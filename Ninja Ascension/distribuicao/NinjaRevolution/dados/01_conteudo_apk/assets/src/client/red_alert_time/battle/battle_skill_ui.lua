-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗技能UI
-- ----------------------------------------------------------------------------------------------------
BattleSkillUI = class("BattleSkillUIClass", Window)

local battle_skill_ui_window_open_terminal = {
    _name = "battle_skill_ui_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _battleUI = BattleSkillUI:new():init(params)
        fwin:open(_battleUI)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_skill_ui_window_close_terminal = {
    _name = "battle_skill_ui_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleSkillUIClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_skill_ui_window_open_terminal)
state_machine.add(battle_skill_ui_window_close_terminal)
state_machine.init()

function BattleSkillUI:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    -- var

    -- load lua file 

    local function init_battle_skill_ui_terminal()
        -- 打开主公技
        local battle_skill_ui_window_update_draw_skill_terminal = {
            _name = "battle_skill_ui_window_update_draw_skill",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawSkill(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(battle_skill_ui_window_update_draw_skill_terminal)
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_battle_skill_ui_terminal()    
end

function BattleSkillUI:init(params)
	local rootWindow = params[1]
	self._rootWindows = rootWindow
    return self
end

function BattleSkillUI:updateDrawSkill(pic_index)
    local root = self.roots[1]
    local Panel_font = ccui.Helper:seekWidgetByName(root, "Panel_font")
    Panel_font:removeAllChildren(true)

    local baseName = "images/face/skill_head/spirte_skill_name_pen"
    local skeletonNodePad = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
    
    skeletonNodePad:registerSpineEventHandler(function (event)
        event.skeletonAnimation:removeFromParent(true)
    end, sp.EventType.ANIMATION_COMPLETE)

    skeletonNodePad:setAnimation(0, _spine_effect_animation_names[1], true)
    Panel_font:addChild(skeletonNodePad)

    
    baseName = string.format(config_res.battle.spirte_skill_name, pic_index)
    local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)

    skeletonNode:registerSpineEventHandler(function (event)
        event.skeletonAnimation:removeFromParent(true)
    end, sp.EventType.ANIMATION_COMPLETE)

    skeletonNode:setAnimation(0, _spine_effect_animation_names[1], true)
    Panel_font:addChild(skeletonNode)
end

function BattleSkillUI:onEnterTransitionFinish()
    local csbItem = csb.createNode(config_csb.battle.battle_font_donghua)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- local action = csb.createTimeline(config_csb.battle.battle_font_donghua)
    -- table.insert(self.actions,action)
    -- csbItem:runAction(action)
end

function BattleSkillUI:close()

end

function BattleSkillUI:destroy()

end

function BattleSkillUI:onExit()
    state_machine.remove("battle_skill_ui_window_update_draw_skill")
end
-- ----------------------------------------------------------------------------------------------------