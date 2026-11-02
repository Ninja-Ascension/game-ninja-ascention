-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗力排行
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityFightingRank = class("ActivityFightingRankClass", Window)
    
function ActivityFightingRank:ctor()
    self.super:ctor()
	app.load("client.cells.activity.activity_fighting_rank_cell")
	self.roots = {}
	self.loaded = false
	
	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
    
    local function init_ActivityFightingRank_terminal()
		local lock_all_fighting_rank_terminal = {
            _name = "lock_all_fighting_rank",
            _init = function (terminal) 
                app.load("client.home.fame.FameHallShow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:open(FameHallShow:new(), fwin._viewdialog)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(lock_all_fighting_rank_terminal)
        state_machine.init()
    end
    

    init_ActivityFightingRank_terminal()
end

function ActivityFightingRank:loading()

	if ActivityFightingRank.cacheListView == nil then
		return 
	end

	local arry = _ED.charts.force
	-- local num =	tonumber(ActivityFightingRank.rankCount)
	for i, v in pairs(arry) do
		-- if i > 50 then
			-- return
		-- end 
		local cell = ActivityFightingRankCell:createCell()
		cell:init(arry[ActivityFightingRank.asyncIndex],ActivityFightingRank.asyncIndex,1)
		ActivityFightingRank.cacheListView:addChild(cell)
		ActivityFightingRank.cacheListView:requestRefreshView()
		ActivityFightingRank.asyncIndex = ActivityFightingRank.asyncIndex + 1
	end
end

function ActivityFightingRank:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[49]--
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
		ActivityFightingRank.asyncIndex = 1
		ActivityFightingRank.cacheListView = rewardListView
		self.currentListView = ActivityFightingRank.cacheListView
		self.currentInnerContainer = self.currentListView:getInnerContainer()
		self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
		
		if #rewardListView:getItems() > 0 then
			rewardListView:removeAllItems()
		end
		-- ActivityFightingRank.rankCount = 3
		self:loading()

	end
end

function ActivityFightingRank:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/activity_zhanlibang.csb")
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

	NetworkManager:register(protocol_command.user_combat_force_order_reward_init.code, nil, nil, nil, self, responseFightingRankInitCallback, false, nil)
	
end

function ActivityFightingRank:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
 	self:initDraw()
 	self:registerOnNoteUpdate(self, 1)
end

function ActivityFightingRank:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	ActivityFightingRank.asyncIndex = 1
	ActivityFightingRank.cacheListView = nil

	self.currentListView = nil
	self.currentInnerContainer = nil
	self:unregisterOnNoteUpdate(self)
end


function ActivityFightingRank:onUpdate(dt)

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

function ActivityFightingRank:onEnterTransitionFinish()

end

function ActivityFightingRank:onExit()

end

function ActivityFightingRank:init()
	
end


function ActivityFightingRank:createCell()
	local cell = ActivityFightingRank:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end