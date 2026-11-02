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
        local state_type = params[3]
        local notice_table = params[4]
        local cell = GameAnnouncementListOne:new()
        cell:init(title_type,index_type,state_type,notice_table)
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

    self._index_type = 0

    self._state_type = false

    self._notice_table = nil

    self._color = 1

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
    local Image_1 = ccui.Helper:seekWidgetByName(root,"Image_1")
    local game_announcement_push = cc.UserDefault:getInstance():getStringForKey("game_announcement_push")
    local push_announcement = zstring.split(game_announcement_push,"|||")
    if isSelected == true then
        Image_1:setVisible(false)
        if self._state_type == true then
            game_announcement_push = game_announcement_push .."|||"..zstring.exchangeTo(self._notice_table[self._index_type])
            cc.UserDefault:getInstance():setStringForKey("game_announcement_push",game_announcement_push)
        end
        state_machine.excute("main_window_push_game_announcement",0,0)
        -- Text_9:setColor(cc.c3b(color_Type[self._color][1], color_Type[self._color][2], color_Type[self._color][3]))
        Button_6:setHighlighted(true)
        Button_6:setTouchEnabled(false)
    else
        -- Text_9:setColor(cc.c3b(color_Type[11][1], color_Type[11][2], color_Type[11][3]))
        Button_6:setHighlighted(false)
        Button_6:setTouchEnabled(true)
    end
end


function GameAnnouncementListOne:updateDraw()
    local root = self.roots[1]
    local Text_9 = ccui.Helper:seekWidgetByName(root,"Text_9")
    local Image_1 = ccui.Helper:seekWidgetByName(root,"Image_1")
    if self._state_type == true then
        Image_1:setVisible(true)
    else
        Image_1:setVisible(false)
    end

    local splitStrForColor = zstring.split(self._title_type, "|")
    if #splitStrForColor > 2 then
        local temp_string = splitStrForColor[3]
        Text_9:setString(temp_string)
        --  DSC重塑使用UI控件的颜色
        if __lua_project_id == __lua_project_l_digital then
            --
        else
            self._color = tonumber(splitStrForColor[2]) + 1
            Text_9:setColor(cc.c3b(color_Type[self._color][1], color_Type[self._color][2], color_Type[self._color][3]))
        end
    else
        Text_9:setString(self._title_type)
    end
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

function GameAnnouncementListOne:init(title_type,index_type,state_type,notice_table)
    self._title_type = title_type
    self._index_type = index_type
    self._state_type = state_type
    self._notice_table = notice_table
    self:onInit()
    self:setContentSize(GameAnnouncementListOne.__size)
    return self
end

function GameAnnouncementListOne:onExit()
    cacher.freeRef(config_csb.cells.game_announcement.game_announcement_list_one, self.roots[1])
end