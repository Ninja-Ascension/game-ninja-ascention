-- ----------------------------------------------------------------------------------------------------
-- 说明：围剿叛军npc信息界面
-- 创建时间	2015-03-06
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

BetrayArmyBattleScene = class("BetrayArmyBattleSceneClass", Window)
    
function BetrayArmyBattleScene:ctor()
    self.super:ctor()
    self.roots = {}
	self.npcExample = nil
	self.npcCell = nil
	self.index = 0
	app.load("client.cells.campaign.betray_army_npc_cell")
	app.load("client.battle.BattleStartEffect")
	app.load("client.battle.fight.FightEnum")
	-- self.rebelArmyExample = nil 
	-- app.load("client.packs.treasure.TreasureStorage")
	
    -- Initialize BetrayArmyBattleScene page state machine.
    local function init_world_boss_terminal()
	
		--	关闭npc二级信息界面
		local betray_army_battle_scene_button_close_terminal = {
            _name = "betray_army_battle_scene_button_close",
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
		-- 打开布阵
		local betray_army_battle_scene_formation_change_button_terminal = {
            _name = "betray_army_battle_scene_formation_change_button",
            _init = function (terminal)
				app.load("client.formation.FormationChange") 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local formationChangeWindow = FormationChange:new()
				fwin:open(formationChangeWindow, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 购买出击令
		local betray_army_battle_scene_buy_prop_button_terminal = {
            _name = "betray_army_battle_scene_buy_prop_button",
            _init = function (terminal)
				app.load("client.cells.prop.prop_buy_prompt")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local _dispatchID = tonumber(instance.dispatchID)
				local buyProp = PropBuyPrompt:new()
				buyProp:init(_dispatchID, 3)
				fwin:open(buyProp, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 刷新页面状态
		local betray_army_battle_scene_refresh_state_terminal = {
            _name = "betray_army_battle_scene_refresh_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if fwin:find("BetrayArmyBattleSceneClass") ~= nil  then
					instance:onUpdateDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 攻击
		local betray_army_battle_scene_common_attack_button_terminal = {
            _name = "betray_army_battle_scene_common_attack_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:challenge(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 改变状态
		local betray_army_battle_scene_state_update_terminal = {
            _name = "betray_army_battle_scene_state_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if tonumber(_ED.betray_army_npc.npcId) == tonumber(self.npcExample.betray_army_id) then
					instance:ChangeToState(_ED.betray_army_npc.npcId)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(betray_army_battle_scene_button_close_terminal)
		state_machine.add(betray_army_battle_scene_formation_change_button_terminal)
		state_machine.add(betray_army_battle_scene_buy_prop_button_terminal)
		state_machine.add(betray_army_battle_scene_refresh_state_terminal)
		state_machine.add(betray_army_battle_scene_common_attack_button_terminal)
		state_machine.add(betray_army_battle_scene_state_update_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_world_boss_terminal()
end


function BetrayArmyBattleScene:challenge(params)

	local _betrayArmyId = params._datas.betray_army_example 
	local _index = params._datas.index 
	local _surplusHp = params._datas.surplusHp 
	
	local surplus = 0
	if tonumber(_index) == 2 then
		if tonumber(_ED.betray_army_information.is_consume) > 0 then--是否功勋加倍(0否 1是)	
			surplus = tonumber(_ED.user_info.dispatch_token) - 1
		else
			surplus = tonumber(_ED.user_info.dispatch_token) - 2
		end
	else
		surplus = tonumber(_ED.user_info.dispatch_token) - 1
	end

	local function responseBattleInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			
			-- 记录下当前所选择的类型
			_ED.worldboss = _ED.worldboss or {}
			_ED.worldboss.selectIndex = _index -- (1,2双倍)
			
			_ED.betray_army_npc = _ED.betray_army_npc or {}
			_ED.betray_army_npc.npcId = _betrayArmyId
			state_machine.excute("page_stage_fight_data_deal", 0, 0)
			
			_ED.user_info.dispatch_token = surplus
			
			fwin:cleanView(fwin._windows)

			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				fwin:freeAllMemeryPool()
			end
			local bse = BattleStartEffect:new()
			bse:init(_enum_fight_type._fight_type_104)
			fwin:open(bse, fwin._windows)
		end
	end
	if tonumber(_surplusHp) <= 0 then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			--服务器已经给提示，所以前端不给提示了
		else
			TipDlg.drawTextDailog(_string_piece_info[335])
		end
	elseif zstring.tonumber(_ED.user_info.dispatch_token) <= 0 or surplus < 0 then
		
		state_machine.excute("betray_army_battle_scene_buy_prop_button", 0, nil) 
		return
	end
	
	local function launchBattle()
		protocol_command.rebel_army_fight.param_list = "".._betrayArmyId.."\r\n".._index
		NetworkManager:register(protocol_command.rebel_army_fight.code, nil, nil, nil, nil, responseBattleInitCallback, false, nil)
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
			local rid = self.npc
			protocol_command.camp_preference.param_list = ""..rid.."\r\n".."0"
			NetworkManager:register(protocol_command.camp_preference.code, nil, nil, nil, nil, responseCampPreferenceCallback, false, nil)
		else
			launchBattle()
		end
	end
end

function BetrayArmyBattleScene:formatTimeString(_time)	--系统时间转换
	local timeString = ""
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
	return timeString
end

function BetrayArmyBattleScene:DarwFleeTime()
	local root = self.roots[1]
	if _ED.betray_army_information.army_time ~= nil then
		local times = os.time()- tonumber(_ED.betray_army_information.army_time)
		
		local FleeTime = 0
		local _refreshTime = ccui.Helper:seekWidgetByName(root, "Text_4_0_0_0")
		if times > self.npcExample.stop_time/1000 then 
			_refreshTime:setString(self:formatTimeString(FleeTime))
		else 
			FleeTime =self.npcExample.stop_time/1000-times	--剩余刷新的时间
			_refreshTime:setString(self:formatTimeString(FleeTime))
			if math.floor(tonumber(FleeTime)) == 0 then
				self.index = self.index + 1
				if tonumber(self.index) == 1 then
					self:onUpdateD()
					state_machine.excute("betray_army_npc_cell_refresh", 0, 
						{
							betrayArmyId = self.npcExample.betray_army_id,
							betray_army_example = self.npcExample.betray_army_example,
							npcCell = self.npcCell
						})
					self:onUpdate(nil)
				end
			end
		end
	end
end

function BetrayArmyBattleScene:ChangeToState(npcId)
	local root = self.roots[1]
	-- self.npcExample.surplus_hp = tonumber(self.npcExample.surplus_hp) 
	ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_1"):setPercent(tonumber(self.npcExample.surplus_hp) / tonumber(self.npcExample.all_hp) * 100)
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_19"):setString(self.npcExample.surplus_hp.."/"..self.npcExample.all_hp)
	-- print(self.npcExample.surplus_hp,"==============================")
	if tonumber(self.npcExample.surplus_hp) <= 0 then
		textHP:setString("0".."/"..self.npcExample.all_hp)
		self:onUpdateD(npcId)
	end
end
function BetrayArmyBattleScene:onUpdateD(betray_army_id)
	local root = self.roots[1]
	local rebelArmyRole = ccui.Helper:seekWidgetByName(root, "Panel_43")	--npc形象
	
	local betrayArmyId = zstring.tonumber(betray_army_id)	--叛军模板
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local npcHeadPic = dms.int(dms["rebel_army_mould"], betrayArmyId, rebel_army_mould.aram_pic) - 1000
		local npcIcon = ""
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			npcIcon = string.format("images/face/big_head/big_head_%d.png", npcHeadPic)
		else
			npcIcon = string.format("images/face/card_head/card_head_%d.png", npcHeadPic)
		end
		
		local background = cc.Sprite:create(npcIcon)
		background:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA, gl.ONE))
		background:setAnchorPoint(cc.p(0.5, 0.5))
		background:setPosition(cc.p(rebelArmyRole:getContentSize().width/2,rebelArmyRole:getContentSize().height/2))
		rebelArmyRole:addChild(background)
	end
	display:gray(rebelArmyRole)
	
end
function BetrayArmyBattleScene:onUpdate(dt)
	self:DarwFleeTime()
end
function BetrayArmyBattleScene:onUpdateDraw()
	local root = self.roots[1]
	
	local rebelArmyRole = ccui.Helper:seekWidgetByName(root, "Panel_43")		--npc形象
	local TextNpcName = ccui.Helper:seekWidgetByName(root, "Text_4")			--npc名字
	local TextNpcGrade = ccui.Helper:seekWidgetByName(root, "Text_4_0")			--npc等级
	local hpLoadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")		--血量
	local textHP = ccui.Helper:seekWidgetByName(root, "Text_19")				--血量数值
	local textDispatch = ccui.Helper:seekWidgetByName(root, "Text_11_0")		--征讨令
	
	local textActivityOne = ccui.Helper:seekWidgetByName(root, "Text_135")			--活动内容
	local textActivityTwo = ccui.Helper:seekWidgetByName(root, "Text_135_0")		--活动内容
	local textActivityThree = ccui.Helper:seekWidgetByName(root, "Text_135_1")		--活动内容
	local textActivityFour = ccui.Helper:seekWidgetByName(root, "Text_135_1_0")		--活动内容
	
	local textCommon = ccui.Helper:seekWidgetByName(root, "Text_90")		--普通攻击消耗
	local textDeadly = ccui.Helper:seekWidgetByName(root, "Text_190")		--全力一击消耗
	
	local betrayArmyId = zstring.tonumber(self.npcExample.betray_army_id)	--叛军模板
	
	--NPC名字和品质
	local npcName = dms.string(dms["rebel_army_mould"], betrayArmyId, rebel_army_mould.army_name)
	local quality = dms.int(dms["rebel_army_mould"], betrayArmyId, rebel_army_mould.army_quality)
	local color = tipStringInfo_quality_color_Type[quality]
	local npcNameColor = cc.c4b(color[1],color[2],color[3],255) -- cc.c4b(255,0,0,255)	
	
	self.npc = dms.int(dms["rebel_army_mould"], betrayArmyId, rebel_army_mould.npc)
	
	TextNpcName:setString(npcName)
	TextNpcName:setColor(npcNameColor)
	
	--NPC等级
	local npcLv = self.npcExample.betray_level
	-- if nil == npcLv then
	-- 	npcLv = dms.string(dms["rebel_army_mould"],betrayArmyId,rebel_army_mould.aram_level)
	-- end
	if verifySupportLanguage(_lua_release_language_en) == true then
		TextNpcGrade:setString(_string_piece_info[6]..npcLv)
	else
		TextNpcGrade:setString(npcLv.._string_piece_info[6])
	end
	
	--npc血量
	hpLoadingBar:setPercent(tonumber(self.npcExample.surplus_hp) / tonumber(self.npcExample.all_hp) * 100)
	textHP:setString(self.npcExample.surplus_hp.."/"..self.npcExample.all_hp)
	--征讨令
	
	
	local dispatchStr =dms.string(dms["pirates_config"], 1, pirates_config.param)
	local dispatchStrMouID = zstring.split(dispatchStr,",")	
	textDispatch:setString(_ED.user_info.dispatch_token.."/"..dispatchStrMouID[6])
	--状态
	if tonumber(_ED.betray_army_information.is_consume) > 0 then--是否消耗减半(0否 1是)
		textActivityOne:setVisible(false)
		textActivityTwo:setVisible(true)
		textDeadly:setString("1")
	else
		textActivityOne:setVisible(true)
		textActivityTwo:setVisible(false)
		textDeadly:setString("2")
	end
	textCommon:setString("1")
	if tonumber(_ED.betray_army_information.is_exploit) > 0 then--是否功勋加倍(0否 1是)	
		textActivityThree:setVisible(false)
		textActivityFour:setVisible(true)
	else
		textActivityThree:setVisible(true)
		textActivityFour:setVisible(false)
	end
	
	--NPC形象
	-- local cell = BetrayArmyNpcCell:createCell()
	-- cell:init(self.npcExample,cell.enum_type.SURROUND_WAR_TWO_NPC)
	-- rebelArmyRole:addChild(cell)
	-- local npcHeadPic = tonumber(dms.string(dms["npc"],self.npcExample.betray_army_id,npc.head_pic))-1000
	 
	local npcHeadPic = nil
	local npcIcon=nil
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		local lineData = dms.element(dms["npc"], self.npcExample.betray_army_id)
		npcHeadPic = dms.atoi(lineData, npc.npc_type)
		npcIcon = string.format("images/ui/pve_sn/pve_tow_bg_%s.png",npcHeadPic)
	else
		npcHeadPic=dms.int(dms["rebel_army_mould"], self.npcExample.betray_army_id, rebel_army_mould.aram_pic) - 1000
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			npcIcon = string.format("images/face/big_head/big_head_%d.png", npcHeadPic)
		else
			npcIcon = string.format("images/face/card_head/card_head_%d.png", npcHeadPic)
		end		
	end

	local background = cc.Sprite:create(npcIcon)
	background:setAnchorPoint(cc.p(0.5, 0.5))
	background:setPosition(cc.p(rebelArmyRole:getContentSize().width/2,rebelArmyRole:getContentSize().height/2))
	rebelArmyRole:addChild(background)
end

function BetrayArmyBattleScene:onEnterTransitionFinish()
	
	local csbBetrayArmyBattleScene = csb.createNode("campaign/WorldBoss/wordBoss_pve.csb")
	self:addChild(csbBetrayArmyBattleScene)
	local root = csbBetrayArmyBattleScene:getChildByName("root")
	table.insert(self.roots, root)
	
	if __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		local action= csb.createTimeline("campaign/WorldBoss/wordBoss_pve.csb")
		csbBetrayArmyBattleScene:runAction(action)
		action:play("window_open",false)
	end
	--关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
		{
			terminal_name = "betray_army_battle_scene_button_close",
			terminal_state = 0,
			isPressedActionEnabled = true
		}, nil, 2)
	self:onUpdateDraw()
	--布阵
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
		{
			terminal_name = "betray_army_battle_scene_formation_change_button",
			terminal_state = 0,
			isPressedActionEnabled = true
		}, nil, 0)
	
	local dispatchStr =dms.string(dms["pirates_config"], 273, pirates_config.param)
	local dispatchStrMouID = zstring.split(dispatchStr,",")	
	self.dispatchID = dispatchStrMouID[17]
	--购买出击令
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, 
		{
			terminal_name = "betray_army_battle_scene_buy_prop_button",
			terminal_state = 0,
			dispatchID = self.dispatchID,
			isPressedActionEnabled = true
		}, nil, 0)
	--普通攻击 进入战斗
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_35"), nil, 
		{
			terminal_name = "betray_army_battle_scene_common_attack_button",
			terminal_state = 0,
			betrayArmyId = self.npcExample.betray_army_id,
			betray_army_example = self.npcExample.betray_army_example,
			surplusHp = self.npcExample.surplus_hp,
			index = 1,
			isPressedActionEnabled = true
		}, nil, 0)
	--全力一击 进入战斗
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_35_0"), nil, 
		{
			terminal_name = "betray_army_battle_scene_common_attack_button",
			terminal_state = 0,
			betrayArmyId = self.npcExample.betray_army_id,
			betray_army_example = self.npcExample.betray_army_example,
			surplusHp = self.npcExample.surplus_hp,
			index = 2,
			isPressedActionEnabled = true
		}, nil, 0)
		
end


function BetrayArmyBattleScene:init(NpcExample,npcCell)
	self.npcExample = NpcExample
	self.npcCell = npcCell
end
function BetrayArmyBattleScene:createCell()
	local cell = BetrayArmyBattleScene:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
function BetrayArmyBattleScene:onExit()
	
end