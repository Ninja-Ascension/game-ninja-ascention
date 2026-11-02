-- ----------------------------------------------------------------------------------------------------
-- 说明：大冒险扣除事件
-------------------------------------------------------------------------------------------------------
AdventureBoxIconCell = class("AdventureBoxIconCellClass", Window)

local adventure_box_icon_cell_open_terminal = {
    _name = "adventure_box_icon_cell_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("AdventureBoxIconCellClass") == nil then
            fwin:open(AdventureBoxIconCell:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local adventure_box_icon_cell_close_terminal = {
    _name = "adventure_box_icon_cell_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("AdventureBoxIconCellClass") then
            fwin:close(fwin:find("AdventureBoxIconCellClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_box_icon_cell_open_terminal)
state_machine.add(adventure_box_icon_cell_close_terminal)
state_machine.init()

function AdventureBoxIconCell:ctor()
    self.super:ctor()
    self.roots = {}
end

function AdventureBoxIconCell:init(params)
    self.state = params
    self:onInit()
    return self
end

function AdventureBoxIconCell:onUpdate(dt)
end

function AdventureBoxIconCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_pve_reward_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box")

    local ImageView_pve_reward_star = ccui.Helper:seekWidgetByName(root, "ImageView_pve_reward_star")
    local Panel_pve_reward_box_rec = ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box_rec")
    
    Panel_pve_reward_box:setVisible(false)
    ImageView_pve_reward_star:setVisible(false)
    Panel_pve_reward_box_rec:setVisible(self.state == 1)
end


function AdventureBoxIconCell:onInit()
    local csbNode = csb.createNode("duplicate/pve_reward_sm.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    self:onUpdateDraw()
end

function AdventureBoxIconCell:onExit()

end
