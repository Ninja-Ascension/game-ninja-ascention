-----------------------------
-- 王者之战兑换界面
-----------------------------
SmBattleofKingsExchange = class("SmBattleofKingsExchangeClass", Window)

--打开界面
local sm_battleof_kings_exchange_open_terminal = {
	_name = "sm_battleof_kings_exchange_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local from_type = params._datas.from_type
		if fwin:find("SmBattleofKingsExchangeClass") == nil then
			fwin:open(SmBattleofKingsExchange:new():init(from_type), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_battleof_kings_exchange_close_terminal = {
	_name = "sm_battleof_kings_exchange_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmBattleofKingsExchangeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_battleof_kings_exchange_open_terminal)
state_machine.add(sm_battleof_kings_exchange_close_terminal)
state_machine.init()

function SmBattleofKingsExchange:ctor()
	self.super:ctor()
	self.roots = {}

	self._from_type = 0
	self._prop_id_1 = 0
	self._prop_id_2 = 0

	-- load lua file
	app.load("client.l_digital.cells.campaign.battleofKings.sm_battle_of_kings_exchange_list_cell")
	app.load("client.cells.utils.resources_icon_cell")

    local function init_sm_battleof_kings_exchange_terminal()
        --刷新道具
        local sm_battleof_kings_exchange_update_need_prop_number_terminal = {
            _name = "sm_battleof_kings_exchange_update_need_prop_number",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateNeedPropNumber()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_battleof_kings_exchange_update_need_prop_number_terminal)

        state_machine.init()
    end
    init_sm_battleof_kings_exchange_terminal()
end

function SmBattleofKingsExchange:updateDraw()
	local root = self.roots[1]

	local ListView_dh = ccui.Helper:seekWidgetByName(root, "ListView_dh")
	ListView_dh:removeAllChildren(true)

	local elements = {}
	if self._from_type == 1 then
		elements = dms.searchs(dms["avatar_shop"], avatar_shop.shop_type, "5")
	else
		elements = dms.searchs(dms["avatar_shop"], avatar_shop.shop_type, "7")
	end
	for i, v in pairs(elements) do
		local cell = state_machine.excute("sm_battle_of_kings_exchange_list_cell_create", 0, {i, v})
		ListView_dh:addChild(cell)
	end

	ListView_dh:requestRefreshView()

	self:updateNeedPropNumber()
end

function SmBattleofKingsExchange:updateNeedPropNumber()
	local root = self.roots[1]

	if self._from_type == 1 then
		self._prop_id_1 = 324
		self._prop_id_2 = 323
		self._prop_id_3 = 620
	elseif self._from_type == 2 then
		self._prop_id_1 = 320
		self._prop_id_2 = 0
		self._prop_id_3 = 621
	end
	local Panel_have_props_1 = ccui.Helper:seekWidgetByName(root, "Panel_have_props_1")
    local Text_props_n_1 = ccui.Helper:seekWidgetByName(root, "Text_props_n_1")
	Panel_have_props_1:removeAllChildren(true)
	Panel_have_props_1:setVisible(false)
	Text_props_n_1:setString("")
	if self._prop_id_1 > 0 then
		Panel_have_props_1:setVisible(true)
		local cell = ResourcesIconCell:createCell()
	    cell:init(6, 0, self._prop_id_1,nil,nil,true,true)
	    Panel_have_props_1:addChild(cell)
	    Text_props_n_1:setString(getPropAllCountByMouldId(self._prop_id_1))
	end

	local Panel_have_props_2 = ccui.Helper:seekWidgetByName(root, "Panel_have_props_2")
    local Text_props_n_2 = ccui.Helper:seekWidgetByName(root, "Text_props_n_2")
	Panel_have_props_2:removeAllChildren(true)
	Panel_have_props_2:setVisible(false)
	Text_props_n_2:setString("")
	if self._prop_id_2 > 0 then
		Panel_have_props_2:setVisible(true)
		local cellTwo = ResourcesIconCell:createCell()
	    cellTwo:init(6, 0, self._prop_id_2,nil,nil,true,true)
	    Panel_have_props_2:addChild(cellTwo)
	    Text_props_n_2:setString(getPropAllCountByMouldId(self._prop_id_2))
	end

	local Panel_have_props_3 = ccui.Helper:seekWidgetByName(root, "Panel_have_props_3")
	if Panel_have_props_3 then
		local Text_props_n_3 = ccui.Helper:seekWidgetByName(root, "Text_props_n_3")
		Panel_have_props_3:removeAllChildren(true)
		Panel_have_props_3:setVisible(false)
		Text_props_n_3:setString("")
		if self._prop_id_3 > 0 then
			Panel_have_props_3:setVisible(true)
			local cell = ResourcesIconCell:createCell()
		    cell:init(6, 0, self._prop_id_3,nil,nil,true,true)
		    Panel_have_props_3:addChild(cell)
		    Text_props_n_3:setString(getPropAllCountByMouldId(self._prop_id_3))
		end
	end

    local items = ccui.Helper:seekWidgetByName(root, "ListView_dh"):getItems()
    for k,v in pairs(items) do
    	v:updateButtonDraw()
    end
end

function SmBattleofKingsExchange:init(from_type)
	self._from_type = from_type 			-- 1:王者之战，2：公会战
	self:onInit()
    return self
end

function SmBattleofKingsExchange:onInit()
    local csbItem = csb.createNode("campaign/BattleofKings/battle_of_kings_exchange.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_dh_back"), nil, 
    {
        terminal_name = "sm_battleof_kings_exchange_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	self:updateDraw()

	if self._from_type == 1 then
		local userinfo = UserTopInfoA:new()
	    userinfo._rootWindows = self
	    local info = fwin:open(userinfo,fwin._windows)
	elseif self._from_type == 2 then
		state_machine.excute("sm_union_user_topinfo_open",0,self)
	end
end

function SmBattleofKingsExchange:onEnterTransitionFinish()
    
end


function SmBattleofKingsExchange:onExit()
    state_machine.remove("sm_battleof_kings_exchange_change_page")
	state_machine.remove("sm_battleof_kings_exchange_open_rank")
end

