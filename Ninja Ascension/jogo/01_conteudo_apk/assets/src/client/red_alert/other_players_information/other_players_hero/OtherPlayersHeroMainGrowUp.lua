-----------------------------
--英雄养成界面
-----------------------------
OtherPlayersHeroMainGrowUp = class("OtherPlayersHeroMainGrowUpClass", Window)

local other_players_hero_main_grow_up_window_open_terminal = {
    _name = "other_players_hero_main_grow_up_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("OtherPlayersHeroMainGrowUpClass")
        if nil == _Window then
            fwin:open(OtherPlayersHeroMainGrowUp:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(other_players_hero_main_grow_up_window_open_terminal)
state_machine.init()

function OtherPlayersHeroMainGrowUp:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship = nil
    
    -- 文字动画显示文字
    self._text_table = nil
    -- Initialize other_players_hero_main_grow_up state machine.
    local function init_other_players_hero_main_grow_up_terminal()
	
		--显示界面
		local other_players_hero_main_grow_up_window_show_terminal = {
            _name = "other_players_hero_main_grow_up_window_show",
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
		local other_players_hero_main_grow_up_window_hide_terminal = {
            _name = "other_players_hero_main_grow_up_window_hide",
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
        local other_players_hero_main_grow_up_change_ship_terminal = {
            _name = "other_players_hero_main_grow_up_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if params ~= "" and params ~= nil then
                    instance.ship = params 
                end
                instance:onUpdateDraw()
                instance:setHeroIcon()
                state_machine.excute("other_players_hero_main_star_up_change_ship",0,instance.ship)
                state_machine.excute("other_players_hero_main_skills_up_change_ship",0,instance.ship)
                state_machine.excute("other_players_hero_main_update_draw_role_effect",0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 设置角色属性的可见性
        local other_players_hero_main_grow_up_set_visible_property_terminal = {
            _name = "other_players_hero_main_grow_up_set_visible_property",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisibleProperty(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

		state_machine.add(other_players_hero_main_grow_up_window_show_terminal)	
		state_machine.add(other_players_hero_main_grow_up_window_hide_terminal)
        state_machine.add(other_players_hero_main_grow_up_change_ship_terminal)
        state_machine.add(other_players_hero_main_grow_up_set_visible_property_terminal)
        state_machine.init()
    end
    
    -- call func init other_players_hero_main_grow_up state machine.
    init_other_players_hero_main_grow_up_terminal()
end

function OtherPlayersHeroMainGrowUp:onHide( ... )
    self:setVisible(false)
end

function OtherPlayersHeroMainGrowUp:onShow( ... )
    self:setVisible(true)
end

function OtherPlayersHeroMainGrowUp:setVisibleProperty(visible)
     local root = self.roots[1]
     local Panel_star_up = ccui.Helper:seekWidgetByName(root,"Panel_star_up")
    Panel_star_up:setVisible(visible)
end

function OtherPlayersHeroMainGrowUp:onUpdateDraw()
    local root = self.roots[1]
    local Text_role_infor_name = ccui.Helper:seekWidgetByName(root,"Text_role_infor_name")
    local Text_fighting_force = ccui.Helper:seekWidgetByName(root,"Text_fighting_force")
    local Text_occupation_infor = ccui.Helper:seekWidgetByName(root,"Text_occupation_infor")
    local Text_types_infor = ccui.Helper:seekWidgetByName(root,"Text_types_infor")
    local Text_qualification_infor = ccui.Helper:seekWidgetByName(root,"Text_qualification_infor")
    local Text_hero_grow_lv = ccui.Helper:seekWidgetByName(root,"Text_hero_grow_lv")
    -- local ability = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.ability)
    Text_hero_grow_lv:setString("Lv"..self.ship.ship_level)
    Text_hero_grow_lv:setColor(cc.c3b(tipStringInfo_quality_color_Type[self.ship.ship_type+1][1],tipStringInfo_quality_color_Type[self.ship.ship_type+1][2],tipStringInfo_quality_color_Type[self.ship.ship_type+1][3]))
    Text_role_infor_name:setString(self.ship.captain_name .. "+" .. self.ship.skill_grow_up_level)
    Text_role_infor_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[self.ship.ship_type+1][1],tipStringInfo_quality_color_Type[self.ship.ship_type+1][2],tipStringInfo_quality_color_Type[self.ship.ship_type+1][3]))
    Text_fighting_force:setString(self.ship.hero_fight)
    Text_occupation_infor:setString(red_alert_hero_job[self.ship.capacity])
    Text_types_infor:setString(red_alert_hero_type[self.ship.capacity]) 
    -- Text_qualification_infor:setString(tipStringInfo_hero_ability[ability])

    local skill_name = dms.string(dms["ship_mould"],self.ship.ship_template_id,ship_mould.skill_name)
    Text_qualification_infor:setString(skill_name)

    local stars,stars_level = getHeroStars(self.ship.ship_template_id)
    for i=1,3 do
        local Panel_grow_star = ccui.Helper:seekWidgetByName(root,"Panel_grow_star_"..i)
        Panel_grow_star:removeBackGroundImage()
        if i > stars  then
            Panel_grow_star:setVisible(false)
        else
            Panel_grow_star:setVisible(true)
            Panel_grow_star:setBackGroundImage("images/ui/state/big_star_"..stars_level..".png")
        end
    end    
end

function OtherPlayersHeroMainGrowUp:onEnterTransitionFinish()

end

function OtherPlayersHeroMainGrowUp:setHeroIcon()
    local action = cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(self.delayDrawHero))
    self:runAction(action) 
end

function OtherPlayersHeroMainGrowUp:delayDrawHero()
    local root = self.roots[1]
    local Panel_hero_grow_animation = ccui.Helper:seekWidgetByName(root,"Panel_hero_grow_animation")
    if nil == Panel_hero_grow_animation or Panel_hero_grow_animation:isVisible() == false then
        return
    end
    Panel_hero_grow_animation:removeAllChildren(true)
    local ship = self.ship
    local ship_mould_id = ship.ship_template_id
    app.load("client.battle.fight.FightEnum")
    local temp_bust_index = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.bust_index)
    temp_bust_index = 10000 + temp_bust_index
    local armature = sp.spine_sprite(Panel_hero_grow_animation, temp_bust_index, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_10+1], true, nil, nil, cc.p(0.5, 0))
    armature:setPosition(cc.p(Panel_hero_grow_animation:getContentSize().width/2, 0))  

end

function OtherPlayersHeroMainGrowUp:openHeroSkillsUp()
    local root = self.roots[1]
    local Panel_skills_star = ccui.Helper:seekWidgetByName(root,"Panel_skills_star")

    state_machine.excute("other_players_hero_main_star_up_window_open",0,{Panel_skills_star,self.ship})
    -- 取消技能在英雄界面中显示
    -- state_machine.excute("other_players_hero_main_skills_up_window_open",0,{Panel_skills_star,self.ship})
    -- 添加武学突破信息显示
    -- app.load("client.red_alert.hero.HeroMainGradeUp")
    -- state_machine.excute("hero_main_grade_up_window_open",0,{Panel_skills_star,self.ship, 1})
    app.load("client.red_alert.other_players_information.other_players_hero.OtherPlayersHeroMainGradeUp")
    state_machine.excute("other_players_hero_main_grade_up_window_open",0,{Panel_skills_star,self.ship, 1})
end

function OtherPlayersHeroMainGrowUp:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_main_grow_up)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    -- 一键分享
    local Button_share = ccui.Helper:seekWidgetByName(root,"Button_share")  
    if Button_share ~= nil then
        Button_share:setVisible(false)
    end
    
	self:onUpdateDraw()
    self:openHeroSkillsUp()	
    self:setHeroIcon()
end

function OtherPlayersHeroMainGrowUp:close()
    local root = self.roots[1]
    local Panel_hero_grow_animation = ccui.Helper:seekWidgetByName(root,"Panel_hero_grow_animation")
    Panel_hero_grow_animation:removeAllChildren(true)
end

function OtherPlayersHeroMainGrowUp:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.ship = params[2]
	self:onInit()
    return self
end

function OtherPlayersHeroMainGrowUp:onExit()
    state_machine.remove("other_players_hero_main_grow_up_window_show")  
    state_machine.remove("other_players_hero_main_grow_up_window_hide")
    state_machine.remove("other_players_hero_main_grow_up_change_ship")
    state_machine.remove("other_players_hero_main_grow_up_set_visible_property")
end
