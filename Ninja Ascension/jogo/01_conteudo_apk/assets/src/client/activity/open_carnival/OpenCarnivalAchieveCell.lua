-- 成就任务列表cell
OpenCarnivalAchieveCell = class("OpenCarnivalAchieveCellClass", Window)
OpenCarnivalAchieveCell.__size = nil

--创建cell
local open_carnival_achieve_cell_cell_terminal = {
    _name = "open_carnival_achieve_cell_cell",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = OpenCarnivalAchieveCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(open_carnival_achieve_cell_cell_terminal)
state_machine.init()

function OpenCarnivalAchieveCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.rewardState = 0
    self.reworld_sorting = {}
    self.trace_id = -1

    local function init_open_carnival_achieve_cell_terminal()
        --
        local open_carnival_achieve_cell_cell_set_number_terminal = {
            _name = "open_carnival_achieve_cell_set_number",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                local mm_index = tonumber(params[2])
                if params[3] ~= nil and params[3] == true then
                else
                    cell:runAction(
                        cc.Sequence:create(
                            {
                                cc.DelayTime:create((mm_index - 1) * 0.1),
                                cc.CallFunc:create(
                                    function(sender)
                                        cell:setVisible(true)
                                        sender:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2, 0.9), cc.ScaleTo:create(0.1, 1)))
                                    end
                                )
                            }
                        )
                    )
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local open_carnival_achieve_cell_trace_terminal = {
            _name = "open_carnival_achieve_cell_trace",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local traceFunctionId = params._datas.cell.trace_id
                state_machine.excute("open_carnival_window_refrush_view", 0, "")

                local openFunctionId = dms.int(dms["function_param"], traceFunctionId, function_param.open_function)
                if dms.int(dms["fun_open_condition"], openFunctionId, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
                    if dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 27 and dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 42 then
                        fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
                    end
                    state_machine.excute("shortcut_function_trace", 0, {trace_function_id = traceFunctionId, _datas = {}})
                else
                    TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(open_carnival_achieve_cell_cell_set_number_terminal)
        state_machine.add(open_carnival_achieve_cell_trace_terminal)
        state_machine.init()
    end

    init_open_carnival_achieve_cell_terminal()
end

function OpenCarnivalAchieveCell:onUpdateDraw()
    local root = self.roots[1]
    local achieveid = tonumber(self.activity.id)
    local openday = self._activity_info.activity_cur_day -- 当前开启天数
    local selectDay = self.activity.dayIndex

    local dailyTaskMould = dms.element(dms["achieve"], achieveid)
    --奖励名称
    local Text_103 = ccui.Helper:seekWidgetByName(root, "Text_103")
    Text_103:setString(dms.atos(dailyTaskMould, achieve.title))

    --进度
    local Text_jindu = ccui.Helper:seekWidgetByName(root, "Text_jindu")
    local achieveData = self._activity_info.activity_init_info[selectDay][achieveid .. ""]

    local nowpersent = achieveData.complete
    local maxpersent = 0
    local data = {
        state = achieveData.status,
        persent = nowpersent,
        maxper = 0
    }
    local param1 = dms.atoi(dailyTaskMould, achieve.param1)
    local raceStr = ""
    -- 排名类的单独处理进度显示
    if param1 == 7 then 
        if data.state == 0 then
            raceStr = "0/1"
        else
            raceStr = "1/1"
        end
    else
        local param2 = dms.atoi(dailyTaskMould, achieve.param2)
        local param3 = dms.atoi(dailyTaskMould, achieve.param3)

        if param3 ~= -1 then
            maxpersent = param3
        else
            maxpersent = param2
        end
        data.maxper = maxpersent
        raceStr = data.persent .. "/" .. data.maxper
    end
    Text_jindu:setString(raceStr)

    --奖励
    local ListView_login_gift_list = ccui.Helper:seekWidgetByName(root, "ListView_1")
    ListView_login_gift_list:removeAllItems()
    local index = 1
    local dailyTaskTrace = dms.atoi(dailyTaskMould, achieve.track_address)
    local rewards = zstring.split(dms.atos(dailyTaskMould, achieve.reward_value), "|")
    for i, v in pairs(rewards) do
        local reward = zstring.split(v, ",")

        local rewardCell = DrawHandle.drawIcon(v)
        ListView_login_gift_list:addChild(rewardCell)

        local rewardinfo = {}
        rewardinfo.type = zstring.tonumber(reward[1])
        rewardinfo.id = tonumber(reward[2])
        rewardinfo.number = tonumber(reward[3])
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
    end

    ListView_login_gift_list:requestRefreshView()
    
    local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
    local Image_slock = ccui.Helper:seekWidgetByName(root, "Image_slock")

    self.Button_lingqu:setVisible(false)
    self.Button_trace:setVisible(false)
    Image_13:setVisible(false)
    Image_slock:setVisible(false)
    Text_jindu:setVisible(true)
    --进度的判断
    self.rewardState = data.state
    if openday < selectDay then 
        Image_slock:setVisible(true)
        self.rewardState = 0
    end
    if self.rewardState == 0 then
        -- 不可领取
        local traceId = dms.atoi(dailyTaskMould, achieve.track_address)
        self.trace_id = traceId
        if openday >= selectDay and traceId ~= -1 then
            self.Button_trace:setVisible(true)
        else
            self.Button_lingqu:setVisible(true)
            self.Button_lingqu:setBright(false)
            self.Button_lingqu:setTouchEnabled(false)
        end
    elseif self.rewardState == 1 then
        --可领取
        self.Button_lingqu:setVisible(true)
        self.Button_lingqu:setBright(true)
        self.Button_lingqu:setTouchEnabled(true)
    elseif self.rewardState == 2 then
        -- 已领取
        Image_13:setVisible(true)
        Text_jindu:setVisible(false)
    end
end

function OpenCarnivalAchieveCell:onInit()
    local root = cacher.createUIRef("activity/open_carnival/open_carnival_achieve_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if OpenCarnivalAchieveCell.__size == nil then
        OpenCarnivalAchieveCell.__size = root:getContentSize()
    end
    self:clearUIInfo()

    -- 领取
    self.Button_lingqu = fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_lingqu"),
        nil,
        {
            terminal_name = "open_carnival_window_get_reward",
            terminal_state = 0,
            touch_black = true,
            m_day = self.activity.dayIndex,
            m_type = self.activity.pageIndex,
            m_idx = self.activity.drawIndex
        },
        nil,
        1
    )

    -- 前往
    self.Button_trace =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_trace"),
        nil,
        {
            terminal_name = "open_carnival_achieve_cell_trace",
            terminal_state = 0,
            cell = self,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self:onUpdateDraw()
end

function OpenCarnivalAchieveCell:onEnterTransitionFinish()
end

function OpenCarnivalAchieveCell:clearUIInfo(...)
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    local Text_103 = ccui.Helper:seekWidgetByName(root, "Text_103")
    local Text_jindu = ccui.Helper:seekWidgetByName(root, "Text_jindu")
    local Image_slock = ccui.Helper:seekWidgetByName(root, "Image_slock")
    if ListView_1 ~= nil then
        ListView_1:removeAllItems()
        Text_103:setString("")
        Text_jindu:setString("")
        Image_slock:setVisible(false)
    end
end

function OpenCarnivalAchieveCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function OpenCarnivalAchieveCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef("activity/open_carnival/open_carnival_achieve_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(true)
    self.roots = {}
end

function OpenCarnivalAchieveCell:init(params)
    self.activity = params[1]
    self._activity_info = _ED.active_activity[194]
    self:onInit()
    self:setContentSize(OpenCarnivalAchieveCell.__size)
    return self
end

function OpenCarnivalAchieveCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("activity/open_carnival/open_carnival_achieve_cell.csb", self.roots[1])
end
