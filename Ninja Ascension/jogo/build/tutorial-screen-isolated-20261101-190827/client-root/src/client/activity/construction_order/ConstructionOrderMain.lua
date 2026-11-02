--[[ ----------------------------------------------------------------------------
-- 建号战令主界面
--]] ----------------------------------------------------------------------------
ConstructionOrderMain = class("ConstructionOrderMainClass", Window)

-- 打开窗口
local construction_order_main_window_open_terminal = {
    _name = "construction_order_main_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ConstructionOrderMainClass") then
			fwin:open(ConstructionOrderMain:new():init(params), fwin._view)
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local construction_order_main_window_close_terminal = {
    _name = "construction_order_main_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 186)
        fwin:close(fwin:find("ConstructionOrderMainClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(construction_order_main_window_open_terminal)
state_machine.add(construction_order_main_window_close_terminal)
state_machine.init()

-- 构造器
function ConstructionOrderMain:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self.order_Main_String = {
        MAXITEMS = 5            -- 界面所能显示最大item数
    }

    self.allRewardStringInfo = {} -- 所有奖励内容
    self.userOrderInfo = {}       -- 玩家战令信息
    self.allRewardAdvanced = {}   -- 所有进阶奖励信息

    self.curLevel = 1       -- 玩家当前等级
    self.maxLevel = 0       -- 对于当前，满级是多少
    self.curPeriod = 0      -- 当前战令第几期
    self.curWeek = 0        -- 当前任务第几周
    self.firstRewardIdx = 0 -- 第一个可领取奖励的下标
    self.finalRewardIdx = 0 -- 最后一个可领取奖励的下标
    self.curRewardIdx = 0   -- 特殊奖励的下标
    self.seriesPurchaseRewardState = 0    -- 连续购买进阶战令奖励状态

    self.totalTime = 0
    self.deltaTime = 1
    -- self.onClickShop = false

    self.oldAllExp = 0              -- 增加之前的经验
    self.newAllExp = 0              -- 最新的经验
    self.oldLevel = 0               -- 增加之前的等级(值会被修改)
    self.oldReallyLevel = 0         -- 上一次的等级(值不会被修改)
    self.newLevel = 0               -- 最新的等级
    self.barSpeed = 0               -- 进度条移动速度
    self.baseProgressEffectPosX = nil     -- 进度条头部动画初始坐标
    self.playExpAnimationState = false   -- 播放增加经验的动画状态
    self.playLevelAnimationState = false -- 播放增加等级的动画状态
    self.isLockButtonState = false  -- 状态机是否被锁住

    self.allRewardIdxInfo = {}      -- 所有奖励的下标
    self.continuousPurchasePics = {}    -- 连续购买期数进度图片

    self.BARSPEEDRATIO = 10         -- 进度条每帧增长速度系数，数值越大，速度越快，越小，越慢
    self.BARMINSPEED = 2            -- 进度条每帧增长最小经验值
    -- load lua files.
    
    app.load("client.activity.construction_order.ConstructionOrderShop")
    app.load("client.activity.construction_order.ConstructionOrderTask")
    app.load("client.activity.construction_order.ConstructionOrderWelfare")
    app.load("client.activity.construction_order.ConstructionOrderRewardList")
    app.load("client.activity.construction_order.ConstructionOrderBuyEnter")
    app.load("client.activity.construction_order.ConstructionOrderActivationEnter")
    app.load("client.activity.construction_order.ConstructionOrderRule")
    app.load("client.activity.construction_order.ConstructionOrderPropertyList")
	app.load("client.utils.CurrencyIcon")
    
    -- Initialize christmas romance page state machine.
    local function init_construction_order_main_terminal()
        -- 打开角色创建窗口
        local construction_order_main_open_terminal = {
            _name = "construction_order_main_open",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭角色创建窗口
        local construction_order_main_close_terminal = {
            _name = "construction_order_main_close",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示窗口
        local construction_order_main_show_terminal = {
            _name = "construction_order_main_show",
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
        local construction_order_main_hide_terminal = {
            _name = "construction_order_main_hide",
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

        -- 打开规则界面
        local construction_order_main_open_rule_terminal = {
            _name = "construction_order_main_open_rule",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    state_machine.excute("construction_order_rule_window_open", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 购买战令进阶卡
        local construction_order_main_buy_warorder_terminal = {
            _name = "construction_order_main_buy_warorder",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    local isHaveProp = instance:isHaveActivationProp()
                    if isHaveProp == false then
                        -- debug.print_r(instance.allRewardAdvanced, "====self.allRewardAdvanced")
                        state_machine.excute("construction_order_buy_enter_window_open", 0, {allRewardInfo = instance.allRewardAdvanced, curPeriod = instance.curPeriod})
                    else
                        state_machine.excute("construction_order_activation_enter_window_open", 0, {type = WarOrderAllTypeEnum.ConstructionWarOrder, stage = instance.curPeriod})

                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开商店界面
        local construction_order_main_open_shop_terminal = {
            _name = "construction_order_main_open_shop",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    local curType = 1
                    if params._datas.curType ~= nil then
                        curType = params._datas.curType
                    end

                    state_machine.excute("construction_order_shop_window_open", 0, {curType = curType})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开任务界面
        local construction_order_main_open_task_terminal = {
            _name = "construction_order_main_open_task",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    local cell = params._datas.mcell
                    cell.curWeek = 1
                    local week = cell.curWeek 
                    local allTaskString = cell:getCurPeriodInfo()[pass_mould.achieve]
                    -- local curTaskString = zstring.split(allTaskString, "!")[cell.curWeek]
                    -- debug.print_r(curTaskString, "==curTaskString")
                    state_machine.excute("construction_order_task_window_open", 0, {allTaskString, week = week})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开全民福利界面
        local construction_order_main_open_welfare_terminal = {
            _name = "construction_order_main_open_welfare",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    local curPeriod = instance.curPeriod
                    state_machine.excute("construction_order_welfare_window_open", 0, {curPeriod = curPeriod})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 奖励领取
        local construction_order_main_refresh_rewards_state_terminal = {
            _name = "construction_order_main_refresh_rewards_state",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    local receiveNums = instance:getCanReceiveNum()
                    local rewardType = params._datas.rewardType
                    -- rewardType(奖励类型) : 1 = 普通奖励 2 = 进阶奖励 3 = 全民奖励 4 = 连续购买道具奖励
                    if receiveNums <= 0 and rewardType ~= 4 then
                        TipDlg.drawTextDailog(war_order_str[20])
                        return false
                    end

                    local receiveType = params._datas.receiveType
                    local rewardIdx = 0
                    if receiveType == 0 then
                        rewardIdx = -1
                        rewardType = -1
                    else
                        -- 类似为4，其它为-1
                        if rewardType == 4 then
                            rewardIdx = -1
                            receiveType = -1
                        else
                            local cell = params._datas.cell
                            rewardIdx = cell.curRewardIdx
                        end
                    end
                    local function responseBuyPropCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(7)
                            fwin:open(getRewardWnd,fwin._ui)
                            -- 领取奖励后的刷新
                            instance:onUpdateDrawReward()
                            
                        end
                    end
                    -- print(receiveType, rewardType, rewardIdx)
                    protocol_command.user_build_war_order_get_reward.param_list = receiveType .. "\r\n" .. rewardType .. "\r\n" .. rewardIdx
                    NetworkManager:register(protocol_command.user_build_war_order_get_reward.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)

                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 进阶卡激活成功，刷新界面
        local construction_order_main_activation_warorder_terminal = {
            _name = "construction_order_main_activation_warorder",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:onUpdateactivation()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --获得战令经验，刷新界面
        local construction_order_main_get_exp_terminal = {
            _name = "construction_order_main_get_exp",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:onUpdateDrawExp()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭所有界面
        local construction_order_main_close_allInterface_terminal = {
            _name = "construction_order_main_close_allInterface",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    fwin:close(fwin:find("ConstructionOrderActivationEnterClass"))
                    fwin:close(fwin:find("ConstructionOrderBuyEnterClass"))
                    fwin:close(fwin:find("ConstructionOrderRuleClass"))
                    fwin:close(fwin:find("ConstructionOrderShopClass"))
                    -- fwin:close(fwin:find("ConstructionOrderShopListNormalClass"))
                    -- fwin:close(fwin:find("ConstructionOrderShopListSpecialClass"))
                    -- fwin:close(fwin:find("ConstructionOrderRewardListClass"))
                    fwin:close(fwin:find("ConstructionOrderShopListSpecialInfoClass"))
                    fwin:close(fwin:find("ConstructionOrderShopTabClass"))
                    -- fwin:close(fwin:find("ConstructionOrderShopTabListClass"))
                    fwin:close(fwin:find("ConstructionOrderShopViewClass"))
                    fwin:close(fwin:find("ConstructionOrderTaskClass"))
                    -- fwin:close(fwin:find("ConstructionOrderTaskListClass"))
                    fwin:close(fwin:find("ConstructionOrderWelfareClass"))
                    -- fwin:close(fwin:find("ConstructionOrderWelfareListClass"))

                    state_machine.excute("home_update_top_activity_info_state", 0, nil)
                    TipDlg.drawTextDailog(tipStringInfo_new_activity_tips[2])
                    state_machine.excute("construction_order_main_window_close", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 浏览皮肤属性面板
        local construction_order_main_show_skin_properties_terminal = {
            _name = "construction_order_main_show_skin_properties",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and params ~= nil then
                    instance:controlShowPropertiyPanel(params._datas.isShow)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭升级动画
        local construction_order_main_close_level_animation_terminal = {
            _name = "construction_order_main_close_level_animation",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                   instance:removeLevelAnimation()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 锁住所有的状态机
        local construction_order_main_lock_button_terminal = {
            _name = "construction_order_main_lock_button",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    state_machine.lock("construction_order_main_buy_warorder")				-- 购买战令进阶卡
                    state_machine.lock("construction_order_main_open_rule")					-- 打开规则界面
                    state_machine.lock("construction_order_main_open_shop")					-- 打开商店界面
                    state_machine.lock("construction_order_main_open_task")				    -- 打开任务界面
                    state_machine.lock("construction_order_main_open_welfare")			    -- 打开全民福利界面
                    state_machine.lock("construction_order_main_refresh_rewards_state")		-- 奖励领取
                    state_machine.lock("construction_order_main_activation_warorder")		-- 进阶卡激活成功，刷新界面
                    state_machine.lock("construction_order_main_get_exp")			        -- 获得战令经验，刷新界面
                    state_machine.lock("construction_order_main_show_skin_properties")		-- 浏览皮肤属性面板
                    state_machine.lock("construction_order_main_close_level_animation")		-- 关闭升级动画
				
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 所有的状态机进行解锁
        local construction_order_main_unlock_button_terminal = {
            _name = "construction_order_main_unlock_button",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    state_machine.unlock("construction_order_main_buy_warorder")				-- 购买战令进阶卡
                    state_machine.unlock("construction_order_main_open_rule")					-- 打开规则界面
                    state_machine.unlock("construction_order_main_open_shop")					-- 打开商店界面
                    state_machine.unlock("construction_order_main_open_task")				    -- 打开任务界面
                    state_machine.unlock("construction_order_main_open_welfare")			    -- 打开全民福利界面
                    state_machine.unlock("construction_order_main_refresh_rewards_state")		-- 奖励领取
                    state_machine.unlock("construction_order_main_activation_warorder")			-- 进阶卡激活成功，刷新界面
                    state_machine.unlock("construction_order_main_get_exp")			            -- 获得战令经验，刷新界面
                    state_machine.unlock("construction_order_main_show_skin_properties")		-- 浏览皮肤属性面板
                    state_machine.unlock("construction_order_main_close_level_animation")		-- 关闭升级动画
				
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(construction_order_main_open_terminal)
        state_machine.add(construction_order_main_close_terminal)
        state_machine.add(construction_order_main_show_terminal)
        state_machine.add(construction_order_main_hide_terminal)
        state_machine.add(construction_order_main_open_rule_terminal)
        state_machine.add(construction_order_main_buy_warorder_terminal)
        state_machine.add(construction_order_main_open_shop_terminal)
        state_machine.add(construction_order_main_open_task_terminal)
        state_machine.add(construction_order_main_open_welfare_terminal)
        state_machine.add(construction_order_main_refresh_rewards_state_terminal)
        state_machine.add(construction_order_main_activation_warorder_terminal)
        state_machine.add(construction_order_main_get_exp_terminal)
        state_machine.add(construction_order_main_close_allInterface_terminal)
        state_machine.add(construction_order_main_show_skin_properties_terminal)
        state_machine.add(construction_order_main_lock_button_terminal)
        state_machine.add(construction_order_main_unlock_button_terminal)
        state_machine.add(construction_order_main_close_level_animation_terminal)
        
        state_machine.init()
    end
    -- call func init christmas romance state machine.
    init_construction_order_main_terminal()
end

-- 奖励领取的界面刷新
function ConstructionOrderMain:onUpdateDrawReward()
    -- 刷新活动数据
    self:updateUserData()
    -- 刷新奖励，只刷新奖励状态
    self:updateDrawNewRewardState()
    -- 刷新特殊奖励，需要刷新内容
    self:updateDrawSpecialReward()
    -- 刷新一键领取红点
    self:updateRedDot()
    -- 连续购买进阶奖励领取状态被改变时刷新进度
    if self.seriesPurchaseRewardState ~= self.userOrderInfo.seriesPurchaseRewardState then
        self:showSeriesPurchasePeriods()
    end
end

-- 战令激活后的界面刷新
function ConstructionOrderMain:onUpdateactivation()
    -- 重新绘制界面奖励内容
    self:onUpdateDrawExp()
    -- 刷新奖励，只刷新奖励状态
    self:updateDrawNewRewardState()
    -- 刷新特殊奖励
    self:updateDrawSpecialReward()
    self:updateDrawAdvanceLock()
    
    -- 刷新一键领取状态机
    self:updateRedDot()
    -- 刷新连续购买进阶战令进度
    self:showSeriesPurchasePeriods()
end

-- 获得战令经验升级后的界面刷新
function ConstructionOrderMain:onUpdateDrawExp()
    self:updateUserData()
    local level = self.curLevel
    self:updateRoleExp()
    -- 如果等级发生变化，刷新内容
    if level ~= self.curLevel then
        self:updateAllRewards()
        self:updateReward()
    end
    -- 获得经验后的动画播放
    self:controlDrawLevelAndExpAnimation()
    self:updateRedDot()
end

-- 只刷新奖励状态
function ConstructionOrderMain:updateDrawNewRewardState()
    local allItems = self.ListView_allreward:getItems()
    local nRewardState, aRewardState = self:getAllRewardState()

    for i, v in ipairs(allItems) do
        v:onUpdateRewardState({normalState = nRewardState[i], advanceState = aRewardState[i]})
    end
end

-- 获取额外显示等级数量
function ConstructionOrderMain:getAddLevelNums()
    local addLevel = dms.int(dms["play_config"], 282, play_config.param)
    return addLevel
end

-- 刷新一键领取红点
function ConstructionOrderMain:updateRedDot()
    fwin:addService({
        callback = function ( params )
            state_machine.excute("notification_center_update", 0, "push_notification_construction_warorder_can_receive_reward_push")
        end,
        delay = 0.2,
    })
end

-- 更新玩家的经验和等级以及当前最大等级
function ConstructionOrderMain:updateRoleExp()
    
    local allExp = self.userOrderInfo.allExp
    local everyGradeExp = self:getEveryGradeNeedExp()

    self.curLevel = math.floor(allExp / everyGradeExp)

    local peakLevel = self:getPeakLevel()
    if self.curLevel > peakLevel then
        local addLevel = self:getAddLevelNums()
        local extraLevel = math.ceil((self.curLevel - peakLevel) / addLevel) * addLevel
        self.maxLevel = peakLevel + extraLevel
    else
        self.maxLevel = peakLevel
    end
    
    self:getOldUserInfo()
    self:setNewUserInfo()

end

-- 初始化进度条
function ConstructionOrderMain:initDrawExpProgress()
    local everyGradeExp = self:getEveryGradeNeedExp()
    local oldStageExp = self.oldAllExp % everyGradeExp
    local expProgressWidth = self.LoadingBar_exp:getContentSize().width
    local curProgress = oldStageExp / everyGradeExp

    self.LoadingBar_exp:setPercent(curProgress * 100)
    self.Text_progress:setString(oldStageExp.."/"..everyGradeExp)
    self.Text_level:setString(self.oldLevel)
    
    if self.baseProgressEffectPosX == nil then
        self.baseProgressEffectPosX = self.Panel_progress_effect:getPositionX()
    end
    if self.Panel_progress_effect:getChildByName("head_Bar_Animation") == nil then
        
        local jsonFile = "images/ui/effice/effect_passport_progress/effect_passport_progress.json"
        local atlasFile = "images/ui/effice/effect_passport_progress/effect_passport_progress.atlas"
        local aniName = "animation"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, true, nil)
        animation:setPosition(cc.p(self.Panel_progress_effect:getContentSize().width / 2, self.Panel_progress_effect:getContentSize().height / 2))
        self.Panel_progress_effect:addChild(animation)
        animation:setName("head_Bar_Animation")
    end
    self.Panel_progress_effect:setVisible(false)
    
    self:controlDrawLevelAndExpAnimation()
end

-- 根据索引获取奖励
function ConstructionOrderMain:getRewardByID(rewardIdxInfo)
    -- 普通奖励
    local rewardNormalInfo = {}
    -- 进阶奖励
    local rewardAdvancedInfo = {}

    local rewardStringInfo = {}
    -- debug.print_r(rewardIdxInfo, "====rewardIdxInfo")
    -- local peakLevel = self:getPeakLevel()
    for i, v in ipairs(rewardIdxInfo) do
        local rewardString = nil
        
        local rewardString = dms.string(dms["pass_reward_mould"], tonumber(v), pass_reward_mould.reward)
        table.insert(rewardStringInfo, rewardString)
    end
    -- debug.print_r(rewardStringInfo, "=====rewardStringInfo")
    -- return rewardNormalInfo, rewardAdvancedInfo
    return rewardStringInfo
end

-- 获取战令等级所有奖励内容
function ConstructionOrderMain:updateAllRewards()
   
    local curPeriod = self.userOrderInfo.curPeriod
    local periodIdxString = self:getCurPeriodInfo()
    local rewardIdxString = periodIdxString[pass_mould.reward]

    local peakLevel = self:getPeakLevel()
    -- 如果大于等级峰值，则继续添加奖励内容
    -- print(self.maxLevel, "===self.maxLevel", peakLevel)
    -- if self.maxLevel > peakLevel then
    --     local rewardIdx = self:getMaxLevelRewardIdx()
    --     print(rewardIdx, "====rewardIdx")
    --     for i = peakLevel, self.maxLevel do
    --         rewardIdxString = rewardIdxString..","..rewardIdx
    --     end
    -- end
    -- print(rewardIdxString, "====rewardIdX")

    self.allRewardIdxInfo = {}
    local rewardIdxInfo = zstring.split(rewardIdxString, ",", function ( value ) return tonumber(value) end)
    for i, v in ipairs(rewardIdxInfo) do
        if i <= peakLevel then
            table.insert(self.allRewardIdxInfo, v)
        end
    end

    if self.maxLevel > peakLevel then
        local rewardIdx = self:getMaxLevelRewardIdx()
        -- print(rewardIdx, "====rewardIdx")
        for i = peakLevel + 1, self.maxLevel do
            table.insert(self.allRewardIdxInfo, rewardIdx)
        end
    end
    -- for i, v in ipairs(rewardIdxInfo) do
    --     if i <= peakLevel then
    --         table.insert(self.allRewardIdxInfo, v)
    --     end
    -- end
    -- self.allRewardIdxInfo = rewardIdxInfo
    -- debug.print_r(self.allRewardIdxInfo, "===allRewardIdxInfo")
    self.allRewardStringInfo = self:getRewardByID(self.allRewardIdxInfo)
    -- return self:getRewardByID(rewardIdxInfo)
end

-- 获取特殊奖励下标
function ConstructionOrderMain:getSpecialReward()
   
    local nRewardState, aRewardState = self:getAllRewardState()
    local specialIdx = 0    -- 特殊奖励下标
    local firstIdx = 0      -- 最近一个不可领取的下标
    local specialString = self:getCurPeriodInfo()[pass_mould.specialReward]
    local peakLevel = self:getPeakLevel()
    if self.maxLevel > peakLevel then
        local subLevel = self.maxLevel - peakLevel
        local addLevel = self:getAddLevelNums()
        local addNums = subLevel / addLevel
        for i = 1, addNums do
            local curLevel = peakLevel + i * addLevel
            specialString = specialString..","..curLevel
        end
    end
    -- print(specialString, "=====specialString")
    local specialInfo = zstring.split(specialString, ",", function ( value ) return tonumber(value) end)

    local curSpecialLevel = 0
    for i, v in ipairs(specialInfo) do
        if v < self.curLevel then
            curSpecialLevel = v
        end
    end
    local specialNormalRewardInfo = {}
    local specialAdvancedRewardInfo = {}
    local specialRewardString = ""
    -- debug.print_r(nRewardState, "===nRewardState")
    -- debug.print_r(aRewardState, "===aRewardState")
    -- 如果距离最近的特殊奖励可领取
    if nRewardState[curSpecialLevel] == 1 or aRewardState[curSpecialLevel] == 1 then
        if nRewardState[curSpecialLevel] == 1 then
            
        end
        if curSpecialLevel > peakLevel then
            if aRewardState[curSpecialLevel] == 1 then
                specialIdx = curSpecialLevel
            end
        else
            if nRewardState[curSpecialLevel] == 1 or aRewardState[curSpecialLevel] == 1 then
                specialIdx = curSpecialLevel
            end
        end
        specialIdx = curSpecialLevel
    else
        -- 第一个不可领取的特殊奖励
        for i, v in ipairs(specialInfo) do
            if nRewardState[v] == 1 or aRewardState[v] == 1 then
                specialIdx = v
                break
            end
            if specialIdx == 0 and firstIdx == 0 then
                if v > peakLevel then
                    if aRewardState[v] == 0 then
                        firstIdx = v
                    end
                else
                    if nRewardState[v] == 0 and aRewardState[v] == 0 then
                        firstIdx = v
                    end
                end
                
            end
        end
    end
    -- print(specialIdx, '=====specialIdx', firstIdx, "===firstIdx")
    if specialIdx == 0 then
        if firstIdx ~= 0 then
            specialIdx = firstIdx
        end
    end
    -- specialNormalRewardInfo, specialAdvancedRewardInfo = self:getRewardByID({specialIdx})
    -- return specialNormalRewardInfo, specialAdvancedRewardInfo
    -- specialRewardString = self:getRewardByID({specialIdx})
    return specialIdx
end

-- 是否含有战令激活道具
function ConstructionOrderMain:isHaveActivationProp()
    local propInfo = dms.string(dms["play_config"], 277, play_config.param)
    local propID = tonumber(zstring.split(propInfo, ",")[2])
    return tonumber(getPropAllCountByMouldId(propID)) > 0
end

function ConstructionOrderMain:updateUserData()
    local user_order_info = _ED.active_activity[186].user_order_info
    -- debug.print_r(user_order_info, "===user_order_info")
    -- local user_order_info = nil
    if user_order_info ~= nil then
        self.userOrderInfo = user_order_info
    end
end

-- 获取所有奖励状态
function ConstructionOrderMain:getAllRewardState()
   
    -- 普通和特殊奖励状态
    local nRewardState = self.userOrderInfo.normalRewardState
    local aRewardState = self.userOrderInfo.advancedRewardState
    
    return nRewardState, aRewardState
end

-- 获取当前奖励可以领取的列数
function ConstructionOrderMain:getCanReceiveNum()
    self.firstRewardIdx = 0
    local firstUncompleteIdx = 0
    local receiveNums = 0
    local nRewardState, aRewardState = self:getAllRewardState()
    -- print(#nRewardState, "====#nRewardState")
    for i = 1, #nRewardState do
        if tonumber(nRewardState[i]) == 1 or tonumber(aRewardState[i]) == 1 then
            receiveNums = receiveNums + 1
            if self.firstRewardIdx == 0 then
                self.firstRewardIdx = i
            end
            self.finalRewardIdx = i
        end
        if firstUncompleteIdx == 0 then
            if tonumber(nRewardState[i]) == 0 and tonumber(aRewardState[i]) == 0 then
                firstUncompleteIdx = i
            end
        end
    end
    -- print(self.finalRewardIdx, "====finalReward1111")
    if self.finalRewardIdx == 0 then
        -- print(firstUncompleteIdx, "===firstUncompleteIdx")
        self.finalRewardIdx = firstUncompleteIdx
    end
    -- print(self.finalRewardIdx, "====finalReward2222")
    return receiveNums
end

-- 获取当前战令等级峰值
function ConstructionOrderMain:getPeakLevel()
    local maxLevelInfo = dms.string(dms["play_config"], 283, play_config.param)
    local peakLevel = tonumber(zstring.split(maxLevelInfo, "|")[1])
    return peakLevel
end

-- 获取峰值等级后的奖励下标
function ConstructionOrderMain:getMaxLevelRewardIdx()
    local maxLevelInfo = dms.string(dms["play_config"], 283, play_config.param)
    local rewardIdx = tonumber(zstring.split(maxLevelInfo, "|")[2])
    return rewardIdx
end

-- 索引获得当前期数的战令信息
function ConstructionOrderMain:getCurPeriodInfo()
    self.curPeriod = self.userOrderInfo.curPeriod
    local allPeriods = table.nums(dms.searchs(dms["pass_mould"], pass_mould.type, WarOrderAllTypeEnum.ConstructionWarOrder))
    -- 如果当前期数大于配置表的最后一期，则沿用最后一期的内容
    if self.curPeriod >= allPeriods then
        self.curPeriod = allPeriods
    end
    local periodIdxString = dms.searchs(dms["pass_mould"], pass_mould.type, WarOrderAllTypeEnum.ConstructionWarOrder, pass_mould.stage, self.curPeriod)
    return periodIdxString[1]
end

function ConstructionOrderMain:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.floor((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .. _string_piece_info[231]
    end
    if _hourTime < 10 then
        timeString = timeString .. "0" .. _hourTime .. ":"
    else
        timeString = timeString .. _hourTime .. ":"
    end

    if _minutesTime < 10 then
        timeString = timeString .. "0" .. _minutesTime .. ":"
    else
        timeString = timeString .. _minutesTime .. ":"
    end

    if _secondsTime < 10 then
        timeString = timeString .. "0" .. _secondsTime
    else
        timeString = timeString .. _secondsTime
    end
    return timeString
end

function ConstructionOrderMain:updateActivityRemainTime()
    if self.Text_time == nil or self._activityEndTime == nil then
        return
    end
    local surplus_time = (self._activityEndTime - (os.time() + _ED.time_add_or_sub) * 1000)
    self.Text_time:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
    -- 倒计时结束后关闭界面
    if surplus_time < 0 then
        _ED.active_activity[186] = nil
        self._activityEndTime = nil
        fwin:addService(
            {
                callback = function(params)
                    state_machine.excute("construction_order_main_close_allInterface", 0, nil)
                end,
                delay = 0.1
            }
        )
        
    end
end

function ConstructionOrderMain:updateDrawListView()
    local posX = self.ListView_allreward:getInnerContainer():getPositionX()
        if posX == self.listview_ContainerPosX then
            return
        end
        self.listview_ContainerPosY = posX
		local items = self.ListView_allreward:getItems()
		if items[1] == nil then
			return
		end
        local size = self.ListView_allreward:getContentSize()
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempX = v:getPositionX() + posX
			if tempX + itemSize.width + itemSize.width < 0 or tempX > size.width + itemSize.width / 2 then
				v:unload()
			else
				v:reload()
			end
		end
end

function ConstructionOrderMain:onUpdate(dt)
    self.totalTime = self.totalTime + dt
    if self.totalTime >= self.deltaTime then
        self:updateActivityRemainTime()
        self.totalTime = 0
    end

    if self.playExpAnimationState == true then
        self:updateDrawExpAnimation()
    end

    if self.ListView_allreward ~= nil and #(self.ListView_allreward:getItems()) > 0 then
        self:updateDrawListView()
    end
end

-- 进阶战令是否被解锁
function ConstructionOrderMain:updateDrawAdvanceLock()
    local isActivated = self.userOrderInfo.stageIsActivated
    if isActivated == 1 then
        self.Lock_advanced:setVisible(false)
        self.Button_buy_warorder:setVisible(false)
    else
        self.Lock_advanced:setVisible(true)
        self.Button_buy_warorder:setVisible(true)
    end
end

function ConstructionOrderMain:updateReward()
    self:updateDrawAllReward()
    self:updateDrawSpecialReward()
    self:updateDrawAdvanceLock()
end

-- 绘制所有列表奖励
function ConstructionOrderMain:updateDrawAllReward()
    self.ListView_allreward:removeAllItems()
    self.ListView_allreward:jumpToLeft()
    self.allRewardAdvanced = {}

    local jumpIndex = 1
    local nRewardState, aRewardState = self:getAllRewardState()
    local peakLevel = self:getPeakLevel()        -- 等级峰值
    for i, v in ipairs(self.allRewardStringInfo) do
        local cell = state_machine.excute("construction_order_reward_list_create", 0, {rewardInfo = v, index = i, normalState = nRewardState[i], advanceState = aRewardState[i], level = i})
        if i <= peakLevel then
            local rewardAdvancedInfo = zstring.split(v, "!")
            local advanceReward = zstring.split(rewardAdvancedInfo[2], "|")
            for j, k in ipairs(advanceReward) do
                table.insert(self.allRewardAdvanced, k)
            end
        end
        self.ListView_allreward:addChild(cell)
    end
    
    -- 获取跳转下标
    local receivedNums = self:getCanReceiveNum()
    local rightCenter = false
    if receivedNums >= self.order_Main_String.MAXITEMS then
        jumpIndex = self.finalRewardIdx
        rightCenter = true
    else
        if jumpIndex == 1 and receivedNums == 0 then
            jumpIndex = self.curLevel
        else
            jumpIndex = self.firstRewardIdx
        end
    end
    if jumpIndex > self.order_Main_String.MAXITEMS then
        if rightCenter == true then
            jumpIndex = jumpIndex - self.order_Main_String.MAXITEMS + 2
        end
        local limitNums = #self.ListView_allreward:getItems() - 4
        if jumpIndex >= limitNums then
            jumpIndex = limitNums
        end
        self:runAction(cc.Sequence:create({cc.DelayTime:create(0.01), cc.CallFunc:create(function ( sender )
            listviewPositioningMoves(self.ListView_allreward, jumpIndex, 0, true)
        end)}))
    else
        self.ListView_allreward:jumpToLeft()
    end
    self.ListView_allreward:requestRefreshView()
    self.listview_ContainerPosX = self.ListView_allreward:getInnerContainer():getPositionX()
end

-- 绘制特殊奖励
function ConstructionOrderMain:updateDrawSpecialReward()
    self.Panel_special_reward_normal:removeAllChildren()
    self.Panel_special_reward_advance1:removeAllChildren()
    self.Panel_special_reward_advance2:removeAllChildren()

    -- 特殊奖励等级
    local specialRewardLevel = self:getSpecialReward()
    self.curRewardIdx = specialRewardLevel
    -- print(specialRewardLevel, "===specialRewardLevelspecialRewardLevel")
    -- debug.print_r(self.allRewardIdxInfo, "====self.allRewardIdxInfo")
    local specialRewardIdx = self.allRewardIdxInfo[specialRewardLevel]
    -- print(specialRewardIdx, "====specialRewardIdx", self.curRewardIdx)
    local specialRewardString = self:getRewardByID({specialRewardIdx})
    -- debug.print_r(specialRewardString, '=====specialRewardString')
    local nRewardState, aRewardState = self:getAllRewardState()
    local rewardInfo = zstring.split(specialRewardString[1], "!")
    local rewardNormal = zstring.split(rewardInfo[1], "|")
    local normalNil = false
    for i, v in ipairs(rewardNormal) do
        if v ~= nil and v ~= "" then
            local cell = DrawHandle.drawIcon(v)
            self.Panel_special_reward_normal:addChild(cell)
        else
            normalNil = true
        end
    end
    

    local rewardAdvanced = zstring.split(rewardInfo[2], "|")
    local cellAdvanced1 = DrawHandle.drawIcon(rewardAdvanced[1])
    self.Panel_special_reward_advance1:addChild(cellAdvanced1)
    if rewardAdvanced[2] ~= nil then
        local cellAdvanced2 = DrawHandle.drawIcon(rewardAdvanced[2])
        self.Panel_special_reward_advance2:addChild(cellAdvanced2)
    end
    self.Text_special_level:setString(string.format(war_order_str[15], specialRewardLevel))
    if normalNil == true then
        self.Button_receive_normal:setVisible(false)
    else
        if nRewardState[specialRewardLevel] == 1 then
            self.Button_receive_normal:setVisible(true)
        else
            self.Button_receive_normal:setVisible(false)
        end
    end

    if aRewardState[specialRewardLevel] == 1 then
        self.Button_receive_advance:setVisible(true)
    else
        self.Button_receive_advance:setVisible(false)
    end
end

-- 获取上一次的经验和等级
function ConstructionOrderMain:getOldUserInfo()
    local activityType = 186
    local oldExp = tonumber(readKey(activityType.."construction_order_user_exp"))
	if oldExp == "" or oldExp == nil then
        oldExp = self.userOrderInfo.allExp
    end

    self.oldAllExp = oldExp
    local everyGradeExp = self:getEveryGradeNeedExp()
    self.oldLevel = math.floor(oldExp / everyGradeExp)
    self.oldReallyLevel = self.oldLevel
end

-- 存入当前的经验，并获取当前的等级和经验
function ConstructionOrderMain:setNewUserInfo()
    local activityType = 186
    writeKey(activityType.."construction_order_user_exp" , self.userOrderInfo.allExp)

    self.newAllExp = self.userOrderInfo.allExp
    local everyGradeExp = self:getEveryGradeNeedExp()
    self.newLevel = math.floor(self.newAllExp / everyGradeExp) 
end

-- 升级、增加经验的动画
function ConstructionOrderMain:controlDrawLevelAndExpAnimation()
    -- 经验有变化
    if self.oldAllExp < self.newAllExp then
        self.playExpAnimationState = true
    else
        self.playExpAnimationState = false
    end

    -- 等级有变化
    if self.oldLevel < self.newLevel then
        self.playLevelAnimationState = true
    else
        self.playLevelAnimationState = false
    end

    -- 经验进度条增加的经验
    local tAddExp = 0
    local everyGradeExp = self:getEveryGradeNeedExp()
    if self.playLevelAnimationState == true then
        local needAddExp1 = everyGradeExp - (self.oldAllExp % everyGradeExp)
        local needAddExp2 = self.newAllExp % everyGradeExp
        tAddExp = needAddExp1 + needAddExp2
    else
        tAddExp = self.newAllExp - self.oldAllExp
    end
    
    -- 进度条每帧增加经验值
    local tSpeed = tAddExp / everyGradeExp * self.BARSPEEDRATIO
    self.barSpeed = (tSpeed >= self.BARMINSPEED and tSpeed or self.BARMINSPEED)

end

-- 移除升级动画并隐藏
function ConstructionOrderMain:removeLevelAnimation()
    self.Panel_levelup:removeAllChildren(true)
    self.Panel_levelup_effect:removeAllChildren(true)
    
    self.BitmapFontLabel_1:setVisible(false)
    self.Image_close:setVisible(false)
    self.Text_tip_close:setVisible(false)
    self.Panel_levelup:setVisible(false)
    self.Panel_levelup_effect:setVisible(false)
end

-- 绘制升级动画
function ConstructionOrderMain:updateDrawLevelAnimation()
    self.BitmapFontLabel_1:setVisible(true)
    self.BitmapFontLabel_1:setString(self.oldReallyLevel)

    self.Image_close:setVisible(true)
    self.Text_tip_close:setVisible(true)
    self.Panel_levelup:setVisible(true)
    self.Panel_levelup_effect:setVisible(true)

    local function animationFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
        if evt ~= nil then
            if evt == "number"  then
                self.BitmapFontLabel_1:setString(self.newLevel)

                local jsonFile = "images/ui/effice/effect_passport_levelup_1/effect_passport_levelup_1.json"
                local atlasFile = "images/ui/effice/effect_passport_levelup_1/effect_passport_levelup_1.atlas"
                local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
                animation2:setAnimation(0, "animation", false)
                animation2:setPosition(cc.p(self.Panel_levelup_effect:getContentSize().width / 2, self.Panel_levelup_effect:getContentSize().height / 2))
                self.Panel_levelup_effect:addChild(animation2)
            end
        end
    end

    local jsonFile = "images/ui/effice/effect_passport_levelup/effect_passport_levelup.json"
    local atlasFile = "images/ui/effice/effect_passport_levelup/effect_passport_levelup.atlas"
    local animation1 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
    animation1:setAnimation(0, "animation", false)
    
    sp.initArmature(animation1, false)
    animation1:setPosition(cc.p(self.Panel_levelup:getContentSize().width / 2, self.Panel_levelup:getContentSize().height / 2))

    self.Panel_levelup:addChild(animation1)
    animation1:getAnimation():setFrameEventCallFunc(animationFrameEvent)
end

-- 绘制增加经验
function ConstructionOrderMain:updateDrawExpAnimation()
    if self.isLockButtonState == false then
        state_machine.excute("construction_order_main_lock_button", 0, nil)
        self.isLockButtonState = true
    end
    local everyGradeExp = self:getEveryGradeNeedExp()
    local tempExpAnimationState = self.playExpAnimationState
    if self.newLevel > self.oldLevel then
        self.oldAllExp = self.oldAllExp + self.barSpeed
        -- 跨级，进度条只增长一轮
        -- 之前等级进度满的时候，开始最新等级经验的增长
        if self.oldAllExp % everyGradeExp <= self.barSpeed then
            self.oldAllExp = self.oldAllExp + (self.newLevel - self.oldLevel - 1) * everyGradeExp
            self.oldLevel = self.newLevel
        end
    else

        if self.oldAllExp < self.newAllExp then
            self.oldAllExp = self.oldAllExp + self.barSpeed
            -- 经验增长完毕
            if self.oldAllExp >= self.newAllExp then
                self.oldAllExp = self.newAllExp
                self.playExpAnimationState = false
            end
        end

    end
    local progress = (self.oldAllExp % everyGradeExp) / everyGradeExp * 100
    self.LoadingBar_exp:setPercent(progress)
    
    -- 进度条光效坐标的控制
    local width = self.LoadingBar_exp:getContentSize().width
    self.Panel_progress_effect:setVisible(true)
    self.Panel_progress_effect:setPositionX(self.baseProgressEffectPosX + width * progress/100)
    
    if self.playExpAnimationState == true then
        self.Panel_progress_effect:setVisible(true)
    else
        self.Panel_progress_effect:setVisible(false)
        -- 经验进度条增长完毕，更新进度条显示
        if tempExpAnimationState ~= self.playExpAnimationState then
            state_machine.excute("construction_order_main_unlock_button", 0, nil)
            
            local tExp = self.newAllExp % everyGradeExp
            self.Text_progress:setString(tExp .. "/" .. everyGradeExp)
            self.Text_level:setString(self.newLevel)
            self.isLockButtonState = false

            if self.playLevelAnimationState == true then
                self:updateDrawLevelAnimation()
                self.playLevelAnimationState = false
            end
        end
    end
end

-- 控制属性界面的显隐
function ConstructionOrderMain:controlShowPropertiyPanel(isShow)
    if isShow == true then
        if #self.ListView_shuxing:getItems() == 0 then
            self:showSkinProperties()
        end
        self.ListView_shuxing:setVisible(true)
        self.Button_hide_property:setVisible(true)
    else
        self.ListView_shuxing:setVisible(false)
        self.Button_hide_property:setVisible(false)
    end
end

-- 绘制属性界面
function ConstructionOrderMain:showSkinProperties()
    local skinID = self:getPicInfo()[2]
    local propertiesAllInfoString = dms.string(dms["ship_skin_mould"], skinID, ship_skin_mould.additional)
    local isAddPercentInfo = zstring.split(dms.string(dms["ship_skin_mould"], skinID, ship_skin_mould.add_percent), "|", tonumber)
    local propertiesInfoString = zstring.split(propertiesAllInfoString, "|")

    local listViewHeight = 0
    for i, v in ipairs(propertiesInfoString) do
        local propertiesInfo = zstring.split(v, ',', function ( value ) return tonumber(value) end)
        local cell = state_machine.excute("construction_order_property_list_create", 0, {propertyInfo = propertiesInfo, isAddPercent = isAddPercentInfo[i]})
        listViewHeight = listViewHeight + cell.roots[1]:getContentSize().height
        self.ListView_shuxing:addChild(cell)
    end
    self.ListView_shuxing:setContentSize(cc.size(self.ListView_shuxing:getContentSize().width, listViewHeight))
    self.ListView_shuxing:requestRefreshView()
    self.ListView_shuxing:jumpToTop()
end

function ConstructionOrderMain:initDrawUI()
    self:showCurrencyUI()
    self:drawBackPic()
    self:drawSkinAdditionPic()
end

-- 获取当期的立绘与皮肤ID
function ConstructionOrderMain:getPicInfo()
    local picString = dms.string(dms["play_config"], 286, play_config.param)
    local picInfo = zstring.split(picString, "|")
    local curPeriod = self.userOrderInfo.curPeriod 
    curPeriod = curPeriod > #picInfo and #picInfo or curPeriod
    local curPicInfo = zstring.split(picInfo[curPeriod], ",", tonumber)
    return curPicInfo
end

-- 绘制立绘
function ConstructionOrderMain:drawBackPic()
    local picID = self:getPicInfo()[1]
    local picPath = string.format("image/cut/passport_roles/cut_passport_roles_%d.png", picID)
    if cc.FileUtils:getInstance():isFileExist(picPath) == false then
        picPath = "image/cut/passport_roles/cut_passport_roles_1.png"
    end
    self.Panel_role:setBackGroundImage(picPath)
end

-- 皮肤属于单体or全体增益属性
function ConstructionOrderMain:drawSkinAdditionPic()
    local skinID = self:getPicInfo()[2]
    local skinAdditionRangeType = dms.int(dms["ship_skin_mould"], skinID, ship_skin_mould.addition_range)
    local picPath = nil
    if skinAdditionRangeType == 1 then
        picPath = "image/activity/passport/activity_passport_deco_4.png"
    elseif skinAdditionRangeType == 2 then
        picPath = "image/activity/passport/activity_passport_deco_3.png"
    end

    self.Image_deco_1:loadTexture(picPath)
end

-- 连续购买期数显示
function ConstructionOrderMain:showSeriesPurchasePeriods()
    for i, v in ipairs(self.continuousPurchasePics) do
        v:setVisible(false)
    end
    -- 已连续购买期数
    local seriesPurchasePeriods = self.userOrderInfo.seriesPurchasePeriods
    self.seriesPurchaseRewardState = self.userOrderInfo.seriesPurchaseRewardState
    local needPeriodNums = self:getPurchasePeriodNums()

    if seriesPurchasePeriods >= needPeriodNums and self.seriesPurchaseRewardState == 1 then
        self.Button_2:setVisible(true)
        local jsonFile = "images/ui/effice/effect_passport_qishu/effect_passport_qishu.json"
        local atlasFile = "images/ui/effice/effect_passport_qishu/effect_passport_qishu.atlas"
        local aniName = "animation"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, true, nil)
        animation:setPosition(cc.p(self.Panel_qishu_effect:getContentSize().width / 2, self.Panel_qishu_effect:getContentSize().height / 2))
        self.Panel_qishu_effect:addChild(animation)
    else
        self.Button_2:setVisible(false)
        self.Panel_qishu_effect:removeAllChildren(true)
    end
    
    if seriesPurchasePeriods > 0 then
        for i = 1, seriesPurchasePeriods do
            self.continuousPurchasePics[i]:setVisible(true)
        end
    end

    self.Text_qishu:setString(seriesPurchasePeriods)

end

-- 获取连续购买获得奖励期数
function ConstructionOrderMain:getPurchasePeriodNums()
    local periodNums = dms.int(dms["play_config"], 276, play_config.param)
    return periodNums
end

-- 每次升级所需经验
function ConstructionOrderMain:getEveryGradeNeedExp()
    local everyGradeExp = dms.int(dms["play_config"], 281, play_config.param)
    return everyGradeExp
end

function ConstructionOrderMain:showCurrencyUI()
	-- 货币显示（金币、体力、钻石）
	local root = self.roots[1]
	local cell = state_machine.excute("currency_icon_create", 0, {propType = 2, propID = nil, callback = function()
        state_machine.excute("construction_order_main_window_close", 0, nil)
    end})
	ccui.Helper:seekWidgetByName(root, "Panel_currency_1"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_currency_1"):addChild(cell)

    cell = state_machine.excute("currency_icon_create", 0, {propType = 12, propID = nil})
	ccui.Helper:seekWidgetByName(root, "Panel_currency_2"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_currency_2"):addChild(cell)

	cell = state_machine.excute("currency_icon_create", 0, {propType = 1, propID = nil})
	ccui.Helper:seekWidgetByName(root, "Panel_currency_3"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_currency_3"):addChild(cell)

end

-- 对界面进行适配
function ConstructionOrderMain:initSuitUI()
    local root = self.roots[1]
    local distance = 0
    local RIGHTLIMITX = 240            -- 左边界面可以往右移动的最远坐标
    local LEFTLIMITX = 198           -- 右边界面可以往左移动的最远坐标

	local director = cc.Director:getInstance()
	local glView = director:getOpenGLView()
	local frameScreen = tonumber(glView:getFrameSize().width) / tonumber(glView:getFrameSize().height)
	local designScreen = tonumber(app.designSize.width) / tonumber(app.designSize.height)
	local scale = frameScreen / designScreen
	if scale < 1 then
		scale = 1
	end

    -- 计算左边的坐标
	local posLeft = fwin:convertToWorldSpaceAR(root , cc.p(self.Panel_zuo_t:getPositionX() , self.Panel_zuo_t:getPositionY()))
    local moveRight = math.abs(RIGHTLIMITX - posLeft.x) * (scale - 1)
    self.Panel_zuo_t:setPosition(self.Panel_zuo_t:getPositionX() + moveRight, self.Panel_zuo_t:getPositionY())

	local posRight = fwin:convertToWorldSpaceAR(root , cc.p(self.Panel_you_t:getPositionX() , self.Panel_you_t:getPositionY()))
    local moveLeft = math.abs(posRight.x - LEFTLIMITX) * (scale - 1)
    self.Panel_you_t:setPosition(self.Panel_you_t:getPositionX() - moveLeft, self.Panel_you_t:getPositionY())
end

-- 对象初始化
function ConstructionOrderMain:init(params)
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function ConstructionOrderMain:onUpdateDraw()
    local root = self.roots[1]

    -- 活动结束时间
    self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time_1")
    
    -- 角色等级
    self.Text_level = ccui.Helper:seekWidgetByName(root, "Text_lv")

    -- 角色经验进度条
    self.LoadingBar_exp = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")

    -- 经验进度条头部动画
    self.Panel_progress_effect = ccui.Helper:seekWidgetByName(root, "Panel_progress_effect")

    -- 角色经验文本
    self.Text_progress = ccui.Helper:seekWidgetByName(root, "Text_exp")

    -- 战令等级奖励容器
    self.ListView_allreward = ccui.Helper:seekWidgetByName(root, "ListView_tab")

    -- 特殊奖励的普通奖励容器
    self.Panel_special_reward_normal = ccui.Helper:seekWidgetByName(root, "Panel_item_1")

    -- 特殊奖励的进阶奖励容器一
    self.Panel_special_reward_advance1 = ccui.Helper:seekWidgetByName(root, "Panel_item_1_0")
    
    -- 特殊奖励的进阶奖励容器二
    self.Panel_special_reward_advance2 = ccui.Helper:seekWidgetByName(root, "Panel_item_1_1")

    -- 进阶版未解锁显示
    self.Lock_advanced = ccui.Helper:seekWidgetByName(root, "Image_lock")

    -- 立绘绘制容器
    self.Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")

    -- 特殊奖励文本
    self.Text_special_level = ccui.Helper:seekWidgetByName(root, "Text_61")

    -- 左边部分的父节点
    self.Panel_zuo_t = ccui.Helper:seekWidgetByName(root, "Panel_zuo_t")
    
    -- 右边部分的父节点
    self.Panel_you_t = ccui.Helper:seekWidgetByName(root, "Panel_you_t")

    -- 皮肤属性列表
    self.ListView_shuxing = ccui.Helper:seekWidgetByName(root, "ListView_shuxing")

    -- 连续购买进阶战令奖励可领取特效容器
    self.Panel_qishu_effect = ccui.Helper:seekWidgetByName(root, "Panel_qishu_effect")

    -- 升级前的等级文本
    self.BitmapFontLabel_1 = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_1")

    -- 升级动画容器
    self.Panel_levelup = ccui.Helper:seekWidgetByName(root, "Panel_levelup")

    -- 升级字体动画容器
    self.Panel_levelup_effect = ccui.Helper:seekWidgetByName(root, "Panel_levelup_effect")

    -- 关闭升级动画提示文本
    self.Text_tip_close = ccui.Helper:seekWidgetByName(root, "Text_tip_close")

    -- 皮肤属性单体or群体加成提示图片容器
    self.Image_deco_1 = ccui.Helper:seekWidgetByName(root, "Image_deco_1")

    -- 连续购买期数文本
    self.Text_qishu = ccui.Helper:seekWidgetByName(root, "Text_qishu")
    
    -- 连续购买期数进度图片1
    self.Image_qishu_1 = ccui.Helper:seekWidgetByName(root, "Image_qishu_1")

    -- 连续购买期数进度图片2
    self.Image_qishu_2 = ccui.Helper:seekWidgetByName(root, "Image_qishu_2")
 
    -- 连续购买期数进度图片3
    self.Image_qishu_3 = ccui.Helper:seekWidgetByName(root, "Image_qishu_3")
 
    table.insert(self.continuousPurchasePics, self.Image_qishu_1)
    table.insert(self.continuousPurchasePics, self.Image_qishu_2)
    table.insert(self.continuousPurchasePics, self.Image_qishu_3)
end

-- 初始化控件的视图
function ConstructionOrderMain:initUIVisibleAndData()
    -- 升级动画容器
    self.Panel_levelup:setVisible(false)
    -- 升级字体动画容器
    self.Panel_levelup_effect:setVisible(false)
    -- 浏览皮肤属性
    self.Button_chakan:setVisible(true)
    -- 关闭升级动画按钮
    self.Image_close:setVisible(false)
    -- 隐藏皮肤属性界面
    self.Button_hide_property:setVisible(false)
    -- 升级前的等级文本
    self.BitmapFontLabel_1:setVisible(false)
    -- 关闭升级动画提示文本
    self.Text_tip_close:setVisible(false)

    
    self._activityEndTime = self.userOrderInfo.endTime
end

-- 红点注册
function ConstructionOrderMain:drawRed()
    -- 全民福利红点
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_construction_warorder_welfare_reward_push",
	_widget = self.Button_national_welfare,
	_invoke = nil,
	_interval = 0.5,})

    -- 任务刷新红点
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_construction_warorder_update_task_push",
	_widget = self.Button_task,
	_invoke = nil,
	_interval = 0.5,
    _updateState = true})

    -- 一键领取红点
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_construction_warorder_can_receive_reward_push",
	_widget = self.Button_click_collection,
	_invoke = nil,
	_interval = 0.5,})
end

function ConstructionOrderMain:drawButton()
    local root = self.roots[1]

    -- 充值进阶战令
    self.Button_buy_warorder =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_unlock"),
        nil,
        {
            terminal_name = "construction_order_main_buy_warorder",
            terminal_state = 0,
            isPressedActionEnabled = true,
        },
        nil,
        0
    )

    -- 右侧普通奖励领取
    self.Button_receive_normal =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_lingqu_putong"),
        nil,
        {
            terminal_name = "construction_order_main_refresh_rewards_state",
            terminal_state = 0,
            isPressedActionEnabled = true,
            rewardType = 1,
            receiveType = 1,
            cell = self,
        },
        nil,
        0
    )

    -- 右侧进阶奖励领取
    self.Button_receive_advance =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_lingqu_gaoji"),
        nil,
        {
            terminal_name = "construction_order_main_refresh_rewards_state",
            terminal_state = 0,
            isPressedActionEnabled = true,
            rewardType = 2,
            receiveType = 1,
            cell = self,
        },
        nil,
        0
    )

    -- 一键领取奖励
    self.Button_click_collection =
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_lingqu"),
        nil,
        {
            terminal_name = "construction_order_main_refresh_rewards_state",
            terminal_state = 0,
            isPressedActionEnabled = true,
            rewardType = -1,
            receiveType = 0,        -- 是否一键领取
            cell = self,
        },
        nil,
        0
    )

    -- 领取连续购买战令奖励
    self.Button_2 =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_2"),
        nil,
        {
            terminal_name = "construction_order_main_refresh_rewards_state",
            terminal_state = 0,
            isPressedActionEnabled = true,
            receiveType = 1,  
            rewardType = 4,      
            cell = self,
        },
        nil,
        0
    )

    -- 打开商店界面
    self.Button_shop =
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_shop"),
        nil,
        {
            terminal_name = "construction_order_main_open_shop",
            terminal_state = 0,
            isPressedActionEnabled = true,
        },
        nil,
        0
    )

    -- 打开任务界面
    self.Button_task =
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_task"),
        nil,
        {
            terminal_name = "construction_order_main_open_task",
            terminal_state = 0,
            isPressedActionEnabled = true,
            mcell = self,
        },
        nil,
        0
    )

    -- 打开全民福利界面
    self.Button_national_welfare =
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_weal"),
        nil,
        {
            terminal_name = "construction_order_main_open_welfare",
            terminal_state = 0,
            isPressedActionEnabled = true,
        },
        nil,
        0
    )

    -- 打开规则界面
    self.Button_rule =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_1"),
        nil,
        {
            terminal_name = "construction_order_main_open_rule",
            terminal_state = 0,
            isPressedActionEnabled = true,
        },
        nil,
        0
    )

    -- 浏览皮肤属性
    self.Button_chakan =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_chakan"),
        nil,
        {
            terminal_name = "construction_order_main_show_skin_properties",
            terminal_state = 0,
            isPressedActionEnabled = true,
            isShow = true,
        },
        nil,
        0
    )

    -- 隐藏皮肤属性界面
    self.Button_hide_property =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Image_dianjifanwei"),
        nil,
        {
            terminal_name = "construction_order_main_show_skin_properties",
            terminal_state = 0,
            isPressedActionEnabled = true,
            isShow = false,
        },
        nil,
        0
    )

     -- 关闭升级动画按钮
    self.Image_close =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Image_close"),
        nil,
        {
            terminal_name = "construction_order_main_close_level_animation",
            terminal_state = 0,
            isPressedActionEnabled = true,
            isShow = false,
        },
        nil,
        0
    )

    -- 关闭
    self.Button_close =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "construction_order_main_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

end

function ConstructionOrderMain:onEnterTransitionFinish()
    -- 加载ConstructionOrderMain界面资源.
    local csbNode = csb.createNode("activity/passport/passport_main_jianhao.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self:updateUserData()
    self:drawButton()
    self:onUpdateDraw()
    self:initUIVisibleAndData()
    self:updateActivityRemainTime()
    self:initSuitUI()
    self:drawRed()
    self:updateRoleExp()
    self:initDrawExpProgress()
    self:updateAllRewards()
    self:updateReward()
    self:showSeriesPurchasePeriods()
    self:initDrawUI()
end

function ConstructionOrderMain:onExit()
    -- 释放ChristmasRomanceWindow界面资源.
    state_machine.remove("construction_order_main_open")
    state_machine.remove("construction_order_main_close")
    state_machine.remove("construction_order_main_show")
    state_machine.remove("construction_order_main_hide")
    state_machine.remove("construction_order_main_open_rule")
    state_machine.remove("construction_order_main_buy_warorder")
    state_machine.remove("construction_order_main_open_shop")
    state_machine.remove("construction_order_main_open_task")
    state_machine.remove("construction_order_main_open_welfare")
    state_machine.remove("construction_order_main_refresh_rewards_state")
    state_machine.remove("construction_order_main_activation_warorder")
    state_machine.remove("construction_order_main_get_exp")
    state_machine.remove("construction_order_main_close_allInterface")
    state_machine.remove("construction_order_main_show_skin_properties")
    state_machine.remove("construction_order_main_lock_button")
    state_machine.remove("construction_order_main_unlock_button")
    state_machine.remove("construction_order_main_close_level_animation")
    
end

function ConstructionOrderMain:close()
    -- window event : close.
end

function ConstructionOrderMain:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
