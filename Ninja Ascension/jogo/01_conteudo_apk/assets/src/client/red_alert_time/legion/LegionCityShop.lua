-----------------------------
-- 城市战商店
-----------------------------
LegionCityShop = class("LegionCityShopClass", Window)

local legion_city_shop_window_open_terminal = {
    _name = "legion_city_shop_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if nil == fwin:find("LegionCityShopClass") then
                    local panel = LegionCityShop:new():init(params)
                    fwin:open(panel, fwin._ui)
                end  
            end
        end
        protocol_command.world_city_shop_init.param_list = ""
        NetworkManager:register(protocol_command.world_city_shop_init.code, nil, nil, nil, nil, responseCallback, false, nil)   
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local legion_city_shop_window_close_terminal = {
    _name = "legion_city_shop_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activityWindow = fwin:find("LegionCityShopClass")
        fwin:close(activityWindow)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_shop_window_open_terminal)
state_machine.add(legion_city_shop_window_close_terminal)
state_machine.init()

function LegionCityShop:ctor()
    self.super:ctor()
    self.roots = {}
    
    -- 定义变量
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._last_state = -1

    -- 加载lua文件
    app.load("client.red_alert_time.legion.LegionCityRuleInfor")

    app.load("client.red_alert_time.cells.legion.legion_city_shop_cell")
    
    -- 初始化状态机
    local function init_legion_city_shop_terminal()
        -- 刷新
        local legion_city_shop_update_draw_terminal = {
            _name = "legion_city_shop_update_draw",
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
                instance._list_view_poy = posY + 1
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_city_shop_change_state_terminal = {
            _name = "legion_city_shop_change_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local current_state = tonumber(params[1])
                if current_state == 0 then
                    fwin:addService({
                        callback = function ( params )
                            state_machine.excute("legion_city_shop_window_close", 0, "")
                        end,
                        delay = 0.1,
                        params = ""
                    })
                elseif current_state ~= instance._last_state then
                    state_machine.excute("legion_city_shop_update_draw", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_shop_update_draw_terminal)
        state_machine.add(legion_city_shop_change_state_terminal)
        state_machine.init()
    end
    init_legion_city_shop_terminal()
end

function LegionCityShop:onUpdateList()

end

-- 刷新界面
function LegionCityShop:onUpdateDraw()
    local root = self.roots[1]

    -- 刷新排名，折扣信息
    local Text_legion_city_shop_p_1 = ccui.Helper:seekWidgetByName(root,"Text_legion_city_shop_p_1")
    local Text_legion_city_shop_p_2 = ccui.Helper:seekWidgetByName(root,"Text_legion_city_shop_p_2")
    local state = 0  -- 0：未开启，1：准备中，2：已开启
    self._end_time = 0
    local push_info = _ED.mould_function_push_info["15"]
    if push_info ~= nil then
        state = tonumber(push_info.state)
        self._end_time = tonumber(push_info.params) / 1000 + push_info.start_time
    end

    if state == 0 then
        state_machine.excute("legion_city_shop_change_state", 0, {0})
        state_machine.excute("main_window_update_city_energy_info", 0, "")
        state_machine.excute("red_alert_time_mine_update_city_energy_info", 0, "")
    else
        self._last_state = state
    end

    if _ED.union.union_info == nil 
        or _ED.union.union_info == {} 
        or _ED.union.union_info.union_id == nil 
        or _ED.union.union_info.union_id == "" 
        or tonumber(_ED.union.union_info.union_id) == 0 
        then
        Text_legion_city_shop_p_1:setString(world_city_tip_str[50])
    else
        if state == 1 then
            Text_legion_city_shop_p_2:setString(world_city_tip_str[47])
        elseif state == 2 then
            local discount = tonumber(_ED.world_city_shop_info.discount) * 10
            if discount >= 10 then
                Text_legion_city_shop_p_1:setString(world_city_tip_str[52])
            else
                if verifySupportLanguage(_lua_release_language_en) == true then
                    discount = (10 - discount) * 10
                end
                local discount_str = string.format(activity_str_tip[22], ""..discount)
                Text_legion_city_shop_p_1:setString(string.format(world_city_tip_str[49], discount_str))
            end
        end
    end

    self._text_time = nil
    if state == 1 then
        Text_legion_city_shop_p_2:setString(world_city_tip_str[48])
    elseif state == 2 then
        local leave_time = self._end_time - (os.time() + _ED.time_add_or_sub)
        Text_legion_city_shop_p_2:setString(string.format(world_city_tip_str[51], exChangeTimeToString(leave_time)))
        self._text_time = Text_legion_city_shop_p_2
    end

    -- 刷新商品列表
    local ListView_legion_city_shop = ccui.Helper:seekWidgetByName(root,"ListView_legion_city_shop")
    self._list_view = ListView_legion_city_shop
    self._list_view:jumpToTop()

    local result = {}
    if _ED.world_city_shop_info ~= nil and _ED.world_city_shop_info.shop_list ~= nil then
        result = _ED.world_city_shop_info.shop_list
    end

    local items = self._list_view:getItems()
    for k,v in pairs(items) do
        state_machine.excute("legion_city_shop_cell_update_info", 0, {cell = v, index = k, info = result[k]})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self._list_view:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("legion_city_shop_cell_create", 0, {i, result[i]})
            self._list_view:addChild(cell)
        end
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function LegionCityShop:onEnterTransitionFinish()

end

function LegionCityShop:onUpdate(dt)
    if self._text_time ~= nil then
        local leave_time = self._end_time - (os.time() + _ED.time_add_or_sub)
        self._text_time:setString(string.format(world_city_tip_str[51], exChangeTimeToString(leave_time)))
        if leave_time < 0 then
            if self._state == 2 then
                state_machine.excute("legion_city_shop_change_state", 0, {0})
            else
                state_machine.excute("legion_city_shop_update_draw", 0, "")
            end
        end
    end

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

function LegionCityShop:onInit( )
    local csbItem = csb.createNode(config_csb.legion.legion_city_shop)       -- 替换csb文件
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_shop_close"), nil, 
    {
        terminal_name = "legion_city_shop_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    -- 说明
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_city_shop_rule"), nil, 
    {
        terminal_name = "legion_city_rule_infor_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        infor_type = 7,
    },
    nil,1)

    self:onUpdateDraw()
end

function LegionCityShop:init(params)
    self:onInit()
    return self
end

function LegionCityShop:onExit()
    -- 移除状态机
    state_machine.remove("legion_city_shop_update_draw")
    state_machine.remove("legion_city_shop_change_state")
end
