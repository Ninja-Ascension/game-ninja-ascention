UnionFightFormation = class("UnionFightFormationClass", Window)

local union_fight_formation_open_terminal = {
	_name = "union_fight_formation_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("UnionFightFormationClass")
		if window ~= nil and window:isVisible() == true then
			return true
		end
        state_machine.lock("union_fight_formation_open")
		fwin:open(UnionFightFormation:new():init(params), fwin._view)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fight_formation_close_terminal = {
	_name = "union_fight_formation_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local window = fwin:find("UnionFightFormationClass")
		if window ~= nil then
			fwin:close(window)
		end	
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fight_formation_open_terminal)
state_machine.add(union_fight_formation_close_terminal)
state_machine.init()

function UnionFightFormation:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.mapInfo = nil
	self.chooseCamp = 0

    local function init_union_fight_formation_terminal()
		local union_fight_formation_return_terminal = {
            _name = "union_fight_formation_return",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_fight_formation_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        local union_fight_formation_role_choose_terminal = {
            _name = "union_fight_formation_role_choose",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local formationIndex = params._datas.selectIndex
				local mapIndex = instance.mapInfo.mapId
				local roleInfo = instance.mapInfo.defenders[""..formationIndex]
				if roleInfo == nil then
					state_machine.excute("union_fight_choose_open", 0, {mapIndex, roleInfo, instance.chooseCamp, formationIndex})
				else
	                state_machine.excute("union_fight_role_info_open", 0, 
	                	{instance.chooseCamp, roleInfo, mapIndex, formationIndex})
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_formation_update_terminal = {
            _name = "union_fight_formation_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local campState = params[1]
				local mapInfo = params[2]
				if instance ~= nil and instance.roots ~= nil then
					if tonumber(instance.chooseCamp) == tonumber(campState) and tonumber(mapInfo.mapId) == tonumber(instance.mapInfo.mapId) then
						instance.mapInfo = mapInfo
						instance:updateDraw()
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(union_fight_formation_return_terminal)
		state_machine.add(union_fight_formation_role_choose_terminal)
		state_machine.add(union_fight_formation_update_terminal)
        state_machine.init()
    end
	
    init_union_fight_formation_terminal()
end

function UnionFightFormation:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local mapData = dms.element(dms["union_fight_campsite_mould"], self.mapInfo.mapId)
	local score = dms.atos(mapData, union_fight_campsite_mould.reward_score)
	local attribute_desc = dms.atos(mapData, union_fight_campsite_mould.attribute_desc)
	local reward_desc = dms.atos(mapData, union_fight_campsite_mould.reward_desc)
	local campsite_name = dms.atos(mapData, union_fight_campsite_mould.campsite_name)
	local fight_formations = zstring.split(dms.atos(mapData, union_fight_campsite_mould.fight_formation), "|")
	local pic_index = dms.atos(mapData, union_fight_campsite_mould.pic_index)

	local Text_15 = ccui.Helper:seekWidgetByName(root, "Text_15")
	local Text_jifen_1 = ccui.Helper:seekWidgetByName(root, "Text_jifen_1")
    local Text_shouwei = ccui.Helper:seekWidgetByName(root, "Text_shouwei")
    local Text_xiaoguo = ccui.Helper:seekWidgetByName(root, "Text_xiaoguo")
    local Text_jiangli = ccui.Helper:seekWidgetByName(root, "Text_jiangli")
    local Panel_16 = ccui.Helper:seekWidgetByName(root, "Panel_16")
    Panel_16:setBackGroundImage(string.format("images/ui/play/legion/jianchuan_%d.png", pic_index))
    
    local max_formation_count = fight_formations[1]
    Text_15:setString(campsite_name)
    Text_jifen_1:setString(""..score)
    Text_xiaoguo:setString(""..attribute_desc)
    Text_jiangli:setString(""..reward_desc)
    Text_shouwei:setString(self.mapInfo.defenderCount.."/"..max_formation_count)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local ListView_10 = ccui.Helper:seekWidgetByName(root, "ListView_10")
		ListView_10:removeAllItems()
		for i=1,max_formation_count do
			local userInfo = self.mapInfo.defenders[""..i]
    		local cell = UnionFightRoleCell:createCell():init(userInfo, i, self.mapInfo.mapId, self.chooseCamp)
    		ListView_10:addChild(cell)
	    end
	    ListView_10:requestRefreshView()
	else
	    for i=1,9 do
	    	local panel = ccui.Helper:seekWidgetByName(root, "Panel_ro_q_"..i)
	    	panel:removeAllChildren(true)
	    	panel:setVisible(false)
	    	if i <= tonumber(max_formation_count) then
	    		panel:setVisible(true)
				local userInfo = self.mapInfo.defenders[""..i]
	    		local cell = UnionFightRoleCell:createCell():init(userInfo, i, self.mapInfo.mapId, self.chooseCamp)
	    		panel:addChild(cell)
		    end
	    end
	end
end

function UnionFightFormation:onInit()
	local csbUnion = csb.createNode("legion/legion_pve_legion.csb")
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	    local action = csb.createTimeline("legion/legion_pve_legion.csb")
	    table.insert(self.actions, action)
	    root:runAction(action)
	    action:play("arrow_z", true)
	end
    
	self:updateDraw()

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "union_fight_formation_return", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		for i=1,9 do
	    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_ro_q_"..i), nil, 
		    {
		        terminal_name = "union_fight_formation_role_choose", 
		        terminal_state = 0,
		        selectIndex = i,
		        isPressedActionEnabled = true
		    }, 
		    nil, 0)
		end
	end
	
    state_machine.unlock("union_fight_formation_open")
end

function UnionFightFormation:onEnterTransitionFinish()
end

function UnionFightFormation:init(params)
	self.mapInfo = params[1]
	self.chooseCamp = params[2]
	self:onInit()
	return self
end

function UnionFightFormation:onExit()
	state_machine.remove("union_fight_formation_return")
	state_machine.remove("union_fight_formation_role_choose")
	state_machine.remove("union_fight_formation_update")
end
