-- ----------------------------------------------------------------------------------------------------
-- 说明：点击顶部用户信息弹出框
-- 创建时间
-- 作者：胡文轩
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
PlayerInfomation = class("PlayerInfomationClass", Window, true)
    
function PlayerInfomation:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self._passedTime = 0
	self._passedTimeTwo = 0
	self._passedTimeDispatchToken = 0
	
	self._lastTime = nil
	self.foodRecovertime = 0	--每分钟恢复的体力
	self.enduranceRecovertime = 0	--每分钟恢复的耐力
	self.dispatchTokenRecovertime = 0	--每分钟恢复的出击令
	
	--体力恢复时间
	self.userfoodRecovertime="00:00:00"
	--体力全部回满
	self.userfoodfulltoall="00:00:00"
	--耐力恢复时间
	self.userEnduranceRecovertime="00:00:00"
	--耐力全部回满
	self.userEndurancefulltoAll="00:00:00"
	--出击令全部回满
	self.userDispatchfulltoAll="00:00:00"

	
	app.load("client.cells.ship.ship_head_cell")
	
    local function init_PlayerInfomation_terminal()
        local player_infomation_main_page_button_terminal = {
            _name = "player_infomation_exit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --打开vip特权
        local playerinfomation_open_vip_privilege_terminal = {
            _name = "playerinfomation_open_vip_privilege",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local vipPrivilegeDialogWindow = VipPrivilegeDialog:new()
       			fwin:open(vipPrivilegeDialogWindow, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --充值
		local player_infomation_into_vip_recharge_terminal = {
            _name = "player_infomation_into_vip_recharge",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- state_machine.excute("shortcut_open_vip_privilege_window", 0, {1, vipLevel, attackCount})
                
               	state_machine.excute("home_recharge_activity", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(player_infomation_main_page_button_terminal)
        if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) then
        	state_machine.add(player_infomation_into_vip_recharge_terminal)
       	end
       	state_machine.add(playerinfomation_open_vip_privilege_terminal)
        state_machine.init()
    end
    
    init_PlayerInfomation_terminal()
end

function PlayerInfomation:formatTimeString(_time)
	local timeString = ""
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
	return timeString
end

function PlayerInfomation:initTime()
	self._lastTime = tonumber(_ED._system_current_energy_time)/1000
	self._passedTime = self._lastTime - _ED.system_time
	if (self._passedTime%3600) > 1 then
		self._passedTime = self._passedTime%3600
	end
	self.foodRecovertime = tonumber(_ED._next_energy_recover_time)/1000-tonumber(_ED._system_current_energy_time)/1000	--每分钟恢复的体力
end

function PlayerInfomation:initTimeTwo()
	self._lastTime = tonumber(_ED._system_current_fuel_time)/1000
	self._passedTimeTwo = self._lastTime - _ED.system_time
	if (self._passedTimeTwo%3600) > 1 then
		self._passedTimeTwo = self._passedTimeTwo%3600
	end
	self.enduranceRecovertime = tonumber(_ED._next_fuel_recover_time)/1000-tonumber(_ED._system_current_fuel_time)/1000	--每分钟恢复的体力
end

-- 回复 出击令
function PlayerInfomation:initTimeDispatchToken()
	self._lastTime = tonumber(_ED._system_current_fuel_time)/1000
	self._passedTimeTwo = self._lastTime - _ED.system_time
	if (self._passedTimeTwo%3600) > 1 then
		self._passedTimeTwo = self._passedTimeTwo%3600
	end
	self.enduranceRecovertime = tonumber(_ED._next_fuel_recover_time)/1000-tonumber(_ED._system_current_fuel_time)/1000	
end

function PlayerInfomation:updateSpecial()
	local endurance = _ED.user_info.endurance.."/".._ED.user_info.max_endurance
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_23"):setString(endurance)
	local user_food = _ED.user_info.user_food.."/".._ED.user_info.max_user_food
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_24"):setString(user_food)
	

	-- 出击令
	_ED.user_info.dispatch_token = _ED.user_info.dispatch_token or "0"
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_25"):setString(_ED.user_info.dispatch_token.."/"..self.max_dispatch_token)
end

function PlayerInfomation:onUpdateDraw()
	local root = self.roots[1]

	-- 绘制头像
	local user_info = nil
	local color = nil
	for i = 2, 7 do
		local shipId = _ED.formetion[i]
		if tonumber(shipId) > 0 then
			local isleadtype = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.captain_type)
			if tonumber(isleadtype) == 0 then
				user_info = _ED.user_ship[_ED.formetion[i]]
				color = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.ship_type)
				break
			end
		end
	end
	local head_pad = ccui.Helper:seekWidgetByName(root, "Panel_3")
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		head_pad:setBackGroundImage(string.format("images/ui/home/wanjia_cg_head_%d.png", zstring.tonumber(_ED.user_info.user_gender)))
	else
		local head_cell = ShipHeadCell:createCell()
		head_cell:init(user_info, 6)
		head_pad:addChild(head_cell)
	end
	
	-- 主角名称
	local name_label = ccui.Helper:seekWidgetByName(root, "Text_name")
	name_label:setString(_ED.user_info.user_name)
	name_label:setColor(cc.c3b(color_Type[color+1][1],color_Type[color+1][2],color_Type[color+1][3]))
	if ___is_open_leadname == true then
		name_label:setFontName("")
		name_label:setFontSize(name_label:getFontSize())
	end
	-- 战斗力
	local fight_label = ccui.Helper:seekWidgetByName(root, "Text_zdl")
	fight_label:setString(_ED.user_info.fight_capacity)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local fight_number = tonumber(_ED.user_info.fight_capacity)
		-- if fight_number > 100000000 then
		-- 	fight_label:setString(math.floor(fight_number/100000000) .. string_equiprety_name[39])
		-- else
		if fight_number > 10000 then
			fight_label:setString(math.floor(fight_number/1000) .. string_equiprety_name[40])
		else
			fight_label:setString(fight_number)
		end
	end
	-- VIP等级
	local vip_label = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_1")
	vip_label:setString(_emailTypeSystemTip[2].." ".._ED.vip_grade)
	
	-- 经验条
	local exp_pad = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
	local cur_exp = tonumber(_ED.user_info.user_experience)
	local total_exp = tonumber(_ED.user_info.user_grade_need_experience)
	local exp_percent = cur_exp / total_exp * 100
	exp_pad:setPercent(exp_percent)
	
	-- 经验条数字
	local exp_label = ccui.Helper:seekWidgetByName(root, "Text_42")
	exp_label:setString(cur_exp.."/".._ED.user_info.user_grade_need_experience)
	
	-- 元宝
	ccui.Helper:seekWidgetByName(root, "Text_5"):setString(_ED.user_info.user_gold)
	
	-- 银两
	ccui.Helper:seekWidgetByName(root, "Text_7"):setString(_ED.user_info.user_silver)
	
	-- 军团贡献
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
		if _ED.union.union_info == nil or _ED.union.union_info == {}  or  _ED.union.union_info.union_id == nil or _ED.union.union_info.union_id == "" then
		--无军团
			ccui.Helper:seekWidgetByName(root, "Text_9"):setString(_unopened_tip)
		else
			ccui.Helper:seekWidgetByName(root, "Text_9"):setString("" .. _ED.union.user_union_info.rest_contribution)
		end
	else
		ccui.Helper:seekWidgetByName(root, "Text_9"):setString(_unopened_tip)
	end
	
	-- 好友数量
	ccui.Helper:seekWidgetByName(root, "Text_11"):setString(_ED.friend_number)
	
	-- 声望
	ccui.Helper:seekWidgetByName(root, "Text_13"):setString(_ED.user_info.user_honour)

	-- 战功
	ccui.Helper:seekWidgetByName(root, "Text_15"):setString(_ED.user_info.exploit)
	
	-- 将魂
	ccui.Helper:seekWidgetByName(root, "Text_17"):setString(_ED.user_info.jade)
	
	-- 威名
	ccui.Helper:seekWidgetByName(root, "Text_19"):setString(_ED.user_info.all_glories)
	
	-- 出击令
	ccui.Helper:seekWidgetByName(root, "Text_25"):setString(_ED.user_info.dispatch_token)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		if verifySupportLanguage(_lua_release_language_en) == true then
			ccui.Helper:seekWidgetByName(root, "Text_dengji"):setString(_string_piece_info[6].._ED.user_info.user_grade)
		else
			ccui.Helper:seekWidgetByName(root, "Text_dengji"):setString(_ED.user_info.user_grade.._string_piece_info[6])
		end
	end
	
	self:updateSpecial()
end

function PlayerInfomation:onEnterTransitionFinish()
	local csbUserInfo = csb.createNode("player/role_information.csb")
	self:addChild(csbUserInfo)
	local action = csb.createTimeline("player/role_information.csb")
    csbUserInfo:runAction(action)
    action:gotoFrameAndPlay(0, action:getDuration(), false)
    -- action:setFrameEventCallFunc(function (frame)
        -- if nil == frame then
            -- return
        -- end

        -- local str = frame:getEvent()
        -- if str == "exit" then
		
        -- end
    -- end)
	
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)
	
	
	local dispatchStr =dms.string(dms["pirates_config"], 1, pirates_config.param)
	self.max_dispatch_token = zstring.split(dispatchStr,",")[6]
	
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) then
		local ButVip = ccui.Helper:seekWidgetByName(root, "Button_vip")
		if ButVip ~= nil then
			-- 跳转到VIP权限界面
			fwin:addTouchEventListener(ButVip, nil, 
			{
				terminal_name = "player_infomation_into_vip_recharge",     
				current_button_name = "Button_vip",       
				terminal_state = 0, 
				isPressedActionEnabled = true
			}, nil, 0)
		end
	end
	local exie_button = ccui.Helper:seekWidgetByName(ccui.Helper:seekWidgetByName(root, "Panel_4"), "Button_1")
	local userinformation_exit_button = fwin:addTouchEventListener(exie_button, nil, 
	{
		terminal_name = "player_infomation_exit", 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local to_vip_privilege_window = ccui.Helper:seekWidgetByName(root,"Button_chakanvip")
		fwin:addTouchEventListener(to_vip_privilege_window, nil, 
		{
			terminal_name = "playerinfomation_open_vip_privilege", 
			isPressedActionEnabled = true
		}, 
		nil, 0)	
	end
	self:onUpdateDraw()
	
	
	local function responseKeepAlive(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil then
		
				self.foodRecovertime = tonumber(_ED._next_energy_recover_time)/1000-tonumber(_ED._system_current_energy_time)/1000	--每分钟恢复的体力
				self.enduranceRecovertime = tonumber(_ED._next_fuel_recover_time)/1000-tonumber(_ED._system_current_fuel_time)/1000	--每分钟恢复的体力
				self.dispatchTokenRecovertime = tonumber(_ED._next_dispatch_token_recover_time)/1000-tonumber(_ED._system_current_dispatch_token_time)/1000	--每分钟恢复的体力
				
				--清除累计计时 ，防止误差
				self._passedTime = 0 
				self._passedTimeTwo = 0
				self._passedTimeDispatchToken = 0
				
				self:onUpdateDraw()
			
			end
		end
	end
	
	local function requestKeepAlive()
		NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, self, responseKeepAlive, false, nil)
	end

	local function requestKeepAliveTwo()
		NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, self, responseKeepAlive, false, nil)
	end
	
	local function requestKeepAliveDispatchToken()
		NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, self, responseKeepAlive, false, nil)
	end
	
	local function foodRemainTime(s)
		--> print("self._passedTime",self._passedTime)
		if tonumber(_ED.user_info.user_food) < tonumber(_ED.user_info.max_user_food) then
			local remain = self.foodRecovertime - self._passedTime
			local remainAll = (tonumber(_ED._next_energy_recover_time)/1000-tonumber(_ED._last_energy_recover_time)/1000)*(tonumber(_ED.user_info.max_user_food)-tonumber(_ED.user_info.user_food)-1)+ self.foodRecovertime - self._passedTime
			local timeUp = tonumber(remain) <= 0 and true or false
			if timeUp == true then
				requestKeepAlive()
				timeUp = false
				self._passedTime = 0
				self.foodRecovertime = (tonumber(_ED._next_energy_recover_time)/1000-tonumber(_ED._last_energy_recover_time)/1000)
				remain = self.foodRecovertime - self._passedTime
				ccui.Helper:seekWidgetByName(root, "Text_36"):setString(self:formatTimeString(remain))
				ccui.Helper:seekWidgetByName(root, "Text_37"):setString(self:formatTimeString(remainAll))
			else
				ccui.Helper:seekWidgetByName(root, "Text_36"):setString(self:formatTimeString(remain))
				ccui.Helper:seekWidgetByName(root, "Text_37"):setString(self:formatTimeString(remainAll))
			end
		else
			ccui.Helper:seekWidgetByName(root, "Text_36"):setString(self.userfoodRecovertime)
			ccui.Helper:seekWidgetByName(root, "Text_37"):setString(self.userfoodfulltoall)
		end
	end
	
	local function enduranceRemainTime(s)
		if tonumber(_ED.user_info.endurance) < tonumber(_ED.user_info.max_endurance) then
			local remain = self.enduranceRecovertime - self._passedTimeTwo
			local remainAll = (tonumber(_ED._next_fuel_recover_time)/1000-tonumber(_ED._last_fuel_recover_time)/1000)*(tonumber(_ED.user_info.max_endurance)-tonumber(_ED.user_info.endurance)-1)+ self.enduranceRecovertime - self._passedTimeTwo
			local timeUp = tonumber(remain) <= 0 and true or false
			if timeUp == true then
				requestKeepAliveTwo()
				timeUp = false
				self._passedTimeTwo = 0
				self.enduranceRecovertime = (tonumber(_ED._next_fuel_recover_time)/1000-tonumber(_ED._last_fuel_recover_time)/1000)
				remain = self.enduranceRecovertime - self._passedTimeTwo
				ccui.Helper:seekWidgetByName(root, "Text_34"):setString(self:formatTimeString(remain))
				ccui.Helper:seekWidgetByName(root, "Text_35"):setString(self:formatTimeString(remainAll))
			else
				ccui.Helper:seekWidgetByName(root, "Text_34"):setString(self:formatTimeString(remain))
				ccui.Helper:seekWidgetByName(root, "Text_35"):setString(self:formatTimeString(remainAll))
			end
		else
			ccui.Helper:seekWidgetByName(root, "Text_34"):setString(self.userfoodRecovertime)
			ccui.Helper:seekWidgetByName(root, "Text_35"):setString(self.userfoodfulltoall)
		end
	end
	
	local function dispatchTokenRemainTime(s)
		if tonumber(_ED.user_info.dispatch_token) < tonumber(self.max_dispatch_token) then
			local remain = self.dispatchTokenRecovertime - self._passedTimeDispatchToken
			local remainAll = (tonumber(_ED._next_dispatch_token_recover_time)/1000 - tonumber(_ED._last_dispatch_token_recover_time)/1000)*(tonumber(self.max_dispatch_token)-tonumber(_ED.user_info.dispatch_token)-1)+ self.dispatchTokenRecovertime - self._passedTimeDispatchToken
			local timeUp = tonumber(remain) <= 0 and true or false
			if timeUp == true then
				requestKeepAliveDispatchToken()
				timeUp = false
				self._passedTimeDispatchToken = 0
				self.dispatchTokenRecovertime = (tonumber(_ED._next_dispatch_token_recover_time)/1000-tonumber(_ED._last_dispatch_token_recover_time)/1000)
				remain = self.dispatchTokenRecovertime - self._passedTimeDispatchToken
				ccui.Helper:seekWidgetByName(root, "Text_38"):setString(self:formatTimeString(remain))
				ccui.Helper:seekWidgetByName(root, "Text_39"):setString(self:formatTimeString(remainAll))
			else
				ccui.Helper:seekWidgetByName(root, "Text_38"):setString(self:formatTimeString(remain))
				ccui.Helper:seekWidgetByName(root, "Text_39"):setString(self:formatTimeString(remainAll))
			end
		else
			ccui.Helper:seekWidgetByName(root, "Text_38"):setString(self.userDispatchfulltoAll)
			ccui.Helper:seekWidgetByName(root, "Text_39"):setString(self.userDispatchfulltoAll)
		end
	end
	
	local function step(dt)
		self._passedTime = self._passedTime + dt
		foodRemainTime(false)
		self._passedTimeTwo = self._passedTimeTwo + dt
		enduranceRemainTime(false)
		self._passedTimeDispatchToken = self._passedTimeDispatchToken + dt
		dispatchTokenRemainTime(false)
	end
	step(0)
	self:scheduler("user_remain_time", step, 1.0)
	
	
	
	if self._lastTime == nil then
		self:initTime()
		self:initTimeTwo()
		self:initTimeDispatchToken()
	else
		requestKeepAlive()
		self._passedTime = 0
		self._passedTimeTwo = 0
		self._passedTimeDispatchToken = 0
	end
end

function PlayerInfomation:onExit()
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) then
   		state_machine.remove("player_infomation_into_vip_recharge")
   	end
	state_machine.remove("player_infomation_exit")
	state_machine.remove("playerinfomation_open_vip_privilege")
	self.onUpdateDraw = nil
end