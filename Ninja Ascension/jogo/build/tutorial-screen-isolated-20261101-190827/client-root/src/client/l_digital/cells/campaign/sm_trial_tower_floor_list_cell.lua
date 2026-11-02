--------------------------------------------------------------------------------------------------------------
--  说明：数码试炼单层控件
--------------------------------------------------------------------------------------------------------------
SmTrialTowerFloorListCell = class("SmTrialTowerFloorListCellClass", Window)
SmTrialTowerFloorListCell.__size = nil
SmTrialTowerFloorListCell.__baseX = nil

--创建cell
local sm_trial_tower_floor_list_cell_terminal = {
    _name = "sm_trial_tower_floor_list_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmTrialTowerFloorListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_trial_tower_floor_list_cell_terminal)
state_machine.init()

function SmTrialTowerFloorListCell:ctor()
	self.super:ctor()
	self.roots = {}

    self.m_type = 0
    self.actionOver = true
    self._npc_id = 0
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.l_digital.campaign.trialtower.SmTrialTowerBaoxiang")
	 -- Initialize sm_trial_tower_floor_list_cell state machine.
    local function init_sm_trial_tower_floor_list_cell_terminal()
        
        local sm_trial_tower_floor_list_cell_check_terminal = {
            _name = "sm_trial_tower_floor_list_cell_check",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.sm_trial_tower_floor_click_on ~= nil and _ED.sm_trial_tower_floor_click_on == true then
                    return
                end
                state_machine.lock("sm_trial_tower_floor_list_cell_check")
                _ED.sm_trial_tower_floor_click_on = true
                local cells = params._datas.cells
                if tonumber(cells.index) == tonumber(cells.current_index) then
                    if cells.m_type == 1 then
                        local ship = zstring.split(dms.string(dms["three_kingdoms_config"], tonumber(cells.index), three_kingdoms_config.npc_id), "|")
                        --打开npc
                        local canJumpFloor = 0
                        local oldJumpFloor = zstring.tonumber(_ED.one_key_sweep_three_max_pass)
                        local jump_info = zstring.split(dms.string(dms["play_config"], 58, play_config.param), "|")
                        for k, v in pairs(jump_info) do
                            local info = zstring.split(v, ",")
                            if oldJumpFloor < tonumber(info[1]) then
                                break
                            end
                            canJumpFloor = tonumber(info[2])
                        end
                        -- local jumpLevel = dms.int(dms["play_config"], 57, play_config.param)
                        -- if jumpLevel <= tonumber(_ED.user_info.user_grade) then
                        --     local jumpFloor = dms.int(dms["base_consume"], 66, base_consume.vip_0_value + tonumber(_ED.vip_grade))
                        --     if canJumpFloor < jumpFloor then
                        --         canJumpFloor = jumpFloor
                        --     end
                        -- end
                        if canJumpFloor > 0 and canJumpFloor >= tonumber(_ED.integral_current_index) and (_ED.is_trial_tower_skip_over == nil or _ED.is_trial_tower_skip_over ~= true) then
                            if _ED.trial_tower_skip == true  then
                                --直接跳
                                local function responseGetServerListCallback1(response)
                                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                        if response.node ~= nil and response.node.roots[1] ~= nil then
                                            state_machine.excute("trial_tower_insert_new_cell_data",0,"0")
                                        else
                                            state_machine.unlock("sm_trial_tower_floor_list_cell_check")
                                            _ED.sm_trial_tower_floor_click_on = false
                                        end
                                    else
                                        state_machine.unlock("sm_trial_tower_floor_list_cell_check")
                                        _ED.sm_trial_tower_floor_click_on = false
                                    end
                                end
                                local integral_Interval = zstring.split(dms.string(dms["play_config"], 23, play_config.param), "!")
                                local intervalData = nil
                                for i, v in pairs(integral_Interval) do
                                    local datas = zstring.split(v, "|")
                                    local levels = zstring.split(datas[1], ",")
                                    if tonumber(_ED.user_info.user_grade) <= tonumber(levels[2]) then
                                        intervalData = datas
                                        break
                                    end
                                end
                                local interval_info = zstring.split(intervalData[2], ",")
                                local tolerance = zstring.split(intervalData[3], ",")
                                local battle_integral = tonumber(interval_info[3])+tonumber(tolerance[3])*math.floor(tonumber(_ED.integral_current_index)/2)

                                local addition_data = zstring.split(dms.string(dms["play_config"], 32, play_config.param),"|")
                                local addition_info = 1
                                for i,v in pairs(addition_data) do
                                    local addition = zstring.split(v,",")
                                    if tonumber(_ED.vip_grade) >= tonumber(addition[1]) then
                                        addition_info = 1+tonumber(addition[2])/100
                                    end
                                end

                                local Magnification = zstring.split(dms.string(dms["play_config"], 25, play_config.param), ",")
                                local strs = ""
                                for j, w in pairs(_ED.user_try_ship_infos) do
                                    local percentage = (zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
                                    --每次战斗胜利后加血和怒
                                    if tonumber(_ED.user_ship[""..w.id].ship_grade) > 10 then
                                        if tonumber(w.newHp) > 0 then
                                            local addAll = zstring.split(dms.string(dms["play_config"], 52, play_config.param), ",")
                                            local fightParams = zstring.split(dms.string(dms["fight_config"], 5 ,user_config.param),",")
                                            w.newHp = zstring.tonumber(w.newHp) + zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*(addAll[1]/100)
                                            if zstring.tonumber(w.newHp) > zstring.tonumber(_ED.user_ship[""..w.id].ship_health) then
                                                w.newHp = zstring.tonumber(_ED.user_ship[""..w.id].ship_health)
                                                percentage = 100
                                            else
                                                percentage = (zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
                                            end
                                            w.newanger = zstring.tonumber(w.newanger) + zstring.tonumber(fightParams[4])*(addAll[2]/100)
                                            if zstring.tonumber(w.newanger) > zstring.tonumber(fightParams[4]) then
                                                w.newanger = zstring.tonumber(fightParams[4])
                                            end
                                        end
                                    end
                                    ------------------------------------------------------------
                                    if strs ~= "" then
                                        strs = strs.."|"..w.id..":"..w.newHp..","..w.newanger..","..percentage
                                    else
                                        strs = w.id..":"..w.newHp..","..w.newanger..","..percentage
                                    end
                                    
                                end

                                local formationInfo = ""
                                for i, v in pairs(_ED.user_formetion_status) do
                                    local ship = _ED.user_ship[""..v]
                                    if ship ~= nil then
                                        if formationInfo == "" then
                                            formationInfo = ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                                        else
                                            formationInfo = formationInfo.."|"..ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                                        end
                                    else
                                        if formationInfo == "" then
                                            formationInfo = "0,0,0,0"
                                        else
                                            formationInfo = formationInfo.."|".."0,0,0,0"
                                        end
                                    end
                                end

                                protocol_command.three_kingdoms_launch.param_list = "54".."\r\n"..dms.string(dms["play_config"], 26, play_config.param).."\r\n".."1".."\r\n"..math.floor(3*5).."\r\n".."1".."\r\n"..
                                _ED.integral_current_index.."\r\n"..strs.."\r\n".."".."\r\n".."".."\r\n"..math.floor(battle_integral*addition_info*tonumber(Magnification[3])).."\r\n"..formationInfo
                                NetworkManager:register(protocol_command.three_kingdoms_launch.code, nil, nil, nil, cells, responseGetServerListCallback1, false, nil)
                            else
                                state_machine.excute("sm_trial_tower_skip_tip_open",0,{ship[2], canJumpFloor})
                                state_machine.unlock("sm_trial_tower_floor_list_cell_check")
                                _ED.sm_trial_tower_floor_click_on = false
                            end
                        else
                            local guanQia = GuanQia:new()
                            guanQia:init(ship[2])
                            fwin:open(guanQia, fwin._ui)
                            state_machine.unlock("sm_trial_tower_floor_list_cell_check")
                            _ED.sm_trial_tower_floor_click_on = false
                        end
                    elseif cells.m_type == 2 then
                        --打开宝箱获得奖励
                        --控制按钮连点
                        local btn = params._datas.terminal_button
                        if btn then
                            btn:setTouchEnabled(false)
                            btn:runAction(cc.Sequence:create({cc.DelayTime:create(1), cc.CallFunc:create(function ( sender )
                                btn:setTouchEnabled(true)
                            end)})
                            )
                        end
                        local function responseGetServerListCallback2(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if response.node ~= nil and nil ~= response.node.roots and response.node.roots[1] ~= nil then
                                    state_machine.excute("sm_trial_tower_baoxiang_open", 0,"")
                                    app.load("client.reward.DrawRareReward")
                                    local getRewardWnd = DrawRareReward:new()
                                    getRewardWnd:init(37)
                                    fwin:open(getRewardWnd, fwin._ui)
                                    
                                    if _ED.active_activity[134] ~= nil and _ED.active_activity[134] ~= "" then
                                        local rewardListView = ccui.Helper:seekWidgetByName(getRewardWnd.roots[1], "ListView_136")
                                        local _tables = rewardListView:getItems()
                                        for i, cell in pairs(_tables) do
                                            if 1 == tonumber(cell.item[1]) then
                                                if cell.setActivityDouble ~= nil then
                                                    cell:setActivityDouble(true)
                                                end
                                            end
                                        end
                                    end
                                end 
                            end
                            state_machine.unlock("sm_trial_tower_floor_list_cell_check")
                            _ED.sm_trial_tower_floor_click_on = false
                            _ED.prop_chest_store_recruiting = false
                        end

                        _ED.new_prop_object = {}
                        _ED.recruit_success_ship_id = nil
                        _ED.new_reward_object = {}
                        _ED.prop_chest_store_recruiting = true

                        protocol_command.three_kingdoms_launch.param_list = "54".."\r\n"..dms.string(dms["play_config"], 26, play_config.param).."\r\n".."0".."\r\n".."0".."\r\n".."0".."\r\n"..
                        _ED.integral_current_index.."\r\n".."".."\r\n".."".."\r\n".."".."\r\n".."0"
                        NetworkManager:register(protocol_command.three_kingdoms_launch.code, nil, nil, nil, cells, responseGetServerListCallback2, false, nil)

                    elseif cells.m_type == 3 then
                        --打开buff界面
                        local win = AdditionSelect:new()
                        win:init()
                        fwin:open(win, fwin._windows)
                        state_machine.unlock("sm_trial_tower_floor_list_cell_check")
                        _ED.sm_trial_tower_floor_click_on = false
                    end
                    -- if true then
                    --     --打赢了或者宝箱开启了或者buff加了
                    --     state_machine.excute("trial_tower_insert_new_cell_data", 0,"")
                    -- end
                else
                    state_machine.unlock("sm_trial_tower_floor_list_cell_check")
                    _ED.sm_trial_tower_floor_click_on = false
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_trial_tower_floor_list_cell_check_terminal)
        state_machine.init()
    end 
    -- call func sm_trial_tower_floor_list_cell create state machine.
    init_sm_trial_tower_floor_list_cell_terminal()

end

function SmTrialTowerFloorListCell:updateNextFloor( current_index )
    local root = self.roots[1]
    self.current_index = current_index
    if root == nil then
        return
    end
    local Panel_player = ccui.Helper:seekWidgetByName(root, "Panel_player")
    Panel_player:removeAllChildren(true)
    local Panel_gx_di = ccui.Helper:seekWidgetByName(root, "Panel_gx_di")
    Panel_gx_di:removeAllChildren(true)
    if tonumber(self.index) == tonumber(current_index) then
        local hero_fight = 0
        local ships = nil
        for i = 2, 7 do
            local shipId = _ED.formetion[i]
            if _ED.user_ship[""..shipId] ~= nil then
                if tonumber(_ED.user_ship[""..shipId].hero_fight) > hero_fight then
                    hero_fight = tonumber(_ED.user_ship[""..shipId].hero_fight)
                    ships = _ED.user_ship[""..shipId]
                end
            end
        end
        ----------------------新的数码的形象------------------------
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], ships.ship_template_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        
        local ship_evo = zstring.split(ships.evolution_status, "|")
        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
        --新的形象编号
        local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
        local armature_hero = sp.spine_sprite(Panel_player, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        armature_hero:setScaleX(-1)
        armature_hero.animationNameList = spineAnimations
        sp.initArmature(armature_hero, true)

        local jsonFile = "sprite/sprite_shilian_di.json"
        local atlasFile = "sprite/sprite_shilian_di.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_gx_di:addChild(animation)
    end
    if tonumber(self.index) > tonumber(current_index)+1 then
        ccui.Helper:seekWidgetByName(root, "Panel_black"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Panel_black"):setVisible(false)
    end
    self:updateDraw(current_index)
end

function SmTrialTowerFloorListCell:updateDraw(current_index)
    local root = self.roots[1]
    self.current_index = current_index
    if root == nil then
        return
    end
    local AtlasLabel_floor_number = ccui.Helper:seekWidgetByName(root, "AtlasLabel_floor_number")
    AtlasLabel_floor_number:setString(tonumber(self.index))

    local Panel_player = ccui.Helper:seekWidgetByName(root, "Panel_player")
    Panel_player:removeAllChildren(true)
    local Panel_gx_di = ccui.Helper:seekWidgetByName(root, "Panel_gx_di")
    Panel_gx_di:removeAllChildren(true)
    if tonumber(self.index) == tonumber(current_index) then
        local hero_fight = 0
        local ships = nil
        for i = 2, 7 do
            local shipId = _ED.formetion[i]
            if _ED.user_ship[""..shipId] ~= nil then
                if tonumber(_ED.user_ship[""..shipId].hero_fight) > hero_fight then
                    hero_fight = tonumber(_ED.user_ship[""..shipId].hero_fight)
                    ships = _ED.user_ship[""..shipId]
                end
            end
        end
        ----------------------新的数码的形象------------------------
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], ships.ship_template_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        
        local ship_evo = zstring.split(ships.evolution_status, "|")
        local evo_mould_id = smGetSkinEvoIdChange(ships)
        --新的形象编号
        local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
        local armature_hero = sp.spine_sprite(Panel_player, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        armature_hero:setScaleX(-1)
        armature_hero.animationNameList = spineAnimations
        sp.initArmature(armature_hero, true)

        local jsonFile = "sprite/sprite_shilian_di.json"
        local atlasFile = "sprite/sprite_shilian_di.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_gx_di:addChild(animation)
    end
    local Panel_enemy = ccui.Helper:seekWidgetByName(root, "Panel_enemy")
    Panel_enemy:removeAllChildren(true)
    local Image_buff = ccui.Helper:seekWidgetByName(root, "Image_buff")
    Image_buff:setVisible(false)
    local Image_box = ccui.Helper:seekWidgetByName(root, "Image_box")
    Image_box:setVisible(false)
    local Panel_gx = ccui.Helper:seekWidgetByName(root, "Panel_gx")
    Panel_gx:removeAllChildren(true)

    -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    -- else
        local Panel_dh_lg_1 = ccui.Helper:seekWidgetByName(root, "Panel_dh_lg_1")
        Panel_dh_lg_1:removeAllChildren(true)
        local Panel_dh_lg_2 = ccui.Helper:seekWidgetByName(root, "Panel_dh_lg_2")
        Panel_dh_lg_2:removeAllChildren(true)
    -- end

    if tonumber(self.index) >= tonumber(current_index) then
        if self._npc_id ~= "-1" then
            self.m_type = 1
            --npc
            -- local ship = zstring.split(self._npc_id, "|")
            -- local npcGroup = zstring.split(dms.string(dms["play_config"], 56, pirates_config.param),",")
            -- local m_index = math.random(1,#npcGroup)
            ----------------------新的数码的形象------------------------
            -- local mould = tonumber(npcGroup[m_index])
            -- --进化形象
            -- local evo_image = dms.string(dms["ship_mould"], mould, ship_mould.fitSkillTwo)
            -- local evo_info = zstring.split(evo_image, ",")
            
            -- local evo_mould_id = evo_info[dms.int(dms["ship_mould"], mould, ship_mould.captain_name)]
            -- --新的形象编号
            -- local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
            local temp_bust_index = TrialTower.npcs[tonumber(self.index)]--tonumber(npcGroup[m_index])
            local armature_hero = sp.spine_sprite(Panel_enemy, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
            armature_hero.animationNameList = spineAnimations
            sp.initArmature(armature_hero, true)

            -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            -- else
                local Panel_dh_lg_1 = ccui.Helper:seekWidgetByName(root, "Panel_dh_lg_1")
                local jsonFile = "sprite/liuguang2.json"
                local atlasFile = "sprite/liuguang2.atlas"
                local animationtwo = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                Panel_dh_lg_1:addChild(animationtwo)
            -- end


        elseif dms.string(dms["three_kingdoms_config"], tonumber(self.index), three_kingdoms_config.reward_id) ~= "-1" then
            self.m_type = 2
            --宝箱
            Image_box:setVisible(true)
            local jsonFile = "sprite/sprite_shilian_baoxiang.json"
            local atlasFile = "sprite/sprite_shilian_baoxiang.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            Panel_gx:addChild(animation)

            -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            -- else
                local Panel_dh_lg_2 = ccui.Helper:seekWidgetByName(root, "Panel_dh_lg_2")
                local jsonFile = "sprite/liuguang2.json"
                local atlasFile = "sprite/liuguang2.atlas"
                local animationtwo = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                Panel_dh_lg_2:addChild(animationtwo)
            -- end

        elseif dms.string(dms["three_kingdoms_config"], tonumber(self.index), three_kingdoms_config.attribute_add_id) ~= "-1" then
            self.m_type = 3
            --buff
            Image_buff:setVisible(true)
            local jsonFile = "sprite/sprite_shilian_baoxiang.json"
            local atlasFile = "sprite/sprite_shilian_baoxiang.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            Panel_gx:addChild(animation)

            -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            -- else
                local Panel_dh_lg_2 = ccui.Helper:seekWidgetByName(root, "Panel_dh_lg_2")
                local jsonFile = "sprite/liuguang2.json"
                local atlasFile = "sprite/liuguang2.atlas"
                local animationtwo = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                Panel_dh_lg_2:addChild(animationtwo)
            -- end
        end
    end

    if tonumber(self.index) > tonumber(current_index)+1 then
        ccui.Helper:seekWidgetByName(root, "Panel_black"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Panel_black"):setVisible(false)
    end
    -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    --     if tonumber(self.index)%2 == 0 then
    --         ccui.Helper:seekWidgetByName(root, "Image_line_1"):setVisible(true)
    --         ccui.Helper:seekWidgetByName(root, "Image_line_2"):setVisible(true)
    --         ccui.Helper:seekWidgetByName(root, "Image_57_1"):setVisible(true)
    --         ccui.Helper:seekWidgetByName(root, "Image_57_0_0"):setVisible(true)
    --     else
    --         ccui.Helper:seekWidgetByName(root, "Image_line_1"):setVisible(false)
    --         ccui.Helper:seekWidgetByName(root, "Image_line_2"):setVisible(false)
    --         ccui.Helper:seekWidgetByName(root, "Image_57_1"):setVisible(false)
    --         ccui.Helper:seekWidgetByName(root, "Image_57_0_0"):setVisible(false)
    --     end
    --     if tonumber(self.index) == 60 then
    --         -- ccui.Helper:seekWidgetByName(root, "Image_line_1"):setVisible(false)
    --         ccui.Helper:seekWidgetByName(root, "Image_line_2"):setVisible(false)
    --         ccui.Helper:seekWidgetByName(root, "Image_57_1"):setVisible(false)
    --         -- ccui.Helper:seekWidgetByName(root, "Image_57_0_0"):setVisible(false)
    --     end
    --     local animationChild = Panel_gx:getChildByTag(1024)
    --     if animationChild ~= nil then 
    --         Panel_gx:removeChildByTag(1024)
    --     end
    --     if zstring.tonumber(self.index) == zstring.tonumber(self.current_index) then
    --         local jsonFile = "sprite/sprite_pve_arrow.json"
    --         local atlasFile = "sprite/sprite_pve_arrow.atlas"
    --         local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    --         animation:setPositionY(Panel_gx:getContentSize().height+150)
    --         animation:setTag(1024)
    --         Panel_gx:addChild(animation)
    --     end
    -- end
end

function SmTrialTowerFloorListCell:onUpdate(dt)
    if self.roots[1] == nil then
        return
    end
    if self._npc_id == "-1" then
        local image_objects = nil
        if dms.string(dms["three_kingdoms_config"], tonumber(self.index), three_kingdoms_config.reward_id) ~= "-1" then
            image_objects = ccui.Helper:seekWidgetByName(self.roots[1], "Image_box")
        else
            image_objects = ccui.Helper:seekWidgetByName(self.roots[1], "Image_buff")
        end

        if self.actionOver == true then
            self.actionOver = false
            local function executeMoveFunc()
                local function executeMoveHeroOverFunc()
                    self.actionOver = true
                end
                image_objects:runAction(cc.Sequence:create(
                    cc.MoveTo:create(1, cc.p(image_objects:getPositionX() , image_objects:getPositionY() - 10)),
                    cc.CallFunc:create(executeMoveHeroOverFunc)
                ))
            end
            image_objects:runAction(cc.Sequence:create(
                cc.MoveTo:create(1, cc.p(image_objects:getPositionX() , image_objects:getPositionY() + 10)),
                cc.CallFunc:create(executeMoveFunc)
            ))
        end
    end
end

function SmTrialTowerFloorListCell:onInit()
    -- local csbItem = csb.createNode("campaign/TrialTower/sm_trial_tower_floor_list.csb")
    -- local root = csbItem:getChildByName("root")
    -- table.insert(self.roots, root) 
    -- self:addChild(csbItem)

    local root = cacher.createUIRef("campaign/TrialTower/sm_trial_tower_floor_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if SmTrialTowerFloorListCell.__size == nil then
        SmTrialTowerFloorListCell.__size = root:getContentSize()
    end
    if SmTrialTowerFloorListCell.__baseX == nil then
        SmTrialTowerFloorListCell.__baseX = root:getPositionX()
    end
    local panel_object = ccui.Helper:seekWidgetByName(root, "Panel_object")
    fwin:addTouchEventListener(panel_object, nil, 
    {
        terminal_name = "sm_trial_tower_floor_list_cell_check", 
        terminal_state = 0, 
        touch_black = true,
        terminal_button = panel_object,
        cells = self,
    }, nil, 1)

    -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    --     if self.index%2 == 0 then
    --         root:setPositionX(SmTrialTowerFloorListCell.__baseX)
    --     else
    --         root:setPositionX(SmTrialTowerFloorListCell.__baseX + 320)
    --     end
    -- else
        root:setPositionX(SmTrialTowerFloorListCell.__baseX)
    -- end
	self:updateDraw(self.current_index)
    self:registerOnNoteUpdate(self)
end

function SmTrialTowerFloorListCell:onEnterTransitionFinish()

end

function SmTrialTowerFloorListCell:clearUIInfo( ... )
    local root = self.roots[1]
    if root ~= nil then
        root:setPositionX(SmTrialTowerFloorListCell.__baseX)
        local Panel_player = ccui.Helper:seekWidgetByName(root, "Panel_player")
        if Panel_player ~= nil then
            Panel_player:removeAllChildren(true)
        end
        local Panel_gx_di = ccui.Helper:seekWidgetByName(root, "Panel_gx_di")
        if Panel_gx_di ~= nil then
            Panel_gx_di:removeAllChildren(true)
        end
        local Panel_enemy = ccui.Helper:seekWidgetByName(root, "Panel_enemy")
        if Panel_enemy ~= nil then
            Panel_enemy:removeAllChildren(true)
        end
        local Panel_gx = ccui.Helper:seekWidgetByName(root, "Panel_gx")
        if Panel_gx ~= nil then
            Panel_gx:removeAllChildren(true)
        end
        local Image_buff = ccui.Helper:seekWidgetByName(root, "Image_buff")
        if Image_buff ~= nil then
            Image_buff:setVisible(false)
        end
        local Image_box = ccui.Helper:seekWidgetByName(root, "Image_box")
        if Image_box ~= nil then
            Image_box:setVisible(false)
        end
    end
end

function SmTrialTowerFloorListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self, 1)
    self:onInit()
end

function SmTrialTowerFloorListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/TrialTower/sm_trial_tower_floor_list.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmTrialTowerFloorListCell:init(params)
    self.index = params[1]
    self.current_index = params[2]
    self._npc_id = dms.string(dms["three_kingdoms_config"], self.index, three_kingdoms_config.npc_id)
	if self.index <= 3 then
        self:onInit()
        -- if tonumber(self.index) == 60 then
            -- SmTrialTowerFloorListCell.__size = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_black"):getContentSize()
        -- else
            SmTrialTowerFloorListCell.__size = self.roots[1]:getContentSize()
        -- end
    end
    -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    --     if tonumber(self.index) == 60 then
    --         self:setContentSize(cc.size(SmTrialTowerFloorListCell.__size.width,348))
    --     else
    --         self:setContentSize(SmTrialTowerFloorListCell.__size)
    --     end
    -- else
        self:setContentSize(SmTrialTowerFloorListCell.__size)
    -- end
    
    return self
end

function SmTrialTowerFloorListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/TrialTower/sm_trial_tower_floor_list.csb", self.roots[1])
end