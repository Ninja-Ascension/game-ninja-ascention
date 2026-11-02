--[[ ----------------------------------------------------------------------------
-- 个性设置主界面
--]] ----------------------------------------------------------------------------
PersonalitySettingMain = class("PersonalitySettingMainClass", Window)

-- 打开窗口
local personality_setting_main_window_open_terminal = {
	_name = "personality_setting_main_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("PersonalitySettingMainClass") then
			fwin:open(PersonalitySettingMain:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local personality_setting_main_window_close_terminal = {
	_name = "personality_setting_main_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("PersonalitySettingMainClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(personality_setting_main_window_open_terminal)
state_machine.add(personality_setting_main_window_close_terminal)
state_machine.init()

-- 构造器
function PersonalitySettingMain:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.btnTabList = {}	-- 按钮页签列表
	self.textTabList = {}	-- 文本页签列表
	self.curCellInfo = {}	-- 当前选中cell数据
	self.tabEnum = {
		HEAD = 1,			-- 头像
		HEADFRAME = 2,		-- 头像框
		IMAGE = 3,			-- 形象
		TITLE = 4,			-- 称号
	}
	self.tabColumnsEnum = {
		[self.tabEnum.HEAD] = 4,
		[self.tabEnum.HEADFRAME] = 4,
		[self.tabEnum.IMAGE] = 4,
		[self.tabEnum.TITLE] = 2,
	}
	self.allTabData = {}

	self.curIndex = 0		-- 当前选中页签
	self.chooseIndex = -1	-- 当前选中下标
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = nil

	-- load lua files.
	app.load("client.l_digital.player.HeadFrameImprint")
	app.load("client.l_digital.cells.player.head_portrait_icon_cell")
	app.load("client.l_digital.cells.player.head_ttile_icon_cell")
	app.load("client.l_digital.cells.player.head_frame_icon_cell")
	-- Initialize personality setting main page state machine.
	local function init_personality_setting_main_terminal()
		-- 打开角色创建窗口
		local personality_setting_main_open_terminal = {
			_name = "personality_setting_main_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local personality_setting_main_close_terminal = {
			_name = "personality_setting_main_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("personality_setting_main_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local personality_setting_main_show_terminal = {
			_name = "personality_setting_main_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local personality_setting_main_hide_terminal = {
			_name = "personality_setting_main_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 跳转印记界面
		local personality_setting_main_jump_to_imprint_terminal = {
			_name = "personality_setting_main_jump_to_imprint",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 跳转印记界面
				if nil ~= instance then
					local curCellInfo = instance.curCellInfo
					state_machine.excute("head_frame_imprint_window_open", 0, curCellInfo)
					instance:updateDramMainRedDot(curCellInfo.id)
					instance:updateCellRedDot()
					state_machine.excute("sm_player_infomation_page_update_red_dot", 0, nil)
					state_machine.excute("user_information_update_role_head_red_dot", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 切换界面
		local personality_setting_main_change_page_terminal = {
			_name = "personality_setting_main_change_page",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 切换界面
				if nil ~= instance then
					instance.curIndex = params._datas.tabIndex
					instance:updateChooseIndex()
					instance:updateDrawTabBtns()
					instance:updateDrawScrollView()
					instance:updateDrawPreviewUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 切换选中cell
		local personality_setting_main_change_cell_terminal = {
			_name = "personality_setting_main_change_cell",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 切换选中cell
				if nil ~= instance then
					if instance.chooseIndex == params._datas.chooseIdx then
						return
					end
					instance.chooseIndex = params._datas.chooseIdx
					instance:setPreviewCurCell(instance.chooseIndex)
					instance:updateCellIsChoosed(instance.chooseIndex)
					instance:updateDrawPreviewContent()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 佩戴按钮事件
		local personality_setting_main_use_cell_terminal = {
			_name = "personality_setting_main_use_cell",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 佩戴按钮事件
				if nil ~= instance then
					local curID = instance.curCellInfo.id

					local curStage = -1
					if instance.curIndex == instance.tabEnum.HEADFRAME then
						if params.curID ~= nil and params.curStage ~= nil then
							curID = params.curID
							curStage = params.curStage
						else
							curStage = instance:getHeadFrameStageByID(curID)
						end
					end

					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								instance:updateUserInfo(curID, curStage)

								state_machine.excute("sm_player_infomation_page_updata_head",0,"sm_player_infomation_page_updata_head.")                        
								state_machine.excute("user_information_update_head",0,"user_information_update_head.")
								if fwin:find("ArenaClass") ~= nil then
									state_machine.excute("arena_update_user_pic",0,"arena_update_user_pic.")
								end
								instance:updateTabData()
								instance:updateCellIsUsed()
								
								instance:updatePreviewDataByTab(instance.curIndex)
								instance:updateDrawPreviewContent()
							end
						end
					end

					if instance.curIndex == instance.tabEnum.HEAD then
						protocol_command.user_info_modify.param_list = "1".."\r\n".. curID
						NetworkManager:register(protocol_command.user_info_modify.code, nil, nil, nil, instance, responseCallback, false, nil)
					elseif instance.curIndex == instance.tabEnum.HEADFRAME then
						protocol_command.change_user_head_frame.param_list = curID.."\r\n".. curStage
						NetworkManager:register(protocol_command.change_user_head_frame.code, nil, nil, nil, instance, responseCallback, false, nil)
					elseif instance.curIndex == instance.tabEnum.IMAGE then
						protocol_command.user_info_modify.param_list = "3".."\r\n".. curID
						NetworkManager:register(protocol_command.user_info_modify.code, nil, nil, nil, instance, responseCallback, false, nil)
					elseif instance.curIndex == instance.tabEnum.TITLE then
						protocol_command.user_title_modify.param_list = "" .. curID
						NetworkManager:register(protocol_command.user_title_modify.code, nil, nil, nil, instance, responseCallback, false, nil)
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 卸下按钮事件
		local personality_setting_main_remove_cell_terminal = {
			_name = "personality_setting_main_remove_cell",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 卸下按钮事件
				if nil ~= instance then
					local curID = instance.curCellInfo.id
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								if instance.curIndex == instance.tabEnum.HEADFRAME then
									instance:updateUserInfo(-1, -1)
								end
								state_machine.excute("sm_player_infomation_page_updata_head",0,"sm_player_infomation_page_updata_head.")                        
								state_machine.excute("user_information_update_head",0,"user_information_update_head.")
								if fwin:find("ArenaClass") ~= nil then
									state_machine.excute("arena_update_user_pic",0,"arena_update_user_pic.")
								end
								instance:updateTabData()
								instance:updateCellIsUsed()
								
								instance:updatePreviewDataByTab(instance.curIndex)
								instance:updateDrawPreviewState()
							end
						end
					end

					if instance.curIndex == instance.tabEnum.HEADFRAME then
						protocol_command.change_user_head_frame.param_list = -1 .."\r\n".. -1
						NetworkManager:register(protocol_command.change_user_head_frame.code, nil, nil, nil, instance, responseCallback, false, nil)
					elseif instance.curIndex == instance.tabEnum.TITLE then
						protocol_command.user_title_modify.param_list = "" .. 0
						NetworkManager:register(protocol_command.user_title_modify.code, nil, nil, nil, instance, responseCallback, false, nil)
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(personality_setting_main_open_terminal)
		state_machine.add(personality_setting_main_close_terminal)
		state_machine.add(personality_setting_main_show_terminal)
		state_machine.add(personality_setting_main_hide_terminal)
		state_machine.add(personality_setting_main_jump_to_imprint_terminal)
		state_machine.add(personality_setting_main_change_page_terminal)
		state_machine.add(personality_setting_main_change_cell_terminal)
		state_machine.add(personality_setting_main_use_cell_terminal)
		state_machine.add(personality_setting_main_remove_cell_terminal)
		state_machine.init()
	end
	-- call func init personality setting main state machine.
	init_personality_setting_main_terminal()
end

function PersonalitySettingMain:initDrawUI()
	self:updateDrawTabBtns()
	self:updateDrawScrollView()
	self:updateDrawPreviewUI()
	self:updateDrawHeadFrameTabRedDot()
end

-- 更新每个页签的选中下标
function PersonalitySettingMain:updateChooseIndex()
	local curTabData = self.allTabData[self.curIndex]
	for k, v in pairs(curTabData) do
		if v.isChoosed == true then
			self.chooseIndex = k
			break
		end
	end
end

function PersonalitySettingMain:updateUserInfo(curID, curStage)
	
	if self.curIndex == self.tabEnum.HEAD then
		_ED.user_info.user_head = tonumber(curID)
	elseif self.curIndex == self.tabEnum.HEADFRAME then
		_ED.user_info.head_frame.curHeadFrameID = tonumber(curID)
		local info = _ED.user_info.head_frame.info
		for i, v in pairs(info) do
			if v.headFrameID == curID then
				_ED.user_info.head_frame.curHeadFrameStage = curStage
				v.curStage = curStage
				break
			end
		end
	elseif self.curIndex == self.tabEnum.IMAGE then
		_ED.user_info.user_image_id = tonumber(curID)
	end

end

function PersonalitySettingMain:updateTabData()
	local curTabData = self.allTabData[self.curIndex]
	for k, v in pairs(curTabData) do
		v.isUsed = false
	end

	local curID = 0
	if self.curIndex == self.tabEnum.HEAD then
		curID = tonumber(_ED.user_info.user_head)
	elseif self.curIndex == self.tabEnum.HEADFRAME then
		curID = tonumber(_ED.user_info.head_frame.curHeadFrameID)
	elseif self.curIndex == self.tabEnum.IMAGE then
		curID = tonumber(_ED.user_info.user_image_id)
	elseif self.curIndex == self.tabEnum.TITLE then
		curID = tonumber(_ED.user_rank_title_info._current_title)
	end
	for k, v in pairs(curTabData) do
		if v.id == curID then
			if self.curIndex == self.tabEnum.HEADFRAME then
				v = self:updateHeadFrameServerData(v)
			else
				v.isUsed = true
			end
			break
		end
	end
end

-- 根据头像框ID获取头像框印记阶段
function PersonalitySettingMain:getHeadFrameStageByID(headFrameID)
	local headFrameInfo = _ED.user_info.head_frame
	local headFrameStage = 1

	if headFrameInfo ~= nil and headFrameInfo.info ~= nil then
		local curInfo = headFrameInfo.info[headFrameID]
		if curInfo ~= nil then
			headFrameStage = curInfo.curStage
		end
	end

	return headFrameStage
end

function PersonalitySettingMain:getHeadUnlockState(mouldData)
	local headUnlockState = false
	local shipID = mouldData.shipID

	local function getState()
		local unLockState = false
	  	local shipInfo = nil
	  	for _, v in pairs(_ED.user_ship) do
			if tonumber(v.ship_template_id) == shipID then
		  		shipInfo = v
		  		break
			end
	  	end
		  
		if shipInfo ~= nil then
			if mouldData.evoMouldID ~= -1 then
				local evo_image = dms.string(dms["ship_mould"], shipID, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				local ship_evo = zstring.split(shipInfo.evolution_status, "|")

				for m = 1 , tonumber(ship_evo[1]) do
					local curPicID = dms.int(dms["ship_evo_mould"], evo_info[m], ship_evo_mould.form_id)
					if curPicID ~= nil and curPicID == mouldData.picID then
						unLockState = true
						break
					end
				end
			elseif mouldData.skinID ~= -1 then
				local ship_skin_info = shipInfo.ship_skin_info
				if ship_skin_info and ship_skin_info ~= "" then
					local skin_info = zstring.split(ship_skin_info, "|")
					for _, n in ipairs(zstring.split(skin_info[2], ",")) do
						local curSkinId = zstring.split(n, ":", tonumber)[1]
						if curSkinId == mouldData.skinID then
							unLockState = true
							break
						end
					end
				end
			end
		end

		return unLockState
	end
  
	if shipID == -1 then
		headUnlockState = true
	else
		headUnlockState = getState()
	end  

	return headUnlockState
end

function PersonalitySettingMain:getHeadFormData(formData)
	local mouldData = {}
	mouldData.shipID = dms.atoi(formData, face_mould.shipID)
	mouldData.evoMouldID = dms.atoi(formData, face_mould.evoMouldID)
	mouldData.skinID = dms.atoi(formData, face_mould.skinID)
	mouldData.picID = dms.atoi(formData, face_mould.ID)
	mouldData.sortID = dms.atoi(formData, face_mould.sortID)
	mouldData.nameIndex = dms.atoi(formData, face_mould.nameID)
	return mouldData
end

function PersonalitySettingMain:getAllHeadData()
	local allHeadInfo = {}
	local hasUsed = false
	local allFormHeadData = dms["face_mould"]
	-- debug.print_r(allFormHeadData, "====allFormHeadData")
	for i, v in ipairs(allFormHeadData) do

		local mouldData = self:getHeadFormData(v)

		local unLocked = self:getHeadUnlockState(mouldData)
		
		local headInfo = {}

		headInfo.mouldData = mouldData
		headInfo.id = mouldData.picID
		headInfo.unLocked = unLocked
		headInfo.isUsed = false
		headInfo.isChoosed = false
		if mouldData.picID == tonumber(_ED.user_info.user_head) then
			hasUsed = true
			headInfo.isChoosed = true
			headInfo.isUsed = true
		end
		
		table.insert(allHeadInfo, headInfo)
	end

	self.allTabData[self.tabEnum.HEAD] = self:sortDataInfo(allHeadInfo, self.tabEnum.HEAD)
	if hasUsed == false then
		local initCellInfo = self.allTabData[self.tabEnum.HEAD][1]
		initCellInfo.isChoosed = true
	end
end

function PersonalitySettingMain:getHeadFrameFormData(formData)
	local mouldData = {}
	mouldData.nameIndex = dms.atos(formData, face_frame_mould.nameID)
	mouldData.toGetIndex = dms.atos(formData, face_frame_mould.toGetID)
	mouldData.imprintStageInfo = zstring.split(dms.atos(formData, face_frame_mould.imprintStage), ",", tonumber)
	mouldData.bgIDInfo = zstring.split(dms.atos(formData, face_frame_mould.bgIDInfo), ",", tonumber)
	mouldData.effectIDInfo = zstring.split(dms.atos(formData, face_frame_mould.effectIDInfo), ",", tonumber)
	mouldData.sortID = dms.atoi(formData, face_frame_mould.sortID)
	mouldData.headFrameID = dms.atoi(formData, face_frame_mould.id)
	return mouldData
end

function PersonalitySettingMain:updateHeadFrameServerData(curHeadFrameInfo)
	
	local headFrameInfo = _ED.user_info.head_frame
	local headFrameID = curHeadFrameInfo.mouldData.headFrameID

	if headFrameInfo ~= nil and headFrameInfo.info ~= nil then
		local userHeadFrameInfo = headFrameInfo.info
		if userHeadFrameInfo[headFrameID] ~= nil then
			local dataInfo = userHeadFrameInfo[headFrameID]
			curHeadFrameInfo.imprintNums = dataInfo.imprintNums
			curHeadFrameInfo.headFrameStage = dataInfo.curStage
			curHeadFrameInfo.unLocked = true
			curHeadFrameInfo.maxStage = self:getMaxHeadFrameStage(curHeadFrameInfo)
		end

		if headFrameID == headFrameInfo.curHeadFrameID then
			curHeadFrameInfo.isUsed = true
			curHeadFrameInfo.isChoosed = true
		end
	end

	return curHeadFrameInfo
end

-- 获取最大解锁印记阶段
function PersonalitySettingMain:getMaxHeadFrameStage(headFrameInfo)
	local maxStage = 1
	local imprintNums = headFrameInfo.imprintNums
	local stageInfo = headFrameInfo.mouldData.imprintStageInfo
	for i, v in ipairs(stageInfo) do
		if imprintNums >= v then
			maxStage = i
		else
			break
		end
	end

	return maxStage
end

function PersonalitySettingMain:getAllUserHeadFrameData()
	local isChoosedID = -1
	local unLockedHeadFrame = {}
	local lockedHeadFrame = {}
	local allHeadFrameInfo = {}
	
	local alluserHeadFrameData = dms["face_frame_mould"]
	for i, v in ipairs(alluserHeadFrameData) do

		local mouldData = self:getHeadFrameFormData(v)
 
		local curHeadFrameInfo = {}
		curHeadFrameInfo.mouldData = mouldData
		curHeadFrameInfo.id = mouldData.headFrameID
		curHeadFrameInfo.headFrameStage = 1
		curHeadFrameInfo.unLocked = false
		curHeadFrameInfo.isUsed = false
		curHeadFrameInfo.isChoosed = false
		curHeadFrameInfo.imprintNums = 0
		curHeadFrameInfo.maxStage = 1
		curHeadFrameInfo = self:updateHeadFrameServerData(curHeadFrameInfo)

		table.insert(allHeadFrameInfo, curHeadFrameInfo)
	end

	self.allTabData[self.tabEnum.HEADFRAME] = self:sortDataInfo(allHeadFrameInfo, self.tabEnum.HEADFRAME)
	
	local hasUsed = false
	local curTabData = self.allTabData[self.tabEnum.HEADFRAME]

	for i, v in pairs(curTabData) do
		if v.isUsed == true then
			hasUsed = true
			break
		end
	end
	if hasUsed == false then
		curTabData[1].isChoosed = true
	end
	-- debug.print_r(allHeadFrameInfo, "====allHeadFrameInfo")
end

function PersonalitySettingMain:getAllUserTitleData()
	local isChoosedID = -1
	local allTitleInfo = {}
	local unLockedTitleInfo = {}
	local lockedTitleInfo = {}
	for i, v in pairs(_ED.user_rank_title_info._title_infos) do
		local titleID = tonumber(v[1])

		local titleInfo = {}
		titleInfo.unLocked = false
		titleInfo.isUsed = false
		titleInfo.isChoosed = false
		titleInfo.titleID = titleID
		titleInfo.id = titleID

		-- 状态为1代表已解锁
		if 1 == tonumber(v[2]) then
			titleInfo.unLocked = true
		end

		if tonumber(_ED.user_rank_title_info._current_title) == titleID then
			isChoosedID = titleID
			titleInfo.isUsed = true 
			titleInfo.isChoosed = true
		end

		table.insert(allTitleInfo, titleInfo)
	end
	
	self.allTabData[self.tabEnum.TITLE] = self:sortDataInfo(allTitleInfo, self.tabEnum.TITLE)
	local curTitleInfo = self.allTabData[self.tabEnum.TITLE]
	if isChoosedID == -1 then
		curTitleInfo[1].isChoosed = true
	end
	-- debug.print_r(allTitleInfo, "=====allTitleInfo")
end

function PersonalitySettingMain:getAllUserImageData()
	local allImageInfo = {}

	local hasUsed = false
	local allFormHeadData = dms["face_mould"]
	for i, v in ipairs(allFormHeadData) do
		local shipID = dms.atoi(v, face_mould.shipID)
		if shipID ~= -1 then
			local mouldData = self:getHeadFormData(v)
	
			local unLocked = self:getHeadUnlockState(mouldData)
			
			local imageInfo = {}
	
			imageInfo.mouldData = mouldData
			imageInfo.id = mouldData.picID
			imageInfo.unLocked = unLocked
			imageInfo.isUsed = false
			imageInfo.isChoosed = false
			if mouldData.picID == tonumber(_ED.user_info.user_image_id) then
				hasUsed = true
				imageInfo.isChoosed = true
				imageInfo.isUsed = true
			end
			
			table.insert(allImageInfo, imageInfo)
		end
	end

	self.allTabData[self.tabEnum.IMAGE] = self:sortDataInfo(allImageInfo, self.tabEnum.IMAGE)

	local curImageID = tonumber(_ED.user_info.user_image_id)
	if hasUsed == false then
		local initCellInfo = self.allTabData[self.tabEnum.IMAGE][1]
		initCellInfo.isChoosed = true
	end
end

function PersonalitySettingMain:sortDataInfo(sortData, type)
	local allDataInfo = {}
	local unLockedInfo = {}
	local lockedInfo = {}
	if type == self.tabEnum.HEADFRAME or type == self.tabEnum.HEAD or type == self.tabEnum.IMAGE then
		table.sort(sortData, function(a, b)
			return a.mouldData.sortID > b.mouldData.sortID
		end)
	end
	for i, v in ipairs(sortData) do
		if v.unLocked == true then
			table.insert(unLockedInfo, v)
		else
			table.insert(lockedInfo, v)
		end
	end

	for i, v in ipairs(unLockedInfo) do
		table.insert(allDataInfo, v)
	end

	for i, v in ipairs(lockedInfo) do
		table.insert(allDataInfo, v)
	end

	return allDataInfo
end

-- 更新绘制页签按钮
function PersonalitySettingMain:updateDrawTabBtns()
	for i = 1, #self.btnTabList do
		self.btnTabList[i]:setTouchEnabled(self.curIndex ~= i)
		self.btnTabList[i]:setBright(self.curIndex ~= i)
		self.btnTabList[i]:setHighlighted(self.curIndex == i)
		self.textTabList[i]:setVisible(self.curIndex == i)
	end
end

-- 更新绘制页签容器
function PersonalitySettingMain:updateDrawScrollView()
	self.ScrollView_main:removeAllChildren(true)

	local curTabDataInfo = self.allTabData[self.curIndex]
	local cellList = {}
	for k, v in pairs(curTabDataInfo) do
		local cell = self:getCellByData(v, k)
		if cell ~= nil then
			table.insert(cellList, cell)
		end
	end

	addNodeToScrollView({targetScrollView = self.ScrollView_main, nodeList = cellList, columns = self.tabColumnsEnum[self.curIndex]})
	-- self:addNodeToScrollView(curTabDataInfo, self.ScrollView_main, self.tabColumnsEnum[self.curIndex])
	self.currentInnerContainer = self.ScrollView_main:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

-- ScrollView的绘制
function PersonalitySettingMain:addNodeToScrollView(curTabDataInfo, m_ScrollView, columns)
	
    if table.nums(curTabDataInfo) > 0 then
        m_ScrollView:removeAllChildren(true)
        local horizontalNumber = columns
        local panel = m_ScrollView:getInnerContainer()
        panel:setContentSize(m_ScrollView:getContentSize())
        panel:setPosition(cc.p(0,0))
        panel:removeAllChildren(true)
        local sSize = panel:getContentSize()
        local sHeight = sSize.height
        local sWidth = sSize.width
        local controlSize = m_ScrollView:getInnerContainerSize()
        local nextY = sSize.height
        local nextX = sSize.width
        local tHeight = 0
        local cellHeight = 0
        local tWidth = 0
        local wPosition = sWidth/horizontalNumber
        local Hlindex = 0
        local number = table.nums(curTabDataInfo)
        local m_number = math.ceil(number/horizontalNumber)
        cellHeight = m_number*(m_ScrollView:getContentSize().width/horizontalNumber)
        sHeight = math.max(sHeight, cellHeight)
        panel:setContentSize(m_ScrollView:getContentSize().width, sHeight + 10)

        local totalRewardCount = 0
        for j, v in pairs(curTabDataInfo) do
            local cell = self:getCellByData(v, j)
            if cell ~= nil then
				panel:addChild(cell)
				tWidth = tWidth + wPosition
				if (j-1)%horizontalNumber == 0 then
					Hlindex = Hlindex+1
					tWidth = 0
					tHeight = sHeight - (wPosition + 2)*Hlindex  
				end
				if j <= horizontalNumber then
					tHeight = sHeight - wPosition
				end
				cell:setPosition(cc.p(tWidth, tHeight))
	
				totalRewardCount = totalRewardCount + 1
			end
        end
        m_ScrollView:jumpToTop()
    end
    self.currentInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

-- 通过当前页签数据获取cell
function PersonalitySettingMain:getCellByData(cellData, index)
	local cell = nil
	if self.curIndex == self.tabEnum.HEAD or self.curIndex == self.tabEnum.IMAGE then
		cell = state_machine.excute("head_portrait_icon_cell_create", 0, {index = index, cellData = cellData})
	elseif self.curIndex == self.tabEnum.HEADFRAME then
		cell = state_machine.excute("head_frame_icon_cell_create", 0, {index = index, cellData = cellData})
	elseif self.curIndex == self.tabEnum.TITLE then
		cell = state_machine.excute("head_ttile_icon_cell_create", 0, {index = index, cellData = cellData})
	end

	return cell
end

function PersonalitySettingMain:updateDrawPreviewUI()
	self.Panel_head:setVisible(self.curIndex == self.tabEnum.HEAD or self.curIndex == self.tabEnum.HEADFRAME)
	self.Panel_role:setVisible(self.curIndex == self.tabEnum.IMAGE)
	self.Panel_title:setVisible(self.curIndex == self.tabEnum.TITLE)
	self.Panel_head_info:setVisible(self.curIndex == self.tabEnum.HEADFRAME)

	local btnText = nil
	if self.curIndex == self.tabEnum.HEAD or self.curIndex == self.tabEnum.IMAGE then
		btnText = tipStringInfo_face_text[4]
	else
		btnText = tipStringInfo_face_text[3]
	end
	self.Text_use:setString(btnText)
	self:updateDrawPreviewContent()
end

function PersonalitySettingMain:updateDrawPreviewContent()
	self:updatePreviewDataByTab(self.curIndex)
	if self.curIndex == self.tabEnum.HEAD then
		self:updateDrawHeadAndFrame(self.curIndex)
	elseif self.curIndex == self.tabEnum.HEADFRAME then
		self:updateDrawHeadAndFrame(self.curIndex)
		self:updateDrawHeadFrameText()
		self:updateDrawCurImprintRedDot()
	elseif self.curIndex == self.tabEnum.IMAGE then
		self:updateDrawImage()
	elseif self.curIndex == self.tabEnum.TITLE then
		self:updateDrawTitle()
	end

	self:updateDrawPreviewState()

end

-- 绘制预览模块佩戴/卸下/使用中控件的显隐
function PersonalitySettingMain:updateDrawPreviewState()
	
	local cellIsUsed = self.curCellInfo.isUsed
	local cellIsUnLocked = self.curCellInfo.unLocked
	self.Button_use:setVisible(cellIsUsed == false and cellIsUnLocked == true)
	self.Button_remove:setVisible(cellIsUsed == true and (self.curIndex == self.tabEnum.HEADFRAME or self.curIndex == self.tabEnum.TITLE))
	self.Image_using:setVisible(cellIsUsed == true and (self.curIndex == self.tabEnum.HEAD or self.curIndex == self.tabEnum.IMAGE))
	self.Panel_lock:setVisible(cellIsUnLocked == false)
end

function PersonalitySettingMain:geyCellDataByIDAndIndex(mouldID, tabIndex)
	local cellDataInfo = nil
	local allUserData = self.allTabData[tabIndex]
	for k, v in pairs(allUserData) do
		if mouldID == v.id then
			cellDataInfo = v
			break
		end
	end
	return cellDataInfo
end

function PersonalitySettingMain:getHeadFrameByData(headFrameData)
	local curStage = headFrameData.headFrameStage
	local curBgID = headFrameData.mouldData.bgIDInfo[curStage]
	local curEffectID = headFrameData.mouldData.effectIDInfo[curStage]

	return curBgID, curEffectID
end

-- 设置当前选中的cell
function PersonalitySettingMain:setPreviewCurCell(cellIndex)
	for k, v in pairs(self.allTabData[self.curIndex]) do
		v.isChoosed = false
	end

	for k, v in pairs(self.allTabData[self.curIndex]) do
		if k == cellIndex then
			v.isChoosed = true
			break
		end
	end
end

-- 更新当前选中的cell数据
function PersonalitySettingMain:updatePreviewDataByTab(tabIndex)
	local curTabDataInfo = self.allTabData[tabIndex]
	for k, v in pairs(curTabDataInfo) do
		if v.isChoosed == true then
			self.curCellInfo = v
			break
		end
	end
end

-- 绘制预览模块头像和头像框
function PersonalitySettingMain:updateDrawHeadAndFrame(type)
	local headPicPath = nil
	local unLockText = nil
	local curHeadID = -1
	local curHeadFrameID = -1
	local curCellInfo = self.curCellInfo
	if type == self.tabEnum.HEAD then
		curHeadID = curCellInfo.id
		curHeadFrameID = _ED.user_info.head_frame.curHeadFrameID
		local nameIndex = curCellInfo.mouldData.nameIndex
		unLockText = self:getConditionByNameIdx(nameIndex)
		unLockText = string.format(_new_interface_text[115], unLockText)
	elseif type == self.tabEnum.HEADFRAME then
		curHeadID = tonumber(_ED.user_info.user_head)
		curHeadFrameID = curCellInfo.id
		unLockText = self:getConditionByNameIdx(curCellInfo.mouldData.toGetIndex)
	end
	local headInfo = self:geyCellDataByIDAndIndex(curHeadID, self.tabEnum.HEAD)
	local headPicIdx = headInfo.mouldData.picID
	if headPicIdx < 9 then
		headPicPath = string.format("images/ui/home/head_%d.png", headPicIdx)
	else
		headPicPath = string.format("images/ui/props/props_%d.png", headPicIdx)
	end 
	self.Panel_head_frame_pic:removeBackGroundImage()
	self.Panel_head_portrait_pic:removeBackGroundImage()
	self.Panel_head_frame_effect:removeAllChildren(true)
	self.Panel_head_portrait_pic:setBackGroundImage(headPicPath)

	local cellIsUnLocked = curCellInfo.unLocked
	if cellIsUnLocked == false then
		self.Text_is_locking:setVisible(true)

		self.Text_is_locking:setString(unLockText)
	end

	if curHeadFrameID ~= -1 then
		local headFrameInfo = self:geyCellDataByIDAndIndex(curHeadFrameID, self.tabEnum.HEADFRAME)
		self:updateDrawEffect(headFrameInfo)
	end
end

-- 绘制头像框特效
function PersonalitySettingMain:updateDrawEffect(headFrameInfo)
	
	local headFramePicIdx, headFrameEffectIdx = self:getHeadFrameByData(headFrameInfo)
	if headFrameInfo.unLocked == true and headFrameInfo.id ~= _ED.user_info.head_frame.curHeadFrameID then
		local maxStage = headFrameInfo.maxStage
		headFramePicIdx = headFrameInfo.mouldData.bgIDInfo[maxStage]
		headFrameEffectIdx = headFrameInfo.mouldData.effectIDInfo[maxStage]
	end
	if headFramePicIdx == -1 then
		return
	end
	local headFramePicPath = string.format("image/cut/frame/cut_frame_%d.png", headFramePicIdx)
	
	local jsonFile = string.format("images/ui/effice/effice_frame_%d/effice_frame_%d.json", headFrameEffectIdx, headFrameEffectIdx)
	local atlasFile = string.format("images/ui/effice/effice_frame_%d/effice_frame_%d.atlas", headFrameEffectIdx, headFrameEffectIdx)
	local aniName = "animation"

	local isPlayEffect = false
	if true == cc.FileUtils:getInstance():isFileExist(jsonFile) then
		isPlayEffect = true
		local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		self.Panel_head_frame_effect:addChild(animation)
		animation:setPosition(cc.p(self.Panel_head_frame_effect:getContentSize().width / 2, self.Panel_head_frame_effect:getContentSize().height / 2))
	end

	if true == cc.FileUtils:getInstance():isFileExist(headFramePicPath) and isPlayEffect == false then
		self.Panel_head_frame_pic:setBackGroundImage(headFramePicPath)
	end
end

function PersonalitySettingMain:getConditionByNameIdx(nameIndex)
	local tipText = dms.string(dms["word_mould"], nameIndex, word_mould.text_info)

	return tipText
end

-- 绘制预览模块头像框文本显示
function PersonalitySettingMain:updateDrawHeadFrameText()
	local headFrameName = self:getConditionByNameIdx(self.curCellInfo.mouldData.nameIndex)
	local imprintNums = self.curCellInfo.imprintNums

	self.Text_name:setString(headFrameName)
	self.Text_imprint_nums:setString(imprintNums)
end

-- 绘制预览模块形象显示
function PersonalitySettingMain:updateDrawImage()
	self.Panel_role:removeAllChildren(true)
	local curCellInfo = self.curCellInfo
	local evo_mould_id = curCellInfo.mouldData.evoMouldID
	local skin_id = curCellInfo.mouldData.skinID
	local temp_bust_index = curCellInfo.mouldData.picID
	local jsonFile = string.format("sprite/spirte_%s.json", temp_bust_index)

	if true == cc.FileUtils:getInstance():isFileExist(jsonFile) then
		local armature_hero = sp.spine_sprite(self.Panel_role, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
		armature_hero:setScaleX(-1)
		armature_hero.animationNameList = spineAnimations
		sp.initArmature(armature_hero, true)
	end

	local unLockText = self:getConditionByNameIdx(curCellInfo.mouldData.nameIndex)
	
	local cellIsUnLocked = curCellInfo.unLocked
	if cellIsUnLocked == false then
		self.Text_is_locking:setVisible(true)

		self.Text_is_locking:setString(string.format(_new_interface_text[115], unLockText))
	end
end

-- 绘制预览模块称号显示
function PersonalitySettingMain:updateDrawTitle()
	self.Panel_title:removeBackGroundImage()
	-- debug.print_r(self.curCellInfo, "=====self.curCellInfo"
	local titlePicID = dms.string(dms["title_param"], self.curCellInfo.titleID, title_param.pic_index)
	local picPath = string.format("images/ui/text/title/title_%s.png", titlePicID)
	self.Panel_title:setBackGroundImage(picPath)

	local cellIsUnLocked = self.curCellInfo.unLocked
	if cellIsUnLocked == false then
		self.Text_is_locking:setVisible(true)
		local tipIndex = dms.string(dms["title_param"], self.curCellInfo.titleID, title_param.lock_tips)
		local tipText = dms.string(dms["word_mould"], tipIndex, word_mould.text_info)
		self.Text_is_locking:setString(tipText)
	end
end

-- 绘制cell是否被选中
function PersonalitySettingMain:updateCellIsChoosed(cellIndex)
	local items = self.ScrollView_main:getChildren()
	for k, v in pairs(items) do
		if v.roots ~= nil and v.roots[1] ~= nil then
			v:updateDrawIsChoosed(k == cellIndex)
		end
	end
end

-- 绘制cell是否被使用
function PersonalitySettingMain:updateCellIsUsed()
	local items = self.ScrollView_main:getChildren()
	local curCellData = self.allTabData[self.curIndex]

	for k, v in pairs(items) do
		local isUsed = curCellData[k].isUsed
		if v.roots ~= nil and v.roots[1] ~= nil then
			v:updateDrawIsUsed(isUsed)
			if self.curIndex == self.tabEnum.HEADFRAME then
				v:updateDrawHeadFrame()
			end
		end
	end
end

-- 更新cell中的红点显示
function PersonalitySettingMain:updateCellRedDot()
	local items = self.ScrollView_main:getChildren()
	
	for k, v in pairs(items) do
		if v.roots ~= nil and v.roots[1] ~= nil and k == self.chooseIndex then
			v:updateDrawRedDot()
		end
	end
end

-- 印记红点
function PersonalitySettingMain:updateDrawCurImprintRedDot()
	local curHeadFrameID = self.curCellInfo.id
	self.Image_red_imprint:setVisible(getPlayerNewHeadFrameImprintStateByID(curHeadFrameID))
end

-- 头像框页签红点
function PersonalitySettingMain:updateDrawHeadFrameTabRedDot()
	self.Image_red:setVisible(getPlayerAllHeadFrameState())
end

-- 更新绘制主界面红点
function PersonalitySettingMain:updateDramMainRedDot(headFrameID)
	self:updateSetHeadFrameIDString(headFrameID)
	self:updateDrawHeadFrameTabRedDot()
	self:updateDrawCurImprintRedDot()
end

-- 更新存储头像框ID的红点信息
function PersonalitySettingMain:updateSetHeadFrameIDString(headFrameID)
	local info = _ED.user_info.head_frame.info
	if info[headFrameID] == nil then
		return false
	end
	local curData = info[headFrameID]
	local curStage = -1
	local curString = ""

	local headFrameString = readKey("player_head_frame")

	local imprintNums = curData.imprintNums
	local headFrameStorageInfo = {}
	if headFrameString ~= nil and headFrameString ~= "" then
		headFrameStorageInfo = zstring.splits(headFrameString, "|", ",", tonumber)
	end
	local headFrameInfo = dms.searchs(dms["face_frame_mould"], face_frame_mould.id, headFrameID)[1]
	local costImprintNumsInfo = zstring.split(dms.atos(headFrameInfo, face_frame_mould.imprintStage), ",", tonumber)

	for i, v in ipairs(costImprintNumsInfo) do
		if imprintNums >= v then
			curStage = i
		end
	end
	
	local isExist = false
	for _, v in ipairs(headFrameStorageInfo) do
		if v[1] == headFrameID then
			isExist = true
			v[2] = curStage
			break
		end
	end

	if isExist == false then
		local curInfo = {headFrameID, curStage}
		table.insert(headFrameStorageInfo, curInfo)
	end

	for i, v in ipairs(headFrameStorageInfo) do
		curString = curString .. v[1] .. "," .. v[2]
		if i ~= #headFrameStorageInfo then
			curString = curString .. "|"
		end
	end

	writeKey("player_head_frame", curString)
end

function PersonalitySettingMain:onUpdate(dt)
	if self.ScrollView_main ~= nil and self.currentInnerContainer ~= nil then
		local size = self.ScrollView_main:getContentSize()
		local posY = self.currentInnerContainer:getPositionY()
		if self.currentInnerContainerPosY == posY then
			return
		end
		self.currentInnerContainerPosY = posY
		local items = self.ScrollView_main:getChildren()
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

-- 对象初始化
function PersonalitySettingMain:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function PersonalitySettingMain:onInit()
	self.curIndex = 1

	self:getAllHeadData()
	self:getAllUserHeadFrameData()
	self:getAllUserTitleData()
	self:getAllUserImageData()
end

function PersonalitySettingMain:onUpdateDraw()
	local root = self.roots[1]

	-- 存放所有资源内容容器
	self.ScrollView_main = ccui.Helper:seekWidgetByName(root, "ScrollView_main")

	-- 头像显示父节点
	self.Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head")

	-- 头像图片容器
	self.Panel_head_portrait_pic = ccui.Helper:seekWidgetByName(root, "Panel_head_portrait_pic")

	-- 头像框图片容器
	self.Panel_head_frame_pic = ccui.Helper:seekWidgetByName(root, "Panel_head_frame_pic")

	-- 头像框特效容器
	self.Panel_head_frame_effect = ccui.Helper:seekWidgetByName(root, "Panel_head_frame_effect")

	-- 称号容器
	self.Panel_title = ccui.Helper:seekWidgetByName(root, "Panel_title")

	-- 形象容器
	self.Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")

	-- 头像框显示父节点
	self.Panel_head_info = ccui.Helper:seekWidgetByName(root, "Panel_head_info")

	-- 印记数量文本
	self.Text_imprint_nums = ccui.Helper:seekWidgetByName(root, "Text_imprint_nums")

	-- 印记红点图片
	self.Image_red_imprint = ccui.Helper:seekWidgetByName(root, "Image_red_imprint")

	-- 头像款页签按钮红点
	self.Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")

	-- 头像框名称
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")

	-- 使用/佩戴文本
	self.Text_use = ccui.Helper:seekWidgetByName(root, "Text_use")

	-- 使用中文本显示
	self.Image_using = ccui.Helper:seekWidgetByName(root, "Image_using")

	-- 解锁条件文本
	self.Text_is_locking = ccui.Helper:seekWidgetByName(root, "Text_is_locking")

	-- 未解锁容器
	self.Panel_lock = ccui.Helper:seekWidgetByName(root, "Panel_lock")

	-- 头像文本
	self.Text_head_portrait = ccui.Helper:seekWidgetByName(root, "Text_head_portrait")

	-- 头像框文本
	self.Text_head_frame = ccui.Helper:seekWidgetByName(root, "Text_head_frame")

	-- 形象文本
	self.Text_role_image = ccui.Helper:seekWidgetByName(root, "Text_role_image")

	-- 称号文本
	self.Text_role_title = ccui.Helper:seekWidgetByName(root, "Text_role_title")

	self.textTabList = {}
	table.insert(self.textTabList, self.Text_head_portrait)
	table.insert(self.textTabList, self.Text_head_frame)
	table.insert(self.textTabList, self.Text_role_image)
	table.insert(self.textTabList, self.Text_role_title)

end

function PersonalitySettingMain:drawBtns()
	local root = self.roots[1]
	
	-- 印记界面查看按钮
	self.Button_imprint = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_imprint"), nil,
	{
		terminal_name = "personality_setting_main_jump_to_imprint",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 使用按钮
	self.Button_use = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use"), nil,
	{
		terminal_name = "personality_setting_main_use_cell",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭界面按钮
	self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "personality_setting_main_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 卸下按钮
	self.Button_remove = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_remove"), nil,
	{
		terminal_name = "personality_setting_main_remove_cell",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.btnTabList = {}
	table.insert(self.btnTabList, ccui.Helper:seekWidgetByName(root, "Button_head_portrait"))
	table.insert(self.btnTabList, ccui.Helper:seekWidgetByName(root, "Button_head_frame"))
	table.insert(self.btnTabList, ccui.Helper:seekWidgetByName(root, "Button_role_image"))
	table.insert(self.btnTabList, ccui.Helper:seekWidgetByName(root, "Button_role_title"))

	for i = 1, #self.btnTabList do
		-- 各页签按钮添加事件
		fwin:addTouchEventListener(self.btnTabList[i], nil,
		{
			terminal_name = "personality_setting_main_change_page",
			terminal_state = 0,
			isPressedActionEnabled = true,
			tabIndex = i,
		}, nil, 0)	
	end
end

function PersonalitySettingMain:onEnterTransitionFinish()
	-- 加载PersonalitySettingMainWindow界面资源.
	-- res.cocostudio.player.head_main = res/cocostudio/player/head_main.csb
	local csbNode = csb.createNode("player/head_main.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	self:onUpdateDraw()
	self:drawBtns()
	self:initDrawUI()
	-- 彩蛋事件添加
	showEasterEggEvent(8,-1,root)
end

function PersonalitySettingMain:onExit()
	-- 释放PersonalitySettingMainWindow界面资源.
	state_machine.remove("personality_setting_main_open")
	state_machine.remove("personality_setting_main_close")
	state_machine.remove("personality_setting_main_show")
	state_machine.remove("personality_setting_main_hide")
	state_machine.remove("personality_setting_main_jump_to_imprint")
	state_machine.remove("personality_setting_main_change_page")
	state_machine.remove("personality_setting_main_change_cell")
	state_machine.remove("personality_setting_main_use_cell")
	state_machine.remove("personality_setting_main_remove_cell")
	
end

function PersonalitySettingMain:close()
	-- window event : close.
	
end

function PersonalitySettingMain:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
