-- ------------------------------------------------------------------------------------------------------------
--  说明：城市战规则说明
-- ------------------------------------------------------------------------------------------------------------
LegionCityRuleInfor = class("LegionCityRuleInforClass", Window)

--打开界面
local legion_city_rule_infor_window_open_terminal = {
    _name = "legion_city_rule_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionCityRuleInforClass") == nil then
            local _win = LegionCityRuleInfor:new()
            local infor_type = params._datas.infor_type
            _win:init(infor_type)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_city_rule_infor_window_close_terminal = {
    _name = "legion_city_rule_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionCityRuleInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_city_rule_infor_window_open_terminal)
state_machine.add(legion_city_rule_infor_window_close_terminal)
state_machine.init()

function LegionCityRuleInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    app.load("client.red_alert_time.legion.LegionCityRewardLook")
    
     -- Initialize alert_home state machine.
    local function init_legion_city_rule_infor_terminal()

    end
    -- call func alert_home create state machine.
    init_legion_city_rule_infor_terminal()
end

-- 显示信息
function LegionCityRuleInfor:onUpdateDraw()
    local root = self.roots[1]
end

--初始化界面
function LegionCityRuleInfor:onInit()
    local csbItem = nil
    if self._infor_type == 1 then    
        csbItem = csb.createNode(config_csb.legion.legion_city_help_infor)
    elseif self._infor_type == 2 then    
        csbItem = csb.createNode(config_csb.legion.legion_city_merit_infor_rule)
    elseif self._infor_type == 3 then 
        csbItem = csb.createNode(config_csb.legion.legion_city_occupy_rule)
    elseif self._infor_type == 4 then 
        csbItem = csb.createNode(config_csb.legion.legion_city_rule)
    elseif self._infor_type == 5 then 
        csbItem = csb.createNode(config_csb.legion.legion_city_occupy_infor_rule)
    elseif self._infor_type == 6 then 
        csbItem = csb.createNode(config_csb.legion.legion_city_occupy_factory_rule)
    elseif self._infor_type == 7 then 
        csbItem = csb.createNode(config_csb.legion.legion_city_shop_rule)
    elseif self._infor_type == 8 then 
        csbItem = csb.createNode(config_csb.legion.legion_city_formation_infor)
    end
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res_infor_close"), nil, 
    {
        terminal_name = "legion_city_rule_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_member_vs_close"), nil, 
    {
        terminal_name = "legion_city_rule_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_city_rule_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 奖励预览
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_reward"), nil, 
    {
        terminal_name = "legion_city_reward_look_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    self:onUpdateDraw()
end

--初始化
function LegionCityRuleInfor:init(infor_type)
    self._infor_type = infor_type
    self:onInit()
end

--移除状态机
function LegionCityRuleInfor:onExit()

end