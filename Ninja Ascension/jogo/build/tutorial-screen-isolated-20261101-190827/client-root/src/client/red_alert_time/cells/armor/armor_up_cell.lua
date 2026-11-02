----------------------------------------------------------------------------------------------------
-- 说明：装甲升级列表cell
-------------------------------------------------------------------------------------------------------
ArmorUpCell = class("ArmorUpCellClass", Window)
ArmorUpCell.__size = nil

local armor_up_cell_create_terminal = {
    _name = "armor_up_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArmorUpCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(armor_up_cell_create_terminal)
state_machine.init()

function ArmorUpCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil

    local function init_armor_up_cell_terminal()
        -- 升级
        local armor_up_cell_update_info_terminal = {
            _name = "armor_up_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params.cell
                cell._index = params.index
                cell._info = params.info
                -- if cell._info ~= nil then
                    if index <= 8 then
                        cell:reload()
                        cell:updateDraw()
                    else
                        cell:unload()
                    end
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(armor_up_cell_update_info_terminal)
        state_machine.init()
    end
    init_armor_up_cell_terminal()         
end

function ArmorUpCell:onUpdateDraw()
    local root = self.roots[1]

end

function ArmorUpCell:onEnterTransitionFinish()

end

function ArmorUpCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.armor.armor_up_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if ArmorUpCell.__size == nil then
        ArmorUpCell.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function ArmorUpCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.armor.armor_up_cell, self.roots[1])
end

function ArmorUpCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ArmorUpCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.armor.armor_up_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ArmorUpCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_armor_up_icon = ccui.Helper:seekWidgetByName(root,"Panel_armor_up_icon")
    local Text_armor_up_name = ccui.Helper:seekWidgetByName(root,"Text_armor_up_name")
    local Text_armor_up_infor = ccui.Helper:seekWidgetByName(root,"Text_armor_up_infor")
    local Text_armor_up_exp = ccui.Helper:seekWidgetByName(root,"Text_armor_up_exp")
    if Panel_armor_up_icon ~= nil then
        Panel_armor_up_icon:removeAllChildren(true)
        Text_armor_up_name:setString("")
        Text_armor_up_infor:setString("")
        Text_armor_up_exp:setString("")
    end
end

function ArmorUpCell:init(params)
    self._index = params[1]
    self._info = params[2]
    if self._index <= 8 then
       self:onInit()
    end
    self:setContentSize(ArmorUpCell.__size)
end

