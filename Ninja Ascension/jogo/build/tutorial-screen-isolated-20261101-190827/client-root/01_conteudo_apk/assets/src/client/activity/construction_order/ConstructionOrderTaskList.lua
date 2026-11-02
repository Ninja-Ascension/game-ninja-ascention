--------------------------------------------------------------------------------------------------------------
--  招募奖励任务列表cell
--------------------------------------------------------------------------------------------------------------
ConstructionOrderTaskList = class("ConstructionOrderTaskListClass", Window)
ConstructionOrderTaskList.__size = nil

-- 创建cell
local construction_order_task_list_create_terminal = {
    _name = "construction_order_task_list_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = ConstructionOrderTaskList:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(construction_order_task_list_create_terminal)
state_machine.init()

function ConstructionOrderTaskList:ctor()
    self.super:ctor()
    self.roots = {}

    self.taskState = 0
    self.taskIndex = 0
    self._index = -1
    self.funcID = -1
    self.taskInfo = {}

    -- 初始化状态机
    local function init_construction_order_task_list_terminal()
        -- 任务界面跳转
        local construction_order_task_list_goto_terminal = {
            _name = "construction_order_task_list_goto",
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
						state_machine.excute("construction_order_task_window_close", 0, nil)
					else
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
					end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(construction_order_task_list_goto_terminal)
        state_machine.init()
    end 
    init_construction_order_task_list_terminal()

end

-- 刷新
function ConstructionOrderTaskList:updateDraw()
    
    local descText = self.taskInfo.descText
    local rewardValue = self.taskInfo.rewardValue
    local state = self.taskInfo.state
    local curPro = self.taskInfo.curPro
    local allPro = self.taskInfo.allPro
    self.Text_desc:setString(descText)
    if curPro >= allPro and state == 1 then
        curPro = allPro
    end
    -- print(rewardValue, "====rewardValue")
    
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

function ConstructionOrderTaskList:onInit()
    local root = cacher.createUIRef("activity/passport/passport_main_jianhao_task_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ConstructionOrderTaskList.__size == nil then
        ConstructionOrderTaskList.__size = root:getContentSize()
    end

    -- self.taskInfo = dms.atos(dms["achieve"], self.taskIndex)
    self.funcID = dms.int(dms["achieve"], self.taskIndex, achieve.track_address)
    -- 前往按钮
    self.Button_go = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qianwang"), nil,
	{
		terminal_name = "construction_order_task_list_goto",
		terminal_state = 0,
		isPressedActionEnabled = true,
        functionID = self.funcID,
	}, nil, 0)	

    -- 文本描述
    self.Text_desc = ccui.Helper:seekWidgetByName(root, "Text_1")

    -- 任务进度
    self.Text_pro = ccui.Helper:seekWidgetByName(root, "Text_2")

    -- 已经领取
    self.ButtonReceived = ccui.Helper:seekWidgetByName(root, "Button_yiwancheng")

    -- 奖励列表容器
    self.ListView_reward = ccui.Helper:seekWidgetByName(root, "ListView_1")

    self:updateDraw()
end

function ConstructionOrderTaskList:onEnterTransitionFinish()
    local root = self.roots[1]
end

function ConstructionOrderTaskList:clearUIInfo( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
    -- 文本描述
    local Text_desc = ccui.Helper:seekWidgetByName(root, "Text_1")

    -- 已经领取
    local ButtonReceived = ccui.Helper:seekWidgetByName(root, "Button_yiwancheng")

    -- 前往按钮
    local Button_go = ccui.Helper:seekWidgetByName(root, "Button_qianwang")
    
    -- 奖励列表容器
    local ListView_reward = ccui.Helper:seekWidgetByName(root, "ListView_1")

    ButtonReceived:setVisible(false)
    Button_go:setVisible(false)
    Text_desc:setString("")
    ListView_reward:removeAllItems()

end

function ConstructionOrderTaskList:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ConstructionOrderTaskList:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:removeAllChildren(true)
    self:clearUIInfo()
    cacher.freeRef("shop/construction_order_task_list_tab_cell.csb", root)
    root:removeFromParent(false)
    self.roots = {}
end

function ConstructionOrderTaskList:init(params)
    self._index = params.index
    self.taskInfo = params.info
    self.taskIndex = self.taskInfo.taskID
    self.taskState = self.taskInfo.state
    if self._index ~= nil and self._index <= 6 then
       self:onInit()
    end
    self:setContentSize(ConstructionOrderTaskList.__size)
    return self
end

function ConstructionOrderTaskList:onExit()
    self:clearUIInfo()
    cacher.freeRef("shop/construction_order_task_list_tab_cell.csb", self.roots[1])
end