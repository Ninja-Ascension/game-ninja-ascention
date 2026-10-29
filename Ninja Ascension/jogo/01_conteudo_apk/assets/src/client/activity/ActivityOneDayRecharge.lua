-- ----------------------------------------------------------------------------------------------------
-- 说明：每日累积充值
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityOneDayRecharge = class("ActivityOneDayRechargeClass", Window)
    
function ActivityOneDayRecharge:ctor()
    self.super:ctor()
	app.load("client.cells.activity.accumlate_rechargeable_cell")
	self.roots = {}
	self.loaded = false
	self.typeIndex = 21
    -- Initialize ActivityOneDayRecharge state machine.
    local function init_ActivityOneDayRecharge_terminal()
		local activity_one_day_recharge_button_terminal = {
            _name = "activity_one_day_recharge_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.onUpdateDraw111 then
					instance:onUpdateDraw111()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(activity_one_day_recharge_button_terminal)
		
        state_machine.init()
    end
    
    -- call func init ActivityOneDayRecharge state machine.
    init_ActivityOneDayRecharge_terminal()
end

function ActivityOneDayRecharge:onUpdateDrawData()
	local root = self.roots[1]
	
	local activity = _ED.active_activity[self.typeIndex]--累充活动
	local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
	if rewardListView == nil then
		return
	end
	if __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then 
		return
	end
	rewardListView:removeAllItems()
	for i, v in pairs(activity.activity_Info) do
		local cell = AccumlateRechargeableCell:createCell()
		cell:init(v,i,self.typeIndex)
		rewardListView:addChild(cell)
	end
	rewardListView:requestRefreshView()
end

function ActivityOneDayRecharge:onUpdateDraw111()
	local root = self.roots[1]
	
	local activity = _ED.active_activity[self.typeIndex]--累充活动
	local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
	if rewardListView == nil then
		return
	end
	rewardListView:removeAllItems()
	for i, v in pairs(activity.activity_Info) do
		local cell = AccumlateRechargeableCell:createCell()
		cell:init(v,i,self.typeIndex)
		rewardListView:addChild(cell)
	end
end

function ActivityOneDayRecharge:loading_cell()
	if ActivityOneDayRecharge.cacheListView == nil then
		return 
	end
	local activity = _ED.active_activity[ActivityOneDayRecharge.typeIndex]--累充活动
	local cell = AccumlateRechargeableCell:createCell()
	cell:init(activity.activity_Info[ActivityOneDayRecharge.asyncIndex],ActivityOneDayRecharge.asyncIndex,ActivityOneDayRecharge.typeIndex)
	ActivityOneDayRecharge.cacheListView:addChild(cell)
	ActivityOneDayRecharge.cacheListView:requestRefreshView()
	ActivityOneDayRecharge.asyncIndex = ActivityOneDayRecharge.asyncIndex + 1
end

function ActivityOneDayRecharge:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.typeIndex]--累充活动
	if activity ~= nil then
		local countText = ccui.Helper:seekWidgetByName(root, "Text_45")
		local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
		if titleText ~= nil then
			titleText:setString(_tip_info_activity[self.typeIndex][1])
		end
		countText:setString(_tip_info_activity[self.typeIndex][2])
		local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_32")	--活动截止时间
		local rewardEndTime = ccui.Helper:seekWidgetByName(root, "Text_44")	--领奖截止时间
		
		-- activityEndTime:setString(zstring.exchangeFrom(activity.begin_time))
		-- rewardEndTime:setString(zstring.exchangeFrom(activity.end_time))
		activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(activity.begin_time)/1000))))
		rewardEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(activity.end_time)/1000))))	
		
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		ActivityOneDayRecharge.asyncIndex = 1
		ActivityOneDayRecharge.cacheListView = rewardListView
		ActivityOneDayRecharge.typeIndex = self.typeIndex
		
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			then
		else
			local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
			for i, v in pairs(activity.activity_Info) do
				-- local cell = AccumlateRechargeableCell:createCell()
				-- cell:init(v,i)
				-- rewardListView:addChild(cell)
				cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
			end
		end
	end
	
end

function ActivityOneDayRecharge:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function ActivityOneDayRecharge:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
 	self:initDraw()
end

function ActivityOneDayRecharge:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	ActivityOneDayRecharge.asyncIndex = 1
	ActivityOneDayRecharge.cacheListView = nil
end

function ActivityOneDayRecharge:onEnterTransitionFinish()
	-- local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
 --    local root = csbAccumlateRechargeable:getChildByName("root")
 --    table.insert(self.roots, root)
	-- self:addChild(csbAccumlateRechargeable)
	
	-- self:onUpdateDraw()

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
end

function ActivityOneDayRecharge:onExit()
	ActivityOneDayRecharge.asyncIndex = 1
	ActivityOneDayRecharge.cacheListView = nil
end

function ActivityOneDayRecharge:init()
	
end


function ActivityOneDayRecharge:createCell()
	local cell = ActivityOneDayRecharge:new()
	cell:registerOnNodeEvent(cell)
	return cell
end