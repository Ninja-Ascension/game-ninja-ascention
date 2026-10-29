--------------------------------------------------------------------------------------------------------------
--  说明：副本挑战界面
--------------------------------------------------------------------------------------------------------------
PveAttack = class("PveAttackClass", Window)

--打开界面
local pve_attack_open_terminal = {
	_name = "pve_attack_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("PveAttackClass") == nil then
    		fwin:open(PveAttack:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local pve_attack_close_terminal = {
	_name = "pve_attack_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PveAttackClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(pve_attack_open_terminal)
state_machine.add(pve_attack_close_terminal)
state_machine.init()

function PveAttack:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    -- npc id
    self._npc_id = 0
    -- 场景id
    self._scene_id = 0

    self._scene_type = 0

    app.load("client.red_alert_time.cells.formation.formation_tank_head_cell")
    app.load("client.red_alert_time.cells.formation.formation_leader_head_cell")
    app.load("client.red_alert_time.battle.battle_enum")
    app.load("client.red_alert_time.pve.PveRaid")
    app.load("client.red_alert_time.player.PlayerEnergyAdd")
    local function init_pve_attack_terminal()
        local pve_attack_show_terminal = {
            _name = "pve_attack_show",
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

        local pve_attack_hide_terminal = {
            _name = "pve_attack_hide",
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

        local pve_attack_begin_fight_terminal = {
            _name = "pve_attack_begin_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                _ED._battle_init_type = instance._scene_type
                _ED._current_scene_id = instance._scene_id
                _ED._scene_npc_id = instance._npc_id
                _ED._npc_difficulty_index = "1"
                state_machine.excute("formation_window_open",0,{_datas = {form_type = 3}})
                state_machine.excute("pve_attack_close", 0, 0)

                -- if missionIsOver() == true then
                --     if tonumber("" .. _ED._current_scene_id) == 1 
                --         -- and zstring.tonumber(_ED.npc_state[tonumber("".._ED._scene_npc_id)]) == 0 
                --         then
                --         state_machine.excute("formation_defend_max_fighting",0,0)
                --     end
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_attack_sweep_terminal = {
            _name = "pve_attack_sweep",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local star = 0 
                if zstring.tonumber(_ED.npc_state[tonumber(""..instance._npc_id)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..instance._npc_id)]) and zstring.tonumber(_ED.npc_state[tonumber(""..instance._npc_id)]) ~= 0 then
                    star = tonumber(_ED.npc_max_state[tonumber(""..instance._npc_id)])
                else
                    star = tonumber(_ED.npc_state[tonumber(""..instance._npc_id)])
                end
                if star < 3 then
                    TipDlg.drawTextDailog(formation_type_string[41])
                    return
                end
				if tonumber(_ED.vip_grade) < 4 then
                    TipDlg.drawTextDailog(formation_type_string[40])
					return
				end
                if instance._scene_type == battle_enum._fight_type._fight_type_15 then
                    _ED._battle_init_type = battle_enum._fight_type._fight_type_15
                else
                    if tonumber(_ED.user_info.user_food) <= 0 then
                        state_machine.excute("player_energy_add_open", 0, "")
                        return
                    end
                    _ED._battle_init_type = battle_enum._fight_type._fight_type_0
                end
				--进入扫荡界面
				-- _ED._battle_init_type = battle_enum._fight_type._fight_type_0
                _ED._current_scene_id = instance._scene_id
                _ED._scene_npc_id = instance._npc_id
                _ED._npc_difficulty_index = "1"
                state_machine.excute("formation_window_open",0,{_datas = {form_type = 3, pve_operating_type = -1}})
                state_machine.excute("pve_attack_close", 0, 0)
				-- state_machine.excute("pve_raid_open",0,{_datas = {scene_id=instance._scene_id, npc_id = instance._npc_id}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面
        local pve_attack_update_draw_terminal = {
            _name = "pve_attack_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(pve_attack_show_terminal)
        state_machine.add(pve_attack_hide_terminal)
        state_machine.add(pve_attack_begin_fight_terminal)
        state_machine.add(pve_attack_sweep_terminal)
        state_machine.add(pve_attack_update_draw_terminal)
        state_machine.init()
    end
    
    init_pve_attack_terminal()
end

function PveAttack:updateDraw()
    local root = self.roots[1]

    -- npc名字
    local Text_npc_name = ccui.Helper:seekWidgetByName(root, "Text_npc_name")
    local npc_name = dms.string(dms["npc"], self._npc_id, npc.npc_name)
    Text_npc_name:setString(npc_name)

    -- 推荐战力
    local environment_formation1 = dms.string(dms["npc"], self._npc_id, npc.environment_formation1)
    local formation_info = dms.element(dms["environment_formation"], self._npc_id)
    local Text_enemy_formtion = ccui.Helper:seekWidgetByName(root,"Text_enemy_formtion")
    local combat_force = dms.atoi(formation_info, environment_formation.combat_force)   
    Text_enemy_formtion:removeAllChildren(true)
    Text_enemy_formtion:setString("")

    local enemyFontSize = Text_enemy_formtion:getFontSize()

    local _richText_1 = ccui.RichText:create()
    _richText_1:ignoreContentAdaptWithSize(false) 
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[16], "fonts/simhei.ttf",enemyFontSize)
    _richText_1:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]),255, exChangeNumToString(combat_force), "fonts/simhei.ttf",enemyFontSize)
    _richText_1:pushBackElement(re2)
    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, ")", "fonts/simhei.ttf",enemyFontSize)
    _richText_1:pushBackElement(re3)
    _richText_1:setPosition(cc.p(Text_enemy_formtion:getContentSize().width/2,Text_enemy_formtion:getContentSize().height/2))
    _richText_1:setContentSize(cc.size(Text_enemy_formtion:getContentSize().width,enemyFontSize))

    -- 获得奖励
    local Text_get_reward = ccui.Helper:seekWidgetByName(root,"Text_get_reward")
    Text_get_reward:removeAllChildren(true)

    local rewardFontSize = Text_get_reward:getFontSize()

    local on_hook_reward = dms.int(dms["npc"], self._npc_id, npc.on_hook_reward)
    local wait_time = dms.string(dms["npc"], self._npc_id, npc.wait_time)
    local _richText_2 = ccui.RichText:create()
    _richText_2:ignoreContentAdaptWithSize(false) 
 --    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[17], "fonts/simhei.ttf",22)
 --    _richText_2:pushBackElement(re1)  
 --    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, wait_time, "fonts/simhei.ttf",22)
 --    _richText_2:pushBackElement(re2)
 --    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, " "..red_alert_time_str[18], "fonts/simhei.ttf",22)
 --    _richText_2:pushBackElement(re3)
 --    local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, exChangeNumToString(math.floor(on_hook_reward*((100+_ED.battle_exp_factor)/100))), "fonts/simhei.ttf",22)
 --    _richText_2:pushBackElement(re4)
	-- local playTheQueue = dms.element(dms["base_consume"], 90)
	-- local nCount = dms.atoi(playTheQueue, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
	-- local re5 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, ""..string.format(red_alert_time_str[99],_ED.vip_grade, nCount)..red_alert_time_str[100], "fonts/simhei.ttf",22)
	-- if nCount ~= 0 then
	-- 	 _richText_2:pushBackElement(re5)
	-- end
 --    _richText_2:setPosition(cc.p(Text_get_reward:getContentSize().width/2,Text_get_reward:getContentSize().height/2))
 --    _richText_2:setContentSize(cc.size(Text_get_reward:getContentSize().width,22))

    -- 有几率获得
    local Text_get_t = ccui.Helper:seekWidgetByName(root,"Text_get_t")
    local Text_get_n = ccui.Helper:seekWidgetByName(root,"Text_get_n")
    Text_get_t:setVisible(false)
    Text_get_n:removeAllChildren(true)
    Text_get_n:setPositionX(Text_get_t:getPositionX())
    local nFontSize = Text_get_n:getFontSize()

    local _richText_3 = ccui.RichText:create()
    _richText_3:ignoreContentAdaptWithSize(false) 
    local re1 =ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[284], "fonts/simhei.ttf",nFontSize)
    _richText_3:pushBackElement(re1)  
    local drop_library = dms.int(dms["npc"], self._npc_id, npc.drop_library)
    local add_numbers = {}
    if drop_library > 0 then
        reward_items = dms.string(dms["scene_reward"], drop_library, scene_reward.reward_items)
        reward_items = zstring.split(reward_items,"|")
        for i,reward in ipairs(reward_items) do
            local reward_tab = zstring.split(reward,",")
            local prop_item = tonumber(reward_tab[1])
            local prop_type = tonumber(reward_tab[2])
            local prop_quality = dms.int(dms["prop_mould"], prop_item, prop_mould.prop_quality)
            local prop_name = dms.string(dms["prop_mould"], prop_item, prop_mould.prop_name)
            if prop_type == 7 then
                prop_quality = dms.int(dms["equipment_mould"], prop_item, equipment_mould.grow_level)
                prop_name = dms.string(dms["equipment_mould"], prop_item, equipment_mould.equipment_name)
            end
            local data = {prop_name,prop_quality}
            table.insert(add_numbers,data)
        end
        for i,v in pairs(add_numbers) do
            local re1 = nil 
            local re2 = nil
            re1 =ccui.RichElementText:create(1, cc.c3b(color_Type[v[2]+1][1],color_Type[v[2]+1][2],color_Type[v[2]+1][3]),255, v[1], "fonts/simhei.ttf",nFontSize)
            _richText_3:pushBackElement(re1)  
            if i == #add_numbers then
                re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,"","fonts/simhei.ttf",nFontSize)
                _richText_3:pushBackElement(re2)
            else
                re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,"、","fonts/simhei.ttf",nFontSize)
                _richText_3:pushBackElement(re2)
            end
        end
        _richText_3:setContentSize(cc.size(Text_get_n:getContentSize().width + Text_get_t:getContentSize().width,nFontSize))
        _richText_3:setPosition(cc.p(_richText_3:getContentSize().width/2,_richText_3:getContentSize().height/2))
        -- Text_get_n:addChild(_richText_3)
    end

    local seat_one = dms.atoi(formation_info, environment_formation.seat_one)
    local seat_two = dms.atoi(formation_info, environment_formation.seat_two)
    local seat_three = dms.atoi(formation_info, environment_formation.seat_three)
    local seat_four = dms.atoi(formation_info, environment_formation.seat_four)
    local seat_five = dms.atoi(formation_info, environment_formation.seat_five)
    local seat_six = dms.atoi(formation_info, environment_formation.seat_six)
    local seat_info = {seat_one,seat_two,seat_three,seat_four,seat_five,seat_six}

    local seat_one_nums = dms.int(dms["environment_ship"], seat_one, environment_ship.level)
    local seat_two_nums = dms.int(dms["environment_ship"], seat_two, environment_ship.level)
    local seat_three_nums = dms.int(dms["environment_ship"], seat_three, environment_ship.level)
    local seat_four_nums = dms.int(dms["environment_ship"], seat_four, environment_ship.level)
    local seat_five_nums = dms.int(dms["environment_ship"], seat_five, environment_ship.level)
    local seat_six_nums = dms.int(dms["environment_ship"], seat_six, environment_ship.level)
    local seat_nums_info = {seat_one_nums,seat_two_nums,seat_three_nums,seat_four_nums,seat_five_nums,seat_six_nums}
    local have_num = 0
    for i=1,6 do
        local Panel_form_point = ccui.Helper:seekWidgetByName(root,"Panel_form_point_"..i)
        local Panel_formation_tank = ccui.Helper:seekWidgetByName(root, "Panel_formation_tank_"..i)
        Panel_formation_tank:removeAllChildren(true)
        local Panel_formation_leader = ccui.Helper:seekWidgetByName(root, "Panel_formation_leader_"..i)
        Panel_formation_leader:removeAllChildren(true)
        have_num = have_num + zstring.tonumber(seat_nums_info[i])
        local cell = state_machine.excute("formation_tank_head_cell_create_cell", 0, {i, seat_info[i], seat_nums_info[i],2})
        Panel_formation_tank:addChild(cell)

        local cell = state_machine.excute("formation_leader_head_cell_create_cell", 0, {i,nil,3, 2})
        Panel_formation_leader:addChild(cell)
    end
    local Button_pve_sweep = ccui.Helper:seekWidgetByName(root,"Button_pve_sweep")
    local Text_all_star_prompt = ccui.Helper:seekWidgetByName(root,"Text_all_star_prompt")
    local Button_attack = ccui.Helper:seekWidgetByName(root,"Button_attack")
    local Panel_pve_attack_box = ccui.Helper:seekWidgetByName(root,"Panel_pve_attack_box")

    if self._scene_type == battle_enum._fight_type._fight_type_1 then
        if verifySupportLanguage(_lua_release_language_en) == true then
            Text_get_t:setVisible(false)
        else
            Text_get_t:setVisible(false)
            Text_get_t:setPositionY(284)
            Text_get_n:setPositionY(284)
        end
        Button_pve_sweep:setVisible(false)
        Text_all_star_prompt:setVisible(false)
        Button_attack:setPositionX(Panel_pve_attack_box:getContentSize().width/2)
        Text_enemy_formtion:setString(tipString_legion_info[43]..have_num)
        local datas = dms.string(dms["pve_scene"], self._scene_id, pve_scene.brief_introduction)
        local texts_info = zstring.split(datas, "/r/n")
        local index = 0
        for i=1,#texts_info do
            local _richText2 = ccui.RichText:create()
            _richText2:ignoreContentAdaptWithSize(false)
            _richText2:setContentSize(cc.size(Text_get_reward:getContentSize().width, 0))
            _richText2:setAnchorPoint(cc.p(0, 0))
            local char_str = texts_info[i]
            local rt, count, text = draw.richTextCollectionMethod(_richText2, 
            char_str, 
            cc.c3b(189, 206, 224),
            cc.c3b(189, 206, 224),
            0, 
            0, 
            config_res.font.font_name, 
            rewardFontSize,
            chat_rich_text_color)
            _richText2:formatTextExt()
            local rsize = _richText2:getContentSize()
            _richText2:setPositionY(Text_get_reward:getContentSize().height-index)
            -- _richText2:setPositionX(400 - 0.5 * fontSize)
            Text_get_reward:addChild(_richText2)
            index = index + rsize.height
        end
    elseif self._scene_type == battle_enum._fight_type._fight_type_15 then
        if verifySupportLanguage(_lua_release_language_en) == true then
            Text_get_t:setVisible(false)
        else
            Text_get_t:setVisible(false)
            Text_get_t:setPositionY(284)
            Text_get_n:setPositionY(284)
        end
        Text_all_star_prompt:setVisible(true)
        Text_enemy_formtion:setString(tipString_legion_info[43]..have_num)
        local datas = dms.string(dms["pve_scene"], self._scene_id, pve_scene.brief_introduction)
        local texts_info = zstring.split(datas, "/r/n")
        local index = 0
        for i=1,#texts_info do
            local _richText2 = ccui.RichText:create()
            _richText2:ignoreContentAdaptWithSize(false)
            _richText2:setContentSize(cc.size(Text_get_reward:getContentSize().width, 0))
            _richText2:setAnchorPoint(cc.p(0, 0))
            local char_str = texts_info[i]
            local rt, count, text = draw.richTextCollectionMethod(_richText2, 
            char_str, 
            cc.c3b(189, 206, 224),
            cc.c3b(189, 206, 224),
            0, 
            0, 
            config_res.font.font_name, 
            rewardFontSize,
            chat_rich_text_color)
            _richText2:formatTextExt()
            local rsize = _richText2:getContentSize()
            _richText2:setPositionY(Text_get_reward:getContentSize().height-index)
            -- _richText2:setPositionX(400 - 0.5 * fontSize)
            Text_get_reward:addChild(_richText2)
            index = index + rsize.height
        end
    else
        local wdatas = zstring.split(dms.string(dms["world_config"], 17 , world_config.param), "|")
        local additionOne = zstring.split(wdatas[1],",")
        local additionTwo = zstring.split(wdatas[2],",")
        local m_addition = 0
        if tonumber(_ED.user_info.user_grade) < zstring.tonumber(_ED.world_level) then
            if zstring.tonumber(_ED.world_level) - tonumber(_ED.user_info.user_grade) >= tonumber(math.max(additionOne[1],additionTwo[1])) then
                m_addition = math.max(additionOne[2],additionTwo[2])*100
            else
                m_addition = math.min(additionOne[2],additionTwo[2])*100
            end
        end

        -- 全名狂欢经验加成
        local activity_add_percent = 0
        if _ED.activity_info ~= nil and _ED.activity_info["84"] ~= nil then
            local info = zstring.split(_ED.activity_info["84"].activity_add_state, ",")
            activity_add_percent = activity_add_percent + tonumber(info[4])
        end

        -- 狂欢时刻经验加成
        if _ED.activity_info ~= nil and _ED.activity_info["130"] ~= nil then
            local info = zstring.split(_ED.activity_info["130"].activity_add_state, "|")
            activity_add_percent = activity_add_percent + tonumber(info[3])
        end

        Text_enemy_formtion:addChild(_richText_1)
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[17], "fonts/simhei.ttf",rewardFontSize)
        _richText_2:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, wait_time, "fonts/simhei.ttf",rewardFontSize)
        _richText_2:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, " "..red_alert_time_str[18], "fonts/simhei.ttf",rewardFontSize)
        _richText_2:pushBackElement(re3)
        local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, exChangeNumToString(math.floor(on_hook_reward*((100+_ED.battle_exp_factor)/100 + activity_add_percent))), "fonts/simhei.ttf",rewardFontSize)
        _richText_2:pushBackElement(re4)
        local playTheQueue = dms.element(dms["base_consume"], 90)
        local nCount = dms.atoi(playTheQueue, base_consume.vip_0_value + zstring.tonumber(_ED.vip_grade))
        local re5 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, ""..string.format(red_alert_time_str[99],_ED.vip_grade, nCount)..red_alert_time_str[100], "fonts/simhei.ttf",rewardFontSize)
        if nCount ~= 0 then
             _richText_2:pushBackElement(re5)
        end
        _richText_2:setPosition(cc.p(Text_get_reward:getContentSize().width/2,Text_get_reward:getContentSize().height/2))
        _richText_2:setContentSize(cc.size(Text_get_reward:getContentSize().width,rewardFontSize))
        Text_get_reward:addChild(_richText_2)
        Text_get_n:addChild(_richText_3)
    end
end

--初始化
function PveAttack:onInit()
    local csbItem = csb.createNode(config_csb.pve.pve_attack_winodw)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_attack_close"), nil, 
    {
        terminal_name = "pve_attack_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "pve_attack_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_sweep"), nil, 
    {
        terminal_name = "pve_attack_sweep",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_attack"), nil, 
    {
        terminal_name = "pve_attack_begin_fight",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    -- for i=1, 6 do
    --     fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_formation_leader"..i), nil, 
    --     {
    --         -- terminal_name = "",
    --         terminal_state = 0,
    --         touch_scale = true,
    --         touch_scale_xy = 0.95,
    --         touch_black = true,
    --         index = 1,
    --     },
    --     nil,3)

    --     fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_formation_tank_"..i), nil, 
    --     {
    --         -- terminal_name = "",
    --         terminal_state = 0,
    --         touch_scale = true,
    --         touch_scale_xy = 0.95,
    --         touch_black = true,
    --         index = 1,
    --     },
    --     nil,3)
    -- end

    self:updateDraw()
end

function PveAttack:onEnterTransitionFinish()

end

function PveAttack:init(params)
    self._npc_id = params[1]
    self._scene_id = params[2]
    self._scene_type = dms.int(dms["pve_scene"], self._scene_id, pve_scene.scene_type) 
	self:onInit()
    return self
end

function PveAttack:onExit()
    state_machine.remove("pve_attack_show")
    state_machine.remove("pve_attack_hide")
    state_machine.remove("pve_attack_begin_fight")
    state_machine.remove("pve_attack_sweep")
    state_machine.remove("pve_attack_update_draw")
end