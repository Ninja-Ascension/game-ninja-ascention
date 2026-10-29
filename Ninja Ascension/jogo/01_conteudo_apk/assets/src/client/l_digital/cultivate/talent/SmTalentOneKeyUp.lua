--[[ ----------------------------------------------------------------------------
-- 天赋一键升级
--]] ----------------------------------------------------------------------------
SmTalentOneKeyUp = class("SmTalentOneKeyUpClass", Window)

-- 打开窗口
local sm_talent_one_key_up_window_open_terminal = {
	_name = "sm_talent_one_key_up_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SmTalentOneKeyUpClass") then
			fwin:open(SmTalentOneKeyUp:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local sm_talent_one_key_up_window_close_terminal = {
	_name = "sm_talent_one_key_up_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmTalentOneKeyUpClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_talent_one_key_up_window_open_terminal)
state_machine.add(sm_talent_one_key_up_window_close_terminal)
state_machine.init()

-- 构造器
function SmTalentOneKeyUp:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- 一键升级
	self.oneKeyUpSilverIsEnough = true
	self.oneKeyUpTalentPointIsEnough = true

	-- 当前选择的数量
	self._select_num = 0

	-- 最大可选择数量
	self._max_select_num = 0

	-- 最小可选择数量
	self._min_select_num = 0


	-- load lua files.

	-- Initialize secret treasure rule page state machine.
	local function init_sm_talent_one_key_up_terminal()
		-- 打开角色创建窗口
		local sm_talent_one_key_up_open_terminal = {
			_name = "sm_talent_one_key_up_open",
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
		local sm_talent_one_key_up_close_terminal = {
			_name = "sm_talent_one_key_up_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("sm_talent_one_key_up_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local sm_talent_one_key_up_show_terminal = {
			_name = "sm_talent_one_key_up_show",
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
		local sm_talent_one_key_up_hide_terminal = {
			_name = "sm_talent_one_key_up_hide",
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

		-- 确定
		local sm_talent_one_key_up_sure_terminal = {
			_name = "sm_talent_one_key_up_sure",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local times = instance._select_num - instance._min_select_num + 1

				local function requestCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							state_machine.excute("sm_talent_main_up_updata",0,"sm_talent_main_up_updata.")
							if self.page == 1 then
								state_machine.excute("sm_talent_page_one_update",0,"sm_talent_page_one_update.")
								state_machine.excute("sm_talent_page_two_update",0,"sm_talent_page_two_update.")
							elseif self.page == 2 then
								state_machine.excute("sm_talent_page_two_update",0,"sm_talent_page_two_update.")
								state_machine.excute("sm_talent_page_three_update",0,"sm_talent_page_three_update.")
							elseif self.page == 3 then
								state_machine.excute("sm_talent_page_three_update",0,"sm_talent_page_three_update.")
								state_machine.excute("sm_talent_page_four_update",0,"sm_talent_page_four_update.")
							elseif self.page == 4 then
								state_machine.excute("sm_talent_page_four_update",0,"sm_talent_page_four_update.")
							end
							state_machine.excute("sm_talent_up_grade_refresh", 0, nil)
							smFightingChange()

							state_machine.unlock("sm_talent_one_key_up_sure")
							-- 关闭界面
							state_machine.excute("sm_talent_one_key_up_close", 0, nil)
						else
							state_machine.unlock("sm_talent_one_key_up_sure")
						end
					else
						state_machine.unlock("sm_talent_one_key_up_sure")
					end
				end

				if self.oneKeyUpSilverIsEnough == false then
					app.load("client.packs.hero.HeroPatchInformationPageGetWay")
					local fightWindow = HeroPatchInformationPageGetWay:new()
					fightWindow:init(0,6)
					fwin:open(fightWindow, fwin._windows)
					return
				end

				if self.oneKeyUpTalentPointIsEnough == false then
					return
				end

				state_machine.lock("sm_talent_one_key_up_sure")

				if times > 1 then
					protocol_command.ship_talent_level_up.param_list = instance.table_mould .. "\r\n" .. times
				else
					protocol_command.ship_talent_level_up.param_list = instance.table_mould
				end
				
				NetworkManager:register(protocol_command.ship_talent_level_up.code, nil, nil, nil, instance, requestCallBack, false, nil) 
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 设置加减
		local sm_talent_one_key_up_change_times_terminal = {
            _name = "sm_talent_one_key_up_change_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local select_num = instance._select_num + tonumber(params._datas.updateLevel)
				if select_num >= instance._max_select_num then
					select_num = instance._max_select_num
				elseif select_num <= instance._min_select_num then
					select_num = instance._min_select_num
				end
				instance:setSelectNum(select_num)
				return true
			end,
			_terminal = nil,
			_terminals = nil
			}

		-- 拖动滑动条
		local sm_talent_one_key_up_silder_update_terminal = {
			_name = "sm_talent_one_key_up_silder_update",
			_init = function (terminal) 

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local Slider_number_xz = instance.Slider_number_xz
				local select_num = math.ceil((tonumber(Slider_number_xz:getPercent()) * (self._max_select_num - self._min_select_num)) / 100)
				instance:setSelectNum(self._min_select_num + select_num)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


		state_machine.add(sm_talent_one_key_up_open_terminal)
		state_machine.add(sm_talent_one_key_up_close_terminal)
		state_machine.add(sm_talent_one_key_up_show_terminal)
		state_machine.add(sm_talent_one_key_up_hide_terminal)
		state_machine.add(sm_talent_one_key_up_sure_terminal)

		state_machine.add(sm_talent_one_key_up_change_times_terminal)
		state_machine.add(sm_talent_one_key_up_silder_update_terminal)

		state_machine.init()
	end
	-- call func init secret treasure rule state machine.
	init_sm_talent_one_key_up_terminal()
end

-- 对象初始化
function SmTalentOneKeyUp:init(params)
	self.page = params[1]
	self.table_mould = params[2]

	self._min_select_num = self:getMinSelectNum()
	self._max_select_num = self:getMaxSelectNum()
	
	return self
end

function SmTalentOneKeyUp:getMinSelectNum()
	local currTalent = _ED.digital_talent_already_add[""..self.table_mould]
	if currTalent == nil then
		currLv = 0
	else
		currLv = tonumber(currTalent.level)
	end

	return currLv + 1
end

function SmTalentOneKeyUp:getMaxSelectNum()
	-- 数值表最大值
	local table_data = dms.element(dms["ship_talent_mould"] , self.table_mould)
	local maxLv = dms.atoi(table_data , ship_talent_mould.max_lv)

	-- 天赋点
	local talent_point = zstring.tonumber(_ED.user_info.talent_point)
	-- 金币
	local user_silver = zstring.tonumber(_ED.user_info.user_silver)

	--属性
	local needGroup = dms.searchs(dms["ship_talent_param"], ship_talent_param.need_mould, self.table_mould)
	local curLvl = self._min_select_num

	local needGoldCoinCount = 0
	local needTanlentPointCount = 0

	local canUpMaxLevel = table.nums(needGroup)

	for _, v in pairs(needGroup) do
		if tonumber(v[3]) >= curLvl then
			local needProp = zstring.splits(v[4] , "|", ",")
			local goldCoinCount = tonumber(needProp[1][3])
			local tanlentPoint = tonumber(needProp[2][3])

			needGoldCoinCount = needGoldCoinCount + goldCoinCount
			needTanlentPointCount = needTanlentPointCount + tanlentPoint

			if needGoldCoinCount > user_silver or needTanlentPointCount > talent_point then
				canUpMaxLevel = tonumber(v[3]) - 1
				break
			end
		end
	end

	return canUpMaxLevel
end

function SmTalentOneKeyUp:onUpdateDraw()
	local root = self.roots[1]

	self.Slider_number_xz = ccui.Helper:seekWidgetByName(root, "Slider_number_xz")
	self.Text_packs_sell_n = ccui.Helper:seekWidgetByName(root, "Text_packs_sell_n")

	self.Text_darw_one_gem_n = ccui.Helper:seekWidgetByName(root, "Text_darw_one_gem_n")
	self.Text_darw_one_gem_n_0 = ccui.Helper:seekWidgetByName(root, "Text_darw_one_gem_n_0")

	-- 滑动选择
	local Slider_number_xz = self.Slider_number_xz
	local function percentChangedEvent(sender,eventType)
		if eventType == ccui.SliderEventType.percentChanged then
			state_machine.excute("sm_talent_one_key_up_silder_update", 0, {sender:getPercent()})
		end
	end
	Slider_number_xz:addEventListener(percentChangedEvent)


	self:setSelectNum(self._min_select_num)
end

function SmTalentOneKeyUp:setSelectNum(select_num)
	self._select_num = select_num

	self:updateUpLevel()
	self:updateCostNum()
	self:updateSliderInfo()
end

function SmTalentOneKeyUp:updateSliderInfo()
	local percent = math.floor((self._select_num - self._min_select_num + 1) / (self._max_select_num - self._min_select_num + 1) * 100)

	self.Slider_number_xz:setPercent(percent)
end

-- 刷新消耗
function SmTalentOneKeyUp:updateCostNum()
	-- 当前选择的数量
	local select_num = self._select_num

	--属性
	local needGroup = dms.searchs(dms["ship_talent_param"], ship_talent_param.need_mould, self.table_mould)
	local curLvl = self._min_select_num

	local needGoldCoinCount = 0
	local needTanlentPointCount = 0

	local canUpMaxLevel = 0

	for _, v in pairs(needGroup) do
		if tonumber(v[3]) >= curLvl and tonumber(v[3]) <= select_num then
			local needProp = zstring.splits(v[4] , "|", ",")
			local goldCoinCount = tonumber(needProp[1][3])
			local tanlentPoint = tonumber(needProp[2][3])

			needGoldCoinCount = needGoldCoinCount + goldCoinCount
			needTanlentPointCount = needTanlentPointCount + tanlentPoint
		end
	end

	self.Text_darw_one_gem_n:setString(needGoldCoinCount)
	self.Text_darw_one_gem_n_0:setString(needTanlentPointCount)

	-- 天赋点
	local talent_point = zstring.tonumber(_ED.user_info.talent_point)
	-- 金币
	local user_silver = zstring.tonumber(_ED.user_info.user_silver)

	local redColor = cc.c3b(255, 0, 0)
	local greenColor = cc.c3b(0, 255, 51)

	self.Text_darw_one_gem_n:setColor(needGoldCoinCount >= user_silver and redColor or greenColor)
	self.Text_darw_one_gem_n_0:setColor(needTanlentPointCount >= talent_point and redColor or greenColor)
end

-- 刷新目标等级
function SmTalentOneKeyUp:updateUpLevel()
	local select_num = self._select_num
	local max_select_num = self._max_select_num

	self.Text_packs_sell_n:setString(select_num .. "/" .. max_select_num)
end

function SmTalentOneKeyUp:onEnterTransitionFinish()
	-- 加载SmTalentOneKeyUpWindow界面资源.
	-- res.cultivate.cultivate_talent_window_0 = res/cultivate/cultivate_talent_window_0.csb
	local csbNode = csb.createNode("cultivate/cultivate_talent_window_0.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "sm_talent_one_key_up_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 关闭
	self.Button_use = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use"), nil,
	{
		terminal_name = "sm_talent_one_key_up_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 确定
	self.Button_use_0 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_0"), nil,
	{
		terminal_name = "sm_talent_one_key_up_sure",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 减
	self.Button_jian = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jian"), nil,
	{
		terminal_name = "sm_talent_one_key_up_change_times",
		terminal_state = 0,
		isPressedActionEnabled = true,
		updateLevel = -1,
	}, nil, 0)

	-- 加
	self.Button_jia = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jia"), nil,
	{
		terminal_name = "sm_talent_one_key_up_change_times",
		terminal_state = 0,
		isPressedActionEnabled = true,
		updateLevel = 1,
	}, nil, 0)


	self:onUpdateDraw()
end

function SmTalentOneKeyUp:onExit()
	-- 释放SmTalentOneKeyUpWindow界面资源.
	state_machine.remove("sm_talent_one_key_up_open")
	state_machine.remove("sm_talent_one_key_up_close")
	state_machine.remove("sm_talent_one_key_up_show")
	state_machine.remove("sm_talent_one_key_up_hide")
end

function SmTalentOneKeyUp:close()
	-- window event : close.
	
end

function SmTalentOneKeyUp:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
