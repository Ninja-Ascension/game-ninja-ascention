----------------------------------------------------------------------------------------------------
-- 说明：武将界面滑动层
-- 创建时间
-- 作者：肖雄
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
HeroIconListView = class("HeroIconListViewClass", Window)

--打开界面
local hero_icon_listview_open_terminal = {
	_name = "hero_icon_listview_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	if fwin:find("HeroIconListViewClass") ~= nil then
    		state_machine.excute("hero_icon_list_view_sort", 0, "hero_icon_list_view_sort.")
    		fwin:find("HeroIconListViewClass"):setVisible(true)
 			return
    	end
    	state_machine.lock("hero_icon_listview_open")
		local cell = HeroIconListView:new()
		cell:init(params)
		fwin:open(cell,fwin._viewdialog)
		return true
	end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local hero_icon_listview_close_terminal = {
	_name = "hero_icon_listview_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:close(fwin:find("HeroIconListViewClass"))
		return true
	end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_icon_listview_open_terminal)
state_machine.add(hero_icon_listview_close_terminal)
state_machine.init()
function HeroIconListView:ctor()
    self.super:ctor()
	self.roots = {}
	
	self.tSortedHeroes = {}
	self.listview = nil
	self.listview_innerY = nil
	self.lastcell = nil
	self.pageshowindex = 1
	self.ship = nil
	self.showFormation = false
	self.heronumber = nil
    local function init_hero_icon_list_view_terminal()
		-- 武将排序
		local hero_icon_list_view_sort_terminal = {
			_name = "hero_icon_list_view_sort",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance.tSortedHeroes = instance:getSortedHeroes()
				return true
			end,
            _terminal = nil,
            _terminals = nil
		}
		--设置亮框
		local hero_listview_set_index_terminal = {
			_name = "hero_listview_set_index",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local ship = params._datas.ship
				local cell = params._datas.cell
				if tonumber(ship.captain_type) == 0 and self.pageshowindex == 2 then
					TipDlg.drawTextDailog(_string_piece_info[383])
					return
				end 
				if tonumber(ship.captain_type) == 2 and self.pageshowindex == 3 then
					TipDlg.drawTextDailog(_string_piece_info[384])
					return
				end
				if ship == nil then
					return
				end
				local next_terminal_name = params._datas.next_terminal_name
				state_machine.excute(next_terminal_name,0,ship)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					if next_terminal_name == "formation_set_ship" then
						instance:setIndex(cell)
					elseif next_terminal_name == "hero_develop_page_strength_to_update_ship" then
						state_machine.excute("hero_develop_page_strength_to_highlighted",0,cell)
					elseif next_terminal_name == "sm_equipment_qianghua_update_ship" then
						state_machine.excute("sm_equipment_qianghua_to_highlighted",0,cell)
					end
				else
					instance:setIndex(cell)
				end
				return true
			end,
            _terminal = nil,
            _terminals = nil
		}
		
		--第一次进入时设置亮框和listview位置
		local hero_icon_listview_first_set_index_terminal = {
            _name = "hero_icon_listview_first_set_index",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:firstIconIndex(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--移除升级用到的材料英雄
		local hero_icon_list_view_remove_cell_terminal = {
			_name = "hero_icon_list_view_remove_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
        		for i, v in pairs(params) do
					instance:removeCellByShipId(v.ship_id)
				end	
				state_machine.excute("hero_icon_list_view_sort",0,"")
				return true
			end,
            _terminal = nil,
            _terminals = nil
		}
		--部分英雄特殊情况下不能切换，比如在升级界面时，
		--主角不能被切换，在突破界面时，经验人不能切换，得到管理页当前页
		local hero_icon_list_view_get_developpage_terminal = {
			_name = "hero_icon_list_view_get_developpage",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	instance.pageshowindex = params
				return true
			end,
            _terminal = nil,
            _terminals = nil
		}
		--锁屏
		local hero_icon_list_view_lock_terminal = {
			_name = "hero_icon_list_view_lock",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	-- print("========================锁住了")
            	ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_list_hero"):setVisible(true)
				return true
			end,
            _terminal = nil,
            _terminals = nil
		}

				--解锁
		local hero_icon_list_view_unlock_terminal = {
			_name = "hero_icon_list_view_unlock",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- print("========================解锁")
				ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_list_hero"):setVisible(false)
			
				return true
			end,
            _terminal = nil,
            _terminals = nil
		}
		--阵容翻页后设置的index
		local hero_icon_listview_set_index_terminal = {
            _name = "hero_icon_listview_set_index",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:setIconIndex(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        		--替换之后头像变更
		local hero_icon_listview_update_all_icon_terminal = {
            _name = "hero_icon_listview_update_all_icon",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if params == nil then
            		instance:onUpdateAllIcon(instance.ship, true)
            	elseif params == 1 then
            		instance:onUpdateAllIcon(instance.lastcell.ship, true)
            	else
            		instance:onUpdateAllIcon(params)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --图标推送刷新
		local hero_icon_listview_icon_push_updata_terminal = {
            _name = "hero_icon_listview_icon_push_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local items = instance.listview:getItems()
            	for i , v in pairs(items) do
            		state_machine.excute("hero_icon_list_cell_formation_hero_icon_push_updata",0,v)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(hero_icon_list_view_sort_terminal)
		state_machine.add(hero_listview_set_index_terminal)
		state_machine.add(hero_icon_list_view_remove_cell_terminal)
		state_machine.add(hero_icon_listview_first_set_index_terminal)
		state_machine.add(hero_icon_list_view_get_developpage_terminal)
		state_machine.add(hero_icon_list_view_lock_terminal)
		state_machine.add(hero_icon_list_view_unlock_terminal)
		state_machine.add(hero_icon_listview_set_index_terminal)
		state_machine.add(hero_icon_listview_update_all_icon_terminal)
		state_machine.add(hero_icon_listview_icon_push_updata_terminal)
        state_machine.init()
    end
    
    init_hero_icon_list_view_terminal()
end
function HeroIconListView:onUpdateAllIcon(ship, isShowFormation)
	local isShow = true
	if isShowFormation == true then
		isShow = false
	end
	self.tSortedHeroes = self:getSortedHeroes(isShow)
	self:createHeroIconList()
	if isShowFormation == true then
		self:setIconIndex(ship)
		self.listview:requestRefreshView()
	else
		self:setIconIndex(ship)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			self.listview:requestRefreshView()
		end
	end
end
function HeroIconListView:setIconIndex(ship)
	--todo 设置的底框 和listvew位置
	local items = self.listview:getItems()
	local index = 1
	local itemsnumber = #items
	local height = 0
	for i,v in pairs(items) do
		if v.ship == ship then
			v:setSelected(true)
			v.ishow = true
			self.lastcell = v
			index = i 
			-- height = v:getContentSize().height
		else
			v:setSelected(false)
		end
	end
	-- self.listview:getInnerContainer():setPositionY((index-1)*height)
end
function HeroIconListView:firstIconIndex(ship)
	--todo 设置第一次的底框 和listvew位置
	local items = self.listview:getItems()
	local index = 1
	local itemsnumber = #items
	local height = 0
	for i,v in pairs(items) do
		if v.ship == ship then
			v:setSelected(true)
			v.ishow = true
			self.lastcell = v
			index = i 
			height = v:getContentSize().height
			break
		end
	end
	self.listview:getInnerContainer():setPositionY((index-1)*height)
end

function HeroIconListView:removeCellByShipId(ship_id)
	local items = self.listview:getItems()
	for i, v in pairs(items) do
		if v.ship ~= nil then
			if v.ship.ship_id == ship_id then
				self.listview:removeItem(self.listview:getIndex(v))
			end
		end
	end
	self.listview:requestRefreshView()
end
function HeroIconListView:onUpdate(dt)
	if self.listview ~= nil and self.listview_innerY ~= nil then
		local size = self.listview:getContentSize()
		local posY = self.listview:getInnerContainer():getPositionY()
		if self.listview_innerY == posY then
			return
		end
		self.listview_innerY = posY
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

function HeroIconListView:getSortedHeroes(new_formation)
	local function fightingCapacity(a,b)
		local al = tonumber(a.hero_fight)
		local bl = tonumber(b.hero_fight)
		local result = false
		if al > bl then
			result = true
		end
		return result 
	end
	-- debug.print_r(self.ship)
	-- print("==========",self.enter_type,zstring.tonumber(self.ship.formation_index))
	-- if self.enter_type ~= "pack" then
	-- 	showFormation = true
	-- end
	-- print("============",self.ship.formation_index)
	if new_formation == true then
		self.showFormation = true
	else
		if zstring.tonumber(self.ship.formation_index) > 0  then
			self.showFormation = true
		else
			self.showFormation = false
		end
	end
	 -- print("=============",showFormation)
	local tSortedHeroes = {}
	-- 上阵武将数组
	local arrBusyHeroes = {}
	-- 各星级武将数组
	local arrStarLevelHeroesWhite = {}--白
	local arrStarLevelHeroesGreen = {}--绿
	local arrStarLevelHeroesKohlrabiblue= {}--蓝
	local arrStarLevelHeroesPurple = {}--紫
	local arrStarLevelHeroesOrange = {}--橙
	local arrStarLevelHeroesRed = {}--红
	local arrStarLevelHeroesGold = {}--金
	local arrStarLevelHeroesExp = {}--经验人
	-- 主角放在第一位
	for i, ship in pairs(_ED.user_ship) do
		if ship.ship_id ~= nil then
			local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
			
			-- if dms.atoi(shipData, ship_mould.captain_type) == 0 then
			-- 	tSortedHeroes[1] = ship
			-- else

			if zstring.tonumber(ship.formation_index) > 0 then
				table.insert(arrBusyHeroes, ship)
			elseif dms.atoi(shipData, ship_mould.captain_type) == 2 then
				table.insert(arrStarLevelHeroesExp, ship)
			elseif dms.atoi(shipData, ship_mould.captain_type) == 3 then 
				--宠物
			else
				if dms.atoi(shipData, ship_mould.ship_type) == 0 then
					table.insert(arrStarLevelHeroesWhite, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
					table.insert(arrStarLevelHeroesGreen, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
					table.insert(arrStarLevelHeroesKohlrabiblue, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
					table.insert(arrStarLevelHeroesPurple, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
					table.insert(arrStarLevelHeroesOrange, ship)
				elseif dms.atoi(shipData, ship_mould.ship_type) == 5 then
					table.insert(arrStarLevelHeroesRed, ship)
				elseif dms.atoi(shipData,ship_mould.ship_type) == 6 then
					table.insert(arrStarLevelHeroesGold, ship)			
				end 
			end
		end
	end

	table.sort(arrBusyHeroes, fightingCapacity)
	table.sort(arrStarLevelHeroesWhite, fightingCapacity)
	table.sort(arrStarLevelHeroesGreen, fightingCapacity)
	table.sort(arrStarLevelHeroesKohlrabiblue, fightingCapacity)
	table.sort(arrStarLevelHeroesPurple, fightingCapacity)
	table.sort(arrStarLevelHeroesOrange, fightingCapacity)
	table.sort(arrStarLevelHeroesRed, fightingCapacity)
	table.sort(arrStarLevelHeroesGold, fightingCapacity)
	table.sort(arrStarLevelHeroesExp, fightingCapacity)
	-- 把已排序好的上阵武将加入到 武将排序数组中
	local hero_number = 0
	if self.showFormation == true then
		local table_main = {}
		local table_ohter = {}
		for i=1, #arrBusyHeroes do
			if tonumber(arrBusyHeroes[i].captain_type) == 0 then
				table.insert(table_main, arrBusyHeroes[i])
			else
				table.insert(table_ohter, arrBusyHeroes[i])
			end
		end
		for i=1, #table_main do
			table.insert(tSortedHeroes, table_main[i])
			hero_number = hero_number + 1
		end
		for i=1, #table_ohter do
			table.insert(tSortedHeroes, table_ohter[i])
			hero_number = hero_number + 1
		end		
	else
		for i=1, #arrStarLevelHeroesGold do
			table.insert(tSortedHeroes, arrStarLevelHeroesGold[i])
			hero_number = hero_number + 1
		end	
		for i=1, #arrStarLevelHeroesRed do
			table.insert(tSortedHeroes, arrStarLevelHeroesRed[i])
			hero_number = hero_number + 1
		end
		for i=1, #arrStarLevelHeroesOrange do
			table.insert(tSortedHeroes, arrStarLevelHeroesOrange[i])
			hero_number = hero_number + 1
		end
		for i=1, #arrStarLevelHeroesPurple do
			table.insert(tSortedHeroes, arrStarLevelHeroesPurple[i])
			hero_number = hero_number + 1
		end
		for i=1, #arrStarLevelHeroesKohlrabiblue do
			table.insert(tSortedHeroes, arrStarLevelHeroesKohlrabiblue[i])
			hero_number = hero_number + 1
		end
		for i=1, #arrStarLevelHeroesGreen do
			table.insert(tSortedHeroes, arrStarLevelHeroesGreen[i])
			hero_number = hero_number + 1
		end
		for i=1, #arrStarLevelHeroesWhite do
			table.insert(tSortedHeroes, arrStarLevelHeroesWhite[i])
			hero_number = hero_number + 1
		end
		for i=1, #arrStarLevelHeroesExp do
			table.insert(tSortedHeroes, arrStarLevelHeroesExp[i])
			hero_number = hero_number + 1
		end
	end
	self.heronumber = hero_number
	-- print("============",self.heronumber)
	return tSortedHeroes
end

function HeroIconListView:setIndex(cell)
	if self.lastcell ~= nil and self.lastcell.setSelected ~= nil then
		self.lastcell.ishow = false
		self.lastcell:setSelected(false)
	end
	cell:setSelected(true)
	cell.ishow = true
	self.lastcell = cell
end

function HeroIconListView:initDraw()
	self:createHeroIconList()
end

function HeroIconListView:createHeroIconList()
	local root = self.roots[1]
	local listview = ccui.Helper:seekWidgetByName(root,"ListView_icon_list")
	listview:removeAllItems()
	self.listview = listview
	app.load("client.cells.ship.hero_icon_list_cell")
	if self.showFormation == true then
		local info = {}
		local old_info = {}
		for k,v in pairs(_ED.user_formetion_status) do
			if tonumber(v) > 0 then
				table.insert(info, v)
			else
				table.insert(old_info, v)
			end
		end
		for k,v in pairs(old_info) do
			table.insert(info, v)
		end

		for i= 1,6 do
			local cell = nil
			local ship = _ED.user_ship[""..info[i]]
			if i <= self.heronumber then
				cell = HeroIconListCell:createCell()
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					cell:init(ship, i,false,nil,1)
				else
					cell:init(ship, i,self.showFormation)
				end
			elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
					cell = HeroIconListCell:createCell()
					cell:init(nil,i,self.showFormation)
				end
			else
				cell = HeroIconListCell:createCell()
				cell:init(nil,i,self.showFormation)
			end
			if cell ~= nil then
				listview:addChild(cell)	
			end
		end
	else
		for i,v in pairs(self.tSortedHeroes) do
			local cell = HeroIconListCell:createCell()
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				cell:init(v, i,false,nil,1)
			else
				cell:init(v, i,self.showFormation)
			end
			listview:addChild(cell)	
		end
	end
	self.listview_innerY = listview:getInnerContainer():getPositionY()
end

function HeroIconListView:onEnterTransitionFinish()
    local csbHeroIconListView = csb.createNode("packs/HeroStorage/generals_role_icon.csb")
	local root = csbHeroIconListView:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbHeroIconListView)

	state_machine.excute("hero_icon_list_view_sort", 0, "hero_icon_list_view_sort.")

	self:initDraw()
	-- iphone刘海适配
	local Panel_box_caiqie = ccui.Helper:seekWidgetByName(root, "Panel_box_caiqie")
	if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and isIphoneX() then 
		if Panel_box_caiqie then 
			Panel_box_caiqie:setPositionX(Panel_box_caiqie:getPositionX()+80)
		end
	end
	
	state_machine.unlock("hero_icon_listview_open")
end
function HeroIconListView:init(ship)
	self.ship = ship
end

function HeroIconListView:close( ... )
	self.listview:removeAllItems()
end
function HeroIconListView:onExit()
	state_machine.remove("hero_icon_list_view_sort_terminal")
	state_machine.remove("hero_listview_set_index")
	state_machine.remove("hero_icon_list_view_remove_cell")
	state_machine.remove("hero_icon_listview_first_set_index")
	state_machine.remove("hero_icon_list_view_get_developpage")
	state_machine.remove("hero_icon_list_view_lock")
	state_machine.remove("hero_icon_list_view_unlock")
	state_machine.remove("hero_icon_listview_set_index")
	state_machine.remove("hero_icon_listview_update_all_icon")
	state_machine.remove("hero_icon_listview_icon_push_updata")
end
