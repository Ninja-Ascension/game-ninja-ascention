----------------------------------------------------------------------------------------------------
-- 说明：胜利后卡牌动画
-------------------------------------------------------------------------------------------------------
BattleWinCardCell = class("BattleWinCardCellClass", Window)

function BattleWinCardCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.armature = {}
	
	app.load("client.cells.prop.prop_icon_cell")
end

-- 卡牌抖动动画
function BattleWinCardCell:playShake(isSend)
	self.roots[1]:stopAllActions()
	self.action = csb.createTimeline("campaign/Snatch/snatch_reward_card.csb")
	self.action:play("window_open", false)
	self.roots[1]:runAction(self.action)
	self.action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end
		
		local str = frame:getEvent()
		if str == "window_open_over" then
			if isSend == true then
				state_machine.excute("battle_win_card_lottery_update_card_shake",0,{target = self})
			end
		elseif str == "over" then
		end
    end)
end

-- 卡牌翻转动画
function BattleWinCardCell:playTurn(isSend)
	self.roots[1]:stopAllActions()
	self.action = csb.createTimeline("campaign/Snatch/snatch_reward_card.csb")
	self.action:play("card_flop", false)
	self.roots[1]:runAction(self.action)
	self.action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end
		
		local str = frame:getEvent()
		if str == "window_open_over" then
		elseif str == "over" then
			if isSend == true then
				state_machine.excute("battle_win_card_lottery_update_card_turn",0,{target = self})
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					state_machine.excute("battle_win_card_addtouchclose")
				end
			end
			
			self:showGoods()
		end
    end)
end

-- 卡牌翻转动画后的高亮状态
function BattleWinCardCell:playTurnLight(isSend)
	if isSend == true then
		local panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_cd_light")
		panel:setVisible(true)
		-- local action = ccui.Helper:seekWidgetByName(root, "Panel_cd_light"):getChildByName("")
	end
end

--动画结束,显示获得物-- 物品id x个数
function BattleWinCardCell:showGoods()
	local cell = PropIconCell:createCell()
	--> print("卡牌的道具信息------------------------",self.current_type)
	cell:init(self.current_type, self.prop)
	self.panel_grid:addChild(cell)
end

-- 物品模板id x数量
function BattleWinCardCell:init(interfaceType, prop)
	self.current_type = interfaceType
	self.prop = prop
end

-- 离开
function BattleWinCardCell:toExit()
	
end

function BattleWinCardCell:onUpdateDraw()
	
end

function BattleWinCardCell:onEnterTransitionFinish()
    local csbItem = csb.createNode("campaign/Snatch/snatch_reward_card.csb")
	local root = csbItem:getChildByName("root")
	--root:removeFromParent(true)
	self:addChild(csbItem)
	table.insert(self.roots, root)
	
	self.panel_grid = ccui.Helper:seekWidgetByName(root, "Panel_7_5")
	
	self.action = csb.createTimeline("campaign/Snatch/snatch_reward_card.csb")
	
	-- self.action:setFrameEventCallFunc(function (frame)
		-- if nil == frame then
			-- return
		-- end
		
		-- local str = frame:getEvent()
		--> print("str---------------------",str)
		-- if str == "window_open_over" then
			-- self:onPlayShakeEnd()

		-- elseif str == "over" then
		
		-- end
    -- end)
	
	-- self.action:play("window_open", true)
	-- self.roots[1]:runAction(self.action)
	
	
	
	-- self:playShake()
	-- self:onUpdateDraw()
end

function BattleWinCardCell:onExit()
	--state_machine.remove("battle_player_head_update")
end
