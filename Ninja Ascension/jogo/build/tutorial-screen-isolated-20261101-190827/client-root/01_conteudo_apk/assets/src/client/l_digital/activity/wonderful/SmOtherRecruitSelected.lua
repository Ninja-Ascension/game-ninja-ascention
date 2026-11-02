SmOtherRecruitSelected = class("SmOtherRecruitSelectedClass", Window)

local sm_other_recruit_selected_open_terminal = {
    _name = "sm_other_recruit_selected_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("SmOtherRecruitSelectedClass") == nil then
            fwin:open(SmOtherRecruitSelected:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_other_recruit_selected_close_terminal = {
    _name = "sm_other_recruit_selected_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmOtherRecruitSelectedClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_other_recruit_selected_open_terminal)
state_machine.add(sm_other_recruit_selected_close_terminal)
state_machine.init()

function SmOtherRecruitSelected:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._baseProp = nil
    self._actionIndex = 0
    self._groupPage = 0
    self._chooseIndex = 0

    local function init_sm_other_recruit_selected_terminal()
        local sm_other_recruit_selected_choose_terminal = {
            _name = "sm_other_recruit_selected_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("sm_other_recruit_selected_choose")
                instance._chooseIndex = params._datas._index

                local addition_group_index = dms.int(dms["prop_mould"], instance._baseProp.user_prop_template, prop_mould.addition_group_index)
                local rewardInfoString = dms.string(dms["scene_reward_ex"], addition_group_index, scene_reward_ex.show_reward)
                local rewardInfoArr = zstring.split(rewardInfoString, "|")
                local ship_id = zstring.split(rewardInfoArr[instance._chooseIndex], ",")[1]
                local evo_image = dms.string(dms["ship_mould"], ship_id, ship_mould.fitSkillTwo)
                local evo_info = zstring.split(evo_image, ",")
                local evo_mould_id = evo_info[dms.int(dms["ship_mould"], ship_id, ship_mould.captain_name)]
                local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
                local ship_name = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)

                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                tip:init(instance, instance.selectRequest, string.format(_new_interface_text[250], ship_name))
                fwin:open(tip, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_other_recruit_selected_choose_terminal)
        state_machine.init()
    end
    init_sm_other_recruit_selected_terminal()
end

function SmOtherRecruitSelected:selectRequest(n)
    if n == 0 then
        local addition_group_index = dms.int(dms["prop_mould"], self._baseProp.user_prop_template, prop_mould.addition_group_index)
        local rewardInfoString = dms.string(dms["scene_reward_ex"], addition_group_index, scene_reward_ex.show_reward)
        local rewardInfoArr = zstring.split(rewardInfoString, "|")
        local ship_id = zstring.split(rewardInfoArr[self._chooseIndex], ",")[1]
        local ships = fundShipWidthTemplateId(tonumber(ship_id))
        local isChange = true
        if ships == nil then
            isChange = false
        end
        local m_starRating = dms.int(dms["ship_mould"], tonumber(ship_id), ship_mould.ship_star)
        if zstring.tonumber(zstring.split(rewardInfoArr[self._chooseIndex], ",")[4]) ~= 0 then
            m_starRating = zstring.tonumber(zstring.split(rewardInfoArr[self._chooseIndex], ",")[4])
        end
        local number_info = zstring.split(dms.string(dms["ship_config"], 13, ship_config.param),"!")[tonumber(m_starRating)]
        local ability = dms.int(dms["ship_mould"], tonumber(ship_id), ship_mould.ability)
        local number_data = zstring.split(number_info,"|")[ability-13+1]
        local count = tonumber(zstring.split(number_data,",")[2])
        local function responseUsePropCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                local ships = fundShipWidthTemplateId(tonumber(ship_id))
                _ED.recruit_success_ship_id = ships.ship_id
                local obj = HeroRecruitSuccess:new()
                obj:setRanking(herorIndex, 5, false, isChange, count, m_starRating)
                fwin:open(obj, fwin._ui)

                local info = _ED.sm_activity_other_recruit_reward[self._groupPage][self._actionIndex]
                info.isChange = isChange
                info.reward = "13,"..ship_id..",1,"..m_starRating
                _ED.sm_activity_other_recruit_reward[self._groupPage][self._actionIndex] = info

                state_machine.unlock("sm_other_recruit_selected_choose")
                state_machine.excute("sm_other_recruit_selected_close", 0, nil)
            end
        end
        protocol_command.prop_use.param_list = self._baseProp.user_prop_id.."\r\n1\r\n"..self._chooseIndex
        NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, self, responseUsePropCallback,false, nil)
    else
        state_machine.unlock("sm_other_recruit_selected_choose")
    end
end

function SmOtherRecruitSelected:onUpdateDraw()
    local root = self.roots[1]
    local addition_group_index = dms.int(dms["prop_mould"], self._baseProp.user_prop_template, prop_mould.addition_group_index)
    local rewardInfoString = dms.string(dms["scene_reward_ex"], addition_group_index, scene_reward_ex.show_reward)
    local rewardInfoArr = zstring.split(rewardInfoString, "|")
    for i, v in pairs(rewardInfoArr) do
        local Panel_role_1_0 = ccui.Helper:seekWidgetByName(root, "Panel_role_"..i.."_0")
        local Panel_role_1 = ccui.Helper:seekWidgetByName(root, "Panel_role_"..i)
        Panel_role_1_0:removeAllChildren(true)
        Panel_role_1:removeAllChildren(true)

        local info = zstring.split(v, ",")
        local ship_id = tonumber(info[1])
        local evo_image = dms.string(dms["ship_mould"], ship_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        -- local ship_evo = zstring.split(self.ship.evolution_status, "|")
        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], ship_id, ship_mould.captain_name)]
        local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

        local camp_preference = dms.int(dms["ship_mould"], tonumber(ship_id), ship_mould.camp_preference)
        local animation_name = ""
        if camp_preference == 1 then            --攻击
            animation_name = "type_1"
        elseif camp_preference == 2 then        --防御
            animation_name = "type_2"
        elseif camp_preference == 3 then        --技能
            animation_name = "type_3"
        end
        local jsonFile = "sprite/spirte_type_di.json"
        local atlasFile = "sprite/spirte_type_di.atlas"
        local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, animation_name, true, nil)
        animation2:setPosition(cc.p(Panel_role_1_0:getContentSize().width/2,0))
        Panel_role_1_0:addChild(animation2)

        draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_role_1, nil, nil, cc.p(0.5, 0))
        app.load("client.battle.fight.FightEnum")
        local hero_animation = sp.spine_sprite(Panel_role_1, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        hero_animation.animationNameList = spineAnimations
        sp.initArmature(hero_animation, true)
        hero_animation._self = self
        hero_animation:getAnimation():setFrameEventCallFunc(onFrameEventRole)
    end
end

function SmOtherRecruitSelected:onInit()
    local csbItem = csb.createNode("activity/wonderful/sm_vip_chouka_2xuan1.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_1"), nil, 
    {
        terminal_name = "sm_other_recruit_selected_choose", 
        terminal_state = 0, 
        _index = 1,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_1_0"), nil, 
    {
        terminal_name = "sm_other_recruit_selected_choose", 
        terminal_state = 0, 
        _index = 2,
    }, nil, 3)

    self:onUpdateDraw()
end

function SmOtherRecruitSelected:init(params)
    self._baseProp = params[1]
    self._actionIndex = params[2]
    self._groupPage = params[3]
    self:onInit()
    return self
end

function SmOtherRecruitSelected:onExit()
    state_machine.remove("sm_other_recruit_selected_choose")
end