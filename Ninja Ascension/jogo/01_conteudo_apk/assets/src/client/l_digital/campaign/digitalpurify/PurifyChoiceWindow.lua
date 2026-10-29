-- ----------------------------------------------------------------------------------------------------
-- 说明：数码净化武将选择界面
-------------------------------------------------------------------------------------------------------
PurifyChoiceWindow = class("PurifyChoiceWindowClass", Window)

local purify_choice_window_open_terminal = {
    _name = "purify_choice_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:open(PurifyChoiceWindow:new():init(params), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local purify_choice_window_close_terminal = {
    _name = "purify_choice_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("PurifyChoiceWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(purify_choice_window_open_terminal)
state_machine.add(purify_choice_window_close_terminal)
state_machine.init()

function PurifyChoiceWindow:ctor()
    self.super:ctor()
    self.roots = {}

    -- load luf file
    app.load("client.l_digital.cells.campaign.digitalpurify.purify_hero_choice_cell")

    -- var
    self._current_choice_team_index = 0
    
    -- Initialize purify choice page state machine.
    local function init_purify_choice_terminal()

        local purify_choice_window_create_team_terminal = {
            _name = "purify_choice_window_create_team",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDigitalPurifyTeamCreateCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node == nil or response.node.roots == nil then
                            return
                        end
                        if nil ~= _ED.digital_purify_info then
                            if nil ~= _ED.digital_purify_info._team_info
                                and nil ~= _ED.digital_purify_info._team_info.team_type 
                                and _ED.digital_purify_info._team_info.team_type >= 0 
                                then
                                state_machine.excute("purify_team_window_open", 0, response.node._rootWindows)
                                state_machine.excute("purify_choice_window_close", 0, 0)
                            end
                        end
                    end
                end

                -- SIN EL GUERRERO NO SE PUEDE DESAFIAR (regla 4 de la ayuda:
                -- «To defeat one evil soldier, you must firstly have this
                -- soldier»). El boton se apagaba y no decia nada, y el rotulo de
                -- la pantalla —una imagen, `images/ui/text/clone/2.png`: «Select a
                -- warrior to purify»— hacia pensar que faltaba ELEGIR y no TENER.
                -- El aviso es el que el chat YA usa para esta misma condicion
                -- (ChatSayMineCell.lua:63), asi que no hace falta cadena nueva.
                if true ~= instance._have_hero then
                    TipDlg.drawTextDailog(_new_interface_text[123])
                    return
                end
                protocol_command.ship_purify_team_manager.param_list = "0\r\n" .. instance._current_choice_team_index .. "\r\n"
                NetworkManager:register(protocol_command.ship_purify_team_manager.code, nil, nil, nil, instance, responseDigitalPurifyTeamCreateCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
    
        local purify_choice_window_join_team_terminal = {
            _name = "purify_choice_window_join_team",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDigitalPurifyTeamJoinCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node == nil or response.node.roots == nil then
                            return
                        end
                        if nil ~= _ED.digital_purify_info then
                            if nil ~= _ED.digital_purify_info._team_info 
                                and nil ~= _ED.digital_purify_info._team_info.team_type
                                and _ED.digital_purify_info._team_info.team_type >= 0 
                                then
                                state_machine.excute("purify_team_window_open", 0, response.node._rootWindows)
                                state_machine.excute("purify_choice_window_close", 0, 0)
                            end
                        end
                    end
                end

                -- SIN EL GUERRERO NO SE PUEDE DESAFIAR (regla 4 de la ayuda:
                -- «To defeat one evil soldier, you must firstly have this
                -- soldier»). El boton se apagaba y no decia nada, y el rotulo de
                -- la pantalla —una imagen, `images/ui/text/clone/2.png`: «Select a
                -- warrior to purify»— hacia pensar que faltaba ELEGIR y no TENER.
                -- El aviso es el que el chat YA usa para esta misma condicion
                -- (ChatSayMineCell.lua:63), asi que no hace falta cadena nueva.
                if true ~= instance._have_hero then
                    TipDlg.drawTextDailog(_new_interface_text[123])
                    return
                end
                protocol_command.ship_purify_team_manager.param_list = "1\r\n" .. instance._current_choice_team_index .. "\r\n"
                NetworkManager:register(protocol_command.ship_purify_team_manager.code, nil, nil, nil, instance, responseDigitalPurifyTeamJoinCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
    
        local purify_choice_window_choice_item_terminal = {
            _name = "purify_choice_window_choice_item",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    local m_index = tonumber(params._datas.m_index)
                    instance.m_data = _ED.digital_purify_info._heros[m_index]
                    instance._current_choice_team_index = m_index - 1
                else
                    instance.m_data = params[1]
                    instance._current_choice_team_index = params[2]
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(purify_choice_window_create_team_terminal)
        state_machine.add(purify_choice_window_join_team_terminal)
        state_machine.add(purify_choice_window_choice_item_terminal)

        state_machine.init()
    end
    
    -- call func init purify choice state machine.
    init_purify_choice_terminal()
end

function PurifyChoiceWindow:init( params )
    self._rootWindows = params
    return self
end

function PurifyChoiceWindow:onUpdate(dt)

end

function PurifyChoiceWindow:onUpdateDraw()
    local root = self.roots[1]

    local shipMouldId = self.m_data[2]

    local ship = fundShipWidthTemplateId(shipMouldId)
    local shipInitGroup = 1
    local havhHero = false

    if ship ~= nil then
        local ship_evo = zstring.split(ship.evolution_status, "|")
        shipInitGroup = tonumber(ship_evo[1])
        havhHero = true
    else
        shipInitGroup = dms.int(dms["ship_mould"], tonumber(shipMouldId), ship_mould.captain_name)
    end

    local evo_image = dms.string(dms["ship_mould"], tonumber(shipMouldId), ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    local shipEvoMouldId = tonumber(evo_info[shipInitGroup])
    local picIndex = dms.int(dms["ship_evo_mould"], shipEvoMouldId, ship_evo_mould.form_id)

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        for i=1, 6 do
            local Panel_dh = ccui.Helper:seekWidgetByName(root, "Panel_dh_" .. i)
            Panel_dh:removeAllChildren(true)
            if i==self._current_choice_team_index+1 then
                -- 创建光效
                local armature = nil
                if animationMode == 1 then
                    -- armature = sp.spine_sprite(self, self._brole._head, spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
                    -- armature.animationNameList = spineAnimations
                    -- sp.initArmature(armature, true)
                    armature = sp.spine_effect("sprite_heisechilun", effectAnimations[1], false, nil, nil, nil, nil, nil, nil, "sprite/")
                    armature.animationNameList = effectAnimations
                    sp.initArmature(armature, true)
                else
                    local armatureName, fileName = self:loadEffectFile(fileIndex)
                    armature = ccs.Armature:create(armatureName)
                    armature._fileName = fileName
                end
                -- table.insert(self.animationList, {fileName = fileName, armature = armature})
                local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
                -- local _tcamp = zstring.tonumber(""..self.roleCamp)
                local _armatureIndex = 0 -- frameListCount * _tcamp
                armature:getAnimation():playWithIndex(_armatureIndex)
                armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
                Panel_dh:addChild(armature)
                armature:setPositionX(Panel_dh:getContentSize().width / 2)
            end
        end
    else
        local name_mould_id = dms.int(dms["ship_evo_mould"], shipEvoMouldId, ship_evo_mould.name_index)
        local shipName = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
        local Text_digimon_name = ccui.Helper:seekWidgetByName(root, "Text_digimon_name")
        Text_digimon_name:setString(shipName)

        local Panel_digimon_animation = ccui.Helper:seekWidgetByName(root, "Panel_digimon_animation")
        if Panel_digimon_animation ~= nil then
            Panel_digimon_animation:removeBackGroundImage()
            Panel_digimon_animation:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex))
        end
        -- local armature_hero = sp.spine_sprite(Panel_dh, picIndex, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        -- armature_hero:setScaleX(-1)
        -- self.armature_hero = armature_hero
        -- armature_hero.animationNameList = spineAnimations
        -- sp.initArmature(self.armature_hero, true)
        -- local function changeActionCallback( armatureBack )  
        -- end
        -- local actionIndex = _enum_animation_l_frame_index.animation_standby

        -- armature_hero._self = self
        -- -- armature_hero:getAnimation():setFrameEventCallFunc(onFrameEventRole)
        -- armature_hero._invoke = changeActionCallback
        -- armature_hero:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        -- csb.animationChangeToAction(self.armature_hero, actionIndex, 0, false)
        -- armature_hero._nextAction = 0
    end
    local Button_team = ccui.Helper:seekWidgetByName(root, "Button_team")
    local Button_join = ccui.Helper:seekWidgetByName(root, "Button_join")
    -- Se quedan PULSABLES aunque no tengas el guerrero: apagados y mudos
    -- parecian un boton roto. Siguen apagados (setBright), pero ahora al
    -- pulsarlos sale el motivo de verdad.
    self._have_hero = havhHero
    Button_team:setTouchEnabled(true)
    Button_team:setBright(havhHero)
    Button_join:setTouchEnabled(true)
    Button_join:setBright(havhHero)
end

function PurifyChoiceWindow:onEnterTransitionFinish()
    local csbPurifyChoiceWindow = csb.createNode("campaign/DigitalPurify/digital_purify_tab_1.csb")
    self:addChild(csbPurifyChoiceWindow)
    local root = csbPurifyChoiceWindow:getChildByName("root")
    table.insert(self.roots, root)

    -- 打开规则窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil, 
    {
        func_string = [[state_machine.excute("purify_help_window_open", 0, 0)]], 
        isPressedActionEnabled = true
    },
    nil,0)

    -- 创建队伍
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_team"), nil, 
    {
        terminal_name = "purify_choice_window_create_team", 
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil,0)

    -- 加入队伍
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_join"), nil, 
    {
        terminal_name = "purify_choice_window_join_team", 
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil,0)

    local firstCell = nil
    for i = 1, 6 do
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            local Panel_digimon_animation = ccui.Helper:seekWidgetByName(root, "Panel_digimon_animation_" .. i)
            Panel_digimon_animation:removeAllChildren(true)
            local ship = fundShipWidthTemplateId(_ED.digital_purify_info._heros[i][2])
            local shipInitGroup = 1
            if ship ~= nil then
                local ship_evo = zstring.split(ship.evolution_status, "|")
                shipInitGroup = tonumber(ship_evo[1])
            else
                shipInitGroup = dms.int(dms["ship_mould"], tonumber(_ED.digital_purify_info._heros[i][2]), ship_mould.captain_name)
            end
            local evo_image = dms.string(dms["ship_mould"], tonumber(_ED.digital_purify_info._heros[i][2]), ship_mould.fitSkillTwo)
            local evo_info = zstring.split(evo_image, ",")
            local shipEvoMouldId = tonumber(evo_info[shipInitGroup])
            if ship then shipEvoMouldId = smGetSkinEvoIdChange(ship) end
            
            local picIndex = dms.int(dms["ship_evo_mould"], shipEvoMouldId, ship_evo_mould.form_id)
            local name_mould_id = dms.int(dms["ship_evo_mould"], shipEvoMouldId, ship_evo_mould.name_index)
            local shipName = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
            local Text_digimon_name = ccui.Helper:seekWidgetByName(root, "Text_digimon_name_"..i)
            Text_digimon_name:setString(shipName)
            local function delayEnd( sender )
                local armature_hero = sp.spine_sprite(sender, picIndex, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
                armature_hero:setScaleX(-1)
                armature_hero.animationNameList = spineAnimations
                sp.initArmature(armature_hero, true)
                local function changeActionCallback( armatureBack )
                end
                local actionIndex = _enum_animation_l_frame_index.animation_standby
                armature_hero._invoke = changeActionCallback
                armature_hero:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                csb.animationChangeToAction(armature_hero, actionIndex, 0, false)
                armature_hero._nextAction = 0
            end

            local action = cc.Sequence:create(cc.DelayTime:create(0.2 * i), cc.CallFunc:create(delayEnd))
            Panel_digimon_animation:runAction(action)
            local pokemon_high_param = dms.searchs(dms["role_high"], pokemon_high.hero_fight_state_id, tonumber(picIndex))
            if pokemon_high_param and pokemon_high_param[1][9] then
                Panel_digimon_animation:setScale(tonumber(pokemon_high_param[1][9]))
            end

            fwin:addTouchEventListener(Panel_digimon_animation, nil, 
            {
                terminal_name = "purify_choice_window_choice_item", 
                terminal_state = 0,
                m_index = i,
            },
            nil,0)


            if i == 1 then
                state_machine.excute("purify_choice_window_choice_item", 0, {_datas = {m_index = i}})
            end
            -- local Panel_dh_1 = ccui.Helper:seekWidgetByName(root, "Panel_dh_" .. i)
            -- -- 创建光效
            -- local armature = nil
            -- if animationMode == 1 then
            --     -- armature = sp.spine_sprite(self, self._brole._head, spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
            --     -- armature.animationNameList = spineAnimations
            --     -- sp.initArmature(armature, true)
            --     armature = sp.spine_effect("sprite_heisechilun", effectAnimations[1], false, nil, nil, nil, nil, nil, nil, "sprite/")
            --     armature.animationNameList = effectAnimations
            --     sp.initArmature(armature, true)
            -- else
            --     local armatureName, fileName = self:loadEffectFile(fileIndex)
            --     armature = ccs.Armature:create(armatureName)
            --     armature._fileName = fileName
            -- end
            -- -- table.insert(self.animationList, {fileName = fileName, armature = armature})
            -- local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
            -- -- local _tcamp = zstring.tonumber(""..self.roleCamp)
            -- local _armatureIndex = 0 -- frameListCount * _tcamp
            -- armature:getAnimation():playWithIndex(_armatureIndex)
            -- armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
            -- Panel_dh_1:addChild(armature)
            -- armature:setPositionX(Panel_dh_1:getContentSize().width / 2)
        else
            local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_" .. i)
            local cell = PurifyHeroChoiceCell:createCell()
            cell:init(i - 1, _ED.digital_purify_info._heros[i])
            Panel_digimon_icon:addChild(cell)
            if i == 1 then
                firstCell = cell
            end
        end
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    else
        local Panel_digimon_animation = ccui.Helper:seekWidgetByName(root, "Panel_digimon_animation")
        -- 创建光效
        local armature = nil
        if animationMode == 1 then
            -- armature = sp.spine_sprite(self, self._brole._head, spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
            -- armature.animationNameList = spineAnimations
            -- sp.initArmature(armature, true)
            armature = sp.spine_effect("sprite_heisechilun", effectAnimations[1], false, nil, nil, nil, nil, nil, nil, "sprite/")
            armature.animationNameList = effectAnimations
            sp.initArmature(armature, true)
        else
            local armatureName, fileName = self:loadEffectFile(fileIndex)
            armature = ccs.Armature:create(armatureName)
            armature._fileName = fileName
        end
        -- table.insert(self.animationList, {fileName = fileName, armature = armature})
        local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
        -- local _tcamp = zstring.tonumber(""..self.roleCamp)
        local _armatureIndex = 0 -- frameListCount * _tcamp
        armature:getAnimation():playWithIndex(_armatureIndex)
        armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
        Panel_digimon_animation:addChild(armature)
        armature:setPositionX(Panel_digimon_animation:getContentSize().width / 2)
        state_machine.excute("purify_hero_choice_cell_choice_target", 0, {_datas = {cell = firstCell}})
    end
    -- self:onUpdateDraw()
end

function PurifyChoiceWindow:onExit()
    state_machine.remove("purify_choice_window_create_team")
    state_machine.remove("purify_choice_window_join_team")
    state_machine.remove("purify_choice_window_choice_item")
end
