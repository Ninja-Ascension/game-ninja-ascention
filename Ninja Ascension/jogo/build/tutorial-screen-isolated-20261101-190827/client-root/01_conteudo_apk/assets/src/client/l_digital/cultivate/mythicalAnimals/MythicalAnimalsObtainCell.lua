--[[ ----------------------------------------------------------------------------
-- 获取途径cell
--]] ----------------------------------------------------------------------------
MythicalAnimalsObtainCell = class("MythicalAnimalsObtainCellClass", Window)
MythicalAnimalsObtainCell.__size = nil

-- 创建Cell实例
local mythical_animals_obtain_cell_create_terminal = {
	_name = "mythical_animals_obtain_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsObtainCell then
			local cell = MythicalAnimalsObtainCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_obtain_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsObtainCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._taskData = nil

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_obtain_cell_terminal()
		local mythical_animals_obtain_cell_jump_terminal = {
			_name = "mythical_animals_obtain_cell_jump",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local taskData = params._datas.taskData
				if taskData ~= nil then
					local taskType = tonumber(taskData.taskType)
					if taskType == 1 then
						-- 跨服王者战
						state_machine.excute("shortcut_function_trace", 0, {_datas = {traceId = 48}})
					elseif taskType == 2 then
						-- 王者战
						state_machine.excute("shortcut_function_trace", 0, {_datas = {traceId = 49}})
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 任务领奖
		local mythical_animals_obtain_cell_get_reward_terminal = {
			_name = "mythical_animals_obtain_cell_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local taskData = params._datas.taskData
				if taskData ~= nil then
					state_machine.lock("mythical_animals_obtain_cell_get_reward")

					local taskType = tonumber(taskData.taskType)

					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							app.load("client.reward.DrawRareReward")
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd, fwin._ui)

							-- 刷新界面
							state_machine.excute("mythical_animals_obtain_update_ui", 0, nil)

							state_machine.excute("mythical_animals_destiny_refresh_ui", 0, nil)

							state_machine.excute("notification_center_update",0,"push_notification_mythical_animal")

							state_machine.excute("mythical_animals_main_ui_refresh_red_dot", 0, 0)

							state_machine.unlock("mythical_animals_obtain_cell_get_reward")
						else
							state_machine.unlock("mythical_animals_obtain_cell_get_reward")
						end
					end
					protocol_command.magical_animals_activate_get_fate_task_reward.param_list = "" .. taskType
					NetworkManager:register(protocol_command.magical_animals_activate_get_fate_task_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_obtain_cell_jump_terminal)
		state_machine.add(mythical_animals_obtain_cell_get_reward_terminal)
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_obtain_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsObtainCell:init(params)
	self._taskData = params

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsObtainCell.__size)
	return self
end

function MythicalAnimalsObtainCell:onUpdateDraw()
	local root = self.roots[1]

	-- 前往
	self.Button_qw = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qw"), nil,
	{
		terminal_name = "mythical_animals_obtain_cell_jump",
		terminal_state = 0,
		isPressedActionEnabled = true,
		taskData = self._taskData
	}, nil, 0)	

	-- 领取
	self.Button_hd = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hd"), nil,
	{
		terminal_name = "mythical_animals_obtain_cell_get_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
		taskData = self._taskData
	}, nil, 0)	

	-- 图标
	self.Image_activity = ccui.Helper:seekWidgetByName(root, "Image_activity")
	-- 来源
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	-- 来源详情
	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")

	self.Panel_21 = ccui.Helper:seekWidgetByName(root, "Panel_21")

	self.Panel_renWu = ccui.Helper:seekWidgetByName(root, "Panel_renWu")

	-- 来源1
	self.Text_1_1 = ccui.Helper:seekWidgetByName(root, "Text_1_1")
	-- 来源详情1
	self.Text_renwu_1 = ccui.Helper:seekWidgetByName(root, "Text_renwu_1")

	self.Image_activity_0 = ccui.Helper:seekWidgetByName(root, "Image_activity_0")

	self.Panel_animation = ccui.Helper:seekWidgetByName(root, "Panel_animation")

	self.Panel_props = ccui.Helper:seekWidgetByName(root, "Panel_props")

	self.Image_done = ccui.Helper:seekWidgetByName(root, "Image_done")

	self:updateUI()
end

function MythicalAnimalsObtainCell:updateUI()
	self.Panel_21:setVisible(false)
	self.Panel_renWu:setVisible(false)

	if self._taskData ~= nil then
		self.Panel_renWu:setVisible(true)
		self.Button_qw:setVisible(true)
		
		self:updateCell2()
	else
		self.Panel_21:setVisible(true)
		self.Button_qw:setVisible(false)
		self.Text_1:setString(tipStringInfo_magical_animals_word[20])
		self.Text_1_0:setString(tipStringInfo_magical_animals_word[21])
	end
	
end

function MythicalAnimalsObtainCell:updateCell2()
	local taskType = tonumber(self._taskData.taskType)
	local name, describe = MythicalAnimalsHandle.getDestinyTaskDes(taskType)

	-- self.Text_1_1:setString(name)
	self.Text_1_1:setVisible(false)
	
	self.Image_activity_0:loadTexture(string.format("images/ui/text/TF_res/Mythical_animals/pic_obtain_%d.png", taskType))

	local status = tonumber(self._taskData.status)

	self.Panel_animation:removeAllChildren(true)
	if status == 1 then
		local jsonFile = "images/ui/effice/effect_illustration2/effect_illustration2.json"
		local atlasFile = "images/ui/effice/effect_illustration2/effect_illustration2.atlas"
		local aniName = "animation"
		local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, true, nil)
		animation:setPosition(cc.p(self.Panel_animation:getContentSize().width/2, self.Panel_animation:getContentSize().height/2))
		self.Panel_animation:addChild(animation)
	end

	self.Button_qw:setVisible(status == 0)
	self.Button_hd:setVisible(status == 1)
	self.Image_done:setVisible(status == 2)

	local taskProgressInfo = MythicalAnimalsHandle.getDestinyTaskProgress(taskType)

	self.Panel_props:removeAllChildren(true)
	if taskProgressInfo.taskReward ~= nil then
		local propData = zstring.split(taskProgressInfo.taskReward, ",")
		local cell = DrawHandle.drawIcon(propData)
		self.Panel_props:addChild(cell)

		describe = describe .. string.format("(%d/%d)", taskProgressInfo.curProgress, taskProgressInfo.nextProgress)
	end

	self.Text_renwu_1:setString(describe)
end

function MythicalAnimalsObtainCell:onInit(params)
	-- 加载MythicalAnimalsObtainCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_obtain_cell = res/cultivate/Mythical_animals/mythical_animals_obtain_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_obtain_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_obtain_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsObtainCell.__size == nil then
		MythicalAnimalsObtainCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsObtainCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.Text_1:setString("")

	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	self.Text_1_0:setString("")

	self.Text_1_1 = ccui.Helper:seekWidgetByName(root, "Text_1_1")
	self.Text_1_1:setString("")

	self.Text_renwu_1 = ccui.Helper:seekWidgetByName(root, "Text_renwu_1")
	self.Text_renwu_1:setString("")

	self.Panel_animation = ccui.Helper:seekWidgetByName(root, "Panel_animation")
	self.Panel_animation:removeAllChildren(true)

	self.Panel_props = ccui.Helper:seekWidgetByName(root, "Panel_props")
	self.Panel_props:removeAllChildren(true)

	self.Image_done = ccui.Helper:seekWidgetByName(root, "Image_done")
	self.Image_done:setVisible(false)
end

function MythicalAnimalsObtainCell:onExit()
	-- 释放MythicalAnimalsObtainCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_obtain_cell.csb", root)
	-- ]]
end

function MythicalAnimalsObtainCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsObtainCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_obtain_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
