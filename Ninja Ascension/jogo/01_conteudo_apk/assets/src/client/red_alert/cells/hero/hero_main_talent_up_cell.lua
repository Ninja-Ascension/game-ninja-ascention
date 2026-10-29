HeroMainTalentUpCell = class("HeroMainTalentUpCellClass", Window)
HeroMainTalentUpCell.__size = nil

local hero_main_talent_up_cell_create_terminal = {
    _name = "hero_main_talent_up_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = HeroMainTalentUpCell:new():init(params)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_main_talent_up_cell_create_terminal)
state_machine.init()

function HeroMainTalentUpCell:ctor()
	self.super:ctor()
	self.roots = {}
	
    -- 武将
    self.ship = nil
    -- 天赋
    self.talentId = 0
    -- 资源消耗ID
    self.resourceNeedId = 0
    -- 天赋是否已经激活
    self.isAlive = false

    local function init_hero_skill_grow_up_list_cell_terminal()
        
    end

    init_hero_skill_grow_up_list_cell_terminal()
end

function HeroMainTalentUpCell:updateDraw()
    local root = self.roots[1]
    local data = dms.element(dms["talent_mould"],self.talentId)
    -- 天赋名称
    local Text_talent_name = ccui.Helper:seekWidgetByName(root, "Text_talent_name")
    local talent_name = dms.atos(data,talent_mould.talent_name)
    local talent_star_quality = dms.atos(data,talent_mould.talent_star_quality)
    Text_talent_name:setString(talent_name)
    Text_talent_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[talent_star_quality+1][1],tipStringInfo_quality_color_Type[talent_star_quality+1][2],tipStringInfo_quality_color_Type[talent_star_quality+1][3]))
    -- 天赋效果描述
    local Text_talent_info = ccui.Helper:seekWidgetByName(root, "Text_talent_info")
    local talent_describe = dms.atos(data,talent_mould.talent_describe)
    Text_talent_info:setString(talent_describe)
    -- 天赋开启条件
    local Text_condition = ccui.Helper:seekWidgetByName(root, "Text_condition")
    local talent_star_dec = dms.atos(data,talent_mould.talent_star_dec)
    Text_condition:setString(talent_star_dec)
    -- 技能icon(激活后点亮图标)
    local Image_talent_icon_bg = ccui.Helper:seekWidgetByName(root,"Image_talent_icon_bg")
    local Sprite_talent_icon = Image_talent_icon_bg:getChildByName("Sprite_talent_icon")
    local talent_pic = dms.atoi(data,talent_mould.talent_pic)
    Sprite_talent_icon:setTexture("images/ui/talent_icon/grade_up_icon_".. talent_pic .. ".png")
    display:ungray(Sprite_talent_icon)
    if self.isAlive == true then
        display:ungray(Sprite_talent_icon)
    else
        display:gray(Sprite_talent_icon)
    end
end

function HeroMainTalentUpCell:onInit() 
    local root = cacher.createUIRef(config_csb.cells.hero.hero_main_talent_up_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if HeroMainTalentUpCell.__size == nil then 
        HeroMainTalentUpCell.__size = root:getContentSize()
    end
    self:setContentSize(HeroMainTalentUpCell.__size)

    self:updateDraw()
end

function HeroMainTalentUpCell:onEnterTransitionFinish()

end

function HeroMainTalentUpCell:init(params)
    self.ship = params[1]
    self.talentId = params[2]
    self.resourceNeedId = params[3]
    self.isAlive = params[4]
    self:onInit()
    return self
end

function HeroMainTalentUpCell:onExit()
    
end