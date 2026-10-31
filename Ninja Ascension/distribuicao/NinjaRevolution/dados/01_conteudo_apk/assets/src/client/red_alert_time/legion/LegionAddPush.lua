-- ------------------------------------------------------------------------------------------------------------
--  说明：军团申请弹窗
-- ------------------------------------------------------------------------------------------------------------
LegionAddPush = class("LegionAddPushClass", Window)

--打开界面
local legion_add_push_window_open_terminal = {
    _name = "legion_add_push_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if getLegionAddPushState() == false 
            or _ED.union_push_legion_info == nil
            or tonumber(_ED.union_push_legion_info.need_verify) ~= 0
            or tonumber(_ED.union_push_legion_info.need_level) > tonumber(_ED.user_info.user_grade)
            or tonumber(_ED.union_push_legion_info.need_combat_force) > tonumber(_ED.user_info.fighter_capacity)
            then
            return
        end

        if fwin:find("LegionAddPushClass") == nil then
            local _win = LegionAddPush:new()
            _win:init(params)
            fwin:open(_win, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_add_push_window_close_terminal = {
    _name = "legion_add_push_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionAddPushClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_add_push_window_open_terminal)
state_machine.add(legion_add_push_window_close_terminal)
state_machine.init()

function LegionAddPush:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._legion_info = nil

    app.load("client.red_alert_time.legion.LegionInforWindow")

     -- Initialize alert_home state machine.
    local function init_legion_add_push_terminal()
        -- 申请加入军团
        local legion_add_push_apply_add_terminal = {
            _name = "legion_add_push_apply_add",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("legion_infor_window_apply_add_union", 0, {instance._legion_info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 查看详情
        local legion_add_push_look_infor_terminal = {
            _name = "legion_add_push_look_infor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("legion_infor_window_open", 0, {self._legion_info, 1})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_add_push_apply_add_terminal)
        state_machine.add(legion_add_push_look_infor_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_add_push_terminal()
end

-- 显示信息
function LegionAddPush:onUpdateDraw()
    local root = self.roots[1]
    local Panel_legion_add_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_legion_add_player_icon")
    local Text_legion_add_push_name = ccui.Helper:seekWidgetByName(root, "Text_legion_add_push_name")             -- 军团名
    local Text_legion_add_push_p = ccui.Helper:seekWidgetByName(root, "Text_legion_add_push_p")     -- 招募宣言
    local Text_legion_add_player_name = ccui.Helper:seekWidgetByName(root, "Text_legion_add_player_name")     -- 团长名

    Panel_legion_add_player_icon:removeAllChildren(true)
    local cell = PlayerHeadIcon:createCell()
    local avatar_info = {}
    avatar_info.object = self._legion_info.union_president_head
    avatar_info.vip = 0
    avatar_info._type = 0
    cell:init(avatar_info)
    Panel_legion_add_player_icon:addChild(cell)

    Text_legion_add_push_name:setString(self._legion_info.union_name)
    Text_legion_add_push_p:setString(self._legion_info.union_watchword)
    if Text_legion_add_push_p:getString() == tipString_legion_info[14] then
        Text_legion_add_push_p:setString(tipString_legion_info[24])
    end
    Text_legion_add_player_name:setString(self._legion_info.union_president_name)
end

--初始化界面
function LegionAddPush:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_add_push)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self._legion_info = _ED.union_push_legion_info
 
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_add_push_window_close", 
        terminal_state = 0, 
    }, nil, 3)   

    -- 加入军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_add_push_add"), nil, 
    {
        terminal_name = "legion_add_push_apply_add", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 查看详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_add_push_infor"), nil, 
    {
        terminal_name = "legion_add_push_look_infor", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self:onUpdateDraw()
end

--初始化
function LegionAddPush:init(legion_info, from_type)
    self:onInit()
end

--移除状态机
function LegionAddPush:onExit()
    state_machine.remove("legion_add_push_apply_add")
    state_machine.remove("legion_add_push_look_infor")
end