--[[ ----------------------------------------------------------------------------
-- 阵容推荐界面列表
--]] ----------------------------------------------------------------------------
FormationTemplateCell = class("FormationTemplateCellClass", Window)
FormationTemplateCell.__size = nil

-- 创建Cell实例
local formation_template_cell_create_terminal = {
    _name = "formation_template_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if FormationTemplateCell then
            local cell = FormationTemplateCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(formation_template_cell_create_terminal)
state_machine.init()

-- 构造器
function FormationTemplateCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._template_info = nil -- 当前推荐信息
    -- load lua files.

    -- Initialize formation template cell page state machine.
    local function init_formation_template_cell_terminal()
        -- 进入阵容详情
        local formation_template_cell_detail_terminal = {
            _name = "formation_template_cell_detail",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if not params then
                    return true
                end
                local groupId = params._datas.group_id
                if groupId then
                    state_machine.excute("formation_template_detail_window_open", 0, {mGroupId = groupId})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(formation_template_cell_detail_terminal)
        state_machine.init()
    end
    -- call func init formation template cell state machine.
    init_formation_template_cell_terminal()
end

function FormationTemplateCell:getWordInfo(wordId)
    local word_info = dms.element(dms["word_mould"], tonumber(wordId))
    local str = word_info[3]
    return str
end

function FormationTemplateCell:onUpdateDraw()
    local root = self.roots[1]
    local templateInfo = self._template_info
    local heroInfo = dms.atos(templateInfo, recommendation_formation_mould.recommend_list)
    local heroList = zstring.split(heroInfo, ",")
    local heroCoreIdx = dms.atoi(templateInfo, recommendation_formation_mould.recommend_pos)
    -- 队名
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    Text_name:setString(self:getWordInfo(dms.atos(templateInfo, recommendation_formation_mould.recommend_name)))

    -- 阵容类型
    local formationType = dms.atoi(templateInfo, recommendation_formation_mould.recommend_type)
    for i = 1, 2 do
        local Panel_type = ccui.Helper:seekWidgetByName(root, "Panel_" .. i)
        if formationType == i then
            Panel_type:setVisible(true)
        else
            Panel_type:setVisible(false)
        end
    end

    -- 队伍口号
    local Text_slogan = ccui.Helper:seekWidgetByName(root, "Text_slogan")
    Text_slogan:setString(self:getWordInfo(dms.atos(templateInfo, recommendation_formation_mould.recommend_character)))

    -- 队员（1-6）
    for i = 1, #heroList do
        local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon_" .. i)
        Panel_icon:removeAllChildren(true)
        local mInfo = {}
        mInfo.index = i
        mInfo.heroId = heroList[i]
        mInfo.isCore = heroCoreIdx == i
        local cell = state_machine.excute("formation_template_icon_cell_create", 0, {mType = 1, mInfo = mInfo})
        Panel_icon:addChild(cell)
    end
end

function FormationTemplateCell:drawButton()
    local root = self.roots[1]
    local groupId = dms.atoi(self._template_info, recommendation_formation_mould.recommend_group)
    -- 选中队伍按钮
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_detail"),
        nil,
        {
            terminal_name = "formation_template_cell_detail",
            group_id = groupId,
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

-- 对象初始化
function FormationTemplateCell:init(params)
    self._template_info = params.m_info
    self._index = params.index
    if self._index < 4 then 
        self:onInit(params)
    end
    self:setContentSize(FormationTemplateCell.__size)
    return self
end

function FormationTemplateCell:onInit(params)
    local root = cacher.createUIRef("packs/HeroStorage/generals_team_cell.csb", "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if FormationTemplateCell.__size == nil then
        FormationTemplateCell.__size = root:getContentSize()
    end
    self:clearUIInfo()
    self:onUpdateDraw()
    self:drawButton()
end

function FormationTemplateCell:onEnterTransitionFinish()
end

function FormationTemplateCell:clearUIInfo()
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    if Text_name ~= nil then
        Text_name:setString("")
    end
    local Text_slogan = ccui.Helper:seekWidgetByName(root, "Text_slogan")
    if Text_slogan ~= nil then
        Text_slogan:setString("")
    end
    for i = 1, 6 do
        local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon_" .. i)
        if Panel_icon ~= nil then
            Panel_icon:removeAllChildren(true)
        end
    end
end

function FormationTemplateCell:onExit()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef("packs/HeroStorage/generals_team_cell.csb", root)
end

function FormationTemplateCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function FormationTemplateCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("packs/HeroStorage/generals_team_cell.csb", root)

    self.roots = {}
end
