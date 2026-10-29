-- ----------------------------------------------------------------------------------------------------
-- 说明：活动 / 每日签到
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityDailySignIn = class("ActivityDailySignInClass", Window)
    
function ActivityDailySignIn:ctor()
    self.super:ctor()
	self.roots = {}
	app.load("client.cells.activity.everyday_sign_in_cell")
	self.index = 1
	self.loaded = false
	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0

    -- Initialize ActivityDailySignIn state machine.
    local function init_ActivityDailySignIn_terminal()
	-- 每日签到
		local everyday_sign_in_button_terminal = {
            _name = "everyday_sign_in_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					local mCell = params._datas._cell
					local index = 1
					self.index = index
					mCell:onUpdateDrawList()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 豪华签到
		local luxury_sign_in_button_terminal = {
            _name = "luxury_sign_in_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					local mCell = params._datas._cell
					local index = 2
					self.index = index
					mCell:onUpdateDrawList()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local activity_luxury_recharge_button_terminal = {
            _name = "activity_luxury_recharge_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
           			if instance ~= nil and instance.onUpdateDrawRecharge ~= nil then
						instance:onUpdateDrawRecharge()
					end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(everyday_sign_in_button_terminal)
		state_machine.add(luxury_sign_in_button_terminal)
		state_machine.add(activity_luxury_recharge_button_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityDailySignIn state machine.
    init_ActivityDailySignIn_terminal()
end

function ActivityDailySignIn:onUpdateDrawList()
	local root = self.roots[1]
	local myListViewOne = ccui.Helper:seekWidgetByName(root, "ListView_3")
	local myListViewTwo = ccui.Helper:seekWidgetByName(root, "ListView_4")
	local button_one =ccui.Helper:seekWidgetByName(root, "Button_mr_1")
	local button_two =ccui.Helper:seekWidgetByName(root, "Button_mr_2")
	local Text_hhmr_1 =ccui.Helper:seekWidgetByName(root, "Text_hhmr_1")
	local Panel_evey_day =ccui.Helper:seekWidgetByName(root, "Panel_evey_day")
	local Panel_luxury_sign =ccui.Helper:seekWidgetByName(root, "Panel_luxury_sign")
	if tonumber(self.index) == 1 then
		-- button_one:setBright(false)
		button_one:setTouchEnabled(false)
		button_one:setHighlighted(true)
		-- button_two:setBright(true)
		button_two:setTouchEnabled(true)
		button_two:setHighlighted(false)
		myListViewOne:setVisible(true)
		myListViewTwo:setVisible(false)
		Panel_evey_day:setVisible(true)
		Panel_luxury_sign:setVisible(false)

		self.currentListView = myListViewOne
		self.currentInnerContainer = myListViewOne:getInnerContainer()
		self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_warship_girl_b
			then 
			self.currentInnerContainerPosY = self.currentInnerContainerPosY -20 
		end
	elseif tonumber(self.index) == 2 then
		-- button_one:setBright(true)
		button_one:setTouchEnabled(true)
		button_one:setHighlighted(false)
		-- button_two:setBright(false)
		button_two:setTouchEnabled(false)
		button_two:setHighlighted(true)
		myListViewOne:setVisible(false)
		myListViewTwo:setVisible(true)
		Panel_luxury_sign:setVisible(true)
		Panel_evey_day:setVisible(false)

		self.currentListView = myListViewTwo
		self.currentInnerContainer = myListViewTwo:getInnerContainer()
		self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_warship_girl_b 
			then 
			self.currentInnerContainerPosY = self.currentInnerContainerPosY -20 
		end
	end
end
function ActivityDailySignIn:onUpdateDrawRecharge()
	local root = self.roots[1]
	local myListViewTwo = ccui.Helper:seekWidgetByName(root, "ListView_4")
	if nil ~= myListViewTwo then
		local items = myListViewTwo:getItems()
		local activity = _ED.active_activity[39]
		for i,v in pairs(items) do
			if tonumber(v.index) == tonumber(activity.activity_login_Max_day) then
				state_machine.excute("activity_luxury_recharge_cell_button", 0, v) 
			end
			
		end
	end
end

function ActivityDailySignIn.loading_cell1(texture)
	if ActivityDailySignIn.myListViewOne ~= nil then
		local activity = _ED.active_activity[38]--每日签到
		local cell = EverydaySignInCell:createCell()
		cell:init(activity.activity_Info[ActivityDailySignIn.myListViewOneIndex],ActivityDailySignIn.myListViewOneIndex,1)
		ActivityDailySignIn.myListViewOne:addChild(cell)
		ActivityDailySignIn.myListViewOne:requestRefreshView()
		local dayNumber = tonumber(activity.activity_login_day)-1
		if dayNumber == tonumber(ActivityDailySignIn.myListViewOneIndex) then
			ActivityDailySignIn.myListViewOne:getInnerContainer():setPosition(cc.p(cell:getContentSize().width,tonumber(cell:getContentSize().height)*dayNumber))
		end
		ActivityDailySignIn.myListViewOneIndex = ActivityDailySignIn.myListViewOneIndex + 1
	end
end


function ActivityDailySignIn.loading_cell_vip(texture)
	if ActivityDailySignIn.myListViewTwo ~= nil then
		local activity = _ED.active_activity[39]--豪华签到
		local cell = EverydaySignInCell:createCell()
		cell:init(activity.activity_Info[ActivityDailySignIn.myListViewTwoIndex],ActivityDailySignIn.myListViewTwoIndex,2)
		ActivityDailySignIn.myListViewTwo:addChild(cell)
		ActivityDailySignIn.myListViewTwo:requestRefreshView()
		local dayNumber = tonumber(activity.activity_login_Max_day)-1
		if dayNumber == tonumber(ActivityDailySignIn.myListViewTwoIndex) then
			ActivityDailySignIn.myListViewTwo:getInnerContainer():setPosition(cc.p(cell:getContentSize().width,tonumber(cell:getContentSize().height)*dayNumber))
		end
		ActivityDailySignIn.myListViewTwoIndex = ActivityDailySignIn.myListViewTwoIndex + 1
	end
end

-- function ActivityDailySignIn:onUpdateDrawData( ... )
-- 	self:onUpdateDraw()
-- end
function ActivityDailySignIn:onUpdateDraw()
	local root = self.roots[1]
	
	local myListViewOne = ccui.Helper:seekWidgetByName(root, "ListView_3")
	local myListViewTwo = ccui.Helper:seekWidgetByName(root, "ListView_4")
	local button_one =ccui.Helper:seekWidgetByName(root, "Button_mr_1")
	local button_two =ccui.Helper:seekWidgetByName(root, "Button_mr_2")
	local Text_hhmr_1 =ccui.Helper:seekWidgetByName(root, "Text_hhmr_1")
	local Panel_evey_day =ccui.Helper:seekWidgetByName(root, "Panel_evey_day")

	ActivityDailySignIn.myListViewOne = myListViewOne
	ActivityDailySignIn.myListViewOneIndex = 1
	ActivityDailySignIn.myListViewTwo = myListViewTwo
	ActivityDailySignIn.myListViewTwoIndex = 1

	self.currentListView = myListViewOne
	self.currentInnerContainer = myListViewOne:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()

	-- if self.index == 1 then
		-- button_one:setBright(false)
		button_one:setTouchEnabled(false)
		button_one:setHighlighted(true)
		-- button_two:setBright(true)
		button_two:setTouchEnabled(true)
		Panel_evey_day:setVisible(true)
		local activity = _ED.active_activity[38]--每日签到
		if #myListViewOne:getItems() > 0 then
			myListViewOne:removeAllItems()
		end
		if activity ~= nil then
			myListViewOne:setVisible(true)
			myListViewTwo:setVisible(false)
			for i, v in pairs(activity.activity_Info) do
				-- local cell = EverydaySignInCell:createCell()
				-- cell:init(v,i,1)
				-- myListViewOne:addChild(cell)
				-- local dayNumber = tonumber(activity.activity_login_day)-1
				-- if dayNumber == tonumber(i) then
				-- 	myListViewOne:getInnerContainer():setPosition(cc.p(cell:getContentSize().width,tonumber(cell:getContentSize().height)*dayNumber))
				-- end
				-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell1)
				self.loading_cell1(nil)
			end
		end
	-- elseif tonumber(self.index) == 2 then		
		--豪华签到
		-- button_one:setBright(true)
		-- button_one:setTouchEnabled(true)
		-- button_two:setBright(false)
		-- button_two:setTouchEnabled(false)
		local activity = _ED.active_activity[39]--豪华签到
		if #myListViewTwo:getItems() > 0 then
			myListViewTwo:removeAllItems()
		end
		if activity ~= nil then
			-- myListViewOne:setVisible(false)
			-- myListViewTwo:setVisible(true)
			for i, v in pairs(activity.activity_Info) do
				-- local cell = EverydaySignInCell:createCell()
				-- cell:init(v,i,2)
				-- myListViewTwo:addChild(cell)
				-- local dayNumber = tonumber(activity.activity_login_Max_day)-1
				-- if dayNumber == tonumber(i) then
				-- 	myListViewTwo:getInnerContainer():setPosition(cc.p(cell:getContentSize().width,tonumber(cell:getContentSize().height)*dayNumber))
				-- end
				-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell_vip)
				self.loading_cell_vip(nil)
			end
			-- local dayNumber = activity.activity_login_Max_day
			-- myListViewOne:getInnerContainer():setPosition(cc.p(data.lastX,data.lastY))
			-- Text_hhmr_1:setString(_string_piece_info[215]..activity.activity_login_day.._string_piece_info[216])
		end
	-- end
	
end

function ActivityDailySignIn.loading(texture)
	-- local _self = ActivityDailySignIn._self
	-- local csbActivityDailySignIn = csb.createNode("activity/wonderful/daily_attendance.csb")
	-- local root = csbActivityDailySignIn:getChildByName("root")
    -- table.insert(_self.roots, root)
	-- _self:addChild(csbActivityDailySignIn)
	local _self = ActivityDailySignIn._self
	local root = nil
	
	if table.getn(_self.roots) == 0 then
		local csbActivityDailySignIn = csb.createNode("activity/wonderful/daily_attendance.csb")
		root = csbActivityDailySignIn:getChildByName("root")
		table.insert(_self.roots, root)
		_self:addChild(csbActivityDailySignIn)
	end
	root = _self.roots[1]
	
	-- cc.Director:getInstance():getTextureCache():removeTexture(texture)
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	_self:onUpdateDraw()
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)	

		--每日签到
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mr_1"), nil, 
		{
			terminal_name = "everyday_sign_in_button", 
			terminal_state = 0, 
			_cell = _self,
			isPressedActionEnabled = true,
		},
		nil,0)
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_daily_attendance",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_mr_1"),
		_invoke = nil,
		_interval = 0.5,})			
		
		--豪华签到
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mr_2"), nil, 
		{
			terminal_name = "luxury_sign_in_button", 
			terminal_state = 0, 
			_cell = _self,
			isPressedActionEnabled = true,
		},
		nil,0)
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_luxury_sign",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_mr_2"),
		_invoke = nil,
		_interval = 0.5,})	
end

function ActivityDailySignIn:lazy()
	if self.loaded == true then
		-- if ActivityDailySignIn.myListViewOne ~= nil 
		-- 	or ActivityDailySignIn.myListViewTwo ~= nil then
		-- 	self:unload()
		-- 	self:lazy()
		-- end
		return
	end
	self.loaded = true
	ActivityDailySignIn._self = self
	-- -- cc.Director:getInstance():getTextureCache():removeTexture(texture)
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)	
	self.loading(nil)
end

function ActivityDailySignIn:unload()
	-- self:removeAllChildren(true)
	-- self.loaded = false
	-- self.roots = {}
	-- ActivityDailySignIn.myListViewOne = nil
	-- ActivityDailySignIn.myListViewOneIndex = 1
	-- ActivityDailySignIn.myListViewTwo = nil
	-- ActivityDailySignIn.myListViewTwoIndex = 1

	-- self.currentListView = nil
	-- self.currentInnerContainer = nil
end

function ActivityDailySignIn:onUpdate(dt)
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

function ActivityDailySignIn:onEnterTransitionFinish()
	-- 出于解决教学时,注册当前root到父级对象
    local _self = self
	local csbActivityDailySignIn = csb.createNode("activity/wonderful/daily_attendance.csb")
	local root = csbActivityDailySignIn:getChildByName("root")
    table.insert(_self.roots, root)
	_self:addChild(csbActivityDailySignIn)
end

function ActivityDailySignIn:onExit()
	ActivityDailySignIn.myListViewOne = nil
	ActivityDailySignIn.myListViewOneIndex = 1
	ActivityDailySignIn.myListViewTwo = nil
	ActivityDailySignIn.myListViewTwoIndex = 1

	self.currentListView = nil
	self.currentInnerContainer = nil
end

function ActivityDailySignIn:init()
end


function ActivityDailySignIn:createCell()
	local cell = ActivityDailySignIn:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end