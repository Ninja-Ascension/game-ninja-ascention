--[[ ----------------------------------------------------------------------------
-- 月卡主界面
--]] ----------------------------------------------------------------------------
MonthlyCardCell = class("MonthlyCardCellClass", Window)
MonthlyCardCell.__size = nil

-- 创建Cell实例
local monthly_card_cell_create_terminal = {
    _name = "monthly_card_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if MonthlyCardCell then
            local cell = MonthlyCardCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(monthly_card_cell_create_terminal)
state_machine.init()

-- 构造器
function MonthlyCardCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.loaded = false
    -- var
    self._activity_card_info = nil -- 月卡信息
    self._card_config = {} -- 月卡配置信息
    self._cur_status = {2,2} -- 当前状态(1:激活 2:直购)
    self._red_tip_sender = {}    -- 红点节点
    self._recharge_btn_orgin = {} -- 按钮初始位置
    -- load lua files.
    app.load("client.cells.utils.resources_icon_cell")
    -- Initialize monthly card cell page state machine.
    local function init_monthly_card_cell_terminal()
        -- 显示窗口
        local monthly_card_cell_show_terminal = {
            _name = "monthly_card_cell_show",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 显示窗口
                if nil ~= instance then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏窗口
        local monthly_card_cell_hide_terminal = {
            _name = "monthly_card_cell_hide",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 隐藏窗口
                if nil ~= instance then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 领取奖励
        local monthly_card_cell_get_reward_terminal = {
            _name = "monthly_card_cell_get_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    state_machine.lock("monthly_card_cell_get_reward")
                    local mType = params._datas.m_type
                    local function responseChangeCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 and response.node ~= nil and response.node.roots[1] ~= nil then
                            response.node:refrushView()
                            state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_new_month_card")
                            state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 1000)
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(7)
                            fwin:open(getRewardWnd, fwin._ui)
                        end
                        state_machine.unlock("monthly_card_cell_get_reward")
                    end

                    protocol_command.monthly_card_receive_reward.param_list = (mType - 1) .. ""
                    NetworkManager:register(protocol_command.monthly_card_receive_reward.code, nil, nil, nil, instance, responseChangeCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 激活/直购
        local monthly_card_cell_active_terminal = {
            _name = "monthly_card_cell_active",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    state_machine.lock("monthly_card_cell_active")
                    local mType = params._datas.m_type
                    
                    if instance:getCanBuyFlag(mType) then
                        if instance._cur_status[mType] == 1 then
                            -- 激活
                            local function responseChangeCallback(response)
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 and response.node ~= nil and response.node.roots[1] ~= nil then
                                    response.node:refrushView()
                                    state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_new_month_card")
                                    app.load("client.reward.DrawRareReward")
                                    local getRewardWnd = DrawRareReward:new()
                                    getRewardWnd:init(7)
                                    fwin:open(getRewardWnd, fwin._ui)
                                    state_machine.unlock("monthly_card_cell_active")
                                end
                            end
                            protocol_command.monthly_card_activate.param_list = (mType - 1) .. ""
                            NetworkManager:register(protocol_command.monthly_card_activate.code, nil, nil, nil, instance, responseChangeCallback, false, nil)
                        elseif instance._cur_status[mType] == 2 then
                            -- 直购
                            _ED.active_activity[192].activity_data.rechargeBuyCallback = function ()
                                if instance ~= nil then 
                                    instance:refrushView()
                                end
                                state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_new_month_card")
                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(7)
                                fwin:open(getRewardWnd, fwin._ui)
                            end
                            local giftIdx = instance:getGiftId(mType)
                            PullUpRechargeWindow({curPurchaseGiftID = giftIdx})
                            state_machine.unlock("monthly_card_cell_active")
                        end
                    else
                        TipDlg.drawTextDailog(tipStringInfo_monthly_card_tip[2])
                        state_machine.unlock("monthly_card_cell_active")
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(monthly_card_cell_show_terminal)
        state_machine.add(monthly_card_cell_hide_terminal)
        state_machine.add(monthly_card_cell_get_reward_terminal)
        state_machine.add(monthly_card_cell_active_terminal)
        state_machine.init()
    end
    -- call func init monthly card cell state machine.
    init_monthly_card_cell_terminal()
end

-- 对象初始化
function MonthlyCardCell:init(params)
    self:onInit(params)
    self:setContentSize(MonthlyCardCell.__size)
    return self
end

-- 获取直购档位
function MonthlyCardCell:getGiftId(mType)
    return tonumber(self._card_config.recharge_info[mType])
end

-- 月卡配置信息获取
function MonthlyCardCell:handleData()
    local tempData = {}
    tempData.recharge_info = zstring.split(_ED.active_activity[192].need_recharge_count, ",") -- 直购档位
    local last_day_info = zstring.split(dms.string(dms["activity_config"], 129, pirates_config.param), ",") -- 单张持续天数
    local max_num_info = zstring.split(dms.string(dms["activity_config"], 134, pirates_config.param), ",") -- 最多持有数量
    tempData.last_day = {}
    tempData.max_num = {}
    tempData.active_prop = {} -- 月卡激活道具
    tempData.reward_info_day = {} -- 月卡每日奖励
    tempData.reward_info_active = {} -- 月卡激活奖励
    for i = 1, 2 do
        -- 单张持续时间
        tempData.last_day[i] = zstring.tonumber(last_day_info[i])
        tempData.max_num[i] = zstring.tonumber(max_num_info[i])
        tempData.active_prop[i] = dms.string(dms["activity_config"], (126 + i), pirates_config.param)
        tempData.reward_info_day[i] = dms.string(dms["activity_config"], (129 + i), pirates_config.param)
        tempData.reward_info_active[i] = dms.string(dms["activity_config"], (131 + i), pirates_config.param)
    end

    self._card_config = tempData
end

function MonthlyCardCell:refrushView()
    _ED.active_activity[192].activity_data.rechargeBuyCallback = nil
    self._activity_card_info = _ED.active_activity[192].activity_data.card_info
    local cardConfig = self._card_config
    for i = 1, 2 do
        -- 每日奖励
        local listview = self.ListView_reward[i]
        listview:removeAllItems()
        local dayReward = zstring.split(cardConfig.reward_info_day[i], "|")
        for _, v in ipairs(dayReward) do
            local cell = DrawHandle.drawIcon(v)
            listview:addChild(cell)
        end
        listview:jumpToLeft()
        listview:requestRefreshView()
        -- 激活奖励
        local activeGetNum = zstring.split(cardConfig.reward_info_active[i], ",")[3]
        self.Text_num[i]:setString(activeGetNum)
        -- 剩余天数
        local cutDay = self._activity_card_info[i].cutDay
        local showDay = cutDay - 1
        if showDay < 0 then
            showDay = 0
        end
        self.Text_day[i]:setString(string.format(tipStringInfo_monthly_card_tip[3], "" .. showDay))
        -- 是否有激活道具
        local propID = zstring.split(cardConfig.active_prop[i], ",")[2]
        local havePropNum = tonumber(getPropAllCountByMouldId(propID))
        local canBuy = self:getCanBuyFlag(i)
        self.Button_recharge[i]:setBright(canBuy)
        if havePropNum >= 1 then
            -- 可以激活
            self._cur_status[i] = 1
            self.Panel_recharge[i]:setVisible(false)
            self.Panel_active[i]:setVisible(true)
            local picIndex = dms.int(dms["prop_mould"], propID, prop_mould.pic_index)
            self.Panel_prop_icon[i]:removeBackGroundImage()
            self.Panel_prop_icon[i]:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
            self.Text_prop_num[i]:setString(tipStringInfo_monthly_card_tip[1])
        else
            -- 显示直购
            self._cur_status[i] = 2
            self.Panel_recharge[i]:setVisible(true)
            self.Panel_active[i]:setVisible(false)
            self.Image_bright[i]:setVisible(canBuy)
            self.Image_gray[i]:setVisible(not canBuy)
        end
        self:showRedTip(i, false)
        local imgPath = "image/activity/monthly_card/first_recharge_btn_"
        self.Panel_tip[i]:setVisible(false)
        self.Panel_unActive[i]:setVisible(false)
        self.Button_get[i]:setVisible(true)
        self.Button_recharge[i]:setPosition(self._recharge_btn_orgin[i])
        if self._activity_card_info[i].haveGet == 1 then
            imgPath = imgPath .. "1.png"
            self.Button_get[i]:setTouchEnabled(true)
            self.Button_get[i]:setBright(true)

            self.Panel_tip[i]:setVisible(true)
            self:showRedTip(i, true)
        else
            if self._activity_card_info[i].haveGet == 0 then
                imgPath = imgPath .. "2.png"
                self.Panel_unActive[i]:setVisible(true)
                -- 未购买则隐藏领取按钮,并设置到中间
                self.Button_get[i]:setVisible(false)
                self.Button_recharge[i]:setPosition(cc.p(self.Panel_center[i]:getPositionX(), self.Panel_center[i]:getPositionY()))
            elseif self._activity_card_info[i].haveGet == 2 then
                self.Panel_tip[i]:setVisible(true)
                imgPath = imgPath .. "3.png"
            end
            self.Button_get[i]:setTouchEnabled(false)
            self.Button_get[i]:setBright(false)
        end
        self.Image_get[i]:loadTexture(imgPath)
    end
    local firstFlag = tonumber(readKey("monthly_card_tips"))
	if firstFlag == "" or firstFlag == nil then
        writeKey("monthly_card_tips" , "192")
    end
end

-- 是否还能购买
function MonthlyCardCell:getCanBuyFlag(mType)
    local lastDay = self._card_config.last_day[mType]
    local maxDay = lastDay * self._card_config.max_num[mType]
    local cutDay = self._activity_card_info[mType].cutDay
    local hairDay = maxDay - cutDay
    return hairDay >= lastDay
end

function MonthlyCardCell:drawAnimation()
    for i = 1, 2 do
        self.Panel_effect[i]:removeAllChildren(true)
        local perPath = "effect_activty_monthly_card_tip_" .. i
        local filePath = "images/ui/effice/" .. perPath .. "/" .. perPath
        local jsonFile = string.format(filePath .. ".json")
        local atlasFile = string.format(filePath .. ".atlas")
        if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
            local spineNode = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            self.Panel_effect[i]:addChild(spineNode)
        end
    end
end

-- 领取红点处理
function MonthlyCardCell:showRedTip(index, flag)
    if self._red_tip_sender[index] == nil and flag then 
        local ball = cc.Sprite:create("images/ui/bar/tips.png")
        ball:setAnchorPoint(cc.p(0.5, 0.5))
        ball:setPosition(cc.p(self.Button_get[index]:getContentSize().width-ball:getContentSize().width*0.5, self.Button_get[index]:getContentSize().height-ball:getContentSize().height*0.5))
        self.Button_get[index]:addChild(ball)
        self._red_tip_sender[index] = ball
    elseif self._red_tip_sender[index] ~= nil then 
        self._red_tip_sender[index]:setVisible(flag)
    end
end

function MonthlyCardCell:onUpdateDraw()
    if self.loaded == false then
        return
    end
    local root = self.roots[1]
    self.ListView_reward = {}
    self.Text_num = {}
    self.Panel_recharge = {}
    self.Panel_active = {}
    self.Image_gray = {}
    self.Image_get = {}
    self.Image_bright = {}
    self.Panel_prop_icon = {}
    self.Panel_effect = {}
    self.Text_prop_num = {}
    self.Text_day = {}
    self.Panel_tip = {}
    self.Panel_unActive = {}
    self.Panel_center = {}
    for i = 1, 2 do
        -- 月卡的奖励列表
        self.ListView_reward[i] = ccui.Helper:seekWidgetByName(root, "ListView_reward_" .. i)
        -- 激活可得钻石数
        self.Text_num[i] = ccui.Helper:seekWidgetByName(root, "Text_num_" .. i)
        -- 显示充值信息
        self.Panel_recharge[i] = ccui.Helper:seekWidgetByName(root, "Panel_recharge_" .. i)
        -- 显示激活信息
        self.Panel_active[i] = ccui.Helper:seekWidgetByName(root, "Panel_active_" .. i)
        -- 灰色档位艺术字
        self.Image_gray[i] = ccui.Helper:seekWidgetByName(root, "Image_gray_" .. i)
        -- 月卡灰色领取/可领取/已领取
        self.Image_get[i] = ccui.Helper:seekWidgetByName(root, "Image_get_" .. i)
        -- 亮色档位艺术字
        self.Image_bright[i] = ccui.Helper:seekWidgetByName(root, "Image_bright_" .. i)
        -- 道具Icon图标
        self.Panel_prop_icon[i] = ccui.Helper:seekWidgetByName(root, "Panel_prop_icon_" .. i)

        -- 钻石图标动画
        self.Panel_effect[i] = ccui.Helper:seekWidgetByName(root, "Panel_effect_" .. i)

        -- 道具数量
        self.Text_prop_num[i] = ccui.Helper:seekWidgetByName(root, "Text_prop_num_" .. i)

        -- 剩余天数
        self.Text_day[i] = ccui.Helper:seekWidgetByName(root, "Text_day_" .. i)

        -- 剩余显示
        self.Panel_tip[i] = ccui.Helper:seekWidgetByName(root, "Panel_tip_" .. i)

        -- 不激活显示内容
        self.Panel_unActive[i] = ccui.Helper:seekWidgetByName(root, "Panel_unActive_" .. i)

        -- 按钮中间位置获取控件
        self.Panel_center[i] = ccui.Helper:seekWidgetByName(root, "Panel_center_" .. i)
    end

    self:drawAnimation()
    self:handleData()
    self:refrushView()
end

function MonthlyCardCell:onInit(params)
    -- 加载MonthlyCardCellWindow界面资源.
    -- activity/wonderful/monthly_card = activity/wonderful/monthly_card.csb
    --[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/wonderful/monthly_card.csb")
	local root = csbNode:getChildByName("root")
	--]]
    -- [[ 使用缓存创建
    local root = cacher.createUIRef("activity/wonderful/monthly_card.csb", "root")
    -- ]]
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if MonthlyCardCell.__size == nil then
        MonthlyCardCell.__size = root:getContentSize()
    end

    -- 领取/已领取按钮
    self.Button_get = {}
    -- 充值/激活按钮
    self.Button_recharge = {}
    for i = 1, 2 do
        self.Button_get[i] =
            fwin:addTouchEventListener(
            ccui.Helper:seekWidgetByName(root, "Button_get_" .. i),
            nil,
            {
                terminal_name = "monthly_card_cell_get_reward",
                terminal_state = 0,
                isPressedActionEnabled = true,
                m_type = i
            },
            nil,
            0
        )
        self.Button_recharge[i] =
            fwin:addTouchEventListener(
            ccui.Helper:seekWidgetByName(root, "Button_recharge_" .. i),
            nil,
            {
                terminal_name = "monthly_card_cell_active",
                terminal_state = 0,
                isPressedActionEnabled = true,
                m_type = i
            },
            nil,
            0
        )
        self._recharge_btn_orgin[i] = cc.p(self.Button_recharge[i]:getPositionX(),self.Button_recharge[i]:getPositionY())
    end

    cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self, false)
end

function MonthlyCardCell:onUpdateDrawData(...)
    self.loaded = true
    self:onUpdateDraw()
end

function MonthlyCardCell:onExit()
    -- 释放MonthlyCardCellWindow界面资源.

    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("activity/wonderful/monthly_card.csb", root)
    -- ]]
end

function MonthlyCardCell:lazy()
    if self.loaded == true then
        return
    end
    self.loaded = true
    self:onInit()
end

function MonthlyCardCell:unload()
    self:removeAllChildren(true)
    self.loaded = false
    self.roots = {}
    self._red_tip_sender = {}
end

-- ~END
-- ----------------------------------------------------------------------------
