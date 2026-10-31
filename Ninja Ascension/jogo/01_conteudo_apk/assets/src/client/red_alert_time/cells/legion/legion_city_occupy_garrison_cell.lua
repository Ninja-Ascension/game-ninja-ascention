----------------------------------------------------------------------------------------------------
-- 说明：军团城市列表cell
-------------------------------------------------------------------------------------------------------
LegionCityOccupyGarrisonCell = class("LegionCityOccupyGarrisonCellClass", Window)
LegionCityOccupyGarrisonCell.__size = nil

local legion_city_occupy_garrison_cell_create_terminal = {
    _name = "legion_city_occupy_garrison_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = LegionCityOccupyGarrisonCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_occupy_garrison_cell_create_terminal)
state_machine.init()

function LegionCityOccupyGarrisonCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._info = nil

    local function init_legion_city_occupy_garrison_cell_terminal()
        local legion_city_occupy_garrison_cell_update_info_terminal = {
            _name = "legion_city_occupy_garrison_cell_update_info",
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
                    if index <= 8 then
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

        local legion_city_occupy_garrison_cell_repatrate_terminal = {
            _name = "legion_city_occupy_garrison_cell_repatrate",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)  
                local cell = params._datas.cell
                -- 遣返
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("legion_city_occupy_garrison_update_list_info", 0, "")
                        state_machine.excute("legion_city_infor_attack_update_draw", 0, "")
                    end
                end

                protocol_command.world_city_disband.param_list = ""..cell._city_id.."\r\n"..cell._info.user_id
                NetworkManager:register(protocol_command.world_city_disband.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_occupy_garrison_cell_update_info_terminal)
        state_machine.add(legion_city_occupy_garrison_cell_repatrate_terminal)
        state_machine.init()
    end
    init_legion_city_occupy_garrison_cell_terminal()         
end

function LegionCityOccupyGarrisonCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_city_garrison_palyer_icon = ccui.Helper:seekWidgetByName(root,"Panel_city_garrison_palyer_icon")
    local Text_city_garrison_palyer_name_lv = ccui.Helper:seekWidgetByName(root,"Text_city_garrison_palyer_name_lv")
    local Text_city_garrison_palyer_state = ccui.Helper:seekWidgetByName(root,"Text_city_garrison_palyer_state")
    Panel_city_garrison_palyer_icon:removeAllChildren(true)

    Text_city_garrison_palyer_name_lv:setString(self._info.user_name.." "..friends_tip_string[12]..self._info.user_level)
    Text_city_garrison_palyer_state:setString(world_city_tip_str[13])

    local cell = PlayerHeadIcon:createCell()
    local avatar_info = {}
    avatar_info.object = self._info.head_pic
    avatar_info.vip = 0
    avatar_info._type = 0
    cell:init(avatar_info)
    Panel_city_garrison_palyer_icon:addChild(cell)
end

function LegionCityOccupyGarrisonCell:onEnterTransitionFinish()

end

function LegionCityOccupyGarrisonCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_city_occupy_garrison_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if LegionCityOccupyGarrisonCell.__size == nil then
        LegionCityOccupyGarrisonCell.__size = root:getContentSize()
    end

    -- 遣返
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_city_garrison_repatrate"), nil, 
    {
        terminal_name = "legion_city_occupy_garrison_cell_repatrate",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    },
    nil,1)

    self:onUpdateDraw()
end

function LegionCityOccupyGarrisonCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_occupy_garrison_cell, self.roots[1])
end

function LegionCityOccupyGarrisonCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionCityOccupyGarrisonCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_occupy_garrison_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionCityOccupyGarrisonCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_city_garrison_palyer_icon = ccui.Helper:seekWidgetByName(root,"Panel_city_garrison_palyer_icon")
    local Text_city_garrison_palyer_name_lv = ccui.Helper:seekWidgetByName(root,"Text_city_garrison_palyer_name_lv")
    local Text_city_garrison_palyer_state = ccui.Helper:seekWidgetByName(root,"Text_city_garrison_palyer_state")
    if Panel_city_garrison_palyer_icon ~= nil then
        Panel_city_garrison_palyer_icon:removeAllChildren(true)
        Text_city_garrison_palyer_name_lv:setString("")
        Text_city_garrison_palyer_state:setString("")
    end
end

function LegionCityOccupyGarrisonCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._city_id = params[3]

    if self._index <= 8 then
       self:onInit()
    end
    self:setContentSize(LegionCityOccupyGarrisonCell.__size)
end

