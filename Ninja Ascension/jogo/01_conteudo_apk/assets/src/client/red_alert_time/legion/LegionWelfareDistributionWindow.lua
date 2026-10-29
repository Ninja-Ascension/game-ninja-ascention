-- ------------------------------------------------------------------------------------------------------------
--  说明：分配情况
-- ------------------------------------------------------------------------------------------------------------
LegionWelfareDistributionWindow = class("LegionWelfareDistributionWindowClass", Window)

--打开界面
local legion_welfare_distribution_window_open_terminal = {
    _name = "legion_welfare_distribution_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionWelfareDistributionWindowClass") == nil then
            local _win = LegionWelfareDistributionWindow:new()
            _win:init(params)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_welfare_distribution_window_close_terminal = {
    _name = "legion_welfare_distribution_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionWelfareDistributionWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_welfare_distribution_window_open_terminal)
state_machine.add(legion_welfare_distribution_window_close_terminal)
state_machine.init()

function LegionWelfareDistributionWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    app.load("client.red_alert_time.cells.player.input_digital_window")
     -- Initialize alert_home state machine.
    local function init_legion_welfare_distribution_terminal()
        -- 刷新
        local legion_welfare_distribution_update_draw_terminal = {
            _name = "legion_welfare_distribution_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_welfare_distribution_update_draw_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_welfare_distribution_terminal()
end


-- 显示信息
function LegionWelfareDistributionWindow:onUpdateDraw()
    local root = self.roots[1]

    local ListView_member = ccui.Helper:seekWidgetByName(root,"ListView_member")
    ListView_member:jumpToTop()
    ListView_member:removeAllItems()

    if _ED.union.union_reward_number == nil or zstring.tonumber(_ED.union.union_reward_number) == 0 then
        return
    end

    local arry = _ED.union.union_reward_info_list
    local function sortfunction( a,b )
        return tonumber(a.time) > tonumber(b.time)
    end
    table.sort( arry, sortfunction )

    for k,v in pairs(arry) do
        local cell = state_machine.excute("legion_welfare_distribution_window_cell_create", 0, {v, k})
        ListView_member:addChild(cell)
    end

    ListView_member:requestRefreshView()
    self.listview = ListView_member
    self.listview_poy = ListView_member:getInnerContainer():getPositionY()
    self.listview_height = ListView_member:getInnerContainer():getPositionY()
end

function LegionWelfareDistributionWindow:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_welfare_distribution_window_arrow_down:setVisible(true)
        else
            self._Image_welfare_distribution_window_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_welfare_distribution_window_arrow_up:setVisible(true)
        else
            self._Image_welfare_distribution_window_arrow_up:setVisible(false)
        end
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

--初始化界面
function LegionWelfareDistributionWindow:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_welfare_distribution_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_infor_close"), nil, 
    {
        terminal_name = "legion_welfare_distribution_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_welfare_distribution_window_close", 
        terminal_state = 0, 
    }, nil, 3)  


    self._Image_welfare_distribution_window_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_welfare_distribution_window_arrow_down")
    self._Image_welfare_distribution_window_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_welfare_distribution_window_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_welfare_distribution_window_arrow_down:stopAllActions()
    self._Image_welfare_distribution_window_arrow_up:stopAllActions()
    playActions(self._Image_welfare_distribution_window_arrow_down)
    playActions(self._Image_welfare_distribution_window_arrow_up)
    self._Image_welfare_distribution_window_arrow_down:setVisible(false)
    self._Image_welfare_distribution_window_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

--初始化
function LegionWelfareDistributionWindow:init(params)
    self:onInit()
end

--移除状态机
function LegionWelfareDistributionWindow:onExit()
    state_machine.remove("legion_welfare_distribution_update_draw")
end