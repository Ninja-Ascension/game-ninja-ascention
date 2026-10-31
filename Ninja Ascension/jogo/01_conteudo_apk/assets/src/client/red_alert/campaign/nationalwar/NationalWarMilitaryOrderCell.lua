-----------------------------
--国家领旨cell
-----------------------------
NationalWarMilitaryOrderCell = class("NationalWarMilitaryOrderCellClass", Window)

local national_war_military_order_create_cell_terminal = {
    _name = "national_war_military_order_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local task_id = params[1]
        local cell = NationalWarMilitaryOrderCell:new()
        cell:init(task_id)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_military_order_create_cell_terminal)
state_machine.init()

function NationalWarMilitaryOrderCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.task_id = nil
end


function NationalWarMilitaryOrderCell:onUpdateDraw()
    local root = self.roots[1]
    local task_name = dms.string(dms["warfare_task"],self.task_id,warfare_task.task_name)
    local remarks = dms.string(dms["warfare_task"],self.task_id,warfare_task.remarks)
    local icon = dms.string(dms["warfare_task"],self.task_id,warfare_task.icon)

    local Panel_military_icon = ccui.Helper:seekWidgetByName(root,"Panel_military_icon")
    local Text_military_name = ccui.Helper:seekWidgetByName(root,"Text_military_name")
    local Text_military_infor = ccui.Helper:seekWidgetByName(root,"Text_military_infor")
    Text_military_name:setString(task_name)
    Text_military_infor:setString(remarks)
    Panel_military_icon:setBackGroundImage("images/ui/play/nationalwar/rw_"..icon..".png")
end

function NationalWarMilitaryOrderCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.campaign.nationalwar.nationalwar_military_order_cell)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)

    local __size = root:getContentSize()
    self:setContentSize(__size)
    table.insert(self.roots, root)
    self:onUpdateDraw() 
end

function NationalWarMilitaryOrderCell:init(task_id)
    self.task_id = tonumber(task_id)
    self:onInit()
    return self
end

function NationalWarMilitaryOrderCell:onExit()

end
