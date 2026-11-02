-----------------------------
--战地争霸的挑战列表的cell
-----------------------------
ArenaDearonCell = class("ArenaDearonCellClass", Window)
ArenaDearonCell.__size = nil

local arena_dearon_cell_terminal = {
    _name = "arena_dearon_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArenaDearonCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_dearon_cell_terminal)
state_machine.init()

function ArenaDearonCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._info = nil

    self._is_cd_time = false
	
	app.load("client.red_alert_time.cells.worldMap.player_head_icon")
	app.load("client.red_alert_time.arena.arena_attack")
	
	-- app.load("client.red_alert_time.cells.worldMap.player_head_icon")
	
 	local function init_arena_dearon_cell_terminal()
	
		local arena_dearon_cell_attack_terminal = {
            _name = "arena_dearon_cell_attack",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --计算火线支援活动加层
                local activity_add = 0
                if _ED.activity_info["91"] ~= nil then
                    local timesData = zstring.split(_ED.activity_info["91"].activity_add_state, ",")
                    local m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
                    if m_times > 0 then
                        activity_add = timesData[5]
                    end
                end
                local curr_attck_times = activity_add + tonumber(_ED.arena_info.leave_attack_count)
                if curr_attck_times <= 0 then
                    local max_count = dms.int(dms["base_consume"], 92, base_consume.vip_0_value + tonumber(_ED.vip_grade))
                    local leave_buy_count = max_count - zstring.tonumber(_ED.arena_info.buy_attack_count)
                    if leave_buy_count > 0 then
                        state_machine.excute("arena_dearon_number_of_purchases_open", 0, nil)
                    else
                        TipDlg.drawTextDailog(red_alert_time_str[214])
                    end
                    return
                end
				local cell = params._datas.cells
                if cell._is_cd_time == false then
                    if __lua_project_id == __lua_project_pacific_rim then
                        state_machine.excute("formation_defend_attack_open", 0, {1})
                        state_machine.excute("formation_defend_attack_add_arena_formation_info", 0, {cell._info})
                    else
                        state_machine.excute("arena_attack_open", 0, cell._info)
                    end
                else   
                    local leave_time = _ED.arena_info.fight_cooling_time - (os.time() + _ED.time_add_or_sub)
                    local per_min_cost = dms.int(dms["arena_config"], 19, arena_config.param)
                    local cost = math.ceil(leave_time / 60) * per_min_cost
                    local tip = ConfirmTip:new()
                    tip:init(cell, cell.clearCdTime, string.format(red_alert_time_str[192], cost))
                    fwin:open(tip,fwin._windows) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(arena_dearon_cell_attack_terminal)
        state_machine.init()
    end
	init_arena_dearon_cell_terminal()        	
end

function ArenaDearonCell:clearCdTime( sure_number )
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("arena_dearon_tab_update", 0, "")
        end
    end
    if sure_number == 0 then
        protocol_command.arena_launch_clear_cd.param_list = "0"
        NetworkManager:register(protocol_command.arena_launch_clear_cd.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end


function ArenaDearonCell:onUpdateDraw()
	local root = self.roots[1]
	--头像
	local Panel_player_head = ccui.Helper:seekWidgetByName(root, "Panel_player_head")
	Panel_player_head:removeAllChildren(true)
	if self._info.user_head_id ~= nil or self._info.user_head_id ~= "" then
	-- debug.print_r(self._info)
		local cell = PlayerHeadIcon:createCell()
		local avatar_info = {}
		avatar_info.object = self._info.user_head_id
		avatar_info.vip = 1
		avatar_info._type = 0
		cell:init(avatar_info)
		Panel_player_head:addChild(cell)
	end

    local is_lucky_rank = false
    for k, v in pairs(_ED.arena_lucky_ranking) do
        if tonumber(v.this_period_lucky_rank) == tonumber(self._info.user_rank) then
            is_lucky_rank = true
            break
        end
    end
	
	--排名
	local Text_arena_rank_t = ccui.Helper:seekWidgetByName(root, "Text_arena_rank_t")
    if is_lucky_rank == false then
	   Text_arena_rank_t:setString(string.format(arena_tip_text[34], self._info.user_rank))
       Text_arena_rank_t:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    else
        Text_arena_rank_t:setString(string.format(arena_tip_text[35], self._info.user_rank))
        Text_arena_rank_t:setColor(cc.c3b(color_Type[4][1], color_Type[4][2], color_Type[4][3]))
    end
	
	--战力
	local Text_arena_fight_n = ccui.Helper:seekWidgetByName(root, "Text_arena_fight_n")
	Text_arena_fight_n:setString(exChangeNumToString(self._info.user_fight))
	
	--名称+等级
	local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
	Text_player_name:setString(self._info.user_name.."  "..string.format(red_alert_all_str[13], ""..self._info.user_level))

    local Button_battle_battlefield = ccui.Helper:seekWidgetByName(root, "Button_battle_battlefield")
    if self._is_cd_time == true then
        Button_battle_battlefield:setBright(false)
    else
        Button_battle_battlefield:setBright(true)
    end
end

function ArenaDearonCell:onEnterTransitionFinish()

end

function ArenaDearonCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.arena.arena_dearon_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if ArenaDearonCell.__size == nil then
		ArenaDearonCell.__size = root:getContentSize()
	end
	
	--挑战
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_battle_battlefield"), nil, 
    {
        terminal_name = "arena_dearon_cell_attack", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self,
    }, nil, 1)

	self:onUpdateDraw()
end

function ArenaDearonCell:onExit()
    local root = self.roots[1]
	_ED.play_head_port = nil
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.arena.arena_dearon_cell, root)
end

function ArenaDearonCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ArenaDearonCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.arena.arena_dearon_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function ArenaDearonCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_player_head = ccui.Helper:seekWidgetByName(root, "Panel_player_head")
    local Text_arena_rank_n = ccui.Helper:seekWidgetByName(root, "Text_arena_rank_n")
    local Text_arena_fight_n = ccui.Helper:seekWidgetByName(root, "Text_arena_fight_n")
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")

    if Panel_player_head ~= nil then
        Panel_player_head:removeAllChildren(true)
        Text_arena_rank_n:setString("")
        Text_arena_fight_n:setString("")
        Text_player_name:setString("")
    end
end

function ArenaDearonCell:init(params)
	self._info = params[1]
    self._index = params[2]
    self._is_cd_time = params[3]
	
    if self._index ~= nil and self._index <= 7 then
        self:onInit()
    end
	self:setContentSize(ArenaDearonCell.__size)
    return self
end

