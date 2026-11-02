--------------------------------------------------------------------------------------------------------------
--  个人居所排行榜
--------------------------------------------------------------------------------------------------------------

PersonalFightRanking = class("PersonalFightRankingClass", Window)

local personal_fight_ranking_window_open_terminal = {
    _name = "personal_fight_ranking_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function (terminal, instance, params)
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("PersonalFightRankingClass") == nil then
                    fwin:open(PersonalFightRanking:new():init(),fwin._ui)
                end
            end
        end
        protocol_command.user_stronghold_view_score_rank.param_list = "0"
        NetworkManager:register(protocol_command.user_stronghold_view_score_rank.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local personal_fight_ranking_window_close_terminal = {
    _name = "personal_fight_ranking_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function (terminal, instance, params)
        fwin:close(fwin:find("PersonalFightRankingClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(personal_fight_ranking_window_open_terminal)
state_machine.add(personal_fight_ranking_window_close_terminal)
state_machine.init()

function PersonalFightRanking:ctor()
    self.super:ctor()
    self.roots = {}

    self._rank_type = 0             --当前显示的排行榜类型：1，全服，2：本服，3：帮派，4：积分奖励
    self._panel_list_view = nil     --排行榜信息显示区
    self._list_views = {}           --排行榜信息页面

    app.load("client.red_alert.personal_fight.PersonalFightRankingListView")
    app.load("client.red_alert.cells.personal_fight.personal_fight_ranking_cell")
    app.load("client.red_alert.cells.personal_fight.personal_fight_ranking_reward_cell")
    app.load("client.red_alert.utils.UserInfoWindow")

    local function init_personal_fight_ranking_terminal()
        -- 改变显示的排行榜类别
        local personal_fight_ranking_change_type_terminal = {
            _name = "personal_fight_ranking_change_type",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local rank_type = params._datas.rank_type
                if rank_type == 3 and zstring.tonumber(_ED.union.user_union_info.union_id) <= 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[157])
                    return
                end
                instance:updateDraw(rank_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新自己的排序信息
        local personal_fight_ranking_update_rank_terminal = {
            _name = "personal_fight_ranking_update_rank",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateRankInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(personal_fight_ranking_update_rank_terminal)
        state_machine.add(personal_fight_ranking_change_type_terminal)
        state_machine.init()    
    end

    init_personal_fight_ranking_terminal()
end

function PersonalFightRanking:init()
    self:onInit()
    return self
end

function PersonalFightRanking:onInit()
    local csbItem = csb.createNode(config_csb.palyer_build.palyer_build_ranking)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._panel_list_view = ccui.Helper:seekWidgetByName(root, "Panel_tank_tab")
    for i = 1, 4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_type_"..i), nil, 
        {
            terminal_name = "personal_fight_ranking_change_type", 
            terminal_state = 0,
            touch_scale = true,
            touch_scale_xy = 0.95, 
            rank_type = i,
        },
        nil,0)
    end

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank_close"), nil, 
    {
        terminal_name = "personal_fight_ranking_window_close", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)

    self:updateDraw(1)
end

function PersonalFightRanking:updateDraw(rank_type)
    local root = self.roots[1]
    for i = 1, 4 do
        local Button_type = ccui.Helper:seekWidgetByName(root, "Button_type_"..i)
        if i == rank_type then
            Button_type:setHighlighted(true)
        else
            Button_type:setHighlighted(false)
        end
    end

    if self._rank_type == rank_type then
        return
    end
    self._rank_type = rank_type

    --刷新排行榜信息显示
    for k, list_view in pairs(self._list_views) do
        list_view:setVisible(false)
    end

    if self._list_views[""..self._rank_type] == nil then
        self._list_views[""..self._rank_type] = state_machine.excute("personal_fight_ranking_list_view_create", 0, 
            {self._panel_list_view, self._rank_type})
        self._list_views[""..self._rank_type]:setVisible(true)
    else
        self._list_views[""..self._rank_type]:setVisible(true)
        self:updateRankInfo()
    end
end

-- 刷新自己的排名信息
function PersonalFightRanking:updateRankInfo()
    local root = self.roots[1]
    local Text_rank_me_t = ccui.Helper:seekWidgetByName(root, "Text_rank_me_t")                 -- 
    local Text_rank_me_n = ccui.Helper:seekWidgetByName(root, "Text_rank_me_n")                 -- 排名
    local Text_rank_integral_n = ccui.Helper:seekWidgetByName(root, "Text_rank_integral_n")     -- 积分
    Text_rank_me_n:setString("")
    Text_rank_integral_n:setString("")

    local nType = tonumber(self._rank_type) - 1

    if nType >= 0 and nType <= 2 then               -- 显示排名信息
        Text_rank_me_t:setString(tipStringInfo_rank_str[9])
        local rank = tonumber(_ED.user_stronghold_rank[""..nType])
        if rank <= 0 then
            Text_rank_me_n:setString(tipStringInfo_rank_str[8])
        else
            Text_rank_me_n:setString(""..rank)
        end
    elseif nType == 3 then                          -- 显示积分段位信息
        Text_rank_me_t:setString(tipStringInfo_rank_str[10])
        -- 显示我的段位信息
        local count = dms.count(dms["user_stronghold"])
        local title_name = ""
        for i = count, 1, -1 do
            local score = dms.int(dms["user_stronghold"], i, user_stronghold.score)
            if tonumber(_ED.personal_user_score) >= score then
                title_name = dms.string(dms["user_stronghold"], i, user_stronghold.title_name)
                break
            end
        end
        Text_rank_me_n:setString(title_name)
    end

    -- 显示积分
    Text_rank_integral_n:setString("".._ED.personal_user_score)
end

function PersonalFightRanking:onExit()
    state_machine.remove("personal_fight_ranking_update_rank")
    state_machine.remove("personal_fight_ranking_change_type")
end

function PersonalFightRanking:onEnterTransitionFinish()

end
