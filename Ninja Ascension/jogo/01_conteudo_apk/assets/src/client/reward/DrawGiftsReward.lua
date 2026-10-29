-- ----------------------------------------------------------------------------------------------------
-- 说明：奖励绘制（上飘消失，最多只显示3个物品）
-- ----------------------------------------------------------------------------------------------------
DrawGiftsReward = class("DrawGiftsRewardClass", Window)

function DrawGiftsReward:ctor()
    self.super:ctor()
    
	self.roots = {}
	self.actions = {}
	
	self._bAnimateEnd = false
	
	self._rewardType = nil
	self._rewardInfo = nil
	 
    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.prop.prop_money_icon")
    app.load("client.cells.prop.prop_money_info")
	
    -- Initialize DrawGiftsReward page state machine.
    local function init_gifts_reward_terminal()
		local gifts_reward_close_terminal = {
            _name = "gifts_reward_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if instance ~= nil and instance._bAnimateEnd == true then
					local action = self.actions[1]
					action:play("window_close", false)
					action:setFrameEventCallFunc(function (frame)
						if nil == frame then
							return
						end

						local str = frame:getEvent()
						if str == "window_close_over" then
							fwin:close(instance)
						end
					end)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(gifts_reward_close_terminal)
        state_machine.init()
    end
    
    init_gifts_reward_terminal()
end

function DrawGiftsReward:onEnterTransitionFinish()
	local csbDrawGiftsReward = csb.createNode("utils/congratulations_to_btain_1.csb")
	self:addChild(csbDrawGiftsReward)
	local root = csbDrawGiftsReward:getChildByName("root")
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("utils/congratulations_to_btain_1.csb")
	table.insert(self.actions, action)
	
    csbDrawGiftsReward:runAction(action)
    action:play("window_open", false)
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_open_over" then
			self._bAnimateEnd = true	
        end
    end)
   
	local function calculateIconType(number)
		local iconid = 3009
		if number >=1 and number<=9999 then
			iconid = 3009
		elseif number>=10000 and number<=99999 then
			iconid = 3011
		elseif number >=100000 then
			iconid = 3013
		end
		return iconid
	end
    local nameCell = {}
	local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_3")
	rewardListView:removeAllItems()
   	local rewardInfo = nil
	if self._rewardInfo == nil then
		rewardInfo = getSceneReward(self._rewardType == nil and 0 or self._rewardType) 
	else
		rewardInfo = self._rewardInfo
	end
	
	for i=1, tonumber(rewardInfo.show_reward_item_count) do
		local flag = false
		local rewardList = rewardInfo.show_reward_list[i]
		local id = rewardList.prop_item
		-- 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 
		-- 11:上阵人数 12:体力 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气18威名 19 日常任务积分 20功勋 21战功)
		--如果有钱
		if tonumber(rewardList.prop_type) == 1 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			rewardListView:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			local name = _All_tip_string_info._fundName
			local quality = 1
			nameCell[i] = cell:getName()
			nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			nameCell[i]:setString(name)
		end
		--如果有宝石
		if tonumber(rewardList.prop_type) == 2 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			rewardListView:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			local name = _All_tip_string_info._crystalName
			local quality = 5
			nameCell[i] = cell:getName()
			nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			nameCell[i]:setString(name)
		end
		
		--如果有魂玉
		if tonumber(rewardList.prop_type) == 5 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			rewardListView:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			local name = _All_tip_string_info._soulName
			local quality = 5
			nameCell[i] = cell:getName()
			nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			nameCell[i]:setString(name)
		end		
		--道具
		if tonumber(rewardList.prop_type) == 6 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
			rewardListView:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			nameCell[i] = cell:getName()
			local name = dms.string(dms["prop_mould"], id, prop_mould.prop_name)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        name = setThePropsIcon(id)[2]
		    end
			local quality = dms.int(dms["prop_mould"], id, prop_mould.prop_quality) + 1
			nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			nameCell[i]:setString(name)
		end	
		--装备
		if tonumber(rewardList.prop_type) == 7 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
			rewardListView:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			nameCell[i] = cell:getName()
			local name = dms.string(dms["equipment_mould"], id, equipment_mould.equipment_name)
			local quality = dms.int(dms["equipment_mould"], id, equipment_mould.grow_level) + 1
			nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			nameCell[i]:setString(name)
		end	
		--武将
		if tonumber(rewardList.prop_type) == 13 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item)
			rewardListView:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			nameCell[i] = cell:getName()
			local name = nil
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        --进化形象
		        local evo_image = dms.string(dms["ship_mould"], id, ship_mould.fitSkillTwo)
		        local evo_info = zstring.split(evo_image, ",")
		        --进化模板id
		        -- local ship_evo = zstring.split(self.ship.evolution_status, "|")
		        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], id, ship_mould.captain_name)]
		        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		        local word_info = dms.element(dms["word_mould"], name_mould_id)
        		name = word_info[3]
		    else 
				name = dms.string(dms["ship_mould"], id, ship_mould.captain_name)
			end

			local quality = dms.int(dms["ship_mould"], id, ship_mould.ship_type) + 1
			nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			nameCell[i]:setString(name)
		end	
		--威名
		if tonumber(rewardList.prop_type) == 18 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			rewardListView:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			nameCell[i] = cell:getName()
			local quality = 1
			local name = _All_tip_string_info._glories
			nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			nameCell[i]:setString(name)
		end	
		--声望
		if tonumber(rewardList.prop_type) == 3 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			rewardListView:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			nameCell[i] = cell:getName()
			local quality = 4
			local name = _All_tip_string_info._reputation
			nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			nameCell[i]:setString(name)
		end	
		--体力
		if tonumber(rewardList.prop_type) == 12 and tonumber(rewardList.item_value) > 0 and flag == false then
			local cell = ResourcesIconCell:createCell()
			cell:init(rewardList.prop_type, tonumber(rewardList.item_value),-1)
			rewardListView:addChild(cell)
			cell.roots[1]:setPositionY(cell.roots[1]:getPositionY() + 20)
			flag = true
			nameCell[i] = cell:getName()
			local quality = 5
			local name = _All_tip_string_info._energyName
			nameCell[i]:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
			nameCell[i]:setString(name)
		end	
	end	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local tpx=120--每个奖励框大小
		local x= rewardListView:getContentSize().width
		local _tables=rewardListView:getItems()
		local rewardTotal = #_tables
		for i, v in pairs(_tables) do
			tpx=v.roots[1]:getContentSize().width
			v.roots[1]:setPositionX(v.roots[1]:getPositionX()+(x-tpx*rewardTotal-10*(rewardTotal-1))/2) --10为子控件间距
		end
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
	{
		terminal_name = "gifts_reward_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
	},
	nil,0)
end

function DrawGiftsReward:onExit()
	state_machine.remove("gifts_reward_close")
end

function DrawGiftsReward:init(_rewardType, _rewardInfo)
	self._rewardType = _rewardType
	self._rewardInfo = _rewardInfo
end
