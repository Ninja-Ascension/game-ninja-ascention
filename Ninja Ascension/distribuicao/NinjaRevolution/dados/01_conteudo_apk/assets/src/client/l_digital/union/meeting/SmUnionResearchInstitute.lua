-- ----------------------------------------------------------------------------------------------------
-- 说明：公会研究院
-------------------------------------------------------------------------------------------------------
SmUnionResearchInstitute = class("SmUnionResearchInstituteClass", Window)

local sm_union_research_institute_open_terminal = {
    _name = "sm_union_research_institute_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("union_lock_state_machine", 0, nil)
        local server_time = _ED.system_time + (os.time() - _ED.native_time) - _ED.GTM_Time
        if _ED.union.user_union_info.union_last_enter_time - server_time > 0 then
            state_machine.excute("union_unlock_state_machine", 0, nil)
            TipDlg.drawTextDailog(_new_interface_text[195])
            return
        end
        state_machine.lock("notification_center_update")
		local _homeWindow = fwin:find("SmUnionResearchInstituteClass")
        if nil == _homeWindow then
            local panel = SmUnionResearchInstitute:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_research_institute_close_terminal = {
    _name = "sm_union_research_institute_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("union_unlock_state_machine", 0, nil)
        state_machine.unlock("notification_center_update")
        state_machine.excute("hero_list_view_update_cell_strength_button_push",0,"hero_list_view_update_cell_strength_button_push.")
        state_machine.excute("hero_list_view_update_cell_equip_button_push",0,"hero_list_view_update_cell_equip_button_push.")
        state_machine.excute("notification_center_update",0,"push_notification_center_ship_warehouse_all")
        state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_home_hero_icon")
        state_machine.excute("notification_center_update",0,"push_notification_center_hero_develop_duplicate_formation")
        state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity")
        state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity_daily_page_button")
        
        state_machine.excute("notification_center_update", 0, "sm_push_notification_center_union_main_window_adventure")--工会大冒险
        state_machine.excute("notification_center_update", 0, "sm_push_notification_center_union_main_window_research_institute")--研究院
        state_machine.excute("notification_center_update", 0, "sm_push_notification_center_union_main_window_slot_machine")--老虎机
        state_machine.excute("notification_center_update", 0, "push_notification_center_union_all")--主界面工会按钮
		local _homeWindow = fwin:find("SmUnionResearchInstituteClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionResearchInstituteClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_research_institute_open_terminal)
state_machine.add(sm_union_research_institute_close_terminal)
state_machine.init()
    
function SmUnionResearchInstitute:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    app.load("client.l_digital.union.heaven.UnionHeaven")
    app.load("client.l_digital.union.heaven.SmUnionInstituteDonate")
    local function init_sm_union_research_institute_terminal()
        -- 显示界面
        local sm_union_research_institute_display_terminal = {
            _name = "sm_union_research_institute_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionResearchInstituteWindow = fwin:find("SmUnionResearchInstituteClass")
                if SmUnionResearchInstituteWindow ~= nil then
                    SmUnionResearchInstituteWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_research_institute_hide_terminal = {
            _name = "sm_union_research_institute_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionResearchInstituteWindow = fwin:find("SmUnionResearchInstituteClass")
                if SmUnionResearchInstituteWindow ~= nil then
                    SmUnionResearchInstituteWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 进入捐献界面
        local sm_union_research_institute_open_donation_terminal = {
            _name = "sm_union_research_institute_open_donation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_heaven_open", 0, 1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 进入
        local sm_union_research_institute_open_institute_terminal = {
            _name = "sm_union_research_institute_open_institute",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = params._datas._page
                state_machine.excute("sm_union_institute_donate_open", 0, page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local sm_union_research_institute_update_draw_terminal = {
            _name = "sm_union_research_institute_update_draw",
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

        state_machine.add(sm_union_research_institute_display_terminal)
        state_machine.add(sm_union_research_institute_hide_terminal)
        state_machine.add(sm_union_research_institute_open_donation_terminal)
        state_machine.add(sm_union_research_institute_open_institute_terminal)
        state_machine.add(sm_union_research_institute_update_draw_terminal)
        state_machine.init()
    end
    init_sm_union_research_institute_terminal()
end

function SmUnionResearchInstitute:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local science_info = zstring.split(_ED.union_science_info,"|")
    local hall_technology = zstring.split(science_info[1],",")
   --工会等级
   local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv")
   Text_lv:setString(_ED.union.union_info.union_grade)

   --工会经验
   local maxMember = dms.int(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxExp)
   local Text_exp = ccui.Helper:seekWidgetByName(root, "Text_exp")
   Text_exp:setString(hall_technology[2].."/"..maxMember)
   local LoadingBar_exp = ccui.Helper:seekWidgetByName(root, "LoadingBar_exp")
   local persent = math.floor(tonumber(hall_technology[2])/maxMember*100)
   LoadingBar_exp:setPercent(persent)
   if maxMember == -1 then
        Text_exp:setString("")
        LoadingBar_exp:setPercent(100)
   end
   
   --今日捐献次数
   local Text_jxcs_n = ccui.Helper:seekWidgetByName(root, "Text_jxcs_n")
   local maxNumber = dms.int(dms["union_config"], 18, union_config.param)
   Text_jxcs_n:setString((maxNumber - tonumber(hall_technology[4])).."/"..maxNumber)
   --今日公会经验
   local Text_exp_today = ccui.Helper:seekWidgetByName(root, "Text_exp_today")
   local LoadingBar_exp_today = ccui.Helper:seekWidgetByName(root, "LoadingBar_exp_today")
   local maxMember = dms.int(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxMember)
   local addition = zstring.split(dms.string(dms["union_science_level"], 1, union_science_level.silver_reward) ,"|")
   local expAdd = zstring.split(addition[1] ,",")
   local nowExpMax = maxMember*tonumber(expAdd[3])*maxNumber
   nowExpMax = dms.int(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxProgress)
   Text_exp_today:setString(hall_technology[3].."/"..nowExpMax)

   LoadingBar_exp_today:setPercent(tonumber(hall_technology[3])/nowExpMax*100)

   if maxNumber - tonumber(hall_technology[4]) <= 0 then
        ccui.Helper:seekWidgetByName(root,"Button_juanxian"):setBright(false)
        Text_jxcs_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
   else
        ccui.Helper:seekWidgetByName(root,"Button_juanxian"):setBright(true)
        Text_jxcs_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
   end

   local open_2 = dms.int(dms["fun_open_condition"], 144, fun_open_condition.union_level)
   local open_3 = dms.int(dms["fun_open_condition"], 145, fun_open_condition.union_level)
   local open_4 = dms.int(dms["fun_open_condition"], 146, fun_open_condition.union_level)
   if open_2 > tonumber(_ED.union.union_info.union_grade) then
        ccui.Helper:seekWidgetByName(root,"Image_lock_bg_2"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_open_lv_2"):setString(string.format(_new_interface_text[62],open_2))
        ccui.Helper:seekWidgetByName(root,"Button_play_2"):setTouchEnabled(false)
   else
        ccui.Helper:seekWidgetByName(root,"Image_lock_bg_2"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_open_lv_2"):setString(string.format(_new_interface_text[62],open_2))
        ccui.Helper:seekWidgetByName(root,"Button_play_2"):setTouchEnabled(true)
   end

   if open_3 > tonumber(_ED.union.union_info.union_grade) then
        ccui.Helper:seekWidgetByName(root,"Image_lock_bg_3"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_open_lv_3"):setString(string.format(_new_interface_text[62],open_3))
        ccui.Helper:seekWidgetByName(root,"Button_play_3"):setTouchEnabled(false)
   else
        ccui.Helper:seekWidgetByName(root,"Image_lock_bg_3"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_open_lv_3"):setString(string.format(_new_interface_text[62],open_3))
        ccui.Helper:seekWidgetByName(root,"Button_play_3"):setTouchEnabled(true)
   end

   if open_4 > tonumber(_ED.union.union_info.union_grade) then
        ccui.Helper:seekWidgetByName(root,"Image_lock_bg_4"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Text_open_lv_4"):setString(string.format(_new_interface_text[62],open_4))
        ccui.Helper:seekWidgetByName(root,"Button_play_4"):setTouchEnabled(false)
   else
        ccui.Helper:seekWidgetByName(root,"Image_lock_bg_4"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Text_open_lv_4"):setString(string.format(_new_interface_text[62],open_4))
        ccui.Helper:seekWidgetByName(root,"Button_play_4"):setTouchEnabled(true)
   end

end

function SmUnionResearchInstitute:init(params)
    self.example = params
    self:onInit()
    return self
end

function SmUnionResearchInstitute:onInit()
    local csbSmUnionResearchInstitute = csb.createNode("legion/sm_legion_research_institute.csb")
    local root = csbSmUnionResearchInstitute:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionResearchInstitute)
    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_03"), nil, 
    {
        terminal_name = "sm_union_research_institute_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

    -- 等级捐献
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_juanxian"), nil, 
    {
        terminal_name = "sm_union_research_institute_open_donation",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)

    for i=1 ,4 do
        -- 科技捐献
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_play_"..i), nil, 
        {
            terminal_name = "sm_union_research_institute_open_institute",
            terminal_state = 0,
            _page = i,
            touch_black = true
        },
        nil,0)
    end
    
end

function SmUnionResearchInstitute:onExit()
    state_machine.remove("sm_union_research_institute_display")
    state_machine.remove("sm_union_research_institute_hide")
end