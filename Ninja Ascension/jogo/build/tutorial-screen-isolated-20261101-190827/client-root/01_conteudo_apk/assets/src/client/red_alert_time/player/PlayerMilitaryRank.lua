--------------------------------------------------------------------------------------------------------------
--  军衔列表
--------------------------------------------------------------------------------------------------------------
PlayerMilitaryRank = class("PlayerMilitaryRankClass", Window)

--打开界面
local player_military_rank_window_open_terminal = {
    _name = "player_military_rank_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _wind = PlayerMilitaryRank:new()
        _wind:init(params)
        fwin:open(_wind, fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local player_military_rank_window_close_terminal = {
    _name = "player_military_rank_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerMilitaryRankClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(player_military_rank_window_open_terminal)
state_machine.add(player_military_rank_window_close_terminal)
state_machine.init()

function PlayerMilitaryRank:ctor()
    self.super:ctor()
    self.roots = {}
    
    --var 
    --列表
    self.listview = nil
    self.listview_poy = 0

    self.listview_height = 0
    self._Image_in_production_arrow_down = nil
    self._Image_in_production_arrow_up = nil

    app.load("client.red_alert_time.cells.player.player_military_rank_cell")
    app.load("client.red_alert_time.player.PlayerMilitaryHelpInfor")

    -- Initialize player_military_rank state machine.
    local function init_player_military_rank_terminal()
   
    end
    
    -- call func player_military_rank create state machine.
    init_player_military_rank_terminal()

end

function PlayerMilitaryRank:updateDraw()
    local root = self.roots[1]
    local Panel_military_icon_now = ccui.Helper:seekWidgetByName(root,"Panel_military_icon_now")
    local Text_military_lv_now_n = ccui.Helper:seekWidgetByName(root,"Text_military_lv_now_n")
    local Text_military_exploit_n =  ccui.Helper:seekWidgetByName(root,"Text_military_exploit_n")
    local Text_cumulative_military_exploit_n =  ccui.Helper:seekWidgetByName(root,"Text_cumulative_military_exploit_n")

    local military_info = _ED.base_military_info["".._ED.user_info.war_industry_level]
    Panel_military_icon_now:removeBackGroundImage()
    Panel_military_icon_now:setBackGroundImage(string.format(config_res.images.ui.props.props, military_info.pic))
    Text_military_lv_now_n:setString(military_info.name)
    Text_military_exploit_n:setString(_ED.user_info.current_war_industry)
    Text_cumulative_military_exploit_n:setString(_ED.user_info.total_war_industry)

    local ListView_military_rank = ccui.Helper:seekWidgetByName(root,"ListView_military_rank")
    ListView_military_rank:jumpToTop()
    ListView_military_rank:removeAllItems()

    local result = {}
    for k, v in pairs(_ED.base_military_info) do
        table.insert(result, v)
    end

    local function sortFunction(a, b)
        return a.id < b.id
    end
    table.sort(result, sortFunction)
    local index = 0 
    for k, v in pairs(result) do
        if k == tonumber(_ED.user_info.war_industry_level) then
            index = k
        end
        local cell = state_machine.excute("player_military_rank_cell_create", 0, {k, v})
        ListView_military_rank:addChild(cell)
    end
    ListView_military_rank:refreshView()
    ListView_military_rank:getInnerContainer():setPosition(cc.p(0,(index+1) * PlayerMilitaryRankCell.__size.height - ListView_military_rank:getInnerContainer():getContentSize().height))
    self.listview = ListView_military_rank
    self.listview_poy = self.listview:getInnerContainer():getPositionY()
    self.listview_height = self.listview:getInnerContainer():getPositionY()
end

function PlayerMilitaryRank:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_in_production_arrow_down:setVisible(true)
        else
            self._Image_in_production_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_in_production_arrow_up:setVisible(true)
        else
            self._Image_in_production_arrow_up:setVisible(false)
        end
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function PlayerMilitaryRank:onInit()
    local csbItem = csb.createNode(config_csb.player.player_military_rank)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_military_rank_close"), nil, 
    {
        terminal_name = "player_military_rank_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cumulative_military_infor"), nil, 
    {
        terminal_name = "player_military_help_infor_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    self._Image_in_production_arrow_down = ccui.Helper:seekWidgetByName(root,"Image_production_arrow_down")
    self._Image_in_production_arrow_up = ccui.Helper:seekWidgetByName(root,"Image_production_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_in_production_arrow_down:stopAllActions()
    self._Image_in_production_arrow_up:stopAllActions()
    playActions(self._Image_in_production_arrow_down)
    playActions(self._Image_in_production_arrow_up)
    self._Image_in_production_arrow_down:setVisible(false)
    self._Image_in_production_arrow_up:setVisible(false)

    self:updateDraw()
end

function PlayerMilitaryRank:onEnterTransitionFinish()
    
end

function PlayerMilitaryRank:init(params)
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function PlayerMilitaryRank:onExit()
   
end