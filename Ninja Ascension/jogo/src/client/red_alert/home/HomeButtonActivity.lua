--------------------------------------------------------------------------------------------------------------
--  说明：主页面按钮
--------------------------------------------------------------------------------------------------------------
HomeButtonActivity = class("HomeButtonActivityClass", Window)

local home_button_activity_window_open_terminal = {
	_name = "home_button_activity_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local _HomeButtonActivityWindow = fwin:find("HomeButtonActivityClass")
        if nil == _HomeButtonActivityWindow and config_csb.home.home_button_1 ~= nil then      
    		fwin:open(HomeButtonActivity:new():init(), fwin._frameview)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local home_button_activity_window_close_terminal = {
	_name = "home_button_activity_window_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HomeButtonActivityClass"))
        -- clear cacher
        cacher.clearWindowCacher()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(home_button_activity_window_open_terminal)
state_machine.add(home_button_activity_window_close_terminal)
state_machine.init()

function HomeButtonActivity:ctor()
	self.super:ctor()
	self.roots = {}

    app.load("client.red_alert.activity.wonderful.ActivityThirdSign")
    app.load("client.red_alert.activity.wonderful.ActivityCostRotary")
    app.load("client.red_alert.cells.home.home_button_cell")
    app.load("client.red_alert.activity.server_top_rank.ServerTopRank")
    app.load("client.red_alert.activity.wonderful.WonderfulOpen")
    app.load("client.red_alert.activity.wonderful.ActivityCostRotaryAll")
    app.load("client.red_alert.activity.wonderful.ActivityCostRotaryRank")

    local function init_home_button_activity_terminal()
		local home_button_activity_choose_card_terminal = {
            _name = "home_button_activity_choose_card",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("wonderful_window_open", 0, 1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_button_activity_update_button_state_terminal = {
            _name = "home_button_activity_update_button_state",
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

		state_machine.add(home_button_activity_choose_card_terminal)
        state_machine.add(home_button_activity_update_button_state_terminal)
        state_machine.init()
    end
    
    init_home_button_activity_terminal()
end

function HomeButtonActivity:updateDraw()
    local root = self.roots[1]
    local ListView_wonderful = ccui.Helper:seekWidgetByName(root, "ListView_wonderful")
    ListView_wonderful:removeAllItems()
    if _ED.activity_info["2"] ~= nil then
        if funOpenDrawTip(135, false) == false then
            local cell = state_machine.excute("home_button_cell_create", 0, {2})
            ListView_wonderful:addChild(cell)
        end 
    end
    local cell = nil
    local needCreateWonderfulOpen = false
    for i,v in pairs(_ED.activity_info) do
        if tonumber(v.activity_type) == 1 then              -- 月卡
        elseif tonumber(v.activity_type) == 2 then          -- 首冲
        elseif tonumber(v.activity_type) == 5 then          -- 元宝大放送
        elseif tonumber(v.activity_type) == 8 then          -- 名将招募
        elseif tonumber(v.activity_type) == 9 then          -- 成长计划VIP2
        elseif tonumber(v.activity_type) == 11 then         -- 活跃奖励
        elseif tonumber(v.activity_type) == 13 then         -- 单笔充值
        elseif tonumber(v.activity_type) == 14 then         -- 邀请好友
        elseif tonumber(v.activity_type) == 15 then         -- 签到
        elseif tonumber(v.activity_type) == 16 then         -- cdkey
        elseif tonumber(v.activity_type) == 17 then         -- 杂货铺
        elseif tonumber(v.activity_type) == 18 then         -- VIP礼包
        elseif tonumber(v.activity_type) == 20 then         -- 累积消费
        elseif tonumber(v.activity_type) == 21 then         -- 每日三签
        elseif tonumber(v.activity_type) == 22 then         -- 积分转盘
        elseif tonumber(v.activity_type) == 23 then         -- 开服冲Top
        elseif tonumber(v.activity_type) == 24 then         --成长计划VIP3
        elseif tonumber(v.activity_type) == 25 then         --成长计划VIP4
        elseif tonumber(v.activity_type) >= 33 then
        elseif tonumber(v.activity_type) == 7 or tonumber(v.activity_type) == 27 then
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
                needCreateWonderfulOpen = true
                break
            end
            
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
                    needCreateWonderfulOpen = true
                    break
                end
            end
        end
    end
    if true == needCreateWonderfulOpen then
        cell = state_machine.excute("home_button_cell_create", 0, {100})
        ListView_wonderful:addChild(cell)
    end
    if _ED.activity_info["22"] ~= nil then
        local cell = state_machine.excute("home_button_cell_create", 0, {22})
        ListView_wonderful:addChild(cell)
    end
    if _ED.activity_info["23"] ~= nil then
        local cell = state_machine.excute("home_button_cell_create", 0, {23})
        ListView_wonderful:addChild(cell)
    end
    if _ED.activity_info["40"] ~= nil then
        local cell = state_machine.excute("home_button_cell_create", 0, {40})
        ListView_wonderful:addChild(cell)
    end
    if _ED.activity_info["37"] ~= nil then
        local cell = state_machine.excute("home_button_cell_create", 0, {37})
        ListView_wonderful:addChild(cell)
    end
    if _ED.activity_info["39"] ~= nil then
        local page = tonumber(zstring.split(_ED.activity_info["39"].activity_add_state, ",")[1]) + 1
        if table.nums(_ED.activity_info["39"].activity_data[page]) > 0 then
            local cell = state_machine.excute("home_button_cell_create", 0, {39})
            ListView_wonderful:addChild(cell)
        end
    end
    if _ED.activity_info["42"] ~= nil then          -- 积分大转盘排行榜
        local cell = state_machine.excute("home_button_cell_create", 0, {42})
        ListView_wonderful:addChild(cell)
    end
end

function HomeButtonActivity:onInit()
    local csbItem = csb.createNode(config_csb.home.home_button_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_charge"), nil, 
    {
        terminal_name = "recharge_dialog_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_button_activity_top_up",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_charge"),
    _invoke = nil,
    _interval = 0.5,})

    -- 月卡
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_on_card"), nil, 
    {
        terminal_name = "home_button_activity_choose_card",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)

	self:updateDraw()
end

function HomeButtonActivity:onEnterTransitionFinish()

end

function HomeButtonActivity:init()
	self:onInit()
    return self
end

function HomeButtonActivity:close( ... )
    local root = self.roots[1]
    local ListView_wonderful = ccui.Helper:seekWidgetByName(root, "ListView_wonderful")
    ListView_wonderful:removeAllItems()
end

function HomeButtonActivity:onExit()
    state_machine.remove("home_button_activity_choose_card")
    state_machine.remove("home_button_activity_update_button_state")
end