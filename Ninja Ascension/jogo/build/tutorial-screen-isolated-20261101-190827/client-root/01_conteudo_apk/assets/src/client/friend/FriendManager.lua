-- ----------------------------------------------------------------------------------------------------
-- 说明：好友界面
-- 创建时间	2015-04-16
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FriendManager = class("FriendManagerClass", Window)
    
function FriendManager:ctor()
    self.super:ctor()
	self.roots = {}
	self.group = {}
	self.actions ={}
	app.load("client.friend.FriendManagerList")
	app.load("client.friend.FriendManagerOne")
	app.load("client.friend.FriendManagerTwo")
	app.load("client.friend.FriendManagerThree")
	app.load("client.friend.FriendManagerFour")
	app.load("client.friend.FriendManagerUserInfo")
	app.load("client.friend.FriendManagerRecommend")
    -- Initialize FriendManager page state machine.
    local function init_friend_manager_terminal()
		--返回
		local friend_manager_back_terminal = {
            _name = "friend_manager_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:cleanView(fwin._view) 
				fwin:close(instance)
				state_machine.excute("menu_back_home_page", 0, "") 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--好友
		local friend_manager_click_friend_terminal = {
            _name = "friend_manager_click_friend",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDrawOne()
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_friend_2"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_01"):setHighlighted(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_04"):setHighlighted(false)
				else
					if __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_digimon_adventure 
						or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_05"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_01"):setHighlighted(true)
				        ccui.Helper:seekWidgetByName(instance.roots[1], "Button_02"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_03"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_04"):setHighlighted(false)
					else
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24"):setVisible(true)
					end
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_25"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_26"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_27"):setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--领取耐力
		local friend_manager_click_send_terminal = {
            _name = "friend_manager_click_send",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDrawTwo()
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_friend_2"):setHighlighted(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_01"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_04"):setHighlighted(false)
				else
					if __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_digimon_adventure 
						or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh
						then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_25"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_05"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_01"):setHighlighted(false)
				        ccui.Helper:seekWidgetByName(instance.roots[1], "Button_02"):setHighlighted(true)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_03"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_04"):setHighlighted(false)
					else
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_25"):setVisible(true)
					end
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_26"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_27"):setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--黑名单
		local friend_manager_click_blacklist_terminal = {
            _name = "friend_manager_click_blacklist",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDrawThree()
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
				else
					if __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_digimon_adventure 
						or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_26"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_05"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_01"):setHighlighted(false)
				        ccui.Helper:seekWidgetByName(instance.roots[1], "Button_02"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_03"):setHighlighted(true)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_04"):setHighlighted(false)
					else
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_26"):setVisible(true)
					end
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_25"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_27"):setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--好友申请
		local friend_manager_click_friend_need_terminal = {
            _name = "friend_manager_click_friend_need",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDrawFour()
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_friend_2"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_01"):setHighlighted(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Button_04"):setHighlighted(true)
				else
					if __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_digimon_adventure 
						or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh 
						then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_27"):setVisible(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_05"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_01"):setHighlighted(false)
				        ccui.Helper:seekWidgetByName(instance.roots[1], "Button_02"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_03"):setHighlighted(false)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_04"):setHighlighted(true)
					else
						ccui.Helper:seekWidgetByName(instance.roots[1], "Image_27"):setVisible(true)
					end
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_25"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_26"):setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(friend_manager_back_terminal)
		state_machine.add(friend_manager_click_friend_terminal)
		state_machine.add(friend_manager_click_send_terminal)
		state_machine.add(friend_manager_click_blacklist_terminal)
		state_machine.add(friend_manager_click_friend_need_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_friend_manager_terminal()
end

function FriendManager:onUpdateDrawOne()
	local root = self.roots[1]
	-- local pageOne = fwin:find("FriendManagerOneClass")
	-- local pageTwo = fwin:find("FriendManagerTwoClass")
	-- local pageThree = fwin:find("FriendManagerThreeClass")
	-- local pageFour = fwin:find("FriendManagerFourClass")
	-- if pageTwo ~= nil then
		-- pageTwo:setVisible(false)
	-- end
	
	-- if pageThree ~= nil then
		-- pageThree:setVisible(false)
	-- end
	
	-- if pageFour ~= nil then
		-- pageFour:setVisible(false)
	-- end
	
	-- if pageOne == nil then
		-- fwin:open(FriendManagerOne:new(),fwin._view)
	-- else
		-- pageOne:setVisible(true)
	-- end
	
	if self.group[2] ~= nil then
		self.group[2]:setVisible(false)
	end
	
	if self.group[3] ~= nil then
		self.group[3]:setVisible(false)
	end
	
	if self.group[4] ~= nil then
		self.group[4]:setVisible(false)
	end
	
	if self.group[1] == nil then
		local cell = FriendManagerOne:createCell()
		ccui.Helper:seekWidgetByName(root, "Panel_1320"):addChild(cell)
		self.group[1] = cell
	else
		self.group[1]:setVisible(true)
		self.group[1]:onUpdateDraw()
	end
end

function FriendManager:onUpdateDrawTwo()
	local root = self.roots[1]
	-- local pageOne = fwin:find("FriendManagerOneClass")
	-- local pageTwo = fwin:find("FriendManagerTwoClass")
	-- local pageThree = fwin:find("FriendManagerThreeClass")
	-- local pageFour = fwin:find("FriendManagerFourClass")
	-- if pageOne ~= nil then
		-- pageOne:setVisible(false)
	-- end
	
	-- if pageThree ~= nil then
		-- pageThree:setVisible(false)
	-- end
	
	-- if pageFour ~= nil then
		-- pageFour:setVisible(false)
	-- end
	
	-- if pageTwo == nil then
		-- fwin:open(FriendManagerTwo:new(),fwin._view)
	-- else
		-- pageTwo:setVisible(true)
	-- end
	
	if self.group[1] ~= nil then
		self.group[1]:setVisible(false)
	end
	
	if self.group[3] ~= nil then
		self.group[3]:setVisible(false)
	end
	
	if self.group[4] ~= nil then
		self.group[4]:setVisible(false)
	end
	
	if self.group[2] == nil then

		local cell = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			cell = FriendManagerRecommend:createCell()
		else
			cell = FriendManagerTwo:createCell()
		end
		ccui.Helper:seekWidgetByName(root, "Panel_1320"):addChild(cell)
		self.group[2] = cell
	else
		self.group[2]:setVisible(true)
		self.group[2]:onUpdateDraw()
	end
	
end

function FriendManager:onUpdateDrawThree()
	local root = self.roots[1]
	-- local pageOne = fwin:find("FriendManagerOneClass")
	-- local pageTwo = fwin:find("FriendManagerTwoClass")
	-- local pageThree = fwin:find("FriendManagerThreeClass")
	-- local pageFour = fwin:find("FriendManagerFourClass")
	
	-- if pageOne ~= nil then
		-- pageOne:setVisible(false)
	-- end
	
	-- if pageTwo ~= nil then
		-- pageTwo:setVisible(false)
	-- end
	
	-- if pageFour ~= nil then
		-- pageFour:setVisible(false)
	-- end
	
	-- if pageThree == nil then
		-- fwin:open(FriendManagerThree:new(),fwin._view)
	-- else
		-- pageThree:setVisible(true)
	-- end
	
	if self.group[1] ~= nil then
		self.group[1]:setVisible(false)
	end
	
	if self.group[2] ~= nil then
		self.group[2]:setVisible(false)
	end
	
	if self.group[4] ~= nil then
		self.group[4]:setVisible(false)
	end
	
	if self.group[3] == nil then
		local cell = FriendManagerThree:createCell()
		ccui.Helper:seekWidgetByName(root, "Panel_1320"):addChild(cell)
		self.group[3] = cell
	else
		self.group[3]:setVisible(true)
		self.group[3]:onUpdateDraw()
	end
	
end

function FriendManager:onUpdateDrawFour()
	local root = self.roots[1]
	-- local pageOne = fwin:find("FriendManagerOneClass")
	-- local pageTwo = fwin:find("FriendManagerTwoClass")
	-- local pageThree = fwin:find("FriendManagerThreeClass")
	-- local pageFour = fwin:find("FriendManagerFourClass")
	-- if pageOne ~= nil then
		-- pageOne:setVisible(false)
	-- end
	
	-- if pageTwo ~= nil then
		-- pageTwo:setVisible(false)
	-- end
	
	-- if pageThree ~= nil then
		-- pageThree:setVisible(false)
	-- end
	
	-- if pageFour == nil then
		-- fwin:open(FriendManagerFour:new(),fwin._view)
	-- else
		-- pageFour:setVisible(true)
	-- end
	
	if self.group[1] ~= nil then
		self.group[1]:setVisible(false)
	end
	
	if self.group[2] ~= nil then
		self.group[2]:setVisible(false)
	end
	
	if self.group[3] ~= nil then
		self.group[3]:setVisible(false)
	end
	
	if self.group[4] == nil then
		local cell = FriendManagerFour:createCell()
		ccui.Helper:seekWidgetByName(root, "Panel_1320"):addChild(cell)
		self.group[4] = cell
	else
		self.group[4]:setVisible(true)
		self.group[4]:onUpdateDraw()
	end
	
end


function FriendManager:onEnterTransitionFinish()
	local csbFriendManager = csb.createNode("friend/friend.csb")
	self:addChild(csbFriendManager)
	local root = csbFriendManager:getChildByName("root")
	table.insert(self.roots, root)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate then
		local action = csb.createTimeline("friend/friend.csb") 
		table.insert(self.actions, action )
		csbFriendManager:runAction(action)
		action:play("window_open", false)
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_05"), nil, {terminal_name = "friend_manager_back", terminal_state = 0}, nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_01"), nil, {terminal_name = "friend_manager_click_friend", terminal_state = 0}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_02"), nil, {terminal_name = "friend_manager_click_send", terminal_state = 0}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_03"), nil, {terminal_name = "friend_manager_click_blacklist", terminal_state = 0}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_04"), nil, {terminal_name = "friend_manager_click_friend_need", terminal_state = 0}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_friend_2"), nil, {terminal_name = "friend_manager_click_send", terminal_state = 0}, nil, 0)
	
	local buttonEndurance = ccui.Helper:seekWidgetByName(root, "Button_02")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		buttonEndurance = ccui.Helper:seekWidgetByName(root, "Button_01")
	end
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_friend_endurance",
	_widget = buttonEndurance,
	_invoke = nil,
	_interval = 0.5,})
	
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_friend_apply",
	_widget = ccui.Helper:seekWidgetByName(root, "Button_04"),
	_invoke = nil,
	_interval = 0.5,})
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		app.load("client.player.UserInformationHeroStorage")
	    fwin:open(UserInformationHeroStorage:new(), fwin._ui)
	    local function responseInitCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then	
	    		state_machine.excute("friend_manager_click_send", 0, "friend_manager_click_send.")
			end
		end
		local currPo = "0"
		if _ED.friend_number == nil or zstring.tonumber(_ED.friend_number) == 0 then
			currPo = "1"
		end
  		protocol_command.random_user_list.param_list = currPo
		NetworkManager:register(protocol_command.random_user_list.code, nil, nil, nil, self, responseInitCallback, false, nil)
	else
		fwin:open(FriendManagerUserInfo:new(), fwin._view)
		state_machine.excute("friend_manager_click_friend", 0, "friend_manager_click_friend.")
	end 
end


function FriendManager:onExit()
	state_machine.remove("friend_manager_back")
	state_machine.remove("friend_manager_click_friend")
	state_machine.remove("friend_manager_click_send")
	state_machine.remove("friend_manager_click_blacklist")
	state_machine.remove("friend_manager_click_friend_need")
end