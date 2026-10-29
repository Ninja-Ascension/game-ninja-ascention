-- ------------------------------------------------------------------------------------------------------------
--  说明：军团信息
-- ------------------------------------------------------------------------------------------------------------
LegionInforWindow = class("LegionInforWindowClass", Window)

--打开界面
local legion_infor_window_open_terminal = {
    _name = "legion_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionInforWindowClass") == nil then
            local legion_info = params[1]
            local from_type = params[2]
            local _win = LegionInforWindow:new()
            _win:init(legion_info, from_type)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_infor_window_close_terminal = {
    _name = "legion_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionInforWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 申请加入军团
local legion_infor_window_apply_add_union_terminal = {
    _name = "legion_infor_window_apply_add_union",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local legion_info = params[1]
        if funOpenDrawTip(152, false) == true then
            TipDlg.drawTextDailog(tipString_legion_info[45])
            return
        end 

        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            then
        else
            TipDlg.drawTextDailog(tipString_legion_info[44])
            return
        end

        if zstring.tonumber(legion_info.union_appiy) > 0 then
            TipDlg.drawTextDailog(tipString_legion_info[7])
            return
        end

        -- 战力要求
        if zstring.tonumber(legion_info.need_combat_force) > zstring.tonumber(_ED.user_info.fighter_capacity) then
            TipDlg.drawTextDailog(red_alert_time_str[308])
            return
        end

        -- 等级要求
        if zstring.tonumber(legion_info.need_level) > zstring.tonumber(_ED.user_info.user_grade) then
            TipDlg.drawTextDailog(red_alert_time_str[307])
            return
        end

        local btype = 1             -- 申请加入
        local union_id = tonumber(legion_info.union_id)
        local function responseUnionSearchCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                TipDlg.drawTextDailog(tipString_legion_info[6])
                if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                    -- 改变申请状态
                    for k, v in pairs(_ED.union.union_list_info) do
                        if union_id == tonumber(v.union_id) then
                            v.union_appiy = 1
                            break
                        end
                    end

                    for k, v in pairs(_ED.union.recommend_union_list_info) do
                        if union_id == tonumber(v.union_id) then
                            v.union_appiy = 1
                            break
                        end
                    end
                    
                    state_machine.excute("legion_add_push_window_close")
                    state_machine.excute("legion_infor_window_close")
                    state_machine.excute("legion_list_update_draw", 0, "")
                else
                    state_machine.excute("legion_add_push_window_close", 0, "")
                    state_machine.excute("legion_infor_window_close")
                    state_machine.excute("legion_list_window_close", 0, "")
                    state_machine.excute("legion_window_open", 0, "")
                end
            end
        end
        protocol_command.union_apply.param_list = legion_info.union_id.."\r\n"..btype
        NetworkManager:register(protocol_command.union_apply.code, nil, nil, nil, self, responseUnionSearchCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(legion_infor_window_open_terminal)
state_machine.add(legion_infor_window_close_terminal)
state_machine.add(legion_infor_window_apply_add_union_terminal)
state_machine.init()

function LegionInforWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._legion_info = nil
    self._from_type = nil

     -- Initialize alert_home state machine.
    local function init_legion_infor_window_terminal()
        -- 申请加入军团
        local legion_infor_window_apply_add_terminal = {
            _name = "legion_infor_window_apply_add",
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

        state_machine.add(legion_infor_window_apply_add_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_infor_window_terminal()
end

-- 显示信息
function LegionInforWindow:onUpdateDraw()
    local root = self.roots[1]
    local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name")             -- 军团名
    local Text_legion_leader_n = ccui.Helper:seekWidgetByName(root, "Text_legion_leader_n")     -- 团长名
    local Text_recruit_declaration_n = ccui.Helper:seekWidgetByName(root, "Text_recruit_declaration_n")     -- 招募宣言
    local Text_legion_lv_n = ccui.Helper:seekWidgetByName(root, "Text_legion_lv_n")             -- 军团等级
    local Text_legion_fight_n = ccui.Helper:seekWidgetByName(root, "Text_legion_fight_n")       -- 战力
    local Text_legion_people_n = ccui.Helper:seekWidgetByName(root, "Text_legion_people_n")     -- 成员人数
    local Text_legion_way_n = ccui.Helper:seekWidgetByName(root, "Text_legion_way_n")           -- 加入方式
    local Text_add_condition_n = ccui.Helper:seekWidgetByName(root, "Text_add_condition_n")     -- 加入条件
    local Text_legion_tank_n = ccui.Helper:seekWidgetByName(root, "Text_legion_tank_n")     --排名

    Text_legion_name:setString(self._legion_info.union_name)
    Text_legion_leader_n:setString(self._legion_info.union_president_name)
    Text_legion_fight_n:setString(exChangeNumToString(self._legion_info.union_fight))
    Text_legion_lv_n:setString(self._legion_info.union_level)
    Text_legion_tank_n:setString(self._legion_info.union_rank)

    if tonumber(self._legion_info.need_verify) == 0 then
        Text_legion_way_n:setString(tipString_legion_info[1])
    else
        Text_legion_way_n:setString(tipString_legion_info[2])
    end
    Text_add_condition_n:setString(string.format(tipString_legion_info[3], self._legion_info.need_level, exChangeNumToString(self._legion_info.need_combat_force)))

    local max_member = dms.int(dms["union_lobby_param"], tonumber(self._legion_info.union_level), union_lobby_param.maxMember)
    Text_legion_people_n:setString(self._legion_info.union_member .. "/" .. max_member)

    if self._from_type == 1 then
        Text_recruit_declaration_n:setString(self._legion_info.union_watchword)
    elseif self._from_type == 2 then
        Text_recruit_declaration_n:setString(self._legion_info.watchword)
    end

    if Text_recruit_declaration_n:getString() == tipString_legion_info[14] then
        Text_recruit_declaration_n:setString(tipString_legion_info[24])
    end

    -- 申请状态
    local Button_boom_sure = ccui.Helper:seekWidgetByName(root, "Button_boom_sure")
    if zstring.tonumber(self._legion_info.union_appiy) > 0 then
        Button_boom_sure:setTitleText(tipString_legion_info[5])
        Button_boom_sure:setBright(false)
    else
        Button_boom_sure:setTitleText(tipString_legion_info[4])
        Button_boom_sure:setBright(true)
    end
end

--初始化界面
function LegionInforWindow:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_infor_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_infor_close"), nil, 
    {
        terminal_name = "legion_infor_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)   
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)   

    -- 加入军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boom_sure"), nil, 
    {
        terminal_name = "legion_infor_window_apply_add", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self:onUpdateDraw()
end

--初始化
function LegionInforWindow:init(legion_info, from_type)
    self._legion_info = legion_info
    self._from_type = from_type
    self:onInit()
end

--移除状态机
function LegionInforWindow:onExit()
    state_machine.remove("legion_infor_window_apply_add")
end