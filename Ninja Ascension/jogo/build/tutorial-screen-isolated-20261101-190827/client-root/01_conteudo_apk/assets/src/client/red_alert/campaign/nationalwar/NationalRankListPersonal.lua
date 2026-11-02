-- ----------------------------------------------------------------------------------------------------
-- 个人荣誉排行信息列表
-- ----------------------------------------------------------------------------------------------------
NationalRankListPersonal = class("NationalRankListPersonalClass", Window)

-- 创建列表
local national_rank_list_personal_window_open_terminal = {
    _name = "national_rank_list_personal_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local nationalRankListPersonalWindow = fwin:find("NationalRankListPersonalClass")
        if nil == nationalRankListPersonalWindow then
            fwin:open(NationalRankListPersonal:new():init(params), fwin._view)
        else
            state_machine.excute("national_rank_list_personal_window_update", 0, params)
            state_machine.excute("national_rank_list_personal_window_show", 0, params)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭列表
local national_rank_list_personal_window_close_terminal = {
    _name = "national_rank_list_personal_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalRankListPersonalClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_rank_list_personal_window_open_terminal)
state_machine.add(national_rank_list_personal_window_close_terminal)
state_machine.init()

function NationalRankListPersonal:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- load
    app.load("client.red_alert.cells.campaign.nationalwar.national_rank_cell")

    -- var 
    self._currentPageIndex = -1
    self._list_view  = nil
    self._list_view_posy = nil

    -- Initialize national rank list personal state machine.
    local function init_national_rank_list_personal_terminal()
        --show window
        local national_rank_list_personal_window_show_terminal = {
            _name = "national_rank_list_personal_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                if self._currentPageIndex == tonumber(_ED.war_rank_info.rankme.rank_camp) then
                    state_machine.excute("national_rank_me_window_show", 0, params)
                else
                    state_machine.excute("national_rank_me_window_hide", 0, params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --hide window
        local national_rank_list_personal_window_hide_terminal = {
            _name = "national_rank_list_personal_window_hide",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --update window
        local national_rank_list_personal_window_update_terminal = {
            _name = "national_rank_list_personal_window_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(national_rank_list_personal_window_show_terminal)
        state_machine.add(national_rank_list_personal_window_hide_terminal)
        state_machine.add(national_rank_list_personal_window_update_terminal)
        state_machine.init()     
    end
    -- call func init national rank list personal state machine.
    init_national_rank_list_personal_terminal()
end

function NationalRankListPersonal:onUpdateDraw(params)
    local pageIndex  = params._datas._pageIndex

    if pageIndex == self._currentPageIndex then
        return
    end
    -- print("___________________________________",pageIndex)

    local root = self.roots[1]

    -- 排名listview容器
    self._list_view = ccui.Helper:seekWidgetByName(root,"ListView_national_truce_rank")
    self._list_view:removeAllItems()

    -- 当前角色rank_me绘制
    if tonumber(_ED.war_rank_info.rankme.rank_camp) == pageIndex then
        -- 空cell
        local nulldata = {
            index = 1,             
            rank_lv =  0,
            rank_name =  "nulldata",
            rank_sex =  "man",
            rank_point =  "0",
            pageIndex = pageIndex
        }
        local cell_null = state_machine.excute("national_rank_cell_create", 0, {nulldata,0})
        cell_null:setVisible(false)

        self._list_view:addChild(cell_null)
        -- rank_me cell
        state_machine.excute("national_rank_me_window_show", 0, params)
    else
        state_machine.excute("national_rank_me_window_hide", 0, params)
    end

    local camp_index = "camp" .. pageIndex
    -- 绘制对应阵营所有cell
    for i,v in pairs(_ED.war_rank_info[camp_index]) do
        -- print("_ED.war_rank_info.rankme.rank_camp",_ED.war_rank_info.rankme.rank_camp)
        -- 阵营所属
        v.pageIndex = pageIndex     
        local cell = state_machine.excute("national_rank_cell_create", 0, {v,i})
        self._list_view:addChild(cell)       
    end

    self._currentPageIndex = pageIndex
    -- print("--------------------------------------",self._currentPageIndex)

    self._list_view_posy = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function NationalRankListPersonal:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_posy == posY then
            return
        end
        self._list_view_posy = posY
        local items = self._list_view:getItems()
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

function NationalRankListPersonal:onInit(params)
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_rank_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw(params)
end

function NationalRankListPersonal:init(params)
    self._rootWindows = params._datas._listView_rootWindows
    self:onInit(params)
    return self
end

function NationalRankListPersonal:onExit()
    state_machine.remove("national_rank_list_personal_window_show")
    state_machine.remove("national_rank_list_personal_window_hide")
    state_machine.remove("national_rank_list_personal_window_update")
end

