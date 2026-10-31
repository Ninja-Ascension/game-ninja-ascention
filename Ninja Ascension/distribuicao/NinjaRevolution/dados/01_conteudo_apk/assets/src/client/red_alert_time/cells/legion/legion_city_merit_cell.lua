----------------------------------------------------------------------------------------------------
-- 说明：军团占领城市战绩cell
-------------------------------------------------------------------------------------------------------
LegionCityMeritCell = class("LegionCityMeritCellClass", Window)
LegionCityMeritCell.__size = nil

local legion_city_merit_cell_create_terminal = {
    _name = "legion_city_merit_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = LegionCityMeritCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_merit_cell_create_terminal)
state_machine.init()

function LegionCityMeritCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil

    local function init_legion_city_merit_cell_terminal()
        local legion_city_merit_cell_update_info_terminal = {
            _name = "legion_city_merit_cell_update_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params.cell
                local index = params.index
                cell._info = params._info
                if cell._info ~= nil then
                    if index <= 13 then
                        cell:reload()
                        cell:onUpdateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(legion_city_merit_cell_update_info_terminal)
        state_machine.init()
    end
    init_legion_city_merit_cell_terminal()         
end

function LegionCityMeritCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_legion_city_merit_rank = ccui.Helper:seekWidgetByName(root,"Text_legion_city_merit_rank")
    local Text_legion_city_merit_name = ccui.Helper:seekWidgetByName(root,"Text_legion_city_merit_name")
    local Text_legion_city_merit_fight = ccui.Helper:seekWidgetByName(root,"Text_legion_city_merit_fight")
    local Text_legion_city_merit = ccui.Helper:seekWidgetByName(root,"Text_legion_city_merit")

    Text_legion_city_merit_rank:setString(self._info.rank)
    Text_legion_city_merit_name:setString(self._info.name)
    Text_legion_city_merit_fight:setString(exChangeNumToString(self._info.fight_number))
    Text_legion_city_merit:setString(exChangeNumToString(self._info.merit))
end

function LegionCityMeritCell:onEnterTransitionFinish()

end

function LegionCityMeritCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_city_merit_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if LegionCityMeritCell.__size == nil then
        LegionCityMeritCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function LegionCityMeritCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_merit_cell, self.roots[1])
end

function LegionCityMeritCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionCityMeritCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_merit_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionCityMeritCell:clearUIInfo()
    local root = self.roots[1]
    local Text_legion_city_merit_rank = ccui.Helper:seekWidgetByName(root,"Text_legion_city_merit_rank")
    local Text_legion_city_merit_name = ccui.Helper:seekWidgetByName(root,"Text_legion_city_merit_name")
    local Text_legion_city_merit_fight = ccui.Helper:seekWidgetByName(root,"Text_legion_city_merit_fight")
    local Text_legion_city_merit = ccui.Helper:seekWidgetByName(root,"Text_legion_city_merit")
    if Text_legion_city_merit_rank ~= nil then
        Text_legion_city_merit_rank:setString("")
        Text_legion_city_merit_name:setString("")
        Text_legion_city_merit_fight:setString("")
        Text_legion_city_merit:setString("")
    end
end

function LegionCityMeritCell:init(params)
    self._index = params[1]
    self._info = params[2]

    if self._index <= 13 then
       self:onInit()
    end
    self:setContentSize(LegionCityMeritCell.__size)
end

