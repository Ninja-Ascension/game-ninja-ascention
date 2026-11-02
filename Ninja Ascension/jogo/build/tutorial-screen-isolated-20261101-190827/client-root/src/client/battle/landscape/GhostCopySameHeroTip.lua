GhostCopySameHeroTip = class("GhostCopySameHeroTipClass", Window)
 
function GhostCopySameHeroTip:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

    local function init_ghost_copy_same_hero_tip_terminal()
        local ghost_copy_same_hero_tip_close_terminal = {
            _name = "ghost_copy_same_hero_tip_close", 
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

        state_machine.add(ghost_copy_same_hero_tip_close_terminal)
        state_machine.init()
    end

    init_ghost_copy_same_hero_tip_terminal()
end

function GhostCopySameHeroTip:init(params)
    self._role = params
    self:onInit()
    return self
end

function GhostCopySameHeroTip:onInit( ... )
    local csbAction = csb.createNode("campaign/maoxian_batle_role_same.csb")
    self:addChild(csbAction)
    local taction = csb.createTimeline("campaign/maoxian_batle_role_same.csb")
    csbAction:runAction(taction)
    -- action group name 'Image_battle_same'
    taction:gotoFrameAndPlay(0, taction:getDuration(), false)
    taction:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "Image_battle_same_over" then
            if self._role.roleCamp == 1 then
                local ghostCopySameHeroSteamBubble = GhostCopySameHeroSteamBubble:new():init(self._role)
                self._role:addChild(ghostCopySameHeroSteamBubble)
                self._role._ghostCopySameHeroSteamBubble = ghostCopySameHeroSteamBubble
                
                self._role:runAction(cc.Sequence:create(
                    cc.DelayTime:create(0.5),
                    cc.CallFunc:create(function ( sender )
                        self._role:setScaleX(-1)
                        sender._ghostCopySameHeroSteamBubble:removeFromParent(true)
                    end),
                    cc.MoveBy:create(0.5, cc.p(640, 0)), 
                    cc.CallFunc:create(function ( sender )
                        _ED._fightModule:killAppointFightObject(1, sender._info._pos)
                        state_machine.excute("fight_role_controller_update_hp_progress", 0, {sender.roleCamp, 0})
                        state_machine.excute("fight_role_be_killed", 0, sender)
                        -- sender:removeFromParent(true)
                end)))
            end

            self:removeAllChildren(true)
        end
    end)
end

function GhostCopySameHeroTip:onEnterTransitionFinish()
	-- local csbChangeSceneCell = csb.createNode("battle/battle_map_heng_huihe_hei.csb")
	-- local root = csbChangeSceneCell:getChildByName("root")
	-- table.insert(self.roots, root)
	-- self:addChild(csbChangeSceneCell)

	-- local action = csb.createTimeline("battle/battle_map_heng_huihe_hei.csb")
 --    table.insert(self.actions, action)

 --    csbChangeSceneCell:runAction(action)
 --    action:setFrameEventCallFunc(function (frame)
 --        if nil == frame then
 --            return
 --        end

 --        local str = frame:getEvent()
 --        if str == "heiping_huihe_over" then
 --        	fwin:close(self)
 --        end
 --    end)
 --    action:play("heiping_huihe", false)
end

function GhostCopySameHeroTip:onExit()

end
