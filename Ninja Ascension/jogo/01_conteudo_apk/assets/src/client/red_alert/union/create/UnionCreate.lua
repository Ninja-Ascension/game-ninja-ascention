--------------------------------------------------------------------------------------------------------------
--  说明：创建军团界面
--------------------------------------------------------------------------------------------------------------
UnionCreate = class("UnionCreateClass", Window)

--打开界面
local union_create_open_terminal = {
	_name = "union_create_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(UnionCreate:new():init(), fwin._view)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local union_create_close_terminal = {
	_name = "union_create_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if params ~= nil then
            fwin:close(fwin:find("UnionCreateClass"))
        end

        -- clear cacher
        cacher.clearWindowCacher()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(union_create_open_terminal)
state_machine.add(union_create_close_terminal)
state_machine.init()

function UnionCreate:ctor()
	self.super:ctor()
	self.roots = {}
	
	app.load("client.red_alert.union.Union")
    app.load("client.utils.ConfirmTip")

    local function init_union_create_terminal()
		local union_create_ensure_button_terminal = {
            _name = "union_create_ensure_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        		local _TextField = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_104")
        		if nil ~= _TextField then
        			_TextField:didNotSelectSelf()
        		end
        		local cost = dms.int(dms["union_config"], 21, union_config.param)
				if zstring.tonumber(cost) <= zstring.tonumber(_ED.user_info.user_gold) then
					instance:quxSureTip()
				else
					state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
					{
						terminal_name = "shortcut_open_recharge_window", 
						terminal_state = 0, 
						_msg = red_alert_all_str[185], 
						_datas= 
						{
						}
					})
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_create_ensure_button_terminal)
        state_machine.init()
    end
    init_union_create_terminal()
end

function UnionCreate:quxSureTip()
	local tip = ConfirmTip:new()
	local cost = dms.int(dms["union_config"], 21, union_config.param)
	tip:init(self, self.onUpdateSendInfo, string.format(tipStringInfo_union_str[39], cost))
	fwin:open(tip, fwin._ui)
end

function UnionCreate:onUpdateSendInfo(n)
	if n ~= 0 then
		return 
	end	
	if self.roots == nil or self.roots[1] == nil then
		return
	end
	local root = self.roots[1]

	local text = ccui.Helper:seekWidgetByName(root, "TextField_104")
	if zstring.checkNikenameChar(text:getString()) == true then
		TipDlg.drawTextDailog(tipStringInfo_union_str[37])
		return
	end
	local str = zstring.exchangeTo(text:getString())
	
	if text:getString() ~= "" then
		local function responseUnionCreateCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if response.node ~= nil and response.node.roots ~= nil then
            		state_machine.excute("union_open", 0, response.node)
            	end
				TipDlg.drawTextDailog(tipStringInfo_union_str[40])
			end
		end
		protocol_command.union_create.param_list = str
		NetworkManager:register(protocol_command.union_create.code, nil, nil, nil, self, responseUnionCreateCallback, false, nil)
	else
		TipDlg.drawTextDailog(tipStringInfo_union_str[22])
	end
end
	
function UnionCreate:updateDraw()
	local root = self.roots[1]
	local cost = dms.int(dms["union_config"], 21, union_config.param)
	ccui.Helper:seekWidgetByName(root, "Text_4_012"):setString(""..cost)
end

function UnionCreate:onInit()
	local csbItem = csb.createNode(config_csb.legion.legion_create)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

	self:updateDraw()
	
	local text = ccui.Helper:seekWidgetByName(root, "TextField_104")
	local Button_50343 = ccui.Helper:seekWidgetByName(root, "Button_50343")

	
	local max_length = dms.int(dms["union_config"], 25, union_config.param)
	draw:addEditBox(text, chat_sent_string[3], "effect/effice_1500.png", Button_50343, max_length, cc.KEYBOARD_RETURNTYPE_DONE)
	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	if cc.PLATFORM_OS_IPHONE == targetPlatform
		or cc.PLATFORM_OS_IPAD == targetPlatform
		or true
		then
		local _TextField = text
		if nil ~= _TextField and nil == _TextField.onNodeEvent then
			_TextField.onNodeEvent = function (event)
		        if event == "exitTransitionStart" then
					_TextField:didNotSelectSelf()
		        end
		    end
			_TextField:registerScriptHandler(_TextField.onNodeEvent)
		end
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1023"), nil, 
    {
        terminal_name = "union_create_close", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(Button_50343, nil, 
    {
        terminal_name = "union_create_ensure_button", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function UnionCreate:onEnterTransitionFinish()

end

function UnionCreate:init()
	self:onInit()
	return self
end

function UnionCreate:onExit()
	state_machine.remove("union_create_ensure_button")
end