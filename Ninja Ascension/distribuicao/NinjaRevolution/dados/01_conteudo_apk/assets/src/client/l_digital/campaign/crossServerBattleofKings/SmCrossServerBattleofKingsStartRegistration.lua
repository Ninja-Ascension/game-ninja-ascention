-----------------------------
-- 王者之战开始报名
-----------------------------
SmCrossServerBattleofKingsStartRegistration = class("SmCrossServerBattleofKingsStartRegistrationClass", Window)

--打开界面
local sm_cross_server_battleof_kings_start_registration_open_terminal = {
	_name = "sm_cross_server_battleof_kings_start_registration_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmCrossServerBattleofKingsStartRegistrationClass") == nil then
			fwin:open(SmCrossServerBattleofKingsStartRegistration:new():init(), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_cross_server_battleof_kings_start_registration_close_terminal = {
	_name = "sm_cross_server_battleof_kings_start_registration_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmCrossServerBattleofKingsStartRegistrationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cross_server_battleof_kings_start_registration_open_terminal)
state_machine.add(sm_cross_server_battleof_kings_start_registration_close_terminal)
state_machine.init()

function SmCrossServerBattleofKingsStartRegistration:ctor()
	self.super:ctor()
	self.roots = {}

    self._current_page = 0
    self._all = nil
    self._attack = nil
    self._anti = nil
    self._technology = nil
	app.load("client.cells.ship.ship_icon_cell")

    local function init_sm_cross_server_battleof_kings_start_registration_terminal()
        local sm_cross_server_battleof_kings_start_registration_change_page_terminal = {
            _name = "sm_cross_server_battleof_kings_start_registration_change_page",
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

                if m_type == 0 then
                    local formation_number = zstring.split(_ED.cross_server_kings_battle.my_formation,",")
                    if #formation_number >= 10 then
                        return
                    end
                    --上阵
                    if _ED.cross_server_kings_battle.my_formation ~= nil and _ED.cross_server_kings_battle.my_formation ~= "" then
                        _ED.cross_server_kings_battle.my_formation = _ED.cross_server_kings_battle.my_formation..","..ship.ship_id
                    else
                        _ED.cross_server_kings_battle.my_formation = ""..ship.ship_id
                    end
                else
                    --下阵
                    local formation_info = zstring.split(_ED.cross_server_kings_battle.my_formation,",")
                    _ED.cross_server_kings_battle.my_formation = ""
                    for i,v in pairs(formation_info) do
                        if "" == v then
                            break
                        end
                        if tonumber(v) == tonumber(ship.ship_id) then
                        else
                            if _ED.cross_server_kings_battle.my_formation == "" then
                                _ED.cross_server_kings_battle.my_formation = ""..v
                            else
                                _ED.cross_server_kings_battle.my_formation = _ED.cross_server_kings_battle.my_formation..","..v
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

        local sm_cross_server_battleof_kings_a_key_array_terminal = {
            _name = "sm_cross_server_battleof_kings_a_key_array",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED.cross_server_kings_battle.my_formation = ""
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
                        if _ED.cross_server_kings_battle.my_formation ~= nil and _ED.cross_server_kings_battle.my_formation ~= "" then
                            _ED.cross_server_kings_battle.my_formation = _ED.cross_server_kings_battle.my_formation..","..ship.ship_id
                        else
                            _ED.cross_server_kings_battle.my_formation = ""..ship.ship_id
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

        local sm_cross_server_battleof_kings_registration_submission_terminal = {
            _name = "sm_cross_server_battleof_kings_registration_submission",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function requestSubmitApply(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- 初始化协议返回
                        local function selfInitResponse( response )
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                
                                local function requestRefrushInit( response )
                                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                        state_machine.excute("sm_cross_server_battleof_kings_open_my_schedule", 0, {_datas={_page = 2}})
                                        state_machine.excute("sm_cross_server_battleof_kings_start_registration_close", 0, nil)
                                        state_machine.excute("sm_cross_server_battleof_kings_look_peak_update_add_number", 0, nil)
                                        if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) == 0 then
                                        else
                                            if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_type) == 1 then
                                                state_machine.excute("sm_cross_server_battleof_kings_my_general_formation_update", 0, nil)
                                            else
                                                TipDlg.drawTextDailog(_new_interface_text[180])
                                            end
                                        end
                                    end
                                end

                                -- 跨服王者别人的阵型
                                protocol_command.the_kings_battle_self_get_other_info.param_list = "".._ED.cross_server_kings_battle.singletonId
                                NetworkManager:register(protocol_command.the_kings_battle_self_get_other_info.code, nil, nil, nil, self, requestRefrushInit, false, nil)
                            end
                        end
                        -- 跨服王者之战初始化接口
                        NetworkManager:register(protocol_command.the_kings_battle_self_init.code, nil, nil, nil, self, selfInitResponse, false, nil)
                    end
                end
                --只报名
                if 0 == _ED.cross_server_kings_battle.cross_server_kings_battle_type and (nil == _ED.cross_server_kings_battle.my_formation or 0 == #_ED.cross_server_kings_battle.my_formation) then
                    -- print("--------------只报名")
                    protocol_command.the_kings_battle_self_apply.param_list = ""
                    NetworkManager:register(protocol_command.the_kings_battle_self_apply.code, nil, nil, nil, instance, requestSubmitApply, false, nil)  
                    return true
                end
                --提交阵容
                local formation_info = zstring.split(_ED.cross_server_kings_battle.my_formation,",")
                if #formation_info < 10 then
                    TipDlg.drawTextDailog(_new_interface_text[152])
                    return 
                end

                if 0 == _ED.cross_server_kings_battle.cross_server_kings_battle_type then
                    
                    local function requestHavePopleSubmitApply(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            local formation = ""
                            local index = ""
                            
                            if "" == index and "" == formation then
                                for i=1,10 do
                                    if 1 == i then
                                        index = i..""
                                    else
                                        index = index..","..i
                                    end
                                end
                                formation = _ED.cross_server_kings_battle.my_formation
                                -- print(index.."\r\n"..formation,"--------------新建陣容")
                            end

                            protocol_command.the_kings_battle_self_change_formation.param_list = formation.."\r\n"..index
                            NetworkManager:register(protocol_command.the_kings_battle_self_change_formation.code, nil, nil, nil, instance, requestSubmitApply, false, nil)
                            
                        end
                    end
                    protocol_command.the_kings_battle_self_apply.param_list = ""
                    NetworkManager:register(protocol_command.the_kings_battle_self_apply.code, nil, nil, nil, instance, requestHavePopleSubmitApply, false, nil)
                    return  
                end
                --判断是修改还是提交
                local formation = ""
                local index = ""
                -- if _ED.cross_server_kings_battle.cross_server_kings_battle_user_formation then
                --     local formation_last_info = zstring.split(_ED.cross_server_kings_battle.cross_server_kings_battle_user_formation,",")
                --     for i = 1,#formation_info do
                --         local v = formation_info[i]
                --         if "" == v then
                --             break
                --         end
                --         local flag = true
                --         if tonumber(v) == tonumber(formation_last_info[i]) then
                --             flag = false
                --         end

                --         if flag then
                --             if "" == index then
                --                 index = i..""
                --                 formation = v..""
                --             else
                --                 index = index..","..i
                --                 formation = formation..","..v
                --             end
                --         end
                --     end
                --     print(index.."\r\n"..formation,"--------------修改")
                -- end
                -- if "" == formation or "" == index then
                --     TipDlg.drawTextDailog(tipStringInfo_cross_server_king_battel_tips[1])
                --     return 
                -- end

                -- 不在做阵容是否一样的判断
                for i = 1,#formation_info do
                    local v = formation_info[i]
                    if "" == v then
                        break
                    end

                    if "" == index then
                        index = i..""
                        formation = v..""
                    else
                        index = index..","..i
                        formation = formation..","..v
                    end
                end


                protocol_command.the_kings_battle_self_change_formation.param_list = formation.."\r\n"..index
                NetworkManager:register(protocol_command.the_kings_battle_self_change_formation.code, nil, nil, nil, instance, requestSubmitApply, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(sm_cross_server_battleof_kings_start_registration_change_page_terminal)
        state_machine.add(sm_battleof_kings_start_go_to_battle_terminal)
        state_machine.add(sm_cross_server_battleof_kings_a_key_array_terminal)
        state_machine.add(sm_cross_server_battleof_kings_registration_submission_terminal)
        state_machine.init()
    end
    init_sm_cross_server_battleof_kings_start_registration_terminal()
end

function SmCrossServerBattleofKingsStartRegistration:changeSelectPage( page )
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

function SmCrossServerBattleofKingsStartRegistration:getSortedHeroes(pages)
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
--更新阵容
function SmCrossServerBattleofKingsStartRegistration:onUpdateFormation()
    local root = self.roots[1]
    --模板ID：等级：进化状态：星级:品阶:战力:实例ID:速度:斗魂:技能等级：皮肤id!下一个武将
    local formation_info = nil
    if _ED.cross_server_kings_battle.my_formation == nil or _ED.cross_server_kings_battle.my_formation == "" then
        _ED.cross_server_kings_battle.my_formation = ""
    else
        formation_info = zstring.split(_ED.cross_server_kings_battle.my_formation,",")
    end

    for i=1, 10 do
        local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_"..i)
        -- local Image_add = ccui.Helper:seekWidgetByName(root, "Image_add_"..i)
        Panel_digimon_icon:removeAllChildren(true)
        -- Image_add:setVisible(true)
        if formation_info ~= nil then
            if formation_info[i] ~= nil then
                local temperId = formation_info[i]
                local cell = ShipIconCell:createCell()
                cell:init(_ED.user_ship[temperId],11)
                ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"):setTouchEnabled(false)
                Panel_digimon_icon:addChild(cell)
            end
        end
    end
end

function SmCrossServerBattleofKingsStartRegistration:onUpdateDraw(pages)
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
        if _ED.cross_server_kings_battle.my_formation ~= nil and _ED.cross_server_kings_battle.my_formation ~= "" then
            local formation_info = zstring.split(_ED.cross_server_kings_battle.my_formation,",")
            for i, w in pairs(formation_info) do
                if tonumber(v.ship_id) == tonumber(w) then
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
    if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) == 0 then
    else
        if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_type) == 1 then
           self:onUpdateFormation()
        end
    end
end

function SmCrossServerBattleofKingsStartRegistration:init()
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function SmCrossServerBattleofKingsStartRegistration:onInit()
    local csbItem = csb.createNode("campaign/BattleofKings/battle_of_kings_sign_up.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_wzzz_back"), nil, 
    {
        terminal_name = "sm_cross_server_battleof_kings_start_registration_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --全部
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_1"), nil, 
    {
        terminal_name = "sm_cross_server_battleof_kings_start_registration_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
	
    --攻
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_2"), nil, 
    {
        terminal_name = "sm_cross_server_battleof_kings_start_registration_change_page", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    --防
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_3"), nil, 
    {
        terminal_name = "sm_cross_server_battleof_kings_start_registration_change_page", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
	
	--技
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_4"), nil, 
    {
        terminal_name = "sm_cross_server_battleof_kings_start_registration_change_page", 
        terminal_state = 0, 
        _page = 4,
    }, nil, 1)

    --一键布阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_yjbz"), nil, 
    {
        terminal_name = "sm_cross_server_battleof_kings_a_key_array", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 1)

    --报名提交
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_qrtj"), nil, 
    {
        terminal_name = "sm_cross_server_battleof_kings_registration_submission", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 1)

    --
    if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) == 0 then
    else
        if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_type) == 1 
            -- 还没有报名的时候，进入报名界面，将上一次的上阵信息显示出来
            or (tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_type) == 0 and _ED.cross_server_kings_battle.cross_server_kings_battle_user_formation ~= nil and _ED.cross_server_kings_battle.cross_server_kings_battle_user_formation ~= "") then
            _ED.cross_server_kings_battle.my_formation = _ED.cross_server_kings_battle.cross_server_kings_battle_user_formation
        end
    end
    
    self:changeSelectPage(1)
    self:onUpdateFormation()
end

function SmCrossServerBattleofKingsStartRegistration:onEnterTransitionFinish()
    
end


function SmCrossServerBattleofKingsStartRegistration:onExit()
	state_machine.remove("sm_cross_server_battleof_kings_start_registration_change_page")
end

