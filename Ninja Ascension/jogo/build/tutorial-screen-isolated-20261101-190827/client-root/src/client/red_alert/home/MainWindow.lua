--------------------------------------------------------------------------------------------------------------
--  说明：主页窗口
--------------------------------------------------------------------------------------------------------------
MainWindow = class("MainWindowClass", Window)

--打开界面
local main_window_open_terminal = {
	_name = "main_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        -- fwin:cleanView(fwin._background)
        -- fwin:cleanView(fwin._view)
        -- fwin:cleanView(fwin._viewdialog)
        -- fwin:cleanView(fwin._ui)

        if fwin:find("MainWindowClass") == nil then
            local god_weaponry = nil
            if params ~= nil then 
                god_weaponry = params
            end
		    fwin:open(MainWindow:new():init(god_weaponry),fwin._frameview)
        end
        state_machine.excute("main_window_show",0,"")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local main_window_close_terminal = {
	_name = "main_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)

		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--登录弹窗
local main_window_login_popup_banner_terminal = {
    _name = "main_window_login_popup_banner",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if terminal.isOpend ~= nil or nil == params then 
            --本次运行时已经弹出过
            if params ~= true then
                terminal.isOpend = nil
            end
            return false
        end
        if fwin:find("LoginClass") ~= nil then
            return false
        end
        --只有第一次进入游戏的时候 
        if terminal.isOpend == nil then 
            terminal.isOpend = true
        end
        if missionIsOver() == false then
            return false
        end
        local t = state_machine.find("main_window_login_popup_banner_open", 0, 0)
        t.index = 1
        t.maxCount = 2
        state_machine.excute("main_window_login_popup_banner_open", 0, 0)
        -- local maxCount = 2 -- 最大弹窗数量
        -- local nCount = dms.count(dms["load_popup_interface"])
        -- local server_date = os.date("%x", _ED.system_time)
        -- for i, v in pairs(dms["load_popup_interface"]) do
        --     local notification_type = dms.atoi(v, load_popup_interface.notification_type)
        --     local addition_png = dms.atos(v, load_popup_interface.addition_png)
        --     local notification_param = dms.atos(v, load_popup_interface.notification_param)
        --     local notification_state = dms.atoi(v, load_popup_interface.notification_state)
        --     local tracking = dms.atoi(v, load_popup_interface.notification_state)
        --     if notification_state == 1 then
        --         if 0 == notification_type then
        --             -- 预告
        --             app.load("client.red_alert.activity.wonderful.ActivityVipPush")
        --             -- cc.UserDefault:getInstance():setStringForKey(getKey("notification_popup_windows_" .. notification_type), "")
        --             local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("notification_popup_windows_" .. notification_type), "")
        --             if save_date ~= server_date then
        --                 state_machine.excute("activity_vip_push_window_open", 0, {notification_type, addition_png, tracking, maxCount + 10})
        --                 maxCount = maxCount - 1
        --             end
        --         elseif 1 == notification_type then
        --             -- 7日登录
        --             app.load("client.red_alert.activity.wonderful.ActivitySevenDay")
        --             if nil ~= _ED.activity_info["7"] then
        --                 local now_day_index = tonumber(zstring.split(_ED.activity_info["7"].activity_add_state, ",")[1])
        --                 local state = zstring.tonumber(_ED.activity_info["7"].activity_data[now_day_index][1].achieve_state)
        --                 if (now_day_index < 7 or state < 2) and true == state_machine.excute("activity_seven_day_window_open", 0, {_zorder = maxCount + 10}) then
        --                     maxCount = maxCount - 1
        --                 end
        --             end
        --         elseif 2 == notification_type then
        --             -- 首充
        --             -- -- local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("today_first_login_game_pop_up_recharge_window"), "")
        --             -- -- if save_date ~= server_date then
        --             --     -- cc.UserDefault:getInstance():setStringForKey(getKey("today_first_login_game_pop_up_recharge_window"), server_date)
        --             --     if zstring.tonumber(_ED.user_info.recharge_all_rmb) <= 0 then
        --             --         app.load("client.red_alert.activity.wonderful.ActivityFristRechargeTop")
        --             --         state_machine.excute("activity_frist_recharge_top_window_open", 0, 0)
        --             --         maxCount = maxCount - 1
        --             --     end
        --             -- -- end
        --             if _ED.activity_info["2"] ~= nil then
        --                 if tonumber(_ED.activity_info["2"].activity_data[1][1].achieve_state) <= 1 then 
        --                     app.load("client.red_alert.activity.wonderful.ActivityFristRechargeTop")
        --                     state_machine.excute("activity_frist_recharge_top_window_open", 0, {_zorder = maxCount + 10})
        --                     maxCount = maxCount - 1
        --                 end
        --             end
        --         elseif 3 == notification_type then
        --             -- 20倍返（98元5倍）
        --             app.load("client.red_alert.activity.wonderful.ActivityPopRecharge")
        --             if _ED.activity_info["19"] ~= nil then
        --                 if true == state_machine.excute("activity_pop_recharge_window_open", 0, {_zorder = maxCount + 10}) then
        --                     maxCount = maxCount - 1
        --                 end
        --             end
        --         elseif 4 == notification_type then
        --             -- 2充

        --         elseif 5 == notification_type then
        --             -- 月卡
                    
        --         elseif 6 == notification_type then
        --             -- VIP礼包
        --             -- cc.UserDefault:getInstance():setStringForKey(getKey("notification_popup_windows_" .. notification_type), "")
        --             local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("notification_popup_windows_" .. notification_type), "")
        --             if save_date ~= server_date then
        --                 notification_param = zstring.split(notification_param, ",")
        --                 local needVipLevel = zstring.tonumber(notification_param[1])
        --                 local vipLevel = zstring.tonumber(notification_param[2])
        --                 if needVipLevel == zstring.tonumber(_ED.user_info.vip_level) then
        --                     app.load("client.red_alert.activity.wonderful.ActivityVipPush")
        --                     state_machine.excute("activity_vip_push_window_open", 0, {notification_type, addition_png, tracking, maxCount + 10})
        --                     maxCount = maxCount - 1
        --                 end
        --             end
        --         end
        --         if maxCount <= 0 then
        --             break
        --         end
        --     end
        -- end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--登录弹窗
local main_window_login_popup_banner_open_terminal = {
    _name = "main_window_login_popup_banner_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- local maxCount = terminal.maxCount -- 最大弹窗数量
        local nCount = dms.count(dms["load_popup_interface"])
        local server_date = os.date("%x", _ED.system_time)
        -- for i, v in pairs(dms["load_popup_interface"]) do
        if terminal.index == nil or terminal.maxCount == nil or terminal.maxCount <= 0 then
            return false
        end
        for i = terminal.index, nCount do
            local v = dms.element(dms["load_popup_interface"], i)
            terminal.index = i + 1
            local notification_type = dms.atoi(v, load_popup_interface.notification_type)
            local addition_png = dms.atos(v, load_popup_interface.addition_png)
            local notification_param = dms.atos(v, load_popup_interface.notification_param)
            local notification_state = dms.atoi(v, load_popup_interface.notification_state)
            local tracking = dms.atoi(v, load_popup_interface.notification_state)
            if notification_state == 1 then
                if 0 == notification_type then
                    -- 预告
                    if fwin:find("ActivityVipPushClass") == nil then
                        app.load("client.red_alert.activity.wonderful.ActivityVipPush")
                        -- cc.UserDefault:getInstance():setStringForKey(getKey("notification_popup_windows_" .. notification_type), "")
                        local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("notification_popup_windows_" .. notification_type), "")
                        if save_date ~= server_date then
                            state_machine.excute("activity_vip_push_window_open", 0, {notification_type, addition_png, tracking, terminal.maxCount - 10})
                            terminal.maxCount = terminal.maxCount - 1
                            return true
                        end
                    end
                elseif 1 == notification_type then
                    -- 7日登录
                    if fwin:find("ActivitySevenDayClass") == nil then
                        app.load("client.red_alert.activity.wonderful.ActivitySevenDay")
                        app.load("client.red_alert.activity.wonderful.ActivityFourteenDays")
                        if nil ~= _ED.activity_info["7"] then
                            local now_day_index = tonumber(zstring.split(_ED.activity_info["7"].activity_add_state, ",")[1])
                            if now_day_index <= #_ED.activity_info["7"].activity_data then
                                local state = zstring.tonumber(_ED.activity_info["7"].activity_data[now_day_index][1].achieve_state)
                                if (now_day_index <= 7 or state < 2) and true == state_machine.excute("activity_seven_day_window_open", 0, {_zorder = terminal.maxCount - 10}) then
                                    terminal.maxCount = terminal.maxCount - 1
                                    return true
                                end
                            end
                        end
                        if nil ~= _ED.activity_info["27"] then
                            local now_day_index = tonumber(zstring.split(_ED.activity_info["27"].activity_add_state, ",")[1])
                            now_day_index = now_day_index - 7
                            if now_day_index > 0 and now_day_index <= #_ED.activity_info["27"].activity_data then
                                local state = zstring.tonumber(_ED.activity_info["27"].activity_data[now_day_index][1].achieve_state)
                                if (now_day_index <= 7 or state < 2) and true == state_machine.excute("activity_fourteen_days_window_open", 0, {_zorder = terminal.maxCount - 10}) then
                                    terminal.maxCount = terminal.maxCount - 1
                                    return true
                                end
                            end
                        end
                    end
                elseif 2 == notification_type then
                    -- 首充
                    -- -- local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("today_first_login_game_pop_up_recharge_window"), "")
                    -- -- if save_date ~= server_date then
                    --     -- cc.UserDefault:getInstance():setStringForKey(getKey("today_first_login_game_pop_up_recharge_window"), server_date)
                    --     if zstring.tonumber(_ED.user_info.recharge_all_rmb) <= 0 then
                    --         app.load("client.red_alert.activity.wonderful.ActivityFristRechargeTop")
                    --         state_machine.excute("activity_frist_recharge_top_window_open", 0, 0)
                    --         terminal.maxCount = terminal.maxCount - 1
                    --     end
                    -- -- end
                    if fwin:find("ActivityFristRechargeTopClass") == nil then
                        local sceneId = 1
                        local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], sceneId, pve_scene.npcs), ",")
                        local maxNpcId = tonumber(tempNpcIds[#tempNpcIds - 1])
                        local npcState = tonumber(_ED.npc_state[zstring.tonumber(maxNpcId)])
                        if npcState > 0 and _ED.activity_info["2"] ~= nil then
                            if tonumber(_ED.activity_info["2"].activity_data[1][1].achieve_state) <= 1 then 
                                app.load("client.red_alert.activity.wonderful.ActivityFristRechargeTop")
                                state_machine.excute("activity_frist_recharge_top_window_open", 0, {_zorder = terminal.maxCount - 10})
                                -- app.load("client.red_alert.activity.wonderful.Wonderful")
                                -- state_machine.excute("wonderful_window_open", 0, 2)
                                terminal.maxCount = terminal.maxCount - 1
                                return true
                            end
                        end
                    end
                elseif 3 == notification_type then
                    -- 20倍返（98元5倍）
                    if fwin:find("ActivityPopRechargeClass") == nil then
                        -- app.load("client.red_alert.activity.wonderful.ActivityPopRecharge")
                        app.load("client.red_alert.activity.wonderful.WonderfulOpen")
                        if _ED.activity_info["19"] ~= nil then
                            if true == state_machine.excute("wonderful_open_window_open", 0, 19) then
                                terminal.maxCount = terminal.maxCount - 1
                                return true
                            end
                        end
                    end
                elseif 4 == notification_type then
                    -- 2充

                elseif 5 == notification_type then
                    -- 月卡
                    
                elseif 6 == notification_type then
                    -- VIP礼包
                    -- cc.UserDefault:getInstance():setStringForKey(getKey("notification_popup_windows_" .. notification_type), "")
                    if fwin:find("ActivityVipPushClass") == nil then
                        local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("notification_popup_windows_" .. notification_type), "")
                        if save_date ~= server_date then
                            notification_param = zstring.split(notification_param, ",")
                            local needVipLevel = zstring.tonumber(notification_param[1])
                            local vipLevel = zstring.tonumber(notification_param[2])
                            if needVipLevel == zstring.tonumber(_ED.user_info.vip_level) then
                                app.load("client.red_alert.activity.wonderful.ActivityVipPush")
                                state_machine.excute("activity_vip_push_window_open", 0, {notification_type, addition_png, tracking, terminal.maxCount - 10})
                                terminal.maxCount = terminal.maxCount - 1
                                return true
                            end
                        end
                    end
                end
                if terminal.maxCount <= 0 then
                    break
                end
            end
        end
        return false
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(main_window_open_terminal)
state_machine.add(main_window_close_terminal)
state_machine.add(main_window_login_popup_banner_terminal)
state_machine.add(main_window_login_popup_banner_open_terminal)
state_machine.init()

function MainWindow:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    
    self.home_cells = {}
    -- 神兵副本
    self._god_weaponry = nil 
    --var
    --技能ID
    self._majesty_skill_id = nil

    self._isAddEffect = false
    self._Text_cd = nil
    self._panel_suiping = nil

    app.load("client.utils.ConfirmTip")
    app.load("client.red_alert.home.HomeButton")
    app.load("client.red_alert.home.HomeButtonForAction")
    app.load("client.red_alert.player.PlayerInfo")
    app.load("client.red_alert.player.PlayerResource")
    app.load("client.red_alert.player.PlayerUpGrade")
    app.load("client.red_alert.cells.home.home_build_cell")
    app.load("client.red_alert.chat.ChatView")
    app.load("client.red_alert.utils.RewardObtain")
    app.load("client.red_alert.utils.BuyResource")
    app.load("client.red_alert.home.HomeSelectAction")
    app.load("client.red_alert.cells.all_resources_cell")
    app.load("client.red_alert.home.BuildLevelUp")
    app.load("client.red_alert.home.ProtagonistSkills")
    app.load("client.red_alert.shop.MysteryShop")
    app.load("client.shop.recharge.RechargeDialog") 
    app.load("client.red_alert.utils.PropsInformation")
    app.load("client.red_alert.utils.GetTheWay")
    app.load("client.red_alert.utils.ShortCut")
    app.load("client.utils.DrawHelper")
    app.load("client.red_alert.fate.Fate")
    app.load("client.red_alert.packs.equipstorage.EquipmentInformation")
    app.load("client.red_alert.notification.push_notification_home_build")
    app.load("client.red_alert.utils.FightingUp")
    app.load("client.red_alert.utils.AddNumber")
    app.load("client.red_alert.cells.player.user_head_icon")
    app.load("client.red_alert.cells.packs.packs_icon_bg_cell")
    app.load("client.red_alert.packs.herostorage.HeroPacksInformation")
    app.load("client.red_alert.notification.push_notification_home_button")
    app.load("client.red_alert.notification.push_notification_home_button_foraction")
    app.load("client.red_alert.utils.UserInfoWindow")
    app.load("client.red_alert.campaign.tourneyfield.Tourneyfield")
    app.load("client.red_alert.home.HomeButtonActivity")
    app.load("client.red_alert.activity.wonderful.ActivityPushManager")
    app.load("client.red_alert.god_weaponry.GodWeaponry")
    app.load("client.red_alert.god_weaponry.GodWeaponryDuplicate")
    app.load("client.red_alert.union.unionFighting.UnionFightingNotice")
    app.load("client.red_alert.union.unionFighting.UnionFightingOpen")
    app.load("client.red_alert.personal_fight.PersonalFightBattleField")

    app.load("client.red_alert.personal_fight.PersonalFightMain")

    -- var 
    self._reconnect = 30 -- socket 重新连接
	
	self._targetPlatform = cc.Application:getInstance():getTargetPlatform()
	
	self.platform_tx_pay_time = os.time()
    
	 -- Initialize alert_home state machine.
    local function init_main_window_terminal()
		--显示主界面所有
		local main_window_show_terminal = {
            _name = "main_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 隐藏主界面所有
        local main_window_hide_terminal = {
            _name = "main_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

			--检查是否有新开启的建筑
		local main_window_check_build_open_terminal = {
            _name = "main_window_check_build_open",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 刷新新开启的建筑
        local main_window_update_build_terminal = {
            _name = "main_window_update_build",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDrawBuild()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新的建筑建筑
        local main_window_update_build_level_terminal = {
            _name = "main_window_update_build_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDrawBuildLevel(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 位移至指定建筑显示区域
        local main_window_scroll_to_panel_city_terminal = {
            _name = "main_window_scroll_to_panel_city",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local city_id = params[1]
                instance:scrollToPanelCity(city_id)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 加入阵营拉近
        local main_window_join_camp_in_terminal = {
            _name = "main_window_join_camp_in",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local city_id = params[1]
                instance:campJoinIn()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local main_window_open_battle_field_terminal = {
            _name = "main_window_open_battle_field",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.personal_fighting_lose_state = nil
                        state_machine.excute("personal_fight_battle_field_window_open", 0, "")
                    end
                end
                protocol_command.user_stronghold_clear_be_rob_cd.param_list=""
                NetworkManager:register(protocol_command.user_stronghold_clear_be_rob_cd.code, nil, nil, nil, self, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(main_window_show_terminal)
		state_machine.add(main_window_hide_terminal)			
		state_machine.add(main_window_check_build_open_terminal)
		state_machine.add(main_window_update_build_terminal)
        state_machine.add(main_window_update_build_level_terminal)
        state_machine.add(main_window_scroll_to_panel_city_terminal)
        state_machine.add(main_window_join_camp_in_terminal)
        state_machine.add(main_window_open_battle_field_terminal)
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_main_window_terminal()
end

function MainWindow:onShow()
    fwin:__show(fwin._frameview)
end

function MainWindow:onHide()
    fwin:__hide(fwin._frameview)
end

function MainWindow:scrollToPanelCity(city_id)
    local root = self.roots[1]
    local ScrollView_home_bg = ccui.Helper:seekWidgetByName(root,"ScrollView_home_bg")
    local panel = ccui.Helper:seekWidgetByName(root, "Panel_city_"..city_id)
    local x = panel:getPositionX()-- - NpcPad:getContentSize().width*2
    local y = panel:getPositionY()-- + NpcPad:getContentSize().height*2
    local size = ScrollView_home_bg:getInnerContainer():getContentSize()
    local move_x = x/size.width*100
    local move_y = 100 - y/size.height*100
    if move_x > 70 then
        move_x = 100 
    elseif move_x < 30 then
        move_x = 0
    end
    if move_y > 70 then
        move_y = 100 
    elseif move_y < 30 then
        move_y = 0
    end
    ScrollView_home_bg:scrollToPercentBothDirection(cc.p(move_x,move_y),0.5,true)
end

function MainWindow:updateDrawBuild()
    for i = 1,dms.count(dms["build_mould"]) do
        local funopen_id = dms.int(dms["build_mould"],i,build_mould.fun_open_tab_id)
        local open_level = dms.int(dms["fun_open_condition"],funopen_id,fun_open_condition.level)

        if open_level == tonumber(_ED.user_info.user_grade) then
            if self.home_cells[i] ~= nil then
                if self.home_cells[i].updateDraw ~= nil then
                    self.home_cells[i]:updateDraw()
                end
            end
        end
    end
end

function MainWindow:updateDrawBuildLevel(build_id)
	state_machine.excute("home_build_cell_update_level",0,self.home_cells[build_id])
    if build_id == 1 then 
        self:checkMajestyPush()
    end
end

function MainWindow:checkBuildOpen()
	
end

function MainWindow:updateDraw()
    local root = self.roots[1]
    -- if config_res._sync_draw_open ~= nil and config_res._sync_draw_open ~= "" and config_res._sync_draw_open == true then
    --     local index = 0
    --     local function repetBack( sender )
    --         index = index + 1
    --         if sender == nil or sender.roots == nil or sender.roots[1] == nil then
    --             sender:stopAllActions()
    --             return
    --         end
    --         if index > 20 then
    --             sender:stopAllActionsByTag(100)
    --             return
    --         end
    --         local root = sender.roots[1]
    --         if index == 19 then
    --             local Panel_city_icon_8 = ccui.Helper:seekWidgetByName(root,"Panel_city_icon_8")
    --             Panel_city_icon_8:removeAllChildren(true)
    --             local jsonFile = "images/ui/effice/effice_home_building_8/effice_home_building_8.json"
    --             local atlasFile = "images/ui/effice/effice_home_building_8/effice_home_building_8.atlas"
    --             local animate1 = sp.spine(jsonFile,atlasFile, 1, 0, "animation_event", true, nil)
    --             Panel_city_icon_8:addChild(animate1) 
    --         elseif index == 20 then
    --             local Panel_build_mine = ccui.Helper:seekWidgetByName(root,"Panel_build_mine")
    --             Panel_build_mine:removeAllChildren(true)
    --             local jsonFile2 = "images/ui/effice/effect_zy_zc/effect_zy_zc.json"
    --             local atlasFile2 = "images/ui/effice/effect_zy_zc/effect_zy_zc.atlas"        
    --             local animate2 = sp.spine(jsonFile2,atlasFile2, 1, 0, "animation_event", true, nil)
    --             Panel_build_mine:addChild(animate2)
    --         else
    --             local panel = ccui.Helper:seekWidgetByName(root, "Panel_city_"..index)
    --             if panel ~= nil then
    --                 local x = panel:getPositionX() 
    --                 local y = panel:getPositionY() 
    --                 panel:removeAllChildren(true)
    --                 local cell = state_machine.excute("home_build_create_cell",0,{index,x,y,panel})
    --                 panel:addChild(cell)
    --                 table.insert(sender.home_cells, cell)
    --             end
    --         end
    --     end
    --     repetBack(self)
    --     local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(repetBack)))
    --     action:setTag(100)
    --     self:runAction(action)
    -- else
        for i=1,18 do
            local panel = ccui.Helper:seekWidgetByName(root, "Panel_city_"..i)
            local x = panel:getPositionX() 
            local y = panel:getPositionY() 
            panel:removeAllChildren(true)
            local cell = state_machine.excute("home_build_create_cell",0,{i,x,y,panel})
            panel:addChild(cell)
            table.insert(self.home_cells, cell)
        end
        local Panel_city_icon_8 = ccui.Helper:seekWidgetByName(root,"Panel_city_icon_8")
        Panel_city_icon_8:removeAllChildren(true)
        local jsonFile = "images/ui/effice/effice_home_building_8/effice_home_building_8.json"
        local atlasFile = "images/ui/effice/effice_home_building_8/effice_home_building_8.atlas"
        local animate1 = sp.spine(jsonFile,atlasFile, 1, 0, "animation_event", true, nil)
        Panel_city_icon_8:addChild(animate1) 

        local Panel_build_mine = ccui.Helper:seekWidgetByName(root,"Panel_build_mine")
        Panel_build_mine:removeAllChildren(true)
        local jsonFile2 = "images/ui/effice/effect_zy_zc/effect_zy_zc.json"
        local atlasFile2 = "images/ui/effice/effect_zy_zc/effect_zy_zc.atlas"        
        local animate2 = sp.spine(jsonFile2,atlasFile2, 1, 0, "animation_event", true, nil)
        Panel_build_mine:addChild(animate2)
    -- end
end

function MainWindow:onInit() 
    -- 推送箭头动画资源加载
    for i, v in pairs(config_res.sprites_cached["push_arrows"]) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
    end
    
    local csbItem = csb.createNode(string.format(config_csb.home.main_window,_ED.user_info.user_force))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(string.format(config_csb.home.main_window,_ED.user_info.user_force))
    table.insert(self.actions, action)
    csbItem:runAction(action)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recovery"), nil, 
    {
        terminal_name = "main_window_open_battle_field",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)
    self._Text_cd = ccui.Helper:seekWidgetByName(root,"Text_cd")
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		local Panel_home_bg = ccui.Helper:seekWidgetByName(root,"Panel_home_bg") 
		Panel_home_bg:removeAllChildren(true)
		Panel_home_bg:setBackGroundImage("images/ui/bg/home_bg1.png")
	end

    self._panel_suiping = ccui.Helper:seekWidgetByName(root, "Panel_suiping")
    self._panel_suiping:setVisible(false)

    getUserFight()
	self:updateDraw() 

   if config_res.home ~= nil and config_res.home.camp_init_position ~= nil then
        local root = self.roots[1]
        local ScrollView_home_bg = ccui.Helper:seekWidgetByName(root,"ScrollView_home_bg")
        local initPosition = config_res.home.camp_init_position["" .. _ED.user_info.user_force]
        if nil ~= initPosition then
            ScrollView_home_bg:getInnerContainer():setPosition(cc.p(initPosition.x, initPosition.y))
        end
    end
end

function MainWindow:campJoinIn()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("camp_in", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "camp_in_over" then
            state_machine.excute("join_camp_suceess_window_close", 0, "")
        end
    end)
end

function MainWindow:checkMajestyPush()
    local majesty_push_state = cc.UserDefault:getInstance():getStringForKey("majesty_".._ED.user_info.user_id.."_".._ED.home_build["1"].level,"0")
    local home_city_level = tonumber(_ED.home_build["1"].level)
    for i=1,dms.count(dms["majesty_skill"]) do
        self._majesty_skill_id = i 
        local skill_type = dms.int(dms["majesty_skill"],self._majesty_skill_id,majesty_skill.skill_type)
        if skill_type ~= 0 then
            local open_level = dms.int(dms["majesty_skill"],self._majesty_skill_id,majesty_skill.open_level)
            if tonumber(majesty_push_state) == 0 and home_city_level == open_level then
                _ED.majesty_push_state = true
                cc.UserDefault:getInstance():setStringForKey("majesty_".._ED.user_info.user_id.."_".._ED.home_build["1"].level,"1")
                return
            else
                _ED.majesty_push_state = false
            end
        end
    end
end

function MainWindow:onEnterTransitionFinish()
	if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		local function openPlayerInfoWindow()
			state_machine.excute("player_info_window_open",0,"")
		end
		local action1 = cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(openPlayerInfoWindow))
		self:runAction(action1)  
		local function openChatViewWindow()
			state_machine.excute("chat_view_window_open",0,"")
			state_machine.excute("home_button_window_open",0,"")
		end
		local action2 = cc.Sequence:create(cc.DelayTime:create(0.2), cc.CallFunc:create(openChatViewWindow))
		self:runAction(action2)  
		
		local function openPlayerResourceWindow()
			state_machine.excute("player_resource_window_open",0,"")
		end
		local action3 = cc.Sequence:create(cc.DelayTime:create(0.3), cc.CallFunc:create(openPlayerResourceWindow))
		self:runAction(action3)  
		
		local function openHomeButtonForActionWindow()
			state_machine.excute("home_button_for_action_window_open",0,"")
		end
		local action4 = cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(openHomeButtonForActionWindow))
		self:runAction(action4)  
		
		local function openHomeButtonActivityWindow()
			state_machine.excute("home_button_activity_window_open", 0, nil)
		end
		local action5 = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openHomeButtonActivityWindow))
		self:runAction(action5)  
		
		local function openGodWeaponryWindow()
			if tonumber(self._god_weaponry) == 1 then
				state_machine.excute("god_weaponry_duplicate_window_open",0,_ED._god_weaponry_duplicate_level)
			end
		end
		local action6 = cc.Sequence:create(cc.DelayTime:create(0.6), cc.CallFunc:create(openGodWeaponryWindow))
		self:runAction(action6)  
		
		local function openMainWindowLoginPopup()
			state_machine.excute("main_window_login_popup_banner", 0, true)
		end
		local action7 = cc.Sequence:create(cc.DelayTime:create(0.7), cc.CallFunc:create(openMainWindowLoginPopup))
		self:runAction(action7)  
		
		local function openPlayerResourceWindow()
			if fwin:find("DuplicateManagerClass") ~= nil then
				state_machine.excute("player_resource_window_hide",0,"")
			end
		end
		local action8 = cc.Sequence:create(cc.DelayTime:create(0.8), cc.CallFunc:create(openPlayerResourceWindow))
		self:runAction(action8)  
	else
		local function openOtherWindow()
			state_machine.excute("player_info_window_open",0,"")
			state_machine.excute("home_button_window_open",0,"")
			state_machine.excute("chat_view_window_open",0,"")
			state_machine.excute("player_resource_window_open",0,"")
			state_machine.excute("home_button_for_action_window_open",0,"")
			-- state_machine.excute("activity_push_manager_goto", 0, nil)
			state_machine.excute("home_button_activity_window_open", 0, nil)
			if tonumber(self._god_weaponry) == 1 then
				state_machine.excute("god_weaponry_duplicate_window_open",0,_ED._god_weaponry_duplicate_level)
			end
			state_machine.excute("main_window_login_popup_banner", 0, true)
			if fwin:find("DuplicateManagerClass") ~= nil then
				state_machine.excute("player_resource_window_hide",0,"")
			end
		end 
		local action = cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(openOtherWindow))
		self:runAction(action)  
    end
    self:checkMajestyPush()

    --跑马灯
    if funOpenDrawTip(55,false) == false then  
        app.load("client.home.WarshipGirlPushInfo")
        state_machine.excute("warship_girl_push_info_open",0,{_datas={_openType=0}})
    end

    --跑马灯top
    if funOpenDrawTip(55,false) == false then  
        app.load("client.home.WarshipGirlPushInfoTop")
        state_machine.excute("warship_girl_push_info_top_open",0,{_datas={_openType=0}})
    end
	--play800的线下充值
	state_machine.excute("platform_get_pay_info", 0, "platform_get_pay_info.")
end

function MainWindow:formatTimeString(_time)
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function MainWindow:onUpdate(dt)
    app.notification_center.running = true
    self._reconnect = self._reconnect - dt
    if _ED.personal_fighting_lose_state ~= nil 
        and _ED.personal_fighting_lose_state ~= 0
        and _ED.personal_fighting_lose_cd > 0 then
        local open_personal_build = false
        for i = 20, 26 do
            if _ED.home_build[""..i] ~= nil and zstring.tonumber(_ED.home_build[""..i].level) > 1 then
                open_personal_build = true
                break
            end
        end

        if open_personal_build == true then
            self._panel_suiping:setVisible(true)
            _ED.personal_fighting_lose_cd = _ED.personal_fighting_lose_cd - dt
            if _ED.personal_fighting_lose_cd <= 0 then       --战败倒计时结束
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.personal_fighting_lose_state = nil
                    end
                end
                protocol_command.user_stronghold_clear_be_rob_cd.param_list = ""
                NetworkManager:register(protocol_command.user_stronghold_clear_be_rob_cd.code, nil, nil, nil, self, responseCallback, false, nil)
            end
        else
            self._panel_suiping:setVisible(false)
        end
    else
        self._panel_suiping:setVisible(false)
    end

    if self._reconnect < 0 then
    	--断线重连后的处理
    	if NetworkAdaptor.socketIsOpen() == false then 
    		NetworkAdaptor.intSocket()
    	end
        self._reconnect = 30
    end
	
	if app.configJson.OperatorName == "tencent" or app.configJson.OperatorName == "gdtppk" then
		if m_tx_pay_index < zstring.tonumber(m_tencent_pay_number) and (os.time() - self.platform_tx_pay_time) > 1 then
			m_tx_pay_index = m_tx_pay_index+1
			self.platform_tx_pay_time = os.time()
			state_machine.excute("tencent_balance_inquiry", 0, "tencent_balance_inquiry.")
		end
	end
	
	if self._targetPlatform == cc.PLATFORM_OS_IPHONE or self._targetPlatform == cc.PLATFORM_OS_IPAD then
		if zstring.tonumber(m_sVersion)*1000 >= 1523 and zstring.tonumber(m_sVersion)*1000 <= 1525 then
			if m_platform_app_value ~= nil and m_platform_app_value ~= "" then
				local iDentity = tonumber(m_platform_app_value)+1
				m_platform_app_value = ""
				local function responseGetServerListCallback(response)
					local specialpid = cc.UserDefault:getInstance():getStringForKey("paySpecialpid")
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						app.load("client.cells.recharge.recharge_list_cell")
						app.load("client.activity.ActivityWindow")
						app.load("client.red_alert.activity.wonderful.ActivityPopRecharge")
						if zstring.tonumber(specialpid) == 9 then
							TipDlg.drawTextDailog(_string_piece_info[427])
						end
						state_machine.excute("activity_pop_recharge_recharge_success", 0, nil)
						handlePlatformRequest(0, VERIFY_RECEIPT_SOUCCESS, ""..(iDentity-1))
						state_machine.excute("refresh_single_recharge_interface_list", 0, {_rechargeCell = nil})
					end
					cc.UserDefault:getInstance():setStringForKey("paySpecialpid", "-1")
					cc.UserDefault:getInstance():flush()
				end
				if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
				and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
				and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
					
					if iDentity == 4 then
						local specialpid = cc.UserDefault:getInstance():getStringForKey("paySpecialpid")
						cc.UserDefault:getInstance():flush()
						if zstring.tonumber(specialpid) == 9 then
							iDentity = 10
						end
					end
					
					protocol_command.vali_top_up_order_number.param_list = "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id..m_play_pay_type
					NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, rechargeCell, responseGetServerListCallback, false, nil)
					NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
				end
			end
		end
	end
end

function MainWindow:scrollViewHomePosition()
    local root = self.roots[1]
    local ScrollView_home_bg = ccui.Helper:seekWidgetByName(root, "ScrollView_home_bg")
    local x = ScrollView_home_bg:getInnerContainer():getPositionX() 
    local y = ScrollView_home_bg:getInnerContainer():getPositionY() 
    return x, y 
end

function MainWindow:init(god_weaponry)
    self._god_weaponry = god_weaponry
	self:onInit()
	return self
end

function MainWindow:close( ... )
    for i = 1, 18 do
        local panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_city_"..i)
        panel:removeAllChildren(true)
    end
end

function MainWindow:onExit()
	state_machine.remove("main_window_show")
	state_machine.remove("main_window_hide")			
	state_machine.remove("main_window_check_build_open")
	state_machine.remove("main_window_update_build")
    state_machine.remove("main_window_update_build_level")
    state_machine.remove("main_window_scroll_to_panel_city")
    state_machine.remove("main_window_join_camp_in")
    state_machine.remove("main_window_open_battle_field")
end