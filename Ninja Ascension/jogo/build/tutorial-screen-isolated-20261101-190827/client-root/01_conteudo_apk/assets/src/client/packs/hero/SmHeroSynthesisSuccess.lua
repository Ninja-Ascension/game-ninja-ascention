-- ----------------------------------------------------------------------------------------------------
-- 说明：卡牌合成成功
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

SmHeroSynthesisSuccess = class("SmHeroSynthesisSuccessClass", Window)
    
function SmHeroSynthesisSuccess:ctor()
    self.super:ctor()
    app.load("client.cells.ship_picture_cell_ten")
    app.load("client.cells.prop.sm_packs_cell")
    app.load("client.cells.ship.ship_head_new_cell")
    app.load("client.shop.recruit.SmGeneralsCard")
    self.roots = {}
    self.actions = {}
    self.zhanjiangling = 0
    self.ship = nil
    self.ranking = 0
    self.mIndex = 0
    self.HeronumberGod = 0

    self.play_types = 0
    self.hero_state = false
    self.hero_animation = nil

    self.isSame = false
    -- Initialize SmHeroSynthesisSuccess page state machine.
    local function init_SmHeroSynthesisSuccess_terminal()
        --返回
        local hero_synthesis_success_renturn_shop_page_terminal = {
            _name = "hero_synthesis_success_renturn_shop_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED.recruit_success_ship_id = ""
                fwin:close(instance)
                fwin:find("DrawRareRewardClass"):setVisible(true)
                state_machine.excute("home_hero_refresh_draw", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --播放攻击动画
        local hero_synthesis_success_play_hero_animation_terminal = {
            _name = "hero_synthesis_success_play_hero_animation",
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
         --卡牌点击
        local hero_synthesis_success_crad_click_on_terminal = {
            _name = "hero_synthesis_success_crad_click_on",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.actions[1]:play("open1_2", false)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Image_shop_bg"):setTouchEnabled(false)

                instance.actions[1]:setFrameEventCallFunc(function (frame)
                    if nil == frame then
                        return
                    end
                    local str2 = frame:getEvent()
                    if str2 == "open1_over" then
                        -- ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root, "Panel_icon"):setVisible(false)
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Text_name"):setVisible(false)
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Button_36550"):setVisible(true)
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Button_36551"):setVisible(true)
                        -- Panel_head_card:setVisible(false)
                        -- ccui.Helper:seekWidgetByName(heroInfoRoot, "Panel_lwj_2"):setSwallowTouches(false)
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_zhedang"):setTouchEnabled(false)
                        ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_zhedang"):setVisible(false)

                        local heroInfoRoot = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_23"):getChildByName("ProjectNode_1"):getChildByName("root")
                        table.insert(self.roots, heroInfoRoot)
                        local Panel_32=  ccui.Helper:seekWidgetByName(heroInfoRoot, "Button_ok")
                        fwin:addTouchEventListener(Panel_32, nil, 
                            {
                                terminal_name = "hero_synthesis_success_renturn_shop_page", 
                                terminal_state = 0, 
                                _action = instance.actions[1],
                            },
                            nil,0)

                    end
                end)
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(hero_synthesis_success_renturn_shop_page_terminal)
        state_machine.add(hero_synthesis_success_play_hero_animation_terminal)
        state_machine.add(hero_synthesis_success_crad_click_on_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_SmHeroSynthesisSuccess_terminal()
end

function SmHeroSynthesisSuccess:loadEffectFile(fileIndex)
    local fileName = string.format("effect/effice_%d.ExportJson", fileIndex)
    -- ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(fileName)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
    local armatureName = string.format("effice_%d", fileIndex)
    return armatureName, fileName
end

function SmHeroSynthesisSuccess:createEffect(fileIndex, fileNameFormat)
    -- 创建光效
    local armature = nil
    if animationMode == 1 then
        -- armature = sp.spine_sprite(self, self._brole._head, spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        -- armature.animationNameList = spineAnimations
        -- sp.initArmature(armature, true)
        armature = sp.spine_effect(fileIndex, effectAnimations[1], false, nil, nil, nil, nil, nil, nil, fileNameFormat)
        armature.animationNameList = effectAnimations
        sp.initArmature(armature, true)
    else
        local armatureName, fileName = self:loadEffectFile(fileIndex)
        armature = ccs.Armature:create(armatureName)
        armature._fileName = fileName
    end
    -- table.insert(self.animationList, {fileName = fileName, armature = armature})
    local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
    -- local _tcamp = zstring.tonumber(""..self.roleCamp)
    local _armatureIndex = 0 -- frameListCount * _tcamp
    armature:getAnimation():playWithIndex(_armatureIndex)
    armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
    -- armature:getAnimation():setSpeedScale(1.0 / __fight_recorder_action_time_speed)
    
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

function SmHeroSynthesisSuccess:setRanking()
    
end
function SmHeroSynthesisSuccess:changeHeroAnimation(play_types)
    self.play_types = play_types
    csb.animationChangeToAction(self.hero_animation, play_types, play_types, false)
end
function SmHeroSynthesisSuccess:ShowUI()

    local csbSmHeroSynthesisSuccess = csb.createNode("shop/recruit_settlement_ten.csb")
    local csbSmHeroSynthesisSuccess_root = csbSmHeroSynthesisSuccess:getChildByName("root")
    local action = csb.createTimeline("shop/recruit_settlement_ten.csb")
    table.insert(self.roots, csbSmHeroSynthesisSuccess_root)
    table.insert(self.actions, action)

    self:addChild(csbSmHeroSynthesisSuccess)
    for i,v in pairs(_ED.user_ship) do
        if _ED.recruit_success_ship_id == v.ship_id then
            self.ship = v
        end
    end
    playEffect(formatMusicFile("effect", 9982))

    ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root,"Panel_yc"):setVisible(false)
    -- ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root, "Panel_icon"):setVisible(false)
    ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root, "Text_name"):setVisible(false)
    ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root, "Button_36550"):setVisible(false)
    ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root, "Button_36551"):setVisible(false)
    local Panel_36549_1 = ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root, "Panel_danci")
    Panel_36549_1:removeAllChildren(true)

    --进化形象
    local evo_image = dms.string(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local ship_evo = zstring.split(self.ship.evolution_status, "|")
    local evo_mould_id = evo_info[tonumber(ship_evo[1])]
    --新的形象编号
    local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

    draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_36549_1, nil, nil, cc.p(0.5, 0))
    app.load("client.battle.fight.FightEnum")
    local hero_animation = sp.spine_sprite(Panel_36549_1, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
    hero_animation:setScaleX(-1)
    self.hero_animation = hero_animation
    self.play_types = 38
    hero_animation.animationNameList = spineAnimations
    sp.initArmature(hero_animation, true)
    hero_animation._self = self
    local function changeActionCallback( armatureBack ) 
        if armatureBack._self ~= nil and armatureBack._self.roots ~= nil and armatureBack._self.roots[1] ~= nil then
            local play_types = armatureBack._self.play_types
            local hero_state = armatureBack._self.hero_state
            if play_types == 14 then
                state_machine.excute("hero_synthesis_success_play_hero_animation",0,15)
            elseif play_types == 38 then
                state_machine.excute("hero_synthesis_success_play_hero_animation",0,14)
            elseif play_types == 15 then
                state_machine.excute("hero_synthesis_success_play_hero_animation",0,0)
                hero_state = true
            elseif play_types == 0 and hero_state == true then
                armatureBack._invoke = nil
            end
        end
    end
    
    hero_animation:getAnimation():setFrameEventCallFunc(onFrameEventRole)
    hero_animation._invoke = changeActionCallback
    hero_animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(hero_animation, self.play_types, self.play_types, false)

    local Panel_head_card = ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root,"Panel_card_icon")
    local Panel_bg = ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root,"Panel_bg")
    Panel_bg:removeAllChildren(true)

    action:play("open1", false)
    csbSmHeroSynthesisSuccess:runAction(action)
    action:setFrameEventCallFunc(function (frame)

        if nil == frame then
            return
        end
        local str1 = frame:getEvent()
        if str1 == "open" then
        elseif str1 == "Panel_card_icon_open" then
            local jsonFile = "sprite/sprite_zhaomubg.json"
            local atlasFile = "sprite/sprite_zhaomubg.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            Panel_bg:addChild(animation)

            -- local heroInfoRoot = ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root, "Panel_23"):getChildByName("ProjectNode_1"):getChildByName("root")
            -- local Panel_bggx = ccui.Helper:seekWidgetByName(heroInfoRoot,"Panel_bggx")
            -- Panel_bggx:removeAllChildren(true)
            local jsonFile = "sprite/sprite_zhaomubg_2.json"
            local atlasFile = "sprite/sprite_zhaomubg_2.atlas"
            local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            Panel_bg:addChild(animation2)
            
            Panel_head_card:removeAllChildren(true)
            Panel_head_card:setVisible(true)
            state_machine.excute("sm_generals_card_open",0,{Panel_head_card,false,true,self.ship.ship_id,false})
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                local animation = draw.createEffect("effect_shop_light", "images/ui/effice/effect_shop_light/effect_shop_light.ExportJson", Panel_head_card, -1, nil, nil, cc.p(0.5, 0.5))
                animation._invoke = changeActionCallback
                csb.animationChangeToAction(animation, 0, 0, false)
            end
            ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root,"Panel_zh"):setVisible(false)

            local Panel_32 = ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root, "Image_shop_bg")
            Panel_32:setTouchEnabled(true)
            ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root, "Panel_zhedang"):setTouchEnabled(false)
            ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root, "Panel_zhedang"):setVisible(false)

        elseif str1 == "Panel_card_icon_close_2" then
            -- Panel_head_card:setVisible(false)
        elseif str1 == "close_suipian" then
            ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root,"Panel_zh"):setVisible(false)
        elseif str1 == "open1_over" then
            
        end
    end)
    
    local heroInfoRoot = ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root, "Panel_23"):getChildByName("ProjectNode_1"):getChildByName("root")
    ccui.Helper:seekWidgetByName(heroInfoRoot, "Panel_lwj_2"):setSwallowTouches(false)
    ccui.Helper:seekWidgetByName(heroInfoRoot, "Panel_lwj_2"):setTouchEnabled(false)
    ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root, "Image_12"):setSwallowTouches(false)
    ccui.Helper:seekWidgetByName(csbSmHeroSynthesisSuccess_root, "Image_12"):setTouchEnabled(false)
    --武将定位
    local Text_dingwei_m = ccui.Helper:seekWidgetByName(heroInfoRoot, "Text_dingwei_m")
    --进化形象
    local evo_image = dms.string(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    -- local ship_evo = zstring.split(self.ship.evolution_status, "|")
    local evo_mould_id = evo_info[dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.captain_name)]
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.position_index)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    local location = word_info[3]
    Text_dingwei_m:setString(location)
    

    --技能
    local Panel_skill_icon = ccui.Helper:seekWidgetByName(heroInfoRoot, "Panel_skill_icon")
    Panel_skill_icon:removeAllChildren(true)
    --进化的天赋技能
    local talent = dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index)
    local talentData = zstring.split(talent, "|")
    local skillData = zstring.split(talentData[2], ",")
    --天赋模板id
    local talentMouldid = skillData[3]
    local pic_index = dms.int(dms["talent_mould"], talentMouldid, talent_mould.new_skill_pic)
    local skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", pic_index))
    --测试临时的图,正式的时候换成上面的代码
    --local skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", 1))
    if skill_icon ~= nil then
        skill_icon:setPosition(cc.p(Panel_skill_icon:getContentSize().width/2,Panel_skill_icon:getContentSize().height/2))
        Panel_skill_icon:addChild(skill_icon)
    end
    local skillNameId = dms.int(dms["talent_mould"], talentMouldid, talent_mould.talent_name)
    local word_info = dms.element(dms["word_mould"], skillNameId)
    local skillName = word_info[3]
    skillName = skillDescriptionReplaceData(talentMouldid,tonumber(self.ship.ship_template_id),1,1,false)
    local Text_skill_name = ccui.Helper:seekWidgetByName(heroInfoRoot, "Text_skill_name")
    Text_skill_name:setString(skillName)

    -- 角色名称和资质
    local Text_1 = ccui.Helper:seekWidgetByName(heroInfoRoot, "Text_1")
    local Panel_quality_hero = ccui.Helper:seekWidgetByName(heroInfoRoot, "Panel_quality_hero")
    if Text_1 and Panel_quality_hero then
        local ship_template_id = self.ship.ship_template_id
        local name_info = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local name_txt = dms.element(dms["word_mould"], name_info)[3]
        Text_1:setString(name_txt)
        Panel_quality_hero:removeBackGroundImage()

        local ability_img = dms.int(dms["ship_mould"], ship_template_id, ship_mould.ability)
        Panel_quality_hero:setBackGroundImage(string.format("image/recruit/recruit_quality_%d.png", ability_img))
        local star = dms.int(dms["ship_mould"], ship_template_id, ship_mould.ship_star)
        if _ED.random_Patch ~= nil 
            and _ED.random_Patch[1] ~= nil 
            and zstring.tonumber(_ED.random_Patch[1].bounty_hero_param_id) > 0 
            then
            local rewards = dms.string(dms["bounty_hero_param"], zstring.tonumber(_ED.random_Patch[1].bounty_hero_param_id), bounty_hero_param.rewards)
            if rewards ~= nil then
                rewards = zstring.split(rewards, ",")
                if zstring.tonumber(rewards[4]) > 0 then
                    star = zstring.tonumber(rewards[4])
                end
            end
        end
        -- 星级
        for i=1,6 do
            local Image_2_x = ccui.Helper:seekWidgetByName(heroInfoRoot, "Image_2_"..i)
            if star >= i then 
                Image_2_x:setVisible(true)
            else
                Image_2_x:setVisible(false)
            end
        end
    end

    --描述
    local Text_skill_infor = ccui.Helper:seekWidgetByName(heroInfoRoot, "Text_skill_infor")
    local skill_describe_id = dms.string(dms["talent_mould"], talentMouldid, talent_mould.talent_describe)
    local word_info = dms.element(dms["word_mould"], skill_describe_id)
    local skill_describe = word_info[3]
    skill_describe = skillDescriptionReplaceData(talentMouldid,tonumber(self.ship.ship_template_id),1,2,false)
    Text_skill_infor:setString(skill_describe)
    local ms_ScrollView = ccui.Helper:seekWidgetByName(heroInfoRoot, "ScrollView_1")
    if ms_ScrollView ~= nil then
        --计算text的高度
        local textRenderSize = Text_skill_infor:getAutoRenderSize() -- 未换行前尺寸
        local VirtualRendererSize = Text_skill_infor:getVirtualRendererSize() -- 控件本身可渲染尺寸
        local needRowNumber = math.ceil(textRenderSize.width / VirtualRendererSize.width)
        local currRowNumber = math.floor(VirtualRendererSize.height / textRenderSize.height)
        local curHeight = 0
        if needRowNumber > currRowNumber then
            curHeight = (needRowNumber - currRowNumber) * textRenderSize.height + Text_skill_infor:getFontSize()
        end
        -- local _,count = string.gsub(skill_describe, "[^\128-\193]", "")  
        -- local text_height = math.ceil((count*Text_skill_infor:getFontSize())/Text_skill_infor:getContentSize().width)*(Text_skill_infor:getFontSize()+8)
        local text_height = VirtualRendererSize.height + curHeight
        Text_skill_infor:setContentSize(cc.size(Text_skill_infor:getContentSize().width , text_height))
        ms_ScrollView:setInnerContainerSize(cc.size(ms_ScrollView:getContentSize().width, text_height))
        Text_skill_infor:setPositionY(text_height)
        local Image_jiantou = ccui.Helper:seekWidgetByName(heroInfoRoot, "Image_jiantou")
        if Image_jiantou ~= nil then
            if ms_ScrollView:getContentSize().height >= text_height then
                Image_jiantou:setVisible(false)
            else
                Image_jiantou:setVisible(true)
                function blinkOutCallback(sender)
                    imageActivty()
                end
                function imageActivty( ... )
                    Image_jiantou:runAction(cc.Sequence:create(
                        cc.FadeTo:create(0.3, 255),
                        cc.FadeTo:create(0.3, 0),
                        cc.CallFunc:create(blinkOutCallback)
                        ))
                end
                imageActivty()
            end
        end
    end
end

function SmHeroSynthesisSuccess:onEnterTransitionFinish()
    self:ShowUI()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Image_shop_bg"), nil, {
        terminal_name = "hero_synthesis_success_crad_click_on", 
        terminal_state = 0
        }, nil, 2)
end

function SmHeroSynthesisSuccess:onExit()

end

function SmHeroSynthesisSuccess:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
          sp.SkeletonRenderer:clear()
    end     
    cacher.removeAllTextures()     
    audioUtilUncacheAll() 
end