-----------------------------
-- 公会的创建的page
-----------------------------
SmUnionFormPage = class("SmUnionFormPageClass", Window)
SmUnionFormPage.__size = nil

local sm_union_form_page_open_terminal = {
    _name = "sm_union_form_page_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmUnionFormPage:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_form_page_open_terminal)
state_machine.init()

function SmUnionFormPage:ctor()
    self.super:ctor()
    self.roots = {}

    self.prop_list = {}
    self.m_index = 1
    app.load("client.l_digital.union.meeting.UnionTheMeetingChangeSign")
    local function init_sm_union_form_page_terminal()
		--显示界面
		local sm_union_form_page_show_terminal = {
            _name = "sm_union_form_page_show",
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
		--隐藏界面
		local sm_union_form_page_hide_terminal = {
            _name = "sm_union_form_page_hide",
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

        --创建军团
        local sm_union_create_ensure_button_terminal = {
            _name = "sm_union_create_ensure_button",
            _init = function (terminal)
                 app.load("client.utils.ConfirmTip")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local text = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_input_name")
                if getDefaultLanguage() == "Ko" then
                else
                    if zstring.checkNikenameChar(text:getString()) == true then
                        TipDlg.drawTextDailog(tipStringInfo_union_str[37])
                        return
                    end
                end
                if tonumber(_ED.user_info.user_grade) < dms.int(dms["fun_open_condition"], 141, fun_open_condition.level) then
                    TipDlg.drawTextDailog(_new_interface_text[29])
                end
                
                local str = zstring.exchangeTo(text:getString())

                if getDefaultLanguage() == "Ko" then
                else
                    if instance:filter_spec_chars(str) == true then
                        TipDlg.drawTextDailog(_new_interface_text[44])
                        return
                    end
                end

                local price = dms.string(dms["union_config"], 1, union_config.param)
                if zstring.tonumber(price) <= zstring.tonumber(_ED.user_info.user_gold) then
                    local function responseUnionCreateCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
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
                            local function responseUnionFightCallback( response )
                            end
                            if _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
                                protocol_command.unino_fight_init.param_list = _ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number
                                NetworkManager:register(protocol_command.unino_fight_init.code, _ED.union_fight_url, nil, nil, nil, responseUnionFightCallback, false, nil)
                            end
                            TipDlg.drawTextDailog(tipStringInfo_union_str[40])
                        end
                    end
                    protocol_command.union_create.param_list = str.."\r\n"..instance.m_index
                    NetworkManager:register(protocol_command.union_create.code, nil, nil, nil, instance, responseUnionCreateCallback, false, nil)
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

        --刷新界面
        local sm_union_form_page_update_draw_terminal = {
            _name = "sm_union_form_page_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance.m_index = params
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --进入设置icon界面
        local sm_union_form_page_open_icon_set_terminal = {
            _name = "sm_union_form_page_open_icon_set",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("union_the_meeting_change_sign_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        
		state_machine.add(sm_union_form_page_show_terminal)	
        state_machine.add(sm_union_form_page_hide_terminal)
        state_machine.add(sm_union_create_ensure_button_terminal)
        state_machine.add(sm_union_form_page_update_draw_terminal)
		state_machine.add(sm_union_form_page_open_icon_set_terminal)

        state_machine.init()
    end
    init_sm_union_form_page_terminal()
end

function SmUnionFormPage:onHide()
    self:setVisible(false)
end

function SmUnionFormPage:onShow()
    self:setVisible(true)
end

function SmUnionFormPage:filter_spec_chars(s)  
    local k = 1
    while k <= #s do
        local c = string.byte(s,k)  
        if not c then break end  
        if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then  
        elseif c>=228 and c<=233 then  
            local c1 = string.byte(s,k+1)  
            local c2 = string.byte(s,k+2)  
            if c1 and c2 then  
                local a1,a2,a3,a4 = 128,191,128,191  
                if c == 228 then a1 = 184  
                elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165  
                end  
                if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then  
                    k = k + 2      
                end  
            end  
        else
            return true  
        end 
        k = k + 1 
    end  
    return false
end  

function SmUnionFormPage:onUpdateDraw()
    local root = self.roots[1]
    local price = dms.string(dms["union_config"], 1, union_config.param)
    local Text_cost_n = ccui.Helper:seekWidgetByName(root, "Text_cost_n")
    Text_cost_n:setString(price)
    local price = dms.string(dms["union_config"], 1, union_config.param)
    if zstring.tonumber(price) <= zstring.tonumber(_ED.user_info.user_gold) then
        Text_cost_n:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))

        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital then
            if tipStringInfo_color_type_assemble ~= nil then
                Text_cost_n:setColor(cc.c3b(tipStringInfo_color_type_assemble[9][1],tipStringInfo_color_type_assemble[9][2],tipStringInfo_color_type_assemble[9][3]))
            end
        end
    else
        Text_cost_n:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    end

    local Panel_legion_logo = ccui.Helper:seekWidgetByName(root, "Panel_legion_logo")
    Panel_legion_logo:removeBackGroundImage()
    Panel_legion_logo:setBackGroundImage(string.format("images/ui/union_logo/union_logo_%d.png", tonumber(self.m_index)))
end

function SmUnionFormPage:onUpdate(dt)
    
end

function SmUnionFormPage:onEnterTransitionFinish()

end

function SmUnionFormPage:onInit( )
    local csbItem = csb.createNode("legion/sm_legion_list_tab_2.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local text = ccui.Helper:seekWidgetByName(root, "TextField_input_name")
    draw:addEditBox(text, _string_piece_info[341], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Image_ghm_bg"), 6, cc.KEYBOARD_RETURNTYPE_DONE)

    if SmUnionFormPage.__size == nil then
        SmUnionFormPage.__size = root:getContentSize()
    end
    self:setContentSize(SmUnionFormPage.__size)

    self:onUpdateDraw()

    
    -- 更换图标
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change"), nil, 
    {
        terminal_name = "sm_union_form_page_open_icon_set", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 创建军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_from_gh"), nil, 
    {
        terminal_name = "sm_union_create_ensure_button", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function SmUnionFormPage:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmUnionFormPage:onExit()
    state_machine.remove("sm_union_form_page_show")    
    state_machine.remove("sm_union_form_page_hide")
end


