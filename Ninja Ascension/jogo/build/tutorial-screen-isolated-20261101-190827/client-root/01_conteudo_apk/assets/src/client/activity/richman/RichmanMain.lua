--[[ ----------------------------------------------------------------------------
-- 大富翁主界面
--]] ----------------------------------------------------------------------------
RichmanMain = class("RichmanMainClass", Window)

-- 打开窗口
local richman_main_window_open_terminal = {
    _name = "richman_main_window_open",
    _init = function(terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RichmanMainClass") then
            fwin:open(RichmanMain:new(), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local richman_main_window_close_terminal = {
    _name = "richman_main_window_close",
    _init = function(terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RichmanMainClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(richman_main_window_open_terminal)
state_machine.add(richman_main_window_close_terminal)
state_machine.init()

-- 构造器
function RichmanMain:ctor()
    self.super:ctor()

    self.roots = {}
	
    -- 倒计时
    self.totalTime = 0
    self.deltaTime = 1

    self.dir = 1

    self.allTempLightRewardStopIdxs = {}
    -- 存放每个格子到达前的等级
    self.beforeArrivalcellLevelList = {}
    -- 临时存放神秘大奖+普通格子的奖励
    self.show_temp_reward_list_group = nil

    -- 格子总数
    self.gridTotalCount = 18
    -- 事件类型
    self.envetTypeEnum = {
        NORMAL = 1,
        TRANSFER =2,
        DOUBLE = 3,
        ADDPROP = 4
    }
    -- 方向
    self.dirTypeEnum = {
        LEFT = -1,
        RIGHT = 1
    }

    -- 格子位置类型
    self.gridTypeEnum = {
        UP = 1,
        DOWN = 2,
        LEFT = 3,
        RIGHT = 4,
        CORNER = 5
    }

    -- 确定每个格子人物的朝向
    self.gridRoleDirList = {
        [self.dirTypeEnum.RIGHT] = {1, 2, 3, 4, 5, 6, 16, 17, 18},
        [self.dirTypeEnum.LEFT] = {7, 8, 9, 10, 11, 12, 13, 14, 15},
    }

    -- 格子位置分类
    self.gridIndexCategory = {
        [self.gridTypeEnum.UP] = {2, 3, 4, 5},
        [self.gridTypeEnum.RIGHT] = {7, 8, 9},
        [self.gridTypeEnum.DOWN] = {11, 12, 13, 14},
        [self.gridTypeEnum.LEFT] = {16, 17, 18},
        [self.gridTypeEnum.CORNER] = {1, 6, 10, 15}
    }

    -- 角色动作组枚举
    self.playerAnimationEnum = {
        STAND_LEFT = 0, 
        STAND_RIGHT = 1, 
        JUMP_LEFT = 2, 
        JUMP_RIGHT = 3, 
        RUN_LEFT = 4, 
        RUN_RIGHT = 5, 
    }

    -- 玩家当前正在移动
    self.playerIsRunning = false
    -- 玩家当前处于神秘大奖状态
    self.isOnShowBigReward = false

    app.load("client.activity.richman.RichmanRule")
    app.load("client.activity.richman.RichmanRewardRecord")
    app.load("client.activity.richman.RichmanChoosePointsReward")
    app.load("client.activity.richman.RichmanTask")
    app.load("client.activity.richman.RichmanChooseDiceNumber")
    app.load("client.activity.richman.RichmanDiamondPurchaseDice")
    app.load("client.activity.richman.RichmanDiceGetAccess")
    app.load("client.activity.richman.RichmanGrandSlamPopup")
	app.load("client.utils.CurrencyIcon")
	app.load("client.reward.DrawRareReward")

	local function init_richman_main_terminal()
        -- 打开角色创建窗口
        local richman_main_open_terminal = {
            _name = "richman_main_open",
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
        local richman_main_close_terminal = {
            _name = "richman_main_close",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 清空活动数据，为红点更新做处理 getRichmanRedState(activity_type)
                _ED.active_activity[187].activity_data = nil

                state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 187)
                state_machine.excute("richman_main_window_close", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示窗口
        local richman_main_show_terminal = {
            _name = "richman_main_show",
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
        local richman_main_hide_terminal = {
            _name = "richman_main_hide",
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

		-- 玩法说明
        local richman_main_rule_window_open_terminal = {
            _name = "richman_main_rule_window_open",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 玩法说明
                if nil ~= instance then
                    state_machine.excute("rich_man_rule_window_open", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 任务
        local richman_main_taskview_open_terminal = {
            _name = "richman_main_taskview_open",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    state_machine.excute("richman_task_window_open", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 领奖记录
        local richman_main_awardsview_open_terminal = {
            _name = "richman_main_awardsview_open",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseBuyPropCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("richman_reward_record_window_open", 0, nil)
				    end
				end
				protocol_command.monopoly_reward_log.param_list = ""
				NetworkManager:register(protocol_command.monopoly_reward_log.code, nil, nil, nil, nil, responseBuyPropCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 扔骰子
        local richman_main_roll_dice_terminal = {
            _name = "richman_main_roll_dice",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
					local diceType = params._datas.diceType
					local propIsEnough = instance:checkDiceEnough(diceType)
					if propIsEnough == false then
						TipDlg.drawTextDailog(tipStringInfo_richman[1])
						return
					end

                    -- 特殊骰子
                    if diceType == 1 and params._datas.dicePosIdxNum == nil then
                        state_machine.excute("richman_choose_dice_number_window_open", 0, nil)
                        return
                    end

                    -- 角色移动前的位置
                    self.startPosIndex = self._userDataInfo.curPosIndex

                    state_machine.excute("richman_main_lock_state")
					local function responseBuyPropCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								instance:updateUserData()
                                instance:startThrowDice(diceType)
                            else
                                state_machine.excute("richman_main_unlock_state")
							end
						else
                            state_machine.excute("richman_main_unlock_state")
					    end
					end
                    -- 骰子骰子的位置
					local dicePosIdxNum = diceType == 0 and -1 or params._datas.dicePosIdxNum
					protocol_command.monopoly_throw_dice.param_list = diceType .. "\r\n".. dicePosIdxNum
					NetworkManager:register(protocol_command.monopoly_throw_dice.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 钻石购买骰子
        local richman_main_diamond_purchase_dice_terminal = {
            _name = "richman_main_diamond_purchase_dice",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("richman_diamond_purchase_dice_window_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 选择积分奖励
        local richman_main_choose_points_reward_terminal = {
            _name = "richman_main_choose_points_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local index = params._datas.index
				state_machine.excute("richman_choose_points_reward_window_open", 0, index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 骰子获取途径界面
        local richman_main_dice_get_access_terminal = {
            _name = "richman_main_dice_get_access",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local diceType = params._datas.diceType
                state_machine.excute("richman_dice_get_access_window_open", 0, diceType)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 领取积分奖励
        local richman_main_get_points_reward_terminal = {
            _name = "richman_main_get_points_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    local rewardButton = params._datas.rewardButton
					if rewardButton == nil or rewardButton.scoreIndex == nil then
						return false
					end

                    local scoreIndex = rewardButton.scoreIndex
					local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								app.load("client.reward.DrawRareReward")
								local getRewardWnd = DrawRareReward:new()
								getRewardWnd:init(7)
								fwin:open(getRewardWnd,fwin._ui)
								
								state_machine.excute("richman_main_update_points_reward", 0, nil)
							end
                        end
                    end
                    protocol_command.monopoly_get_achieve_reward.param_list = scoreIndex
                    NetworkManager:register(protocol_command.monopoly_get_achieve_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 更新积分奖励内容
        local richman_main_update_points_reward_terminal = {
            _name = "richman_main_update_points_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    instance:updateUserData()
                    instance:updateDrawPointsReward()
                    instance:updateUserActivityParams()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

		-- 传送格子事件
        local richman_main_transfer_cell_terminal = {
            _name = "richman_main_transfer_cell",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    local curPosIdx = params._datas.choosIdx
                    -- 角色移动前的位置
                    self.startPosIndex = self._userDataInfo.curPosIndex
					local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                

								instance:updateUserData()
                                self._userDataInfo.isTransfer = 0
								instance:specialTransferUI(false)
                                instance:changeClickEventState()
                                state_machine.excute("richman_main_lock_state", 0, nil)
                                instance:transferGrid()
							end
                        end
                    end
                    protocol_command.monopoly_transmission.param_list = curPosIdx
                    NetworkManager:register(protocol_command.monopoly_transmission.code, nil, nil, nil, instance, responseCallback, false, nil)
					
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 更新骰子数量
        local richman_main_update_dice_numbers_terminal = {
            _name = "richman_main_update_dice_numbers",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    instance:updateDiceNumbers()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新任务红点
        local richman_main_refresh_task_red_point_terminal = {
            _name = "richman_main_refresh_task_red_point",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    instance:refreshTaskRedPoint()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 状态机锁
        local richman_main_lock_state_terminal = {
            _name = "richman_main_lock_state",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("richman_main_close")
                state_machine.lock("richman_main_rule_window_open")
                state_machine.lock("richman_main_taskview_open")
                state_machine.lock("richman_main_awardsview_open")
                state_machine.lock("richman_main_diamond_purchase_dice")
                state_machine.lock("richman_main_dice_get_access")
                state_machine.lock("richman_main_roll_dice")
                state_machine.lock("richman_choose_dice_number_window_open")
                state_machine.lock("richman_main_transfer_cell")
                state_machine.lock("richman_main_get_points_reward")
                state_machine.lock("richman_main_choose_points_reward")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 状态机解锁
        local richman_main_unlock_state_terminal = {
            _name = "richman_main_unlock_state",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.unlock("richman_main_close")
                state_machine.unlock("richman_main_rule_window_open")
                state_machine.unlock("richman_main_taskview_open")
                state_machine.unlock("richman_main_awardsview_open")
                state_machine.unlock("richman_main_diamond_purchase_dice")
                state_machine.unlock("richman_main_dice_get_access")
                state_machine.unlock("richman_main_roll_dice")
                state_machine.unlock("richman_choose_dice_number_window_open")
                state_machine.unlock("richman_main_transfer_cell")
                state_machine.unlock("richman_main_get_points_reward")
                state_machine.unlock("richman_main_choose_points_reward")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 播放神秘大奖动画
        local richman_main_play_big_reward_animation_terminal = {
            _name = "richman_main_play_big_reward_animation",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:startShowBigReward()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
        state_machine.add(richman_main_open_terminal)
        state_machine.add(richman_main_close_terminal)
        state_machine.add(richman_main_show_terminal)
        state_machine.add(richman_main_hide_terminal)
        state_machine.add(richman_main_rule_window_open_terminal)
        state_machine.add(richman_main_taskview_open_terminal)
        state_machine.add(richman_main_awardsview_open_terminal)
        state_machine.add(richman_main_roll_dice_terminal)
        state_machine.add(richman_main_diamond_purchase_dice_terminal)
        state_machine.add(richman_main_choose_points_reward_terminal)
        state_machine.add(richman_main_dice_get_access_terminal)
        state_machine.add(richman_main_get_points_reward_terminal)
        state_machine.add(richman_main_update_points_reward_terminal)
        state_machine.add(richman_main_transfer_cell_terminal)
        state_machine.add(richman_main_update_dice_numbers_terminal)
        state_machine.add(richman_main_refresh_task_red_point_terminal)
        state_machine.add(richman_main_lock_state_terminal)
        state_machine.add(richman_main_unlock_state_terminal)
        state_machine.add(richman_main_play_big_reward_animation_terminal)
		
        state_machine.init()
    end
    -- call func init state machine.
    init_richman_main_terminal()

end

function RichmanMain:onUpdate(dt)
    self.totalTime = self.totalTime + dt
    if self.totalTime >= self.deltaTime then
        self:updateActivityRemainTime()
        self.totalTime = 0
    end
end

function RichmanMain:updateActivityRemainTime()
    if self.Text_10 == nil or self._activityEndTime == nil then
        return
    end
    local surplus_time = (self._activityEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
    self.Text_10:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function RichmanMain:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.floor((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .._string_piece_info[231]
    end
    if _hourTime < 10 then
        timeString = timeString .. "0".._hourTime ..":"
    else
        timeString = timeString .. _hourTime ..":"
    end

    if _minutesTime < 10 then
        timeString = timeString .. "0".._minutesTime ..":"
    else
        timeString = timeString .. _minutesTime ..":"
    end

    if _secondsTime < 10 then
        timeString = timeString .. "0".._secondsTime 
    else
        timeString = timeString .. _secondsTime 
    end
    return timeString
end

function RichmanMain:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/dafuweng/dafuweng.csb")
    local root = csbNode:getChildByName("root")
    self:addChild(csbNode)
    table.insert(self.roots, root)

    self:initFormData()

	self:updateUserData()

    self:initCellLevel()

	self:drawBtns()

	self:onUpdateDraw()

	self:initDrawUI()

    self:updateActivityRemainTime()
end

-- 初始化表格数据
function RichmanMain:initFormData()
    -- 普通骰子配置
    self.normalDiceConfig = {
        propID = zstring.split(dms.string(dms["activity_config"], 102, activity_config.param), ",",  tonumber)[2],
        onceCostNum = dms.int(dms["activity_config"], 106, activity_config.param),
        score = dms.int(dms["activity_config"], 104, activity_config.param),
    }

    -- 幸运骰子配置
    self.luckyDiceConfig = {
        propID = zstring.split(dms.string(dms["activity_config"], 103, activity_config.param), ",",  tonumber)[2],
        onceCostNum = dms.int(dms["activity_config"], 107, activity_config.param),
        score = dms.int(dms["activity_config"], 105, activity_config.param),
    }

    -- 格子最大等级上限
    self.maxCellLevel = dms.int(dms["activity_config"], 110, activity_config.param)

    -- 初始化格子数据
    self.gridFormDataList = {}
    for i = 1, dms.count(dms["monopoly_mould"]) do
        local gridFormData = {}
        gridFormData.id = dms.int(dms["monopoly_mould"], i, monopoly_mould.id)
        gridFormData.posIdx = dms.int(dms["monopoly_mould"], i, monopoly_mould.posIdx)
        gridFormData.cellType = dms.int(dms["monopoly_mould"], i, monopoly_mould.cellType)
        gridFormData.cellReward = dms.string(dms["monopoly_mould"], i, monopoly_mould.cellReward)
        table.insert(self.gridFormDataList, gridFormData)
    end
end

-- 更新用户数据
function RichmanMain:updateUserData()
    self._userDataInfo = _ED.active_activity[187].activity_data
    -- debug.print_r(self._userDataInfo, "self._userDataInfo")
    self._activityEndTime = _ED.active_activity[187].end_time
end

-- 获取每个格子初始时的等级
function RichmanMain:initCellLevel()
    for i, v in ipairs(self._userDataInfo.cellLevelList) do
        self.beforeArrivalcellLevelList[i] = v
    end
end

function RichmanMain:drawBtns()
    local root = self.roots[1]
    -- 关闭
    self.dafuweng_Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "dafuweng_Button_close"), nil, 
    {
        terminal_name = "richman_main_close",
        terminal_state = 0, 
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 规则
    self.Button_guizi = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guize"), nil, 
    {
        terminal_name = "richman_main_rule_window_open",
        terminal_state = 0, 
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 任务
    self.Button_renwu = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_renwu"), nil, 
    {
        terminal_name = "richman_main_taskview_open",
        terminal_state = 0, 
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 领奖记录
    self.Button_jiangli = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jiangli"), nil, 
    {
        terminal_name = "richman_main_awardsview_open",
        terminal_state = 0, 
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 钻石购买骰子
    self.Button_goumai = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_goumai"), nil, 
    {
        terminal_name = "richman_main_diamond_purchase_dice",
        terminal_state = 0, 
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 获取普通骰子
    self.Button_jia = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jia"), nil, 
    {
        terminal_name = "richman_main_dice_get_access",
        terminal_state = 0, 
        isPressedActionEnabled = true,
        diceType = 0,
    },
    nil,0)

    -- 获取特殊骰子
    self.Button_jia_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jia_1"), nil, 
    {
        terminal_name = "richman_main_dice_get_access",
        terminal_state = 0, 
        isPressedActionEnabled = true,
        diceType = 1,
    },
    nil,0)

    -- 扔普通骰子
    self.dafuweng_Button_touzi_0 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "dafuweng_Button_touzi_0"), nil, 
    {
        terminal_name = "richman_main_roll_dice",
        terminal_state = 0, 
        isPressedActionEnabled = true,
        diceType = 0,
    },
    nil,0)

    -- 扔特殊骰子
    self.dafuweng_Button_touzi_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "dafuweng_Button_touzi_1"), nil, 
    {
        terminal_name = "richman_main_roll_dice",
        terminal_state = 0, 
        isPressedActionEnabled = true,
        diceType = 1,
    },
    nil,0)
end

function RichmanMain:onUpdateDraw()
    local root = self.roots[1]
    -- 文本
    -- 活动剩余时间
    self.Text_10 = ccui.Helper:seekWidgetByName(root, "Text_10")
    -- 普通骰子数量
    self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    -- 特殊骰子数量
    self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
    -- 当前积分数
    self.Text_18 = ccui.Helper:seekWidgetByName(root, "Text_18")
    -- 剩余翻倍次数
    self.Text_29 = ccui.Helper:seekWidgetByName(root, "Text_29")
    -- 选择想要前往的格子
    self.Text_4 = ccui.Helper:seekWidgetByName(root, "Text_4")
    -- 规则
    self.Text_tips = ccui.Helper:seekWidgetByName(root, "Text_tips")
    -- 积分数
    self.Text_18 = ccui.Helper:seekWidgetByName(root, "Text_18")

    -- 积分奖励进度条
    self.LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")


    -- 选择要前往格子数时中间部分遮罩
    self.Image_mask = ccui.Helper:seekWidgetByName(root, "Image_mask")
    -- 任务红点
    self.Image_tips_point = ccui.Helper:seekWidgetByName(root, "Image_tips_point")

    -- 选择跳过骰子动画
    self.CheckBox_1 = ccui.Helper:seekWidgetByName(root, "CheckBox_1")


    -- 剩余积分翻倍次数
    self.Panel_fanbei = ccui.Helper:seekWidgetByName(root, "Panel_fanbei")
    -- 皮肤立绘展示
    self.Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
    -- 升星动效
    self.Panel_star_dongxiao = ccui.Helper:seekWidgetByName(root, "Panel_star_dongxiao")
    -- 骰子投掷动效
    self.dafuweng_Panel_dongxiao = ccui.Helper:seekWidgetByName(root, "dafuweng_Panel_dongxiao")
    -- 
    self.Panel_currency_1 = ccui.Helper:seekWidgetByName(root, "Panel_currency_1")
    -- 
    self.Panel_currency_2 = ccui.Helper:seekWidgetByName(root, "Panel_currency_2")
    -- 
    self.Panel_currency_3 = ccui.Helper:seekWidgetByName(root, "Panel_currency_3")
    -- 传送时事件格子遮罩
    self.Panel_mask = ccui.Helper:seekWidgetByName(root, "Panel_mask")


    -- 格子Icon列表
    self.gridUIList = {}
    for i = 1, self.gridTotalCount do
        local gridUI = {}
        -- 格子的索引
        gridUI.posIdx = i
        -- 方向
        gridUI.dir = nil
        for dir, v in pairs(self.gridRoleDirList) do
            if gridUI.dir == nil then
                for _, posIdx in pairs(v) do
                    if posIdx == i then
                        gridUI.dir = dir
                        break
                    end
                end
            end
        end

        -- 格子选中灯带（1-18）
        gridUI.lightImg = ccui.Helper:seekWidgetByName(root, "dafuweng_Image_choose_" .. i)
        -- 格子背景底图（1-18）
        gridUI.bgImg = ccui.Helper:seekWidgetByName(root, "dafuweng_lmage_icon_" .. i)
        -- 格子神秘奖励获得底图（1-18）
        gridUI.bigRewardBgImg = ccui.Helper:seekWidgetByName(root, "dafuweng_Image_lvse_" .. i)
        -- 格子奖励物品（1-18）
        gridUI.rewardPanel = ccui.Helper:seekWidgetByName(root, "dafuweng_Panel_icon_" .. i)
        -- 物品等级(1-18）（需要判空）
        gridUI.levelText = ccui.Helper:seekWidgetByName(root, "dafuweng_Text_icon_" .. i)
        -- 格子选中灯带特效（1-18）
        gridUI.lightEffectPanel = ccui.Helper:seekWidgetByName(root, "dafuweng_Panel_choose_" .. i)
        -- 传送点击按钮
        gridUI.transferButton = ccui.Helper:seekWidgetByName(root, "Button_" .. i)
        -- 转角遮罩4个（只有转角有）（需要判空）
        gridUI.cornerPanel = ccui.Helper:seekWidgetByName(root, "dafuweng_Image_mask_" .. i)

        -- 初始化隐藏神秘大奖底图
        if gridUI.bigRewardBgImg ~= nil then
            gridUI.bigRewardBgImg:setVisible(false)
        end

        -- 设定可以传送的格子点击事件
        if gridUI.transferButton ~= nil then
            gridUI.transferButton:setTouchEnabled(false)
            if self:getGridEventType(i) == self.envetTypeEnum.NORMAL then
                fwin:addTouchEventListener(gridUI.transferButton, nil, 
                {
                    terminal_name = "richman_main_transfer_cell",
                    terminal_state = 0, 
                    isPressedActionEnabled = true,
                    choosIdx = i,
                },
                nil,0)
            end
        end

        table.insert(self.gridUIList, gridUI)
    end
        
    -- 积分奖励UI列表
    self.scoreRewardUIList = {}
    for i = 1, self._userDataInfo.everyStageNums do
        local scoreRewardUI = {}
        scoreRewardUI.index = i
        -- 积分奖励特效
        scoreRewardUI.rewardEffectPanel = ccui.Helper:seekWidgetByName(root, "Panel_score_reward_effect_" .. i)
        -- 积分奖励
        scoreRewardUI.rewardPanel = ccui.Helper:seekWidgetByName(root, "Panel_score_reward_icon_" .. i)
        -- 积分
        scoreRewardUI.score = ccui.Helper:seekWidgetByName(root, "Text_score_reward_" .. i)
        -- 领取积分奖励按钮
        scoreRewardUI.rewardButton = ccui.Helper:seekWidgetByName(root, "Button_score_reward_jiangli_" .. i)
        -- 可选积分奖励按钮
        scoreRewardUI.selectButton = ccui.Helper:seekWidgetByName(root, "Button_score_reward_xuanze_" .. i)
        -- 可选积分奖励未选择时"+"按钮
        scoreRewardUI.selectPlusButton = ccui.Helper:seekWidgetByName(root, "Image_score_reward_add_" .. i)
        -- 已领取icon灰态图片
        scoreRewardUI.mask = ccui.Helper:seekWidgetByName(root, "Image_score_reward_mask_" .. i)
        -- 已领取标签
        scoreRewardUI.received = ccui.Helper:seekWidgetByName(root, "Image_score_reward_received_" .. i)
        -- 积分进度条
        scoreRewardUI.pointLoadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_" .. i)

        fwin:addTouchEventListener(scoreRewardUI.rewardButton, nil, 
        {
            terminal_name = "richman_main_get_points_reward",
            terminal_state = 0, 
            isPressedActionEnabled = true,
            rewardButton = scoreRewardUI.rewardButton
        },
        nil,0)

        fwin:addTouchEventListener(scoreRewardUI.selectButton, nil, 
        {
            terminal_name = "richman_main_choose_points_reward",
            terminal_state = 0, 
            isPressedActionEnabled = true,
            index = i
        },
        nil,0)

        fwin:addTouchEventListener(scoreRewardUI.selectPlusButton, nil, 
        {
            terminal_name = "richman_main_choose_points_reward",
            terminal_state = 0, 
            isPressedActionEnabled = true,
            index = i
        },
        nil,0)

        table.insert(self.scoreRewardUIList, scoreRewardUI)
    end
end

-- 获得格子的事件类型
function RichmanMain:getGridEventType(posIdx)
    local eventType = nil
    for _, v in ipairs(self.gridFormDataList) do
        if v.posIdx == posIdx then
            eventType = v.cellType
            break
        end
    end
    return eventType
end

function RichmanMain:initDrawUI()
    self:updateDiceNumbers()

    self:updateDrawRole()
    self:updateDrawAllRewardCell()
    self:updateDrawCellLevel()
    self:updateDrawCellLight()

    self:specialTransferUI(self._userDataInfo.isTransfer == 1)

    self:showDoublePointsTip()
    self:updateDrawSpecialPoints()
    self:initDrawSkipButton()
    self:showCurrencyUI()
    self:changeClickEventState()
    self:refreshTaskRedPoint()
end

-- 更新骰子数量
function RichmanMain:updateDiceNumbers()
    local normalDiceNumbers = tonumber(getPropAllCountByMouldId(self.normalDiceConfig.propID))
    local specialDiceNumbers = tonumber(getPropAllCountByMouldId(self.luckyDiceConfig.propID))
    -- 普通骰子数量
    self.Text_1:setString(normalDiceNumbers)
    -- 特殊骰子数量
    self.Text_2:setString(specialDiceNumbers)

    local count = normalDiceNumbers + specialDiceNumbers
    if _ED.totalRichmanDiceCount == nil then
        _ED.totalRichmanDiceCount = normalDiceNumbers + specialDiceNumbers
    end

    if count < _ED.totalRichmanDiceCount then
        _ED.totalRichmanDiceCount = count
    end
end

function RichmanMain:updateDrawRole(isBigReward)
    local curPosIndex = isBigReward == true and 1 or self._userDataInfo.curPosIndex

    local jsonFile = "images/ui/effice/effect_monopoly_taiyi/effect_monopoly_taiyi.json"
    local atlasFile = "images/ui/effice/effect_monopoly_taiyi/effect_monopoly_taiyi.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "stand_right", true, nil)

    local rolePosX = self.gridUIList[curPosIndex].bgImg:getPositionX()
    local rolePosY = self.gridUIList[curPosIndex].bgImg:getPositionY()
    animation:setPosition(cc.p(rolePosX, rolePosY))
    self.Panel_role:addChild(animation)

    animation.animationNameList = {"stand_left", "stand_right", "jump_left", "jump_right", "run_left", "run_right"}
    sp.initArmature(animation, nil, true)

    -- 存储玩家动画节点
    if isBigReward == true then
        self.bigRewardPlayerAni = animation
    else
        self.playerAni = animation
    end

    self:changeRoleDir(self.gridUIList[curPosIndex].dir)
end

-- 设置角色朝向（每掷一次骰子就要调用此方法）
function RichmanMain:changeRoleDir(dir, isShowBigReward)
    if self.playerAni ~= nil then
        self:setRoleDir(dir)
        if isShowBigReward == true then
            self.bigRewardPlayerAni:setScaleX(self.dir)
        else
            self.playerAni:setScaleX(self.dir)
        end
    end
end

-- 获得角色的朝向(-1是左 1是右 )
function RichmanMain:setRoleDir(dir)
    -- print("self.dir = ", self.dir, " isUp = ", isUp, " isDown = ", isDown)
    self.dir = dir
end

-- 绘制所有格子里面的内容
function RichmanMain:updateDrawAllRewardCell()
    local gridUIList = self.gridUIList
    for _, v in ipairs(gridUIList) do
        self:drawCellReward(v)
    end
end

-- 绘制单个格子的奖励
function RichmanMain:drawCellReward(gridUI)
    local posIdx = gridUI.posIdx
    local rewardPanel = gridUI.rewardPanel
    
    local cellInfo = self:getCellInfo(posIdx)
    local formData = cellInfo.formData

    rewardPanel:removeAllChildren(true)
    rewardPanel:removeBackGroundImage()

    if formData.cellType == 1 then
        -- 普通格子的奖励
        local rewardCell = DrawHandle.drawIcon(cellInfo.curReward)
        rewardPanel:addChild(rewardCell)
    elseif formData.cellType == 2 then
        local picPath = "image/activity/dafuweng/activity_monopoly_arrow.png"
        rewardPanel:setBackGroundImage(picPath)
    elseif formData.cellType == 3 then
        local picPath = "image/activity/dafuweng/activity_monopoly_double.png"
        rewardPanel:setBackGroundImage(picPath)
    elseif formData.cellType == 4 then
        local picPath = "image/activity/dafuweng/activity_monopoly_dice_1.png"
        rewardPanel:setBackGroundImage(picPath)
    end
end

-- 获取格子信息
function RichmanMain:getCellInfo(posIdx, isMinus)
    local cellInfo = {}

    local formData = self:getGridFormDataListByPosIdx(posIdx)
    local curLevel = self._userDataInfo.cellLevelList[posIdx] + 1

    if isMinus == true then
        -- 到达格子前的等级≠到达格子后的等级
        if self._userDataInfo.cellLevelList[posIdx] ~= self.beforeArrivalcellLevelList[posIdx] then
            self.beforeArrivalcellLevelList[posIdx] = self._userDataInfo.cellLevelList[posIdx]
            curLevel = curLevel - 1
        end
    end
    cellInfo.formData = formData
    -- 如果大于最大等级，则为最大等级
    cellInfo.curLevel = curLevel >= self.maxCellLevel and self.maxCellLevel or curLevel
    -- 普通格子
    if formData.cellType == self.envetTypeEnum.NORMAL then
        local cellReward = zstring.split(formData.cellReward, "|")
        cellInfo.curReward = cellReward[cellInfo.curLevel]
    elseif formData.cellType == self.envetTypeEnum.ADDPROP then
        local cellReward = zstring.split(formData.cellReward, "|")
        cellInfo.curReward = cellReward[1]
    end

    return cellInfo
end

function RichmanMain:getGridFormDataListByPosIdx(posIdx)
    local data = nil
    for _, v in ipairs(self.gridFormDataList) do
        if v.posIdx == posIdx then
            data = v
            break
        end
    end
    return data
end

-- 绘制格子等级
function RichmanMain:updateDrawCellLevel()
    local gridUIList = self.gridUIList
    for _, v in ipairs(gridUIList) do
        local level = self._userDataInfo.cellLevelList[v.posIdx] + 1
        if v.levelText ~= nil then
            v.levelText:setString(string.format(tipStringInfo_richman[3], level))
        end
    end
end

-- 绘制格子灯带
function RichmanMain:updateDrawCellLight()
    local gridUIList = self.gridUIList
    for _, v in ipairs(gridUIList) do
        local isLight = self._userDataInfo.cellLightingStateList[v.posIdx] == 1
        v.lightImg:setVisible(isLight)

        self:drawCellArriveAni(v.posIdx, false)
    end
end

-- 传送UI切换
function RichmanMain:specialTransferUI(isShow)
    self.Panel_mask:setVisible(isShow)
    self.Image_mask:setVisible(isShow)
    self.Text_4:setVisible(isShow)
end

-- 积分翻倍提示
function RichmanMain:showDoublePointsTip()
    if self._userDataInfo.remainScoreDoubleTimes > 0 then
        self.Panel_fanbei:setVisible(true)

        local cellInfo = dms.searchs(dms["monopoly_mould"], monopoly_mould.cellType, self.envetTypeEnum.DOUBLE)[1]
        local rewardInfo = dms.atos(cellInfo, monopoly_mould.cellReward)
        local pointTimes = zstring.split(rewardInfo, ",")

        self.Text_29:setString(string.format(tipStringInfo_richman[8], self._userDataInfo.remainScoreDoubleTimes, pointTimes[2]))
    else
        self.Panel_fanbei:setVisible(false)
    end
end

-- 绘制积分特殊奖励内容
function RichmanMain:updateDrawSpecialPoints()
    self:updateSpecialPointsNumber()
    self:updateDrawPointsReward()
    self:updateUserActivityParams()
end

-- 更新积分数量
function RichmanMain:updateSpecialPointsNumber()
    local points = self._userDataInfo.allAchievePoints
    self.Text_18:setString(points)
end

-- 绘制积分特殊奖励内容
function RichmanMain:updateDrawPointsReward()
    local everyStageNum = self._userDataInfo.everyStageNums

    local pointRewardsInfo = self._userDataInfo.pointRewardsInfo
    local allPointRewardCounts = table.nums(pointRewardsInfo)

    local curUnreceiveIdx = 0
    for i, v in ipairs(pointRewardsInfo) do
        if v.rewardState == 0 or v.rewardState == 1 then
            curUnreceiveIdx = i
            break
        end
    end

    -- 当前处于第几阶段
    local curStage = math.ceil(curUnreceiveIdx / everyStageNum)
    if curStage == 0 then
        curStage = math.ceil(#pointRewardsInfo / everyStageNum)
    end
    -- print("curStage = ", curStage)
    -- 当前阶段积分奖励数据
    local index = 1
    local curStagePointsRewadList = {}
    for i, v in ipairs(pointRewardsInfo) do
        if i > (curStage - 1) * everyStageNum and i <= curStage * everyStageNum then
            -- print("scoreIndex = ", i)
            curStagePointsRewadList[index] = {data = v, scoreIndex = i}
            index = index + 1
        end
    end
    
    -- 获取之前阶段的总积分
    local oldStageTotalScore = pointRewardsInfo[(curStage - 1) * everyStageNum] and pointRewardsInfo[(curStage - 1) * everyStageNum].needPoints or 0
    
    local curPercent = 0
    for i, everyRewardPoint in ipairs(curStagePointsRewadList) do
        -- 获取上一个格子需要的积分数量
        local lastPoint = i == 1 and oldStageTotalScore or (curStagePointsRewadList[i-1].data.needPoints )
        -- 上个格子到当前格子需要的积分数量
        local needPoint = everyRewardPoint.data.needPoints - lastPoint

        if self._userDataInfo.allAchievePoints >= everyRewardPoint.data.needPoints then
            everyRewardPoint.pointPercent = 1
        else
            everyRewardPoint.pointPercent = (self._userDataInfo.allAchievePoints - lastPoint) / needPoint
        end
        everyRewardPoint.pointPercent = everyRewardPoint.pointPercent > 0 and everyRewardPoint.pointPercent or 0
    end

    for i, v in ipairs(self.scoreRewardUIList) do
        if curStagePointsRewadList[i] ~= nil then
            local data = curStagePointsRewadList[i].data
            local scoreIndex = curStagePointsRewadList[i].scoreIndex
            local pointPercent = curStagePointsRewadList[i].pointPercent

            v.rewardEffectPanel:removeAllChildren(true)
            v.rewardPanel:removeAllChildren(true)
            v.score:setVisible(false)
            v.rewardButton:setVisible(false)
            v.selectButton:setVisible(false)
            v.selectPlusButton:setVisible(false)

            if data ~= nil then
                v.score:setVisible(true)
                v.score:setString(data.needPoints)
                v.rewardButton:setVisible(data.rewardState == 1)
                v.mask:setVisible(data.rewardState == 2)
                v.received:setVisible(data.rewardState == 2)


                -- 是否可领取
                v.rewardButton.scoreIndex = nil
                if data.rewardState == 1 then
                    if data.canChooseReward == 1 then
                        if data.chooseIdx > 0 then
                            v.rewardButton.scoreIndex = scoreIndex
                        end
                    else
                        v.rewardButton.scoreIndex = scoreIndex
                    end
                end

                if data.rewardState == 1 then
                    local jsonFile = "images/ui/effice/effect_monopoly_jiangli/effect_monopoly_jiangli.json"
                    local atlasFile = "images/ui/effice/effect_monopoly_jiangli/effect_monopoly_jiangli.atlas"

                    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation2", true, nil)
                    animation:setAnimation(0, "animation2", true)
                    animation:setPosition(cc.p(v.rewardEffectPanel:getContentSize().width/2, v.rewardEffectPanel:getContentSize().height/2))
                    v.rewardEffectPanel:addChild(animation)
                end

                local propIcon = nil
                local chooseIdx = nil
                -- 可选奖励
                if data.canChooseReward == 1 then
                    if data.chooseIdx > 0 then
                        chooseIdx = data.rewardIdxInfo[data.chooseIdx]
                    end
                else
                    chooseIdx = data.rewardIdxInfo[1]
                end

                -- 可选择并且没有领奖且已选择奖励
                v.selectButton:setVisible(data.canChooseReward == 1 and data.rewardState ~= 2 and chooseIdx ~= nil)
                -- 可选择且没有领奖且没有选择奖励
                v.selectPlusButton:setVisible(data.canChooseReward == 1 and data.rewardState ~= 2 and chooseIdx == nil)
                if chooseIdx ~= nil then
                    local rewardInfo = self:getPointRewardByIndex(chooseIdx)
                    propIcon = DrawHandle.drawIcon(rewardInfo)
                end

                if propIcon ~= nil then
                    v.rewardPanel:addChild(propIcon)
                end
            end

            if pointPercent ~= nil then
                v.pointLoadingBar:setPercent(pointPercent * 100)
            end
        end
    end

end

-- 更新用户积分奖励数据
function RichmanMain:updateUserActivityParams()
    -- print("积分 updateUserActivityParams>>>>>>>>>>>>>>>>>>>")
    local userDataInfo = _ED.active_activity[187].activity_params
    if userDataInfo == nil then
        return
    end

    local activity_data = _ED.active_activity[187].activity_data
    if activity_data == nil then
        return
    end

    -- 协议数据
    local pointRewardsInfo = activity_data.pointRewardsInfo
    local achieveRewardList = {}
    
    for i, v in ipairs(pointRewardsInfo) do
        table.insert(achieveRewardList, v.rewardState)
    end

    -- 用户数据
    local userDataInfo = json.decode(userDataInfo)
    userDataInfo.achieveReward = zstring.concat(achieveRewardList, ",")

    -- 更新
    userDataInfo = json.encode(userDataInfo)
    _ED.active_activity[187].activity_params = userDataInfo
end

-- 根据奖励下标取对应的奖励内容
function RichmanMain:getPointRewardByIndex(index)
    local rewardInfo = nil
    local allScoreRewardList = self._userDataInfo.allScoreRewardList
    for i, v in ipairs(allScoreRewardList) do
        if i == index then
            rewardInfo = v
            break
        end
    end
    return rewardInfo
end

function RichmanMain:initDrawSkipButton()
    -- 默认不跳过
    local skipFlag = false
    local skipResult = self:getSkipState()
    if skipResult == false then
        self:setSkipState(0)
    else
        skipFlag = skipResult
    end
    self.CheckBox_1:setSelected(skipFlag)
    self.CheckBox_1:addTouchEventListener(function(sender, eventType)
        if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
            self:updateSelect()
        end
    end)
end

-- 获取跳过状态
function RichmanMain:getSkipState()
    local openState = readKey("activitType187".."_".."skipState")
    if openState ~= "" and tonumber(openState) == 1 then
        return true
    end
    return false
end

-- 设置跳过状态
function RichmanMain:setSkipState(mState)
    writeKey("activitType187".."_".."skipState", mState)
end

function RichmanMain:updateSelect()
    local isSelected = self.CheckBox_1:isSelected()
    -- 1为跳过， 0为不跳过
    if isSelected == false then
        self:setSkipState(1)
    else
        self:setSkipState(0)
    end
end

-- 货币显示（普通骰子、特殊骰子、钻石）
function RichmanMain:showCurrencyUI()
    local cell = state_machine.excute("currency_icon_create", 0, {propType = 6, propID = self.normalDiceConfig.propID})
    self.Panel_currency_1:removeAllChildren(true)
    self.Panel_currency_1:addChild(cell)

    local cell = state_machine.excute("currency_icon_create", 0, {propType = 6, propID = self.luckyDiceConfig.propID})
    self.Panel_currency_2:removeAllChildren(true)
    self.Panel_currency_2:addChild(cell)

    local cell = state_machine.excute("currency_icon_create", 0, {propType = 2, propID = nil, callback = function()
        state_machine.excute("richman_main_close", 0, nil)
    end})
    self.Panel_currency_3:removeAllChildren(true)
    self.Panel_currency_3:addChild(cell)
end

-- 判断骰子数量是否足够
function RichmanMain:checkDiceEnough(diceType)
    local diceConfig = nil
    diceConfig = (diceType == 0) and self.normalDiceConfig or self.luckyDiceConfig

    local propNums = tonumber(getPropAllCountByMouldId(diceConfig.propID))
    -- print("diceConfig.propID = ", diceConfig.propID, " propNums = ", propNums, " diceConfig.onceCostNum = ", diceConfig.onceCostNum)
    return propNums >= diceConfig.onceCostNum
end

-- 开始投掷骰子
function RichmanMain:startThrowDice(diceType)
    local userDiceNum = self._userDataInfo.userDiceNum

    -- 展示结果->移除
    local function changeActionCallbackTwo(armatureBack1)
        if armatureBack1 then
            armatureBack1._invoke = nil
            armatureBack1:removeFromParent(true)
            self:updateRoads()
            self:playerMove()
        end
    end

    -- 播放骰子动画
    local function changeActionCallbackOne(armatureBack)
        if armatureBack then
            armatureBack._invoke = changeActionCallbackTwo
            armatureBack:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            csb.animationChangeToAction(armatureBack, userDiceNum, userDiceNum, false)
        end
    end

    local jsonFile = nil
    local atlasFile = nil
    if diceType == 0 then
        jsonFile = "images/ui/effice/effect_monopoly_touzi/effect_monopoly_touzi.json"
        atlasFile = "images/ui/effice/effect_monopoly_touzi/effect_monopoly_touzi.atlas"
    elseif diceType == 1 then
        jsonFile = "images/ui/effice/effect_monopoly_touzi_lucky/effect_monopoly_touzi_lucky.json"
        atlasFile = "images/ui/effice/effect_monopoly_touzi_lucky/effect_monopoly_touzi_lucky.atlas"
    end

    self.dafuweng_Panel_dongxiao:removeAllChildren(true)

    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
    animation.animationNameList = {"animation", "1", "2", "3", "4", "5", "6"}
    sp.initArmature(animation, false)
    
    self.dafuweng_Panel_dongxiao:addChild(animation)
    animation:setPosition(self.dafuweng_Panel_dongxiao:getContentSize().width/2, self.dafuweng_Panel_dongxiao:getContentSize().height/2)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    
    if self:getSkipState() == true then
        animation._invoke = changeActionCallbackTwo
        csb.animationChangeToAction(animation, userDiceNum, userDiceNum, false)
    else
        animation._invoke = changeActionCallbackOne
        csb.animationChangeToAction(animation, 0, 0, false)
    end
end

-- 获得角色移动路径
function RichmanMain:updateRoads()
    local userDiceNum = self._userDataInfo.userDiceNum
    local endPosIndex = self.startPosIndex + userDiceNum
    
    self.roadIds = {}
    for i = self.startPosIndex + 1, endPosIndex do
        table.insert(self.roadIds, (i%18 == 0 and 18 or i%18))
    end

    -- debug.print_r(self.roadIds, "self.roadIds")
end

-- 角色移动
function RichmanMain:playerMove()
    self.moveIdx = self.moveIdx or 1
    local posIdx = self.roadIds[self.moveIdx]
    
    --回到起点
    if posIdx == nil then
        self.moveIdx = nil
        self.playerIsRunning = false
        self:playerNormalMoveEndEvent()
        return
    end

    -- print("playerMove->posIdx = ", posIdx)
    local nextPos = cc.p(self.gridUIList[posIdx].bgImg:getPositionX(), self.gridUIList[posIdx].bgImg:getPositionY())

    -- 当前玩家所处格子下标（实时变动）
    self.curPosIdx = posIdx
    -- 每跳一次计算下朝向
    local dir = self.gridUIList[posIdx].dir
    self:changeRoleDir(dir)
    if self.playerIsRunning == false then
        self.playerIsRunning = true
        csb.animationChangeToAction(self.playerAni, self.playerAnimationEnum.RUN_RIGHT, self.playerAnimationEnum.RUN_RIGHT, false)
    end
    self.playerAni:stopAllActions()
    self.playerAni:runAction(cc.Sequence:create(cc.MoveTo:create(0.5, nextPos), 
        cc.CallFunc:create(function () 
            self.moveIdx = self.moveIdx + 1
            self:playerMove()
        end
    )))
end

-- 移动到最后一个格子的事件
function RichmanMain:playerNormalMoveEndEvent(isShowBigReward)

    -- 移除消失光效，角色显示
    local function changeActionCallbackTwo(armatureBack)
        if armatureBack then
            armatureBack._invoke = nil
            armatureBack:removeFromParent(true)
            self.playerAni:setVisible(true)
        end
    end

    -- 玩家走到对应格子后的行为
    local function changeActionCallbackOne(armatureBack)
        if armatureBack then
            armatureBack._invoke = nil
            if isShowBigReward == true then
                self._userDataInfo.isShowBigReward = false
                self.isOnShowBigReward = false
                -- print("移除神秘大奖动画")
                self:recoverBigRewardBgImg()
                armatureBack:removeFromParent(true)
                local disappearPos = cc.p(self.bigRewardPlayerAni:getPositionX(), self.bigRewardPlayerAni:getPositionY())
                -- 播放角色消失动画
                self:playRoleDisappearAni(self.Panel_role, disappearPos, changeActionCallbackTwo)
            end
            -- 是神秘大奖并且不处于传送状态时，直接播放神秘大奖动画
            if self._userDataInfo.isShowBigReward == true and self._userDataInfo.isTransfer ~= 1 then
                self.allTempLightRewardStopIdxs = self._userDataInfo.allLightRewardStopIdxs
                state_machine.excute("richman_grand_slam_popup_window_open", 0, nil)
            else
                if self._userDataInfo.isShowBigReward == true then
                    self.allTempLightRewardStopIdxs = self._userDataInfo.allLightRewardStopIdxs
                    self.isOnShowBigReward = true
                end
                state_machine.excute("richman_main_unlock_state")
            end
            -- 绘制奖励
            self:drawReward(isShowBigReward)
            -- 刷新界面
            self:refreshDrawUI()
        end
    end

    if isShowBigReward == true then
        self.bigRewardPlayerAni._invoke = changeActionCallbackOne
        self.bigRewardPlayerAni:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    else
        self.playerAni._invoke = changeActionCallbackOne
        self.playerAni:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    end
    csb.animationChangeToAction(self.playerAni, self.playerAnimationEnum.JUMP_RIGHT, self.playerAnimationEnum.STAND_RIGHT, true)
end

function RichmanMain:drawReward(isShowBigReward)
    if isShowBigReward == true then
        -- 神秘大奖+普通奖励
        local show_reward_view = clone(self.show_temp_reward_list_group == nil and self.show_reward_list_group or self.show_temp_reward_list_group)
        self.show_temp_reward_list_group = nil
        -- debug.print_r(show_reward_view, "show_reward_view 222")

        local rewardInfo = {}
        for i, v in ipairs(self.allTempLightRewardStopIdxs) do
            local cellCurInfo = self:getCellInfo(v)
            local tempInfo = zstring.split(cellCurInfo.curReward, ",")
            local tempRewardInfo = {}
            tempRewardInfo.type = tempInfo[1]
            tempRewardInfo.id = tempInfo[2]
            tempRewardInfo.number = tempInfo[3]
            table.insert(rewardInfo, tempRewardInfo)
        end

        -- debug.print_r(rewardInfo, "神秘大奖")

        local getRewardWnd = DrawRareReward:new()
        getRewardWnd:init(7, show_reward_view, rewardInfo)
        fwin:open(getRewardWnd, fwin._ui)
    else
        -- 如果触发神秘大奖，神秘大奖是和普通格子奖励一起过来的
        if _ED.show_reward_list_group ~= nil then
            self.show_reward_list_group = clone(_ED.show_reward_list_group[1])
        end
        -- 备份神秘大奖的奖励数据
        if self.isOnShowBigReward == true and self._userDataInfo.isShowBigReward == true then
            self.show_temp_reward_list_group = clone(_ED.show_reward_list_group[1])
        end
        local show_reward_view = clone(self.show_reward_list_group)
        -- debug.print_r(show_reward_view, "show_reward_view 111")

        local posIdx = self._userDataInfo.curPosIndex
        local cellCurInfo = self:getCellInfo(posIdx, true)
        -- debug.print_r(cellCurInfo, "cellCurInfo")
        local cellType = cellCurInfo.formData.cellType
        if cellType == self.envetTypeEnum.NORMAL or cellType == self.envetTypeEnum.ADDPROP then
            local rewardInfo = {}
            local tempInfo = zstring.split(cellCurInfo.curReward, ",")

            local tempRewardInfo = {}
            tempRewardInfo.type = tempInfo[1]
            tempRewardInfo.id = tempInfo[2]
            tempRewardInfo.number = tempInfo[3]
            table.insert(rewardInfo, tempRewardInfo)

            local getRewardWnd = DrawRareReward:new()
            getRewardWnd:init(7, show_reward_view, rewardInfo)
            fwin:open(getRewardWnd, fwin._ui)
        end
    end 
end

function RichmanMain:refreshDrawUI()
    self:drawCellArriveAni(self._userDataInfo.curPosIndex, false)

    self:drawGetPointAni()

    self:updateDiceNumbers()

    self:drawCellReward(self.gridUIList[self._userDataInfo.curPosIndex])

    self:updateDrawCellLevel()

    self:updateDrawCellLight()

    self:specialTransferUI(self._userDataInfo.isTransfer == 1)

    self:showDoublePointsTip()

    self:updateDrawSpecialPoints()

    self:changeClickEventState()

    self:refreshTaskRedPoint()
end

-- 播放格子到达灯带动画
function RichmanMain:drawCellArriveAni(posIdx, isBigReward)
    local lightEffectPanel = self.gridUIList[posIdx].lightEffectPanel
    lightEffectPanel:removeAllChildren(true)

    -- 格子类型
    local gridType = -1
    for k, v in pairs(self.gridIndexCategory) do
        for _, gridIndex in pairs(v) do
            if posIdx == gridIndex then
                gridType = k
                break
            end
        end
    end

    local jsonFile = nil
    local atlasFile = nil
    local animationNameList = {}
    if gridType == self.gridTypeEnum.UP or gridType == self.gridTypeEnum.DOWN then
        jsonFile = "images/ui/effice/effect_monopoly_gezi2/effect_monopoly_gezi2.json"
        atlasFile = "images/ui/effice/effect_monopoly_gezi2/effect_monopoly_gezi2.atlas"
        animationNameList = {"animation1", "animation2", "animation3"}
    elseif gridType == self.gridTypeEnum.LEFT or gridType == self.gridTypeEnum.RIGHT then
        jsonFile = "images/ui/effice/effect_monopoly_gezi1/effect_monopoly_gezi1.json"
        atlasFile = "images/ui/effice/effect_monopoly_gezi1/effect_monopoly_gezi1.atlas"
        animationNameList = {"animation1", "animation2", "animation3"}
    elseif gridType == self.gridTypeEnum.CORNER then
        jsonFile = "images/ui/effice/effect_monopoly_gezi3/effect_monopoly_gezi3.json"
        atlasFile = "images/ui/effice/effect_monopoly_gezi3/effect_monopoly_gezi3.atlas"
        animationNameList = {"animation", "animation2"}
    end
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, nil, false, nil)
    sp.initArmature(animation, false)
    animation.animationNameList = animationNameList
    lightEffectPanel:addChild(animation)
    animation:setPosition(cc.p(lightEffectPanel:getContentSize().width / 2, lightEffectPanel:getContentSize().height / 2))

    -- 如果没到达过，播放animation1的动画  到达过播放animation2动画
    local animationIdx = 0
    -- 神秘大奖
    if isBigReward == true then
        if gridType ~= self.gridTypeEnum.CORNER then
            animationIdx = 2
        else
            animationIdx = self._userDataInfo.cellLightingStateList[posIdx] == 1 and 1 or 0
        end
    else
        animationIdx = self._userDataInfo.cellLightingStateList[posIdx] == 1 and 1 or 0
    end
    -- print("播放格子点亮动画 animationIdx = ", animationIdx, " jsonFile = ", jsonFile)
    csb.animationChangeToAction(animation, animationIdx, animationIdx, true)
end

-- 播放积分增加动画
function RichmanMain:drawGetPointAni()
    local Panel_star_dongxiao = self.Panel_star_dongxiao
    self.Panel_star_dongxiao:removeAllChildren(true)

    local function changeActionCallbackOne(armatureBack)
        if armatureBack then
            armatureBack._invoke = nil
            armatureBack:removeFromParent(true)
        end
    end

    local jsonFile = "images/ui/effice/effect_monopoly_jifen/effect_monopoly_jifen.json"
    local atlasFile = "images/ui/effice/effect_monopoly_jifen/effect_monopoly_jifen.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallbackOne
    animation.animationNameList = {"animation"}
    Panel_star_dongxiao:addChild(animation)
    animation:setPosition(cc.p(Panel_star_dongxiao:getContentSize().width / 2, Panel_star_dongxiao:getContentSize().height / 2))
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation, 0, 0, false)
end

-- 触发神秘大奖
function RichmanMain:startShowBigReward()
    state_machine.excute("richman_main_lock_state")

    -- 主角色隐藏
    self.playerAni:setVisible(false)
    self:recoverBigRewardBgImg()
    -- 执行神秘大奖角色移动逻辑
    self:updateDrawRole(true)
    self:updateBigRewardRoads()
    self:startBigRewardPlayMove()
end

-- 重置神秘大奖底图
function RichmanMain:recoverBigRewardBgImg()
    for _, v in ipairs(self.gridUIList) do
        if v.bigRewardBgImg ~= nil then
            v.bigRewardBgImg:setVisible(false)
        end
    end
end

-- 获得角色移动路径
function RichmanMain:updateBigRewardRoads()
    local startPosIndex = 1
    local endPosIndex = 19
    
    self.bigRewardRoadIds = {}
    for i = startPosIndex, endPosIndex do
        table.insert(self.bigRewardRoadIds, (i%18 == 0 and 18 or i%18))
    end

    -- debug.print_r(self.bigRewardRoadIds, "self.bigRewardRoadIds")
end

-- 神秘大奖移动
function RichmanMain:startBigRewardPlayMove()
    self.bigRewardMoveIdx = self.bigRewardMoveIdx or 1
    local posIdx = self.bigRewardRoadIds[self.bigRewardMoveIdx]
    
    --回到起点
    if posIdx == nil then
        self.bigRewardMoveIdx = nil
        csb.animationChangeToAction(self.bigRewardPlayerAni, self.playerAnimationEnum.JUMP_RIGHT, self.playerAnimationEnum.STAND_RIGHT, false)
        self:playerNormalMoveEndEvent(true)
        return
    end

    local nextPos = cc.p(self.gridUIList[posIdx].bgImg:getPositionX(), self.gridUIList[posIdx].bgImg:getPositionY())

    -- 每跳一次计算下朝向
    local dir = self.gridUIList[posIdx].dir
    -- print("神秘大奖 角色朝向 dir = ", dir, " posIdx = ", posIdx)
    self:changeRoleDir(dir, true)

    local function changeActionCallbackOne(armatureBack)
        if armatureBack then
            armatureBack._invoke = nil
            -- print("下一次移动")
            self.bigRewardMoveIdx = self.bigRewardMoveIdx + 1
            csb.animationChangeToAction(self.bigRewardPlayerAni, self.playerAnimationEnum.RUN_RIGHT, self.playerAnimationEnum.RUN_RIGHT, false)
            self:startBigRewardPlayMove()
        end
    end

    self.bigRewardPlayerAni:stopAllActions()
    self.bigRewardPlayerAni:runAction(cc.Sequence:create(cc.MoveTo:create(0.5, nextPos), 
        cc.CallFunc:create(function () 
            -- self:drawCellArriveAni(posIdx, true)
            local isSpecialState = false
            for i, v in ipairs(self.allTempLightRewardStopIdxs) do
                if v == posIdx then
                    isSpecialState = true
                    if self.gridUIList[posIdx].bigRewardBgImg ~= nil then
                        self.gridUIList[posIdx].bigRewardBgImg:setVisible(true)
                    end
                    self.bigRewardPlayerAni._invoke = changeActionCallbackOne
                    self.bigRewardPlayerAni:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                    csb.animationChangeToAction(self.bigRewardPlayerAni, self.playerAnimationEnum.JUMP_RIGHT, self.playerAnimationEnum.JUMP_RIGHT, false)
                    break
                end
            end

            if isSpecialState == false then
                self.bigRewardMoveIdx = self.bigRewardMoveIdx + 1
                csb.animationChangeToAction(self.bigRewardPlayerAni, self.playerAnimationEnum.RUN_RIGHT, self.playerAnimationEnum.RUN_RIGHT, false)
                self:startBigRewardPlayMove()
            end
        end
    )))
end

-- 更改传送按钮的状态
function RichmanMain:changeClickEventState()
    local curPosIndex = self._userDataInfo.curPosIndex
    local gridType = self:getGridEventType(curPosIndex)
    for _, v in ipairs(self.gridUIList) do
        if v.transferButton ~= nil then
            v.transferButton:setTouchEnabled(gridType == self.envetTypeEnum.TRANSFER or self._userDataInfo.isTransfer == 1)
        end
    end
end

-- 传送到指定格子
function RichmanMain:transferGrid(index)
    local startPosIndex = self.startPosIndex
    local endPosIndex = self._userDataInfo.curPosIndex

    local startRolePosX = self.gridUIList[startPosIndex].bgImg:getPositionX()
    local startRolePosY = self.gridUIList[startPosIndex].bgImg:getPositionY()

    local endRolePosX = self.gridUIList[endPosIndex].bgImg:getPositionX()
    local endRolePosY = self.gridUIList[endPosIndex].bgImg:getPositionY()

    local dir = self.gridUIList[endPosIndex].dir
    
    -- 传送格子后触发神秘大奖
    if self._userDataInfo.isShowBigReward == true then
        self.isOnShowBigReward = true
        self.allTempLightRewardStopIdxs = self._userDataInfo.allLightRewardStopIdxs
    end

    local function changeActionCallbackThree(armatureBack)
        if armatureBack ~= nil then
            armatureBack._invoke = nil
            armatureBack:stopAllActions()
            armatureBack:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), 
                cc.CallFunc:create(function () 
                    armatureBack:setPosition(cc.p(endRolePosX, endRolePosY))
                    self:changeRoleDir(dir)
                    armatureBack:setVisible(true)
                    -- 绘制奖励
                    self:drawReward(false)
                    self:refreshDrawUI()
                end),
                cc.DelayTime:create(0.5),
                cc.CallFunc:create(function()
                    -- 传送后判断是否需要播放神秘大奖
                    if self.isOnShowBigReward == true then
                        state_machine.excute("richman_grand_slam_popup_window_open", 0, nil)
                    else
                        state_machine.excute("richman_main_unlock_state", 0, nil)
                    end
                end)
            ))
        end
    end

    local function changeActionCallbackTWo(armatureBack)
        if armatureBack then
            -- 移除消失光效动画
            armatureBack._invoke = nil
            armatureBack:removeFromParent(true)
            self.playerAni._invoke = changeActionCallbackThree
            csb.animationChangeToAction(self.playerAni, self.playerAnimationEnum.JUMP_RIGHT, self.playerAnimationEnum.STAND_RIGHT, true)
        end
    end

    local function changeActionCallbackOne(armatureBack)
        if armatureBack then
            -- 隐藏角色动画
            self.playerAni:setVisible(false)

            armatureBack._invoke = nil
            self:playRoleDisappearAni(self.Panel_role, cc.p(startRolePosX, startRolePosY), changeActionCallbackTWo)
        end
    end

    self.playerAni._invoke = changeActionCallbackOne
    self.playerAni:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(self.playerAni, self.playerAnimationEnum.JUMP_RIGHT, self.playerAnimationEnum.JUMP_RIGHT, false)
end

-- 刷新任务按钮上的红点
function RichmanMain:refreshTaskRedPoint()
    local isShow = getRichmanTaskRedState(187)
    self.Image_tips_point:setVisible(isShow)
end

-- 播放角色消失动画
function RichmanMain:playRoleDisappearAni(targetNode, pos, actionCallFunc)
    local jsonFile = "images/ui/effice/effect_monopoly_xiaoshi/effect_monopoly_xiaoshi.json"
    local atlasFile = "images/ui/effice/effect_monopoly_xiaoshi/effect_monopoly_xiaoshi.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, nil, false, nil)
    sp.initArmature(animation, false)
    animation.animationNameList = {"animation"}
    
    targetNode:addChild(animation)
    animation:setPosition(pos)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    animation._invoke = actionCallFunc
    csb.animationChangeToAction(animation, 0, 0, false)
end

function RichmanMain:onExit()
    state_machine.remove("richman_main_open")
    state_machine.remove("richman_main_close")
    state_machine.remove("richman_main_show")
    state_machine.remove("richman_main_hide")
    state_machine.remove("richman_main_rule_window_open")
    state_machine.remove("richman_main_taskview_open")
    state_machine.remove("richman_main_awardsview_open")
    state_machine.remove("richman_main_roll_dice")
    state_machine.remove("richman_main_diamond_purchase_dice")
    state_machine.remove("richman_main_choose_points_reward")
    state_machine.remove("richman_main_get_points_reward")
    state_machine.remove("richman_main_update_points_reward")
    state_machine.remove("richman_main_dice_get_access")
    state_machine.remove("richman_main_transfer_cell")
    state_machine.remove("richman_main_update_dice_numbers")
    state_machine.remove("richman_main_refresh_task_red_point")
    state_machine.remove("richman_main_lock_state")
    state_machine.remove("richman_main_unlock_state")
    state_machine.remove("richman_main_play_big_reward_animation")
    
end


function RichmanMain:close()
	-- window event : close.
	
end

function RichmanMain:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
