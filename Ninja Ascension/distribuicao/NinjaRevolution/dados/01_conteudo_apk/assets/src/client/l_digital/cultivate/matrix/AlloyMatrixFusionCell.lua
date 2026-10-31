-----------------------------
-- 单个合金
-----------------------------
AlloyMatrixFusionCell = class("AlloyMatrixFusionCellClass", Window)
AlloyMatrixFusionCell.__size = nil

function AlloyMatrixFusionCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.is_select = false

    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFusion")
    
    local function init_alloy_matrix_select_formation_cell_terminal()
        local alloy_matrix_select_formation_in_terminal = {
            _name = "alloy_matrix_select_formation_in",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                local ship_id = cell.ship.ship_id
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("alloy_matrix_ship_update",0,response.node.ship)
                            state_machine.excute("alloy_matrix_select_formation_close",0,"")
                        end 
                    end
                end
                protocol_command.ship_metal_set.param_list = ship_id.."\r\n"..cell.index.."\r\n" .. "1" .."\r\n".. cell.matrix_params
                NetworkManager:register(protocol_command.ship_metal_set.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(alloy_matrix_select_formation_in_terminal)
        state_machine.init()
    end
    init_alloy_matrix_select_formation_cell_terminal()
end

function AlloyMatrixFusionCell:onUpdateDraw()
	local root = self.roots[1]
    local Panel_alloy_matrix_fusion_list_frame = ccui.Helper:seekWidgetByName(root, "Panel_alloy_matrix_fusion_list_frame")
    local Panel_alloy_matrix_fusion_list_icon = ccui.Helper:seekWidgetByName(root, "Panel_alloy_matrix_fusion_list_icon")
    local Text_alloy_matrix_fusion_list_name = ccui.Helper:seekWidgetByName(root, "Text_alloy_matrix_fusion_list_name")

    local Text_alloy_matrix_fusion_list_in_atk_t = ccui.Helper:seekWidgetByName(root, "Text_alloy_matrix_fusion_list_in_atk_t")
    local Text_alloy_matrix_fusion_list_in_atk_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_matrix_fusion_list_in_atk_n")

    local Text_alloy_matrix_fusion_list_in_hp_t = ccui.Helper:seekWidgetByName(root, "Text_alloy_matrix_fusion_list_in_hp_t")
    local Text_alloy_matrix_fusion_list_in_hp_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_matrix_fusion_list_in_hp_n")

    local CheckBox_alloy_matrix_fusion_list = ccui.Helper:seekWidgetByName(root, "CheckBox_alloy_matrix_fusion_list")

    CheckBox_alloy_matrix_fusion_list:setSelected(self.is_select)

    local function onOpenTouchEvent(sender, eventType)
        -- Solo `ended`: en `canceled` (deslizar la lista desde la casilla) el motor
        -- no cambia la casilla y la seleccion quedaba distinta de lo que se ve.
        if eventType == ccui.TouchEventType.ended then
            local isSelected = CheckBox_alloy_matrix_fusion_list:isSelected()
    
            -- _is_accept_friend 1 同意接受好友申请  0 不同意
            if isSelected == false then
                -- TODO
                -- 实际上是选中了
                -- false 的时候是没有选中 ,实际上是执行的 已经选中状态 这里是因为checkbox组件,在点击时候,自己会把状态修改,处理完了后,又执行了这个回调.实际上是获取的上次的状态
                self.is_select = true
                state_machine.excute("matrix_fusion_metal_num_select", 0, {self.matrix_info.id, 1})
            else
                self.is_select = false
                state_machine.excute("matrix_fusion_metal_num_select", 0, {self.matrix_info.id, -1})
            end
        end
    end
    CheckBox_alloy_matrix_fusion_list:addTouchEventListener(onOpenTouchEvent)

    --图标
    local quality = dms.int(dms["ship_metal_mould"], self.matrix_info.metalMould, ship_metal_mould.quality)
    quality = quality +1
    Panel_alloy_matrix_fusion_list_frame:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
    Panel_alloy_matrix_fusion_list_frame:removeAllChildren(true)

    --名称
    local nameindex = dms.int(dms["ship_metal_mould"], self.matrix_info.metalMould, ship_metal_mould.name)
    local word_info = dms.element(dms["word_mould"], nameindex) 
    Text_alloy_matrix_fusion_list_name:setString(word_info[3])
    Text_alloy_matrix_fusion_list_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))

    local cell = AlloyMatrixFormationCell:createCell()
    cell:init({self.matrix_info.id, false})
    Panel_alloy_matrix_fusion_list_icon:addChild(cell)

    --属性
    local big_type = dms.int(dms["ship_metal_mould"], self.matrix_info.metalMould, ship_metal_mould.head)
    local mould_type = dms.int(dms["ship_metal_mould"], self.matrix_info.metalMould, ship_metal_mould.add_type)
    local quality = dms.int(dms["ship_metal_mould"], self.matrix_info.metalMould, ship_metal_mould.quality)

    local quality_add = zstring.splits(dms.string(dms["ship_config"], 35, ship_config.param), "|", ",")
    local add_percent = tonumber(quality_add[quality +1][2])

    local add_attribute = nil
    for i = 1, #dms["ship_metal_param"] do
        local group_id = dms.int(dms["ship_metal_param"], i, ship_metal_param.group_id)
        local grade = dms.int(dms["ship_metal_param"], i, ship_metal_param.metal_grade)
        local level = dms.int(dms["ship_metal_param"], i, ship_metal_param.metal_level)
        local add = dms.string(dms["ship_metal_param"], i, ship_metal_param.metal_add)
        if mould_type == group_id and tonumber(self.matrix_info.metalLevel) == grade and tonumber(self.matrix_info.metalRankLevel) == level then
            add_attribute = add
            break
        end
    end
    if big_type == 1 then
        if add_attribute then
            local add_infos = zstring.splits(add_attribute, "|", ",")
            Text_alloy_matrix_fusion_list_in_atk_t:setString(tipStringInfo_trialTower_attribute_info[tonumber(add_infos[1][1]) + 1][1])
            Text_alloy_matrix_fusion_list_in_atk_n:setString(tonumber(add_infos[1][2])*add_percent)

            Text_alloy_matrix_fusion_list_in_hp_t:setString(tipStringInfo_trialTower_attribute_info[tonumber(add_infos[2][1]) + 1][1])
            Text_alloy_matrix_fusion_list_in_hp_n:setString(tonumber(add_infos[2][2])*add_percent)
        end
    else
        if add_attribute then
            local add_infos = zstring.split(add_attribute, ",")
            if tonumber(add_infos[1]) == 33 then
                Text_alloy_matrix_fusion_list_in_atk_t:setString(tipStringInfo_alloy_matrix_tips[5])
                Text_alloy_matrix_fusion_list_in_atk_n:setString(string.format("%.2f%%", tonumber(add_infos[2])*add_percent))
            elseif tonumber(add_infos[1]) == 34 then
                Text_alloy_matrix_fusion_list_in_atk_t:setString(tipStringInfo_alloy_matrix_tips[6])
                Text_alloy_matrix_fusion_list_in_atk_n:setString(string.format("%.2f%%", tonumber(add_infos[2])*add_percent))
            end
            Text_alloy_matrix_fusion_list_in_hp_t:setString("")
            Text_alloy_matrix_fusion_list_in_hp_n:setString("")
        end
    end
end

function AlloyMatrixFusionCell:onUpdate( dt )
    
end

function AlloyMatrixFusionCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function AlloyMatrixFusionCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef("cultivate/alloy_matrix_fusion_list_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function AlloyMatrixFusionCell:init(info, index, selected)
    self.matrix_info = info
    self.is_select = selected
    if index~= nil and index < 7 then
    	self:onInit()
    end

    if AlloyMatrixFusionCell.__size then
        self:setContentSize(AlloyMatrixFusionCell.__size)
    end
    return self
end

function AlloyMatrixFusionCell:onInit()
    local root = cacher.createUIRef("cultivate/alloy_matrix_fusion_list_cell.csb", "root")
    root:removeFromParent(false)
    self:addChild(root)
    table.insert(self.roots, root)

    if AlloyMatrixFusionCell.__size == nil then
        AlloyMatrixFusionCell.__size = root:getContentSize()
    end

    self:clearUIInfo()

    self:onUpdateDraw()
end

function AlloyMatrixFusionCell:onEnterTransitionFinish()
end

function AlloyMatrixFusionCell:createCell()
	local cell = AlloyMatrixFusionCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function AlloyMatrixFusionCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_alloy_matrix_fusion_list_frame = ccui.Helper:seekWidgetByName(root, "Panel_alloy_matrix_fusion_list_frame")
    local Panel_alloy_matrix_fusion_list_icon = ccui.Helper:seekWidgetByName(root, "Panel_alloy_matrix_fusion_list_icon")
    local Text_alloy_matrix_fusion_list_name = ccui.Helper:seekWidgetByName(root, "Text_alloy_matrix_fusion_list_name")

    local Text_alloy_matrix_fusion_list_in_atk_t = ccui.Helper:seekWidgetByName(root, "Text_alloy_matrix_fusion_list_in_atk_t")
    local Text_alloy_matrix_fusion_list_in_atk_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_matrix_fusion_list_in_atk_n")

    local Text_alloy_matrix_fusion_list_in_hp_t = ccui.Helper:seekWidgetByName(root, "Text_alloy_matrix_fusion_list_in_hp_t")
    local Text_alloy_matrix_fusion_list_in_hp_n = ccui.Helper:seekWidgetByName(root, "Text_alloy_matrix_fusion_list_in_hp_n")

    local CheckBox_alloy_matrix_fusion_list = ccui.Helper:seekWidgetByName(root, "CheckBox_alloy_matrix_fusion_list")

    if Panel_alloy_matrix_fusion_list_frame ~= nil then
        Panel_alloy_matrix_fusion_list_frame:removeBackGroundImage()
        Panel_alloy_matrix_fusion_list_frame:removeAllChildren(true)
    end

    if Panel_alloy_matrix_fusion_list_icon then
        Panel_alloy_matrix_fusion_list_icon:removeBackGroundImage()
        Panel_alloy_matrix_fusion_list_icon:removeAllChildren(true)
    end

    if Text_alloy_matrix_fusion_list_name then
        Text_alloy_matrix_fusion_list_name:setString("")
    end

    if Text_alloy_matrix_fusion_list_in_atk_t then
        Text_alloy_matrix_fusion_list_in_atk_t:setString("")
        Text_alloy_matrix_fusion_list_in_atk_n:setString("")
        Text_alloy_matrix_fusion_list_in_hp_t:setString("")
        Text_alloy_matrix_fusion_list_in_hp_n:setString("")
    end

    if CheckBox_alloy_matrix_fusion_list then
        CheckBox_alloy_matrix_fusion_list:setSelected(false)
    end
end

function AlloyMatrixFusionCell:onExit()
    self:clearUIInfo()
    state_machine.remove("alloy_matrix_select_formation_in")
    cacher.freeRef("cultivate/alloy_matrix_fusion_list_cell.csb", self.roots[1])
end
