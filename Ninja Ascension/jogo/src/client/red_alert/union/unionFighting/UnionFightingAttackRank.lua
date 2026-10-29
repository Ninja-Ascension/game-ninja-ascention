UnionFightingAttackRank = class("UnionFightingAttackRankClass", Window)

local union_fighting_attack_rank_open_terminal = {
	_name = "union_fighting_attack_rank_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(UnionFightingAttackRank:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_attack_rank_close_terminal = {
	_name = "union_fighting_attack_rank_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionFightingAttackRankClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_attack_rank_open_terminal)
state_machine.add(union_fighting_attack_rank_close_terminal)
state_machine.init()

function UnionFightingAttackRank:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	self._choose_city_id = 0

	self.listview = nil
	self.listview_poy = 0

	app.load("client.red_alert.cells.union.union_fight_attack_rank_cell")
	app.load("client.red_alert.union.unionFighting.UnionFightingAttackCost")
	app.load("client.red_alert.union.unionFighting.UnionFightingRule")
end

function UnionFightingAttackRank:onUpdateDraw( ... )
    local root = self.roots[1]
    local ListView_26 = ccui.Helper:seekWidgetByName(root, "ListView_26")
    ListView_26:removeAllItems()

    if _ED.union_fight_city_attack_rank_list ~= nil then
	    local myCitys = {}
	    local result = {}
	    for k,v in pairs(_ED.union_fight_city_attack_rank_list) do
	    	 table.insert(result, v)
	   	end
	    local function sortFunc( a, b )
	        return tonumber(a.cost) > tonumber(b.cost)
	    end
	    table.sort(result, sortFunc)

	    for k,v in pairs(result) do
	    	if tonumber(v.city_id) == tonumber(self._choose_city_id) then
	    		table.remove(result, k)
	    	else
	    		if tonumber(v.join_cost_union_id) == tonumber(_ED.union.union_info.union_id) then
		    		table.insert(myCitys, v)
		    	end
	    	end
	    end
	    local index = 0
		
		if tonumber(self._choose_city_id) > 0 then
			local info = _ED.union_fight_city_attack_rank_list[""..self._choose_city_id]
	        index = index + 1
			local cell = state_machine.excute("union_fight_attack_rank_cell_create", 0, {info, index})
	        ListView_26:addChild(cell)
	    end

	    for k,v in pairs(myCitys) do
	        index = index + 1
			local cell = state_machine.excute("union_fight_attack_rank_cell_create", 0, {v, index})
	        ListView_26:addChild(cell)
	    end

        for k,v in pairs(result) do
        	local isAdd = true
        	for k1,v1 in pairs(myCitys) do
        		if tonumber(v1.city_id) == tonumber(v.city_id) then
        			isAdd = false
        		end
        	end
        	if isAdd == true then
	    		index = index + 1
	            local cell = state_machine.excute("union_fight_attack_rank_cell_create", 0, {v, index})
	            ListView_26:addChild(cell)
	        end
	    end
        ListView_26:requestRefreshView()
        self.listview = ListView_26
        self.listview_poy = ListView_26:getInnerContainer():getPositionY()
    end
end

function UnionFightingAttackRank:onUpdate( dt )
	if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function UnionFightingAttackRank:onInit(params)
	local csbNode = csb.createNode(config_csb.big_map.map_legion_pk_attack)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "union_fighting_attack_rank_close", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pk_gem_p"), nil, 
    {
        terminal_name = "union_fighting_rule_open", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, 
    nil, 0)

    self:onUpdateDraw()
end

function UnionFightingAttackRank:onEnterTransitionFinish()
end

function UnionFightingAttackRank:init(params)
	self._choose_city_id = params[1]
    self:onInit()
	return self
end

function UnionFightingAttackRank:onExit()

end
