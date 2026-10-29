----------------------------------------------------------------------------------------------------
-- 说明：领地主界面
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：

-- 镇压
-------------------------------------------------------------------------------------------------------
MineManager = class("MineManagerClass", Window)
    
function MineManager:ctor()
    self.super:ctor()
	self.roots = {}
    app.load("client.campaign.mine.MineManagerFriend")
    app.load("client.campaign.mine.MineManagerManorFight")
    app.load("client.campaign.mine.MineManagerNoPerson")
    app.load("client.campaign.mine.MineManagerPatrol")
    app.load("client.campaign.mine.MineManagerFriendList")
    app.load("client.campaign.mine.MineManagerAddPerson")
    app.load("client.campaign.mine.MineManagerChooseStatus")
	self._userId = nil
	self.timeQueue = {}
	self.but = {}
	
    -- Initialize MineManager page state machine.
    local function init_mine_manager_terminal()
		
		--更新数据
		local mine_manager_update_activity_terminal = {
            _name = "mine_manager_update_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:sendManorInit()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--返回
		local mine_manager_back_activity_terminal = {
            _name = "mine_manager_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					state_machine.excute("menu_show_campaign",0,4)
				else
					fwin:open(Campaign:new(), fwin._view)
				end
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--回家
		local mine_manager_goto_home_terminal = {
            _name = "mine_manager_goto_home",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
				local view = MineManager:new()
				fwin:open(view, fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--好友列表
		local mine_manager_go_friend_mine_terminal = {
            _name = "mine_manager_go_friend_mine",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:open(MineManagerFriend:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--点击城池
		local mine_manager_into_mine_terminal = {
            _name = "mine_manager_into_mine",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:gotoBypassflow(params._datas._cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(mine_manager_update_activity_terminal)
		state_machine.add(mine_manager_goto_home_terminal)
		state_machine.add(mine_manager_back_activity_terminal)
		state_machine.add(mine_manager_go_friend_mine_terminal)
		state_machine.add(mine_manager_into_mine_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_mine_manager_terminal()
end

--决定去向
function MineManager:gotoBypassflow(index)

	local city = self.manor_info.city
	
	for i, v in pairs(city) do
		
		local manor_index_id = tonumber(v.manor_index_id)
		local _id = self._userId
		if manor_index_id == index then
			if tonumber(v.manor_status) == 0 then				--未开启状态
				
				if self:isMe() then
				
					local manorData = dms["manor_mould"]
					for i = 1 , table.getn(manorData) do
						local byOpenId = dms.int(manorData, i, manor_mould.by_open_manor)
						if byOpenId == manor_index_id then
							local name = dms.string(manorData, i, manor_mould.manor_name)
							TipDlg.drawTextDailog(game_mine_tip_str[1] .. name .. game_mine_tip_str[2])
							break
						end
					end
				
				else
					TipDlg.drawTextDailog(tipStringInfo_mine_info[25])
				
				end
				
			elseif tonumber(v.manor_status) == 1 then			--可点击挑战
				if self:isMe() then
					local cell = MineManagerManorFight:createCell()
					cell:init(manor_index_id)
					fwin:open(cell, fwin._view)
				else
					TipDlg.drawTextDailog(tipStringInfo_mine_info[25])
				
				end
			elseif tonumber(v.manor_status) == 2 then			--空闲状态
				if self:isMe() then
					local cell = MineManagerNoPerson:createCell()
					cell:init(manor_index_id)
					fwin:open(cell, fwin._view)
				else
					TipDlg.drawTextDailog(tipStringInfo_mine_info[25])
				end
			elseif tonumber(v.manor_status) == 3 then			--巡逻中
				local function responseManorUserInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local cell = MineManagerPatrol:createCell()
						cell:init(manor_index_id,_id, 0, self.friend_info)
						fwin:open(cell, fwin._view)
					end
				end
				
				-- 自己传0
				local str = self._userId or "0"
				
				protocol_command.manor_user_init.param_list = manor_index_id.."\r\n"..str

				NetworkManager:register(protocol_command.manor_user_init.code, nil, nil, nil, instance, responseManorUserInitCallback,false)
			elseif tonumber(v.manor_status) == 4 then			--可领奖
				local function responseManorUserInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local cell = MineManagerPatrol:createCell()
						cell:init(manor_index_id, _id, 3, self.friend_info)
						fwin:open(cell, fwin._view)
					end
				end
				local str = self._userId or "0"
				
				protocol_command.manor_user_init.param_list = manor_index_id.."\r\n"..str
				NetworkManager:register(protocol_command.manor_user_init.code, nil, nil, nil, instance, responseManorUserInitCallback,false)
				
				
			elseif tonumber(v.manor_status) == 5 then			--暴动中

				local function responseManorUserInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local cell = MineManagerPatrol:createCell()
						cell:init(manor_index_id, _id, 1, self.friend_info)
						fwin:open(cell, fwin._view)
					end
				end
				
				local str = self._userId or "0"
				
				protocol_command.manor_user_init.param_list = manor_index_id.."\r\n"..str
				
				NetworkManager:register(protocol_command.manor_user_init.code, nil, nil, nil, instance, responseManorUserInitCallback,false)

			end
		end
	end
end

-- 切换状态时,重置为默认显示
function MineManager:setDefault(v)
	local indexID = v.manor_index_id
	local lockStates = self.lockStates[indexID]
	lockStates:setVisible(false)
	local fightStates = self.fightStates[indexID]
	fightStates:setVisible(false)
	local goOnStates = self.goOnStates[indexID]
	goOnStates:setVisible(false)
	local myButtonTimes = self.myButtonTimes[indexID]
	myButtonTimes:setVisible(false)
	myButtonTimes:setString("")
	local haveStates = self.haveStates[indexID]
	haveStates:setVisible(false)
	local baoDongStates = self.baoDongStates[indexID]
	baoDongStates:setVisible(false)
	local myButton = self.myButton[indexID]
	myButton:setColor(cc.c3b(255,255,255))
end

--(0锁定)
function MineManager:setLock(v)
	local indexID = v.manor_index_id
	local myButton = self.myButton[indexID]
	myButton:setColor(cc.c3b(50,50,50))
	local lockStates = self.lockStates[indexID]
	lockStates:setVisible(true)
end
--(1开启)
function MineManager:setOpen(v)
	local indexID = v.manor_index_id
	local fightStates = self.fightStates[indexID]
	fightStates:setVisible(true)
end
--(2可巡逻)
function MineManager:setUnused(v)
	local indexID = v.manor_index_id
	local goOnStates = self.goOnStates[indexID]
	goOnStates:setVisible(true)
end
--(3巡逻中)
function MineManager:setPatrol(v)

	local indexID = v.manor_index_id
	
	local myButtonTimes = self.myButtonTimes[indexID]
	myButtonTimes:setVisible(true)
	myButtonTimes:setString("00:00:00")
	self.timeQueue = self.timeQueue or {}
	local item = {
		text = myButtonTimes,
		num = v.surplus_times,
		index = indexID,
		v = v,
	}
	table.insert(self.timeQueue, item)
end
--(4可领奖)
function MineManager:setPatrolComplete(v)
	local indexID = v.manor_index_id
	local haveStates = self.haveStates[indexID]
	haveStates:setVisible(true)

	local action = csb.createTimeline("campaign/MineManager/attack_territory.csb")
    self.csbMineManager:runAction(action)
    action:play("Panel_lingqu_dh", true)
end
--(5暴动)
function MineManager:setRiot(v)
	local indexID = v.manor_index_id
	local baoDongStates = self.baoDongStates[indexID]
	baoDongStates:setVisible(true)
	
	local action = csb.createTimeline("campaign/MineManager/attack_territory.csb")
    self.csbMineManager:runAction(action)
    action:play("Panel_baodong_dh", true)
end


function MineManager:onUpdateDraw()
	self.startTime = os.time()
	-- 进入的处理 
	-- 当前是玩家自己
	-- 当前是别人家的
	local manor_info = nil

	if self:isMe() then
		manor_info = _ED.manor_info.player
		-- 隐藏好友姓名框
		self.panel_friend:setVisible(false)
	else
		manor_info = _ED.manor_info.friend
		-- 显示好友姓名框
		self.panel_friend:setVisible(true)
		-- 设置好友名
		local name = manor_info.user_name
		self.text_friend :setString(name)
	end
	
	self.manor_info = manor_info
	-- local test = {5,4,3,2,1,0}
	local city = manor_info.city
	local manor_status = nil
	for i, v in pairs(city) do
		 -- v.manor_status = test[i]
		 -- v.surplus_times = 430 - i*24
		 -- v.manor_status = 2
		 
		if i > #self.myButton then
			break
		end
		
		self:setDefault(v)
		
		manor_status = v.manor_status
		--(0锁定 1开启 2可巡逻 3巡逻中 4 可领奖 5暴动)
		if manor_status == 0 then
			self:setLock(v)
		elseif manor_status == 1 then
			if self:isMe() then
				self:setOpen(v)
			end
		elseif manor_status == 2 then
			if self:isMe() then
				self:setUnused(v)
			end
		elseif manor_status == 3 then
			self:setPatrol(v)
		elseif manor_status == 4 then
			self:setPatrolComplete(v)
		elseif manor_status == 5 then
			self:setRiot(v)
		end
	end	

	-- 显示剩余镇压次数
	self.text_zycs:setString(getMineManagerSurplusSuppressCount())
end


function MineManager:changeTime()

	local nums = table.getn(self.timeQueue)
	for i = 1, nums do
		local current_interval = math.floor(self.timeQueue[i].num/1000) - (os.time() - self.startTime)
		if current_interval > 0 then
			local timeString = ""
			timeString = timeString .. string.format("%02d",math.floor(tonumber(current_interval)/3600)) .. ":"
			timeString = timeString .. string.format("%02d",math.floor((tonumber(current_interval)%3600)/60)) .. ":"
			timeString = timeString .. string.format("%02d",math.floor(tonumber(current_interval)%60))
			self.timeQueue[i].text:setString(timeString)
		else
			self.timeQueue[i].text:setString("")
			-- 倒计时完毕,显示领取
			self:setPatrolComplete(self.timeQueue[i].v)
			
		end
	end
	
end

function MineManager:onUpdate(dt)
	self:changeTime()
end

function MineManager:onEnterTransitionFinish()
	local userinfo = EquipPlayerInfomation:new()
	fwin:open(userinfo,fwin._view)
	self.userinfo = userinfo
	
    local csbMineManager = csb.createNode("campaign/MineManager/attack_territory.csb")
    self:addChild(csbMineManager)
	self.csbMineManager = csbMineManager
	
   	local root = csbMineManager:getChildByName("root")
	table.insert(self.roots, root)
	
	
	-- Panel_139 好友时状况
	self.panel_friend = ccui.Helper:seekWidgetByName(root, "Panel_139")
	self.text_friend = ccui.Helper:seekWidgetByName(root, "Text_198")
	self.button_home = ccui.Helper:seekWidgetByName(root, "Button_hdld")
	
	-- Text_zycs 当前剩余的镇压次数
	self.text_zycs = ccui.Helper:seekWidgetByName(root, "Text_zycs")
	
	-- 好友名称
	--self.text_zycs = ccui.Helper:seekWidgetByName(root, "Text_zycs")
	
	self.myButton = {									--对应button
		ccui.Helper:seekWidgetByName(root, "Button_01"),	--桃源村
		ccui.Helper:seekWidgetByName(root, "Button_02"),	--宛城
		ccui.Helper:seekWidgetByName(root, "Button_03"),	--洛阳
		ccui.Helper:seekWidgetByName(root, "Button_04"),	--荆州
		ccui.Helper:seekWidgetByName(root, "Button_05"),	--五丈原
		ccui.Helper:seekWidgetByName(root, "Button_06"),	--赤壁
	}
	self.myButtonTimes = {								--对应button时间
		ccui.Helper:seekWidgetByName(root, "Text_time_1"),	--桃源村
		ccui.Helper:seekWidgetByName(root, "Text_time_2"),	--宛城
		ccui.Helper:seekWidgetByName(root, "Text_time_3"),	--洛阳
		ccui.Helper:seekWidgetByName(root, "Text_time_4"),	--荆州
		ccui.Helper:seekWidgetByName(root, "Text_time_5"),	--五丈原
		ccui.Helper:seekWidgetByName(root, "Text_time_6"),	--赤壁
	}
	self.lockStates = {									--对应button锁定状态
		ccui.Helper:seekWidgetByName(root, "Image_lock_1"),	--桃源村
		ccui.Helper:seekWidgetByName(root, "Image_lock_2"),	--宛城
		ccui.Helper:seekWidgetByName(root, "Image_lock_3"),	--洛阳
		ccui.Helper:seekWidgetByName(root, "Image_lock_4"),	--荆州
		ccui.Helper:seekWidgetByName(root, "Image_lock_5"),	--五丈原
		ccui.Helper:seekWidgetByName(root, "Image_lock_6"),	--赤壁
	}
	self.fightStates = {									--对应button战斗状态
		ccui.Helper:seekWidgetByName(root, "Panel_gd_1"),	--桃源村
		ccui.Helper:seekWidgetByName(root, "Panel_gd_2"),	--宛城
		ccui.Helper:seekWidgetByName(root, "Panel_gd_3"),	--洛阳
		ccui.Helper:seekWidgetByName(root, "Panel_gd_4"),	--荆州
		ccui.Helper:seekWidgetByName(root, "Panel_gd_5"),	--五丈原
		ccui.Helper:seekWidgetByName(root, "Panel_gd_6"),	--赤壁
	}
	self.fightStatesTwo = {									--对应button战斗状态动画
		ccui.Helper:seekWidgetByName(root, "ArmatureNode_1"),	--桃源村
		ccui.Helper:seekWidgetByName(root, "ArmatureNode_2"),	--宛城
		ccui.Helper:seekWidgetByName(root, "ArmatureNode_3"),	--洛阳
		ccui.Helper:seekWidgetByName(root, "ArmatureNode_5_14"),--荆州
		ccui.Helper:seekWidgetByName(root, "ArmatureNode_4"),	--五丈原
		ccui.Helper:seekWidgetByName(root, "ArmatureNode_5"),	--赤壁
	}
	self.goOnStates = {									--对应button添加状态 + 武将
		ccui.Helper:seekWidgetByName(root, "Panel_gd_tj_1"),	--桃源村
		ccui.Helper:seekWidgetByName(root, "Panel_gd_tj_2"),	--宛城
		ccui.Helper:seekWidgetByName(root, "Panel_gd_tj_3"),	--洛阳
		ccui.Helper:seekWidgetByName(root, "Panel_gd_tj_4"),	--荆州
		ccui.Helper:seekWidgetByName(root, "Panel_gd_tj_5"),	--五丈原
		ccui.Helper:seekWidgetByName(root, "Panel_gd_tj_6"),	--赤壁
	}
	self.goOnStatesTwo = {									--对应button添加状态动画
		ccui.Helper:seekWidgetByName(root, "ArmatureNode_6"),	--桃源村
		ccui.Helper:seekWidgetByName(root, "ArmatureNode_7"),	--宛城
		ccui.Helper:seekWidgetByName(root, "ArmatureNode_8"),	--洛阳
		ccui.Helper:seekWidgetByName(root, "ArmatureNode_10_12"),--荆州
		ccui.Helper:seekWidgetByName(root, "ArmatureNode_9"),	--五丈原
		ccui.Helper:seekWidgetByName(root, "ArmatureNode_10"),	--赤壁
	}
	self.haveStates = {									--对应button领取状态
		ccui.Helper:seekWidgetByName(root, "Panel_lingqu_1"),	--桃源村
		ccui.Helper:seekWidgetByName(root, "Panel_lingqu_2"),	--宛城
		ccui.Helper:seekWidgetByName(root, "Panel_lingqu_3"),	--洛阳
		ccui.Helper:seekWidgetByName(root, "Panel_lingqu_4"),	--荆州
		ccui.Helper:seekWidgetByName(root, "Panel_lingqu_5"),	--五丈原
		ccui.Helper:seekWidgetByName(root, "Panel_lingqu_6"),	--赤壁
	}
	self.baoDongStates = {									--对应button暴动状态
		ccui.Helper:seekWidgetByName(root, "Panel_baodong_1"),	--桃源村
		ccui.Helper:seekWidgetByName(root, "Panel_baodong_2"),	--宛城
		ccui.Helper:seekWidgetByName(root, "Panel_baodong_3"),	--洛阳
		ccui.Helper:seekWidgetByName(root, "Panel_baodong_4"),	--荆州
		ccui.Helper:seekWidgetByName(root, "Panel_baodong_5"),	--五丈原
		ccui.Helper:seekWidgetByName(root, "Panel_baodong_6"),	--赤壁
	}
	
	self:sendManorInit()
	
	--返回
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ldga_01"), nil, 
	{
		terminal_name = "mine_manager_back_activity", 
		terminal_state = 0, 
		_cell = 1,
		isPressedActionEnabled = true
	}, nil, 2)
	
	--拜访好友
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bfhy"), nil, 
	{
		terminal_name = "mine_manager_go_friend_mine", 
		terminal_state = 0, 
		_cell = 1,
		isPressedActionEnabled = true
	}, nil, 0)
	
	--对应的六个领地的按钮响应
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_01"), nil, 
	{
		terminal_name = "mine_manager_into_mine", 
		terminal_state = 0, 
		_cell = 1,
		isPressedActionEnabled = true
	}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_02"), nil, 
	{
		terminal_name = "mine_manager_into_mine", 
		terminal_state = 0, 
		_cell = 2,
		isPressedActionEnabled = true
	}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_03"), nil, 
	{
		terminal_name = "mine_manager_into_mine", 
		terminal_state = 0, 
		_cell = 3,
		isPressedActionEnabled = true
	}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_04"), nil, 
	{
		terminal_name = "mine_manager_into_mine", 
		terminal_state = 0, 
		_cell = 4,
		isPressedActionEnabled = true
	}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_05"), nil, 
	{
		terminal_name = "mine_manager_into_mine", 
		terminal_state = 0, 
		_cell = 5,
		isPressedActionEnabled = true
	}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_06"), nil, 
	{
		terminal_name = "mine_manager_into_mine", 
		terminal_state = 0, 
		_cell = 6,
		isPressedActionEnabled = true
	}, nil, 0)
	
	
	fwin:addTouchEventListener(self.button_home, nil, 
	{
		terminal_name = "mine_manager_goto_home", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, nil, 0)
	
	state_machine.excute("menu_button_hide_highlighted_all", 0, nil)
end

function MineManager:sendManorInit()
	local function responseMineManagerInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil then
				response.node:onUpdateDraw()
			end
		end
	end
	protocol_command.manor_init.param_list = self._userId or _ED.user_info.user_id
	NetworkManager:register(protocol_command.manor_init.code, nil, nil, nil, self, responseMineManagerInitCallback, false, nil)
end


function MineManager:isMe()
	if nil == self._isMeSelf then
		if nil ~= self._userId  and  tonumber(_ED.user_info.user_id) ~= tonumber(self._userId) then
			self._isMeSelf =  false
		else
			self._isMeSelf =  true
		end
	end
	return self._isMeSelf
end

function MineManager:init(user_id, friend_info)
	-- 当 user_id 为 nil 则是玩家自己
	self._userId = user_id
	self.friend_info = friend_info
end

function MineManager:close()
	fwin:close(self.userinfo)
end

function MineManager:onExit()
	state_machine.remove("mine_manager_update_activity")
	state_machine.remove("mine_manager_goto_home")
	state_machine.remove("mine_manager_back_activity")
	state_machine.remove("mine_manager_go_friend_mine")
	state_machine.remove("mine_manager_into_mine")
end
