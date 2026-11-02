-- YouTube推广页1
FansExtensionPageOneCell = class("FansExtensionPageOneCellClass", Window)

local fans_extension_page_one_cell_open_terminal = {
    _name = "fans_extension_page_one_cell_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("FansExtensionPageOneCellClass") == nil then
            fwin:open(FansExtensionPageOneCell:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fans_extension_page_one_cell_open_terminal)
state_machine.init()

function FansExtensionPageOneCell:ctor()
    self.super:ctor()
    self.roots = {}
end

function FansExtensionPageOneCell:init(params)
    self:onInit()
end

function FansExtensionPageOneCell:onInit()
    local csbFansExtensionPageOneCell = csb.createNode("activity/wonderful/youtubu_rule.csb")
    local root = csbFansExtensionPageOneCell:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    self:addChild(root)
    self:setContentSize(root:getContentSize())

    self:onUpdateDraw()
end

function FansExtensionPageOneCell:onUpdateDraw()
    local root = self.roots[1]
    local urlAddres = tipStringInfo_customer_service_tips[1]
    local Text_linkto = ccui.Helper:seekWidgetByName(root, "Text_linkto")
    Text_linkto:setString(urlAddres)

    local urlAddresTwo = tipStringInfo_customer_service_tips[3]
    local Text_linkto_1 = ccui.Helper:seekWidgetByName(root, "Text_linkto_1")
    Text_linkto_1:setString(urlAddresTwo)
    
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_2"),
        nil,
        {
            terminal_name = "fans_extension_window_goto_web_page",
            terminal_state = 0,
            touch_black = true,
            url = urlAddres
        },
        nil,
        3
    )

    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_3"),
        nil,
        {
            terminal_name = "fans_extension_window_goto_web_page",
            terminal_state = 0,
            touch_black = true,
            url = urlAddresTwo
        },
        nil,
        3
    )
end

function FansExtensionPageOneCell:createCell()
    local cell = FansExtensionPageOneCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function FansExtensionPageOneCell:onExit()
end
