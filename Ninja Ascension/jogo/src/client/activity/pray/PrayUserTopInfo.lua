-- ----------------------------------------------------------------------------------------------------
-- 说明：限时祈福顶部用户信息
-------------------------------------------------------------------------------------------------------
PrayUserTopInfo = class("PrayUserTopInfoClass", Window, true)
--打开界面
local pray_user_top_info_open_terminal = {
	_name = "pray_user_top_info_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local userinfo = PrayUserTopInfo:new()
		userinfo._rootWindows = params
		fwin:open(userinfo,fwin._windows)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(pray_user_top_info_open_terminal)
state_machine.init()

function PrayUserTopInfo:ctor()
    self.super:ctor()
	self.roots = {}
	self.user_silver = 0
	self.user_gold = 0

	self.Text_sliver = nil 
	self.Text_gold = nil
	self.Text_pray_item = nil

	app.load("client.utils.SmBuySilverCoins")
    local function init_pray_user_top_info_terminal()
		-- 刷新拥有道具数量
		local pray_user_top_info_refresh_prop_count_terminal = {
			_name = "pray_user_top_info_refresh_prop_count",
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

		state_machine.add(pray_user_top_info_refresh_prop_count_terminal)
        state_machine.init()
    end
    
    init_pray_user_top_info_terminal()
end

function PrayUserTopInfo:updatePropCount()
	-- 需要替换成活动所需要的道具
	local propID = dms.int(dms["activity_config"], 84, activity_config.param)
	local havePropNum = tonumber(getPropAllCountByMouldId(propID))

	if havePropNum > 10000 then
		self.Text_pray_item:setString(math.floor(havePropNum / 1000) .. string_equiprety_name[40])
	else
		self.Text_pray_item:setString(havePropNum)
	end
end

function PrayUserTopInfo:onEnterTransitionFinish()
	local csb_public_information = csb.createNode("activity/Pray/Pray_top.csb")
	local root = csb_public_information:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csb_public_information)

	self.Text_sliver = ccui.Helper:seekWidgetByName(root,"Text_111")
	self.Text_gold = ccui.Helper:seekWidgetByName(root,"Text_121")
	self.Text_pray_item = ccui.Helper:seekWidgetByName(root,"Text_ghb")
	ccui.Helper:seekWidgetByName(root,"Button_tili_add"):setVisible(false)
	
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

	-- 无法获取图片控件
    -- local Image_rzl = ccui.Helper:seekWidgetByName(root,"Image_rzl")
    -- local propID = dms.int(dms["activity_config"], 62, activity_config.param)
    -- local icon_index = dms.int(dms["prop_mould"], propID, prop_mould.pic_index)
    -- Image_rzl:setTexture(string.format("images/ui/props/props_%d.png", icon_index))

    self:updatePropCount()
end

function PrayUserTopInfo:onUpdate(dt)
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

function PrayUserTopInfo:onExit()
	state_machine.remove("pray_user_top_info_refresh_prop_count")
end