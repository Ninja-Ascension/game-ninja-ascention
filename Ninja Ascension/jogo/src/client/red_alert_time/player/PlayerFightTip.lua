--------------------------------------------------------------------------------------------------------------
--  说明：战斗力提升详情
--------------------------------------------------------------------------------------------------------------
PlayerFightTip = class("PlayerFightTipClass", Window)

--打开界面
local player_fight_tip_open_terminal = {
	_name = "player_fight_tip_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("PlayerFightTipClass") == nil then
            local _win = PlayerFightTip:new()
            _win:init(params)
            fwin:open(_win, fwin._ui)
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_fight_tip_close_terminal = {
	_name = "player_fight_tip_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerFightTipClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_fight_tip_open_terminal)
state_machine.add(player_fight_tip_close_terminal)
state_machine.init()

function PlayerFightTip:ctor()
	self.super:ctor()
	self.roots = {}

    self._dec = nil
end

function PlayerFightTip:updateDraw()
    local root = self.roots[1]
    -- 描述
    local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
    Text_tip:setString(self._dec)

end


--初始化
function PlayerFightTip:onInit()
    local csbItem = csb.createNode(config_csb.player.player_fight_tip)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_fight_tip"), nil, 
    {
        terminal_name = "player_fight_tip_close", 
        terminal_state = 0, 
    }, nil, 1)

    self:updateDraw()
end

function PlayerFightTip:onEnterTransitionFinish()

end

function PlayerFightTip:init(param)
    self._dec = param[1]
	self:onInit()
    return self
end

function PlayerFightTip:onExit()
end