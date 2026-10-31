-----------------------------
-- 王者之战开始报名
-----------------------------
SmBattleofKingsStartRegistration = class("SmBattleofKingsStartRegistrationClass", Window)

--打开界面
local sm_battleof_kings_start_registration_open_terminal = {
	_name = "sm_battleof_kings_start_registration_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmBattleofKingsStartRegistrationClass") == nil then
			fwin:open(SmBattleofKingsStartRegistration:new():init(), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_battleof_kings_start_registration_close_terminal = {
	_name = "sm_battleof_kings_start_registration_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmBattleofKingsStartRegistrationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_battleof_kings_start_registration_open_terminal)
state_machine.add(sm_battleof_kings_start_registration_close_terminal)
state_machine.init()

function SmBattleofKingsStartRegistration:ctor()
	self.super:ctor()
	self.roots = {}

    self._current_page = 0
    self._all = nil
    self._attack = nil
    self._anti = nil
    self._technology = nil
	app.load("client.cells.ship.ship_icon_cell")

    local function init_sm_battleof_kings_start_registration_terminal()
        local sm_battleof_kings_start_registration_change_page_terminal = {
            _name = "sm_battleof_kings_start_registration_change_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_battleof_kings_start_go_to_battle_terminal = {
            _name = "sm_battleof_kings_start_go_to_battle",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local m_type = tonumber(params[1])
                local ship = params[2]
                --模板ID：等级：进化状态：星级:品阶:战力:实例ID:速度:斗魂:技能等级：皮肤id!下一个武将
                local skin_id = 0
                if ship.ship_skin_info and ship.ship_skin_info ~= "" then
                    local skin_info = zstring.splits(ship.ship_skin_info, "|", ":")
                    local temp = zstring.split(skin_info[1][1], ",")
                    skin_id = zstring.tonumber(temp[1])
                end
                if m_type == 0 then
                    local formation_number = zstring.split(_ED.kings_battle.my_formation,"!")
                    if #formation_number >= 10 then
                        return
                    end
                    --上阵
                    if _ED.kings_battle.my_formation ~= nil and _ED.kings_battle.my_formation ~= "" then
                        _ED.kings_battle.my_formation = _ED.kings_battle.my_formation.."!"..ship.ship_template_id..":"..ship.ship_grade..":"..ship.evolution_status..":"..ship.StarRating..":"..ship.Order..":"..ship.hero_fight..":"..ship.ship_id..":"..math.ceil(ship.ship_wisdom)..":"..ship.skillLevel..":"..skin_id
                    else
                        _ED.kings_battle.my_formation = ""..ship.ship_template_id..":"..ship.ship_grade..":"..ship.evolution_status..":"..ship.StarRating..":"..ship.Order..":"..ship.hero_fight..":"..ship.ship_id..":"..math.ceil(ship.ship_wisdom)..":"..skin_id
                    end
                else
                    --下阵
                    local formation_info = zstring.split(_ED.kings_battle.my_formation,"!")
                    _ED.kings_battle.my_formation = ""
                    for i,v in pairs(formation_info) do
                        local datas = zstring.split(v,":")
                        if tonumber(datas[7]) == tonumber(ship.ship_id) then
                        else
                            if _ED.kings_battle.my_formation == "" then
                                _ED.kings_battle.my_formation = ""..v
                            else
                                _ED.kings_battle.my_formation = _ED.kings_battle.my_formation.."!"..v
                            end
                        end
                    end
                end
                instance:onUpdateFormation()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_battleof_kings_a_key_array_terminal = {
            _name = "sm_battleof_kings_a_key_array",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED.kings_battle.my_formation = ""
                ShipIconCell.battle_kings_number = 0
                local tSortedHeroes = instance:getSortedHeroes(1)
                for i=1 , 10 do
                    local ship = tSortedHeroes[i]
                    local skin_id = 0
                    if ship and ship.ship_skin_info and ship.ship_skin_info ~= "" then
                        local skin_info = zstring.splits(ship.ship_skin_info, "|", ":")
                        local temp = zstring.split(skin_info[1][1], ",")
                        skin_id = zstring.tonumber(temp[1])
                    end
                    if ship ~= nil then
                        if _ED.kings_battle.my_formation ~= nil and _ED.kings_battle.my_formation ~= "" then
                            _ED.kings_battle.my_formation = _ED.kings_battle.my_formation.."!"..ship.ship_template_id..":"..ship.ship_grade..":"..ship.evolution_status..":"..ship.StarRating..":"..ship.Order..":"..ship.hero_fight..":"..ship.ship_id..":"..math.ceil(ship.ship_wisdom)..":"..skin_id
                        else
                            _ED.kings_battle.my_formation = ""..ship.ship_template_id..":"..ship.ship_grade..":"..ship.evolution_status..":"..ship.StarRating..":"..ship.Order..":"..ship.hero_fight..":"..ship.ship_id..":"..math.ceil(ship.ship_wisdom)..":"..skin_id
                        end
                        ShipIconCell.battle_kings_number = ShipIconCell.battle_kings_number + 1
                    end
                end
                instance:onUpdateFormation()
                instance:onUpdateDraw(1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_battleof_kings_registration_submission_terminal = {
            _name = "sm_battleof_kings_registration_submission",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local formation_info = zstring.split(_ED.kings_battle.my_formation,"!")
                if #formation_info < 10 then
                    TipDlg.drawTextDailog(_new_interface_text[152])
                    return
                end
                local function requesrDefendCheck(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("sm_battleof_kings_open_my_schedule", 0, {_datas={_page = 2}})
                        state_machine.excute("sm_battleof_kings_start_registration_close", 0, nil)
                        state_machine.excute("sm_battleof_kings_look_peak_update_add_number", 0, nil)
                        if tonumber(_ED.kings_battle.kings_battle_open_type) == 0 then
                        else
                            if tonumber(_ED.kings_battle.kings_battle_type) == 1 then
                                state_machine.excute("sm_battleof_kings_my_general_formation_update", 0, nil)
                            else
                                TipDlg.drawTextDailog(_new_interface_text[180])
                            end
                        end
                    end
                end
                protocol_command.the_kings_battle_manager.param_list = "0".."\r\n".._ED.kings_battle.my_formation
                if tonumber(_ED.kings_battle.kings_battle_open_type) == 0 then
                else
                    if tonumber(_ED.kings_battle.kings_battle_type) == 1 then
                        protocol_command.the_kings_battle_manager.param_list = "1".."\r\n".._ED.kings_battle.my_formation
                    end
                end
                NetworkManager:register(protocol_command.the_kings_battle_manager.code, nil, nil, nil, instance, requesrDefendCheck, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(sm_battleof_kings_start_registration_change_page_terminal)
        state_machine.add(sm_battleof_kings_start_go_to_battle_terminal)
        state_machine.add(sm_battleof_kings_a_key_array_terminal)
        state_machine.add(sm_battleof_kings_registration_submission_terminal)
        state_machine.init()
    end
    init_sm_battleof_kings_start_registration_terminal()
end

function SmBattleofKingsStartRegistration:changeSelectPage( page )
    local root = self.roots[1]

    local Panel_tab = ccui.Helper:seekWidgetByName(root, "Panel_tab")
    local Button_tab_1 = ccui.Helper:seekWidgetByName(root, "Button_tab_1")
    local Button_tab_2 = ccui.Helper:seekWidgetByName(root, "Button_tab_2")
    local Button_tab_3 = ccui.Helper:seekWidgetByName(root, "Button_tab_3")
    local Button_tab_4 = ccui.Helper:seekWidgetByName(root, "Button_tab_4")
    if page == self._current_page then
        if page == 1 then
            Button_tab_1:setHighlighted(true)
        elseif page == 2 then
            Button_tab_2:setHighlighted(true)
        elseif page == 3 then
            Button_tab_3:setHighlighted(true)
		elseif page == 4 then 
			Button_tab_4:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_tab_1:setHighlighted(false)
    Button_tab_2:setHighlighted(false)
    Button_tab_3:setHighlighted(false)
    Button_tab_4:setHighlighted(false)
	
    if page == 1 then
        Button_tab_1:setHighlighted(true)
	elseif page == 2 then
		Button_tab_2:setHighlighted(true)
	elseif page == 3 then
		Button_tab_3:setHighlighted(true)
    else
        Button_tab_4:setHighlighted(true)
	end
	self:onUpdateDraw(page)
end

function SmBattleofKingsStartRegistration:getSortedHeroes(pages)
    local function fightingCapacity(a,b)
        local al = tonumber(a.hero_fight)
        local bl = tonumber(b.hero_fight)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end
     -- print("=============",showFormation)
    local tSortedHeroes = {}

    for i, ship in pairs(_ED.user_ship) do
		if tonumber(pages) == 1 then
			table.insert(tSortedHeroes, ship)
		else
			local camp_preference = dms.int(dms["ship_mould"], ship.ship_template_id, ship_mould.camp_preference)
			if camp_preference == tonumber(pages)-1 then
				table.insert(tSortedHeroes, ship)
			end
		end
    end

    table.sort(tSortedHeroes, fightingCapacity)
    return tSortedHeroes
end

function SmBattleofKingsStartRegistration:onUpdateFormation()
    local root = self.roots[1]
    --模板ID：等级：进化状态：星级:品阶:战力:实例ID:速度:斗魂:技能等级：皮肤id!下一个武将
    local formation_info = nil
    if _ED.kings_battle.my_formation == nil or _ED.kings_battle.my_formation == "" then
        _ED.kings_battle.my_formation = ""
    else
        formation_info = zstring.split(_ED.kings_battle.my_formation,"!")
    end

    for i=1, 10 do
        local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_"..i)
        -- local Image_add = ccui.Helper:seekWidgetByName(root, "Image_add_"..i)
        Panel_digimon_icon:removeAllChildren(true)
        -- Image_add:setVisible(true)
        if formation_info ~= nil then
            if formation_info[i] ~= nil then
                local datas = zstring.split(formation_info[i],":")
                -- Image_add:setVisible(false)
                local cell = ShipIconCell:createCell()
                cell:init(_ED.user_ship[datas[7]],11)
                ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"):setTouchEnabled(false)
                Panel_digimon_icon:addChild(cell)
            end
        end
    end
end

function SmBattleofKingsStartRegistration:onUpdateDraw(pages)
    local root = self.roots[1]

    if pages == 1 then
        ShipIconCell.battle_kings_number = 0
    end

	local tSortedHeroes = self:getSortedHeroes(pages)
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_digimon_pack")
    m_ScrollView:removeAllChildren(true)
	local panel = m_ScrollView:getInnerContainer()
    panel:setContentSize(m_ScrollView:getContentSize())
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = m_ScrollView:getInnerContainerSize()
    local nextY = sSize.height
    local nextX = sSize.width
    local tHeight = 0
    local cellHeight = 0
    local tWidth = 0
    local wPosition = sWidth/6
    local Hlindex = 0
    local number = #tSortedHeroes
    local m_number = math.ceil(number/6)
    cellHeight = m_number*(m_ScrollView:getContentSize().width/6)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local index = 1
	for j, v in pairs(tSortedHeroes) do
        local cell = ShipIconCell:createCell()
		cell:init(v,11)
        panel:addChild(cell)
        tWidth = tWidth + wPosition
        if (index-1)%6 ==0 then
            Hlindex = Hlindex+1
            tWidth = 0
            tHeight = sHeight - wPosition*Hlindex  
        end
        if index <= 6 then
            tHeight = sHeight - wPosition
        end
        index = index + 1
        cell:setPosition(cc.p(tWidth,tHeight))
        ccui.Helper:seekWidgetByName(cell.roots[1], "Image_chuzhan"):setVisible(false)
        if _ED.kings_battle.my_formation ~= nil and _ED.kings_battle.my_formation ~= "" then
            local formation_info = zstring.split(_ED.kings_battle.my_formation,"!")
            for i, w in pairs(formation_info) do
                local datas = zstring.split(w,":")
                if tonumber(v.ship_id) == tonumber(datas[7]) then
                    ccui.Helper:seekWidgetByName(cell.roots[1], "Image_chuzhan"):setVisible(true)
                    --上阵上一次阵容，控制数码兽选择的数量
                    if pages and pages == 1 and ShipIconCell.battle_kings_number < 10 then
                        ShipIconCell.battle_kings_number = ShipIconCell.battle_kings_number + 1
                    end
                    break
                end
            end
        end
    end
	m_ScrollView:jumpToTop()
    if tonumber(_ED.kings_battle.kings_battle_open_type) == 0 then
    else
        if tonumber(_ED.kings_battle.kings_battle_type) == 1 then
           self:onUpdateFormation()
        end
    end
end

function SmBattleofKingsStartRegistration:init()
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function SmBattleofKingsStartRegistration:onInit()
    local csbItem = csb.createNode("campaign/BattleofKings/battle_of_kings_sign_up.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_wzzz_back"), nil, 
    {
        terminal_name = "sm_battleof_kings_start_registration_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --全部
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_1"), nil, 
    {
        terminal_name = "sm_battleof_kings_start_registration_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
	
    --攻
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_2"), nil, 
    {
        terminal_name = "sm_battleof_kings_start_registration_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    --防
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_3"), nil, 
    {
        terminal_name = "sm_battleof_kings_start_registration_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
	
	--技
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_4"), nil, 
    {
        terminal_name = "sm_battleof_kings_start_registration_change_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)

    --一键布阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_yjbz"), nil, 
    {
        terminal_name = "sm_battleof_kings_a_key_array", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 1)

    --报名提交
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_qrtj"), nil, 
    {
        terminal_name = "sm_battleof_kings_registration_submission", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 1)

    --
    if tonumber(_ED.kings_battle.kings_battle_open_type) == 0 then
    else
        if tonumber(_ED.kings_battle.kings_battle_type) == 1 
            -- 还没有报名的时候，进入报名界面，将上一次的上阵信息显示出来
            or (tonumber(_ED.kings_battle.kings_battle_type) == 0 and _ED.kings_battle.kings_battle_user_formation ~= nil and _ED.kings_battle.kings_battle_user_formation ~= "") then
            _ED.kings_battle.my_formation = _ED.kings_battle.kings_battle_user_formation
        end
    end
    
    self:changeSelectPage(1)
    self:onUpdateFormation()
end

function SmBattleofKingsStartRegistration:onEnterTransitionFinish()
    
end


function SmBattleofKingsStartRegistration:onExit()
	state_machine.remove("sm_battleof_kings_start_registration_change_page")
end

