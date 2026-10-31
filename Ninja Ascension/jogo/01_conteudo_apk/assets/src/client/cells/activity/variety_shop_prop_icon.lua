-- ----------------------------------------------------------------------------------------------------
-- 说明：杂货铺物品
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
VarietyShopPropIcon = class("VarietyShopPropIconClass", Window)
    
function VarietyShopPropIcon:ctor()
    self.super:ctor()
	self.roots = {}
	
	self.enum_type = {
		NONE = 1,
		EQUAL_IMAGE = 2,
		ADD_IMAGE = 3,
	}
	
	self.interfaceType = self.enum_type.NONE
	self.type = nil
	self.mould = nil
	self.num = nil
	self._iconName = "" --道具名称
	self._iconCounts = 0 --道具数量，用在折扣贩卖中，计算数量时有条件判断
	self._showCount = false
	
    -- Initialize VarietyShopPropIcon state machine.
    local function init_VarietyShopPropIcon_terminal()
        state_machine.init()
    end
    
    -- call func init VarietyShopPropIcon state machine.
    init_VarietyShopPropIcon_terminal()
end

function VarietyShopPropIcon:onUpdateDraw()
	local root = self.roots[1]
	
	local equalImage = ccui.Helper:seekWidgetByName(root, "Image_1")
	local propPad = ccui.Helper:seekWidgetByName(root, "Panel_dh_01")
	
	-- FURY: el signo «=» NUNCA se enciende. Sale de `Image_1` de
	-- `landed_gifts_list_dh_k.csb`, que lo saca de
	-- `images/ui/play/wonderful_activity/duihuan_deng.png` y del plist
	-- `wonderful_activity_1.plist`, y esa carpeta NO EXISTE en este
	-- paquete: encenderlo pinta el cartel «... art missed» encima del
	-- premio. Lo unico que lo encendia era la rama EQUAL_IMAGE, que es
	-- la que usaban las filas de los canjes 70, 71 y 76.
	if equalImage ~= nil then
		equalImage:setVisible(false)
	end
	
	if self.type == 1 then--银币
		local cell = propMoneyIcon:createCell()
		cell:init("1",self.num,nil)
		propPad:addChild(cell)
		self._iconName = _All_tip_string_info._fundName
		self._iconCounts = _ED.user_info.user_silver
	end
	if self.type == 2 then--金币
		local cell = propMoneyIcon:createCell()
		cell:init("2",self.num,nil)
		propPad:addChild(cell)
		self._iconName = _All_tip_string_info._crystalName
		self._iconCounts = _ED.user_info.user_gold
	end
	if self.type == 3 then--声望
		local cell = propMoneyIcon:createCell()
		cell:init("3",self.num,nil)
		propPad:addChild(cell)
		self._iconName = _All_tip_string_info._reputation
	end
	if self.type == 4 then	--舰魂
		local cell = propMoneyIcon:createCell()
		cell:init("4",self.num, nil)
		propPad:addChild(cell)
		self._iconName = _All_tip_string_info._hero
	end
	if self.type == 5 then	--水雷魂
		local cell = propMoneyIcon:createCell()
		cell:init("5",self.num, nil)
		propPad:addChild(cell)
		self._iconName = _All_tip_string_info._soulName
	end
	if self.type == 6 then--道具
		-- local cell = PropIconCell:createCell()
		-- cell:init(26, self.mould,self.num)
		-- propPad:addChild(cell)
		-- Fury (30-sep): ResourcesIconCell, que abre la descripcion con un toque (la de ModelPropIconCell
		-- no salia en algunos objetos de la Tienda Premium). Mismo tamano de hueco que la anterior.
		app.load("client.cells.utils.resources_icon_cell")
		local cell = ResourcesIconCell:createCell()
		cell:init(6, self.num, self.mould, nil, nil, true, true, 1)
		propPad:addChild(cell)
		self._iconName = dms.string(dms["prop_mould"],self.mould,prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            self._iconName = setThePropsIcon(self.mould)[2]
        end
		self._iconCounts = getPropAllCountByMouldId(self.mould)
	end
	if self.type == 7 then	--装备
		local cell = EquipIconCell:createCell()
		cell:init(11, nil, self.mould, nil, nil, self.num)
		propPad:addChild(cell)
		self._iconName = dms.string(dms["equipment_mould"],self.mould,equipment_mould.equipment_name)
		local counts = 0
		if self._showCount == true then
			for i, equip in pairs(_ED.user_equiment) do
				if dms.int(dms["equipment_mould"], equip.user_equiment_template, equipment_mould.equipment_type) < 4 then
					local insert = false
					if tonumber(equip.ship_id) <=0 then 
						if zstring.tonumber(equip.user_equiment_grade) <= 5 
							and zstring.tonumber(equip.equiment_refine_level) <= 1 then 
						 --强化不能
						 insert = true
						end
					end
					if insert then 
						counts = counts + 1
					end
				end
			end
			self._iconCounts =  counts
		end
	end

	if self.type == 13 then  --战船

		app.load("client.cells.ship.ship_head_new_cell")
		local cell = ShipHeadNewCell:createCell()
		cell:init(nil,5,self.mould,{showNum = self.num})
		propPad:addChild(cell)
		self._iconName = dms.string(dms["ship_mould"],self.mould,ship_mould.captain_name)
		local counts = 0
		if self._showCount then 
			for i, v in pairs(_ED.user_ship) do
				if zstring.tonumber(v.ship_template_id) == zstring.tonumber(self.mould) then 
					--非上阵
					if zstring.tonumber(v.formation_index) <= 0 and zstring.tonumber(v.little_partner_formation_index) <= 0 then
						if zstring.tonumber(v.ship_grade) <= 5 and  zstring.tonumber(v.ship_skillstren.skill_level) <= 1 then 
							counts = counts + 1
						end
					end
				end
			end
		end
		self._iconCounts = counts
	end
end
--道具
function VarietyShopPropIcon:getItemCell(mid,mtype,count,isCertainly)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.isShowName = false
	cellConfig.isDebris = true
	cellConfig.mouldType = mtype
	cellConfig.touchShowType = 1
	cellConfig.count = count
	cellConfig.isCertainly = isCertainly
	cellConfig.isShowBorder = false
	cell:init(cellConfig)
	return cell
end
function VarietyShopPropIcon:onEnterTransitionFinish()
	local csbVarietyShopPropIcon = csb.createNode("activity/wonderful/landed_gifts_list_dh_k.csb")
    local root = csbVarietyShopPropIcon:getChildByName("root")
    table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	
	self:setContentSize(root:getChildByName("Panel_dh_2"):getContentSize())
	
	self:onUpdateDraw()
end

function VarietyShopPropIcon:onExit()
	
end

function VarietyShopPropIcon:init(_interfaceType, _type, _mould, _num,showNum)
	self.interfaceType = _interfaceType
	self.type = tonumber(_type)
	self.mould = _mould
	self.num = tonumber(_num)
	if showNum == nil then 
		self._showCount = false
	else
		self._showCount = showNum
	end
end

function VarietyShopPropIcon:createCell()
	local cell = VarietyShopPropIcon:new()
	cell:registerOnNodeEvent(cell)
	return cell
end