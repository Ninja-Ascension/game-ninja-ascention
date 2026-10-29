SmOtherRecruitReward = class("SmOtherRecruitRewardClass", Window)

local sm_other_recruit_reward_open_terminal = {
    _name = "sm_other_recruit_reward_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("SmOtherRecruitRewardClass") == nil then
            fwin:open(SmOtherRecruitReward:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_other_recruit_reward_close_terminal = {
    _name = "sm_other_recruit_reward_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        _ED.recruit_success_ship_id = nil
        fwin:close(fwin:find("SmOtherRecruitRewardClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_other_recruit_reward_open_terminal)
state_machine.add(sm_other_recruit_reward_close_terminal)
state_machine.init()

function SmOtherRecruitReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._index = 0
    self._currentPage = 0
    self._actionIndex = 0
    self.rewardCellList = {}

    self._isShowOther = false

    local function init_sm_other_recruit_reward_terminal()
        local sm_other_recruit_reward_request_terminal = {
            _name = "sm_other_recruit_reward_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local activity = _ED.active_activity[114]
                if activity == nil then
                    return
                end
                state_machine.lock("sm_other_recruit_reward_request")
                _ED.recruit_success_ship_id = nil
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node._isShowOther = false
                            response.node:onUpdateDraw()
                        else
                            state_machine.excute("sm_other_recruit_reward_open", 0, nil)
                        end
                    end
                    instance:runAction(cc.Sequence:create({cc.DelayTime:create(0.2), cc.CallFunc:create(function ( sender )
                        state_machine.unlock("sm_other_recruit_reward_request")
                    end)})
                    )
                end
                protocol_command.get_activity_reward.param_list = activity.activity_id.."\r\n"..(instance._index - 1).."\r\n0"
                NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_other_recruit_reward_change_page_terminal = {
            _name = "sm_other_recruit_reward_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._currentPage + params._datas.page < 0 then
                    return
                end
                if instance._currentPage + params._datas.page > #_ED.sm_activity_other_recruit_reward then
                    return
                end
                instance._currentPage = instance._currentPage + params._datas.page
                instance:changePage()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_other_recruit_reward_action_continue_terminal = {
            _name = "sm_other_recruit_reward_action_continue",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_other_recruit_reward_request_terminal)
        state_machine.add(sm_other_recruit_reward_change_page_terminal)
        state_machine.add(sm_other_recruit_reward_action_continue_terminal)
        state_machine.init()
    end
    init_sm_other_recruit_reward_terminal()
end

function SmOtherRecruitReward:updatePageButton( ... )
    local root = self.roots[1]
    local Button_left = ccui.Helper:seekWidgetByName(root, "Button_left"):setVisible(false)
    local Button_right = ccui.Helper:seekWidgetByName(root, "Button_right"):setVisible(false)
    Button_left:setVisible(false)
    Button_right:setVisible(false)
    if self._index == 2 and self._actionIndex ~= 0 then
        if self._currentPage > 1 then
            Button_right:setVisible(true)
        end
        if self._currentPage < #_ED.sm_activity_other_recruit_reward then
            Button_left:setVisible(true)
        end
    end
end

function SmOtherRecruitReward:changePage( ... )
    local root = self.roots[1]
    self:updatePageButton()
    for k,v in pairs(self.rewardCellList) do
        v:removeFromParent(true)
    end
    self.rewardCellList = {}
    local rewardInfo = _ED.sm_activity_other_recruit_reward[self._currentPage]
    for k,v in pairs(rewardInfo) do
        local info = zstring.split(v.reward, ",")
        local panel = ccui.Helper:seekWidgetByName(root, "Panel_prop_"..k)
        panel:removeAllChildren(true)
        local cell = nil
        if tonumber(info[1]) == 13 then
            local ship_id = info[2]
            local star = zstring.tonumber(info[4])
            if v.isChange == true then
                local m_starRating = dms.int(dms["ship_mould"], tonumber(ship_id), ship_mould.ship_star)
                if star ~= 0 then
                    m_starRating = star
                end
                local number_info = zstring.split(dms.string(dms["ship_config"], 13, ship_config.param),"!")[tonumber(m_starRating)]
                local ability = dms.int(dms["ship_mould"], tonumber(ship_id), ship_mould.ability)
                local fitSkillOne = dms.int(dms["ship_mould"], tonumber(ship_id), ship_mould.fitSkillOne)
                local number_data = zstring.split(number_info,"|")[ability-13+1]
                local split_or_merge_count = tonumber(zstring.split(number_data,",")[2])
                local prop = fundPropWidthId(fitSkillOne)
                cell = ResourcesIconCell:createCell()
                if star ~= 0 then
                    cell:init(6, split_or_merge_count, prop.user_prop_template,nil,nil,true,true,0, {shipStar = star})
                else
                    cell:init(6, split_or_merge_count, prop.user_prop_template,nil,nil,true,true,0)
                end
            else
                cell = ResourcesIconCell:createCell()
                if star ~= 0 then
                    cell:init(info[1], tonumber(info[3]), ship_id,nil,nil,true,true,0, {shipStar = star})
                else
                    cell:init(info[1], tonumber(info[3]), ship_id,nil,nil,true,true,0)
                end
            end
        elseif tonumber(info[1]) == 6 then
            local prop = fundPropWidthId(info[2])
            cell = ResourcesIconCell:createCell()
            cell:init(info[1], tonumber(info[3]), prop.user_prop_template,nil,nil,true,true,0)
        elseif tonumber(info[1]) == 7 then
            local equip = fundEquipWidthId(info[2])
            cell = ResourcesIconCell:createCell()
            cell:init(info[1], tonumber(info[3]), equip.user_equiment_template, nil, nil, true, true, 0)
        elseif tonumber(info[1]) == 1 then
            cell = ResourcesIconCell:createCell()
            cell:init(info[1], tonumber(info[3]), -1, nil, nil, true, true, 0)
        end
        panel:addChild(cell)
        table.insert(self.rewardCellList, cell)
        if tonumber(info[1]) == 13 and v.isChange == false then
            local jsonFile = "sprite/sprite_wzkp.json"
            local atlasFile = "sprite/sprite_wzkp.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            animation:setPosition(cc.p(panel:getContentSize().width/2,panel:getContentSize().height/2))
            panel:addChild(animation)
        end
    end
end

function SmOtherRecruitReward:onUpdateDraw()
    local root = self.roots[1]
    if self._isShowOther == false then
        for k,v in pairs(self.rewardCellList) do
            v:removeFromParent(true)
        end
        self.rewardCellList = {}
        self._currentPage = 1
        self._actionIndex = 0
        ccui.Helper:seekWidgetByName(root, "Panel_36549_1"):setVisible(false)
        self:updatePageButton()
    else
        self._isShowOther = false
    end
    local Image_15 = ccui.Helper:seekWidgetByName(root, "Image_15")
    local Panel_xsbx_bg = ccui.Helper:seekWidgetByName(root, "Panel_xsbx_bg")

    local function addReward( sender )
        self._actionIndex = self._actionIndex + 1
        local groupInfo = _ED.sm_activity_other_recruit_reward[self._currentPage]
        if groupInfo == nil then
            self._currentPage = self._currentPage - 1
            ccui.Helper:seekWidgetByName(root, "Panel_36549_1"):setVisible(true)
            self:updatePageButton()
            return
        end
        local info = groupInfo[self._actionIndex]
        if info == nil then
            self._currentPage = self._currentPage + 1
            if self._currentPage <= #_ED.sm_activity_other_recruit_reward then
                for k,v in pairs(self.rewardCellList) do
                    v:removeFromParent(true)
                end
                self.rewardCellList = {}
            end
            self._actionIndex = 0
            addReward(sender)
            return
        end
        local panel = ccui.Helper:seekWidgetByName(root, "Panel_prop_"..self._actionIndex)
        playEffect(formatMusicFile("effect", 9988))
        local cell = nil
        local isChange = info.isChange
        info = zstring.split(info.reward, ",")
        if tonumber(info[1]) == 13 then
            local star = zstring.tonumber(info[4])
            local ship_id = info[2]
            local ships = fundShipWidthTemplateId(tonumber(ship_id))
            local shipPropId = 0
            local count = 0
            if isChange == true then
                local m_starRating = dms.int(dms["ship_mould"], tonumber(ship_id), ship_mould.ship_star)
                if star ~= 0 then
                    m_starRating = star
                end
                local number_info = zstring.split(dms.string(dms["ship_config"], 13, ship_config.param),"!")[tonumber(m_starRating)]
                local ability = dms.int(dms["ship_mould"], tonumber(ship_id), ship_mould.ability)
                shipPropId = dms.int(dms["ship_mould"], tonumber(ship_id), ship_mould.fitSkillOne)
                local number_data = zstring.split(number_info,"|")[ability-13+1]
                count = tonumber(zstring.split(number_data,",")[2])

                local prop = fundPropWidthId(shipPropId)
                cell = ResourcesIconCell:createCell()
                if star ~= 0 then
                    cell:init(6, count, prop.user_prop_template,nil,nil,true,true,0, {shipStar = star})
                else
                    cell:init(6, count, prop.user_prop_template,nil,nil,true,true,0)
                end
            else
                cell = ResourcesIconCell:createCell()
                if star ~= 0 then
                    cell:init(info[1], tonumber(info[3]), ship_id, nil,nil,true,true,0, {shipStar = star})
                else
                    cell:init(info[1], tonumber(info[3]), ship_id, nil,nil,true,true,0)
                end
            end
            _ED.recruit_success_ship_id = ships.ship_id
            local obj = HeroRecruitSuccess:new()
            obj:setRanking(herorIndex, 5, false, isChange, count, star)
            fwin:open(obj, fwin._ui)
            self._isShowOther = true
        elseif tonumber(info[1]) == 6 then
            local prop = fundPropWidthId(info[2])
            cell = ResourcesIconCell:createCell()
            cell:init(info[1], tonumber(info[3]), prop.user_prop_template,nil,nil,true,true,0)
            local props_type = dms.int(dms["prop_mould"], info[2], prop_mould.props_type)
            if props_type == 7 then
                state_machine.excute("sm_other_recruit_selected_open", 0, {prop, self._actionIndex, self._currentPage})
                self._isShowOther = true
            end
        elseif tonumber(info[1]) == 7 then
            local equip = fundEquipWidthId(info[2])
            cell = ResourcesIconCell:createCell()
            cell:init(info[1], tonumber(info[3]), equip.user_equiment_template, nil, nil, true, true, 0)
        elseif tonumber(info[1]) == 1 then
            cell = ResourcesIconCell:createCell()
            cell:init(info[1], tonumber(info[3]), -1, nil, nil, true, true, 0)
        end

        Panel_xsbx_bg:addChild(cell)
        table.insert(self.rewardCellList, cell)
        cell:setPosition(cc.p(Image_15:getPositionX(), Image_15:getPositionY()))
        cell:setScale(0.1)
        cell:setRotation(180)
        if self._isShowOther == true then
            local seq = cc.Sequence:create(
                cc.Spawn:create(cc.ScaleTo:create(0.15, 1),
                cc.RotateTo:create(0.15, 360),
                cc.MoveTo:create(0.15, cc.p(panel:getPositionX() - panel:getContentSize().width/2, panel:getPositionY() - panel:getContentSize().height/2)))
            )
            cell:runAction(seq)
        else
            local seq = cc.Sequence:create(
                cc.Spawn:create(cc.ScaleTo:create(0.15, 1),
                cc.RotateTo:create(0.15, 360),
                cc.MoveTo:create(0.15, cc.p(panel:getPositionX() - panel:getContentSize().width/2, panel:getPositionY() - panel:getContentSize().height/2))),
                cc.CallFunc:create(addReward)
            )
            cell:runAction(seq)
        end
    end
    addReward(self)

    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.ActivityType114)
    if fun_is_open == true then
        local Panel_consume_icon = ccui.Helper:seekWidgetByName(root, "Panel_consume_icon")

        Panel_consume_icon:setBackGroundImage("images/ui/icon/zuanshi.png")

        local lvs = zstring.tonumber(dms.string(dms["shop_config"], 22, shop_config.param))
        if lvs > 0 then
            local needPropNumber = 0
            if fundPropWidthId(lvs) then
                needPropNumber = zstring.tonumber(fundPropWidthId(lvs).prop_number)
            end
            local nNumber = 0
            if zstring.tonumber(self._index) == 1 then
                nNumber = 1
            else
                nNumber = 5
            end
            if needPropNumber >= nNumber then
                ccui.Helper:seekWidgetByName(root, "Label_36610"):setString(nNumber)
                local picIndex = dms.int(dms["prop_mould"], lvs, prop_mould.pic_index)          -- 物品图标索引
                Panel_consume_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
                Panel_consume_icon:setScale(0.6)
            else
                local info = zstring.split(_ED.active_activity[114].need_recharge_count, ",")[self._index]
                local cost = zstring.split(info, "-")[3]
                ccui.Helper:seekWidgetByName(root, "Label_36610"):setString(cost)
            end
        end
    end
end

function SmOtherRecruitReward:onInit()
    local csbItem = csb.createNode("activity/wonderful/sm_vip_chouka_jiesuan.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_36550"), nil, 
    {
        terminal_name = "sm_other_recruit_reward_request", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_36551"), nil, 
    {
        terminal_name = "sm_other_recruit_reward_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_left"), nil, 
    {
        terminal_name = "sm_other_recruit_reward_change_page", 
        terminal_state = 0, 
        page = 1,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_right"), nil, 
    {
        terminal_name = "sm_other_recruit_reward_change_page", 
        terminal_state = 0, 
        page = -1,
    }, nil, 3)

    playEffect(formatMusicFile("effect", 9983))

    local Panel_zhaomu_open = ccui.Helper:seekWidgetByName(root, "Panel_zhaomu_open")
    if Panel_zhaomu_open ~= nil then
        local function changeActionCallback( armatureBack ) 
            self:onUpdateDraw()
            armatureBack:removeFromParent(true)
        end
        Panel_zhaomu_open:removeAllChildren(true)
        if __lua_project_id == __lua_project_l_naruto then
            local animation = draw.createEffect("sprite_fudan", "sprite/sprite_fudan.ExportJson", Panel_zhaomu_open, -1, nil, nil, cc.p(0.5, 0.5))
            animation._invoke = changeActionCallback
            csb.animationChangeToAction(animation, 0, 0, false)
        else
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
    else
        self:onUpdateDraw()
    end

    local lvs = zstring.tonumber(dms.string(dms["shop_config"], 22, shop_config.param))
    if lvs > 0 then
        local needPropNumber = 0
        if fundPropWidthId(lvs) then
            needPropNumber = zstring.tonumber(fundPropWidthId(lvs).prop_number)
        end
        local nNumber = 0
        if zstring.tonumber(self._index) == 1 then
            nNumber = 1
        else
            nNumber = 5
        end
        if needPropNumber >= nNumber then
            ccui.Helper:seekWidgetByName(root, "Label_36610"):setString(nNumber)
        else
            local info = zstring.split(_ED.active_activity[114].need_recharge_count, ",")[self._index]
            local cost = zstring.split(info, "-")[3]
            ccui.Helper:seekWidgetByName(root, "Label_36610"):setString(cost)
        end
   end
end

function SmOtherRecruitReward:onEnterTransitionFinish()
    self:onInit()
end

function SmOtherRecruitReward:init(params)
    self._index = params[1]
    return self
end

function SmOtherRecruitReward:onExit()
    state_machine.remove("sm_other_recruit_reward_request")
    state_machine.remove("sm_other_recruit_reward_change_page")
    state_machine.remove("sm_other_recruit_reward_action_continue")
end