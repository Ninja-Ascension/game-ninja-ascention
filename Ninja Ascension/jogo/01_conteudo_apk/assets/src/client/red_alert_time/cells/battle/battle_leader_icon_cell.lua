-- ---------------------------------------------------------------------------------
-- 将领头像
-- ---------------------------------------------------------------------------------
BattleLeaderIconCell = class("BattleLeaderIconCellClass", Window)
BattleLeaderIconCell.__size = nil

local battle_leader_icon_cell_create_terminal = {
    _name = "battle_leader_icon_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = BattleLeaderIconCell:new()
        local index = params[1]
        local shipMouldId = params[2]
        cell:init(index, shipMouldId)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_leader_icon_cell_create_terminal)
state_machine.init()

function BattleLeaderIconCell:ctor()
    self.super:ctor()
    self.roots = {}

    -- var
    self.index = 0

    self.shipMouldId = nil

    self._size = nil

    -- Initialize battle_leader_icon_cell machine.
    local function init_battle_leader_icon_cell_terminal()

        state_machine.init()
    end
    
    -- call func init battle_leader_icon_cell machine.
    init_battle_leader_icon_cell_terminal()
end

function BattleLeaderIconCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_leader_number = ccui.Helper:seekWidgetByName(root,"Text_leader_number")
    Text_leader_number:setString("" .. self.index)

    if zstring.tonumber(self.shipMouldId) > 0 then
        local picIndexs = zstring.split(dms.string(dms["ship_mould"], self.shipMouldId, ship_mould.head_icon), ",")
        local Panel_leader_icon = ccui.Helper:seekWidgetByName(root,"Panel_leader_icon")
        Panel_leader_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndexs[1])) 

        local ship_type = dms.int(dms["ship_mould"], self.shipMouldId, ship_mould.ship_type)
        local Text_leader_star_number = ccui.Helper:seekWidgetByName(root,"Text_leader_star_number")
        Text_leader_star_number:setString("" .. ship_type)
    end
end

function BattleLeaderIconCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.battle.battle_leader_icon_cell)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)

    BattleLeaderIconCell.__size = root:getContentSize()
    self:setContentSize(BattleLeaderIconCell.__size)

    self._size = BattleLeaderIconCell.__size

    self:addChild(root)

    self:onUpdateDraw() 
end

function BattleLeaderIconCell:init(index, shipMouldId)
    self.index = index
    self.shipMouldId = shipMouldId
    self:onInit()
    return self
end

function BattleLeaderIconCell:onExit()
   
end
-- ---------------------------------------------------------------------------------