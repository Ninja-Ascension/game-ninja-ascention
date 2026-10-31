-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场主界面
-------------------------------------------------------------------------------------------------------
Arena = class("ArenaClass", Window)

local arena_window_open_terminal = {
    _name = "arena_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:open(Arena:new(), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_window_close_terminal = {
    _name = "arena_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
    		fwin:close(fwin:find("ArenaClass"))
	    	fwin:cleanView(fwin._view)
	        if fwin:find("MenuClass") == nil then
	            fwin:open(Menu:new(), fwin._taskbar)
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
	        state_machine.excute("menu_clean_page_state", 0, "")
	    else
    		fwin:close(fwin:find("ArenaClass"))
    	end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_window_open_terminal)
state_machine.add(arena_window_close_terminal)
state_machine.init()


Arena.RoleName = nil
function Arena:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}

	self.cacheListView = nil
	self.cacheListViewPosX = 0
	self._list_view_posY = 0
	self._list_view_posX = 0

	self._armature = nil

	-- load lua file
	app.load("client.l_digital.campaign.arena.ArenaPoint")
	app.load("client.l_digital.campaign.arena.ArenaAchieveReward")
    app.load("client.l_digital.cells.arena.arena_ladder_seat_cell")
	app.load("client.l_digital.campaign.arena.ArenaRankingPanel")
	app.load("client.l_digital.campaign.arena.ArenaWarReportPanel")
	app.load("client.l_digital.campaign.arena.ArenaRulePanel")
	app.load("client.l_digital.campaign.arena.ArenaFiveTimeResult")
	
    -- Initialize Arena page state machine.
    local function init_arena_terminal()
		local arena_refresh_launch_list_terminal = {
		    _name = "arena_refresh_launch_list",
		    _init = function (terminal) 
		        
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params) 
		    	local function responseArenaLounchRefreshCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("user_info_hero_storage_update",0,"user_info_hero_storage_update.")
						if response.node == nil or response.node.roots == nil then
							return
						end
						response.node:onInitDraw()
					end
				end
				protocol_command.arena_lounch_refresh.param_list = "0".."\r\n".."0"
				NetworkManager:register(protocol_command.arena_lounch_refresh.code, nil, nil, nil, instance, responseArenaLounchRefreshCallback, false, nil)
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}
		
		local arena_one_key_worship_terminal = {
		    _name = "arena_one_key_worship",
		    _init = function (terminal) 
		        
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params) 
		    	local function responseArenaWorshipCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("user_info_hero_storage_update",0,"user_info_hero_storage_update.")
						if response.node == nil or response.node.roots == nil then
							return
						end
						response.node:onUpdateDrawLaunchListView()
						local rewardList = getSceneReward(14)
						if nil ~= rewardList then
							local number = 0
							for i=1, tonumber(rewardList.show_reward_item_count) do
								if tonumber(rewardList.show_reward_list[i].prop_type) == 1 then
									number = tonumber(rewardList.show_reward_list[i].item_value)
									break
								end
							end
							TipDlg.drawTextDailog(string.format(_new_interface_text[41],zstring.tonumber(number)))
						else
							TipDlg.drawTextDailog(_new_interface_text[134])
						end
					end
				end
				protocol_command.arena_worship.param_list = "0".."\r\n".."1".."\r\n".."-1"
				NetworkManager:register(protocol_command.arena_worship.code, nil, nil, nil, instance, responseArenaWorshipCallback, false, nil)
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}
		
		local arena_clear_launch_wait_cd_terminal = {
		    _name = "arena_clear_launch_wait_cd",
		    _init = function (terminal) 
		        
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params) 
		    	local function responseArenaClearLaunchWaitCdCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("user_info_hero_storage_update",0,"user_info_hero_storage_update.")
						if response.node == nil or response.node.roots == nil then
							return
						end
						response.node:onUpdateDraw()
					end
				end
				
				protocol_command.arena_launch_clear_cd.param_list = "0"
				NetworkManager:register(protocol_command.arena_launch_clear_cd.code, nil, nil, nil, instance, responseArenaClearLaunchWaitCdCallback, false, nil)
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}
		
		local arena_buy_launch_count_terminal = {
		    _name = "arena_buy_launch_count",
		    _init = function (terminal) 
		        
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params) 
		    	local function responseArenaBuyLaunchCountCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("user_info_hero_storage_update",0,"user_info_hero_storage_update.")
						if response.node == nil or response.node.roots == nil then
							return
						end
						response.node:onUpdateDraw()
					end
				end
				
				protocol_command.buy_arena_launch_count.param_list = "0"
				NetworkManager:register(protocol_command.buy_arena_launch_count.code, nil, nil, nil, instance, responseArenaBuyLaunchCountCallback, false, nil)
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		local arena_once_again_ladder_seat_playback_terminal = {
            _name = "arena_once_again_ladder_seat_playback",
            _init = function (terminal) 
                app.load("client.battle.BattleStartEffect")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            if type(cc.nrSpineCommand)=='function' and _ED.nr_arena_recorded_packets then
                                require('arena_replay').play(_ED.nr_arena_recorded_packets)
                            end		
							if _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
								_ED.user_is_level_up = true
								_ED.arena_is_level_up = true
								_ED.last_grade = _ED.user_info.last_user_grade
								_ED.last_food = _ED.user_info.last_user_food
								_ED.last_endurance = _ED.user_info.last_endurance			
							end
							-- 胜利了,记录当前.requestArenaFightDatas
							if tonumber(_ED.attackData.isWin) == 1 then


							end
							fwin:close(self.userInformationHeroStorage)
							fwin:cleanView(fwin._windows)
							fwin:freeAllMemeryPool()
							local bse = BattleStartEffect:new()
							bse:init(_enum_fight_type._fight_type_11)
							fwin:open(bse, fwin._windows)
						end	
					end
				end
            	protocol_command.battlefield_report_battle_info_get.param_list = _ED.battle_playback_arena.nType.."\r\n".._ED.battle_playback_arena.time
                if type(cc.nrSpineCommand)=='function' then
                    protocol_command.battlefield_report_battle_info_get.param_list = protocol_command.battlefield_report_battle_info_get.param_list.."\r\njournal-v2"
                end
				NetworkManager:register(protocol_command.battlefield_report_battle_info_get.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local arena_set_list_view_position_terminal = {
            _name = "arena_set_list_view_position",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local root = instance.roots[1]
				local ListView_challenger = ccui.Helper:seekWidgetByName(root, "ListView_challenger")
				ListView_challenger:getInnerContainer():setPositionX(0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --点击竞技场商店
		local arena_go_to_shop_terminal = {
            _name = "arena_go_to_shop",
            _init = function (terminal)
                app.load("client.l_digital.shop.SmShopPropBuyListView")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local _shop = Shop:new()
				_shop:init(0,3)
				fwin:open(_shop, fwin._view)
				state_machine.excute("shop_manager", 0, 
                    {
                        _datas = {
                            terminal_name = "shop_manager",     
                            next_terminal_name = "shop_prop_buy",
                            current_button_name = "Button_props",  
                            but_image = "prop",      
                            terminal_state = 0, 
                            shop_type = "shop",
                            isPressedActionEnabled = false
                        }
                    }
                )
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arena_update_times_info_terminal = {
            _name = "arena_update_times_info",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
	            	instance:onUpdateDraw()
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arena_open_user_pic_window_terminal = {
            _name = "arena_open_user_pic_window",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.l_digital.player.SmPlayerSystemSetChangeHead")
        		state_machine.excute("sm_player_system_set_change_head_open",0,"sm_player_system_set_change_head_open.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新头像
        local arena_update_user_pic_terminal = {
            _name = "arena_update_user_pic",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
	            	instance:updateDrawHead()
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         --facebook分享
        local share_click_on_terminal = {
            _name = "share_click_on",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	            if __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[2])
                    else
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[1])
                    end
                end

	            if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
                    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_lz_share[2])
                    else
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_lz_share[1])
                    end
                end
                
                if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and app.configJson.ReleaseLanguage == "en" then
                    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[2])
                    else
                        handlePlatformRequest(0, CC_SHARE_REQUEST, _web_page_share[1])
                    end
                end
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(arena_refresh_launch_list_terminal)
		state_machine.add(arena_one_key_worship_terminal)
		state_machine.add(arena_clear_launch_wait_cd_terminal)
		state_machine.add(arena_buy_launch_count_terminal)
		state_machine.add(arena_once_again_ladder_seat_playback_terminal)
		state_machine.add(arena_set_list_view_position_terminal)
		state_machine.add(arena_go_to_shop_terminal)
		state_machine.add(arena_update_times_info_terminal)
		state_machine.add(arena_open_user_pic_window_terminal)
		state_machine.add(arena_update_user_pic_terminal)
		state_machine.add(share_click_on_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_terminal()
end

function Arena:onUpdate(dt)
	if nil ~= self._interval then
        self._interval = self._interval - dt
        if self._last_interval - self._interval > 0.5 then
            self._last_interval = self._interval
            if self._interval < 0 then
                self:onUpdateDraw()
            else
                self.Text_cd_n:setString(self:formatTimeString(self._interval))
            end
        end
    end
    
    if self.cacheListView ~= nil then
    	local size = self.cacheListView:getContentSize()
		local posX = self.cacheListView:getInnerContainer():getPositionX()
		local posY = self.cacheListView:getInnerContainer():getPositionY()

		if self ._list_view_posY == 0 then
	        self._list_view_posY = posY
	    end
    	if __lua_project_id == __lua_project_l_digital then
    		local left_button = ccui.Helper:seekWidgetByName(self.roots[1], "Button_arrow_l")
    		local right_button = ccui.Helper:seekWidgetByName(self.roots[1], "Button_arrow_r")
             if self._list_view_posY < -30 then 
                right_button:setVisible(true)
            else
                right_button:setVisible(false)
            end
            if self._list_view_posY >= self.cacheListView:getContentSize().height - self.cacheListView:getInnerContainer():getContentSize().height + 30 then
                left_button:setVisible(true)
            else
                left_button:setVisible(false)
            end

            if self._list_view_posY == posY then
                return
            end
            self._list_view_posY = posY
            local items = self.cacheListView:getItems()
            if items[1] == nil then
                return
            end
            local itemSize = items[1]:getContentSize()
            for i, v in pairs(items) do
                local tempY = v:getPositionY() + posY
                if tempY + itemSize.height/2 < 0 or tempY > size.height + itemSize.height /2 then
                    v:unload()
                else
                    v:reload()
                end
            end
        elseif __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        	local left_button = ccui.Helper:seekWidgetByName(self.roots[1], "Button_arrow_l")
			local right_button = ccui.Helper:seekWidgetByName(self.roots[1], "Button_arrow_r")

			if self.cacheListViewPosX == posX then
		        return
		    end
		    self.cacheListViewPosX = posX

		    if self.cacheListViewPosX >= 0 then
	        	left_button:setVisible(false)
	        else
	        	left_button:setVisible(true)
	        end

	        if self.cacheListViewPosX <= (self.cacheListView:getContentSize().width - self.cacheListView:getInnerContainer():getContentSize().width) then
	        	right_button:setVisible(false)
	        else
	        	right_button:setVisible(true)
	        end


		    local items = self.cacheListView:getItems()
		    if items[1] == nil then
		        return
		    end
		    local itemSize = items[1]:getContentSize()
		    for i, v in pairs(items) do
		        local tempX = v:getPositionX() + posX
		        if tempX + itemSize.width/2 < 0 or tempX > size.width + itemSize.width/2 then
		            v:unload()
		        else
		            v:reload()
		        end
		    end
        else
		    if self.cacheListViewPosX == posX then
		        return
		    end
		    self.cacheListViewPosX = posX
		    local items = self.cacheListView:getItems()
		    if items[1] == nil then
		        return
		    end
		    local itemSize = items[1]:getContentSize()
		    for i, v in pairs(items) do
		        local tempX = v:getPositionX() + posX
		        if tempX + itemSize.width/2 < 0 or tempX > size.width + itemSize.width/2 then
		            -- v:unload()
		        else
		            v:reload()
		        end
		    end
		end
	end
end

function Arena:formatTimeString(_time)  --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%01d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function Arena:onUpdateDraw()
	local root = self.roots[1]
	-- 排名
	local Text_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rank_n")
	Text_rank_n:setString(_ED.arena_user_rank)

	-- 战斗力
	local Text_fight_n = ccui.Helper:seekWidgetByName(root, "Text_fight_n")
	Text_fight_n:setString(_ED.user_combat_force)

	-- 挑战次数
	local everyDayFreeLounchCount = dms.string(dms["arena_config"], 2, pirates_config.param)
	local Text_tzcs = ccui.Helper:seekWidgetByName(root, "Text_tzcs")
	Text_tzcs:setString("" .. _ED.arena_user_remain .. "/" .. everyDayFreeLounchCount)

	-- [[挑战的冷却CD
	self._interval = nil
	local Panel_26 = ccui.Helper:seekWidgetByName(root, "Panel_26")
	Panel_26:setVisible(false)
	if nil ~= _ED.user_launch_battle_cd and _ED.user_launch_battle_cd > 0 then
		local Text_cd_n = ccui.Helper:seekWidgetByName(root, "Text_cd_n")
		local interval = _ED.user_launch_battle_cd / 1000 - (_ED.system_time + (os.time() - _ED.native_time))
        if interval > 0 then
			Panel_26:setVisible(true)
        	self._interval = interval
            self._last_interval = interval
            self.Text_cd_n = Text_cd_n
            self.Text_cd_n:setString(self:formatTimeString(self._interval))
        end
	end
	-- ~挑战的冷却CD]]

	-- [[刷新消耗
	local Image_zuanshi = ccui.Helper:seekWidgetByName(root, "Image_zuanshi")
	local Text_zuanshi_n = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_n")
	local Text_free = ccui.Helper:seekWidgetByName(root, "Text_free")
	Image_zuanshi:setVisible(false)
	Text_zuanshi_n:setVisible(false)
	Text_free:setVisible(false)

	-- ~刷新消耗]]

	local Button_change = ccui.Helper:seekWidgetByName(root, "Button_change")
	local Button_reset = ccui.Helper:seekWidgetByName(root, "Button_reset")
	local Button_buy_cs = ccui.Helper:seekWidgetByName(root, "Button_buy_cs")

	Image_zuanshi:loadTexture("images/ui/icon/zuanshi.png")
	Button_change:setVisible(false)
	Button_reset:setVisible(false)
	Button_buy_cs:setVisible(false)

	if nil ~= self._interval then
		Button_reset:setVisible(true)
		local needGold = dms.int(dms["arena_config"], 5, pirates_config.param)
		Image_zuanshi:setVisible(true)
		Text_zuanshi_n:setVisible(true)
		Text_zuanshi_n:setString("" .. needGold)
	elseif tonumber(_ED.arena_user_remain) > 0 then
		Button_change:setVisible(true)
		local needGolds = zstring.split(dms.string(dms["arena_config"], 6, pirates_config.param), ",")
		local needGold = zstring.tonumber(needGolds[math.max(1, math.min(#needGolds, _ED.user_launch_refresh_count + 1))])
		if nil ~= needGold and needGold > 0 then
			Image_zuanshi:setVisible(true)
			Text_zuanshi_n:setVisible(true)
			Text_zuanshi_n:setString("" .. needGold)
		else
			Text_free:setVisible(true)
		end
	end

	if tonumber(_ED.arena_user_remain) == 0 then
		local needGolds = zstring.split(dms.string(dms["arena_config"], 3, pirates_config.param), ",")
		local curr = zstring.tonumber(_ED.arena_user_change_times_buy_times) + 1
		if curr >= #needGolds then
			curr = #needGolds
		end
		local needGold = zstring.tonumber(needGolds[curr])
		Text_free:setVisible(false)
		Image_zuanshi:setVisible(true)
		Text_zuanshi_n:setVisible(true)
		Text_zuanshi_n:setString("" .. needGold)
		Button_change:setVisible(false)
		Button_reset:setVisible(false)
		Button_buy_cs:setVisible(true)

		local prop_id = dms.string(dms["arena_config"], 18, pirates_config.param)
	    local propData = fundPropWidthId(prop_id)
	    if propData ~= nil then
	    	Image_zuanshi:setVisible(true)
	    	Image_zuanshi:loadTexture("images/ui/props/props_3042.png")
	    	Text_zuanshi_n:setVisible(true)
	    	Text_zuanshi_n:setString("" .. propData.prop_number)
	    	Button_change:setVisible(true)
		end
	end
	self:onUpdateDrawFiveTimes()
end

function Arena:onUpdateDrawLaunchListView()
	local root = self.roots[1]
	local ListView_challenger = ccui.Helper:seekWidgetByName(root, "ListView_challenger")
	local items = ListView_challenger:getItems()
	for i, v in pairs(items) do
		v.roleInstance = _ED.arena_challenge[i]
		v:initDraw()
	end
end

function Arena:onUpdateDrawFiveTimes()
	local root = self.roots[1]
	local ListView_challenger = ccui.Helper:seekWidgetByName(root, "ListView_challenger")
	local items = ListView_challenger:getItems()
	for i, v in pairs(items) do
		v:updateFiveTimesInfo()
	end
end

function Arena:onRefreshLaunchListView( ... )
	local root = self.roots[1]
	local ListView_challenger = ccui.Helper:seekWidgetByName(root, "ListView_challenger")
	ListView_challenger:removeAllItems()
	for i, v in pairs(_ED.arena_challenge) do
		local cell = ArenaLadderSeatCell:createCell()
		if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
			cell:init(v, 10+i)
		else
			cell:init(v, i)
		end
		ListView_challenger:addChild(cell)
	end
	ListView_challenger:refreshView()
	-- ListView_challenger:requestRefreshView()

	-- ListView_challenger:scrollToRight(0.01, false)
	self.cacheListView = ListView_challenger
	if  __lua_project_id == __lua_project_l_digital then
		self.cacheListView:jumpToBottom()
	else
		ListView_challenger:getInnerContainer():setPositionX(ListView_challenger:getContentSize().width - ListView_challenger:getInnerContainer():getContentSize().width)
		self.cacheListViewPosX = ListView_challenger:getInnerContainer():getPositionX()
		ListView_challenger:getInnerContainer():setPositionX(self.cacheListViewPosX - 1)
	end
	
end

function Arena:updateDrawHead()
	local root = self.roots[1]
	local Panel_head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_head")
	if __lua_project_id == __lua_project_l_digital then
		local hero_fight = 0
		local ship_id = 0
		for i,v in pairs(_ED.user_ship) do
			if zstring.tonumber(v.hero_fight) > hero_fight then
				hero_fight = zstring.tonumber(v.hero_fight)
				ship_id = i
			end
		end
		if ship_id and ship_id ~= 0 then
			local evo_mould_id = smGetSkinEvoIdChange(_ED.user_ship[ship_id])
			local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

			local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
			if fun_is_open == true then
				temp_bust_index = tonumber(_ED.user_info.user_image_id)

				if temp_bust_index <= 0 then
					temp_bust_index = dms.int(dms["user_config"], 23, user_config.param)
				end
			end

			Panel_head:removeAllChildren(true)
			self._armature = nil
			-- draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), self.roleIconPanel, nil, nil, cc.p(0.5, 0))

			--画光圈
			local camp_preference = dms.int(dms["ship_mould"], tonumber(_ED.user_ship[ship_id].ship_template_id), ship_mould.camp_preference)
			local animation_name = ""
			if camp_preference == 1 then    		--攻击
				animation_name = "type_1"
			elseif camp_preference == 2 then 		--防御
				animation_name = "type_2"
			elseif camp_preference == 3 then 		--技能
				animation_name = "type_3"
			end
			local jsonFile = "sprite/spirte_type_di.json"
		    local atlasFile = "sprite/spirte_type_di.atlas"
		    local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, animation_name, true, nil)
		    animation2:setPosition(cc.p(Panel_head:getContentSize().width/2,0))
		 	Panel_head:addChild(animation2)

		 	app.load("client.battle.fight.FightEnum")
			if self._armature == nil then
				self._armature = sp.spine_sprite(Panel_head, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self._armature:setScaleX(-1)
				end
			end
		end
	else
		if Panel_head ~= nil then
			Panel_head:removeBackGroundImage()
			local playerIconStr = nil
			if tonumber(_ED.user_info.user_head) >= 9 then
				playerIconStr = string.format("images/ui/props/props_%s.png", _ED.user_info.user_head)
			else
				playerIconStr = string.format("images/ui/home/head_%s.png", _ED.user_info.user_head)
			end
			Panel_head:setBackGroundImage(playerIconStr)
		end
	end
end

function Arena:onInitDraw()
	self:updateDrawHead()
	self:onUpdateDraw()
	self:onRefreshLaunchListView()
end

function Arena:onEnterTransitionFinish()
    local csbArena = csb.createNode("campaign/ArenaStorage/ArenaStorage.csb")
	local root = csbArena:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArena)
	
	-- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "arena_window_close", 
        isPressedActionEnabled = true
    },
    nil,0)
    
    _ED.city_resource_battle_report = _ED.city_resource_battle_report or {}
    _ED.city_resource_battle_report[11] = {}
	protocol_command.battlefield_report_get.param_list = "11,1011"
	NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, self, responseReportCallback, false, nil)

    -- [[标题栏
    local title_but_names = {
    	{"Button_ranking", 	"sm_arena_ranking_panel_open"},
    	{"Button_shop",		"arena_go_to_shop"},
    	{"Button_reward",	"arena_achieve_reward_window_open"},
    	{"Button_zhanbao",	"sm_arena_war_report_panel_open"},
    	{"Button_jifen", 	"arena_point_window_open"},
    	{"Button_guize", 	"sm_arena_rule_panel_open"},
	}

	for i, v in pairs(title_but_names) do
		local Button_func = ccui.Helper:seekWidgetByName(root, v[1])
        fwin:addTouchEventListener(Button_func, nil, 
        {
            terminal_name = v[2],    
            page_index = i,
            button = Button_huodong_guaka, 
            isPressedActionEnabled = true
        },
        nil,0)
	end

	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_arena_achieve",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_reward"),
        _invoke = nil,
        _interval = 0.5,})

	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_arena_point",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_jifen"),
        _invoke = nil,
        _interval = 0.5,})
	
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_war_report_panel",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_zhanbao"),
        _invoke = nil,
        _interval = 0.5,})
	
	-- ~标题栏]]

	-- [[初始化竞技场
    -- if _ED.arena_user_rank == nil or _ED.arena_user_rank == "" then
	    local function responseArenaInitCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if nil ~= response.node and nil ~= response.node.roots then
					response.node:onInitDraw()
				end
			end
		end

		protocol_command.arena_init.param_list = "0"
		NetworkManager:register(protocol_command.arena_init.code, nil, nil, nil, self, responseArenaInitCallback, false, nil)
	-- else
	-- 	self:onInitDraw()
 --    end
    -- ~初始化竞技场]]

    -- 刷新
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change"), nil, 
    {
        terminal_name = "arena_refresh_launch_list", 
        isPressedActionEnabled = true
    },
    nil,0)

    -- 一键膜拜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yjmb"), nil, 
    {
        terminal_name = "arena_one_key_worship", 
        isPressedActionEnabled = true
    },
    nil,0)

    -- 清除挑战等待CD
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reset"), nil, 
    {
        terminal_name = "arena_clear_launch_wait_cd", 
        isPressedActionEnabled = true
    },
    nil,0)

    -- 购买挑战次数
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_cs"), nil, 
    {
        terminal_name = "arena_buy_launch_count", 
        isPressedActionEnabled = true
    },
    nil,0)

    -- local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head")
    -- if Panel_head ~= nil then
    -- 	--头像变更
    -- 	fwin:addTouchEventListener(Panel_head, nil, 
	   --  {
	   --      terminal_name = "arena_open_user_pic_window", 
	   --      isPressedActionEnabled = true
	   --  },
	   --  nil,0)
    -- end
    if ccui.Helper:seekWidgetByName(root, "Button_show") ~= nil then
		ccui.Helper:seekWidgetByName(root, "Button_show"):setTouchEnabled(true)
	    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_show"), nil, 
	    {
	        terminal_name = "share_click_on", 
	        isPressedActionEnabled = true
	    },
	    nil,0)
	end

    if ccui.Helper:seekWidgetByName(root, "Button_show") ~= nil then
    	if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
    		ccui.Helper:seekWidgetByName(root, "Button_show"):setVisible(true)
    	else
    		ccui.Helper:seekWidgetByName(root, "Button_show"):setVisible(false)
    	end
	end
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		local director = cc.Director:getInstance()
		local glView = director:getOpenGLView()
		local frameScreen = tonumber(glView:getFrameSize().width) / tonumber(glView:getFrameSize().height)
		local designScreen = tonumber(app.designSize.width) / tonumber(app.designSize.height)
		local scale = frameScreen / designScreen
		if scale < 1 then
			scale = 1
		end
		local pixLeft = (scale - 1) * 66
		local pixRight = (scale - 1) * 157
		local Panel_8 = ccui.Helper:seekWidgetByName(root, "Panel_8")
		local Panel_jjc_1 = ccui.Helper:seekWidgetByName(root, "Panel_jjc_1")
		Panel_8:setPositionX(Panel_8:getPositionX() - pixLeft)
		Panel_jjc_1:setPositionX(Panel_jjc_1:getPositionX() + pixRight)
	end

    app.load("client.player.UserInformationHeroStorage")
    local userInformationHeroStorage = UserInformationHeroStorage:new()
    userInformationHeroStorage._rootWindows = self
	fwin:open(userInformationHeroStorage,fwin._view)
	
	-- 彩蛋事件添加
	showEasterEggEvent(4,-1,root)

end

function Arena:init(params)
	return self
end

function Arena:close( ... )
	
end

function Arena:onExit()
	state_machine.remove("arena_refresh_launch_list")
	state_machine.remove("arena_one_key_worship")
	state_machine.remove("arena_clear_launch_wait_cd")
	state_machine.remove("arena_buy_launch_count")
	state_machine.remove("arena_set_list_view_position")
	state_machine.remove("arena_go_to_shop")
	state_machine.remove("arena_update_times_info")
end

function Arena:destroy( window )
	if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end