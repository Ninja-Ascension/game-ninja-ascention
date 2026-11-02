-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场活动
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityArean = class("ActivityAreanClass", Window)
    
function ActivityArean:ctor()
    self.super:ctor()
	app.load("client.cells.activity.activity_arean_list_cell.lua")
	self.roots = {}
	self.loaded = false
	self.typeIndex = 64
    -- Initialize ActivityArean state machine.
    local function init_ActivityArean_terminal()
		
		
        state_machine.init()
    end
    
    -- call func init ActivityArean state machine.
    init_ActivityArean_terminal()
end

function ActivityArean:onUpdateDraw111()
	local root = self.roots[1]
	
	local activity = _ED.active_activity[self.typeIndex]
	local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	if rewardListView == nil then
		return
	end
	rewardListView:removeAllItems()
	for i, v in pairs(activity.activity_Info) do
		local cell = ActivityAreanListCell:createCell()
		cell:init(v,i,self.typeIndex)
		rewardListView:addChild(cell)
	end
end

function ActivityArean:loading_cell()
	if ActivityArean.cacheListView == nil then
		return 
	end
	local activity = _ED.active_activity[ActivityArean.typeIndex]
	local cell = ActivityAreanListCell:createCell()
	cell:init(activity.activity_Info[ActivityArean.asyncIndex],ActivityArean.asyncIndex,ActivityArean.typeIndex)
	ActivityArean.cacheListView:addChild(cell)
	ActivityArean.cacheListView:requestRefreshView()
	ActivityArean.asyncIndex = ActivityArean.asyncIndex + 1
end

function ActivityArean:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.typeIndex]
	if activity ~= nil then
		local countText = ccui.Helper:seekWidgetByName(root, "Text_45")
		local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
		if titleText ~= nil then
			titleText:setString(_tip_info_activity[self.typeIndex][1])
		end
		countText:setString(_tip_info_activity[self.typeIndex][2])		

		local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_32")	--活动截止时间
		local rewardEndTime = ccui.Helper:seekWidgetByName(root, "Text_44")	--领奖截止时间
		

		
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
		ActivityArean.asyncIndex = 1
		ActivityArean.cacheListView = rewardListView
		ActivityArean.typeIndex = self.typeIndex
		
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		for i, v in pairs(activity.activity_Info) do
			-- local cell = AccumlateRechargeableCell:createCell()
			-- cell:init(v,i)
			-- rewardListView:addChild(cell)
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
		end
	end
	
end

function ActivityArean:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function ActivityArean:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
 	self:initDraw()
end

function ActivityArean:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	ActivityArean.asyncIndex = 1
	ActivityArean.cacheListView = nil
end

function ActivityArean:onEnterTransitionFinish()
	-- local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
 --    local root = csbAccumlateRechargeable:getChildByName("root")
 --    table.insert(self.roots, root)
	-- self:addChild(csbAccumlateRechargeable)
	
	-- self:onUpdateDraw()

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
end

function ActivityArean:onExit()
	ActivityArean.asyncIndex = 1
	ActivityArean.cacheListView = nil
end

function ActivityArean:init()
	
end


function ActivityArean:createCell()
	local cell = ActivityArean:new()
	cell:registerOnNodeEvent(cell)
	return cell
end