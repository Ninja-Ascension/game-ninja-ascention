-- ------------------------------------------------------------------------------------------------------------
--  说明：军团申请列表
-- ------------------------------------------------------------------------------------------------------------
LegionApplicationConfirmation = class("LegionApplicationConfirmationClass", Window)

--打开界面
local legion_application_confirmation_window_open_terminal = {
    _name = "legion_application_confirmation_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if tonumber(_ED.union.user_union_info.union_post) >= 3 then       -- 普通成员，没有权限
            TipDlg.drawTextDailog(tipString_legion_info[13])
            return
        end
        if fwin:find("LegionApplicationConfirmationClass") == nil then
            local rootWindow = nil
            if params ~= nil and params._datas ~= nil and params._datas.rootWindow ~= nil then
                rootWindow = params._datas.rootWindow
            end
            local _win = LegionApplicationConfirmation:new()
            _win:init(rootWindow)
            fwin:open(_win,fwin._ui)
            return _win
        end
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_application_confirmation_window_close_terminal = {
    _name = "legion_application_confirmation_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionApplicationConfirmationClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_application_confirmation_window_open_terminal)
state_machine.add(legion_application_confirmation_window_close_terminal)
state_machine.init()

function LegionApplicationConfirmation:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

     -- Initialize alert_home state machine.
    local function init_legion_application_confirmation_terminal()
        --显示界面
        local legion_application_confirmation_show_terminal = {
            _name = "legion_application_confirmation_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --隐藏界面
        local legion_application_confirmation_hide_terminal = {
            _name = "legion_application_confirmation_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local legion_application_confirmation_update_draw_terminal = {
            _name = "legion_application_confirmation_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    local posY = instance._list_view_poy
                    instance:onUpdateDraw()
                    if math.abs(posY) > math.abs(instance._list_view_height) then
                        posY = instance._list_view_height
                    end
                    instance._list_view:getInnerContainer():setPositionY(posY)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 全部操作
        local legion_application_confirmation_all_member_terminal = {
            _name = "legion_application_confirmation_all_member",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.union.user_union_info.union_post) >= 3 then       -- 普通成员，没有权限
                    TipDlg.drawTextDailog(tipString_legion_info[13])
                    return
                end
                local ntype = params._datas._type
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                local str = ""
                for k, v in pairs(_ED.union.union_examine_list_info) do
                    if k == 1 then
                        str = v.id
                    else
                        str = str .. "," .. v.id
                    end
                end
                protocol_command.union_persion_manage.param_list = _ED.union.union_info.union_id.."\r\n"..str.."\r\n"..ntype
                NetworkManager:register(protocol_command.union_persion_manage.code, nil, nil, nil, instance, responseCallback, true, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        state_machine.add(legion_application_confirmation_show_terminal)
        state_machine.add(legion_application_confirmation_hide_terminal)
        state_machine.add(legion_application_confirmation_update_draw_terminal)
        state_machine.add(legion_application_confirmation_all_member_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_application_confirmation_terminal()
end

function LegionApplicationConfirmation:onHide()
    self:setVisible(false)
end

function LegionApplicationConfirmation:onShow()
    self:setVisible(true)
end

function LegionApplicationConfirmation:refreshListView()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
end

-- 显示信息
function LegionApplicationConfirmation:onUpdateDraw()
    local root = self.roots[1]

    local Button_all_refuse_legion_add = ccui.Helper:seekWidgetByName(root, "Button_all_refuse_legion_add")
    local Button_all_agree_legion_add = ccui.Helper:seekWidgetByName(root, "Button_all_agree_legion_add")

    local ListView_add_legion = ccui.Helper:seekWidgetByName(root, "ListView_add_legion")
    self._list_view = ListView_add_legion
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    if _ED.union.union_examine_list_sum ~= nil and tonumber(_ED.union.union_examine_list_sum) ~= 0 then
        for k, v in pairs(_ED.union.union_examine_list_info) do
            local cell = state_machine.excute("legion_application_confirmation_cell_create", 0, {k, v})
            self._list_view:addChild(cell)
        end
        Button_all_refuse_legion_add:setTouchEnabled(true)
        Button_all_refuse_legion_add:setBright(true)
        Button_all_agree_legion_add:setTouchEnabled(true)
        Button_all_agree_legion_add:setBright(true)
    else
        Button_all_refuse_legion_add:setTouchEnabled(false)
        Button_all_refuse_legion_add:setBright(false)
        Button_all_agree_legion_add:setTouchEnabled(false)
        Button_all_agree_legion_add:setBright(false)
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self._list_view:requestRefreshView()

    local Text_not_add_legion = ccui.Helper:seekWidgetByName(root, "Text_not_add_legion")
    if #self._list_view:getItems() == 0 then
        Text_not_add_legion:setVisible(true)
    else
        Text_not_add_legion:setVisible(false)
    end
end

function LegionApplicationConfirmation:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

--初始化界面
function LegionApplicationConfirmation:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_application_confirmation)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    if self._rootWindows == nil then
        Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
    end

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_application_confirmation_close"), nil, 
    {
        terminal_name = "legion_application_confirmation_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    -- 全部拒绝
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_all_refuse_legion_add"), nil, 
    {
        terminal_name = "legion_application_confirmation_all_member", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _type = 0,
    }, nil, 1)    

    -- 全部同意
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_all_agree_legion_add"), nil, 
    {
        terminal_name = "legion_application_confirmation_all_member", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        _type = 1,
    }, nil, 1)    

    -- 设置限制
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_set_legion_add"), nil, 
    {
        terminal_name = "legion_manage_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)    

    self:onUpdateDraw()
end

--初始化
function LegionApplicationConfirmation:init(rootWindow)
    self._rootWindows = rootWindow
    self:onInit()
end

--移除状态机
function LegionApplicationConfirmation:onExit()
    state_machine.remove("legion_application_confirmation_show")
    state_machine.remove("legion_application_confirmation_hide")
    state_machine.remove("legion_application_confirmation_update_draw")
    state_machine.remove("legion_application_confirmation_all_member")
end
