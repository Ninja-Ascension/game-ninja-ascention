-- ----------------------------------------------------------------------------------------------------
-- 说明：公告详情
-------------------------------------------------------------------------------------------------------
GameAnnouncementInfor = class("GameAnnouncementInforClass", Window)

local red_alert_time_game_announcement_infor_open_terminal = {
    _name = "red_alert_time_game_announcement_infor_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("GameAnnouncementInforClass")
        if nil == _homeWindow then
            fwin:open(GameAnnouncementInfor:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_game_announcement_infor_close_terminal = {
    _name = "red_alert_time_game_announcement_infor_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("GameAnnouncementInforClass")
        if nil ~= _homeWindow then
            fwin:close(fwin:find("GameAnnouncementInforClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_game_announcement_infor_open_terminal)
state_machine.add(red_alert_time_game_announcement_infor_close_terminal)
state_machine.init()
    
function GameAnnouncementInfor:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    app.load("client.red_alert_time.cells.mail.mail_other_text_cell")
    local function init_red_alert_time_game_announcement_infor_terminal()

    end
    
    init_red_alert_time_game_announcement_infor_terminal()
end

function GameAnnouncementInfor:init(params)
    self._datas = params._datas.cell._datas
    self:onInit()
    return self
end

function GameAnnouncementInfor:onUpdateDraw()
    local root = self.roots[1]
    local Text_announcement_infor_title = ccui.Helper:seekWidgetByName(root, "Text_announcement_infor_title")
    local ListView_announcement_infor = ccui.Helper:seekWidgetByName(root, "ListView_announcement_infor")
    self._list_view = ListView_announcement_infor
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()
    local texts_info = zstring.split(self._datas, "/r/n")
    local f,e = string.find(texts_info[1], "%%%C-%%")
    local name = "" 
    if f == nil or e == nil then
        name = texts_info[1]
    else
        name = string.sub(texts_info[1], f+4, e-1)
    end

    Text_announcement_infor_title:setString(name)
    local mail_dec = ""
    for i=2,#texts_info do
        mail_dec = mail_dec.."/r/n"..texts_info[i]
    end
    local cell = state_machine.excute("mail_other_text_cell", 0, {mail_dec, config_res.font.font_name})
    ListView_announcement_infor:addChild(cell)

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()

end

function GameAnnouncementInfor:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        -- local itemSize = items[1]:getContentSize()
        -- for i, v in pairs(items) do
        --     local tempY = v:getPositionY() + posY
        --     if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
        --         v:unload()
        --     else
        --         v:reload()
        --     end
        -- end
    end
end

function GameAnnouncementInfor:onInit()
    local csbGameAnnouncementInfor = csb.createNode(config_csb.game_announcement.game_announcement_infor)
    local root = csbGameAnnouncementInfor:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbGameAnnouncementInfor)
    
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_look_mail_close"), nil, 
    {
        terminal_name = "red_alert_time_game_announcement_infor_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_game_announcement_infor_close",
        terminal_state = 0,
    },
    nil,3)
    
    self:onUpdateDraw()
end

function GameAnnouncementInfor:onExit()

end