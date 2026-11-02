----------------------------------------------------------------------------------------------------
-- 说明：副本界面选项卡Seat
-------------------------------------------------------------------------------------------------------
LDuplicateSelectSeatCell = class("LDuplicateSelectSeatCellClass", Window)

function LDuplicateSelectSeatCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}			-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.mySceneID = 0		-- 场景ID
	
	self.cacheSeatBG = nil
	self.cacheBackGround = nil
	
	self.getStarCount = 0
	self.sceneStarNum = 0

	self.currentPageType = 0
	
	self.asyncIndex = 0
	self.maxIndex = 0
	
	--通关状态
	self.cacheCompleteStatusImage = nil
	self.cacheChapterText = nil				--章节显示文本

	-- 初始化武将小像事件响应需要使用的状态机
	local function init_duplicate_select_seat_terminal()
		local duplicate_select_seat_click_terminal = {
            _name = "duplicate_select_seat_click",
            _init = function (terminal) 
				app.load("client.landscape.duplicate.pve.LPVEScene")
				app.load("client.landscape.duplicate.pve.LPVEMap")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- the way -- visible
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					local sceneId = params._datas.sceneID
					local changePageType = params._datas.currentPageType
					state_machine.excute("lpve_raid_select_panel_close_action",0,"")
					state_machine.excute("lduplicate_window_visible", 0, true)
					state_machine.excute("lduplicate_window_pve_quick_entrance", 0, {_type = changePageType, _sceneId = sceneId})		
				else
					state_machine.excute("lduplicate_window_visible", 0, true)
					
					-- the way -- close
					-- local duplicate_main_wnd = fwin:find("LDuplicateWindowClass")
					-- if duplicate_main_wnd ~= nil then
						-- fwin:close(duplicate_main_wnd)
					-- end
					
					state_machine.excute("lduplicate_window_pve_quick_entrance", 0, {_type = 1, _sceneId = params._datas.sceneID})

				end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(duplicate_select_seat_click_terminal)
        state_machine.init()
	end
	
	init_duplicate_select_seat_terminal()
end

function LDuplicateSelectSeatCell:onUpdateDraw()
	local root = self.roots[1]
	if self.mySceneID == nil then
		return
	end
	--显示关卡名称
	local name = dms.string(dms["pve_scene"], tonumber(self.mySceneID), pve_scene.scene_name)
	
	--绘制关卡背景
	--self.cacheBackGround:setTexture("images/ui/pve_sn/pve_duplicate_" .. dms.int(dms["pve_scene"], self.mySceneID, pve_scene.scene_entry_pic) ..".png")
	
	if self.asyncIndex == 1 then
		-- 未开启章节
		-- display:gray(self.cacheBackGround)
		-- self.cacheStarText:setVisible(false)
		-- self.cacheStarText1:setVisible(false)
		-- ccui.Helper:seekWidgetByName(root, "Text_14_1"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(root, "Text_14"):setVisible(false)
		-- ccui.Helper:seekWidgetByName(root, "Image_13"):setVisible(false)
		-- self.cacheSeatBG:setTouchEnabled(false)
	
	elseif self.asyncIndex == 2 then
		-- 正在攻打章节
		ccui.Helper:seekWidgetByName(root, "Panel_zhangjie_dh"):setVisible(true)
	end
	
	local function numberToStringFunc(_input)
		local input_number = zstring.tonumber(_input)
		
		local function getNumberLessThan100(temp1)
			local need = temp1 % 100
			
			local output = ""
			
			if need <= 0 then
				return output
			end
			
			if need <= 10 then
				output = numberToStringArg[need]
			elseif need < 20 then
				output = numberToStringArg[10] .. numberToStringArg[need - 10]
			elseif need < 100 then
				output = numberToStringArg[math.floor(need / 10)] .. numberToStringArg[10]
				if need % 10 ~= 0 then
					output = output .. numberToStringArg[need % 10]
				end		
			end
			
			return output
		end
		
		local function getNumberLessThan1000(temp2)
			local need = temp2 % 1000
			
			local output = ""
			
			if need <= 0 then
				return output
			end
			
			output = numberToStringArg[math.floor(need / 100)] .. numberToStringArg[11]
			
			if need % 100 < 10 and need % 100 > 0 then
				output = output .. numberToStringArg[13]
			end

			local tmpStr = getNumberLessThan100(temp2)
			
			output = output .. tmpStr
			
			return output
		end
		
		local function getNumberLessThan10000(temp3)
			local need = temp3 % 10000
			
			local output = ""
			
			output = numberToStringArg[math.floor(need / 1000)] .. numberToStringArg[12]
			
			if need % 1000 < 100 and need % 100 > 0 then
				output = output .. numberToStringArg[13]
			end

			local tmpStr = ""
			
			if need % 1000 < 100 then
				tmpStr = getNumberLessThan100(temp3)
			else
				tmpStr = getNumberLessThan1000(temp3)
			end
			
			output = output .. tmpStr
			
			return output
		end
		
		local output_string = ""
		if _input < 100 then
			output_string = getNumberLessThan100(_input)
		elseif _input < 1000 then
			output_string = getNumberLessThan1000(_input)
		elseif _input < 10000 then
			output_string = getNumberLessThan10000(_input)
		end
		
		return output_string
	end
	
	--星星数量
	self.getStarCount = tonumber(_ED.get_star_count[self.mySceneID])
	self.sceneStarNum = dms.int(dms["pve_scene"], tonumber(self.mySceneID), pve_scene.total_star)
	if self.currentPageType ~= 3 then 
		-- self.cacheStarText:setString(self.getStarCount .. "/" .. self.sceneStarNum)
		ccui.Helper:seekWidgetByName(root, "Text_14_1"):setVisible(false)
		-- self.cacheStarText1:setString(self.getStarCount)
		--显示章节
		self.cacheChapterText:getVirtualRenderer():setDimensions(36,0) -- setContentSize(cc.size(36,500))
		self.cacheChapterText:setString(name)
		self.cacheChapterText:setContentSize(self.cacheChapterText:getVirtualRenderer():getContentSize())
		-- local length = self.cacheChapterText:getStringLength() -- 文字个数
		-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		-- 	if name == _string_piece_info[199] or self.maxIndex == self.asyncIndex + 1 then
		-- 		self.cacheChapterText:setPositionX(self.cacheChapterText:getPositionX() + 20)
		-- 	end
		-- end
		-- self.cacheChapterText:setPositionY(self.cacheChapterText:getPositionY() - length*22)
		-- self.cacheChapterText:setMaxLineWidth(36)
		
		local Scenelength=0
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			if self.mySceneID <= 10 then
				Scenelength = 0
			elseif self.mySceneID % 10 == 0 or self.mySceneID <= 19 then
				Scenelength = 1
			else -- 暂不考虑100以上章节
				Scenelength = 2
			end
			--print(".....",Scenelength)
			self.cacheChapterText1:setPositionY(self.cacheChapterText1:getPositionY() - Scenelength*18) 
		end
		
		self.cacheChapterText1:setString(_string_piece_info[97] .. numberToStringFunc(self.mySceneID) .. _string_piece_info[98])
		self.cacheChapterText1:setMaxLineWidth(36)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		if self.maxIndex == self.asyncIndex then
			--self.cacheChapterText:setPositionX(self.cacheChapterText:getPositionX() + 20)
		end
	end
	--显示通关状态
	if self.getStarCount == self.sceneStarNum then
		self.cacheCompleteStatusImage:setVisible(true)
	end
end

function LDuplicateSelectSeatCell:onEnterTransitionFinish()
	local filePath = "duplicate/pve_main_k.csb"
	
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self:setContentSize(ccui.Helper:seekWidgetByName(root, "Panel_zhangjie_3"):getContentSize())

	self.cacheSeatBG = ccui.Helper:seekWidgetByName(root, "Panel_4")
	self.cacheSeatBG:setSwallowTouches(false)
	fwin:addTouchEventListener(self.cacheSeatBG, nil, 
	{
		terminal_name = "duplicate_select_seat_click", 
		terminal_state = 0, 
		sceneID = self.mySceneID,
		currentPageType = self.currentPageType
	},
	nil, 0)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if self.mySceneID ~= nil then
			local hongdian = ccui.Helper:seekWidgetByName(root, "Panel_tuisong")
			hongdian._data = {self.mySceneID, self.currentPageType}
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_list_scene_the_chest",
			_widget = hongdian,
			_invoke = nil,
			_interval = 0.5,})
		end
	end
	
	--背景图 会根据关卡ID来替换背景图
	self.cacheBackGround = ccui.Helper:seekWidgetByName(root, "Panel_zhangjie_3"):getChildByName("Sprite_zhangjie")
	
	--缓存显示星星数量文本
	self.cacheStarText = ccui.Helper:seekWidgetByName(root, "Text_14_0")
	self.cacheStarText1 = ccui.Helper:seekWidgetByName(root, "Text_14_2")
	
	--缓存显示章节的文本
	self.cacheChapterText = ccui.Helper:seekWidgetByName(root, "Text_zhangjie")
	self.cacheChapterText1 = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_zj_nb")
	
	--通关状态
	self.cacheCompleteStatusImage = ccui.Helper:seekWidgetByName(root, "Image_tongguan")
	
	--开始绘制
	-- self:onUpdateDraw()
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
	
	-- root._data = {self.mySceneID, self.currentPageType}
	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_list_scene_the_chest",
	-- _widget = root,
	-- _invoke = nil,
	-- _interval = 0.5,})
end


function LDuplicateSelectSeatCell:onExit()

end


function LDuplicateSelectSeatCell:init(value, _currentPageType, _asyncIndex, _maxIndex)
	self.mySceneID = value
	self.currentPageType = _currentPageType
	self.asyncIndex = _asyncIndex
	self.maxIndex = _maxIndex
	return self
end


function LDuplicateSelectSeatCell:createCell()
	local cell = LDuplicateSelectSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

