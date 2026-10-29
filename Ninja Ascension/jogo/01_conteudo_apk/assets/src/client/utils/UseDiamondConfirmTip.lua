-- ----------------------------------------------------------------------------------------------------
-- 说明：花费钻石二级确认界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：吴平涛
-- 时间 : 04.19
-------------------------------------------------------------------------------------------------------
UseDiamondConfirmTip = class("UseDiamondConfirmTipClass", Window)

--打开界面
local use_diamond_confirm_tip_open_terminal = {
    _name = "use_diamond_confirm_tip_open",
    _init = function (terminal)
		-- 今日不再提醒
    	-- cc.UserDefault:getInstance():setStringForKey(getKey("use_diamond_confirm_tip_open_unopen_data"), "")
        local server_date = os.date("%x", _ED.system_time)
        local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("use_diamond_confirm_tip_open_unopen_data"), "")
        if save_date == server_date then
            terminal.unopen = true
        else
            terminal.unopen = false
        end
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local UseDiamondConfirmTipWindow = fwin:find("UseDiamondConfirmTipClass")
        if UseDiamondConfirmTipWindow ~= nil and UseDiamondConfirmTipWindow:isVisible() == true then
            return true
        end
		if params._datas ~= nil then
			state_machine.lock("use_diamond_confirm_tip_open", 0, "")
			local data = params._datas
			fwin:open(UseDiamondConfirmTip:createCell():init(data[1],data[2],data[3],data[4]), fwin._dialog)  -- self 回调函数 显示TEXT 回调状态机
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local use_diamond_confirm_tip_close_terminal = {
    _name = "use_diamond_confirm_tip_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        UseDiamondConfirmTip:closeCell()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(use_diamond_confirm_tip_open_terminal)
state_machine.add(use_diamond_confirm_tip_close_terminal)
state_machine.init()

function UseDiamondConfirmTip:ctor()
    self.super:ctor()
    self._instance = nil
    self._callback = nil
    self._txt = ""
    self.params = nil -- {terminal_name = "", terminal_state = 0, _msg = "", _datas= {}}
    self.lock = false
    -- Initialize UseDiamondConfirmTip state machine.
    local function init_UseDiamondConfirmTip_terminal()
		-- 界面确定按钮
        local  use_diamond_confirm_tip_ok_terminal = {
            _name = "use_diamond_confirm_tip_ok",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.params ~= nil then
                    instance.lock = true
                    state_machine.excute(instance.params._datas.terminal_name, instance.params._datas.terminal_state, {status = 1, _datas = instance.params._datas})
				else
                    instance._callback(instance._instance, 0)
				    fwin:close(instance)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 界面取消按钮
        local use_diamond_confirm_tip_cancel_terminal = {
            _name = "use_diamond_confirm_tip_cancel",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                -- if instance.params ~= nil then
                    -- state_machine.excute(instance.params._datas.terminal_name, instance.params._datas.terminal_state, {status = 2, _datas = instance.params._datas})
                -- else
                --     instance._callback(instance._instance, 1)
                -- end
                if instance._callback ~= nil then
                    instance._callback(instance._instance, 1)
                end
			    if instance.lock == false then
				    fwin:close(instance)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--今天可开启状态
		local use_diamond_confirm_tip_unopen_status_terminal = {
            _name = "use_diamond_confirm_tip_unopen_status",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local checkBox = params
            	local window_terminal = state_machine.find("use_diamond_confirm_tip_open")
            	if window_terminal.unopen == true then
            		window_terminal.unopen = false
            		cc.UserDefault:getInstance():setStringForKey(getKey("use_diamond_confirm_tip_open_unopen_data"), "")
            	else
            		window_terminal.unopen = true
	            	local server_date = os.date("%x", _ED.system_time)
	            	cc.UserDefault:getInstance():setStringForKey(getKey("use_diamond_confirm_tip_open_unopen_data"), server_date)
			    end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(use_diamond_confirm_tip_ok_terminal)
        state_machine.add(use_diamond_confirm_tip_cancel_terminal)
		state_machine.add(use_diamond_confirm_tip_unopen_status_terminal)
        state_machine.init()
    end
    
    -- call func init UseDiamondConfirmTip state machine.
    init_UseDiamondConfirmTip_terminal()
end
function UseDiamondConfirmTip:onInit()
	-- self:updateDraw()
	local csbUseDiamondConfirmTip = csb.createNode("utils/prompt_4.csb")
    self:addChild(csbUseDiamondConfirmTip)
	
	local root = csbUseDiamondConfirmTip:getChildByName("root")
	
	
	--提示文本
    local drawText = ""
    if self.params ~= nil and self.params._msg ~= nil then
        drawText = self.params._msg
    elseif self._txt ~= nil and self._txt ~= "" then
	    drawText = self._txt   
    end
	local strT = zstring.zsplit(drawText, "|")
	if #strT > 1 then
		-- Text_1_22252
		ccui.Helper:seekWidgetByName(root, "Text_1_22252"):setString(strT[1] or " ")
		ccui.Helper:seekWidgetByName(root, "Text_1_22253"):setString(strT[2] or " ")
	else
		ccui.Helper:seekWidgetByName(root, "Text_1_22254"):setString(strT[1] or " ")
	end
    -- ccui.Helper:seekWidgetByName(root, "Text_141"):setString(drawText or " ")

	local ok_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_6"), nil, {
		terminal_name = "use_diamond_confirm_tip_ok", 
		terminal_state = 1,
		taget = self,
		isPressedActionEnabled = true
		}, nil, 0)
	local cancel_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4_8"), nil, {
		terminal_name = "use_diamond_confirm_tip_cancel", 
		terminal_state = 1,
		taget = self,
		isPressedActionEnabled = true
		}, nil, 0)
	local cancel_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2_pu2_15"), nil, {
		terminal_name = "use_diamond_confirm_tip_cancel", 
		terminal_state = 1,
		taget = self
		}, nil, 0)
		
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_2"), nil, 
	{
		terminal_name = "use_diamond_confirm_tip_unopen_status", 
		terminal_state = 0, 
	},
	nil,0)
		
	state_machine.unlock("use_diamond_confirm_tip_open", 0, "")
end

function UseDiamondConfirmTip:onEnterTransitionFinish()
    
end

function UseDiamondConfirmTip:init(instance, callback, txt, params)
	self._instance = instance
	self._callback = callback
	self._txt = txt
    self.params = params
	self:onInit()
    return self
end

function UseDiamondConfirmTip:onExit()
	state_machine.remove("use_diamond_confirm_tip_ok")
	state_machine.remove("use_diamond_confirm_tip_cancel")
	state_machine.remove("use_diamond_confirm_tip_unopen_status")
end

function UseDiamondConfirmTip:createCell( ... )
    local cell = UseDiamondConfirmTip:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function UseDiamondConfirmTip:closeCell( ... )
    local UseDiamondConfirmTipWindow = fwin:find("UseDiamondConfirmTipClass")
    if UseDiamondConfirmTipWindow == nil then
        return
    end
    fwin:close(UseDiamondConfirmTipWindow)
end
