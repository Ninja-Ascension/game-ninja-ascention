-----------------------------
-- 资源点占领界面
-----------------------------
MapRattlingAttack = class("MapRattlingAttackClass", Window)

local map_rattling_attack_window_open_terminal = {
    _name = "map_rattling_attack_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("MapRattlingAttackClass")
        if nil == _Window then
            fwin:open(MapRattlingAttack:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local map_rattling_attack_window_close_terminal = {
    _name = "map_rattling_attack_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("MapRattlingAttackClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(map_rattling_attack_window_open_terminal)
state_machine.add(map_rattling_attack_window_close_terminal)
state_machine.init()

function MapRattlingAttack:ctor()
    self.super:ctor()
    self.roots = {}

    self._info = nil
    self._resource_index = 0

    self._tick_time = 0
    self._isNeedTick = false

    app.load("client.utils.ConfirmTip")
    local function init_map_rattling_attack_terminal()
        local map_rattling_attack_attacking_terminal = {
            _name = "map_rattling_attack_attacking",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.city_resource_user_info ~= nil and 
                    tonumber(_ED.city_resource_user_info.resource_hold_id) > 0 then
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.sureChange, string_map_rattling_info[9])
                    fwin:open(tip, fwin._windows)
                else
                    instance:sureChange(0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(map_rattling_attack_attacking_terminal)
        state_machine.init()
    end
    init_map_rattling_attack_terminal()
end

function MapRattlingAttack:sureChange(sure_number)
    local function responseCallback( response )
        state_machine.excute("map_rattling_attack_window_close", 0, nil)
        state_machine.excute("map_rattling_update_info", 0, nil)
        -- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            
        -- end
    end
    if sure_number == 0 then
        protocol_command.city_resource_hold.param_list = self._info.city_id.."\r\n"..self._info.resource_id.."\r\n"..self._info.id.."\r\n1"
        NetworkManager:register(protocol_command.city_resource_hold.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function MapRattlingAttack:onUpdateDraw()
    local root = self.roots[1]
    local Panel_build_rec = ccui.Helper:seekWidgetByName(root, "Panel_build_rec")
    local Text_rec_name = ccui.Helper:seekWidgetByName(root, "Text_rec_name")
    local Text_rec_t = ccui.Helper:seekWidgetByName(root, "Text_rec_t")
    local Text_rec_x_n = ccui.Helper:seekWidgetByName(root, "Text_rec_x_n")
    local Text_rex_time_n = ccui.Helper:seekWidgetByName(root, "Text_rex_time_n")

    local city_resource_data = dms.element(dms["city_resource_mould"], self._info.resource_mould_id)
    local resourceType = dms.atoi(city_resource_data, city_resource_mould.resourceType)
    local quality = dms.atoi(city_resource_data, city_resource_mould.quality)
    local speed = dms.atoi(city_resource_data, city_resource_mould.speed)
    local resource_pic = 0
    if tonumber(self._info.resource_level) == 1 then
        resource_pic = dms.atos(city_resource_data, city_resource_mould.rattling_pic_1)
        speed = speed + speed * dms.int(dms["city_resource_hold_config"], 5, city_resource_hold_config.param)/100
    else
        resource_pic = dms.atos(city_resource_data, city_resource_mould.rattling_pic_2)
    end
    Panel_build_rec:setBackGroundImage(string.format(config_res.images.ui.play.big_map.rattling_building, resource_pic))
    
    local resource_info = _ED.city_resource_hold_resource_infos[tonumber(self._resource_index)]
    if tonumber(resource_info.open_state) == 0 then
        self._tick_time = tonumber(resource_info.leave_time)
    else
        self._tick_time = resource_info.use_os_time
    end
    if tonumber(resource_info.open_state) == 1 then
        self:registerOnNoteUpdate(self, 0.1)
        self._isNeedTick = true
    else
        self:unregisterOnNoteUpdate(self, 0.1)
        self._isNeedTick = false
    end

    Text_rex_time_n:setString(self:formatTimeString(self._tick_time))
    Text_rec_x_n:setString(string.format(string_map_rattling_info[2], speed))

    local infos = ""
    if resourceType == 33 then
        infos = _All_tip_string_info._martix
    elseif resourceType == 1 then
        infos = _All_tip_string_info._fundName
    elseif resourceType == 2 then
        infos = _All_tip_string_info._crystalName
    elseif resourceType == 5 then
        infos = _All_tip_string_info._hero
    end
    Text_rec_t:setString(infos)
    local city_name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],self._info.city_id, warfare_map_mould.city_name)
    Text_rec_name:setString(city_name..""..self._resource_index)
    Text_rec_t:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    Text_rec_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
end

function MapRattlingAttack:formatTimeString(_time)
    local timeString = ""
    local now_time = math.max(tonumber(_time), 0)
    timeString = timeString .. string.format("%02d", math.floor(now_time/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))
    return timeString
end

function MapRattlingAttack:onUpdate( dt )
    if self._isNeedTick == false then
        return
    end
    if self._tick_time <= 0 then
        self._tick_time = 0
        self:unregisterOnNoteUpdate(self)
    else
        self._tick_time = self._tick_time - dt
    end
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Text_rex_time_n"):setString(self:formatTimeString(self._tick_time))
end

function MapRattlingAttack:onEnterTransitionFinish()

end

function MapRattlingAttack:onInit( )
    local csbItem = csb.createNode(config_csb.big_map.map_rattling_attack)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_attack"), nil, 
    {
        terminal_name = "map_rattling_attack_window_close", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_attack_1"), nil, 
    {
        terminal_name = "map_rattling_attack_attacking", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()
end

function MapRattlingAttack:init(params)
    self._info = params[1]
    self._resource_index = params[2]
	self:onInit()
    return self
end

function MapRattlingAttack:onExit()
    state_machine.remove("map_rattling_attack_attacking")
end
