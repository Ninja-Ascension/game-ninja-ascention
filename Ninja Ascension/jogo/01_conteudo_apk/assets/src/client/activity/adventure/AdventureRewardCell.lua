--------------------------------------------------------------------------------------------------------------
--  说明：限时宝箱规则说明cell
--------------------------------------------------------------------------------------------------------------
AdventureRewardCell = class("AdventureRewardCellClass", Window)
AdventureRewardCell.__size = nil

--创建cell
local adventure_reward_cell_create_terminal = {
    _name = "adventure_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = AdventureRewardCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_reward_cell_create_terminal)
state_machine.init()

function AdventureRewardCell:ctor()
	self.super:ctor()
	self.roots = {}

    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.shop.recharge.RechargeDialog")
    app.load("client.reward.DrawRareReward")
    app.load("client.cells.prop.prop_money_icon")

    self._info = nil

	 -- Initialize adventure_reward_cell state machine.
    local function init_adventure_reward_cell_terminal()

    end 
    -- call func adventure_reward_cell create state machine.
    init_adventure_reward_cell_terminal()

end

function AdventureRewardCell:updateDraw()
    local root = self.roots[1]
    local Panel_obtained_icon = ccui.Helper:seekWidgetByName(root, "Panel_obtained_icon")
    local Text_obtained_01 = ccui.Helper:seekWidgetByName(root, "Text_obtained_01")

    local rewardType = zstring.tonumber(self.reward[1])
    local cell = ResourcesIconCell:createCell()
    if 13 == rewardType then
        local table = {}
        if self.reward[4] ~= nil and tonumber(self.reward[4]) ~= -1 then
            table.shipStar = tonumber(self.reward[4])
        end
        cell:init(rewardType, tonumber(self.reward[3]), tonumber(self.reward[2]),nil,nil,true,true,1,table)
    else
        cell:init(rewardType, tonumber(self.reward[3]), tonumber(self.reward[2]),nil,nil,true,true,1)
    end

    Panel_obtained_icon:addChild(cell)
    Text_obtained_01:setString(tonumber(self.reward[3]))
end


function AdventureRewardCell:onInit()
    local root = cacher.createUIRef("activity/adventure/adv_obtained_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if AdventureRewardCell.__size == nil then
        AdventureRewardCell.__size = root:getContentSize()
    end

	self:updateDraw()
end

function AdventureRewardCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function AdventureRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_obtained_icon = ccui.Helper:seekWidgetByName(root, "Panel_obtained_icon")
    local Text_obtained_01 = ccui.Helper:seekWidgetByName(root, "Text_obtained_01")
    if Panel_obtained_icon then
        Panel_obtained_icon:removeAllChildren(true)
        Text_obtained_01:setString("")
    end
end

function AdventureRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function AdventureRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/adventure/adv_obtained_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function AdventureRewardCell:init(params)
    self.reward = params
	self:onInit()
    self:setContentSize(AdventureRewardCell.__size)
    return self
end

function AdventureRewardCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/adventure/adv_obtained_list.csb", self.roots[1])
end