-----------------------------
-- 公会战排行排行榜主界面
-----------------------------
UnionFightingAllRank = class("UnionFightingAllRankClass", Window)

--打开界面
local union_fighting_all_rank_open_terminal = {
    _name = "union_fighting_all_rank_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local function responseUnionInitCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("UnionFightingAllRankClass") == nil then
                    fwin:open(UnionFightingAllRank:new():init(params), fwin._ui)        
                end
            end
        end
        protocol_command.union_warfare_manager.param_list = "3\r\n0\r\n0"
        NetworkManager:register(protocol_command.union_warfare_manager.code, nil, nil, nil, nil, responseUnionInitCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_fighting_all_rank_close_terminal = {
    _name = "union_fighting_all_rank_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("UnionFightingAllRankClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fighting_all_rank_open_terminal)
state_machine.add(union_fighting_all_rank_close_terminal)
state_machine.init()

function UnionFightingAllRank:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0

    app.load("client.l_digital.cells.union.unionFighting.union_fighting_all_rank_union_cell")
    app.load("client.l_digital.cells.union.unionFighting.union_fighting_all_rank_person_cell")

    local function init_union_fighting_all_rank_terminal()
        local union_fighting_all_rank_change_page_terminal = {
            _name = "union_fighting_all_rank_change_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(union_fighting_all_rank_change_page_terminal)

        state_machine.init()
    end
    init_union_fighting_all_rank_terminal()
end

function UnionFightingAllRank:updateUnionRank()
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

    local show_score = false
    if rank_type == 0 then
        show_score = true
    end

    local items = self._union_list_view:getItems()
    for k,v in pairs(items) do
        state_machine.excute("union_fighting_all_rank_union_cell_update_info", 0, {cell = v, index = k, info = result[k], show_score = show_score})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            self._union_list_view:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("union_fighting_all_rank_union_cell_create", 0, {i, result[i], show_score})
            self._union_list_view:addChild(cell)
        end
    end

    self._union_list_view:requestRefreshView()
    self._union_list_view_poy = self._union_list_view:getInnerContainer():getPositionY()
    self._union_list_view_height = self._union_list_view:getInnerContainer():getPositionY()
end

function UnionFightingAllRank:updatePersonRank()
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

function UnionFightingAllRank:updateUserInfo()
    local root = self.roots[1]
    local Text_ghz_rank_gh_n = ccui.Helper:seekWidgetByName(root,"Text_ghz_rank_gh_n")
    local Text_ghz_jf_n = ccui.Helper:seekWidgetByName(root,"Text_ghz_jf_n")
    local Text_ghz_rank_gr_n = ccui.Helper:seekWidgetByName(root,"Text_ghz_rank_gr_n")

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

    if _ED.union.union_fight_rank_info ~= nil 
        and _ED.union.union_fight_rank_info[""..(self._current_page - 1)] ~= nil 
        and _ED.union.union_fight_rank_info[""..(self._current_page - 1)].person_rank ~= nil 
        then
        for k, v in pairs(_ED.union.union_fight_rank_info[""..(self._current_page - 1)].person_rank) do
            if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
                person_info = v
                break   
            end
        end
    end

    if union_info == nil then
        Text_ghz_rank_gh_n:setString(_new_interface_text[156])
        Text_ghz_jf_n:setString(_new_interface_text[156])
    else
        Text_ghz_rank_gh_n:setString(union_info.rank)
        Text_ghz_jf_n:setString(union_info.score)
    end

    if person_info == nil then
        Text_ghz_rank_gr_n:setString(_new_interface_text[156])
    else
        Text_ghz_rank_gr_n:setString(person_info.rank)
    end
end

function UnionFightingAllRank:changeSelectPage( page )
    local root = self.roots[1]
    for i = 1, 5 do
        local Button_ghz_rank = ccui.Helper:seekWidgetByName(root,"Button_ghz_rank_"..i)
        local Image_rank_1 = ccui.Helper:seekWidgetByName(root,"Image_rank_"..i.."_1")
        local Image_rank_2 = ccui.Helper:seekWidgetByName(root,"Image_rank_"..i.."_2")
        if i == page then
            Button_ghz_rank:setHighlighted(true)
            Button_ghz_rank:setTouchEnabled(false)
            Image_rank_1:setVisible(false)
            Image_rank_2:setVisible(true)
        else    
            Button_ghz_rank:setHighlighted(false)
            Button_ghz_rank:setTouchEnabled(true)
            Image_rank_1:setVisible(true)
            Image_rank_2:setVisible(false)
        end
    end
    if page == self._current_page then
        return
    end
    self._current_page = page

    self:updateUnionRank()
    self:updatePersonRank()
    self:updateUserInfo()
end

function UnionFightingAllRank:onUpdate(dt)
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

function UnionFightingAllRank:init(params)
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function UnionFightingAllRank:onInit()
    local csbItem = csb.createNode(config_csb.union_fight.sm_legion_ghz_rank)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_wzzz_back"), nil, 
    {
        terminal_name = "union_fighting_all_rank_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    for i = 1, 5 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ghz_rank_"..i), nil, 
        {
            terminal_name = "union_fighting_all_rank_change_page", 
            terminal_state = 0, 
            _page = i,
        }, nil, 0)
    end

    self:changeSelectPage(1)

    state_machine.excute("sm_union_user_topinfo_open",0,self)
end

function UnionFightingAllRank:onEnterTransitionFinish()
    
end


function UnionFightingAllRank:onExit()
    state_machine.remove("union_fighting_all_rank_change_page")
end