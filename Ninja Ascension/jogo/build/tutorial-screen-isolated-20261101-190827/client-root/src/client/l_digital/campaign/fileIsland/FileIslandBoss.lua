-- ----------------------------------------------------------------------------------------------------
-- 说明：文件岛boss
-------------------------------------------------------------------------------------------------------

FileIslandBoss = class("FileIslandBossClass", Window)

local fileIsland_window_team_boss_open_terminal = {
    _name = "fileIsland_window_team_boss_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
  --   	local function responseFileIslandBossInitCallback(response)
		-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		-- 		local FileIslandBossWindow = fwin:find("FileIslandBossClass")
		--     	if FileIslandBossWindow == nil then
		--     		fwin:open(FileIslandBoss:new():init(params), fwin._view)
		--     	end
		-- 	end
		-- end
		-- protocol_command.fileIslandBossInfo.param_list = ""
		-- NetworkManager:register(protocol_command.fileIslandBossInfo.code, nil, nil, nil, nil, responseFileIslandBossInitCallback, false, nil)

		local FileIslandBossWindow = fwin:find("FileIslandBossClass")
    	if FileIslandBossWindow == nil then
    		fwin:open(FileIslandBoss:new():init(params), fwin._view)
    	end

    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fileIsland_window_team_boss_open_terminal)
state_machine.init()

function FileIslandBoss:ctor()
    self.super:ctor()
	self.roots = {}

	app.load("client.l_digital.cells.campaign.fileIsland.fileIsland_boss_cell")

	local function init_fileIsland_friends_terminal()
		-- 关闭
		local fileIsland_boss_close_terminal = {
            _name = "fileIsland_boss_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

            	state_machine.excute("fileIsland_window_updateDraw_boss_redPoint", 0, "")

				fwin:close(fwin:find("FileIslandBossClass"))

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 参加
        local fileIsland_boss_Button_explore_join_terminal = {
            _name = "fileIsland_boss_Button_explore_join",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local node = params._datas.node
				local max = dms.string(dms["play_config"], 99, play_config.param)
				if tonumber(max) - #node.bossInfo[node.selectIndex].rewardFriends <=0 then
					TipDlg.drawTextDailog(tipStringInfo_file_island_tips[19])
					return
				end
				state_machine.excute("fileIsland_formation_open", 0, {info = node.bossInfo[node.selectIndex], infoType = 1,  attackFriendBossCount = node.data.attackFriendBossCount})

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local fileIsland_boss_Button_explore_boss_refresh_terminal = {
            _name = "fileIsland_boss_Button_explore_boss_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseFileIslandBossInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if params._datas then
							local node = params._datas.node
							node:initData()
							node:onUpdateDraw()
							node:onUpdateDrawBossInfo(node.selectIndex)
						else
							instance:initData()
							instance:onUpdateDraw()
							instance:onUpdateDrawBossInfo(instance.selectIndex)
						end
						TipDlg.drawTextDailog(tipStringInfo_file_island_tips[18])
					end
				end
				protocol_command.fileIslandBossInfo.param_list = ""
				NetworkManager:register(protocol_command.fileIslandBossInfo.code, nil, nil, nil, nil, responseFileIslandBossInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新右边boss信息
        local fileIsland_boss_refresh_boss_info_terminal = {
            _name = "fileIsland_boss_refresh_boss_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDrawBossInfo(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fileIsland_boss_close_terminal)
        state_machine.add(fileIsland_boss_Button_explore_join_terminal)
        state_machine.add(fileIsland_boss_refresh_boss_info_terminal)
        state_machine.add(fileIsland_boss_Button_explore_boss_refresh_terminal)

		state_machine.init()
	end

	init_fileIsland_friends_terminal()
end

-- 刷新右侧boss信息
function FileIslandBoss:onUpdateDrawBossInfo(params)
	local root = self.roots[1]

	self.Image_explor_boss:setVisible(false)
	self.Text_explor_boss_challenged:setVisible(false)

	for i = 1, 4 do
		local node = ccui.Helper:seekWidgetByName(root, "Panel_explore_boss_drop_icon_" .. i)
		node:setVisible(false)
	end

	local bossInfo = self.bossInfo[params]
	if bossInfo == nil then
		return
	end

	-- boss名
	local npcData = dms.element(dms["npc"], bossInfo.npcId)
	local nickId = dms.atos(npcData, npc.npc_name)
	local nick = dms.element(dms["word_mould"], nickId)
	self.Text_explore_boss_name:setString(nick[3])

	-- 剩余次数
	local max = dms.string(dms["play_config"], 99, play_config.param)
	self.Text_explore_friend_times_n:setString(tonumber(max) - #bossInfo.rewardFriends)

	-- 我的boss
	if bossInfo.uid == tonumber(_ED.user_info.user_id) then
		self.Image_explor_boss:setVisible(true)
	end

	-- 已挑战
	if bossInfo.isChallenged == 1 then
		self.Text_explor_boss_challenged:setVisible(true)
		-- self.Button_explore_join:setBright(false)
		-- self.Button_explore_join:setTouchEnabled(false)
		-- self.Panel_effect_kdtxcj:setVisible(false)
	else
		-- self.Button_explore_join:setBright(true)
		-- self.Button_explore_join:setTouchEnabled(true)
		-- self.Panel_effect_kdtxcj:setVisible(true)
	end

	local picId = dms.atos(npcData, npc.head_pic)
	pidId = zstring.split(picId, ",")[2]
	self.Panel_explore_boss_head:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", pidId))

	-- 剩余时间
	local current = _ED.system_time + (os.time() - _ED.native_time)
    local surplus_time = bossInfo.endTime - current
    self.Text_explore_remaining_time_n:setString(getRedAlertTimeActivityFormat(surplus_time))

    -- 可参加好友个数
    local max = dms.string(dms["play_config"], 100, play_config.param)
    self.Text_explore_friend_boss_n:setString((max - self.data.attackFriendBossCount) .. "/" .. max)

    -- 奖励
    local rewardID = dms.atos(npcData, npc.drop_library)
    local rewardInfoString = dms.string(dms["scene_reward_ex"], rewardID, scene_reward_ex.show_reward)

	local rewards = zstring.split(rewardInfoString, "|")

	-- 显示掉落
	for i = 1, #rewards do
		local reward = zstring.split(rewards[i], ",")
		local node = ccui.Helper:seekWidgetByName(root, "Panel_explore_boss_drop_icon_" .. i)
		node:setVisible(true)
		local icon = ResourcesIconCell:createCell()
        icon:init(tonumber(reward[2]), tonumber(reward[3]), tonumber(reward[1]), nil, nil, true, true, 1)
		node:addChild(icon)
	end

end

function FileIslandBoss:onUpdateDraw()
	local root = self.roots[1]
	
	-- 列表
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_explore")
	listView:removeAllItems()
	listView:jumpToTop()

	for i = 1, #self.bossInfo do
		local cellData = self.bossInfo[i]
		local cell = FileIslandBossCell:createCell()
		cell:init(cellData, i, self)
		listView:addChild(cell)
	end

	listView:requestRefreshView()
	
	self.listView = listView
	self.list_view_posY = listView:getInnerContainer():getPositionY()

end

function FileIslandBoss:onUpdate(dt)
	if self.bossInfo and self.selectIndex then
    	local data = self.bossInfo[self.selectIndex]
    	if data and data.endTime and data.endTime > 0 then
    		local current = _ED.system_time + (os.time() - _ED.native_time)
	        local surplus_time = data.endTime - current

	        if self.Text_explore_remaining_time_n then
	            self.Text_explore_remaining_time_n:setString(getRedAlertTimeActivityFormat(surplus_time))
	        end
    	end
    end

    if self.listView ~= nil then
        local size = self.listView:getContentSize()
        local posY = self.listView:getInnerContainer():getPositionY()
        if self.list_view_posY == posY then
            return
        end

        self.list_view_posY = posY
        local items = self.listView:getItems()

        if items[1] == nil then
            return
        end

        local itemSize = items[1]:getContentSize()

        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end

end

function FileIslandBoss:onInit()
	local csb_explore_friend_task = csb.createNode("campaign/explore/explore_boss.csb")
	local root = csb_explore_friend_task:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csb_explore_friend_task)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_phb_back"), nil, 
	{
		terminal_name = "fileIsland_boss_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 0)

	-- 刷新
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_boss_refresh"), nil, 
	{
		terminal_name = "fileIsland_boss_Button_explore_boss_refresh", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		node = self,
	},
	nil, 0)

	-- 参加
	self.Button_explore_join = ccui.Helper:seekWidgetByName(root, "Button_explore_join")
	fwin:addTouchEventListener(self.Button_explore_join, nil, 
	{
		terminal_name = "fileIsland_boss_Button_explore_join", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		node = self,
	},
	nil, 0)

    -- 角色底
    local Panel_effect_kdtxdz = ccui.Helper:seekWidgetByName(root, "Panel_effect_kdtxdz")
    if Panel_effect_kdtxdz then
    	local jsonFile = "images/ui/effice/effect_kdtxdz/effect_kdtxdz.json" 
	    local atlasFile = "images/ui/effice/effect_kdtxdz/effect_kdtxdz.atlas" 
	    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	    animation.animationNameList = {"animation"}
	    sp.initArmature(animation, false)
	    animation._invoke = changeActionCallback
	    Panel_effect_kdtxdz:addChild(animation)
	    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	    csb.animationChangeToAction(animation, 0, 1, false)
    end
    
	-- boss名
	self.Text_explore_boss_name = ccui.Helper:seekWidgetByName(root, "Text_explore_boss_name")
	-- 剩余次数
	self.Text_explore_friend_times_n = ccui.Helper:seekWidgetByName(root, "Text_explore_friend_times_n")
	-- 总次数
	self.Text_explore_friend_times = ccui.Helper:seekWidgetByName(root, "Text_explore_friend_times")
	local max = dms.string(dms["play_config"], 99, play_config.param)
	self.Text_explore_friend_times:setString("/" .. max)

	-- 剩余时间
	self.Text_explore_remaining_time_n = ccui.Helper:seekWidgetByName(root, "Text_explore_remaining_time_n")
	-- 我的boss
	self.Image_explor_boss = ccui.Helper:seekWidgetByName(root, "Image_explor_boss")
	-- 已挑战
	self.Text_explor_boss_challenged = ccui.Helper:seekWidgetByName(root, "Text_explor_boss_challenged")
	-- boss图像
	self.Panel_explore_boss_head = ccui.Helper:seekWidgetByName(root, "Panel_explore_boss_head")
	-- 可参加好友个数
	self.Text_explore_friend_boss_n = ccui.Helper:seekWidgetByName(root, "Text_explore_friend_boss_n")
	-- 参加动画
	self.Panel_effect_kdtxcj = ccui.Helper:seekWidgetByName(root, "Panel_effect_kdtxcj")
	local jsonFile = "images/ui/effice/effect_kdtxcj/effect_kdtxcj.json" 
    local atlasFile = "images/ui/effice/effect_kdtxcj/effect_kdtxcj.atlas" 
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    animation.animationNameList = {"animation"}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    self.Panel_effect_kdtxcj:addChild(animation)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation, 0, 1, false)
	
	self.selectIndex = 1
	self:onUpdateDraw()
	self:onUpdateDrawBossInfo(self.selectIndex)

    -- 顶部用户信息
	app.load("client.l_digital.campaign.fileIsland.FileIslandShopBuyTop") 					
	local userinfo = FileIslandShopBuyTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

	self:registerOnNodeEvent(self)
	self:registerOnNoteUpdate(self, 1)
end

function FileIslandBoss:initData()
	self.data = _ED.fileIsland.bossInfo
	self.bossInfo = _ED.fileIsland.bossInfo.bossInfo

	for i = 1, #self.bossInfo do
		local info = self.bossInfo[i]
		-- 我发现的boss为1
		if info.uid == tonumber(_ED.user_info.user_id) then
			info.isMy = 1
		else
			info.isMy = 0
		end

		info.isChallenged = 0

		-- 是否已挑战，1为已挑战
		if info.curProgress > 0 and info.uid == tonumber(_ED.user_info.user_id) then
			info.isChallenged = 1
		end

		local bChallenged = false
		for i = 1, #info.rewardFriends do
			if tonumber(info.rewardFriends[i]) == tonumber(_ED.user_info.user_id) then
				bChallenged = true
			end
		end

		if bChallenged == true then
			info.isChallenged = 1
		end

		local current = _ED.system_time + (os.time() - _ED.native_time)
	    local lastTime = info.endTime - current
	    info.lastTime = lastTime
	end

	local function sortFunc(a, b)
        if tonumber(a.isChallenged) < tonumber(b.isChallenged) then
            return tonumber(a.isChallenged) < tonumber(b.isChallenged)
        elseif tonumber(a.isChallenged) == tonumber(b.isChallenged) then
            if  tonumber(a.isMy) > tonumber(b.isMy) then
                return tonumber(a.isMy) > tonumber(b.isMy)
            elseif tonumber(a.isMy) == tonumber(b.isMy) then
                return tonumber(a.lastTime) > tonumber(b.lastTime)
            end
        end
    end

    table.sort(self.bossInfo, sortFunc)

end

function FileIslandBoss:init(params)
	self:initData()
	self:onInit()
	return self
end

function FileIslandBoss:onExit()
	state_machine.remove("fileIsland_boss_close")
	state_machine.remove("fileIsland_boss_Button_explore_boss_refresh")
	state_machine.remove("fileIsland_boss_Button_explore_join")
	state_machine.remove("fileIsland_boss_refresh_boss_info")

end

