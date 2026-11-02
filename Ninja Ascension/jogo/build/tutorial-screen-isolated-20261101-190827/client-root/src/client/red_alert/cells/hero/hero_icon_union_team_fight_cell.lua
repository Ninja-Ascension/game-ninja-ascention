--------------------------------------------------------------------------------------------------------------
--  说明：英雄头像
--------------------------------------------------------------------------------------------------------------
HeroIconUnionTeamFightCell = class("HeroIconUnionTeamFightCellClass", Window)
HeroIconUnionTeamFightCell.__size = nil

--创建cell
local hero_icon_union_team_fight_create_cell_terminal = {
    _name = "hero_icon_union_team_fight_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local ship = params[1]
        local cell = HeroIconUnionTeamFightCell:new()
        cell:init(ship)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_icon_union_team_fight_create_cell_terminal)
state_machine.init()

function HeroIconUnionTeamFightCell:ctor()
	self.super:ctor()
	self.roots = {}

	 -- Initialize hero_icon_cell state machine.
    local function init_hero_icon_union_team_fight_cell_terminal()

    end
    
    -- call func hero_icon_union_team_fight_cell create state machine.
    init_hero_icon_union_team_fight_cell_terminal()

end

--刷新界面
function HeroIconUnionTeamFightCell:updateDraw()
    local root = self.roots[1]

    local picIndex = dms.int(dms["ship_mould"], self.ship, ship_mould.head_icon)       --头像图标
    local quality = dms.int(dms["ship_mould"], self.ship, ship_mould.ship_type)        --角色颜色品质
    local name = dms.string(dms["ship_mould"], self.ship, ship_mould.captain_name)     --主角名称

    local Panel_head_icon = ccui.Helper:seekWidgetByName(root, "Panel_head_icon")               --头像icon
    local Panel_quality_box = ccui.Helper:seekWidgetByName(root, "Panel_quality_box")           --头像背景
    local Text_role_name = ccui.Helper:seekWidgetByName(root,"Text_role_name")                  --角色名字
    Text_role_name:setVisible(false)
    local Image_hook = ccui.Helper:seekWidgetByName(root,"Image_hook")                          --选中icon
    Image_hook:setVisible(false)
    local Image_name_bg = ccui.Helper:seekWidgetByName(root,"Image_name_bg")                    --名字背景
    Image_name_bg:setVisible(false)
    local Panel_head_box = ccui.Helper:seekWidgetByName(root,"Panel_head_box")                  --头像层
    local Image_push = ccui.Helper:seekWidgetByName(root,"Image_push")
    Image_push:setVisible(false)
    local Panel_types = ccui.Helper:seekWidgetByName(root,"Panel_types")
    Panel_types:setVisible(false)
    Panel_head_box:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3])) 
    Panel_head_icon:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3])) 
    
    Panel_head_icon:removeBackGroundImage()
    Panel_quality_box:removeBackGroundImage()
    Panel_head_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
    Panel_quality_box:setBackGroundImage(string.format("images/ui/quality/hero_icon_quality_%d.png", quality))

    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star")      --星级
    Panel_star:removeAllChildren(true)
    local stars,stars_level = getHeroStars(self.ship)
    draw.addHeroStar(Panel_star,stars,stars_level)
end

--设置显示
function HeroIconUnionTeamFightCell:setSeclected()
    local root = self.roots[1]    
    local Image_head_light = ccui.Helper:seekWidgetByName(root,"Image_head_light")
    if Image_head_light == nil then
        return
    end
    Image_head_light:setVisible(self.isSelecet)
end

--初始化界面
function HeroIconUnionTeamFightCell:onInit() 
    local root = cacher.createUIRef(config_csb.cells.hero.hero_icon_cell,"root")
    table.insert(self.roots, root)
    self:addChild(root)
    local Panel_head_box = ccui.Helper:seekWidgetByName(root, "Panel_head_box")
    Panel_head_box:setSwallowTouches(false)
    
    if HeroIconUnionTeamFightCell.__size == nil then
        local __size = Panel_head_box:getContentSize()
        HeroIconUnionTeamFightCell.__size = __size
    end

    fwin:addTouchEventListener(Panel_head_box, nil, 
    {
        terminal_name = "hero_icon_cell_click_head", 
        terminal_state = 0, 
        cell = self, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
    }, nil, 3)

	self:updateDraw()
end

function HeroIconUnionTeamFightCell:onEnterTransitionFinish()

end

--初始化
function HeroIconUnionTeamFightCell:init(ship)
    self.ship = ship
    self:onInit()
    self:setContentSize(HeroIconUnionTeamFightCell.__size)
end

--退出
function HeroIconUnionTeamFightCell:onExit()
    cacher.freeRef(config_csb.cells.hero.hero_icon_cell, self.roots[1])
end