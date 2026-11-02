--------------------------------------------------------------------------------------------------------------
--  说明：清盘计划cell
--------------------------------------------------------------------------------------------------------------
RedAlerTimeWindingUpPlanCell = class("RedAlerTimeWindingUpPlanCellClass", Window)
RedAlerTimeWindingUpPlanCell.__size = nil

--创建cell
local red_alert_time_winding_up_plan_cell_terminal = {
    _name = "red_alert_time_winding_up_plan_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlerTimeWindingUpPlanCell:new()
		local activity_reward = params[1]
        cell:init(activity_reward)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_winding_up_plan_cell_terminal)
state_machine.init()

function RedAlerTimeWindingUpPlanCell:ctor()
	self.super:ctor()
	self.roots = {}
	self._activity_reward = nil
    self._prop_from_type = 0
    self._prop_id = 0
    app.load("client.red_alert_time.props.PropsInforPrompt")
    app.load("client.red_alert_time.equipment.EquipmentInforPrompt")
    app.load("client.red_alert_time.build_up.BuildUpTankProduction")
    local function init_red_alert_time_winding_up_plan_cell_terminal()
        local props_icon_set_selected_terminal = {
            _name = "props_icon_set_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell._prop_from_type == 1 then
                    state_machine.excute("props_infor_prompt_window_open", 0, {cell._prop_id})
                elseif cell._prop_from_type == 4 then
                    state_machine.excute("equipment_infor_prompt_window_open", 0, {_ED.user_equiment[""..cell._prop_id].equipment_mould_id, _ED.user_equiment[""..cell._prop_id]})
                elseif cell._prop_from_type == 10 then
                    local info = {}
                    info.tank_id = cell._prop_id
                    state_machine.excute("build_up_tank_production_window_open", 0, {1, info, false})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(props_icon_set_selected_terminal)        
        state_machine.init()
    end

    init_red_alert_time_winding_up_plan_cell_terminal()

end

function RedAlerTimeWindingUpPlanCell:updateDraw()
    local root = self.roots[1]
	local Panel_winding_up_plan_icon = ccui.Helper:seekWidgetByName(root,"Panel_winding_up_plan_icon")
    Panel_winding_up_plan_icon:removeAllChildren(true)
    local datas = zstring.split(self._activity_reward.achieve_reward,",")
    if tonumber(datas[1]) == -1 then
        datas[1] = resource_prop_id[tonumber(datas[2])]
        datas[2] = 1
    end
    local prop_type = tonumber(datas[2])
    local show_type = 4
    local prop_from_type = 3
    if tonumber(datas[2]) == 13 then --坦克
        prop_type = 3
        prop_from_type = 10
    elseif tonumber(datas[2]) == 6 then --道具    
        prop_type = 1
        prop_from_type = 1
    elseif tonumber(datas[2]) == 7 then --配件    
        prop_type = 7
        prop_from_type = 4
    else
        prop_type = 1
        prop_from_type = 1
    end
    local cell = nil
    local prop_id = nil
    if prop_type == 7 then
        prop_id = {}
        prop_id.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
        prop_id.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
        --cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(datas[3])})
    else
        prop_id = tonumber(datas[1])
       -- cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3]),nil,tonumber(datas[1])})
    end

    local pic_index = nil
    if tonumber(prop_type) == 1 then
        pic_index = dms.string(dms["prop_mould"], prop_id, prop_mould.pic_index)
        pic_index = zstring.split(pic_index, ",")
    elseif tonumber(prop_type) == 3 then
        pic_index = dms.string(dms["ship_mould"], prop_id, ship_mould.head_icon)
        pic_index = zstring.split(pic_index, ",")
    elseif tonumber(prop_type) == 7 then       -- 配件
        local equipment_info = nil
        if prop_id.equipment_name ~= nil then
            equipment_info = prop_id
        else
            equipment_info = _ED.user_equiment[""..prop_id]
        end
        pic_index = zstring.split(equipment_info.pic_index, ",")
    end
    self._prop_from_type = prop_from_type
    self._prop_id = tonumber(datas[1])
    --Panel_winding_up_plan_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
    cell = cc.Sprite:create(string.format(config_res.images.ui.props.props, pic_index[1]))
    Panel_winding_up_plan_icon:addChild(cell)
    local panelSize = Panel_winding_up_plan_icon:getContentSize()
    cell:setPosition(cc.p(panelSize.width / 2, panelSize.height / 2))
    local Text_icon_number_n = ccui.Helper:seekWidgetByName(root,"Text_icon_number_n")
    Text_icon_number_n:setString(datas[3])

    local Image_winding_up_get_hook = ccui.Helper:seekWidgetByName(root,"Image_winding_up_get_hook")
    if tonumber(self._activity_reward.achieve_state) >= 1 then
        --display:gray(cell)
        cell:setColor(cc.c3b(79,85,85))
        Image_winding_up_get_hook:setVisible(true)
    else
        --display:ungray(cell)
        Image_winding_up_get_hook:setVisible(false)
    end
end

function RedAlerTimeWindingUpPlanCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.winding_up_plan_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_winding_up_plan_icon"), nil, 
    {
        terminal_name = "props_icon_set_selected", 
        terminal_state = 0, 
        cell = self,
    }, nil, 1)

    if RedAlerTimeWindingUpPlanCell.__size == nil then
        RedAlerTimeWindingUpPlanCell.__size = root:getContentSize()
    end

	self:updateDraw()

end

function RedAlerTimeWindingUpPlanCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function RedAlerTimeWindingUpPlanCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_winding_up_plan_icon = ccui.Helper:seekWidgetByName(root,"Panel_winding_up_plan_icon")
    local Text_icon_number_n = ccui.Helper:seekWidgetByName(root,"Text_icon_number_n")
	if Panel_winding_up_plan_icon ~= nil then
		Text_icon_number_n:setString("")
        Panel_winding_up_plan_icon:removeBackGroundImage()
		Panel_winding_up_plan_icon:removeAllChildren(true)
	end
end

function RedAlerTimeWindingUpPlanCell:init(activity_reward)
    self._activity_reward = activity_reward
	self:onInit()
	
    self:setContentSize(RedAlerTimeWindingUpPlanCell.__size)
    return self
end

function RedAlerTimeWindingUpPlanCell:onExit()
    state_machine.remove("props_icon_set_selected")
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.winding_up_plan_cell, self.roots[1])
end