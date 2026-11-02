--------------------------------------------------------------------------------------------------------------
--  说明：小助手对话
--------------------------------------------------------------------------------------------------------------
TeachingChat = class("TeachingChatClass", Window)

--打开界面
local teaching_chat_open_terminal = {
    _name = "teaching_chat_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("TeachingChatClass") == nil then
            fwin:open(TeachingChat:new():init(params), fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local teaching_chat_close_terminal = {
    _name = "teaching_chat_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TeachingChatClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(teaching_chat_open_terminal)
state_machine.add(teaching_chat_close_terminal)
state_machine.init()

function TeachingChat:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_teaching_chat_terminal()
        
    end
    init_teaching_chat_terminal()
end

function TeachingChat:updateDraw(params)
    local root = self.roots[1]
    local Text_xx_1 = ccui.Helper:seekWidgetByName(root,"Text_xx_1")
    Text_xx_1:setString(params.distribute)
end

--初始化
function TeachingChat:onInit(params)
    local csbItem = csb.createNode(config_csb.chats.dialog_lhm)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_dialog_1"), nil, 
    {
        terminal_name = "teaching_chat_close",
        terminal_state = 0, 
    }, nil, 3)

    self:updateDraw(params)
end

function TeachingChat:onEnterTransitionFinish()

end

function TeachingChat:init(params)
    self:onInit(params)
    return self
end

function TeachingChat:onExit()
end