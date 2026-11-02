-----------------------------
-- 跨服王者之战下注界面
-----------------------------
SmCrossServerBattleofKingsBetting = class("SmCrossServerBattleofKingsBettingClass", Window)

--打开界面
local sm_cross_server_battleof_kings_betting_open_terminal = {
	_name = "sm_cross_server_battleof_kings_betting_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local from_type = params._datas.from_type
		if fwin:find("SmCrossServerBattleofKingsBettingClass") == nil then
			fwin:open(SmCrossServerBattleofKingsBetting:new():init(from_type), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_cross_server_battleof_kings_betting_close_terminal = {
	_name = "sm_cross_server_battleof_kings_betting_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmCrossServerBattleofKingsBettingClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cross_server_battleof_kings_betting_open_terminal)
state_machine.add(sm_cross_server_battleof_kings_betting_close_terminal)
state_machine.init()

function SmCrossServerBattleofKingsBetting:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.l_digital.cells.campaign.crossServerBattleofKings.sm_cross_server_battle_of_kings_betting_list_cell")

    local function init_sm_cross_server_battleof_kings_betting_terminal()
        local sm_cross_server_battleof_kings_betting_update_draw_terminal = {
            _name = "sm_cross_server_battleof_kings_betting_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_cross_server_battleof_kings_betting_update_draw_terminal)
        state_machine.init()
    end
    init_sm_cross_server_battleof_kings_betting_terminal()
end

function SmCrossServerBattleofKingsBetting:onUpdateList()
    local root = self.roots[1]

    local ListView_dh = ccui.Helper:seekWidgetByName(root,"ListView_dh")
    ListView_dh:removeAllItems()
    if nil == _ED.cross_server_battle_kings_score_rank then
        return
    end
    local result = _ED.cross_server_battle_kings_score_rank.other_user

    for k, v in pairs(result) do
        local cell = state_machine.excute("sm_cross_server_battle_of_kings_betting_list_cell_create",0,{v, self._from_type})
         ListView_dh:addChild(cell)
    end

    ListView_dh:requestRefreshView()
end

function SmCrossServerBattleofKingsBetting:onUpdateDraw()
    local root = self.roots[1]
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateList()
            end
        end
    end
    
    protocol_command.the_kings_battle_self_battle_rank.param_list = "1".."\r\n".."20"
    NetworkManager:register(protocol_command.the_kings_battle_self_battle_rank.code, nil, nil, nil, self, responseCallback, false, nil)

end

function SmCrossServerBattleofKingsBetting:init(from_type)
    self._from_type = from_type
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function SmCrossServerBattleofKingsBetting:onInit()
    local csbItem = csb.createNode("campaign/BattleofKingsX/battle_of_kings_x_stake.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_dh_back"), nil, 
    {
        terminal_name = "sm_cross_server_battleof_kings_betting_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	

    self:onUpdateDraw()

    if self._from_type == 1 then
        local userinfo = UserTopInfoA:new()
        userinfo._rootWindows = self
        local info = fwin:open(userinfo,fwin._windows)
    elseif self._from_type == 2 then
        state_machine.excute("sm_union_user_topinfo_open",0,self)
    end
end

function SmCrossServerBattleofKingsBetting:onEnterTransitionFinish()
    
end


function SmCrossServerBattleofKingsBetting:onExit()
	state_machine.remove("sm_cross_server_battleof_kings_betting_update_draw")
end

