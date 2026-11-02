-- ------------------------------------------------------------------------------------------------------------
--  奖励仓库cell
-- ------------------------------------------------------------------------------------------------------------
LegionWelfareWindowCell = class("LegionWelfareWindowCellClass", Window)
LegionWelfareWindowCell.__size = nil

--创建cell
local legion_welfare_window_cell_create_terminal = {
    _name = "legion_welfare_window_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionWelfareWindowCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_welfare_window_cell_create_terminal)
state_machine.init()

function LegionWelfareWindowCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info = nil 

    self._is_selected = false

    local function init_legion_welfare_window_cell_terminal()
        local legion_welfare_window_cell_exchange_terminal = {
            _name = "legion_welfare_window_cell_exchange",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell._is_selected == true then
                    cell._is_selected = false
                    state_machine.excute("legion_welfare_window_update_select_num", 0, -1)
                else
                    cell._is_selected = true
                    state_machine.excute("legion_welfare_window_update_select_num", 0, 1)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local legion_welfare_window_cell_set_selected_terminal = {
            _name = "legion_welfare_window_cell_set_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params[1]
                if cell ~= nil then
                    cell:setSelected(params[2])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(legion_welfare_window_cell_exchange_terminal)
        state_machine.add(legion_welfare_window_cell_set_selected_terminal)
        state_machine.init()
    end
    
    init_legion_welfare_window_cell_terminal()
end

function LegionWelfareWindowCell:setSelected(selected)
    if self._is_selected == selected then
        return
    end
    self._is_selected = selected

    if self.roots ~= nil and self.roots[1] ~= nil then
        local root = self.roots[1]
        local CheckBox_creeps = ccui.Helper:seekWidgetByName(root,"CheckBox_creeps")
        CheckBox_creeps:setSelected(selected)
    end
end

function LegionWelfareWindowCell:updateDraw()
    local root = self.roots[1]

    -- 职位
    local Text_legion_people_position = ccui.Helper:seekWidgetByName(root,"Text_legion_people_position")
    if tonumber(self._info.post) == 1 then
        Text_legion_people_position:setString(tipStringInfo_union_str[33])
        Text_legion_people_position:setColor(cc.c3b(tipStringInfo_union_color[1][1], tipStringInfo_union_color[1][2], tipStringInfo_union_color[1][3]))
    elseif tonumber(self._info.post) == 2 then
        Text_legion_people_position:setString(tipStringInfo_union_str[34])
        Text_legion_people_position:setColor(cc.c3b(tipStringInfo_union_color[2][1], tipStringInfo_union_color[2][2], tipStringInfo_union_color[2][3]))
    else
        Text_legion_people_position:setString(tipStringInfo_union_str[43])
        Text_legion_people_position:setColor(cc.c3b(tipStringInfo_union_color[5][1], tipStringInfo_union_color[5][2], tipStringInfo_union_color[5][3]))
    end

    -- 战力
    local Text_legion_people_fight_n = ccui.Helper:seekWidgetByName(root,"Text_legion_people_fight_n")
    Text_legion_people_fight_n:setString(exChangeNumToString(self._info.capactity))
    
    -- name and leve
    local Text_legion_people_name = ccui.Helper:seekWidgetByName(root,"Text_legion_people_name")
    Text_legion_people_name:setString(self._info.name.." "..string.format(red_alert_all_str[117],self._info.level))

    -- 周贡献
    local Text_week_contribution_n = ccui.Helper:seekWidgetByName(root,"Text_week_contribution_n")
    Text_week_contribution_n:setString(self._info.weak_activity_con)

    -- 参与次数
    local Text_participate_n = ccui.Helper:seekWidgetByName(root,"Text_participate_n")
    Text_participate_n:setString(self._info.weak_activity_join_times)

    local CheckBox_creeps = ccui.Helper:seekWidgetByName(root,"CheckBox_creeps")
    CheckBox_creeps:setSelected(self._is_selected)
end

function LegionWelfareWindowCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_welfare_window_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    if LegionWelfareWindowCell.__size == nil then
        LegionWelfareWindowCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"CheckBox_creeps"), nil, 
    {
        terminal_name = "legion_welfare_window_cell_exchange", 
        terminal_state = 0, 
        cell = self,
    }, nil, 1)    

    self:updateDraw()
end

function LegionWelfareWindowCell:onEnterTransitionFinish()

end

function LegionWelfareWindowCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionWelfareWindowCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_welfare_window_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionWelfareWindowCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_legion_people_position = ccui.Helper:seekWidgetByName(root, "Text_legion_people_position")
    local Text_legion_people_fight_n = ccui.Helper:seekWidgetByName(root, "Text_legion_people_fight_n")
    local Text_legion_people_name = ccui.Helper:seekWidgetByName(root, "Text_legion_people_name")
    local Text_week_contribution_n = ccui.Helper:seekWidgetByName(root, "Text_week_contribution_n")
    local Text_participate_n = ccui.Helper:seekWidgetByName(root, "Text_participate_n")
    local CheckBox_creeps = ccui.Helper:seekWidgetByName(root,"CheckBox_creeps")
    if Text_legion_people_position ~= nil then
        Text_legion_people_position:setString("")
        Text_legion_people_fight_n:setString("")
        Text_legion_people_name:setString("")
        Text_week_contribution_n:setString("")
        Text_participate_n:setString("")
        CheckBox_creeps:setSelected(true)
    end
end

function LegionWelfareWindowCell:init(params)
    self._info = params[1]
    self._index = params[2]
    if self._index ~= nil and self._index <= 7 then
        self:onInit()
    end
    self:setContentSize(LegionWelfareWindowCell.__size)
    return self
end

function LegionWelfareWindowCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_welfare_window_cell, self.roots[1])
end

