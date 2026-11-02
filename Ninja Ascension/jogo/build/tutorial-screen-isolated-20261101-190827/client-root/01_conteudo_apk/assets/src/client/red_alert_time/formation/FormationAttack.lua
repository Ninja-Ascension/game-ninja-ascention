--------------------------------------------------------------------------------------------------------------
--  说明：阵容执行
--------------------------------------------------------------------------------------------------------------
FormationAttack = class("FormationAttackClass", Window)

--打开界面
local formation_attack_open_terminal = {
	_name = "formation_attack_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = FormationAttack:new():init(params)
        fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local formation_attack_close_terminal = {
	_name = "formation_attack_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FormationAttackClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(formation_attack_open_terminal)
state_machine.add(formation_attack_close_terminal)
state_machine.init()

function FormationAttack:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_production_arrow_up = nil
    self._Image_production_arrow_down = nil

    app.load("client.red_alert_time.world.WorldBattleTroopsInfor")

    local function init_formation_attack_terminal()
        local formation_attack_show_terminal = {
            _name = "formation_attack_show",
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

        local formation_attack_hide_terminal = {
            _name = "formation_attack_hide",
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

        local formation_attack_update_info_terminal = {
            _name = "formation_attack_update_info",
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

        local formation_attack_go_ahead_terminal = {
            _name = "formation_attack_go_ahead",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if fwin:find("PveMapClass") ~= nil then
                    state_machine.excute("pve_map_close", 0, "")
                end
                if fwin:find("PveManagerClass") ~= nil then
                    state_machine.excute("pve_manager_window_close", 0, "")
                end
                if fwin:find("CampaignClass") ~= nil then
                    state_machine.excute("campaign_window_close", 0, "")
                end
                if fwin:find("ExpeditionClass") ~= nil then
                    state_machine.excute("expedition_window_close", 0, "")
                end
                if fwin:find("LimitDekaronClass") ~= nil then
                    state_machine.excute("limit_dekaron_window_close", 0, "")
                end
                if fwin:find("LegionHegemonyClass") ~= nil then
                    state_machine.excute("legion_hegemony_window_close", 0, "")
                end
                if fwin:find("LegionClass") ~= nil then
                    state_machine.excute("legion_window_close", 0, "")
                end
                if fwin:find("LegionPKClass") ~= nil then
                    state_machine.excute("legion_pk_close", 0, "")
                end
                if fwin:find("LegionPveClass") ~= nil then
                    state_machine.excute("legion_pve_window_close", 0, "")
                end
                if fwin:find("CampPkClass") ~= nil then
                    state_machine.excute("camp_pk_close", 0, "")
                end
                state_machine.excute("formation_window_close", 0, "")
                state_machine.excute("short_cut_go_to_other_window", 0, {14})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(formation_attack_show_terminal)
        state_machine.add(formation_attack_hide_terminal)
        state_machine.add(formation_attack_update_info_terminal)
        state_machine.add(formation_attack_go_ahead_terminal)
        state_machine.init()
    end
    
    init_formation_attack_terminal()
end

function FormationAttack:updateDraw()
    local root = self.roots[1]
    local Text_troops_implement = ccui.Helper:seekWidgetByName(root, "Text_troops_implement")
    local max_count = dms.int(dms["base_consume"], 81, base_consume.vip_0_value + tonumber(_ED.vip_grade))

    local ListView_implement = ccui.Helper:seekWidgetByName(root, "ListView_implement")
    ListView_implement:jumpToTop()
    ListView_implement:removeAllItems()

    local result = {}
    local attack_count = 0
    if _ED.world_map~= nil and _ED.world_map.target_event_info ~= nil then
        for i, v in pairs(_ED.world_map.target_event_info) do
            if (tonumber(v._event_type) < 10 or tonumber(v._event_type) >= 18) then
                table.insert(result, v)
            end
        end
    end
    
    local function sortFunction(a, b)
        return a._time < b._time
    end
    table.sort(result, sortFunction)

    attack_count = #result
    Text_troops_implement:setString(string.format(red_alert_time_str[108], max_count - attack_count))

    local items = ListView_implement:getItems()
    for k,v in pairs(items) do
        state_machine.excute("formation_implement_cell_update_info", 0, {cell = v, _info = result[k]})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            ListView_implement:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("formation_implement_cell_create",0, {i, result[i]})
            ListView_implement:addChild(cell)
        end
    end

    if __lua_project_id == __lua_project_pacific_rim then
        local free_count = max_count - attack_count
        if free_count > 0 then
            for i = 1, free_count do
                local cell = state_machine.excute("formation_implement_free_cell_create", 0, {#result + i})
                ListView_implement:addChild(cell)
            end
        end
        attack_count = max_count
    end

    ListView_implement:requestRefreshView()
    self._list_view = ListView_implement
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    local Text_troops_production_not = ccui.Helper:seekWidgetByName(root, "Text_troops_production_not")
    local Button_production_go = ccui.Helper:seekWidgetByName(root, "Button_production_go")
    if attack_count == 0 then
        Text_troops_production_not:setVisible(true)
        Button_production_go:setVisible(true)
    else
        Text_troops_production_not:setVisible(false)
        Button_production_go:setVisible(false)
    end
end

function FormationAttack:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_production_arrow_down:setVisible(true)
        else
            self._Image_production_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_production_arrow_up:setVisible(true)
        else
            self._Image_production_arrow_up:setVisible(false)
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

--初始化
function FormationAttack:onInit()
    local csbItem = csb.createNode(string.format(config_csb.formation.formation_tab, "2"))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_production_go"), nil, 
    {
        terminal_name = "formation_attack_go_ahead", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    self._Image_production_arrow_up = ccui.Helper:seekWidgetByName(root,"Image_production_arrow_up")
    self._Image_production_arrow_down = ccui.Helper:seekWidgetByName(root,"Image_production_arrow_down")

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_production_arrow_down:stopAllActions()
    self._Image_production_arrow_up:stopAllActions()
    playActions(self._Image_production_arrow_down)
    playActions(self._Image_production_arrow_up)
    self._Image_production_arrow_down:setVisible(false)
    self._Image_production_arrow_up:setVisible(false)

    self:updateDraw()
end

function FormationAttack:onEnterTransitionFinish()

end

function FormationAttack:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function FormationAttack:onExit()
    state_machine.remove("formation_attack_show")
    state_machine.remove("formation_attack_hide")
    state_machine.remove("formation_attack_update_info")
    state_machine.remove("formation_attack_go_ahead")
end