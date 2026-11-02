--------------------------------------------------------------------------------------------------------------
--  说明：公告小标题
--------------------------------------------------------------------------------------------------------------
GameAnnouncementCell = class("GameAnnouncementCellClass", Window)
GameAnnouncementCell.__size = nil

--创建cell
local game_announcement_create_cell_terminal = {
    _name = "game_announcement_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = GameAnnouncementCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(game_announcement_create_cell_terminal)
state_machine.init()

function GameAnnouncementCell:ctor()
    self.super:ctor()
    self.roots = {}

  -- var 
  -- 小标题描述
  self._title_infor = nil
  -- 描述
  self._datas = nil

     -- Initialize game_announcement_cell state machine.
    local function init_game_announcement_cell_terminal()

        state_machine.init()
    end 
    -- call func game_announcement_cell create state machine.
    init_game_announcement_cell_terminal()

end




function GameAnnouncementCell:updateDraw()
    local root = self.roots[1]
    local Text_game_announcement_infor = ccui.Helper:seekWidgetByName(root,"Text_game_announcement_infor")
    local Image_game_announcement_box = ccui.Helper:seekWidgetByName(root,"Image_game_announcement_box")
    Text_game_announcement_infor:removeAllChildren(true)
    local texts_info = zstring.split(self._datas, "/r/n")
    local index = 0
    local font_name = Text_game_announcement_infor:getFontName()
    local _richText_combination = {}
    for i=1,#texts_info do
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)
        
        _richText:setAnchorPoint(cc.p(0, 0))
        local char_str = texts_info[i]
        local map = string.utf8.chars(char_str)
        local len_count = 0
        for j,v in pairs(map) do
            if string.len(v) == 1 then
                len_count = len_count + 1
            end
        end
        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            if len_count >= 15 then
                _richText:setContentSize(cc.size(GameAnnouncementCell.__size.width - 62.5, 0))
            else
                _richText:setContentSize(cc.size(GameAnnouncementCell.__size.width - 12, 0))
            end
        else
            if len_count >= 20 then
                _richText:setContentSize(cc.size(GameAnnouncementCell.__size.width - 20, 0))
            else
                _richText:setContentSize(cc.size(GameAnnouncementCell.__size.width, 0))
            end
        end
        local baseColor = cc.c3b(189, 206, 224)
        if __lua_project_id == __lua_project_l_naruto then
            baseColor = chat_rich_text_color[8]
        end
        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            baseColor = cc.c3b(71, 71, 71)
        end

        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital then
            baseColor = cc.c3b(45, 53, 88)
        end

        local rt, count, text = draw.richTextCollectionMethod(_richText, 
            char_str, 
            baseColor,
            baseColor,
            0, 
            0, 
            font_name, 
            20,
            chat_rich_text_color)
        _richText:formatTextExt()
        local rsize = _richText:getContentSize()
        _richText:setPositionY(Text_game_announcement_infor:getContentSize().height-index)
        Text_game_announcement_infor:addChild(_richText)
        index = index + rsize.height
        _richText_combination[i] = {}
        _richText_combination[i].t_object = _richText
        _richText_combination[i].height = index-rsize.height
    end
    local newHeight = 0
    newHeight = index+20*3/2
    if newHeight > GameAnnouncementCell.__size.height then
        newHeight = index+20*3/2
    else
        newHeight = GameAnnouncementCell.__size.height
    end
    root:setAnchorPoint(cc.p(0, 0))
    root:setContentSize(cc.size(GameAnnouncementCell.__size.width, newHeight))
    root:setPositionY(-20)
    if Image_game_announcement_box ~= nil then
        Image_game_announcement_box:setContentSize(cc.size(GameAnnouncementCell.__size.width, newHeight-10))
        Image_game_announcement_box:setPositionY(root:getContentSize().height+20)
    end
    for i, v in pairs( _richText_combination) do
        v.t_object:setPositionY(root:getContentSize().height-tonumber(v.height))
    end
    self:setContentSize( root:getContentSize())
end

function GameAnnouncementCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.game_announcement.game_announcement_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if GameAnnouncementCell.__size == nil then
        GameAnnouncementCell.__size = root:getContentSize()
    end

    root:setContentSize(GameAnnouncementCell.__size)

    -- fwin:addTouchEventListener(root, nil, 
    -- {
    --     terminal_name = "red_alert_time_game_announcement_infor_open",
    --     terminal_state = 0,
    --     touch_black = true,
    --     cell = self,
    -- },
    -- nil,1)

    self:updateDraw()

end

function GameAnnouncementCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function GameAnnouncementCell:init(params)
    -- self._title_infor = title_infor
    self._datas = params[1]
    self:onInit()
    return self
end

function GameAnnouncementCell:onExit()
    cacher.freeRef(config_csb.cells.game_announcement.game_announcement_cell, self.roots[1])
end