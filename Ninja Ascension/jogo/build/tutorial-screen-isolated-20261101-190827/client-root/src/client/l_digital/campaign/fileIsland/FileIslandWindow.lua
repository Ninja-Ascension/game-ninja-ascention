-- ----------------------------------------------------------------------------------------------------
-- 说明：空岛探索主界面
-------------------------------------------------------------------------------------------------------
FileIslandWindow = class("FileIslandWindowClass", Window)

local fileIsland_window_open_terminal = {
    _name = "fileIsland_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if params and zstring.tonumber(params) == 1 then
            if fwin:find("FileIslandWindowClass") == nil then
                fwin:open(FileIslandWindow:new():init(params), fwin._view)
            end
        else
            local function callback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if fwin:find("FileIslandWindowClass") == nil then
                        fwin:open(FileIslandWindow:new():init(params), fwin._view)
                    end
                end
            end
            protocol_command.fileIslandEnter.param_list = ""
            NetworkManager:register(protocol_command.fileIslandEnter.code, nil, nil, nil, nil, callback, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fileIsland_window_open_terminal)
state_machine.init()

function FileIslandWindow:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.l_digital.campaign.fileIsland.FileIslandBoss")
    app.load("client.l_digital.campaign.fileIsland.FileIslandFriends")
    app.load("client.l_digital.campaign.fileIsland.FileIslandHolyThing")
    app.load("client.l_digital.campaign.fileIsland.FileIslandRule")
    app.load("client.l_digital.campaign.fileIsland.FileIslandShop")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinish")
    app.load("client.l_digital.campaign.fileIsland.FileIslandOneFinish")
    app.load("client.l_digital.campaign.fileIsland.FileIslandShopBuyTop")
    app.load("client.l_digital.campaign.fileIsland.FileIslandSearchPointBuy")
    app.load("client.l_digital.campaign.fileIsland.FileIslandFormation")
    
    local function init_fileIsland_terminal()
        -- 关闭
		local fileIsland_window_close_terminal = {
            _name = "fileIsland_window_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.unlock("explore_window_open_fun_window")

                if fwin:find("HomeClass") == nil then
                    state_machine.excute("menu_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "menu_manager",
                                next_terminal_name = "menu_show_home_page", 
                                current_button_name = "Button_home",
                                but_image = "Image_home",       
                                terminal_state = 0, 
                                _needOpenHomeHero = true,
                                isPressedActionEnabled = true
                            }
                        }
                    )
                    state_machine.excute("menu_back_home_page", 0, "")
                    state_machine.excute("home_change_open_atrribute", 0, false)
                end
                
                fwin:close(fwin:find("FileIslandWindowClass"))
                fwin:close(fwin:find("FileIslandShopBuyTopClass"))

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local fileIsland_window_onUpdateDraw_terminal = {
            _name = "fileIsland_window_onUpdateDraw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新boss红点
        local fileIsland_window_updateDraw_boss_redPoint_terminal = {
            _name = "fileIsland_window_updateDraw_boss_redPoint",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:reqBossData()

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新好友任务红点
        local fileIsland_window_updateDraw_friend_redPoint_terminal = {
            _name = "fileIsland_window_updateDraw_friend_redPoint",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:reqFriendData()

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 探索动画
        local fileIsland_open_animation_terminal = {
            _name = "fileIsland_open_animation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.fileIsland.searchPoint <= 0 then
                    TipDlg.drawTextDailog(tipStringInfo_file_island_tips[16])
                    return
                end
                local openType = params._datas.openType
                
                if self.jump_animation == true then
                    if openType == 1 then
                        state_machine.excute("fileIsland_one_finish_window_open", 0, "")
                    elseif openType == 2 then
                        state_machine.excute("fileIsland_all_finish_window_open", 0, "")
                    end
                else
                    local animation = params._datas.node.animation

                    local function changeActionCallback(armatureBack)
                        if openType == 1 then
                            state_machine.excute("fileIsland_one_finish_window_open", 0, "")
                        elseif openType == 2 then
                            state_machine.excute("fileIsland_all_finish_window_open", 0, "")
                        end
                        animation._invoke = nil
                    end

                    animation._invoke = changeActionCallback
                    csb.animationChangeToAction(animation, 0, 1, false)
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求好友任务数据
        local fileIsland_window_friends_open_request_data_terminal = {
            _name = "fileIsland_window_friends_open_request_data",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                
                local function responseFileIslandFriendsInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if #_ED.fileIsland.taskInfo.mySingleTaskInfo ~= 0 
                            or #_ED.fileIsland.taskInfo.myMultiTaskInfo ~= 0 
                            or #_ED.fileIsland.taskInfo.myJoinTaskInfo ~= 0 
                            or #_ED.fileIsland.taskInfo.friendMultiTaskInfo ~= 0
                            then
                            state_machine.excute("fileIsland_window_friends_open", 0, "")
                        else
                            TipDlg.drawTextDailog(tipStringInfo_file_island_tips[10])
                        end
                    end
                end
                protocol_command.fileIslandTaskInfo.param_list = ""
                NetworkManager:register(protocol_command.fileIslandTaskInfo.code, nil, nil, nil, nil, responseFileIslandFriendsInitCallback, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求boss数据
        local fileIsland_window_team_boss_open_request_data_terminal = {
            _name = "fileIsland_window_team_boss_open_request_data",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                
                local function responseFileIslandBossInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if #_ED.fileIsland.bossInfo.bossInfo ~= 0 then
                            state_machine.excute("fileIsland_window_team_boss_open", 0, "")
                        else
                            TipDlg.drawTextDailog(tipStringInfo_file_island_tips[9])
                        end
                    end
                end
                protocol_command.fileIslandBossInfo.param_list = ""
                NetworkManager:register(protocol_command.fileIslandBossInfo.code, nil, nil, nil, nil, responseFileIslandBossInitCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求圣物数据
        local fileIsland_window_holy_thing_open_request_data_terminal = {
            _name = "fileIsland_window_holy_thing_open_request_data",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                TipDlg.drawTextDailog(tipStringInfo_file_island_tips[15])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fileIsland_window_close_terminal)
        state_machine.add(fileIsland_window_onUpdateDraw_terminal)
        state_machine.add(fileIsland_window_updateDraw_boss_redPoint_terminal)
        state_machine.add(fileIsland_window_updateDraw_friend_redPoint_terminal)
        state_machine.add(fileIsland_open_animation_terminal)
        state_machine.add(fileIsland_window_friends_open_request_data_terminal)
        state_machine.add(fileIsland_window_team_boss_open_request_data_terminal)
        state_machine.add(fileIsland_window_holy_thing_open_request_data_terminal)

        state_machine.init()
    end
    
    init_fileIsland_terminal()

end

function FileIslandWindow:init(params)
    self.isRefreshing = false
    self:registerOnNoteUpdate(self, 1)
    return self
end

function FileIslandWindow:onUpdate(dt)
    local root = self.roots[1]
    if root == nil then
        return
    end

    if _ED.fileIsland == nil then
        return
    end

    local lastCDTime = _ED.fileIsland.lastCDTime
    if lastCDTime and lastCDTime > 0 then
        local current = _ED.system_time + (os.time() - _ED.native_time)
        local surplus_time = lastCDTime - current

        if self.Text_explore_time_n then
            self.Text_explore_time_n:setString(getRedAlertTimeActivityFormat(surplus_time))
        end

        -- 时间到，请求探索点
        if surplus_time <= 0 then
            self:requestSearchPoint()
        end
    end
end

function FileIslandWindow:requestSearchPoint()
    if self.isRefreshing == true then
        return
    end

    local function callback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

            if self.onUpdateDraw then
                self:onUpdateDraw()
            end

            self.isRefreshing = false
        end
    end

    self.isRefreshing = true
    protocol_command.refreshSearchPoint.param_list = ""
    NetworkManager:register(protocol_command.refreshSearchPoint.code, nil, nil, nil, nil, callback, false, nil)
end

function FileIslandWindow:isOpenSearchPanel()
    local eventId = -1
    if _ED.eventIds and table.nums(_ED.eventIds) > 0 then
        for i=3,5 do
            if _ED.eventIds[i] and table.nums(_ED.eventIds[i]) > 0 and _ED.fileIsland.resultInfo.curRewardIndex 
            and _ED.fileIsland.resultInfo.curRewardIndex > 0 and tonumber(_ED.fileIsland.resultInfo.curRewardIndex) == i then
                eventId = _ED.fileIsland.resultInfo.curRewardIndex
                break
            end
        end
    end
    if eventId > 0 then
        if tonumber(eventId) == 5 and table.nums(_ED.eventIds[eventId]) == 1 then
            state_machine.excute("fileIsland_one_finish_window_open", 0, tonumber(eventId))
        else
            state_machine.excute("fileIsland_all_finish_window_open", 0, tonumber(eventId))
        end
    end
end

function FileIslandWindow:onUpdateDraw()
    local root = self.roots[1]

    if _ED.fileIsland == nil then
        return
    end

    local searchPoint = tonumber(_ED.fileIsland.searchPoint)
    self.Text_explore_spot_n:setString(searchPoint .. "/20")

    -- 显示恢复倒计时
    if searchPoint < 20 then
        self.Text_explore_time_t:setVisible(true)
        self.Text_explore_time_n:setVisible(true)

    -- 隐藏恢复倒计时
    else
        self.Text_explore_time_t:setVisible(false)
        self.Text_explore_time_n:setVisible(false)
    end

	state_machine.excute("notification_center_update", 0, "push_notification_fileIsland_update_search_1_btn_push")
    state_machine.excute("notification_center_update", 0, "push_notification_fileIsland_update_search_all_btn_push")
end

function FileIslandWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/explore/explore.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_rule"), nil, 
    {
        terminal_name = "fileIsland_window_rule_window_open", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 商城
    local Button_explore_shop = ccui.Helper:seekWidgetByName(root, "Button_explore_shop")
    fwin:addTouchEventListener(Button_explore_shop, nil, 
    {
        terminal_name = "fileIsland_window_shop_open", 
        isPressedActionEnabled = true
    },
    nil, 0)

    local Panel_effect_shop = ccui.Helper:seekWidgetByName(root, "Panel_effect_shop")
    if Panel_effect_shop then
        local jsonFile = "images/ui/effice/effect_kdtxtssd/effect_kdtxtssd.json" 
        local atlasFile = "images/ui/effice/effect_kdtxtssd/effect_kdtxtssd.atlas" 
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation.animationNameList = {"animation"}
        sp.initArmature(animation, false)
        animation._invoke = changeActionCallback
        Panel_effect_shop:addChild(animation)
        animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(animation, 0, 1, false)
    end

    -- 好友任务
    self.friendIcon = ccui.Helper:seekWidgetByName(root, "Button_explore_friends")
    fwin:addTouchEventListener(self.friendIcon, nil, 
    {
        terminal_name = "fileIsland_window_friends_open_request_data", 
        isPressedActionEnabled = true
    },
    nil, 0)

    local Panel_effect_frends = ccui.Helper:seekWidgetByName(root, "Panel_effect_frends")
    if Panel_effect_frends then
        local jsonFile = "images/ui/effice/effect_kdtshyrw/effect_kdtshyrw.json" 
        local atlasFile = "images/ui/effice/effect_kdtshyrw/effect_kdtshyrw.atlas" 
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation.animationNameList = {"animation"}
        sp.initArmature(animation, false)
        animation._invoke = changeActionCallback
        Panel_effect_frends:addChild(animation)
        animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(animation, 0, 1, false)
    end

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_fileIsland_friend_icon_push",
        _widget = self.friendIcon,
        _invoke = nil,
        _interval = 0.5,})

    -- boss
    self.bossIcon = ccui.Helper:seekWidgetByName(root, "Button_explore_team_boss")
    fwin:addTouchEventListener(self.bossIcon, nil, 
    {
        terminal_name = "fileIsland_window_team_boss_open_request_data", 
        isPressedActionEnabled = true
    },
    nil, 0)

    local Panel_effect_team_boss = ccui.Helper:seekWidgetByName(root, "Panel_effect_team_boss") 
    if Panel_effect_team_boss then
        local jsonFile = "images/ui/effice/effect_kdtstdb/effect_kdtstdb.json" 
        local atlasFile = "images/ui/effice/effect_kdtstdb/effect_kdtstdb.atlas" 
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation.animationNameList = {"animation"}
        sp.initArmature(animation, false)
        animation._invoke = changeActionCallback
        Panel_effect_team_boss:addChild(animation)
        animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(animation, 0, 1, false)
    end

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_fileIsland_boss_icon_push",
        _widget = self.bossIcon,
        _invoke = nil,
        _interval = 0.5,})

    -- 圣物
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_holy_thing"), nil, 
    {
        terminal_name = "fileIsland_window_holy_thing_open_request_data", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 探索一次
    self.Button_explore_1 = ccui.Helper:seekWidgetByName(root, "Button_explore_1")
    fwin:addTouchEventListener(self.Button_explore_1, nil, 
    {
        terminal_name = "fileIsland_open_animation", 
        isPressedActionEnabled = true,
        openType = 1,
        node = self,
    },
    nil, 0)

    local Panel_effect_kdtxts = ccui.Helper:seekWidgetByName(root, "Panel_effect_kdtxts")
    if Panel_effect_kdtxts then
        local jsonFile = "images/ui/effice/effect_kdtxts/effect_kdtxts.json" 
        local atlasFile = "images/ui/effice/effect_kdtxts/effect_kdtxts.atlas" 
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation.animationNameList = {"animation"}
        sp.initArmature(animation, false)
        animation._invoke = changeActionCallback
        Panel_effect_kdtxts:addChild(animation)
        animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(animation, 0, 1, false)
    end

    -- 一键探索
    self.Button_explore_all = ccui.Helper:seekWidgetByName(root, "Button_explore_all")
    fwin:addTouchEventListener(self.Button_explore_all, nil, 
    {
        terminal_name = "fileIsland_open_animation", 
        isPressedActionEnabled = true,
        openType = 2,
        node = self,
    },
    nil, 0)

    if funOpenDrawTip(186, false) == true then
        self.Button_explore_all:setVisible(false)
        self.Button_explore_1:setPosition(root:getContentSize().width / 2, self.Button_explore_1:getPositionY())
    end

    local Panel_effect_kdtxyjts = ccui.Helper:seekWidgetByName(root, "Panel_effect_kdtxyjts")
    if Panel_effect_kdtxyjts then
        local jsonFile = "images/ui/effice/effect_kdtxyjts/effect_kdtxyjts.json" 
        local atlasFile = "images/ui/effice/effect_kdtxyjts/effect_kdtxyjts.atlas" 
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation.animationNameList = {"animation"}
        sp.initArmature(animation, false)
        animation._invoke = changeActionCallback
        Panel_effect_kdtxyjts:addChild(animation)
        animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(animation, 0, 1, false)
    end

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_fileIsland_update_search_1_btn_push",
        _widget = self.Button_explore_1,
        _invoke = nil,
        _interval = 0.5,})

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_fileIsland_update_search_all_btn_push",
        _widget = self.Button_explore_all,
        _invoke = nil,
        _interval = 0.5,})

    -- 购买探索点
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_buy"), nil, 
    {
        terminal_name = "FileIslandSearchPointBuy_open", 
        isPressedActionEnabled = true
    },
    nil, 0)


    self.jump_animation = cc.UserDefault:getInstance():getBoolForKey("FileIslandWindow_jump_animation", false)

    -- 跳过动画
    self.CheckBox_explore_fast_forward = ccui.Helper:seekWidgetByName(root, "CheckBox_explore_fast_forward")
    self.CheckBox_explore_fast_forward:setSelected(self.jump_animation)

    local function selectedEvent(sender, eventType)
        if eventType == ccui.CheckBoxEventType.selected then
            self.jump_animation = true
            cc.UserDefault:getInstance():setBoolForKey("FileIslandWindow_jump_animation", true)
        elseif eventType == ccui.CheckBoxEventType.unselected then
            self.jump_animation = false
            cc.UserDefault:getInstance():setBoolForKey("FileIslandWindow_jump_animation", false)
        end
    end
    self.CheckBox_explore_fast_forward:addEventListener(selectedEvent)

	-- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_maoxian_back"), nil, 
    {
        terminal_name = "fileIsland_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 探索点
    self.Text_explore_spot_n = ccui.Helper:seekWidgetByName(root, "Text_explore_spot_n")
    -- 恢复时间
    self.Text_explore_time_t = ccui.Helper:seekWidgetByName(root, "Text_explore_time_t")
    -- 恢复时间数
    self.Text_explore_time_n = ccui.Helper:seekWidgetByName(root, "Text_explore_time_n")

    local Panel_effect_explore = ccui.Helper:seekWidgetByName(root, "Panel_effect_explore")
    if Panel_effect_explore then
        local jsonFile = "images/ui/effice/effect_kdtszjm/effect_kdtszjm.json" 
        local atlasFile = "images/ui/effice/effect_kdtszjm/effect_kdtszjm.atlas" 
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation1", false, nil)
        animation.animationNameList = {"animation1", "animation2"}
        sp.initArmature(animation, false)

        local function changeActionCallback(armatureBack)

        end

        animation._invoke = changeActionCallback
        Panel_effect_explore:addChild(animation)
        animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(animation, 1, 1, false)
        self.animation = animation
    end

    self:onUpdateDraw()

    --一键探索未完成任务
    self:isOpenSearchPanel()

    -- 顶部用户信息
    app.load("client.l_digital.campaign.fileIsland.FileIslandShopBuyTop")                   
    local userinfo = FileIslandShopBuyTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

    self:reqFriendData()
    self:reqBossData()

end

function FileIslandWindow:onExit()
    state_machine.remove("fileIsland_window_close")
    state_machine.remove("fileIsland_window_onUpdateDraw")
	state_machine.remove("fileIsland_window_updateDraw_boss_redPoint")
    state_machine.remove("fileIsland_window_updateDraw_friend_redPoint")
    state_machine.remove("fileIsland_open_animation")
    state_machine.remove("fileIsland_window_friends_open_request_data")
    state_machine.remove("fileIsland_window_team_boss_open_request_data")
    state_machine.remove("fileIsland_window_holy_thing_open_request_data")
end

function FileIslandWindow:destroy(window)
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end

-- 请求boss信息，刷新boss icon红点
function FileIslandWindow:reqFriendData()
    local function callback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("notification_center_update", 0, "push_notification_fileIsland_friend_icon_push")
        end
    end
    protocol_command.fileIslandTaskInfo.param_list = ""
    NetworkManager:register(protocol_command.fileIslandTaskInfo.code, nil, nil, nil, nil, callback, false, nil)
end

-- 请求好友信息，刷新好友 icon红点
function FileIslandWindow:reqBossData()
    local function callback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("notification_center_update", 0, "push_notification_fileIsland_boss_icon_push")
        end
    end
    protocol_command.fileIslandBossInfo.param_list = ""
    NetworkManager:register(protocol_command.fileIslandBossInfo.code, nil, nil, nil, nil, callback, false, nil)
end
