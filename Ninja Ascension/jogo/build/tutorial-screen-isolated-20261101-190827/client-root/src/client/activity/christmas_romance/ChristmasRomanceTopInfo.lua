-- ----------------------------------------------------------------------------------------------------
-- 说明：圣诞奇缘顶部用户信息
-------------------------------------------------------------------------------------------------------
ChristmasRomanceTopInfo = class("ChristmasRomanceTopInfoClass", Window, true)
--打开界面
local christmas_romance_top_info_open_terminal = {
	_name = "christmas_romance_top_info_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local userinfo = ChristmasRomanceTopInfo:new()
		userinfo._rootWindows = params.rootWindows
		userinfo.openType = params.openType
		fwin:open(userinfo,fwin._windows)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(christmas_romance_top_info_open_terminal)
state_machine.init()

function ChristmasRomanceTopInfo:ctor()
    self.super:ctor()
	self.roots = {}
	self.user_silver = 0
	self.user_gold = 0

	self.Text_sliver = nil 
	self.Text_gold = nil
	self.Text_lim_item = nil

	app.load("client.utils.SmBuySilverCoins")
    local function init_christmas_romance_top_info_terminal()
		-- 刷新拥有道具数量
		local christmas_romance_top_info_refresh_prop_count_terminal = {
			_name = "christmas_romance_top_info_refresh_prop_count",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:updatePropCount()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 跳转
		local christmas_romance_top_info_jump_page_terminal = {
			_name = "christmas_romance_top_info_jump_page",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				--跳转幸运转盘
				state_machine.excute("christmas_romance_jump_to_page", 0, {_datas = {m_type = 1}})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(christmas_romance_top_info_refresh_prop_count_terminal)
		state_machine.add(christmas_romance_top_info_jump_page_terminal)
        state_machine.init()
    end
    
    init_christmas_romance_top_info_terminal()
end

function ChristmasRomanceTopInfo:updatePropCount()
	-- 抽奖券
	local propStr = dms.string(dms["activity_config"], 91, activity_config.param)
	local prop = zstring.split(propStr, ",")
	local havePropNum = tonumber(getPropAllCountByMouldId(prop[2]))

	if havePropNum > 10000 then
		self.Text_drawjuan:setString(math.floor(havePropNum / 1000) .. string_equiprety_name[40])
	else
		self.Text_drawjuan:setString(havePropNum)
	end

	-- 抽奖券
	propStr = dms.string(dms["activity_config"], 96, activity_config.param)
	prop = zstring.split(propStr, ",")
	havePropNum = tonumber(getPropAllCountByMouldId(prop[2]))

	if havePropNum > 10000 then
		self.Text_exchangejuan:setString(math.floor(havePropNum / 1000) .. string_equiprety_name[40])
	else
		self.Text_exchangejuan:setString(havePropNum)
	end
end

function ChristmasRomanceTopInfo:onEnterTransitionFinish()
	local csb_public_information = csb.createNode("activity/christmas_romance/christmas_romance_xinxi.csb")
	local root = csb_public_information:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csb_public_information)

	self.Text_sliver = ccui.Helper:seekWidgetByName(root,"Text_111")
	self.Text_gold = ccui.Helper:seekWidgetByName(root,"Text_121")

	-- 抽奖券
	self.Text_drawjuan = ccui.Helper:seekWidgetByName(root,"Text_drawjuan")
	-- 兑换券
	self.Text_exchangejuan = ccui.Helper:seekWidgetByName(root,"Text_exchangejuan")

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_zuanshi_add"), nil, 
    {
        terminal_name = "activity_home_recharge_button", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_jinbi_add"), nil, 
    {
        terminal_name = "sm_buy_silver_coinsopen", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)
    
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_exchangejuan_add"), nil, 
    {
        terminal_name = "christmas_romance_top_info_jump_page", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)


	local Panel_draw = ccui.Helper:seekWidgetByName(root,"Panel_draw")
	local Panel_exchange = ccui.Helper:seekWidgetByName(root,"Panel_exchange")
	Panel_draw:setVisible(false)
	Panel_exchange:setVisible(false)

	-- 打开来源 	1.转盘界面 2.兑换商店
    if self.openType == 1 then
    	Panel_draw:setVisible(true)
    elseif self.openType == 2 then
    	Panel_exchange:setVisible(true)
    end

    local Button_drawjuan_add = ccui.Helper:seekWidgetByName(root,"Button_drawjuan_add")
    if Button_drawjuan_add ~= nil then
    	Button_drawjuan_add:setVisible(false)
    end

    self:updatePropCount()
end

function ChristmasRomanceTopInfo:onUpdate(dt)
	if self.user_silver ~= _ED.user_info.user_silver 
		and self.Text_sliver ~= nil then
		self.user_silver = _ED.user_info.user_silver

		if tonumber( self.user_silver)> 10000 then
			self.Text_sliver:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
		else
			self.Text_sliver:setString(self.user_silver)
		end
	end
	
	if self.user_gold ~= _ED.user_info.user_gold 
		and self.Text_gold ~= nil then
		self.user_gold = _ED.user_info.user_gold

		if tonumber( self.user_gold)> 1000000 then
			self.Text_gold:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
		else
			self.Text_gold:setString(self.user_gold)
		end
	end
end

function ChristmasRomanceTopInfo:onExit()
	state_machine.remove("christmas_romance_top_info_refresh_prop_count")
end