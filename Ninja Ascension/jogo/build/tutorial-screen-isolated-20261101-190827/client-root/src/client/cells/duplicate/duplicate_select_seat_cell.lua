----------------------------------------------------------------------------------------------------
-- 说明：副本界面选项卡Seat
-------------------------------------------------------------------------------------------------------
local is2002 = false
local is2003 = false
if __lua_project_id == __lua_project_warship_girl_a 
or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
or __lua_project_id == __lua_project_koone
or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
then
	if dev_version >= 2003 then
		is2003 = true
	end
	if dev_version >= 2002 then
		is2002 = true
	end
end

DuplicateSelectSeatCell = class("DuplicateSelectSeatCellClass", Window)

DuplicateSelectSeatCell.__size = nil

function DuplicateSelectSeatCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}			-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.mySceneID = 0		-- 场景ID
	
	self.cacheSceneNameText = nil	--场景名称text
	self.cacheSeatBG = nil
	self.cacheBackGround = nil
	
	self.getStarCount = 0
	self.sceneStarNum = 0

	self.currentPageType = 0
	self.npcID = 0
	self.sceneID = 0
	self.sceneNum = 1
	self.filePath = ""
	
	self.isInvalid = false
	self.tipInfo = ""
	--通关状态文本
	self.cacheCompleteStatusText = nil
	self.cacheCompleteStatusImage = nil
	self.cacheChapterText = nil				--章节显示文本
	-- 初始化武将小像事件响应需要使用的状态机
	local function init_duplicate_select_seat_terminal()
		
		-- 自己被点击了哦哦哦哦哦
		local duplicate_select_seat_click_terminal = {
            _name = "duplicate_select_seat_click",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				TipDlg.drawTextDailog(cell.tipInfo)
	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local duplicate_select_seat_tent_fight_terminal = {
            _name = "duplicate_select_seat_tent_fight",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local npcID = params._datas.npcID 
				local npcState = params._datas.npcState 
				local sceneID = params._datas.sceneID 
				local sceneNum = params._datas.sceneNum 
				local currentPageType = params._datas.currentPageType 
				local isPass = params._datas.isPass 
				
				local cell = params._datas.cell
				app.load("client.duplicate.pve.PVEChallengeFamousTent") 
				panel = PVEChallengeFamousTent:new()
				panel:init(npcID, sceneID, currentPageType, sceneNum, isPass, npcState)
				fwin:open(panel, fwin._window)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--添加需要使用的状态机到状态机管理器去
		state_machine.add(duplicate_select_seat_click_terminal)
		state_machine.add(duplicate_select_seat_tent_fight_terminal)
        state_machine.init()
	end
	
	init_duplicate_select_seat_terminal()
end

function DuplicateSelectSeatCell:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end

	if __lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
		or __lua_project_id == __lua_project_yugioh then
		if  tonumber(self.currentPageType) == 3 then   -- 名将副本
			local open_scene = dms.string(dms["pve_scene"], self.mySceneID, pve_scene.open_scene) --被场景开启的id
			local list =  zstring.split(open_scene ,",")
			local  tentButton = ccui.Helper:seekWidgetByName(root, "Button_zhuming")
			local  shengli = ccui.Helper:seekWidgetByName(root, "Image_zhuming_sheng")
			local  zhumingname = ccui.Helper:seekWidgetByName(root, "Text_zhuming_name")	
			local  Imagezhumingh = ccui.Helper:seekWidgetByName(root, "Image_zhuming_h")	 --灰色
			local ispPass = false
			for i,v in ipairs(list) do
				v = tonumber(v)
				local tentType = dms.string(dms["pve_scene"], v, pve_scene.scene_type)
				if tentType ~= nil and tonumber(tentType) == 10 then    --有帐篷的场景
					local name = dms.string(dms["pve_scene"], v, pve_scene.scene_name)
					zhumingname:setString(name)
					local quality = 4
					zhumingname:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
					tentButton:setVisible(true)
					if self.isInvalid == false then   ---场景已开启
						tentButton:setTouchEnabled(true)
						tentButton:setBright(true)
					else
						tentButton:setTouchEnabled(false)
						tentButton:setBright(false)
					end
					local npcs = dms.string(dms["pve_scene"], v, pve_scene.npcs)
					if npcs == nil then
						break
					end
					local npc = tonumber(npcs)
					self.hasTentSceneId = true
					self.npcID = npc
					self.sceneID = v
					self.sceneNum = 1
					local npcState = tonumber(_ED.npc_state[npc])
					self.npcState = npcState
					if npcState > 0 then     --- 帐篷是否已通关
						ispPass = true
						-- shengli:setVisible(false)
						-- tentButton:setTouchEnabled(false)	
					else
						ispPass = false
						-- shengli:setVisible(false)
					end
					
				end
			end
			local npcs = dms.string(dms["pve_scene"], tonumber(self.mySceneID), pve_scene.npcs)
			npcs = zstring.split(npcs ,",") 
			local lastNPC = tonumber(npcs[#npcs])
			local npcState1 = tonumber(_ED.npc_state[lastNPC])
			if  self.hasTentSceneId == true and self.isInvalid == false then   -- 有帐篷
				if npcState1 > 0 then   ---当前场景是否已通关
					if ispPass == false then
						local animationName = "jianliang"
						local jsonFile = "images/ui/effice/zhuming_dengta/jianliang.json"
						local atlasFile = "images/ui/effice/zhuming_dengta/jianliang.atlas"
						local  zhumingnamedh = ccui.Helper:seekWidgetByName(root, "Panel_zhuming_0")
						zhumingnamedh:removeAllChildren(true)
						if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
							local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
							zhumingnamedh:addChild(animation)
							zhumingnamedh:setVisible(true)
						end
					elseif ispPass == true then
	
						shengli:setVisible(true)
						
						-- tentButton:setTouchEnabled(false)
						-- local animationName = "jianliang_1"
						-- local jsonFile = "images/ui/effice/zhuming_dengta_0/jianliang_1.json"
						-- local atlasFile = "images/ui/effice/zhuming_dengta_0/jianliang_1.atlas"
						-- local  zhumingnamedh = ccui.Helper:seekWidgetByName(root, "Panel_zhuming_1")
						-- if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
							-- local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
							-- zhumingnamedh:addChild(animation)
							-- zhumingnamedh:setVisible(true)
						-- end	
					end	
				else
					Imagezhumingh:setVisible(true)
					-- tentButton:setTouchEnabled(false)
				end
				fwin:addTouchEventListener(tentButton, nil, 
				{
					terminal_name = "duplicate_select_seat_tent_fight", 
					terminal_state = 0, 
					npcID = self.npcID ,
					npcState = self.npcState,
					sceneID = self.sceneID ,
					sceneNum = self.sceneNum ,
					currentPageType = self.currentPageType ,
					isPass = npcState1 ,
					cell = self
				},
				nil, 0)
			end	
		end
	end
	

	--显示关卡名称
	local name = dms.string(dms["pve_scene"], tonumber(self.mySceneID), pve_scene.scene_name)
	self.cacheSceneNameText:setString(name)
	local scene_entry_pic = dms.int(dms["pve_scene"], self.mySceneID, pve_scene.scene_entry_pic)
	--绘制关卡背景
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		self.cacheBackGround:setBackGroundImage("images/ui/pve/pve_chapter_pic_" .. scene_entry_pic ..".png")
	else
		self.cacheBackGround:setBackGroundImage("images/ui/pve_sn/pve_duplicate_" .. scene_entry_pic ..".png")
	end
	--星星数量
	self.getStarCount = tonumber(_ED.get_star_count[self.mySceneID])
	self.sceneStarNum = dms.int(dms["pve_scene"], tonumber(self.mySceneID), pve_scene.total_star)
	if self.currentPageType ~= 3 then 
		self.cacheStarText:setString(self.getStarCount .. " / " .. self.sceneStarNum)
		--显示章节
		local zjCount = self.mySceneID
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_warship_girl_b
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
			or __lua_project_id == __lua_project_yugioh
			then 
			if self.currentPageType == 2 then  --精英副本
				zjCount = zstring.tonumber(self.mySceneID) - 100

			end
		end
		self.cacheChapterText:setString(_string_piece_info[97] .. zjCount.. _string_piece_info[98])
	end
	
	local npcs = dms.string(dms["pve_scene"], tonumber(self.mySceneID), pve_scene.npcs)
	npcs = zstring.split(npcs ,",") 
	local lastNPC = tonumber(npcs[#npcs])
	local npcState = tonumber(_ED.npc_state[lastNPC])
	--显示通关状态 105 = 已通关 106 = 完美通关
	
	-- 调用当前场景中的最后一个npc的状态
	local Image_ko = ccui.Helper:seekWidgetByName(self.roots[1], "Image_ko")
	Image_ko:setVisible(false)
	if npcState > 0 then
		-- self.cacheCompleteStatusText:setVisible(true)
		-- self.cacheCompleteStatusText:setString(_string_piece_info[106])
		-- self.cacheCompleteStatusImage:setVisible(true)
		
		Image_ko:setVisible(true)
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
	
	
	local function isBegin()
		if self.getStarCount == 0 then
			return true
		end
		
		return false
	
	end
	-- 红警时刻暂时屏蔽教学
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		return false
	end
	if missionIsOver() == true and self.isInvalid == false then
		if zstring.tonumber(_ED.user_info.user_grade) <= 10 and self._tuition == nil and missionIsOver() == true and true == isBegin() then	
			self._tuition = TuitionController:new():init(nil)
			local psize = self:getContentSize()
			self._tuition:setPosition(cc.p(psize.width / 2, psize.height / 2))
			self:addChild(self._tuition, 1000)
			self._tuition:unlockWindow(nil)
			--self.lastTuition:setVisible(false)
		end
	end
end


function DuplicateSelectSeatCell:invalid()
	local root = self.roots[1]
	self.cacheBackGround:setColor(cc.c3b(55,55,55))
	
	self.isInvalid = true

	local open_condition_describe = dms.string(dms["pve_scene"], self.mySceneID, pve_scene.open_condition_describe) -- 开启条件描述
	local by_open_scene = dms.string(dms["pve_scene"], self.mySceneID, pve_scene.by_open_scene) --被场景开启的id
	
	local list =  zstring.split(by_open_scene ,",")
	for i,v in ipairs(list) do
		v = tonumber(v)	
		local npcs = dms.string(dms["pve_scene"], v, pve_scene.npcs)
		npcs = zstring.split(npcs ,",") 
		local lastNPC = tonumber(npcs[#npcs])
		local npcState = tonumber(_ED.npc_state[lastNPC])
		
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_yugioh
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_warship_girl_b
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
			then 
			if npcState <= 0  then
				if self.currentPageType == 3 then 
					--名将副本的配置表关卡不是顺序的，需要通过配置表找到关卡提示
					self.tipInfo = _string_piece_info[385] .. dms.string(dms["pve_scene"], v, pve_scene.scene_name)
				else
					self.tipInfo = dms.string(dms["pve_scene"], v+1, pve_scene.open_condition_describe)	
				end
				break 
			end
		else
			if npcState <= 0  then
				self.tipInfo = dms.string(dms["pve_scene"], v+1, pve_scene.open_condition_describe)
				break 
			end
		end
	end
	
end

--动画从头播放到尾
function DuplicateSelectSeatCell:playActionToDuration()
	self.cacheAction:gotoFrameAndPlay(0, self.cacheAction:getDuration(), false)
	-- self.cacheAction:play(actionName, false)
end

function DuplicateSelectSeatCell:initPlotCopy()
	local root = self.roots[1]

end

function DuplicateSelectSeatCell:initEliteCopy()
	local root = self.roots[1]

	--开始绘制
	self:onUpdateDraw()
end

function DuplicateSelectSeatCell:initGreatCopy()
	local root = self.roots[1]

	--开始绘制
	self:onUpdateDraw()
end

function DuplicateSelectSeatCell:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
		then
		return
	end
	local filePath = ""

	if __lua_project_id == __lua_project_yugioh then 
		if self.currentPageType == 1 then
			
			if  zstring.tonumber(self.mySceneID) %2 == 1 then  
				-- 右边开始
				filePath = "duplicate/pve_zhangjie_list.csb" 
			else
				--左边开始
				filePath = "duplicate/pve_zhangjie_list_1.csb" 
			end
		elseif self.currentPageType == 2 then
			filePath = "duplicate/pve_zhangjie_list_jy.csb"
		elseif self.currentPageType == 3 then
			if  zstring.tonumber(self.mySceneID) %2 == 1 then  
				-- 右边开始
				filePath = "duplicate/pve_zhangjie_list_mj.csb"
			else
				--左边开始
				filePath = "duplicate/pve_zhangjie_list_mj_1.csb"
			end
		end
	else
		if self.currentPageType == 1 then
			filePath = "duplicate/pve_zhangjie_list.csb"
		elseif self.currentPageType == 2 then
			filePath = "duplicate/pve_zhangjie_list_jy.csb"
		elseif self.currentPageType == 3 then
			filePath = "duplicate/pve_zhangjie_list_mj.csb"
		end
	end
	
	
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self:setContentSize(root:getContentSize())

	-- 列表控件动画播放
	local action = csb.createTimeline(filePath)
    root:runAction(action)
    action:play("list_view_cell_open", false)
	
	-- if self.currentPageType == 1 then
	-- 	self:initPlotCopy()
	-- elseif self.currentPageType == 2 then
	-- 	self:initEliteCopy()
	-- elseif self.currentPageType == 3 then
	-- 	self:initGreatCopy()
	-- end
	if self.currentPageType == 3 then
		ccui.Helper:seekWidgetByName(root, "Image_11_6"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_3_6_8"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_3_6_8"):setVisible(false)

	end
	self.cacheSceneNameText = ccui.Helper:seekWidgetByName(root, "Text_zhangjie_name")
	
	self.cacheSeatBG = ccui.Helper:seekWidgetByName(root, "Panel_2")
	self.cacheSeatBG:setSwallowTouches(false)
	
	local isGotoNPC = false
	
	if true == is2003 then
		isGotoNPC = true
	end

	--背景图 会根据关卡ID来替换背景图
	self.cacheBackGround = ccui.Helper:seekWidgetByName(root, "Panel_3")
	
	--缓存通关状态文本
	-- self.cacheCompleteStatusText = ccui.Helper:seekWidgetByName(root, "Text_tongguan")
	-- self.cacheCompleteStatusImage = ccui.Helper:seekWidgetByName(root, "Image_ko")
	
	--缓存显示星星数量文本
	self.cacheStarText = ccui.Helper:seekWidgetByName(root, "Text_star")
	
	--缓存显示章节的文本
	self.cacheChapterText = ccui.Helper:seekWidgetByName(root, "Text_zhangjie")
	
	--开始绘制
	-- self:onUpdateDraw()
	
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
	
	local hongdian = ccui.Helper:seekWidgetByName(root, "Panel_fubents")
	
	hongdian._data = {self.mySceneID, self.currentPageType}
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_list_scene_the_chest",
	_widget = hongdian,
	_invoke = nil,
	_interval = 0.5,})
	
	if self.isInvalid == false  then
		fwin:addTouchEventListener(self.cacheSeatBG, nil, 
		{
			terminal_name = "duplicate_page_controller_change_scene", 
			next_terminal_name = "", 
			but_image = "", 
			terminal_state = 0, 
			isPressedActionEnabled = false,
			cell = self,
			sceneID = self.mySceneID,
			currentPageType = self.currentPageType,
			isGotoNPC = isGotoNPC -- 是否直接跳入到npc
		},
		nil, 0)
	else
		self:invalid()
		
		fwin:addTouchEventListener(self.cacheSeatBG, nil, 
		{
			terminal_name = "duplicate_select_seat_click", 
			next_terminal_name = "", 
			but_image = "", 
			terminal_state = 0, 
			isPressedActionEnabled = false,
			cell = self,
			sceneID = self.mySceneID,
			currentPageType = self.currentPageType,
			isGotoNPC = isGotoNPC -- 是否直接跳入到npc
		},
		nil, 0)
	end
	
end

function DuplicateSelectSeatCell:onInit( ... )
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
		then
		local filePath = ""
		if __lua_project_id == __lua_project_yugioh then 
			if self.currentPageType == 1 then
				if  zstring.tonumber(self.mySceneID) %2 == 1 then  
					-- 右边开始
					filePath = "duplicate/pve_zhangjie_list.csb" 
				else
					--左边开始
					filePath = "duplicate/pve_zhangjie_list_1.csb" 
				end
			elseif self.currentPageType == 2 then
				if  zstring.tonumber(self.mySceneID) %2 == 1 then  
					-- 右边开始
					filePath = "duplicate/pve_zhangjie_list_jy.csb"
				else
					--左边开始
					filePath = "duplicate/pve_zhangjie_list_jy_2.csb"
				end
			elseif self.currentPageType == 3 then
				if  zstring.tonumber(self.mySceneID) %2 == 1 then  
					-- 右边开始
					filePath = "duplicate/pve_zhangjie_list_mj.csb"
				else
					--左边开始
					filePath = "duplicate/pve_zhangjie_list_mj_1.csb"
				end
			end
		else
			if self.currentPageType == 1 then
				filePath = "duplicate/pve_zhangjie_list.csb"
			elseif self.currentPageType == 2 then
				filePath = "duplicate/pve_zhangjie_list_jy.csb"
			elseif self.currentPageType == 3 then
				filePath = "duplicate/pve_zhangjie_list_mj.csb"
			end
		end
		self.filePath = filePath

		local root = cacher.createUIRef(filePath, "root")
		-- local csbItem = csb.createNode(filePath)
		-- local root = csbItem:getChildByName("root")
		root:removeFromParent(false)
		self:addChild(root)
		table.insert(self.roots, root)

		self.cacheSeatBG = ccui.Helper:seekWidgetByName(root, "Panel_2")

		if DuplicateSelectSeatCell.__size == nil then
			DuplicateSelectSeatCell.__size = self.cacheSeatBG:getContentSize()
		end
		self:setContentSize(DuplicateSelectSeatCell.__size)

		-- 列表控件动画播放
		local action = csb.createTimeline(filePath)
	    root:runAction(action)
	    action:play("list_view_cell_open", false)

		if self.currentPageType == 3 then
			ccui.Helper:seekWidgetByName(root, "Image_11_6"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_3_6_8"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_3_6_8"):setVisible(false)
			--缓存资源，重新加载时，初始化默认状态
			local  tentButton = ccui.Helper:seekWidgetByName(root, "Button_zhuming")
			local  shengli = ccui.Helper:seekWidgetByName(root, "Image_zhuming_sheng")
			local  zhumingname = ccui.Helper:seekWidgetByName(root, "Text_zhuming_name")	
			local  Imagezhumingh = ccui.Helper:seekWidgetByName(root, "Image_zhuming_h")	 --灰色
			Imagezhumingh:setVisible(false)
			zhumingname:setString("")
			shengli:setVisible(false)
			tentButton:setVisible(false)
		end
		self.cacheSceneNameText = ccui.Helper:seekWidgetByName(root, "Text_zhangjie_name")
		
		self.cacheSeatBG:setSwallowTouches(false)
		
		local isGotoNPC = false
		
		if true == is2003 then
			isGotoNPC = true
		end

		--背景图 会根据关卡ID来替换背景图
		self.cacheBackGround = ccui.Helper:seekWidgetByName(root, "Panel_3")
		self.cacheBackGround:setColor(cc.c3b(255,255,255))
		
		--缓存通关状态文本
		-- self.cacheCompleteStatusText = ccui.Helper:seekWidgetByName(root, "Text_tongguan")
		-- self.cacheCompleteStatusImage = ccui.Helper:seekWidgetByName(root, "Image_ko")
		
		--缓存显示星星数量文本
		self.cacheStarText = ccui.Helper:seekWidgetByName(root, "Text_star")
		
		--缓存显示章节的文本
		self.cacheChapterText = ccui.Helper:seekWidgetByName(root, "Text_zhangjie")
		
		--开始绘制
		-- self:onUpdateDraw()
		
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
		
		local hongdian = ccui.Helper:seekWidgetByName(root, "Panel_fubents")
		
		hongdian._data = {self.mySceneID, self.currentPageType}
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_list_scene_the_chest",
		_widget = hongdian,
		_invoke = nil,
		_interval = 0.5,})
		
		if self.isInvalid == false  then
			fwin:addTouchEventListener(self.cacheSeatBG, nil, 
			{
				terminal_name = "duplicate_page_controller_change_scene", 
				next_terminal_name = "", 
				but_image = "", 
				terminal_state = 0, 
				isPressedActionEnabled = false,
				cell = self,
				sceneID = self.mySceneID,
				currentPageType = self.currentPageType,
				isGotoNPC = isGotoNPC -- 是否直接跳入到npc
			},
			nil, 0)
		else
			self:invalid()
			
			fwin:addTouchEventListener(self.cacheSeatBG, nil, 
			{
				terminal_name = "duplicate_select_seat_click", 
				next_terminal_name = "", 
				but_image = "", 
				terminal_state = 0, 
				isPressedActionEnabled = false,
				cell = self,
				sceneID = self.mySceneID,
				currentPageType = self.currentPageType,
				isGotoNPC = isGotoNPC -- 是否直接跳入到npc
			},
			nil, 0)
		end
	end
end

function DuplicateSelectSeatCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function DuplicateSelectSeatCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Panel_zhuming_0 = ccui.Helper:seekWidgetByName(root, "Panel_zhuming_0")
	if Panel_zhuming_0 ~= nil then
		Panel_zhuming_0:removeAllChildren(true)
	end
	cacher.freeRef(self.filePath, root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function DuplicateSelectSeatCell:onExit()
	-- state_machine.remove("duplicate_select_seat_click")
	-- state_machine.remove("equip_icon_cell_change_equip_storage")
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
		then
		local root = self.roots[1]
		local Panel_zhuming_0 = ccui.Helper:seekWidgetByName(root, "Panel_zhuming_0")
		if Panel_zhuming_0 ~= nil then
			Panel_zhuming_0:removeAllChildren(true)
		end
		cacher.freeRef(self.filePath, root)
	end
end

function DuplicateSelectSeatCell:getSceneID()
	return self.mySceneID
end


function DuplicateSelectSeatCell:init(value, _currentPageType, isInvalid, index)
	self.mySceneID = value
	self.currentPageType = _currentPageType
	self.isInvalid = isInvalid
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim 
		then
		if index < 6 then
			self:onInit()
		end
	end
	self:setContentSize(DuplicateSelectSeatCell.__size)
	return self
end


function DuplicateSelectSeatCell:createCell()
	local cell = DuplicateSelectSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

