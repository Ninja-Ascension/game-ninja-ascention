----------------------------------------------------------------------------------------------------
-- 说明：时装信息界面下滑列(描述)
-------------------------------------------------------------------------------------------------------
FashionInfoDescribeListCell = class("FashionInfoDescribeListCellClass", Window)

function FashionInfoDescribeListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
	self.equip_mouldId= nil
    local function equip_info_describe_list_cell_terminal()
		
    end
    
    equip_info_describe_list_cell_terminal()
end

function FashionInfoDescribeListCell:onUpdateDraw()
	local root = self.roots[1]
	local text = ccui.Helper:seekWidgetByName(root, "Text_5")
	local panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	
	local label_UI = csb.createNode("utils/version_length.csb")
	local label_root = label_UI:getChildByName("root")
	local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
	local lableBaseSize = lableCell:getContentSize()
	
	local sizeX = panel_3:getContentSize().width
	local sizeY = panel_3:getContentSize().height
	local textX = text:getContentSize().width
	local textY = text:getPositionY()
	local tipHeight = 0

	local equipId = nil

	local equip_lv = 1
	if self.equipmentInstance ~= nil then
		equipId =self.equipmentInstance.user_equiment_template
		equip_lv = zstring.tonumber(self.equipmentInstance.user_equiment_grade)
	else
		equip_lv = 1
		equipId = self.equip_mouldId
	end
	local textInfo = dms.string(dms["equipment_mould"], equipId, equipment_mould.trace_remarks)
	local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
			lableCell:getFontSize(), cc.size(lableBaseSize.width+45, 0), 
			cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[12][1],tipStringInfo_quality_color_Type[12][2],tipStringInfo_quality_color_Type[12][3]))
	panel_3:addChild(lableCell)
	lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
	local lableSize = lableCell:getContentSize()
	tipHeight = tipHeight + lableSize.height
	-- lableCell:setPosition(cc.p(lableCell:getPositionX()+20, -1 * tipHeight+sizeY-42))
	lableCell:setPosition(cc.p(lableCell:getPositionX()+30, -1*tipHeight+textY))
	panel_3:setContentSize(cc.size(sizeX,tipHeight + sizeY))
	
end

function FashionInfoDescribeListCell:onEnterTransitionFinish()
    local csbFashionInfoDescribeListCell = csb.createNode("packs/EquipStorage/equipment_information_list_4.csb")
	local root = csbFashionInfoDescribeListCell:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
	self:onUpdateDraw()
	-- Text_5 描述
	
	
end


function FashionInfoDescribeListCell:onExit()

end

function FashionInfoDescribeListCell:init(equipmentInstance,equipId)
	self.equipmentInstance = equipmentInstance
	self.equip_mouldId = equipId
end

function FashionInfoDescribeListCell:createCell()
	local cell = FashionInfoDescribeListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end