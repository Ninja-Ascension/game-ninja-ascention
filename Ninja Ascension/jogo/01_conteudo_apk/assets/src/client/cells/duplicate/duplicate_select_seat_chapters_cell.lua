----------------------------------------------------------------------------------------------------
-- 说明：副本界面选项卡Seat
-------------------------------------------------------------------------------------------------------
DuplicateSelectSeatChaptersCell = class("DuplicateSelectSeatChaptersCellClass", Window)

function DuplicateSelectSeatChaptersCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}			-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.mySceneID = 0		-- 场景ID
	self.actions = {}
	
	self.cacheSceneNameText = nil	--场景名称text
	self.cacheSeatBG = nil
	self.cacheBackGround = nil
	
	self.getStarCount = 0
	self.sceneStarNum = 0

	self.currentPageType = 0
	
	self.isHighlighted = nil
	
	--通关状态文本
	self.cacheCompleteStatusText = nil
	self.cacheCompleteStatusImage = nil
	self.cacheChapterText = nil				--章节显示文本

	-- 初始化武将小像事件响应需要使用的状态机
	-- local function init_duplicate_select_seat_terminal()
		
		-- -- 自己被点击了哦哦哦哦哦
		-- local duplicate_select_seat_click_terminal = {
            -- _name = "duplicate_select_seat_click",
            -- _init = function (terminal) 
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
			
				-- local sceneID = params._datas.sceneID
				-- local owner = params._datas.owner
				-- local currentPageType = params._datas.currentPageType
				-- state_machine.excute("duplicate_page_controller_change_scene", 0, {_datas = { sceneID = sceneID, currentPageType = currentPageType }})

                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- --添加需要使用的状态机到状态机管理器去
		-- state_machine.add(duplicate_select_seat_click_terminal)
        -- state_machine.init()
	-- end
	
	-- init_duplicate_select_seat_terminal()
end

function DuplicateSelectSeatChaptersCell:onUpdateDraw()
	--显示关卡名称
	local name = dms.string(dms["pve_scene"], tonumber(self.mySceneID), pve_scene.scene_name)
	self.cacheSceneNameText:setString(name)
	
	--绘制关卡背景
	--self.cacheBackGround:setBackGroundImage("images/ui/pve_sn/pve_duplicate_" .. dms.int(dms["pve_scene"], self.mySceneID, pve_scene.scene_entry_pic) ..".png")
	
	--星星数量
	self.getStarCount = tonumber(_ED.get_star_count[self.mySceneID])
	self.sceneStarNum = dms.int(dms["pve_scene"], tonumber(self.mySceneID), pve_scene.total_star)
	if self.currentPageType ~= 3 then 
		self.cacheStarText:setString(self.getStarCount .. " / " .. self.sceneStarNum)
		self.cacheStarText_chosen:setString(self.cacheStarText:getString())
		--显示章节
		--self.cacheChapterText:setString(_string_piece_info[97] .. self.mySceneID .. _string_piece_info[98])
	end
	
	
	--显示通关状态 105 = 已通关 106 = 完美通关
	if self.getStarCount == self.sceneStarNum then
		-- self.cacheCompleteStatusText:setVisible(true)
		-- self.cacheCompleteStatusText:setString(_string_piece_info[106])
		-- self.cacheCompleteStatusImage:setVisible(true)
	else
		local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(self.mySceneID), pve_scene.npcs), ",")
		local sceneState = tonumber(_ED.scene_current_state[self.mySceneID])
		local isComplete = false
		
		for i = 1, table.getn(tempNpcIds) do
			if sceneState + 1 == i then
				isComplete = true
			elseif sceneState + 2 == i then
				isComplete = false
			elseif sceneState + 2 < i then
				isComplete = false
				break
			end
		end
		
		if isComplete == true then
			-- self.cacheCompleteStatusText:setVisible(true)
			-- self.cacheCompleteStatusText:setString(_string_piece_info[105])
			-- self.cacheCompleteStatusImage:setVisible(true)
		end
	end
end

--动画从头播放到尾
function DuplicateSelectSeatChaptersCell:playActionToDuration()
	-- self.cacheAction:gotoFrameAndPlay(0, self.cacheAction:getDuration(), false)
	-- self.cacheAction:play(actionName, false)
end

function DuplicateSelectSeatChaptersCell:initPlotCopy()
	-- local root = self.roots[1]

end

function DuplicateSelectSeatChaptersCell:initEliteCopy()
	-- local root = self.roots[1]

	-- --开始绘制
	-- self:onUpdateDraw()
end

function DuplicateSelectSeatChaptersCell:initGreatCopy()
	-- local root = self.roots[1]

	-- --开始绘制
	-- self:onUpdateDraw()
end

function DuplicateSelectSeatChaptersCell:onEnterTransitionFinish()
	local filePath = ""
	if self.currentPageType == 1 then
		filePath = "duplicate/pve_button.csb"
	elseif self.currentPageType == 2 then
		filePath = "duplicate/pve_button.csb" --"duplicate/pve_zhangjie_list_jy.csb"
	elseif self.currentPageType == 3 then
		filePath = "duplicate/pve_button.csb" --"duplicate/pve_zhangjie_list_mj.csb"
	end
	
	self.filePath = filePath
	
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	
	
	local Panel_20 = ccui.Helper:seekWidgetByName(root, "Panel_20")
	self:setContentSize(Panel_20:getContentSize())
	
	
	-- 按钮
	self.panel_button = ccui.Helper:seekWidgetByName(root, "Panel_3")
	--缓存显示星星数量文本
	self.cacheStarText = ccui.Helper:seekWidgetByName(root, "Text_star")
	
	-- 选中
	self.panel_chosen = ccui.Helper:seekWidgetByName(root, "Panel_1")
	--缓存显示星星数量文本
	self.cacheStarText_chosen = ccui.Helper:seekWidgetByName(root, "Text_2")
	
	self.cacheSceneNameText = ccui.Helper:seekWidgetByName(root, "Text_zhangjie_name")
	self.cacheSceneNameText:setSwallowTouches(false)
	self.cacheSceneNameText:setTouchEnabled(false)
	
	self.cacheSeatBG = ccui.Helper:seekWidgetByName(root, "Button_zhangjie_list")
	self:registerTouchEvent(self.cacheSeatBG)
	
	--缓存显示章节的文本
	--self.cacheChapterText = ccui.Helper:seekWidgetByName(root, "Text_zhangjie")
	
	--开始绘制
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    -- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
	self:onUpdateDraw()
	
	local Panel_tuisong = ccui.Helper:seekWidgetByName(root, "Panel_tuisong")
	
	Panel_tuisong._data = {self.mySceneID, self.currentPageType}
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_list_scene_the_chest",
	_widget = Panel_tuisong,
	_invoke = nil,
	_interval = 0.5,})
	
	self:setHighlighted(false)
end

function DuplicateSelectSeatChaptersCell:registerTouchEvent(trigger)
	local _self = self
	local function trigger_onTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if evenType == ccui.TouchEventType.began then
		elseif evenType == ccui.TouchEventType.moved then
		
		elseif evenType == ccui.TouchEventType.canceled then
		
		elseif evenType == ccui.TouchEventType.ended then
			_self:setHighlighted(true)
			
			local sceneID = _self.mySceneID
			local owner = _self
			local currentPageType = _self.currentPageType
			state_machine.excute("duplicate_page_controller_change_scene", 0, {_datas = { sceneID = sceneID, currentPageType = currentPageType }})
		end
	end
	trigger:addTouchEventListener(trigger_onTouchEvent)
end

function DuplicateSelectSeatChaptersCell:setHighlighted(isbool)
	self.cacheSeatBG:setHighlighted(isbool)
	local action = self.actions[1]
	local root = self.roots[1]
	
	if self.isHighlighted ~= isbool then
		self.isHighlighted = isbool
		
		self:showChosen(isbool)
		self:showButton(not isbool)
		
	end
end


-- 显示选中
function DuplicateSelectSeatChaptersCell:showChosen(isbool)
	self.panel_chosen:setVisible(isbool)
end


-- 显示按钮
function DuplicateSelectSeatChaptersCell:showButton(isbool)
	self.panel_button:setVisible(isbool)
end


function DuplicateSelectSeatChaptersCell:onExit()
	-- state_machine.remove("duplicate_select_seat_click")
	-- state_machine.remove("equip_icon_cell_change_equip_storage")
end

function DuplicateSelectSeatChaptersCell:getSceneID()
	return self.mySceneID
end


function DuplicateSelectSeatChaptersCell:init(value, _currentPageType)
	self.mySceneID = value
	self.currentPageType = _currentPageType
	return self
end


function DuplicateSelectSeatChaptersCell:createCell()
	local cell = DuplicateSelectSeatChaptersCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

