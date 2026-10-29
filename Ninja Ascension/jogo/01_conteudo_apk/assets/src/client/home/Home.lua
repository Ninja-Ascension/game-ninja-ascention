-- ----------------------------------------------------------------------------------------------------
-- 说明：主页中间面菜单
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

-- 进度未到的功能入口封闭
-- TipDlg.drawTextDailog(_function_unopened_tip_string)

Home = class("HomeClass", Window)
Home.__userHeroFontName = nil

if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
   app.load("client.activity.ActivityFirstRecharge")
   app.load("client.red_alert.login.CampChose")
   app.load("client.red_alert.cells.all_resources_cell")
   app.load("client.cells.utils.sm_item_icon_cell")
   app.load("client.activity.dailytask.TargetTask")
   app.load("client.l_digital.campaign.arena.Arena")
   if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
       app.load("client.l_digital.activity.wonderful.SmFiveStarPraise")
   end
end

local home_window_open_terminal = {
    _name = "home_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.lock("home_window_open", 0, "")
        Loading.loading(
        {
            _pic = {}, 
            _plist = {
                -- {
                --     _png = {"images/ui/play/wonderful_activity/wonderful_he_1.png"}, 
                --     _plist = {"images/ui/play/wonderful_activity/wonderful_he_1.plist"}
                -- },
                -- {
                --     _png = {"images/ui/play/wonderful_activity/wonderful_he_2.png"}, 
                --     _plist = {"images/ui/play/wonderful_activity/wonderful_he_2.plist"}
                -- },
                -- {
                --     _png = {"images/ui/play/wonderful_activity/wonderful_list.png"}, 
                --     _plist = {"images/ui/play/wonderful_activity/wonderful_list.plist"}
                -- }
            }, 
            _ui = {}
        },
        nil,
        {"activity_window_loading", 0, params})
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local home_window_loading_terminal = {
    _name = "home_window_loading",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.unlock("home_window_open", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(home_window_open_terminal)
state_machine.add(home_window_loading_terminal)
state_machine.init()

function Home:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
        self._view = fwin._frameview
        self._zorder = 1
    end
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.current_type = 0
    self.runState = 0
	self.id = nil
	self._needOpenHomeHero = false
	self._is_show_mystery_shop = false  --是否主页显示神秘商店
	self.AcitivityListTwo = nil
    self.have_send_purify = false
    -- 血量默认设置开启
    local showMasterHp = cc.UserDefault:getInstance():getStringForKey("m_isShowMasterHp")
    if showMasterHp == nil or showMasterHp == "" then
        cc.UserDefault:getInstance():setStringForKey("m_isShowMasterHp","1")
    end
	
	self.init_home_effect = nil
	self.listButtons_1 = nil -- 用于游戏王
    self.listButtons_2 = nil -- 用于游戏王

    self.show_finder = nil --指引
    self.everyDayOnlineRewardTime = 0 -- 数码每日在线奖励显示时间
    self.everyDayOnlinePanel = nil
    self.Panel_hd_tuisong = nil
    self.user_fight = 0
    self.combination_prop_open = false      -- 组合卡道具领取入口是否开放
    self.combination_prop_flag = false
    self.combination_prop_level = dms.int(dms["activity_config"], 70, activity_config.param) -- 组合卡道具领取等级配置

    self.rowMaxIconNums = 0              -- 活动icon每行最大数量
    self.enumLineType = {
        FIRSTLINE = 1,              -- 第一行
        SECONDLINE = 2,             -- 第二行
    }
    self.itemsFirstLineArray = {}        -- 第一行图标数组
    self.itemsScecondLineArray = {}      -- 第二行图标数组
    self.itemsThirdLineArray = {}        -- 第三行图标数组
  
    self.isShowActivityList = true          -- 控制收放活动listview
    self.easterEggRoleSp = nil              -- 彩蛋活动迪路兽动画

    app.load("client.cells.activity.activity_icon_cell")
    app.load("client.activity.wonderful.ActivityRVipPush")
    app.load("client.utils.DrawHandle")
    app.load("client.home.HomeTips")

    -- HY临时更新添加 WEB支付海报
    -- app.load("client.activity.wonderful.WebPayPush")

    self.updateTimes = 0

    self.totalTimes = 0
    
    -- Initialize Home page state machine.
    local function init_home_terminal()
		--home界面管理
		local home_manager_terminal = {
            _name = "home_manager",
            _init = function (terminal)
				app.load("client.home.HomeHero")
				app.load("client.player.UserInformation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if terminal.current_terminal_name ~= terminal._name then
                    fwin:freeCache()
                    terminal.current_terminal_name = params._datas.next_terminal_name
					--如果是军团就不关闭界面（因为军团未做）
     --                if params._datas.next_terminal_name == "home_click_union" then
					-- 	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                            -- or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					-- 		state_machine.excute("menu_clean_page_state", 0, "home")
					-- 	end
					-- else
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
							state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                            if params._datas.unload == true then
                                state_machine.excute(params._datas.next_terminal_name, 0, params)
                                return
                            end
                        else
                            state_machine.excute("menu_clean_page_state", 0, "home")
						end
					-- end
                    state_machine.excute(params._datas.next_terminal_name, 0, params)
                    
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then			--龙虎门项目控制
						return
					end
					if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
						return
					end 
                    state_machine.remove("home_click_out_page")
                    state_machine.remove("home_click_in_page")
                    state_machine.remove("home_click_union")
                    state_machine.remove("home_click_daily_tasks")
                    state_machine.remove("home_click_fame_hall_manager")
                    state_machine.remove("home_click_friend_manager")
                    state_machine.remove("home_click_email_manager")
                    state_machine.remove("home_click_recover")
                    state_machine.remove("home_click_generals")
                    state_machine.remove("home_click_equipment")
                    state_machine.remove("home_click_treasure")
                    state_machine.remove("home_click_recharge")
                    state_machine.remove("home_click_vip")
                    state_machine.remove("home_click_CatalogueStorage")
                    state_machine.remove("home_click_install")
                    state_machine.remove("home_click_chat")
                    state_machine.remove("home_click_sevendays_activity")
                    state_machine.remove("home_click_destiny_system")
                    state_machine.remove("home_click_hero_shop")
                    state_machine.remove("home_click_activity")
                    state_machine.remove("home_recharge_activity")
                    state_machine.remove("home_goto_click_union")
                    state_machine.remove("home_goto_click_recruit")
                    state_machine.remove("home_click_pets")
              
                    if __lua_project_id == __lua_project_yugioh then
                        state_machine.remove("home_click_magic_card")
                    end
                    
                    cc.Director:getInstance():getTextureCache():removeUnusedTextures()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil,
			child = "child"
        }
		-- 首充完毕之后关闭首充按钮
		local home_update_first_recharge_terminal = {
            _name = "home_update_first_recharge",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				if nil == fwin:find("HomeClass") then
					return
				end
				
				if nil ~= instance.updateFirstRecharge then
					instance:updateFirstRecharge()
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--军团
		local home_click_union_terminal = {
            _name = "home_click_union",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)         
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    if tonumber(_ED.user_info.user_grade) < dms.int(dms["fun_open_condition"], 141, fun_open_condition.level) then
                        TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 141, fun_open_condition.tip_info))
                        return
                    end
                end
                if params._datas.gotype == 1 then
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        app.load("client.l_digital.union.create.UnionJoin")
                    else
                        app.load("client.union.create.UnionJoin")
                    end
                    state_machine.excute("union_join_open", 0, "")
                elseif params._datas.gotype == 2 then
                    if __lua_project_id == __lua_project_gragon_tiger_gate
                        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                        or __lua_project_id == __lua_project_red_alert
                        then
                        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                            then
                            app.load("client.l_digital.union.UnionTigerGate")
                        else
                            app.load("client.union.UnionTigerGate")
                        end
                        state_machine.excute("Union_open", 0, "")
                        state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                        state_machine.excute("home_hide_event", 0, "home_hide_event.")
                    else
                        app.load("client.union.Union")
                        state_machine.excute("Union_open", 0, "")
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--日常任务
		local home_click_daily_tasks_terminal = {
            _name = "home_click_daily_tasks",
            _init = function (terminal)    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- fwin:open(DailyTasks:new(), fwin._view) 
				TipDlg.drawTextDailog(_function_unopened_tip_string)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--好友
		local home_click_friend_manager_terminal = {
            _name = "home_click_friend_manager",
            _init = function (terminal)   
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    app.load("client.l_digital.friend.SmFriendWindow")
                    state_machine.excute("sm_friend_window_open", 0, nil)
                else
                    app.load("client.friend.FriendManager")
    				fwin:open(FriendManager:new(), fwin._view) 
                    if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
                        state_machine.excute("menu_adventure_open_button", 0, 0) 
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		

		--名人堂
		local home_click_fame_hall_terminal = {
            _name = "home_click_fame_hall_manager",
            _init = function (terminal)
				app.load("client.home.fame.FameHall")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                        then

                        local m_type = 7
                        local needNumber = "1"
                        local terminalName = "sm_ranking_main_interface_open"
                        if __lua_project_id == __lua_project_l_digital then
                            app.load("client.l_digital.system.SmRankingHonor")
                            m_type = 0
                            needNumber = "10"
                            terminalName = "sm_ranking_honor_window_open"
                        else
                            app.load("client.l_digital.system.SmRankingMainInterface")
                        end
                        
                        local function responseCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                    state_machine.excute(terminalName, 0, 0) 
                                end
                            end
                        end
                        
                        protocol_command.order_get_info.param_list = m_type.."\r\n".."1".."\r\n"..needNumber
                        NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, instance, responseCallback, false, nil)
                    else
                        local openlevel = tonumber(dms.int(dms["fun_open_condition"], 39, fun_open_condition.level))
                        if tonumber(_ED.user_info.user_grade) < openlevel then 
                            TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 39, fun_open_condition.tip_info))
                            return
                        end    
                        fwin:open(FameHall:new(), fwin._view) 
                    end
                else
				    fwin:open(FameHall:new(), fwin._view) 
                end
                if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
                    state_machine.excute("menu_adventure_open_button", 0, 0) 
                end
				-- TipDlg.drawTextDailog(_function_unopened_tip_string)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--邮件
		local home_click_email_manager_terminal = {
            _name = "home_click_email_manager",
            _init = function (terminal)
				app.load("client.email.EmailManager")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    -- local function responsePropCompoundCallback(response)
                    --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    --         if fwin:find("EmailManagerClass") == nil then
                    --            fwin:open(EmailManager:new(), fwin._view) 
                    --         end
                    --     end
                    -- end
                    -- NetworkManager:register(protocol_command.reward_center_init.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
                    
                    if fwin:find("EmailManagerClass") == nil then
                       fwin:open(EmailManager:new(), fwin._view) 
                    end
                else
				    fwin:open(EmailManager:new(), fwin._view) 
                end
                if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
                    state_machine.excute("menu_adventure_open_button", 0, 0) 
                end
				-- TipDlg.drawTextDailog(_function_unopened_tip_string)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--武将列表
		local home_click_generals_terminal = {
            _name = "home_click_generals",
            _init = function (terminal) 
                 app.load("client.packs.hero.HeroStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
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
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
					state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                    state_machine.excute("home_hide_event", 0, "home_hide_event.")
				end
                if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
                   state_machine.excute("menu_adventure_open_button", 0, 0) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --魔陷卡列表
        local home_click_magic_card_terminal = {
            _name = "home_click_magic_card",
            _init = function (terminal) 
                 app.load("client.magicCard.MagicCardChooseMain")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if fwin:find("MagicCardChooseMainClass") ~= nil then
                    fwin:close(fwin:find("MagicCardChooseMainClass"))
                end
                local MagicCardMagicListWindow = fwin:find("MagicCardMagicListClass")
                if MagicCardMagicListWindow ~= nil then
                    fwin:close(MagicCardMagicListWindow)
                end 
                local MagicCardTrupListWindow = fwin:find("MagicCardTrupListClass")
                if MagicCardTrupListWindow ~= nil then
                    fwin:close(MagicCardTrupListWindow)
                end
                state_machine.excute("magic_card_main_choose_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --战宠将列表
        local home_click_pets_terminal = {
            _name = "home_click_pets",
            _init = function (terminal) 
                 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local fun_id = 54
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
                    fun_id = 58
                end
                local isOpen_pet  = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], fun_id, fun_open_condition.level)
                if false == isOpen_pet then
                    TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], fun_id, fun_open_condition.tip_info))
                    return
                end
                state_machine.excute("menu_clean_page_state", 0, "home")
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
                
                state_machine.excute("menu_adventure_open_button", 0, 0) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --推荐阵容
        local home_click_recommend_formation_terminal = {
            _name = "home_click_recommend_formation",
            _init = function (terminal) 
                 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.formation.RecommendFormation")
                state_machine.excute("recommend_formation_window_open",0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

	
		--装备列表
		local home_click_equipment_terminal = {
            _name = "home_click_equipment",
            _init = function (terminal) 
                app.load("client.packs.equipment.EquipStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(EquipStorage:new(), fwin._view) 
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
					state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                    state_machine.excute("home_hide_event", 0, "home_hide_event.")
		        elseif __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
                   state_machine.excute("menu_adventure_open_button", 0, 0) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--主界面充值按钮
		local home_click_recharge_terminal = {
            _name = "home_click_recharge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- fwin:open(Recharge:new(), fwin._windows) 
				TipDlg.drawTextDailog(_function_unopened_tip_string)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--主界面VIP按钮
		local home_click_vip_terminal = {
            _name = "home_click_vip",
            _init = function (terminal) 
                app.load("client.shop.recharge.VipPrivilegeDialog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:open(VipPrivilegeDialog:new(), fwin._windows) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--主界面宝物按钮
		local home_click_treasure_terminal = {
            _name = "home_click_treasure",
            _init = function (terminal) 
                app.load("client.packs.treasure.TreasureStorage")
				-- app.load("client.duplicate.pve.PVEStage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(TreasureStorage:new(), fwin._view) 
				-- fwin:open(PageStage:new(), fwin._view) 

                if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
                   state_machine.excute("menu_adventure_open_button", 0, 0) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--主界面图鉴按钮
		local home_click_CatalogueStorage_terminal = {
            _name = "home_click_CatalogueStorage",
            _init = function (terminal) 
                app.load("client.home.catalogue.CatalogueStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(CatalogueStorage:new(), fwin._view)
                if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
                    state_machine.excute("menu_adventure_open_button", 0, 0) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--主界面设置按钮
		local home_click_install_terminal = {
            _name = "home_click_install",
            _init = function (terminal) 
                app.load("client.system.InStall")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(InStall:new(), fwin._view) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        --主界面回收按钮
		local home_click_recover_terminal = {
            _name = "home_click_recover",
            _init = function (terminal) 
                app.load("client.refinery.RefiningFurnace")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    local isopen,tip = getFunopenLevelAndTip(10)
                    if isopen == true then
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
                        state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                        state_machine.excute("home_hide_event", 0, "home_hide_event.")
                    else
                        TipDlg.drawTextDailog(tip)
                    end
                else
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
                end

                if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
                    state_machine.excute("menu_adventure_open_button", 0, 0) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--主界面聊天按钮
		local home_click_chat_terminal = {
            _name = "home_click_chat",
            _init = function (terminal) 
                app.load("client.chat.ChatStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = 71
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    index = 88
                end
                local isOpen = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], index, fun_open_condition.level)
                if false == isOpen then
                    TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], index, fun_open_condition.tip_info))
                    return
                end
    			fwin:open(ChatStorage:new(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
				
		local home_click_activity_terminal = {
			_name = "home_click_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- local function responseBattleInitCallback(response)
					-- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- BattleSceneClass.Draw()
					-- end
				-- end
				-- _ED._current_scene_id = 1
				-- _ED._scene_npc_id = 5
				-- _ED._npc_difficulty_index = 1
				-- protocol_command.battle_field_init.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
				-- NetworkManager:register(protocol_command.battle_field_init.code, nil, nil, nil, nil, responseBattleInitCallback, true, nil)
				TipDlg.drawTextDailog(_function_unopened_tip_string)
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		local home_recharge_activity_terminal = {
			_name = "home_recharge_activity",
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
                    if funOpenDrawTip(181) == true then
                        return
                    end
                end
				app.load("client.shop.recharge.RechargeDialog")
				local Recharge = RechargeDialog:new()
				Recharge:init(4)
				fwin:open(Recharge , fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		--主界面七日活动按钮
		local home_click_sevendays_activity_terminal = {
            _name = "home_click_sevendays_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- state_machine.excute("home_manager",0,"SevenDaysActivity")
				-- fwin:open(SevenDaysActivity:new(), fwin._view) 
				TipDlg.drawTextDailog(_function_unopened_tip_string)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--主界面三国志按钮
		local home_click_destiny_system_terminal = {
            _name = "home_click_destiny_system",
            _init = function (terminal) 
                 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    local userlevel = tonumber(_ED.user_info.user_grade)
                    local openlevel = tonumber(dms.string(dms["fun_open_condition"],9, fun_open_condition.level))
                    if userlevel < openlevel then
                        TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"],9, fun_open_condition.tip_info))
                    else
                        app.load("client.destiny.DestinySystem")
                        fwin:open(DestinySystem:new(), fwin._view)
                        state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                        state_machine.excute("home_hide_event", 0, "home_hide_event.")
                    end
                else
    				app.load("client.destiny.DestinySystem")
    				fwin:open(DestinySystem:new(), fwin._view)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--主界面神秘商店按钮
		local home_click_hero_shop_terminal = {
            _name = "home_click_hero_shop",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			--向服务器发送请求
                    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                        local isopen,tip = getFunopenLevelAndTip(41)
                        if isopen == true then
                            local function recruitCallBack(response)
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    app.load("client.shop.hero.HeroShop")
                                    fwin:open(HeroShop:new(), fwin._view)             
                                end
                            end
                            if _ED.secret_shop_init_info.os_time == nil or _ED.secret_shop_init_info.os_time == "" then
                                NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
                            else
                                local times = os.time()- tonumber(_ED.secret_shop_init_info.os_time)
                                local leave_time = _ED.secret_shop_init_info.refresh_time/1000-times
                                if leave_time <= 0 then
                                    NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, self, recruitCallBack, false, nil)
                                else
                                    recruitCallBack({RESPONSE_SUCCESS = true,PROTOCOL_STATUS = 0})
                                end
                            end
                        else
                            TipDlg.drawTextDailog(tip)
                        end
						state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                        state_machine.excute("home_hide_event", 0, "home_hide_event.")
                    else
                        app.load("client.shop.hero.HeroShop")
                        fwin:open(HeroShop:new(), fwin._view)  
                        state_machine.excute("menu_adventure_open_button", 0, 0) 
                    end
					-- local function recruitCallBack(response)
						-- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
      --                   -------------------
      --                   if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
      --                       local function recruitCallBack(response)
      --                           if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
      --                               app.load("client.shop.hero.HeroShop")
      --                               fwin:open(HeroShop:new(), fwin._view)             
      --                           end
      --                       end
      --                       NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
						-- else
      --                   	app.load("client.shop.hero.HeroShop")
						-- 	fwin:open(HeroShop:new(), fwin._view) 
						-- end	
      --                   ----------------------
						-- end
					-- end
					
					-- protocol_command.secret_shop_init.param_list = "".._ED.user_info.user_id
					-- NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
						state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                        state_machine.excute("home_hide_event", 0, "home_hide_event.")
					end
                    if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
                        state_machine.excute("menu_adventure_open_button", 0, 0) 
                    end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local push_infomation_home_terminal = {
            _name = "push_infomation_home",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if self.index ~= nil then 
                    if __lua_project_id == __lua_project_adventure then

                        --state_machine.excute("push_info_update_draw", 0, "")
                    else
					   fwin:open(PushInfo:new(), fwin._background)--打开消息推送
                    end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local close_push_infomation_home_terminal = {
            _name = "close_push_infomation_home",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if self.index ~= nil then 
					fwin:close(fwin:find("PushInfoClass"))--关闭消息推送
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local push_infomation_home_update_draw_hero_intro_terminal = {
            _name = "push_infomation_home_update_draw_hero_intro",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateDrawHeroIntro(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local home_click_strategy_terminal = {
            _name = "home_click_strategy",
            _init = function (terminal) 
                app.load("client.home.strategy.Strategy")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    app.load("client.home.lstrategy.LStrategy")
                    state_machine.excute("lstrategy_main_open", 0, nil)
                else
                    state_machine.excute("menu_clean_page_state", 0,"") 
                    fwin:open(Strategy:new(), fwin._view)
                    -- TipDlg.drawTextDailog(_function_unopened_tip_string)
                end
                if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
                    state_machine.excute("menu_adventure_open_button", 0, 0) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 打开包裹的主界面
        local home_click_package_terminal = {
            _name = "home_click_package",
            _init = function (terminal) 
                app.load("client.packs.prop.PropStorage")
                app.load("client.packs.prop.SmPropWarehouse")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    state_machine.excute("prop_warehouse_window_open", 0, nil)
                else
                    if __lua_project_id == __lua_project_gragon_tiger_gate
                        or __lua_project_id == __lua_project_red_alert 
                        or __lua_project_id == __lua_project_legendary_game
                        then
                        fwin:open(PropStorage:new(), fwin._background)
                    else
    				    state_machine.excute("menu_clean_page_state", 0,"")
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
                end
				if __lua_project_id == __lua_project_gragon_tiger_gate
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then			--龙虎门项目控制
					state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                    state_machine.excute("home_hide_event", 0, "home_hide_event.")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 打开Home时，是否打开HomHero
        local home_change_open_atrribute_terminal = {
            _name = "home_change_open_atrribute",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance._needOpenHomeHero = params
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 隐藏界面
        local home_hide_event_terminal = {
            _name = "home_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.onHide ~= nil and instance.roots ~= nil then
                    instance:onHide()
                    state_machine.excute("home_hero_hide_event", 0, "home_hero_hide_event")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local home_show_event_terminal = {
            _name = "home_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
    				instance:onShow()
                    state_machine.excute("home_hero_show_event", 0, "home_hero_show_event")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local Button_lilian_campaign_show_terminal = {
            _name = "Button_lilian_campaign_show",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("arena_window_open", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--主界面三国志按钮跳转
		local home_goto_destiny_system_terminal = {
            _name = "home_goto_destiny_system",
            _init = function (terminal) 
                 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("home_manager", 0, {_datas={terminal_name = "home_manager", next_terminal_name = "home_click_destiny_system",but_image = "Image_home", terminal_state = 0, isPressedActionEnabled = true}})
						local next_terminal_name = params._datas.next_terminal_name
						if nil ~= next_terminal_name then
							state_machine.excute(next_terminal_name, 0, params._datas.next_params)
						end
                        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                            if params._datas.cell ~= nil then
                                state_machine.excute("destiny_system_set_prop_cell",0,params._datas.cell)
                            end
                        end
					end
				end
                if __lua_project_id == __lua_project_yugioh
                    or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge
                    then
                    if tonumber(_ED.user_info.user_grade) < dms.int(dms["fun_open_condition"], 9, fun_open_condition.level) then
                        TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 9, fun_open_condition.tip_info))
                        return
                    end
                end
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    if _ED.cur_star_count == "" or _ED.cur_star_count == nil then
                        local _data = NetworkManager:find(protocol_command.destiny_init.code) 
                        if nil ~= _data then
                            _data.handler = recruitCallBack
                        else
                            NetworkManager:register(protocol_command.destiny_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
                        end  
                    else
                        recruitCallBack({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                    end
                else
    				local _data = NetworkManager:find(protocol_command.destiny_init.code) 
    				if nil ~= _data then
    					_data.handler = recruitCallBack
    				else
    					NetworkManager:register(protocol_command.destiny_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
    				end
				end
                if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
                   state_machine.excute("menu_adventure_open_button", 0, 0) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--主界面军团按钮跳转
		local home_goto_click_union_terminal = {
            _name = "home_goto_click_union",
            _init = function (terminal) 
                 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if ___is_open_union == false then
                    return
                end
				state_machine.excute("menu_adventure_open_button", 0, 0)
				local isOpen_union  = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 11, fun_open_condition.level)
				if false == isOpen_union then
					TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 11, fun_open_condition.tip_info))
					return
				end
				if _ED.union.union_info == nil or _ED.union.union_info == {}  or  _ED.union.union_info.union_id == nil or _ED.union.union_info.union_id == "" then
					local function responseUnionListCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if zstring.tonumber(_ED.union.union_list_sum) == 0 then -- 第一个军团时
								state_machine.excute("home_manager", 0, {_datas={terminal_name = "home_manager", next_terminal_name = "home_click_union",but_image = "Image_home", terminal_state = 0,gotype=1 , isPressedActionEnabled = true}})
								 return true
							else
                                if _ED.union.union_info == nil or _ED.union.union_info == {}  or  _ED.union.union_info.union_id == nil or _ED.union.union_info.union_id == "" then
                                    state_machine.excute("home_manager", 0, {_datas={terminal_name = "home_manager", next_terminal_name = "home_click_union",but_image = "Image_home", terminal_state = 0,gotype=1 , isPressedActionEnabled = true}})
                                else
                                    local function responseCallback( response )
                                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then                
                                            state_machine.excute("home_manager", 0, {_datas={terminal_name = "home_manager", next_terminal_name = "home_click_union",but_image = "Image_home", terminal_state = 0,gotype=2 , isPressedActionEnabled = true}})
                                        end
                                    end
                                    if tonumber(_ED.union.union_member_list_sum) == nil then 
                                        NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, nil, responseCallback, false, nil)                    
                                    else
                                        state_machine.excute("home_manager", 0, {_datas={terminal_name = "home_manager", next_terminal_name = "home_click_union",but_image = "Image_home", terminal_state = 0,gotype=2 , isPressedActionEnabled = true}})
                                    end
                                end

                                return true
							end	
						end
					end	
					_ED.union.union_list_info = nil
					protocol_command.union_list.param_list = "0"
					NetworkManager:register(protocol_command.union_list.code, nil, nil, nil, self, responseUnionListCallback, false, nil)
					-- state_machine.excute("union_join_open", 0, response.node)
				else
					-- state_machine.excute("Union_open", 0, response.node)
					local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then                
                            state_machine.excute("home_manager", 0, {_datas={terminal_name = "home_manager", next_terminal_name = "home_click_union",but_image = "Image_home", terminal_state = 0,gotype=2 , isPressedActionEnabled = true}})
                        end
                    end
                    if tonumber(_ED.union.union_member_list_sum) == nil then 
                        NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, nil, responseCallback, false, nil)                    
                    else
                        -- 进入公会界面
                        state_machine.excute("home_manager", 0, {_datas={terminal_name = "home_manager", next_terminal_name = "home_click_union",but_image = "Image_home", terminal_state = 0,gotype=2 , isPressedActionEnabled = true}})
                    end
                end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --抽卡 --游戏王
        local home_goto_click_recruit_terminal = {
            _name = "home_goto_click_recruit",
            _init = function (terminal) 
                 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_yugioh then
                    state_machine.excute("menu_clean_page_state", 0, "home")
                end
                local _shop = Shop:new()
                fwin:open(_shop, fwin._view)
                state_machine.excute("menu_adventure_open_button", 0, 0)
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
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         -- 占领
        local home_capture_open_terminal = {
            _name = "home_capture_open",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _level = tonumber(dms.string(dms["fun_open_condition"],55, fun_open_condition.level))
                local user_level = tonumber(_ED.user_info.user_grade)
                if user_level < _level then
                -- state_machine.excute("menu_clean_page_state", 0, "")
                    local text = dms.string(dms["fun_open_condition"],55, fun_open_condition.tip_info)
                    TipDlg.drawTextDailog(text)
                    return
                end
                app.load("client.captureResource.CaptureResourceMain")
                if _ED.capture_resource_build_info == nil then
                    local function responseCaptureCallback(response)
                        state_machine.excute("capture_resource_open", 0, nil)
                        state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                        state_machine.excute("home_hide_event", 0, "home_hide_event.")                        
                    end
                    NetworkManager:register(protocol_command.map_scattered_init.code, nil, nil, nil, self, responseCaptureCallback, false, nil)                     
                else
                    state_machine.excute("capture_resource_open", 0, nil)
                    state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                    state_machine.excute("home_hide_event", 0, "home_hide_event.")  
                end

                

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

	    -- 显示爆衣按钮
        local home_baoyi_button_terminal = {
            _name = "home_baoyi_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local shipId = zstring.tonumber(params._datas._shipId)
                local currentPage = params._datas._currentPage
                instance:updatabaoyi(shipId,currentPage)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         -- 点击爆衣按钮
        local home_baoyi_button_enter_terminal = {
            _name = "home_baoyi_button_enter",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("home_baoyi_button_enter", 0, "")
                if params._datas._currentPage._lock == nil or params._datas._currentPage._lock == false then
                    params._datas._currentPage._lock = true
                    if params._datas._currentPage._baoyi == nil or params._datas._currentPage._baoyi == false then
                        params._datas._currentPage._baoyi = true
                        instance:updatabaoyi(params._datas._shipId,params._datas._currentPage,false)
                        local shipId = params._datas._shipId
                        local shipPic = tonumber(dms.string(dms["ship_mould"], shipId, ship_mould.bust_index)) + 10000
                        local path = string.format("images/face/big_head/big_head_%d.png", shipPic)
                        params._datas._currentPage:onUpdateDraw(path)
                    elseif params._datas._currentPage._baoyi ~= nil and params._datas._currentPage._baoyi == true then
                        params._datas._currentPage._baoyi = false
                        local shipId = params._datas._shipId
                        local shipPic = tonumber(dms.string(dms["ship_mould"], shipId, ship_mould.bust_index))
                        local path = string.format("images/face/big_head/big_head_%d.png", shipPic)
                        params._datas._currentPage:onUpdateDraw(path)
                        instance:updatabaoyi(0,params._datas._currentPage,true)
                    end
                end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         --facebook
        local home_goto_click_faceBook_url_terminal = {
            _name = "home_goto_click_faceBook_url",
            _init = function (terminal)
    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                handlePlatformRequest(0, CC_OPEN_URL_LAYOUT, _face_book_url)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --客服
        local home_goto_click_gm_url_terminal = {
            _name = "home_goto_click_gm_url",
            _init = function (terminal)
    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("platform_operator_openurl", 0,"")
                --handlePlatformRequest(0, CC_OPEN_URL_LAYOUT, app.configJson.urlweb)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 冒险与挖矿的独立状态机
        -- 讨论区
        local home_adventure_forum_terminal = {
            _name = "home_adventure_forum",
            _init = function (terminal)
                app.load("client.adventure.chat.AdventureChatStorage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                    fwin:open(AdventureChatStorage:new(), fwin._windows)
                -- state_machine.excute("menu_adventure_open_button", 0,"")
                -- state_machine.excute("menu_clean_page_state", 0,"")

                -- fwin:open(AdventureForums:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_adventure_fanpage_terminal = {
            _name = "home_adventure_fanpage",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	    	    --弹出粉丝页窗口
	    	    state_machine.excute("platform_the_open_fans_page", 0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 礼包
        local home_adventure_gift_bag_terminal = {
            _name = "home_adventure_gift_bag",
            _init = function (terminal)
                app.load("client.adventure.activity.reward.AdventureRewardCenter")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureRewardCenter:new():init(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 好友
        local home_adventure_friends_terminal = {
            _name = "home_adventure_friends",
            _init = function (terminal)
                app.load("client.adventure.friend.AdventureFriendManger")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("menu_clean_page_state", 0,"")
                fwin:open(AdventureFriendManger:new():init(), fwin._view)
                state_machine.excute("menu_adventure_open_button", 0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 设置
        local home_adventure_system_set_terminal = {
            _name = "home_adventure_system_set",
            _init = function (terminal)
                app.load("client.adventure.system.set.AdventureSet")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureSet:new():init(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		 -- 更多
        local home_adventure_more_system_terminal = {
            _name = "home_adventure_more_system",
            _init = function (terminal)
				app.load("client.adventure.home.MoreSystem")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(MoreSystem:new():init(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 商店
        local home_adventure_shop_terminal = {
            _name = "home_adventure_shop",
            _init = function (terminal)
                app.load("client.adventure.shop.AdventureShop")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("menu_clean_page_state", 0,"")
                fwin:open(AdventureShop:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 签到
        local home_adventure_sign_in_terminal = {
            _name = "home_adventure_sign_in",
            _init = function (terminal)
                app.load("client.adventure.activity.sign.AdventureDailySignIn")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureDailySignIn:new():init(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 月卡
        local home_adventure_month_card_terminal = {
            _name = "home_adventure_month_card",
            _init = function (terminal)
                app.load("client.adventure.activity.month_card.AdventureMonthCard")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureMonthCard:new():init(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 活动
        local home_adventure_activity_terminal = {
            _name = "home_adventure_activity",
            _init = function (terminal)
                app.load("client.adventure.activity.AdventureActivityWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("menu_clean_page_state", 0,"")
                fwin:open(AdventureActivityWindow:new():init(), fwin._view)
                state_machine.excute("menu_adventure_open_button", 0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 成就
        local home_adventure_achievement_terminal = {
            _name = "home_adventure_achievement",
            _init = function (terminal)
                app.load("client.adventure.achievement.AdventureAchievement")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                state_machine.excute("menu_clean_page_state", 0,"")
                fwin:open(AdventureAchievement:new():init(), fwin._view)
                state_machine.excute("menu_adventure_open_button", 0,"")
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 黑市
        local home_adventure_black_market_terminal = {
            _name = "home_adventure_black_market",
            _init = function (terminal)
                app.load("client.adventure.activity.black_market.AdventureBlackMarket")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("menu_adventure_open_button", 0,"")
                state_machine.excute("menu_clean_page_state", 0,"")
                fwin:open(AdventureBlackMarket:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 公告
        local home_adventure_notice_terminal = {
            _name = "home_adventure_notice",
            _init = function (terminal)
                app.load("client.adventure.system.notice.AdventureNotice")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureNotice:new():init(2), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --讨论区
        local home_adventure_discuss_terminal = {
            _name = "home_adventure_discuss",
            _init = function (terminal)
                --app.load("client.adventure.system.notice.AdventureNotice")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureNotice:new():init(2), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		-- 挖矿项目功能锁
        local home_adventure_update_open_condition_terminal = {
            _name = "home_adventure_update_open_condition",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--月卡 评审状态
				if funOpenConditionJudge(56) == true and zstring.tonumber(_ED.server_review) == 0 then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_yueka"):setVisible(true)
					--ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1"):setVisible(true)
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_yueka"):setVisible(false)
					--ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1"):setVisible(false)
				end
				--黑市
				if funOpenConditionJudge(57) == true then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_heishi"):setVisible(true)
					--ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_0"):setVisible(true)
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_heishi"):setVisible(false)
					--ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_0"):setVisible(false)
				end
				--好友
				if funOpenConditionJudge(58) == true then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_haoyou"):setVisible(true)
					--ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_1"):setVisible(true)
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_haoyou"):setVisible(false)
					--ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_1"):setVisible(false)
				end
				--活动
				if funOpenConditionJudge(59) == true then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_huodong"):setVisible(true)
					--ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_2"):setVisible(true)
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_huodong"):setVisible(false)
					--ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_2"):setVisible(false)
				end
				--商店
				-- if funOpenConditionJudge(60) == true then
				-- 	ccui.Helper:seekWidgetByName(instance.roots[1], "Button_shangdian"):setVisible(true)
				-- 	ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_0_0"):setVisible(true)
				-- else
				-- 	ccui.Helper:seekWidgetByName(instance.roots[1], "Button_shangdian"):setVisible(false)
				-- 	ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_0_0"):setVisible(false)
				-- end
				--更多
				if funOpenConditionJudge(61) == true then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_more"):setVisible(true)
					--ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_1_0"):setVisible(true)
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_more"):setVisible(false)
					--ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_1_0"):setVisible(false)
				end

                if funOpenConditionJudge(62) == true then
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chengjiu"):setVisible(true)
                    --ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_1_0"):setVisible(true)
                else
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Button_chengjiu"):setVisible(false)
                    --ccui.Helper:seekWidgetByName(instance.roots[1], "Image_1_1_0"):setVisible(false)
                end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		
        local home_more_setting_update_terminal = {
            _name = "home_more_setting_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _paramsdata = params._datas
                local root = _paramsdata.cell.roots[1]
                local action = _paramsdata.cell.actions[1]
                local  Panel_103 = ccui.Helper:seekWidgetByName(root, "Panel_103")
                if _paramsdata.status == true then
                    Panel_103:setVisible(false)
                    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                        action:setTimeSpeed(app.getTimeSpeed())
                    end
                    action:play("Panel_126_untonch", false)
                else
                    Panel_103:setVisible(true)
                    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                        action:setTimeSpeed(app.getTimeSpeed())
                    end
                    action:play("Panel_126_tonch", false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 检查等级奖励是否领取完了
        local home_check_level_packs_terminal = {
            _name = "home_check_level_packs",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:checkLevelPacks(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		 -- 舰娘分享成功
        local home_get_share_ok_terminal = {
            _name = "home_get_share_ok",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local share_id = params
				if params ~= nil and params ~= "" then
					share_id = "1"
				end
				local function responseAreaShareOkCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("arena_share_close",0,"")   --关闭分享界面
					end
				end
				protocol_command.share_game.param_list = ""..share_id
				NetworkManager:register(protocol_command.share_game.code,nil,nil, nil, nil, responseAreaShareOkCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开数码每日领取
        local sm_open_every_day_online_reward_terminal = {
            _name = "sm_open_every_day_online_reward",
            _init = function (terminal)
                app.load("client.l_digital.home.SmEveryDayOnlineReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_every_day_online_reward_open",0,"sm_every_day_online_reward_open.")
                state_machine.excute("sm_every_day_online_reward_define",0,"sm_every_day_online_reward_define.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --模块参与提示
        local sm_model_join_push_goto_join_terminal = {
            _name = "sm_model_join_push_goto_join",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currId = params._datas.shortCut
                params:setVisible(false)
                local current_time = _ED.system_time + (os.time() - _ED.native_time)
                cc.UserDefault:getInstance():setStringForKey(getKey("ship_purify_push_time"..currId), current_time)
                cc.UserDefault:getInstance():flush()
                if currId == 1 then
                    state_machine.excute("sm_union_red_envelopes_open", 0, nil)
                elseif currId == 2 then
                    state_machine.excute("union_fighting_main_open", 0, nil)
                elseif currId == 3 then
                    state_machine.excute("explore_window_open", 0, "3")
                    -- state_machine.excute("explore_window_open_fun_window", 0, { _datas = {page_index = 3} })
                elseif currId == 4 then
                    app.load("client.l_digital.campaign.Campaign")
                    state_machine.excute("campaign_window_open", 0, nil)
                    state_machine.excute("sm_battleof_kings_window_open", 0, nil)
                elseif currId == 5 then
                    app.load("client.l_digital.campaign.Campaign")
                    state_machine.excute("campaign_window_open", 0, nil)
                    state_machine.excute("sm_cross_server_battleof_kings_window_open", 0, nil)
                end
                _ED.home_activity_push_info[currId].isWaitOpen = false
                _ED.home_activity_push_info[currId].isHaveOpen = false
                local openIndex = 0
                for k,v in pairs(_ED.home_activity_push_info) do
                    if v ~= nil and (v.isWaitOpen == true or v.isAllShow == true) then
                        openIndex = k
                        break
                    end
                end
                if openIndex ~= 0 then
                    if openIndex == 4 then
                        instance:updateHomeAcivityPushUIInfo(openIndex, _ED.home_activity_push_info[4].isAllShow)
                    else
                        instance:updateHomeAcivityPushUIInfo(openIndex, false)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --功能开启浏览
        local sm_model_open_push_scan_terminal = {
            _name = "sm_model_open_push_scan",
            _init = function (terminal)
                app.load("client.l_digital.home.SmModelOpenPushScan")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currId = params._datas.shortCut
                state_machine.excute("sm_model_open_push_scan_open",0,currId)
                _ED.system_fun_open_event = 0
                local Image_funopen_tip = ccui.Helper:seekWidgetByName(instance.roots[1], "Image_funopen_tip")
                if Image_funopen_tip ~= nil then
                    Image_funopen_tip:setVisible(false)
                end
                --红点隐藏
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --功能开启刷新
        local sm_model_open_push_updata_terminal = {
            _name = "sm_model_open_push_updata",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:modelOpenPush()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        
        --布阵刷新
        local sm_model_open_layout_refresh_draw_terminal = {
            _name = "sm_model_open_layout_refresh_draw",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if true then
                    return
                end
                local Panel_fomation_role = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_fomation_role")
                if Panel_fomation_role ~= nil then
                    Panel_fomation_role:removeAllChildren(true)

                    local formetion_index = 1
                    local ships = nil
                    for i,v in pairs(_ED.user_formetion_status) do
                        if _ED.user_ship[""..v] ~= nil then
                            formetion_index = i
                            ships = _ED.user_ship[""..v]
                            break
                        end
                    end

                    if ships ~= nil then
                        local _ship_mould_id = ships.ship_template_id
                        local temp_bust_index = 0
                        ----------------------新的数码的形象------------------------
                        --进化形象
                        local evo_image = dms.string(dms["ship_mould"], _ship_mould_id, ship_mould.fitSkillTwo)
                        local evo_info = zstring.split(evo_image, ",")
                        --进化模板id
                        local ship_evo = zstring.split(ships.evolution_status, "|")
                        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
                        --新的形象编号
                        temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

                        draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_fomation_role, nil, nil, cc.p(0.5, 0))
                        app.load("client.battle.fight.FightEnum")
                        local shipSpine = sp.spine_sprite(Panel_fomation_role, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))

                        fwin:addTouchEventListener(Panel_fomation_role,   nil, 
                        {
                            terminal_name = "home_hero_into_formation_page",    
                            terminal_state = 0, 
                            _heroInstance = ships,
                            _formetion_index = formetion_index,
                            isPressedActionEnabled = true
                        }, 
                        nil, 0)
                    end  
                    Panel_fomation_role._istips = nil
                    Panel_fomation_role._nodeChild = nil
                    state_machine.excute("notification_center_remove_widget", 0, { _widget = Panel_fomation_role })
                    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_develop_home_hero_icon",
                        _widget = Panel_fomation_role,
                        _invoke = nil,
                        _interval = 0.5,}) 
                        end   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开动画
        local sm_model_open_the_animation_terminal = {
            _name = "sm_model_open_the_animation",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                local tipCell = nil
                if __lua_project_id == __lua_project_l_digital then
                    local Image_8 = ccui.Helper:seekWidgetByName(instance.roots[1], "Image_8")
                    local Panel_18 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_18")
                    if Panel_18:getChildByName("tip_Popup") == nil then
                        tipCell = state_machine.excute("home_tips_to_get_list_create", 0, nil)
                        Panel_18:addChild(tipCell)
                        tipCell:setName("tip_Popup")
                    else
                        tipCell = Panel_18:getChildByName("tip_Popup")
                    end
                end
                if tipCell ~= nil then
                    tipCell.action:play("animation_open", false)
                else
                    instance.actions[1]:play("animation_open", false)
                    if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                        or __lua_project_id == __lua_project_l_naruto
                        then
                    else
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Button_guanbi"):setVisible(true)
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Button_zhankai"):setVisible(false)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭动画
        local sm_model_close_the_animation_terminal = {
            _name = "sm_model_close_the_animation",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
               
                local tipCell = nil
                if __lua_project_id == __lua_project_l_digital then
                    local Image_8 = ccui.Helper:seekWidgetByName(instance.roots[1], "Image_8")
                    local Panel_18 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_18")
                    if Panel_18:getChildByName("tip_Popup") == nil then
                        tipCell = state_machine.excute("home_tips_to_get_list_create", 0, nil)
                        Panel_18:addChild(tipCell)
                        tipCell:setName("tip_Popup")
                    else
                        tipCell = Panel_18:getChildByName("tip_Popup")
                    end
                end
                if tipCell ~= nil then
                    tipCell.action:play("animation_close", false)
                else
                    instance.actions[1]:play("animation_close", false)
                    if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    else
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Button_guanbi"):setVisible(false)
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Button_zhankai"):setVisible(true)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_update_top_activity_info_state_terminal = {
            _name = "home_update_top_activity_info_state",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.onUpdateDrawEx ~= nil then
                    instance:onUpdateDrawEx()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 活动推送刷新
        local sm_home_update_activity_push_state_terminal = {
            _name = "sm_home_update_activity_push_state",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 转点推送
                local server_time = getCurrentGTM8Time()
                local update_leave_time = (24 - server_time.hour) * 3600 - server_time.min * 60 - server_time.sec + 1

                -- 体力领取推送
                local energyData = zstring.split(dms.string(dms["activity_config"], 1, activity_config.param), "|")
                local add_enger_info = zstring.split(_ED._add_enger_info,"|")
                local energy_leave_time = 0
                for i=1, 4 do
                    local energy_info = zstring.split(energyData[i], ",")
                    local next_time_info = zstring.split(energy_info[1], ":")       -- 下一次体力领取时间
                    local next_leave_time = (tonumber(next_time_info[1]) - server_time.hour) * 3600 + (tonumber(next_time_info[2]) - server_time.min) * 60 + (tonumber(next_time_info[3]) - server_time.sec)
                    if next_leave_time > 0 then
                        energy_leave_time = next_leave_time
                        break
                    end
                end

                local activity_type = 0
                local leave_time = update_leave_time
                if energy_leave_time > 0 and energy_leave_time < update_leave_time then
                    activity_type = 1001
                    leave_time = energy_leave_time
                end

                local function callback(sender)
                    state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, activity_type)
                    state_machine.excute("sm_home_update_activity_push_state", 0, "")
                end
                instance:runAction(cc.Sequence:create(
                    cc.DelayTime:create(leave_time),
                    cc.CallFunc:create(callback)))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_update_online_reward_info_state_terminal = {
            _name = "home_update_online_reward_info_state",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil 
                    and instance.everyDayOnlinePanel == nil then
                    local Panel_online_reward = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_online_reward")
                    if Panel_online_reward ~= nil and not instance._localOnlineGiftHidden then
                        if false == funOpenDrawTip(162, false) then
                            instance.everyDayOnlinePanel = Panel_online_reward
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_update_mission_over_finder_state_terminal = {
            _name = "home_update_mission_over_finder_state",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    if instance.showFinder ~= nil then
                        if tonumber(_ED.user_info.user_grade) < 10 then
                            instance:showFinder()
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_update_target_task_info_state_terminal = {
            _name = "home_update_target_task_info_state",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateTargetTaskState()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_update_back_pack_clock_pic_terminal = {
            _name = "home_update_back_pack_clock_pic",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 是否拥有号令忍界限时道具
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    local root = instance.roots[1]
                    local Image_clock = ccui.Helper:seekWidgetByName(root, "Image_clock")
                    if Image_clock ~= nil then
                        Image_clock:setVisible(false)
                        if _ED.active_activity[174] ~= nil then
                            local time_info = _ED.active_activity[174].serverEndTime
                            if time_info ~=nil then
                                local _localEndTime = _ED.active_activity[174].serverEndTime.localEndTime
                                local _crossServerEndTime = _ED.active_activity[174].serverEndTime.crossEndTime
                                if _crossServerEndTime ~= nil and _localEndTime ~= nil  then
                                    if difftime(_localEndTime) < 0 and difftime(_crossServerEndTime) < 43200000 then
                                        local props = _ED.user_prop
                                        local success = false
                                        local prop_arrs = zstring.splits(dms.string(dms["activity_config"], 80, activity_config.param), "|", ",")
                                        for k,prop_info in pairs(props) do
                                            for i,v in ipairs(prop_arrs) do
                                                if tonumber(v[2]) == tonumber(prop_info.user_prop_template) then
                                                    success = true
                                                    break
                                                end
                                            end
                                        end
                            
                                        Image_clock:setVisible(success)
                                    end
                                end
                            end
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 客服反馈入口
        local home_customer_server_open_terminal = {
            _name = "home_customer_server_open",
            _init = function (terminal)
                app.load("client.l_digital.player.SmPlayerSystemQAWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_player_system_qa_window_open",0,"")
               
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 聊天框上部分按钮移动动画
        local home_line_btn_move_terminal = {
            _name = "home_line_btn_move",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then 
                    local mType = params[1]
                    local distance = params[2]

                    local Panel_mailanima = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_mailanima")
                    if Panel_mailanima == nil then
                        Panel_mailanima = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_mailanima_xr1")
                    end

                    if mType == 2 then 
                        -- 上移
                        Panel_mailanima:setPositionY(Panel_mailanima:getPositionY() + distance)
                    else
                        -- 下移
                        Panel_mailanima:setPositionY(Panel_mailanima:getPositionY() - distance)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- DSC新招募系统
        local home_new_recruit_main_terminal = {
            _name = "home_new_recruit_main",
            _init = function (terminal)
                app.load("client.shop.newrecruit.NewRecruitMain")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("new_recruit_main_window_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 增加战令经验
        local add_war_order_exp_terminal = {
            _name = "add_war_order_exp",
            _init = function (terminal)
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local exp = params
                fwin:addService({
                    callback = function ( warOrderExp )
                        TipDlg.drawTextDailog(string.format(war_order_str[18], warOrderExp))
                    end,
                    delay = 1,
                    params = exp
                })
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 控制活动listview的收放
        local home_activity_listview_control_open_and_shrink_terminal = {
            _name = "home_activity_listview_control_open_and_shrink",
            _init = function (terminal)
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    state_machine.lock("home_activity_listview_control_open_and_shrink")
                    instance.isShowActivityList = (not instance.isShowActivityList)
                    instance:onClickDisplayActivityIcon()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 彩蛋活动迪路兽动作切换
        local home_easter_egg_role_animation_change_terminal = {
            _name = "home_easter_egg_role_animation_change",
            _init = function (terminal)
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    local mType = params.type
                    if mType == 1 then 
                        -- 出现
                        local Panel_role = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_role")
                        Panel_role:removeAllChildren(true)
                        local jsonFile = "images/ui/effice/effice_zhuchengcaidan1/effice_zhuchengcaidan1.json"
                        local atlasFile = "images/ui/effice/effice_zhuchengcaidan1/effice_zhuchengcaidan1.atlas"
                        self.easterEggRoleSp = sp.spine(jsonFile, atlasFile, 1, 0, "animation1", false, nil)
                        self.easterEggRoleSp:setAnimation(0, "animation1", false)
                        Panel_role:addChild(self.easterEggRoleSp)
                        self.easterEggRoleSp:registerSpineEventHandler(
                            function(event)
                                -- 切换待机
                                self.easterEggRoleSp:setToSetupPose()
                                self.easterEggRoleSp:setAnimation(0, "animation3", true)
                            end,
                            sp.EventType.ANIMATION_COMPLETE
                        )

                    elseif mType == 2 then 
                        -- 消失
                        self.easterEggRoleSp:setToSetupPose()
                        self.easterEggRoleSp:setAnimation(0, "animation2", false)
                        self.easterEggRoleSp:registerSpineEventHandler(
                            function(event)
                                self.easterEggRoleSp:removeFromParent(true)
                            end,
                            sp.EventType.ANIMATION_COMPLETE
                        )
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开首冲界面
        local home_open_first_recharge_activity_terminal = {
            _name = "home_open_first_recharge_activity",
            _init = function (terminal)
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local isOpen = false
                -- 首冲重塑
                if _ED.active_activity[193] ~= nil and GetFlagActivityForFirstRecharge() then
                    local function requestCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            app.load("client.activity.first_recharge.FirstRechargeWindow")
                            state_machine.excute("first_recharge_window_open", 0, "")
                        end
                    end
                    NetworkManager:register(protocol_command.first_charge_init.code, nil, nil, nil, nil, requestCallBack, false, nil)
                    isOpen = true
                end
                -- 首冲
                app.load("client.activity.ActivityRichFirstRecharge")
                if state_machine.excute("activity_rich_first_recharge_open", 0, "") == true then
                    isOpen = true
                end

                return isOpen
            end,
            _terminal = nil,
            _terminals = nil
        }

		if state_machine.find("home_manager") == nil then
			state_machine.add(home_manager_terminal)
		end
        state_machine.add(home_line_btn_move_terminal)
        state_machine.add(home_customer_server_open_terminal)
		state_machine.add(home_goto_destiny_system_terminal)
		state_machine.add(home_goto_click_union_terminal)
		state_machine.add(home_update_first_recharge_terminal)
		-- state_machine.add(home_click_out_page_terminal)
		-- state_machine.add(home_click_in_page_terminal)
		state_machine.add(home_click_union_terminal)
		state_machine.add(home_click_daily_tasks_terminal)
		state_machine.add(home_click_fame_hall_terminal)
		state_machine.add(home_click_friend_manager_terminal)
		state_machine.add(home_click_email_manager_terminal)
		state_machine.add(home_click_recover_terminal)
	

		state_machine.add(home_click_generals_terminal)
        if __lua_project_id == __lua_project_yugioh then
            state_machine.add(home_click_magic_card_terminal)
        end
        state_machine.add(home_click_pets_terminal)
		state_machine.add(home_click_equipment_terminal)
		state_machine.add(home_click_recharge_terminal)
		state_machine.add(home_click_vip_terminal)
		state_machine.add(home_click_treasure_terminal)

		state_machine.add(home_click_CatalogueStorage_terminal)
		state_machine.add(home_click_install_terminal)
		
		state_machine.add(home_click_chat_terminal)
		state_machine.add(home_click_sevendays_activity_terminal)
		state_machine.add(home_click_destiny_system_terminal)
		state_machine.add(home_click_hero_shop_terminal)

		state_machine.add(home_click_activity_terminal)
		state_machine.add(home_recharge_activity_terminal)
		
		state_machine.add(push_infomation_home_terminal)
		state_machine.add(close_push_infomation_home_terminal)
        state_machine.add(push_infomation_home_update_draw_hero_intro_terminal)
        state_machine.add(home_click_strategy_terminal)
        state_machine.add(home_update_back_pack_clock_pic_terminal)
        if ___is_open_laster == true then
            state_machine.add(home_baoyi_button_terminal)
            state_machine.add(home_baoyi_button_enter_terminal)
        end
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
			state_machine.add(home_click_package_terminal)
			state_machine.add(home_change_open_atrribute_terminal)
			state_machine.add(home_hide_event_terminal)
			state_machine.add(home_show_event_terminal)
            state_machine.add(home_more_setting_update_terminal)
            state_machine.add(home_check_level_packs_terminal)
            state_machine.add(home_capture_open_terminal)
		end

        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
            state_machine.add(Button_lilian_campaign_show_terminal)
        end

        if __lua_project_id == __lua_project_adventure then
            state_machine.add(home_adventure_forum_terminal)
	        state_machine.add(home_adventure_fanpage_terminal)
            state_machine.add(home_adventure_gift_bag_terminal)
            state_machine.add(home_adventure_friends_terminal)
            state_machine.add(home_adventure_system_set_terminal)
            state_machine.add(home_adventure_shop_terminal)
            state_machine.add(home_adventure_sign_in_terminal)
            state_machine.add(home_adventure_month_card_terminal)
            state_machine.add(home_adventure_activity_terminal)
            state_machine.add(home_adventure_achievement_terminal)
            state_machine.add(home_adventure_black_market_terminal)
            state_machine.add(home_adventure_notice_terminal)
			state_machine.add(home_adventure_more_system_terminal)
			state_machine.add(home_adventure_update_open_condition_terminal)
        end
        if __lua_project_id == __lua_project_yugioh then
            state_machine.add(home_goto_click_recruit_terminal)
        end
        state_machine.add(home_click_recommend_formation_terminal)
        state_machine.add(home_get_share_ok_terminal)
        state_machine.add(home_goto_click_faceBook_url_terminal)
        state_machine.add(home_goto_click_gm_url_terminal)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            state_machine.add(sm_open_every_day_online_reward_terminal)
            state_machine.add(sm_model_join_push_goto_join_terminal)
            state_machine.add(sm_model_open_push_scan_terminal)
            state_machine.add(sm_model_open_push_updata_terminal)
            state_machine.add(sm_model_open_layout_refresh_draw_terminal)
            state_machine.add(sm_model_open_the_animation_terminal)
            state_machine.add(sm_model_close_the_animation_terminal)
            state_machine.add(home_update_top_activity_info_state_terminal)
            state_machine.add(sm_home_update_activity_push_state_terminal)
            state_machine.add(home_update_online_reward_info_state_terminal)
            state_machine.add(home_update_mission_over_finder_state_terminal)
            state_machine.add(home_update_target_task_info_state_terminal)
        end

        state_machine.add(home_new_recruit_main_terminal)
        state_machine.add(add_war_order_exp_terminal)

        state_machine.add(home_activity_listview_control_open_and_shrink_terminal)
        state_machine.add(home_easter_egg_role_animation_change_terminal)
        state_machine.add(home_open_first_recharge_activity_terminal)
        state_machine.init()
    end
    -- call func init hom state machine.
    init_home_terminal()
end
function Home:checkLevelPacks(_type)
    local root = self.roots[1]
    if _type == 1 then
        local Button_level_pack = ccui.Helper:seekWidgetByName(root,"Button_level_pack")
        Button_level_pack:setVisible(true)
        return
    end
    if __lua_project_id == __lua_project_gragon_tiger_gate 
        -- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        -- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        or __lua_project_id == __lua_project_red_alert 
        then   
        local Button_level_pack = ccui.Helper:seekWidgetByName(root,"Button_level_pack")
        if tonumber(_ED.user_info.user_grade) < 3 then
            Button_level_pack:setVisible(false)
            return
        end
        if _ED.active_activity[12] == nil then
            Button_level_pack:setVisible(false)
            return
        end
        local showbutton = false
        for i,v in pairs(_ED.active_activity[12].activity_Info) do
            if v.activityInfo_isReward == "0" then
                showbutton = true 
                break
            end
        end
        if showbutton == false then
            state_machine.excute("level_packs_close_action",0,"")
        end
        Button_level_pack:setVisible(showbutton)
    end
end
function Home:onHide()
	for i, v in pairs(self.roots) do
		v:setVisible(false)
	end
end

function Home:onShow()
	for i, v in pairs(self.roots) do
		v:setVisible(true)
	end
end

function Home:updatabaoyi(shipId,currentPage,isshow)
    local root  = self.roots[1]
    if root == nil then
        return
    end


    if shipId > 0 and isshow == nil then
        local shipPic = tonumber(dms.string(dms["ship_mould"], shipId, ship_mould.bust_index)) + 10000
        local headPath = string.format("images/face/big_head/big_head_%d.png", shipPic)
        -- local file,err = io.open(headPath,"r+") 
        local roleIcon = ccs.Skin:create(headPath)
        local baoyibutton = ccui.Helper:seekWidgetByName(root, "Button_baoyi")
        if roleIcon ~= nil then
            if baoyibutton ~= nil then
                if zstring.tonumber(_ED.server_review) == 1 then
                    ccui.Helper:seekWidgetByName(root, "Panel_baoyitubiao"):setVisible(false)
                else
                    ccui.Helper:seekWidgetByName(root, "Panel_baoyitubiao"):setVisible(true)
                end
                if dms.int(dms["ship_mould"], tonumber(shipId), ship_mould.captain_type) == 0 then
                    local fashionEquip, pic = getUserFashion()
                    if fashionEquip ~= nil and pic ~= nil then
                        ccui.Helper:seekWidgetByName(root, "Panel_baoyitubiao"):setVisible(false)
                    end
                end
                fwin:addTouchEventListener(baoyibutton, nil, 
                {
                    terminal_name = "home_baoyi_button_enter", 
                    _shipId = shipId,
                    _currentPage = currentPage,
                    _cell = self,
                    terminal_state = 0, 
                    isPressedActionEnabled = true
                },
                nil,0)  
            end
        else
            if baoyibutton ~= nil then
                ccui.Helper:seekWidgetByName(root, "Panel_baoyitubiao"):setVisible(false)
            end
        end   
    end
    if isshow ~= nil then
        local Panel_baoyi = ccui.Helper:seekWidgetByName(root, "Panel_baoyi_one")
        if isshow == false then
            Panel_baoyi:setVisible(true)
            local ArmatureNode_bao_10 = Panel_baoyi:getChildByName("ArmatureNode_bao_10")
            local function changeActionCallback(armatureBack)
                -- local shipPic = tonumber(dms.string(dms["ship_mould"], shipId, ship_mould.bust_index)) + 10000
                -- local path = string.format("images/face/big_head/big_head_%d.png", shipPic)
                -- currentPage:onUpdateDraw(path)
                currentPage._lock = false         
                state_machine.unlock("home_baoyi_button_enter", 0, "")
                armatureBack:setVisible(false)
                armatureBack._invoke = nil
            end
            ArmatureNode_bao_10:setVisible(true)

            draw.initArmature(ArmatureNode_bao_10, nil, -1, 0, 1)
            ArmatureNode_bao_10:getAnimation():playWithIndex(0, 0, 0)
            csb.animationChangeToAction(ArmatureNode_bao_10, 0, 0, nil)
            ArmatureNode_bao_10._invoke = changeActionCallback
            if shipId > 0 then
                local data =  dms.searchs(dms["ship_sound_effect_param"], ship_sound_effect_param.ship_mould, shipId)
                if data ~= nil and  table.getn(data) > 0 and data[1] ~= nil then
                   local tempMusicIndex =  dms.atoi(data[1], ship_sound_effect_param.sound_effect3)
                    if tempMusicIndex > 0 then
                         playEffect(formatMusicFile("effect", tempMusicIndex ))
                    end
                end   
            end
        else
            Panel_baoyi:setVisible(false)
            currentPage._lock = false
            state_machine.unlock("home_baoyi_button_enter", 0, "")
        end
        -- ccui.Helper:seekWidgetByName(root, "Panel_baoyi_one"):setVisible(isshow)
    end
    -- body
end
function Home:updateFirstRecharge()
	local root = self.roots[1]
	local AcitivityList = ccui.Helper:seekWidgetByName(root, "ListView_1")
	if nil == AcitivityList then
 		return --
	end
	local items = AcitivityList:getItems()
	if __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        or __lua_project_id == __lua_project_red_alert 
        then
        AcitivityList:removeAllItems()
		self:upDataDraw()
	else
        if __lua_project_id == __lua_project_yugioh then 
            local listButtons2 = ccui.Helper:seekWidgetByName(root, "Panel_button_list_2")
            local childs = listButtons2:getChildren()
            for i,v in ipairs(listButtons2) do
                if v.ActivityType == v.enum_type.ACTIVITY_HOME_FIRST_RECHARGE_ICON then
                    listButtons2:removeItem(i) 
                    self:refreshActivityListButtonsSize(2)          
                    return 
                end
            end
        else
            for i,v in ipairs(items) do
                if v.ActivityType == v.enum_type.ACTIVITY_HOME_FIRST_RECHARGE_ICON then
                    AcitivityList:removeItem(i) 
                    self:refreshActivityListViewSize()          
                    return 
                end
            end
        end
	end
end

--刷新活动按钮位置
function Home:refreshActivityListButtonsSize(index)  
    local root = self.roots[1]
    if root == nil then 
        return
    end
    if index == 1 then 
        --顶端三个 活动， 日常任务 ，开服基金
        local buttons1 = ccui.Helper:seekWidgetByName(root, "Panel_button_list")
        local childs = buttons1:getChildren()
        for i,v in pairs(childs) do
            local point_x = buttons1:getContentSize().width - i * v:getContentSize().width - 10
            v:setPositionX(point_x)
        end
    else
        local buttons2 = ccui.Helper:seekWidgetByName(root, "Panel_button_list_2")
        local childs = buttons2:getChildren()
        for i,v in pairs(childs) do
            local point_x = buttons2:getContentSize().width - i * v:getContentSize().width - 10
            v:setPositionX(point_x)
        end
    end
end

function Home:refreshActivityListViewSize()
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
        local root = self.roots[1]
        if root ~= nil then
            local AcitivityList = ccui.Helper:seekWidgetByName(root, "ListView_1")

            local items = AcitivityList:getItems()
            local iCount = #items
            if iCount > 0 then
                -- 移动ListView的位置
                local xx, yy = AcitivityList:getPosition()
                local lsize = AcitivityList:getContentSize()
                AcitivityList:setAnchorPoint(cc.p(1, 0))
                AcitivityList:setPosition(cc.p(xx + lsize.width, yy))
                local margin = AcitivityList:getItemsMargin()
                local twidth = 0
                for i, v in pairs(items) do
                    local w = v:getContentSize().width
                    twidth = twidth + w
                end
                twidth = twidth + (#items - 1) * margin 
                AcitivityList:setContentSize(cc.size(twidth, lsize.height))
                AcitivityList:refreshView()
            end
        end
    end
end
--显示指引
function Home:showFinder()
    do return end -- NinjaAscension: no "Main Instance Challenge" guide on the home screen
    if self.show_finder == nil then
        local Panel_pve = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_pve")
        app.load("client.cells.duplicate.pageview_seat_role_guide_cell")
        --print("============",fwin:find("PageViewSeatRoleGuideClass"))
        local guide = PageViewSeatRoleGuide:createCell()
        guide:setPosition(cc.p(Panel_pve:getContentSize().width * 0.5 - 15, Panel_pve:getContentSize().height*0.5))
        self.show_finder = guide
        Panel_pve:addChild(guide)
    end
end

function Home:upDataDraw()
	local root = self.roots[1]
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local Panel_dh_1 = ccui.Helper:seekWidgetByName(root, "Panel_dh_1")
        if Panel_dh_1 ~= nil then
            if Panel_dh_1.animation ~= nil then
                Panel_dh_1.animation:removeFromParent(true)
            end
            local jsonFile = "sprite/spirte_maoxian.json"
            local atlasFile = "sprite/spirte_maoxian.atlas"
            Panel_dh_1.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            Panel_dh_1:addChild(Panel_dh_1.animation)
        end

        local Panel_dh_2 = ccui.Helper:seekWidgetByName(root, "Panel_dh_2")
        if Panel_dh_2.animation ~= nil then
            Panel_dh_2.animation:removeFromParent(true)
        end
        local jsonFile = "sprite/spirte_zhenzhan.json"
        local atlasFile = "sprite/spirte_zhenzhan.atlas"
        Panel_dh_2.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_dh_2:addChild(Panel_dh_2.animation)

        local Panel_dh_3 = ccui.Helper:seekWidgetByName(root, "Panel_dh_3")
        if Panel_dh_3 then 
            if Panel_dh_3.animation ~= nil then
                Panel_dh_3.animation:removeFromParent(true)
            end
            local jsonFile = "sprite/spirte_maoxian.json"
            local atlasFile = "sprite/spirte_maoxian.atlas"
            Panel_dh_3.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            Panel_dh_3:addChild(Panel_dh_3.animation)
        end

        self:onUpdateDrawEx()

        return
    end

    local AcitivityList = ccui.Helper:seekWidgetByName(root, "ListView_1")
    local AcitivityListTwo = ccui.Helper:seekWidgetByName(root, "ListView_1_2")
    if __lua_project_id == __lua_project_yugioh then 
        self.listButtons_1 = ccui.Helper:seekWidgetByName(root, "Panel_button_list")
        self.listButtons_2 = ccui.Helper:seekWidgetByName(root, "Panel_button_list_2")
    end
	app.load("client.cells.activity.activity_icon_cell")
	--军团
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
        and ___is_open_union == true
         then
		-- if _ED.union.union_info ~= nil and _ED.union.union_info ~= "" and _ED.union.union_info.union_id ~= nil then
			local Buttonlegion = ccui.Helper:seekWidgetByName(root, "Button_legion")
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_all",
			_widget = Buttonlegion,
			_invoke = nil,
			_interval = 0.5,})
		-- end
	end
	--活动
	local activityIcon = ActivityIconCell:createCell()
	activityIcon:init(activityIcon.enum_type.ACTIVITY_EXCITING_ICON)
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        activityIcon._notification = { _terminal_name = "push_notification_center_activity_all",
        _widget = activityIcon,
        _invoke = nil,
        _interval = 0.5,}

        local Buttonlegion = ccui.Helper:seekWidgetByName(root, "Button_legion")
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_all",
        _widget = Buttonlegion,
        _invoke = nil,
        _interval = 0.5,})        
    elseif __lua_project_id == __lua_project_yugioh then
        self.listButtons_1:addChild(activityIcon)  
        self:refreshActivityListButtonsSize(1)  
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_all",
        _widget = activityIcon,
        _invoke = nil,
        _interval = 0.5,})
    else
	   AcitivityList:addChild(activityIcon)	
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_all",
        _widget = activityIcon,
        _invoke = nil,
        _interval = 0.5,})
    end
	--日常任务
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        local Button_dailytasks = ccui.Helper:seekWidgetByName(root, "Button_dailytasks")
        fwin:addTouchEventListener(Button_dailytasks, nil, 
        {
            terminal_name = "activity_every_day_button", 
            terminal_state = 0, 
            isPressedActionEnabled = true
        },
        nil,0)
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_daily_activity",
        _widget = Button_dailytasks,
        _invoke = nil,
        _interval = 0.5,})
    else
    	local everyDayJob = ActivityIconCell:createCell()
    	everyDayJob:init(everyDayJob.enum_type.ACTIVITY_EVERYDAY_ICON)
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            everyDayJob._notification = { _terminal_name = "push_notification_center_activity_main_page_daily_activity",
            _widget = everyDayJob,
            _invoke = nil,
            _interval = 0.5,}
        elseif __lua_project_id == __lua_project_yugioh then 
            self.listButtons_1:addChild(everyDayJob)
            self:refreshActivityListButtonsSize(1)
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_daily_activity",
            _widget = everyDayJob,
            _invoke = nil,
            _interval = 0.5,}) 
        else
    	   AcitivityList:addChild(everyDayJob)
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_daily_activity",
            _widget = everyDayJob,
            _invoke = nil,
            _interval = 0.5,})
        end
	end
	local is2002 = false
	if __lua_project_id == __lua_project_warship_girl_a 
	or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
	or __lua_project_id == __lua_project_koone
    or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert
	then
		if dev_version >= 2002 then
			is2002 = true
		end
	end
		
	local firstRecharge = nil
	if true == is2002 then
		--首充
		if nil ~= _ED.active_activity[4] then
			firstRecharge = ActivityIconCell:createCell()
			firstRecharge:init(firstRecharge.enum_type.ACTIVITY_HOME_FIRST_RECHARGE_ICON)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                then
                -- if tonumber(_ED.recharge_rmb_number) > 0 and tonumber(_ED.active_activity[4].activity_id)==0 then
                --     if firstRecharge.animation ~= nil then
                --         firstRecharge.animation:removeFromParent(true)
                --     end
                --     local jsonFile = "sprite/sprite_wzkp.json"
                --     local atlasFile = "sprite/sprite_wzkp.atlas"
                --     firstRecharge.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                --     firstRecharge.animation:setPosition(cc.p(firstRecharge:getContentSize().width / 2, firstRecharge:getContentSize().height / 2))
                --     firstRecharge:addChild(firstRecharge.animation)
                -- end
            end
            if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
               firstRecharge._notification = { _terminal_name = "push_notification_center_activity_recharge",
                _widget = firstRecharge,
                _invoke = nil,
                _interval = 0.5,}
            elseif __lua_project_id == __lua_project_yugioh then 
                self.listButtons_2:addChild(firstRecharge)
                self:refreshActivityListButtonsSize(2)
                state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_recharge",
                _widget = firstRecharge,
                _invoke = nil,
                _interval = 0.5,})
            else
                AcitivityList:addChild(firstRecharge)
                state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_recharge",
                _widget = firstRecharge,
                _invoke = nil,
                _interval = 0.5,})
            end
		end
	end

	--七日活动
    local sevenDayAty = nil
    if _ED.active_activity[42] ~= nil then
        sevenDayAty = ActivityIconCell:createCell()
        sevenDayAty:init(sevenDayAty.enum_type.ACTIVITY_SEVEN_DAY_ICON)
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            sevenDayAty._notification = { _terminal_name = "push_notification_center_activity_main_page_seven_days_activity",
            _widget = sevenDayAty,
            _invoke = nil,
            _interval = 0.5,}
        elseif __lua_project_id == __lua_project_yugioh then 
            self.listButtons_2:addChild(sevenDayAty)
            self:refreshActivityListButtonsSize(2)

            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_seven_days_activity",
            _widget = sevenDayAty,
            _invoke = nil,
            _interval = 0.5,})
            protocol_command.week_active_init.param_list = "".._ED.active_activity[42].activity_day_count
            NetworkManager:register(protocol_command.week_active_init.code, nil, nil, nil, nil, nil, false, nil)
        else
            AcitivityList:addChild(sevenDayAty)

            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_seven_days_activity",
            _widget = sevenDayAty,
            _invoke = nil,
            _interval = 0.5,})
        end
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
    else
        if _ED.active_activity[78] ~= nil then 
            local topRank = ActivityIconCell:createCell()
            topRank:init(topRank.enum_type.ACTIVITY_TOP_RANK)
            AcitivityListTwo:addChild(topRank)
        end
        if _ED.active_activity[80] ~= nil then 
            local onlineRank = ActivityIconCell:createCell()
            onlineRank:init(onlineRank.enum_type.ACTIVITY_ONLINE_REWARD)
            AcitivityListTwo:addChild(onlineRank)
        end
    end
    
	--开服基金
    local seveFundAty = nil
    local needlevel = 0
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        needlevel = dms.int(dms["fun_open_condition"], 150, fun_open_condition.level)
    else
        needlevel = 0
        if tonumber(_ED.user_info.user_grade) >= needlevel then
        	if _ED.active_activity[27] ~= nil then
                seveFundAty = ActivityIconCell:createCell()
                seveFundAty:init(seveFundAty.enum_type.ACTIVITY_SEVEN_DAY_TWO_ICONTWO)
                if __lua_project_id == __lua_project_gragon_tiger_gate
                    -- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    -- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                    or __lua_project_id == __lua_project_l_naruto 
                    or __lua_project_id == __lua_project_red_alert
                    then
                    seveFundAty._notification = { _terminal_name = "push_notification_center_activity_open_server_activity",
                    _widget = seveFundAty,
                    _invoke = nil,
                    _interval = 0.5,}
                elseif __lua_project_id == __lua_project_yugioh then 
                    self.listButtons_1:addChild(seveFundAty)
                    self:refreshActivityListButtonsSize(1)
                    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_open_server_activity",
                    _widget = seveFundAty,
                    _invoke = nil,
                    _interval = 0.5,})
                else
                    AcitivityList:addChild(seveFundAty)
                    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_open_server_activity",
                    _widget = seveFundAty,
                    _invoke = nil,
                    _interval = 0.5,})
                end
            end
        end
    end
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
    else
    	local isReward = false
        local rewardCentre = nil
    	if _ED._reward_centre == nil or _ED._reward_centre == "" or #_ED._reward_centre == 0 then
    		_ED._reward_centre = nil
    		_ED._reward_centre = {}
    		local function responsePropCompoundCallback(response)
    			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    				isReward = true
    			end
    		end
    		NetworkManager:register(protocol_command.reward_center_init.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
    	else
    		rewardCentre = ActivityIconCell:createCell()
    		rewardCentre:init(rewardCentre.enum_type.ACTIVITY_GAIN_REWARD_ICON)
            if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_red_alert then
                rewardCentre._notification = { _terminal_name = "push_notification_center_activity_the_center_of_the_award",
                _widget = rewardCentre,
                _invoke = nil,
                _interval = 0.5,}
            elseif __lua_project_id == __lua_project_yugioh then 
                self.listButtons_2:addChild(rewardCentre)
                self:refreshActivityListButtonsSize(2)
                state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_of_the_award",
                _widget = rewardCentre,
                _invoke = nil,
                _interval = 0.5,})
            else
                AcitivityList:addChild(rewardCentre)
                state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_of_the_award",
                _widget = rewardCentre,
                _invoke = nil,
                _interval = 0.5,})
            end
    		rewardCentre.item = "reward"
    	end
    	
    	--领奖中心
    	if isReward == true then
    		if #_ED._reward_centre > 0 then
    			rewardCentre = ActivityIconCell:createCell()
    			rewardCentre:init(rewardCentre.enum_type.ACTIVITY_GAIN_REWARD_ICON)
                if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_red_alert
                    then
                    rewardCentre._notification = { _terminal_name = "push_notification_center_activity_the_center_of_the_award",
                    _widget = rewardCentre,
                    _invoke = nil,
                    _interval = 0.5,}
                elseif __lua_project_id == __lua_project_yugioh then 
                    self.listButtons_2:addChild(rewardCentre)
                    self:refreshActivityListButtonsSize(2)
                    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_of_the_award",
                    _widget = rewardCentre,
                    _invoke = nil,
                    _interval = 0.5,})
                else
                    AcitivityList:addChild(rewardCentre)
                    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_of_the_award",
                    _widget = rewardCentre,
                    _invoke = nil,
                    _interval = 0.5,})
                end
    			rewardCentre.item = "reward"
    		end
    	end
    end
	

    local rechargeRecharge = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        or __lua_project_id == __lua_project_red_alert 
        or __lua_project_id == __lua_project_legendary_game 
        then			--龙虎门项目控制
		rechargeRecharge = ActivityIconCell:createCell()
		rechargeRecharge:init(rechargeRecharge.enum_type.ACTIVITY_HOME_RECHARGE_BUTTON)
        if __lua_project_id == __lua_project_gragon_tiger_gate 
            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            or __lua_project_id == __lua_project_l_naruto 
            or __lua_project_id == __lua_project_red_alert 
            then
        else
            AcitivityList:addChild(rechargeRecharge)
        end
        self:refreshActivityListViewSize()
	end
	
	-- local __layout = ccui.Helper:seekWidgetByName(root, "Panel_128")
	
    local mysteryShop = nil
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
    elseif __lua_project_id == __lua_project_warship_girl_b 
        or __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
    	or __lua_project_id == __lua_project_warship_girl_a 
    	or __lua_project_id == __lua_project_koone
        or __lua_project_id == __lua_project_gragon_tiger_gate 
        or __lua_project_id == __lua_project_red_alert
        then
		--神秘船坞
		mysteryShop = ActivityIconCell:createCell()
        local openLevel = dms.int(dms["fun_open_condition"], 77, fun_open_condition.level)
        if openLevel > 0 then
            --商店扩展
            mysteryShop:init(mysteryShop.enum_type.ACTIVITY_HOME_SHOP_EX)
        else
            mysteryShop:init(mysteryShop.enum_type.ACTIVITY_HOME_MYSTERY_SHOP)
        end
		
        if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_red_alert
            then
            mysteryShop._notification = { _terminal_name = "push_notification_center_activity_click_hero_shop",
            _widget = mysteryShop,
            _invoke = nil,
            _interval = 0.5,}
        elseif __lua_project_id == __lua_project_yugioh then 
            self.listButtons_2:addChild(mysteryShop)
            self:refreshActivityListButtonsSize(2)
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_click_hero_shop",
            _widget = mysteryShop,
            _invoke = nil,
            _interval = 0.5,})
        else
            AcitivityListTwo:addChild(mysteryShop)
			-- __layout:addChild(mysteryShop)
			-- mysteryShop:setPosition(cc.p(170, 20))
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_click_hero_shop",
            _widget = mysteryShop,
            _invoke = nil,
            _interval = 0.5,})
        end
    end

    if __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_pokemon
		then
        --限时优惠
        local limit = ActivityIconCell:createCell()
        limit:init(limit.enum_type.ACTIVITY_LIMIT_TIME_COUPONS)
        AcitivityListTwo:addChild(limit)
    elseif __lua_project_id == __lua_project_gragon_tiger_gate
        then  
        local limit = ActivityIconCell:createCell()
        limit:init(limit.enum_type.ACTIVITY_LIMIT_TIME_COUPONS)
        local panel_limit = ccui.Helper:seekWidgetByName(root, "Panel_limit")
        if panel_limit ~= nil then 
            panel_limit:removeAllChildren(true)
            panel_limit:addChild(limit)
        end
    end

    --等级礼包
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
    else
        local levelGift = dms.int(dms["fun_open_condition"], 78, fun_open_condition.level)
        if levelGift > 0 and zstring.tonumber(_ED.user_info.user_grade) > levelGift then 
           local levelGiftCell = ActivityIconCell:createCell()
           levelGiftCell:init(levelGiftCell.enum_type.ACTIVITY_LEVEL_GIFT_HOME)
            if __lua_project_id == __lua_project_gragon_tiger_gate
                then 
                AcitivityList:addChild(levelGiftCell)
            else
                AcitivityListTwo:addChild(levelGiftCell)  
            end
        end
    end
    
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_pokemon
        then
        local Landingreword = nil
        Landingreword = ActivityIconCell:createCell()
        if _ED.active_activity[24] ~= nil then
            Landingreword:init(Landingreword.enum_type.ACTIVITY_LANDING_REWORD)
            -- AcitivityList:addChild(Landingreword)  
            Landingreword._notification = { _terminal_name = "push_notification_activity_login_reward",
                _widget = Landingreword,
                _invoke = nil,
                _interval = 0.5,}
        end

        --金币砸金蛋
        local smokedeggs = nil
        if _ED.active_activity[87] ~= nil then
            smokedeggs1 = ActivityIconCell:createCell()
            smokedeggs1:init(smokedeggs1.enum_type.ACTIVITY_SM_SMOKEDEGGS_1)
            -- AcitivityList:addChild(smokedeggs1)  
        end
        --钻石砸金蛋
        if _ED.active_activity[88] ~= nil then
            smokedeggs2 = ActivityIconCell:createCell()
            smokedeggs2:init(smokedeggs2.enum_type.ACTIVITY_SM_SMOKEDEGGS_2)
            -- AcitivityList:addChild(smokedeggs2)  
        end

        --全服排名活动
        local fullServiceRankings = nil
        if _ED.active_activity[86] ~= nil then
            if funOpenDrawTip(156, false) == false then
                fullServiceRankings = ActivityIconCell:createCell()
                fullServiceRankings:init(fullServiceRankings.enum_type.ACTIVITY_SM_FULL_SERVICE_RANKINGS)
                -- AcitivityList:addChild(fullServiceRankings)  
            end
        end

        --月卡福利
        local monthCardWelfare = nil
        monthCardWelfare = ActivityIconCell:createCell()
        monthCardWelfare:init(monthCardWelfare.enum_type.ACTIVITY_SM_ON_CARD)
        -- AcitivityList:addChild(fullServiceRankings)  

        --vip礼包
        -- local HomeVipPacks = nil
        -- HomeVipPacks = ActivityIconCell:createCell()
        -- HomeVipPacks:init(HomeVipPacks.enum_type.ACTIVITY_SM_VIP_PACKS)

        local items = {}
        local itemsTwo = {}
        if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_onepiece then
        else
            table.insert(items, firstRecharge)    -- 首充
        end
        if firstRecharge == nil then
            local m_isVisible = false
            for i,v in pairs(_ED.month_card) do
                if tonumber(v.surplus_month_card_time) == 0 then
                    m_isVisible = true
                end
            end
            if m_isVisible == true then
                table.insert(items, monthCardWelfare)    -- 月卡福利
            else
                -- table.insert(items, HomeVipPacks)           --vip礼包
            end
        end

        -- 大耳有福，天使送礼
        local welcomeMoneyMan = nil
        if _ED.active_activity[14] ~= nil then
            if funOpenDrawTip(163, false) == false then
                welcomeMoneyMan = ActivityIconCell:createCell()
                welcomeMoneyMan:init(welcomeMoneyMan.enum_type.ACTIVITY_SM_DAERYOUFU)
                -- AcitivityList:addChild(welcomeMoneyMan)  
            end
        end

        -- 限时宝箱
        local limitedTimeBox = nil
        if _ED.active_activity[89] ~= nil then
            if funOpenDrawTip(164, false) == false then
                limitedTimeBox = ActivityIconCell:createCell()
                limitedTimeBox:init(limitedTimeBox.enum_type.ACTIVITY_SM_LIMITED_TIME_BOX)
                -- AcitivityList:addChild(limitedTimeBox)  
                limitedTimeBox._notification = { _terminal_name = "push_notification_center_activity_the_center_sm_limited_time_box",
                    _widget = limitedTimeBox,
                    _invoke = nil,
                    _interval = 0.5,}
            end
        end

        -- 新增限时神兽
        local limitedSprite = nil
        if _ED.active_activity[150] ~= nil then
            if funOpenDrawTip(164, false) == false then
                limitedSprite = ActivityIconCell:createCell()
                limitedSprite:init(limitedSprite.enum_type.ACTIVITY_SM_LIMITED_TIME_SPRITE)
                -- AcitivityList:addChild(limitedTimeBox)  
                limitedSprite._notification = { _terminal_name = "push_notification_center_activity_the_center_sm_limited_time_box",
                    _widget = limitedSprite,
                    _invoke = nil,
                    _interval = 0.5,}
            end
        end
        table.insert(items, rechargeRecharge)    -- 充值
        table.insert(items, activityIcon)    -- 活动
        table.insert(items, Landingreword)    -- 登陆奖励
        table.insert(items, seveFundAty)    -- 开服基金
        table.insert(items, limitedTimeBox)    -- 限时宝箱
        table.insert(items, limitedSprite)    -- 限时宝箱
        table.insert(itemsTwo, sevenDayAty)    -- 七日活动
        table.insert(itemsTwo, smokedeggs1)    -- 钻石砸金蛋
        table.insert(itemsTwo, smokedeggs2)    -- 金币砸金蛋
        table.insert(itemsTwo, fullServiceRankings)    -- 全服排名活动
        table.insert(itemsTwo, welcomeMoneyMan)    -- 大耳有福活动



        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        then
            if AcitivityList._x == nil then
                AcitivityList._x = AcitivityList:getPositionX()
            end
            AcitivityList:setPositionX(AcitivityList._x)
            AcitivityList:setScaleX(-1)
            AcitivityList:setPositionX(AcitivityList._x+AcitivityList:getContentSize().width-100)
        end
        for i, v in pairs(items) do
            if v ~= nil then
                AcitivityList:addChild(v)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                then
                    v:setScaleX(-1)
                end
                -- AcitivityList:getInnerContainer():setPositionX(v:getContentSize().width*index)
                if v._notification ~= nil then
                    state_machine.excute("push_notification_center_manager", 0, v._notification)
                end
            end
        end
        local AcitivityListTwo = ccui.Helper:seekWidgetByName(root, "ListView_2")
        AcitivityListTwo:removeAllItems()
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        then
            if AcitivityListTwo._x == nil then
                AcitivityListTwo._x = AcitivityListTwo:getPositionX()
            end
            AcitivityListTwo:setPositionX(AcitivityListTwo._x)
            AcitivityListTwo:setScaleX(-1)
            AcitivityListTwo:setPositionX(AcitivityListTwo._x+AcitivityListTwo:getContentSize().width-100)
        end
        for i, v in pairs(itemsTwo) do
            if v ~= nil then
                AcitivityListTwo:addChild(v)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                then
                    v:setScaleX(-1)
                end
                if v._notification ~= nil then
                    state_machine.excute("push_notification_center_manager", 0, v._notification)
                end
            end
        end
    elseif __lua_project_id == __lua_project_gragon_tiger_gate
    	or __lua_project_id == __lua_project_red_alert
        then
        local items = {}
        
        table.insert(items, seveFundAty)    -- 开服基金
        table.insert(items, sevenDayAty)    -- 七日活动
        table.insert(items, mysteryShop)    -- 神秘商店       
        table.insert(items, everyDayJob)    -- 日常任务
        table.insert(items, firstRecharge)    -- 首充
        table.insert(items, rechargeRecharge)    -- 充值
        table.insert(items, activityIcon)    -- 活动
        table.insert(items, rewardCentre)    -- 领奖中心
        for i, v in pairs(items) do
            if v ~= nil then
                AcitivityList:addChild(v)
                if v._notification ~= nil then
                    state_machine.excute("push_notification_center_manager", 0, v._notification)
                end
            end
        end
    end
end

function Home:onUpdateDrawEx( ... )

    ----WEB支付海报-----
    -- state_machine.excute("web_pay_push_window_open", 0, nil)
    ----WEB支付海报-----

    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.ActivityVipPush)
    if fun_is_open == true then
        state_machine.excute("activity_r_vip_push_window_open", 0, {type=2})
    end

    -- 初始化每行图标数组
    -- La ciudad monta los iconos MAS DE UNA VEZ por entrada; el contador sale
    -- en la traza para poder separar las pasadas y ver que el ajuste de las
    -- filas ni se acumula ni se anula en la segunda.
    Home._pasadaIconos = (Home._pasadaIconos or 0) + 1
    self.itemsFirstLineArray = {}
    self.itemsScecondLineArray = {}
    self.itemsThirdLineArray = {}

    local root = self.roots[1]
    local Panel_19 = ccui.Helper:seekWidgetByName(root, "Panel_19")
    if Panel_19 ~= nil then
        if _ED.active_activity[99] ~= nil and _ED.active_activity[99] ~= "" 
            or (_ED.active_activity[131] ~= nil and _ED.active_activity[131] ~= "")
            or (_ED.active_activity[132] ~= nil and _ED.active_activity[132] ~= "")
            or (_ED.active_activity[133] ~= nil and _ED.active_activity[133] ~= "")
            or (_ED.active_activity[134] ~= nil and _ED.active_activity[134] ~= "")
            then
            Panel_19:setVisible(true)
        else
            Panel_19:setVisible(false)
        end
    end

    local AcitivityList = ccui.Helper:seekWidgetByName(root, "ListView_1")
    AcitivityList:removeAllItems()
    if __lua_project_id == __lua_project_l_naruto then
        if isIphoneX() then
            -- iphoneX以后的活动icon适配
            AcitivityList:setPositionX(AcitivityList:getPositionX()+80)
        end
	else
		if AcitivityList._x == nil then
			AcitivityList._x = AcitivityList:getPositionX()
		end
		-- El ancho de la CAJA se guarda aparte: `Home:fitActivityBox`
		-- la ensancha, y sin esto la segunda pasada colocaria la fila
		-- con el ancho ya ensanchado y se iria a la derecha.
		if AcitivityList._anchoBase == nil then
			AcitivityList._anchoBase = AcitivityList:getContentSize().width
		end
		AcitivityList:setPositionX(AcitivityList._x)
		AcitivityList:setScaleX(-1)
		AcitivityList:setPositionX(AcitivityList._x+AcitivityList._anchoBase-100)
	end
    local AcitivityListTwo = ccui.Helper:seekWidgetByName(root, "ListView_2")
    AcitivityListTwo:removeAllItems()

    -- 第三行的图标刷新的时候移除
    local AcitivityListTwo2 = AcitivityListTwo:getParent():getChildByName("AcitivityListTwo2")
    if AcitivityListTwo2 then
        AcitivityListTwo2:removeAllItems()
        -- Fuera entera, no solo vaciada (port de Fury 86189f9e/412d1c9c): vacia
        -- seguia en la ciudad con su caja recogiendo toques si en esta pasada ya
        -- no hay tercera fila. Si la hay, se vuelve a clonar mas abajo.
        AcitivityListTwo2:removeFromParent()
    end

    if __lua_project_id == __lua_project_l_naruto then
        if isIphoneX() then
            -- iphoneX以后的活动icon适配
		    AcitivityListTwo:setPositionX(AcitivityListTwo:getPositionX()+80)
        end
	else
		if AcitivityListTwo._x == nil then
			AcitivityListTwo._x = AcitivityListTwo:getPositionX()
		end
		-- El ancho de la CAJA se guarda aparte: `Home:fitActivityBox`
		-- la ensancha, y sin esto la segunda pasada colocaria la fila
		-- con el ancho ya ensanchado y se iria a la derecha.
		if AcitivityListTwo._anchoBase == nil then
			AcitivityListTwo._anchoBase = AcitivityListTwo:getContentSize().width
		end
		AcitivityListTwo:setPositionX(AcitivityListTwo._x)
		AcitivityListTwo:setScaleX(-1)
		AcitivityListTwo:setPositionX(AcitivityListTwo._x+AcitivityListTwo._anchoBase-100)
	end
    --活动
    local activityIcon = ActivityIconCell:createCell()
    activityIcon:init(activityIcon.enum_type.ACTIVITY_EXCITING_ICON)
    -- activityIcon._notification = { _terminal_name = "push_notification_center_activity_all",
    -- _widget = activityIcon,
    -- _invoke = nil,
    -- _interval = 0.5,}

    local Buttonlegion = ccui.Helper:seekWidgetByName(root, "Button_legion")
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_all",
        _widget = Buttonlegion,
        _invoke = nil,
        _interval = 0.5,})

    --日常任务
    local Button_dailytasks = ccui.Helper:seekWidgetByName(root, "Button_dailytasks")
    fwin:addTouchEventListener(Button_dailytasks, nil, 
    {
        terminal_name = "activity_every_day_button", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil,0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_daily_activity",
        _widget = Button_dailytasks,
        _invoke = nil,
        _interval = 0.5,})

    local firstRecharge = nil
    --首充
    if nil ~= _ED.active_activity[4] then
        if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_onepiece then
        else
            firstRecharge = ActivityIconCell:createCell()
            firstRecharge:init(firstRecharge.enum_type.ACTIVITY_HOME_FIRST_RECHARGE_ICON)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                if firstRecharge:getChildByTag(1025) == nil then
                    app.load("client.l_digital.cells.activity.wonderful.sm_first_charge_qibao_cell")
                    local qipao = SmFirstChargeQibaoCell:createCell()
    				qipao:init()
                    qipao:setTag(1025)
                    firstRecharge:addChild(qipao)
                end
            end
        end
       -- firstRecharge._notification = { _terminal_name = "push_notification_center_activity_recharge",
       --  _widget = firstRecharge,
       --  _invoke = nil,
       --  _interval = 0.5,}
    end

    --七日活动
    local sevenDayAty = nil
    if _ED.active_activity[42] ~= nil then
        sevenDayAty = ActivityIconCell:createCell()
        sevenDayAty._notification = { _terminal_name = "push_notification_center_activity_main_page_seven_days_activity",
            _widget = sevenDayAty,
            _invoke = nil,
            _interval = 0.5,}
        sevenDayAty:init(sevenDayAty.enum_type.ACTIVITY_SEVEN_DAY_ICON)
    end

    -- 七天乐
    local severHappyAty = nil
    if _ED.active_activity[137] ~= nil then
        severHappyAty = ActivityIconCell:createCell()
        severHappyAty:init(severHappyAty.enum_type.ACTIVITY_SEVEN_HAPPY_ICON)

        severHappyAty._notification = { _terminal_name = "push_notification_7happy_home_push",
        _widget = severHappyAty,
        _invoke = nil,
        _interval = 0.5,}
    end

    -- 成长之路
    local pathGrowthAty = nil
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_l_digital then
        if _ED.active_activity[142] ~= nil then
            pathGrowthAty = ActivityIconCell:createCell()
            pathGrowthAty:init(pathGrowthAty.enum_type.ACTIVITY_PATH_GROWTH_1)

            pathGrowthAty._notification = { _terminal_name = "push_notification_path_growth_home_push",
            _widget = pathGrowthAty,
            _invoke = nil,
            _interval = 0.5,}
        end
    end
    
    -- 豪华首冲
    local richFirstRechargeAty = nil
    if _ED.active_activity[144] ~= nil then
        richFirstRechargeAty = ActivityIconCell:createCell()
        richFirstRechargeAty:init(richFirstRechargeAty.enum_type.ACTIVITY_RICH_FIRST_RECHARGE)

        richFirstRechargeAty._notification = { _terminal_name = "push_notification_rich_recharge_push",
        _widget = richFirstRechargeAty,
        _invoke = nil,
        _interval = 0.5,}
    end
    
    -- 微信活动
    local wechatRewardAty = nil
    if _ED.active_activity[146] ~= nil then
        local level = zstring.split(_ED.active_activity[146].need_recharge_count, ",")[1]
        if tonumber(level) <= tonumber(_ED.user_info.user_grade) then
            wechatRewardAty = ActivityIconCell:createCell()
            wechatRewardAty:init(wechatRewardAty.enum_type.ACTIVITY_WECHAT_REWARD)
        end
        -- wechatRewardAty._notification = { _terminal_name = "push_notification_rich_recharge_push",
        -- _widget = wechatRewardAty,
        -- _invoke = nil,
        -- _interval = 0.5,}
    end

     -- 节日红包活动  
    local redPacketAty = nil
    if _ED.active_activity[155] ~= nil then
        redPacketAty = ActivityIconCell:createCell()
        redPacketAty:init(redPacketAty.enum_type.ACTIVITY_RED_PACKET)
    end

     -- 大师训练营  
    local trainingcampAty = nil
    if _ED.active_activity[157] ~= nil then
        trainingcampAty = ActivityIconCell:createCell()
        trainingcampAty:init(trainingcampAty.enum_type.ACTIVITY_TRAINING_CAMP)
    end

      -- 宝可梦救助站  
    local rescuestationAty = nil
    if _ED.active_activity[159] ~= nil then
        rescuestationAty = ActivityIconCell:createCell()
        rescuestationAty:init(rescuestationAty.enum_type.ACTIVITY_RESCUE_STATION)
    end

    -- 皮卡丘大冒险
    local pikachuAdventureAty = nil
    if _ED.active_activity[147] ~= nil then
        pikachuAdventureAty = ActivityIconCell:createCell()
        pikachuAdventureAty:init(pikachuAdventureAty.enum_type.ACTIVITY_PIKACHU_ADVENTURE)

        pikachuAdventureAty._notification = { _terminal_name = "push_notification_pikachu_adventure_push",
        _widget = pikachuAdventureAty,
        _invoke = nil,
        _interval = 0.5,}
    end

    -- 宝可梦秘宝
    -- debug.print_r(_ED.active_activity[148])
    local pokemonTreasureAty = nil
    if _ED.active_activity[148] ~= nil then
        pokemonTreasureAty = ActivityIconCell:createCell()
        pokemonTreasureAty:init(pokemonTreasureAty.enum_type.ACTIVITY_POKEMON_TREASURE)

        pokemonTreasureAty._notification = { _terminal_name = "push_notification_pokemon_treasure_push",
        _widget = pokemonTreasureAty,
        _invoke = nil,
        _interval = 0.5,}
    end

    -- 世界boss
    local worldBossAty = nil
    if _ED.world_boss_open_info and _ED.world_boss_open_info.status ~= 0 and false == funOpenDrawTip(190, false) then
        worldBossAty = ActivityIconCell:createCell()
        worldBossAty:init(worldBossAty.enum_type.ACTIVITY_WORLD_BOSS)
        worldBossAty.activity_type = 20005
        worldBossAty._notification = { _terminal_name = "push_notification_world_boss_push",
        _widget = worldBossAty,
        _invoke = nil,
        _interval = 0.5,}
    end

    -- 武器扭蛋
    local pokemonEggMachineAty = nil
    if _ED.active_activity[154] ~= nil then
        pokemonEggMachineAty = ActivityIconCell:createCell()
        pokemonEggMachineAty:init(pokemonEggMachineAty.enum_type.ACTIVITY_EGG_MACHINE)

        pokemonEggMachineAty._notification = { _terminal_name = "push_notification_egg_machine_push",
        _widget = pokemonEggMachineAty,
        _invoke = nil,
        _interval = 0.5,}
    end

    -- 跨服排行  _ED.activity_recharge_state[1]
    local pokemonRechargeAty = nil
  --  if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto then
        if _ED.activity_recharge_state and _ED.activity_recharge_state == 1 then
            pokemonRechargeAty = ActivityIconCell:createCell()
            pokemonRechargeAty:init(pokemonRechargeAty.enum_type.ACTIVITY_POKEMON_RECHARGE)
            pokemonRechargeAty.activity_type = 20004
            -- SIN punto rojo, y es a proposito. Aqui habia un
            -- copia-pega: este icono colgaba el terminal
            -- `push_notification_pokemon_treasure_push`, que mira
            -- `_ED.active_activity[148]` (el tesoro del dragon, OTRO
            -- evento), asi que el Recharge Ranking se encendia con
            -- las tiradas gratis del 148 y no con nada suyo. El
            -- 20004 no pasa por el bloque 85: su unico dato en la
            -- ciudad es la puerta del S2C 13039
            -- (`_ED.activity_recharge_state`, un 0 o un 1), y una
            -- clasificacion no tiene nada que cobrar, asi que no hay
            -- con que decidir un punto rojo. Mejor sin el que
            -- mintiendo.
        end
   -- end

    -- 限时排行奖励
    local limitRankAty = nil
    if _ED.active_activity[143] ~= nil then
        limitRankAty = ActivityIconCell:createCell()
        limitRankAty:init(limitRankAty.enum_type.ACTIVITY_LIMIT_RANK_REWORD)

        limitRankAty._notification = { _terminal_name = "push_notification_limit_rank_push",
        _widget = limitRankAty,
        _invoke = nil,
        _interval = 0.5,}
    end

    --开服基金
    local seveFundAty = nil
    -- if __lua_project_id == __lua_project_l_naruto then
        local needlevel = dms.int(dms["fun_open_condition"], 150, fun_open_condition.level)

        if tonumber(_ED.user_info.user_grade) >= needlevel then
            if _ED.active_activity[27] ~= nil then
                local is_show = false
                for j, w in pairs(_ED.active_activity[27].activity_Info) do
                    if tonumber(w.activityInfo_isReward) == 0 then
                        is_show = true
                        break
                    end
                end
                if is_show == true then
                    seveFundAty = ActivityIconCell:createCell()
                    seveFundAty:init(seveFundAty.enum_type.ACTIVITY_SEVEN_DAY_TWO_ICONTWO)
                    -- seveFundAty._notification = { _terminal_name = "push_notification_center_activity_open_server_activity",
                    --     _widget = seveFundAty,
                    --     _invoke = nil,
                    --     _interval = 0.5,}
                end
            end
        end
    -- end

    -- self:refreshActivityListViewSize()
    local Landingreword = nil
    -- if __lua_project_id == __lua_project_l_naruto then
        if _ED.active_activity[24] ~= nil then
            local is_show = false
            for k, v in pairs(_ED.active_activity[24].activity_Info) do
                if tonumber(v.activityInfo_isReward) == 0 then
                    is_show = true
                end
            end
            if is_show == true then
                Landingreword = ActivityIconCell:createCell()
                if false then
                    Landingreword:init(Landingreword.enum_type.ACTIVITY_HOME_LANDING_REWORD)
                else
                    Landingreword:init(Landingreword.enum_type.ACTIVITY_LANDING_REWORD)
                end
                -- Landingreword._notification = { _terminal_name = "push_notification_activity_login_reward",
                --     _widget = Landingreword,
                --     _invoke = nil,
                --     _interval = 0.5,}
            end
        end
    -- end

    --金币砸金蛋
    local smokedeggs1 = nil
    if _ED.active_activity[87] ~= nil then
        smokedeggs1 = ActivityIconCell:createCell()
        smokedeggs1:init(smokedeggs1.enum_type.ACTIVITY_SM_SMOKEDEGGS_1)
    end
    --钻石砸金蛋
    local smokedeggs2 = nil
    if _ED.active_activity[88] ~= nil then
        smokedeggs2 = ActivityIconCell:createCell()
        smokedeggs2:init(smokedeggs2.enum_type.ACTIVITY_SM_SMOKEDEGGS_2)
    end
    --全服排名活动
    local fullServiceRankings = nil
    if _ED.active_activity[86] ~= nil then
        if funOpenDrawTip(156, false) == false then
            fullServiceRankings = ActivityIconCell:createCell()
            fullServiceRankings:init(fullServiceRankings.enum_type.ACTIVITY_SM_FULL_SERVICE_RANKINGS)
        end
    end

    -- 大耳有福
    local welcomeMoneyMan = nil
    if _ED.active_activity[14] ~= nil then
        if funOpenDrawTip(163, false) == false then
            state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 14)
            welcomeMoneyMan = ActivityIconCell:createCell()
            welcomeMoneyMan:init(welcomeMoneyMan.enum_type.ACTIVITY_SM_DAERYOUFU)
        end
    end
    -- 限时宝箱，限时神兽
    local limitedTimeBox = nil
    if _ED.active_activity[89] ~= nil then
        if funOpenDrawTip(164, false) == false then
            limitedTimeBox = ActivityIconCell:createCell()
            limitedTimeBox:init(limitedTimeBox.enum_type.ACTIVITY_SM_LIMITED_TIME_BOX)
            -- limitedTimeBox._notification = { _terminal_name = "push_notification_center_activity_the_center_sm_limited_time_box",
            --     _widget = limitedTimeBox,
            --     _invoke = nil,
            --     _interval = 0.5,}
        end
    end
    -- 新增限时神兽
    local limitedSprite = nil
    if _ED.active_activity[158] ~= nil then
        if funOpenDrawTip(164, false) == false then
            limitedSprite = ActivityIconCell:createCell()
            limitedSprite:init(limitedSprite.enum_type.ACTIVITY_SM_LIMITED_TIME_SPRITE)
        end
    end
    -- 充值返钻
    local rechargeReturnGold = nil
    -- print("=========充值返钻==========")
    -- debug.print_r(_ED.active_activity[107])
    if _ED.active_activity[107] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 107)
        rechargeReturnGold = ActivityIconCell:createCell()
        rechargeReturnGold:init(rechargeReturnGold.enum_type.ACTIVITY_SM_RECHARGE_RETURN_REWARD)
    end

    -- 充值返钻1
    -- print("=======充值返钻====1111====")
    -- debug.print_r(_ED.active_activity[145])
    local rechargeReturnGoldNew = nil
    if _ED.active_activity[145] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 145)
        rechargeReturnGoldNew = ActivityIconCell:createCell()
        rechargeReturnGoldNew:init(rechargeReturnGoldNew.enum_type.ACTIVITY_SM_RECHARGE_RETURN_REWARD_NEW)
    end

    -- 充值返利
    local rechargeReturnInterest = nil
    if _ED.active_activity[178] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 178)
        rechargeReturnInterest = ActivityIconCell:createCell()
        rechargeReturnInterest:init(rechargeReturnInterest.enum_type.ACTIVITY_SM_RECHARGE_RETURN_INTEREST)
    end

    -- 神兽来袭
    local otherRecruitActivity = nil
    if _ED.active_activity[114] ~= nil then
        local activity_info = _ED.active_activity[114]
        local info = zstring.split(zstring.split(activity_info.need_recharge_count, "@")[4], ",")
        if zstring.tonumber(_ED.vip_grade) >= tonumber(info[2]) then
            state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 114)
            otherRecruitActivity = ActivityIconCell:createCell()
            otherRecruitActivity:init(otherRecruitActivity.enum_type.ACTIVITY_SM_OTHER_RECRUIT_ACTIVITY)
        end
    end

    -- 愚人节：节日道具兑换活动
    local festivalExchange = nil
    if _ED.active_activity[121] ~= nil then
        festivalExchange = ActivityIconCell:createCell()
        festivalExchange:init(festivalExchange.enum_type.ACTIVITY_FESTIVAL_EXCHNAGE_1)
    end

    -- 节日兑换活动(复制活动121)
    local newFestivalExchange = nil
    if _ED.active_activity[177] ~= nil then
        newFestivalExchange = ActivityIconCell:createCell()
        newFestivalExchange:init(newFestivalExchange.enum_type.ACTIVITY_NEW_FESTIVAL_EXCHNAGE)
    end

    local activityActive = nil
    if funOpenDrawTip(180, false) == false then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 10000)
        activityActive = ActivityIconCell:createCell()
        activityActive:init(activityActive.enum_type.ACTIVITY_SM_ACTIVE)
    end

    -- YouTube推广
    local videoFansExtension = nil
    if GetProjectFunctionIsOpen(ProjectFunctionEnum.YouTubeFansExtension) == true then 
        app.load("client.activity.fans_extension.FansExtensionCell")
        videoFansExtension = FansExtensionCell:createCell()
        videoFansExtension:init()
        videoFansExtension.activity_type = 20002
    end

    -- 观看广告
    local activityWatchAds = nil
    if getWatchAdFuncOpenState() then
        app.load("client.activity.watch_ads.WatchAdsCell")
        activityWatchAds = WatchAdsCell:createCell()
        activityWatchAds:init()
    end

    -- 观看广告
    if activityWatchAds ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityWatchAds, lineType = self.enumLineType.SECONDLINE})
    end

    -- CODIGOS DE REGALO (punto 7.26): icono fijo, fuera del tutorial. Sin fila
    -- en activity_sorting_mould (20008): va el ultimo de la ciudad. Abre la
    -- ventana de codigos y, la primera vez de cada dia, la abre sola.
    if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto) and (tonumber(_ED.user_info and _ED.user_info.user_grade) or 0) >= 5 then -- Victor 26-sep: desde el nivel 5
        app.load("client.l_digital.activity.gift_codes.GiftCodesCell")
        local giftCodes = GiftCodesCell:createCell()
        giftCodes:init()
        giftCodes.activity_type = 20008
        self:addActivityIconIntoGroup({iconCell = giftCodes, lineType = self.enumLineType.SECONDLINE})
    end

    -- Fury: LA TIENDA DE SUSCRIPCIONES (29-sep-2026, docs/systems/suscripciones.md),
    -- junto a los Codigos y con el mismo nivel. Sin fila en activity_sorting_mould
    -- (20009): va al final. Abre FurySubscriptionShop.
    if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto) and (tonumber(_ED.user_info and _ED.user_info.user_grade) or 0) >= 5 then
        app.load("client.l_digital.activity.subscription.FurySubscriptionShop")
        local furySubscriptions = FurySubscriptionCell:createCell()
        furySubscriptions:init()
        furySubscriptions.activity_type = 20009
        self:addActivityIconIntoGroup({iconCell = furySubscriptions, lineType = self.enumLineType.SECONDLINE})
    end

    -- Fury: INVITA A UN AMIGO (sistema 18, 30-sep-2026, docs/systems/invita_amigo.md). Desde el
    -- nivel 5 como Codigos; sin fila en activity_sorting_mould (29190): va al final.
    if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto) and (tonumber(_ED.user_info and _ED.user_info.user_grade) or 0) >= 5 then
        app.load("client.l_digital.activity.invite_friend.FuryInviteFriend")
        local furyInvite = FuryInviteFriendCell:createCell()
        furyInvite:init()
        furyInvite.activity_type = 29190
        self:addActivityIconIntoGroup({iconCell = furyInvite, lineType = self.enumLineType.SECONDLINE})
    end

    -- Fury: EL BANNER ESPECIAL SR (sistema C, 29-sep-2026, docs/systems/banner_sr.md).
    -- Evento 29040 del bloque 85: solo sale si el servidor lo anuncia. Sin fila en
    -- activity_sorting_mould: va al final. Abre FuryBannerSR.
    if _ED.active_activity[29040] ~= nil then
        app.load("client.l_digital.activity.banner_sr.FuryBannerSR")
        local furyBannerSR = FuryBannerSRCell:createCell()
        furyBannerSR:init()
        furyBannerSR.activity_type = 29040
        self:addActivityIconIntoGroup({iconCell = furyBannerSR, lineType = self.enumLineType.SECONDLINE})
    end

    -- Fury: EL EVENTO «MONEDAS PREMIUM» (30-sep-2026, docs/systems/evento_monedas_premium.md).
    -- Tipo propio 29150 del bloque 85 (siempre abierto); sin fila en activity_sorting_mould:
    -- va al final. Abre la ventana del 179 (ActivitySuperPack) con su tipo.
    if _ED.active_activity[29150] ~= nil then
        app.load("client.l_digital.activity.premium_coins.FuryPremiumCoins")
        local furyPremiumCoins = FuryPremiumCoinsCell:createCell()
        furyPremiumCoins:init()
        furyPremiumCoins.activity_type = 29150
        self:addActivityIconIntoGroup({iconCell = furyPremiumCoins, lineType = self.enumLineType.SECONDLINE})
    end

    -- Fury: EL JEFE INTERSERVIDOR «La invasion de Itachi» en Naruto (sistema D, 29-sep-2026,
    -- docs/systems/jefe_interservidor.md). Mismo desbloqueo que el Juego de Cell
    -- (function_param 190); sin fila en activity_sorting_mould (20050): va al final.
    if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto) and false == funOpenDrawTip(190, false) then
        app.load("client.l_digital.campaign.worldboss.FuryCrossBossWindow")
        local furyCrossBoss = FuryCrossBossCell:createCell()
        furyCrossBoss:init()
        furyCrossBoss.activity_type = 20050
        self:addActivityIconIntoGroup({iconCell = furyCrossBoss, lineType = self.enumLineType.SECONDLINE})
    end

    -- Fury: LAS CRONICAS (sistema G, 29-sep-2026, docs/systems/cronicas.md). Desde el nivel 10;
    -- sin fila en activity_sorting_mould (29080): va al final. Abre FuryChronicle.
    -- 30-sep-2026: Victor la quiere en «Crecimiento» (SmCultivateWindow), no en la ciudad.
    if false then
        app.load("client.l_digital.activity.chronicle.FuryChronicle")
        local furyChronicle = FuryChronicleCell:createCell()
        furyChronicle:init()
        furyChronicle.activity_type = 29080
        self:addActivityIconIntoGroup({iconCell = furyChronicle, lineType = self.enumLineType.SECONDLINE})
    end

    -- Fury: LAS OFERTAS RELAMPAGO (sistema 16, 30-sep-2026, docs/systems/ofertas_relampago.md).
    -- Desde el nivel 5, como la tienda de suscripciones; sin fila en activity_sorting_mould
    -- (29170): va al final. Abre FuryFlashOffers.
    if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto) and (tonumber(_ED.user_info and _ED.user_info.user_grade) or 0) >= 5 then
        app.load("client.l_digital.activity.flash_offers.FuryFlashOffers")
        local furyFlashOffers = FuryFlashOffersCell:createCell()
        furyFlashOffers:init()
        furyFlashOffers.activity_type = 29170
        self:addActivityIconIntoGroup({iconCell = furyFlashOffers, lineType = self.enumLineType.SECONDLINE})
    end

    -- Fury: EL PASE DE TEMPORADA (sistema 15, 30-sep-2026, docs/systems/pase_temporada.md). Desde el
    -- nivel 10; sin fila en activity_sorting_mould (29160): va al final. Abre FurySeasonPass.
    if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto) and (tonumber(_ED.user_info and _ED.user_info.user_grade) or 0) >= 10 then
        app.load("client.l_digital.activity.season_pass.FurySeasonPass")
        local furySeasonPass = FurySeasonPassCell:createCell()
        furySeasonPass:init()
        furySeasonPass.activity_type = 29160
        self:addActivityIconIntoGroup({iconCell = furySeasonPass, lineType = self.enumLineType.SECONDLINE})
    end

    -- Fury: LOS HITOS DEL SERVIDOR (sistema 19, 30-sep-2026, docs/systems/hitos_servidor.md). Desde el
    -- nivel 5; sin fila en activity_sorting_mould (29200): va al final. Abre FuryServerMilestone.
    if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto) and (tonumber(_ED.user_info and _ED.user_info.user_grade) or 0) >= 5 then
        app.load("client.l_digital.activity.server_milestone.FuryServerMilestone")
        local furyServerMilestone = FuryServerMilestoneCell:createCell()
        furyServerMilestone:init()
        furyServerMilestone.activity_type = 29200
        self:addActivityIconIntoGroup({iconCell = furyServerMilestone, lineType = self.enumLineType.SECONDLINE})
    end
	
    if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and tonumber(_ED.combine_ship_prop_get) ~= 2 then 
        -- 组合卡道具领取入口
        local combinationProp = nil
        if self.combination_prop_open then
            if self.combination_prop_open then
                app.load("client.activity.combine_prop.CombinePropCell")
                combinationProp = CombinePropCell:createCell()
                combinationProp:init()
                combinationProp.activity_type = 20001
            else
                if fwin:find("CombinePropWindowClass") then
                    fwin:close(fwin:find("CombinePropWindowClass"))
                end
                if fwin:find("CombinePropCellClass") then
                    fwin:close(fwin:find("CombinePropCellClass"))
                end
            end
        end

        if combinationProp then 
             -- 组合卡道具领取入口
            self:addActivityIconIntoGroup({iconCell = combinationProp, lineType = self.enumLineType.FIRSTLINE})
        end
    else
        if fwin:find("CombinePropWindowClass") then
            fwin:close(fwin:find("CombinePropWindowClass"))
        end
        if fwin:find("CombinePropCellClass") then
            fwin:close(fwin:find("CombinePropCellClass"))
        end
    end

    -- YouTube推广
    if videoFansExtension then
        if __lua_project_id == __lua_project_l_digital then 
            self:addActivityIconIntoGroup({iconCell = videoFansExtension, lineType = self.enumLineType.SECONDLINE})
        else
            self:addActivityIconIntoGroup({iconCell = videoFansExtension, lineType = self.enumLineType.FIRSTLINE})
        end
    end

    if __lua_project_id == __lua_project_l_dragonball2 then 
        -- DB2项目不显示vip礼包
    else
        -- vip礼包显示规则（只要存在没有购买的vip礼包就会显示）
        if getCanBuySmallestGiftLevel() > 0 then
            local HomeVipPacks = ActivityIconCell:createCell()
            HomeVipPacks:init(HomeVipPacks.enum_type.ACTIVITY_SM_VIP_PACKS)
            if __lua_project_id == __lua_project_l_digital then 
                self:addActivityIconIntoGroup({iconCell = HomeVipPacks, lineType = self.enumLineType.SECONDLINE })
            else
                self:addActivityIconIntoGroup({iconCell = HomeVipPacks, lineType = self.enumLineType.FIRSTLINE})
            end
        end
    end
    -- 月卡重塑福利入口
    local newMonthCardWelfare = nil 
    if _ED.active_activity[192] ~= nil then
        newMonthCardWelfare = ActivityIconCell:createCell()
        newMonthCardWelfare:init(newMonthCardWelfare.enum_type.ACTIVITY_SM_ON_CARD)
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 1000)
    end
	if __lua_project_id == __lua_project_l_naruto then
        -- 月卡重塑福利入口
        if newMonthCardWelfare ~= nil then 
            self:addActivityIconIntoGroup({iconCell = newMonthCardWelfare, lineType = self.enumLineType.FIRSTLINE})
        end
		--table.insert(items, firstRecharge)    -- 首充
		if firstRecharge == nil then
			local m_isVisible = false
            -- 月卡重塑对于老月卡改为表控制
            local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 1000)
            if activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
            else
                for i,v in pairs(_ED.month_card) do
                    if tonumber(v.surplus_month_card_time) == 0 then
                        m_isVisible = true
                    end
                end
                if m_isVisible == true then
                    local monthCardWelfare = ActivityIconCell:createCell()
                    monthCardWelfare:init(monthCardWelfare.enum_type.ACTIVITY_SM_ON_CARD)
                    self:addActivityIconIntoGroup({iconCell = monthCardWelfare, lineType = self.enumLineType.FIRSTLINE})    -- 月卡福利
                end
                    -- local HomeVipPacks = ActivityIconCell:createCell()
                    -- HomeVipPacks:init(HomeVipPacks.enum_type.ACTIVITY_SM_VIP_PACKS)
                    -- table.insert(items, HomeVipPacks)           --vip礼包
			    -- end
            end
		end

		local rechargeRecharge = ActivityIconCell:createCell()
		rechargeRecharge:init(rechargeRecharge.enum_type.ACTIVITY_HOME_RECHARGE_BUTTON)
        rechargeRecharge.activity_type = 20003
        self:addActivityIconIntoGroup({iconCell = rechargeRecharge, lineType = self.enumLineType.FIRSTLINE})        -- 充值
        self:addActivityIconIntoGroup({iconCell = activityIcon, lineType = self.enumLineType.FIRSTLINE})            -- 活动
        if Landingreword ~= nil then
            self:addActivityIconIntoGroup({iconCell = Landingreword, lineType = self.enumLineType.FIRSTLINE})       -- 登陆奖励
		end
        if seveFundAty ~= nil then
            self:addActivityIconIntoGroup({iconCell = seveFundAty, lineType = self.enumLineType.FIRSTLINE})       -- 开服基金
		end
        if pathGrowthAty then
            self:addActivityIconIntoGroup({iconCell = pathGrowthAty, lineType = self.enumLineType.SECONDLINE })
        end
        if richFirstRechargeAty then
            self:addActivityIconIntoGroup({iconCell = richFirstRechargeAty, lineType = self.enumLineType.FIRSTLINE})    -- 豪华首冲
        end
        -- 限时排行
        if limitRankAty then
            self:addActivityIconIntoGroup({iconCell = limitRankAty, lineType = self.enumLineType.SECONDLINE })
        end

        -- 皮卡丘大冒险
        if pikachuAdventureAty then
            self:addActivityIconIntoGroup({iconCell = pikachuAdventureAty, lineType = self.enumLineType.SECONDLINE })
        end

        -- 宝可梦秘宝
        if pokemonTreasureAty then
            self:addActivityIconIntoGroup({iconCell = pokemonTreasureAty, lineType = self.enumLineType.SECONDLINE })
        end

         --跨服排行
        if  pokemonRechargeAty then
            self:addActivityIconIntoGroup({iconCell = pokemonRechargeAty, lineType = self.enumLineType.SECONDLINE })
        end

        -- 七天乐
        if severHappyAty then
            self:addActivityIconIntoGroup({iconCell = severHappyAty, lineType = self.enumLineType.SECONDLINE })
        end

        -- 武器扭蛋
        if pokemonEggMachineAty then
            self:addActivityIconIntoGroup({iconCell = pokemonEggMachineAty, lineType = self.enumLineType.SECONDLINE })
        end

        --节日红包
        if redPacketAty then
            self:addActivityIconIntoGroup({iconCell = redPacketAty, lineType = self.enumLineType.SECONDLINE })
        end

           --大师训练营
        if trainingcampAty then
            self:addActivityIconIntoGroup({iconCell = trainingcampAty, lineType = self.enumLineType.FIRSTLINE})
        end

        -- 世界boss
        if worldBossAty then
            self:addActivityIconIntoGroup({iconCell = worldBossAty, lineType = self.enumLineType.FIRSTLINE})
        end    

        self:addActivityIconIntoGroup({iconCell = limitedTimeBox, lineType = self.enumLineType.FIRSTLINE})    -- 限时宝箱
        self:addActivityIconIntoGroup({iconCell = limitedSprite, lineType = self.enumLineType.FIRSTLINE})    -- 限时宝箱

        
        self:addActivityIconIntoGroup({iconCell = sevenDayAty, lineType = self.enumLineType.SECONDLINE })      -- 七日活动
        self:addActivityIconIntoGroup({iconCell = smokedeggs1, lineType = self.enumLineType.SECONDLINE })      -- 钻石砸金蛋
        self:addActivityIconIntoGroup({iconCell = smokedeggs2, lineType = self.enumLineType.SECONDLINE })      -- 金币砸金蛋
        self:addActivityIconIntoGroup({iconCell = fullServiceRankings, lineType = self.enumLineType.SECONDLINE })      -- 全服排名活动
        self:addActivityIconIntoGroup({iconCell = welcomeMoneyMan, lineType = self.enumLineType.SECONDLINE})      -- 大耳有福活动

        --宝可梦救助站
        if rescuestationAty then
            self:addActivityIconIntoGroup({iconCell = rescuestationAty, lineType = self.enumLineType.FIRSTLINE})
        end
	else
        -- 世界boss
        if worldBossAty then
            if __lua_project_id == __lua_project_l_digital then 
                self:addActivityIconIntoGroup({iconCell = worldBossAty, lineType = self.enumLineType.SECONDLINE})
                
            else
                self:addActivityIconIntoGroup({iconCell = worldBossAty, lineType = self.enumLineType.FIRSTLINE})
            end
        end
        
        --微信活动
        if wechatRewardAty then
            self:addActivityIconIntoGroup({iconCell = wechatRewardAty, lineType = self.enumLineType.FIRSTLINE})
        end

        -- 豪华首冲
        if richFirstRechargeAty then
            self:addActivityIconIntoGroup({iconCell = richFirstRechargeAty, lineType = self.enumLineType.FIRSTLINE})
        end
        if __lua_project_id == __lua_project_l_digital then -- DSC商城按钮
            local texturePath = "images/ui/home/home_shop_1.png"
            -- local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(texturePath)
            -- if spriteFrame ~= nil then
                local Button_shop_0 = ccui.Helper:seekWidgetByName(root, "Button_shop_0")
                Button_shop_0:setVisible(false)
                local btnShop = ccui.Button:create(texturePath, texturePath, texturePath, 1)
                btnShop:setName("btnShop")
                btnShop:ignoreContentAdaptWithSize(false)
                btnShop:setContentSize(Button_shop_0:getContentSize())
                local nodeShop = ccui.Widget:create()
                nodeShop:setContentSize(cc.size(100, 97))
                nodeShop:setAnchorPoint(cc.p(0, 0))
                btnShop:setPosition(cc.p(nodeShop:getContentSize().width / 2, nodeShop:getContentSize().height / 2 + 2))
                nodeShop:addChild(btnShop)
                nodeShop.activity_type = 20006
                self:addActivityIconIntoGroup({iconCell = nodeShop, lineType = self.enumLineType.FIRSTLINE})

                fwin:addTouchEventListener(btnShop, nil, 
                    {
                        terminal_name = "menu_manager", 	
                        next_terminal_name = "menu_show_shop", 			
                        current_button_name = "Button_shop_0", 		
                        but_image = "Image_shop", 		
                        terminal_state = 0,
                        shop_type = "shop",
                        isPressedActionEnabled = true
                    }, 
                    nil, 0)
                    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_new_shop",
                    _widget = btnShop,
                    _invoke = nil,
                    _interval = 0.5,})
            -- end
        end
            
        -- 首充
        if __lua_project_id ~= __lua_project_l_pokemon and __lua_project_id ~= __lua_project_onepiece then
            self:addActivityIconIntoGroup({iconCell = firstRecharge, lineType = self.enumLineType.FIRSTLINE})
        end

        if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
        else
            -- 月卡重塑福利入口
            if newMonthCardWelfare ~= nil then 
                self:addActivityIconIntoGroup({iconCell = newMonthCardWelfare, lineType = self.enumLineType.FIRSTLINE})
            end
    		if firstRecharge == nil then
    			local m_isVisible = false
                -- 月卡重塑对于老月卡改为表控制
                local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 1000)
                if activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
                else
                    for i,v in pairs(_ED.month_card) do
                        if tonumber(v.surplus_month_card_time) == 0 then
                            m_isVisible = true
                        end
                    end
                end
    			if m_isVisible == true then
    				local monthCardWelfare = ActivityIconCell:createCell()
    				monthCardWelfare:init(monthCardWelfare.enum_type.ACTIVITY_SM_ON_CARD)
                    -- 月卡福利
                    self:addActivityIconIntoGroup({iconCell = monthCardWelfare, lineType = self.enumLineType.FIRSTLINE})
    			else
                    -- 如果已经到了18级，则显示充值按钮
                    if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece ) and tonumber(_ED.vip_grade) == tonumber(_vip_max_grade[1]) then
                        local HomeChongzhi = ActivityIconCell:createCell()
                        HomeChongzhi:init(HomeChongzhi.enum_type.ACTIVITY_HOME_RECHARGE_BUTTON)
                        if __lua_project_id == __lua_project_l_digital then 
                            self:addActivityIconIntoGroup({iconCell = HomeChongzhi, lineType = self.enumLineType.SECONDLINE})
                        else
                            self:addActivityIconIntoGroup({iconCell = HomeChongzhi, lineType = self.enumLineType.FIRSTLINE})
                        end
                    else
                        -- vip礼包
                        -- local HomeVipPacks = ActivityIconCell:createCell()
                        -- HomeVipPacks:init(HomeVipPacks.enum_type.ACTIVITY_SM_VIP_PACKS)
                        -- table.insert(items, HomeVipPacks)
                    end
    			end
    		end
        end

        self:addActivityIconIntoGroup({iconCell = activityIcon, lineType = self.enumLineType.FIRSTLINE})    -- 活动

        -- 武器扭蛋
        if pokemonEggMachineAty then
            self:addActivityIconIntoGroup({iconCell = pokemonEggMachineAty, lineType = self.enumLineType.SECONDLINE})
        end

        -- 皮卡丘大冒险
        if pikachuAdventureAty then
            self:addActivityIconIntoGroup({iconCell = pikachuAdventureAty, lineType = self.enumLineType.SECONDLINE})
        end

        -- 宝可梦秘宝
        if pokemonTreasureAty then
            self:addActivityIconIntoGroup({iconCell = pokemonTreasureAty, lineType = self.enumLineType.SECONDLINE})
        end

        --节日红包
        if redPacketAty then
            self:addActivityIconIntoGroup({iconCell = redPacketAty, lineType = self.enumLineType.SECONDLINE})
        end
        
        --跨服排行
        if  pokemonRechargeAty then
            self:addActivityIconIntoGroup({iconCell = pokemonRechargeAty, lineType = self.enumLineType.SECONDLINE})
        end

        -- 限时排行
        if limitRankAty then
            self:addActivityIconIntoGroup({iconCell = limitRankAty, lineType = self.enumLineType.SECONDLINE})
        end

         --大师训练营
        if trainingcampAty then
            if __lua_project_id == __lua_project_l_digital then 
                self:addActivityIconIntoGroup({iconCell = trainingcampAty, lineType = self.enumLineType.SECONDLINE})
            else
                self:addActivityIconIntoGroup({iconCell = trainingcampAty, lineType = self.enumLineType.FIRSTLINE})
            end
        end

         --宝可梦救助站
        if rescuestationAty then
            if __lua_project_id == __lua_project_l_digital then
                self:addActivityIconIntoGroup({iconCell = rescuestationAty, lineType = self.enumLineType.SECONDLINE}) 
            else
                self:addActivityIconIntoGroup({iconCell = rescuestationAty, lineType = self.enumLineType.FIRSTLINE})
            end
        end

        -- 七天乐
        if severHappyAty then
            self:addActivityIconIntoGroup({iconCell = severHappyAty, lineType = self.enumLineType.SECONDLINE})
        end

        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_digital then
            if pathGrowthAty then
                self:addActivityIconIntoGroup({iconCell = pathGrowthAty, lineType = self.enumLineType.SECONDLINE})
            end
        end
        
        -- 金币砸金蛋
        self:addActivityIconIntoGroup({iconCell = smokedeggs1, lineType = self.enumLineType.SECONDLINE})
        -- 钻石砸金蛋
        self:addActivityIconIntoGroup({iconCell = smokedeggs2, lineType = self.enumLineType.SECONDLINE})

        if otherRecruitActivity ~= nil then
            -- 机械邪龙兽来袭
            self:addActivityIconIntoGroup({iconCell = otherRecruitActivity, lineType = self.enumLineType.SECONDLINE})
        end

        -- 限时神兽
        self:addActivityIconIntoGroup({iconCell = limitedTimeBox, lineType = self.enumLineType.SECONDLINE})

        self:addActivityIconIntoGroup({iconCell = limitedSprite, lineType = self.enumLineType.SECONDLINE})
        
	-- 大耳有福活动，天使送礼
        self:addActivityIconIntoGroup({iconCell = welcomeMoneyMan, lineType = self.enumLineType.SECONDLINE})

        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
            if seveFundAty ~= nil then
                -- 开服基金
                self:addActivityIconIntoGroup({iconCell = seveFundAty, lineType = self.enumLineType.SECONDLINE})
            end
        end

        -- 全服排名活动
        self:addActivityIconIntoGroup({iconCell = fullServiceRankings, lineType = self.enumLineType.SECONDLINE})

        -- 七日活动，开服狂欢
        self:addActivityIconIntoGroup({iconCell = sevenDayAty, lineType = self.enumLineType.SECONDLINE})

        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_pokemon then
            if Landingreword ~= nil then
                -- 登陆奖励
                self:addActivityIconIntoGroup({iconCell = Landingreword, lineType = self.enumLineType.SECONDLINE})
            end
        end

	end

    -- 火影
    if __lua_project_id == __lua_project_l_naruto then
        -- 节日道具兑换活动
        self:addActivityIconIntoGroup({iconCell = festivalExchange, lineType = self.enumLineType.SECONDLINE})
        -- 新节日兑换活动（复制121）
        self:addActivityIconIntoGroup({iconCell = newFestivalExchange, lineType = self.enumLineType.SECONDLINE})

        if rechargeReturnGold ~= nil then
            -- 充值返钻
            self:addActivityIconIntoGroup({iconCell = rechargeReturnGold, lineType = self.enumLineType.SECONDLINE})
        end

        -- 机械邪龙兽来袭
        if otherRecruitActivity ~= nil then
            self:addActivityIconIntoGroup({iconCell = otherRecruitActivity, lineType = self.enumLineType.SECONDLINE})
        end
    end

    -- 活跃度
    if activityActive ~= nil then
        if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            self:addActivityIconIntoGroup({iconCell = activityActive, lineType = self.enumLineType.FIRSTLINE})
        else
            self:addActivityIconIntoGroup({iconCell = activityActive, lineType = self.enumLineType.SECONDLINE})
        end
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        -- 任务
        Button_dailytasks:setVisible(false)
        local btnTask = ccui.Button:create("images/ui/home/activity_everyday.png", "images/ui/home/activity_everyday.png", "images/ui/home/activity_everyday.png", 1)
        btnTask:setName("btnTask")
        local nodeTask = ccui.Widget:create()
        if __lua_project_id == __lua_project_l_digital then
            btnTask:ignoreContentAdaptWithSize(false)
            btnTask:setContentSize(Button_dailytasks:getContentSize())
            nodeTask:setContentSize(cc.size(100, 97))
        else
            nodeTask:setContentSize(cc.size(80, 90))
        end
        nodeTask:setAnchorPoint(cc.p(0, 0))
        btnTask:setPosition(cc.p(nodeTask:getContentSize().width / 2, nodeTask:getContentSize().height / 2 + 2))
        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            btnTask:setPosition(cc.p(nodeTask:getContentSize().width / 2, nodeTask:getContentSize().height / 2 + 3.5))
        end
        nodeTask:addChild(btnTask)
        nodeTask.activity_type = 20007
        self:addActivityIconIntoGroup({iconCell = nodeTask, lineType = self.enumLineType.FIRSTLINE})

        fwin:addTouchEventListener(btnTask, nil, 
        {
            terminal_name = "activity_every_day_button", 
            terminal_state = 0, 
            isPressedActionEnabled = true
        },
        nil, 0)
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_main_page_daily_activity",
        _widget = btnTask,
        _invoke = nil,
        _interval = 0.5,})
    end
    
    -- 首页每日累充活动
    local activityDailyConsumeRecharge = nil
    if __lua_project_id == __lua_project_l_digital then
        if _ED.active_activity[106] ~= nil then
            state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 106)
            activityDailyConsumeRecharge = ActivityIconCell:createCell()
            activityDailyConsumeRecharge:init(activityDailyConsumeRecharge.enum_type.ACTIVITY_SM_RECHARGE_GET_REWARD)
        end
    end

    -- 幸运占卜(新)
    local activityDivination = nil
    if _ED.active_activity[161] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 161)
        activityDivination = ActivityIconCell:createCell()
        activityDivination:init(activityDivination.enum_type.ACTIVITY_DIVINATION_GAME)
    end

    -- 金猪纳宝
    local goldenPigNaba = nil
    if _ED.active_activity[167] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 167)
        goldenPigNaba = ActivityIconCell:createCell()
        goldenPigNaba:init(goldenPigNaba.enum_type.ACTIVITY_SM_GOLDEN_PIG_NABA)
    end

    -- 首页限时折扣
    local activityHomeDiscount = nil
    if _ED.active_activity[112] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 112)
        activityHomeDiscount = ActivityIconCell:createCell()
        activityHomeDiscount:init(activityHomeDiscount.enum_type.ACTIVITY_DISCOUNT_SALE_HOME)
    end

    -- 首页拉霸入口
    local activityLaba = nil
    if _ED.active_activity[162] ~= nil then
        -- state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 112)
        activityLaba = ActivityIconCell:createCell()
        activityLaba:init(activityLaba.enum_type.ACTIVITY_LABA_HOME)
    end

    -- 首页特权卡入口
    local activitySpecialCard = nil
    if _ED.active_activity[163] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 163)
        activitySpecialCard = ActivityIconCell:createCell()
        activitySpecialCard:init(activitySpecialCard.enum_type.ACTIVITY_SPECIAL_CARD_HOME)
    end

    -- 首页回归七天乐入口
    local activitySevenDayRegression = nil
    if _ED.active_activity[166] ~= nil then
        activitySevenDayRegression = ActivityIconCell:createCell()
        activitySevenDayRegression:init(activitySevenDayRegression.enum_type.ACTIVITY_SEVEN_DAY_REGRESSION)

        activitySevenDayRegression._notification = { _terminal_name = "push_notification_seven_day_regression_push",
            _widget = activitySevenDayRegression,
            _invoke = nil,
            _interval = 0.5,}
    end

    -- 首页回归签到入口
    local activityUserReturn = nil
    if _ED.active_activity[164] ~= nil and _ED.active_activity[165] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 164)
        activityUserReturn = ActivityIconCell:createCell()
        activityUserReturn:init(activityUserReturn.enum_type.ACTIVITY_USER_RETURN)
        
    end

    -- 首页单笔充值入口
    local activitySingleRecharge = nil
    if _ED.active_activity[152] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 152)
        activitySingleRecharge = ActivityIconCell:createCell()
        activitySingleRecharge:init(activitySingleRecharge.enum_type.ACTIVITY_DAILY_ONCE_RECHARGE)
    end

    -- 首页超值礼包
    local activitySuperPack = nil
    if _ED.active_activity[179] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 179)
        activitySuperPack = ActivityIconCell:createCell()
        activitySuperPack:init(activitySuperPack.enum_type.ACTIVITY_SM_SUPER_PACK)
    end

    -- 首页限时奖池
    local activityLimitPool = nil
    if _ED.active_activity[168] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 168)
        activityLimitPool = ActivityIconCell:createCell()
        activityLimitPool:init(activityLimitPool.enum_type.ACTIVITY_LIMIT_POOL)
    end

    -- 首页排重福袋(幸运配对)
    local activityFortuneBag = nil
    if _ED.active_activity[169] ~= nil then
        _ED.active_activity[169].activity_data = json.decode(_ED.active_activity[169].activity_params)
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 169)
        activityFortuneBag = ActivityIconCell:createCell()
        activityFortuneBag:init(activityFortuneBag.enum_type.ACTIVITY_FORTUNE_BAG)
    end

    -- 首页私人订制
    local activityCustomGift = nil
    if _ED.active_activity[170] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 170)
        activityCustomGift = ActivityIconCell:createCell()
        activityCustomGift:init(activityCustomGift.enum_type.ACTIVITY_PRIVATE_CUSTOM)
    end

    -- 首页彩蛋舞会
    local activityEggDance = nil
    if _ED.active_activity[171] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 171)
        activityEggDance = ActivityIconCell:createCell()
        activityEggDance:init(activityEggDance.enum_type.ACTIVITY_EGG_DANCE)
    end

    -- 首页夏日酷饮
    local activitySummerDrink = nil
    if _ED.active_activity[172] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 172)
        activitySummerDrink = ActivityIconCell:createCell()
        activitySummerDrink:init(activitySummerDrink.enum_type.ACTIVITY_SUMMER_DRINK)
    end

    -- 首页秘境之旅
    local activitySecretJourney = nil
    if _ED.active_activity[173] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 173)
        activitySecretJourney = ActivityIconCell:createCell()
        activitySecretJourney:init(activitySecretJourney.enum_type.ACTIVITY_SECRET_JOURNEY)
    end

    -- 首页号令忍界
    local activityCommandWorld = nil
    if _ED.active_activity[174] ~= nil then
        activityCommandWorld = ActivityIconCell:createCell()
        activityCommandWorld:init(activityCommandWorld.enum_type.ACTIVITY_COMMAND_WORLD)
        local function activityOrdersWorldResponseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 174)
                state_machine.excute("home_update_back_pack_clock_pic", 0, nil)
            end
        end
        NetworkManager:register(protocol_command.activity_orders_world_init.code, nil, nil, nil, nil, activityOrdersWorldResponseCallback, false, nil)
    end

    -- 首页七日连充
    local activitySevenDaysRecharge = nil
    if _ED.showSevenDaysRecharge then
        activitySevenDaysRecharge = ActivityIconCell:createCell()
        activitySevenDaysRecharge:init(activitySevenDaysRecharge.enum_type.ACTIVITY_SEVEN_DAYS_RCHARGE)
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 1003)
    end

    -- 首页道具置换
    local activityExchangeProp = nil
    if _ED.active_activity[28] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 28)
        activityExchangeProp = ActivityIconCell:createCell()
        activityExchangeProp:init(activityExchangeProp.enum_type.ACTIVITY_EXCHANGE_PROP)
    end

    -- 半月礼home
    local activityMonthGift = nil
    if _ED.active_activity[175] ~= nil then
        local curRoleLevel = tonumber(_ED.user_info.user_grade)
        local openLevel = 7

        local isOpenActivityMonthGift = true

        if _ED.active_activity[175].activity_params ~= nil and _ED.active_activity[175].activity_params ~= "" then
            local activityParams = json.decode(_ED.active_activity[175].activity_params).dayInfo
            local endTimeAct = activityParams[4].endTime        
            isOpenActivityMonthGift = difftime(endTimeAct) > 0
        end
        
        if isOpenActivityMonthGift == true then 
            activityMonthGift = ActivityIconCell:createCell()
            activityMonthGift:init(activityMonthGift.enum_type.ACTIVITY_MONTH_GIFT)
            local function activityMonthGiftresponseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    local activity_info = _ED.active_activity[175].activityInitData
                    if activity_info ~= nil then
                        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 175)
    
                        -- 7级之后
                        local isShowUI = false
                        if curRoleLevel >= openLevel then
                            local isPop = cc.UserDefault:getInstance():getStringForKey(getKey("isPopActivityMonthGift"), "")
                            if isPop ~= nil and isPop ~= "" then
                                local firstLogin = activity_info.firstLogin
                                isShowUI = firstLogin
                            else
                                writeKey("isPopActivityMonthGift", 1)
                                isShowUI = true
                            end 
                        end
                        
                        if isShowUI == true then
                            app.load("client.activity.wonderful.ActivityMonthGift")
                            state_machine.excute("activity_month_gift_open", 0, nil)
                        end
                    end
                end
            end
            NetworkManager:register(protocol_command.half_the_ritual_init.code, nil, nil, nil, nil, activityMonthGiftresponseCallback, false, nil)
        end
    end

    -- 超值团购home
    local activityGroupBuy = nil
    if _ED.active_activity[176] ~= nil then
        activityGroupBuy = ActivityIconCell:createCell()
        activityGroupBuy:init(activityGroupBuy.enum_type.ACTIVITY_GROUP_BUY)
        local function activityGroupBuyresponseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                local activity_info = _ED.active_activity[176].activityAllData
                if activity_info ~= nil then
                    state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 176)
                end
            end
        end
        NetworkManager:register(protocol_command.activity_group_buy_init.code, nil, nil, nil, nil, activityGroupBuyresponseCallback, false, nil)
    end

    -- 首页限时祈福
    local activityPray = nil
    if _ED.active_activity[180] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 180)
        activityPray = ActivityIconCell:createCell()
        activityPray:init(activityPray.enum_type.ACTIVITY_LIM_PRAY)
    end

    --首页圣诞奇缘
    local activityChristmasRomance = nil
    if _ED.active_activity[181] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 181)
        activityChristmasRomance = ActivityIconCell:createCell()
        activityChristmasRomance:init(activityChristmasRomance.enum_type.ACTIVITY_CHRISTMAS_ROMANCE)
    end

    -- 首页新服庆典
    local activityNewServerCelebration = nil
    if _ED.active_activity[182] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 182)
        activityNewServerCelebration = ActivityIconCell:createCell()
        activityNewServerCelebration:init(activityNewServerCelebration.enum_type.ACTIVITY_NEW_SERVER_CELEBRATION)
    end
    
    -- 首页常规战令活动
    local activityOrdinaryWarOrder = nil
    local activityWarOrderInfo = _ED.active_activity[185]
    -- debug.print_r(activityWarOrderInfo, "====activityWarOrderInfo")
    if activityWarOrderInfo ~= nil and activityWarOrderInfo.user_order_info ~= nil and table.nums(activityWarOrderInfo.user_order_info.warOrderTypeInfo) > 0 then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 185)
        activityOrdinaryWarOrder = ActivityIconCell:createCell()
        activityOrdinaryWarOrder:init(activityOrdinaryWarOrder.enum_type.ACTIVITY_ORDINARY_WAR_ORDER)
    end


    -- 首页建号战令活动
    local activityConstructionWarOrder = nil
    -- debug.print_r( _ED.active_activity[186], "=== _ED.active_activity[186]")
    if _ED.active_activity[186] ~= nil and _ED.active_activity[186].user_order_info ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 186)
        activityConstructionWarOrder = ActivityIconCell:createCell()
        activityConstructionWarOrder:init(activityConstructionWarOrder.enum_type.ACTIVITY_CONSTRUCTION_WAR_ORDER)
    end

    --大富翁
    local activityRichman = nil
    if _ED.active_activity[187] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 187)
        activityRichman = ActivityIconCell:createCell()
        activityRichman:init(activityRichman.enum_type.ACTIVITY_RICH_MAN)
    end

    -- 首页跨服限时奖池
    local activityCrossServerLimitPool = nil
    if _ED.active_activity[188] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 188)
        activityCrossServerLimitPool = ActivityIconCell:createCell()
        activityCrossServerLimitPool:init(activityCrossServerLimitPool.enum_type.ACTIVITY_CROSS_SERVER_LIMIT_POOL)
    end

    -- 限时召唤up池1
    local activityLimSummon_1 = nil
    local idActivity = 189
    if _ED.active_activity[idActivity] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, idActivity)
        activityLimSummon_1 = ActivityIconCell:createCell()
        activityLimSummon_1:init(activityLimSummon_1.enum_type.ACTIVITY_LIM_SUMMON_UP_1)
    end

    -- 限时召唤up池2
    local activityLimSummon_2 = nil
    local idActivity = 190
    if _ED.active_activity[idActivity] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, idActivity)
        activityLimSummon_2 = ActivityIconCell:createCell()
        activityLimSummon_2:init(activityLimSummon_2.enum_type.ACTIVITY_LIM_SUMMON_UP_2)
    end

    -- 彩蛋活动轮播界面
    if _ED.active_activity[191] ~= nil then
        app.load("client.activity.easter_egg.EasterEggHandle")
        EasterEggHandle.showEggGuide(self.roots[1])
        -- 主城彩彩蛋事件添加
        if self.roots[1].homeEgg == nil then 
            local eggcell = showEasterEggEvent(1,-1,self.roots[1])
            if eggcell then
                self.roots[1].homeEgg = eggcell 
            end
        end
    end

    -- 首冲重塑活动界面
    local activityFirstRechargeNew = nil 
    if _ED.active_activity[193] ~= nil then
        _ED.active_activity[193].activity_data = json.decode(_ED.active_activity[193].activity_params)
        if GetFlagActivityForFirstRecharge() then 
            state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 193)
            activityFirstRechargeNew = ActivityIconCell:createCell()
            activityFirstRechargeNew:init(activityFirstRechargeNew.enum_type.ACTIVITY_FIRST_RECHARGE)
        end
    end
    
    -- 开服狂欢重塑活动界面
    local activityOpenCarnival = nil 
    if _ED.active_activity[194] ~= nil then
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 194)
        activityOpenCarnival = ActivityIconCell:createCell()
        activityOpenCarnival:init(activityOpenCarnival.enum_type.ACTIVITY_OPEN_CARNIVAL)
    end

    -- 节日道具兑换活动
    if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece ) and festivalExchange ~= nil then
        self:addActivityIconIntoGroup({iconCell = festivalExchange, lineType = self.enumLineType.SECONDLINE, insertIndex = 1})
    end

    -- 新节日兑换活动（复制121）
    if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece ) and newFestivalExchange ~= nil then
        self:addActivityIconIntoGroup({iconCell = newFestivalExchange, lineType = self.enumLineType.SECONDLINE, insertIndex = 1})
    end

    -- 充值返利
    if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and rechargeReturnGold ~= nil then
        self:addActivityIconIntoGroup({iconCell = rechargeReturnGold, lineType = self.enumLineType.SECONDLINE, insertIndex = 1})
    end

    -- 充值返利（单笔充值）
    if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and rechargeReturnGoldNew ~= nil then
        self:addActivityIconIntoGroup({iconCell = rechargeReturnGoldNew, lineType = self.enumLineType.SECONDLINE, insertIndex = 1})
    end

    -- 充值返利
    if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and rechargeReturnInterest ~= nil then
        self:addActivityIconIntoGroup({iconCell = rechargeReturnInterest, lineType = self.enumLineType.SECONDLINE, insertIndex = 1})
    end

    
    

    -- 幸运占卜(新的)
    if activityDivination ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityDivination, lineType = self.enumLineType.SECONDLINE})
    end
    -- 金猪纳宝(新的)
    if goldenPigNaba ~= nil then
        self:addActivityIconIntoGroup({iconCell = goldenPigNaba, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页限时折扣
    if activityHomeDiscount ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityHomeDiscount, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页拉霸
    if activityLaba ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityLaba, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页特权卡
    if activitySpecialCard ~= nil then
        self:addActivityIconIntoGroup({iconCell = activitySpecialCard, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页回归七天乐入口
    if activitySevenDayRegression ~= nil then
        self:addActivityIconIntoGroup({iconCell = activitySevenDayRegression, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页回归签到入口
    if activityUserReturn ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityUserReturn, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页单笔充值入口
    if activitySingleRecharge ~= nil then
        self:addActivityIconIntoGroup({iconCell = activitySingleRecharge, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页超值礼包
    if activitySuperPack ~= nil then
        self:addActivityIconIntoGroup({iconCell = activitySuperPack, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页限时奖池
    if activityLimitPool ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityLimitPool, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页排重福袋(幸运配对)
    if activityFortuneBag ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityFortuneBag, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页私人订制
    if activityCustomGift ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityCustomGift, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页彩蛋舞会
    if activityEggDance ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityEggDance, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页彩蛋舞会
    if activitySummerDrink ~= nil then
        self:addActivityIconIntoGroup({iconCell = activitySummerDrink, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页秘境之旅
    if activitySecretJourney ~= nil then
        self:addActivityIconIntoGroup({iconCell = activitySecretJourney, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页秘境之旅
    if activityCommandWorld ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityCommandWorld, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页七日连充
    if activitySevenDaysRecharge ~= nil then
        self:addActivityIconIntoGroup({iconCell = activitySevenDaysRecharge, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页限时祈福
    if activityPray ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityPray, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页圣诞奇缘
    if activityChristmasRomance ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityChristmasRomance, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页新服庆典
    if activityNewServerCelebration ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityNewServerCelebration, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页建号战令活动
    if activityConstructionWarOrder ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityConstructionWarOrder, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首页常规战令活动
    if activityOrdinaryWarOrder ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityOrdinaryWarOrder, lineType = self.enumLineType.SECONDLINE})
    end
    
    -- 大富翁
    if activityRichman ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityRichman, lineType = self.enumLineType.SECONDLINE})
    end
    
    -- 首页跨服限时奖池
    if activityCrossServerLimitPool ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityCrossServerLimitPool, lineType = self.enumLineType.SECONDLINE})
    end
    
    -- 首页每日累充活动
    if __lua_project_id == __lua_project_l_digital then
        if activityDailyConsumeRecharge ~= nil then
            self:addActivityIconIntoGroup({iconCell = activityDailyConsumeRecharge, lineType = self.enumLineType.SECONDLINE, insertIndex = 1})
        end
    end

    -- 首页道具置换
    if activityExchangeProp ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityExchangeProp, lineType = self.enumLineType.SECONDLINE})
    end  

    -- 半月礼home
    if activityMonthGift ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityMonthGift, lineType = self.enumLineType.SECONDLINE})
    end

    -- 超值团购home
    if activityGroupBuy ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityGroupBuy, lineType = self.enumLineType.SECONDLINE})
    end

    -- 限时召唤up池1
    if activityLimSummon_1 ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityLimSummon_1, lineType = self.enumLineType.SECONDLINE})
    end

    -- 限时召唤up池2
    if activityLimSummon_2 ~= nil then
        self:addActivityIconIntoGroup({iconCell = activityLimSummon_2, lineType = self.enumLineType.SECONDLINE})
    end

    -- 首冲重塑活动界面
    self:addFirstRecharge(activityFirstRechargeNew)
    
    -- 开服狂欢重塑
    if activityOpenCarnival ~= nil then 
        self:addActivityIconIntoGroup({iconCell = activityOpenCarnival, lineType = self.enumLineType.SECONDLINE})
    end
    
    if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            AcitivityList:setPositionX(AcitivityListTwo:getPositionX()-82)
        else
	        -- DSC重塑不偏移坐标
            if __lua_project_id == __lua_project_l_digital then
                
            else
                AcitivityList:setPositionX(AcitivityListTwo:getPositionX())
            end
        end
    end

    local items, itemsTwo, itemsThree = self:sortActivityIcon(self.itemsFirstLineArray, self.itemsScecondLineArray, self.itemsThirdLineArray)

    for i, v in pairs(items) do
        if v ~= nil then
            AcitivityList:addChild(v)
			if __lua_project_id == __lua_project_l_naruto then
			else
				v:setScaleX(-1)
			end
            if v._notification ~= nil then
                state_machine.excute("push_notification_center_manager", 0, v._notification)
            end
        end
    end
    self:fitActivityRow(AcitivityList)

    for i, v in pairs(itemsTwo) do
        if v ~= nil then
            AcitivityListTwo:addChild(v)
			if __lua_project_id == __lua_project_l_naruto then
			else
				v:setScaleX(-1)
			end
            if v._notification ~= nil then
                state_machine.excute("push_notification_center_manager", 0, v._notification)
            end
        end
    end
    self:fitActivityRow(AcitivityListTwo)

    -- Con esta traza se sabe POR QUE RAMA entra sin mirar la pantalla: si
    -- `fila3=0` el bloque de abajo no corre -no hay tercera fila- y todo lo
    -- que sobra de la segunda se queda EN la segunda.
    local logIconos = cclog or print
    logIconos("[iconos] pasada=" .. tostring(Home._pasadaIconos)
        .. " fila1=" .. #items .. " fila2=" .. #itemsTwo
        .. " fila3=" .. #itemsThree .. " rowMaxIconNums=" .. tostring(self.rowMaxIconNums)
        .. " scroll2pai=" .. tostring(ccui.Helper:seekWidgetByName(root, "ScrollView_2pai") ~= nil))

    -- 显示第三列活动
    if #itemsThree > 0 then
        -- DSC重塑，第三列以后的活动ICON放入scrollview中
        local ScrollView_2pai = ccui.Helper:seekWidgetByName(root, "ScrollView_2pai")
        if  ScrollView_2pai ~= nil then
            if __lua_project_id == __lua_project_l_digital then
                
                local minLineNums = #itemsThree >= self.rowMaxIconNums and self.rowMaxIconNums or #itemsThree
                local allLines = math.ceil(#itemsThree / self.rowMaxIconNums)
                for i, v in ipairs(itemsThree) do
                    v:setScaleX(-1)
                end

                -- 获取scrollview的坐标和宽高
                if ScrollView_2pai._x == nil then
                    ScrollView_2pai._x = ScrollView_2pai:getPositionX()
                end
                if ScrollView_2pai._y == nil then
                    ScrollView_2pai._y = ScrollView_2pai:getPositionY()
                end
                if ScrollView_2pai._height == nil then
                    ScrollView_2pai._height = ScrollView_2pai:getContentSize().height
                end
                if ScrollView_2pai.width == nil then
                    ScrollView_2pai.width = ScrollView_2pai:getContentSize().width
                end

                -- 设置scrollview的属性
                ScrollView_2pai:setScaleX(-1)
                ScrollView_2pai:setAnchorPoint(0,1)
                ScrollView_2pai:setPositionX(ScrollView_2pai._x + ScrollView_2pai.width - 100)
                ScrollView_2pai:setPositionY(ScrollView_2pai._y + ScrollView_2pai._height)

                local maxWidth = 0
                if #itemsThree >= self.rowMaxIconNums then
                    maxWidth = self.rowMaxIconNums * itemsThree[1]:getContentSize().width
                else
                    maxWidth = #itemsThree * itemsThree[1]:getContentSize().width
                end
                ScrollView_2pai:setContentSize(maxWidth, allLines * itemsThree[1]:getContentSize().height)
                addNodeToScrollView{targetScrollView = ScrollView_2pai,nodeList = itemsThree, columns = minLineNums}
            
            end
        else
            local activityTwoLists = AcitivityListTwo:getParent():getChildren()
            for i, v in ipairs(activityTwoLists) do
                if v:getName() == "AcitivityListTwo2" then
                    v:removeFromParent()
                end
            end
            local AcitivityListTwo2 = AcitivityListTwo:clone()
            AcitivityListTwo2:removeAllItems()
            -- El clon NO conserva la maquetacion lineal de la lista original, y
            -- por eso la tercera fila no colocaba sus iconos: se quedaban donde
            -- los dejaba el setPosition copiado de la SEGUNDA fila, calculado
            -- para iconos de 80 px. El de la compra en grupo mide 92
            -- (activity_group_buy.csb), asi que en ese hueco se salia y quedaba
            -- partido. Con la direccion puesta, la lista coloca y desplaza ella.
            AcitivityListTwo2:setDirection(ccui.ListViewDirection.horizontal)
            AcitivityListTwo2:setPosition(cc.p(AcitivityListTwo:getPositionX(), AcitivityListTwo:getPositionY() - 80))
            AcitivityListTwo2:setName("AcitivityListTwo2")
            AcitivityListTwo:getParent():addChild(AcitivityListTwo2)
    
            for i = 1, #itemsThree do
                local item = itemsThree[i]
                AcitivityListTwo2:addChild(item)
    
                if __lua_project_id == __lua_project_l_naruto then
                else
                    item:setScaleX(-1)
                end
    
                if item._notification ~= nil then
                    state_machine.excute("push_notification_center_manager", 0, item._notification)
                end
            end
            self:fitActivityRow(AcitivityListTwo2)
        end
    end

end

-- 判断活动图标是否有红点
function Home:checkActivityHaveRedDot()
    local root = self.roots[1]
    local isHaveRedDot = false

    local listviewLineTwo = ccui.Helper:seekWidgetByName(root, "ListView_2")
    if listviewLineTwo ~= nil then
        local listviewLineTwoItems = listviewLineTwo:getItems()
        for i, v in ipairs(listviewLineTwoItems) do
            isHaveRedDot = getSmActivityIconCellPushTips(v.activity_type)
            if isHaveRedDot == true then
                break
            end
        end
        
    end

    local ScrollView_2pai = ccui.Helper:seekWidgetByName(root, "ScrollView_2pai")
    if ScrollView_2pai ~= nil and isHaveRedDot == false then
        local scrollviewLineThreeItems = ScrollView_2pai:getChildren()
        for i, v in ipairs(scrollviewLineThreeItems) do
            isHaveRedDot = getSmActivityIconCellPushTips(v.activity_type)
            if isHaveRedDot == true then
                break
            end
        end
    end

    return isHaveRedDot
end

-- 控制收放按钮红点的显示
function Home:showControlOpenShrinkRedDot()
    -- 是否显示红点
    local isShowRedot = false
    -- 如果不展开列表，需要判断活动是否有红点存在
    if self.isShowActivityList == false or self.isShowActivityList == nil then
        isShowRedot = self:checkActivityHaveRedDot()
    else
        -- 展开活动listview入口icon，不显示红点
        isShowRedot = false
    end
    
    local Image_tips_red = ccui.Helper:seekWidgetByName(self.roots[1], "Image_tips_red")
    Image_tips_red:setVisible(isShowRedot)
end

-- 控制活动listview的显示
function Home:onClickDisplayActivityIcon()
    local aniName = nil
    -- 收起活动listview入口icon，同时收放按钮上需判断是否显示红点
    if self.isShowActivityList == false or self.isShowActivityList == nil then
        aniName = "animation_more_close"
    else
        aniName = "animation_more_open"
    end

    local action = self.actions[1]
	action:play(aniName, false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "more_close" or str == "more_open" then
        	state_machine.unlock("home_activity_listview_control_open_and_shrink")
        end
    end)

    self:showControlOpenShrinkRedDot()
end

function Home:sortActivityIcon(items, itemsTwo, itemsThree)
    local copy_items = {}
    for i=#items, 1,-1 do
        table.insert(copy_items, items[i])
    end
    items = copy_items

    local copy_items_two = {}
    for i=#itemsTwo, 1,-1 do
        table.insert(copy_items_two, itemsTwo[i])
    end
    itemsTwo = copy_items_two

    local copy_items_three = {}
    for i = #itemsThree, 1, -1 do
        table.insert(copy_items_three, itemsThree[i])
    end
    itemsThree = copy_items_three

    if dms["activity_sorting_mould"] ~= nil then
        -- 属于第二行的所有图标
        local allSecondItems = {}
        table.add(allSecondItems, itemsTwo)
        table.add(allSecondItems, itemsThree)

        table.sort(items, function(a, b)
            return a.sortID < b.sortID
        end)
        
        table.sort(allSecondItems, function(a, b)
            return a.sortID < b.sortID
        end)
        
        itemsTwo = {}
        itemsThree = {}
        -- 若第二行图标数量大于最大容量，需插入第三行
        if #allSecondItems > self.rowMaxIconNums then
            for i = 1, self.rowMaxIconNums do
                table.insert(itemsTwo, allSecondItems[i])
            end

            for i = self.rowMaxIconNums + 1, #allSecondItems do
                table.insert(itemsThree, allSecondItems[i])
            end
        else
            itemsTwo = allSecondItems
        end

        -- REPARTO EQUILIBRADO (7.16, 24-sep-2026). La tabla manda a la fila 1
        -- (lineType 1) los fijos -recarga, Eventos, primera recarga...- y
        -- ademas casi todos los permanentes del calendario (27, 142, 144,
        -- 157, 164, 175); con 14-16 iconos por tanda la fila de ARRIBA se
        -- llenaba y la de abajo quedaba casi vacia. Aqui se ponen en fila
        -- TODOS en el orden de la tabla (primero los de lineType 1, luego
        -- los demas, cada grupo por sortID) y se parten en filas del mismo
        -- tamano: 2 filas hasta 2 x rowMaxIconNums (10, el tope por fila que
        -- declara el propio cliente) y 3 a partir de ahi. Ninguna fila pasa
        -- de lo que ya tenia antes y ningun icono cambia de orden relativo.
        if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
            local todos = {}
            for _, v in ipairs(items) do table.insert(todos, v) end
            for _, v in ipairs(allSecondItems) do table.insert(todos, v) end
            local filas = math.min(3, math.max(2, math.ceil(#todos / math.max(1, self.rowMaxIconNums))))
            items, itemsTwo, itemsThree = {}, {}, {}
            local destino = { items, itemsTwo, itemsThree }
            local puesto = 0
            for f = 1, filas do
                local cupo = math.ceil((#todos - puesto) / (filas - f + 1))
                for i = puesto + 1, puesto + cupo do
                    table.insert(destino[f], todos[i])
                end
                puesto = puesto + cupo
            end
        end
    end

    -- local allItems = {}
    -- for _, v in ipairs(items) do
    --     table.insert(allItems, v)
    -- end

    -- for _, v in ipairs(itemsTwo) do
    --     table.insert(allItems, v)
    -- end

    -- for _, v in ipairs(itemsThree) do
    --     table.insert(allItems, v)
    -- end

    -- local columnNum = 10
    -- local maxNum = #allItems
    -- items = {}
    -- for i = 1, columnNum do
    --     if allItems[i] then
    --         table.insert(items, allItems[i])
    --     end
    -- end

    -- itemsTwo = {}
    -- for i = columnNum + 1, columnNum * 2 do
    --     if allItems[i] then
    --         table.insert(itemsTwo, allItems[i])
    --     end
    -- end

    -- itemsThree = {}
    -- for i = columnNum * 2 + 1, columnNum * 3 do
    --     if allItems[i] then
    --         table.insert(itemsThree, allItems[i])
    --     end
    -- end

    return items, itemsTwo, itemsThree
end

function Home:cleanReawrd()
	local root = self.roots[1]
    if __lua_project_id == __lua_project_yugioh then 
        local buttosList = ccui.Helper:seekWidgetByName(root, "Panel_button_list_2")
        for i, v in pairs(buttosList:getChildren()) do
            if v.item == "reward" then
                buttosList:removeChild(v,true)
                self:refreshActivityListButtonsSize(2)
                break
            end
        end
    else
        local AcitivityList = ccui.Helper:seekWidgetByName(root, "ListView_1")
        for i, v in pairs(AcitivityList:getItems()) do
            if v.item == "reward" then
                AcitivityList:removeItem(i-1)
            end
        end
        if __lua_project_id == __lua_project_gragon_tiger_gate
            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_red_alert then
        else
            self:refreshActivityListViewSize()
        end
    end
end

function Home:updateDrawHeroIntro(_ship_mould_id)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        self._ship_mould_id = _ship_mould_id.ship_template_id
    else
        self._ship_mould_id = _ship_mould_id
    end
	
	
    local root = self.roots[1]
    local headId = dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.bust_index)
    local heroIntroString = dms.string(dms["ship_mould"], self._ship_mould_id, ship_mould.sign_msg)
    local captainName = nil
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], self._ship_mould_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        local ship_evo = zstring.split(_ship_mould_id.evolution_status, "|")
        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
        captainName = word_info[3]
    else
    	captainName = dms.string(dms["ship_mould"], self._ship_mould_id, ship_mould.captain_name)
    end
    local heroHeadPath = ""
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
        heroHeadPath = string.format("images/face/big_head/big_head_%s.png", headId)
    else
        heroHeadPath = string.format("images/face/card_head/card_head_%s.png", headId)
    end
    
    if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
        if dms.int(dms["ship_mould"], tonumber(self._ship_mould_id), ship_mould.captain_type) == 0 then
            local fashionEquip, pic = getUserFashion()
            if fashionEquip ~= nil and pic ~= nil then
                if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
                    heroHeadPath = string.format("images/face/big_head/big_head_%s.png", pic)
                else
                    heroHeadPath = string.format("images/face/card_head/card_head_%s.png", pic)
                end
            end
        end
    end
    local heroHeadPanel = ccui.Helper:seekWidgetByName(root, "Panel_card")
    local heroIntro = ccui.Helper:seekWidgetByName(root, "Text_card_11")
    heroHeadPanel:setBackGroundImage(heroHeadPath)
    heroIntro:setString(heroIntroString)
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    else
    	if  dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.captain_type) == 0 then
    		captainName = _ED.user_info.user_name
        end
	end
    if ___is_open_leadname == true then
        if Home.__userHeroFontName == nil then
            Home.__userHeroFontName = ccui.Helper:seekWidgetByName(root, "Text_2"):getFontName()
        end
        if dms.int(dms["ship_mould"], tonumber(self._ship_mould_id), ship_mould.captain_type) == 0 then
            ccui.Helper:seekWidgetByName(root, "Text_2"):setFontName("")
            ccui.Helper:seekWidgetByName(root, "Text_2"):setFontSize(ccui.Helper:seekWidgetByName(root, "Text_2"):getFontSize())-->设置字体大小
        else
            ccui.Helper:seekWidgetByName(root, "Text_2"):setFontName(Home.__userHeroFontName)
        end
    end
	ccui.Helper:seekWidgetByName(root, "Text_2"):setString(captainName)
	
	local quality = dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.ship_type) + 1
	ccui.Helper:seekWidgetByName(root, "Text_2"):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	
	if self.init_home_effect == 1 then
		self:playHeroEffect()
	else
		self.init_home_effect = 2
	end
	
	
	-- if tempMusicIndex > 0 then
		-- cc.SimpleAudioEngine:getInstance():stopAllEffects()
		-- playEffect(formatMusicFile("effect", tempMusicIndex))
	-- end
end

function Home:updateTargetTaskState( ... )
    local root = self.roots[1]

    local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
    if Panel_2 == nil then
        Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2_xr1")
    end

    if _ED.targetAchieveId == nil then
        _ED.targetAchieveId = zstring.tonumber(dms.int(dms["user_config"], 16, user_config.param))
    end
    local current_target_id = 0
    if _ED.targetAchieveId > 0 then
        for k,v in pairs(_ED.all_achieve) do
            if k >= tonumber(_ED.targetAchieveId) then
                if tonumber(v) >= 0 then
                    current_target_id = k
                    break
                end
            end
        end
    end
    if Panel_2 ~= nil then
        Panel_2:setVisible(true)
        if current_target_id > 0 then
            _ED.targetAchieveId = current_target_id
            local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
            local Panel_4 = ccui.Helper:seekWidgetByName(root, "Panel_4")
            local ArmatureNode_3 = Panel_2:getChildByName("ArmatureNode_3")
            ArmatureNode_3:setVisible(false)
            local complete = _ED.all_achieve[tonumber(_ED.targetAchieveId)]
            local max = dms.int(dms["achieve"], _ED.targetAchieveId, achieve.param2)
            local track_address = dms.string(dms["achieve"], _ED.targetAchieveId, achieve.track_address)
            track_address = zstring.split(zstring.split(track_address, "|")[1], ",")
            Panel_3:setBackGroundImage("images/ui/text/task/mbrw_icon_"..track_address[1]..".png")
            Panel_4:setBackGroundImage("images/ui/text/task/mbrw_name_"..track_address[2]..".png")
            if tonumber(complete) >= max then
                -- DSC重塑
                if __lua_project_id == __lua_project_l_digital then
                    -- 禁止代码主动释放cocostudio动画
                    -- ArmatureNode_3:removeAllChildren(true)

                    local Panel_Node_3 = ccui.Helper:seekWidgetByName(root, "Panel_Node_3")
                    if Panel_Node_3 ~= nil then
                        Panel_Node_3:removeAllChildren(true)
                    local jsonFile = "images/ui/effice/effect_target_new/effect_target_new.json"
                    local atlasFile = "images/ui/effice/effect_target_new/effect_target_new.atlas"
                    if true == cc.FileUtils:getInstance():isFileExist(jsonFile) then
                        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation1", true, nil)
                            animation:setPosition(cc.p(Panel_Node_3:getContentSize().width/2, Panel_Node_3:getContentSize().height/2))
                            Panel_Node_3:addChild(animation)
                        end
                    end
                else
                    ArmatureNode_3:setVisible(true)
                end
            end
        else
            _ED.targetAchieveId = -1
            Panel_2:setVisible(false)
        end
    end
end

function Home:playHeroEffect()
	local _ship_mould_id = self._ship_mould_id
	if nil == _ship_mould_id then
		return
	end
	local tempMusicIndex = dms.int(dms["ship_mould"], _ship_mould_id, ship_mould.sound_index)
	if self.id == nil then
		 self.id = _ship_mould_id
		if tempMusicIndex > 0 then
			playEffect(formatMusicFile("effect", tempMusicIndex))
		end
	elseif self.id == _ship_mould_id then
		cc.SimpleAudioEngine:getInstance():stopAllEffects()
	else
		self.id = _ship_mould_id
		if tempMusicIndex > 0 then
			playEffect(formatMusicFile("effect", tempMusicIndex))
		end
	end
end

-- 将活动icoN插入到对应的行数组中
-- iconCell = 图标节点icon      lineType = 所属行数  notChangeLine = 不进行换行处理 insertIndex = 插入的下标 
function Home:addActivityIconIntoGroup(params)
    local iconCell = params.iconCell
    local lineType = params.lineType
    local notChangeLine = params.notChangeLine
    local insertIndex = params.insertIndex

    if iconCell ~= nil then
        if dms["activity_sorting_mould"] ~= nil then
            local iconDataInfo = dms.searchs(dms["activity_sorting_mould"], activity_sorting_mould.activityID, iconCell.activity_type)
            if iconDataInfo ~= nil and iconDataInfo[1] ~= nil then
                lineType = dms.atoi(iconDataInfo[1], activity_sorting_mould.lineType)
                iconCell.sortID = dms.atoi(iconDataInfo[1], activity_sorting_mould.sortID)
            end
            iconCell.sortID = iconCell.sortID == nil and 10000 or iconCell.sortID
        end
        if lineType == self.enumLineType.FIRSTLINE then
            table.insert(self.itemsFirstLineArray, iconCell)
        elseif lineType == self.enumLineType.SECONDLINE then

            -- 第二行大于最大数量时插入到第三行，若不需要换行的话直接插到第二行
            if #self.itemsScecondLineArray < self.rowMaxIconNums or notChangeLine == true then
                if insertIndex ~= nil then
                    table.insert(self.itemsScecondLineArray, insertIndex, iconCell)
                else
                    table.insert(self.itemsScecondLineArray, iconCell)
                end
            elseif #self.itemsScecondLineArray >= self.rowMaxIconNums then
                table.insert(self.itemsThirdLineArray, iconCell)
            end
        end
    end

end

-- Deja una fila de iconos lista para COLOCAR y para ARRASTRAR.
--
-- `addChild` mete el icono en la lista, pero no toca el contenedor interno,
-- que se queda con los 500 px del `home_button.csb`; lo que pasa de ahi no
-- tiene recorrido de desplazamiento y no se puede tocar. Y `refreshView()`
-- por si solo no siempre basta: `ListView::updateInnerContainerSize` no hace
-- nada si la direccion de la lista no es vertical ni horizontal (cae en el
-- `default`), y estas tres listas no la declaran en ningun sitio.
--
-- Por eso aqui se hacen las tres cosas, y la ultima a mano: el ancho se
-- calcula con el ancho REAL de cada icono. No todos miden igual -el de la
-- compra en grupo (176) mide 92 px y casi todos los demas 80, ver el root
-- de `res/cocostudio/activity/icon/activity_group_buy.csb`-, y ese sobrante
-- es lo que dejaba el ultimo icono partido contra el borde.
--
-- La traza `[iconos]` dice en el registro del cliente si esto corrio y con
-- que numeros, sin tener que mirar la pantalla.
function Home:fitActivityRow(lista)
    if lista == nil then
        return
    end
    -- NARUTO (26-sep-2026): esta variante NO voltea las filas (Home.lua
    -- arriba: `if __lua_project_id == __lua_project_l_naruto` salta el
    -- `setScaleX(-1)` de la lista y de cada icono), y todo lo de aqui -la
    -- caja que se ensancha hacia la IZQUIERDA, el recorte, el ancla- esta
    -- medido para la fila volteada de Dragon Ball. Sin volteo, el recorte
    -- dejaria fuera los iconos que pasan de 500 px. Naruto se queda con su
    -- maquetacion de fabrica hasta verla en LDPlayer.
    if __lua_project_id == __lua_project_l_naruto then
        self:spaceNarutoActivityRow(lista)
        return
    end
    local items = lista:getItems()
    if items == nil or #items == 0 then
        return
    end
    lista:setDirection(ccui.ListViewDirection.horizontal)

    -- EL CORRIMIENTO DE UN HUECO. La lista va volteada (`setScaleX(-1)`) y
    -- cada icono lleva OTRO `setScaleX(-1)` para desvoltear su arte. Ese
    -- segundo volteo gira el icono sobre su ancla, y con el ancla en 0 el
    -- CUERPO se va entero fuera de su hueco: la maquetacion coloca el icono
    -- en `x`, pero lo que se pinta ocupa `[x - ancho, x]`. Medido: el icono
    -- 1 salia en [1751..1886] -fuera del visor por la derecha- y el icono 2
    -- ocupaba el hueco del 1. Con el ancla en la MITAD el cuerpo cae justo
    -- en su hueco: la maquetacion suma `ancla * ancho` a la posicion, asi
    -- que el volteo y la maquetacion se compensan.
    local ancho = (#items - 1) * lista:getItemsMargin()
    for i = 1, #items do
        local icono = items[i]
        if icono:getScaleX() < 0 then
            icono:setAnchorPoint(cc.p(0.5, icono:getAnchorPoint().y))
        end
        ancho = ancho + icono:getContentSize().width
    end

    -- La caja, ANTES de refrescar: el contenedor interno nunca puede ser
    -- mas estrecho que ella.
    local crecio = self:fitActivityBox(lista)
    lista:refreshView()
    local caja = lista:getContentSize()
    if ancho > caja.width then
        lista:setInnerContainerSize(cc.size(ancho, caja.height))
    end

    local log = cclog or print
    log("[iconos] " .. tostring(lista:getName()) .. " n=" .. #items
        .. " caja=" .. math.floor(caja.width)
        .. " crecio=" .. math.floor(crecio)
        .. " necesita=" .. math.floor(ancho)
        .. " interior=" .. math.floor(lista:getInnerContainer():getContentSize().width))

    -- La geometria se mide DESPUES de que la lista coloque. `refreshView`
    -- solo marca la maquetacion como sucia; `Layout::doLayout` corre en el
    -- siguiente `visit`. Midiendo antes, TODOS los iconos salen en el mismo
    -- sitio -el origen del contenedor- y la traza no vale para nada.
    self:trazaFilaIconos(lista, crecio)
end

-- NARUTO: SEPARACION DE LA FILA DE ICONOS (visto en LDPlayer, 26-sep).
--
-- En Naruto el boton de cada icono (con el rotulo quemado en el PNG) es mas
-- ancho que su hueco: huecos de 80-92 y botones de 88-92 colocados en x = -7..4
-- (medido con una traza del arbol de cada icono). Con margen 0 los rotulos se
-- pisaban («First recharge gift» sobre «Login gift», «Weapon & Ninja Tool
-- Replacement» sobre «Privilege Pass»). Aqui se mide lo que sobresale cada
-- icono por la izquierda y por la derecha y se da a la fila el margen justo
-- para que dos vecinos no se toquen (tope 24). No se voltea ni se recorta
-- nada: es la maquetacion de fabrica con aire entre iconos.
-- 27-sep (LDPlayer, nivel 60): con +2 los rotulos SE TOCABAN: el texto
-- quemado llega al borde del PNG («Replacement» de zc_icon_34 acaba en la
-- columna 90 de 92) y la fila va escalada a 0,75, asi que 2 px eran 1,5 en
-- pantalla y la «t» quedaba pegada a «Privilege Pass». +8 da 6 px de aire; las
-- dos filas siguen cabiendo (la mas larga, diez iconos, acaba en ~800 de 960).
function Home:spaceNarutoActivityRow(lista)
    local items = lista:getItems()
    if items == nil or #items < 2 then
        return
    end
    local function sobra(item)
        local w = item:getContentSize().width
        local izq, der = 0, 0
        for _, hijo in ipairs(item:getChildren()) do
            for _, nieto in ipairs(hijo:getChildren()) do
                if nieto:isVisible() and tolua.type(nieto) == "ccui.Button" then
                    local bb = nieto:getBoundingBox()
                    izq = math.max(izq, -bb.x)
                    der = math.max(der, bb.x + bb.width - w)
                end
            end
        end
        return izq, der
    end
    local margen = 0
    local _, derPrev = sobra(items[1])
    for i = 2, #items do
        local izq, der = sobra(items[i])
        margen = math.max(margen, derPrev + izq)
        derPrev = der
    end
    if margen <= 0 then
        return
    end
    margen = math.min(24, math.ceil(margen) + 8)
    if margen > lista:getItemsMargin() then
        lista:setItemsMargin(margen)
        lista:refreshView()
    end
end

-- Traza de geometria de una fila, medida despues de maquetar.
--
-- Se fuerza la maquetacion si el enlace la expone; si no, se mide en el
-- siguiente fotograma. Va aparte de `fitActivityRow` para que se vea que lo
-- que imprime es el estado YA colocado.
function Home:trazaFilaIconos(lista, crecio)
    local function medir()
        local items = lista:getItems()
        if items == nil or #items == 0 then
            return
        end
        local dir = cc.Director:getInstance()
        local ori, vis = dir:getVisibleOrigin(), dir:getVisibleSize()
        local interior = lista:getInnerContainer()
        local function tramo(nodo, w)
            if nodo == nil then
                return "[nil]"
            end
            local a = nodo:convertToWorldSpace(cc.p(0, 0)).x
            local b = nodo:convertToWorldSpace(cc.p(w, 0)).x
            return "[" .. math.floor(math.min(a, b)) .. ".." .. math.floor(math.max(a, b)) .. "]"
        end
        -- `isClippingEnabled` puede no estar enlazado: si no esta, se dice,
        -- que tambien es informacion.
        local function recorta(nodo)
            if nodo == nil then
                return "nil"
            end
            local ok, v = pcall(nodo.isClippingEnabled, nodo)
            if ok then
                return tostring(v)
            end
            return "n/d"
        end
        local padre = lista:getParent()
        local ultimo = items[#items]
        local log = cclog or print
        log("[iconos] " .. tostring(lista:getName())
            .. " pasada=" .. tostring(Home._pasadaIconos)
            .. " visor=" .. tramo(lista, lista:getContentSize().width)
            .. " pantalla=[" .. math.floor(ori.x) .. ".." .. math.floor(ori.x + vis.width) .. "]"
            .. " clip=" .. recorta(lista) .. "/" .. recorta(padre)
            .. " escalaX=" .. lista:getScaleX()
            .. " crecio=" .. math.floor(crecio)
            .. " ancla=" .. items[1]:getAnchorPoint().x
            .. " cartel=" .. (function()
                local c = Home.rectCartelObjetivo(self)
                if c == nil then return "nil" end
                return "[" .. math.floor(c.izq) .. ".." .. math.floor(c.der)
                    .. "]x[" .. math.floor(c.abajo) .. ".." .. math.floor(c.arriba) .. "]"
            end)()
            .. " filaY=" .. math.floor(lista:convertToWorldSpace(cc.p(0, 0)).y)
                .. ".." .. math.floor(lista:convertToWorldSpace(cc.p(0, lista:getContentSize().height)).y)
            .. " interior=" .. tramo(interior, interior:getContentSize().width)
            .. " desvio=" .. math.floor(interior:getPositionX())
            .. " item1=" .. tramo(items[1], items[1]:getContentSize().width)
            .. " item2=" .. tramo(items[math.min(2, #items)], items[math.min(2, #items)]:getContentSize().width)
            .. " itemN=" .. tramo(ultimo, ultimo:getContentSize().width)
            .. " padre=" .. tostring(padre and padre:getName())
            .. tramo(padre, padre and padre:getContentSize().width or 0))

        -- Y LA REJILLA ENTERA, hueco a hueco. Es lo unico que dice quien
        -- esta al lado de quien: un solape de dos iconos solo se puede leer
        -- con el tipo de actividad de cada hueco pegado a su tramo. Sin
        -- esto hubo que deducir el vecino del 143 desde
        -- `activity_sorting_mould`, y la tabla no dice cuales de sus filas
        -- llegaron a crearse.
        local huecos = {}
        for i = 1, #items do
            huecos[#huecos + 1] = tostring(items[i].activity_type)
                .. tramo(items[i], items[i]:getContentSize().width)
        end
        log("[iconos] " .. tostring(lista:getName())
            .. " huecos " .. table.concat(huecos, " "))
    end

    -- Y una traza mas AL SOLTAR EL ARRASTRE, que es la unica forma de ver
    -- adonde llega el recorrido de verdad.
    if lista._trazaScroll == nil then
        lista._trazaScroll = true
        pcall(lista.addScrollViewEventListener, lista, function(_, tipo)
            if tipo ~= ccui.ScrollviewEventType.scrolling then
                pcall(medir)
            end
        end)
    end

    local interior = lista:getInnerContainer()
    local forzada = pcall(interior.forceDoLayout, interior)
    if forzada then
        medir()
    elseif (Home._pasadaIconos or 0) > 4 then
        -- La ciudad remonta los iconos cada dos por tres; no hace falta
        -- llenar el registro mas alla de las primeras pasadas.
        return
    else
        -- Sin `forceDoLayout` enlazado, al siguiente fotograma: para entonces
        -- el `visit` ya ha corrido `doLayout`.
        lista:runAction(cc.Sequence:create(
            cc.DelayTime:create(0.1),
            cc.CallFunc:create(function()
                local ok, err = pcall(medir)
                if not ok then
                    local log = cclog or print
                    log("[iconos] traza tardia fallo: " .. tostring(err))
                end
            end)))
    end
end

-- Ajusta la CAJA de la fila a lo que se ve de verdad, y devuelve cuanto
-- crecio.
--
-- La caja del `.csb` mide 500 y se coloca con el ancla en (0,0) y volteada,
-- asi que ocupa `[pos - ancho, pos]`. Pero la lista NO recorta
-- (`clip=false`), o sea que los iconos se pintan por toda la pantalla, muy
-- por fuera de esa caja. Y el recorrido de desplazamiento es
-- `interior - caja`: con la caja de 500 y el contenido de 1712, el
-- recorrido es de 1212, mucho mas de lo que hace falta para pasear 1712 por
-- una pantalla de 1137 utiles. Por eso al arrastrar hasta el tope se iban
-- los iconos por la derecha y quedaba MEDIA PANTALLA VACIA, y aun asi habia
-- iconos a los que no se llegaba.
--
-- Se ensancha la caja hasta el borde izquierdo de la pantalla: como no
-- recorta, no cambia nada de lo que se pinta; lo que cambia es el recorrido,
-- que pasa a ser exactamente el que hace falta.
function Home:fitActivityBox(lista)
    local padre = lista:getParent()
    if padre == nil then
        return 0
    end
    local dir = cc.Director:getInstance()
    local ori, vis = dir:getVisibleOrigin(), dir:getVisibleSize()
    local cero = padre:convertToWorldSpace(cc.p(0, 0)).x
    local cien = padre:convertToWorldSpace(cc.p(100, 0)).x
    local escala = (cien - cero) / 100
    if escala <= 0 then
        return 0
    end
    local derecha = padre:convertToWorldSpace(cc.p(lista:getPositionX(), 0)).x

    -- EL CARTEL DE LA TAREA OBJETIVO. Al ensanchar la caja, la fila de abajo
    -- llega hasta el borde izquierdo de la pantalla y se le mete debajo al
    -- cartel «Escenario Principal», que se pinta ENCIMA y ademas se queda
    -- sus toques (`Button_1` -> `target_task_window_open`). Subir las filas no
    -- vale: el cartel ocupa `y 347..411` de maqueta y la fila de abajo
    -- `355..435`, o sea 56 de solape; subirlas 56 dejaria la de arriba en
    -- `553..633`, justo debajo de `Button_mingren` (`592..634`). Seria
    -- cambiar un tapado por otro.
    -- Asi que en vez de mover la fila se le quita ese trozo de banda: la
    -- caja empieza a la derecha del cartel y la fila recorta, con lo que no
    -- pinta ni recoge toques ahi. Solo le pasa a la fila que se cruza con el
    -- cartel; las otras dos siguen llegando al borde de la pantalla.
    local izquierda = ori.x
    local cartel = self:rectCartelObjetivo()
    if cartel ~= nil then
        local alto = lista:getContentSize().height
        local y1 = lista:convertToWorldSpace(cc.p(0, 0)).y
        local y2 = lista:convertToWorldSpace(cc.p(0, alto)).y
        if math.min(y1, y2) < cartel.arriba and math.max(y1, y2) > cartel.abajo then
            izquierda = math.max(izquierda, cartel.der)
        end
    end

    -- Lo util es de donde puede empezar la fila hasta el borde derecho de la
    -- caja, sin pasarse de la pantalla por la derecha.
    local util = (math.min(derecha, ori.x + vis.width) - izquierda) / escala
    local caja = lista:getContentSize()
    -- Con la caja ajustada a lo que se ve, recortar ya no quita nada de lo
    -- que se pinta dentro; lo que quita es lo que se salia por los lados, que
    -- es justo el trozo que se le montaba al cartel.
    pcall(lista.setClippingEnabled, lista, true)
    if util > caja.width then
        lista:setContentSize(cc.size(util, caja.height))
        return util - caja.width
    end
    return 0
end

-- Rectangulo en MUNDO del cartel de la tarea objetivo («Escenario
-- Principal»), o nil si no esta. Es `Panel_2`/`Panel_2_xr1` y lo que ocupa
-- de verdad es su `Button_1`, el que abre «Recompensa Objetiva»
-- (`target_task_window_open`, Home.lua:6644).
function Home:rectCartelObjetivo()
    local root = self.roots and self.roots[1]
    if root == nil then
        return nil
    end
    local panel = ccui.Helper:seekWidgetByName(root, "Panel_2")
    if panel == nil then
        panel = ccui.Helper:seekWidgetByName(root, "Panel_2_xr1")
    end
    if panel == nil or panel:isVisible() == false then
        return nil
    end
    local boton = ccui.Helper:seekWidgetByName(panel, "Button_1")
    if boton == nil or boton:isVisible() == false then
        return nil
    end
    local tam = boton:getContentSize()
    local a = boton:convertToWorldSpace(cc.p(0, 0))
    local b = boton:convertToWorldSpace(cc.p(tam.width, tam.height))
    return {
        izq = math.min(a.x, b.x), der = math.max(a.x, b.x),
        abajo = math.min(a.y, b.y), arriba = math.max(a.y, b.y),
    }
end

-- 初始化每行最大容纳数量
function Home:initMaxColumnNums()
    if __lua_project_id == __lua_project_l_digital then
        self.rowMaxIconNums = dms.int(dms["activity_config"], 100, activity_config.param)
    else
        self.rowMaxIconNums = 10
    end
end

-- 首冲重塑挂载处理
function Home:addFirstRecharge(iconCell)
    local root = self.roots[1]
    local Panel_first_recharge = ccui.Helper:seekWidgetByName(root, "Panel_first_recharge")
    if Panel_first_recharge ~= nil then 
        Panel_first_recharge:setVisible(false)
        Panel_first_recharge:removeAllChildren(true)
        if iconCell ~= nil then 
            Panel_first_recharge:setVisible(true)
            Panel_first_recharge:addChild(iconCell)
        end
    else
        if iconCell ~= nil then 
            self:addActivityIconIntoGroup({iconCell = iconCell, lineType = self.enumLineType.FIRSTLINE})
        end
    end
end


function Home:onEnterTransitionFinish()
    local csbHome = csb.createNode("home/home_button.csb")
    local root = csbHome:getChildByName("root")
    table.insert(self.roots, root)
    local action = csb.createTimeline("home/home_button.csb")
    csbHome:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
	-- action:play("Panel_button_1_tonch", false)
	self.action = action
    self:addChild(csbHome)


    if __lua_project_id == __lua_project_adventure then
        -- 讨论区
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_taolunqu"),       nil, 
        {
            terminal_name = "home_adventure_forum",
            current_button_name = "Button_taolunqu",        
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
        if zstring.tonumber(_game_platform_version_type) == 3 then
            if zstring.tonumber(_ED.server_review) == 0 then  -- 0 
                ccui.Helper:seekWidgetByName(root, "Button_fanpage"):setVisible(true)
            else
                ccui.Helper:seekWidgetByName(root, "Button_fanpage"):setVisible(false)
            end
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fanpage"),       nil, 
            {
                terminal_name = "home_adventure_fanpage",
                current_button_name = "Button_fanpage",        
                terminal_state = 0, 
                isPressedActionEnabled = true
            }, 
            nil, 0)
        end
        

        -- 礼包
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_libao"),       nil, 
        {
            terminal_name = "home_adventure_gift_bag",
            current_button_name = "Button_libao",        
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)

        -- 好友
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_haoyou"),       nil, 
        {
            terminal_name = "home_adventure_friends",
            current_button_name = "Button_haoyou",        
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
        if __lua_project_id == __lua_project_adventure then
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_adventure_home_friend",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_haoyou"),
                _invoke = nil,
                _interval = 0.5,})
        end

        -- 设置
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shezhi"),       nil, 
        {
            terminal_name = "home_adventure_system_set",
            current_button_name = "Button_shezhi",        
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)

        -- 商店
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shangdian"),       nil, 
        {
            terminal_name = "home_adventure_shop",
            current_button_name = "Button_shangdian",        
            terminal_state = 0, 
            isPressedActionEnabled = true
			
        }, 
        nil, 0)
		
		 -- 更多
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_more"),       nil, 
        {
            terminal_name = "home_adventure_more_system",
            current_button_name = "Button_more",        
            terminal_state = 0, 
            isPressedActionEnabled = true
			
        }, 
        nil, 0)
		
		if __lua_project_id == __lua_project_adventure then
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_adventure_more",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_more"),
                _invoke = nil,
                _interval = 0.5,})
		end

        -- 签到
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qiandao"),       nil, 
        {
            terminal_name = "home_adventure_sign_in",
            current_button_name = "Button_qiandao",        
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)

        -- 月卡
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yueka"),       nil, 
        {
            terminal_name = "home_adventure_month_card",
            current_button_name = "Button_yueka",        
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
		if __lua_project_id == __lua_project_adventure then
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_adventure_home_mothcard",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_yueka"),
                _invoke = nil,
                _interval = 0.5,})
		end
		
        -- 活动
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_huodong"),       nil, 
        {
            terminal_name = "home_adventure_activity",
            current_button_name = "Button_huodong",        
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
		if __lua_project_id == __lua_project_adventure then
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_adventure_achievement_activity",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_huodong"),
                _invoke = nil,
				_current_type = -1,
                _interval = 0.5,})
		end
		
        -- 成就
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chengjiu"),       nil, 
        {
            terminal_name = "home_adventure_achievement",
            current_button_name = "Button_chengjiu",        
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
        if __lua_project_id == __lua_project_adventure then
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_adventure_achievement_update",
             _widget =ccui.Helper:seekWidgetByName(root, "Button_chengjiu"),
             _invoke = nil,
             _current_type = -1,
             _interval = 0.5,})
        end

        -- 黑市
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_heishi"),       nil, 
        {
            terminal_name = "home_adventure_black_market",
            current_button_name = "Button_heishi",        
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)

        -- 公告
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gonggao"),       nil, 
        {
            terminal_name = "home_adventure_notice",
            current_button_name = "Button_gonggao",        
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)

        -- 开始冒险
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_start"),       nil, 
        {
            terminal_name = "menu_manager",     
            next_terminal_name = "menu_adventure_avg", 
            current_button_name = "Button_maoxian",
            but_image = "Image_maoxian",         
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
		state_machine.excute("home_adventure_update_open_condition", 0, nil)
    else
        local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
        if Text_tip ~= nil then
            -- DSC重塑
            if __lua_project_id == __lua_project_l_digital then
                Text_tip:setVisible(false)
            else
                if home_duplicate_tips_info ~= nil then
                    local lastOpenNpc = 0
                    for k,v in pairs(_ED.npc_state) do
                        if tonumber(v) == 0 then
                            lastOpenNpc = k
                            break
                        end
                    end
                    for k,v in pairs(home_duplicate_tips_info) do
                        if tonumber(v[1]) > lastOpenNpc then
                            Text_tip:setString(v[2])
                            break
                        end
                    end
                end
            end

        end
        
        self:initMaxColumnNums()

    	self:upDataDraw()
    	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
    	or __lua_project_id == __lua_project_warship_girl_a 
    	or __lua_project_id == __lua_project_koone
    	then
    		self.AcitivityListTwo = ccui.Helper:seekWidgetByName(root, "ListView_1_2")
    	end
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_richang"),   nil, {terminal_name = "home_manager",   next_terminal_name = "home_click_daily_tasks",                      but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
    	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion"),    nil, {terminal_name = "home_manager",   next_terminal_name = "home_click_union",                            but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
        local Button_mingren = ccui.Helper:seekWidgetByName(root, "Button_mingren")
        --评审状态不显示排行榜
        if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto then 
            if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
                Button_mingren:setVisible(true)
            else
                Button_mingren:setVisible(false)
            end
        end

    	fwin:addTouchEventListener(Button_mingren,   nil, {terminal_name = "home_manager",   next_terminal_name = "home_click_fame_hall_manager",                but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mail"),      nil, {terminal_name = "home_manager",   next_terminal_name = "home_click_email_manager",                    but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_friends"),   nil, {terminal_name = "home_manager",   next_terminal_name = "home_click_friend_manager",                   but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gaizao"),    nil, {terminal_name = "home_manager",    next_terminal_name = "home_click_recover",                         but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wujiang"),             nil, {terminal_name = "home_manager",     next_terminal_name = "home_click_generals",             but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true, unload = true}, nil, 0)
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equipment"),           nil, {terminal_name = "home_manager",     next_terminal_name = "home_click_equipment",            but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true, unload = true}, nil, 0)
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_baowu"),               nil, {terminal_name = "home_manager",     next_terminal_name = "home_click_treasure",             but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true, unload = true}, nil, 0)
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chongzhi"),            nil, {terminal_name = "home_manager",     next_terminal_name = "home_click_recharge",             but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_vip"),                 nil, {terminal_name = "home_click_vip",     terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tujian"),              nil, {terminal_name = "home_click_CatalogueStorage", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_menu"),              nil, {terminal_name = "home_click_install",  terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat"),                nil, {terminal_name = "home_click_chat",  terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7day"),                nil, {terminal_name = "home_manager",     next_terminal_name = "home_click_sevendays_activity",   but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_huozhong"),            nil, {terminal_name = "home_goto_destiny_system", but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)

        -- 客服反馈入口
        local Button_gm_connect = ccui.Helper:seekWidgetByName(root, "Button_gm_connect")
        if Button_gm_connect then 
            Button_gm_connect:setVisible(true)
            fwin:addTouchEventListener(Button_gm_connect, nil, {terminal_name = "home_customer_server_open", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
        end

        -- 设置按钮
        local Button_set = ccui.Helper:seekWidgetByName(root, "Button_set")
        if Button_set then 
            fwin:addTouchEventListener(Button_set, nil, {terminal_name = "sm_chat_view_open_chat_set_window", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
        end

        if __lua_project_id == __lua_project_yugioh then 
            local wordTreePanel = ccui.Helper:seekWidgetByName(root, "Panel_huozhong")
            wordTreePanel:removeAllChildren(true)
            local animationName = "daiji"
            local jsonFile = "images/ui/effice/effect_ui_king/effect_ui_king.json"
            local atlasFile = "images/ui/effice/effect_ui_king/effect_ui_king.atlas"

            if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
                local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
                wordTreePanel:addChild(animation)
            end
            local animationName = "daiji"
            local jsonFile = "images/ui/effice/effect_ui_chouka/effect_ui_chouka.json"
            local atlasFile = "images/ui/effice/effect_ui_chouka/effect_ui_chouka.atlas"
            local chouKaPanel = ccui.Helper:seekWidgetByName(root, "Panel_ck")
            chouKaPanel:removeAllChildren(true)
            if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
                local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
                chouKaPanel:addChild(animation)
            end
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_chouka"),            nil, {terminal_name = "home_goto_click_recruit", but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)    
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_magic"),             nil, {terminal_name = "home_manager", next_terminal_name = "home_click_magic_card", but_image = "Image_home", terminal_state = 0, isPressedActionEnabled = true, unload = true}, nil, 0)

            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_new_recruit",
            _widget = ccui.Helper:seekWidgetByName(root, "Panel_chouka"),
            _invoke = nil,
            _interval = 0.5,})

            local Button_tujian = ccui.Helper:seekWidgetByName(root, "Button_tujian")
            if Button_tujian ~= nil then
                if tonumber(_ED.server_review) == 1 then
                    Button_tujian:setVisible(false)
                else
                    Button_tujian:setVisible(true)
                end
            end
            
        end
    	if __lua_project_id == __lua_project_gragon_tiger_gate
            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_red_alert then
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion"),            nil, {terminal_name = "home_goto_click_union", but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)    
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_secret"),            nil, {terminal_name = "home_capture_open", but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
        else
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion"),            nil, {terminal_name = "home_goto_click_union", but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
        end
        local facebookButton = ccui.Helper:seekWidgetByName(root, "Button_facebook")
        local kefuButton = ccui.Helper:seekWidgetByName(root, "Button_kefu")
        if facebookButton ~= nil then
            fwin:addTouchEventListener(facebookButton, nil, {terminal_name = "home_goto_click_faceBook_url", but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)    
        end
        if kefuButton ~= nil then
            fwin:addTouchEventListener(kefuButton, nil, {terminal_name = "home_goto_click_gm_url", but_image = "Image_home", terminal_state = 0, isPressedActionEnabled = true, unload = true}, nil, 0)
        end
        --战宠 数码
        local button_zc = ccui.Helper:seekWidgetByName(root, "Button_zc")
        if button_zc ~= nil then 
            fwin:addTouchEventListener(button_zc,             nil, {terminal_name = "home_click_pets", but_image = "Image_home", terminal_state = 0, isPressedActionEnabled = true, unload = true}, nil, 0)
        end

        --推荐阵容 数码
        local Button_line = ccui.Helper:seekWidgetByName(root, "Button_line")
        if Button_line ~= nil then 
            fwin:addTouchEventListener(Button_line,             nil, {terminal_name = "home_click_recommend_formation", but_image = "Image_home", terminal_state = 0, isPressedActionEnabled = true, unload = true}, nil, 0)
        end
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shenjiang2"),          nil, {terminal_name = "home_manager",     next_terminal_name = "home_click_hero_shop",            but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
		-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shenjiang_3"),          nil, {terminal_name = "home_manager",     next_terminal_name = "home_click_hero_shop",            but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
        -- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_click_hero_shop",
            -- _widget = ccui.Helper:seekWidgetByName(root, "Button_shenjiang_3"),
            -- _invoke = nil,
            -- _interval = 0.5,})
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then

        elseif __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_red_alert then
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_capture",
            _widget = ccui.Helper:seekWidgetByName(root, "Button_secret"),
            _invoke = nil,
            _interval = 0.5,})            
        end
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_exciting_activities"), nil, {terminal_name = "home_manager",     next_terminal_name = "home_click_activity",             but_image = "Image_home",       terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge"), nil, {terminal_name = "home_recharge_activity",terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gonglue"), nil, {terminal_name = "home_click_strategy",   terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
		
    	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
            if zstring.tonumber(_ED.user_info.user_force) == 0
				and missionIsOver() == true 
				then
                app.load("configs.csb.config")
                if  __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                else
                    state_machine.excute("camp_chose_window_open",0,"")
                end
            end
            app.load("client.mission.newfunopen.NewFunctionOpen")
            -- state_machine.excute("new_function_open",0,16)
            fwin:addService({
                callback = function ( params )
                    if missionIsOver() == true and params.showFinder ~= nil then
                        if tonumber(_ED.user_info.user_grade) < 10 then
                            params:showFinder()
                        end
                    end
                end,
                delay = 0.5,
                params = self
            })
            local Panel_beizhanling = ccui.Helper:seekWidgetByName(root,"Panel_beizhanling")
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_capture_shine",
            _widget = Panel_beizhanling,
            _invoke = nil,
            _interval = 0.5,})
            
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            else
                local Panel_kezhanling = ccui.Helper:seekWidgetByName(root,"Panel_kezhanling")
                state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_capture_can_attack_shine",
                _widget = Panel_kezhanling,
                _invoke = nil,
                _interval = 0.5,})
            end
                        
    		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_warehouse"), 	nil, 
    		{
    			terminal_name = "home_click_package", 	
    			terminal_state = 0, 
    			isPressedActionEnabled = true
    		}, 
            nil, 0)
            
            local Image_clock = ccui.Helper:seekWidgetByName(root, "Image_clock")
            if Image_clock ~= nil then
                Image_clock:setVisible(false)
            end
            
            --装备碎片丢到包裹里了，所以包裹按钮 加上装备合成的推送
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_equipment_warehouse_all",
            _widget = ccui.Helper:seekWidgetByName(root, "Button_warehouse"),
            _invoke = nil,
            _interval = 0.5,})
    		
    		--商城
    		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shop_0"), 		nil, 
    		{
    			terminal_name = "menu_manager", 	
    			next_terminal_name = "menu_show_shop", 			
    			current_button_name = "Button_shop_0", 		
    			but_image = "Image_shop", 		
    			terminal_state = 0,
                shop_type = "shop",
    			isPressedActionEnabled = true
    		}, 
    		nil, 0)
    		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_new_shop",
    		_widget = ccui.Helper:seekWidgetByName(root, "Button_shop_0"),
    		_invoke = nil,
    		_interval = 0.5,})
    		
            local Panel_zhaomu = ccui.Helper:seekWidgetByName(root, "Panel_zhaomu")
            if Panel_zhaomu ~= nil then
                local ArmatureNode_zhaomu = Panel_zhaomu:getChildByName("ArmatureNode_zhaomu")
                if ArmatureNode_zhaomu ~= nil then
                    ccui.Helper:seekWidgetByName(root, "Button_zhaomu").Armature = ArmatureNode_zhaomu
                    ccui.Helper:seekWidgetByName(root, "Button_zhaomu").zhaomu = Panel_zhaomu
                    
                end
            end

            --招募
            local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.NewRecruit)
            if fun_is_open == true then
                fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhaomu"),         nil, 
                {
                    terminal_name = "home_new_recruit_main",
                    terminal_state = 0,
                    isPressedActionEnabled = true,
                }, 
                nil, 0)
                
                state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_new_recruit_system",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_zhaomu"),
                _invoke = nil,
                _interval = 0.5,})
            else
                fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhaomu"),         nil, 
                {
                    terminal_name = "menu_manager",     
                    next_terminal_name = "menu_show_shop",          
                    current_button_name = "Button_zhaomu",
                    but_image = "Image_shop",       
                    terminal_state = 0,
                    shop_type = "zhaomu",
                    isPressedActionEnabled = true
                }, 
                nil, 0)
                
                state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_new_recruit",
                _widget = ccui.Helper:seekWidgetByName(root, "Button_zhaomu"),
                _invoke = nil,
                _interval = 0.5,})
            end


    		--阵容
    		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_line_0"), 	nil, 
    		{
    			terminal_name = "menu_manager", 	
    			next_terminal_name = "menu_show_formation", 	
    			current_button_name = "Button_line_0", 	
    			but_image = "Image_line-uo", 	
    			_touch_type = "menu",
    			terminal_state = 0, 
    			isPressedActionEnabled = true
    		}, 
    		nil, 0)
    		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_all",
    			_widget = ccui.Helper:seekWidgetByName(root, "Button_line_0"),
    			_invoke = nil,
    			_interval = 0.5,})	
            
            -- 副本
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_duplicate"),  nil, 
            {
                terminal_name = "menu_manager",     
                next_terminal_name = "menu_show_duplicate",     
                current_button_name = "Button_duplicate",   
                but_image = "Image_duplicate",  
                terminal_state = 0, 
                isPressedActionEnabled = true
            }, 
            nil, 0)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            else
                state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_battle_all",
                    _widget = ccui.Helper:seekWidgetByName(root, "Button_duplicate"),
                    _invoke = nil,
                    _interval = 0.5,})
            end  

    		--征战
    		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lilian_0"), 	nil, 
    		{
    			terminal_name = "menu_manager", 	
    			next_terminal_name = "menu_show_campaign", 		
    			current_button_name = "Button_lilian_0", 		
    			but_image = "Image_activity",	
    			terminal_state = 0, 
    			isPressedActionEnabled = true
    		}, 
    		nil, 0)
    		_ED._is_recharge_push_expedition = false
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_arena_all",
                    _widget = ccui.Helper:seekWidgetByName(root, "Button_lilian_0"),
                    _invoke = nil,
                    _interval = 0.5,})
            else
        		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_all",
        			_widget = ccui.Helper:seekWidgetByName(root, "Button_lilian_0"),
        			_invoke = nil,
        			_interval = 0.5,})
            end	

            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then   -- 1评审, 其他非
                fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lilian_0"),   nil, 
                {
                    terminal_name = "Button_lilian_campaign_show",          
                    but_image = "Image_activity",  
                    terminal_state = 0,
                    isPressedActionEnabled = true
                }, 
                nil, 0)
            end

            --偷师学艺
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_home_skills"),  nil, 
            {
                terminal_name = "menu_manager",     
                next_terminal_name = "menu_show_skills_school",      
                current_button_name = "Button_home_skills",        
                but_image = "",   
                terminal_state = 0, 
                isPressedActionEnabled = true
            }, 
            nil, 0)
            -- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_learing",
            -- _widget = ccui.Helper:seekWidgetByName(root, "Button_home_skills"),
            -- _invoke = nil,
            -- _interval = 0.5,})            
            
            --等级奖励
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_level_pack"),  nil, 
            {
                terminal_name = "menu_manager",     
                next_terminal_name = "menu_show_level_packs",      
                current_button_name = "Button_level_pack",        
                but_image = "",   
                terminal_state = 0, 
                isPressedActionEnabled = true
            }, 
            nil, 0)
            state_machine.excute("home_check_level_packs",0,"")
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_level_packs",
            _widget = ccui.Helper:seekWidgetByName(root, "Button_level_pack"),
            _invoke = nil,
            _interval = 0.5,})
              
    	end

        -- 数码冒险入口
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jjc"),  nil, 
        {
            terminal_name = "explore_window_open",
            terminal_state = 0, 
            isPressedActionEnabled = true,
            app.load("client.l_digital.explore.ExploreWindow")
        }, 
        nil, 0)

        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_special_duplicate_all",
            _widget = ccui.Helper:seekWidgetByName(root, "Button_jjc"),
            _invoke = nil,
            _interval = 0.5,})
        end
    	
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_mall_all",
    	_widget = ccui.Helper:seekWidgetByName(root, "Button_mail"),
    	_invoke = nil,
    	_interval = 0.5,})
    	
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_friend_all",
    	_widget = ccui.Helper:seekWidgetByName(root, "Button_friends"),
    	_invoke = nil,
    	_interval = 0.5,})
    	
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_ship_warehouse_all",
    	_widget = ccui.Helper:seekWidgetByName(root, "Button_wujiang"),
    	_invoke = nil,
    	_interval = 0.5,})
		
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_equipment_warehouse_all",
    	_widget = ccui.Helper:seekWidgetByName(root, "Button_equipment"),
    	_invoke = nil,
    	_interval = 0.5,})
		
    	
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_recovery_all",
    	_widget = ccui.Helper:seekWidgetByName(root, "Button_gaizao"),
    	_invoke = nil,
    	_interval = 0.5,})
    	
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_military_rank_all",
    	_widget = ccui.Helper:seekWidgetByName(root, "Button_huozhong"),
    	_invoke = nil,
    	_interval = 0.5,})
    	
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_click_hero_shop",
    	_widget = ccui.Helper:seekWidgetByName(root, "Button_shenjiang2"),
    	_invoke = nil,
    	_interval = 0.5,})
    	
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_chat_all",
    	_widget = ccui.Helper:seekWidgetByName(root, "Button_chat"),
    	_invoke = nil,
    	_interval = 0.5,})
    	
    	local hideUserInfo = false
    	if __lua_project_id == __lua_project_gragon_tiger_gate
            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
            if self._needOpenHomeHero == false then
    			fwin:open(HomeHero:new():init(), fwin._background)
    		else
    			local home_hero_wnd = HomeHero:new()
    			fwin:open(home_hero_wnd:init(home_hero_wnd._enum_window_type._FORMATION), fwin._background)
    			
    			state_machine.excute("home_hide_event", 0, "home_hide_event.")
    			hideUserInfo = true
            end
            fwin:open(UserInformation:new(), fwin._frameview)
    	else
    		fwin:open(HomeHero:new():init(), fwin._background)
        
            fwin:open(UserInformation:new(), fwin._background)
    	end
    	
    	if hideUserInfo == true then 
    		state_machine.excute("user_information_hide_event", 0, "user_information_hide_event.")
    	end

        

        -- 数码冒险入口
        local Button_sign = ccui.Helper:seekWidgetByName(root, "Button_sign")
        if Button_sign ~= nil then
            fwin:addTouchEventListener(Button_sign,  nil, 
            {
                terminal_name = "sm_check_in_info_window_window_open",
                terminal_state = 0, 
                isPressedActionEnabled = true,
                app.load("client.l_digital.activity.wonderful.SmCheckInInfoWindow")
            }, 
            nil, 0)

            state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_every_day_sign_all",
            _widget = Button_sign,
            _invoke = nil,
            _interval = 0.5,})
        end

        -- if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
                -- or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
        --     local _level = dms.string(dms["fun_open_condition"],51, fun_open_condition.level)
        --     if tonumber(_ED.user_info.user_grade) >= tonumber(_level) then
        --         state_machine.excute("chat_show_self",0,"")
        --     end
        -- end
    	if __lua_project_id == __lua_project_gragon_tiger_gate
            or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
            or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_red_alert then
            local action = csb.createTimeline("home/home_button.csb")
            table.insert(self.actions,action)
            csbHome:runAction(action)
            local _level = dms.string(dms["fun_open_condition"],71, fun_open_condition.level) 
            if tonumber(_ED.user_info.user_grade) >= tonumber(_level) then
                state_machine.excute("chat_show_self",0,"")
            end
                
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_913"), nil, 
            {
                terminal_name = "home_more_setting_update", 
                next_terminal_name = "", 
                but_image = "", 
                terminal_state = 0, 
                cell = self,
                status = false,
                isPressedActionEnabled = true
            }, 
            nil, 0)

            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_103"), nil, 
            {
                terminal_name = "home_more_setting_update", 
                next_terminal_name = "", 
                but_image = "", 
                terminal_state = 0, 
                cell = self,
                status = true,
                isPressedActionEnabled = true
            }, 
            nil, 0)
        else
        	local status = false
        	local function onOpenTouchEvent(sender, eventType)
        		if eventType == ccui.TouchEventType.began then
        			playEffect(formatMusicFile("button", 1))
        		elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
        		
        			if status == false then
        				action:play("Panel_126_tonch", false)
        				ccui.Helper:seekWidgetByName(root, "Panel_103"):setVisible(true)
        				status = true
        			elseif status == true then
        				action:play("Panel_126_untonch", false)
        				status = false
        				ccui.Helper:seekWidgetByName(root, "Panel_103"):setVisible(false)
        			end
        		end
        	end
        	local button_01 = ccui.Helper:seekWidgetByName(root, "Button_913")
        	button_01:addTouchEventListener(onOpenTouchEvent)
        	button_01:setPressedActionEnabled(true)
        	ccui.Helper:seekWidgetByName(root, "Panel_103"):addTouchEventListener(onOpenTouchEvent)
        end
    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_home_expand",
    	_widget = ccui.Helper:seekWidgetByName(root, "Button_913"),
    	_invoke = nil,
    	_interval = 0.5,})
    	
    	state_machine.excute("platform_get_pay_info", 0, "platform_get_pay_info.")
		if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			local buttonFb = ccui.Helper:seekWidgetByName(root, "Button_fb")
			if buttonFb ~= nil then
				if zstring.tonumber(_ED.server_review) == 0 then
					buttonFb:setVisible(true)
					local statusFB = false
					local function onOpenFBTouchEvent(sender, eventType)
						if eventType == ccui.TouchEventType.began then
							playEffect(formatMusicFile("button", 1))
						elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
							if statusFB == false then
								action:play("Panel_127_tonch", false)
								ccui.Helper:seekWidgetByName(root, "Panel_127"):setVisible(true)
								statusFB = true
							elseif statusFB == true then
								action:play("Panel_127_untonch", false)
								statusFB = false
								ccui.Helper:seekWidgetByName(root, "Panel_127"):setVisible(false)
							end
						end
					end
					buttonFb:addTouchEventListener(onOpenFBTouchEvent)
					buttonFb:setPressedActionEnabled(true)
				else
					buttonFb:setVisible(false)
				end
				local Button_fans = ccui.Helper:seekWidgetByName(root, "Button_fans") --粉丝页
				local Button_share = ccui.Helper:seekWidgetByName(root, "Button_share") --分享
				if Button_fans~=nil then
					local function onOpenFBFansEvent(sender, eventType)
						if eventType == ccui.TouchEventType.began then
							playEffect(formatMusicFile("button", 1))
						elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
							state_machine.excute("platform_the_open_fans_page", 0, "platform_the_open_fans_page.")
						end
					end

					Button_fans:addTouchEventListener(onOpenFBFansEvent)
					Button_fans:setPressedActionEnabled(true)
				end
				if Button_share~=nil then
					local function onOpenFBShareEvent(sender, eventType)
						if eventType == ccui.TouchEventType.began then
							playEffect(formatMusicFile("button", 1))
						elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
							state_machine.excute("platform_the_request_share", 0, "platform_the_request_share.")  --  分享ID
						end
					end
					Button_share:addTouchEventListener(onOpenFBShareEvent)
					Button_share:setPressedActionEnabled(true)
				end
			end
		end
    	
    	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
    		local status = false
    		local function onOpenTouchEvent(sender, eventType)
    			if eventType == ccui.TouchEventType.began then
    				playEffect(formatMusicFile("button", 1))
    			elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
    			
    				if status == false then
    					action:play("Button_add_touch", false)
    					status = true
    				elseif status == true then
    					action:play("Button_add_untouch", false)
    					status = false
    				end
    			end
    		end
    		-- local button_01 = ccui.Helper:seekWidgetByName(root, "Button_add")
    		-- button_01:addTouchEventListener(onOpenTouchEvent)
    		-- button_01:setPressedActionEnabled(true)
    	
    	end
        if __lua_project_id ==__lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital  or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece  or __lua_project_id == __lua_project_red_alert then
            if ___is_open_push_info ~= false then
                app.load("client.home.WarshipGirlPushInfo")
                state_machine.excute("warship_girl_push_info_open",0,{_datas={_openType=0}})
            end
        end
    end
    --每日登陆奖励
    local Panel_online_reward = ccui.Helper:seekWidgetByName(root, "Panel_online_reward")
    -- Local port: keep the incomplete online gift and its separate Spine
    -- background hidden until its rewards and rendering are implemented.
    self._localOnlineGiftHidden = true
    self.everyDayOnlinePanel = nil
    for _, name in ipairs({"Panel_online_reward", "Panel_bgdh", "Panel_tjhl"}) do
        local panel = ccui.Helper:seekWidgetByName(root, name)
        if panel then
            fwin:removeTouchEventListener(panel)
            if panel.animation then
                panel.animation:removeFromParent(true)
                panel.animation = nil
            end
            panel:setVisible(false)
            panel:setTouchEnabled(false)
        end
    end
    if Panel_online_reward ~= nil and not self._localOnlineGiftHidden then
        local Panel_bgdh = ccui.Helper:seekWidgetByName(root, "Panel_bgdh")
        if Panel_bgdh.animation ~= nil then
            Panel_bgdh.animation:removeFromParent(true)
        end
        local jsonFile = "sprite/sprite_tianjianghaoli.json"
        local atlasFile = "sprite/sprite_tianjianghaoli.atlas"
        Panel_bgdh.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_bgdh:addChild(Panel_bgdh.animation)

        local Panel_tjhl = ccui.Helper:seekWidgetByName(root, "Panel_tjhl")
        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital and Panel_tjhl and true == cc.FileUtils:getInstance():isFileExist("images/ui/effice/effice_tjhl_box/effect_tjhl_box.json") then
            if Panel_tjhl.animation ~= nil then
                Panel_tjhl.animation:removeFromParent(true)
            end
            local jsonFileTwo = "images/ui/effice/effice_tjhl_box/effect_tjhl_box.json"
            local atlasFileTwo = "images/ui/effice/effice_tjhl_box/effect_tjhl_box.atlas"
            Panel_tjhl.animation = sp.spine(jsonFileTwo, atlasFileTwo, 1, 0, "animation", true, nil)
            Panel_tjhl:addChild(Panel_tjhl.animation)
        end

        Panel_online_reward:setVisible(false)
        if false == funOpenDrawTip(162, false) then
            self.everyDayOnlinePanel = Panel_online_reward
        end
        fwin:addTouchEventListener(Panel_online_reward,  nil, 
        {
            terminal_name = "sm_open_every_day_online_reward",   
            terminal_state = 0, 
        }, 
        nil, 0)
        -- iphone刘海适配
        if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and isIphoneX() then 
            if Panel_online_reward then 
                Panel_online_reward:setPositionX(Panel_online_reward:getPositionX()+80)
            end
        end
    end
    self.Panel_hd_tuisong = ccui.Helper:seekWidgetByName(root, "Panel_hd_tuisong")
    -- iphone刘海适配
    if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and isIphoneX() then 
        if self.Panel_hd_tuisong then 
            self.Panel_hd_tuisong:setPositionX(self.Panel_hd_tuisong:getPositionX()+80)
        end
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        self:modelOpenPush()
        fwin:addService({
            callback = function ( params )
                params:initShowHomeActivityInfo()
            end,
            delay = 0.5,
            params = self
        })
        app.load("client.l_digital.cultivate.SmCultivateWindow")
        --临时隐藏
        -- ccui.Helper:seekWidgetByName(root, "Button_yangcheng"):setVisible(false)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yangcheng"), nil, 
        {
            terminal_name = "sm_cultivate_window_open", 
            status = false,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_cultivate",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_yangcheng"),
        _invoke = nil,
        _interval = 0.5,})
        -- local Panel_fomation_role = ccui.Helper:seekWidgetByName(root, "Panel_fomation_role")
        -- if Panel_fomation_role ~= nil then
        --     Panel_fomation_role:removeAllChildren(true)

        --     local formetion_index = 1
        --     local ships = nil
        --     for i,v in pairs(_ED.user_formetion_status) do
        --         if _ED.user_ship[""..v] ~= nil then
        --             formetion_index = i
        --             ships = _ED.user_ship[""..v]
        --             break
        --         end
        --     end

        --     if ships ~= nil then
        --         local _ship_mould_id = ships.ship_template_id
        --         local temp_bust_index = 0
        --         ----------------------新的数码的形象------------------------
        --         --进化形象
        --         local evo_image = dms.string(dms["ship_mould"], _ship_mould_id, ship_mould.fitSkillTwo)
        --         local evo_info = zstring.split(evo_image, ",")
        --         --进化模板id
        --         local ship_evo = zstring.split(ships.evolution_status, "|")
        --         local evo_mould_id = evo_info[tonumber(ship_evo[1])]
        --         --新的形象编号
        --         temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

        --         draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_fomation_role, nil, nil, cc.p(0.5, 0))
        --         app.load("client.battle.fight.FightEnum")
        --         local shipSpine = sp.spine_sprite(Panel_fomation_role, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))

        --         fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_fomation_role"),   nil, 
        --         {
        --             terminal_name = "home_hero_into_formation_page",    
        --             terminal_state = 0, 
        --             _heroInstance = ships,
        --             _formetion_index = formetion_index,
        --             isPressedActionEnabled = true
        --         }, 
        --         nil, 0)
        --         state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_hero_develop_home_hero_icon",
        --         _widget = Panel_fomation_role,
        --         _invoke = nil,
        --         _interval = 0.5,})
        --     end   
        -- end   

        local Button_zhankai = ccui.Helper:seekWidgetByName(root, "Button_zhankai")
        if Button_zhankai ~= nil then
            Button_zhankai:setVisible(false)
            fwin:addTouchEventListener(Button_zhankai,   nil, 
            {
                terminal_name = "sm_model_open_the_animation",    
                terminal_state = 0, 
            }, 
            nil, 0)
        end

        local Button_guanbi = ccui.Helper:seekWidgetByName(root, "Button_guanbi")
        if Button_guanbi ~= nil then
            Button_guanbi:setVisible(true)
            fwin:addTouchEventListener(Button_guanbi,   nil, 
            {
                terminal_name = "sm_model_close_the_animation",    
                terminal_state = 0, 
            }, 
            nil, 0)
        end

        local Button_1 = ccui.Helper:seekWidgetByName(root, "Button_1")
        if Button_1 ~= nil then
            fwin:addTouchEventListener(Button_1,   nil, 
            {
                terminal_name = "target_task_window_open",    
                terminal_state = 0, 
            }, 
            nil, 0)
        end

        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        else
            state_machine.excute("sm_model_open_the_animation", 0, nil)
        end

        -- TODO 减少进入游戏前端向后端请求的次数
        -- 数码获取黑名单数据
        -- NetworkManager:register(protocol_command.friend_update.code, nil, nil, nil, nil, nil, false, nil)

        state_machine.excute("sm_home_update_activity_push_state", 0, "")

        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            --商店红点定时刷新
            self:shopUpdateTimes()
            self:updateTargetTaskState()
        end
    end
    -- iphone刘海适配
    local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Panel_2")
    local Panel_zuo = ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Panel_zuo")
    if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and isIphoneX() then 
        if Panel_2 then 
            Panel_2:setPositionX(Panel_2:getPositionX()+80)
        end
        if Panel_zuo then 
            Panel_zuo:setPositionX(Panel_zuo:getPositionX()+80)
        end
    end

    -- DSC重塑，主页活动图标List收放按钮
    if __lua_project_id == __lua_project_l_digital then
        local Button_more_2pai = ccui.Helper:seekWidgetByName(root, "Button_more_2pai")
        if Button_more_2pai ~= nil then
            Button_more_2pai:setVisible(true)
            fwin:addTouchEventListener(Button_more_2pai, nil, 
            {
                terminal_name = "home_activity_listview_control_open_and_shrink",    
                terminal_state = 0, 
                isPressedActionEnabled = true,
            }, 
            nil, 0)
        end
    end

    -- 添加主城雪花效果
    local Panel_effice_piaoluo = ccui.Helper:seekWidgetByName(root, "Panel_effice_piaoluo")
    if Panel_effice_piaoluo then Panel_effice_piaoluo:setVisible(false) end
    if false and Panel_effice_piaoluo then -- Desktop: seasonal falling flakes disabled.
        Panel_effice_piaoluo:removeAllChildren(true)
        Panel_effice_piaoluo:setVisible(true)
        local jsonFileTwo = "images/ui/effice/effect_zhuchenggx4/effect_zhuchenggx4.json"
        local atlasFileTwo = "images/ui/effice/effect_zhuchenggx4/effect_zhuchenggx4.atlas"
        local spineNode = sp.spine(jsonFileTwo, atlasFileTwo, 1, 0, "animation", true, nil)
        Panel_effice_piaoluo:addChild(spineNode)
    end
end

function Home:shopUpdateTimes()
    local server_time = getCurrentGTM8Time()
    local currTimes = server_time.hour * 3600 + server_time.min * 60 + server_time.sec
    local refresh_times = zstring.split(dms.string(dms["shop_config"], 1, shop_config.param) , ",")
    local nextReresh = 0
    local currhour = server_time.hour
    for i , v in pairs(refresh_times) do
        local _hour = tonumber(zstring.split(v , ":")[1])
        if tonumber(currhour) <= _hour then
            --找到下个时间点
            nextReresh = _hour
            break
        end
    end
    if nextReresh ~= 0 then
        if nextReresh*3600 - currTimes > 10 then
            self:runAction(cc.Sequence:create({cc.DelayTime:create(nextReresh*3600 - currTimes), cc.CallFunc:create(function ( sender )
                state_machine.excute("notification_center_update", 0, "push_notification_center_new_shop") 
                self:shopUpdateTimes()
            end)}))
        end
    end
end

--功能开启提示
function Home:modelOpenPush()
    local root = self.roots[1]
    
    local Panel_fun_open = ccui.Helper:seekWidgetByName(root, "Panel_fun_open")
    if Panel_fun_open == nil then
        Panel_fun_open = ccui.Helper:seekWidgetByName(root, "Panel_fun_open_xr1")
    end

    local currId = dms.int(dms["user_experience_param"] ,tonumber(_ED.user_info.user_grade) ,user_experience_param.open_push_index)
    if currId == -1 then
        Panel_fun_open:setVisible(false)
        return
    end
    Panel_fun_open:setVisible(true)
    --图标
    local Panel_fun_icon = ccui.Helper:seekWidgetByName(root, "Panel_fun_icon")
    Panel_fun_icon:removeAllChildren(true)
    Panel_fun_icon:setBackGroundImage(string.format("images/ui/text/XTZY/fun_icon_%d.png",currId))
    --文字
    local Panel_fun_text = ccui.Helper:seekWidgetByName(root, "Panel_fun_text")
    Panel_fun_text:removeAllChildren(true)
    Panel_fun_text:setBackGroundImage(string.format("images/ui/text/XTZY/fun_text_%d.png",currId))
    --开启等级
    local BitmapFontLabel_fun_open_lv = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_fun_open_lv")
    BitmapFontLabel_fun_open_lv:setString(_model_open_push_tip[currId][1])
    fwin:addTouchEventListener(Panel_fun_open,  nil, 
    {
        terminal_name = "sm_model_open_push_scan",
        shortCut = currId,  
        terminal_state = 0, 
    }, 
    nil, 0)

     -- iphone刘海适配
     if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and isIphoneX() then 
        if Panel_fun_open then 
            Panel_fun_open:setPositionX(Panel_fun_open:getPositionX()+80)
        end
    end
    local Image_funopen_tip = ccui.Helper:seekWidgetByName(root, "Image_funopen_tip")
    if Image_funopen_tip ~= nil then
        if _ED.system_fun_open_event == nil or _ED.system_fun_open_event < 0 then
            --没有打开，需要红点推送
            Image_funopen_tip:setVisible(true)
        end
    end
end

function Home:updateHomeAcivityPushUIInfo( currId, isAllShow )
    local isOpend = false
    for k,v in pairs(_ED.home_activity_push_info) do
        if v ~= nil and v.isHaveOpen == true then
            isOpend = true
            break
        end
    end
    if isOpend == true then
        _ED.home_activity_push_info[currId].isWaitOpen = true
        _ED.home_activity_push_info[currId].isHaveOpen = false
        _ED.home_activity_push_info[currId].isAllShow = isAllShow
        return
    end
    _ED.home_activity_push_info[currId].isHaveOpen = true
    _ED.home_activity_push_info[currId].isWaitOpen = false
    _ED.home_activity_push_info[currId].isAllShow = isAllShow
    local root = self.roots[1]
    if root == nil then
        return
    end
    local Panel_hd_tuisong = ccui.Helper:seekWidgetByName(root, "Panel_hd_tuisong")
    if Panel_hd_tuisong == nil then
        return
    end
    local Panel_hd_tuisong = ccui.Helper:seekWidgetByName(root, "Panel_hd_tuisong")
    Panel_hd_tuisong:setVisible(true)
    local Panel_tsdh = ccui.Helper:seekWidgetByName(root, "Panel_tsdh")
    if Panel_tsdh.animation ~= nil then
        Panel_tsdh.animation:removeFromParent(true)
    end
    local jsonFile = "sprite/sprite_gongnengtuisong.json"
    local atlasFile = "sprite/sprite_gongnengtuisong.atlas"
    Panel_tsdh.animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    Panel_tsdh:addChild(Panel_tsdh.animation)

    --参加
    local Image_zt_1 = ccui.Helper:seekWidgetByName(root, "Image_zt_1")
    --进行
    local Image_zt_2 = ccui.Helper:seekWidgetByName(root, "Image_zt_2")
    Image_zt_1:setVisible(false)
    Image_zt_2:setVisible(false)
    Image_zt_1:setVisible(true)
    --标题
    local Panel_ts_text = ccui.Helper:seekWidgetByName(root, "Panel_ts_text")
    Panel_ts_text:removeAllChildren(true)
    Panel_ts_text:setBackGroundImage(string.format("images/ui/text/XTKF_res/ts_text_%d.png", currId))
    --图标
    local Panel_ts_icon = ccui.Helper:seekWidgetByName(root, "Panel_ts_icon")
    Panel_ts_icon:removeAllChildren(true)
    Panel_ts_icon:setBackGroundImage(string.format("images/ui/text/XTKF_res/ts_icon_%d.png", currId))
    fwin:removeTouchEventListener(Panel_hd_tuisong)
    fwin:addTouchEventListener(Panel_hd_tuisong,  nil, 
    {
        terminal_name = "sm_model_join_push_goto_join",
        shortCut = currId,  
        terminal_state = 0, 
    }, 
    nil, 0)
end

function Home:initShowHomeActivityInfo( ... )
    if _ED.home_activity_push_info == nil then
        _ED.home_activity_push_info = {}
    end
    if home_activity_push_times_info ~= nil then
        local server_time = getCurrentGTM8Time()
        for k,v in pairs(home_activity_push_times_info) do
            local openInfo = _ED.home_activity_push_info[k]
            if openInfo == nil then
                openInfo = {isHaveOpen = false, isWaitOpen = false, isAllShow = false}
            end
            _ED.home_activity_push_info[k] = openInfo
            if (openInfo.isHaveOpen == false and openInfo.isWaitOpen == false) or openInfo.isAllShow == true then
                if funOpenDrawTip(v[1], false) == false then
                    local isOpened = false
                    if k == 1 then
                        isOpened = _ED.union_red_envelopes_open
                    elseif k == 2 then
                        isOpened = _ED.union.union_fight_battle_info ~= nil and zstring.tonumber(_ED.union.union_fight_battle_info.state) >= 1
                    elseif k == 3 then
                        isOpened = true
                    elseif k == 4 then
                        isOpened = true
                    end
                    if isOpened == true then
                        if k == 1 then
                            self:updateHomeAcivityPushUIInfo(k, false)
                        elseif k == 2 then
                            local beginTime = v[2][1]
                            local open_time = zstring.split(beginTime, ":")
                            local leave_time = (tonumber(open_time[1]) - server_time.hour) * 3600 + (tonumber(open_time[2]) - server_time.min) * 60 + tonumber(open_time[3]) - server_time.sec 
                            if leave_time <= 0 then
                                local endTime = v[2][#v[2]]
                                open_time = zstring.split(endTime, ":")
                                leave_time = (tonumber(open_time[1]) - server_time.hour) * 3600 + (tonumber(open_time[2]) - server_time.min) * 60 + tonumber(open_time[3]) - server_time.sec 
                                
                                if leave_time > 0 then
                                    endTime = v[2][#v[2] - 1]
                                    open_time = zstring.split(endTime, ":")
                                    leave_time = (tonumber(open_time[1]) - server_time.hour) * 3600 + (tonumber(open_time[2]) - server_time.min) * 60 + tonumber(open_time[3]) - server_time.sec 
                                    if leave_time <= 0 then
                                        self:updateHomeAcivityPushUIInfo(k, true)
                                    else
                                        self:updateHomeAcivityPushUIInfo(k, false)
                                    end
                                end
                            end
                            --self:updateHomeAcivityPushUIInfo(k, false)
                        elseif k == 3 then
                            local function responseDigitalPurifyInitCallback(response)
                                if type(_ED.digital_purify_info) ~= "table" or type(_ED.digital_purify_info._heros) ~= "table" then
                                    return
                                end
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    local haveShip = false
                                    for i , v in pairs(_ED.digital_purify_info._heros) do
                                        if fundShipWidthTemplateId(v[2]) ~= nil then
                                            haveShip = true
                                            break 
                                        end
                                    end
                                    if haveShip == true then
                                        local currNumber = 0
                                        if _ED.digital_purify_info ~= nil and _ED.digital_purify_info._team_info ~= nil
                                            and _ED.digital_purify_info._team_info.members ~= nil then
                                            for i , v in pairs(_ED.digital_purify_info._team_info.members) do
                                                if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
                                                    currNumber = tonumber(v.complete_count)
                                                end
                                            end
                                        end
                                        if currNumber < 3 then
                                            self:updateHomeAcivityPushUIInfo(3, false)
                                        end
                                    end
                                end
                            end
                            if _ED.digital_purify_info == nil then
                                NetworkManager:register(protocol_command.ship_purify_init.code, nil, nil, nil, nil, responseDigitalPurifyInitCallback, false, nil) 
                            else
                                responseDigitalPurifyInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                            end
                        elseif k == 4 then
                            local beginTime = v[2][1]
                            local open_time = zstring.split(beginTime, ":")
                            local leave_time = (tonumber(open_time[1]) - server_time.hour) * 3600 + (tonumber(open_time[2]) - server_time.min) * 60 + tonumber(open_time[3]) - server_time.sec 
                            if leave_time <= 0 then
                                local endTime = v[2][#v[2]]
                                open_time = zstring.split(endTime, ":")
                                leave_time = (tonumber(open_time[1]) - server_time.hour) * 3600 + (tonumber(open_time[2]) - server_time.min) * 60 + tonumber(open_time[3]) - server_time.sec 
                                if leave_time > 0 then
                                    endTime = v[2][#v[2] - 1]
                                    open_time = zstring.split(endTime, ":")
                                    leave_time = (tonumber(open_time[1]) - server_time.hour) * 3600 + (tonumber(open_time[2]) - server_time.min) * 60 + tonumber(open_time[3]) - server_time.sec 
                                    if leave_time <= 0 then
                                        self:updateHomeAcivityPushUIInfo(k, true)
                                    else
                                        self:updateHomeAcivityPushUIInfo(k, false)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Hide online/promotion shortcuts in the local port. Cache node references
-- because other activity updates may attempt to make these visible again.
function Home:hideLocalPromotionShortcuts()
    if not self.roots or not self.roots[1] then return end
    if not self._localPromotionNodes then
        self._localPromotionNodes = {}
        local hidden={Button_huodong=true,Button_chongzhi=true,Button_libao=true,Button_kefu=true,
            Button_gm_connect=true,ListView_1=true,ListView_1_2=true,ListView_2=true,ScrollView_2pai=true}
        local function collect(node)
            if hidden[node:getName()] then table.insert(self._localPromotionNodes,node) end
            for _,child in ipairs(node:getChildren()) do collect(child) end
        end
        collect(self.roots[1])
    end
    for _,node in ipairs(self._localPromotionNodes) do
        node:setVisible(false)
        node:setTouchEnabled(false)
    end
end

function Home:onUpdate(dt)
    self:hideLocalPromotionShortcuts()
    -- 老用户回归自动关闭活动
    if nil == self.userReturnDayCls and _ED.active_activity[166]  then
        local userReturnEndTime = _ED.active_activity[166].end_time
        local current = _ED.system_time + (os.time() - _ED.native_time)
        local surplusTime = userReturnEndTime / 1000 - current
        if 0 >= surplusTime then
            self.userReturnDayCls = true
            app.load("client.activity.sevendaysregression.SevenHappyRegressionManager")
            if  fwin:find("SevenHappyRegressionManagerClass") then
                TipDlg.drawTextDailog(tipStringInfo_new_activity_tips[2])
                fwin:close(fwin:find("SevenHappyRegressionManagerClass"))
                _ED.active_activity[166] = nil
                state_machine.excute("home_update_top_activity_info_state", 0, nil)
            end
        end
    end
    if _ED.is_send_get_web_recharge_state == nil and _ED.webRechargeState ~= nil and _ED.sevenDayActOpenServerNumber ~= nil then
        _ED.is_send_get_web_recharge_state = true
        UpdateSevenRechargeActivity()
    end

    -- 首页七日连充自动关闭活动
    if _ED.webSevenDayOpen and _ED.showSevenDaysRecharge and _ED.seven_day_recharge_infos then
        local SevenDaysEndTime = _ED.seven_day_recharge_infos.endTime
        if SevenDaysEndTime <= 0 then
            _ED.showSevenDaysRecharge = false
            _ED.webSevenDayOpen = false
        else
            local server_time = getCurrentGTM8Time()
            local current = os.time() - _ED.native_time + _ED.system_time
            local surplusTime = SevenDaysEndTime / 1000 - current
            if 0 >= surplusTime then
                _ED.seven_day_recharge_infos = nil
                _ED.showSevenDaysRecharge = false
                _ED.webSevenDayOpen = false
                app.load("client.activity.seven_days_recharge.SevenDaysRechargeWindow")
                if  fwin:find("SevenDaysRechargeWindow") then
                    TipDlg.drawTextDailog(tipStringInfo_new_activity_tips[2])
                    fwin:close(fwin:find("SevenDaysRechargeWindow"))
                end
                state_machine.excute("home_update_top_activity_info_state", 0, nil)
            end
        end
    end

    -- 组合卡道具领取条件
    if (__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and not self.combination_prop_flag and tonumber(_ED.combine_ship_prop_get) ~= 2 then 
        
        self.combination_prop_open = tonumber(_ED.user_info.user_grade) >= self.combination_prop_level
        if self.combination_prop_open then 
            state_machine.excute("home_update_top_activity_info_state",0,"")
            self.combination_prop_flag = true
        end
    end

    if nil == self.userReturnCls and _ED.active_activity[164] then
        local userReturnEndTime = _ED.active_activity[164].end_time
        local current = _ED.system_time + (os.time() - _ED.native_time)
        local surplusTime = userReturnEndTime / 1000 - current
        if 0 >= surplusTime then
            self.userReturnCls = true
            app.load("client.activity.user_return.UserReturnWindow")
            if  fwin:find("UserReturnWindowClass") then
                TipDlg.drawTextDailog(tipStringInfo_new_activity_tips[2])
                fwin:close(fwin:find("UserReturnWindowClass"))
                protocol_command.old_user_back_recharge_close.param_list = _ED.active_activity[165].activity_id.."".."\r\n"
                NetworkManager:register(protocol_command.old_user_back_recharge_close.code, nil, nil, nil, nil, nil, false, nil)
                
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        _ED.active_activity[164] = nil
                        _ED.active_activity[165] = nil
                        _ED.active_activity[166] = nil
						state_machine.excute("home_update_top_activity_info_state", 0, nil)
					end
				end
                protocol_command.old_user_back_seven_day_close.param_list = _ED.active_activity[164].activity_id.."".."\r\n"
                NetworkManager:register(protocol_command.old_user_back_seven_day_close.code, nil, nil, nil, nil, responseCallback, false, nil)
            end
        end
    end

	if 2 == self.init_home_effect and nil ~= self._ship_mould_id  then
		self.init_home_effect = 1
		self:playHeroEffect()
	end

	if self.action ~= nil then
		self.action:play("Panel_button_1_tonch", false)
		self.action = nil
	end    

    if self.runState == 1 then
        state_machine.unlock("menu_manager_change_to_page", 0, "")
        self.runState = self.runState + 1
    end
    if self.runState == 0 then
        self.runState = self.runState + 1
    end
	if __lua_project_id == __lua_project_warship_girl_b 
        or __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
    	or __lua_project_id == __lua_project_warship_girl_a 
    	or __lua_project_id == __lua_project_koone
    	then
		--次日活动
		if self._is_show_activity_next_day ~= true and _ED.active_activity[48] ~= nil then
			--and tonumber(_ED.active_activity[48].activity_isReward) == 1
			self._is_show_activity_next_day = true
			local mysteryShop = ActivityIconCell:createCell()
			mysteryShop:init(mysteryShop.enum_type.ACTIVITY_HOME_NEXT_DAY_ICON)
            if __lua_project_id == __lua_project_yugioh then 
                self.listButtons_2:addChild(mysteryShop)
                self:refreshActivityListButtonsSize(2)
            else
                self.AcitivityListTwo:addChild(mysteryShop)
            end
		
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_activity_next_day",
			_widget = mysteryShop,
			_invoke = nil,
			_interval = 0.5,})
		end
	end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
    	or __lua_project_id == __lua_project_red_alert
	    then
        --队伍发送聊天时间
        if tonumber(_ED.purify_team_send_world_message_times) > 0 then
            _ED.purify_team_send_world_message_times = _ED.purify_team_send_world_message_times - dt
        end
        if tonumber(_ED.purify_team_send_union_message_times) > 0 then
            _ED.purify_team_send_union_message_times = _ED.purify_team_send_union_message_times - dt
        end

        local isShowOnlinePanel = false
        if self.everyDayOnlinePanel ~= nil then
            -- local Panel_hd_tuisong = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_hd_tuisong")
            self.everyDayOnlinePanel:setVisible(false)
            if (os.time() + _ED.time_add_or_sub) >= zstring.tonumber(_ED.every_day_online_reward_next_time)/1000 then
                local count = zstring.tonumber(_ED.every_day_online_reward_times)
                local timeArr = zstring.split(dms.string(dms["play_config"], 50, pirates_config.param), ",")
                if count < #timeArr then
                    isShowOnlinePanel = true
                    self.everyDayOnlinePanel:setVisible(true)
                    if self.Panel_hd_tuisong ~= nil then
                        if self.Panel_hd_tuisong:isVisible() == true then
                            self.Panel_hd_tuisong._isHide = true
                        end
                        self.Panel_hd_tuisong:setVisible(false)
                    end
                end
            end
            if isShowOnlinePanel == false 
                and self.Panel_hd_tuisong ~= nil 
                and self.Panel_hd_tuisong._isHide == true
                then
                self.Panel_hd_tuisong:setVisible(true)
                self.Panel_hd_tuisong._isHide = nil
            end
        end
	elseif __lua_project_id == __lua_project_gragon_tiger_gate
        or __lua_project_id == __lua_project_red_alert then
        if self.show_finder ~= nil then
            if tonumber(_ED.user_info.user_grade) < 14 and missionIsOver() == true then
                self.show_finder:setVisible(true)
            else
                self.show_finder:setVisible(false)
            end
        end
		if _ED._reward_centre == nil or _ED._reward_centre == "" or #_ED._reward_centre == 0 then
		else
			local root = self.roots[1]
			local AcitivityList = ccui.Helper:seekWidgetByName(root, "ListView_1")
			
			local function getHasRewardCentre()
				
				for k, v in pairs(AcitivityList:getItems()) do
					if v.item == "reward"  then
						return true 
					end
				    
				end
				
				return false
			end
			
			if getHasRewardCentre() ~= true then
                AcitivityList:removeAllItems()
				self:upDataDraw()
				-- local rewardCentre = ActivityIconCell:createCell()
				-- rewardCentre:init(rewardCentre.enum_type.ACTIVITY_GAIN_REWARD_ICON)
				-- AcitivityList:addChild(rewardCentre)	
				-- rewardCentre.item = "reward"
				-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_of_the_award",
				-- _widget = rewardCentre,
				-- _invoke = nil,
				-- _interval = 0.5,})
			end
		end
	end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        self.totalTimes = self.totalTimes + dt
        if self.totalTimes >= 10 then
            self.totalTimes = 0

            if _ED.user_info.fight_capacity ~= self.user_fight then
                self.user_fight = _ED.user_info.fight_capacity
            end

            if _ED.home_activity_push_info == nil then
                _ED.home_activity_push_info = {}
            end
            if home_activity_push_times_info ~= nil then
                local server_time = getCurrentGTM8Time()
                for k,v in pairs(home_activity_push_times_info) do
                    local openInfo = _ED.home_activity_push_info[k]
                    if openInfo == nil then
                        openInfo = {isHaveOpen = false, isWaitOpen = false, isAllShow = false}
                    end
                    _ED.home_activity_push_info[k] = openInfo
                    if (openInfo.isHaveOpen == false and openInfo.isWaitOpen == false) or openInfo.isAllShow == true then
                        if funOpenDrawTip(v[1], false) == false then
                            local isOpened = false
                            if k == 1 then
                                isOpened = _ED.union_red_envelopes_open
                            elseif k == 2 then
                                isOpened = _ED.union.union_fight_battle_info ~= nil and zstring.tonumber(_ED.union.union_fight_battle_info.state) >= 1
                                if isOpened == true then
                                    if _ED.union.union_info == nil 
                                        or _ED.union.union_info == {} 
                                        or _ED.union.union_info.union_id == nil 
                                        or _ED.union.union_info.union_id == "" 
                                        or tonumber(_ED.union.union_info.union_id) == 0 
                                        then
                                        isOpened = false
                                    end
                                end
                                if isOpened == true then
                                    isOpened = not funOpenDrawTip(82, false)
                                end
                                if isOpened == true then
                                    isOpened = not funOpenDrawTip(149, false)
                                end
                            elseif k == 3 then
                                isOpened = true
                            elseif k == 4 then
                                isOpened = true
                            end
                            if isOpened == true then
                                local totalTimes = 0
                                if k == 4 then
                                    totalTimes = #v[2]
                                end
                                for j, timeInfo in pairs(v[2]) do
                                    local open_time = zstring.split(timeInfo, ":")
                                    local leave_time = (tonumber(open_time[1]) - server_time.hour) * 3600 + (tonumber(open_time[2]) - server_time.min) * 60 + tonumber(open_time[3]) - server_time.sec
                                    if leave_time <= 0 and leave_time >= -1 then
                                        if k == 3 then
                                            local function responseDigitalPurifyInitCallback(response)
                                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                                    self.have_send_purify = true
                                                    local haveShip = false
                                                    for i , v in pairs(_ED.digital_purify_info._heros) do
                                                        if fundShipWidthTemplateId(v[2]) ~= nil then
                                                            haveShip = true
                                                            break 
                                                        end
                                                    end
                                                    if haveShip == true then
                                                        local currNumber = 0
                                                        if _ED.digital_purify_info ~= nil and _ED.digital_purify_info._team_info ~= nil
                                                            and _ED.digital_purify_info._team_info.members ~= nil then
                                                            for i , v in pairs(_ED.digital_purify_info._team_info.members) do
                                                                if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
                                                                    currNumber = tonumber(v.complete_count)
                                                                end
                                                            end
                                                        end
                                                        if currNumber < 3 then
                                                            self:updateHomeAcivityPushUIInfo(3, false)
                                                        end
                                                    end
                                                end
                                            end
                                            if _ED.digital_purify_info == nil and self.have_send_purify == false then
                                                self.have_send_purify = true
                                                NetworkManager:register(protocol_command.ship_purify_init.code, nil, nil, nil, nil, responseDigitalPurifyInitCallback, false, nil) 
                                            else
                                                responseDigitalPurifyInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                                            end
                                        else
                                            if k == 4 and totalTimes - 1 == j then
                                                self:updateHomeAcivityPushUIInfo(k, true)
                                            else
                                                self:updateHomeAcivityPushUIInfo(k, false)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        if self.updateTimes == 0 then
            state_machine.excute("sm_model_open_the_animation", 0, nil)
        elseif self.updateTimes > 1.5 then
            state_machine.excute("sm_model_close_the_animation", 0, nil)
            self.updateTimes = -5
        elseif self.updateTimes >= -1 and self.updateTimes < 0 then
            self.updateTimes = 0
            state_machine.excute("sm_model_open_the_animation", 0, nil)
        end
        self.updateTimes = self.updateTimes + dt
    end
    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then


    end
end

function Home:onExit()
    state_machine.remove("home_adventure_forum")
    state_machine.remove("home_adventure_gift_bag")
    state_machine.remove("home_adventure_friends")
    state_machine.remove("home_adventure_system_set")
    state_machine.remove("home_adventure_shop")
    state_machine.remove("home_adventure_sign_in")
    state_machine.remove("home_adventure_month_card")
    state_machine.remove("home_adventure_activity")
    state_machine.remove("home_adventure_achievement")
    state_machine.remove("home_adventure_black_market")
    state_machine.remove("home_adventure_notice")
	state_machine.remove("home_adventure_more_system")
    state_machine.remove("home_capture_open")
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        state_machine.remove("home_more_setting_update")
        state_machine.remove("home_check_level_packs")
    end
    if __lua_project_id ==__lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh or 
        __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then  
        if ___is_open_push_info ~= false then
            state_machine.excute("warship_girl_push_info_close",0,"")
        end
    end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        state_machine.remove("sm_open_every_day_online_reward")
        state_machine.remove("sm_model_join_push_goto_join")
        state_machine.remove("sm_model_open_push_scan")
        state_machine.remove("sm_model_open_push_updata")
        state_machine.remove("sm_home_update_activity_push_state")
        state_machine.remove("home_update_online_reward_info_state")
        state_machine.remove("home_update_mission_over_finder_state")
        state_machine.remove("home_update_target_task_info_state")
    end

    state_machine.remove("home_new_recruit_main")
    state_machine.remove("add_war_order_exp")
    state_machine.remove("home_activity_listview_control_open_and_shrink")
end

function Home:init(prop,types )
	self.prop = prop
	self.type = types
end

function Home:createCell()
	local cell = Home:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
