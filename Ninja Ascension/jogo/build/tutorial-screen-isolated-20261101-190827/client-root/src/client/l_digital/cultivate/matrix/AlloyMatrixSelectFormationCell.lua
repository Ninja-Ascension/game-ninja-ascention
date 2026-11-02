-----------------------------
-- 单个合金
-----------------------------
AlloyMatrixSelectFormationCell = class("AlloyMatrixSelectFormationCellClass", Window)
AlloyMatrixSelectFormationCell.__size = nil

function AlloyMatrixSelectFormationCell:ctor()
	self.super:ctor()
	self.roots = {}

    app.load("client.l_digital.cultivate.matrix.AlloyMatrixFormationCell")
    
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
                            if cell.cell_parent then
                                state_machine.excute("alloy_matrix_formation_update",0,{cell.cell_parent.panel_cell})
                                cell.cell_parent:onUpdateDraw(cell.cell_parent.currentIndex)
                            end

                            state_machine.excute("alloy_matrix_ship_update",0,response.node.ship)
                            state_machine.excute("alloy_matrix_select_formation_close",0,"")
                            
                        end 
                    end
                end
                protocol_command.ship_metal_set.param_list = ship_id.."\r\n"..cell.index.."\r\n" .. "1" .."\r\n".. cell.matrix_params
                NetworkManager:register(protocol_command.ship_metal_set.code, nil, nil, nil, cell, responseGetServerListCallback, false, nil)
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

function AlloyMatrixSelectFormationCell:onUpdateDraw()
	local root = self.roots[1]
    local Image_recommend_list_set = ccui.Helper:seekWidgetByName(root, "Image_recommend_list_set")
    local Button_recommend_list_all_in = ccui.Helper:seekWidgetByName(root, "Button_recommend_list_all_in")
    local Text_recommend_list_name = ccui.Helper:seekWidgetByName(root, "Text_recommend_list_name")

    --名称
    local nameindex = dms.int(dms["ship_matrix_mould"], self.matrix_id, ship_matrix_mould.name)
    local word_info = dms.element(dms["word_mould"], nameindex) 
    Text_recommend_list_name:setString(word_info[3])
    self.matrix_params = ""
    for i=1,8 do
        local Panel_recommend_list_icon = ccui.Helper:seekWidgetByName(root, "Panel_recommend_list_icon_" .. i)
        if self.matrix_info[i] then
            local quality = dms.int(dms["ship_metal_mould"], self.matrix_info[i].metalMould, ship_metal_mould.quality)
            Panel_recommend_list_icon:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality+1))
            Panel_recommend_list_icon:removeAllChildren(true)
            
            local cell = AlloyMatrixFormationCell:createCell()
            cell:init({self.matrix_info[i].id, false})
            Panel_recommend_list_icon:addChild(cell)

            self.matrix_params = self.matrix_params .. self.matrix_info[i].id .. "," .. i .. "|"
        end
    end
end

function AlloyMatrixSelectFormationCell:onUpdate( dt )
    
end

function AlloyMatrixSelectFormationCell:init(id, info, index, ship, panel_cell)
	self.matrix_id = id
    self.matrix_info = info
    self.index = index
    self.ship = ship
    self.cell_parent = panel_cell
	self:onInit()

    if AlloyMatrixSelectFormationCell.__size then
        self:setContentSize(AlloyMatrixSelectFormationCell.__size)
    end

    return self
end

function AlloyMatrixSelectFormationCell:onInit()
    local csbItem = csb.createNode("cultivate/alloy_serial_recommend_list_cell.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    if AlloyMatrixSelectFormationCell.__size == nil then
        AlloyMatrixSelectFormationCell.__size = root:getContentSize()
    end

    ccui.Helper:seekWidgetByName(root,"Panel_recommend_list_box"):setSwallowTouches(false)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recommend_list_all_in"), nil, 
    {
        terminal_name = "alloy_matrix_select_formation_in", 
        terminal_state = 0,
        _cell = self,
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
end

function AlloyMatrixSelectFormationCell:onEnterTransitionFinish()
end

function AlloyMatrixSelectFormationCell:createCell()
	local cell = AlloyMatrixSelectFormationCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function AlloyMatrixSelectFormationCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Image_recommend_list_set = ccui.Helper:seekWidgetByName(root, "Image_recommend_list_set")
    local Button_recommend_list_all_in = ccui.Helper:seekWidgetByName(root, "Button_recommend_list_all_in")
    local Text_recommend_list_name = ccui.Helper:seekWidgetByName(root, "Text_recommend_list_name")

    for i=1,8 do
        local Panel_recommend_list_icon = ccui.Helper:seekWidgetByName(root, "Panel_recommend_list_icon_" .. i)
        if Panel_recommend_list_icon ~= nil then
            Panel_recommend_list_icon:removeBackGroundImage()
            Panel_recommend_list_icon:removeAllChildren(true)
        end
    end

    if Image_recommend_list_set ~= nil then
        Image_recommend_list_set:setVisible(false)
    end

    if Text_recommend_list_name then
        Text_recommend_list_name:setString("")
    end

    if Button_recommend_list_all_in then
        Button_recommend_list_all_in:setVisible(true)
    end
end

function AlloyMatrixSelectFormationCell:onExit()
    self:clearUIInfo()
    state_machine.remove("alloy_matrix_select_formation_in")
end
