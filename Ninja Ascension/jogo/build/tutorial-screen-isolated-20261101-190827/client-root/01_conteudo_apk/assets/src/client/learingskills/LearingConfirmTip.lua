-- ----------------------------------------------------------------------------------------------------
-- 说明：二级确认界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：李彪
-- 时间 : 04.19
-------------------------------------------------------------------------------------------------------
LearingConfirmTip = class("LearingConfirmTipClass", Window)
    
function LearingConfirmTip:ctor()
    self.super:ctor()
    self._instance = nil
    self._callback = nil
    self.pic_index = nil

    -- Initialize ConfirmTip state machine.
    local function init_learing_ConfirmTip_terminal()
		-- 界面确定按钮
        local learing_confirm_tip_ok_terminal = {
            _name = "learing_confirm_tip_ok",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._callback(instance._instance, 0)
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 界面取消按钮
        local learing_confirm_tip_cancel_terminal = {
            _name = "learing_confirm_tip_cancel",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._callback(instance._instance, 1)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(learing_confirm_tip_ok_terminal)
        state_machine.add(learing_confirm_tip_cancel_terminal)
        state_machine.init()
    end
    
    -- call func init ConfirmTip state machine.
    init_learing_ConfirmTip_terminal()
end

function LearingConfirmTip:onEnterTransitionFinish()
    local csbConfirmTip = csb.createNode("skills/skills_promt.csb")
    self:addChild(csbConfirmTip)
	
	local root = csbConfirmTip:getChildByName("root")
    local config = zstring.split(dms.string(dms["pirates_config"],231,pirates_config.param),"|")
	--提示文本

    local Text_zhuanshi = ccui.Helper:seekWidgetByName(root, "Text_zhuanshi")
    Text_zhuanshi:setString(config[4])
    local Panel_event_name_0 = ccui.Helper:seekWidgetByName(root, "Panel_event_name_0")
    Panel_event_name_0:setBackGroundImage(string.format("images/ui/skills_props/skills_event_%s.png",self.pic_index))
	local ok_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_queding"), nil, {
		terminal_name = "learing_confirm_tip_ok", 
		terminal_state = 1,
		taget = self,
		isPressedActionEnabled = true
		}, nil, 0)
	local cancel_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_quxiao"), nil, {
		terminal_name = "learing_confirm_tip_cancel", 
		terminal_state = 1,
		taget = self,
		isPressedActionEnabled = true
		}, nil, 0)
end

function LearingConfirmTip:init(instance, callback, pic_index)
	self._instance = instance
	self._callback = callback
	self.pic_index = pic_index
    return self
end

function LearingConfirmTip:onExit()
    state_machine.remove("learing_confirm_tip_ok")
    state_machine.remove("learing_confirm_tip_cancel")
	
end