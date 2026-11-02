--------------------------------------------------------------------------------------------------------------
--  说明：金猪纳宝活动cell
--------------------------------------------------------------------------------------------------------------
SmActivityGoldenPigNabaoCell = class("SmActivityGoldenPigNabaoCellClass", Window)
SmActivityGoldenPigNabaoCell.__size = nil

--创建cell
local sm_activity_golden_pig_nabao_create_cell_terminal = {
    _name = "sm_activity_golden_pig_nabao_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivityGoldenPigNabaoCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_golden_pig_nabao_create_cell_terminal)
state_machine.init()

function SmActivityGoldenPigNabaoCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._info = nil

	 -- Initialize sm_activity_golden_pig_nabao_cell state machine.
    local function init_sm_activity_golden_pig_nabao_cell_terminal()

    end 
    -- call func sm_activity_golden_pig_nabao_cell create state machine.
    init_sm_activity_golden_pig_nabao_cell_terminal()

end

function SmActivityGoldenPigNabaoCell:updateDraw()
    local root = self.roots[1]
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
    local Panel_zs = ccui.Helper:seekWidgetByName(root, "Panel_zs")
    local Text_zs_n = ccui.Helper:seekWidgetByName(root, "Text_zs_n")
    Text_player_name:setString(self._info.userName)
    Text_zs_n:setString(self._info.rewardGold)

    local posX = Text_player_name:getPositionX() + Text_player_name:getContentSize().width
    Panel_zs:setPositionX(posX)
end


function SmActivityGoldenPigNabaoCell:onInit()
    local root = cacher.createUIRef("Lucky/Lucky_number_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmActivityGoldenPigNabaoCell.__size == nil then
        SmActivityGoldenPigNabaoCell.__size = root:getContentSize()
    end

	self:updateDraw()
end

function SmActivityGoldenPigNabaoCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmActivityGoldenPigNabaoCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
    local Text_zs_n = ccui.Helper:seekWidgetByName(root, "Text_zs_n")
    if Text_player_name ~= nil then
        Text_player_name:setString("")
        Text_zs_n:setString("")
    end
end

function SmActivityGoldenPigNabaoCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmActivityGoldenPigNabaoCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("Lucky/Lucky_number_list.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmActivityGoldenPigNabaoCell:init(params)
    self._info = params[1]
	self:onInit()
    self:setContentSize(SmActivityGoldenPigNabaoCell.__size)
    return self
end

function SmActivityGoldenPigNabaoCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("Lucky/Lucky_number_list.csb", self.roots[1])
end