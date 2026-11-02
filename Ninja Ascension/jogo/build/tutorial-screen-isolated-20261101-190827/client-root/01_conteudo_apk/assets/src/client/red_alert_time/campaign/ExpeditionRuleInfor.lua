-- ------------------------------------------------------------------------------------------------------------
--  说明：作战中心规则说明
-- ------------------------------------------------------------------------------------------------------------
ExpeditionRuleInfor = class("ExpeditionRuleInforClass", Window)

--打开界面
local expedition_rule_infor_window_open_terminal = {
    _name = "expedition_rule_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("ExpeditionRuleInforClass") == nil then
            local _win = ExpeditionRuleInfor:new()
            local infor_type = params
            _win:init(infor_type)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local expedition_rule_infor_window_close_terminal = {
    _name = "expedition_rule_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ExpeditionRuleInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(expedition_rule_infor_window_open_terminal)
state_machine.add(expedition_rule_infor_window_close_terminal)
state_machine.init()

function ExpeditionRuleInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
     -- Initialize alert_home state machine.
    local function init_expedition_rule_infor_terminal()

    end
    -- call func alert_home create state machine.
    init_expedition_rule_infor_terminal()
end

-- 显示信息
function ExpeditionRuleInfor:onUpdateDraw()
    local root = self.roots[1]
    if self._infor_type == 122 then 
        local ListView_rule = ccui.Helper:seekWidgetByName(root, "ListView_rule")
        self._list_view = ListView_rule
        self._list_view:jumpToTop()

        self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
        self._list_view_height = self._list_view:getInnerContainer():getPositionY()

        self._list_view:requestRefreshView()
    end
    
end

function ExpeditionRuleInfor:onUpdate(dt)
    if self._infor_type == 122 then 
        if self._list_view ~= nil then
            local size = self._list_view:getContentSize()
            local posY = self._list_view:getInnerContainer():getPositionY()
            if self._list_view_height == 0 then
                self._list_view_height = posY
            end
            if self._list_view_poy <= -30 then
                self._Image_rule_arrow_down:setVisible(true)
            else
                self._Image_rule_arrow_down:setVisible(false)
            end
            if self._list_view_poy >= self._list_view_height + 30 then
                self._Image_rule_arrow_up:setVisible(true)
            else
                self._Image_rule_arrow_up:setVisible(false)
            end
            if self._list_view_poy == posY then
                return
            end
            self._list_view_poy = posY
            local items = self._list_view:getItems()
            if items[1] == nil then
                return
            end
            local itemSize = items[1]:getContentSize()
        end
    end
end

--初始化界面
function ExpeditionRuleInfor:onInit()
    local csbItem = nil
    if self._infor_type == 1 then    
        csbItem = csb.createNode(config_csb.arena.arena_rule_infor)
    elseif self._infor_type == 2 then    
        csbItem = csb.createNode(config_csb.campaign.expedition_rule_infor)
    elseif self._infor_type == 3 then 
        csbItem = csb.createNode(config_csb.campaign.super_scholar_rule_infor)
    elseif self._infor_type == 4 then 
        csbItem = csb.createNode(config_csb.campaign.enemy_strike_rule_infor)
    elseif self._infor_type == 5 then 
        csbItem = csb.createNode(config_csb.campaign.rebel_haunt_rule_infor)    
    elseif self._infor_type == 6 then 
        csbItem = csb.createNode(config_csb.campaign.limit_dekaron_rule_infor)   
    elseif self._infor_type == 62 then 
        csbItem = csb.createNode(config_csb.campaign.limit_dekaron_battle_rule)   
    elseif self._infor_type == 12 then 
        csbItem = csb.createNode(config_csb.campaign.camp_pk_rule_infor)
    elseif self._infor_type == 122 then 
        csbItem = csb.createNode(config_csb.campaign.camp_pk_rule_infor_x)
    elseif self._infor_type == 13 then 
        csbItem = csb.createNode(config_csb.campaign.guard_battle_rule_infor)
    end
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res_infor_close"), nil, 
    {
        terminal_name = "expedition_rule_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "expedition_rule_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    if self._infor_type == 122 then 
        self._Image_rule_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_rule_arrow_down")
        self._Image_rule_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_rule_arrow_up")
        
        local function playActions(sender)
            if sender ~= nil and sender:getParent() ~= nil then
                local fadeOut = cc.FadeOut:create(0.5)
                local fadeIn = cc.FadeIn:create(0.5)
                sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
            end
        end
        self._Image_rule_arrow_down:stopAllActions()
        self._Image_rule_arrow_up:stopAllActions()
        playActions(self._Image_rule_arrow_down)
        playActions(self._Image_rule_arrow_up)
        self._Image_rule_arrow_down:setVisible(false)
        self._Image_rule_arrow_up:setVisible(false)
    end

    self:onUpdateDraw()
end

--初始化
function ExpeditionRuleInfor:init(infor_type)
    self._infor_type = infor_type
    self:onInit()
end

--移除状态机
function ExpeditionRuleInfor:onExit()

end