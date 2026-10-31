UnionFightRoleInfo = class("UnionFightRoleInfoClass", Window)

local union_fight_role_info_open_terminal = {
	_name = "union_fight_role_info_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("UnionFightRoleInfoClass")
		if window ~= nil and window:isVisible() == true then
			return true
		end
        state_machine.lock("union_fight_role_info_open")
		fwin:open(UnionFightRoleInfo:new():init(params), fwin._view)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fight_role_info_close_terminal = {
	_name = "union_fight_role_info_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("UnionFightRoleInfoClass")
		if window ~= nil then
			fwin:close(window)
		end	
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fight_role_info_open_terminal)
state_machine.add(union_fight_role_info_close_terminal)
state_machine.init()

function UnionFightRoleInfo:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.roleInfo = nil
	self.chooseCamp = 0
	self.mapIndex = 0
	self.formationIndex = 0

    local function init_union_fight_role_info_terminal()
		local union_fight_role_info_return_terminal = {
            _name = "union_fight_role_info_return",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_fight_role_info_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_role_info_fighting_terminal = {
            _name = "union_fight_role_info_fighting",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local chooseId = instance.roleInfo.userId
                local mapIndex = instance.mapIndex
                local mapData = dms.element(dms["union_fight_campsite_mould"], mapIndex)
                local campsite_index = dms.atos(mapData, union_fight_campsite_mould.campsite_index)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            			_ED.lastUnionFightMap = mapIndex
            			app.load("client.battle.BattleStartEffect")
						app.load("client.battle.fight.FightEnum")
                        fwin:cleanView(fwin._windows)
						fwin:freeAllMemeryPool()
						local bse = BattleStartEffect:new()
						bse:init(_enum_fight_type._fight_type_8)
						fwin:open(bse, fwin._windows)
                    end
                end
                if _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
                    protocol_command.unino_fight.param_list = _ED.union.union_info.union_id.."\r\n"..mapIndex.."\r\n".._ED.user_current_server_number.."\r\n"..instance.formationIndex
                    NetworkManager:register(protocol_command.unino_fight.code, _ED.union_fight_url, nil, nil, nil, responseCallback, true, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_role_info_change_role_terminal = {
            _name = "union_fight_role_info_change_role",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_fight_choose_open", 0, {instance.mapIndex, instance.roleInfo, instance.chooseCamp, instance.formationIndex})
                state_machine.excute("union_fight_role_info_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local union_fight_role_info_give_up_terminal = {
            _name = "union_fight_choose_cell_give_up",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local chooseId = instance.roleInfo.userId
                local mapIndex = instance.mapIndex
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	state_machine.excute("union_fight_role_info_close", 0, nil)
                    end
                end
                if _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
                    protocol_command.unino_set_formation.param_list = "1\r\n"..chooseId.."\r\n"..mapIndex.."\r\n"..instance.formationIndex.."\r\n".._ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number
                    NetworkManager:register(protocol_command.unino_set_formation.code, _ED.union_fight_url, nil, nil, nil, responseCallback, true, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_fight_role_info_return_terminal)
		state_machine.add(union_fight_role_info_fighting_terminal)
		state_machine.add(union_fight_role_info_change_role_terminal)
		state_machine.add(union_fight_role_info_give_up_terminal)
        state_machine.init()
    end
	
    init_union_fight_role_info_terminal()
end

function UnionFightRoleInfo:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
    local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name")
    if self.chooseCamp == 0 then
    	Text_legion_name:setString(_ED.union_fight_owner_union_name)
    else
    	Text_legion_name:setString(_ED.union_fight_other_union_name)
    end
    local nameText = ccui.Helper:seekWidgetByName(root, "Text_name")
    local levelText = ccui.Helper:seekWidgetByName(root, "Text_3")
    local fightText = ccui.Helper:seekWidgetByName(root, "Text_3_0")
    local Panel_role_icon = ccui.Helper:seekWidgetByName(root, "Panel_role_icon")
    local shipData = dms.element(dms["ship_mould"], self.roleInfo.userHeadId)
    local icon = dms.atos(shipData, ship_mould.head_icon)
    local quality = dms.atos(shipData, ship_mould.ship_type) + 1
    Panel_role_icon:setBackGroundImage(string.format("images/ui/props/props_%s.png", icon))
    local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
    local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", quality)
    Panel_kuang:setBackGroundImage(quality_path)
    local Panel_ye = ccui.Helper:seekWidgetByName(root, "Panel_ye")
    local Text_6 = ccui.Helper:seekWidgetByName(root, "Text_6")
    Panel_ye:setVisible(false)
    Text_6:setVisible(false)

    if tonumber(self.roleInfo.userState) == 0 or tonumber(self.roleInfo.userState) == 2 or self.chooseCamp == 0 then
    	Panel_ye:setVisible(true)
	    nameText:setString(self.roleInfo.userName)
	    levelText:setString(""..self.roleInfo.userLevel)
	    fightText:setString(""..self.roleInfo.userFighting)
	    for i=1,6 do
	    	local panel = ccui.Helper:seekWidgetByName(root, "Panel_ro_w_"..i)
	    	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_ro_k_"..i)
	    	local info = self.roleInfo.userFormations[i]
	    	if info ~= nil then
	    		-- 	info.userName
	    		local shipData = dms.element(dms["ship_mould"], info.userHead)
			    local icon = dms.atos(shipData, ship_mould.head_icon)
			    local quality = dms.atos(shipData, ship_mould.ship_type) + 1
			    nameText:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
	    		panel:setBackGroundImage(string.format("images/ui/props/props_%s.png", icon))
	    		local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality))
   				Panel_kuang:setBackGroundImage(quality_path)
	    	end
	    end
    else
    	Text_6:setVisible(true)
	    nameText:setString(tipStringInfo_union_str[63])
	    levelText:setString(tipStringInfo_union_str[63])
	    fightText:setString(tipStringInfo_union_str[63])
    end
    
 --    if tonumber(self.roleInfo.userState) == 0 then
	-- elseif tonumber(self.roleInfo.userState) == 1 then
	-- 	-- 暗
	-- elseif tonumber(self.roleInfo.userState) == 2 then
	-- 	-- 击杀
	-- end

	local Button_kaizhan = ccui.Helper:seekWidgetByName(root, "Button_kaizhan")
    local Panel_12 = ccui.Helper:seekWidgetByName(root, "Panel_12")
	Button_kaizhan:setVisible(false)
	Panel_12:setVisible(false)
	--0报名1备战2战斗3休战
	if tonumber(_ED.union_fight_state) == 2 and self.chooseCamp == 1 then
		Button_kaizhan:setVisible(true)
	end
	if tonumber(_ED.union_fight_state) == 1 and self.chooseCamp == 0 then
		if tonumber(_ED.union.user_union_info.union_post) == 1 or 
			tonumber(_ED.union.user_union_info.union_post) == 2 then
			Panel_12:setVisible(true)
		end
	end
	if tonumber(self.roleInfo.userState) == 2 then
		Button_kaizhan:setVisible(false)
		Panel_12:setVisible(false)
	end
end

function UnionFightRoleInfo:onInit()
	local csbUnion = csb.createNode("legion/legion_pve_xinxi.csb")
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

	self:updateDraw()

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
    {
        terminal_name = "union_fight_role_info_return", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kaizhan"), nil, 
    {
        terminal_name = "union_fight_role_info_fighting", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_0"), nil, 
    {
        terminal_name = "union_fight_role_info_change_role", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
    {
        terminal_name = "union_fight_choose_cell_give_up", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
    state_machine.unlock("union_fight_role_info_open")
end

function UnionFightRoleInfo:onEnterTransitionFinish()
end

function UnionFightRoleInfo:init(params)
	self.chooseCamp = params[1]
	self.roleInfo = params[2]
	self.mapIndex = params[3]
	self.formationIndex = params[4]
	self:onInit()
	return self
end

function UnionFightRoleInfo:onExit()
	state_machine.remove("union_fight_role_info_return")
	state_machine.remove("union_fight_role_info_fighting")
	state_machine.remove("union_fight_role_info_change_role")
	state_machine.remove("union_fight_choose_cell_give_up")
end
