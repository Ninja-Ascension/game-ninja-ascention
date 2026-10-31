----------------------------------------------------------------------------------------------------
-- 说明：抢夺列表条绘制
-------------------------------------------------------------------------------------------------------
PlunderListCell = class("PlunderListCellClass", Window)

function PlunderListCell:ctor()
    self.super:ctor()
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.utils.scene.SceneCacheData")
	app.load("client.utils.ConfirmTip")
    -- 定义封装类中的变量
	self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.snatchListing = nil		-- 当前要绘制的一系列信息
	self.propMould = nil		-- 当前要绘制的道具mould
	self.equipmentMould = nil	-- 抢夺对应的宝物id
	self.grabTankLink = nil		-- 抢夺对应的宝物id对应的抢夺表
	self.isNPC = false --当前是否为npc
	local function init_plunder_list_cell_terminal()
		-- 抢夺一次
		local plunder_list_cell_plunder_one_terminal = {
            _name = "plunder_list_cell_plunder_one",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print("抢夺........................")
				local cell = params._datas.cell
				cell:checkupFightCD(1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 5次
		local plunder_list_cell_plunder_five_terminal = {
            _name = "plunder_list_cell_plunder_five",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print("抢夺........................5")
				local cell = params._datas.cell
				cell:checkupFightCD(5)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		
		state_machine.add(plunder_list_cell_plunder_five_terminal)
		state_machine.add(plunder_list_cell_plunder_one_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_plunder_list_cell_terminal()
end


function PlunderListCell:showConfirmTip(n)
	if n == 0 then
		-- yes
		self:sendFight()
	else
		-- no
	end
end
	
function PlunderListCell:checkupFightCD(n)
	self.sendFightType = n
	-- 1代表普通抢夺 
	-- 5代表5次抢夺
	if getAvoidFightTime() > 0  and true ~= self.isNPC then
		local tip = ConfirmTip:new()
		tip:init(self, self.showConfirmTip, tipStringInfo_plunder[6])
		fwin:open(tip,fwin._ui)
	else
		self:sendFight()
	end
end

function PlunderListCell:getEnduranceMID()

	local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
	
	return tonumber(config[16])

end

function PlunderListCell:sendFight()
	-- 判定体力
	if tonumber(_ED.user_info.endurance) < 2 then
		app.load("client.cells.prop.prop_buy_prompt")
		local win = PropBuyPrompt:new()
		win:init(self:getEnduranceMID(), 2)
		fwin:open(win, fwin._ui)
		return
	end

	if self.sendFightType == 1 then
			self:oneFight()
		elseif self.sendFightType == 5 then
			self:fiveFight()
	end
	self.sendFightType = nil
end

function PlunderListCell:oneFight()
	local cell = self
	local function responsePlunderCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			--> print("抢夺进来了")
			
			-----------记录当前场景缓存数据
			local cacheName = SceneCacheNameEnum.PLUNDER
			local cacheData = SceneCacheData.read(cacheName)
			if nil == cacheData then
				cacheData = SceneCacheData.getInitExample(cacheName)
			end
			cacheData.isWin = 1
			SceneCacheData.write(SceneCacheNameEnum.PLUNDER, cacheData)

			state_machine.excute("plunder_list_close_from_challenge", 0, {})

			-- 打开战斗
			app.load("client.battle.BattleStartEffect")
			app.load("client.battle.fight.FightEnum")

			local bse = BattleStartEffect:new()
			bse:init(_enum_fight_type._fight_type_10)
			fwin:open(bse, fwin._windows)
			
		end
	end
	

	
	local function launchBattle()

		if nil ~= NetworkManager:find(protocol_command.grab_launch.code) then
			return
		end
	
		local str = ""..cell.snatchListing.snatch_object_type.."\r\n"..cell.snatchListing.snatch_object_id
		str = str.."\r\n"..cell.propMould.."\r\n"..cell.grabTankLink
		protocol_command.grab_launch.param_list = str
		NetworkManager:register(protocol_command.grab_launch.code, nil, nil, nil, nil, responsePlunderCallback, false, nil)
	end
	
	if self.isNPC == false then
		
		if missionIsOver() == false then
			launchBattle()
		else
			if __lua_project_id == __lua_project_warship_girl_a 
			or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_koone
			then
				local function responseCampPreferenceCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
						if _ED.camp_preference_info ~= nil and _ED.camp_preference_info.count > 0 then
							app.load("client.formation.FormationChangeMakeWar") 
							
							local makeWar = FormationChangeMakeWar:new()
							
							makeWar:init(launchBattle)
							
							fwin:open(makeWar, fwin._ui)
						else
							launchBattle()
						end
					end
				end
				_ED._battle_init_type = "1"
				local rid = cell.snatchListing.snatch_object_id
				protocol_command.camp_preference.param_list = ""..rid.."\r\n".."0"
				NetworkManager:register(protocol_command.camp_preference.code, nil, nil, nil, nil, responseCampPreferenceCallback, false, nil)
			else
				launchBattle()
			end
		end
	else
		launchBattle()
	end
end


function PlunderListCell:fiveFight()
	local cell = self
	
	local propMould = cell.propMould
	--> print("我要抢夺的道具id--1----------------------",propMould)

	local function responsePlunderCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			--> print("抢夺进来了5")
			-----------当前场景缓存数据
			local cacheName = SceneCacheNameEnum.PLUNDER
			local cacheData = SceneCacheData.read(cacheName)
			if nil == cacheData then
				cacheData = SceneCacheData.getInitExample(cacheName)
			end
			cacheData.isWin = 5
			SceneCacheData.write(SceneCacheNameEnum.PLUNDER, cacheData)

			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			else
				state_machine.excute("plunder_list_close_from_challenge", 0, {})
			end
			
			--> print("我要去抢夺的道具id-2--------------------",propMould)

			app.load("client.campaign.plunder.PlunderSpoilsReport")
			local win = PlunderSpoilsReport:new()
			win:init(propMould)
			fwin:open(win, fwin._ui)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				if zstring.tonumber(_ED.user_info.last_user_grade) ~= zstring.tonumber(_ED.user_info.user_grade) then
					local wind = fwin:find("BattleLevelUpClass")
					if wind ~= nil then
						fwin:close(wind)
					end
					app.load("client.battle.BattleLevelUp")
					fwin:open(BattleLevelUp:new(), fwin._windows) 
					_ED.user_info.last_user_grade = _ED.user_info.user_grade
				end
			end
		end
	end
	str = ""..cell.snatchListing.snatch_object_type.."\r\n"..cell.snatchListing.snatch_object_id
	str = str.."\r\n"..cell.propMould.."\r\n"..cell.grabTankLink
	--> print("参数-2-------------",str)
	protocol_command.grab_launch_ten.param_list = str
	NetworkManager:register(protocol_command.grab_launch_ten.code, nil, nil, nil, nil, responsePlunderCallback, false, nil)
end

function PlunderListCell:onUpdateDraw()
	-- 名称  等级  概率
	-- local probability = ""
	-- for i = 1, #plunder_probability do
		-- if plunder_probability[i][1] == zstring.tonumber(self.snatchListing.object_probability) then
			-- probability = plunder_probability[i][2]
			-- break
		-- end
	-- end
	if self.snatchListing == nil then 
		return
	end
	local probabilityColor = {
		{255,0,255},
		{0,147,239},
		{0,147,239},
		{0,255,40},
		{0,255,40},
		{0,255,40},
	}
	
	local function probabilityType(number)
		local pType = 6
		if number>=401 then
			pType = 1
		elseif number <=400 and number>=300 then
			pType = 2
		elseif number <=299 and number >=250 then
			pType = 3
		elseif number <=249 and number >=200 then
			pType = 4
		elseif number <=199 and number >=130 then
			pType = 5
		elseif number<=129 then
			pType = 6
		end
		return pType
	end
	
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local Label_name = ccui.Helper:seekWidgetByName(self.roots[1], "Label_name")
	Label_name:setString(self.snatchListing.object_name)
	
	if verifySupportLanguage(_lua_release_language_en) == true then
		ccui.Helper:seekWidgetByName(self.roots[1], "Label_3205_lv"):setString(tipStringInfo_plunder[3]..self.snatchListing.object_level)
	else
		ccui.Helper:seekWidgetByName(self.roots[1], "Label_3205_lv"):setString(self.snatchListing.object_level..tipStringInfo_plunder[3])
	end
	local probabilityTypes = probabilityType(tonumber(self.snatchListing.object_probability))
	ccui.Helper:seekWidgetByName(self.roots[1], "Label_3207_1"):setColor(cc.c3b(probabilityColor[probabilityTypes][1],probabilityColor[probabilityTypes][2],probabilityColor[probabilityTypes][3]))	
	ccui.Helper:seekWidgetByName(self.roots[1], "Label_3207_1"):setString( _probabilityName[probabilityTypes])
	
	
	local mid = nil
	local quality = nil

	-- 抢夺对象是玩家还是NPC
	local player	= ccui.Helper:seekWidgetByName(self.roots[1], "Panel_58374")
	local npc 		= ccui.Helper:seekWidgetByName(self.roots[1], "Button_3213")
	self.headList:removeAllChildren(true)
	if zstring.tonumber(self.snatchListing.snatch_object_type) == 0 then
		
		self.isNPC = true
		
		if -1 ~= tonumber(self.snatchListing.object_icon1) then
			self.headList:addChild(self:createShipHeadCellNPC(zstring.tonumber(self.snatchListing.object_icon1)))
			
			mid = zstring.tonumber(self.snatchListing.object_icon1)
			quality = dms.int(dms["environment_ship"], mid, environment_ship.ship_type)+1
		end
		if -1 ~= tonumber(self.snatchListing.object_icon2) then
			self.headList:addChild(self:createShipHeadCellNPC(zstring.tonumber(self.snatchListing.object_icon2)))
		end
		if -1 ~= tonumber(self.snatchListing.object_icon3) then
			self.headList:addChild(self:createShipHeadCellNPC(zstring.tonumber(self.snatchListing.object_icon3)))
		end
		
		self:showFive()
	elseif zstring.tonumber(self.snatchListing.snatch_object_type) == 1 then
		
		self.isNPC = false
		
		if -1 ~= tonumber(self.snatchListing.object_icon1) then
			self.headList:addChild(self:createShipHeadCell(zstring.tonumber(self.snatchListing.object_icon1)))
			
			mid = zstring.tonumber(self.snatchListing.object_icon1)
			quality = dms.int(dms["ship_mould"], mid, ship_mould.ship_type)+1
		end
		if -1 ~= tonumber(self.snatchListing.object_icon2) then
			self.headList:addChild(self:createShipHeadCell(zstring.tonumber(self.snatchListing.object_icon2)))
		end
		if -1 ~= tonumber(self.snatchListing.object_icon3) then
			self.headList:addChild(self:createShipHeadCell(zstring.tonumber(self.snatchListing.object_icon3)))
		end
		
		self:showOne()
	end
	
	-- snatch_object_type ="",				--抢夺对象类型(0:npc 1:玩家)
	-- snatch_object_id ="",				--抢夺对象id 
	-- snatch_object_hero_id ="",			--抢夺对象头像id 
	-- object_level ="",					--对象等级
	-- object_name ="",						--对象名称
	-- object_probability ="",				--对象概率
	-- object_icon1 ="",					--对象头像1
	-- object_icon2 ="",					--对象头像2
	-- object_icon3 ="",					--对象头像3

	Label_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))	
	
	-- plunder_five = { -- 哪种概率时显示抢5次
	-- {2, 500}, 	--蓝色品质时需要这么多
	-- {3, 250},	--紫色品质时需要这么多
	-- {4, 150},	--橙色品质时需要这么多
	-- }
	
	--判断 显示抢5次
	--用宝物的品质
	
	-- local treasureQuality =  dms.int(dms["prop_mould"], self.propMould, prop_mould.prop_quality)
	-- local isFive = false
	-- for i = 1, table.getn(plunder_five) do
		-- local item = plunder_five[i]
		-- if item[1] == treasureQuality then
			-- if item[2] == zstring.tonumber(self.snatchListing.object_probability) then
				-- isFive = true
				-- break 
			-- end
		-- end
	-- end
end

function PlunderListCell:createShipHeadCell(mouldId)
	local cell = ShipHeadCell:createCell()
	cell:init(nil, 12, mouldId)
	return cell
end

function PlunderListCell:createShipHeadCellNPC(mouldId)	
	local cell = ShipHeadCell:createCell()
	local ship = cell:constructionShipFromNPC(mouldId)
	cell:init(ship, 11)
	return cell
end

function PlunderListCell:showOne()	
	self.panel_five:setVisible(false)
	self.button_one:setVisible(true)
	
	fwin:addTouchEventListener(self.button_one, nil, 
	{
		terminal_name = "plunder_list_cell_plunder_one", 
		terminal_state = self.isPlunder,
		cell = self,
		isPressedActionEnabled = true,
	},
	nil, 0)	
end

function PlunderListCell:showFive()	
	self.panel_five:setVisible(true)
	self.button_one:setVisible(false)
	
	fwin:addTouchEventListener(self.button_five_one, nil, 
	{
		terminal_name = "plunder_list_cell_plunder_one", 
		terminal_state = self.isPlunder,
		cell = self,
		isPressedActionEnabled = true,
	},
	nil, 0)	
	
	fwin:addTouchEventListener(self.button_five, nil, 
	{
		terminal_name = "plunder_list_cell_plunder_five", 
		terminal_state = self.isPlunder,
		cell = self,
		isPressedActionEnabled = true,
	},
	nil, 0)	
	
end

function PlunderListCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("campaign/Snatch/indiana_list.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	self:setContentSize(ccui.Helper:seekWidgetByName(root, "Panel_3201"):getContentSize())
	table.insert(self.roots, root)
	
	-- 列表控件动画播放
	local action = csb.createTimeline("campaign/Snatch/indiana_list.csb")
    root:runAction(action)
    action:play("list_view_cell_open", false)
	
	self.headList = ccui.Helper:seekWidgetByName(root, "ListView_1")
	
	self.button_one = ccui.Helper:seekWidgetByName(self.roots[1], "Button_3213")
	
	self.button_five_one = ccui.Helper:seekWidgetByName(self.roots[1], "Button_3214")
	
	self.button_five = ccui.Helper:seekWidgetByName(self.roots[1], "Button_3215")
	
	self.panel_five = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_58374")

	self:onUpdateDraw()
end

function PlunderListCell:onExit()
	state_machine.remove("plunder_list_cell_plunder_one")
	state_machine.remove("plunder_list_cell_plunder_five")
end

function PlunderListCell:init(snatchListing, propMould, equipmentMould, grabTankLink)
	self.snatchListing = snatchListing
	self.propMould = propMould				-- 当前要绘制的道具mould
	self.equipmentMould = equipmentMould	-- 抢夺对应的宝物id
	self.grabTankLink = grabTankLink		-- 抢夺对应的宝物id对应的抢夺表
end

function PlunderListCell:createCell()
	local cell = PlunderListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

