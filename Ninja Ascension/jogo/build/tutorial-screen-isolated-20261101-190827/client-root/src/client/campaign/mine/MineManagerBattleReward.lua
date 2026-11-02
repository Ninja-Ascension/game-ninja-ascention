-- ----------------------------------------------------------------------------------------------------
-- 说明：领地 战斗结束奖励结算界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MineManagerBattleReward = class("MineManagerBattleRewardClass", Window)

function MineManagerBattleReward:ctor()
	self.super:ctor()
	app.load("client.campaign.mine.MineManagerRewardDropIcon")
	self.roots = {}
	self.rewardList = nil
	self.bTouch = false
	self.statisticsIndex = 1
	
	local function init_terminal()
		-- 点击后返回
		local mine_manager_reward_drop_draw_terminal = {
            _name = "mine_manager_reward_drop_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                
				instance:statistics()

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(mine_manager_reward_drop_draw_terminal)
		state_machine.init()
    end
    
    -- call func init hom state machine.
    init_terminal()
	
end	

function MineManagerBattleReward:statistics()
	if self.rewardList.show_reward_item_count < self.statisticsIndex then
		self.bTouch = true
		return
	end
	self:addItem(self.statisticsIndex)
end

function MineManagerBattleReward:addItem(i)

	local item = self.rewardList.show_reward_list[i]
					
	local mid = item.prop_item
	local num = item.item_value
	local mtype = item.prop_type
	
	local cell = MineManagerRewardDropIcon:createCell()
	cell:init(mid, num,mtype)
	
	self.listView1784:addChild(cell)
	
	self.statisticsIndex = self.statisticsIndex + 1
end

function MineManagerBattleReward:onEnterTransitionFinish()
	
	---模拟胜利奖励--------------------------------------------
	-- function testReward()
		-- local show_reward_view = {
			-- show_reward_type = 40,
			-- show_reward_item_count = 3,
			-- show_reward_list = {
				-- {
					-- prop_item = -1, 
					-- prop_type = 1,
					-- item_value = 1000,
				-- },
				-- {
					-- prop_item = 10, 
					-- prop_type = 6,
					-- item_value = 10,
				-- },
				-- {
					-- prop_item = 100, 
					-- prop_type = 6,
					-- item_value = 1,
				-- },
			-- }
		-- }
	
		-- _ED.show_reward_list_group[40] = show_reward_view
	-- end
	
	-- testReward()
	
	-----------------------------------------------------------

	local csbvictory = csb.createNode("campaign/MineManager/attack_territory_victoty.csb")
	self:addChild(csbvictory)
	local root = csbvictory:getChildByName("root")
	table.insert(self.roots, root)
	
	self.listView1784 = ccui.Helper:seekWidgetByName(root, "ListView_1784")
	
	self.rewardList = getSceneReward(40)
	
	
	local action = csb.createTimeline("campaign/MineManager/attack_territory_victoty.csb")
    csbvictory:runAction(action)
    action:gotoFrameAndPlay(0, action:getDuration(), false)
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
		
        if str == "icon_dorp" then
			if nil ~= self.rewardList then
				self:addItem(self.statisticsIndex)
			end
        end
    end)
	
	local sceneData = dms.element(dms["pve_scene"],_ED._current_scene_id)
	if (dms.atoi(sceneData, pve_scene.scene_type)==0) then
		_ED._fight_win_count = _ED._fight_win_count+1
	end
	
	playEffect(formatMusicFile("effect", 9996))
	
	local function backPlotScene(sender, eventType)				--点击确定
		if eventType == ccui.TouchEventType.ended and self.bTouch == true then
			
			fwin:close(instance)
			fwin:close(fwin:find("BattleSceneClass"))
			fwin:removeAll()
			app.load("client.home.Menu")
			fwin:open(Menu:new(), fwin._taskbar)
			
			-- state_machine.excute("menu_manager", 0, 
				-- {
					-- _datas = {
						-- terminal_name = "menu_manager", 	
						-- next_terminal_name = "menu_show_campaign", 
						-- current_button_name = "Button_activity",
						-- but_image = "Image_activity", 		
						-- terminal_state = 0, 
						-- isPressedActionEnabled = true
					-- }
				-- }
			-- )
			local view = MineManager:new()
			view:init(nil)
			fwin:open(view, fwin._view)	
			
		elseif eventType == ccui.TouchEventType.began then
			playEffect(formatMusicFile("button", 1))		--加入按钮音效
		end
	end
	ccui.Helper:seekWidgetByName(root, "Panel_210"):addTouchEventListener(backPlotScene)

end


function MineManagerBattleReward:init(fight_type)
	self._fight_type = fight_type
end

function MineManagerBattleReward:onExit()

end
-- END
-- ----------------------------------------------------------------------------------------------------