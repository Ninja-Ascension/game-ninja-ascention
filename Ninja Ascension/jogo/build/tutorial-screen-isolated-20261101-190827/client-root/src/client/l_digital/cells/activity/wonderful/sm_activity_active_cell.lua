--------------------------------------------------------------------------------------------------------------
SmActivityActiveCell = class("SmActivityActiveCellClass", Window)
SmActivityActiveCell.__size = nil

local sm_activity_active_cell_create_terminal = {
    _name = "sm_activity_active_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivityActiveCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_active_cell_create_terminal)
state_machine.init()

function SmActivityActiveCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._index = 0
    self._taskInfo = nil

    app.load("client.cells.utils.resources_icon_cell")
    local function init_sm_activity_active_cell_terminal()
        local sm_activity_active_cell_check_terminal = {
            _name = "sm_activity_active_cell_check",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cells = params._datas.cells
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(42)
                        fwin:open(getRewardWnd, fwin._ui)
                        state_machine.excute("sm_activity_active_window_update", 0, nil)
                    end
                end
                protocol_command.draw_daily_mission_reward.param_list = ""..cells._taskInfo.daily_task_id
                NetworkManager:register(protocol_command.draw_daily_mission_reward.code, nil, nil, nil, cells, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_activity_active_cell_go_to_terminal = {
            _name = "sm_activity_active_cell_go_to",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cells = params._datas.cells
                local traceFunctionId = dms.int(dms["daily_mission_param"], cells._taskInfo.daily_task_mould_id, daily_mission_param.trace_function_id)
                state_machine.excute("shortcut_function_trace", 0, {trace_function_id = traceFunctionId, _datas = {}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_activity_active_cell_check_terminal)
        state_machine.add(sm_activity_active_cell_go_to_terminal)
        state_machine.init()
    end
    init_sm_activity_active_cell_terminal()
end

function SmActivityActiveCell:updateDraw()
    local root = self.roots[1]
    local Text_id = ccui.Helper:seekWidgetByName(root, "Text_id")
    local Panel_15 = ccui.Helper:seekWidgetByName(root, "Panel_15")
    local Text_1_1 = ccui.Helper:seekWidgetByName(root, "Text_1_1")
    local Text_1_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_1_0")
    local Image_bg_ywc = ccui.Helper:seekWidgetByName(root, "Image_bg_ywc")
    local Image_bg_wwc = ccui.Helper:seekWidgetByName(root, "Image_bg_wwc")
    local Button_lq = ccui.Helper:seekWidgetByName(root, "Button_lq")
    local Button_qw = ccui.Helper:seekWidgetByName(root, "Button_qw")
    local ArmatureNode_1 = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("ArmatureNode_1")
    local Image_ywc = ccui.Helper:seekWidgetByName(root, "Image_ywc")

    Image_bg_ywc:setVisible(false)
    Image_bg_wwc:setVisible(false)
    Button_lq:setVisible(false)
    Button_qw:setVisible(false)
    Panel_15:removeAllChildren(true)
    ArmatureNode_1:setVisible(false)
    Image_ywc:setVisible(false)

    local dailyTaskMould = dms.element(dms["daily_mission_param"], self._taskInfo.daily_task_mould_id)
    local conditionParam = zstring.split(dms.atos(dailyTaskMould, daily_mission_param.condition_param), ",") -- 商城购买道具道具ID,次数的conditionParam值为模板id,次数
    local needCompleteCount = zstring.tonumber(conditionParam[#conditionParam])
    local rewardIcon = dms.atos(dailyTaskMould, daily_mission_param.pic_index)
    local rewardParam = zstring.split(dms.atos(dailyTaskMould, daily_mission_param.mission_reward), ",")

    if zstring.tonumber(self._taskInfo.daily_task_param) == 0 then
        if zstring.tonumber(self._taskInfo.daily_task_complete_count) >= needCompleteCount then
            Button_lq:setVisible(true)
            Image_bg_ywc:setVisible(true)
            -- DSC重塑更换动画
            local jsonFile = "images/ui/effice/effect_activity_1/effect_activity_1.json"
            local atlasFile = "images/ui/effice/effect_activity_1/effect_activity_1.atlas"
            local aniName = "animation"
            if true == cc.FileUtils:getInstance():isFileExist(jsonFile) then
                if __lua_project_id == __lua_project_l_digital then
                    local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, true, nil)
                    local Panel_effct = ccui.Helper:seekWidgetByName(root, "Panel_effct")
                    if Panel_effct ~= nil and animation ~= nil then
                        Panel_effct:removeAllChildren(true)
                        animation:setPosition(Panel_effct:getContentSize().width / 2, Panel_effct:getContentSize().height / 2)
                        Panel_effct:addChild(animation)
                    end
                end
            else
                ArmatureNode_1:setVisible(true)
            end
           
        else
            local dailyTaskTrace = dms.atoi(dailyTaskMould, daily_mission_param.trace_function_id)
            if dailyTaskTrace > 0 then
                Button_qw:setVisible(true)
            end
            Image_bg_wwc:setVisible(true)
        end
    else
        Image_ywc:setVisible(true)
        Image_bg_wwc:setVisible(true)
    end
    
    Text_id:setString(dms.atos(dailyTaskMould, daily_mission_param.mission_name))
    local count = self._taskInfo.daily_task_complete_count
    -- if tonumber(needCompleteCount) >= 100000000 then
    --     needCompleteCount = math.floor(needCompleteCount/100000000)..string_equiprety_name[39]
    -- else
    if tonumber(needCompleteCount) >= 10000 then
        needCompleteCount = math.floor(needCompleteCount/1000)..string_equiprety_name[40]
    end
    -- if tonumber(count) >= 100000000 then
    --     count = math.floor(count/100000000)..string_equiprety_name[39]
    -- else
    if tonumber(count) >= 10000 then
        count = math.floor(count/1000)..string_equiprety_name[40]
    end
    Text_1_1:setString(count.."/"..needCompleteCount)
    Text_1_1_0:setString(rewardParam[2])
    Panel_15:setBackGroundImage(string.format("images/ui/props/props_%d.png", rewardIcon))
end

function SmActivityActiveCell:onInit()
    local csbItem = csb.createNode("activity/wonderful/sm_active_list.csb")
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)

    if SmActivityActiveCell.__size == nil then
        SmActivityActiveCell.__size = ccui.Helper:seekWidgetByName(root, "Panel_2"):getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_bg_ywc"), nil, 
    {
        terminal_name = "sm_activity_active_cell_check", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lq"), nil, 
    {
        terminal_name = "sm_activity_active_cell_check", 
        terminal_state = 0, 
        touch_black = true,
        cells = self,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qw"), nil, 
    {
        terminal_name = "sm_activity_active_cell_go_to", 
        terminal_state = 0, 
        touch_black = true,
        cells = self,
    }, nil, 1)

	self:updateDraw()
end

function SmActivityActiveCell:onEnterTransitionFinish()

end

function SmActivityActiveCell:init(params)
    self._index = params[1]
    self._taskInfo = params[2]

	self:onInit()
    self:setContentSize(SmActivityActiveCell.__size)
    return self
end

function SmActivityActiveCell:onExit()
end