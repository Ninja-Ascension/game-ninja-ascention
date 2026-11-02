-----------------------------
--阵型设置
-----------------------------
Formation = class("FormationClass", Window)

--打开界面
local formation_window_open_terminal = {
    _name = "formation_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("FormationClass") == nil then
            local _wind = Formation:new()
            _wind:init(params)
            fwin:open(_wind, fwin._ui)
            if params._datas.is_misssion == true then
                state_machine.excute("formation_window_hide", 0, "")
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local formation_window_close_terminal = {
    _name = "formation_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FormationClass"))
        -- -- 校验开启教学事件
        -- state_machine.excute("main_window_check_mission", 0, 0)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(formation_window_open_terminal)
state_machine.add(formation_window_close_terminal)
state_machine.init()

function Formation:ctor()
    self.super:ctor()
    self.roots = {}

    --(1: 防守部队，    2：世界部队出征，3：pve部队出征，4：军团切磋, 5：军团切磋挑战
    -- 6: 军团副本出征，7：叛军出没,     8:远征，        9：极限挑战, 10:敌军来袭
    -- 11:战地争霸      12：守卫战防守   13：守卫战进攻, 14：军团争霸, 15：阵营战
    -- 16:城市战进攻，17：城市战防守，18：城市战部队兑换, 19: 工厂进攻，20：工厂防守)
    self._form_type = 1 
	self._pve_operating_type = 0 --(-1为扫荡，其他为普通)
	
	self.attack_cell = nil  --世界攻击对象
	self.playersOrmine = 0
	self.isForce = 0
    self.world_attack_type = 0

    self._current_page = 0
    self._defendPanel = nil
    self._attackPanel = nil
    self._repairPanel = nil
    self._factorPanel = nil

    app.load("client.red_alert_time.formation.FormationDefend")
    app.load("client.red_alert_time.formation.FormationAttack")
    app.load("client.red_alert_time.formation.FormationRepair")
    app.load("client.red_alert_time.formation.FormationChooseTroop")
    app.load("client.red_alert_time.formation.FormationManage")
    app.load("client.red_alert_time.formation.FormationLeaderChoose")
    app.load("client.red_alert_time.formation.FormationFactor")
    app.load("client.red_alert_time.cells.formation.formation_tank_head_cell")
    app.load("client.red_alert_time.cells.formation.formation_leader_head_cell")
    app.load("client.red_alert_time.cells.formation.formation_manage_enabled_cell")
    app.load("client.red_alert_time.cells.formation.formation_manage_disabled_cell")
    app.load("client.red_alert_time.cells.formation.formation_implement_cell")
    app.load("client.red_alert_time.cells.formation.formation_repair_cell")
    app.load("client.red_alert_time.cells.formation.formation_choose_leader_cell")
    app.load("client.red_alert_time.cells.formation.formation_implement_free_cell")

    app.load("client.red_alert_time.leader.LeaderExchangeInfo")

    local function init_formation_terminal()
        local formation_change_page_terminal = {
            _name = "formation_change_page",
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

        local formation_window_show_terminal = {
            _name = "formation_window_show",
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

        local formation_window_hide_terminal = {
            _name = "formation_window_hide",
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

        state_machine.add(formation_change_page_terminal)
        state_machine.add(formation_window_show_terminal)
        state_machine.add(formation_window_hide_terminal)
    end
    init_formation_terminal()
end

function Formation:updateInfo( ... )
    local root = self.roots[1]

    local Text_troops_type_title = ccui.Helper:seekWidgetByName(root, "Text_troops_type_title")
    local Button_troops = ccui.Helper:seekWidgetByName(root, "Button_troops")
    if self._form_type == 1 then
        Text_troops_type_title:setString(formation_type_string[1])
        Button_troops:setTitleText(formation_type_string[35])
    elseif self._form_type == 4 
        or self._form_type == 5
        or self._form_type == 6
        or self._form_type == 9 then
        Text_troops_type_title:setString(formation_type_string[21])
        Button_troops:setTitleText(formation_type_string[21])
    elseif self._form_type == 8 then
        Text_troops_type_title:setString(formation_type_string[2])
        Button_troops:setTitleText(formation_type_string[21])
    elseif self._form_type == 12 
        or self._form_type == 13 then
        Text_troops_type_title:setString(formation_type_string[32])
        Button_troops:setTitleText(formation_type_string[32])
    elseif self._form_type == 14 then
        Text_troops_type_title:setString(formation_type_string[33])
        Button_troops:setTitleText(formation_type_string[33])
    elseif self._form_type == 15 then
        Text_troops_type_title:setString(formation_type_string[45])
        Button_troops:setTitleText(formation_type_string[46])
    else
        Text_troops_type_title:setString(formation_type_string[2])
        Button_troops:setTitleText(formation_type_string[22])
    end
end

function Formation:changeSelectPage( page, params )
    local root = self.roots[1]
    local Panel_troops_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_troops_tab_box")
    local Button_troops = ccui.Helper:seekWidgetByName(root, "Button_troops")
    local Button_troops_implement = ccui.Helper:seekWidgetByName(root, "Button_troops_implement")
    local Button_troops_repair = ccui.Helper:seekWidgetByName(root, "Button_troops_repair")
    local Button_troops_gain = ccui.Helper:seekWidgetByName(root, "Button_troops_gain")
    local Image_form_box = ccui.Helper:seekWidgetByName(root, "Image_form_box")
    if Image_form_box ~= nil then
        Image_form_box:setVisible(false)
    end
    if page == self._current_page then
        if page == 1 then
            Button_troops:setHighlighted(true)
            if Image_form_box ~= nil then
                Image_form_box:setVisible(true)
            end
        elseif page == 2 then
            Button_troops_implement:setHighlighted(true)
        elseif page == 3 then
            Button_troops_repair:setHighlighted(true)
        else
            Button_troops_gain:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_troops:setHighlighted(false)
    Button_troops_implement:setHighlighted(false)
    Button_troops_repair:setHighlighted(false)
    Button_troops_gain:setHighlighted(false)
    state_machine.excute("formation_defend_hide", 0, nil)
    state_machine.excute("formation_attack_hide", 0, nil)
    state_machine.excute("formation_repair_hide", 0, nil)
    state_machine.excute("formation_factor_hide", 0, nil)
    if page == 1 then
        if Image_form_box ~= nil then
            Image_form_box:setVisible(true)
        end
        Button_troops:setHighlighted(true)
        if self._defendPanel == nil then
            self._defendPanel = state_machine.excute("formation_defend_open", 0, {Panel_troops_tab_box, self._form_type, self.attack_cell, self.playersOrmine, self._pve_operating_type,self.isForce,self.world_attack_type})
        else
            state_machine.excute("formation_defend_show", 0, nil)
        end
    elseif page == 2 then
        Button_troops_implement:setHighlighted(true)
        if self._attackPanel == nil then
            self._attackPanel = state_machine.excute("formation_attack_open", 0, {Panel_troops_tab_box, self._form_type})
        else
            state_machine.excute("formation_attack_show", 0, nil)
        end
    elseif page == 3 then
        Button_troops_repair:setHighlighted(true)
        if self._repairPanel == nil then
            self._repairPanel = state_machine.excute("formation_repair_open", 0, {Panel_troops_tab_box, self._form_type})
        else
            state_machine.excute("formation_repair_show", 0, nil)
        end
    elseif page == 4 then
        Button_troops_gain:setHighlighted(true)
        if self._factorPanel == nil then
            self._factorPanel = state_machine.excute("formation_factor_window_open", 0, {Panel_troops_tab_box})
        else
            state_machine.excute("formation_factor_show", 0, nil)
        end
    end
    if params ~= nil
        and params._datas ~= nil 
        and params._datas.next_terminal ~= nil
        and params._datas.next_terminal ~= ""
        then
        state_machine.excute(params._datas.next_terminal, 0, params._datas.next_terminal_params)
    end
end

function Formation:onInit(params)
    local csbItem = csb.createNode(config_csb.formation.formation)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_troops_close"), nil, 
    {
        terminal_name = "formation_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)      

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_troops"), nil, 
    {
        terminal_name = "formation_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_troops_implement"), nil, 
    {
        terminal_name = "formation_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_troops_repair"), nil, 
    {
        terminal_name = "formation_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_formation_repair",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_troops_repair"),
    _invoke = nil,
    _interval = 0.2,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_troops_gain"), nil, 
    {
        terminal_name = "formation_change_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 0)

    if params ~= nil and params._datas ~= nil and params._datas.form_type ~= nil then
        self._form_type = params._datas.form_type
    end
	
	if params ~= nil and params._datas ~= nil and params._datas.pve_operating_type ~= nil then
        self._pve_operating_type = params._datas.pve_operating_type
    end
	
	-------世界攻击添加-------
	if params ~= nil and params._datas ~= nil and params._datas.attack_cell ~= nil then
        self.attack_cell = params._datas.attack_cell
    end
	if params ~= nil and params._datas ~= nil and params._datas.playersOrmine ~= nil then
        self.playersOrmine = params._datas.playersOrmine
    end
	if params ~= nil and params._datas ~= nil and params._datas.isForce ~= nil then
        self.isForce = params._datas.isForce
    end
    if params ~= nil and params._datas ~= nil and params._datas.attack_type ~= nil then
        self.world_attack_type = params._datas.attack_type
    end
	------攻击添加end--------
    self:updateInfo()

    local page = 1
    if params ~= nil and params._datas ~= nil and params._datas.page ~= nil then
        page = tonumber(params._datas.page)
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:changeSelectPage(page, params)
            end
        end
    end
    if params ~= nil and params._datas ~= nil and params._datas.is_misssion == true then
        self:changeSelectPage(page, params)
    else
        NetworkManager:register(protocol_command.get_ship_count.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function Formation:onEnterTransitionFinish()

end

function Formation:init(params)
    self:setTouchEnabled(true)
    self:onInit(params)
end

function Formation:onExit()
    state_machine.remove("formation_change_page")
    state_machine.remove("formation_window_show")
    state_machine.remove("formation_window_hide")
end