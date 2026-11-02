-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的选择宠物升级界面
-------------------------------------------------------------------------------------------------------
ChoosePetToStreng = class("ChoosePetToStrengClass", Window)

function ChoosePetToStreng:ctor()
    self.super:ctor()
	self.roots = {}
	self.sortPet = {}
	self.selectMaxCount = 5
	self.selectCount = 0
	self.strenShipId = nil

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
	self.choose_indexs = {}
	
	app.load("client.utils.ConfirmTip")
	app.load("client.cells.ship.hero_choose_list_cell")
	
    local function init_choose_hero_to_streng_page_terminal()
		-- 关闭
		local choose_pet_to_streng_page_close_terminal = {
            _name = "choose_pet_to_streng_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local ships = {}
				local ListView_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_1")
				local cells = ListView_1:getItems()
		
				for i, cell in pairs(cells) do
					if cell.status == true then
						table.insert(ships, cell.heroInstance)
						
					end
				end
				state_machine.excute("pet_strengthen_page_update_info", 0, {_datas = {needPetsInfo = ships}})
				state_machine.excute("choose_pet_to_streng_page_cancel", 0, nil)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local choose_pet_to_streng_page_cancel_terminal = {
            _name = "choose_pet_to_streng_page_cancel",
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
		
		local pet_strengthen_page_check_full_terminal = {
            _name = "pet_strengthen_page_check_full",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local win = fwin:find("ChoosePetToStrengClass")
				if nil == win or nil == params or nil == params._datas or nil == params._datas.cell then
					return
				end
				local getExp = instance.getExp
				-- local gradeNeedExprience = instance.gradeNeedExprience
				-- local cellExp = instance:getOfferOfExp(params._datas.cell.heroInstance.user_prop_template)
				-- local captainGrade = tonumber(_ED.user_info.user_grade)	--主角等级
				-- local AllExp = 0			--可获总经验
				-- local NeedExp = zstring.tonumber(_ED.user_ship[instance.strenShipId].grade_need_exprience) --需要多少经验
				-- local ship_grade = tonumber(_ED.user_ship[instance.strenShipId].ship_grade)				  --战船当前等级
				state_machine.excute("pet_strengthen_page_check_conut", 0, {_datas = {cell = params._datas.cell}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local pet_strengthen_page_check_conut_terminal = {
            _name = "pet_strengthen_page_check_conut",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local tempCell = params._datas.cell
				local cellExp = instance:getOfferOfExp(tempCell.heroInstance.user_prop_template)
				if tempCell.status == false then
					if instance.selectCount >= instance.selectMaxCount then
						TipDlg.drawTextDailog(_pet_tipString_info[7])
					else
						tempCell:setSelected(true)
						instance.selectCount = instance.selectCount + 1
						instance.getExp = instance.getExp + cellExp
					end
				else
					tempCell:setSelected(false)
					instance.selectCount = instance.selectCount - 1
					instance.getExp = instance.getExp - cellExp
				end
				
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_exp_v"):setString(instance.getExp)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_sucsi_v"):setString(instance.gradeNeedExprience)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(choose_pet_to_streng_page_cancel_terminal)
		state_machine.add(pet_strengthen_page_check_full_terminal)
		state_machine.add(choose_pet_to_streng_page_close_terminal)
		state_machine.add(pet_strengthen_page_check_conut_terminal)
        state_machine.init()
    end
    init_choose_hero_to_streng_page_terminal()
end

function ChoosePetToStreng.loading(texture)
	local myListView = ChoosePetToStreng.myListView
	if myListView ~= nil then
		local cell = HeroChooseListCell:createCell()
		cell:init(ChoosePetToStreng.sortPet[ChoosePetToStreng.asyncIndex], 3, ChoosePetToStreng.sortPet[ChoosePetToStreng.asyncIndex]._isSelect, ChoosePetToStreng.asyncIndex)
		myListView:addChild(cell)
		ChoosePetToStreng.asyncIndex = ChoosePetToStreng.asyncIndex + 1
	end
end

function ChoosePetToStreng:sortPetProps()
	local petProps = {}
	local arrStarLevelPetsWhite = {}
	local arrStarLevelPetsGreen = {}
	local arrStarLevelPetsBlue = {}
	local arrStarLevelPetsPurple = {}
	local arrStarLevelPetsYellow = {}
	local arrStarLevelPetsRed = {}
	local allProps = {}
	for i, prop in pairs(_ED.user_prop) do
		if prop.user_prop_template ~= nil then
			local propData = dms.element(dms["prop_mould"], prop.user_prop_template)
			if dms.atoi(propData, prop_mould.props_type) == 21 then
				if dms.atoi(propData, prop_mould.prop_quality) == 0 then
					table.insert(arrStarLevelPetsWhite, prop)
				elseif dms.atoi(propData, prop_mould.prop_quality) == 1 then
					table.insert(arrStarLevelPetsGreen, prop)
				elseif dms.atoi(propData, prop_mould.prop_quality) == 2 then
					table.insert(arrStarLevelPetsBlue, prop)
				elseif dms.atoi(propData, prop_mould.prop_quality) == 3 then
					table.insert(arrStarLevelPetsPurple, prop)
				elseif dms.atoi(propData, prop_mould.prop_quality) == 4 then				
					table.insert(arrStarLevelPetsYellow, prop)
				elseif dms.atoi(propData, prop_mould.prop_quality) == 5 then				
					table.insert(arrStarLevelPetsRed, prop)
				end
			end
		end
	end
	for i=1, #arrStarLevelPetsRed do
		table.insert(allProps, arrStarLevelPetsRed[i])
	end
	for i=1, #arrStarLevelPetsYellow do
		table.insert(allProps, arrStarLevelPetsYellow[i])
	end
	for i=1, #arrStarLevelPetsPurple do
		table.insert(allProps, arrStarLevelPetsPurple[i])
	end
	for i=1, #arrStarLevelPetsBlue do
		table.insert(allProps, arrStarLevelPetsBlue[i])
	end
	for i=1, #arrStarLevelPetsGreen do
		table.insert(allProps, arrStarLevelPetsGreen[i])
	end
	for i=1, #arrStarLevelPetsWhite do
		table.insert(allProps, arrStarLevelPetsWhite[i])
	end
	local propCount = 0
	for k,prop in pairs(allProps) do

		for i=1,zstring.tonumber(prop.prop_number) do
			local cell = {}
			--深拷贝
			cell.user_prop_id = prop.user_prop_id
			cell.user_prop_template = prop.user_prop_template
			cell.prop_number = prop.prop_number
			cell._isSelect = false
			propCount = propCount + 1
			cell._index = propCount
			table.insert(petProps, cell)
		end
	end
	return petProps
end

function ChoosePetToStreng:updateExp(tempCell)
	local cellExp = self:getOfferOfExp(tempCell.heroInstance.user_prop_template)
	if tempCell.status == true then
		if self.selectCount >= self.selectMaxCount then
			TipDlg.drawTextDailog(_pet_tipString_info[7])
		else
			self.selectCount = self.selectCount + 1
			self.getExp = self.getExp + cellExp
		end
	else
		self.selectCount = self.selectCount - 1
		self.getExp = self.getExp - cellExp
	end
	
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_exp_v"):setString(self.getExp)
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_sucsi_v"):setString(self.gradeNeedExprience)
end

function ChoosePetToStreng:getOfferOfExp(mouldId)
	local cellExp = dms.int(dms["prop_mould"],mouldId,prop_mould.use_of_experience)
	return cellExp
end

function ChoosePetToStreng:showConfirmTip(n)
	if n == 0 then
		-- yes
		self.indexCell:setSelected(true)
		self:updateExp(self.indexCell)
	else
		-- no
	end
end

function ChoosePetToStreng:tipFullExp(cell)
	self.indexCell = cell
	
	local tip = ConfirmTip:new()
	tip:init(self, self.showConfirmTip, _string_piece_info[369])
	fwin:open(tip,fwin._ui)
end

function ChoosePetToStreng:onUpdateDraw()
	self.sortPet = self:sortPetProps()
	self.getExp = 0
	self.selectCount = 0
	for i,v in pairs(self.choose_indexs) do
		if v ~= "" then
			local prop = self.sortPet[zstring.tonumber(v._index)]
			if prop ~= nil and prop ~= "" then 
				prop._isSelect = true
				self.getExp = self.getExp + self:getOfferOfExp(prop.user_prop_template)
				self.selectCount = self.selectCount + 1
			end
		end
	end
	local ListView_1 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	app.load("client.cells.ship.hero_choose_list_cell")

	ListView_1:removeAllItems()
	ChoosePetToStreng._self = self
	ChoosePetToStreng.myListView = ListView_1
	ChoosePetToStreng.sortPet = self.sortPet
	ChoosePetToStreng.asyncIndex = 1

	for i, v in pairs(self.sortPet) do
		self.loading(nil)
	end
	ListView_1:requestRefreshView()

	self.currentListView = ListView_1
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_exp_v"):setString(self.getExp)
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_sucsi_v"):setString(self.gradeNeedExprience)
end

function ChoosePetToStreng:onUpdate(dt)
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

function ChoosePetToStreng:onEnterTransitionFinish()
	
	local csbGeneralsQianghua = csb.createNode("packs/choose_material.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	root:removeFromParent(true)
	table.insert(self.roots, root)
    self:addChild(root)
    
	self:onUpdateDraw()
	
	local view_panel = ccui.Helper:seekWidgetByName(root, "Panel_2")
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(view_panel, "Button_1"), nil, 
	{
		terminal_name = "choose_pet_to_streng_page_cancel", 
		terminal_state = 0, 
		_ship = self.ship,
		isPressedActionEnabled = true
	}, 
	nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(view_panel, "Button_4"), nil, 
	{
		terminal_name = "choose_pet_to_streng_page_close", 
		terminal_state = 0, 
		_ship = self.ship,
		isPressedActionEnabled = true
	},
	nil, 0)
end

function ChoosePetToStreng:onExit()
	ChoosePetToStreng.myListView = nil
	ChoosePetToStreng.asyncIndex = 1
	state_machine.remove("choose_pet_to_streng_page_close")
	state_machine.remove("pet_strengthen_page_check_conut")
	state_machine.remove("choose_pet_to_streng_page_cancel")
end

function ChoosePetToStreng:init(ships, strenShipId)
	self.choose_indexs = ships
	self.strenShipId = strenShipId
	self.gradeNeedExprience = _ED.user_ship[strenShipId].grade_need_exprience
	local ship_type = dms.int(dms["ship_mould"], _ED.user_ship[strenShipId].ship_template_id, ship_mould.ship_type) 
	local levelExps = dms.searchs(dms["pet_level_requirement"], pet_level_requirement.pet_type, ship_type)
	if levelExps == nil then 
		return
	end
	local petLevel = zstring.tonumber(_ED.user_ship[strenShipId].ship_grade)
	for k,v in pairs(levelExps) do
		if zstring.tonumber(v[3]) == petLevel then 
			self.gradeNeedExprience = zstring.tonumber(v[4]) - zstring.tonumber(_ED.user_ship[strenShipId].exprience)
			break
		end
	end
end