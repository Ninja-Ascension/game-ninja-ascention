MapRattlingBuildCell = class("MapRattlingBuildCellClass", Window)

local map_rattling_build_create_cell_terminal = {
    _name = "map_rattling_build_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = MapRattlingBuildCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(map_rattling_build_create_cell_terminal)
state_machine.init()

function MapRattlingBuildCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = nil
    self._resource_index = 0

    self._isNeedTick = false
    self._cur_time = 0
    self._max_time = 0

    local function init_map_rattling_build_cell_terminal()
        local map_rattling_build_cell_choose_terminal = {
            _name = "map_rattling_build_cell_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if tonumber(cell._info.user_id) == 0 then
                    state_machine.excute("map_rattling_attack_window_open", 0, {cell._info, cell._resource_index})
                else
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                state_machine.excute("map_rattling_infomation_window_open", 0, {response.node._info, response.node._resource_index})
                            end
                        end
                    end
                    protocol_command.city_resource_hold_get_user_position_info.param_list = cell._info.city_id.."\r\n"..cell._info.resource_id.."\r\n"..cell._info.id
                    NetworkManager:register(protocol_command.city_resource_hold_get_user_position_info.code, nil, nil, nil, cell, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(map_rattling_build_cell_choose_terminal)
        state_machine.init()
    end
    init_map_rattling_build_cell_terminal()
end

function MapRattlingBuildCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_build_rec = ccui.Helper:seekWidgetByName(root,"Panel_build_rec")

    local Panel_rattling_build = ccui.Helper:seekWidgetByName(root,"Panel_rattling_build")
    local Panel_rattling_build_0 = ccui.Helper:seekWidgetByName(root,"Panel_rattling_build_0")
    Panel_rattling_build:setVisible(false)
    Panel_rattling_build_0:setVisible(false)
    
    local Text_rattling_build_types = ccui.Helper:seekWidgetByName(root,"Text_rattling_build_types")
    local Text_rattling_build_name = ccui.Helper:seekWidgetByName(root,"Text_rattling_build_name")
    local Panel_national = ccui.Helper:seekWidgetByName(root,"Panel_national")
    local LoadingBar_1 = ccui.Helper:seekWidgetByName(root,"LoadingBar_1")
    local Image_bihu = ccui.Helper:seekWidgetByName(root,"Image_bihu")
    local Panel_effice_get = ccui.Helper:seekWidgetByName(root,"Panel_effice_get")
    local Text_legion_name = ccui.Helper:seekWidgetByName(root,"Text_legion_name")
    local Panel_bihu = ccui.Helper:seekWidgetByName(root,"Panel_bihu")
    Panel_effice_get:removeAllChildren(true)

    if tonumber(self._info.master_id) > 0 then
        Image_bihu:setVisible(true)
        Panel_bihu:setVisible(true)
    end

    if self._info.unionName ~= "" then
        Text_legion_name:setString("<"..self._info.unionName..">")
    else
        Text_legion_name:setString("")
    end

    local armature = ccs.Armature:create("effice_rattling_up")
    draw.initArmature(armature, nil, -1, 0, 1)
    csb.animationChangeToAction(armature, 0, 0, true)
    Panel_effice_get:addChild(armature)

    local city_resource_data = dms.element(dms["city_resource_mould"], self._info.resource_mould_id)
    local resourceType = dms.atoi(city_resource_data, city_resource_mould.resourceType)
    local quality = dms.atoi(city_resource_data, city_resource_mould.quality)
    local time = dms.atoi(city_resource_data, city_resource_mould.s_time)
    self._max_time = time/1000
    self._cur_time = self._info.end_time/1000 - (os.time() + _ED.time_add_or_sub)
    LoadingBar_1:setPercent((self._cur_time/self._max_time)*100)

    local resource_pic = 0
    if tonumber(self._info.resource_level) == 1 then
        resource_pic = dms.atos(city_resource_data, city_resource_mould.rattling_pic_1)
    else
        resource_pic = dms.atos(city_resource_data, city_resource_mould.rattling_pic_2)
    end
    Panel_build_rec:setBackGroundImage(string.format(config_res.images.ui.play.big_map.rattling_building, resource_pic))
    local infos = ""
    local actionIndex = 0
    local armatureName = ""
    if resourceType == 33 then
        infos = _All_tip_string_info._martix
        actionIndex = 1
        armatureName = "effice_home_get_2"
    elseif resourceType == 1 then
        infos = _All_tip_string_info._fundName
        actionIndex = 1
        armatureName = "effice_home_get_1"
    elseif resourceType == 2 then
        actionIndex = 0
        infos = _All_tip_string_info._crystalName
        armatureName = "effice_rattling_gem_get"
    elseif resourceType == 5 then
        infos = _All_tip_string_info._hero
        actionIndex = 0
        armatureName = "effice_rattling_soul_get"
    end

    local armature = ccs.Armature:create(armatureName)
    draw.initArmature(armature, nil, -1, 0, 1)
    csb.animationChangeToAction(armature, actionIndex, actionIndex, true)
    Panel_effice_get:addChild(armature)

    if tonumber(self._info.user_id) == 0 then
        Panel_rattling_build:setVisible(true)
        Text_rattling_build_types:setString(infos)
        Text_rattling_build_types:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
        Panel_effice_get:setVisible(false)
    else
        self._isNeedTick = true
        Panel_rattling_build_0:setVisible(true)
        Text_rattling_build_name:setString(self._info.userName)
        Panel_effice_get:setVisible(true)
    end
end

function MapRattlingBuildCell:onUpdate( dt )
    if self._isNeedTick == false then
        return
    end
    if self._cur_time <= 0 then
        self._cur_time = 0
        self:unregisterOnNoteUpdate(self)
    else
        self._cur_time = self._cur_time - dt
    end
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root,"LoadingBar_1"):setPercent((self._cur_time/self._max_time)*100)
end

function MapRattlingBuildCell:onEnterTransitionFinish()

end

--初始化列表
function MapRattlingBuildCell:onInit( )
    local csbItem = csb.createNode(config_csb.cells.big_map.map_rattling_build)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)
    
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_build_rec"), nil, 
    {
        terminal_name = "map_rattling_build_cell_choose", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 0)
    
    self:onUpdateDraw() 
end

function MapRattlingBuildCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._resource_index = params[3]
    self:onInit()
    return self
end

function MapRattlingBuildCell:onExit()

end
