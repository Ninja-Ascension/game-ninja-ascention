-- ----------------------------------------------------------------------------------------------------
-- 说明：征战主界面（包含竞技场等。。。）
-------------------------------------------------------------------------------------------------------
Campaign = class("CampaignClass", Window)

local campaign_window_open_terminal = {
    _name = "campaign_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:open(Campaign:new(), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local campaign_window_close_terminal = {
    _name = "campaign_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:close(fwin:find("CampaignClass"))

    	if fwin:find("MenuClass") == nil then
            fwin:open(Menu:new(), fwin._taskbar)
        end
		if fwin:find("HomeClass") == nil then
        	state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager", 	
						next_terminal_name = "menu_show_home_page", 
						current_button_name = "Button_home",
						but_image = "Image_home", 		
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
        end
        state_machine.excute("menu_back_home_page", 0, "") 
		state_machine.excute("home_hero_refresh_draw", 0, "")
		state_machine.excute("menu_clean_page_state", 0, "") 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(campaign_window_open_terminal)
state_machine.add(campaign_window_close_terminal)
state_machine.init()

function Campaign:ctor()
    self.super:ctor()
    self.roots = {}

    -- load luf file
    app.load("client.l_digital.campaign.arena.Arena")
    app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsWindow")
    app.load("client.l_digital.union.unionFighting.UnionFightingMain")
    app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelMap")
    app.load("client.l_digital.campaign.cross_total_war.CrossTotalWar")
    app.load("client.l_digital.campaign.team_arena.TeamArena")
    app.load("client.l_digital.campaign.crossServerBattleofKings.SmCrossServerBattleofKingsWindow")
    -- var
    -- 界面跳转映射
    self.interfaceJumpMapping = {
        [1] = {fun_open_id = 80}, -- 竞技场
        [2] = {fun_open_id = 81}, -- 王者之战
        [3] = {fun_open_id = 82}, -- 公会战
        [4] = {fun_open_id = 83}, -- 跨服王者之战
        [5] = {fun_open_id = 84}, -- 跨服矿战
        [6] = {fun_open_id = 195}, -- 冠军试炼
        [7] = {fun_open_id = 196},-- 跨服小队竞技场
    }
	
    -- Initialize campaign page state machine.
    local function init_campaign_terminal()

		local campaign_show_manager_terminal = {
            _name = "campaign_show_manager",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("campaign_show_manager")

                local pageIndex = params._datas.pageIndex
                local fun_open_id = instance.interfaceJumpMapping[pageIndex].fun_open_id

                local unlockCallback = function()
                    state_machine.unlock("campaign_show_manager")
                end

                -- 功能未开启
                if params._datas.isOpened == false then
                    local element = dms.element(dms["fun_open_condition"], fun_open_id)
                    TipDlg.drawTextDailog(dms.atos(element, fun_open_condition.tip_info))

                    unlockCallback()
                else
                    if pageIndex == 1 then
                        -- 竞技场
                        state_machine.excute("arena_window_open", 0, 0)
                        unlockCallback()
                    elseif pageIndex == 2 then
                        -- 王者之战
                        state_machine.excute("sm_battleof_kings_window_open", 0, 0)
                        unlockCallback()
                    elseif pageIndex == 3 then
                        -- 公会战
                        state_machine.excute("union_fighting_main_open", 0, nil)
                        unlockCallback()
                    elseif pageIndex == 4 then
                        -- 跨服王者之战
                        local function requesrDefendCheck(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.excute("sm_cross_server_battleof_kings_window_open", 0, 0)
                                unlockCallback()
                            else
                                unlockCallback()
                            end
                        end
                        NetworkManager:register(protocol_command.the_kings_battle_self_init.code, nil, nil, nil, self, requesrDefendCheck, false, nil) 
                    elseif pageIndex == 5 then
                        -- 跨服矿战
                        local function responseCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.excute("cross_server_battel_map_window_open", 0, 0)
                                unlockCallback()
                            else
                                unlockCallback()
                            end
                        end

                        if _ED.cross_server_battel_is_open == 0 then
                            NetworkManager:register(protocol_command.cross_mine_user_join_not_open.code, nil, nil, nil, self, responseCallback, false, nil)
                        else
                            NetworkManager:register(protocol_command.cross_mine_init.code, nil, nil, nil, self, responseCallback, false, nil)
                        end
                    elseif pageIndex == 6 then
                        -- 冠军试炼
                        local function responseCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.excute("cross_total_war_window_open", 0, 0)
                                unlockCallback()
                            else
                                unlockCallback()
                            end
                        end
                        NetworkManager:register(protocol_command.cross_arena_init.code, nil, nil, nil, self, responseCallback, false, nil) 
                    elseif pageIndex == 7 then
                        -- 跨服小队竞技场
                        local function responseCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.excute("team_arena_window_open", 0, 0)
                                unlockCallback()
                            else
                                unlockCallback()
                            end
                        end
                        NetworkManager:register(protocol_command.team_arena_enter.code, nil, nil, nil, self, responseCallback, false, nil) 
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		local campaign_window_show_terminal = {
            _name = "campaign_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local campaign_window_hide_terminal = {
            _name = "campaign_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(campaign_show_manager_terminal)
		state_machine.add(campaign_window_show_terminal)
		state_machine.add(campaign_window_hide_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_campaign_terminal()
end

function Campaign:onUpdate(dt)

end

function Campaign:onUpdateDraw()
	
end

function Campaign:onEnterTransitionFinish()
	local csbCampaign = csb.createNode("campaign/activity_list.csb")
    self:addChild(csbCampaign)
	local root = csbCampaign:getChildByName("root")
	table.insert(self.roots, root)
	-- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_activity_back"), nil, 
    {
        terminal_name = "campaign_window_close", 
        isPressedActionEnabled = true
    },
    nil,0)

	-- 添加进入的回调
	local ScrollView_activity_fun = ccui.Helper:seekWidgetByName(root, "ScrollView_activity_fun")
    local items = ScrollView_activity_fun:getChildren()
    
    for i, v in pairs(items) do
        v.roots = {v}
		local Image_maoxian_fun_pic = ccui.Helper:seekWidgetByName(v, "Image_activity_fun_pic_" .. i)
        local Image_maoxian_lock = ccui.Helper:seekWidgetByName(v, "Image_activity_lock_" .. i)
        local Text_activity_lv = ccui.Helper:seekWidgetByName(v, "Text_activity_lv_" .. i)

        local fun_open_id = self.interfaceJumpMapping[i].fun_open_id
		
        -- 功能是否开启
        local isOpened = funOpenDrawTip(fun_open_id, false) == false
        if type(cc.nrSpineCommand)=='function' and require('fight_test_access').enabled(fun_open_id) then
            isOpened = true
        end
        Image_maoxian_lock:setVisible(isOpened == false)

        -- 开启条件文本
        if Text_activity_lv ~= nil then
            Text_activity_lv:setVisible(isOpened == false)
            local element = dms.element(dms["fun_open_condition"], fun_open_id)
            Text_activity_lv:setString(dms.atos(element, fun_open_condition.tip_info))
        end

        fwin:addTouchEventListener(Image_maoxian_fun_pic, nil, 
        {
            terminal_name = "campaign_show_manager", 
            pageIndex = i,
            isOpened = isOpened,
            isPressedActionEnabled = true
        },
        nil,0)

        local basePositionX = v:getPositionX()
        v:setPositionX(1240)
        local moveTo = cc.MoveTo:create(0.12, cc.p(basePositionX, v:getPositionY()))
        local delay = cc.DelayTime:create((i - 1) * 0.12)
        -- local action = cc.EaseBackInOut:create(moveTo)
        v:runAction(cc.Sequence:create(delay, moveTo))
	end

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_arena_page_tip",
        _widget = ccui.Helper:seekWidgetByName(root, "Image_activity_fun_pic_1"),
        _invoke = nil,
        _interval = 0.5,})

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_battle_of_kings_all",
        _widget = ccui.Helper:seekWidgetByName(root, "Image_activity_fun_pic_2"),
        _invoke = nil,
        _interval = 0.5,})

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_union_battle",
        _widget = ccui.Helper:seekWidgetByName(root, "Image_activity_fun_pic_3"),
        _invoke = nil,
        _interval = 0.5,})
    --跨服王者 红点推送
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_battle_of_cross_server_kings_all",
    _widget = ccui.Helper:seekWidgetByName(root, "Image_activity_fun_pic_4"),
    _invoke = nil,
    _interval = 0.5,})


    -- --跨服冠军试炼 红点推送
    -- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_cross_total_war",
    -- _widget = ccui.Helper:seekWidgetByName(root, "Image_activity_fun_pic_6"),
    -- _invoke = nil,
    -- _interval = 0.5,})

    --跨服竞技小队 红点推送
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_team_arean",
    _widget = ccui.Helper:seekWidgetByName(root, "Image_activity_fun_pic_7"),
    _invoke = nil,
    _interval = 0.5,})

	self:onUpdateDraw()
    
    app.load("client.player.UserInformationHeroStorage")
    local userInformationHeroStorage = UserInformationHeroStorage:new()
    userInformationHeroStorage._rootWindows = self
    fwin:open(userInformationHeroStorage,fwin._view)
end

function Campaign:onExit()
	state_machine.remove("campaign_show_manager")
	state_machine.remove("campaign_window_show")
	state_machine.remove("campaign_window_hide")
end

function Campaign:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end

--return Campaign:new()
