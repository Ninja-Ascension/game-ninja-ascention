-- --------------------------------------------------------------------------------------------------
-- 说明：工厂buff增益cell
-- -----------------------------------------------------------------------------------------------------
BaseReserveFactoryGainCell = class("BaseReserveFactoryGainCellClass", Window)
BaseReserveGainCellSize = BaseReserveGainCellSize or nil

local base_reserve_factory_gain_cell_create_terminal = {
    _name = "base_reserve_factory_gain_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local cell = BaseReserveFactoryGainCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(base_reserve_factory_gain_cell_create_terminal)
state_machine.init()

function BaseReserveFactoryGainCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = index
    self._info = nil
    self._base_build_buff = nil

    app.load("client.red_alert_time.cells.props.props_icon_cell")
    local function init_base_reserve_factory_gain_cell_terminal()

        state_machine.add(base_reserve_factory_gain_cell_use_terminal)       
        state_machine.init()
    end
    init_base_reserve_factory_gain_cell_terminal()           
end

function BaseReserveFactoryGainCell:onUpdateDraw()
    local root = self.roots[1]

    local build_buff_id = dms.int(dms["world_city_mould"], self._info.factory_id, world_city_mould.build_buff_id)
    local factory_buff = dms.string(dms["world_city_mould"], self._info.factory_id, world_city_mould.factory_buff)
    self._base_build_buff = _ED.base_build_buff[""..build_buff_id]

    local Panel_base_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_base_res_icon")
    Panel_base_res_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,3,self._base_build_buff.id,6})
    Panel_base_res_icon:addChild(cell) 

    local Text_base_res_gain_infor = ccui.Helper:seekWidgetByName(root,"Text_base_res_gain_infor")
    local is_leader = false
    if _ED.union.union_info == nil 
        or _ED.union.union_info == {} 
        or _ED.union.union_info.union_id == nil 
        or _ED.union.union_info.union_id == "" 
        or tonumber(_ED.union.union_info.union_id) == 0 
        then
    else
        if tonumber(_ED.union.user_union_info.union_post) == 1 then
            is_leader = true
        end
    end

    local attr = 0
    local factory_buff_info = zstring.split(factory_buff, "|")
    factory_buff_info = zstring.split(factory_buff_info[self._info.factory_level], ",")
    local attr = factory_buff_info[2]
    if is_leader == true then
        attr = factory_buff_info[4]
    end
    local str = string.gsub(self._base_build_buff.info, "!x@", attr.."%%")
    if is_leader == false then
        Text_base_res_gain_infor:setString(string.format(world_city_tip_str[60], str))
    else
        Text_base_res_gain_infor:setString(string.format(world_city_tip_str[61], str))
    end

    local Text_base_res_city_factory_gain_infor = ccui.Helper:seekWidgetByName(root,"Text_base_res_city_factory_gain_infor")
    Text_base_res_city_factory_gain_infor:setString(world_city_tip_str[68])

    local Button_base_res_add = ccui.Helper:seekWidgetByName(root,"Button_base_res_add")
    Button_base_res_add:setVisible(false)
end

function BaseReserveFactoryGainCell:onEnterTransitionFinish()

end

function BaseReserveFactoryGainCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.props.base_reserve_gain_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if BaseReserveGainCellSize == nil then
        BaseReserveGainCellSize = size
    end
    root:setTouchEnabled(false)
    
    self:onUpdateDraw()
end

function BaseReserveFactoryGainCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.props.base_reserve_gain_cell, self.roots[1])
end

function BaseReserveFactoryGainCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function BaseReserveFactoryGainCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.props.base_reserve_gain_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BaseReserveFactoryGainCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_base_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_base_res_icon")
    local Text_base_res_gain_infor = ccui.Helper:seekWidgetByName(root,"Text_base_res_gain_infor")
    local Button_base_res_add = ccui.Helper:seekWidgetByName(root,"Button_base_res_add")
    local Text_base_res_city_factory_gain_infor = ccui.Helper:seekWidgetByName(root,"Text_base_res_city_factory_gain_infor")

    if Panel_base_res_icon ~= nil then
        Panel_base_res_icon:removeAllChildren(true)
        Text_base_res_gain_infor:setString("")
        Button_base_res_add:setVisible(true)
        Text_base_res_city_factory_gain_infor:setString("")
        root:setTouchEnabled(true)
    end
end

function BaseReserveFactoryGainCell:init(params) 
    self._index = params[1]
    self._info = params[2]

    if self._index ~= nil and self._index <= 8 then
        self:onInit()
    end
    self:setContentSize(BaseReserveGainCellSize)
end

