-----------------------------
--任务目标界面
-----------------------------
TaskTarget = class("TaskTargetClass", Window)

local task_target_window_open_terminal = {
    _name = "task_target_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        if nil == fwin:find("TaskTargetClass") then
            fwin:open(TaskTarget:new():init(), fwin._windows)
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local task_target_window_close_terminal = {
    _name = "task_target_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("TaskTargetClass"))    
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(task_target_window_open_terminal)
state_machine.add(task_target_window_close_terminal)
state_machine.init()

function TaskTarget:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_task_target_terminal()
        local task_target_click_terminal = {
            _name = "task_target_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("national_war_map_window_close",0,{_datas={open_type = 1}})
                local last_open_npc = 1
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
                            last_open_npc = k
                            break
                        end
                    else
                        if k > 9 and tonumber(v) <= 0 then
                            last_open_npc = k
                            break
                        end
                    end
                end
                if fwin:find("DuplicateMapClass") ~= nil 
                    and tonumber(last_open_scene) == fwin:find("DuplicateMapClass").sceneID
                    then
                    local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(last_open_scene), pve_scene.npcs), ",")
                    local index = 1
                    for k,v in pairs(tempNpcIds) do
                        if tonumber(v) == tonumber(last_open_npc) then
                            index = k
                            break
                        end
                    end
                    state_machine.excute("duplicate_map_move_to_choose_npc",0,{index})
                    state_machine.excute("duplicate_map_short_cut_npc",0,{last_open_npc})
                else
                    state_machine.excute("hero_recruit_window_hide",0,"")
                    state_machine.excute("catalogue_storage_window_hide",0,"")
                    state_machine.excute("packs_window_hide",0,"")
                    state_machine.excute("hero_main_window_hide",0,"")
                    state_machine.excute("main_window_open",0,"")
                    state_machine.excute("player_resource_window_show",0,"")   
                    state_machine.excute("home_button_for_action_window_show",0,"")  
                    state_machine.excute("chat_view_window_show",0,"")
                    state_machine.excute("duplicate_title_window_show",0,"")
                    state_machine.excute("hero_star_activation_window_hide",0,"")
                    state_machine.excute("hero_talent_activation_window_close",0,"")
                    state_machine.excute("duplicate_title_update_information", 0, {last_open_scene})
                    state_machine.excute("duplicate_manager_window_open",0,{1})
                    state_machine.excute("duplicate_list_cell_click",0,{
                        _datas = {
                            cell = {
                                scenceID = last_open_scene,
                                from_type = 1,
                                npc_id = last_open_npc
                            }
                        }
                    })
                    state_machine.excute("duplicate_map_window_show",0,"")
                    state_machine.excute("duplicate_map_short_cut_npc",0,{last_open_npc})
                end
                state_machine.excute("task_target_window_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(task_target_click_terminal)
        state_machine.init()
    end
    
    init_task_target_terminal()
end

function TaskTarget:onEnterTransitionFinish()

end

function TaskTarget:onInit( )
    local last_open_scene = 1
    for k,v in pairs(_ED.scene_current_state) do
        if tonumber(v) >= 0 then
            last_open_scene = k
        else
            break
        end
    end
    local current_npc = 0
    local isChangeNext = true
    for k,v in pairs(_ED.npc_state) do
        if tonumber(last_open_scene) == 1 then
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

    local filePath = string.format(config_csb.activity.dailytasks.task_target_window, ""..last_target.bg) 
    local csbItem = csb.createNode(filePath)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_target_go"), nil, 
    {
        terminal_name = "task_target_click",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_target_close"), nil, 
    {
        terminal_name = "task_target_window_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    local Text_target_bar_t = ccui.Helper:seekWidgetByName(root, "Text_target_bar_t")
    local LoadingBar_target = ccui.Helper:seekWidgetByName(root, "LoadingBar_target")
    
    Text_target_bar_t:setString(current_npc.."/"..last_target.target_param_value)
    LoadingBar_target:setPercent(current_npc/last_target.target_param_value * 100)

    playEffect(formatMusicFile("effect", last_target.pop_music))
end

function TaskTarget:init()
    self:onInit(params)
    return self
end

function TaskTarget:onExit()
    state_machine.remove("task_target_click")
end
