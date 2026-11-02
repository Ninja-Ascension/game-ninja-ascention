-- ----------------------------------------------------------------------------------------------------
-- 说明：最新公告界面
-------------------------------------------------------------------------------------------------------
RedAlertTimeGameAnnouncement = class("RedAlertTimeGameAnnouncementClass", Window)

local red_alert_time_game_announcement_open_terminal = {
    _name = "red_alert_time_game_announcement_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("RedAlertTimeGameAnnouncementClass")
        if nil == _homeWindow then
            fwin:open(RedAlertTimeGameAnnouncement:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_game_announcement_close_terminal = {
    _name = "red_alert_time_game_announcement_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("RedAlertTimeGameAnnouncementClass")
        if nil ~= _homeWindow then
            fwin:close(fwin:find("RedAlertTimeGameAnnouncementClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_game_announcement_open_terminal)
state_machine.add(red_alert_time_game_announcement_close_terminal)
state_machine.init()
    
function RedAlertTimeGameAnnouncement:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    app.load("client.red_alert_time.cells.game_announcement.game_announcement_cell")
    app.load("client.red_alert_time.game_announcement.GameAnnouncementInfor")
    local function init_red_alert_time_game_announcement_terminal()

    end
    
    init_red_alert_time_game_announcement_terminal()
end

function RedAlertTimeGameAnnouncement:init()
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function RedAlertTimeGameAnnouncement:onUpdateDraw()
    local root = self.roots[1]

    local ListView_announcement = ccui.Helper:seekWidgetByName(root, "ListView_announcement")
    self._list_view = ListView_announcement
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()
    local mail_dec = "%|1|军团温馨提醒%/r/n指挥官您可以享受军团玩法啦!/r/n/r/n额外获得多种战斗加成,轻松提高战斗属性!/r/n%|2|★军团副本%/r/n挑战极限,获得大量经验奖励!/r/n★%|3|军团商店%/r/n超值稀有道具,免费兑换!/r/n★%|4|军团争霸%/r/n争夺全服第一军团,获得超高资源产量加成!/r/n★%|5|军团协防%/r/n团友互相协防,轻松抵御敌人来袭!"
    for i=1,5 do
        local cell = state_machine.excute("game_announcement_create_cell",0,{mail_dec})
        ListView_announcement:addChild(cell)
        self._cell_height = cell:getContentSize().height
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()

end

function RedAlertTimeGameAnnouncement:onUpdate(dt)
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

function RedAlertTimeGameAnnouncement:onInit()
    local csbRedAlertTimeGameAnnouncement = csb.createNode(config_csb.game_announcement.game_announcement)
    local root = csbRedAlertTimeGameAnnouncement:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbRedAlertTimeGameAnnouncement)

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
    
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_announcement_close"), nil, 
    {
        terminal_name = "red_alert_time_game_announcement_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
    
    self:onUpdateDraw()
end

function RedAlertTimeGameAnnouncement:onExit()

end