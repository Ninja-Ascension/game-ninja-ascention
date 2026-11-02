--[[ ----------------------------------------------------------------------------
-- 阵容推荐头像icon
--]] ----------------------------------------------------------------------------
FormationTemplateIconCell = class("FormationTemplateIconCellClass", Window)
FormationTemplateIconCell.__size = nil

-- 创建Cell实例
local formation_template_icon_cell_create_terminal = {
    _name = "formation_template_icon_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if FormationTemplateIconCell then
            local cell = FormationTemplateIconCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_template_icon_cell_create_terminal)
state_machine.init()

-- 构造器
function FormationTemplateIconCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._type = 1 -- 1:主界面 2:详情界面
    self._hero_info = nil -- 武将信息
    -- load lua files.

    -- Initialize formation template icon cell page state machine.
    local function init_formation_template_icon_cell_terminal()
        -- 卡牌详情展示
        local formation_template_icon_cell_describe_terminal = {
            _name = "formation_template_icon_cell_describe",
            _init = function(terminal)
                app.load("client.formation.HeroInformation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if not params then
                    return true
                end
                local heroId = params._datas.hero_id
                local index = params._datas.m_index
                if heroId and index then
                    state_machine.excute("sm_role_information_open", 0, {heroId, 1, index})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(formation_template_icon_cell_describe_terminal)
        state_machine.init()
    end
    init_formation_template_icon_cell_terminal()
end

-- 头像
function FormationTemplateIconCell:addHeroIconCell(heroId, shipInfo)
    local hero_head = ShipHeadNewCell:createCell()
    if shipInfo ~= nil then 
        hero_head:init(shipInfo,hero_head.enum_type._SHOW_SHIP_INFORMATION,nil,{showNum = shipInfo.ship_grade,isFormationTemplat = true})
    else
        hero_head:init(heroId,hero_head.enum_type._SHOW_HERO_FROM_WARCRAFT, false,{isFormationTemplat = true})
    end
    return hero_head
end

function FormationTemplateIconCell:onUpdateDraw()
    local root = self.roots[1]
    local heroId = self._hero_info.heroId
    local isCore = self._hero_info.isCore

    -- 模版找拥有武将
    local shipInfo = fundShipWidthTemplateId(heroId)

    -- 角色
    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
    Panel_role:removeAllChildren(true)
    local cell = self:addHeroIconCell(heroId, shipInfo)
    Panel_role:addChild(cell)

    -- 核心标志
    local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
    if isCore then
        Panel_1:setVisible(true)
    else
        Panel_1:setVisible(false)
    end

    -- 未拥有标识
    local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
    -- 置灰
    if shipInfo == nil then
        Panel_2:setVisible(true)
    else
        Panel_2:setVisible(false)
    end
end

function FormationTemplateIconCell:drawBtn()
    local root = self.roots[1]
    -- 角色选中按钮
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_icon"),
        nil,
        {
            terminal_name = "formation_template_icon_cell_describe",
            terminal_state = 0,
            hero_id = self._hero_info.heroId,
            m_index = self._hero_info.index,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

-- 对象初始化
function FormationTemplateIconCell:init(params)
    self._type = params.mType
    self._hero_info = params.mInfo
    self:onInit(params)
    self:setContentSize(FormationTemplateIconCell.__size)
    return self
end

function FormationTemplateIconCell:onInit(params)
    local root = cacher.createUIRef("packs/HeroStorage/generals_team_icon.csb", "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if FormationTemplateIconCell.__size == nil then
        FormationTemplateIconCell.__size = root:getContentSize()
    end

    if self._type == 2 then
        self:drawBtn()
    end
    self:onUpdateDraw()
end

function FormationTemplateIconCell:onEnterTransitionFinish()
end

function FormationTemplateIconCell:onExit()
    local root = self.roots[1]
    cacher.freeRef("packs/HeroStorage/generals_team_icon.csb", root)
end

function FormationTemplateIconCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function FormationTemplateIconCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("packs/HeroStorage/generals_team_icon.csb", root)

    self.roots = {}
end
