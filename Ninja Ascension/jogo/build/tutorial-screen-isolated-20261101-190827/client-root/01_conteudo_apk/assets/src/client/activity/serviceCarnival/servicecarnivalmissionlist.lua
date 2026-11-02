--[[ ----------------------------------------------------------------------------
-- 排行榜列表cell
--]] ----------------------------------------------------------------------------
ServiceCarnivalmissionList = class("ServiceCarnivalmissionListClass", Window)
ServiceCarnivalmissionList.__size = nil

-- 创建Cell实例
local service_carnivalmission_list_create_terminal = {
	_name = "service_carnivalmission_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if ServiceCarnivalmissionList then
			local cell = ServiceCarnivalmissionList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(service_carnivalmission_list_create_terminal)
state_machine.init()

-- 构造器
function ServiceCarnivalmissionList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.index = 1
	self.m_type = 1
	self.rewardState = 0		-- 任务状态
	self.missionID = 1			-- 任务ID
	self.ButtonList = {}		-- 按钮列表
	self.missionInfo = {}		-- 任务信息
	self.missionState = 1		-- 任务状态
	self.openState = 1			-- 该榜单是否开启
	-- load lua files.
	-- Initialize service carnivalmission list page state machine.
	local function init_service_carnivalmission_list_terminal()
		-- 前往按钮点击事件
		local service_carnivalmission_list_jump_terminal = {
			_name = "service_carnivalmission_list_jump",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local cell = params._datas.mcell
					local endTime = cell.endTime
					local openState = cell.openState
					local times = _ED.system_time + (os.time() - _ED.native_time)
					if openState ~= 2 or tonumber(times) > tonumber(endTime) then
						TipDlg.drawTextDailog(_new_interface_text[325])
                    	return false
					end
					local traceFunctionId = params._datas.functionID
					local openFunctionId = dms.int(dms["function_param"], traceFunctionId, function_param.open_function)
					if openFunctionId <= 0 or dms.int(dms["fun_open_condition"], openFunctionId, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
						if dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 27
							and dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 42 
							then
							fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
						end
						state_machine.excute("shortcut_function_trace", 0, {trace_function_id = traceFunctionId, _datas = {}})
					else
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
					end
                return true
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 领取奖励按钮点击事件
		local service_carnivalmission_list_get_reward_terminal = {
			_name = "service_carnivalmission_list_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local cell = params._datas.cell
					local state = cell.missionState
					local type = cell.m_type
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							-- if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								app.load("client.reward.DrawRareReward")
								local getRewardWnd = DrawRareReward:new()
								getRewardWnd:init(7)
								
								fwin:open(getRewardWnd, fwin._ui)
								state_machine.excute("service_carnival_main_update_achieve", nil, 0)
							-- end
						end
					end
					protocol_command.celebration_order_get_order_reward.param_list = type .. "\r\n" .. cell.missionID
					NetworkManager:register(protocol_command.celebration_order_get_order_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
			
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(service_carnivalmission_list_jump_terminal)
		state_machine.add(service_carnivalmission_list_get_reward_terminal)
		state_machine.init()
	end

	-- call func init service carnivalmission list state machine.
	init_service_carnivalmission_list_terminal()
end

-- 对象初始化
function ServiceCarnivalmissionList:init(params)
	
	self.missionInfo = params.missionInfo
	self.m_type = params.mType
	self.openState = params.openState
	self.endTime = params.endTime
	if params.missionState ~= nil then
		self.missionState = params.missionState
	end
	self.index = params.index
	if self.index <= 5 then
		self:onInit()
	end
	self:setContentSize(ServiceCarnivalmissionList.__size)
	return self
end

function ServiceCarnivalmissionList:onUpdateDraw()
	local root = self.roots[1]
	local Text_renwu_info = ccui.Helper:seekWidgetByName(root , "Text_renwu_info")
	local Text_num_now = ccui.Helper:seekWidgetByName(root , "Text_num_now")
	local Text_num_need = ccui.Helper:seekWidgetByName(root , "Text_num_need")
	
	local achieve_id = self.missionInfo[achieve.id]
	self.missionID = achieve_id
	local text = self.missionInfo[achieve.title]
	if Text_renwu_info ~= nil then
		Text_renwu_info:setString(text.."")
	end
	for i, v in ipairs(self.ButtonList) do
		self.ButtonList[i]:setVisible(false)
	end

	local activity_data = _ED.active_activity[182].activity_data
	local taskInfo = activity_data.achieveResult
	-- debug.print_r(taskInfo)
	
	self.rewardList:removeAllItems()
	local rewardInfos = zstring.split(self.missionInfo[achieve.reward_value] , "|")
	for i, v in ipairs(rewardInfos) do
		local rewardInfo = zstring.split(v , ",")
		local cell = DrawHandle.drawIcon(rewardInfo)
		self.rewardList:addChild(cell)
	end
	self.rewardList:requestRefreshView()

	local state = 1
	local serverState = 1
	local serverPro = 0

	for i, v in ipairs(taskInfo) do
		
		if tonumber(v[1]) == tonumber(achieve_id) then
			serverState = tonumber(v[2])
			serverPro = tonumber(v[3])
			break
		end
	end
	local userInfo = activity_data.userPowers
	local needText = self.missionInfo[achieve.param2]
	if serverPro ~= -1 then
		userInfo = serverPro
	end

	if serverState == 2 then
		state = 2
	else
		-- 当前进度大于累计进度，并且服务器传来的任务状态为可领取
		if tonumber(userInfo) >= tonumber(needText) and serverState == 1 then
			state = 1
		else
			state = 0
		end
	end

	local achieveType = tonumber(self.missionInfo[achieve.achive_type])
	
	if state ~= 0 then
		Text_num_now:setString(needText.."")
	else
		Text_num_now:setString(userInfo.."")
	end
	
	Text_num_need:setString("/"..needText)

	
	self.rewardState = state
	self.missionState = state
	for i, v in ipairs(self.ButtonList) do
		self.ButtonList[i]:setVisible(false)
	end
	-- 服务端传递的状态为0，1，2需加一
	local curState = state + 1
	self.ButtonList[curState]:setVisible(true)
end

function ServiceCarnivalmissionList:initDrawInfo()
	for i, v in ipairs(self.ButtonList) do
		self.ButtonList[i]:setVisible(false)
	end
end

function ServiceCarnivalmissionList:onEnterTransitionFinish()
	
end

function ServiceCarnivalmissionList:onInit()
	-- 加载ServiceCarnivalmissionListWindow界面资源.
	-- res.activity.service_carnival.service_carnival_mission_list = res/activity/service_carnival/service_carnival_mission_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/service_carnival/service_carnival_mission_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/service_carnival/service_carnival_mission_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	
	self:clearUIInfo()

	if ServiceCarnivalmissionList.__size == nil then
		ServiceCarnivalmissionList.__size = root:getContentSize()
	end
	self.ButtonList = {}

	-- 奖励列表		
	self.rewardList = ccui.Helper:seekWidgetByName(root, "ListView_cr_rewards")

	-- 前往按钮
	self.Button_go = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil,
	{
		terminal_name = "service_carnivalmission_list_jump",
		terminal_state = 0,
		isPressedActionEnabled = true,
		functionID = tonumber(self.missionInfo[achieve.track_address]),
		mcell = self,
	}, nil, 0)	
	table.insert(self.ButtonList , self.Button_go)

	-- 领取按钮
	self.Button_recevied = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recevied"), nil,
	{
		terminal_name = "service_carnivalmission_list_get_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
		cell = self,
	}, nil, 0)	
	table.insert(self.ButtonList , self.Button_recevied)

	self.Button_done = ccui.Helper:seekWidgetByName(root , "Image_done")
	table.insert(self.ButtonList , self.Button_done)

	-- self:initDrawInfo()

	self:onUpdateDraw()
end

function ServiceCarnivalmissionList:onExit()
	-- 释放ServiceCarnivalmissionListWindow界面资源.
	
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/service_carnival/service_carnival_mission_list.csb", root)
	-- ]]
end

function ServiceCarnivalmissionList:clearUIInfo()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Text_renwu_info = ccui.Helper:seekWidgetByName(root , "Text_renwu_info")
	local Text_num_now = ccui.Helper:seekWidgetByName(root , "Text_num_now")
	local Text_num_need = ccui.Helper:seekWidgetByName(root , "Text_num_need")
	local rewardList = ccui.Helper:seekWidgetByName(root , "ListView_cr_rewards")
	rewardList:removeAllItems()
	Text_renwu_info:setString("")
	Text_num_now:setString("")
	Text_num_need:setString("")
	-- for i, v in ipairs(self.ButtonList) do
	-- 	self.ButtonList[i]:setVisible(false)
	-- end
end

function ServiceCarnivalmissionList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ServiceCarnivalmissionList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/service_carnival/service_carnival_mission_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
