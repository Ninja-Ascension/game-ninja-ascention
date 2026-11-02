MapBuildInforCell = class("MapBuildInforCellClass", Window)
MapBuildInforCell.__size = nil

local map_build_infor_create_cell_terminal = {
    _name = "map_build_infor_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = MapBuildInforCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(map_build_infor_create_cell_terminal)
state_machine.init()

function MapBuildInforCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = nil

    self._tick_time = 0
    self._isNeedTick = false

    local function init_map_build_infor_cell_terminal()
        local map_build_infor_cell_go_terminal = {
            _name = "map_build_infor_cell_go",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("map_rattling_window_open", 0, {response.node._info.city_id, response.node._info.mould_id, response.node._index})
                        end
                            state_machine.excute("map_build_infor_window_close", 0, nil)
                    end
                end
                protocol_command.city_resource_hold_get_resource_users.param_list = cell._info.city_id.."\r\n"..cell._info.id
                NetworkManager:register(protocol_command.city_resource_hold_get_resource_users.code, nil, nil, nil, cell, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(map_build_infor_cell_go_terminal)
        state_machine.init()
    end
    init_map_build_infor_cell_terminal()
end

function MapBuildInforCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_build_rec_name = ccui.Helper:seekWidgetByName(root,"Text_build_rec_name")
    local Panel_build = ccui.Helper:seekWidgetByName(root,"Panel_build")
    local Text_rec_n = ccui.Helper:seekWidgetByName(root,"Text_rec_n")
    local Text_time_n = ccui.Helper:seekWidgetByName(root,"Text_time_n")
    local Text_rec_s_n = ccui.Helper:seekWidgetByName(root,"Text_rec_s_n")
    local Text_look = ccui.Helper:seekWidgetByName(root,"Text_look")
    local Text_go = ccui.Helper:seekWidgetByName(root,"Text_go")
    local Panel_legion_z = ccui.Helper:seekWidgetByName(root,"Panel_legion_z")
    local Text_legion_n = ccui.Helper:seekWidgetByName(root,"Text_legion_n")
    local Image_collect = ccui.Helper:seekWidgetByName(root,"Image_collect")
    local Image_full = ccui.Helper:seekWidgetByName(root,"Image_full")
    Image_collect:setVisible(false)
    Image_full:setVisible(false)

    Text_look:setVisible(false)
    Text_go:setVisible(false)
    if tonumber(_ED.city_world_map_id_backup) == tonumber(self._info.city_id) then
        Text_go:setVisible(true)
    else
        Text_look:setVisible(true)
    end

    local city_resource_data = dms.element(dms["city_resource_mould"], self._info.mould_id)
    -- local resourceType = dms.atoi(city_resource_data, city_resource_mould.resourceType)
    local quality = dms.atoi(city_resource_data, city_resource_mould.quality)
    local resource_pic = dms.atoi(city_resource_data, city_resource_mould.resource_pic)
    local distributes = dms.atos(city_resource_data, city_resource_mould.distribute)

    Panel_build:setBackGroundImage(string.format(config_res.images.ui.play.big_map.rattling_building, resource_pic))

    if tonumber(self._info.meInThisCity) == 1 then
        if tonumber(self._info.useUserCity) > 0 then
            Image_collect:setVisible(true)
        end
    else
        if tonumber(self._info.useUserCity) == tonumber(self._info.allUserCity) then
            Image_full:setVisible(true)
        end
    end

    Text_rec_n:setString(distributes)
    Text_rec_n:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    if self._info.user_name == "" then
        Text_rec_s_n:setString(string_map_rattling_info[1])
    else
        Text_rec_s_n:setString(self._info.user_name)
    end
    if self._info.union_name == "" then
        Text_legion_n:setString(string_map_rattling_info[1])
    else
        Text_legion_n:setString(self._info.union_name)
    end
    local city_name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],self._info.city_id, warfare_map_mould.city_name)
    Text_build_rec_name:setString(city_name..""..self._index)
    Text_build_rec_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))

    if tonumber(self._info.open_state) == 0 then
        self._tick_time = tonumber(self._info.leave_time)
    else
        self._tick_time = self._info.use_os_time
    end
    if tonumber(self._info.open_state) == 1 then
        self:registerOnNoteUpdate(self, 0.1)
        self._isNeedTick = true
    else
        self:unregisterOnNoteUpdate(self, 0.1)
        self._isNeedTick = false
    end
    Text_time_n:setString(self:formatTimeString(self._tick_time))
end

function MapBuildInforCell:formatTimeString(_time)
    local timeString = ""
    local now_time = math.max(tonumber(_time), 0)
    timeString = timeString .. string.format("%02d", math.floor(now_time/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))
    return timeString
end

function MapBuildInforCell:onUpdate( dt )
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
    ccui.Helper:seekWidgetByName(root, "Text_time_n"):setString(self:formatTimeString(self._tick_time))
end

function MapBuildInforCell:onEnterTransitionFinish()

end

--初始化列表
function MapBuildInforCell:onInit( )
    local csbItem = csb.createNode(config_csb.cells.big_map.map_build_infor_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)
	
	table.insert(self.roots, root)
    if MapBuildInforCell.__size == nil then
        MapBuildInforCell.__size = root:getContentSize()
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_in"), nil, 
    {
        terminal_name = "map_build_infor_cell_go", 
        terminal_state = 0, 
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 0)

	self:onUpdateDraw()	
end

function MapBuildInforCell:init(params)
    self._index = params[1]
    self._info = params[2]
	self:onInit()
    self:setContentSize(MapBuildInforCell.__size)
    return self
end

function MapBuildInforCell:onExit()

end
