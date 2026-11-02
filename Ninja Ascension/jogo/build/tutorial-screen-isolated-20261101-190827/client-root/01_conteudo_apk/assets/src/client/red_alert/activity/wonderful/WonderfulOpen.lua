-----------------------------
-- 开服狂欢
-----------------------------
WonderfulOpen = class("WonderfulOpenClass", Window)

local wonderful_open_window_open_terminal = {
    _name = "wonderful_open_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- 活动动画资源加载
        for i, v in pairs(config_res.sprites_cached["wonderful"]) do
            cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
        end
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if _ED.activity_info ~= nil then
                    if nil == fwin:find("WonderfulOpenClass") then
                        fwin:open(WonderfulOpen:new():init(params), fwin._ui)
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

local wonderful_open_window_close_terminal = {
    _name = "wonderful_open_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WonderfulOpenClass"))

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

state_machine.add(wonderful_open_window_open_terminal)
state_machine.add(wonderful_open_window_close_terminal)
state_machine.init()

function WonderfulOpen:ctor()
    self.super:ctor()
    self.roots = {}

    -- var 活动数据
    self._activity_datas = {}
    -- 活动界面
    self._activity_panle = {}
    --左侧列表table
    self._activity_left_cells = {}
    --load lua file
    app.load("client.red_alert.activity.wonderful.TopupReward")
    app.load("client.red_alert.activity.wonderful.SevenDay")
    app.load("client.red_alert.activity.wonderful.UpLevel")
    app.load("client.red_alert.activity.wonderful.ConfirmReward")
    app.load("client.red_alert.activity.wonderful.FightReward")
    app.load("client.red_alert.activity.wonderful.AccumlateConsumption")
    app.load("client.red_alert.cells.activity.wonderful.open_active_left_cell")
    app.load("client.red_alert.cells.activity.wonderful.famous_general_cell")
    app.load("client.red_alert.cells.activity.wonderful.change_props_cell")
    app.load("client.red_alert.activity.wonderful.ActivityPopRecharge")
    app.load("client.red_alert.activity.wonderful.WonderfulTrialtower")
    app.load("client.red_alert.activity.wonderful.FourteenDays")
    app.load("client.red_alert.activity.wonderful.WonderfulEquip")
    app.load("client.red_alert.activity.wonderful.WonderfulTourneyfield")
    app.load("client.red_alert.activity.wonderful.WonderfulHeroUp")
    app.load("client.red_alert.activity.wonderful.NowdayTopupReward")

    -- Initialize wonderful_open state machine.
    local function init_wonderful_open_terminal()
	
		--切换活动
		local wonderful_open_show_activity_by_type_terminal = {
            _name = "wonderful_open_show_activity_by_type",
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
        local wonderful_open_set_un_select_terminal = {
            _name = "wonderful_open_set_un_select",
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
        local wonderful_open_remove_page_terminal = {
            _name = "wonderful_open_remove_page",
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
        local wonderful_open_update_by_terminal = {
            _name = "wonderful_open_update_by",
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
        local wonderful_open_move_list_view_position_terminal = {
            _name = "wonderful_open_move_list_view_position",
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

		state_machine.add(wonderful_open_show_activity_by_type_terminal)	
        state_machine.add(wonderful_open_set_un_select_terminal)
        state_machine.add(wonderful_open_remove_page_terminal)
        state_machine.add(wonderful_open_update_by_terminal)
        state_machine.add(wonderful_open_move_list_view_position_terminal)
        state_machine.init()
    end
    
    -- call func init sign_in state machine.
    init_wonderful_open_terminal()
end

function WonderfulOpen:setUnSelcet()
    for i,cell in pairs(self._activity_left_cells) do
        if cell ~= nil and cell.setSelect ~= nil then
            cell._select = false
            cell:setSelect()
        end
    end
end

function WonderfulOpen:changeActivityShow(activity_type)
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
        if activity_type == 3 then      -- 战力达成
            state_machine.excute("fight_reward_set_positiony",0,"")
        elseif activity_type == 4 then  -- 闯关奖励
            state_machine.excute("confirm_reward_set_positiony",0,"")
        elseif activity_type == 6 then  -- 冲击奖励
            state_machine.excute("up_level_set_positiony",0,"")
        elseif activity_type == 12 then -- 累计充值
            state_machine.excute("topup_reward_set_positiony",0,"")
        elseif activity_type == 26 then -- 侠客行
            state_machine.excute("wonderful_trialtower_set_positiony", 0, "")
        elseif activity_type == 28 then -- 华山论剑
            state_machine.excute("wonderful_tourneyfield_set_positiony", 0, "")
        elseif activity_type == 29 then -- 装备强化
            state_machine.excute("wonderful_equip_set_positiony", 0, "")
        elseif activity_type == 30 then -- 侠客培养
            state_machine.excute("wonderful_hero_up_set_positiony", 0, "")
        end
    end
   
    if self._activity_panle[""..activity_type] ~= nil then
        self._activity_panle[""..activity_type]:setVisible(true)
    end
end

function WonderfulOpen:moveListViewPosition(params)
    local root = self.roots[1]
    local move_x = params[1]
    local move_y = params[2]
    local ListView_wonderful_label = ccui.Helper:seekWidgetByName(root,"ListView_wonderful_label")
    -- ListView_wonderful_label:scrollToPercentBothDirection(cc.p(move_x,move_y),0.5,true)
    ListView_wonderful_label:getInnerContainer():setPosition(cc.p(move_x,move_y))
end

--刷新背景
function WonderfulOpen:onUpdateBy(activity_type)
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

function WonderfulOpen:createPanelBy(activity_type)
    local root = self.roots[1]
    local Panel_wonderful_page = ccui.Helper:seekWidgetByName(root,"Panel_wonderful_page")
    local activity_panel = nil
    if activity_type == 3 then  -- 战力达成
        activity_panel = state_machine.excute("fight_reward_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 4 then  -- 闯关奖励
        activity_panel = state_machine.excute("confirm_reward_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 6 then  -- 冲击奖励
        activity_panel = state_machine.excute("up_level_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 7 then  -- 七天
        activity_panel = state_machine.excute("seven_day_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 12 then --累计充值
        activity_panel = state_machine.excute("topup_reward_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 19 then -- 五倍返
        activity_panel = state_machine.excute("activity_pop_recharge_window_open",0,{nil,Panel_wonderful_page})
    elseif activity_type == 26 then -- 侠客行
        activity_panel = state_machine.excute("wonderful_trialtower_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 27 then -- 十四天活动
        activity_panel = state_machine.excute("fourteen_days_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 28 then -- 华山论剑
        activity_panel = state_machine.excute("wonderful_tourneyfield_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 29 then -- 装备强化
        activity_panel = state_machine.excute("wonderful_equip_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 30 then -- 侠客培养
        activity_panel = state_machine.excute("wonderful_hero_up_window_open",0,{Panel_wonderful_page})
    elseif activity_type == 32 then -- 今日充值福利
        activity_panel = state_machine.excute("nowday_topup_reward_window_open",0,{Panel_wonderful_page})
    end
    self._activity_panle[""..activity_type] = activity_panel
end

function WonderfulOpen:removeActivityPanel(activity_type)
    if self._activity_panle[""..activity_type] ~= nil then
        self._activity_panle[""..activity_type]:removeFromParent(true)
        self._activity_panle[""..activity_type] = nil
    end
end

function WonderfulOpen:removeActivityPage(activity_type)
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
    if cell ~= self._activity_left_cells[1] then
        state_machine.excute("open_active_left_cell_click",0,{_datas = { cell = self._activity_left_cells[1]}})
    else
        state_machine.excute("home_button_activity_update_button_state", 0, nil)
        state_machine.excute("wonderful_open_window_close", 0, 0)
    end
end

function WonderfulOpen:onUpdateDraw()
    -- debug.print_r(_ED.activity_info["8"])
    local root = self.roots[1]
    local ListView_wonderful_label = ccui.Helper:seekWidgetByName(root,"ListView_wonderful_label")
    local index = 1
    for i,v in pairs(self._activity_datas) do
        local cell = state_machine.excute("open_active_left_create_cell",0,{v.activity_type,index})
        ListView_wonderful_label:addChild(cell)
        if index == 1 then
            state_machine.excute("open_active_left_cell_click",0,{_datas = { cell = cell}})
        end
        table.insert(self._activity_left_cells,cell)
        index = index + 1
    end
    self._list_view = ListView_wonderful_label
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function WonderfulOpen:onUpdate(dt)
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

function WonderfulOpen:onEnterTransitionFinish()
    
end

function WonderfulOpen:onInit()
    local csbItem = csb.createNode(config_csb.activity.wonderful.wonderful_open)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_wonderful_close"), nil, 
    {
        terminal_name = "wonderful_open_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()
end

function WonderfulOpen:initActivityDatas()
    for i,v in pairs(_ED.activity_info) do
        local activity_type = tonumber(v.activity_type)
        if activity_type == 1 then              -- 月卡
        elseif activity_type == 2 then          -- 首冲
        elseif activity_type == 5 then          -- 元宝大放送
        elseif activity_type == 8 then          -- 名将招募
        elseif activity_type == 9 then          -- 成长计划VIP2
        elseif activity_type == 11 then         -- 活跃奖励
        elseif activity_type == 13 then         -- 单笔充值
        elseif activity_type == 14 then         -- 邀请好友
        elseif activity_type == 15 then         -- 签到
        elseif activity_type == 16 then         -- cdkey
        elseif activity_type == 17 then         -- 杂货铺
        elseif activity_type == 18 then         -- VIP礼包
        elseif activity_type == 20 then         -- 累积消费
        elseif activity_type == 21 then         -- 每日三签
        elseif activity_type == 22 then         -- 积分转盘
        elseif activity_type == 23 then         -- 开服冲Top
        elseif activity_type == 24 then         --成长计划VIP3
        elseif activity_type == 25 then         --成长计划VIP4
        elseif activity_type == 31 then         -- 累积充值(常驻活动)
        elseif activity_type == 33 then         -- 豪华签到
        elseif activity_type == 34 then         -- 特惠礼包
        elseif activity_type == 35 then         -- 特惠礼包
        elseif activity_type == 36 then         -- 每月充值福利
        elseif activity_type == 37 then         -- 元宝大转盘
        elseif activity_type == 38 then         -- 十连抽送碎片
        elseif activity_type == 39 then         -- 渠道定制活动
        elseif activity_type == 40 then         -- 开服冲Top(2号)
        elseif activity_type == 41 then         -- 单笔充值2
        elseif activity_type == 42 then         -- 全服积分大转盘
        elseif activity_type == 43 then         -- 登陆送
        elseif activity_type == 7 or activity_type == 27 then
            local index = 0 
            local activity_data = _ED.activity_info[""..v.activity_type].activity_data
            for k,v in pairs(activity_data) do
                for k1,v1 in pairs(v) do
                    if tonumber(v1.achieve_state) == 2 then 
                        index = index + 1 
                    end
                end
            end 
            if index == #activity_data then
            else
                v.value = dms.int(dms["activity_param"],v.activity_type,activity_param.types)
                table.insert(self._activity_datas,v)
            end
        elseif activity_type == 32 then         -- 今日充值福利
            v.value = dms.int(dms["activity_param"],v.activity_type,activity_param.types)
            table.insert(self._activity_datas,v)
        else
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
                -- 开服狂欢
                if v.value >= 20000 and v.value < 30000 then
                    table.insert(self._activity_datas,v)
                end
            end
        end
    end

    for i,v in pairs(self._activity_datas) do
        local id =  v.activity_type
        v.value = dms.int(dms["activity_param"],id,activity_param.types)
    end


    local function sortTable( a, b )
        return tonumber(a.value) < tonumber(b.value)
    end

    table.sort(self._activity_datas,sortTable)
end

function WonderfulOpen:init(params)
    self:initActivityDatas()
	self:onInit()
    if params ~= nil then
        state_machine.excute("wonderful_open_set_un_select",0,"")
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
        state_machine.excute("wonderful_open_show_activity_by_type",0,{params})
        state_machine.excute("wonderful_open_update_by",0,{params})
    end
    return self
end

function WonderfulOpen:onExit()
    state_machine.remove("wonderful_open_show_activity_by_type")
    state_machine.remove("wonderful_open_set_un_select")
    state_machine.remove("wonderful_open_remove_page")
    state_machine.remove("wonderful_open_update_by")
    state_machine.remove("wonderful_open_move_list_view_position")
end
