-----------------------------
--VIP特权
-----------------------------
ShopHelp = class("ShopHelpClass", Window)
--打开
local shop_help_window_open_terminal = {
    _name = "shop_help_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ShopHelpClass") then
            fwin:open(ShopHelp:new():init(), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local shop_help_window_close_terminal = {
    _name = "shop_help_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ShopHelpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(shop_help_window_open_terminal)
state_machine.add(shop_help_window_close_terminal)
state_machine.init()

function ShopHelp:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_shop_help_terminal()

        state_machine.init()
    end
    init_shop_help_terminal()
end 

function ShopHelp:onUpdateDraw()
 
end


function ShopHelp:onInit()
    local csbItem = csb.createNode(config_csb.shop.shop_help)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "shop_help_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)
    
    self:onUpdateDraw()
end


function ShopHelp:init()
	self:onInit()
    return self
end

function ShopHelp:onExit()

end