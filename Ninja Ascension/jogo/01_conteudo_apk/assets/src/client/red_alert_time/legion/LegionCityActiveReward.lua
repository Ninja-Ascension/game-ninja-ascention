--------------------------------------------------------------------------------------------------------------
--  说明：军团城市奖励
--------------------------------------------------------------------------------------------------------------
LegionCityActiveReward = class("LegionCityActiveRewardClass", Window)

--打开界面
local legion_city_active_reward_open_terminal = {
    _name = "legion_city_active_reward_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(LegionCityActiveReward:new():init(params), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_active_reward_open_terminal)
state_machine.init()

function LegionCityActiveReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.listview = nil
    self.listview_poy = nil
    self.listview_height = 0

    local function init_legion_city_active_reward_terminal()
        local legion_city_active_reward_show_terminal = {
            _name = "legion_city_active_reward_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_active_reward_hide_terminal = {
            _name = "legion_city_active_reward_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_active_reward_show_terminal)
        state_machine.add(legion_city_active_reward_hide_terminal)
        state_machine.init()
    end
    init_legion_city_active_reward_terminal()
end

function LegionCityActiveReward:onUpdateDraw()
    local root = self.roots[1]
    local ListView_legion_city_reward = ccui.Helper:seekWidgetByName(root, "ListView_legion_city_reward")
    ListView_legion_city_reward:jumpToTop()
    ListView_legion_city_reward:removeAllItems()

    for i = 1, dms.count(dms["world_city_reward"]) do
        local cell = state_machine.excute("legion_city_reward_cell_create", 0, {i})
        ListView_legion_city_reward:addChild(cell)
    end
    ListView_legion_city_reward:requestRefreshView()
    self.listview = ListView_legion_city_reward
    self.listview_poy = ListView_legion_city_reward:getInnerContainer():getPositionY()
    self.listview_height = ListView_legion_city_reward:getInnerContainer():getPositionY()
end

function LegionCityActiveReward:onInit(params)
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_city_active_infor_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw()
end

function LegionCityActiveReward:onUpdate(dt)
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

function LegionCityActiveReward:onEnterTransitionFinish()

end

function LegionCityActiveReward:init(params)
    self._rootWindows = params[1]
    self:onInit(params)
    return self
end

function LegionCityActiveReward:onExit()
    state_machine.remove("legion_city_active_reward_show")
    state_machine.remove("legion_city_active_reward_hide")
end