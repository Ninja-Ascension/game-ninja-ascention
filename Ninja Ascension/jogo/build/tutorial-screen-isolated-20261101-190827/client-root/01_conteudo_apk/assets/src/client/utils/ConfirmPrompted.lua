-- ----------------------------------------------------------------------------------------------------
-- 说明：二级确认界面 系统提示 --龙虎门用于vip礼包
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：李彪
-- 时间 : 04.19
-------------------------------------------------------------------------------------------------------
ConfirmPrompted = class("ConfirmPromptedClass", Window)
    
function ConfirmPrompted:ctor()
    self.super:ctor()
    self._instance = nil
    self._callback = nil
    self._txt = ""
    self.params = nil -- {terminal_name = "", terminal_state = 0, _msg = "", _datas= {}}
	self.roots = {}
	self.actions = {}
	self._buy_mould = nil
    -- Initialize ConfirmPrompted state machine.
    local function init_ConfirmPrompted_terminal()
		-- 界面确定按钮
        local confirm_prompted_ok_terminal = {
            _name = "confirm_prompted_ok",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                instance._callback(instance._instance, 0, instance._buy_mould)
				
				instance.actions[1]:play("window_close", false)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 界面取消按钮
        local confirm_prompted_cancel_terminal = {
            _name = "confirm_prompted_cancel",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
               instance._callback(instance._instance, 1)
               
			   instance.actions[1]:play("window_close", false)
			   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(confirm_prompted_ok_terminal)
        state_machine.add(confirm_prompted_cancel_terminal)
        state_machine.init()
    end
    
    -- call func init ConfirmPrompted state machine.
    init_ConfirmPrompted_terminal()
end

function ConfirmPrompted:onEnterTransitionFinish()
    local csbConfirmPrompted = csb.createNode("utils/prompted_1.csb")
    self:addChild(csbConfirmPrompted)
	
	local root = csbConfirmPrompted:getChildByName("root")
	table.insert(self.roots, root)

	local action = csb.createTimeline("utils/prompted_1.csb")
	table.insert(self.actions, action)
	csbConfirmPrompted:runAction(action)
	action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end
		
		local str = frame:getEvent()
		if str == "close" then
			fwin:close(self)
		end
	end)
	action:play("window_open", false)

	--提示文本
    local drawText = self._txt
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_red_alert 
        or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
        then
    	ccui.Helper:seekWidgetByName(root, "Text_money"):setString(drawText or " ")
    	ccui.Helper:seekWidgetByName(root,"Text_vip_name"):setString(self._buy_mould.mould_name)
    else
    	ccui.Helper:seekWidgetByName(root, "Text_2_4"):setString(drawText or " ")
    end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103_0_4"), nil, {
		terminal_name = "confirm_prompted_ok", 
		terminal_state = 1,
		taget = self,
		isPressedActionEnabled = true
		}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103_2"), nil, {
		terminal_name = "confirm_prompted_cancel", 
		terminal_state = 1,
		taget = self,
		isPressedActionEnabled = true
		}, nil, 2)

end

function ConfirmPrompted:init(instance, callback, txt ,buy_mould)
	self._instance = instance
	self._callback = callback
	self._txt = txt
	self._buy_mould = buy_mould
    return self
end

function ConfirmPrompted:onExit()
	state_machine.remove("confirm_prompted_ok")
	state_machine.remove("confirm_prompted_cancel")
	state_machine.remove("confirm_prompted_close")
	
end