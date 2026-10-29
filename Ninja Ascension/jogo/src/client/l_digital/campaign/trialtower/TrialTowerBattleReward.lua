-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双 战斗结束奖励结算界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
TrialTowerBattleReward = class("TrialTowerBattleRewardClass", Window)

function TrialTowerBattleReward:ctor()
	self.super:ctor()
	self.roots = {}
	self.rewardList = nil
	self._offset = 32
	app.load("client.battle.BattleLevelUp")
end	

function TrialTowerBattleReward:onEnterTransitionFinish()
	-- Fury: el combate de las torres diaria/semanal se cierra en FuryTowers.lua.
	if _ED.fury_tower_battle ~= nil and FuryTowers_battleEnd ~= nil and FuryTowers_battleEnd(true) then
		return
	end
	-- res\cocostudio\campaign\TrialTower\victory_in_battle_1.csb

	local csbvictory = csb.createNode("campaign/TrialTower/victory_in_battle_1.csb")
	self:addChild(csbvictory)
	local root = csbvictory:getChildByName("root")
	table.insert(self.roots, root)
	local bTouch = false
	local action = csb.createTimeline("campaign/TrialTower/victory_in_battle_1.csb")
	playEffect(formatMusicFile("effect", 9996))
	self.rewardList = getSceneReward(38)

	--计算星数
	local index = 0
    local datas = {}
	local DeadNumber = 0
	for i, v in pairs(_ED._fightModule.attackObjects) do
        local shipInfo = {}
        shipInfo.healthPoint = v.healthPoint
        shipInfo.skillPoint = v.skillPoint
        shipInfo.id = v.id
        table.insert(datas, shipInfo) 
    end

	for i,v in pairs(_ED.user_formetion_status) do
		if tonumber(v) > 0 then
	    	local isDead = true
	    	local shipInfo = {}
	    	for j=1, #datas do
	    		if tonumber(v) == tonumber(datas[j].id) then
	    			isDead = false
	    		end
	    	end
	    	if isDead == true then
	    		DeadNumber = DeadNumber + 1
	    	end
    	end
    end

	local npcCurStar = 3   --星级，现在临时给3
	if DeadNumber == 0 then
		npcCurStar = 3
	elseif DeadNumber > 1 then
		npcCurStar = 1
	elseif DeadNumber == 1 then
		npcCurStar = 2
	end

	for i=1,3 do
		local Image_star = ccui.Helper:seekWidgetByName(root,"Image_star_"..i)
		-- DSC重塑
		if __lua_project_id == __lua_project_l_digital then 
			local Text_star = ccui.Helper:seekWidgetByName(root,"Text_star_"..i)
			if Text_star then 
				Image_star = Text_star
			end
		end
		if i == npcCurStar then
			Image_star:setVisible(true)
		else
			Image_star:setVisible(false)
		end
	end

	--星级
   	local Panel_star_dh = ccui.Helper:seekWidgetByName(root,"Panel_star_dh") 
	local a_name = ""
	local cx_name = ""
	if npcCurStar == 1 then
		a_name = "1star"
		cx_name = "1star_cx"
	elseif npcCurStar == 2 then
		a_name = "2star"
		cx_name = "2star_cx"
	elseif npcCurStar == 3 then
		a_name = "3star"
		cx_name = "3star_cx"
    else    
        a_name = "3star"
        cx_name = "3star_cx"
	end
   	local jsonFile = "sprite/spirte_zaxing.json"
    local atlasFile = "sprite/spirte_zaxing.atlas"
    local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, a_name, true, nil)
    animation2.animationNameList = {a_name,cx_name}
	sp.initArmature(animation2, false)

    local function onFrameEventBullet(bone,evt,originFrameIndex,currentFrameIndex)
        if evt ~= nil and #evt > 0 then
            if evt == "ding" then
                playEffect(formatMusicFile("effect", 9989))
            end
        end
    end
	local function changeActionCallback( armatureBack )
	end
	animation2._invoke = changeActionCallback
    animation2:getAnimation():setFrameEventCallFunc(onFrameEventBullet)
	animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	csb.animationChangeToAction(animation2, 0, 1, false)
    Panel_star_dh:addChild(animation2)

    --基础积分
    local addition_data = zstring.split(dms.string(dms["play_config"], 32, play_config.param),"|")
	local addition_info = 1 
	for i,v in pairs(addition_data) do
		local addition = zstring.split(v,",")
		if tonumber(_ED.vip_grade) >= tonumber(addition[1]) then
			addition_info = 1+tonumber(addition[2])/100
		end
	end
	addition_info = addition_info * self._offset
	local Text_jifen_1 = ccui.Helper:seekWidgetByName(root,"Text_jifen_1") 
	Text_jifen_1:setString(math.floor(_ED.three_kingdoms_battle_integral*addition_info/self._offset))

	--得星倍率
	local Text_beilv = ccui.Helper:seekWidgetByName(root,"Text_beilv") 
	local Magnification = zstring.split(dms.string(dms["play_config"], 25, play_config.param), ",")
	local beivNum = Magnification[npcCurStar] * self._offset
	Text_beilv:setString(beivNum/self._offset)

	--获得积分
	local Text_jifen_2 = ccui.Helper:seekWidgetByName(root,"Text_jifen_2") 
	
	-- Text_jifen_2:setString(math.floor(_ED.three_kingdoms_battle_integral*addition_info*tonumber(_ED.trial_star_Magnification)))
	Text_jifen_2:setString(math.floor(_ED.three_kingdoms_battle_integral*addition_info*tonumber(beivNum/self._offset)/self._offset))
	
	local function backPlotScene(sender, eventType)				--点击确定
		if eventType == ccui.TouchEventType.ended then
			
			local function responseGetServerListCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					if response.node ~= nil and response.node.roots[1] ~= nil then
						fwin:close(instance)
						fwin:close(fwin:find("BattleSceneClass"))
						fwin:removeAll()
						app.load("client.home.Menu")
						fwin:open(Menu:new(), fwin._taskbar)
						app.load("client.l_digital.campaign.trialtower.TrialTower")
						fwin:open(TrialTower:new(), fwin._ui) 
					end	
                end
            end
            --记录战斗结算

            local strs = ""
            local index = 0
            local datas = {}

            for i, v in pairs(_ED._fightModule.attackObjects) do
                local shipInfo = {}
                shipInfo.healthPoint = v.healthPoint
                shipInfo.skillPoint = v.skillPoint
                shipInfo.maxHp = zstring.tonumber(shipInfo.healthPoint)/zstring.tonumber(_ED.user_ship[""..v.id].ship_health)*100
                shipInfo.id = v.id
                table.insert(datas, shipInfo) 
            end

            for i,v in pairs(_ED.user_formetion_status) do
            	if tonumber(v) > 0 then
	            	local isDead = true
	            	local shipInfo = {}
	            	for j=1, #datas do
	            		if tonumber(v) == tonumber(datas[j].id) then
	            			isDead = false
	            		end
	            	end
	            	if isDead == true then
	            		shipInfo.healthPoint = 0
		                shipInfo.skillPoint = 0
		                shipInfo.maxHp = 0
		                shipInfo.id = v
		                table.insert(datas, shipInfo) 
	            	end
            	end
            end

            for j, w in pairs(_ED.user_try_ship_infos) do
            	local isData = nil
        		for i=1, #datas do
        			if tonumber(datas[i].id) == tonumber(w.id) then
        				isData = datas[i]
        			end
        		end
        		if isData ~= nil then
        			local percentage = 0
        			--每次战斗胜利后加血和怒
        			if tonumber(isData.healthPoint) > 0 then
        				local addAll = zstring.split(dms.string(dms["play_config"], 52, play_config.param), ",")
        				local fightParams = zstring.split(dms.string(dms["fight_config"], 5 ,user_config.param),",")
        				isData.healthPoint = zstring.tonumber(isData.healthPoint) + zstring.tonumber(_ED.user_ship[""..isData.id].ship_health)*(addAll[1]/100)
        				if zstring.tonumber(isData.healthPoint) > zstring.tonumber(_ED.user_ship[""..isData.id].ship_health) then
        					isData.healthPoint = zstring.tonumber(_ED.user_ship[""..isData.id].ship_health)
        					percentage = 100
        				else
        					percentage = (zstring.tonumber(isData.healthPoint)/zstring.tonumber(_ED.user_ship[""..isData.id].ship_health)*100)
        				end
        				isData.skillPoint = zstring.tonumber(isData.skillPoint) + zstring.tonumber(fightParams[4])*(addAll[2]/100)
        				if zstring.tonumber(isData.skillPoint) > zstring.tonumber(fightParams[4]) then
        					isData.skillPoint = zstring.tonumber(fightParams[4])
        				end
        			end
        			------------------------------------------------
            		if strs ~= "" then
            			strs = strs.."|"..isData.id..":"..isData.healthPoint..","..isData.skillPoint..","..percentage
            		else
            			strs = isData.id..":"..isData.healthPoint..","..isData.skillPoint..","..percentage
            		end
            	else
            		local percentage = (zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
        			--每次战斗胜利后加血和怒
        			if tonumber(_ED.user_ship[""..w.id].ship_grade) >= 10 then
	        			if tonumber(w.newHp) > 0 then
	        				local addAll = zstring.split(dms.string(dms["play_config"], 52, play_config.param), ",")
	        				local fightParams = zstring.split(dms.string(dms["fight_config"], 5 ,user_config.param),",")
	        				w.newHp = zstring.tonumber(w.newHp) + zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*(addAll[1]/100)
	        				if zstring.tonumber(w.newHp) > zstring.tonumber(_ED.user_ship[""..w.id].ship_health) then
	        					w.newHp = zstring.tonumber(_ED.user_ship[""..w.id].ship_health)
	        					percentage = 100
	        				else
	        					percentage = (zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
	        				end
	        				w.newanger = zstring.tonumber(w.newanger) + zstring.tonumber(fightParams[4])*(addAll[2]/100)
	        				if zstring.tonumber(w.newanger) > zstring.tonumber(fightParams[4]) then
	        					w.newanger = zstring.tonumber(fightParams[4])
	        				end
	        			end
        			end
        			------------------------------------------------------------
            		if strs ~= "" then
            			strs = strs.."|"..w.id..":"..w.newHp..","..w.newanger..","..percentage
            		else
            			strs = w.id..":"..w.newHp..","..w.newanger..","..percentage
            		end
        		end
            end



            local newBuff = ""
            for j, w in pairs(_ED.three_kingdoms_view.atrribute) do
                local buff_info = zstring.split(w[1] ,":")
                local shipId = tonumber(buff_info[2])
                if shipId < 0 then
                    --重新记录buff
                    if j == 1 then
                        newBuff = w[1]..","..w[2]
                    else
                        newBuff = newBuff .."|"..w[1]..","..w[2]
                    end
                end
            end

            local Magnification = zstring.split(dms.string(dms["play_config"], 25, play_config.param), ",")
            local formationInfo = ""
            for i, v in pairs(_ED.user_formetion_status) do
                local ship = _ED.user_ship[""..v]
                if ship ~= nil then
                    if formationInfo == "" then
                        formationInfo = ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                    else
                        formationInfo = formationInfo.."|"..ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
                    end
                else
                    if formationInfo == "" then
                        formationInfo = "0,0,0,0"
                    else
                        formationInfo = formationInfo.."|".."0,0,0,0"
                    end
                end
            end

            protocol_command.three_kingdoms_launch.param_list = "54".."\r\n".._ED._current_scene_id.."\r\n".._ED.trial_scene_npc_id.."\r\n"..math.floor(npcCurStar*tonumber(_ED.trial_star_Magnification)).."\r\n".."1".."\r\n"..
            _ED.integral_current_index.."\r\n"..strs.."\r\n".."".."\r\n"..newBuff.."\r\n"..math.floor(_ED.three_kingdoms_battle_integral*(addition_info/self._offset)*tonumber(beivNum/self._offset)).."\r\n"..formationInfo
            NetworkManager:register(protocol_command.three_kingdoms_launch.code, nil, nil, nil, self, responseGetServerListCallback, false, nil)
            --清除记录
		    cc.UserDefault:getInstance():setStringForKey(getKey("GuanBattleIndex"), "-1")
		    cc.UserDefault:getInstance():flush()
		elseif eventType == ccui.TouchEventType.began then
			playEffect(formatMusicFile("button", 1))		--加入按钮音效
		end
	end

	function blinkOutCallback(sender)
		ccui.Helper:seekWidgetByName(root, "Panel_8"):addTouchEventListener(backPlotScene)
	end

	root:runAction(cc.Sequence:create(
		cc.DelayTime:create(1.5),
		cc.CallFunc:create(blinkOutCallback)
	))

	
	

	-- --找过关条件
	-- local layerCount = tonumber(_ED.three_kingdoms_view.current_floor)			-- 第几层
	-- local currentIndex = tonumber(_ED.three_kingdoms_view.current_npc_pos)		--当前挑战位置
	
	-- if currentIndex == 0 then
	-- 	currentIndex = 2 
	-- 	layerCount = layerCount -1
	-- else
	-- 	currentIndex = currentIndex - 1 
	-- end

	-- local npcList = dms.string(dms["three_kingdoms_config"], tonumber(layerCount), three_kingdoms_config.npc_id)
	-- local datas = zstring.split(npcList , ",")  	
	-- local npcMID = tonumber(datas[currentIndex+1])
	-- local achievementIndex = dms.string(dms["npc"], npcMID, npc.get_star_condition)	--通关条件-从npc取找成就模板
	-- local GuanqiaCondition = dms.string(dms["achievement_mould"], achievementIndex, achievement_mould.achievement_describe)
	-- ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(tipStringInfo_trialTower[14]..GuanqiaCondition)
	
end


function TrialTowerBattleReward:init(fight_type,attackObjects)
	self._fight_type = fight_type
	self.attackObjects = attackObjects
end

function TrialTowerBattleReward:onExit()

end
-- END
-- ----------------------------------------------------------------------------------------------------