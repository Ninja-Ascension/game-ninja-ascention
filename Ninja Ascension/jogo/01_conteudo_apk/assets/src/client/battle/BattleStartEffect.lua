-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗开场动画管理类
-------------------------------------------------------------------------------------------------------
local is2006 = false
local is2005 = false
if __lua_project_id == __lua_project_warship_girl_a 
	or __lua_project_id == __lua_project_warship_girl_b
	or __lua_project_id == __lua_project_digimon_adventure 
	or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
	or __lua_project_id == __lua_project_naruto 
	or __lua_project_id == __lua_project_pokemon 
	or __lua_project_id == __lua_project_rouge 
	or __lua_project_id == __lua_project_yugioh
	or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
	or __lua_project_id == __lua_project_red_alert
	or __lua_project_id == __lua_project_legendary_game
	or __lua_project_id == __lua_project_koone
	then
	if dev_version >= 2006 then
		is2006 = true
	elseif dev_version >= 2005 then
		is2005 = true
	end
end

BattleStartEffect = class("BattleStartEffectClass", Window)

function BattleStartEffect:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.battle.fight.FightEnum")
	--战斗类型枚举
	self.enum_type = {
		_TYPE_PVE = 1,						-- PVE战斗
		_TYPE_ARENA = 2,					-- 竞技场战斗
	}
	
	self.currentType = 0					-- 当前战斗类型
	
	self.cacheFightArmature = nil
	self._state = 0

	self._ufight = 0

	self._spineEffects = {}

	self.isRegisterEnvironmentFightComplete = false
	if fwin.cleanMusic ~= nil then
		fwin:cleanMusic()
	end
	fwin:cleanView(fwin._dialog)
	fwin:cleanView(fwin._notification)
	fwin:cleanView(fwin._screen)
	fwin:cleanView(fwin._system)
	fwin:cleanView(fwin._display_log)


					-- fwin:cleanView(fwin._background)
					-- -- fwin:cleanView(fwin._view)
					-- fwin:cleanView(fwin._viewdialog)
					-- fwin:cleanView(fwin._taskbar)
					-- fwin:cleanView(fwin._ui)
					-- fwin:cleanView(fwin._dialog)
					-- fwin:cleanView(fwin._notification)
					-- fwin:cleanView(fwin._screen)
					-- fwin:cleanView(fwin._system)
					-- fwin:cleanView(fwin._display_log) 

	ccs.ArmatureDataManager:destroyInstance()
	cc.SpriteFrameCache:getInstance():removeSpriteFrames()
	cacher.removeAllTextures()
	
    local function init_battle_start_effect_terminal()
    	local battle_start_effect_into_fight_terminal = {
            _name = "battle_start_effect_into_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if is2006 then
				
				else
					instance:intoFight()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local battle_start_create_into_fight_terminal = {
            _name = "battle_start_create_into_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:createIntoFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local battle_create_into_fight_end_terminal = {
            _name = "battle_create_into_fight_end",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:endIntoFight()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(battle_create_into_fight_end_terminal)
		state_machine.add(battle_start_create_into_fight_terminal)
        state_machine.add(battle_start_effect_into_fight_terminal)
        state_machine.init()
    end
    
    -- call func init battle start effect state machine.
    init_battle_start_effect_terminal()
end

function BattleStartEffect:loading()
	-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	self.fightWindow:init(self.currentType, 
		_ED._current_scene_id, 
		_ED._scene_npc_id, 
		_ED._npc_difficulty_index,
		_ED._npc_addition_params)
	-- fwin:open(fightWindow, fwin._view)
	_ED._npc_addition_params = nil
	if self._state == 0 then
		self._state = 2
		-- self.cacheFightArmature:getAnimation():gotoAndPlay(0)
		-- self.cacheFightArmature:getAnimation():playWithIndex(0)
	else
		if self._state == 3 then
			self.cacheFightArmature:getAnimation()._nextAction = 0
			self:showFight()
		end
		-- if self._state == 2 then
		-- 	state_machine.excute("battle_start_effect_into_fight", 0, "")
		-- else
		-- 	self._state = 1
		-- end
	end
	-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end

function BattleStartEffect:showFight()
	-- if self.fightWindow ~= nil then
	-- 	fwin:open(self.fightWindow, fwin._view)
	-- 	self.fightWindow:release()
	-- 	self.fightWindow = nil
	-- end
end

function BattleStartEffect:intoFight()
	self:showFight()

	fwin:close(self)
	fwin:cleanView(fwin._window)
	-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	
	state_machine.excute("fight_hero_into", 0, 0)
end

function BattleStartEffect:createIntoFight()
	fwin:cleanView(fwin._window)
	-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	state_machine.excute("fight_hero_into", 0, 0)
end

function BattleStartEffect:endIntoFight()
	if nil ~= self.cacheFightArmature then
		self.cacheFightArmature._nextAction = 0
		self:closeView()
	end
end
function BattleStartEffect:closeView()
	for k,v in pairs(self._spineEffects) do
        if v ~= nil then
            v:release()
            v = nil
        end
    end
    self._spineEffects = {}
	self:showFight()
	fwin:close(self)
end

function BattleStartEffect:loadAttackSkillInfluenceEffect(skillInfluenceId, _sforIndex) 
    -- 加载技能效用
    local skillInfluenceElementData = dms.element(dms["skill_influence"], skillInfluenceId)
    if skillInfluenceElementData ~= nil then
        local effectId = dms.atoi(skillInfluenceElementData, _sforIndex)
        if effectId >= 0 then
            -- local function dataLoaded(percent)
            --     if percent >= 1 then
            --     end
            -- end
            local fileName = string.format("effect/effice_%d.ExportJson", effectId)

            self._exportJsons[fileName] = fileName
            -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, dataLoaded)
        end
    end
end

function BattleStartEffect:loadAttackSkillInfluencesEffects(skillInfluences)
    for n, t in pairs(skillInfluences) do
        local _skf = t
        local skillInfluenceId  = tonumber(_skf.skillInfluenceId)
        -- 后段光效
        self:loadAttackSkillInfluenceEffect(skillInfluenceId, skill_influence.bear_lighting_effect_id)
    end
end

function BattleStartEffect:loadAttackEffects()
    self._exportJsonIndex = 0
    self._exportJsonOver = false
	local _self = self
    local function dataLoaded1AAA(percent)
        if percent >= 1 then
           if _self._exportJsonOver == false then
               _self._exportJsonOver = true

               -- _self.cacheFightArmature._nextAction = 0

             --    local fightWindow = fwin:find("FightClass")
	            -- fightWindow:initHeros()

	            -- if missionIsOver() == false and checkEventType(execute_type_role_restart, 1) == true then
	            --     executeNextEvent(nil, true)
	            -- end
				
				-- Loading.loading(
			 --    {
			 --        _pic = {}, 
			 --        _plist = {
			 --        	-- sprite/hero_head_effect.ExportJson
			 --            {
			 --                _png = {"sprite/hero_head_effect0.png"}, 
			 --                _plist = {"sprite/hero_head_effect0.plist"}
			 --            },
			 --            {
			 --                _png = {"sprite/hero_head_effect1.png"}, 
			 --                _plist = {"sprite/hero_head_effect1.plist"}
			 --            },
			 --            {
			 --                _png = {"sprite/hero_head_effect2.png"}, 
			 --                _plist = {"sprite/hero_head_effect2.plist"}
			 --            },
			 --            {
			 --                _png = {"sprite/hero_head_effect3.png"}, 
			 --                _plist = {"sprite/hero_head_effect4.plist"}
			 --            },
			 --            -- sprite/hero_head_effect_2_1.ExportJson,
			 --            {
			 --                _png = {"sprite/hero_head_effect_2_10.png"}, 
			 --                _plist = {"sprite/hero_head_effect_2_10.plist"}
			 --            },
			 --            {
			 --                _png = {"sprite/hero_head_effect_2_11.png"}, 
			 --                _plist = {"sprite/hero_head_effect_2_11.plist"}
			 --            },
			 --            {
			 --                _png = {"sprite/hero_head_effect_2_12.png"}, 
			 --                _plist = {"sprite/hero_head_effect_2_12.plist"}
			 --            },
			 --            {
			 --                _png = {"sprite/hero_head_effect_2_13.png"}, 
			 --                _plist = {"sprite/hero_head_effect_2_13.plist"}
			 --            },
			 --            {
			 --                _png = {"sprite/hero_head_effect_2_14.png"}, 
			 --                _plist = {"sprite/hero_head_effect_2_14.plist"}
			 --            },
			 --            {
			 --                _png = {"sprite/hero_head_effect_2_15.png"}, 
			 --                _plist = {"sprite/hero_head_effect_2_15.plist"}
			 --            },
			 --            -- sprite/hero_head_effect_4_1.ExportJson,
			 --            {
			 --                _png = {"sprite/hero_head_effect_4_10.png"}, 
			 --                _plist = {"sprite/hero_head_effect_4_10.plist"}
			 --            },
			 --            {
			 --                _png = {"sprite/hero_head_effect_4_11.png"}, 
			 --                _plist = {"sprite/hero_head_effect_4_11.plist"}
			 --            },
			 --            {
			 --                _png = {"sprite/hero_head_effect_4_12.png"}, 
			 --                _plist = {"sprite/hero_head_effect_4_12.plist"}
			 --            },
			 --            {
			 --                _png = {"sprite/hero_head_effect_4_13.png"}, 
			 --                _plist = {"sprite/hero_head_effect_4_13.plist"}
			 --            },
			 --            {
			 --                _png = {"sprite/hero_head_effect_4_14.png"}, 
			 --                _plist = {"sprite/hero_head_effect_4_14.plist"}
			 --            }
			 --        }, 
			 --        _ui = {}
			 --    },
			 --    nil,
			 --    nil)
           end
        end
    end

	-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("sprite/spirte_battle_card.ExportJson", dataLoaded1AAA)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card.ExportJson")
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card_1.ExportJson")
	end
	

	local function addArmatureFileInfo(v)
		local mid = v._mouldId
		if v._type == "1" then
			local shipMouldId = dms.int(dms["environment_ship"], mid, environment_ship.directing)
			if shipMouldId > 0 then
				mid = shipMouldId
			end
		end
		local movementIndex = dms.int(dms["ship_mould"], mid, ship_mould.movement)
		local captain_type = dms.int(dms["ship_mould"], mid, ship_mould.captain_type) --判断是否是宠物
		if __lua_project_id == __lua_project_warship_girl_a 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim  
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh then
			if dms.int(dms["ship_mould"], tonumber(mid), ship_mould.captain_type) == 0 then
				local fashionEquip, pic = getUserFashion()
				if fashionEquip ~= nil and pic ~= nil then
					movementIndex = 0
				end
			end
		end
		if __lua_project_id == __lua_project_rouge 
			then
			movementIndex = 0
		end
		if __lua_project_id == __lua_project_yugioh
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			then
			ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_battle_card.ExportJson")
		end
		if movementIndex ~= nil and movementIndex > 0 and captain_type ~= 3 then
			if __lua_project_id == __lua_project_yugioh then
                local jsonFile = string.format("sprite/spirte_battle_card_%s.json", movementIndex)
                local atlasFile = string.format("sprite/spirte_battle_card_%s.atlas", movementIndex)
	            if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
		            local spArmature = sp.spine(jsonFile, atlasFile, _tipstringinfo_fight_armature_scale, 0, 
		                spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)
	            	spArmature:retain()
	            	table.insert(self._spineEffects, spine)
	            end
            elseif __lua_project_id == __lua_project_pokemon 
            	then
                local jsonFile = string.format("sprite/big_head_%s.json", movementIndex)
                local atlasFile = string.format("sprite/big_head_%s.atlas", movementIndex)
                if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
	                local spArmature = sp.spine(jsonFile, atlasFile, _tipstringinfo_fight_armature_scale, 0, 
		                spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)
	            	spArmature:retain()
	            	table.insert(self._spineEffects, spine)
	            end
			else
				ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("sprite/spirte_battle_card_%d.ExportJson",movementIndex))
			end
		end
	end
	
	if _ED.battleData ~= nil then
		-- 添加我方角色动态
		for _, v1 in pairs(_ED.battleData._heros) do
			addArmatureFileInfo(v1)
		end
		-- 添加敌方角色动态
		-- for _, v2 in pairs(_ED.battleData._armys) do
			-- for _, v3 in pairs(v2._data) do
				-- addArmatureFileInfo(v3._mouldId)
			-- end
		-- end
	end

	cc.Director:getInstance():getTextureCache():addImage("images/ui/battle/battle_1.png")
	cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/battle/battle_1.plist")
	
	-- if _ED.attackData ~= nil then
	--     self._exportJsons = {}
	--     for i, v in pairs(_ED.attackData.roundData) do
	--         for j, h in pairs(v.roundAttacksData) do
	
				-- end
			-- end
		-- end
	-- for do
		-- local movementIndex = dms.int(dms["ship_mould"], v, ship_mould.movement)
		-- if movementIndex > 0 then
			-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(string.format("sprite/spirte_battle_card_%d.ExportJson",movementIndex))
		-- end
	-- end
	
	-- cacher.addArmatureFileInfo("sprite/spirte_battle_card.ExportJson")
	dataLoaded1AAA(1) 
    if self._npc_type == "0" then
        
    elseif self._npc_type == "1" then
        
        -- if self._boss_battle_card_num ~= nil then
        --  local pathName = string.format(self._boss_battle_card_string,self._boss_battle_card_num)
        --  ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(pathName, dataLoaded)
        -- end

    end
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("sprite/hero_head_effect.ExportJson", dataLoaded1AAA)
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("sprite/hero_head_effect_2.ExportJson", dataLoaded1AAA)
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("sprite/hero_head_effect_2_1.ExportJson", dataLoaded1AAA)
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("sprite/hero_head_effect_4.ExportJson", dataLoaded1AAA)
    -- -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync("sprite/hero_broken_effect.ExportJson", dataLoaded1AAA)

	-- if _ED.attackData ~= nil then
	--     self._exportJsons = {}
	--     for i, v in pairs(_ED.attackData.roundData) do
	--         for j, h in pairs(v.roundAttacksData) do
	--             local attData = h
	--             local skillMouldId          = tonumber(attData.skillMouldId)
	--             local skillElementData = dms.element(dms["skill_mould"], skillMouldId)
	--             local skillQuality = dms.atoi(skillElementData, skill_mould.skill_quality)  -- 技能类型(0:普通 1:怒气)
	--             if skillQuality == 0 or true then
	-- 	            local skillInfluenceId = zstring.split(dms.atos(skillElementData, skill_mould.health_affect), ",")[1]
	-- 	            -- 启动技能中段
	-- 	            self:loadAttackSkillInfluenceEffect(skillInfluenceId, skill_influence.posterior_lighting_effect_id)

	-- 	            self:loadAttackSkillInfluencesEffects(h.skillInfluences)
	-- 	            -- 合体技能
	-- 	            if h.fitHeros ~= nil then
	-- 	                for f, s in pairs(h.fitHeros) do
	-- 	                    skillElementData = dms.element(dms["skill_mould"], tonumber(s.skillMouldId))
		                    
	-- 	                    local skillInfluenceIds = zstring.split(dms.atos(skillElementData, skill_mould.releas_skill), "|")
	-- 	                    skillInfluenceIds = zstring.split(skillInfluenceIds[f], ",")
	-- 	                    skillInfluenceId = zstring.tonumber(skillInfluenceIds[1])
	-- 	                    -- 启动技能中段
	-- 	                    self:loadAttackSkillInfluenceEffect(skillInfluenceId, skill_influence.posterior_lighting_effect_id)

	-- 	                    self:loadAttackSkillInfluencesEffects(s.skillInfluences)
	-- 	                end
	-- 	            end

	-- 	            self:loadAttackSkillInfluencesEffects(h.skillAfterInfluences)
	--         	end
	--         end
	--     end
	--     for i, v in pairs(self._exportJsons) do
	--         local fileName = v
	--         --> print("加载光效：", fileName)
	--         ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, dataLoaded1AAA)  
	--     end
	-- end
end

function BattleStartEffect:registerEnvironmentFight(_current_scene_id,_scene_npc_id, _npc_difficulty_index, _npc_addition_params)
	
	-- 非副本战的 不用提前请求的都过滤掉
	if self.currentType == _enum_fight_type._fight_type_10
		or self.currentType == _enum_fight_type._fight_type_11 
		or self.currentType == _enum_fight_type._fight_type_53 
		or self.currentType >= _enum_fight_type._fight_type_101 or self.currentType == _enum_fight_type._fight_type_107 
		or self.currentType == _enum_fight_type._fight_type_109
		or self.currentType == _enum_fight_type._fight_type_211
		or self.currentType == _enum_fight_type._fight_type_213
		or self.currentType == _enum_fight_type._fight_type_214
		or self.currentType == _enum_fight_type._fight_type_219
		or self.currentType == _enum_fight_type._fight_type_220
		or missionIsOver() == false	
		then
		-- state_machine.excute("battle_start_create_into_fight", 0, "")
		-- self.cacheFightArmature._nextAction = 0
		self:loadAttackEffects()
		return
	end
	
	if self.isRegisterEnvironmentFightComplete ~= true then
		self.isRegisterEnvironmentFightComplete = true
	
		if _npc_addition_params ~= nil and _npc_addition_params ~= "" then
			
		else
		   _npc_addition_params = "0"
		end
		
		-- _ED.init_environment_fight_complete = false
		-- local function responseEnvironmentFightCallback(response)
		-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		-- 		if response.node.roots ~= nil then
		-- 			_ED.init_environment_fight_complete = true
		-- 			response.node.isRegisterEnvironmentFightComplete = true
		-- 		end
		-- 	else
		-- 		-- if response.node.roots ~= nil then
		-- 		-- 	response.node.cacheFightArmature._nextAction = 0
		-- 		-- end
		-- 		-- -- -- 无论成功失败都发起战斗开启
		-- 		-- -- state_machine.excute("battle_start_create_into_fight", 0, "")
		-- 	end
		-- 	response.node:loadAttackEffects()
		-- end

		-- protocol_command.environment_fight.param_list = "".._current_scene_id.."\r\n".._scene_npc_id.."\r\n".._npc_difficulty_index.."\r\n".._npc_addition_params
		-- NetworkManager:register(protocol_command.environment_fight.code, nil, nil, nil, self, responseEnvironmentFightCallback, false, nil)

		_ED.init_environment_fight_complete = true
		self:loadAttackEffects()
	end
end

function BattleStartEffect:onEnterTransitionFinish()
	-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.imageLoaded, self)

	-- ccs.ArmatureDataManager:destroyInstance()
	-- cc.SpriteFrameCache:getInstance():removeSpriteFrames()
 -- 	cacher.removeAllTextures()
 -- 	-- -- cacher.addTextureAsync(texture_cache_load_images_fight)
 -- 	-- ccs.ArmatureDataManager:destroyInstance()
 -- 	-- cacher.cleanSystemCacher()

 	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	    app.load("client.battle.landscape.FightLoading")
	    fwin:open(FightLoadingCell:new():init(self.currentType), fwin._windows)
	    return
    end

	local csbPveDuplicate = csb.createNode("battle/battle_donghua.csb")
    local root = csbPveDuplicate:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPveDuplicate)
	
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_2")
    self.cacheFightArmature = panel:getChildByName("ArmatureNode_1")
	
	local battle_open = 0
	local battle_close = 1
	local battle_wait = 2
	local isPlayover = false
	local isLoadBettle = false
	local isBattleWait = false
	
	local function changeActionCallback(armatureBack)
		local armature = armatureBack
		if armature ~= nil then
			local actionIndex = armature._actionIndex
			if actionIndex == battle_open then
				if isPlayover == false then
					isPlayover = true
				else
					deleteEffect(armature)
					
					-- if self._state == 1 then
					-- 	state_machine.excute("battle_start_effect_into_fight", 0, "")
					-- else
					-- 	self._state = 2
					-- end
					
					if true == is2005 then
						--state_machine.excute("battle_start_effect_into_fight", 0, "")
						self:endIntoFight()
					elseif true == is2006 then
						self:endIntoFight()
						state_machine.excute("fight_hero_into", 0, 0)
					else
						state_machine.excute("battle_start_effect_into_fight", 0, "")
					end
					
					self.cacheFightArmature = nil
				end
			elseif actionIndex == battle_close then
				armature._nextAction = battle_wait
			elseif actionIndex == battle_wait then
				if true == is2005 then
				elseif true == is2006 then
					armature._nextAction = battle_open
				else
					armature._nextAction = battle_open
				end

				if isBattleWait ~= true then
					isBattleWait = true
				 
				 	fwin:cleanView(fwin._frameview)
					fwin:cleanView(fwin._background)
					fwin:cleanView(fwin._view)
					fwin:cleanView(fwin._viewdialog)
					fwin:cleanView(fwin._taskbar)
					fwin:cleanView(fwin._ui)
					fwin:cleanView(fwin._dialog)
					fwin:cleanView(fwin._notification)
					fwin:cleanView(fwin._screen)
					fwin:cleanView(fwin._system)
					fwin:cleanView(fwin._display_log) 

					-- app.load("client.battle.fight.Fight")
					-- local fightWindow = Fight:new()
					-- fightWindow:init(self.currentType, _ED._current_scene_id, _ED._scene_npc_id, _ED._npc_difficulty_index, _ED._npc_addition_params)
					-- fwin:open(fightWindow, fwin._view)
					
					-- if true == is2005 or true == is2006 then
					-- 	self:registerEnvironmentFight(_ED._current_scene_id, _ED._scene_npc_id, _ED._npc_difficulty_index, _ED._npc_addition_params)
					-- end

					-- state_machine.excute("fight_hero_into", 0, 0)

					fightWindow = self.fightWindow
					fightWindow:initMap()
					fwin:open(fightWindow, fwin._view)
					fightWindow:release()

					fightWindow:initHeros()
					
		            if missionIsOver() == false and checkEventType(execute_type_role_restart, 1) == true then
		                executeNextEvent(nil, true)
		            end
				end
			end
		end
	end
	
	if self.cacheFightArmature == nil then
		self.cacheFightArmature = draw.createEffect("effect_12", "images/ui/effice/effect_12/effect_12.ExportJson", self, 1, 0, 1)
	else
		draw.initArmature(self.cacheFightArmature, nil, 1, 0, 1)
	end
	self.cacheFightArmature._needLoad = true
	self.cacheFightArmature._invoke = changeActionCallback
	self.cacheFightArmature._actionIndex = 0
	self.cacheFightArmature._nextAction = 1
	self.cacheFightArmature:getAnimation():playWithIndex(1)

	-- test code
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		self.cacheFightArmature:setVisible(false)
	end

	Loading.loading(
    {
        _pic = {}, 
        _plist = {
            {
                _png = {"images/ui/battle/battle_1.png"}, 
                _plist = {"images/ui/battle/battle_1.plist"}
            }
        }, 
        _ui = {}
    },
    nil,
    nil)

    app.load("client.battle.fight.Fight")
	local fightWindow = Fight:new()
	fightWindow:init(self.currentType, _ED._current_scene_id, _ED._scene_npc_id, _ED._npc_difficulty_index, _ED._npc_addition_params)
	-- fwin:open(fightWindow, fwin._view)
	self.fightWindow = fightWindow
	self.fightWindow:retain()

	if true == is2005 or true == is2006 then
		self:registerEnvironmentFight(_ED._current_scene_id, _ED._scene_npc_id, _ED._npc_difficulty_index, _ED._npc_addition_params)
	end
end

function BattleStartEffect:onUpdate(dt)
	self._ufight = self._ufight + 1
	if self._ufight == 2 then

	end
end

function BattleStartEffect:init(aType)
	self.currentType = aType
end

function BattleStartEffect:onExit()
	state_machine.remove("battle_start_effect_into_fight")
	state_machine.remove("battle_start_create_into_fight")
	state_machine.remove("battle_create_into_fight_end")
	
	
end
