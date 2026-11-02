-----------------------------
-- 王者之战下注界面
-----------------------------
SmBattleofKingsBetting = class("SmBattleofKingsBettingClass", Window)

--打开界面
local sm_battleof_kings_betting_open_terminal = {
	_name = "sm_battleof_kings_betting_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local from_type = params._datas.from_type
		if fwin:find("SmBattleofKingsBettingClass") == nil then
			fwin:open(SmBattleofKingsBetting:new():init(from_type), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_battleof_kings_betting_close_terminal = {
	_name = "sm_battleof_kings_betting_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmBattleofKingsBettingClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_battleof_kings_betting_open_terminal)
state_machine.add(sm_battleof_kings_betting_close_terminal)
state_machine.init()

function SmBattleofKingsBetting:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.l_digital.cells.campaign.battleofKings.sm_battle_of_kings_betting_list_cell")

    local function init_sm_battleof_kings_betting_terminal()
        local sm_battleof_kings_betting_update_draw_terminal = {
            _name = "sm_battleof_kings_betting_update_draw",
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

        state_machine.add(sm_battleof_kings_betting_update_draw_terminal)
        state_machine.init()
    end
    init_sm_battleof_kings_betting_terminal()
end

function SmBattleofKingsBetting:onUpdateList()
    local root = self.roots[1]

    local ListView_dh = ccui.Helper:seekWidgetByName(root,"ListView_dh")
    ListView_dh:removeAllItems()

    local result = {}
    if self._from_type == 1 and _ED.battle_kings_score_rank.other_user ~= nil then
        result = _ED.battle_kings_score_rank.other_user
    elseif self._from_type == 2 and _ED.union.union_fight_betting_info ~= nil then
        result = _ED.union.union_fight_betting_info
    end

    for k, v in pairs(result) do
        local cell = state_machine.excute("sm_battle_of_kings_betting_list_cell_create",0,{v, self._from_type})
         ListView_dh:addChild(cell)
    end

    ListView_dh:requestRefreshView()
end

function SmBattleofKingsBetting:onUpdateDraw()
    local root = self.roots[1]
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateList()
            end
        end
    end
    if self._from_type == 1 then
        protocol_command.order_get_info.param_list = "7".."\r\n".."1".."\r\n".."20"
        NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, self, responseCallback, false, nil)
    elseif self._from_type == 2 then
        protocol_command.union_warfare_manager.param_list = "4".."\r\n".."0".."\r\n".."0"
        NetworkManager:register(protocol_command.union_warfare_manager.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function SmBattleofKingsBetting:init(from_type)
    self._from_type = from_type
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function SmBattleofKingsBetting:onInit()
    local csbItem = csb.createNode("campaign/BattleofKings/battle_of_kings_stake.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_dh_back"), nil, 
    {
        terminal_name = "sm_battleof_kings_betting_close", 
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

function SmBattleofKingsBetting:onEnterTransitionFinish()
    
end


function SmBattleofKingsBetting:onExit()
	state_machine.remove("sm_battleof_kings_betting_update_draw")
end

