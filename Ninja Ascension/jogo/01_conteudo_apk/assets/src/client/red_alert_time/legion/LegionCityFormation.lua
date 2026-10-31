-----------------------------
-- 城市战部队兑换界面
-----------------------------
LegionCityFormation = class("LegionCityFormationClass", Window)

local legion_city_formation_window_open_terminal = {
    _name = "legion_city_formation_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local function responseCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if nil == fwin:find("LegionCityFormationClass") then
                    local panel = LegionCityFormation:new():init(params)
                    fwin:open(panel, fwin._ui)
                end  
            end
        end
        NetworkManager:register(protocol_command.get_ship_count.code, nil, nil, nil, nil, responseCallback, false, nil)      
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local legion_city_formation_window_close_terminal = {
    _name = "legion_city_formation_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activityWindow = fwin:find("LegionCityFormationClass")
        fwin:close(activityWindow)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_formation_window_open_terminal)
state_machine.add(legion_city_formation_window_close_terminal)
state_machine.init()

function LegionCityFormation:ctor()
    self.super:ctor()
    self.roots = {}
    
    app.load("client.red_alert_time.formation.FormationChooseTroop")
    app.load("client.red_alert_time.cells.build_up.build_up_tank_factory_tank_cell")

    app.load("client.red_alert_time.legion.LegionCityRuleInfor")

    local function init_legion_city_formation_terminal()
        -- 刷新
        local legion_city_formation_update_draw_terminal = {
            _name = "legion_city_formation_update_draw",
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

        local legion_city_formation_change_terminal = {
            _name = "legion_city_formation_change",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("formation_choose_troop_window_open", 0, {0, {}, 18})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_formation_update_draw_terminal)
        state_machine.add(legion_city_formation_change_terminal)
        state_machine.init()
    end
    init_legion_city_formation_terminal()
end

-- 刷新界面
function LegionCityFormation:onUpdateDraw()
    local root = self.roots[1]
    local ScrollView_production = ccui.Helper:seekWidgetByName(root,"ScrollView_production")
    ScrollView_production:removeAllChildren(true)

    local width = ScrollView_production:getContentSize().width
    local height = ScrollView_production:getContentSize().height
    local temp_cell = state_machine.excute("build_up_tank_factory_tank_cell_create",0,{0})
    local size = temp_cell:getContentSize()

    local result_tank = {}
    for k, v in pairs(_ED.user_ship) do
        if tonumber(v.captain_type) ~= 3 and zstring.tonumber(v.city_ship_count) > 0 then
            local order = dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.base_mould_priority)        -- 排序
            local tank_info = {}
            tank_info.tank_id = v.ship_template_id
            tank_info.order = order
            tank_info.ship_type = tonumber(v.ship_type)
            tank_info.camp_preference = tonumber(v.camp_preference)
            tank_info.count = zstring.tonumber(v.city_ship_count)         -- 拥有的城市战部队

            table.insert(result_tank, tank_info)
        end
    end

    local order_types = {3, 1, 2, 4}        -- 按火箭、坦克、火炮、特种兵顺序排序
    local function sortTank(a, b)
        if a.ship_type > b.ship_type
            or (a.ship_type == b.ship_type and order_types[a.camp_preference] > order_types[b.camp_preference])
            or (a.ship_type == b.ship_type and order_types[a.camp_preference] == order_types[b.camp_preference] and a.order > b.order)
            then
            return true
        end 
        return false
    end
    table.sort(result_tank, sortTank)

    local tank_count = #result_tank
    local scroll_height = math.ceil(tank_count / 4)

    if scroll_height*size.height > height then
        height = scroll_height*size.height
    end
    ScrollView_production:getInnerContainer():setContentSize(cc.size(width,height))
    
    for i = 1, tank_count do
        local row = math.floor((i - 1) % 4)
        local col = math.floor((i - 1) / 4)
        local cell = state_machine.excute("build_up_tank_factory_tank_cell_create", 0, {i, -1, result_tank[i]})
        cell:setAnchorPoint(cc.p(0,1))
        cell:setPosition(cc.p(row*(width/4),height - col*size.height))
        ScrollView_production:addChild(cell)
    end
    
    ScrollView_production:jumpToTop()
end

function LegionCityFormation:onEnterTransitionFinish()

end

function LegionCityFormation:onInit( )
    local csbItem = csb.createNode(config_csb.legion.legion_city_formation)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_shop_close"), nil, 
    {
        terminal_name = "legion_city_formation_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    -- 说明
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), nil, 
    {
        terminal_name = "legion_city_rule_infor_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        infor_type = 8,
    },
    nil,1)

    -- 部队兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_22"), nil, 
    {
        terminal_name = "legion_city_formation_change",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    self:onUpdateDraw()
end

function LegionCityFormation:init(params)
    self:onInit()
    return self
end

function LegionCityFormation:onExit()
    state_machine.remove("legion_city_formation_update_draw")
    state_machine.remove("legion_city_formation_change")
end
