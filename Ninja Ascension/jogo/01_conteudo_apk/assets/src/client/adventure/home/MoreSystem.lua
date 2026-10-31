-- ----------------------------------------------------------------------------------------------------
-- 说明： "更多" 窗口
-- 点击主界面中更多按钮弹出窗口
-------------------------------------------------------------------------------------------------------
MoreSystem = class("MoreSystemClass", Window)
    
function MoreSystem:ctor()
    self.super:ctor()
    self.roots = {}
	self.goodsInfoList = {}

	local function init_more_system_terminal()
	
		-- 设置
	   local more_system_set_terminal = {
            _name = "more_sytem_set",
            _init = function (terminal)
                app.load("client.adventure.system.set.AdventureSet")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("MoreSystemClass"))
                fwin:open(AdventureSet:new():init(), fwin._dialog)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 公告
		local more_notice_terminal = {
            _name = "more_notice",
            _init = function (terminal)
                app.load("client.adventure.system.notice.AdventureNotice")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("MoreSystemClass"))
                fwin:open(AdventureNotice:new():init(2), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 讨论区
		local more_talk_area_terminal = {
             _name = "more_talk_area",
            _init = function (terminal)
                --app.load("client.adventure.system.forums.AdventureForums")
                app.load("client.adventure.chat.AdventureChatStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureChatStorage:new(), fwin._windows)
				-- fwin:close(fwin:find("MoreSystemClass"))
    --             state_machine.excute("menu_clean_page_state", 0,"")
    --             state_machine.excute("menu_adventure_open_button", 0,"")
    --             fwin:open(AdventureForums:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 礼包
		local more_gift_bag_terminal = {
      _name = "more_gift_bag",
            _init = function (terminal)
                app.load("client.adventure.activity.reward.AdventureRewardCenter")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("MoreSystemClass"))
                fwin:open(AdventureRewardCenter:new():init(), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		  -- 签到
        local more_sign_in_terminal = {
            _name = "more_sign_in",
            _init = function (terminal)
                app.load("client.adventure.activity.sign.AdventureDailySignIn")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("MoreSystemClass"))
                fwin:open(AdventureDailySignIn:new():init(), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 成就
		  local more_achievement_terminal = {
            _name = "more_achievement",
            _init = function (terminal)
                app.load("client.adventure.achievement.AdventureAchievement")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("MoreSystemClass"))
                state_machine.excute("menu_clean_page_state", 0,"")
                state_machine.excute("menu_adventure_open_button", 0,"")
                fwin:open(AdventureAchievement:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 选择语言
        local more_talk_xuanze_yuyan_terminal = {
            _name = "more_talk_xuanze_yuyan",
            _init = function (terminal)
                app.load("client.adventure.home.MoreSystemChooseLanguage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(MoreSystemChooseLanguage:new():init(2), fwin._view)
                fwin:close(fwin:find("MoreSystemClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


	 state_machine.add(more_system_set_terminal)
	 state_machine.add(more_notice_terminal)
	 state_machine.add(more_talk_area_terminal)
	 state_machine.add(more_gift_bag_terminal)
	 state_machine.add(more_sign_in_terminal)
	 state_machine.add(more_achievement_terminal)
     state_machine.add(more_talk_xuanze_yuyan_terminal)
	 state_machine.init()
	end  	 
	init_more_system_terminal()
end

function MoreSystem:init()
	return self
end

function MoreSystem:onUpdateDraw()

end

function MoreSystem:onEnterTransitionFinish()
	
    local csbMoreSystem = csb.createNode("home/home_more.csb")
    local root = csbMoreSystem:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbMoreSystem)

	self:onUpdateDraw()
		
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("MoreSystemClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 讨论区
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_taolunqu"),       nil, 
    {
        terminal_name = "more_talk_area",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    local languageButton = ccui.Helper:seekWidgetByName(root, "Button_xuanzeyuyan")
    if zstring.tonumber(_game_platform_version_type) == 4 then 
        languageButton:setVisible(true)
    else
        if languageButton ~= nil then 
            languageButton:setVisible(false)
        end
    end

    -- 选择语言
    fwin:addTouchEventListener(languageButton,       nil, 
    {
        terminal_name = "more_talk_xuanze_yuyan",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	-- 礼包
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_libao"),       nil, 
    {
        terminal_name = "more_gift_bag",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_adventure_home_giftbag",
     _widget = ccui.Helper:seekWidgetByName(root, "Button_libao"),
     _invoke = nil,
     _interval = 0.5,})
	 
	-- 设置
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shezhi"),       nil, 
    {
        terminal_name = "more_sytem_set",    
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	-- 签到
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qiandao"),       nil, 
    {
        terminal_name = "more_sign_in",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_adventure_sign_in",
     _widget = ccui.Helper:seekWidgetByName(root, "Button_qiandao"),
     _invoke = nil,
     _interval = 0.5,})

	-- 成就
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chengjiu"),       nil, 
    {
        terminal_name = "more_achievement",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_adventure_achievement_update",
 --     _widget = ccui.Helper:seekWidgetByName(root, "Button_chengjiu"),
 --     _invoke = nil,
 --     _interval = 0.5,})
		
	
	-- 公告
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gonggao"),       nil, 
    {
        terminal_name = "more_notice",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function MoreSystem:onExit()
	state_machine.remove("more_sytem_set")
	state_machine.remove("more_notice")
	state_machine.remove("more_talk_area")
	state_machine.remove("home_gift_bag")
	state_machine.remove("more_sign_in")
	state_machine.remove("more_achievement")
    state_machine.remove("more_talk_xuanze_yuyan")
end