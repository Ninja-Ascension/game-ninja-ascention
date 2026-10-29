--------------------------------------------------------------------------------------------------------------
--  说明：公会副本地图
--------------------------------------------------------------------------------------------------------------
SmUnionPveMap = class("SmUnionPveMapClass", Window)
SmUnionPveMap.__size = nil
function SmUnionPveMap:ctor()
	self.super:ctor()
	self.roots = {}
	app.load("client.l_digital.union.duplicate.SmUnionPveNpc")
	 -- Initialize union rank list cell state machine.
    local function init_sm_union_pve_map_terminal()
        -- local sm_union_pve_map_buy_cell_terminal = {
            -- _name = "sm_union_pve_map_buy_cell",
            -- _init = function (terminal)
               
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
            	-- local cell = params._datas.cell
            	-- local function responseUnionCreateCallback(response)
                    -- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	-- state_machine.excute("sm_union_my_campsite_update_draw_cell", 0, cell.index)
                    -- end
                -- end
                -- local shipData = zstring.split(cell.training_info,",")
           		-- protocol_command.union_ship_train_place_buy.param_list = cell.index
                -- NetworkManager:register(protocol_command.union_ship_train_place_buy.code, nil, nil, nil, instance, responseUnionCreateCallback, false, nil)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		-- state_machine.add(sm_union_pve_map_select_ship_terminal)
        state_machine.init()
    end
    -- call func init union rank list cell state machine.
    init_sm_union_pve_map_terminal()

end

function SmUnionPveMap:updateDraw()
	local root = self.roots[1]
	local sceneMould = dms.element(dms["pve_scene"], 155)
	local npcs = dms.atos(sceneMould, pve_scene.npcs)
	local npcDatas = zstring.split(npcs, ",")
	local current_grade = dms.int(dms["copy_config"],3,copy_config.param)
	local current_index = (#_ED.union_pve_info) >= current_grade and current_grade or (#_ED.union_pve_info)
	if self.number ~= nil and self.number > 0 and self.number < (math.ceil(tonumber(current_index)/4) + 1) then
		local maxNpc = self.number*4
		--所在区间的位置
		local Interval = 4
		--local current_grade = dms.int(dms["copy_config"],3,copy_config.param)
		--local current_index = (#_ED.union_pve_info) >= current_grade and current_grade or (#_ED.union_pve_info)
		if (current_index) > maxNpc then
			Interval = 4
		else
			Interval = 4 - (maxNpc - (current_index))
		end
		--npc位置
		for i=1, 4 do
			local Panel_gh_pve_npc = ccui.Helper:seekWidgetByName(root, "Panel_gh_pve_npc_"..i)
			Panel_gh_pve_npc:setVisible(false)
		end
		local nullIndex = 0
		for i=1, 4 do
			if i<=Interval then
				local npc_op = maxNpc-4+i
				local npc_id = npcDatas[npc_op]
				local Panel_gh_pve_npc = ccui.Helper:seekWidgetByName(root, "Panel_gh_pve_npc_"..i)
				Panel_gh_pve_npc:setVisible(true)
				Panel_gh_pve_npc:removeAllChildren(true)
				local cell = SmUnionPveNpc:createCell()
				cell:init(npc_id,npc_op)
				Panel_gh_pve_npc:addChild(cell)
			else
				local Panel_gh_pve_npc = ccui.Helper:seekWidgetByName(root, "Panel_gh_pve_npc_"..i)
				Panel_gh_pve_npc:setVisible(true)
				Panel_gh_pve_npc:removeAllChildren(true)
				local cell = SmUnionPveNpc:createCell()
				if maxNpc - current_grade < i and maxNpc - current_grade > 0 then
					Panel_gh_pve_npc:setVisible(false)
				else
					Panel_gh_pve_npc:setVisible(true)
				end
				cell:init(0,0)
				Panel_gh_pve_npc:addChild(cell)
			end
		end
	end
end

function SmUnionPveMap:onInit()
	if self.number ~= nil and self.number > 0 then
		local count = math.ceil(self.number%3)
		if count == 0 then
			count = 3
		end

		local csbSmUnionPveMap= csb.createNode(string.format("legion/sm_legion_pve_map_%d.csb", count))
	    local root = csbSmUnionPveMap:getChildByName("root")
	    table.insert(self.roots, root)
		for i=1, 4 do
			local Panel_gh_pve_npc = ccui.Helper:seekWidgetByName(root, "Panel_gh_pve_npc_"..i)
			if Panel_gh_pve_npc._x == nil then
				Panel_gh_pve_npc._x = Panel_gh_pve_npc:getPositionX()
			end
			Panel_gh_pve_npc:setPositionX(Panel_gh_pve_npc._x)
		end
		 
	    self:addChild(csbSmUnionPveMap)
		if SmUnionPveMap.__size == nil then
			SmUnionPveMap.__size = root:getContentSize()
		end	


		
		self:updateDraw()
	end
end

function SmUnionPveMap:onEnterTransitionFinish()

end

function SmUnionPveMap:init(number)
	--local data = dms.int(dms["copy_config"],3,copy_config.param)
	--print("-------data----data---"..data)
	if tonumber(number) > 0 and number ~= nil then
		self.number = tonumber(number)

		self:onInit()
		self:setContentSize(SmUnionPveMap.__size)
		return self
	end
end

function SmUnionPveMap:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmUnionPveMap:unload()
	if self.number ~= nil and self.number > 0 then
		local root = self.roots[1]
		if root == nil then
			return
		end
		local count = math.ceil(self.number%3)
		if count == 0 then
			count = 3
		end

		cacher.freeRef(string.format("legion/sm_legion_pve_map_%d.csb", count), root)
		root:stopAllActions()
		root:removeFromParent(false)
		self.roots = {}
	end
end
function SmUnionPveMap:onExit()
	if self.number ~= nil and self.number > 0 then
		local count = math.ceil(self.number%3)
		if count == 0 then
			count = 3
		end
		cacher.freeRef(string.format("legion/sm_legion_pve_map_%d.csb", count), self.roots[1])
	end
end

function SmUnionPveMap:createCell()
	local cell = SmUnionPveMap:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
