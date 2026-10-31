-- ----------------------------------------------------------------------------------------------------
-- 说明：top帮排行榜界面list
-------------------------------------------------------------------------------------------------------
ActivityTopRankHelpList = class("ActivityTopRankHelpListClass", Window)
function ActivityTopRankHelpList:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.treasure_instance = nil
	self.name = nil
	self.info = nil
	self.types = nil
    -- Initialize TreasureRebornPage page state machine.
end

function ActivityTopRankHelpList:onUpdateDraw()
	local root = self.roots[1]
	-- Text_biaoti
	-- Text_shuoming
	-- Panel_14
	self.width1 = 0
	self.hight1 = 0
	local name = ccui.Helper:seekWidgetByName(root, "Text_biaoti")
	local text = ccui.Helper:seekWidgetByName(root, "Text_shuoming")
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_14")
	local image = ccui.Helper:seekWidgetByName(root, "Image_18")
	local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
	name:setString(self.name)
	-- local frameAddCount = 18	--字体间距
	local Text_width = text:getPositionX()
	local Text_height = text:getPositionY()
	local sizeX = Panel_4:getContentSize().width
	local sizeY = Panel_4:getContentSize().height
	local Panel_14_high = panel:getPositionY()
	local Panel_14_width = panel:getPositionX()
	
	local label_UI = csb.createNode("utils/version_length.csb")
	local label_root = label_UI:getChildByName("root")
	local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
	local lableBaseSize = lableCell:getContentSize()
	local tipHeight = 0
	local _widthjian = 0 
	local _positionx = 0 
	_widthjian = 35
	_positionx = 10

	for i, v in pairs(self.info) do
		local lableCell_temp = nil
		if self.types == 5 then
			
		else
			lableCell_temp = cc.Label:createWithTTF(v, lableCell:getFontName(), 
			lableCell:getFontSize(), cc.size(lableBaseSize.width-_widthjian, 0), 
			cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		end
		lableCell_temp:setColor(cc.c3b(tipStringInfo_quality_color_Type[12][1],tipStringInfo_quality_color_Type[12][2],tipStringInfo_quality_color_Type[12][3]))
		panel:addChild(lableCell_temp)
		lableCell_temp:setAnchorPoint(CCPoint(0, 0))-->设置锚点
		local lableSize = lableCell_temp:getContentSize()
		
		tipHeight = tipHeight + lableSize.height
		lableCell_temp:setPosition(cc.p(lableCell_temp:getPositionX()+_positionx, -1 * tipHeight+30))
	end
	Panel_4:setContentSize(cc.size(sizeX,tipHeight + sizeY-image:getContentSize().height))
	self:setContentSize(cc.size(sizeX,sizeY))
	self.width1 = sizeX
	self.hight1 = (tipHeight + sizeY)
	panel:setPosition(Panel_14_width,Panel_14_high+tipHeight-image:getContentSize().height-30 +self.hight1 - image:getContentSize().height)
end

function ActivityTopRankHelpList:onEnterTransitionFinish()
	-- local refinery_help_list = csb.createNode("refinery/refinery_help_list.csb")
	-- self:addChild(refinery_help_list)
	-- local root = refinery_help_list:getChildByName("root")
	-- table.insert(self.roots, root)
	
	-- self:onUpdateDraw()
end
function ActivityTopRankHelpList:onInit( ... )
	local refinery_help_list = csb.createNode("refinery/refinery_help_list.csb")
	self:addChild(refinery_help_list)
	local root = refinery_help_list:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end

function ActivityTopRankHelpList:init(name, info,types)
	self.name = name
	self.info = info
	self.types = types
	self:onInit()
	self:setContentSize(cc.size(self.width1,self.hight1))
end

function ActivityTopRankHelpList:onExit()
end

function ActivityTopRankHelpList:createCell()
	local cell = ActivityTopRankHelpList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
