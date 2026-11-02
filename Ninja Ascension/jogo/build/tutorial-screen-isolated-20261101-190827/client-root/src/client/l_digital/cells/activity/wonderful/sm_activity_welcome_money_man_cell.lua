--------------------------------------------------------------------------------------------------------------
--  说明：战力排行活动奖励cell
--------------------------------------------------------------------------------------------------------------
SmActivityWelcomeMoneyManCell = class("SmActivityWelcomeMoneyManCellClass", Window)
SmActivityWelcomeMoneyManCell.__size = nil

--创建cell
local sm_activity_welcome_money_man_create_cell_terminal = {
    _name = "sm_activity_welcome_money_man_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivityWelcomeMoneyManCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_welcome_money_man_create_cell_terminal)
state_machine.init()

function SmActivityWelcomeMoneyManCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._info = nil

	 -- Initialize sm_activity_welcome_money_man_cell state machine.
    local function init_sm_activity_welcome_money_man_cell_terminal()

    end 
    -- call func sm_activity_welcome_money_man_cell create state machine.
    init_sm_activity_welcome_money_man_cell_terminal()

end

function SmActivityWelcomeMoneyManCell:updateDraw()
    local root = self.roots[1]
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
    local Panel_zs = ccui.Helper:seekWidgetByName(root, "Panel_zs")
    local Text_zs_n = ccui.Helper:seekWidgetByName(root, "Text_zs_n")
    
    Text_player_name:setString(self._info.nickname)
    Text_zs_n:setString(self._info.get_of_gold)

    local posX = Text_player_name:getPositionX() + Text_player_name:getContentSize().width
    Panel_zs:setPositionX(posX)
end


function SmActivityWelcomeMoneyManCell:onInit()
    local root = cacher.createUIRef("activity/wonderful/yingcaishen_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmActivityWelcomeMoneyManCell.__size == nil then
        SmActivityWelcomeMoneyManCell.__size = root:getContentSize()
    end

	self:updateDraw()
end

function SmActivityWelcomeMoneyManCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmActivityWelcomeMoneyManCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
    local Text_zs_n = ccui.Helper:seekWidgetByName(root, "Text_zs_n")
    if Text_player_name ~= nil then
        Text_player_name:setString("")
        Text_zs_n:setString("")
    end
end

function SmActivityWelcomeMoneyManCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmActivityWelcomeMoneyManCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/yingcaishen_list.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmActivityWelcomeMoneyManCell:init(params)
    self._info = params[1]
	self:onInit()
    self:setContentSize(SmActivityWelcomeMoneyManCell.__size)
    return self
end

function SmActivityWelcomeMoneyManCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/yingcaishen_list.csb", self.roots[1])
end