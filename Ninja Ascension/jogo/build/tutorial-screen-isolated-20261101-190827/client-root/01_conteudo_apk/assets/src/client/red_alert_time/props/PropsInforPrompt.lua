-- ------------------------------------------------------------------------------------------------------------
--  说明：道具信息提示
-- ------------------------------------------------------------------------------------------------------------
PropsInforPrompt = class("PropsInforPromptClass", Window)

--打开界面
local props_infor_prompt_window_open_terminal = {
    _name = "props_infor_prompt_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local prop_id = params[1]
        local reward_type = dms.int(dms["prop_mould"], prop_id, prop_mould.reward_type)
        if reward_type > 0 then
            local addition_group_index = dms.int(dms["prop_mould"], prop_id, prop_mould.addition_group_index)
            local reward_info = zstring.split(dms.string(dms["scene_reward"], addition_group_index, scene_reward.reward_items),"|")
            if reward_type == 1 then
                state_machine.excute("red_alert_time_box_preview_window_open",0,{reward_info, red_alert_time_str[305]})
            elseif reward_type == 2 then
                state_machine.excute("red_alert_time_box_preview_window_open",0,{reward_info, red_alert_time_str[306]})
            end
        else
            if fwin:find("PropsInforPromptClass") == nil then
                local _win = PropsInforPrompt:new()
                _win:init(prop_id)
                fwin:open(_win,fwin._windows)
            end
        end
        local platformFbMethodWindow = fwin:find("platformFbMethodClass") 
        if platformFbMethodWindow ~= nil and platformFbMethodWindow:isVisible() == true then
            platformFbMethodWindow:setVisible(false)
        end
        
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local props_infor_prompt_window_close_terminal = {
    _name = "props_infor_prompt_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PropsInforPromptClass"))
        local platformFbMethodWindow = fwin:find("platformFbMethodClass") 
        if platformFbMethodWindow ~= nil and platformFbMethodWindow:isVisible() == false then
            platformFbMethodWindow:setVisible(true)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(props_infor_prompt_window_open_terminal)
state_machine.add(props_infor_prompt_window_close_terminal)
state_machine.init()

function PropsInforPrompt:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._prop_id = nil

    app.load("client.red_alert_time.cells.props.props_icon_cell")
     -- Initialize alert_home state machine.
    local function init_props_infor_prompt_terminal()

    end
    -- call func alert_home create state machine.
    init_props_infor_prompt_terminal()
end

--初始化界面
function PropsInforPrompt:onInit()
    local csbItem = csb.createNode(config_csb.props.props_infor_prompt)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_infor_prompt_close"), nil, 
    {
        terminal_name = "props_infor_prompt_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "props_infor_prompt_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_infor_prompt_sure"), nil, 
    {
        terminal_name = "props_infor_prompt_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    self:onUpdateDraw()
end

-- 显示信息
function PropsInforPrompt:onUpdateDraw()
    local root = self.roots[1]
    -- icon
    local Panel_infor_prompt_icon = ccui.Helper:seekWidgetByName(root, "Panel_infor_prompt_icon")
    Panel_infor_prompt_icon:removeAllChildren(true)
    local cell = nil
    local change_of_equipment = dms.int(dms["prop_mould"], self._prop_id, prop_mould.change_of_equipment)
    if change_of_equipment > 0 then
        cell = state_machine.excute("props_icon_create_cell",0,{9,7, self._prop_id,1,-1,false})
    else
        cell = state_machine.excute("props_icon_create_cell",0,{4,3,self._prop_id,1})
    end
    Panel_infor_prompt_icon:addChild(cell) 

    -- name
    local Text_infor_prompt_icon_name = ccui.Helper:seekWidgetByName(root, "Text_infor_prompt_icon_name")
    local prop_name = dms.string(dms["prop_mould"], self._prop_id, prop_mould.prop_name)
    Text_infor_prompt_icon_name:setString(prop_name)

    -- 描述
    local Text_infor_prompt_t_1 = ccui.Helper:seekWidgetByName(root, "Text_infor_prompt_t_1")
    local Text_infor_prompt_t_2 = ccui.Helper:seekWidgetByName(root, "Text_infor_prompt_t_2")
    local remarks = dms.string(dms["prop_mould"], self._prop_id, prop_mould.remarks)
    local trace_remarks = dms.string(dms["prop_mould"], self._prop_id, prop_mould.trace_remarks)
    Text_infor_prompt_t_1:setString(remarks)
    Text_infor_prompt_t_2:setString("")
    if tonumber(trace_remarks) == nil then
        Text_infor_prompt_t_2:setString(trace_remarks)
    end
end

--初始化
function PropsInforPrompt:init(prop_id)
    self._prop_id = prop_id
    self:onInit()
end

--移除状态机
function PropsInforPrompt:onExit()

end