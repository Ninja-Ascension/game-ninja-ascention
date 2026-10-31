-- ----------------------------------------------------------------------------------------------------
-- 说明：跨服排行规则
-------------------------------------------------------------------------------------------------------
RechargeRuleWindow = class("RechargeRuleWindowClass", Window)

local recharge_rule_window_open_terminal = {
    _name = "recharge_rule_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("RechargeRuleWindowClass") == nil then
            fwin:open(RechargeRuleWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local recharge_rule_window_close_terminal = {
    _name = "recharge_rule_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("RechargeRuleWindowClass") then
            fwin:close(fwin:find("RechargeRuleWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(recharge_rule_window_open_terminal)
state_machine.add(recharge_rule_window_close_terminal)
state_machine.init()

function RechargeRuleWindow:ctor()
    self.super:ctor()
    self.roots = {}
end

function RechargeRuleWindow:init(params)
    return self
end

function RechargeRuleWindow:onUpdate(dt)
end

function RechargeRuleWindow:onUpdateDraw()
    local root = self.roots[1]
end


function RechargeRuleWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/wonderful/recharge_ranking_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
            
    local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    local Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")
    if _ED.recharge_ranking_reward then
        local serverGroup = zstring.split(_ED.recharge_ranking_reward.serverGroup,",")
        local str = ""
        for i,v in pairs(serverGroup) do
           str = str.."   ".._ED.recharge_ranking_reward.serverNameInfo[v]
        end
    Text_1:setString(str)
    Text_1_0:setString(os.date("%Y"..tipStringInfo_time_info[1]
                                                .."%m"..tipStringInfo_time_info[2]
                                                .."%d"..tipStringInfo_time_info[10]
                                                .."%H"..tipStringInfo_time_info[11], getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(_ED.recharge_ranking_reward.timeData.topUpTime)/1000))))
    end

    self:addChild(csbNode)
     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "recharge_rule_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function RechargeRuleWindow:onExit()

end
