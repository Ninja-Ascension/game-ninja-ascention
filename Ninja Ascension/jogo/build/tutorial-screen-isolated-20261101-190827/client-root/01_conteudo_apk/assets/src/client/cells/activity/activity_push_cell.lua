-- ----------------------------------------------------------------------------------------------------
-- 说明：活动推送单个cell
-------------------------------------------------------------------------------------------------------
ActivityPushCell = class("ActivityPushCellClass", Window)
    
function ActivityPushCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.activityInfo = nil
	self.isFourProps = false -- 是否有四个道具   两种情况1：一个道具 2：四个道具
	self.propsInfo = nil -- 道具数据
	app.load("client.cells.utils.resources_icon_cell")
end

function ActivityPushCell:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	if self.activityInfo == nil then 
		return
	end
	ccui.Helper:seekWidgetByName(root, "Text_top"):setString(self.activityInfo.activityTitle)
	ccui.Helper:seekWidgetByName(root, "Text_miaoshu2"):setString(self.activityInfo.activityInfo)
	ccui.Helper:seekWidgetByName(root, "Panel_land_list"):setBackGroundImage(string.format("images/ui/activity/ativity_%s.png", "".. activity_push_pic[zstring.tonumber(self.activityInfo.activityId)]))
	        
    local propList = ccui.Helper:seekWidgetByName(root, "ListView_11")
    propList:removeAllItems()
    if self.propsInfo ~= nil then 
        for k,v in pairs(self.propsInfo) do
            local items = zstring.split("".. v, ";")
            local cell = ResourcesIconCell:createCell()
            cell:init(zstring.tonumber(items[1]), 0,items[2])
			cell:showName(items[2],zstring.tonumber(items[1]))

            propList:addChild(cell)
        end
    end
end

function ActivityPushCell:init(info)

	self.activityInfo = info
	self:onInit()
	return self
end

function ActivityPushCell:onInit()
	
    self.propsInfo = zstring.split(""..self.activityInfo.activityProps , "-")
    local csbPath = ""
    if #self.propsInfo == 4 then
    	self.isFourProps = true
    	csbPath = "activity/wonderful/wonderful_tuijian_list_4.csb"
    else
    	self.isFourProps = false
		csbPath = "activity/wonderful/wonderful_tuijian_list_1.csb"
    end

    local csbAccumlateGotoCell = csb.createNode(csbPath)
    local root = csbAccumlateGotoCell:getChildByName("root")
    table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	local sizePanel = root:getChildByName("Panel_land_list")
	sizePanel:setTouchEnabled(false)
	self:setContentSize(sizePanel:getContentSize())
	self:onUpdateDraw()
end

function ActivityPushCell:createCell()
	local cell = ActivityPushCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end