-----------------------------
--无双试炼排行
-----------------------------
TrialtowerRanking = class("TrialtowerRankingClass", Window)

local trialtower_ranking_window_open_terminal = {
    _name = "trialtower_ranking_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)     
        local function responseCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if nil == fwin:find("TrialtowerRankingClass") then
                    fwin:open(TrialtowerRanking:new():init(), fwin._ui)
                end
            end
        end
        NetworkManager:register(protocol_command.three_kings_get_rank_info.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local trialtower_ranking_window_close_terminal = {
    _name = "trialtower_ranking_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TrialtowerRankingClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(trialtower_ranking_window_open_terminal)
state_machine.add(trialtower_ranking_window_close_terminal)
state_machine.init()

function TrialtowerRanking:ctor()
    self.super:ctor()
    self.roots = {}

    --var 
    --列表
    self.listview = nil
    self.listview_PosY = nil

    -- load lua file
    app.load("client.red_alert.cells.campaign.trialtower.trialtower_ranking_cell")


end

function TrialtowerRanking:onUpdateDraw()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    ListView_1:removeAllItems()
    for i,v in pairs(_ED.trialtower_ranking_info.other_info) do
        local cell = state_machine.excute("trialtower_ranking_create_cell",0,{v,i})
        ListView_1:addChild(cell)
    end
   
    ListView_1:requestRefreshView()
    self.listview = ListView_1
    self.listview_PosY = self.listview:getInnerContainer():getPositionY()

    --绘制我的排名信息
    local Text_rank_number = ccui.Helper:seekWidgetByName(root,"Text_rank_number") -- 我的排名
    if zstring.tonumber(_ED.trialtower_ranking_info.my_rank) == 0 then
        Text_rank_number:setString(red_alert_all_str[120])
    else
        Text_rank_number:setString(string.format(red_alert_all_str[145],_ED.trialtower_ranking_info.my_rank))
    end

    local Text_progress_v = ccui.Helper:seekWidgetByName(root,"Text_progress_v") -- 我的进度
    Text_progress_v:setString(string.format(red_alert_all_str[118],_ED.trialtower_ranking_info.max_floor))
end

function TrialtowerRanking:onUpdate()
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_PosY == posY then
            return
        end
        self.listview_PosY = posY
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

function TrialtowerRanking:onEnterTransitionFinish()

end

function TrialtowerRanking:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.trialtower.trialtower_ranking)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "trialtower_ranking_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw() 
end

function TrialtowerRanking:init()
    self:onInit()
    return self
end

function TrialtowerRanking:onExit()
    
end
