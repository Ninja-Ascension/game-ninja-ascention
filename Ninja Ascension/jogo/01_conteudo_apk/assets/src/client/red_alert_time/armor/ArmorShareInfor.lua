-- ------------------------------------------------------------------------------------------------------------
--  说明：装甲分享查看
-- ------------------------------------------------------------------------------------------------------------
ArmorShareInfor = class("ArmorShareInforClass", Window)

--打开界面
local armor_share_infor_window_open_terminal = {
    _name = "armor_share_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("ArmorShareInforClass") == nil then
            local _win = ArmorShareInfor:new()
            _win:init(params)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local armor_share_infor_window_close_terminal = {
    _name = "armor_share_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ArmorShareInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(armor_share_infor_window_open_terminal)
state_machine.add(armor_share_infor_window_close_terminal)
state_machine.init()

function ArmorShareInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._armor_info = nil

    local function init_armor_share_infor_terminal()

    end
    init_armor_share_infor_terminal()
end

-- 显示信息
function ArmorShareInfor:onUpdateDraw()
    local root = self.roots[1]
    local Button_share = ccui.Helper:seekWidgetByName(root, "Button_share")
    local Button_armor_unload = ccui.Helper:seekWidgetByName(root, "Button_armor_unload")
    local Button_armor_change = ccui.Helper:seekWidgetByName(root, "Button_armor_change")
    local Button_armor_up = ccui.Helper:seekWidgetByName(root, "Button_armor_up")
    Button_share:setVisible(false)
    Button_armor_unload:setVisible(false)
    Button_armor_change:setVisible(false)
    Button_armor_up:setVisible(false)

    local Panel_armor_icon = ccui.Helper:seekWidgetByName(root, "Panel_armor_icon")
    local Text_armor_name = ccui.Helper:seekWidgetByName(root, "Text_armor_name")
    local Text_armor_attribute = ccui.Helper:seekWidgetByName(root, "Text_armor_attribute")
    local Text_armor_attribute_infor = ccui.Helper:seekWidgetByName(root, "Text_armor_attribute_infor")

    Panel_armor_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell", 0, {8, 14, self._armor_info.equipment_mould_id, 15, nil, nil, self._armor_info})
    Panel_armor_icon:addChild(cell)
    Text_armor_name:setString(self._armor_info.equipment_name)
    Text_armor_attribute_infor:setString(self._armor_info.trace_remarks)

    local attr_info = zstring.split(self._armor_info.attr, ",")
    local attr_name = red_alert_time_attribute[tonumber(attr_info[1]) + 1]
    local attr_value = tonumber(attr_info[2])
    Text_armor_attribute:setString(""..attr_name.."+"..attr_value.."%")
end

--初始化界面
function ArmorShareInfor:onInit()
    local csbItem = csb.createNode(config_csb.armor.armor_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_infor_close"), nil, 
    {
        terminal_name = "armor_share_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "armor_share_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    self:onUpdateDraw()
end

--初始化
function ArmorShareInfor:init(params)
    self._armor_info = params[1]

    self:onInit()
end

--移除状态机
function ArmorShareInfor:onExit()   

end
