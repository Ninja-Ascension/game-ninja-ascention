-- ------------------------------------------------------------------------------------------------------------
--  说明：守卫战
-- ------------------------------------------------------------------------------------------------------------
GuardBattle = class("GuardBattleClass", Window)

--打开界面
local guard_battle_window_open_terminal = {
    _name = "guard_battle_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(155) == true then
            return
        end
        if _ED.union.union_info == nil 
                or _ED.union.union_info == {} 
                or _ED.union.union_info.union_id == nil 
                or _ED.union.union_info.union_id == "" 
                or tonumber(_ED.union.union_info.union_id) == 0 
                then
            TipDlg.drawTextDailog(red_alert_time_str[158])
            return
        end  
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("GuardBattleClass") == nil then
                    fwin:open(GuardBattle:new():init(), fwin._ui)
                end
            end
        end
        protocol_command.guard_stronghold_init.param_list = ""
        NetworkManager:register(protocol_command.guard_stronghold_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local guard_battle_window_close_terminal = {
    _name = "guard_battle_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GuardBattleClass"))
        protocol_command.guard_exit.param_list = ""
        NetworkManager:register(protocol_command.guard_exit.code, nil, nil, nil, nil, nil, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(guard_battle_window_open_terminal)
state_machine.add(guard_battle_window_close_terminal)
state_machine.init()

function GuardBattle:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._is_open = false
    self._text_time = nil

    self._last_state = 0
    self._end_time = 0

    self._reconnect_count = 0
    self._reconnect_time = 0

    self._last_contribution = 0
    self._min_rank = 0              -- 有参数资格最小排名

    app.load("client.red_alert_time.campaign.GuardBattleGain")
    app.load("client.red_alert_time.campaign.GuardBattleRank")
    app.load("client.red_alert_time.campaign.GuardBattleRankListview")
    app.load("client.red_alert_time.campaign.GuardBattleRankReward")
    app.load("client.red_alert_time.campaign.GuardBattleRecord")
    app.load("client.red_alert_time.campaign.GuardBattleRecordListview")
    app.load("client.red_alert_time.campaign.GuardBattleGuardList")
    app.load("client.red_alert_time.campaign.GuardBattlePkAttack")
    app.load("client.red_alert_time.campaign.ExpeditionRuleInfor")

    app.load("client.red_alert_time.cells.campaign.guard_battle_gain_cell")
    app.load("client.red_alert_time.cells.campaign.guard_battle_rank_cell")
    app.load("client.red_alert_time.cells.campaign.guard_battle_guard_list_cell")
    app.load("client.red_alert_time.cells.campaign.guard_battle_rank_reward_cell")

    app.load("client.red_alert_time.legion.LegionChatsView")
    
    local function init_guard_battle_terminal()
        local guard_battle_show_info_terminal = {
            _name = "guard_battle_show_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("expedition_rule_infor_window_open",0,13)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_click_stronghold_terminal = {
            _name = "guard_battle_click_stronghold",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._is_open == true and tonumber(_ED.guard_battle_user_info.hegemony_rank) <= instance._min_rank then
                    state_machine.excute("guard_battle_guard_list_window_open", 0, "")
                else
                    state_machine.excute("guard_battle_record_window_open", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_buy_gain_terminal = {
            _name = "guard_battle_buy_gain",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._is_open == true then
                    if tonumber(_ED.guard_battle_user_info.hegemony_rank) <= instance._min_rank then
                        state_machine.excute("guard_battle_gain_window_open", 0, "")
                    else
                        TipDlg.drawTextDailog(tipStringInfo_campaign_info[57])
                    end
                else
                    TipDlg.drawTextDailog(red_alert_time_str[170])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_update_user_info_terminal = {
            _name = "guard_battle_update_user_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateUserInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_update_stronghold_info_terminal = {
            _name = "guard_battle_update_stronghold_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdatestronghold()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_update_state_terminal = {
            _name = "guard_battle_update_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local current_state = tonumber(params[1])
                if instance._last_state ~= current_state then
                    if instance._last_state == 0 then           -- 守卫战开启，清除上一次战报数据
                        state_machine.excute("guard_battle_record_update_all", 0, "")
                    elseif instance._last_state == 2 and current_state == 0 then        -- 守卫战结束
                        state_machine.excute("guard_battle_guard_list_window_close", 0, "")
                        state_machine.excute("guard_battle_pk_attack_close", 0, "")
                        state_machine.excute("guard_battle_gain_window_close", 0, "")
                        state_machine.excute("guard_battle_record_show_result_info", 0, "")
                    end
                    instance:onUpdateDraw()
                end
                instance._last_state = current_state
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求初始化
        local guard_battle_request_init_terminal = {
            _name = "guard_battle_request_init",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            -- response.node:onUpdateDraw()
                            state_machine.excute("guard_battle_update_state", 0, {tonumber(_ED.guard_battle_stronghold_info.state)})
                        end
                    end
                end
                protocol_command.guard_stronghold_init.param_list = ""
                NetworkManager:register(protocol_command.guard_stronghold_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示战斗结果信息
        local guard_battle_show_battle_result_terminal = {
            _name = "guard_battle_show_battle_result",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.guard_battle_user_info.battle_type) > 0 and tonumber(_ED.guard_battle_user_info.hegemony_rank) <= instance._min_rank then
                    TipDlg.drawTextDailog(string.format(tipStringInfo_campaign_info[58], tonumber(_ED.guard_battle_user_info.fight_count)))
                end
                _ED.show_reward_list_group_ex = _ED.show_reward_list_group_ex or {}
                local current_contribution = tonumber(_ED.guard_battle_user_info.contribution)
                if current_contribution > instance._last_contribution then
                    local reward_list = {}
                    reward_list.show_reward_list = {}
                    local info = {
                        prop_item = -1,
                        prop_type = 28,
                        item_value = current_contribution - instance._last_contribution,
                    }
                    table.insert(reward_list.show_reward_list, info)
                    table.insert(_ED.show_reward_list_group_ex, reward_list)
                    checkRewardObtainDraw()
                    instance._last_contribution = current_contribution
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 清除cd
        local guard_battle_sure_clear_cd_terminal = {
            _name = "guard_battle_sure_clear_cd",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("guard_battle_guard_list_update_draw", 0, "")
                            state_machine.excute("guard_battle_update_user_info", 0, "")
                        end
                    end
                end
                protocol_command.guard_clear_cd.param_list = ""
                NetworkManager:register(protocol_command.guard_clear_cd.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 守卫军状态改变，请求刷新守卫军列表
        local guard_battle_request_guard_list_terminal = {
            _name = "guard_battle_request_guard_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                TipDlg.drawTextDailog(red_alert_time_str[298])
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("guard_battle_guard_list_update_list", 0, "")
                    end
                end
                protocol_command.guard_list_init.param_list = ""
                NetworkManager:register(protocol_command.guard_list_init.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(guard_battle_show_info_terminal)
        state_machine.add(guard_battle_click_stronghold_terminal)
        state_machine.add(guard_battle_buy_gain_terminal)
        state_machine.add(guard_battle_update_user_info_terminal)
        state_machine.add(guard_battle_update_state_terminal)
        state_machine.add(guard_battle_update_stronghold_info_terminal)
        state_machine.add(guard_battle_request_init_terminal)
        state_machine.add(guard_battle_show_battle_result_terminal)
        state_machine.add(guard_battle_sure_clear_cd_terminal)
        state_machine.add(guard_battle_request_guard_list_terminal)
        state_machine.init()
    end
    init_guard_battle_terminal()
end

function GuardBattle:playAttckEffect( ... )
    local root = self.roots[1]
    local Panel_guard_stronghold_effect = ccui.Helper:seekWidgetByName(root, "Panel_guard_stronghold_effect")
    if tonumber(_ED.guard_battle_stronghold_info.state) ~= 2 then
        if Panel_guard_stronghold_effect:getChildByTag(1000) ~= nil then
            Panel_guard_stronghold_effect:removeChildByTag(1000)
        end
    else    
        if Panel_guard_stronghold_effect:getChildByTag(1000) == nil then
            Panel_guard_stronghold_effect:removeAllChildren(true)
            local baseName = config_res.effect.effect_attack_guard
            local skeletonNode = sp.spine(baseName..".json", baseName..".atlas", 1, 0, nil, false, nil)
            skeletonNode:setAnimation(0, "animation_attack", true)
            skeletonNode:setPosition(cc.p(0, 0))
            skeletonNode:setTag(1000)
            Panel_guard_stronghold_effect:addChild(skeletonNode)
        end
    end
end

-- 刷新用户信息状态
function GuardBattle:onUpdateUserInfo()
    local root = self.roots[1]
    -- 个人贡献
    local Text_contribution_n = ccui.Helper:seekWidgetByName(root, "Text_contribution_n")
    Text_contribution_n:setString(exChangeNumToString(_ED.guard_battle_user_info.contribution))
    -- 增益
    for i = 1, 3 do 
        local Image_guard_gain_icon = ccui.Helper:seekWidgetByName(root, "Image_guard_gain_icon_"..i)
        Image_guard_gain_icon:setVisible(false)
    end
    local Text_guard_state_cooling_time = ccui.Helper:seekWidgetByName(root, "Text_guard_state_cooling_time")
    self._text_cd_time = Text_guard_state_cooling_time

    self._text_cd_time:setString("")
    if tonumber(_ED.guard_battle_stronghold_info.state) > 0 then
        for k, v in pairs(_ED.guard_battle_user_info.factor_list) do
            local Image_guard_gain_icon = ccui.Helper:seekWidgetByName(root, "Image_guard_gain_icon_"..k)
            if Image_guard_gain_icon ~= nil then
                if tonumber(v) == 0 then
                    Image_guard_gain_icon:setVisible(false)
                else
                    Image_guard_gain_icon:setVisible(true)
                end
            end
        end
        local leave_time = _ED.guard_battle_user_info.cd_end_time - (os.time() + _ED.time_add_or_sub)
        if leave_time > 0 then
            self._text_cd_time:setString(string.format(red_alert_time_str[183], exChangeTimeToString(leave_time)))
        else
            self._text_cd_time:setString("")
        end
    end
end

-- 刷新据点状态
function GuardBattle:onUpdatestronghold()
    local root = self.roots[1]
    local Text_stronghold_n = ccui.Helper:seekWidgetByName(root, "Text_stronghold_n")
    local LoadingBar_stronghold_boom = ccui.Helper:seekWidgetByName(root, "LoadingBar_stronghold_boom")

    local max_hp = 0
    local current_hp = 0
    if _ED.guard_battle_stronghold_info ~= nil then
        current_hp = tonumber(_ED.guard_battle_stronghold_info.current_hp)
        max_hp = tonumber(_ED.guard_battle_stronghold_info.max_hp)
    end

    local percent = current_hp * 100 / max_hp
    Text_stronghold_n:setString(""..current_hp.."/"..max_hp)
    LoadingBar_stronghold_boom:setPercent(percent)
end

-- 显示信息
function GuardBattle:onUpdateDraw()
    local root = self.roots[1]

    -- 战斗状态
    local Text_guard_state_n = ccui.Helper:seekWidgetByName(root, "Text_guard_state_n")
    local Text_guard_state_time = ccui.Helper:seekWidgetByName(root, "Text_guard_state_time")
    Text_guard_state_n:setString(tipStringInfo_campaign_info[11])
    Text_guard_state_time:setString("")
    Text_guard_state_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))

    self._text_time = Text_guard_state_time

    -- 战斗结果
    local Panel_guard_settlement_bg = ccui.Helper:seekWidgetByName(root, "Panel_guard_settlement_bg")
    local Text_guard_legion_t = ccui.Helper:seekWidgetByName(root, "Text_guard_legion_t")
    local Text_guard_legion_name = ccui.Helper:seekWidgetByName(root, "Text_guard_legion_name")
    local Panel_guard_vs = ccui.Helper:seekWidgetByName(root, "Panel_guard_vs")
    local Panel_guard_settlement = ccui.Helper:seekWidgetByName(root, "Panel_guard_settlement")
    Panel_guard_vs:removeBackGroundImage()
    Panel_guard_settlement:removeBackGroundImage()
    Panel_guard_settlement_bg:setVisible(false)

    local battle_type = tonumber(_ED.guard_battle_user_info.battle_type)
    local state = tonumber(_ED.guard_battle_stronghold_info.state)
    self._end_time = 0
    local push_info = _ED.mould_function_push_info["13"]
    if push_info ~= nil then
        self._end_time = tonumber(push_info.params) / 1000 + push_info.start_time
    end
    if state == 0 then     -- 已结束
        self._is_open = false
        Panel_guard_settlement_bg:setVisible(true)
        if tonumber(_ED.guard_battle_stronghold_info.result) ~= -1 then
            Panel_guard_settlement:setBackGroundImage(string.format(config_res.images.ui.combat.camp_pk_vs_text, 1))
            if tonumber(_ED.guard_battle_stronghold_info.result) == 1 then        -- 进攻胜利
                Panel_guard_vs:setBackGroundImage(string.format(config_res.images.ui.combat.guard_text, 2))
            else       -- 守方胜利
                Panel_guard_vs:setBackGroundImage(string.format(config_res.images.ui.combat.guard_text, 1))
            end
        end
        if tonumber(_ED.guard_battle_stronghold_info.top_legion) ~= nil and tonumber(_ED.guard_battle_stronghold_info.top_legion) == -1 then
            Text_guard_legion_name:setString("")
        else
            Text_guard_legion_name:setString(_ED.guard_battle_stronghold_info.top_legion)
        end
    elseif state == 1 then     -- 备战中
        self._is_open = true
        Text_guard_state_n:setString(tipStringInfo_campaign_info[18])
        Text_guard_state_n:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
        local leave_time = self._end_time - (os.time() + _ED.time_add_or_sub)
        Text_guard_state_time:setString(exChangeTimeToString(leave_time))
    elseif state == 2 then     -- 开战中
        self._is_open = true
        Text_guard_state_n:setString(tipStringInfo_campaign_info[19])
        Text_guard_state_n:setColor(cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3]))
        local leave_time = self._end_time - (os.time() + _ED.time_add_or_sub)
        Text_guard_state_time:setString(exChangeTimeToString(leave_time))
    end

    self._reconnect_count = 0
    self._reconnect_time = 0

    self:onUpdatestronghold()
    self:onUpdateUserInfo()
    self:playAttckEffect()
end

function GuardBattle:onUpdate(dt)
    if self._text_time ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            local leave_time = self._end_time - (os.time() + _ED.time_add_or_sub)
            if tonumber(_ED.guard_battle_stronghold_info.state) >= 1 then
                self._text_time:setString(exChangeTimeToString(leave_time))
                if leave_time < 0 then
                    self._text_time:setString(exChangeTimeToString(""))
                end

                if leave_time <= 0 then
                    -- 倒计时结束
                    self._text_time:setString("")
                    -- self:onUpdateDraw()
                end

                local leave_cd_time = _ED.guard_battle_user_info.cd_end_time - (os.time() + _ED.time_add_or_sub)
                if leave_cd_time > 0 then
                    self._text_cd_time:setString(string.format(red_alert_time_str[183], exChangeTimeToString(leave_cd_time)))
                else
                    self._text_cd_time:setString("")
                end
            end

            if leave_time <= -1 then
                if self._reconnect_count <= 2 then
                    if self._reconnect_time <= 0 then
                        self._reconnect_count = self._reconnect_count + 1
                        self._reconnect_time = 3
                        state_machine.excute("guard_battle_request_init", 0, "")
                    else
                        self._reconnect_time = self._reconnect_time - dt
                    end
                end
            end
        end
    end
end

function GuardBattle:updateChatView()
    local root = self.roots[1]
    local Panel_chat_view = ccui.Helper:seekWidgetByName(root, "Panel_chat_view")
    Panel_chat_view:removeAllChildren(true)
    state_machine.excute("legion_chats_view_open", 0, {Panel_chat_view, 1})
end

--初始化界面
function GuardBattle:onInit()
    local csbItem = csb.createNode(config_csb.campaign.guard_battle)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    self._last_state = tonumber(_ED.guard_battle_stronghold_info.state)
    self._last_contribution = tonumber(_ED.guard_battle_user_info.contribution)

    local rank_info = zstring.split(dms.string(dms["guard_config"], 3, guard_config.param), "|")
    self._min_rank = tonumber(rank_info[1])

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_battle_infor"), nil, 
    {
        terminal_name = "guard_battle_show_info", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_battle_close"), nil, 
    {
        terminal_name = "guard_battle_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_battle_gain"), nil, 
    {
        terminal_name = "guard_battle_buy_gain", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    local Image_guard_battle_bar_1 = ccui.Helper:seekWidgetByName(root, "Image_guard_battle_bar_1")
    Image_guard_battle_bar_1:setTouchEnabled(true)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_guard_battle_bar_1"), nil, 
    {
        terminal_name = "guard_battle_buy_gain", 
        terminal_state = 0, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_battle_battle_field"), nil, 
    {
        terminal_name = "guard_battle_record_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guard_battle_rank"), nil, 
    {
        terminal_name = "guard_battle_rank_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_guard_stronghold"), nil, 
    {
        terminal_name = "guard_battle_click_stronghold", 
        terminal_state = 0, 
    }, nil, 1)

    self:onUpdateDraw()
    self:updateChatView()
end

--初始化
function GuardBattle:init()
    self:onInit()
    return self
end

--移除状态机
function GuardBattle:onExit()
    state_machine.remove("guard_battle_show_info")
    state_machine.remove("guard_battle_click_stronghold")
    state_machine.remove("guard_battle_buy_gain")
    state_machine.remove("guard_battle_update_user_info")
    state_machine.remove("guard_battle_update_state")
    state_machine.remove("guard_battle_update_stronghold_info")
    state_machine.remove("guard_battle_request_init")
    state_machine.remove("guard_battle_show_battle_result")
    state_machine.remove("guard_battle_sure_clear_cd")
    state_machine.remove("guard_battle_request_guard_list")
end