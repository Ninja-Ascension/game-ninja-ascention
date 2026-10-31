-- ----------------------------------------------------------------------------------------------------
-- 说明：活动 / 迎财神
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityWelcomeMammon = class("ActivityWelcomeMammonClass", Window)
    
function ActivityWelcomeMammon:ctor()
    self.super:ctor()
	app.load("client.activity.LookUpAccumulate")
	self.roots = {}
	self.loaded = false
	self.normalPanel = nil -- 待机
	self.ArmatureNode_1 = nil -- 采集动画
	self._Text_ycs_3 = nil
	self._Button_3 = nil
	
    -- Initialize activity_welcome_mammon state machine.
    local function init_activity_welcome_mammon_terminal()
		local welcome_mammon_button_terminal = {
            _name = "welcome_mammon_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function responseGetServerListCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert
						or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
							if response.node == nil or response.node.roots == nil then
								return
							end
						end
						response.node:onUpdateDraw()
						if __lua_project_id == __lua_project_warship_girl_b 
							or __lua_project_id == __lua_project_digimon_adventure 
							or __lua_project_id == __lua_project_naruto 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_yugioh 
							then 
							response.node:playCollectAction()
						else
							response.node:DrawArmature()
							response.node:DrawArmatureOne()
						end
					end
				end
				NetworkManager:register(protocol_command.greet_fortune.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--空箱子点击
		local welcome_mammon_six_count_button_one_terminal = {
            _name = "welcome_mammon_six_count_button_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if tonumber(_ED.welcome_mammon.welcome_time_day_yet) >= 3 then
					TipDlg.drawTextDailog(_string_piece_info[181])
				else
					TipDlg.drawTextDailog(_string_piece_info[256])
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--有钱了~~
		local welcome_mammon_six_count_button_terminal = {
            _name = "welcome_mammon_six_count_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local _getCount = params._datas.getCount
				local _jsilverCount = params._datas.mJsilverCount
				
				-- if fwin:find("LookUpAccumulateClass") == nil then
					local LookUp = LookUpAccumulate:new()
					LookUp:init(_getCount,_jsilverCount)
					fwin:open(LookUp, fwin._ui)
				-- end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local activity_welcome_mammon_recharge_state_button_terminal = {
            _name = "activity_welcome_mammon_recharge_state_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					instance:rechargeState()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(welcome_mammon_button_terminal)
		state_machine.add(welcome_mammon_six_count_button_one_terminal)
		state_machine.add(welcome_mammon_six_count_button_terminal)
		state_machine.add(activity_welcome_mammon_recharge_state_button_terminal)
		
        state_machine.init()
    end
    
    -- call func init ActivityWelcomeMammon state machine.
    init_activity_welcome_mammon_terminal()
end

function ActivityWelcomeMammon:formatTimeString(_time)	--系统时间转换
	local timeString = ""
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
	return timeString
end

function ActivityWelcomeMammon:DarwTimes()
	local root = self.roots[1]
	if _ED.welcome_mammon.cooling_times ~= nil and _ED.welcome_mammon.cooling_times ~= "" then
		local times = os.time()- tonumber(_ED.welcome_mammon.os_time)
		local remainTime = 0
		if self._Text_ycs_3 == nil then
			return
		end
		if times > _ED.welcome_mammon.cooling_times/1000 then 
			self._Text_ycs_3:setVisible(false)
			self._Text_ycs_3:setString(self:formatTimeString(remainTime))
			
			self._Button_3:setBright(true)
			self._Button_3:setTouchEnabled(true)
		else 
			remainTime =_ED.welcome_mammon.cooling_times/1000-times	--剩余刷新的时间
			self._Text_ycs_3:setVisible(true)
			self._Text_ycs_3:setString(self:formatTimeString(remainTime))
			
			self._Button_3:setBright(false)
			self._Button_3:setTouchEnabled(false)
		end
		if tonumber(_ED.welcome_mammon.welcome_time_day_sum) == tonumber(_ED.welcome_mammon.welcome_time_day_yet) then
			self._Button_3:setBright(false)
			self._Button_3:setTouchEnabled(false)
			self._Text_ycs_3:setVisible(false)
		end
	end
end


	
function ActivityWelcomeMammon:DrawArmatureOne()
	local root = self.roots[1]
	local Panel_10 = ccui.Helper:seekWidgetByName(root, "Panel_10")
	Panel_10:setVisible(true)
	if __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then
	else
		local ArmatureNode_1 = Panel_10:getChildByName("ArmatureNode_1")
		local animation = ArmatureNode_1:getAnimation()
		animation:playWithIndex(0, 0, 0)
	end
end
function ActivityWelcomeMammon:DrawArmature()
	local root = self.roots[1]
	local Panel_10 = ccui.Helper:seekWidgetByName(root, "Panel_10")
	local Panel_9 = ccui.Helper:seekWidgetByName(root, "Panel_9")
	if tonumber(_ED.welcome_mammon.welcome_time_yet) >= 1 then
		Panel_9:setVisible(true)
		
		if __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			then
		else
			local ArmatureNode_2 = Panel_9:getChildByName("ArmatureNode_2")
			local animation = ArmatureNode_2:getAnimation()
			animation:playWithIndex(0, 0, -1)
		end
	else
		Panel_9:setVisible(false)
	end
end
function ActivityWelcomeMammon:rechargeState()
	local root = self.roots[1]
	local welcomeInfo = ccui.Helper:seekWidgetByName(root, "Text_ycs_4")
	local welcomeButtonOne = ccui.Helper:seekWidgetByName(root, "Button_caiji_1")	
	local welcomeButtonTwo = ccui.Helper:seekWidgetByName(root, "Button_caiji_2")
	local ButtonWelcome = ccui.Helper:seekWidgetByName(root, "Button_3")
	welcomeInfo:setString(_string_piece_info[286])
	welcomeButtonOne:setVisible(true)
	welcomeButtonTwo:setVisible(false)
	ButtonWelcome:setBright(false)
	ButtonWelcome:setTouchEnabled(false)
end

--播放采集动画
function ActivityWelcomeMammon:playCollectAction()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local caijiPanel = ccui.Helper:seekWidgetByName(root, "Panel_10")
	if __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then
		caijiPanel:removeAllChildren(true)
		local jsonFile = "images/ui/effice/caiji_1/caiji_1.json"
		local atlasFile = "images/ui/effice/caiji_1/caiji_1.atlas"
		self.ArmatureNode_1 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		self.ArmatureNode_1.animationNameList = {"animation"}
		sp.initArmature(self.ArmatureNode_1, false)
		caijiPanel:addChild(self.ArmatureNode_1)
	end
    self.ArmatureNode_1._invoke = function(armatureBack)
		if armatureBack:isVisible() == true then
			armatureBack:setVisible(false)
			self.normalPanel:setVisible(true)
		end
	end
	self.ArmatureNode_1:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	csb.animationChangeToAction(self.ArmatureNode_1, 0, 0, false)
	self.ArmatureNode_1:setVisible(true)
	
	caijiPanel:setVisible(true)
	self.normalPanel:setVisible(false)
end

function ActivityWelcomeMammon:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local welcomeCount = ccui.Helper:seekWidgetByName(root, "Text_ycs_2")	--今日次数
	local welcomeInfo = ccui.Helper:seekWidgetByName(root, "Text_ycs_4")	
	local ButtonWelcome = ccui.Helper:seekWidgetByName(root, "Button_3")
	local welcomeButtonOne = ccui.Helper:seekWidgetByName(root, "Button_caiji_1")	
	local welcomeButtonTwo = ccui.Helper:seekWidgetByName(root, "Button_caiji_2")
	-- _ED.welcome_mammon.welcome_time_sum = npos(list)					--迎财神总次数
	-- _ED.welcome_mammon.welcome_time_yet = npos(list)					--已迎财神次数
	-- _ED.welcome_mammon.welcome_time_day_sum = npos(list)				--每日迎财神总次数
	-- _ED.welcome_mammon.welcome_time_day_yet = npos(list)				--每日已迎财神次数
	self._Text_ycs_3 = ccui.Helper:seekWidgetByName(root, "Text_ycs_3")
	self._Button_3 = ccui.Helper:seekWidgetByName(root, "Button_3")

	local Panel_10 = ccui.Helper:seekWidgetByName(root, "Panel_10")
	Panel_10:setVisible(false)

	ButtonWelcome:setBright(false)
	ButtonWelcome:setTouchEnabled(false)
	if tonumber(_ED.welcome_mammon.welcome_time_yet) <= 0 then
		welcomeButtonOne:setVisible(true)
		welcomeButtonTwo:setVisible(false)
	else 
		welcomeButtonTwo:setVisible(true)
		welcomeButtonOne:setVisible(false)
	end
	local welcomeTime = tonumber(_ED.welcome_mammon.welcome_time_sum) - tonumber(_ED.welcome_mammon.welcome_time_yet)
	local jsilverCount = _ED.welcome_mammon.return_jsilver_count
	if welcomeTime > 6 then
		welcomeInfo:setString(_string_piece_info[285])
		welcomeButtonOne:setVisible(true)
		welcomeButtonTwo:setVisible(false)
	elseif welcomeTime == 6 and tonumber(_ED.welcome_mammon.welcome_time_day_yet) == 3  then
		welcomeInfo:setString(_string_piece_info[286])
	else
		welcomeInfo:setString(_string_piece_info[196]..jsilverCount.._string_piece_info[197]..welcomeTime.._string_piece_info[198])--累计的次数
	end
	
	local everyDayTimes = _ED.welcome_mammon.welcome_time_day_sum
	local everyDayTimesYet = _ED.welcome_mammon.welcome_time_day_yet
	welcomeCount:setString(_string_piece_info[195]..everyDayTimesYet.."/"..everyDayTimes.._string_piece_info[173])--今日次数
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
	{
		terminal_name = "welcome_mammon_button", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_caiji_2"), nil, 
	{
		terminal_name = "welcome_mammon_six_count_button", 
		terminal_state = 0, 
		getCount = welcomeTime,
		mJsilverCount = jsilverCount,
		isPressedActionEnabled = true
	},
	nil,0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_caiji_1"), nil, 
	{
		terminal_name = "welcome_mammon_six_count_button_one", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)
end


function ActivityWelcomeMammon:onUpdate(dt)
	self:DarwTimes()
end


function ActivityWelcomeMammon:initDraw()
	if self.loaded == false then
		return
	end
    local csbActivityWelcomeMammon = csb.createNode("activity/wonderful/welcome_god_Wealth.csb")
	local root = csbActivityWelcomeMammon:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbActivityWelcomeMammon)
    self.normalPanel = nil
	if __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		then 
		if self.normalPanel == nil then 
			--只能执行一次
			self.normalPanel = ccui.Helper:seekWidgetByName(root, "Panel_100001")		
			local caijiPanel = ccui.Helper:seekWidgetByName(root, "Panel_10")

			if __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
				then
				self.normalPanel:removeAllChildren(true)
				local jsonFile = "images/ui/effice/caiji/caiji.json"
				local atlasFile = "images/ui/effice/caiji/caiji.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	    		self.normalPanel:addChild(animation)

	    		local Panel_9 = ccui.Helper:seekWidgetByName(root, "Panel_9")
	    		Panel_9:removeAllChildren(true)
				local jsonFile = "images/ui/effice/caiji_2/caiji_2.json"
				local atlasFile = "images/ui/effice/caiji_2/caiji_2.atlas"
				local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	    		Panel_9:addChild(animation)
			else
				self.ArmatureNode_1 = caijiPanel:getChildByName("ArmatureNode_1")
				draw.initArmature(self.ArmatureNode_1, nil, -1, 0, 1)
		    	csb.animationChangeToAction(self.ArmatureNode_1, 0, 0, false)
		    	self.ArmatureNode_1:setVisible(false)
		    end
    		caijiPanel:setVisible(true)
		end
		self.normalPanel = ccui.Helper:seekWidgetByName(root, "Panel_100001")		
	end
	self:onUpdateDraw()
	if __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		then 
	else
		self:DrawArmature()
	end
end

function ActivityWelcomeMammon:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
 	self:initDraw()
 	self:registerOnNoteUpdate(self, 1)
end

function ActivityWelcomeMammon:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	self:unregisterOnNoteUpdate(self)
end

function ActivityWelcomeMammon:onEnterTransitionFinish()
 --    local csbActivityWelcomeMammon = csb.createNode("activity/wonderful/welcome_god_Wealth.csb")
	-- local root = csbActivityWelcomeMammon:getChildByName("root")
 --    table.insert(self.roots, root)
 --    self:addChild(csbActivityWelcomeMammon)
	
	-- self:onUpdateDraw()
	
	-- self:DrawArmature()
	
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
end

function ActivityWelcomeMammon:onExit()
	state_machine.remove("welcome_mammon_six_count_button")
	state_machine.remove("activity_welcome_mammon_recharge_state_button")
end

function ActivityWelcomeMammon:init()

end


function ActivityWelcomeMammon:createCell()
	local cell = ActivityWelcomeMammon:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end