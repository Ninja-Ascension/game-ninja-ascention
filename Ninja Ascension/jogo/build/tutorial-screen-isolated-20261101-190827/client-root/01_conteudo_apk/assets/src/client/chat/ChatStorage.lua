----------------------------------------------------------------------------------------------------
-- 说明：聊天主界面--
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ChatStorage = class("ChatStorageClass", Window)
    
function ChatStorage:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.types = nil
	self.lock_state = true
	self.button_lock = nil 
	_ED.chat_lock_state = false
	
	app.load("client.chat.ChatWorldPage")
	app.load("client.chat.ChatWhisperPage")
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
		and ___is_open_union == true
		 then
		app.load("client.chat.ChatUnionPage")
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		app.load("client.chat.ChatUnionPage")
		app.load("client.l_digital.chat.ChatSystemPage")
		app.load("client.l_digital.chat.ChatTeamPage")
	end
    -- Initialize ChatStorage page state machine.
    local function init_chat_storage_terminal()
		--返回home界面
		local chat_return_home_page_terminal = {
            _name = "chat_return_home_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("chat_show_change_button", 0, "click chat_show_change_button.'")
				state_machine.excute("chat_world_page_close", 0, "click chat_world_page_close.'")
				state_machine.excute("chat_whisper_page_close", 0, "click chat_whisper_page_close.'")
				state_machine.excute("sm_chat_view_open_chat_updata_open_state", 0, "")
				if (__lua_project_id == __lua_project_warship_girl_a 
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh)
					and ___is_open_union == true
	   				then
	   				state_machine.excute("union_world_page_close", 0, "click union_world_page_close.'")
	   			end
	   			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					state_machine.excute("union_world_page_close", 0, "click union_world_page_close.'")
					state_machine.excute("chat_team_page_close", 0, "click chat_team_page_close.'")
					state_machine.excute("chat_system_page_close", 0, "click chat_system_page_close.'")
				end
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					if params == false then
						fwin:close(instance)
					else
						local action = instance.actions[1]
						instance.actions[1]:play("window_close", false)
					end
				else	
					local cell = params._datas.cell
					fwin:close(cell)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--世界聊天界面
		local chat_show_chat_page_in_world_terminal = {
            _name = "chat_show_chat_page_in_world",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDrawOne()
				if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_0") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_0"):setVisible(true)
				end
				if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0"):setVisible(false)
				end
				if (__lua_project_id == __lua_project_warship_girl_a 
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh)
					and ___is_open_union == true
					 then
	   				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_2"):setVisible(false)
	   			end
				if __lua_project_id == __lua_project_gragon_tiger_gate 
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_1"):setHighlighted(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_3"):setHighlighted(false)
				end
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2") ~= nil then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2"):setVisible(false) 
					end
					if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_4") ~= nil then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_4"):setVisible(false)
					end
					if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_5") ~= nil then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_5"):setVisible(false)
					end
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_2"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_4"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_5"):setHighlighted(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--军团聊天界面
		local chat_show_chat_page_in_union_terminal = {
            _name = "chat_show_chat_page_in_union",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	            if (__lua_project_id == __lua_project_warship_girl_a 
			    	or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
			    	or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh )
	            	and ___is_open_union == true
	            	then
	            	if _ED.union.union_info == nil or _ED.union.union_info == {} or _ED.union.union_info.union_id == nil or _ED.union.union_info.union_id == "" then
	            		if __lua_project_id == __lua_project_digimon_adventure 
							or __lua_project_id == __lua_project_naruto 
	            			or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
	            			or __lua_project_id == __lua_project_yugioh 
	            			or __lua_project_id == __lua_project_warship_girl_b 
	            			then 
	            			TipDlg.drawTextDailog(tipStringInfo_union_str[69])
	            		end
	            	else
		            	instance:onUpdateDrawTwo()
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_0"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_2"):setVisible(true)
					end
				elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
	   				-- if _ED.union.union_info == nil or _ED.union.union_info == {} or _ED.union.union_info.union_id == nil or _ED.union.union_info.union_id == "" then
	       --      		TipDlg.drawTextDailog(tipStringInfo_union_str[69])
	       --      	else
		            	instance:onUpdateDrawTwo()
		            	if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_0") ~= nil then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_0"):setVisible(false)
						end
						if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0") ~= nil then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0"):setVisible(false)
						end
						if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2") ~= nil then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2"):setVisible(true)
						end
						if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_4") ~= nil then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_4"):setVisible(false)
						end
						if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_5") ~= nil then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_5"):setVisible(false)
						end
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_1"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_2"):setHighlighted(true)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_3"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_4"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_5"):setHighlighted(false)
					-- end
				else
					if (__lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto)
						and app.configJson.OperatorName == "gamedreamer" 
						then
						handlePlatformRequest(0, CC_SYSTEM_PAUSE, _ED.user_info.user_name)
					else
						handlePlatformRequest(0, CC_OPEN_URL_LAYOUT, app.configJson.urlweb)
					end
	   			end
				-- instance:onUpdateDrawTwo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--私聊界面
		local chat_show_chat_page_in_another_terminal = {
            _name = "chat_show_chat_page_in_another",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDrawThree()
				_ED.findNewWhisper = 0
				if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_0") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_0"):setVisible(false)
				end
				if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0"):setVisible(true)
				end
				if (__lua_project_id == __lua_project_warship_girl_a 
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh)
					and  ___is_open_union == true
 					then
	   				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_2"):setVisible(false)
	   			end
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert
					then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_3"):setHighlighted(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_1"):setHighlighted(false)
				end

				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2") ~= nil then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2"):setVisible(false)
					end
					if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_4") ~= nil then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_4"):setVisible(false)
					end
					if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_5") ~= nil then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_5"):setVisible(false)
					end
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_2"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_4"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_5"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_3"):setHighlighted(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_1"):setHighlighted(false)
					state_machine.excute("notification_center_update", 0, "push_notification_center_whisper_chat")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local chat_whisper_page_other_terminal = {
            _name = "chat_whisper_page_other",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- 更新信息
				local pageOne = fwin:find("ChatWorldPageClass")
				local pageTwo = fwin:find("ChatUnionPageClass")
				local pageThree = fwin:find("ChatWhisperPageClass")
				local pageFour = fwin:find("ChatSystemPageClass")
				local pageFive = fwin:find("ChatTeamPageClass")
				
				if pageOne ~= nil then
					pageOne:setVisible(false)
				end
				
				if pageTwo ~= nil then
					pageTwo:setVisible(false)
				end
				
				if pageThree == nil then
					local cell = ChatWhisperPage:new()
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						local Panel_jildf = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_jildf")
						cell:init(params , Panel_jildf)
					else
						cell:init(params)
					end
					fwin:open(cell,fwin._windows)
					cell:byChild()

				else
					pageThree:setVisible(true)
					pageThree:init(params)
					pageThree:byChild()
				end

				if pageFour ~= nil then
					pageFour:setVisible(false)
				end
				if pageFive ~= nil then
					pageFive:setVisible(false)
				end
				if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_0") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_0"):setVisible(false)
				end
				if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0"):setVisible(true)
				end
				if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b)
					and ___is_open_union == true
					 then
	   				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_2"):setVisible(false)
	   			end
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					or __lua_project_id == __lua_project_red_alert 
					then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_3"):setHighlighted(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_1"):setHighlighted(false)
				end
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2") ~= nil then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2"):setVisible(false)
					end
					if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_4") ~= nil then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_4"):setVisible(false)
					end
					if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_5") ~= nil then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_5"):setVisible(false)
					end
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_2"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_4"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_5"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_3"):setHighlighted(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_1"):setHighlighted(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --GM
		local chat_show_chat_page_in_gm_terminal = {
            _name = "chat_show_chat_page_in_gm",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if (__lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) 
					and app.configJson.OperatorName == "gamedreamer" then
					handlePlatformRequest(0, CC_SYSTEM_PAUSE, _ED.user_info.user_name)
				else
					handlePlatformRequest(0, CC_OPEN_URL_LAYOUT, app.configJson.urlweb)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --系统聊天界面
		local chat_show_chat_page_in_system_terminal = {
            _name = "chat_show_chat_page_in_system",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:onUpdateDrawFour()
            	if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_0") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_0"):setVisible(false)
				end
				if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0"):setVisible(false)
				end
				if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2"):setVisible(false)
				end
				if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_4") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_4"):setVisible(true)
				end
				if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_5") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_5"):setVisible(false)
				end
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_1"):setHighlighted(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_2"):setHighlighted(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_3"):setHighlighted(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_4"):setHighlighted(true)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_5"):setHighlighted(false)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--组队聊天界面
		local chat_show_chat_page_in_team_terminal = {
            _name = "chat_show_chat_page_in_team",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:onUpdateDrawFive()
            	if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_0") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_0"):setVisible(false)
				end
				if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0"):setVisible(false)
				end
				if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2"):setVisible(false)
				end
				if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_4") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_4"):setVisible(false)
				end
				if ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_5") ~= nil then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_5"):setVisible(true)
				end
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_1"):setHighlighted(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_2"):setHighlighted(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_3"):setHighlighted(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_4"):setHighlighted(false)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chat_5"):setHighlighted(true)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --数码锁屏
		local sm_chat_view_lock_state_change_terminal = {
            _name = "sm_chat_view_lock_state_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local button_textures1 = "images/ui/text/chat/sjlt_btn_sp1.png"
            	local button_textures2 = "images/ui/text/chat/sjlt_btn_sp2.png"
				if instance.lock_state == false then
					instance.lock_state = true 
					_ED.chat_lock_state = true 
				else
					instance.lock_state = false 
					_ED.chat_lock_state = false 
				end
				if instance.lock_state == true then
					self.button_lock:loadTextures(button_textures2,button_textures2,button_textures2)
				else
					self.button_lock:loadTextures(button_textures1,button_textures1,button_textures1)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_chat_view_update_all_info_terminal = {
            _name = "sm_chat_view_update_all_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local pageOne = fwin:find("ChatWorldPageClass")
				local pageTwo = fwin:find("ChatUnionPageClass")
				local pageThree = fwin:find("ChatWhisperPageClass")
				local pageFour = fwin:find("ChatSystemPageClass")
				local pageFive = fwin:find("ChatTeamPageClass")
				if pageOne ~= nil and pageOne:isVisible() == true then
            		state_machine.excute("chat_world_page_updata",0,"chat_world_page_updata.")
            	end
            	if pageTwo ~= nil and pageTwo:isVisible() == true then
	    			state_machine.excute("chat_union_page_updata",0,"chat_union_page_updata.")
	    		end
	    		if pageThree ~= nil and pageThree:isVisible() == true then
	    			state_machine.excute("chat_whisper_page_updata",0,"chat_whisper_page_updata.")
	    		end
	    		if pageFour ~= nil and pageFour:isVisible() == true then
	    			state_machine.excute("chat_system_page_updata",0,"chat_system_page_updata.")
	    		end
	    		if pageFive ~= nil and pageFive:isVisible() == true then
	    			state_machine.excute("chat_team_page_updata",0,"chat_team_page_updata.")
	    		end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 调用聊天框上移，下移动作
		-- 1上移 2下移
		local sm_chat_view_play_action_terminal = {
			_name = "sm_chat_view_play_action",
			_init = function (terminal) 

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local playType = params
					local action = self.actions[1]
					if action then
						if playType == 1 then
							action:play("window_up", false)
						elseif playType == 2 then
							action:play("window_down", false)
						end
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(chat_whisper_page_other_terminal)
		state_machine.add(chat_return_home_page_terminal)
		state_machine.add(chat_show_chat_page_in_world_terminal)
		state_machine.add(chat_show_chat_page_in_union_terminal)
		state_machine.add(chat_show_chat_page_in_another_terminal)
		state_machine.add(chat_show_chat_page_in_system_terminal)
		state_machine.add(chat_show_chat_page_in_team_terminal)
		state_machine.add(sm_chat_view_lock_state_change_terminal)
		state_machine.add(sm_chat_view_update_all_info_terminal)
		state_machine.add(sm_chat_view_play_action_terminal)

		if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
			and ___is_open_union == true
			 then
			state_machine.add(chat_show_chat_page_in_gm_terminal)
		end

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_chat_storage_terminal()
end

function ChatStorage:onUpdateDrawOne()
	local root = self.roots[1]
	local pageOne = fwin:find("ChatWorldPageClass")
	local pageTwo = fwin:find("ChatUnionPageClass")
	local pageThree = fwin:find("ChatWhisperPageClass")
	local pageFour = fwin:find("ChatSystemPageClass")
	local pageFive = fwin:find("ChatTeamPageClass")
	
	if pageTwo ~= nil then
		-- pageTwo:setVisible(false)
		state_machine.excute("chat_union_page_hide", 0, nil)
	end
	if pageThree ~= nil then
		-- pageThree:setVisible(false)
		state_machine.excute("chat_whisper_page_hide", 0, nil)
	end
	if pageFour ~= nil then
		-- pageFour:setVisible(false)
		state_machine.excute("chat_system_page_hide", 0, nil)
	end
	if pageFive ~= nil then
		-- pageFive:setVisible(false)
		state_machine.excute("chat_team_page_hide", 0, nil)
	end
	if pageOne == nil and not _ED.chat_lock_state then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local Panel_jildf = ccui.Helper:seekWidgetByName(root, "Panel_jildf")
			fwin:open(ChatWorldPage:new():init(Panel_jildf),fwin._windows)
		else
			fwin:open(ChatWorldPage:new(),fwin._windows)
		end
	else
		-- pageOne:setVisible(true)
		-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then 
		-- 	state_machine.excute("chat_world_page_updata",0,"chat_world_page_updata.")
		-- end
		state_machine.excute("chat_world_page_show", 0, nil)
	end
end

function ChatStorage:onUpdateDrawTwo()
	local root = self.roots[1]
	local pageOne = fwin:find("ChatWorldPageClass")
	local pageTwo = fwin:find("ChatUnionPageClass")
	local pageThree = fwin:find("ChatWhisperPageClass")
	local pageFour = fwin:find("ChatSystemPageClass")
	local pageFive = fwin:find("ChatTeamPageClass")
	
	if pageOne ~= nil then
		-- pageOne:setVisible(false)
		state_machine.excute("chat_world_page_hide", 0, nil)
	end
	if pageThree ~= nil then
		-- pageThree:setVisible(false)
		state_machine.excute("chat_whisper_page_hide", 0, nil)
	end
	if pageFour ~= nil then
		-- pageFour:setVisible(false)
		state_machine.excute("chat_system_page_hide", 0, nil)
	end
	if pageFive ~= nil then
		-- pageFive:setVisible(false)
		state_machine.excute("chat_team_page_hide", 0, nil)
	end
	if pageTwo == nil and not _ED.chat_lock_state then
		if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) 
			and ___is_open_union == true
			 then
		 	local Panel_jildf = ccui.Helper:seekWidgetByName(root, "Panel_jildf")
			fwin:open(ChatUnionPage:new():init(Panel_jildf),fwin._windows)
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local Panel_jildf = ccui.Helper:seekWidgetByName(root, "Panel_jildf")
			fwin:open(ChatUnionPage:new():init(Panel_jildf),fwin._windows)
		end
	else
		-- pageTwo:setVisible(true)
		-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then 
		-- 	state_machine.excute("chat_union_page_updata",0,"chat_union_page_updata.")
		-- end
		state_machine.excute("chat_union_page_show", 0, nil)
	end
end

function ChatStorage:onUpdateDrawThree()
	local root = self.roots[1]
	local pageOne = fwin:find("ChatWorldPageClass")
	local pageTwo = fwin:find("ChatUnionPageClass")
	local pageThree = fwin:find("ChatWhisperPageClass")
	local pageFour = fwin:find("ChatSystemPageClass")
	local pageFive = fwin:find("ChatTeamPageClass")
	
	if pageOne ~= nil then
		-- pageOne:setVisible(false)
		state_machine.excute("chat_world_page_hide", 0, nil)
	end
	if pageTwo ~= nil then
		-- pageTwo:setVisible(false)
		state_machine.excute("chat_union_page_hide", 0, nil)
	end
	if pageFour ~= nil then
		-- pageFour:setVisible(false)
		state_machine.excute("chat_system_page_hide", 0, nil)
	end
	if pageFive ~= nil then
		-- pageFive:setVisible(false)
		state_machine.excute("chat_team_page_hide", 0, nil)
	end
	
	if pageThree == nil and not _ED.chat_lock_state then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local Panel_jildf = ccui.Helper:seekWidgetByName(root, "Panel_jildf")
			fwin:open(ChatWhisperPage:new():init( nil , Panel_jildf),fwin._windows)
		else
			fwin:open(ChatWhisperPage:new(),fwin._windows)
		end
	else
		-- pageThree:setVisible(true)
		-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then 
		-- 	state_machine.excute("chat_whisper_page_updata",0,"chat_whisper_page_updata.")
		-- end
		state_machine.excute("chat_whisper_page_show", 0, nil)
	end
end

function ChatStorage:onUpdateDrawFour()
	local root = self.roots[1]
	local pageOne = fwin:find("ChatWorldPageClass")
	local pageTwo = fwin:find("ChatUnionPageClass")
	local pageThree = fwin:find("ChatWhisperPageClass")
	local pageFour = fwin:find("ChatSystemPageClass")
	local pageFive = fwin:find("ChatTeamPageClass")
	
	if pageOne ~= nil then
		-- pageOne:setVisible(false)
		state_machine.excute("chat_world_page_hide", 0, nil)
	end
	if pageTwo ~= nil then
		-- pageTwo:setVisible(false)
		state_machine.excute("chat_union_page_hide", 0, nil)
	end
	if pageThree ~= nil then
		-- pageThree:setVisible(false)
		state_machine.excute("chat_whisper_page_hide", 0, nil)
	end
	if pageFive ~= nil then
		-- pageFive:setVisible(false)
		state_machine.excute("chat_team_page_hide", 0, nil)
	end
	if pageFour == nil and not _ED.chat_lock_state then
		fwin:open(ChatSystemPage:new(),fwin._windows)
	else
		-- pageFour:setVisible(true)
		-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then 
		-- 	state_machine.excute("chat_system_page_updata",0,"chat_system_page_updata.")
		-- end
		state_machine.excute("chat_system_page_show", 0, nil)
	end
end

function ChatStorage:onUpdateDrawFive()
	local root = self.roots[1]
	local pageOne = fwin:find("ChatWorldPageClass")
	local pageTwo = fwin:find("ChatUnionPageClass")
	local pageThree = fwin:find("ChatWhisperPageClass")
	local pageFour = fwin:find("ChatSystemPageClass")
	local pageFive = fwin:find("ChatTeamPageClass")
	
	if pageOne ~= nil then
		-- pageOne:setVisible(false)
		state_machine.excute("chat_world_page_hide", 0, nil)
	end
	if pageTwo ~= nil then
		-- pageTwo:setVisible(false)
		state_machine.excute("chat_union_page_hide", 0, nil)
	end
	if pageThree ~= nil then
		-- pageThree:setVisible(false)
		state_machine.excute("chat_whisper_page_hide", 0, nil)
	end
	if pageFour ~= nil then
		-- pageFour:setVisible(false)
		state_machine.excute("chat_system_page_hide", 0, nil)
	end
	
	if pageFive == nil and not _ED.chat_lock_state then
		fwin:open(ChatTeamPage:new(),fwin._windows)
	else
		-- pageFive:setVisible(true)
		-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then 
		-- 	state_machine.excute("chat_team_page_updata",0,"chat_team_page_updata.")
		-- end
		state_machine.excute("chat_team_page_show", 0, nil)
	end
end

function ChatStorage:updateSelect()
	local root = self.roots[1]
	local isSelected = ccui.Helper:seekWidgetByName(root, "CheckBox_chat"):isSelected()
	
	if isSelected == false then
		state_machine.excute("chat_show_self", 0, "click chat_show_self.'")
	else
		state_machine.excute("chat_hide_self", 0, "click chat_hide_self.'")
	end
end

function ChatStorage:onEnterTransitionFinish()
	_ED._last_send_chat_time = _ED._last_send_chat_time or 0
    local csbChatStorage = csb.createNode("Chat/chat.csb")
    self:addChild(csbChatStorage)
	local root = csbChatStorage:getChildByName("root")
	table.insert(self.roots, root)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert  then
		local action = csb.createTimeline("Chat/chat.csb") 
		table.insert(self.actions, action )
		csbChatStorage:runAction(action)
		action:play("window_open", false)

		action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end
	        local str = frame:getEvent()
	        if str == "window_close_over" then
	        	fwin:close(self)
			elseif str == "window_open_over" then
				-- iphone刘海适配
				local Panel_jildf = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_jildf")
				if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and Panel_jildf and isIphoneX() then 
					Panel_jildf:setPositionX(Panel_jildf:getPositionX()+80)
				end
	        	if self.types == nil then
	        		state_machine.excute("chat_show_chat_page_in_world", 0, "click chat_show_chat_page_in_world.'")
	        	end
	        end
	    end)
		
	end
	
	local return_home = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_410"), nil, {terminal_name = "chat_return_home_page", terminal_state = 0, isPressedActionEnabled = true, cell = self}, nil, 0)
	
	--聊天
	local setPressedActionEnabled = true
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		setPressedActionEnabled = false
	end
	local shijie  = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_1"), nil, {func_string = [[state_machine.excute("chat_show_chat_page_in_world", 0, "click chat_show_chat_page_in_world.'")]],isPressedActionEnabled = setPressedActionEnabled}, nil, 0)
	local juntuan = nil
	local siliao  = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_3"), nil, {func_string = [[state_machine.excute("chat_show_chat_page_in_another", 0, "click chat_show_chat_page_in_another.'")]],isPressedActionEnabled = setPressedActionEnabled}, nil, 0)
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
		and ___is_open_union == true
	 	then
	 	local unionButton = ccui.Helper:seekWidgetByName(root, "Button_chat_4")
	 	unionButton:setVisible(true)
		juntuan = fwin:addTouchEventListener(unionButton, nil, {func_string = [[state_machine.excute("chat_show_chat_page_in_union", 0, "click chat_show_chat_page_in_union.'")]],isPressedActionEnabled = setPressedActionEnabled}, nil, 0)
		local Gm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_2"), nil, {func_string = [[state_machine.excute("chat_show_chat_page_in_gm", 0, "click chat_show_chat_page_in_gm.'")]],isPressedActionEnabled = setPressedActionEnabled}, nil, 0)
	else
		juntuan = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_2"), nil, {func_string = [[state_machine.excute("chat_show_chat_page_in_union", 0, "click chat_show_chat_page_in_union.'")]],isPressedActionEnabled = setPressedActionEnabled}, nil, 0)
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		shijie:setHighlighted(true)
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_world_chat",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_chat_1"),
		_invoke = nil,
		_interval = 0.5,})
	end
		
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_whisper_chat",
	_widget = ccui.Helper:seekWidgetByName(root, "Button_chat_3"),
	_invoke = nil,
	_interval = 0.5,})

	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
		and ___is_open_union == true
		 then
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_chat",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_chat_4"),
		_invoke = nil,
		_interval = 0.5,})
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local system  = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_4"), nil, {func_string = [[state_machine.excute("chat_show_chat_page_in_system", 0, "click chat_show_chat_page_in_system.'")]],isPressedActionEnabled = setPressedActionEnabled}, nil, 0)
		local team  = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_5"), nil, {func_string = [[state_machine.excute("chat_show_chat_page_in_team", 0, "click chat_show_chat_page_in_team.'")]],isPressedActionEnabled = setPressedActionEnabled}, nil, 0)
		
		--NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
	else
		state_machine.excute("chat_show_chat_page_in_world", 0, "click chat_show_chat_page_in_world.'")
		
	end

	local Button_chat_lock = ccui.Helper:seekWidgetByName(root, "Button_chat_lock")
	if Button_chat_lock ~= nil then
		fwin:addTouchEventListener(Button_chat_lock,nil, 
	    {
	        terminal_name = "sm_chat_view_lock_state_change",     
	        terminal_state = 0, 
	    }, 
	    nil, 0)
	    self.button_lock = Button_chat_lock
	    state_machine.excute("sm_chat_view_lock_state_change", 0, "")
	end
	
	local CheckBox_chat = ccui.Helper:seekWidgetByName(root, "CheckBox_chat")
	local status = false
	local chatView = fwin:find("ChatHomeViewClass")
	if chatView ~= nil then
		if chatView:isVisible() == false then
			status = false
			if CheckBox_chat ~= nil then
				CheckBox_chat:setSelected(false)
			end
		else
			status = true
			if CheckBox_chat ~= nil then
				CheckBox_chat:setSelected(true)
			end
		end
	end
	
	local function onOpenTouchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
		elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			self:updateSelect()
		end
	end
	if CheckBox_chat ~= nil then
		CheckBox_chat:addTouchEventListener(onOpenTouchEvent)
	end
end

function ChatStorage:init(types)
	self.types = types
end

function ChatStorage:onExit()
	state_machine.remove("chat_return_home_page")
	state_machine.remove("chat_show_chat_page_in_world")
	state_machine.remove("chat_show_chat_page_in_union")
	state_machine.remove("chat_show_chat_page_in_another")
	state_machine.remove("chat_whisper_page_other")
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
		and ___is_open_union == true
		 then
		state_machine.remove("chat_show_chat_page_in_gm")
	end
	state_machine.remove("chat_show_chat_page_in_system")
	state_machine.remove("chat_show_chat_page_in_team")
	state_machine.remove("sm_chat_view_lock_state_change")
	state_machine.remove("sm_chat_view_update_all_info")
	state_machine.remove("sm_chat_view_play_action")
end
