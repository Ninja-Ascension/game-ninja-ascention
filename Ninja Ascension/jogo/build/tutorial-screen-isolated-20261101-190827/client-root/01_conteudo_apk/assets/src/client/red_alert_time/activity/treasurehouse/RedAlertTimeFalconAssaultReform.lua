--------------------------------------------------------------------------------------------------------------
--  猎鹰突击改造
--------------------------------------------------------------------------------------------------------------
RedAlertTimeFalconAssaultReform = class("RedAlertTimeFalconAssaultReformClass", Window)

--打开界面
local red_alert_time_falcon_assault_reform_open_terminal = {
    _name = "red_alert_time_falcon_assault_reform_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = RedAlertTimeFalconAssaultReform:new():init(params)
        fwin:open(panel)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_falcon_assault_reform_open_terminal)
state_machine.init()

function RedAlertTimeFalconAssaultReform:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- 定义变量
    self._activity_type = 0

    self._is_end = false
    self.m_times = 0
    self.m_reset_times = 0
    self._label_close_text = nil
    self._label_reset_text = nil

    -- 加载lua文件
    app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_falcon_assault_cell")
    
    -- 初始化状态机
    local function init_red_alert_time_falcon_assault_reform_terminal()
        local red_alert_time_falcon_assault_reform_show_terminal = {
            _name = "red_alert_time_falcon_assault_reform_show",
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

        local red_alert_time_falcon_assault_reform_hide_terminal = {
            _name = "red_alert_time_falcon_assault_reform_hide",
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
        local red_alert_time_falcon_assault_reform_update_draw_terminal = {
            _name = "red_alert_time_falcon_assault_reform_update_draw",
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

        local red_alert_time_falcon_assault_reform_get_rule_terminal = {
            _name = "red_alert_time_falcon_assault_reform_get_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance._activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_falcon_assault_reform_update_draw_terminal)
        state_machine.add(red_alert_time_falcon_assault_reform_hide_terminal)
        state_machine.add(red_alert_time_falcon_assault_reform_show_terminal)
        state_machine.add(red_alert_time_falcon_assault_reform_get_rule_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_falcon_assault_reform_terminal()
end

function RedAlertTimeFalconAssaultReform:updateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type]
    local activity_add_state = {}
    local tank_ids = {}
    if tonumber(self._activity_type) == 20000 then
        -- 猎鹰突击
        -- activity_add_state = "活动起始时间,活动关闭时间,当前时间，坦克id， 改造坦克id，已使用免费次数 ,每日免费次数，单次抽取金币，10连抽金币，折扣，10连抽原价
        --                       !收集记录记录(没有时为0)"
        local activity_add_state_arr = zstring.split(activity_info.activity_add_state, "!")
        activity_add_state = zstring.split(activity_add_state_arr[1], ",")
        table.insert(tank_ids, tonumber(activity_add_state[5]))
    elseif tonumber(self._activity_type) == 99 then
        -- 极限突破
        -- activity_add_state = "开始时间,结束时间,领奖时间,免费次数,免费最大次数,单抽金币,10连金币,超级实验金币,折扣,10连原价,超级实验剩余次数,超级实验最大次数,超级实验需要VIP等级,核心1id，核心2id，改造坦克1id，改造坦克2id
        --                     !获奖记录(没有时为0)"    
        local activity_add_state_arr = zstring.split(activity_info.activity_add_state, "!")
        activity_add_state = zstring.split(activity_add_state_arr[1], ",")
        table.insert(tank_ids, tonumber(activity_add_state[16]))
        table.insert(tank_ids, tonumber(activity_add_state[17]))
    end

    local ScrollView_festival_each_child = ccui.Helper:seekWidgetByName(root,"ScrollView_festival_each_child")
    ScrollView_festival_each_child:removeAllChildren(true)

    local cell_tables = {}
    local cell_size = nil
    local total_col = 2
    for k, v in pairs(tank_ids) do
        local cell = state_machine.excute("red_alert_time_falcon_assault_cell_create", 0, {k, v})
        ScrollView_festival_each_child:addChild(cell)
        table.insert(cell_tables, cell)
        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
    end

    local count = #cell_tables
    if count > 0 then
        local size = ScrollView_festival_each_child:getContentSize()
        local height = cell_size.height * math.ceil(count / total_col)
        local width = size.width / total_col
        if height > size.height then
            size.height = height
            ScrollView_festival_each_child:setInnerContainerSize(size)
        end

        for k, v in pairs(cell_tables) do
            local row = math.floor((k - 1) % total_col) + 1
            local col = math.floor((k - 1) / total_col) + 1
            local posX = size.width * row / total_col - width / 2 - cell_size.width / 2
            local posY = size.height - cell_size.height * col
            v:setPosition(posX, posY)
        end
    end

    -- 显示倒计时
    self._is_end = false
    if tonumber(activity_add_state[3]/1000) - (os.time() + _ED.time_add_or_sub) < 0 then
        self._is_end = true
    end

    local time_str = activity_str_tip[93]
    if self._is_end == false then
        self.m_times = tonumber(activity_add_state[3]) / 1000 - (os.time() + _ED.time_add_or_sub)
    else
        self.m_times = tonumber(activity_add_state[2]) / 1000 - (os.time() + _ED.time_add_or_sub)
        time_str = activity_str_tip[92]
    end

    local Text_festival_blessing_time_1 = ccui.Helper:seekWidgetByName(root,"Text_festival_blessing_time_1")
    Text_festival_blessing_time_1:removeAllChildren(true)
    Text_festival_blessing_time_1:setString("")
    local time_info, time_int = createActivityTimeLable(Text_festival_blessing_time_1, 0, time_str, "")
    Text_festival_blessing_time_1:addChild(time_info)
    Text_festival_blessing_time_1:addChild(time_int)
    self._label_close_text = time_int
    
    -- 重置时间
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1

    local Text_festival_blessing_time_2 = ccui.Helper:seekWidgetByName(root,"Text_festival_blessing_time_2")
    Text_festival_blessing_time_2:removeAllChildren(true)
    Text_festival_blessing_time_2:setString("")
    local reset_time_info, reset_time_int = createActivityTimeLable(Text_festival_blessing_time_2, 0, activity_str_tip[96], "")
    Text_festival_blessing_time_2:addChild(reset_time_info)
    Text_festival_blessing_time_2:addChild(reset_time_int)
    self._label_reset_text = reset_time_int
end

function RedAlertTimeFalconAssaultReform:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if self._label_reset_text ~= nil then
            self._label_reset_text:setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            self:onUpdateDraw()
        end
    end
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self._label_close_text ~= nil then
            self._label_close_text:setString(getRedAlertTimeActivityFormat(self.m_times))
        end
        if self.m_times <= 0 then
            self.m_times = 0
            if self._is_end == false then
                self:onUpdateDraw()
            end
        end
    end
end

--初始化
function RedAlertTimeFalconAssaultReform:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.falcon_assault_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)  

    --规则查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_festival_blessing_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_falcon_assault_reform_get_rule", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeFalconAssaultReform:onEnterTransitionFinish()

end

function RedAlertTimeFalconAssaultReform:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeFalconAssaultReform:onExit()
    -- 移除状态机
    state_machine.remove("red_alert_time_falcon_assault_reform_show")
    state_machine.remove("red_alert_time_falcon_assault_reform_hide")
    state_machine.remove("red_alert_time_falcon_assault_reform_update_draw")
    state_machine.remove("red_alert_time_falcon_assault_reform_get_rule")
end