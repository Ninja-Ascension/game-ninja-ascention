--------------------------------------------------------------------------------------------------------------
--  说明：王者之战淘汰控件
--------------------------------------------------------------------------------------------------------------
SmCrossServerBattleOfKingsEliminateCell = class("SmCrossServerBattleOfKingsEliminateCellClass", Window)
SmCrossServerBattleOfKingsEliminateCell.__size = nil

--创建cell
local sm_cross_server_battle_of_kings_eliminate_cell_terminal = {
    _name = "sm_cross_server_battle_of_kings_eliminate_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmCrossServerBattleOfKingsEliminateCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        -- cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_cross_server_battle_of_kings_eliminate_cell_terminal)
state_machine.init()

function SmCrossServerBattleOfKingsEliminateCell:ctor()
	self.super:ctor()
	self.roots = {}

    self.cd_time = 0
	 -- Initialize sm_cross_server_battle_of_kings_eliminate_cell state machine.
    local function init_sm_cross_server_battle_of_kings_eliminate_cell_terminal()
        --
        -- local sm_cross_server_trial_tower_Addition_select_back_activity_terminal = {
            -- _name = "sm_cross_server_trial_tower_Addition_select_back_activity",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)          
                -- local cell = params._datas.cells
                -- if tonumber(_ED.three_kingdoms_view.current_max_stars) >= tonumber(cell.need) then
                    -- local Image_ygm = ccui.Helper:seekWidgetByName(cell.roots[1], "Image_ygm")
                    -- Image_ygm:setVisible(true)
                    -- Image_ygm:setScale(5)
                    -- local function playOver()
                        -- state_machine.excute("addition_select_back_activity", 0, {cell.need,cell.info})
                    -- end
                    -- Image_ygm:runAction(cc.Sequence:create(cc.ScaleTo:create(0.15, 1),cc.CallFunc:create(playOver)))
                    
                -- else
                    -- return
                -- end
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }

        -- state_machine.add(sm_cross_server_trial_tower_Addition_select_back_activity_terminal)
        state_machine.init()
    end 
    -- call func sm_cross_server_battle_of_kings_eliminate_cell create state machine.
    init_sm_cross_server_battle_of_kings_eliminate_cell_terminal()

end

function SmCrossServerBattleOfKingsEliminateCell:updateDraw()
    local root = self.roots[1]
    local strs = string.format(_new_interface_text[200],zstring.tonumber(_ED.cross_server_kings_battle.my_win_number),zstring.tonumber(_ED.cross_server_kings_battle.my_lose_number))
    local Text_tips = ccui.Helper:seekWidgetByName(root, "Text_tips") 
    Text_tips:setString(strs)
end

function SmCrossServerBattleOfKingsEliminateCell:onUpdate(dt)

end

function SmCrossServerBattleOfKingsEliminateCell:onInit()
    local root = cacher.createUIRef("campaign/BattleofKings/battle_of_kings_tab_2_list_2.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmCrossServerBattleOfKingsEliminateCell.__size == nil then
        SmCrossServerBattleOfKingsEliminateCell.__size = root:getContentSize()
    end
	
	self:updateDraw()
end

function SmCrossServerBattleOfKingsEliminateCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmCrossServerBattleOfKingsEliminateCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_tips = ccui.Helper:seekWidgetByName(root, "Text_tips")
    if Text_tips ~= nil then
        Text_tips:setString("")
    end
end

function SmCrossServerBattleOfKingsEliminateCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmCrossServerBattleOfKingsEliminateCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/BattleofKings/battle_of_kings_tab_2_list_2.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmCrossServerBattleOfKingsEliminateCell:init(params)
    self.index = params[1]
    self.max_index = params[2]
	self:onInit()

    self:setContentSize(SmCrossServerBattleOfKingsEliminateCell.__size)
    return self
end

function SmCrossServerBattleOfKingsEliminateCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/BattleofKings/battle_of_kings_tab_2_list_2.csb", self.roots[1])
end