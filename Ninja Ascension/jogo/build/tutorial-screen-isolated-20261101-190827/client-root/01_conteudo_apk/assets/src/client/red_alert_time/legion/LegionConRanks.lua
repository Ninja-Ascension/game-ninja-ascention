-- ---------------------------
-- 军团贡献排行
-- ---------------------------
LegionConRanks = class("LegionConRanksClass", Window)

local legion_con_ranks_window_open_terminal = {
    _name = "legion_con_ranks_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = LegionConRanks:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_con_ranks_window_open_terminal)
state_machine.init()

function LegionConRanks:ctor()
    self.super:ctor()
    self.roots = {}

    self.listview = nil
    self.listview_poy = nil
    self.listview_height = 0
    self._Image_player_build_arrow_down = nil
    self._Image_player_build_arrow_up = nil
	self._post = -1

    self._week_devote = nil

    local function init_legion_con_ranks_terminal()
        -- 显示界面
        local legion_con_ranks_show_terminal = {
            _name = "legion_con_ranks_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local legion_con_ranks_hide_terminal = {
            _name = "legion_con_ranks_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 刷新界面
        local legion_con_ranks_update_draw_terminal = {
            _name = "legion_con_ranks_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local posY = instance.listview_poy
                instance:onUpdateDraw()
                if math.abs(posY) > math.abs(instance.listview_height) then
                    posY = instance.listview_height
                end
                instance.listview:getInnerContainer():setPositionY(posY)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        state_machine.add(legion_con_ranks_show_terminal)  
        state_machine.add(legion_con_ranks_hide_terminal)
        state_machine.add(legion_con_ranks_update_draw_terminal)
        state_machine.init()
    end
    init_legion_con_ranks_terminal()
end

function LegionConRanks:onHide()
    self:setVisible(false)
end

function LegionConRanks:onShow()
    self:setVisible(true)
end

function LegionConRanks:onUpdateDraw()
    local root = self.roots[1]
    local Text_legion_tank_me_n = ccui.Helper:seekWidgetByName(root,"Text_legion_tank_me_n")
    local Text_player_lv = ccui.Helper:seekWidgetByName(root,"Text_player_lv")
    local Text_player_contribution_n = ccui.Helper:seekWidgetByName(root,"Text_player_contribution_n")
    Text_player_lv:setString(string.format(red_alert_all_str[117],_ED.user_info.user_grade))

    local ListView_legion_contribution = ccui.Helper:seekWidgetByName(root,"ListView_legion_contribution")
    ListView_legion_contribution:jumpToTop()

    if tonumber(_ED.union.union_member_list_sum) == nil then
        return
    end
    self._post = tonumber(_ED.union.user_union_info.union_post) 
    local arry = {}
    local week_devote = 0 
    local ranking = 0
    for k, v in pairs(_ED.union.union_member_list_info) do
        if tonumber(v.id) == tonumber(_ED.user_info.user_id) then
            if _ED.user_info.union_week_contribute ~= nil then
                v.week_devote = tonumber(_ED.user_info.union_week_contribute)
            end
            week_devote = v.week_devote
            break
        end
    end
    for k, v in pairs(_ED.union.union_member_list_info) do
        table.insert(arry, v)
    end

    local function sortfunction( a,b )
        local result = false
        if tonumber(a.week_devote) > tonumber(b.week_devote)  then
            return true
        end 
        return result
    end
    table.sort( arry, sortfunction )
    for k, v in pairs(arry) do
        v.rank = k
        if tonumber(v.id) == tonumber(_ED.user_info.user_id) then
            ranking = k
        end
    end
    if __lua_project_id == __lua_project_pacific_rim then
        local user_info = arry[ranking]
        table.remove(arry, ranking)
        table.insert(arry, 1, user_info)
    end

    local items = ListView_legion_contribution:getItems()
    for k,v in pairs(items) do
        state_machine.excute("legion_cotribution_rank_cell_update_info", 0, {cell = v, index = k, info_data = arry[k]})
    end

    if #items > #arry then
        local index = 0
        for i=#arry + 1, #items do
            ListView_legion_contribution:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #arry then
        for i=#items + 1, #arry do
            local cell = state_machine.excute("legion_cotribution_rank_create_cell", 0, {arry[i], i})
            ListView_legion_contribution:addChild(cell)
        end
    end

    Text_player_contribution_n:setString(week_devote)
    Text_legion_tank_me_n:setString(ranking)
    self._week_devote = week_devote

    ListView_legion_contribution:requestRefreshView()
    self.listview = ListView_legion_contribution
    self.listview_poy = ListView_legion_contribution:getInnerContainer():getPositionY()
    self.listview_height = ListView_legion_contribution:getInnerContainer():getPositionY()
end

function LegionConRanks:onUpdate(dt)
    if _ED.union.user_union_info ~= nil and _ED.union.user_union_info.union_post ~= nil then
        if self._post ~= -1 and tonumber(_ED.union.user_union_info.union_post) ~= self._post  then
            self._post = tonumber(_ED.union.user_union_info.union_post)
            self:onUpdateDraw()
        end
    end
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_contribution_arrow_down:setVisible(true)
        else
            self._Image_contribution_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_contribution_arrow_up:setVisible(true)
        else
            self._Image_contribution_arrow_up:setVisible(false)
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

function LegionConRanks:onEnterTransitionFinish()

end

function LegionConRanks:onInit( )
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_tab, 4))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_contribution_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_contribution_arrow_down")
    self._Image_contribution_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_contribution_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_contribution_arrow_down:stopAllActions()
    self._Image_contribution_arrow_up:stopAllActions()
    playActions(self._Image_contribution_arrow_down)
    playActions(self._Image_contribution_arrow_up)
    self._Image_contribution_arrow_down:setVisible(false)
    self._Image_contribution_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

function LegionConRanks:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function LegionConRanks:onExit()
    state_machine.remove("legion_con_ranks_show")
    state_machine.remove("legion_con_ranks_hide")
    state_machine.remove("legion_con_ranks_update_draw")
end
