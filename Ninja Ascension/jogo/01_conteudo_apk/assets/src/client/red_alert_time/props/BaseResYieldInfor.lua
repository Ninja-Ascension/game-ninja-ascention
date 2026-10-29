-- ------------------------------------------------------------------------------------------------------------
--  说明：基地储备产量提示信息
-- ------------------------------------------------------------------------------------------------------------
BaseResYieldInfor = class("BaseResYieldInforClass", Window)

--打开界面
local base_res_yield_infor_window_open_terminal = {
    _name = "base_res_yield_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("BaseResYieldInforClass") == nil then
            local _win = BaseResYieldInfor:new()
            _win:init(params)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local base_res_yield_infor_window_close_terminal = {
    _name = "base_res_yield_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BaseResYieldInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(base_res_yield_infor_window_open_terminal)
state_machine.add(base_res_yield_infor_window_close_terminal)
state_machine.init()

function BaseResYieldInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._name = ""
    self._res_num = 0
    self._build_buff_id = 0

    self._text_time = nil
    self._buff_info = {}
    self._max_time = 0
    self._start_time = 0
     -- Initialize alert_home state machine.
    local function init_base_res_yield_infor_terminal()

    end
    -- call func alert_home create state machine.
    init_base_res_yield_infor_terminal()
end

--显示
function BaseResYieldInfor:onShow()
   self:setVisible(true)
end

--隐藏
function BaseResYieldInfor:onHide()
   self:setVisible(false)
end

--初始化界面
function BaseResYieldInfor:onInit()
    local csbItem = csb.createNode(config_csb.props.base_res_yield_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "base_res_yield_infor_window_close", 
        terminal_state = 0, 
    }, nil, 1)

    self:onUpdateDraw()
end

-- 显示信息
function BaseResYieldInfor:onUpdateDraw()
    local root = self.roots[1]
    local Text_res_yield_infor = ccui.Helper:seekWidgetByName(root, "Text_res_yield_infor")
    local Text_res_yield_infor_up_prompt = ccui.Helper:seekWidgetByName(root, "Text_res_yield_infor_up_prompt")
    Text_res_yield_infor:setString(string.format(red_alert_time_str[10], self._name, exChangeNumToString(self._res_num)))
    Text_res_yield_infor_up_prompt:setString("")
    self._text_time = nil
    for k,v in pairs(_ED.factor_info) do
        if tonumber(v.build_buff_id) == self._build_buff_id then
            table.insert(self._buff_info, v)
            break
        end
    end

    local max_time = 0
    local start_time = 0
    if table.nums(self._buff_info) > 0 then
        for k,v in pairs(self._buff_info) do
            max_time = tonumber(v.factor_cd_time)-- + max_time
            start_time = tonumber(v.factor_start_time)-- + start_time
        end
        local leave_time = max_time - zstring.tonumber((os.time() + _ED.time_add_or_sub - start_time))
        self._text_time = Text_res_yield_infor_up_prompt
        self._text_time:setString(string.format(red_alert_time_str[199], exChangeTimeToString(leave_time)))
    end
    self._max_time = max_time
    self._start_time = start_time
end

function BaseResYieldInfor:onUpdate(dt)
    if self._text_time ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            if table.nums(self._buff_info) > 0 then
                local leave_time = self._max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - self._start_time))
                if leave_time > 0 then
                    self._text_time:setString(string.format(red_alert_time_str[199], exChangeTimeToString(leave_time)))
                else
                    self:onUpdateDraw()
                end
            end
        end
    end
end

--初始化
function BaseResYieldInfor:init(params)
    self._name = params[1]
    self._res_num = params[2]
    self._build_buff_id = params[3]
    self:onInit()
end

--移除状态机
function BaseResYieldInfor:onExit()

end