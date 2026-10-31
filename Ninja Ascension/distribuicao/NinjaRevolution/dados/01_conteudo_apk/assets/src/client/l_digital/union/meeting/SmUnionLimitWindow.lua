-- ----------------------------------------------------------------------------------------------------
-- 说明：公会限制界面
-------------------------------------------------------------------------------------------------------
SmUnionLimitWindow = class("SmUnionLimitWindowClass", Window)

local sm_union_limit_window_open_terminal = {
    _name = "sm_union_limit_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionLimitWindowClass")
        if nil == _homeWindow then
            local panel = SmUnionLimitWindow:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_limit_window_close_terminal = {
    _name = "sm_union_limit_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionLimitWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionLimitWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_limit_window_open_terminal)
state_machine.add(sm_union_limit_window_close_terminal)
state_machine.init()
    
function SmUnionLimitWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    local function init_sm_union_limit_window_terminal()
        -- 显示界面
        local sm_union_limit_window_display_terminal = {
            _name = "sm_union_limit_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionLimitWindowWindow = fwin:find("SmUnionLimitWindowClass")
                if SmUnionLimitWindowWindow ~= nil then
                    SmUnionLimitWindowWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_limit_window_hide_terminal = {
            _name = "sm_union_limit_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionLimitWindowWindow = fwin:find("SmUnionLimitWindowClass")
                if SmUnionLimitWindowWindow ~= nil then
                    SmUnionLimitWindowWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --设置类型
        local sm_union_limit_window_set_type_terminal = {
            _name = "sm_union_limit_window_set_type",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = params._datas._page
                if page == 1 then
                    instance.m_type = tonumber(instance.m_type) - 1
                    if instance.m_type < 1 then
                        instance.m_type = 3
                    end
                else
                    instance.m_type = tonumber(instance.m_type) + 1
                    if instance.m_type > 3 then
                        instance.m_type = 1
                    end
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --设置等级
        local sm_union_limit_window_set_level_terminal = {
            _name = "sm_union_limit_window_set_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = params._datas._page
                local price = zstring.split(dms.string(dms["union_config"], 10, union_config.param) ,",")
                local max = tonumber(price[2])
                local min = tonumber(price[1])
                if page == 1 then
                    instance.level_limit = tonumber(instance.level_limit) - 1
                    if instance.level_limit < min then
                        if instance.level_limit < 0 then
                            instance.level_limit = max
                        else
                            instance.level_limit = 0
                        end
                    end
                else
                    instance.level_limit = tonumber(instance.level_limit) + 1
                    if instance.level_limit < min and instance.level_limit > 0 then
                        instance.level_limit = min
                    end
                    if instance.level_limit > max then
                        instance.level_limit = 0
                    end
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求修改设置
        local sm_union_limit_window_modify_settings_terminal = {
            _name = "sm_union_limit_window_modify_settings",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        --刷新界面
                        _ED.union.union_info.approval_status = (instance.m_type-1)..","..instance.level_limit
                        state_machine.excute("union_the_meeting_check_update_limit", 0, nil)
                        state_machine.excute("sm_union_limit_window_close", 0, nil)
                    end
                end
                protocol_command.union_apply_review_update.param_list = (instance.m_type-1)..","..instance.level_limit
                NetworkManager:register(protocol_command.union_apply_review_update.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_limit_window_display_terminal)
        state_machine.add(sm_union_limit_window_hide_terminal)
        state_machine.add(sm_union_limit_window_set_type_terminal)
        state_machine.add(sm_union_limit_window_set_level_terminal)
        state_machine.add(sm_union_limit_window_modify_settings_terminal)
        state_machine.init()
    end
    init_sm_union_limit_window_terminal()
end

function SmUnionLimitWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local Text_type_n = ccui.Helper:seekWidgetByName(root,"Text_type_n")
    Text_type_n:setString(union_limit_title[tonumber(self.m_type)])

    local Text_lv_n = ccui.Helper:seekWidgetByName(root,"Text_lv_n")
    if tonumber(self.level_limit) == 0 then
        Text_lv_n:setString(union_limit_title[4])
    else
        Text_lv_n:setString(self.level_limit)
    end
end

function SmUnionLimitWindow:init(params)
    local approval_status = zstring.split(_ED.union.union_info.approval_status ,",")
    self.m_type = tonumber(approval_status[1])+1
    self.level_limit = tonumber(approval_status[2])
    self:onInit()
    return self
end

function SmUnionLimitWindow:onInit()
    local csbSmUnionLimitWindow = csb.createNode("legion/sm_legion_shenhe_setting.csb")
    local root = csbSmUnionLimitWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionLimitWindow)
    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_limit_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cancel"), nil, 
    {
        terminal_name = "sm_union_limit_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    --设置类型
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arrow_left_1"), nil, 
    {
        terminal_name = "sm_union_limit_window_set_type",
        terminal_state = 0,
        _page = 1,
        touch_black = true,
    },
    nil,0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arrow_right_1"), nil, 
    {
        terminal_name = "sm_union_limit_window_set_type",
        terminal_state = 0,
        _page = 2,
        touch_black = true,
    },
    nil,0)

    
    -- --设置等级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arrow_left_2"), nil, 
    {
        terminal_name = "sm_union_limit_window_set_level",
        terminal_state = 0,
        _page = 1,
        touch_black = true,
    },
    nil,0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_arrow_right_2"), nil, 
    {
        terminal_name = "sm_union_limit_window_set_level",
        terminal_state = 0,
        _page = 2,
        touch_black = true,
    },
    nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ok"), nil, 
    {
        terminal_name = "sm_union_limit_window_modify_settings",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)

    local price = zstring.split(dms.string(dms["union_config"], 10, union_config.param) ,",")
    self.max = tonumber(price[2])
    self.min = tonumber(price[1])

    local function arrowLeftTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if ccui.TouchEventType.began == evenType then
            self.left = true
        elseif ccui.TouchEventType.moved == evenType then
            if __mpoint.x - __spoint.x > 80 
                or __mpoint.x - __spoint.x < -80 
                or __mpoint.y - __spoint.y > 50 
                or __mpoint.y - __spoint.y < -50 
                then
                self.left = false
            end
        elseif ccui.TouchEventType.ended == evenType then
            if self.left == true then
                self.level_limit = tonumber(self.level_limit) - 1
                if self.level_limit < self.min then
                    if self.level_limit < 0 then
                        self.level_limit = self.max
                    else
                        self.level_limit = 0
                    end
                end
                local Text_lv_n = ccui.Helper:seekWidgetByName(root,"Text_lv_n")
                if tonumber(self.level_limit) == 0 then
                    Text_lv_n:setString(union_limit_title[4])
                else
                    Text_lv_n:setString(self.level_limit)
                end
            end
            self.left = false
        end
    end
    -- ccui.Helper:seekWidgetByName(root, "Button_arrow_left_2"):addTouchEventListener(arrowLeftTouchEvent)

    local function arrowRightTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if ccui.TouchEventType.began == evenType then
            self.right = true
        elseif ccui.TouchEventType.moved == evenType then
            if __mpoint.x - __spoint.x > 80 
                or __mpoint.x - __spoint.x < -80 
                or __mpoint.y - __spoint.y > 50 
                or __mpoint.y - __spoint.y < -50 
                then
                self.right = false
            end
        elseif ccui.TouchEventType.ended == evenType then
            if self.right == true then
                self.level_limit = tonumber(self.level_limit) + 1
                if self.level_limit < self.min and self.level_limit > 0 then
                    self.level_limit = self.min
                end
                if self.level_limit > self.max then
                    self.level_limit = 0
                end
                local Text_lv_n = ccui.Helper:seekWidgetByName(root,"Text_lv_n")
                if tonumber(self.level_limit) == 0 then
                    Text_lv_n:setString(union_limit_title[4])
                else
                    Text_lv_n:setString(self.level_limit)
                end
            end
            self.right = false
        end
    end
    -- ccui.Helper:seekWidgetByName(root, "Button_arrow_right_2"):addTouchEventListener(arrowRightTouchEvent)
end

function SmUnionLimitWindow:onUpdate(dt)
    if self.left == true then
        self.level_limit = tonumber(self.level_limit) - 1
        if self.level_limit < self.min then
            if self.level_limit < 0 then
                self.level_limit = self.max
            else
                self.level_limit = 0
            end
        end
        local Text_lv_n = ccui.Helper:seekWidgetByName(self.roots[1],"Text_lv_n")
        if tonumber(self.level_limit) == 0 then
            Text_lv_n:setString(union_limit_title[4])
        else
            Text_lv_n:setString(self.level_limit)
        end
    end
    if self.right == true then
        self.level_limit = tonumber(self.level_limit) + 1
        if self.level_limit < self.min and self.level_limit > 0 then
            self.level_limit = self.min
        end
        if self.level_limit > self.max then
            self.level_limit = 0
        end
        local Text_lv_n = ccui.Helper:seekWidgetByName(self.roots[1],"Text_lv_n")
        if tonumber(self.level_limit) == 0 then
            Text_lv_n:setString(union_limit_title[4])
        else
            Text_lv_n:setString(self.level_limit)
        end
    end

end

function SmUnionLimitWindow:onExit()
    state_machine.remove("sm_union_limit_window_display")
    state_machine.remove("sm_union_limit_window_hide")
end