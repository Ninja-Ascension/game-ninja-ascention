-----------------------------
--活动
-----------------------------
Wonderful = class("WonderfulClass", Window)

local wonderful_window_open_terminal = {
    _name = "wonderful_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- 活动动画资源加载
        -- for i, v in pairs(config_res.sprites_cached["wonderful"]) do
            -- cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
        -- end
        if funOpenDrawTip(242) == true then
            return
        end 
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if _ED.activity_info ~= nil then
                    local activityWindow = fwin:find("WonderfulClass")
                    if nil == fwin:find("WonderfulClass") then
                        fwin:open(Wonderful:new():init(params), fwin._dview)
                    else
                        local root = activityWindow.roots[1]
                        root.__cwindow = activityWindow
                        Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

                        activityWindow:changeToActivity(params)
                        if params == nil then
                            params = _ED._activity_recording_id
                            state_machine.excute("wonderful_show_activity_by_type",0,{params})
                        end
                        activityWindow:setVisible(true)
                        activityWindow:resume()

                    end
                end
            end
        end

        responseCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 1})
        state_machine.excute("notification_center_update", 0, "push_notification_parts_activity_state")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local wonderful_window_close_terminal = {
    _name = "wonderful_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- fwin:close(fwin:find("WonderfulClass"))
        local activityWindow = fwin:find("WonderfulClass")
        if activityWindow ~= nil then
            activityWindow:setVisible(false)
            activityWindow:pause()
            fwin:unAllCovers(nil, false, activityWindow)
        end

        -- clear cacher
        -- cacher.clearWindowCacher()
        cacher.removeAllTextures()
        
        --外部活动刷新
        state_machine.excute("main_window_push_activity",0,0)
        state_machine.excute("main_window_update_userinfo", 0, nil)
        state_machine.excute("home_map_update_build", 0, nil)
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
        _ED.push_parts_activity_state = false
        state_machine.excute("notification_center_update", 0, "push_notification_parts_activity_state")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local wonderful_window_loading_terminal = {
    _name = "wonderful_window_loading",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activityWindow = fwin:find("WonderfulClass")
        if activityWindow == nil then
            activityWindow = Wonderful:new():init(params)
            fwin:open(activityWindow, fwin._dview)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local wonderful_window_hide_terminal = {
    _name = "wonderful_window_hide",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activityWindow = fwin:find("WonderfulClass")
        if activityWindow ~= nil then
            activityWindow:setVisible(false)
            activityWindow:pause()
        end
        --外部活动刷新
        state_machine.excute("main_window_push_activity",0,0)
        state_machine.excute("main_window_update_userinfo", 0, nil)
        state_machine.excute("home_map_update_build", 0, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(wonderful_window_open_terminal)
state_machine.add(wonderful_window_close_terminal)
-- state_machine.add(wonderful_window_loading_terminal)
-- state_machine.add(wonderful_window_hide_terminal)
state_machine.init()

function Wonderful:ctor()
    self.super:ctor()
    self.roots = {}

    -- var 活动数据
    self._activity_datas = {}
    -- 活动界面
    self._activity_panle = {}
    --左侧列表table
    self._activity_left_cells = {}
	
	self.params = nil
    
    --load lua file
    app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_active_left_cell")
	app.load("client.red_alert_time.cells.props.props_icon_cell")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeExchangeReward")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeReceiveEnergy")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeOnlineReward")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeGrowthPlan")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeFirstCharge")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeTroopsAssembled")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeBaseLevel")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeRechargeRedBag")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeAchievementsReached")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeLegionSeries")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeLevelingVip")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeGeneralsRecruited")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeLeaderRecruit")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimePartsSupply")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeRedEnvelopes")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimePrivilegeChest")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeSevenDayRecruit")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeTreasureQuest")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeActivityRanking")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeActivityActUpScientific")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeActivityFirstRecharge")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeActivityInsaneMiner")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeActivityThreeDayRecharge")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeActivityConsumeBackGoods")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeMonthCard")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeGiftPacks")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeTankExchange")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeRankActivity")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeLeaderRecruitActivity")
    -- Initialize wonderful state machine.
    local function init_wonderful_terminal()
	
		--切换活动
		local wonderful_show_activity_by_type_terminal = {
            _name = "wonderful_show_activity_by_type",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local activity_type = params[1]
                instance:changeActivityShow(activity_type)
                state_machine.excute("red_alert_time_wonderful_update_push", 0, activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --取消选中标记
        local wonderful_set_un_select_terminal = {
            _name = "wonderful_set_un_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setUnSelcet()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --移除活动页
        local wonderful_remove_page_terminal = {
            _name = "wonderful_remove_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:removeActivityPage(params[1])
                instance:removeActivityPanel(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新背景
        local wonderful_update_by_terminal = {
            _name = "wonderful_update_by",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateBy(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --移动列表层的坐标
        local wonderful_move_list_view_position_terminal = {
            _name = "wonderful_move_list_view_position",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:moveListViewPosition(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新首充列表
        local red_alert_time_wonderful_update_first_terminal = {
            _name = "red_alert_time_wonderful_update_first",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    for i,cell in pairs(instance._activity_left_cells) do
                        if cell ~= nil and cell.roots ~= nil and cell.roots[1] ~= nil then
                            if tonumber(cell._activity_type) == tonumber(params) then
                                state_machine.excute("wonderful_remove_page", 0, {tonumber(params)})
                                state_machine.excute("main_window_remove_list_button", 0, tonumber(params))
                                -- state_machine.excute("red_alert_time_active_left_cell_update_draw", 0, cell)
                            end
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新新活动
        local red_alert_time_wonderful_update_new_activity_terminal = {
            _name = "red_alert_time_wonderful_update_new_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i,v in pairs(_ED.activity_info) do
                    if v ~= nil then
                        local activity_type = tonumber(v.activity_type)
                        if activity_type == 4           -- 疯狂关卡
                        or activity_type == 13          --
                        or activity_type == 17          --天天限购
                        or activity_type == 79          --连续7天充值
                        or activity_type == 34          --采集福利
                        or activity_type == 8           --招募将领
                        or activity_type == 45          --充值红包
                        or activity_type == 47          --在线奖励
                        or activity_type == 2           -- 首充豪礼
                        or activity_type == 50          -- 基地冲级
                        or activity_type == 51          -- 军团冲级
                        or activity_type == 52          -- 战力冲榜
                        or activity_type == 53          -- 关卡排行
                        or activity_type == 54            -- 部队集结
                        or activity_type == 55            -- 开服限购
                        or activity_type == 108            -- 军事培训
                        or activity_type == 109            -- 有趣道具
                        or activity_type == 56            -- 沙漠之鹰
                        or activity_type == 60            -- 秘宝探险
                        or activity_type == 62            -- 战地风云
                        or activity_type == 61            -- 红包大派送
                        or activity_type == 63            -- 全服冲v
                        or activity_type == 64            -- 特权宝箱
                        or activity_type == 65            -- 配件补给
                        or activity_type == 66            -- 军团战力
                        or activity_type == 68            -- 配件进化
                        or activity_type == 69            -- 军团募集
                        or activity_type == 70            -- 改造风暴
                        or activity_type == 72            -- 采集福利
                        or activity_type == 73            -- 军团副本
                        or activity_type == 74            -- 战火纷飞
                        or activity_type == 76            -- 捐献优惠
                        or activity_type == 77            -- 硝烟弥漫
                        or activity_type == 106            -- 全面发展
                        or activity_type == 107            -- 完美伪装
                        or activity_type == 41            -- 首冲返利
                        or activity_type == 80            -- 充值福利
                        or activity_type == 32            -- 每日单笔
                        or activity_type == 12            -- 累计充值
                        or activity_type == 84            -- 全民狂欢
                        or activity_type == 85            -- 科技飙升
                        or activity_type == 86            -- 军备竞赛
                        or activity_type == 87            -- 疯狂矿工
                        or activity_type == 88            -- 活动达人
                        or activity_type == 89            -- 连续小充
                        or activity_type == 90            -- 将领进阶
                        or activity_type == 91            -- 火线支援
                        or activity_type == 92            -- 首次充值
                        or activity_type == 93            -- 同心协力
                        or activity_type == 94            -- 将领进化
                        or activity_type == 95            -- 消费返利
                        or activity_type == 110            -- 加速礼包
                        or activity_type == 111           -- 兵种兑换
                        or activity_type == 112           -- 开服礼包
                        or activity_type == 113
                        or activity_type == 114
                        or activity_type == 115
                        or activity_type == 116
                        or activity_type == 120           -- 充值排行
                        or activity_type == 121           -- 英雄招募
                        or activity_type == 122           -- 幸运抽奖
                        or activity_type == 123           -- 消费排行
                        or activity_type == 124           -- 装甲生产
                        or activity_type == 125           -- 累计消费
                        then
                            local isUpdate = true
                            for j,w in pairs(self._activity_datas) do
                                if tonumber(w.activity_type) == activity_type then
                                    isUpdate = false
                                end
                            end
                            if _ED.activity_info[""..activity_type] ~= nil and isUpdate == true then
                                self._activity_left_cells = {}
                                self:initActivityDatas()
                                self:onUpdateDraw()
                                return
                            end
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_wonderful_update_push_terminal = {
            _name = "red_alert_time_wonderful_update_push",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    for i,cell in pairs(instance._activity_left_cells) do
                        if cell ~= nil and cell.roots ~= nil and cell.roots[1] ~= nil then
                            if tonumber(cell._activity_type) == tonumber(params) then
                                state_machine.excute("red_alert_time_active_left_cell_update_push", 0, cell)
                                break
                            end
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(wonderful_show_activity_by_type_terminal)	
        state_machine.add(wonderful_set_un_select_terminal)
        state_machine.add(wonderful_remove_page_terminal)
        state_machine.add(wonderful_update_by_terminal)
        state_machine.add(wonderful_move_list_view_position_terminal)
        state_machine.add(red_alert_time_wonderful_update_first_terminal)
        state_machine.add(red_alert_time_wonderful_update_new_activity_terminal)
        state_machine.add(red_alert_time_wonderful_update_push_terminal)
        state_machine.init()
    end
    
    -- call func init sign_in state machine.
    init_wonderful_terminal()
end

function Wonderful:setUnSelcet()
    for i,cell in pairs(self._activity_left_cells) do
        if cell ~= nil and cell.setSelect ~= nil then
            cell._select = false
            cell:setSelect()
        end
    end
end

function Wonderful:changeActivityShow(activity_type)
    local activity_panel = self:createPanelBy(activity_type)
end

function Wonderful:moveListViewPosition(params)
    local root = self.roots[1]
    local move_x = params[1]
    local move_y = params[2]
    local ListView_wonderful_label = ccui.Helper:seekWidgetByName(root,"ListView_wonderful_label")
    -- ListView_wonderful_label:scrollToPercentBothDirection(cc.p(move_x,move_y),0.5,true)
    ListView_wonderful_label:getInnerContainer():setPosition(cc.p(move_x,move_y))
end

--刷新背景
function Wonderful:onUpdateBy(activity_type)
    local root = self.roots[1]
    
end

function Wonderful:createPanelBy(activity_type)
    local root = self.roots[1]
    local Panel_wonderful_page = ccui.Helper:seekWidgetByName(root,"Panel_activity_tab_box")
	Panel_wonderful_page:removeAllChildren(true)
    _ED._activity_recording_id = activity_type
    local activity_panel = nil
    if activity_type == 1 then      -- 月卡
        activity_panel = state_machine.excute("red_alert_time_month_card_open",0,{Panel_wonderful_page,activity_type})
    elseif activity_type == 2 then  -- 首冲
        activity_panel = state_machine.excute("red_alert_time_first_charge_open",0,{Panel_wonderful_page,activity_type})
	elseif activity_type == 4 then  -- 疯狂关卡
        activity_panel = state_machine.excute("red_alert_time_achievements_reached_window_open",0,{Panel_wonderful_page,activity_type})
	elseif activity_type == 8 then  -- 将领招募
        activity_panel = state_machine.excute("red_alert_time_leader_recruit_window_open",0,{Panel_wonderful_page,activity_type})	
	elseif activity_type == 79 then  -- 连续7天充值
        activity_panel = state_machine.excute("red_alert_time_seven_day_recruit_window_open",0,{Panel_wonderful_page,activity_type})		
	elseif activity_type == 54 or activity_type == 55 or activity_type == 108 or activity_type == 109 or activity_type == 17 or activity_type == 70 
        or activity_type == 77 or activity_type == 106 or activity_type == 107 or activity_type == 94 or activity_type == 110
        then -- 部队集结
        activity_panel = state_machine.excute("red_alert_time_troops_assembled_window_open",0,{Panel_wonderful_page,activity_type})
	elseif activity_type == 47 then -- 在线奖励
		activity_panel = state_machine.excute("red_alert_time_online_reward_window_open",0,{Panel_wonderful_page,activity_type})
	elseif activity_type == 50 then  -- 基地冲级
        activity_panel = state_machine.excute("red_alert_time_base_level_window_open",0,{Panel_wonderful_page,activity_type})	
    elseif activity_type == 9 then  -- 成长计划VIP2
        activity_panel = state_machine.excute("red_alert_time_growth_plan_window_open",0,{Panel_wonderful_page,activity_type})
    elseif activity_type == 16 then -- cdkey
        activity_panel = state_machine.excute("red_alert_time_exchange_reward_window_open",0,{Panel_wonderful_page,activity_type})
    elseif activity_type == 45 or activity_type == 41 or activity_type == 80 
        or activity_type == 90 or activity_type == 32 or activity_type == 12 then --充值红包,首冲返利，充值福利,将领进阶
        activity_panel = state_machine.excute("red_alert_time_recharge_red_bag_window_open",0,{Panel_wonderful_page,activity_type})
	elseif activity_type == 51 then --军团冲级
        activity_panel = state_machine.excute("red_alert_time_legion_series_window_open",0,{Panel_wonderful_page,activity_type})
	elseif activity_type == 73 then --军团副本
        activity_panel = state_machine.excute("red_alert_time_legion_series_window_open",0,{Panel_wonderful_page,activity_type})		
	elseif activity_type == 53 then --关卡排行
        activity_panel = state_machine.excute("red_alert_time_achievements_reached_window_open",0,{Panel_wonderful_page,activity_type})
	elseif activity_type == 52 then --战力冲榜
        activity_panel = state_machine.excute("red_alert_time_achievements_reached_window_open",0,{Panel_wonderful_page,activity_type})
	elseif activity_type == 56 then --沙漠之鹰
        activity_panel = state_machine.excute("red_alert_time_achievements_reached_window_open",0,{Panel_wonderful_page,activity_type})	
	elseif activity_type == 59 then -- 领取能量
		activity_panel = state_machine.excute("red_alert_time_receive_rnergy_window_open",0,{Panel_wonderful_page,activity_type})
	elseif activity_type == 60 then -- 秘宝探险
		activity_panel = state_machine.excute("red_alert_time_treasure_quest_window_open",0,{Panel_wonderful_page,activity_type})
	elseif activity_type == 61 then -- 红包大派送
		activity_panel = state_machine.excute("red_alert_time_red_rnvelopes_window_open",0,{Panel_wonderful_page,activity_type})	
	elseif activity_type == 62 then -- 战地风云
		activity_panel = state_machine.excute("red_alert_time_achievements_reached_window_open",0,{Panel_wonderful_page,activity_type})	
	elseif activity_type == 63 then -- 全服冲v
		activity_panel = state_machine.excute("red_alert_time_leveling_vip_window_open",0,{Panel_wonderful_page,activity_type})	
	elseif activity_type == 64 then -- 特权宝箱
		activity_panel = state_machine.excute("red_alert_time_privilege_chest_window_open",0,{Panel_wonderful_page,activity_type})		
	elseif activity_type == 65 then -- 配件补给
		activity_panel = state_machine.excute("red_alert_time_parts_supply_window_open",0,{Panel_wonderful_page,activity_type})		
	elseif activity_type == 66 then -- 军团战力
		activity_panel = state_machine.excute("red_alert_time_legion_series_window_open",0,{Panel_wonderful_page,activity_type})
	elseif activity_type == 68 then  -- 配件进化
        activity_panel = state_machine.excute("red_alert_time_generals_recruited_window_open",0,{Panel_wonderful_page,activity_type})		
	elseif activity_type == 69 then -- 军团募集
		activity_panel = state_machine.excute("red_alert_time_legion_series_window_open",0,{Panel_wonderful_page,activity_type})			
	elseif activity_type == 72 then -- 采集福利
		activity_panel = state_machine.excute("red_alert_time_achievements_reached_window_open",0,{Panel_wonderful_page,activity_type})	
	elseif activity_type == 74 then -- 战火纷飞
		activity_panel = state_machine.excute("red_alert_time_achievements_reached_window_open",0,{Panel_wonderful_page,activity_type})	
	elseif activity_type == 76 then -- 捐献优惠
		activity_panel = state_machine.excute("red_alert_time_achievements_reached_window_open",0,{Panel_wonderful_page,activity_type})
    elseif activity_type == 84 then -- 全民狂欢
        activity_panel = state_machine.excute("red_alert_time_online_reward_window_open",0,{Panel_wonderful_page,activity_type})
    elseif activity_type == 85 then -- 科技飙升
        activity_panel = state_machine.excute("red_alert_time_act_up_scientific_window_open",0,{Panel_wonderful_page,activity_type})
    elseif activity_type == 86 then -- 军备竞赛
        activity_panel = state_machine.excute("red_alert_time_leveling_vip_window_open",0,{Panel_wonderful_page,activity_type})
    elseif activity_type == 87 then -- 疯狂矿工
        activity_panel = state_machine.excute("red_alert_time_insane_miner_window_open",0,{Panel_wonderful_page,activity_type})  
    elseif activity_type == 88 then -- 活动达人
        activity_panel = state_machine.excute("red_alert_time_online_reward_window_open",0,{Panel_wonderful_page,activity_type})
    elseif activity_type == 89 then -- 连续小充
        activity_panel = state_machine.excute("red_alert_time_three_day_recharge_window_open",0,{Panel_wonderful_page,activity_type})
    elseif activity_type == 91 then -- 火线支援
        activity_panel = state_machine.excute("red_alert_time_online_reward_window_open",0,{Panel_wonderful_page,activity_type})
    elseif activity_type == 92 then -- 首次充值
        activity_panel = state_machine.excute("red_alert_time_first_recharge_window_open",0,{Panel_wonderful_page,activity_type})    
    elseif activity_type == 93 then --同心协力
        activity_panel = state_machine.excute("red_alert_time_legion_series_window_open",0,{Panel_wonderful_page,activity_type})
    elseif activity_type == 95 or activity_type == 125 then --消费返利
        activity_panel = state_machine.excute("red_alert_time_consume_back_goods_window_open",0,{Panel_wonderful_page,activity_type})	
    elseif activity_type == 111 then --坦克兑换
        activity_panel = state_machine.excute("red_alert_time_tank_exchange_window_open",0,{Panel_wonderful_page,activity_type})   	
    elseif activity_type >= 112 and activity_type <= 116 then --开服礼包
        activity_panel = state_machine.excute("red_alert_time_gift_packs_window_open",0,{Panel_wonderful_page,activity_type})   
     elseif activity_type == 120    --充值排行
        or activity_type == 123     -- 消费排行
        then 
        activity_panel = state_machine.excute("red_alert_time_rank_activity_window_open",0,{Panel_wonderful_page,activity_type})   	
    elseif activity_type == 121           -- 英雄招募
        or activity_type == 122           -- 幸运抽奖
        or activity_type == 124           
        then
        activity_panel = state_machine.excute("red_alert_time_leader_recruit_activity_window_open",0,{Panel_wonderful_page,activity_type}) 
    end
    -- self._activity_panle[""..activity_type] = activity_panel
end

function Wonderful:removeActivityPanel(activity_type)
    
end

function Wonderful:removeActivityPage(activity_type)
    local root = self.roots[1]
    local ListView_wonderful_label = ccui.Helper:seekWidgetByName(root,"ListView_activity_tab_button")
    for i,cell in pairs(self._activity_left_cells) do
        if tonumber(cell._activity_type) == tonumber(activity_type) then
            table.remove(self._activity_left_cells,i)
            ListView_wonderful_label:removeItem(ListView_wonderful_label:getIndex(cell))
            break
        end
    end
    for k,v in pairs(self._activity_datas) do
        if zstring.tonumber(v.activity_type) == zstring.tonumber(activity_type) then
            table.remove(self._activity_datas, k)
            break
        end
    end
    _ED.activity_info[""..activity_type] = nil
    if tonumber(activity_type) == 68 then--刷新配件进化活动加层
        state_machine.excute("equipment_strengthen_tab_update_activity_add_draw",0,"")
        state_machine.excute("equipment_reform_tab_update_activity_add_draw",0,"")
    end
    if tonumber(activity_type) == 85 then--刷新科技升级状态
        state_machine.excute("build_up_scientific_to_update_draw",0,"")
        state_machine.excute("build_up_scientific_info_update_draw",0,"")
        state_machine.excute("build_up_scientific_up_update_draw",0,"")
    end
    if tonumber(activity_type) == 91 then--刷新攻击或重置次数
        state_machine.excute("expedition_update_draw",0,"") --远征
        state_machine.excute("pve_parts_supply_tab_activity_end_updata",0,"")--配件
        state_machine.excute("arena_dearon_tab_update", 0, "") --竞技场
    end
    ListView_wonderful_label:requestRefreshView()
    state_machine.excute("red_alert_time_active_left_cell_click",0,{_datas = { cell = self._activity_left_cells[1]}})
end

function Wonderful:onUpdateDraw()
    local root = self.roots[1]
    local ListView_wonderful_label = ccui.Helper:seekWidgetByName(root,"ListView_activity_tab_button")
    ListView_wonderful_label:removeAllItems()

    local index = 1
    for i,v in pairs(self._activity_datas) do
        local cell = state_machine.excute("red_alert_time_active_left_create_cell",0,{v.activity_type,index})
        ListView_wonderful_label:addChild(cell)
        -- if index == 1 then
            -- state_machine.excute("red_alert_time_active_left_cell_click",0,{_datas = { cell = cell}})
        -- end
        table.insert(self._activity_left_cells,cell)
        index = index + 1
    end
    ListView_wonderful_label:requestRefreshView()
	if self.params == nil then
		for i,cell in pairs(self._activity_left_cells) do
			if cell ~= nil and cell.setSelect ~= nil then
				cell._select = false
				cell:setSelect()
			end
		end	
		state_machine.excute("wonderful_set_un_select",0,"")
		state_machine.excute("red_alert_time_active_left_cell_click",0,{_datas = { cell = self._activity_left_cells[1]}})
	end

    self._list_view = ListView_wonderful_label
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

-- function Wonderful:onUpdate(dt)
--     if self._list_view ~= nil then
--         local size = self._list_view:getContentSize()
--         local posY = self._list_view:getInnerContainer():getPositionY()
--         if self._list_view_poy == posY then
--             return
--         end
--         self._list_view_poy = posY
--         local items = self._list_view:getItems()
--         if items[1] == nil then
--             return
--         end
--         local itemSize = items[1]:getContentSize()
--         for i, v in pairs(items) do
--             local tempY = v:getPositionY() + posY
--             if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
--                 v:unload()
--             else
--                 v:reload()
--             end
--         end
--     end
-- end

function Wonderful:onEnterTransitionFinish()
    
end

function Wonderful:onInit()
    local csbItem = csb.createNode(config_csb.activity.activity)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
	
    self.__check_covers = true
    root.__cwindow = self
	Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
	
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_activity_close"), nil, 
    {
        terminal_name = "wonderful_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	
	self:onUpdateDraw()
end

function Wonderful:initActivityDatas()
    self._activity_datas = {}
    for i,v in pairs(_ED.activity_info) do
        if v ~= nil then
            local activity_type = tonumber(v.activity_type)
    		-- print(v.activity_type,v.activity_title)
    		if activity_type == 7 then          -- 7日与每日签到
            elseif activity_type == 1 then         -- 月卡
            elseif activity_type == 83 then         -- 
            elseif activity_type == 18 then         -- 战地机甲
            elseif activity_type == 19 then         -- 密宝探寻
            elseif activity_type == 81 then         -- 消费转盘
            elseif activity_type == 23 then         -- 特权礼包
            elseif activity_type == 26 then         -- 军团战力
            elseif activity_type == 27 then         -- 
            elseif activity_type == 28 then         -- 科威特的秘密
            elseif activity_type == 29 then         -- 疯狂关卡
            elseif activity_type == 30 then         -- 改造风暴
            elseif activity_type == 82 then         -- 
            -- elseif activity_type == 79 then         -- 连续充值
            elseif activity_type == 37 then         -- 消费转盘
            elseif activity_type == 39 then         -- 
            elseif activity_type == 40 then         -- 限时目标奖励
            elseif activity_type == 42 then         -- 捐献优惠
            elseif activity_type == 46 then         -- 幸运抽奖
            elseif activity_type == 48 then         -- 总部援军
            elseif activity_type == 49 then         -- 
            elseif activity_type == 57 then         -- 兄弟同享
            elseif activity_type == 58 then         -- 战地机甲
            elseif activity_type == 59 then         -- 领取能量
            elseif activity_type == 67 then         -- 科威特的秘密
            elseif activity_type == 71 then         -- 装甲猛兽
            elseif activity_type == 104 then         -- 极限洪流
            elseif activity_type == 105 then         -- 雷霆风暴
            elseif activity_type == 75 then         -- 沙漠熊狮
            elseif activity_type == 78 then         -- 军资集结
            elseif activity_type == 96 then         -- 清盘计划
            elseif activity_type == 97 then         -- 摧枯拉朽
            elseif activity_type == 98 then         -- 消消乐
            elseif activity_type == 99 then         -- 火线将领
            elseif activity_type == 101 then         -- 军事讲坛
            elseif activity_type == 102 then         -- 坦克拉霸
            elseif activity_type == 103 then         -- 折扣卖场
            -- elseif activity_type == 8 then         -- 将领招募
            -- elseif activity_type == 9 or activity_type == 24 or activity_type == 25 then
            elseif activity_type == 9  then			--成长计划
                local index = 0 
                local activity_data = _ED.activity_info[""..v.activity_type].activity_data[2]
    			-- v.value = dms.int(dms["activity_param"],v.activity_type,activity_param.types)
    			-- table.insert(self._activity_datas,v)
                for k,v in pairs(activity_data) do
                    if tonumber(v.achieve_state) == 2 then 
                        index = index + 1 
                    end
                end 
    			
                if index == #activity_data then

                else
    				
                    v.value = dms.int(dms["activity_param"],v.activity_type,activity_param.types)
                    table.insert(self._activity_datas,v)
                end
            elseif activity_type == 4           -- 疯狂关卡
    			or activity_type == 13 			--
    			or activity_type == 17 			--天天限购
                -- or activity_type == 27			--
                -- or activity_type == 82			--诺曼的馈赠
                or activity_type == 79			--连续7天充值
                or activity_type == 34			--采集福利
                or activity_type == 8			--招募将领
                or activity_type == 45			--充值红包
                -- or activity_type == 47			--在线奖励
    			or activity_type == 2           -- 首充豪礼
    			or activity_type == 50          -- 基地冲级
    			or activity_type == 51          -- 军团冲级
    			or activity_type == 52          -- 战力冲榜
    			or activity_type == 53          -- 关卡排行
    			or activity_type == 54            -- 部队集结
    			or activity_type == 55            -- 开服限购
                or activity_type == 108            -- 军事培训
                or activity_type == 109            -- 有趣道具
    			or activity_type == 56            -- 沙漠之鹰
    			or activity_type == 60         	  -- 秘宝探险
    			or activity_type == 62            -- 战地风云
    			or activity_type == 61            -- 红包大派送
    			or activity_type == 63            -- 全服冲v
    			or activity_type == 64            -- 特权宝箱
    			or activity_type == 65            -- 配件补给
    			or activity_type == 66            -- 军团战力
    			or activity_type == 68            -- 配件进化
    			or activity_type == 69            -- 军团募集
    			or activity_type == 70            -- 改造风暴
    			or activity_type == 72            -- 采集福利
    			or activity_type == 73            -- 军团副本
    			or activity_type == 74            -- 战火纷飞
    			or activity_type == 76            -- 捐献优惠
                or activity_type == 77            -- 硝烟弥漫
                or activity_type == 106           -- 全面发展
                or activity_type == 107           -- 完美伪装
    			or activity_type == 41            -- 首冲充值
                or activity_type == 80            -- 充值福利
                or activity_type == 32            -- 每日单笔
                or activity_type == 12            -- 累计充值
                or activity_type == 84            -- 全民狂欢
                or activity_type == 85            -- 科技飙升
                or activity_type == 86            -- 军备竞赛
                or activity_type == 87            -- 疯狂矿工
                or activity_type == 88            -- 活动达人
                or activity_type == 89            -- 连续小充
                or activity_type == 90            -- 将领进阶
                or activity_type == 91            -- 火线支援
                or activity_type == 92            -- 首次充值
                or activity_type == 93            -- 同心协力
                or activity_type == 94            -- 将领进化
                or activity_type == 95            -- 消费返利
                or activity_type == 110            -- 加速礼包
                or activity_type == 111           -- 兵种兑换
                or (activity_type >= 112 and activity_type <= 116)  -- 开服礼包
                or activity_type == 120           -- 充值排行
                or activity_type == 121           -- 英雄招募
                or activity_type == 122           -- 幸运抽奖
                or activity_type == 123           -- 消费排行
                or activity_type == 124           -- 装甲生产
                or activity_type == 125            -- 累计消费
                then
                local index = 0 
                local activity_data = _ED.activity_info[""..v.activity_type].activity_data[1]
    			v.value = dms.int(dms["activity_param"],v.activity_type,activity_param.types)
    			table.insert(self._activity_datas,v)
                -- for k,v in pairs(activity_data) do
                    -- if tonumber(v.achieve_state) == 2 then 
                        -- index = index + 1 
                    -- end
                -- end 
                -- if index == #activity_data then
                -- else
                    -- v.value = dms.int(dms["activity_param"],v.activity_type,activity_param.types)
                    -- table.insert(self._activity_datas,v)
                -- end
    		elseif activity_type == 47 then			--在线奖励
    			local index = 0 
                local activity_data = _ED.activity_info[""..v.activity_type].activity_data[1]
    			for k,v in pairs(activity_data) do
                    if tonumber(v.achieve_state) == 2 then 
                        index = index + 1 
                    end
                end 
                if index == #activity_data then
                else
                    v.value = dms.int(dms["activity_param"],v.activity_type,activity_param.types)
                    table.insert(self._activity_datas,v)
                end
            else
                v.value = dms.int(dms["activity_param"],v.activity_type,activity_param.types)
                -- 常驻活动
                if v.value >= 10000 and v.value < 20000 then
                    table.insert(self._activity_datas,v)
                end
            end
        end
    end
    if nil ~= _ED.server_review and zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
        -- local card_data = {
            -- activity_type = "1",
            -- value = dms.int(dms["activity_param"],1,activity_param.types),
        -- }

        local cdkey_code_data = {
            activity_type = "16",					--礼包兑换
            value = dms.int(dms["activity_param"],16,activity_param.types),
        }

        -- if _ED.user_open_server_recharge_rebate_info ~= nil
            -- and _ED.user_open_server_recharge_rebate_info.recharge_money ~= nil 
            -- and _ED.user_open_server_recharge_rebate_info.vip_exp ~= nil 
            -- then
            -- local activity_type = 1001
            -- local index_type = 0
            -- for i,v in pairs(dms["activity_param"]) do
                -- if dms.int(dms["activity_param"],i,activity_param.id) == activity_type then
                    -- index_type = dms.int(dms["activity_param"],i,activity_param.types)
                    -- break
                -- end
            -- end
            -- local register_data = {
                -- activity_type = ""..activity_type,
                -- value = index_type,
            -- }
            -- table.insert(self._activity_datas,register_data) 
        -- end
		
		local receive_energy_data = {
			activity_type = "59",
			value = dms.int(dms["activity_param"],59,activity_param.types),
		}

        local month_card_data = {
            activity_type = "1",
            value = dms.int(dms["activity_param"],1,activity_param.types),
        }
		
        table.insert(self._activity_datas,receive_energy_data)           --领取能量
		
        table.insert(self._activity_datas,cdkey_code_data)           --cdkey

        table.insert(self._activity_datas,month_card_data)           --月卡
    end
    -- for i,v in pairs(self._activity_datas) do
    --     local id =  v.activity_type
    --     v.value = dms.int(dms["activity_param"],id,activity_param.types)
    -- end

    local function sortTable( a, b )
        return tonumber(a.value) < tonumber(b.value)
    end

    table.sort(self._activity_datas,sortTable)
end

function Wonderful:changeToActivity( params )
    if params ~= nil then
        for i,cell in pairs(self._activity_left_cells) do
            if cell ~= nil and cell.setSelect ~= nil then
                cell._select = false
                cell:setSelect()
            end
            
            if tonumber(cell._activity_type) == tonumber(params) then
                state_machine.excute("wonderful_set_un_select",0,"")
                state_machine.excute("red_alert_time_active_left_cell_click",0,{_datas = { cell = cell}})
                -- cell._select = true
                -- cell:setSelect()
                
            end
        end
        -- state_machine.excute("wonderful_show_activity_by_type",0,{params})
        -- state_machine.excute("wonderful_update_by",0,{params})
    end
end

function Wonderful:init(params)
	self.params = params
    self:setTouchEnabled(true)
    self:initActivityDatas()
    self:onInit()
    self:changeToActivity(params)
    return self
end

function Wonderful:onExit()
    if _ED.system_time ~= nil then
        state_machine.excute("main_window_update_userinfo", 0, nil)
        state_machine.excute("home_map_update_build", 0, nil)
    end
    state_machine.remove("wonderful_show_activity_by_type")
    state_machine.remove("wonderful_set_un_select")
    state_machine.remove("wonderful_remove_page")
    state_machine.remove("wonderful_update_by")
    state_machine.remove("wonderful_move_list_view_position")
    state_machine.remove("red_alert_time_wonderful_update_first")
    state_machine.remove("red_alert_time_wonderful_update_new_activity")
    state_machine.remove("red_alert_time_wonderful_update_push")
end
