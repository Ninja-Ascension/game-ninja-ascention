-- ----------------------------------------------------------------------------------------------------
-- 说明：围剿叛军主页面
-- 创建时间	2015-03-06
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

WorldBoss = class("WorldBossClass", Window)
    
function WorldBoss:ctor()
    self.super:ctor()
	app.load("client.campaign.worldboss.SeniorityExploit")
	-- app.load("client.campaign.worldboss.RecommendFriend")
	app.load("client.campaign.worldboss.BetrayArmyShop")
	app.load("client.campaign.worldboss.ExploitSecond")
	app.load("client.campaign.worldboss.BetrayArmyNpc")
	app.load("client.campaign.worldboss.WorldbossFriendHurt")
	app.load("client.utils.ConfirmTip")
    self.roots = {}
	self.actions = {}
	self.npcMouldid = ""
	self.rolePageList = {}
	self.enum_initType = {
		_UPDATE_BOSS = 1,	
	}
	
	-- app.load("client.packs.treasure.TreasureStorage")
	
    -- Initialize WorldBoss page state machine.
    local function init_world_boss_terminal()
	
		local world_boss_back_terminal = {
            _name = "world_boss_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                
				fwin:close(instance)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					if fwin:find("CampaignClass") == nil then
						state_machine.excute("menu_show_campaign",0,5)
					else
						state_machine.excute("campaign_window_show",0,"")
					end
				else
					fwin:open(Campaign:new(), fwin._view)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--排行榜
		local button_seniority_terminal = {
            _name = "button_seniority",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            		fwin:open(SeniorityExploit:new(), fwin._ui)
            	else
					local function responsePropCompoundCallback(response)
	                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							local function responseCallback(response)
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									fwin:open(SeniorityExploit:new(), fwin._ui)
								end
							end
							protocol_command.search_order_list.param_list = "".."11"
							NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responseCallback, false, nil)
						end
	                end
					
					protocol_command.search_order_list.param_list = "".."12"
	                NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--推荐好友
		local button_recommend_friend_terminal = {
            _name = "button_recommend_friend",
            _init = function (terminal) 
                app.load("client.friend.FriendManagerRecommend")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					fwin:open(FriendManagerRecommend:new(), fwin._windows)
					-- local function responsePropCompoundCallback(response)
						-- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							-- fwin:open(RecommendFriend:new(), fwin._ui)
						-- end
					-- end
					
					-- NetworkManager:register(protocol_command.random_user_list.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--奖励
		local button_exploit_reward_terminal = {
            _name = "button_exploit_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local view = fwin:find("ExploitSecondClass")
				if nil == view then
					fwin:open(ExploitSecond:new(), fwin._ui)
				else
					view:onShow(true)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--叛军商店
		local button_betray_army_shop_terminal = {
            _name = "button_betray_army_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if (__lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert) and
                	_ED.rebel_exploit_shop.count ~= nil and _ED.rebel_exploit_shop.count ~= "" and tonumber(_ED.rebel_exploit_shop.count) ~= 0 then
                	fwin:open(BetrayArmyShop:new(), fwin._view)
				else
					local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							fwin:open(BetrayArmyShop:new(), fwin._view)
						end
					end
					NetworkManager:register(protocol_command.rebel_exploit_shop_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--进入副本
		local world_boss_show_duplicate_terminal = {
            _name = "world_boss_show_duplicate",
            _init = function (terminal) 
				app.load("client.duplicate.DuplicateController")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
			
				fwin:open(DuplicateController:new(), fwin._view)
				
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
				
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local world_boss_help_button_terminal = {
            _name = "world_boss_help_button",
            _init = function (terminal) 
				app.load("client.campaign.worldboss.BetrayArmyHelp")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:open(BetrayArmyHelp:new(), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--打开指定的npc战斗界面
		local world_boss_open_npc_fight_terminal = {
            _name = "world_boss_open_npc_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                
				-- betray_army_npc_cell_into_battle_info  
				-- _npcExample = self.npcExample
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--依次打开好友伤害浮动界面
		local world_boss_open_float_hurt_terminal = {
            _name = "world_boss_open_float_hurt",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                
				instance:showFloatHurt()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新战功
		local world_boss_refresh_honor_terminal = {
            _name = "world_boss_refresh_honor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
           		if instance ~= nil and instance.roots ~= nil then
					instance:rankRebelArmyDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --叛军BOSS
		local world_boss_rebel_boss_terminal = {
            _name = "world_boss_rebel_boss",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
           		
           		local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						app.load("client.campaign.worldboss.rebelboss.RebelBoss")
           				state_machine.excute("rebel_boss_window_open",0,1)
					end
				end
				NetworkManager:register(protocol_command.rebel_boss_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
				

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(world_boss_open_float_hurt_terminal)
		state_machine.add(world_boss_open_npc_fight_terminal)
		state_machine.add(world_boss_back_terminal)
		state_machine.add(button_exploit_reward_terminal)
		state_machine.add(button_seniority_terminal)
		state_machine.add(button_recommend_friend_terminal)
		state_machine.add(button_betray_army_shop_terminal)
		state_machine.add(world_boss_show_duplicate_terminal)
		state_machine.add(world_boss_help_button_terminal)
		state_machine.add(world_boss_refresh_honor_terminal)
		state_machine.add(world_boss_rebel_boss_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_world_boss_terminal()
end
-- 绘制排名
function WorldBoss:rankRebelArmyDraw()
	local root = self.roots[1]
	local myExploitText = nil
	local oneHurtText = nil
	local dayAccumulateText = nil
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
		myExploitText = ccui.Helper:seekWidgetByName(root, "Text_6")
		oneHurtText = ccui.Helper:seekWidgetByName(root, "Text_4")
		dayAccumulateText = ccui.Helper:seekWidgetByName(root, "Text_2")
	else
		myExploitText = ccui.Helper:seekWidgetByName(root, "Text_2")
		oneHurtText = ccui.Helper:seekWidgetByName(root, "Text_4")
		dayAccumulateText = ccui.Helper:seekWidgetByName(root, "Text_6")
	end
	
	if _ED.exploit_second_information ~= nil then
		if tonumber(_ED.exploit_second_information.myExploit) == 0 
			or _ED.exploit_second_information.myExploit == nil then
			myExploitText:setString(_string_piece_info[151])			--我的功勋排名
		else
			myExploitText:setString(_ED.exploit_second_information.myExploit)			--我的功勋排名
		end
		if tonumber(_ED.exploit_second_information.oneHurt) == 0 
			or _ED.exploit_second_information.oneHurt == nil then
			oneHurtText:setString(_string_piece_info[151])				--单次伤害排名
		else
			oneHurtText:setString(_ED.exploit_second_information.oneHurt)				--单次伤害排名
		end
		if _ED.exploit_second_information.dayAccumulate == nil then 
			dayAccumulateText:setString("0")
		else
			dayAccumulateText:setString(_ED.exploit_second_information.dayAccumulate)	--今日功勋累计
		end
	end	
end
-- 绘制NPC
function WorldBoss:onUpdateDraw()
	local root = self.roots[1]
	local betrayArmyPageView = ccui.Helper:seekWidgetByName(root, "PageView_101")
	local PanelNPC = ccui.Helper:seekWidgetByName(root, "Panel_21")	--小助手形象
	local Panel_role_1 = nil
	if tonumber(_ED.betray_army_information.army_count) <= 0 then
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			Panel_role_1 = ccui.Helper:seekWidgetByName(root, "Panel_role_1")
			Panel_role_1:removeAllChildren(true)
			draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_role_1, nil, nil, cc.p(0.5, 0))
			
			if animationMode == 1 then
				app.load("client.battle.fight.FightEnum")
				local shipSpine = sp.spine_sprite(Panel_role_1, 1089, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	                shipSpine:setScaleX(-1)
	            end
			else
				draw.createEffect("spirte_" .. 1089, "sprite/spirte_" .. 89 .. ".ExportJson", Panel_role_1, -1, nil, nil, cc.p(0.5, 0))
			end
		end
		PanelNPC:setVisible(true)
	else
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			Panel_role_1 = ccui.Helper:seekWidgetByName(root, "Panel_role_1")
			Panel_role_1:removeAllChildren(true)
		end
		local nCount = _ED.betray_army_information.army_count			--叛军数量
		local armyInfo =  _ED.betray_army_information.betray_army_info	
		local pageCount = math.floor((nCount - 1) / 3) + 1
		for i = 1, pageCount do	
			local elementData = {}
			for j=1, 3 do
				table.insert(elementData, armyInfo[i * 3 - (j-1)])
			end
			local cell = BetrayArmyNpc:createCell()
			cell:init(elementData)
			betrayArmyPageView:addPage(cell)
			
			
			table.insert(self.rolePageList,  cell)
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			then
			local function checkopennpcshare( sender )
				self:openNPCFightInfo()
			end
			local action = cc.Sequence:create(cc.DelayTime:create(0.6), cc.CallFunc:create(checkopennpcshare))
			self:runAction(action)			
		else
			self:openNPCFightInfo()
		end
	end
end

function WorldBoss:openNPCFightInfo()
	local npcId = _ED.betray_army_npc.npcId
	if  nil ~= tonumber(npcId) then
		for i = 1 , table.getn(self.rolePageList) do
			local page = self.rolePageList[i]
			local cells = page.roleCellList
			for i = 1 , table.getn(cells) do
				local cell = cells[i]
				if tonumber(cell.npcExample.betray_army_example) == tonumber(npcId)then
					-- 打开离开前的
					state_machine.excute("betray_army_npc_cell_into_battle_info", 0, {_datas={_npcExample = cell.npcExample, cell = cell}})
					if tonumber(cell.npcExample.surplus_hp) > 0 then
						-- 检查是否分享过
						if tonumber(cell.npcExample.share_state) == 0 then -- 分享状态(0否 1是)
							self:openShareWin(cell)
						end
					end
					_ED.betray_army_npc.npcId = nil
					return
				end
			end
		end
	end
end


function WorldBoss:sendShare()
	local shareCell = self.shareCell
	self.shareCell = nil
	
	local function refushRebelArmyCallBack(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			-- 手动标记分享记录
			for i,v in ipairs(_ED.betray_army_information.betray_army_info) do
				if v.betray_army_example == shareCell.npcExample.betray_army_example  then
					v.share_state = 1
					response.node = nil
					return
				end
			end
		end
	end
	NetworkManager:register(protocol_command.rebel_army_share.code, nil, nil, nil, shareCell, refushRebelArmyCallBack, false, nil)
end


function WorldBoss:showShareConfirmTip(n)
	if n == 0 then
		-- yes
		self:sendShare()
	else
		-- no
	end
end

function WorldBoss:openShareWin(shareCell)
	self.shareCell = shareCell
	local tip = ConfirmTip:new()
	tip:init(self, self.showShareConfirmTip, _string_piece_info[373])
	fwin:open(tip,fwin._ui)
end

function WorldBoss:onUpdate(dt)

	if tonumber(_ED.betray_army_information.army_count) > 0 then
		-- 叛军数大于0 , 开始 刷新382请求. 排除掉不是我当前的npc实例
		-- 排除自己造成的伤害
		local currentTime  = os.time()
		local interval = tonumber(tipStringInfo_betrayArmy_request_refresh_interval)
		if currentTime - self.lastTime >= interval then
			self.lastTime = currentTime
			self:updateInfo()
		end
	end

end

function WorldBoss:updateBossHP()
	-- 更新boss血量
	for i = 1,_ED.betray_army_information.army_count do
		local betrayInfo = _ED.betray_army_information.betray_army_info[i]
		for j = 1 , _ED.worldboss_refush_rebel_army.count do
			local data = _ED.worldboss_refush_rebel_army.list[j]
			if tonumber(betrayInfo.betray_army_example) == data[1] then
				betrayInfo.surplus_hp = data[4]
				break
			end
		end
	end
end

-- 检查是否有好友伤害需要飘出来
function WorldBoss:statisticsFloatHurt()
	
	self.FloatHurtlist = {}
	for i = 1,_ED.betray_army_information.army_count do
		local betrayInfo = _ED.betray_army_information.betray_army_info[i]
		for j = 1 , _ED.worldboss_refush_rebel_army.count do
			local data = _ED.worldboss_refush_rebel_army.list[j]
			if tonumber(betrayInfo.betray_army_example) == data[1] and data[2] ~= tostring(_ED.user_info.user_name) then
				local fname = data[2]
				local hurt = data[3]
				local str = string.format(_string_piece_info[336],fname,hurt)
				table.insert(self.FloatHurtlist, str)
			end
		end
	end
	
	self:showFloatHurt()
end

function WorldBoss:showFloatHurt()
	if table.getn(self.FloatHurtlist) > 0 then
		local str = table.remove(self.FloatHurtlist,1)
		local view = WorldbossFriendHurt:createCell()
		view:init(str)
		fwin:open(view, fwin._view)
	end
end

function WorldBoss:updateInfo()
	local _self = self
	-- 去找服务器要当前的刷新数据
	local function refushRebelArmyCallBack(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			response.node:updateBossHP()
			-- 消息出去 
			for i = 1 , table.getn(response.node.rolePageList) do
				local cell = response.node.rolePageList[i]
				state_machine.excute("world_boss_update_page_npc_info", 0,{cell = cell}) 
			end
		end
	end
	NetworkManager:register(protocol_command.refush_rebel_army.code, nil, nil, nil, _self, refushRebelArmyCallBack, false, nil)
end

function WorldBoss:updateBoss()
	if self.enum_initType._UPDATE_BOSS == self.etype then
	
		local _self = self
		-- 去找服务器要当前的刷新数据
		local function refushRebelArmyCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if nil ~= response.node and response.node.roots ~= nil and response.node.roots[1] ~= nil then
					-- 更新boss血量
					response.node:updateBossHP()
					--	绘制叛军信息
					response.node:onUpdateDraw()
					--	绘制主页面显示信息
					response.node:rankRebelArmyDraw()
					-- 检查 伤害绘制
					response.node:statisticsFloatHurt()
					
					state_machine.excute("betray_army_npc_state_update", 0, "betray_army_npc_cell_update_battle_info.")
				end
			end
		end
		NetworkManager:register(protocol_command.refush_rebel_army.code, nil, nil, nil, self, refushRebelArmyCallBack, false, nil)
	end
end

function WorldBoss:onEnterTransitionFinish()
	
	self.lastTime = os.time()
	local csbWorldBoss = csb.createNode("campaign/WorldBoss/worldBoss.csb")
	self:addChild(csbWorldBoss)
	local root = csbWorldBoss:getChildByName("root")
	table.insert(self.roots, root)
	-- 小助手呼吸动画
	if tonumber(_ED.betray_army_information.army_count) <= 0 then
		local action = csb.createTimeline("campaign/WorldBoss/worldBoss.csb")
		table.insert(self.actions, action)
		root:runAction(action)
		action:play("Panel_role_1_dh", true)
	end
	local PanelNPC = ccui.Helper:seekWidgetByName(root, "Panel_21")	--小助手形象
	PanelNPC:setVisible(false)
	if tonumber(_ED.betray_army_information.army_count) <= 0 then
		PanelNPC:setVisible(true)
	end
	local Button_6 = ccui.Helper:seekWidgetByName(root, "Button_6")
	--评审状态不显示排行榜
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto then 
		if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
			Button_6:setVisible(true)
		else
			Button_6:setVisible(false)
		end
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, {terminal_name = "world_boss_back", terminal_state = 0, isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {terminal_name = "button_exploit_reward", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
	fwin:addTouchEventListener(Button_6, nil, {terminal_name = "button_seniority", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5"), nil, {terminal_name = "button_recommend_friend", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, {terminal_name = "button_betray_army_shop", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_21"), nil, {terminal_name = "world_boss_show_duplicate", terminal_state = 0}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {terminal_name = "world_boss_help_button", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_worldboss",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_2"),
		_direction = 2, --功勋奖励
		_invoke = nil,
		_interval = 0.5,})	
	end


	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then	
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_worldboss_reward",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_2"),
		_invoke = nil,
		_interval = 0.5,})	
	end
	if self.enum_initType._UPDATE_BOSS == self.etype then 
		self:updateBoss()
	else
		--	绘制叛军信息
		self:onUpdateDraw()
		--	绘制主页面显示信息
		self:rankRebelArmyDraw()
	end
	if __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto   
		then 
		
		local function recruitCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then 
					response.node:rankRebelArmyDraw()
				end
			end
		end
		NetworkManager:register(protocol_command.rebel_army_init.code, nil, nil, nil, self, recruitCallBack, false, nil)	
	end
	
	state_machine.excute("menu_button_hide_highlighted_all", 0, nil)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		if _ED.rebel_exploit_shop.count == nil or _ED.rebel_exploit_shop.count == "" or tonumber(_ED.rebel_exploit_shop.count) == 0 then
			local function recruitCallBack(response)
			end
			NetworkManager:register(protocol_command.rebel_exploit_shop_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
		end

		local function responseCallback(response)
			local function responsePropCompoundCallback(response)
	        end
			protocol_command.search_order_list.param_list = "".."12"
	        NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)			
		end
		protocol_command.search_order_list.param_list = "".."11"
		NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responseCallback, false, nil)

	end
	
	local Button_worldboss = ccui.Helper:seekWidgetByName(root, "Button_worldboss")
	if Button_worldboss ~= nil then
		if _ED.RebelBoss.is_open_state == 0 then
			Button_worldboss:setVisible(false)
		else
			Button_worldboss:setVisible(true)
		end 
		--世界BOSS
		fwin:addTouchEventListener(Button_worldboss, nil, 
	    {
	        terminal_name = "world_boss_rebel_boss", 
	        terminal_state = 0, 
	        isPressedActionEnabled = true
	    }, nil, 2)

	end
end

-- etype 表示 当前数据处理方式, 是初始化还是更新
function WorldBoss:init(etype)
	self.etype = etype

end

function WorldBoss:onExit()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		cacher.destoryRefPools()
		cacher.cleanSystemCacher()
		cacher.removeAllTextures()
	end
	state_machine.excute("exploit_second_back_close", 0, 0)
	state_machine.remove("world_boss_open_npc_fight")
	state_machine.remove("world_boss_open_float_hurt")
	state_machine.remove("world_boss_back")
	state_machine.remove("button_seniority")
	state_machine.remove("button_recommend_friend")
	state_machine.remove("button_betray_army_shop")
	state_machine.remove("button_exploit_reward")
	state_machine.remove("world_boss_refresh_honor")
end