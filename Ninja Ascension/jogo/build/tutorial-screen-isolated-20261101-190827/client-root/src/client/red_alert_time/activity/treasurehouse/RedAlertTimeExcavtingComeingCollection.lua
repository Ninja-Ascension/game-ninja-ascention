--------------------------------------------------------------------------------------------------------------
--  说明：挖掘机来袭 收集零件
--------------------------------------------------------------------------------------------------------------
RedAlertTimeExcavtingComeingCollection = class("RedAlertTimeExcavtingComeingCollectionClass", Window)

--打开界面
local red_alert_time_excavting_comeing_collection_open_terminal = {
    _name = "red_alert_time_excavting_comeing_collection_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(RedAlertTimeExcavtingComeingCollection:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_excavting_comeing_collection_open_terminal)
state_machine.init()

function RedAlertTimeExcavtingComeingCollection:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._activity_type = 0
    self.oneNeedGod = 0
    self.tenNeedGod = 0
    self.tenNeedGodOld = 0
    self.discount = 0
    self.isFree = false
    self._is_end = false

    app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLeaderSeniorOnce")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeLeaderSeniorTen")

    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_snatch_rebel_haunt_pack_cell")
    
    local function init_red_alert_time_excavting_comeing_collection_terminal()
        local red_alert_time_excavting_comeing_collection_show_terminal = {
            _name = "red_alert_time_excavting_comeing_collection_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_excavting_comeing_collection_hide_terminal = {
            _name = "red_alert_time_excavting_comeing_collection_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local red_alert_time_excavting_comeing_collection_updata_terminal = {
            _name = "red_alert_time_excavting_comeing_collection_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_excavting_comeing_collection_get_terminal = {
            _name = "red_alert_time_excavting_comeing_collection_get",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local curr_type = params._datas._type
                if curr_type == 1 and instance.isFree == true then
                    TipDlg.drawTextDailog(activity_str_tip[77])
                    return
                end
                if curr_type == 0 and instance.isFree == true then
                    state_machine.excute("red_alert_time_excavting_comeing_collection_sure_collect",0,{0})
                else
                    local need_gold = 0
                    local cost = 0
                    if curr_type == 0 then
                        need_gold = instance.oneNeedGod
                        cost = 1
                    else
                        cost = 10
                        need_gold = instance.tenNeedGod
                    end
                    if tonumber(need_gold) > tonumber(_ED.user_info.user_gold) then
                        TipDlg.drawTextDailog(tipStringInfo_campaign_info[16])
                        return
                    end
                    state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {need_gold,cost,curr_type}, m_type = 35}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_excavting_comeing_collection_sure_collect_terminal = {
            _name = "red_alert_time_excavting_comeing_collection_sure_collect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local choose_type = params[1]
                local acitvity = _ED.activity_info[""..instance._activity_type]
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if choose_type == 1 then
                            if fwin:find("RedAlertTimeLeaderSeniorTenClass") ~= nil then
                                state_machine.excute("red_alert_time_leader_senior_ten_update_draw", 0, nil)
                            else
                                state_machine.excute("red_alert_time_leader_senior_ten_window_open", 0, {instance._activity_type, instance.tenNeedGod, instance.tenNeedGodOld, instance.discount})
                            end
                        else
                            if fwin:find("RedAlertTimeLeaderSeniorOnceClass") ~= nil then
                                state_machine.excute("red_alert_time_leader_senior_once_update_draw", 0, nil)
                            else
                                state_machine.excute("red_alert_time_leader_senior_once_window_open", 0, {instance._activity_type, instance.oneNeedGod, false})
                            end
                        end
                    end
                end
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n".."0".."\r\n".."0".."\r\n"..choose_type
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 矿点收集
        local red_alert_time_excavting_comeing_collection_mine_terminal = {
            _name = "red_alert_time_excavting_comeing_collection_mine",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_excavting_comeing_window_close", 0, "")
                state_machine.excute("red_alert_time_center_window_close", 0, "")
                state_machine.excute("short_cut_go_to_other_window",0,{16})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_excavting_comeing_collection_updata_terminal)
        state_machine.add(red_alert_time_excavting_comeing_collection_hide_terminal)
        state_machine.add(red_alert_time_excavting_comeing_collection_show_terminal)
        state_machine.add(red_alert_time_excavting_comeing_collection_get_terminal)
        state_machine.add(red_alert_time_excavting_comeing_collection_sure_collect_terminal)
        state_machine.add(red_alert_time_excavting_comeing_collection_mine_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_excavting_comeing_collection_terminal()
end

function RedAlertTimeExcavtingComeingCollection:updateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_add_state = zstring.split(activity_info.activity_add_state, ",")

    -- activity_add_state = "开始时间,结束时间,领奖时间,免费次数,最大免费次数,单次收集花费,10次收集花费,10次收集花费原价,折扣,零件数量,奖励预览掉落id"
    activity_add_state = zstring.split("11,22,33,1,1,48,432,480,9,10,1012", ",")

    -- 零件数量
    local Text_excavting_comeing_equ_n = ccui.Helper:seekWidgetByName(root,"Text_excavting_comeing_equ_n")
    Text_excavting_comeing_equ_n:setString(activity_add_state[10])

    local Button_excavting_comeing_equ_free = ccui.Helper:seekWidgetByName(root,"Button_excavting_comeing_equ_free")
    local Button_excavting_comeing_equ_one = ccui.Helper:seekWidgetByName(root,"Button_excavting_comeing_equ_one")
    local Button_excavting_comeing_gold_equ_ten = ccui.Helper:seekWidgetByName(root,"Button_excavting_comeing_gold_equ_ten")

    local Image_excavting_comeing_gold_equ_1 = ccui.Helper:seekWidgetByName(root,"Image_excavting_comeing_gold_equ_1")
    local Text_excavting_comeing_gold_equ_one_n = ccui.Helper:seekWidgetByName(root,"Text_excavting_comeing_gold_equ_one_n")
    local Text_excavting_comeing_equ_ten_n = ccui.Helper:seekWidgetByName(root,"Text_excavting_comeing_equ_ten_n")
    local Text_excavting_comeing_equ_ten_old_n = ccui.Helper:seekWidgetByName(root,"Text_excavting_comeing_equ_ten_old_n")
    Text_excavting_comeing_gold_equ_one_n:setString(activity_add_state[6])
    Text_excavting_comeing_equ_ten_n:setString(activity_add_state[7])
    Text_excavting_comeing_equ_ten_old_n:setString(activity_add_state[8])
    self.oneNeedGod = tonumber(activity_add_state[6])
    self.tenNeedGod = tonumber(activity_add_state[7])
    self.tenNeedGodOld = tonumber(activity_add_state[8])
    self.discount = tonumber(activity_add_state[9])

    self.isFree = false
    self._is_end = false
    if tonumber(activity_add_state[3]/1000) - (os.time() + _ED.time_add_or_sub) < 0 then
        self._is_end = true
    end
    if self._is_end == true then
        self.isFree = false
        Button_excavting_comeing_equ_free:setVisible(false)
        Button_excavting_comeing_equ_one:setVisible(true)
        Image_excavting_comeing_gold_equ_1:setVisible(true)
        Text_excavting_comeing_gold_equ_one_n:setVisible(true)
            
        Button_excavting_comeing_equ_one:setTouchEnabled(false)
        Button_excavting_comeing_equ_one:setBright(false)
        Button_excavting_comeing_gold_equ_ten:setTouchEnabled(false)
        Button_excavting_comeing_gold_equ_ten:setBright(false)
    else
        if tonumber(activity_add_state[4]) < tonumber(activity_add_state[5]) then
            self.isFree = true
            Button_excavting_comeing_equ_free:setVisible(true)
            Button_excavting_comeing_equ_one:setVisible(false)
            Image_excavting_comeing_gold_equ_1:setVisible(false)
            Text_excavting_comeing_gold_equ_one_n:setVisible(false)
        else
            self.isFree = false
            Button_excavting_comeing_equ_free:setVisible(false)
            Button_excavting_comeing_equ_one:setVisible(true)
            Image_excavting_comeing_gold_equ_1:setVisible(true)
            Text_excavting_comeing_gold_equ_one_n:setVisible(true)
        end
    end

end

function RedAlertTimeExcavtingComeingCollection:updateRewardPreview()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_add_state = zstring.split(activity_info.activity_add_state, ",")

    -- activity_add_state = "开始时间,结束时间,领奖时间,免费次数,最大免费次数,单次收集花费,10次收集花费,10次收集花费原价,折扣,零件数量,奖励预览掉落id"
    activity_add_state = zstring.split("11,22,33,1,1,48,432,480,9,10,1012", ",")
    -- 奖励预览
    local ListView_excavting_comeing_rew = ccui.Helper:seekWidgetByName(root,"ListView_excavting_comeing_rew")
    local reward_info = zstring.split(dms.string(dms["scene_reward"], tonumber(activity_add_state[11]), scene_reward.reward_items),"|")
    for k, v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local prop_data = {}
        prop_data.prop_item = tonumber(info[1])
        prop_data.prop_type = tonumber(info[2])
        prop_data.item_value = tonumber(info[3])
        local cell = createPropIconCell(prop_data, true, true, true)
        ListView_excavting_comeing_rew:addChild(cell)
    end
    ListView_excavting_comeing_rew:requestRefreshView()
end

--初始化
function RedAlertTimeExcavtingComeingCollection:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.excavting_comeing_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)  

    --免费
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_excavting_comeing_equ_free"), nil, 
    {
        terminal_name = "red_alert_time_excavting_comeing_collection_get", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 0,
    }, nil, 1)

    --单次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_excavting_comeing_equ_one"), nil, 
    {
        terminal_name = "red_alert_time_excavting_comeing_collection_get", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 0,
    }, nil, 1)
    
    --10次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_excavting_comeing_gold_equ_ten"), nil, 
    {
        terminal_name = "red_alert_time_excavting_comeing_collection_get", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 1,
    }, nil, 1)  

    --矿点收集
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_excavting_comeing_res"), nil, 
    {
        terminal_name = "red_alert_time_excavting_comeing_collection_mine", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _type = 0,
    }, nil, 1)

    self:updateDraw()
    self:updateRewardPreview()
end

function RedAlertTimeExcavtingComeingCollection:onEnterTransitionFinish()

end

function RedAlertTimeExcavtingComeingCollection:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeExcavtingComeingCollection:onExit()
    state_machine.remove("red_alert_time_excavting_comeing_collection_show")
    state_machine.remove("red_alert_time_excavting_comeing_collection_hide")
    state_machine.remove("red_alert_time_excavting_comeing_collection_updata")
    state_machine.remove("red_alert_time_excavting_comeing_collection_get")
    state_machine.remove("red_alert_time_excavting_comeing_collection_sure_collect")
    state_machine.remove("red_alert_time_excavting_comeing_collection_mine")
end