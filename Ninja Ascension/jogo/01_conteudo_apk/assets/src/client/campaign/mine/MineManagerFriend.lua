----------------------------------------------------------------------------------------------------
-- 说明：点击拜访好友后的弹窗
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MineManagerFriend = class("MineManagerFriendClass", Window)
    
function MineManagerFriend:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}
	
    -- Initialize MineManager page state machine.
    local function init_mine_manager_friend_terminal()
	
		--返回
		local mine_manager_friend_back_terminal = {
            _name = "mine_manager_friend_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(mine_manager_friend_back_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_mine_manager_friend_terminal()
end



function MineManagerFriend:onUpdateDraw()
	
	if table.getn(_ED.manor_friend_info) == 0 then
		fwin:close(self)
		
		function showConfirmTip(instance,n)
			if n == 0 then
				-- 提示显示好友
				app.load("client.friend.FriendManagerRecommend")
				fwin:open(FriendManagerRecommend:new(), fwin._windows)
			end
		end
		
		-- 提示 添加好友
		app.load("client.utils.ConfirmPrompted")
		local tip = ConfirmPrompted:new()
		tip:init(self, showConfirmTip, tipStringInfo_mine_info[31])
		fwin:open(tip,fwin._ui)
	else
		self:setVisible(true)

		local root = self.roots[1]
		local listView = ccui.Helper:seekWidgetByName(root, "ListView_li_frd")
		
		-- 添加缓动
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		MineManagerFriend.asyncIndex = 1
		MineManagerFriend.cacheListView = listView
		
		for k, v in pairs(_ED.manor_friend_info) do
			-- local cell = MineManagerFriendList:createCell()
			-- cell:init(v)
			-- listView:addChild(cell)
			cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)
		end
		listView:requestRefreshView()

		ccui.Helper:seekWidgetByName(root, "Text_ld_fr_2"):setString(getMineManagerSurplusSuppressCount())
	end
end



function MineManagerFriend:loading_cell()
	if MineManagerFriend.cacheListView == nil then
		return 
	end
	local data = _ED.manor_friend_info
	local cell = MineManagerFriendList:createCell()
	cell:init(data[MineManagerFriend.asyncIndex])
	MineManagerFriend.cacheListView:addChild(cell)
	MineManagerFriend.cacheListView:requestRefreshView()
	MineManagerFriend.asyncIndex = MineManagerFriend.asyncIndex + 1
end



function MineManagerFriend:onEnterTransitionFinish()
	
	self:setVisible(false)
	
    local csbMineManager = csb.createNode("campaign/MineManager/attack_territory_frd.csb")
    self:addChild(csbMineManager)
	
   	local root = csbMineManager:getChildByName("root")
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hyld_x"), nil, {func_string = [[state_machine.excute("mine_manager_friend_back", 0, "mine_manager_friend_back.'")]],isPressedActionEnabled = true}, nil, 2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hyld_gb"), nil, {func_string = [[state_machine.excute("mine_manager_friend_back", 0, "mine_manager_friend_back.'")]],isPressedActionEnabled = true}, nil, 2)

	local function responseOverCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			self:setVisible(true)
			local action = csb.createTimeline("campaign/MineManager/attack_territory_frd.csb")
			table.insert(self.actions, action)
			csbMineManager:runAction(action)
			action:setFrameEventCallFunc(function (frame)
				if nil == frame then
					return
				end
				
				local str = frame:getEvent()
				if str == "close" then
					fwin:close(response.node)
				end
			end)
			action:play("window_open", false)
			
		-- 	self:onUpdateDraw()
			if response.node ~= nil then
				response.node:afterRespnseManorFriend()
			end		
		else
			fwin:close(self)
		end

	end
	NetworkManager:register(protocol_command.manor_friend.code, nil, nil, nil, self, responseOverCallback,false)
end

function MineManagerFriend:afterRespnseManorFriend()

	-- self:setVisible(true)
	-- 	local action = csb.createTimeline("campaign/MineManager/attack_territory_frd.csb")
	-- 	table.insert(self.actions, action)
	-- 	csbMineManager:runAction(action)
	-- 	action:setFrameEventCallFunc(function (frame)
	-- 		if nil == frame then
	-- 			return
	-- 		end
			
	-- 		local str = frame:getEvent()
	-- 		if str == "close" then
	-- 			fwin:close(self)
	-- 		end
	-- 	end)
	-- 	action:play("window_open", false)
		
		self:onUpdateDraw()

end
function MineManagerFriend:onExit()
	state_machine.remove("mine_manager_friend_back")
	MineManagerFriend.asyncIndex = 1
	MineManagerFriend.cacheListView = nil
end
