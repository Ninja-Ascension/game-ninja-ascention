SmCultivateArtifactConfirmTrain = class("SmCultivateArtifactConfirmTrain", Window)

-- 打开窗口
local sm_cultivate_artifact_confirm_train_window_open_terminal = {
    _name = "sm_cultivate_artifact_confirm_train_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("SmCultivateArtifactConfirmTrain") then
            fwin:open(SmCultivateArtifactConfirmTrain:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local sm_cultivate_artifact_confirm_train_window_close_terminal = {
    _name = "sm_cultivate_artifact_confirm_train_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmCultivateArtifactConfirmTrain"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cultivate_artifact_confirm_train_window_open_terminal)
state_machine.add(sm_cultivate_artifact_confirm_train_window_close_terminal)
state_machine.init()

function SmCultivateArtifactConfirmTrain:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- 默认最大培训数
    self.DEFAULT_MAX_TRAIN_NUM = 100

    local function init_sm_cultivate_artifact_confirm_train_terminal()
        
        local sm_cultivate_artifact_confirm_train_close_terminal = 
        {
            _name = "sm_cultivate_artifact_confirm_train_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("SmCultivateArtifactConfirmTrain"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_confirm_train_confirm_terminal = 
        {
            _name = "sm_cultivate_artifact_confirm_train_confirm",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local artifactInfoView = fwin:find("SmCultivateArtifactInfoClass")
                if artifactInfoView == nil then
                    return
                end

                local count = instance.numChoose

                state_machine.lock("sm_cultivate_artifact_confirm_train_confirm")
                state_machine.lock("sm_cultivate_artifact_confirm_train_close")
                local function responseCallBack( response )
                    state_machine.unlock("sm_cultivate_artifact_confirm_train_confirm")
                    state_machine.unlock("sm_cultivate_artifact_confirm_train_close")

                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- 关闭界面
                        state_machine.excute("sm_cultivate_artifact_confirm_train_close", 0, nil)

                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("sm_cultivate_artifact_open_result", 0, true)

                            -- 更新按钮状态
                            response.node:updateButtonState(true)
                            response.node:showAddAttr()
                        end

                        -- 刷新红点
                        state_machine.excute("notification_center_update",0,"push_notification_cultivate_artifact")
                        state_machine.excute("notification_center_update",0,"push_notification_home_cultivate")
                    end
                end
                local id = dms.string(dms["artifact_mould"], artifactInfoView._chooseCellIndex, artifact_mould.id)
                protocol_command.artifact_culture.param_list = id.."\r\n"..(artifactInfoView._chooseIndex - 1).."\r\n"..count
                NetworkManager:register(protocol_command.artifact_culture.code, nil, nil, nil, artifactInfoView, responseCallBack, false, nil)  

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cultivate_artifact_confirm_train_operation_terminal = 
        {
            _name = "sm_cultivate_artifact_confirm_train_operation",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local num = params._datas.num
                instance:operationNum(num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_cultivate_artifact_confirm_train_close_terminal)
        state_machine.add(sm_cultivate_artifact_confirm_train_confirm_terminal)
        state_machine.add(sm_cultivate_artifact_confirm_train_operation_terminal)
        
        state_machine.init()
    end

    init_sm_cultivate_artifact_confirm_train_terminal()
end

function SmCultivateArtifactConfirmTrain:init(params)
    self.params = params
    
    self:initData()
    
    if nil ~= self.onInit then
        self:onInit(params)
    end

    return self
end

function SmCultivateArtifactConfirmTrain:onEnterTransitionFinish()
    local csbNode = csb.createNode("cultivate/cultivate_artifact_tab_3.csb")
    self:addChild(csbNode)

    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)

    -- 定义按钮控件
    self.btnClose = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
    {
        terminal_name = "sm_cultivate_artifact_confirm_train_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)
    
    self.btnConfirm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_py"), nil,
    {
        terminal_name = "sm_cultivate_artifact_confirm_train_confirm",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    self.Button_num_0_1 = ccui.Helper:seekWidgetByName(root, "Button_add")
    self.Button_num_0_10 = ccui.Helper:seekWidgetByName(root, "Button_add_1")
    self.Button_num_1_1 = ccui.Helper:seekWidgetByName(root, "Button_min")
    self.Button_num_1_10 = ccui.Helper:seekWidgetByName(root, "Button_min_1")

    fwin:addTouchEventListener(self.Button_num_0_1, nil,
    {
        terminal_name = "sm_cultivate_artifact_confirm_train_operation",
        terminal_state = 0,
        isPressedActionEnabled = true,
        num = -1
    }, nil, 0)

    fwin:addTouchEventListener(self.Button_num_0_10, nil,
    {
        terminal_name = "sm_cultivate_artifact_confirm_train_operation",
        terminal_state = 0,
        isPressedActionEnabled = true,
        num = -10
    }, nil, 0)

    fwin:addTouchEventListener(self.Button_num_1_1, nil,
    {
        terminal_name = "sm_cultivate_artifact_confirm_train_operation",
        terminal_state = 0,
        isPressedActionEnabled = true,
        num = 1
    }, nil, 0)

    fwin:addTouchEventListener(self.Button_num_1_10, nil,
    {
        terminal_name = "sm_cultivate_artifact_confirm_train_operation",
        terminal_state = 0,
        isPressedActionEnabled = true,
        num = 10
    }, nil, 0)

    self.Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_1")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            local percent = sender:getPercent()
            self:updateSliderBySlider(percent)
        end
    end
    self.Slider_number:addEventListener(percentChangedEvent)

    self:onUpdateDraw()
    self:showData()
end

function SmCultivateArtifactConfirmTrain:onUpdateDraw()
    local root = self.roots[1]

    -- 定义除按钮外的其他UI控件
    self.Text_num_0 = ccui.Helper:seekWidgetByName(root, "Text_num_0")

    -- 消耗道具
    self.Image_item_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
    self.Image_item_2 = ccui.Helper:seekWidgetByName(root, "Image_1_1")
    self.Image_item_3 = ccui.Helper:seekWidgetByName(root, "Image_1_0")
    self.Text_item_1 = ccui.Helper:seekWidgetByName(root, "Text_4")
    self.Text_item_2 = ccui.Helper:seekWidgetByName(root, "Text_4_1")
    self.Text_item_3 = ccui.Helper:seekWidgetByName(root, "Text_4_0")
end

function SmCultivateArtifactConfirmTrain:initData()
    -- 更新数据
    local maxNum, costInfo = state_machine.excute("sm_cultivate_artifact_info_count_max_num", 0, nil)

    self.countMaxNum = maxNum

    local maxTrainLevel = dms.int(dms["play_config"], 291, play_config.param)
    if maxTrainLevel == nil then
        maxTrainLevel = self.DEFAULT_MAX_TRAIN_NUM
    end

    if self.countMaxNum > maxTrainLevel then
        self.countMaxNum = maxTrainLevel
    end
    self.numChoose = 1

    self.costInfo = costInfo
end

function SmCultivateArtifactConfirmTrain:showData()
    -- 更新显示
    self:updateSlider()
end

function SmCultivateArtifactConfirmTrain:operationNum(changeNums)
    -- 如果选中数值有修改
    if changeNums ~= nil then
        local haveCount = self.numChoose + changeNums
        if haveCount < 1 then
            haveCount = 1
        elseif haveCount > self.countMaxNum then
            haveCount = self.countMaxNum
        end

        -- 刷新进度条
        self.numChoose = haveCount
        self:updateSlider()
    end
end

function SmCultivateArtifactConfirmTrain:updateSlider()
    local percent = self.numChoose / self.countMaxNum * 100

    self.Slider_number:setPercent(percent)

    self:showChooseNum()
end

function SmCultivateArtifactConfirmTrain:updateSliderBySlider(percent_in)
    local percent = percent_in

    self.numChoose = math.floor(self.countMaxNum * percent / 100)

    if self.numChoose < 1 then
        self.numChoose = 1
    end

    self:showChooseNum()
end

function SmCultivateArtifactConfirmTrain:showChooseNum()
    self.Text_num_0:setString(self.numChoose.."/"..self.countMaxNum)

    self.Image_item_2:setVisible(false)
    self.Image_item_3:setVisible(false)

    self.Text_item_2:setVisible(false)
    self.Text_item_3:setVisible(false)

    for i,v in ipairs(self.costInfo) do
        local lstDataCost = zstring.split(v, ",", zstring.tonumber)
        local type = lstDataCost[1]
        local typeID = lstDataCost[2]
        local value = lstDataCost[3]
        value = value * self.numChoose
        if type == 6 then
            -- 绘制消耗品图标
            self.Text_item_1:setString("x"..value)
        elseif type == 1 then
            -- 绘制金币图标
            self.Image_item_2:setVisible(true)
            self.Text_item_2:setVisible(true)
            self.Text_item_2:setString("x"..value)
        elseif type == 2 then
            -- 绘制钻石图标
            self.Image_item_3:setVisible(true)
            self.Text_item_3:setVisible(true)
            self.Text_item_3:setString("x"..value)
        end
    end
end

function SmCultivateArtifactConfirmTrain:onExit()
    state_machine.remove("sm_cultivate_artifact_confirm_train_close")
    state_machine.remove("sm_cultivate_artifact_confirm_train_confirm")
    state_machine.remove("sm_cultivate_artifact_confirm_train_operation")
end

function SmCultivateArtifactConfirmTrain:close()

end

function SmCultivateArtifactConfirmTrain:destroy(window)
 
end
