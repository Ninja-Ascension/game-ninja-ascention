-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityRebelArmy = class("ActivityRebelArmyClass", Window)
    
function ActivityRebelArmy:ctor()
    self.super:ctor()
	app.load("client.cells.activity.accumlate_goto_cell.lua")
	self.roots = {}
	self.loaded = false
	self.typeIndex = 47
    -- Initialize ActivityRebelArmy state machine.
    local function init_ActivityRebelArmy_terminal()
		-- local activity_once_recharge_button_terminal = {
            -- _name = "activity_once_recharge_button",
            -- _init = function (terminal) 
            
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
					-- instance:onUpdateDraw111()
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
        -- state_machine.add(activity_once_recharge_button_terminal)
		
        state_machine.init()
    end
    
    -- call func init ActivityRebelArmy state machine.
    init_ActivityRebelArmy_terminal()
end

function ActivityRebelArmy:onUpdateDraw111()
	local root = self.roots[1]
	
	local activity = _ED.active_activity[self.typeIndex]
	local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	if rewardListView == nil then
		return
	end
	rewardListView:removeAllItems()
	for i, v in pairs(activity.activity_Info) do
		local cell = AccumlateGotoCell:createCell()
		cell:init(v,i,self.typeIndex)
		rewardListView:addChild(cell)
	end
end

function ActivityRebelArmy:loading_cell()
	if ActivityRebelArmy.cacheListView == nil then
		return 
	end
	local activity = _ED.active_activity[ActivityRebelArmy.typeIndex]
	local cell = AccumlateGotoCell:createCell()
	cell:init(activity.activity_Info[ActivityRebelArmy.asyncIndex],ActivityRebelArmy.asyncIndex,ActivityRebelArmy.typeIndex)
	ActivityRebelArmy.cacheListView:addChild(cell)
	ActivityRebelArmy.cacheListView:requestRefreshView()
	ActivityRebelArmy.asyncIndex = ActivityRebelArmy.asyncIndex + 1
end

function ActivityRebelArmy:onUpdateDraw()
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
		
		-- activityEndTime:setString(zstring.exchangeFrom(activity.activity_over_time))
		-- rewardEndTime:setString(zstring.exchangeFrom(activity.activity_draw_over_time))
		
		activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.activity_over_time)/1000)))
		-- FURY: `rewardEndTime` no esta en landed_gifts.csb de este proyecto; sin la guarda esto moria en el primer metodo sobre nil.
		if rewardEndTime ~= nil then
			rewardEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
												.."%m"..tipStringInfo_time_info[2]
												.."%d"..tipStringInfo_time_info[10]
												.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.activity_draw_over_time)/1000)))
		end
		
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		ActivityRebelArmy.asyncIndex = 1
		ActivityRebelArmy.cacheListView = rewardListView
		ActivityRebelArmy.typeIndex = self.typeIndex
		
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		for i, v in pairs(activity.activity_Info) do
			-- local cell = AccumlateRechargeableCell:createCell()
			-- cell:init(v,i)
			-- rewardListView:addChild(cell)
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
		end
	end
	
end

function ActivityRebelArmy:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function ActivityRebelArmy:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
 	self:initDraw()
end

function ActivityRebelArmy:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	ActivityRebelArmy.asyncIndex = 1
	ActivityRebelArmy.cacheListView = nil
end

function ActivityRebelArmy:onEnterTransitionFinish()
	-- local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
 --    local root = csbAccumlateRechargeable:getChildByName("root")
 --    table.insert(self.roots, root)
	-- self:addChild(csbAccumlateRechargeable)
	
	-- self:onUpdateDraw()

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
end

function ActivityRebelArmy:onExit()
	ActivityRebelArmy.asyncIndex = 1
	ActivityRebelArmy.cacheListView = nil
end

function ActivityRebelArmy:init()
	
end


function ActivityRebelArmy:createCell()
	local cell = ActivityRebelArmy:new()
	cell:registerOnNodeEvent(cell)
	return cell
end