----------------------------------------------------------------------------------------------------
-- 说明：装甲仓库列表cell
-------------------------------------------------------------------------------------------------------
BuildUpTankFactoryTankChooseCell = class("BuildUpTankFactoryTankChooseCellClass", Window)
BuildUpTankFactoryTankChooseCell.__size = nil

local build_up_tank_factory_tank_choose_cell_create_terminal = {
    _name = "build_up_tank_factory_tank_choose_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = BuildUpTankFactoryTankChooseCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_tank_factory_tank_choose_cell_create_terminal)
state_machine.init()

function BuildUpTankFactoryTankChooseCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._ship_mould_id = 0
    self._from_type = 0

    local function init_build_up_tank_factory_tank_choose_cell_terminal()
        local build_up_tank_factory_tank_choose_cell_click_terminal = {
            _name = "build_up_tank_factory_tank_choose_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local choose_index = cell._index
                state_machine.excute("build_up_tank_factory_production_ex_choose_tank", 0, choose_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_factory_tank_choose_cell_set_selected_terminal = {
            _name = "build_up_tank_factory_tank_choose_cell_set_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                local selected = params[2]
                cell:setSelected(selected)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_factory_tank_choose_cell_update_info_terminal = {
            _name = "build_up_tank_factory_tank_choose_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params.cell
                cell._index = params.index
                cell._ship_mould_id = tonumber(params.ship_mould_id)
                if cell._ship_mould_id ~= nil and cell._ship_mould_id > 0 then
                    cell:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(build_up_tank_factory_tank_choose_cell_click_terminal)
        state_machine.add(build_up_tank_factory_tank_choose_cell_set_selected_terminal)
        state_machine.add(build_up_tank_factory_tank_choose_cell_update_info_terminal)
        state_machine.init()
    end
    init_build_up_tank_factory_tank_choose_cell_terminal()         
end

function BuildUpTankFactoryTankChooseCell:setSelected(selected)
    local root = self.roots[1]
    local Image_hook = ccui.Helper:seekWidgetByName(root,"Image_hook")
    if Image_hook ~= nil then
        Image_hook:setVisible(selected)
    end
end

function BuildUpTankFactoryTankChooseCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_quality_bg = ccui.Helper:seekWidgetByName(root,"Panel_quality_bg")
    local Sprite_tank_icon = root:getChildByName("Sprite_tank_icon")
    local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock")

    Panel_quality_bg:removeBackGroundImage()

    local pic_index = dms.string(dms["ship_mould"], self._ship_mould_id, ship_mould.head_icon)
    pic_index = zstring.split(pic_index, ",")
    local pic = tonumber(pic_index[1])
    local quality = tonumber(pic_index[2])
    Sprite_tank_icon:setTexture(string.format(config_res.images.ui.props.props, pic))

    local boatyard_level = dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.boatyard_level)    -- 需要工厂等级
    local cur_level = 0
    if self._from_type == 1 then    -- 坦克工厂1
        if _ED.home_build["9"] ~= nil then
            cur_level = _ED.home_build["9"].level
        end
    elseif self._from_type == 2 then    -- 坦克工厂2
        if _ED.home_build["10"] ~= nil then
            cur_level = _ED.home_build["10"].level
        end
    elseif self._from_type == 3 then    -- 改造工厂
        if _ED.home_build["9"] ~= nil then
            cur_level = _ED.home_build["9"].level
        end
        if _ED.home_build["10"] ~= nil 
            and cur_level < _ED.home_build["10"].level then
            cur_level = _ED.home_build["10"].level
        end
    end

    if boatyard_level <= cur_level then
        display:ungray(Sprite_tank_icon)
        Panel_quality_bg:setBackGroundImage(string.format(config_res.images.ui.icon.icon, quality))
        Image_lock:setVisible(false)
    else
        display:gray(Sprite_tank_icon)
        Panel_quality_bg:setBackGroundImage(string.format(config_res.images.ui.icon.icon, 0))
        Image_lock:setVisible(true)
    end

    self:setSelected(false)
end

function BuildUpTankFactoryTankChooseCell:onEnterTransitionFinish()

end

function BuildUpTankFactoryTankChooseCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.build_up.build_up_cell_4_cell_2, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if BuildUpTankFactoryTankChooseCell.__size == nil then
        BuildUpTankFactoryTankChooseCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_quality_bg"), nil, 
    {
        terminal_name = "build_up_tank_factory_tank_choose_cell_click",
        terminal_state = 0,
        cell = self,
    },
    nil,1)

    self:onUpdateDraw()
end

function BuildUpTankFactoryTankChooseCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_cell_4_cell_2, self.roots[1])
end

function BuildUpTankFactoryTankChooseCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function BuildUpTankFactoryTankChooseCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.build_up.build_up_cell_4_cell_2, root)
    root:removeFromParent(false)
    self.roots = {}
end

function BuildUpTankFactoryTankChooseCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_quality_bg = ccui.Helper:seekWidgetByName(root,"Panel_quality_bg")
    local Sprite_tank_icon = root:getChildByName("Sprite_tank_icon")
    local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock")
    local Image_hook = ccui.Helper:seekWidgetByName(root,"Image_hook")
    if Panel_quality_bg ~= nil then
        Panel_quality_bg:removeBackGroundImage()
        display:ungray(Sprite_tank_icon)
        Image_lock:setVisible(false)
        Image_hook:setVisible(false)
    end
end

function BuildUpTankFactoryTankChooseCell:init(params)
    self._index = params[1]
    self._ship_mould_id = params[2]
    self._from_type = params[3]
    self:onInit()
    self:setContentSize(BuildUpTankFactoryTankChooseCell.__size)
end

