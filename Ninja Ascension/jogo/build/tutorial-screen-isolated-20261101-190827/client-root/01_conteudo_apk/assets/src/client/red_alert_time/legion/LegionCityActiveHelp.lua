--------------------------------------------------------------------------------------------------------------
--  说明：军团城市规则
--------------------------------------------------------------------------------------------------------------
LegionCityActiveHelp = class("LegionCityActiveHelpClass", Window)

--打开界面
local legion_city_active_help_open_terminal = {
    _name = "legion_city_active_help_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(LegionCityActiveHelp:new():init(params), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_active_help_open_terminal)
state_machine.init()

function LegionCityActiveHelp:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.red_alert_time.legion.LegionCityImageInfor")

    local function init_legion_city_active_help_terminal()
        local legion_city_active_help_show_terminal = {
            _name = "legion_city_active_help_show",
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

        local legion_city_active_help_hide_terminal = {
            _name = "legion_city_active_help_hide",
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

        local legion_city_active_help_change_page_terminal = {
            _name = "legion_city_active_help_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDraw(params._datas.page)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_active_help_show_terminal)
        state_machine.add(legion_city_active_help_hide_terminal)
        state_machine.add(legion_city_active_help_change_page_terminal)
        state_machine.init()
    end
    init_legion_city_active_help_terminal()
end

function LegionCityActiveHelp:onUpdateDraw(page)
    local root = self.roots[1]
    local Button_rebel_haunt_soldier = ccui.Helper:seekWidgetByName(root, "Button_rebel_haunt_soldier")
    local Button_rebel_haunt_leader = ccui.Helper:seekWidgetByName(root, "Button_rebel_haunt_leader")
    local ScrollView_text_legion_city_help = ccui.Helper:seekWidgetByName(root, "ScrollView_text_legion_city_help")
    local ScrollView_text_legion_city_factory_help = ccui.Helper:seekWidgetByName(root, "ScrollView_text_legion_city_factory_help")
    if page == 1 then
        Button_rebel_haunt_soldier:setHighlighted(true)
        Button_rebel_haunt_soldier:setTouchEnabled(false)
        Button_rebel_haunt_leader:setHighlighted(false)
        Button_rebel_haunt_leader:setTouchEnabled(true)
        ScrollView_text_legion_city_help:setVisible(true)
        ScrollView_text_legion_city_factory_help:setVisible(false)
    else
        Button_rebel_haunt_soldier:setHighlighted(false)
        Button_rebel_haunt_soldier:setTouchEnabled(true)
        Button_rebel_haunt_leader:setHighlighted(true)
        Button_rebel_haunt_leader:setTouchEnabled(false)
        ScrollView_text_legion_city_help:setVisible(false)
        ScrollView_text_legion_city_factory_help:setVisible(true)
    end
end

function LegionCityActiveHelp:onInit(params)
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_city_active_infor_tab, 3))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 帮助
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_ctiy_image_infor"), nil, 
    {
        terminal_name = "legion_city_image_infor_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)   

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rebel_haunt_soldier"), nil, 
    {
        terminal_name = "legion_city_active_help_change_page", 
        terminal_state = 0, 
        touch_black = true,
        page = 1,
    }, nil, 1)   

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rebel_haunt_leader"), nil, 
    {
        terminal_name = "legion_city_active_help_change_page", 
        terminal_state = 0, 
        touch_black = true,
        page = 2,
    }, nil, 1)   

    self:onUpdateDraw(1)
end

function LegionCityActiveHelp:onEnterTransitionFinish()

end

function LegionCityActiveHelp:init(params)
    self._rootWindows = params[1]
    self:onInit(params)
    return self
end

function LegionCityActiveHelp:onExit()
    state_machine.remove("legion_city_active_help_show")
    state_machine.remove("legion_city_active_help_hide")
    state_machine.remove("legion_city_active_help_change_page")
end