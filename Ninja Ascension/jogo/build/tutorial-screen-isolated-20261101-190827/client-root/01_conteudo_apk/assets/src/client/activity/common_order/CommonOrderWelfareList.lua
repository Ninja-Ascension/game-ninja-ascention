--------------------------------------------------------------------------------------------------------------
--  招募奖励全民福利列表cell
--------------------------------------------------------------------------------------------------------------
CommonOrderWelfareList = class("CommonOrderWelfareListClass", Window)
CommonOrderWelfareList.__size = nil

-- 创建cell
local common_order_welfare_list_window_tab_cell_create_terminal = {
    _name = "common_order_welfare_list_window_tab_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = CommonOrderWelfareList:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(common_order_welfare_list_window_tab_cell_create_terminal)
state_machine.init()

function CommonOrderWelfareList:ctor()
    self.super:ctor()
    self.roots = {}

    self.welfareInfo = {}
    self.welfareID = 0
    self.curType = 0
    self.curStage = 0

    -- 初始化状态机
    local function init_common_order_welfare_list_window_tab_cell_terminal()
        -- 领取全民福利奖励
        local common_order_welfare_list_get_reward_terminal = {
            _name = "common_order_welfare_list_get_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and params ~= nil then
                    local cell = params._datas.mcell
                    local welfareID = cell.welfareInfo.welfareID
                    local type = cell.curType
                    local function responseBuyPropCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(7)
                            fwin:open(getRewardWnd,fwin._ui)
                            
                            state_machine.excute("common_order_welfare_update", 0, nil)
                            fwin:addService({
                                callback = function ( params )
                                    state_machine.excute("notification_center_update", 0, "push_notification_common_warorder_welfare_reward_push")
                                    state_machine.excute("notification_center_update", 0, "push_notification_common_warorder_type_reward_can_receive_push")
                                end,
                                delay = 0,
                            })
                        end
                    end
                    local rewarddType = 3                       -- 全民福利奖励类型为3
                    protocol_command.normal_war_order_get_reward.param_list = type .. "\r\n" .. -1 .. "\r\n" .. rewarddType .. "\r\n" .. welfareID
                    NetworkManager:register(protocol_command.normal_war_order_get_reward.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)



                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(common_order_welfare_list_get_reward_terminal)
        state_machine.init()
    end 
    init_common_order_welfare_list_window_tab_cell_terminal()

end

-- 获取奖励内容
function CommonOrderWelfareList:getRewardInfo()
    local rewardIdx = self.welfareInfo.rewardIdx
    local rewardString = dms.string(dms["pass_reward_mould"], rewardIdx, pass_reward_mould.reward)
    return rewardString
end

-- 刷新
function CommonOrderWelfareList:updateDraw()
    self.Image_unComplete:setVisible(false)
    self.Image_completed:setVisible(false)
    self.Button_click_receive:setVisible(false)
    self.ListReward:removeAllItems()

    local state = self.welfareInfo.state
    local needNum = self.welfareInfo.needNum
    self.welfareID = self.welfareInfo.welfareID
    self.Text_desc:setString(string.format(war_order_str[6], needNum))
    if state == 0 then
        self.Image_unComplete:setVisible(true)
    elseif state == 1 then
        self.Button_click_receive:setVisible(true)
    elseif state == 2 then
        self.Image_completed:setVisible(true)
    end

    local rewardString = self:getRewardInfo()
    local rewardCells = DrawHandle.drawIcons(rewardString)
    for i, v in ipairs(rewardCells) do
        self.ListReward:addChild(v)
    end
    self.ListReward:jumpToLeft()
    self.ListReward:requestRefreshView()
end 

function CommonOrderWelfareList:onInit()
    local root = cacher.createUIRef("activity/passport/passport_main_welfare_cell_0.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if CommonOrderWelfareList.__size == nil then
        CommonOrderWelfareList.__size = root:getContentSize()
    end

    -- 未完成按钮
    self.Image_unComplete = ccui.Helper:seekWidgetByName(root, "Button_weidacheng")

    -- 已领取按钮
    self.Image_completed = ccui.Helper:seekWidgetByName(root, "Button_yilingqu")

    -- 任务文本描述
    self.Text_desc = ccui.Helper:seekWidgetByName(root, "Text_1")

    -- 奖励列表容器
    self.ListReward = ccui.Helper:seekWidgetByName(root, "ListView_1")

    -- 可领取按钮
    self.Button_click_receive =
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_lingqu"),
        nil,
        {
            terminal_name = "common_order_welfare_list_get_reward",
            terminal_state = 0,
            isPressedActionEnabled = true,
            mcell = self,
        },
        nil,
        0
    )


    self:updateDraw()
end

function CommonOrderWelfareList:onEnterTransitionFinish()
    local root = self.roots[1]
end

function CommonOrderWelfareList:clearUIInfo( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
    
end

function CommonOrderWelfareList:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function CommonOrderWelfareList:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:removeAllChildren(true)
    self:clearUIInfo()
    cacher.freeRef("activity/passport/passport_main_welfare_cell_0.csb", root)
    root:removeFromParent(false)
    self.roots = {}
end

function CommonOrderWelfareList:init(params)
    self.welfareInfo = params[1]
    self.curType = params[2]
    -- if self._index ~= nil and self._index <= 6 then
       self:onInit()
    -- end
    self:setContentSize(CommonOrderWelfareList.__size)
    return self
end

function CommonOrderWelfareList:onExit()
    self:clearUIInfo()
    cacher.freeRef("activity/passport/passport_main_welfare_cell_0.csb", self.roots[1])
end