--------------------------------------------------------------------------------------------------------------
--  说明：军团城市战绩
--------------------------------------------------------------------------------------------------------------
LegionCityActiveMerit = class("LegionCityActiveMeritClass", Window)

--打开界面
local legion_city_active_merit_open_terminal = {
    _name = "legion_city_active_merit_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(LegionCityActiveMerit:new():init(params), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_active_merit_open_terminal)
state_machine.init()

function LegionCityActiveMerit:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self.listview = nil
    self.listview_poy = nil
    self.listview_height = 0

    local function init_legion_city_active_merit_terminal()
        local legion_city_active_merit_show_terminal = {
            _name = "legion_city_active_merit_show",
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

        local legion_city_active_merit_hide_terminal = {
            _name = "legion_city_active_merit_hide",
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

        local legion_city_active_merit_change_page_terminal = {
            _name = "legion_city_active_merit_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_active_merit_show_terminal)
        state_machine.add(legion_city_active_merit_hide_terminal)
        state_machine.add(legion_city_active_merit_change_page_terminal)   
        state_machine.init()
    end
    init_legion_city_active_merit_terminal()
end

function LegionCityActiveMerit:changeSelectPage( page )
    local root = self.roots[1]
    local Button_legion_city_merit_all = ccui.Helper:seekWidgetByName(root, "Button_legion_city_merit_all")
    local Button_legion_city_merit_legion = ccui.Helper:seekWidgetByName(root, "Button_legion_city_merit_legion")
    Button_legion_city_merit_all:setHighlighted(false)
    Button_legion_city_merit_legion:setHighlighted(false)
    if page == 1 then
        Button_legion_city_merit_all:setHighlighted(true)
    elseif page == 2 then
        Button_legion_city_merit_legion:setHighlighted(true)
    end
    if page == self._current_page then
        return
    end
    self._current_page = page
    
    local ListView_legion_city_merit = ccui.Helper:seekWidgetByName(root, "ListView_legion_city_merit")
    ListView_legion_city_merit:jumpToTop()

    local nType = self._current_page - 1
    local arry = _ED.world_city_info.rank_list[""..nType]

    local items = ListView_legion_city_merit:getItems()
    for k,v in pairs(items) do
        state_machine.excute("legion_city_merit_cell_update_info", 0, {cell = v, index = k, _info = arry[k]})
    end

    if #items > #arry then
        local index = 0
        for i=#arry + 1, #items do
            ListView_legion_city_merit:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #arry then
        for i=#items + 1, #arry do
            local cell = state_machine.excute("legion_city_merit_cell_create", 0, {i, arry[i]})
            ListView_legion_city_merit:addChild(cell)
        end
    end

    ListView_legion_city_merit:requestRefreshView()
    self.listview = ListView_legion_city_merit
    self.listview_poy = ListView_legion_city_merit:getInnerContainer():getPositionY()
    self.listview_height = ListView_legion_city_merit:getInnerContainer():getPositionY()

    local Text_legion_city_merit_not_p = ccui.Helper:seekWidgetByName(root, "Text_legion_city_merit_not_p")
    if self._current_page == 2 and #arry == 0 then
        Text_legion_city_merit_not_p:setVisible(true)
    else
        Text_legion_city_merit_not_p:setVisible(false)
    end
end

function LegionCityActiveMerit:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
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

function LegionCityActiveMerit:onInit(params)
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_city_active_infor_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hegemony_fighting_infor"), nil, 
    {
        terminal_name = "legion_city_rule_infor_window_open", 
        terminal_state = 0, 
        touch_black = true,
        infor_type = 2,
    }, nil, 3)      

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_city_merit_all"), nil, 
    {
        terminal_name = "legion_city_active_merit_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_city_merit_legion"), nil, 
    {
        terminal_name = "legion_city_active_merit_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    if params ~= nil and params._datas ~= nil and params._datas._page ~= nil then
        self:changeSelectPage(tonumber(params._datas._page))
    else
        self:changeSelectPage(1)
    end
end

function LegionCityActiveMerit:onEnterTransitionFinish()

end

function LegionCityActiveMerit:init(params)
    self._rootWindows = params[1]
    self:onInit(params)
    return self
end

function LegionCityActiveMerit:onExit()
    state_machine.remove("legion_city_active_merit_show")
    state_machine.remove("legion_city_active_merit_hide")
    state_machine.remove("legion_city_active_info_change_page")
end