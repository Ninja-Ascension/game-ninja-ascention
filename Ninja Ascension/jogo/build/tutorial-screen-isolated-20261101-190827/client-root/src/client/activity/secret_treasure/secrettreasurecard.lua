--[[ ----------------------------------------------------------------------------
-- 牌面
--]] ----------------------------------------------------------------------------
SecretTreasureCard = class("SecretTreasureCardClass", Window)
SecretTreasureCard.__size = nil

-- 创建Cell实例
local secret_treasure_card_create_terminal = {
	_name = "secret_treasure_card_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if SecretTreasureCard then
			local cell = SecretTreasureCard:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(secret_treasure_card_create_terminal)
state_machine.init()

-- 构造器
function SecretTreasureCard:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	-- 1背面 2正面+道具 3纯正面
	self._cardState = 0

	-- load lua files.

	-- Initialize secret treasure card page state machine.
	local function init_secret_treasure_card_terminal()
		-- 翻牌抽奖
		local secret_treasure_card_draw_terminal = {
			_name = "secret_treasure_card_draw",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 1 - 28
				local root = params._datas._self
				local index = root._index

				if not root:propIsEnough() then
					state_machine.excute("secret_treasure_prompt_1_window_open", 0, nil)
					return true
				end

				-- 禁用按钮事件
				state_machine.excute("secret_treasure_change_click_state", 0, false)

				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							local propData = response.node:getRewardInfo()
							-- debug.print_r(propData, "propData")

							local isFinalReward = SecretTreasureHandle.isGotFinalReward()
							response.node:startTurnCard(propData, isFinalReward)
						else
							-- 启用按钮事件
							state_machine.excute("secret_treasure_change_click_state", 0, true)
						end
					else
						-- 启用按钮事件
						state_machine.excute("secret_treasure_change_click_state", 0, true)
					end
				end
				-- 清空奖励内容
				_ED.show_reward_list_group = {}
				_ED.show_reward_list_group_ex = {}
				
				-- 抽一次
				protocol_command.secret_travel_draw.param_list = "" .. 1 .. "\r\n" .. (index - 1)
				NetworkManager:register(protocol_command.secret_travel_draw.code, nil, nil, nil, root, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 传送下一层
		local secret_treasure_card_go_to_next_terminal = {
			_name = "secret_treasure_card_go_to_next",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local root = params._datas._self

				local canGoNext = SecretTreasureHandle.canGoToNextFloor()
				if canGoNext then
					-- 打开确认跳转弹窗
					state_machine.excute("secret_treasure_prompt_3_window_open", 0, nil)
				else
					-- print("can't go to next")
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(secret_treasure_card_draw_terminal)
		state_machine.add(secret_treasure_card_go_to_next_terminal)
	end
	-- call func init secret treasure card state machine.
	init_secret_treasure_card_terminal()
end

-- 对象初始化
function SecretTreasureCard:init(params)
	self._index = params[1]
	self._cardState = params[2]
	self._rewardInfo = params[3]

	self:onInit(params)
	self:setContentSize(SecretTreasureCard.__size)
	return self
end

function SecretTreasureCard:onUpdateDraw()
	local root = self.roots[1]

	-- 背面
	self.Image_card_1 = ccui.Helper:seekWidgetByName(root, "Image_card_1")

	-- 正面
	self.Image_card_0 = ccui.Helper:seekWidgetByName(root, "Image_card_0")

	self.Panel_item = ccui.Helper:seekWidgetByName(root, "Panel_item")

	self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")

	self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
	fwin:removeTouchEventListener(self.Panel_1)

	self:updateUI()
end

function SecretTreasureCard:getRewardInfo()
	local rewardData = _ED.show_reward_list_group[1].show_reward_list[1]
	local propData = {rewardData.prop_type, rewardData.prop_item, rewardData.item_value}
	if tonumber(propData[1]) == 13 then
		local shipMouldID = tonumber(propData[2])
		local star = dms.int(dms["ship_mould"], shipMouldID, ship_mould.ship_star)
		if getShipByTemplateId(propData[2]) then
			star = tonumber(getShipByTemplateId(shipMouldID).StarRating)
		end
		propData[4] = star
	end
	return propData
end

function SecretTreasureCard:updateUI()
	self.Image_card_1:setVisible(false)
	self.Image_card_0:setVisible(false)
	self.Panel_item:setVisible(false)

	self.Panel_1:setTouchEnabled(false)

	self.Panel_item:removeAllChildren(true)
	self.Panel_effect:removeAllChildren(true)

	-- 1背面 2正面+道具 3传送门状态
	local cardState = self._cardState
	if cardState == 1 then
		self.Image_card_1:setVisible(true)
		self.Panel_1:setTouchEnabled(true)
		fwin:addTouchEventListener(self.Panel_1, nil,
		{
			terminal_name = "secret_treasure_card_draw",
			terminal_state = 0,
			isPressedActionEnabled = true,
			_self = self
		}, nil, 0)
	elseif cardState == 2 then
		self.Image_card_0:setVisible(true)
		self.Panel_item:setVisible(true)
		if self._rewardInfo then
			self:addRewardItem(self._rewardInfo)
		else
			local cell = state_machine.excute("secret_treasure_item_create", 0, {type = 1, reward = nil})
			self.Panel_item:addChild(cell)
		end
	elseif cardState == 3 then
		self:createEffect(false, true)

		self.Panel_1:setTouchEnabled(true)
		fwin:addTouchEventListener(self.Panel_1, nil,
		{
			terminal_name = "secret_treasure_card_go_to_next",
			terminal_state = 0,
			isPressedActionEnabled = true,
			_self = self
		}, nil, 0)
	end
end

-- 翻牌动画
-- 普通图标飞到奖励福袋里
-- 终极奖励弹窗
function SecretTreasureCard:startTurnCard(reward, isFinalReward, removeBySelf)
	self:createEffect(true, false)
	self.Panel_1:setTouchEnabled(false)
	self:addRewardItem(reward)

	local time1, time2 = 0.3, 0.5

	local quickFindMode = state_machine.excute("secret_treasure_get_quick_turn_state", 0, nil)
	if quickFindMode then
		time2 = time2/1.5
	end

	local callFunc = nil
	if isFinalReward then
		callFunc = cc.CallFunc:create(function (sender)
				state_machine.excute("secret_treasure_done_window_open", 0, reward)
				state_machine.excute("secret_treasure_change_quick_card_state", 0, false)
				state_machine.excute("secret_treasure_refresh_ui", 0, nil)
			end
		)
	else
		callFunc = cc.CallFunc:create(function (sender)
				local index = sender._index
				state_machine.excute("secret_treasure_add_fly_card", 0, {index, reward})
				state_machine.excute("secret_treasure_refresh_ui", 0, nil)
				if removeBySelf then
					sender:removeFromParent(true)
				end
			end
		)
	end

	self:runAction(cc.Sequence:create(
			cc.DelayTime:create(time1), 
			cc.CallFunc:create(function (sender)
				sender.Image_card_0:setVisible(true)
				sender.Panel_item:setVisible(true)
				sender.Panel_effect:removeAllChildren(true)
			end
			), 
			cc.DelayTime:create(time2),
			callFunc
		)
	)
end

function SecretTreasureCard:addRewardItem(reward)
	local cell = self:addResourcesIconCell(reward)
	self.Panel_item:addChild(cell)
end

-- 播放翻牌动画
function SecretTreasureCard:createEffect(isTurnAni, isLoop)
	local animationName = isTurnAni and "animation3" or "animation4"

	self.Image_card_1:setVisible(false)
	self.Image_card_0:setVisible(false)

	self.Panel_item:removeAllChildren(true)
	self.Panel_item:setVisible(false)

	local Panel_effect = self.Panel_effect
	Panel_effect:removeAllChildren(true)

	local jsonFile = "images/ui/effice/effect_secret_treasure/effect_secret_treasure.json"
	local atlasFile = "images/ui/effice/effect_secret_treasure/effect_secret_treasure.atlas"

	local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, isLoop, nil)
	sp.initArmature(animation, true)
	animation:setAnimation(0, animationName, isLoop)
	animation:setPosition(cc.p(Panel_effect:getContentSize().width/2, Panel_effect:getContentSize().height/2))
	Panel_effect:addChild(animation)
end

-- 未翻完的牌子，点击下一层开始播下落动画
function SecretTreasureCard:playDropAni()	
	if self.actions[1] then
		self.actions[1]:play("drop", false)
	else
		-- print("not find drop ani")
	end
end

function SecretTreasureCard:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end

-- 道具是否足够
function SecretTreasureCard:propIsEnough()
	local propID, costPropCount = SecretTreasureHandle.getSecretCostPropID()
	local havePropNum = tonumber(getPropAllCountByMouldId(tonumber(propID)))

	return havePropNum >= costPropCount
end

function SecretTreasureCard:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Image_card_1 = ccui.Helper:seekWidgetByName(root, "Image_card_1")
	self.Image_card_1:setVisible(false)

	self.Image_card_0 = ccui.Helper:seekWidgetByName(root, "Image_card_0")
	self.Image_card_0:setVisible(false)

	self.Panel_item = ccui.Helper:seekWidgetByName(root, "Panel_item")
	self.Panel_item:removeAllChildren(true)

	self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
	self.Panel_effect:removeAllChildren(true)

	self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
	self.Panel_1:setPosition(cc.p(0, 0))
	self.Panel_1:setRotation(0)
	self.Panel_1:setSkewX(0)
	self.Panel_1:setSkewY(0)
end

function SecretTreasureCard:onEnterTransitionFinish()
	
end

function SecretTreasureCard:onInit(params)
	-- 加载SecretTreasureCardWindow界面资源.
	-- res.activity.secret_treasure.secret_treasure_card = res/activity/secret_treasure/secret_treasure_card.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/secret_treasure/secret_treasure_card.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/secret_treasure/secret_treasure_card.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if SecretTreasureCard.__size == nil then
		SecretTreasureCard.__size = root:getContentSize()
	end

	local action = csb.createTimeline("activity/secret_treasure/secret_treasure_card.csb")
	table.insert(self.actions, action)
	root:stopAllActions()
	root:runAction(action)

	self:clearUIInfo()
	self:onUpdateDraw()
end

function SecretTreasureCard:onExit()
	-- 释放SecretTreasureCardWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/secret_treasure/secret_treasure_card.csb", root)
	-- ]]
end

function SecretTreasureCard:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SecretTreasureCard:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/secret_treasure/secret_treasure_card.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
