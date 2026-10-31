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
		if params ~= nil then
			fwin:open(UnionCreate:new():init(params),fwin._taskbar)
		end	
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
            -- fwin:close(fwin:find("UserInformationShopClass"))
        end
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
	
	self.selectIndex = -1
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.union.Union")
    else
		app.load("client.union.Union")
	end
	 -- Initialize union create state machine.
    local function init_union_create_terminal()
		
		
		--创建军团
		local union_create_ensure_button_terminal = {
            _name = "union_create_ensure_button",
            _init = function (terminal)
                 app.load("client.utils.ConfirmTip")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local _window = fwin:find("UnionCreateClass")
            	if nil ~= _window and nil ~= _window.roots and nil ~= _window.roots[1] then
            		local _TextField = ccui.Helper:seekWidgetByName(_window.roots[1], "TextField_104")
            		if nil ~= _TextField then
            			_TextField:didNotSelectSelf()
            		end
            	end
            	local price = zstring.split(dms.string(dms["pirates_config"], 193, pirates_config.param), ",")[1]
				if zstring.tonumber(price) <= zstring.tonumber(_ED.user_info.user_gold) then
					instance:quxSureTip()
				else
					state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
					{
						terminal_name = "shortcut_open_recharge_window", 
						terminal_state = 0, 
						_msg = _string_piece_info[273], 
						_datas= 
						{

						}
					})
				end
                -- instance:onUpdateSendInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- -- 选择军团图标
        local union_create_select_terminal = {
            _name = "union_create_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.selectIndex = params._datas.selectIndex

                local but_bgImage = nil
                if terminal.page_name ~= nil then
                    but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                    if but_bgImage ~= nil then
                        but_bgImage:setVisible(false)
                    end
                end
                terminal.page_name = params._datas.but_image
                but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                if but_bgImage ~= nil then
                    but_bgImage:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(union_create_ensure_button_terminal)
		state_machine.add(union_create_select_terminal)
        state_machine.init()
    end
    
    -- call func init union create state machine.
    init_union_create_terminal()

end
function UnionCreate:quxSureTip()
	if self.selectIndex ~= -1 then
		local tip = ConfirmTip:new()
		local config = zstring.split(dms.string(dms["pirates_config"], 193, pirates_config.param), ",")
		tip:init(self, self.onUpdateSendInfo, string.format(tipStringInfo_union_str[39],config[1]))
		fwin:open(tip,fwin._ui)
	else
		TipDlg.drawTextDailog(tipStringInfo_union_str[21])
	end	
end

function UnionCreate:onUpdateSendInfo(n)
	if n ~= 0 then
		return 
	end	
	if  self.roots == nil or self.roots[1] == nil then
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
		if self.selectIndex ~= -1 then
			local function responseUnionCreateCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
                        local function responseCallback(response)
                        	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							        app.load("client.l_digital.union.UnionTigerGate")
							    else
		                        	app.load("client.union.UnionTigerGate")
		                        end	
	                        	state_machine.excute("Union_open", 0, response.node)
	                        end
                        end
                        NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, response.node, responseCallback, false, nil)     
                    else
                        app.load("client.union.Union")
    					state_machine.excute("Union_open", 0, response.node)
                    end
                    local function responseUnionFightCallback( response )
                    end
                    if _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
	                    protocol_command.unino_fight_init.param_list = _ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number
						NetworkManager:register(protocol_command.unino_fight_init.code, _ED.union_fight_url, nil, nil, nil, responseUnionFightCallback, false, nil)
					end
					TipDlg.drawTextDailog(tipStringInfo_union_str[40])
				end
			end
			protocol_command.union_create.param_list = str.."\r\n"..self.selectIndex
			NetworkManager:register(protocol_command.union_create.code, nil, nil, nil, self, responseUnionCreateCallback, false, nil)
			-- text:setString("")
		else
			-- TipDlg.drawTextDailog("请选择军团图标")
			TipDlg.drawTextDailog(tipStringInfo_union_str[21])
		end
	else
		-- TipDlg.drawTextDailog("请输入军团名称")
		TipDlg.drawTextDailog(tipStringInfo_union_str[22])
	end
end
	
function UnionCreate:updateDraw()
	local root = self.roots[1]
	local config = zstring.split(dms.string(dms["pirates_config"], 193, pirates_config.param), ",")
	ccui.Helper:seekWidgetByName(root, "Text_4_012"):setString(config[1])
end

function UnionCreate:onInit()
	local csbUnionCreate = csb.createNode("legion/legion_create.csb")
    local root = csbUnionCreate:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionCreate)
	
	self:updateDraw()
	
	local text = ccui.Helper:seekWidgetByName(root, "TextField_104")
	if verifySupportLanguage(_lua_release_language_en) == true then
		draw:addEditBox(text, _string_piece_info[341], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_50343"), 12, cc.KEYBOARD_RETURNTYPE_DONE)
	else
		draw:addEditBox(text, _string_piece_info[341], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_50343"), 6, cc.KEYBOARD_RETURNTYPE_DONE)
	end
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
	
	 for i = 1, 3 do          -- 根据物品数量添加响应
		local butimage = "Image_14"
		for n=2,i do
			butimage = butimage.."_0"
		end
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_30_"..i),       nil, 
        {
            terminal_name = "union_create_select",     
            but_image = butimage,
            terminal_state = 0, 
            cell = self,
            selectIndex = i,
            isPressedActionEnabled = false
        }, 
        nil, 0)
    end
	
	
	 -- 关闭界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5231"), nil, 
    {
        terminal_name = "union_create_close", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0) 
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1023"), nil, 
    {
        terminal_name = "union_create_close", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0) 
	-- 创建
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_50343"), nil, 
    {
        terminal_name = "union_create_ensure_button", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function UnionCreate:onEnterTransitionFinish()
	app.load("client.player.UserInformationShop") 					--顶部用户信息
	local userinfo = fwin:find("UserInformationShopClass")
	if userinfo == nil then
		fwin:open(UserInformationShop:new(),fwin._view)
	end
end

function UnionCreate:init()
	self:onInit()
	return self
end

function UnionCreate:onExit()
	state_machine.remove("union_create_ensure_button")
end