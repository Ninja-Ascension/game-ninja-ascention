-----------------------------
--军团信息
-----------------------------
LegionInfomation = class("LegionInfomationClass", Window)

local legion_infomation_window_open_terminal = {
    _name = "legion_infomation_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = LegionInfomation:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_infomation_window_open_terminal)
state_machine.init()

function LegionInfomation:ctor()
    self.super:ctor()
    self.roots = {}

    self._user_union_info = nil

    local function init_legion_infomation_terminal()
        --显示界面
        local legion_infomation_show_terminal = {
            _name = "legion_infomation_show",
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
        local legion_infomation_hide_terminal = {
            _name = "legion_infomation_hide",
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

        -- 功能
        local legion_infomation_goto_use_terminal = {
            _name = "legion_infomation_goto_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if params._datas.index == 1 then
                    state_machine.excute("legion_pve_window_open", 0, {self._user_union_info})
                elseif params._datas.index == 2 then
                    state_machine.excute("legion_technology_donate_window_open", 0, "")
                elseif params._datas.index == 3 then
                    state_machine.excute("legion_shop_window_open", 0, "")
                elseif params._datas.index == 4 then
                    state_machine.excute("rank_window_open", 0, {_datas = {list_type = 4}})
                elseif params._datas.index == 5 then
                    state_machine.excute("legion_active_open", 0, nil)
                elseif params._datas.index == 6 then
                    if funOpenDrawTip(155, false) == true then
                        TipDlg.drawTextDailog(red_alert_time_str[159])
                    else
                        state_machine.excute("legion_hegemony_window_open", 0, nil)
                    end
                elseif params._datas.index == 7 then
                    state_machine.excute("legion_welfare_window_open", 0, nil)
                elseif params._datas.index == 8 then
                    state_machine.excute("legion_application_confirmation_window_open", 0, "")
                elseif params._datas.index == 9 then
                    state_machine.excute("legion_manage_window_open", 0, {instance._user_union_info})
                elseif params._datas.index == 10 then
                    state_machine.excute("legion_pk_open", 0, nil)
                elseif params._datas.index == 11 then
                    state_machine.excute("legion_city_open", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local legion_infomation_update_draw_terminal = {
            _name = "legion_infomation_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 退出军团
        local legion_infomation_go_out_terminal = {
            _name = "legion_infomation_go_out",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.union.user_union_info.union_post) == 1 and tonumber(_ED.union.union_info.members) > 1 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[46])
                else
                    state_machine.excute("legion_exit_prompt_window_open", 0, {instance._user_union_info.id})
                    -- local tip = ConfirmTip:new()
                    -- tip:init(instance, instance.quxSureTipCallBack, tipStringInfo_union_str[47])
                    -- fwin:open(tip, fwin._ui)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_infomation_show_terminal)  
        state_machine.add(legion_infomation_hide_terminal)
        state_machine.add(legion_infomation_update_draw_terminal)
        state_machine.add(legion_infomation_goto_use_terminal)
        state_machine.add(legion_infomation_go_out_terminal)  
        state_machine.init()
    end
    init_legion_infomation_terminal()
end

function LegionInfomation:onHide()
    self:setVisible(false)
end

function LegionInfomation:onShow()
    self:setVisible(true)
end

function LegionInfomation:onUpdateDraw()
    local union_info = _ED.union.union_info
    local root = self.roots[1]
    local Text_legion_name = ccui.Helper:seekWidgetByName(root,"Text_legion_name")
    local Text_legion_lv = ccui.Helper:seekWidgetByName(root,"Text_legion_lv")
    local Text_legion_leader_n = ccui.Helper:seekWidgetByName(root,"Text_legion_leader_n")
    local LoadingBar_legion_contribution = ccui.Helper:seekWidgetByName(root,"LoadingBar_legion_contribution")
    local Text_legion_leader_deputy_n = ccui.Helper:seekWidgetByName(root,"Text_legion_leader_deputy_n")
    local Text_legion_fight_n = ccui.Helper:seekWidgetByName(root,"Text_legion_fight_n")
    local Text_legion_rank_n = ccui.Helper:seekWidgetByName(root,"Text_legion_rank_n")
    local Text_legion_people_n = ccui.Helper:seekWidgetByName(root,"Text_legion_people_n")
    local Text_legion_notice_infor = ccui.Helper:seekWidgetByName(root,"Text_legion_notice_infor")
    local Text_legion_lv_ing_n = ccui.Helper:seekWidgetByName(root,"Text_legion_lv_ing_n")

    -- 军团名
    Text_legion_name:setString(union_info.union_name)
    Text_legion_name:setColor(cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3]))
    local Position_x = Text_legion_name:getPositionX() + Text_legion_name:getContentSize().width
    -- 军团等级
    Text_legion_lv:setString(string.format(red_alert_all_str[117],union_info.union_grade))
    Text_legion_lv:setPositionX(Position_x + 15)

    -- 团长名/副团长数量
    local vice_chairman_count = 0
    for k,v in pairs(_ED.union.union_member_list_info) do
        if tonumber(v.post) == 2 then
            vice_chairman_count = vice_chairman_count + 1
        end
        if tonumber(v.id) == tonumber(_ED.user_info.user_id) then
            self._user_union_info = v
        end
    end
    local memberNum = zstring.split(dms.string(dms["union_config"], 1, union_config.param), ",")[2]
    Text_legion_leader_n:setString(union_info.union_head_name)
    if Text_legion_leader_deputy_n ~= nil then
        Text_legion_leader_deputy_n:setString(vice_chairman_count.."/"..memberNum)
    end
    
    -- 成员数量
    if Text_legion_people_n ~= nil then
        local maxMember = dms.int(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxMember)
        Text_legion_people_n:setString(union_info.members.."/"..maxMember)
    end
    -- 战力
    if Text_legion_fight_n ~= nil then
        Text_legion_fight_n:setString(exChangeNumToString(union_info.combat_force))
    end

    -- 排名
    if Text_legion_rank_n ~= nil then
        Text_legion_rank_n:setString(union_info.ranking)
    end

    -- 公告
    local bulletin = union_info.bulletin
    if bulletin == "" then
        bulletin = tipString_legion_info[24]
    end
    Text_legion_notice_infor:setString(bulletin)

    -- 经验
    local maxProgress = dms.int(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxExp)

    Text_legion_lv_ing_n:setString(union_info.union_worship.."/"..maxProgress)
    LoadingBar_legion_contribution:setPercent(tonumber(union_info.union_worship) * 100/tonumber(maxProgress))
    --如果公会满级了
    if tonumber(maxProgress) == -1 then
        Text_legion_lv_ing_n:setString(tipStringInfo_union_str[70])
        LoadingBar_legion_contribution:setPercent(100)
    else    --如果公会没满级
        Text_legion_lv_ing_n:setString(union_info.union_worship.."/"..maxProgress)
        LoadingBar_legion_contribution:setPercent(tonumber(union_info.union_worship) * 100/tonumber(maxProgress))
    end

    local Button_legion_manage = ccui.Helper:seekWidgetByName(root, "Button_legion_manage")
    local Button_legion_mail = ccui.Helper:seekWidgetByName(root, "Button_legion_mail")
    if tonumber(_ED.union.user_union_info.union_post) > 2 then
        if Button_legion_manage ~= nil then
            Button_legion_manage:setBright(false)
            Button_legion_manage:setTouchEnabled(false)
        end
        if Button_legion_mail ~= nil then
            Button_legion_mail:setBright(false)
            Button_legion_mail:setTouchEnabled(false)
        end
    else
        if Button_legion_manage ~= nil then
            Button_legion_manage:setBright(true)
            Button_legion_manage:setTouchEnabled(true)
        end
        if Button_legion_mail ~= nil then
            Button_legion_mail:setBright(true)
            Button_legion_mail:setTouchEnabled(true)
        end
    end
end

function LegionInfomation:onEnterTransitionFinish()

end

function LegionInfomation:onInit( )
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_contribution_add"), nil, 
    {
        terminal_name = "legion_technology_donate_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    for i=1,11 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_function_"..i), nil, 
        {
            terminal_name = "legion_infomation_goto_use", 
            terminal_state = 0, 
            touch_black = true,
            index = i ,
        }, nil, 1)
    end
    if tonumber(_ED.union.user_union_info.union_post) == 1 or tonumber(_ED.union.user_union_info.union_post) == 2 then
        local check = ccui.Helper:seekWidgetByName(root, "Button_legion_function_8")
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_legion_apply",
        _widget = check,
        _invoke = nil,
        _interval = 0.2,})
    end

    local can_receive = ccui.Helper:seekWidgetByName(root, "Button_legion_function_1")
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_legion_pve_receive",
        _widget = can_receive,
        _invoke = nil,
        _interval = 0.2,})

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_legion_city_reward",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_legion_function_11"),
        _invoke = nil,
        _interval = 0.2,})

    -- 协防设置
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_help_set"), nil, 
    {
        terminal_name = "legion_set_attack_help_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 军团邮件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_mail"), nil, 
    {
        terminal_name = "legion_mail_write_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 2,
    }, nil, 1)

    -- 退出军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_exit"), nil, 
    {
        terminal_name = "legion_infomation_go_out", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 军团管理
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_manage"), nil, 
    {
        terminal_name = "legion_manage_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)


    self:onUpdateDraw()
end

function LegionInfomation:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function LegionInfomation:onExit()
    state_machine.remove("legion_infomation_show")
    state_machine.remove("legion_infomation_hide")
    state_machine.remove("legion_infomation_update_draw")
    state_machine.remove("legion_infomation_goto_use")
    state_machine.remove("legion_infomation_go_out")
end
