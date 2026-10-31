-- ------------------------------------------------------------------------------------------------------------
--  说明：工厂属性
-- ------------------------------------------------------------------------------------------------------------
LegionCityFactoryInfor = class("LegionCityFactoryInforClass", Window)

--打开界面
local legion_city_factory_infor_window_open_terminal = {
    _name = "legion_city_factory_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local city_id = params[1]
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("LegionCityFactoryInforClass") == nil then
                    local _win = LegionCityFactoryInfor:new()
                    _win:init(params)
                    fwin:open(_win,fwin._ui)
                end
            end
        end

        protocol_command.world_city_detail_get.param_list = ""..city_id
        NetworkManager:register(protocol_command.world_city_detail_get.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_city_factory_infor_window_close_terminal = {
    _name = "legion_city_factory_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionCityFactoryInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_city_factory_infor_window_open_terminal)
state_machine.add(legion_city_factory_infor_window_close_terminal)
state_machine.init()

function LegionCityFactoryInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._info = nil
    self.info = nil
    self.collection_type = 0
    self.recording_type = 0

    self._factory_text_time = nil
    self._factory_loading_bar = nil
    self._factory_max_level = 0
    self._factory_max_time = 0

    app.load("client.red_alert_time.worldMap.redAlertTimeMineCollectionSelection")

     -- Initialize alert_home state machine.
    local function init_legion_city_factory_infor_window_terminal()
        --分享打开
        local legion_city_factory_infor_share_open_terminal = {
            _name = "legion_city_factory_infor_share_open",
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
        local legion_city_factory_infor_share_close_terminal = {
            _name = "legion_city_factory_infor_share_close",
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
        local legion_city_factory_infor_share_chats_terminal = {
            _name = "legion_city_factory_infor_share_chats",
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
                        state_machine.excute("legion_city_factory_infor_share_close", 0, 0)         
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("legion_city_factory_infor_share_close", 0, 0) 
                    return
                end 

                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("legion_city_factory_infor_share_close", 0, 0)
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
        local legion_city_factory_infor_collection_terminal = {
            _name = "legion_city_factory_infor_collection",
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
                                state_machine.excute("legion_city_factory_infor_update_draw", 0, 0)
                            end
                        end
                    end
                    local city_data = dms.element(dms["world_city_mould"], instance.info._mould_id)
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
        local legion_city_factory_infor_update_draw_terminal = {
            _name = "legion_city_factory_infor_update_draw",
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

        state_machine.add(legion_city_factory_infor_share_open_terminal)    
        state_machine.add(legion_city_factory_infor_share_close_terminal)    
        state_machine.add(legion_city_factory_infor_share_chats_terminal) 
        state_machine.add(legion_city_factory_infor_collection_terminal) 
        state_machine.add(legion_city_factory_infor_update_draw_terminal) 
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_city_factory_infor_window_terminal()
end

-- 显示信息
function LegionCityFactoryInfor:onUpdateDraw()
    local root = self.roots[1]
    local Panel_legion_city_infor_city = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_infor_city")
    local Text_legion_city_name_xy = ccui.Helper:seekWidgetByName(root, "Text_legion_city_name_xy")
    local Text_legion_city_lv = ccui.Helper:seekWidgetByName(root, "Text_legion_city_lv")
    local Text_legion_city_legion_name_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_legion_name_n")
    local Panel_legion_city_res_icon = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_res_icon")
    local Text_legion_city_res_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_res_n")
    local Panel_legion_city_occupy_res = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_occupy_res")
    local Text_legion_city_res_t = ccui.Helper:seekWidgetByName(root, "Text_legion_city_res_t")
    Panel_legion_city_res_icon:setVisible(true)
    Text_legion_city_res_n:setVisible(true)
    Text_legion_city_res_t:setVisible(true)

    Panel_legion_city_infor_city:removeBackGroundImage()
    Panel_legion_city_res_icon:removeBackGroundImage()

    local open_state = 0
    if _ED.mould_function_push_info["16"] ~= nil then
        open_state = tonumber(_ED.mould_function_push_info["16"].state)
    end

    local city_data = dms.element(dms["world_city_mould"], self._info.city_id)
    local name = dms.atos(city_data, world_city_mould.name)
    local level = dms.atoi(city_data, world_city_mould.level)
    local pic = dms.atoi(city_data, world_city_mould.pic)
    local mine_type = dms.atoi(city_data, world_city_mould.mine_type)
    local position = dms.atos(city_data, world_city_mould.position)
    local factory_buff = zstring.split(dms.atos(city_data, world_city_mould.factory_buff), "|")

    -- 城市图标
    Panel_legion_city_infor_city:setBackGroundImage(string.format(config_res.images.ui.legion.legion_city_icon, pic))

    -- 城市名称
    Text_legion_city_name_xy:removeAllChildren(true)
    Text_legion_city_name_xy:setString("")
    local font_size = Text_legion_city_name_xy:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, name, config_res.font.font_name,font_size)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, " ("..position..")", config_res.font.font_name,font_size)
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(Text_legion_city_name_xy:getContentSize().width/2,Text_legion_city_name_xy:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_legion_city_name_xy:getContentSize().width,font_size))
    Text_legion_city_name_xy:addChild(_richText)

    -- 城市等级
    Text_legion_city_lv:setString(friends_tip_string[12]..level)

    -- 占领军团
    if tonumber(self._info.progress_union_id) > 0 then
        Text_legion_city_legion_name_n:setString(self._info.progress_union_name)
    elseif tonumber(self._info.union_id) > 0 then
        Text_legion_city_legion_name_n:setString(self._info.union_name)
    else
        Text_legion_city_legion_name_n:setString(tipStringInfo_rank_str[6])
    end

    -- 富饶资源
    Panel_legion_city_res_icon:setVisible(false)
    Text_legion_city_res_n:setVisible(false)
    Text_legion_city_res_t:setVisible(false)

    -- 加成描述
    local Text_legion_city_factory_infor_lv_0 = ccui.Helper:seekWidgetByName(root, "Text_legion_city_factory_infor_lv_0")
    local Text_legion_city_factory_infor_all_up_0 = ccui.Helper:seekWidgetByName(root, "Text_legion_city_factory_infor_all_up_0")
    local Text_legion_city_factory_infor_up_0 = ccui.Helper:seekWidgetByName(root, "Text_legion_city_factory_infor_up_0")

    local factory_buff_info = zstring.split(factory_buff[1], ",")
    local str = ""
    local leader_str = ""
    for k, v in pairs(world_city_factory_buff_info) do
        if tonumber(factory_buff_info[1]) == tonumber(v[1]) then
            str = v[2]
        end
        if tonumber(factory_buff_info[3]) == tonumber(v[1]) then
            leader_str = v[2]
        end
    end

    for i = 1, 5 do
        local Text_legion_city_factory_infor_all_up = ccui.Helper:seekWidgetByName(root, "Text_legion_city_factory_infor_all_up_"..i)
        local Text_legion_city_factory_infor_up = ccui.Helper:seekWidgetByName(root, "Text_legion_city_factory_infor_up_"..i)

        local factory_buff_info = zstring.split(factory_buff[i], ",")
        local attr_str = string.format(str, factory_buff_info[2])
        local leader_attr_str = string.format(leader_str, factory_buff_info[4])
        Text_legion_city_factory_infor_all_up:setString(string.format(world_city_tip_str[60], attr_str))
        Text_legion_city_factory_infor_up:setString(string.format(world_city_tip_str[61], leader_attr_str))

        if i == tonumber(self._info.factory_level) then
            Text_legion_city_factory_infor_lv_0:setString(friends_tip_string[12]..i)
            Text_legion_city_factory_infor_all_up_0:setString(string.format(world_city_tip_str[60], attr_str))
            Text_legion_city_factory_infor_up_0:setString(string.format(world_city_tip_str[61], leader_attr_str))
        end
    end

    local occupy_state = 0         -- 1：完全占领
    if open_state == 0 then
        if (tonumber(self._info.state) == 2 and self._info.union_id > 0 and self._info.union_id == self._info.progress_union_id and self._info.progress == 0) then
            occupy_state = 1
        end
    end

    -- 工厂等级
    local Panel_legion_city_factory_lv = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_factory_lv")
    local Text_legion_city_factory_lv_time_t = ccui.Helper:seekWidgetByName(root, "Text_legion_city_factory_lv_time_t")
    local Text_legion_city_factory_lv_time_n = ccui.Helper:seekWidgetByName(root, "Text_legion_city_factory_lv_time_n")
    local LoadingBar_legion_city_factory_lv = ccui.Helper:seekWidgetByName(root, "LoadingBar_legion_city_factory_lv")

    local level = tonumber(self._info.factory_level)
    Panel_legion_city_factory_lv:removeBackGroundImage()
    Panel_legion_city_factory_lv:setBackGroundImage(string.format(config_res.images.ui.legion.legion_city_forcaty, level))

    LoadingBar_legion_city_factory_lv:loadTexture(string.format(config_res.images.ui.legion.legion_city_factory_pass, level))
    self._factory_max_time = dms.int(dms["world_city_config"], 28, world_city_config.param)      -- 升级需要时间
    self._factory_max_level = 5             -- 最大等级

    local local_time = self._info.factory_occupy_time
    local add_time = 0
    local current_time = 0
    if level < self._factory_max_level and occupy_state == 1 then
        current_time = os.time() + _ED.time_add_or_sub - self._info.factory_start_time
        current_time = math.min(current_time, self._factory_max_time)

        self._factory_text_time = Text_legion_city_factory_lv_time_n
        self._factory_loading_bar = LoadingBar_legion_city_factory_lv
    end
    local leave_time = self._factory_max_time - current_time
    local percent = (current_time * 100 / self._factory_max_time + (level - 1) * 100) / (self._factory_max_level - 1)
    LoadingBar_legion_city_factory_lv:setPercent(percent)

    if level < self._factory_max_level then
        Text_legion_city_factory_lv_time_t:setString(world_city_tip_str[53])
        Text_legion_city_factory_lv_time_n:setString(exChangeTimeToString(leave_time))
    else
        Text_legion_city_factory_lv_time_t:setString(world_city_tip_str[54])
        Text_legion_city_factory_lv_time_n:setString(tipStringInfo_union_str[70])
    end

    local Button_legion_city_collection = ccui.Helper:seekWidgetByName(root,"Button_legion_city_collection")
    local Button_legion_city_share = ccui.Helper:seekWidgetByName(root,"Button_legion_city_share")
    Button_legion_city_collection:setVisible(true)
    Button_legion_city_share:setVisible(true)

    if self._from_type == 2 then
        local position = dms.string(dms["world_city_mould"], self._info.city_id, world_city_mould.position)
        self.info = _ED.world_map.world_map_info_list[position]

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
    else
        Button_legion_city_collection:setVisible(false)
        Button_legion_city_share:setVisible(false)
    end
end

function LegionCityFactoryInfor:onUpdate(dt)
    if self._factory_text_time ~= nil then
        local current_time = os.time() + _ED.time_add_or_sub - self._info.factory_start_time
        local leave_time = self._factory_max_time - current_time
        local percent = (current_time * 100 / self._factory_max_time + (self._info.factory_level - 1) * 100) / (self._factory_max_level - 1)
        self._factory_loading_bar:setPercent(percent)
        self._factory_text_time:setString(exChangeTimeToString(leave_time))

        if leave_time < 0 then
            self:onUpdateDraw()
        end
    end
end

--初始化界面
function LegionCityFactoryInfor:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_city_factory_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leigon_city_infor_colse"), nil, 
    {
        terminal_name = "legion_city_factory_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)   
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_city_factory_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)   

    -- 收藏
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_collection"), nil, 
    {
        terminal_name = "legion_city_factory_infor_collection",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    -- 分享
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_share"), nil, 
    {
        terminal_name = "legion_city_factory_infor_share_open",
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
        terminal_name = "legion_city_factory_infor_share_close", 
        terminal_state = 0, 
    }, nil, 1)  
    
    -- 分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_legion_chat"), nil, 
    {
        terminal_name = "legion_city_factory_infor_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 14,
    }, nil, 1)  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_world_chat"), nil, 
    {
        terminal_name = "legion_city_factory_infor_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 13,
    }, nil, 1) 

    self:onUpdateDraw()
end

--初始化
function LegionCityFactoryInfor:init(params)
    self._city_id = params[1]
    self._from_type = params[2]     -- 1：不可分享，2：可分享

    self._info = _ED.world_city_info.detail_info[""..self._city_id]

    self:onInit()
end

--移除状态机
function LegionCityFactoryInfor:onExit()
    state_machine.remove("legion_city_factory_infor_share_open")
    state_machine.remove("legion_city_factory_infor_share_close")
    state_machine.remove("legion_city_factory_infor_share_chats")
    state_machine.remove("legion_city_factory_infor_collection")
    state_machine.remove("legion_city_factory_infor_update_draw")
end