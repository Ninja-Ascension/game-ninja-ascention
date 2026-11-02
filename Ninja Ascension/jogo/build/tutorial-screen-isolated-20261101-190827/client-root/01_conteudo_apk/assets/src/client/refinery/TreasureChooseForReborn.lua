-- ----------------------------------------------------------------------------------------------------
-- 说明：回收界面宝物重生界面
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
TreasureChooseForReborn = class("TreasureChooseForRebornClass", Window)
	
function TreasureChooseForReborn:ctor()
    self.super:ctor()
	
	self.roots = {}
    
    -- Initialize TreasureChooseForReborn page state machine.
    local function init_TreasureChooseForReborn_terminal()
		-- 关闭
		local treasure_choose_reborn_close_terminal = {
            _name = "treasure_choose_reborn_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then			--龙虎门项目控制
				else
					state_machine.excute("menu_show_event", 0, "menu_show_event.")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(treasure_choose_reborn_close_terminal)
        state_machine.init()
    end
    
    init_TreasureChooseForReborn_terminal()
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
			if dms.atoi(shipData, equipment_mould.equipment_type) >=4 and dms.atoi(shipData, equipment_mould.equipment_type) <6 then
				equipType = 2
			end
			if equipType == 2 and tonumber(v.user_equiment_grade) > 1 and (zstring.tonumber(v.ship_id) == 0) then
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

function TreasureChooseForReborn.loading(texture)
	local myListView = TreasureChooseForReborn.myListView
	if myListView ~= nil then
		local cell = TreasureChooseForRebornCell:createCell()
		cell:init(TreasureChooseForReborn.sortEquipsForReborn[TreasureChooseForReborn.asyncIndex])
		myListView:addChild(cell)
		TreasureChooseForReborn.asyncIndex = TreasureChooseForReborn.asyncIndex + 1
		myListView:requestRefreshView()
	end
end

function TreasureChooseForReborn:onUpdateDraw()
	local ListView_bwcs = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_bwcs")
	app.load("client.cells.treasure.treasure_choose_for_reborn_cell")
	-- for i,v in ipairs(self:sortEquipsForReborn()) do
	-- 	local cellList = TreasureChooseForRebornCell:createCell()
	-- 	cellList:init(v)
	-- 	ListView_bwcs:addChild(cellList)
	-- end

	TreasureChooseForReborn.myListView = ListView_bwcs
	TreasureChooseForReborn.sortEquipsForReborn = sortEquipsForRebornFunc()
	TreasureChooseForReborn.asyncIndex = 1
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	for i, v in ipairs(TreasureChooseForReborn.sortEquipsForReborn) do
		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
	end
end

function TreasureChooseForReborn:onEnterTransitionFinish()
	local csbTreasureChooseForReborn = csb.createNode("refinery/refinery_treasure_cs_xz.csb")
	self:addChild(csbTreasureChooseForReborn)
	local root = csbTreasureChooseForReborn:getChildByName("root")
	table.insert(self.roots, root)
	
	state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
	self:onUpdateDraw()
	
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bwcs_fanhui"), nil, 
	{
		terminal_name = "treasure_choose_reborn_close",
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
end

function TreasureChooseForReborn:onExit()
	TreasureChooseForReborn.myListView = nil
	TreasureChooseForReborn.asyncIndex = 1
	state_machine.remove("treasure_choose_reborn_close")
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end