-- ------------------------------------------------------------------------------------------------------------
--  说明：军团城市驻防设置
-- ------------------------------------------------------------------------------------------------------------
LegionCityOccupyGarrison = class("LegionCityOccupyGarrisonClass", Window)

--打开界面
local legion_city_occupy_garrison_open_terminal = {
    _name = "legion_city_occupy_garrison_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionCityOccupyGarrisonClass") == nil then
            fwin:open(LegionCityOccupyGarrison:new():init(params), fwin._ui)
        end
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_city_occupy_garrison_close_terminal = {
    _name = "legion_city_occupy_garrison_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionCityOccupyGarrisonClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_occupy_garrison_open_terminal)
state_machine.add(legion_city_occupy_garrison_close_terminal)
state_machine.init()

function LegionCityOccupyGarrison:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._city_id = 0
    self._info = nil

    app.load("client.red_alert_time.cells.legion.legion_city_occupy_garrison_cell")

    local function init_legion_city_occupy_garrison_terminal()
        local legion_city_occupy_garrison_update_list_info_terminal = {
            _name = "legion_city_occupy_garrison_update_list_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_occupy_garrison_update_list_info_terminal)
        state_machine.init()
    end
    init_legion_city_occupy_garrison_terminal()
end

function LegionCityOccupyGarrison:onUpdateDraw(sort_index)
    local root = self.roots[1]
    local ListView_city_occupy_garrison = ccui.Helper:seekWidgetByName(root, "ListView_city_occupy_garrison")
    ListView_city_occupy_garrison:jumpToTop()
    self._list_view = ListView_city_occupy_garrison

    self._info = _ED.world_city_info.detail_info[""..self._city_id]

    local result = {}
    for k, v in pairs(self._info.defencer_list) do
        if tonumber(v.nType) == 0 then
            table.insert(result, v)
        end
    end

    local items = self._list_view:getItems()
    for k,v in pairs(items) do
        state_machine.excute("legion_city_occupy_garrison_cell_update_info", 0, {cell = v, _info = result[k], index = k})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self._list_view:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("legion_city_occupy_garrison_cell_create", 0, {i, result[i], self._info.city_id})
            self._list_view:addChild(cell)
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function LegionCityOccupyGarrison:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
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

function LegionCityOccupyGarrison:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_city_occupy_garrison)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_city_occupy_garrison_colse"), nil, 
    {
        terminal_name = "legion_city_occupy_garrison_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)   
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_city_occupy_garrison_close", 
        terminal_state = 0, 
    }, nil, 3)   

    self:onUpdateDraw()
end

function LegionCityOccupyGarrison:init(params)
    self._city_id = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function LegionCityOccupyGarrison:onExit()
    state_machine.remove("legion_city_occupy_garrison_update_list_info")
end