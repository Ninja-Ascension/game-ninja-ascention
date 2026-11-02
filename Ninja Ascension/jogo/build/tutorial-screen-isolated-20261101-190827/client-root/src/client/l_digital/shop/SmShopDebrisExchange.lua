-- ----------------------------------------------------------------------------------------------------
-- 说明：sm商城碎片兑换
-------------------------------------------------------------------------------------------------------

SmShopDebrisExchange = class("SmShopDebrisExchangeClass", Window)

local sm_shop_debris_exchange_open_terminal = {
    _name = "sm_shop_debris_exchange_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local SmShopDebrisExchangeWindow = fwin:find("SmShopDebrisExchangeClass")
    	if SmShopDebrisExchangeWindow ~= nil then
    		SmShopDebrisExchangeWindow:setVisible(true)
    		return
    	end
    	local page = SmShopDebrisExchange:new():init()
        fwin:open(page , fwin._ui)
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_shop_debris_exchange_close_terminal = {
    _name = "sm_shop_debris_exchange_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local SmShopDebrisExchangeWindow = fwin:find("SmShopDebrisExchangeClass")
        if nil ~= SmShopDebrisExchangeWindow then
            fwin:close(fwin:find("SmShopDebrisExchangeClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_shop_debris_exchange_open_terminal)
state_machine.add(sm_shop_debris_exchange_close_terminal)
state_machine.init()

function SmShopDebrisExchange:ctor()
    self.super:ctor()
	self.roots = {}
	self.scrollView = nil
	self.roll_width = 0

    self._text_time = nil
    self._tick_time = 0

    self._scroll_view = nil
    self._scroll_view_pox = nil
    self._scroll_view_width = 0

	-- app.load("client.l_digital.shop.SmShopRefreshWindow")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.l_digital.cells.prop.sm_shop_debris_exchange_list_cell")
	local function init_sm_shop_debris_exchange_terminal()

        local sm_shop_debris_exchange_updateDraw_terminal = {
            _name = "sm_shop_debris_exchange_updateDraw",
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

        local sm_shop_debris_exchange_update_money_terminal = {
            _name = "sm_shop_debris_exchange_update_money",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateMoney()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_shop_debris_exchange_request_update_draw_terminal = {
            _name = "sm_shop_debris_exchange_request_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseBuyPropCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                protocol_command.shop_frags_init.param_list = ""
                NetworkManager:register(protocol_command.shop_frags_init.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_shop_debris_exchange_updateDraw_terminal)
        state_machine.add(sm_shop_debris_exchange_update_money_terminal)
        state_machine.add(sm_shop_debris_exchange_request_update_draw_terminal)
        state_machine.init()
	end
	init_sm_shop_debris_exchange_terminal()
end

function SmShopDebrisExchange:onUpdateMoney()
    local root = self.roots[1]
    local Text_suipian = ccui.Helper:seekWidgetByName(root, "Text_suipian")
    local curr_cost = _ED.user_info.jade
    Text_suipian:setString(curr_cost)
end

function SmShopDebrisExchange:onUpdateDraw()
    local root = self.roots[1]
    local ScrollView_suipian_duihuan = ccui.Helper:seekWidgetByName(root, "ScrollView_suipian_duihuan")
    ScrollView_suipian_duihuan:removeAllChildren(true)

    local shop_info = zstring.split(dms.string(dms["shop_config"], 10, shop_config.param), ",")
    local showlv = tonumber(shop_info[1])

    local show_group = {}
    if _ED.shop_frags_info ~= nil and _ED.shop_frags_info.shop_list ~= nil then
        for k, v in pairs(_ED.shop_frags_info.shop_list) do
            if showlv > tonumber(_ED.user_info.user_grade) and (v.good_index == 1 or v.good_index == 19) then
            else
                table.insert(show_group, v)
            end
        end
    end

    local function sortFunction(a, b)
        return a.good_index < b.good_index
    end
    table.sort(show_group, sortFunction)

    local cell_size = nil
    local width_n = math.ceil((#show_group)/ 2)
    local cell_group = {}
    for i , v in pairs(show_group) do 
        local prop = self:getPropByType(v)
        local cell = state_machine.excute("sm_shop_debris_exchange_list_cell_create", 0, {prop, i})
        if cell_size == nil then
            cell_size = cell:getContentSize()
        end

        ScrollView_suipian_duihuan:addChild(cell)
        table.insert(cell_group, cell)
    end

    if cell_size ~= nil then
        self.roll_width = cell_size.width * 3
        local InnerWidth = math.max(cell_size.width * width_n , ScrollView_suipian_duihuan:getContentSize().width)
        ScrollView_suipian_duihuan:setInnerContainerSize(cc.size(InnerWidth , cell_size.height * 2))
        self.scrollView = ScrollView_suipian_duihuan

        for k, v in pairs(cell_group) do
            v:setPosition(cc.p( ((k - 1) % width_n) * cell_size.width , (2 - math.ceil( k / width_n)) * cell_size.height))
        end
    end

    self._scroll_view = ScrollView_suipian_duihuan
    self._scroll_view_pox = 99999--ScrollView_suipian_duihuan:getInnerContainer():getPositionX()
    self._scroll_view_width = ScrollView_suipian_duihuan:getInnerContainer():getPositionX()

    -- 刷新倒计时
    local max_time = tonumber(shop_info[2]) * 3600 * 24
    local leave_time = max_time - (os.time() + _ED.time_add_or_sub - _ED.shop_frags_info.last_refresh_time)
    local Text_time_number = ccui.Helper:seekWidgetByName(root, "Text_time_number")
    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")

    if showlv > tonumber(_ED.user_info.user_grade) then
        Text_time:setVisible(false)
        Text_time_number:setVisible(false)
        self._text_time = nil
        self._tick_time = 0
    else
        Text_time:setVisible(true)
        Text_time_number:setVisible(true)
        Text_time_number:setString(getRedAlertTimeActivityFormat(leave_time))
        self._text_time = Text_time_number
        self._tick_time = leave_time
    end

    self:onUpdateMoney()
end

function SmShopDebrisExchange:getPropByType(originalProp)
     function change_type(prop_type)
        if prop_type == 0 then
            return 6 
        elseif prop_type == 1 then
            return 13
        elseif prop_type == 2 then
            return 7
        elseif prop_type == 4 then
            return 34
        elseif prop_type == -1 then
            return 1
        end
    end
    local prop = {}

    local reward = dms.element(dms["avatar_shop"], originalProp.good_id)

    local goods_info = zstring.split(dms.atos(reward, avatar_shop.prop), ",")
    local cost_info = zstring.split(dms.atos(reward, avatar_shop.cost_gold), ",")

    prop.mould_id = tonumber(goods_info[2])
    prop.type = tonumber(goods_info[1])
    prop.sale_percentage = tonumber(cost_info[3])
    prop.good_index = originalProp.good_index
    prop.max_buy_times = originalProp.max_buy_times
    prop.good_id = originalProp.good_id

    if prop.number == nil then
        prop.number = 1
    end

    local prop_info = nil
    if prop.type == 6 then
        prop_info = dms.element(dms["prop_mould"], prop.mould_id)
        if prop.mould_name == nil then
            prop.mould_name = dms.atos(prop_info, prop_mould.prop_name)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                prop.mould_name = setThePropsIcon(prop.mould_id)[2]
            end
        end
        if prop.prop_quality == nil then
            prop.prop_quality = dms.atoi(prop_info, prop_mould.prop_quality)
        end
        prop.mould_remarks = dms.atos(prop_info, prop_mould.remarks)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            prop.mould_remarks = drawPropsDescription(prop.mould_id)
        end
    elseif prop.type == 7 then
        prop_info = dms.element(dms["equipment_mould"], prop.mould_id)
        if prop.mould_name == nil then
            prop.mould_name = smEquipWordlFundByIndex(prop.mould_id , 1)
        end
        prop.prop_quality = dms.atoi(prop_info, equipment_mould.trace_npc_index)
        if prop.prop_quality == 0 then
            prop.prop_quality = 3
        end
        prop.mould_remarks = smEquipWordlFundByIndex(prop.mould_id , 2)--描述
    end
    return prop
end

function SmShopDebrisExchange:onUpdate(dt)
    if self._text_time ~= nil and self._tick_time > 0 then
        self._tick_time = self._tick_time - dt
        self._text_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
        if self._tick_time < 0 then
            self._tick_time = 0
            state_machine.excute("sm_shop_debris_exchange_request_update_draw", 0, "")
        end
    end
    if self._scroll_view ~= nil then
        local size = self._scroll_view:getContentSize()
        local posX = self._scroll_view:getInnerContainer():getPositionX()
        if self._scroll_view_pox == posX then
            return
        end
        self._scroll_view_pox = posX
        local items = self._scroll_view:getChildren()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempX = v:getPositionX() + posX
            if tempX + itemSize.width < 0 or tempX > size.width + itemSize.width then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function SmShopDebrisExchange:onInit()
	local csbSmShopDebrisExchange = csb.createNode("shop/sm_shop_suipian_duihuan.csb")
	local root = csbSmShopDebrisExchange:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csbSmShopDebrisExchange)
    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "sm_shop_debris_exchange_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 3)
    
	-- self:onUpdateDraw()
    state_machine.excute("sm_shop_debris_exchange_request_update_draw", 0, "")
end

function SmShopDebrisExchange:init()
	self:onInit()
	return self
end

function SmShopDebrisExchange:onExit()
	state_machine.remove("sm_shop_debris_exchange_updateDraw")
    state_machine.remove("sm_shop_debris_exchange_update_money")
    state_machine.remove("sm_shop_debris_exchange_request_update_draw")
end

