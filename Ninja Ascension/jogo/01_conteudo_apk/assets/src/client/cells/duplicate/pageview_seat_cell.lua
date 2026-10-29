----------------------------------------------------------------------------------------------------
-- 说明：副本界面选项卡Seat
-------------------------------------------------------------------------------------------------------
PageViewSeat = class("PageViewSeatClass", Window)

function PageViewSeat:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
	self.cacheSeatBG = nil
	self.cacheNameText = nil		--章节名称
	self.cacheChapterText = nil		--章节编号
	
	self.cacheAction = nil		--缓存动画
	self.cacheBackGround = nil	--缓存背景图层 根据NPC颜色 更换
	self.cacheNpcBox = nil		--隐藏的NPC宝箱
	
	self.npcID = 0
	self.npcState = 0			--npc攻击状态  0：打过  1：可攻击  2:锁定
	
	self.sceneID = 0			--场景ID
	self.sceneNum = 0			--关卡编号
	
	self.sprite_image = nil
	self.sprite_quality = nil

	-- 初始化武将小像事件响应需要使用的状态机
	local function init_page_view_seat_cell_terminal()
		
		-- 设计在阵容界面，点击武将小图像需要处理的逻辑
		-- local click_page_view_seat_terminal = {
            -- _name = "click_page_view_seat",
            -- _init = function (terminal) 
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
            	--> print("click_page_view_seat Click")
				-- --local icon = 
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- 添加需要使用的状态机到状态机管理器去
		-- state_machine.add(click_page_view_seat_terminal)
        state_machine.init()
	end
	init_page_view_seat_cell_terminal()
end

function PageViewSeat:onUpdateDraw()

	local root = self.roots[1]
	
	--如果是下一关卡的话 哈哈
	if self.npcID == -1 then
		ccui.Helper:seekWidgetByName(root, "Panel_star_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_star_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_star_3"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(root, "Image_4"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(false)
		self.sprite_image:setTexture("map/pve_npc/fuben_gk_next.png")
		self.sprite_quality:setVisible(false)
		return
	--如何是上一关
	elseif self.npcID == -10 then
		ccui.Helper:seekWidgetByName(root, "Panel_star_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_star_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_star_3"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(root, "Image_4"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(false)
		self.sprite_image:setTexture("map/pve_npc/fuben_gk_return.png")
		self.sprite_quality:setVisible(false)
		return
	end
	
	-- 根据挑战次数 绘制底板颜色 以及背景图 99次为普通怪 10为精英怪 5次为BOSS
	local mapIndex = dms.int(dms["npc"], self.npcID, npc.map_index)
	self.sprite_image:setTexture("map/pve_npc/fuben_gk_" .. mapIndex .. ".png")

	-- 绘制NPC的品质底框
	local qualityImageIndex = dms.int(dms["npc"], self.npcID, npc.base_pic)
	self.sprite_quality:setTexture(string.format("images/ui/quality/plot_npc_%d.png", qualityImageIndex))
	
	--设置关卡名称
	-- self.cacheNameText:setString(dms.string(dms["npc"], self.npcID, npc.npc_name))
	
	--绘制星星状态
	local maxStar = tonumber(dms.string(dms["npc"], self.npcID, npc.difficulty_include_count))
	local CurStar = 0
	if zstring.tonumber(_ED.npc_state[tonumber(""..self.npcID)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..self.npcID)]) and zstring.tonumber(_ED.npc_state[tonumber(""..self.npcID)]) ~= 0 then
		CurStar = tonumber(_ED.npc_max_state[tonumber(""..self.npcID)])
	else
		CurStar = tonumber(_ED.npc_state[tonumber(""..self.npcID)])
	end
	 	--tonumber(_ED.npc_state[dms.string(dms["npc"],self.npcId,npc.id)])
	--> print("star star star star star star", CurStar)
	
	local root = self.roots[1]
	if CurStar == 1 then  
		ccui.Helper:seekWidgetByName(root, "Panel_star_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_star_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_star_3"):setVisible(false)
	elseif CurStar == 2 then 
		ccui.Helper:seekWidgetByName(root, "Panel_star_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_star_2"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_star_3"):setVisible(false)
	elseif CurStar == 3 then
		ccui.Helper:seekWidgetByName(root, "Panel_star_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_star_2"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_star_3"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Panel_star_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_star_2"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_star_3"):setVisible(false)
	end
	
	--显示章节编号
	self.cacheChapterText:setString(self.sceneID .. "-" .. self.sceneNum)
	
	--判断NPC宝箱是否显示
	local npcIdListStr = dms.string(dms["pve_scene"], self.sceneID, pve_scene.design_npc)
	local npcIDTable = zstring.split(npcIdListStr, ",")
	local checkResult = self:checkNpcTableForNpcID(npcIDTable, self.npcID)
	
	if checkResult == true then
		self.cacheNpcBox:setVisible(true)
	end
end

--检测table中是否包含传入的NPCid
function PageViewSeat:checkNpcTableForNpcID(npcIDTable, npcID)
	for i, v in pairs(npcIDTable) do
		if v == npcID then
			return true
		end
	end
	return false
end

--动画从头播放到尾
function PageViewSeat:playActionToDuration()
	if self.cacheAction ~= nil then
		self.cacheAction:gotoFrameAndPlay(0, self.cacheAction:getDuration(), false)
	end	
	-- self.cacheAction:play(actionName, false)
end

function PageViewSeat:resetName(value)
	if value == true then
		self.cacheNameText:setString("")
	else
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        local name_info = ""
	        local name_data = zstring.split(dms.string(dms["npc"], self.npcID, npc.npc_name), "|")
	        for i, v in pairs(name_data) do
	            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
	            name_info = name_info..word_info[3]
	        end
	        self.cacheNameText:setString(name_info)
	    else
	    	self.cacheNameText:setString(dms.string(dms["npc"], self.npcID, npc.npc_name))
	    end
	end
end

function PageViewSeat:onEnterTransitionFinish()
end
function PageViewSeat:onInit()
	local csbItem = csb.createNode("duplicate/pve_guangqia.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("duplicate/pve_guangqia.csb")
	root:runAction(action)
	self.cacheAction = action
	
	--隐藏关卡宝箱
	self.cacheNpcBox = ccui.Helper:seekWidgetByName(root, "Panel_1")
	self.cacheNpcBox:setVisible(false)
	
	-- self.cacheSeatArt = ccui.Helper:seekWidgetByName(root, "PageSeat")
	self.cacheSeatBG = ccui.Helper:seekWidgetByName(root, "Panel_2")
	
	--穿透点击 让被遮挡的物体也响应点击事件
	-- self.cacheSeatArt:setSwallowTouches(false)
	self.cacheSeatBG:setSwallowTouches(false)
	self:setContentSize(root:getContentSize())
	
	local function cacheListViewTouchCallback(sender, eventType)
		
		-- local _spoint = sender:getTouchBeganPosition()
		-- local _mpoint = sender:getTouchMovePosition()
		-- local _epoint = sender:getTouchEndPosition()
		
		if eventType == ccui.TouchEventType.began then
		    --> print("Touch Down")
			state_machine.excute("page_stage_play_action", 0, "open")
			state_machine.excute("pve_bottom_play_action", 0, "open")
			state_machine.excute("page_view_clean_all_seat_name", 0, "event page_view_clean_all_seat_name")
			--> print("self.npcState self.npcState self.npcState", self.npcState)
		elseif eventType == ccui.TouchEventType.moved then
		    --> print("PageViewSeat Touch Move")
			-- local px = self:getPercent():getPositionX()
			--> print(string.format("  X= %s,   Y= %s  ", px, 0))
			state_machine.excute("page_view_scrolling", 0, "event page_view_scrolling.")
		elseif eventType == ccui.TouchEventType.ended then
		    --> print("Touch Up")
			state_machine.excute("page_view_seat_click", 0, { click = self })
			sender._one_called = true
		elseif eventType == ccui.TouchEventType.canceled then
			--> print("Touch Cancel")
			state_machine.excute("page_view_scrolling_for_cancel_terminal", 0, "event page_view_scrolling_for_cancel_terminal.")
		end
	end
	
	self.sprite_image = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("Sprite_guangqiatu")
	self.sprite_quality = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("Sprite_guangqpinzhi")

	local clickPanel = ccui.Helper:seekWidgetByName(root, "Panel_guangqiatu")
	self.cacheBackGround = clickPanel
	clickPanel.callback = cacheListViewTouchCallback
	clickPanel:addTouchEventListener(cacheListViewTouchCallback)
	
	-- 面板被点击了
	-- fwin:addTouchEventListener(self.cacheSeatBG, nil, 
	-- {
		-- terminal_name = "page_view_seat_click", 
		-- next_terminal_name = "", 
		-- but_image = "", 	
		-- terminal_state = 0, 
		-- isPressedActionEnabled = false,
		-- click = self
	-- }, 
	-- nil, 0)
	
	--章节编号
	self.cacheChapterText = ccui.Helper:seekWidgetByName(root, "Text_fuben")
	
	--章节名称
	self.cacheNameText = ccui.Helper:seekWidgetByName(root, "Text_fuben_name")
	
	-- self.cacheFrame = ccui.Helper:seekWidgetByName(root, "Image_gq_bg_1")
	-- self.cacheFrame:setVisible(false)

	-- self.cacheFrame = ccui.Helper:seekWidgetByName(root, "Image_gq_bg_1")
	-- self.cacheFrame:setVisible(false)
	
	--开始绘制
	self:onUpdateDraw()
end

--显示选择框
function PageViewSeat:setBgScale(value)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
	
	else
		self.cacheSeatBG:setScale(value)
	end
end

function PageViewSeat:onShow()
	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_312"):setVisible(true)
end

function PageViewSeat:onHide()
	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_312"):setVisible(false)
end

function PageViewSeat:resetBgScale()
	self.cacheSeatBG:setScale(1)
end


function PageViewSeat:onExit()
	-- state_machine.remove("click_page_view_seat")
	-- state_machine.remove("equip_icon_cell_change_equip_storage")
end

--锁定关卡
function PageViewSeat:lock()
	-- self.npcState == 2
	self.cacheChapterText:setString(_string_piece_info[133])
	-- self.cacheBackGround:setTouchEnabled(false)
	display:gray(self.sprite_image)
	display:gray(self.sprite_quality)
	display:gray(self.cacheNpcBox:getChildByName("Sprite_1"))
end

--解锁关卡
function PageViewSeat:upLock()
	self:onUpdateDraw()
end

function PageViewSeat:init(value, state, sceneID, sceneNum)
	self.npcID = value
	self.npcState = state
	self.sceneID = sceneID				--场景ID
	self.sceneNum = sceneNum			--关卡编号
	self:onInit()
end


function PageViewSeat:createCell()
	local cell = PageViewSeat:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

