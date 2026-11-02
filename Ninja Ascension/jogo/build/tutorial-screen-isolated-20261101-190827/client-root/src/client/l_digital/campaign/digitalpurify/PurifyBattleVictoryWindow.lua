-- ----------------------------------------------------------------------------------------------------
-- 说明：数码净化战斗胜利
-------------------------------------------------------------------------------------------------------
PurifyBattleVictoryWindow = class("PurifyBattleVictoryWindowClass", Window)

local purify_battle_victory_window_open_terminal = {
    _name = "purify_battle_victory_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:open(PurifyBattleVictoryWindow:new():init(params), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local purify_battle_victory_window_close_terminal = {
    _name = "purify_battle_victory_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("PurifyBattleVictoryWindowClass"))
        -- fwin:removeAll()
        -- cacher.removeAllObject(_object)
        cacher.removeAllTextures()
        fwin:reset(nil)
        -- fwin:removeAll()
        -- app.load("client.home.Menu")
        -- fwin:open(Menu:new(), fwin._taskbar)
        -- if fwin:find("HomeClass") == nil then
        --     state_machine.excute("menu_manager", 0, 
        --         {
        --             _datas = {
        --                 terminal_name = "menu_manager",     
        --                 next_terminal_name = "menu_show_home_page", 
        --                 current_button_name = "Button_home",
        --                 but_image = "Image_home",       
        --                 terminal_state = 0, 
        --                 _needOpenHomeHero = true,
        --                 isPressedActionEnabled = true
        --             }
        --         }
        --     )
        -- end
        -- state_machine.excute("menu_back_home_page", 0, "")
        state_machine.excute("digital_purify_window_open", 0, 0)
        -- state_machine.excute("explore_window_open", 0, "3")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(purify_battle_victory_window_open_terminal)
state_machine.add(purify_battle_victory_window_close_terminal)
state_machine.init()

function PurifyBattleVictoryWindow:ctor()
    self.super:ctor()
    self.roots = {}

    self.rewardNumber = 0
    -- load luf file

    -- var
    
    -- Initialize purify team page state machine.
    local function init_purify_battle_victory_terminal()
        local purify_battle_victory_window_open_chest_terminal = {
            _name = "purify_battle_victory_window_open_chest",
            _init = function (terminal) 
                app.load("client.cells.utils.resources_icon_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = params._datas._page
                local panel = nil
                if page == 1 then
                    panel = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_box_dh_1")
                else
                    panel = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_box_dh_2")
                end
                if panel.isOpened == true then
                    return
                end
                local function responseDigitalPurifyBuyChestCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node == nil or response.node.roots == nil then
                            state_machine.unlock("purify_battle_victory_window_open_chest")
                            return
                        end
                        if ccui.Helper:seekWidgetByName(instance.roots[1], "Button_back"):isVisible() == false then
                            ccui.Helper:seekWidgetByName(instance.roots[1], "Button_back"):setVisible(true)
                        end
                        local position_Panel_box = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_box_"..page)
                        -- for i=1, 2 do
                        --     ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_box_"..i):setTouchEnabled(false)
                        -- end

                        local Panel_box_dh = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_box_dh_"..page)
                        Panel_box_dh:removeAllChildren(true)
                        for i=1, 2 do
                            local Image_zuanshi_icon = ccui.Helper:seekWidgetByName(instance.roots[1], "Image_zuanshi_icon_"..i)
                            local Text_zuanshi_n = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_zuanshi_n_"..i)
                            local panel = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_box_dh_"..i)
                            if i == tonumber(page) or panel.isOpened == true then
                               Image_zuanshi_icon:setVisible(false)
                               Text_zuanshi_n:setVisible(false)
                            else
                                local cost = dms.int(dms["play_config"], 21, play_config.param)
                                Image_zuanshi_icon:setVisible(true) 
                                Text_zuanshi_n:setVisible(true) 
                                Text_zuanshi_n:setString(cost)
                            end
                        end
                        -- 绘制奖励
                        local function changeActionCallbackTwo( armatureBack ) 
                            --
                            -- if instance.rewardNumber == 0 then
                            --     if page == 1 then
                            --         ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_box_2"):setTouchEnabled(true)
                            --     else
                            --         ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_box_1"):setTouchEnabled(true)   
                            --     end
                            -- end
                            local reward = getSceneReward(2)

                            for i=1, tonumber(reward.show_reward_item_count) do
                                local Panel_props = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_props_"..(i+instance.rewardNumber))
                                local cell = ResourcesIconCell:createCell()
                                cell:init(tonumber(reward.show_reward_list[i].prop_type), tonumber(reward.show_reward_list[i].item_value),tonumber(reward.show_reward_list[i].prop_item))
                                -- ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_bg"):removeAllChildren(true)
                                ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_bg"):addChild(cell)
                                cell:setAnchorPoint(0.5,0.5)
                                cell:setVisible(false)
                                cell:ignoreAnchorPointForPosition(false)

                                local MoveTopoint = cc.p(Panel_props:getPositionX(), Panel_props:getPositionY()) 
                                local function playOver()
                                    cell:setPosition(cc.p(position_Panel_box:getPositionX(),position_Panel_box:getPositionY()))
                                    cell:setScale(0.1)
                                    cell:setVisible(true)
                                end
                                local seq = cc.Sequence:create({cc.DelayTime:create(0.25*(i-1)),cc.CallFunc:create(playOver),cc.Spawn:create({cc.ScaleTo:create(0.25, 1),cc.MoveTo:create(0.25, MoveTopoint),
                                            cc.RotateBy:create(0.25, 360)
                                            })})
                                cell:runAction(seq)

                                -- local scheduler = cc.Director:getInstance():getScheduler()  
                                -- local schedulerID = nil  
                                -- schedulerID = scheduler:scheduleScriptFunc(function ()
                                --         print(Panel_box:getPositionX(),Panel_box:getPositionY())
                                --         cell:setPosition(cc.p(Panel_box:getPositionX(),Panel_box:getPositionY()))
                                --         cell:setScale(0.1)
                                --         cell:setVisible(true)
                                --         local MoveTopoint = cc.p(Panel_props:getPositionX(), Panel_props:getPositionY())
                                --         local seq = cc.Sequence:create({cc.DelayTime:create(t/2),cc.CallFunc:create(playOver),cc.Spawn:create({cc.ScaleTo:create(0.25, 1),cc.MoveTo:create(0.25, MoveTopoint),
                                --             cc.RotateBy:create(0.25, 360)
                                --             })})
                                --         cell:runAction(seq)
                                --         cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID)
                                -- end,0.25*(i-1),false)
                            end
                            instance.rewardNumber = instance.rewardNumber + tonumber(reward.show_reward_item_count)
                            armatureBack:pause()
                            state_machine.unlock("purify_battle_victory_window_open_chest")
                        end
                        local jsonFile = "sprite/sprite_baoxiang.json"
                        local atlasFile = "sprite/sprite_baoxiang.atlas"
                        local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "box_open", true, nil)
                        animation2.animationNameList = {"box_open"}
                        sp.initArmature(animation2, false)
                        animation2._invoke = changeActionCallbackTwo
                        Panel_box_dh:addChild(animation2)
                        Panel_box_dh.isOpened = true
                        animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                        animation2:setAnimation(0, "box_open", false)
                    else
                        state_machine.unlock("purify_battle_victory_window_open_chest")    
                    end
                end
                state_machine.lock("purify_battle_victory_window_open_chest")
                -- The original server distinguishes the free and paid chest
                -- by the page; sending it lets the local server reject an
                -- unsupported paid reward without charging or duplicating.
                protocol_command.ship_purify_buy_battle_reward.param_list = tostring(page)
                NetworkManager:register(protocol_command.ship_purify_buy_battle_reward.code, nil, nil, nil, instance, responseDigitalPurifyBuyChestCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(purify_battle_victory_window_open_chest_terminal)
        state_machine.init()
    end
    
    -- call func init purify team state machine.
    init_purify_battle_victory_terminal()
end

function PurifyBattleVictoryWindow:init( params )
    return self
end

function PurifyBattleVictoryWindow:onUpdate(dt)

end

function PurifyBattleVictoryWindow:onUpdateDraw()
    local root = self.roots[1]

    for i=1,2 do
        local Panel_box_dh = ccui.Helper:seekWidgetByName(root, "Panel_box_dh_"..i)
        Panel_box_dh:removeAllChildren(true)

        local jsonFile = "sprite/sprite_baoxiang.json"
        local atlasFile = "sprite/sprite_baoxiang.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_box_dh:addChild(animation)
        Panel_box_dh:setTouchEnabled(true)
    end
end

function PurifyBattleVictoryWindow:onEnterTransitionFinish()
    local csbPurifyBattleVictoryWindow = csb.createNode("campaign/DigitalPurify/digital_purify_battle_victory.csb")
    self:addChild(csbPurifyBattleVictoryWindow)
    local root = csbPurifyBattleVictoryWindow:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("campaign/DigitalPurify/digital_purify_battle_victory.csb")
    self.action = action
    -- action:setTimeSpeed(app.getTimeSpeed())
    csbPurifyBattleVictoryWindow:runAction(action)
    action:gotoFrameAndPlay(0, action:getDuration(), false)

    -- 关闭窗口
    --
    -- El boton de salir SIEMPRE visible. Estaba oculto hasta que un
    -- cofre se abriera con exito, y el cofre solo paga cuando TRES
    -- companeros han gastado sus tres partidas del dia: jugando solo la
    -- pantalla de victoria no tenia ninguna salida y habia que matar la
    -- aplicacion. Medido en el emulador.
    ccui.Helper:seekWidgetByName(root, "Button_back"):setVisible(true)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "purify_battle_victory_window_close", 
        isPressedActionEnabled = true
    },
    nil,0)


    -- 宝箱1
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_box_1"), nil, 
    {
        terminal_name = "purify_battle_victory_window_open_chest", 
        _page = 1,
        isPressedActionEnabled = true,
    },
    nil,0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_box_dh_1"), nil, 
    {
        terminal_name = "purify_battle_victory_window_open_chest", 
        _page = 1,
        isPressedActionEnabled = true,
    },
    nil,0)


    -- 宝箱2
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_box_2"), nil, 
    {
        terminal_name = "purify_battle_victory_window_open_chest", 
        _page = 2,
        isPressedActionEnabled = true
    },
    nil,0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_box_dh_2"), nil, 
    {
        terminal_name = "purify_battle_victory_window_open_chest", 
        _page = 2,
        isPressedActionEnabled = true
    },
    nil,0)

    self:onUpdateDraw()
    local formationInfo = ""
    for i=1, 6 do
        local ship = _ED.purify_user_ship[i]
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
    protocol_command.ship_purify_team_launch.param_list = "" .. _ED.digital_purify_info._team_info.team_type .. "\r\n" .. zstring.concat(_ED.purify_formation_info, ",").."\r\n"..formationInfo
    NetworkManager:register(protocol_command.ship_purify_team_launch.code, nil, nil, nil, self, nil, false, nil)
end

function PurifyBattleVictoryWindow:onExit()
    state_machine.remove("purify_battle_victory_window_open_chest")
end
