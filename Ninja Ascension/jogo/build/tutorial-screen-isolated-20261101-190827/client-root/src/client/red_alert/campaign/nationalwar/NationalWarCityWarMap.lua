-----------------------------
--国战城市战争地图
-----------------------------
NationalWarCityWarMap = class("NationalWarCityWarMapClass", Window)
local m_follow = {}

local national_war_city_war_map_window_open_terminal = {
    _name = "national_war_city_war_map_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	for i ,v in pairs(red_alert_home_city_id) do
	   		if _ED.war_user_at_city_id == tonumber(v) then
	   			return
	   		end
	   	end
        local _Window = fwin:find("NationalWarCityWarMapClass")
        if nil == _Window then
            fwin:open(NationalWarCityWarMap:new():init(params), fwin._view)
			state_machine.excute("national_war_map_window_hide",0,"")
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_city_war_map_window_close_terminal = {
    _name = "national_war_city_war_map_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarCityWarMapClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_city_war_map_window_open_terminal)
state_machine.add(national_war_city_war_map_window_close_terminal)
state_machine.init()

----更新包上去后干掉这个方法
function sp.spine_sprite_path_match(armaturePad, jsonFile, atlasFile, actionName, loop, ZOrder, actionTimeSpeed, pAnchor, scale, trackIndex, skinName)
	local _scale = 1
	local _trackIndex = 0
	local _loop = true
	if scale ~= nil then
		_scale = scale
	end
	if trackIndex ~= nil then
		_trackIndex = trackIndex
	end
	if loop ~= nil then
		_loop = loop
	end
	local skeletonNode = sp.spine(jsonFile, atlasFile, _scale, _trackIndex, actionName, _loop, skinName)
	-- if actionTimeSpeed ~= nil and actionTimeSpeed > 0 then
	-- 	skeletonNode:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
	-- end

	if armaturePad ~= nil then
		if ZOrder ~= nil then
			armaturePad:addChild(skeletonNode, ZOrder)
		else
			armaturePad:addChild(skeletonNode)
		end
		local size = armaturePad:getContentSize()
		if pAnchor ~= nil then
			skeletonNode:setPosition(cc.p(size.width * pAnchor.x, size.height * pAnchor.y))
		else
			skeletonNode:setPosition(cc.p(size.width / 2, size.height / 2))
		end
	end

	return skeletonNode
end

function NationalWarCityWarMap:ctor()
    self.super:ctor()
    self.roots = {}
	self.action = {}
	
	-- load lua file
	app.load("client.red_alert.campaign.nationalwar.NationalWarCityWarMapUI")
	app.load("client.red_alert.campaign.nationalwar.NationalWarCityWarBilling")
	app.load("client.red_alert.campaign.nationalwar.NationalWarCityWarOccupiedBilling")
	app.load("client.red_alert.campaign.nationalwar.NatinalWarHeroListviewWarCity")
	app.load("client.red_alert.cells.campaign.nationalwar.national_war_city_war_hero_cell")
	app.load("client.battle.fight.FightEnum")
    app.load("client.red_alert.battle.battle_macros")
	-- var
	self.city_id = nil
	self.armatureLeft = {}
	self.armatureRight = {}
	self.m_cardIndex = 0
	self.updateTime = 0
	self.isUpdateBattleField = -1
	
	-- 我的阵营
	self._myCamp = zstring.tonumber(_ED.user_info.user_force)
	
	-- 当前城池阵营 （0，1，2，3）
	self._camp = 1
	-- 当前城池阵营人员数量 
	self._Defensive_warrior = 1
	-- 当前城池阵营守卫数量
	self._Defensive_npc = 6
	-- 敌方1阵营 
	self._enemy_camp1 = 2
	-- 敌方人员数量 
	self._enemy_number1 = 1
	-- 敌方2阵营 
	self._enemy_camp2 = 3
	-- 敌方人员数量
	self._enemy_number2 = 5
	
    -- Initialize NationalWarMap state machine.
    local function init_national_war_war_city_war_map_terminal()

        local national_war_city_war_battle_move_terminal = {
            _name = "national_war_city_war_battle_move",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if (self._camp ~= self._myCamp and self._Defensive_warrior+self._Defensive_npc == 0) 
				or (self._camp == self._myCamp and self._enemy_number1+self._enemy_number2 == 0) then
					TipDlg.drawTextDailog(red_alert_war_city_map_tip[1])
				else
					instance:setUserPos(_ED.war_city_war_matchingData)
					state_machine.excute("national_war_city_war_attack_cd",0,"")
                    if zstring.tonumber(_ED.war_city_war_result) == 0 then
                        state_machine.excute("national_war_city_war_map_window_close",0,"")
                        state_machine.excute("national_war_map_window_show",0,"")
                        state_machine.excute("national_war_map_return_home_city",0,"")
                        state_machine.excute("natinal_war_revivetime_window_open",0,"")
                    end						
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		local national_war_city_war_battle_request_terminal = {
            _name = "national_war_city_war_battle_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("national_war_city_war_battle_move",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

		--复位操作
        local national_war_city_war_battle_attack_reset_terminal = {
            _name = "national_war_city_war_battle_attack_reset",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:battleAttackReset(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		
        local national_war_city_war_battle_keep_reset_terminal = {
            _name = "national_war_city_war_battle_keep_reset",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:battleKeepReset(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		-- 城池攻占后刷新
		local national_war_city_war_occupied_refresh_terminal = {
            _name = "national_war_city_war_occupied_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
				self:cityWarInfo()
				self:initUserPos()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		-- 城池战斗后的刷新
		local national_war_city_war_billing_refresh_terminal = {
			_name = "national_war_city_war_billing_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 		
				-- if (self._camp ~= zstring.tonumber(_ED.warfareCityInfo[zstring.tonumber(self.city_id)].camp))  then
					-- state_machine.excute("national_war_city_war_occupied_billing_window_open",0,{self.city_id})
				-- end
				self.isUpdateBattleField = self._camp
				self:cityWarInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		-- 卡牌动画播放
		local national_war_city_war_play_tactics_animation_terminal = {
			_name = "national_war_city_war_play_tactics_animation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 		
				self:playTacticsAnimation(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--刷新即时的状态
		local national_war_city_war_update_immediate_terminal = {
			_name = "national_war_city_war_update_immediate",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 		
				--刷新血量
				state_machine.excute("national_war_hero_listview_war_city_update_hp",0,"")
				--刷新城池人数
				self:cityWarInfo()
				self:StaffComplement()
				-- state_machine.excute("national_war_city_war_billing_ui_refresh",0,"")
				--刷新城池状态
				state_machine.excute("national_war_city_war_buff_number_update",0,"")
				--刷新玩家连斩
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--场景动画播放后的动画
		local national_war_city_war_scenes_animation_end_terminal = {
			_name = "national_war_city_war_scenes_animation_end",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 		
				--刷新血量
				state_machine.excute("national_war_hero_listview_war_city_update_hp",0,"")
				if instance.m_cardIndex~= 1 and instance.m_cardIndex~= 2 then
					instance:cardSkillAnimation(instance.m_cardIndex)
				else
					state_machine.excute("national_war_city_war_buff_show",0,{instance.m_cardIndex})
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(national_war_city_war_battle_move_terminal)  
        state_machine.add(national_war_city_war_battle_request_terminal)  
        state_machine.add(national_war_city_war_battle_attack_reset_terminal)  
        state_machine.add(national_war_city_war_battle_keep_reset_terminal)  
        state_machine.add(national_war_city_war_occupied_refresh_terminal)  
        state_machine.add(national_war_city_war_billing_refresh_terminal)  
        state_machine.add(national_war_city_war_play_tactics_animation_terminal)  
        state_machine.add(national_war_city_war_update_immediate_terminal)  
        state_machine.add(national_war_city_war_scenes_animation_end_terminal)  
        state_machine.init()
    end
    
    -- call func init rebirth state machine.
    init_national_war_war_city_war_map_terminal()
end

--卡牌动画的绘制
function NationalWarCityWarMap.cardChangeActionCallback(armatureBack)
	armatureBack:removeFromParent(true)
	armatureBack = nil
end

--角色身上的动画绘制
function NationalWarCityWarMap:cardSkillAnimation(index)
	local root = self.roots[1]
	local skeletonNode = sp.spine("sprite/effect_gz_"..index..".json", "sprite/effect_gz_"..index..".atlas", 1, 0, nil, false, nil)
	if self._myCamp ~= self._camp then--如果我是攻
		self.armatureLeft[2]:addChild(skeletonNode)
	else
		self.armatureRight[2]:addChild(skeletonNode)
	end
	skeletonNode:addAnimation(0, "animation", true)
	sp.initArmature(skeletonNode, true)
	skeletonNode:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	if index~=3 and index ~= 4 then
		skeletonNode._invoke = self.cardChangeActionCallback
	-- else
		-- skeletonNode:setTag(998)
	end
	_ED.warfare_buff_personal = {}
end

local function deleteEffectFile(armatureBack) 
	-- CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo("images/ui/effice/effect_gzkapai/effect_gzkapai.ExportJson")
	if armatureBack.removeFromParent ~= nil then
		armatureBack:removeFromParent(true)
		armatureBack = nil
	end
	state_machine.excute("national_war_city_war_scenes_animation_end",0,"")
end

-- 绘制卡牌动画
function NationalWarCityWarMap:playTacticsAnimation(index)
	local root = self.roots[1]
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_gzkapai/effect_gzkapai.ExportJson")
	local armature = ccs.Armature:create("effect_gzkapai")
	self.m_cardIndex = index
	armature:getAnimation():playWithIndex(index-1)
	armature:setAnchorPoint(0.5,0.5)
	armature:setPosition(cc.p(self:getContentSize().width/2,self:getContentSize().height/2))
	armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	armature._invoke = deleteEffectFile
	self:addChild(armature)
	if self.m_cardIndex == 1 then
		pushEffect(formatMusicFile("effect", zstring.tonumber(config_res.campaign.nationalwar.music.background.card.miehuo)))
	elseif self.m_cardIndex == 2 then
		pushEffect(formatMusicFile("effect", zstring.tonumber(config_res.campaign.nationalwar.music.background.card.fanghuo)))
	elseif self.m_cardIndex == 3 then
		pushEffect(formatMusicFile("effect", zstring.tonumber(config_res.campaign.nationalwar.music.background.card.jufen)))
	elseif self.m_cardIndex == 4 then
		pushEffect(formatMusicFile("effect", zstring.tonumber(config_res.campaign.nationalwar.music.background.card.guwu)))
	elseif self.m_cardIndex == 5 then
		pushEffect(formatMusicFile("effect", zstring.tonumber(config_res.campaign.nationalwar.music.background.card.liaoshang)))
	end
end

function NationalWarCityWarMap:cityWarInfo()
	local root = self.roots[1]
	-- 当前城池阵营 （0，1，2，3）
	self._camp = zstring.tonumber(_ED.war_in_city_info.now_city_camp)
	-- 当前城池阵营守卫数量
	self._Defensive_npc = zstring.tonumber(_ED.war_in_city_info.defense_people_number)

	
	if self._camp == 1 then
		self._Defensive_warrior = zstring.tonumber(_ED.war_in_city_info.union_people_number)
		self._enemy_number1 = zstring.tonumber(_ED.war_in_city_info.natural_numbers)
		self._enemy_number2 = zstring.tonumber(_ED.war_in_city_info.act_of_god_numbers)
	elseif self._camp == 2 then
		self._Defensive_warrior = zstring.tonumber(_ED.war_in_city_info.natural_numbers)
		self._enemy_number1 = zstring.tonumber(_ED.war_in_city_info.union_people_number)
		self._enemy_number2 = zstring.tonumber(_ED.war_in_city_info.act_of_god_numbers)
	elseif self._camp == 3 then 
		self._Defensive_warrior = zstring.tonumber(_ED.war_in_city_info.act_of_god_numbers)
		self._enemy_number1 = zstring.tonumber(_ED.war_in_city_info.union_people_number)
		self._enemy_number2 = zstring.tonumber(_ED.war_in_city_info.natural_numbers)
	else
		--中立的城池处理 ****  应该是要加一个_enemy_number3,逻辑太多，只在_enemy_number1后面做处理
		self._Defensive_warrior = zstring.tonumber(_ED.war_in_city_info.defense_people_number)
		self._enemy_number1 = zstring.tonumber(_ED.war_in_city_info.union_people_number) + zstring.tonumber(_ED.war_in_city_info.act_of_god_numbers) --两个阵营的数量
		self._enemy_number2 = zstring.tonumber(_ED.war_in_city_info.natural_numbers)
	end
end

--刷新后的人员补位
function NationalWarCityWarMap:StaffComplement()
	local root = self.roots[1]
	local Panel_battle_map = ccui.Helper:seekWidgetByName(root,"Panel_battle_map")
	--攻击方补充人数
	local attackNumberPeople = 0
	if self._enemy_number1 + self._enemy_number2 > 6 then
		attackNumberPeople = 6
	else
		attackNumberPeople = self._enemy_number1 + self._enemy_number2
	end
	if attackNumberPeople == 1 then
		if self._myCamp == self._camp then--如果我是防
			if self.armatureLeft[2]== nil then
				self:battleApproachSupplement(2,5,0)
			end
		end
	else
		for i=1, attackNumberPeople do
			if self.armatureLeft[i]== nil then
				self:battleApproachSupplement(i,i+3,0)
			end
		end
	end
	--防守方补充人数
	local defenseNumberPeople = 0
	if self._Defensive_warrior + self._Defensive_npc > 6 then
		defenseNumberPeople = 6
	else
		defenseNumberPeople = self._Defensive_warrior + self._Defensive_npc
	end
	
	if defenseNumberPeople == 1 then
		if self._myCamp ~= self._camp then--如果我是攻
			if self.armatureRight[2] == nil then
				self:battleApproachSupplement(2,5,1)
			end
		end
	else
		for i=1, defenseNumberPeople do
			if self.armatureRight[i]== nil then
				self:battleApproachSupplement(i,i+3,1)
			end
		end
	end
end

--切换人物形象
function NationalWarCityWarMap:replaceTheImage(list,index,battletype,matchingData)
	local root = self.roots[1]
	local Panel_battle_map = ccui.Helper:seekWidgetByName(root,"Panel_battle_map")
	
	local Panel_left_role = nil
	local Panel_left_roleMove = nil
	list:removeFromParent(true)
	list = nil
	if battletype == 0 then
		Panel_left_role = ccui.Helper:seekWidgetByName(root,"Panel_left_role_"..index+3)
		Panel_left_roleMove = ccui.Helper:seekWidgetByName(root,"Panel_left_role_"..index)
	else
		Panel_left_role = ccui.Helper:seekWidgetByName(root,"Panel_right_role_"..index+3)
		Panel_left_roleMove = ccui.Helper:seekWidgetByName(root,"Panel_right_role_"..index)
	end
	local x = Panel_left_role:getPositionX()
	local y = Panel_left_role:getPositionY()
	local ProtagonistAnimation = _enum_spine_animation_image_path.actress_image
	local positionIndex = 0
	if index+3 == 1 or index+3 == 4 or index+3 == 7 then
		positionIndex = 1
	elseif index+3 ==2 or index+3 == 5 or index+3 == 8 then
		positionIndex = 2
	else
		positionIndex = 3
	end
	local armature = sp.spine_sprite_path_match(Panel_battle_map, ProtagonistAnimation..".json", ProtagonistAnimation..".atlas", _spine_sprite_animation_names[24], true, positionIndex, nil, cc.p(0.5, 0))
	armature:setPosition(cc.p(x + Panel_left_role:getContentSize().width/2,y + Panel_left_role:getContentSize().height/2))
	armature:addAnimation(0, _spine_sprite_animation_names[24], true)
	sp.initArmature(armature, true)
	armature.animationNameList = _spine_sprite_animation_names
	armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)

	local action_index =  _enum_spine_animation_frame_index.animation_standby_dir_20
	csb.animationChangeToAction(armature,action_index, action_index, true)
	if battletype == 0 then
		self.armatureLeft[index] = armature
		if index+3==1 or index+3 == 4 or index+3 == 7 then
			armature:setScale(0.6)
		elseif index+3==2 or index+3 == 5 or index+3 == 8 then
			armature:setScale(0.7)
		else
			armature:setScale(0.8)
		end
		local x = Panel_left_roleMove:getPositionX()
		local y = Panel_left_roleMove:getPositionY()
		local move_x = x + Panel_left_roleMove:getContentSize().width/2
		local move_y = y + Panel_left_roleMove:getContentSize().height/2
		local user_at_x ,user_at_y = self.armatureLeft[index]:getPosition()
		self:move(cc.p(user_at_x ,user_at_y),cc.p(move_x,move_y),self.armatureLeft[index])
		local function change_npc_state()
			state_machine.excute("national_war_city_war_is_move",0,{0})
			local action_index = self.move_index - 1
			csb.animationChangeToAction(self.armatureLeft[index],action_index, action_index, true)
			if matchingData ~= nil then
				local action_index = battletype == 0 and _enum_spine_animation_frame_index.animation_attack_dir_7 or _enum_spine_animation_frame_index.animation_attack_dir_20
				csb.animationChangeToAction(self.armatureLeft[index],action_index, action_index, true)
				self.armatureLeft[index].cycleNumber=0
				self.armatureLeft[index]._isDeath = zstring.tonumber(matchingData.outcome)--是否存活
				self.armatureLeft[index]._battletype = battletype
				self.armatureLeft[index]._index = index
				self.armatureLeft[index]._invoke = self.changeActionCallback
			end
		end
		self.armatureLeft[index]:runAction(cc.Sequence:create(cc.MoveTo:create(1,cc.p(move_x,move_y)),cc.CallFunc:create(change_npc_state)))
	else
		self.armatureRight[index] = armature
		if index+3==1 or index+3 == 4 or index+3 == 7 then
			armature:setScale(0.6)
			armature:setScaleX(-0.6)
		elseif index+3==2 or index+3 == 5 or index+3 == 8 then
			armature:setScale(0.7)
			armature:setScaleX(-0.7)
		else
			armature:setScale(0.8)
			armature:setScaleX(-0.8)
		end
		local x = Panel_left_roleMove:getPositionX()
		local y = Panel_left_roleMove:getPositionY()
		local move_x = x + Panel_left_roleMove:getContentSize().width/2
		local move_y = y + Panel_left_roleMove:getContentSize().height/2
		local user_at_x ,user_at_y = self.armatureRight[index]:getPosition()
		self:move(cc.p(user_at_x ,user_at_y),cc.p(move_x,move_y),self.armatureRight[index])
		local function change_npc_state()
			state_machine.excute("national_war_city_war_is_move",0,{0})
			local action_index = self.move_index - 1
			csb.animationChangeToAction(self.armatureRight[index],action_index, action_index, true)
			if matchingData ~= nil then
				local action_index = battletype == 0 and _enum_spine_animation_frame_index.animation_attack_dir_7 or _enum_spine_animation_frame_index.animation_attack_dir_20
				csb.animationChangeToAction(self.armatureRight[index],action_index, action_index, true)
				self.armatureRight[index].cycleNumber=0
				self.armatureRight[index]._isDeath = zstring.tonumber(matchingData.outcome)--是否存活
				self.armatureRight[index]._battletype = battletype
				self.armatureRight[index]._index = index
				self.armatureRight[index]._invoke = self.changeActionCallback
			end
		end
		self.armatureRight[index]:runAction(cc.Sequence:create(cc.MoveTo:create(1,cc.p(move_x,move_y)),cc.CallFunc:create(change_npc_state)))
	end
end

function NationalWarCityWarMap:initUserPos()
	local root = self.roots[1]
	for z=1, 9 do
		if self.armatureLeft[z]~= nil and self.armatureLeft[z]:getParent() ~= nil then
			self.armatureLeft[z]:removeFromParent(true)
			self.armatureLeft[z] = nil
		end
		if self.armatureRight[z]~= nil and self.armatureRight[z]:getParent() ~= nil then
			self.armatureRight[z]:removeFromParent(true)
			self.armatureRight[z] = nil
		end
	end
	self.armatureLeft = {}
	self.armatureRight = {}
				
	local Panel_battle_map = ccui.Helper:seekWidgetByName(root,"Panel_battle_map")
	
	local attackTheStarting  = 1 --攻方初始位
	local attackNumber = self._enemy_number1+self._enemy_number2
	local defensiveTheStarting  = 1  --守方初始位
	local defensiveNumber = self._Defensive_warrior+self._Defensive_npc
	if self._myCamp ~= self._camp then--如果我是攻
		if attackNumber == 1 then
			attackTheStarting = 2
		else
			attackTheStarting = 1
		end
		if defensiveNumber == 1 then
			defensiveTheStarting = 2
		else
			defensiveTheStarting = 1
		end
	end
	if self._myCamp == self._camp then--如果我是防
		if defensiveNumber == 1 then
			defensiveTheStarting = 2
		else
			defensiveTheStarting = 1	
		end
		if attackNumber == 1 then
			attackTheStarting = 2
		else
			attackTheStarting = 1
		end
	end
	--攻(主角永远在第二位)
	
	if attackNumber > 0 then
		if attackNumber > 6 then
			attackNumber = 6
		end
		local attackTheStarting  = 1
		if self._myCamp ~= self._camp then--如果我是攻
			if attackNumber == 1 then
				attackTheStarting = 2
			end
		end
		for i=1, attackNumber do
			local Panel_left_role = ccui.Helper:seekWidgetByName(root,"Panel_left_role_"..attackTheStarting+i-1+3)
			local x = Panel_left_role:getPositionX()
			local y = Panel_left_role:getPositionY()
			local ProtagonistAnimation = nil
			if self._myCamp ~= self._camp then--如果我是攻
				if attackTheStarting == 2 or (attackTheStarting == 1 and i == 2) then
					if zstring.tonumber(_ED.user_info.user_gender) == 2 then
						ProtagonistAnimation = _enum_spine_animation_image_path.actress_image
					else
						ProtagonistAnimation = _enum_spine_animation_image_path.leading_man_image
					end
				else
					ProtagonistAnimation = _enum_spine_animation_image_path.leading_man_image
				end
			else
				ProtagonistAnimation = _enum_spine_animation_image_path.leading_man_image
			end
			local positionIndex = 0
			if attackTheStarting+i-1 == 1 or attackTheStarting+i-1 == 4 or attackTheStarting+i-1 == 7 then
				positionIndex = 1
			elseif attackTheStarting+i-1 ==2 or attackTheStarting+i-1 == 5 or attackTheStarting+i-1 == 8 then
				positionIndex = 2
			else
				positionIndex = 3
			end
			local armature = sp.spine_sprite_path_match(Panel_battle_map, ProtagonistAnimation..".json", ProtagonistAnimation..".atlas", _spine_sprite_animation_names[24], true, positionIndex, nil, cc.p(0.5, 0))
			armature:setPosition(cc.p(x + Panel_left_role:getContentSize().width/2,y + Panel_left_role:getContentSize().height/2))
			armature:addAnimation(0, _spine_sprite_animation_names[24], true)
			sp.initArmature(armature, true)
			armature.animationNameList = _spine_sprite_animation_names
			armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)

			local action_index =  _enum_spine_animation_frame_index.animation_standby_dir_20
			csb.animationChangeToAction(armature,action_index, action_index, true)
			self.armatureLeft[attackTheStarting+i-1] = armature
			if attackTheStarting+i-1==1 or attackTheStarting+i-1 == 4 or attackTheStarting+i-1 == 7 then
				armature:setScale(0.6)
			elseif attackTheStarting+i-1==2 or attackTheStarting+i-1 == 5 or attackTheStarting+i-1 == 8 then
				armature:setScale(0.7)
			else
				armature:setScale(0.8)
			end
				
			if self._myCamp ~= self._camp then--如果我是攻
				if attackTheStarting == 2 or (attackTheStarting == 1 and i == 2) then
					self:showShipInfo(self.armatureLeft[attackTheStarting+i-1])
					for i, v in pairs(_ED.warfare_buff_personal) do
						self:cardSkillAnimation(dms.int(dms["warfare_card"], zstring.tonumber(v.buff_card_id), warfare_card.effect))
					end
					local baseName = "images/ui/effice/effect_jd/effect_jd"
					local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
					skeletonNode:setAnimation(0.5, "animation", true)
					skeletonNode:setPosition(cc.p(0,self.armatureLeft[attackTheStarting+i-1]:getContentSize().height*2))
					skeletonNode:setScale(2.0)
					self.armatureLeft[attackTheStarting+i-1]:addChild(skeletonNode,-1)
				end
			end
			--标记
			self.armatureLeft[attackTheStarting+i-1]._m_index = attackTheStarting+i-1+3
		end
	end
	
	--防
	if defensiveNumber > 0 then
		if defensiveNumber > 6 then
			defensiveNumber = 6
		end
		local attackTheStarting  = 1
		if self._myCamp == self._camp then--如果我是防
			if defensiveNumber == 1 then
				attackTheStarting = 2
			end
		end
		for j=1, defensiveNumber do
			local Panel_left_role = ccui.Helper:seekWidgetByName(root,"Panel_right_role_"..defensiveTheStarting+j-1+3)
			local x = Panel_left_role:getPositionX()
			local y = Panel_left_role:getPositionY()
			local ProtagonistAnimation = nil
			if self._myCamp == self._camp then--如果我是防
				if attackTheStarting == 2 or (attackTheStarting == 1 and j == 2) then
					if zstring.tonumber(_ED.user_info.user_gender) == 2 then
						ProtagonistAnimation = _enum_spine_animation_image_path.actress_image
					else
						ProtagonistAnimation = _enum_spine_animation_image_path.leading_man_image
					end
				else
					ProtagonistAnimation = _enum_spine_animation_image_path.leading_man_image
				end
			else
				ProtagonistAnimation = _enum_spine_animation_image_path.leading_man_image
			end
			local positionIndex = 0
			if defensiveTheStarting+j-1 == 1 or defensiveTheStarting+j-1 == 4 or defensiveTheStarting+j-1 == 7 then
				positionIndex = 1
			elseif defensiveTheStarting+j-1 ==2 or defensiveTheStarting+j-1 == 5 or defensiveTheStarting+j-1 == 8 then
				positionIndex = 2
			else
				positionIndex = 3
			end
			local armature = sp.spine_sprite_path_match(Panel_battle_map, ProtagonistAnimation..".json", ProtagonistAnimation..".atlas", _spine_sprite_animation_names[76], true, positionIndex, nil, cc.p(0.5, 0))
			armature:setPosition(cc.p(x + Panel_left_role:getContentSize().width/2,y + Panel_left_role:getContentSize().height/2))
			armature:addAnimation(0, _spine_sprite_animation_names[76], true)
			sp.initArmature(armature, true)    
			armature.animationNameList = _spine_sprite_animation_names
			armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  

			local action_index =  _enum_spine_animation_frame_index.animation_standby_dir_19
			csb.animationChangeToAction(armature,action_index, action_index, true)
			self.armatureRight[defensiveTheStarting+j-1] = armature
			if defensiveTheStarting+j-1==1 or defensiveTheStarting+j-1 == 4 or defensiveTheStarting+j-1 == 7 then
				armature:setScale(0.6)
				armature:setScaleX(-0.6)
			elseif defensiveTheStarting+j-1==2 or defensiveTheStarting+j-1 == 5 or defensiveTheStarting+j-1 == 8 then
				armature:setScale(0.7)
				armature:setScaleX(-0.7)
			else
				armature:setScale(0.8)
				armature:setScaleX(-0.8)
			end
			if self._myCamp == self._camp then--如果我是防
				if defensiveTheStarting == 2 or (defensiveTheStarting == 1 and j == 2) then
					self:showShipInfo(self.armatureRight[defensiveTheStarting+j-1],nil,true)
					for i, v in pairs(_ED.warfare_buff_personal) do
						self:cardSkillAnimation(dms.int(dms["warfare_card"], zstring.tonumber(v.buff_card_id), warfare_card.effect))
					end
					local baseName = "images/ui/effice/effect_jd/effect_jd"
					local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
					skeletonNode:setAnimation(0.5, "animation", true)
					skeletonNode:setPosition(cc.p(0,self.armatureRight[defensiveTheStarting+j-1]:getContentSize().height*2))
					skeletonNode:setScale(2.0)
					self.armatureRight[defensiveTheStarting+j-1]:addChild(skeletonNode,-1)
				end
			end
			
			--标记
			self.armatureRight[defensiveTheStarting+j-1]._m_index = defensiveTheStarting+j-1+3
		end
	end
end


-- 死亡和胜利
function NationalWarCityWarMap.changeActionCallback(armatureBack)
	local armature = armatureBack
	if armature ~= nil then
		local actionIndex = armature._actionIndex
		if actionIndex == _enum_spine_animation_frame_index.animation_attack_dir_7 
			or actionIndex == _enum_spine_animation_frame_index.animation_attack_dir_20 
			then
			armature.cycleNumber = armature.cycleNumber + 1
			if armature.cycleNumber == 2 then
				if armature._isDeath == 1 then
					armature._nextAction = _enum_spine_animation_frame_index.animation_shengli
				else
					armature._nextAction = _enum_spine_animation_frame_index.animation_death
				end
			end
		elseif actionIndex == _enum_spine_animation_frame_index.animation_death then
			-- remove
			armature.cycleNumber = armature.cycleNumber + 1
			if armature.cycleNumber == 3 then
				armature._nextAction = _enum_spine_animation_frame_index.animation_standby_dir_20
			end
		elseif actionIndex == _enum_spine_animation_frame_index.animation_shengli then	
			armature.cycleNumber = armature.cycleNumber + 1
			if armature.cycleNumber == 3 then
				armature._nextAction = _enum_spine_animation_frame_index.animation_standby_dir_20
			end
		elseif actionIndex == _enum_spine_animation_frame_index.animation_standby_dir_20 then	
			if armature._battletype == 0 then
				state_machine.excute("national_war_city_war_battle_attack_reset",0,armature)
			else
				state_machine.excute("national_war_city_war_battle_keep_reset",0,armature)
			end
		end
	end
	
end

-- 战斗后的攻方复位操作
function NationalWarCityWarMap:battleAttackReset(armature)
	local root = self.roots[1]
	
	for i,v in pairs(self.armatureLeft) do
		if v == armature then
				if self.armatureLeft[i+3] ~= nil then
					armature:removeFromParent(true)
					armature = nil
					self.armatureLeft[i]:setVisible(false)
					self.armatureLeft[i]:removeFromParent(true)
					self.armatureLeft[i] = nil
					self.armatureLeft[i] = self.armatureLeft[i+3]
					self.armatureLeft[i+3]:setVisible(false)
					self.armatureLeft[i+3] = nil
					self.armatureLeft[i]:setVisible(true)
					if self._enemy_number1+self._enemy_number2 > i+3 then
						self:battleApproachSupplement(i+3,i+6,0)
						if self._myCamp ~= self._camp then--如果我是攻
							if (i==2 and self._enemy_number1+self._enemy_number2 >= i-1) then
								self:showShipInfo(self.armatureLeft[i],nil,false)
								for i, v in pairs(_ED.warfare_buff_personal) do
									self:cardSkillAnimation(dms.int(dms["warfare_card"], zstring.tonumber(v.buff_card_id), warfare_card.effect))
								end
								local baseName = "images/ui/effice/effect_jd/effect_jd"
								local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
								skeletonNode:setAnimation(0.5, "animation", true)
								skeletonNode:setPosition(cc.p(0,self.armatureLeft[i]:getContentSize().height*2))
								skeletonNode:setScale(2.0)
								self.armatureLeft[i]:addChild(skeletonNode,-1)
							end
						end
					end
				else
					if (i==2 and self._enemy_number1+self._enemy_number2 >= i-1) 
					or self._enemy_number1+self._enemy_number2 >= i then
						if self.armatureLeft[i+3] == nil and self._enemy_number1+self._enemy_number2<=i+3 then
							if self.armatureLeft[6]~= nil then
								self.armatureLeft[6]:removeFromParent(true)
								self.armatureLeft[6] = nil
							elseif self.armatureLeft[6] == nil and self.armatureLeft[4]~= nil then
								self.armatureLeft[4]:removeFromParent(true)
								self.armatureLeft[4] = nil
							elseif self.armatureLeft[6] == nil and self.armatureLeft[4]== nil and self.armatureLeft[3]~= nil then
								self.armatureLeft[3]:removeFromParent(true)
								self.armatureLeft[3] = nil
							elseif self.armatureLeft[6] == nil and self.armatureLeft[4]== nil and self.armatureLeft[3]== nil and self.armatureLeft[1] ~= nil then 
								self.armatureLeft[1]:removeFromParent(true)
								self.armatureLeft[1] = nil
							end
							self:battleApproachSupplement(i,i+3,0)
							if self._myCamp ~= self._camp then--如果我是攻
								if (i==2 and self._enemy_number1+self._enemy_number2 >= i-1) then
									self:showShipInfo(self.armatureLeft[i],nil,false)
									for i, v in pairs(_ED.warfare_buff_personal) do
										self:cardSkillAnimation(dms.int(dms["warfare_card"], zstring.tonumber(v.buff_card_id), warfare_card.effect))
									end
									local baseName = "images/ui/effice/effect_jd/effect_jd"
									local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
									skeletonNode:setAnimation(0.5, "animation", true)
									skeletonNode:setPosition(cc.p(0,self.armatureLeft[i]:getContentSize().height*2))
									skeletonNode:setScale(2.0)
									self.armatureLeft[i]:addChild(skeletonNode,-1)
								end
							end
						else
							self:battleApproachSupplement(i,i+3,0)
							if (i==2 and self._enemy_number1+self._enemy_number2 >= i-1) then
								self:showShipInfo(self.armatureLeft[i],nil,false)
								for i, v in pairs(_ED.warfare_buff_personal) do
									self:cardSkillAnimation(dms.int(dms["warfare_card"], zstring.tonumber(v.buff_card_id), warfare_card.effect))
								end
								local baseName = "images/ui/effice/effect_jd/effect_jd"
								local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
								skeletonNode:setAnimation(0.5, "animation", true)
								skeletonNode:setPosition(cc.p(0,self.armatureLeft[i]:getContentSize().height*2))
								skeletonNode:setScale(2.0)
								self.armatureLeft[i]:addChild(skeletonNode,-1)
							end
						end
					end
					armature:removeFromParent(true)
					armature = nil
				end
			break
		end
	end
end 

-- 战斗后的守方复位操作
function NationalWarCityWarMap:battleKeepReset(armature)
	local root = self.roots[1]
	for i,v in pairs(self.armatureRight) do
		if v == armature then
				if self.armatureRight[i+3] ~= nil then
					
					armature:removeFromParent(true)
					armature = nil
					self.armatureRight[i]:setVisible(false)
					self.armatureRight[i]:removeFromParent(true)
					self.armatureRight[i] = nil
					self.armatureRight[i] = self.armatureRight[i+3]
					self.armatureRight[i+3]:setVisible(false)
					self.armatureRight[i+3] = nil
					self.armatureRight[i]:setVisible(true)
					if self._Defensive_warrior+self._Defensive_npc > i+3 then
						self:battleApproachSupplement(i+3,i+6,1)
						if self._myCamp == self._camp then--如果我是防
							if (i==2 and self._Defensive_warrior+self._Defensive_npc >= i-1) then
								self:showShipInfo(self.armatureRight[i],nil,true)
								for i, v in pairs(_ED.warfare_buff_personal) do
									self:cardSkillAnimation(dms.int(dms["warfare_card"], zstring.tonumber(v.buff_card_id), warfare_card.effect))
								end
								local baseName = "images/ui/effice/effect_jd/effect_jd"
								local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
								skeletonNode:setAnimation(0.5, "animation", true)
								skeletonNode:setPosition(cc.p(0,self.armatureRight[i]:getContentSize().height*2))
								skeletonNode:setScale(2.0)
								self.armatureRight[i]:addChild(skeletonNode,-1)
							end
						end
					end
				else
					---这里有问题
					if (i==2 and self._Defensive_warrior+self._Defensive_npc >= i-1) 
					or self._Defensive_warrior+self._Defensive_npc >= i then
						if self.armatureRight[i+3] == nil and self._Defensive_warrior+self._Defensive_npc<=i+3 then
							if self.armatureRight[6]~= nil then
								self.armatureRight[6]:removeFromParent(true)
								self.armatureRight[6] = nil
							elseif self.armatureRight[6] == nil and self.armatureRight[4]~= nil then
								self.armatureRight[4]:removeFromParent(true)
								self.armatureRight[4] = nil
							elseif self.armatureRight[6] == nil and self.armatureRight[4]== nil and self.armatureRight[3]~= nil then
								self.armatureRight[3]:removeFromParent(true)
								self.armatureRight[3] = nil
							elseif self.armatureRight[6] == nil and self.armatureRight[4]== nil and self.armatureRight[3]== nil and self.armatureRight[1] ~= nil then 
								self.armatureRight[1]:removeFromParent(true)
								self.armatureRight[1] = nil
							end
							self:battleApproachSupplement(i,i+3,1)
							if self._myCamp == self._camp then--如果我是防
								if (i==2 and self._Defensive_warrior+self._Defensive_npc >= i-1) then
									self:showShipInfo(self.armatureRight[i],nil,true)
									for i, v in pairs(_ED.warfare_buff_personal) do
										self:cardSkillAnimation(dms.int(dms["warfare_card"], zstring.tonumber(v.buff_card_id), warfare_card.effect))
									end
									local baseName = "images/ui/effice/effect_jd/effect_jd"
									local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
									skeletonNode:setAnimation(0.5, "animation", true)
									skeletonNode:setPosition(cc.p(0,self.armatureRight[i]:getContentSize().height*2))
									skeletonNode:setScale(2.0)
									self.armatureRight[i]:addChild(skeletonNode,-1)
								end
							end
						else
							self:battleApproachSupplement(i,i+3,1)
							if (i==2 and self._Defensive_warrior+self._Defensive_npc >= i-1) then
								self:showShipInfo(self.armatureRight[i],nil,true)
								for i, v in pairs(_ED.warfare_buff_personal) do
									self:cardSkillAnimation(dms.int(dms["warfare_card"], zstring.tonumber(v.buff_card_id), warfare_card.effect))
								end
								local baseName = "images/ui/effice/effect_jd/effect_jd"
								local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
								skeletonNode:setAnimation(0.5, "animation", true)
								skeletonNode:setPosition(cc.p(0,self.armatureRight[i]:getContentSize().height*2))
								skeletonNode:setScale(2.0)
								self.armatureRight[i]:addChild(skeletonNode,-1)
							end
						end
					end
					armature:removeFromParent(true)
					armature = nil
				end
			break
		end
	end
end 

--战斗入场补充
--1：补充的队列，2：移动到的id,3:攻击还是防守（0攻，1防）
function NationalWarCityWarMap:battleApproachSupplement(list, index, battletype)
	local root = self.roots[1]
	
	local city_panel = nil
	local actionId = 0
	local w = 0
	if battletype == 0 then
		city_panel = ccui.Helper:seekWidgetByName(root,"Panel_left_role_"..index)
		actionId = 24
		w = 0
	else
		city_panel = ccui.Helper:seekWidgetByName(root,"Panel_right_role_"..index)
		actionId = 76
		w = ccui.Helper:seekWidgetByName(root,"Panel_battle_map"):getContentSize().width
	end
	local x = city_panel:getPositionX()
	local y = city_panel:getPositionY()
	local positionIndex = 0
	if list == 1 or list == 4 or list == 7 then
		positionIndex = 1
	elseif list ==2 or list == 5 or list == 8 then
		positionIndex = 2
	else
		positionIndex = 3
	end
	local armature = sp.spine_sprite_path_match(ccui.Helper:seekWidgetByName(root,"Panel_battle_map"), _enum_spine_animation_image_path.leading_man_image..".json", _enum_spine_animation_image_path.leading_man_image..".atlas", _spine_sprite_animation_names[actionId], true, positionIndex, nil, cc.p(0.5, 0))
	armature:setPosition(cc.p(w,y + city_panel:getContentSize().height/2))
	armature:addAnimation(0, _spine_sprite_animation_names[actionId], true)
	sp.initArmature(armature, true)
	armature.animationNameList = _spine_sprite_animation_names
	armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  

	local action_index =  _enum_spine_animation_frame_index.animation_standby_dir_20
	csb.animationChangeToAction(armature,action_index, action_index, true)
	if battletype == 0 then
		self.armatureLeft[list] = armature
		if list==1 or list == 4 or list == 7 then
			armature:setScale(0.6)
		elseif list==2 or list == 5 or list == 8 then
			armature:setScale(0.7)
		else
			armature:setScale(0.8)
		end
		local move_x = x + city_panel:getContentSize().width/2
		local move_y = y + city_panel:getContentSize().height/2
		local user_at_x ,user_at_y = self.armatureLeft[list]:getPosition()
		self:move(cc.p(user_at_x ,user_at_y),cc.p(move_x,move_y),self.armatureLeft[list])
		local function change_npc_state()
			state_machine.excute("national_war_city_war_is_move",0,{0})
			local action_index = self.move_index - 1
			csb.animationChangeToAction(self.armatureLeft[list],action_index, action_index, true)
		end
		self.armatureLeft[list]:runAction(cc.Sequence:create(cc.MoveTo:create(1,cc.p(move_x,move_y)),cc.CallFunc:create(change_npc_state)))
	else
		self.armatureRight[list] = armature
		if list==1 or list == 4 or list == 7 then
			armature:setScale(0.6)
			armature:setScaleX(-0.6)
		elseif list==2 or list == 5 or list == 8 then
			armature:setScale(0.7)
			armature:setScaleX(-0.7)
		else
			armature:setScale(0.8)
			armature:setScaleX(-0.8)
		end
		local move_x = x + city_panel:getContentSize().width/2
		local move_y = y + city_panel:getContentSize().height/2
		local user_at_x ,user_at_y = self.armatureRight[list]:getPosition()
		self:move(cc.p(user_at_x ,user_at_y),cc.p(move_x,move_y),self.armatureRight[list])
		local function change_npc_state()
			state_machine.excute("national_war_city_war_is_move",0,{0})
			local action_index = self.move_index - 1
			csb.animationChangeToAction(self.armatureRight[list],action_index, action_index, true)
		end
		self.armatureRight[list]:runAction(cc.Sequence:create(cc.MoveTo:create(1,cc.p(move_x,move_y)),cc.CallFunc:create(change_npc_state)))
		
	end
end

--1：移动的队列，2:赋值的数据 3：移动到的id,4:攻击还是防守（0攻，1防）
function NationalWarCityWarMap:battleMoveMatching(list, matchingData ,index, battletype)
	local root = self.roots[1]
	local city_panel = nil
	
	if matchingData ~= nil 
	and zstring.tonumber(matchingData.userId) ~= zstring.tonumber(_ED.user_info.user_id) 
	and zstring.tonumber(matchingData.gender) == 2 
	then
		self:replaceTheImage(list,index,battletype,matchingData)	
		return
	end
	if battletype == 0 then
		city_panel = ccui.Helper:seekWidgetByName(root,"Panel_left_role_"..index)
	else
		city_panel = ccui.Helper:seekWidgetByName(root,"Panel_right_role_"..index)
	end
	local x = city_panel:getPositionX()
	local y = city_panel:getPositionY()
	local move_x = x + city_panel:getContentSize().width/2
	local move_y = y + city_panel:getContentSize().height/2
	local user_at_x ,user_at_y = list:getPosition()
	self:move(cc.p(user_at_x ,user_at_y),cc.p(move_x,move_y),list)
	local function change_npc_state()
		state_machine.excute("national_war_city_war_is_move",0,{0})
		local action_index = self.move_index - 1
		csb.animationChangeToAction(list,action_index, action_index, true)
		if matchingData ~= nil then
			local action_index = battletype == 0 and _enum_spine_animation_frame_index.animation_attack_dir_7 or _enum_spine_animation_frame_index.animation_attack_dir_20
			csb.animationChangeToAction(list,action_index, action_index, true)
			list.cycleNumber=0
			list._isDeath = zstring.tonumber(matchingData.outcome)--是否存活
			list._battletype = battletype
			list._index = index
			list._invoke = self.changeActionCallback
		end
	end
	list:runAction(cc.Sequence:create(cc.MoveTo:create(1,cc.p(move_x,move_y)),cc.CallFunc:create(change_npc_state)))
	
end

-- 移动用户坐标
-- 1:匹配数据 
function NationalWarCityWarMap:setUserPos(matchingData)
    local root = self.roots[1]
	local isBattle = false
	for i,v in pairs(matchingData) do
		for j, w in pairs(v) do
			if zstring.tonumber(w.userId) == zstring.tonumber(_ED.user_info.user_id) then
				isBattle = true
			end
		end
	end
	
	--攻击方
	if #matchingData > 1 and #self.armatureLeft>1 then
		if isBattle == false then
			if #matchingData == 2 and #self.armatureLeft >= 2 then
				-- 1，3
				if self.armatureLeft[1]~= nil and self.armatureRight[1] ~= nil then
					self:battleMoveMatching(self.armatureLeft[1],matchingData[1][1],1,0)
					self:showShipInfo(self.armatureLeft[1],matchingData[1][1])
					if self.armatureLeft[4]~= nil then
						self:battleMoveMatching(self.armatureLeft[4],nil,4,0)
					end
				end
				if self.armatureLeft[3] ~= nil and self.armatureRight[3] ~= nil then
					self:battleMoveMatching(self.armatureLeft[3],matchingData[2][1],3,0)
					self:showShipInfo(self.armatureLeft[3],matchingData[2][1])
					if self.armatureLeft[6]~= nil then
						self:battleMoveMatching(self.armatureLeft[6],nil,6,0)
					end
				end
			elseif #matchingData == 3 and #self.armatureLeft >= 3 then
				-- 1,3,5
				if self._myCamp ~= self._camp then
					if self.armatureLeft[1] ~= nil and self.armatureRight[1] ~= nil then
						self:battleMoveMatching(self.armatureLeft[1],matchingData[1][1],1,0)
						self:showShipInfo(self.armatureLeft[1],matchingData[1][1])
						if self.armatureLeft[4]~= nil then
							self:battleMoveMatching(self.armatureLeft[4],nil,4,0)
						end
					end
					if self.armatureLeft[3]~= nil and self.armatureRight[3] ~= nil then
						self:battleMoveMatching(self.armatureLeft[3],matchingData[3][1],3,0)
						self:showShipInfo(self.armatureLeft[3],matchingData[3][1])
						if self.armatureLeft[6]~= nil then
							self:battleMoveMatching(self.armatureLeft[6],nil,6,0)
						end
					end
					if self.armatureLeft[5]~= nil and self.armatureRight[5] ~= nil then
						self:battleMoveMatching(self.armatureLeft[5],matchingData[2][1],2,0)
						self:showShipInfo(self.armatureLeft[5],matchingData[2][1])
						if self.armatureLeft[8]~= nil then
							self:battleMoveMatching(self.armatureLeft[8],nil,8,0)
						end
					end
				else
					if self.armatureLeft[1] ~= nil and self.armatureRight[1] ~= nil then
						self:battleMoveMatching(self.armatureLeft[1],matchingData[1][1],1,0)
						self:showShipInfo(self.armatureLeft[1],matchingData[1][1])
						if self.armatureLeft[4]~= nil then
							self:battleMoveMatching(self.armatureLeft[4],nil,4,0)
						end
					end
					if self.armatureLeft[2]~= nil and self.armatureRight[2] ~= nil then
						self:battleMoveMatching(self.armatureLeft[2],matchingData[2][1],2,0)
						self:showShipInfo(self.armatureLeft[2],matchingData[2][1])
						if self.armatureLeft[5]~= nil then
							self:battleMoveMatching(self.armatureLeft[5],nil,5,0)
						end
					end
					if self.armatureLeft[3]~= nil and self.armatureRight[3] ~= nil then
						self:battleMoveMatching(self.armatureLeft[3],matchingData[3][1],3,0)
						self:showShipInfo(self.armatureLeft[3],matchingData[3][1])
						if self.armatureLeft[6]~= nil then
							self:battleMoveMatching(self.armatureLeft[6],nil,6,0)
						end
					end
				end
			end
		else
			if #matchingData == 2 and #self.armatureLeft >= 2 then
				-- 1,2
				if self.armatureLeft[1] ~= nil and self.armatureRight[1] ~= nil then
					self:battleMoveMatching(self.armatureLeft[1],matchingData[1][1],1,0)
					self:showShipInfo(self.armatureLeft[1],matchingData[1][1])
					if self.armatureLeft[4]~= nil then
						self:battleMoveMatching(self.armatureLeft[4],nil,4,0)
					end
				end
				self:battleMoveMatching(self.armatureLeft[2],matchingData[2][1],2,0)
				self:showShipInfo(self.armatureLeft[2],matchingData[2][1])
				if self.armatureLeft[5]~= nil then
					self:battleMoveMatching(self.armatureLeft[5],nil,5,0)
				end
			elseif #matchingData == 3 and #self.armatureLeft >= 3 then
				-- 1，2，3
				if self.armatureLeft[1]~= nil and self.armatureRight[1] ~= nil then
					self:battleMoveMatching(self.armatureLeft[1],matchingData[1][1],1,0)
					self:showShipInfo(self.armatureLeft[1],matchingData[1][1])
					if self.armatureLeft[4]~= nil then
						self:battleMoveMatching(self.armatureLeft[4],nil,4,0)
					end
				end
				self:battleMoveMatching(self.armatureLeft[2],matchingData[2][1],2,0)
				self:showShipInfo(self.armatureLeft[2],matchingData[2][1])
				if self.armatureLeft[5]~= nil then
					self:battleMoveMatching(self.armatureLeft[5],nil,5,0)
				end
				if self.armatureLeft[3] ~= nil and self.armatureRight[3] ~= nil then
					self:battleMoveMatching(self.armatureLeft[3],matchingData[3][1],3,0)
					self:showShipInfo(self.armatureLeft[3],matchingData[3][1])
					if self.armatureLeft[6]~= nil then
						self:battleMoveMatching(self.armatureLeft[6],nil,6,0)
					end
				end
			end
		end
	elseif #matchingData == 1 and #self.armatureLeft>1 then
		if isBattle == false then
			-- 1
			if self.armatureLeft[1]~= nil then
				self:battleMoveMatching(self.armatureLeft[1],matchingData[1][1],1,0)
				self:showShipInfo(self.armatureLeft[1],matchingData[1][1])
				if self.armatureLeft[4]~= nil then
					self:battleMoveMatching(self.armatureLeft[4],nil,4,0)
				end
			end
		else
			-- 2
			if self.armatureLeft[2]~= nil then
				self:battleMoveMatching(self.armatureLeft[2],matchingData[1][1],2,0)
				self:showShipInfo(self.armatureLeft[2],matchingData[1][1])
				if self.armatureLeft[5]~= nil then
					self:battleMoveMatching(self.armatureLeft[5],nil,5,0)
				end
			end
		end
	end
	
	--防守方
	if #matchingData > 1 and #self.armatureRight>1 then
		if isBattle == false then
			if #matchingData == 2 and #self.armatureRight >= 2 then
				-- 1，3
				if self.armatureRight[1] ~= nil and self.armatureLeft[1] ~= nil then
					self:battleMoveMatching(self.armatureRight[1],matchingData[1][2],1,1)
					self:showShipInfo(self.armatureRight[1],matchingData[1][2],true)
					if self.armatureRight[4]~= nil then
						self:battleMoveMatching(self.armatureRight[4],nil,4,1)
					end
				end
				if self.armatureRight[3]~= nil and self.armatureLeft[3] ~= nil then
					self:battleMoveMatching(self.armatureRight[3],matchingData[2][2],3,1)
					self:showShipInfo(self.armatureRight[3],matchingData[2][2],true)
					if self.armatureRight[6]~= nil then
						self:battleMoveMatching(self.armatureRight[6],nil,6,1)
					end
				end
			elseif #matchingData == 3 and #self.armatureRight >= 3 then
				-- 1,3,5
				if self._myCamp == self._camp then--如果我是防
					if self.armatureRight[1]~= nil and self.armatureLeft[1] ~= nil then
						self:battleMoveMatching(self.armatureRight[1],matchingData[1][2],1,1)
						self:showShipInfo(self.armatureRight[1],matchingData[1][2],true)
						if self.armatureRight[4]~= nil then
							self:battleMoveMatching(self.armatureRight[4],nil,4,1)
						end
					end
					if self.armatureRight[3]~= nil and self.armatureLeft[3] ~= nil then
						self:battleMoveMatching(self.armatureRight[3],matchingData[3][2],3,1)
						self:showShipInfo(self.armatureRight[3],matchingData[3][2],true)
						if self.armatureRight[6]~= nil then
							self:battleMoveMatching(self.armatureRight[6],nil,6,1)
						end
					end
					if self.armatureRight[5]~= nil and self.armatureLeft[5] ~= nil then
						self:battleMoveMatching(self.armatureRight[5],matchingData[2][2],2,1)
						self:showShipInfo(self.armatureRight[5],matchingData[2][2],true)
						if self.armatureRight[8]~= nil then
							self:battleMoveMatching(self.armatureRight[8],nil,8,1)
						end
					end
				else
					if self.armatureRight[1]~= nil and self.armatureLeft[1] ~= nil then
						self:battleMoveMatching(self.armatureRight[1],matchingData[1][2],1,1)
						self:showShipInfo(self.armatureRight[1],matchingData[1][2],true)
						if self.armatureRight[4]~= nil then
							self:battleMoveMatching(self.armatureRight[4],nil,4,1)
						end
					end
					if self.armatureRight[2]~= nil and self.armatureLeft[2] ~= nil then
						self:battleMoveMatching(self.armatureRight[2],matchingData[2][2],2,1)
						self:showShipInfo(self.armatureRight[2],matchingData[2][2],true)
						if self.armatureRight[5]~= nil then
							self:battleMoveMatching(self.armatureRight[5],nil,5,1)
						end
					end
					if self.armatureRight[3]~= nil and self.armatureLeft[3] ~= nil then
						self:battleMoveMatching(self.armatureRight[3],matchingData[3][2],3,1)
						self:showShipInfo(self.armatureRight[3],matchingData[3][2],true)
						if self.armatureRight[6]~= nil then
							self:battleMoveMatching(self.armatureRight[6],nil,6,1)
						end
					end
				end
			end
		else
			if #matchingData == 2 and #self.armatureRight >= 2 then
				-- 1,2
				if self.armatureRight[1]~= nil and self.armatureLeft[1] ~= nil then
					self:battleMoveMatching(self.armatureRight[1],matchingData[1][2],1,1)
					self:showShipInfo(self.armatureRight[1],matchingData[1][2],true)
					if self.armatureRight[4]~= nil then
						self:battleMoveMatching(self.armatureRight[4],nil,4,1)
					end
				end
				self:battleMoveMatching(self.armatureRight[2],matchingData[2][2],2,1)
				self:showShipInfo(self.armatureRight[2],matchingData[2][2],true)
				if self.armatureRight[5]~= nil then
					self:battleMoveMatching(self.armatureRight[5],nil,5,1)
				end
			elseif #matchingData == 3 and #self.armatureRight >= 3 then
				-- 1，2，3
				if self.armatureRight[1]~= nil and self.armatureLeft[1] ~= nil then
					self:battleMoveMatching(self.armatureRight[1],matchingData[1][2],1,1)
					self:showShipInfo(self.armatureRight[1],matchingData[1][2],true)
					if self.armatureRight[4]~= nil then
						self:battleMoveMatching(self.armatureRight[4],nil,4,1)
					end
				end
				self:battleMoveMatching(self.armatureRight[2],matchingData[2][2],2,1)
				self:showShipInfo(self.armatureRight[2],matchingData[2][2],true)
				if self.armatureRight[5]~= nil then
					self:battleMoveMatching(self.armatureRight[5],nil,5,1)
				end
				if self.armatureRight[3]~= nil and self.armatureLeft[3] ~= nil then
					self:battleMoveMatching(self.armatureRight[3],matchingData[3][2],3,1)
					self:showShipInfo(self.armatureRight[3],matchingData[3][2],true)
					if self.armatureRight[6]~= nil then
						self:battleMoveMatching(self.armatureRight[6],nil,6,1)
					end
				end
			end
		end
	elseif #matchingData == 1 and #self.armatureRight>1 then
		if isBattle == false then
			-- 1
			if self.armatureRight[1]~= nil then
				self:battleMoveMatching(self.armatureRight[1],matchingData[1][2],1,1)
				self:showShipInfo(self.armatureRight[1],matchingData[1][2],true)
				if self.armatureRight[4]~= nil then
					self:battleMoveMatching(self.armatureRight[4],nil,4,1)
				end
			end
		else
			-- 2
			if self.armatureRight[2]~= nil then
				self:battleMoveMatching(self.armatureRight[2],matchingData[1][2],2,1)
				self:showShipInfo(self.armatureRight[2],matchingData[1][2],true)
				if self.armatureRight[5]~= nil then
					self:battleMoveMatching(self.armatureRight[5],nil,5,1)
				end
			end
		end
	end
	
	-- 进入结算界面
	if isBattle == true then
		local matchingDataInfo = nil
		if #matchingData>1 then
			matchingDataInfo=matchingData[2]
		else
			matchingDataInfo=matchingData[1]
		end
		local attackOrDefense = 0
		if self._myCamp ~= self._camp then--如果我是攻
			attackOrDefense = 0
		else
			attackOrDefense = 1
		end
		if self.isUpdateBattleField ~= zstring.tonumber(_ED.warfareCityInfo[zstring.tonumber(self.city_id)].camp) then
		else
			state_machine.excute("national_war_city_war_billing_window_open",0,{self,matchingDataInfo,self.city_id,attackOrDefense})
		end
		state_machine.excute("national_war_city_war_billing_refresh",0,"")
		
		local outcome = 0
		-- if self._myCamp ~= self._camp then--如果我是攻
			-- outcome = zstring.tonumber(matchingDataInfo[1].outcome)
		-- else
			outcome = zstring.tonumber(matchingDataInfo[1].outcome)
		-- end

		if outcome == 0 then
			self:battlefieldHide()
		end
	end
end

--显示战场
function NationalWarCityWarMap:battlefieldShow()
	local root = self.roots[1]
	for i=1, 9 do
		if self.armatureLeft~= nil then
			if self.armatureLeft[i]~= nil then
				self.armatureLeft[i]:setVisible(true)
			end
		end
		
		if self.armatureRight~= nil then
			if self.armatureRight[i]~= nil then
				self.armatureRight[i]:setVisible(true)
			end
		end
	end
end

--隐藏战场
function NationalWarCityWarMap:battlefieldHide()
	local root = self.roots[1]
	for i=1, 9 do
		if self.armatureLeft~= nil then
			if self.armatureLeft[i]~= nil then
				self.armatureLeft[i]:setVisible(false)
			end
		end
		if self.armatureRight~= nil then
			if self.armatureRight[i]~= nil then
				self.armatureRight[i]:setVisible(false)
			end
		end
	end
end

function NationalWarCityWarMap:move(move_pos, vector,armature)
    local at = CC_POSITIONS_TO_DEGREES(cc.p(move_pos), vector)
    local actionIndex = math.modf(at / (360.0 / 25.0))
    if actionIndex < 0 then
        actionIndex = -1 * actionIndex + 13
    end
    local actionIndex = actionIndex * _spine_sprite_animation_team_count + 1
    self.move_index = actionIndex
    csb.animationChangeToAction(armature, actionIndex, actionIndex, true)
    state_machine.excute("national_war_city_war_is_move",0,{1})
    
end

function NationalWarCityWarMap:openCityWarMayUIWindow()
	state_machine.excute("national_war_city_war_map_ui_window_open",0,{self,self.city_id})
end

function NationalWarCityWarMap:showShipInfo(list,datasInfo,mirroring)
	if datasInfo == nil then
		datasInfo = {
			userId = _ED.user_info.user_id,
			userName = _ED.user_info.user_name,
			gender = _ED.user_info.user_gender,
			country = _ED.user_info.user_force,
		}
	end
	
	local cell_rankme = state_machine.excute("national_war_city_war_hero_cell_create",0,{list,datasInfo})
	list:addChild(cell_rankme)
	if mirroring~= nil and mirroring == true then
		cell_rankme:setScaleX(-1)
	end
	
end

function NationalWarCityWarMap:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.natinalwar_battle_map)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
	
	self:openCityWarMayUIWindow()
	self:cityWarInfo()
	self:initUserPos()
	self.isUpdateBattleField = self._camp
	-- self:setUserPos()
	playBgm(formatMusicFile("background", zstring.tonumber(config_res.campaign.nationalwar.music.background.warCityWarMap)))
end

function NationalWarCityWarMap:onUpdate(dt)
	self.updateTime = self.updateTime + dt
	if self.updateTime >= 5 then
		local function responseCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if _ED.war_user_dead == false then
					--刷新的状态机
					state_machine.excute("national_war_city_war_update_immediate",0,"")
				else
					-- state_machine.excute("national_war_record_window_open",0,{self.city_id})
					state_machine.excute("national_war_city_war_map_ui_close",0,"")
					state_machine.excute("national_war_map_return_home_city",0,"")	
				end
			end
		end
		protocol_command.refush_city_info.param_list = self.city_id
		NetworkManager:register(protocol_command.refush_city_info.code, nil, nil, nil,nil, responseCallback, false, nil)
		self.updateTime = 0
	end
	
	if self.isUpdateBattleField ~= -1 and (self.isUpdateBattleField ~= zstring.tonumber(_ED.warfareCityInfo[zstring.tonumber(self.city_id)].camp))  then
		state_machine.excute("national_war_city_war_occupied_billing_window_open",0,{self.city_id})
		self.isUpdateBattleField = -1
	end
	
end

function NationalWarCityWarMap:init(params)
	self.city_id = params[1]
    self:onInit()
    return self
end

function NationalWarCityWarMap:onExit()
    state_machine.remove("national_war_city_war_battle_move")  
    state_machine.remove("national_war_city_war_battle_request")  
    state_machine.remove("national_war_city_war_battle_attack_reset")  
    state_machine.remove("national_war_city_war_battle_keep_reset")  
    state_machine.remove("national_war_city_war_occupied_refresh")  
    state_machine.remove("national_war_city_war_billing_refresh")  
    state_machine.remove("national_war_city_war_play_tactics_animation")  
    state_machine.remove("national_war_city_war_update_immediate")  
    state_machine.remove("national_war_city_war_scenes_animation_end")  
end
