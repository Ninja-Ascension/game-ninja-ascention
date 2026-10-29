-----------------------------
--英雄包裹 小详情界面
-----------------------------
HeroPacksInformation = class("HeroPacksInformationClass", Window)

local hero_packs_information_window_open_terminal = {
    _name = "hero_packs_information_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroPacksInformationClass")
        if nil == _Window then
            local ship = params[1]
            local show_button = params[2]
            local prop_from_type = params[3]
            fwin:open(HeroPacksInformation:new():init(ship,show_button,prop_from_type),fwin._ui)
        end  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
local hero_packs_information_window_close_terminal = {
    _name = "hero_packs_information_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroPacksInformationClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_packs_information_window_open_terminal)
state_machine.add(hero_packs_information_window_close_terminal)
state_machine.init()

function HeroPacksInformation:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship = nil

    --按钮显示
    self._show_button = nil
    self._prop_from_type = nil
    -- Initialize hero_packs_information state machine.
    local function init_hero_packs_information_terminal()
	
		--培养 -- 升星
		local hero_packs_information_goto_stars_terminal = {
            _name = "hero_packs_information_goto_stars",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local ship = instance.ship
                state_machine.excute("hero_packs_information_window_close",0,"")
                state_machine.excute("hero_packs_window_close",0,"")

                state_machine.excute("hero_main_change_ship",0,ship)
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
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		--详情 -- 天赋
		local hero_packs_information_more_information_terminal = {
            _name = "hero_packs_information_more_information",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local ship = instance.ship
                state_machine.excute("hero_packs_information_window_close",0,"")
                state_machine.excute("hero_packs_window_close",0,"")

                state_machine.excute("hero_main_change_ship",0,ship)
                state_machine.excute("hero_main_maneger",0,{_datas = {
                    terminal_name = "hero_main_maneger",     
                    next_terminal_name = "hero_main_change_to_skills_page", 
                    current_button_name = "Button_talent",   
                    but_image = "",     
                    terminal_state = 0,
                    fun_open_id = 92,
                    touch_scale = true,
                    touch_scale_xy = 0.95, 
                }})                  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
        --前往 -- 羁绊
        local hero_packs_information_relaship_terminal = {
            _name = "hero_packs_information_relaship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("hero_packs_information_window_close",0,"")
                state_machine.excute("hero_packs_window_close",0,"")

                -- 缺少跳转
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

		state_machine.add(hero_packs_information_goto_stars_terminal)	
		state_machine.add(hero_packs_information_more_information_terminal)
        state_machine.add(hero_packs_information_relaship_terminal)
        state_machine.init()
    end
    
    -- call func init packs_scrollview_jewelry state machine.
    init_hero_packs_information_terminal()
end

function HeroPacksInformation:onUpdateDraw()
    local root = self.roots[1]
    -- debug.print_r(self.ship)
    local picIndex = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.head_icon)
    local ability = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ability)
    local ship_type = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type)
    local Panel_hero_packs_infor_icon = ccui.Helper:seekWidgetByName(root,"Panel_hero_packs_infor_icon")
    Panel_hero_packs_infor_icon:removeBackGroundImage()
    Panel_hero_packs_infor_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))

    local Text_hero_packs_infor_name = ccui.Helper:seekWidgetByName(root,"Text_hero_packs_infor_name")
    local skillGrowUpLevel = ""
    if nil ~= self.ship.skill_grow_up_level then
        skillGrowUpLevel = "+" .. self.ship.skill_grow_up_level
    end
    Text_hero_packs_infor_name:setString(self.ship.captain_name .. skillGrowUpLevel)
    Text_hero_packs_infor_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type+1][1],tipStringInfo_quality_color_Type[ship_type+1][2],tipStringInfo_quality_color_Type[ship_type+1][3]))
    local Text_hero_packs_infor_fight = ccui.Helper:seekWidgetByName(root,"Text_hero_packs_infor_fight")
    Text_hero_packs_infor_fight:setString(self.ship.hero_fight)

    local Text_hero_packs_infor_01 = ccui.Helper:seekWidgetByName(root,"Text_hero_packs_infor_01")
    local Text_hero_packs_infor_02 = ccui.Helper:seekWidgetByName(root,"Text_hero_packs_infor_02")
    local Text_hero_packs_infor_03 = ccui.Helper:seekWidgetByName(root,"Text_hero_packs_infor_03")
    local Text_hero_packs_infor_04 = ccui.Helper:seekWidgetByName(root,"Text_hero_packs_infor_04")
    local capacity = dms.int(dms["ship_mould"],self.ship.ship_template_id,ship_mould.capacity)
    Text_hero_packs_infor_01:setString(red_alert_hero_type[capacity])
    Text_hero_packs_infor_02:setString(tipStringInfo_hero_ability[ability])
    Text_hero_packs_infor_03:setString(math.ceil(self.ship.ship_health))
    Text_hero_packs_infor_04:setString(math.ceil(self.ship.ship_courage))

    local Button_hero_packs_infor_go = ccui.Helper:seekWidgetByName(root,"Button_hero_packs_infor_go")
    local Panel_hero_packs_infor_cultivate = ccui.Helper:seekWidgetByName(root,"Panel_hero_packs_infor_cultivate")
    Button_hero_packs_infor_go:setVisible(false)
    Panel_hero_packs_infor_cultivate:setVisible(false)
    if zstring.tonumber(self.ship.little_partner_formation_index) > 0 then
        Button_hero_packs_infor_go:setVisible(true)
    else
        Panel_hero_packs_infor_cultivate:setVisible(true)
    end    
    if self._prop_from_type == 3 or self._prop_from_type == 5 then
        Panel_hero_packs_infor_cultivate:setVisible(self._show_button)
    end
end

function HeroPacksInformation:onEnterTransitionFinish()

end

function HeroPacksInformation:onInit( )
    local csbItem = csb.createNode(config_csb.packs.herostorage.hero_packs_information)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_hero_packs_infor_1"), nil, 
    {
        terminal_name = "hero_packs_information_window_close", 
        terminal_state = 0, 
    }, nil, 0)
    -- 前往
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_packs_infor_go"), nil, 
    {
        terminal_name = "hero_packs_information_relaship", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    -- 培养
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_packs_infor_cultivate"), nil, 
    {
        terminal_name = "hero_packs_information_goto_stars", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    -- 详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_packs_infor_detail"), nil, 
    {
        terminal_name = "hero_packs_information_more_information", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

	self:onUpdateDraw()	
end

function HeroPacksInformation:init(ship,show_button,prop_from_type)
    self.ship = ship
    self._show_button = show_button
    self._prop_from_type = prop_from_type
	self:onInit()
    return self
end

function HeroPacksInformation:onExit()
    state_machine.remove("hero_packs_information_goto_stars")    
    state_machine.remove("hero_packs_information_more_information")
    state_machine.remove("hero_packs_information_relaship")   
end
