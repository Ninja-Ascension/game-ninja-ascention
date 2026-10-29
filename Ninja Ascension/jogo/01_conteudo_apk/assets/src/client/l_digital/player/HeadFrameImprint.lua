--[[ ----------------------------------------------------------------------------
-- 头像框的印记界面
--]] ----------------------------------------------------------------------------
HeadFrameImprint = class("HeadFrameImprintClass", Window)

-- 打开窗口
local head_frame_imprint_window_open_terminal = {
	_name = "head_frame_imprint_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("HeadFrameImprintClass") then
			fwin:open(HeadFrameImprint:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local head_frame_imprint_window_close_terminal = {
	_name = "head_frame_imprint_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("HeadFrameImprintClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(head_frame_imprint_window_open_terminal)
state_machine.add(head_frame_imprint_window_close_terminal)
state_machine.init()

-- 构造器
function HeadFrameImprint:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.curHeadFrameInfo = {}
	self.curStage = -1
	self.initStage = -1
	self.curID = -1
	-- load lua files.
	app.load("client.l_digital.cells.player.head_frame_imprint_cell")
	-- Initialize head frame imprint page state machine.
	local function init_head_frame_imprint_terminal()
		-- 打开角色创建窗口
		local head_frame_imprint_open_terminal = {
			_name = "head_frame_imprint_open",
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
		local head_frame_imprint_close_terminal = {
			_name = "head_frame_imprint_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("head_frame_imprint_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local head_frame_imprint_show_terminal = {
			_name = "head_frame_imprint_show",
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
		local head_frame_imprint_hide_terminal = {
			_name = "head_frame_imprint_hide",
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

		-- 绘制复选框
		local head_frame_imprint_update_cell_checkbox_terminal = {
			_name = "head_frame_imprint_update_cell_checkbox",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 绘制复选框
				if nil ~= instance then
					local curStage = params
					instance:updateDrawCellIsSelect(curStage)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 确认佩戴
		local head_frame_imprint_confirm_wear_terminal = {
			_name = "head_frame_imprint_confirm_wear",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 确认佩戴
				if nil ~= instance then
					if instance.curStage == instance.initStage and instance.isUsed == true then
						TipDlg.drawTextDailog(tipStringInfo_face_text[5])
						return
					end
					state_machine.excute("personality_setting_main_use_cell", 0, {curID = instance.curID, curStage = instance.curStage})
					state_machine.excute("head_frame_imprint_close", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(head_frame_imprint_open_terminal)
		state_machine.add(head_frame_imprint_close_terminal)
		state_machine.add(head_frame_imprint_show_terminal)
		state_machine.add(head_frame_imprint_hide_terminal)
		state_machine.add(head_frame_imprint_update_cell_checkbox_terminal)
		state_machine.add(head_frame_imprint_confirm_wear_terminal)
		state_machine.init()
	end
	-- call func init head frame imprint state machine.
	init_head_frame_imprint_terminal()
end

function HeadFrameImprint:updateDrawCellIsSelect(curStage)
	local items = self.ListView_imprint:getItems()
	self.curStage = curStage
	for i, v in ipairs(items) do
		v:updateDrawSelected(curStage == v.curStage)
	end
end

-- 对象初始化
function HeadFrameImprint:init(params)
	self.curHeadFrameInfo = params
	self.curID = params.mouldData.headFrameID
	self.initStage = params.headFrameStage
	self.curStage = self.initStage
	self.isUsed = params.isUsed

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function HeadFrameImprint:onUpdateDraw()
	local root = self.roots[1]

	-- 用于存放所有印记阶段的容器
	self.ListView_imprint = ccui.Helper:seekWidgetByName(root, "ListView_imprint")

	-- 玩家当前印记数
	self.Text_imprint_nums = ccui.Helper:seekWidgetByName(root, "Text_imprint_nums")

	self:initDrawUI()
	self:updateDrawListView()
end

function HeadFrameImprint:initDrawUI()
	self.Text_imprint_nums:setString(self.curHeadFrameInfo.imprintNums)

	self.Button_up:setVisible(self.curHeadFrameInfo.unLocked)
end

function HeadFrameImprint:updateDrawListView()
	self.ListView_imprint:removeAllItems()

	local headFrameInfo = self.curHeadFrameInfo
	-- debug.print_r(headFrameInfo, "====headFrameInfo")
	local allStages = table.nums(headFrameInfo.mouldData.imprintStageInfo)
	for i = 1, allStages + 1 do
		local stageInfo = {}
		if i == allStages + 1 then
			stageInfo.picID = -1
		else
			stageInfo.picID = headFrameInfo.mouldData.bgIDInfo[i]
			stageInfo.effectID = headFrameInfo.mouldData.effectIDInfo[i]
			stageInfo.isChoosed = headFrameInfo.headFrameStage == i
			stageInfo.haveImprintNums = headFrameInfo.imprintNums
			stageInfo.needImprintNums = headFrameInfo.mouldData.imprintStageInfo[i]
			stageInfo.unLocked = headFrameInfo.unLocked
		end 
		stageInfo.curStage = i
		local cell = state_machine.excute("head_frame_imprint_cell_create", 0, stageInfo)
		self.ListView_imprint:addChild(cell)
	end

	self.ListView_imprint:requestRefreshView()
	self.ListView_imprint:jumpToLeft()
end

function HeadFrameImprint:onEnterTransitionFinish()
	-- 加载HeadFrameImprintWindow界面资源.
	-- res.cocostudio.player.imprint_main = res/player/imprint_main.csb
	local csbNode = csb.createNode("player/imprint_main.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭界面按钮
	self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "head_frame_imprint_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 佩戴按钮
	self.Button_up = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_up"), nil,
	{
		terminal_name = "head_frame_imprint_confirm_wear",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function HeadFrameImprint:onExit()
	-- 释放HeadFrameImprintWindow界面资源.
	state_machine.remove("head_frame_imprint_open")
	state_machine.remove("head_frame_imprint_close")
	state_machine.remove("head_frame_imprint_show")
	state_machine.remove("head_frame_imprint_hide")
	state_machine.remove("head_frame_imprint_update_cell_checkbox")
	state_machine.remove("head_frame_imprint_confirm_wear")
	
end

function HeadFrameImprint:close()
	-- window event : close.
	
end

function HeadFrameImprint:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
