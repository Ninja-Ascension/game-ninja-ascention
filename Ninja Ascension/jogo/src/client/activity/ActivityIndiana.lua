-- ----------------------------------------------------------------------------------------------------
-- 说明：夺宝活动
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityIndiana = class("ActivityIndianaClass", Window)
    
function ActivityIndiana:ctor()
    self.super:ctor()
	app.load("client.cells.activity.activity_indiana_list_cell.lua")
	self.roots = {}
	self.loaded = false
	self.typeIndex = 63
    -- Initialize ActivityIndiana state machine.
    local function init_ActivityIndiana_terminal()
		
		
        state_machine.init()
    end
    
    -- call func init ActivityIndiana state machine.
    init_ActivityIndiana_terminal()
end

function ActivityIndiana:onUpdateDraw111()
	local root = self.roots[1]
	
	local activity = _ED.active_activity[self.typeIndex]
	local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	if rewardListView == nil then
		return
	end
	rewardListView:removeAllItems()
	for i, v in pairs(activity.activity_Info) do
		local cell = ActivityIndianaListCell:createCell()
		cell:init(v,i,self.typeIndex)
		rewardListView:addChild(cell)
	end
end

function ActivityIndiana:loading_cell()
	if ActivityIndiana.cacheListView == nil then
		return 
	end
	local activity = _ED.active_activity[ActivityIndiana.typeIndex]
	local cell = ActivityIndianaListCell:createCell()
	cell:init(activity.activity_Info[ActivityIndiana.asyncIndex],ActivityIndiana.asyncIndex,ActivityIndiana.typeIndex)
	ActivityIndiana.cacheListView:addChild(cell)
	ActivityIndiana.cacheListView:requestRefreshView()
	ActivityIndiana.asyncIndex = ActivityIndiana.asyncIndex + 1
end

function ActivityIndiana:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.typeIndex]
	if activity ~= nil then
		local countText = ccui.Helper:seekWidgetByName(root, "Text_45")
		local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
		if titleText ~= nil then
			titleText:setString(_tip_info_activity[self.typeIndex][1])
		end
		countText:setString(_tip_info_activity[self.typeIndex][2])		
		-- titleText:setString("夺宝活动")
		-- countText:setString("夺宝活动--夺宝活动")
		local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_32")	--活动截止时间
		local rewardEndTime = ccui.Helper:seekWidgetByName(root, "Text_44")	--领奖截止时间
		
		-- activityEndTime:setString(zstring.exchangeFrom(activity.begin_time))
		-- rewardEndTime:setString(zstring.exchangeFrom(activity.end_time))
		
		activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.begin_time)/1000)))
		rewardEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.end_time)/1000)))	
		
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		ActivityIndiana.asyncIndex = 1
		ActivityIndiana.cacheListView = rewardListView
		ActivityIndiana.typeIndex = self.typeIndex
		
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		for i, v in pairs(activity.activity_Info) do
			-- local cell = AccumlateRechargeableCell:createCell()
			-- cell:init(v,i)
			-- rewardListView:addChild(cell)
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
		end
	end
	
end

function ActivityIndiana:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function ActivityIndiana:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
 	self:initDraw()
end

function ActivityIndiana:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	ActivityIndiana.asyncIndex = 1
	ActivityIndiana.cacheListView = nil
end

function ActivityIndiana:onEnterTransitionFinish()
	-- local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
 --    local root = csbAccumlateRechargeable:getChildByName("root")
 --    table.insert(self.roots, root)
	-- self:addChild(csbAccumlateRechargeable)
	
	-- self:onUpdateDraw()

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
end

function ActivityIndiana:onExit()
	ActivityIndiana.asyncIndex = 1
	ActivityIndiana.cacheListView = nil
end

function ActivityIndiana:init()
	
end


function ActivityIndiana:createCell()
	local cell = ActivityIndiana:new()
	cell:registerOnNodeEvent(cell)
	return cell
end