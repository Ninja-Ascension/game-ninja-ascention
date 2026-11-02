--------------------------------------------------------------------------------------------------------------
--  说明：数码宝物吞噬cell
--------------------------------------------------------------------------------------------------------------
SmTreasureSwallowedCell = class("SmTreasureSwallowedCellClass", Window)
SmTreasureSwallowedCell.__size = nil

--创建cell
local sm_treasure_swallowed_cell_terminal = {
    _name = "sm_treasure_swallowed_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmTreasureSwallowedCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        -- cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_treasure_swallowed_cell_terminal)
state_machine.init()

function SmTreasureSwallowedCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.isSelected = false
	
	 -- Initialize sm_treasure_swallowed_cell state machine.
    local function init_sm_treasure_swallowed_cell_terminal()

        local sm_treasure_swallowed_cell_set_select_terminal = {
            _name = "sm_treasure_swallowed_cell_set_select",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells = params._datas.cell
                if nil == cells.roots[1] then
                    return false
                end
                local checkbox  = ccui.Helper:seekWidgetByName(cells.roots[1], "CheckBox_1")

                local demandMaxExp = cells:calculationData()
                
                if checkbox:isSelected() == false then
                    --添加
                    --先判断是否已经选了4种装备了
                    local isHave = false
                    -- for i=1,#cells.swallow_the_array do
                    --     if tonumber(cells.swallow_the_array[i]) == tonumber(cells.equip.user_equiment_template) then
                    --         isHave = true
                    --     end
                    -- end
                    -- if isHave == false then
                        for i=1,#cells.swallow_the_array do
                            if tonumber(cells.swallow_the_array[i]) == 0 then
                                isHave = true
                            end
                        end
                    --end
                    if isHave == false then
                        TipDlg.drawTextDailog(_new_interface_text[230])
                        return
                    end
                    --再判断是否经验满了
                    if tonumber(cells.upEquip.useExp) >= demandMaxExp then
                        TipDlg.drawTextDailog(_new_interface_text[229])
                        return
                    end

                    --最后再做添加
                    for i=1,#cells.swallow_the_array do
                        -- if tonumber(cells.swallow_the_array[i]) == tonumber(cells.equip.user_equiment_template) then
                        --     cells.swallow_number[i] = tonumber(cells.swallow_number[i]) + 1
                        --     cells.upEquip.useExp = tonumber(cells.upEquip.useExp) + dms.int(dms["equipment_mould"], cells.equip.user_equiment_template, equipment_mould.initial_supply_escalate_exp)
                        --     break
                        if tonumber(cells.swallow_the_array[i]) == 0 then
                            cells.swallow_the_array[i] = tonumber(cells.equip.user_equiment_template)
                            cells.swallow_the_array_instanceId[i] = tonumber(cells.equip.user_equiment_id)
                            cells.swallow_number[i] = tonumber(cells.swallow_number[i]) + 1
                            cells.upEquip.useExp = tonumber(cells.upEquip.useExp) + dms.int(dms["equipment_mould"], cells.equip.user_equiment_template, equipment_mould.initial_supply_escalate_exp)
                            break
                        end
                    end
                    state_machine.excute("sm_treasure_swallowed_cell_set_Selected_data",0,{cells.swallow_the_array,cells.swallow_number,cells.upEquip.useExp, cells})
                    cells.isSelected = true
                    checkbox:setSelected(true)
                else
                    --删除
                    local isUse = {0,0,0,0}
                    for i=1,#cells.swallow_the_array do
                        if isUse[i] ~= 1 then
                            if tonumber(cells.swallow_the_array[i]) == tonumber(cells.equip.user_equiment_template) then
                                isUse[i] = 1
                                cells.swallow_number[i] = tonumber(cells.swallow_number[i]) - 1
                                cells.swallow_the_array[i] = "0"
                                cells.swallow_the_array_instanceId[i] = "0"
                                cells.upEquip.useExp = tonumber(cells.upEquip.useExp) - dms.int(dms["equipment_mould"], cells.equip.user_equiment_template, equipment_mould.initial_supply_escalate_exp)
                                break
                            end
                        end
                    end
                    state_machine.excute("sm_treasure_swallowed_cell_set_Selected_data",0,{cells.swallow_the_array,cells.swallow_number,cells.upEquip.useExp, cells})
                    cells.isSelected = false
                    checkbox:setSelected(false)
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_treasure_swallowed_cell_unselect_terminal = {
            _name = "sm_treasure_swallowed_cell_unselect",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil == params.roots[1] then
                    return false
                end

                local checkbox  = ccui.Helper:seekWidgetByName(params.roots[1], "CheckBox_1")
                
                if nil ~= checkbox and checkbox:isSelected() == true then
                    state_machine.excute("sm_treasure_swallowed_cell_set_select", 0, {_datas = { cell = params}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        ---设置选中的数据
        local sm_treasure_swallowed_cell_set_Selected_data_terminal = {
            _name = "sm_treasure_swallowed_cell_set_Selected_data",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[4]
                cell.swallow_the_array = params[1]
                cell.swallow_number = params[2]
                cell.upEquip.useExp = params[3]
                state_machine.excute("sm_equipment_qianghua_add_cell_set_data",0,{cell.swallow_the_array,cell.swallow_number,cell.upEquip.useExp})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(sm_treasure_swallowed_cell_set_select_terminal)
        state_machine.add(sm_treasure_swallowed_cell_unselect_terminal)
        state_machine.add(sm_treasure_swallowed_cell_set_Selected_data_terminal)
        state_machine.init()
    end 
    -- call func sm_treasure_swallowed_cell create state machine.
    init_sm_treasure_swallowed_cell_terminal()

end

function SmTreasureSwallowedCell:calculationData()
    local ship_id = self.upEquip.ship_id
    local shipData = _ED.user_ship[""..ship_id]
    --武将装备数据（等级|品质|经验|星级）
    local shipEquip = zstring.split(shipData.equipInfo, "|")
    --装备位
    local e_index = self.upEquip.m_index
    local levels = zstring.split(shipEquip[1], ",")
    local picAll = zstring.split(shipEquip[2], ",")
    local pic = picAll[tonumber(e_index)]
    local expAll = zstring.split(shipEquip[3], ",")
    local oldExp = expAll[tonumber(e_index)]
    --知道品质了去换算颜色
    local picIndex = shipOrEquipSetColour(tonumber(pic))

    --计算需要多少经验
    local demandMaxExp = 0
    --通过当前等级和可以升的最大等级计算需要的总经验
    for i = tonumber(levels[tonumber(e_index)]) ,self.upEquip.maxLv do
        demandMaxExp = demandMaxExp + dms.int(dms["equipment_refining_experience_param"], i, picIndex+2)
    end
    --算出需要的总经验
    demandMaxExp = demandMaxExp - tonumber(oldExp)

    return demandMaxExp
end

function SmTreasureSwallowedCell:createEquipHead(objectType,ship)
    local cell = EquipIconCell:createCell()
    cell:init(objectType,ship)
    return cell
end

function SmTreasureSwallowedCell:updateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    --画图标
    local Panel_equ_icon = ccui.Helper:seekWidgetByName(root, "Panel_equ_icon")
    Panel_equ_icon:removeAllChildren(true)
    local _type = 1
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        _type = 7
    end   
    local cell = self:createEquipHead(_type,self.equip)
    Panel_equ_icon:addChild(cell)
    cell:setPosition(cell:getPositionX(),cell:getPositionY())

    --画名称
    local Text_book_name = ccui.Helper:seekWidgetByName(root, "Text_book_name")
    --获取装备名称索引
    local nameindex = dms.int(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.equipment_name)
    --通过索引找到word_mould
    local word_info = dms.element(dms["word_mould"], nameindex)
    local name = word_info[3]
    Text_book_name:setString(name)
    --画增加的经验
    local Text_exp = ccui.Helper:seekWidgetByName(root, "Text_exp")
    local n_exp = dms.int(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.initial_supply_escalate_exp)
    Text_exp:setString(string.format(_new_interface_text[8],zstring.tonumber(n_exp)))

    local checkbox  = ccui.Helper:seekWidgetByName(root, "CheckBox_1")
    checkbox:setSelected(self.isSelected)
end

function SmTreasureSwallowedCell:onInit()
    local root = cacher.createUIRef("packs/EquipStorage/sm_equipment_qianghua_add_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmTreasureSwallowedCell.__size == nil then
        SmTreasureSwallowedCell.__size = root:getContentSize()
    end
    --选择当前活动页
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "ImageView_equ"), nil, 
    {
        terminal_name = "sm_treasure_swallowed_cell_set_select", 
        terminal_state = 0, 
        touch_black = true,
        cell = self, 
    }, nil, 1)

	self:updateDraw()
end

function SmTreasureSwallowedCell:clearUIInfo()
	local root = self.roots[1]
    local Panel_equ_icon = ccui.Helper:seekWidgetByName(root, "Panel_equ_icon")
    local checkbox = ccui.Helper:seekWidgetByName(root, "checkbox")
    if Panel_equ_icon ~= nil then
        Panel_equ_icon:removeAllChildren(true)
    end
    if checkbox ~= nil then
        checkbox:setSelected(false)
    end
end

function SmTreasureSwallowedCell:onEnterTransitionFinish()

end

function SmTreasureSwallowedCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    -- self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmTreasureSwallowedCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("packs/EquipStorage/sm_equipment_qianghua_add_list.csb", root)
    root:stopAllActions()
    -- self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmTreasureSwallowedCell:init(params)
    self.equip = params[1]
    self.isSelected = params[2]
    self.swallow_the_array = params[3]
    self.swallow_number = params[4]
    self.upEquip = params[5]
    if params[6] ~= nil and params[6] < 8 then
        self:onInit()
    end
    self.swallow_the_array_instanceId = params[7]
    self:setContentSize(SmTreasureSwallowedCell.__size)
    return self
end

function SmTreasureSwallowedCell:onExit()
    -- state_machine.excute("sm_treasure_swallowed_cell_unselect", 0, self)
	self:clearUIInfo()
    cacher.freeRef("packs/EquipStorage/sm_equipment_qianghua_add_list.csb", self.roots[1])
end