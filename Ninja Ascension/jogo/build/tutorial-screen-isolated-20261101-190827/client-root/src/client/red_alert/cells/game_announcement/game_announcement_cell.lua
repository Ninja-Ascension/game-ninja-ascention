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
        local title_infor = nil
        local content = nil
        if params ~= nil then
            title_infor = params[1]
            content = params[2]
        end
        local cell = GameAnnouncementCell:new()
        cell:init(title_infor,content)
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
  self._content = nil

     -- Initialize game_announcement_cell state machine.
    local function init_game_announcement_cell_terminal()

        state_machine.init()
    end 
    -- call func game_announcement_cell create state machine.
    init_game_announcement_cell_terminal()

end




function GameAnnouncementCell:updateDraw()
    local root = self.roots[1]
    local Text_infor_title = ccui.Helper:seekWidgetByName(root,"Text_infor_title")
    Text_infor_title:setString("")
    local Image_title_bg = ccui.Helper:seekWidgetByName(root,"Image_title_bg")
    Image_title_bg:setVisible(false)
    local Panel_infor = ccui.Helper:seekWidgetByName(root,"Panel_infor")
    Panel_infor:removeAllChildren(true)
    if self._title_infor == nil and self._content == nil then
        return
    end
    Image_title_bg:setVisible(true)
    Text_infor_title:setString(self._title_infor)
    local content_position = 0
    local index_max = 0
    local index_min = 0
    for i, str in ipairs(self._content) do
        local splitStrForColor = zstring.split(str, "|")
        local splitStrForContent = zstring.split(splitStrForColor[3], "%%/!")
        local splitStrForPosition = zstring.split(splitStrForContent[2], ",")
        splitStrForPosition[2] = splitStrForPosition[2] + (6*i)
        local temp_string = splitStrForContent[1]
        if i == 1 then 
            Text_infor_title:setString(temp_string)
        else
            if i == 2 then 
                content_position = tonumber(splitStrForPosition[2])
            end
            local temp_color = tonumber(splitStrForColor[2])
            local temp_position = cc.p(tonumber(splitStrForPosition[1]), tonumber(splitStrForPosition[2]))  
            local temp_image_position = cc.p(tonumber(splitStrForPosition[3]), tonumber(splitStrForPosition[4]))    
            local temp_image_path = splitStrForPosition[5]  
            local contentImage=nil

            local map = string.utf8.chars(temp_string)
            local len_size = 0
            for j,v in pairs(map) do
                local len = string.len(v)
                if string.len(v) > 1 then
                    len = string.len(v) - 1
                end
                len_size = len_size + len
            end
            if len_size > 40 and len_size <= 60 then
                index_max = i
            elseif len_size > 60 then
                index_min = i 
            end
            if index_max > 0 and index_max < i then
                splitStrForPosition[2] = splitStrForPosition[2] + 26
            elseif index_min > 0 and index_min < i then
                splitStrForPosition[2] = splitStrForPosition[2] + 6
            end
            local _richText_temp = ccui.RichText:create()
            _richText_temp:ignoreContentAdaptWithSize(false)
            _richText_temp:setContentSize(cc.size(Panel_infor:getContentSize().width ,splitStrForPosition[2] - content_position*2))
            _richText_temp:setPosition(cc.p(Panel_infor:getContentSize().width/2,splitStrForPosition[2]/2))
            local re_temp = ccui.RichElementText:create(1, cc.c3b(color_Type[29][1],color_Type[29][2],color_Type[29][3]), 
                255, temp_string, "fonts/simhei.ttf", 18)
            _richText_temp:pushBackElement(re_temp)
            Panel_infor:addChild(_richText_temp)
        end
    end

end

function GameAnnouncementCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.game_announcement.game_announcement_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if GameAnnouncementCell.__size == nil then
        GameAnnouncementCell.__size = root:getContentSize()
    end

    self:updateDraw()

end

function GameAnnouncementCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function GameAnnouncementCell:setSelfContentSize()
    --文字处理
    local content_position = 0
    local content_height = 0
    local index_max = 0
    local index_min = 0
    if self._title_infor ~= nil and self._content ~= nil then
        for i, str in ipairs(self._content) do
            local splitStrForColor = zstring.split(str, "|")
            local splitStrForContent = zstring.split(splitStrForColor[3], "%%/!")
            local splitStrForPosition = zstring.split(splitStrForContent[2], ",")
            local temp_string = splitStrForContent[1]
            splitStrForPosition[2] = splitStrForPosition[2] + (6*i)
            local len_size = 0
            if i == 1 then 
            else
                if i == 2 then 
                    content_position = splitStrForPosition[2]
                else
                    local text_height = tonumber(splitStrForPosition[2])
                    content_height = text_height - content_position
                end
                local map = string.utf8.chars(temp_string)
                for j,v in pairs(map) do
                    local len = string.len(v)
                    if string.len(v) > 1 then
                        len = string.len(v) - 1
                    end
                    len_size = len_size + len
                end
                if len_size > 40 and len_size <= 60 then
                    index_max = i
                elseif len_size > 60 then
                    index_min = i 
                end
            end
        end
        
        if #self._content ~= 4 then
            content_height = content_height - 20
        end
        if self._title_infor == 1 then
            content_height = 0 
        end
    else
        content_height = -20
    end
    self:setContentSize(cc.size(GameAnnouncementCell.__size.width,
        GameAnnouncementCell.__size.height - content_height))
end

function GameAnnouncementCell:init(title_infor,content)
    self._title_infor = title_infor
    self._content = content
    self:onInit()
    self:setSelfContentSize()
    return self
end

function GameAnnouncementCell:onExit()
    cacher.freeRef(config_csb.cells.game_announcement.game_announcement_cell, self.roots[1])
end