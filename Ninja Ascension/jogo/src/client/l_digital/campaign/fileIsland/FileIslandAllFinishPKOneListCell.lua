----------------------------------------------------------------------------------------------------
-- 试炼扫荡cell
-------------------------------------------------------------------------------------------------------
FileIslandAllFinishPKOneListCell = class("FileIslandAllFinishPKOneListCellClass", Window)
FileIslandAllFinishPKOneListCell.__size = nil

local fileIsland_one_pk_list_cell_terminal = {
    _name = "fileIsland_one_pk_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = FileIslandAllFinishPKOneListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fileIsland_one_pk_list_cell_terminal)
state_machine.init()

function FileIslandAllFinishPKOneListCell:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0

    local function init_fileIsland_one_pk_list_cell_terminal()
        local fileIsland_one_pk_list_cell_update_terminal = {
            _name = "fileIsland_one_pk_list_cell_update",
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
        local fileIsland_one_pk_list_cell_go_terminal = {
            _name = "fileIsland_one_pk_list_cell_go",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("fileIsland_formation_open", 0, {info = cell._taskInfo, infoType = 2})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fileIsland_one_pk_list_cell_update_terminal)
        state_machine.add(fileIsland_one_pk_list_cell_go_terminal)
        state_machine.init()
    end
    init_fileIsland_one_pk_list_cell_terminal()           
end

function FileIslandAllFinishPKOneListCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_single_challenge = ccui.Helper:seekWidgetByName(root, "Text_single_challenge")
    local Panel_single_role = ccui.Helper:seekWidgetByName(root, "Panel_single_role")
    Text_single_challenge:setString(string.format( tipStringInfo_file_island_tips[3], self._index))

    local headId = zstring.split(dms.string(dms["npc"], self._taskInfo.npcId, 3), ",")[2]
    
    if self._armature == nil then
        self._armature = sp.spine_sprite(Panel_single_role, headId, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            self._armature:setScaleX(-1)
        end
    end
end

function FileIslandAllFinishPKOneListCell:onEnterTransitionFinish()

end

function FileIslandAllFinishPKOneListCell:onInit()
    local csbItem = csb.createNode("campaign/explore/explore_single_challenge_role_cell.csb")
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    -- local root = cacher.createUIRef("campaign/TrialTower/sm_trial_tower_rweep_tab_3_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    local size = root:getContentSize()
    
    if FileIslandAllFinishPKOneListCell.__size == nil then
        FileIslandAllFinishPKOneListCell.__size = size
    end

    --挑战
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_challenge_boss"), nil, 
    {
        terminal_name = "fileIsland_one_pk_list_cell_go", 
        terminal_state = 0,
        touch_black = true,
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
        cell = self,
    },
    nil,1)

    self:onUpdateDraw()
end

function FileIslandAllFinishPKOneListCell:onExit()
    cacher.freeRef("campaign/explore/explore_single_challenge_role_cell.csb", self.roots[1])
end

function FileIslandAllFinishPKOneListCell:init(params) 
    self._index = params[1]
    self._taskInfo = params[2]
   
    self:onInit()
    self:setContentSize(FileIslandAllFinishPKOneListCell.__size)
end

