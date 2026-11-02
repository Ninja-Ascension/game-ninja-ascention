PersonalFightTaskCell = class("PersonalFightTaskCellClass", Window)

local personal_player_task_cell_create_terminal = {
    _name = "personal_player_task_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local index = params[1]
        local cell = PersonalFightTaskCell:new()
        cell:init(index)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(personal_player_task_cell_create_terminal)
state_machine.init()

function PersonalFightTaskCell:ctor()
    self.super:ctor()
    self.roots = {}
end

function PersonalFightTaskCell:onUpdateDraw()
    local root = self.roots[1]

    for i = 1, 3 do
        local Image_rew_box = ccui.Helper:seekWidgetByName(root,"Image_rew_box_"..i)
        if i == self._index then
            Image_rew_box:setVisible(true)
        else
            Image_rew_box:setVisible(false)
        end
    end

    local Panel_rew_light = ccui.Helper:seekWidgetByName(root,"Panel_rew_light")

    task_data = nil
    task_mould_id = 945 + self._index

    if _ED.user_task_infos["7"] ~= nil then
        for i, data in pairs(_ED.user_task_infos["7"]) do
            if zstring.tonumber(data.task_mould_id) == task_mould_id then
                task_data = data
                break
            end
        end
    end
    
    if task_data == nil then
        Panel_rew_light:setVisible(false)
    else
        local total = zstring.tonumber(task_data.need_complete_count)
        local current = zstring.tonumber(task_data.task_complete_count)
        if current >= total then
            Panel_rew_light:setVisible(true)
        else
            Panel_rew_light:setVisible(false)
        end
    end
end

function PersonalFightTaskCell:onInit()
    local csbNode = csb.createNode(config_csb.cells.palyer_build.palyer_build_task_cell)
    self:addChild(csbNode)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw()
end

function PersonalFightTaskCell:init(index, state)
    self._index = index

    self:onInit()
    return self
end
