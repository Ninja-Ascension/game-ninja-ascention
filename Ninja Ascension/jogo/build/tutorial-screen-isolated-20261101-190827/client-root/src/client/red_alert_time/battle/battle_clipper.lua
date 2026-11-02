-- ----------------------------------------------------------------------------------------------------
-- 说明：纹理剪裁特效
-- ----------------------------------------------------------------------------------------------------
BattleClipper = class("BattleClipperClass", Window)

local battle_clipper_create_terminal = {
    _name = "battle_clipper_create",
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

state_machine.add(battle_clipper_create_terminal)
state_machine.init()

function BattleClipper:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
end

function BattleClipper:init(params)
	return self
end

function BattleClipper:onEnterTransitionFinish()

end

function BattleClipper:close()

end

function BattleClipper:destroy()

end
-- ----------------------------------------------------------------------------------------------------