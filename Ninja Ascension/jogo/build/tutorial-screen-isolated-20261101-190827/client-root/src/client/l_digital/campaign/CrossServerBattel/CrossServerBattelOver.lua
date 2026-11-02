-- ----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战结束界面
-------------------------------------------------------------------------------------------------------
CrossServerBattelOver = class("CrossServerBattelOverClass", Window)

local cross_server_battel_over_window_open_terminal = {
    _name = "cross_server_battel_over_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	
        local function responseCrossServerBattelInitCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                local close_type = zstring.tonumber(_ED.cross_server_battel_map_close_info.type)
                if close_type == 2 then
                    app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelBegin")
                    state_machine.excute("cross_server_battel_begin_window_open", 0, "")
                else
                    fwin:open(CrossServerBattelOver:new(), fwin._view)
                end
            end
        end
        NetworkManager:register(protocol_command.cross_mine_user_join_not_open.code, nil, nil, nil, nil, responseCrossServerBattelInitCallback, false, nil)
        
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local cross_server_battel_over_window_close_terminal = {
    _name = "cross_server_battel_over_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:close(fwin:find("CrossServerBattelOverClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(cross_server_battel_over_window_open_terminal)
state_machine.add(cross_server_battel_over_window_close_terminal)
state_machine.init()


function CrossServerBattelOver:ctor()
    self.super:ctor()
    self.roots = {}
	self._armature = nil

	-- load lua file
	app.load("client.l_digital.cells.campaign.CrossServerBattel.cross_service_rank_over_cell")
    -- Initialize Arena page state machine.
    local function init_cross_server_battel_over_terminal()
		local cross_server_battel_show_formation_terminal = {
		    _name = "cross_server_battel_show_formation",
		    _init = function (terminal) 
		        app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelShowBestFormation")
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params)
                local index = params._datas._index
                local user_info = _ED.cross_server_battel_map_close_info.topRank[(index - 1) .. ""].userInfo
                if user_info then
                    state_machine.excute("cross_server_battel_show_best_formation_open", 0, user_info)
                else
                    return
                end
                return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		state_machine.add(cross_server_battel_show_formation_terminal)
		state_machine.init()
	end

	init_cross_server_battel_over_terminal()
end

function CrossServerBattelOver:onUpdate(dt)
end

function CrossServerBattelOver:formatTimeString(_time)  --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%01d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function CrossServerBattelOver:onUpdateDraw()
    local root = self.roots[1]
    local server_ranks = _ED.cross_server_battel_map_close_info.CrossMineServerInfo
    local ListView_rank = ccui.Helper:seekWidgetByName(root, "ListView_rank") 
    if ListView_rank then 
        ListView_rank:removeAllItems()
        if server_ranks then 
            for i, v in ipairs(server_ranks) do
                local cell = state_machine.excute("sm_cross_service_rank_over_cell_create",0,{rank_idx = i, rank_info = v})
                ListView_rank:addChild(cell)
            end
            ListView_rank:jumpToTop()
            ListView_rank:requestRefreshView()
        end
    else
        for i=1, 4 do
            local panel_rank = ccui.Helper:seekWidgetByName(root, "Panel_cross_sver_rank_" .. i)
            local Text_cross_sver_name = ccui.Helper:seekWidgetByName(root, "Text_cross_sver_name_" .. i)
            local Text_sver_rank_integral = ccui.Helper:seekWidgetByName(root, "Text_sver_rank_integral_n_" .. i)
            local Text_sver_rank_reword = ccui.Helper:seekWidgetByName(root, "Text_sver_rank_reward_n_" .. i)

            if server_ranks and server_ranks[i] then
                local server_name = _ED.cross_server_battel_all_servers[server_ranks[i].serverId]
                local getStr1 = string.match(server_name, "-")
                local getStr2 = string.match(server_name, "_")
                if getStr1 and getStr1 ~= "" then
                    server_name = zstring.split(server_name, "-")[1]
                elseif getStr2 and getStr2 ~= "" then
                    server_name = zstring.split(server_name, "_")[1]
                end
                Text_cross_sver_name:setString(server_name)
                Text_sver_rank_integral:setString(server_ranks[i].totalScore)
                -- Text_sver_rank_reword:setString(server_ranks[i].reWard)
                if tonumber(server_ranks[i].reWard)> 1000000 then
                    Text_sver_rank_reword:setString(math.floor(tonumber(server_ranks[i].reWard) / 1000) .. string_equiprety_name[40])
                else
                    Text_sver_rank_reword:setString(server_ranks[i].reWard)
                end
                panel_rank:setVisible(true)
            else
                panel_rank:setVisible(false)
            end
        end
    end

    --全服前三
    local personal_ranks = _ED.cross_server_battel_map_close_info.topRank
    for i=0,2 do
        local Text_cross_player_name = ccui.Helper:seekWidgetByName(root, "Text_cross_player_name_" .. (i+1))
        local Text_cross_player_severs = ccui.Helper:seekWidgetByName(root, "Text_cross_player_severs_" .. (i+1))
        local Panel_cross_head = ccui.Helper:seekWidgetByName(root, "Panel_cross_head_" .. (i+1))
        local personal_rank = personal_ranks[i .. ""]
        if personal_rank then
            Text_cross_player_name:setString(personal_rank.userInfo.nickName)
            Text_cross_player_severs:setString(_ED.cross_server_battel_all_servers[personal_rank.userInfo.serverId])
            self:runAction(cc.Sequence:create({cc.DelayTime:create(i*0.1), cc.CallFunc:create(function ( sender ) 
                self:updateDrawHead(personal_rank.maxCombatShip, Panel_cross_head)
                end)}))
        else
            Text_cross_player_name:setString(tipStringInfo_cross_server_battel_tips[18])
            Text_cross_player_severs:setString(tipStringInfo_cross_server_battel_tips[18])
        end
    end
end

function CrossServerBattelOver:updateDrawHead(info, panel)
    local root = self.roots[1]
    function getUserShip( info )
        local ship_info = {}
        local infos = zstring.split(info, ":")
        ship_info.ship_template_id = infos[1]
        ship_info.ship_grade = infos[2]
        ship_info.evolution_status = infos[3]
        ship_info.StarRating = infos[4]
        ship_info.Order = infos[5]
        ship_info.hero_fight = infos[6]
        ship_info.speed = infos[7]
        ship_info.skin_id = infos[11]
        return ship_info
    end

    local ship = getUserShip(info)
    local Panel_head = panel
    local hero_fight = 0
    local ship_id = 0
    --进化形象
    local evo_image = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local ship_evo = zstring.split(ship.evolution_status, "|")
    local evo_mould_id = smGetSkinEvoIdChange(ship)
    if ship.skin_id and zstring.tonumber(ship.skin_id) ~= 0 then
        evo_mould_id = dms.int(dms["ship_skin_mould"], ship.skin_id, ship_skin_mould.ship_evo_id)
    end
    local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

    Panel_head:removeAllChildren(true)
    self._armature = nil
    -- draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), self.roleIconPanel, nil, nil, cc.p(0.5, 0))

    --画光圈
    local camp_preference = dms.int(dms["ship_mould"], tonumber(ship.ship_template_id), ship_mould.camp_preference)
    local animation_name = ""
    if camp_preference == 1 then            --攻击
        animation_name = "type_1"
    elseif camp_preference == 2 then        --防御
        animation_name = "type_2"
    elseif camp_preference == 3 then        --技能
        animation_name = "type_3"
    end
    local jsonFile = "sprite/spirte_type_di.json"
    local atlasFile = "sprite/spirte_type_di.atlas"
    local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, animation_name, true, nil)
    animation2:setPosition(cc.p(Panel_head:getContentSize().width/2,0))
    Panel_head:addChild(animation2)

    app.load("client.battle.fight.FightEnum")
    if self._armature == nil then
        self._armature = sp.spine_sprite(Panel_head, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            self._armature:setScaleX(-1)
        end
    end
end

function CrossServerBattelOver:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/cross_service/cross_service_map_over_ui.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    for i=1,3 do
        local Panel_cross_head = ccui.Helper:seekWidgetByName(root, "Panel_cross_head_" .. i)
        if _ED.cross_server_battel_map_close_info.topRank[(i - 1) .. ""] then
            fwin:addTouchEventListener(Panel_cross_head, nil, 
            {
                terminal_name = "cross_server_battel_show_formation", 
                terminal_state = 0,
                _index = i,
                isPressedActionEnabled = true
            }, 
            nil, 0)
        end
    end

    -- iphone刘海适配
    local Panel_cross_left_d = ccui.Helper:seekWidgetByName(root, "Panel_cross_left_d")
    if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and Panel_cross_left_d and isIphoneX() then 
        Panel_cross_left_d:setPositionX(Panel_cross_left_d:getPositionX()+80)
    end
    

    self:onUpdateDraw()
end

function CrossServerBattelOver:init()
end

function CrossServerBattelOver:onExit()
    self:stopAllActions()
end