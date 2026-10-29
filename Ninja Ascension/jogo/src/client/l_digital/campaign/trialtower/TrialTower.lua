-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双主界面
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

TrialTower = class("TrialTowerClass", Window)
TrialTower.npcs = {}

function TrialTower:ctor()
    self.super:ctor()
    app.load("client.l_digital.campaign.trialtower.JiangLi")
    app.load("client.l_digital.campaign.trialtower.GuanQia")
    app.load("client.l_digital.campaign.trialtower.PaiHang")
    app.load("client.l_digital.campaign.trialtower.TrialTowerShop")
    app.load("client.l_digital.campaign.trialtower.AttributeAddition")
    app.load("client.l_digital.campaign.trialtower.AdditionSelect")
    app.load("client.l_digital.campaign.trialtower.TrialTowerRewardBox")
    app.load("client.l_digital.campaign.trialtower.TrialTowerLostTreasure")
    app.load("client.l_digital.campaign.trialtower.TrialTowerSpoilsReport")
    app.load("client.l_digital.campaign.trialtower.SmTrialTowerRweepTip")
    app.load("client.l_digital.campaign.trialtower.SmTrialTowerRule")
    app.load("client.l_digital.campaign.trialtower.SmTrialTowerTanking")
    app.load("client.l_digital.campaign.trialtower.SmTrialTowerReward")
    app.load("client.l_digital.campaign.trialtower.SmTrialTowerSkipTip")
    app.load("client.l_digital.campaign.trialtower.SmTrialTowerSweep")
    app.load("client.l_digital.campaign.trialtower.SmTrialTowerSweepInfo")
    app.load("client.l_digital.campaign.trialtower.SmTrialTowerVipSkipTip")
    app.load("client.l_digital.cells.campaign.sm_trial_tower_floor_list_cell")
    app.load("client.l_digital.cells.campaign.sm_trial_tower_sweep_list_cell")
    app.load("client.l_digital.cells.campaign.sm_trial_tower_Addition_cell")
    app.load("client.battle.BattleStartEffect")
    
    self.ListView_tower = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    
    self.roots = {}
    self.cellHeight = 0

    self._moveIndex = 0
    self._movePosY = 0

    -- 此变量用于客户端扩展试练塔最大层数
    self._MAX_FLOOR = dms.count(dms["three_kingdoms_config"])
 
    local function init_trial_tower_terminal()
        --返回
        local trial_tower_back_activity_terminal = {
            _name = "trial_tower_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.unlock("explore_window_open_fun_window")
                if nil == fwin:find("ExploreWindowClass") then
                    state_machine.excute("explore_window_open", 0, "") 
                end
                fwin:close(fwin:find("TrialTowerClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local trial_tower_insert_new_cell_data_terminal = {
            _name = "trial_tower_insert_new_cell_data",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawUserInfo()
                local index = #instance.ListView_tower:getItems()+1
                _ED.integral_current_index = tonumber(_ED.three_kingdoms_view.current_floor) + 1
                
                if _ED.integral_current_index > self._MAX_FLOOR then
                    local cells = instance.ListView_tower:getItem(0)
                    if cells ~= nil and cells.clearUIInfo ~= nil then
                        cells:clearUIInfo()
                    end
                    for i,v in pairs(instance.ListView_tower:getItems()) do
                        v:updateNextFloor(tonumber(_ED.integral_current_index))
                    end
                    state_machine.unlock("sm_trial_tower_floor_list_cell_check")
                    _ED.sm_trial_tower_floor_click_on = false
                else
                    local beginPosY = instance.currentInnerContainer:getPositionY()
                    if index <= self._MAX_FLOOR then
                        local cell = state_machine.excute("sm_trial_tower_floor_list_cell",0,{index,tonumber(_ED.integral_current_index)})
                        instance.ListView_tower:insertCustomItem(cell, 0)
                        -- instance.ListView_tower:requestRefreshView()
                        instance.currentInnerContainer:setPositionY(beginPosY)
                    end
                    fwin:addService({
                        callback = function ( params )
                            if params ~= nil and params.roots ~= nil and params.roots[1] ~= nil then
                                params.currentInnerContainer:setPositionY(beginPosY)
                                
                                local posY = -params.cellHeight * (tonumber(_ED.integral_current_index) - 2)
                                posY = posY - 40
                                if posY > 0 then
                                    posY = 0
                                end
                                if posY < -params.cellHeight * (self._MAX_FLOOR - 1) then
                                    posY = -params.cellHeight * (self._MAX_FLOOR - 1)
                                end
                                params._moveIndex = 25
                                params._movePosY = (posY - beginPosY)/params._moveIndex
                                
                                local cells = params.ListView_tower:getItem(#params.ListView_tower:getItems()-tonumber(_ED.integral_current_index)+1)
                                if cells ~= nil and cells.clearUIInfo ~= nil then
                                    cells:clearUIInfo()
                                end
                                for i,v in pairs(params.ListView_tower:getItems()) do
                                    v:updateNextFloor(tonumber(_ED.integral_current_index))
                                end
                            end
                        end,
                        delay = 0.01,
                        params = instance
                    })
                    fwin:addService({
                        callback = function ( params )
                            state_machine.unlock("sm_trial_tower_floor_list_cell_check")
                            _ED.sm_trial_tower_floor_click_on = false
                        end,
                        delay = 0.5,
                        params = instance
                    })
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local trial_tower_draw_sprite_terminal = {
            _name = "trial_tower_draw_sprite",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local maxHeight = #instance.ListView_tower:getItems()*instance.cellHeight

                local scheduler2 = cc.Director:getInstance():getScheduler()  
                local schedulerID2 = nil  
                schedulerID2 = scheduler2:scheduleScriptFunc(function ()
                        if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                            --yi格的距离
                            local moveDistance = instance.cellHeight/(maxHeight-instance.cellHeight)*100
                            local m_offset = moveDistance*3
                            local m_offset = moveDistance*3
                            if tonumber(_ED.integral_current_index) < 3 then
                                m_offset = -moveDistance
                            elseif tonumber(_ED.integral_current_index) < 9 then
                                m_offset = 0
                            elseif tonumber(_ED.integral_current_index) < 21 then  
                                m_offset = moveDistance     
                            elseif tonumber(_ED.integral_current_index) < 30 then    
                                m_offset = moveDistance*2     
                            end
                            local addX = 0
                            if tonumber(_ED.integral_current_index) >= 52 then
                                addX = -3
                            end
                            local percents = (#instance.ListView_tower:getItems() - tonumber(_ED.integral_current_index)+1)*moveDistance - m_offset - addX
                            -- local percents = math.floor(100-(tonumber(_ED.integral_current_index)-1)/#instance.ListView_tower:getItems()*100) + math.floor(instance.cellHeight/maxHeight*100)
                            if percents <= 0 then
                            elseif percents >= 100 then
                                percents = 99
                                instance.ListView_tower:scrollToPercentVertical(percents,0,false)
                            else
                                instance.ListView_tower:scrollToPercentVertical(percents,0,false)
                            end
                        end

                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID2)
                      
                end,0,false)               

                
                if tonumber(_ED.integral_current_index) <= 57 then
                    local scheduler = cc.Director:getInstance():getScheduler()  
                    local schedulerID = nil  
                    schedulerID = scheduler:scheduleScriptFunc(function ()
                            if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                                --yi格的距离
                                local moveDistance = instance.cellHeight/maxHeight*100
                                local m_offset = moveDistance*3
                                local m_offset = moveDistance*3
                                if tonumber(_ED.integral_current_index) < 3 then
                                    m_offset = -moveDistance
                                elseif tonumber(_ED.integral_current_index) < 9 then
                                    m_offset = 0
                                elseif tonumber(_ED.integral_current_index) < 21 then  
                                    m_offset = moveDistance     
                                elseif tonumber(_ED.integral_current_index) < 30 then    
                                    m_offset = moveDistance*2     
                                end
                                local addX = 0
                                if tonumber(_ED.integral_current_index) >= 52 then
                                    addX = -3
                                end
                                local percents2 = (#instance.ListView_tower:getItems() - tonumber(_ED.integral_current_index))*moveDistance - m_offset - addX
                                -- local percents2 = math.floor(100-(tonumber(_ED.integral_current_index))/#instance.ListView_tower:getItems()*100) + math.floor(instance.cellHeight/maxHeight*100)
                                if percents2 <= 0 then
                                    percents2 = 1
                                elseif percents2 >= 100 then
                                    percents2 = 99
                                end
                                instance.ListView_tower:scrollToPercentVertical(percents2,1,true)
                            end

                            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)
                          
                    end,0.5,false)
                end

                local datas = instance.ListView_tower:getItem(#instance.ListView_tower:getItems()-tonumber(_ED.integral_current_index)+1)
                local Panel_player = ccui.Helper:seekWidgetByName(datas.roots[1], "Panel_player")
                if Panel_player ~= nil then
                    Panel_player:removeAllChildren(true)
                end
                local Panel_gx_di = ccui.Helper:seekWidgetByName(datas.roots[1], "Panel_gx_di")
                if Panel_gx_di ~= nil then
                    Panel_gx_di:removeAllChildren(true)
                end

                local Panel_enemy = ccui.Helper:seekWidgetByName(datas.roots[1], "Panel_enemy")
                if Panel_enemy ~= nil then
                    Panel_enemy:removeAllChildren(true)
                end
                local Image_buff = ccui.Helper:seekWidgetByName(datas.roots[1], "Image_buff")
                if Image_buff ~= nil then
                    Image_buff:setVisible(false)
                end
                local Image_box = ccui.Helper:seekWidgetByName(datas.roots[1], "Image_box")
                if Image_box ~= nil then
                    Image_box:setVisible(false)
                end
                local Panel_gx = ccui.Helper:seekWidgetByName(datas.roots[1], "Panel_gx")
                if Panel_gx ~= nil then
                    Panel_gx:removeAllChildren(true)
                end

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                    or __lua_project_id == __lua_project_l_naruto
                    then
                    for i,v in pairs(instance.ListView_tower:getItems()) do
                        v:updateDraw(tonumber(_ED.integral_current_index))
                    end
                else
                    local function changeActionCallback( armatureBack ) 
                        local function changeActionCallbackTwo( armatureBack ) 
                            for i,v in pairs(instance.ListView_tower:getItems()) do
                                v:updateDraw(tonumber(_ED.integral_current_index))
                            end
                            armatureBack:removeFromParent(true)
                        end

                        local datas = instance.ListView_tower:getItem(#instance.ListView_tower:getItems()-tonumber(_ED.integral_current_index))
                        if datas~= nil then
                            local Panel_player = ccui.Helper:seekWidgetByName(datas.roots[1], "Panel_player")
                            if Panel_player ~= nil then
                                Panel_player:removeAllChildren(true)
                            end
                            local Panel_gx_di = ccui.Helper:seekWidgetByName(datas.roots[1], "Panel_gx_di")
                            if Panel_gx_di ~= nil then
                                Panel_gx_di:removeAllChildren(true)

                                local jsonFile = "sprite/sprite_chuansong.json"
                                local atlasFile = "sprite/sprite_chuansong.atlas"
                                local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                                animation2.animationNameList = {"animation"}
                                sp.initArmature(animation2, false)
                                animation2._invoke = changeActionCallbackTwo
                                Panel_gx_di:addChild(animation2)
                                animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                                csb.animationChangeToAction(animation2, 0, 0, false)
                            end
                        end
                        armatureBack:removeFromParent(true)
                    end
                    if Panel_gx_di ~= nil then
                        local jsonFile = "sprite/sprite_chuansong.json"
                        local atlasFile = "sprite/sprite_chuansong.atlas"
                        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                        animation.animationNameList = {"animation"}
                        sp.initArmature(animation, false)
                        animation._invoke = changeActionCallback
                        Panel_gx_di:addChild(animation)
                        animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                        csb.animationChangeToAction(animation, 0, 0, false)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_trial_tower_hide_terminal = {
            _name = "sm_trial_tower_hide",
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

        local sm_trial_tower_show_terminal = {
            _name = "sm_trial_tower_show",
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

        local sm_trial_tower_open_shop_window_terminal = {
            _name = "sm_trial_tower_open_shop_window",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("shop_window_open",0,{close_terminal_name = "sm_trial_tower_shop_back", shop_page = 4})
                state_machine.excute("sm_trial_tower_hide", 0, 0)

                state_machine.excute("shop_manager", 0, 
                    {
                        _datas = {
                            terminal_name = "shop_manager",     
                            next_terminal_name = "shop_prop_buy",
                            current_button_name = "Button_props",  
                            but_image = "prop",      
                            terminal_state = 0, 
                            shop_type = "shop",
                            isPressedActionEnabled = false
                        }
                    }
                )
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_trial_tower_shop_back_terminal = {
            _name = "sm_trial_tower_shop_back",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("shop_window_close", 0, 0)
                state_machine.excute("sm_trial_tower_show", 0, 0)
                -- LA BARRA DE MONEDAS DE PRUEBA, al volver de la
                -- tienda. El boton Button_shop de la Torre NO abre
                -- TrialTowerShop: abre la ventana general de tienda
                -- en su pagina 4 (:351), que es la Tienda de Prueba
                -- (C2S 211, glories_shop). Su respuesta S2C 304 ya
                -- deja el saldo nuevo en _ED.user_info.all_glories
                -- (ProtocolParser.lua:491-494), pero esta pantalla
                -- solo se volvia a hacer visible y seguia pintando
                -- el numero viejo hasta salir y entrar.
                if instance ~= nil and instance.roots ~= nil
                    and instance.roots[1] ~= nil then
                    instance:updateDrawUserInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- LA BARRA DE MONEDAS DE LA TORRE NO SE REFRESCABA al volver de su
        -- tienda: la tienda avisa con `trial_tower_buy_updatenumber`
        -- (`TrialTowerShop.lua:1028`) y esta ventana lo QUITA al salir
        -- (:883) pero nunca lo daba de alta, asi que el aviso no llegaba
        -- a nadie y el saldo se quedaba con el valor de antes hasta salir
        -- y volver a entrar. El saldo nuevo ya viaja en el S2C 304.
        local trial_tower_buy_updatenumber_terminal = {
            _name = "trial_tower_buy_updatenumber",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawUserInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_trial_tower_update_info_terminal = {
            _name = "sm_trial_tower_update_info",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawUserInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新BUFF显示
        local sm_trial_tower_update_buff_info_terminal = {
            _name = "sm_trial_tower_update_buff_info",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawBuffInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_trial_tower_update_all_info_terminal = {
            _name = "sm_trial_tower_update_all_info",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updataDraw()
                end
                state_machine.excute("sm_trial_tower_update_info", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(trial_tower_back_activity_terminal)
        state_machine.add(trial_tower_insert_new_cell_data_terminal)
        state_machine.add(trial_tower_draw_sprite_terminal)
        state_machine.add(sm_trial_tower_hide_terminal)
        state_machine.add(sm_trial_tower_show_terminal)
        state_machine.add(sm_trial_tower_open_shop_window_terminal)
        state_machine.add(sm_trial_tower_shop_back_terminal)
        state_machine.add(trial_tower_buy_updatenumber_terminal)
        state_machine.add(sm_trial_tower_update_info_terminal)
        state_machine.add(sm_trial_tower_update_buff_info_terminal)
        state_machine.add(sm_trial_tower_update_all_info_terminal)
        state_machine.init()
    end
    
    
    -- call func init hom state machine.
    init_trial_tower_terminal()
end

function TrialTower:updataDraw()
    local root = self.roots[1]
    self.ListView_tower = ccui.Helper:seekWidgetByName(root, "ListView_tower")
    self.ListView_tower:removeAllItems()

    local maxCount = 0
    if tonumber(_ED.integral_current_index) + 8 > self._MAX_FLOOR then
        maxCount = self._MAX_FLOOR
    else
        maxCount = tonumber(_ED.integral_current_index) + 8
    end
    for i=1,maxCount do
        local cell = state_machine.excute("sm_trial_tower_floor_list_cell",0,{i,tonumber(_ED.integral_current_index)})
        if i == 1 then
            self.ListView_tower:addChild(cell)
        else
            self.ListView_tower:insertCustomItem(cell, 0)
        end
        -- self.ListView_tower:requestRefreshView()
        if self.cellHeight == 0 then
            self.cellHeight = cell:getContentSize().height
        end
    end

    self.currentInnerContainer = self.ListView_tower:getInnerContainer()
    local posY = -self.cellHeight * (tonumber(_ED.integral_current_index) - 2)
    posY = posY - 40
    if posY > 0 then
        posY = 0
    end
    if posY < -self.cellHeight * (self._MAX_FLOOR - 1) then
        posY = -self.cellHeight * (self._MAX_FLOOR - 1)
    end
    fwin:addService({
        callback = function ( params )
            if params ~= nil and params.roots ~= nil and params.roots[1] ~= nil then
                if _ED.integral_current_index >= self._MAX_FLOOR then
                    params.ListView_tower:jumpToTop()
                else
                    params.currentInnerContainer:setPositionY(posY)
                end
            end
        end,
        delay = 0.01,
        params = self
    })
    -- self.currentInnerContainerPosY = -9999--self.currentInnerContainer:getPositionY()

    local Panel_player_ziji = ccui.Helper:seekWidgetByName(root, "Panel_player_ziji")
    if Panel_player_ziji ~= nil then
        Panel_player_ziji:removeAllChildren(true)
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
        local armature_hero = sp.spine_sprite(Panel_player_ziji, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        armature_hero:setScaleX(-1)
        armature_hero.animationNameList = spineAnimations
        sp.initArmature(armature_hero, true)
    end
end

function TrialTower:onUpdate( dt )
    if self.ListView_tower ~= nil and self.currentInnerContainer ~= nil then
        local size = self.ListView_tower:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self._moveIndex > 0 then
            self._moveIndex = self._moveIndex - 1
            self.currentInnerContainer:setPositionY(posY + self._movePosY)
        end
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.ListView_tower:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function TrialTower:updateDrawUserInfo()
    local root = self.roots[1]

    --用户银币
    local Text_jinbi_n = ccui.Helper:seekWidgetByName(root, "Text_jinbi_n")
    -- if zstring.tonumber( _ED.user_info.user_silver) > 100000000 then
    --     Text_jinbi_n:setString(math.floor(_ED.user_info.user_silver/ 100000000) .. string_equiprety_name[39])
    -- else
    if zstring.tonumber( _ED.user_info.user_silver)> 10000 then
        Text_jinbi_n:setString(math.floor(_ED.user_info.user_silver / 1000) .. string_equiprety_name[40])
    else
        Text_jinbi_n:setString(_ED.user_info.user_silver)
    end
    -- Text_jinbi_n:setString(_ED.user_info.user_silver)
    --用户宝石
    local Text_zuanshi_n =  ccui.Helper:seekWidgetByName(root, "Text_zuanshi_n")
    -- if zstring.tonumber( _ED.user_info.user_gold) > 100000000 then
    --     Text_zuanshi_n:setString(math.floor(_ED.user_info.user_gold / 100000000) .. string_equiprety_name[39])
    -- else
    if zstring.tonumber( _ED.user_info.user_gold)> 1000000 then
        Text_zuanshi_n:setString(math.floor(_ED.user_info.user_gold / 1000) .. string_equiprety_name[40])
    else
        Text_zuanshi_n:setString(_ED.user_info.user_gold)
    end
    -- Text_zuanshi_n:setString(_ED.user_info.user_gold)
    --用户的试炼币
    local Text_shilianbi_n = ccui.Helper:seekWidgetByName(root, "Text_shilianbi_n")
    Text_shilianbi_n:setString(zstring.tonumber(_ED.user_info.all_glories))
    --用户试炼星星
    local Text_star_n = ccui.Helper:seekWidgetByName(root, "Text_star_n")
    Text_star_n:setString(_ED.three_kingdoms_view.current_max_stars)
    --用户试炼积分
    local Text_jifen = ccui.Helper:seekWidgetByName(root, "Text_jifen")
    local percent = dms.float(dms["play_config"], 54, play_config.param)
    
    Text_jifen:setString(_ED.user_try_to_score_points)
end

function TrialTower:updateDrawBuffInfo()
    local root = self.roots[1]
    local Image_buff_view = ccui.Helper:seekWidgetByName(root, "Image_buff_view")
    local addBuff = {}
    local m_index = 0
    for j, w in pairs(_ED.three_kingdoms_view.atrribute) do
        local id = tonumber(zstring.split(w[1],":")[1])
        local num = tonumber(w[2])
        local list = zstring.split( dms.string(dms["three_kingdoms_attribute"], id, three_kingdoms_attribute.attribute_value),",")
        local atype = tonumber(list[1])
        local avalue = tonumber(list[2])
        if tonumber(list[1]) == 5 or tonumber(list[1]) == 6 or tonumber(list[1]) == 8 or tonumber(list[1]) == 10 or tonumber(list[1]) == 40 or tonumber(list[1]) == 42 then
            avalue = avalue*100
            list[2] = tonumber(list[2])*100
        end
        if addBuff[atype] == nil then
            addBuff[atype] = {}
            addBuff[atype].a_type = atype
            addBuff[atype].a_value = avalue*num    
        else
            addBuff[atype].a_value = addBuff[atype].a_value + avalue*num 
        end
        
    end
    local Text_buff = ccui.Helper:seekWidgetByName(root, "Text_buff")
    Text_buff:removeAllChildren(true)
    local m_height = 0 
    local n_width = 0
    for i,v in pairs(addBuff) do
        m_index = m_index + 1
    end
    if m_index == 0 then
        local char_str = _new_interface_text[231]
        local _richText2 = ccui.RichText:create()
        _richText2:ignoreContentAdaptWithSize(false)

        local richTextWidth = Text_buff:getContentSize().width-n_width
        if richTextWidth == 0 then
            richTextWidth = Text_buff:getFontSize() * 6
        end

        _richText2:setContentSize(cc.size(richTextWidth,Text_buff:getContentSize().height))
        _richText2:setAnchorPoint(cc.p(0, 0))
        local rt, count, text = draw.richTextCollectionMethod(_richText2, 
            char_str, 
            cc.c3b(255,255,255),
            cc.c3b(255,255,255),
            0, 
            0, 
            Text_buff:getFontName(), 
            Text_buff:getFontSize(),
            the_color_of_the_fetters)
        _richText2:formatTextExt()
        local rsize = _richText2:getContentSize()
        _richText2:setPosition(cc.p(n_width,0-m_height))
        Text_buff:addChild(_richText2)

        local newHeight = 0
        newHeight = _richText2:getContentSize().height
        if newHeight > Text_buff:getContentSize().height then
            newHeight = _richText2:getContentSize().height
        else
            newHeight = Text_buff:getContentSize().height
        end
        m_height = m_height + newHeight
    else
        for i,v in pairs(addBuff) do
            local value,name= getTrialtowerAdditionFormatValue(tonumber(v.a_type), tonumber(v.a_value))
            local char_str = skill_attributes_text_tips[tonumber(v.a_type)+1]..value
            local _richText2 = ccui.RichText:create()
            _richText2:ignoreContentAdaptWithSize(false)

            local richTextWidth = Text_buff:getContentSize().width-n_width
            if richTextWidth == 0 then
                richTextWidth = Text_buff:getFontSize() * 6
            end
        
            _richText2:setContentSize(cc.size(richTextWidth,Text_buff:getContentSize().height))
            _richText2:setAnchorPoint(cc.p(0, 0))
            local rt, count, text = draw.richTextCollectionMethod(_richText2, 
                char_str, 
                cc.c3b(255,255,255),
                cc.c3b(255,255,255),
                0, 
                0, 
                Text_buff:getFontName(), 
                Text_buff:getFontSize(),
                the_color_of_the_fetters)
            _richText2:formatTextExt()
            local rsize = _richText2:getContentSize()
            _richText2:setPosition(cc.p(n_width,0-m_height))
            Text_buff:addChild(_richText2)

            local newHeight = 0
            newHeight = _richText2:getContentSize().height
            if newHeight > Text_buff:getContentSize().height then
                newHeight = _richText2:getContentSize().height
            else
                newHeight = Text_buff:getContentSize().height
            end
            m_height = m_height + newHeight
        end
    end

    local up = m_height - (Image_buff_view:getContentSize().height) + Text_buff:getFontSize()
    Image_buff_view:setContentSize(cc.size(Image_buff_view:getContentSize().width,Image_buff_view:getContentSize().height + up))
    Text_buff:setPositionY(Text_buff:getPositionY()+up)
end

function TrialTower:initDate()
    
end

function TrialTower:onEnterTransitionFinish()
    TrialTower.npcs = TrialTower.npcs or {}
    if #TrialTower.npcs == 0 then
        local npcGroup = zstring.split(dms.string(dms["play_config"], 56, pirates_config.param),",")
        for i=1,self._MAX_FLOOR do
            table.insert(TrialTower.npcs, npcGroup[math.random(1,#npcGroup)])
        end
    end
    -- add control layer for trial tower
    local csbTrialTower = csb.createNode("campaign/TrialTower/trial_tower.csb")
    self.csbTrialTower = csbTrialTower
    local csbTrialTower_root = csbTrialTower:getChildByName("root")
    table.insert(self.roots, csbTrialTower_root)
    self:addChild(csbTrialTower)
    self.csbTrialTower_root = csbTrialTower_root
    
    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_back"), nil, 
    {
        terminal_name = "trial_tower_back_activity", 
        isPressedActionEnabled = true
    },
    nil,3)

    --规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_rule"), nil, 
    {
        terminal_name = "sm_trial_tower_rule_open", 
        isPressedActionEnabled = true
    },
    nil,0)

    --排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_rank"), nil, 
    {
        terminal_name = "sm_trial_tower_tanking_open", 
        isPressedActionEnabled = true
    },
    nil,0)

    --商店
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_shop"), nil, 
    {
        terminal_name = "sm_trial_tower_open_shop_window", 
        isPressedActionEnabled = true
    },
    nil,0)

    --奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_reward"), nil, 
    {
        terminal_name = "sm_trial_tower_reward_open", 
        isPressedActionEnabled = true
    },
    nil,0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_trial_tower_reward",
        _widget = ccui.Helper:seekWidgetByName(csbTrialTower_root,"Button_reward"),
        _invoke = nil,
        _interval = 0.5,})

    local ListView_tower = ccui.Helper:seekWidgetByName(csbTrialTower_root, "ListView_tower")
    local function listTouchEvent( sender )
        self._moveIndex = 0
    end
    ListView_tower:addScrollViewEventListener(listTouchEvent)

    if tonumber(_ED.integral_current_index) == 0 then
        _ED.integral_current_index = tonumber(_ED.three_kingdoms_view.current_floor) + 1
    elseif tonumber(_ED.integral_current_index) ~= tonumber(_ED.three_kingdoms_view.current_floor) + 1 then
        _ED.integral_current_index = tonumber(_ED.three_kingdoms_view.current_floor) + 1
    end
    self:updataDraw()
    self:updateDrawUserInfo()
    self:updateDrawBuffInfo()

    local Panel_buff = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Panel_buff")

    local function buffOnTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if ccui.TouchEventType.began == evenType then
            ccui.Helper:seekWidgetByName(csbTrialTower_root, "Image_buff_view"):setVisible(true)
        elseif ccui.TouchEventType.moved == evenType then
            if __lua_project_id == __lua_project_gragon_tiger_gate
                or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_digimon_adventure 
                or __lua_project_id == __lua_project_yugioh
                or __lua_project_id == __lua_project_warship_girl_b 
                then
                if __mpoint.x - __spoint.x > 80 
                    or __mpoint.x - __spoint.x < -80 
                    or __mpoint.y - __spoint.y > 50 
                    or __mpoint.y - __spoint.y < -50 
                    then
                    ccui.Helper:seekWidgetByName(csbTrialTower_root, "Image_buff_view"):setVisible(false)
                end
            end
        elseif ccui.TouchEventType.ended == evenType then
            ccui.Helper:seekWidgetByName(csbTrialTower_root, "Image_buff_view"):setVisible(false)
        end
    end
    Panel_buff:addTouchEventListener(buffOnTouchEvent)

    --如果数据没有说明全部满血
    if _ED.user_try_ship_infos == nil or _ED.user_try_ship_infos == "" or table.nums(_ED.user_try_ship_infos) <= 0 then
        _ED.user_try_ship_infos = {}
    end
    for i, v in pairs(_ED.user_ship) do
        local ships = {}
        ships.newHp = v.ship_health
        ships.maxHp = 100                   --血量的百分比
        ships.newanger = 0
        ships.id = v.ship_id
        if _ED.user_try_ship_infos[""..v.ship_id] == nil then
            _ED.user_try_ship_infos[""..v.ship_id] = ships
        -- else
        --     _ED.user_try_ship_infos[v.ship_id].newHp = tonumber(_ED.user_ship[""..v.ship_id].ship_health)*(tonumber(_ED.user_try_ship_infos[v.ship_id].maxHp)/100)
        end
    end
    -- if tonumber(_ED.one_key_sweep_three_max_pass) > 0 and tonumber(_ED.one_key_sweep_three_max_pass) >= tonumber(_ED.integral_current_index) then
    --     state_machine.excute("sm_trial_tower_skip_tip_open",0,"0")
    -- end
    
    local AtlasLabel_louceng = ccui.Helper:seekWidgetByName(csbTrialTower_root, "AtlasLabel_louceng")
    local m_jump_floor = 0
    local openLevel = dms.int(dms["play_config"], 57, play_config.param)
    if openLevel <= tonumber(_ED.user_info.user_grade) then 
        m_jump_floor = dms.int(dms["base_consume"], 66, base_consume.vip_0_value + tonumber(_ED.vip_grade))
    end
    if tonumber(_ED.three_kings_vip_sweep_state) == 0 then
        local jumpLevel = dms.int(dms["play_config"], 57, play_config.param)
        if tonumber(_ED.integral_current_index) <= 1
            and jumpLevel <= tonumber(_ED.user_info.user_grade)
            then
            local jumpFloor = dms.int(dms["base_consume"], 66, base_consume.vip_0_value + tonumber(_ED.vip_grade))
            m_jump_floor = jumpFloor
            if jumpFloor > 0 then
                state_machine.excute("sm_trial_tower_vip_skip_tip_open", 0, nil)
            end
        end
    elseif tonumber(_ED.three_kings_vip_sweep_state) == 1 then
        state_machine.excute("sm_trial_tower_sweep_window_open", 0, nil)
    end
    if AtlasLabel_louceng then 
       if tonumber(_ED.three_kingdoms_view.current_floor) > m_jump_floor then 
            m_jump_floor = tonumber(_ED.three_kingdoms_view.current_floor)
       end
       AtlasLabel_louceng:setString(m_jump_floor.."")
    end

    -- 彩蛋事件添加
    showEasterEggEvent(6,-1,csbTrialTower_root)
end

function TrialTower:close( ... )

end

function TrialTower:onExit()
    --fwin:close(fwin:find("UserTopInfoAClass"))
    state_machine.remove("trial_tower_buy_lost_treasure_complete")
    state_machine.remove("trial_tower_back_activity")
    state_machine.remove("trial_tower_reward_button")
    state_machine.remove("hero_trial_tower_button")
    state_machine.remove("arrange_trial_tower_button")
    state_machine.remove("shop_trial_tower_button")
    state_machine.remove("AttributeAddition_button")
    state_machine.remove("trial_tower_buy_updatenumber")
    state_machine.remove("trial_tower_one_key_three_star")
    state_machine.remove("sm_trial_tower_hide")
    state_machine.remove("sm_trial_tower_show")
    state_machine.remove("sm_trial_tower_open_shop_window")
    state_machine.remove("sm_trial_tower_shop_back")
    state_machine.remove("sm_trial_tower_update_info")
    state_machine.remove("sm_trial_tower_update_all_info")
end

function TrialTower:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end
