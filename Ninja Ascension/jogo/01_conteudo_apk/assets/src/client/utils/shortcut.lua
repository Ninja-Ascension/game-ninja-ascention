-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中界面跳转的快捷方式
-- -----------------------------------------------------------------------------------------------------
shortcut = shortcut or {}

-- 退回时的场景名
shortcut.shortcut_function_back_scene = nil
shortcut.shortcut_function_back_scene_enum = {
	EquipPatchListView = "EquipPatchListView",
	HeroPatchListView = "HeroPatchListView",
	Home = "Home",
	ActivityDailySignIn = "ActivityDailySignIn",
	AccumlateConsumption = "AccumlateConsumption",
	AccumlateRechargeable = "AccumlateRechargeable",
	FirstRecharge = "FirstRecharge",

}

-- 打开账号在别处登录的提示对话框
local shortcut_open_function_login_of_other_terminal = {
    _name = "shortcut_open_function_login_of_other",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
            or __lua_project_id == __lua_project_l_naruto
            then
            app.load("client.utils.OtherAccountLogin")
            state_machine.excute("other_account_login_window_open", 0, nil)
        else
    		app.load("client.utils.LoginOfOtherTip")
            fwin:open(LoginOfOtherTip:new():init(), fwin._system)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


-- 打开普通的功能提示对话框
local shortcut_open_function_dailog_cancel_and_ok_terminal = {
    _name = "shortcut_open_function_dailog_cancel_and_ok",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		app.load("client.utils.ConfirmTip")
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
            or __lua_project_id == __lua_project_red_alert 
            or __lua_project_id == __lua_project_red_alert_time 
	    or __lua_project_id == __lua_project_pacific_rim
            then
			if fwin:find("ConfirmTipClass") ~= nil then
				fwin:close(fwin:find("ConfirmTipClass"))
			end
		end
        fwin:open(ConfirmTip:new():init(nil, nil, "", params), fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 进入副本页面
local shortcut_open_duplicate_window_terminal = {
    _name = "shortcut_open_duplicate_window",
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
            or __lua_project_id == __lua_project_red_alert_time 
	    or __lua_project_id == __lua_project_pacific_rim
            then
		else
			app.load("client.duplicate.DuplicateController")
			if fwin:find("DuplicateControllerClass") == nil then
				if nil ~= params and type(params) == "table" then
					fwin:open(DuplicateController:new():init(params[1], params[2], params[3]), fwin._view)
				else
					fwin:open(DuplicateController:new():init(), fwin._view)
				end
			end
			if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				local duplicate_manager = state_machine.find("duplicate_controller_manager")
				if duplicate_manager ~= nil then 
					duplicate_manager.last_terminal_name = ""
				end
				state_machine.excute("duplicate_controller_manager", 0, 
					{
						_datas = {
							terminal_name = "duplicate_controller_manager",     
							next_terminal_name = "duplicate_controller_copy_page",       
							current_button_name = "Button_ptfb_2",    
							but_image = "Image_copy",       
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
			else
				state_machine.excute("duplicate_controller_manager", 0, 
					{
						_datas = {
							terminal_name = "duplicate_controller_manager",     
							next_terminal_name = "duplicate_controller_copy_page",       
							current_button_name = "Button_putong",    
							but_image = "Image_copy",       
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
			end
			
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}



-- 进入名将副本页面  
local shortcut_open_duplicate_hight_copy_window_terminal = {
    _name = "shortcut_open_duplicate_hight_copy_window",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
	
		app.load("client.duplicate.DuplicateController")
		if fwin:find("DuplicateControllerClass") == nil then
			if nil ~= params and type(params) == "table" then
				fwin:open(DuplicateController:new():init(params[1], params[2], params[3]), fwin._view)
			else
				fwin:open(DuplicateController:new():init(), fwin._view)
			end
		end
		
		state_machine.excute("duplicate_controller_manager", 0, 
			{
				_datas = {
					terminal_name = "duplicate_controller_manager",     
					next_terminal_name = "duplicate_select_hight_copy_panel",       
					current_button_name = "Button_mingjiang_4",    
					but_image = "Image_hight_copy",       
					terminal_state = 0, 
					isPressedActionEnabled = true
				}
			}
		)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 进入精英副本界面
local shortcut_open_elite_duplicate_window_terminal = {
    _name = "shortcut_open_elite_duplicate_window",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
            or __lua_project_id == __lua_project_red_alert 
            or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
            then
			return true
		end
		app.load("client.duplicate.DuplicateController")
		if fwin:find("DuplicateControllerClass") == nil then
			if nil ~= params and type(params) == "table" then
				fwin:open(DuplicateController:new():init(params[1], params[2], params[3]), fwin._view)
			else
				fwin:open(DuplicateController:new():init(), fwin._view)
			end
		end
			local duplicate_manager = state_machine.find("duplicate_controller_manager")
			if duplicate_manager ~= nil then 
				duplicate_manager.last_terminal_name = ""
			end
			state_machine.excute("duplicate_controller_manager", 0, 
				{
					_datas = {
						terminal_name = "duplicate_controller_manager",     
						next_terminal_name = "duplicate_controller_elite_copy_page",       
						current_button_name = "Button_jingyingbt",    
						but_image = "Image_copy",       
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
		
	
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
-- VIP等级不足的跳转提示界面
local shortcut_open_recharge_tip_dialog_terminal = {
    _name = "shortcut_open_recharge_tip_dialog",
    _init = function (terminal) 
        app.load("client.utils.RechargeTipDialog")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(RechargeTipDialog:new():init(params[1], params[2], params[3], params[4]), fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 进入充值界面
local shortcut_open_recharge_window_terminal = {
    _name = "shortcut_open_recharge_window",
    _init = function (terminal) 
        app.load("client.shop.recharge.RechargeDialog")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if __lua_project_id == __lua_project_red_alert 
            or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
            then
            if funOpenDrawTip(60) == true then
                return
            end
        end
        if params ~= nil and type(params) == "table" then
            local status = params.status
            if status ~= nil and status ~= 1 then
                return
            end
        end
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            or __lua_project_id == __lua_project_l_naruto 
            then
            if funOpenDrawTip(181) == true then
                return
            end
            if fwin:find("RechargeDialogClass") ~= nil and fwin:find("SmVipPrivilegeDialogClass") ~= nil then
                state_machine.excute("sm_vip_prilige_show_recharge",0,"")
            else
                local rechargeDialogWindow = RechargeDialog:new()
                fwin:open(rechargeDialogWindow, fwin._windows)
            end
        else
            local rechargeDialogWindow = RechargeDialog:new()
            -- if type(params) == "table" then
            --     rechargeDialogWindow:init(params[1], params[2])
            -- end
            fwin:open(rechargeDialogWindow, fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 进入VIP特权界面
local shortcut_open_vip_privilege_window_terminal = {
    _name = "shortcut_open_vip_privilege_window",
    _init = function (terminal) 
        app.load("client.shop.recharge.VipPrivilegeDialog")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local vipPrivilegeDialogWindow = VipPrivilegeDialog:new()
        fwin:open(vipPrivilegeDialogWindow, fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 查看奖励物品的信息
local shortcut_open_show_reward_item_info_terminal = {
    _name = "shortcut_open_show_reward_item_info",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        app.load("client.cells.equip.equip_icon_cell")
        app.load("client.cells.prop.prop_icon_cell")
        app.load("client.cells.utils.resources_icon_cell")
        app.load("client.cells.prop.prop_money_icon")
        app.load("client.cells.prop.prop_money_info")
		app.load("client.cells.prop.prop_information")
        app.load("client.packs.equipment.EquipFragmentInfomation")
        local v = params._datas.reward

        if __lua_project_id == __lua_project_gragon_tiger_gate
            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then
        	local from_icon_type = params._datas.from_icon_type
        	if from_icon_type == "red_alert" then
        		local cell = params._datas.cell
        		local mould_id = cell.prop_id
        		local proptype = cell.prop_type
        		v = 
        		{
        			proptype,
        			mould_id
        		}
        	end
        end

        local rewardType = zstring.tonumber(v[1])
        if rewardType == 6 then
            local cell = propInformation:new()
            cell:init(cell:constructionPropTemplate(v[2]),1)
            fwin:open(cell, fwin._ui)
        elseif rewardType == 7 then
            local FragmentInformation = EquipFragmentInfomation:new()
            if __lua_project_id == __lua_project_gragon_tiger_gate 
	    	or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim
                then
            	FragmentInformation:init(v[2],nil,2)
            else
            	FragmentInformation:init(v[2])
            end
            fwin:open(FragmentInformation, fwin._view)
        else
            local cell = propMoneyInfo:new()
            cell:init(""..rewardType)
            fwin:open(cell, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 返回
local shortcut_function_back_terminal = {
    _name = "shortcut_function_back",
    _init = function (terminal) 

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		
		if shortcut.shortcut_function_back_scene == nil then
			-- 为nil 直接退出
			return true
		elseif shortcut.shortcut_function_back_scene == shortcut.shortcut_function_back_scene_enum.EquipPatchListView then
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim
                then
				app.load("client.packs.prop.PropStorage")
				fwin:open(PropStorage:new(), fwin._background)
				state_machine.excute("prop_storage_manager",0,
					{
					_datas = {
								terminal_name = "prop_storage_manager", 	
								next_terminal_name = "prop_equip_show_list", 			
								current_button_name = "Button_zhuangbei",
								but_image = "",         
								terminal_state = 0, 
								isPressedActionEnabled = false								
							 }
					}
				)
			else
				app.load("client.packs.equipment.EquipStorage")
				fwin:open(EquipStorage:new(), fwin._view)
				state_machine.excute("equip_storage_show_equip_storage_patch", 0, "")
			end
		elseif shortcut.shortcut_function_back_scene == shortcut.shortcut_function_back_scene_enum.HeroPatchListView then
			app.load("client.packs.hero.HeroStorage")
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                		or __lua_project_id == __lua_project_red_alert 
                		or __lua_project_id == __lua_project_red_alert_time 
				or __lua_project_id == __lua_project_pacific_rim
                then
				if fwin:find("HeroStorageClass") ~= nil then
					fwin:close(fwin:find("HeroStorageClass"))
				end
			end			
			fwin:open(HeroStorage:new(), fwin._view)
			state_machine.excute("hero_storage_show_hero_storage_patch", 0, "")
		elseif shortcut.shortcut_function_back_scene == shortcut.shortcut_function_back_scene_enum.Home then
			state_machine.excute("menu_show_home_page", 0, "")
		elseif shortcut.shortcut_function_back_scene == shortcut.shortcut_function_back_scene_enum.ActivityDailySignIn then
			-- state_machine.excute("menu_clean_page_state", 0, "home")
			-- fwin:open(ActivityWindow:new(), fwin._view) 
			-- state_machine.excute("activity_window_change_to_page", 0, "DailySignIn")
			state_machine.excute("activity_window_open", 0, {nil, "DailySignIn"})
		elseif shortcut.shortcut_function_back_scene == shortcut.shortcut_function_back_scene_enum.AccumlateConsumption then
			-- state_machine.excute("menu_clean_page_state", 0, "home")
			-- fwin:open(ActivityWindow:new(), fwin._view) 
			-- state_machine.excute("activity_window_change_to_page", 0, "AccumlateConsumption")
			state_machine.excute("activity_window_open", 0, {nil, "AccumlateConsumption"})
		elseif shortcut.shortcut_function_back_scene == shortcut.shortcut_function_back_scene_enum.AccumlateRechargeable then
			-- state_machine.excute("menu_clean_page_state", 0, "home")
			-- fwin:open(ActivityWindow:new(), fwin._view) 
			-- state_machine.excute("activity_window_change_to_page", 0, "AccumlateRechargeable")
			state_machine.excute("activity_window_open", 0, {nil, "AccumlateRechargeable"})
		elseif shortcut.shortcut_function_back_scene == shortcut.shortcut_function_back_scene_enum.FirstRecharge then
			-- state_machine.excute("menu_clean_page_state", 0, "home")
			-- fwin:open(ActivityWindow:new(), fwin._view) 
			-- state_machine.excute("activity_window_change_to_page", 0, "FirstRecharge")
			state_machine.excute("activity_window_open", 0, {nil, "FirstRecharge"})
		elseif shortcut.shortcut_function_back_scene == shortcut.shortcut_function_back_scene_enum.Home then
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time 
		or __lua_project_id == __lua_project_pacific_rim
                or __lua_project_id == __lua_project_legendary_game 
                then
				fwin:cleanViews({
					fwin._background,
					fwin._view,
					fwin._viewdialog,
					fwin._taskbar,
					fwin._ui,
					fwin._windows,
					fwin._dialog
					})
				fwin:__show(fwin._frameview)
			else
			end
		end
		
		-- 打开完毕之后,清除记录
		shortcut.shortcut_function_back_scene = nil
		
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
	
-- 记录跳转来源
local shortcut_function_goto_log_terminal = {
    _name = "shortcut_function_goto_log",
    _init = function (terminal) 
	
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		shortcut.shortcut_function_back_scene = params
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


-- 追踪
local shortcut_function_trace_terminal = {
    _name = "shortcut_function_trace",
    _init = function (terminal) 
        -- 0：武将仓库		功能点1
        -- 1：装备仓库		功能点7
        -- 2：宝物仓库		功能点8
        -- 3：包裹			功能点1
        -- 4：三国志		功能点9
        -- 5：回收			功能点10
        -- 6：活动			功能点1
        -- 7：神将商店		功能点41
        -- 8：名人堂		功能点39
        -- 9：觉醒商店		功能点6
        -- 10：阵容			功能点1
        -- 11：副本			功能点43
        -- 12：名将副本		功能点18
        -- 13：日常副本		功能点19
        -- 14：精英副本		功能点26
        -- 15：征战			功能点1
        -- 16：竞技场		功能点16
        -- 17：夺宝			功能点15
        -- 18：三国无双		功能点14
        -- 19：领地攻讨		功能点13
        -- 20：围剿叛军		功能点12
        -- 21：商城招贤		功能点44
        -- 21：商城道具		功能点42
        -- 21：商城礼包		功能点42
        -- 22：战将招募		功能点45
        -- 23：神将招募		功能点44
        -- 24：军团			功能点11
        -- 25：军团商店		功能点11
        -- 26：好友			功能点47
        -- 27：VIP特权		功能点50
		-- 28：竞技场商店	
		-- 29：三国无双商店	功能点14
		-- 30：围剿叛军商店	
		-- 31：商城道具	
		-- 32：商城礼包	
        -- 37: 宠物商店	
        -- 38: 皇骑战场宠物副本 
        -- 30: 宠物列表
        -- 40  探索商店
        -- 41  冒险-活动关卡
        -- 42  主页-购买金币
        -- 43  主页-购买体力
        -- 44  数码兽-强化-升级
        -- 45  数码兽-强化-进阶
        -- 46  数码兽-强化-技能
        -- 47  公会战
        -- 48  跨服王者之战
        -- 49  王者之战
        -- 60  月卡
        -- 97  当前主线最高进度
        -- 98  当前精英最高进度
        -- 99  读取文字内容
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local arpview = fwin:find("ActivityFirstRechargePopupClass")
		if arpview ~= nil then
			fwin:close(arpview)
		end
        local functionParmaMouldId = params.trace_function_id
        params = params._datas
        local traceId = nil
        local nextId = nil
        if not functionParmaMouldId and params.traceId then
            traceId = params.traceId
        else
            traceId = dms.int(dms["function_param"], functionParmaMouldId, function_param.genre)
            nextId = dms.int(dms["function_param"], functionParmaMouldId, function_param.open_function)
            if nextId > 0 and funOpenDrawTip(nextId) == true then
                return 
            end
        end
        local npcRequirement = false
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            npcRequirement = traceId == -2--待修改-添加新类型跳转npc挑战界面
        else
            npcRequirement = traceId < 0
        end
		if npcRequirement then			--跳转到关卡
			local hview = fwin:find("HeroStorageClass")
			if hview ~= nil then
				if __lua_project_id == __lua_project_gragon_tiger_gate 
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                    or __lua_project_id == __lua_project_red_alert 
                    or __lua_project_id == __lua_project_red_alert_time 
                    or __lua_project_id == __lua_project_pacific_rim
                    then
				else
					fwin:close(hview)
				end
			end
		
			app.load("client.duplicate.DuplicateController")
			local openScene = dms.int(dms["function_param"], functionParmaMouldId, function_param.open_scene)
			local openNpc = dms.int(dms["function_param"], functionParmaMouldId, function_param.open_npc)
			local _scene_type = zstring.split(dms.string(dms["pve_scene"], openScene, pve_scene.npcs),",")
			local num = nil
			for i,v in pairs(_scene_type) do
				if tonumber(v) == tonumber(openNpc) then
					num = i
				end
			end
			
			_ED._current_scene_id = openScene
			
			_ED._current_seat_index = num
			_ED._last_page_type = 1
			
			_ED._duplicate_is_show_guide = true
			
			--print("openScene,openNpc,_scene_type",openScene,openNpc,_scene_type)
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time 
                or __lua_project_id == __lua_project_pacific_rim
                then
					fwin:cleanView(fwin._view)
					fwin:cleanView(fwin._ui)
					fwin:cleanView(fwin._windows)
					local scene_type = dms.int(dms["pve_scene"], openScene, pve_scene.scene_type)
					local pageType = 1
					if scene_type == 0 then 
						pageType = 1 
					elseif scene_type == 1 then 
						pageType = 2 
					end

				    state_machine.excute("lduplicate_window_pve_quick_entrance", 0, 
                    {
                        _type = pageType, 
                        _sceneId = openScene,
                        _npcid = openNpc
                    })
			else
                local scene_type = dms.int(dms["pve_scene"], openScene, pve_scene.scene_type)
                if scene_type == 0 then 
                   --主线副本
                    state_machine.excute("menu_manager", 0, 
                    {
                        _datas = {
                            terminal_name = "menu_manager",     
                            next_terminal_name = "menu_show_duplicate",     
                            current_button_name = "Button_duplicate",   
                            but_image = "Image_duplicate",  
                            terminal_state = 0, 
                            isPressedActionEnabled = true
                        }
                    })
                    
                elseif scene_type == 1 then 
                    --精英副本
                    state_machine.excute("menu_manager", 0, 
                    {
                        _datas = {
                            terminal_name = "menu_manager",     
                            next_terminal_name = "menu_show_duplicate_abyss",     
                            current_button_name = "Button_duplicate",   
                            but_image = "Image_duplicate",  
                            terminal_state = 0, 
                            isPressedActionEnabled = true
                        }
                    })
                end
			end
        elseif traceId == 0 then
			state_machine.excute("menu_clean_page_state", 0,"") 
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                then
				if fwin:find("HeroStorageClass") ~= nil then
					fwin:close(fwin:find("HeroStorageClass"))
				end
			end
			fwin:open(HeroStorage:new(), fwin._view) 
			state_machine.excute("hero_storage_manager", 0, 
				{
					_datas = {
						terminal_name = "hero_storage_manager",     
						next_terminal_name = "hero_storage_show_hero_storage_list", 
						current_button_name = "Button_equipment",   
						but_image = "",     
						terminal_state = 0, 
						isPressedActionEnabled = false
					}
				}
			)
        elseif traceId == 1 then      
			state_machine.excute("menu_clean_page_state", 0,"") 
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                then
				app.load("client.packs.prop.PropStorage")
				fwin:open(PropStorage:new(), fwin._background)
				state_machine.excute("prop_storage_manager",0,
					{
					_datas = {
								terminal_name = "prop_storage_manager", 	
								next_terminal_name = "prop_equip_show_list", 			
								current_button_name = "Button_zhuangbei",
								but_image = "",         
								terminal_state = 0, 
								isPressedActionEnabled = false								
							 }
					}
				)
			else
				fwin:open(EquipStorage:new(), fwin._view)
			end
        elseif traceId == 2 then
			state_machine.excute("menu_clean_page_state", 0,"")
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                then
				app.load("client.packs.prop.PropStorage")
				fwin:open(PropStorage:new(), fwin._background)
				state_machine.excute("prop_storage_manager",0,
					{
					_datas = {
								terminal_name = "prop_storage_manager", 	
								next_terminal_name = "prop_treasure_show_list", 			
								current_button_name = "Button_xinfa",
								but_image = "",         
								terminal_state = 0, 
								isPressedActionEnabled = false
						     }
					}
				)
			else 
				fwin:open(TreasureStorage:new(), fwin._view) 
			end
        elseif traceId == 3 then
			state_machine.excute("menu_clean_page_state", 0,"") 
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                then
				fwin:open(PropStorage:new(), fwin._background)
			else
				fwin:open(PropStorage:new(), fwin._view)
			end
			state_machine.excute("prop_storage_manager", 0, 
				{
					_datas = {
						terminal_name = "Button_daoju",     
						next_terminal_name = "prop_storage_chick_prop_storages",            
						current_button_name = "Button_daoju",       
						but_image = "",         
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
        elseif traceId == 4 then
			app.load("client.destiny.DestinySystem")
			state_machine.excute("home_goto_destiny_system", 0, {_datas = {
				next_terminal_name = "menu_change_button_state",
				next_params = {
					_datas = {
						buttonName = "Button_home"
					}
				}
			}})
        elseif traceId == 5 then
			state_machine.excute("menu_clean_page_state", 0,"") 
			fwin:open(RefiningFurnace:new(), fwin._view)
			state_machine.excute("refining_furnace_manager", 0, 
				{
					_datas = {
						terminal_name = "refining_furnace_manager",     
						next_terminal_name = "refining_furnace_show_hero_resolve_view", 
						current_button_name = "Button_wjfj",    
						but_image = "",     
						terminal_state = 0, 
						isPressedActionEnabled = false
					}
				}
			)
        elseif traceId == 6 then
			-- app.load("client.activity.ActivityWindow")
			-- state_machine.excute("menu_clean_page_state", 0,"") 
			-- fwin:open(ActivityWindow:new(), fwin._view) 
			state_machine.excute("activity_window_open", 0, {"client.activity.ActivityWindow", nil})
        elseif traceId == 7 then
			
			
			if nextId == 41 then
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                    or __lua_project_id == __lua_project_red_alert 
                    or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                    then
					local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							state_machine.excute("menu_clean_page_state", 0,"") 
							app.load("client.shop.hero.HeroShop")
							fwin:open(HeroShop:new(), fwin._view)
							fwin:close(fwin:find("HeroDevelopClass"))					
						end
					end
					NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
				else
					state_machine.excute("menu_clean_page_state", 0,"") 
					fwin:close(fwin:find("HeroRecruitPreviewClass"))
					app.load("client.shop.hero.HeroShop")
					fwin:open(HeroShop:new(), fwin._view)
					fwin:close(fwin:find("HeroDevelopClass"))
				end
			elseif nextId == 14 then
				app.load("client.campaign.trialtower.TrialTower")
				app.load("client.campaign.trialtower.TrialTowerShop")
				local function responseKingdomsCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							local function responsePropCompoundCallback(response)
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									state_machine.excute("equip_fragment_acquire_get_close", 0, {_datas = {_id = functionParmaMouldId}})
									
									state_machine.excute("menu_clean_page_state", 0,"") 
									
									fwin:open(TrialTower:new(), fwin._view)
									if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                                        or __lua_project_id == __lua_project_red_alert 
                                        or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                                        then
										fwin:open(TrialTowerShop:new(), fwin._windows)
									else	
										fwin:close(fwin:find("TrialTowerShopClass"))
										fwin:open(TrialTowerShop:new(), fwin._viewdialog)
									end
								end
							end
							NetworkManager:register(protocol_command.dignified_shop_init.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
						else
						end
					end
				NetworkManager:register(protocol_command.three_kingdoms_init.code, nil, nil, nil, nil, responseKingdomsCallback, false, nil)
			end
        elseif traceId == 8 then	--名人堂
			app.load("client.home.fame.FameHall")
			state_machine.excute("menu_clean_page_state", 0,"") 
			fwin:open(FameHall:new(), fwin._view) 
			
        elseif traceId == 9 then
        	if __lua_project_id == __lua_project_digimon_adventure 
		          or __lua_project_id == __lua_project_naruto 
                or __lua_project_id == __lua_project_pokemon 
                or __lua_project_id == __lua_project_rouge 
                or __lua_project_id == __lua_project_gragon_tiger_gate 
        		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_warship_girl_b
                or __lua_project_id == __lua_project_yugioh 
                then 
                local openLevel = dms.int(dms["fun_open_condition"], 5, fun_open_condition.level)
                local userlevel = tonumber(_ED.user_info.user_grade)
                if userlevel >= openLevel then 
                    app.load("client.packs.hero.HeroAwakenShop")
                    local shop = HeroAwakenShop:new()
                    shop:init(1)
                    fwin:open(shop, fwin._viewdialog)  
                else
                    TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 5, fun_open_condition.tip_info))
                end
        	else
            	TipDlg.drawTextDailog(_function_unopened_tip_string)
            end
        elseif traceId == 10 then
			-- app.load("client.formation.Formation")
			-- local formation = Formation:new()
			-- for i = 2, 7 do
				-- local shipId = _ED.formetion[i]
				-- if tonumber(shipId) > 0 then
					-- local isleadtype = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.captain_type)
					-- if tonumber(isleadtype) == 0 then
						-- formation:init(_ED.user_ship[_ED.formetion[i]])
					-- end
				-- end
			-- end
			-- fwin:open(formation, fwin._view) 
			app.load("client.home.Menu")
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end
			state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager", 	
						next_terminal_name = "menu_show_formation", 	
						current_button_name = "Button_line-uo", 	
						but_image = "Image_line-uo", 	
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
        elseif traceId == 11 then
            -- fwin:open(DuplicateController:new(), fwin._view)
            -- state_machine.excute("duplicate_page_controller_open", 0, 
            --  {
            --      _datas = {
            --          terminal_name = "duplicate_page_controller_open",   
            --          next_terminal_name = "duplicate_page_controller_open",        
            --          but_image = "Image_duplicate",       
            --          terminal_state = 0, 
            --          isPressedActionEnabled = true
            --      }
            --  }
            -- )
			app.load("client.home.Menu")
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end
			state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager", 	
						next_terminal_name = "menu_show_duplicate",  	
						current_button_name = "Button_duplicate", 	
						but_image = "Image_duplicate", 	
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
			state_machine.excute("shortcut_open_duplicate_window", 0, params) 
        elseif traceId == 12 then
			app.load("client.home.Menu")
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end
			state_machine.excute("menu_manager", 0, 
                    {
                        _datas = {
							terminal_name = "menu_manager",     
							next_terminal_name = "menu_show_duplicate_hero",     
							current_button_name = "Button_mingjiang",            
							but_image = "Image_hight_copy",       
							terminal_state = 0, 
							isPressedActionEnabled = true
                        }
                    }
                )
			state_machine.unlock("menu_manager_change_to_page", 0, "")
			state_machine.excute("pve_daily_activity_copy_change_to_page", 0, 0)
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                then
				state_machine.excute("general_copy",0,"")
			end
        elseif traceId == 13 then
        		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                    or __lua_project_id == __lua_project_red_alert 
                    or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                    then
        		else
					fwin:removeAll()
				end
				app.load("client.home.Menu")
				if fwin:find("MenuClass") == nil then
					fwin:open(Menu:new(), fwin._taskbar)
				end
				-- state_machine.excute("menu_clean_page_state", 0,"") 
				state_machine.excute("menu_manager", 0, 
					{
						_datas = {
							terminal_name = "menu_manager", 	
							next_terminal_name = "menu_show_duplicate_everyday", 
							current_button_name = "Button_duplicate",
							but_image = "Image_duplicate", 		
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
				state_machine.unlock("menu_manager_change_to_page", 0, "")
				state_machine.excute("pve_daily_activity_copy_change_to_page", 0, 0)
        elseif traceId == 14 then
        	if __lua_project_id == __lua_project_digimon_adventure 
                or __lua_project_id == __lua_project_naruto 
                or __lua_project_id == __lua_project_pokemon 
                or __lua_project_id == __lua_project_rouge 
                or __lua_project_id == __lua_project_warship_girl_b
                or __lua_project_id == __lua_project_yugioh 
                then 
        		app.load("client.home.Menu")
				if fwin:find("MenuClass") == nil then
					fwin:open(Menu:new(), fwin._taskbar)
				end
				state_machine.excute("menu_manager", 0, 
					{
						_datas = {
							terminal_name = "menu_manager", 	
							next_terminal_name = "menu_show_duplicate",  	
							current_button_name = "Button_duplicate", 	
							but_image = "Image_duplicate", 	
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
				state_machine.excute("shortcut_open_elite_duplicate_window", 0, params)
			elseif __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				then 
				app.load("client.home.Menu")
				if fwin:find("MenuClass") == nil then
					fwin:open(Menu:new(), fwin._taskbar)
				end
				state_machine.excute("menu_manager", 0, 
					{
						_datas = {
							terminal_name = "menu_manager", 	
							next_terminal_name = "menu_show_duplicate_abyss",  	
							current_button_name = "Button_duplicate", 	
							but_image = "Image_duplicate", 	
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
			else
				TipDlg.drawTextDailog(_function_unopened_tip_string)
        	end
            
        elseif traceId == 15 then
			-- app.load("client.campaign.Campaign")
			-- fwin:open(Campaign:new(), fwin._view)
			app.load("client.home.Menu")
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end
			state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager", 	
						next_terminal_name = "menu_show_campaign", 		
						current_button_name = "Button_activity", 		
						but_image = "Image_activity",	
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
        elseif traceId == 16 then
			app.load("client.home.Menu")
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end
			state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager", 	
						next_terminal_name = "menu_show_campaign", 		
						current_button_name = "Button_activity", 		
						but_image = "Image_activity",	
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
			fwin:open(Arena:new(), fwin._view) 
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
			-- fwin:close(fwin:find("CampaignClass"))
        elseif traceId == 17 then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                then
				if fwin:find("PlunderClass") ~= nil then
					return
				end
			end        	
			app.load("client.home.Menu")
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end
			state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager", 	
						next_terminal_name = "menu_show_campaign", 		
						current_button_name = "Button_activity", 		
						but_image = "Image_activity",	
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
			fwin:open(Plunder:new(), fwin._view)    
			-- fwin:close(fwin:find("CampaignClass"))
        elseif traceId == 18 then
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end
			state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager", 	
						next_terminal_name = "menu_show_campaign", 		
						current_button_name = "Button_activity", 		
						but_image = "Image_activity",	
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
			local function responseKingdomsCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					state_machine.excute("equip_fragment_acquire_get_close", 0, {_datas = {_id = functionParmaMouldId}})
					fwin:open(TrialTower:new(), fwin._view)
					fwin:close(fwin:find("CampaignClass"))
				end
			end
			NetworkManager:register(protocol_command.three_kingdoms_init.code, nil, nil, nil, nil, responseKingdomsCallback, false, nil)
        elseif traceId == 19 then
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end
			state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager", 	
						next_terminal_name = "menu_show_campaign", 		
						current_button_name = "Button_activity", 		
						but_image = "Image_activity",	
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
            state_machine.excute("menu_clean_page_state", 0,"") 
			fwin:open(MineManager:new(), fwin._view)    
			fwin:close(fwin:find("CampaignClass"))
        elseif traceId == 20 then
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end
			state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager", 	
						next_terminal_name = "menu_show_campaign", 		
						current_button_name = "Button_activity", 		
						but_image = "Image_activity",	
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
			local function recruitCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					fwin:open(WorldBoss:new(), fwin._view)  
					fwin:close(fwin:find("CampaignClass"))
				end
			end
			NetworkManager:register(protocol_command.rebel_army_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
        elseif traceId == 21 then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                then
				state_machine.excute("shortcut_open_recharge_window", 0, "shortcut_open_recharge_window")
			else
				if fwin:find("MenuClass") == nil then
					fwin:open(Menu:new(), fwin._taskbar)
				end
				state_machine.excute("menu_manager", 0, 
					{
						_datas = {
							terminal_name = "menu_manager", 	
							next_terminal_name = "menu_show_shop", 			
							current_button_name = "Button_shop", 		
							but_image = "Image_shop", 		
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
			end
				
        elseif traceId == 22 then
        	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                then
        		state_machine.excute("lduplicate_window_return",0,"")
        		if fwin:find("HeroRecruitSuccessClass") ~= nil then
        			fwin:close(fwin:find("HeroRecruitSuccessClass"))
        			state_machine.excute("hero_recruit_shop_twopage_open",0,"")
        			state_machine.excute("hero_recruit_shop_twopage_show",0,"")
        			return
        		end
        	end
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end

            local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.NewRecruit)

			if fun_is_open == false then
					state_machine.excute("menu_manager", 0, 
					{
						_datas = {
							terminal_name = "menu_manager", 	
							next_terminal_name = "menu_show_shop", 			
							current_button_name = "Button_shop", 		
							but_image = "Image_shop", 
							shop_type = "zhaomu",		
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
            elseif fun_is_open == true then
                state_machine.excute("home_new_recruit_main", 0, nil)
			else
				state_machine.excute("menu_manager", 0, 
					{
						_datas = {
							terminal_name = "menu_manager", 	
							next_terminal_name = "menu_show_shop", 			
							current_button_name = "Button_shop", 		
							but_image = "Image_shop", 		
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
				state_machine.excute("shop_manager", 0, 
					{
						_datas = {
							terminal_name = "shop_manager",     
							next_terminal_name = "shop_ship_recruit",
							current_button_name = "Button_tavern",  
							but_image = "recruit",      
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
				fwin:close(fwin:find("HeroRecruitGeneralViewClass"))
				fwin:close(fwin:find("HeroRecruitPreviewClass"))
				local heroRecruitGeneralViewWindow = HeroRecruitGeneralView:new()
				heroRecruitGeneralViewWindow:init(1, 1)
				fwin:open(heroRecruitGeneralViewWindow,fwin._ui)
			end
        elseif traceId == 23 then
        	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                then
				state_machine.excute("lduplicate_window_return",0,"")        		
        		if fwin:find("HeroRecruitSuccessClass") ~= nil then
        			fwin:close(fwin:find("HeroRecruitSuccessClass"))
        			state_machine.excute("hero_recruit_shop_twopage_open",0,"")
        			state_machine.excute("hero_recruit_shop_twopage_show",0,"")
        			return
        		end
        	end
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end

			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                then
				state_machine.excute("menu_manager", 0, 
					{
						_datas = {
							terminal_name = "menu_manager", 	
							next_terminal_name = "menu_show_shop", 			
							current_button_name = "Button_shop", 		
							but_image = "Image_shop", 
							shop_type = "zhaomu",		
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
				-- state_machine.excute("shop_manager", 0, 
				-- 	{
				-- 		_datas = {
				-- 			terminal_name = "shop_manager",     
				-- 			next_terminal_name = "shop_ship_recruit",
				-- 			current_button_name = "Button_tavern",  
				-- 			but_image = "recruit", 
				-- 			shop_type = "zhaomu",     
				-- 			terminal_state = 0, 
				-- 			isPressedActionEnabled = true
				-- 		}
				-- 	}
				-- )
			else
				state_machine.excute("menu_clean_page_state", 0,"")
				state_machine.excute("menu_manager", 0, 
					{
						_datas = {
							terminal_name = "menu_manager", 	
							next_terminal_name = "menu_show_shop", 			
							current_button_name = "Button_shop", 		
							but_image = "Image_shop", 		
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
				state_machine.excute("shop_manager", 0, 
					{
						_datas = {
							terminal_name = "shop_manager",     
							next_terminal_name = "shop_ship_recruit",
							current_button_name = "Button_tavern",  
							but_image = "recruit",      
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
				fwin:close(fwin:find("HeroRecruitGeneralViewClass"))
				fwin:close(fwin:find("HeroRecruitPreviewClass"))
				local heroRecruitGeneralViewWindow = HeroRecruitGeneralView:new()
				heroRecruitGeneralViewWindow:init(2,1)
				fwin:open(heroRecruitGeneralViewWindow,fwin._ui)
			end
        --elseif traceId == 24 then
          --  TipDlg.drawTextDailog(_function_unopened_tip_string)
        elseif traceId == 24 then
            local isOpen_union  = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 11, fun_open_condition.level)
			if false == isOpen_union then
				TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 11, fun_open_condition.tip_info))
				return
			end
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end
			-- state_machine.excute("menu_clean_page_state", 0,"") 

			if _ED.union.union_info == nil or _ED.union.union_info == {}  or  _ED.union.union_info.union_id == nil or _ED.union.union_info.union_id == "" then
				local function responseUnionListCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- if response.node ~= nil and response.node.roots ~= nil then
							if zstring.tonumber(_ED.union.union_list_sum) == 0 then -- 第一个军团时
								state_machine.excute("home_manager", 0, {_datas={terminal_name = "home_manager", next_terminal_name = "home_click_union",but_image = "Image_home", terminal_state = 0,gotype=1 , isPressedActionEnabled = true}})
								 return true
							else
								state_machine.excute("home_manager", 0, {_datas={terminal_name = "home_manager", next_terminal_name = "home_click_union",but_image = "Image_home", terminal_state = 0,gotype=1 , isPressedActionEnabled = true}})
								 return true
							end	
						-- end
					end
				end	
				_ED.union.union_list_info = nil
				protocol_command.union_list.param_list = "0"
				NetworkManager:register(protocol_command.union_list.code, nil, nil, nil, self, responseUnionListCallback, false, nil)
				-- state_machine.excute("union_join_open", 0, response.node)
			else
				-- state_machine.excute("Union_open", 0, response.node)
				state_machine.excute("home_manager", 0, {_datas={terminal_name = "home_manager", next_terminal_name = "home_click_union",but_image = "Image_home", terminal_state = 0,gotype=2 , isPressedActionEnabled = true}})
            end

            if traceId == 25 then 
    			-- state_machine.excute("home_goto_click_union", 0, "")
                -- state_machine.excute("menu_show_shop", 0, {_datas = {shop_type = "shop", shop_page = 5}})
    			-- state_machine.excute("union_shop_open", 0, 
    			-- 		{
    			-- 			_datas = {
    			-- 				terminal_name = "union_shop_select_page", 	
    			-- 				next_terminal_name = "union_shop_to_fashion_page", 		
    			-- 				current_button_name = "Button_shizhuang", 		
    			-- 				but_image = "Image_shizhuang",	
    			-- 				terminal_state = 0, 
    			-- 				isPressedActionEnabled = true
    			-- 			}
    			-- 		}
    			-- 	)
            end
        elseif traceId == 25 then
            state_machine.excute("menu_show_shop", 0, {_datas = {shop_type = "shop", shop_page = 5}})
		elseif traceId == 26 then
            app.load("client.home.Menu")
            if fwin:find("MenuClass") == nil then
                fwin:open(Menu:new(), fwin._taskbar)
            end
            state_machine.excute("menu_clean_page_state", 0,"") 
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                then
                app.load("client.l_digital.friend.SmFriendWindow")
                state_machine.excute("sm_friend_window_open", 0, nil)
            else
                app.load("client.friend.FriendManager")
    			fwin:open(FriendManager:new(), fwin._view)
            end
		elseif traceId == 27 then
			app.load("client.shop.recharge.VipPrivilegeDialog")
			fwin:open(VipPrivilegeDialog:new(), fwin._windows)
		elseif traceId == 28 then
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                state_machine.excute("menu_show_shop", 0, {_datas = {shop_type = "shop", shop_page = 3}})
            else
    			state_machine.excute("menu_clean_page_state", 0,"")
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    app.load("client.l_digital.campaign.arena.Arena")
                else
                    app.load("client.campaign.arena.Arena")
                end
    			fwin:open(Arena:new(), fwin._view)
    			
    			app.load("client.campaign.arena.ArenaHonorShop")
    			fwin:open(ArenaHonorShop:new(), fwin._view)
            end
			fwin:close(fwin:find("HeroDevelopClass"))
		elseif traceId == 29 then
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                if funOpenDrawTip(118) == true then
                    return
                end
                app.load("client.l_digital.shop.SmShopPropBuyListView")
                state_machine.excute("menu_manager","0",{_datas = {
                    next_terminal_name = "menu_show_shop", 
                    current_button_name = "Button_shop_0",
                    but_image = "Image_shop",   
                    terminal_state = 0,
                    shop_type = "shop",
                    shop_page = 4,
                }}
                )
            else
    			app.load("client.campaign.trialtower.TrialTower")
    			app.load("client.campaign.trialtower.TrialTowerShop")
    			local function responseKingdomsCallback(response)
    					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    						local function responsePropCompoundCallback(response)
    							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    								state_machine.excute("equip_fragment_acquire_get_close", 0, {_datas = {_id = functionParmaMouldId}})
    								state_machine.excute("menu_clean_page_state", 0,"") 
    								fwin:open(TrialTower:new(), fwin._view)
    								fwin:open(TrialTowerShop:new(), fwin._view)
    							end
    						end
    						NetworkManager:register(protocol_command.dignified_shop_init.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
    					else
    					end
    				end
    			NetworkManager:register(protocol_command.three_kingdoms_init.code, nil, nil, nil, nil, responseKingdomsCallback, false, nil)
            end
		elseif traceId == 30 then
			
			app.load("client.campaign.worldboss.WorldBoss")
			app.load("client.campaign.worldboss.BetrayArmyShop")

			local function recruitCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					state_machine.excute("equip_fragment_acquire_get_close", 0, {_datas = {_id = functionParmaMouldId}})
					fwin:open(WorldBoss:new(), fwin._view)	
					-- fwin:open(BetrayArmyShop:new(), fwin._view)	
					state_machine.excute("button_betray_army_shop", 0, "")
					state_machine.excute("hero_develop_page_close", 0, "")
				end
			end
			NetworkManager:register(protocol_command.rebel_army_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
			
			
			
			
		elseif traceId == 31 then
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                then
				if fwin:find("HomeClass") == nil then
	            	state_machine.excute("menu_manager", 0, 
						{
							_datas = {
								terminal_name = "menu_manager", 	
								next_terminal_name = "menu_show_home_page", 
								current_button_name = "Button_home",
								but_image = "Image_home", 		
								terminal_state = 0, 
								isPressedActionEnabled = true
							}
						}
					)
	            end
				state_machine.excute("menu_back_home_page", 0, "") 
            	state_machine.excute("menu_clean_page_state", 0, "")
				state_machine.excute("menu_manager", 0, 
					{
						_datas = {
							terminal_name = "menu_manager", 	
							next_terminal_name = "menu_show_shop", 			
							current_button_name = "Button_shop", 		
							but_image = "Image_shop", 
							shop_type = "shop",		
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
			else
				state_machine.excute("menu_manager", 0, 
					{
						_datas = {
							terminal_name = "menu_manager", 	
							next_terminal_name = "menu_show_shop", 			
							current_button_name = "Button_shop", 		
							but_image = "Image_shop", 		
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
				state_machine.excute("shop_manager", 0, 
					{
						_datas = {
							terminal_name = "shop_manager",     
							next_terminal_name = "shop_prop_buy",
							current_button_name = "Button_props",   
							but_image = "prop",         
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
			end
		elseif traceId == 32 then
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end
			state_machine.excute("menu_manager", 0, 
				{
					_datas = {
						terminal_name = "menu_manager", 	
						next_terminal_name = "menu_show_shop", 			
						current_button_name = "Button_shop", 		
						but_image = "Image_shop", 		
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
			state_machine.excute("shop_manager", 0, 
				{
					_datas = {
						terminal_name = "shop_manager", 	
						next_terminal_name = "shop_vip_buy",	
						current_button_name = "Button_packs",  	
						but_image = "vip", 	
						terminal_state = 0, 
						isPressedActionEnabled = true
					}
				}
			)
		elseif traceId == 33 then
			app.load("client.learingskills.LearingSkillsDevelop")
			state_machine.excute("learing_skills_develop_open",0,{1,1})
		elseif traceId == 34 then 
			app.load("client.learingskills.LearingSkillsDevelop")
			state_machine.excute("learing_skills_develop_open",0,{2,2})
		elseif traceId == 35 then 
			app.load("client.captureResource.CaptureResourceMain")
			state_machine.excute("capture_resource_open",0, nil)	
		elseif traceId == 36 then 
			if fwin:find("MenuClass") == nil then
				fwin:open(Menu:new(), fwin._taskbar)
			end
			if fwin:find("HomeClass") == nil then
				if fwin:find("HomeClass") == nil then
	            	state_machine.excute("menu_manager", 0, 
						{
							_datas = {
								terminal_name = "menu_manager", 	
								next_terminal_name = "menu_show_home_page", 
								current_button_name = "Button_home",
								but_image = "Image_home", 		
								terminal_state = 0, 
								isPressedActionEnabled = true
							}
						}
					)
	            end
			end
			state_machine.excute("menu_back_home_page", 0, "") 
			state_machine.excute("home_hero_refresh_draw", 0, "")
			state_machine.excute("menu_clean_page_state", 0, "") 
        elseif traceId == 37 then 
            --宠物商店
            local openLevel = dms.int(dms["fun_open_condition"], 55, fun_open_condition.level)
            local userlevel = tonumber(_ED.user_info.user_grade)
            if userlevel >= openLevel then 
                app.load("client.packs.pet.PetShop")                
                local cell = PetShop:new()
                cell:init(1)
                fwin:open(cell, fwin._view)  
            else
                TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 55, fun_open_condition.tip_info))
            end
        elseif traceId == 38 then 
            --宠物副本
            local function responsePetDuplicateCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    fwin:close(fwin:find("PetShopClass"))       
                    app.load("client.campaign.battlefield.BattleField")
                    state_machine.excute("battle_field_window_open",0,"")
                end
            end
            NetworkManager:register(protocol_command.pet_counterpart_init.code, nil, nil, nil, nil, responsePetDuplicateCallback, true, nil)
        elseif traceId == 39 then 
            app.load("client.packs.pet.PetStorage")     
            fwin:open(PetStorage:new(), fwin._view) 
            state_machine.excute("pet_storage_manager", 0, 
            {
                _datas = {
                    terminal_name = "pet_storage_manager",     
                    next_terminal_name = "pet_storage_show_pet_list", 
                    current_button_name = "Button_zhanchong",   
                    but_image = "",     
                    terminal_state = 0, 
                    isPressedActionEnabled = false
                }
            })
            
            state_machine.excute("menu_change_button_state", 0,
                {
                    _datas = {
                        buttonName = "Button_home"
                    }
                }
            ) 
        elseif traceId == 40 then -- 40  探索商店
			if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
            
            app.load("client.l_digital.campaign.fileIsland.FileIslandWindow")
            state_machine.excute("fileIsland_window_shop_open",0, 0)
        elseif traceId == 41 then -- 41  冒险-活动关卡
            app.load("client.l_digital.explore.ExploreWindow")
            state_machine.excute("explore_window_open", 0, 0)
            state_machine.excute("explore_window_open_fun_window", 0,
            {
                _datas = {
                    terminal_name = "explore_window_open_fun_window",
                    page_index = 1,
                    isPressedActionEnabled = true
                }
            })
        elseif traceId == 42 then -- 42  主页-购买金币
            state_machine.excute("sm_buy_silver_coinsopen", 0, 0)
        elseif traceId == 43 then -- 43  主页-购买体力
            state_machine.excute("sm_buy_physicalopen", 0, 0)
        elseif traceId == 44 then -- 44  数码兽-强化-升级
            state_machine.excute("formation_open_instance_window", 0, {_datas = {_shipInstance = _ED.user_ship[_ED.user_formetion_status[1]]}})
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                state_machine.excute("formation_switch_paging_information",0,{_datas = {_page = 5}})
            else
                state_machine.excute("formation_go_to_hero_herodevelop", 0,
                {
                    _datas = {
                        terminal_name = "formation_go_to_hero_herodevelop", 
                        terminal_state = 0, 
                        isPressedActionEnabled = true
                    }
                })
                state_machine.excute("hero_develop_page_manager",0,{_datas = {
                    next_terminal_name = "hero_develop_page_open_advanced",             
                    current_button_name = "Button_tupo",    
                    but_image = "",     
                    shipId = _ED.user_formetion_status[1],
                    terminal_state = 0, 
                    openWinId = 34,
                    isPressedActionEnabled = tempIsPressedActionEnabled
                }})
            end
        elseif traceId == 45 then -- 45  数码兽-强化-进阶
            state_machine.excute("formation_open_instance_window", 0, {_datas = {_shipInstance = _ED.user_ship[_ED.user_formetion_status[1]]}})
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                state_machine.excute("formation_switch_paging_information",0,{_datas = {_page = 4}})
            else
                state_machine.excute("formation_go_to_hero_herodevelop", 0,
                {
                    _datas = {
                        terminal_name = "formation_go_to_hero_herodevelop", 
                        terminal_state = 0, 
                        isPressedActionEnabled = true
                    }
                })
            end
        elseif traceId == 46 then -- 46  数码兽-强化-技能
            state_machine.excute("formation_open_instance_window", 0, {_datas = {_shipInstance = _ED.user_ship[_ED.user_formetion_status[1]]}})
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                state_machine.excute("formation_switch_paging_information",0,{_datas = {_page = 7}})
            else
                state_machine.excute("formation_go_to_hero_herodevelop", 0,
                {
                    _datas = {
                        terminal_name = "formation_go_to_hero_herodevelop", 
                        terminal_state = 0, 
                        isPressedActionEnabled = true
                    }
                })
                state_machine.excute("hero_develop_page_manager",0,{_datas = {
                    terminal_name = "hero_develop_page_manager",    
                    next_terminal_name = "hero_develop_page_open_skill_stren_page",             
                    current_button_name = "Button_tianming",    
                    but_image = "",     
                    shipId = _ED.user_formetion_status[1],
                    terminal_state = 0, 
                    openWinId = 4,
                    isPressedActionEnabled = true
                }})
            end
        elseif traceId == 47 then -- 47  公会战
            app.load("client.l_digital.union.unionFighting.UnionFightingMain")
            state_machine.excute("union_fighting_main_open", 0, nil)
        elseif traceId == 48 then -- 48  跨服王者之战
            app.load("client.l_digital.campaign.Campaign")
            state_machine.excute("campaign_window_open", 0, nil)
            state_machine.excute("campaign_show_cross_server_battle_of_kings", 0, nil)
        elseif traceId == 49 then -- 49  王者之战
            app.load("client.l_digital.campaign.Campaign")
            state_machine.excute("campaign_window_open", 0, nil)
            state_machine.excute("campaign_show_battle_of_kings", 0, nil)
        elseif traceId == 51 then -- 51  数码-跳转登录奖励
            -- app.load("client.l_digital.activity.wonderful.SmActivityLangingReword")
            -- state_machine.excute("sm_activity_langing_reword_window_open",0,"") 
            if __lua_project_id == __lua_project_onepiece then
                state_machine.excute("activity_window_open", 0, {"client.l_digital.activity.wonderful.SmActivityLangingReword", "SmActivityLangingReword"})
                state_machine.excute("activity_window_open_page_activity",0,{"SmActivityLangingReword"})
            else
                app.load("client.l_digital.activity.wonderful.SmActivityLangingReword")
                state_machine.excute("sm_activity_langing_reword_window_open",0,"") 
            end
            
        elseif traceId == 50 then  --商店宝箱跳转
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    if funOpenDrawTip(115) == true then
                        return
                    end
                    app.load("client.l_digital.shop.SmShopPropBuyListView")
                    state_machine.excute("menu_manager","0",{_datas = {
                        next_terminal_name = "menu_show_shop", 
                        current_button_name = "Button_shop_0",
                        but_image = "Image_shop",   
                        terminal_state = 0,
                        shop_type = "shop",
                        shop_page = 1,
                    }}
                )
            end
        elseif traceId == 52 then   -- 52 打开首充界面
            if state_machine.excute("home_open_first_recharge_activity", 0, "") == false then
                app.load("client.shop.recharge.RechargeDialog")
                state_machine.excute("recharge_dialog_window_open", 0, 0)
                state_machine.excute("show_vip_privilege", 0, 0)
            end
        elseif traceId == 53 then -- 53  数码-跳转vip特权
            app.load("client.shop.recharge.RechargeDialog")
            state_machine.excute("recharge_dialog_window_open", 0, 0)
            state_machine.excute("show_vip_privilege", 0, 0)
        elseif traceId == 54        -- 54  数码-跳转vip-5特权
            or traceId == 55        -- 55  数码-跳转vip-8特权
            or traceId == 56        -- 56  数码-跳转vip-10特权
            or traceId == 57        -- 57  数码-跳转vip-13特权
            or traceId == 58        -- 58  数码-跳转vip-16特权
            or traceId == 59        -- 59  数码-跳转vip-17特权
            then 
            local vip_grade = 0
            if traceId == 54 then
                vip_grade = 5
            elseif traceId == 55 then
                vip_grade = 8
            elseif traceId == 56 then
                vip_grade = 10
            elseif traceId == 57 then
                vip_grade = 13
            elseif traceId == 58 then
                vip_grade = 16
            elseif traceId == 59 then
                vip_grade = 17
            end
            app.load("client.shop.recharge.RechargeDialog")
            state_machine.excute("recharge_dialog_window_open", 0, 0)
            state_machine.excute("show_vip_privilege", 0, 0)
            state_machine.excute("sm_vip_prilige_update_change_page",0, {vip_grade})
        elseif traceId == 60 then -- 60  月卡
            state_machine.excute("activity_window_open", 0, {"client.activity.ActivityMonthCard", "MonthCard"})
            state_machine.excute("activity_window_open_page_activity",0,{"MonthCard"})
        elseif traceId == 61 then
            if nil ~= _ED.active_activity[4] then
                app.load("client.activity.ActivityFirstRecharge")
                state_machine.excute("rechargeable_open",0,1)
            else
                app.load("client.shop.recharge.RechargeDialog")
                state_machine.excute("recharge_dialog_window_open", 0, 0)
            end
        elseif traceId == 62 then
            state_machine.excute("formation_open_instance_window", 0, {_datas = {_shipInstance = _ED.user_ship[_ED.user_formetion_status[1]]}})
            state_machine.excute("formation_switch_paging_information",0,{_datas = {_page = 2}})
        elseif traceId == 80 then -- 80  公会战
            app.load("client.l_digital.union.unionFighting.UnionFightingMain")
            state_machine.excute("union_fighting_main_open", 0, nil)
        elseif traceId == 92 then -- 92  公会战
            app.load("client.l_digital.union.unionFighting.UnionFightingMain")
            state_machine.excute("union_fighting_main_open", 0, nil)
        elseif traceId == 97 then -- 97  当前主线最高进度
            -- fwin:open(DuplicateController:new(), fwin._view)
            -- state_machine.excute("duplicate_page_controller_open", 0, 
            --  {
            --      _datas = {
            --          terminal_name = "duplicate_page_controller_open",   
            --          next_terminal_name = "duplicate_page_controller_open",        
            --          but_image = "Image_duplicate",       
            --          terminal_state = 0, 
            --          isPressedActionEnabled = true
            --      }
            --  }
            -- )
            app.load("client.home.Menu")
            if fwin:find("MenuClass") == nil then
                fwin:open(Menu:new(), fwin._taskbar)
            end
            state_machine.excute("menu_manager", 0, 
                {
                    _datas = {
                        terminal_name = "menu_manager",     
                        next_terminal_name = "menu_show_duplicate",     
                        current_button_name = "Button_duplicate",   
                        but_image = "Image_duplicate",  
                        terminal_state = 0, 
                        isPressedActionEnabled = true
                    }
                }
            )
            state_machine.excute("shortcut_open_duplicate_window", 0, params) 
        elseif traceId == 98 then -- 98  当前精英最高进度
            if __lua_project_id == __lua_project_digimon_adventure 
                or __lua_project_id == __lua_project_pokemon 
                or __lua_project_id == __lua_project_rouge 
                or __lua_project_id == __lua_project_warship_girl_b
                or __lua_project_id == __lua_project_yugioh 
                then 
                app.load("client.home.Menu")
                if fwin:find("MenuClass") == nil then
                    fwin:open(Menu:new(), fwin._taskbar)
                end
                state_machine.excute("menu_manager", 0, 
                    {
                        _datas = {
                            terminal_name = "menu_manager",     
                            next_terminal_name = "menu_show_duplicate",     
                            current_button_name = "Button_duplicate",   
                            but_image = "Image_duplicate",  
                            terminal_state = 0, 
                            isPressedActionEnabled = true
                        }
                    }
                )
                state_machine.excute("shortcut_open_elite_duplicate_window", 0, params)
            elseif __lua_project_id == __lua_project_gragon_tiger_gate
                or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                then 
                app.load("client.home.Menu")
                if fwin:find("MenuClass") == nil then
                    fwin:open(Menu:new(), fwin._taskbar)
                end
                state_machine.excute("menu_manager", 0, 
                    {
                        _datas = {
                            terminal_name = "menu_manager",     
                            next_terminal_name = "menu_show_duplicate_abyss",   
                            current_button_name = "Button_duplicate",   
                            but_image = "Image_duplicate",  
                            terminal_state = 0, 
                            isPressedActionEnabled = true
                        }
                    }
                )
            else
                TipDlg.drawTextDailog(_function_unopened_tip_string)
            end
        elseif traceId == 99 then -- 99  读取文字内容
        elseif traceId == 100 then -- 100  数码试炼
            app.load("client.l_digital.explore.ExploreWindow")
            state_machine.excute("explore_window_open", 0, "2")
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
            -- state_machine.excute("explore_window_open_fun_window", 0, { _datas = {page_index = 2} })
        elseif traceId == 101 then -- 101  数码净化
            app.load("client.l_digital.explore.ExploreWindow")
            state_machine.excute("explore_window_open", 0, "3")
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
            -- state_machine.excute("explore_window_open_fun_window", 0, { _datas = {page_index = 3} })
        elseif traceId == 102 then -- 102  公会捐献
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                if _ED.union.union_info == nil or _ED.union.union_info == {}  or  _ED.union.union_info.union_id == nil or _ED.union.union_info.union_id == "" then
                    app.load("client.l_digital.union.create.UnionJoin")
                    local function responseUnionListCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("union_join_open", 0, "")
                        end
                    end 
                    _ED.union.union_list_info = nil
                    protocol_command.union_list.param_list = "0"
                    NetworkManager:register(protocol_command.union_list.code, nil, nil, nil, self, responseUnionListCallback, false, nil)
                else
                    app.load("client.l_digital.union.UnionTigerGate")
                    app.load("client.l_digital.union.meeting.SmUnionResearchInstitute")
                    if tonumber(_ED.union.union_member_list_sum) == nil then 
                        local function responseCallback( response )
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then 
                                state_machine.excute("Union_open", 0, "")
                                state_machine.excute("sm_union_research_institute_open",0,"sm_union_research_institute_open.")
                            end
                        end
                        NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, nil, responseCallback, false, nil)
                    else
                        state_machine.excute("Union_open", 0, "")
                        state_machine.excute("sm_union_research_institute_open",0,"sm_union_research_institute_open.")
                    end
                end
            end
        elseif traceId == 103 then --   数码合金
            app.load("client.l_digital.cultivate.matrix.AlloyMatrixWindow")
            state_machine.excute("alloy_matrix_window_open",0,"")
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
        elseif traceId == 104 then --   数码精神
            app.load("client.l_digital.cultivate.SmCultivateSpiritWindow")
            state_machine.excute("sm_cultivate_spirit_window_open", 0, "")
            state_machine.excute("sm_activity_active_window_close", 0, nil)
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
        elseif traceId == 105 then --   公会能量屋
            if _ED.union.union_info == nil or _ED.union.union_info == {} or _ED.union.union_info.union_id == nil or _ED.union.union_info.union_id == "" then
                -- app.load("client.l_digital.union.create.UnionJoin")
                -- local function responseUnionListCallback(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         state_machine.excute("union_join_open", 0, "")
                --     end
                -- end 
                -- _ED.union.union_list_info = nil
                -- protocol_command.union_list.param_list = "0"
                -- NetworkManager:register(protocol_command.union_list.code, nil, nil, nil, self, responseUnionListCallback, false, nil)
                TipDlg.drawTextDailog(_new_interface_text[293])
            else
                if dms.int(dms["fun_open_condition"], 147, fun_open_condition.union_level) > tonumber(_ED.union.union_info.union_grade) then
                    TipDlg.drawTextDailog(_new_interface_text[294])
                else
                -- app.load("client.l_digital.union.meeting.SmUnionEnergyHouse")
                -- local server_time = _ED.system_time + (os.time() - _ED.native_time) - _ED.GTM_Time
                -- if _ED.union.user_union_info.union_last_enter_time - server_time > 0 then
                --     TipDlg.drawTextDailog(_new_interface_text[195])
                --     return
                -- end
                -- local function responseCallback(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         state_machine.excute("sm_union_energy_house_open", 0, 1)
                --     end
                -- end
                -- NetworkManager:register(protocol_command.union_ship_train_init.code, nil, nil, nil, nil, responseCallback, false, nil)
                    app.load("client.l_digital.union.UnionTigerGate")
                    state_machine.excute("Union_open", 0, "")
                    state_machine.excute("union_change_update_open_energy_house",0,"union_change_update_open_energy_house.")
                end
            end
            state_machine.excute("sm_activity_active_window_close", 0, nil)
        elseif traceId == 106 then --   神器
            app.load("client.l_digital.cultivate.artifact.SmCultivateArtifactWindow")
            state_machine.excute("sm_cultivate_artifact_window_open", 0, "")
            state_machine.excute("sm_activity_active_window_close", 0, nil)
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
        elseif traceId == 107 then --   神秘商店
            app.load("client.shop.SecretShop")
            state_machine.excute("secret_shop_window_open", 0, "")
            state_machine.excute("sm_activity_active_window_close", 0, "")
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
        elseif traceId == 108 then --   工会红包
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                app.load("client.l_digital.union.redEnvelopes.SmUnionRedEnvelopes")
                if funOpenDrawTip(nextId, true) == true then
                    return
                end
                state_machine.excute("sm_union_red_envelopes_open", 0, "")
                
            end
        elseif traceId == 109 then --   充值
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                app.load("client.shop.recharge.RechargeDialog")
                if funOpenDrawTip(nextId, true) == true then
                    return
                end
                state_machine.excute("recharge_dialog_window_open", 0, 0)
            end
        elseif traceId == 110 then --   数码兽-强化-升星
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                if funOpenDrawTip(nextId, true) == true then
                    return
                end
                if fwin:find("ActivityWindowClass") then
                    app.load("client.activity.ActivityWindow")
                    state_machine.excute("activity_window_close",0, "")
                end
                state_machine.excute("shortcut_function_open_ship_rising_star", 0, {_datas = {root_trace = 110}})
            end
        elseif traceId == 111 then --   数码兽-强化-斗魂
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                if funOpenDrawTip(nextId, true) == true then
                    return
                end
                if fwin:find("ActivityWindowClass") then
                    app.load("client.activity.ActivityWindow")
                    state_machine.excute("activity_window_close",0, "")
                end
                state_machine.excute("shortcut_function_open_ship_rising_star", 0, {_datas = {root_trace = 111}})
            end
        elseif traceId == 112 then --   节日兑换活动
            if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                or __lua_project_id == __lua_project_red_alert 
                or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
                then
                app.load("client.l_digital.activity.wonderful.AprilFoolsDayPropExchangeActivity")
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close", 0, 0)
                state_machine.excute("april_fools_day_prop_exchange_activity_window_open", 0, 0)
            end
        elseif traceId == 113 then --   数码合金抽卡
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
            
            app.load("client.l_digital.cultivate.matrix.AlloyMatrixGetReword")
			state_machine.excute("alloy_matrix_get_reword_window_open",0, {_datas = {is_fun_open = true}})
		elseif traceId == 114 then --   探索有礼
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
            
            app.load("client.l_digital.campaign.fileIsland.FileIslandWindow")
            state_machine.excute("fileIsland_window_open",0, 0)
        elseif traceId == 115 then --   天赋
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
            
            app.load("client.l_digital.cultivate.talent.SmTalentMainWindow")
            state_machine.excute("sm_talent_main_window_open",0, 0)
        elseif traceId == 116 then --   诸神赐福
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
            
            app.load("client.l_digital.cultivate.constellation.SmCultivateConstellationWindow")
            state_machine.excute("sm_cultivate_constellation_window_open",0, 0)
        elseif traceId == 117 then --   秘宝活动
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
            if _ED.active_activity[148] ~= nil then
                app.load("client.activity.treasure.TreasureWindow")
                state_machine.excute("treasure_window_open", 0, "")
            end
         elseif traceId == 118 then --   限时精灵
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
            if _ED.active_activity[89] ~= nil and funOpenDrawTip(164, false) == false then
                app.load("client.l_digital.activity.wonderful.SmLimitedTimeEquipBox")
                state_machine.excute("sm_limited_time_equip_box_open", 0, {89})
            end
        elseif traceId == 119 then --   精灵来袭
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
            if _ED.active_activity[114] ~= nil then
                app.load("client.l_digital.activity.wonderful.SmOtherRecruitActivity")
                state_machine.excute("sm_other_recruit_activity_open", 0, {})

                local activity_type = 114
                local readTime = cc.UserDefault:getInstance():getStringForKey(getKey("activity_push_"..activity_type))
                local nowTimeStr = os.date("%Y".."-".."%m".."-".."%d".."-".."%H", getBaseGTM8Time(_ED.system_time + (os.time() - _ED.native_time)))
                local nowTimes = zstring.split(nowTimeStr, "-")
                local havePush = false
                if readTime == nil or readTime == "" then
                    writeKey( "activity_push_"..activity_type, nowTimeStr)
                    havePush = true
                else
                    local readTimes = zstring.split(readTime , "-")
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
                end
            end
        elseif traceId == 120 then --   武器扭蛋
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
            if _ED.active_activity[154] ~= nil then
                app.load("client.activity.egg_machine.EggMachineWindow")
                state_machine.excute("egg_machine_window_open", 0, "")
            end
        elseif traceId == 121 then --   世界boss
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
            app.load("client.l_digital.campaign.worldboss.WorldBossWindow")
            state_machine.excute("world_boss_window_open", 0, 0)
        elseif traceId == 123 then --   活动列表
            if fwin:find("ActivityWindowClass") then
                app.load("client.activity.ActivityWindow")
                state_machine.excute("activity_window_close",0, "")
            end
            app.load("client.cells.activity.activity_icon_cell")
            state_machine.excute("activity_icon_button", 0, 0)
        elseif traceId == 127 then --   跳转广告观看界面
            app.load("client.activity.watch_ads.WatchAdsWindow")
            if fwin:find("WatchAdsWindowClass") then
                state_machine.excute("watch_ads_window_close",0, "")
            end
            state_machine.excute("watch_ads_window_open", 0, "")
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--后台切走了
local shortcut_function_cc_platform_pause_terminal = {
    _name = "shortcut_function_cc_platform_pause",
    _init = function (terminal) 
	
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
            or __lua_project_id == __lua_project_red_alert 
            or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
            then

		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--后台切回来了
local shortcut_function_cc_platform_resume_terminal = {
    _name = "shortcut_function_cc_platform_resume",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
            or __lua_project_id == __lua_project_red_alert 
            or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
            then
			if fwin:find("FightUIClass") ~= nil then
				local function responseKeepAliveCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					else
						fwin:open(ReconnectView:new(),fwin._system)
					end
				end
				NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, responseKeepAliveCallback, false, nil)
			end
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
-- 铜币的购买打开获取途径面板
local shortcut_function_silver_to_get_open_terminal = {
    _name = "shortcut_function_silver_to_get_open",
    _init = function (terminal) 
	
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	app.load("client.utils.silver.SilverToGet")
		local types = params
		state_machine.excute("silver_to_get_open",0,types)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--跳转到武将升星/斗魂
local shortcut_function_open_ship_rising_star_terminal = {
    _name = "shortcut_function_open_ship_rising_star",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local ship = nil
        local root_trace = params._datas.root_trace
        for i, v in pairs(_ED.user_formetion_status) do
            if zstring.tonumber(v) > 0 then
                ship = _ED.user_ship[""..v]
                break
            end
        end
        local enter_type = "learn"
        if fwin:find("HeroIconListViewClass") == nil then
            app.load("client.packs.hero.HeroIconListView")
            state_machine.excute("hero_icon_listview_open",0,ship)
            fwin:find("HeroIconListViewClass"):setVisible(false)
        end
        app.load("client.packs.hero.HeroDevelop")
        if fwin:find("HeroDevelopClass") ~= nil then
            state_machine.excute("formation_set_ship",0,ship)
            return
            -- fwin:close(fwin:find("HeroDevelopClass"))
        end
        local heroDevelopWindow = HeroDevelop:new()
        if __lua_project_id == __lua_project_gragon_tiger_gate 
            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then
            ship.shengming = zstring.tonumber(ship.ship_health)
            ship.gongji = zstring.tonumber(ship.ship_courage)
            ship.waigong = zstring.tonumber(ship.ship_intellect)
            ship.neigong = zstring.tonumber(ship.ship_quick)
        end
        -- print("=======11=====",enter_type)
        if enter_type ~= "learn" and enter_type ~= "pack" then
            enter_type = "formation"
        end
        for i,v in pairs(_ED.user_formetion_status) do
            if zstring.tonumber(v) == tonumber(ship.ship_id) then
                enter_type = "formation"
            end
        end
        heroDevelopWindow:init(ship.ship_id, enter_type)
        fwin:open(heroDevelopWindow, fwin._viewdialog)
        local button_name = root_trace == 110 and "Button_peiyang" or "Button_douhun"
        local next_terminal_name = root_trace == 110 and "hero_develop_page_open_train_page" or "hero_develop_page_open_fighting_spirit"
        state_machine.excute("hero_develop_page_manager",0,{_datas = {next_terminal_name = next_terminal_name,            
        current_button_name = button_name,     
        but_image = "",     
        shipId = nil,
        terminal_state = 0, 
        openWinId = 3,
        isPressedActionEnabled = tempIsPressedActionEnabled}})
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 打开建号战令特殊商店
local shortcut_open_construction_order_special_shop_terminal = {
    _name = "shortcut_open_construction_order_special_shop",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if _ED.active_activity[186] ~= nil and _ED.active_activity[186].user_order_info ~= nil then
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    app.load("client.activity.construction_order.ConstructionOrderMain")
                    state_machine.excute("construction_order_main_window_open", 0, nil)
                    state_machine.excute("construction_order_main_open_shop", 0, {_datas = {curType = 2}})
                end
            end
            protocol_command.user_build_war_order_init.param_list = ""
            NetworkManager:register(protocol_command.user_build_war_order_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        else
            TipDlg.drawTextDailog(war_order_str[25])
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 初始化快捷跳转方式的状态机
local function init_shortcut_terminal()


	state_machine.add(shortcut_open_function_login_of_other_terminal)
	state_machine.add(shortcut_open_duplicate_hight_copy_window_terminal)
	state_machine.add(shortcut_function_goto_log_terminal)
	state_machine.add(shortcut_function_back_terminal)
    state_machine.add(shortcut_open_function_dailog_cancel_and_ok_terminal)
    state_machine.add(shortcut_open_duplicate_window_terminal)
   	state_machine.add(shortcut_open_recharge_tip_dialog_terminal)
    state_machine.add(shortcut_open_recharge_window_terminal)
    state_machine.add(shortcut_open_vip_privilege_window_terminal)
    state_machine.add(shortcut_open_show_reward_item_info_terminal)
    state_machine.add(shortcut_function_trace_terminal)
	state_machine.add(shortcut_function_cc_platform_pause_terminal)
	state_machine.add(shortcut_function_cc_platform_resume_terminal)
	state_machine.add(shortcut_function_silver_to_get_open_terminal)
	state_machine.add(shortcut_open_elite_duplicate_window_terminal)
    state_machine.add(shortcut_function_open_ship_rising_star_terminal)
    state_machine.add(shortcut_open_construction_order_special_shop_terminal)
	
	state_machine.init()
end

-- call func init shortcut state machine.
init_shortcut_terminal()