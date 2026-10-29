----------------------------------------------------------------------------------------------------
-- 说明：点击巡逻中的领地
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MineManagerPatrol = class("MineManagerPatrolClass", Window)
    
function MineManagerPatrol:ctor()
    self.super:ctor()
	app.load("client.campaign.mine.MineAttackTerritoryRole")
	app.load("client.campaign.mine.MineManagerPatrolReward")
	app.load("client.campaign.mine.MineManagerPatrolEventList")
	app.load("client.campaign.mine.MineManagerSuppressReward")
	
    self.roots = {}
	self.mouldId = nil
	self.ship = nil
	self.ktimes = 0
	self._start_time = 0
	self._end_time = 0
	self._interval = 0
	
	self.fontSize = 18 -- 事件文字大小
	self.fontRowHeight = 50 -- 每条事件高度
	self.patrolPanel = nil --巡逻
	self.patrolButton = nil --巡逻双倍
	self.isDoubleReward = false -- 是否是双倍奖励

	
	self.countdownQueue = {30*60,20*60,10*60} -- 请求间隔时间
	self.countdownQueueText = {"00:30:00","00:20:00","00:10:00"}
	
	app.load("client.packs.hero.HeroPatchInformationPageTwoChild")
	app.load("client.cells.prop.prop_icon_cell")
    -- Initialize MineManager page state machine.
    local function init_mine_manager_patrol_terminal()
		--返回
		local mine_manager_manor_patrol_back_terminal = {
            _name = "mine_manager_manor_patrol_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 奖励领取
		local mine_manager_manor_patrol_get_reward_terminal = {
            _name = "mine_manager_manor_patrol_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				-- 提示获得 奖励
				instance:showGetReward()
	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
			
		-- 奖励领取 双倍
		local mine_manager_manor_patrol_get_reward_double_terminal = {
            _name = "mine_manager_manor_patrol_get_reward_double",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local paramArr = zstring.split(dms.string(dms["pirates_config"], 306, pirates_config.param), ",")
            	local vipLevel = zstring.tonumber(paramArr[1])
            	if zstring.tonumber(_ED.vip_grade) < vipLevel then 
            		TipDlg.drawTextDailog(tipStringInfo_mine_info[33])
            		return
            	end
            	
            	app.load("client.utils.ExpendConfirm")
            	local view = ExpendConfirm:new():init(1,zstring.tonumber(paramArr[2]),{patrolId = params._datas._id})
  				fwin:open(view, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --花费钻石巡逻双倍奖励成功，刷新界面
		local mine_manager_manor_patrol_get_reward_double_update_terminal = {
            _name = "mine_manager_manor_patrol_get_reward_double_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:patrolRewardDouble()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
			
		-- 暴动镇压
		local mine_manager_patrol_goto_riot_suppress_terminal = {
            _name = "mine_manager_patrol_goto_riot_suppress",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	
				local function responseGetRewardCallback(response)
					state_machine.excute("mine_manager_update_activity", 0, nil) 
					
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then 
							response.node:showRiotSuppress()
						end
					else
						-- 失败就可能是已经被镇压过了, 直接隐藏按钮
						if tonumber(response.PROTOCOL_STATUS) == -487 then
							if response.node ~= nil and response.node.roots ~= nil then 
								response.node:hideRebellion()
							end
						end
					end
				end
				-- 用户id, 好友id ,好友领地Id  _id = self.mouldId,_userId = self.userId,
				protocol_command.manor_repress_rebellion.param_list = params._datas._userId.."\r\n"..params._datas._id
				NetworkManager:register(protocol_command.manor_repress_rebellion.code, nil, nil, nil, instance, responseGetRewardCallback,false)
				
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(mine_manager_patrol_goto_riot_suppress_terminal)
		state_machine.add(mine_manager_manor_patrol_back_terminal)
		state_machine.add(mine_manager_manor_patrol_get_reward_terminal)
		state_machine.add(mine_manager_manor_patrol_get_reward_double_terminal)
		state_machine.add(mine_manager_manor_patrol_get_reward_double_update_terminal)
		
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_mine_manager_patrol_terminal()
end


function MineManagerPatrol:showGetReward()
	
	local view = MineManagerPatrolReward:new()

	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		local doubleStatus = 0
		for i,v in ipairs(_ED.manor_info.player.city) do
	        if v ~= nil then
	            if tonumber(self.mouldId) == tonumber(v.manor_index_id) then
	                doubleStatus = tonumber(v.patrol_status)
	                break
	            end
	        end
	    end
	    if doubleStatus == 1 then 
	    	self.isDoubleReward = true
	    else
	    	self.isDoubleReward = false
	    end
	else
		self.isDoubleReward = false
	end
		view:init(self.mouldId,self.isDoubleReward)
		fwin:open(view, fwin._windows)	
end



function MineManagerPatrol:updateObtainCurrentSate()
	-- 根据事件池的时间权重,决定显示当前类型
	
	-- 状态优先级 完成- 暴动- 镇压- 普通-
	
	-- 检查是否有3 ,完成
	
	-- 检查是否有2 和 1 是否 匹配
	
	-- 默认就巡逻
	
	self.lastSate = 0
	local tempSate = 0
	local isSubside = nil
	
	for i=1 , _ED.manor_patrol_info_number do
	
		local item = _ED.manor_patrol_info_describe[i]

		local eType = tonumber(item[2])		
	
		if eType == 0 then -- 普通
			tempSate = 0
		elseif eType == 1 then -- 暴动
			isSubside = false
			
		elseif eType == 2 then -- 镇压
			isSubside = true
			
		elseif eType == 3 then -- 结束
			tempSate = 3
		end
	end
	
	if tempSate == 3 then
		self.lastSate = tempSate
	else
		if nil ~= isSubside and false == isSubside then
			self.lastSate = 1
		else
			self.lastSate = tempSate
		end
	end
end

-- 显示镇压动画
function MineManagerPatrol:showRiotSuppress()
	-- 通知外面大地图更新状态
	state_machine.excute("mine_manager_update_activity", 0, nil) 
	
	self._role_action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()
        if str == "Panel_22_zhenya_over" then
			-- 读取171 奖励
			-- 提示 镇压成功
			-- 变更状态
			
			self:updateObtainCurrentSate()
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_warship_girl_b 
				then 
				--正压过后还是暴动状态。不知道上面怎么算的，直接改数据
				self.lastSate = 0
			end
			
			self:updateLastSate()
			local view = MineManagerSuppressReward:createCell()
			view:init(self.friend_info)
			fwin:open(view, fwin._windows)
		elseif str == "zhenya_jiangli" then
			-- 插入一条数据 到当前的事件池
			-- 更新事件池 updateIncidentMessage
			
			_ED.manor_patrol_info_number = _ED.manor_patrol_info_number +1
			table.insert(_ED.manor_patrol_info_describe, _ED.manor_repress_riot_info)
			self:updateIncidentMessage(true)
			
			-- 奖励
        end
    end)
	self._role_action:play("Panel_22_zhenya", false)
	
	
end

function MineManagerPatrol:hideRebellion()
	self.button403:setVisible(false)
end


function MineManagerPatrol:onUpdate(dt)
	self:updateCountdown()
end

function MineManagerPatrol:onUpdateDraw()
	local root = self.roots[1]

	-- 普通巡逻的主容器层
	self.panel_405  = ccui.Helper:seekWidgetByName(root, "Panel_405")
	self.panel_r_list = {
		ccui.Helper:seekWidgetByName(root, "Panel_r_41"),
		ccui.Helper:seekWidgetByName(root, "Panel_r_42"),
		ccui.Helper:seekWidgetByName(root, "Panel_r_43")
	}
	
	-- 镇压按钮
	
	self.button403 = ccui.Helper:seekWidgetByName(root, "Button_403")
	fwin:addTouchEventListener(self.button403, nil, 
	{
		terminal_name = "mine_manager_patrol_goto_riot_suppress", 
		terminal_state = 0, 
		_id = self.mouldId,
		_userId = self.userId,
		isPressedActionEnabled = true
	}, nil, 0)
	
	-- 事件池
	self.listView184 = ccui.Helper:seekWidgetByName(root, "ListView_184")
	
	-- 巡逻/暴动 role
	self.panel_r_d  = ccui.Helper:seekWidgetByName(root, "Panel_r_d")
	self.panel_r_d:addChild(self:createRole(tonumber(_ED.manor_patrol_hero_id)))
	
	-- 完成的
	self.panel_r_in  = ccui.Helper:seekWidgetByName(root, "Panel_r_in")
	self.panel_r_in:addChild(self:createRole(tonumber(_ED.manor_patrol_hero_id)))
	
	-- 巡逻状态
	self.text_43 = ccui.Helper:seekWidgetByName(root, "Text_43")
	
	-- 总倒计时
	self.text_44 = ccui.Helper:seekWidgetByName(root, "Text_44")

	local nameText = ccui.Helper:seekWidgetByName(root, "Text_198")
	local bgPanel = ccui.Helper:seekWidgetByName(root, "Panel_40")
	-- 设置城池背景-------------------------------------------------------------------------------
	bgPanel:setBackGroundImage(self:getCityBackGroundImage(self.mouldId))

	-- 设置城池名称-------------------------------------------------------------------------------
	nameText:setString(dms.string(dms["manor_mould"], self.mouldId, manor_mould.manor_name))
	
	-- 设置 当前的请求倒计时间隔 _ED.manor_patrol_income_type
	self.currentCountdown = self.countdownQueue[tonumber(_ED.manor_patrol_income_type)+1]
	
	self:updateObtainCurrentSate()
	
	self:updateLastSate()
	
	self:updateAll()
end

function MineManagerPatrol:createRole(shipID)
	local cell = MineAttackTerritoryRole:createCell()
	cell:initShip(shipID)
	return cell
end

function MineManagerPatrol:createNPC(npcID)
	local cell = MineAttackTerritoryRole:createCell()
	cell:initNPC(npcID)
	return cell
end

function MineManagerPatrol:showChatRole()
	self.chatRole = {}
	local npcStr = dms.string(dms["manor_mould"], self.mouldId , manor_mould.defend_npc)
	local npc = zstring.split(npcStr, ",")
	local n = math.min(#self.panel_r_list, #npc)
	
	for i = 1 , n do
		
			local p = self.panel_r_list[i]
			p:removeAllChildren(true)
		
			local role = self:createNPC(tonumber(npc[i]))
			p:addChild(role)
			
			table.insert(self.chatRole, role)
	end
end

function MineManagerPatrol:showChat(index)
	-- 根据当前 城池的 闲聊npc 组取出npc列
	-- 循环 废话表中匹配该npc id的 条目
	-- 循环 该匹配的条目数量
	-- 循环中,注意判定特殊字符为表情
	--self.panel_r_list
	-- 当 表情或者 气泡动画结束时,触发下一个继续
	self.chatRole[index]:showNPCDialogue(index)
end

function MineManagerPatrol:patrolRewardDouble()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	self.patrolPanel:setVisible(true)
	
	--self.patrolButton
	local doubleStatus = 0
	for i,v in ipairs(_ED.manor_info.player.city) do
        if v ~= nil then
            if tonumber(self.mouldId) == tonumber(v.manor_index_id) then
                doubleStatus = tonumber(v.patrol_status)
                break
            end
        end
    end

    if doubleStatus == 1 then 
    	--已经开启了
    	self.patrolButton:setColor(cc.c3b(150, 150, 150))
    	self.patrolButton:setTouchEnabled(false)
    	self.isDoubleReward = true
    else
    	self.patrolButton:setColor(cc.c3b(255, 255, 255))
    	self.patrolButton:setTouchEnabled(true)
    	self.isDoubleReward = false
    end
end

function MineManagerPatrol:updateLastSate()
	local root = self.roots[1]
	self.panel_405:setVisible(false)
	self.panel_r_d:setVisible(false)
	self.panel_r_in:setVisible(false)
	self.button403:setVisible(false)
	
	self.panel_r_d:stopAllActions()
	self.panel_r_in:stopAllActions()
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		self.patrolPanel:setVisible(false)
	end

	if self.lastSate == 0 then -- 跳普通
		self.panel_405:setVisible(true)
		self.panel_r_d:setVisible(true)
		self.hasShowChatNum = 0
		-- 执行废话三人组模式
		self:showChatRole()
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_warship_girl_b 
			then 
			if true == self:isMe() then 
				self.patrolPanel:setVisible(true)
				self:patrolRewardDouble()
			end
			
		end
		if nil ==  self.isInitQiPao then
			self.isInitQiPao = true
			 self._role_action:setFrameEventCallFunc(function (frame)
				if nil == frame then
					return
				end
				
				local str = frame:getEvent()
				
				if self.hasShowChatNum < 3 then
					if str == "Panel_r_d_day_qipao_1" then
						self:showChat(1)
						self.hasShowChatNum = self.hasShowChatNum +1
					elseif str == "Panel_r_d_day_qipao_2" then
						self:showChat(2)
						self.hasShowChatNum = self.hasShowChatNum +1
					elseif str == "Panel_r_d_day_qipao_3" then
						self:showChat(3)
						self.hasShowChatNum = self.hasShowChatNum +1
					end
				end
			end)
			
			
		end
		
		self._role_action:play("Panel_r_d_day", true)

	elseif self.lastSate == 1 then -- 跳暴动
		self.panel_r_d:setVisible(true)
		self._role_action:play("Panel_r_d_riot", true)
		
		if true ~= self:isMe() then
			self.button403:setVisible(true)
		else
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_warship_girl_b 
				then 
				self:patrolRewardDouble()
			end	
		end
		
		
	elseif self.lastSate == 2 then -- 跳镇压
		--镇压动画只出现在 点击镇压
		
	elseif self.lastSate == 3 then -- 跳完成
		self.panel_r_in:setVisible(true)
		self._role_action:play("window_open", false)
		
		local heroName, heroColor = self:getHeroInfo(tonumber(_ED.manor_patrol_hero_id))
		ccui.Helper:seekWidgetByName(root, "Text_name_7"):setString(heroName)
		ccui.Helper:seekWidgetByName(root, "Text_name_7"):setColor(heroColor)
		
		ccui.Helper:seekWidgetByName(root, "Text_486"):setString(tipStringInfo_mine_info[18])
		
		self.button_gain:setTouchEnabled(true)
		self.button_gain:setBright(true)
		
		self.text_43:setString(tipStringInfo_mine_info[12])
		self.text_44:setString("")
		
		self.button_gain:setTouchEnabled(true)
		self.button_gain:setBright(true)
		
		self.Panel_401:setVisible(true)

		self.Text_406:setString(heroName)
		self.Text_406:setColor(heroColor)

		-- self.listView184:removeLastItem()
		
		-- local gwidth = self.listView184:getContentSize().width
		-- local richTextTime = ccui.RichText:create()
		-- richTextTime:ignoreContentAdaptWithSize(false)
		-- local fontSize = 20
		
		-- local tempStr = tipStringInfo_mine_info[17]
		-- local re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_mine_patrol_color[5][1], tipStringInfo_mine_patrol_color[5][2], tipStringInfo_mine_patrol_color[5][3]), 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
		-- richTextTime:pushBackElement(re)

		-- richTextTime:setContentSize(cc.size(gwidth, 30))
		
		-- self.listView184:addChild(richTextTime)
		
		-- self.listView184:getInnerContainer():setPositionY(99999)
		-- self.listView184:requestRefreshView()
		
		--self:endAll()
	end

end



function MineManagerPatrol:endAll()

	--self.listView184:removeLastItem()
		
	local gwidth = self.listView184:getContentSize().width
	local richTextTime = ccui.RichText:create()
	richTextTime:ignoreContentAdaptWithSize(false)
	local fontSize = self.fontSize
	
	local tempStr = tipStringInfo_mine_info[17]
	local re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_mine_patrol_color[5][1], tipStringInfo_mine_patrol_color[5][2], tipStringInfo_mine_patrol_color[5][3]), 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
	richTextTime:pushBackElement(re)

	richTextTime:setContentSize(cc.size(gwidth, 30))
	
	self.listView184:addChild(richTextTime)
	
	self.listView184:getInnerContainer():setPositionY(99999)
	self.listView184:requestRefreshView()

end

function MineManagerPatrol:updateAll()

	self.currentTime = os.time()
	
	self.currentPatrolEndTime = _ED.manor_patrol_end_time % self.currentCountdown
	
	if self.currentPatrolEndTime == 0  then
		self.currentPatrolEndTime = self.currentCountdown
	end
	
	-- 设置奖励积累-------------------------------------------------------------------------------
	self:updateReward()
	
	
	-- 设置事件播放-------------------------------------------------------------------------------
	-- 时间, 事件描述 , 角色, 物品,个数
	self:updateIncidentMessage()

	-- 设置当前动画状态---------------------------------------------------------------------------
	-- 如果当前的状态 和 传入状态 不相等则判定进入改变
	
	local _lastSate = self.lastSate
	
	--local _lastSate = tonumber(_ED.manor_patrol_info_describe[tonumber(_ED.manor_patrol_info_number)][2])
	
	self:updateObtainCurrentSate()

	if self.lastSate ~= _lastSate then
		self:updateLastSate()
	else
		--self.lastSate = _lastSate
	end
end

-- 更新 文字消息 -- 操作数据,isBackfillTime 是否重置时间
function MineManagerPatrol:updateIncidentMessage(isBackfillTime)
	local backfillTime = nil
	if true == isBackfillTime then
		backfillTime = self.timeLabel:getString()
	end

	local root = self.roots[1]
	local listView184 = self.listView184
	listView184:removeAllItems()
	
	local gwidth = listView184:getContentSize().width
	local gheight = listView184:getContentSize().height

	local heroName, heroColor = self:getHeroInfo(tonumber(_ED.manor_patrol_hero_id))
	
	local endType = false
	
	-- local rewardSortIndexList = {}
	
	for i=1 , _ED.manor_patrol_info_number do
	
		-- local listCell = MineManagerPatrolEventList:createCell()
		-- listCell:init(1,i)
		-- listView184:addChild(listCell)
		
		local item = _ED.manor_patrol_info_describe[i]
		
		local goods = zstring.split(item[4], ",")
		
		local mouldId = tonumber(goods[1])
		local gtype = tonumber(goods[2])
		
		local goodsName = nil
		local goodsColor = nil
		
		if nil ~= mouldId and  nil ~= gtype then
			goodsName, goodsColor = self:getGoodsInfo(mouldId,gtype)
			goodsCount = goods[3]
			
			
			-- for j=1, table.getn(rewardSortIndexList) do
				-- local sitem  = rewardSortIndexList[j]
				-- if sitem[1] ~= mouldId and sitem[2] ~= gtype or  j == 1 then
					-- table.insert(rewardSortIndexList, {mouldId,gtype})
				-- end
			-- end
		end
		
		local goodsCount = goods[3]
		
		local dateStr = os.date("%X",math.floor(tonumber(item[1])/1000))
		
		local eIndex = tonumber(item[5])
		
		local eType = tonumber(item[2])
		
		local str =""
		local _richText = nil
		if eType == 0 then -- 普通
		
			str = dms.string(dms["patrol_reward"], eIndex, patrol_reward.event)
			_richText = self:cutStringMain(dateStr, str ,gwidth, heroName, heroColor, goodsName, goodsCount,  goodsColor)
		
		elseif eType == 1 then -- 暴动
			str = dms.string(dms["patrol_reward"], eIndex, patrol_reward.event)
			_richText = self:cutStringRiot(dateStr, str, gwidth)
			
		elseif eType == 2 then -- 镇压
			
			heroName  = item[3]
			heroColor = cc.c3b(tipStringInfo_mine_patrol_color[4][1], tipStringInfo_mine_patrol_color[4][2], tipStringInfo_mine_patrol_color[4][3])
			textColor = cc.c3b(tipStringInfo_mine_patrol_color[4][1], tipStringInfo_mine_patrol_color[4][2], tipStringInfo_mine_patrol_color[4][3])
		
			str = tipStringInfo_mine_info[14]
			_richText = self:cutStringMain(dateStr, str ,gwidth, heroName, heroColor, goodsName, goodsCount,  goodsColor,textColor)
			
		elseif eType == 3 then -- 结束
			endType = true
			-- 第一条起始时间 和 末尾的结束时间 的 差值
			textColor = cc.c3b(tipStringInfo_mine_patrol_color[5][1], tipStringInfo_mine_patrol_color[5][2], tipStringInfo_mine_patrol_color[5][3])
			timeLen = math.floor((item[1] - _ED.manor_patrol_info_describe[1][1])/1000) / 3600
			timeLen = math.floor(timeLen)+1
			str = string.format(tipStringInfo_mine_info[15],timeLen)..tipStringInfo_mine_info[16]
			_richText = self:cutStringMain(dateStr, str ,gwidth, heroName, heroColor, goodsName, goodsCount,  goodsColor,textColor)
		
			state_machine.excute("mine_manager_update_activity", 0, nil) 
		end
		
		if nil ~= _richText then
		
			listView184:addChild(_richText)
		
		end
	end
	
	--self.rewardSortIndexList = rewardSortIndexList
	---------------------------------------------------------------------------------
	
	if true ~= endType then
	-- 收益时间
		
		local richTextTime = ccui.RichText:create()
		richTextTime:ignoreContentAdaptWithSize(false)
		
		local fontSize = self.fontSize
		
		local tempStr = tipStringInfo_mine_info[13]
		local re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_mine_patrol_color[7][1], tipStringInfo_mine_patrol_color[7][2], tipStringInfo_mine_patrol_color[7][3]), 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
		richTextTime:pushBackElement(re)
		
		local timeTxt = ""
		
		if nil ~= backfillTime then
			timeTxt = backfillTime
		else
			timeTxt = self.countdownQueueText[tonumber(_ED.manor_patrol_income_type)+1]
		end
		
		local timeLabel = cc.Label:createWithTTF(timeTxt, "fonts/FZYiHei-M20S.ttf", fontSize)
		self.timeLabel = timeLabel
		timeLabel:setTextColor(cc.c4b(tipStringInfo_mine_patrol_color[6][1], tipStringInfo_mine_patrol_color[6][2], tipStringInfo_mine_patrol_color[6][3],255))
		timeLabel:setAnchorPoint(cc.p(0, 0))
		timeLabel:setPosition(130 ,5)
		richTextTime:addChild(timeLabel)
		
		richTextTime:setContentSize(cc.size(gwidth, 30))
		
		listView184:addChild(richTextTime)
		
		listView184:requestRefreshView()
		listView184:getInnerContainer():setPositionY(99999)
	
	else
		self:endAll()
	end
	
	---------------------------------------------------------------------------------
end

function MineManagerPatrol:getQualityColor(i)
	return cc.c3b(color_Type[i][1],
		color_Type[i][2],
		color_Type[i][3])
end

function MineManagerPatrol:getHeroInfo(mouldId)
	local name 	= dms.string(dms["ship_mould"], mouldId, ship_mould.captain_name)
	local quality = dms.int(dms["ship_mould"], mouldId, ship_mould.ship_type)+1
	

	return name, self:getQualityColor(quality)
end

function MineManagerPatrol:getGoodsInfo(mouldId, gtype)
	-- 按171奖励类型解析
	app.load("client.cells.prop.model_prop_icon_cell")
	local info = ModelPropIconCell.getGoodInfo(mouldId, gtype)

	local name 	= info.name
	local quality = info.quality

	return name, self:getQualityColor(quality)
end


function MineManagerPatrol:sortReward()
	
	for j=1, table.getn(rewardSortIndexList) do
		local sitem  = rewardSortIndexList[j]
		if sitem[1] ~= mouldId and sitem[2] ~= gtype or  j == 1 then
			table.insert(rewardSortIndexList, {mouldId,gtype})
		end
	end

end


-- 更新 奖励列表
function MineManagerPatrol:updateReward()
	
	local root = self.roots[1]
	local listView2 = ccui.Helper:seekWidgetByName(root, "ListView_42")
	
	listView2:removeAllItems()
	
	local rewardProp = zstring.split(_ED.manor_patrol_reward,"|") 
	if table.getn(rewardProp) > 0 then
		for i,v in ipairs(rewardProp) do
			local rewardPropInfo = zstring.split(v, ",")
			-- 奖励(id,类型,数量)
			local mid = tonumber(rewardPropInfo[1])
			local mtype = tonumber(rewardPropInfo[2])
			local num = tonumber(rewardPropInfo[3])
			if mtype > 0 and num > 0 then
				
			
				local reward = self:getPropCell(mid, num,mtype)
				listView2:addChild(reward)
			end
		end
		listView2:requestRefreshView()
	end
end


function MineManagerPatrol:formatTime(current_interval)

	local timeString = ""
	timeString = timeString .. string.format("%02d",math.floor(tonumber(current_interval)/3600)) .. ":"
	timeString = timeString .. string.format("%02d",math.floor((tonumber(current_interval)%3600)/60)) .. ":"
	timeString = timeString .. string.format("%02d",math.floor(tonumber(current_interval)%60))
	return timeString
end

-- 收益时间到了
function MineManagerPatrol:sendGetReward()
	
	local function responseManorUserInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			
			response.node:updateAll()
			
			response.node.isSend = false
		end
	end
	

	local str = self.userId or "0"			
	protocol_command.manor_user_init.param_list = self.mouldId.."\r\n"..str
	NetworkManager:register(protocol_command.manor_user_init.code, nil, nil, nil, instance, responseManorUserInitCallback,false)

end

-- 更新 校正巡逻时间 
function MineManagerPatrol:updateCountdown()
	
	if self.isSend == true then
		--return 
	end
	
	-- if self.isEnd == true then
		-- return 
	-- end

	if _ED.manor_patrol_end_time > 0 then

		self.text_43:setString(tipStringInfo_mine_info[11])
		
		local _time = os.time()
		
		local interval = _time - self.currentTime
		if interval >= 1 then
			
			-- 总倒计时时间
			_ED.manor_patrol_end_time = _ED.manor_patrol_end_time - interval
			self.text_44:setString(self:formatTime(_ED.manor_patrol_end_time))
			
			
			if self.currentPatrolEndTime <= 1 then
				self.isSend = true
				return self:sendGetReward()
			end
			
			-- 当前倒计时时间
			self.currentPatrolEndTime = self.currentPatrolEndTime - interval
			self.timeLabel:setString(self:formatTime(self.currentPatrolEndTime))
			self.currentTime = _time
		end
	
	-- else
		
		-- self.isEnd = true
		-- self.lastSate = 3
		-- self:updateLastSate()
		
	end
end

-- 1 类型事件用的 暴动
function MineManagerPatrol:cutStringRiot(dateStr, str, width)
	local mRoot = ccui.RichText:create()
	local fontSize = self.fontSize
	mRoot:ignoreContentAdaptWithSize(false)
	
	local strNum = 0
	
	local timeColor = cc.c3b(tipStringInfo_mine_patrol_color[1][1], tipStringInfo_mine_patrol_color[1][2], tipStringInfo_mine_patrol_color[1][3])
	-- 插入时间
	local tempStr = "["..dateStr.."]  "
	local re = ccui.RichElementText:create(1, timeColor, 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
	mRoot:pushBackElement(re)
	strNum = strNum + string.len(tempStr)
	
	local riotColor = cc.c3b(tipStringInfo_mine_patrol_color[3][1], tipStringInfo_mine_patrol_color[3][2], tipStringInfo_mine_patrol_color[3][3])
	local re = ccui.RichElementText:create(1, riotColor, 255, str, "fonts/FZYiHei-M20S.ttf", fontSize)
	mRoot:pushBackElement(re)
	strNum = strNum + string.len(str)
	
	local n = math.ceil(width / fontSize)
	
	local m = math.ceil(strNum*.5 / n)

	mRoot:setContentSize(cc.size(width, self.fontRowHeight))

	return mRoot
end



-- 1430952989901 0 吹雪 1,1,1 2  
-- 0 类型事件用的 2 3 事件
function MineManagerPatrol:cutStringMain(dateStr, str, width, heroName, heroColor,  goodsName, goodsCount,  goodsColor, textColor)
	local mRoot = ccui.RichText:create()
	local fontSize = self.fontSize
	mRoot:ignoreContentAdaptWithSize(false)
	
	-- 名字之前可能有文字也可能没有
	-- 末尾可能是物品结尾,也可能其他结尾
	
	local textColor = textColor or cc.c3b(tipStringInfo_mine_patrol_color[2][1], tipStringInfo_mine_patrol_color[2][2], tipStringInfo_mine_patrol_color[2][3])
	
	local strNum = 0
	
	
	local timeColor = cc.c3b(tipStringInfo_mine_patrol_color[1][1], tipStringInfo_mine_patrol_color[1][2], tipStringInfo_mine_patrol_color[1][3])
	-- 插入时间
	local tempStr = "["..dateStr.."]  "
	local re = ccui.RichElementText:create(1, timeColor, 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
	mRoot:pushBackElement(re)
	strNum = strNum + string.len(tempStr)
	
	
	-- 一段段分解字符串
	local startIndex,endIndex = string.find(str, "|x|")
	
	
	if startIndex > 1 then
	
		--  名字前的一段话
		local tempStr = string.sub(str, 1, startIndex-1)
		local re = ccui.RichElementText:create(1, textColor, 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
		mRoot:pushBackElement(re)
		strNum = strNum + string.len(tempStr)
	
	end
	
	-- 名字
	local tempStr = "["..heroName.."]"
	local re = ccui.RichElementText:create(1, heroColor, 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
	mRoot:pushBackElement(re)
	strNum = strNum + string.len(tempStr)
	
	-- 名字后的一段话,到物品之前
	local tempStr = string.sub(str, endIndex+1)
	local startIndex,endIndex = string.find(tempStr, "|y|")
	local tempStr = string.sub(tempStr, 1,startIndex-1)
	local re = ccui.RichElementText:create(1, textColor, 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
	mRoot:pushBackElement(re)
	strNum = strNum + string.len(tempStr)
	
	-- 物品名和数量
	local tempStr = goodsName.."x"..goodsCount
	local re = ccui.RichElementText:create(1, goodsColor, 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
	mRoot:pushBackElement(re)
	strNum = strNum + string.len(tempStr)
	
	-- 物品名之后的
	local startIndex,endIndex = string.find(str, "|y|")
	
	if string.len(string.sub(str,endIndex+1)) > 0 then

		local tempStr = string.sub(str,endIndex+1)
		local re = ccui.RichElementText:create(1, textColor, 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
		mRoot:pushBackElement(re)
		strNum = strNum + string.len(tempStr)

	end
	
	local n = math.ceil(width / fontSize)
	
	local m = math.ceil(strNum*.5 / n)
	

	mRoot:setContentSize(cc.size(width, self.fontRowHeight))

	return mRoot
end

--道具
function MineManagerPatrol:getPropCell(mid, num,mtype)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.count = num
	cellConfig.isShowName = true
	cellConfig.isDebris = true
	cellConfig.mouldType = mtype
	cellConfig.touchShowType = 1
	cell:init(cellConfig)
	return cell
end

function MineManagerPatrol:getCityBackGroundImage(index)
	local img = "images/ui/play/minemanager/bg_%d.jpg"
	return string.format(img,index)
end

function MineManagerPatrol:onEnterTransitionFinish()
    local csbMineManagerPatrol = csb.createNode("campaign/MineManager/attack_territory_patrol.csb")
	local action = csb.createTimeline("campaign/MineManager/attack_territory_patrol.csb")
    csbMineManagerPatrol:runAction(action)
	self._role_action = action
	self:addChild(csbMineManagerPatrol)
	
	
   	local root = csbMineManagerPatrol:getChildByName("root")
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_42"), nil, {func_string = [[state_machine.excute("mine_manager_manor_patrol_back", 0, "mine_manager_manor_patrol_back.'")]],
			isPressedActionEnabled = true,}, nil, 2)
	
	-- 提醒获得巡逻完毕的奖励
	self.Panel_401 = ccui.Helper:seekWidgetByName(root, "Panel_401")
	self.Panel_401:setVisible(false)
	-- 完成巡逻的角色名
	self.Text_406 = ccui.Helper:seekWidgetByName(root, "Text_406")

	-- 领取
	self.button_gain = ccui.Helper:seekWidgetByName(root, "Button_1")
	
	self.button_gain:setTouchEnabled(false)
	self.button_gain:setBright(false)
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		then 
		self.patrolPanel = ccui.Helper:seekWidgetByName(root, "Panel_syfb")
		self.patrolPanel:setVisible(false)
		self.patrolButton = ccui.Helper:seekWidgetByName(root, "Button_syfb")
		fwin:addTouchEventListener(self.patrolButton, nil, 
		{
			terminal_name = "mine_manager_manor_patrol_get_reward_double", 
			_id = self.mouldId,
			isPressedActionEnabled = true
		}, 
		nil, 0)

	end
	
	ccui.Helper:seekWidgetByName(root, "Button_403"):setVisible(false)

	
	-- 判定当前是自己还是别人
	if false == self:isMe() then
		self.button_gain:setVisible(false)
	end
	
	fwin:addTouchEventListener(self.button_gain, nil, 
	{
		terminal_name = "mine_manager_manor_patrol_get_reward", 
		_id = self.mouldId,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	self:onUpdateDraw()
	
	local userinfo = EquipPlayerInfomation:new()
	fwin:open(userinfo,fwin._view)
	self.userinfo = userinfo

end

function MineManagerPatrol:isMe()
	if nil == self._isMeSelf then
		if nil ~= self.userId  and  tonumber(_ED.user_info.user_id) ~= tonumber(self.userId) then
			self._isMeSelf =  false
		else
			self._isMeSelf =  true
		end
	end
	return self._isMeSelf
end

function MineManagerPatrol:init(_id,userId,types,friend_info)
	self.mouldId = _id
	self.userId = userId
	self.types = types
	self.friend_info = friend_info
	
	--self.lastSate = self.types

	-- self._over_time = tonumber(_ED.manor_patrol_end_time)
	-- self._save_time = os.time()
	
	-- self._start_time = os.time()
	-- self._end_time = self._save_time + tonumber(_ED.manor_patrol_end_time)
	-- self._interval = math.ceil(self._end_time - os.time())
end

function MineManagerPatrol:close()
	fwin:close(self.userinfo)
end

function MineManagerPatrol:onExit()
	state_machine.remove("mine_manager_manor_patrol_back")
	state_machine.remove("mine_manager_manor_patrol_get_reward")
end

function MineManagerPatrol:createCell()
	local cell = MineManagerPatrol:new()
	cell:registerOnNodeEvent(cell)
	return cell
end