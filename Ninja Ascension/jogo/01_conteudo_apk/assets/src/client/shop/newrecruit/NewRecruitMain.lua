--[[ ----------------------------------------------------------------------------
-- 新招募主界面
--]] ----------------------------------------------------------------------------
NewRecruitMain = class("NewRecruitMainClass", Window)

-- 打开窗口
local new_recruit_main_window_open_terminal = {
	_name = "new_recruit_main_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("NewRecruitMainClass") then
			fwin:open(NewRecruitMain:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local new_recruit_main_window_close_terminal = {
	_name = "new_recruit_main_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		state_machine.excute("notification_center_update", 0, "push_notification_center_new_recruit_system")
		fwin:close(fwin:find("NewRecruitMainClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(new_recruit_main_window_open_terminal)
state_machine.add(new_recruit_main_window_close_terminal)
state_machine.init()

-- 构造器
function NewRecruitMain:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.deltaTime = 1
	self.totalTime = 0

	self.wishListNotEnd = true		-- 心愿单未结束
	self.firstLoginRightOne = false	-- 首次注册右侧列表红点一
	self.firstLoginRightTwo = false	-- 首次注册右侧列表红点二
	self._cell_list	= {}			-- 切换按钮cell列表

	-- load lua files.
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_money_icon")

	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.shop.newrecruit.NewRecruitCardRecord")
	app.load("client.shop.newrecruit.NewRecruitPreviewWindow")
	app.load("client.shop.newrecruit.NewRecruitShop")
	app.load("client.shop.newrecruit.NewRecruitWish")
	app.load("client.shop.newrecruit.NewRecruitRule")
	app.load("client.shop.newrecruit.NewRecruitBuyTips")
	app.load("client.utils.CurrencyIcon")

	app.load("client.shop.recruit.HeroRecruitSuccess")
	app.load("client.shop.recruit.HeroRecruitSuccessTen")
	
	app.load("client.reward.DrawRareReward")
	app.load("client.activity.lim_summon.LimSummonViewMain")
	
	-- Initialize lim pool page state machine.
	local function init_new_recruit_main_terminal()
		-- 打开角色创建窗口
		local new_recruit_main_open_terminal = {
			_name = "new_recruit_main_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local new_recruit_main_close_terminal = {
			_name = "new_recruit_main_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("new_recruit_main_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local new_recruit_main_show_terminal = {
			_name = "new_recruit_main_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local new_recruit_main_hide_terminal = {
			_name = "new_recruit_main_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 抽取奖励（1次 10次）
		local new_recruit_main_get_reward_terminal = {
			_name = "new_recruit_main_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local times = params._datas.times
				local m_type = params._datas.m_type
				local state = instance:getCanDrawReward(times)
				if not state then
					-- TipDlg.drawTextDailog(tipStringInfo_activity_limit_pool[5])
					state_machine.excute("new_recruit_buy_tips_window_open", 0, nil)
					return true
				end

				state_machine.excute("new_recruit_main_lock_button", 0, nil)
				
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
							if fwin:find("HeroRecruitSuccessClass") ~= nil then
								fwin:close(fwin:find("HeroRecruitSuccessClass"))
							end

							if fwin:find("HeroRecruitSuccessTenClass") ~= nil then
								fwin:close(fwin:find("HeroRecruitSuccessTenClass"))
							end

							getSceneReward(64)
							_ED.show_reward_list_group_ex = {}

							if times == 1 then
								local obj = HeroRecruitSuccess:new()
								obj:setRanking(herorIndex, m_type, true)
								fwin:open(obj, fwin._ui)
								
								-- app.load("client.reward.DrawRareReward")
								-- local getRewardWnd = DrawRareReward:new()
								-- getRewardWnd:init(7)
								-- fwin:open(getRewardWnd, fwin._ui)
							elseif times == 10 then
								local obj = HeroRecruitSuccessTen:new()
								obj:setRanking(herorIndex, m_type, true)
								fwin:open(obj, fwin._ui)
								-- app.load("client.reward.DrawRareReward")
								-- local getRewardWnd = DrawRareReward:new()
								-- getRewardWnd:init(7)
								-- fwin:open(getRewardWnd, fwin._ui)
							end
							-- state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
							state_machine.excute("new_recruit_main_refresh_ui", 0, 0)
							state_machine.excute("new_recruit_main_update_redDot", 0, nil)
							-- -- 刷新活动按钮红点
							-- state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 168)
							-- 刷新道具的数量
							-- state_machine.excute("lim_user_top_info_refresh_prop_count", 0, 0)	
							-- state_machine.excute("new_recruit_main_unlock_button", 0, nil)
						else
							state_machine.excute("new_recruit_main_unlock_button", 0, nil)
						end
					else
						state_machine.excute("new_recruit_main_unlock_button", 0, nil)
					end
					_ED.prop_chest_store_recruiting = false
				end

				_ED.new_prop_object = {}
				_ED.recruit_success_ship_id = nil
				_ED.new_reward_object = {}
				_ED.prop_chest_store_recruiting = true
				_ED.newRecruitInfo.doubleRemoveTimes = 0
				_ED.newRecruitInfo.doubleReward = nil

				protocol_command.new_recruitment_system.param_list = "" .. times
				NetworkManager:register(protocol_command.new_recruitment_system.code, nil, nil, nil, instance, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 心愿单
		local new_recruit_main_open_wish_list_terminal = {
			_name = "new_recruit_main_open_wish_list",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					state_machine.excute("new_recruit_wish_window_open", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 奖励预览
		local new_recruit_main_open_reward_preview_terminal = {
			_name = "new_recruit_main_open_reward_preview",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					state_machine.excute("new_recruit_preview_window_open", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 招募商店
		local new_recruit_main_open_recruit_shop_terminal = {
			_name = "new_recruit_main_open_recruit_shop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					-- local function responseCallback(response)
					-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					-- 		app.load("client.shop.newrecruit.NewRecruitShop")
					-- 		state_machine.excute("new_recruit_shop_window_open", 0, nil)
					-- 	end
					-- end
					-- protocol_command.new_recruitment_shop_enter.param_list = ""
					-- NetworkManager:register(protocol_command.new_recruitment_shop_enter.code, nil, nil, nil, instance, responseCallback, false, nil)
					state_machine.excute("new_recruit_shop_window_open", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 历史记录
		local new_recruit_main_open_history_record_terminal = {
			_name = "new_recruit_main_open_history_record",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local curPage = 1
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								state_machine.excute("new_recruit_card_record_window_open", 0, {curPage})
							end
						end
					end
					-- protocol_command.view_draw_items.param_list = ""
					-- NetworkManager:register(protocol_command.view_draw_items.code, nil, nil, nil, instance, responseCallback, false, nil)
					protocol_command.view_draw_items.param_list = ""
					NetworkManager:register(protocol_command.view_draw_items.code, nil, nil, nil, instance, responseCallback, false, nil)
					-- state_machine.excute("new_recruit_card_record_window_open", 0, {curPage})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新主界面
		local new_recruit_main_refresh_ui_terminal = {
			_name = "new_recruit_main_refresh_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开规则界面
		local new_recruit_main_rule_open_terminal = {
			_name = "new_recruit_main_rule_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					state_machine.excute("new_recruit_rule_window_open", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭心愿单icon
		local new_recruit_main_close_wishlist_terminal = {
			_name = "new_recruit_main_close_wishlist",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:hideWishList()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新界面红点
		local new_recruit_main_update_redDot_terminal = {
			_name = "new_recruit_main_update_redDot",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:updateRedDot()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 锁住所有按钮的状态机
		local new_recruit_main_lock_button_terminal = {
			_name = "new_recruit_main_lock_button",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					
					state_machine.lock("new_recruit_main_get_reward")					-- 抽奖状态机
					state_machine.lock("new_recruit_main_close")						-- 关闭状态机
					state_machine.lock("new_recruit_main_rule_open")					-- 规则状态机
					state_machine.lock("new_recruit_main_open_wish_list")				-- 心愿单状态机
					state_machine.lock("new_recruit_main_open_reward_preview")			-- 奖励预览状态机
					state_machine.lock("new_recruit_main_open_recruit_shop")			-- 商店状态机
					state_machine.lock("new_recruit_main_open_history_record")			-- 历史记录状态机
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开所有按钮的状态机
		local new_recruit_main_unlock_button_terminal = {
			_name = "new_recruit_main_unlock_button",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					state_machine.unlock("new_recruit_main_get_reward")					-- 抽奖状态机
					state_machine.unlock("new_recruit_main_close")						-- 关闭状态机
					state_machine.unlock("new_recruit_main_rule_open")					-- 规则状态机
					state_machine.unlock("new_recruit_main_open_wish_list")				-- 心愿单状态机
					state_machine.unlock("new_recruit_main_open_reward_preview")			-- 奖励预览状态机
					state_machine.unlock("new_recruit_main_open_recruit_shop")			-- 商店状态机
					state_machine.unlock("new_recruit_main_open_history_record")			-- 历史记录状态机
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


		state_machine.add(new_recruit_main_open_terminal)
		state_machine.add(new_recruit_main_close_terminal)
		state_machine.add(new_recruit_main_show_terminal)
		state_machine.add(new_recruit_main_hide_terminal)
		state_machine.add(new_recruit_main_get_reward_terminal)
		state_machine.add(new_recruit_main_open_wish_list_terminal)
		state_machine.add(new_recruit_main_open_reward_preview_terminal)
		state_machine.add(new_recruit_main_open_recruit_shop_terminal)
		state_machine.add(new_recruit_main_open_history_record_terminal)
		state_machine.add(new_recruit_main_refresh_ui_terminal)
		state_machine.add(new_recruit_main_rule_open_terminal)
		state_machine.add(new_recruit_main_close_wishlist_terminal)
		state_machine.add(new_recruit_main_update_redDot_terminal)
		state_machine.add(new_recruit_main_lock_button_terminal)
		state_machine.add(new_recruit_main_unlock_button_terminal)
		state_machine.init()
	end
	-- call func init lim pool state machine.
	init_new_recruit_main_terminal()
end

-- 对象初始化
function NewRecruitMain:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function NewRecruitMain:onInit(params)
	
end

-- 隐藏心愿单
function NewRecruitMain:hideWishList()
	_ED.active_activity[184] = nil
	self:showRightList()
end

-- 是否可以抽奖
function NewRecruitMain:getCanDrawReward(times)
	if times == 1 then
		if(self:isHaveFreeTimes()) then
			return true
		end
	end
	if(self:haveEnoughProp(times)) then
		return true
	end
	if(self:haveEnoughDiamond(times)) then
		return true
	end
	return false
end

-- 获取招募券道具id
function NewRecruitMain:getNeedCostPropID()
	local propID = tonumber(zstring.split(dms.string(dms["play_config"], 255, activity_config.param), ",")[2])
	return propID
end

-- 获取消耗招募券的数量
function NewRecruitMain:getNeedCostPropCount(times)
	local needCount = 0
	local needInfo = dms.string(dms["play_config"], 258, play_config.param)
	if times == 1 then
		needCount = tonumber(zstring.split(needInfo, ",")[1])
	else
		needCount = tonumber(zstring.split(needInfo, ",")[2])
	end
	return needCount
end

-- 获取消耗钻石的数量
function NewRecruitMain:getNeedCostDiamondCount(times)
	local needCount = 0
	local needInfo = dms.string(dms["play_config"], 257, play_config.param)
	if times == 1 then
		needCount = tonumber(zstring.split(needInfo, ",")[1])
	else
		needCount = tonumber(zstring.split(needInfo, ",")[2])
	end
	return needCount
end

-- 1/10抽消耗招募券的数量
-- 次数, 道具id
function NewRecruitMain:haveEnoughProp(times)
	local needCount = self:getNeedCostPropCount(times)
	local propID = self:getNeedCostPropID()
	local havePropNum = tonumber(getPropAllCountByMouldId(propID))
	return havePropNum >= needCount
end

-- 1/10抽消耗钻石的数量
function NewRecruitMain:haveEnoughDiamond(times)
	local needCount = self:getNeedCostDiamondCount(times)
	local havePropNum = _ED.user_info.user_gold
	return tonumber(havePropNum) >= tonumber(needCount)
end

-- 免费次数是否使用
function NewRecruitMain:isHaveFreeTimes()
	local result = true
	local data = _ED.newRecruitInfo
	local freeTime = data.free_times
	result = (freeTime > 0)
	return result
end

-- 更新红点
function NewRecruitMain:updateRedDot()
	fwin:addService({
		callback = function ( params )
			state_machine.excute("notification_center_update", 0, "push_notification_center_new_recruit_free")
			state_machine.excute("notification_center_update", 0, "push_notification_center_new_recruit_ten")
			state_machine.excute("notification_center_update", 0, "push_notification_center_new_recruit_shop")
		end,
		delay = 0,
	})

	if _ED.active_activity[184] ~= nil then
		state_machine.excute("notification_center_update", 0, "push_notification_center_new_recruit_wishlist")
	end
	self:refreshChangeReddot()
end


-- 绘制红点
function NewRecruitMain:initDrawRedDot()
	local root = self.roots[1]
	-- 抽取一次免费红点
	local oneDot =  ccui.Helper:seekWidgetByName(root, "Image_red")
	oneDot:setVisible(false)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_new_recruit_free",
	_widget = oneDot,
	_invoke = nil,
	_interval = 0.5,})

	-- 十连红点
	local tenDot =  ccui.Helper:seekWidgetByName(root, "Image_red_2")
	tenDot:setVisible(false)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_new_recruit_ten",
	_widget = tenDot,
	_invoke = nil,
	_interval = 0.5,})

end

-- 包含心愿单的红点
function NewRecruitMain:initDrawRightOne()
	local root = self.roots[1]
	self.firstLoginRightOne = true
	-- 招募商店红点
	local shopDot =  ccui.Helper:seekWidgetByName(root, "Image_red_4")
	shopDot:setVisible(false)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_new_recruit_shop",
	_widget = shopDot,
	_invoke = nil,
	_interval = 0.5,})

	local wishDot =  ccui.Helper:seekWidgetByName(root, "Image_red_3")
	wishDot:setVisible(false)
	-- 心愿单红点
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_new_recruit_wishlist",
	_widget = wishDot,
	_invoke = nil,
	_interval = 0.5,})
end

-- 不包含心愿单的红点
function NewRecruitMain:initDrawRightTwo()
	local root = self.roots[1]
	self.firstLoginRightTwo = true
	-- 招募商店红点
	local shopDot =  ccui.Helper:seekWidgetByName(root, "Image_red_4_2")
	shopDot:setVisible(false)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_new_recruit_shop",
	_widget = shopDot,
	_invoke = nil,
	_interval = 0.5,})
end

-- 右边按钮panel的显示
function NewRecruitMain:showRightList()
	if _ED.active_activity[184] ~= nil then
		self.Panel_right_1:setVisible(true)
		self.Panel_right_2:setVisible(false)
		if self.firstLoginRightOne == false then
			self:initDrawRightOne()
		end
	else
		self.Panel_right_1:setVisible(false)
		self.Panel_right_2:setVisible(true)
		if self.firstLoginRightTwo == false then
			self:initDrawRightTwo()
		end
	end
end

function NewRecruitMain:updateUI()
	local data = _ED.newRecruitInfo
	-- 招募进度显示
	local allProgress = dms.int(dms["play_config"], 249, play_config.param)
	local curTimes = data.cur_draw_times
	local curProgess = curTimes % allProgress

	self.Text_cost_free:setVisible(false)
	self.Text_cost_1:setVisible(false)

	self.Text_progress:setString(curProgess.." / "..allProgress)
	self.LoadingBar_zhaomu:setPercent(curProgess / allProgress * 100)

	local isFree = self:isHaveFreeTimes()
	-- 招募消耗物品的显示
	self.Text_cost_free:setVisible(isFree)
	local propID = self:getNeedCostPropID()
	local picIndex = dms.int(dms["prop_mould"], propID, prop_mould.pic_index)			-- 招募券图标索引
	local oneIconPath = ""
	local tenIconPath = ""
	if isFree ~= true then
		-- 抽取1次
		local isPropEnough = self:haveEnoughProp(1)
		self.Text_cost_1:setVisible(true)
		if isPropEnough == true then
			local count = self:getNeedCostPropCount(1)
			self.Text_cost_1:setString(count)
			-- 招募券图标路径
			oneIconPath = string.format("image/common/currency/common_currency_%d.png", picIndex)
		else
			local count = self:getNeedCostDiamondCount(1)
			self.Text_cost_1:setString(count)
			oneIconPath = "image/common/currency/common_currency_1.png"
		end
		self.Image_zhaomu_one_icon:setVisible(true)
		self.Image_zhaomu_one_icon:setBackGroundImage(oneIconPath)
	else
		self.Image_zhaomu_one_icon:setVisible(false)
	end

	-- 抽取10次
	local isPropEnough = self:haveEnoughProp(10)
	if isPropEnough == true then
		local count = self:getNeedCostPropCount(10)
		self.Text_cost_2:setString(count)
		tenIconPath = string.format("image/common/currency/common_currency_%d.png", picIndex)
	else
		local count = self:getNeedCostDiamondCount(10)
		self.Text_cost_2:setString(count)
		tenIconPath = "image/common/currency/common_currency_1.png"
	end
	self.Image_zhaomu_ten_icon:setVisible(true)
	self.Image_zhaomu_ten_icon:setBackGroundImage(tenIconPath)

	self:showRightList()
end

function NewRecruitMain:onUpdateDraw()
	local root = self.roots[1]

	-- 控件区域
	-- 招募进度条
	self.LoadingBar_zhaomu = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")

	-- 招募进度文本
	self.Text_progress = ccui.Helper:seekWidgetByName(root, "Text_progress")
	
	-- 招募1次消耗金币icon
	self.Image_zhaomu_one_icon = ccui.Helper:seekWidgetByName(root, "Panel_cost_1")
	-- 招募1次消耗数量文本
	self.Text_cost_1 = ccui.Helper:seekWidgetByName(root, "Text_cost_1")

	-- 招募10次消耗招募券icon
	self.Image_zhaomu_ten_icon = ccui.Helper:seekWidgetByName(root, "Panel_cost_2")
	-- 招募10次消耗道具文本
	self.Text_cost_2= ccui.Helper:seekWidgetByName(root, "Text_cost_2")

	-- 本次是否免费的文本
	self.Text_cost_free = ccui.Helper:seekWidgetByName(root, "Text_cost_free")

	-- 右边包含心愿单按钮的panel
	self.Panel_right_1 = ccui.Helper:seekWidgetByName(root, "Panel_you_button_1")
	
	-- 右边不包含心愿单按钮的panel
	self.Panel_right_2 = ccui.Helper:seekWidgetByName(root, "Panel_you_button_2")

	-- 存放动画容器
	self.Panel_chouka = ccui.Helper:seekWidgetByName(root, "Panel_chouka")
	local jsonFile = "images/ui/effice/effect_lilith/effect_lilith.json"
	local atlasFile = "images/ui/effice/effect_lilith/effect_lilith.atlas"
	local aniName = "animation"
	local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, true, nil)
	self.Panel_chouka:addChild(animation)

	-- 跳转到up池
	self.ListView_jump_to_up = ccui.Helper:seekWidgetByName(root, "ListView_jump_to_up")

	self:showCurrencyUI()

	self:updateUI()
	self:initDrawRedDot()

	self:showJumpLst()
	self:refreshChangeReddot()
end

function NewRecruitMain:onEnterTransitionFinish()
	-- 加载NewRecruitMainWindow界面资源.
	-- res.activity.new_recruit_main.new_recruit_main = res/shop/new_recruit.csb.csb
	local csbNode = csb.createNode("shop/new_recruit.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	-- 规则按钮
	self.Button_help = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil,
	{
		terminal_name = "new_recruit_main_rule_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "new_recruit_main_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 抽取1次
	self.Button_get_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "new_recruit_main_get_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
		times = 1,
		m_type = 15
	}, nil, 0)	

	-- 抽取10次
	self.Button_get_10 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
	{
		terminal_name = "new_recruit_main_get_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
		times = 10,
		m_type = 15
	}, nil, 0)	

	-- 心愿单
	self.Button_wish_list = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5"), nil,
	{
		terminal_name = "new_recruit_main_open_wish_list",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 奖励预览
	self.Button_reward_preview1= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_6"), nil,
	{
		terminal_name = "new_recruit_main_open_reward_preview",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 招募商店
	self.Button_recruit_shop1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7"), nil,
	{
		terminal_name = "new_recruit_main_open_recruit_shop",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 奖励预览
	self.Button_reward_preview2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_6_2"), nil,
	{
		terminal_name = "new_recruit_main_open_reward_preview",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 招募商店
	self.Button_recruit_shop2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7_2"), nil,
	{
		terminal_name = "new_recruit_main_open_recruit_shop",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 历史记录
	self.Button_history_record = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil,
	{
		terminal_name = "new_recruit_main_open_history_record",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

function NewRecruitMain:showCurrencyUI()
	-- 货币显示（招募币、金币、招募券、钻石）
	local root = self.roots[1]
	local cell = state_machine.excute("currency_icon_create", 0, {propType = 1, propID = nil})
	ccui.Helper:seekWidgetByName(root, "Panel_currency_1"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_currency_1"):addChild(cell)

	local needInfo = zstring.split(dms.string(dms["play_config"], 255, play_config.param), ",")
	local propType = tonumber(needInfo[1])
	local propID = tonumber(needInfo[2])
	cell = state_machine.excute("currency_icon_create", 0, {propType = propType, propID = propID})
	ccui.Helper:seekWidgetByName(root, "Panel_currency_2"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_currency_2"):addChild(cell)

	cell = state_machine.excute("currency_icon_create", 0, {propType = 2, propID = nil})
	ccui.Helper:seekWidgetByName(root, "Panel_currency_3"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_currency_3"):addChild(cell)

	local needInfo = zstring.split(dms.string(dms["play_config"], 256, play_config.param), ",")
	local propType = tonumber(needInfo[1])
	local propID = tonumber(needInfo[2])
	cell = state_machine.excute("currency_icon_create", 0, {propType = propType, propID = propID})
	ccui.Helper:seekWidgetByName(root, "Panel_currency_4"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_currency_4"):addChild(cell)
end

function NewRecruitMain:showJumpLst()
	if self.ListView_jump_to_up == nil then
		return
	end
	self._cell_list = {}
	app.load("client.activity.lim_summon.LimSummonMgr")
	app.load("client.activity.lim_summon.LimSummonCellMainJump")

	self.ListView_jump_to_up:setVisible(true)
	self.ListView_jump_to_up:removeAllItems()

	-- 原招募界面
	local cell = LimSummonCellMainJump:new()
	cell:init(0)
	cell:setFocus(true)
	self.ListView_jump_to_up:addChild(cell)
	self._cell_list["0"] = cell
	-- up池
	local lstActivity = LimSummonMgr:GetInstance():getActivityLst()
    for i,v in pairs(lstActivity) do
        local idActivity = v
		local cell = LimSummonCellMainJump:new()
		cell:init(idActivity)
		cell:setFocus(false)
		self.ListView_jump_to_up:addChild(cell)
		self._cell_list[idActivity..""] = cell
    end

    self.ListView_jump_to_up:jumpToLeft()
    self.ListView_jump_to_up:requestRefreshView()
end

-- 切換按鈕红点
function NewRecruitMain:refreshChangeReddot()
    for k,v in pairs(self._cell_list) do
        local isShow = false
        if k == "0" then 
            if getNewShopRecruitmentFreeTime() == true or (getNewShopRecruitmentFirstLogin("ten") == true and getNewRecruitTenDiamondEnough()) or (getNewRecruitTenPropEnough() == true) then
                isShow = true
			end
        else
            if LimSummonMgr:GetInstance():isTipCanSummonTen(tonumber(k)) then
                isShow = true
            end
        end 
        v:setRedTip(isShow)
    end
end

function NewRecruitMain:onExit()
	-- 释放NewRecruitMainWindow界面资源.
	state_machine.remove("new_recruit_main_open")
	state_machine.remove("new_recruit_main_close")
	state_machine.remove("new_recruit_main_show")
	state_machine.remove("new_recruit_main_hide")

	state_machine.remove("new_recruit_main_get_reward")
	state_machine.remove("new_recruit_main_open_wish_list")
	state_machine.remove("new_recruit_main_open_reward_preview")
	state_machine.remove("new_recruit_main_open_recruit_shop")
	state_machine.remove("new_recruit_main_open_history_record")
	state_machine.remove("new_recruit_main_refresh_ui")
	state_machine.remove("new_recruit_main_rule_open")
	state_machine.remove("new_recruit_main_close_wishlist")
	state_machine.remove("new_recruit_main_update_redDot")
	state_machine.remove("new_recruit_main_lock_button")
	state_machine.remove("new_recruit_main_unlock_button")
	
	
end

function NewRecruitMain:close()
	-- window event : close.
	
end

function NewRecruitMain:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
