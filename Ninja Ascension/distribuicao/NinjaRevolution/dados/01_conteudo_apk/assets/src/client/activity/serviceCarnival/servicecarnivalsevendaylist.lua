--[[ ----------------------------------------------------------------------------
-- 分页按钮列表容器cell
--]] ----------------------------------------------------------------------------
ServiceCarnivalSevendayList = class("ServiceCarnivalSevendayListClass", Window)
ServiceCarnivalSevendayList.__size = nil

-- 创建Cell实例
local service_carnival_sevenday_list_create_terminal = {
	_name = "service_carnival_sevenday_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if ServiceCarnivalSevendayList then
			local cell = ServiceCarnivalSevendayList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(service_carnival_sevenday_list_create_terminal)
state_machine.init()

-- 构造器
function ServiceCarnivalSevendayList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
    self.rewardState = 0
	self.index = 1
	self.achieveID = 1
	self.funcID = -1

    self.reworld_sorting = {}
	-- load lua files.

	-- Initialize service carnival sevenday list page state machine.
	local function init_service_carnival_sevenday_list_terminal()
				-- 领取
		local ervice_carnival_sevenday_list_getReward_terminal = {
			_name = "ervice_carnival_sevenday_list_getReward",
			_init = function (terminal)       
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if _ED.active_activity[183] == nil then
					return
				end

				local cells = params._datas.cells

				local function callback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
							return
						end

						local cell = response.node
						app.load("client.reward.DrawRareReward")
						local getRewardWnd = DrawRareReward:new()

						getRewardWnd:init(7, nil, cells.reworld_sorting)
						fwin:open(getRewardWnd, fwin._ui)

						local userData = cell.activity.userData
						local userData_day = userData.statusArr[tonumber(cell.activity.dayIndex)]
						local userData_page = userData_day[tonumber(cell.activity.pageIndex)]
						local userData_cell = userData_page[tonumber(cell.activity.drawIndex)]
						userData_cell.st = 1

						cell:updateDraw()
						state_machine.excute("service_carnival_sevenday_type_change", 0, {true}) 

						fwin:addService({
							callback = function ( params )
								-- state_machine.excute("notification_center_update", 0, "push_notification_service_carnival_7happy_page_push")
								state_machine.excute("notification_center_update", 0, "push_notification_service_carnival_7happy_day_push")
								state_machine.excute("notification_center_update", 0, "push_notification_service_carnival_page_push")
								state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 182)
							end,
							delay = 0,
						})

					end
				end

				local req = {}
				req.actId = _ED.active_activity[183].activity_id
				req.actType = 183
				req.rType = 0
				req.rDay = cells.activity.dayIndex
				req.rPage = cells.activity.pageIndex
				req.rIndex = cells.activity.drawIndex
				
				local reqStr = json.encode(req)
				protocol_command.carnival_n_day.param_list = reqStr
				NetworkManager:register(protocol_command.carnival_n_day.code, nil, nil, nil, cells, callback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 前往按钮
		
		local ervice_carnival_sevenday_list_forward_terminal = {
			_name = "ervice_carnival_sevenday_list_forward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local traceFunctionId = params._datas.functionID
					local openFunctionId = dms.int(dms["function_param"], traceFunctionId, function_param.open_function)
					if openFunctionId <= 0 or dms.int(dms["fun_open_condition"], openFunctionId, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
						if dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 27
							and dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 42 
							then
							-- fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
						end
						state_machine.excute("shortcut_function_trace", 0, {trace_function_id = traceFunctionId, _datas = {}})
						state_machine.excute("service_carnival_main_window_close", 0, nil)
					else
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(ervice_carnival_sevenday_list_getReward_terminal)
		state_machine.add(ervice_carnival_sevenday_list_forward_terminal)
		state_machine.init()
	end
	-- call func init service carnival sevenday list state machine.
	init_service_carnival_sevenday_list_terminal()
end

function ServiceCarnivalSevendayList:updateDraw()
    local root = self.roots[1]

    -- 当前cell的配置数据，成就id，目标完成最大数，奖励index
    local cellData = self.activity.data
	
    local dailyTaskMould = dms.element(dms["achieve"], self.activity.id)
    -- 奖励名称
   
    self.Text_renwu_info:setString(dms.atos(dailyTaskMould, achieve.title))

	local Text_num_now = ccui.Helper:seekWidgetByName(root, "Text_num_now")
	local Text_num_fen = ccui.Helper:seekWidgetByName(root, "Text_num_fen")
	local Text_num_need = ccui.Helper:seekWidgetByName(root, "Text_num_need")

    -- 当前cell的用户数据
    local userData = self.activity.userData
    local userData_day = userData.statusArr[tonumber(self.activity.dayIndex)]
    local userData_page = userData_day[tonumber(self.activity.pageIndex)]
    local userData_cell = userData_page[tonumber(self.activity.drawIndex)]
    
    local achieveid = tonumber(self.activity.id)
    local nowpersent = tonumber(userData_cell.cc)
	
    local maxpersent = 0
	
    local data = 
    {
        achieve_data = dailyTaskMould,
        achieve_id = achieveid,
        state = tonumber(userData_cell.st), -- 0未, 1 已领取 
        persent = nowpersent,
        maxper = cellData[2],
    }
    

    local strMaxper = cellData[2]
    if tonumber( cellData[2]) > 10000 then
        strMaxper = math.floor(tonumber( cellData[2]) / 1000) .. string_equiprety_name[40]
    else
        strMaxper =  cellData[2]
    end
	Text_num_need:setString(strMaxper)
    local strNow = data.persent
	
    if tonumber(data.persent) > 10000 then
        strNow = math.floor(tonumber(data.persent) / 1000) .. string_equiprety_name[40]
    else
        strNow = data.persent
    end
	Text_num_now:setString(strNow)

    -- 奖励
    local cell_gift = dms.string(dms["achieve"], self.activity.id, achieve.reward_value)
    local ListView_login_gift_list = ccui.Helper:seekWidgetByName(root, "ListView_seven_rewards")
    ListView_login_gift_list:removeAllItems()
    local index = 1
    local rewards = zstring.split(cell_gift, "|")
    for i, v in pairs(rewards) do
        local reward = zstring.split(v, ",")
        local rewardType = zstring.tonumber(reward[1])
        if rewardType == 1 then
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(1, tonumber(reward[3]), -1,nil,nil,true,true,1)
            ListView_login_gift_list:addChild(rewardIcon)

            local rewardinfo = {}
            rewardinfo.type = 1
            rewardinfo.id = -1
            rewardinfo.number = tonumber(reward[3])
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        elseif rewardType == 2 then
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(2, tonumber(reward[3]), -1,nil,nil,true,true,1)
            ListView_login_gift_list:addChild(rewardIcon)

            local rewardinfo = {}
            rewardinfo.type = 2
            rewardinfo.id = -1
            rewardinfo.number = tonumber(reward[3])
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
         elseif rewardType == 3 then
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(3, tonumber(reward[3]), -1,nil,nil,true,true,1)
            ListView_login_gift_list:addChild(rewardIcon)

            local rewardinfo = {}
            rewardinfo.type = 3
            rewardinfo.id = -1
            rewardinfo.number = tonumber(reward[3])
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        elseif rewardType == 12 then
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(12, tonumber(reward[3]), -1,nil,nil,true,true,1)
            ListView_login_gift_list:addChild(rewardIcon)

            local rewardinfo = {}
            rewardinfo.type = 12
            rewardinfo.id = -1
            rewardinfo.number = tonumber(reward[3])
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        elseif rewardType == 6 or reward[1] == "5" then
            local reawrdID = tonumber(reward[2])
            local rewardNum = tonumber(reward[3])
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(6, rewardNum, reawrdID,nil,nil,true,true,1)  
            ListView_login_gift_list:addChild(rewardIcon)

            local rewardinfo = {}
            rewardinfo.type = 6
            rewardinfo.id = reawrdID
            rewardinfo.number = rewardNum
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        elseif rewardType == 7 then
            local reawrdID = tonumber(reward[2])
            local rewardNum = tonumber(reward[3])
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(7, rewardNum, reawrdID,nil,nil,true,true,1,{equipQuality = 3})
            ListView_login_gift_list:addChild(rewardIcon)

            local rewardinfo = {}
            rewardinfo.type = 7
            rewardinfo.id = reawrdID
            rewardinfo.number = rewardNum
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        else
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1)
            ListView_login_gift_list:addChild(rewardIcon)

            local rewardinfo = {}
            rewardinfo.type = rewardType
            rewardinfo.id = tonumber(reward[2])
            rewardinfo.number = tonumber(reward[3])
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        end
    end
    ListView_login_gift_list:requestRefreshView()
	ListView_login_gift_list:jumpToLeft()
	self.Button_recevied:setVisible(false)
    -- ccui.Helper:seekWidgetByName(root,"Image_13"):setVisible(false)
	Text_num_need:setVisible(true)
	Text_num_now:setVisible(true)
    Text_num_fen:setVisible(true)
	
	if self.funcID == -1 and tonumber(data.state) == 0 then
		self.Button_go:setTouchEnabled(false)
		self.Button_go:setBright(false)
	else
		self.Button_go:setTouchEnabled(true)
		self.Button_go:setBright(true)
	end

    -- 未完成
    if tonumber(data.state) == 0 then
        self.rewardState = 1
		self.Button_recevied:setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_recevied"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_recevied"):setTouchEnabled(false)
		self.Button_go:setVisible(true)
		self.Image_done:setVisible(false)
    -- 可领取
    elseif tonumber(data.state) == 2 then
        self.rewardState = 0
		self.Button_recevied:setVisible(true)
        self.Button_recevied:setBright(true)
        self.Button_recevied:setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root,"Button_recevied"):setBright(true)
        ccui.Helper:seekWidgetByName(root,"Button_recevied"):setTouchEnabled(true)
		self.Button_go:setVisible(false)
		self.Image_done:setVisible(false)
    -- 已经领取
    elseif tonumber(data.state) == 1 then
        self.rewardState = 2
        self.Button_recevied:setVisible(false)
        -- ccui.Helper:seekWidgetByName(root,"Image_13"):setVisible(true)
		Text_num_need:setVisible(false)
		Text_num_now:setVisible(false)
		Text_num_fen:setVisible(false)
		self.Button_go:setVisible(false)
		self.Image_done:setVisible(true)
    end

end

-- 对象初始化
function ServiceCarnivalSevendayList:init(params)
    self.activity = params[1]
	self.index = params[2]
	
	self.achieveID = self.activity.id
	if self.index <= 6 then
		self:onInit()
	end
	self:setContentSize(ServiceCarnivalSevendayList.__size)
	return self
end

function ServiceCarnivalSevendayList:onUpdateDraw()
	local root = self.roots[1]

end

function ServiceCarnivalSevendayList:onEnterTransitionFinish()
	
end

function ServiceCarnivalSevendayList:onInit()
	-- 加载ServiceCarnivalSevendayListWindow界面资源.
	-- res.activity.service_carnival.service_carnival_sevenday_list = res/activity/service_carnival/service_carnival_sevenday_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/service_carnival/service_carnival_sevenday_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/service_carnival/service_carnival_sevenday_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	self:clearUIInfo()
	if ServiceCarnivalSevendayList.__size == nil then
		ServiceCarnivalSevendayList.__size = root:getContentSize()
	end

	-- 领取
	self.Button_recevied = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recevied"), nil,
	{
		terminal_name = "ervice_carnival_sevenday_list_getReward",
		terminal_state = 0,
		isPressedActionEnabled = true,
		cells = self,
	}, nil, 0)	

	-- 已领取
	self.Image_done = ccui.Helper:seekWidgetByName(root, "Image_done")
	self.funcID = dms.int(dms["achieve"], self.activity.id, achieve.track_address)
	-- 前往
	self.Button_go = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil,
	{
		terminal_name = "ervice_carnival_sevenday_list_forward",
		terminal_state = 0,
		isPressedActionEnabled = true,
		functionID = self.funcID
	}, nil, 0)
	-- 任务描述
	self.Text_renwu_info = ccui.Helper:seekWidgetByName(root, "Text_renwu_info")
	
	-- 奖励列表
	self.ListView_seven_rewards = ccui.Helper:seekWidgetByName(root, "ListView_seven_rewards")
	
	self:onUpdateDraw()
	self:updateDraw()
end

function ServiceCarnivalSevendayList:clearUIInfo()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local ListView_seven_rewards = ccui.Helper:seekWidgetByName(root, "ListView_seven_rewards")
	local Text_renwu_info = ccui.Helper:seekWidgetByName(root, "Text_renwu_info")

	ListView_seven_rewards:removeAllItems()
	Text_renwu_info:setString("")
end

function ServiceCarnivalSevendayList:onExit()
	-- 释放ServiceCarnivalSevendayListWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/service_carnival/service_carnival_sevenday_list.csb", root)
	-- ]]
end

function ServiceCarnivalSevendayList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ServiceCarnivalSevendayList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/service_carnival/service_carnival_sevenday_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
