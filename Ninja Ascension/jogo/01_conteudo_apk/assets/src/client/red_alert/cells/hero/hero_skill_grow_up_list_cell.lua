--------------------------------------------------------------------------------------------------------------
--  说明：英雄武学突破列表项
--------------------------------------------------------------------------------------------------------------
HeroSkillGrowUpListCell = class("HeroSkillGrowUpListCellClass", Window)
HeroSkillGrowUpListCell.__size = nil

--创建cell
local hero_skill_grow_up_list_cell_create_terminal = {
    _name = "hero_skill_grow_up_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = HeroSkillGrowUpListCell:new():init(params)
        -- cell:registerOnNodeEvent(cell)
        -- cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

-- 更新绘图
local hero_skill_grow_up_list_cell_update_draw_terminal = {
    _name = "hero_skill_grow_up_list_cell_update_draw",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = params[1]
        local isAlive = params[2]
        cell.isAlive = isAlive
        cell:onUpdateDraw()
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_skill_grow_up_list_cell_create_terminal)
state_machine.add(hero_skill_grow_up_list_cell_update_draw_terminal)
state_machine.init()

function HeroSkillGrowUpListCell:ctor()
	self.super:ctor()
	self.roots = {}
	
    -- var
    -- 武将
    self.ship = nil
    -- 宽
    self.width = 100
    -- 天赋
    self.talentId = 0
    -- 资源消耗ID
    self.resourceNeedId = 0
    -- 天赋是否已经激活
    self.isAlive = false

	 -- Initialize hero_skill_grow_up_list_cell state machine.
    local function init_hero_skill_grow_up_list_cell_terminal()
        -- 选中技能
        local hero_skill_grow_up_list_cell_create_choice_terminal = {
            _name = "hero_skill_grow_up_list_cell_create_choice",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(hero_skill_grow_up_list_cell_create_choice_terminal)
        state_machine.init()
    end
    
    -- call func hero_skill_grow_up_list_cell create state machine.
    init_hero_skill_grow_up_list_cell_terminal()

end

function HeroSkillGrowUpListCell:onUpdateDraw() 
    self:removeAllChildren(true)
    local fontSize = 18
    local nameWidth = fontSize * 6
    local richText = ccui.RichText:create()
    richText:ignoreContentAdaptWithSize(false)
    richText:setContentSize(cc.size(self.width - fontSize, 0))
    richText:setAnchorPoint(0, 0)

    local richTextInfo = ccui.RichText:create()
    richTextInfo:ignoreContentAdaptWithSize(false)
    richTextInfo:setContentSize(cc.size(self.width - fontSize - nameWidth, 0))
    richTextInfo:setAnchorPoint(0, 0)

    self:setAnchorPoint(0, 0)

    local shipGrowParam = dms.element(dms["ship_grow_param"], self.resourceNeedId)
    local talentMould = dms.element(dms["talent_mould"], self.talentId)
    local talent_name = dms.atos(talentMould,talent_mould.talent_name)
    local talent_describe = dms.atos(talentMould,talent_mould.talent_describe)

    local colorIndex = 3
    local colorInfoIndex = 2
    if self.isAlive then
        colorIndex = 1
        colorInfoIndex = 1
    end

    local name = ccui.RichElementText:create(1, hero_skill_grade_color_info[colorIndex], 255, string.format(tipStringInfo_hero_info[5], talent_name), config_res.font.font_name, fontSize)
    local info = ccui.RichElementText:create(1, hero_skill_grade_color_info[colorInfoIndex], 255, talent_describe, config_res.font.font_name, fontSize)

    richText:pushBackElement(name)
    richTextInfo:pushBackElement(info)

    if nil ~= richText.formatTextExt then
        richText:formatTextExt()
    end
    if nil ~= richTextInfo.formatTextExt then
        richTextInfo:formatTextExt()
    end
    local size = richText:getContentSize()
    local infoSize = richTextInfo:getContentSize()
    self:setContentSize(infoSize)
    self:addChild(richText) 
    self:addChild(richTextInfo) 
    self:setAnchorPoint(cc.p(0, 0))
    richText:setPosition(cc.p(nameWidth - size.width, infoSize.height))
    -- richText:setPosition(cc.p(0, infoSize.height))
    richTextInfo:setPosition(cc.p(nameWidth, infoSize.height))
end

--初始化界面
function HeroSkillGrowUpListCell:onInit() 
    self:onUpdateDraw()
end

function HeroSkillGrowUpListCell:onEnterTransitionFinish()

end

--初始化
function HeroSkillGrowUpListCell:init(params)
    self.ship = params[1]
    self.width = params[2]
    self.talentId = params[3]
    self.resourceNeedId = params[4]
    self.isAlive = params[5]
    self:onInit()
    return self
end

--退出
function HeroSkillGrowUpListCell:onExit()
    
end