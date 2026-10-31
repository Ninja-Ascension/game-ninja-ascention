-- ------------------------------------------------------------------------------------------------------------
--  说明：极限挑战结算奖励
-- ------------------------------------------------------------------------------------------------------------
LimitDekaronSettlementReward = class("LimitDekaronSettlementRewardClass", Window)

--打开界面
local limit_dekaron_settlement_reward_window_open_terminal = {
    _name = "limit_dekaron_settlement_reward_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LimitDekaronSettlementRewardClass") == nil then
            local _win = LimitDekaronSettlementReward:new()
            _win:init(params)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local limit_dekaron_settlement_reward_window_close_terminal = {
    _name = "limit_dekaron_settlement_reward_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LimitDekaronSettlementRewardClass"))
        checkRewardObtainDraw()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(limit_dekaron_settlement_reward_window_open_terminal)
state_machine.add(limit_dekaron_settlement_reward_window_close_terminal)
state_machine.init()

function LimitDekaronSettlementReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.scroll_view = nil
    self.scroll_view_poy = 0
    
     -- Initialize alert_home state machine.
    local function init_limit_dekaron_settlement_reward_terminal()

    end
    -- call func alert_home create state machine.
    init_limit_dekaron_settlement_reward_terminal()
end

-- 显示信息
function LimitDekaronSettlementReward:onUpdateDraw()
    local root = self.roots[1]

    -- 闯关信息
    local Text_settlement_reward_infor = ccui.Helper:seekWidgetByName(root, "Text_settlement_reward_infor")
    Text_settlement_reward_infor:removeAllChildren(true)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[253], "fonts/simhei.ttf",19)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, ""..self._npc_count, "fonts/simhei.ttf",19)
    _richText:pushBackElement(re2)
    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[140], "fonts/simhei.ttf",19)
    _richText:pushBackElement(re3)  
    local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, ""..self._star_count, "fonts/simhei.ttf",19)
    _richText:pushBackElement(re4)
    local re5 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[139], "fonts/simhei.ttf",19)
    _richText:pushBackElement(re5)
    _richText:setPosition(cc.p(Text_settlement_reward_infor:getContentSize().width/2,Text_settlement_reward_infor:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_settlement_reward_infor:getContentSize().width,19))
    Text_settlement_reward_infor:addChild(_richText)

    local ScrollView_settlement_reward_icon = ccui.Helper:seekWidgetByName(root, "ScrollView_settlement_reward_icon")
    ScrollView_settlement_reward_icon:removeAllChildren(true)

    if self._rewards ~= nil then
        local reward_info = zstring.split(self._rewards, "|")
        local size = ScrollView_settlement_reward_icon:getContentSize()
        local cell = state_machine.excute("props_icon_create_cell", 0, {6, 1, 1, 1})
        local cell_height = cell:getContentSize().height

        local line_count = math.ceil(#reward_info / 4)
        if size.height < line_count * (cell_height + 30) then
            size.height = line_count * (cell_height + 30)
        end
        ScrollView_settlement_reward_icon:getInnerContainer():setContentSize(cc.size(size.width, size.height))
        ScrollView_settlement_reward_icon:jumpToTop()

        for i,v in pairs(reward_info) do
            if v ~= "" then
                local info = zstring.split(v, ",")
                local prop_id = tonumber(info[1])
                local prop_type = tonumber(info[2])
                local prop_count = tonumber(info[3])
                local cell = nil
                if prop_id > 0 then
                    cell = state_machine.excute("props_icon_create_cell", 0, {6, 1, prop_id, 1, prop_count})
                else
                    cell = state_machine.excute("props_icon_create_cell", 0, {6, 1, prop_type, 1, prop_count})
                end
                ScrollView_settlement_reward_icon:addChild(cell) 

                local row = math.floor((i - 1) % 4)
                local col = math.floor((i - 1) / 4)
                local cell_size = cell:getContentSize()
                cell:setAnchorPoint(cc.p(0, 1))
                cell:setPosition(cc.p(20 + row * (size.width / 4), size.height - col * (cell_size.height + 30)))

                if cell_height == 0 then
                    cell_height = cell_size.height
                end
            end
        end
        self.scroll_view = ScrollView_settlement_reward_icon
        self.scroll_view_poy = ScrollView_settlement_reward_icon:getInnerContainer():getPositionY()
    end
end

--初始化界面
function LimitDekaronSettlementReward:onInit()
    local csbItem = csb.createNode(config_csb.campaign.limit_dekaron_settlement_reward)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_settlement_reward_close"), nil, 
    {
        terminal_name = "limit_dekaron_settlement_reward_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_settlement_reward_sure"), nil, 
    {
        terminal_name = "limit_dekaron_settlement_reward_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "limit_dekaron_settlement_reward_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    self:onUpdateDraw()
end

--初始化
function LimitDekaronSettlementReward:init(params)
    self._rewards = params[1]
    self._npc_count = params[2]
    self._star_count = params[3]
    self:onInit()
end

--移除状态机
function LimitDekaronSettlementReward:onExit()

end