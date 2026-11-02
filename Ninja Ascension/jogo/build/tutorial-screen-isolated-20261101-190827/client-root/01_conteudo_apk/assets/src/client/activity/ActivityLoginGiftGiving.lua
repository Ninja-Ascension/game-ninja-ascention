-- ----------------------------------------------------------------------------------------------------
-- 说明：登陆送礼
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityLoginGiftGiving = class("ActivityLoginGiftGivingClass", Window)
    
function ActivityLoginGiftGiving:ctor()
    self.super:ctor()
	app.load("client.cells.activity.accumlate_rechargeable_cell")
	app.load("client.cells.activity.activity_login_gift_giving_cell")
	self.roots = {}
	self.loaded = false
	self.typeIndex = 24
	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
    -- Initialize ActivityLoginGiftGiving state machine.
    local function init_ActivityLoginGiftGiving_terminal()
		-- local activity_one_day_recharge_button_terminal = {
            -- _name = "activity_one_day_recharge_button",
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
		
        -- state_machine.add(activity_accumlate_recharge_button_terminal)
		
        state_machine.init()
    end
    
    -- call func init ActivityLoginGiftGiving state machine.
    init_ActivityLoginGiftGiving_terminal()
end

-- function ActivityLoginGiftGiving:onUpdateDraw()
	-- local root = self.roots[1]
	
	-- local activity = _ED.active_activity[self.typeIndex]--登陆送礼
	-- local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
	-- if rewardListView == nil then
		-- return
	-- end
	-- rewardListView:removeAllItems()
	-- for i, v in pairs(activity.activity_Info) do
		-- local cell = AccumlateRechargeableCell:createCell()
		-- cell:init(v,i,self.typeIndex)
		-- rewardListView:addChild(cell)
	-- end
-- end

function ActivityLoginGiftGiving:loading_cell()
	if ActivityLoginGiftGiving.cacheListView == nil then
		return 
	end
	local activity = _ED.active_activity[ActivityLoginGiftGiving.typeIndex]--登陆送礼
	local cell = ActivityLoginGiftGivingCell:createCell()
	cell:init(activity.activity_Info[ActivityLoginGiftGiving.asyncIndex],ActivityLoginGiftGiving.asyncIndex,ActivityLoginGiftGiving.typeIndex)
	ActivityLoginGiftGiving.cacheListView:addChild(cell)
	ActivityLoginGiftGiving.cacheListView:requestRefreshView()
	ActivityLoginGiftGiving.asyncIndex = ActivityLoginGiftGiving.asyncIndex + 1
end

function ActivityLoginGiftGiving:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.typeIndex]--登陆送礼
	if  activity ~= nil then
		local countText = ccui.Helper:seekWidgetByName(root, "Text_45")
		local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
		countText:setString(_tip_info_activity[self.typeIndex][2])
		if titleText ~= nil then
			titleText:setString(_tip_info_activity[self.typeIndex][1])
		end
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		ActivityLoginGiftGiving.asyncIndex = 1
		ActivityLoginGiftGiving.cacheListView = rewardListView
		ActivityLoginGiftGiving.typeIndex = self.typeIndex
		local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_32")	--开始时间
		local rewardEndTime = ccui.Helper:seekWidgetByName(root, "Text_44")	--结束时间
		
		activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(zstring.tonumber(activity.begin_time)/1000)))
		rewardEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(activity.end_time1)))	
		
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			then
			rewardEndTime:setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_33"):setVisible(false)
			activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(activity.end_time1)))
		end
		
		for i, v in pairs(activity.activity_Info) do
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
		end
	end

end

function ActivityLoginGiftGiving:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function ActivityLoginGiftGiving:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true

 	self:initDraw()
end

function ActivityLoginGiftGiving:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	ActivityLoginGiftGiving.asyncIndex = 1
	ActivityLoginGiftGiving.cacheListView = nil
end



function ActivityLoginGiftGiving:onEnterTransitionFinish()
	-- local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
 --    local root = csbAccumlateRechargeable:getChildByName("root")
 --    table.insert(self.roots, root)
	-- self:addChild(csbAccumlateRechargeable)
	
	-- self:onUpdateDraw()

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
end

function ActivityLoginGiftGiving:onExit()
	ActivityLoginGiftGiving.asyncIndex = 1
	ActivityLoginGiftGiving.cacheListView = nil
end

function ActivityLoginGiftGiving:init()
	
end




function ActivityLoginGiftGiving:createCell()
	local cell = ActivityLoginGiftGiving:new()
	cell:registerOnNodeEvent(cell)
	return cell
end