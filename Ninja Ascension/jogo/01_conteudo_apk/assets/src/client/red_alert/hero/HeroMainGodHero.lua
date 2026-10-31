-----------------------------
--英雄神将界面
-----------------------------
HeroMainGodHero = class("HeroMainGodHeroClass", Window)

local hero_main_god_hero_window_open_terminal = {
    _name = "hero_main_god_hero_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroMainGodHeroClass")
        if nil == _Window then
            fwin:open(HeroMainGodHero:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_main_god_hero_window_open_terminal)
state_machine.init()

function HeroMainGodHero:ctor()
    self.super:ctor()
    self.roots = {}
    local function init_hero_main_god_hero_terminal()
    
        --显示界面
        local hero_main_god_hero_window_show_terminal = {
            _name = "hero_main_god_hero_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --隐藏界面
        local hero_main_god_hero_window_hide_terminal = {
            _name = "hero_main_god_hero_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --改变英雄
        local hero_main_god_hero_change_ship_terminal = {
            _name = "hero_main_god_hero_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local ship = params
                instance.ship = ship
                instance:setHeroIcon()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --任务更新
        local hero_main_god_hero_update_task_terminal = {
            _name = "hero_main_god_hero_update_task",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil then
                    local ship = instance.ship
                    ship = _ED.user_ship[""..ship.ship_id]
                    instance.ship = ship
                    instance:setHeroIcon()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --任务跳转
        local hero_main_god_hero_task_go_on_terminal = {
            _name = "hero_main_god_hero_task_go_on",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local initial_rank_level = dms.int(dms["ship_mould"], instance.ship.ship_template_id, ship_mould.initial_rank_level)
                -- local ship_type = dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.ship_type)
                if funOpenDrawTip(86, false) == true then
                    TipDlg.drawTextDailog(tipStringInfo_god_weaponry_info[2])
                    return
                end
                local task_info = nil
                if _ED.user_task_infos["6"] ~= nil then
                    for i, task in pairs(_ED.user_task_infos["6"]) do
                        if tonumber(instance.ship.god_weaponry_task_id) == tonumber(task.task_id) then
                            task_info = task
                        end
                    end
                end
                if task_info ~= nil then
                    local task_mould_id = task_info.task_mould_id
                    local achievement_mould_id = dms.int(dms["task_mould"], task_mould_id, task_mould.achieve_mould_id)
                    local achievement_short_id = dms.int(dms["achievement_mould"], achievement_mould_id, achievement_mould.achievement_short_id)
                    local achievement_finish_type = dms.int(dms["achievement_mould"], achievement_mould_id, achievement_mould.achievement_finish_type)
                    if achievement_finish_type == 34 then 
                        local item_value = 0
                        local  prop = fundPropWidthId(achievement_short_id)
                        if prop == nil then
                            item_value = 0
                        else
                            item_value= prop.prop_number
                        end
                        local cell = state_machine.excute("get_the_way_window_open",0,{6,achievement_short_id,item_value})
                        return
                    end
                    if achievement_short_id == 818 then
                        state_machine.excute("task_window_close",0,"")
                        if fwin:find("DuplicateMapClass")  ~= nil then
                            state_machine.excute("duplicate_map_window_close",0,"")
                            state_machine.excute("duplicate_title_window_close",0,"")
                            state_machine.excute("main_window_open", 0, "")
                            state_machine.excute("player_resource_window_show", 0, "")     
                            state_machine.excute("home_button_for_action_window_show",0,"")
                            state_machine.excute("chat_view_window_show",0,"")
                            if fwin:find("PacksClass")  ~= nil then
                                state_machine.excute("packs_window_close",0,"")
                            elseif fwin:find("HeroMainClass")  ~= nil then
                                state_machine.excute("hero_main_window_close",0,"")
                            end
                        end
                        if fwin:find("DuplicateManagerClass")  ~= nil then
                            state_machine.excute("duplicate_manager_window_close",0,"")
                            state_machine.excute("main_window_open", 0, "")
                            state_machine.excute("player_resource_window_show", 0, "")     
                            state_machine.excute("home_button_for_action_window_show",0,"")
                            state_machine.excute("chat_view_window_show",0,"")
                            if fwin:find("PacksClass")  ~= nil then
                                state_machine.excute("packs_window_close",0,"")
                            elseif fwin:find("HeroMainClass")  ~= nil then
                                state_machine.excute("hero_main_window_close",0,"")
                            end
                        end
                        return
                    end
                    state_machine.excute("short_cut_go_to_other_window",0,{achievement_short_id, nil, instance.ship})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(hero_main_god_hero_window_show_terminal)   
        state_machine.add(hero_main_god_hero_window_hide_terminal)
        state_machine.add(hero_main_god_hero_change_ship_terminal)
        state_machine.add(hero_main_god_hero_update_task_terminal)
        state_machine.add(hero_main_god_hero_task_go_on_terminal)   
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_hero_main_god_hero_terminal()    
end

function HeroMainGodHero:onShow()
   self:setVisible(true)
end

function HeroMainGodHero:onHide()
   self:setVisible(false)
end

function HeroMainGodHero:setHeroIcon( )
    local root = self.roots[1]
    local Panel_hero_god_animation = ccui.Helper:seekWidgetByName(root,"Panel_hero_god_animation")
    Panel_hero_god_animation:removeAllChildren(true)
    local ship = self.ship
    local ship_mould_id = ship.ship_template_id
    app.load("client.battle.fight.FightEnum")
    local temp_bust_index = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.bust_index)
    temp_bust_index = 10000 + temp_bust_index
    local armature = sp.spine_sprite(Panel_hero_god_animation, temp_bust_index, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_10+1], true, nil, nil, cc.p(0.5, 0))
    armature:setPosition(cc.p(Panel_hero_god_animation:getContentSize().width/2, 0)) 
    --名字
    local Text_god_role_infor_name = ccui.Helper:seekWidgetByName(root,"Text_god_role_infor_name")
    local captain_name = dms.string(dms["ship_mould"], ship_mould_id, ship_mould.captain_name)
    local ship_type = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.ship_type)
    Text_god_role_infor_name:setString(captain_name .. "+" .. self.ship.skill_grow_up_level)
    Text_god_role_infor_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type+1][1],tipStringInfo_quality_color_Type[ship_type+1][2],tipStringInfo_quality_color_Type[ship_type+1][3]))
    --等级
    local Text_hero_god_lv = ccui.Helper:seekWidgetByName(root,"Text_hero_god_lv")
    Text_hero_god_lv:setString("Lv".._ED.user_info.user_grade)
    Text_hero_god_lv:setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type+1][1],tipStringInfo_quality_color_Type[ship_type+1][2],tipStringInfo_quality_color_Type[ship_type+1][3]))
    --职业
    local Text_god_occupation_infor = ccui.Helper:seekWidgetByName(root,"Text_god_occupation_infor")
    local capacity = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.capacity)
    Text_god_occupation_infor:setString(red_alert_hero_job[capacity])
    --类型 
    local Text_god_types_infor = ccui.Helper:seekWidgetByName(root,"Text_god_types_infor")
    Text_god_types_infor:setString(red_alert_hero_type[capacity]) 
    --资质
    local Text_god_qualification_infor = ccui.Helper:seekWidgetByName(root,"Text_god_qualification_infor")
    local ability = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.ability)
    Text_god_qualification_infor:setString(tipStringInfo_hero_ability[ability])
    --星级
    local stars,stars_level = getHeroStars(ship_mould_id)
    for i=1,3 do
        local Panel_god_star = ccui.Helper:seekWidgetByName(root,"Panel_god_star_"..i)
        Panel_god_star:removeBackGroundImage()
        if i > stars  then
            Panel_god_star:setVisible(false)
        else
            Panel_god_star:setVisible(true)
            Panel_god_star:setBackGroundImage("images/ui/state/big_star_"..stars_level..".png")
        end
    end

    local Text_god_up_star_1 = ccui.Helper:seekWidgetByName(root,"Text_god_up_star_1")
    local Text_god_up_star_2 = ccui.Helper:seekWidgetByName(root,"Text_god_up_star_2")
    local Panel_god_icon = ccui.Helper:seekWidgetByName(root,"Panel_god_icon")
    local Button_god_up_go_on = ccui.Helper:seekWidgetByName(root,"Button_god_up_go_on")
    local Panel_god_up = ccui.Helper:seekWidgetByName(root,"Panel_god_up")
    local Image_god_up = ccui.Helper:seekWidgetByName(root,"Image_god_up")
    local Text_god_skill_infor = ccui.Helper:seekWidgetByName(root,"Text_god_skill_infor")
    local Text_god_finish = ccui.Helper:seekWidgetByName(root,"Text_god_finish")
    local Panel_god_skill_infor = ccui.Helper:seekWidgetByName(root,"Panel_god_skill_infor")
    local Text_god_up_success = ccui.Helper:seekWidgetByName(root,"Text_god_up_success")

    Text_god_up_star_1:setString("")
    Text_god_up_star_2:setString("")
    Panel_god_icon:removeBackGroundImage()
    Button_god_up_go_on:setVisible(false)
    Panel_god_up:setVisible(false)
    Image_god_up:setVisible(false)
    Panel_god_skill_infor:setVisible(false)
    Text_god_skill_infor:setString("")
    Text_god_finish:setString("")
    Text_god_up_success:setVisible(false)
    -- 解析神兵技能
    if _ED.god_weaponry_info == nil or table.nums(_ED.god_weaponry_info) == 0 then
        initAllGodWeaponryData()
    end
    local initial_rank_level = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.initial_rank_level)
    if funOpenDrawTip(86, false) == true then
        local ship_mould_id = self.ship.ship_template_id
        local god_weaponry_id = 0
        local super_equipment_mould_group_id = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.super_equipment_mould_group_id)
        if super_equipment_mould_group_id > 0 then
            if tonumber(self.ship.god_weaponry) <= 0 then
                god_weaponry_id = super_equipment_mould_group_id
                Button_god_up_go_on:setVisible(true)
                Image_god_up:setVisible(true)
            else
                god_weaponry_id = tonumber(self.ship.god_weaponry)
            end
            Panel_god_skill_infor:setVisible(true)
            local god_info = _ED.god_weaponry_info[""..god_weaponry_id]
            local talentMould = dms.element(dms["talent_mould"], god_info.talent_id)
            local talent_describe = dms.atos(talentMould, talent_mould.talent_describe)
            Text_god_skill_infor:setString(talent_describe)
        end
    else
        local task_info = nil
        if _ED.user_task_infos["6"] ~= nil then
            for i, task in pairs(_ED.user_task_infos["6"]) do
                if tonumber(self.ship.god_weaponry_task_id) == tonumber(task.task_id) then
                    task_info = task
                end
            end
        end
        if task_info ~= nil then
            local ship_mould_id = self.ship.ship_template_id
            local advanced_ship_open_tasks = zstring.split(dms.string(dms["ship_mould"], ship_mould_id, ship_mould.advanced_ship_open_tasks), ",")
            local task_index = 0
            for k,v in pairs(advanced_ship_open_tasks) do
                if tonumber(v) == tonumber(task_info.task_mould_id) then
                    task_index = k
                end
            end
            Panel_god_up:setVisible(true)
            local task_mould_id = task_info.task_mould_id
            local achievement_mould_id = dms.int(dms["task_mould"], task_mould_id, task_mould.achieve_mould_id)
            local task_pic = dms.int(dms["task_mould"], task_mould_id, task_mould.task_pic)
            local achievement_name = dms.string(dms["achievement_mould"], achievement_mould_id, achievement_mould.achievement_name)
            local achievement_dec = dms.string(dms["achievement_mould"], achievement_mould_id, achievement_mould.achievement_dec)
            Text_god_up_star_1:setString(achievement_name.."("..task_info.task_complete_count.."/"..task_info.need_complete_count..")")
            Text_god_up_star_2:setString(achievement_dec)
            Text_god_finish:setString((task_index - 1).."/6")
            Panel_god_icon:setBackGroundImage(string.format("images/ui/task_icon/tasks_icon_%d.png", task_pic))
            Button_god_up_go_on:setVisible(true)
            Image_god_up:setVisible(true)
        else
            local ship_mould_id = self.ship.ship_template_id
            local god_weaponry_id = 0
            local super_equipment_mould_group_id = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.super_equipment_mould_group_id)
            if super_equipment_mould_group_id > 0 then
                if tonumber(self.ship.god_weaponry) <= 0 then
                    god_weaponry_id = super_equipment_mould_group_id
                    Button_god_up_go_on:setVisible(true)
                    Image_god_up:setVisible(true)
                else
                    god_weaponry_id = tonumber(self.ship.god_weaponry)
                    Text_god_up_success:setVisible(true)
                end
                Panel_god_skill_infor:setVisible(true)
                local god_info = _ED.god_weaponry_info[""..god_weaponry_id]
                local talentMould = dms.element(dms["talent_mould"], god_info.talent_id)
                local talent_describe = dms.atos(talentMould, talent_mould.talent_describe)
                Text_god_skill_infor:setString(talent_describe)
            end
        end
    end
end

function HeroMainGodHero:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_main_god_hero)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_god_up_go_on"), nil, 
    {
        terminal_name = "hero_main_god_hero_task_go_on", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:setHeroIcon()
end

function HeroMainGodHero:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.ship = params[2]    
    self:onInit()
    return self
end

function HeroMainGodHero:onExit()
    state_machine.remove("hero_main_god_hero_window_show")   
    state_machine.remove("hero_main_god_hero_window_hide")
    state_machine.remove("hero_main_god_hero_change_ship")
    state_machine.remove("hero_main_god_hero_update_task")
    state_machine.remove("hero_main_god_hero_task_go_on")
end
