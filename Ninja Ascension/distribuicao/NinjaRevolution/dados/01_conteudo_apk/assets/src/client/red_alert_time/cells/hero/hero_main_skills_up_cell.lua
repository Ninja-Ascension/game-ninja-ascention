--------------------------------------------------------------------------------------------------------------
--  说明：英雄天赋列表、技能
--------------------------------------------------------------------------------------------------------------
HeroMainSkillsUpCell = class("HeroMainSkillsUpCellClass", Window)
HeroMainSkillsUpCell.__size = nil

--创建cell
local hero_main_skills_up_create_cell_terminal = {
    _name = "hero_main_skills_up_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local talent_id = params[1]
        local talent_state = params[2]
        local _ship = params[3]        
        local index = params[4]
        local cell = HeroMainSkillsUpCell:new()
        cell:init(talent_id,talent_state,_ship,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_main_skills_up_create_cell_terminal)
state_machine.init()

function HeroMainSkillsUpCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.talent_id = nil
    self.talent_state = nil  
    self.ship = nil
	 -- Initialize hero_main_skills_up state machine.
    local function init_hero_main_skills_up_cell_terminal()
		

    end
    
    -- call func hero_main_skills_up create state machine.
    init_hero_main_skills_up_cell_terminal()

end

function HeroMainSkillsUpCell:updateDraw()
    local root = self.roots[1]
    local data = dms.element(dms["talent_mould"],self.talent_id)
    local talent_name = dms.atos(data,talent_mould.talent_name)
    local talent_describe = dms.atos(data,talent_mould.talent_describe)
    local base_additional = dms.atos(data,talent_mould.base_additional)
    local talent_pic = dms.atoi(data,talent_mould.talent_pic)
    local talent_star_dec = dms.atos(data,talent_mould.talent_star_dec)
    local talent_star_quality = dms.atos(data,talent_mould.talent_star_quality)

    local Panel_skil = ccui.Helper:seekWidgetByName(root,"Panel_skil")
    local Panel_talent = ccui.Helper:seekWidgetByName(root,"Panel_talent")
    Panel_skil:setVisible(false)
    Panel_talent:setVisible(false)

    local Panel_skills_talent_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_skills_talent_icon_1")
    local Sprite_skills_talent_icon_1 = Panel_skills_talent_icon_1:getChildByName("Sprite_skills_talent_icon_1")

    Sprite_skills_talent_icon_1:setTexture("images/ui/talent_icon/talent_icon_".. talent_pic .. ".png")
    display:ungray(Sprite_skills_talent_icon_1)
    if tonumber(self.talent_state) == 1 then
        display:ungray(Sprite_skills_talent_icon_1)
    else
        display:gray(Sprite_skills_talent_icon_1)
    end
    
    if base_additional == "-1" then
        Panel_skil:setVisible(true)

        local Text_skills_talent_attributes_1 = ccui.Helper:seekWidgetByName(root,"Text_skills_talent_attributes_1")
        Text_skills_talent_attributes_1:setString(talent_star_dec)

        local Text_skills_talent_name_1 = ccui.Helper:seekWidgetByName(root,"Text_skills_talent_name_1")
        Text_skills_talent_name_1:setString(talent_name)

        Text_skills_talent_name_1:setColor(cc.c3b(tipStringInfo_quality_color_Type[self.ship.ship_type+1][1],tipStringInfo_quality_color_Type[self.ship.ship_type+1][2],tipStringInfo_quality_color_Type[self.ship.ship_type+1][3]))
    else
        Panel_talent:setVisible(true)

        local Text_skills_talent_attributes_2 = ccui.Helper:seekWidgetByName(root,"Text_skills_talent_attributes_2")
        Text_skills_talent_attributes_2:setString(talent_star_dec)
        Text_skills_talent_attributes_2:setColor(cc.c3b(tipStringInfo_quality_color_Type[talent_star_quality+1][1],tipStringInfo_quality_color_Type[talent_star_quality+1][2],tipStringInfo_quality_color_Type[talent_star_quality+1][3]))

        local Text_skills_talent_name_2 = ccui.Helper:seekWidgetByName(root,"Text_skills_talent_name_2")
        Text_skills_talent_name_2:setString(talent_name)

        -- Text_skills_talent_name_1:setColor(cc.c3b(tipStringInfo_quality_color_Type[talent_star_quality+1][1],tipStringInfo_quality_color_Type[talent_star_quality+1][2],tipStringInfo_quality_color_Type[talent_star_quality+1][3]))
    end
end

function HeroMainSkillsUpCell:onInit() 
    local root = cacher.createUIRef(config_csb.cells.hero.hero_main_skills_up_cell,"root")
    table.insert(self.roots, root)
    self:addChild(root)
    local Panel_skills_talent_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_skills_talent_icon_1")
    if HeroMainSkillsUpCell.__size == nil then 
        HeroMainSkillsUpCell.__size = Panel_skills_talent_icon_1:getContentSize()
    end
	Panel_skills_talent_icon_1:setTouchEnabled(true)
    local function buttonTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        if ccui.TouchEventType.began == evenType then  
            state_machine.excute("hero_star_talent_infor_window_close", 0, 0)
            local function openOtherWindow()
                state_machine.excute("hero_star_talent_infor_window_open",0,{self.talent_id,cc.p(__spoint.x,__spoint.y),self.ship.ship_type})
            end
            local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
            self:stopAllActions()
            self:runAction(action)                    
        elseif ccui.TouchEventType.moved == evenType then

        elseif ccui.TouchEventType.canceled == evenType then
            self:stopAllActions()
            state_machine.excute("hero_star_talent_infor_window_close", 0, 0)
            
        elseif ccui.TouchEventType.ended == evenType then
            self:stopAllActions()
            state_machine.excute("hero_star_talent_infor_window_close", 0, 0)
        end
    end
    
    fwin:addTouchEventListener(Panel_skills_talent_icon_1, buttonTouchEvent, {
        terminal_name = "",
    }, nil, 0)      

    self:updateDraw()
end

function HeroMainSkillsUpCell:onEnterTransitionFinish()

end

function HeroMainSkillsUpCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function HeroMainSkillsUpCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.hero.hero_main_skills_up_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function HeroMainSkillsUpCell:init(talent_id,talent_state,_ship,index)
    self.talent_id = talent_id
    self.talent_state = talent_state
    self.ship = _ship
    if index ~= nil and index < 10 then
	   self:onInit()
    end
    self:setContentSize(HeroMainSkillsUpCell.__size)
end

function HeroMainSkillsUpCell:onExit()
    cacher.freeRef(config_csb.cells.hero.hero_main_skills_up_cell, self.roots[1])
end