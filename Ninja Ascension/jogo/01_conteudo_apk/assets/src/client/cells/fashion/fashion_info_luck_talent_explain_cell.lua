---------------------------------
---说明：时装信息界面的 缘分、天赋、
---------------------------------
-- fashion_info_luck_talent_explain_cell.lua

FashionInfoTalentExplain = class("FashionInfoTalentExplainClass", Window)
   
function FashionInfoTalentExplain:ctor()
    self.super:ctor()
	self.equip = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.page = nil
	self.equip_mould = nil
	self.texts = {}
end

function FashionInfoTalentExplain:onUpdateDrawLot() --缘分
	
end

function FashionInfoTalentExplain:onUpdateDrawTalent() --天赋
	local root = self.roots[1]
	-- local Text_biaoti = ccui.Helper:seekWidgetByName(root, "Text_biaoti")		--标题
	local Text_shuoming = ccui.Helper:seekWidgetByName(root, "Text_fashion_shuoming")	-- 
	-- Text_biaoti:setString(_string_piece_info[38])
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_fashion_shuoming")
	local Image_18 = ccui.Helper:seekWidgetByName(root, "Image_18")
	local Panel_14 = ccui.Helper:seekWidgetByName(root, "Panel_fashion_14")
	
	-- local frameAddCount = 18	--字体间距
	local Text_width = Text_shuoming:getPositionX()
	local Text_height = Text_shuoming:getPositionY()
	local sizeX = PanelGeneralsEquipment:getContentSize().width
	local sizeY = PanelGeneralsEquipment:getContentSize().height
	local Panel_14_high = Panel_14:getPositionY()
	local Panel_14_width = Panel_14:getPositionX()
	
	local label_UI = csb.createNode("utils/version_length.csb")
	local label_root = label_UI:getChildByName("root")
	local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")

	local lableBaseSize = lableCell:getContentSize()
	local TextShuomingSize = Text_shuoming:getContentSize()

	local tipHeight = 0
	for i, v in pairs(self.texts) do
		local colorIndex = v[1]
		 -- print("=----",v[1],v[2],v[3])
		local textInfo = "[" .. v[2] .. "]" .. " " .. v[3] .. "(" .. _string_piece_info[51] .."+" .. i .. _string_piece_info[52] ..")"
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
			lableCell:getFontSize(), cc.size(TextShuomingSize.width, 0), 
			cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		if tonumber(colorIndex) == 0 then
			lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[13][1],tipStringInfo_quality_color_Type[13][2],tipStringInfo_quality_color_Type[13][3]))
		else
			lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
		end
		Panel_14:addChild(lableCell)
		lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
		local lableSize = lableCell:getContentSize()
		
		tipHeight = tipHeight + lableSize.height
	
		lableCell:setPosition(cc.p(Text_shuoming:getPositionX(), -1 * tipHeight))
	end
	PanelGeneralsEquipment:setContentSize(cc.size(sizeX,tipHeight + sizeY))
	self:setContentSize(cc.size(sizeX,sizeY+tipHeight+5))

	Panel_14:setPosition(Panel_14_width,Panel_14_high+tipHeight)
end

function FashionInfoTalentExplain:onUpdateDrawExplain() --武将说明
	
end

function FashionInfoTalentExplain:onEnterTransitionFinish()

    --获取 武将碎片选项卡 美术资源
    local equipment_information_list_7 = csb.createNode("packs/EquipStorage/equipment_information_list_7.csb")
	local root = equipment_information_list_7:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(equipment_information_list_7)
	self.oSize = root:getContentSize()
	
	local Text_biaoti = ccui.Helper:seekWidgetByName(root, "Text_fashion_ti")		--标题
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_fashion_shuoming")
	if self.page == 1 then
		-- Text_biaoti:setString(_string_piece_info[37])
		-- self:onUpdateDrawLot()
	elseif self.page == 2 then
		Text_biaoti:setString(_string_piece_info[38])
		self:onUpdateDrawTalent()
	elseif self.page == 3 then
		-- Text_biaoti:setString(_string_piece_info[39])
		-- self:onUpdateDrawExplain()
	end
	-- self:setContentSize(cc.size(PanelGeneralsEquipment:getContentSize().width,PanelGeneralsEquipment:getContentSize().height))
	
	self.size = self:getContentSize()
	
	
	equipment_information_list_7:setPosition(cc.p(0, self.size.height - self.oSize.height))
end

function FashionInfoTalentExplain:onExit()

end

function FashionInfoTalentExplain:init(equip,mouldid, page, text)
	self.equip = equip
	self.equip_mould = mouldid
	self.texts = text
	self.page = page
end

function FashionInfoTalentExplain:createCell()
	local cell = FashionInfoTalentExplain:new()
	cell:registerOnNodeEvent(cell)
	return cell
end