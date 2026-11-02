-- ----------------------------------------------------------------------------------------------------
-- 说明：账号别处登录确认界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-- 时间 : 
-------------------------------------------------------------------------------------------------------
LoginOfOtherTip = class("LoginOfOtherTipClass", Window)

local logout_tip_window_open_terminal = {
    _name = "logout_tip_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if __lua_project_id == __lua_project_red_alert_time 
            or __lua_project_id == __lua_project_pacific_rim 
            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            or __lua_project_id == __lua_project_l_naruto 
            then
            if nil ~= fwin:find("ReconnectViewClass") then
                return false
            end
        end
        if _ED.user_info ~= nil and _ED.user_info.user_id ~= "" then
        	fwin:close("LoginOfOtherTipClass")
        	fwin:open(LoginOfOtherTip:new():init(), fwin._system)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local logout_tip_window_close_terminal = {
    _name = "logout_tip_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close("LoginOfOtherTipClass")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(logout_tip_window_open_terminal)
state_machine.add(logout_tip_window_close_terminal)
state_machine.init()

function LoginOfOtherTip:ctor()
	closeLastWindow("LoginOfOtherTipClass")
	
    self.super:ctor()
    self._instance = nil
    self._callback = nil
    self._txt = ""
    self.params = nil -- {terminal_name = "", terminal_state = 0, _msg = "", _datas= {}}

    -- Initialize LoginOfOtherTip state machine.
    local function init_LoginOfOtherTip_terminal()
		-- 界面确定按钮
        local login_of_other_tip_ok_terminal = {
            _name = "login_of_other_tip_ok",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_red_alert_time 
                    or __lua_project_id == __lua_project_pacific_rim 
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                    or __lua_project_id == __lua_project_l_naruto 
                    then
                else
            	   initialize_ed()
                end
				local platformloginInfo = {
					platform_id="",
					register_type="",
					platform_account="",
					nickname="",		
					password="",
					is_registered = false
					}
				_ED.user_platform = {}
				_ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
				_ED.default_user = platformloginInfo.platform_account
				fwin:removeAll()
				cacher.destoryRefPools()
				cacher.cleanSystemCacher()
				cacher.cleanActionTimeline()
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					checkTipBeLeave()
				end

				cacher.remvoeUnusedArmatureFileInfoes()
				fwin:reset(nil)
				fwin:open(Login:new(), fwin._view)
				fwin:close(fwin:find("LoginOfOtherTipClass"))
				_ED.m_is_games = false
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(login_of_other_tip_ok_terminal)
       
        state_machine.init()
    end
    
    -- call func init LoginOfOtherTip state machine.
    init_LoginOfOtherTip_terminal()
end

function LoginOfOtherTip:onEnterTransitionFinish()
    local csbLoginOfOtherTip = csb.createNode("utils/tuichu_zhanghao.csb")
    self:addChild(csbLoginOfOtherTip)
	
	local root = csbLoginOfOtherTip:getChildByName("root")

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5328"), nil, {
		terminal_name = "login_of_other_tip_ok", 
		terminal_state = 1,
		taget = self,
		isPressedActionEnabled = true
		}, nil, 0)

end

function LoginOfOtherTip:init(instance, callback, txt, params)
	self._instance = instance
	self._callback = callback
	self._txt = txt
    self.params = params
    return self
end

function LoginOfOtherTip:onExit()
	state_machine.remove("login_of_other_tip_ok")
end