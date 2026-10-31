-- ------------------------------------------------------------------------------------------------------------
--  说明：城市战奖励预览
-- ------------------------------------------------------------------------------------------------------------
LegionCityRewardLook = class("LegionCityRewardLookClass", Window)

--打开界面
local legion_city_reward_look_window_open_terminal = {
    _name = "legion_city_reward_look_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionCityRewardLookClass") == nil then
            local _win = LegionCityRewardLook:new()
            _win:init(params)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_city_reward_look_window_close_terminal = {
    _name = "legion_city_reward_look_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionCityRewardLookClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_city_reward_look_window_open_terminal)
state_machine.add(legion_city_reward_look_window_close_terminal)
state_machine.init()

function LegionCityRewardLook:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
     -- Initialize alert_home state machine.
    local function init_legion_city_reward_look_terminal()

    end
    -- call func alert_home create state machine.
    init_legion_city_reward_look_terminal()
end

-- 显示信息
function LegionCityRewardLook:onUpdateDraw()
    local root = self.roots[1]
    local reward_info = zstring.split(dms.string(dms["world_city_config"], 16, world_city_config.param), "!")
    -- 占领奖励
    local occupy_reward = zstring.split(reward_info[1], "|")
    for i = 1, 4 do
        local Panel_city_reward_look_icon = ccui.Helper:seekWidgetByName(root, "Panel_city_reward_look_icon_"..i)

        if occupy_reward[i] ~= nil then
            Panel_city_reward_look_icon:removeAllChildren(true)
            local info = zstring.split(occupy_reward[i], ",")
            local prop_data = {}
            prop_data.prop_item = tonumber(info[1])
            prop_data.prop_type = tonumber(info[2])
            prop_data.item_value = tonumber(info[3])

            local cell = createPropIconCell(prop_data, false, true, true)
            Panel_city_reward_look_icon:addChild(cell)
        end
    end

    -- 排名奖励
    local rank_reward = zstring.split(reward_info[2], "|")
    for i = 1, 3 do
        local Panel_city_reward_look_icon_rank = ccui.Helper:seekWidgetByName(root, "Panel_city_reward_look_icon_rank_"..i)

        if rank_reward[i] ~= nil then
            Panel_city_reward_look_icon_rank:removeAllChildren(true)
            local info = zstring.split(rank_reward[i], ",")
            local prop_data = {}
            prop_data.prop_item = tonumber(info[1])
            prop_data.prop_type = tonumber(info[2])
            prop_data.item_value = tonumber(info[3])

            local cell = createPropIconCell(prop_data, false, true, true)
            Panel_city_reward_look_icon_rank:addChild(cell)
        end
    end
end

--初始化界面
function LegionCityRewardLook:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_city_reward_look)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_shop_close"), nil, 
    {
        terminal_name = "legion_city_reward_look_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
end

--初始化
function LegionCityRewardLook:init(infor_type)

    self:onInit()
end

--移除状态机
function LegionCityRewardLook:onExit()

end