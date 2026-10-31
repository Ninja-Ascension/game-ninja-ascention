-- --------------------------------------------------------------------------------------------------
-- 说明：基地储备增益cell
-- -----------------------------------------------------------------------------------------------------
BaseReserveGainCell = class("BaseReserveGainCellClass", Window)
BaseReserveGainCellSize = BaseReserveGainCellSize or nil

local base_reserve_gain_cell_create_terminal = {
    _name = "base_reserve_gain_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local cell = BaseReserveGainCell:new()
        local index = params[1]
        local base_build_buff = params[2]
        cell:init(index, base_build_buff)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.1)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(base_reserve_gain_cell_create_terminal)
state_machine.init()

function BaseReserveGainCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = index
    self._last_time = 0
    self._max_time = 0
    self._start_time = 0
    self._need_gold = 0

    app.load("client.red_alert_time.cells.props.props_icon_cell")
    local function init_base_reserve_gain_cell_terminal()

        local base_reserve_gain_cell_use_terminal = {
            _name = "base_reserve_gain_cell_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local shop_id = cell._base_build_buff.shop_id
                if shop_id > 0 then
                    local prop_ids_info = dms.string(dms["build_shop"], shop_id, build_shop.prop_ids)
                    local prop_ids = zstring.split(prop_ids_info, ",")
                    local buy_type = dms.int(dms["build_shop"], shop_id, build_shop.buy_type)
                    state_machine.excute("props_use_window_open",0,{shop_id, prop_ids, buy_type})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(base_reserve_gain_cell_use_terminal)       
        state_machine.init()
    end
    init_base_reserve_gain_cell_terminal()           
end

function BaseReserveGainCell:onUpdateDraw()
    local root = self.roots[1]

    local Panel_base_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_base_res_icon")
    Panel_base_res_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,3,self._base_build_buff.id,6})
    Panel_base_res_icon:addChild(cell) 
    local Text_base_res_gain_infor = ccui.Helper:seekWidgetByName(root,"Text_base_res_gain_infor")
    Text_base_res_gain_infor:setString(self._base_build_buff.info)

    local Button_base_res_add = ccui.Helper:seekWidgetByName(root,"Button_base_res_add")
    if self._base_build_buff.shop_id < 0 then
        Button_base_res_add:setVisible(false)
    else
        Button_base_res_add:setVisible(true)
    end
end

function BaseReserveGainCell:setSelected()

end

function BaseReserveGainCell:onEnterTransitionFinish()

end

function BaseReserveGainCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.props.base_reserve_gain_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if BaseReserveGainCellSize == nil then
        BaseReserveGainCellSize = size
    end

    root:setSwallowTouches(false)
    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "base_reserve_gain_cell_use", 
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    -- 使用
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_base_res_add"), nil, 
    {
        terminal_name = "base_reserve_gain_cell_use",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)
    
    self:onUpdateDraw()
end

function BaseReserveGainCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.props.base_reserve_gain_cell, self.roots[1])
end

function BaseReserveGainCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function BaseReserveGainCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.props.base_reserve_gain_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BaseReserveGainCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_base_res_icon = ccui.Helper:seekWidgetByName(root,"Panel_base_res_icon")
    local Text_base_res_gain_infor = ccui.Helper:seekWidgetByName(root,"Text_base_res_gain_infor")
    local Button_base_res_add = ccui.Helper:seekWidgetByName(root,"Button_base_res_add")

    if Panel_base_res_icon ~= nil then
        Panel_base_res_icon:removeAllChildren(true)
        Text_base_res_gain_infor:setString(self._base_build_buff.info)
        Button_base_res_add:setVisible(true)
    end
end

function BaseReserveGainCell:init(index, base_build_buff) 
    self._index = index
    self._base_build_buff = base_build_buff

    if index ~= nil and index <= 8 then
        self:onInit()
    end
    self:setContentSize(BaseReserveGainCellSize)
end

