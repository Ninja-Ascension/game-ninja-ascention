--[[ ----------------------------------------------------------------------------
-- 阵容推荐详情
--]] ----------------------------------------------------------------------------
FormationTemplateDetail = class("FormationTemplateDetailClass", Window)

-- 打开窗口
local formation_template_detail_window_open_terminal = {
    _name = "formation_template_detail_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("FormationTemplateDetailClass") then
            fwin:open(FormationTemplateDetail:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local formation_template_detail_window_close_terminal = {
    _name = "formation_template_detail_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FormationTemplateDetailClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_template_detail_window_open_terminal)
state_machine.add(formation_template_detail_window_close_terminal)
state_machine.init()

-- 构造器
function FormationTemplateDetail:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._group_id = nil
    self._card_list = {}
    -- load lua files.
    app.load("client.formation.FormationShow")

    -- Initialize formation template detail page state machine.
    local function init_formation_template_detail_terminal()
        -- 下一个卡牌下标
        local hero_list_view_get_next_ship_info_terminal = {
            _name = "hero_list_view_get_next_ship_info",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    return instance:getNextPageShipInfo(params)
                else
                    return 1
                end
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 查看阵容
        local formation_template_detail_show_formation_terminal = {
            _name = "formation_template_detail_show_formation",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params then
                    local cardList = params._datas.card_list
                    local shipList = {}
                    for i, v in ipairs(cardList) do
                        local temp = {}
                        temp.shipId = tonumber(v)
                        temp.shipPos = i
                        temp.shipInfo = fundShipWidthTemplateId(tonumber(v))
                        table.insert(shipList, temp)
                    end
                    state_machine.excute("formation_show_window_open", 0, {mShipList = shipList})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(hero_list_view_get_next_ship_info_terminal)
        state_machine.add(formation_template_detail_show_formation_terminal)
        state_machine.init()
    end
    -- call func init formation template detail state machine.
    init_formation_template_detail_terminal()
end

function FormationTemplateDetail:getWordInfo(wordId)
    local word_info = dms.element(dms["word_mould"], wordId)
    local str = word_info[3]
    return str
end

--获取下一个卡牌数据
function FormationTemplateDetail:getNextPageShipInfo(index)
    local chooseIndex = index
    if 1 > chooseIndex then
        chooseIndex = #self._card_list
    elseif #self._card_list < chooseIndex then
        chooseIndex = 1
    end

    local ship_id = nil
    local index = 1
    for i, v in ipairs(self._card_list) do
        if index == tonumber(chooseIndex) then
            ship_id = v
        end
        index = index + 1
    end

    return zstring.tonumber(ship_id), chooseIndex
end

function FormationTemplateDetail:drawRoleSp(sender, heroId)
    local shipInfo = fundShipWidthTemplateId(heroId)
    local evo_mould_id = 0
    if shipInfo == nil then
        local evo_image = dms.string(dms["ship_mould"], heroId, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        local captain_name = dms.int(dms["ship_mould"], heroId, ship_mould.captain_name)
        evo_mould_id = evo_info[captain_name]
    else
        local ship_evo = zstring.split(shipInfo.evolution_status, "|")
        evo_mould_id = smGetSkinEvoIdChange(shipInfo)
    end

    local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    local armature_hero = sp.spine_sprite(sender, picIndex, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
    armature_hero:setScaleX(-1)
    sp.initArmature(armature_hero, true)
end

function FormationTemplateDetail:onUpdateDraw()
    local root = self.roots[1]
    local templateData = dms.searchs(dms["recommendation_formation_mould"], recommendation_formation_mould.recommend_group, self._group_id)
    local info = templateData[1]
    local heroList = zstring.split(info[recommendation_formation_mould.recommend_list], ",")
    self._card_list = heroList
    local heroCoreIdx = tonumber(info[recommendation_formation_mould.recommend_pos])

    -- 队名
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    Text_name:setString(self:getWordInfo(info[recommendation_formation_mould.recommend_name]))

    -- 角色动画
    local Panel_role_effect = ccui.Helper:seekWidgetByName(root, "Panel_role_effect")
    self:drawRoleSp(Panel_role_effect, heroList[heroCoreIdx])

    --角色类型
    local Sprite_name_bar = ccui.Helper:seekWidgetByName(root, "Panel_detail"):getChildByName("Sprite_name_bar") 
    local camp_preference = dms.int(dms["ship_mould"], heroList[heroCoreIdx], ship_mould.camp_preference)
    if camp_preference > 0 and camp_preference <= 3 then
        Sprite_name_bar:setTexture(string.format("images/ui/icon/sm_type_bar_%d.png", camp_preference))
    end

    -- 角色名
    local Text_role_name = ccui.Helper:seekWidgetByName(root, "Text_role_name")
    Text_role_name:setString(self:getWordInfo(info[recommendation_formation_mould.recommend_core_name]))

    -- 简介
    local Text_parse = ccui.Helper:seekWidgetByName(root, "Text_parse")
    Text_parse:setString(self:getWordInfo(info[recommendation_formation_mould.recommend_describe]))

    -- 队员（1-6）
    for i = 1, #heroList do
        local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon_" .. i)
        Panel_icon:removeAllChildren(true)
        local mInfo = {}
        mInfo.index = i
        mInfo.heroId = heroList[i]
        mInfo.isCore = heroCoreIdx == i
        local cell = state_machine.excute("formation_template_icon_cell_create", 0, {mType = 2, mInfo = mInfo})
        Panel_icon:addChild(cell)
    end
end

function FormationTemplateDetail:drawBtn()
    local root = self.roots[1]
    -- 阵容详情按钮
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_formation"),
        nil,
        {
            terminal_name = "formation_template_detail_show_formation",
            terminal_state = 0,
            card_list = self._card_list,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "formation_template_detail_window_close",
            terminal_state = 0,
            card_list = self._card_list,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

function FormationTemplateDetail:onEnterTransitionFinish()
    local csbNode = csb.createNode("packs/HeroStorage/generals_team_detail.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self:onUpdateDraw()
    self:drawBtn()
end

-- 对象初始化
function FormationTemplateDetail:init(params)
    self._group_id = params.mGroupId
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function FormationTemplateDetail:onExit()
    state_machine.remove("hero_list_view_get_next_ship_info")
    state_machine.remove("formation_template_detail_show_formation")
end

function FormationTemplateDetail:close()
    -- window event : close.
end

function FormationTemplateDetail:destroy(window)
    -- window event : destroy.
end
