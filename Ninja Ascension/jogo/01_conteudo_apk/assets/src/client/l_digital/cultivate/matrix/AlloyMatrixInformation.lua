-----------------------------
-- 合金矩阵信息
-----------------------------
AlloyMatrixInformation = class("AlloyMatrixInformationClass", Window)

function AlloyMatrixInformation:ctor()
	self.super:ctor()
	self.roots = {}

    app.load("client.l_digital.cultivate.matrix.AlloyMatrixSelectFormation")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixStrengthenAll")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFormationReword")
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixRule")
    
    local function init_alloy_matrix_information_terminal()
        local alloy_matrix_information_update_terminal = {
            _name = "alloy_matrix_information_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.index = params
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local alloy_matrix_information_open_select_formation_terminal = {
            _name = "alloy_matrix_information_open_select_formation",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("alloy_matrix_select_formation_open", 0, {cell.index, cell.ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local alloy_matrix_to_down_all_terminal = {
            _name = "alloy_matrix_to_down_all",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local ship_id = cell.ship.ship_id
                local metals = cell.alloyMatrix.mmi[cell.index .. ""]
                if metals and table.nums(metals) > 0 then
                else
                    TipDlg.drawTextDailog(tipStringInfo_alloy_matrix_tips[10])
                    return
                end
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                            if cell.panel_cell then
                                state_machine.excute("alloy_matrix_formation_update",0,{cell.panel_cell})
                                cell:drawMatrixInfo()
                                cell:onUpdateDraw(cell.currentIndex)
                            end
                            state_machine.excute("alloy_matrix_ship_update",0,response.node.ship)
                        end 
                    end
                end
                protocol_command.ship_metal_set.param_list = ship_id.."\r\n"..cell.index.."\r\n".."2".."\r\n".. "-1"
                NetworkManager:register(protocol_command.ship_metal_set.code, nil, nil, nil, cell, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --一键强化
        local alloy_matrix_information_open_strengthen_all_terminal = {
            _name = "alloy_matrix_information_open_strengthen_all",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local metals = cell.alloyMatrix.mmi[cell.index .. ""]
                if metals and table.nums(metals) > 0 then
                    state_machine.excute("alloy_matrix_strengthen_all_open", 0, {cell.index, cell.ship})
                else
                    TipDlg.drawTextDailog(tipStringInfo_alloy_matrix_tips[10])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --规则
        local alloy_matrix_formation_rule_open_terminal = {
            _name = "alloy_matrix_formation_rule_open",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("alloy_matrix_rule_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --矩阵奖励红点
        local alloy_matrix_formation_reword_redot_terminal = {
            _name = "alloy_matrix_formation_reword_redot",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:formationRewordRedot()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(alloy_matrix_information_update_terminal)
        state_machine.add(alloy_matrix_information_open_select_formation_terminal)
        state_machine.add(alloy_matrix_to_down_all_terminal)
        state_machine.add(alloy_matrix_information_open_strengthen_all_terminal)
        state_machine.add(alloy_matrix_formation_rule_open_terminal)
        state_machine.add(alloy_matrix_formation_reword_redot_terminal)
        state_machine.init()
    end
    init_alloy_matrix_information_terminal()
end

function AlloyMatrixInformation:onUpdateDraw()
    self:formationRewordRedot()
    
	local root = self.roots[1]
    local Text_alloy_attr_atk_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_attr_atk_n")
    local Text_alloy_attr_defense_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_attr_defense_n")
    local Text_alloy_attr_hp_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_attr_hp_n")
    local Text_alloy_attr_hurt_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_attr_hurt_n")
    local Text_alloy_attr_hurt_t = ccui.Helper:seekWidgetByName(root,"Text_alloy_attr_hurt_t")

    local Text_alloy_attr_fomation_lock = ccui.Helper:seekWidgetByName(root,"Text_alloy_attr_fomation_lock")
    local Text_alloy_attr_state = ccui.Helper:seekWidgetByName(root,"Text_alloy_attr_state")

    local Text_alloy_attr_add_atk_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_attr_add_atk_n")
    local Text_alloy_attr_add_defense_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_attr_add_defense_n")
    local Text_alloy_attr_add_hp_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_attr_add_hp_n")
    local Text_alloy_attr_add_hurt_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_attr_add_hurt_n")
    local Text_alloy_attr_add_hurt_t = ccui.Helper:seekWidgetByName(root,"Text_alloy_attr_add_hurt_t")

    local Panel_alloy_attr_add_box = ccui.Helper:seekWidgetByName(root,"Panel_alloy_attr_add_box")

    for i=1,8 do
        local Panel_alloy_formaiton_icon = ccui.Helper:seekWidgetByName(root,"Panel_alloy_formaiton_icon_" .. i)
        Panel_alloy_formaiton_icon:removeBackGroundImage()
    end

    --合金加成
    function getAddAttrInfo( metal_info )
        local add_attribute = ""
        if not metal_info then
            return add_attribute
        end
        local mould_type = dms.int(dms["ship_metal_mould"], metal_info.metalMould, ship_metal_mould.add_type)
        for i = 1, #dms["ship_metal_param"] do
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
    local metal_info = self.alloyMatrix.mmi[self.index .. ""]
    for i = 1, (self.index + 1)*2 do
        local Panel_alloy_formaiton_icon = ccui.Helper:seekWidgetByName(root,"Panel_alloy_formaiton_icon_" .. i)
        Panel_alloy_formaiton_icon:removeBackGroundImage()
        local add_attribute = ""
        if metal_info and table.nums(metal_info) ~= 0 and metal_info[i .. ""] and _ED.user_alloy_matrix[tonumber(metal_info[i .. ""])] then
            local user_metal = _ED.user_alloy_matrix[tonumber(metal_info[i .. ""])]

            local big_type = dms.int(dms["ship_metal_mould"], user_metal.metalMould, ship_metal_mould.head)
            local metal_type = dms.int(dms["ship_metal_mould"], user_metal.metalMould, ship_metal_mould.mould_type)
            local quality = dms.int(dms["ship_metal_mould"], user_metal.metalMould, ship_metal_mould.quality)

            local quality_add = zstring.splits(dms.string(dms["ship_config"], 35, ship_config.param), "|", ",")
            local add_percent = tonumber(quality_add[quality +1][2])

            Panel_alloy_formaiton_icon:setBackGroundImage(string.format("images/ui/text/smhj/hj_%d.png", metal_type))

            if big_type == 1 then
                add_attribute = getAddAttrInfo( _ED.user_alloy_matrix[tonumber(metal_info[i .. ""])])
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
                add_attribute = getAddAttrInfo( _ED.user_alloy_matrix[tonumber(metal_info[i .. ""])])
                local add_infos = zstring.split(add_attribute, ",")
                if tonumber(add_infos[1]) == 33 then
                    add_atk_percent = add_atk_percent + tonumber(add_infos[2])*add_percent
                elseif tonumber(add_infos[1]) == 34 then
                    add_dfn_percent = add_dfn_percent + tonumber(add_infos[2])*add_percent
                end
            end
        end
    end
    Text_alloy_attr_fomation_lock:setVisible((not metal_info or table.nums(metal_info) == 0))

    Text_alloy_attr_atk_n:setString(all_add_atk)
    Text_alloy_attr_defense_n:setString(all_add_dfn)
    Text_alloy_attr_hp_n:setString(all_add_hp)
    if add_atk_percent > 0 then
        Text_alloy_attr_hurt_t:setString(tipStringInfo_alloy_matrix_tips[5])
        Text_alloy_attr_hurt_n:setString(string.format("%.2f%%", add_atk_percent))

        Text_alloy_attr_hurt_t:setVisible(true)
        Text_alloy_attr_hurt_n:setVisible(true)
    elseif add_dfn_percent > 0 then
        Text_alloy_attr_hurt_t:setString(tipStringInfo_alloy_matrix_tips[6])
        Text_alloy_attr_hurt_n:setString(string.format("%.2f%%", add_dfn_percent))

        Text_alloy_attr_hurt_t:setVisible(true)
        Text_alloy_attr_hurt_n:setVisible(true)
    else
        Text_alloy_attr_hurt_t:setVisible(false)
        Text_alloy_attr_hurt_n:setVisible(false)
    end
    
    --矩阵加成
    function getMatrixAddAttrInfo( id, quality )
        local add_attribute = ""
        if not id or not quality then
            return add_attribute
        end
        local group_id = dms.int(dms["ship_matrix_mould"], id, ship_matrix_mould.group_id)

        for i = 1, #dms["ship_matrix_param"] do
            local group_id1 = dms.int(dms["ship_matrix_param"], i, ship_matrix_param.group_id)
            local quality1 = dms.int(dms["ship_matrix_param"], i, ship_matrix_param.quality)
            local add = dms.string(dms["ship_matrix_param"], i, ship_matrix_param.add)

            if group_id == group_id1 and tonumber(quality) == quality1 then
                add_attribute = add
                break
            end
        end
        return add_attribute
    end

    local matrix = self.alloyMatrix.ma[self.index .. ""]
    local name = nil
    local need_metals = nil
    local add_attribute = nil
    if matrix and table.nums(matrix) ~= 0 then
        local id = table.keys(matrix)[1]
        local quality = tonumber(table.values(matrix)[1])
        --获取装备名称索引
        local nameindex = dms.int(dms["ship_matrix_mould"], id, ship_matrix_mould.name)
        --通过索引找到word_mould
        local word_info = dms.element(dms["word_mould"], nameindex)
        name = word_info[3]
        need_metals = dms.string(dms["ship_matrix_mould"], id, ship_matrix_mould.metal_need)
        Text_alloy_attr_state:setString(name)
        Text_alloy_attr_state:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))


        add_attribute = zstring.splits(getMatrixAddAttrInfo(id, quality), "|", ",")
        local add_hurt = ""
        for i,v in ipairs(add_attribute) do
            if tonumber(add_attribute[i][1]) == 0 then
                Text_alloy_attr_add_hp_n:setString("+" .. add_attribute[i][2])
            elseif tonumber(add_attribute[i][1]) == 1 then
                Text_alloy_attr_add_atk_n:setString("+" .. add_attribute[i][2])
            elseif tonumber(add_attribute[i][1]) == 2 then
                Text_alloy_attr_add_defense_n:setString("+" .. add_attribute[i][2])
            elseif tonumber(add_attribute[i][1]) == 85 then
                add_hurt = add_attribute[i][2]
            end
        end

        
        if add_hurt == "" then
            Text_alloy_attr_add_hurt_t:setString(add_hurt)
            Text_alloy_attr_add_hurt_n:setString(add_hurt)
        else
            Text_alloy_attr_add_hurt_t:setString(tipStringInfo_alloy_matrix_tips[19])
            Text_alloy_attr_add_hurt_n:setString("+" .. string.format("%.2f%%", tonumber(add_hurt)))
        end

        Panel_alloy_attr_add_box:setVisible(true)
    else
        Text_alloy_attr_state:setString(tipStringInfo_alloy_matrix_tips[15])
        Text_alloy_attr_state:setColor(cc.c3b(tipStringInfo_quality_color_Type[1][1],tipStringInfo_quality_color_Type[1][2],tipStringInfo_quality_color_Type[1][3]))
        Panel_alloy_attr_add_box:setVisible(false)
    end
end

function AlloyMatrixInformation:onUpdate( dt )
    
end

function AlloyMatrixInformation:formationRewordRedot()
    local root = self.roots[1]
    local Image_hjcq_tip = ccui.Helper:seekWidgetByName(root,"Image_hjcq_tip")
    local reword = _ED.user_ship[self.ship.ship_id].alloyMatrix.mr
    Image_hjcq_tip:setVisible(false)
    if reword and table.nums(reword) > 0 then
        local state = table.values(reword)
        for i,v in ipairs(state) do
            if tonumber(v) == 0 then
                Image_hjcq_tip:setVisible(true)
                break
            end
        end
    else
        Image_hjcq_tip:setVisible(false)
    end
end

function AlloyMatrixInformation:init(ship, index)
	self.ship = ship
    self.index = index
    self.alloyMatrix = _ED.user_ship[self.ship.ship_id].alloyMatrix
	self:onInit()
    return self
end

function AlloyMatrixInformation:onInit()
    local csbItem = csb.createNode("cultivate/alloy_attr_infor_cell.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    --一键卸下
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_6"), nil, 
    {
        terminal_name = "alloy_matrix_to_down_all", 
        terminal_state = 0,
        cell = self,
        touch_black = true,
    }, nil, 3)

    --一键强化
    if funOpenDrawTip(184, false) then
        ccui.Helper:seekWidgetByName(root,"Button_6_0"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root,"Button_6_0"):setVisible(true)
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_6_0"), nil, 
    {
        terminal_name = "alloy_matrix_information_open_strengthen_all", 
        terminal_state = 0,
        cell = self,
        touch_black = true,
    }, nil, 3)

    --一键放置
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_6_1"), nil, 
    {
        terminal_name = "alloy_matrix_information_open_select_formation", 
        terminal_state = 0,
        cell = self,
        touch_black = true,
    }, nil, 3)

    --规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_attr_infor"), nil, 
    {
        terminal_name = "alloy_matrix_formation_rule_open", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    --矩阵列表
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_attr_formation_list"), nil, 
    {
        terminal_name = "alloy_matrix_formation_reword_open", 
        terminal_state = 0,
        _ship = self.ship,
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
end

function AlloyMatrixInformation:onEnterTransitionFinish()
end

function AlloyMatrixInformation:createCell()
	local cell = AlloyMatrixInformation:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function AlloyMatrixInformation:onExit()
    state_machine.remove("alloy_matrix_update_choose_state")
end
