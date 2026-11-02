-- ----------------------------------------------------------------------------------------------------
-- 说明：公会进入的公告
-------------------------------------------------------------------------------------------------------
SmUnionHallNoticeWindow = class("SmUnionHallNoticeWindowClass", Window)

local sm_union_hall_notice_window_open_terminal = {
    _name = "sm_union_hall_notice_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionHallNoticeWindowClass")
        if nil == _homeWindow then
            local panel = SmUnionHallNoticeWindow:new():init(params)
            fwin:open(panel,fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_hall_notice_window_close_terminal = {
    _name = "sm_union_hall_notice_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionHallNoticeWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionHallNoticeWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_hall_notice_window_open_terminal)
state_machine.add(sm_union_hall_notice_window_close_terminal)
state_machine.init()
    
function SmUnionHallNoticeWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    local function init_sm_union_hall_notice_window_terminal()
        -- 显示界面
        local sm_union_hall_notice_window_display_terminal = {
            _name = "sm_union_hall_notice_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionHallNoticeWindowWindow = fwin:find("SmUnionHallNoticeWindowClass")
                if SmUnionHallNoticeWindowWindow ~= nil then
                    SmUnionHallNoticeWindowWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_hall_notice_window_hide_terminal = {
            _name = "sm_union_hall_notice_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionHallNoticeWindowWindow = fwin:find("SmUnionHallNoticeWindowClass")
                if SmUnionHallNoticeWindowWindow ~= nil then
                    SmUnionHallNoticeWindowWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 修改公告
        local sm_union_hall_notice_window_set_announcement_terminal = {
            _name = "sm_union_hall_notice_window_set_announcement",
            _init = function (terminal) 
                app.load("client.l_digital.cells.union.union_the_meeting_place_notice_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_the_meeting_place_notice_open", 0, 1)
                state_machine.excute("sm_union_hall_notice_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_hall_notice_window_display_terminal)
        state_machine.add(sm_union_hall_notice_window_hide_terminal)
        state_machine.add(sm_union_hall_notice_window_set_announcement_terminal)
        state_machine.init()
    end
    init_sm_union_hall_notice_window_terminal()
end

function SmUnionHallNoticeWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    --公告内容
    local Text_notice = ccui.Helper:seekWidgetByName(root, "Text_notice")
    Text_notice:setString(_ED.union.union_info.watchword)

    --会长
    local Text_inscribe = ccui.Helper:seekWidgetByName(root, "Text_inscribe")
    local leaderName = ""
    for i=1,zstring.tonumber(_ED.union.union_member_list_sum) do
        local unionData = _ED.union.union_member_list_info[i]
        if unionData ~= nil and tonumber(unionData.post) == 1 then
            leaderName = unionData.name
        end
    end

    Text_inscribe:setString(string.format(_new_interface_text[61],leaderName))

    if tonumber(_ED.union.user_union_info.union_post) == 1 then
        ccui.Helper:seekWidgetByName(root, "Button_xiugai_2"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Button_xiugai_2"):setVisible(false)
    end
end

function SmUnionHallNoticeWindow:init(params)
    self.example = params
    self:onInit()
    return self
end

function SmUnionHallNoticeWindow:onInit()
    local csbSmUnionHallNoticeWindow = csb.createNode("legion/sm_legion_hall_notice.csb")
    local root = csbSmUnionHallNoticeWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionHallNoticeWindow)
    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_hall_notice_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_xiugai_2"), nil, 
    {
        terminal_name = "sm_union_hall_notice_window_set_announcement",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)
end

function SmUnionHallNoticeWindow:onExit()
    state_machine.remove("sm_union_hall_notice_window_display")
    state_machine.remove("sm_union_hall_notice_window_hide")
end