--------------------------------------------------------------------------------------------------------------
--  说明：军团城市详情
--------------------------------------------------------------------------------------------------------------
LegionCityActiveInfo = class("LegionCityActiveInfoClass", Window)

--打开界面
local legion_city_active_info_open_terminal = {
    _name = "legion_city_active_info_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("LegionCityActiveInfoClass") == nil then
            fwin:open(LegionCityActiveInfo:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_city_active_info_close_terminal = {
    _name = "legion_city_active_info_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionCityActiveInfoClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_active_info_open_terminal)
state_machine.add(legion_city_active_info_close_terminal)
state_machine.init()

function LegionCityActiveInfo:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self._helpPanel = nil

    app.load("client.red_alert_time.legion.LegionCityActiveHelp")

    local function init_legion_city_active_info_terminal()

    end
    init_legion_city_active_info_terminal()
end

function LegionCityActiveInfo:changeSelectPage()
    local root = self.roots[1]
    local Panel_legion_ctiy_active_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_legion_ctiy_active_tab_box")
    Panel_legion_ctiy_active_tab_box:removeAllChildren(true)
    state_machine.excute("legion_city_active_help_open", 0, {Panel_legion_ctiy_active_tab_box})
end

function LegionCityActiveInfo:onInit(params)
    local csbItem = csb.createNode(config_csb.legion.legion_city_active_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_shop_close"), nil, 
    {
        terminal_name = "legion_city_active_info_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)   

    self:changeSelectPage()   
end

function LegionCityActiveInfo:onEnterTransitionFinish()

end

function LegionCityActiveInfo:init(params)
    self:onInit(params)
    return self
end

function LegionCityActiveInfo:onExit()
    
end