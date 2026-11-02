-- ------------------------------------------------------------------------------------------------------------
--  说明：操作
-- ------------------------------------------------------------------------------------------------------------
EquipmentPartsInfor = class("EquipmentPartsInforClass", Window)

--打开界面
local equipment_parts_infor_window_open_terminal = {
    _name = "equipment_parts_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("EquipmentPartsInforClass") == nil then
            local equipment_info = params[1]
            local equipment_cell = params[2]
            local _win = EquipmentPartsInfor:new()
            _win:init(equipment_info, equipment_cell)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local equipment_parts_infor_window_close_terminal = {
    _name = "equipment_parts_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentPartsInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(equipment_parts_infor_window_open_terminal)
state_machine.add(equipment_parts_infor_window_close_terminal)
state_machine.init()

function EquipmentPartsInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._equipment_info = nil
    self._is_wear = false

    app.load("client.red_alert_time.cells.props.props_icon_cell")
     -- Initialize alert_home state machine.
    local function init_equipment_parts_infor_terminal()
        --分解
        local equipment_parts_infor_decompose_terminal = {
            _name = "equipment_parts_infor_decompose",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local equipments = {instance._equipment_info}
                state_machine.excute("equipment_parts_decompose_window_open", 0, {1, equipments})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --装配
        local equipment_parts_infor_wear_terminal = {
            _name = "equipment_parts_infor_wear",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local wear_type = 0
                if self._is_wear == false then      -- 穿装备
                    wear_type = 1
                end
                local equipment_type = tonumber(instance._equipment_info.influence_type)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("equipment_parts_infor_window_close", 0, "")
                        end
                        state_machine.excute("equipment_packs_tab_fitting_update_draw", 0, "")
                        state_machine.excute("equipment_parts_tab_update_draw_cell", 0, equipment_type)
                    end
                end
                protocol_command.equipment_adorn.param_list = instance._equipment_info.equip_id .."\r\n".. wear_type
                NetworkManager:register(protocol_command.equipment_adorn.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--分享打开
        local equipment_parts_infor_share_open_terminal = {
            _name = "equipment_parts_infor_share_open",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(true)
                Panel_share_close:setVisible(true)
                Animations_PlayOpenMainUI({Panel_share}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_SLIDE_DOWN, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--分享关闭
        local equipment_parts_infor_share_close_terminal = {
            _name = "equipment_parts_infor_share_close",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(false)
                Panel_share_close:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--分享到聊天
        local equipment_parts_infor_share_chats_terminal = {
            _name = "equipment_parts_infor_share_chats",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(params._datas.chat_type) == 14 then
                    if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                        state_machine.excute("equipment_parts_infor_share_close", 0, 0)         
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("equipment_parts_infor_share_close", 0, 0) 
                    return
                end 
				local function responseSendMessageCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("equipment_parts_infor_share_close", 0, "")
						TipDlg.drawTextDailog(game_share_tip_text[1])
					end
				end
				
				local share_id = dms.int(dms["equipment_mould"], instance._equipment_info.equipment_mould_id, equipment_mould.influence_type)
				local share_position = dms.int(dms["equipment_mould"], instance._equipment_info.equipment_mould_id, equipment_mould.equipment_type)
				if share_id == 1 then
					share_position = share_position + 4
				elseif share_id == 2 then
					share_position = share_position + 12
				elseif share_id == 3 then
					share_position = share_position + 20
				else
					share_position = share_position + 28
				end
				local datas = dms.string(dms["message_share"], share_position, message_share.content)
				local equip_name = dms.string(dms["equipment_mould"], instance._equipment_info.equipment_mould_id, equipment_mould.equipment_name)        -- 名称
				local quality = dms.int(dms["equipment_mould"], instance._equipment_info.equipment_mould_id, equipment_mould.grow_level)              -- 品质
				local mine_info = "|"..quality.."|"..equip_name
				local data1 =  string.gsub(datas, "!x@", mine_info)
                -- local paramsInfo = mine_info
                local paramsInfo = "5-1-"..instance._equipment_info.equipment_mould_id..","..mine_info
				datas = ""--data1
				local str =datas..chat_section[1].."4".."|"..instance._equipment_info.equipment_name..","..instance._equipment_info.strength..","..instance._equipment_info.upgrade_level
					..","..instance._equipment_info.rank_up_level..","..instance._equipment_info.influence_type..","..instance._equipment_info.equipment_type.."+"..instance._equipment_info.pic_index.."+"..instance._equipment_info.attr
				str = zstring.exchangeTo(str)
                protocol_command.send_message.param_list = str.."\r\n"..params._datas.chat_type.. "\r\n0\r\n" .. share_position.."\r\n"..paramsInfo
				-- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, instance, responseSendMessageCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=instance, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equipment_parts_infor_decompose_terminal)    
        state_machine.add(equipment_parts_infor_wear_terminal)    
        state_machine.add(equipment_parts_infor_share_open_terminal)    
        state_machine.add(equipment_parts_infor_share_close_terminal)    
        state_machine.add(equipment_parts_infor_share_chats_terminal)    
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_equipment_parts_infor_terminal()
end

--初始化界面
function EquipmentPartsInfor:onInit()
    local csbItem = csb.createNode(config_csb.equipment.equipment_parts_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_infor_close"), nil, 
    {
        terminal_name = "equipment_parts_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "equipment_parts_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 分解
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_decompose"), nil, 
    {
        terminal_name = "equipment_parts_infor_decompose", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 装配
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_un"), nil, 
    {
        terminal_name = "equipment_parts_infor_wear", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_strengthen"), nil, 
    {
        terminal_name = "equipment_strengthen_reform_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        page_index = 1,
        equipment_id = self._equipment_info.equip_id,
        equipment_cell = self._equipment_cell,
    }, nil, 1)  

    -- 改造
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_reform"), nil, 
    {
        terminal_name = "equipment_strengthen_reform_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        page_index = 2,
        equipment_id = self._equipment_info.equip_id,
        equipment_cell = self._equipment_cell,
    }, nil, 1)  
	
	-- 分享打开
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share"), nil, 
    {
        terminal_name = "equipment_parts_infor_share_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  
	
	ccui.Helper:seekWidgetByName(root,"Panel_share_close"):setSwallowTouches(false)
	-- 分享关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_share_close"), nil, 
    {
        terminal_name = "equipment_parts_infor_share_close", 
        terminal_state = 0, 
    }, nil, 1)  
	
	-- 分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_legion_chat"), nil, 
    {
        terminal_name = "equipment_parts_infor_share_chats", 
        terminal_state = 0, 
        touch_black = true,
		chat_type = 14,
    }, nil, 1)  
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_world_chat"), nil, 
    {
        terminal_name = "equipment_parts_infor_share_chats", 
        terminal_state = 0, 
        touch_black = true,
		chat_type = 13,
    }, nil, 1)  

    self:onUpdateDraw()
end

-- 显示信息
function EquipmentPartsInfor:onUpdateDraw()
    local root = self.roots[1]

    -- 图标和名称
    local Panel_parts_icon = ccui.Helper:seekWidgetByName(root, "Panel_parts_icon")
    local Text_parts_name = ccui.Helper:seekWidgetByName(root, "Text_parts_name")
    Panel_parts_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell", 0, {8, 4, self._equipment_info.equip_id, 7})
    Panel_parts_icon:addChild(cell)
    Text_parts_name:setString(self._equipment_info.equipment_name)

    -- 属性
    local Text_parts_attribute_n_1 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_n_1")         -- 强度
    local Text_parts_attribute_n_2 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_n_2")         -- 强化等级
    local Text_parts_attribute_n_3 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_n_3")         -- 改造等级
    local Text_parts_attribute_n_4 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_n_4")         -- 适用

    Text_parts_attribute_n_1:setString(self._equipment_info.strength)
    Text_parts_attribute_n_2:setString(self._equipment_info.upgrade_level)
    Text_parts_attribute_n_3:setString(self._equipment_info.rank_up_level)
    Text_parts_attribute_n_4:setString(tipStringInfo_tank_type_info[self._equipment_info.influence_type])

    local add_attr_info = zstring.split(self._equipment_info.attr, "|")

    -- 加成属性1
    local Text_parts_attribute_t_5 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_t_5")
    local Text_parts_attribute_n_5 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_n_5")
    local add_attr_1 = zstring.split(add_attr_info[1], ",")
    local attr_id_1 = tonumber(add_attr_1[1])
    Text_parts_attribute_t_5:setString(red_alert_time_attribute[attr_id_1 + 1] .. red_alert_time_str[29]..":")
    local is_hundred = false
    for k, v in pairs(attribute_hundred) do
        if v == attr_id_1 then
            is_hundred = true
            break
        end
    end
    if is_hundred == true then
        Text_parts_attribute_n_5:setString("" .. add_attr_1[2] .. "%")
    else
        Text_parts_attribute_n_5:setString("" .. add_attr_1[2])
    end

    -- 加成属性2
    local Text_parts_attribute_t_6 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_t_6")
    local Text_parts_attribute_n_6 = ccui.Helper:seekWidgetByName(root, "Text_parts_attribute_n_6")
    if add_attr_info[2] == nil then
        Text_parts_attribute_t_6:setString("")
        Text_parts_attribute_n_6:setString("")
    else
        local add_attr_2 = zstring.split(add_attr_info[2], ",")
        local attr_id_2 = tonumber(add_attr_2[1])
        Text_parts_attribute_n_6:setString(red_alert_time_attribute[attr_id_2 + 1] .. red_alert_time_str[29]..":")
        local is_hundred = false
        for k, v in pairs(attribute_hundred) do
            if v == attr_id_2 then
                is_hundred = true
                break
            end
        end
        if is_hundred == true then
            Text_parts_attribute_t_6:setString("" .. add_attr_2[2] .. "%")
        else
            Text_parts_attribute_t_6:setString("" .. add_attr_2[2])
        end
    end

    -- 装配状态
    local Button_parts_un = ccui.Helper:seekWidgetByName(root, "Button_parts_un")       -- 装配
    local Button_parts_decompose = ccui.Helper:seekWidgetByName(root, "Button_parts_decompose")       -- 分解
    if tonumber(self._equipment_info.is_equiped) == 0 then      -- 未装备
        self._is_wear = false
        Button_parts_decompose:setBright(true)
        Button_parts_decompose:setTouchEnabled(true)
        Button_parts_un:setTitleText(red_alert_time_str[34])
    else
        self._is_wear = true
        Button_parts_decompose:setBright(false)
        Button_parts_decompose:setTouchEnabled(false)
        Button_parts_un:setTitleText(red_alert_time_str[35])
    end
end

--初始化
function EquipmentPartsInfor:init(equipment_info, equipment_cell)
    self._equipment_info = equipment_info
    self._equipment_cell = equipment_cell
    self:onInit()
end

--移除状态机
function EquipmentPartsInfor:onExit()   
    state_machine.remove("equipment_parts_infor_decompose")
    state_machine.remove("equipment_parts_infor_wear")
    state_machine.remove("equipment_parts_infor_share_open")
    state_machine.remove("equipment_parts_infor_share_close")
    state_machine.remove("equipment_parts_infor_share_chats")
end
