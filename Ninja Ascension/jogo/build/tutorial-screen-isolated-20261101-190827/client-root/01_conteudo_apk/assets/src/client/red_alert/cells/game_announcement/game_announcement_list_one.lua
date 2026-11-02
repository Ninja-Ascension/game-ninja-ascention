--------------------------------------------------------------------------------------------------------------
--  说明：公告左边单个控件
--------------------------------------------------------------------------------------------------------------
GameAnnouncementListOne = class("GameAnnouncementListOneClass", Window)
GameAnnouncementListOne.__size = nil

--创建cell
local game_announcement_list_one_create_terminal = {
    _name = "game_announcement_list_one_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local title_type = params[1]
        local index_type = params[2]
        local cell = GameAnnouncementListOne:new()
        cell:init(title_type,index_type)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(game_announcement_list_one_create_terminal)
state_machine.init()

function GameAnnouncementListOne:ctor()
    self.super:ctor()
    self.roots = {}

  -- var 
  -- 单个控件名称
  self._title_type = nil
  --是否选中
  self._select = false

     -- Initialize game_announcement_list_one state machine.
    local function init_game_announcement_list_one_terminal()

        local game_announcement_list_one_selected_terminal = {
            _name = "game_announcement_list_one_selected",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("game_announcement_select_left_once", 0, cell._index_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(game_announcement_list_one_selected_terminal)
        state_machine.init()
    end 
    -- call func game_announcement_list_one create state machine.
    init_game_announcement_list_one_terminal()

end

function GameAnnouncementListOne:changeSelectedState( isSelected )
    local root = self.roots[1]
    local Text_9 = ccui.Helper:seekWidgetByName(root,"Text_9")
    local Button_6 = ccui.Helper:seekWidgetByName(root,"Button_6")
    if isSelected == true then
        Text_9:setColor(cc.c3b(255,234,198))
        Button_6:setHighlighted(true)
        Button_6:setTouchEnabled(false)
    else
        Text_9:setColor(cc.c3b(144,101,65))
        Button_6:setHighlighted(false)
        Button_6:setTouchEnabled(true)
    end
end


function GameAnnouncementListOne:updateDraw()
    local root = self.roots[1]
    local Text_9 = ccui.Helper:seekWidgetByName(root,"Text_9")
    Text_9:setString(self._title_type)
end

function GameAnnouncementListOne:onInit()
    local root = cacher.createUIRef(config_csb.cells.game_announcement.game_announcement_list_one, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if GameAnnouncementListOne.__size == nil then
        GameAnnouncementListOne.__size = ccui.Helper:seekWidgetByName(root, "Panel_gonggao"):getContentSize()
    end

    --选择当前页
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_6"), nil, 
    {
        terminal_name = "game_announcement_list_one_selected", 
        terminal_state = 0, 
        cell = self, 
    }, nil, 0)    

    self:updateDraw()

end

function GameAnnouncementListOne:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function GameAnnouncementListOne:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function GameAnnouncementListOne:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.game_announcement.game_announcement_list_one, root)
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function GameAnnouncementListOne:init(title_type,index_type)
    self._title_type = title_type
    self._index_type = index_type
    self:onInit()
    self:setContentSize(GameAnnouncementListOne.__size)
    return self
end

function GameAnnouncementListOne:onExit()
    cacher.freeRef(config_csb.cells.game_announcement.game_announcement_list_one, self.roots[1])
end