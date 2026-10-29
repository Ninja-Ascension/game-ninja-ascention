-- ----------------------------------------------------------------------------------------------------
-- 说明：征战主界面（包含竞技场等。。。）
-- 创建时间
-- 作者：胡文轩
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
Campaign = class("CampaignClass", Window)

function Campaign:ctor()
    self.super:ctor()
    self.roots = {}
	self.pages={}
	self.pages_copy={}
    self.runState = 0
	self.nowPageIndex=6
	self.liliandonghua=nil
	self.bool1=false
	self.bool2=false
	self.bool3=false
	self.bool4=false
	self.bool5=false
	self.bool6=false --新添加排位赛
	self.bool7=false
	self.bool8=false --新增宠物
	self._initPages = 0
	self.bool_init=false
    resetMission(false)
	
    app.load("client.campaign.arena.Arena")
	app.load("client.campaign.plunder.Plunder")
	app.load("client.campaign.mine.MineManager")
	app.load("client.campaign.trialtower.TrialTower")
	app.load("client.campaign.worldboss.WorldBoss")
	app.load("client.player.EquipPlayerInfomation") 
    -- Initialize campaign page state machine.
    local function init_campaign_terminal()
	
		--竞技场
		local campaign_show_arena_terminal = {
            _name = "campaign_show_arena",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if nil == fwin:find("CampaignClass") then
					return
				end
				
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					local function openArenaPanel( ... )
						if nil ~= fwin:find("CampaignClass") then
							-- state_machine.excute("menu_clean_page_state_campaign", 0,"") 
							-- -- fwin:close(fwin:find("CampaignClass"))
							-- fwin:find("CampaignClass"):setVisible(false)
							state_machine.excute("campaign_window_hide",0,"")
							-- fwin:cleanView(fwin._view)
							local win = Arena:new()
							win:init(nil, true)
							fwin:open(win, fwin._view)	
						end
					end
					-- if _ED.arena_user_rank == nil or _ED.arena_user_rank == "" or tonumber(_ED.arena_user_rank) == nil then
						if instance.registerArena ~= true then
							instance.registerArena = true
							local function responseArenaInitCallback(response)
								if nil == fwin:find("CampaignClass") then
									return
								end
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									openArenaPanel()
								end
								instance.registerArena = false
							end
							protocol_command.arena_init.param_list = "0"
							NetworkManager:register(protocol_command.arena_init.code, nil, nil, nil, nil, responseArenaInitCallback, false, nil)
						end
					-- else
					-- 	openArenaPanel()
					-- end
				else
					if instance.registerArena ~= true then
						instance.registerArena = true
						---[[
						local function responseArenaInitCallback(response)
							if nil == fwin:find("CampaignClass") then
								return
							end
					
							instance.registerArena = false
							
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								
								if nil ~= fwin:find("CampaignClass") then
							
									state_machine.excute("menu_clean_page_state", 0,"") 
									fwin:cleanView(fwin._view) 
									local win = Arena:new()
									win:init(nil, true)
									fwin:open(win, fwin._view)	
									fwin:close(fwin:find("CampaignClass"))
								
								end
							end
						end
						protocol_command.arena_init.param_list = "0"
						NetworkManager:register(protocol_command.arena_init.code, nil, nil, nil, nil, responseArenaInitCallback, false, nil)
						--]]
					end
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--夺宝
		local campaign_show_snatch_terminal = {
            _name = "campaign_show_snatch",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
     --        		state_machine.excute("menu_clean_page_state_campaign", 0,"") 
					-- fwin:find("CampaignClass"):setVisible(false)
					state_machine.excute("campaign_window_hide",0,"")
					fwin:open(Plunder:new(), fwin._view)
            	else
					state_machine.excute("menu_clean_page_state", 0,"") 
					fwin:cleanView(fwin._view) 
					fwin:open(Plunder:new(), fwin._view)	
					fwin:close(fwin:find("CampaignClass"))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--领地攻讨
		local campaign_show_mineral_res_terminal = {
            _name = "campaign_show_mineral_res",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	    --         	state_machine.excute("menu_clean_page_state_campaign", 0,"") 
					-- fwin:find("CampaignClass"):setVisible(false)
					state_machine.excute("campaign_window_hide",0,"")
					fwin:open(MineManager:new(), fwin._view)
				else
					state_machine.excute("menu_clean_page_state", 0,"") 
	            	fwin:cleanView(fwin._view) 
					
					fwin:open(MineManager:new(), fwin._view)	
					fwin:close(fwin:find("CampaignClass"))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--围剿叛军
		local campaign_show_palace_terminal = {
            _name = "campaign_show_palace",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			    --         	state_machine.excute("menu_clean_page_state_campaign", 0,"") 
							-- fwin:find("CampaignClass"):setVisible(false)
							state_machine.excute("campaign_window_hide",0,"")
							fwin:open(WorldBoss:new(), fwin._view)
						else
							state_machine.excute("menu_clean_page_state", 0,"") 
							fwin:cleanView(fwin._view) 
							fwin:open(WorldBoss:new(), fwin._view)	
							fwin:close(fwin:find("CampaignClass"))
						end
						-- print("===111111111==============")
					end
				end
				-- print("=====222222222222============")
				NetworkManager:register(protocol_command.rebel_army_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--三国无双
		local campaign_show_trial_tower_terminal = {
            _name = "campaign_show_trial_tower",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				--local user_grade=dms.string(dms["fun_open_condition"], 19, fun_open_condition.level)
				--> debug.log(true, "_ED.user_info.user_grade",_ED.user_info.user_grade)
				--if tonumber(_ED.user_info.user_grade) >= 19 then
					local function responseKingdomsCallback(response)
						
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				    			state_machine.excute("campaign_window_hide",0,"")
				    --         	state_machine.excute("menu_clean_page_state_campaign", 0,"") 
								-- fwin:find("CampaignClass"):setVisible(false)
								fwin:open(TrialTower:new(), fwin._view)
							else
								state_machine.excute("menu_clean_page_state", 0,"") 
								fwin:cleanView(fwin._view) 
								fwin:open(TrialTower:new(), fwin._view)
								fwin:close(fwin:find("CampaignClass"))
							end
						end
					end

					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						if _ED.three_kingdoms_view == nil or _ED.three_kingdoms_view.current_max_stars == "" or _ED.three_kingdoms_view.current_max_stars == nil then
							NetworkManager:register(protocol_command.three_kingdoms_init.code, nil, nil, nil, nil, responseKingdomsCallback, false, nil)	
						else
							responseKingdomsCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
						end
					else
						NetworkManager:register(protocol_command.three_kingdoms_init.code, nil, nil, nil, nil, responseKingdomsCallback, true, nil)					
					end

					
				-- else
					-- local csbTrialTower = csb.createNode("utils/congratulations_to_btain.csb")	
					-- local csbTrialTower_root = csbTrialTower:getChildByName("root")
					-- table.insert(self.roots, csbTrialTower_root)
					-- self:addChild(csbTrialTower)
					-- dubug.log(true,dms.string(dms["fun_open_condition"], 19, fun_open_condition.tip_info))
				-- end	
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--排位赛
		local campaign_show_warcraft_terminal = {
            _name = "campaign_show_warcraft",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function responseWarcraftInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraft")
						fwin:open(AdventureArenaWarcraft:new(), fwin._view)
                    end
                end
 				local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
	 			protocol_command.warcraft_info_init.param_list = currentServerNumber
                NetworkManager:register(protocol_command.warcraft_info_init.code, _ED.union_fight_url, nil, nil, nil, responseWarcraftInitCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 国战
        local campaign_show_nationalwar_terminal = {
            _name = "campaign_show_nationalwar",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("configs.csb.config")
				app.load("configs.sprite.config")
        	    app.load("client.red_alert.campaign.nationalwar.NationalTruce")
				app.load("client.red_alert.campaign.nationalwar.NationalTruceLoading")
				app.load("client.utils.DrawHelper")
			    local function responseNationalTaskCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("national_truce_open",0,"")
                    end
                end
                protocol_command.get_warfare_task.param_list = ""
                NetworkManager:register(protocol_command.get_warfare_task.code, nil, nil, nil, nil, responseNationalTaskCallback, false, nil)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--战宠副本
		local campaign_show_pet_duplicate_terminal = {
            _name = "campaign_show_pet_duplicate",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	 local function responsePetDuplicateCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	fwin:close(fwin:find("CampaignClass"))
                        app.load("client.campaign.battlefield.BattleField")
            			state_machine.excute("battle_field_window_open",0,"")
                    end
                end
                NetworkManager:register(protocol_command.pet_counterpart_init.code, nil, nil, nil, nil, responsePetDuplicateCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	--------------------------------------------------------------------------------------------------
	
		--竞技场 灰色
		local campaign_show_arena_invalid_terminal = {
            _name = "campaign_show_arena_invalid",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 16, fun_open_condition.tip_info))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--夺宝 灰色
		local campaign_show_snatch_invalid_terminal = {
            _name = "campaign_show_snatch_invalid",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 15, fun_open_condition.tip_info))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--领地攻讨 灰色
		local campaign_show_palace_invalid_terminal = {
            _name = "campaign_show_palace_invalid",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 12, fun_open_condition.tip_info))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--围剿叛军 灰色
		local campaign_show_mineral_res_invalid_terminal = {
            _name = "campaign_show_mineral_res_invalid",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 13, fun_open_condition.tip_info))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--三国无双 灰色
		local campaign_show_trial_tower_invalid_terminal = {
            _name = "campaign_show_trial_tower_invalid",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 14, fun_open_condition.tip_info))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --排位赛 灰色
		local campaign_show_warcraft_invalid_terminal = {
            _name = "campaign_show_warcraft_invalid",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
            		TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 57, fun_open_condition.tip_info))
            	else
					TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 53, fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --排位赛 灰色
		local campaign_show_nationalwar_invalid_terminal = {
            _name = "campaign_show_nationalwar_invalid",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 58, fun_open_condition.tip_info))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --战宠 灰色
		local campaign_show_pet_duplicate_invalid_terminal = {
            _name = "campaign_show_pet_duplicate_invalid",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local fun_id = 59
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
                    fun_id = 63
                end
				TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], fun_id, fun_open_condition.tip_info))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 返回主页
		local campaign_window_close_terminal = {
            _name = "campaign_window_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if fwin:find("CampaignClass") ~= nil then
					fwin:close(fwin:find("CampaignClass"))
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					or __lua_project_id == __lua_project_warship_girl_b 
					then
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
						if fwin:find("MenuClass") == nil then
				            fwin:open(Menu:new(), fwin._taskbar)
				        end
				    end
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
					state_machine.excute("home_hero_refresh_draw", 0, "")
					state_machine.excute("menu_clean_page_state", 0, "") 
				else
					state_machine.excute("menu_back_home_page", 0, "") 
					state_machine.excute("home_hero_refresh_draw", 0, "")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 
		local campaign_window_show_terminal = {
            _name = "campaign_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 
		local campaign_window_hide_terminal = {
            _name = "campaign_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		state_machine.add(campaign_show_trial_tower_invalid_terminal)
		state_machine.add(campaign_show_snatch_invalid_terminal)
		state_machine.add(campaign_show_palace_invalid_terminal)
		state_machine.add(campaign_show_mineral_res_invalid_terminal)
		state_machine.add(campaign_show_arena_invalid_terminal)
		state_machine.add(campaign_show_warcraft_invalid_terminal)
		state_machine.add(campaign_show_nationalwar_invalid_terminal)
		state_machine.add(campaign_show_pet_duplicate_invalid_terminal)

		state_machine.add(campaign_show_arena_terminal)
		state_machine.add(campaign_show_snatch_terminal)
		state_machine.add(campaign_show_mineral_res_terminal)
		state_machine.add(campaign_show_palace_terminal)
		state_machine.add(campaign_show_trial_tower_terminal)
		state_machine.add(campaign_show_warcraft_terminal)
		state_machine.add(campaign_show_nationalwar_terminal)
		state_machine.add(campaign_show_pet_duplicate_terminal)

		state_machine.add(campaign_window_close_terminal)

		state_machine.add(campaign_window_show_terminal)
		state_machine.add(campaign_window_hide_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_campaign_terminal()
end

if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert  then
	function Campaign:initActivityWindowPageView() --滑动pageView
		local root = self.roots[1]
		local pageView = ccui.Helper:seekWidgetByName(root, "PageView_lilian")
		local pages=pageView:getPages()
		local function pageViewEvent(sender, eventType)
			if eventType == ccui.PageViewEventType.turning then
				local pageView = sender
				local currentPageIndex = pageView:getCurPageIndex()
				-- 1
				local arena  = ccui.Helper:seekWidgetByName(root, "Button_55848_0_0_0")
				-- 夺宝 2
				local plunder	= ccui.Helper:seekWidgetByName(root, "Button_55848_0_0_0_0")
				-- 世界海战 3
				local trialtower = ccui.Helper:seekWidgetByName(root, "Button_55848_0_0")
				-- 海域攻占 4
				local mine = ccui.Helper:seekWidgetByName(root, "Button_55848_ziyuan")
				-- 港口警戒 5
				local worldboss = ccui.Helper:seekWidgetByName(root, "Button_55848_0")
				
				local Panel_donghua=ccui.Helper:seekWidgetByName(root, "Panel_donghua")
				for i ,v in pairs(self.pages) do
					self.pages[i]:retain()
				end
				if self.bool_init==false then
					-- if self.nowPageIndex == 2 then
					-- 	pageView:removePageAtIndex(0)
					-- 	pageView:addPage(self.pages[1])
					-- 	self.pages = nil
					-- 	self.pages = pageView:getPages()
					-- end
					-- if self.nowPageIndex == 3 then
					-- 	pageView:removePageAtIndex(0)
					-- 	pageView:addPage(self.pages[1])
					-- 	self.pages = nil
					-- 	self.pages = pageView:getPages()
						
					-- 	pageView:removePageAtIndex(0)
					-- 	pageView:addPage(self.pages[1])
					-- 	self.pages = nil
					-- 	self.pages = pageView:getPages()
					-- end
					
					-- if self.nowPageIndex == 4 then
					-- 	pageView:removePageAtIndex(0)
					-- 	pageView:addPage(self.pages[1])
					-- 	self.pages = nil
					-- 	self.pages = pageView:getPages()
						
					-- 	pageView:removePageAtIndex(0)
					-- 	pageView:addPage(self.pages[1])
					-- 	self.pages = nil
					-- 	self.pages = pageView:getPages()
						
					-- 	pageView:removePageAtIndex(0)
					-- 	pageView:addPage(self.pages[1])
					-- 	self.pages = nil
					-- 	self.pages = pageView:getPages()
					-- end
					
					-- if self.nowPageIndex == 5 then
					-- 	pageView:removePageAtIndex(0)
					-- 	pageView:addPage(self.pages[1])
					-- 	self.pages = nil
					-- 	self.pages = pageView:getPages()
						
					-- 	pageView:removePageAtIndex(0)
					-- 	pageView:addPage(self.pages[1])
					-- 	self.pages = nil
					-- 	self.pages = pageView:getPages()
						
					-- 	pageView:removePageAtIndex(0)
					-- 	pageView:addPage(self.pages[1])
					-- 	self.pages = nil
					-- 	self.pages = pageView:getPages()
						
					-- 	pageView:removePageAtIndex(0)
					-- 	pageView:addPage(self.pages[1])
					-- 	self.pages = nil
					-- 	self.pages = pageView:getPages()
					-- end
					self.bool_init=true
				else
					if currentPageIndex < 7 then
					   pageView:removePageAtIndex(13)
					   pageView:insertPage(self.pages[14],0)
					   -- self.pages=nil
					   -- self.pages=pageView:getPages()
					   if self.nowPageIndex == 1 then
							self.nowPageIndex = 14
					   else
							self.nowPageIndex = self.nowPageIndex-1
					   end
					   
					end
					
					
					if currentPageIndex > 7  then
						pageView:removePageAtIndex(0)
						pageView:addPage(self.pages[1])
						-- self.pages=nil
						-- self.pages=pageView:getPages()
						if self.nowPageIndex == 14 then
							self.nowPageIndex = 1
					    else
							self.nowPageIndex = self.nowPageIndex+1
					    end
					   
					end			
					if  currentPageIndex ~= 7 then
						pageView:scrollToPage(7)
					else
						self:addAnimation()
					end

				end		
				for i ,v in pairs(self.pages) do
					self.pages[i]:release()
				end
				self.pages=pageView:getPages()
			end
		end 
		pageView:addEventListener(pageViewEvent)
	end
end
function Campaign:addAnimation()
	if fwin:find("CampaignClass"):isVisible() == false then
		return
	end
	local root = self.roots[1]
	local Panel_donghua = ccui.Helper:seekWidgetByName(root,"Panel_donghua")
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_lilian_1/effect_lilian_1.ExportJson")
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_lilian_2/effect_lilian_2.ExportJson")
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_lilian_3/effect_lilian_3.ExportJson")
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_lilian_4/effect_lilian_4.ExportJson")
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_lilian_5/effect_lilian_5.ExportJson")
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_lilian_6/effect_lilian_6.ExportJson")
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_lilian_7/effect_lilian_7.ExportJson")
	-- self.liliandonghua = ccs.Armature:create("effect_lilian_1")
	-- self.liliandonghua:getAnimation():playWithIndex(0)
	-- self.liliandonghua:setPosition(cc.p(self.liliandonghua:getPositionX()+120, self.liliandonghua:getPositionY()+80))
	-- Panel_donghua:addChild(self.liliandonghua)	
	local AmationId=1
	-- print("================",self.nowPageIndex,self.bool1)
	if self.nowPageIndex==1 or self.nowPageIndex==8 then
		AmationId=1
	elseif self.nowPageIndex==2 or self.nowPageIndex==9 then
		AmationId=2
	elseif self.nowPageIndex==3 or self.nowPageIndex==10 then
		AmationId=3
	elseif self.nowPageIndex==4 or self.nowPageIndex==11 then
		AmationId=5
	elseif self.nowPageIndex==5 or self.nowPageIndex==12 then
		AmationId=4
	elseif self.nowPageIndex==6 or self.nowPageIndex==13 then
		AmationId=6
	elseif self.nowPageIndex==7 or self.nowPageIndex==14 then
		AmationId=7
	end
	if self.liliandonghua ~= nil then
		self.liliandonghua:removeFromParent(true)
		Panel_donghua:removeAllChildren(true)
	end
	self.liliandonghua = ccs.Armature:create("effect_lilian_"..AmationId)
	self.liliandonghua:getAnimation():playWithIndex(0)
	Panel_donghua:addChild(self.liliandonghua)
	-- print("=============",self.bool1,self.bool2,self.bool3,self.bool4,self.bool5)
	if self.nowPageIndex==1 or self.nowPageIndex==8 then
		-- print("=======添加动画1")
		self.liliandonghua:setPosition(cc.p(self.liliandonghua:getPositionX()+120, self.liliandonghua:getPositionY()+80))
		self.liliandonghua:setVisible(self.bool1)
	elseif self.nowPageIndex==2 or self.nowPageIndex==9 then
		-- print("=======添加动画2")
		self.liliandonghua:setPosition(cc.p(self.liliandonghua:getPositionX()+120, self.liliandonghua:getPositionY()+80))
		self.liliandonghua:setVisible(self.bool2)
	elseif self.nowPageIndex==3 or self.nowPageIndex==10 then
		-- print("=======添加动画3")
		self.liliandonghua:setPosition(cc.p(self.liliandonghua:getPositionX()+128, self.liliandonghua:getPositionY()+72))
		self.liliandonghua:setVisible(self.bool3)
	elseif self.nowPageIndex==4 or self.nowPageIndex==11 then
		-- print("=======添加动画4")
		self.liliandonghua:setPosition(cc.p(self.liliandonghua:getPositionX()+120, self.liliandonghua:getPositionY()+80))
		self.liliandonghua:setVisible(self.bool5)
	elseif self.nowPageIndex==5 or self.nowPageIndex==12 then
		-- print("=======添加动画5")
		self.liliandonghua:setPosition(cc.p(self.liliandonghua:getPositionX()+135, self.liliandonghua:getPositionY()+125))
		self.liliandonghua:setVisible(self.bool4)
	elseif self.nowPageIndex==6 or self.nowPageIndex==13 then
		self.liliandonghua:setPosition(cc.p(self.liliandonghua:getPositionX()+135, self.liliandonghua:getPositionY()+125))
		self.liliandonghua:setVisible(self.bool6)
	elseif self.nowPageIndex==7 or self.nowPageIndex==14 then
		self.liliandonghua:setPosition(cc.p(self.liliandonghua:getPositionX()+135, self.liliandonghua:getPositionY()+125))
		self.liliandonghua:setVisible(self.bool6)
	end
end
function Campaign:onUpdate(dt)
    if self.runState == 1 then
        state_machine.unlock("menu_manager_change_to_page", 0, "")
        self.runState = self.runState + 1
    end
    if self.runState == 0 then
        self.runState = self.runState + 1
    end

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then--
		local PageViews=ccui.Helper:seekWidgetByName(self.roots[1], "PageView_lilian")
		if PageViews == nil then
			return
		end
		local pagesSetscale=PageViews:getPages()
					
		local movep=0
		local width=3600
		for i, v in pairs(pagesSetscale) do
		
			movep=pagesSetscale[i]:convertToWorldSpaceAR(cc.p(0, 0)).x / app.scaleFactor - (fwin._width - app.baseOffsetX) / 2
			
			if movep < 0 then
				movep=0-movep
			end
			
			local scaleX = 1-movep*3/3600
			if scaleX < 0 then
				scaleX = -scaleX
			end
			pagesSetscale[i]:setScale(scaleX)
			
		end
		
		local ismove=0

		ismove=pagesSetscale[8]:getPositionX()
		if ismove~=0 then
			if self.liliandonghua ~= nil then
				self.liliandonghua:setVisible(false)
			end
		end
	end
end
function Campaign:CreateCampaign()
	local _Campaign = Campaign:new()
	_Campaign:registerOnNodeEvent(_Campaign)
	return _Campaign
end
function Campaign:initPages(initPages)
	--print("openpages:",initPages)
	self._initPages=initPages
	--print("self._initPages ...init",self._initPages )
end

function Campaign:onEnterTransitionFinish()
	--print("self._initPages .......",self._initPages )
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local userinfo = EquipPlayerInfomation:new()
		local info = fwin:open(userinfo,fwin._view)
	end
    local csbCampaignBG = csb.createNode("campaign/activity_list_bg.csb")
    local csbCampaign = csb.createNode("campaign/activity_list.csb")
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
    	local csbCampaign_root = csbCampaignBG:getChildByName("root")
    	local Image_1 = ccui.Helper:seekWidgetByName(csbCampaign_root, "Image_1")
    	Image_1:setTouchEnabled(true)
    end
    self:addChild(csbCampaignBG)
    self:addChild(csbCampaign)
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
    else
	    local action = csb.createTimeline("campaign/activity_list.csb")
	    csbCampaign:runAction(action)
	    action:gotoFrameAndPlay(0, action:getDuration(), false)
	end

	local root = csbCampaign:getChildByName("root")
	table.insert(self.roots, root)
	

	local PageView_lilian=nil
	local Panel_donghua=nil
		--动画

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then

		PageView_lilian=ccui.Helper:seekWidgetByName(root, "PageView_lilian")
		Panel_donghua=ccui.Helper:seekWidgetByName(root, "Panel_donghua")
		self.pages = PageView_lilian:getPages()
		for i, v in pairs(self.pages) do
			 -- v:retain()
			 self.pages_copy[i] = v:clone()
			 -- self.pages_copy[i]:retain()
		end
	end
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_arena_reward",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_55848_0_0_0"),
		_invoke = nil,
		_interval = 0.5,})	
		
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_indiana",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_55848_0_0_0_0"),
		_invoke = nil,
		_interval = 0.5,})	
		
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_trialtower",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_55848_0_0"),
		_invoke = nil,
		_interval = 0.5,})	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_worldboss",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_55848_0"),
		_invoke = nil,
		_interval = 0.5,})
		
		self.warcraft_Image_11 = ccui.Helper:seekWidgetByName(root, "Image_11")
		warcraft = ccui.Helper:seekWidgetByName(root, "Button_paiweisai")
	end

	local warcraft = nil
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_worldboss",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_55848_0"),
		_direction = 1, --历练界面
		_invoke = nil,
		_interval = 0.5,})	

		self.warcraft_Image_11 = ccui.Helper:seekWidgetByName(root, "Image_11")
		warcraft = ccui.Helper:seekWidgetByName(root, "Button_paiweisai")
	end
	
	-- 12	港口警戒	12	35	0	0	提督，35级才开放港口警戒功能，请努力提升等级再来吧！
	-- 13	海域攻占	13	32	0	0	提督，32级开放海域攻占功能，要努力提升等级哦！
	-- 14	世界海战	14	22	0	0	提督，22级才能进世界海战哟，请努力提升等级再来吧！
	-- 15	夺宝	15	15	0	0	提督，15级才开放夺宝哟，请努力提升等级再来吧！
	-- 16	演习	16	10	0	0	提督，10级才开放演习哟，请努力提升等级再来吧！
	-- 17	排位赛	16	10	0	0	提督，10级才开放演习哟，请努力提升等级再来吧！
	
	--开始判定锁界面

	self.arena_Image_6  	= ccui.Helper:seekWidgetByName(root, "Image_6")
	self.plunder_Image_7  	= ccui.Helper:seekWidgetByName(root, "Image_7")
	self.trialtower_Image_8 = ccui.Helper:seekWidgetByName(root, "Image_8")
	self.mine_Image_9  		= ccui.Helper:seekWidgetByName(root, "Image_9")
	self.worldboss_Image_10 = ccui.Helper:seekWidgetByName(root, "Image_10")
	self.pet_Image_11		= ccui.Helper:seekWidgetByName(root, "Image_12")
	self.nationalwar_image = nil

	if __lua_project_id ~= __lua_project_warship_girl_b and __lua_project_id ~= __lua_project_digimon_adventure and __lua_project_id ~= __lua_project_pokemon
		and __lua_project_id ~= __lua_project_rouge and __lua_project_id ~= __lua_project_yugioh  then 
		self.arena_Image_6_0  		= ccui.Helper:seekWidgetByName(root, "Image_6_0")
		self.plunder_Image_7_0  	= ccui.Helper:seekWidgetByName(root, "Image_7_0")
		self.trialtower_Image_8_0 	= ccui.Helper:seekWidgetByName(root, "Image_8_0")
		self.mine_Image_9_0  		= ccui.Helper:seekWidgetByName(root, "Image_9_0")
		self.worldboss_Image_10_0 	= ccui.Helper:seekWidgetByName(root, "Image_10_0")
	end

	local nationalwar = nil

	-- 演习 1
	local arena  = ccui.Helper:seekWidgetByName(root, "Button_55848_0_0_0")
	-- 夺宝 2
	local plunder	= ccui.Helper:seekWidgetByName(root, "Button_55848_0_0_0_0")
	-- 世界海战 3
	local trialtower = ccui.Helper:seekWidgetByName(root, "Button_55848_0_0")
	-- 海域攻占 5
	local mine = ccui.Helper:seekWidgetByName(root, "Button_55848_ziyuan")
	-- 港口警戒 4
	local worldboss = ccui.Helper:seekWidgetByName(root, "Button_55848_0")
	-- 战宠副本
	local pet = ccui.Helper:seekWidgetByName(root, "Button_hqzc")

	if  __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		warcraft = ccui.Helper:seekWidgetByName(root, "Button_55849_0")
		self.nationalwar_image = ccui.Helper:seekWidgetByName(root, "Image_11_0")
		nationalwar = ccui.Helper:seekWidgetByName(root, "Button_55849_11")
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
			self.nowPageIndex = self._initPages
		--因为返回暂时没做好，self._initPages却有传值，所以每次进入先是默认强制1 代表武神台
			PageView_lilian:insertPage(self.pages_copy[7],0)
			PageView_lilian:insertPage(self.pages_copy[6],0)
			PageView_lilian:insertPage(self.pages_copy[5],0)
			PageView_lilian:insertPage(self.pages_copy[4],0)
			PageView_lilian:insertPage(self.pages_copy[3],0)
			PageView_lilian:insertPage(self.pages_copy[2],0)
			PageView_lilian:insertPage(self.pages_copy[1],0)
			local PageViews=ccui.Helper:seekWidgetByName(root, "PageView_lilian")	
			-- for i, v in pairs(self.pages) do
			-- 	v:release()
			-- end
			self.pages = nil
			self.pages = PageViews:getPages()

			PageViews:setPosition(cc.p(PageViews:getPositionX()+180,PageViews:getPositionY()+300))
			for i ,v in pairs(self.pages) do
				v:setAnchorPoint(0.5,0.5)
			end
			PageView_lilian:scrollToPage(7) 	

		self:initButton(
			ccui.Helper:seekWidgetByName(self.pages_copy[1], "Button_55848_0_0_0"), 
			ccui.Helper:seekWidgetByName(self.pages_copy[2], "Button_55848_0_0_0_0"),
			ccui.Helper:seekWidgetByName(self.pages_copy[3], "Button_55848_0_0"), 
			ccui.Helper:seekWidgetByName(self.pages_copy[4], "Button_55848_ziyuan"),
			ccui.Helper:seekWidgetByName(self.pages_copy[5], "Button_55848_0"),
			ccui.Helper:seekWidgetByName(self.pages_copy[6], "Button_55849_0"),
			ccui.Helper:seekWidgetByName(self.pages_copy[7], "Button_55849_11"),
			ccui.Helper:seekWidgetByName(self.pages_copy[1], "Image_6"), 
			ccui.Helper:seekWidgetByName(self.pages_copy[2], "Image_7"),
			ccui.Helper:seekWidgetByName(self.pages_copy[3], "Image_8"), 
			ccui.Helper:seekWidgetByName(self.pages_copy[4], "Image_9"),
			ccui.Helper:seekWidgetByName(self.pages_copy[5], "Image_10"),
			ccui.Helper:seekWidgetByName(self.pages_copy[6], "Image_10_0"),
			ccui.Helper:seekWidgetByName(self.pages_copy[7], "Image_11_0")
			)
			--拷贝过来的按钮也添加推送
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_arena_reward",
				_widget = ccui.Helper:seekWidgetByName(self.pages_copy[1], "Button_55848_0_0_0"),
				_invoke = nil,
				_interval = 0.5,})	
				
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_indiana",
				_widget = ccui.Helper:seekWidgetByName(self.pages_copy[2], "Button_55848_0_0_0_0"),
				_invoke = nil,
				_interval = 0.5,})	
				
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_trialtower",
				_widget = ccui.Helper:seekWidgetByName(self.pages_copy[3], "Button_55848_0_0"),
				_invoke = nil,
				_interval = 0.5,})	

			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_worldboss",
				_widget = ccui.Helper:seekWidgetByName(self.pages_copy[5], "Button_55848_0"),
				_invoke = nil,
				_interval = 0.5,})			
			self:initActivityWindowPageView()
	end

	self:initButton(arena, plunder,trialtower,mine,worldboss,warcraft,nationalwar,
		self.arena_Image_6,self.plunder_Image_7,self.trialtower_Image_8,
		self.mine_Image_9,self.worldboss_Image_10,self.warcraft_Image_11,self.nationalwar_image)
	if self.pet_Image_11 ~= nil and pet ~= nil then 
		--战宠功能
		self:initPetButton(pet,self.pet_Image_11)
	end

	local closeWindow = ccui.Helper:seekWidgetByName(root, "Button_55")
	if closeWindow ~= nil then
		fwin:addTouchEventListener(closeWindow, nil, 
		{
			terminal_name = "campaign_window_close", 
			isPressedActionEnabled = true
		},
		nil,0)
	end
end

--此函数已经参数太多，新增功能后添加新函数
function Campaign:initButton(arena, plunder,trialtower,mine,worldboss,warcraft,nationalwar,arena_Image_6,plunder_Image_7,trialtower_Image_8,mine_Image_9,worldboss_Image_10,warcraft_Image_11,nationalwar_image)

	-- 判定 演习
	local isOpen_arena  = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 16, fun_open_condition.level)
	-- 判定 夺宝
	local isOpen_plunder	= tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 15, fun_open_condition.level)
	-- 判定 世界海战
	local isOpen_trialtower = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 14, fun_open_condition.level)
	-- 判定 海域攻占
	local isOpen_mine = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 13, fun_open_condition.level)
	-- 判定 港口警戒
	local isOpen_worldboss = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 12, fun_open_condition.level)

	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		local isOpen_warcrft = false
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
			isOpen_warcrft = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 57, fun_open_condition.level)
		else
			isOpen_warcrft = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 53, fun_open_condition.level)
		end
		
		if isOpen_warcrft == true then
			self.bool6=true
			fwin:addTouchEventListener(warcraft, nil, 
			{
				terminal_name = "campaign_show_warcraft", 
				isPressedActionEnabled = true
			},
			nil,0)
		else
			warcraft:setBright(false)
			fwin:addTouchEventListener(warcraft, nil, {func_string = [[state_machine.excute("campaign_show_warcraft_invalid", 0, "campaign_show_warcraft_invalid.'")]]}, nil, 0)
			self.warcraft_Image_11:setVisible(true)
			self.bool6=false
		end
	end
	--print("开启入口------------------", isOpen_arena, isOpen_plunder, isOpen_trialtower, isOpen_mine, isOpen_worldboss)
	--print("level------------------", dms.int(dms["fun_open_condition"], 16, fun_open_condition.level),dms.int(dms["fun_open_condition"], 15, fun_open_condition.level),dms.int(dms["fun_open_condition"], 14, fun_open_condition.level),dms.int(dms["fun_open_condition"], 13, fun_open_condition.level),dms.int(dms["fun_open_condition"], 12, fun_open_condition.level))
	
	if isOpen_arena then
		self.bool1=true
		-- fwin:addTouchEventListener(arena, nil, {func_string = [[state_machine.excute("campaign_show_arena", 0, "campaign_show_arena.'")]]}, nil, 0)
		-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		-- 	local Panel_wushentai = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wushentai")
		-- 	Panel_wushentai:setSwallowTouches(false)
		-- 	arena:setSwallowTouches(false)
		-- 	fwin:addTouchEventListener(Panel_wushentai, nil, 
		-- 	{
		-- 		terminal_name = "campaign_show_arena", 
		-- 		isPressedActionEnabled = true
		-- 	},
		-- 	nil,0)
		-- end
		
		fwin:addTouchEventListener(arena, nil, 
		{
			terminal_name = "campaign_show_arena", 
			isPressedActionEnabled = true
		},
		nil,0)
	else
		arena:setBright(false)
		
		fwin:addTouchEventListener(arena, nil, {func_string = [[state_machine.excute("campaign_show_arena_invalid", 0, "campaign_show_arena_invalid.'")]]}, nil, 0)
		
		arena_Image_6:setVisible(true)
		if self.arena_Image_6_0 ~= nil then 
			self.arena_Image_6_0:setVisible(true)
		end
		self.bool1=false
	end
	
	
	if isOpen_plunder then
		self.bool2=true
		-- fwin:addTouchEventListener(plunder, nil, {func_string = [[state_machine.excute("campaign_show_snatch", 0, "campaign_show_arena.'")]]}, nil, 0)
		fwin:addTouchEventListener(plunder, nil, 
		{
			terminal_name = "campaign_show_snatch", 
			isPressedActionEnabled = true
		},
		nil,0)
	else
		plunder:setBright(false)
		fwin:addTouchEventListener(plunder, nil, {func_string = [[state_machine.excute("campaign_show_snatch_invalid", 0, "campaign_show_snatch_invalid.'")]]}, nil, 0)
		
		plunder_Image_7:setVisible(true)
		if self.plunder_Image_7_0 ~= nil then 
			self.plunder_Image_7_0:setVisible(true)
		end
		self.bool2=false
	end
	
	--
	--
	if isOpen_trialtower then
		self.bool3=true
		-- fwin:addTouchEventListener(trialtower, nil, {func_string = [[state_machine.excute("campaign_show_trial_tower", 0, "campaign_show_trial_tower.'")]]}, nil, 0)
		fwin:addTouchEventListener(trialtower, nil, 
		{
			terminal_name = "campaign_show_trial_tower", 
			isPressedActionEnabled = true
		},
		nil,0)
	else
		trialtower:setBright(false)
		
		fwin:addTouchEventListener(trialtower, nil, {func_string = [[state_machine.excute("campaign_show_trial_tower_invalid", 0, "campaign_show_trial_tower_invalid.'")]]}, nil, 0)
		
		trialtower_Image_8:setVisible(true)
		if self.trialtower_Image_8_0 ~= nil then 
			self.trialtower_Image_8_0:setVisible(true)
		end
		self.bool3=false
	end
	
	
	
	if isOpen_mine then
		self.bool5=true
		-- fwin:addTouchEventListener(mine, nil, {func_string = [[state_machine.excute("campaign_show_mineral_res", 0, "campaign_show_mineral_res.'")]]}, nil, 0)
		fwin:addTouchEventListener(mine, nil, 
		{
			terminal_name = "campaign_show_mineral_res", 
			isPressedActionEnabled = true
		},
		nil,0)
	else
		mine:setBright(false)
		
		fwin:addTouchEventListener(mine, nil, {func_string = [[state_machine.excute("campaign_show_mineral_res_invalid", 0, "campaign_show_mineral_res_invalid.'")]]}, nil, 0)
		mine_Image_9:setVisible(true)
		if self.mine_Image_9_0 ~= nil then 
			self.mine_Image_9_0:setVisible(true)
		end
		self.bool5=false
	end
	
	
	
	if isOpen_worldboss then
		self.bool4=true
		-- fwin:addTouchEventListener(worldboss, nil, {func_string = [[state_machine.excute("campaign_show_palace", 0, "campaign_show_palace.'")]]}, nil, 0)
		fwin:addTouchEventListener(worldboss, nil, 
		{
			terminal_name = "campaign_show_palace", 
			isPressedActionEnabled = true
		},
		nil,0)
	else
		worldboss:setBright(false)
		
		fwin:addTouchEventListener(worldboss, nil, {func_string = [[state_machine.excute("campaign_show_palace_invalid", 0, "campaign_show_palace_invalid.'")]]}, nil, 0)
		
		worldboss_Image_10:setVisible(true)
		if self.worldboss_Image_10_0 ~= nil then 
			self.worldboss_Image_10_0:setVisible(true)
		end
		self.bool4=false
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		local isOpen_nationalwar = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 58, fun_open_condition.level)
		if isOpen_nationalwar == true then
			self.bool7=true
			fwin:addTouchEventListener(nationalwar, nil, 
			{
				terminal_name = "campaign_show_nationalwar", 
				isPressedActionEnabled = true
			},
			nil,0)
		else
			nationalwar:setBright(false)
			fwin:addTouchEventListener(nationalwar, nil, {func_string = [[state_machine.excute("campaign_show_nationalwar_invalid", 0, "campaign_show_nationalwar_invalid.'")]]}, nil, 0)
			if nationalwar_image ~= nil then 
				nationalwar_image:setVisible(true)
			end
			self.bool7 = false
		end
	end
	
	--ccui.Helper:seekWidgetByName(root, "Button_55848_0_0_0"):setEnabled(false)

end

function Campaign:initPetButton(petButton,petImage)
	local fun_id = 59
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
        fun_id = 63
    end
	local petLevel = dms.int(dms["fun_open_condition"], fun_id, fun_open_condition.level)
	-- 判定 宠物副本s
	local isOpen_pet = false
	if petLevel ~= nil and petLevel ~= -1 then 
		--有此功能
		isOpen_pet =  tonumber(_ED.user_info.user_grade) >= petLevel
	else
		isOpen_pet = false
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
		--龙虎门配置不一样
		isOpen_pet = false
	end
	
	if isOpen_pet == true then
		self.bool8=true
		fwin:addTouchEventListener(petButton, nil, 
		{
			terminal_name = "campaign_show_pet_duplicate", 
			isPressedActionEnabled = true
		},
		nil,0)
		self.pet_Image_11:setVisible(false)
	else
		petButton:setBright(false)
		fwin:addTouchEventListener(petButton, nil, {func_string = [[state_machine.excute("campaign_show_pet_duplicate_invalid", 0, "campaign_show_pet_duplicate_invalid.'")]]}, nil, 0)
		self.pet_Image_11:setVisible(true)
		self.bool8=false
	end
end

function Campaign:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		-- for i,v in pairs(self.pages) do
		-- 	v:release()
		-- end
		-- for i, v in pairs(self.pages_copy) do
		-- 	v:release()
		-- end
		local root = self.roots[1]
		local Panel_donghua=ccui.Helper:seekWidgetByName(root, "Panel_donghua")
		Panel_donghua:removeAllChildren(true)
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("images/ui/effice/effect_lilian_1/effect_lilian_1.ExportJson")
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("images/ui/effice/effect_lilian_2/effect_lilian_2.ExportJson")
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("images/ui/effice/effect_lilian_3/effect_lilian_3.ExportJson")
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("images/ui/effice/effect_lilian_4/effect_lilian_4.ExportJson")
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("images/ui/effice/effect_lilian_5/effect_lilian_5.ExportJson")
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("images/ui/effice/effect_lilian_6/effect_lilian_6.ExportJson")
		ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("images/ui/effice/effect_lilian_7/effect_lilian_7.ExportJson")

		cacher.destoryRefPools()
		cacher.removeAllTextures()
		cacher.cleanSystemCacher()
		if fwin:find("HomeClass") == nil then
			cacher.cleanActionTimeline()
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				checkTipBeLeave()
			end				
			-- fwin:removeAll()
		end
	elseif __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		cacher.destoryRefPools()
		cacher.removeAllTextures()
		cacher.cleanSystemCacher()
	end
end
function Campaign:onExit()
	state_machine.remove("campaign_show_arena")
	state_machine.remove("campaign_show_snatch")
	state_machine.remove("campaign_show_mineral_res")
	state_machine.remove("campaign_show_palace")
	state_machine.remove("campaign_show_trial_tower")
	state_machine.remove("campaign_show_warcraft")
	state_machine.remove("campaign_show_nationalwar")
	state_machine.remove("campaign_show_pet_duplicate")
	
	state_machine.remove("campaign_show_trial_tower_invalid")
	state_machine.remove("campaign_show_snatch_invalid")
	state_machine.remove("campaign_show_palace_invalid")
	state_machine.remove("campaign_show_mineral_res_invalid")
	state_machine.remove("campaign_show_arena_invalid")
	state_machine.remove("campaign_show_warcraft_invalid")
	state_machine.remove("campaign_show_nationalwar_invalid")
	state_machine.remove("campaign_show_pet_duplicate_invalid")

	state_machine.remove("campaign_window_close")

	state_machine.remove("campaign_window_show")
	state_machine.remove("campaign_window_hide")
end

--return Campaign:new()