-- ---------------------------
-- 推送(带数字)
-- ---------------------------
UtilTips = class("UtilTipsClass", Window)
UtilTips.__size = nil

local util_tips_create_terminal = {
    _name = "util_tips_cretae",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = UtilTips:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

local util_tips_window_close_terminal = {
    _name = "util_tips_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        fwin:close(fwin:find("UtilTipsClass"))
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(util_tips_create_terminal)
state_machine.add(util_tips_window_close_terminal)
state_machine.init()

function UtilTips:ctor()
    self.super:ctor()
    self.roots = {}

    self._number = nil 
end

function UtilTips:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function UtilTips:onUpdateDraw()
    local root = self.roots[1]
    local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
    if self._number == nil then
        Text_number:setString("")
    else
        Text_number:setString(self._number)
    end
    local Panel_tuisong = ccui.Helper:seekWidgetByName(root, "Panel_tuisong")
    Panel_tuisong:removeAllChildren(true)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_tuisong)
    local armature = ccs.Armature:create("effect_tuisong")
    armature:getAnimation():playWithIndex(0)
    armature:setPosition(cc.p(Panel_tuisong:getContentSize().width/2,Panel_tuisong:getContentSize().height/2))
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc) 
    Panel_tuisong:addChild(armature)

end

function UtilTips:onInit()
    local root = cacher.createUIRef(config_csb.utils.util_tips, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if UtilTips.__size == nil then
        UtilTips.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function UtilTips:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef(config_csb.utils.util_tips, self.roots[1])
end

function UtilTips:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function UtilTips:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.utils.util_tips, root)
    root:removeFromParent(false)
    self.roots = {}
end

function UtilTips:init(params)
    self._number = params[1]
    self:onInit()
    self:setContentSize(UtilTips.__size)
end

function UtilTips:clearUIInfo()
    local root = self.roots[1]  
    local Panel_tuisong = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_n_1")    
    if Panel_tuisong ~= nil then
        Panel_tuisong:removeAllChildren(true)
    end
end
