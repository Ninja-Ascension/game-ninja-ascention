------------------------------------
-- 坦克改造生产消耗列表
------------------------------------
BuildUpTankReformProcCell = class("BuildUpTankReformProcCellClass", Window)

local build_up_tank_reform_proc_cell_create_terminal = {
    _name = "build_up_tank_reform_proc_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local from_type = params[1]
        local tank_info = params[2]
        local cell = BuildUpTankReformProcCell:new()
        cell:init(from_type, tank_info)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_tank_reform_proc_cell_create_terminal)
state_machine.init()

function BuildUpTankReformProcCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- 1:坦克工厂1,2：坦克工厂2,3：改造工厂, 4：制造工厂
    self._from_type = from_type
    -- 
    self._tank_info = tank_info
    -- 生产数量
    self._select_num = 0

    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0

    -- load lua file
    app.load("client.red_alert_time.cells.build_up.build_up_tank_reform_used_cell")
    local function init_build_up_tank_reform_proc_cell_terminal()
        local build_up_tank_reform_proc_cell_update_terminal = {
            _name = "build_up_tank_reform_proc_cell_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if params ~= nil then
                    instance._select_num = params
                end
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateSelectNumber()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(build_up_tank_reform_proc_cell_update_terminal)
        state_machine.init()
    end

    init_build_up_tank_reform_proc_cell_terminal()
end

function BuildUpTankReformProcCell:updateSelectNumber()
    local items = self.listview:getItems()
    for k, v in pairs(items) do
        state_machine.excute("build_up_tank_reform_used_cell_update_draw", 0, {v, self._select_num})
    end
end

-- 升级需求
function BuildUpTankReformProcCell:updateDraw()
    local root = self.roots[1]

    local tank_data = dms.element(dms["ship_mould"], self._tank_info.tank_id)
    local tank_grow_id = dms.atoi(tank_data, ship_mould.required_material_id)

    local tank_grow_data = dms.element(dms["ship_grow_requirement"], tank_grow_id)
    local tank_update_id = dms.atoi(tank_grow_data, ship_grow_requirement.need_ship_mould1)             -- 改造需要兵种
    local tank_update_count = dms.atoi(tank_grow_data, ship_grow_requirement.need_ship_mould1_count)    -- 改造需要兵种数量

    local need_prop_infos = {}
    -- 消耗前置坦克信息
    local info = {}
    info.prop_type = 1
    info.prop_id = tank_update_id
    info.prop_count = tank_update_count
    table.insert(need_prop_infos, info)
    -- 消耗资源信息
    for i = 1, 4 do
        local info = {}
        info.prop_type = 2
        info.prop_id = tank_from_prop_used_ids[i]
        info.prop_count = dms.atoi(tank_grow_data, ship_grow_requirement.need_iron + i - 1)
        if info.prop_count > 0 then
            table.insert(need_prop_infos, info)
        end
    end
    -- 消耗道具信息
    for i = 1, 4 do
        local info = {}
        info.prop_type = 3
        info.prop_id = dms.atoi(tank_grow_data, ship_grow_requirement.need_prop1 + 2 * (i - 1))
        info.prop_count = dms.atoi(tank_grow_data, ship_grow_requirement.need_prop1 + 2 * (i - 1) + 1)
        if info.prop_id > 0 then
            table.insert(need_prop_infos, info)
        end
    end

    local ListView_res_infor_interactive = ccui.Helper:seekWidgetByName(root,"ListView_res_infor_interactive")
    ListView_res_infor_interactive:jumpToTop()
    ListView_res_infor_interactive:removeAllItems()

    for k, v in pairs(need_prop_infos) do
        local cell = state_machine.excute("build_up_tank_reform_used_cell_create", 0, {k, v, self._select_num})
        ListView_res_infor_interactive:addChild(cell)
    end

    ListView_res_infor_interactive:requestRefreshView()
    ListView_res_infor_interactive:jumpToTop()
    self.listview = ListView_res_infor_interactive
    self.listview_poy = ListView_res_infor_interactive:getInnerContainer():getPositionY()
    self.listview_height = ListView_res_infor_interactive:getInnerContainer():getPositionY()
end


function BuildUpTankReformProcCell:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function BuildUpTankReformProcCell:onInit()
    local csbItem = csb.createNode(string.format(config_csb.cells.build_up.build_up_cell, 3))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    local ListView_res_infor_interactive = ccui.Helper:seekWidgetByName(root, "ListView_res_infor_interactive")
    if nil ~= ListView_res_infor_interactive.setBounceBottomBoundary then
        ListView_res_infor_interactive:setBounceBottomBoundary(0)
    end

    self:updateDraw()
end

function BuildUpTankReformProcCell:onEnterTransitionFinish()
end

function BuildUpTankReformProcCell:init(from_type, tank_info)
    self._from_type = from_type
    self._tank_info = tank_info
    
    self:onInit()
end

function BuildUpTankReformProcCell:onExit()
    state_machine.remove("build_up_tank_reform_proc_cell_update")
end