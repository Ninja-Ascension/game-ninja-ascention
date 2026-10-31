-- ------------------------------------------------------------------------------------------------------------
--  说明：消消乐奖励道具预览
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeEliminateMusicRewardLook = class("RedAlertTimeEliminateMusicRewardLookClass", Window)

local red_alert_time_eliminate_music_reward_look_window_open_terminal = {
    _name = "red_alert_time_eliminate_music_reward_look_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeEliminateMusicRewardLookClass") then
            fwin:open(RedAlertTimeEliminateMusicRewardLook:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_eliminate_music_reward_look_window_close_terminal = {
    _name = "red_alert_time_eliminate_music_reward_look_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeEliminateMusicRewardLookClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_eliminate_music_reward_look_window_open_terminal)
state_machine.add(red_alert_time_eliminate_music_reward_look_window_close_terminal)
state_machine.init()

function RedAlertTimeEliminateMusicRewardLook:ctor()
    self.super:ctor()
    self.roots = {}
    self._name = nil
    self._reward_info = {}
    self.iconGroup = {}

    app.load("client.red_alert_time.cells.props.props_icon_cell")
    -- local function init_red_alert_time_eliminate_music_reward_look_terminal()
    --     local red_alert_time_eliminate_music_reward_look_show_terminal = {
    --         _name = "red_alert_time_eliminate_music_reward_look_show",
    --         _init = function (terminal) 
                
    --         end,
    --         _inited = false,
    --         _instance = self,
    --         _state = 0,
    --         _invoke = function(terminal, instance, params)
    --             instance:setVisible(true)
    --             return true
    --         end,
    --         _terminal = nil,
    --         _terminals = nil
    --     }

    --     state_machine.add(red_alert_time_eliminate_music_reward_look_show_terminal)

    --     state_machine.init()
    -- end
    -- init_red_alert_time_eliminate_music_reward_look_terminal()
end

function RedAlertTimeEliminateMusicRewardLook:updateDraw()
    local root = self.roots[1]
    local Panel_reward_box = ccui.Helper:seekWidgetByName(root,"Panel_reward_box")
    local Image_act_congratulations_get_box = ccui.Helper:seekWidgetByName(root,"Image_act_congratulations_get_box")
    local Panel_window_box = ccui.Helper:seekWidgetByName(root,"Panel_window_box")
    local Image_height = Image_act_congratulations_get_box:getContentSize().height
    Panel_reward_box:removeAllChildren(true)
    local total_height = 0
    for i , v in pairs(self._reward_info) do
        if v ~= nil then
            local cell = state_machine.excute("red_alert_time_eliminate_music_reward_look_cell_create",0,v)
            total_height = cell:getContentSize().height + total_height
            cell:setPositionY(Panel_reward_box:getContentSize().height - total_height)
            Panel_reward_box:addChild(cell)
        end
    end
    local float_height = total_height - Panel_reward_box:getContentSize().height
    Image_act_congratulations_get_box:setContentSize(cc.size(Image_act_congratulations_get_box:getContentSize().width,Image_height + float_height))
    Panel_window_box:setPositionY(Panel_window_box:getPositionY() + float_height / 2)
end

function RedAlertTimeEliminateMusicRewardLook:onInit(index)
    local csbItem = csb.createNode(config_csb.treasurehouse.eliminate_music_reward_look)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_congratulations_get_close"), nil, 
    {
        terminal_name = "red_alert_time_eliminate_music_reward_look_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    if self._name ~= nil then
        ccui.Helper:seekWidgetByName(root, "Text_act_congratulations_get_name"):setString(self._name)
    end
    self:updateDraw()
end

function RedAlertTimeEliminateMusicRewardLook:init(params)
    self._reward_info = params._data
    self._name = params._name
    self:onInit()
    return self
end

function RedAlertTimeEliminateMusicRewardLook:onExit()
    --state_machine.remove("red_alert_time_eliminate_music_reward_look_show")
end