-- ----------------------------------------------------------------------------------------------------
-- 说明：回收界面武将分解界面
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
PetChooseForResolve = class("PetChooseForResolveClass", Window)

function PetChooseForResolve:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}
	self.sortShip = {}
	self.selectMaxCount = 5
	self.selectCount = 0

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0

	app.load("client.cells.pet.pet_choose_list_cell")
    -- Initialize PetChooseForResolve page state machine.
    local function init_pet_choose_terminal()
       local pet_choose_resolve_sort_terminal = {
            _name = "pet_choose_resolve_sort",
            _init = function (terminal) 
                terminal._sortShip = {}
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function chooseHero()
					local list = {}
					local j = 1
					for i, v in pairs(_ED.user_ship) do
						local inRosouce = false
						local captain_type = dms.int(dms["ship_mould"],v.ship_template_id,ship_mould.captain_type)
						if captain_type == 3 then 
							--宠物
							inRosouce = false
						end
						if inRosouce == false then
							local shipId = v.ship_id
							local shipData = dms.element(dms["ship_mould"], v.ship_template_id)
							local shipQuality = dms.atoi(shipData, ship_mould.ship_type)
							local shipRankLevel = dms.atoi(shipData, ship_mould.initial_rank_level) 
							if zstring.tonumber(shipId) ~= _ED.formation_pet_id then
								list[j] = v
								j = j+1
							end
						end
					end
					return list
				end
				
				local function compare(a, b)
					local a_quality = dms.int(dms["ship_mould"], a.ship_template_id, ship_mould.ship_type)
					local b_quality = dms.int(dms["ship_mould"], b.ship_template_id, ship_mould.ship_type)
					if a_quality < b_quality then
						return false
					elseif a_quality == b_quality then
						if tonumber(a.ship_grade) > tonumber(b.ship_grade) then
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
				
				terminal._sortShip = sortList(chooseHero())
				return true
            end,
            _terminal = nil,
            _terminals = nil,
			_sortShip = {}
        }
		
		-- 关闭
		local pet_choose_resolve_page_close_terminal = {
            _name = "pet_choose_resolve_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local pet_resolve_page_check_conut_terminal = {
            _name = "pet_resolve_page_check_conut",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local tempCell = params._datas.cell
				if tempCell.status == false then
					if instance.selectCount >= instance.selectMaxCount then
						TipDlg.drawTextDailog(_string_piece_info[53])
					else
						ccui.Helper:seekWidgetByName(tempCell.roots[1], "Image_10"):setVisible(true)
						tempCell.status = true
						instance.selectCount = instance.selectCount + 1
					end
				else
					ccui.Helper:seekWidgetByName(tempCell.roots[1], "Image_10"):setVisible(false)
					tempCell.status = false
					instance.selectCount = instance.selectCount - 1
				end
				
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_xzwj_2"):setString(instance.selectCount)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(pet_choose_resolve_sort_terminal)
		state_machine.add(pet_choose_resolve_page_close_terminal)
		state_machine.add(pet_resolve_page_check_conut_terminal)
        state_machine.init()
    end
    
    init_pet_choose_terminal()
end

function PetChooseForResolve.loading(texture)
	local myListView = PetChooseForResolve.myListView
	if myListView ~= nil then
		local cell = PetChooseListCell:createCell()
		cell:init(PetChooseForResolve.sortShip[PetChooseForResolve.asyncIndex], 1,  PetChooseForResolve.asyncIndex)
		myListView:addChild(cell)
		PetChooseForResolve.asyncIndex = PetChooseForResolve.asyncIndex + 1
	end
end

function PetChooseForResolve:sortPets()
	local function chooseHero()
		local list = {}
		local j = 1
		for i, v in pairs(_ED.user_ship) do
			local inRosouce = true
			local captain_type = dms.int(dms["ship_mould"],v.ship_template_id,ship_mould.captain_type)
			if captain_type == 3 then 
				--宠物
				inRosouce = false
			end
			if inRosouce == false then
				local shipId = v.ship_id
				local shipData = dms.element(dms["ship_mould"], v.ship_template_id)
				local shipQuality = dms.atoi(shipData, ship_mould.ship_type)
				local shipRankLevel = dms.atoi(shipData, ship_mould.initial_rank_level) 
				if zstring.tonumber(shipId) ~= _ED.formation_pet_id 
					and zstring.tonumber(v.pet_equip_ship_id) == 0
					then
					--驯养和上阵的不能参与
					list[j] = v
					j = j+1
				end
			end
		end
		return list
	end
				
	local function compare(a, b)
		local a_quality = dms.int(dms["ship_mould"], a.ship_template_id, ship_mould.ship_type)
		local b_quality = dms.int(dms["ship_mould"], b.ship_template_id, ship_mould.ship_type)
		if a_quality < b_quality then
			return false
		elseif a_quality == b_quality then
			if tonumber(a.ship_grade) > tonumber(b.ship_grade) then
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
	local petsList = sortList(chooseHero())

	return petsList
end

function PetChooseForResolve:onUpdateDraw()
	self.sortShip = self:sortPets()
	local ListView_1 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	PetChooseForResolve._self = self
	PetChooseForResolve.myListView = ListView_1
	PetChooseForResolve.sortShip = self.sortShip
	PetChooseForResolve.asyncIndex = 1
	
	for i, v in ipairs(self.sortShip) do
		self.loading(nil)
	end
	ListView_1:requestRefreshView()

	self.currentListView = ListView_1
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_xzwj_2"):setString(self.selectCount)
end

function PetChooseForResolve:onUpdate(dt)
	if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
		local size = self.currentListView:getContentSize()
		local posY = self.currentInnerContainer:getPositionY()
		if self.currentInnerContainerPosY == posY then
			return
		end
		self.currentInnerContainerPosY = posY
		local items = self.currentListView:getItems()
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


function PetChooseForResolve:onEnterTransitionFinish()
	local csbHeroChoose = csb.createNode("packs/HeroStorage/generals_sell.csb")
    local root = csbHeroChoose:getChildByName("root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)
 
	self:onUpdateDraw()
	ccui.Helper:seekWidgetByName(root, "Panel_xzwj_choose"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Text_shou_name"):setString(_pet_tipString_info[15])
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
	{
		terminal_name = "pet_choose_resolve_page_close", 
		terminal_state = 0, 
		_ship = self.ship,
		isPressedActionEnabled = true
	}, 
	nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xzwj_qd"), nil, 
	{
		terminal_name = "pet_choose_resolve_page_close", 
		terminal_state = 0, 
		_ship = self.ship,
		isPressedActionEnabled = true
	},
	nil, 2)
end

function PetChooseForResolve:onExit()
	state_machine.excute("menu_show_event", 0, "menu_show_event.")
	PetChooseForResolve.myListView = nil
	PetChooseForResolve.asyncIndex = 1
	state_machine.remove("pet_choose_resolve_sort")
	state_machine.remove("pet_choose_resolve_page_close")
	state_machine.remove("pet_choose_resolve_close")
	state_machine.remove("pet_resolve_page_check_conut")
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end

function PetChooseForResolve:init()
	
	state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
end
