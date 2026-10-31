-- ----------------------------------------------------------------------------------------------------
-- 说明：工会顶部用户信息
-------------------------------------------------------------------------------------------------------
smUnionUserTopInfo = class("smUnionUserTopInfoClass", Window, true)
--打开界面
local sm_union_user_topinfo_open_terminal = {
	_name = "sm_union_user_topinfo_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		-- if fwin:find("smUnionUserTopInfoClass") == nil then
			local userinfo = smUnionUserTopInfo:new()
			userinfo._rootWindows = params
			fwin:open(userinfo,fwin._windows)
		-- end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(sm_union_user_topinfo_open_terminal)
state_machine.init()    
function smUnionUserTopInfo:ctor()
    self.super:ctor()
	self.roots = {}
	self.user_silver = 0
	self.user_gold = 0
	self.user_union_cost = 0
	self.Text_sliver = nil 
	self.Text_gold = nil
	self.Text_unionCost = nil
	app.load("client.utils.SmBuySilverCoins")
    local function init_sm_union_user_topinfo_terminal()
		
        state_machine.init()
    end
    
    init_sm_union_user_topinfo_terminal()
end

function smUnionUserTopInfo:onEnterTransitionFinish()
	local csb_public_information = csb.createNode("utils/public_information_6.csb")
	local root = csb_public_information:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csb_public_information)

	self.Text_sliver = ccui.Helper:seekWidgetByName(root,"Text_111")
	self.Text_gold = ccui.Helper:seekWidgetByName(root,"Text_121")
	self.Text_unionCost = ccui.Helper:seekWidgetByName(root,"Text_ghb")
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
end

function smUnionUserTopInfo:onUpdate(dt)
	if self.user_silver ~= _ED.user_info.user_silver 
		and self.Text_sliver ~= nil then
		self.user_silver = _ED.user_info.user_silver
		-- if tonumber( self.user_silver) > 100000000 then
		-- 	self.Text_sliver:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber( self.user_silver)> 10000 then
			self.Text_sliver:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
		else
			self.Text_sliver:setString(self.user_silver)
		end
	end
	
	if self.user_gold ~= _ED.user_info.user_gold 
		and self.Text_gold ~= nil then
		self.user_gold = _ED.user_info.user_gold
		-- if tonumber(self.user_gold) > 100000000 then
		-- 	self.Text_gold:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber( self.user_gold)> 1000000 then
			self.Text_gold:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
		else
			self.Text_gold:setString(self.user_gold)
		end
	end

	if self.user_union_cost ~=  _ED.union.user_union_info.rest_contribution
		and self.Text_unionCost ~= nil then
		self.user_union_cost = _ED.union.user_union_info.rest_contribution
		-- if tonumber(self.user_union_cost) > 100000000 then
		-- 	self.Text_unionCost:setString(math.floor(self.user_union_cost / 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber( self.user_union_cost)> 10000 then
			self.Text_unionCost:setString(math.floor(self.user_union_cost / 1000) .. string_equiprety_name[40])
		else
			self.Text_unionCost:setString(self.user_union_cost)
		end
	end
	
end

function smUnionUserTopInfo:onExit()
	
end