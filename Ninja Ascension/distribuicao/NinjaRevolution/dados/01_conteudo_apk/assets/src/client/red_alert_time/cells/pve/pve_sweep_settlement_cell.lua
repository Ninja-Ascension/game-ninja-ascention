----------------------------------------------------------------------------------------------------
-- 说明：扫荡结算cell
-------------------------------------------------------------------------------------------------------
PveSweepSettlementCell = class("PveSweepSettlementCellClass", Window)
PveSweepSettlementCell.__size = nil
PveSweepSettlementCell.__list_size = nil

local pve_sweep_settlement_create_cell_terminal = {
    _name = "pve_sweep_settlement_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PveSweepSettlementCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_sweep_settlement_create_cell_terminal)
state_machine.init()

function PveSweepSettlementCell:ctor()
    self.super:ctor()
	self.roots = {}		
	self.number = 0
	self.reward = nil
	self.old_formation = nil
	self.count = 1
	self.is_xh = false

    self.is_no_energy = false
    self.is_no_ship = false
    self.is_failure = false
    self.is_no_gem = false
    self.fight_type = 0

    self.is_no_attack_times = false     -- 装甲副本扫荡挑战次数不足

	app.load("client.red_alert_time.cells.pve.pve_sweep_result_cell")
	app.load("client.red_alert_time.cells.pve.pve_sweep_loss_cell")
	app.load("client.red_alert_time.cells.pve.pve_sweep_repair_cell")
	app.load("client.red_alert_time.cells.pve.pve_sweep_loss_icon_cell")
	app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
	
 	local function init_pve_sweep_settlement_cell_terminal()
        local pve_sweep_settlement_cell_choose_terminal = {
            _name = "pve_sweep_settlement_cell_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local pve_sweep_settlement_cell_carry_on_terminal = {
            _name = "pve_sweep_settlement_cell_carry_on",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				--扫荡继续
                local cell = params
				local old_formation = {}
				local function sweepCallback( response )
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        fwin:addService({
                            callback = function ( params )
                                state_machine.unlock("adventure_mine_request_battle_field_init")
                            end,
                            delay = 0.3,
                            params = nil
                        })
						state_machine.excute("pve_map_update_draw",0,"")
						if params ~= nil and params.roots ~= nil and params.roots[1] ~= nil then
							params.reward = getSceneReward(2)
							params:onUpdateListView()
                            if params.reward == nil then
                                _ED._sweep_failure = true
                            end
						end
                        if fwin:find("PveRaidClass") ~= nil then
                            state_machine.excute("pve_raid_sweep_is_once_again",0,0)
                            state_machine.excute("pve_raid_update_zidi", 0, 0)
                        end
                    else
                        state_machine.unlock("adventure_mine_request_battle_field_init")
					end
				end
				for i,v in pairs(_ED.attack_formation) do
					local is_same = false
					if tonumber(v.ship_id)~= 0 then
						for j,w in pairs(old_formation) do
							if w.ship_id == v.ship_id then
								is_same = true
							end
						end
						if is_same == false then
							v.ship_count = _ED.user_ship[v.ship_id].ship_count
							table.insert(old_formation, v)
						end
					end
				end

                local formation = zstring.split(_ED.sweep_request_info.att_str, "|")
                local att_str = ""
                local can_sweep = false
                local reduce_count = {}                 -- ship_id 对应已上阵的数量
                for i = 1, 6 do
                    if formation[i] ~= nil then
                        local info = zstring.split(formation[i], ",")
                        local ship_id = tonumber(info[1])
                        local ship = _ED.user_ship[""..ship_id]
                        local count = tonumber(info[3])
                        local current_count = 0
                        local reduce = zstring.tonumber(reduce_count[""..ship_id])
                        if ship ~= nil then
                            current_count = tonumber(ship.current_count) - reduce
                        end
                        if current_count < count then
                            count = current_count
                        end
                        reduce_count[""..ship_id] = zstring.tonumber(reduce_count[""..ship_id]) + count
                        if i > 1 then
                            att_str = att_str.."|"
                        end
                        if count == 0 then
                            att_str = att_str.."0,0,0,0,0,0,0"
                        else
                            can_sweep = true
                            att_str = att_str..info[1]..","..info[2]..","..count..","..info[4]..","..count..","..info[6]..","..info[7]
                        end
                    end
                end
                if _ED._sweep_failure == true then
                    cell.is_failure = true
                    cell:onUpdateDraw()
                    _ED._sweep_failure = false
                    return
                end
                if can_sweep == false then
                    state_machine.excute("pve_raid_sweep_stop", 0, 1)
                    cell.is_no_ship = true
                    cell:onUpdateDraw()
                else
                    _ED.sweep_request_info.att_str = att_str
    				state_machine.excute("adventure_mine_request_battle_field_init", 0, {_ED.sweep_request_info.fight_type, _ED.sweep_request_info.scene_id, _ED.sweep_request_info.npc_id, 
    				_ED.sweep_request_info.difficulty, 0, _ED.sweep_request_info.att_str, 1, sweepCallback})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local pve_sweep_settlement_cell_stop_terminal = {
            _name = "pve_sweep_settlement_cell_stop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                 local cell = params._datas.cell
				 cell.is_xh = true
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(pve_sweep_settlement_cell_choose_terminal)
        state_machine.add(pve_sweep_settlement_cell_carry_on_terminal)
        state_machine.add(pve_sweep_settlement_cell_stop_terminal)
        state_machine.init()
    end
	init_pve_sweep_settlement_cell_terminal()        	
end

function PveSweepSettlementCell:onUpdateListView()
    local root = self.roots[1]
    --列表
    local ListView_cell_box = ccui.Helper:seekWidgetByName(root,"ListView_cell_box")
    local Image_sweep_time_line = ccui.Helper:seekWidgetByName(root,"Image_sweep_time_line")
    ListView_cell_box:removeAllItems()
    local cellReward = nil
    local cellloss = nil
    local cellrepair = nil
    --奖励
    if self.reward ~= nil then
        cellReward = state_machine.excute("pve_sweep_result_create_cell", 0, self.reward) 
        ListView_cell_box:addChild(cellReward)
    end
    
    local is_consumption = false
    local is_repair = false
    for i,v in pairs(self.old_formation) do
        if tonumber(_ED.user_ship[v.ship_id].lose_ship_count) > 0 then
            is_repair = true
        end
        if tonumber(_ED.user_ship[v.ship_id].ship_count) < tonumber(v.ship_count) then
            self.old_formation[i].loss_count = tonumber(v.ship_count) - tonumber(_ED.user_ship[v.ship_id].ship_count)
            is_consumption = true
        end
    end
    --损失
    if is_consumption == true then
        cellloss = state_machine.excute("pve_sweep_loss_create_cell", 0, self.old_formation) 
        ListView_cell_box:addChild(cellloss)
    end
    --修理
    if is_repair == true then
        cellrepair = state_machine.excute("pve_sweep_repair_create_cell", 0, {self,self.old_formation}) 
        ListView_cell_box:addChild(cellrepair)
    end
    
    local listHeight = 0
    if cellReward ~= nil then
        listHeight = listHeight + cellReward:getContentSize().height
    end
    if cellloss ~= nil then
        listHeight = listHeight + cellloss:getContentSize().height
    end
    if cellrepair ~= nil then
        listHeight = listHeight + cellrepair:getContentSize().height
    end

    if PveSweepSettlementCell.__list_size.height < listHeight then
        local upHeight = (listHeight-ListView_cell_box:getContentSize().height)
        root:setContentSize(cc.size(PveSweepSettlementCell.__size.width,PveSweepSettlementCell.__size.height+upHeight))
        self:setContentSize(root:getContentSize())
        ListView_cell_box:setContentSize(cc.size(PveSweepSettlementCell.__list_size.width, listHeight))
        root:setPositionY(root:getPositionY() + upHeight)
        Image_sweep_time_line:setPositionY(ListView_cell_box:getPositionY()-listHeight-12)
    end

    ListView_cell_box:requestRefreshView()
    state_machine.excute("pve_raid_sweep_request_refresh_list", 0, "")
end

function PveSweepSettlementCell:onUpdateDraw()
    local root = self.roots[1]
    --第几次扫荡
    local Text_sweep_number = ccui.Helper:seekWidgetByName(root,"Text_sweep_number")
    local Text_sweep_count_down = ccui.Helper:seekWidgetByName(root,"Text_sweep_count_down")
    local Image_title = ccui.Helper:seekWidgetByName(root,"Image_title")
    local ListView_cell_box = ccui.Helper:seekWidgetByName(root,"ListView_cell_box")
    local Image_sweep_time_line = ccui.Helper:seekWidgetByName(root,"Image_sweep_time_line")
    Text_sweep_number:setString(string.format(sweep_tip_text[1],self.number))
    Text_sweep_count_down:setString(string.format(sweep_tip_text[2],math.floor(self.count+1)))
    Text_sweep_count_down:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))

    Image_title:setVisible(true)
    Text_sweep_number:setVisible(true)

    if _ED._sweep_failure == true then
        self.is_failure = true
        _ED._sweep_failure = false
    end

    if self.number > self.max_number then
        Image_title:setVisible(false)
        Text_sweep_number:setVisible(false)
        ListView_cell_box:setVisible(false)
        Text_sweep_count_down:setVisible(true)
        Image_sweep_time_line:setVisible(true)
        Text_sweep_count_down:setString(sweep_tip_text[11])
        Text_sweep_count_down:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        state_machine.excute("pve_raid_sweep_stop", 0, 1)
        state_machine.excute("pve_raid_update_zidi", 0, 0)
    else
        if self.is_no_energy == true 
            or self.is_no_ship == true
            or self.is_failure == true
            or self.is_no_attack_times == true
            or self.is_no_gem == true
            then
            local str = ""
            local stop_type = 0
            if self.is_no_energy == true then
                str = sweep_tip_text[12]
                stop_type = 2
            elseif self.is_no_ship == true then
                str = sweep_tip_text[13]
                stop_type = 2
            elseif self.is_failure == true then
                str = sweep_tip_text[14]
                stop_type = 3
            elseif self.is_no_attack_times == true then
                str = sweep_tip_text[17]
                stop_type = 3
            elseif self.is_no_gem == true then
                str = sweep_tip_text[18]
                stop_type = 3
            end
            Image_title:setVisible(false)
            Text_sweep_number:setVisible(false)
            ListView_cell_box:setVisible(false)
            Text_sweep_count_down:setVisible(true)
            Image_sweep_time_line:setVisible(true)
            Text_sweep_count_down:setString(str)
            Text_sweep_count_down:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
            state_machine.excute("pve_raid_sweep_stop", 0, stop_type)
        end
    end
end

function PveSweepSettlementCell:onEnterTransitionFinish()
	
end

function PveSweepSettlementCell:onUpdate(dt)
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    if self.number > self.max_number then
        return
    end
    if self.is_failure == true then
        return
    end

    if self.count > 0 then
        state_machine.excute("pve_raid_update_draw", 0, 0 )
        self.count = self.count - dt
        local Text_sweep_number = ccui.Helper:seekWidgetByName(self.roots[1],"Text_sweep_number")
        Text_sweep_number:setString(string.format(sweep_tip_text[1],self.number))
        if self.count <= 0 then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_sweep_count_down"):setVisible(false)
        end
        if self.fight_type == battle_enum._fight_type._fight_type_15 then
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_sweep_count_down"):setString(sweep_tip_text[15])
        else
            ccui.Helper:seekWidgetByName(self.roots[1],"Text_sweep_count_down"):setString(string.format(sweep_tip_text[2],math.floor(self.count+1)))
        end
    elseif self.count <= 0 and self.is_xh == false then
        self.is_xh = true
        ccui.Helper:seekWidgetByName(self.roots[1],"Text_sweep_count_down"):setVisible(false)
        ccui.Helper:seekWidgetByName(self.roots[1],"Image_sweep_time_line"):setVisible(true)
        ccui.Helper:seekWidgetByName(self.roots[1],"ListView_cell_box"):setVisible(true)
        -- state_machine.excute("pve_sweep_result_cell_update_sprint", 0, 0)
        -- if self.reward == nil then
            -- state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = sweep_tip_text[6], m_type = 0}})
        -- else
			if self.number > self.max_number then
				state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = sweep_tip_text[6], m_type = 0}})
                self:onUpdateDraw()
			else
                local carry_on = true
                local repars_ships = {}
                for i,v in pairs(self.old_formation) do
                    if tonumber(_ED.user_ship[v.ship_id].lose_ship_count) > 0 then
                        table.insert(repars_ships, v)
                    end
                end
                local need_repars_gem = 0
                for j, k in pairs(repars_ships) do
                    local ship_data = dms.element(dms["ship_mould"], _ED.user_ship[k.ship_id].ship_template_id)
                    local cost_gem = dms.atoi(ship_data, ship_mould.price)           -- 维修消耗宝石矿
                    need_repars_gem = need_repars_gem + math.ceil(tonumber(_ED.user_ship[k.ship_id].lose_ship_count)*cost_gem)
                end
                need_repars_gem = math.ceil(need_repars_gem * (1 - zstring.tonumber(_ED.repair_cost_factor) / 100))
                if need_repars_gem > zstring.tonumber(_ED.user_info.user_silver) then
                    carry_on = false
                    self.is_no_gem = true
                    self:onUpdateDraw()
                else
                    if self.fight_type == battle_enum._fight_type._fight_type_15 then
                        if getArmorPveAttackTimes() <= 0 then
                            carry_on = false
                            self.is_no_attack_times = true
                            self:onUpdateDraw()
                        end
                    else
                        if tonumber(_ED.user_info.user_food) <= 0 then
                            carry_on = false
                            state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = sweep_tip_text[3], m_type = 36}})
                            self.is_no_energy = true
                            self:onUpdateDraw()
                        end
                    end
                end
                if carry_on == true then
                    if self.number < self.max_number then
                        state_machine.excute("pve_sweep_settlement_cell_carry_on",0,self)
                    elseif self.number == self.max_number then
                        TipDlg.drawTextDailog(sweep_tip_text[6])
                        state_machine.excute("pve_sweep_settlement_cell_carry_on",0,self)
                    end
				end
			end
		-- end
	elseif self.is_xh == true then
		-- ccui.Helper:seekWidgetByName(self.roots[1],"Text_sweep_count_down"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(self.roots[1],"Image_sweep_time_line"):setVisible(true)
		-- ccui.Helper:seekWidgetByName(self.roots[1],"ListView_cell_box"):setVisible(true)
	end
end

function PveSweepSettlementCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.pve.pve_sweep_cell)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    if PveSweepSettlementCell.__size == nil then
        PveSweepSettlementCell.__size = root:getContentSize()
    end
    root:setContentSize(PveSweepSettlementCell.__size)
    
    local Image_sweep_time_line = ccui.Helper:seekWidgetByName(root,"Image_sweep_time_line")
    local ListView_cell_box = ccui.Helper:seekWidgetByName(root,"ListView_cell_box")
    local Text_sweep_count_down = ccui.Helper:seekWidgetByName(root,"Text_sweep_count_down")

    if PveSweepSettlementCell.__list_size == nil then
        PveSweepSettlementCell.__list_size = ListView_cell_box:getContentSize()
    end
    ListView_cell_box:removeAllItems()
    ListView_cell_box:setContentSize(PveSweepSettlementCell.__list_size)

    Text_sweep_count_down:setVisible(true)
    Image_sweep_time_line:setVisible(false)
    ListView_cell_box:setVisible(false)

    root:setAnchorPoint(cc.p(0, 0))
    root:setPositionY(0)
    
    self:onUpdateDraw()
end

function PveSweepSettlementCell:onExit()
	-- cacher.freeRef(config_csb.cells.pve.pve_sweep_cell, self.roots[1])
end

function PveSweepSettlementCell:init(datas)
	self.number = datas[1]
	self.reward = datas[2]
	self.old_formation = datas[3]
    self.max_number = datas[4]
    self.fight_type = datas[5]
    self:onInit()
    self:setContentSize(PveSweepSettlementCell.__size)
end

