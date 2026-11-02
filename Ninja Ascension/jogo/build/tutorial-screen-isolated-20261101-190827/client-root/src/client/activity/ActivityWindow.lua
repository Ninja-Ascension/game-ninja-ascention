-- ----------------------------------------------------------------------------------------------------
-- 说明：活动主界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
isUseNewActivityMode = false
if __lua_project_id == __lua_project_gragon_tiger_gate 
	or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
	or __lua_project_id == __lua_project_red_alert 
	or __lua_project_id == __lua_project_digimon_adventure 
	or __lua_project_id == __lua_project_naruto
	or __lua_project_id == __lua_project_yugioh
	or __lua_project_id == __lua_project_warship_girl_b 
	or __lua_project_id == __lua_project_pokemon 
	or __lua_project_id == __lua_project_rouge
	then
	isUseNewActivityMode = true
end

ActivityWindow = class("ActivityWindowClass", Window)

local activity_window_open_terminal = {
    _name = "activity_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local activityWindow = fwin:find("ActivityWindowClass")
		if activityWindow ~= nil and activityWindow:isVisible() == true then
			return true
		end
    	state_machine.lock("activity_window_open", 0, "")
    	if isUseNewActivityMode == true then
    		state_machine.excute("activity_window_loading", 0, params)
    	else
			Loading.loading(
	        {
	            _pic = {}, 
	            _plist = {
	                {
	                    _png = {"images/ui/play/wonderful_activity/wonderful_he_1.png"}, 
	                    _plist = {"images/ui/play/wonderful_activity/wonderful_he_1.plist"}
	                },
	                {
	                    _png = {"images/ui/play/wonderful_activity/wonderful_he_2.png"}, 
	                    _plist = {"images/ui/play/wonderful_activity/wonderful_he_2.plist"}
	                },
	                {
	                    _png = {"images/ui/play/wonderful_activity/wonderful_list.png"}, 
	                    _plist = {"images/ui/play/wonderful_activity/wonderful_list.plist"}
	                }
	            }, 
	            _ui = {}
	        },
	        nil,
	        {"activity_window_loading", 0, params})
       	end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_window_loading_terminal = {
    _name = "activity_window_loading",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	state_machine.unlock("activity_window_open", 0, "")
    	local packageName = params[1]
    	local windowName = params[2]
    	if packageName ~= nil and #packageName > 0 then
    		app.load(packageName)
    	end
    	state_machine.excute("menu_clean_page_state", 0, "home")
    	local activityWindow = fwin:find("ActivityWindowClass")
    	if activityWindow == nil then
    		activityWindow = ActivityWindow:new():init()
			fwin:open(activityWindow, fwin._view)
		else
			activityWindow:setVisible(true)
			activityWindow.userInfo:setVisible(true)
			activityWindow:reloadAsyncPage()
		end
		fwin:__hide(fwin._frameview)
		state_machine.excute("activity_window_change_to_page", 0, windowName)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
            state_machine.excute("activity_window_check_activity_info", 0, "")
		else
			activityWindow:checkupReplyPhysical()
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_window_hide_terminal = {
    _name = "activity_window_hide",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local activityWindow = fwin:find("ActivityWindowClass")
    	if activityWindow ~= nil then
    		activityWindow.currentIndex = -1
			activityWindow:setVisible(false)
			if activityWindow.userInfo ~= nil then
				activityWindow.userInfo:setVisible(false)
			end
			activityWindow:clearAllPages()
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_window_show_terminal = {
    _name = "activity_window_show",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local activityWindow = fwin:find("ActivityWindowClass")
    	if activityWindow ~= nil then
    		activityWindow.currentIndex = -1
			activityWindow:setVisible(true)
			if  activityWindow.userInfo ~= nil then
				activityWindow.userInfo:setVisible(true)
			end
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_window_open_terminal)
state_machine.add(activity_window_loading_terminal)
state_machine.add(activity_window_hide_terminal)
state_machine.add(activity_window_show_terminal)
state_machine.init()

-- 外界要定位到哪个活动直接调用状态机【activity_window_change_to_page】并传对应活动的名字（字符串）

-- 1：签到			 key : 		"DailySignIn"
-- 2：首冲礼包		 key :	 	"FirstRecharge"
-- 3：累冲礼包		 key :	 	"AccumlateRechargeable"
-- 4：月卡			 key :	 	"MonthCard"
-- 5：迎财神			 key :	 	"WelcomeMammon"
-- 6：回体力			 key :	 	"addEnergy"
-- 7：累积消费		 key :	 	"AccumlateConsumption"
-- 8：七日活动		 key :	 	"SevenDays"
-- 9：开服基金		 key :	 	"OpenServer"
-- 10：杂货铺		 key :	 	"VarietyShop"
-- 11：VIP礼包		 key :	 	"VipPackage"
-- 12:分享           key :	 	"SharePage"
function ActivityWindow:ctor()
    self.super:ctor()
	app.load("client.player.UserInformationHeroStorage") 
	app.load("client.cells.activity.activity_icon_cell")
	self.roots = {}
	self.PageViewAty = nil
	self.lastIndex = -1
	self.currentIndex = 1
	self.pageKeys = {
		--{key = "", page = nil},
		--{key = "", page = nil},
		--{key = "", page = nil},
	}
	self.Panel_page_act = nil
	self.lastpage = nil

	self.listView = nil

	self._activity_list = {}
    -- Initialize ActivityWindow state machine.
    local function init_activity_window_terminal()
		
		local activity_window_control_change_terminal = {
            _name = "activity_window_control_change",
            _init = function (terminal) 
                
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local tabCtrl = params
				instance:activityReplyPhysicalPage(tabCtrl)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新活动
		local activity_window_refresh_button_terminal = {
            _name = "activity_window_refresh_button",
            _init = function (terminal) 
                
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:activityWindowRefresh()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local activity_window_change_to_page_terminal = {
            _name = "activity_window_change_to_page",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local name = params
                instance:changeToPage(name)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local activity_window_lazy_terminal = {
            _name = "activity_window_lazy",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local windowInstance = params
				if windowInstance ~= nil and windowInstance.lazy ~= nil then
					windowInstance:lazy()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local activity_window_unload_terminal = {
            _name = "activity_window_unload",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local windowInstance = params
				if windowInstance ~= nil and windowInstance.unload ~= nil then
					windowInstance:unload()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_window_remove_activity_page_terminal = {
            _name = "activity_window_remove_activity_page",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:removeActivityPage(params[1], params[2])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		-- 返回主页
		local activity_window_close_terminal = {
            _name = "activity_window_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					state_machine.excute("activity_window_hide", 0, "activity_window_hide")
					state_machine.excute("menu_back_home_page", 0, "menu_back_home_page")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_window_open_page_activity_terminal = {
            _name = "activity_window_open_page_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				for i, v in pairs(instance.listView:getItems()) do
					if v.pagekey == params[1] then
						state_machine.excute("activity_window_control_change", 0, v)
						break
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_window_update_activity_info_terminal = {
            _name = "activity_window_update_activity_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
            		local isAdd = true
					for i,v in pairs(instance._activity_list) do
                        if zstring.tonumber(v) == tonumber(params) then
                            isAdd = false
                            break
                        end
                    end
                	if isAdd == true then
                		instance:addNewActivity(params)
                	end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_window_remove_activity_info_terminal = {
            _name = "activity_window_remove_activity_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                	for k,pageInfo in pairs(instance.pageKeys) do
                		if pageInfo ~= nil and zstring.tonumber(pageInfo.activity_type) == tonumber(params) then
                			for i,v in pairs(instance._activity_list) do
		                        if tonumber(v) == tonumber(params) then
		                            instance._activity_list[i] = nil
		                            break
		                        end
		                    end
                			instance:removeActivityPage(pageInfo.page, pageInfo.key)
                    		break
                		end
                	end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_window_check_activity_info_terminal = {
            _name = "activity_window_check_activity_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:checkAllActivity()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_window_update_activity_page_terminal = {
            _name = "activity_window_update_activity_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    for k,pageInfo in pairs(instance.pageKeys) do
                        if pageInfo ~= nil and zstring.tonumber(pageInfo.activity_type) == tonumber(params) then
                            if pageInfo.page ~= nil and pageInfo.page.onUpdateDraw ~= nil then
                                pageInfo.page:onUpdateDraw()
                            end
                            break
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_window_update_activity_info_by_type_terminal = {
            _name = "activity_window_update_activity_info_by_type",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateActivityInfoByType(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_window_list_view_jump_bottom_terminal = {
            _name = "activity_window_list_view_jump_bottom",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    function blinkOutCallback(sender)
                        ccui.Helper:seekWidgetByName(instance.roots[1], "ListView_wonder_btn"):jumpToBottom()
                    end
                    instance:runAction(cc.Sequence:create(
                        cc.DelayTime:create(0.5),
                        cc.CallFunc:create(blinkOutCallback)
                        ))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		state_machine.add(activity_window_close_terminal)
		state_machine.add(activity_window_control_change_terminal)
		state_machine.add(activity_window_refresh_button_terminal)
		state_machine.add(activity_window_change_to_page_terminal)
		state_machine.add(activity_window_lazy_terminal)
		state_machine.add(activity_window_unload_terminal)
		state_machine.add(activity_window_remove_activity_page_terminal)
		state_machine.add(activity_window_open_page_activity_terminal)
		state_machine.add(activity_window_update_activity_info_terminal)
		state_machine.add(activity_window_remove_activity_info_terminal)
        state_machine.add(activity_window_check_activity_info_terminal)
        state_machine.add(activity_window_update_activity_page_terminal)
        state_machine.add(activity_window_update_activity_info_by_type_terminal)
        state_machine.add(activity_window_list_view_jump_bottom_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityWindow state machine.
    init_activity_window_terminal()
end

function ActivityWindow:updateActivityInfoByType( activity_type )
    for i, v in pairs(self.pageKeys) do
        if v ~= nil
            and zstring.tonumber(v.activity_type) == zstring.tonumber(activity_type)
            and v.page.loaded == true 
            and v.page.onUpdateDrawData ~= nil
            then
            v.page:onUpdateDrawData()
            break
        end
    end 
end

function ActivityWindow:checkAllActivity()
    local show_activity = {}

    local current_time = os.time() + _ED.time_add_or_sub
    for k, v in pairs(_ED.active_activity) do
        if tonumber(k) == 48
            or tonumber(k) == 47
            or tonumber(k) == 44
            or tonumber(k) == 43
            or tonumber(k) == 45
            or tonumber(k) == 49
            or tonumber(k) == 70
            or tonumber(k) == 71
            or tonumber(k) == 76
            or tonumber(k) == 38
            or tonumber(k) == 24
            then
            table.insert(show_activity, ""..k)
        elseif tonumber(k) == 28 then
            local surplus_time = tonumber(v.activity_login_day) - current_time
            if surplus_time > 0 then
                -- table.insert(show_activity, ""..k)
            end
        elseif tonumber(k) == 7
            or tonumber(k) == 17
            or tonumber(k) == 81
            or tonumber(k) == 82
            or tonumber(k) == 83
            or tonumber(k) == 90
            or tonumber(k) == 77
            or tonumber(k) == 91
            or tonumber(k) == 92
            or tonumber(k) == 93
            or tonumber(k) == 94
            or tonumber(k) == 95
            or tonumber(k) == 96
            or tonumber(k) == 97
            or tonumber(k) == 98
            or tonumber(k) == 99
            or tonumber(k) == 100
            or tonumber(k) == 101
            or tonumber(k) == 102
            or tonumber(k) == 103
            or tonumber(k) == 104
            or tonumber(k) == 105
            or tonumber(k) == 106
            or tonumber(k) == 108
            or tonumber(k) == 109
            or tonumber(k) == 110
            or tonumber(k) == 111
            or tonumber(k) == 112
            or tonumber(k) == 113
            or tonumber(k) == 114
            or tonumber(k) == 115
            or tonumber(k) == 116
            or tonumber(k) == 117
            or tonumber(k) == 118
            or tonumber(k) == 119
            or tonumber(k) == 120
            or tonumber(k) == 121
            or tonumber(k) == 122
            or tonumber(k) == 123
            or tonumber(k) == 124
            or tonumber(k) == 125
            or tonumber(k) == 126
            or tonumber(k) == 127
            or tonumber(k) == 128
            or tonumber(k) == 129
            or tonumber(k) == 130
            or tonumber(k) == 131
            or tonumber(k) == 132
            or tonumber(k) == 133
            or tonumber(k) == 134
            or tonumber(k) == 135
            or tonumber(k) == 136
            or tonumber(k) == 138
            or tonumber(k) == 139
            or tonumber(k) == 140
            or tonumber(k) == 141
            then
            local end_time = 0
            if tonumber(k) == 81 
                or tonumber(k) == 82
                or tonumber(k) == 95
                or tonumber(k) == 115
                or tonumber(k) == 116
                then
                local other_info = zstring.split(v.activity_params, "|")
                end_time = tonumber(other_info[2]) / 1000
            elseif tonumber(k) == 77 
                or tonumber(k) == 117
                or tonumber(k) == 118
                then
                local other_info = zstring.split(v.activity_params, "|")
                end_time = tonumber(other_info[8]) / 1000
            elseif tonumber(k) == 119 
                then
                local other_info = zstring.split(v.activity_params, "|")
                end_time = tonumber(other_info[4]) / 1000
            else
                end_time = tonumber(v.end_time) / 1000
            end
            local surplus_time = end_time - current_time
            if surplus_time > 0 then
                table.insert(show_activity, ""..k)
            end
        elseif tonumber(k) == 78
            or tonumber(k) == 79
            or tonumber(k) == 80
            then
            if funOpenDrawTip(k + 75, false) == false then
                local surplus_time = tonumber(v.end_time) / 1000 - current_time
                if surplus_time > 0 then
                    table.insert(show_activity, ""..k)
                end
            end
        elseif tonumber(k) == 27 then
            if tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 150, fun_open_condition.level) then
                local is_show = false
                for j, w in pairs(v.activity_Info) do
                    if tonumber(w.activityInfo_isReward) == 0 then
                        is_show = true
                        break
                    end
                end
                if is_show == true then
                    table.insert(show_activity, ""..k)
                end
            end
        elseif tonumber(k) == 68 then  
            if open_share_fun == 1 then -- tipstring里的开关，1 是打开，0是关闭
                table.insert(show_activity, ""..k)
            end
        elseif tonumber(k) == 142 then -- 成长之路
            if tonumber(v.activity_params.actStatus) == 1 then
                table.insert(show_activity, ""..k)
            end

        elseif tonumber(k) == 150 then -- 每日充值
            table.insert(show_activity, ""..k)

        -- FURY: `onUpdateDrawNew` SI monta la pestana del 151 (:4984-4987) y
        -- mete "151" en `self._activity_list`. Pero esta lista es la que dice
        -- que pestanas DEBEN seguir vivas, y el 151 estaba comentado: en cada
        -- apertura de la ventana («activity_window_check_activity_info», :100)
        -- caia en `remove_activity` (:729-739) y `removeActivityPage` (:396)
        -- borraba la pestana recien montada. Sin error de Lua y sin rastro: la
        -- pestana simplemente no aparecia aunque el bloque 85 del 151 llegara.
        elseif tonumber(k) == 151 then -- 每日单笔充值
            table.insert(show_activity, ""..k)
        -- EL 152 NO ENTRA: su rama de `onUpdateDrawNew` esta comentada
        -- (:4979-4982) porque su entrada se movio al vestibulo, asi que no
        -- tiene pestana que mantener viva.
        -- elseif tonumber(k) == 152 then -- 每日单笔充值
        --     table.insert(show_activity, ""..k)
        elseif tonumber(k) == 156 or tonumber(k) == 156 then -- 联系我们
            table.insert(show_activity, ""..k)
        end  
    end

    -- 月卡重塑对于老月卡改为表控制
    local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 1000)
    if activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        if _ED.active_activity[192] ~= nil then 
            table.insert(show_activity, "1000")
        end
    else
        if zstring.tonumber(_ED.server_review) ~= 1 then
            local m_isVisible = false
            for i,v in pairs(_ED.month_card) do
                if tonumber(v.surplus_month_card_time) == 0 then
                    m_isVisible = true
                end
            end
            if m_isVisible == true then
                table.insert(show_activity, "1000")
            end
        end
    end

    -- 回体力
    if false == funOpenDrawTip(151,false) then
        if getSmActivityEatManualShow() == true then
            table.insert(show_activity, "1001")
        end
    end

    local add_activity = {}
    local remove_activity = {}

    for i, show_act in pairs(show_activity) do
        local is_add = true
        for j, act in pairs(self._activity_list) do
            if tonumber(show_act) == tonumber(act) then
                is_add = false
            end
        end
        if is_add == true then
            table.insert(add_activity, show_act)
        end
    end

    for j, act in pairs(self._activity_list) do
        local is_remove = true
        for i, show_act in pairs(show_activity) do
            if tonumber(show_act) == tonumber(act) then
                is_remove = false
            end
        end
        if is_remove == true then
            table.insert(remove_activity, act)
        end
    end

    for k, act in pairs(add_activity) do
        state_machine.excute("activity_window_update_activity_info", 0, act)
    end

    for k, act in pairs(remove_activity) do
        state_machine.excute("activity_window_remove_activity_info", 0, act)
    end
end

function ActivityWindow:addNewActivity( activity_type )
    local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, tonumber(activity_type))
	if tonumber(activity_type) == 48 and _ED.active_activity[48] ~= nil and _ED.active_activity[48]~="" then
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityNextDay()			--48：次日
    		table.insert(self._activity_list, "48")
        end
	end	

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        if tonumber(activity_type) == 38 and _ED.active_activity[38] ~= nil and _ED.active_activity[38]~="" then
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
                self:activitySmCheckInfo()          --48：签到
                table.insert(self._activity_list, "38")
            end
        end
    end

	if tonumber(activity_type) == 7 and _ED.active_activity[7] ~= nil and _ED.active_activity[7]~="" then
		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityAccumlate(7)			--2：累充
    		table.insert(self._activity_list, "7")
        end
	end	

    if tonumber(activity_type) == 92 and _ED.active_activity[92] ~= nil and _ED.active_activity[92]~="" then
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityAccumlate(92)           --2：累充
            table.insert(self._activity_list, "92")
        end
    end 

    if tonumber(activity_type) == 93 and _ED.active_activity[93] ~= nil and _ED.active_activity[93]~="" then  --每日折扣
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            if funOpenDrawTip(152, false) == false then
                self:activitySmDayDiscount()
                table.insert(self._activity_list, "93")
            end
        end
    end

	if tonumber(activity_type) == 47 and _ED.active_activity[47] ~= nil and _ED.active_activity[47]~="" then
    	if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityRebelArmy()			--叛军
    		table.insert(self._activity_list, "47")
        end
	end	

	if tonumber(activity_type) == 44 and _ED.active_activity[44] ~= nil and _ED.active_activity[44]~="" then
		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityDuplicateDouble()			--副本双倍
    		table.insert(self._activity_list, "44")
        end
	end	

	if tonumber(activity_type) == 43 and _ED.active_activity[43] ~= nil and _ED.active_activity[43]~="" then
		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityArenaDouble()			--演习双倍
    		table.insert(self._activity_list, "43")
        end
	end	

    -- 每日充值送礼（建号绑定）
	if tonumber(activity_type) == 77 and _ED.active_activity[77] ~= nil and _ED.active_activity[77]~="" then
		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityOneDayRecharge(77)
    		table.insert(self._activity_list, "77")
        end
	end

    -- 每日充值送礼
    if tonumber(activity_type) == 91 and _ED.active_activity[91] ~= nil and _ED.active_activity[91]~="" then
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityOneDayRecharge(91)
            table.insert(self._activity_list, "91")
        end
    end

    -- 每日充值送礼-恶魔兽
    if tonumber(activity_type) == 117 and _ED.active_activity[117] ~= nil and _ED.active_activity[117]~="" then
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityOneDayRecharge(117)
            table.insert(self._activity_list, "117")
        end
    end

    -- 每日充值送礼-V仔兽EX
    if tonumber(activity_type) == 118 and _ED.active_activity[118] ~= nil and _ED.active_activity[118]~="" then
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityOneDayRecharge(118)
            table.insert(self._activity_list, "118")
        end
    end

    -- 每日充值送礼-稀有
    if tonumber(activity_type) == 139 and _ED.active_activity[139] ~= nil and _ED.active_activity[139]~="" then
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityOneDayRecharge(139)
            table.insert(self._activity_list, "139")
        end
    end

	if tonumber(activity_type) == 45 and _ED.active_activity[45] ~= nil and _ED.active_activity[45]~="" then
		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityOnceRecharge()			--45（单笔充值活动）
    		table.insert(self._activity_list, "45")
        end
	end	

	if tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 150, fun_open_condition.level) then
		if tonumber(activity_type) == 27 and _ED.active_activity[27] ~= nil and _ED.active_activity[27]~="" then
            local is_show = false
            for j, w in pairs(_ED.active_activity[27].activity_Info) do
                if tonumber(w.activityInfo_isReward) == 0 then
                    is_show = true
                    break
                end
            end
            if is_show == true then
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 27)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activityStartServeFund()       --开服基金
                    table.insert(self._activity_list, "27")
                end
            end
		end
	end

	if tonumber(activity_type) == 68 and _ED.active_activity[68] ~= nil and _ED.active_activity[68]~="" then --分享
    	if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            if open_share_fun == 1 then -- tipstring里的开关，1 是打开，0是关闭
    			self:activityShare()
    			table.insert(self._activity_list, "68")
    		end
        end
	end

	if tonumber(activity_type) == 17 and _ED.active_activity[17] ~= nil and _ED.active_activity[17]~="" then --累计消费
		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityConsumption(17)
    		table.insert(self._activity_list, "17")
        end
	end

	if tonumber(activity_type) == 49 and _ED.active_activity[49] ~= nil and _ED.active_activity[49]~="" then  --排行榜活动
		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityFightingRank()
    		table.insert(self._activity_list, "49")
        end
	end

	if tonumber(activity_type) == 28 and _ED.active_activity[28] ~= nil and _ED.active_activity[28]~="" then  --兑换
		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
      --       self:activityHalfPriceRestrictionNew(28)
    		-- table.insert(self._activity_list, "28")
        end
	end

    if tonumber(activity_type) == 136 and _ED.active_activity[136] ~= nil and _ED.active_activity[136]~="" then  --皮肤兑换
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySkinExchangeRestriction(136)
            table.insert(self._activity_list, "136")
        end
    end


    if false then
        if tonumber(activity_type) == 24 and _ED.active_activity[24] ~= nil and _ED.active_activity[24] ~= "" then
            local is_show = false
            for k, v in pairs(_ED.active_activity[24].activity_Info) do
                if tonumber(v.activityInfo_isReward) == 0 then
                    is_show = true
                end
            end
            if is_show == true then
                if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                else
                    self:activityLoginReward()
                    table.insert(self._activity_list, "24")
                end
            end
        end
    end

	if tonumber(activity_type) == 70 and _ED.active_activity[70] ~= nil and _ED.active_activity[70]~="" then  --限时兑换二
		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityVarietyShopTwo()--限时兑换二
    		table.insert(self._activity_list, "70")
        end
	end

	if tonumber(activity_type) == 71 and _ED.active_activity[71] ~= nil and _ED.active_activity[71]~="" then  --限时兑换三
		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityVarietyShopThree()--限时兑换三
    		table.insert(self._activity_list, "71")
        end
	end
	
	if tonumber(activity_type) == 76 and _ED.active_activity[76] ~= nil and _ED.active_activity[76]~="" then  --折扣贩售
    	if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityDiscountSale()
    		table.insert(self._activity_list, "76")
        end
	end

	if tonumber(activity_type) == 78 and _ED.active_activity[78] ~= nil and _ED.active_activity[78]~="" then  --招募仙人掌
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            if funOpenDrawTip(153, false) == false then
        		self:activityRecruitShip(78)
        		table.insert(self._activity_list, "78")
            end
        end
	end

	if tonumber(activity_type) == 79 and _ED.active_activity[79] ~= nil and _ED.active_activity[79]~="" then  --招募巴多拉
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            if funOpenDrawTip(154, false) == false then
        		self:activityRecruitShip(79)
        		table.insert(self._activity_list, "79")
            end
        end
	end

	if tonumber(activity_type) == 80 and _ED.active_activity[80] ~= nil and _ED.active_activity[80]~="" then  --招募火神兽
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            if funOpenDrawTip(155, false) == false then
        		self:activityRecruitShip(80)
        		table.insert(self._activity_list, "80")
            end
        end
	end

	if tonumber(activity_type) == 81 and _ED.active_activity[81] ~= nil and _ED.active_activity[81]~="" then  --抽卡活动-送拉拉兽
    	if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmCompageCount(81)
    		table.insert(self._activity_list, "81")
        end
	end

	if tonumber(activity_type) == 82 and _ED.active_activity[82] ~= nil and _ED.active_activity[82]~="" then  --招募活动-招募数码兽
    	if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmCompageCount(82)
    		table.insert(self._activity_list, "82")
        end
	end

	if tonumber(activity_type) == 83 and _ED.active_activity[83] ~= nil and _ED.active_activity[83]~="" then  --竞技场积分奖励
    	if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmCompageCount(83)
    		table.insert(self._activity_list, "83")
        end
	end

    if tonumber(activity_type) == 116 and _ED.active_activity[116] ~= nil and _ED.active_activity[116]~="" then  --抽卡送亚古兽（建号绑定）
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmCompageCount(116)
            table.insert(self._activity_list, "116")
        end
    end

	if tonumber(activity_type) == 90 and _ED.active_activity[90] ~= nil and _ED.active_activity[90]~="" then  --点金双倍
    	if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityHeroDiscount()
    		table.insert(self._activity_list, "90")
        end
	end
    
    if tonumber(activity_type) == 1000 and zstring.tonumber(_ED.server_review) ~= 1 then    
        -- 月卡重塑对于老月卡改为表控制
        local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 1000)
        if activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            if _ED.active_activity[192] ~= nil then
                self:activityMonthCardTwo()         --3：月卡
                table.insert(self._activity_list, "1000")
            end
        else                                                    -- 月卡
            local m_isVisible = false
            for i,v in pairs(_ED.month_card) do
                if tonumber(v.surplus_month_card_time) == 0 then
                    m_isVisible = true
                end
            end
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
                if m_isVisible == true then
                    self:activityMonthCardTwo()         --3：月卡
                    table.insert(self._activity_list, "1000")
                end
            end
        end
    end

    -- 领取体力
    if tonumber(activity_type) == 1001 and false == funOpenDrawTip(151,false) then
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            if getSmActivityEatManualShow() == true then
                self:activityReplyPhysical()
                table.insert(self._activity_list, "1001")
            end
        end
    end

    if tonumber(activity_type) == 94 and _ED.active_activity[94] ~= nil and _ED.active_activity[94]~="" then  --体力购买双倍
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(94)
            table.insert(self._activity_list, "94")
        end
    end
    if tonumber(activity_type) == 95 and _ED.active_activity[95] ~= nil and _ED.active_activity[95]~="" then  --抽装备宝箱得天赋点
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(95)
            table.insert(self._activity_list, "95")
        end
    end
    if tonumber(activity_type) == 96 and _ED.active_activity[96] ~= nil and _ED.active_activity[96]~="" then  --抽装备宝箱有礼
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(96)
            table.insert(self._activity_list, "96")
        end
    end
    if tonumber(activity_type) == 97 and _ED.active_activity[97] ~= nil and _ED.active_activity[97]~="" then  --普通关卡双倍掉落
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(97)
            table.insert(self._activity_list, "97")
        end
    end
    if tonumber(activity_type) == 98 and _ED.active_activity[98] ~= nil and _ED.active_activity[98]~="" then  --精英关卡双倍掉落
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(98)
            table.insert(self._activity_list, "98")
        end
    end
    if tonumber(activity_type) == 99 and _ED.active_activity[99] ~= nil and _ED.active_activity[99]~="" then  --金币关卡双倍掉落
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(99)
            table.insert(self._activity_list, "99")
        end
    end
    if tonumber(activity_type) == 100 and _ED.active_activity[100] ~= nil and _ED.active_activity[100]~="" then  --精英副本次数增加
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(100)
            table.insert(self._activity_list, "100")
        end
    end
    if tonumber(activity_type) == 101 and _ED.active_activity[101] ~= nil and _ED.active_activity[101]~="" then  --金币副本次数增加
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(101)
            table.insert(self._activity_list, "101")
        end
    end
    if tonumber(activity_type) == 102 and _ED.active_activity[102] ~= nil and _ED.active_activity[102]~="" then  --体力购买次数奖励
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(102)
            table.insert(self._activity_list, "102")
        end
    end
    if tonumber(activity_type) == 103 and _ED.active_activity[103] ~= nil and _ED.active_activity[103]~="" then  --点金次数奖励
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(103)
            table.insert(self._activity_list, "103")
        end
    end
    if tonumber(activity_type) == 104 and _ED.active_activity[104] ~= nil and _ED.active_activity[104]~="" then  --试炼积分奖励
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(104)
            table.insert(self._activity_list, "104")
        end
    end
    if tonumber(activity_type) == 105 and _ED.active_activity[105] ~= nil and _ED.active_activity[105]~="" then  --试炼宝箱开启奖励
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(105)
            table.insert(self._activity_list, "105")
        end
    end
    if tonumber(activity_type) == 106 and _ED.active_activity[106] ~= nil and _ED.active_activity[106]~="" then  --充值送资源
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        elseif __lua_project_id == __lua_project_l_digital then
            -- DSC充值送资源移到主界面上
        else
            self:activitySmDianjin(106)
            table.insert(self._activity_list, "106")
        end
    end
    if tonumber(activity_type) == 108 and _ED.active_activity[108] ~= nil and _ED.active_activity[108]~="" then  --挑战奖励
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(108)
            table.insert(self._activity_list, "108")
        end
    end
    if tonumber(activity_type) == 109 and _ED.active_activity[109] ~= nil and _ED.active_activity[109]~="" then  --精英挑战王
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(109)
            table.insert(self._activity_list, "109")
        end
    end
    if tonumber(activity_type) == 110 and _ED.active_activity[110] ~= nil and _ED.active_activity[110]~="" then  --金币消耗
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(110)
            table.insert(self._activity_list, "110")
        end
    end
    if tonumber(activity_type) == 111 and _ED.active_activity[111] ~= nil and _ED.active_activity[111]~="" then  --VIP折扣
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmVIPDiscount()
            table.insert(self._activity_list, "111")
        end
    end
    if tonumber(activity_type) == 112 and _ED.active_activity[112] ~= nil and _ED.active_activity[112]~="" then  --道具折扣
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmPropDiscountNew()
            table.insert(self._activity_list, "112")

            -- 老版本限时折扣界面
            -- self:activitySmPropDiscount()
            -- table.insert(self._activity_list, "112")
        end
    end
    if tonumber(activity_type) == 113 and _ED.active_activity[113] ~= nil and _ED.active_activity[113]~="" then  --备战奖励
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(113)
            table.insert(self._activity_list, "113")
        end
    end
    if tonumber(activity_type) == 114 and _ED.active_activity[114] ~= nil and _ED.active_activity[114]~="" then  --机械邪龙兽来袭
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and tonumber(tonumber(activity_sequence_show[1][4])) == 2 then
        else
            self:activitySmLimited(114)
            table.insert(self._activity_list, "114")
        end
    end
    if tonumber(activity_type) == 115 and _ED.active_activity[115] ~= nil and _ED.active_activity[115]~="" then  --115.消耗钻石送礼(建号绑定）
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(115)
            table.insert(self._activity_list, "115")
        end
    end
    if tonumber(activity_type) == 119 and _ED.active_activity[119] ~= nil and _ED.active_activity[119]~="" then  --119.60元充值活动活动
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            -- El 119 NO tiene rama en activitySmDianjin (enum_type se queda
            -- en "") ni en SmActivityBuyGoldReward:onUpdateDraw (cell = nil).
            -- Su pantalla es RechargeForSixtyGiftActivity, que es justo lo que
            -- usa onUpdateDrawNew:4725 al abrir la ventana. Aqui iba por el
            -- otro camino y reventaba al llegar el 119 con la ventana abierta.
            self:activityRechargeForSixtyGift(119)
            table.insert(self._activity_list, "119")
        end
    end

    if tonumber(activity_type) == 120 and _ED.active_activity[120] ~= nil and _ED.active_activity[120]~="" then  --愚人节：关卡掉落
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(120)
            table.insert(self._activity_list, "120")
        end
    end

    if tonumber(activity_type) == 121 and _ED.active_activity[121] ~= nil and _ED.active_activity[121]~="" then  --愚人节：节日道具兑换活动
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(121)
            table.insert(self._activity_list, "121")
        end
    end

    -- if tonumber(activity_type) == 1211 and _ED.active_activity[1211] ~= nil and _ED.active_activity[1211]~="" then  --愚人节：节日道具兑换活动
    --     self:activitySmLimited(1211)
    --     table.insert(self._activity_list, "1211")
    -- end


    if tonumber(activity_type) == 122 and _ED.active_activity[122] ~= nil and _ED.active_activity[122]~="" then  --愚人节：节日登陆活动
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else 
            self:activityHolidayLogin(122)
            table.insert(self._activity_list, "122")
        end
    end

    if tonumber(activity_type) == 123 and _ED.active_activity[123] ~= nil and _ED.active_activity[123]~="" then  --关卡掉落
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(123)
            table.insert(self._activity_list, "123")
        end
    end

    if tonumber(activity_type) == 124 and _ED.active_activity[124] ~= nil and _ED.active_activity[124]~="" then  --徽章限时兑换
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityEmblemLimitTimeExchange(124)
            table.insert(self._activity_list, "124")
        end
    end

    if tonumber(activity_type) == 125 and _ED.active_activity[125] ~= nil and _ED.active_activity[125]~="" then  --徽章登陆有礼
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activityEmblemLogin(125)
            table.insert(self._activity_list, "125")
        end
    end

    if tonumber(activity_type) == 126 and _ED.active_activity[126] ~= nil and _ED.active_activity[126]~="" then  --完成任务送纪念道具
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(126)
            table.insert(self._activity_list, "126")
        end
    end

    if tonumber(activity_type) == 127 and _ED.active_activity[127] ~= nil and _ED.active_activity[127]~="" then  --纪念礼盒促销 127-112
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmPropGiftBoxPromotion()
            table.insert(self._activity_list, "127")
        end
    end

    if tonumber(activity_type) == 128 and _ED.active_activity[128] ~= nil and _ED.active_activity[128]~="" then  --经验副本次数增加
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(128)
            table.insert(self._activity_list, "128")
        end
    end

    if tonumber(activity_type) == 129 and _ED.active_activity[129] ~= nil and _ED.active_activity[129]~="" then  --技之作战副本次数增加
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(129)
            table.insert(self._activity_list, "129")
        end
    end

    if tonumber(activity_type) == 130 and _ED.active_activity[130] ~= nil and _ED.active_activity[130]~="" then  --幻像挑战副本次数增加
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(130)
            table.insert(self._activity_list, "130")
        end
    end

    if tonumber(activity_type) == 131 and _ED.active_activity[131] ~= nil and _ED.active_activity[131]~="" then  --经验副本奖励双倍
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(131)
            table.insert(self._activity_list, "131")
        end
    end

    if tonumber(activity_type) == 132 and _ED.active_activity[132] ~= nil and _ED.active_activity[132]~="" then  --技之作战奖励双倍
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(132)
            table.insert(self._activity_list, "132")
        end
    end

    if tonumber(activity_type) == 133 and _ED.active_activity[133] ~= nil and _ED.active_activity[133]~="" then  --幻像挑战副本奖励双倍
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(133)
            table.insert(self._activity_list, "133")
        end
    end

    if tonumber(activity_type) == 134 and _ED.active_activity[134] ~= nil and _ED.active_activity[134]~="" then  --数码试炼金币奖励双倍
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(134)
            table.insert(self._activity_list, "134")
        end
    end

    if tonumber(activity_type) == 135 and _ED.active_activity[135] ~= nil and _ED.active_activity[135]~="" then  --净化必出数码兽
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmLimited(135)
            table.insert(self._activity_list, "135")
        end
    end

    if tonumber(activity_type) == 138 and _ED.active_activity[138] ~= nil and _ED.active_activity[138]~="" and not funOpenDrawTip(126, false) then  -- 抽合金有礼
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(138)
            table.insert(self._activity_list, "138")
        end
    end

    if tonumber(activity_type) == 140 and _ED.active_activity[140] ~= nil and _ED.active_activity[140]~="" then  -- 净化挑战有礼
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(140)
            table.insert(self._activity_list, "140")
        end
    end

    if tonumber(activity_type) == 141 and _ED.active_activity[141] ~= nil and _ED.active_activity[141]~="" then  -- 探索有礼
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
        else
            self:activitySmDianjin(141)
            table.insert(self._activity_list, "141")
        end
    end

    if tonumber(activity_type) == 142 and _ED.active_activity[142] ~= nil and _ED.active_activity[142]~="" then  -- 成长之路
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
        else
            if __lua_project_id == __lua_project_l_digital then
            else
                self:activityPathGrowth(142)
                table.insert(self._activity_list, "142")
            end
        end
    end

    if tonumber(activity_type) == 150 and _ED.active_activity[150] ~= nil and _ED.active_activity[150]~="" then  -- 每日充值
        self:activityDailyRecharge(150)
        table.insert(self._activity_list, "150")
    end

    -- if tonumber(activity_type) == 152 and _ED.active_activity[152] ~= nil and _ED.active_activity[152]~="" then  -- 单笔充值
    --     self:activityDailyOnceRecharge(152)
    --     table.insert(self._activity_list, "152")
    -- end

    if tonumber(activity_type) == 151 and _ED.active_activity[151] ~= nil and _ED.active_activity[151]~="" then  -- 每日单笔充值
        self:ActivityOnceRechargeNew(151)
        table.insert(self._activity_list, "151")
    end

    if tonumber(activity_type) == 156 and _ED.active_activity[156] ~= nil and _ED.active_activity[156]~="" then  -- 联系我们
        if __lua_project_id == __lua_project_l_naruto then
            -- 火影的联系我们移至youtube
        else
            self:activityContactus()
            table.insert(self._activity_list, "156")
        end
    end

    for k,v in pairs(self.pageKeys) do
        if v ~= nil and tonumber(v.activity_type) == tonumber(activity_type) and v.page:getParent() == nil then
            self.Panel_page_act:addChild(v.page)
        end
    end

    self.listView:requestRefreshView()
end

function ActivityWindow:removeActivityPage(pageItem, key)
	local root = self.roots[1]
	if root ~= nil and pageItem ~= nil then
		if pageItem.cellItem ~= nil then
			local iIdx = self.listView:getIndex(pageItem.cellItem)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                self.listView:removeItem(iIdx)
			else
				if iIdx > 0 then
					if isUseNewActivityMode == true then
						-- table.remove(self.pageKeys,iIdx+1)
					else
						self.listView:removeItem(iIdx)
					end
				end
			end
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			pageItem:removeFromParent(true)
			for k,v in pairs(self.pageKeys) do
				if v ~= nil and v.key == key then
					table.remove(self.pageKeys, k)
					break
				end
			end
			for i, v in pairs(self.listView:getItems()) do
				if v~= nil then
					state_machine.excute("activity_window_control_change", 0, v)
					break
				end
			end
		else
			self.PageViewAty:removePage(pageItem)
		end
	end
end

function ActivityWindow:clearAllPages()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
	    local root = self.roots[1]
		for i, v in pairs(self.pageKeys) do
			if v ~= nil and v.page ~= nil then
				if v.page.unload ~= nil then
					v.page:unload()
				end
                if v.page then
				    v.page:setVisible(false)
                end
			end
		end
	end
end

function ActivityWindow:changeToPage(name)
	self:clearAllPages()
    local root = self.roots[1]
	for i, v in pairs(self.pageKeys) do
		if v ~= nil then
			if v.key == name then	--注意：字符串做对比，不同平台对大小写要求不同。
				if isUseNewActivityMode == true then
					if v.page.loaded == false then
						v.page:lazy()
						v.page:setVisible(true)
						if v.page.onUpdateDrawData ~= nil then
							v.page:onUpdateDrawData()
						end
					else
						v.page:setVisible(true)
						if v.page.onUpdateDrawData ~= nil then
							v.page:onUpdateDrawData()
						end
					end
					
					local iIdx = self.listView:getIndex(v.page.cellItem)
					state_machine.excute("activity_copy_title_cell", 0, {self.listView:getItems()[iIdx], iIdx, self.listView})
				else
					local pageIndex = tonumber(i) - 1
					local currentPageIndex = self.PageViewAty:getCurPageIndex()
					if currentPageIndex ~= pageIndex then
						self.PageViewAty:scrollToPage(pageIndex)
						if __lua_project_id == __lua_project_digimon_adventure 
							or __lua_project_id == __lua_project_naruto 
							or __lua_project_id == __lua_project_warship_girl_b 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge
							then 
							--从外部进入到活动界面防止自身调用pageViewEvent 
							self.lastIndex = pageIndex + 1
							local items = self.listView:getItems()
							local activityIconCell = items[self.lastIndex]
	            			state_machine.excute("activity_copy_title_cell", 0, {activityIconCell,currentPageIndex,self.listView})
						end
						
						state_machine.excute("activity_window_lazy", 0, self.PageViewAty:getPage(self.PageViewAty:getCurPageIndex()))
					end
				end
			else
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					then
					if v.page.unload ~= nil then
						v.page:unload()
					end
				end
				if isUseNewActivityMode == true then
					v.page:setVisible(false)
				end		
			end
		end
	end

	if isUseNewActivityMode == true then
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			then 
			self:sortListItem(name)
		else
			self:sortListItem()
		end
	end
end
function ActivityWindow:activityReplyPhysicalPage(tabCtrl) --点击listview的每一项进行页面切换。
	local root = self.roots[1]
	self:clearAllPages()
	local tabItems = self.listView:getItems()
	for i, v in pairs(tabItems) do
		if v == tabCtrl then
			if isUseNewActivityMode == true then
				for j,k in pairs(self.pageKeys) do
					if k ~= nil then
						if k.key == v.pagekey then
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
								
                                local havePush = false
                                local activity_type = 0
                                if k.activity_type ~= nil then
                                    activity_type = tonumber(k.activity_type)
                                end
                                if activity_type == 121 then
                                    activity_type = 1211
                                end
                                if activity_type > 0 then
                                    --print("=========activity_type==========="..activity_type)
                                    local readTime = cc.UserDefault:getInstance():getStringForKey(getKey("activity_push_"..activity_type))
                                    local nowTimeStr = os.date("%Y".."-".."%m".."-".."%d".."-".."%H", getBaseGTM8Time(_ED.system_time + (os.time() - _ED.native_time)))
                                    local nowTimes = zstring.split(nowTimeStr , "-")
    								if readTime == nil or readTime == "" then
    									writeKey( "activity_push_"..activity_type , nowTimeStr)
    									havePush = true
    								else
    									local readTimes = zstring.split(readTime, "-")
                                        if #readTimes <= 1 then
                                            readTimes = zstring.split(os.date("%Y".."-".."%m".."-".."%d".."-".."%H", readTimes[1]), "-")
                                        end
                                        readTimes[4] = readTimes[4] or 0
                                        local lastTime = os.time({year=tonumber(readTimes[1]), month=tonumber(readTimes[2]), day=tonumber(readTimes[3]), hour=tonumber(readTimes[4]), min=0, sec=0})
                                        local nowTime = os.time({year=tonumber(nowTimes[1]), month=tonumber(nowTimes[2]), day=tonumber(nowTimes[3]), hour=tonumber(nowTimes[4]), min=0, sec=0})
                                        if nowTime - lastTime >= 24*3600 then
                                            writeKey( "activity_push_"..activity_type, nowTimeStr)
                                            havePush = true
                                        else
                                            if (tonumber(readTimes[3]) ~= tonumber(nowTimes[3]) and tonumber(nowTimes[4]) >= 5)
                                                or (tonumber(readTimes[3]) == tonumber(nowTimes[3]) 
                                                    and zstring.tonumber(readTimes[4]) < 5
                                                    and tonumber(nowTimes[4]) >= 5)
                                                then
                                                writeKey( "activity_push_"..activity_type, nowTimeStr)
                                                havePush = true
                                            end
                                        end
    									-- if tonumber(readTimes[1]) < tonumber(nowTimes[1]) or tonumber(readTimes[2]) < tonumber(nowTimes[2])
    									-- 	or tonumber(readTimes[3]) < tonumber(nowTimes[3]) then
    									-- 	writeKey( "activity_push_"..activity_type , nowTime)
             --                                havePush = true
    									-- end
    								end
    								if havePush == true then
    									state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, activity_type)
    								end
                                end
							end
							if k.page.loaded == false then	
								k.page:lazy()
								k.page:setVisible(true)
								if k.page.onUpdateDrawData ~= nil then
									k.page:onUpdateDrawData()
								end
							else
								k.page:setVisible(true)
								if k.page.onUpdateDrawData ~= nil then
									k.page:onUpdateDrawData()
								end
							end	
						else
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
								then
								if k.page.unload ~= nil then
									k.page:unload()
								end
							end
							k.page:setVisible(false)
						end
					end
				end

				state_machine.excute("activity_copy_title_cell", 0, {tabItems[i],i,self.listView})
				-- state_machine.excute("activity_window_refresh_button",0,"")			
			else
				if self.PageViewAty:getCurPageIndex() ~= (i - 1) then--同页面的不用切换
					self.PageViewAty:scrollToPage(i - 1)
				end
			end
		end
	end
end

function ActivityWindow:asyncChangePage_null(texture)

end

function ActivityWindow:reloadAsyncPage()
	-- local root = self.roots[1]
	-- local pageView = ccui.Helper:seekWidgetByName(root, "PageView_wdf_1")
	-- local listView = ccui.Helper:seekWidgetByName(root, "ListView_wonder_btn")

	-- local pages = pageView:getPages()
	-- local pageCount = #pages

	-- local getCurPageIndex = pageView:getCurPageIndex()

	-- state_machine.excute("activity_window_unload", 0, pageView:getPage(getCurPageIndex))
	-- state_machine.excute("activity_window_lazy", 0, pageView:getPage(getCurPageIndex))

	-- if getCurPageIndex > 0 then
	-- 	state_machine.excute("activity_window_unload", 0, pageView:getPage(getCurPageIndex - 1))
	-- 	state_machine.excute("activity_window_lazy", 0, pageView:getPage(getCurPageIndex - 1))
	-- end

	-- if getCurPageIndex + 1 < pageCount then
	-- 	state_machine.excute("activity_window_unload", 0, pageView:getPage(getCurPageIndex + 1))
	-- 	state_machine.excute("activity_window_lazy", 0, pageView:getPage(getCurPageIndex + 1))
	-- end
end

function ActivityWindow:asyncChangePage(texture)
	if isUseNewActivityMode == true then
		return
	end

	-- local currentPageIndex = pageView:getCurPageIndex() + 1
	-- self.currentIndex = currentPageIndex
	-- local items = listView:getItems()
	-- local dailyActivityCopyTitleCell = items[currentPageIndex]
 --    state_machine.excute("activity_copy_title_cell", 0, {dailyActivityCopyTitleCell,currentPageIndex,listView})
	
	
	-- local cell = pageView:getPage(pageView:getCurPageIndex())

	-- state_machine.excute("shortcut_function_goto_log" ,0, cell.pageName)


	-- cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
	
	local pages = self.PageViewAty:getPages()
	local pageCount = #pages

	local getCurPageIndex = self.PageViewAty:getCurPageIndex()
	state_machine.excute("activity_window_lazy", 0, self.PageViewAty:getPage(getCurPageIndex))
	-- if getCurPageIndex - 2 >= 0 then
	-- 	state_machine.excute("activity_window_unload", 0, pageView:getPage(getCurPageIndex - 2))
	-- end
	local movePageIndex = getCurPageIndex - 1
	while movePageIndex > 0 do
		if movePageIndex - 1 >= 0 then
			if self.unload == true then
				state_machine.excute("activity_window_unload", 0, self.PageViewAty:getPage(movePageIndex - 1))
			end
		end
		movePageIndex = movePageIndex - 1
	end
	if getCurPageIndex - 1 >= 0 then
		state_machine.excute("activity_window_lazy", 0, self.PageViewAty:getPage(getCurPageIndex - 1))
	end

	if getCurPageIndex + 1 < pageCount then
		state_machine.excute("activity_window_lazy", 0, self.PageViewAty:getPage(getCurPageIndex + 1))
	end
	-- if getCurPageIndex + 2 < pageCount then
	-- 	state_machine.excute("activity_window_unload", 0, pageView:getPage(getCurPageIndex + 2))
	-- end
	movePageIndex = getCurPageIndex + 1
	while movePageIndex < pageCount do
		if movePageIndex + 1 < pageCount then
			if self.unload == true then
				state_machine.excute("activity_window_unload", 0, self.PageViewAty:getPage(movePageIndex + 1))
			end
		end
		movePageIndex = movePageIndex + 1
	end
	if self.unload == true then
		cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	end
	self.unload = false
end


function ActivityWindow:initActivityWindowPageView() --滑动pageView
	if isUseNewActivityMode == true then
		return
	end
	
	local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local currentPageIndex = self.PageViewAty:getCurPageIndex() + 1
            if self.lastIndex == currentPageIndex then
            	return
            end
            if math.abs(self.lastIndex - currentPageIndex) > 1 then
            	self.unload = true
            end
            self.lastIndex = currentPageIndex
			self.currentIndex = currentPageIndex
			local items = self.listView:getItems()
			local dailyActivityCopyTitleCell = items[currentPageIndex]
            state_machine.excute("activity_copy_title_cell", 0, {dailyActivityCopyTitleCell,currentPageIndex,self.listView})
			
			
			local cell = self.PageViewAty:getPage(self.PageViewAty:getCurPageIndex())
	
			state_machine.excute("shortcut_function_goto_log" ,0, cell.pageName)


			-- cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
			
			-- local pages = pageView:getPages()
			-- local pageCount = #pages

			-- getCurPageIndex = pageView:getCurPageIndex()
			-- state_machine.excute("activity_window_lazy", 0, pageView:getPage(getCurPageIndex))
			-- -- if getCurPageIndex - 2 >= 0 then
			-- -- 	state_machine.excute("activity_window_unload", 0, pageView:getPage(getCurPageIndex - 2))
			-- -- end
			-- local movePageIndex = getCurPageIndex - 1
			-- while movePageIndex > 0 do
			-- 	if movePageIndex - 1 >= 0 then
			-- 		state_machine.excute("activity_window_unload", 0, pageView:getPage(movePageIndex - 1))
			-- 	end
			-- 	movePageIndex = movePageIndex - 1
			-- end
			-- if getCurPageIndex - 1 >= 0 then
			-- 	state_machine.excute("activity_window_lazy", 0, pageView:getPage(getCurPageIndex - 1))
			-- end

			-- if getCurPageIndex + 1 < pageCount then
			-- 	state_machine.excute("activity_window_lazy", 0, pageView:getPage(getCurPageIndex + 1))
			-- end
			-- -- if getCurPageIndex + 2 < pageCount then
			-- -- 	state_machine.excute("activity_window_unload", 0, pageView:getPage(getCurPageIndex + 2))
			-- -- end
			-- movePageIndex = getCurPageIndex + 1
			-- while movePageIndex < pageCount do
			-- 	if movePageIndex + 1 < pageCount then
			-- 		state_machine.excute("activity_window_unload", 0, pageView:getPage(movePageIndex + 1))
			-- 	end
			-- 	movePageIndex = movePageIndex + 1
			-- end
			-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()


			cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
			cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.asyncChangePage_null, self, false)
    		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.asyncChangePage_null, self, false)
    		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.asyncChangePage, self, false)
        end
    end 
	self.PageViewAty:addEventListener(pageViewEvent)
end
function ActivityWindow:activityReplyPhysical() --回体力
	local root = self.roots[1]
	app.load("client.activity.ActivityAddEnergy")

	local addEnergy = ActivityAddEnergy:createCell()
	addEnergy:init()
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(addEnergy)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_REPLY_PHYSICAL_ICON)
	self.listView:addChild(activityIcon)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else	
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_eat_manual",
    	_widget = activityIcon,
    	_invoke = nil,
    	_interval = 0.5,})
    end
    addEnergy.cellItem = activityIcon
	activityIcon.pagekey = "addEnergy"
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        activityIcon.priority = 3
        activityIcon.activityType = 1001
        local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
        if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
            activityIcon.activitySequence = activity_sequence[1][3]
        end
    else
    	activityIcon.priority = 1011
    end
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()
	end
	table.insert(self.pageKeys, {key="addEnergy", page=addEnergy, activity_type = "1001"})
end

function ActivityWindow:activityPathGrowth(activityType)
    local root = self.roots[1]
    app.load("client.l_digital.activity.wonderful.PathGrowth")
    
    local PathGrowth = PathGrowth:createCell(activityType)
    PathGrowth:init(activityType)
    PathGrowth.pageName = "PathGrowth"
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(PathGrowth)
    end
    
    local activityIcon = ActivityIconCell:createCell()
    local enum_type = ""
    if tonumber(activityType) == 142 then -- 成长之路
        -- activityIcon._istips = true
        activityIcon.priority = 2  -- 放第一个
        activityIcon.activityType = 142
        local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
        if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
            activityIcon.activitySequence = activity_sequence[1][3]
        end
        enum_type = activityIcon.enum_type.ACTIVITY_PATH_GROWTH
    end
    activityIcon:init(enum_type)
    self.listView:addChild(activityIcon)

    PathGrowth.cellItem = activityIcon
    activityIcon.pagekey = "PathGrowth"..activityType
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end     
    table.insert(self.pageKeys, {key="PathGrowth"..activityType, page=PathGrowth, activity_type = activityType})

    
end

function ActivityWindow:activityDailyRecharge(activityType)
    local root = self.roots[1]
    app.load("client.l_digital.activity.wonderful.ActivityDailyRecharge")
    
    local ActivityDailyRecharge = ActivityDailyRecharge:createCell(activityType)
    ActivityDailyRecharge.pageName = "ActivityDailyRecharge"
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(ActivityDailyRecharge)
    end

    local activityIcon = ActivityIconCell:createCell()
    local enum_type = ""
    if tonumber(activityType) == 150 then 
        activityIcon.priority = 150
        activityIcon.activityType = 150
        local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
        if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
            activityIcon.activitySequence = activity_sequence[1][3]
        end
        enum_type = activityIcon.enum_type.ACTIVITY_DAILY_RECHARGE
    end
    activityIcon:init(enum_type)
    self.listView:addChild(activityIcon)

    ActivityDailyRecharge.cellItem = activityIcon
    activityIcon.pagekey = "ActivityDailyRecharge"..activityType
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end     
    table.insert(self.pageKeys, {key="ActivityDailyRecharge"..activityType, page=ActivityDailyRecharge, activity_type = activityType})
end

-- 每日单笔充值(入口移至主界面大厅)
function ActivityWindow:activityDailyOnceRecharge(activityType)
    local root = self.roots[1]
    app.load("client.l_digital.activity.wonderful.ActivityDailyOnceRecharge")
  
    local ActivityDailyOnceRecharge = ActivityDailyOnceRecharge:createCell()
    ActivityDailyOnceRecharge:init(activityType)
    ActivityDailyOnceRecharge.pageName = "ActivityDailyOnceRecharge"
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(ActivityDailyOnceRecharge)
    end

    local activityIcon = ActivityIconCell:createCell()
    local enum_type = ""
    if tonumber(activityType) == 152 then 
        activityIcon.priority = 152
        activityIcon.activityType = 152
        local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
        if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
            activityIcon.activitySequence = activity_sequence[1][3]
        end
        enum_type = activityIcon.enum_type.ACTIVITY_DAILY_ONCE_RECHARGE
    end
    activityIcon:init(enum_type)
    self.listView:addChild(activityIcon)

    ActivityDailyOnceRecharge.cellItem = activityIcon
    activityIcon.pagekey = "ActivityDailyOnceRecharge"..activityType
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end     
    table.insert(self.pageKeys, {key="ActivityDailyOnceRecharge"..activityType, page=ActivityDailyOnceRecharge, activity_type = activityType})
end

-- 单笔充值
function ActivityWindow:ActivityOnceRechargeNew(activityType)
    local root = self.roots[1]
    app.load("client.l_digital.activity.wonderful.ActivityOnceRecharge")
    
    -- 151: la clase de client/l_digital/activity/wonderful/ActivityOnceRecharge.lua,
    -- no la del 45, que comparte nombre global.
    local ActivityOnceRecharge = ActivityOnceRechargeDaily:createCell()
    ActivityOnceRecharge:init(activityType)
    ActivityOnceRecharge.pageName = "ActivityOnceRecharge"
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(ActivityOnceRecharge)
    end

    local activityIcon = ActivityIconCell:createCell()
    local enum_type = ""
    if tonumber(activityType) == 151 then
        activityIcon.priority = 151
        activityIcon.activityType = 151
        local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
        if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
            activityIcon.activitySequence = activity_sequence[1][3]
        end
        enum_type = activityIcon.enum_type.ACTIVITY_ONCE_RECHARGE
    end
    activityIcon:init(enum_type)
    self.listView:addChild(activityIcon)

    ActivityOnceRecharge.cellItem = activityIcon
    activityIcon.pagekey = "ActivityOnceRecharge"..activityType
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end     
    table.insert(self.pageKeys, {key="ActivityOnceRecharge"..activityType, page=ActivityOnceRecharge, activity_type = activityType})
end

function ActivityWindow:activityLoginReward()       --登录送礼
    local root = self.roots[1]
    app.load("client.l_digital.activity.wonderful.SmActivityLangingReword")
    
    local activityLangingReword = SmActivityLangingReword:createCell()
    -- activityLangingReword:init()
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(activityLangingReword)
    end
    
    local activityIcon = ActivityIconCell:createCell()
    activityIcon:init(activityIcon.enum_type.ACTIVITY_LANDING_REWORD)
    self.listView:addChild(activityIcon)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_activity_login_reward",
        _widget = activityIcon,
        _invoke = nil,
        _interval = 0.5,})
    end

    activityLangingReword.cellItem = activityIcon
    activityIcon.pagekey = "SmActivityLangingReword"
    activityIcon.priority = 10
    activityIcon.activityType = 24
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end 
    table.insert(self.pageKeys, {key="SmActivityLangingReword", page=activityLangingReword, activity_type = "24"})
end

function ActivityWindow:activitySmCheckInfo()       --每日签到
    local root = self.roots[1]
    app.load("client.l_digital.activity.wonderful.SmCheckInInfoWindow")
    
    local smCheckInInfoWindow = SmCheckInInfoWindow:createCell()
    -- smCheckInInfoWindow:init()
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(smCheckInInfoWindow)
    end
    
    local activityIcon = ActivityIconCell:createCell()
    activityIcon:init(activityIcon.enum_type.ACTIVITY_SM_CHECK_INFO)
    self.listView:addChild(activityIcon)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_every_day_sign_all",
        _widget = activityIcon,
        _invoke = nil,
        _interval = 0.5,})
    end

    smCheckInInfoWindow.cellItem = activityIcon
    activityIcon.pagekey = "SmCheckInInfoWindow"
    activityIcon.priority = 8000
    activityIcon.activityType = 38
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end 
    table.insert(self.pageKeys, {key="SmCheckInInfoWindow", page=smCheckInInfoWindow, activity_type = "38"})
end

function ActivityWindow:activitySmDayDiscount()       --每日折扣
    local root = self.roots[1]
    app.load("client.l_digital.activity.wonderful.SmDayDiscountWindow")
    
    local smDayDiscountWindow = SmDayDiscountWindow:createCell()
    -- smCheckInInfoWindow:init()
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(smDayDiscountWindow)
    end
    
    local activityIcon = ActivityIconCell:createCell()
    activityIcon:init(activityIcon.enum_type.ACTIVITY_SM_DAY_DISCOUNT)
    self.listView:addChild(activityIcon)

    smDayDiscountWindow.cellItem = activityIcon
    activityIcon.pagekey = "SmDayDiscountWindow"
    activityIcon.priority = 8
    activityIcon.activityType = 93
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end 
    table.insert(self.pageKeys, {key="SmDayDiscountWindow", page=smDayDiscountWindow, activity_type = "93"})
end

function ActivityWindow:activityWelcomeMammon()--迎财神
	local root = self.roots[1]
	app.load("client.activity.ActivityWelcomeMammon")
	
	local WelcomeMammon = ActivityWelcomeMammon:createCell()
	WelcomeMammon:init()
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(WelcomeMammon)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_WELCOME_MAMMON_ICON)
	self.listView:addChild(activityIcon)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_god_of_wealth",
	_widget = activityIcon,
	_invoke = nil,
	_interval = 0.5,})

	WelcomeMammon.cellItem = activityIcon
	activityIcon.pagekey = "WelcomeMammon"
	activityIcon.priority = 2400
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()
	end	
	table.insert(self.pageKeys, {key="WelcomeMammon", page=WelcomeMammon})
end

function ActivityWindow:activityFirstRechargeable()--首冲礼包
	local root = self.roots[1]
	app.load("client.activity.ActivityFirstRecharge")
	
	local FirstRecharge = ActivityFirstRecharge:createCell()
	FirstRecharge:init()
	FirstRecharge.pageName = "FirstRecharge"
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(FirstRecharge)
	end

	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_FIRST_RECHARGE_ICON)
	self.listView:addChild(activityIcon)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_recharge",
	_widget = activityIcon,
	_invoke = nil,
	_interval = 0.5,})

	FirstRecharge.cellItem = activityIcon
	activityIcon.pagekey = "FirstRecharge"
	activityIcon.priority = 2100
    activityIcon.activityType = 4
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()
	end	
	table.insert(self.pageKeys, {key="FirstRecharge", page=FirstRecharge})
end

function ActivityWindow:activityGiftCodes()--兑换码
	local root = self.roots[1]
	app.load("client.activity.ActivityGiftCodes")
	
	local ActivityGiftCodes = ActivityGiftCodes:createCell()
	ActivityGiftCodes:init()
	ActivityGiftCodes.pageName = "ActivityGiftCodes" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityGiftCodes)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_GIFT_CODES_ICON)
	self.listView:addChild(activityIcon)
	
	ActivityGiftCodes.cellItem = activityIcon
	activityIcon.pagekey = "ActivityGiftCodes"
	activityIcon.priority = 2800
	activityIcon.push_state = 0	
	table.insert(self.pageKeys, {key="ActivityGiftCodes", page=ActivityGiftCodes})
end

function ActivityWindow:activityHeroDiscount()--神将折扣
	local root = self.roots[1]
	app.load("client.activity.ActivityDoubleDiscount")
	
	local ActivityHeroDiscount = ActivityDoubleDiscount:createCell()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
		then
		ActivityHeroDiscount:init(90)
	else
		ActivityHeroDiscount:init(46)
	end
	ActivityHeroDiscount.pageName = "ActivityHeroDiscount" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityHeroDiscount)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_HERO_DISCOUNT_ICON)
	self.listView:addChild(activityIcon)
	
	ActivityHeroDiscount.cellItem = activityIcon
	activityIcon.pagekey = "ActivityHeroDiscount"
	activityIcon.priority = 1100
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        activityIcon.priority = 20
    end
    activityIcon.activityType = 90
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	activityIcon.push_state = 0	
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end 
	table.insert(self.pageKeys, {key="ActivityHeroDiscount", page=ActivityHeroDiscount, activity_type = "90"})
end

function ActivityWindow:activityDuplicateDouble()--副本双倍
	local root = self.roots[1]
	app.load("client.activity.ActivityDoubleDiscount")
	
	local ActivityDuplicateDouble = ActivityDoubleDiscount:createCell()
	ActivityDuplicateDouble:init(44)
	ActivityDuplicateDouble.pageName = "ActivityDuplicateDouble"
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityDuplicateDouble)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_DUPLICATE_DOUBLE_ICON)
	self.listView:addChild(activityIcon)
	
	ActivityDuplicateDouble.cellItem = activityIcon
	activityIcon.pagekey = "ActivityDuplicateDouble"
	activityIcon.priority = 1005
    activityIcon.activityType = 44
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	activityIcon.push_state = 0	
	table.insert(self.pageKeys, {key="ActivityDuplicateDouble", page=ActivityDuplicateDouble, activity_type = "44"})
end

function ActivityWindow:activityArenaDouble()--演习
	local root = self.roots[1]
	app.load("client.activity.ActivityDoubleDiscount")
	
	local ActivityArenaDouble = ActivityDoubleDiscount:createCell()
	ActivityArenaDouble:init(43)
	ActivityArenaDouble.pageName = "ActivityArenaDouble" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityArenaDouble)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_ARENA_DOUBLE_ICON)
	self.listView:addChild(activityIcon)
	
	ActivityArenaDouble.cellItem = activityIcon
	activityIcon.pagekey = "ActivityArenaDouble"
	activityIcon.priority = 1006
    activityIcon.activityType = 43
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	activityIcon.push_state = 0	
	table.insert(self.pageKeys, {key="ActivityArenaDouble", page=ActivityArenaDouble, activity_type = "43"})
end

function ActivityWindow:activityOneDayRecharge(m_type)--21（单日充值活动）
	local root = self.roots[1]
	local ActivityOneDayRecharge = nil
    m_type = m_type or 77
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.activity.wonderful.SmActivityRechargeEverydayGift")
		ActivityOneDayRecharge = SmActivityRechargeEverydayGift:createCell() 
		ActivityOneDayRecharge:init(m_type)
	else
		app.load("client.activity.ActivityOneDayRecharge")
		ActivityOneDayRecharge = ActivityOneDayRecharge:createCell()
		ActivityOneDayRecharge:init()
	end
	
	ActivityOneDayRecharge.pageName = "ActivityOneDayRecharge" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityOneDayRecharge)
	end
	local activityIcon = ActivityIconCell:createCell()
    local enum_type = 0
    if m_type == 91 then
        enum_type = activityIcon.enum_type.ACTIVITY_ONE_DAY_RECHARGE_ICON_1
    elseif m_type == 117 then
        enum_type = activityIcon.enum_type.ACTIVITY_ONE_DAY_RECHARGE_ICON_1_EX
    elseif m_type == 118 then
        enum_type = activityIcon.enum_type.ACTIVITY_ONE_DAY_RECHARGE_ICON_1_EXX
    elseif m_type == 139 then
        enum_type = activityIcon.enum_type.ACTIVITY_ONE_DAY_RECHARGE_ICON_2
    else
        enum_type = activityIcon.enum_type.ACTIVITY_ONE_DAY_RECHARGE_ICON
    end
	activityIcon:init(enum_type)
	self.listView:addChild(activityIcon)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_one_day_recharge",
    	_widget = activityIcon,
    	_invoke = nil,
    	_interval = 0.5,})
    end

	ActivityOneDayRecharge.cellItem = activityIcon
	activityIcon.pagekey = "ActivityOneDayRecharge"..m_type
	activityIcon.priority = 1007
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        if m_type == 91 or m_type == 77 or m_type == 117 or m_type == 118 or m_type == 139 then
            activityIcon.priority = 18
        else
            
        end
        if m_type == 77 then
            activityIcon.activityType = 77
        elseif m_type == 91 then
            activityIcon.activityType = 91
        elseif m_type == 117 then
            activityIcon.activityType = 117
        elseif m_type == 118 then
            activityIcon.activityType = 118
        elseif m_type == 139 then
            activityIcon.activityType = 139
        end
        local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
        if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
            activityIcon.activitySequence = activity_sequence[1][3]
        end
    end
	activityIcon.push_state = 0	
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end     
	table.insert(self.pageKeys, {key="ActivityOneDayRecharge"..m_type, page=ActivityOneDayRecharge, activity_type = ""..m_type})
end

function ActivityWindow:activityOnceRecharge()--45（单笔充值活动）
	local root = self.roots[1]
	app.load("client.activity.ActivityOnceRecharge")
	
	-- 45: SU pagina es la de client/activity/ActivityOnceRecharge.lua (landed_gifts.csb +
	-- accumlate_rechargeable_cell), que lee available_count/completed_count/need_day/estado
	-- de CADA ENTRADA. La variante l_digital/wonderful es la del 151 y lee activity_params,
	-- que al 45 no le llega nunca: pisaba este global cuando se cargaba antes.
	local ActivityOnceRecharge = ActivityOnceRecharge45:createCell()
	ActivityOnceRecharge:init(45)
	ActivityOnceRecharge.pageName = "ActivityOnceRecharge" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityOnceRecharge)
	end
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_ONCE_RECHARGE_ICON)
	self.listView:addChild(activityIcon)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_once_recharge",
	_widget = activityIcon,
	_invoke = nil,
	_interval = 0.5,})

	ActivityOnceRecharge.cellItem = activityIcon
	activityIcon.pagekey = "ActivityOnceRecharge"
	activityIcon.priority = 1008
    activityIcon.activityType = 45
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	activityIcon.push_state = 0	
	table.insert(self.pageKeys, {key="ActivityOnceRecharge", page=ActivityOnceRecharge, activity_type = "45"})
end

function ActivityWindow:activityRebelArmy()--47（叛军活动）
	local root = self.roots[1]
	app.load("client.activity.ActivityRebelArmy")
	
	local ActivityRebelArmy = ActivityRebelArmy:createCell()
	ActivityRebelArmy:init()
	ActivityRebelArmy.pageName = "ActivityRebelArmy" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityRebelArmy)
	end
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_REBEL_ARMY_ICON)
	self.listView:addChild(activityIcon)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_rebel_army_recharge",
	_widget = activityIcon,
	_invoke = nil,
	_interval = 0.5,})

	ActivityRebelArmy.cellItem = activityIcon
	activityIcon.pagekey = "ActivityRebelArmy"
	activityIcon.priority = 1004
    activityIcon.activityType = 47
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()
	end		
	table.insert(self.pageKeys, {key="ActivityRebelArmy", page=ActivityRebelArmy, activity_type = "47"})
end

function ActivityWindow:activityRebelArmyKill()--66（叛军击杀活动）
	local root = self.roots[1]
	app.load("client.activity.activityRebelArmyKill")
	
	local activityRebelArmyKill = activityRebelArmyKill:createCell()
	activityRebelArmyKill:init(66)
	activityRebelArmyKill.pageName = "activityRebelArmyKill" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(activityRebelArmyKill)
	end
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_REBEL_ARMY_KILL_ICON)
	self.listView:addChild(activityIcon)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_rebel_army_kill_recharge",
	_widget = activityIcon,
	_invoke = nil,
	_interval = 0.5,})

	activityRebelArmyKill.cellItem = activityIcon
	activityIcon.pagekey = "activityRebelArmyKill"
	activityIcon.priority = 1400
    activityIcon.activityType = 66
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()
	end			
	table.insert(self.pageKeys, {key="activityRebelArmyKill", page=activityRebelArmyKill})
end

function ActivityWindow:ActivityRebelArmyAttack()--67（叛军攻打活动）
	local root = self.roots[1]
	app.load("client.activity.ActivityRebelArmyAttack")
	
	local ActivityRebelArmyAttack = ActivityRebelArmyAttack:createCell()
	ActivityRebelArmyAttack:init(67)
	ActivityRebelArmyAttack.pageName = "ActivityRebelArmy" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityRebelArmyAttack)
	end
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_REBEL_ARMY_ATTACK_ICON)
	self.listView:addChild(activityIcon)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_rebel_army_attck_recharge",
	_widget = activityIcon,
	_invoke = nil,
	_interval = 0.5,})

	ActivityRebelArmyAttack.cellItem = activityIcon
	activityIcon.pagekey = "ActivityRebelArmyAttack"
	activityIcon.priority = 1300
    activityIcon.activityType = 67
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then 
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()
	end		
	table.insert(self.pageKeys, {key="ActivityRebelArmyAttack", page=ActivityRebelArmyAttack})
end

function ActivityWindow:activityAccumlate(m_type)--累冲礼包
	local root = self.roots[1]
    local activity_type = 7
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        activity_type = m_type or 7
    end
	app.load("client.activity.ActivityAccumlateRechargeable")
	
	local AccumlateRechargeable = ActivityAccumlateRechargeable:createCell()
	AccumlateRechargeable:init(activity_type)
	AccumlateRechargeable.pageName = "AccumlateRechargeable"
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(AccumlateRechargeable)
	end
	local activityIcon = ActivityIconCell:createCell()
    local enum_type = 0
    if activity_type == 92 then
        enum_type = activityIcon.enum_type.ACTIVITY_ACCUMLATE_RECHARGEABLE_ICON_1
    else
        enum_type = activityIcon.enum_type.ACTIVITY_ACCUMLATE_RECHARGEABLE_ICON
    end
	activityIcon:init(enum_type)
	self.listView:addChild(activityIcon)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_accumlate_rechargeable",
    	_widget = activityIcon,
    	_invoke = nil,
    	_interval = 0.5,})
    end

	AccumlateRechargeable.cellItem = activityIcon
	activityIcon.pagekey = "AccumlateRechargeable"..activity_type
	activityIcon.priority = 1002
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        if activity_type == 92 or activity_type == 7 then
            activityIcon.priority = 4
        end
        if activity_type == 7 then
            activityIcon.activityType = 7
        elseif activity_type == 92 then
            activityIcon.activityType = 92
        end
        local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
        if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
            activityIcon.activitySequence = activity_sequence[1][3]
        end
    end
	if __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh then
        activityIcon.priority = 150
	end
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()
	end		
	table.insert(self.pageKeys, {key="AccumlateRechargeable"..activity_type, page=AccumlateRechargeable, activity_type = ""..activity_type})
end

function ActivityWindow:activityConsumption(activity_type)--累积消费
	local root = self.roots[1]
	app.load("client.activity.ActivityAccumlateConsumption")
	
	local AccumlateConsumption = ActivityAccumlateConsumption:createCell()
	AccumlateConsumption:init(activity_type)
	AccumlateConsumption.pageName = "AccumlateConsumption"
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(AccumlateConsumption)
	end
	
	local activityIcon = ActivityIconCell:createCell()
    activityIcon:init(activityIcon.enum_type.ACTIVITY_ACCUMLATE_CONSUMPTION_ICON)
	self.listView:addChild(activityIcon)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_accumlate_consumption",
    	_widget = activityIcon,
    	_invoke = nil,
    	_interval = 0.5,})
    end

	AccumlateConsumption.cellItem = activityIcon
	activityIcon.pagekey = "AccumlateConsumption"
	activityIcon.priority = 1012
    activityIcon.activityType = 17
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        activityIcon.priority = 15
    end
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()
	end		
	table.insert(self.pageKeys, {key="AccumlateConsumption", page=AccumlateConsumption, activity_type = "17"})
end

function ActivityWindow:activitySignIn()--签到
	local root = self.roots[1]
	app.load("client.activity.ActivityDailySignIn")
	local DailySignIn = ActivityDailySignIn:createCell()
	DailySignIn:init()
	DailySignIn.pageName = "ActivityDailySignIn" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(DailySignIn)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_SIGN_IN_ICON)
	self.listView:addChild(activityIcon)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_sign",
	_widget = activityIcon,
	_invoke = nil,
	_interval = 0.5,})	

	DailySignIn.cellItem = activityIcon
	activityIcon.pagekey = "DailySignIn"
	activityIcon.priority = 200
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()
	end	
	table.insert(self.pageKeys, {key="DailySignIn", page=DailySignIn})
	table.insert(self.roots, DailySignIn.roots[1])	
end

function ActivityWindow:activityMonthCardTwo()--月卡
	local root = self.roots[1]
    -- 月卡重塑
    if _ED.active_activity[192] ~= nil then 
        app.load("client.activity.monthly_card.MonthlyCardCell")
        local MonthCard = state_machine.excute("monthly_card_cell_create", 0 , "")

        local activityIcon = ActivityIconCell:createCell()
        activityIcon:init(activityIcon.enum_type.ACTIVITY_NEW_MONTH_Card)
        self.listView:addChild(activityIcon)
    
        MonthCard.cellItem = activityIcon
        activityIcon.pagekey = "MonthCard"
        activityIcon.priority = 5
        activityIcon.activityType = 1000
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_new_month_card",
            _widget = activityIcon,
            _invoke = nil,
            _interval = 0.5,})	
        local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
        if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
            activityIcon.activitySequence = activity_sequence[1][3]
        end
        activityIcon:updatePushState()
	
        table.insert(self.pageKeys, {key="MonthCard", page=MonthCard, activity_type = "1000"})
    else
        app.load("client.activity.ActivityMonthCard")
        local MonthCard = ActivityMonthCard:createCell()
        
        MonthCard:init()
        if isUseNewActivityMode == true then
        else
            self.PageViewAty:addPage(MonthCard)
        end
        local activityIcon = ActivityIconCell:createCell()
        activityIcon:init(activityIcon.enum_type.ACTIVITY_TWO_MONTH_CARD_ICON)
        self.listView:addChild(activityIcon)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        else
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_month_card",
            _widget = activityIcon,
            _invoke = nil,
            _interval = 0.5,})	
        end
        MonthCard.cellItem = activityIcon
        activityIcon.pagekey = "MonthCard"
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            activityIcon.priority = 5
        else
            activityIcon.priority = 1003
        end
        activityIcon.activityType = 1000
        local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
        if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
            activityIcon.activitySequence = activity_sequence[1][3]
        end

        if isUseNewActivityMode == true then
            activityIcon:updatePushState()
        end		
        table.insert(self.pageKeys, {key="MonthCard", page=MonthCard, activity_type = "1000"})
    end
end

function ActivityWindow:activityStartServeFund()--开服基金
	local root = self.roots[1]
	app.load("client.activity.open_server.OpenServerActivity")
	local OpenServer = OpenServerActivity:createCell()
	OpenServer:init()
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(OpenServer)
	end
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_START_SERVE_FUND_ICON)
	self.listView:addChild(activityIcon)

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_open_server_activity",
        	_widget = activityIcon,
        	_invoke = nil,
        	_interval = 0.5,})
    end

	OpenServer.cellItem = activityIcon
	activityIcon.pagekey = "OpenServer"
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        activityIcon.priority = 1
    else
    	activityIcon.priority = 1009
    end
    activityIcon.activityType = 27
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	if isUseNewActivityMode == true then
        activityIcon:updatePushState()
	end		
	table.insert(self.pageKeys, {key="OpenServer", page=OpenServer, activity_type = "27"})
end

function ActivityWindow:activitySevenDays()--七日活动
	local root = self.roots[1]
	app.load("client.activity.sevendays.SevenDaysActivity")
	local SevenDays = SevenDaysActivity:createCell()
	SevenDays:init()
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(SevenDays)
	end
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_SEVEN_DAY_TWO_ICON)
	self.listView:addChild(activityIcon)

	SevenDays.cellItem = activityIcon
	activityIcon.pagekey = "SevenDays"
	activityIcon.priority = 100
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="SevenDays", page=SevenDays})
end

function ActivityWindow:activityVarietyShop()--杂货铺
	local root = self.roots[1]
	app.load("client.activity.ActivityVarietyShop")
	local VarietyShop = ActivityVarietyShop:createCell()
	VarietyShop:init()
	VarietyShop.pageName = "ActivityVarietyShop"
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(VarietyShop)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_VARIETY_SHOP_ICON)
	self.listView:addChild(activityIcon)
	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_sign",
	-- _widget = activityIcon,
	-- _invoke = nil,
	-- _interval = 0.5,})	
	VarietyShop.cellItem = activityIcon
	activityIcon.pagekey = "VarietyShop"
	activityIcon.priority = 800
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="VarietyShop", page=VarietyShop})
end

-- 将活动类型28的活动 入口放在主界面
function ActivityWindow:activityHalfPriceRestrictionNew(m_type)--半价限购
	local root = self.roots[1]
	app.load("client.activity.ActivityHalfPriceRestriction")
	local HalfPriceRestriction = ActivityHalfPriceRestriction:createCell()
	HalfPriceRestriction:init(m_type)
	HalfPriceRestriction.pageName = "ActivityHalfPriceRestriction" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(HalfPriceRestriction)
	end

	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_HALF_PRICE_RESTRICTION_ICON)
	self.listView:addChild(activityIcon)

	HalfPriceRestriction.cellItem = activityIcon
	activityIcon.pagekey = "HalfPriceRestriction"
	activityIcon.priority = 1014
    activityIcon.activityType = 28
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        if m_type == 28 then
            activityIcon.priority = 13
        end
    end
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="HalfPriceRestriction", page=HalfPriceRestriction, activity_type = "28"})
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_half_price_restriction",
    	_widget = activityIcon,
    	_invoke = nil,
    	_interval = 0.5,})
    end
	if isUseNewActivityMode == true then
        activityIcon:updatePushState()
	end	
end

function ActivityWindow:activitySkinExchangeRestriction(m_type)   --皮肤兑换
    local root = self.roots[1]
    app.load("client.activity.ActivitySkinExchangeRestriction")
    local SkinExchangeRestriction = ActivitySkinExchangeRestriction:createCell()
    SkinExchangeRestriction:init(m_type)
    SkinExchangeRestriction.pageName = "ActivitySkinExchangeRestriction" 
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(SkinExchangeRestriction)
    end

    local activityIcon = ActivityIconCell:createCell()
    activityIcon:init(activityIcon.enum_type.ACTIVITY_SKIN_EXCHANGE_RESTRICTION_ICON)   -- 1
    self.listView:addChild(activityIcon)

    SkinExchangeRestriction.cellItem = activityIcon
    activityIcon.pagekey = "SkinExchangeRestriction"
    activityIcon.priority = 1136
    activityIcon.activityType = 136
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    --     if m_type == 136 then
    --         activityIcon.priority = 23               -- 13
    --     end
    -- end
    activityIcon.push_state = 0
    table.insert(self.pageKeys, {key="SkinExchangeRestriction", page=SkinExchangeRestriction, activity_type = "136"})
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_skin_exchange_restriction",
        _widget = activityIcon,
        _invoke = nil,
        _interval = 0.5,})
    end
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end
end

function ActivityWindow:activityHalfPriceRestriction()--半价限购
	local root = self.roots[1]
	app.load("client.activity.ActivityHalfPriceRestriction")
	local HalfPriceRestriction = ActivityHalfPriceRestriction:createCell()
	HalfPriceRestriction:init()
	HalfPriceRestriction.pageName = "ActivityHalfPriceRestriction" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(HalfPriceRestriction)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_HALF_PRICE_RESTRICTION_ICON)
	self.listView:addChild(activityIcon)
	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_sign",
	-- _widget = activityIcon,
	-- _invoke = nil,
	-- _interval = 0.5,})	
	HalfPriceRestriction.cellItem = activityIcon
	activityIcon.pagekey = "HalfPriceRestriction"
	activityIcon.priority = 900
    activityIcon.activityType = 62
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="HalfPriceRestriction", page=HalfPriceRestriction, activity_type = "62"})
end

function ActivityWindow:activityVipPackage()--vip礼包
	local root = self.roots[1]
	app.load("client.activity.ActivityVipPackage")
	local VipPackage = ActivityVipPackage:createCell()
	VipPackage:init()
	VipPackage.pageName = "ActivityVipPackage" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(VipPackage)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_VIP_PACKAGE_ICON)
	self.listView:addChild(activityIcon)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_vip_package",
	_widget = activityIcon,
	_invoke = nil,
	_interval = 0.5,})	

	VipPackage.cellItem = activityIcon
	activityIcon.pagekey = "VipPackage"
	activityIcon.priority = 2300
    activityIcon.activityType = 40
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()	
	end		
	table.insert(self.pageKeys, {key="VipPackage", page=VipPackage})
end

function ActivityWindow:activityNextDay()--次日领取
	local root = self.roots[1]
	app.load("client.activity.ActivityNextDay")
	
	local ActivityNextDay = ActivityNextDay:createCell()
	ActivityNextDay:init()
	ActivityNextDay.pageName = "ActivityNextDay" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityNextDay)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_NEXT_DAY_ICON)
	self.listView:addChild(activityIcon)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_activity_next_day",
	_widget = activityIcon,
	_invoke = nil,
	_interval = 0.5,})

	ActivityNextDay.cellItem = activityIcon
	activityIcon.pagekey = "ActivityNextDay"
	activityIcon.priority = 1001
    activityIcon.activityType = 48
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()
	end		
	table.insert(self.pageKeys, {key="ActivityNextDay", page=ActivityNextDay, activity_type = "48"})
end

function ActivityWindow:activityFightingRank()  -- 战力排行
	local root = self.roots[1]
	app.load("client.activity.ActivityFightingRank")
	local ActivityFightingRank = ActivityFightingRank:createCell()
	ActivityFightingRank:init()
	ActivityFightingRank.pageName = "ActivityFightingRank" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityFightingRank)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_FIGHTING_RANK)
	self.listView:addChild(activityIcon)

	ActivityFightingRank.cellItem = activityIcon
	activityIcon.pagekey = "ActivityFightingRank"
	activityIcon.priority = 1013
    activityIcon.activityType = 49
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="ActivityFightingRank", page=ActivityFightingRank, activity_type = "49"})
end

function ActivityWindow:ActivityLoginGiftGiving()--24（登陆送礼）
	local root = self.roots[1]
	app.load("client.activity.ActivityLoginGiftGiving")
	
	local ActivityLoginGiftGiving = ActivityLoginGiftGiving:createCell()
	ActivityLoginGiftGiving:init()
	ActivityLoginGiftGiving.pageName = "ActivityLoginGiftGiving" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityLoginGiftGiving)
	end
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_LOGIN_GIFT_GIVING_ICON)
	self.listView:addChild(activityIcon)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_login_gift_giving",
	_widget = activityIcon,
	_invoke = nil,
	_interval = 0.5,})

	ActivityLoginGiftGiving.cellItem = activityIcon
	activityIcon.pagekey = "ActivityLoginGiftGiving"
	activityIcon.priority = 400
    activityIcon.activityType = 24
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        activityIcon.priority = 12
    end
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()
	end		
	table.insert(self.pageKeys, {key="ActivityLoginGiftGiving", page=ActivityLoginGiftGiving, activity_type = "24"})
end

function ActivityWindow:activityIndiana()--63（夺宝活动）
	local root = self.roots[1]
	app.load("client.activity.ActivityIndiana")
	
	local ActivityIndiana = ActivityIndiana:createCell()
	ActivityIndiana:init()
	ActivityIndiana.pageName = "ActivityIndiana"
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityIndiana)
	end
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_INDIANA_ICON)
	self.listView:addChild(activityIcon)
	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_rebel_army_recharge",
	-- _widget = activityIcon,
	-- _invoke = nil,
	-- _interval = 0.5,})

	ActivityIndiana.cellItem = activityIcon
	activityIcon.pagekey = "ActivityIndiana"
	activityIcon.priority = 1600
    activityIcon.activityType = 63
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="ActivityIndiana", page=ActivityIndiana})
end

function ActivityWindow:activityArean()--64（竞技场活动）
	local root = self.roots[1]
	app.load("client.activity.ActivityArean")
	
	local ActivityArean = ActivityArean:createCell()
	ActivityArean:init()
	ActivityArean.pageName = "ActivityArean"
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityArean)
	end
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_AREAN_ICON)
	self.listView:addChild(activityIcon)
	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_rebel_army_recharge",
	-- _widget = activityIcon,
	-- _invoke = nil,
	-- _interval = 0.5,})

	ActivityArean.cellItem = activityIcon
	activityIcon.pagekey = "ActivityArean"
	activityIcon.priority = 2000
    activityIcon.activityType = 64
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	activityIcon.push_state = 0	
	table.insert(self.pageKeys, {key="ActivityArean", page=ActivityArean})
end

function ActivityWindow:activityTrialTowerDouble()--世界海战双倍
	local root = self.roots[1]
	app.load("client.activity.ActivityDoubleDiscount")
	
	local ActivityTrialTowerDouble = ActivityDoubleDiscount:createCell()
	ActivityTrialTowerDouble:init(65)
	ActivityTrialTowerDouble.pageName = "ActivityTrialTowerDouble"
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityTrialTowerDouble)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_TRIAL_TOWER_DOUBLE_ICON)
	self.listView:addChild(activityIcon)
	
	ActivityTrialTowerDouble.cellItem = activityIcon
	activityIcon.pagekey = "ActivityTrialTowerDouble"
	activityIcon.priority = 1800
    activityIcon.activityType = 65
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="ActivityTrialTowerDouble", page=ActivityTrialTowerDouble})
end

function ActivityWindow:activityShare() ----分享
	local root = self.roots[1]
	app.load("client.activity.share.activitySharePage")
	
	local SharePage = ActivitySharePage:createCell()
	SharePage:init()
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(SharePage)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_HOME_SHARE)
	self.listView:addChild(activityIcon)	
	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_eat_manual",
	-- _widget = activityIcon,
	-- _invoke = nil,
	-- _interval = 0.5,})
	SharePage.cellItem = activityIcon
	activityIcon.pagekey = "SharePage"
	activityIcon.priority = 1010
    activityIcon.activityType = 68
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="SharePage", page=SharePage, activity_type = "68"})
end

function ActivityWindow:activityVarietyShopTwo()--限时兑换二
	local root = self.roots[1]
	app.load("client.activity.ActivityVarietyShopTwo")
	local VarietyShopTwo = ActivityVarietyShopTwo:createCell()
	VarietyShopTwo:init()
	VarietyShopTwo.pageName = "VarietyShopTwo" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(VarietyShopTwo)
	end

	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_VARIETY_SHOP_TWO_ICON)
	local wonderList = ccui.Helper:seekWidgetByName(root, "ListView_wonder_btn")
	wonderList:addChild(activityIcon)

	VarietyShopTwo.cellItem = activityIcon
	activityIcon.pagekey = "VarietyShopTwo"
	activityIcon.priority = 1015
    activityIcon.activityType = 70
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="VarietyShopTwo", page=VarietyShopTwo, activity_type = "70"})
end

function ActivityWindow:activityVarietyShopThree()--限时兑换三
	local root = self.roots[1]
	app.load("client.activity.ActivityVarietyShopThree")
	local VarietyShopThree = ActivityVarietyShopThree:createCell()
	VarietyShopThree:init()
	VarietyShopThree.pageName = "VarietyShopThree" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(VarietyShopThree)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_VARIETY_SHOP_THREE_ICON)
	local wonderList = ccui.Helper:seekWidgetByName(root, "ListView_wonder_btn")
	wonderList:addChild(activityIcon)

	VarietyShopThree.cellItem = activityIcon
	activityIcon.pagekey = "VarietyShopThree"
	activityIcon.priority = 1016
    activityIcon.activityType = 71
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="VarietyShopThree", page=VarietyShopThree, activity_type = "71"})
end

function ActivityWindow:activityContactus()--联系我们
    local root = self.roots[1]
    app.load("client.activity.ActivityContactUs")
    local ActContactUs = ActivityContactUs:createCell()
    ActContactUs:init()
    ActContactUs.pageName = "ActContactUs" 
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(ActContactUs)
    end
    
    local activityIcon = ActivityIconCell:createCell()
    activityIcon:init(activityIcon.enum_type.ACTIVITY_CONTACT_US)
  --  local wonderList = ccui.Helper:seekWidgetByName(root, "ListView_wonder_btn")
    self.listView:addChild(activityIcon)

    ActContactUs.cellItem = activityIcon
    activityIcon.pagekey = "ActContactUs"
    activityIcon.priority = 1
    activityIcon.activityType = 156
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    activityIcon.push_state = 0
    table.insert(self.pageKeys, {key="ActContactUs", page=ActContactUs, activity_type = "156"})
end

--游戏王facebook分享
function ActivityWindow:activityFaceBookShare()--
	local root = self.roots[1]
	app.load("client.activity.ActivityFaceBookShare")
	local FaceBookShare = ActivityFaceBookShare:createCell()
	FaceBookShare:init()
	FaceBookShare.pageName = "FaceBookShare" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(FaceBookShare)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_FACEBOOK_SHARE)
	local wonderList = ccui.Helper:seekWidgetByName(root, "ListView_wonder_btn")
	wonderList:addChild(activityIcon)

	FaceBookShare.cellItem = activityIcon
	activityIcon.pagekey = "FaceBookShare"
	activityIcon.priority = 910
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="FaceBookShare", page=FaceBookShare})
end

--游戏王邀请好友
function ActivityWindow:activityInviteFriend()--
	local root = self.roots[1]
	app.load("client.activity.ActivityInviteFriend")
	local InviteFriend = ActivityInviteFriend:createCell()

	InviteFriend:init()
	InviteFriend.pageName = "InviteFriend" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(InviteFriend)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_INVITE_FRIEND)
	local wonderList = ccui.Helper:seekWidgetByName(root, "ListView_wonder_btn")
	wonderList:addChild(activityIcon)

	InviteFriend.cellItem = activityIcon
	activityIcon.pagekey = "InviteFriend"
	activityIcon.priority = 920
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="InviteFriend", page=InviteFriend})
end

--折扣贩卖DISCOUNT_SALE
function ActivityWindow:activityDiscountSale()--
	local root = self.roots[1]
	app.load("client.activity.ActivityDiscountSale")
	local DiscountSale = ActivityDiscountSale:createCell()

	DiscountSale:init()
	DiscountSale.pageName = "DiscountSale" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(DiscountSale)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_DISCOUNT_SALE)
	local wonderList = ccui.Helper:seekWidgetByName(root, "ListView_wonder_btn")
	wonderList:addChild(activityIcon)

	DiscountSale.cellItem = activityIcon
	activityIcon.pagekey = "DiscountSale"
	activityIcon.priority = 1017
    activityIcon.activityType = 76
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="DiscountSale", page=DiscountSale, activity_type = "76"})
end

--等级礼包
function ActivityWindow:activityLevelGift()--
	local root = self.roots[1]
	app.load("client.activity.level_gift.ActivityLevelGift")
	local LevelGift = ActivityLevelGift:createCell()

	LevelGift:init()
	LevelGift.pageName = "LevelGift" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(LevelGift)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_LEVEL_GIFT)
	local wonderList = ccui.Helper:seekWidgetByName(root, "ListView_wonder_btn")
	wonderList:addChild(activityIcon)

	LevelGift.cellItem = activityIcon
	activityIcon.pagekey = "LevelGift"
	activityIcon.priority = 950
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="LevelGift", page=LevelGift})
end

--累计充值排行榜
function ActivityWindow:activityRechargeRank()--
	local root = self.roots[1]
	app.load("client.activity.ActivityRechargebleRank")
	local rechargeRank = ActivityRechargebleRank:createCell()

	rechargeRank:init()
	rechargeRank.pageName = "rechargeRank" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(rechargeRank)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_RECHARGE_RANK)
	local wonderList = ccui.Helper:seekWidgetByName(root, "ListView_wonder_btn")
	wonderList:addChild(activityIcon)

	rechargeRank.cellItem = activityIcon
	activityIcon.pagekey = "rechargeRank"
	activityIcon.priority = 960
    activityIcon.activityType = 79
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="rechargeRank", page=rechargeRank})
end

--月基金
function ActivityWindow:activityMonthFund()--
	local root = self.roots[1]
	app.load("client.activity.month_fund.ActivityMonthFund")
	local ActivityMonthFund = ActivityMonthFund:createCell()

	ActivityMonthFund:init()
	ActivityMonthFund.pageName = "ActivityMonthFund" 
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(ActivityMonthFund)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_MONTH_FUND)
	local wonderList = ccui.Helper:seekWidgetByName(root, "ListView_wonder_btn")
	wonderList:addChild(activityIcon)

	ActivityMonthFund.cellItem = activityIcon
	activityIcon.pagekey = "ActivityMonthFund"
	activityIcon.priority = 930
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="ActivityMonthFund", page=ActivityMonthFund})
end

--78,79,80招募武将活动
function ActivityWindow:activityRecruitShip( activityType )
	local root = self.roots[1]
	app.load("client.l_digital.activity.wonderful.SmActivityRecruitShip")
	local SmActivityRecruitShip = SmActivityRecruitShip:createCell()

	SmActivityRecruitShip:init(activityType)
	SmActivityRecruitShip.pageName = "SmActivityRecruitShip"..activityType
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(SmActivityRecruitShip)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	local enum_type = nil
	if tonumber(activityType) == 78 then
		enum_type = activityIcon.enum_type.ACTIVITY_RECRUIT_SHIP_1
	elseif tonumber(activityType) == 79 then
		enum_type = activityIcon.enum_type.ACTIVITY_RECRUIT_SHIP_2
	else
		enum_type = activityIcon.enum_type.ACTIVITY_RECRUIT_SHIP_3
	end
	activityIcon:init(enum_type)
	local wonderList = ccui.Helper:seekWidgetByName(root, "ListView_wonder_btn")
	wonderList:addChild(activityIcon)

	SmActivityRecruitShip.cellItem = activityIcon
	activityIcon.pagekey = "SmActivityRecruitShip"..activityType
	activityIcon.priority = 1018
	activityIcon.push_state = 0
	table.insert(self.pageKeys, {key="SmActivityRecruitShip"..activityType, page=SmActivityRecruitShip, activity_type = activityType})

	if tonumber(activityType) == 78 then
		activityIcon.priority = 1018
        activityIcon.activityType = 78
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            activityIcon.priority = 13
        end
		-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_recruit_ship_1",
		-- _widget = activityIcon,
		-- _invoke = nil,
		-- _interval = 0.5,})
	elseif tonumber(activityType) == 79 then
		activityIcon.priority = 1019
        activityIcon.activityType = 79
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            activityIcon.priority = 30
        end
		-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_recruit_ship_2",
		-- _widget = activityIcon,
		-- _invoke = nil,
		-- _interval = 0.5,})

	elseif tonumber(activityType) == 80 then
		activityIcon.priority = 1020
        activityIcon.activityType = 80
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            activityIcon.priority = 31
        end
		-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_recruit_ship_3",
		-- _widget = activityIcon,
		-- _invoke = nil,
		-- _interval = 0.5,})
	end
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()
	end
end

function ActivityWindow:activityWelcomeMoneyMan()--迎财神
	local root = self.roots[1]
	app.load("client.activity.ActivityWelcomeMoneyMan")
	local activityWelcomeMoneyManLayer = ActivityWelcomeMoneyMan:createCell()
	activityWelcomeMoneyManLayer:init()
	activityWelcomeMoneyManLayer.pageName = "ActivityWelcomeMoneyMan"
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(activityWelcomeMoneyManLayer)
	end

	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_WELCOME_MONEY_MAN_ICON)

	activityWelcomeMoneyManLayer.cellItem = activityIcon
	activityIcon.pagekey = "ActivityWelcomeMoneyMan"
	local wonderList = ccui.Helper:seekWidgetByName(root, "ListView_wonder_btn")
	wonderList:addChild(activityIcon)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_welcome_money_man",
	_widget = activityIcon,
	_invoke = nil,
	_interval = 0.5,})

	activityIcon.priority = 200
    activityIcon.activityType = 14
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()
	end	
	table.insert(self.pageKeys, {key="ActivityWelcomeMoneyMan", page=activityWelcomeMoneyManLayer})
end

function ActivityWindow:activitySmCompageCount(activityType)--竞技场积分奖励,抽卡送啦啦兽
	local root = self.roots[1]
	app.load("client.l_digital.activity.wonderful.SmActivityCompageCount")
	
	local SmActivityCompageCount = SmActivityCompageCount:createCell()
	SmActivityCompageCount:init(activityType)
	SmActivityCompageCount.pageName = "SmActivityCompageCount"
	if isUseNewActivityMode == true then
	else
		self.PageViewAty:addPage(SmActivityCompageCount)
	end
	
	local activityIcon = ActivityIconCell:createCell()
	local enum_type = ""
	if tonumber(activityType) == 81 then -- 抽卡活动-送拉拉兽
		enum_type = activityIcon.enum_type.ACTIVITY_SM_COMPAGE_COUNT_1
	elseif tonumber(activityType) == 82 then -- 招募活动-招募数码兽
		enum_type = activityIcon.enum_type.ACTIVITY_SM_COMPAGE_COUNT_2
	elseif tonumber(activityType) == 83 then -- 竞技场积分奖励
		enum_type = activityIcon.enum_type.ACTIVITY_SM_COMPAGE_COUNT_3
    elseif tonumber(activityType) == 116 then --抽卡送亚古兽（建号绑定）
        enum_type = activityIcon.enum_type.ACTIVITY_SM_COMPAGE_COUNT_4
	end
	activityIcon:init(enum_type)
	self.listView:addChild(activityIcon)

	if tonumber(activityType) == 81 
        or tonumber(activityType) == 116
        then
		activityIcon.priority = 1021
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            activityIcon.priority = 7
        end
        if tonumber(activityType) == 81 then
            activityIcon.activityType = 81
        elseif tonumber(activityType) == 116 then
            activityIcon.activityType = 116
        end
		-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_compage_count_1",
		-- _widget = activityIcon,
		-- _invoke = nil,
		-- _interval = 0.5,})
	elseif tonumber(activityType) == 82 then
		activityIcon.priority = 1022
        activityIcon.activityType = 82
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            activityIcon.priority = 28
        end
		-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_compage_count_2",
		-- _widget = activityIcon,
		-- _invoke = nil,
		-- _interval = 0.5,})
	elseif tonumber(activityType) == 83 then
		activityIcon.priority = 1023
        activityIcon.activityType = 83
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            activityIcon.priority = 18
        end
		-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_compage_count_3",
		-- _widget = activityIcon,
		-- _invoke = nil,
		-- _interval = 0.5,})
	end
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end

	SmActivityCompageCount.cellItem = activityIcon
	activityIcon.pagekey = "SmActivityCompageCount"..activityType
	if isUseNewActivityMode == true then
		activityIcon:updatePushState()
	end		
	table.insert(self.pageKeys, {key="SmActivityCompageCount"..activityType, page=SmActivityCompageCount, activity_type = activityType})
end

function ActivityWindow:activitySmDianjin(activityType)--点金奖励
    local root = self.roots[1]
    app.load("client.l_digital.activity.wonderful.SmActivityBuyGoldReward")
    local smActivityBuyGoldReward = SmActivityBuyGoldReward:createCell()
    smActivityBuyGoldReward:init(activityType)
    smActivityBuyGoldReward.pageName = "SmActivityBuyGoldReward"
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(SmActivityBuyGoldReward)
    end
    
    local activityIcon = ActivityIconCell:createCell()
    local enum_type = ""
    if tonumber(activityType) == 103 then -- 点金奖励
        activityIcon.priority = 103
        activityIcon.activityType = 103
        enum_type = activityIcon.enum_type.ACTIVITY_SM_BUY_GOLD_REWARD
    elseif tonumber(activityType) == 102 then -- 体力购买次数奖励
        activityIcon.priority = 102
        activityIcon.activityType = 102
        enum_type = activityIcon.enum_type.ACTIVITY_SM_BUY_FOOD_TIMES
    elseif tonumber(activityType) == 104 then -- 试炼积分奖励
        activityIcon.priority = 104
        activityIcon.activityType = 104
        enum_type = activityIcon.enum_type.ACTIVITY_SM_TRIALTOWER_POINT
    elseif tonumber(activityType) == 105 then -- 试炼宝箱开启
        activityIcon.priority = 105
        activityIcon.activityType = 105
        enum_type = activityIcon.enum_type.ACTIVITY_SM_TRIALTOWER_BOX_REWARD
    elseif tonumber(activityType) == 95 then -- 抽装备得天赋点
        activityIcon.priority = 95
        activityIcon.activityType = 95
        enum_type = activityIcon.enum_type.ACTIVITY_SM_CHEST_EXTRACT_REWARD_EX
    elseif tonumber(activityType) == 96 then -- 抽装备宝箱
        activityIcon.priority = 96
        activityIcon.activityType = 96
        enum_type = activityIcon.enum_type.ACTIVITY_SM_CHEST_EXTRACT_REWARD
    elseif tonumber(activityType) == 106 then -- 充值送资源
        activityIcon.priority = 106
        activityIcon.activityType = 106
        enum_type = activityIcon.enum_type.ACTIVITY_SM_RECHARGE_GET_REWARD
    elseif tonumber(activityType) == 108 then -- 挑战奖励
        activityIcon.priority = 108
        activityIcon.activityType = 108
        enum_type = activityIcon.enum_type.ACTIVITY_SM_CHANGEE_COPY_REWARD
    elseif tonumber(activityType) == 109 then -- 精英挑战王
        activityIcon.priority = 109
        activityIcon.activityType = 109
        enum_type = activityIcon.enum_type.ACTIVITY_SM_COPY_ELIT_ATTACK
    elseif tonumber(activityType) == 110 then -- 金币消耗
        activityIcon.priority = 110
        activityIcon.activityType = 110
        enum_type = activityIcon.enum_type.ACTIVITY_SM_GOLD_COST
    elseif tonumber(activityType) == 113 then -- 备战奖励
        activityIcon.priority = 113
        activityIcon.activityType = 113
        enum_type = activityIcon.enum_type.ACTIVITY_SM_READY_FOR_BATTLE
    elseif tonumber(activityType) == 115 then -- 消耗钻石送礼(建号绑定
        activityIcon.priority = 115
        activityIcon.activityType = 115
        enum_type = activityIcon.enum_type.ACTIVITY_ACCUMLATE_CONSUMPTION_ICON_EX
    elseif tonumber(activityType) == 126 then -- 完成任务送纪念道具
        activityIcon.priority = 126
        activityIcon.activityType = 126
        enum_type = activityIcon.enum_type.ACTIVITY_SM_READY_FOR_BATTLE1
    elseif tonumber(activityType) == 138 then -- 抽合金有礼
        activityIcon.priority = 138
        activityIcon.activityType = 138
        enum_type = activityIcon.enum_type.ACTIVITY_DRAW_MATRIX_REWORD
    elseif tonumber(activityType) == 141 then -- 探索有礼
        activityIcon.priority = 141
        activityIcon.activityType = 141
        enum_type = activityIcon.enum_type.ACTIVITY_ISLAND_EXPLORE_REWORD
    elseif tonumber(activityType) == 140 then -- 净化挑战
        activityIcon.priority = 140
        activityIcon.activityType = 140
        enum_type = activityIcon.enum_type.ACTIVITY_CLEANSING_ATTACK_REWORD
    end
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    activityIcon:init(enum_type)
    self.listView:addChild(activityIcon)

    smActivityBuyGoldReward.cellItem = activityIcon
    activityIcon.pagekey = "SmActivityBuyGoldReward"..activityType
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end     
    table.insert(self.pageKeys, {key="SmActivityBuyGoldReward"..activityType, page=smActivityBuyGoldReward, activity_type = activityType})
end

function ActivityWindow:activitySmLimited(activityType)   -- 通用限时活动
    local root = self.roots[1]
    app.load("client.l_digital.activity.wonderful.SmActivityLimitedWindow")
    
    local smActivityLimitedWindow = SmActivityLimitedWindow:createCell()
    smActivityLimitedWindow:init(activityType)
    smActivityLimitedWindow.pageName = "SmActivityLimitedWindow"
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(smActivityLimitedWindow)
    end
    
    local activityIcon = ActivityIconCell:createCell()
    local enum_type = ""
    if tonumber(activityType) == 94 then -- 体力购买双倍
        activityIcon.priority = 94
        activityIcon.activityType = 94
        enum_type = activityIcon.enum_type.ACTIVITY_SM_COPY_FOOD_BUY_MULTIPLE
    elseif tonumber(activityType) == 97 then -- 普通关卡双倍掉落
        activityIcon.priority = 97
        activityIcon.activityType = 97
        enum_type = activityIcon.enum_type.ACTIVITY_SM_COPY_DOUBLE_DROP_NORMAL
    elseif tonumber(activityType) == 98 then -- 精英关卡双倍掉落
        activityIcon.priority = 98
        activityIcon.activityType = 98
        enum_type = activityIcon.enum_type.ACTIVITY_SM_COPY_DOUBLE_DROP_ELIT
    elseif tonumber(activityType) == 99 then -- 金币关卡双倍掉落
        activityIcon.priority = 99
        activityIcon.activityType = 99
        enum_type = activityIcon.enum_type.ACTIVITY_SM_COPY_DOUBLE_DROP_SILVER
    elseif tonumber(activityType) == 100 then -- 精英副本次数增加
        activityIcon.priority = 100
        activityIcon.activityType = 100
        enum_type = activityIcon.enum_type.ACTIVITY_SM_COPY_ATTACK_COUNT_ELIT
    elseif tonumber(activityType) == 101 then -- 金币副本次数增加
        activityIcon.priority = 101
        activityIcon.activityType = 101
        enum_type = activityIcon.enum_type.ACTIVITY_SM_COPY_ATTACK_COUNT_SILVER
    elseif tonumber(activityType) == 114 then   --机械邪龙兽来袭（活动标签）
        activityIcon.priority = 114
        activityIcon.activityType = 114
        enum_type = activityIcon.enum_type.ACTIVITY_SM_OTHER_RECRUIT_ACTIVITY_EX
    elseif tonumber(activityType) == 120 then   --愚人节：关卡掉落
        activityIcon.priority = 120
        activityIcon.activityType = 120
        enum_type = activityIcon.enum_type.ACTIVITY_COPY_REWARD_DROP
    elseif tonumber(activityType) == 121 then   --愚人节：节日道具兑换活动
        activityIcon.priority = 121
        activityIcon.activityType = 121
        enum_type = activityIcon.enum_type.ACTIVITY_FESTIVAL_EXCHNAGE
    -- elseif tonumber(activityType) == 1211 then   --愚人节：节日道具兑换活动
    --     activityIcon.priority = 1211
    --     enum_type = activityIcon.enum_type.ACTIVITY_FESTIVAL_EXCHNAGE_1
    -- elseif tonumber(activityType) == 122 then   --愚人节：节日登陆活动
    --     activityIcon.priority = 122
    --     enum_type = activityIcon.enum_type.ACTIVITY_FESTIVAL_LOGIN
    elseif tonumber(activityType) == 123 then   --关卡掉落
        activityIcon.priority = 123
        activityIcon.activityType = 123
        enum_type = activityIcon.enum_type.ACTIVITY_COPY_REWARD_DROP1
    elseif tonumber(activityType) == 128 then   --经验副本次数增加
        activityIcon.priority = 128
        activityIcon.activityType = 128
        enum_type = activityIcon.enum_type.ACTIVITY_SM_TYPE_128
    elseif tonumber(activityType) == 129 then   --技之作战副本次数增加
        activityIcon.priority = 129
        activityIcon.activityType = 129
        enum_type = activityIcon.enum_type.ACTIVITY_SM_TYPE_129
    elseif tonumber(activityType) == 130 then   --幻像挑战副本次数增加
        activityIcon.priority = 130
        activityIcon.activityType = 130
        enum_type = activityIcon.enum_type.ACTIVITY_SM_TYPE_130
    elseif tonumber(activityType) == 131 then   --经验副本奖励双倍
        activityIcon.priority = 131
        activityIcon.activityType = 131
        enum_type = activityIcon.enum_type.ACTIVITY_SM_TYPE_131
    elseif tonumber(activityType) == 132 then   --技之作战奖励双倍
        activityIcon.priority = 132
        activityIcon.activityType = 132
        enum_type = activityIcon.enum_type.ACTIVITY_SM_TYPE_132
    elseif tonumber(activityType) == 133 then   --幻像挑战副本奖励双倍
        activityIcon.priority = 133
        activityIcon.activityType = 133
        enum_type = activityIcon.enum_type.ACTIVITY_SM_TYPE_133
    elseif tonumber(activityType) == 134 then   --数码试炼金币奖励双倍
        activityIcon.priority = 134
        activityIcon.activityType = 134
        enum_type = activityIcon.enum_type.ACTIVITY_SM_TYPE_134
    elseif tonumber(activityType) == 135 then   --净化必出数码兽
        activityIcon.priority = 135
        activityIcon.activityType = 135
        enum_type = activityIcon.enum_type.ACTIVITY_CLEANSING_GET_HERO
    elseif tonumber(activityType) == 136 then   --
        activityIcon.priority = 136
        activityIcon.activityType = 136
        enum_type = activityIcon.enum_type.ACTIVITY_SKIN_EXCHANGE_RESTRICTION_ICON
    end
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    activityIcon:init(enum_type)
    self.listView:addChild(activityIcon)
    
    smActivityLimitedWindow.cellItem = activityIcon
    activityIcon.pagekey = "SmActivityLimitedWindow"..activityType
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end     
    ----
    table.insert(self.pageKeys, {key="SmActivityLimitedWindow"..activityType, page=smActivityLimitedWindow, activity_type = activityType})
end

function ActivityWindow:activitySmVIPDiscount()   -- VIP折扣
    local root = self.roots[1]
    app.load("client.l_digital.activity.wonderful.SmActivityVIPDiscount")
    
    local smActivityVIPDiscount = SmActivityVIPDiscount:createCell()
    smActivityVIPDiscount:init()
    smActivityVIPDiscount.pageName = "SmActivityVIPDiscount"
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(smActivityVIPDiscount)
    end
    
    local activityIcon = ActivityIconCell:createCell()
    activityIcon.priority = 111
    activityIcon.activityType = 111
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    activityIcon:init(activityIcon.enum_type.ACTIVITY_SM_VIP_DISCOUNT)
    self.listView:addChild(activityIcon)
    
    smActivityVIPDiscount.cellItem = activityIcon
    activityIcon.pagekey = "SmActivityVIPDiscount"
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end     
    table.insert(self.pageKeys, {key="SmActivityVIPDiscount", page=smActivityVIPDiscount, activity_type = 111})
end

function ActivityWindow:activitySmPropDiscount()   -- 道具折扣
    local root = self.roots[1]
    app.load("client.l_digital.activity.wonderful.SmActivityPropDiscount")
    
    local smActivityPropDiscount = SmActivityPropDiscount:createCell()
    smActivityPropDiscount:init()
    smActivityPropDiscount.pageName = "SmActivityPropDiscount"
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(smActivityPropDiscount)
    end
    
    local activityIcon = ActivityIconCell:createCell()
    activityIcon.priority = 112
    activityIcon.activityType = 112
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    activityIcon:init(activityIcon.enum_type.ACTIVITY_SM_DAILY_PROP_DISCOUNT)
    self.listView:addChild(activityIcon)

    smActivityPropDiscount.cellItem = activityIcon
    activityIcon.pagekey = "SmActivityPropDiscount"
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end     
    table.insert(self.pageKeys, {key="SmActivityPropDiscount", page=smActivityPropDiscount, activity_type = 112})
end

function ActivityWindow:activitySmPropDiscountNew()   -- 道具折扣
    local root = self.roots[1]
    app.load("client.l_digital.activity.wonderful.SmActivityPropDiscountNew")
    
    local SmActivityPropDiscountNew = SmActivityPropDiscountNew:createCell()
    SmActivityPropDiscountNew:init()
    SmActivityPropDiscountNew.pageName = "SmActivityPropDiscountNew"
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(SmActivityPropDiscountNew)
    end
    
    local activityIcon = ActivityIconCell:createCell()
    activityIcon.priority = 112
    activityIcon.activityType = 112
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    activityIcon:init(activityIcon.enum_type.ACTIVITY_SM_DAILY_PROP_DISCOUNT)
    self.listView:addChild(activityIcon)

    SmActivityPropDiscountNew.cellItem = activityIcon
    activityIcon.pagekey = "SmActivityPropDiscountNew"
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end     
    table.insert(self.pageKeys, {key="SmActivityPropDiscountNew", page=SmActivityPropDiscountNew, activity_type = 112})
end

function ActivityWindow:activityRechargeForSixtyGift()   -- 60元充值活动活动
    local root = self.roots[1]
    app.load("client.l_digital.activity.wonderful.RechargeForSixtyGiftActivity")
    
    local rechargeForSixtyGiftActivity = RechargeForSixtyGiftActivity:createCell()
    rechargeForSixtyGiftActivity:init()
    rechargeForSixtyGiftActivity.pageName = "RechargeForSixtyGiftActivity"
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(rechargeForSixtyGiftActivity)
    end
    
    local activityIcon = ActivityIconCell:createCell()
    activityIcon.priority = 1
    activityIcon.activityType = 119
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    activityIcon._istips = true
    activityIcon:init(activityIcon.enum_type.ACTIVITY_RECHARGE_FOR_SIXTY_GIFT)
    self.listView:addChild(activityIcon)

    rechargeForSixtyGiftActivity.cellItem = activityIcon
    activityIcon.pagekey = "RechargeForSixtyGiftActivity"
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end     
    table.insert(self.pageKeys, {key="RechargeForSixtyGiftActivity", page=rechargeForSixtyGiftActivity, activity_type = 119})
end

function ActivityWindow:activityHolidayLogin(activity_type)--愚人节：节日登陆活动
    local root = self.roots[1]
    app.load("client.activity.ActivityHolidayLogin")
    
    local ActivityHolidayLogin = ActivityHolidayLogin:createCell()
    ActivityHolidayLogin:init(activity_type)
    ActivityHolidayLogin.pageName = "ActivityHolidayLogin"
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(ActivityHolidayLogin)
    end
    
    local activityIcon = ActivityIconCell:createCell()
    activityIcon:init(activityIcon.enum_type.ACTIVITY_FESTIVAL_LOGIN)
    self.listView:addChild(activityIcon)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_holiday_login",
        _widget = activityIcon,
        _invoke = nil,
        _interval = 0.5,})
    end

    ActivityHolidayLogin.cellItem = activityIcon
    activityIcon.pagekey = "ActivityHolidayLogin"
    activityIcon.priority = 1122
    activityIcon.activityType = 122
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        activityIcon.priority = 122
    end
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end     
    table.insert(self.pageKeys, {key="ActivityHolidayLogin", page=ActivityHolidayLogin, activity_type = "122"})
end

-- 徽章限时兑换
function ActivityWindow:activityEmblemLimitTimeExchange(m_type)--徽章限时兑换
    local root = self.roots[1]
    app.load("client.activity.ActivityEmblemLimitTimeExchange")
    local ActivityEmblemLimitTimeExchange = ActivityEmblemLimitTimeExchange:createCell()
    ActivityEmblemLimitTimeExchange:init(m_type)
    ActivityEmblemLimitTimeExchange.pageName = "ActivityEmblemLimitTimeExchange" 
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(ActivityEmblemLimitTimeExchange)
    end

    local activityIcon = ActivityIconCell:createCell()
    activityIcon:init(activityIcon.enum_type.ACTIVITY_EMBLEM_LIMIT_TIME_EXCHANGE)
    self.listView:addChild(activityIcon)

    ActivityEmblemLimitTimeExchange.cellItem = activityIcon
    activityIcon.pagekey = "ActivityEmblemLimitTimeExchange"
    activityIcon.priority = 1124
    activityIcon.activityType = 124
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    activityIcon.push_state = 0
    table.insert(self.pageKeys, {key="ActivityEmblemLimitTimeExchange", page=ActivityEmblemLimitTimeExchange, activity_type = "124"})
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_emblem_limit_time_exchange",
        _widget = activityIcon,
        _invoke = nil,
        _interval = 0.5,})
    end
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end 
end

--徽章登陆有礼
function ActivityWindow:activityEmblemLogin(activity_type)
    local root = self.roots[1]
    app.load("client.activity.ActivityEmblemLogin")
    
    local ActivityEmblemLogin = ActivityEmblemLogin:createCell()
    ActivityEmblemLogin:init(activity_type)
    ActivityEmblemLogin.pageName = "ActivityEmblemLogin"
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(ActivityEmblemLogin)
    end
    
    local activityIcon = ActivityIconCell:createCell()
    activityIcon:init(activityIcon.enum_type.ACTIVITY_EMBLEM_LOGIN)
    self.listView:addChild(activityIcon)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_emblem_login",
        _widget = activityIcon,
        _invoke = nil,
        _interval = 0.5,})
    end

    ActivityEmblemLogin.cellItem = activityIcon
    activityIcon.pagekey = "ActivityEmblemLogin"
    activityIcon.priority = 1125
    activityIcon.activityType = 125
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        activityIcon.priority = 125
    end
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end     
    table.insert(self.pageKeys, {key="ActivityEmblemLogin", page=ActivityEmblemLogin, activity_type = "125"})
end

function ActivityWindow:activitySmPropGiftBoxPromotion()   -- 纪念礼盒促销 127
    local root = self.roots[1]
    app.load("client.l_digital.activity.wonderful.SmPropGiftBoxPromotion")
    
    local SmPropGiftBoxPromotion = SmPropGiftBoxPromotion:createCell()
    SmPropGiftBoxPromotion:init()
    SmPropGiftBoxPromotion.pageName = "SmPropGiftBoxPromotion"
    if isUseNewActivityMode == true then
    else
        self.PageViewAty:addPage(SmPropGiftBoxPromotion)
    end
    
    local activityIcon = ActivityIconCell:createCell()
    activityIcon.priority = 127
    activityIcon.activityType = 127
    local activity_sequence = dms.searchs(dms["activity_sequence"], 2, activityIcon.activityType)
    if activity_sequence ~= nil and activity_sequence[1][3] ~= nil then
        activityIcon.activitySequence = activity_sequence[1][3]
    end
    activityIcon:init(activityIcon.enum_type.ACTIVITY_SM_DAILY_PROP_GIFT_BOX_PROMOTION)
    self.listView:addChild(activityIcon)

    SmPropGiftBoxPromotion.cellItem = activityIcon
    activityIcon.pagekey = "SmPropGiftBoxPromotion"
    if isUseNewActivityMode == true then
        activityIcon:updatePushState()
    end     
    table.insert(self.pageKeys, {key="SmPropGiftBoxPromotion", page=SmPropGiftBoxPromotion, activity_type = 127})
end

function ActivityWindow:activityWindowRefresh()
	local root = self.roots[1]
	if _ED.active_activity[39] ~= nil and _ED.active_activity[39]~="" then
		state_machine.excute("activity_luxury_recharge_button", 0, "activity_luxury_recharge_button.") -- 刷新豪华签到
	end
	state_machine.excute("activity_month_card_button", 0, "activity_month_card_button.") -- 活动月卡
	if _ED.active_activity[4] ~= nil and _ED.active_activity[4]~="" then
		state_machine.excute("activity_first_recharge_button", 0, "activity_first_recharge_button.") -- 刷新活动首冲
	end
	-- if _ED.active_activity[7] ~= nil and _ED.active_activity[7]~="" then
	-- 	state_machine.excute("activity_accumlate_recharge_button", 0, "activity_accumlate_recharge_button.") -- 刷新累充
	-- end
 --    if _ED.active_activity[92] ~= nil and _ED.active_activity[92]~="" then
 --        state_machine.excute("activity_accumlate_recharge_button", 0, "activity_accumlate_recharge_button.") -- 刷新累充
 --    end
	if _ED.active_activity[27] ~= nil and _ED.active_activity[27]~="" then
		state_machine.excute("all_server_fund_activity_update_draw", 0, "all_server_fund_activity_update_draw.") -- 刷新开服基金VIP等级
	end
    
    -- TODO: 刷新老用户回归活动
    if _ED.active_activity[165] ~= nil then
        state_machine.excute("user_return_main_tab2_refresh",0,"user_return_main_tab2_refresh.")
    end

	-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	-- 	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	-- 	then
	-- 	if _ED.active_activity[77] ~= nil and _ED.active_activity[77]~="" then
	-- 		state_machine.excute("sm_activity_recharge_everyday_gift_window_update_draw", 0, "sm_activity_recharge_everyday_gift_window_update_draw.") -- 刷新每日累充
	-- 	end
	-- else
	-- 	if _ED.active_activity[21] ~= nil and _ED.active_activity[21]~="" then
	-- 		state_machine.excute("activity_one_day_recharge_button", 0, "activity_one_day_recharge_button.") -- 刷新每日累充
	-- 	end
	-- end
 --     -- 刷新每日累充
 --    if _ED.active_activity[91] ~= nil and _ED.active_activity[91] ~= "" then
 --        state_machine.excute("sm_activity_recharge_everyday_gift_window_update_draw", 0, "sm_activity_recharge_everyday_gift_window_update_draw.") -- 刷新每日累充
 --    end

 --     -- 刷新每日充值送礼-恶魔兽
 --    if _ED.active_activity[117] ~= nil and _ED.active_activity[117] ~= "" then
 --        state_machine.excute("sm_activity_recharge_everyday_gift_window_update_draw", 0, "sm_activity_recharge_everyday_gift_window_update_draw.") -- 刷新每日累充
 --    end

 --     -- 刷新每日充值送礼-V仔兽EX
 --    if _ED.active_activity[118] ~= nil and _ED.active_activity[118] ~= "" then
 --        state_machine.excute("sm_activity_recharge_everyday_gift_window_update_draw", 0, "sm_activity_recharge_everyday_gift_window_update_draw.") -- 刷新每日累充
 --    end
	
	-- if _ED.active_activity[45] ~= nil and _ED.active_activity[45]~="" then
	-- 	state_machine.excute("activity_once_recharge_button", 0, "activity_once_recharge_button.") -- 刷新单笔累充
	-- end

	-- if __lua_project_id == __lua_project_gragon_tiger_gate 
	-- 	or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	-- 	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	-- 	or __lua_project_id == __lua_project_red_alert 
	-- 	then
	-- 	if _ED.active_activity[17] ~= nil and _ED.active_activity[17]~="" then
	-- 		state_machine.excute("activity_accumlate_consumption_onupdate_data",0,"")	 --累计消费
	-- 	end
	-- end
    
end

function ActivityWindow:onUpdateDrawNew()
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self._activity_list = {}
		local root = self.roots[1]
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 38)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmCheckInfo()
                    table.insert(self._activity_list, "38") 
                end
            end
		else
			if _ED.active_activity[38] ~= nil and _ED.active_activity[38]~="" or _ED.active_activity[39] ~= nil and _ED.active_activity[39]~="" then
				self:activitySignIn()				--1：签到
			end
		end
		if _ED.active_activity[48] ~= nil and _ED.active_activity[48]~="" then
            local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 48)
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
    			self:activityNextDay()			--48：次日
    			table.insert(self._activity_list, "48")
            end
		end	
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
		else
			if _ED.active_activity[28] ~= nil and _ED.active_activity[28]~="" then
				-- self:activityVarietyShop()			-- 杂货铺
			end
		end
		if _ED.active_activity[7] ~= nil and _ED.active_activity[7]~="" then
            local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 7)
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
    			self:activityAccumlate(7)			--2：累充
    			table.insert(self._activity_list, "7")
            end
		end	
		if zstring.tonumber(_ED.server_review) ~= 1 then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				local m_isVisible = false
				for i,v in pairs(_ED.month_card) do
					if tonumber(v.surplus_month_card_time) == 0 then
						m_isVisible = true
					end
				end
                -- 月卡重塑对于老月卡改为表控制
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 1000)
                if activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                    if _ED.active_activity[192] ~= nil then 
                        self:activityMonthCardTwo()
                        table.insert(self._activity_list, "1000")
                    end
                else
    				if m_isVisible == true then
    					self:activityMonthCardTwo()			--3：月卡
                        table.insert(self._activity_list, "1000")
    				end
                end
			else
				self:activityMonthCardTwo()			--3：月卡
			end
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
		else
			if _ED.active_activity[40] ~= nil and _ED.active_activity[40]~="" then
				self:activityVipPackage()			--4:VIP礼包
			end	
		end	

		if _ED.active_activity[47] ~= nil and _ED.active_activity[47]~="" then
            local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 47)
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
    			self:activityRebelArmy()			--叛军
    			table.insert(self._activity_list, "47")
            end
		end	
		
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
		else
			if _ED.active_activity[46] ~= nil and _ED.active_activity[46]~="" then
				self:activityHeroDiscount()			--神将折扣
			end	
		end	
		if _ED.active_activity[44] ~= nil and _ED.active_activity[44]~="" then
            local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 44)
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
        		self:activityDuplicateDouble()			--副本双倍
        		table.insert(self._activity_list, "44")
            end
		end	
		if _ED.active_activity[43] ~= nil and _ED.active_activity[43]~="" then
            local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 43)
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
    			self:activityArenaDouble()			--演习双倍
    			table.insert(self._activity_list, "43")
            end
		end	
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			if _ED.active_activity[77] ~= nil and _ED.active_activity[77]~="" then
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 77)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
    				self:activityOneDayRecharge(77)
    				table.insert(self._activity_list, "77")
                end
			end
		else
			if _ED.active_activity[21] ~= nil and _ED.active_activity[21]~="" then
				self:activityOneDayRecharge()			--21（单日充值活动）
			end	
		end	
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
		else
			if _ED.welcome_mammon.welcome_time_sum ~= nil and _ED.welcome_mammon.welcome_time_sum ~= "" then
				self:activityWelcomeMammon()		--5：迎财神
			end	
		end	
		if _ED.active_activity[45] ~= nil and _ED.active_activity[45]~="" then
            local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 45)
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
    			self:activityOnceRecharge()			--45（单笔充值活动）
    			table.insert(self._activity_list, "45")
            end
		end	
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
    		if tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 150, fun_open_condition.level) then
				if _ED.active_activity[27] ~= nil and _ED.active_activity[27]~="" then
                    local is_show = false
                    for j, w in pairs(_ED.active_activity[27].activity_Info) do
                        if tonumber(w.activityInfo_isReward) == 0 then
                            is_show = true
                            break
                        end
                    end
                    local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 27)
                    if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                    else
                        if is_show == true then
                            self:activityStartServeFund()       --开服基金
                            table.insert(self._activity_list, "27")
                        end
                    end
				end
			end
		end
		-- self:activityStartServeFund()		--开服基金
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
		else
			if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
				self:activityGiftCodes() 	--兑换码
			end
		end
		if _ED.active_activity[68] ~= nil and _ED.active_activity[68]~="" then --分享
            local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 68)
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
    			if open_share_fun == 1 then -- tipstring里的开关，1 是打开，0是关闭
    				self:activityShare()
    				table.insert(self._activity_list, "68")
    			end
            end
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
            local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 1001)
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
    			if false == funOpenDrawTip(151,false) then
                    if getSmActivityEatManualShow() == true then
        				self:activityReplyPhysical()		--6：回体力
                        table.insert(self._activity_list, "1001")
                    end
    			end
            end
		else
			self:activityReplyPhysical()		--6：回体力
		end
		if _ED.active_activity[17] ~= nil and _ED.active_activity[17]~="" then --累计消费
            local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 17)
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
    			self:activityConsumption(17)
    			table.insert(self._activity_list, "17")
            end
		end

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
		else
			if _ED.active_activity[14] ~= nil and _ED.active_activity[14]~="" then  --迎财神
				self:activityWelcomeMoneyMan()
			end
		end

		if _ED.active_activity[49] ~= nil and _ED.active_activity[49]~="" then  --排行榜活动
			 local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 49)
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
                self:activityFightingRank()
    			table.insert(self._activity_list, "49")
            end
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
            if false then
                if _ED.active_activity[24] ~= nil and _ED.active_activity[24] ~= "" then
                    local is_show = false
                    for k, v in pairs(_ED.active_activity[24].activity_Info) do
                        if tonumber(v.activityInfo_isReward) == 0 then
                            is_show = true
                        end
                    end
                    local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 24)
                    if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                    else
                        if is_show == true then
                            self:activityLoginReward()
                            table.insert(self._activity_list, "24")
                        end
                    end
                end
            end
		else
			if _ED.active_activity[24] ~= nil and _ED.active_activity[24]~="" then  --登陆送礼
				self:ActivityLoginGiftGiving()
			end
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			if _ED.active_activity[28] ~= nil and _ED.active_activity[28]~="" then  --兑换
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 28)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
    				-- self:activityHalfPriceRestrictionNew(28)
    				-- table.insert(self._activity_list, "28")
                end
			end

            if _ED.active_activity[136] ~= nil and _ED.active_activity[136]~="" then  --皮肤兑换
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 136)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySkinExchangeRestriction(136)
                    table.insert(self._activity_list, "136")
                end
            end
		else
			if _ED.active_activity[62] ~= nil and _ED.active_activity[62]~="" then  --半价限购
				self:activityHalfPriceRestriction()
			end
		end
		if _ED.active_activity[70] ~= nil and _ED.active_activity[70]~="" then  --限时兑换二
			 local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 70)
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
                self:activityVarietyShopTwo()--限时兑换二
    			table.insert(self._activity_list, "70")
            end
		end
		if _ED.active_activity[71] ~= nil and _ED.active_activity[71]~="" then  --限时兑换三
			local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 71)
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
                self:activityVarietyShopThree()--限时兑换三
    			table.insert(self._activity_list, "71")
            end
		end
		
		if _ED.active_activity[76] ~= nil and _ED.active_activity[76]~="" then  --折扣贩售
			local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 76)
            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
                self:activityDiscountSale()
    			table.insert(self._activity_list, "76")
            end
		end

		--等级礼包
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
		else
			local levelGift = dms.int(dms["fun_open_condition"], 78, fun_open_condition.level)
		    if levelGift > 0 and zstring.tonumber(_ED.user_info.user_grade) > levelGift then 
		       self:activityLevelGift()
		    end
	    end
	    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	    	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	    	then
	    	if _ED.active_activity[78] ~= nil and _ED.active_activity[78]~="" then  --招募仙人掌
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 78)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    if funOpenDrawTip(153, false) == false then
        				self:activityRecruitShip(78)
        				table.insert(self._activity_list, "78")
                    end
                end
			end
			if _ED.active_activity[79] ~= nil and _ED.active_activity[79]~="" then  --招募巴多拉
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 79)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    if funOpenDrawTip(154, false) == false then
        				self:activityRecruitShip(79)
        				table.insert(self._activity_list, "79")
                    end
                end
			end
			if _ED.active_activity[80] ~= nil and _ED.active_activity[80]~="" then  --招募火神兽
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 80)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    if funOpenDrawTip(155, false) == false then
        				self:activityRecruitShip(80)
        				table.insert(self._activity_list, "80")
                    end
                end
			end

			if _ED.active_activity[81] ~= nil and _ED.active_activity[81]~="" then  --抽卡活动-送拉拉兽
				local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 81)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmCompageCount(81)
    				table.insert(self._activity_list, "81")
                end
			end

			if _ED.active_activity[82] ~= nil and _ED.active_activity[82]~="" then  --招募活动-招募数码兽
				local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 82)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmCompageCount(82)
    				table.insert(self._activity_list, "82")
                end
			end

			if _ED.active_activity[83] ~= nil and _ED.active_activity[83]~="" then  --竞技场积分奖励
				local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 83)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmCompageCount(83)
    				table.insert(self._activity_list, "83")
                end
			end
            if _ED.active_activity[116] ~= nil and _ED.active_activity[116]~="" then  --抽卡送亚古兽（建号绑定）
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 116)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmCompageCount(116)
                    table.insert(self._activity_list, "116")
                end
            end
			if _ED.active_activity[90] ~= nil and _ED.active_activity[90]~="" then  --点金双倍
				local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 90)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activityHeroDiscount()
    				table.insert(self._activity_list, "90")
                end
			end

            if _ED.active_activity[91] ~= nil and _ED.active_activity[91]~="" then  --每日充值送礼
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 91)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activityOneDayRecharge(91)
                    table.insert(self._activity_list, "91")
                end
            end

            if _ED.active_activity[117] ~= nil and _ED.active_activity[117]~="" then  --每日充值送礼-恶魔兽
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 117)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activityOneDayRecharge(117)
                    table.insert(self._activity_list, "117")
                end
            end

            if _ED.active_activity[118] ~= nil and _ED.active_activity[118]~="" then  --每日充值送礼-V仔兽EX
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 118)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activityOneDayRecharge(118)
                    table.insert(self._activity_list, "118")
                end
            end

            if _ED.active_activity[139] ~= nil and _ED.active_activity[139]~="" then  --每日充值送礼-V仔兽EX
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 139)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activityOneDayRecharge(139)
                    table.insert(self._activity_list, "139")
                end
            end

            if _ED.active_activity[92] ~= nil and _ED.active_activity[92]~="" then  --充值送礼
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 92)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activityAccumlate(92)
                    table.insert(self._activity_list, "92")
                end
            end

            if _ED.active_activity[93] ~= nil and _ED.active_activity[93]~="" then  --每日折扣
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 93)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    if funOpenDrawTip(152, false) == false then
                        self:activitySmDayDiscount()
                        table.insert(self._activity_list, "93")
                    end
                end
            end

            if _ED.active_activity[94] ~= nil and _ED.active_activity[94]~="" then  --体力购买双倍
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 94)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(94)
                    table.insert(self._activity_list, "94")
                end
            end
            if _ED.active_activity[95] ~= nil and _ED.active_activity[95]~="" then  --抽装备宝箱得天赋点
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 95)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(95)
                    table.insert(self._activity_list, "95")
                end
            end
            if _ED.active_activity[96] ~= nil and _ED.active_activity[96]~="" then  --抽装备宝箱有礼
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 96)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(96)
                    table.insert(self._activity_list, "96")
                end
            end
            if _ED.active_activity[97] ~= nil and _ED.active_activity[97]~="" then  --普通关卡双倍掉落
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 97)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(97)
                    table.insert(self._activity_list, "97")
                end
            end
            if _ED.active_activity[98] ~= nil and _ED.active_activity[98]~="" then  --精英关卡双倍掉落
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 98)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(98)
                    table.insert(self._activity_list, "98")
                end
            end
            if _ED.active_activity[99] ~= nil and _ED.active_activity[99]~="" then  --金币关卡双倍掉落
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 99)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(99)
                    table.insert(self._activity_list, "99")
                end
            end
            if _ED.active_activity[100] ~= nil and _ED.active_activity[100]~="" then  --精英副本次数增加
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 100)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(100)
                    table.insert(self._activity_list, "100")
                end
            end
            if _ED.active_activity[101] ~= nil and _ED.active_activity[101]~="" then  --金币副本次数增加
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 101)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(101)
                    table.insert(self._activity_list, "101")
                end
            end
            if _ED.active_activity[102] ~= nil and _ED.active_activity[102]~="" then  --体力购买次数奖励
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 102)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(102)
                    table.insert(self._activity_list, "102")
                end
            end
            if _ED.active_activity[103] ~= nil and _ED.active_activity[103]~="" then  --点金次数奖励
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 103)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(103)
                    table.insert(self._activity_list, "103")
                end
            end
            if _ED.active_activity[104] ~= nil and _ED.active_activity[104]~="" then  --试炼积分奖励
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 104)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(104)
                    table.insert(self._activity_list, "104")
                end
            end
            if _ED.active_activity[105] ~= nil and _ED.active_activity[105]~="" then  --试炼宝箱开启奖励
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 105)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(105)
                    table.insert(self._activity_list, "105")
                end
            end
            if _ED.active_activity[106] ~= nil and _ED.active_activity[106]~="" then  --充值送资源
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 106)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                elseif __lua_project_id == __lua_project_l_digital then
                    -- DSC充值送资源移到主界面上
                else
                    self:activitySmDianjin(106)
                    table.insert(self._activity_list, "106")
                end
            end
            if _ED.active_activity[108] ~= nil and _ED.active_activity[108]~="" then  --挑战奖励
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 108)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(108)
                    table.insert(self._activity_list, "108")
                end
            end
            if _ED.active_activity[109] ~= nil and _ED.active_activity[109]~="" then  --精英挑战王
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 109)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(109)
                    table.insert(self._activity_list, "109")
                end
            end
            if _ED.active_activity[110] ~= nil and _ED.active_activity[110]~="" then  --金币消耗
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 110)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(110)
                    table.insert(self._activity_list, "110")
                end
            end
            if _ED.active_activity[111] ~= nil and _ED.active_activity[111]~="" then  --VIP折扣
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 111)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmVIPDiscount()
                    table.insert(self._activity_list, "111")
                end
            end
            if _ED.active_activity[112] ~= nil and _ED.active_activity[112]~="" then  --道具折扣
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 112)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmPropDiscountNew()
                    table.insert(self._activity_list, "112")

                    -- 老版本限时折扣界面
                    -- self:activitySmPropDiscount()
                    -- table.insert(self._activity_list, "112")
                end
            end
            if _ED.active_activity[113] ~= nil and _ED.active_activity[113]~="" then  --备战奖励
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 113)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(113)
                    table.insert(self._activity_list, "113")
                end
            end
            if _ED.active_activity[114] ~= nil and _ED.active_activity[114]~="" then  --机械邪龙兽来袭
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 114)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(tonumber(activity_sequence_show[1][4])) == 2 then
                else
                    self:activitySmLimited(114)
                    table.insert(self._activity_list, "114")
                end
            end
            if _ED.active_activity[115] ~= nil and _ED.active_activity[115]~="" then  --消耗钻石送礼(建号绑定
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 115)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(115)
                    table.insert(self._activity_list, "115")
                end
            end
             if _ED.active_activity[119] ~= nil and _ED.active_activity[119]~="" then  --60元充值活动活动
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 119)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activityRechargeForSixtyGift(119)
                    table.insert(self._activity_list, "119")
                end
            end

            if _ED.active_activity[120] ~= nil and _ED.active_activity[120]~="" then  --愚人节：关卡掉落
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 120)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(120)
                    table.insert(self._activity_list, "120")
                end
            end
            
            if _ED.active_activity[121] ~= nil and _ED.active_activity[121]~="" then  --愚人节：节日道具兑换活动
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 121)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(121)
                    table.insert(self._activity_list, "121")
                end
            end

            -- if _ED.active_activity[1211] ~= nil and _ED.active_activity[1211]~="" then  --愚人节：节日道具兑换活动
            --     self:activitySmLimited(1211)
            --     table.insert(self._activity_list, "1211")
            -- end

            if _ED.active_activity[122] ~= nil and _ED.active_activity[122]~="" then  --愚人节：节日登陆活动
                -- self:activitySmLimited(122)
                -- table.insert(self._activity_list, "122")
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 122)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activityHolidayLogin(122)
                    table.insert(self._activity_list, "122")
                end
            end

            if _ED.active_activity[123] ~= nil and _ED.active_activity[123]~="" then  --关卡掉落
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 123)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(123)
                    table.insert(self._activity_list, "123")
                end
            end
            
            if _ED.active_activity[124] ~= nil and _ED.active_activity[124]~="" then  --徽章限时兑换
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 124)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activityEmblemLimitTimeExchange(124)
                    table.insert(self._activity_list, "124")
                end
            end

            if _ED.active_activity[125] ~= nil and _ED.active_activity[125]~="" then  --徽章登陆有礼
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 125)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activityEmblemLogin(125)
                    table.insert(self._activity_list, "125")
                end
            end

            if _ED.active_activity[126] ~= nil and _ED.active_activity[126]~="" then  --完成任务送纪念道具
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 126)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(126)
                    table.insert(self._activity_list, "126")
                end
            end

            if _ED.active_activity[127] ~= nil and _ED.active_activity[127]~="" then  --纪念礼盒促销 127
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 127)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmPropGiftBoxPromotion()
                    table.insert(self._activity_list, "127")
                end
            end

            if _ED.active_activity[128] ~= nil and _ED.active_activity[128]~="" then  --经验副本次数增加
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 128)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(128)
                    table.insert(self._activity_list, "128")
                end
            end

            if _ED.active_activity[129] ~= nil and _ED.active_activity[129]~="" then  --技之作战副本次数增加
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 129)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(129)
                    table.insert(self._activity_list, "129")
                end
            end

            if _ED.active_activity[130] ~= nil and _ED.active_activity[130]~="" then  --幻像挑战副本次数增加
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 130)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(130)
                    table.insert(self._activity_list, "130")
                end
            end

            if _ED.active_activity[131] ~= nil and _ED.active_activity[131]~="" then  --经验副本奖励双倍
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 131)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(131)
                    table.insert(self._activity_list, "131")
                end
            end

            if _ED.active_activity[132] ~= nil and _ED.active_activity[132]~="" then  --技之作战奖励双倍
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 132)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(132)
                    table.insert(self._activity_list, "132")
                end
            end

            if _ED.active_activity[133] ~= nil and _ED.active_activity[133]~="" then  --幻像挑战副本奖励双倍
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 133)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(133)
                    table.insert(self._activity_list, "133")
                end
            end

            if _ED.active_activity[134] ~= nil and _ED.active_activity[134]~="" then  --数码试炼金币奖励双倍
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 134)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(134)
                    table.insert(self._activity_list, "134")
                end
            end

            if _ED.active_activity[135] ~= nil and _ED.active_activity[135]~="" then  --数净化必出数码兽
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 135)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmLimited(135)
                    table.insert(self._activity_list, "135")
                end
            end

            if _ED.active_activity[138] ~= nil and _ED.active_activity[138]~="" then  --抽合金有礼
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 138)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(138)
                    table.insert(self._activity_list, "138")
                end
            end

            if _ED.active_activity[140] ~= nil and _ED.active_activity[140]~="" then  --净化挑战有礼
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 140)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(140)
                    table.insert(self._activity_list, "140")
                end
            end

            if _ED.active_activity[141] ~= nil and _ED.active_activity[141]~="" then  --探索有礼
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 141)
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto ) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    self:activitySmDianjin(141)
                    table.insert(self._activity_list, "141")
                end
            end

            if _ED.active_activity[142] ~= nil and _ED.active_activity[142]~="" then  --成长之路
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 142)
                if ((__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto ) or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    if __lua_project_id == __lua_project_l_digital then
                    else
                        self:activityPathGrowth(142)
                        table.insert(self._activity_list, "142")
                    end
                end
            end

            if _ED.active_activity[150] ~= nil and _ED.active_activity[150]~="" then  -- 每日充值
                self:activityDailyRecharge(150)
                table.insert(self._activity_list, "150")
            end

            -- if _ED.active_activity[152] ~= nil and _ED.active_activity[152]~="" then  -- 每日单笔充值
            --     self:activityDailyOnceRecharge(152)
            --     table.insert(self._activity_list, "152")
            -- end

            if _ED.active_activity[151] ~= nil and _ED.active_activity[151]~="" then  -- 单笔充值
                self:ActivityOnceRechargeNew(151)
                table.insert(self._activity_list, "151")
            end
            if _ED.active_activity[156] ~= nil and _ED.active_activity[156]~="" then  -- 联系我们
                if __lua_project_id == __lua_project_l_naruto then
                    -- 火影的联系我们移至youtube
                else
                    self:activityContactus()
                    table.insert(self._activity_list, "156")
                end
            end
	    end
		for i,v in ipairs(self.pageKeys) do
			if v ~= nil then
				self.Panel_page_act:addChild(v.page)
			end
		end
	end
end

function ActivityWindow:sortListItem(first)
-- 100	七日活动	
-- 200	签到
-- 250	月卡
-- 300	次日领取	
-- 400	24（登陆送礼）	
-- 500	21（单日充值活动）	
-- 600	45（单笔充值活动）	
-- 700	累冲礼包	
-- 800	杂货铺	
-- 900	半价限购	
-- 1000	累积消费	
-- 1100	神将折扣	
-- 1200	47（叛军活动）	
-- 1300	67（叛军攻打活动）	
-- 1400	66（叛军击杀活动）	
-- 1500	 战力排行	
-- 1600	63（夺宝活动）	
-- 1700	副本双倍	
-- 1800	世界海战双倍	
-- 1900	演习	
-- 2000	64（竞技场活动）	
-- 2100	首冲礼包		
-- 2300	vip礼包	
-- 2400	迎财神	
-- 2500	回体力	
-- 2600	开服基金	
-- 2700	分享	
-- 2800	兑换码	
	local assemble = {}
	local items = self.listView:getItems()
	for i,v in pairs(items) do 
		local data = {
			list = v,
			pageKey = self.pageKeys[i],
		}
		table.insert(assemble,data)
	end
    local newitems = {}
	 for i,v in pairs(items) do
	 	 if first == nil then
		 	 if v._istips == true then
		 	 	v.push_state = 1 
		 	 else
		 	 	v.push_state = 0
		 	 end
	 	 end
	 	 v:retain()
	 	 table.insert(newitems,v)
	 end

    if false then
        local function sortType( a, b )
            local result = true
            if not a.activitySequence then
                result = false
            elseif not b.activitySequence then
                result = false
            elseif a.activitySequence == b.activitySequence then
                result = (tonumber(a.priority) < tonumber(b.priority))
            else
               result = (tonumber(a.activitySequence) < tonumber(b.activitySequence)) 
            end
            return result
        end
        table.sort(newitems, sortType)
    else
        local function sortType( a, b )
            return tonumber(a.push_state) > tonumber(b.push_state) or 
            	tonumber(a.push_state) == tonumber(b.push_state) and tonumber(a.priority) < tonumber(b.priority)
        end

        table.sort(newitems, sortType)
    end

    -- Fury (30-sep-2026): si se pidio una pestaña concreta (activity_window_open con nombre),
    -- va la PRIMERA: la seleccion de abajo toma newitems[1] y, por la ordenacion, abria otra
    -- (Suscripciones > «Tienda Premium» se quedaba en «Contactanos»).
    if type(first) == "string" then
        for i, v in ipairs(newitems) do
            if v.pagekey == first and i > 1 then
                table.remove(newitems, i)
                table.insert(newitems, 1, v)
                break
            end
        end
    end
    self.listView:removeAllItems()

    for i,v in pairs(newitems) do
    	-- print("==================", v.key, v.pagekey, v.priority, v.push_state,v.activityType)
     --    print("========activitySequence==========", v.activityType,v.activitySequence)
    	self.listView:addChild(v)
    	v:release()
    end

     if __lua_project_id == __lua_project_gragon_tiger_gate 
     	or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		then
     	--等级礼包不能跳转
    	if first == "LevelGift" then 
    	else
    		state_machine.excute("activity_window_control_change",0,newitems[1])	
    	end
	end
    self.listView:requestRefreshView()
    local itemsnew = self.listView:getItems()
    self.pageKeys = {}
    for i, v in pairs(itemsnew) do 
    	for f, w in pairs(assemble) do 
    		if w.list == v then
    			table.insert(self.pageKeys, {key=w.pageKey.key, page=w.pageKey.page, activity_type=zstring.tonumber(w.pageKey.activity_type)})
    			break
    		end
    	end
    end
end
function ActivityWindow:onUpdateDraw()
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		return
	end
	local root = self.roots[1]

	if _ED.active_activity[38] ~= nil and _ED.active_activity[38]~="" 
		or _ED.active_activity[39] ~= nil and _ED.active_activity[39]~="" then
		self:activitySignIn()				--1：签到
	end
	
	if _ED.active_activity[48] ~= nil and _ED.active_activity[48]~="" then
		self:activityNextDay()			--48：次日
	end
	
	if _ED.active_activity[28] ~= nil and _ED.active_activity[28]~="" then
		-- self:activityVarietyShop()			-- 杂货铺
	end
	
	if _ED.active_activity[4] ~= nil and _ED.active_activity[4]~="" and _ED.active_activity[4].activity_id == "0" then
		self:activityFirstRechargeable()	--	首冲
	end

	if _ED.active_activity[7] ~= nil and _ED.active_activity[7]~="" then
		self:activityAccumlate()			--2：累充
	end
	
	if zstring.tonumber(_ED.server_review) ~= 1 then
		self:activityMonthCardTwo()			--3：月卡
	end
	
	if _ED.active_activity[40] ~= nil and _ED.active_activity[40]~="" then
		self:activityVipPackage()			--4:VIP礼包
	end	

	if _ED.active_activity[47] ~= nil and _ED.active_activity[47]~="" then
		self:activityRebelArmy()			--叛军
	end	
	if _ED.active_activity[46] ~= nil and _ED.active_activity[46]~="" then
		self:activityHeroDiscount()			--神将折扣
	end	
	
	if _ED.active_activity[44] ~= nil and _ED.active_activity[44]~="" then
		self:activityDuplicateDouble()			--副本双倍
	end	
	
	if _ED.active_activity[43] ~= nil and _ED.active_activity[43]~="" then
		self:activityArenaDouble()			--演习双倍
	end	

	if _ED.active_activity[21] ~= nil and _ED.active_activity[21]~="" then
		self:activityOneDayRecharge()			--21（单日充值活动）
	end						
	if _ED.welcome_mammon.welcome_time_sum ~= nil and _ED.welcome_mammon.welcome_time_sum ~= "" then
		self:activityWelcomeMammon()		--5：迎财神
	end
		
	if _ED.active_activity[45] ~= nil and _ED.active_activity[45]~="" then
		self:activityOnceRecharge()			--45（单笔充值活动）
	end	
	-- self:activitySevenDays()			--七日活动
	if _ED.active_activity[49] ~= nil and _ED.active_activity[49]~="" then  --排行榜活动
		self:activityFightingRank()
	end
	if _ED.active_activity[24] ~= nil and _ED.active_activity[24]~="" then  --登陆送礼
		self:ActivityLoginGiftGiving()
	end
	if _ED.active_activity[62] ~= nil and _ED.active_activity[62]~="" then  --半价限购
		self:activityHalfPriceRestriction()
	end
	if _ED.active_activity[70] ~= nil and _ED.active_activity[70]~="" then  --限时兑换二
		self:activityVarietyShopTwo()--限时兑换二
	end
	if _ED.active_activity[71] ~= nil and _ED.active_activity[71]~="" then  --限时兑换三
		self:activityVarietyShopThree()--限时兑换三
	end
	if _ED.active_activity[63] ~= nil and _ED.active_activity[63]~="" then  --夺宝活动
		self:activityIndiana()
	end
	if _ED.active_activity[66] ~= nil and _ED.active_activity[66]~="" then  --叛军击杀
		self:activityRebelArmyKill()
	end
	if _ED.active_activity[64] ~= nil and _ED.active_activity[64]~="" then  --竞技场活动activityArean
		self:activityArean()
	end
	if _ED.active_activity[65] ~= nil and _ED.active_activity[65]~="" then  --世界海战双倍
		self:activityTrialTowerDouble()
	end
	if _ED.active_activity[67] ~= nil and _ED.active_activity[67]~="" then  --叛军攻打
		self:ActivityRebelArmyAttack()
	end
	if _ED.active_activity[14] ~= nil and _ED.active_activity[14]~="" then  --迎财神
		self:activityWelcomeMoneyMan()
	end

	if _ED.active_activity[76] ~= nil and _ED.active_activity[76]~="" then  --折扣贩售
		self:activityDiscountSale()
	end

	--self:activityMonthFund()
	self:activityStartServeFund()		--开服基金
	--等级礼包
	local levelGift = dms.int(dms["fun_open_condition"], 78, fun_open_condition.level)
    if levelGift > 0 and zstring.tonumber(_ED.user_info.user_grade) > levelGift then 
       self:activityLevelGift()
    end

	if _ED.active_activity[79] ~= nil and _ED.active_activity[79]~="" then  --累計充值排行
		self:activityRechargeRank()
	end

	if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
		self:activityGiftCodes() 	--兑换码
	end

	self:activityReplyPhysical()		--6：回体力
	if _ED.active_activity[17] ~= nil and _ED.active_activity[17]~="" then --累计消费
		self:activityConsumption()
	end

    if _ED.active_activity[122] ~= nil and _ED.active_activity[122]~="" then --愚人节：节日登陆活动
        self:activityHolidayLogin(122)
    end

    if _ED.active_activity[125] ~= nil and _ED.active_activity[125]~="" then --徽章登陆有礼
        self:activityEmblemLogin(125)
    end

	--分享 ，邀请活动
	if __lua_project_id == __lua_project_yugioh then 
		--self:activityInviteFriend()
		self:activityFaceBookShare()
	end

	for i,v in ipairs(self.pageKeys) do
		if v ~= nil then
			self.Panel_page_act:addChild(v.page)
			-- self.PageViewAty:addPage(v.page)
		end
	end
end

function ActivityWindow:onEnterTransitionFinish()
	self:onInit()
end


function ActivityWindow:checkupReplyPhysical()
	-- 检查当前时间 ,吃烧鸡--------------------------------------------------------------------------
	local n = _ED.system_time + (os.time() - _ED.native_time)
	local hour = tonumber(os.date("%H", getBaseGTM8Time(n)))+1 -- 0~23
	--150	吃烧鸡时间	150	12:00:00-14:00:00,18:00:00-20:00:00
	if nil == _ED._dinner_init_time_list then
		local config = zstring.split(dms.string(dms["pirates_config"], 150, pirates_config.param), ",")
		local timeList = {}
		for i,v in ipairs(config) do
			local t = zstring.split(v, "-")
			for i,h in ipairs(t) do
				local z = zstring.split(h, ":")
				table.insert(timeList, tonumber(z[1]))
			end
		end
		-- 记下可以吃的时间段
		_ED._dinner_init_time_list = timeList
	end
	
	local function checkup(_hour, minz, maxz)
		if _hour > minz-1 and _hour < maxz+1 then
			return true
		end
		return false
	end
	
	if nil == tonumber(_ED._dinner_init_hour) then
		_ED._dinner_init_hour = -1
	end
	
	for i = 1 , #_ED._dinner_init_time_list do
		if 0 == (i-1)%2 then 
			if true == checkup(hour, _ED._dinner_init_time_list[i], _ED._dinner_init_time_list[i+1]) and
				false == checkup(_ED._dinner_init_hour, _ED._dinner_init_time_list[i], _ED._dinner_init_time_list[i+1])  then
				
					_ED._dinner_init_hour = hour
					NetworkManager:register(protocol_command.dinner_init.code, nil, nil, nil, nil, function ()
						-- 检查处理
					end, false, nil)
				break
			end
		end
	end
	---end---------------------------------------------------------------------------------------------------
end

function ActivityWindow:init()
	return self
end

function ActivityWindow:onInit()
	if self.roots[1] ~= nil then
		return
	end

    local csbActivityWindow = csb.createNode("activity/wonderful/wonderful.csb")
    local root = csbActivityWindow:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbActivityWindow)
    --push_notification_center_activity_all_push_state[""..121] = false
    --getRechargeForTimeLimitBadgeActivityTips(121) = true
	if isUseNewActivityMode == true then
		self.Panel_page_act = ccui.Helper:seekWidgetByName(root, "Panel_page_act")
	end
	self.PageViewAty = ccui.Helper:seekWidgetByName(root, "PageView_wdf_1")
	self.listView = ccui.Helper:seekWidgetByName(root, "ListView_wonder_btn")
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		then
		self:onUpdateDrawNew()
	else
		self:onUpdateDraw()
	end
	self:initActivityWindowPageView()
	if isUseNewActivityMode == true then
		local add_page = nil
		for i,v in ipairs(self.pageKeys) do
			if v ~= nil then
				if v.key == "DailySignIn" then
					add_page = v.page
					break
				end
			end
		end
		-- self.Panel_page_act:addChild(add_page)
		state_machine.excute("activity_copy_title_cell", 0, {self.listView:getItems()[self.currentIndex],self.currentIndex,self.listView})
	end
	--顶部用户信息
	local userinfo = UserInformationHeroStorage:new()
	userinfo.__cname = "UserInformationHeroStorageClassA"
	fwin:open(userinfo,fwin._view)
	self.userInfo = userinfo

    self.PageViewAty:scrollToPage(0)
	-- state_machine.excute("activity_window_lazy", 0, pageView:getPage(pageView:getCurPageIndex()))
	
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		then
		local closeWindow = ccui.Helper:seekWidgetByName(root, "Button_wonderful_back")
		if closeWindow ~= nil then
			fwin:addTouchEventListener(closeWindow, nil, 
			{
				terminal_name = "activity_window_close", 
				isPressedActionEnabled = true
			},
			nil,0)
		end
	else
		self.PageViewAty:setBackGroundImage("images/ui/bg/bg_cangku_1.png")
	end

	if isUseNewActivityMode == true then
		self.PageViewAty:setTouchEnabled(false)
		self:sortListItem("first")
	end

    -- local Panel_effec = ccui.Helper:seekWidgetByName(root, "Panel_effec")
    -- if Panel_effec ~= nil then
    --     Panel_effec:removeAllChildren(true)
    --     local jsonFile = "images/ui/effice/effect_chixu/effect_chixu.json"
    --     local atlasFile = "images/ui/effice/effect_chixu/effect_chixu.atlas"
    --     local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    --     animation2:setPosition(cc.p(Panel_effec:getContentSize().width/2,0))
    --     Panel_effec:addChild(animation2)
    -- end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        local Panel_effec = ccui.Helper:seekWidgetByName(root, "Panel_effec")
        if Panel_effec ~= nil then
            Panel_effec:removeAllChildren(true)
            local jsonFile = "images/ui/effice/effice_hdbg/effice_hdbg.json"
            local atlasFile = "images/ui/effice/effice_hdbg/effice_hdbg.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            Panel_effec:addChild(animation)
        end
    end
end

function ActivityWindow:close()
    local Panel_effec = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_effec")
    if Panel_effec ~= nil then
        Panel_effec:removeAllChildren(true)
    end
end

function ActivityWindow:onExit()
	state_machine.unlock("activity_window_open", 0, "")
	state_machine.remove("activity_window_refresh_button")
	state_machine.remove("activity_window_change_to_page")
	state_machine.remove("activity_window_lazy")
	state_machine.remove("activity_window_unload")
	state_machine.remove("activity_window_remove_activity_page")
    state_machine.remove("activity_window_check_activity_info")
    state_machine.remove("activity_window_update_activity_page")
    state_machine.remove("activity_window_update_activity_info_by_type")
	cc.Director:getInstance():getTextureCache():unbindAllImageAsync()
end

function ActivityWindow:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end