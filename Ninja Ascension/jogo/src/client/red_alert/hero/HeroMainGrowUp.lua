-----------------------------
--英雄养成界面
-----------------------------
HeroMainGrowUp = class("HeroMainGrowUpClass", Window)

local hero_main_grow_up_window_open_terminal = {
    _name = "hero_main_grow_up_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroMainGrowUpClass")
        if nil == _Window then
            fwin:open(HeroMainGrowUp:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_main_grow_up_window_open_terminal)
state_machine.init()

function HeroMainGrowUp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship = nil
    
    -- load lua file
    app.load("client.utils.ConfirmTip")
    -- 文字动画显示文字
    self._text_table = nil
    -- Initialize hero_main_grow_up state machine.
    local function init_hero_main_grow_up_terminal()
	
		--显示界面
		local hero_main_grow_up_window_show_terminal = {
            _name = "hero_main_grow_up_window_show",
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
		local hero_main_grow_up_window_hide_terminal = {
            _name = "hero_main_grow_up_window_hide",
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
        local hero_main_grow_up_change_ship_terminal = {
            _name = "hero_main_grow_up_change_ship",
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
                state_machine.excute("hero_main_star_up_change_ship",0,instance.ship)
                state_machine.excute("hero_main_skills_up_change_ship",0,instance.ship)
                state_machine.excute("hero_main_grade_up_change_ship",0,instance.ship)
                state_machine.excute("hero_main_update_draw_role_effect", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 星星动画
        local hero_talant_up_star_terminal = {
            _name = "hero_talant_up_star",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._text_table = params[2]
                instance:onShowStarsAction()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        
        -- 设置角色属性的可见性
        local hero_main_grow_up_set_visible_property_terminal = {
            _name = "hero_main_grow_up_set_visible_property",
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

        -- 一键分享
        local hero_main_grow_up_share_terminal = {
            _name = "hero_main_grow_up_share",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                app.load("client.red_alert.chat.ChatSent")
                local ship = params._datas.cell.ship
                -- ship.captain_name
                local tip = ConfirmTip:new()
                local info = string.format(red_alert_all_str[202])
                tip:init(instance, instance.aKeyToShare, info)
                fwin:open(tip,fwin._windows) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

		state_machine.add(hero_main_grow_up_window_show_terminal)	
		state_machine.add(hero_main_grow_up_window_hide_terminal)
        state_machine.add(hero_main_grow_up_change_ship_terminal)
        state_machine.add(hero_talant_up_star_terminal)
        state_machine.add(hero_main_grow_up_set_visible_property_terminal)
        state_machine.add(hero_main_grow_up_share_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_hero_main_grow_up_terminal()
end

function HeroMainGrowUp:onHide( ... )
    self:setVisible(false)
end

function HeroMainGrowUp:onShow( ... )
    self:setVisible(true)
end

function HeroMainGrowUp:aKeyToShare(sureNumber)
    if sureNumber == 0 then
        app.load("client.red_alert.chat.ChatSent")
        local ship = self.ship
        local str = "1&|&".._ED.user_info.user_id.."&|&"..ship.ship_id.."&|&" .. ship.ship_type .."&|&"..ship.captain_name..""
        protocol_command.send_message.param_list = str.."\r\n1\r\n0"
        NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, nil, nil, false, nil)
        TipDlg.drawTextDailog(red_alert_all_str[199])
    end
end

function HeroMainGrowUp:setVisibleProperty(visible)
     local root = self.roots[1]
     local Panel_star_up = ccui.Helper:seekWidgetByName(root,"Panel_star_up")
    Panel_star_up:setVisible(visible)
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
		if visible == false then
			local Panel_skills_star = ccui.Helper:seekWidgetByName(root,"Panel_skills_star")
			-- 添加武学突破信息显示
			app.load("client.red_alert.hero.HeroMainGradeUp")
			state_machine.excute("hero_main_grade_up_window_open",0,{Panel_skills_star,self.ship, 0})
		end
    end	
end

function HeroMainGrowUp:onUpdateDraw()
    local root = self.roots[1]
    --英雄名字
    local Text_role_infor_name = ccui.Helper:seekWidgetByName(root,"Text_role_infor_name")
    Text_role_infor_name:setString(self.ship.captain_name .. "+" .. self.ship.skill_grow_up_level)
    Text_role_infor_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[self.ship.ship_type+1][1],tipStringInfo_quality_color_Type[self.ship.ship_type+1][2],tipStringInfo_quality_color_Type[self.ship.ship_type+1][3]))
    --英雄战力
    local Text_fighting_force = ccui.Helper:seekWidgetByName(root,"Text_fighting_force")
    Text_fighting_force:setString(self.ship.hero_fight)
    --英雄职业
    local Text_occupation_infor = ccui.Helper:seekWidgetByName(root,"Text_occupation_infor")
    Text_occupation_infor:setString(red_alert_hero_job[self.ship.capacity])
    --英雄类型
    local Text_types_infor = ccui.Helper:seekWidgetByName(root,"Text_types_infor")
    Text_types_infor:setString(red_alert_hero_type[self.ship.capacity]) 
    --英雄资质
    local Text_qualification_infor = ccui.Helper:seekWidgetByName(root,"Text_qualification_infor")
    -- local ability = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.ability)
    local skill_name = dms.string(dms["ship_mould"],self.ship.ship_template_id,ship_mould.skill_name)
    -- Text_qualification_infor:setString(tipStringInfo_hero_ability[ability])
    Text_qualification_infor:setString(skill_name)  
    --英雄等级
    local Text_hero_grow_lv = ccui.Helper:seekWidgetByName(root,"Text_hero_grow_lv")
    Text_hero_grow_lv:setString("Lv".._ED.user_info.user_grade)
    Text_hero_grow_lv:setColor(cc.c3b(tipStringInfo_quality_color_Type[self.ship.ship_type+1][1],tipStringInfo_quality_color_Type[self.ship.ship_type+1][2],tipStringInfo_quality_color_Type[self.ship.ship_type+1][3]))
    --英雄属性
    local Panel_hero_grow_types = ccui.Helper:seekWidgetByName(root,"Panel_hero_grow_types")
    local sign_msg = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.sign_msg)
    Panel_hero_grow_types:setBackGroundImage(string.format("images/ui/quality/types_%d.png", sign_msg))
    --英雄星级
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

function HeroMainGrowUp:onShowStarsAction()
    --  星星动画
    local root = self.roots[1]
    local action = self.actions[1]
    local stars,stars_level = getHeroStars(self.ship.ship_template_id)
    if tonumber(stars) <= 0 then
        return
    end
    local Panel_grow_star = ccui.Helper:seekWidgetByName(root,"Panel_grow_star_"..stars)
    Panel_grow_star:setVisible(true)
    Panel_grow_star:setBackGroundImage("images/ui/state/big_star_"..stars_level..".png")
    action:play("talant_up_star_"..stars, false)   
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        local text_table = self._text_table
        if str == "talant_up_star_"..stars.."_over" then
            state_machine.excute("hero_main_update_draw",0,"") 
            state_machine.excute("add_number_window_open",0,{7,text_table})
            state_machine.excute("hero_main_change_ship",0,"")
        end  
    end)
end

function HeroMainGrowUp:onEnterTransitionFinish()

end

function HeroMainGrowUp:setHeroIcon()
    local action = cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(self.delayDrawHero))
    self:runAction(action) 
end

function HeroMainGrowUp:delayDrawHero()
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

function HeroMainGrowUp:openHeroSkillsUp()
    local root = self.roots[1]
    local Panel_skills_star = ccui.Helper:seekWidgetByName(root,"Panel_skills_star")

    state_machine.excute("hero_main_star_up_window_open",0,{Panel_skills_star,self.ship})
    -- 取消技能在英雄界面中显示
    -- state_machine.excute("hero_main_skills_up_window_open",0,{Panel_skills_star,self.ship})
    -- 添加武学突破信息显示
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
    else
    	app.load("client.red_alert.hero.HeroMainGradeUp")
		state_machine.excute("hero_main_grade_up_window_open",0,{Panel_skills_star,self.ship, 0})
    end
end

function HeroMainGrowUp:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_main_grow_up)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.hero.hero_main_grow_up) 
    table.insert(self.actions, action)
    action:setTimeSpeed(app.getTimeSpeed())
    csbItem:runAction(action)

    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        local text_table = self._text_table
        --判断是第几颗星
        if str == "talant_up_star_1_over" then
            state_machine.excute("add_number_window_open",0,{7,text_table})
        elseif str == "talant_up_star_2_over" then
            state_machine.excute("add_number_window_open",0,{7,text_table})
        elseif str == "talant_up_star_3_over" then
            state_machine.excute("add_number_window_open",0,{7,text_table})
        end  
    end)
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pve_map_back"), nil, 
    -- {
    --     terminal_name = "duplicate_title_back_up_floor", 
    --     terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
    -- }, nil, 0)

    -- 一键分享
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share"), nil, 
    {
        terminal_name = "hero_main_grow_up_share",      
        but_image = "",     
        terminal_state = 0,
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)

	self:onUpdateDraw()
    self:openHeroSkillsUp()	
    self:setHeroIcon()
end

function HeroMainGrowUp:close()
    local root = self.roots[1]
    local Panel_hero_grow_animation = ccui.Helper:seekWidgetByName(root,"Panel_hero_grow_animation")
    Panel_hero_grow_animation:removeAllChildren(true)
end

function HeroMainGrowUp:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.ship = params[2]
	self:onInit()
    return self
end

function HeroMainGrowUp:onExit()
    state_machine.remove("hero_main_grow_up_window_show")  
    state_machine.remove("hero_main_grow_up_window_hide")
    state_machine.remove("hero_main_grow_up_change_ship")
    state_machine.remove("hero_talant_up_star")
    state_machine.remove("hero_main_grow_up_set_visible_property")
    state_machine.remove("hero_main_grow_up_share")
end
