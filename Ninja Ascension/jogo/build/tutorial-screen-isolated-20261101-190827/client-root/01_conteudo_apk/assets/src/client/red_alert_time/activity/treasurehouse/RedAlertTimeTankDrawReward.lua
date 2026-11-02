-- ------------------------------------------------------------------------------------------------------------
--  说明：坦克拉霸奖励详情
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeTankDrawReward = class("RedAlertTimeTankDrawRewardClass", Window)

local red_alert_time_tank_draw_reward_window_open_terminal = {
    _name = "red_alert_time_tank_draw_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeTankDrawRewardClass") then
            fwin:open(RedAlertTimeTankDrawReward:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_tank_draw_reward_window_close_terminal = {
    _name = "red_alert_time_tank_draw_reward_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeTankDrawRewardClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_tank_draw_reward_window_open_terminal)
state_machine.add(red_alert_time_tank_draw_reward_window_close_terminal)
state_machine.init()

function RedAlertTimeTankDrawReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    -- self._Image_seek_reward_arrow_down = nil
    -- self._Image_seek_reward_arrow_up = nil

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_tank_draw_reward_cell")
    app.load("client.red_alert_time.cells.props.props_icon_cell")
    local function init_red_alert_time_tank_draw_reward_terminal()
        local red_alert_time_tank_draw_reward_show_terminal = {
            _name = "red_alert_time_tank_draw_reward_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_tank_draw_reward_hide_terminal = {
            _name = "red_alert_time_tank_draw_reward_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_tank_draw_reward_update_draw_terminal = {
            _name = "red_alert_time_tank_draw_reward_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local posY = instance._list_view_poy
                instance:onUpdateDraw()
                if math.abs(posY) > math.abs(instance._list_view_height) then
                    posY = instance._list_view_height
                end
                instance._list_view:getInnerContainer():setPositionY(posY)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_tank_draw_reward_show_terminal)
        state_machine.add(red_alert_time_tank_draw_reward_hide_terminal)
        state_machine.add(red_alert_time_tank_draw_reward_update_draw_terminal)
        state_machine.init()
    end
    init_red_alert_time_tank_draw_reward_terminal()
end

function RedAlertTimeTankDrawReward:onUpdateDraw()
    local root = self.roots[1]

    local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    self._list_view = ListView_1
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    for k,v in pairs(self._activity_data) do
        local cell = state_machine.excute("red_alert_time_tank_draw_reward_cell_create", 0, {k, v})
        self._list_view:addChild(cell)
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function RedAlertTimeTankDrawReward:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        -- if self._list_view_poy <= -30 then
        --     self._Image_seek_reward_arrow_down:setVisible(true)
        -- else
        --     self._Image_seek_reward_arrow_down:setVisible(false)
        -- end
        -- if self._list_view_poy >= self._list_view_height + 30 then
        --     self._Image_seek_reward_arrow_up:setVisible(true)
        -- else
        --     self._Image_seek_reward_arrow_up:setVisible(false)
        -- end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
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

function RedAlertTimeTankDrawReward:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.tank_draw_reward)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tank_draw_close"), nil, 
    {
        terminal_name = "red_alert_time_tank_draw_reward_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    -- self._Image_seek_reward_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_seek_reward_arrow_down")
    -- self._Image_seek_reward_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_seek_reward_arrow_up")
    
    -- local function playActions(sender)
    --     if sender ~= nil and sender:getParent() ~= nil then
    --         local fadeOut = cc.FadeOut:create(0.5)
    --         local fadeIn = cc.FadeIn:create(0.5)
    --         sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
    --     end
    -- end
    -- self._Image_seek_reward_arrow_down:stopAllActions()
    -- self._Image_seek_reward_arrow_up:stopAllActions()
    -- playActions(self._Image_seek_reward_arrow_down)
    -- playActions(self._Image_seek_reward_arrow_up)
    -- self._Image_seek_reward_arrow_down:setVisible(false)
    -- self._Image_seek_reward_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

function RedAlertTimeTankDrawReward:init(params)
    self._activity_type = params[1]
    self._activity_data = self._activity_type.activity_data[1]
    self:onInit()
    return self
end

function RedAlertTimeTankDrawReward:onExit()
    state_machine.remove("red_alert_time_tank_draw_reward_show")
    state_machine.remove("red_alert_time_tank_draw_reward_hide")
    state_machine.remove("red_alert_time_tank_draw_reward_update_draw")
end