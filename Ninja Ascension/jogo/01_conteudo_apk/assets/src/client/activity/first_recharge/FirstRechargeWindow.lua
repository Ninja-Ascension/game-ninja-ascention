--[[ ----------------------------------------------------------------------------
-- 首冲主界面
--]] ----------------------------------------------------------------------------
FirstRechargeWindow = class("FirstRechargeWindowClass", Window)

-- 打开窗口
local first_recharge_window_open_terminal = {
    _name = "first_recharge_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("FirstRechargeWindowClass") then
            fwin:open(FirstRechargeWindow:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local first_recharge_window_close_terminal = {
    _name = "first_recharge_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FirstRechargeWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(first_recharge_window_open_terminal)
state_machine.add(first_recharge_window_close_terminal)
state_machine.init()

-- 构造器
function FirstRechargeWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._cur_page = 0 -- 当前天数
    self._activity_reward = nil -- 活动奖励数据
    self._is_recharge = false -- 玩家是否已充值
    self._is_get_effect = false -- 光效是否已加载

    -- load lua files.
    app.load("client.cells.utils.resources_icon_cell")
    -- Initialize first recharge window page state machine.
    local function init_first_recharge_window_terminal()
        -- 切换天数显示
        local first_recharge_window_change_page_terminal = {
            _name = "first_recharge_window_change_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    local mPage = params._datas.m_page
                    instance:changePage(mPage)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 领取奖励
        local first_recharge_window_get_reward_terminal = {
            _name = "first_recharge_window_get_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local curPage = instance._cur_page
                if nil ~= instance then
                    if instance:haveGetFlag(curPage) then
                        state_machine.lock("first_recharge_window_get_reward")
                        local function responseChangeCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 and response.node ~= nil and response.node.roots[1] ~= nil then
                                response.node:refrushView(curPage)
                                
                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(7)
                                fwin:open(getRewardWnd, fwin._ui)

                                if not GetFlagActivityForFirstRecharge() then 
                                    state_machine.excute("activity_window_remove_activity_info", 0, 193)
                                    state_machine.excute("home_update_top_activity_info_state", 0, nil)
                                    state_machine.excute("first_recharge_window_close", 0, nil)
                                end

                            end
                            state_machine.unlock("first_recharge_window_get_reward")
                        end

                        protocol_command.first_charge_receive_reward.param_list = (curPage - 1) .. ""
                        NetworkManager:register(protocol_command.first_charge_receive_reward.code, nil, nil, nil, instance, responseChangeCallback, false, nil)
                    else
                        TipDlg.drawTextDailog(tipStringInfo_first_recharge_tip[1])
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 去充值
        local first_recharge_window_goto_recharge_terminal = {
            _name = "first_recharge_window_goto_recharge",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("first_recharge_window_goto_recharge")
                state_machine.excute("shortcut_open_recharge_window", 0, "")
                state_machine.excute("recharge_dialog_open_move_recharge_min", 0, "")
                state_machine.excute("first_recharge_window_close", 0, "")
                state_machine.unlock("first_recharge_window_goto_recharge")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(first_recharge_window_change_page_terminal)
        state_machine.add(first_recharge_window_get_reward_terminal)
        state_machine.add(first_recharge_window_goto_recharge_terminal)
        state_machine.init()
    end
    -- call func init first recharge window state machine.
    init_first_recharge_window_terminal()
end

function FirstRechargeWindow:refrushView(mPage)
    self._activity_reward = _ED.active_activity[193].reward_info
    self:savePushTime()
    state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 193)
    self._is_recharge = self:haveRechargeFlag()
    for i = 1, #self._activity_reward do
        if self:haveGetFlag(i) then
            self:changePage(i)
            return
        end
    end
    for i = 1, #self._activity_reward do
        if self:haveUnlockFlag(i) then
            self:changePage(i)
            return
        end
    end

    self:changePage(mPage)
end

-- 主页按钮红点推送时间保存
function FirstRechargeWindow:savePushTime()
    local curTime = _ED.system_time + (os.time() - _ED.native_time)
    cc.UserDefault:getInstance():setStringForKey(getKey("activity_first_recharge_193"), curTime)
    cc.UserDefault:getInstance():flush()
end

-- 玩家是否已充值
function FirstRechargeWindow:haveRechargeFlag()
    for i = 1, #self._activity_reward do
        if self._activity_reward[i].heveGet > 0 then
            return true
        end
    end
    return false
end

-- 是否可领取奖励
function FirstRechargeWindow:haveGetFlag(mPage)
    return self._activity_reward[mPage].heveGet == 1
end

-- 是否有未解锁的奖励
function FirstRechargeWindow:haveUnlockFlag(mPage)
    return self._activity_reward[mPage].heveGet == 0
end

-- 切换天数显示
function FirstRechargeWindow:changePage(mPage)
    self._cur_page = mPage
    for i = 1, #self._activity_reward do
        if mPage == i then
            self.btnList[i]:setTouchEnabled(false)
            self.btnList[i]:setHighlighted(true)
        else
            self.btnList[i]:setTouchEnabled(true)
            self.btnList[i]:setHighlighted(false)
        end
    end

    -- 奖励
    self.ListView_reward:removeAllItems()
    local rewards = zstring.split(self._activity_reward[mPage].rewards, "|")
    for _, v in ipairs(rewards) do
        local cell = DrawHandle.drawIcon(v)
        self.ListView_reward:addChild(cell)
    end
    self.ListView_reward:jumpToLeft()
    self.ListView_reward:requestRefreshView()

    -- 立绘
    self:showRoleEffect(self._activity_reward[mPage].aniId)

    -- 是否充值
    self.Button_get:setVisible(self._is_recharge)
    self.Button_recharge:setVisible(not self._is_recharge)

    -- 领取状态
    self.Image_1:setVisible(false)
    self.Image_2:setVisible(false)
    self.Image_4:setVisible(false)
    self.Button_get:setBright(false)
    self.Button_get:setTouchEnabled(true)
    self.Panel_effect:setVisible(false)
    if self._is_recharge then
        if self._activity_reward[mPage].heveGet == 0 then
            -- 不可领取
            self.Image_4:setVisible(true)
        elseif self._activity_reward[mPage].heveGet == 1 then
            -- 可领取
            self.Image_2:setVisible(true)
            self.Button_get:setBright(true)
            self:showGetEffect()
        elseif self._activity_reward[mPage].heveGet == 2 then
            -- 已领取
            self.Image_1:setVisible(true)
            self.Button_get:setTouchEnabled(false)
        end
    end
end

-- 领取按钮光效
function FirstRechargeWindow:showGetEffect()
    self.Panel_effect:setVisible(true)
    if not self._is_get_effect then
        self._is_get_effect = true
        self.Panel_effect:removeAllChildren(true)
        local filePath = "images/ui/effice/effect_activty_first_recharge_role_get/effect_activty_first_recharge_role_get"
        local jsonFile = filePath .. ".json"
        local atlasFile = filePath .. ".atlas"
        if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
            local spineNode = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            self.Panel_effect:addChild(spineNode)
        end
    end
end

-- 标题动画
function FirstRechargeWindow:showTitleEffect()
    self.Panel_effect_title:removeAllChildren(true)
    local filePath = "images/ui/effice/effect_activty_first_recharge_title/effect_activty_first_recharge_title"
    local jsonFile = filePath .. ".json"
    local atlasFile = filePath .. ".atlas"
    if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
        local spineNode = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        self.Panel_effect_title:addChild(spineNode)
    end
end

-- 切换立绘
function FirstRechargeWindow:showRoleEffect(aniId)
    self.Panel_role:removeAllChildren(true)
    local folderName = "effect_activty_first_recharge_role_" .. aniId
    local jsonFile = "images/ui/effice/effect_activty_first_recharge_role/"..folderName.."/effect_activty_first_recharge_role.json"
    local atlasFile = "images/ui/effice/effect_activty_first_recharge_role/"..folderName.."/effect_activty_first_recharge_role.atlas"
    if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
        local spineNode = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        self.Panel_role:addChild(spineNode)
    end
end

function FirstRechargeWindow:onUpdateDraw()
    local root = self.roots[1]

    -- 奖励列表
    self.ListView_reward = ccui.Helper:seekWidgetByName(root, "ListView_reward")

    -- 气泡文本控件
    self.Text_pop = ccui.Helper:seekWidgetByName(root, "Text_pop")

    -- 已领取文字图片
    self.Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")

    -- 可领取文字图片
    self.Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")

    -- 未到天数领取按钮
    self.Image_4 = ccui.Helper:seekWidgetByName(root, "Image_4")

    -- 人物立绘动画
    self.Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")

    -- 领取光效
    self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")

    -- 首冲标题光效
    self.Panel_effect_title = ccui.Helper:seekWidgetByName(root, "Panel_effect_title")
end

-- 对象初始化
function FirstRechargeWindow:init(params)
    if nil ~= self.onInit then
        self._activity_reward = _ED.active_activity[193].reward_info
        self:onInit(params)
    end
    return self
end

function FirstRechargeWindow:onInit(params)
    local csbNode = csb.createNode("activity/first_recharge/first_recharge_main.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 关闭按钮
    self.Button_close =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "first_recharge_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 天数按钮
    self.btnList = {}
    for i = 1, #self._activity_reward do
        self.btnList[i] =
            fwin:addTouchEventListener(
            ccui.Helper:seekWidgetByName(root, "Button_day_" .. i),
            nil,
            {
                terminal_name = "first_recharge_window_change_page",
                terminal_state = 0,
                isPressedActionEnabled = true,
                m_page = i,
            },
            nil,
            0
        )
    end

    -- 领取/已领取按钮
    self.Button_get =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_get"),
        nil,
        {
            terminal_name = "first_recharge_window_get_reward",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 前往充值
    self.Button_recharge =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_recharge"),
        nil,
        {
            terminal_name = "first_recharge_window_goto_recharge",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self:onUpdateDraw()
    self:showTitleEffect()
    self:refrushView(1)
end

function FirstRechargeWindow:onExit()
    state_machine.remove("first_recharge_window_change_page")
    state_machine.remove("first_recharge_window_get_reward")
    state_machine.remove("first_recharge_window_goto_recharge")
end

function FirstRechargeWindow:close()
    -- window event : close.
end

function FirstRechargeWindow:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
