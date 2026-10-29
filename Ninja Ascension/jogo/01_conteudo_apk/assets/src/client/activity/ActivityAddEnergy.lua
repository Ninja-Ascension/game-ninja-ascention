-- ----------------------------------------------------------------------------------------------------
-- 说明：活动 / 吃烧鸡，领体力
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityAddEnergy = class("ActivityAddEnergyClass", Window)
    
function ActivityAddEnergy:ctor()
    self.super:ctor()
	app.load("client.activity.ActivityAddEnergyAccident")
	self.roots = {}
	self.loaded = false
	self.distance = 0
	self._Text_add_strength_time_now = nil
    -- Initialize ActivityAddEnergy state machine.
    local function init_activity_add_energy_terminal()
		--恢复体力
		local reply_physical_button_terminal = {
            _name = "reply_physical_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local _replyPhysical = params._datas.replyPhysical
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					if tonumber(_ED._add_enger) <= 0 then
						instance.roots[2]:setVisible(false)
						instance.roots[1]:onUpdateDraw()
					end
				else
					local function responseGetServerListCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							
							local function responseInitPhysicalCallback(response)
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									if tonumber(_ED._add_enger) <= 0 then
										response.node[2]:setVisible(false)
										response.node[1]:onUpdateDraw()
									end
								end
							end
							NetworkManager:register(protocol_command.dinner_init.code, nil, nil, nil, response.node, responseInitPhysicalCallback, false, nil)
						end
					end
					
					NetworkManager:register(protocol_command.dinner_time.code, nil, nil, nil, {instance,_replyPhysical}, responseGetServerListCallback, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --补领
        local activity_add_energy_replenishment_terminal = {
            _name = "activity_add_energy_replenishment",
            _init = function (terminal) 
                app.load("client.l_digital.activity.wonderful.SmActivityBuyEnergy")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local page = params._datas.page
				state_machine.excute("sm_activity_buy_energy_window_open", 0, page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --前往
        local activity_add_energy_go_to_task_window_terminal = {
            _name = "activity_add_energy_go_to_task_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("activity_window_hide", 0, 0)
				app.load("client.activity.dailytask.DailyTask")
				state_machine.excute("daily_task_window_open", 0, {back_terminal_name = "activity_add_energy_show_page"})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新
        local activity_add_energy_update_draw_terminal = {
            _name = "activity_add_energy_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if getSmActivityEatManualShow() == false then
            		state_machine.excute("activity_window_remove_activity_info", 0, 1001)
            	else
					instance:onUpdateDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_add_energy_show_page_terminal = {
            _name = "activity_add_energy_show_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("activity_window_show", 0, "")
				state_machine.excute("activity_window_open_page_activity",0,{"addEnergy"})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(reply_physical_button_terminal)
		state_machine.add(activity_add_energy_replenishment_terminal)
		state_machine.add(activity_add_energy_go_to_task_window_terminal)
		state_machine.add(activity_add_energy_update_draw_terminal)
		state_machine.add(activity_add_energy_show_page_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityAddEnergy state machine.
    init_activity_add_energy_terminal()
end

function ActivityAddEnergy:onUpdateDraw()
	local root = self.roots[1]
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local energyData = zstring.split(dms.string(dms["activity_config"], 1, activity_config.param), "|")
		local add_enger_info = zstring.split(_ED._add_enger_info,"|")
		self.distance = 0

		local current = os.time() + _ED.time_add_or_sub
		local temp = os.date("*t", getBaseGTM8Time(zstring.tonumber(current)))
		local m_hour    = tonumber(string.format("%02d", temp.hour))
		local m_min     = tonumber(string.format("%02d", temp.min))
		local m_sec     = tonumber(string.format("%02d", temp.sec))
		local newTimes = m_hour*3600+m_min*60+m_sec
		local refreshTime = 5 * 3600									-- 截止第二天五点刷新前都可以领取体力
		local oneDaySeconds = 24 * 3600									-- 一天的秒数
		newTimes = newTimes <= refreshTime and (newTimes + oneDaySeconds) or newTimes
		
		local createUserData = os.date("*t", getBaseGTM8Time(zstring.tonumber(_ED.user_info.create_time)))
		local createUserTimes = zstring.tonumber(string.format("%02d", createUserData.hour))*3600 + tonumber(string.format("%02d", createUserData.min))*60 + tonumber(string.format("%02d", createUserData.sec))

		for i=1, 4 do
			local Text_add_strength_time = ccui.Helper:seekWidgetByName(root, "Text_add_strength_time_"..i)
			--补领
			local Button_add_strength_rec = ccui.Helper:seekWidgetByName(root, "Button_add_strength_rec_"..i)
			--前往
			local Button_add_strength_go = ccui.Helper:seekWidgetByName(root, "Button_add_strength_go_"..i)
			--已领
			local Image_add_strength_yi = ccui.Helper:seekWidgetByName(root, "Image_add_strength_yi_"..i)
			--未到时间
			local Image_add_strength_not = ccui.Helper:seekWidgetByName(root, "Image_add_strength_not_"..i)
			Button_add_strength_rec:setVisible(false)
			Button_add_strength_go:setVisible(false)
			Image_add_strength_yi:setVisible(false)
			Image_add_strength_not:setVisible(false)
			local energy_info = zstring.split(energyData[i], ",")
			local energy_infok1 = zstring.split(energy_info[1], ":")
			local energy_infok2 = zstring.split(energy_info[2], ":")
			if Text_add_strength_time ~= nil then
				Text_add_strength_time:setString(string.format(activity_add_energy_tips[i],(energy_infok1[1]..":"..energy_infok1[2].."-"..energy_infok2[1]..":"..energy_infok2[2])))
			end
			local add_enger_data = zstring.split(add_enger_info[i],",")
			local earlyMorning1 = tonumber(zstring.split(energy_info[1], ":")[1])*3600
			local earlyMorning2 = tonumber(zstring.split(energy_info[2], ":")[1])*3600
			earlyMorning1 = earlyMorning1 <= refreshTime and (earlyMorning1 + oneDaySeconds) or earlyMorning1
			earlyMorning2 = earlyMorning2 <= refreshTime and (earlyMorning2 + oneDaySeconds) or earlyMorning2
			if createUserData.year ~= temp.year
                or createUserData.month ~= temp.month
                or createUserData.day ~= temp.day
                or createUserTimes <= earlyMorning2 then
				if newTimes >= earlyMorning1 and newTimes <= earlyMorning2 then
					if tonumber(add_enger_data[1]) == 1 then
						Image_add_strength_yi:setVisible(true)
					else
						Button_add_strength_go:setVisible(true)
					end
				elseif newTimes > earlyMorning2 then
					if tonumber(add_enger_data[1]) == 1 then
						Image_add_strength_yi:setVisible(true)
					else
						Button_add_strength_rec:setVisible(true)
					end
				elseif newTimes < earlyMorning1 then
					Image_add_strength_not:setVisible(true)
				end
			end
		end
		
		-- 一直显示补领倒计时
		self.distance = refreshTime + oneDaySeconds - newTimes
		if self.distance ~= 0 then
			ccui.Helper:seekWidgetByName(root, "Text_add_strength_time_now"):setString(self:formatTimeString(self.distance))
		else
			ccui.Helper:seekWidgetByName(root, "Text_add_strength_time_now"):setString("")
		end
	else
		app.load("client.reward.DrawGainReward")
		
		local getFood = 0
		
		local isGetGold = false
		local getGold = 0

		local rewardList = getSceneReward(6)
		
		getFood = tonumber(getRewardValueWithType(rewardList, 12))
		getGold = tonumber(getRewardValueWithType(rewardList, 2))

		TipDlg.drawTextDailog(_string_piece_info[212]..getFood)
		if getGold > 0 then
			--> print("====================================2=========2=============2==",getGold)
			local AddEnergyAccident = ActivityAddEnergyAccident:new() 
			AddEnergyAccident:init(getGold)
	        fwin:open(AddEnergyAccident, fwin._windows)
			AddEnergyAccident:lazy()
		end
		-- 状态(0 午餐 1晚餐 -1(不能吃))
		local replyPhysicalText = ccui.Helper:seekWidgetByName(root, "Text_16")
		local Image_10 = ccui.Helper:seekWidgetByName(root, "Image_10")
		local Text_120 = ccui.Helper:seekWidgetByName(root, "Text_120")	--	午餐
		local Text_130 = ccui.Helper:seekWidgetByName(root, "Text_130")	--	晚餐
		Image_10:setVisible(true)
		Text_120:setVisible(false)
		Text_130:setVisible(false)
		if tonumber(_ED._add_enger_time) > 0 then
			replyPhysicalText:setString(_string_piece_info[202])
		else
			replyPhysicalText:setString(_string_piece_info[203])
		end
	end
end

function ActivityAddEnergy:formatTimeString(_time)	--系统时间转换
	local timeString = ""
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
	return timeString
end

function ActivityAddEnergy:onUpdate(dt)
	if self.distance ~= 0 then
		self.distance = self.distance - dt
		self._Text_add_strength_time_now:setString(self:formatTimeString(self.distance))
		if self.distance == 0 then
			self:onUpdateDraw()
		end
	end
end

function ActivityAddEnergy:initDraw()
	
	if nil == ActivityAddEnergy.onlyExample then
		return
	end
	
    local csbActivityAddEnergy = csb.createNode("activity/wonderful/add_strength.csb")
    local root = csbActivityAddEnergy:getChildByName("root")
    table.insert(ActivityAddEnergy.onlyExample.roots, root)
	ActivityAddEnergy.onlyExample:addChild(csbActivityAddEnergy)
	local replyPhysicalText = ccui.Helper:seekWidgetByName(root, "Text_16")
	local replyPhysicalBtn = ccui.Helper:seekWidgetByName(root, "Button_11")
	local Image_10 = ccui.Helper:seekWidgetByName(root, "Image_10")
	local Text_120 = ccui.Helper:seekWidgetByName(root, "Text_120")	--	午餐
	local Text_130 = ccui.Helper:seekWidgetByName(root, "Text_130")	--	晚餐
	self._Text_add_strength_time_now = ccui.Helper:seekWidgetByName(root, "Text_add_strength_time_now")
	--回体力初始化
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self:onUpdateDraw()
	else
		Image_10:setVisible(true)
		replyPhysicalBtn:setVisible(false)
		local function responseGetServerListCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if nil == ActivityAddEnergy.onlyExample then
				
					return
				end
				if response.node ~= nil and response.node.roots[1] ~= nil then
					response.node:afterResponse()
				end
				-- if tonumber(_ED._add_enger) > 0 then
				-- 	replyPhysicalBtn:setVisible(true)
					
				-- 	Image_10:setVisible(false)
				-- 	replyPhysicalText:setString(_string_piece_info[201])
				-- 	if tonumber(_ED._add_enger_time) > 0 then
				-- 		Text_130:setVisible(true)
				-- 	else
				-- 		Text_120:setVisible(true)
				-- 	end
				-- else
				-- -- 状态(0 午餐 1晚餐 -1(不能吃))
				-- 	Text_130:setVisible(false)
				-- 	Text_120:setVisible(false)
				-- 	if tonumber(_ED._add_enger_time) > 0 then
				-- 		replyPhysicalText:setString(_string_piece_info[203])
				-- 	else
				-- 		replyPhysicalText:setString(_string_piece_info[203])
				-- 	end
				-- end
			end
		end
		NetworkManager:register(protocol_command.dinner_init.code, nil, nil, nil, self, responseGetServerListCallback, false, nil)

		if __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			then
			local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
			Panel_effect:removeAllChildren(true)
			local jsonFile = "images/ui/effice/effect_eat/effect_eat.json"
			local atlasFile = "images/ui/effice/effect_eat/effect_eat.atlas"
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		    Panel_effect:addChild(animation)
		end

		fwin:addTouchEventListener(replyPhysicalBtn, nil, 
				{
					terminal_name = "reply_physical_button", 
					terminal_state = 0, 
					replyPhysical = replyPhysicalBtn, 
					isPressedActionEnabled = true
				},
				nil,0)
	end
end
function ActivityAddEnergy:afterResponse()
	local root = self.roots[1]
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		local replyPhysicalText = ccui.Helper:seekWidgetByName(root, "Text_16")
		local replyPhysicalBtn = ccui.Helper:seekWidgetByName(root, "Button_11")
		local Image_10 = ccui.Helper:seekWidgetByName(root, "Image_10")
		local Text_120 = ccui.Helper:seekWidgetByName(root, "Text_120")	--	午餐
		local Text_130 = ccui.Helper:seekWidgetByName(root, "Text_130")	--	晚餐
		if tonumber(_ED._add_enger) > 0 then
			replyPhysicalBtn:setVisible(true)
			
			Image_10:setVisible(false)
			replyPhysicalText:setString(_string_piece_info[201])
			if tonumber(_ED._add_enger_time) > 0 then
				Text_130:setVisible(true)
			else
				Text_120:setVisible(true)
			end
		else
		-- 状态(0 午餐 1晚餐 -1(不能吃))
			Text_130:setVisible(false)
			Text_120:setVisible(false)
			if tonumber(_ED._add_enger_time) > 0 then
				replyPhysicalText:setString(_string_piece_info[203])
			else
				replyPhysicalText:setString(_string_piece_info[203])
			end
		end
	end
end
function ActivityAddEnergy:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	ActivityAddEnergy.onlyExample = self
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
	self:initDraw()

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		for i=1, 4 do
			--补领
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_add_strength_rec_"..i), nil, 
			{
				terminal_name = "activity_add_energy_replenishment", 
				terminal_state = 0, 
				page = i,
				isPressedActionEnabled = true
			},
			nil,0)
			--前往
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_add_strength_go_"..i), nil, 
			{
				terminal_name = "activity_add_energy_go_to_task_window", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)
		end
	end
	self:registerOnNoteUpdate(self, 1)
end

function ActivityAddEnergy:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	ActivityAddEnergy.onlyExample = nil
	self:unregisterOnNoteUpdate(self)
end

function ActivityAddEnergy:onEnterTransitionFinish()
 --    local csbActivityAddEnergy = csb.createNode("activity/wonderful/add_strength.csb")
 --    local root = csbActivityAddEnergy:getChildByName("root")
 --    table.insert(self.roots, root)
	-- self:addChild(csbActivityAddEnergy)
	-- local replyPhysicalText = ccui.Helper:seekWidgetByName(root, "Text_16")
	-- local replyPhysicalBtn = ccui.Helper:seekWidgetByName(root, "Button_11")
	-- local Image_10 = ccui.Helper:seekWidgetByName(root, "Image_10")
	-- local Text_120 = ccui.Helper:seekWidgetByName(root, "Text_120")	--	午餐
	-- local Text_130 = ccui.Helper:seekWidgetByName(root, "Text_130")	--	晚餐
	
	-- replyPhysicalBtn:setVisible(false)
	
	-- Image_10:setVisible(true)
	-- --回体力初始化
	-- local function responseGetServerListCallback(response)
	-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	-- 		if tonumber(_ED._add_enger) > 0 then
	-- 			replyPhysicalBtn:setVisible(true)
				
	-- 			Image_10:setVisible(false)
	-- 			replyPhysicalText:setString(_string_piece_info[201])
	-- 			if tonumber(_ED._add_enger_time) > 0 then
	-- 				Text_130:setVisible(true)
	-- 			else
	-- 				Text_120:setVisible(true)
	-- 			end
	-- 		else
	-- 		-- 状态(0 午餐 1晚餐 -1(不能吃))
	-- 			Text_130:setVisible(false)
	-- 			Text_120:setVisible(false)
	-- 			if tonumber(_ED._add_enger_time) > 0 then
	-- 				replyPhysicalText:setString(_string_piece_info[202])
	-- 			else
	-- 				replyPhysicalText:setString(_string_piece_info[203])
	-- 			end
	-- 		end
	-- 	end
	-- end
	-- NetworkManager:register(protocol_command.dinner_init.code, nil, nil, nil, nil, responseGetServerListCallback, false, nil)
	
	
	-- fwin:addTouchEventListener(replyPhysicalBtn, nil, 
	-- 		{
	-- 			terminal_name = "reply_physical_button", 
	-- 			terminal_state = 0, 
	-- 			replyPhysical = replyPhysicalBtn, 
	-- 			isPressedActionEnabled = true
	-- 		},
	-- 		nil,0)
	
	-- ActivityAddEnergy.onlyExample = self
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.initDraw, self, false)
end

function ActivityAddEnergy:onExit()
	state_machine.remove("reply_physical_button")
	state_machine.remove("activity_add_energy_go_to_task_window")
	state_machine.remove("activity_add_energy_show_page")
	ActivityAddEnergy.onlyExample = nil
end

function ActivityAddEnergy:init()
end


function ActivityAddEnergy:createCell()
	local cell = ActivityAddEnergy:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end
