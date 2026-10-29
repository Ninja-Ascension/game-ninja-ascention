--------------------------------------------------------------------------------------------------------------
--  说明：武将首页
--------------------------------------------------------------------------------------------------------------
HeroMain = class("HeroMainClass", Window)

--打开界面
local hero_main_window_open_terminal = {
    _name = "hero_main_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(66) == true then
            return
        end    
        if fwin:find("HeroMainClass") == nil then
            local _win = HeroMain:new()
            _win:init()
            fwin:open(_win,fwin._view)
        end
        state_machine.excute("hero_main_window_show",0,"")
        state_machine.excute("main_window_hide", 0, "")
        state_machine.excute("player_resource_window_hide", 0, "")     
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")  
        state_machine.excute("duplicate_title_window_hide",0,"") 
        state_machine.excute("duplicate_map_window_hide",0,"")
        state_machine.excute("duplicate_manager_window_hide",0,"")
        state_machine.excute("seven_star_map_ui_window_hide",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local hero_main_window_close_terminal = {
    _name = "hero_main_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroMainClass"))
        if fwin:find("NationalWarMapClass") ~= nil then
            -- state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
        elseif fwin:find("DuplicateManagerClass") == nil then
            if fwin:find("CampaignClass") ~= nil then
                state_machine.excute("campaign_window_show",0,"")
                state_machine.excute("home_button_for_action_window_hide",0,"") 
                state_machine.excute("chat_view_window_hide",0,"")
            elseif fwin:find("UnionClass") ~= nil then
            elseif fwin:find("SevenStarClass") ~= nil then
                state_machine.excute("seven_star_map_ui_window_show",0,"")
                state_machine.excute("duplicate_map_window_show",0,"")
                state_machine.excute("player_resource_window_hide",0,"")
                state_machine.excute("home_button_for_action_window_show",0,"")
            elseif fwin:find("DuplicateMapClass") ~= nil then
                state_machine.excute("duplicate_map_window_show", 0, nil)
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")
                state_machine.excute("duplicate_title_window_show",0,"")
            else
                state_machine.excute("main_window_open",0,"")
                state_machine.excute("player_resource_window_show",0,"")   
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")
                state_machine.excute("duplicate_title_window_show",0,"")
            end
        else
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("duplicate_title_window_show",0,"")  
            state_machine.excute("duplicate_map_window_show",0,"")   
            state_machine.excute("duplicate_manager_window_show",0,"")   
            state_machine.excute("hero_star_activation_window_close",0,"")
        end
        if fwin:find("TaskClass") ~= nil then
            state_machine.excute("task_window_show",0,"") 
            state_machine.excute("player_resource_window_hide",0,"") 
            state_machine.excute("home_button_for_action_window_hide",0,"") 
            state_machine.excute("chat_view_window_hide",0,"")
            state_machine.excute("duplicate_title_window_hide",0,"")  
            state_machine.excute("duplicate_map_window_hide",0,"")   
            state_machine.excute("duplicate_manager_window_hide",0,"")   
            state_machine.excute("seven_star_map_ui_window_hide",0,"")
        end
        if fwin:find("AddNumberClass") ~= nil then
            state_machine.excute("add_number_window_close",0,"")
        end
        
        state_machine.excute("national_city_hide_game_resource_info", 0, nil)
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(hero_main_window_open_terminal)
state_machine.add(hero_main_window_close_terminal)
state_machine.init()

function HeroMain:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._last_page_index = 0

    --load lua file
    app.load("client.red_alert_time.cells.hero.hero_icon_cell")
    app.load("client.red_alert_time.cells.hero.hero_main_skills_up_cell")
    app.load("client.red_alert_time.hero.HeroMainGrowUp")
    app.load("client.red_alert_time.hero.HeroMainSkillsUp")
    app.load("client.red_alert_time.hero.HeroMainStarUp")
    app.load("client.red_alert_time.hero.HeroFetters")
    app.load("client.red_alert_time.hero.HeroAttributes")
    app.load("client.red_alert_time.hero.HeroMainGodHero")
    app.load("client.red_alert_time.packs.herostorage.HeroPacks")
    app.load("client.red_alert_time.packs.herostorage.HeroStarSkillsIconInfor")
    app.load("client.red_alert_time.packs.herostorage.HeroStarSkillsInforProperty")
    app.load("client.red_alert_time.packs.herostorage.HeroStarTalentInfor")
    app.load("client.red_alert_time.hero.HeroStarUpSuccess")
    app.load("client.red_alert_time.notification.push_notification_hero")
    app.load("client.red_alert_time.recruit.CatalogueStorage")

    --var
    self.hero_type = nil -- 1 信息 -- 2 形象
    --英雄icon列表
    self.listview = nil 
    --列表x轴
    self.listview_pox = nil

     -- Initialize alert_home state machine.
    local function init_hero_main_terminal()
        --管理
        local hero_main_maneger_terminal = {
        _name = "hero_main_maneger",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local fun_open_id = params._datas.fun_open_id
            if funOpenDrawTip(fun_open_id) == true then
                return
            end
            if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                -- hide child window
                terminal.last_terminal_name = params._datas.next_terminal_name
                state_machine.excute(params._datas.next_terminal_name, 0, params)
            end 
            -- set select ui button is highlighted
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(false)
                terminal.select_button:setTouchEnabled(true)
            end
            if terminal.select_button == nil and params._datas.current_button_name ~= nil then
                terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
            else
                terminal.select_button = params
            end

            if terminal.select_button.setHighlighted == nil and params._datas.current_button_name ~= nil then
                terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
            end
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(true)
                terminal.select_button:setTouchEnabled(false)
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
        }

        --显示所有
        local hero_main_window_show_terminal = {
            _name = "hero_main_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:onShow()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏所有
        local hero_main_window_hide_terminal = {
            _name = "hero_main_window_hide",
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
        
        -- 翻页显示英雄信息\英雄形象
        local hero_main_show_information_or_icon_terminal = {
            _name = "hero_main_show_information_or_icon",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local action = cell.actions[1]
                if cell.hero_type == 1 then
                    cell.hero_type = 2
                    action:play("infor_cg_switching_2",false)
                else
                    cell.hero_type = 1
                    action:play("infor_cg_switching_1",false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 改变英雄
        local hero_main_change_ship_terminal = {
            _name = "hero_main_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= "" and params ~= nil then
                    instance.ship = params 
                end
                state_machine.excute("hero_main_grow_up_change_ship",0,instance.ship)
                state_machine.excute("hero_fetters_change_ship",0,instance.ship)
                state_machine.excute("hero_main_god_hero_change_ship",0,instance.ship)
                instance:setHeroInfo()
                instance:setHeroCellSelected(instance.ship)

                if instance._last_page_index == 4 then
                    if tonumber(instance.ship.ship_type) >= 4 then 
                    else
                        state_machine.excute("hero_main_maneger", 0, {
                            _datas = 
                            {
                                next_terminal_name = "hero_main_change_to_star_page", 
                                current_button_name = "Button_rising_star",
                                fun_open_id = 91,
                            }
                            })
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 升星
        local hero_main_change_to_star_page_terminal = {
            _name = "hero_main_change_to_star_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._last_page_index = 1
                state_machine.excute("hero_main_grow_up_window_show",0,"")
                state_machine.excute("hero_main_star_up_window_show",0,"")
                state_machine.excute("hero_main_grow_up_set_visible_property", 0, true)

                state_machine.excute("hero_main_skills_up_window_hide",0,"")
                state_machine.excute("hero_main_grade_up_window_hide", 0, 0)
                state_machine.excute("hero_fetters_window_hide",0,"")
                state_machine.excute("hero_main_god_hero_window_hide",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
     
        -- 天赋
        local hero_main_change_to_skills_page_terminal = {
            _name = "hero_main_change_to_skills_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._last_page_index = 2
                state_machine.excute("hero_main_grow_up_window_show",0,"")
                state_machine.excute("hero_main_skills_up_window_show",0,"")
                state_machine.excute("hero_main_grade_up_window_show", 0, 0)

                state_machine.excute("hero_main_star_up_window_hide",0,"")
                state_machine.excute("hero_fetters_window_hide",0,"")
                state_machine.excute("hero_main_god_hero_window_hide",0,"") 
                state_machine.excute("hero_main_grow_up_set_visible_property", 0, false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        -- 羁绊
        local hero_main_change_to_relaship_page_terminal = {
            _name = "hero_main_change_to_relaship_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._last_page_index = 3
                local root = instance.roots[1]
                local Panel_label_switching = ccui.Helper:seekWidgetByName(root,"Panel_label_switching")
                state_machine.excute("hero_fetters_window_open",0,{Panel_label_switching,instance.ship}) 
                state_machine.excute("hero_fetters_window_show",0,"") 
                state_machine.excute("hero_main_grow_up_set_visible_property", 0, true)

                state_machine.excute("hero_main_grow_up_window_hide",0,"")
                state_machine.excute("hero_main_god_hero_window_hide",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        -- 神将
        local hero_main_change_to_god_hero_terminal = {
            _name = "hero_main_change_to_god_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._last_page_index = 4
                local root = instance.roots[1]
                local Panel_label_switching = ccui.Helper:seekWidgetByName(root,"Panel_label_switching")
                state_machine.excute("hero_main_god_hero_window_open",0,{Panel_label_switching,instance.ship})            
                state_machine.excute("hero_main_god_hero_window_show",0,"")
                state_machine.excute("hero_main_grow_up_set_visible_property", 0, true)

                state_machine.excute("hero_fetters_window_hide",0,"") 
                state_machine.excute("hero_main_grow_up_window_hide",0,"")          
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  


        -- 移除某个头像
        local hero_main_remove_list_item_terminal = {
            _name = "hero_main_remove_list_item",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:removeListViewItem(params)     
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 添加某个头像
        local hero_main_add_list_item_terminal = {
            _name = "hero_main_add_list_item",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addListViewItem(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 升星后刷新列表
        local hero_main_update_draw_terminal = {
            _name = "hero_main_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 更新角色形象
        local hero_main_update_draw_role_effect_terminal = {
            _name = "hero_main_update_draw_role_effect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setHeroIcon()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 刷新英雄信息
        local hero_main_update_hero_info_terminal = {
            _name = "hero_main_update_hero_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setHeroInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        
        state_machine.add(hero_main_maneger_terminal)
        state_machine.add(hero_main_window_show_terminal)
        state_machine.add(hero_main_window_hide_terminal)   
        state_machine.add(hero_main_show_information_or_icon_terminal)
        state_machine.add(hero_main_change_ship_terminal)
        state_machine.add(hero_main_change_to_star_page_terminal)
        state_machine.add(hero_main_change_to_skills_page_terminal)
        state_machine.add(hero_main_change_to_relaship_page_terminal)
        state_machine.add(hero_main_change_to_god_hero_terminal)
        state_machine.add(hero_main_remove_list_item_terminal)
        state_machine.add(hero_main_add_list_item_terminal)
        state_machine.add(hero_main_update_draw_terminal)
        state_machine.add(hero_main_update_draw_role_effect_terminal)
        state_machine.add(hero_main_update_hero_info_terminal)
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_hero_main_terminal()

end

--设置英雄icon选择
function HeroMain:setHeroCellSelected(ship)
    for i ,v in pairs(self.listview:getItems()) do 
        if v.ship == ship then
            v.isSelecet = true
            state_machine.excute("hero_icon_cell_set_seleceted",0,v)
        else
            if v.isSelecet == true then
                v.isSelecet = false
                state_machine.excute("hero_icon_cell_set_seleceted",0,v)
            end
        end
    end
end

--显示
function HeroMain:onShow()
   self:setVisible(true)
end

--隐藏
function HeroMain:onHide()
   self:setVisible(false)
end

--初始化界面
function HeroMain:onInit()
    local csbItem = csb.createNode(config_csb.hero.hero_main)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
    --阵营背景
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
    	local Panel_hero_cg_role = ccui.Helper:seekWidgetByName(root, "Panel_hero_cg_role")
		local Panel_hero_infor_bg = ccui.Helper:seekWidgetByName(root, "Panel_hero_infor_bg")
		local Panel_cgbg = ccui.Helper:seekWidgetByName(root, "Panel_cgbg")
		Panel_cgbg:setBackGroundImage("images/ui/decorative/card_head_bg.png")
		Panel_hero_cg_role:setBackGroundImage("images/face/card_hero/card_hero_1008.png")
		Panel_hero_infor_bg:setBackGroundImage("images/ui/decorative/hero_infor_ins.png")
    else
		local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
		Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")
    end

    local action = csb.createTimeline(config_csb.hero.hero_main)
    action:setTimeSpeed(app.getTimeSpeed())
    table.insert(self.actions, action)

    csbItem:runAction(action)    
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_main_back"), nil, 
    {
        terminal_name = "hero_main_window_close", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)     
    -- 翻页显示英雄信息
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_hero_infor"), nil, 
    {
        terminal_name = "hero_main_show_information_or_icon", 
        terminal_state = 0, 
        cell = self, 
    }, nil, 0)      
    -- 翻页显示英雄形象
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_hero_cg_role"), nil, 
    {
        terminal_name = "hero_main_show_information_or_icon", 
        terminal_state = 0, 
        cell = self, 
    }, nil, 0) 
    --显示属性介绍
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_attributes"), nil, 
    {
        terminal_name = "hero_attributes_window_open", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)     
    --升星
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rising_star"), nil, 
    {
        terminal_name = "hero_main_maneger",     
        next_terminal_name = "hero_main_change_to_star_page", 
        current_button_name = "Button_rising_star",   
        but_image = "",     
        terminal_state = 0, 
        fun_open_id = 91,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)      
    --升星推送
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_hero_star_up",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_rising_star"),
    _cell = self,
    _invoke = nil,
    _interval = 0.5,})

    --天赋
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_talent"), nil, 
    {
        terminal_name = "hero_main_maneger",     
        next_terminal_name = "hero_main_change_to_skills_page", 
        current_button_name = "Button_talent",   
        but_image = "",     
        terminal_state = 0, 
        fun_open_id = 92,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)   
    --突破推送
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_hero_grade_up",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_talent"),
    _cell = self,
    _invoke = nil,
    _interval = 0.5,})

    --羁绊
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fetters"), nil, 
    {
        terminal_name = "hero_main_maneger",     
        next_terminal_name = "hero_main_change_to_relaship_page", 
        current_button_name = "Button_fetters",   
        but_image = "",     
        terminal_state = 0, 
        fun_open_id = 93,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)      
    --羁绊推送
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_hero_fetters",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_fetters"),
    _cell = self,
    _invoke = nil,
    _interval = 0.5,})

    --神将
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_god_hero"), nil, 
    {
        terminal_name = "hero_main_maneger",     
        next_terminal_name = "hero_main_change_to_god_hero", 
        current_button_name = "Button_god_hero",   
        but_image = "",     
        terminal_state = 0,
        fun_open_id = 94, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)

    -- 侠客录
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_role_register"), nil, 
    {
        terminal_name = "catalogue_storage_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 武将包裹
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_pack"), nil, 
    {
        terminal_name = "hero_packs_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		local function onUpdateDrawData()
			self:onUpdateDraw()
		end
		local function setHeroInfoData()
			self:setHeroInfo() 
		end
		local function setHeroIconData()
			self:setHeroIcon()
		end
		local function onUpdateHeroGrowUp()
			self:openHeroGrowUp()
		end
		if _ED.hero_main_Preloading_1 == 0 then
			self:openHeroGrowUp()
			self:onUpdateDraw()
			self:setHeroInfo() 
		else
			onUpdateHeroGrowUp()
			-- local run_action  = cc.Sequence:create(cc.DelayTime:create(_ED.hero_main_Preloading_1),cc.CallFunc:create(onUpdateHeroGrowUp))
			-- self:runAction(run_action)
			local run_action2  = cc.Sequence:create(cc.DelayTime:create(_ED.hero_main_Preloading_1),cc.CallFunc:create(onUpdateDrawData))
			self:runAction(run_action2)
			local run_action3  = cc.Sequence:create(cc.DelayTime:create(_ED.hero_main_Preloading_1),cc.CallFunc:create(setHeroInfoData))
			self:runAction(run_action3)
		end
		if _ED.hero_main_Preloading_2 == 0 then
			self:setHeroIcon()
		else
			local run_action4  = cc.Sequence:create(cc.DelayTime:create(_ED.hero_main_Preloading_2),cc.CallFunc:create(setHeroIconData))
			self:runAction(run_action4)
		end
    else
		self:onUpdateDraw()
		self:openHeroGrowUp()
		self:setHeroInfo() 
		self:setHeroIcon()
    end
end

function HeroMain:onEnterTransitionFinish()
    self:loadEffect()
end

function HeroMain:loadEffect()
    -- 侠客主界面资源动画加载
    for i, v in pairs(config_res.sprites_cached["hero_main"]) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
    end
    local effect_paths = nil 
    for i, v in pairs(config_res.armatures_cached["hero_main"]) do
        effect_paths = v
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    end
end

function HeroMain:setHeroIcon()
	if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		if _ED.hero_main_Preloading_2 == 0 then
			self:delayDrawHero()
		else
			local action = cc.Sequence:create(cc.DelayTime:create(_ED.hero_main_Preloading_2), cc.CallFunc:create(self.delayDrawHero))
			self:runAction(action) 
		end
	else
		local action = cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(self.delayDrawHero))
		self:runAction(action) 
	end
end

function HeroMain:delayDrawHero()
    local root = self.roots[1]
    local Panel_hero_animation = ccui.Helper:seekWidgetByName(root,"Panel_hero_animation")
    if nil == Panel_hero_animation or Panel_hero_animation:isVisible() == false then
        return
    end
    Panel_hero_animation:removeAllChildren(true)
    local ship = self.ship
    local ship_mould_id = ship.ship_template_id
    app.load("client.battle.fight.FightEnum")
    local temp_bust_index = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.bust_index)
    temp_bust_index = 10000 + temp_bust_index
    local armature = sp.spine_sprite(Panel_hero_animation, temp_bust_index, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_10+1], true, nil, nil, cc.p(0.5, 0))
    armature:setPosition(cc.p(Panel_hero_animation:getContentSize().width/2, 0))
	_ED.hero_main_Preloading_1 = 0
	_ED.hero_main_Preloading_2 = 0
end

--设置英雄信息
function HeroMain:setHeroInfo()
    local root = self.roots[1]
    -- 是否显示境界按钮
    if _ED.god_weaponry_open_state == nil 
        or tonumber(_ED.god_weaponry_open_state) ~= 0 then
        if tonumber(self.ship.ship_type) >= 4 then 
            ccui.Helper:seekWidgetByName(root, "Button_god_hero"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root, "Button_god_hero"):setVisible(false)
        end
    else
        ccui.Helper:seekWidgetByName(root, "Button_god_hero"):setVisible(false)
    end

    local stars,stars_level = getHeroStars(self.ship.ship_template_id)
    for i=1,3 do
        local Panel_hero_infor_star = ccui.Helper:seekWidgetByName(root,"Panel_hero_infor_star_"..i)    --上部分星级icon
        local Panel_hero_star = ccui.Helper:seekWidgetByName(root,"Panel_hero_star_"..i)                --下部分星级icon
        Panel_hero_infor_star:removeBackGroundImage()
        Panel_hero_star:removeBackGroundImage()
        if i > stars  then
            Panel_hero_infor_star:setVisible(false)
            Panel_hero_star:setVisible(false)
        else
            Panel_hero_infor_star:setVisible(true)
            Panel_hero_star:setVisible(true)
            Panel_hero_infor_star:setBackGroundImage("images/ui/state/big_star_"..stars_level..".png")
            Panel_hero_star:setBackGroundImage("images/ui/state/big_star_"..stars_level..".png")
        end
    end

    local ship_mould_id = self.ship.ship_template_id
    local temp_bust_index = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.bust_index)        --半身像下标
    local Panel_hero_spine_role = ccui.Helper:seekWidgetByName(root,"Panel_hero_spine_role")            --英雄信息面板
    local function onUpdateHeroIcon()
        if Panel_hero_spine_role ~= nil then
            Panel_hero_spine_role:removeAllChildren(true)
            local jsonPath = "images/face/big_head/big_head_" .. temp_bust_index .. ".json"
            local atlasPath = "images/face/big_head/big_head_" .. temp_bust_index .. ".atlas"
            if cc.FileUtils:getInstance():isFileExist(jsonPath) == true then
                local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
                animation:setPosition(cc.p(Panel_hero_spine_role:getContentSize().width/2,Panel_hero_spine_role:getContentSize().height/2))
                Panel_hero_spine_role:addChild(animation)
            end
        end
    end
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
    	if _ED.hero_main_Preloading_1==0 then
			onUpdateHeroIcon()
		else
			local run_action  = cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(onUpdateHeroIcon))
			self:runAction(run_action)
		end
    else
		onUpdateHeroIcon()
    end

    local Panel_hero_cg_role = ccui.Helper:seekWidgetByName(root,"Panel_hero_cg_role")
    Panel_hero_cg_role:removeBackGroundImage()
    Panel_hero_cg_role:setBackGroundImage("images/face/card_hero/card_hero_"..temp_bust_index..".png")  
    --名字
    local Text_hero_infor_name = ccui.Helper:seekWidgetByName(root,"Text_hero_infor_name")
    Text_hero_infor_name:setString(self.ship.captain_name)
    Text_hero_infor_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[self.ship.ship_type+1][1],tipStringInfo_quality_color_Type[self.ship.ship_type+1][2],tipStringInfo_quality_color_Type[self.ship.ship_type+1][3]))
    
    --职业
    local Text_hero_occupation_infor = ccui.Helper:seekWidgetByName(root,"Text_hero_occupation_infor")
    Text_hero_occupation_infor:setString(red_alert_hero_job[self.ship.capacity])

    --类型
    local Text_hero_types_infor = ccui.Helper:seekWidgetByName(root,"Text_hero_types_infor")
    Text_hero_types_infor:setString(red_alert_hero_type[self.ship.capacity])
    
    --兵力
    local Text_troops_infor = ccui.Helper:seekWidgetByName(root,"Text_troops_infor")
    Text_troops_infor:setString(math.ceil(self.ship.ship_health))
    
    --攻击
    local Text_attack_infor = ccui.Helper:seekWidgetByName(root,"Text_attack_infor")
    Text_attack_infor:setString(math.ceil(self.ship.ship_courage))

    --攻速
    local Text_ias_infor = ccui.Helper:seekWidgetByName(root,"Text_ias_infor")
    Text_ias_infor:setString(math.ceil(self.ship.attack_speed))

    --聚气
    local Text_gas_gathering_infor = ccui.Helper:seekWidgetByName(root,"Text_gas_gathering_infor")
    Text_gas_gathering_infor:setString(math.ceil(self.ship.gas_gather))

    --物防
    local Text_anti_matter_infor = ccui.Helper:seekWidgetByName(root,"Text_anti_matter_infor")
    Text_anti_matter_infor:setString(math.ceil(self.ship.ship_quick))

    --法防
    local Text_law_against_infor = ccui.Helper:seekWidgetByName(root,"Text_law_against_infor")
    Text_law_against_infor:setString(math.ceil(self.ship.ship_intellect))

    --命中
    local Text_hit_infor = ccui.Helper:seekWidgetByName(root,"Text_hit_infor")
    Text_hit_infor:setString(math.ceil(self.ship.hit))

    --闪躲
    local Text_dodge_infor = ccui.Helper:seekWidgetByName(root,"Text_dodge_infor")
    Text_dodge_infor:setString(math.ceil(self.ship.dodge))

    --暴击
    local Text_crit_infor = ccui.Helper:seekWidgetByName(root,"Text_crit_infor")
    Text_crit_infor:setString(math.ceil(self.ship.crit))

    --韧性 
    local Text_toughness_infor = ccui.Helper:seekWidgetByName(root,"Text_toughness_infor")
    Text_toughness_infor:setString(math.ceil(self.ship.toughness))

    --格挡 
    local Text_parry_infor = ccui.Helper:seekWidgetByName(root,"Text_parry_infor")
    Text_parry_infor:setString(math.ceil(self.ship.block))

    --破击
    local Text_wreck_infor = ccui.Helper:seekWidgetByName(root,"Text_wreck_infor")
    Text_wreck_infor:setString(math.ceil(self.ship.wreck))
                            
end

-- 延迟加载侠客cell
function HeroMain:onUpdateHeroIcon()
    local root = self.roots[1]
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root,"ListView_hero_icon")
    local index = 1
    local result = self:getSortForFight()
    for i,ship in pairs(result) do
        if index > 7 then 
            local cell = state_machine.excute("hero_icon_create_cell",0,{ship,2,index})
            ListView_hero_icon:addChild(cell)
        end
        index = index + 1
    end
    ListView_hero_icon:requestRefreshView()
    self.listview = ListView_hero_icon
    self.listview_pox = ListView_hero_icon:getInnerContainer():getPositionX()
end

--刷新英雄icon列表
function HeroMain:onUpdateDraw()
    local root = self.roots[1]   
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root,"ListView_hero_icon")      --英雄icon列表
    local cells = ListView_hero_icon:getItems()
    -- if nil == self.listview then
        ListView_hero_icon:removeAllItems()
        local baseShip = _ED.user_ship[""..self.ship.ship_id]
        local index = 1
        local result = self:getSortForFight()
        for i,ship in pairs(result) do
            local cell = state_machine.excute("hero_icon_create_cell",0,{ship,2,index})
            index = index + 1
            ListView_hero_icon:addChild(cell)
            if baseShip == nil then
                baseShip = ship
            end
        end
        self.ship = baseShip
        ListView_hero_icon:requestRefreshView()
        self.listview = ListView_hero_icon
        self.listview_pox = ListView_hero_icon:getInnerContainer():getPositionX()
        ListView_hero_icon:getInnerContainer():setPositionX(0)
    -- else
    --     local items = self:getSortForFight()
    --     for i, v in pairs(cells) do
    --         local alive = false
    --         for n, m in pairs(items) do
    --             if v.ship == m then
    --                 alive = true
    --                 break
    --             end
    --         end
    --         if false == alive then
    --             ListView_hero_icon:removeItem(ListView_hero_icon:getIndex(v))
    --         else
    --             v:unload()
    --             v:reload()
    --         end
    --     end
    -- end
    self:setHeroCellSelected(self.ship)
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
    	if _ED.hero_main_Preloading_2==0 then
			self:onUpdateHeroIcon()
		else
			local run_action  = cc.Sequence:create(cc.DelayTime:create(_ED.hero_main_Preloading_2),cc.CallFunc:create(self.onUpdateHeroIcon))
			self:runAction(run_action)
		end
    end
end

--移除英雄icon
function HeroMain:removeListViewItem(ship)
    local root = self.roots[1]   
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root,"ListView_hero_icon")      --英雄icon列表
    for i,cell in pairs(ListView_hero_icon:getItems()) do
        if cell.ship == ship then
            ListView_hero_icon:removeItem(ListView_hero_icon:getIndex(cell))
            break
        end
    end
    ListView_hero_icon:requestRefreshView()
end

--添加英雄icon
function HeroMain:addListViewItem(ship)
    local root = self.roots[1]   
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root,"ListView_hero_icon")      --英雄icon列表
    local cell = state_machine.excute("hero_icon_create_cell",0,{ship,2,0})
    ListView_hero_icon:addChild(cell)
    ListView_hero_icon:requestRefreshView()
end

--打开英雄成长界面
function HeroMain:openHeroGrowUp()
    local root = self.roots[1]
    local Panel_label_switching = ccui.Helper:seekWidgetByName(root,"Panel_label_switching")    --英雄成长界面
    state_machine.excute("hero_main_grow_up_window_open",0,{Panel_label_switching,self.ship})
	local function onShowWindow()
		state_machine.excute("hero_main_maneger",0,{_datas = {
			terminal_name = "hero_main_maneger",     
			next_terminal_name = "hero_main_change_to_star_page", 
			current_button_name = "Button_rising_star",   
			but_image = "",     
			terminal_state = 0, 
			fun_open_id = 91,
			touch_scale = true,
			touch_scale_xy = 0.95, 
		}})
	end
	if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		if _ED.hero_main_Preloading_2==0 then
			onShowWindow()
		else
			local run_action  = cc.Sequence:create(cc.DelayTime:create(_ED.hero_main_Preloading_2),cc.CallFunc:create(onShowWindow))
			self:runAction(run_action)
		end
	else
		onShowWindow()
	end	
end

--更新坐标
function HeroMain:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posx = self.listview:getInnerContainer():getPositionX()
        if self.listview_pox == posx then
            return
        end
        self.listview_pox = posx
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempx = v:getPositionX() + posx
            if tempx + itemSize.width * 2 < 0 or tempx > size.width + itemSize.width * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function HeroMain:getSortForFight()
    local result = {}
    for i,v in pairs(_ED.user_ship) do
        table.insert(result,v)
    end
    local all_result = {}
    local in_formation = {}
    local in_raleship = {}
    local gold_ship = {} -- 6
    local red_ship = {}  -- 5
    local orange_ship = {} -- 4
    local purple_ship = {} -- 3
    local blue_ship = {} -- 2 
    local green_ship = {} -- 1
    local white_ship = {} -- 0
    local function sortShipFight( a, b )
        return tonumber(a.hero_fight) > tonumber(b.hero_fight)
    end
    table.sort(result, sortShipFight)


    for i,ship in pairs(result) do
        -- debug.print_r(ship)
        if zstring.tonumber(ship.formation_index) > 0 then
            -- table.insert(in_formation, ship)
        elseif zstring.tonumber(ship.little_partner_formation_index) > 0 then
        --     table.insert(in_raleship, ship)
        elseif zstring.tonumber(ship.ship_type) == 6 then
            table.insert(gold_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 5 then
            table.insert(red_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 4 then
            table.insert(orange_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 3 then
            table.insert(purple_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 2 then
            table.insert(blue_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 1 then
            table.insert(green_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 0 then
            table.insert(white_ship, ship)
        end
    end
    self.ship_numbers = 0
    -- for i,v in pairs(in_formation) do
    --    table.insert(all_result,v)
    -- end
    local formation_temp = {}
    local position_str = dms.string(dms["formation_mould"],tonumber(_ED.formetion[1]),formation_mould.position)
    position_str = zstring.split(position_str,",")
    for i,v in pairs(position_str) do
        if zstring.tonumber(_ED.formetion[i+1]) ~= 0 then
            table.insert(formation_temp,_ED.user_ship["".._ED.formetion[i+1]])
        end
    end

    local formation_temp_change_index = {}
    for i,v in pairs(formation_temp) do
        table.insert(formation_temp_change_index,formation_temp[#formation_temp-i+1])
    end

    for i,v in pairs(formation_temp_change_index) do
       table.insert(all_result,v)
    end
    
    for i,v in pairs(in_raleship) do
       table.insert(all_result,v)
    end

    for i,v in pairs(gold_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(red_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(orange_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(purple_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(blue_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(green_ship) do
        table.insert(all_result,v)
    end  
    for i,v in pairs(white_ship) do
       table.insert(all_result,v)
    end
    return all_result
end

--清除英雄icon列表
function HeroMain:close()
    local root = self.roots[1]
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root,"ListView_hero_icon")      --英雄icon列表
    ListView_hero_icon:removeAllItems()
    self:stopAllActions()
end

--初始化
function HeroMain:init(ship)
    self.user_ships = self:getSortForFight()
    self.ship = ship or self.user_ships[1]
    self:onInit()
end

function HeroMain:destroy()
    if fwin:find("NationalWarMapClass") == nil then
        cc.SpriteFrameCache:getInstance():removeSpriteFrames() 
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end
	_ED.hero_main_Preloading_1 = 0
	_ED.hero_main_Preloading_2 = 0
end

--移除状态机
function HeroMain:onExit()
    state_machine.remove("hero_main_window_show")
    state_machine.remove("hero_main_window_hide")
    state_machine.remove("hero_main_show_information_or_icon")
    state_machine.remove("hero_main_change_ship")
    state_machine.remove("hero_main_maneger")
    state_machine.remove("hero_main_change_to_star_page")
    state_machine.remove("hero_main_change_to_skills_page")
    state_machine.remove("hero_main_change_to_relaship_page")
    state_machine.remove("hero_main_change_to_god_hero")    
    state_machine.remove("hero_main_remove_list_item")
    state_machine.remove("hero_main_add_list_item")
    state_machine.remove("hero_main_update_draw")
    state_machine.remove("hero_main_update_draw_role_effect")
    state_machine.remove("hero_main_update_hero_info")
end