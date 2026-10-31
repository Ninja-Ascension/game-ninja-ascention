-- ------------------------------------------------------------------------------------------------------------
--  说明：发起弹劾
-- ------------------------------------------------------------------------------------------------------------
LegionImpeachmentWindow = class("LegionImpeachmentWindowClass", Window)

--打开界面
local legion_impeachment_window_window_open_terminal = {
    _name = "legion_impeachment_window_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionImpeachmentWindowClass") == nil then
            local _win = LegionImpeachmentWindow:new()
            _win:init(params)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_impeachment_window_window_close_terminal = {
    _name = "legion_impeachment_window_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionImpeachmentWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_impeachment_window_window_open_terminal)
state_machine.add(legion_impeachment_window_window_close_terminal)
state_machine.init()

function LegionImpeachmentWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._info_data = nil 
    self._cell = nil

     -- Initialize alert_home state machine.
    local function init_legion_impeachment_window_terminal()
        -- 刷新
        local legion_impeachment_window_initiate_impeachment_terminal = {
            _name = "legion_impeachment_window_initiate_impeachment",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseUnionListCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node._cell._info_data.post = response.node._choose_type
                            response.node._cell:updateDraw()
                            state_machine.excute("legion_impeachment_window_window_close", 0, "")
                        end
                    end
                end 
                protocol_command.union_appoint.param_list = _ED.union.union_info.union_id.."\r\n"..instance._info_data.id.."\r\n"..6
                NetworkManager:register(protocol_command.union_appoint.code, nil, nil, nil, instance, responseUnionListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_impeachment_window_initiate_impeachment_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_impeachment_window_terminal()
end


-- 显示信息
function LegionImpeachmentWindow:onUpdateDraw()
    local root = self.roots[1]

end

--初始化界面
function LegionImpeachmentWindow:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_impeachment_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_infor_close"), nil, 
    {
        terminal_name = "legion_impeachment_window_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)    

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_impeachment_window_window_close", 
        terminal_state = 0, 
    }, nil, 1)  

    -- 发起弹劾
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_impeachment"), nil, 
    {
        terminal_name = "legion_impeachment_window_initiate_impeachment", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)    

    self:onUpdateDraw()
end

--初始化
function LegionImpeachmentWindow:init(params)
    self._cell = params[1] 
    self._info_data = params[2]    
    self:onInit()
end

--移除状态机
function LegionImpeachmentWindow:onExit()
    state_machine.remove("legion_impeachment_window_initiate_impeachment")
end