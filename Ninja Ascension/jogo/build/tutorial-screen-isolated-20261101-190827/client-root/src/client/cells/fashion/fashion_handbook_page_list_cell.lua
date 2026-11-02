----------------------------------------------------
-- 时装图鉴LIST
--------------------------------------------------

FashionHandbookPageListCell = class("FashionHandbookPageListCellClass", Window)
FashionHandbookPageListCell.__size = nil 

function FashionHandbookPageListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.example = nil 
	self.index = nil
	self.suitId = nil
	-- Initialize FashionHandbookPageListCell state machine.
    local function init_fashion_handbook_page_list_cell_terminal()
    	local fashion_handbook_page_list_cell_show_fashion_information_terminal = {
            _name = "fashion_handbook_page_list_cell_show_fashion_information",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.packs.fashion.FashionInformation")
            	state_machine.excute("fashion_information_open", 0, params)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(fashion_handbook_page_list_cell_show_fashion_information_terminal)	
        state_machine.init()
    end
    -- -- call func init FashionHandbookPageListCell state machine.
    init_fashion_handbook_page_list_cell_terminal()

end

function FashionHandbookPageListCell:onUpdateDrawNil()
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

function FashionHandbookPageListCell:onUpdateDraw()
	local  root = self.roots[1]
	if root == nil then
		return
	end 

	local  Text_shizhuang_name = ccui.Helper:seekWidgetByName(root, "Text_shizhuang_name")
	local  Text_shuxing_01 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_01")
	local  Text_shuxing_02 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_02")
	local  Text_shuxing_1 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_1")
	local  Text_shuxing_0_0 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_0_0")
	Text_shuxing_01:setString("")
	Text_shuxing_02:setString("")
	Text_shuxing_1:setString("")
	Text_shuxing_0_0:setString("")

	local Panel_shizhuang_tu_1 =  ccui.Helper:seekWidgetByName(root, "Panel_shizhuang_tu_1")
	local Panel_shizhuang_tu_2 =  ccui.Helper:seekWidgetByName(root, "Panel_shizhuang_tu_2")
	Panel_shizhuang_tu_1:removeBackGroundImage()
	Panel_shizhuang_tu_2:removeBackGroundImage()

	local nameOne = ccui.Helper:seekWidgetByName(root, "Text_243")
	local nemaeTwo = ccui.Helper:seekWidgetByName(root, "Text_243_0")
	local equipMouldIdOne = dms.atoi(self.example ,equipment_fashion_pokedex.suit_fashion_id_1)
	local equipMouldIdTwo = dms.atoi(self.example ,equipment_fashion_pokedex.suit_fashion_id_2)

	

	local qualityOne = dms.int(dms["equipment_mould"], equipMouldIdOne, equipment_mould.grow_level) + 1
    local picIndexOne =  dms.int(dms["equipment_mould"], equipMouldIdOne, equipment_mould.All_icon)

    nameOne:setString(dms.string(dms["equipment_mould"], equipMouldIdOne, equipment_mould.equipment_name))
    nameOne:setColor(cc.c3b(tipStringInfo_quality_color_Type[qualityOne][1],tipStringInfo_quality_color_Type[qualityOne][2],tipStringInfo_quality_color_Type[qualityOne][3]))

    local qualityTwo = dms.int(dms["equipment_mould"], equipMouldIdTwo, equipment_mould.grow_level) + 1
    local picIndexTwo =  dms.int(dms["equipment_mould"], equipMouldIdTwo, equipment_mould.All_icon)

    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
    	Panel_shizhuang_tu_1:setBackGroundImage(string.format("images/ui/props/props_%s.png", picIndexOne+1000 ))
    	Panel_shizhuang_tu_2:setBackGroundImage(string.format("images/ui/props/props_%s.png", picIndexTwo+1000))
    else
    	Panel_shizhuang_tu_1:setBackGroundImage(string.format("images/face/hero_head/props_%s.png", picIndexOne+1000 ))
    	Panel_shizhuang_tu_2:setBackGroundImage(string.format("images/face/hero_head/props_%s.png", picIndexTwo+1000))
    end

    nemaeTwo:setString(dms.string(dms["equipment_mould"], equipMouldIdTwo, equipment_mould.equipment_name))
    nemaeTwo:setColor(cc.c3b(tipStringInfo_quality_color_Type[qualityTwo][1],tipStringInfo_quality_color_Type[qualityTwo][2],tipStringInfo_quality_color_Type[qualityTwo][3]))



    local EquipOne = fundEquipWidthId(equipMouldIdOne)
	Panel_shizhuang_tu_1:setTouchEnabled(false)
	Panel_shizhuang_tu_2:setTouchEnabled(false)
	-- params._datas._equip_mould
	if EquipOne ~= nil then
			Panel_shizhuang_tu_1:setColor(cc.c3b(255,255,255))
			Panel_shizhuang_tu_1:setTouchEnabled(true)
			-- Panel_shizhuang_tu_1:setBright(false)
			fwin:addTouchEventListener(Panel_shizhuang_tu_1, nil, 
			{
			    terminal_name = "fashion_handbook_page_list_cell_show_fashion_information", 
			    terminal_state = 0,
			    _cell = self,
			    _equip = EquipOne,
			    isPressedActionEnabled = false
			}, 
			nil, 0)
	
	else
		Panel_shizhuang_tu_1:setColor(cc.c3b(tipStringInfo_fashion_str[3][1],tipStringInfo_fashion_str[3][2],tipStringInfo_fashion_str[3][3]))
		Panel_shizhuang_tu_1:setTouchEnabled(true)
		-- Panel_shizhuang_tu_1:setBright(false)
		fwin:addTouchEventListener(Panel_shizhuang_tu_1, nil, 
		{
		    terminal_name = "fashion_handbook_page_list_cell_show_fashion_information", 
		    terminal_state = 0,
		    _cell = self,
		    _equip = nil,
		    _equip_mould = equipMouldIdOne,
		    isPressedActionEnabled = false
		}, 
		nil, 0)
	end
	local EquipTwo = fundEquipWidthId(equipMouldIdTwo)
	if EquipTwo ~= nil then
			Panel_shizhuang_tu_2:setColor(cc.c3b(255,255,255))
			Panel_shizhuang_tu_2:setTouchEnabled(true)
			-- Panel_shizhuang_tu_2:setBright(false)
			fwin:addTouchEventListener(Panel_shizhuang_tu_2, nil, 
			{
			    terminal_name = "fashion_handbook_page_list_cell_show_fashion_information", 
			    terminal_state = 0,
			    _cell = self,
			    _equip = EquipTwo,
			    isPressedActionEnabled = false
			}, 
			nil, 0)

	else
		Panel_shizhuang_tu_2:setColor(cc.c3b(tipStringInfo_fashion_str[3][1],tipStringInfo_fashion_str[3][2],tipStringInfo_fashion_str[3][3]))
		Panel_shizhuang_tu_2:setTouchEnabled(true)
		-- Panel_shizhuang_tu_2:setBright(true)
		fwin:addTouchEventListener(Panel_shizhuang_tu_2, nil, 
			{
			    terminal_name = "fashion_handbook_page_list_cell_show_fashion_information", 
			    terminal_state = 0,
			    _cell = self,
			    _equip = nil,
			    _equip_mould = equipMouldIdTwo,
			    isPressedActionEnabled = false
			}, 
			nil, 0)
	end






    local suitId = dms.atoi(self.example ,equipment_fashion_pokedex.suit_id)
    -- dms.string(dms["suit_param"],suitId,suit_param.suit_name)
    Text_shizhuang_name:setString(dms.string(dms["suit_param"],suitId,suit_param.suit_name))
    local activate_property1 = dms.string(dms["suit_param"],suitId,suit_param.activate_property1)
	local activate_property2 = dms.string(dms["suit_param"],suitId,suit_param.activate_property2)
	local activate_property3 = dms.string(dms["suit_param"],suitId,suit_param.activate_property3)
	local seq1 = zstring.split(activate_property1,"|")

	for i,v in pairs(seq1) do
		local influenceType = zstring.split(v,",")		--每一种属性
		local _pType = tonumber(influenceType[1])
		local _pValue = influenceType[2]
		if i == 1 then
			if _pType+1 > 4 then
				Text_shuxing_01:setString(_influence_type[_pType+1].."+")
				Text_shuxing_02:setString(_pValue.."%")
			else
				Text_shuxing_01:setString(_influence_type[_pType+1].."+")
				Text_shuxing_02:setString(_pValue)
			end
		elseif i == 2 then
			if _pType+1 > 4 then
				Text_shuxing_1:setString(_influence_type[_pType+1].."+")
				Text_shuxing_0_0:setString(_pValue.."%")
			else
				Text_shuxing_1:setString(_influence_type[_pType+1].."+")
				Text_shuxing_0_0:setString(_pValue)
			end
		end
	end	


    
end

function FashionHandbookPageListCell:onEnterTransitionFinish()

end

function FashionHandbookPageListCell:onInit()

 	local root = cacher.createUIRef("fashionable_dress/fashionable_tujian_k.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	if FashionHandbookPageListCell.__size == nil then
		FashionHandbookPageListCell.__size = root:getChildByName("Panel_212"):getContentSize()
	end	
	if self.suitId > 0 then
		self:onUpdateDraw()
	elseif self.suitId == -1 then
		self:onUpdateDrawNil()
	end

end


function FashionHandbookPageListCell:onExit()
	cacher.freeRef("fashionable_dress/fashionable_tujian_k.csb", self.roots[1])
end

function FashionHandbookPageListCell:init(example,index,suitId)
	self.example = example
	self.index = index
	self.suitId = suitId
	-- if index < 5 then
		self:onInit()
	-- end
	self:setContentSize(FashionHandbookPageListCell.__size)
end


function FashionHandbookPageListCell:reload()

	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function FashionHandbookPageListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("fashionable_dress/fashionable_tujian_k.csb", root)

	root:removeFromParent(false)
	self.roots = {}
end

function FashionHandbookPageListCell:createCell()
	local cell = FashionHandbookPageListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end