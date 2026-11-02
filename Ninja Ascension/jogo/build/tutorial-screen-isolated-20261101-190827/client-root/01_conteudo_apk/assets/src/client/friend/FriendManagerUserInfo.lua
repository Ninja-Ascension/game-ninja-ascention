-- ----------------------------------------------------------------------------------------------------
-- 说明：好友顶部信息界面
-- 创建时间	2015-04-23
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FriendManagerUserInfo = class("FriendManagerUserInfoClass", Window)
    
function FriendManagerUserInfo:ctor()
    self.super:ctor()
	self.roots = {}
	self.action = nil
	self.fight_capacity = 0 	-- 战力
	self.vip_grade = 0			--vip等级
	self.name = 0				--用户名称
	self.endurance = 0			--耐力
	self.max_endurance = 0
	self._Label_user_fight = nil
	self._Label_user_food = nil
    -- Initialize FriendManager page state machine.
    local function init_friend_manager_user_info_terminal()
		
		--关闭
		local friend_manager_user_info_terminal = {
            _name = "friend_manager_user_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				app.load("client.player.PlayerInfomation")
				fwin:open(PlayerInfomation:new(),fwin._windows )
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(friend_manager_user_info_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_friend_manager_user_info_terminal()
end

function FriendManagerUserInfo:onUpdateDraw()
	self.fight_capacity = _ED.user_info.fight_capacity or 0 -- 战力
	self.vip_grade = _ED.vip_grade							--vip等级
	self.name = _ED.user_info.user_name						--用户名称
	self.endurance = _ED.user_info.endurance						--耐力
	self.max_endurance = _ED.user_info.max_endurance						--耐力
	
	local label_user_name				= ccui.Helper:seekWidgetByName(self.roots[1], "Text_2")
	local label_vip_grade 	= ccui.Helper:seekWidgetByName(self.roots[1], "AtlasLabel_1_2")
	local Label_user_fight = ccui.Helper:seekWidgetByName(self.roots[1], "Text_112_4")
	local Label_user_food = ccui.Helper:seekWidgetByName(self.roots[1], "Text_122_6")
	
	
	-- if zstring.tonumber( self.fight_capacity) > 100000000 then
	-- 	Label_user_fight:setString(math.floor(self.fight_capacity/ 100000000) .. string_equiprety_name[39])
	-- else
	if zstring.tonumber(self.fight_capacity)> 10000 then
		Label_user_fight:setString(math.floor(self.fight_capacity / 1000) .. string_equiprety_name[40])
	else
		Label_user_fight:setString(self.fight_capacity)
	end
	label_user_name:setString(self.name)
	label_vip_grade:setString(self.vip_grade)	
	Label_user_food:setString(self.endurance .. "/" .. self.max_endurance)
	if ___is_open_leadname == true then
		label_user_name:setFontName("")
		label_user_name:setFontSize(label_user_name:getFontSize())
	end
	self._Label_user_fight = Label_user_fight
	self._Label_user_food = Label_user_food
end

function FriendManagerUserInfo:onUpdate(dt)
	if self.fight_capacity ~= _ED.user_info.fight_capacity then
		self.fight_capacity = _ED.user_info.fight_capacity
		-- if zstring.tonumber( self.fight_capacity) > 100000000 then
		-- 	self._Label_user_fight:setString(math.floor(self.fight_capacity/ 100000000) .. string_equiprety_name[39])
		-- else
		if zstring.tonumber(self.fight_capacity)> 10000 then
			self._Label_user_fight:setString(math.floor(self.fight_capacity / 1000) .. string_equiprety_name[40])
		else
			self._Label_user_fight:setString(self.fight_capacity)
		end
	end
	
	if self.endurance ~= _ED.user_info.endurance and nil ~= self.endurance and self.max_endurance ~= nil then
		self.endurance = _ED.user_info.endurance
		if zstring.tonumber(self.endurance) > 10000  or zstring.tonumber(self.max_endurance) > 10000 then
			self._Label_user_food:setString(math.floor(self.endurance/1000)..string_equiprety_name[40] .."/"..self.max_endurance)
		else
			self._Label_user_food:setString(self.endurance.."/"..self.max_endurance)
		end
	end
	
end

function FriendManagerUserInfo:onEnterTransitionFinish()
	local csbFriendManagerUserInfo = csb.createNode("utils/public_information_5.csb")
	self:addChild(csbFriendManagerUserInfo)
	local root = csbFriendManagerUserInfo:getChildByName("root")
	table.insert(self.roots, root)
	  self:onUpdateDraw()
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, {terminal_name = "friend_manager_user_info", terminal_state = 0}, nil, 0)

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


function FriendManagerUserInfo:onExit()
	state_machine.remove("friend_manager_user_info")
end