--------------------------------------------------------------------------------------------------------------
--  说明：武将首页
--------------------------------------------------------------------------------------------------------------
OtherPlayersHeroMain = class("OtherPlayersHeroMainClass", Window)

--打开界面
local other_players_hero_main_window_open_terminal = {
	_name = "other_players_hero_main_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTip(66) == true then
            return
        end    
        if fwin:find("OtherPlayersHeroMainClass") == nil then
            local _win = OtherPlayersHeroMain:new()
            _win:init(params)
            fwin:open(_win,fwin._windows)
        end
        -- state_machine.excute("other_players_hero_main_window_show",0,"")
        -- state_machine.excute("main_window_hide", 0, "")
        -- state_machine.excute("player_resource_window_hide", 0, "")     
        -- state_machine.excute("home_button_for_action_window_hide",0,"")
        -- state_machine.excute("chat_view_window_hide",0,"")  
        -- state_machine.excute("duplicate_title_window_hide",0,"") 
        -- state_machine.excute("duplicate_map_window_hide",0,"")
        -- state_machine.excute("duplicate_manager_window_hide",0,"")
        -- state_machine.excute("user_info_window_hide", 0, "")
        -- state_machine.excute("ranking_window_hide", 0, "")
        -- -- state_machine.excute("chat_sent_window_close_action", 0, "")
        -- state_machine.excute("chat_sent_window_hide", 0, "")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local other_players_hero_main_window_close_terminal = {
	_name = "other_players_hero_main_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("OtherPlayersHeroMainClass"))

        -- if fwin:find("NationalWarMapClass") ~= nil then
        --     -- state_machine.excute("player_resource_window_show",0,"")   
        --     state_machine.excute("home_button_for_action_window_show",0,"")  
        -- elseif fwin:find("DuplicateManagerClass") == nil then
        --     if fwin:find("CampaignClass") ~= nil then
        --         state_machine.excute("campaign_window_show",0,"")
        --         state_machine.excute("home_button_for_action_window_hide",0,"") 
        --         state_machine.excute("chat_view_window_hide",0,"")
        --     elseif fwin:find("UnionClass") ~= nil then
        --     elseif fwin:find("CatalogueStorageClass") ~= nil then
        --     else
        --         state_machine.excute("main_window_show",0,"")
        --         state_machine.excute("player_resource_window_show",0,"")   
        --         state_machine.excute("home_button_for_action_window_show",0,"")  
        --         state_machine.excute("chat_view_window_show",0,"")
        --         state_machine.excute("duplicate_title_window_show",0,"")
        --         state_machine.excute("user_info_window_show", 0, "")
        --         state_machine.excute("ranking_window_show", 0, "")
        --     end
        -- else
        --     state_machine.excute("home_button_for_action_window_show",0,"")  
        --     state_machine.excute("chat_view_window_show",0,"")
        --     state_machine.excute("duplicate_title_window_show",0,"")  
        --     state_machine.excute("duplicate_map_window_show",0,"")   
        --     state_machine.excute("duplicate_manager_window_show",0,"")   
        --     state_machine.excute("hero_star_activation_window_close",0,"")
        --     state_machine.excute("user_info_window_show", 0, "")
        --     state_machine.excute("ranking_window_show", 0, "")
        -- end
        
        state_machine.excute("national_city_hide_game_resource_info", 0, nil)
        -- clear cacher
        cacher.clearWindowCacher()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(other_players_hero_main_window_open_terminal)
state_machine.add(other_players_hero_main_window_close_terminal)
state_machine.init()

function OtherPlayersHeroMain:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    -- load lua file
    app.load("client.red_alert_time.cells.hero.hero_icon_cell")
    app.load("client.red_alert_time.cells.hero.hero_main_skills_up_cell")
    app.load("client.red_alert_time.packs.herostorage.HeroPacks")
    app.load("client.red_alert_time.packs.herostorage.HeroStarSkillsIconInfor")
    app.load("client.red_alert_time.packs.herostorage.HeroStarSkillsInforProperty")
    app.load("client.red_alert_time.packs.herostorage.HeroStarTalentInfor")
    app.load("client.red_alert_time.hero.HeroMainSkillsUp")
    app.load("client.red_alert_time.other_players_information.other_players_hero.OtherPlayersHeroAttributes")
    app.load("client.red_alert_time.other_players_information.other_players_hero.OtherPlayersHeroFetters")
    app.load("client.red_alert_time.other_players_information.other_players_hero.OtherPlayersHeroMainGrowUp")
    app.load("client.red_alert_time.other_players_information.other_players_hero.OtherPlayersHeroMainSkillsUp")
    app.load("client.red_alert_time.other_players_information.other_players_hero.OtherPlayersHeroMainStarUp")
    app.load("client.red_alert_time.other_players_information.other_players_hero.OtherPlayersHeroMainGradeUp")
    --var
    self.hero_type = nil -- 1 信息 -- 2 形象
    --英雄icon列表
    self.listview = nil 
    --列表x轴
    self.listview_pox = nil

    self.catalogue_ship = nil

	 -- Initialize other_players_hero_main state machine.
    local function init_other_players_hero_main_terminal()
        --管理
        local other_players_hero_main_maneger_terminal = {
        _name = "other_players_hero_main_maneger",
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
		local other_players_hero_main_window_show_terminal = {
            _name = "other_players_hero_main_window_show",
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
		-- 隐藏所有
        local other_players_hero_main_window_hide_terminal = {
            _name = "other_players_hero_main_window_hide",
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
        local other_players_hero_main_show_information_or_icon_terminal = {
            _name = "other_players_hero_main_show_information_or_icon",
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
        local other_players_hero_main_change_ship_terminal = {
            _name = "other_players_hero_main_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= "" and params ~= nil then
                    instance.ship = params 
                end
                state_machine.excute("other_players_hero_main_grow_up_change_ship",0,instance.ship)
                state_machine.excute("other_players_hero_fetters_change_ship",0,instance.ship)
                state_machine.excute("other_players_hero_main_grade_up_change_ship", 0, instance.ship)
                instance:setHeroInfo()
                instance:onUpdateDraw()
                instance:setHeroCellSelected(instance.ship)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 升星
        local other_players_hero_main_change_to_star_page_terminal = {
            _name = "other_players_hero_main_change_to_star_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("other_players_hero_main_grow_up_window_show",0,"")
                state_machine.excute("other_players_hero_main_star_up_window_show",0,"")
                state_machine.excute("other_players_hero_main_grow_up_set_visible_property", 0, true)

                state_machine.excute("other_players_hero_main_skills_up_window_hide",0,"")
                state_machine.excute("other_players_hero_main_grade_up_window_hide", 0, 0)
                state_machine.excute("other_players_hero_fetters_window_hide",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
     
        -- 天赋
        local other_players_hero_main_change_to_skills_page_terminal = {
            _name = "other_players_hero_main_change_to_skills_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("other_players_hero_main_grow_up_window_show",0,"")
                state_machine.excute("other_players_hero_main_skills_up_window_show",0,"")
                state_machine.excute("other_players_hero_main_grade_up_window_show", 0, 0)

                state_machine.excute("other_players_hero_main_star_up_window_hide",0,"")
                state_machine.excute("other_players_hero_fetters_window_hide",0,"")
                state_machine.excute("other_players_hero_main_grow_up_set_visible_property", 0, false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        -- 羁绊
        local other_players_hero_main_change_to_relaship_page_terminal = {
            _name = "other_players_hero_main_change_to_relaship_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local Panel_label_switching = ccui.Helper:seekWidgetByName(root,"Panel_label_switching")
                state_machine.excute("other_players_hero_fetters_window_open",0,{Panel_label_switching,instance.ship}) 

                state_machine.excute("other_players_hero_fetters_window_show",0,"") 

                state_machine.excute("other_players_hero_main_grow_up_window_hide",0,"")
                state_machine.excute("other_players_hero_main_grow_up_set_visible_property", 0, false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 移除某个头像
        local other_players_hero_main_remove_list_item_terminal = {
            _name = "other_players_hero_main_remove_list_item",
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
        local other_players_hero_main_add_list_item_terminal = {
            _name = "other_players_hero_main_add_list_item",
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

        -- 更新角色形象
        local other_players_hero_main_update_draw_role_effect_terminal = {
            _name = "other_players_hero_main_update_draw_role_effect",
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

        state_machine.add(other_players_hero_main_maneger_terminal)
		state_machine.add(other_players_hero_main_window_show_terminal)
		state_machine.add(other_players_hero_main_window_hide_terminal)	
        state_machine.add(other_players_hero_main_show_information_or_icon_terminal)
        state_machine.add(other_players_hero_main_change_ship_terminal)
        state_machine.add(other_players_hero_main_change_to_star_page_terminal)
        state_machine.add(other_players_hero_main_change_to_skills_page_terminal)
        state_machine.add(other_players_hero_main_change_to_relaship_page_terminal)
        state_machine.add(other_players_hero_main_remove_list_item_terminal)
        state_machine.add(other_players_hero_main_add_list_item_terminal)
        state_machine.add(other_players_hero_main_update_draw_role_effect_terminal)
        state_machine.init()
    end
    
    -- call func other_players_hero_main create state machine.
    init_other_players_hero_main_terminal()

end

--设置英雄icon选择
function OtherPlayersHeroMain:setHeroCellSelected(ship)
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
function OtherPlayersHeroMain:onShow()
   self:setVisible(true)
end

--隐藏
function OtherPlayersHeroMain:onHide()
   self:setVisible(false)
end

--初始化界面
function OtherPlayersHeroMain:onInit()
    local csbItem = csb.createNode(config_csb.hero.hero_main)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    local action = csb.createTimeline(config_csb.hero.hero_main)
    action:setTimeSpeed(app.getTimeSpeed())
    table.insert(self.actions, action)

    csbItem:runAction(action)    

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
    
    --传说按钮
    local Button_god_hero = ccui.Helper:seekWidgetByName(root,"Button_god_hero")
    Button_god_hero:setVisible(false)
    --英雄包裹
    local Button_hero_pack = ccui.Helper:seekWidgetByName(root,"Button_hero_pack")
    Button_hero_pack:setVisible(false)
    --侠客录
    local Button_role_register = ccui.Helper:seekWidgetByName(root,"Button_role_register")
    if Button_role_register ~= nil then
        Button_role_register:setVisible(false)
    end
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_main_back"), nil, 
    {
        terminal_name = "other_players_hero_main_window_close", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)     
    -- 翻页显示英雄信息
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_hero_infor"), nil, 
    {
        terminal_name = "other_players_hero_main_show_information_or_icon", 
        terminal_state = 0, 
        cell = self, 
    }, nil, 0)      
    -- 翻页显示英雄形象
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_hero_cg_role"), nil, 
    {
        terminal_name = "other_players_hero_main_show_information_or_icon", 
        terminal_state = 0, 
        cell = self, 
    }, nil, 0) 
    --显示属性介绍
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_attributes"), nil, 
    {
        terminal_name = "other_players_hero_attributes_window_open", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)     
    --升星
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rising_star"), nil, 
    {
        terminal_name = "other_players_hero_main_maneger",     
        next_terminal_name = "other_players_hero_main_change_to_star_page", 
        current_button_name = "Button_rising_star",   
        but_image = "",     
        terminal_state = 0, 
        fun_open_id = 91,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)      

    --天赋
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_talent"), nil, 
    {
        terminal_name = "other_players_hero_main_maneger",     
        next_terminal_name = "other_players_hero_main_change_to_skills_page", 
        current_button_name = "Button_talent",   
        but_image = "",     
        terminal_state = 0, 
        fun_open_id = 92,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)   

    --羁绊
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fetters"), nil, 
    {
        terminal_name = "other_players_hero_main_maneger",     
        next_terminal_name = "other_players_hero_main_change_to_relaship_page", 
        current_button_name = "Button_fetters",   
        but_image = "",     
        terminal_state = 0, 
        fun_open_id = 93,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)      

	self:onUpdateDraw()
    self:openHeroGrowUp()
    self:setHeroInfo() 
    self:setHeroIcon()
end

function OtherPlayersHeroMain:onEnterTransitionFinish()

end

function OtherPlayersHeroMain:setHeroIcon()
    local action = cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(self.delayDrawHero))
    self:runAction(action) 
end

function OtherPlayersHeroMain:delayDrawHero()
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

end

--设置英雄信息
function OtherPlayersHeroMain:setHeroInfo()
    local root = self.roots[1]
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

    local Panel_hero_cg_role = ccui.Helper:seekWidgetByName(root,"Panel_hero_cg_role")              --英雄信息面板
    Panel_hero_cg_role:removeBackGroundImage()
    local ship_mould_id = self.ship.ship_template_id
    local temp_bust_index = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.bust_index)        --半身像下标
    Panel_hero_cg_role:setBackGroundImage("images/face/card_hero/card_hero_"..temp_bust_index..".png")  
    
    local Panel_hero_spine_role = ccui.Helper:seekWidgetByName(root,"Panel_hero_spine_role")            --英雄信息面板
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

--刷新英雄icon列表
function OtherPlayersHeroMain:onUpdateDraw()
    local root = self.roots[1]   
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root,"ListView_hero_icon")      --英雄icon列表
    ListView_hero_icon:removeAllItems()
    local index = 1
    for i,ship in pairs(self:getSortForFight()) do
        local cell = state_machine.excute("hero_icon_create_cell",0,{ship,6,index})
        index = index + 1
        ListView_hero_icon:addChild(cell)
    end
    ListView_hero_icon:requestRefreshView()
    self.listview = ListView_hero_icon
    self.listview_pox = ListView_hero_icon:getInnerContainer():getPositionX()

    self:setHeroCellSelected(self.ship)
    if table.nums(self.user_ships) <= 1 then
        ccui.Helper:seekWidgetByName(root,"ListView_hero_icon"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Image_hero_icon_ins"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root,"ListView_hero_icon"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Image_hero_icon_ins"):setVisible(true)
    end
end

--移除英雄icon
function OtherPlayersHeroMain:removeListViewItem(ship)
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
function OtherPlayersHeroMain:addListViewItem(ship)
    local root = self.roots[1]   
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root,"ListView_hero_icon")      --英雄icon列表
    local cell = state_machine.excute("hero_icon_create_cell",0,{ship,2,0})
    ListView_hero_icon:addChild(cell)
    ListView_hero_icon:requestRefreshView()
end

--打开英雄成长界面
function OtherPlayersHeroMain:openHeroGrowUp( ... )
    local root = self.roots[1]
    local Panel_label_switching = ccui.Helper:seekWidgetByName(root,"Panel_label_switching")    --英雄成长界面
    state_machine.excute("other_players_hero_main_grow_up_window_open",0,{Panel_label_switching,self.ship})
	local function onShowWindow()
		state_machine.excute("other_players_hero_main_maneger",0,{_datas = {
			terminal_name = "other_players_hero_main_maneger",     
			next_terminal_name = "other_players_hero_main_change_to_star_page", 
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
function OtherPlayersHeroMain:onUpdate(dt)
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

function OtherPlayersHeroMain:getSortForFight()
    local result = {}
    if _ED.other_user_ship ~= nil then
        for i,v in pairs(_ED.other_user_ship) do
            if tonumber(v.little_partner_formation_index) <= 0 then
                table.insert(result,v)
            end
        end
    end
    if #result == 0 and nil ~= self.ship then
        table.insert(result,self.ship)
    end
    return result
end

--清除英雄icon列表
function OtherPlayersHeroMain:close()
    local root = self.roots[1]
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root,"ListView_hero_icon")      --英雄icon列表
    ListView_hero_icon:removeAllItems()
end

--初始化
function OtherPlayersHeroMain:init(ship)
    self.user_ships = self:getSortForFight()
    self.ship = ship or self.user_ships[1]
    self:onInit()
end

--移除状态机
function OtherPlayersHeroMain:onExit()
    -- call
    state_machine.excute("chat_sent_window_show", 0, "")
    _ED.other_user_ship = nil
    -- remove 
    state_machine.remove("other_players_hero_main_window_show")
    state_machine.remove("other_players_hero_main_window_hide")
    state_machine.remove("other_players_hero_main_show_information_or_icon")
    state_machine.remove("other_players_hero_main_change_ship")
    state_machine.remove("other_players_hero_main_maneger")
    state_machine.remove("other_players_hero_main_change_to_star_page")
    state_machine.remove("other_players_hero_main_change_to_skills_page")
    state_machine.remove("other_players_hero_main_change_to_relaship_page")
    state_machine.remove("other_players_hero_main_remove_list_item")
    state_machine.remove("other_players_hero_main_add_list_item")
    state_machine.remove("other_players_hero_main_update_draw_role_effect")
end