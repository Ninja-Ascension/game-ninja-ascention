-- ----------------------------------------------------------------------------------------------------
-- 说明：获得路径的list
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EquipFragmentAcquire = class("EquipFragmentAcquireClass", Window)
  
function EquipFragmentAcquire:ctor()
    self.super:ctor()
	self.roots = {}
	self.mouldId = nil
	self.raids_number = 0
    -- Initialize Home page state machine.
		-- -1：无跳转
		-- （X级开启，已开启）
		-- 跳转（前往）
		-- 0：武将仓库
		-- 1：装备仓库
		-- 2：宝物仓库
		-- 3：包裹
		-- 4：三国志
		-- 5：回收
		-- 6：活动
		-- 7：神将商店
		-- 8：名人堂
		-- 9：觉醒商店
		-- 10：阵容
		-- 11：副本
		-- 12：名将副本
		-- 13：日常副本
		-- 14：精英副本
		-- 15：征战
		-- 16：竞技场
		-- 17：夺宝
		-- 18：三国无双
		-- 19：领地攻讨
		-- 20：围剿叛军
		-- 21：商城招贤
		-- 21：商城道具
		-- 21：商城礼包
		-- 22：战将招募
		-- 23：神将招募
		-- 24：军团
		-- 25：军团商店
    local function init_equip_fragment_acquire_terminal()
		local equip_fragment_acquire_get_terminal = {
            _name = "equip_fragment_acquire_get",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local traceFunctionId = params._datas._id

                local openFunctionId = dms.int(dms["function_param"], traceFunctionId, function_param.open_function)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					local open_leve=dms.int(dms["function_param"], traceFunctionId, function_param.open_leve)
					local sceneId=dms.int(dms["function_param"], traceFunctionId, function_param.open_scene)
					local npcId=dms.int(dms["function_param"], traceFunctionId, function_param.open_npc)
					local by_open_vip=dms.int(dms["function_param"], traceFunctionId, function_param.by_open_vip)

	                if open_leve > zstring.tonumber(_ED.user_info.user_grade)
						or by_open_vip > tonumber(_ED.vip_grade)
						or (nil ~= sceneId and sceneId > 0 and tonumber(_ED.scene_current_state[sceneId]) < 0)
						or (nil ~= npcId and npcId > 0 and tonumber(_ED.npc_state[npcId]) <= 0)
						then
						TipDlg.drawTextDailog(_new_interface_text[35])
						return false
					end

					if funOpenDrawTip(openFunctionId) then
						return
					end
				else
	                if openFunctionId > 0 then
	                    local user_grade=dms.int(dms["fun_open_condition"], openFunctionId, fun_open_condition.level)
	                    if user_grade <= zstring.tonumber(_ED.user_info.user_grade) then
	                        
	                    else
	                        TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
	                        return false
	                    end
	                end
				end
				
                fwin:close(fwin:find("HeroPatchInformationPageGetWayClass"))
				state_machine.excute("touch_colose", 0, "touch_colose.'")
				state_machine.excute("hero_patch_information_close", 0, "hero_patch_information_close.'")
				-- if dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 27 then
					-- fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
				-- end
		
				local awakenEqupComposeWindow = fwin:find("HeroAwakenEquipInfoClass")
				if awakenEqupComposeWindow ~= nil then 
					fwin:close(awakenEqupComposeWindow)
				end
				local heroAwakenEquipWindow = fwin:find("HeroAwakenEquipComposeClass")
				if heroAwakenEquipWindow ~= nil then 
					fwin:close(heroAwakenEquipWindow)
				end
				local window_terminal = state_machine.find("pet_develop_page_close")
				if window_terminal ~= nil then 
					--宠物
					state_machine.excute("pet_develop_page_close",0,0)
				end
				local petInfowindow = fwin:find("PetInformationClass")
				if petInfowindow ~= nil then 
					--宠物信息界面
					fwin:close(petInfowindow)
				end
				state_machine.excute("pet_storage_return_home_page",0,0)
                state_machine.excute("shortcut_function_trace", 0, {trace_function_id = traceFunctionId, _datas = {}})
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_fragment_acquire_get_close_terminal = {
            _name = "equip_fragment_acquire_get_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local traceFunctionId = params._datas._id
				
				fwin:close(fwin:find("HeroPatchInformationPageGetWayClass"))
				state_machine.excute("hero_patch_information_close", 0, "hero_patch_information_close.'")
				state_machine.excute("touch_colose", 0, "touch_colose.'")
				
				if dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 27 then
					fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
				end
				local awakenEqupComposeWindow = fwin:find("HeroAwakenEquipInfoClass")
				if awakenEqupComposeWindow ~= nil then 
					fwin:close(awakenEqupComposeWindow)
				end
				local heroAwakenEquipWindow = fwin:find("HeroAwakenEquipComposeClass")
				if heroAwakenEquipWindow ~= nil then 
					fwin:close(heroAwakenEquipWindow)
				end
				local petInfowindow = fwin:find("PetInformationClass")
				if petInfowindow ~= nil then 
					--宠物信息界面
					fwin:close(petInfowindow)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local equip_fragment_acquire_get_in_plist_terminal = {
            _name = "equip_fragment_acquire_get_in_plist",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				TipDlg.drawTextDailog(_function_unopened_tip_string)
				
				fwin:close(fwin:find("HeroPatchInformationPageGetWayClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新界面
        local equip_fragment_acquire_refresh_interface_data_terminal = {
            _name = "equip_fragment_acquire_refresh_interface_data",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("hero_patch_information_update_draw", 0, "")
            	if fwin:find("SmRoleStrengthenTabRisingStarClass") ~= nil then
	            	state_machine.excute("sm_role_strengthen_tab_rising_star_update_draw", 0 , "")
	            end
	            if fwin:find("SmRoleStrengthenTabUpProductClass") ~= nil then
		            state_machine.excute("sm_role_strengthen_tab_up_product_update_draw",0,"")
		        end
		        if fwin:find("SmEquipmentTabUpProductClass") ~= nil then
		        	state_machine.excute("sm_equipment_tab_up_product_update_draw",0,"")
		        end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --追踪扫荡
        local equip_fragment_acquire_track_raids_terminal = {
            _name = "equip_fragment_acquire_track_raids",
            _init = function (terminal)
            	app.load("client.duplicate.MoppingResults")
            	app.load("client.duplicate.AutoRaids")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	local open_scene = params._datas.open_scene
            	local open_npc = params._datas.open_npc
            	local traceFunctionId = params._datas._id
            	local raidsNumber = tonumber(params._datas.raidsNumber)
				_ED.auto_raids_real_count = raidsNumber

				 
                local openFunctionId = dms.int(dms["function_param"], traceFunctionId, function_param.open_function)
				local open_leve=dms.int(dms["function_param"], traceFunctionId, function_param.open_leve)
				local sceneId=dms.int(dms["function_param"], traceFunctionId, function_param.open_scene)
				local npcId=dms.int(dms["function_param"], traceFunctionId, function_param.open_npc)
				local by_open_vip=dms.int(dms["function_param"], traceFunctionId, function_param.by_open_vip)

                if open_leve > zstring.tonumber(_ED.user_info.user_grade)
					or by_open_vip > tonumber(_ED.vip_grade)
					or (nil ~= sceneId and sceneId > 0 and tonumber(_ED.scene_current_state[sceneId]) < 0)
					or (nil ~= npcId and npcId > 0 and tonumber(_ED.npc_state[npcId]) <= 0)
					then
					TipDlg.drawTextDailog(_new_interface_text[35])
					return false
				end


				if funOpenDrawTip(openFunctionId) then
					return
				end

				local open_id = 110
				if raidsNumber == 3 then 
					open_id = 113
				elseif raidsNumber == 50 then
					open_id = 112
				elseif raidsNumber == 1000 then
					open_id = 197
				end
				local myLv = tonumber(_ED.user_info.user_grade)
				local myVip = tonumber(_ED.vip_grade)
				local needLv = dms.int(dms["fun_open_condition"], open_id, fun_open_condition.level)
				local needVip = dms.int(dms["fun_open_condition"], open_id, fun_open_condition.vip_level)

				if raidsNumber == 50 or raidsNumber == 1000 then
					if myLv < needLv and myVip < needVip then
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], open_id, fun_open_condition.tip_info))
						return
					end
				else
					if myLv < needLv or myVip < needVip then
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], open_id, fun_open_condition.tip_info))
						return
					end
				end
				
				local star = 0
				if zstring.tonumber(_ED.npc_state[tonumber(open_npc)]) < zstring.tonumber(_ED.npc_max_state[tonumber(open_npc)]) and zstring.tonumber(_ED.npc_state[tonumber(open_npc)]) ~= 0 then
					star = tonumber(_ED.npc_max_state[tonumber(open_npc)])
				else
					star = tonumber(_ED.npc_state[tonumber(open_npc)])
				end
				
				if zstring.tonumber(star) < 3 then
					TipDlg.drawTextDailog(_new_interface_text[133])
					return
				end

				local currentNpcID = open_npc							-- NPCID
				local DifficultyID = 1												-- 攻击下标
				local surplusTimes = raidsNumber --self.maxAttackCount - self.currentAttackTimes	-- 扫荡次数
				local elseContent  = "0"											-- 扫荡类型
				
				local addTimes = 0
				open_scene = dms.int(dms["npc"], open_npc, npc.scene_id)
				local scene_type = dms.int(dms["pve_scene"], open_scene, pve_scene.scene_type)
			    if scene_type == 1 then
			        if _ED.active_activity[100] ~= nil and _ED.active_activity[100] ~= "" then
			            addTimes = tonumber(_ED.active_activity[100].activity_Info[1].activityInfo_need_day)
			        end
			    end

				local totalAttackTimes = dms.int(dms["npc"], open_npc, npc.daily_attack_count)
				totalAttackTimes = totalAttackTimes + addTimes
				-- --debug.print_r(_ED.npc_current_attack_count)
				local surplusAttackCount = tonumber(_ED.npc_current_attack_count[tonumber(open_npc)])
				local finalBattleTimes = totalAttackTimes - surplusAttackCount
				if (finalBattleTimes > raidsNumber) then finalBattleTimes = raidsNumber end
				surplusTimes = finalBattleTimes
				
				if tonumber(surplusTimes) <= 0 then
					-- TipDlg.drawTextDailog(_string_piece_info[113])
					state_machine.excute("equip_fragment_acquire_buy_times", 0, {cell, currentNpcID})
					return
				end

				if zstring.tonumber(dms.int(dms["npc"], open_npc, npc.attack_need_food)) * surplusTimes > zstring.tonumber(_ED.user_info.user_food) then
					surplusTimes = math.floor(zstring.tonumber(_ED.user_info.user_food)/zstring.tonumber(dms.int(dms["npc"], open_npc, npc.attack_need_food)))
				end
				
				-- 处理 开战时 体力不足 -----------------
				
				if zstring.tonumber(_ED.user_info.user_food) < zstring.tonumber(dms.int(dms["npc"], open_npc, npc.attack_need_food)) then
					app.load("client.cells.prop.prop_buy_prompt")
					
					local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
					local mid = zstring.tonumber(config[15])
					--print("abc",mid)
					local win = PropBuyPrompt:new()
					win:init(mid)
					fwin:open(win, fwin._ui)
					return
				end
				if raidsNumber == 1000 then
					state_machine.excute("auto_raids_window_open", 0, {1, currentNpcID, DifficultyID, surplusTimes, elseContent, {"equip_fragment_acquire_refresh_interface_data", instance},raidsNumber,open_scene,scene_type})
				else
					_ED.auto_raids_source = false
					fwin:open(MoppingResults:new():init(1, currentNpcID, DifficultyID, surplusTimes, elseContent, {"equip_fragment_acquire_refresh_interface_data", instance},raidsNumber,open_scene,scene_type), fwin._windows)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新控件
        local equip_fragment_acquire_refresh_the_control_terminal = {
            _name = "equip_fragment_acquire_refresh_the_control",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params[1]
            	cell:onUpdateRaidsButton(params[2],params[3],params[4])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 副本重置
        local equip_fragment_acquire_buy_times_terminal = {
            _name = "equip_fragment_acquire_buy_times",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params[1]
            	local currentNpcID = params[2]
            	app.load("client.utils.ConfirmTip")
                local function sureFunc(sender, sure_number)
                    if sure_number ~= 0 then
                        return
                    end
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
	                            response.node:onUpdateDraw()
	                        end
                        end
                    end
	                protocol_command.basic_consumption.param_list = "22".."\r\n"..currentNpcID
	                NetworkManager:register(protocol_command.basic_consumption.code, nil, nil, nil, cell, responseCallback, false, nil)
                end

                local buy_times = tonumber(_ED.npc_current_buy_count[tonumber(currentNpcID)]) + 1
                local total_reset_times = dms.int(dms["base_consume"], 22, base_consume.vip_0_value + tonumber(_ED.vip_grade))
                if buy_times > total_reset_times then
                	app.load("client.utils.SmResetDuplicateTip")
                	state_machine.excute("sm_reset_duplicate_tip_open", 0, nil)
                	-- TipDlg.drawTextDailog(_new_interface_text[211])
                	return
                end
                local reset_info = zstring.split(dms.string(dms["copy_config"], 1, copy_config.param), ",")
                local cost = reset_info[buy_times]
                local tip = ConfirmTip:new()
                tip:init(instance, sureFunc, string.format(_new_interface_text[210], cost, buy_times - 1))
                fwin:open(tip, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(equip_fragment_acquire_get_terminal)
		state_machine.add(equip_fragment_acquire_get_in_plist_terminal)
		state_machine.add(equip_fragment_acquire_get_close_terminal)
		state_machine.add(equip_fragment_acquire_track_raids_terminal)
		state_machine.add(equip_fragment_acquire_refresh_interface_data_terminal)
		state_machine.add(equip_fragment_acquire_refresh_the_control_terminal)
		state_machine.add(equip_fragment_acquire_buy_times_terminal)

        state_machine.init()
    end
    
    init_equip_fragment_acquire_terminal()
end

function EquipFragmentAcquire:onUpdateRaidsButton(number,m_type,typeBtn)
	local root = self.roots[1]
	local open_scene = dms.int(dms["function_param"], self.mouldId, function_param.open_scene)
	local open_npc = dms.int(dms["function_param"], self.mouldId, function_param.open_npc)
	local openFunctionId = dms.int(dms["function_param"], self.mouldId, function_param.open_function)
	local open_leve=dms.int(dms["function_param"], self.mouldId, function_param.open_leve)
	local by_open_vip=dms.int(dms["function_param"], self.mouldId, function_param.by_open_vip)

    if open_leve > zstring.tonumber(_ED.user_info.user_grade)
		or by_open_vip > tonumber(_ED.vip_grade)
		or (nil ~= open_scene and open_scene > 0 and tonumber(_ED.scene_current_state[open_scene]) < 0)
		or (nil ~= open_npc and open_npc > 0 and tonumber(_ED.npc_state[open_npc]) <= 0)
		or funOpenDrawTip(openFunctionId, false)
		then
			-- ccui.Helper:seekWidgetByName(root, "Button_sd"):setVisible(false)
			self.Button_zdsd:setVisible(false)
			self.Button_sd_ten:setVisible(false)
			self.Button_sd_three:setVisible(false)
			self.Button_sd_one:setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_1101"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_1103"):setVisible(true)
		return
	end
	if (open_scene > 0 and open_npc > 0) or dms.int(dms["function_param"], self.mouldId, function_param.genre) == 97 then
		if ccui.Helper:seekWidgetByName(root, "Button_1101"):isVisible() == true then
			-- ccui.Helper:seekWidgetByName(root, "Button_sd"):setVisible(true)
			if typeBtn == 1 then
				self.Button_zdsd:setVisible(false)
				self.Button_sd_ten:setVisible(false)
				self.Button_sd_three:setVisible(true)
				self.Button_sd_one:setVisible(true)
			end
			if typeBtn == 10 then
				self.Button_zdsd:setVisible(true)
				self.Button_sd_ten:setVisible(true)
				self.Button_sd_three:setVisible(false)
				self.Button_sd_one:setVisible(false)
			end
			ccui.Helper:seekWidgetByName(root, "Button_1101"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_1103"):setVisible(false)
		end
		self.raids_number = tonumber(number)
		-- ccui.Helper:seekWidgetByName(root, "Text_sd_n"):setString(string.format(_new_interface_text[136],zstring.tonumber(self.raids_number)))
	else
		if ccui.Helper:seekWidgetByName(root, "Button_1101"):isVisible() == true then
			ccui.Helper:seekWidgetByName(root, "Button_1101"):setVisible(true)
			-- ccui.Helper:seekWidgetByName(root, "Button_sd"):setVisible(false)
			self.Button_zdsd:setVisible(false)
			self.Button_sd_ten:setVisible(false)
			self.Button_sd_three:setVisible(false)
			self.Button_sd_one:setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_1103"):setVisible(false)
		end
		self.raids_number = 0
	end
	self.m_type = m_type
	if tonumber(m_type) == 5 then
		if ccui.Helper:seekWidgetByName(root, "Button_sd_one"):isVisible() == true then
			ccui.Helper:seekWidgetByName(root, "Text_tzcs_n"):setVisible(true)


			local addTimes = 0
			open_scene = dms.int(dms["npc"], open_npc, npc.scene_id)
			local scene_type = dms.int(dms["pve_scene"], open_scene, pve_scene.scene_type)
		    if scene_type == 1 then
		        if _ED.active_activity[100] ~= nil and _ED.active_activity[100] ~= "" then
		            addTimes = tonumber(_ED.active_activity[100].activity_Info[1].activityInfo_need_day)
		        end
		    end

			local totalAttackTimes = dms.int(dms["npc"], open_npc, npc.daily_attack_count)
			totalAttackTimes = totalAttackTimes + addTimes

			local surplusAttackCount = _ED.npc_current_attack_count[tonumber(open_npc)]

			ccui.Helper:seekWidgetByName(root, "Text_tzcs_n"):setString((totalAttackTimes - surplusAttackCount) .. "/" .. dms.int(dms["npc"], open_npc, npc.daily_attack_count))
		else
			ccui.Helper:seekWidgetByName(root, "Text_tzcs_n"):setVisible(false)
		end
	else
		ccui.Helper:seekWidgetByName(root, "Text_tzcs_n"):setVisible(false)
	end

end

function EquipFragmentAcquire:onUpdateDraw()
	local root = self.roots[1]
	local textName = ccui.Helper:seekWidgetByName(root, "Text_1101")
	local textDes = ccui.Helper:seekWidgetByName(root, "Text_1102")
	local get = ccui.Helper:seekWidgetByName(root, "Button_1101")
	local getTwo = ccui.Helper:seekWidgetByName(root, "Panel_1101")
	local notGet = ccui.Helper:seekWidgetByName(root, "Text_1103")
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_1103")
	--debug.print_r(self.mouldId,"self.mouldId")
	local name = dms.string(dms["function_param"], self.mouldId, function_param.name)
	local pic = dms.int(dms["function_param"], self.mouldId, function_param.icon)
	local id = dms.int(dms["function_param"], self.mouldId, function_param.open_function)
	local des = dms.string(dms["function_param"], self.mouldId, function_param.describe)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local describeInfo = ""
        local describeData = zstring.split(des, "|")
        for i, v in pairs(describeData) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            describeInfo = describeInfo .. word_info[3]
        end
        
        des = describeInfo
    end
	textName:setString(name)
	textDes:setString(des)
	getTwo:setSwallowTouches(false)
	local opened = true
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local open_function = dms.int(dms["function_param"], self.mouldId, function_param.open_function)
		local open_leve=dms.int(dms["function_param"], self.mouldId, function_param.open_leve)
		local sceneId=dms.int(dms["function_param"], self.mouldId, function_param.open_scene)
		local npcId=dms.int(dms["function_param"], self.mouldId, function_param.open_npc)
		local by_open_vip=dms.int(dms["function_param"], self.mouldId, function_param.by_open_vip)

        if open_leve > zstring.tonumber(_ED.user_info.user_grade)
			or by_open_vip > tonumber(_ED.vip_grade)
			or (nil ~= sceneId and sceneId > 0 and tonumber(_ED.scene_current_state[sceneId]) < 0)
			or (nil ~= npcId and npcId > 0 and tonumber(_ED.npc_state[npcId]) <= 0)
			or funOpenDrawTip(open_function, false)
			then
			opened = false
		end

		textName:setColor(cc.c3b(_quality_color[pic + 1][1], _quality_color[pic + 1][2], _quality_color[pic + 1][3]))
	else
		panel:setBackGroundImage(string.format("images/ui/function_icon/function_icon_%d.png", pic))
	end
	local level = nil
	local vipLevel = nil
	local openScene = nil
	local openNpc = nil
	if id > 0 then
		level = dms.int(dms["fun_open_condition"], id, fun_open_condition.level)
		vipLevel = dms.int(dms["fun_open_condition"], id, fun_open_condition.vip_level)
	else
		openScene = dms.int(dms["function_param"], self.mouldId, function_param.open_scene)
		openNpc = dms.int(dms["function_param"], self.mouldId, function_param.open_npc)
	end
	-- print("================",id)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local open_scene = dms.int(dms["function_param"], self.mouldId, function_param.open_scene)
		local open_npc = dms.int(dms["function_param"], self.mouldId, function_param.open_npc)
		if (open_scene > 0 and open_npc > 0) or dms.int(dms["function_param"], self.mouldId, function_param.genre) == 97 or opened == false then
		else
			local function headLayerTouchEvent(sender, evenType)
				local __spoint = sender:getTouchBeganPosition()
				local __mpoint = sender:getTouchMovePosition()
				local __epoint = sender:getTouchEndPosition()
				if ccui.TouchEventType.began == evenType then
					
				elseif evenType == ccui.TouchEventType.moved then
					
				elseif ccui.TouchEventType.ended == evenType or
					ccui.TouchEventType.canceled == evenType then
					if math.abs( __epoint.y - __spoint.y) < 8 then
						state_machine.excute("equip_fragment_acquire_get", 0, {_datas = {num = dms.int(dms["function_param"], self.mouldId, function_param.genre),_id = self.mouldId}})
					end
				end
			end
			getTwo:addTouchEventListener(headLayerTouchEvent)
		end
	elseif __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if id > 0 then
			local test = dms.string(dms["fun_open_condition"], id, fun_open_condition.task_mould)
			notGet:setString(test)
			-- print("========",dms.string(dms["fun_open_condition"], id, fun_open_condition.task_mould))
		else

		end
	end
	--> print(id,openScene,openNpc,_ED.npc_state[openNpc],_ED.scene_current_state[openScene],"------------------------------")
	if true == opened and (id <= 0 or (level <= tonumber(_ED.user_info.user_grade) and vipLevel <= tonumber(_ED.vip_grade))) then
		if dms.int(dms["function_param"], self.mouldId, function_param.genre) == -1 then
			if _ED.npc_state[openNpc] ~= nil and _ED.scene_current_state[openScene] ~= nil and 
				tonumber(_ED.scene_current_state[openScene]) > 0 and tonumber(_ED.npc_state[openNpc]) > 0 then
				get:setVisible(true)
				fwin:addTouchEventListener(get, nil, 
				{
					terminal_name = "equip_fragment_acquire_get", 
					terminal_state = 0, 
					num = dms.int(dms["function_param"], self.mouldId, function_param.genre),
					_id = self.mouldId,
					isPressedActionEnabled = true
				},
				nil,0)
				----------------
				getTwo:setSwallowTouches(false)
				local function headLayerTouchEvent(sender, evenType)
					local __spoint = sender:getTouchBeganPosition()
					local __mpoint = sender:getTouchMovePosition()
					local __epoint = sender:getTouchEndPosition()
					if ccui.TouchEventType.began == evenType then
						
					elseif evenType == ccui.TouchEventType.moved then
						
					elseif ccui.TouchEventType.ended == evenType or
						ccui.TouchEventType.canceled == evenType then
						if math.abs( __epoint.y - __spoint.y) < 8 then
							state_machine.excute("equip_fragment_acquire_get", 0, {_datas = {num = dms.int(dms["function_param"], self.mouldId, function_param.genre),_id = self.mouldId}})
						end
					end
				end
				getTwo:addTouchEventListener(headLayerTouchEvent)
			else
				notGet:setVisible(true)
			end
		else
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
				then
				local open_scene = dms.int(dms["function_param"], self.mouldId, function_param.open_scene)
				local open_npc = dms.int(dms["function_param"], self.mouldId, function_param.open_npc)
				if (open_scene > 0 and open_npc > 0) or dms.int(dms["function_param"], self.mouldId, function_param.genre) == 97 then
					if dms.int(dms["function_param"], self.mouldId, function_param.genre) == 97 then
						for i,v in pairs(_ED.npc_state) do
							if i <= 250 then
								if tonumber(v) == 3 then
									open_npc = i
								end
							else
								break
							end
						end
						open_scene = dms.int(dms["npc"], open_npc, npc.scene_id)
					end
					-- ccui.Helper:seekWidgetByName(root, "Button_sd"):setVisible(true)
					fwin:addTouchEventListener(self.Button_sd_one, nil, 
					{
						terminal_name = "equip_fragment_acquire_track_raids", 
						terminal_state = 0, 
						-- num = dms.int(dms["function_param"], self.mouldId, function_param.genre),
						-- num = dms.int(dms["function_param"], self.mouldId, function_param.genre),
						open_scene = open_scene,
						open_npc = open_npc,
						_id = self.mouldId,
						cell = self,
						raidsNumber = 1,
						isPressedActionEnabled = true
					},
					nil,0)
					fwin:addTouchEventListener(self.Button_sd_three, nil, 
					{
						terminal_name = "equip_fragment_acquire_track_raids", 
						terminal_state = 0, 
						-- num = dms.int(dms["function_param"], self.mouldId, function_param.genre),
						-- num = dms.int(dms["function_param"], self.mouldId, function_param.genre),
						open_scene = open_scene,
						open_npc = open_npc,
						_id = self.mouldId,
						raidsNumber = 3,
						cell = self,
						isPressedActionEnabled = true
					},
					nil,0)
					fwin:addTouchEventListener(self.Button_sd_ten, nil, 
					{
						terminal_name = "equip_fragment_acquire_track_raids", 
						terminal_state = 0, 
						-- num = dms.int(dms["function_param"], self.mouldId, function_param.genre),
						-- num = dms.int(dms["function_param"], self.mouldId, function_param.genre),
						open_scene = open_scene,
						open_npc = open_npc,
						_id = self.mouldId,
						raidsNumber = 10,
						cell = self,
						isPressedActionEnabled = true
					},
					nil,0)
					fwin:addTouchEventListener(self.Button_zdsd, nil, 
					{
						terminal_name = "equip_fragment_acquire_track_raids", 
						terminal_state = 0, 
						-- num = dms.int(dms["function_param"], self.mouldId, function_param.genre),
						-- num = dms.int(dms["function_param"], self.mouldId, function_param.genre),
						open_scene = open_scene,
						open_npc = open_npc,
						_id = self.mouldId,
						raidsNumber = 1000,
						cell = self,
						isPressedActionEnabled = true
					},
					nil,0)
					
				else
					get:setVisible(true)
					fwin:addTouchEventListener(get, nil, 
					{
						terminal_name = "equip_fragment_acquire_get", 
						terminal_state = 0, 
						-- num = dms.int(dms["function_param"], self.mouldId, function_param.genre),
						-- num = dms.int(dms["function_param"], self.mouldId, function_param.genre),
						_id = self.mouldId,
						isPressedActionEnabled = true
					},
					nil,0)
				end
			else
				get:setVisible(true)
				fwin:addTouchEventListener(get, nil, 
				{
					terminal_name = "equip_fragment_acquire_get", 
					terminal_state = 0, 
					-- num = dms.int(dms["function_param"], self.mouldId, function_param.genre),
					-- num = dms.int(dms["function_param"], self.mouldId, function_param.genre),
					_id = self.mouldId,
					isPressedActionEnabled = true
				},
				nil,0)
				----------------
				getTwo:setSwallowTouches(false)
				local function headLayerTouchEvent(sender, evenType)
					local __spoint = sender:getTouchBeganPosition()
					local __mpoint = sender:getTouchMovePosition()
					local __epoint = sender:getTouchEndPosition()
					if ccui.TouchEventType.began == evenType then
						
					elseif evenType == ccui.TouchEventType.moved then
						
					elseif ccui.TouchEventType.ended == evenType or
						ccui.TouchEventType.canceled == evenType then
						if math.abs( __epoint.y - __spoint.y) < 8 then
							state_machine.excute("equip_fragment_acquire_get", 0, {_datas = {num = dms.int(dms["function_param"], self.mouldId, function_param.genre),_id = self.mouldId}})
						end
					end
				end
				getTwo:addTouchEventListener(headLayerTouchEvent)
			end
		end
		------------------
	else
		notGet:setVisible(true)
	end
	
	-- 重置之后刷新次数
	if tonumber(self.m_type) == 5 then
		if ccui.Helper:seekWidgetByName(root, "Button_sd_one"):isVisible() == true and ccui.Helper:seekWidgetByName(root, "Text_tzcs_n"):isVisible() == true then
			local open_npc = dms.int(dms["function_param"], self.mouldId, function_param.open_npc)
			local addTimes = 0
			open_scene = dms.int(dms["npc"], open_npc, npc.scene_id)
			local scene_type = dms.int(dms["pve_scene"], open_scene, pve_scene.scene_type)
		    if scene_type == 1 then
		        if _ED.active_activity[100] ~= nil and _ED.active_activity[100] ~= "" then
		            addTimes = tonumber(_ED.active_activity[100].activity_Info[1].activityInfo_need_day)
		        end
		    end

			local totalAttackTimes = dms.int(dms["npc"], open_npc, npc.daily_attack_count)
			totalAttackTimes = totalAttackTimes + addTimes
			
			local surplusAttackCount = _ED.npc_current_attack_count[tonumber(open_npc)]

			ccui.Helper:seekWidgetByName(root, "Text_tzcs_n"):setString((totalAttackTimes - surplusAttackCount) .. "/" .. dms.int(dms["npc"], open_npc, npc.daily_attack_count))
		end
	end

end

function EquipFragmentAcquire:onEnterTransitionFinish()
    local csbEquipFragmentAcquire = csb.createNode("packs/to_get_list.csb")
    self:addChild(csbEquipFragmentAcquire)
	local root = csbEquipFragmentAcquire:getChildByName("root")
	table.insert(self.roots, root)
	
	local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
	local MySize = Panel_2:getContentSize()
	self:setContentSize(MySize)

	self.Button_zdsd = ccui.Helper:seekWidgetByName(root, "Button_zdsd")
	self.Button_sd_three = ccui.Helper:seekWidgetByName(root, "Button_sd_three")
	self.Button_sd_ten = ccui.Helper:seekWidgetByName(root, "Button_sd_ten")
	self.Button_sd_one = ccui.Helper:seekWidgetByName(root, "Button_sd_one")
	
	self:onUpdateDraw()
end

function EquipFragmentAcquire:init(_id)
	self.mouldId = _id		--获得途径id
end

function EquipFragmentAcquire:onExit()
	state_machine.remove("equip_fragment_acquire_get")
	state_machine.remove("equip_fragment_acquire_get_in_plist")
	state_machine.remove("equip_fragment_acquire_get_close")
end

function EquipFragmentAcquire:createCell()
	local cell = EquipFragmentAcquire:new()
	cell:registerOnNodeEvent(cell)
	return cell
end