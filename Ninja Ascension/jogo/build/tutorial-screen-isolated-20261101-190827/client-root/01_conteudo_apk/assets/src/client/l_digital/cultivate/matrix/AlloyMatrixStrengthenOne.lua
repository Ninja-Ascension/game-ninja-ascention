-----------------------------
-- 单个合金强化
-----------------------------
AlloyMatrixStrengthenOne = class("AlloyMatrixStrengthenOneClass", Window)

function AlloyMatrixStrengthenOne:ctor()
	self.super:ctor()
	self.roots = {}
    
    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFormationCell")

    local function init_alloy_matrix_formation_terminal()
        local alloy_matrix_strengthen_one_show_terminal = {
            _name = "alloy_matrix_strengthen_one_show",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.cell = params
                instance:onUpdateDraw(instance.cell.matrix_id)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local alloy_matrix_strengthen_one_show_hide_terminal = {
            _name = "alloy_matrix_strengthen_one_show_hide",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         local alloy_matrix_strong_update_terminal = {
            _name = "alloy_matrix_strong_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _type = params._datas._type
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw(response.node.metal.id)
                            if instance.cell then
                                instance.cell:onUpdateDraw()
                            end
                            -- Reforzar UNA aleacion no pasa por alloy_matrix_ship_update,
                            -- asi que el cartel de "+N poder" hay que pedirlo aqui.
                            smFightingChange()
                        end 
                    end
                end
                protocol_command.ship_metal_escalate.param_list = instance.metal.id.."\r\n".._type
                NetworkManager:register(protocol_command.ship_metal_escalate.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        
        state_machine.add(alloy_matrix_strengthen_one_show_terminal)
        state_machine.add(alloy_matrix_strengthen_one_show_hide_terminal)
        state_machine.add(alloy_matrix_strong_update_terminal)
        state_machine.init()
    end
    init_alloy_matrix_formation_terminal()
end

function AlloyMatrixStrengthenOne:onUpdateDraw(params)
	local root = self.roots[1]
    local metal = _ED.user_alloy_matrix[tonumber(params)]
    self.metal = metal

    local Panel_alloy_up_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_alloy_up_icon_1")
    local Text_alloy_up_infor_add_effect = ccui.Helper:seekWidgetByName(root,"Text_alloy_up_infor_add_effect")

    --合金图片
    local quality = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.quality)
    Panel_alloy_up_icon_1:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality+1))
    Panel_alloy_up_icon_1:removeAllChildren(true)

    local cell = AlloyMatrixFormationCell:createCell()
    cell:init({metal.id, false})
    Panel_alloy_up_icon_1:addChild(cell)

    --获取装备名称索引
    local nameindex = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_matrix_mould.name)
    --通过索引找到word_mould
    local word_info = dms.element(dms["word_mould"], nameindex)
    if metal.metalRankLevel > 0 then
        Text_alloy_up_infor_add_effect:setString(word_info[3] .. "+" .. metal.metalRankLevel)
    else
        Text_alloy_up_infor_add_effect:setString(word_info[3])
    end
    quality = quality +1
    Text_alloy_up_infor_add_effect:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))

    local metal_info = self.alloyMatrix.mmi[self.index .. ""]
    for i = 1, (self.index + 1)*2 do
        local Panel_alloy_up_add_icon = ccui.Helper:seekWidgetByName(root,"Panel_alloy_up_add_icon_" .. i)
        Panel_alloy_up_add_icon:removeBackGroundImage()
        if metal_info and table.nums(metal_info) ~= 0 and metal_info[i .. ""] and _ED.user_alloy_matrix[tonumber(metal_info[i .. ""])] then
            --矩阵小图标
            local user_metal = _ED.user_alloy_matrix[tonumber(metal_info[i .. ""])]
            local metal_type = dms.int(dms["ship_metal_mould"], user_metal.metalMould, ship_metal_mould.mould_type)
            local path = tonumber(metal.id) == tonumber(user_metal.id) and "images/ui/text/smhj/hj_%d.png" or "images/ui/text/smhj/wjhhj_%d.png"
            Panel_alloy_up_add_icon:setBackGroundImage(string.format(path, metal_type))
        end
    end

    --合金信息
    function getMetalRow( metal )
        local mould_type = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.add_type)
        local current_row = nil
        for i = 1, #dms["ship_metal_param"] do
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
    
    local current_row = getMetalRow(metal)
    local big_type = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.head)

    --品质加成系数
    local quality = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.quality)
    local quality_add = zstring.splits(dms.string(dms["ship_config"], 35, ship_config.param), "|", ",")
    local add_percent = tonumber(quality_add[quality +1][2])

    --品质消耗系数
    local quality_need = zstring.splits(dms.string(dms["ship_config"], 36, ship_config.param), "|", ",")
    local need_percent = tonumber(quality_need[quality +1][2])

    local Panel_alloy_strong_effect_box = ccui.Helper:seekWidgetByName(root,"Panel_alloy_strong_effect_box")
    local Panel_alloy_up_effect_box = ccui.Helper:seekWidgetByName(root,"Panel_alloy_up_effect_box")

    if current_row then
        local next_grade_exp = dms.atoi(current_row, ship_metal_param.next_need_exp)
        local next_level_gold = dms.atoi(current_row, ship_metal_param.next_level_gold)

        local Text_alloy_strong_lv_t = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_lv_t")
        local LoadingBar_alloy_strong_lv = ccui.Helper:seekWidgetByName(root,"LoadingBar_alloy_strong_lv")
        local Text_alloy_strong_lv_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_lv_n")
    
        local Text_alloy_strong_atk_t = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_atk_t")
        local Text_alloy_strong_hp_t = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_hp_t")

        local Text_alloy_strong_atk_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_atk_n")
        local Text_alloy_strong_hp_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_hp_n")

        local Text_alloy_strong_add_atk_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_add_atk_n")
        local Text_alloy_strong_add_hp_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_add_hp_n")

        local Image_3 = ccui.Helper:seekWidgetByName(root,"Image_3")

        local Image_alloy_attr_top = ccui.Helper:seekWidgetByName(root,"Image_alloy_attr_top")
        local Panel_alloy_attr_top_box = ccui.Helper:seekWidgetByName(root,"Panel_alloy_attr_top_box")
        Panel_alloy_attr_top_box:setVisible(true)

        local Text_alloy_strong_infor_condition = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_infor_condition")
        local Text_alloy_strong_infor_add_effect_state = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_infor_add_effect_state")

        local Text_alloy_strong_stuff_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_stuff_n")

        --进阶界面
        local Panel_alloy_up_icon_2 = ccui.Helper:seekWidgetByName(root,"Panel_alloy_up_icon_2")
        local Panel_alloy_up_icon_3 = ccui.Helper:seekWidgetByName(root,"Panel_alloy_up_icon_3")
        local Text_alloy_up_effect_t = ccui.Helper:seekWidgetByName(root,"Text_alloy_up_effect_t")
        local Text_alloy_up_add_effect_t = ccui.Helper:seekWidgetByName(root,"Text_alloy_up_add_effect_t")
        local Text_alloy_up_effect_lv_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_up_effect_lv_n")
        local Text_alloy_up_add_effect_lv_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_up_add_effect_lv_n")
        local Text_alloy_up_money_condition_n = ccui.Helper:seekWidgetByName(root,"Text_alloy_up_money_condition_n")

        if next_grade_exp ~= -1 and next_level_gold == -1 then
            Text_alloy_strong_atk_t:setPositionX(self.Text_alloy_strong_atk_t_posX )
            Text_alloy_strong_atk_n:setPositionX(self.Text_alloy_strong_atk_n_posX)
            Text_alloy_strong_hp_t:setPositionX(self.Text_alloy_strong_hp_t_posX)
            Text_alloy_strong_hp_n:setPositionX(self.Text_alloy_strong_hp_n_posX)

            -- 属性
            if big_type == 1 then
                local add_attribute = dms.atos(current_row, ship_metal_param.metal_add)
                local add_infos = zstring.splits(add_attribute, "|", ",")
                Text_alloy_strong_atk_t:setString(tipStringInfo_trialTower_attribute_info[tonumber(add_infos[1][1]) + 1][1])
                Text_alloy_strong_hp_t:setString(tipStringInfo_trialTower_attribute_info[tonumber(add_infos[2][1]) + 1][1])
                
                Text_alloy_strong_atk_n:setString(tonumber(add_infos[1][2])*add_percent)
                Text_alloy_strong_hp_n:setString(tonumber(add_infos[2][2])*add_percent)

                Image_3:setPositionY(self.default_posY)

                Text_alloy_strong_hp_t:setVisible(true)
                Text_alloy_strong_hp_n:setVisible(true)
            elseif big_type == 2 then
                local add_attribute = dms.atos(current_row, ship_metal_param.metal_add)
                local add_infos = zstring.split(add_attribute, ",")
                if tonumber(add_infos[1]) == 33 then
                    Text_alloy_strong_atk_t:setString(tipStringInfo_alloy_matrix_tips[5])
                    Text_alloy_strong_atk_n:setString(string.format("%.2f%%", tonumber(add_infos[2])*add_percent))
                    Image_3:setPositionY(Text_alloy_strong_atk_t:getPositionY())
                elseif tonumber(add_infos[1]) == 34 then
                    Text_alloy_strong_atk_t:setString(tipStringInfo_alloy_matrix_tips[6])
                    Text_alloy_strong_atk_n:setString(string.format("%.2f%%", tonumber(add_infos[2])*add_percent))
                    Image_3:setPositionY(Text_alloy_strong_atk_t:getPositionY())
                end
                Text_alloy_strong_hp_t:setVisible(false)
                Text_alloy_strong_hp_n:setVisible(false)
            end

            --等级
            Text_alloy_strong_lv_t:setString("Lv" .. metal.metalLevel)
            Text_alloy_strong_lv_n:setString(metal.experience .. "/" .. next_grade_exp*add_percent)
            LoadingBar_alloy_strong_lv:setPercent(metal.experience/next_grade_exp*100)

            --升级所需精华
            Text_alloy_strong_stuff_n:setString(_ED.maxtrix_essence_num .. "/" .. next_grade_exp*add_percent - tonumber(metal.experience))

            --下级增加的属性
            local next_id = dms.atos(current_row, ship_metal_param.id) + 1
            if big_type == 1 then
                local next_add = zstring.splits(dms.string(dms["ship_metal_param"], next_id, ship_metal_param.metal_add), "|", ",")

                Text_alloy_strong_add_atk_n:setString(tonumber(next_add[1][2])*add_percent)
                Text_alloy_strong_add_hp_n:setString(tonumber(next_add[2][2])*add_percent)

                Image_3:setPositionY(self.default_posY)
                Text_alloy_strong_add_hp_n:setVisible(true)
            elseif big_type == 2 then
                local next_add = zstring.split(dms.string(dms["ship_metal_param"], next_id, ship_metal_param.metal_add),  ",")

                Text_alloy_strong_add_atk_n:setString(string.format("%.2f%%", tonumber(next_add[2])*add_percent))
                Image_3:setPositionY(Text_alloy_strong_add_atk_n:getPositionY())
                Text_alloy_strong_add_hp_n:setVisible(false)
            end

            -- 下阶增加的属性
            local all_levels = dms.searchs(dms["ship_metal_param"], ship_metal_param.metal_level, metal.metalRankLevel)
            local max_level = all_levels[#all_levels][ship_metal_param.metal_grade]
            Text_alloy_strong_infor_condition:setString(string.format(tipStringInfo_alloy_matrix_tips[8], tonumber(max_level)))
            Text_alloy_strong_infor_add_effect_state:setString(word_info[3] .. "+" .. tonumber(metal.metalRankLevel)+1)

            Text_alloy_strong_infor_condition:setVisible(true)
            Text_alloy_strong_infor_add_effect_state:setVisible(true)

            --最大阶
            Image_alloy_attr_top:setVisible(false)

            -- 显示等级面板，关闭进阶面板
            Panel_alloy_strong_effect_box:setVisible(true)
            Panel_alloy_up_effect_box:setVisible(false)

        elseif next_grade_exp == -1 and next_level_gold == -1 then
            -- 属性
            if big_type == 1 then
                local add_attribute = dms.atos(current_row, ship_metal_param.metal_add)
                local add_infos = zstring.splits(add_attribute, "|", ",")
                Text_alloy_strong_atk_t:setString(tipStringInfo_trialTower_attribute_info[tonumber(add_infos[1][1]) + 1][1])
                Text_alloy_strong_hp_t:setString(tipStringInfo_trialTower_attribute_info[tonumber(add_infos[2][1]) + 1][1])
                
                Text_alloy_strong_atk_n:setString(tonumber(add_infos[1][2])*add_percent)
                Text_alloy_strong_hp_n:setString(tonumber(add_infos[2][2])*add_percent)

                Image_3:setPositionY(self.default_posY)

                Text_alloy_strong_hp_t:setVisible(true)
                Text_alloy_strong_hp_n:setVisible(true)
            elseif big_type == 2 then
                local add_attribute = dms.atos(current_row, ship_metal_param.metal_add)
                local add_infos = zstring.split(add_attribute, ",")
                if tonumber(add_infos[1]) == 33 then
                    Text_alloy_strong_atk_t:setString(tipStringInfo_alloy_matrix_tips[5])
                    Text_alloy_strong_atk_n:setString(string.format("%.2f%%", tonumber(add_infos[2])*add_percent))
                    Image_3:setPositionY(Text_alloy_strong_atk_n:getPositionY())
                elseif tonumber(add_infos[1]) == 34 then
                    Text_alloy_strong_atk_t:setString(tipStringInfo_alloy_matrix_tips[6])
                    Text_alloy_strong_atk_n:setString(string.format("%.2f%%", tonumber(add_infos[2])*add_percent))
                    Image_3:setPositionY(Text_alloy_strong_atk_n:getPositionY())
                end
                Text_alloy_strong_hp_t:setVisible(false)
                Text_alloy_strong_hp_n:setVisible(false)
            end

            --等级
            Text_alloy_strong_lv_t:setString("Lv" .. metal.metalLevel)
            
            Text_alloy_strong_atk_t:setPositionX(self.Text_alloy_strong_atk_t_posX + 120)
            Text_alloy_strong_atk_n:setPositionX(self.Text_alloy_strong_atk_n_posX + 120)
            Text_alloy_strong_hp_t:setPositionX(self.Text_alloy_strong_hp_t_posX + 120)
            Text_alloy_strong_hp_n:setPositionX(self.Text_alloy_strong_hp_n_posX + 120)

            Text_alloy_strong_lv_n:setString(tipStringInfo_alloy_matrix_tips[7])
            Image_alloy_attr_top:setVisible(true)

            Panel_alloy_attr_top_box:setVisible(false)
            --下阶隐藏
            Text_alloy_strong_infor_condition:setVisible(true)
            Text_alloy_strong_infor_add_effect_state:setVisible(true)

            -- 显示等级面板，关闭进阶面板
            Panel_alloy_strong_effect_box:setVisible(true)
            Panel_alloy_up_effect_box:setVisible(false)
        elseif next_grade_exp == -1 and next_level_gold ~= -1 then
            Text_alloy_strong_atk_t:setPositionX(self.Text_alloy_strong_atk_t_posX )
            Text_alloy_strong_atk_n:setPositionX(self.Text_alloy_strong_atk_n_posX)
            Text_alloy_strong_hp_t:setPositionX(self.Text_alloy_strong_hp_t_posX)
            Text_alloy_strong_hp_n:setPositionX(self.Text_alloy_strong_hp_n_posX)
            --合金图片
            local quality = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_metal_mould.quality)
            Panel_alloy_up_icon_2:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality+1))
            Panel_alloy_up_icon_2:removeAllChildren(true)

            local cell = AlloyMatrixFormationCell:createCell()
            cell:init({metal.id, false})
            Panel_alloy_up_icon_2:addChild(cell)

            Panel_alloy_up_icon_3:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality+1))
            Panel_alloy_up_icon_3:removeAllChildren(true)

            local cell = AlloyMatrixFormationCell:createCell()
            cell:init({metal.id, false})
            Panel_alloy_up_icon_3:addChild(cell)

            --名称1
            local nameindex = dms.int(dms["ship_metal_mould"], metal.metalMould, ship_matrix_mould.name)
            local word_info = dms.element(dms["word_mould"], nameindex)
            Text_alloy_up_effect_t:setString(word_info[3] .. "+" .. metal.metalRankLevel)
            quality = quality +1
            Text_alloy_up_effect_t:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))

            -- 名称2
            Text_alloy_up_add_effect_t:setString(word_info[3] .. "+" .. tonumber(metal.metalRankLevel)+1)
            Text_alloy_up_add_effect_t:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))

            Text_alloy_up_effect_lv_n:setString(metal.metalLevel)
            Text_alloy_up_add_effect_lv_n:setString(metal.metalLevel)

            --进阶所需金币
            Text_alloy_up_money_condition_n:setString(tonumber(next_level_gold)*need_percent)

            -- 显示进阶级面板，关闭等面板
            Panel_alloy_strong_effect_box:setVisible(false)
            Panel_alloy_up_effect_box:setVisible(true)
        end
    end
end

function AlloyMatrixStrengthenOne:onUpdate( dt )
    
end

function AlloyMatrixStrengthenOne:init(params, index)
    self._choose_ship = params
    self.index = index
    self.alloyMatrix = _ED.user_ship[self._choose_ship.ship_id].alloyMatrix
	self:onInit()
    return self
end

function AlloyMatrixStrengthenOne:onInit()
    local csbItem = csb.createNode("cultivate/alloy_attr_up_infor_cell.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_Panel_alloy_up_back"), nil, 
    {
        terminal_name = "alloy_matrix_strengthen_one_show_hide", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)

    --升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_strong_update"), nil, 
    {
        terminal_name = "alloy_matrix_strong_update", 
        terminal_state = 0,
        _type = 0,
        touch_black = true,
    }, nil, 3)

    --一键强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_strong_all_strong"), nil, 
    {
        terminal_name = "alloy_matrix_strong_update", 
        terminal_state = 0,
        _type = 1,
        touch_black = true,
    }, nil, 3)

    --升阶
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_alloy_up_update"), nil, 
    {
        terminal_name = "alloy_matrix_strong_update", 
        terminal_state = 0,
        _type = 0,
        touch_black = true,
    }, nil, 3)

    --箭头坐标
    self.default_posY = ccui.Helper:seekWidgetByName(root,"Image_3"):getPositionY()

    self.Text_alloy_strong_atk_t_posX = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_atk_t"):getPositionX()
    self.Text_alloy_strong_hp_t_posX = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_hp_t"):getPositionX()

    self.Text_alloy_strong_atk_n_posX = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_atk_n"):getPositionX()
    self.Text_alloy_strong_hp_n_posX = ccui.Helper:seekWidgetByName(root,"Text_alloy_strong_hp_n"):getPositionX()
end

function AlloyMatrixStrengthenOne:onEnterTransitionFinish()
end

function AlloyMatrixStrengthenOne:createCell()
	local cell = AlloyMatrixStrengthenOne:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function AlloyMatrixStrengthenOne:onExit()
    state_machine.remove("alloy_matrix_update_choose_state")
end
