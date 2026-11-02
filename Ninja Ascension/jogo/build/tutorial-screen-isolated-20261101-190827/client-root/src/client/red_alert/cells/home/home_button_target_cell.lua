
HomeButtonTargetCell = class("HomeButtonTargetCellClass", Window)
HomeButtonTargetCell.__size = nil

local home_button_target_cell_create_terminal = {
    _name = "home_button_target_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = HomeButtonTargetCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(home_button_target_cell_create_terminal)
state_machine.init()

function HomeButtonTargetCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    app.load("client.red_alert.activity.dailytasks.TaskTarget")

    local function init_home_button_target_cell_terminal()
        local home_button_target_cell_click_terminal = {
            _name = "home_button_target_cell_click",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("task_target_window_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_button_target_cell_update_terminal = {
            _name = "home_button_target_cell_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(home_button_target_cell_click_terminal)
        state_machine.add(home_button_target_cell_update_terminal)
        state_machine.init()
    end
    
    init_home_button_target_cell_terminal()
end

function HomeButtonTargetCell:onUpdateDraw( ... )
    local root = self.roots[1]
    local Panel_target_icon = ccui.Helper:seekWidgetByName(root, "Panel_target_icon")
    local LoadingBar_target = ccui.Helper:seekWidgetByName(root, "LoadingBar_target")
    local Text_target = ccui.Helper:seekWidgetByName(root, "Text_target")
    local Panel_prompt = ccui.Helper:seekWidgetByName(root, "Panel_prompt")
    local Text_promp = ccui.Helper:seekWidgetByName(root, "Text_promp")
    local current_npc = 0
    local isChangeNext = true
    local last_open_scene = 1
    for k,v in pairs(_ED.scene_current_state) do
        if tonumber(v) >= 0 then
            last_open_scene = k
        else
            break
        end
    end

    for k,v in pairs(_ED.npc_state) do
        if last_open_scene == 1 then
            if tonumber(v) <= 0 and k%2 ~= 0 then
                current_npc = k
                current_npc = (tonumber(current_npc) + 1)/2
                break
            end
        else
            if k > 9 and tonumber(v) <= 0 then
                current_npc = k
                current_npc = current_npc - 4
                break
            end
        end
    end
    current_npc = current_npc - 1
    -- local sceneState = tonumber(_ED.scene_current_state[1])
    -- current_npc = sceneState
    -- print("场景当前的状态：", sceneState)
    local last_target = nil
    for k,v in pairs(_ED.target_datas) do
        if last_target == nil then
            last_target = v
            isChangeNext = false
        end
        if current_npc >= v.target_param_value then
            isChangeNext = true
            if v.target_param_value > last_target.target_param_value then
                last_target = v
            end
        end
    end
    if isChangeNext == true and last_target.next_task_id > 0 then
        for k,v in pairs(_ED.target_datas) do
            if last_target.next_task_id == v.id then
                last_target = v
                break
            end
        end
    end
    Panel_target_icon:setBackGroundImage("images/ui/wonderful/home_task_role_"..last_target.icon..".png")
    Text_target:setString(current_npc.."/"..last_target.target_param_value)
    LoadingBar_target:setPercent(current_npc/last_target.target_param_value * 100)
    Text_promp:setString(last_target.pop_info)
    if tonumber(current_npc) >= tonumber(last_target.target_param_value) then
        self:setVisible(false)
    end
end

function HomeButtonTargetCell:onInit()
    -- 绘图初始化
    local csbItem = csb.createNode(config_csb.cells.home.home_button_target_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)

    local action = csb.createTimeline(config_csb.cells.home.home_button_target_cell)
    -- table.insert(self.actions, action)
    root:runAction(action)
    action:play("animation_chat", true)

    if HomeButtonTargetCell.__size == nil then
        HomeButtonTargetCell.__size = root:getContentSize()
    end

    self:setContentSize(HomeButtonTargetCell.__size)

    local Panel_target_icon = ccui.Helper:seekWidgetByName(root, "Panel_target_icon")
    fwin:addTouchEventListener(Panel_target_icon, nil, 
    {
        terminal_name = "home_button_target_cell_click",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)

    self:onUpdateDraw() 
end

function HomeButtonTargetCell:init()
    self:onInit()
    return self
end

function HomeButtonTargetCell:onExit()
    state_machine.remove("home_button_target_cell_click")
    state_machine.remove("home_button_target_cell_update")
end