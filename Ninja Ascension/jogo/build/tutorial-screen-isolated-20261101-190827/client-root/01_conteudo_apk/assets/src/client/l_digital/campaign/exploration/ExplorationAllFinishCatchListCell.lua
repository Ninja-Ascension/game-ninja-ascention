----------------------------------------------------------------------------------------------------
-- 试炼扫荡cell
-------------------------------------------------------------------------------------------------------
ExplorationAllFinishCatchListCell = class("ExplorationAllFinishCatchListCellClass", Window)
ExplorationAllFinishCatchListCell.__size = nil

local exploration_all_finish_catch_list_cell_terminal = {
    _name = "exploration_all_finish_catch_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ExplorationAllFinishCatchListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_all_finish_catch_list_cell_terminal)
state_machine.init()

function ExplorationAllFinishCatchListCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0

    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishCatchBegin")
    local function init_exploration_all_finish_catch_list_cell_terminal()
        local exploration_all_finish_catch_list_cell_update_terminal = {
            _name = "exploration_all_finish_catch_list_cell_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --挑战
        local exploration_all_finish_catch_list_cell_go_terminal = {
            _name = "exploration_all_finish_catch_list_cell_go",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("exploration_all_finish_catch_begin_window_open", 0, {cell._taskInfo, 2})
                cell:removeFromParent()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(exploration_all_finish_catch_list_cell_update_terminal)
        state_machine.add(exploration_all_finish_catch_list_cell_go_terminal)
        state_machine.init()
    end
    init_exploration_all_finish_catch_list_cell_terminal()           
end

function ExplorationAllFinishCatchListCell:onUpdateDraw()
    local root = self.roots[1]
    -- local Text_single_challenge = ccui.Helper:seekWidgetByName(root, "Text_single_challenge")
    -- local Panel_single_role = ccui.Helper:seekWidgetByName(root, "Panel_single_role")
    -- Text_single_challenge:setString(string.format( tipStringInfo_file_island_tips[3], self._index))
    -- local headId = zstring.split(dms.string(dms["npc"], self._taskInfo.npcId, 3), ",")[2]
    -- if self._armature == nil then
    --     self._armature = sp.spine_sprite(Panel_single_role, headId, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
    --     if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
    --         self._armature:setScaleX(-1)
    --     end
    -- end
end

function ExplorationAllFinishCatchListCell:onEnterTransitionFinish()

end

function ExplorationAllFinishCatchListCell:onInit()
    local csbItem = csb.createNode("campaign/exploration/exploration_event_catch_cell.csb")
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    -- local root = cacher.createUIRef("campaign/TrialTower/sm_trial_tower_rweep_tab_3_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if ExplorationAllFinishCatchListCell.__size == nil then
        ExplorationAllFinishCatchListCell.__size = size
    end

    --挑战
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_go"), nil, 
    {
        terminal_name = "exploration_all_finish_catch_list_cell_go", 
        terminal_state = 0,
        touch_black = true,
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
        cell = self,
    },
    nil,1)

    self:onUpdateDraw()
end

function ExplorationAllFinishCatchListCell:onExit()
    cacher.freeRef("campaign/explore/explore_single_challenge_role_cell.csb", self.roots[1])
end

function ExplorationAllFinishCatchListCell:init(params) 
    self._index = params[1]
    self._taskInfo = params[2]
   
    self:onInit()
    self:setContentSize(ExplorationAllFinishCatchListCell.__size)
end

