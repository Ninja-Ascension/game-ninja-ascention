----------------------------------------------------
-- 宠物图鉴LIST
--------------------------------------------------

PetHandbookPageListCell = class("PetHandbookPageListCellClass", Window)

function PetHandbookPageListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self._example = nil 
	self.index = nil
	self._suitId = nil
	self._csbIndex = 2 -- 2 两个宠物 3 3个宠物  控制读取哪个资源CSB
	self._suitDate = nil
	self._isActivate = false --此图鉴被激活
	-- Initialize PetHandbookPageListCell state machine.
    local function init_pet_handbook_page_list_cell_terminal()
    	local pet_handbook_page_list_cell_show_information_terminal = {
            _name = "pet_handbook_page_list_cell_show_information",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local ship = params._datas._shipId
            	local petId = dms.int(dms["ship_mould"],ship,ship_mould.base_mould2)
            	local propId = dms.int(dms["pet_mould"],petId,pet_mould.prop_piece_id)
            	app.load("client.packs.hero.HeroPatchInformation")
				local cell = HeroPatchInformation:new()
				cell:init({user_prop_template = propId},2)
				fwin:open(cell, fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(pet_handbook_page_list_cell_show_information_terminal)	
        state_machine.init()
    end
    -- -- call func init PetHandbookPageListCell state machine.
    init_pet_handbook_page_list_cell_terminal()

end

function PetHandbookPageListCell:onUpdateDrawNil()
	local  root = self.roots[1]
	if root == nil then
		return
	end
	local  Text_shuxing_01 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_01")
	local  Text_shuxing_02 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_02")
	local  Text_shuxing_1 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_1")
	local  Text_shuxing_0_0 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_0_0")
	if verifySupportLanguage(_lua_release_language_en) == true then
		ccui.Helper:seekWidgetByName(root, "Text_shizhuang_name"):setString("coming soon")
	else
		ccui.Helper:seekWidgetByName(root, "Text_shizhuang_name"):setString("???")
	end
	Text_shuxing_01:setString("???")
	Text_shuxing_02:setString("???")
	Text_shuxing_1:setString("???")
	Text_shuxing_0_0:setString("???")
	ccui.Helper:seekWidgetByName(root, "Text_243"):setString("")
	ccui.Helper:seekWidgetByName(root, "Text_243_0"):setString("")
	ccui.Helper:seekWidgetByName(root, "Panel_shizhuang_tu_1"):removeBackGroundImage()
	ccui.Helper:seekWidgetByName(root, "Panel_shizhuang_tu_2"):removeBackGroundImage()
end

function PetHandbookPageListCell:onUpdateDraw()
	local  root = self.roots[1]
	if root == nil then
		return
	end
	local suit_id = dms.atoi(self._example,pet_pokedex.suit_id)
	self._suitDate = dms.element(dms["suit_param"], suit_id)
	ccui.Helper:seekWidgetByName(root, "Text_pet_name"):setString(dms.atos(self._suitDate,suit_param.suit_name))
	local pet1 = dms.atoi(self._example,pet_pokedex.pet_template_id_1)
	local pet2 = dms.atoi(self._example,pet_pokedex.pet_template_id_2)
	local pet3 = dms.atoi(self._example,pet_pokedex.pet_template_id_3)

	local isPet1 = false
	local isPet2 = false
	local isPet3 = false
	local have_ship = zstring.split(_ED.catalogue_hero_is_have, ",")
    for i , v in pairs(have_ship) do
    	if pet1 == tonumber(v) then
    		isPet1 = true
    	end
    	if pet2 == tonumber(v) then
    		isPet2 = true
    	end
    	if pet3 == tonumber(v) then
    		isPet3 = true
    	end
    end
	if pet1 ~= nil and pet1 ~= -1 then 
		self:onUpdateShipPanel(1,pet1,isPet1)
	end
	if pet2 ~= nil and pet2 ~= -1 then 
		self:onUpdateShipPanel(2,pet2,isPet2)
	end
	if pet3 ~= nil and pet3 ~= -1 then 
		self:onUpdateShipPanel(3,pet3,isPet3)
	end
	--此套装是否被激活
	if isPet1 and isPet2 and (pet3 == -1 or isPet3) then 
		self._isActivate = true
		ccui.Helper:seekWidgetByName(root, "Image_10_0_0"):setColor(cc.c3b(255,255,255))
	else
		ccui.Helper:seekWidgetByName(root, "Image_10_0_0"):setColor(cc.c3b(130,130,130))
	end
end

-- 刷新宠物数据
-- @ index 第几个宠物
-- @ shipId 模板ID
-- @ isActivate
function PetHandbookPageListCell:onUpdateShipPanel(index,shipId,isActivate)
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local shipPanel = ccui.Helper:seekWidgetByName(root, "Panel_pet_tu_".. index)
	if shipPanel ~= nil then
		local picIndex = dms.int(dms["ship_mould"],shipId,ship_mould.All_icon)
		shipPanel:setBackGroundImage(string.format("images/face/big_head/big_head_%s.png",picIndex))
		
		fwin:addTouchEventListener(shipPanel, nil, 
		{
			terminal_name = "pet_handbook_page_list_cell_show_information", 
			terminal_state = 0, 
			isPressedActionEnabled = true,
			_shipId = shipId,
		},
		nil,0)	
	end
	if isActivate == true then 
		shipPanel:setColor(cc.c3b(255,255,255))
		local Panel2 = ccui.Helper:seekWidgetByName(root, "Panel_212")
		local armature = Panel2:getChildByName("ArmatureNode_pet_".. index)
		if armature ~= nil then 
			armature:setVisible(true)
		end
	else
		shipPanel:setColor(cc.c3b(150,150,150))
	end
	
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_name_".. index)
	if nameText ~= nil then 
		local ship_type = dms.int(dms["ship_mould"],shipId,ship_mould.ship_type) +1
		nameText:setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type][1], tipStringInfo_quality_color_Type[ship_type][2], tipStringInfo_quality_color_Type[ship_type][3]))
		nameText:setString(dms.string(dms["ship_mould"],shipId,ship_mould.captain_name))
	end
	
	--套装属性
	local activate_property1 = dms.atos(self._suitDate,suit_param.activate_property1)
	local activate_property2 = dms.atos(self._suitDate,suit_param.activate_property2)
	local activate_property3 = dms.atos(self._suitDate,suit_param.activate_property3)
	
	--套装属性只会有一种
	local infoDate = nil
	if activate_property1 ~= "-1" then 
		infoDate = activate_property1
	end
	if activate_property2 ~= "-1" then 
		infoDate = activate_property2
	end
	if activate_property3 ~= "-1" then 
		infoDate = activate_property3
	end
	for i=1,4 do
		local infoText = ccui.Helper:seekWidgetByName(root, "Text_shuxing_"..i)
		infoText:setString("")
		local valueText = ccui.Helper:seekWidgetByName(root, "Text_shuxing_1_"..i)
		valueText:setString("")
	end
	if infoDate == nil then 
		return
	end
	--设置属性
	local seq1 = zstring.split("" ..infoDate,"|")
	for i,v in pairs(seq1) do
		local influenceType = zstring.split(v,",")
		local _pType = tonumber(influenceType[1])
		local _pValue = influenceType[2]
		local infoText = ccui.Helper:seekWidgetByName(root, "Text_shuxing_"..i)
		infoText:setString(_influence_type[_pType+1].."+")
		local valueText = ccui.Helper:seekWidgetByName(root, "Text_shuxing_1_"..i)
		valueText:setString(_pValue..string_equiprety_name_vlua_type[_pType+1])
	end
end

function PetHandbookPageListCell:onEnterTransitionFinish()

end

function PetHandbookPageListCell:onInit()

	if self._csbIndex == 2 then 
		path = "packs/PetStorage/PetStorage_tujian_k2.csb"
	else
		path = "packs/PetStorage/PetStorage_tujian_k3.csb"
	end
 	local root = cacher.createUIRef(path, "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
 	self:setContentSize(root:getChildByName("Panel_212"):getContentSize())
 	ccui.Helper:seekWidgetByName(root, "Panel_212"):getChildByName("ArmatureNode_pet_1"):setVisible(false)
 	ccui.Helper:seekWidgetByName(root, "Panel_212"):getChildByName("ArmatureNode_pet_2"):setVisible(false)
	
	if self._suitId > 0 then
		self:onUpdateDraw()
	elseif self._suitId == -1 then
		self:onUpdateDrawNil()
	end
end

function PetHandbookPageListCell:onExit()
	local path = ""
	if self._csbIndex == 2 then 
		path = "packs/PetStorage/PetStorage_tujian_k2.csb"
	else
		path = "packs/PetStorage/PetStorage_tujian_k3.csb"
	end
	cacher.freeRef(path, self.roots[1])
end

function PetHandbookPageListCell:init(example,index,suitId)
	self._example = example
	self.index = index
	self._suitId = suitId
	local petId3 = dms.atoi(example,pet_pokedex.pet_template_id_3)
	if petId3 == -1 then 
		self._csbIndex = 2
	else
		self._csbIndex = 3
	end
	self:onInit()
end

function PetHandbookPageListCell:reload()

	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PetHandbookPageListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local path = ""
	if self._csbIndex == 2 then 
		path = "packs/PetStorage/PetStorage_tujian_k2.csb"
	else
		path = "packs/PetStorage/PetStorage_tujian_k3.csb"
	end
	cacher.freeRef(path, root)

	root:removeFromParent(false)
	self.roots = {}
end

function PetHandbookPageListCell:createCell()
	local cell = PetHandbookPageListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end