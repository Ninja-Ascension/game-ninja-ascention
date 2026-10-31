--------------------------------------------------------------------------------------------------------------
--  招募奖励全民福利列表cell
--------------------------------------------------------------------------------------------------------------
ConstructionOrderWelfareList = class("ConstructionOrderWelfareListClass", Window)
ConstructionOrderWelfareList.__size = nil

-- 创建cell
local construction_order_welfare_list_window_tab_cell_create_terminal = {
    _name = "construction_order_welfare_list_window_tab_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = ConstructionOrderWelfareList:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(construction_order_welfare_list_window_tab_cell_create_terminal)
state_machine.init()

function ConstructionOrderWelfareList:ctor()
    self.super:ctor()
    self.roots = {}

    self.welfareInfo = {}
    self.welfareID = 0

    -- 初始化状态机
    local function init_construction_order_welfare_list_window_tab_cell_terminal()
        -- 领取全民福利奖励
        local construction_order_welfare_list_get_reward_terminal = {
            _name = "construction_order_welfare_list_get_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and params ~= nil then
                    local cell = params._datas.mcell
                    local welfareID = cell.welfareInfo.welfareID

                   
                    local function responseBuyPropCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(7)
                            fwin:open(getRewardWnd,fwin._ui)
                            
                            state_machine.excute("construction_order_welfare_update", 0, nil)
                        end
                    end
                    -- print(welfareID, "=====welfareID")
                    local oneClickCollection = 1                -- 不是一键领取为1
                    local rewarddType = 3                       -- 奖励类型为3
                    protocol_command.user_build_war_order_get_reward.param_list = oneClickCollection .. "\r\n" .. rewarddType .. "\r\n" .. welfareID
                    NetworkManager:register(protocol_command.user_build_war_order_get_reward.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(construction_order_welfare_list_get_reward_terminal)
        state_machine.init()
    end 
    init_construction_order_welfare_list_window_tab_cell_terminal()

end

-- 获取奖励内容
function ConstructionOrderWelfareList:getRewardInfo()
    local rewardIdx = self.welfareInfo.rewardIdx
    -- print(rewardIdx, "====rewardIdx")
    local rewardString = dms.string(dms["pass_reward_mould"], rewardIdx, pass_reward_mould.reward)
    return rewardString
end

-- 刷新
function ConstructionOrderWelfareList:updateDraw()
    self.Image_unComplete:setVisible(false)
    self.Image_completed:setVisible(false)
    self.Button_click_receive:setVisible(false)
    self.ListReward:removeAllItems()

    local state = self.welfareInfo.state
    local needNum = self.welfareInfo.needNum
    self.welfareID = self.welfareInfo.welfareID
    self.Text_desc:setString(string.format(war_order_str[6], needNum))
    if state == 0 then
        self.Button_uncomplete:setVisible(true)
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

function ConstructionOrderWelfareList:onInit()
    local root = cacher.createUIRef("activity/passport/passport_main_welfare_cell_0.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ConstructionOrderWelfareList.__size == nil then
        ConstructionOrderWelfareList.__size = root:getContentSize()
    end

    -- 已领取按钮
    self.Button_received = ccui.Helper:seekWidgetByName(root, "Button_received")

    -- 未完成按钮
    self.Button_uncomplete = ccui.Helper:seekWidgetByName(root, "Button_weidacheng")

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
            terminal_name = "construction_order_welfare_list_get_reward",
            terminal_state = 0,
            isPressedActionEnabled = true,
            mcell = self,
        },
        nil,
        0
    )

    -- 未完成按钮
    self.Image_unComplete = ccui.Helper:seekWidgetByName(root, "Button_weidacheng")

    -- 已领取按钮
    self.Image_completed = ccui.Helper:seekWidgetByName(root, "Button_yilingqu")


    self:updateDraw()
end

function ConstructionOrderWelfareList:onEnterTransitionFinish()
    local root = self.roots[1]
end

function ConstructionOrderWelfareList:clearUIInfo( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
    
end

function ConstructionOrderWelfareList:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ConstructionOrderWelfareList:unload()
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

function ConstructionOrderWelfareList:init(params)
    self.welfareInfo = params[1]
    -- if self._index ~= nil and self._index <= 6 then
       self:onInit()
    -- end
    self:setContentSize(ConstructionOrderWelfareList.__size)
    return self
end

function ConstructionOrderWelfareList:onExit()
    self:clearUIInfo()
    cacher.freeRef("activity/passport/passport_main_welfare_cell_0.csb", self.roots[1])
end