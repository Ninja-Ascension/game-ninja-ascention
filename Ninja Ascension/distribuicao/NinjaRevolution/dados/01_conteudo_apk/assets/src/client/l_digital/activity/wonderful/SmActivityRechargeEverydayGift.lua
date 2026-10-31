-- ----------------------------------------------------------------------------------------------------
-- 说明：每日充值
-------------------------------------------------------------------------------------------------------
SmActivityRechargeEverydayGift = class("SmActivityRechargeEverydayGiftClass", Window)
 
function SmActivityRechargeEverydayGift:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.l_digital.activity.wonderful.SmActivityRechargeEverydayBox")
    app.load("client.landscape.cells.duplicate.lpve_reward_cell")
    app.load("client.reward.DrawRareReward")
    self.currDay = 0 --当前第几天
    self.end_times = 0
    self.maxDaysNum = 5    -- 累充天数上限
    self.text_times = nil 
    self.canReward = false
    self.reworld_sorting = {}

    local function init_sm_activity_recharge_everyday_gift_window_terminal()
        -- 刷新
        local sm_activity_recharge_everyday_gift_window_update_draw_terminal = {
            _name = "sm_activity_recharge_everyday_gift_window_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance.roots[1]:runAction(cc.Sequence:create({cc.DelayTime:create(0.5), cc.CallFunc:create(function ( sender )
                        instance:onUpdateDraw()
                    end)}))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 查看礼包
        local sm_activity_recharge_everyday_gift_look_gift_terminal = {
            _name = "sm_activity_recharge_everyday_gift_look_gift",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance = params._datas.cell
                local index = params._datas.index
                local currdata = _ED.active_activity[instance.m_type].activity_Info[index]
                state_machine.excute("sm_activity_recharge_everyday_box_open",0,currdata)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 领奖
        local sm_activity_recharge_everyday_gift_get_reward_terminal = {
            _name = "sm_activity_recharge_everyday_gift_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance = params._datas.cell
                if instance.canReward == false then
                    state_machine.excute("shortcut_open_recharge_window", 0, "")
                else
                    local Image_received = ccui.Helper:seekWidgetByName(instance.roots[1],"Image_received")
                    local Image_receive = ccui.Helper:seekWidgetByName(instance.roots[1],"Image_receive")
                    local Button_recruit_card_send_rec = ccui.Helper:seekWidgetByName(instance.roots[1],"Button_recruit_card_send_rec")
                    local Panel_recharge_everyday_gift_box = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_recharge_everyday_gift_box_"..instance.currDay)
                    if TipDlg.drawStorageTipo() == false then
                        local function responseGetServerListCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                local getRewardWnd = DrawRareReward:new()
                                -- getRewardWnd:init(7,nil,instance.reworld_sorting)
                                getRewardWnd:init(7)
                                fwin:open(getRewardWnd,fwin._ui)
                                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                    response.node.roots[1]:runAction(cc.Sequence:create({cc.DelayTime:create(0.5), cc.CallFunc:create(function ( sender )
                                        response.node:onUpdateDraw()
                                    end)}))
                                end
                            end
                        end
                        local activity = _ED.active_activity[instance.m_type]
                        local currDatas = zstring.split(activity.activity_params, "|")
                        local rewardInfo = zstring.split(currDatas[1], ",")
                        local showDay = 0
                        for k,v in pairs(rewardInfo) do
                            if tonumber(v) == 0 then
                                showDay = k
                                break
                            end
                        end
                        if showDay == 0 or showDay > instance.currDay then
                            showDay = instance.currDay
                        end
                        local activityId = activity.activity_id
                        protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(showDay)-1).."\r\n1"
                        NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(sm_activity_recharge_everyday_gift_get_reward_terminal)
        state_machine.add(sm_activity_recharge_everyday_gift_window_update_draw_terminal)
        state_machine.add(sm_activity_recharge_everyday_gift_look_gift_terminal)
        state_machine.init()
    end
    init_sm_activity_recharge_everyday_gift_window_terminal()
end

function SmActivityRechargeEverydayGift:onUpdate(dt)
    if self.end_times > 0 and self.text_times ~= nil then
        self.end_times = self.end_times - dt
        self.text_times:setString(getRedAlertTimeActivityFormat(self.end_times))
        if self.end_times == 0 then
        end
    end
end

function SmActivityRechargeEverydayGift:onUpdateDrawData()
    self:onUpdateDraw()
end

function SmActivityRechargeEverydayGift:updateDrawButton()
    local root = self.roots[1]
    local activity = _ED.active_activity[self.m_type]
    local haveRechargeNumber = 0
    -- 1,1,1,1,1|2040,4560,720,1040,980,0|5|0|0|1513257557568|219-224,101502
    local currDatas = zstring.split(activity.activity_params, "|")
    local rewardInfo = zstring.split(currDatas[1], ",")
    local rechargeCountData = zstring.split(currDatas[2], ",")
    local currDay = tonumber(currDatas[3])
    if currDay >= #rewardInfo - 1 then
        currDay = #rewardInfo - 1
    end
    --充值金额--测试数据
    local needRecharge = tonumber(activity.activity_Info[currDay+1].activityInfo_need_day)
    for i = 1 , 5 do
        local Panel_recharge_everyday_gift_box = ccui.Helper:seekWidgetByName(root,"Panel_recharge_everyday_gift_box_"..i)
        Panel_recharge_everyday_gift_box:removeBackGroundImage()
        Panel_recharge_everyday_gift_box:removeAllChildren(true)
        local chest_cell = nil
        if tonumber(activity.activity_Info[i].activityInfo_need_day) <= tonumber(rechargeCountData[i]) then
            -- Panel_recharge_everyday_gift_box:setBackGroundImage("images/ui/reward/gq_pic_bx1open.png")
            haveRechargeNumber = haveRechargeNumber + 1
            if tonumber(rewardInfo[i]) == 1 then
            -- if tonumber(activity.activity_Info[i].activityInfo_isReward) == 0 then
                chest_cell = state_machine.excute("lpve_reward_cell_create", 0, {-1, {state = 1, showAni = false}, 0})
            else
                chest_cell = state_machine.excute("lpve_reward_cell_create", 0, {-1, {state = 0, showAni = true}, 0})
            end
        else
            chest_cell = state_machine.excute("lpve_reward_cell_create", 0, {-1, {state = 0, showAni = false}, 0})
        end
        Panel_recharge_everyday_gift_box:addChild(chest_cell)
    end

    local Button_recruit_card_send_rec = ccui.Helper:seekWidgetByName(root,"Button_recruit_card_send_rec")
    local Image_received = ccui.Helper:seekWidgetByName(root,"Image_received")
    local Image_receive = ccui.Helper:seekWidgetByName(root,"Image_receive")
    Image_received:setVisible(true)
    Image_receive:setVisible(true)
    Image_received:setString("")
    Image_receive:setString("")
    -- local currRwardState = tonumber(activity.activity_Info[self.currDay].activityInfo_isReward)

    local showDay = 0
    for k,v in pairs(rewardInfo) do
        if tonumber(v) == 0 then
            showDay = k
            break
        end
    end
    if showDay == 0 or showDay > self.currDay then
        showDay = self.currDay
    end

    if tonumber(activity.activity_Info[showDay].activityInfo_need_day) > tonumber(rechargeCountData[showDay]) then
        Image_receive:setString(_string_piece_info[206])
        Button_recruit_card_send_rec:setTouchEnabled(true)
        Button_recruit_card_send_rec:setBright(true)
        self.canReward = false
    else
        if tonumber(rewardInfo[showDay]) == 0 then
        -- if tonumber(activity.activity_Info[self.currDay].activityInfo_isReward) == 0 then
            --可领
            Image_receive:setString(_new_interface_text[198])
            Button_recruit_card_send_rec:setTouchEnabled(true)
            Button_recruit_card_send_rec:setBright(true)
            self.canReward = true
        else
            --领过了
            Button_recruit_card_send_rec:setTouchEnabled(false)
            Button_recruit_card_send_rec:setBright(false)
            Image_receive:setString(_new_interface_text[199])
        end
    end

    -- 最终奖励领取后显示已领取图标
    local Image_rec = ccui.Helper:seekWidgetByName(root,"Image_rec")
    if Image_rec ~= nil then
        Image_rec:setVisible(false)
        if self.currDay == self.maxDaysNum then
            if tonumber(rewardInfo[self.currDay]) == 1 then
                Image_rec:setVisible(true)
            end
        end
    end

    local LoadingBar_recharge_everyday_gift = ccui.Helper:seekWidgetByName(root,"LoadingBar_recharge_everyday_gift")
    local per = haveRechargeNumber / 5 * 100
    LoadingBar_recharge_everyday_gift:setPercent(per)
end

function SmActivityRechargeEverydayGift:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local activity = _ED.active_activity[self.m_type]
    if activity.activity_params == "" then
        --当前的奖励的领取次数|每档充值金额,...|最大领取数|循环次数|当前循环第几天
        activity.activity_params = "0|0,0,0,0,0,0|0|0|0|0"
    end
    self.maxDaysNum = tonumber(activity.need_recharge_count)
    local currDatas = zstring.split(activity.activity_params, "|")
    local rewardInfo = zstring.split(currDatas[1], ",")
    local rechargeCountData = zstring.split(currDatas[2], ",")
    local currDay = tonumber(currDatas[3])
    if currDay >= #rewardInfo - 1 then
        currDay = #rewardInfo - 1
    end
    local showDay = 0
    for k,v in pairs(rewardInfo) do
        if tonumber(v) == 0 then
            showDay = k
            break
        end
    end
    if showDay == 0 or showDay > currDay + 1 then
        showDay = currDay + 1
    end
    currDay = showDay - 1
    --充值金额--测试数据
    local needRecharge = tonumber(activity.activity_Info[currDay+1].activityInfo_need_day)
    local Panel_recharge_everyday_gift_price = ccui.Helper:seekWidgetByName(root,"Panel_recharge_everyday_gift_price")
    Panel_recharge_everyday_gift_price:removeBackGroundImage()
    if needRecharge == 60 then
        Panel_recharge_everyday_gift_price:setBackGroundImage("images/ui/text/sm_hd/mrcz_je_1.png")
    elseif needRecharge == 300 then
        Panel_recharge_everyday_gift_price:setBackGroundImage("images/ui/text/sm_hd/mrcz_je_2.png")
    elseif needRecharge == 600 then
        Panel_recharge_everyday_gift_price:setBackGroundImage("images/ui/text/sm_hd/mrcz_je_3.png")
    elseif needRecharge == 980 then
        Panel_recharge_everyday_gift_price:setBackGroundImage("images/ui/text/sm_hd/mrcz_je_4.png")
    end
    --今日充值金额
    local today_recharge = tonumber(rechargeCountData[currDay+1])
    local Text_recharge_everyday_gift_p = ccui.Helper:seekWidgetByName(root,"Text_recharge_everyday_gift_p")
    if today_recharge >= needRecharge then
        Text_recharge_everyday_gift_p:setString(activity_tip_str_info[1])
    else
        Text_recharge_everyday_gift_p:setString(string.format(activity_tip_str_info[2] , today_recharge , needRecharge - today_recharge))
    end
    --当前天数 测试数据
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto
        then
        local LoadingBar_re_gift_0 = ccui.Helper:seekWidgetByName(root,"LoadingBar_re_gift_0")
        LoadingBar_re_gift_0:setPercent(today_recharge/needRecharge*100)
        local Text_re_gift_p_0 = ccui.Helper:seekWidgetByName(root,"Text_re_gift_p_0")
        if today_recharge >= needRecharge then
            Text_re_gift_p_0:setString(needRecharge.."/"..needRecharge)
        else
            Text_re_gift_p_0:setString(today_recharge.."/"..needRecharge)
        end
    end

    self.currDay = currDay + 1

    local index = 1
    local currReward = activity.activity_Info[showDay]
    local rewardNumber = 0
    for i , v in pairs(currReward.activityInfo_prop_info) do
        if i < 3 then
            rewardNumber = rewardNumber + 1
            local Panel_recharge_everyday_gift_icon = ccui.Helper:seekWidgetByName(root,"Panel_recharge_everyday_gift_icon_"..i)
            Panel_recharge_everyday_gift_icon:removeAllChildren(true)
            local cell = ResourcesIconCell:createCell()
            cell:init(6, v.propMouldCount, v.propMould,nil,nil,nil,true)
            Panel_recharge_everyday_gift_icon:addChild(cell)
            local rewardinfo = {}
            rewardinfo.type = 6
            rewardinfo.id = v.propMould
            rewardinfo.number = v.propMouldCount
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        end
    end
    for i , v in pairs(currReward.activityInfo_equip_info) do
        if rewardNumber < 3 then
            rewardNumber = rewardNumber + 1
            local Panel_recharge_everyday_gift_icon = ccui.Helper:seekWidgetByName(root,"Panel_recharge_everyday_gift_icon_"..rewardNumber)
            Panel_recharge_everyday_gift_icon:removeAllChildren(true)
            local cell = ResourcesIconCell:createCell()
            cell:init(7, tonumber(v.equipMouldCount), v.equipMould,nil,nil,true,true)
             Panel_recharge_everyday_gift_icon:addChild(cell)
            local rewardinfo = {}
            rewardinfo.type = 7
            rewardinfo.id = v.equipMould
            rewardinfo.number = v.equipMouldCount
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        end
    end
    if rewardNumber < 3 then
        if tonumber(currReward.activityInfo_silver) > 0 then
            local Panel_recharge_everyday_gift_icon = ccui.Helper:seekWidgetByName(root,"Panel_recharge_everyday_gift_icon_3")
            Panel_recharge_everyday_gift_icon:removeAllChildren(true)
            local cell = ResourcesIconCell:createCell()
            cell:init(1, currReward.activityInfo_silver, -1,nil,nil,nil,true)
            Panel_recharge_everyday_gift_icon:addChild(cell)
            local rewardinfo = {}
            rewardinfo.type = 1
            rewardinfo.id = -1
            rewardinfo.number = currReward.activityInfo_silver
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        end
    end
    if currDay == 4 then
        local currReward = activity.activity_Info[currDay + 2]
        for i , v in pairs(currReward.activityInfo_equip_info) do
            local rewardinfo = {}
            rewardinfo.type = 7
            rewardinfo.id = v.equipMould
            rewardinfo.number = v.equipMouldCount
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        end
        for i , v in pairs(currReward.activityInfo_prop_info) do
            local rewardinfo = {}
            rewardinfo.type = 6
            rewardinfo.id = v.propMould
            rewardinfo.number = v.propMouldCount
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        end
    end
    --最终奖励
    local Panel_recharge_everyday_gift_box_6 = ccui.Helper:seekWidgetByName(root,"Panel_recharge_everyday_gift_box_6")
    Panel_recharge_everyday_gift_box_6:removeAllChildren(true)
    if #activity.activity_Info[6].activityInfo_equip_info > 0 then
        local maxRewardData = activity.activity_Info[6].activityInfo_equip_info[1]
        local cell = ResourcesIconCell:createCell()
        cell:init(7, maxRewardData.equipMouldCount, maxRewardData.equipMould,nil,nil,nil,true,nil,{equipQuality = 1})
        Panel_recharge_everyday_gift_box_6:addChild(cell)
    elseif #activity.activity_Info[6].activityInfo_prop_info > 0 then
        local maxRewardData = activity.activity_Info[6].activityInfo_prop_info[1]
        local cell = ResourcesIconCell:createCell()
        cell:init(6, maxRewardData.propMouldCount, maxRewardData.propMould,nil,nil,nil,true)
        Panel_recharge_everyday_gift_box_6:addChild(cell)
    end
    --形象 测试数据
    local Text_recharge_everyday_gift_time_n = ccui.Helper:seekWidgetByName(root,"Text_recharge_everyday_gift_time_n")
    --结束时间/1000 -( os.time() - _ED.native_time + _ED.system_time)
    if self.m_type == 77 
        or self.m_type == 117 
        or self.m_type == 118
        then
        self.end_times = (tonumber(currDatas[8]) / 1000) - ( os.time() - _ED.native_time + _ED.system_time)
    elseif self.m_type == 91 or self.m_type == 139 then
        self.end_times = (tonumber(activity.end_time) / 1000) - ( os.time() - _ED.native_time + _ED.system_time)
    end
    self.text_times = Text_recharge_everyday_gift_time_n

    local Panel_recharge_everyday_gift_role = ccui.Helper:seekWidgetByName(root,"Panel_recharge_everyday_gift_role")
    -- local rewardDataInfo = zstring.split(dms.string(dms["activity_config"], 5, activity_config.param), "|")
    local icons = zstring.split(currDatas[7],",")[2]
    if Panel_recharge_everyday_gift_role ~= nil then
        Panel_recharge_everyday_gift_role:removeBackGroundImage()
        Panel_recharge_everyday_gift_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", tonumber(icons)))
    end
    self:updateDrawButton()
end

function SmActivityRechargeEverydayGift:lazy()
    if self.loaded == true then
        return
    end
    self.loaded = true
    self:onInit()
end

function SmActivityRechargeEverydayGift:unload()
    self:removeAllChildren(true)
    self.loaded = false
    self.roots = {}
    self.canReward = false
    self.currDay = 0 --当前第几天
    self.end_times = 0
    self.text_times = nil 
end

function SmActivityRechargeEverydayGift:init(m_type)
    self.m_type = tonumber(m_type)
    -- self:onInit()
end

function SmActivityRechargeEverydayGift:onInit()
    local csbSmActivityRechargeEverydayGift = csb.createNode("activity/wonderful/recharge_everyday_gift.csb")
    local root = csbSmActivityRechargeEverydayGift:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmActivityRechargeEverydayGift)

    self:onUpdateDraw()

	-- 查看礼包
    for i = 1 , 5 do 
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_recharge_everyday_gift_box_"..i), nil, 
        {
            terminal_name = "sm_activity_recharge_everyday_gift_look_gift",
            terminal_state = 0,
            index = i,
            touch_black = true,
            cell = self,
        },
        nil,3)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recruit_card_send_rec"), nil, 
    {
        terminal_name = "sm_activity_recharge_everyday_gift_get_reward",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true,
        cell = self,
    },
    nil,3)

end

function SmActivityRechargeEverydayGift:onExit()
    -- state_machine.remove("sm_activity_recharge_everyday_gift_window_update_draw")
    -- state_machine.remove("sm_activity_recharge_everyday_gift_look_gift")
    -- state_machine.remove("sm_activity_recharge_everyday_gift_get_reward") 
end

function SmActivityRechargeEverydayGift:createCell()
    local cell = SmActivityRechargeEverydayGift:new()
    cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell, 0.5)
    return cell
end