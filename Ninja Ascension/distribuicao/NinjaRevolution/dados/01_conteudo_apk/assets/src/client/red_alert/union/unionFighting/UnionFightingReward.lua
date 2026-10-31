UnionFightingReward = class("UnionFightingRewardClass", Window)

local union_fighting_reward_open_terminal = {
	_name = "union_fighting_reward_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(UnionFightingReward:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_reward_close_terminal = {
	_name = "union_fighting_reward_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionFightingRewardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_reward_open_terminal)
state_machine.add(union_fighting_reward_close_terminal)
state_machine.init()

function UnionFightingReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.listview = nil
	self.listview_poy = 0

	app.load("client.red_alert.cells.union.union_fight_reward_cell")
	app.load("client.red_alert.cells.all_resources_cell")
end

function UnionFightingReward:onUpdateDraw( ... )
    local root = self.roots[1]
    local ListView_rec = ccui.Helper:seekWidgetByName(root, "ListView_rec")
    ListView_rec:removeAllItems()

    if _ED.union_stronghold_reward_list ~= nil then
	    local states = {}
	    if _ED.union.user_union_info.union_city_reward_info ~= nil 
	        and _ED.union.user_union_info.union_city_reward_info ~= ""
	        and _ED.union.user_union_info.union_city_reward_info ~= "-1" then
	        states = zstring.split(_ED.union.user_union_info.union_city_reward_info, ",")
	    end
	    local result1 = {}
	    local result2 = {}
        for k,reward_info in pairs(_ED.union_stronghold_reward_list) do
        	local isCanReward = true
        	for index, city_id in pairs(states) do
        		if tonumber(city_id) == tonumber(reward_info.city_id) then
        			isCanReward = false
        		end
        	end
        	if isCanReward == true then
        		table.insert(result1, reward_info)
        	else
        		table.insert(result2, reward_info)
        	end
        end

        local index = 0
        for k,v in pairs(result1) do
            local city_type = dms.int(dms[config_res.campaign.nationalwar.warfare_map_mould], v.city_id, warfare_map_mould.city_type)
            if city_type ~= 4 then
            	index = index + 1
                local cell = state_machine.excute("union_fight_reward_cell_create", 0, {v, index})
        		ListView_rec:addChild(cell)
            end
        end
        for k,v in pairs(result2) do
            local city_type = dms.int(dms[config_res.campaign.nationalwar.warfare_map_mould], v.city_id, warfare_map_mould.city_type)
            if city_type ~= 4 then
            	index = index + 1
                local cell = state_machine.excute("union_fight_reward_cell_create", 0, {v, index})
        		ListView_rec:addChild(cell)
            end
        end
    end

    ListView_rec:requestRefreshView()
    self.listview = ListView_rec
    self.listview_poy = ListView_rec:getInnerContainer():getPositionY()
end

function UnionFightingReward:onUpdate( dt )
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

function UnionFightingReward:onInit(params)
	local csbNode = csb.createNode(config_csb.big_map.map_legion_build_reward)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "union_fighting_reward_close", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, 
    nil, 0)

    self:onUpdateDraw()
end

function UnionFightingReward:onEnterTransitionFinish()
end

function UnionFightingReward:init(params)
    self:onInit()
	return self
end

function UnionFightingReward:onExit()

end
