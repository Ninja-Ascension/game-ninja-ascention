-- ----------------------------------------------------------------------------------------------------
-- 说明：公会修改名称
-------------------------------------------------------------------------------------------------------
SmUnionChangeName = class("SmUnionChangeNameClass", Window)

local sm_union_change_name_window_open_terminal = {
    _name = "sm_union_change_name_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionChangeNameClass")
        if nil == _homeWindow then
            local panel = SmUnionChangeName:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_change_name_window_close_terminal = {
    _name = "sm_union_change_name_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionChangeNameClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionChangeNameClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_change_name_window_open_terminal)
state_machine.add(sm_union_change_name_window_close_terminal)
state_machine.init()
    
function SmUnionChangeName:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    local function init_sm_union_change_name_window_terminal()
        -- 显示界面
        local sm_union_change_name_window_display_terminal = {
            _name = "sm_union_change_name_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionChangeNameWindow = fwin:find("SmUnionChangeNameClass")
                if SmUnionChangeNameWindow ~= nil then
                    SmUnionChangeNameWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_change_name_window_hide_terminal = {
            _name = "sm_union_change_name_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionChangeNameWindow = fwin:find("SmUnionChangeNameClass")
                if SmUnionChangeNameWindow ~= nil then
                    SmUnionChangeNameWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 修改名称
        local sm_union_change_name_window_modify_the_name_terminal = {
            _name = "sm_union_change_name_window_modify_the_name",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local price = dms.int(dms["union_config"], 15, union_config.param)
                if price > tonumber(_ED.user_info.user_gold) then
                    state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                    {
                        terminal_name = "shortcut_open_recharge_window", 
                        terminal_state = 0, 
                        _msg = _string_piece_info[316], 
                        _datas= 
                        {

                        }
                    })
                    return
                end 

                local text = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_gg_xinxi")
                text:didNotSelectSelf()
                local codes = text:getString()
                if codes == nil or codes == "" or string.len(codes) == 0 then
                    TipDlg.drawTextDailog(_string_piece_info[257])
                    return
                end
                codes = zstring.exchangeTo(codes)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        --刷新界面
                        text:setString("")
                        -- _ED.union.union_info.union_name = codes
                        -- DSC重塑
                        if __lua_project_id == __lua_project_l_digital then
                            state_machine.excute("union_the_meeting_place_information_new_update_name", 0, nil)
                        else
                            state_machine.excute("union_the_meeting_place_information_update_name", 0, nil)
                        end
                        state_machine.excute("sm_union_change_name_window_close", 0, nil)
                    end
                end
                protocol_command.union_name_update.param_list = codes
                NetworkManager:register(protocol_command.union_name_update.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_change_name_window_display_terminal)
        state_machine.add(sm_union_change_name_window_hide_terminal)
        state_machine.add(sm_union_change_name_window_modify_the_name_terminal)
        state_machine.init()
    end
    init_sm_union_change_name_window_terminal()
end

function SmUnionChangeName:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local price = dms.string(dms["union_config"], 15, union_config.param)
    local Text_zuanshi_n = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_n")
    Text_zuanshi_n:setString(price)
    local price = dms.string(dms["union_config"], 1, union_config.param)
    if zstring.tonumber(price) <= zstring.tonumber(_ED.user_info.user_gold) then
        Text_zuanshi_n:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    else
        Text_zuanshi_n:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    end
end

function SmUnionChangeName:init(params)
    self.example = params
    self:onInit()
    return self
end

function SmUnionChangeName:onInit()
    local csbSmUnionChangeName = csb.createNode("legion/sm_legion_name_change.csb")
    local root = csbSmUnionChangeName:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionChangeName)
    self:onUpdateDraw()

    local text = ccui.Helper:seekWidgetByName(root, "TextField_gg_xinxi")
    draw:addEditBox(text, _string_piece_info[341], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Image_9"), 6, cc.KEYBOARD_RETURNTYPE_DONE)
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_5_qx"), nil, 
    {
        terminal_name = "sm_union_change_name_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_5_bc"), nil, 
    {
        terminal_name = "sm_union_change_name_window_modify_the_name",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)
end

function SmUnionChangeName:onExit()
    state_machine.remove("sm_union_change_name_window_display")
    state_machine.remove("sm_union_change_name_window_hide")
end