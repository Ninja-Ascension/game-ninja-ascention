-----------------------------
--活动排行榜
-----------------------------
RedAlertTimeActivityRanking = class("RedAlertTimeActivityRankingClass", Window)

local red_alert_time_activity_ranking_window_open_terminal = {
    _name = "red_alert_time_activity_ranking_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeActivityRankingClass") then
            local panel = RedAlertTimeActivityRanking:new():init(params)
            fwin:open(panel, fwin._dview)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_activity_ranking_window_close_terminal = {
    _name = "red_alert_time_activity_ranking_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- fwin:close(fwin:find("WonderfulClass"))
        local activityWindow = fwin:find("RedAlertTimeActivityRankingClass")
        fwin:close(activityWindow)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_activity_ranking_window_open_terminal)
state_machine.add(red_alert_time_activity_ranking_window_close_terminal)
state_machine.init()

function RedAlertTimeActivityRanking:ctor()
    self.super:ctor()
    self.roots = {}
	self.activity_type = nil

    self.listview = nil
    self.listview_poy = nil
    self.listview_height = 0
    self._Image_act_rank_arrow_down = nil
    self._Image_act_rank_arrow_up = nil
	
	app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_activity_ring_cell")
end

function RedAlertTimeActivityRanking:onUpdateDraw()
    local root = self.roots[1]
	local ListView_act_rank = ccui.Helper:seekWidgetByName(root,"ListView_act_rank")
	ListView_act_rank:removeAllItems()
    local number = #_ED.activity_info[""..self._datas_id].activity_data[1]
    local count = zstring.split(_ED.activity_info[""..self._datas_id].activity_data[1][number].achieve_complete_count,"/")
    local index = 0
    local cellIndex = 1
    if self.datas ~= nil then
        for i, v in pairs(self.datas) do
            index = index + 1
            -- if index <= tonumber(count[2]) and v ~= nil then
        	    local cell = state_machine.excute("red_alert_time_activity_ring_cell",0,{v, self._datas_id, cellIndex})
                ListView_act_rank:addChild(cell)
                cellIndex = cellIndex + 1
            -- end
        end
    end
    ListView_act_rank:requestRefreshView()

    self.listview = ListView_act_rank
    self.listview_poy = ListView_act_rank:getInnerContainer():getPositionY()
    self.listview_height = ListView_act_rank:getInnerContainer():getPositionY()

    local Text_act_rank_type_t_1 = ccui.Helper:seekWidgetByName(root,"Text_act_rank_type_t_1")
    local Text_act_rank_type_t_2 = ccui.Helper:seekWidgetByName(root,"Text_act_rank_type_t_2")
    local Text_act_rank_name = ccui.Helper:seekWidgetByName(root,"Text_act_rank_name")
    local Text_act_rank_t = ccui.Helper:seekWidgetByName(root,"Text_act_rank_t")
    if self._datas_id == 52 then
        Text_act_rank_type_t_1:setString(activity_str_tip[86])
        Text_act_rank_type_t_2:setString(activity_str_tip[70])
    elseif self._datas_id == 53 then
        Text_act_rank_type_t_1:setString(activity_str_tip[86])
        Text_act_rank_type_t_2:setString(activity_str_tip[71])
    elseif self._datas_id == 51 then 
        Text_act_rank_type_t_1:setString(activity_str_tip[85])
        Text_act_rank_type_t_2:setString(activity_str_tip[72])
    elseif self._datas_id == 69 then
        Text_act_rank_type_t_1:setString(activity_str_tip[85])
        Text_act_rank_type_t_2:setString(activity_str_tip[73])
    elseif self._datas_id == 66 then
        Text_act_rank_type_t_1:setString(activity_str_tip[85])
        Text_act_rank_type_t_2:setString(activity_str_tip[74])
    elseif self._datas_id == 73 then
        Text_act_rank_type_t_1:setString(activity_str_tip[85])
        Text_act_rank_type_t_2:setString(activity_str_tip[84])
    elseif self._datas_id == 93 then
        Text_act_rank_type_t_1:setString(activity_str_tip[85])
        Text_act_rank_type_t_2:setString(activity_str_tip[110])
    elseif self._datas_id == 120 then
        Text_act_rank_type_t_1:setString(activity_str_tip[86])
        Text_act_rank_type_t_2:setString(activity_str_tip[185])
        Text_act_rank_name:setString(activity_str_tip[192])
        Text_act_rank_t:setString(activity_str_tip[193])
    elseif self._datas_id == 123 then
        Text_act_rank_type_t_1:setString(activity_str_tip[86])
        Text_act_rank_type_t_2:setString(activity_str_tip[186])
        Text_act_rank_name:setString(activity_str_tip[192])
        Text_act_rank_t:setString(activity_str_tip[193])
    end
end

function RedAlertTimeActivityRanking:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_act_rank_arrow_down:setVisible(true)
        else
            self._Image_act_rank_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_act_rank_arrow_up:setVisible(true)
        else
            self._Image_act_rank_arrow_up:setVisible(false)
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

function RedAlertTimeActivityRanking:onEnterTransitionFinish()

end

function RedAlertTimeActivityRanking:onInit( )
    local csbItem = csb.createNode(config_csb.activity.act_rank_window)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    self._Image_act_rank_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_act_rank_arrow_down")
    self._Image_act_rank_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_act_rank_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_act_rank_arrow_down:stopAllActions()
    self._Image_act_rank_arrow_up:stopAllActions()
    playActions(self._Image_act_rank_arrow_down)
    playActions(self._Image_act_rank_arrow_up)
    self._Image_act_rank_arrow_down:setVisible(false)
    self._Image_act_rank_arrow_up:setVisible(false)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_rank_close"), nil, 
    {
        terminal_name = "red_alert_time_activity_ranking_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_activity_ranking_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    if self._datas_id == 52 then        -- 战力
        if _ED.fight_ranks ~= nil and _ED.fight_ranks.other_user ~= nil then
            self.datas = _ED.fight_ranks.other_user
        end
    elseif self._datas_id == 53 then        -- 关卡
        if _ED.npc_rank ~= nil and _ED.npc_rank.other_user ~= nil then
            self.datas = _ED.npc_rank.other_user
        end
    elseif self._datas_id == 51 then        -- 军团等级
        if _ED.union ~= nil and _ED.union.rank_union_level_list ~= nil then
            self.datas = _ED.union.rank_union_level_list
        end
    elseif self._datas_id == 69 then        -- 军团贡献
        if _ED.union ~= nil and _ED.union.rank_union_con_list ~= nil then
            self.datas = _ED.union.rank_union_con_list
        end
    elseif self._datas_id == 66 then        -- 军团战力
        if _ED.union ~= nil and _ED.union.rank_union_list_info ~= nil then
            self.datas = _ED.union.rank_union_list_info
        end
    elseif self._datas_id == 73 then    -- 军团副本
        self.datas = _ED.activity_all_legion_copy
    elseif self._datas_id == 93 then    -- 军团总贡献
        self.datas = _ED.activity_legion_all_contribute
    elseif self._datas_id == 120 then    -- 充值排行
        self.datas = _ED.recharge_activity_rank
    elseif self._datas_id == 123 then    -- 消费排行
        self.datas = _ED.consume_activity_rank
    end

	self:onUpdateDraw()
end

function RedAlertTimeActivityRanking:init(params)
    self._datas_id = tonumber(params)
	self:onInit()
    return self
end

function RedAlertTimeActivityRanking:onExit()
    state_machine.remove("red_alert_time_activity_ranking_activity_codes")
end
