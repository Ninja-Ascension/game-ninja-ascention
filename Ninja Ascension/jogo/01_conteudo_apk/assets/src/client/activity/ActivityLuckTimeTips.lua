--[[ ----------------------------------------------------------------------------
-- 幸运占卜窗口界面
--]] ----------------------------------------------------------------------------
ActivityLuckTimeTips = class("ActivityLuckTimeTipsClass", Window)

-- 打开窗口
local activity_luck_time_tips_window_open_terminal = {
	_name = "activity_luck_time_tips_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ActivityLuckTimeTipsClass") then
			fwin:open(ActivityLuckTimeTips:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local activity_luck_time_tips_window_close_terminal = {
	_name = "activity_luck_time_tips_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivityLuckTimeTipsClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_luck_time_tips_window_open_terminal)
state_machine.add(activity_luck_time_tips_window_close_terminal)
state_machine.init()

-- 构造器
function ActivityLuckTimeTips:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.awardPos = {}

	-- load lua files.
	-- Initialize activity luck time tips page state machine.
	local function init_activity_luck_time_tips_terminal()
		-- 打开角色创建窗口
		local activity_luck_time_tips_open_terminal = {
			_name = "activity_luck_time_tips_open",
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
		local activity_luck_time_tips_close_terminal = {
			_name = "activity_luck_time_tips_close",
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
		local activity_luck_time_tips_show_terminal = {
			_name = "activity_luck_time_tips_show",
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
		local activity_luck_time_tips_hide_terminal = {
			_name = "activity_luck_time_tips_hide",
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

		local activity_luck_time_tips_bagani_terminal = {
			_name = "activity_luck_time_tips_bagani",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("activity_luck_time_tips_window_close",0,0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 前往邮件
		local activity_luck_time_tips_gomail_terminal = {
			_name = "activity_luck_time_tips_gomail",
			_init = function (terminal)
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
					state_machine.excute("mail_home_window_open", 0, "")
					state_machine.excute("activity_luck_time_tips_window_close", 0, "")
					state_machine.excute("activity_luck_frame_window_close", 0, "")
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(activity_luck_time_tips_gomail_terminal)

		state_machine.add(activity_luck_time_tips_bagani_terminal)
		state_machine.add(activity_luck_time_tips_open_terminal)
		state_machine.add(activity_luck_time_tips_close_terminal)
		state_machine.add(activity_luck_time_tips_show_terminal)
		state_machine.add(activity_luck_time_tips_hide_terminal)
		state_machine.init()
	end
	-- call func init activity luck time tips state machine.
	init_activity_luck_time_tips_terminal()
end

-- 对象初始化
function ActivityLuckTimeTips:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end
function ActivityLuckTimeTips:getCellItem(pos,drawNum)
	local cell = self.cellItem:clone()
	local Text_luck_number_title = ccui.Helper:seekWidgetByName(cell, "Text_luck_number_title")
	Text_luck_number_title:setString(string.format(Text_luck_number_title:getString(),pos))
	
	local Text_luck_number = ccui.Helper:seekWidgetByName(cell, "Text_luck_number")
	Text_luck_number:setString("")
	
	local lucknum = zstring.split(_ED.active_activity[161].need_recharge_count,"@")
	lucknum = tostring(lucknum[2])
	local xiangdeng = 0
	drawNum = tostring(drawNum)
	for i=1, 5 do
		local char1 = string.sub(drawNum, i, i)
		local char2 = string.sub(lucknum, i, i)
		local Text_luck_number = ccui.Helper:seekWidgetByName(cell, "BitmapFontLabel_"..i)
		if char1 == char2 then
			xiangdeng = xiangdeng+1
			Text_luck_number:setFntFile("fonts/num_double_hit_2.fnt")
		else
			Text_luck_number:setFntFile("fonts/num_double_hit.fnt")
		end
		Text_luck_number:setString(char1)
	end
	local Text_luck_prize_number = ccui.Helper:seekWidgetByName(cell, "Text_luck_prize_number")
	local Image_luck_prize_bg = ccui.Helper:seekWidgetByName(cell, "Image_luck_prize_bg")
	local Image_day_lock_1 = ccui.Helper:seekWidgetByName(cell, "Image_day_lock_1")
	if xiangdeng <= 0 then
		Image_day_lock_1:setVisible(false)
		Image_luck_prize_bg:setVisible(false)
	else
		Image_day_lock_1:setVisible(true)
		Image_luck_prize_bg:setVisible(false)
		Text_luck_prize_number:setString(string.format(Text_luck_prize_number:getString(),tostring(6-xiangdeng)))
	end 
	return cell
end
function ActivityLuckTimeTips:onUpdateDraw()
	local root = self.roots[1]

	self.ListView_137 = ccui.Helper:seekWidgetByName(root, "ListView_137")
	self.ListView_137:setVisible(true)
	self.cellItem = ccui.Helper:seekWidgetByName(root, "Panel_luck_number_content")
	self.cellItem:setPosition(-1000,-1000)
	local Panel_luck_number = ccui.Helper:seekWidgetByName(root, "Panel_luck_number")
	if _ED.active_activity[161].activity_params.extObj.totalReward ~= nil and _ED.active_activity[161].activity_params.extObj.totalReward ~= "" then
		local myReworld =  zstring.splits(_ED.active_activity[161].activity_params.extObj.totalReward, "|",",")
	
		for i,v in pairs(myReworld) do
			local prop_data = v
			local cell = ResourcesIconCell:createCell()
			cell:setScale(0.6)
			cell:setAnchorPoint(0,1)
			cell:init(zstring.tonumber(prop_data[1]), zstring.tonumber(prop_data[3]), prop_data[2],nil,nil,true,true,1)
			self.ListView_137:addChild(cell)
		end
		self.ListView_137:setItemsMargin(-58)
		self.ListView_137:refreshView()
	end

	self.ListView_136 = ccui.Helper:seekWidgetByName(root, "ListView_136")
	self.ListView_136:setVisible(true)
	local localItem = _ED.active_activity[161].activity_params.extObj.ex
	local cellSize = self.cellItem:getContentSize()
	for i=1,10,2 do
		local default_item = ccui.Layout:create()
		default_item:setContentSize(cellSize.width*2,cellSize.height)
	
		local cell1 = self:getCellItem(i,localItem[i].divineNum)
		cell1:setPosition(0,0)
		default_item:addChild(cell1)

		local cell2 = self:getCellItem(i+1,localItem[i+1].divineNum)
		cell2:setPosition(cellSize.width,0)
		default_item:addChild(cell2)

		self.ListView_136:addChild(default_item)
	end
	self.ListView_136:refreshView()

	-- for i,v in pairs(_ED.divinationInfo.DrawResultMap) do 
	-- 	local cell = cellItem:clone()
	-- 	local Text_luck_number_title = ccui.Helper:seekWidgetByName(cell, "Text_luck_number_title")
	-- 	Text_luck_number_title:setString(string.format(Text_luck_number_title:getString(),i))
		
	-- 	local Text_luck_number = ccui.Helper:seekWidgetByName(cell, "Text_luck_number")

	-- 	local label2 = cc.Label:createWithBMFont("fonts/fnt_gold_num.fnt","1")
	-- 	label2:setString(v)
	-- 	debug.log(v)
	-- 	Text_luck_number:addChild(label2)
	-- 	local drawNum = _ED.divinationInfo.DrawResultMap[i]
	-- 	drawNum = tostring(drawNum)
	-- 	local lucknum = tostring(_ED.divinationInfo.lucky_num)
	-- 	for i=1, 5 do
	-- 		local char1 = string.sub(drawNum, i, i)
	-- 		local char2 = string.sub(lucknum, i, i)
			
	-- 		if char1 == char2 then
	-- 			debug.log(char1)
	-- 			debug.log(char2)
	-- 			-- label2:getLetter(i-1):setScale()
	-- 			-- label2:setColor(cc.c3b(117, 75, 50))
	-- 			label2:getLetter(i-1):setColor(cc.c3b(200, 30, 30))
	-- 		end
	-- 	end
		
	-- 	local Text_luck_prize_number = ccui.Helper:seekWidgetByName(cell, "Text_luck_prize_number")
	-- 	local Image_luck_prize_bg = ccui.Helper:seekWidgetByName(cell, "Image_luck_prize_bg")
	-- 	if tonumber(_ED.divinationInfo.DrawResultLuckyNumCountMap[i]) == 0 then
	-- 		Text_luck_prize_number:setVisible(false)
	-- 		Image_luck_prize_bg:setVisible(false)
	-- 	else
	-- 		Text_luck_prize_number:setVisible(true)
	-- 		Image_luck_prize_bg:setVisible(true)
	-- 		Text_luck_prize_number:setString(string.format(Text_luck_prize_number:getString(),6-tonumber(_ED.divinationInfo.DrawResultLuckyNumCountMap[i])))
	-- 	end
	-- 	cell:setPosition((1-i%2)*cellSize.width,(4-math.floor((i-1)/2))*cellSize.height+2)
	-- 	Panel_luck_number:addChild(cell)
	-- end
	

	-- self.ScrollView_luck_award_content = ccui.Helper:seekWidgetByName(root, "ScrollView_luck_award_content")

	-- self.reworlds = zstring.splits(_ED.divinationInfo.DrawReward, "|",",")
	-- -- self.reworlds = zstring.splits("1,1001,100|2,94,1", "|",",")
	
	-- debug.log(self.reworlds)
	-- local size = self.ScrollView_luck_award_content:getContentSize()
	-- local line = math.floor(table.nums(self.reworlds)/6)
	-- if line < 2 then
	-- 	line = 2
	-- end
	-- self.ScrollView_luck_award_content:setInnerContainerSize(cc.size(size.width, 85*line))
	-- local dis = 5
	-- local wid = 80
	-- for i = 1, table.nums(self.reworlds) do 
	-- 	local x = 0
	-- 	local y = 0
	-- 	if (i % 6) == 0 then
	-- 		x = 5*(dis+wid)+dis
	-- 	else
	-- 		x = (i % 6-1)*(dis+wid)+dis
	-- 	end			
	-- 	local curLine = line - math.floor((i-1)/6)
	-- 	if curLine == 1 then
	-- 		y = dis
	-- 	else
	-- 		y = (curLine-1)*(dis+wid)+dis
	-- 	end		
	-- 	cell = state_machine.excute("activity_daily_icon_cell_create", 0, {self.reworlds[i]})
	-- 	cell:setPosition(cc.p(x,y))
	-- 	if tonumber(self.reworlds[i][1]) == 4 then
	-- 		table.insert(self.awardPos,cell)
	-- 	end
	-- 	self.ScrollView_luck_award_content:addChild(cell)
	-- end

	-- local textdata=decideWhichPropIsFullFunc(self.reworlds)
	-- debug.log(self.reworlds,"textdata.reworlds")
	-- debug.log(textdata,"textdata")
	-- if textdata~="" then
	-- 	self.Button_luck_get:setVisible(true)
	-- else
	-- 	self.Button_luck_get:setVisible(false)
	-- 	self.Button_luck_confirm:setPositionX(self.roots[1]:getContentSize().width/2)
	-- end

end

function ActivityLuckTimeTips:onEnterTransitionFinish()
	-- 加载ActivityLuckTimeTipsWindow界面资源.
	-- res.activity.activity_luck_time_tips = res/activity/activity_luck_time_tips.csb
	local csbNode = csb.createNode("Lucky/activity_luck_time_tips.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 确定按键
	self.Button_luck_confirm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_confirm"), nil,
	{
		terminal_name = "activity_luck_time_tips_bagani",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	-- 前往邮件
	self.Button_luck_get = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_luck_get"), nil,
	{
		terminal_name = "activity_luck_time_tips_gomail",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:onUpdateDraw()
end

function ActivityLuckTimeTips:onExit()
	-- 释放ActivityLuckTimeTipsWindow界面资源.
	state_machine.remove("activity_luck_time_tips_open")
	state_machine.remove("activity_luck_time_tips_close")
	state_machine.remove("activity_luck_time_tips_show")
	state_machine.remove("activity_luck_time_tips_hide")
	state_machine.remove("activity_luck_time_tips_bagani")
	state_machine.remove("activity_luck_time_tips_gomail")
	
end

function ActivityLuckTimeTips:close()
	-- window event : close.
	
end

function ActivityLuckTimeTips:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
