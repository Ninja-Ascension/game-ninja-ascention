-- ----------------------------------------------------------------------------------------------------
-- 说明：回收界面装备重生界面
-------------------------------------------------------------------------------------------------------
EquipChooseForReborn = class("EquipChooseForRebornClass", Window)
	
function EquipChooseForReborn:ctor()
    self.super:ctor()
	
	self.roots = {}
    
    -- Initialize EquipChooseForReborn page state machine.
    local function init_equip_choose_for_reborn_terminal()
		-- 关闭
		local equip_choose_reborn_close_terminal = {
            _name = "equip_choose_reborn_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				state_machine.excute("menu_show_event", 0, "menu_show_event.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equip_choose_reborn_close_terminal)
        state_machine.init()
    end
    
    init_equip_choose_for_reborn_terminal()
end

local function sortEquipsForRebornFunc()
	local function chooseEquip()
		local list = {}
		local j = 1
		for i, v in pairs(_ED.user_equiment) do
			local shipId = v.user_equiment_id
			local shipData = dms.element(dms["equipment_mould"], v.user_equiment_template)
			local shipQuality = dms.atoi(shipData, equipment_mould.grow_level)
			local equipType = 0
			if dms.atoi(shipData, equipment_mould.equipment_type) <= 3 then
				equipType = 2
			end
			--强化，精炼，升星
			if equipType == 2 and (zstring.tonumber(v.ship_id) == 0) 
				and (zstring.tonumber(v.user_equiment_grade) > 1 or zstring.tonumber(v.equiment_refine_level) > 0 or v.add_attribute ~= "")
				then
				list[j] = v
				j = j+1
			end
		end
		return list
	end
	
	local function compare(a, b)
		local a_quality = dms.int(dms["equipment_mould"], a.user_equiment_template, equipment_mould.grow_level)
		local b_quality = dms.int(dms["equipment_mould"], b.user_equiment_template, equipment_mould.grow_level)
		if a_quality > b_quality then
			return false
		elseif a_quality == b_quality then
			if tonumber(a.user_equiment_grade) > tonumber(b.user_equiment_grade) then
				return false
			end
		end
		return true
	end
	
	local function sortList(list)
		local count = #list
		
		for i=1, count do
			for j=1, count-i do
				if compare(list[j], list[j+1]) == false then
					list[j], list[j+1] = list[j+1], list[j]
				end
			end
		end
		return list
	end
	return sortList(chooseEquip())
end

function EquipChooseForReborn.loading(texture)
	local myListView = EquipChooseForReborn.myListView
	if myListView ~= nil then
		local cell = EquipChooseForRebornCell:createCell()
		cell:init(EquipChooseForReborn.sortEquipsForReborn[EquipChooseForReborn.asyncIndex])
		myListView:addChild(cell)
		EquipChooseForReborn.asyncIndex = EquipChooseForReborn.asyncIndex + 1
		myListView:requestRefreshView()
	end
end

function EquipChooseForReborn:onUpdateDraw()
	local ListView_bwcs = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_bwcs")
	app.load("client.cells.equip.equip_choose_for_reborn_cell")
	-- for i,v in ipairs(self:sortEquipsForReborn()) do
	-- 	local cellList = EquipChooseForRebornCell:createCell()
	-- 	cellList:init(v)
	-- 	ListView_bwcs:addChild(cellList)
	-- end
	ListView_bwcs:removeAllItems()
	EquipChooseForReborn.myListView = ListView_bwcs
	EquipChooseForReborn.sortEquipsForReborn = sortEquipsForRebornFunc()
	EquipChooseForReborn.asyncIndex = 1
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		app.load("client.cells.utils.multiple_list_view_cell")
		local preMultipleCell = nil
		local multipleCell = nil
		for i,v in pairs(EquipChooseForReborn.sortEquipsForReborn) do
			local cell = EquipChooseForRebornCell:createCell()
			cell:init(v)
			if multipleCell == nil then
				multipleCell = MultipleListViewCell:createCell()
				multipleCell:init(ListView_bwcs, EquipChooseForRebornCell.__size)
				ListView_bwcs:addChild(multipleCell)
				multipleCell.prev = preMultipleCell
				if preMultipleCell ~= nil then
					preMultipleCell.next = multipleCell
				end
			end
			multipleCell:addNode(cell)
			if multipleCell.child2 ~= nil then
				preMultipleCell = multipleCell
				multipleCell = nil
			end
		end
	else
		for i, v in ipairs(EquipChooseForReborn.sortEquipsForReborn) do
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
		end
	end
end

function EquipChooseForReborn:onEnterTransitionFinish()
	local csbEquipChooseForReborn = csb.createNode("refinery/refinery_zhuangbei_cs_xz.csb")
	self:addChild(csbEquipChooseForReborn)
	local root = csbEquipChooseForReborn:getChildByName("root")
	table.insert(self.roots, root)
	
	state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
	self:onUpdateDraw()
	
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bwcs_fanhui"), nil, 
	{
		terminal_name = "equip_choose_reborn_close",
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
end

function EquipChooseForReborn:onExit()
	EquipChooseForReborn.myListView = nil
	EquipChooseForReborn.asyncIndex = 1
	state_machine.remove("equip_choose_reborn_close")
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end