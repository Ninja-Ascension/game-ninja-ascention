-- ----------------------------------------------------------------------------------------------------
-- 说明：回收界面宠物重生界面
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
PetChooseForReborn = class("PetChooseForRebornClass", Window)
	
function PetChooseForReborn:ctor()
    self.super:ctor()
	
	self.roots = {}
	app.load("client.cells.pet.pet_choose_list_cell")
    -- Initialize PetChooseForReborn page state machine.
    local function init_PetChooseForReborn_terminal()
		-- 关闭
		local pet_choose_reborn_close_terminal = {
            _name = "pet_choose_reborn_close",
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

        state_machine.add(pet_choose_reborn_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_PetChooseForReborn_terminal()
end

function PetChooseForReborn:sortHerosForRebornFun()
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
	
	return sortList(chooseHero())
end

function PetChooseForReborn.loading(texture)
	local myListView = PetChooseForReborn.myListView
	if myListView ~= nil then
		local cell = PetChooseListCell:createCell()
		cell:init(PetChooseForReborn.sortHerosForReborn[PetChooseForReborn.asyncIndex],2,PetChooseForReborn.asyncIndex)
		myListView:addChild(cell)
		PetChooseForReborn.asyncIndex = PetChooseForReborn.asyncIndex + 1
		myListView:requestRefreshView()
	end
end

function PetChooseForReborn:onUpdateDraw()
	local ListView_1 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	app.load("client.cells.pet.pet_choose_list_cell")
	
	PetChooseForReborn.myListView = ListView_1
	PetChooseForReborn.sortHerosForReborn = self:sortHerosForRebornFun()
	PetChooseForReborn.asyncIndex = 1
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	
	for i, v in ipairs(PetChooseForReborn.sortHerosForReborn) do
		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
	end
	
end

function PetChooseForReborn:onEnterTransitionFinish()
	local csbPetChooseForReborn = csb.createNode("packs/HeroStorage/generals_sell.csb")
	self:addChild(csbPetChooseForReborn)
	local root = csbPetChooseForReborn:getChildByName("root")
	table.insert(self.roots, root)

	ccui.Helper:seekWidgetByName(root, "Text_shou_name"):setString(_pet_tipString_info[15])
	
	
	state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
	self:onUpdateDraw()
	
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
	{
		terminal_name = "pet_choose_reborn_close", 
		isPressedActionEnabled = true
	}, 
	nil, 2)
end

function PetChooseForReborn:onExit()
	PetChooseForReborn.myListView = nil
	PetChooseForReborn.asyncIndex = 1
	state_machine.remove("pet_choose_reborn_close")
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end