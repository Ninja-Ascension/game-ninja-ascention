-- ----------------------------------------------------------------------------------------------------
-- 说明：征战顶部用户信息
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipPlayerInfomation = class("EquipPlayerInfomationClass", Window, true)
    
function EquipPlayerInfomation:ctor()
    self.super:ctor()
	self.roots = {}
	self.user_silver = 0
	self.user_grade = 0
	self.user_gold = 0
	self.user_experience = 0
	self.user_grade_need_experience = 0
	self.fight_capacity = 0

	self._Text_9 = nil
	self._Text_10 = nil
	self._Text_11 = nil
	self._Text_12 = nil
	
    app.load("client.player.PlayerInfomation")
    -- Initialize EquipPlayerInfomation page state machine.
    local function init_EquipPlayerInfomation_terminal()
        local equip_player_infomation_button_terminal = {
            _name = "equip_player_infomation_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
				fwin:open(PlayerInfomation:new(),fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(equip_player_infomation_button_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_EquipPlayerInfomation_terminal()
end

function EquipPlayerInfomation:onEnterTransitionFinish()
	local csb_public_information = csb.createNode("utils/public_information_3.csb")
	local root = csb_public_information:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csb_public_information)
	
	self.fight_capacity = _ED.user_info.fight_capacity or 0
	self.endurance = _ED.user_info.endurance
	self.max_endurance = _ED.user_info.max_endurance
	self.user_silver = _ED.user_info.user_silver
	self.user_gold = _ED.user_info.user_gold
	
	local Text_9 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_91")
	local Text_10 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_101")
	local Text_11 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_111")
	local Text_12 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_121")
	
	self._Text_9 = Text_9
	self._Text_10 = Text_10
	self._Text_11 = Text_11
	self._Text_12 = Text_12
	
	-- if tonumber( self.fight_capacity) > 100000000 then
	-- 	Text_9:setString(math.floor(self.fight_capacity/ 100000000) .. string_equiprety_name[39])
	-- else
	if tonumber(self.fight_capacity)> 10000 then
		Text_9:setString(math.floor(self.fight_capacity / 1000) .. string_equiprety_name[40])
	else
		Text_9:setString(self.fight_capacity)
	end
	
	if tonumber( self.endurance) > 10000  or tonumber( self.max_endurance) > 10000 then
			Text_10:setString(math.floor(self.endurance/1000)..string_equiprety_name[40] .."/"..self.max_endurance)
		else
			Text_10:setString(self.endurance.."/"..self.max_endurance)
		end
	
	-- if tonumber( self.user_silver) > 100000000 then
	-- 	Text_11:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
	-- else
	if tonumber( self.user_silver)> 10000 then
		Text_11:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
	else
		Text_11:setString(self.user_silver)
	end
	
	-- if tonumber(self.user_gold) > 100000000 then
	-- 	Text_12:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
	-- else
	if tonumber( self.user_gold)> 1000000 then
		Text_12:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
	else
		Text_12:setString(self.user_gold)
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, {func_string = [[state_machine.excute("equip_player_infomation_button", 0, "equip_player_infomation_button.'")]]}, nil, 0)
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
	    app.load("client.utils.SmBuyPhysical")
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tili_add"), nil, 
	    {
	        terminal_name = "sm_buy_physicalopen", 
	        terminal_state = 0, 
	        touch_black = true,
	    }, nil, 0)
	end
end

function EquipPlayerInfomation:onUpdate(dt)

	if self.fight_capacity ~= _ED.user_info.fight_capacity then
		self.fight_capacity = _ED.user_info.fight_capacity
		-- if tonumber( self.fight_capacity) > 100000000 then
		-- 	self._Text_9:setString(math.floor(self.fight_capacity/ 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber(self.fight_capacity)> 10000 then
			self._Text_9:setString(math.floor(self.fight_capacity / 1000) .. string_equiprety_name[40])
		else
			self._Text_9:setString(self.fight_capacity)
		end
	end
	
	if self.endurance ~= _ED.user_info.endurance then
		self.endurance = _ED.user_info.endurance
		if tonumber( self.endurance) > 10000  or tonumber( self.max_endurance) > 10000 then
			self._Text_10:setString(math.floor(self.endurance/1000)..string_equiprety_name[40] .."/"..self.max_endurance)
		else
			self._Text_10:setString(self.endurance.."/"..self.max_endurance)
		end
	end
	
	-- if self.max_endurance ~= _ED.user_info.max_endurance then
		-- self.max_endurance = _ED.user_info.max_endurance
		-- Text_10:setString(self.endurance.."/"..self.max_endurance)
	-- end
	
	if self.user_silver ~= _ED.user_info.user_silver then
		self.user_silver = _ED.user_info.user_silver
		-- if tonumber( self.user_silver) > 100000000 then
		-- 	self._Text_11:setString(math.floor(self.user_silver/ 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber( self.user_silver)> 10000 then
			self._Text_11:setString(math.floor(self.user_silver / 1000) .. string_equiprety_name[40])
		else
			self._Text_11:setString(self.user_silver)
		end
	end
	
	if self.user_gold ~= _ED.user_info.user_gold then
		self.user_gold = _ED.user_info.user_gold
		-- if tonumber(self.user_gold) > 100000000 then
		-- 	self._Text_12:setString(math.floor(self.user_gold / 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber( self.user_gold)> 1000000 then
			self._Text_12:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
		else
			self._Text_12:setString(self.user_gold)
		end
	end
end

function EquipPlayerInfomation:onExit()
	state_machine.remove("equip_player_infomation_button")
end