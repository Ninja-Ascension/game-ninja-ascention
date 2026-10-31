-- ----------------------------------------------------------------------------------------------------
-- 说明：斗魂强化未开一键升级前
-------------------------------------------------------------------------------------------------------
SmRoleStrengthenTabFightingSpiritOld = class("SmRoleStrengthenTabFightingSpiritOldClass", Window)

local sm_role_strengthen_tab_fighting_spirit_old_open_terminal = {
    _name = "sm_role_strengthen_tab_fighting_spirit_old_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabFightingSpiritOldClass")
        if nil == _homeWindow then
            local panel = SmRoleStrengthenTabFightingSpiritOld:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_strengthen_tab_fighting_spirit_old_close_terminal = {
    _name = "sm_role_strengthen_tab_fighting_spirit_old_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabFightingSpiritOldClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleStrengthenTabFightingSpiritOldClass"))
        end
        state_machine.excute("formation_update_ship_info", 0, {isChange = true})
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_strengthen_tab_fighting_spirit_old_open_terminal)
state_machine.add(sm_role_strengthen_tab_fighting_spirit_old_close_terminal)
state_machine.init()
    
function SmRoleStrengthenTabFightingSpiritOld:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0
    self.m_index = 1
    self.soul_lv = 1
    self.soul_exp = 0
    self.recording_prop_list = {}
    self.add_Exp = 0

    self._choose_props = nil
    self._old_choose_props = nil
    self._current_count = 0
    self._max_count = 0

    self.is_max_exp = false
    app.load("client.cells.prop.sm_packs_cell")
    app.load("client.packs.hero.SmRoleStrengthenSpecialReinforcement")

    local function init_sm_role_strengthen_tab_fighting_spirit_old_terminal()
        -- 显示界面
        local sm_role_strengthen_tab_fighting_spirit_old_display_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_old_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabFightingSpiritOldWindow = fwin:find("SmRoleStrengthenTabFightingSpiritOldClass")
                if SmRoleStrengthenTabFightingSpiritOldWindow ~= nil then
                    SmRoleStrengthenTabFightingSpiritOldWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_strengthen_tab_fighting_spirit_old_hide_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_old_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabFightingSpiritOldWindow = fwin:find("SmRoleStrengthenTabFightingSpiritOldClass")
                if SmRoleStrengthenTabFightingSpiritOldWindow ~= nil then
                    SmRoleStrengthenTabFightingSpiritOldWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 记录道具
        local sm_role_strengthen_tab_fighting_spirit_old_recording_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_old_recording",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local props = params[1]
                local props_number = tonumber(params[2])
                if instance.soul_lv >= 20 then
                    return
                end
                if instance.is_max_exp == true and props_number > 0 then
                    return
                end
                for i,v in pairs(instance.recording_prop_list) do
                    if zstring.tonumber(v.prop.user_prop_template) == zstring.tonumber(props.user_prop_template) then
                        if props_number > 0 then
                            if zstring.tonumber(v.prop.prop_number) > zstring.tonumber(v.prop.use_number) then
                                v.prop.use_number = zstring.tonumber(v.prop.use_number) + props_number
                            end
                        else
                            if zstring.tonumber(v.prop.use_number) > 0 then
                                v.prop.use_number = zstring.tonumber(v.prop.use_number) + props_number
                            end
                        end
                        break
                    end
                end
                instance:updateSelectedObjectDraw()
                if params[3] == true then
                else
                    instance._choose_props = props
                    instance._current_count = zstring.tonumber(props.use_number)
                    instance._max_count = zstring.tonumber(props.prop_number)
                    instance:setSelectNum(zstring.tonumber(props.use_number))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 材料强化
        local sm_role_strengthen_tab_fighting_spirit_old_material_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_old_material",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ship_id = instance.ship_id
                local function responseCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("sm_role_strengthen_tab_fighting_spirit_old_update_draw", 0, "")
                            -- state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{ship_id})
                            TipDlg.drawTextDailog(_new_interface_text[220])
                            smFightingChange()
                        end
                    end
                    state_machine.unlock("sm_role_strengthen_tab_fighting_spirit_old_material")
                end
                local prop_info = ""
                for i,v in pairs(instance.recording_prop_list) do
                    if zstring.tonumber(v.prop.use_number) > 0  then
                        if prop_info == "" then
                            prop_info = v.prop.user_prop_id..","..v.prop.use_number
                        else
                            prop_info = prop_info.."|"..v.prop.user_prop_id..","..v.prop.use_number
                        end
                    end
                end
                if prop_info == "" then
                    TipDlg.drawTextDailog(_new_interface_text[162])
                    return
                end
                state_machine.lock("sm_role_strengthen_tab_fighting_spirit_old_material")
                protocol_command.ship_soul_level_up.param_list = instance.ship_id.."\r\n".."0".."\r\n"..(tonumber(instance.m_index)-1).."\r\n"..prop_info
                NetworkManager:register(protocol_command.ship_soul_level_up.code, nil, nil, nil, instance, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 强化刷新
        local sm_role_strengthen_tab_fighting_spirit_old_update_draw_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_old_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updatePropsInfo()
                instance:onUpdateDraw()
                state_machine.excute("sm_role_strengthen_tab_fighting_spirit_up_lv_update_draw", 0, {instance.m_index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_strengthen_tab_fighting_spirit_old_change_times_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_old_change_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.soul_lv >= 20 then
                    return
                end
                if instance.is_max_exp == true and tonumber(params._datas.updateLevel) > 0 then
                    return
                end
                if instance._current_count + tonumber(params._datas.updateLevel) < 0 then
                    return
                end
                if instance._current_count + tonumber(params._datas.updateLevel) > tonumber(instance._max_count) then
                    return
                end
                instance:setSelectNum(instance._current_count + tonumber(params._datas.updateLevel))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_strengthen_tab_fighting_spirit_old_silder_update_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_old_silder_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.soul_lv >= 20 then
                    return
                end
                local Slider_number = ccui.Helper:seekWidgetByName(instance.roots[1], "Slider_number")
                local select_num = math.ceil(tonumber(Slider_number:getPercent()) * instance._max_count / 100)
                if select_num <= 0 then
                    select_num = 0
                end

                if instance.is_max_exp == true and select_num > instance._current_count then
                    select_num = instance._current_count
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_strengthen_tab_fighting_spirit_old_set_max_number_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_old_set_max_number",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- if instance._old_choose_props == nil or instance._old_choose_props ~= instance._choose_props then
                --     instance._old_choose_props = instance._choose_props
                --     instance._max_count = instance:CalculateNumber()
                --     instance._current_count = zstring.tonumber(instance._choose_props.use_number)
                --     instance._old_choose_props._max_count = instance._max_count
                --     instance:setSelectNum(zstring.tonumber(instance._choose_props.use_number))
                -- else
                --     instance._current_count = zstring.tonumber(instance._choose_props.use_number)
                --     instance._max_count = instance._old_choose_props._max_count
                --     instance:setSelectNum(zstring.tonumber(instance._choose_props.use_number))
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_strengthen_tab_fighting_spirit_old_display_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_old_hide_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_old_recording_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_old_material_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_old_update_draw_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_old_change_times_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_old_silder_update_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_old_set_max_number_terminal)
        
        state_machine.init()
    end
    init_sm_role_strengthen_tab_fighting_spirit_old_terminal()
end

function SmRoleStrengthenTabFightingSpiritOld:getSortedHeroes()
    local function fightingCapacity(a,b)
        local al = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.trace_scene)
        local bl = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.trace_scene)
        local result = false
        if al < bl then
            result = true
        end
        return result 
    end
    local tSortedHeroes = {}

    for i, prop in pairs(_ED.user_prop) do
        if "243" == prop.user_prop_template then
            -- 跳过斗魂精华
        else
            local propData = dms.element(dms["prop_mould"], prop.user_prop_template)
            if dms.atoi(propData, prop_mould.reward_type) > 0 then
                table.insert(tSortedHeroes, prop)
            end
        end
    end

    table.sort(tSortedHeroes, fightingCapacity)

    -- 斗魂精华添加到最前面显示
    for i, prop in pairs(_ED.user_prop) do
        if "243" == prop.user_prop_template then -- 添加斗魂精华
            table.insert(tSortedHeroes, 1, prop)
        end
    end
    return tSortedHeroes
end

function SmRoleStrengthenTabFightingSpiritOld:updatePropsInfo( ... )
    local root = self.roots[1]
    if root == nil then 
        return
    end
    self.recording_prop_list = {}
    local tSortedHeroes = self:getSortedHeroes()
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_cailiao")
    m_ScrollView:removeAllChildren(true)
    local panel = m_ScrollView:getInnerContainer()
    panel:setContentSize(m_ScrollView:getContentSize())
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = m_ScrollView:getInnerContainerSize()
    local nextY = sSize.height
    local nextX = sSize.width
    local tHeight = 0
    local cellHeight = 0
    local tWidth = 0
    local wPosition = sWidth/5
    local Hlindex = 0
    local number = #tSortedHeroes
    local m_number = math.ceil(number/5)
    cellHeight = m_number*(m_ScrollView:getContentSize().width/5)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local first = nil
    local index = 1
    for j, v in pairs(tSortedHeroes) do
        local cell = state_machine.excute("sm_packs_cell",0,{v,0,nil,6,1})
        panel:addChild(cell)
        table.insert(self.recording_prop_list, cell)
        if index == 1 then
            first = cell
        end
        tWidth = tWidth + wPosition
        if (index-1)%5 ==0 then
            Hlindex = Hlindex+1
            tWidth = 0
            tHeight = sHeight - wPosition*Hlindex  
        end
        if index <= 5 then
            tHeight = sHeight - wPosition
        end
        index = index + 1
        cell:setPosition(cc.p(tWidth,tHeight))
    end
    m_ScrollView:jumpToTop()
end

function SmRoleStrengthenTabFightingSpiritOld:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local shipInfo = _ED.user_ship[""..self.ship_id]
    if shipInfo == nil then
        return
    end
    local faction_id = zstring.split(dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.faction_id),",")
    local unlock_condition = dms.int(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.unlock_condition)
    --找对应的天赋
    local talent_id =  tonumber(zstring.split(dms.string(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.talent_id),",")[1])
    local Panel_dh_icon = ccui.Helper:seekWidgetByName(root,"Panel_dh_icon")
    Panel_dh_icon:removeBackGroundImage()
    local icon = dms.string(dms["talent_mould"], talent_id, talent_mould.buff_add_beau)
    if tonumber(icon) < 10 then
        icon = "0"..icon
    end
    Panel_dh_icon:setBackGroundImage(string.format("images/ui/talent_icon/talent_icon_%s.png", icon))
    --选中de斗魂名称
    local Text_dh_name = ccui.Helper:seekWidgetByName(root,"Text_dh_name")
    local name = dms.int(dms["talent_mould"], talent_id, talent_mould.talent_name)
    local word_info = dms.element(dms["word_mould"], name)
    local skillName = word_info[3]
    Text_dh_name:setString(skillName)


    --计算出升级到满级需要的经验数
    local soul_data = zstring.split(shipInfo.ship_fighting_spirit,"|")
    --当前经验
    local soul_exp = tonumber(zstring.split(soul_data[self.m_index],",")[2])
    --当前等级
    local soul_lv = tonumber(zstring.split(soul_data[self.m_index],",")[1])
    --找到对应的升级库组
    local attribute_id = zstring.split(dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.attribute_id),",")
    local expLibrary = attribute_id[self.m_index]
    local expUpData = dms.searchs(dms["ship_soul_experience_param"], ship_soul_experience_param.library_group, expLibrary)
    local lvIndex = 0
    for i,v in pairs(expUpData) do
        if tonumber(v[3]) == soul_lv then
            lvIndex = i
            break
        end
    end
    --得到当前级升级需要的经验
    local needMaxExp = 0
    needMaxExp = needMaxExp + expUpData[lvIndex][4]-soul_exp
    for i = lvIndex+1, lvIndex+(19-soul_lv) do
        needMaxExp = needMaxExp + expUpData[i][4]
    end
    self.needMaxExp = needMaxExp
    self:updateSelectedObjectDraw()


    self:setSelectNum(0)
end

function SmRoleStrengthenTabFightingSpiritOld:calculationExpAndLv(add_Exp,exp,lv,expUpData,index)
    --通过经验升级表计算现在可以升到多少级
    local grand_total = 0
    local number = 0
    if zstring.tonumber(index) <= 0 then
        number = 0
    else
        number = zstring.tonumber(index)
    end
    local maxExp = 0
    if number ~= 0 then
        for i=number,#expUpData do
            grand_total = grand_total + tonumber(expUpData[i][4])
            if add_Exp + exp < grand_total then
                exp = math.abs(grand_total - (add_Exp + exp) - tonumber(expUpData[i][4]))
                lv = i
                maxExp = tonumber(expUpData[i][4])
                break
            end
        end
    end
    return exp,lv, maxExp
end

function SmRoleStrengthenTabFightingSpiritOld:undateExpDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local shipInfo = _ED.user_ship[""..self.ship_id]
    if shipInfo == nil then
        return
    end
    local soul_data = zstring.split(shipInfo.ship_fighting_spirit,"|")
    self.soul_exp = tonumber(zstring.split(soul_data[self.m_index],",")[2])
    self.soul_lv = tonumber(zstring.split(soul_data[self.m_index],",")[1])
    if self.soul_lv >= 20 then
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_zsqh"):setBright(false)
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_zsqh"):setTouchEnabled(false)
    else
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_zsqh"):setBright(true)
        ccui.Helper:seekWidgetByName(self.roots[1],"Button_zsqh"):setTouchEnabled(true)
    end
    --找到对应的升级库组
    local attribute_id = zstring.split(dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.attribute_id),",")
    local expLibrary = attribute_id[self.m_index]
    local expUpData = dms.searchs(dms["ship_soul_experience_param"], ship_soul_experience_param.library_group, expLibrary)
    local expUpInfo = nil
    local lvIndex = 0
    for i,v in pairs(expUpData) do
        if tonumber(v[3]) == self.soul_lv then
            expUpInfo = v
            lvIndex = i
            break
        end
    end

    local upexps, upLv ,maxExp= self:calculationExpAndLv(self.add_Exp,self.soul_exp,self.soul_lv,expUpData,lvIndex)

    --选中de斗魂等级
    local Text_dh_lv = ccui.Helper:seekWidgetByName(root,"Text_dh_lv")

    Text_dh_lv:setString("Lv."..upLv)

    local LoadingBar_dh_exp = ccui.Helper:seekWidgetByName(root, "LoadingBar_dh_exp")
    local persent = math.floor(upexps*100/maxExp)
    LoadingBar_dh_exp:setPercent(persent)
    local Text_dh_exp = ccui.Helper:seekWidgetByName(root, "Text_dh_exp")
    Text_dh_exp:setString(upexps.."/"..maxExp)
    self.is_max_exp = false
    if upLv == 20 then
        LoadingBar_dh_exp:setPercent(100)
        Text_dh_exp:setString("")
        self.is_max_exp = true
    end

    local faction_id = zstring.split(dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.faction_id),",")
    local talent_id =  tonumber(zstring.split(dms.string(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.talent_id),",")[1])
    --选中的斗魂描述
    local Text_dh_info = ccui.Helper:seekWidgetByName(root,"Text_dh_info") 
    local describe = dms.int(dms["talent_mould"], talent_id, talent_mould.talent_describe)
    local word_info = dms.element(dms["word_mould"], describe)
    local describe_text = word_info[3]
    --画描述内容
    local attribute_content = {}
    local attribute_bonus_library = dms.int(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.attribute_bonus_library)
    local attributes = dms.searchs(dms["ship_soul_addition_property_param"], ship_soul_addition_property_param.library_group, attribute_bonus_library)
    local attribute_bonus = nil
    for i, v in pairs(attributes) do
        if tonumber(v[3]) == upLv then
            attribute_bonus = v
            break
        end
    end

    --战前加的属性
    -- local base_additional = dms.string(dms["talent_mould"], talent_id, talent_mould.base_additional)
    if attribute_bonus[4] ~= "-1" then
        for i, v in pairs(zstring.split(attribute_bonus[4],"|")) do
            table.insert(attribute_content, zstring.split(v,",")[2])
        end
    end
    --战中加的属性
    -- local influence_judge_result = dms.string(dms["talent_mould"], talent_id, talent_mould.influence_judge_result)
    if attribute_bonus[5] ~= "-1" then
        local content = zstring.split(attribute_bonus[5],"|")

        local index = 0
        for i, v in pairs(zstring.split(attribute_bonus[5],"|")) do
            index = index + 1
            local value = zstring.split(v, ",")
            table.insert(attribute_content, zstring.split(content[index],",")[2])
        end
    end
    for i,v in pairs(attribute_content) do
        describe_text = string.gsub(describe_text,"{"..i.."}",v)
    end
    Text_dh_info:setString(describe_text)

    local Text_dh_jinbi =  ccui.Helper:seekWidgetByName(root, "Text_dh_jinbi")
    local Image_jb_icon = ccui.Helper:seekWidgetByName(root, "Image_jb_icon")
    if self.add_Exp > 0 then
        local needMoney = dms.int(dms["ship_config"], 10, ship_config.param)
        if self.needMaxExp < self.add_Exp then
            self.add_Exp = self.needMaxExp
        end
        Text_dh_jinbi:setString(self.add_Exp*needMoney)
        Image_jb_icon:setVisible(true)
    else
        Text_dh_jinbi:setString(_new_interface_text[160])
        Image_jb_icon:setVisible(false)
    end
end

function SmRoleStrengthenTabFightingSpiritOld:updateSelectedObjectDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    self.add_Exp = 0
    for i,v in pairs(self.recording_prop_list) do
        if zstring.tonumber(v.prop.use_number) > 0 then
            state_machine.excute("sm_packs_cell_update_selected_object", 0, {v,v.prop.use_number})
            self.add_Exp = self.add_Exp + dms.int(dms["prop_mould"], v.prop.user_prop_template, prop_mould.reward_type)*zstring.tonumber(v.prop.use_number)
        else
            state_machine.excute("sm_packs_cell_update_selected_object", 0, {v,0})
        end
    end
    self:undateExpDraw()
end

function SmRoleStrengthenTabFightingSpiritOld:CalculateNumber()
    local exps = 0
    local needNumber = 0
    for i,v in pairs(self.recording_prop_list) do
        if zstring.tonumber(v.prop.use_number) > 0  then
            local reward_type = dms.int(dms["prop_mould"], v.prop.user_prop_template, prop_mould.reward_type)
            exps = exps + reward_type * zstring.tonumber(v.prop.use_number)
        end
    end
    local RemainingExps = self.needMaxExp - exps
    local number = 0
    if RemainingExps > 0 then
        local reward_props = dms.int(dms["prop_mould"], self._choose_props.user_prop_template, prop_mould.reward_type)
        number = math.ceil(RemainingExps/reward_props)
        if number > zstring.tonumber(self._choose_props.prop_number) then
            number = zstring.tonumber(self._choose_props.prop_number)
        end
    end
    number = number + zstring.tonumber(self._choose_props.use_number)
    return number
end

function SmRoleStrengthenTabFightingSpiritOld:setSelectNum(select_num)
    -- local root = self.roots[1]
    -- local lastCount = self._current_count
    -- self._current_count = select_num
    -- if self._current_count >= tonumber(self._max_count) then
    --     self._current_count = tonumber(self._max_count)
    -- end
    -- if self._current_count <= 0 then
    --     self._current_count = 0
    -- end
    -- local percent = math.floor(self._current_count * 100 / self._max_count)

    -- local Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_number")
    -- Slider_number:setPercent(percent)
    -- local Text_dh_add_0 = ccui.Helper:seekWidgetByName(root, "Text_dh_add_0")
    -- Text_dh_add_0:setString(self._current_count.."/"..self._max_count)
    -- local Text_dh_exp_0 = ccui.Helper:seekWidgetByName(root, "Text_dh_exp_0")
    -- local Text_dh_name_0 = ccui.Helper:seekWidgetByName(root, "Text_dh_name_0")
    -- Text_dh_exp_0:setString("")
    -- Text_dh_name_0:setString("")
    -- -- if self._current_count > 0 then
    -- --     ccui.Helper:seekWidgetByName(root, "Text_dh_jinbi"):setVisible(true)
    -- -- else
    -- --     ccui.Helper:seekWidgetByName(root, "Text_dh_jinbi"):setVisible(false)
    -- -- end
    -- if self._choose_props ~= nil then
    --     local name = setThePropsIcon(self._choose_props.user_prop_template)[2]
    --     local quality = dms.int(dms["prop_mould"], self._choose_props.user_prop_template, prop_mould.prop_quality)+1
    --     Text_dh_name_0:setString(name)
    --     Text_dh_name_0:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
    --     Text_dh_exp_0:setString(dms.string(dms["prop_mould"], self._choose_props.user_prop_template, prop_mould.reward_type))
    --     state_machine.excute("sm_role_strengthen_tab_fighting_spirit_old_recording", 0, {self._choose_props, self._current_count - lastCount, true})
    -- end
end

function SmRoleStrengthenTabFightingSpiritOld:init(params)
    self.m_index = tonumber(params._datas.index)
    self.ship_id = params._datas.shipId
    self:onInit()
    return self
end

function SmRoleStrengthenTabFightingSpiritOld:onInit()
    local csbSmRoleStrengthenTabFightingSpiritOld = csb.createNode("packs/HeroStorage/sm_role_strengthen_tab_cell_5_window_0.csb")
    local root = csbSmRoleStrengthenTabFightingSpiritOld:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleStrengthenTabFightingSpiritOld)
	
    self:onUpdateDraw()

    
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_closed"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_fighting_spirit_old_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 3)

    --宝石强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_zsqh"), nil, 
    {
        terminal_name = "sm_role_strengthen_special_reinforcementopen", 
        terminal_state = 0,
        index = self.m_index,
        ship_id = self.ship_id,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --普通强化
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_qh"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_fighting_spirit_old_material", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_fighting_spirit_old_change_times", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        updateLevel = 1,
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reduce"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_fighting_spirit_old_change_times", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        updateLevel = -1,
    }, nil, 1)  

    -- local Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_number")
    -- local function percentChangedEvent(sender,eventType)
    --     if eventType == ccui.SliderEventType.percentChanged then
    --         state_machine.excute("sm_role_strengthen_tab_fighting_spirit_old_silder_update", 0, {sender:getPercent()})
    --     end
    -- end
    -- Slider_number:addEventListener(percentChangedEvent)

    self:updatePropsInfo()
end

function SmRoleStrengthenTabFightingSpiritOld:onExit()
    state_machine.remove("sm_role_strengthen_tab_fighting_spirit_old_display")
    state_machine.remove("sm_role_strengthen_tab_fighting_spirit_old_hide")
    state_machine.remove("sm_role_strengthen_tab_fighting_spirit_old_silder_update")
    state_machine.remove("sm_role_strengthen_tab_fighting_spirit_old_change_times")
end