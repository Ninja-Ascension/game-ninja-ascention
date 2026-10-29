-- ----------------------------------------------------------------------------------
-- 王者之战的战场UI
-- ----------------------------------------------------------------------------------
TheKingsBattleUIWindow= class("TheKingsBattleUIWindowClass", Window)

local the_kings_battle_ui_window_open_terminal = {
    _name = "the_kings_battle_ui_window_open",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("the_kings_battle_ui_window_close", 0, 0)
        local window = TheKingsBattleUIWindow:new():init(params)
        fwin:open(window, fwin._view)
        return window
    end,
    _terminal = nil,
    _terminals = nil
}

local the_kings_battle_ui_window_close_terminal = {
    _name = "the_kings_battle_ui_window_close",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TheKingsBattleUIWindowClass"))
        return window
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(the_kings_battle_ui_window_open_terminal)
state_machine.add(the_kings_battle_ui_window_close_terminal)
state_machine.init()

function TheKingsBattleUIWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    -- load lua file

    -- var
    self._round_index = 1
    self._attackers = {}
    self._defenders = {}

    -- Initialize the kings battle window state machine.
    local function init_the_kings_battle_ui_window_terminal()
        local the_kings_battle_ui_window_update_draw_hp_terminal = {
            _name = "the_kings_battle_ui_window_update_draw_hp",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateHpDraw(params[1], params[2])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local the_kings_battle_ui_window_update_draw_sp_terminal = {
            _name = "the_kings_battle_ui_window_update_draw_sp",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateSpDraw(params[1], params[2])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local the_kings_battle_ui_window_update_draw_round_count_terminal = {
            _name = "the_kings_battle_ui_window_update_draw_round_count",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawRoundCount(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local the_kings_battle_ui_window_update_draw_camp_info_terminal = {
            _name = "the_kings_battle_ui_window_update_draw_camp_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawCampInfo(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local the_kings_battle_ui_window_update_draw_win_terminal = {
            _name = "the_kings_battle_ui_window_update_draw_win",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- instance:updateWinDraw(params)
                fwin:addService({
                    callback = function ( params )
                        if nil ~= params[1].updateWinDraw then
                            params[1]:updateWinDraw(params[2])
                        end
                    end,
                    params = {instance, params},
                    delay = 0.5
                })
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --退出
        local the_kings_battle_ui_window_out_terminal = {
            _name = "the_kings_battle_ui_window_out",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
            
                cacher.removeAllTextures()
                fwin:reset(nil)
                app.load("client.home.Menu")
                fwin:open(Menu:new(), fwin._taskbar)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    if fwin:find("HomeClass") == nil then
                        state_machine.excute("menu_manager", 0, 
                            {
                                _datas = {
                                    terminal_name = "menu_manager",
                                    next_terminal_name = "menu_show_home_page", 
                                    current_button_name = "Button_home",
                                    but_image = "Image_home",       
                                    terminal_state = 0, 
                                    _needOpenHomeHero = true,
                                    isPressedActionEnabled = true
                                }
                            }
                        )
                        state_machine.excute("menu_back_home_page", 0, "")
                        -- state_machine.excute("home_change_open_atrribute", 0, false)
                    end
                end
                state_machine.excute("campaign_window_open", 0, nil)
                -- 是否是跨服王者标志
                if  _ED.cross_server_kings_battle_flag then
                    _ED.cross_server_kings_battle_flag = nil
                    state_machine.excute("sm_cross_server_battleof_kings_window_open", 0, nil)
                else
                    state_machine.excute("sm_battleof_kings_window_open", 0, nil)
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

                -- 跳过战斗
        local the_kings_battle_ui_skeep_fighting_copy_terminal = {
            _name = "the_kings_battle_ui_skeep_fighting_copy",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("fight_skeep_fighting", 0, 0)
                state_machine.excute("fight_first_set_skip_misson",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(the_kings_battle_ui_window_update_draw_hp_terminal)
        state_machine.add(the_kings_battle_ui_window_update_draw_sp_terminal)
        state_machine.add(the_kings_battle_ui_window_update_draw_round_count_terminal)
        state_machine.add(the_kings_battle_ui_window_update_draw_camp_info_terminal)
        state_machine.add(the_kings_battle_ui_window_update_draw_win_terminal)
        state_machine.add(the_kings_battle_ui_window_out_terminal)
        state_machine.add(the_kings_battle_ui_skeep_fighting_copy_terminal)
        state_machine.init()
    end

    -- call func init the kings battle window state machine.
    init_the_kings_battle_ui_window_terminal()
end

function TheKingsBattleUIWindow:init(params)
    for i, v in pairs(_ED.battleData._heros) do
        table.insert(self._attackers, v)
    end

    if _ED.battleData.__heros then
        for i, v in pairs(_ED.battleData.__heros) do
            table.insert(self._attackers, v)
        end
    end
    
    for i, v in pairs(_ED.battleData._armys[1]._data) do
        table.insert(self._defenders, v)
    end

    if _ED.battleData._armys[1].__data then
        for i, v in pairs(_ED.battleData._armys[1].__data) do
            table.insert(self._defenders, v)
        end
    end
    return self
end

function TheKingsBattleUIWindow:updateHeadDraw( attacker, defender )
    local root = self.roots[1]
    attacker = self._attackers[1]
    defender = self._defenders[1]

    -- 当前的战斗对象头像
    local Panel_pve_head_1 = ccui.Helper:seekWidgetByName(root, "Panel_pve_head_1")
    Panel_pve_head_1:setBackGroundImage("images/ui/pve_sn/props_" .. attacker._head .. ".png")
    
    local Panel_pve_head_2 = ccui.Helper:seekWidgetByName(root, "Panel_pve_head_2")
    Panel_pve_head_2:setBackGroundImage("images/ui/pve_sn/props_" .. defender._head .. ".png")

    -- 绘制速度
    local Label_1p_speed_n = ccui.Helper:seekWidgetByName(root, "Label_1p_speed_n")
    Label_1p_speed_n:setString(_ED.battleData.attacker_priority)

    local Label_2p_speed_n = ccui.Helper:seekWidgetByName(root, "Label_2p_speed_n")
    Label_2p_speed_n:setString(_ED.battleData.defender_priority)


    -- 绘制剩余的参战角色，和已经被击败的角色
    for i = 2, 3 do
        attacker = self._attackers[i]
        defender = self._defenders[i]

        if attacker then
            local Panel_pve_head_hb_left = ccui.Helper:seekWidgetByName(root, "Panel_pve_head_hb_left_"..i-1)
            Panel_pve_head_hb_left:removeAllChildren(true)
            local cell = ShipIconCell:createCell()
            local ships = {}
            ships.ship_template_id = attacker._mouldId
            ships.evolution_status = attacker._head
            ships.Order = attacker._quality
            ships.ship_grade = ""
            ships.StarRating = "0"
            if attacker.__death then
                cell:init(ships,12,nil,nil,nil,nil,true)
            else
                cell:init(ships,12,nil,nil,nil,nil,nil)
            end
            Panel_pve_head_hb_left:addChild(cell)
        end

        if defender then
            local Panel_pve_head_hb_right = ccui.Helper:seekWidgetByName(root, "Panel_pve_head_hb_right_"..i-1)
            Panel_pve_head_hb_right:removeAllChildren(true)
            local cell = ShipIconCell:createCell()
            local ships = {}
            ships.ship_template_id = defender._mouldId
            ships.evolution_status = defender._head
            ships.Order = defender._quality
            ships.ship_grade = ""
            ships.StarRating = "0"
            if defender.__death then
                cell:init(ships,12,nil,nil,nil,nil,true)
            else
                cell:init(ships,12,nil,nil,nil,nil,nil)
            end
            Panel_pve_head_hb_right:addChild(cell)
        end
    end
end

function TheKingsBattleUIWindow:updateHpDraw( attacker, defender )
    local root = self.roots[1]
    local LoadingBar_1_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1_1")
    local LoadingBar_2_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_2_1")

    if nil == attacker then
        -- LoadingBar_1_1:setPercent(100)
    else
        -- local lhp = zstring.tonumber(attacker._role._lhp)
        -- if lhp < attacker._role._hp then
            lhp = attacker._role._hp
        -- end

        local percent = lhp/attacker._brole._hp * 100
        LoadingBar_1_1:setPercent(percent)
    end

    if nil == defender then
        -- LoadingBar_2_1:setPercent(100)
    else
        -- local lhp = zstring.tonumber(defender._role._lhp)
        -- if lhp < defender._role._hp then
            lhp = defender._role._hp
        -- end
        local percent = lhp/defender._brole._hp * 100
        LoadingBar_2_1:setPercent(percent)
    end
end

function TheKingsBattleUIWindow:updateSpDraw( attacker, defender )
    local root = self.roots[1]
    local LoadingBar_nuqi_left = ccui.Helper:seekWidgetByName(root, "LoadingBar_nuqi_left")
    local LoadingBar_nuqi_right = ccui.Helper:seekWidgetByName(root, "LoadingBar_nuqi_right")

    local Panel_nuqiman_dh_1 = ccui.Helper:seekWidgetByName(root, "Panel_nuqiman_dh_1")
    local Panel_nuqiman_dh_2 = ccui.Helper:seekWidgetByName(root, "Panel_nuqiman_dh_2")
    if nil == attacker then
        -- LoadingBar_1_1:setPercent(100)
    else
        local addSp = 0
        if self._showAttacker ~= nil and self._showAttacker ~= attacker then
            -- -- local lastPercent = LoadingBar_nuqi_left:getPercent()
            -- local kingsPercent = dms.float(dms["fight_config"], 21, fight_config.attribute)
            -- -- lastPercent = kingsPercent * lastPercent
            -- addSp = zstring.tonumber(self._showAttackerLastSp) * kingsPercent
        end
        self._showAttacker = attacker
        -- self._showAttackerLastSp = zstring.tonumber(attacker._role._lhp)
        local lsp = zstring.tonumber(attacker._role._lsp)
        -- if lsp <= 0 then
        --     lsp = attacker._role._sp
        -- end
        self._showAttackerLastSp = lsp

        local percent = (addSp + lsp)/FightModule.MAX_SP * 100
        percent = math.max(0, math.min(100, percent))
        LoadingBar_nuqi_left:setPercent(percent)
        if percent >= 100 then
            if nil == Panel_nuqiman_dh_1._full_animation then
                -- if Panel_nuqiman_dh_1:getChildByTag(501) ~= nil then
                --     Panel_nuqiman_dh_1:removeChildByTag(501)
                -- end
                local jsonFile = "sprite/sprite_wzzz_nuqiman.json"
                local atlasFile = "sprite/sprite_wzzz_nuqiman.atlas"
                local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                -- animation:setPosition(cc.p(Panel_icon:getContentSize().width/2,Panel_icon:getContentSize().height/2))
                -- animation:setTag(500)
                Panel_nuqiman_dh_1:addChild(animation)
                Panel_nuqiman_dh_1._full_animation = animation
            end
            Panel_nuqiman_dh_1._full_animation:setVisible(true)
        else
            -- if Panel_nuqiman_dh_1:getChildByTag(500) ~= nil then
            --     Panel_nuqiman_dh_1:removeChildByTag(500)
            -- end
            if nil ~= Panel_nuqiman_dh_1._full_animation then
                Panel_nuqiman_dh_1._full_animation:setVisible(false)
            end
            if Panel_nuqiman_dh_1:getChildByTag(501) ~= nil then
                local moveX = LoadingBar_nuqi_left:getPositionX() + LoadingBar_nuqi_left:getContentSize().width/100*percent - LoadingBar_nuqi_left:getContentSize().width/2
                local animation = Panel_nuqiman_dh_1:getChildByTag(501)
                animation:setVisible(true)
                animation:setPositionX(Panel_nuqiman_dh_1:getPositionX()-moveX)
            else
                local jsonFile = "sprite/sprite_wzzz_nuqitou.json"
                local atlasFile = "sprite/sprite_wzzz_nuqitou.atlas"
                local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                animation:setTag(501)
                Panel_nuqiman_dh_1:addChild(animation)
                if math.floor(percent) <= 0 then
                    animation:setVisible(false)
                else
                    animation:setVisible(true)
                end
            end
            
        end
    end

    if nil == defender then
        -- LoadingBar_2_1:setPercent(100)
    else
        local addSp = 0
        if self._showBeAttacker ~= nil and self._showBeAttacker ~= defender then
            -- -- local lastPercent = LoadingBar_nuqi_left:getPercent()
            -- local kingsPercent = dms.float(dms["fight_config"], 21, fight_config.attribute)
            -- -- lastPercent = kingsPercent * lastPercent
            -- addSp = zstring.tonumber(self._showBeAttackerLastSp) * kingsPercent
        end
        self._showBeAttacker = defender
        -- self._showBeAttackerLastSp = defender._role._sp
        local lsp = zstring.tonumber(defender._role._lsp)
        -- if lsp <= 0 then
            -- lsp = defender._role._sp
        -- end
        self._showBeAttackerLastSp = lsp

        local percent = (addSp + lsp)/FightModule.MAX_SP * 100
        percent = math.max(0, math.min(100, percent))
        LoadingBar_nuqi_right:setPercent(percent)
        if percent >= 100 then
            if nil == Panel_nuqiman_dh_2._full_animation then
                -- if Panel_nuqiman_dh_2:getChildByTag(501) ~= nil then
                --     Panel_nuqiman_dh_2:removeChildByTag(501)
                -- end
                local jsonFile = "sprite/sprite_wzzz_nuqiman.json"
                local atlasFile = "sprite/sprite_wzzz_nuqiman.atlas"
                local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                -- animation:setPosition(cc.p(Panel_icon:getContentSize().width/2,Panel_icon:getContentSize().height/2))
                -- animation:setTag(500)
                Panel_nuqiman_dh_2:addChild(animation)
                Panel_nuqiman_dh_2._full_animation = animation
            end
            Panel_nuqiman_dh_2._full_animation:setVisible(true)
        else
            -- if Panel_nuqiman_dh_2:getChildByTag(500) ~= nil then
            --     Panel_nuqiman_dh_2:removeChildByTag(500)
            -- end
            if nil ~= Panel_nuqiman_dh_2._full_animation then
                Panel_nuqiman_dh_2._full_animation:setVisible(false)
            end
            if Panel_nuqiman_dh_2:getChildByTag(501) ~= nil then
                local moveX = 0 - LoadingBar_nuqi_right:getContentSize().width/100*percent + LoadingBar_nuqi_right:getContentSize().width/2
                local animation = Panel_nuqiman_dh_2:getChildByTag(501)
                animation:setVisible(true)
                animation:setScaleX(-1)
                animation:setPositionX(Panel_nuqiman_dh_2:getPositionX()-moveX)
            else
                local jsonFile = "sprite/sprite_wzzz_nuqitou.json"
                local atlasFile = "sprite/sprite_wzzz_nuqitou.atlas"
                local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                animation:setTag(501)
                Panel_nuqiman_dh_2:addChild(animation)
                if math.floor(percent) <= 0 then
                    animation:setVisible(false)
                else
                    animation:setVisible(true)
                    animation:setScaleX(-1)
                end
            end
        end
    end
end

function TheKingsBattleUIWindow:updateDrawRoundCount(_round_index)
    local root = self.roots[1]

    if zstring.tonumber(_round_index) <= 0 then
        self._round_index = 1
    else
        self._round_index = _round_index -- self._round_index + _round_index
    end

    local drawCount = self._round_index
    if drawCount < 1 then
        drawCount = 1
    end
    local Label_10865 = ccui.Helper:seekWidgetByName(root, "Label_10865")
    Label_10865:setString(drawCount .. "/10")
end

function TheKingsBattleUIWindow:onUpdateDraw( ... )
    local root = self.roots[1]
    -- 绘制名称
    local Label_1p_name = ccui.Helper:seekWidgetByName(root, "Label_1p_name")
    -- Label_1p_name:setString(_ED.battleData.attacker_name)
    Label_1p_name:setString(_ED._attack_people_name)

    local Label_2p_name = ccui.Helper:seekWidgetByName(root, "Label_2p_name")
    Label_2p_name:setString(_ED._defense_people_name)
    -- Label_2p_name:setString(_ED.battleData.defender_name)
    -- -- 绘制速度
    -- local Label_1p_speed_n = ccui.Helper:seekWidgetByName(root, "Label_1p_speed_n")
    -- Label_1p_speed_n:setString(_ED.battleData.attacker_priority)

    -- local Label_2p_speed_n = ccui.Helper:seekWidgetByName(root, "Label_2p_speed_n")
    -- Label_2p_speed_n:setString(_ED.battleData.defender_priority)

    local attacker = self._attackers[1]
    local defender = self._defenders[1]

    self:updateHeadDraw()
    self:updateHpDraw({_role={_hp = attacker._hp}, _brole = {_hp = attacker._hp}}, {_role={_hp = defender._hp}, _brole = {_hp = defender._hp}})
    self:updateSpDraw({_role={_sp = attacker._sp}}, {_role={_sp = defender._sp}})
    self:updateDrawRoundCount(0)
end

function TheKingsBattleUIWindow:updateDrawCampInfo(params)
    local camp = params
    if camp == 0 then
        local attacker = table.remove(self._attackers, 1, 1)

        attacker.__death = true
        table.insert(self._attackers, attacker)
    elseif camp == 1 then
        local defender = table.remove(self._defenders, 1, 1)

        defender.__death = true
        table.insert(self._defenders, defender)
    end
    self:updateHeadDraw()
end

function TheKingsBattleUIWindow:updateWinDraw( params )
    local root = self.roots[1]
    local Panel_winner = ccui.Helper:seekWidgetByName(root, "Panel_winner")
    
    Panel_winner:setVisible(true)

    local ArmatureNode_winner = Panel_winner:getChildByName("ArmatureNode_winner")

    draw.initArmature(ArmatureNode_winner, nil, -1, 0, 1)
    csb.animationChangeToAction(ArmatureNode_winner, params, params + 1, true)
    ArmatureNode_winner._actionIndex = 0
    ArmatureNode_winner._invoke = function(armatureBack)
        ccui.Helper:seekWidgetByName(root, "Panel_closed"):setVisible(true)
    end
end

function TheKingsBattleUIWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/BattleofKings/battle_of_kings_battle_UI.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    ccui.Helper:seekWidgetByName(root, "Button_10871"):setVisible(true)
    ccui.Helper:seekWidgetByName(root, "Button_zidong"):setVisible(false)

    -- 战斗跳过
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_10871"), nil, 
    {
        terminal_name = "the_kings_battle_ui_skeep_fighting_copy",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 0)

    -- 退出战斗
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_closed"), nil, 
    {
        terminal_name = "the_kings_battle_ui_window_out",
        terminal_state = 0, 
        -- isPressedActionEnabled = true
    }, nil, 0)

    self:onUpdateDraw()
end

function TheKingsBattleUIWindow:onExit()
    state_machine.remove("the_kings_battle_ui_window_update_draw_hp")
    state_machine.remove("the_kings_battle_ui_window_update_draw_sp")
    state_machine.remove("the_kings_battle_ui_window_update_draw_round_count")
    state_machine.remove("the_kings_battle_ui_window_update_draw_camp_info")
    state_machine.remove("the_kings_battle_ui_window_update_draw_win")
    state_machine.remove("the_kings_battle_ui_window_out")
end
