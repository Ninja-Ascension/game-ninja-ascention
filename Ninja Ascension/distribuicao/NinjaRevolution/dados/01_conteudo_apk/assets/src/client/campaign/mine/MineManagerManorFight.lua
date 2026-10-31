----------------------------------------------------------------------------------------------------
-- 说明：点击可以攻打的领地
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MineManagerManorFight = class("MineManagerManorFightClass", Window)
    
function MineManagerManorFight:ctor()
    self.super:ctor()
    self.roots = {}
	self.mouldId = nil
	app.load("client.battle.BattleStartEffect")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.campaign.mine.MineAttackTerritoryRole")
	 app.load("client.battle.fight.FightEnum")
    -- Initialize MineManager page state machine.
    local function init_mine_manager_manor_fight_terminal()
	
		--返回
		local mine_manager_manor_fight_back_terminal = {
            _name = "mine_manager_manor_fight_back",
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
		--开始挑战
		local mine_manager_manor_fight_start_terminal = {
            _name = "mine_manager_manor_fight_start",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:challenge(params._datas._id)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(mine_manager_manor_fight_back_terminal)
		state_machine.add(mine_manager_manor_fight_start_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_mine_manager_manor_fight_terminal()
end


function  MineManagerManorFight:challenge(id)
	local function responseOverCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			
			fwin:close(response.node)
			fwin:close(fwin:find("MineManagerClass"))
			
			local bse = BattleStartEffect:new()
			bse:init(_enum_fight_type._fight_type_103)
			fwin:open(bse, fwin._windows)
		end
	end

	
	local function launchBattle()
		protocol_command.manor_fight.param_list = id
		NetworkManager:register(protocol_command.manor_fight.code, nil, nil, nil, instance, responseOverCallback,true)
	end
	
	if missionIsOver() == false then
		launchBattle()
	else
		if __lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_koone
		then
			local function responseCampPreferenceCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					
					if _ED.camp_preference_info ~= nil and _ED.camp_preference_info.count > 0 then
						app.load("client.formation.FormationChangeMakeWar") 
						
						local makeWar = FormationChangeMakeWar:new()
						
						makeWar:init(launchBattle)
						
						fwin:open(makeWar, fwin._ui)
					else
						launchBattle()
					end
				end
			end
			_ED._battle_init_type = "0"
			local rid = self.npc_id
			protocol_command.camp_preference.param_list = ""..rid.."\r\n".."0"
			NetworkManager:register(protocol_command.camp_preference.code, nil, nil, nil, nil, responseCampPreferenceCallback, false, nil)
		else
			launchBattle()
		end
	end
end


function MineManagerManorFight:getCityBackGroundImage(index)
	local img = "images/ui/play/minemanager/bg_%d.jpg"
	return string.format(img,index)
end

--道具
function MineManagerManorFight:getPropCell(mid, num,mtype)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.count = num
	cellConfig.isShowName = true
	cellConfig.isDebris = true
	cellConfig.mouldType = mtype
	cellConfig.touchShowType = 1
	cell:init(cellConfig)
	return cell
end

function MineManagerManorFight:onUpdateDraw()
	local root = self.roots[1]
	local bgPanel = ccui.Helper:seekWidgetByName(root, "Panel_bg_10")
	local npcPanel = ccui.Helper:seekWidgetByName(root, "Panel_38")
	local npcName = ccui.Helper:seekWidgetByName(root, "Text_name_7_18")
	local npcSpeech = ccui.Helper:seekWidgetByName(root, "Text_486_16")
	local describeText = ccui.Helper:seekWidgetByName(root, "Text_31")
	local needPowerText = ccui.Helper:seekWidgetByName(root, "Text_34")
	local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_103")
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_101")
	
	-- 设置城池背景-------------------------------------------------------------------------------
	bgPanel:setBackGroundImage(self:getCityBackGroundImage(self.mouldId))

	-- 设置城池名称-------------------------------------------------------------------------------
	nameText:setString(dms.string(dms["manor_mould"], self.mouldId, manor_mould.manor_name))
	
	-- 设置城池描述-------------------------------------------------------------------------------
	describeText:setString(dms.string(dms["manor_mould"], self.mouldId, manor_mould.describe))
	
	-- 设置胜利奖励-------------------------------------------------------------------------------
	local winnerId = dms.string(dms["manor_mould"], self.mouldId, manor_mould.win_reward)
	local reward_gold = dms.int(dms["scene_reward"], winnerId, scene_reward.reward_gold)
	local library = dms.string(dms["scene_reward"], winnerId, scene_reward.reward_prop)
	local reward_silver = dms.int(dms["scene_reward"], winnerId, scene_reward.reward_silver)
	local reward_jade = dms.int(dms["scene_reward"], winnerId, scene_reward.reward_jade)
	
	local rewardProp = {}
	
	if string.len(library) > 0 then
		rewardProp = zstring.split(library,"|")
	end
	
	if reward_silver> 0 then
		local rewardGoldCell = self:getPropCell(-1,reward_silver,1)
		rewardListView:addChild(rewardGoldCell)
	end
	
	if reward_gold> 0 then
		local rewardGoldCell = self:getPropCell(-1,reward_gold,2)
		rewardListView:addChild(rewardGoldCell)
	end

	if reward_jade> 0 then
		local rewardGoldCell = self:getPropCell(-1,reward_jade,5)
		rewardListView:addChild(rewardGoldCell)
	end
	
	
	for i,v in pairs(rewardProp) do
	
		local rewardPropInfo = zstring.split(v, ",")
		if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
			local reawrdID = tonumber(rewardPropInfo[2])
			local rewardNum = tonumber(rewardPropInfo[1])
			local cell = self:getPropCell(reawrdID,rewardNum,6)
			rewardListView:addChild(cell)
		end
	end

	-- 设置战力-------------------------------------------------------------------------------
	local recommendFight = dms.int(dms["manor_mould"], self.mouldId, manor_mould.recommend_fight)
	if recommendFight >= 10000 then
		recommendFight = math.floor(recommendFight / 10000).._string_piece_info[150]
	end
	needPowerText:setString(recommendFight)

	-- 设置守将名称-------------------------------------------------------------------------------
	local npc_id = dms.int(dms["manor_mould"], self.mouldId, manor_mould.npc_id)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local name_info = ""
		local name_data = zstring.split(dms.string(dms["npc"], npc_id, npc.npc_name), "|")
		for i, v in pairs(name_data) do
			local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
			name_info = name_info..word_info[3]
		end
		npcName:setString(name_info)
	else
		npcName:setString(dms.string(dms["npc"], npc_id, npc.npc_name))
	end
	self.npc_id = npc_id
	-- 设置守将言语-------------------------------------------------------------------------------
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local word_info = dms.element(dms["word_mould"], zstring.tonumber(dms.string(dms["npc"], npc_id, npc.sign_msg)))
        npcSpeech:setString(word_info[3])   
    else
    	npcSpeech:setString(dms.string(dms["npc"], npc_id, npc.sign_msg))   
    end

	-- 设置守将形象-------------------------------------------------------------------------------
	local npc_id = dms.int(dms["manor_mould"],self.mouldId, manor_mould.npc_id)
	npcPanel:addChild(self:createRole(npc_id))
	
	-- 设置守将出场-------------------------------------------------------------------------------
	self._role_action:play("window_open", false)
	
	-- 设置顶部属性栏-------------------------------------------------------------------------------
	local userinfo = EquipPlayerInfomation:new()
	fwin:open(userinfo,fwin._view)
	self.userinfo = userinfo
end

function MineManagerManorFight:onEnterTransitionFinish()

    local csbMineManagerManorFight = csb.createNode("campaign/MineManager/attack_territory_in.csb")
	self.csbMineManagerManorFight = csbMineManagerManorFight
	self:addChild(csbMineManagerManorFight)
   	local root = csbMineManagerManorFight:getChildByName("root")
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("campaign/MineManager/attack_territory_in.csb")
    csbMineManagerManorFight:runAction(action)
	self._role_action = action
	
		
	-- 设置返回-------------------------------------------------------------------------------
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_32"), nil, 
	{
		func_string = [[state_machine.excute("mine_manager_manor_fight_back", 0, "mine_manager_manor_fight_back.'")]],
		isPressedActionEnabled = true,
	}, nil, 2)
	
		
	-- 设置挑战-------------------------------------------------------------------------------
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_31"), nil, 
	{
		terminal_name = "mine_manager_manor_fight_start", 
		terminal_state = 0, 
		_id = self.mouldId,
		_instance = self,
		isPressedActionEnabled = true
	}, nil, 0)
	
	self:onUpdateDraw()
end

function MineManagerManorFight:init(id)
	self.mouldId = id
end
function MineManagerManorFight:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		fwin:close(self.userinfo)
	end
end
function MineManagerManorFight:onExit()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		fwin:close(self.userinfo)
	end
	
	state_machine.remove("mine_manager_manor_fight_back")
	state_machine.remove("mine_manager_manor_fight_start")
end

function MineManagerManorFight:createCell()
	local cell = MineManagerManorFight:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function MineManagerManorFight:createRole(npcID)
	-- 红警时刻暂时屏蔽
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		return
	end
	local cell = MineAttackTerritoryRole:createCell()
	cell:initNPC(npcID)
	return cell
end