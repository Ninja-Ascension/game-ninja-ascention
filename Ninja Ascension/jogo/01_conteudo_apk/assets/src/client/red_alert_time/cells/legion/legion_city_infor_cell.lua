----------------------------------------------------------------------------------------------------
-- 说明：军团城市属性资源cell
-------------------------------------------------------------------------------------------------------
LegionCityInforCell = class("LegionCityInforCellClass", Window)
LegionCityInforCell.__size = nil

local legion_city_infor_cell_create_terminal = {
    _name = "legion_city_infor_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local panel = LegionCityInforCell:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_infor_cell_create_terminal)
state_machine.init()

function LegionCityInforCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._info = nil
    self._from_type = 0

    self.collection_type = 0
    self.recording_type = 0
    self.info = nil

    app.load("client.red_alert_time.worldMap.redAlertTimeMineCollectionSelection")

    local function init_legion_city_infor_cell_terminal()
        --分享打开
        local legion_city_infor_cell_share_open_terminal = {
            _name = "legion_city_infor_cell_share_open",
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
        local legion_city_infor_cell_share_close_terminal = {
            _name = "legion_city_infor_cell_share_close",
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
        local legion_city_infor_cell_share_chats_terminal = {
            _name = "legion_city_infor_cell_share_chats",
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
                        state_machine.excute("legion_city_infor_cell_share_close", 0, 0)         
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("legion_city_infor_cell_share_close", 0, 0) 
                    return
                end 

                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("legion_city_infor_cell_share_close", 0, 0)
                            TipDlg.drawTextDailog(game_share_tip_text[1])
                        end 
                    end
                end

                local paramsInfo = "9-1-"..instance.info._mould_id
                local str = chat_section[1]..dms.string(dms["message_share"], 1, message_share.jump_type).."|"..instance.info._x..","..instance.info._y
                str = zstring.exchangeTo(str)
                protocol_command.send_message.param_list = str.."\r\n"..params._datas.chat_type.. "\r\n0\r\n3\r\n"..paramsInfo
                -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, instance, responseSendMessageCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --收藏
        local legion_city_infor_cell_collection_terminal = {
            _name = "legion_city_infor_cell_collection",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.collection_type == 0 then
                    local function requesrDeletecoordinate(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                TipDlg.drawTextDailog(friends_tip_string[11])
                                _ED.world_map.coord_collent[""..response.node.recording_type][response.node.info._type.."," .. response.node.info._id] = nil
                                state_machine.excute("legion_city_infor_cell_update_draw", 0, 0)
                            end
                        end
                    end
                    local city_data = dms.element(dms["world_city_mould"], self.info._mould_id)
                    local name = dms.atos(city_data, world_city_mould.name)
                    local level = dms.atoi(city_data, world_city_mould.level)
                    protocol_command.world_coord_collect.param_list = "0" .. "\r\n" .. "" .. instance.recording_type .. "-" ..instance.info._type .. "," .. instance.info._id .."\r\n"..name.."|"..level.."|"..instance.info._x..","..instance.info._y
                    NetworkManager:register(protocol_command.world_coord_collect.code, nil, nil, nil, instance, requesrDeletecoordinate, false, nil)
                else
                    state_machine.excute("red_alert_time_mine_collection_selection_open", 0, {_datas={m_type = 1, cells = instance}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local legion_city_infor_cell_update_draw_terminal = {
            _name = "legion_city_infor_cell_update_draw",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_infor_cell_share_open_terminal)    
        state_machine.add(legion_city_infor_cell_share_close_terminal)    
        state_machine.add(legion_city_infor_cell_share_chats_terminal) 
        state_machine.add(legion_city_infor_cell_collection_terminal) 
        state_machine.add(legion_city_infor_cell_update_draw_terminal) 
        state_machine.init()
    end
    init_legion_city_infor_cell_terminal()         
end

function LegionCityInforCell:onUpdateDraw()
    if self._from_type == 1 or self._from_type == 2 then
        self:onUpdateCityInfo()
    else
        self:onUpdateStrongInfo()
    end
end

function LegionCityInforCell:onUpdateCityInfo()
    local root = self.roots[1]
    local resource_info = dms.string(dms["world_city_mould"], self._info.city_id, world_city_mould.resource_info)
    -- 资源产量
    local res_info = zstring.split(resource_info, "|")
    for i = 1, 5 do
        local Text_legion_city_occupy_res_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_res_n_"..i)
        local Image_legion_city_occupy_icon = ccui.Helper:seekWidgetByName(root, "Image_legion_city_occupy_icon_"..i)
        local Text_legion_city_occupy_res = ccui.Helper:seekWidgetByName(root, "Text_legion_city_occupy_res_"..i)
        local out_put = 0
        local info = zstring.split(res_info[i], ",")
        out_put = zstring.tonumber(info[2]) * 3600
        Text_legion_city_occupy_res_n:setString(exChangeNumToString(out_put)..world_city_tip_str[3])
        Text_legion_city_occupy_res:setString(reward_prop_list[tonumber(info[1])]..":")
        local pic_index = 1
        for k, v in pairs(tank_from_prop_used_ids) do
            if v == tonumber(tonumber(info[1])) then
                pic_index = k
                break
            end
        end
        Image_legion_city_occupy_icon:loadTexture(config_res.images.ui.home._ui_res_type_small_icon[pic_index], 1)
    end

    if self._from_type == 2 then
        local position = dms.string(dms["world_city_mould"], self._info.city_id, world_city_mould.position)
        self.info = _ED.world_map.world_map_info_list[position]

        local Button_legion_city_collection = ccui.Helper:seekWidgetByName(root,"Button_legion_city_collection")
        self.collection_type = 1
        for i=1,3 do
            if _ED.world_map.coord_collent ~= nil and _ED.world_map.coord_collent[""..i]~= nil then
                for j, v in pairs(_ED.world_map.coord_collent[""..i]) do
                    local m_info = zstring.split(j, ",")
                    if zstring.tonumber(m_info[2]) == zstring.tonumber(self.info._id) then
                        self.collection_type = 0
                        self.recording_type = i
                        break
                    end
                end
            end
        end
        if self.collection_type == 0 then
            Button_legion_city_collection:setTitleText(tipStringInfo_consumption_info[22])
        else
            Button_legion_city_collection:setTitleText(tipStringInfo_consumption_info[21])
        end
    end
end

function LegionCityInforCell:onUpdateStrongInfo()
    local root = self.roots[1]
    -- 加成buff
    local buff_info = zstring.split(dms.string(dms["world_city_mould"], self._info.city_id, world_city_mould.buff_info), "|")
    local Text_legion_city_un_occupy_dodge_t = ccui.Helper:seekWidgetByName(root, "Text_legion_city_un_occupy_dodge_t")
    local Text_legion_city_un_occupy_dodge_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_un_occupy_dodge_n")
    local Text_legion_city_un_occupy_add = ccui.Helper:seekWidgetByName(root, "Text_legion_city_un_occupy_add")
    local Text_legion_city_un_occupy_add_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_un_occupy_add_n")

    local buff_1 = zstring.split(buff_info[1], ",")
    Text_legion_city_un_occupy_dodge_t:setString(red_alert_time_str[169]..red_alert_time_attribute[tonumber(buff_1[1]) + 1]..":")
    Text_legion_city_un_occupy_dodge_n:setString("+"..buff_1[2].."%")

    local buff_2 = zstring.split(buff_info[2], ",")
    Text_legion_city_un_occupy_add_n:setString("+"..buff_2[2].."%")
end

function LegionCityInforCell:onEnterTransitionFinish()

end

function LegionCityInforCell:onInit()
    local csbItem = csb.createNode(string.format(config_csb.cells.legion.legion_city_infor_cell, self._from_type))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 
    
    if LegionCityInforCell.__size == nil then
        LegionCityInforCell.__size = root:getContentSize()
    end

    -- 收藏
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_collection"), nil, 
    {
        terminal_name = "legion_city_infor_cell_collection",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    -- 分享
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_share"), nil, 
    {
        terminal_name = "legion_city_infor_cell_share_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1) 
    
    local Panel_share_close = ccui.Helper:seekWidgetByName(root,"Panel_share_close")
    if Panel_share_close ~= nil then
        Panel_share_close:setSwallowTouches(false)
    end
    -- 分享关闭
    fwin:addTouchEventListener(Panel_share_close, nil, 
    {
        terminal_name = "legion_city_infor_cell_share_close", 
        terminal_state = 0, 
    }, nil, 1)  
    
    -- 分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_legion_chat"), nil, 
    {
        terminal_name = "legion_city_infor_cell_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 14,
    }, nil, 1)  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_world_chat"), nil, 
    {
        terminal_name = "legion_city_infor_cell_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 13,
    }, nil, 1) 

    self:onUpdateDraw()
end

function LegionCityInforCell:init(params)
    self._rootWindows = params[1]   
    self._info = params[2]
    self._from_type = params[3]

    self:onInit()
    return self
end

function LegionCityInforCell:onExit()   
    state_machine.remove("legion_city_infor_cell_share_open")
    state_machine.remove("legion_city_infor_cell_share_close")
    state_machine.remove("legion_city_infor_cell_share_chats")
    state_machine.remove("legion_city_infor_cell_collection")
    state_machine.remove("legion_city_infor_cell_update_draw")
end
