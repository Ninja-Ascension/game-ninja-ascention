-- ----------------------------------------------------------------------------------------------------
-- 说明：角色进化成功
-------------------------------------------------------------------------------------------------------
GeneralsEvoSuccessWindow = class("GeneralsEvoSuccessWindowClass", Window)

local generals_evo_success_window_open_terminal = {
    _name = "generals_evo_success_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("GeneralsEvoSuccessWindowClass")
        if nil == _homeWindow then
            local panel = GeneralsEvoSuccessWindow:new():init(params)
            fwin:open(panel, fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local generals_evo_success_window_close_terminal = {
    _name = "generals_evo_success_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        smFightingChange()
		local _homeWindow = fwin:find("GeneralsEvoSuccessWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("GeneralsEvoSuccessWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(generals_evo_success_window_open_terminal)
state_machine.add(generals_evo_success_window_close_terminal)
state_machine.init()
    
function GeneralsEvoSuccessWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship = nil
    self.isEvo = false

    self.play_types = 0
    self.hero_state = false

    local function init_generals_evo_success_window_terminal()
        -- 显示界面
        local generals_evo_success_window_display_terminal = {
            _name = "generals_evo_success_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local generals_evo_success_window_hide_terminal = {
            _name = "generals_evo_success_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --播放攻击动画
        local generals_evo_success_play_hero_animation_terminal = {
            _name = "generals_evo_success_play_hero_animation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:changeHeroAnimation(params)
                end
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(generals_evo_success_window_display_terminal)
        state_machine.add(generals_evo_success_window_hide_terminal)
        state_machine.add(generals_evo_success_play_hero_animation_terminal)
        
        state_machine.init()
    end
    init_generals_evo_success_window_terminal()
end

function GeneralsEvoSuccessWindow:changeHeroAnimation(play_types)
    self.play_types = play_types
    csb.animationChangeToAction(self.hero_animation, play_types, play_types, false)
end

function GeneralsEvoSuccessWindow:getSkillAnimationIndex()
    return 15,nil
end

function GeneralsEvoSuccessWindow:loadEffectFile(fileIndex)
    local fileName = string.format("effect/effice_%d.ExportJson", fileIndex)
    -- ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(fileName)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
    local armatureName = string.format("effice_%d", fileIndex)
    return armatureName, fileName
end

function GeneralsEvoSuccessWindow:createEffect(fileIndex, fileNameFormat)
    -- 创建光效
    local armature = nil
    if animationMode == 1 then
        armature = sp.spine_effect(fileIndex, effectAnimations[1], false, nil, nil, nil, nil, nil, nil, fileNameFormat)
        armature.animationNameList = effectAnimations
        sp.initArmature(armature, true)
    else
        local armatureName, fileName = self:loadEffectFile(fileIndex)
        armature = ccs.Armature:create(armatureName)
        armature._fileName = fileName
    end
    local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
    local _armatureIndex = 0 -- frameListCount * _tcamp
    armature:getAnimation():playWithIndex(_armatureIndex)
    armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
    
    local duration = zstring.tonumber(dms.int(dms["duration"], fileIndex, 1))
    armature._duration = duration / 60.0
    return armature
end

local function checkFrameEvent(events, mode)
    if events ~= n and #events > 0 then
        for i, v in pairs(events) do
            if v == mode then
                return true
            end
        end
    end
    return false
end

local function onFrameEventRole(bone,evt,originFrameIndex,currentFrameIndex)
    local armature = bone:getArmature()
    local _self = armature._self
    local frameEvents = zstring.split(evt, "_")
    if checkFrameEvent(frameEvents, "union") == true then -- 启动角色镜头聚焦
        -- print("start union effect!")
        local effectIds = zstring.split(frameEvents[2], ",")
        for i, v in pairs(effectIds) do
            local function deleteEffectFile(armatureBack)
                if armatureBack == nil then
                    return
                end
                -- 删除光效
                armatureBack._LastsCountTurns = armatureBack._LastsCountTurns == nil and 0 or armatureBack._LastsCountTurns
                if armatureBack._LastsCountTurns <= 0 then
                    local fileName = armatureBack._fileName
                    if m_tOperateSystem == 5 then
                        if fileName ~= nil then
                            CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(fileName)
                        end
                    end
                        if armatureBack.getParent ~= nil then
                            if armatureBack:getParent() ~= nil then
                                if armatureBack.removeFromParent ~= nil then
                                    armatureBack:removeFromParent(true)
                                end
                            end
                        end
                    if m_tOperateSystem == 5 then
                        CCSpriteFrameCache:purgeSharedSpriteFrameCache()
                        CCTextureCache:sharedTextureCache():removeUnusedTextures()
                    end
                end
            end
            -- print("create union effect:", v)
            local armatureEffect = _self:createEffect(v, "sprite/effect_")
            armatureEffect._self = _self
            armatureEffect._invoke = deleteEffectFile

            local map = armature -- _self:getParent()
            map:addChild(armatureEffect)
        end
    end
end

function GeneralsEvoSuccessWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    self.animation_index,self.effic_id = self:getSkillAnimationIndex()      

    local shipInfo = _ED.user_ship[""..self.ship.ship_id]
    --进化模板id
    local ship_evo = zstring.split(shipInfo.evolution_status, "|")

    jttd.NewAPPeventSlogger("6|"..shipInfo.ship_template_id.."|"..ship_evo[1])
    local m_index = 1
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        m_index = 2
    end
    for i=1,2 do
        local Panel_evo_icon = ccui.Helper:seekWidgetByName(root,"Panel_evo_icon_"..i)
        Panel_evo_icon:setTouchEnabled(false)
        Panel_evo_icon:removeAllChildren(true)
    end
    for i=2, m_index, -1 do
        local Panel_evo_icon = ccui.Helper:seekWidgetByName(root,"Panel_evo_icon_"..i)
        Panel_evo_icon:setTouchEnabled(false)
        Panel_evo_icon:removeAllChildren(true)
        local quality = dms.int(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.ship_type)
        ----------------------新的数码的形象------------------------
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        local index = 0
        if i == 1 then
            index = tonumber(ship_evo[1])-1
        else
            index = tonumber(ship_evo[1])
        end
        local evo_mould_id = evo_info[index]
        --新的形象编号
        local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

        draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_evo_icon, nil, nil, cc.p(0.5, 0))
        app.load("client.battle.fight.FightEnum")
        local hero_animation = sp.spine_sprite(Panel_evo_icon, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        hero_animation:setScaleX(-1)
        if i==2 then
            self.hero_animation = hero_animation
            self.play_types = 14
        end
        hero_animation.animationNameList = spineAnimations
        sp.initArmature(hero_animation, true)
        hero_animation._self = self

        if i==2 then
            local function changeActionCallback( armatureBack ) 
                local play_types = armatureBack._self.play_types
                local hero_state = armatureBack._self.hero_state
                if play_types == 14 then
                    state_machine.excute("generals_evo_success_play_hero_animation",0,15)
                elseif play_types == 38 then
                    state_machine.excute("generals_evo_success_play_hero_animation",0,0)
                elseif play_types == 15 then
                    state_machine.excute("generals_evo_success_play_hero_animation",0,0)
                    hero_state = true
                elseif play_types == 0 and hero_state == true then
                    armatureBack._invoke = nil
                end
            end
            hero_animation:getAnimation():setFrameEventCallFunc(onFrameEventRole)
            hero_animation._invoke = changeActionCallback
            hero_animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            csb.animationChangeToAction(hero_animation, self.play_types, self.play_types, false)

            if self.effic_id ~= nil then
                local armature_effic = sp.spine_effect(self.effic_id, effectAnimations[1], false, nil, nil, nil)    
                self.armature_effic = armature_effic
                sp.initArmature(self.armature_effic, false)
                armature_effic.animationNameList = effectAnimations
                self.armature_effic:setVisible(false)
                hero_animation:addChild(armature_effic)
                local function changeActionEfficCallback( armatureBack )    
                    armatureBack:setVisible(false)
                end
                armature_effic._invoke = changeActionEfficCallback
                armature_effic:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)                     
            end

            if self.normal_effic_id ~= nil then
                local normal_armature_effic = sp.spine_effect(self.normal_effic_id, effectAnimations[1], false, nil, nil, nil)  
                self.normal_armature_effic = normal_armature_effic
                sp.initArmature(self.normal_armature_effic, false)
                normal_armature_effic.animationNameList = effectAnimations
                self.normal_armature_effic:setVisible(false)
                hero_animation:addChild(normal_armature_effic)
                local function changeActionEfficCallback( armatureBack )    
                    armatureBack:setVisible(false)
                end
                normal_armature_effic._invoke = changeActionEfficCallback
                normal_armature_effic:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  
            end

        end

        --画技能
        local talent = dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index)
        local talentData = zstring.split(talent, "|")

        local skillData = zstring.split(talentData[2], ",")
        --天赋模板id
        local talentMouldid = skillData[3]

        --画技能图标
        local Panel_skill_icon = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon_"..i)
        Panel_skill_icon:removeAllChildren(true)
        local skill_icon = nil
        local pic_index = dms.int(dms["talent_mould"], talentMouldid, talent_mould.new_skill_pic)
        skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", pic_index))
        --测试临时的图,正式的时候换成上面的代码
        --skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", i))
        if skill_icon ~= nil then
            skill_icon:setPosition(cc.p(Panel_skill_icon:getContentSize().width/2,Panel_skill_icon:getContentSize().height/2))
            Panel_skill_icon:addChild(skill_icon)
        end

        --技能名称
        local Text_skill_name = ccui.Helper:seekWidgetByName(root, "Text_skill_name_"..i)
        local skillNameId = dms.int(dms["talent_mould"], talentMouldid, talent_mould.talent_name)
        local word_info = dms.element(dms["word_mould"], skillNameId)
        local skillName = word_info[3]
        skillName = skillDescriptionReplaceData(talentMouldid,shipInfo.ship_template_id,2,1,false,index)
        Text_skill_name:setString(skillName)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            local Text_name_2_2 = ccui.Helper:seekWidgetByName(root, "Text_name_2_2")
            local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.position_index)
            local word_info = dms.element(dms["word_mould"], name_mould_id)
            local location = word_info[3]
            Text_name_2_2:setString(location)
        end
    end
    local Text_name_1 = ccui.Helper:seekWidgetByName(root, "Text_name_1")
    local Text_name_2 = ccui.Helper:seekWidgetByName(root, "Text_name_2")
    Text_name_1:setString(_new_interface_text[137])
    Text_name_2:setString(_new_interface_text[138])
end

function GeneralsEvoSuccessWindow:UpdateShowLoading()
    local root = self.roots[1]
    if root == nil then 
        return
    end

end
-- function GeneralsEvoSuccessWindow:showImageAnimation()
--     local root = self.roots[1]
--     if root == nil then 
--         return
--     end
--     local shipInfo = _ED.user_ship[""..self.ship_id]
--     if shipInfo == nil then
--         return
--     end

-- end

function GeneralsEvoSuccessWindow:init(params)
    self.ship = params[1]
    self:onInit()
    return self
end

function GeneralsEvoSuccessWindow:onInit()
    local csbGeneralsEvoSuccessWindow = csb.createNode("packs/HeroStorage/generals_evo_success_window.csb")
    local root = csbGeneralsEvoSuccessWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbGeneralsEvoSuccessWindow)

    local action = csb.createTimeline("packs/HeroStorage/generals_evo_success_window.csb")
    table.insert(self.actions, action)
    csbGeneralsEvoSuccessWindow:runAction(action)
    action:play("animation0", false)

	playEffect(formatMusicFile("effect", 9981))
    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Panel_bg"), nil, 
    {
        terminal_name = "generals_evo_success_window_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 3)

	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    -- {
        -- terminal_name = "red_alert_time_mine_help_info_close",
        -- terminal_state = 0,
    -- },
    -- nil,3)
	
end

function GeneralsEvoSuccessWindow:onExit()
    state_machine.remove("generals_evo_success_window_hide")
    state_machine.remove("generals_evo_success_window_display")

end