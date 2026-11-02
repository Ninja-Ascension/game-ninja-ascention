-- ----------------------------------------------------------------------------------------------------
-- 说明：累计充值排行榜
-------------------------------------------------------------------------------------------------------
ActivityRechargebleRank = class("ActivityRechargebleRankClass", Window)
    
local activity_rechargeble_rank_open_terminal = {
    _name = "activity_rechargeble_rank_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local rechargeRank = ActivityRechargebleRankClass:new()
        rechargeRank:init()
        rechargeRank:registerOnNodeEvent(rechargeRank)
		rechargeRank:registerOnNoteUpdate(rechargeRank, 1)
        fwin:open(rechargeRank,fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(activity_rechargeble_rank_open_terminal)
state_machine.init()

function ActivityRechargebleRank:ctor()
    self.super:ctor()
	app.load("client.cells.activity.activity_rechargeble_rank_cell")
	self.roots = {}
	self.loaded = false
	
	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
    local function init_activity_rechargeble_rank_terminal()
		-- local lock_all_fighting_rank_terminal = {
  --           _name = "lock_all_fighting_rank",
  --           _init = function (terminal) 
  --               app.load("client.home.fame.FameHallShow")
  --           end,
  --           _inited = false,
  --           _instance = self,
  --           _state = 0,
  --           _invoke = function(terminal, instance, params) 
		-- 		fwin:open(FameHallShow:new(), fwin._viewdialog)
  --               return true
  --           end,
  --           _terminal = nil,
  --           _terminals = nil
  --       }
		-- state_machine.add(lock_all_fighting_rank_terminal)
  --       state_machine.init()
    end
    

    init_activity_rechargeble_rank_terminal()
end

function ActivityRechargebleRank:loading()

	if ActivityRechargebleRank.cacheListView == nil then
		return 
	end
	local arry = _ED.charts.recharge_rank_info
	for i, v in pairs(arry) do
		local cell = ActivityRechargebleRankCell:createCell()
		cell:init(arry[ActivityRechargebleRank.asyncIndex],ActivityRechargebleRank.asyncIndex,1)
		ActivityRechargebleRank.cacheListView:addChild(cell)
		ActivityRechargebleRank.cacheListView:requestRefreshView()
		ActivityRechargebleRank.asyncIndex = ActivityRechargebleRank.asyncIndex + 1
	end
end

function ActivityRechargebleRank:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[79]--
	if activity ~= nil then
		local activitybegTime = ccui.Helper:seekWidgetByName(root, "Text_32")	--开始时间
		local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_44")	--结束时间
		local rewardEndTime = ccui.Helper:seekWidgetByName(root, "Text_44_0")	--结束时间
			activitybegTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
												.."%m"..tipStringInfo_time_info[2]
												.."%d"..tipStringInfo_time_info[10]
												.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.begin_time)/1000)))
			activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
												.."%m"..tipStringInfo_time_info[2]
												.."%d"..tipStringInfo_time_info[10]
												.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.end_time)/1000)))	
									
			rewardEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.activity_draw_over_time)/1000)))	
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		ActivityRechargebleRank.asyncIndex = 1
		ActivityRechargebleRank.cacheListView = rewardListView
		self.currentListView = ActivityRechargebleRank.cacheListView
		self.currentInnerContainer = self.currentListView:getInnerContainer()
		self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
		
		if #rewardListView:getItems() > 0 then
			rewardListView:removeAllItems()
		end
		self:loading()
	end
end

function ActivityRechargebleRank:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/activity_charge_rank.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	local Button_4 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, {terminal_name = "lock_all_fighting_rank", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local function responseFightingRankInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots[1] ~= nil then
				response.node:onUpdateDraw()
			end
		end
	end
	NetworkManager:register(protocol_command.recharge_rank_init.code, nil, nil, nil, self, responseFightingRankInitCallback, false, nil)
end

function ActivityRechargebleRank:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
 	self:initDraw()
 	self:registerOnNoteUpdate(self, 1)
end

function ActivityRechargebleRank:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	ActivityRechargebleRank.asyncIndex = 1
	ActivityRechargebleRank.cacheListView = nil

	self.currentListView = nil
	self.currentInnerContainer = nil
	self:unregisterOnNoteUpdate(self)
end

function ActivityRechargebleRank:onUpdate(dt)

	if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
		local size = self.currentListView:getContentSize()
		local posY = self.currentInnerContainer:getPositionY()
		if self.currentInnerContainerPosY == posY then
			return
		end
		self.currentInnerContainerPosY = posY
		local items = self.currentListView:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
				v:unload()
			else
				v:reload()
			end
		end
	end
end

function ActivityRechargebleRank:onEnterTransitionFinish()

end

function ActivityRechargebleRank:onExit()

end

function ActivityRechargebleRank:init()
	
end


function ActivityRechargebleRank:createCell()
	local cell = ActivityRechargebleRank:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end