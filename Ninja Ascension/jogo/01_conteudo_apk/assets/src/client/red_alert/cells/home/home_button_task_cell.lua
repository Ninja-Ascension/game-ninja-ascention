
HomeButtonTaskCell = class("HomeButtonTaskCellClass", Window)
HomeButtonTaskCell.__size = nil

local home_button_task_cell_create_terminal = {
    _name = "home_button_task_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if _ED.user_task_infos["0"] == nil then
            return nil
        end
        local cell = HomeButtonTaskCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(home_button_task_cell_create_terminal)
state_machine.init()

function HomeButtonTaskCell:ctor()
    self.super:ctor()
    self.roots = {}

    self.current_achieve_mould_id = 0

    app.load("client.red_alert.activity.dailytasks.TaskFinish")

    local function init_home_button_task_cell_terminal()
        local home_button_task_cell_click_terminal = {
            _name = "home_button_task_cell_click",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local achievement_short_id = dms.int(dms["achievement_mould"], instance.current_achieve_mould_id, achievement_mould.achievement_short_id)
                state_machine.excute("short_cut_go_to_other_window",0,{achievement_short_id, true})
                if fwin:find("DuplicateMapClass")  ~= nil then
                    state_machine.excute("player_resource_window_hide", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(home_button_task_cell_click_terminal)
        state_machine.init()
    end
    
    init_home_button_task_cell_terminal()
end

function HomeButtonTaskCell:onUpdateDraw( ... )

end

function HomeButtonTaskCell:onUpdate(dt)
    local number = tonumber(tipStringInfo_target_param[1])
    if self.current_achieve_mould_id >= number
        then
        self.roots[1]:setVisible(false)
        return
    end
    local ret = missionIsOver()
    if ret ~= self.Panel_task_arrow._visible then
        self.Panel_task_arrow:setVisible(ret)
        self.Panel_task_arrow._visible = ret
    end
    -- print(self.Panel_task_arrow._visible)
end

function HomeButtonTaskCell:onInit()
    local info = ""
    for i,v in pairs(_ED.user_task_infos["0"]) do
        if tonumber(v.achievement_finish_type) == 66 then
            info = dms.string(dms["achievement_mould"], v.achieve_mould_id, achievement_mould.achievement_dec)
            self.current_achieve_mould_id = v.achieve_mould_id
            if zstring.tonumber(v.task_complete_count) >= zstring.tonumber(v.need_complete_count) then
                local all_reward_datas = {}
                all_reward_datas.show_reward_list = {}
                local achievement_reward = dms.string(dms["achievement_mould"], v.achieve_mould_id, achievement_mould.achievement_reward)
                achievement_reward = zstring.split(achievement_reward,"|")
                for i,rewards in pairs(achievement_reward) do
                    local temp_tab = zstring.split(rewards,",")
                    local data = {
                        item_value = temp_tab[3],
                        prop_type = temp_tab[2],
                        prop_item = temp_tab[1],
                    }
                    table.insert(all_reward_datas.show_reward_list, data)
                end
                state_machine.excute("task_finish_window_open", 0, {v, all_reward_datas})
            else
                state_machine.excute("task_finish_window_close", 0, nil)
            end
            break
        end
    end
    local elements = dms.searchs(dms["target_param"], target_param.achievement_mould_id, self.current_achieve_mould_id)

    -- 绘图初始化
    local csbItem = csb.createNode(config_csb.cells.home.home_button_task_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)

    self.Panel_task_arrow = ccui.Helper:seekWidgetByName(root, "Panel_task_arrow")
    -- tipStringInfo_target_param目标引导关闭关卡
    local number = tonumber(tipStringInfo_target_param[1])
    if self.current_achieve_mould_id >= number
        or self.current_achieve_mould_id == nil
        or info == ""
        then
        root:setVisible(false)
    else
        local action = csb.createTimeline(config_csb.cells.home.home_button_task_cell)
        -- table.insert(self.actions, action)
        root:runAction(action)
        action:play("animation_task", true)
    end

    ccui.Helper:seekWidgetByName(root, "Text_task_infor"):setString(info)

    -- 绘制奖励宝石数量
    local Text_gem = ccui.Helper:seekWidgetByName(root, "Text_gem")
    if nil ~= Text_gem and nil ~= elements then
        local element = elements[1]
        if nil ~= element then
            local rewards = zstring.split(dms.atos(element, target_param.rewards), ",")
            if nil ~= rewards then
                local rType = rewards[2]
                local reward = rewards[3]
                if rType == "2" and nil ~= reward then
                    Text_gem:setString("+" .. reward)
                end
            end
        end
    end

    if HomeButtonTaskCell.__size == nil then
        HomeButtonTaskCell.__size = root:getContentSize()
    end

    self:setContentSize(HomeButtonTaskCell.__size)

    local Panel_task_touch = ccui.Helper:seekWidgetByName(root, "Panel_task_touch")
    fwin:addTouchEventListener(Panel_task_touch, nil, 
    {
        terminal_name = "home_button_task_cell_click",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2)
    
    self:onUpdateDraw()

end

function HomeButtonTaskCell:init()
    self:onInit()
    return self
end

function HomeButtonTaskCell:onExit()
    state_machine.remove("home_button_task_cell_click")
end