-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗失败界面
-------------------------------------------------------------------------------------------------------
TrialTowerBattleLose = class("TrialTowerBattleLoseClass", Window)

local trial_tower_battle_lose_open_terminal = {
    _name = "trial_tower_battle_lose_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		-- Fury: el combate de las torres diaria/semanal se cierra en FuryTowers.lua.
		if _ED.fury_tower_battle ~= nil and FuryTowers_battleEnd ~= nil and FuryTowers_battleEnd(false) then
			return true
		end
		local _homeWindow = fwin:find("TrialTowerBattleLoseClass")
        if nil == _homeWindow then
            local panel = TrialTowerBattleLose:new():init(params)
            fwin:open(panel,fwin._window)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local trial_tower_battle_lose_close_terminal = {
    _name = "trial_tower_battle_lose_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("TrialTowerBattleLoseClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("TrialTowerBattleLoseClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(trial_tower_battle_lose_open_terminal)
state_machine.add(trial_tower_battle_lose_close_terminal)
state_machine.init()
    
function TrialTowerBattleLose:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.ship.hero_icon_list_cell")
    app.load("client.cells.ship.ship_icon_cell")

    local function init_trial_tower_battle_lose_terminal()
        -- 显示界面
        local trial_tower_battle_lose_display_terminal = {
            _name = "trial_tower_battle_lose_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local TrialTowerBattleLoseWindow = fwin:find("TrialTowerBattleLoseClass")
                if TrialTowerBattleLoseWindow ~= nil then
                    TrialTowerBattleLoseWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local trial_tower_battle_lose_hide_terminal = {
            _name = "trial_tower_battle_lose_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local TrialTowerBattleLoseWindow = fwin:find("TrialTowerBattleLoseClass")
                if TrialTowerBattleLoseWindow ~= nil then
                    TrialTowerBattleLoseWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --退出
        local trial_tower_battle_lose_drop_out_terminal = {
            _name = "trial_tower_battle_lose_drop_out",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
				fwin:close(fwin:find("BattleSceneClass"))
				fwin:removeAll()
				app.load("client.home.Menu")
				fwin:open(Menu:new(), fwin._taskbar)
				app.load("client.l_digital.campaign.trialtower.TrialTower")
				fwin:open(TrialTower:new(), fwin._ui) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --跳转到 武将商店招募
        local trial_tower_battle_lose_open_hero_shop_terminal = {
            _name = "trial_tower_battle_lose_open_hero_shop",
            _init = function (terminal) 
                 app.load("client.shop.Shop")
                 app.load("client.home.Menu")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(fwin:find("FightUIClass"))
                cacher.removeAllTextures()
                fwin:reset(nil)

                app.load("client.home.Menu")
                fwin:open(Menu:new(), fwin._taskbar)
                    
                local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.NewRecruit)
                if fun_is_open == true then
                    app.load("client.home.Menu")
                    fwin:open(Menu:new(), fwin._taskbar)

                    if fwin:find("HomeClass") == nil then
                        state_machine.excute("menu_manager", 0, 
                            {
                                _datas = {
                                    terminal_name = "menu_manager",     
                                    next_terminal_name = "menu_show_home_page", 
                                    current_button_name = "Button_home",
                                    but_image = "Image_home",       
                                    terminal_state = 0, 
                                    isPressedActionEnabled = true
                                }
                            }
                        )
                    end
                    local trace_id = 22
                    state_machine.excute("shortcut_function_trace", 0, {trace_function_id = nil, _datas = {traceId = trace_id}})
                else
                    local _shop = Shop:new()
                    _shop:init(1)
                    fwin:open(_shop, fwin._view)

                    state_machine.excute("shop_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "shop_manager",     
                                next_terminal_name = "shop_ship_recruit",
                                current_button_name = "Button_tavern",  
                                but_image = "recruit",
                                terminal_state = 0, 
                                shop_type = "zhaomu",
                                isPressedActionEnabled = true
                            }
                        }
                    )
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --跳转到 强化装备
        local trial_tower_battle_lose_open_equipment_terminal = {
            _name = "trial_tower_battle_lose_open_equipment",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(fwin:find("FightUIClass"))
                cacher.removeAllTextures()
                fwin:reset(nil)
                app.load("client.home.Menu")
                fwin:open(Menu:new(), fwin._taskbar)
                local ship = nil
                for i, v in pairs(_ED.user_formetion_status) do
                    if zstring.tonumber(v) > 0 then
                        ship = _ED.user_ship[""..v]
                        break
                    end
                end
                
                if fwin:find("HeroIconListViewClass") == nil then
                    app.load("client.packs.hero.HeroIconListView")
                    state_machine.excute("hero_icon_listview_open",0,ship)
                    fwin:find("HeroIconListViewClass"):setVisible(false)
                end

                --武将装备数据(等级|品质|经验|星级|模板)
                local shipEquip = zstring.split(ship.equipInfo, "|")
                local equipData = zstring.split(shipEquip[5], ",")
                local equipStar = zstring.split(shipEquip[4], ",")
                local equipMouldId = equipData[1]
                local equip = {}
                --装备模板id
                --初始装备
                local equipAll = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.treasureSkill)
                if tonumber(equipStar[1]) == 0 then
                    local equipMouldData = zstring.split(equipAll, ",")
                    equip.user_equiment_template = equipMouldData[1]
                else
                    equip.user_equiment_template = equipMouldId
                end
                --装备等级
                local equipLevelData = zstring.split(shipEquip[1], ",")
                equip.user_equiment_grade = equipLevelData[1]
                --所属战船
                equip.ship_id = ship.ship_id
                equip.m_index = 1

                app.load("client.packs.equipment.SmEquipmentQianghua")
                state_machine.excute("sm_equipment_qianghua_open",0,equip)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --跳转到 武将进阶
        local trial_tower_battle_lose_open_ship_advanced_terminal = {
            _name = "trial_tower_battle_lose_open_ship_advanced",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(fwin:find("FightUIClass"))
                cacher.removeAllTextures()
                fwin:reset(nil)
                app.load("client.home.Menu")
                fwin:open(Menu:new(), fwin._taskbar)
                local ship = nil
                for i, v in pairs(_ED.user_formetion_status) do
                    if zstring.tonumber(v) > 0 then
                        ship = _ED.user_ship[""..v]
                        break
                    end
                end
                local enter_type = "learn"
                if fwin:find("HeroIconListViewClass") == nil then
                    app.load("client.packs.hero.HeroIconListView")
                    state_machine.excute("hero_icon_listview_open",0,ship)
                    fwin:find("HeroIconListViewClass"):setVisible(false)
                end
                app.load("client.packs.hero.HeroDevelop")
                if fwin:find("HeroDevelopClass") ~= nil then
                    state_machine.excute("formation_set_ship",0,ship)
                    return
                    -- fwin:close(fwin:find("HeroDevelopClass"))
                end
                local heroDevelopWindow = HeroDevelop:new()
                if __lua_project_id == __lua_project_gragon_tiger_gate 
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    ship.shengming = zstring.tonumber(ship.ship_health)
                    ship.gongji = zstring.tonumber(ship.ship_courage)
                    ship.waigong = zstring.tonumber(ship.ship_intellect)
                    ship.neigong = zstring.tonumber(ship.ship_quick)
                end
                -- print("=======11=====",enter_type)
                if enter_type ~= "learn" and enter_type ~= "pack" then
                    enter_type = "formation"
                end
                for i,v in pairs(_ED.user_formetion_status) do
                    if zstring.tonumber(v) == tonumber(ship.ship_id) then
                        enter_type = "formation"
                    end
                end
                heroDevelopWindow:init(ship.ship_id, enter_type)
                fwin:open(heroDevelopWindow, fwin._viewdialog)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --跳转到 武将升星
        local trial_tower_battle_lose_open_ship_rising_star_terminal = {
            _name = "trial_tower_battle_lose_open_ship_rising_star",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(fwin:find("FightUIClass"))
                cacher.removeAllTextures()
                fwin:reset(nil)
                app.load("client.home.Menu")
                fwin:open(Menu:new(), fwin._taskbar)
                local ship = nil
                for i, v in pairs(_ED.user_formetion_status) do
                    if zstring.tonumber(v) > 0 then
                        ship = _ED.user_ship[""..v]
                        break
                    end
                end
                local enter_type = "learn"
                if fwin:find("HeroIconListViewClass") == nil then
                    app.load("client.packs.hero.HeroIconListView")
                    state_machine.excute("hero_icon_listview_open",0,ship)
                    fwin:find("HeroIconListViewClass"):setVisible(false)
                end
                app.load("client.packs.hero.HeroDevelop")
                if fwin:find("HeroDevelopClass") ~= nil then
                    state_machine.excute("formation_set_ship",0,ship)
                    return
                    -- fwin:close(fwin:find("HeroDevelopClass"))
                end
                local heroDevelopWindow = HeroDevelop:new()
                if __lua_project_id == __lua_project_gragon_tiger_gate 
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    ship.shengming = zstring.tonumber(ship.ship_health)
                    ship.gongji = zstring.tonumber(ship.ship_courage)
                    ship.waigong = zstring.tonumber(ship.ship_intellect)
                    ship.neigong = zstring.tonumber(ship.ship_quick)
                end
                -- print("=======11=====",enter_type)
                if enter_type ~= "learn" and enter_type ~= "pack" then
                    enter_type = "formation"
                end
                for i,v in pairs(_ED.user_formetion_status) do
                    if zstring.tonumber(v) == tonumber(ship.ship_id) then
                        enter_type = "formation"
                    end
                end
                heroDevelopWindow:init(ship.ship_id, enter_type)
                fwin:open(heroDevelopWindow, fwin._viewdialog)

                state_machine.excute("hero_develop_page_manager",0,{_datas = {next_terminal_name = "hero_develop_page_open_train_page",            
                current_button_name = "Button_peiyang",     
                but_image = "",     
                shipId = self.shipId,
                terminal_state = 0, 
                openWinId = 3,
                isPressedActionEnabled = tempIsPressedActionEnabled}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(trial_tower_battle_lose_display_terminal)
        state_machine.add(trial_tower_battle_lose_hide_terminal)
        state_machine.add(trial_tower_battle_lose_drop_out_terminal)
        state_machine.add(trial_tower_battle_lose_open_hero_shop_terminal)
        state_machine.add(trial_tower_battle_lose_open_equipment_terminal)
        state_machine.add(trial_tower_battle_lose_open_ship_advanced_terminal)
        state_machine.add(trial_tower_battle_lose_open_ship_rising_star_terminal)
        
        state_machine.init()
    end
    init_trial_tower_battle_lose_terminal()
end


function TrialTowerBattleLose:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
end

function TrialTowerBattleLose:init(_fight_type)
    self._fight_type = _fight_type
    self:onInit()
    return self
end

function TrialTowerBattleLose:onInit()
    local csbTrialTowerBattleLose = csb.createNode("battle/sm_battle_failure.csb")
    local root = csbTrialTowerBattleLose:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbTrialTowerBattleLose)
    local action = csb.createTimeline("battle/sm_battle_failure.csb")
    table.insert(self.actions, action)
    csbTrialTowerBattleLose:runAction(action)
    self.actions[1]:play("window_open", false)
    playEffect(formatMusicFile("effect", 9995))   
    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_black_bg"), nil, 
    {
        terminal_name = "trial_tower_battle_lose_drop_out",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    -- 抽卡
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), nil, 
    {
        terminal_name = "trial_tower_battle_lose_open_hero_shop",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)

    -- 强化装备
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_2"), nil, 
    {
        terminal_name = "trial_tower_battle_lose_open_equipment",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)

    --数码兽进阶
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_3"), nil, 
    {
        terminal_name = "trial_tower_battle_lose_open_ship_advanced",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)

    --数码兽升星
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_4"), nil, 
    {
        terminal_name = "trial_tower_battle_lose_open_ship_rising_star",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)

    -- 战报统计
    local Button_damage = ccui.Helper:seekWidgetByName(root,"Button_damage")
    if Button_damage then
        Button_damage:setVisible(false)
    end

    --记录战斗结算

    --找到npc
    local npcs = zstring.split(_ED.three_kingdoms_npc_formation_infos, ",")
    --找到npc的环境阵型
    local environment_formation1 = dms.string(dms["npc"], tonumber(npcs[tonumber(_ED.three_kingdoms_battle_index)]), npc.environment_formation1)
    self.ship_info = {}
    for j=1, 6 do
        local ship = dms.int(dms["environment_formation"], environment_formation1, environment_formation.seat_one+j-1)
        self.ship_info[j] = ship
    end

    local byAttacks = ""
    
    --记录怪物血量
    for i,w in pairs(self.ship_info) do
        local isData = true
        for i,v in pairs(_ED._fightModule.byAttackObjects) do
            if tonumber(v.id) == tonumber(w) and tonumber(w) ~= 0 then
                if byAttacks == "" then
                    byAttacks = w..","..v.healthPoint
                else
                    byAttacks = byAttacks .. "|"..w..","..v.healthPoint
                end
                isData = false
            end
        end
        if isData == true and tonumber(w) ~= 0 then
            if byAttacks == "" then
                byAttacks = w..",".."0"
            else
                byAttacks = byAttacks .. "|"..w..",".."0"
            end
        end
    end
    byAttacks = _ED.integral_current_index..",".._ED.three_kingdoms_battle_index.."-"..byAttacks

    local strs = ""
    local index = 0
    local datas = {}

    for i,v in pairs(_ED.user_formetion_status) do
    	local shipInfo = {}
    	shipInfo.healthPoint = 0
        shipInfo.skillPoint = 0
        shipInfo.maxHp = 0
        shipInfo.id = v
        table.insert(datas, shipInfo) 
    end

    for j, w in pairs(_ED.user_try_ship_infos) do
    	local isData = nil
		for i=1, #datas do
			if tonumber(datas[i].id) == tonumber(w.id) then
				isData = datas[i]
			end
		end
		if isData ~= nil then
    		if strs ~= "" then
    			strs = strs.."|"..isData.id..":"..isData.healthPoint..","..isData.skillPoint..","..(zstring.tonumber(isData.healthPoint)/zstring.tonumber(_ED.user_ship[""..isData.id].ship_health)*100)
    		else
    			strs = isData.id..":"..isData.healthPoint..","..isData.skillPoint..","..(zstring.tonumber(isData.healthPoint)/zstring.tonumber(_ED.user_ship[""..isData.id].ship_health)*100)
    		end
    	else
    		if strs ~= "" then
    			strs = strs.."|"..w.id..":"..w.newHp..","..w.newanger..","..(zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
    		else
    			strs = w.id..":"..w.newHp..","..w.newanger..","..(zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
    		end
		end
    end

    local newBuff = ""
    for j, w in pairs(_ED.three_kingdoms_view.atrribute) do
        local buff_info = zstring.split(w[1] ,":")
        local shipId = tonumber(buff_info[2])
        if shipId < 0 then
            --重新记录buff
            if j == 1 then
                newBuff = w[1]..","..w[2]
            else
                newBuff = newBuff .."|"..w[1]..","..w[2]
            end
        end
    end
    strs = strs.."-"..byAttacks
    -- 失败时层数传-1，不对宝箱、buff做任何操作
    local current_index = -1
    protocol_command.three_kingdoms_launch.param_list = "54".."\r\n"..dms.string(dms["play_config"], 26, play_config.param).."\r\n".."0".."\r\n".."0".."\r\n".."1".."\r\n"..
    current_index.."\r\n"..strs.."\r\n".."".."\r\n"..newBuff.."\r\n".."0"
    NetworkManager:register(protocol_command.three_kingdoms_launch.code, nil, nil, nil, self, nil, false, nil)
    --清除记录
    cc.UserDefault:getInstance():setStringForKey(getKey("GuanBattleIndex"), "-1")
    cc.UserDefault:getInstance():flush()
end

function TrialTowerBattleLose:onExit()
    state_machine.remove("trial_tower_battle_lose_display")
    state_machine.remove("trial_tower_battle_lose_hide")
end