--------------------------------------------------------------------------------------------------------------
--  极限突破研究获奖记录
--------------------------------------------------------------------------------------------------------------
RedAlertTimeUitimateBreakthroughRecord = class("RedAlertTimeUitimateBreakthroughRecordClass", Window)

--打开界面
local red_alert_time_uitimate_breakthrough_record_open_terminal = {
    _name = "red_alert_time_uitimate_breakthrough_record_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = fwin:open(RedAlertTimeUitimateBreakthroughRecord:new():init(params), fwin._ui)  
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_uitimate_breakthrough_record_open_terminal)
state_machine.init()

function RedAlertTimeUitimateBreakthroughRecord:ctor()
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
    
    -- 初始化状态机
    local function init_red_alert_time_uitimate_breakthrough_record_terminal()
        local red_alert_time_uitimate_breakthrough_record_show_terminal = {
            _name = "red_alert_time_uitimate_breakthrough_record_show",
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

        local red_alert_time_uitimate_breakthrough_record_hide_terminal = {
            _name = "red_alert_time_uitimate_breakthrough_record_hide",
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
        local red_alert_time_uitimate_breakthrough_record_update_draw_terminal = {
            _name = "red_alert_time_uitimate_breakthrough_record_update_draw",
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

        local red_alert_time_uitimate_breakthrough_record_get_rule_terminal = {
            _name = "red_alert_time_uitimate_breakthrough_record_get_rule",
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

        state_machine.add(red_alert_time_uitimate_breakthrough_record_update_draw_terminal)
        state_machine.add(red_alert_time_uitimate_breakthrough_record_hide_terminal)
        state_machine.add(red_alert_time_uitimate_breakthrough_record_show_terminal)
        state_machine.add(red_alert_time_uitimate_breakthrough_record_get_rule_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_uitimate_breakthrough_record_terminal()
end

function RedAlertTimeUitimateBreakthroughRecord:updateDraw()
    local root = self.roots[1]
    local activity_info = _ED.activity_info[""..self._activity_type]
    -- activity_add_state = "开始时间,结束时间,领奖时间,免费次数,免费最大次数,单抽金币,10连金币,超级实验金币,折扣,10连原价,超级实验剩余次数,超级实验最大次数,超级实验需要VIP等级,核心1id，核心2id，改造坦克1id，改造坦克2id
    --                     !获奖记录"      
    local activity_add_state_arr = zstring.split(activity_info.activity_add_state, "!")
    local activity_add_state = zstring.split(activity_add_state_arr[1], ",")

    -- 收集记录
    local ScrollView_uitimate_breakthrough = ccui.Helper:seekWidgetByName(root,"ScrollView_uitimate_breakthrough")
    ScrollView_uitimate_breakthrough:removeAllChildren(true)

    local reward_info = {}
    if activity_add_state_arr[2] ~= "0" then
        reward_info = zstring.split(activity_add_state_arr[2], "|")
    end

    local cell_tables = {}
    local cell_size = nil
    local total_col = 4
    for k, v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local reward = {}
        reward.prop_item = tonumber(info[1])
        reward.prop_type = tonumber(info[2])
        reward.item_value = tonumber(info[3])
        local cell = createPropIconCell(reward, true, true, true)
        ScrollView_uitimate_breakthrough:addChild(cell)
        table.insert(cell_tables, cell)
        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
    end

    local count = #cell_tables
    if count > 0 then
        local cell_height = cell_size.height + 35
        local size = ScrollView_uitimate_breakthrough:getContentSize()
        local height = cell_height * math.ceil(count / total_col)
        local width = size.width / total_col
        if height > size.height then
            size.height = height
            ScrollView_uitimate_breakthrough:setInnerContainerSize(size)
        end

        for k, v in pairs(cell_tables) do
            local row = math.floor((k - 1) % total_col) + 1
            local col = math.floor((k - 1) / total_col) + 1
            local posX = size.width * row / total_col - width / 2 - cell_size.width / 2
            local posY = size.height - cell_height * col
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

    local Text_uitimate_breakthrough_time_1 = ccui.Helper:seekWidgetByName(root,"Text_uitimate_breakthrough_time_1")
    Text_uitimate_breakthrough_time_1:removeAllChildren(true)
    Text_uitimate_breakthrough_time_1:setString("")
    local time_info, time_int = createActivityTimeLable(Text_uitimate_breakthrough_time_1, 0, time_str, "")
    Text_uitimate_breakthrough_time_1:addChild(time_info)
    Text_uitimate_breakthrough_time_1:addChild(time_int)
    self._label_close_text = time_int
    
    -- 重置时间
    local server_time = getCurrentGTM8Time()
    self.m_reset_times = (24 - server_time.hour) * 3600 + (0 - server_time.min) * 60 + 0 - server_time.sec - 1

    local Text_uitimate_breakthrough_time_2 = ccui.Helper:seekWidgetByName(root,"Text_uitimate_breakthrough_time_2")
    Text_uitimate_breakthrough_time_2:removeAllChildren(true)
    Text_uitimate_breakthrough_time_2:setString("")
    local reset_time_info, reset_time_int = createActivityTimeLable(Text_uitimate_breakthrough_time_2, 0, activity_str_tip[96], "")
    Text_uitimate_breakthrough_time_2:addChild(reset_time_info)
    Text_uitimate_breakthrough_time_2:addChild(reset_time_int)
    self._label_reset_text = reset_time_int
end

function RedAlertTimeUitimateBreakthroughRecord:onUpdate(dt)
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
function RedAlertTimeUitimateBreakthroughRecord:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.uitimate_breakthrough_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)  

    --规则查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_uitimate_breakthrough_rule_infor"), nil, 
    {
        terminal_name = "red_alert_time_uitimate_breakthrough_record_get_rule", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeUitimateBreakthroughRecord:onEnterTransitionFinish()

end

function RedAlertTimeUitimateBreakthroughRecord:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeUitimateBreakthroughRecord:onExit()
    -- 移除状态机
    state_machine.remove("red_alert_time_uitimate_breakthrough_record_show")
    state_machine.remove("red_alert_time_uitimate_breakthrough_record_hide")
    state_machine.remove("red_alert_time_uitimate_breakthrough_record_update_draw")
    state_machine.remove("red_alert_time_uitimate_breakthrough_record_get_rule")
end