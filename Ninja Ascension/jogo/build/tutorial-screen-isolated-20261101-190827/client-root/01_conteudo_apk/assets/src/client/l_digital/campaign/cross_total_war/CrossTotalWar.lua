--[[ ----------------------------------------------------------------------------
-- 跨服忍界大战主界面
--]] ----------------------------------------------------------------------------
CrossTotalWar = class("CrossTotalWarClass", Window)

local cross_total_war_window_open_terminal = {
    _name = "cross_total_war_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
	_invoke = function(terminal, instance, params) 
		if nil == fwin:find("CrossTotalWarClass") then
			fwin:open(CrossTotalWar:new(), fwin._view)
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local cross_total_war_window_close_terminal = {
    _name = "cross_total_war_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:close(fwin:find("CrossTotalWarClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(cross_total_war_window_open_terminal)
state_machine.add(cross_total_war_window_close_terminal)
state_machine.init()


CrossTotalWar.RoleName = nil
function CrossTotalWar:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}

	self.cacheListView = nil
	self.cacheListViewPosX = 0
	self._list_view_posY = 0
	self._list_view_posX = 0

	self._armature = nil

	self.deltaTime = 1
	self.totalTime = 0
	self._endTime = nil

	-- load lua file
	app.load("client.l_digital.campaign.cross_total_war.crosstotalwarrole")
	app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarRule")
	app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarReport")
 	app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarPreview")
	app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarChallenge")
	app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarFormation")
	app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarFormationIcon")
	app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarFormationIcon")
	app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarShop")
	app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarAttackFormation")
	app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarVictory")
	app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarVictoryReward")
	app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarShowDefenseFormation")
	
	-- app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarRulePanel")
	-- app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarFiveTimeResult")
	
    -- Initialize CrossTotalWar page state machine.
    local function init_cross_total_war_terminal()
		local cross_total_war_refresh_launch_list_terminal = {
		    _name = "cross_total_war_refresh_launch_list",
		    _init = function (terminal) 
		        
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params) 
				
				local function responseCrossTotalWarInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
						if response.node == nil or response.node.roots == nil then
							return
						end

						response.node:onInitDraw()
					end
				end
				protocol_command.cross_arena_init.param_list = ""
				NetworkManager:register(protocol_command.cross_arena_init.code, nil, nil, nil, self, responseCrossTotalWarInitCallback, false, nil)
				return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}
		
		local cross_total_war_one_key_worship_terminal = {
		    _name = "cross_total_war_one_key_worship",
		    _init = function (terminal) 
		        
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params) 
		    	local function responseCrossTotalWarWorshipCallback(response)
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
				protocol_command.cross_total_war_worship.param_list = "0".."\r\n".."1".."\r\n".."-1"
				-- NetworkManager:register(protocol_command.cross_total_war_worship.code, nil, nil, nil, instance, responseCrossTotalWarWorshipCallback, false, nil)
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}
		

		local cross_total_war_once_again_ladder_seat_playback_terminal = {
            _name = "cross_total_war_once_again_ladder_seat_playback",
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
							if _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
								_ED.user_is_level_up = true
								_ED.cross_total_war_is_level_up = true
								_ED.last_grade = _ED.user_info.last_user_grade
								_ED.last_food = _ED.user_info.last_user_food
								_ED.last_endurance = _ED.user_info.last_endurance			
							end
							-- 胜利了,记录当前.requestCrossTotalWarFightDatas
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
            	protocol_command.battlefield_report_battle_info_get.param_list = _ED.battle_playback_CrossTotalWar.nType.."\r\n".._ED.battle_playback_CrossTotalWar.time
				-- NetworkManager:register(protocol_command.battlefield_report_battle_info_get.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local cross_total_war_set_list_view_position_terminal = {
            _name = "cross_total_war_set_list_view_position",
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
		local cross_total_war_go_to_shop_terminal = {
            _name = "cross_total_war_go_to_shop",
            _init = function (terminal)
                -- app.load("client.shop.SmShopPropBuyListView")
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

        local cross_total_war_update_times_info_terminal = {
            _name = "cross_total_war_update_times_info",
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

        local cross_total_war_open_user_pic_window_terminal = {
            _name = "cross_total_war_open_user_pic_window",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.player.SmPlayerSystemSetChangeHead")
        		state_machine.excute("sm_player_system_set_change_head_open",0,"sm_player_system_set_change_head_open.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新头像
        local cross_total_war_update_user_pic_terminal = {
            _name = "cross_total_war_update_user_pic",
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
	            if __lua_project_id == __lua_project_l_naruto then
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
		
		 --刷新押注
		local update_bet_status_terminal = {
            _name = "update_bet_status",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	            if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
	            	instance:updateBet()
	            end
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		 --刷新排行榜
		 local update_bet_status_terminal = {
            _name = "update_bet_status",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	            if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
	            	instance:updateBet()
	            end
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(update_bet_status_terminal)
		state_machine.add(cross_total_war_refresh_launch_list_terminal)
		state_machine.add(cross_total_war_one_key_worship_terminal)
		state_machine.add(cross_total_war_once_again_ladder_seat_playback_terminal)
		state_machine.add(cross_total_war_set_list_view_position_terminal)
		state_machine.add(cross_total_war_go_to_shop_terminal)
		state_machine.add(cross_total_war_update_times_info_terminal)
		state_machine.add(cross_total_war_open_user_pic_window_terminal)
		state_machine.add(cross_total_war_update_user_pic_terminal)
		state_machine.add(share_click_on_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_cross_total_war_terminal()
end
function CrossTotalWar:getChangeTimes()
	-- 获取挑战次数
	local function cross_arena_remaining_challengesCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				response.node:onUpdateDraw()
			end
		end
	end
	protocol_command.cross_arena_remaining_challenges.param_list = ""
	NetworkManager:register(protocol_command.cross_arena_remaining_challenges.code, nil, nil, nil, self, cross_arena_remaining_challengesCallback, false, nil)
end

function CrossTotalWar:onUpdate(dt)

	self.totalTime = self.totalTime + dt
	if self.totalTime >= self.deltaTime then
		self:updateRemainTime()
		self.totalTime = 0
	end

	if nil ~= self._interval and -1 ~= self._interval then
        self._interval = self._interval - dt
        if self._last_interval - self._interval > 0.5 then
            self._last_interval = self._interval
            if self._interval < 0 then
                self:getChangeTimes()
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
				if __lua_project_id == __lua_project_onepiece then
					v:unload()
				end
			else
				v:reload()
			end
		end
		
	end
end

function CrossTotalWar:formatTimeString(_time)  --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%01d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function CrossTotalWar:onUpdateDraw()
	local root = self.roots[1]

	-- 排名
	local Text_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rank_n")
	if tonumber(_ED.cross_arena_data.myRank) == -1 then
		Text_rank_n:setString(_new_interface_text[335])
	else
		Text_rank_n:setString(_ED.cross_arena_data.myRank)
	end

	-- 战斗力
	local Text_fight_n = ccui.Helper:seekWidgetByName(root, "Text_fight_n")
	Text_fight_n:setString(_ED.cross_arena_data.myCombatForce)
	-- 积分
	local Text_point_n = ccui.Helper:seekWidgetByName(root, "Text_point_n")
	Text_point_n:setString(_ED.cross_arena_data.integral)

	-- 挑战次数
	local everyDayFreeLounchCount = dms.string(dms["gvg_config"], 29, pirates_config.param)
	local Text_tzcs = ccui.Helper:seekWidgetByName(root, "Text_tzcs")
	Text_tzcs:setString("" .. _ED.cross_arena_user_remain.challengeTimes .. "/" .. everyDayFreeLounchCount)

	local Image_zbjd = ccui.Helper:seekWidgetByName(root, "Image_zbjd")
	local Image_ysjd = ccui.Helper:seekWidgetByName(root, "Image_ysjd")
	local Image_jsjd = ccui.Helper:seekWidgetByName(root, "Image_jsjd")

	if tonumber(_ED.cross_arena_data.state) == 1 then
		Image_ysjd:setVisible(true)
		Image_zbjd:setVisible(false)
		Image_jsjd:setVisible(false)
	elseif tonumber(_ED.cross_arena_data.state) == 3 or tonumber(_ED.cross_arena_data.state) == 4 or tonumber(_ED.cross_arena_data.state) == 5 then
		Image_ysjd:setVisible(false)
		Image_zbjd:setVisible(false)
		Image_jsjd:setVisible(true)
	else
		Image_ysjd:setVisible(false)
		Image_zbjd:setVisible(true)
		Image_jsjd:setVisible(false)
	end


	self._interval = nil
	local Text_time_0 = ccui.Helper:seekWidgetByName(root, "Text_time_0")
	Text_time_0:setVisible(false)
	self.Text_cd_n = ccui.Helper:seekWidgetByName(root, "Text_time")
	self.Text_cd_n:setVisible(false)

	if nil ~=_ED.cross_arena_user_remain.countDown and tonumber(_ED.cross_arena_user_remain.countDown) > 0 then
		local interval =_ED.cross_arena_user_remain.countDown / 1000
		if interval > 0 then
			Text_time_0:setVisible(true)
        	self._interval = interval
			self._last_interval = interval
			self.Text_cd_n:setVisible(true)
            self.Text_cd_n:setString(self:formatTimeString(self._interval))
        end
	end

	self.Text_time_1 = ccui.Helper:seekWidgetByName(root, "Text_time_1")
	self:updateEndTime()

	-- self:onUpdateDrawFiveTimes()
end

function CrossTotalWar:onUpdateDrawLaunchListView()
	local root = self.roots[1]
	local ListView_challenger = ccui.Helper:seekWidgetByName(root, "ListView_challenger")
	local items = ListView_challenger:getItems()
	for i, v in pairs(items) do
		v.roleInstance = _ED.cross_arena_data.ranks[i]
		v:initDraw()
	end
end

function CrossTotalWar:updateBet()
	local root = self.roots[1]
	local ListView_challenger = ccui.Helper:seekWidgetByName(root, "ListView_challenger")
	local items = ListView_challenger:getItems()
	for i, v in pairs(items) do
		v:hideBetButton()
	end
end


function CrossTotalWar:onUpdateDrawFiveTimes()
	local root = self.roots[1]
	local ListView_challenger = ccui.Helper:seekWidgetByName(root, "ListView_challenger")
	local items = ListView_challenger:getItems()
	for i, v in pairs(items) do
		v:updateFiveTimesInfo()
	end
end

function CrossTotalWar:onRefreshLaunchListView( ... )

	local root = self.roots[1]
	local ListView_challenger = ccui.Helper:seekWidgetByName(root, "ListView_challenger")
	ListView_challenger:removeAllItems()
	for i, v in pairs(_ED.cross_arena_data.ranks) do
		local cell = CrossTotalWarRole:createCell()
		local tmp = {}
		tmp[1] = v.template
		v.template = tmp
		-- v.template = {
		-- 	[1] = "135:5:1|2,0,0,0:3:0:139:0!149:6:1|2,0,0,0:3:0:139:0!92:2:1|2,0,0,0:4:0:147:0!87:1:1|2,0,0,0:4:0:147:0!79:1:1|2,0,0,0:4:0:147:0!257:15:1|2,0,0,0:4:0:177:0",
		-- 	[2] = "-1",
		-- 	[3] = "-1",
		-- 	[4] = "-1",
		-- }
		cell:init(v, i)
		ListView_challenger:addChild(cell)
	end
	ListView_challenger:refreshView()

	-- ListView_challenger:scrollToRight(0.01, false)
	self.cacheListView = ListView_challenger
	
	ListView_challenger:getInnerContainer():setPositionX(ListView_challenger:getContentSize().width - ListView_challenger:getInnerContainer():getContentSize().width)
	self.cacheListViewPosX = ListView_challenger:getInnerContainer():getPositionX()
	ListView_challenger:getInnerContainer():setPositionX(self.cacheListViewPosX - 1)
	

	local items = ListView_challenger:getItems()
	if table.nums(items) <= 9 then
		for k, v in pairs(items) do
			v:reload()
		end
	end

	ListView_challenger:jumpToLeft()
	ListView_challenger:requestRefreshView()
end

function CrossTotalWar:updateDrawHead()
	local root = self.roots[1]
	local Panel_head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_head")
	if __lua_project_id == __lua_project_l_digital and Panel_head ~= nil then
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

function CrossTotalWar:onInitDraw()
	self:updateDrawHead()
	self:onUpdateDraw()
	self:onRefreshLaunchListView()
end

function CrossTotalWar:updateEndTime()
	self._endTime = tonumber(_ED.cross_arena_data.endTime)
end

function CrossTotalWar:updateRemainTime()
	if self.Text_time_1 == nil or self._endTime == nil then
		return
	end
	local surplus_time = (self._endTime - ((os.time() + _ED.time_add_or_sub))*1000)
	self.Text_time_1:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function CrossTotalWar:drawTime(_time)
	local timeString = ""
	local _dayTime = math.floor((_time / 1000) / 86400)
	local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
	local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
	local _secondsTime = math.floor((_time / 1000) % 60)
	if _dayTime > 0 then
		timeString = timeString .. _dayTime .._string_piece_info[231]
	end
	if _hourTime < 10 then
		timeString = timeString .. "0".._hourTime ..":"
	else
		timeString = timeString .. _hourTime ..":"
	end

	if _minutesTime < 10 then
		timeString = timeString .. "0".._minutesTime ..":"
	else
		timeString = timeString .. _minutesTime ..":"
	end

	if _secondsTime < 10 then
		timeString = timeString .. "0".._secondsTime 
	else
		timeString = timeString .. _secondsTime 
	end
	return timeString
end

function CrossTotalWar:onEnterTransitionFinish()
    local csbCrossTotalWar = csb.createNode("campaign/cross_total_war/cross_total_war.csb")
	local root = csbCrossTotalWar:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbCrossTotalWar)


	
	-- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "cross_total_war_window_close", 
        isPressedActionEnabled = true   
    },
    nil,0)
    
 --    _ED.city_resource_battle_report = _ED.city_resource_battle_report or {}
 --    _ED.city_resource_battle_report[11] = {}
	-- protocol_command.battlefield_report_get.param_list = "11,1011"
	-- NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, self, responseReportCallback, false, nil)

    -- [[标题栏
    local title_but_names = {
    	{"Button_guize", 	"cross_total_war_rule_window_open"},
    	{"Button_zhanbao",	"cross_total_war_report_window_open"},
    	{"Button_shop",		"cross_total_war_shop_window_open"},
    	{"Button_reward",	"cross_total_war_preview_window_open"},
    	-- {"Button_formation",	"cross_total_war_formation_window_open"},
    	-- {"Button_ranking", 	"sm_cross_total_war_ranking_panel_open"},
    	-- {"Button_jifen", 	"cross_total_war_point_window_open"},
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

	-- 设置防守阵容
	local function func_defforma(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			-- 获取防守阵容信息
			local function cross_arena_defensive_formation_getCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					state_machine.excute("cross_total_war_formation_window_open",0,"")
				end
			end
			protocol_command.cross_arena_defensive_formation_get.param_list = ""
			NetworkManager:register(protocol_command.cross_arena_defensive_formation_get.code, nil, nil, nil, self, cross_arena_defensive_formation_getCallback, false, nil)
		end
   end
   ccui.Helper:seekWidgetByName(root, "Button_formation"):addTouchEventListener(func_defforma)

	-- 挑战
	local function func_fight(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			local state = tonumber(_ED.cross_arena_data.state)
			if  state == 0 or state == 2 or state == 6 then
				TipDlg.drawTextDailog(dms.element(dms["word_mould"], 13518)[3])
				return
			end
			
			if tonumber(_ED.cross_arena_user_remain.challengeTimes) <= 0 then
				TipDlg.drawTextDailog(_new_interface_text[178])
				return
			end
			state_machine.excute("cross_total_war_challenge_window_open", 0, "")
		end
   end
   ccui.Helper:seekWidgetByName(root, "Button_fight"):addTouchEventListener(func_fight)

	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_cross_total_war_achieve",
    --     _widget = ccui.Helper:seekWidgetByName(root, "Button_reward"),
    --     _invoke = nil,
    --     _interval = 0.5,})

	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_cross_total_war_point",
    --     _widget = ccui.Helper:seekWidgetByName(root, "Button_jifen"),
    --     _invoke = nil,
    --     _interval = 0.5,})
	
	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_war_report_panel",
    --     _widget = ccui.Helper:seekWidgetByName(root, "Button_zhanbao"),
    --     _invoke = nil,
    --     _interval = 0.5,})
	
	-- ~标题栏]]

	-- 获取防守阵容信息
	local function cross_arena_defensive_formation_getCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				if _ED.cross_arena_formation.formation1 == "0,0,0,0,0,0" then
					state_machine.excute("cross_total_war_formation_window_open",0,"cross_total_war_formation_window_open.")
				end
			end
		end
	end
	protocol_command.cross_arena_defensive_formation_get.param_list = ""
	NetworkManager:register(protocol_command.cross_arena_defensive_formation_get.code, nil, nil, nil, self, cross_arena_defensive_formation_getCallback, false, nil)

	-- [[初始化竞技场
		local function responseCrossTotalWarInitCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if nil ~= response.node and nil ~= response.node.roots then
				end
			end

		end
		protocol_command.cross_arena_init.param_list = ""
		NetworkManager:register(protocol_command.cross_arena_init.code, nil, nil, nil, self, responseCrossTotalWarInitCallback, false, nil)
	-- ~初始化竞技场]]

	
	
	-- 获取挑战次数
	local function cross_arena_remaining_challengesCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				response.node:onInitDraw()

			end
		end
	end
	protocol_command.cross_arena_remaining_challenges.param_list = ""
	NetworkManager:register(protocol_command.cross_arena_remaining_challenges.code, nil, nil, nil, self, cross_arena_remaining_challengesCallback, false, nil)

    -- 刷新
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change"), nil, 
    {
        terminal_name = "cross_total_war_refresh_launch_list", 
        isPressedActionEnabled = true
    },
    nil,0)

    -- 一键膜拜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yjmb"), nil, 
    {
        terminal_name = "cross_total_war_one_key_worship", 
        isPressedActionEnabled = true
    },
    nil,0)


    -- local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head")
    -- if Panel_head ~= nil then
    -- 	--头像变更
    -- 	fwin:addTouchEventListener(Panel_head, nil, 
	   --  {
	   --      terminal_name = "cross_total_war_open_user_pic_window", 
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

    app.load("client.player.UserInformationHeroStorage")
    local userInformationHeroStorage = UserInformationHeroStorage:new()
    userInformationHeroStorage._rootWindows = self
	fwin:open(userInformationHeroStorage,fwin._view)
	
	-- iphone刘海适配
	local ListView_challenger = ccui.Helper:seekWidgetByName(root, "ListView_challenger")
	local Button_arrow_l = ccui.Helper:seekWidgetByName(root, "Button_arrow_l")

	if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and isIphoneX() then 
		if ListView_challenger then 
			ListView_challenger:setScale(0.9)
			ListView_challenger:setPositionX(ListView_challenger:getPositionX()+80)
		end
		if Button_arrow_l then 
			Button_arrow_l:setPositionX(Button_arrow_l:getPositionX()+80)
		end
	end
end

function CrossTotalWar:init(params)
	return self
end

function CrossTotalWar:close( ... )
	
end

function CrossTotalWar:onExit()
	state_machine.remove("cross_total_war_refresh_launch_list")
	state_machine.remove("cross_total_war_one_key_worship")
	state_machine.remove("cross_total_war_set_list_view_position")
	state_machine.remove("cross_total_war_go_to_shop")
	state_machine.remove("cross_total_war_update_times_info")
	state_machine.remove("update_bet_status")
	
end

function CrossTotalWar:destroy( window )
	if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end
-- ~END
-- ----------------------------------------------------------------------------
