--------------------------------------------------------------------------------------------------------------
--  说明：升级界面
--------------------------------------------------------------------------------------------------------------
EffectPlay = class("EffectPlayClass", Window)

--打开界面
local effect_play_window_open_terminal = {
    _name = "effect_play_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("EffectPlayClass") == nil then
            local effect_type = params[1]
            fwin:open(EffectPlay:new():init(effect_type), fwin._display_log)
        else
            local effect_type = params[1]
            state_machine.excute("effect_play_continue_play", 0, effect_type)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local effect_play_window_close_terminal = {
    _name = "effect_play_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EffectPlayClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(effect_play_window_open_terminal)
state_machine.add(effect_play_window_close_terminal)
state_machine.init()

function EffectPlay:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    
    -- var 
    -- 动画类型
    self._effect_type = 0

    self._armature = nil 

    self._first_time = true
    self._is_continue = false

     -- Initialize effect_play state machine.
    local function init_effect_play_terminal()
        local effect_play_update_action_terminal = {
            _name = "effect_play_update_action",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updatePlayEffect()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local effect_play_continue_play_terminal = {
            _name = "effect_play_continue_play",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._is_continue = true
                instance._effect_type = params
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local effect_play_on_close_terminal = {
            _name = "effect_play_on_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._is_continue == false then
                    state_machine.excute("effect_play_window_close",0,"")
                else
                    instance._is_continue = false
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(effect_play_update_action_terminal)
        state_machine.add(effect_play_continue_play_terminal)
        state_machine.add(effect_play_on_close_terminal)
        state_machine.init()
    end
    
    -- call func effect_play create state machine.
    init_effect_play_terminal()
end


--初始化界面
function EffectPlay:updateDraw()

    local root = self.roots[1]
    local Panel_play = ccui.Helper:seekWidgetByName(root, "Panel_play")
    Panel_play:removeAllChildren(true)
    local effect_name = "" 
    if self._effect_type == 1 then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_up_hero)
        effect_name = "effect_up_hero"
    elseif self._effect_type == 2 then 
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_up_commander)
        effect_name = "effect_up_commander"
    elseif self._effect_type == 3 then 
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_up_prestige)
        effect_name = "effect_up_prestige"
    elseif self._effect_type == 4 then 
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_up_skill)
        effect_name = "effect_up_skill"
    else
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_up_vip)
        effect_name = "effect_up_vip"
    end

    self._armature = ccs.Armature:create(effect_name)
    local function deleteEffectFile(armatureBack)
        if armatureBack.removeFromParent ~= nil then
            armatureBack:removeFromParent(true)
            state_machine.excute("effect_play_on_close",0,"")
        end
    end
    draw.initArmature(self._armature, nil, -1, 0, 1)
    self._armature:getAnimation():playWithIndex(0)
    self._armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    self._armature._invoke = deleteEffectFile
    Panel_play:addChild(self._armature)
end

function EffectPlay:updatePlayEffect()
    local root = self.roots[1]
    
    local Panel_play = ccui.Helper:seekWidgetByName(root, "Panel_play")
    self._armature:getAnimation():setFrameEventCallFunc(
    function(bone,evt,originFrameIndex,currentFrameIndex)
        local tempArmature = bone:getArmature()
        if tempArmature:isVisible() == true then
            if self._first_time == true then
                self._first_time = false
                if evt == "end" then
                    tempArmature:removeFromParent(true)
                    self:updateDraw()
                end
            else
                if evt == "open_over" then
                    tempArmature:removeFromParent(true)
                    self:updateDraw()
                end
            end
        end
    end)
end

--初始化
function EffectPlay:onInit()
    local csbItem = csb.createNode(config_csb.utils.effect_play)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:updateDraw()
    
end

function EffectPlay:onEnterTransitionFinish()

end

function EffectPlay:init(effect_type)
    self._effect_type = effect_type
    self:onInit()
    return self
end

function EffectPlay:onExit()
    state_machine.remove("effect_play_update_action")
    state_machine.remove("effect_play_continue_play")
    state_machine.remove("effect_play_on_close")
end