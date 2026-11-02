--------------------------------------------------------------------------------------------------------------
--  招募奖励预览数码兽列表cell
--------------------------------------------------------------------------------------------------------------
ExplorationPokemonPreviewCell = class("ExplorationPokemonPreviewCellClass", Window)
ExplorationPokemonPreviewCell.__size = nil

-- 创建cell
local exploration_pokemon_preview_cell_create_terminal = {
    _name = "exploration_pokemon_preview_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = ExplorationPokemonPreviewCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_pokemon_preview_cell_create_terminal)
state_machine.init()

function ExplorationPokemonPreviewCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = nil
    
    -- 初始化状态机
    local function init_exploration_pokemon_preview_cell_terminal()

    end 
    init_exploration_pokemon_preview_cell_terminal()

end

function ExplorationPokemonPreviewCell:updateHeroAnimation()
    local root = self.roots[1]
    local Panel_digimon_dh = ccui.Helper:seekWidgetByName(root,"Panel_digimon_dh")
    Panel_digimon_dh:removeAllChildren(true)

    local evo_mould_info = zstring.split(dms.string(dms["ship_mould"], self._info.mould_id, ship_mould.fitSkillTwo), ",")
    local evo_index = dms.int(dms["ship_mould"], self._info.mould_id, ship_mould.captain_name)
    local evo_mould_id = evo_mould_info[evo_index]

    local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_digimon_dh, nil, nil, cc.p(0.5, 0))
        local armature_hero = sp.spine_sprite(Panel_digimon_dh, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        armature_hero:setScaleX(-1)
        armature_hero.animationNameList = spineAnimations
        sp.initArmature(armature_hero, true)
    else
        Panel_digimon_dh:removeBackGroundImage()
        Panel_digimon_dh:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", temp_bust_index))
    end
end

-- 刷新
function ExplorationPokemonPreviewCell:updateDraw()
    local root = self.roots[1]
    local Text_digimon_name = ccui.Helper:seekWidgetByName(root,"Text_digimon_name")
    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star")
    local Image_tag = ccui.Helper:seekWidgetByName(root,"Image_tag")

    Text_digimon_name:setString("")
    Panel_star:removeAllChildren(true)
    if tonumber(self._info.tag) == -1 then
        Image_tag:setVisible(false)
    elseif tonumber(self._info.tag) == 1 then
        Image_tag:setVisible(true)
    end

    local name = smHeroWorldFundByMouldId(self._info.mould_id, 1)
    Text_digimon_name:setString(name)

    local initStar = zstring.tonumber(self._info.order)
    neWshowShipStar(Panel_star , initStar)

    self:updateHeroAnimation()
end 

function ExplorationPokemonPreviewCell:onInit()
    local root = cacher.createUIRef("shop/sm_recruit_preview_window_tab_1_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ExplorationPokemonPreviewCell.__size == nil then
        ExplorationPokemonPreviewCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function ExplorationPokemonPreviewCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function ExplorationPokemonPreviewCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_digimon_name = ccui.Helper:seekWidgetByName(root,"Text_digimon_name")
    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star")
    local Panel_digimon_dh = ccui.Helper:seekWidgetByName(root,"Panel_digimon_dh")

    if Text_digimon_name ~= nil then
        Text_digimon_name:setString("")
    end
    if Panel_star ~= nil then
        Panel_star:removeAllChildren(true)
    end
    if Panel_digimon_dh then
        Panel_digimon_dh:removeAllChildren(true)
    end
    --state_machine.remove("exploration_pokemon_preview_cell_create")
end

function ExplorationPokemonPreviewCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ExplorationPokemonPreviewCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:removeAllChildren(true)
    self:clearUIInfo()
    cacher.freeRef("shop/sm_recruit_preview_window_tab_1_list.csb", root)
    root:removeFromParent(false)
    self.roots = {}
end

function ExplorationPokemonPreviewCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._prop_type = params[3]

    self:onInit()
    self:setContentSize(ExplorationPokemonPreviewCell.__size)
    return self
end

function ExplorationPokemonPreviewCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("shop/sm_recruit_preview_window_tab_1_list.csb", self.roots[1])
end