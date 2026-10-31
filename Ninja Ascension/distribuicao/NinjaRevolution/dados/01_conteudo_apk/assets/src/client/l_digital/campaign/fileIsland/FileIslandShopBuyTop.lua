-- ----------------------------------------------------------------------------------------------------
-- 说明：文件岛顶部信息
-------------------------------------------------------------------------------------------------------
FileIslandShopBuyTop = class("FileIslandShopBuyTopClass", Window, true)
    
function FileIslandShopBuyTop:ctor()
    self.super:ctor()
	self.roots = {}
	-- 探索币
	self.user_explore = 0
	self.user_silver = 0
	self.user_gold = 0

	self._Text_10 = nil
	self._Text_11 = nil
	self._Text_12 = nil
	
    local function init_user_topinfo_a_terminal()
		-- 用户信息显示
		local user_topinfo_a_show_all_info_terminal = {
            _name = "user_topinfo_a_show_all_info",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				app.load("client.player.PlayerInfomation")
				fwin:open(PlayerInfomation:new(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(user_topinfo_a_show_all_info_terminal)
        state_machine.init()
    end
    
    init_user_topinfo_a_terminal()
end

function FileIslandShopBuyTop:onEnterTransitionFinish()
	local csb_public_information = csb.createNode("campaign/explore/explore_public_information.csb")
	local root = csb_public_information:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csb_public_information)
	
	self.user_silver = _ED.user_info.user_silver
	self.user_gold = _ED.user_info.user_gold

	_ED.fileIsland = _ED.fileIsland or {}
	self.user_explore = _ED.fileIsland.searchCoin or 0
	if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		_ED.pokemonExplore = _ED.pokemonExplore or {}
		self.user_explore = _ED.pokemonExplore.searchCoin
	end

	local Text_10 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_11")
	local Text_11 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_12")
	local Text_12 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_12_0")

	self._Text_10 = Text_10
	self._Text_11 = Text_11
	self._Text_12 = Text_12

	if tonumber(self.user_silver) > 10000 then
		Text_10:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
	else
		Text_10:setString(self.user_silver)
	end

	if tonumber(self.user_gold) > 1000000 then
		Text_11:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
	else
		Text_11:setString(self.user_gold)
	end

	if tonumber(self.user_explore) > 1000000 then
		Text_12:setString(math.floor(self.user_explore / 1000) .. string_equiprety_name[40])
	else
		Text_12:setString(self.user_explore)
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, {func_string = [[state_machine.excute("user_topinfo_a_show_all_info", 0, "equip_player_infomation_button.'")]]}, nil, 0)
	if fwin:find("CaptureResourceClass") ~= nil then
		ccui.Helper:seekWidgetByName(root, "Panel_2"):setTouchEnabled(false)
	end	

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_zuanshi_add"), nil, 
	    {
	        terminal_name = "activity_home_recharge_button", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)
	    app.load("client.utils.SmBuySilverCoins")
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_jinbi_add"), nil, 
	    {
	        terminal_name = "sm_buy_silver_coinsopen", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)
	end
end

function FileIslandShopBuyTop:onUpdate(dt)
	if self.user_silver ~= _ED.user_info.user_silver then
		self.user_silver = _ED.user_info.user_silver
		if tonumber(self.user_silver) > 10000 then
			self._Text_10:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
		else
			self._Text_10:setString(self.user_silver)
		end
	end
	
	if self.user_gold ~= _ED.user_info.user_gold then
		self.user_gold = _ED.user_info.user_gold
		if tonumber(self.user_gold) > 1000000 then
			self._Text_11:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
		else
			self._Text_11:setString(self.user_gold)
		end
	end

	if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		if self.user_explore ~= _ED.pokemonExplore.searchCoin then
			self.user_explore = _ED.pokemonExplore.searchCoin or 0
			if tonumber(self.user_explore) > 1000000 then
				self._Text_12:setString(math.floor(self.user_explore / 1000) .. string_equiprety_name[40])
			else
				self._Text_12:setString(self.user_explore)
			end
		end
	else
		if self.user_explore ~= _ED.fileIsland.searchCoin then
			self.user_explore = _ED.fileIsland.searchCoin or 0
			if tonumber(self.user_explore) > 1000000 then
				self._Text_12:setString(math.floor(self.user_explore / 1000) .. string_equiprety_name[40])
			else
				self._Text_12:setString(self.user_explore)
			end
		end
	end

	
end

function FileIslandShopBuyTop:onExit()
	state_machine.remove("user_topinfo_a_show_all_info")
end