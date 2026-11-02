--[[ ----------------------------------------------------------------------------
-- 阵容角色展示
--]] ----------------------------------------------------------------------------
FormationShowCell = class("FormationShowCellClass", Window)
FormationShowCell.__size = nil

-- 创建Cell实例
local formation_show_cell_create_terminal = {
    _name = "formation_show_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if FormationShowCell then
            local cell = FormationShowCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_show_cell_create_terminal)
state_machine.init()

-- 构造器
function FormationShowCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._ship_data = nil
    -- load lua files.

    -- Initialize formation show cell page state machine.
    local function init_formation_show_cell_terminal()
    end
    -- call func init formation show cell state machine.
    init_formation_show_cell_terminal()
end

function FormationShowCell:onUpdateDraw()
    local root = self.roots[1]
    local shipId = self._ship_data.shipId
    local shipInfo = self._ship_data.shipInfo
    local skinId = zstring.tonumber(self._ship_data.skinId)
    local evolutionStatus = self._ship_data.evolutionStatus

    -- 角色动画
    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
    local evo_mould_id = 0
    local evo_image = dms.string(dms["ship_mould"], shipId, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    if skinId ~= 0 then
        evo_mould_id = dms.int(dms["ship_skin_mould"], skinId, ship_skin_mould.ship_evo_id)
    elseif evolutionStatus ~= nil and evolutionStatus[1] ~= nil then
        evo_mould_id = evo_info[tonumber(evolutionStatus[1])]
    elseif shipInfo == nil then
        local captain_name = dms.int(dms["ship_mould"], shipId, ship_mould.captain_name)
        evo_mould_id = evo_info[captain_name]
    else
        local ship_evo = zstring.split(shipInfo.evolution_status, "|")
        evo_mould_id = smGetSkinEvoIdChange(shipInfo)
    end
    local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    local armature_hero = sp.spine_sprite(Panel_role, picIndex, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
    armature_hero:setScaleX(-1)
    armature_hero.animationNameList = spineAnimations
    sp.initArmature(armature_hero, true)

    -- 光圈
    local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
    -- 角色属性图标
    local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    local camp_preference = dms.int(dms["ship_mould"], tonumber(shipId), ship_mould.camp_preference)
    local animation_name = ""
    if camp_preference == 1 then --攻击
        animation_name = "type_1"
    elseif camp_preference == 2 then --防御
        animation_name = "type_2"
    elseif camp_preference == 3 then --技能
        animation_name = "type_3"
    end
    local jsonFile = "sprite/spirte_type_di.json"
    local atlasFile = "sprite/spirte_type_di.atlas"
    local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, animation_name, true, nil)
    animation2:setPosition(cc.p(Panel_effect:getContentSize().width / 2, 0))
    animation2:setTag(999)
    Panel_effect:addChild(animation2, -1)
    -- 属性图标
    showShipTypeImage(Panel_icon, camp_preference)
end

-- 对象初始化
function FormationShowCell:init(params)
    self._ship_data = params.mShipData
    self:onInit(params)
    self:setContentSize(FormationShowCell.__size)
    return self
end

function FormationShowCell:onInit(params)
    local root = cacher.createUIRef("packs/HeroStorage/generals_team_formation_role.csb", "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if FormationShowCell.__size == nil then
        FormationShowCell.__size = root:getContentSize()
    end
    self:clearUIInfo()
    self:onUpdateDraw()
end

function FormationShowCell:onEnterTransitionFinish()
end

function FormationShowCell:onExit()
    self:clearUIInfo()
    local root = self.roots[1]
    cacher.freeRef("packs/HeroStorage/generals_team_formation_role.csb", root)
end

function FormationShowCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
    if Panel_role ~= nil then
        Panel_role:removeAllChildren(true)
    end
    local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
    if Panel_effect ~= nil then
        Panel_effect:removeAllChildren(true)
    end
    local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    if Panel_icon ~= nil then
        Panel_icon:removeAllChildren(true)
    end
end

function FormationShowCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function FormationShowCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("packs/HeroStorage/generals_team_formation_role.csb", root)

    self.roots = {}
end
