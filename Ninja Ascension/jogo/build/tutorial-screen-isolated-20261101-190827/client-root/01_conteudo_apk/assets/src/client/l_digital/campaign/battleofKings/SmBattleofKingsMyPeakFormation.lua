-----------------------------
-- 王者之战查看我的巅峰阵型
-----------------------------
SmBattleofKingsMyPeakFormation = class("SmBattleofKingsMyPeakFormationClass", Window)

--打开界面
local sm_battleof_kings_my_peak_formation_open_terminal = {
	_name = "sm_battleof_kings_my_peak_formation_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmBattleofKingsMyPeakFormationClass") == nil then
			fwin:open(SmBattleofKingsMyPeakFormation:new():init(), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_battleof_kings_my_peak_formation_close_terminal = {
	_name = "sm_battleof_kings_my_peak_formation_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmBattleofKingsMyPeakFormationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_battleof_kings_my_peak_formation_open_terminal)
state_machine.add(sm_battleof_kings_my_peak_formation_close_terminal)
state_machine.init()

function SmBattleofKingsMyPeakFormation:ctor()
	self.super:ctor()
	self.roots = {}
	self._battle_number = 0
	app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsViewGeneralFormation")
    local function init_sm_battleof_kings_my_peak_formation_terminal()
        local sm_battleof_kings_my_peak_formation_save_terminal = {
            _name = "sm_battleof_kings_my_peak_formation_save",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if nil ~= response.node and nil ~= response.node.roots then
                        	local function requesrDefendCheck(response)
		                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		                            state_machine.excute("sm_battleof_kings_my_peak_formation_close", 0, 0)
                        			state_machine.excute("sm_battleof_kings_prepare_for_the_game_update_battle_draw", 0, "")
		                    	end
                        	end
                        	protocol_command.the_kings_battle_manager.param_list = "5"
		                    NetworkManager:register(protocol_command.the_kings_battle_manager.code, nil, nil, nil, nil, requesrDefendCheck, false, nil)
                        end
                    end
                end
                protocol_command.the_kings_battle_manager.param_list = "1".."\r\n"..instance._user_formation
                NetworkManager:register(protocol_command.the_kings_battle_manager.code, nil, nil, nil, instance, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_battleof_kings_my_peak_formation_save_terminal)
        state_machine.init()
    end
    init_sm_battleof_kings_my_peak_formation_terminal()
end

function SmBattleofKingsMyPeakFormation:getTimeDesByInterval( timeInt )
	local result = {}
    local oh     = math.floor(timeInt/3600)
    local om     = math.floor((timeInt - oh*3600)/60)
    local os     = math.floor(timeInt - oh*3600 - om*60)
    local hour = oh
    local day  = 0
    if(oh>=24) then
        day  = math.floor(hour/24)
        hour = oh - day*24
    end
    if hour > 0 then
        if hour < 10 then
            hour = "0"..hour
        end
    else
        hour = "00"
    end
    if om > 0 then
        if om < 10 then
            om = "0"..om
        end
    else
        om = "00"
    end
    if os > 0 then
        if os < 10 then
            os = "0"..os
        end
    else
        os = "00"
    end
    return hour..":"..om..":"..os
end

function SmBattleofKingsMyPeakFormation:onUpdateDraw()
    local root = self.roots[1]
    local heroCardsTable = {}
    local padCardsTable = {}
    self.start_pos = nil
    local began_pos = nil
    local requestchangeFormation = nil
	local elementName = {
		"Panel_digimon_icon_1",
		"Panel_digimon_icon_2",
		"Panel_digimon_icon_3",
		"Panel_digimon_icon_4",
		"Panel_digimon_icon_5",
		"Panel_digimon_icon_6",
		"Panel_digimon_icon_7",
		"Panel_digimon_icon_8",
		"Panel_digimon_icon_9",
		"Panel_digimon_icon_10",
	}

	local function executeMoveHeroOverFunc()
		lockMoveHero = false
		isChangeFormation = false
		began_pos = nil
		self.start_pos = nil
	end

	local battle_count = 0
	for i,v in pairs(_ED.kings_battle.peak_list) do
		if tonumber(v.id) == tonumber(_ED.user_info.user_id) then
			local result = zstring.split(v.result ,"|")
			battle_count = #result - 10
			break
		end
	end

	self._battle_number = (battle_count - 1) * 3

	local function formationTouchListener(sender, eventType)
		if isChangeFormation == true or lockMoveHero == true then
			return
		end

		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()

		if self.start_pos == nil then
			self.start_pos = cc.p(__spoint.x, __spoint.y)
		else
			if self.start_pos.x ~= __spoint.x and self.start_pos.y ~= __spoint.y then
				-- return
				eventType = ccui.TouchEventType.ended
			end
		end
		if eventType == ccui.TouchEventType.began then
			for pos, heroCard in pairs(heroCardsTable) do
				local bPosition = heroCard:convertToNodeSpace(cc.p(__spoint.x, __spoint.y))
				if ( bPosition.x >0 and bPosition.x <  heroCard:getContentSize().width and bPosition.y > 0 and bPosition.y < heroCard:getContentSize().height ) then
					began_pos = pos
					began_heroSprite = heroCard
					local tempX, tempY  = heroCard:getPosition()
					began_hero_position = cc.p(tempX, tempY)
					began_hero_ZOrder = heroCard:getLocalZOrder()
					local parent_node = began_heroSprite:getParent()
					beganHero = parent_node 
					parent_node:reorderChild(began_heroSprite, 100)
					parent_node:getParent():reorderChild(parent_node, 100)
				end
			end
		elseif eventType == ccui.TouchEventType.moved then
			if began_pos == nil then
				return
			end
			if nil ~= began_heroSprite then
				began_heroSprite:setPosition(cc.p( (__mpoint.x - __spoint.x) / app.scaleFactor / began_heroSprite._scale + began_hero_position.x , (__mpoint.y - __spoint.y) / app.scaleFactor / began_heroSprite._scale + began_hero_position.y))
			end
		elseif eventType == ccui.TouchEventType.canceled then
			self.start_pos = nil
			if began_pos == nil then
				return
			end
			if nil ~= began_heroSprite then
				began_heroSprite:setPosition(cc.p(began_hero_position.x , began_hero_position.y))
			end
		elseif eventType == ccui.TouchEventType.ended
			or eventType == ccui.TouchEventType.canceled then
			self.start_pos = nil
			if began_pos == nil then
				return
			end
			local isChanged = false

			local temp = cc.p(began_heroSprite:getContentSize().width/2, began_heroSprite:getContentSize().height/2)
			local e_position = fwin:convertToWorldSpaceAR(began_heroSprite, cc.p(temp.x,temp.y)) -- began_heroSprite:convertToWorldSpaceAR(cc.p(temp.x,temp.y))
			if eventType == ccui.TouchEventType.ended then
				for pos, card_hero in pairs(padCardsTable) do
					if pos > self._battle_number then
						if card_hero:getTag() ~= began_heroSprite:getTag() then
							local bPosition = card_hero:convertToNodeSpaceAR(e_position)
							if ( bPosition.x >0 and bPosition.x <  card_hero:getContentSize().width and bPosition.y > 0 and bPosition.y < card_hero:getContentSize().height ) then
								isChanged = true
								changedHero = card_hero
								end_pos =  pos
								change_heroSprite = heroCardsTable[end_pos]
								break
							end
						end
					end
				end
			end
			if (isChanged == false) or isChangeFormation == true then
				began_hero_position = cc.p(0, 0)
				lockMoveHero = true
				began_heroSprite:runAction(cc.Sequence:create(
					cc.MoveTo:create(0.3, began_hero_position),
					cc.DelayTime:create(0.2),
					cc.CallFunc:create(executeMoveHeroOverFunc)
				))
				local parent_node = began_heroSprite:getParent() 
				parent_node:reorderChild(began_heroSprite, began_hero_ZOrder)
				
			else
				requestChangeFormation()
			end
		end
	end

	--移动
	local function moveFormationHero(heroSprite, changedPad)
		if heroSprite == nil then
			return
		end
		lockMoveHero = true
		local xx, yy = heroSprite:getPosition()
		local e_position = fwin:convertToWorldSpace(heroSprite, cc.p(0, 0)) -- heroSprite:convertToWorldSpace(cc.p(0, 0))
		e_position = changedPad:convertToNodeSpace(cc.p(e_position.x, e_position.y))
		heroSprite:setPosition(cc.p(e_position.x, e_position.y))
		
		heroSprite:retain()
		heroSprite:removeFromParent(false)
		changedPad:addChild(heroSprite)
		heroSprite:onInit()
		heroSprite:setTouchEnabled(true)
		heroSprite:release()
		heroSprite:setTag(changedPad:getTag())
		
		began_hero_position = cc.p(0, 0)
		-- heroSprite:runAction(cc.MoveTo:create(0.3, began_hero_position))
		heroSprite:runAction(cc.Sequence:create(
			cc.MoveTo:create(0.3, began_hero_position),
			cc.DelayTime:create(0.2),
			cc.CallFunc:create(executeMoveHeroOverFunc)
		))
	end

	requestChangeFormation = function ()
		heroCardsTable[began_pos] = change_heroSprite
		heroCardsTable[end_pos] = began_heroSprite

		-- responseChangeFormation({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
		moveFormationHero(began_heroSprite, changedHero)
		-- if tonumber(endShipId) > 0 then
			moveFormationHero(change_heroSprite, beganHero)
		-- end	
		-- state_machine.excute("home_hero_refresh_draw", 0, 0)
		-- isChangeFormation = true

		self._user_formation = ""
		local list_object_change = {}
		for i, v in pairs(heroCardsTable) do
			if #self._user_formation > 0 then
				self._user_formation = self._user_formation .. "!"
			end
			self._user_formation = self._user_formation .. v._formation_info
			local datas = zstring.split(v._formation_info,":")
			--战力
	        local BitmapFontLabel_fighting = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_fighting_"..i)
	       	BitmapFontLabel_fighting:setString(_ED.user_ship[datas[7]].hero_fight)
	       	--速度
	       	-- local Text_sudu = ccui.Helper:seekWidgetByName(root,"Text_sudu_"..i)
	       	-- Text_sudu:setString(datas[8])
	       	table.insert(list_object_change, datas[8])
		end

		for i=1,3 do
	    	local Text_sudu = ccui.Helper:seekWidgetByName(root,"Text_sudu_"..i)
	    	local speed = 0
	    	if i==1 then
	    		speed = tonumber(list_object_change[1]) + tonumber(list_object_change[2]) + tonumber(list_object_change[3])
			elseif i == 2 then
				speed = tonumber(list_object_change[4]) + tonumber(list_object_change[5]) + tonumber(list_object_change[6])
			elseif i == 3 then
				speed = tonumber(list_object_change[7]) + tonumber(list_object_change[8]) + tonumber(list_object_change[9])
			end
			Text_sudu:setString(speed)
	    end
	end

    -- 创建阵型信息
    self._user_formation = _ED.kings_battle.peak_list[_ED.user_info.user_id].formation
    local formation_info = zstring.split(_ED.kings_battle.kings_battle_user_formation, "!")
    self.list_object = {}
    for i=1, #formation_info do
    	local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root,"Panel_digimon_icon_"..i)
    	Panel_digimon_icon:removeAllChildren(true)
    	padCardsTable[i] = Panel_digimon_icon
    	if formation_info ~= nil then
            if formation_info[i] ~= nil then
            	local datas = zstring.split(formation_info[i],":")
                local cell = ShipIconCell:createCell()
		    	cell:init(_ED.user_ship[datas[7]],12)
		    	heroCardsTable[i] = cell
		    	cell:setTag(Panel_digimon_icon:getTag())
		    	local size = Panel_digimon_icon:getContentSize()
				cell:setContentSize(size)
		        Panel_digimon_icon:addChild(cell)
		    	cell:setTouchEnabled(true)
		    	if i > self._battle_number then
			        cell:addTouchEventListener(formationTouchListener)
			    end
		        cell._scale = Panel_digimon_icon:getScale()
		        cell._formation_info = formation_info[i]

		        --战力
		        local BitmapFontLabel_fighting = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_fighting_"..i)
		       	BitmapFontLabel_fighting:setString(_ED.user_ship[datas[7]].hero_fight)
		       	table.insert(self.list_object, datas[8])
            end
        end
    end
    --速度
   	for i=1,3 do
    	local Text_sudu = ccui.Helper:seekWidgetByName(root,"Text_sudu_"..i)
    	local speed = 0
    	if i==1 then
    		speed = tonumber(self.list_object[1]) + tonumber(self.list_object[2]) + tonumber(self.list_object[3])
		elseif i == 2 then
			speed = tonumber(self.list_object[4]) + tonumber(self.list_object[5]) + tonumber(self.list_object[6])
		elseif i == 3 then
			speed = tonumber(self.list_object[7]) + tonumber(self.list_object[8]) + tonumber(self.list_object[9])
		end
		Text_sudu:setString(speed)
    end

    for i=1, 3 do
    	ccui.Helper:seekWidgetByName(root,"Panel_result_"..i):removeBackGroundImage()
    end

    local battle_result = zstring.split(_ED.kings_battle.kings_battle_result, "|")
    for i=11, #battle_result do
    	local Panel_result = ccui.Helper:seekWidgetByName(root,"Panel_result_"..(i-10))
    	if tonumber(zstring.split(battle_result[i], ",")[1]) == 1 then
    		--胜利
			Panel_result:setBackGroundImage("images/ui/text/SMZB_res/46.png")
    	elseif tonumber(zstring.split(battle_result[i], ",")[1]) == 0 then
    		--失败
    		Panel_result:setBackGroundImage("images/ui/text/SMZB_res/47.png")
    	end
    end

    local Text_time = ccui.Helper:seekWidgetByName(root,"Text_time")
    --
    if tonumber(_ED.kings_battle.kings_battle_open_type) == 4 then
    	self.cd_time = tonumber(_ED.kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
    else
    	self.cd_time = tonumber(_ED.kings_battle.kings_battle_next_time)/1000-(tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
    end
    Text_time:setString(self:getTimeDesByInterval(self.cd_time))

end

function SmBattleofKingsMyPeakFormation:onUpdate(dt)
	if self.roots == nil or self.roots[1] == nil or self.cd_time == nil then
		return
	end
    if self.cd_time > 0 then
        self.cd_time = self.cd_time - dt
        ccui.Helper:seekWidgetByName(self.roots[1],"Text_time"):setString(self:getTimeDesByInterval(self.cd_time))
        if self.cd_time <= 60 then
        	local result = zstring.split(_ED.kings_battle.peak_list[_ED.user_info.user_id].result ,"|")
        	if result and tonumber(result[#result][1]) == -1 then
        		self._battle_number = self._battle_number + 1
        	end
        end
        if self.cd_time <= 0 then
        	self.cd_time = nil
            state_machine.excute("sm_battleof_kings_my_peak_formation_save", 0, 0)
        end
    end
end

function SmBattleofKingsMyPeakFormation:init()
    -- self:setTouchEnabled(true)
	self:onInit()
    return self
end

function SmBattleofKingsMyPeakFormation:onInit()
    local csbItem = csb.createNode("campaign/BattleofKings/battle_of_kings_lineup_2.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_wzzz_back"), nil, 
    {
        terminal_name = "sm_battleof_kings_my_peak_formation_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_save"), nil, 
    {
        terminal_name = "sm_battleof_kings_my_peak_formation_save", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "sm_battleof_kings_my_peak_formation_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	
    self:onUpdateDraw()
end

function SmBattleofKingsMyPeakFormation:onEnterTransitionFinish()
    
end


function SmBattleofKingsMyPeakFormation:onExit()
	-- state_machine.remove("sm_battleof_kings_my_peak_formation_change_page")
	state_machine.remove("sm_battleof_kings_my_peak_formation_save")
end

