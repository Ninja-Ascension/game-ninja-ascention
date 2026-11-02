----------------------------------------------------------------------------------------------------
-- 说明：配件碎片图标
-------------------------------------------------------------------------------------------------------
EquipmentPacksChipCell = class("EquipmentPacksChipCellClass", Window)
EquipmentPacksChipCell.__size = nil

local equipment_packs_chip_cell_create_terminal = {
    _name = "equipment_packs_chip_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = EquipmentPacksChipCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_packs_chip_cell_create_terminal)
state_machine.init()

function EquipmentPacksChipCell:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.red_alert_time.props.PropsInforPrompt")
    app.load("client.red_alert_time.equipment.EquipmentPartsFragmentInfor")
    local function init_equipment_packs_chip_cell_terminal()
        --设置选中
        local equipment_packs_chip_cell_set_selected_terminal = {
            _name = "equipment_packs_chip_cell_set_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local chip_id = dms.int(dms["prop_config"], 16, prop_config.param)
                if cell._prop_id == chip_id then
                    state_machine.excute("props_infor_prompt_window_open", 0, {cell._prop_id})
                else
                    state_machine.excute("equipment_parts_fragment_infor_open", 0, {cell._prop_id, cell._info})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新
        local equipment_packs_chip_cell_update_draw_terminal = {
            _name = "equipment_packs_chip_cell_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params
                if cell ~= nil then
                   cell:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(equipment_packs_chip_cell_set_selected_terminal)  
        state_machine.add(equipment_packs_chip_cell_update_draw_terminal)      
        state_machine.init()
    end
    init_equipment_packs_chip_cell_terminal()         
end


function EquipmentPacksChipCell:onUpdateDraw()
    local root = self.roots[1]

    -- 图标
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    local Panel_quality_icon = ccui.Helper:seekWidgetByName(root,"Panel_quality_icon")
    local Panel_fragment = ccui.Helper:seekWidgetByName(root,"Panel_fragment")
    local Panel_formation_position = ccui.Helper:seekWidgetByName(root,"Panel_formation_position")
    Panel_props_icon:removeBackGroundImage()
    Panel_quality_icon:removeBackGroundImage()
    Panel_quality_icon:removeAllChildren(true)

    local pic_index = dms.string(dms["prop_mould"], self._prop_id, prop_mould.pic_index)
    pic_index = zstring.split(pic_index, ",")

    Panel_props_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
    Panel_quality_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[2]))
    Panel_fragment:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[4]))
    Panel_formation_position:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[5]))

    local quality = pic_index[2] - 2
    local effect_paths = string.format(config_res.images.ui.effice.effect_quality_box, quality,quality)
    if cc.FileUtils:getInstance():isFileExist(effect_paths) == true then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
        local armature = ccs.Armature:create("effect_quality_box_"..quality)
        draw.initArmature(armature, nil, -1, 0, 1)
        armature:setPosition(cc.p(Panel_quality_icon:getContentSize().width/2, Panel_quality_icon:getContentSize().height/2))
        Panel_quality_icon:addChild(armature)
    end

    -- 名称
    local Text_props_name = ccui.Helper:seekWidgetByName(root,"Text_props_name")
    local prop_name = ""
    local change_of_equipment = dms.int(dms["prop_mould"], self._prop_id, prop_mould.change_of_equipment)
    if change_of_equipment > 0 then
        local equipment_type = dms.int(dms["equipment_mould"], change_of_equipment, equipment_mould.equipment_type)
        prop_name = "" .. equipment_type .."." .. tipStringInfo_equipment_info[equipment_type]
    else
        prop_name = dms.string(dms["prop_mould"], self._prop_id, prop_mould.prop_name)
    end
    Text_props_name:setString(prop_name)

    -- 数量
    local Image_num_bg = ccui.Helper:seekWidgetByName(root,"Image_num_bg")
    local Text_props_n = ccui.Helper:seekWidgetByName(root,"Text_props_n")
    Text_props_n:setString("")
    Text_props_n:removeAllChildren(true)
    local count = zstring.tonumber(self._info.prop_number)
    local need_count = dms.int(dms["prop_mould"], self._prop_id, prop_mould.split_or_merge_count)

    local width = 0
    if need_count == 0 then
        Text_props_n:ignoreContentAdaptWithSize(true)
        Text_props_n:setString(exChangeNumToString(count))
        width = Text_props_n:getContentSize().width
    elseif count < need_count then
        Text_props_n:ignoreContentAdaptWithSize(true)
        Text_props_n:setString(exChangeNumToString(count).."/"..exChangeNumToString(need_count))
        width = Text_props_n:getContentSize().width
    else
        Text_props_n:ignoreContentAdaptWithSize(false)
        local font_size = Text_props_n:getFontSize()
        local label_need_count = cc.Label:createWithTTF("/"..exChangeNumToString(need_count), config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        label_need_count:setAnchorPoint(1, 0.5)
        label_need_count:setPosition(cc.p(0, 0))
        Text_props_n:addChild(label_need_count)
        width = label_need_count:getContentSize().width

        local label_count = cc.Label:createWithTTF(exChangeNumToString(count), config_res.font.font_name, font_size / CC_CONTENT_SCALE_FACTOR())
        label_count:setAnchorPoint(1, 0.5)
        label_count:setPosition(cc.p(-width, 0))
        label_count:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
        Text_props_n:addChild(label_count)
        width = width + label_count:getContentSize().width
    end
    width = width + 5
    Image_num_bg:setContentSize(cc.size(width, Image_num_bg:getContentSize().height))
end

function EquipmentPacksChipCell:onEnterTransitionFinish()

end

function EquipmentPacksChipCell:onUpdate(dt)

end

function EquipmentPacksChipCell:onInit()
    local root = cacher.createUIRef(string.format(config_csb.cells.props.props_res_icon, 9), "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if root._x == nil then
        root._x = root:getPositionX()
    end
    root:setPositionX(root._x)
    
    if EquipmentPacksChipCell.__size == nil then
        EquipmentPacksChipCell.__size = root:getContentSize()
    end

    -- 使用
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    Panel_props_icon:setSwallowTouches(false)
    local function panelTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
            pushEffect(formatMusicFile("button", 1))
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if math.abs(__spoint.x - __epoint.x) <= 10 and math.abs(__spoint.y - __epoint.y) <= 10 
                or missionIsOver() == false
                then
                state_machine.excute("equipment_packs_chip_cell_set_selected", 0, {_datas = {cell = self}})
            end
        end
    end
    Panel_props_icon:setTouchEnabled(true)
    Panel_props_icon:addTouchEventListener(panelTouchListener)
    Panel_props_icon.callback = panelTouchListener

    self:onUpdateDraw()
end

function EquipmentPacksChipCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    self:stopAllActions()
    cacher.freeRef(string.format(config_csb.cells.props.props_res_icon, 9), root)
end

function EquipmentPacksChipCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function EquipmentPacksChipCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end        
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.props.props_res_icon, 9), root)
    self:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function EquipmentPacksChipCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    local Panel_quality_icon = ccui.Helper:seekWidgetByName(root,"Panel_quality_icon")
    local Panel_fragment = ccui.Helper:seekWidgetByName(root,"Panel_fragment")
    local Panel_formation_position = ccui.Helper:seekWidgetByName(root,"Panel_formation_position")
    local Text_props_name = ccui.Helper:seekWidgetByName(root,"Text_props_name")
    local Text_props_n = ccui.Helper:seekWidgetByName(root,"Text_props_n")
    if Panel_props_icon ~= nil then
        Panel_props_icon:removeBackGroundImage()
        Panel_quality_icon:removeBackGroundImage()
        Panel_quality_icon:removeAllChildren(true)
        Panel_fragment:removeBackGroundImage()
        Panel_formation_position:removeBackGroundImage()
        Text_props_name:setString("")
        Text_props_n:setString("")
        Text_props_n:removeAllChildren(true)
        Text_props_n:ignoreContentAdaptWithSize(true)
    end

end

function EquipmentPacksChipCell:init(params)
    self._prop_id = params[1]
    self._info = params[2]
    -- if index ~= nil and index < max_cout then
        self:onInit()
    -- end

    self:setContentSize(EquipmentPacksChipCell.__size)

end

