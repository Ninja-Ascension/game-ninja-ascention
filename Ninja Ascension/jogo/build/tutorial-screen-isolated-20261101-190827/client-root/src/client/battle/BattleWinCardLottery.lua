-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗结束翻卡牌抽奖
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
BattleWinCardLottery = class("BattleWinCardLotteryClass", Window)

function BattleWinCardLottery:ctor()
	self.super:ctor()
	self.roots = {}
	
	self.rewardList = nil
	-- 卡牌显示物品类型 
	self.current_type = 20
	self.reward = nil
	self._itime = 1
	app.load("client.cells.battle.battle_win_card_cell")
	
	 local function init_terminal()
		-- 点击后返回
		local battle_win_card_lottery_update_card_shake_terminal = {
            _name = "battle_win_card_lottery_update_card_shake",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					instance:updateCardShake()
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		local battle_win_card_lottery_update_card_turn_terminal = {
            _name = "battle_win_card_lottery_update_card_turn",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					instance:updateCardTurn()
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		local battle_win_card_addtouchclose_terminal = {
            _name = "battle_win_card_addtouchclose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					instance:addTouchClose()
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		state_machine.add(battle_win_card_lottery_update_card_shake_terminal)
		state_machine.add(battle_win_card_lottery_update_card_turn_terminal)
		state_machine.add(battle_win_card_addtouchclose_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_terminal()

	
end	


function BattleWinCardLottery:onUpdate(dt)
	-- 启动 卡牌跳跳
	if self._itime > 0 then
		--self._itime = self._itime +1
		if self._itime == 1 then
			self._itime = -1
			self._cellIndex = 1
			self.cardQueue[1]:playShake(true)
		end
	end
end

function BattleWinCardLottery:createCardCell()
	local cell = BattleWinCardCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function BattleWinCardLottery:updateCardShake()
	if self._cellIndex == -1 then
		return
	end
	self._cellIndex = self._cellIndex + 1
	if self._cellIndex > #self.cardQueue then
		self._cellIndex = 1
	end
	self.cardQueue[self._cellIndex]:playShake(true)
end

function BattleWinCardLottery:updateCardTurn()
	
	for i = 1, #self.cardQueue do
		if i ~= self._selectIndex then
			--填值显示
			local item = table.remove(self.reward)
			self.cardQueue[i]:init(self.current_type, item)
			self.cardQueue[i]:playTurn(true)
			self.cardQueue[i]:playTurn(false)
		end
	end
	
	self:showText()
end

function BattleWinCardLottery:showText()
	--显示获得
	local item = self.rewardItem

	local count = ""
	local fight_reward_count = item.fight_reward_count
	local fight_reward = item.fight_reward
	if tonumber(fight_reward) < 6 then
		count = tostring(fight_reward_count)
	end
	self.text_lottery:setVisible(false)
	self.text_acquire:setVisible(true)
	self.text_goodsName:setVisible(true)
	self.text_goodsName:setString(count..item.fight_reward_name)
	local quality = tonumber(item.fight_reward_quality)+1
	self.text_goodsName:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))

	--> print("得到了什么-------------------",item.fight_reward_name, quality,item. fight_reward_count)
	
	local text_acquireWidth = self.text_acquire:getContentSize().width
	local text_goodsNameWidth = self.text_goodsName:getContentSize().width

	local x = (fwin._width - (text_acquireWidth+text_goodsNameWidth))*0.5 + text_acquireWidth*0.5
	
	local text_acquireX = self.text_acquire:getPositionX()
	local text_goodsName = self.text_acquire:getPositionX()
	
	self.text_acquire:setPositionX(x)
	self.text_goodsName:setPositionX(x + text_acquireWidth*0.5)
	
	self.panel_touch:setVisible(true)
end

function BattleWinCardLottery:onClick(index)
	self._cellIndex = -1
	self._selectIndex = index
	self.panel_cardOne:setTouchEnabled(false)
	self.panel_cardTwo:setTouchEnabled(false)
	self.panel_cardThree:setTouchEnabled(false)
	
	--填值显示
	local rewardIndex = 0
	local item = nil
	for i = 1, #self.reward do
		 if tonumber(self.reward[i].fight_reward_extraction_state) == 1 then
			item = self.reward[i]
			rewardIndex = i
			break
		 end
	end
	table.remove(self.reward, rewardIndex)
	self.rewardItem = item
	self.cardQueue[index]:init(self.current_type, item,index)
	self.cardQueue[index]:playTurn(true)
	self.cardQueue[index]:playTurnLight(true)
	
end

function BattleWinCardLottery:gotoOriginScene()
	-- 还没抽奖,不跳走
	--> print("gotoOriginScene-----------------", self._fight_type)
	if self._cellIndex == -1  then
		-- 根据当前战斗类型,获取将去哪个界面
		if self._fight_type == _enum_fight_type._fight_type_11 then --jjc
			fwin:close(self)
			fwin:close(fwin:find("BattleSceneClass"))
			-- fwin:removeAll()
			-- cacher.removeAllObject(_object)
            cacher.removeAllTextures()
            fwin:reset(nil)
			-- fwin:removeAll()
			fwin:open(Menu:new(), fwin._taskbar)
			local before = tonumber(_ED.arena_user_rank)
			local cell = Arena:new()
			cell:init(before)
			fwin:open(cell, fwin._view)	
		elseif self._fight_type == _enum_fight_type._fight_type_10 then --抢夺
			-- 获得的物品也算抢夺的
			
			-----------记录当前场景缓存数据
			app.load("client.utils.scene.SceneCacheData")
			local cacheName = SceneCacheNameEnum.PLUNDER
			local cacheData = SceneCacheData.read(cacheName)
			if nil == cacheData then
				cacheData = SceneCacheData.getInitExample(cacheName)
			end
			
			if cacheData.rewardMouldId == nil then
			
				cacheData.rewardMouldId = tonumber(self.rewardItem.fight_reward_mould_id)
				SceneCacheData.write(SceneCacheNameEnum.PLUNDER, cacheData, "BattleWinCardLottery")
			end
			
			fwin:close(self)
			fwin:close(fwin:find("BattleSceneClass"))
			-- fwin:removeAll()
			-- cacher.removeAllObject(_object)
            cacher.removeAllTextures()
            fwin:reset(nil)
			-- fwin:removeAll()
			fwin:open(Menu:new(), fwin._taskbar)
			_ED.last_plunders_litter_page.open = 1
			local plunderWnd = Plunder:new()
			plunderWnd:init(1)
			fwin:open(plunderWnd, fwin._view)
			-- state_machine.excute("plunder_update_page",0,"")
		elseif self._fight_type == _enum_fight_type._fight_type_106 then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then	
				fwin:close(self)
				state_machine.excute("fight_reward_ror_capture_win_close",0,"")
			end
		else
			-- pvp才抽牌的,所以默认跳哪个页面就木有了,自己加吧
		end
	end
end

function BattleWinCardLottery:onUpdateDraw()

end

function BattleWinCardLottery:onEnterTransitionFinish()
	
	local csbvictory = csb.createNode("campaign/Snatch/snatch_reward.csb")
	self:addChild(csbvictory)
	local root = csbvictory:getChildByName("root")
	table.insert(self.roots, root)

	self.panel_cardOne = ccui.Helper:seekWidgetByName(root, "Panel_cq_b_1")
	self.panel_cardOne._index = 1
	
	self.panel_cardTwo = ccui.Helper:seekWidgetByName(root, "Panel_cq_b_2")
	self.panel_cardTwo._index = 2
	
	self.panel_cardThree = ccui.Helper:seekWidgetByName(root, "Panel_cq_b_3")
	self.panel_cardThree._index = 3
	
	self.cell_cardOne = self:createCardCell()
	
	self.cell_cardTwo = self:createCardCell()
	
	self.cell_cardThree = self:createCardCell()
	
	self.panel_cardOne:addChild(self.cell_cardOne)
	self.panel_cardTwo:addChild(self.cell_cardTwo)
	self.panel_cardThree:addChild(self.cell_cardThree)
	
	--self.tip = Text_32
	
	--提示请抽卡
	self.text_lottery  = ccui.Helper:seekWidgetByName(root, "Text_32")
	self.text_lottery:setVisible(true)
	--恭喜获得
	self.text_acquire  = ccui.Helper:seekWidgetByName(root, "Text_33")
	self.text_acquire:setVisible(false)
	--获得物品名
	self.text_goodsName  = ccui.Helper:seekWidgetByName(root, "Text_33_0")
	self.text_goodsName:setVisible(false)

	self.panel_touch = ccui.Helper:seekWidgetByName(root, "Panel_311")
	
	self.panel_chouqu = ccui.Helper:seekWidgetByName(root, "Panel_chouqu")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local function gotoOriginSceneHander(sender, eventType)

			if eventType == ccui.TouchEventType.ended then
				
				self:gotoOriginScene()
				sender._one_called = true
			elseif eventType == ccui.TouchEventType.began then
				
			end
		end
		
		self.panel_chouqu.callback = gotoOriginSceneHander
		self.panel_chouqu:addTouchEventListener(gotoOriginSceneHander)
	end

	self.cardQueue = {
		self.cell_cardOne,
		self.cell_cardTwo,
		self.cell_cardThree,
	}
	
	----------------------------------------------------------------
	--从ED中取出当前翻牌数据,复制完后删除ED中的数据
	self.reward = {}
	for i = 1, #_ED._snatch_fight_reward do
		table.insert(self.reward, _ED._snatch_fight_reward[i])
	end
	_ED._snatch_fight_reward = {}
	_ED._snatch_fight_reward_count = 0
	------------------------------------------------------------------
	
	local function openCardHander(sender, eventType)	
		if eventType == ccui.TouchEventType.ended then
			self:onClick(sender._index)
			sender._one_called = true
		elseif eventType == ccui.TouchEventType.began then
			
		end
	end
	
	self.panel_cardOne:addTouchEventListener(openCardHander)
	self.panel_cardTwo:addTouchEventListener(openCardHander)
	self.panel_cardThree:addTouchEventListener(openCardHander)
	
	self.panel_cardOne.callback = openCardHander
	self.panel_cardTwo.callback = openCardHander
	self.panel_cardThree.callback = openCardHander
	
	 
	 
	self:onUpdateDraw()
end

function BattleWinCardLottery:addTouchClose()
	local function gotoOriginSceneHander(sender, eventType)

		if eventType == ccui.TouchEventType.ended then
			
			self:gotoOriginScene()
		elseif eventType == ccui.TouchEventType.began then
			
		end
	end
	
	self.panel_chouqu.callback = gotoOriginSceneHander
	self.panel_chouqu:addTouchEventListener(gotoOriginSceneHander)
end
function BattleWinCardLottery:init(_fight_type)
	--> print("BattleWinCardLottery:init(_fight_type)----------------",self._fight_type )
	self._fight_type = _fight_type
end

function BattleWinCardLottery:onExit()
	state_machine.remove("battle_win_card_lottery_update_card_shake")
	state_machine.remove("battle_win_card_lottery_update_card_turn")
	state_machine.remove("battle_win_card_addtouchclose")
end
-- END
-- ----------------------------------------------------------------------------------------------------