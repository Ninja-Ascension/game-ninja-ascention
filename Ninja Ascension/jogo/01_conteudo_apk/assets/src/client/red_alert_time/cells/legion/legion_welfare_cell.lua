-- ------------------------------------------------------------------------------------------------------------
--  奖励仓库cell
-- ------------------------------------------------------------------------------------------------------------
LegionWelfareCell = class("LegionWelfareCellClass", Window)
LegionWelfareCell.__size = nil

--创建cell
local legion_welfare_cell_create_terminal = {
    _name = "legion_welfare_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionWelfareCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_welfare_cell_create_terminal)
state_machine.init()

function LegionWelfareCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._reward_info = 0

    local function init_legion_welfare_cell_terminal()
        local legion_welfare_cell_exchange_terminal = {
            _name = "legion_welfare_cell_exchange",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.union.user_union_info.union_post) > 1 then
                    return
                end
                local cell = params._datas.cell
                state_machine.excute("legion_welfare_window_window_open", 0, {cell._index, cell._reward_info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(legion_welfare_cell_exchange_terminal)
        state_machine.init()
    end
    
    init_legion_welfare_cell_terminal()
end


function LegionWelfareCell:updateDraw()
    local root = self.roots[1]
    -- 模板id,类型,数量
    local reward_info = zstring.split(self._reward_info, ",")
    local prop_type = tonumber(reward_info[2])
    if tonumber(reward_info[2]) == 13 then --坦克
        prop_type = 3
    elseif tonumber(reward_info[2]) == 6 then --道具    
        prop_type = 1
    elseif tonumber(reward_info[2]) == 7 then --配件    
        prop_type = 7
    else
        prop_type = 1
    end
    -- icon
    local Panel_legion_welfare_icon = ccui.Helper:seekWidgetByName(root, "Panel_legion_welfare_icon")
    Panel_legion_welfare_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,3,tonumber(reward_info[1]),prop_type,tonumber(reward_info[3])})
    Panel_legion_welfare_icon:addChild(cell) 

    -- name
    local Text_legion_welfare_name = ccui.Helper:seekWidgetByName(root, "Text_legion_welfare_name")
    local prop_name = dms.string(dms["prop_mould"], reward_info[1], prop_mould.prop_name)
    Text_legion_welfare_name:setString(prop_name)

    -- dec
    local Text_legion_welfare_infor = ccui.Helper:seekWidgetByName(root,"Text_legion_welfare_infor")
    local remarks = dms.string(dms["prop_mould"], reward_info[1], prop_mould.remarks)
    Text_legion_welfare_infor:setString(remarks)

    -- count
    local Text_legion_welfare_n = ccui.Helper:seekWidgetByName(root,"Text_legion_welfare_n")
    Text_legion_welfare_n:setString(reward_info[3])
end

function LegionWelfareCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_welfare_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    if LegionWelfareCell.__size == nil then
        LegionWelfareCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "legion_welfare_cell_exchange", 
        terminal_state = 0, 
        cell = self,
    }, nil, 1)    

    self:updateDraw()
end

function LegionWelfareCell:onEnterTransitionFinish()

end

function LegionWelfareCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionWelfareCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_welfare_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionWelfareCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_legion_welfare_icon = ccui.Helper:seekWidgetByName(root, "Panel_legion_welfare_icon")
    local Text_legion_welfare_name = ccui.Helper:seekWidgetByName(root, "Text_legion_welfare_name")
    local Text_legion_welfare_infor = ccui.Helper:seekWidgetByName(root,"Text_legion_welfare_infor")
    local Text_legion_welfare_n = ccui.Helper:seekWidgetByName(root,"Text_legion_welfare_n")
    if Panel_legion_welfare_icon ~= nil then
        Panel_legion_welfare_icon:removeAllChildren(true)
        Text_legion_welfare_name:setString("")
        Text_legion_welfare_infor:setString("")
        Text_legion_welfare_n:setString("")
    end
end

function LegionWelfareCell:init(params)
    self._index = params[1]
    self._reward_info = params[2]
    if self._index ~= nil and self._index <= 7 then
        self:onInit()
    end
    self:setContentSize(LegionWelfareCell.__size)
    return self
end

function LegionWelfareCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_welfare_cell, self.roots[1])
end

