--------------------------------------------------------------------------------------------------------------
--  增益页面
--------------------------------------------------------------------------------------------------------------
FormationFactor = class("FormationFactorClass", Window)

local formation_factor_window_open_terminal = {
    _name = "formation_factor_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = FormationFactor:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_factor_window_open_terminal)
state_machine.init()

function FormationFactor:ctor()
    self.super:ctor()
    self.roots = {}

    -- 
    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_shop_arrow_down = nil
    self._Image_shop_arrow_up = nil

    self._last_page_index = 1

    app.load("client.red_alert_time.cells.props.base_reserve_gain_cell")
    app.load("client.red_alert_time.cells.props.base_reserve_gain_ing_cell")

    -- Initialize formation_factor state machine.
    local function init_formation_factor_terminal()
        local formation_factor_show_terminal = {
            _name = "formation_factor_show",
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

        local formation_factor_hide_terminal = {
            _name = "formation_factor_hide",
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

        local formation_factor_update_terminal = {
            _name = "formation_factor_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local posY = instance._list_view_poy
                instance:updateDraw()
                if math.abs(posY) > math.abs(instance._list_view_height) then
                    posY = instance._list_view_height
                end
                instance._list_view:getInnerContainer():setPositionY(posY)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(formation_factor_show_terminal)
        state_machine.add(formation_factor_hide_terminal)
        state_machine.add(formation_factor_update_terminal)
        state_machine.init()
    end
    
    -- call func formation_factor create state machine.
    init_formation_factor_terminal()

end

function FormationFactor:updateDraw()
    local root = self.roots[1]

    local ListView_troops_gain = ccui.Helper:seekWidgetByName(root, "ListView_troops_gain")
    ListView_troops_gain:jumpToTop()
    ListView_troops_gain:removeAllItems()

    local have_factor_buff = {}         -- 有增益生效
    local no_factor_buff = {}
    local buff_info = {}
    for k,v in pairs(_ED.factor_info) do
        if tonumber(v.build_buff_id) == 6 
            or tonumber(v.build_buff_id) == 7 
            or tonumber(v.build_buff_id) == 8 
            then
            buff_info[""..v.build_buff_id] = tonumber(v.factor_cd_time)-- + zstring.tonumber(buff_info[""..v.build_buff_id])
        end
    end

    for k, v in pairs(_ED.base_build_buff) do
        if tonumber(k) == 6 or tonumber(k) == 7 or tonumber(k) == 8 then
            if buff_info[""..k] == nil then
                table.insert(no_factor_buff, v)
            elseif buff_info[""..k] ~= nil then
                table.insert(have_factor_buff, v)
            end
        end
    end

    function sortByCdTime(a, b)
        local factor_cd_time_1 = tonumber(buff_info[""..a.id])
        local factor_cd_time_2 = tonumber(buff_info[""..b.id])
        return factor_cd_time_1 > factor_cd_time_2
    end
    table.sort(have_factor_buff, sortByCdTime)

    function sortFunction(a, b)
        return a.id < b.id
    end
    table.sort(no_factor_buff, sortFunction)

    local index = 1

    for k, v in pairs(have_factor_buff) do
        local cell = state_machine.excute("base_reserve_gain_ing_cell_create", 0, {index, v})
        ListView_troops_gain:addChild(cell)
        index = index + 1
    end

    for k, v in pairs(no_factor_buff) do
        local cell = state_machine.excute("base_reserve_gain_cell_create", 0, {index, v})
        ListView_troops_gain:addChild(cell)
        index = index + 1
    end

    self._list_view = ListView_troops_gain
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function FormationFactor:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
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

function FormationFactor:onInit()
    local csbItem = csb.createNode(string.format(config_csb.formation.formation_tab, "4"))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:updateDraw()
end

function FormationFactor:onEnterTransitionFinish()
    
end

function FormationFactor:init(params)
    local rootWindow = params[1]

    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function FormationFactor:onExit()
    state_machine.remove("formation_factor_show")
    state_machine.remove("formation_factor_hide")
    state_machine.remove("formation_factor_update")
end