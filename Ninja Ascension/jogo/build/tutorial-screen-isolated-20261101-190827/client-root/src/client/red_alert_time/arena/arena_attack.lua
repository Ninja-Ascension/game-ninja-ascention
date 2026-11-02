--------------------------------------------------------------------------------------------------------------
--  说明：竞技场挑战界面
--------------------------------------------------------------------------------------------------------------
ArenaAttack = class("ArenaAttackClass", Window)

--打开界面
local arena_attack_open_terminal = {
	_name = "arena_attack_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("ArenaAttackClass") == nil then
    		fwin:open(ArenaAttack:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local arena_attack_close_terminal = {
	_name = "arena_attack_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ArenaAttackClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(arena_attack_open_terminal)
state_machine.add(arena_attack_close_terminal)
state_machine.init()

function ArenaAttack:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
	self._info = nil
    -- npc id
    self._npc_id = 0
    -- 场景id
    self._scene_id = 0

    app.load("client.red_alert_time.cells.formation.formation_tank_head_cell")
    app.load("client.red_alert_time.cells.formation.formation_leader_head_cell")
    local function init_arena_attack_terminal()
        local arena_attack_show_terminal = {
            _name = "arena_attack_show",
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

        local arena_attack_hide_terminal = {
            _name = "arena_attack_hide",
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
		
		local arena_attack_attack_go_terminal = {
            _name = "arena_attack_attack_go",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local isHaveSetFormation = false
                local formation_tabs = zstring.split(_ED.arena_info.arena_formation, "|")
                for k, v in pairs(formation_tabs) do
                    local info_tabs = zstring.split(v, ",")
                    if tonumber(info_tabs[1]) > 0 then
                        isHaveSetFormation = true
                        break
                    end
                end
                if isHaveSetFormation == false then
                    TipDlg.drawTextDailog(formation_type_string[14])
                    return
                end

                local old_cell = instance._info
				local old_rand = _ED.arena_info.rank
                _ED.arena_last_rank = tonumber(_ED.arena_info.rank)
				local function requestArenaFightDatasCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        fwin:addService({
                            callback = function ( params )
                                state_machine.unlock("adventure_mine_request_battle_field_init")
                            end,
                            delay = 0.3,
                            params = nil
                        })
						if _ED._battle_sweep == 1 then
						else
							if tonumber(_ED.arena_info.rank) < tonumber(old_rand) then
								state_machine.excute("arena_dearon_tab_rank_change_update", 0, old_cell)
							end

							_ED.init_environment_fight_complete = true
							
							state_machine.excute("formation_window_close", 0, 0)
							state_machine.excute("fight_window_open", 0, 0)
							state_machine.excute("arena_attack_close", 0, 0)
						end	
                    else
                        state_machine.unlock("adventure_mine_request_battle_field_init")
					end
					state_machine.excute("arena_dearon_tab_update", 0, 0)
                    state_machine.excute("arena_reward_integral_tab_update_draw", 0, "")
				end
				
				local scene_npc_tab = dms.string(dms["arena_config"],11,arena_config.param)
                scene_npc_tab = zstring.split(scene_npc_tab,",")
                local scene_id = scene_npc_tab[1]
                local npc_id = scene_npc_tab[2]
                _ED._current_scene_id = scene_id
                _ED._scene_npc_id = npc_id
                _ED._battle_init_type = 11
				state_machine.excute("adventure_mine_request_battle_field_init", 0, {_ED._battle_init_type, _ED._current_scene_id, _ED._scene_npc_id, 0, 
				instance._info.user_id.."\r\n"..instance._info.user_rank, 0, 0, requestArenaFightDatasCallback})     
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(arena_attack_show_terminal)
        state_machine.add(arena_attack_hide_terminal)
        state_machine.add(arena_attack_attack_go_terminal)
        state_machine.init()
    end
    
    init_arena_attack_terminal()
end

function ArenaAttack:updateDraw()
    local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Button_pve_sweep"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Button_attack"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Text_all_star_prompt"):setVisible(false)
	
	
	ccui.Helper:seekWidgetByName(root, "Text_arena_attack_p"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Button_arena_attack"):setVisible(true)
	
	-- print(self._info._info.ship_moulds)
	local shipData = zstring.split(self._info.ship_moulds, "|")
	local ship_number = 0
	for i = 1, #shipData do
		local infos = zstring.split(shipData[i], ",")
		if tonumber(infos[3]) > 0 then
			ship_number = ship_number + tonumber(infos[3])
		end
	end
	
    -- npc名字
    local Text_npc_name = ccui.Helper:seekWidgetByName(root, "Text_npc_name")
    -- local npc_name = dms.string(dms["npc"], self._npc_id, npc.npc_name)
    Text_npc_name:setString(arena_tip_text[12])
	--部队信息
	local Text_enemy_formtion = ccui.Helper:seekWidgetByName(root, "Text_enemy_formtion")
	Text_enemy_formtion:removeAllChildren(true)

    local enemyFontSize = Text_enemy_formtion:getFontSize()

	local _richText_1 = ccui.RichText:create()
	_richText_1:ignoreContentAdaptWithSize(false) 
	local colors = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
	local color_2 = cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3])
	local re1 = ccui.RichElementText:create(1, colors,255, string.format(arena_tip_text[13],exChangeNumToString(self._info.user_fight)), config_res.font.font_name,enemyFontSize)
	_richText_1:pushBackElement(re1)  
	_richText_1:setPosition(cc.p(Text_enemy_formtion:getContentSize().width/2,Text_enemy_formtion:getContentSize().height/2+6))
    _richText_1:setContentSize(cc.size(Text_enemy_formtion:getContentSize().width,enemyFontSize))
    Text_enemy_formtion:addChild(_richText_1)
	
	local _richText_2 = ccui.RichText:create()
	_richText_2:ignoreContentAdaptWithSize(false) 
	local re2_1 = ccui.RichElementText:create(1, colors,255, string.format(arena_tip_text[14],exChangeNumToString(ship_number)), config_res.font.font_name,enemyFontSize)
	_richText_2:pushBackElement(re2_1)  
	_richText_2:setPosition(cc.p(Text_enemy_formtion:getContentSize().width/2,Text_enemy_formtion:getContentSize().height/2-16))
    _richText_2:setContentSize(cc.size(Text_enemy_formtion:getContentSize().width,enemyFontSize))
    Text_enemy_formtion:addChild(_richText_2)


    -- 获得奖励
    local get_reward = zstring.split(dms.string(dms["arena_config"], 14, arena_config.param), ",")
    local Text_get_reward = ccui.Helper:seekWidgetByName(root,"Text_get_reward")

    local rewardFontSize = Text_get_reward:getFontSize()

	local _richText_3 = ccui.RichText:create()
	_richText_3:ignoreContentAdaptWithSize(false) 
	
	local re3_1 = ccui.RichElementText:create(1, colors,255, arena_tip_text[15], config_res.font.font_name,rewardFontSize)
	_richText_3:pushBackElement(re3_1)  
	--临时的0
	local re3_2 = ccui.RichElementText:create(1, color_2,255, string.format(arena_tip_text[16],get_reward[1]), config_res.font.font_name,rewardFontSize)
	_richText_3:pushBackElement(re3_2)  
	_richText_3:setPosition(cc.p(Text_get_reward:getContentSize().width/2,Text_get_reward:getContentSize().height/2+6))
    _richText_3:setContentSize(cc.size(Text_get_reward:getContentSize().width,rewardFontSize))
    Text_get_reward:addChild(_richText_3)
	
	local _richText_4 = ccui.RichText:create()
	_richText_4:ignoreContentAdaptWithSize(false) 
	local rank = tonumber(_ED.arena_info.rank) - tonumber(self._info.user_rank)
	if rank <= 0 then
		rank = 0
	end
	local re4_1 = ccui.RichElementText:create(1, colors,255, arena_tip_text[17], config_res.font.font_name,rewardFontSize)
	_richText_4:pushBackElement(re4_1)  
	local re4_2 = ccui.RichElementText:create(1, color_2,255, "+"..rank, config_res.font.font_name,rewardFontSize)
	_richText_4:pushBackElement(re4_2)  
	_richText_4:setPosition(cc.p(Text_get_reward:getContentSize().width/2,Text_get_reward:getContentSize().height/2-16))
    _richText_4:setContentSize(cc.size(Text_get_reward:getContentSize().width,rewardFontSize))
    Text_get_reward:addChild(_richText_4)
	

    -- 有几率获得
	local Text_get_t = ccui.Helper:seekWidgetByName(root,"Text_get_t")
	Text_get_t:setString(arena_tip_text[18])
    local Text_get_n = ccui.Helper:seekWidgetByName(root,"Text_get_n")
    Text_get_n:removeAllChildren(true)
    local reward_info = zstring.split(dms.string(dms["arena_config"], 18, arena_config.param), ",")
    local scene_reward_id = tonumber(reward_info[1])
    local prop_info = zstring.split(dms.string(dms["scene_reward"], scene_reward_id, scene_reward.reward_items), "|")
    local info = zstring.split(prop_info[1], ",")
    local prop_id = tonumber(info[1])
    local prop_name = dms.string(dms["prop_mould"], prop_id, prop_mould.prop_name)
    local quality = dms.int(dms["prop_mould"], prop_id, prop_mould.prop_quality)
    Text_get_n:setString(prop_name)
    Text_get_n:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
	Text_get_n:setPositionX(Text_get_t:getPositionX() + Text_get_t:getContentSize().width)
    Text_get_n:setPositionY(Text_get_t:getPositionY())
    Text_get_n:setContentSize(cc.size(Text_get_n:getContentSize().width,Text_get_t:getContentSize().height))

    for i=1,6 do
        local Panel_form_point = ccui.Helper:seekWidgetByName(root,"Panel_form_point_"..i)
        local Panel_formation_tank = ccui.Helper:seekWidgetByName(root, "Panel_formation_tank_"..i)
        Panel_formation_tank:removeAllChildren(true)
        local Panel_formation_leader = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_"..i)
        Panel_formation_leader:removeAllChildren(true)
		local infos = zstring.split(shipData[i], ",")
		local ship = {}
		ship.ship_template_id = infos[2]
        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, ship, infos[3],3})
        Panel_formation_tank:addChild(cell)

		local leader_head = nil
		if tonumber(infos[6]) > 0 then
			leader_head = {}
			leader_head.captain_name = dms.string(dms["ship_mould"], tonumber(infos[7]), ship_mould.captain_name)
			leader_head.ship_type = dms.string(dms["ship_mould"], tonumber(infos[7]), ship_mould.ship_type)
			leader_head.ship_template_id = infos[7]
		end
        local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i,leader_head,1, 2})
        Panel_formation_leader:addChild(cell)
    end
end

--初始化
function ArenaAttack:onInit()
    local csbItem = csb.createNode(config_csb.pve.pve_attack_winodw)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_attack_close"), nil, 
    {
        terminal_name = "arena_attack_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "arena_attack_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arena_attack"), nil, 
    {
        terminal_name = "arena_attack_attack_go",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,1)

    self:updateDraw()
end

function ArenaAttack:onEnterTransitionFinish()

end

function ArenaAttack:init(params)
    self._info = params
	self:onInit()
    return self
end

function ArenaAttack:onExit()
    state_machine.remove("arena_attack_show")
    state_machine.remove("arena_attack_hide")
    state_machine.remove("arena_attack_attack_go")
end