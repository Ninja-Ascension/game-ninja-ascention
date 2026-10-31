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
        if funOpenDrawTip(56) == true then
            return
        end    
        -- 活动动画资源加载
        for i, v in pairs(config_res.sprites_cached["wonderful"]) do
            cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
        end
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if _ED.activity_info ~= nil then
                    if nil == fwin:find("WonderfulClass") then
                        fwin:open(Wonderful:new():init(params), fwin._ui)
                    end

                    -- state_machine.excute("main_window_hide", 0, "")
                    -- state_machine.excute("player_resource_window_hide", 0, "")     
                    -- state_machine.excute("home_button_for_action_window_hide",0,"")
                    -- state_machine.excute("chat_view_window_hide",0,"")  
                    -- state_machine.excute("duplicate_title_window_hide",0,"")
                end
            end
        end
        if _ED.activity_have_new == true or _ED.activity_info == nil then
            NetworkManager:register(protocol_command.activity_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        else
            responseCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 1})
        end
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
        fwin:close(fwin:find("WonderfulClass"))

        state_machine.excute("main_window_open",0,"")
        state_machine.excute("player_resource_window_show",0,"")   
        state_machine.excute("home_button_for_action_window_show",0,"")  
        state_machine.excute("chat_view_window_show",0,"")
        state_machine.excute("duplicate_title_window_show",0,"")
      
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(wonderful_window_open_terminal)
state_machine.add(wonderful_window_close_terminal)
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
    --load lua file
    app.load("client.red_alert.activity.wonderful.ActiveReward")
    app.load("client.red_alert.activity.wonderful.ExchangeReward")
    app.load("client.red_alert.activity.wonderful.OnCard")
    app.load("client.red_alert.activity.wonderful.FirstCharge")
    app.load("client.red_alert.activity.wonderful.ChangeProps")
    app.load("client.red_alert.activity.wonderful.WingSent")
    app.load("client.red_alert.activity.wonderful.GrowthPlan")
    app.load("client.red_alert.activity.wonderful.GrowthPlanThree")
    app.load("client.red_alert.activity.wonderful.GrowthPlanFour")
    app.load("client.red_alert.activity.wonderful.FamousGeneral")
    app.load("client.red_alert.activity.wonderful.AccumlateConsumption")
    app.load("client.red_alert.cells.activity.wonderful.active_left_cell")
    app.load("client.red_alert.cells.activity.wonderful.famous_general_cell")
    app.load("client.red_alert.cells.activity.wonderful.change_props_cell")
    app.load("client.red_alert.activity.wonderful.InvitationFriend")
    app.load("client.red_alert.activity.wonderful.ActivitySign")
    app.load("client.red_alert.activity.wonderful.OneRecharge")
    app.load("client.red_alert.activity.wonderful.AccumulatedTopup")
    app.load("client.red_alert.activity.wonderful.LuxurySign")
    app.load("client.red_alert.activity.wonderful.MonthlyTopupReward")
    app.load("client.red_alert.activity.wonderful.SpecialGift")
    app.load("client.red_alert.activity.wonderful.SpecialGiftHigh")
    app.load("client.red_alert.activity.wonderful.WonderfulSendPieces")
    app.load("client.red_alert.activity.wonderful.WonderfulDailySign")
    app.load("client.red_alert.activity.wonderful.WonderfulRechargeRebate")
    app.load("client.red_alert.activity.wonderful.UpLevelTwo")
    app.load("client.red_alert.activity.wonderful.OneRechargeTwo")
    
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
        local wonderful_update_first_terminal = {
            _name = "wonderful_update_first",
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
                                state_machine.excute("active_left_cell_update_draw", 0, cell)
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
        state_machine.add(wonderful_update_first_terminal)
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
    if self._activity_panle["8"] ~= nil then
        self._activity_panle["8"]:removeFromParent(true)
        -- table.remove(self._activity_panle,8) 
        self._activity_panle["8"] = nil
        state_machine.excute("famous_general_window_close",0,"")
    end
    for i,panel in pairs(self._activity_panle) do
        panel:setVisible(false)
    end
    
    if self._activity_panle[""..activity_type] == nil then
        local activity_panel = self:createPanelBy(activity_type)
    else
        if activity_type == 5 then  -- 元宝大放送
            state_machine.excute("wing_sent_set_positiony",0,"")
        elseif activity_type == 8 then  -- 名将招募
            state_machine.excute("famous_general_set_positiony",0,"")
            state_machine.excute("famous_general_play_actions",0,"")
        elseif activity_type == 9 then  -- 成长计划VIP2
            state_machine.excute("growth_plan_set_positiony",0,"")
        elseif activity_type == 11 then -- 活跃奖励
            state_machine.excute("active_reward_set_positiony",0,"")
        elseif activity_type == 13 then -- 单笔充值
            state_machine.excute("one_recharge_set_positiony",0,"")
        elseif activity_type == 14 then -- 邀请好友
            state_machine.excute("invitation_friend_set_positiony",0,"")
        elseif activity_type == 17 then -- 杂货铺
            state_machine.excute("change_props_set_positiony", 0, "")
        elseif activity_type == 20 then -- 累积消费
            state_machine.excute("accumlate_consumption_set_positiony", 0, "")
        elseif activity_type == 24 then -- 成长计划VIP3
            state_machine.excute("growth_plan_three_set_positiony",0,"")
        elseif activity_type == 25 then -- 成长计划VIP4
            state_machine.excute("growth_plan_four_set_positiony",0,"")
        elseif activity_type == 31 then -- 累积充值(常驻活动)
            state_machine.excute("accumulated_topup_set_positiony",0,"")
        elseif activity_type == 36 then -- 每月充值福利
            state_machine.excute("monthly_topup_reward_set_positiony",0,"")
        elseif activity_type == 39 then -- 渠道定制活动
            state_machine.excute("up_level_two_set_positiony",0,"")
        elseif activity_type == 41 then  -- 单笔充值2
            state_machine.excute("one_recharge_two_set_positiony",0,"")
        elseif activity_type == 43 then  -- 登录送
            state_machine.excute("wonderful_daily_sign_set_positionx",0,"")
        end
    end
   
    if self._activity_panle[""..activity_type] ~= nil then
        self._activity_panle[""..activity_type]:setVisible(true)
    end
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
    local Image_wonderful_7 = ccui.Helper:seekWidgetByName(root,"Image_wonderful_7")
    local Image_wonderful_first_charge = ccui.Helper:seekWidgetByName(root,"Image_wonderful_first_charge")
    local Image_wonderful_genral = ccui.Helper:seekWidgetByName(root,"Image_wonderful_genral")
    Image_wonderful_7:setVisible(false)
    Image_wonderful_first_charge:setVisible(false)
    Image_wonderful_genral:setVisible(false)
    if activity_type == 2 then
        Image_wonderful_7:setVisible(false)
        Image_wonderful_first_charge:setVisible(true)
        Image_wonderful_genral:setVisible(false)
    elseif activity_type == 8 then
        Image_wonderful_7:setVisible(false)
        Image_wonderful_first_charge:setVisible(false)
        Image_wonderful_genral:setVisible(true)
    else
        Image_wonderful_7:setVisible(true)
        Image_wonderful_first_charge:setVisible(false)
        Image_wonderful_genral:setVisible(false)
    end
end

function Wonderful:createPanelBy(activity_type)
    local root = self.roots[1]
    local Panel_wonderful_page = ccui.Helper:seekWidgetByName(root,"Panel_wonderful_page")
    local activity_panel = nil
    if activity_type == 1 then      -- 月卡
        activity_panel = state_machine.excute("on_card_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 2 then  -- 首冲
        activity_panel = state_machine.excute("first_charge_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 5 then  -- 元宝大放送
        activity_panel = state_machine.excute("wing_sent_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 8 then  -- 名将招募
        activity_panel = state_machine.excute("famous_general_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 9 then  -- 成长计划VIP2
        activity_panel = state_machine.excute("growth_plan_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 11 then -- 活跃奖励
        activity_panel = state_machine.excute("active_reward_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 13 then --单笔充值
        activity_panel = state_machine.excute("one_recharge_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 14 then --邀请好友
        activity_panel = state_machine.excute("invitation_friend_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 15 then -- 签到
        activity_panel = state_machine.excute("activity_sign_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 16 then -- cdkey
        activity_panel = state_machine.excute("exchange_reward_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 17 then -- 杂货铺
        activity_panel = state_machine.excute("change_props_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 20 then -- 累积消费
        activity_panel = state_machine.excute("accumlate_consumption_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 21 then -- 每日三签
        activity_panel = state_machine.excute("activity_third_sign_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 24 then --成长计划VIP3
        activity_panel = state_machine.excute("growth_plan_three_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 25 then --成长计划VIP4
        activity_panel = state_machine.excute("growth_plan_four_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 31 then --累积充值(常驻活动)
        activity_panel = state_machine.excute("accumulated_topup_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 33 then --豪华签到
        activity_panel = state_machine.excute("luxury_sign_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 34 then --特惠礼包
        activity_panel = state_machine.excute("special_gift_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 35 then --特惠礼包高级
        activity_panel = state_machine.excute("special_gift_high_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 36 then --每月充值福利
        activity_panel = state_machine.excute("monthly_topup_reward_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 38 then -- 十连抽送碎片
        activity_panel = state_machine.excute("wonderful_send_pieces_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 39 then  -- 冲击奖励(特殊渠道)
        activity_panel = state_machine.excute("up_level_two_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 41 then -- 单笔充值2
        activity_panel = state_machine.excute("one_recharge_two_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 43 then -- 登陆送
        activity_panel = state_machine.excute("wonderful_daily_sign_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 1001 then -- 内测返利
        activity_panel = state_machine.excute("wonderful_recharge_rebate_window_open",0,{Panel_wonderful_page})
    end
    self._activity_panle[""..activity_type] = activity_panel
end

function Wonderful:removeActivityPanel(activity_type)
    if self._activity_panle[""..activity_type] ~= nil then
        self._activity_panle[""..activity_type]:removeFromParent(true)
        self._activity_panle[""..activity_type] = nil
    end
end

function Wonderful:removeActivityPage(activity_type)
    local root = self.roots[1]
    local ListView_wonderful_label = ccui.Helper:seekWidgetByName(root,"ListView_wonderful_label")
    for i,cell in pairs(self._activity_left_cells) do
        if tonumber(cell._activity_type) == tonumber(activity_type) then
            table.remove(self._activity_left_cells,i)
            ListView_wonderful_label:removeItem(ListView_wonderful_label:getIndex(cell))
        end
    end
    _ED.activity_info[""..activity_type] = nil
    ListView_wonderful_label:requestRefreshView()
    state_machine.excute("active_left_cell_click",0,{_datas = { cell = self._activity_left_cells[1]}})
end

function Wonderful:onUpdateDraw()
    -- debug.print_r(_ED.activity_info["8"])
    local root = self.roots[1]
    local ListView_wonderful_label = ccui.Helper:seekWidgetByName(root,"ListView_wonderful_label")
    local index = 1
    for i,v in pairs(self._activity_datas) do
        local cell = state_machine.excute("active_left_create_cell",0,{v.activity_type,index})
        ListView_wonderful_label:addChild(cell)
        if index == 1 then
            state_machine.excute("active_left_cell_click",0,{_datas = { cell = cell}})
        end
        table.insert(self._activity_left_cells,cell)
        index = index + 1
    end

    self._list_view = ListView_wonderful_label
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function Wonderful:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function Wonderful:onEnterTransitionFinish()
    
end

function Wonderful:onInit()
    -- debug.print_r(_ED.activity_info["40"])
    local csbItem = csb.createNode(config_csb.activity.wonderful.wonderful)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_wonderful_close"), nil, 
    {
        terminal_name = "wonderful_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()
end

function Wonderful:initActivityDatas()
    for i,v in pairs(_ED.activity_info) do
        local activity_type = tonumber(v.activity_type)
        if activity_type == 3 then              -- 战力达成
        elseif activity_type == 2 then          -- 首冲
        elseif activity_type == 4 then          -- 闯关奖励
        elseif activity_type == 6 then          -- 冲级奖励
        elseif activity_type == 7 then          -- 七天乐
        elseif activity_type == 12 then         -- 累积充值
        elseif activity_type == 18 then         -- VIP礼包
        elseif activity_type == 19 then         -- 98五倍返
        elseif activity_type == 22 then         -- 积分转盘
        elseif activity_type == 23 then         -- 开服冲Top
        elseif activity_type == 26 then         -- 侠客行
        elseif activity_type == 27 then         -- 十四天活动
        elseif activity_type == 28 then         -- 华山论剑
        elseif activity_type == 29 then         -- 装备强化
        elseif activity_type == 30 then         -- 侠客培养
        elseif activity_type == 32 then         -- 今日充值福利
        elseif activity_type == 37 then         -- 元宝大转盘
        elseif activity_type == 40 then         -- 开服冲Top(2号)
        elseif activity_type == 42 then         -- 全服积分大转盘
        elseif activity_type == 9 or activity_type == 24 or activity_type == 25 then
            local index = 0 
            local activity_data = _ED.activity_info[""..v.activity_type].activity_data[2]
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
        elseif activity_type == 13 
            or activity_type == 31
            or activity_type == 34
            or activity_type == 35
            then
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
        elseif activity_type == 39 then
            local page = tonumber(zstring.split(_ED.activity_info["39"].activity_add_state, ",")[1]) + 1
            if table.nums(_ED.activity_info["39"].activity_data[page]) > 0 then
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
    if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
        local card_data = {
            activity_type = "1",
            value = dms.int(dms["activity_param"],1,activity_param.types),
        }

        local cdkey_code_data = {
            activity_type = "16",
            value = dms.int(dms["activity_param"],16,activity_param.types),
        }

        if _ED.user_open_server_recharge_rebate_info ~= nil
            and _ED.user_open_server_recharge_rebate_info.recharge_money ~= nil 
            and _ED.user_open_server_recharge_rebate_info.vip_exp ~= nil 
            then
            local activity_type = 1001
            local index_type = 0
            for i,v in pairs(dms["activity_param"]) do
                if dms.int(dms["activity_param"],i,activity_param.id) == activity_type then
                    index_type = dms.int(dms["activity_param"],i,activity_param.types)
                    break
                end
            end
            local register_data = {
                activity_type = ""..activity_type,
                value = index_type,
            }
            table.insert(self._activity_datas,register_data) 
        end
        table.insert(self._activity_datas,card_data)          --3：月卡
        table.insert(self._activity_datas,cdkey_code_data)           --cdkey
    end
    -- for i,v in pairs(self._activity_datas) do
    --     debug.print_r(v)
    --     local id =  v.activity_type
    --     v.value = dms.int(dms["activity_param"],id,activity_param.types)
    -- end


    local function sortTable( a, b )
        return tonumber(a.value) < tonumber(b.value)
    end

    table.sort(self._activity_datas,sortTable)
end

function Wonderful:init(params)
    self:initActivityDatas()
	self:onInit()
    if params ~= nil then
        state_machine.excute("wonderful_set_un_select",0,"")
        for i,cell in pairs(self._activity_left_cells) do
            if cell ~= nil and cell.setSelect ~= nil then
                cell._select = false
                cell:setSelect()
            end
            if tonumber(cell._activity_type) == tonumber(params) then
                cell._select = true
                cell:setSelect()
            end
        end
        state_machine.excute("wonderful_show_activity_by_type",0,{params})
        state_machine.excute("wonderful_update_by",0,{params})
    end
    return self
end

function Wonderful:onExit()
    state_machine.remove("wonderful_show_activity_by_type")
    state_machine.remove("wonderful_set_un_select")
    state_machine.remove("wonderful_remove_page")
    state_machine.remove("wonderful_update_by")
    state_machine.remove("wonderful_move_list_view_position")
    state_machine.remove("wonderful_update_first")
end
