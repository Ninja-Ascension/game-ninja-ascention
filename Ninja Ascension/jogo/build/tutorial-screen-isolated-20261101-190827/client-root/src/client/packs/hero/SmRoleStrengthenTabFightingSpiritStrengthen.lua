-- ----------------------------------------------------------------------------------------------------
-- 说明：斗魂强化
-------------------------------------------------------------------------------------------------------
SmRoleStrengthenTabFightingSpiritStrengthen = class("SmRoleStrengthenTabFightingSpiritStrengthenClass", Window)

local sm_role_strengthen_tab_fighting_spirit_strengthen_open_terminal = {
    _name = "sm_role_strengthen_tab_fighting_spirit_strengthen_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabFightingSpiritStrengthenClass")
        if nil == _homeWindow then
            local panel = SmRoleStrengthenTabFightingSpiritStrengthen:new():init(params)
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_strengthen_tab_fighting_spirit_strengthen_close_terminal = {
    _name = "sm_role_strengthen_tab_fighting_spirit_strengthen_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabFightingSpiritStrengthenClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleStrengthenTabFightingSpiritStrengthenClass"))
        end
        state_machine.excute("formation_update_ship_info", 0, {isChange = true})
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_strengthen_tab_fighting_spirit_strengthen_open_terminal)
state_machine.add(sm_role_strengthen_tab_fighting_spirit_strengthen_close_terminal)
state_machine.init()
    
function SmRoleStrengthenTabFightingSpiritStrengthen:ctor()
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

    local function init_sm_role_strengthen_tab_fighting_spirit_strengthen_terminal()
        -- 显示界面
        local sm_role_strengthen_tab_fighting_spirit_strengthen_display_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_strengthen_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabFightingSpiritStrengthenWindow = fwin:find("SmRoleStrengthenTabFightingSpiritStrengthenClass")
                if SmRoleStrengthenTabFightingSpiritStrengthenWindow ~= nil then
                    SmRoleStrengthenTabFightingSpiritStrengthenWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_strengthen_tab_fighting_spirit_strengthen_hide_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_strengthen_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabFightingSpiritStrengthenWindow = fwin:find("SmRoleStrengthenTabFightingSpiritStrengthenClass")
                if SmRoleStrengthenTabFightingSpiritStrengthenWindow ~= nil then
                    SmRoleStrengthenTabFightingSpiritStrengthenWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 记录道具
        local sm_role_strengthen_tab_fighting_spirit_strengthen_recording_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_strengthen_recording",
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
                                if params[3] == true then
                                    v.prop.use_number = zstring.tonumber(v.prop.use_number) + props_number
                                end
                            end
                        else
                            if zstring.tonumber(v.prop.use_number) > 0 then
                                if params[3] == true then
                                    v.prop.use_number = zstring.tonumber(v.prop.use_number) + props_number
                                end
                            end
                        end
                        break
                    end
                end
                if params[3] == true then
                else
                    instance._choose_props = props
                    instance._current_count = zstring.tonumber(props.use_number)
                    instance._max_count = zstring.tonumber(props.prop_number)
                    local name = setThePropsIcon(props.user_prop_template)[2]
                    local quality = dms.int(dms["prop_mould"], props.user_prop_template, prop_mould.prop_quality)+1
                    instance._Text_dh_name_0:setString(name)
                    instance._Text_dh_name_0:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
                    instance._Text_dh_exp_0:setString(dms.int(dms["prop_mould"], props.user_prop_template, prop_mould.reward_type))
                    instance:setSelectNum(zstring.tonumber(props.use_number))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 材料强化
        local sm_role_strengthen_tab_fighting_spirit_strengthen_material_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_strengthen_material",
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
                            state_machine.excute("sm_role_strengthen_tab_fighting_spirit_strengthen_update_draw", 0, "")
                            -- state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{ship_id})
                            TipDlg.drawTextDailog(_new_interface_text[220])
                            smFightingChange()
                        end
                    end
                    state_machine.unlock("sm_role_strengthen_tab_fighting_spirit_strengthen_material")
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
                state_machine.lock("sm_role_strengthen_tab_fighting_spirit_strengthen_material")
                protocol_command.ship_soul_level_up.param_list = instance.ship_id.."\r\n".."0".."\r\n"..(tonumber(instance.m_index)-1).."\r\n"..prop_info
                NetworkManager:register(protocol_command.ship_soul_level_up.code, nil, nil, nil, instance, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 强化刷新
        local sm_role_strengthen_tab_fighting_spirit_strengthen_update_draw_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_strengthen_update_draw",
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

        local sm_role_strengthen_tab_fighting_spirit_strengthen_change_times_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_strengthen_change_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._choose_props == nil then
                    instance._Slider_number:setPercent(0)
                    return
                end
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

        local sm_role_strengthen_tab_fighting_spirit_strengthen_silder_update_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_strengthen_silder_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._choose_props == nil then
                    instance._Slider_number:setPercent(0)
                    return
                end
                if instance.soul_lv >= 20 then
                    return
                end
                local select_num = math.ceil(tonumber(instance._Slider_number:getPercent()) * instance._max_count / 100)
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

        local sm_role_strengthen_tab_fighting_spirit_strengthen_set_max_number_terminal = {
            _name = "sm_role_strengthen_tab_fighting_spirit_strengthen_set_max_number",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._old_choose_props == nil or instance._old_choose_props ~= instance._choose_props then
                    instance._old_choose_props = instance._choose_props
                    instance._max_count = instance:CalculateNumber()
                    instance._current_count = zstring.tonumber(instance._choose_props.use_number)
                    instance._old_choose_props._max_count = instance._max_count
                    instance:setSelectNum(zstring.tonumber(instance._choose_props.use_number))
                else
                    instance._current_count = zstring.tonumber(instance._choose_props.use_number)
                    instance._max_count = instance._old_choose_props._max_count
                    instance:setSelectNum(zstring.tonumber(instance._choose_props.use_number))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_strengthen_tab_fighting_spirit_strengthen_display_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_strengthen_hide_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_strengthen_recording_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_strengthen_material_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_strengthen_update_draw_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_strengthen_change_times_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_strengthen_silder_update_terminal)
        state_machine.add(sm_role_strengthen_tab_fighting_spirit_strengthen_set_max_number_terminal)
        
        state_machine.init()
    end
    init_sm_role_strengthen_tab_fighting_spirit_strengthen_terminal()
end

function SmRoleStrengthenTabFightingSpiritStrengthen:getSortedHeroes()
    local function fightingCapacity(a, b)
        local al = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.trace_scene)
        local bl = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.trace_scene)
        local result = false
        if al < bl then
            result = true
        end
        return result
    end

    local tSortedHeroes = {}

    -- 经验道具
    for i, prop in pairs(_ED.user_prop) do
        local prop_mould_data = dms.element(dms["prop_mould"], prop.user_prop_template)
        if dms.atoi(prop_mould_data, prop_mould.reward_type) > 0 and dms.atoi(prop_mould_data, prop_mould.use_type) == 4 then
            table.insert(tSortedHeroes, prop)
        end
    end

    -- 进阶宝石和卷轴
    for i, prop in pairs(_ED.user_prop) do
        local prop_mould_data = dms.element(dms["prop_mould"], prop.user_prop_template)
        if dms.atoi(prop_mould_data, prop_mould.reward_type) > 0 and dms.atoi(prop_mould_data, prop_mould.use_type) == 5 then
            table.insert(tSortedHeroes, prop)
        end
    end

    -- 忍者碎片
    for i, prop in pairs(_ED.user_prop) do
        local prop_mould_data = dms.element(dms["prop_mould"], prop.user_prop_template)
        if dms.atoi(prop_mould_data, prop_mould.reward_type) > 0 and dms.atoi(prop_mould_data, prop_mould.use_type) == 3 then
            table.insert(tSortedHeroes, prop)
        end
    end

    table.sort(tSortedHeroes, fightingCapacity)

    -- 斗魂精华添加到最前面显示
    for i, prop in pairs(_ED.user_prop) do
        if "243" == prop.user_prop_template then -- 添加斗魂精华
            table.insert(tSortedHeroes, 1, prop)
        end
    end

    -- 其他道具
    for i, prop in pairs(_ED.user_prop) do
        local prop_mould_data = dms.element(dms["prop_mould"], prop.user_prop_template)
        -- la esencia 243 ya va en cabecera: meterla otra vez la mandaba duplicada
        if
            "243" ~= prop.user_prop_template and
            dms.atoi(prop_mould_data, prop_mould.reward_type) > 0 and dms.atoi(prop_mould_data, prop_mould.use_type) ~= 4 and dms.atoi(prop_mould_data, prop_mould.use_type) ~= 5 and
                dms.atoi(prop_mould_data, prop_mould.use_type) ~= 3
         then
            table.insert(tSortedHeroes, prop)
        end
    end

    return tSortedHeroes
end

function SmRoleStrengthenTabFightingSpiritStrengthen:updatePropsInfo( ... )
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
    local wPosition = sWidth/3
    local Hlindex = 0
    local number = #tSortedHeroes
    local m_number = math.ceil(number/3)
    cellHeight = m_number*(m_ScrollView:getContentSize().width/3)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    for j, v in pairs(tSortedHeroes) do
        self:runAction(cc.Sequence:create({cc.DelayTime:create((j-1)*0.02), cc.CallFunc:create(function ( sender )
            if sender ~= nil and sender.roots ~= nil and sender.roots[1] ~= nil then
                local cell = state_machine.excute("sm_packs_cell",0,{v,0,nil,6,2})
                panel:addChild(cell)
                cell._reward_type = dms.int(dms["prop_mould"], v.user_prop_template, prop_mould.reward_type)
                table.insert(self.recording_prop_list, cell)
                if j == 1 then
                    state_machine.excute("sm_packs_cell_update_page", 0, {_datas = {cells = cell}})
                end
                tWidth = tWidth + wPosition
                if (j-1)%3 ==0 then
                    Hlindex = Hlindex+1
                    tWidth = 0
                    tHeight = sHeight - wPosition*Hlindex  
                end
                if j <= 3 then
                    tHeight = sHeight - wPosition
                end
                cell:setPosition(cc.p(tWidth, tHeight))
            end
        end)}))
    end
    m_ScrollView:jumpToTop()
end

function SmRoleStrengthenTabFightingSpiritStrengthen:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local shipInfo = self._shipInfo--_ED.user_ship[""..self.ship_id]
    if shipInfo == nil then
        return
    end
    local faction_id = zstring.split(dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.faction_id),",")
    local unlock_condition = dms.int(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.unlock_condition)
    --找对应的天赋
    local talent_id = tonumber(zstring.split(dms.string(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.talent_id),",")[1])
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
    self.soul_exp = tonumber(zstring.split(soul_data[self.m_index],",")[2])
    --当前等级
    self.soul_lv = tonumber(zstring.split(soul_data[self.m_index],",")[1])
    --找到对应的升级库组
    local attribute_id = zstring.split(dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.attribute_id),",")
    local expLibrary = attribute_id[self.m_index]
    self._expUpData = dms.searchs(dms["ship_soul_experience_param"], ship_soul_experience_param.library_group, expLibrary)
    self._lvIndex = 0
    for i,v in pairs(self._expUpData) do
        if tonumber(v[3]) == self.soul_lv then
            self._lvIndex = i
            break
        end
    end
    --得到当前级升级需要的经验
    local needMaxExp = 0
    needMaxExp = needMaxExp + self._expUpData[self._lvIndex][4]-self.soul_exp
    for i = self._lvIndex+1, self._lvIndex+(19-self.soul_lv) do
        needMaxExp = needMaxExp + self._expUpData[i][4]
    end
    self.needMaxExp = needMaxExp
    self:updateSelectedObjectDraw()

    self:setSelectNum(0)
end

function SmRoleStrengthenTabFightingSpiritStrengthen:calculationExpAndLv(add_Exp,exp,lv,expUpData,index)
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

function SmRoleStrengthenTabFightingSpiritStrengthen:undateExpDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local shipInfo = self._shipInfo--_ED.user_ship[""..self.ship_id]
    if shipInfo == nil then
        return
    end
    if self.soul_lv >= 20 then
        self._Button_zsqh:setBright(false)
        self._Button_zsqh:setTouchEnabled(false)
    else
        self._Button_zsqh:setBright(true)
        self._Button_zsqh:setTouchEnabled(true)
    end
    local upexps, upLv, maxExp = self:calculationExpAndLv(self.add_Exp,self.soul_exp,self.soul_lv,self._expUpData,self._lvIndex)

    self._Text_dh_lv:setString("Lv."..upLv)
    local persent = math.floor(upexps*100/maxExp)
    self._LoadingBar_dh_exp:setPercent(persent)
    self._Text_dh_exp:setString(upexps.."/"..maxExp)
    self.is_max_exp = false
    if upLv == 20 then
        self._LoadingBar_dh_exp:setPercent(100)
        self._Text_dh_exp:setString("")
        self.is_max_exp = true
    end

    local attribute_bonus = nil
    for i, v in pairs(self._attributes) do
        if tonumber(v[3]) == upLv then
            attribute_bonus = v
            break
        end
    end

    local attribute_content = {}
    --战前加的属性
    if attribute_bonus[4] ~= "-1" then
        for i, v in pairs(zstring.split(attribute_bonus[4],"|")) do
            table.insert(attribute_content, zstring.split(v,",")[2])
        end
    end
    --战中加的属性
    if attribute_bonus[5] ~= "-1" then
        local content = zstring.split(attribute_bonus[5],"|")

        local index = 0
        for i, v in pairs(zstring.split(attribute_bonus[5],"|")) do
            index = index + 1
            local value = zstring.split(v, ",")
            table.insert(attribute_content, zstring.split(content[index],",")[2])
        end
    end
    local describe_text = self._describe_text
    for i,v in pairs(attribute_content) do
        describe_text = string.gsub(describe_text, "{"..i.."}", v)
    end
    
    local textWidth = self._Text_dh_info:getContentSize().width
    self._Text_dh_info:setString(describe_text)
    self._Text_dh_info:setUnifySizeEnabled(true) --使用归一化尺寸, 不使用自定义尺寸
    self._Text_dh_info:setTextAreaSize(cc.size(textWidth, 0))	
    self._Text_dh_info:ignoreContentAdaptWithSize(false) --不使用自定义尺寸

    if self.add_Exp > 0 then
        if self.needMaxExp < self.add_Exp then
            self.add_Exp = self.needMaxExp
        end
        self._Text_dh_jinbi:setString(self.add_Exp*self._needMoney)
        self._Image_jb_icon:setVisible(true)
    else
        self._Text_dh_jinbi:setString(_new_interface_text[160])
        self._Image_jb_icon:setVisible(false)
    end
end

function SmRoleStrengthenTabFightingSpiritStrengthen:updateSelectedObjectDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    self.add_Exp = 0
    for i,v in pairs(self.recording_prop_list) do
        self.add_Exp = self.add_Exp + v._reward_type * zstring.tonumber(v.prop.use_number)
        -- if tonumber(self._choose_props.user_prop_template) == zstring.tonumber(v.prop.user_prop_template) then
        --     if zstring.tonumber(v.prop.use_number) > 0 then
        --         state_machine.excute("sm_packs_cell_update_selected_object", 0, {v,v.prop.use_number})
        --     else
        --         state_machine.excute("sm_packs_cell_update_selected_object", 0, {v,0})
        --     end
        -- end
    end
    self:undateExpDraw()
end

function SmRoleStrengthenTabFightingSpiritStrengthen:CalculateNumber()
    local exps = 0
    local needNumber = 0
    for i,v in pairs(self.recording_prop_list) do
        if zstring.tonumber(v.prop.use_number) > 0 and  tonumber(v.prop.user_prop_template) ~= tonumber(self._choose_props.user_prop_template) then
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
        else
            number = number
        end
    end
    return number
end

function SmRoleStrengthenTabFightingSpiritStrengthen:setSelectNum(select_num)
    local root = self.roots[1]
    local lastCount = self._current_count
    self._current_count = select_num
    if self._current_count >= tonumber(self._max_count) then
        self._current_count = tonumber(self._max_count)
    end
    if self._current_count <= 0 then
        self._current_count = 0
    end
    
    local percent = math.floor(self._current_count * 100 / self._max_count)

    self._Slider_number:setPercent(percent)
    self._Text_dh_add_0:setString(self._current_count.."/"..self._max_count)
    local length = string.format('%s', self._Text_dh_add_0:getString()):len()
    self._Text_dh_add_1:setPositionX(self._Text_dh_add_0:getPositionX() + length * self._Text_dh_add_0:getFontSize()/2 + 10)
    if self._choose_props ~= nil then
        state_machine.excute("sm_role_strengthen_tab_fighting_spirit_strengthen_recording", 0, {self._choose_props, self._current_count - lastCount, true})
    else
        self._Text_dh_exp_0:setString("")
        self._Text_dh_name_0:setString("")
    end
    self:updateSelectedObjectDraw()
end

function SmRoleStrengthenTabFightingSpiritStrengthen:init(params)
    self.m_index = tonumber(params._datas.index)
    self.ship_id = params._datas.shipId
    self:onInit()
    return self
end

function SmRoleStrengthenTabFightingSpiritStrengthen:onInit()
    local csbSmRoleStrengthenTabFightingSpiritStrengthen = csb.createNode("packs/HeroStorage/sm_role_strengthen_tab_cell_5_window.csb")
    local root = csbSmRoleStrengthenTabFightingSpiritStrengthen:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleStrengthenTabFightingSpiritStrengthen)
	
    self._Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_number")
    self._Text_dh_add_0 = ccui.Helper:seekWidgetByName(root, "Text_dh_add_0")
    self._Text_dh_jinbi = ccui.Helper:seekWidgetByName(root, "Text_dh_jinbi")
    self._Image_jb_icon = ccui.Helper:seekWidgetByName(root, "Image_jb_icon")
    self._Text_dh_exp_0 = ccui.Helper:seekWidgetByName(root, "Text_dh_exp_0")
    self._Text_dh_name_0 = ccui.Helper:seekWidgetByName(root, "Text_dh_name_0")
    self._Text_dh_info = ccui.Helper:seekWidgetByName(root, "Text_dh_info")
    self._LoadingBar_dh_exp = ccui.Helper:seekWidgetByName(root, "LoadingBar_dh_exp")
    self._Text_dh_exp = ccui.Helper:seekWidgetByName(root, "Text_dh_exp")
    self._Text_dh_lv = ccui.Helper:seekWidgetByName(root, "Text_dh_lv")
    self._Button_zsqh = ccui.Helper:seekWidgetByName(root, "Button_zsqh")
    self._Text_dh_add_1 = ccui.Helper:seekWidgetByName(root, "Text_dh_add_1")

    self._shipInfo = _ED.user_ship[""..self.ship_id]
    local faction_id = zstring.split(dms.string(dms["ship_mould"], self._shipInfo.ship_template_id, ship_mould.faction_id),",")
    local talent_id = tonumber(zstring.split(dms.string(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.talent_id),",")[1])
    local describe = dms.int(dms["talent_mould"], talent_id, talent_mould.talent_describe)
    local word_info = dms.element(dms["word_mould"], describe)
    self._describe_text = word_info[3]
    local attribute_bonus_library = dms.int(dms["ship_soul_mould"], faction_id[self.m_index], ship_soul_mould.attribute_bonus_library)
    self._attributes = dms.searchs(dms["ship_soul_addition_property_param"], ship_soul_addition_property_param.library_group, attribute_bonus_library)

    self._needMoney = dms.int(dms["ship_config"], 10, ship_config.param)
    self:onUpdateDraw()

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_closed"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_fighting_spirit_strengthen_close", 
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
        terminal_name = "sm_role_strengthen_tab_fighting_spirit_strengthen_material", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_fighting_spirit_strengthen_change_times", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        updateLevel = 1,
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reduce"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_fighting_spirit_strengthen_change_times", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        updateLevel = -1,
    }, nil, 1)  

    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("sm_role_strengthen_tab_fighting_spirit_strengthen_silder_update", 0, {sender:getPercent()})
        end
    end
    self._Slider_number:addEventListener(percentChangedEvent)

    self:updatePropsInfo()
end

function SmRoleStrengthenTabFightingSpiritStrengthen:onExit()
    state_machine.remove("sm_role_strengthen_tab_fighting_spirit_strengthen_display")
    state_machine.remove("sm_role_strengthen_tab_fighting_spirit_strengthen_hide")
    state_machine.remove("sm_role_strengthen_tab_fighting_spirit_strengthen_silder_update")
    state_machine.remove("sm_role_strengthen_tab_fighting_spirit_strengthen_change_times")
end