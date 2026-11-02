FightRewardForDailyActivityCopy = class("FightRewardForDailyActivityCopyClass", Window)

function FightRewardForDailyActivityCopy:ctor()
    self.super:ctor()
    self.roots = {}

    self.copyId = _ED._daily_copy_npc_id

    self.num_group = {}
    self.rewards = {
        0, -- base_reward = 0,
        0, -- extra_reward = 0,
        0, -- total_reward = 0,
        0, -- reward_type = 0,
        -1, -- reward_mould_id = 0,
    }
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.utils.resources_icon_cell")
    -- initialize fight reward ror daily activity copy page state machine.
    local function init_fight_reward_ror_daily_activity_copy_terminal()

        local fight_reward_ror_daily_activity_copy_close_terminal = {
            _name = "fight_reward_ror_daily_activity_copy_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED._current_scene_id = 0
                _ED._scene_npc_id = 0
                _ED._current_seat_index = -1
                _ED._npc_difficulty_index = 0
                _ED._npc_addition_params = ""
				fwin:close(instance)
				fwin:close(fwin:find("BattleSceneClass"))
				-- fwin:removeAll()
                
				-- app.load("client.home.Menu")
				-- fwin:open(Menu:new(), fwin._taskbar)
				-- state_machine.excute("menu_manager", 0, 
					-- {
						-- _datas = {
							-- terminal_name = "menu_manager", 	
							-- next_terminal_name = "menu_show_duplicate", 
							-- current_button_name = "Button_duplicate",
							-- but_image = "Image_duplicate", 		
							-- terminal_state = 0, 
							-- isPressedActionEnabled = true
						-- }
					-- }
				-- )
				
                -- state_machine.excute("duplicate_controller_manager", 0, 
                    -- {
                        -- _datas = {
                            -- terminal_name = "duplicate_controller_manager",     
                            -- next_terminal_name = "duplicate_select_daily_activity_copy_panel",      
                            -- current_button_name = "Button_richang",
                            -- but_image = "Image_daily_activity_copy",       
                            -- terminal_state = 0, 
                            -- isPressedActionEnabled = true
                        -- }
                    -- }
                -- )
				
                -- cacher.removeAllObject(_object)
                cacher.removeAllTextures()
                fwin:reset(nil)
				-- fwin:removeAll()
				app.load("client.home.Menu")
				if fwin:find("MenuClass") == nil then
					fwin:open(Menu:new(), fwin._taskbar)
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					state_machine.excute("lduplicate_window_manager", 0, {4})
				else
					-- state_machine.excute("menu_clean_page_state", 0,"") 
					state_machine.excute("menu_manager", 0, 
						{
							_datas = {
								terminal_name = "menu_manager", 	
								next_terminal_name = "menu_show_duplicate_everyday", 
								current_button_name = "Button_duplicate",
								but_image = "Image_duplicate", 		
								terminal_state = 0, 
								isPressedActionEnabled = true
							}
						}
					)
					state_machine.unlock("menu_manager_change_to_page", 0, "")
					if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					else
						--这个地方会使当前的选中ID 默认变成第一个,数码宝贝不要这个
						state_machine.excute("pve_daily_activity_copy_change_to_page", 0, 0)
					end	
                end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(fight_reward_ror_daily_activity_copy_close_terminal)
        state_machine.init()
    end

    -- call func init fight reward ror daily activity copy state machine.
    init_fight_reward_ror_daily_activity_copy_terminal()
end

function FightRewardForDailyActivityCopy:init(_fight_type)
    self._fight_type = _fight_type
    local rewardList = getSceneReward(39)
    for i, v in pairs(rewardList.show_reward_list) do
        if v.prop_type == 15 then -- 伤害值

        elseif v.prop_type == 22 then -- 基础奖励
            self.rewards[1] = v.item_value
        elseif v.prop_type == 23 then -- 额外奖励
            self.rewards[2] = v.item_value
        else -- 物品奖励
            self.rewards[3] = v.item_value
            self.rewards[4] = v.prop_type
            self.rewards[5] = v.prop_item
        end
    end
    return self
end


function FightRewardForDailyActivityCopy:onEnterTransitionFinish()
    local csbFightRewardForDailyActivityCopy = csb.createNode("duplicate/GameActivity/GameActivity_victory.csb")
    local root = csbFightRewardForDailyActivityCopy:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbFightRewardForDailyActivityCopy)

    local elementData = dms.element(dms["daily_instance_mould"], tonumber(self.copyId))
    -- 战斗评价信息
    ccui.Helper:seekWidgetByName(root, "Text_903_86"):setString(dms.atos(elementData, daily_instance_mould.decpict))

    -- 绘制奖励图标
    app.load("client.cells.utils.resources_icon_cell")
    local Panel_12 = ccui.Helper:seekWidgetByName(root, "Panel_12")
    local rewardIcon = nil
    local rewardType = zstring.tonumber(self.rewards[4])
    if rewardType == 6 then
        rewardIcon = PropIconCell:createCell()
        rewardIcon:init(16, self.rewards[5],self.rewards[3])
    elseif rewardType == 7 then
        rewardIcon = EquipIconCell:createCell()
        rewardIcon:init(8, nil, self.rewards[5], nil)
    else
        rewardIcon = ResourcesIconCell:createCell()
        rewardIcon:init(zstring.tonumber(rewardType), -1, -1)
    end
    Panel_12:addChild(rewardIcon)

    -- 添加基础奖励和额外获得的文字信息
    table.insert(self.num_group, ccui.Helper:seekWidgetByName(root, "Text_903_20"))
    table.insert(self.num_group, ccui.Helper:seekWidgetByName(root, "Text_903_30"))

    -- 总共获得的数量
    ccui.Helper:seekWidgetByName(root, "Text_903_1_1_0_0"):setString(""..self.rewards[3])
	
	local action = csb.createTimeline("duplicate/GameActivity/GameActivity_victory.csb")
    csbFightRewardForDailyActivityCopy:runAction(action)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		action:play("window_open_win", false)
	else
		action:gotoFrameAndPlay(0, action:getDuration(), false)
    end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		action:setFrameEventCallFunc(function (frame)
			if nil == frame then
				return
			end

			local str = frame:getEvent()
			if str == "window_open_win_over" then
				--print("window_open_win_over..............")
				local Panel_win_open = ccui.Helper:seekWidgetByName(root, "Panel_win_open")
				local ArmatureNode_4=Panel_win_open:getChildByName("ArmatureNode_4")
				ArmatureNode_4:setVisible(true)
				csb.animationChangeToAction(ArmatureNode_4, 0, 0, nil)
			elseif str == "over" then
				local label1 = self.num_group[1]
				local label2 = self.num_group[2]
				label1:setString(""..self.rewards[1])
				label2:setString(""..(self.rewards[2]))
				--print("over..........")
			end
		end)
		
		local Panel_win_open = ccui.Helper:seekWidgetByName(root, "Panel_win_open")
		local ArmatureNode_4=Panel_win_open:getChildByName("ArmatureNode_4")
		draw.initArmature(ArmatureNode_4, nil, -1, 0, 1)
		ArmatureNode_4:getAnimation():playWithIndex(0, 0, 0)
		ArmatureNode_4:setVisible(false)
		
		ArmatureNode_4._invoke = function(armatureBack)
			--print("armatureBack_over..............")
			armatureBack:setVisible(false)
			action:play("window_open", false)
			armatureBack._invoke=nil
		end
		
	else
		action:setFrameEventCallFunc(function (frame)
			if nil == frame then
				return
			end

			local str = frame:getEvent()
			local pos = string.find(str, "change_num_")
			if pos ~= nil then
				local datas = zstring.split(str, "_")
				local groupIndex = zstring.tonumber(datas[3])
				local frameCount = zstring.tonumber(datas[4])
				local frameIndex = datas[5]
				local label = self.num_group[groupIndex]
				if label ~= nil then
					if frameIndex == "over" then
						label:setString(""..self.rewards[groupIndex])
					else
						frameIndex = zstring.tonumber(frameIndex)
						label:setString(""..(self.rewards[groupIndex] * frameIndex / frameCount))
					end
				end
			end
			
		end)
	end
	
	-- 退出战斗结算界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_7"), nil, 
    {
        terminal_name = "fight_reward_ror_daily_activity_copy_close",     
        current_button_name = "Panel_7",     
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, nil, 0)
	
end

function FightRewardForDailyActivityCopy:onExit()
end
