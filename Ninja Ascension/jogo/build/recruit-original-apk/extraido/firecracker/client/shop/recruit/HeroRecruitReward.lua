HeroRecruitReward = class("HeroRecruitRewardClass", Window)

local hero_recruit_reward_window_open_terminal = {
    _name = "hero_recruit_reward_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("HeroRecruitRewardClass") == nil then
            fwin:open(HeroRecruitReward:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local hero_recruit_reward_window_close_terminal = {
    _name = "hero_recruit_reward_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroRecruitRewardClass"))
        _ED.random_Patch = {}
        _ED.new_prop_object = {}
        _ED.recruit_success_ship_id = nil
        _ED.new_reward_object = {}
        _ED.prop_chest_store_recruiting = true
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(hero_recruit_reward_window_open_terminal)
state_machine.add(hero_recruit_reward_window_close_terminal)
state_machine.init()

function HeroRecruitReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    app.load("client.l_digital.cultivate.matrix.AlloyMatrixGetReword")

    local function init_hero_recruit_reward_terminal()
        local hero_recruit_reward_request_terminal = {
            _name = "hero_recruit_reward_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local need_silver = dms.int(dms["partner_bounty_param"],9,partner_bounty_param.spend_silver)
                local m_type = 4
                need_silver = need_silver*10
                if instance.m_type and instance.m_type == 6 then
                    local max_num = zstring.splits(dms.string(dms["ship_config"], 41, ship_config.param), "|", ",")
                    need_silver = dms.int(dms["partner_bounty_param"], max_num[3][1], partner_bounty_param.spend_silver)
                    m_type = 6
                end
                if need_silver > tonumber(_ED.user_info.user_silver) then
                    app.load("client.packs.hero.HeroPatchInformationPageGetWay")
                    local fightWindow = HeroPatchInformationPageGetWay:new()
                    fightWindow:init(0, 6)
                    fwin:open(fightWindow, fwin._windows)
                    return
                end
                local function tenrecruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                    _ED.prop_chest_store_recruiting = false
                    state_machine.excute("alloy_matrix_get_reword_update", 0, "")
                end
                _ED.random_Patch = {}
                _ED.new_prop_object = {}
                _ED.recruit_success_ship_id = nil
                _ED.new_reward_object = {}
                _ED.prop_chest_store_recruiting = true
                protocol_command.ship_batch_bounty.param_list = m_type
                NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, instance, tenrecruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(hero_recruit_reward_request_terminal)
        state_machine.init()
    end
    init_hero_recruit_reward_terminal()
end

function HeroRecruitReward:onUpdateDraw()
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Panel_15"):setVisible(false)
    local ScrollView_41 = ccui.Helper:seekWidgetByName(root, "ScrollView_41")
    local Panel_head_icon = ccui.Helper:seekWidgetByName(root, "Panel_head_icon")
    ScrollView_41:removeAllChildren(true)
    ScrollView_41:setAnchorPoint(cc.p(0, 0))
    self.reward_info = {}

    local index = 1
    for i=1, #_ED.random_Patch do
        local m_datas = {}
        local isSame = false
        if tonumber(_ED.new_reward_object[index].m_type) == 6 then
            local user_prop_template = _ED.user_prop["".._ED.new_reward_object[index].mould_id].user_prop_template
            local prop_ship = dms.int(dms["prop_mould"], user_prop_template, prop_mould.use_of_ship)
            if zstring.tonumber(prop_ship) > 0 then
                local ships = fundShipWidthTemplateId(tonumber(prop_ship))
                if ships ~= nil then
                    local m_starRating = dms.int(dms["ship_mould"], tonumber(prop_ship), ship_mould.ship_star)
                    local number_info = zstring.split(dms.string(dms["ship_config"], 13, ship_config.param),"!")[tonumber(m_starRating)]
                    local ability = dms.int(dms["ship_mould"], tonumber(prop_ship), ship_mould.ability)
                    local number_data = zstring.split(number_info,"|")[ability-13+1]
                    local split_or_merge_count = tonumber(zstring.split(number_data,",")[2])
                    if split_or_merge_count > 0 and split_or_merge_count <= tonumber(_ED.new_reward_object[index].number) then
                        m_datas.m_type = 13
                        m_datas.random = prop_ship
                        m_datas.number = _ED.new_reward_object[index].number
                        m_datas.prop_random = _ED.new_reward_object[index].mould_id
                        m_datas.isSame = 1
                        isSame = true
                    end
                end
            end
            if isSame == false then
                m_datas.m_type = 6
                m_datas.random = _ED.new_reward_object[index].mould_id
                m_datas.number = _ED.new_reward_object[index].number
            end
            m_datas.bounty_hero_param_id = _ED.random_Patch[i].bounty_hero_param_id
            table.insert(self.reward_info, m_datas)
            index = index + 1
        elseif tonumber(_ED.new_reward_object[index].m_type) == 7 then
            m_datas.m_type = 7
            m_datas.random = _ED.new_reward_object[index].mould_id
            m_datas.number = _ED.new_reward_object[index].number
            table.insert(self.reward_info, m_datas)
            index = index + 1
        elseif tonumber(_ED.new_reward_object[index].m_type) == 1 then
            m_datas.m_type = 1
            m_datas.random = _ED.new_reward_object[index].mould_id
            m_datas.number = _ED.new_reward_object[index].number
            table.insert(self.reward_info, m_datas)
            index = index + 1
        elseif tonumber(_ED.new_reward_object[index].m_type) == 66 then
            m_datas.m_type = 66
            m_datas.random = _ED.new_reward_object[index].mould_id
            m_datas.number = _ED.new_reward_object[index].number
            table.insert(self.reward_info, m_datas)
            index = index + 1
        elseif tonumber(_ED.new_reward_object[index].m_type) == 67 then
            m_datas.m_type = 67
            m_datas.random = _ED.new_reward_object[index].mould_id
            m_datas.number = _ED.new_reward_object[index].number
            table.insert(self.reward_info, m_datas)
            index = index + 1
        end
    end

    local panel = ScrollView_41:getInnerContainer()
    panel:setContentSize(ScrollView_41:getContentSize())
    panel:setPosition(cc.p(0, 0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local tHeight = 0
    local tWidth = 0
    local wPosition = sSize.width/5
    local Hlindex = 0
    local m_number = 20
    local cellHeight = 0
    local cellWidth = 0
    index = 0
    cellHeight = m_number*(ScrollView_41:getContentSize().width/5)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(ScrollView_41:getContentSize().width, sHeight)
    ScrollView_41:jumpToTop()
    local function addReward( sender )
        if index >= self.max_num then
            local need_silver = dms.int(dms["partner_bounty_param"],9,partner_bounty_param.spend_silver)
            local m_type = 4
            need_silver = need_silver*10
            if self.m_type and self.m_type == 6 then
                local max_num = zstring.splits(dms.string(dms["ship_config"], 41, ship_config.param), "|", ",")
                need_silver = dms.int(dms["partner_bounty_param"], max_num[3][1], partner_bounty_param.spend_silver)
                m_type = 6
            end
            ccui.Helper:seekWidgetByName(root, "Label_36610"):setString(tostring(need_silver))
            ccui.Helper:seekWidgetByName(root, "Panel_15"):setVisible(true)
            return
        end
        playEffect(formatMusicFile("effect", 9988))
        index = index + 1
        local info = self.reward_info[index]
        local cell = nil
        if tonumber(info.m_type) == 13 then
            local ship_id = info.random
            local bounty_hero_param_id = info.bounty_hero_param_id
            cell = ResourcesIconCell:createCell()
            cell:init(info.m_type, tonumber(info.number), ship_id,nil,nil,true,true,0)
            cell:updateStarInfo(bounty_hero_param_id)
        elseif tonumber(info.m_type) == 6 then
            local prop = _ED.user_prop[""..info.random]
            cell = ResourcesIconCell:createCell()
            cell:init(6, tonumber(info.number), prop.user_prop_template,nil,nil,true,true,0)
        elseif tonumber(info.m_type) == 7 then
            local equip = _ED.user_equiment[""..info.random]
            cell = ResourcesIconCell:createCell()
            cell:init(info.m_type, tonumber(info.number), equip.user_equiment_template, nil, nil, true, true, 0)
        elseif tonumber(info.m_type) == 1 then
            cell = ResourcesIconCell:createCell()
            cell:init(info.m_type, tonumber(info.number), -1, nil, nil, true, true, 0)
        elseif tonumber(info.m_type) == 66 then
            --合金
            local equip = _ED.user_alloy_matrix[info.random]
            cell = ResourcesIconCell:createCell()
            cell:init(info.m_type, tonumber(info.number), equip.metalMould, nil, nil, false, true, 1)
        elseif tonumber(info.m_type) == 67 then
            cell = ResourcesIconCell:createCell()
            cell:init(info.m_type, tonumber(info.number), -1, nil, nil, true, true, 0)
        end

        panel:addChild(cell)
        tWidth = tWidth + wPosition
        if (index - 1)%5 == 0 then
            Hlindex = Hlindex + 1
            tWidth = 0
            tHeight = sHeight - wPosition * Hlindex
            if Hlindex >= 20 then
                ScrollView_41:scrollToPercentVertical(100, 0, false)
            elseif Hlindex >= 18 then
                ScrollView_41:scrollToPercentVertical((Hlindex - 5/Hlindex)*100/m_number, 0, false)
            elseif Hlindex >= 3 then
                ScrollView_41:scrollToPercentVertical((Hlindex - 8/Hlindex)*100/m_number, 0, false)
            end
        end
        if index <= 5 then
            tHeight = sHeight - wPosition
        end
        -- cell:setPosition(cc.p(sSize.width/2 - cell:getContentSize().width/2, tHeight + 600 * 10/Hlindex))
        cell:setPosition(cc.p(tWidth, tHeight))
        cell:setScale(0.1)
        local seq = cc.Sequence:create(
            cc.ScaleTo:create(0.12, 1.2),
            cc.ScaleTo:create(0.02, 1),
            -- cc.Spawn:create(cc.ScaleTo:create(0.12, 1)),
            -- cc.MoveTo:create(0.12, cc.p(tWidth, tHeight))),
            cc.CallFunc:create(addReward)
         )
        cell:runAction(seq)
    end
    addReward(self)
end

function HeroRecruitReward:onUpdate(dt) 
end

function HeroRecruitReward:onInit()
    local csbItem = csb.createNode("shop/recruit_settlement_shici_hundred.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_36550"), nil, 
    {
        terminal_name = "hero_recruit_reward_request", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_36551"), nil, 
    {
        terminal_name = "hero_recruit_reward_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    if (self.m_type and self.m_type == 6) then
        self:onUpdateDraw()
    else
        playEffect(formatMusicFile("effect", 9983))
        local function changeActionCallback( armatureBack ) 
            self:onUpdateDraw()
            armatureBack:removeFromParent(true)
        end

        local Panel_zhaomu_open = ccui.Helper:seekWidgetByName(root, "Panel_zhaomu_open")
        Panel_zhaomu_open:removeAllChildren(true)
        
        if __lua_project_id == __lua_project_l_naruto then
            local animation = draw.createEffect("sprite_fudan", "sprite/sprite_fudan.ExportJson", Panel_zhaomu_open, -1, nil, nil, cc.p(0.5, 0.5))
            animation._invoke = changeActionCallback
            csb.animationChangeToAction(animation, 0, 0, false)
        else
            -- local jsonFile = (self.m_type and self.m_type == 6) and "images/ui/effice/effect_hjcqcq/effect_hjcqcq.json" or "sprite/sprite_fudan.json"
            -- local atlasFile = (self.m_type and self.m_type == 6) and "images/ui/effice/effect_hjcqcq/effect_hjcqcq.atlas" or "sprite/sprite_fudan.atlas"
            local jsonFile = "sprite/sprite_fudan.json"
            local atlasFile = "sprite/sprite_fudan.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            animation.animationNameList = {"animation"}
            sp.initArmature(animation, false)
            animation._invoke = changeActionCallback
            Panel_zhaomu_open:addChild(animation)
            animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            csb.animationChangeToAction(animation, 0, 0, false)
        end
    end
end

function HeroRecruitReward:init(params)
    self.m_type = params
    self.max_num = 100
    if self.m_type then
        self.max_num = 50
    end
    self:onInit()
    return self
end

function HeroRecruitReward:onExit()
    state_machine.remove("hero_recruit_reward_request")
end