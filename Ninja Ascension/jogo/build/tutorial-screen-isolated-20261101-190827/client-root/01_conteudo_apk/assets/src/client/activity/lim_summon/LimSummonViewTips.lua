LimSummonViewTips = class("LimSummonViewTipsClass", Window)

-- 打开窗口
local lim_summon_view_tips_window_open_terminal = {
    _name = "lim_summon_view_tips_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("LimSummonViewTipsClass") then
            fwin:open(LimSummonViewTips:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local lim_summon_view_tips_window_close_terminal = {
    _name = "lim_summon_view_tips_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LimSummonViewTipsClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(lim_summon_view_tips_window_open_terminal)
state_machine.add(lim_summon_view_tips_window_close_terminal)
state_machine.init()

function LimSummonViewTips:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_lim_summon_view_tips_terminal()
        
        local lim_summon_view_tips_close_terminal = 
        {
            _name = "lim_summon_view_tips_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("LimSummonViewTipsClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local lim_summon_view_tips_confirm_terminal = 
        {
            _name = "lim_summon_view_tips_confirm",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    instance.callback(instance.type)
                    
                    fwin:close(fwin:find("LimSummonViewTipsClass"))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(lim_summon_view_tips_close_terminal)
        state_machine.add(lim_summon_view_tips_confirm_terminal)

        state_machine.init()
    end

    init_lim_summon_view_tips_terminal()
end

function LimSummonViewTips:init(params)
    self.params = params
    
    self:initData()
    
    if nil ~= self.onInit then
        self:onInit(params)
    end

    return self
end

function LimSummonViewTips:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/lim_summon/lim_summon_tips.csb")
    self:addChild(csbNode)

    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)

    -- 定义按钮控件
    self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
    {
        terminal_name = "lim_summon_view_tips_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)
    
    self.Button_ok = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"), nil,
    {
        terminal_name = "lim_summon_view_tips_confirm",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    self:onUpdateDraw()
    self:showData()
end

function LimSummonViewTips:onUpdateDraw()
    local root = self.roots[1]

    -- 定义除按钮外的其他UI控件
    self.Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
end

function LimSummonViewTips:initData()
    -- 更新数据
    self.type = self.params.type
    self.countNeed = self.params.countNeed
    self.callback = self.params.callback

    self.costDiamond = self.countNeed * LimSummonMgr:GetInstance().nPriceRecruit
end

function LimSummonViewTips:showData()
    -- 更新显示
    local sTips = tipStringInfo_lim_summon_up[3]
    local sContent = string.format(sTips, self.costDiamond, self.countNeed)
    self.Text_tip:setString(sContent)
end

function LimSummonViewTips:onExit()
    state_machine.remove("lim_summon_view_tips_close")
    state_machine.remove("lim_summon_view_tips_confirm")
end

function LimSummonViewTips:close()

end

function LimSummonViewTips:destroy(window)
 
end