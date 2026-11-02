-- ----------------------------------------------------------------------------------------------------
-- 说明：战地争霸布阵界面
-------------------------------------------------------------------------------------------------------
ArenaTroopsTab = class("ArenaTroopsTabClass", Window)

local arena_troops_tab_open_terminal = {
    _name = "arena_troops_tab_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaTroopsTabClass")
        if nil == _homeWindow then
    		fwin:open(ArenaTroopsTab:new():init(params[1]), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_troops_tab_close_terminal = {
    _name = "arena_troops_tab_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaTroopsTabClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaTroopsTabClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_troops_tab_open_terminal)
state_machine.add(arena_troops_tab_close_terminal)
state_machine.init()
    
function ArenaTroopsTab:ctor()
    self.super:ctor()
    self.roots = {}
	
	self._choose_formation = {}
    self._choose_leaders = {}
	
	self._current_page = 0	
	self._tankCellTab = {}
    self._tankLightList = {}
    self._leaderCellTab = {}
    self._leaderLightList = {}
	
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

    app.load("client.red_alert_time.leader.LeaderExchangeInfo")
	
	local function init_arena_troops_tab_terminal()
		local arena_troops_tab_show_terminal = {
            _name = "arena_troops_tab_show",
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

        local arena_troops_tab_hide_terminal = {
            _name = "arena_troops_tab_hide",
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

		local arena_troops_tab_choose_leader_terminal = {
            _name = "arena_troops_tab_choose_leader",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(157, false) == true then
                    TipDlg.drawTextDailog(red_alert_time_str[86])
                    return
                end
                local index = params._datas.index
                if instance._choose_leaders[""..index].ship == nil then
                    state_machine.excute("formation_leader_choose_window_open", 0, {index, instance._choose_leaders})
                else
                    local info = {}
                    info.choose_formation_index = index
                    info.choose_ship = nil
                    state_machine.excute("arena_troops_tab_update_once_leader_info", 0, info)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local arena_troops_tab_choose_tanke_terminal = {
            _name = "arena_troops_tab_choose_tanke",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                if instance._choose_formation[""..index].ship == nil then
                    state_machine.excute("formation_choose_troop_window_open", 0, {index, instance._choose_formation})
                else
                    local info = {}
                    info.choose_formation_index = index
                    info.choose_ship = nil
                    info.choose_ship_count = 0
                    state_machine.excute("arena_troops_tab_update_once_tank_info", 0, info)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local arena_troops_tab_update_once_tank_info_terminal = {
            _name = "arena_troops_tab_update_once_tank_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params.choose_formation_index
                local choose_ship = params.choose_ship
                local choose_ship_count = params.choose_ship_count
                instance._choose_formation[""..index].ship = choose_ship
                instance._choose_formation[""..index].choose_count = choose_ship_count
                instance:updateChooseInfo(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local arena_troops_tab_update_once_leader_info_terminal = {
            _name = "arena_troops_tab_update_once_leader_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params.choose_formation_index
                local choose_ship = params.choose_ship
                instance._choose_leaders[""..index].ship = choose_ship
                instance:updateChooseLeader(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local arena_troops_tab_max_fighting_terminal = {
            _name = "arena_troops_tab_max_fighting",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:chooseMaxFightingShip()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local arena_troops_tab_max_load_terminal = {
            _name = "arena_troops_tab_max_load",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:chooseMaxLoadShip()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 套用阵型
        local arena_troops_tab_load_formation_terminal = {
            _name = "arena_troops_tab_load_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params
                local formation = _ED.default_formation[""..index]
                instance:updateFormation(formation)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 保存阵型
        local arena_troops_tab_save_formation_terminal = {
            _name = "arena_troops_tab_save_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params[1]
                local formation_name = params[2]
                if instance:saveFormation(index, formation_name) == true then
                    TipDlg.drawTextDailog(string.format(formation_type_string[16], index))
                else
                    TipDlg.drawTextDailog(formation_type_string[15])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 克隆竞技场阵型
        local arena_troops_tab_clone_arena_formation_terminal = {
            _name = "arena_troops_tab_clone_arena_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local formation = nil
				local datas = {}
				local leaderdatas = {}
				for i=1, 6 do
					-- 部队实例ID,部队模板ID,战斗数量,单位载重,出战数量,将领实例ID,将领模板ID
					
					if tonumber(self._choose_formation[""..i].choose_count) == 0 then
						datas[i] = "0,0,0,0,0"
					else
						-- debug.print_r(self._choose_formation[""..i])
						datas[i] = self._choose_formation[""..i].ship.ship_id..","..self._choose_formation[""..i].ship.ship_template_id..","
						..self._choose_formation[""..i].choose_count..","..self._choose_formation[""..i].ship.attack_speed..","..self._choose_formation[""..i].choose_count
					end
				end
				for i=1, 6 do
					if self._choose_leaders[""..i].ship == nil then
						leaderdatas[i] = "0,0"
					else
						leaderdatas[i] = self._choose_leaders[""..i].ship.ship_id..","..self._choose_leaders[""..i].ship.ship_template_id
					end
				end
				for i=1,6 do 
					if i == 1 then
						formation = ""..datas[i]..","..leaderdatas[i]
					else
						formation = formation.."|"..datas[i]..","..leaderdatas[i]
					end
				end
				local function responseNationalTaskCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						_ED.arena_info.arena_formation = formation
                    end
                end
				
                protocol_command.arena_launch_formation_change.param_list = "0".."\r\n"..formation
				NetworkManager:register(protocol_command.arena_launch_formation_change.code, nil, nil, nil, nil, responseNationalTaskCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
        state_machine.add(arena_troops_tab_show_terminal)
        state_machine.add(arena_troops_tab_hide_terminal) 
        state_machine.add(arena_troops_tab_choose_leader_terminal) 
        state_machine.add(arena_troops_tab_choose_tanke_terminal) 
        state_machine.add(arena_troops_tab_update_once_tank_info_terminal) 
        state_machine.add(arena_troops_tab_max_fighting_terminal) 
        state_machine.add(arena_troops_tab_load_formation_terminal) 
        state_machine.add(arena_troops_tab_save_formation_terminal) 
        state_machine.add(arena_troops_tab_clone_arena_formation_terminal) 
		state_machine.init()
	end
	
	init_arena_troops_tab_terminal()
	
end

function ArenaTroopsTab:updateChooseInfo( formation_index )
    local root = self.roots[1]
    local ship = self._choose_formation[""..formation_index].ship
    local choose_count = self._choose_formation[""..formation_index].choose_count
    local cell = self._tankCellTab[formation_index]
    cell:updateAllInfo(formation_index, ship, choose_count)
    self:updateOtherInfo()
end

function ArenaTroopsTab:updateChooseLeader( formation_index )
    local root = self.roots[1]
    local ship = self._choose_leaders[""..formation_index].ship
    local cell = self._leaderCellTab[formation_index]
    cell:updateAllInfo(formation_index, ship)
    self:updateOtherInfo()
end

function ArenaTroopsTab:updateOtherInfo( ... )
    local root = self.roots[1]
    local Text_troops_t = ccui.Helper:seekWidgetByName(root, "Text_troops_t")
    local Text_troops_fight_t = ccui.Helper:seekWidgetByName(root, "Text_troops_fight_t")
    local Text_troops_load_t = ccui.Helper:seekWidgetByName(root, "Text_troops_load_t")
    local Text_troops_parts_add = ccui.Helper:seekWidgetByName(root, "Text_troops_parts_add")
    local Text_troops_leader_t = ccui.Helper:seekWidgetByName(root, "Text_troops_leader_t")
    local Text_troops_arrival_t = ccui.Helper:seekWidgetByName(root, "Text_troops_arrival_t")
    Text_troops_t:setString(string.format(formation_type_string[3], tonumber(_ED.user_info.soldier)))

    Text_troops_parts_add:setString(string.format(formation_type_string[6], 0))
    Text_troops_leader_t:setString(string.format(formation_type_string[7], 0))
    if self._form_type == 1 or self._form_type == 3 then
        Text_troops_arrival_t:setString("")
    elseif self._form_type == 2 then
		local m_times = getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,_ED.world_map.position_coordinates_y,self.attack_cell._x,self.attack_cell._y)
        Text_troops_arrival_t:setString(string.format(formation_type_string[8], exChangeTimeToString(m_times)))
    end

    -- 更新战斗力，载重
    local all_fight_number = 0
    local all_load_number = 0
    if self._choose_formation ~= nil then
        for k, info in pairs(self._choose_formation) do
            if info.ship ~= nil then
                all_fight_number = all_fight_number + getShipFightNumber(info.ship, info.choose_count)
                all_load_number = all_load_number + tonumber(info.ship.attack_speed) * info.choose_count
            end
        end
    end
    Text_troops_fight_t:setScale(1)
    Text_troops_load_t:setScale(1)
    
    Text_troops_fight_t:setString(string.format(formation_type_string[4], exChangeNumToString(math.floor(all_fight_number))))
    Text_troops_load_t:setString(string.format(formation_type_string[5], exChangeNumToString(all_load_number)))
    if self._isLightFight == true then
        Text_troops_fight_t:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        Text_troops_load_t:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_troops_fight_t:setScale(1.2)
    else
        Text_troops_fight_t:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        Text_troops_load_t:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        Text_troops_load_t:setScale(1.2)
    end

    -- self:updateSaveButtonState()
end


function ArenaTroopsTab:onUpdateDraw()
	local root = self.roots[1]
	self:loadFormation()
	local formation_info = nil
	if _ED.arena_info.arena_formation ~= "" then
		formation_info = {}
		local form_info = zstring.split(_ED.arena_info.arena_formation, "|")
		if #form_info == 6 then
			for i=1,#form_info do
				formation_info[i] = {}
				local formationData = zstring.split(form_info[i], ",")
				formation_info[i].ship_id = formationData[1]
				formation_info[i].count = formationData[5]
				if tonumber(formationData[6]) ~= 0 then
					formation_info[i].leader_id = formationData[6]
				end
			end
		end
	end
	-- debug.print_r(formation_info)
	self:updateFormation(formation_info)
end

function ArenaTroopsTab:updateFormation(formation_info)
    if true then
        self:updateFormationEX(formation_info)
        return
    end
    local root = self.roots[1]
    formation_info = self:adjustFormation(formation_info)
    for i=1,6 do
        local ship = nil
        local choose_count = 0
        local ship_id = 0
        local leader = nil
        if formation_info ~= nil and formation_info[i] ~= nil then
            ship_id = formation_info[i].ship_id
            local leader_id = formation_info[i].leader_id
            if zstring.tonumber(ship_id) > 0 then
                ship = _ED.user_ship[""..ship_id]
                choose_count = formation_info[i].count
                if zstring.tonumber(leader_id) > 0 then
                    leader = _ED.user_ship[""..leader_id]
                end
            end
        end
        local Panel_formation_tank = ccui.Helper:seekWidgetByName(root, "Panel_formation_tank_"..i)
        Panel_formation_tank:removeAllChildren(true)
        local Panel_formation_leader = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_"..i)
        Panel_formation_leader:removeAllChildren(true)
        self._choose_formation[""..i] = {ship = ship, choose_count = choose_count}
        self._choose_leaders[""..i] = {ship = leader}

        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, ship, choose_count,1, true})
        Panel_formation_tank:addChild(cell)

        local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i, leader, 1, 1})
        Panel_formation_leader:addChild(cell)
    end

    self:updateOtherInfo()
end

function ArenaTroopsTab:updateFormationEX(formation_info)
    local root = self.roots[1]
    formation_info = self:adjustFormation(formation_info)

    self._tankCellTab = {}
    self._leaderCellTab = {}
    local padCardsTable = {}
    local leaderCardsTable = {}
    local began_heroSprite = nil
    local began_hero_position = nil
    local change_heroSprite = nil
    local began_hero_ZOrder = nil
    local began_pos = nil
    local end_pos = nil
    local changedHero = nil
    local beganHero = nil

    local function moveFormationHero(heroSprite, changedPad, pos, move_type)
        if heroSprite == nil then
            return
        end
        local xx, yy = heroSprite:getPosition()
        local e_position = fwin:convertToWorldSpace(heroSprite, cc.p(0, 0)) -- heroSprite:convertToWorldSpace(cc.p(0, 0))
        e_position = changedPad:convertToNodeSpace(cc.p(e_position.x, e_position.y))
        heroSprite:setPosition(cc.p(e_position.x, e_position.y))
        
        heroSprite:retain()
        heroSprite:removeFromParent(false)
        changedPad:addChild(heroSprite)
        heroSprite:release()
        heroSprite:setTag(changedPad:getTag())
        
        began_hero_position = cc.p(0, 0)
        heroSprite:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, began_hero_position)))

        if move_type == 2 then
            self:updateChooseLeader(pos)
        else
            self:updateChooseInfo(pos)
        end
    end
    
    local function formationTouchListener(sender, eventType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        local move_type = sender.move_type

        if eventType == ccui.TouchEventType.began then
            local info_list = self._tankCellTab
            if move_type == 2 then
                info_list = self._leaderCellTab
            end
            for pos, heroCard in pairs(info_list) do
                local bPosition = heroCard:convertToNodeSpace(cc.p(__spoint.x, __spoint.y))
                if (bPosition.x > 0 and bPosition.x < heroCard:getContentSize().width and bPosition.y > 0 and bPosition.y < heroCard:getContentSize().height) then
                    began_pos = pos
                    began_heroSprite = heroCard
                    local tempX, tempY  = heroCard:getPosition()
                    began_hero_position = cc.p(tempX, tempY)
                    began_hero_ZOrder = heroCard:getLocalZOrder()
                    local parent_node = began_heroSprite:getParent()
                    beganHero = parent_node 
                    parent_node:reorderChild(began_heroSprite, 100)
                    parent_node:getParent():reorderChild(parent_node, 100)
                end
            end
        elseif eventType == ccui.TouchEventType.moved then
            if began_pos == nil then
                return
            end
            if nil ~= began_heroSprite then
                began_heroSprite:setPosition(cc.p((__mpoint.x - __spoint.x) / app.scaleFactor + began_hero_position.x , (__mpoint.y - __spoint.y) / app.scaleFactor + began_hero_position.y))

                local temp = cc.p(began_heroSprite:getContentSize().width/2, began_heroSprite:getContentSize().height/2)
                local e_position = fwin:convertToWorldSpaceAR(began_heroSprite, cc.p(temp.x,temp.y))
                local index = 0
                local info_list = padCardsTable
                local state_list = self._tankLightList
                if move_type == 2 then
                    info_list = leaderCardsTable
                    state_list = self._leaderLightList
                end
                for pos, card_hero in pairs(info_list) do
                    if card_hero:getTag() ~= began_heroSprite:getTag() then
                        local bPosition = card_hero:convertToNodeSpaceAR(e_position)
                        if (bPosition.x > 0 and bPosition.x < card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height) then
                            index = pos
                        end
                    end
                end
                for k,v in pairs(state_list) do
                    if k == index then
                        v:setVisible(true)
                    else
                        v:setVisible(false)
                    end
                end
            end
        elseif eventType == ccui.TouchEventType.canceled then
            if began_pos == nil then
                return
            end
            if nil ~= began_heroSprite then
                began_heroSprite:setPosition(cc.p(began_hero_position.x, began_hero_position.y))
            end
        elseif eventType == ccui.TouchEventType.ended
            or eventType == ccui.TouchEventType.canceled then
            if began_pos == nil then
                return
            end
            local info_list = padCardsTable
            local state_list = self._tankLightList
            local cell_list = self._tankCellTab
            if move_type == 2 then
                info_list = leaderCardsTable
                state_list = self._leaderLightList
                cell_list = self._leaderCellTab
            end
            if math.abs(__spoint.x - __epoint.x) <= 5 and math.abs(__spoint.y - __epoint.y) <= 5 then
                if move_type == 2 then
                    state_machine.excute("arena_troops_tab_choose_leader", 0, {_datas = {index = began_pos}})
                else
                    state_machine.excute("arena_troops_tab_choose_tanke", 0, {_datas = {index = began_pos}})
                end
            else
                local isChanged = false
                local temp = cc.p(began_heroSprite:getContentSize().width/2, began_heroSprite:getContentSize().height/2)
                local e_position = fwin:convertToWorldSpaceAR(began_heroSprite, cc.p(temp.x,temp.y)) -- began_heroSprite:convertToWorldSpaceAR(cc.p(temp.x,temp.y))
                -- if eventType == ccui.TouchEventType.ended then
                    for pos, card_hero in pairs(info_list) do
                        if card_hero:getTag() ~= began_heroSprite:getTag() then
                            local bPosition = card_hero:convertToNodeSpaceAR(e_position)
                            if (bPosition.x > 0 and bPosition.x < card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height) then
                                isChanged = true
                                changedHero = card_hero
                                end_pos = pos
                                change_heroSprite = cell_list[end_pos]
                                break
                            end
                        end
                    end
                -- end
                if isChanged == false then
                    began_hero_position = cc.p(0, 0)
                    began_heroSprite:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, began_hero_position)))
                    local parent_node = began_heroSprite:getParent() 
                    parent_node:reorderChild(began_heroSprite, began_hero_ZOrder)
                else
                    if move_type == 2 then
                        self._leaderCellTab[began_pos] = change_heroSprite
                        self._leaderCellTab[end_pos] = began_heroSprite

                        local beginInfo = self._choose_leaders[""..began_pos]
                        local endInfo = self._choose_leaders[""..end_pos]
                        self._choose_leaders[""..end_pos] = beginInfo
                        self._choose_leaders[""..began_pos] = endInfo
                    else
                        self._tankCellTab[began_pos] = change_heroSprite
                        self._tankCellTab[end_pos] = began_heroSprite

                        local beginInfo = self._choose_formation[""..began_pos]
                        local endInfo = self._choose_formation[""..end_pos]
                        self._choose_formation[""..end_pos] = beginInfo
                        self._choose_formation[""..began_pos] = endInfo
                    end
                    moveFormationHero(began_heroSprite, changedHero, end_pos, move_type)
                    moveFormationHero(change_heroSprite, beganHero, began_pos, move_type)
                end
                for k,v in pairs(state_list) do
                    v:setVisible(false)
                end
            end
        end
    end

    for i=1,6 do
        local ship = nil
        local choose_count = 0
        local ship_id = 0
        local leader = nil
        if formation_info ~= nil and formation_info[i] ~= nil then
            ship_id = formation_info[i].ship_id
            local leader_id = formation_info[i].leader_id
            if zstring.tonumber(ship_id) > 0 then
                ship = _ED.user_ship[""..ship_id]
                choose_count = formation_info[i].count
                if zstring.tonumber(leader_id) > 0 then
                    leader = _ED.user_ship[""..leader_id]
                end
            end
        end
        local Panel_formation_tank = ccui.Helper:seekWidgetByName(root, "Panel_formation_tank_"..i)
        Panel_formation_tank:removeAllChildren(true)
        local Panel_formation_leader = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_"..i)
        Panel_formation_leader:removeAllChildren(true)
        self._choose_formation[""..i] = {ship = ship, choose_count = choose_count}
        self._choose_leaders[""..i] = {ship = leader}

        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, ship, choose_count,1, true})
        Panel_formation_tank:addChild(cell)
        table.insert(padCardsTable, Panel_formation_tank)
        table.insert(self._tankCellTab, cell)
        cell:setTag(Panel_formation_tank:getTag())
        cell:setName("formation_tank")
        cell.move_type = 1
        cell:addTouchEventListener(formationTouchListener)

        local cell1 = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i, leader, 1, 1})
        Panel_formation_leader:addChild(cell1)
        table.insert(leaderCardsTable, Panel_formation_leader)
        table.insert(self._leaderCellTab, cell1)
        cell1:setTag(Panel_formation_leader:getTag())
        cell1:setName("formation_leader")
        cell1.move_type = 2
        cell1:addTouchEventListener(formationTouchListener)
    end

    self:updateOtherInfo()
end

-- 调整阵型带兵数量，去掉损耗和已出征的部队
function ArenaTroopsTab:adjustFormation(formation_info)
    local reduce_count = {}                 -- ship_id 对应已上阵的数量
    if formation_info == nil then
        return {}
    end
    for k, v in pairs(formation_info) do
        local ship_id = zstring.tonumber(v.ship_id)
        local count = zstring.tonumber(v.count)
        if ship_id > 0 then
            local current_count = 0
            for k1, v1 in pairs(_ED.user_ship) do
                if zstring.tonumber(v1.ship_id) == ship_id then
                    current_count = zstring.tonumber(v1.current_count)
                    break
                end
            end
            local reduce = zstring.tonumber(reduce_count[""..ship_id])
            local max_count = current_count - reduce
            if count > max_count then
                count = max_count
            end
        end
        v.count = count
        reduce_count[""..ship_id] = zstring.tonumber(reduce_count[""..ship_id]) + count
        if count <= 0 then
            formation_info[k] = {ship = nil, choose_count = 0, leader_id = 0}
        end
    end
    return formation_info
end

-- 刷新增益状态
function ArenaTroopsTab:updateFactor()
    local root = self.roots[1]
    local fatcor_state = {0, 0, 0, 0, 0, 0}
    for k, v in pairs(_ED.factor_info) do 
        local build_buff_id = tonumber(v.build_buff_id)
        if build_buff_id == 7 then          -- 减伤
            fatcor_state[1] = 1
        elseif build_buff_id == 6 then      -- 加伤
            fatcor_state[2] = 1
        elseif build_buff_id == 8 then      -- 行军速度
            fatcor_state[3] = 1
        end
    end

    for i = 1, 3 do
        local Image_form_gain_icon_0 = ccui.Helper:seekWidgetByName(root,"Image_form_gain_icon_0_"..i)
        local Image_form_gain_icon = ccui.Helper:seekWidgetByName(root,"Image_form_gain_icon_"..i)
        if fatcor_state[i] > 0 then         -- 有增益
            Image_form_gain_icon_0:setVisible(false)
            Image_form_gain_icon:setVisible(true)
        else
            Image_form_gain_icon_0:setVisible(true)
            Image_form_gain_icon:setVisible(false)
        end
    end
end

function ArenaTroopsTab:chooseMaxFightingShip( ... )
    local result = {}
    local leaders = {}
    for k,v in pairs(_ED.user_ship) do
        if v.captain_type ~= 3 then
            local last_count = tonumber(v.current_count)
            while last_count > 0 do
                last_count = last_count - tonumber(_ED.user_info.soldier)
                if last_count >= 0 then
                    table.insert(result, {ship = v, count = tonumber(_ED.user_info.soldier)})
                else
                    table.insert(result, {ship = v, count = last_count + tonumber(_ED.user_info.soldier)})
                end
            end
        else
            table.insert(leaders, {ship = v})
        end
    end
    local function sortTank(a, b)
        local order_a = dms.int(dms["ship_mould"], a.ship.ship_template_id, ship_mould.base_mould_priority)
        local order_b = dms.int(dms["ship_mould"], b.ship.ship_template_id, ship_mould.base_mould_priority)
        return order_a > order_b
    end
    table.sort(result, sortTank)
    function sortLoad( a, b )
        return tonumber(getShipFightNumber(a.ship, tonumber(a.count))) > tonumber(getShipFightNumber(b.ship, tonumber(b.count)))
    end
    table.sort(result, sortLoad)

    local function sortLeader(a, b)
        if tonumber(a.ship.ship_type) > tonumber(b.ship.ship_type)
            or tonumber(a.ship.ship_type) == tonumber(b.ship.ship_type) and tonumber(a.ship.ship_level) > tonumber(b.ship.ship_level) 
            or tonumber(a.ship.ship_type) == tonumber(b.ship.ship_type) and tonumber(a.ship.ship_level) == tonumber(b.ship.ship_level) and tonumber(a.ship.ship_template_id) < tonumber(b.ship.ship_template_id)
            then
            return true
        end
        return false
    end
    table.sort(leaders, sortLeader)

    local choose_formation = {}
    for k,v in pairs(result) do
        if k > 6 then
            break
        end
        table.insert(choose_formation, {ship_id = v.ship.ship_id, count = v.count})
    end
    for k,v in pairs(leaders) do
        if k > 6 then
            break
        end
        if choose_formation[k] ~= nil then
            choose_formation[k].leader_id = v.ship.ship_id
        end
    end
    self._isLightFight = true
    self:updateFormation(choose_formation)
end

function ArenaTroopsTab:chooseMaxLoadShip( ... )
    local result = {}
    local leaders = {}
    for k,v in pairs(_ED.user_ship) do
        if v.captain_type ~= 3 then
            local last_count = tonumber(v.current_count)
            while last_count > 0 do
                last_count = last_count - tonumber(_ED.user_info.soldier)
                if last_count >= 0 then
                    table.insert(result, {ship = v, attack_speed = tonumber(v.attack_speed), count = tonumber(_ED.user_info.soldier)})
                else
                    table.insert(result, {ship = v, attack_speed = tonumber(v.attack_speed), count = last_count + tonumber(_ED.user_info.soldier)})
                end
            end
        else
            table.insert(leaders, {ship = v})
        end
    end
    local function sortTank(a, b)
        local order_a = dms.int(dms["ship_mould"], a.ship.ship_template_id, ship_mould.base_mould_priority)
        local order_b = dms.int(dms["ship_mould"], b.ship.ship_template_id, ship_mould.base_mould_priority)
        return order_a > order_b
    end
    table.sort(result, sortTank)
    function sortLoad( a, b )
        return tonumber(a.attack_speed) * tonumber(a.count) > tonumber(b.attack_speed) * tonumber(b.count)
    end
    table.sort(result, sortLoad)

    local function sortLeader(a, b)
        if tonumber(a.ship.ship_type) > tonumber(b.ship.ship_type)
            or tonumber(a.ship.ship_type) == tonumber(b.ship.ship_type) and tonumber(a.ship.ship_level) > tonumber(b.ship.ship_level) 
            or tonumber(a.ship.ship_type) == tonumber(b.ship.ship_type) and tonumber(a.ship.ship_level) == tonumber(b.ship.ship_level) and tonumber(a.ship.ship_template_id) < tonumber(b.ship.ship_template_id)
            then
            return true
        end
        return false
    end
    table.sort(leaders, sortLeader)

    local choose_formation = {}
    for k,v in pairs(result) do
        if k > 6 then
            break
        end
        table.insert(choose_formation, {ship_id = v.ship.ship_id, count = v.count})
    end
    for k,v in pairs(leaders) do
        if k > 6 then
            break
        end
        if choose_formation[k] ~= nil then
            choose_formation[k].leader_id = v.ship.ship_id
        end
    end
    self._isLightFight = false
    self:updateFormation(choose_formation)
end

-- 保存阵型
function ArenaTroopsTab:saveFormation(index, formation_name)
    local can_save = false
    local str = ""
    local formation = {}
    for i = 1, 6 do
        local info = self._choose_formation[""..i]
        local leader = self._choose_leaders[""..i]
        local formation_info = {}
        if info.ship == nil then
            if i == 1 then
                str = str.."0,0"
            else
                str = str.."|0,0"
            end
            formation_info.ship_id = 0
            formation_info.count = 0
        else
            if i == 1 then
                str = str..info.ship.ship_id..","..info.choose_count
            else
                str = str.."|"..info.ship.ship_id..","..info.choose_count
            end
            formation_info.ship_id = info.ship.ship_id
            formation_info.count = info.choose_count
            if leader.ship == nil then
                str = str..",0"
                formation_info.leader_id = 0
            else
                str = str..","..leader.ship.ship_id
                formation_info.leader_id = leader.ship.ship_id
            end
            can_save = true
        end
        table.insert(formation, formation_info)
    end
    if can_save == false then
        return false
    end
    if index == 0 then          -- 保存进攻阵型
        cc.UserDefault:getInstance():setStringForKey(getKey("attack_formation"), str)
        _ED.attack_formation = formation
    else                        -- 阵型管理阵型
        if formation_name ~= nil and formation_name ~= "" then
            cc.UserDefault:getInstance():setStringForKey(getKey("formation_name"..index), formation_name)
            cc.UserDefault:getInstance():setStringForKey(getKey("formation"..index), str)
            _ED.default_formation[""..index] = formation
        end
    end
    return true
end

-- 加载保存的阵型
function ArenaTroopsTab:loadFormation()
    -- 阵型管理保存的阵型
    if _ED.default_formation == nil then
        _ED.default_formation = {}
        local max_formation_count = dms.int(dms["base_consume"], 82, base_consume.vip_0_value + tonumber(_ED.vip_grade)) -- 可保存最大阵型数量
        for i = 1, max_formation_count do
            local formation_name = "formation"..i
            local formation_str = cc.UserDefault:getInstance():getStringForKey(getKey(formation_name))
            if formation_str ~= nil and formation_str ~= "" then
                local formation_tabs = zstring.split(formation_str, "|")
                local formation = {}
                for j = 1, 6 do
                    local formation_info = zstring.split(formation_tabs[j], ",")
                    local info = {}
                    info.ship_id = formation_info[1]
                    info.count = formation_info[2]
                    info.leader_id = formation_info[3]
                    table.insert(formation, info)
                end
                _ED.default_formation[""..i] = formation
            end
        end
    end
end

function ArenaTroopsTab:init(params1)
	self._rootWindows = params1
    self:onInit()
    return self
end

function ArenaTroopsTab:onInit()
    local csbArenaTroopsTab = csb.createNode(config_csb.arena.arena_troops_tab)
    local root = csbArenaTroopsTab:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaTroopsTab)
	
	for i=1,6 do
        local Image_form_tank_hook = ccui.Helper:seekWidgetByName(root, "Image_form_tank_hook_"..i)
        table.insert(self._tankLightList, Image_form_tank_hook)
        local Image_form_leader_hook = ccui.Helper:seekWidgetByName(root, "Image_form_leader_hook_"..i)
        table.insert(self._leaderLightList, Image_form_leader_hook)
    end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation_fight"), nil, 
    {
        terminal_name = "arena_troops_tab_max_fighting", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation_load"), nil, 
    {
        terminal_name = "arena_troops_tab_max_load", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation"), nil, 
    {
        terminal_name = "formation_manage_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation_save"), nil, 
    {
        terminal_name = "arena_troops_tab_clone_arena_formation", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)
	
	
	self:onUpdateDraw()
end

function ArenaTroopsTab:onExit()
	state_machine.remove("arena_troops_tab_show")
    state_machine.remove("arena_troops_tab_hide")
    state_machine.remove("arena_troops_tab_choose_leader")
    state_machine.remove("arena_troops_tab_choose_tanke")
    state_machine.remove("arena_troops_tab_update_once_tank_info")
    state_machine.remove("arena_troops_tab_update_once_leader_info")
    state_machine.remove("arena_troops_tab_max_fighting")
    state_machine.remove("arena_troops_tab_max_load")
    state_machine.remove("arena_troops_tab_load_formation")
    state_machine.remove("arena_troops_tab_save_formation")
    state_machine.remove("arena_troops_tab_clone_arena_formation")
end