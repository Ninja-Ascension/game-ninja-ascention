-- ----------------------------------------------------------------------------------------------------
-- 说明：皮卡丘大冒险活动
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
AdventureWindow = class("AdventureWindowClass", Window)

local adventure_window_open_terminal = {
    _name = "adventure_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	if nil == fwin:find("AdventureWindowClass") then
			fwin:open(AdventureWindow:new():init(params), fwin._view)
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local adventure_window_close_terminal = {
    _name = "adventure_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		fwin:close(fwin:find("AdventureWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_window_open_terminal)  
state_machine.add(adventure_window_close_terminal)  
state_machine.init()
function AdventureWindow:ctor()
    self.super:ctor()
	self.roots = {}
	self.loaded = false
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.activity.adventure.AdventureCutEvent")
	app.load("client.activity.adventure.AdventureGuessEvent")
	app.load("client.activity.adventure.AdventureRuleWindow")
	app.load("client.activity.adventure.AdventureRewardWindow")
	app.load("client.activity.adventure.AdventureSelectNum")
	app.load("client.activity.adventure.AdventureBoxOpen")
	app.load("client.activity.adventure.AdventureBoxIconCell")
	app.load("client.activity.adventure.AdventureTaskWindow")
	app.load("client.mission.missionex.WindowLock")
	
	self.reworld_sorting = {}
	self.index = 1
	self.isChangeMap = false
	self.curTurn = -1
	self.roadIds = {}
	self.isGameOver = false

	self.lastArrivePlace = {}
	-- animation2右待机 animation3右移动 animation4下待机 animation5下移动 animation6左待机 animation7左移动 animation8上待机 animation9上移动
	self.roads = {
		[1] = {pos = cc.p(44, 379), move = 7, stand = 0},
		[2] = {pos = cc.p(133, 379), move = 1, stand = 0},
		[3] = {pos = cc.p(222, 379), move = 1, stand = 0},
		[4] = {pos = cc.p(311, 379), move = 1, stand = 0},
		[5] = {pos = cc.p(400, 379), move = 1, stand = 0},
		[6] = {pos = cc.p(489, 379), move = 1, stand = 0},
		[7] = {pos = cc.p(578, 379), move = 1, stand = 0},
		[8] = {pos = cc.p(667, 379), move = 1, stand = 2},
		[9] = {pos = cc.p(667, 300), move = 3, stand = 2},
		[10] = {pos = cc.p(667, 221), move = 3, stand = 2},
		[11] = {pos = cc.p(667, 142), move = 3, stand = 2},
		[12] = {pos = cc.p(667, 63), move = 3, stand = 4},
		[13] = {pos = cc.p(578, 63), move = 5, stand = 4},
		[14] = {pos = cc.p(489, 63), move = 5, stand = 4},
		[15] = {pos = cc.p(400, 63), move = 5, stand = 4},
		[16] = {pos = cc.p(311, 63), move = 5, stand = 4},
		[17] = {pos = cc.p(222, 63), move = 5, stand = 4},
		[18] = {pos = cc.p(133, 63), move = 5, stand = 4},
		[19] = {pos = cc.p(44, 63), move = 5, stand = 6},
		[20] = {pos = cc.p(44, 142), move = 7, stand = 6},
		[21] = {pos = cc.p(44, 221), move = 7, stand = 6},
		[22] = {pos = cc.p(44, 300), move = 7, stand = 6},
	}

    -- Initialize AdventureWindow state machine.
    local function init_adventure_window_terminal()

        --投掷骰子
		local throw_monopoly_terminal = {
            _name = "throw_monopoly",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local _self = params._datas.tab
            	-- if self.isGameOver then
            	-- 	TipDlg.drawTextDailog(tipStringInfo_pikachu_tips[1])
            	-- end
            	local windowLock = fwin:find("WindowLockClass")
                if windowLock == nil then
                    fwin:open(WindowLock:new():init(), fwin._windows)
                end
            	state_machine.lock("throw_monopoly", 0, "")
				state_machine.lock("adventure_select_num_open", 0, "")
            	local isplay = false
	            local function callBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						_self:setDiceNum()
						local function changeActionCallbackOne(armatureBack )
							if armatureBack then
								local info = json.decode(_ED.active_activity[147].activity_params)
								local num = tonumber(info.destance)
								local function changeActionCallbackTwo( armatureBack1 )
									if armatureBack1 then
										armatureBack1:removeFromParent(true)
										_self:getRoads()
										_self:playerMove()
									end
								end
								armatureBack._invoke = changeActionCallbackTwo
								armatureBack:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
								csb.animationChangeToAction(armatureBack, num, num, false)
							end
						end

		                local Panel_dice_effect = ccui.Helper:seekWidgetByName(_self.roots[1], "Panel_dice_effect")
						local jsonFile = "images/ui/effice/effect_dmx_sz/effect_dmx_sz.json"
		                local atlasFile = "images/ui/effice/effect_dmx_sz/effect_dmx_sz.atlas"
                        local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "box_open", true, nil)
                        animation2.animationNameList = {"animation","animation1","animation2","animation3","animation4","animation5","animation6"}
                        sp.initArmature(animation2, false)
                        animation2._invoke = changeActionCallbackOne
                        Panel_dice_effect:addChild(animation2)
                        animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                        csb.animationChangeToAction(animation2, 0, 0, false)
                    else
                    	fwin:close(fwin:find("WindowLockClass"))
						state_machine.unlock("throw_monopoly", 0, "")
						state_machine.unlock("adventure_select_num_open", 0, "")
					end
				end
				protocol_command.monopoly_throw.param_list = "1".."\r\n".."-1"
				NetworkManager:register(protocol_command.monopoly_throw.code, nil, nil, nil, _self, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --骰子选择数字
		local select_num_update_terminal = {
            _name = "select_num_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:setDiceNum()
            	instance:getRoads()
				instance:playerMove()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --更新进度宝箱
		local adventure_box_update_terminal = {
            _name = "adventure_box_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:drawBox()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --更新骰子数量
		local adventure_dice_num_update_terminal = {
            _name = "adventure_dice_num_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:setDiceNum()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(adventure_rule_open_terminal)
		state_machine.add(throw_monopoly_terminal)
		state_machine.add(select_num_update_terminal)
		state_machine.add(adventure_box_update_terminal)
		state_machine.add(adventure_dice_num_update_terminal)
        state_machine.init()
    end
    init_adventure_window_terminal()
end

function AdventureWindow:onUpdateDraw()
    local root = self.roots[1]
	self.adventure_info = json.decode(_ED.active_activity[147].activity_params)
	self.curTurn = tonumber(self.adventure_info.turnNum) + 1

	self:drawPlayer()
	self:setDiceNum()
	self:drawMap(false)
end

function AdventureWindow:onUpdate(dt)
    
end

function AdventureWindow:onEnterTransitionFinish()

end

--设置活动倒计时
function AdventureWindow:onUpdate(dt)
	if self.__text_rare_time then
		self:updateDrawActivityTime()
	end
end

function AdventureWindow:updateDrawActivityTime()
	local root = self.roots[1]
	if root == nil or _ED.active_activity[147] == nil then
		return
	end
	local activity = self.activity  
	local surplus_time = _ED.active_activity[147].end_time/1000  - os.time() + (_ED.system_time - _ED.native_time)*2
	self.__text_rare_time:setString(getRedAlertTimeActivityFormat(surplus_time))
	surplus_time = _ED.active_activity[147].end_time/1000  - os.time() + (_ED.system_time - _ED.native_time)*2
	
	if surplus_time <= 0 then
		state_machine.excute("adventure_window_close", 0, nil)
	end
end

function AdventureWindow:setDiceNum()
	local root = self.roots[1]
	local Image_red_1 = ccui.Helper:seekWidgetByName(root, "Image_red_1")
	local Image_red_2 = ccui.Helper:seekWidgetByName(root, "Image_red_2")

	local info = json.decode(_ED.active_activity[147].activity_params)
	local freeTime = tonumber(info.freeTime)

	local diceId_local = dms.int(dms["activity_config"], 19, activity_config.param)
	local diceSpecialId_local = dms.int(dms["activity_config"], 23, activity_config.param)

	local diceId = info.costitem[1] or diceId_local
	local diceSpecialId = info.costitem[2] or diceSpecialId_local

	local diceNum = getPropAllCountByMouldId(diceId)
	local diceSpecialNum = getPropAllCountByMouldId(diceSpecialId)

	local Text_dice_n = ccui.Helper:seekWidgetByName(root, "Text_dice_n")
	local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
	local Text_special_dice_n = ccui.Helper:seekWidgetByName(root, "Text_special_dice_n")

	if freeTime > 0 then
		Text_2:setString(tipStringInfo_pikachu_tips[4])
		Text_dice_n:setString(freeTime)
	else
		Text_2:setString(tipStringInfo_pikachu_tips[3])
		Text_dice_n:setString(diceNum)
	end
	Text_special_dice_n:setString(diceSpecialNum)

	if freeTime > 0 or tonumber(diceNum) > 0 then
		Image_red_1:setVisible(true)
	else
		Image_red_1:setVisible(false)
	end

	if tonumber(diceSpecialNum) > 0 then
		Image_red_2:setVisible(true)
	else
		Image_red_2:setVisible(false)
	end
end

--地图绘制
function AdventureWindow:drawMap(changed)
	local root = self.roots[1]
	local boxReward = _ED.active_activity[147].activity_Info
	local maxTurn = tonumber(boxReward[tonumber(_ED.active_activity[147].activity_count)].activityInfo_need_day)
	self:drawBox()
	local curTurn = self.curTurn
	if self.curTurn > maxTurn then
		if changed then
			fwin:close(fwin:find("WindowLockClass"))
			TipDlg.drawTextDailog(tipStringInfo_pikachu_tips[1])
			NetworkManager:register(protocol_command.monopoly_move_end.code, nil, nil, nil, _self, callBack, false, nil)
			return
		else
			curTurn = curTurn -1
		end
	end

	if changed then
		self.adventure_info = json.decode(_ED.active_activity[147].activity_params)
		self.adventure_info.arrivePlace = {}
	end
	
	self.transferEvent = {}
	local mapInfo = zstring.split(dms.string(dms["activity_monopoly_map_mould"], curTurn, 3), ",")
	local arrivePlace = self.adventure_info.arrivePlace or {}
	for i, id in ipairs(mapInfo) do   
		local Panel_road_pic = ccui.Helper:seekWidgetByName(root, "Panel_road_pic_" .. i)
		local Panel_road_event = ccui.Helper:seekWidgetByName(root, "Panel_road_event_" .. i)
		local picIndex = dms.int(dms["activity_monopoly_task_mould"], id, 6)
		local aniIndex = dms.int(dms["activity_monopoly_task_mould"], id, 5)

		Panel_road_pic:removeBackGroundImage()
		Panel_road_event:removeAllChildren(true)
		Panel_road_pic:setBackGroundImage(string.format("images/ui/text/sm_hd/act_great_adventure/adv_road_%d.png", picIndex))
		


		if aniIndex ~= 8 and not table.containValue(arrivePlace, tonumber(i) - 1) then
			local jsonFile = string.format("images/ui/effice/effect_dmx_%d/effect_dmx_%d.json", aniIndex, aniIndex)
			local atlasFile = string.format("images/ui/effice/effect_dmx_%d/effect_dmx_%d.atlas", aniIndex, aniIndex)
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			local posX = Panel_road_event:getContentSize().width/2
			local posY = Panel_road_event:getContentSize().height/2
			animation:setPosition(cc.p(posX, 0))
			Panel_road_event:addChild(animation)
			animation:runAction(cc.MoveTo:create(0.5, cc.p(posX, posY)))
		end
		local evenType = dms.int(dms["activity_monopoly_task_mould"], id, 3)
		if evenType == 3 then
			table.insert(self.transferEvent, i)
		end
		self.roads[i].eventId = id
		self.roads[i].index = i
		self.roads[i].aniPanel = Panel_road_event
	end
	self.isChangeMap = changed

	if changed then
		self.player:runAction(cc.Sequence:create(cc.DelayTime:create(0.6), 
        cc.CallFunc:create(function ()
				self:playerMove()
	        end
    	)))
	end

	if not changed and not self.adventure_info.status then
		if tonumber(self.adventure_info.destance) == -1 then
			local curIndex = tonumber(self.adventure_info.place) + 1
			self:drawReward(self.roads[curIndex].eventId, curIndex)
		else
			self:getRoads()
			self:playerMove()
		end
	end
end

function AdventureWindow:drawBox()
	local root = self.roots[1]
	local info = json.decode(_ED.active_activity[147].activity_params)
	local chestOpenIds = info.chestIds
	local LoadingBar_reward = ccui.Helper:seekWidgetByName(root, "LoadingBar_reward")
	local completeTurn = self.curTurn - 1
	local box_img = {
		{"gq_pic_bx1.png", "gq_pic_bx1open.png"},
		{"gq_pic_bx1.png", "gq_pic_bx1open.png"},
		{"gq_pic_bx2.png", "gq_pic_bx2open.png"},
		{"gq_pic_bx2.png", "gq_pic_bx2open.png"},
		{"gq_pic_bx3.png", "gq_pic_bx3open.png"},
		{"gq_pic_bx3.png", "gq_pic_bx3open.png"},
	}

	local LoadingBar_reward = ccui.Helper:seekWidgetByName(root, "LoadingBar_reward")
	local allWidth = LoadingBar_reward:getContentSize().width
	local boxReward = _ED.active_activity[147].activity_Info
	local maxNum = tonumber(boxReward[tonumber(_ED.active_activity[147].activity_count)].activityInfo_need_day)
	LoadingBar_reward:setPercent(completeTurn/maxNum*100)

	for i, box in ipairs(boxReward) do
		local needTurn = tonumber(box.activityInfo_need_day)
		local picId = tonumber(box.activityInfo_icon)
		local Panel_reward_box = ccui.Helper:seekWidgetByName(root, "Panel_reward_box_" .. i)
		local Text_adv_circle = ccui.Helper:seekWidgetByName(root, "Text_adv_circle_" .. i)
		Panel_reward_box:removeBackGroundImage()
		Panel_reward_box:removeAllChildren(true)

		local boxPosX = allWidth*(needTurn/maxNum) - Panel_reward_box:getContentSize().width/2

		Panel_reward_box:setPositionX(boxPosX)
		Text_adv_circle:setPositionX(allWidth*(needTurn/maxNum))
		-- 0 未开不能开 1未开可以开 2开过了
		Text_adv_circle:setString(needTurn .. tipStringInfo_pikachu_tips[5])
		local state = 0
		if needTurn <= completeTurn then
			if table.containValue(chestOpenIds, i) then
				-- 开过了
				Panel_reward_box:setBackGroundImage("images/ui/reward/" .. box_img[i][2])
				state = 2
			else
				--未开可以开
				Panel_reward_box:setBackGroundImage("images/ui/reward/" .. box_img[i][1])
				local cell = AdventureBoxIconCell:new()
				cell:init(1)
				Panel_reward_box:addChild(cell)
				state = 1
			end
		else
			--未开不能开
			Panel_reward_box:setBackGroundImage("images/ui/reward/" .. box_img[i][1])
			state = 0
		end
		Panel_reward_box:setTouchEnabled(true)
		fwin:addTouchEventListener(Panel_reward_box, nil, 
		{
			terminal_name = "adventure_box_open_open", 
			terminal_state = 0, 
			id = i,
			states = state,
			isPressedActionEnabled = true
		},
		nil,0)
	end
end

function AdventureWindow:drawPlayer()
	local root = self.roots[1]
	local Panel_road_run = ccui.Helper:seekWidgetByName(root, "Panel_road_run")
	local road = self.roads[tonumber(self.adventure_info.place) + 1]
	local jsonFile = "images/ui/effice/effect_dmx_pkq/effect_dmx_pkq.json"
    local atlasFile = "images/ui/effice/effect_dmx_pkq/effect_dmx_pkq.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation2", true, nil)
    animation.animationNameList = {"animation2","animation3","animation4","animation5","animation6","animation7","animation8", "animation9"}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    animation:setPosition(road.pos)
    Panel_road_run:addChild(animation)
    self.player = animation
    csb.animationChangeToAction(animation, road.stand, road.stand, true)
end

function AdventureWindow:playerMove()
	local root = self.roots[1]
	local id = self.roadIds[self.index]
	--回到起点
	if self.curId == 1 and table.containValue(self.roadIds, 1) and not self.isChangeMap then
		self.curTurn = self.curTurn + 1
		csb.animationChangeToAction(self.player, self.roads[self.curId].stand, self.roads[self.curId].stand, true)
		self.lastArrivePlace = {}
		self:drawMap(true)
		return
	end

	self.isChangeMap = false
	if not id then
		local function callBack( response )
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				self:setDiceNum()
				self:drawReward(self.roads[self.curId].eventId, self.roads[self.curId].index)
				local evenType = dms.int(dms["activity_monopoly_task_mould"], self.roads[self.curId].eventId, 3)
				if evenType ~= 3 then
					self.roads[self.curId].aniPanel:removeAllChildren(true)
					fwin:close(fwin:find("WindowLockClass"))
					state_machine.unlock("throw_monopoly", 0, "")
					state_machine.unlock("adventure_select_num_open", 0, "")
				end
				
			end
		end
		-- 记录上次到达过的地点  到达的地点，发送结束消息就会把当前点记录
		self.lastArrivePlace = self.adventure_info.arrivePlace
		NetworkManager:register(protocol_command.monopoly_move_end.code, nil, nil, nil, _self, callBack, false, nil)
		csb.animationChangeToAction(self.player, self.roads[self.curId].stand, self.roads[self.curId].stand, true)
		self.index = 1
		return
	end

	local road = self.roads[id]
	self.curId = id
	csb.animationChangeToAction(self.player, road.move, road.move, true)
	self.player:runAction(cc.Sequence:create(cc.MoveTo:create(0.5, road.pos), 
        cc.CallFunc:create(function () 
            self.index = self.index + 1
            self:playerMove(self.index)
        end
    )))
end

function AdventureWindow:getRoads()
	self.adventure_info = json.decode(_ED.active_activity[147].activity_params)
	local firstPos = tonumber(self.adventure_info.place) + 1
	local endNum = tonumber(self.adventure_info.place) + 1 + tonumber(self.adventure_info.destance)
	
	self.roadIds = {}
	for i=firstPos+1, endNum do
		table.insert(self.roadIds, (i%22 == 0 and 22 or i%22))
	end
end

function AdventureWindow:drawReward( eventId ,index)
	local Panel_road_run = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_road_run")
	local evenType = dms.int(dms["activity_monopoly_task_mould"], eventId, 3)
	self.adventure_info = json.decode(_ED.active_activity[147].activity_params)
	--到达过的地方不触发事件
	if table.containValue(self.lastArrivePlace, tonumber(index) - 1) and evenType ~= 3 then
		return
	end

	if evenType == 1 then --获取奖励
		app.load("client.reward.DrawRareReward")
		local getRewardWnd = DrawRareReward:new()
		getRewardWnd:init(7)
		fwin:open(getRewardWnd, fwin._ui)
	elseif evenType == 2 then -- 扣除金币
		state_machine.excute("adventure_cut_event_open", 0, "")
	elseif evenType == 3 then -- 传送门
		local temp = {}
		table.merge(temp, self.transferEvent)
		table.removeForValue(temp, index)
		local nextIndex = tonumber(temp[1])
		
		local function changeActionCallbackOut(armatureBack )
			if armatureBack then
				local function changeActionCallbackIn( armatureBack1 )
					if armatureBack1 then
						self.player:setPosition(self.roads[nextIndex].pos)
						self.player:setVisible(true)
						armatureBack1:removeFromParent(true)
						fwin:close(fwin:find("WindowLockClass"))
						state_machine.unlock("throw_monopoly", 0, "")
						state_machine.unlock("adventure_select_num_open", 0, "")
					end
				end

				self.player:setVisible(false)
				csb.animationChangeToAction(self.player, self.roads[nextIndex].stand, self.roads[nextIndex].stand, true)
				armatureBack:setPosition(self.roads[nextIndex].pos)
				armatureBack._invoke = changeActionCallbackIn
				armatureBack:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
				csb.animationChangeToAction(armatureBack, 0, 0, false)
			end
		end

		local jsonFile = "images/ui/effice/effect_dmx_chuansong/effect_dmx_chuansong.json"
	    local atlasFile = "images/ui/effice/effect_dmx_chuansong/effect_dmx_chuansong.atlas"
	    local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation2.animationNameList = {"animation"}
        sp.initArmature(animation2, false)
        animation2._invoke = changeActionCallbackOut
        animation2:setPosition(self.roads[index].pos)
        Panel_road_run:addChild(animation2)
        animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(animation2, 0, 0, false)
	elseif evenType == 4 then -- 猜拳
		state_machine.excute("adventure_guess_event_open", 0, "")
	elseif evenType == 6 then -- 宝箱
		app.load("client.reward.DrawRareReward")
		local getRewardWnd = DrawRareReward:new()
		getRewardWnd:init(7)
		fwin:open(getRewardWnd, fwin._ui)
	end
end

function AdventureWindow:onInit( )
    local csbItem = csb.createNode("activity/adventure/adventure.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

	self.__text_rare_time = ccui.Helper:seekWidgetByName(root, "Text_rare_time")
	-- 关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_adventure_back"), nil, 
	{
		terminal_name = "adventure_window_close", 
		terminal_state = 0, 
		tab = self,
		isPressedActionEnabled = true
	},
	nil,0)

	-- 骰子投掷
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_dice_use"), nil, 
	{
		terminal_name = "throw_monopoly", 
		terminal_state = 0, 
		tab = self,
	},
	nil,0)

	-- 获得骰子
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_adventure_get_dice"), nil, 
	{
		terminal_name = "adventure_task_window_open", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)

	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_activity_icon_cell",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_adventure_get_dice"),
        _invoke = nil,
        _activity_type = 153,
        cells = self.roots[1],
        _interval = 0.2,})
	state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 153)

	--玩法说明
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_adventure_rule"), nil, 
	{
		terminal_name = "adventure_rule_window_open", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)

	--获得奖励
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_adventure_reward"), nil, 
	{
		terminal_name = "adventure_reward_window_open", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)

	--孤注一掷
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_special_dice_use"), nil, 
	{
		terminal_name = "adventure_select_num_open", 
		terminal_state = 0, 
	},
	nil,0)
	self:onUpdateDraw()
end

function AdventureWindow:init(params)   
	self:onInit()
    return self
end

function AdventureWindow:onExit()
end