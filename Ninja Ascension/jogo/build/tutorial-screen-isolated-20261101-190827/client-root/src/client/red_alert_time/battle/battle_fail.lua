-----------------------------
--战斗失败
-----------------------------
BattleFail = class("BattleFailClass", Window)

--打开战斗失败界面
local battle_fail_window_open_terminal = {
    _name = "battle_fail_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("battle_ui_window_close", 0, 0)
        local _window = fwin:find("BattleFailClass")
        if nil == _window then
            fwin:open(BattleFail:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭战斗失败界面
local battle_fail_window_close_terminal = {
    _name = "battle_fail_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleFailClass"))
        clearMission()
        -- cacher.removeAllTextures()
        -- fwin:reset(nil)
        fwin:removeAll()
        cacher.destorySystemCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_fail_window_open_terminal)
state_machine.add(battle_fail_window_close_terminal)
state_machine.init()

function BattleFail:ctor()
    self.super:ctor()
    self.roots = {}

    --load lua file
    app.load("client.red_alert_time.formation.FormationSetting")
    app.load("client.red_alert_time.hero.HeroMain")
    app.load("client.red_alert_time.packs.equipstorage.Equipment")  
    app.load("client.red_alert_time.horse.RacecourseRide")
    app.load("client.red_alert_time.god_weaponry.GodWeaponry")
  
    -- Initialize battle_fail state machine.
    local function init_battle_fail_terminal()
        --将领
        local battel_fail_to_hero_terminal = {
            _name = "battel_fail_to_hero",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("battle_fail_window_close")
                state_machine.excute("battel_fail_button_goto_the_way",0,{2})
                -- if _ED._battle_init_type == battle_enum._fight_type._fight_type_10
                --     or _ED._battle_init_type == battle_enum._fight_type._fight_type_23 then
                --     _ED.national_truce_short_type = 1
                -- else
                    state_machine.excute("hero_main_window_open",0,"")  
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --装备
        local battel_fail_to_equip_terminal = {
            _name = "battel_fail_to_equip",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("battle_fail_window_close")
                fwin:removeAll()
                state_machine.excute("battel_fail_button_goto_the_way",0,{3})
                -- if _ED._battle_init_type == battle_enum._fight_type._fight_type_10
                --     or _ED._battle_init_type == battle_enum._fight_type._fight_type_23 then
                --     _ED.national_truce_short_type = 2
                -- else
                    state_machine.excute("equipment_window_open",0,"")
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --阵型
        local battel_fail_to_formation_terminal = {
            _name = "battel_fail_to_formation",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("battle_fail_window_close")
                fwin:removeAll()
                state_machine.excute("battel_fail_button_goto_the_way",0,{4})
                -- if _ED._battle_init_type == battle_enum._fight_type._fight_type_10
                --     or _ED._battle_init_type == battle_enum._fight_type._fight_type_23 then
                --     _ED.national_truce_short_type = 3
                -- else
                    state_machine.excute("formation_setting_window_open",0,"")
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 珍兽
        local battel_fail_to_treasure_ride_terminal = {
            _name = "battel_fail_to_treasure_ride",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("battle_fail_window_close")
                fwin:removeAll()
                state_machine.excute("battel_fail_button_goto_the_way",0,{5})
                -- if _ED._battle_init_type == battle_enum._fight_type._fight_type_10
                --     or _ED._battle_init_type == battle_enum._fight_type._fight_type_23 then
                --     _ED.national_truce_short_type = 4
                -- else
                    state_machine.excute("racecourse_ride_window_open",0,"")
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 神兵  
        local battel_fail_to_god_weaponry_terminal = {
            _name = "battel_fail_to_god_weaponry",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("battle_fail_window_close")
                fwin:removeAll()
                -- if _ED._battle_init_type == battle_enum._fight_type._fight_type_10
                --     or _ED._battle_init_type == battle_enum._fight_type._fight_type_23 then
                --     state_machine.excute("battel_fail_button_goto_the_way",0,{6})   
                --     _ED.national_truce_short_type = 5
                -- else
                    local list = getGodWeaponrySortForFight()
                    -- 有蓝三星以上侠客打开兵器谱,没有打开兵器谱入口
                    if table.nums(list) == 0 then
                        state_machine.excute("main_window_open",0,"")
                        state_machine.excute("home_select_action_window_open",0,{16})
                    else
                        state_machine.excute("battel_fail_button_goto_the_way",0,{6})  
                        state_machine.excute("god_weaponry_window_open",0,"")
                    end
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 退出
        local battel_fail_button_close_terminal = {
            _name = "battel_fail_button_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("battle_fail_window_close")
                fwin:removeAll()
                fwin:freeAllMemeryPool()
                state_machine.excute("battel_fail_button_goto_the_way",0,{1})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(battel_fail_to_hero_terminal)
        state_machine.add(battel_fail_to_equip_terminal)
        state_machine.add(battel_fail_to_formation_terminal)
        state_machine.add(battel_fail_button_close_terminal)
        state_machine.add(battel_fail_to_treasure_ride_terminal)
        state_machine.add(battel_fail_to_god_weaponry_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_battle_fail_terminal()
end


function BattleFail:onUpdateDraw()
    local root = self.roots[1]
    -- 绘制主公动画
    local Panel_player_role = ccui.Helper:seekWidgetByName(root,"Panel_player_role")
    if nil ~= Panel_player_role and Panel_player_role:isVisible() == true then
        local jsonPath = nil
        local atlasPath = nil
        if tonumber(_ED.user_info.user_gender) == 1 then
            jsonPath = "sprite/spirte_nanzhu.json"
            atlasPath = "sprite/spirte_nanzhu.atlas"
        elseif tonumber(_ED.user_info.user_gender) == 2 then
            jsonPath = "sprite/spirte_nvzhu.json"
            atlasPath = "sprite/spirte_nvzhu.atlas"
        end
        local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", false, nil)
        animation:setPosition(cc.p(Panel_player_role:getContentSize().width / 2, 0))
        Panel_player_role:addChild(animation)
    end
end

--播放战斗失败动画
function BattleFail:onEnterTransitionFinish()
    local root = self.roots[1]
    local Panel_open = ccui.Helper:seekWidgetByName(root, "Panel_open")
    local Panel_fail = ccui.Helper:seekWidgetByName(root, "Panel_fail")
    local ArmatureNode_1 = Panel_open:getChildByName("ArmatureNode_1")
    local ArmatureNode_1_0 = Panel_fail:getChildByName("ArmatureNode_1_0")
    Panel_open:setVisible(true)
    if nil ~= ArmatureNode_1 then
        local animation = ArmatureNode_1:getAnimation()
        local animation_2 = ArmatureNode_1_0:getAnimation()
        local animationEventCallFunc = function()
            Panel_open:setVisible(false)
            Panel_fail:setVisible(true)
            animation_2:playWithIndex(1, 0, -1)
        end 
        animation:playWithIndex(0, 0, 0)
        animation:setMovementEventCallFunc(animationEventCallFunc)
    end
end

--初始化界面
function BattleFail:onInit( )
    local csbItem = csb.createNode(config_csb.battle.battle_fail)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_victory_in_battle_go_on"), nil, 
    {
        terminal_name = "battel_fail_button_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --英雄
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_victory_hero"), nil, 
    {
        terminal_name = "battel_fail_to_hero", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    

    --装备
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_victory_equipment"), nil, 
    {
        terminal_name = "battel_fail_to_equip", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    

    --阵型
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_victory_line"), nil, 
    {
        terminal_name = "battel_fail_to_formation", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    

    --珍兽
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_victory_racecourse"), nil, 
    {
        terminal_name = "battel_fail_to_treasure_ride", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)   

    --神兵
    local Button_victory_god_weaponry = ccui.Helper:seekWidgetByName(root,"Button_victory_god_weaponry")
    Button_victory_god_weaponry:setVisible(false)
    if funOpenDrawTip(86,false) == false then 
        Button_victory_god_weaponry:setVisible(true)
    end 
        fwin:addTouchEventListener(Button_victory_god_weaponry, nil, 
        {
            terminal_name = "battel_fail_to_god_weaponry", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0) 

    self:onUpdateDraw() 
end


function BattleFail:init()
    self:onInit()
    return self
end

--关闭战斗失败界面
function BattleFail:destroy()
 
end

--移除状态机
function BattleFail:onExit()
    state_machine.remove("battel_fail_to_hero")
    state_machine.remove("battel_fail_to_equip")
    state_machine.remove("battel_fail_to_formation")
    state_machine.remove("battel_fail_button_close")
    state_machine.remove("battel_fail_to_treasure_ride")
    state_machine.remove("battel_fail_to_god_weaponry")
end
