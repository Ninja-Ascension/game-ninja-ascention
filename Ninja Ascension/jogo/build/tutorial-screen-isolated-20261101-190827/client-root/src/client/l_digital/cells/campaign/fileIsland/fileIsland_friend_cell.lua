----------------------------------------------------------------------------------------------------
-- 说明：文件岛好友任务cell
----------------------------------------------------------------------------------------------------
FileIslandFriendCell = class("FileIslandFriendCellClass", Window)
FileIslandFriendCell.__size = nil

function FileIslandFriendCell:ctor()
    self.super:ctor()
	self.roots = {}

	local function init_fileIsland_friend_cell_terminal()
		-- 领取
		local fileIsland_friend_cell_Button_fd_get_terminal = {
            _name = "fileIsland_friend_cell_Button_fd_get",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
            	local _type = params._datas._type

            	local function callback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

						local rewardInfo = getSceneReward(7) 
                        if rewardInfo ~= nil then
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(nil, rewardInfo)
                            fwin:open(getRewardWnd, fwin._ui)
                        end

						state_machine.excute("fileIsland_friends_refresh_list", 0, "") 
					end
				end

				local req = {}
            	req.finderUid = cell.taskData.uid
            	req.taskId = cell.taskData.taskId
            	req.type = _type

            	local str = json.encode(req)
				protocol_command.fileIslandFriendTaskReward.param_list = str
				NetworkManager:register(protocol_command.fileIslandFriendTaskReward.code, nil, nil, nil, nil, callback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 邀请
        local fileIsland_friend_cell_Button_friend_join_terminal = {
            _name = "fileIsland_friend_cell_Button_friend_join",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local lastSendTime = cc.UserDefault:getInstance():getStringForKey(getKey("fileIsland_send_join_time"), "0")
            	local distanceTime = dms.int(dms["play_config"], 112, play_config.param)
            	if os.time() - tonumber(lastSendTime) < distanceTime*60 then
            		local left_time = distanceTime*60 - (os.time() - tonumber(lastSendTime))
            		local time = math.floor((tonumber(left_time)%3600)/60) .. tipStringInfo_time_info[6] .. math.floor(tonumber(left_time)%60).. tipStringInfo_time_info[7]
            		TipDlg.drawTextDailog(string.format(tipStringInfo_file_island_tips[17], time))
            		return
            	end
            	local cell = params._datas._cell

	            local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	cc.UserDefault:getInstance():setStringForKey(getKey("fileIsland_send_join_time"), os.time())
                        TipDlg.drawTextDailog(_new_interface_text[121])
                    end
                end

                local paramsInfo = _ED.user_info.user_name .. "|" .. cell.taskData.uid .. "," .. cell.taskData.taskId
                protocol_command.send_message.param_list = "\r\n19\r\n0\r\n46\r\n"..paramsInfo
                -- Se ESPERA la respuesta en vez de fingirla.
                NetworkManager:socketRequest(protocol_command.send_message.code, instance, responseSendMessageCallback)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 信息
        local fileIsland_friend_cell_Button_fd_sin_infor_terminal = {
            _name = "fileIsland_friend_cell_Button_fd_sin_infor",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

            	local my_table = params._datas._cell.my_table
            	local taskData = params._datas._cell.taskData
            	if taskData.listType == 1 and taskData.cellType == 3 then
            		my_table = params._datas._cell.friend_table
            	end

            	state_machine.excute("FileIslandFriendCellInfo_open", 0, {my_table = my_table, taskData = taskData}) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 加入
        local fileIsland_friend_cell_Button_friend_add_terminal = {
            _name = "fileIsland_friend_cell_Button_friend_add",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
            	local data = cell.taskData
            	local req = {}
            	req.finderUid = data.uid
            	req.taskId = data.taskId
            	local str = json.encode(req)

            	local function callback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("fileIsland_friends_request_and_refresh_list", 0, "") 
					end
				end
				protocol_command.fileIslandFriendTaskJoin.param_list = str
				NetworkManager:register(protocol_command.fileIslandFriendTaskJoin.code, nil, nil, nil, nil, callback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(fileIsland_friend_cell_Button_fd_get_terminal)
		state_machine.add(fileIsland_friend_cell_Button_friend_join_terminal)
		state_machine.add(fileIsland_friend_cell_Button_fd_sin_infor_terminal)
		state_machine.add(fileIsland_friend_cell_Button_friend_add_terminal)
		
        state_machine.init()
	end

	init_fileIsland_friend_cell_terminal()
end


function FileIslandFriendCell:onUpdateDraw()
	local root = self.roots[1]

	state_machine.excute("notification_center_update", 0, "push_notification_fileIsland_friend_cell_push")
	if self.taskData.cellType == 1 then
		-- 头像
		if self.Panel_role then
			self.Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%s.png", self.my_table.headId))
		end

		-- 我的任务描述
		local killCount = self.taskData.selfChallengeTimes
		local word_info = dms.element(dms["word_mould"], self.my_table.npcDesc)
		self.Text_friend_role_t:setString(word_info[3]..killCount .. "/" .. self.my_table.npcNum)

		if tonumber(killCount) < tonumber(self.my_table.npcNum) then
			self.Text_friend_role_t:setColor(cc.c3b(243,243,84))
		else
			self.Text_friend_role_t:setColor(cc.c3b(16,218,16))
		end

		-- 我的任务奖励
		local rewards = zstring.split(self.my_table.reward, "|")
		for i, v in pairs(rewards) do
			local reward = zstring.split(v, ",")
        	local rewardType = zstring.tonumber(reward[1])
        	local node = ResourcesIconCell:createCell()
            node:init(rewardType, tonumber(reward[3]), tonumber(reward[2]), nil, nil, true, true, 1)
            local panel = ccui.Helper:seekWidgetByName(root, "Panel_friend_role_icon_" .. i)
            if panel then
            	panel:addChild(node) 
            end
		end

		if self.taskData.curProgress == 1 then
			self.Image_fd_completed:setVisible(true)
			if self.Button_fd_get then
				self.Button_fd_get:setVisible(false)
			end
		else
			if self.Button_fd_get then
				self.Button_fd_get:setVisible(true)
				-- 不可领取
				if tonumber(killCount) < tonumber(self.my_table.npcNum) then
					self.Button_fd_get:setBright(false)
				-- 可领取
				else
					self.Button_fd_get:setBright(true)
				end
			end
		end

	elseif self.taskData.cellType == 2 then
		-- 我的头像
		if self.Panel_friend_role_icon_1 then
			local props_bg_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", self.my_table.npcQuality))
		    if props_bg_icon ~= nil then
		        props_bg_icon:setPosition(cc.p(self.Panel_friend_role_icon_1:getContentSize().width / 2, self.Panel_friend_role_icon_1:getContentSize().height / 2))
		        self.Panel_friend_role_icon_1:addChild(props_bg_icon)
		    end

		    local props_icon = cc.Sprite:create(string.format("images/ui/props/props_%d.png", self.my_table.headId))
		    if props_icon ~= nil then
		        props_icon:setPosition(cc.p(self.Panel_friend_role_icon_1:getContentSize().width / 2, self.Panel_friend_role_icon_1:getContentSize().height / 2))
		        self.Panel_friend_role_icon_1:addChild(props_icon)
		    end
		end

		-- 我的昵称
		self.Text_friend_player:setString(self.taskData.otherUserInfo.nickName)

		-- 我的任务描述
		local killCount = self.taskData.selfChallengeTimes
		local word_info = dms.element(dms["word_mould"], self.my_table.npcDesc)
		self.Text_friend_role_t:setString(word_info[3]..killCount .. "/" .. self.my_table.npcNum)

		if tonumber(killCount) < tonumber(self.my_table.npcNum) then
			self.Text_friend_role_t:setColor(cc.c3b(243,243,84))
		else
			self.Text_friend_role_t:setColor(cc.c3b(16,218,16))
		end

		if self.taskData.curProgress == 1 then
			if self.Image_fd_cp_completed_1 then
				self.Image_fd_cp_completed_1:setVisible(true)
			end

			if self.Button_fd_get then
				self.Button_fd_get:setVisible(false)
			end
		else
			if self.Image_fd_cp_completed_1 then
				self.Image_fd_cp_completed_1:setVisible(false)
			end

			if self.Button_fd_get then
				self.Button_fd_get:setVisible(true)
				-- 不可领取
				if tonumber(killCount) < tonumber(self.my_table.npcNum) then
					self.Button_fd_get:setBright(false)
				-- 可领取
				else
					self.Button_fd_get:setBright(true)
				end
			end
		end


		-- 我的任务奖励
		local rewards = zstring.split(self.my_table.reward, "|")
		for i, v in pairs(rewards) do
			local reward = zstring.split(v, ",")
        	local rewardType = zstring.tonumber(reward[1])
        	local node = ResourcesIconCell:createCell()
            node:init(rewardType, tonumber(reward[3]), tonumber(reward[2]), nil, nil, true, true, 1)
            local panel = ccui.Helper:seekWidgetByName(root, "Panel_friend_role_icon_jl_" .. i)
            if panel then
            	panel:addChild(node) 
            end
		end

		-- 好友的头像
		if self.Panel_friend_role_icon_2 then
			local props_bg_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", self.friend_table.npcQuality))
		    if props_bg_icon ~= nil then
		        props_bg_icon:setPosition(cc.p(self.Panel_friend_role_icon_2:getContentSize().width / 2, self.Panel_friend_role_icon_2:getContentSize().height / 2))
		        self.Panel_friend_role_icon_2:addChild(props_bg_icon)
		    end

		    local props_icon = cc.Sprite:create(string.format("images/ui/props/props_%d.png", self.friend_table.headId))
		    if props_icon ~= nil then
		        props_icon:setPosition(cc.p(self.Panel_friend_role_icon_2:getContentSize().width / 2, self.Panel_friend_role_icon_2:getContentSize().height / 2))
		        self.Panel_friend_role_icon_2:addChild(props_icon)
		    end
		end

		-- 好友的昵称
		if next(self.taskData.joinFriends) == nil then
			self.Text_friend_player_1:setString(_new_interface_text[314])

			if self.Button_fd_get_2 then
				self.Button_fd_get_2:setVisible(false)
			end
			self.Button_friend_join:setVisible(true)
		else
			self.Text_friend_player_1:setString(self.taskData.joinFriends[1].nickName)

			if self.Button_fd_get_2 then
				self.Button_fd_get_2:setVisible(true)
			end
			self.Button_friend_join:setVisible(false)
		end

		-- 好友的任务描述
		local killCount2 = self.taskData.friendChallengeTimes
		local friend_npcDesc = dms.element(dms["word_mould"], self.friend_table.npcDesc)
		self.Text_friend_role_t_1:setString(friend_npcDesc[3]..killCount2 .. "/" .. self.friend_table.npcNum)

		if tonumber(killCount2) < tonumber(self.friend_table.npcNum) then
			self.Text_friend_role_t_1:setColor(cc.c3b(243,243,84))
		else
			self.Text_friend_role_t_1:setColor(cc.c3b(16,218,16))
		end

		if self.Button_fd_get_2 then
			-- 不可领取
			--if (tonumber(killCount) < tonumber(self.my_table.npcNum) or tonumber(killCount2) < tonumber(self.friend_table.npcNum)) or table.containValue(self.taskData.rewardFriends, tonumber(_ED.user_info.user_id)) then
				--self.Button_fd_get_2:setBright(false)
			if self.taskData.rewardFriends and self.taskData.rewardFriends ~= nil and table.containValue(self.taskData.rewardFriends, tonumber(_ED.user_info.user_id)) then
				if self.Image_fd_cp_completed_2 then
					self.Image_fd_cp_completed_2:setVisible(true)
				end

				if self.Button_fd_get_2 then
					self.Button_fd_get_2:setVisible(false)
				end

				if self.Button_friend_join then
					self.Button_friend_join:setVisible(false)
				end
			else
				if (tonumber(killCount) < tonumber(self.my_table.npcNum) or tonumber(killCount2) < tonumber(self.friend_table.npcNum)) or table.containValue(self.taskData.rewardFriends, tonumber(_ED.user_info.user_id)) then
					self.Button_fd_get_2:setBright(false)
				else
					-- 可领取
					self.Button_fd_get_2:setBright(true)
				end
			end
		end

		-- 好友的任务奖励
		local rewards = zstring.split(self.friend_table.reward, "|")
		for i, v in pairs(rewards) do
			local reward = zstring.split(v, ",")
        	local rewardType = zstring.tonumber(reward[1])
        	local node = ResourcesIconCell:createCell()
            node:init(rewardType, tonumber(reward[3]), tonumber(reward[2]), nil, nil, true, true, 1)
            local panel = ccui.Helper:seekWidgetByName(root, "Panel_friend_role_icon_" .. i .. "_jl")
            if panel then
            	panel:addChild(node) 
            end
		end

		

	elseif self.taskData.cellType == 3 then
		-- 任务发现者的任务数
		local killCount = self.taskData.selfChallengeTimes

		-- 任务发现者的头像
		if self.Panel_friend_role_icon_1 then
			local props_bg_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", self.my_table.npcQuality))
		    if props_bg_icon ~= nil then
		        props_bg_icon:setPosition(cc.p(self.Panel_friend_role_icon_1:getContentSize().width / 2, self.Panel_friend_role_icon_1:getContentSize().height / 2))
		        self.Panel_friend_role_icon_1:addChild(props_bg_icon)
		    end

		    local props_icon = cc.Sprite:create(string.format("images/ui/props/props_%d.png", self.my_table.headId))
		    if props_icon ~= nil then
		        props_icon:setPosition(cc.p(self.Panel_friend_role_icon_1:getContentSize().width / 2, self.Panel_friend_role_icon_1:getContentSize().height / 2))
		        self.Panel_friend_role_icon_1:addChild(props_icon)
		    end
		end

		-- 任务发现者的昵称
		self.Text_friend_player:setString(self.taskData.otherUserInfo.nickName)

		-- 任务发现者的任务描述
		local friend_npcDesc = dms.element(dms["word_mould"], self.my_table.npcDesc)
		self.Text_friend_role_t:setString(friend_npcDesc[3]..killCount .. "/" .. self.my_table.npcNum)

		if tonumber(killCount) < tonumber(self.my_table.npcNum) then
			self.Text_friend_role_t:setColor(cc.c3b(243,243,84))
		else
			self.Text_friend_role_t:setColor(cc.c3b(16,218,16))
		end


		-- 任务参与者的任务数
		local killCount2 = self.taskData.friendChallengeTimes

		-- 任务参与者昵称
		if self.taskData.listType == 2 then
			self.Text_friend_player_1:setString(_new_interface_text[314])
			self.Button_friend_add:setVisible(true)
		else
			self.Text_friend_player_1:setString(self.taskData.joinFriends[1].nickName)
			self.Button_friend_add:setVisible(false)

			if self.Button_fd_get then
				self.Button_fd_get:setVisible(true)
				-- 不可领取
				if tonumber(killCount2) < tonumber(self.friend_table.npcNum) then
					self.Button_fd_get:setBright(false)
				-- 可领取
				else
					if tonumber(self.taskData.selfChallengeTimes) >= tonumber(self.my_table.npcNum) then
						self.Button_fd_get:setBright(true)
					else
						self.Button_fd_get:setBright(false)
					end
				end
			end

		end

		-- 任务参与者的任务描述
		local word_info = dms.element(dms["word_mould"], self.friend_table.npcDesc)
		self.Text_friend_role_t_1:setString(word_info[3]..killCount2 .. "/" .. self.friend_table.npcNum)

		if tonumber(killCount2) < tonumber(self.friend_table.npcNum) then
			self.Text_friend_role_t_1:setColor(cc.c3b(243,243,84))
		else
			self.Text_friend_role_t_1:setColor(cc.c3b(16,218,16))
		end

		-- 任务参与者的npc头像
		if self.Panel_friend_role_icon_1_0 then
			local props_bg_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", self.friend_table.npcQuality))
		    if props_bg_icon ~= nil then
		        props_bg_icon:setPosition(cc.p(self.Panel_friend_role_icon_1_0:getContentSize().width / 2, self.Panel_friend_role_icon_1_0:getContentSize().height / 2))
		        self.Panel_friend_role_icon_1_0:addChild(props_bg_icon)
		    end

		    local props_icon = cc.Sprite:create(string.format("images/ui/props/props_%d.png", self.friend_table.headId))
		    if props_icon ~= nil then
		        props_icon:setPosition(cc.p(self.Panel_friend_role_icon_1_0:getContentSize().width / 2, self.Panel_friend_role_icon_1_0:getContentSize().height / 2))
		        self.Panel_friend_role_icon_1_0:addChild(props_icon)
		    end
		end

		-- 任务参与者的任务奖励
		local rewards = zstring.split(self.friend_table.reward, "|")
		for i, v in pairs(rewards) do
			local reward = zstring.split(v, ",")
        	local rewardType = zstring.tonumber(reward[1])
        	local node = ResourcesIconCell:createCell()
            node:init(rewardType, tonumber(reward[3]), tonumber(reward[2]), nil, nil, true, true, 1)
            local panel = ccui.Helper:seekWidgetByName(root, "Panel_friend_role_icon_" .. i .. "_jl")  
            if panel then
            	panel:addChild(node) 
            end
		end

		-- 任务参与者完成
		--if not table.containValue(self.taskData.rewardFriends, tonumber(_ED.user_info.user_id)) then
		if self.taskData.rewardFriends and self.taskData.rewardFriends ~= nil and table.containValue(self.taskData.rewardFriends, tonumber(_ED.user_info.user_id)) then
			self.Image_fd_join_completed:setVisible(true)
			self.Button_friend_add:setVisible(false)
			self.Button_fd_get:setVisible(false)
		end

	end
end

function FileIslandFriendCell:onUpdate(dt)
	local root = self.roots[1]
    if root == nil then
        return
    end

    if self.taskData == nil or self.taskData.endTime == nil then
        return
    end

    local lastCDTime = self.taskData.endTime
    if lastCDTime and lastCDTime > 0 then
        local current = _ED.system_time + (os.time() - _ED.native_time)
        local surplus_time = lastCDTime - current

        if self.Text_fd_sin_time_n then
            self.Text_fd_sin_time_n:setString(getRedAlertTimeActivityFormat(surplus_time))
            if surplus_time <= 3600 then
            	self.Text_fd_sin_time_n:setColor(cc.c3b(255, 0, 0))
            else
            	self.Text_fd_sin_time_n:setColor(cc.c3b(255, 255, 255))
            end
        end

        -- 时间到
        if surplus_time <= 0 and self.Text_fd_sin_time_n:isVisible() == true then
            self.Text_fd_sin_time_n:setVisible(false)
            state_machine.excute("fileIsland_friends_request_and_refresh_list", 0, "") 
        end
    end

    local joinFriendData = self.taskData.joinFriends[1]
    if joinFriendData and joinFriendData.endTime and tonumber(self.taskData.friendChallengeTimes) < tonumber(self.friend_table.npcNum) then
    	local current = _ED.system_time + (os.time() - _ED.native_time)
        local surplus_time = joinFriendData.endTime - current

        if self.Text_fd_sin_time_n then
            self.Text_fd_sin_time_n:setString(getRedAlertTimeActivityFormat(surplus_time))
        end

        -- 时间到
        if surplus_time <= 0 and self.Text_fd_sin_time_n:isVisible() == true then
            self.Text_fd_sin_time_n:setVisible(false)
            state_machine.excute("fileIsland_friends_request_and_refresh_list", 0, "") 
        end
   	end

end

function FileIslandFriendCell:onInit()
	local csb = nil
	if self.taskData.cellType == 1 then
		csb = "campaign/explore/explore_friend_single_task_cell.csb"
	elseif self.taskData.cellType == 2 then
		csb = "campaign/explore/explore_friend_cooperation_1_cell.csb"
	elseif self.taskData.cellType == 3 then
		csb = "campaign/explore/explore_friend_cooperation_2_cell.csb"
	end

    local root = cacher.createUIRef(csb, "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	-- 领取自己
	self.Button_fd_get = ccui.Helper:seekWidgetByName(root, "Button_fd_get")
	if self.Button_fd_get then
		fwin:addTouchEventListener(self.Button_fd_get, nil, 
		{
			terminal_name = "fileIsland_friend_cell_Button_fd_get", 
			terminal_state = 0, 
			isPressedActionEnabled = true,
			_cell = self,
			_type = 0,
		}, 
		nil, 0)
	end

	-- 邀请
	self.Button_friend_join = ccui.Helper:seekWidgetByName(root, "Button_friend_join")
	if self.Button_friend_join then
		fwin:addTouchEventListener(self.Button_friend_join, nil, 
		{
			terminal_name = "fileIsland_friend_cell_Button_friend_join", 
			terminal_state = 0, 
			isPressedActionEnabled = true,
			_cell = self,
		}, 
		nil, 0)
	end

	-- 信息
	local Button_fd_sin_infor = ccui.Helper:seekWidgetByName(root, "Button_fd_sin_infor") 
	if Button_fd_sin_infor then
		fwin:addTouchEventListener(Button_fd_sin_infor, nil, 
		{
			terminal_name = "fileIsland_friend_cell_Button_fd_sin_infor", 
			terminal_state = 0, 
			isPressedActionEnabled = true,
			_cell = self,
		}, 
		nil, 0)
	end

	-- 加入
	self.Button_friend_add = ccui.Helper:seekWidgetByName(root, "Button_friend_add") 
	if self.Button_friend_add then
		fwin:addTouchEventListener(self.Button_friend_add, nil, 
		{
			terminal_name = "fileIsland_friend_cell_Button_friend_add", 
			terminal_state = 0, 
			isPressedActionEnabled = true,
			_cell = self,
		}, 
		nil, 0)
	end

	-- 倒计时
	self.Text_fd_sin_time_n = ccui.Helper:seekWidgetByName(root, "Text_fd_sin_time_n")

	if self.taskData.cellType == 1 then
		-- 任务名
		self.Text_friend_role_t = ccui.Helper:seekWidgetByName(root, "Text_friend_role_t") 
		-- npc头像
		self.Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role") 
		-- 已领取
		self.Image_fd_completed = ccui.Helper:seekWidgetByName(root, "Image_fd_completed") 

	elseif self.taskData.cellType == 2 then
		-- 我的名称
		self.Text_friend_player = ccui.Helper:seekWidgetByName(root, "Text_friend_player") 
		-- 我的任务名
		self.Text_friend_role_t = ccui.Helper:seekWidgetByName(root, "Text_friend_role_t") 
		-- 我的任务npc头像
		self.Panel_friend_role_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_friend_role_icon_1") 
		-- 我的已完成
		self.Image_fd_cp_completed_1 = ccui.Helper:seekWidgetByName(root, "Image_fd_cp_completed_1") 

		-- 好友玩家名
		self.Text_friend_player_1 = ccui.Helper:seekWidgetByName(root, "Text_friend_player_1") 
		-- 好友任务名
		self.Text_friend_role_t_1 = ccui.Helper:seekWidgetByName(root, "Text_friend_role_t_1")  
		-- 好友任务npc头像
		self.Panel_friend_role_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_friend_role_icon_2") 
		-- 领取好友的奖励
		self.Button_fd_get_2 = ccui.Helper:seekWidgetByName(root, "Button_fd_get_2") 
		if self.Button_fd_get_2 then
			fwin:addTouchEventListener(self.Button_fd_get_2, nil, 
			{
				terminal_name = "fileIsland_friend_cell_Button_fd_get", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_cell = self,
				_type = 1,
			}, 
			nil, 0)
		end

		-- 好友的已完成
		self.Image_fd_cp_completed_2 = ccui.Helper:seekWidgetByName(root, "Image_fd_cp_completed_2") 
		self.Image_fd_cp_completed_2:setVisible(false)

	elseif self.taskData.cellType == 3 then
		-- 好友玩家名
		self.Text_friend_player = ccui.Helper:seekWidgetByName(root, "Text_friend_player") 
		-- 好友任务名
		self.Text_friend_role_t = ccui.Helper:seekWidgetByName(root, "Text_friend_role_t") 
		-- 好友任务npc头像
		self.Panel_friend_role_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_friend_role_icon_1")
		-- 我的任务npc头像
		self.Panel_friend_role_icon_1_0 = ccui.Helper:seekWidgetByName(root, "Panel_friend_role_icon_1_0")
 		-- 我的玩家名
		self.Text_friend_player_1 = ccui.Helper:seekWidgetByName(root, "Text_friend_player_1") 
		-- 我的任务名
		self.Text_friend_role_t_1 = ccui.Helper:seekWidgetByName(root, "Text_friend_role_t_1")
		-- 已完成
		self.Image_fd_join_completed = ccui.Helper:seekWidgetByName(root, "Image_fd_join_completed") 

		-- self.my_reward_list = {}
		-- local Panel_friend_role_icon_1_jl = ccui.Helper:seekWidgetByName(root, "Panel_friend_role_icon_1_jl") 
		-- local Panel_friend_role_icon_2_jl = ccui.Helper:seekWidgetByName(root, "Panel_friend_role_icon_2_jl") 
		-- local Panel_friend_role_icon_3_jl = ccui.Helper:seekWidgetByName(root, "Panel_friend_role_icon_3_jl") 
		-- table.insert(self.my_reward_list, Panel_friend_role_icon_1_jl)
		-- table.insert(self.my_reward_list, Panel_friend_role_icon_2_jl)
		-- table.insert(self.my_reward_list, Panel_friend_role_icon_3_jl)
	end

	local panel_size = root:getContentSize()
	self:onUpdateDraw()

	self:setContentSize(panel_size)
	if FileIslandFriendCell.__size == nil then
		FileIslandFriendCell.__size = panel_size
	end

	self:registerOnNoteUpdate(self, 1)
end

function FileIslandFriendCell:reload()

    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:onInit()
end

function FileIslandFriendCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end

    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function FileIslandFriendCell:clearUIInfo()
    local root = self.roots[1]

end

function FileIslandFriendCell:onExit()
	self:clearUIInfo()
end

function FileIslandFriendCell:initData()
	local configId = self.taskData.configId
	-- 任务类型（1：单人任务 2：协作任务）
	local taskType = self.taskData.type
	local configdata = dms.element(dms["file_island_friend_task"], configId)

	-- 任务发现者的配置
	self.my_table = {}
	self.my_table.npcId = dms.atos(configdata, file_island_friend_task.npcId)
	self.my_table.npcNum = dms.atos(configdata, file_island_friend_task.npcNum)
	self.my_table.npcDesc = dms.atos(configdata, file_island_friend_task.npcDesc)
	self.my_table.npcQuality = dms.atos(configdata, file_island_friend_task.npcQuality)
	self.my_table.npcInfo = dms.atos(configdata, file_island_friend_task.npcInfo)
	self.my_table.reward = dms.atos(configdata, file_island_friend_task.reward)

	local initState = dms.string(dms["ship_mould"], self.my_table.npcId, ship_mould.captain_name)
	local evoIds = zstring.split(dms.string(dms["ship_mould"], self.my_table.npcId, ship_mould.fitSkillTwo), ",")
	local evoId = evoIds[tonumber(initState)]
	self.my_table.headId = dms.string(dms["ship_evo_mould"], evoId, ship_evo_mould.form_id)

	-- 任务参与者的配置
	if taskType == 2 then
		self.friend_table = {}
		self.friend_table.npcId = dms.atos(configdata, file_island_friend_task.friend_npcId)
		self.friend_table.npcNum = dms.atos(configdata, file_island_friend_task.friend_npcNum)
		self.friend_table.npcDesc = dms.atos(configdata, file_island_friend_task.friend_npcDesc)
		self.friend_table.npcQuality = dms.atos(configdata, file_island_friend_task.friend_npcQuality)
		self.friend_table.npcInfo = dms.atos(configdata, file_island_friend_task.friend_npcInfo)
		self.friend_table.reward = dms.atos(configdata, file_island_friend_task.friend_reward)

		local initState = dms.string(dms["ship_mould"], self.friend_table.npcId, ship_mould.captain_name)
		local evoIds = zstring.split(dms.string(dms["ship_mould"], self.friend_table.npcId, ship_mould.fitSkillTwo), ",")
		local evoId = evoIds[tonumber(initState)]
		self.friend_table.headId = dms.string(dms["ship_evo_mould"], evoId, ship_evo_mould.form_id)

	end

end

function FileIslandFriendCell:init(params, index)
	self.taskData = params or {}
	self:initData()

	self.index = index

	if index and index < 6 then
		self:onInit()
	end

	if FileIslandFriendCell.__size then
		self:setContentSize(FileIslandFriendCell.__size)

	end
end

function FileIslandFriendCell:createCell()
	local cell = FileIslandFriendCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


