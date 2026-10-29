-- ---------------------------
-- 工会战-战斗结束排行信息
-- ---------------------------
UnionFightingRank = class("UnionFightingRankClass", Window)

local union_fighting_rank_window_open_terminal = {
    _name = "union_fighting_rank_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("UnionFightingRankClass") == nil then
            local panel = UnionFightingRank:new():init(params)
            fwin:open(panel)
            return panel
        end
        return nil
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fighting_rank_window_open_terminal)
state_machine.init()

function UnionFightingRank:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._current_page = 0

    app.load("client.l_digital.cells.union.unionFighting.union_fighting_all_rank_union_cell")
    app.load("client.l_digital.cells.union.unionFighting.union_fighting_all_rank_person_cell")

    local function init_union_fighting_rank_terminal()
        -- 刷新界面
        local union_fighting_rank_update_draw_terminal = {
            _name = "union_fighting_rank_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 刷新界面
        local union_fighting_rank_request_refresh_terminal = {
            _name = "union_fighting_rank_request_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseUnionInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        else
                            response.node:updateDraw()
                        end
                    else
                        response.node:updateDraw()
                    end
                end
                protocol_command.union_warfare_manager.param_list = "3\r\n0\r\n0"
                NetworkManager:register(protocol_command.union_warfare_manager.code, nil, nil, nil, instance, responseUnionInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        state_machine.add(union_fighting_rank_update_draw_terminal)
        state_machine.add(union_fighting_rank_request_refresh_terminal)
        state_machine.init()
    end
    init_union_fighting_rank_terminal()
end

function UnionFightingRank:updateUnionRank()
    local root = self.roots[1]
    local ListView_legion_rank = ccui.Helper:seekWidgetByName(root,"ListView_legion_rank")
    self._union_list_view = ListView_legion_rank
    self._union_list_view:jumpToTop()

    local rank_type = self._current_page - 1
    local result = {}
    if _ED.union.union_fight_rank_info == nil 
        or _ED.union.union_fight_rank_info[""..rank_type] == nil 
        or _ED.union.union_fight_rank_info[""..rank_type].union_rank == nil 
        then
        for i = 1, 4 do
            local info = {}
            info.rank = i
            info.union_id = -1
            table.insert(result, info)
        end
    else
        result = _ED.union.union_fight_rank_info[""..rank_type].union_rank
    end

    local items = self._union_list_view:getItems()
    for k,v in pairs(items) do
        state_machine.excute("union_fighting_all_rank_union_cell_update_info", 0, {cell = v, index = k, info = result[k], show_score = false})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self._union_list_view:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("union_fighting_all_rank_union_cell_create", 0, {i, result[i], false})
            self._union_list_view:addChild(cell)
        end
    end

    self._union_list_view:requestRefreshView()
    self._union_list_view_poy = self._union_list_view:getInnerContainer():getPositionY()
    self._union_list_view_height = self._union_list_view:getInnerContainer():getPositionY()
end

function UnionFightingRank:updatePersonRank()
    local root = self.roots[1]
    local ListView_gr_rank = ccui.Helper:seekWidgetByName(root,"ListView_gr_rank")
    self._person_list_view = ListView_gr_rank
    self._person_list_view:jumpToTop()

    local rank_type = self._current_page - 1
    local result = {}
    if _ED.union.union_fight_rank_info == nil 
        or _ED.union.union_fight_rank_info[""..rank_type] == nil 
        or _ED.union.union_fight_rank_info[""..rank_type].person_rank == nil 
        then
        for i = 1, 4 do
            local info = {}
            info.rank = i
            info.user_id = -1
            table.insert(result, info)
        end
    else
        result = _ED.union.union_fight_rank_info[""..rank_type].person_rank
    end

    local items = self._person_list_view:getItems()
    for k,v in pairs(items) do
        state_machine.excute("union_fighting_all_rank_person_cell_update_info", 0, {cell = v, index = k, info = result[k], rank_type = rank_type})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self._person_list_view:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("union_fighting_all_rank_person_cell_create", 0, {i, result[i], rank_type})
            self._person_list_view:addChild(cell)
        end
    end

    self._person_list_view:requestRefreshView()
    self._person_list_view_poy = self._person_list_view:getInnerContainer():getPositionY()
    self._person_list_view_height = self._person_list_view:getInnerContainer():getPositionY()
end

function UnionFightingRank:updateUserInfo()
    local root = self.roots[1]
    local Text_gh_zj_n = ccui.Helper:seekWidgetByName(root,"Text_gh_zj_n")
    local Text_gh_jf_n = ccui.Helper:seekWidgetByName(root,"Text_gh_jf_n")
    local Text_gh_jf_w_n = ccui.Helper:seekWidgetByName(root,"Text_gh_jf_w_n")
    local Text_gh_jf_ls_n = ccui.Helper:seekWidgetByName(root,"Text_gh_jf_ls_n")
    local Text_gh_zj_t_0_1_1 = ccui.Helper:seekWidgetByName(root,"Text_gh_zj_t_0_1_1")

    local union_info = nil
    local person_info = nil

    if _ED.union.union_fight_rank_info ~= nil 
        and _ED.union.union_fight_rank_info[""..(self._current_page - 1)] ~= nil 
        and _ED.union.union_fight_rank_info[""..(self._current_page - 1)].union_rank ~= nil 
        then
        for k, v in pairs(_ED.union.union_fight_rank_info[""..(self._current_page - 1)].union_rank) do
            if tonumber(v.union_id) == tonumber(_ED.union.union_info.union_id) then
                union_info = v
                break   
            end
        end
    end

    -- if _ED.union.union_fight_rank_info ~= nil 
    --     and _ED.union.union_fight_rank_info[""..(self._current_page - 1)] ~= nil 
    --     and _ED.union.union_fight_rank_info[""..(self._current_page - 1)].person_rank ~= nil 
    --     then
    --     for k, v in pairs(_ED.union.union_fight_rank_info[""..(self._current_page - 1)].person_rank) do
    --         if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
    --             person_info = v
    --             break   
    --         end
    --     end
    -- end

    if union_info == nil then
        Text_gh_zj_n:setString(tipStringInfo_union_str[35])
        Text_gh_jf_n:setString(string.format(_new_interface_text[217], 0))
    else
        Text_gh_zj_n:setString(""..union_info.rank.._string_piece_info[317])
        Text_gh_jf_n:setString(string.format(_new_interface_text[217], union_info.score))
    end

    -- if person_info == nil then
    --     Text_gh_jf_w_n:setString(tipStringInfo_union_str[35])
    --     Text_gh_jf_ls_n:setString(string.format(_new_interface_text[218], 0))
    -- else
    --     Text_gh_jf_w_n:setString(""..person_info.rank.._string_piece_info[317])
    --     Text_gh_jf_ls_n:setString(string.format(_new_interface_text[218], person_info.win_times))
    -- end
    if _ED.union.union_fight_rank_info ~= nil then
        if _ED.union.union_fight_rank_info[""..(self._current_page - 1)] ~= nil and zstring.tonumber(_ED.union.union_fight_rank_info[""..(self._current_page - 1)].user_rank) > 0 then
            Text_gh_jf_w_n:setString("".._ED.union.union_fight_rank_info[""..(self._current_page - 1)].user_rank.._string_piece_info[317])
            Text_gh_jf_ls_n:setString(string.format(_new_interface_text[218], _ED.union.union_fight_rank_info[""..(self._current_page - 1)].win_times))
        else
            Text_gh_jf_w_n:setString(tipStringInfo_union_str[35])
            Text_gh_jf_ls_n:setString(string.format(_new_interface_text[218], 0))
        end
    else
        Text_gh_jf_w_n:setString(tipStringInfo_union_str[35])
        Text_gh_jf_ls_n:setString(string.format(_new_interface_text[218], 0))
    end

    if self._current_page == 1 then         -- 决赛结束
        Text_gh_zj_t_0_1_1:setString(tipStringInfo_union_str[96])
    else
        Text_gh_zj_t_0_1_1:setString(tipStringInfo_union_str[95])
    end
end

function UnionFightingRank:updateDraw()
    local root = self.roots[1]

    self._current_page = 0
    if tonumber(_ED.union.union_fight_battle_info.battle_times) == 5 then
        self._current_page = 1
    else
        self._current_page = tonumber(_ED.union.union_fight_battle_info.battle_times) + 1
    end
    self:updateUnionRank()
    self:updatePersonRank()
    self:updateUserInfo()
end

function UnionFightingRank:onUpdate(dt)
    if self._union_list_view ~= nil then
        local size = self._union_list_view:getContentSize()
        local posY = self._union_list_view:getInnerContainer():getPositionY()
        if self._union_list_view_height == 0 then
            self._union_list_view_height = posY
        end
        if self._union_list_view_poy ~= posY then
            self._union_list_view_poy = posY
            local items = self._union_list_view:getItems()
            if items[1] ~= nil then
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
    end

    if self._person_list_view ~= nil then
        local size = self._person_list_view:getContentSize()
        local posY = self._person_list_view:getInnerContainer():getPositionY()
        if self._person_list_view_height == 0 then
            self._person_list_view_height = posY
        end
        if self._person_list_view_poy ~= posY then
            self._person_list_view_poy = posY
            local items = self._person_list_view:getItems()
            if items[1] ~= nil then
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
    end
end

function UnionFightingRank:onEnterTransitionFinish()

end

function UnionFightingRank:onInit( )
    local csbItem = csb.createNode(string.format(config_csb.union_fight.sm_legion_ghz_tab, 5))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- self:updateDraw()
    state_machine.excute("union_fighting_rank_request_refresh")
end

function UnionFightingRank:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function UnionFightingRank:onExit()
    state_machine.remove("union_fighting_rank_update_draw")
    state_machine.remove("union_fighting_rank_request_refresh")
end
