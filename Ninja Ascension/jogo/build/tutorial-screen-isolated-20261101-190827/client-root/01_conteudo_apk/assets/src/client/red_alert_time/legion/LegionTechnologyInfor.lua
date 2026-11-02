-- ------------------------------------------------------------------------------------------------------------
--  说明：科技捐献信息
-- ------------------------------------------------------------------------------------------------------------
LegionTechnologyInfor = class("LegionTechnologyInforClass", Window)

--打开界面
local legion_technology_infor_window_open_terminal = {
    _name = "legion_technology_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionTechnologyInforClass") == nil then
            local _win = LegionTechnologyInfor:new()
            local science_id = params._datas.science_id
            _win:init(science_id)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_technology_infor_window_close_terminal = {
    _name = "legion_technology_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionTechnologyInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_technology_infor_window_open_terminal)
state_machine.add(legion_technology_infor_window_close_terminal)
state_machine.init()

function LegionTechnologyInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._science_id = 0

     -- Initialize alert_home state machine.
    local function init_legion_technology_infor_terminal()
        local legion_technology_infor_update_draw_terminal = {
            _name = "legion_technology_infor_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_technology_infor_update_draw_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_technology_infor_terminal()
end

-- 显示信息
function LegionTechnologyInfor:onUpdateDraw()
    local root = self.roots[1]
    local Text_technology_infor = ccui.Helper:seekWidgetByName(root, "Text_technology_infor")
    local Text_technology_name_lv = ccui.Helper:seekWidgetByName(root, "Text_technology_name_lv")
    local talent_id = dms.int(dms["union_science_mould"], self._science_id, union_science_mould.talent_id)
    local talent_describe = dms.string(dms["talent_mould"], talent_id, talent_mould.talent_describe)
    Text_technology_infor:setString(talent_describe)

    local science_info = _ED.union_science_info[""..self._science_id]
    Text_technology_name_lv:setString(science_info.name..string.format(red_alert_time_str[33], science_info.level))
end

--初始化界面
function LegionTechnologyInfor:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_technology_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_technology_close"), nil, 
    {
        terminal_name = "legion_technology_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_technology_infor_window_close", 
        terminal_state = 0, 
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_technology_cancel"), nil, 
    {
        terminal_name = "legion_technology_infor_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_technology_sure"), nil, 
    {
        terminal_name = "legion_technology_infor_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    self:onUpdateDraw()
end

--初始化
function LegionTechnologyInfor:init(science_id)
    self._science_id = science_id
    self:onInit()
end

--移除状态机
function LegionTechnologyInfor:onExit()
    state_machine.remove("legion_technology_infor_update_draw")
end