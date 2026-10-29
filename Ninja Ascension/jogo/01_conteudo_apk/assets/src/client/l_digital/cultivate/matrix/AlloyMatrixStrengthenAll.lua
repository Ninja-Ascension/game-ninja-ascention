-----------------------------
-- 合金矩阵一键强化
-----------------------------
AlloyMatrixStrengthenAll = class("AlloyMatrixStrengthenAllClass", Window)

local alloy_matrix_strengthen_all_open_terminal = {
    _name = "alloy_matrix_strengthen_all_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("AlloyMatrixStrengthenAllClass") == nil then
            fwin:open(AlloyMatrixStrengthenAll:new():init(params), fwin._ui)     
        end
    end,
    _terminal = nil,
    _terminals = nil
}

local alloy_matrix_strengthen_all_close_terminal = {
    _name = "alloy_matrix_strengthen_all_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("AlloyMatrixStrengthenAllClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(alloy_matrix_strengthen_all_open_terminal)
state_machine.add(alloy_matrix_strengthen_all_close_terminal)
state_machine.init()

function AlloyMatrixStrengthenAll:ctor()
    self.super:ctor()
    self.roots = {}
    self._max_level = 120
    self._min_level = 0

    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFormationCell")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixInformation")
    
    local function init_alloy_matrix_terminal()
        local alloy_matrix_strong_all_terminal = {
            _name = "alloy_matrix_strong_all",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(instance.all_need_exp) > tonumber(_ED.maxtrix_essence_num) then
                    TipDlg.drawTextDailog(tipStringInfo_alloy_matrix_tips[16])
                    return
                end

                if tonumber(instance.all_need_gold) > tonumber(_ED.user_info.user_silver) then
                    app.load("client.packs.hero.HeroPatchInformationPageGetWay")
                    local fightWindow = HeroPatchInformationPageGetWay:new()
                    fightWindow:init(0,6)
                    fwin:open(fightWindow, fwin._windows)
                    return
                end

                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                            response.node:playActions()
                            state_machine.excute("alloy_matrix_ship_update",0,response.node.ship)
                        end 
                    end
                end
                protocol_command.ship_metal_onekey_escalate.param_list = instance.ship.ship_id .."\r\n"..instance.index.."\r\n" .. instance._current_level
                NetworkManager:register(protocol_command.ship_metal_onekey_escalate.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_auto_upgrade_silder_update_terminal = {
            _name = "sm_auto_upgrade_silder_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Slider_number = ccui.Helper:seekWidgetByName(instance.roots[1], "Slider_alloy_strong_all")
                local select_num = math.floor(tonumber(Slider_number:getPercent()) * (self._max_level) / 100) + self._min_level
                if select_num <= 0 then
                    select_num = 1
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_auto_upgrade_silder_update_terminal)
        state_machine.add(alloy_matrix_strong_all_terminal)
        state_machine.init()
    end
    init_alloy_matrix_terminal()
end

function AlloyMatrixStrengthenAll:setSelectNum(select_num)
    local root = self.roots[1]
    if self._current_level == select_num then
        return
    end
    self._current_level = select_num
    if self._current_level >= self._max_level then
        self._current_level = self._max_level
    end
    if self._min_level > 120 then
        self._min_level = 120
    end
    if self._current_level <= self._min_level then
        self._current_level = self._min_level
    end
    local percent = math.floor((self._current_level - self._min_level) / (self._max_level - self._min_level)*100)

    local Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_alloy_strong_all")
    Slider_number:setPercent(percent)
    local Text_alloy_strong_all_slider_t = ccui.Helper:seekWidgetByName(root, "Text_alloy_strong_all_slider_t")
    Text_alloy_strong_all_slider_t:setString(string.format(tipStringInfo_alloy_matrix_tips[11], self._current_level))
    local Text_prop_sell_end = ccui.Helper:seekWidgetByName(root, "Text_money")

    self:onUpdateUI()
end

function AlloyMatrixStrengthenAll:onUpdateUI()
    local root = self.roots[1]
    local Text_alloy_strong_all_add_atk_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_strong_all_add_atk_n")
    local Text_alloy_strong_all_add_df_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_strong_all_add_df_n")
    local Text_alloy_strong_add_all_hp_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_strong_add_all_hp_n")
    local Text_alloy_strong_add_all_injury_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_strong_add_all_injury_n")

    local Text_alloy_matrixl_strong_stuff_n_2 = ccui.Helper:seekWidgetByName(root,"Text_alloy_matrixl_strong_stuff_n_2")
    local Text_alloy_matrixl_strong_stuff_n_2_0 = ccui.Helper:seekWidgetByName(root,"Text_alloy_matrixl_strong_stuff_n_2_0")
    local Text_alloy_matrixl_strong_stuff_n_1 = ccui.Helper:seekWidgetByName(root,"Text_alloy_matrixl_strong_stuff_n_1")
    local Text_alloy_matrixl_strong_stuff_n_1_0 = ccui.Helper:seekWidgetByName(root,"Text_alloy_matrixl_strong_stuff_n_1_0")

    local metal_info = self.alloyMatrix.mmi[self.index .. ""]
    local all_need_exp = 0
    local all_need_gold = 0
    local all_add_atk = 0
    local all_add_dfn = 0
    local all_add_hp = 0
    local add_atk_percent = 0
    local add_dfn_percent = 0

    local add_attribute = nil
    for k,v in pairs(metal_info) do
        if v and _ED.user_alloy_matrix[tonumber(v)] then
            local metal = _ED.user_alloy_matrix[tonumber(v)]
            if tonumber(metal.metalLevel) < self._current_level then
                local need = self:getAllConsume(metal)
                all_need_exp = all_need_exp + need[1]
                all_need_gold = all_need_gold + need[2]
            end
            add_attribute = self:getAllAddAttrInfo(metal)
            if add_attribute then
                all_add_atk = all_add_atk + add_attribute[1]
                all_add_dfn = all_add_dfn + add_attribute[2]
                all_add_hp = all_add_hp + add_attribute[3]
                add_atk_percent = add_atk_percent + add_attribute[4]
                add_dfn_percent = add_dfn_percent + add_attribute[5]
            end
        end
    end

    Text_alloy_strong_all_add_atk_n:setString(all_add_atk)
    Text_alloy_strong_all_add_df_n:setString(all_add_dfn)
    Text_alloy_strong_add_all_hp_n:setString(all_add_hp)

    if add_atk_percent > 0 then
        Text_alloy_strong_add_all_injury_n:setString(string.format("%.2f%%", add_atk_percent))
        Text_alloy_strong_add_all_injury_n:setVisible(true)
    elseif add_dfn_percent > 0 then
        Text_alloy_strong_add_all_injury_n:setString(string.format("%.2f%%", add_dfn_percent))
        Text_alloy_strong_add_all_injury_n:setVisible(true)
    else
        Text_alloy_strong_add_all_injury_n:setString(0)
        Text_alloy_strong_add_all_injury_n:setVisible(false)
    end

    Text_alloy_matrixl_strong_stuff_n_1:setString(all_need_exp)
    Text_alloy_matrixl_strong_stuff_n_1_0:setString("/" .. _ED.maxtrix_essence_num)
    Text_alloy_matrixl_strong_stuff_n_1_0:setPositionX(Text_alloy_matrixl_strong_stuff_n_1:getPositionX() + Text_alloy_matrixl_strong_stuff_n_1:getContentSize().width)
    if all_need_exp > tonumber(_ED.maxtrix_essence_num) then
        Text_alloy_matrixl_strong_stuff_n_1:setColor(cc.c3b(255,0,0))
    else
        Text_alloy_matrixl_strong_stuff_n_1:setColor(cc.c3b(101,217,0))
    end
    self.all_need_exp = all_need_exp
    Text_alloy_matrixl_strong_stuff_n_2:setString(all_need_gold)
    Text_alloy_matrixl_strong_stuff_n_2_0:setString("/" .. _ED.user_info.user_silver)
    Text_alloy_matrixl_strong_stuff_n_2_0:setPositionX(Text_alloy_matrixl_strong_stuff_n_2:getPositionX() + Text_alloy_matrixl_strong_stuff_n_2:getContentSize().width)
    self.all_need_gold = all_need_gold
    if all_need_gold > tonumber(_ED.user_info.user_silver) then
        Text_alloy_matrixl_strong_stuff_n_2:setColor(cc.c3b(255,0,0))
    else
        Text_alloy_matrixl_strong_stuff_n_2:setColor(cc.c3b(101,217,0))
    end
end

function AlloyMatrixStrengthenAll:getAllConsume( currnetMetal )
    --合金信息
    function getMetalRow( metal )
        local mould_type = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.add_type)
        local current_row = nil
        local all_same_type = dms.searchs(dms["ship_metal_param"], ship_metal_param.group_id, mould_type)
        for i = tonumber(all_same_type[1][1]), (#all_same_type + tonumber(all_same_type[1][1])) do
            local group_id = dms.int(dms["ship_metal_param"], i, ship_metal_param.group_id)
            local grade = dms.int(dms["ship_metal_param"], i, ship_metal_param.metal_grade)
            local level = dms.int(dms["ship_metal_param"], i, ship_metal_param.metal_level)

            if mould_type == group_id and tonumber(metal.metalLevel) == grade and tonumber(metal.metalRankLevel) == level then
                current_row = dms.element(dms["ship_metal_param"], i)
                break
            end
        end
        return current_row
    end

    local quality = dms.int(dms["ship_metal_mould"], currnetMetal.metalMould, ship_metal_mould.quality)
    local quality_add1 = zstring.splits(dms.string(dms["ship_config"], 35, ship_config.param), "|", ",")
    local quality_add = zstring.splits(dms.string(dms["ship_config"], 36, ship_config.param), "|", ",")
    local need_percent = quality_add[quality +1][2]
    local need_percent1 = quality_add1[quality +1][2]

    local metal = {}
    local all_need_exp = 0
    local all_need_gold = 0
    table.merge(metal, currnetMetal)
    --根据等级循环
    for level = currnetMetal.metalLevel, (self._current_level-1) do
        metal.metalLevel = level
        local row = getMetalRow(metal)
        local next_grade_exp = dms.atoi(row, ship_metal_param.next_need_exp)
        local next_level_gold = dms.atoi(row, ship_metal_param.next_level_gold)
        if next_grade_exp == -1 then
            all_need_gold = all_need_gold + next_level_gold*need_percent
            --升阶后，阶数改变了,等级没变，所以加一次相同等级到下一等级所需经验
            if level < 120 then
                metal.metalRankLevel = tonumber(metal.metalRankLevel) + 1
                row = getMetalRow(metal)
                next_grade_exp = dms.atoi(row, ship_metal_param.next_need_exp)
                all_need_exp = all_need_exp + next_grade_exp*need_percent1
            end
        else
            all_need_exp = all_need_exp + next_grade_exp*need_percent1
        end
    end
    return {(all_need_exp - currnetMetal.experience), all_need_gold}
end

function AlloyMatrixStrengthenAll:playActions()
    local root = self.roots[1]
    local Text_alloy_strong_all_add_atk_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_strong_all_add_atk_n")
    local Text_alloy_strong_all_add_df_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_strong_all_add_df_n")
    local Text_alloy_strong_add_all_hp_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_strong_add_all_hp_n")
    local Text_alloy_strong_add_all_injury_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_strong_add_all_injury_n")

    local Panel_sz_dh_1 = ccui.Helper:seekWidgetByName(root, "Panel_sz_dh_1")
    local Panel_sz_dh_2 = ccui.Helper:seekWidgetByName(root, "Panel_sz_dh_2")
    local Panel_sz_dh_3 = ccui.Helper:seekWidgetByName(root, "Panel_sz_dh_3")
    local Panel_sz_dh_4 = ccui.Helper:seekWidgetByName(root, "Panel_sz_dh_4")

    local jsonFile = "images/ui/effice/effect_yjqhsz/effect_yjqhsz.json" 
    local atlasFile = "images/ui/effice/effect_yjqhsz/effect_yjqhsz.atlas"

    if tonumber(Text_alloy_strong_all_add_atk_n:getString()) > 0 then
        local animation1 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation1.animationNameList = {"animation"}
        sp.initArmature(animation1, false)
        local function changeActionCallback( ... )
            Panel_sz_dh_1:removeAllChildren(true)
        end
        animation1._invoke = changeActionCallback
        
        Panel_sz_dh_1:addChild(animation1)
        animation1:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(animation1, 0, 0, false)
    end

    if tonumber(Text_alloy_strong_all_add_df_n:getString()) > 0 then
        local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation2.animationNameList = {"animation"}
        sp.initArmature(animation2, false)
        local function changeActionCallback( ... )
            Panel_sz_dh_2:removeAllChildren(true)
        end
        animation2._invoke = changeActionCallback
            
        Panel_sz_dh_2:addChild(animation2)
        animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(animation2, 0, 0, false)
    end

    if tonumber(Text_alloy_strong_add_all_hp_n:getString()) > 0 then
        local animation3 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation3.animationNameList = {"animation"}
        sp.initArmature(animation3, false)
        local function changeActionCallback( ... )
            Panel_sz_dh_3:removeAllChildren(true)
        end
        animation3._invoke = changeActionCallback
        Panel_sz_dh_3:addChild(animation3)
        animation3:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(animation3, 0, 0, false)
    end

    if Text_alloy_strong_add_all_injury_n:isVisible() then
        local animation4 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation4.animationNameList = {"animation"}
        sp.initArmature(animation4, false)
        local function changeActionCallback( ... )
            Panel_sz_dh_4:removeAllChildren(true)
        end
        animation4._invoke = changeActionCallback
        Panel_sz_dh_4:addChild(animation4)
        animation4:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(animation4, 0, 0, false)
    end
end

function AlloyMatrixStrengthenAll:onUpdateDraw()
    local root = self.roots[1]
    --图标
    local Panel_matrix_all_top = ccui.Helper:seekWidgetByName(root,"Panel_matrix_all_top")
    local Panel_recommend_strong_frame_list = ccui.Helper:seekWidgetByName(root,"Panel_recommend_strong_frame_list_icon_2")

    local Panel_recommend_strong_frame_list_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_recommend_strong_frame_list_icon_1")
    --攻击
    local Text_alloy_strong_all_atk_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_all_atk_n")
    local Image_3 = ccui.Helper:seekWidgetByName(root,"Image_3")

    --防御
    local Text_alloy_strong_all_df_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_all_df_n")
    local Image_3_1 = ccui.Helper:seekWidgetByName(root,"Image_3_1")

    --血量
    local Text_alloy_strong_all_hp_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_all_hp_n")
    local Image_3_1_0 = ccui.Helper:seekWidgetByName(root,"Image_3_1_0")

    -- 加成、减免
    local Text_alloy_strong_all_injury_t_1 = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_all_injury_t_1")
    local Text_alloy_strong_all_injury_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_all_injury_n")

    --消耗
    local Text_alloy_matrixl_strong_stuff_n_2 = ccui.Helper:seekWidgetByName(root,"Text_alloy_matrixl_strong_stuff_n_2")
    local Text_alloy_matrixl_strong_stuff_n_2_0 = ccui.Helper:seekWidgetByName(root,"Text_alloy_matrixl_strong_stuff_n_2_0")
    local Text_alloy_matrixl_strong_stuff_n_1 = ccui.Helper:seekWidgetByName(root,"Text_alloy_matrixl_strong_stuff_n_1")
    local Text_alloy_matrixl_strong_stuff_n_1_0 = ccui.Helper:seekWidgetByName(root,"Text_alloy_matrixl_strong_stuff_n_1_0")

    --合金加成
    function getAddAttrInfo( metal_info )
        local add_attribute = ""
        if not metal_info then
            return add_attribute
        end
        local mould_type = dms.int(dms["ship_metal_mould"], metal_info.metalMould, ship_metal_mould.add_type)
        local all_same_type = dms.searchs(dms["ship_metal_param"], ship_metal_param.group_id, mould_type)
        for i = tonumber(all_same_type[1][1]), (#all_same_type + tonumber(all_same_type[1][1])) do
            local group_id = dms.int(dms["ship_metal_param"], i, ship_metal_param.group_id)
            local grade = dms.int(dms["ship_metal_param"], i, ship_metal_param.metal_grade)
            local level = dms.int(dms["ship_metal_param"], i, ship_metal_param.metal_level)
            local add = dms.string(dms["ship_metal_param"], i, ship_metal_param.metal_add)
            if mould_type == group_id and tonumber(metal_info.metalLevel) == grade and tonumber(metal_info.metalRankLevel) == level then
                add_attribute = add
                break
            end
        end
        return add_attribute
    end
    
    --绘制图标
    local panel_size = Panel_matrix_all_top:getContentSize()
    local metal_info = self.alloyMatrix.mmi[self.index .. ""]
    local icon_size = Panel_recommend_strong_frame_list_icon_1:getContentSize()
    local scale = Panel_recommend_strong_frame_list:getScale()
    local list_width = (icon_size.width*table.nums(metal_info) + 10*(table.nums(metal_info) -1))
    Panel_recommend_strong_frame_list:setContentSize(cc.size(list_width, icon_size.height))
    Panel_recommend_strong_frame_list:setAnchorPoint(cc.p(0, 0))
    
    local list_size = Panel_recommend_strong_frame_list:getContentSize()
    Panel_recommend_strong_frame_list:setPosition(cc.p(panel_size.width/2 - list_width*scale/2, 14))

    local index = 0

    local all_add_atk = 0
    local all_add_dfn = 0
    local all_add_hp = 0
    local add_atk_percent = 0
    local add_dfn_percent = 0
    self._current_level = 120
    for k,v in pairs(metal_info) do
        if v and _ED.user_alloy_matrix[tonumber(v)] then
            local metal = _ED.user_alloy_matrix[tonumber(v)]
            --获取最小等级
            if tonumber(metal.metalLevel) < self._current_level then
                self._current_level = tonumber(metal.metalLevel)
            end

            local di_kuang = Panel_recommend_strong_frame_list_icon_1:clone()
            --图标
            local quality = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.quality)
            quality = quality +1
            di_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
            local icon = di_kuang:getChildByName("Panel_recommend_strong_list_icon_1")
            local cell = AlloyMatrixFormationCell:createCell()
            cell:init({metal.id, false})
            icon:addChild(cell)

            di_kuang:setPosition(cc.p(((icon_size.width + 10)*index), 0))
            Panel_recommend_strong_frame_list:addChild(di_kuang)
            index = index + 1

            --属性加成
            local big_type = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.head)
            local metal_type = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.mould_type)
            local quality = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.quality)

            local quality_add = zstring.splits(dms.string(dms["ship_config"], 35, ship_config.param), "|", ",")
            local add_percent = tonumber(quality_add[quality +1][2])
            local add_attribute = ""
            if big_type == 1 then
                add_attribute = getAddAttrInfo(metal)
                local add_infos = zstring.splits(add_attribute, "|", ",")
                for k= 1, table.nums(add_infos) do
                    if tonumber(add_infos[k][1]) == 0 then
                        all_add_hp = all_add_hp + tonumber(add_infos[k][2])*add_percent
                    elseif tonumber(add_infos[k][1]) == 1 then
                        all_add_atk = all_add_atk + tonumber(add_infos[k][2])*add_percent
                    elseif tonumber(add_infos[k][1]) == 2 then
                        all_add_dfn = all_add_dfn + tonumber(add_infos[k][2])*add_percent
                    end
                end
            elseif big_type == 2 then
                add_attribute = getAddAttrInfo(metal)
                local add_infos = zstring.split(add_attribute, ",")
                if tonumber(add_infos[1]) == 33 then
                    add_atk_percent = add_atk_percent + tonumber(add_infos[2])*add_percent
                    
                elseif tonumber(add_infos[1]) == 34 then
                    add_dfn_percent = add_dfn_percent + tonumber(add_infos[2])*add_percent
                end
            end
        end
    end
    Text_alloy_strong_all_atk_n:setString(all_add_atk)
    Text_alloy_strong_all_df_n:setString(all_add_dfn)
    Text_alloy_strong_all_hp_n:setString(all_add_hp)

    local Image_3_1_1 = ccui.Helper:seekWidgetByName(root,"Image_3_1_1")
    if add_atk_percent > 0 then
        Text_alloy_strong_all_injury_t_1:setString(tipStringInfo_alloy_matrix_tips[5])
        Text_alloy_strong_all_injury_n:setString(string.format("%.2f%%", add_atk_percent))

        Text_alloy_strong_all_injury_t_1:setVisible(true)
        Text_alloy_strong_all_injury_n:setVisible(true)
        Image_3_1_1:setVisible(true)
    elseif add_dfn_percent > 0 then
        Text_alloy_strong_all_injury_t_1:setString(tipStringInfo_alloy_matrix_tips[6])
        Text_alloy_strong_all_injury_n:setString(string.format("%.2f%%", add_dfn_percent))

        Text_alloy_strong_all_injury_t_1:setVisible(true)
        Text_alloy_strong_all_injury_n:setVisible(true)
        Image_3_1_1:setVisible(true)
    else
        Text_alloy_strong_all_injury_t_1:setVisible(false)
        Text_alloy_strong_all_injury_n:setVisible(false)
        Text_alloy_strong_all_injury_n:setString(0)
        Image_3_1_1:setVisible(false)
    end

    self._min_level = self._current_level + 1
    self:setSelectNum(self._min_level)
end

function AlloyMatrixStrengthenAll:getAllAddAttrInfo(metalInfo)
    function getAddAttrInfo( metal_info )
        local add_attribute = ""
        if not metal_info then
            return add_attribute
        end
        local mould_type = dms.int(dms["ship_metal_mould"], metalInfo.metalMould, ship_metal_mould.add_type) 
        local all_same_type = dms.searchs(dms["ship_metal_param"], ship_metal_param.group_id, mould_type)
        for i = tonumber(all_same_type[1][1]), (#all_same_type + tonumber(all_same_type[1][1])) do
            local group_id = dms.int(dms["ship_metal_param"], i, ship_metal_param.group_id)
            local grade = dms.int(dms["ship_metal_param"], i, ship_metal_param.metal_grade)
            local level = dms.int(dms["ship_metal_param"], i, ship_metal_param.metal_level)
            local add = dms.string(dms["ship_metal_param"], i, ship_metal_param.metal_add)
            if mould_type == group_id and tonumber(metal_info.metalLevel) == grade and tonumber(metal_info.metalRankLevel) == level then
                add_attribute = add
                break
            end
        end
        return add_attribute
    end

    local all_add_atk = 0
    local all_add_dfn = 0
    local all_add_hp = 0
    local add_atk_percent = 0
    local add_dfn_percent = 0

    local metal = {}
    table.merge(metal, metalInfo)
    if tonumber(metal.metalLevel) < self._current_level then
        metal.metalLevel = self._current_level
        local mould_type = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.add_type)
        local all_same_type = dms.searchs(dms["ship_metal_param"], ship_metal_param.group_id, mould_type)
        for i = tonumber(all_same_type[1][1]), (#all_same_type + tonumber(all_same_type[1][1])) do
            local group_id = dms.int(dms["ship_metal_param"], i, ship_metal_param.group_id)
            local grade = dms.int(dms["ship_metal_param"], i, ship_metal_param.metal_grade)
            local level = dms.int(dms["ship_metal_param"], i, ship_metal_param.metal_level)
            local next_need_exp = dms.string(dms["ship_metal_param"], i, ship_metal_param.next_need_exp)
            if mould_type == group_id and tonumber(metal.metalLevel) == grade and tonumber(next_need_exp) > 0 then
                metal.metalRankLevel = level
                break
            elseif mould_type == group_id and tonumber(metal.metalLevel) == grade and tonumber(next_need_exp) and metal.metalLevel == 120 then
                metal.metalRankLevel = level
                break
            end
        end
    end

    local big_type = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.head)
    local metal_type = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.mould_type)
    local quality = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.quality)

    local quality_add = zstring.splits(dms.string(dms["ship_config"], 35, ship_config.param), "|", ",")
    local add_percent = tonumber(quality_add[quality +1][2])
    local add_attribute = ""
    if big_type == 1 then
        add_attribute = getAddAttrInfo(metal)
        local add_infos = zstring.splits(add_attribute, "|", ",")
        for k= 1, table.nums(add_infos) do
            if tonumber(add_infos[k][1]) == 0 then
                all_add_hp = all_add_hp + tonumber(add_infos[k][2])*add_percent
            elseif tonumber(add_infos[k][1]) == 1 then
                all_add_atk = all_add_atk + tonumber(add_infos[k][2])*add_percent
            elseif tonumber(add_infos[k][1]) == 2 then
                all_add_dfn = all_add_dfn + tonumber(add_infos[k][2])*add_percent
            end
        end
    elseif big_type == 2 then
        add_attribute = getAddAttrInfo(metal)
        local add_infos = zstring.split(add_attribute, ",")
        if tonumber(add_infos[1]) == 33 then
            add_atk_percent = add_atk_percent + tonumber(add_infos[2])*add_percent
        elseif tonumber(add_infos[1]) == 34 then
            add_dfn_percent = add_dfn_percent + tonumber(add_infos[2])*add_percent
        end
    end
    return {all_add_atk, all_add_dfn, all_add_hp, add_atk_percent, add_dfn_percent}
end

function AlloyMatrixStrengthenAll:onUpdate( dt )
    
end

function AlloyMatrixStrengthenAll:init(params)
    self.index = params[1]
    self.ship = params[2]
    self.alloyMatrix = _ED.user_ship[self.ship.ship_id].alloyMatrix
    self:onInit()
    return self
end

function AlloyMatrixStrengthenAll:onInit()
    local csbItem = csb.createNode("cultivate/alloy_matrix_all_strong.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_matrix_fusion_back"), nil, 
    {
        terminal_name = "alloy_matrix_strengthen_all_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    --一键强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_matrix_strong_all"), nil, 
    {
        terminal_name = "alloy_matrix_strong_all", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    local Slider_number = ccui.Helper:seekWidgetByName(root, "Slider_alloy_strong_all")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            local select_num = math.floor(tonumber(sender:getPercent()) * (self._max_level) / 100) + self._min_level
            if select_num <= self._min_level then
                select_num = self._min_level
            elseif select_num >= self._max_level then
                select_num = self._max_level
            end
            local Text_alloy_strong_all_slider_t = ccui.Helper:seekWidgetByName(root, "Text_alloy_strong_all_slider_t")
            Text_alloy_strong_all_slider_t:setString(string.format(tipStringInfo_alloy_matrix_tips[11], select_num))
        end
    end

    local function uiChangeEvent( sender,eventType )
        if eventType == 2 then
            state_machine.excute("sm_auto_upgrade_silder_update", 0, {sender:getPercent()})
        end
    end
    Slider_number:addEventListener(percentChangedEvent)
    Slider_number:addTouchEventListener(uiChangeEvent)

    local Panel_qhlb_dh = ccui.Helper:seekWidgetByName(root, "Panel_qhlb_dh")
    local jsonFile = "images/ui/effice/effect_qhlb/effect_qhlb.json" 
    local atlasFile = "images/ui/effice/effect_qhlb/effect_qhlb.atlas" 
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    animation.animationNameList = {"animation"}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    Panel_qhlb_dh:addChild(animation)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation, 0, 0, false)

    self:onUpdateDraw()
end

function AlloyMatrixStrengthenAll:onEnterTransitionFinish()
end

function AlloyMatrixStrengthenAll:onExit()
    state_machine.remove("tab_btn_change")
end
