--[[ ----------------------------------------------------------------------------
-- 卡册主界面
--]] ----------------------------------------------------------------------------
Illustration = class("IllustrationClass", Window)

-- 打开窗口
local illustration_window_open_terminal = {
	_name = "illustration_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("IllustrationClass") then
			fwin:open(Illustration:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local illustration_window_close_terminal = {
	_name = "illustration_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		state_machine.excute("notification_center_update",0,"push_notification_cultivate_card_book")
		fwin:close(fwin:find("IllustrationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_window_open_terminal)
state_machine.add(illustration_window_close_terminal)
state_machine.init()

-- 构造器
function Illustration:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._ability_select = {13,14,15,16,17} 		-- 资质选择数据	(13.14,15,16,17)
	self._phase_select = 1			-- 攻防技选择	(1,2,3)
	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosX = 0
	-- load lua files.
	app.load("client.l_digital.cultivate.illustration.IllustrationAttributes")
	app.load("client.l_digital.cultivate.illustration.IllustrationRank")
	app.load("client.l_digital.cultivate.illustration.IllustrationRule")
	app.load("client.l_digital.cultivate.illustration.IllustrationAchievement")
	app.load("client.l_digital.cells.cultivate.illustration.illustration_cell")
	app.load("client.l_digital.cells.cultivate.illustration.illustration_combine_cell")
	app.load("client.l_digital.cultivate.illustration.IllustrationHandle")
	app.load("client.l_digital.cultivate.illustration.IllustrationTips")
	app.load("client.l_digital.cultivate.illustration.illustrationListManage")
	app.load("client.l_digital.cultivate.illustration.IllustrationSpecialConditionTips")
	-- Initialize illustration page state machine.
	local function init_illustration_terminal()
		-- 打开角色创建窗口
		local illustration_open_terminal = {
			_name = "illustration_open",
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
		local illustration_close_terminal = {
			_name = "illustration_close",
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

		-- 显示窗口
		local illustration_show_terminal = {
			_name = "illustration_show",
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
		local illustration_hide_terminal = {
			_name = "illustration_hide",
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

		-- 攻防技方向切换
		local illustration_change_phase_terminal = {
			_name = "illustration_change_phase",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance then
					instance:changePhase(params._datas.m_type)
					instance:updateCardList()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- -- 左滑右滑
		-- local illustration_left_right_terminal = {
		-- 	_name = "illustration_left_right",
		-- 	_init = function (terminal)
				
		-- 	end,
		-- 	_inited = false,
		-- 	_instance = self,
		-- 	_state = 0,
		-- 	_invoke = function(terminal, instance, params)
		-- 		if instance then
		-- 			instance.ListView_1:jumpToPercentHorizontal(params._datas.index * 100)
		-- 		end

		-- 		return true
		-- 	end,
		-- 	_terminal = nil,
		-- 	_terminals = nil
		-- }

		-- 下一个卡牌下标
		local hero_list_view_get_next_ship_info_terminal = {
            _name = "hero_list_view_get_next_ship_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
            	return instance:getNextPageShipInfo(params)
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		-- 刷新滑动列表位置
		local illustration_local_list_terminal = {
			_name = "illustration_local_list",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local chooseIndex = params
				local percentNum = params/(#instance._card_list)*100
				if instance then
					instance.ListView_1:jumpToPercentHorizontal(percentNum)
				end

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新页面
		local illustration_refush_list_terminal = {
			_name = "illustration_refush_list",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance then
					smFightingChange()
					instance:updateCardList()
					instance:showAchieveTip()
					instance:openUpLevelTip()
					instance:openSpecialConditionTip()
					instance:showRedTip()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		-- 刷新提示和红点页面
		local illustration_refush_bar_list_terminal = {
			_name = "illustration_refush_bar_list",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance then
					smFightingChange()
					local aniIndex = nil
					if params then
						aniIndex = params[1]
					end
					instance:updateCardList(1,aniIndex)
					instance:showAchieveTip()
					instance:openUpLevelTip()
					instance:openSpecialConditionTip()
					instance:showRedTip()

				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- -- 选中所有资质并切换列表
		-- local illustration_mark_all_ability_terminal = {
		-- 	_name = "illustration_mark_all_ability",
		-- 	_init = function (terminal)
				
		-- 	end,
		-- 	_inited = false,
		-- 	_instance = self,
		-- 	_state = 0,
		-- 	_invoke = function(terminal, instance, params)
		-- 		if instance then
		-- 			local phase_select = params
		-- 			instance:markAllAblility()
		-- 			instance:updateSelect()
		-- 			instance:changePhase(phase_select)
		-- 			instance:updateCardList()
		-- 		end
		-- 		return true
		-- 	end,
		-- 	_terminal = nil,
		-- 	_terminals = nil
		-- }

		-- -- 获得卡册中卡的索引(攻，防，技)
		-- local illustration_get_card_index_terminal = {
		-- 	_name = "illustration_get_card_index",
		-- 	_init = function (terminal)
				
		-- 	end,
		-- 	_inited = false,
		-- 	_instance = self,
		-- 	_state = 0,
		-- 	_invoke = function(terminal, instance, params)
		-- 		local index = 1
		-- 		local ship_id = params
		-- 		if instance then
		-- 			for k, v in pairs(instance._card_list) do
		-- 				if v == ship_id then
		-- 					index = k
		-- 					break
		-- 				end
		-- 			end
		-- 		end
		-- 		return index
		-- 	end,
		-- 	_terminal = nil,
		-- 	_terminals = nil
		-- }

		state_machine.add(illustration_open_terminal)
		state_machine.add(illustration_close_terminal)
		state_machine.add(illustration_show_terminal)
		state_machine.add(illustration_hide_terminal)
		state_machine.add(illustration_change_phase_terminal)
		state_machine.add(hero_list_view_get_next_ship_info_terminal)
		state_machine.add(illustration_local_list_terminal)
		state_machine.add(illustration_refush_list_terminal)
		state_machine.add(illustration_refush_bar_list_terminal)
		-- state_machine.add(illustration_mark_all_ability_terminal)
		-- state_machine.add(illustration_get_card_index_terminal)
		state_machine.init()
	end
	-- call func init illustration state machine.
	init_illustration_terminal()
end

-- 对象初始化
function Illustration:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

-- function Illustration:onUpdate( dt )
-- 	if self.ListView_1 then
-- 		local posX = self.ListView_1:getInnerContainer():getPositionX()
-- 		if posX <= -20 then
-- 			self.leftButton:setVisible(true)
-- 		else
-- 			self.leftButton:setVisible(false)
-- 		end
-- 		if posX >= self.ListView_1:getContentSize().width - self.ListView_1:getInnerContainer():getContentSize().width + 20 then
-- 			self.rightButton:setVisible(true)
-- 		else
-- 			self.rightButton:setVisible(false)
-- 		end
-- 	end
    
-- end

--获取下一个卡牌数据
function Illustration:getNextPageShipInfo( _chooseIndex )
	local chooseIndex =  _chooseIndex
	if 1 > chooseIndex then
		chooseIndex = #self._card_list
	elseif #self._card_list < chooseIndex then
		chooseIndex = 1
	end

	state_machine.excute("illustration_local_list",0,chooseIndex)
	local ship_id = nil
	local index = 1
	for k,v in pairs(self._card_list) do
		if index == tonumber(chooseIndex)  then
			ship_id = v
		end
		index = index + 1
	end
	
	return zstring.tonumber(ship_id), chooseIndex
end

function Illustration:onUpdateDraw()
	local root = self.roots[1]

	-- 当前级别卡册评分进度条
	self.LoadingBar_achievement = ccui.Helper:seekWidgetByName(root, "LoadingBar_achievement")

	-- 卡册总评分
	self.Text_points = ccui.Helper:seekWidgetByName(root, "Text_points")

	-- 当前级别获得卡册评分
	self.Text_n1 = ccui.Helper:seekWidgetByName(root, "Text_n1")
	self.Text_n1:setVisible(false)
	-- /
	self.Text_n1_0 = ccui.Helper:seekWidgetByName(root, "Text_n1_0")
	self.Text_n1_0:setVisible(false)
	-- 当前级别升级需要的卡册评分
	self.Text_n2 = ccui.Helper:seekWidgetByName(root, "Text_n2")
	self.Text_n2:setVisible(false)

	-- 左下角提示
	self.Panel_tips = ccui.Helper:seekWidgetByName(root, "Panel_tips")
	self.Panel_tips:setSwallowTouches(false)
	
	-- 成就属性展示
	self.Panel_tips = ccui.Helper:seekWidgetByName(root, "Panel_dialog")

	-- 下一目标文字
	self.Text_t = ccui.Helper:seekWidgetByName(root, "Text_t")
	self.Text_t:setVisible(false)

	-- 资质复选框
	self.Panel_quality = ccui.Helper:seekWidgetByName(root, "Panel_quality")

	local function onOpenTouchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			if sender.selectState then
				sender.selectState = false
			else
				sender.selectState = true
			end
			self:updateSelect()
			self:updateCardList()
        end
	end


	for i = 13,17 do
		local checkbox  = ccui.Helper:seekWidgetByName(root, "CheckBox_"..i)
		checkbox:addTouchEventListener(onOpenTouchEvent)
	end

	for k,v in pairs(self._ability_select) do
		local checkbox  = ccui.Helper:seekWidgetByName(root, "CheckBox_"..v)
		checkbox:setSelected(true)
		checkbox.selectState = true
	end

	local userinfo = UserTopInfoA:new()
	userinfo._rootWindows = self
	local info = fwin:open(userinfo,fwin._windows)
	self:updateSelect()
	self:changePhase(self._phase_select)
	self:updateCardList()
	self:openUpLevelTip()
	self:openSpecialConditionTip()
	self:showAchieveTip()
	self:showRedTip()
end

-- 成就属性显示
function Illustration:showAchieveTip()
	local root = self.roots[1]
	for i=1,3 do
		local Text_attributes_t = ccui.Helper:seekWidgetByName(root, "Text_attributes_t_"..i)
		local Text_attributes_n = ccui.Helper:seekWidgetByName(root, "Text_attributes_n_"..i)
		Text_attributes_n:setVisible(false)
		Text_attributes_t:setVisible(false)
	end

	local normalAdd,totalScore,totalAdd = IllustrationHandle.getAchieveByServer()
	if nil == totalScore then
		totalScore = 0
	end
	local achieveData,aimMark,aimId = IllustrationHandle.getAchieveAdd(totalScore)

	local addDatas = zstring.split(achieveData,"|")
	for i=1,#addDatas do
		local datas = zstring.split(addDatas[i],",")
		local addType = tonumber(datas[1])
		local addVal = tonumber(datas[2])
		local propertyName, propertyValue = getPropertyNameAndValue(addType, addVal)
		
		local Text_attributes_n = ccui.Helper:seekWidgetByName(root, "Text_attributes_n_"..i)
		Text_attributes_n:setString(propertyName)
		local Text_attributes_t = ccui.Helper:seekWidgetByName(root, "Text_attributes_t_"..i)
		Text_attributes_t:setString(propertyValue)
		Text_attributes_n:setVisible(true)
		Text_attributes_t:setVisible(true)
	end

	local percent = 100
	local showScore = totalScore
	if -1 ~= aimMark then
		local lastMark = IllustrationHandle.getAchieveById(aimId - 1)

		if nil ~= lastMark then
			totalScore = totalScore - lastMark
			aimMark = aimMark - lastMark
		end
		self.Text_n1:setString(""..totalScore)
		self.Text_n2:setString(""..aimMark)
		percent = totalScore / aimMark * 100
		self.Text_n1:setVisible(true)
		self.Text_n2:setVisible(true)
		self.Text_n1_0:setVisible(true)
		self.Text_t:setVisible(true)
	else

	end 
	self.Text_points:setString(""..showScore)
	self.LoadingBar_achievement:setPercent(percent)
end

-- 刷新资质选择
function Illustration:updateSelect()
	local root = self.roots[1]
	self._ability_select = {}
	for i = 13,17 do
		local checkbox  = ccui.Helper:seekWidgetByName(root, "CheckBox_"..i)
		local isSelected = checkbox.selectState
		if isSelected then
			table.insert( self._ability_select, i )
		end
	end
end

-- 刷新数据不改变列表顺序
function Illustration:updateOneCard()
	local listViewCards = self.ListView_1:getItems()
	
end

-- -- 勾选所有资质
-- function Illustration:markAllAblility()
-- 	local root = self.roots[1]
-- 	for i = 13, 17 do
-- 		local checkbox  = ccui.Helper:seekWidgetByName(root, "CheckBox_"..i)
-- 		checkbox:setSelected(true)
-- 		checkbox.selectState = true
-- 	end
-- end

-- 刷新卡列表
function Illustration:updateCardList(type,aniIndex)
	self.ListView_1:removeAllItems()
	local cardList = nil
	if type and self._card_list and  1 == type then
		cardList = self._card_list
	else
		if self._phase_select == 4 then
			cardList = IllustrationHandle.getSortCombineCards()
		else
			cardList = IllustrationHandle.getCardShipByPhase(self._phase_select,self._ability_select)
		end
	end
	self._card_list = cardList
	local index = 1
	local preMultipleCell = nil
	local multipleCell = nil
	for k,v in pairs(cardList) do
		local aniFlag = false
		if aniIndex and aniIndex == v then
			aniFlag = true
		end
		local cell = nil
		if self._phase_select == 4 then
			cell = state_machine.excute("illustration_combine_cell_create",0,{v,index,aniFlag})
		else
			cell = state_machine.excute("illustration_cell_create",0,{v,index,aniFlag})
		end
		
		if multipleCell == nil then
			local sizes = cell:getContentSize()
			multipleCell = illustrationListManage:createCell()
			multipleCell:init(self.ListView_1, cell:getContentSize())
			self.ListView_1:addChild(multipleCell)
			multipleCell.prev = preMultipleCell
			if preMultipleCell ~= nil then
				preMultipleCell.next = multipleCell
			end
		end
		multipleCell:addNode(cell)
		preMultipleCell = multipleCell
		multipleCell = nil
		index = index + 1
	end
	self.ListView_1:requestRefreshView()
	self.ListView_1:jumpToTop()
end

function Illustration:onUpdate(dt)
	if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
		local size = self.currentListView:getContentSize()
		local posX = self.currentInnerContainer:getPositionX()
		if self.currentInnerContainerPosX == posX then
			return
		end
		self.currentInnerContainerPosX = posX
		local items = self.currentListView:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempX = v:getPositionX() + posX
			if tempX + itemSize.width < 0 or tempX > size.width + itemSize.width then
				v:unload()
			else
				v:reload()
			end
		end
	end
end
-- 刷新攻防技
function Illustration:changePhase(pageIndex)
	self.Button_atk:setEnabled(true)
	self.Button_atk:setHighlighted(false)
	self.Button_def:setEnabled(true)
	self.Button_def:setHighlighted(false)
	self.Button_skill:setEnabled(true)
	self.Button_skill:setHighlighted(false)
	self.Button_comb:setEnabled(true)
	self.Button_comb:setHighlighted(false)

	self.Panel_quality:setVisible(true)

	if 1 == pageIndex then
		self.Button_atk:setEnabled(false)
		self.Button_atk:setHighlighted(true)
	elseif 2 == pageIndex then
		self.Button_def:setEnabled(false)
		self.Button_def:setHighlighted(true)
	elseif 3 == pageIndex then
		self.Button_skill:setEnabled(false)
		self.Button_skill:setHighlighted(true)
	elseif 4 == pageIndex then
		self.Button_comb:setEnabled(false)
		self.Button_comb:setHighlighted(true)

		self.Panel_quality:setVisible(false)
	end

	self._phase_select = pageIndex
end

-- 升级或道具缺少提示栏
function Illustration:openUpLevelTip()
	local canUpList,needProp = IllustrationHandle.getFlagUplevelAllCard()
	if fwin:find("IllustrationTipsClass") then
		state_machine.excute("illustration_tips_window_close",0,"")
	end
	if canUpList and 0 ~= #canUpList then
		state_machine.excute("illustration_tips_window_open",0,{type = 0, num = #canUpList, val = canUpList })
	elseif table.nums(needProp) > 0 then
		state_machine.excute("illustration_tips_window_open",0,{type = 1, num = needProp })
	end
	
end

-- 打开组合卡册隐藏条件完成提示栏
function Illustration:openSpecialConditionTip()
	if fwin:find("IllustrationSpecialConditionTipsClass") then
		state_machine.excute("illustration_special_condition_tips_window_close",0,"")
	end
	state_machine.excute("illustration_special_condition_tips_window_open", 0, nil)
end

-- 攻防技红点
function Illustration:showRedTip()
	IllustrationHandle.pushTipControl(self.Button_atk,false)
	IllustrationHandle.pushTipControl(self.Button_def,false)
	IllustrationHandle.pushTipControl(self.Button_skill,false)
	IllustrationHandle.pushTipControl(self.Button_comb,false)

	if IllustrationHandle.getPhaseFlagUnlockAllCard(1) or 0 < #IllustrationHandle.getPhaseFlagUplevelAllCard(1) then
		IllustrationHandle.pushTipControl(self.Button_atk,true)
	end
	if IllustrationHandle.getPhaseFlagUnlockAllCard(2) or (IllustrationHandle.getPhaseFlagUplevelAllCard(2) 
		and 0 < #IllustrationHandle.getPhaseFlagUplevelAllCard(2)) then
			IllustrationHandle.pushTipControl(self.Button_def,true)
	end
	if IllustrationHandle.getPhaseFlagUnlockAllCard(3) or (IllustrationHandle.getPhaseFlagUplevelAllCard(3) 
		and 0 < #IllustrationHandle.getPhaseFlagUplevelAllCard(3)) then
			IllustrationHandle.pushTipControl(self.Button_skill,true)
	end

	if IllustrationHandle.getCombineCardShowRedPoint() then
		IllustrationHandle.pushTipControl(self.Button_comb,true)
	end
end

function Illustration:onEnterTransitionFinish()
	-- 加载IllustrationWindow界面资源.
	-- res.cultivate.illustration.illustration = res/cultivate/illustration/illustration.csb
	local csbNode = csb.createNode("cultivate/illustration/illustration.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 跳转到规则
	self.Button_help = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil,
	{
		terminal_name = "illustration_rule_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 跳转到排行榜
	self.Button_ranking = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ranking"), nil,
	{
		terminal_name = "illustration_rank_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 跳转到属性总览
	self.Button_attribute = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_attribute"), nil,
	{
		terminal_name = "illustration_attributes_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 跳转到卡册评分成就页
	self.Button_achievement = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_achievement"), nil,
	{
		terminal_name = "illustration_achievement_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 攻卡按钮
	self.Button_atk = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_atk"), nil,
	{
		terminal_name = "illustration_change_phase",
		terminal_state = 0,
		m_type = 1,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 防卡按钮
	self.Button_def = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_def"), nil,
	{
		terminal_name = "illustration_change_phase",
		terminal_state = 0,
		m_type = 2,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 技卡按钮
	self.Button_skill = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_skill"), nil,
	{
		terminal_name = "illustration_change_phase",
		terminal_state = 0,
		m_type = 3,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 组合按钮
	self.Button_comb = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_comb"), nil,
	{
		terminal_name = "illustration_change_phase",
		terminal_state = 0,
		m_type = 4,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "illustration_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- -- 向右按钮
	-- self.rightButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_right"), nil,
	-- {
	-- 	terminal_name = "illustration_left_right",
	-- 	terminal_state = 0,
	-- 	touch_black = true,
    --     index = 1,
	-- 	isPressedActionEnabled = true,
	-- }, nil, 0)

	-- -- 向左按钮
	-- self.leftButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_right"), nil,
	-- {
	-- 	terminal_name = "illustration_left_right",
	-- 	terminal_state = 0,
	-- 	touch_black = true,
    --     index = 0,
	-- 	isPressedActionEnabled = true,
	-- }, nil, 0)
	-- 卡册主列表
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
	self.currentListView = self.ListView_1
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosX = self.currentInnerContainer:getPositionX()
	self:onUpdateDraw()

	-- DB2重塑,资质和组合卡册显示的处理
	self:showQualityAndCombinBtn()
	-- 彩蛋事件添加
    showEasterEggEvent(9,-1,root)
end

-- DB2重塑,资质和组合卡册显示的处理
function Illustration:showQualityAndCombinBtn()
	local root = self.roots[1]
	local Panel_select_14 = ccui.Helper:seekWidgetByName(root, "Panel_select_14")
	if Panel_select_14 ~= nil then 
		for i = 14,17 do 
			local Panel_select = ccui.Helper:seekWidgetByName(root, "Panel_select_".. i)
			local qualityOpen = IllustrationHandle.isQualityCardConfig(i)
			Panel_select:setVisible(qualityOpen)
		end
		local Button_comb = ccui.Helper:seekWidgetByName(root, "Button_comb")
		local combinOpen = IllustrationHandle.isCombineCardConfig()
		Button_comb:setVisible(combinOpen)
	end
end

function Illustration:onExit()
	-- 释放IllustrationWindow界面资源.
	state_machine.remove("illustration_open")
	state_machine.remove("illustration_close")
	state_machine.remove("illustration_show")
	state_machine.remove("illustration_hide")
	state_machine.remove("illustration_change_phase")
	state_machine.remove("illustration_left_right")
	state_machine.remove("hero_list_view_get_next_ship_info")
	state_machine.remove("illustration_local_list")
	state_machine.remove("illustration_refush_list")
	state_machine.remove("illustration_refush_bar_list")
	-- state_machine.remove("illustration_mark_all_ability")
	-- state_machine.remove("illustration_get_card_index")
end

function Illustration:close()
	-- window event : close.
	if fwin:find("IllustrationTipsClass") then
		state_machine.excute("illustration_tips_window_close",0,"")
	end
	if fwin:find("IllustrationSpecialConditionTipsClass") then
		state_machine.excute("illustration_special_condition_tips_window_close",0,"")
	end
end

function Illustration:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
