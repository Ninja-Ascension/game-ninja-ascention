-- ---------------------------
-- 工会战-战斗过程中
-- ---------------------------
UnionFightingInfo = class("UnionFightingInfoClass", Window)

local union_fighting_info_window_open_terminal = {
    _name = "union_fighting_info_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("UnionFightingInfoClass") == nil then
            local panel = UnionFightingInfo:new():init(params)
            fwin:open(panel)
            return panel
        end
        return nil
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fighting_info_window_open_terminal)
state_machine.init()

function UnionFightingInfo:ctor()
    self.super:ctor()
    self.roots = {}

    self._show_round = 0
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0
    self._tick_time = 0
    self._next_round_cell = nil

    local function init_union_fighting_info_terminal()
        local union_fighting_info_update_info_terminal = {
            _name = "union_fighting_info_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fighting_info_update_info_terminal)
        state_machine.init()
    end
    init_union_fighting_info_terminal()
end

function UnionFightingInfo:updateDraw()
    local root = self.roots[1]
    local ListView_ghz_name = ccui.Helper:seekWidgetByName(root, "ListView_ghz_name")
    -- self._list_view = ListView_ghz_name
    -- self._list_view:jumpToTop()
    -- self._list_view:removeAllItems()
    local myUnionCount = 0
    if _ED.union.union_fight_member_info ~= nil then
        local result = _ED.union.union_fight_member_info
        local function sortCount( a, b )
            return tonumber(a.current_num) > tonumber(b.current_num) or 
                (tonumber(a.current_num) == tonumber(b.current_num) and tonumber(a.total_num) > tonumber(b.total_num))
        end
        table.sort(result, sortCount)
        for index,info in pairs(result) do
            if tonumber(info.union_id) == tonumber(_ED.union.union_info.union_id) then
                myUnionCount = info.current_num
            end
            local items = ListView_ghz_name:getItems()
            for k,v in pairs(items) do
                state_machine.excute("union_fighting_union_cell_update", 0, {cell = v, info = result[k]})
            end

            if #items < #result then
                for i=#items + 1, #result do
                    local cell = state_machine.excute("union_fighting_union_cell_create",0, {result[i]})
                    ListView_ghz_name:addChild(cell)
                end
            end

            ListView_ghz_name:requestRefreshView()
            -- self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
            -- self._list_view_height = self._list_view:getInnerContainer():getPositionY()
            -- self._list_view:jumpToTop()
        end
    end
    local Text_ghz_infor_p = ccui.Helper:seekWidgetByName(root,"Text_ghz_infor_p")
    local Panel_legion = ccui.Helper:seekWidgetByName(root,"Panel_legion")
    if #ListView_ghz_name:getItems() == 0 then
        Text_ghz_infor_p:setVisible(true)
        Panel_legion:setVisible(false)
    else
        Text_ghz_infor_p:setVisible(false)
        Panel_legion:setVisible(true)
    end
    
    local Text_ghz_infor_t_1 = ccui.Helper:seekWidgetByName(root, "Text_ghz_infor_t_1")
    local Text_ghz_infor_t_2 = ccui.Helper:seekWidgetByName(root, "Text_ghz_infor_t_2")
    local Text_ghz_infor_t_3 = ccui.Helper:seekWidgetByName(root, "Text_ghz_infor_t_3")
    local Text_ghz_infor_n_1 = ccui.Helper:seekWidgetByName(root, "Text_ghz_infor_n_1")
    local Text_ghz_infor_n_2 = ccui.Helper:seekWidgetByName(root, "Text_ghz_infor_n_2")
    local Text_ghz_infor_n_3 = ccui.Helper:seekWidgetByName(root, "Text_ghz_infor_n_3")
    local Panel_ghz_infor_title = ccui.Helper:seekWidgetByName(root, "Panel_ghz_infor_title")
    Panel_ghz_infor_title:removeBackGroundImage()
    if tonumber(_ED.union.union_fight_battle_info.state) == 4 then
        Text_ghz_infor_t_1:setString(tipStringInfo_union_str[89])
        Text_ghz_infor_t_2:setString(tipStringInfo_union_str[90])
        Text_ghz_infor_t_3:setString(tipStringInfo_union_str[91])
        Panel_ghz_infor_title:setBackGroundImage("images/ui/text/GHZ_res/ghz_left_tab_title_2.png")
        if _ED.union.union_fight_union_info ~= nil then
            Text_ghz_infor_n_1:setString(myUnionCount)
            if _ED.union.union_fight_union_info.max_win_name == "" then
                Text_ghz_infor_n_2:setString(_new_interface_text[156])
            else
                Text_ghz_infor_n_2:setString(_ED.union.union_fight_union_info.max_win_name)
            end
            Text_ghz_infor_n_3:setString(_ED.union.union_fight_union_info.max_win_times)
        else
            Text_ghz_infor_n_1:setString(_new_interface_text[156])
            Text_ghz_infor_n_2:setString(_new_interface_text[156])
            Text_ghz_infor_n_3:setString(_new_interface_text[156])
        end
    else
        Panel_ghz_infor_title:setBackGroundImage("images/ui/text/GHZ_res/ghz_left_tab_title_1.png")
        Text_ghz_infor_t_1:setString(tipStringInfo_union_str[92])
        Text_ghz_infor_t_2:setString(tipStringInfo_union_str[93])
        Text_ghz_infor_t_3:setString(tipStringInfo_union_str[94])
        Text_ghz_infor_n_1:setString(_new_interface_text[156])
        Text_ghz_infor_n_2:setString(_new_interface_text[156])
        Text_ghz_infor_n_3:setString(myUnionCount)
    end
end

function UnionFightingInfo:onEnterTransitionFinish()

end

function UnionFightingInfo:onInit( )
    local csbItem = csb.createNode(string.format(config_csb.union_fight.sm_legion_ghz_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:updateDraw()
end

function UnionFightingInfo:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function UnionFightingInfo:onExit()
    state_machine.remove("union_fighting_info_update_info")
end
