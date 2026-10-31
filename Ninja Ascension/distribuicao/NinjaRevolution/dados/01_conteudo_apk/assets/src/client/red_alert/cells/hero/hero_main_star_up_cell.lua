HeroMainStarUpCell = class("HeroMainStarUpCellClass", Window)
HeroMainStarUpCell.__size = nil

--创建cell
local hero_main_star_up_create_cell_terminal = {
    _name = "hero_main_star_up_create_cell",
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
        local cell = HeroMainStarUpCell:new()
        cell:init(talent_id,talent_state,_ship,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_main_star_up_create_cell_terminal)
state_machine.init()

function HeroMainStarUpCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.talent_id = nil
    self.talent_state = nil  
    self.ship = nil

    local function init_hero_main_star_up_cell_terminal()
		
    end
    init_hero_main_star_up_cell_terminal()
end

function HeroMainStarUpCell:updateDraw()
    local root = self.roots[1]
    local data = dms.element(dms["talent_mould"],self.talent_id)
    local talent_name = dms.atos(data,talent_mould.talent_name)
    local talent_describe = dms.atos(data,talent_mould.talent_describe)
    local base_additional = dms.atos(data,talent_mould.base_additional)
    local talent_pic = dms.atoi(data,talent_mould.talent_pic)
    local talent_star_dec = dms.atos(data,talent_mould.talent_star_dec)
    local talent_star_quality = dms.atos(data,talent_mould.talent_star_quality)
    local talent_star = 0

    local talent_str = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.talent_id)
    local talent_tab = zstring.split(talent_str,"|")
    for i,v in pairs(talent_tab) do
        local talent_id_tab = zstring.split(v,",")
        local talent_id_t = talent_id_tab[3]
        if tonumber(talent_id_t) == tonumber(self.talent_id) then
            talent_star = tonumber(talent_id_tab[2])
            break
        end
    end

    local Image_talent_icon_bg = ccui.Helper:seekWidgetByName(root,"Image_talent_icon_bg")
    local Sprite_talent_icon = Image_talent_icon_bg:getChildByName("Sprite_talent_icon")

    Sprite_talent_icon:setTexture("images/ui/talent_icon/talent_icon_".. talent_pic .. ".png")
    display:ungray(Sprite_talent_icon)
    if tonumber(self.talent_state) == 1 then
        display:ungray(Sprite_talent_icon)
    else
        display:gray(Sprite_talent_icon)
    end
    
    local Text_meridian_info = ccui.Helper:seekWidgetByName(root, "Text_meridian_info")
    Text_meridian_info:setString(talent_describe)

    local Text_meridian_name = ccui.Helper:seekWidgetByName(root, "Text_meridian_name")
    Text_meridian_name:setString(talent_name)

    Text_meridian_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[talent_star_quality+1][1],tipStringInfo_quality_color_Type[talent_star_quality+1][2],tipStringInfo_quality_color_Type[talent_star_quality+1][3]))

    local Text_condition = ccui.Helper:seekWidgetByName(root, "Text_condition")
    Text_condition:setString(talent_star_dec..red_alert_all_str[198])
    Text_condition:setColor(cc.c3b(tipStringInfo_quality_color_Type[talent_star_quality+1][1],tipStringInfo_quality_color_Type[talent_star_quality+1][2],tipStringInfo_quality_color_Type[talent_star_quality+1][3]))

    local stars, stars_level = self:getTalentStars(talent_star)
    for i=1,3 do
        local Panel_grow_star = ccui.Helper:seekWidgetByName(root,"Panel_star_"..i)
        Panel_grow_star:removeBackGroundImage()
        if i > stars then
            Panel_grow_star:setVisible(false)
        else
            Panel_grow_star:setVisible(true)
            Panel_grow_star:setBackGroundImage("images/ui/state/big_star_"..stars_level..".png")
        end
    end
end

function HeroMainStarUpCell:getTalentStars(talent_star) -- 返回星数 和当前星级品质  绿 蓝 紫
    local stars = 0
    local stars_level = 0
    -- 0 1 2 3 4 5 6 7 8 9 10 11 12 
    if talent_star == 0 then
        return stars , 1
    end
    if talent_star % 3 == 0 then
        stars_level = math.floor(talent_star / 3)
        stars = 3
        return stars , stars_level
    else
        stars_level = math.floor(talent_star / 3) + 1
        stars = talent_star % 3
        return stars , stars_level
    end
end

function HeroMainStarUpCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.hero.hero_main_star_up_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if HeroMainStarUpCell.__size == nil then 
        HeroMainStarUpCell.__size = root:getContentSize()
    end
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
    
    -- fwin:addTouchEventListener(Panel_skills_talent_icon_1, buttonTouchEvent, {
    --     terminal_name = "",
    -- }, nil, 0)      

    self:updateDraw()
end

function HeroMainStarUpCell:onEnterTransitionFinish()

end

function HeroMainStarUpCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function HeroMainStarUpCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.hero.hero_main_star_up_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function HeroMainStarUpCell:init(talent_id,talent_state,_ship,index)
    self.talent_id = talent_id
    self.talent_state = talent_state
    self.ship = _ship
    if index ~= nil and index < 10 then
	   self:onInit()
    end
    self:setContentSize(HeroMainStarUpCell.__size)
end

function HeroMainStarUpCell:onExit()
    cacher.freeRef(config_csb.cells.hero.hero_main_star_up_cell, self.roots[1])
end