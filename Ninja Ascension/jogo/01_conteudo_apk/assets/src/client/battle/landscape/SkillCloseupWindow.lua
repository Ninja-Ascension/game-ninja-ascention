-- ----------------------------------------------------------------------------------
-- SkillCloseupWindow 头像特写镜头
-- ----------------------------------------------------------------------------------
SkillCloseupWindow= class("SkillCloseupWindowClass", Window)

local skill_closeup_window_open_terminal = {
    _name = "skill_closeup_window_open",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("skill_closeup_window_close", 0, 0)
        local window = SkillCloseupWindow:new():init(params)
        fwin:open(window, fwin._view)
        playEffectMusic(9705)
        return window
    end,
    _terminal = nil,
    _terminals = nil
}

local skill_closeup_window_close_terminal = {
    _name = "skill_closeup_window_close",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SkillCloseupWindowClass"))
        return window
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(skill_closeup_window_open_terminal)
state_machine.add(skill_closeup_window_close_terminal)
state_machine.init()

function SkillCloseupWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    -- load lua file

    -- var
    self._camp = 0
    self._head = 0

    -- Initialize skill closeup window state machine.
    local function init_skill_closeup_window_terminal()
        local skill_closeup_window_play_sp_effect_terminal = {
            _name = "skill_closeup_window_play_sp_effect",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:playSpEffect()
                return window
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(skill_closeup_window_play_sp_effect_terminal)
        state_machine.init()
    end

    -- call func init skill closeup window state machine.
    init_skill_closeup_window_terminal()
end

function SkillCloseupWindow:init(params)
    self._target = params[1]
    self._camp = params[2]
    self._head = params[3]
    return self
end

function SkillCloseupWindow:playSpEffect()
    self:setVisible(false)

    local armatureEffect = self._target:createEffect("bishabaoqi", "sprite/effect_")
    armatureEffect._self = self._target
    armatureEffect._invoke = function ( armatureBack )
        armatureEffect._self.__deleteEffectFile(armatureBack)
        state_machine.excute("skill_closeup_window_close", 0, 0)
    end

    local size = self._target:getContentSize()
    -- armatureEffect:setPosition(cc.p(size.width / 2, 0))
    armatureEffect:setPosition(cc.p(self._target.parent:getPosition()))
    self._target.parent:getParent():addChild(armatureEffect, 2000000)
end

function SkillCloseupWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("battle/battle_super_skill_head.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    local action = csb.createTimeline("battle/battle_super_skill_head.csb")
    table.insert(self.actions, action)
    csbNode:runAction(action)

    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_close" then
            state_machine.excute("skill_closeup_window_close", 0, 0)
            -- state_machine.excute("skill_closeup_window_play_sp_effect", 0, 0)
        end
    end)

    action:play("texie_1", false)

    local controlLayer = nil
    local Panel_head = nil
    local ArmatureNode = nil

    local Panel_spine = nil
    local Panel_skill_name = nil
    if 0 == self._camp then
        controlLayer = ccui.Helper:seekWidgetByName(root, "Panel_left")
        Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head_1")
        ArmatureNode = controlLayer:getChildByName("ArmatureNode_1")

        Panel_spine = ccui.Helper:seekWidgetByName(root, "Panel_spine_left")
        Panel_skill_name = ccui.Helper:seekWidgetByName(root, "Panel_left_1")
    else
        controlLayer = ccui.Helper:seekWidgetByName(root, "Panel_right")
        Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head_2")
        ArmatureNode = controlLayer:getChildByName("ArmatureNode_2")

        Panel_spine = ccui.Helper:seekWidgetByName(root, "Panel_spine_right")
        Panel_skill_name = ccui.Helper:seekWidgetByName(root, "Panel_right_1")
    end
    controlLayer:setVisible(true)
    if nil ~= Panel_head then
        Panel_head:setBackGroundImage(string.format("images/face/big_head/big_head_%s.png", "" .. self._head))
    end

    if nil ~= Panel_skill_name then
        Panel_skill_name:setBackGroundImage(string.format("images/face/rage_head/rage_name_%s.png", "" .. self._head))
    end

    if nil ~= ArmatureNode then
        local spriteIcon = string.format("images/face/rage_head/rage_name_%d.png", zstring.tonumber(self._head))
        -- print(spriteIcon)
        local skinIcon = ccs.Skin:create(spriteIcon)
        skinIcon:getTexture():setAliasTexParameters()
        ArmatureNode:getBone("name"):addDisplay(skinIcon, 0)
    end

    if nil ~= Panel_spine then
        local jsonFile = "images/ui/effice/effect_nuqitexie/effect_nuqitexie.json"
        local atlasFile = "images/ui/effice/effect_nuqitexie/effect_nuqitexie.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_spine:addChild(animation)
    end

    -- 火影项目添加绝技释放的遮挡光效
    if 0 == self._camp then
        local Panel_spine_left_1 = ccui.Helper:seekWidgetByName(root, "Panel_spine_left_1")
        if nil ~= Panel_spine_left_1 then
            local jsonFile = "images/ui/effice/effect_nuqitexie_1/effect_nuqitexie_1.json"
            local atlasFile = "images/ui/effice/effect_nuqitexie_1/effect_nuqitexie_1.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            Panel_spine_left_1:addChild(animation)
        end
    else
        local Panel_spine_right_1 = ccui.Helper:seekWidgetByName(root, "Panel_spine_right_1")
        if nil ~= Panel_spine_right_1 then
            local jsonFile = "images/ui/effice/effect_nuqitexie_1/effect_nuqitexie_1.json"
            local atlasFile = "images/ui/effice/effect_nuqitexie_1/effect_nuqitexie_1.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            Panel_spine_right_1:addChild(animation)
        end
    end
end

function SkillCloseupWindow:onExit()
    -- state_machine.remove("skill_closeup_window_play_sp_effect")
    if nil ~= self._target and nil ~= self._target.parent then
        self._target.parent:stopAllActionsByTag(2)
        self._target:excuteSPSkillEffect()
    end
end
