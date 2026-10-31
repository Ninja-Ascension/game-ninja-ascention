--[[ ----------------------------------------------------------------------------
-- 货币显示通用结构
--]] ----------------------------------------------------------------------------
CurrencyIcon = class("CurrencyIconClass", Window)
CurrencyIcon.__size = nil

-- 创建Cell实例
local currency_icon_create_terminal = {
	_name = "currency_icon_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CurrencyIcon then
			local cell = CurrencyIcon:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			cell:registerOnNoteUpdate(cell, 1)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(currency_icon_create_terminal)
state_machine.init()

-- 构造器
function CurrencyIcon:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._propType = nil
	self._propID = nil

	self.enum_type = {
		SILVER_COIN_INFORMATION = 1,				-- 	1:银币
		GOLD_COIN_INFORMATION = 2,					--	2:金币 
		REPUTATION_INFORMATION = 3,					--	3:声望 
		HERO_SOUL_INFORMATION = 4,					--	4:将魂 
		SOUL_JADE_INFORMATION = 5,					--	5:魂玉 
		PROP_INFORMATION = 6,						--	6:道具 
		EQUIPMENT_INFORMATION = 7,					--	7:装备 
		EXPERIENCE_INFORMATION = 8,					--	8:经验 
		ENDURANCE_INFORMATION = 9,					--	9:耐力 
		FUNCTION_INFORMATION = 10,					--	10:功能点 
		BATTLE_NUMBER_PEOPLE_INFORMATION = 11,		--	11:上阵人数 
		PHYSICAL_STRENGTH_INFORMATION = 12,			--	12:体力
		HERO_INFORMATION = 13,						--	13:武将 
		AREAN_RANK_INFORMATION = 14,				--	14:竞技场排名
		DPS_INFORMATION = 15,						--	15:伤害
		DUEL_INFORMATION = 16,						--	16:比武积分
		POWER_INFORMATION = 17,						--	17:霸气
		GLORIES_INFORMATION= 18,					--	18:威名
		DAILYTASK_SCORE_INFORMATION = 19,			--	19:日常任务积分
		FEATS_INFORMATION = 20,						--	20:功勋
		BATTLE_ACHIEVEMENT_INFORMATION = 21,		--	21:战功
		RECHARGE_SHOP_INFORMATION = 22,				--	22:充值商店
		UNION_CONTRIBUTION = 28,             		--  28:军团贡献
		WAR_INFORMATION = 31,             			--  31:战神令
		PET_SOUL_INFORMATION = 33,             		--  33:驯兽魂
		TALENT_POINT = 34,             				--  34:天赋点

		VIP_EXPERIENCE = 39,             			--  39:VIP经验
		SKIN_COIN_INFORMATIO = 64,                  -- 皮肤
		ALLOY_MATRIX = 66,             				--  66:数码合金
		MATRIX_ESSENCE = 67,             		    --  66:数码合金精华
		EXPLORE_MONEY = 68,							-- 68:探索币
		HOLY_ESSENCE = 69,							-- 69:圣物精华
		EXPLORE_MONEY1 = 70,						-- 70:探索币（口袋）
		SILKBAG_INFORMATION=71,						-- 71:锦囊
		MAGIC_ANIMAL_INFORMATION=72,				-- 72:神兽整卡
		FIGHT_SPIRIT=73,							-- 73:战魂
		CASH_VOUCHER = 74,							-- 74:代金券
	}

	self.resData = {		
		[self.enum_type.SILVER_COIN_INFORMATION] = {resPath = "image/common/currency/common_currency_2.png", terminal_name = "sm_buy_silver_coinsopen", isShowBtn = true},
		[self.enum_type.GOLD_COIN_INFORMATION] = {resPath = "image/common/currency/common_currency_1.png", terminal_name = "activity_home_recharge_button", isShowBtn = true},
		-- [self.enum_type.REPUTATION_INFORMATION] = {resPath = ""},
		-- [self.enum_type.HERO_SOUL_INFORMATION] = {resPath = ""},
		-- [self.enum_type.EXPERIENCE_INFORMATION] = {resPath = ""},
		-- [self.enum_type.ENDURANCE_INFORMATION] = {resPath = ""},
		-- [self.enum_type.FUNCTION_INFORMATION] = {resPath = ""},
		[self.enum_type.PHYSICAL_STRENGTH_INFORMATION] = {resPath = "image/common/currency/common_currency_5.png", terminal_name = "sm_buy_physicalopen", isShowBtn = true},
		-- [self.enum_type.GLORIES_INFORMATION] = {resPath = ""},
		-- [self.enum_type.FEATS_INFORMATION] = {resPath = ""},
		-- [self.enum_type.PET_SOUL_INFORMATION] = {resPath = ""},
		-- [self.enum_type.TALENT_POINT] = {resPath = ""},
	}

	-- load lua files.

	-- Initialize lim pool record list page state machine.
	local function init_currency_icon_terminal()
		-- 触发货币购买事件
		local currency_icon_click_terminal = {
			_name = "currency_icon_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local customTerminalName = params._datas.customTerminalName
				state_machine.excute(customTerminalName, 0, 0)

				if params._datas.customCallback ~= nil then
					params._datas.customCallback()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(currency_icon_click_terminal)
	end
	-- call func init lim pool record list state machine.
	init_currency_icon_terminal()
end

-- 对象初始化
-- currencyInfo = {propType = "", propID = ""}
function CurrencyIcon:init(params)
	self._propType = tonumber(params.propType)
	self._propID = tonumber(params.propID)
	self._callback = params.callback

	self:onInit(params)
	self:setContentSize(CurrencyIcon.__size)
	return self
end

function CurrencyIcon:updateUI()
	local root = self.roots[1]

	local propType = self._propType
	local propyID = self._propID

	local resPath = ""
	local isShowBtn = false
	local terminal_name = ""

	if self.resData[propType] ~= nil then
		resPath = self.resData[propType].resPath
		isShowBtn = self.resData[propType].isShowBtn
		terminal_name = self.resData[propType].terminal_name

		if propType == self.enum_type.PHYSICAL_STRENGTH_INFORMATION then
			self.max_user_food = dms.int(dms["user_experience_param"], _ED.user_info.user_grade, user_experience_param.combatFoodCapacity)
		end
	else
		if propType == self.enum_type.PROP_INFORMATION then
			local icon_index = dms.int(dms["prop_mould"], propyID, prop_mould.pic_index)
			resPath = string.format("image/common/currency/common_currency_%d.png", icon_index)
		end
	end
	-- print("resPath = ", resPath)

	self.Panel_1:removeBackGroundImage()
	self.Panel_1:setBackGroundImage(resPath)

	self.Button_add:setVisible(isShowBtn)
	if isShowBtn == true and terminal_name ~= "" then
		self.Button_add = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil,
		{
			terminal_name = "currency_icon_click",
			terminal_state = 0,
			isPressedActionEnabled = true,
			customTerminalName = terminal_name,
			customCallback = self._callback,
		}, nil, 0)
	end

	self:updateCurrencyCount()
end

function CurrencyIcon:onUpdateDraw()
	local root = self.roots[1]

	-- 货币图标
	self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")

	-- 货币数量
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")

	-- 货币数量
	self.Button_add = ccui.Helper:seekWidgetByName(root, "Button_add")

	self:updateUI()
end

function CurrencyIcon:updateCurrencyCount()
	if self._propType == self.enum_type.PHYSICAL_STRENGTH_INFORMATION then
		if self.user_food ~= _ED.user_info.user_food then
			self.user_food = _ED.user_info.user_food
			self.Text_1:setString(self.user_food .. "/" .. self.max_user_food)

			-- Label_power_left:setString(self.user_food)
			-- Label_power_right:setString(self.max_user_food)
			-- if tonumber(self.user_food) > tonumber(self.max_user_food) then
			-- 	Label_power_left:setColor(cc.c3b(0,255,0))
			-- else
			-- 	Label_power_left:setColor(cc.c3b(255,255,255))
			-- end
		end
	elseif self._propType == self.enum_type.SILVER_COIN_INFORMATION then
		if self.user_silver ~= _ED.user_info.user_silver then
			self.user_silver = _ED.user_info.user_silver
			if tonumber( self.user_silver)> 10000 then
				self.Text_1:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
			else
				self.Text_1:setString(self.user_silver)
			end
		end
	elseif self._propType == self.enum_type.GOLD_COIN_INFORMATION then
		if self.user_gold ~= _ED.user_info.user_gold then
			self.user_gold = _ED.user_info.user_gold
			if tonumber( self.user_gold)> 1000000 then
				self.Text_1:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
			else
				self.Text_1:setString(self.user_gold)
			end
		end
	elseif self._propType == self.enum_type.PROP_INFORMATION then
		self.havePropNum = tonumber(getPropAllCountByMouldId(self._propID))
		if self.havePropNum > 10000 then
			self.Text_1:setString(math.floor(self.havePropNum / 1000) .. string_equiprety_name[40])
		else
			self.Text_1:setString(self.havePropNum)
		end

	end
end

function CurrencyIcon:onUpdate(dt)
	self:updateCurrencyCount()
end

function CurrencyIcon:onEnterTransitionFinish()
	
end

function CurrencyIcon:onInit(params)
	-- 加载CurrencyIconWindow界面资源.
	-- res.utils.common_currency_1.csb = res/utils/common_currency_1.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("utils/common_currency_1.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("utils/common_currency_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CurrencyIcon.__size == nil then
		CurrencyIcon.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function CurrencyIcon:onExit()
	-- 释放CurrencyIconWindow界面资源.

	-- [[ 释放缓存
	-- local root = self.roots[1]
	-- cacher.freeRef("utils/common_currency_1.csb", root)
	-- ]]
end

function CurrencyIcon:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CurrencyIcon:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	-- cacher.freeRef("utils/common_currency_1.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
