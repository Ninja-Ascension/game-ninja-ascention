






BossIntroduce = class("BossIntroduceClass", Window)
BossIntroduce.__cmoroon = true

local bossintroduce_open_window_terminal = {
	_name = "bossintroduce_open_window",
	_init = function (terminal)

	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local ship_mould_id = params
		local _BossIntroduce = BossIntroduce:new()
		_BossIntroduce:init(ship_mould_id)
		fwin:open(_BossIntroduce,fwin._dialog)

		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(bossintroduce_open_window_terminal)
state_machine.init()
function BossIntroduce:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.ship_mould_id = nil

	self.musicId = -1

    local function init_boss_introduce_terminal()
    	local boss_introduce_close_terminal = {
			_name = "boss_introduce_close",
			_init = function (terminal)

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				fwin:close(instance)
                local _role_diaglog = fwin:find("RoleDialogueClass")
                if _role_diaglog ~= nil then
                    _role_diaglog:setVisible(true)
                end

                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					if missionIsOver() == true then

						state_machine.excute("fight_attack_round_start",0,0)
					else
						state_machine.excute("fight_attack_round_start",0,0)
				  	end
				else
					if missionIsOver() == true then

						state_machine.excute("fight_attack_round_start",0,0)
				  	end
					state_machine.excute("battle_scene_resume", 0, nil)
				end




				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(boss_introduce_close_terminal)
        state_machine.init()
    end


    init_boss_introduce_terminal()
end

function BossIntroduce:onEnterTransitionFinish()
end

function BossIntroduce:onUpdateDraw()
	local root = self.roots[1]
	local ship_mould_id = self.ship_mould_id

	local evo_mould_id = self.ship_evo_mould
	local name = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then






        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
        name = word_info[3]
    else
		name = dms.string(dms["ship_mould"],ship_mould_id,ship_mould.captain_name)
	end

	local ability = dms.int(dms["ship_mould"],ship_mould_id,ship_mould.ability)
	local capacity = dms.int(dms["ship_mould"],ship_mould_id,ship_mould.capacity)
	local introduce = dms.string(dms["ship_mould"],ship_mould_id,ship_mould.introduce)
	local deadly_skill_mould = dms.int(dms["ship_mould"],ship_mould_id,ship_mould.deadly_skill_mould)
	local temp_bust_index = 0
	local skill_name = nil
	local skill_describe = nil
	local skill_pic = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then








		temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

		introduce = dms.string(dms["word_mould"], dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.describe_index), word_mould.text_info)
		local disString = dms.string(dms["word_mould"], dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.position_index), word_mould.text_info)
		ccui.Helper:seekWidgetByName(root, "Text_dingwei"):setString(disString)
	else
		temp_bust_index = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.bust_index)
	end
	local quality = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.ship_type)

	if nil ~= evo_mould_id then
		skill_describe = dms.string(dms["word_mould"], dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.describe_index), word_mould.text_info)
		local talentInfo = zstring.splits(dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index), "|", ",")
		local skillTalentMould = talentInfo[2][3]
		local skill_name_index = dms.int(dms["talent_mould"], skillTalentMould, talent_mould.talent_name)
		local skill_describe_index = dms.int(dms["talent_mould"], skillTalentMould, talent_mould.talent_describe)

		skill_name = skillDescriptionReplaceData(skillTalentMould,ship_mould_id,2,1,true)

		skill_describe = skillDescriptionReplaceData(skillTalentMould,ship_mould_id,2,2,true)
		skill_pic = dms.int(dms["talent_mould"], skillTalentMould, talent_mould.new_skill_pic)

		if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
			local skill_describe_index = dms.int(dms["talent_mould"], skillTalentMould, 21)
			local word_info = dms.element(dms["word_mould"], skill_describe_index)
	    	skill_describe = word_info[3]
		end
	else
		skill_name = dms.string(dms["skill_mould"],deadly_skill_mould,skill_mould.skill_name)
		skill_describe = dms.string(dms["skill_mould"],deadly_skill_mould,skill_mould.skill_describe)
		skill_pic = dms.int(dms["skill_mould"],deadly_skill_mould,skill_mould.skill_pic)
	end











	local Text_hero_name = ccui.Helper:seekWidgetByName(root, "Text_hero_name")
	local Text_hero_ability = ccui.Helper:seekWidgetByName(root, "Text_hero_ability")
	local Text_hero_introduce = ccui.Helper:seekWidgetByName(root, "Text_hero_introduce")
	local Text_skill_name = ccui.Helper:seekWidgetByName(root, "Text_skill_name")
	local Text_skill_describe = ccui.Helper:seekWidgetByName(root, "Text_skill_describe")

	local Panel_capacity = ccui.Helper:seekWidgetByName(root, "Panel_capacity")
	local Panel_skill_pic = ccui.Helper:seekWidgetByName(root, "Panel_skill_pic")

	local Panel_hero = ccui.Helper:seekWidgetByName(root, "Panel_hero")
	Text_hero_name:setString(name)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then

		Text_hero_ability:setString(ability)
		Text_hero_introduce:setString(introduce)
		Text_skill_name:setString(skill_name)
		Text_skill_describe:setString(skill_describe)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		else
			Panel_capacity:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png",capacity))
		end
		Panel_skill_pic:setBackGroundImage(string.format("images/ui/skills/skills_%d.png", skill_pic))

		draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_hero, nil, nil, cc.p(0.5, 0))
		app.load("client.battle.fight.FightEnum")
		local shipSpine = sp.spine_sprite(Panel_hero, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        shipSpine:setScaleX(-1)
	    end


        local evo_image = dms.string(dms["ship_mould"], ship_mould_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        local evoLevel = 1
        for i, v in pairs(evo_info) do
        	if tonumber(v) == tonumber(evo_mould_id) then
        		evoLevel = i
        	end
        end

	    local Panel_jinhuadengji = ccui.Helper:seekWidgetByName(root, "Panel_jinhuadengji")
	    local level_groun_icon = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.level_groun_icon)
	    Panel_jinhuadengji:setBackGroundImage(string.format("images/ui/text/sm_role_up_%d.png", level_groun_icon))
	else

		Text_hero_ability:setString(tipStringInfo_hero_ability[ability])
		Text_hero_introduce:setString(introduce)
		Text_skill_name:setString(skill_name)
		Text_skill_describe:setString(skill_describe)

		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
			Panel_capacity:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png",capacity))
			Panel_skill_pic:setBackGroundImage(string.format("images/ui/skills_props/skills_props_%d.png", skill_pic))
			draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_hero, nil, nil, cc.p(0.5, 0))
			app.load("client.battle.fight.FightEnum")
			sp.spine_sprite(Panel_hero, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
		end

		local Panel_hero_pic = ccui.Helper:seekWidgetByName(root, "Panel_hero_pic")
		local Text_hero_ch = ccui.Helper:seekWidgetByName(root, "Text_hero_ch")
		local Text_dingwei = ccui.Helper:seekWidgetByName(root, "Text_dingwei")
		if Panel_hero_pic ~= nil then
			Panel_hero_pic:removeAllChildren(true)
			local jsonPath = "images/face/big_head/big_head_" .. temp_bust_index .. ".json"
			local atlasPath = "images/face/big_head/big_head_" .. temp_bust_index .. ".atlas"
			local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
			animation:setPosition(cc.p(Panel_hero_pic:getContentSize().width/2,Panel_hero_pic:getContentSize().height/2))
			Panel_hero_pic:addChild(animation)

		    local talent_tab_str = dms.string(dms["ship_mould"], ship_mould_id, ship_mould.talent_id)
		    local talent_tab = zstring.split(talent_tab_str,"|")[1]
		    local talent_mould_id = zstring.split(talent_tab, ",")[3]

			local talent_name = dms.string(dms["talent_mould"], talent_mould_id, talent_mould.talent_name)
			local talent_describe = dms.string(dms["talent_mould"], talent_mould_id, talent_mould.talent_describe)
			local talent_pic = dms.int(dms["talent_mould"], talent_mould_id, talent_mould.talent_pic)

			Text_skill_name:setString(talent_name)
			Text_skill_describe:setString(talent_describe)
			Panel_skill_pic:setBackGroundImage(string.format("images/ui/talent_icon/talent_icon_%d.png", talent_pic))

			local sound_id = zstring.split(dms.string(dms["ship_mould"], ship_mould_id, ship_mould.sound_index), "|")[1]
			if tonumber(sound_id) > 0 then
				pushEffect(formatMusicFile("effect", sound_id))
			end
			for i=1,dms.count(dms["sound_effect_param"]) do
				if dms.string(dms["sound_effect_param"], i, sound_effect_param.class_name) == "BossIntroduceClass" then
					pushEffect(formatMusicFile("effect", dms.int(dms["sound_effect_param"], i, sound_effect_param.special_effect)))
				end
			end
		end
		if Text_hero_ch ~= nil then
			Text_hero_ch:setString(dms.string(dms["ship_mould"], ship_mould_id, ship_mould.skill_name))
		end
		if Text_dingwei ~= nil then
			Text_dingwei:setString(dms.string(dms["ship_mould"], ship_mould_id, ship_mould.skill_describe))
		end
	end
end

function BossIntroduce:playCloseAtion( ... )











end

function BossIntroduce:onUpdate(dt)
	if self._role_diaglog == nil then
		local _role_diaglog = fwin:find("RoleDialogueClass")
	    if _role_diaglog ~= nil then
	        _role_diaglog:setVisible(false)
	        self._role_diaglog = _role_diaglog
	    end
	end
end

function BossIntroduce:onInit()
	local csbItem = csb.createNode("battle/battle_boss_xx.csb")
	local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbItem)
    local action = csb.createTimeline("battle/battle_boss_xx.csb")
  	table.insert(self.actions, action)
    csbItem:runAction(action)

    action:play("window_open",false)

    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_open_over" then
        	fwin._close_touch_end_event = false
		    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_223"),  nil,
		    {
		        terminal_name = "boss_introduce_close",
		        terminal_state = 0,
		        isPressedActionEnabled = true
		    },
		    nil, 0)
        end

    end)
	self:onUpdateDraw()

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        if zstring.tonumber(self.ship_music) > 0 then
        	self.musicId = playEffectMusic(self.ship_music)

        end
    end

    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    	local time = dms.int(dms["copy_config"],4,copy_config.param)
    	root:runAction(cc.Sequence:create(cc.DelayTime:create(time),
            cc.CallFunc:create(function ()
                   state_machine.excute("boss_introduce_close", 0, "")
                end
            )))
    end
end

function BossIntroduce:playBossWaring( ... )
	local jsonFile = "sprite/sprite_waring.json"
    local atlasFile = "sprite/sprite_waring.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	sp.initArmature(animation, true)

    local function changeActionCallback( armatureBack )
		animation._self:onInit()
		armatureBack:removeFromParent(true)
    end

    animation._self = self
    animation._invoke = changeActionCallback
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)

    local fsize = cc.size((fwin._width - app.baseOffsetX), (fwin._height - app.baseOffsetY))
    animation:setPosition(cc.p(fsize.width / 2, fsize.height / 2))

    self:setContentSize(fsize)
    self:setTouchEnabled(true)

    self:addChild(animation)
    playEffectMusic(9979)
end

function BossIntroduce:init(ship_mould_id)
	if type(ship_mould_id) == "table" then
		self.ship_mould_id = ship_mould_id[1]
		self.ship_evo_mould = ship_mould_id[2]
		self.ship_music = ship_mould_id[3]
	else
		self.ship_mould_id = ship_mould_id
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        self:playBossWaring()
    else
		self:onInit()
	end
end
function BossIntroduce:onExit()
	state_machine.remove("boss_introduce_close", 0, "")

	stopEffect()
	stopEffectEx(self.musicId)

end