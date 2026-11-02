-- ----------------------------------------------------------------------------------------------------
-- 说明：每日充值
-------------------------------------------------------------------------------------------------------
ActivityDailyRecharge = class("ActivityDailyRechargeClass", Window)

local activity_daily_recharge_window_open_terminal = {
    _name = "activity_daily_recharge_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("ActivityDailyRechargeClass")
        if nil == _homeWindow then
            local panel = ActivityDailyRecharge:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_daily_recharge_window_close_terminal = {
    _name = "activity_daily_recharge_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("ActivityDailyRechargeClass")
        if nil ~= _homeWindow then
            fwin:close(fwin:find("ActivityDailyRechargeClass"))
        end
        state_machine.excute("home_update_top_activity_info_state", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_daily_recharge_window_open_terminal)
state_machine.add(activity_daily_recharge_window_close_terminal)
state_machine.init()
    
function ActivityDailyRecharge:ctor()
    self.super:ctor()
    self.roots = {}
    self.loaded = false
    self.actions = {}
    self.ship_id = 0
    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.l_digital.activity.wonderful.ActivityDailyRechargeBuy")
    local function init_activity_daily_recharge_window_terminal()
        -- 购买
        local go_to_buy_terminal = {
            _name = "go_to_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _self = params._datas._cell
                local dangWId = params._datas.dangWId
                local state = params._datas.state
                if state == 0 then
                    state_machine.excute("activity_daily_recharge_buy_window_open", 0, {dangWId, _self.myRewards})
                elseif state == 1 then
                    local function callBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            -- response.node:isDrawedUpdateDraw()
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(7)
                            fwin:open(getRewardWnd, fwin._dialog)
                            -- if exit then
                            --  fwin:close(fwin:find("ActivityRichFirstRechargeClass"))
                            -- else
                            --  _self:sortDatas(_self.curIndex)
                            -- end
                            if response.node and response.node.roots and response.node.roots[1] then
                                state_machine.excute("activity_daily_recharge_window_update_draw", 0, "")
                            end
                        end
                    end
                    protocol_command.get_activity_reward.param_list = "".._ED.active_activity[150].activity_id.."\r\n"..(tonumber(_self.myRewards[dangWId].index) - 1).."\r\n".."1"
                    NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, _self, callBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local activity_daily_recharge_window_update_draw_terminal = {
            _name = "activity_daily_recharge_window_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(go_to_buy_terminal)
        state_machine.add(activity_daily_recharge_window_update_draw_terminal)
        state_machine.init()
    end
    init_activity_daily_recharge_window_terminal()
end

function ActivityDailyRecharge:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local activity = _ED.active_activity[150]
    if activity == nil then
        return
    end

    self:initData()
    
    local params = zstring.split(activity.activity_params, "|")
    for i=1,3 do
        local datas = zstring.splits(params[i], ",", ":")
        local dangWId = datas[1][1]
        local rmb = dms.int(dms["top_up_goods"], dangWId, 4)
        local Panel_gift_bag_position =  ccui.Helper:seekWidgetByName(root, "Panel_gift_bag_position_" .. i)
        local Panel_gift_bag =  ccui.Helper:seekWidgetByName(root, "Panel_gift_bag_" .. i)
        local Text_gift_infor =  ccui.Helper:seekWidgetByName(root, "Text_gift_infor_" .. i)
        local Text_rmb =  ccui.Helper:seekWidgetByName(root, "Text_rmb_" .. i)
        local Button_recharge_rmb =  ccui.Helper:seekWidgetByName(root, "Button_recharge_rmb_" .. i)
        local Image_buy =  ccui.Helper:seekWidgetByName(root, "Image_buy_" .. i)
        local Button_recharge_receive =  ccui.Helper:seekWidgetByName(root, "Button_recharge_receive_" .. i)
        local Image_rmb_icon =  ccui.Helper:seekWidgetByName(root, "Image_rmb_icon_" .. i)

        Panel_gift_bag_position:removeBackGroundImage()
        Panel_gift_bag:removeBackGroundImage()
        Text_gift_infor:setString("")
        Text_rmb:setString("")

        Text_rmb:setString(rmb)

        local des = dms.element(dms["word_mould"], 3147 + i)
        Text_gift_infor:setString(des[3])

        Panel_gift_bag_position:setBackGroundImage(string.format("images/ui/text/sm_hd/chaozhilibao_position_%d.png", tonumber(dangWId)))
        Panel_gift_bag:setBackGroundImage(string.format("images/ui/activity/mrlb_%d.png", tonumber(dangWId)))

        Text_rmb:setVisible(true)
        Image_rmb_icon:setVisible(true)
        if tonumber(self.myRewards[dangWId].num) ~= 0 then
            if tonumber(self.myRewards[dangWId].state) == 0 then
                Button_recharge_rmb:setVisible(true)
                Button_recharge_rmb:setTouchEnabled(true)
                Button_recharge_rmb:setBright(true)
                Button_recharge_receive:setVisible(false)
                Image_buy:setVisible(false)

                --次数用完了
                if tonumber(self.myRewards[dangWId].buy) >= tonumber(self.myRewards[dangWId].num) then
                    Button_recharge_rmb:setVisible(true)
                    Button_recharge_receive:setVisible(false)
                    Image_buy:setVisible(true)
                    Button_recharge_rmb:setTouchEnabled(false)
                    Button_recharge_rmb:setBright(false)
                    Text_rmb:setVisible(false)
                    Image_rmb_icon:setVisible(false)
                end
            elseif tonumber(self.myRewards[dangWId].state) == 1 then
                Button_recharge_rmb:setVisible(false)
                Button_recharge_receive:setVisible(true)
                Image_buy:setVisible(false)
            end
        else
            if tonumber(self.myRewards[dangWId].state) == 0 then
                Button_recharge_rmb:setVisible(true)
                Button_recharge_rmb:setTouchEnabled(true)
                Button_recharge_rmb:setBright(true)
                Button_recharge_receive:setVisible(false)
                Image_buy:setVisible(false)
            elseif tonumber(self.myRewards[dangWId].state) == 1 then
                Button_recharge_rmb:setVisible(false)
                Button_recharge_receive:setVisible(true)
                Image_buy:setVisible(false)
            end
        end

        fwin:addTouchEventListener(Button_recharge_rmb, nil, 
        {
            terminal_name = "go_to_buy", 
            terminal_state = 0, 
            _cell = self, 
            dangWId = dangWId,
            state = tonumber(self.myRewards[dangWId].state)
        },
        nil,0)  

        fwin:addTouchEventListener(Button_recharge_receive, nil, 
        {
            terminal_name = "go_to_buy", 
            terminal_state = 0, 
            _cell = self, 
            dangWId = dangWId,
            state = tonumber(self.myRewards[dangWId].state)
        },
        nil,0) 
    end
end

function ActivityDailyRecharge:initData()
    local activity = _ED.active_activity[150]
    if activity == nil then
        return
    end
    local allReward = {}
    for i,info in ipairs(activity.activity_Info) do
        local dangW = zstring.splits(info.activityInfo_need_day, ",", "-")
        local minLevel = tonumber(dangW[1][1])
        local maxLevel = tonumber(dangW[1][2])
        if tonumber(_ED.user_info.user_grade) >= minLevel and maxLevel > tonumber(_ED.user_info.user_grade) then
            allReward[dangW[2][1]] = info 
        end
    end

    self.myRewards = {}
    local params = zstring.split(activity.activity_params, "|")
    for i, data in ipairs(params) do
        local datas = zstring.splits(data, ",", ":")
        if allReward[datas[1][1]] then
            self.myRewards[datas[1][1]] = allReward[datas[1][1]]
            self.myRewards[datas[1][1]].buy = datas[1][2]
            self.myRewards[datas[1][1]].state = datas[2][1]
            self.myRewards[datas[1][1]].num = datas[3][1]
        end
    end
end

function ActivityDailyRecharge:onUpdate(dt)
end

function ActivityDailyRecharge:onInit()
    local csbActivityDailyRecharge = csb.createNode("activity/wonderful/daily_gift_bag.csb")
    local root = csbActivityDailyRecharge:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbActivityDailyRecharge)
    self:onUpdateDraw()
end

function ActivityDailyRecharge:lazy()
    if self.loaded == true then
        return
    end
    self.loaded = true
    self:onInit()
    self:registerOnNoteUpdate(self, 1)
end

function ActivityDailyRecharge:unload()
    self:removeAllChildren(true)
    self.loaded = false
    self.roots = {}
end

function ActivityDailyRecharge:onExit()
    state_machine.remove("activity_daily_recharge_window_display")
    state_machine.remove("activity_daily_recharge_window_hide")
end

function ActivityDailyRecharge:createCell()
    local cell = ActivityDailyRecharge:new()
    cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell, 1)
    return cell
end