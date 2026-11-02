-- ----------------------------------------------------------------------------------------------------
-- 说明：杂货铺
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityVarietyShop = class("ActivityVarietyShopClass", Window)
    
function ActivityVarietyShop:ctor()
    self.super:ctor()
	app.load("client.cells.activity.variety_shop_cell")
	self.roots = {}
	self.loaded = false
	
	self.examples = {}
	
    -- Initialize ActivityVarietyShop state machine.
    local function init_ActivityVarietyShop_terminal()
		
		
        state_machine.init()
    end
    
    -- call func init ActivityVarietyShop state machine.
    init_ActivityVarietyShop_terminal()
end

function ActivityVarietyShop:loading_cell()
	if ActivityVarietyShop.cacheListView == nil then
		return 
	end
	local activity = _ED.active_activity[28]--
	local cell = VarietyShopCell:createCell()
	cell:init(self.examples[ActivityVarietyShop.asyncIndex], ActivityVarietyShop.asyncIndex)
	ActivityVarietyShop.cacheListView:addChild(cell)
	ActivityVarietyShop.cacheListView:requestRefreshView()
	ActivityVarietyShop.asyncIndex = ActivityVarietyShop.asyncIndex + 1
end

function ActivityVarietyShop:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[28]--
	if activity ~= nil then
		local countText = ccui.Helper:seekWidgetByName(root, "Text_45")
		local titleText = ccui.Helper:seekWidgetByName(root, "Text_032")
		if titleText ~= nil then
			titleText:setString(activity.activity_describe)
		end
		countText:setString(_string_piece_info[355])
		if ( __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh)
			and _tip_info_activity[28] ~= nil
			then
			titleText:setString(_tip_info_activity[28][1])
			countText:setString(_tip_info_activity[28][2])
		end

		local activityStartTime = ccui.Helper:seekWidgetByName(root, "Text_32")	--活动开始时间
		activityStartTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(activity.activity_start_day)))
		
		
		local activityEndTime = ccui.Helper:seekWidgetByName(root, "Text_44")	--活动截止时间
		activityEndTime:setString(os.date("%Y"..tipStringInfo_time_info[1]
											.."%m"..tipStringInfo_time_info[2]
											.."%d"..tipStringInfo_time_info[10]
											.."%H"..tipStringInfo_time_info[11], zstring.exchangeFrom(activity.activity_login_day)))
		
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
			ActivityVarietyShop.asyncIndex = 1
			ActivityVarietyShop.cacheListView = rewardListView
		end
		
		local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_1")	
		for i, v in ipairs(self.examples) do
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				or __lua_project_id == __lua_project_red_alert 
				then
				cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)	
			else
				local cell = VarietyShopCell:createCell()
				cell:init(v,i)
				rewardListView:addChild(cell)
			end
		end
	end
	
end

function ActivityVarietyShop:initDraw()
	local csbAccumlateRechargeable = csb.createNode("activity/wonderful/landed_gifts.csb")
    local root = csbAccumlateRechargeable:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbAccumlateRechargeable)
	
	self:onUpdateDraw()
end

function ActivityVarietyShop:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
 	self:initDraw()
end

function ActivityVarietyShop:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	ActivityVarietyShop.asyncIndex = 1
	ActivityVarietyShop.cacheListView = nil
end

function ActivityVarietyShop:onEnterTransitionFinish()
	
end

function ActivityVarietyShop:onExit()
	-- ActivityVarietyShop.asyncIndex = 1
	-- ActivityVarietyShop.cacheListView = nil
end

function ActivityVarietyShop:init()
	local activity = _ED.active_activity[28]--限时兑换活动
	self.examples = zstring.split(activity.activity_extra_prame, "\\r\\n")
	if _ED.variety_shop_exchang_times == nil or _ED.variety_shop_exchang_times == "" then
		_ED.variety_shop_exchang_times = zstring.split(activity.activity_extra_prame2, ",")
	end	
end


function ActivityVarietyShop:createCell()
	local cell = ActivityVarietyShop:new()
	cell:registerOnNodeEvent(cell)
	return cell
end