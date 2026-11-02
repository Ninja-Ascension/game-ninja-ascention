----------------------------------------------------------------------------------------------------
-- 说明：点击可以巡逻的领地
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MineManagerAddPerson = class("MineManagerAddPersonClass", Window)
    
function MineManagerAddPerson:ctor()
    self.super:ctor()
	app.load("client.campaign.mine.MineAttackTerritoryRole")
	app.load("client.campaign.mine.MineManagerPatrolPrompt")
	
	
    self.roots = {}
	self.ship = nil	--武将实例
	self.status = 1	--巡逻收益状态
	self.times = 0	--巡逻时常
	self.cityID = nil	--领地Id
	self.Mytime = 1
    -- Initialize MineManager page state machine.
    local function init_mine_manager_add_person_terminal()
	
		--返回
		local mine_manager_manager_add_person_back_terminal = {
            _name = "mine_manager_manager_add_person_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local mine_manager_manager_add_person_start_terminal = {
            _name = "mine_manager_manager_add_person_start",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				instance.send_myId = params._datas._myId
				instance.send_ship = params._datas._ship
				
				-- 提示 是否 开始巡逻
				instance:promptStartPatrol()
	
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local mine_manager_manager_add_person_start_go_patrol_terminal = {
            _name = "mine_manager_manager_add_person_start_go_patrol",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			
				local function responseStartCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- 处理掉 当前城池的状态

						state_machine.excute("mine_manager_update_activity", 0, nil) 
						if response.node ~= nil and response.node.roots ~= nil then 
							response.node:startPatrolAnimation()
						end
					end
				end
				protocol_command.manor_patrol.param_list = instance.send_ship.ship_id .. "\r\n" 
						.. instance.send_myId .. "\r\n" 
						.. instance.Mytime .. "\r\n" 
						.. instance.status
				NetworkManager:register(protocol_command.manor_patrol.code, nil, nil, nil, instance, responseStartCallback,false)
                
				--instance:startPatrolAnimation()
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local mine_manager_manager_choose_patrol_status_terminal = {
            _name = "mine_manager_manager_choose_patrol_status",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--巡逻收益状态
				local cell = MineManagerChooseStatus:createCell()
				fwin:open(cell, fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local mine_manager_manager_patrol_status_back_terminal = {
            _name = "mine_manager_manager_patrol_status_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--巡逻收益状态
				instance.status = params._datas._time
				if instance.status == 1 then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Text_9"):setString(tipStringInfo_mine_info[23][1])
				elseif instance.status == 2 then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Text_9"):setString(tipStringInfo_mine_info[23][2])
				elseif instance.status == 3 then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Text_9"):setString(tipStringInfo_mine_info[23][3])
				end
				instance:changeRank()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local mine_manager_manager_choose_times_terminal = {
            _name = "mine_manager_manager_choose_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--选择巡逻时常
				instance:changeRank(params._datas._time)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(mine_manager_manager_add_person_start_go_patrol_terminal)
		state_machine.add(mine_manager_manager_add_person_back_terminal)
		state_machine.add(mine_manager_manager_add_person_start_terminal)
		state_machine.add(mine_manager_manager_choose_patrol_status_terminal)
		state_machine.add(mine_manager_manager_choose_times_terminal)
		state_machine.add(mine_manager_manager_patrol_status_back_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_mine_manager_add_person_terminal()
end

-- window_close 巡逻消失动画
function MineManagerAddPerson:startPatrolAnimation()

	self.button_23:setTouchEnabled(false)
	self.button_xl_21:setTouchEnabled(false)
	self.button_23:setBright(false)
	self.button_xl_21:setBright(false)
	
	self.qipao:setString(tipStringInfo_mine_info[19])
	
	self._role_action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()

        if str == "window_close_over" then
        
			local cell = MineManagerPatrol:createCell()
			cell:init(self.send_myId)
			fwin:open(cell, fwin._view)
			fwin:close(self)
			
        end
    end)
	self._role_action:play("window_close", false)
	
end

function MineManagerAddPerson:promptStartPatrol()
	
	--检查 弹药
	-- local config = zstring.split(dms.string(dms["pirates_config"], 278, pirates_config.param), ",")
	-- local ammo = tonumber(config[self.Mytime])

	-- 根据状态,查找需要的资源
	
	if self.status == 1 then
			
		if tonumber(_ED.user_info.endurance) < self.ammo then
			-- 提示弹药不足
			-- 提示购买
			local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
			local mid = tonumber(config[16])
			app.load("client.cells.prop.prop_buy_prompt")
			local win = PropBuyPrompt:new()
			win:init(mid,4)
			fwin:open(win, fwin._ui)
			
			return
		end
	
	else
	
		if self.ammo > zstring.tonumber(_ED.user_info.user_gold) then
			-- 提示宝石不足,去充值
			-- 提示购买
			state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
			{
				terminal_name = "shortcut_open_recharge_window", 
				terminal_state = 0, 
				_msg = _string_piece_info[273], 
				_datas= 
				{

				}
			})
			
			return
		end
	
	end
	
	--- 提示巡逻时长确认
	local view = MineManagerPatrolPrompt:createCell()
	-- 精力数, 巡逻时间长, 巡逻类型
	view:init(self.ammo,self.times, self.status )
	fwin:open(view,fwin._windows)
end

--道具
function MineManagerAddPerson:getItemCell(mid,mtype,count,isCertainly)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.isShowName = false
	cellConfig.isDebris = true
	cellConfig.mouldType = mtype
	cellConfig.touchShowType = 1
	cellConfig.count = count
	cellConfig.isCertainly = isCertainly
	cell:init(cellConfig)
	return cell
end

function MineManagerAddPerson:getCityBackGroundImage(index)
	local img = "images/ui/play/minemanager/bg_%d.jpg"
	return string.format(img,index)
end

function MineManagerAddPerson:getColor(i)
	return cc.c3b(color_Type[i][1],
		color_Type[i][2],
		color_Type[i][3])

end


function MineManagerAddPerson:changeRank(_time)
	
	if  nil == tonumber(_time) then
		_time = self.Mytime
	end

	ccui.Helper:seekWidgetByName(self.roots[1], "Image_gou_1"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1], "Image_gou_2"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1], "Image_gou_3"):setVisible(false)
	
	ccui.Helper:seekWidgetByName(self.roots[1], "Image_6"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1], "Image_8"):setVisible(false)
	
	
	local config = zstring.split(dms.string(dms["pirates_config"], 278, pirates_config.param), ",")
	local gemConfig = zstring.split(dms.string(dms["pirates_config"], 279, pirates_config.param), ",")
	local ammo = 0 
	
	local vip4 = zstring.tonumber(gemConfig[1])
	local vip8 = zstring.tonumber(gemConfig[2])
	
	local map = {}
	map[1] = config
	map[2] = {vip4*1,vip4*2,vip4*3}
	map[3] = {vip8*1,vip8*2,vip8*3}

	if self.status == 1 then
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_8"):setVisible(true)
	elseif self.status == 2 then
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_6"):setVisible(true)
	elseif self.status == 3 then
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_6"):setVisible(true)
	end
	
	if _time == 1 then
		self.Mytime = 1
		self.times = 4
		
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_gou_1"):setVisible(true)
		ammo = tonumber(map[self.status][self.Mytime])
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_210"):setString(ammo)
		
		local list = self.debrisList[1]
		self:updateHeroIconCount(list[1],list[2])
	elseif _time == 2 then
		self.Mytime = 2
		self.times = 8
		
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_gou_2"):setVisible(true)
		ammo = tonumber(map[self.status][self.Mytime])
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_210"):setString(ammo)
		
		local list = self.debrisList[2]
		self:updateHeroIconCount(list[1],list[2])
	elseif _time == 3 then
		self.Mytime = 3
		self.times = 12
		
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_gou_3"):setVisible(true)
		ammo = tonumber(map[self.status][self.Mytime])
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_210"):setString(ammo)
		
		
		local list = self.debrisList[3]
		self:updateHeroIconCount(list[1],list[2])
	end
	
	self.ammo = ammo
end

function MineManagerAddPerson:updateHeroIconCount(countA,countB)
	local count = ""
	if countA ~= countB then
		count = "("..countA .. "~" .. countB..")"
	else
		count = countA
	end
	self.propMouldCell:updateIconCount(count)
end

function MineManagerAddPerson:ergodicPropTemplate(ship_base_template_id)
	--遍历 道具模板,找 use_of_ship 匹配
	local data = dms["prop_mould"]
	for i,v in ipairs (data) do
		local prop_mould_id = i
		local storage_page_index = dms.int(data, prop_mould_id, prop_mould.storage_page_index) 
		if storage_page_index == 5 then
			local use_of_ship = dms.int(data, prop_mould_id, prop_mould.use_of_ship) 
			if ship_base_template_id == use_of_ship then
				return prop_mould_id
			end
		end
	end
	return nil
end

function MineManagerAddPerson:onUpdateDraw()
	local root = self.roots[1]
	local heroName = ccui.Helper:seekWidgetByName(root, "Text_26")			--选择武将上阵名称
	local heroGet = ccui.Helper:seekWidgetByName(root, "Text_28")			--选择武将上阵额外获得
	local energy = ccui.Helper:seekWidgetByName(root, "Text_210")			--消耗精力
	local npcPanel = ccui.Helper:seekWidgetByName(root, "Panel_r_in_3")			--武将图片
	
	local shipName = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship_evo = zstring.split(self.ship.evolution_status, "|")
		local evo_mould_id = evo_info[tonumber(ship_evo[1])]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		shipName = word_info[3]
	else
		shipName = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_name)
	end

	heroName:setString(shipName)
	heroGet:setString(shipName .. _string_piece_info[63])
	
	local quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type)+1
	heroName:setColor(self:getColor(quality))
	heroGet:setColor(self:getColor(quality))
	
	--  1,1-1|2,1-2|3,2-3
	local debrisCount = dms.string(dms["manor_mould"], self.cityID, manor_mould.debris_count)
	local debris = zstring.split(debrisCount,"|")
	self.debrisList = {}
	for i = 1, table.getn(debris) do
		local arr = zstring.split(debris[i],",")
		
		local arrJV = zstring.split(arr[2],"-")
		arrJV[1] = tonumber(arrJV[1])
		arrJV[2] = tonumber(arrJV[2])
		table.insert(self.debrisList, arrJV)
	end
	
	
	--- Panel_dispatch
	self.panel_dispatch = ccui.Helper:seekWidgetByName(root, "Panel_dispatch")
	
	local bgPanel = ccui.Helper:seekWidgetByName(root, "Panel_30")
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_8")

	-- 设置城池背景-------------------------------------------------------------------------------
	bgPanel:setBackGroundImage(self:getCityBackGroundImage(self.cityID))
	
	-- 设置城池名称-------------------------------------------------------------------------------
	local cityName = dms.string(dms["manor_mould"], self.cityID, manor_mould.manor_name)
	nameText:setString(cityName)

	-- 设置守将形象-------------------------------------------------------------------------------
	npcPanel:addChild(self:createRole(tonumber(self.ship.ship_template_id)))
	self._role_action:play("window_open", false)

	ccui.Helper:seekWidgetByName(root, "Text_name_7_4"):setString(shipName)
	self.qipao = ccui.Helper:seekWidgetByName(root, "Text_486_2")
	self.qipao:setString(tipStringInfo_mine_info[20])
	--dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.sign_msg)

	-- 设置胜利奖励-------------------------------------------------------------------------------
	local listViewProp = ccui.Helper:seekWidgetByName(root, "ListView_21")
	
	local winnerId = dms.string(dms["manor_mould"], self.cityID, manor_mould.win_reward)

	local reward_gold = dms.int(dms["scene_reward"], winnerId, scene_reward.reward_gold)

	local library = dms.string(dms["scene_reward"], winnerId, scene_reward.reward_prop)

	local rewardProp = zstring.split(library,"|")

	-- if reward_gold> 0 then
		-- local rewardGoldCell = self:getPropCell(-1,reward_gold,2)
		-- rewardListView:addChild(rewardGoldCell)
	-- end

	-- for i,v in pairs(rewardProp) do
	
		-- local rewardPropInfo = zstring.split(v, ",")
		-- if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
			-- local reawrdID = tonumber(rewardPropInfo[2])
			-- local rewardNum = tonumber(rewardPropInfo[1])
			-- local cell = self:getPropCell(reawrdID,rewardNum,6)
			-- rewardListView:addChild(cell)
		-- end
	-- end	
	
	-- 当前武将 碎片
	local propMouldID = self:ergodicPropTemplate(tonumber(self.ship.ship_base_template_id))
	local cell = self:getItemCell(propMouldID,6,"(1~3)",true)
	listViewProp:addChild(cell)
	self.propMouldCell = cell

	-- 最大金币
	local dropMaxGold = dms.int(dms["manor_mould"], self.cityID, manor_mould.drop_max_gold)
	local dropMaxGoldCell = self:getItemCell(-1,2,dropMaxGold)
	listViewProp:addChild(dropMaxGoldCell)
	
	-- 最大银币
	local dropMaxSilver = dms.int(dms["manor_mould"], self.cityID, manor_mould.drop_max_silver)
	local dropMaxSilverCell = self:getItemCell(-1,1,dropMaxSilver)
	listViewProp:addChild(dropMaxSilverCell)
	
	-- 可获得武将
	local dropShip = zstring.split(dms.string(dms["manor_mould"], self.cityID, manor_mould.drop_ship), ",")
	for i,v in  ipairs (dropShip) do
		local cell = self:getItemCell(tonumber(v),13,1)
		listViewProp:addChild(cell)
	end
	
	-- 可获得道具
	local dropProp = zstring.split(dms.string(dms["manor_mould"], self.cityID, manor_mould.drop_prop), "|")
	for i,v in  ipairs (dropProp) do
		local item = zstring.split(v, ",")
		local mid = tonumber(item[2])
		local mtype = tonumber(item[1])
		local cell = self:getItemCell(mid,mtype)
		listViewProp:addChild(cell)
	end

end

function MineManagerAddPerson:onEnterTransitionFinish()

    local csbMineManagerAddPerson = csb.createNode("campaign/MineManager/attack_territory_dispatch.csb")
	local action = csb.createTimeline("campaign/MineManager/attack_territory_dispatch.csb")
    csbMineManagerAddPerson:runAction(action)
	self._role_action = action
	self:addChild(csbMineManagerAddPerson)
	
   	local root = csbMineManagerAddPerson:getChildByName("root")
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_in_bc"), nil, 
	{
		func_string = [[state_machine.excute("mine_manager_manager_add_person_back", 0, "mine_manager_manager_add_person_back.'")]],
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	--开始巡逻
	self.button_xl_21 = ccui.Helper:seekWidgetByName(root, "Button_xl_21")
	fwin:addTouchEventListener(self.button_xl_21, nil, 
	{
		terminal_name = "mine_manager_manager_add_person_start", 
		terminal_state = 0, 
		_ship = self.ship,
		_myId = self.cityID,
		_instance = self,
		isPressedActionEnabled = true
	}, nil, 0)
	
	
	-- Button_23 选择巡逻状态
	self.button_23 = ccui.Helper:seekWidgetByName(root, "Button_23")
	fwin:addTouchEventListener(self.button_23, nil, 
	{
		func_string = [[state_machine.excute("mine_manager_manager_choose_patrol_status", 0, "mine_manager_manager_choose_patrol_status.'")]],
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	self:onUpdateDraw()
	self:changeRank(1)
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_9"):setString(tipStringInfo_mine_info[23][1])
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"), nil, 
	{
		terminal_name = "mine_manager_manager_choose_times", 
		_time = 1,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_14"), nil, 
	{
		terminal_name = "mine_manager_manager_choose_times", 
		_time = 2,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_15"), nil, 
	{
		terminal_name = "mine_manager_manager_choose_times", 
		_time = 3,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	state_machine.excute("mine_manager_manager_choose_times", 0, {_datas = {_time = 1}})
	
	
	local userinfo = EquipPlayerInfomation:new()
	fwin:open(userinfo,fwin._view)
	self.userinfo = userinfo
	
end

function MineManagerAddPerson:init(ship,id)
	self.ship = ship
	self.cityID = tonumber(id)
end

function MineManagerAddPerson:onExit()

	state_machine.remove("mine_manager_manager_add_person_start_go_patrol")
	state_machine.remove("mine_manager_manager_add_person_back")
	state_machine.remove("mine_manager_manager_add_person_start")
	state_machine.remove("mine_manager_manager_choose_patrol_status")
	state_machine.remove("mine_manager_manager_choose_times")
	state_machine.remove("mine_manager_manager_patrol_status_back")
end

function MineManagerAddPerson:createCell()
	local cell = MineManagerAddPerson:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function MineManagerAddPerson:createRole(mid)
	fwin:close(self.userinfo)

	local cell = MineAttackTerritoryRole:createCell()
	cell:initShip(mid)
	return cell
end
