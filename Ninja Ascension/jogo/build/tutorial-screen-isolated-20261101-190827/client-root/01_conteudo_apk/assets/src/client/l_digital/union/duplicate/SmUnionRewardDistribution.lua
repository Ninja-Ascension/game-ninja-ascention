-- ----------------------------------------------------------------------------------------------------
-- 说明：公会工会副本奖励分配
-------------------------------------------------------------------------------------------------------
SmUnionRewardDistribution = class("SmUnionRewardDistributionClass", Window)

local sm_union_reward_distribution_open_terminal = {
    _name = "sm_union_reward_distribution_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionRewardDistributionClass")
        if nil == _homeWindow then
            local panel = SmUnionRewardDistribution:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_reward_distribution_close_terminal = {
    _name = "sm_union_reward_distribution_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionRewardDistributionClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionRewardDistributionClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_reward_distribution_open_terminal)
state_machine.add(sm_union_reward_distribution_close_terminal)
state_machine.init()
    
function SmUnionRewardDistribution:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    app.load("client.cells.ship.hero_icon_list_cell")
    app.load("client.l_digital.cells.union.union_npc_distribution_list_cell")
    local function init_sm_union_reward_distribution_terminal()
        -- 显示界面
        local sm_union_reward_distribution_display_terminal = {
            _name = "sm_union_reward_distribution_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionRewardDistributionWindow = fwin:find("SmUnionRewardDistributionClass")
                if SmUnionRewardDistributionWindow ~= nil then
                    SmUnionRewardDistributionWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_reward_distribution_hide_terminal = {
            _name = "sm_union_reward_distribution_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionRewardDistributionWindow = fwin:find("SmUnionRewardDistributionClass")
                if SmUnionRewardDistributionWindow ~= nil then
                    SmUnionRewardDistributionWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_reward_distribution_display_terminal)
        state_machine.add(sm_union_reward_distribution_hide_terminal)

        state_machine.init()
    end
    init_sm_union_reward_distribution_terminal()
end

function SmUnionRewardDistribution:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    self.gradListView = ccui.Helper:seekWidgetByName(root, "ListView_fpjl")
    self.gradListView:removeAllItems()
    self.cacheListView = self.gradListView
    self.currentListView = self.cacheListView
    self.currentInnerContainer = self.cacheListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    local index = 0
    table.sort(_ED.union_battle_lucky_reworld, function(c1, c2)
            if c1 ~= nil 
                and c2 ~= nil 
                and zstring.tonumber(c1.user_time) > zstring.tonumber(c2.user_time) then
                return true
            end
            return false
        end)

    for i, v in pairs(_ED.union_battle_lucky_reworld) do
        index = index + 1
        local cell = UnionNpcDistributionListCell:createCell()
        cell:init(v,index)
        self.cacheListView:addChild(cell)
        self.cacheListView:requestRefreshView()
    end

end

function SmUnionRewardDistribution:init()
    self:onInit()
    return self
end

function SmUnionRewardDistribution:onUpdate(dt)

    if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentListView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentListView:getItems()
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

function SmUnionRewardDistribution:onInit()
    local csbSmUnionRewardDistribution = csb.createNode("legion/sm_legion_pve_window_distribution.csb")
    local root = csbSmUnionRewardDistribution:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionRewardDistribution)
    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_reward_distribution_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

end

function SmUnionRewardDistribution:onExit()
    state_machine.remove("sm_union_reward_distribution_display")
    state_machine.remove("sm_union_reward_distribution_hide")
end