-- ----------------------------------------------------------------------------------------------------
-- 说明：奖励提示界面
-- 如果是获得英雄 -- 设置一下getHero 在退出的时候显示动画界面
-------------------------------------------------------------------------------------------------------
AdventureTipReward = class("AdventureTipRewardClass", Window)
    
function AdventureTipReward:ctor()
    self.super:ctor()
    self.roots = {}
	self.reward = nil
	self.getHero = false
	self.accidentRewardList = {}
	self.isAccident = false
	self.rewardCount = 0
	self.list_huode1 = nil 
	self.list_huode2 = nil 
    -- Initialize adventure battle reward state machine.
    local function init_adventure_battle_reward_terminal()
		local adventure_tip_reward_open_accident_terminal = {
            _name = "adventure_tip_reward_open_accident",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local  data = params._datas
            	--{list = self.accidentRewardList,index = 1}
            	if params._datas.list ~= nil and #params._datas.list > 0 then 
            		-- 有意外奖励
            		fwin:open(AdventureAccidentReward:new():init(data.list), fwin._ui)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

		local adventure_tip_reward_close_window_terminal = {
	        _name = "adventure_tip_reward_close_window",
	        _init = function (terminal)
	            app.load("client.adventure.system.share.AdventureShareDialog")
	            app.load("client.adventure.duplicate.AdventureDuplicateBattleDlg")
	        end,
	        _inited = false,
	        _instance = self,
	        _state = 0,
	        _invoke = function(terminal, instance, params)
	        	instance:checkMineBossReward()
	        	if missionIsOver() == true then 
	        		state_machine.excute("adventure_tip_reward_open_accident",0,{_datas = {list = instance.accidentRewardList}})
	        	end
	        	fwin:close(fwin:find("AdventureTipRewardClass"))	        	
	            return true
	        end,
	        _terminal = nil,
	        _terminals = nil,
    	}	
		state_machine.add(adventure_tip_reward_open_accident_terminal)
		state_machine.add(adventure_tip_reward_close_window_terminal)
        state_machine.init()

    end
    -- call func init adventure battle reward state machine.
    init_adventure_battle_reward_terminal()
end

function AdventureTipReward:init(reward)
	self.reward = reward
	return self
end

function AdventureTipReward:checkMineBossReward()
	if tonumber(self.reward.show_reward_type) == 15 then 
		if AdventureDuplicateBattleDlg.__mine_boss_name ~= "" then
			local shareInfo = string.format(_share_text[2],"" .. AdventureDuplicateBattleDlg.__mine_boss_name )
		 	state_machine.excute("adventure_open_share_dialog",0,shareInfo)
		end
	end
end


function AdventureTipReward:onUpdateDraw()
	local root = self.roots[1]
	
	local _width = 0
	local _nCount = 0
	-- 类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 11:上阵人数 12:体力 
	-- 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气 18 威名 19 日常任务积分 20功勋 
	-- 21战功 22日常副本基础奖励 23日常副本额外奖励 24出击令 25免战时间)29排位胜点
	self.accidentRewardList = {}
	self.isAccident = false
	self.rewardCount = 0 
	
	local rewardItems = {}
	if self.reward.show_reward_list == nil then 
	
		return
	end

	for i, v in pairs(self.reward.show_reward_list) do
		if zstring.tonumber(v.prop_type) == 7 or zstring.tonumber(v.prop_type) == 26 or zstring.tonumber(v.prop_type) == 27 or zstring.tonumber(v.prop_type) == 28 then
			app.load("client.adventure.reward.AdventureAccidentReward")
			table.insert(self.accidentRewardList,v)
			self.isAccident = true
		end	
		local cell = adventureNewSmallPropIconCell:createCell()
		if zstring.tonumber(v.prop_type) == 1 then
			cell:init(0, {resource_type = 1} , "" .. getResourceValueToStringForAdventure(v.item_value), nil, 0, 0)
			--ListView_huode:addChild(cell)
			table.insert(rewardItems,cell)
			_width = cell:getContentSize().width
			_nCount = _nCount + 1
		elseif zstring.tonumber(v.prop_type) == 2 then
			cell:init(0, {resource_type = 2} , "" .. getResourceValueToStringForAdventure(v.item_value), nil, 0, 0)
			--ListView_huode:addChild(cell)
			table.insert(rewardItems,cell)
			_width = cell:getContentSize().width
			_nCount = _nCount + 1
		elseif zstring.tonumber(v.prop_type) == 3 then
			cell:init(0, {resource_type = 3} , "" .. getResourceValueToStringForAdventure(v.item_value), nil, 0, 0)
			--ListView_huode:addChild(cell)
			table.insert(rewardItems,cell)
			_width = cell:getContentSize().width
			_nCount = _nCount + 1
		elseif zstring.tonumber(v.prop_type) == 4 then
			cell:init(0, {resource_type = 4} , "" .. getResourceValueToStringForAdventure(v.item_value), nil, 0, 0)
			--ListView_huode:addChild(cell)
			table.insert(rewardItems,cell)
			_width = cell:getContentSize().width
			_nCount = _nCount + 1
		elseif zstring.tonumber(v.prop_type) == 6 then
			cell:init(0, {mould_id = v.prop_item} , "" .. getResourceValueToStringForAdventure(v.item_value), nil, 0, 0)
			--ListView_huode:addChild(cell)
			table.insert(rewardItems,cell)
			_width = cell:getContentSize().width
			_nCount = _nCount + 1
		elseif zstring.tonumber(v.prop_type) == 8 then	
			cell:init(0, {resource_type = 8} , "" .. getResourceValueToStringForAdventure(v.item_value), nil, 0, 0)
			--ListView_huode:addChild(cell)
			table.insert(rewardItems,cell)
			_width = cell:getContentSize().width
			_nCount = _nCount + 1
		elseif zstring.tonumber(v.prop_type) == 13 then		
			self.getHero = true
		elseif zstring.tonumber(v.prop_type) == 29 then		 --胜点
			cell:init(0, {resource_type = 25} , "" .. getResourceValueToStringForAdventure(v.item_value), nil, 0, 0)
			--ListView_huode:addChild(cell)
			table.insert(rewardItems,cell)
			_width = cell:getContentSize().width
			_nCount = _nCount + 1
		elseif zstring.tonumber(v.prop_type) == 30 then		 --积分
			cell:init(0, {resource_type = 26} , "" .. getResourceValueToStringForAdventure(v.item_value), nil, 0, 0)
			--ListView_huode:addChild(cell)
			table.insert(rewardItems,cell)
			_width = cell:getContentSize().width
			_nCount = _nCount + 1
		end
	end
	local show_listView = nil

	if _nCount > 6 then 
		show_listView = self.list_huode2
		show_listView:setVisible(true)
		self.list_huode1:setVisible(false)
	else
		show_listView = self.list_huode1
		show_listView:setVisible(true)
		self.list_huode1:setVisible(true)
		self.list_huode2:setVisible(false)
		
		if show_listView._x == nil then
			show_listView._x = self.list_huode1:getPositionX()
		end
		show_listView:setPositionX(show_listView._x - (80 + show_listView:getItemsMargin()) * (_nCount - 1) / 2)
	end
	show_listView:setTouchEnabled(true)
	for k,v in pairs(rewardItems) do
		show_listView:addChild(v)
		show_listView:requestRefreshView()		
	end
	show_listView:requestRefreshView()		
	
	self.rewardCount = _nCount

	if self.rewardCount == 0 and self.isAccident == true and #self.accidentRewardList > 0 then 
		--单纯的显示意外奖励
		if missionIsOver() == true then 
			state_machine.excute("adventure_tip_reward_open_accident", 0, {_datas = {list = self.accidentRewardList}})
		end		
		fwin:close(fwin:find("AdventureTipRewardClass"))
	end
	
	if self.getHero == true and _nCount == 0 then
		fwin:close(fwin:find("AdventureTipRewardClass"))
	end
end

function AdventureTipReward:onEnterTransitionFinish()
	local csbAdventureBattleReward = csb.createNode("battle/battle_huodejiangli.csb")
    local root = csbAdventureBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleReward)
    self.list_huode1 = ccui.Helper:seekWidgetByName(root, "ListView_huode")
	self.list_huode2 = ccui.Helper:seekWidgetByName(root, "ListView_huode_1")
	self:onUpdateDraw()
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        terminal_name = "adventure_tip_reward_close_window",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
	-- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reward"),       nil, 
    {
        terminal_name = "adventure_tip_reward_close_window",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureTipReward:onExit()
	if self.getHero == true then
		self.getHero = false
		local heroIds = zstring.split(_ED.recruit_success_ship_ids, ",")
		---有些地方必须要调用　AdventureRecruitSuccess　如新手指引　绑定了　不鞥呢用十连抽
		local Window1 = fwin:find("AdventureArenaWarcraftClass")
        local Window2 = fwin:find("AdventureArenaWarcraftListClass")
		if #heroIds > 1 then 
			app.load("client.adventure.shop.recruit.AdventureRecruitSuccessTen")
			
            if Window1~= nil or Window2 ~= nil then 
            	fwin:open(AdventureRecruitSuccessTen:new():init(), fwin._windows)
            else
            	fwin:open(AdventureRecruitSuccessTen:new():init(), fwin._ui)
            end
		else 
			app.load("client.adventure.shop.recruit.AdventureRecruitSuccess")
			
			if Window1~= nil or Window2 ~= nil then 
            	fwin:open(AdventureRecruitSuccess:new():init(), fwin._windows)
            else
            	fwin:open(AdventureRecruitSuccess:new():init(), fwin._ui)
            end
		end
		
	end
end