--------------------------------------------------------------------------------------------------------------
--  说明：王者之战战斗结束列表控件
--------------------------------------------------------------------------------------------------------------
SmCrossServerBattleOfKingsOverListCell = class("SmCrossServerBattleOfKingsOverListCellClass", Window)
SmCrossServerBattleOfKingsOverListCell.__size = nil

--创建cell
local sm_cross_server_battle_of_kings_over_list_cell_terminal = {
    _name = "sm_cross_server_battle_of_kings_over_list_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmCrossServerBattleOfKingsOverListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        -- cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_cross_server_battle_of_kings_over_list_cell_terminal)
state_machine.init()

function SmCrossServerBattleOfKingsOverListCell:ctor()
	self.super:ctor()
	self.roots = {}
	 -- Initialize sm_cross_server_battle_of_kings_over_list_cell state machine.
    local function init_sm_cross_server_battle_of_kings_over_list_cell_terminal()
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
    -- call func sm_cross_server_battle_of_kings_over_list_cell create state machine.
    init_sm_cross_server_battle_of_kings_over_list_cell_terminal()

end

function SmCrossServerBattleOfKingsOverListCell:updateDraw()
    local root = self.roots[1]
    
end

function SmCrossServerBattleOfKingsOverListCell:onUpdate(dt)
    
end

function SmCrossServerBattleOfKingsOverListCell:onInit()
    local root = cacher.createUIRef("campaign/BattleofKings/battle_of_kings_tab_2_list_2.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmCrossServerBattleOfKingsOverListCell.__size == nil then
        SmCrossServerBattleOfKingsOverListCell.__size = root:getContentSize()
    end

    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_sxxz"), nil, 
    -- {
        -- terminal_name = "sm_cross_server_trial_tower_Addition_select_back_activity", 
        -- terminal_state = 0, 
        -- touch_black = true,
		-- cells = self,
    -- }, nil, 1)

	self:updateDraw()
end

function SmCrossServerBattleOfKingsOverListCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmCrossServerBattleOfKingsOverListCell:clearUIInfo( ... )
    local root = self.roots[1]
    
end

function SmCrossServerBattleOfKingsOverListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmCrossServerBattleOfKingsOverListCell:unload()
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

function SmCrossServerBattleOfKingsOverListCell:init(params)
    -- self.info = params[1]
    -- self.need = params[2]
    -- self.index = params[3]
	self:onInit()

    self:setContentSize(SmCrossServerBattleOfKingsOverListCell.__size)
    return self
end

function SmCrossServerBattleOfKingsOverListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/BattleofKings/battle_of_kings_tab_2_list_2.csb", self.roots[1])
end