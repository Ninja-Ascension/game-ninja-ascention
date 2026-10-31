--[[ ----------------------------------------------------------------------------
-- 任务列表项
--]] ----------------------------------------------------------------------------
RichmanTaskList = class("RichmanTaskListClass", Window)
RichmanTaskList.__size = nil

-- 创建Cell实例
local richman_task_list_create_terminal = {
	_name = "richman_task_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RichmanTaskList then
			local cell = RichmanTaskList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(richman_task_list_create_terminal)
state_machine.init()

-- 构造器
function RichmanTaskList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.taskInfo = nil

	-- load lua files.

	-- Initialize RichmanTaskList page state machine.
	local function init_richman_task_list_terminal()
		-- 任务界面跳转
        local richman_task_list_goto_terminal = {
            _name = "richman_task_list_goto",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and params ~= nil then
                    local traceFunctionId = params._datas.functionID
					local openFunctionId = dms.int(dms["function_param"], traceFunctionId, function_param.open_function)
					if openFunctionId <= 0 or dms.int(dms["fun_open_condition"], openFunctionId, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
						state_machine.excute("shortcut_function_trace", 0, {trace_function_id = traceFunctionId, _datas = {}})
						state_machine.excute("richman_task_window_close", 0, nil)
						state_machine.excute("richman_main_window_close", 0, nil)
					else
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
					end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(richman_task_list_goto_terminal)
		state_machine.init()
	end
	-- call func init RichmanTaskList state machine.
	init_richman_task_list_terminal()
end

-- 刷新
function RichmanTaskList:updateDraw()
    
    local descText = self.taskInfo.descText
    local rewardValue = self.taskInfo.rewardValue
    local state = self.taskInfo.state
    local curPro = self.taskInfo.curPro
    local allPro = self.taskInfo.allPro
    self.Text_desc:setString(descText)

    if curPro >= allPro and state == 1 then
        curPro = allPro
    end
    
    local rewardCell = DrawHandle.drawIcon(rewardValue)
    self.ListView_reward:addChild(rewardCell)

    self.Text_pro:setString(curPro.."/"..allPro)
    -- 如果已领取
    if state == 1 then
        self.ButtonReceived:setVisible(true)
        self.Button_go:setVisible(false)
    else
        self.ButtonReceived:setVisible(false)
        self.Button_go:setVisible(true)
        if self.funcID == -1 then
            self.Button_go:setTouchEnabled(false)
		    self.Button_go:setBright(false)
        else
            self.Button_go:setTouchEnabled(true)
		    self.Button_go:setBright(true)
        end
    end
end 

-- 对象初始化
function RichmanTaskList:init(params)
	self.taskInfo = params

	self:onInit(params)
	self:setContentSize(RichmanTaskList.__size)
	return self
end

function RichmanTaskList:updateUI()
	
end

function RichmanTaskList:onUpdateDraw()
	local root = self.roots[1]

	-- 领取按钮
	self.Button_3:setVisible(false)
	-- 前往按钮
	self.Button_4:setVisible(false)
	self.Image_8:setVisible(false)
	self.Panel_icon:removeAllChildren(true)
	self.Image_choose:setVisible(false)

    local rewardCell = DrawHandle.drawIcon(self.taskInfo.rewardValue)
    self.Panel_icon:addChild(rewardCell)

	self.Text_8:setString(self.taskInfo.descText)
	self.Text_9:setString(self.taskInfo.curPro.."/"..self.taskInfo.allPro)
	self.LoadingBar_1:setPercent(self.taskInfo.curPro / self.taskInfo.allPro * 100)

	if self.taskInfo.taskState == 1 then
        self.Button_3:setVisible(true)
        self.Image_choose:setVisible(true)
    elseif self.taskInfo.taskState == 0 then
        self.Button_4:setVisible(true)
        if self.funcID == -1 then
            self.Button_4:setTouchEnabled(false)
		    self.Button_4:setBright(false)
        else
            self.Button_4:setTouchEnabled(true)
		    self.Button_4:setBright(true)
        end
	elseif self.taskInfo.taskState == 2 then
        self.Image_8:setVisible(true)
    end
end

function RichmanTaskList:onEnterTransitionFinish()
	
end

function RichmanTaskList:onInit(params)
	-- 加载RichmanTaskList界面资源.
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/dafuweng/dafuweng_task_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/dafuweng/dafuweng_task_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RichmanTaskList.__size == nil then
		RichmanTaskList.__size = root:getContentSize()
	end

	-- 图标容器
	self.Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
	-- 已领取
	self.Image_8 = ccui.Helper:seekWidgetByName(root, "Image_8")
	-- 任务文本
	self.Text_8 = ccui.Helper:seekWidgetByName(root, "Text_8")
	-- 任务进度条
	self.LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
	-- 任务进度文本
	self.Text_9 = ccui.Helper:seekWidgetByName(root, "Text_9")
	-- 可领取
	self.Image_choose = ccui.Helper:seekWidgetByName(root, "Image_choose")

	self.funcID = dms.int(dms["achieve"], self.taskInfo.achieveID, achieve.track_address)
	-- 前往
	self.Button_4 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil,
	{
		terminal_name = "richman_task_list_goto",
		terminal_state = 0,
		isPressedActionEnabled = true,
        functionID = self.funcID,
	}, nil, 0)	
	-- 领取
	self.Button_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil,
	{
		terminal_name = "richman_task_get_reward_update",
		terminal_state = 0,
		isPressedActionEnabled = true,
        achieveID = self.taskInfo.achieveID,
	}, nil, 0)	
	
	self:onUpdateDraw()
end

function RichmanTaskList:onExit()
	-- 释放RichmanTaskList界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/dafuweng/dafuweng_task_list.csb", root)
	-- ]]
end

function RichmanTaskList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RichmanTaskList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/dafuweng/dafuweng_task_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
