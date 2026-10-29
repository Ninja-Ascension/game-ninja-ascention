--------------------------------------------------------------------------------------------------------------
--  守卫战战斗记录列表
--------------------------------------------------------------------------------------------------------------
GuardBattleRecordListview = class("GuardBattleRecordListviewClass", Window)

local guard_battle_record_listview_window_open_terminal = {
    _name = "guard_battle_record_listview_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = GuardBattleRecordListview:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(guard_battle_record_listview_window_open_terminal)
state_machine.init()

function GuardBattleRecordListview:ctor()
    self.super:ctor()
    self.roots = {}

    self._from_type = 0
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._list_jump_bottom = false

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    self._is_show_result = false

    -- Initialize guard_battle_record_listview state machine.
    local function init_guard_battle_record_listview_terminal()
        --显示
        local guard_battle_record_listview_window_show_terminal = {
            _name = "guard_battle_record_listview_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local list_view = params
                if list_view ~= nil and list_view.roots ~= nil and list_view.roots[1] ~= nil then
                    list_view:onShow()
                    list_view:addReportCell()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏
        local guard_battle_record_listview_window_hide_terminal = {
            _name = "guard_battle_record_listview_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local list_view = params
                if list_view ~= nil and list_view.roots ~= nil and list_view.roots[1] ~= nil then
                    list_view:onHide()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 刷新
        local guard_battle_record_listview_update_draw_terminal = {
            _name = "guard_battle_record_listview_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local list_view = params
                if list_view ~= nil and list_view.roots ~= nil and list_view.roots[1] ~= nil then
                    local posY = list_view._list_view_poy
                    list_view:onUpdateDraw()
                    if math.abs(posY) > math.abs(list_view._list_view_height) then
                        posY = list_view._list_view_height
                    end
                    list_view._list_view:getInnerContainer():setPositionY(posY)   
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_record_listview_add_report_cell_terminal = {
            _name = "guard_battle_record_listview_add_report_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local list_view = params
                if list_view ~= nil and list_view.roots ~= nil and list_view.roots[1] ~= nil then
                    list_view:addReportCell()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local guard_battle_record_listview_show_result_info_terminal = {
            _name = "guard_battle_record_listview_show_result_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local list_view = params
                if list_view ~= nil and list_view.roots ~= nil and list_view.roots[1] ~= nil then
                    list_view:addResultCell()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(guard_battle_record_listview_window_show_terminal)
        state_machine.add(guard_battle_record_listview_window_hide_terminal)
        state_machine.add(guard_battle_record_listview_update_draw_terminal)
        state_machine.add(guard_battle_record_listview_add_report_cell_terminal)
        state_machine.add(guard_battle_record_listview_show_result_info_terminal)
        state_machine.init()
    end
    init_guard_battle_record_listview_terminal()
end

--显示
function GuardBattleRecordListview:onShow()
   self:setVisible(true)
end

--隐藏
function GuardBattleRecordListview:onHide()
   self:setVisible(false)
end

-- 添加战斗结果
function GuardBattleRecordListview:addResultCell()
    if self._from_type == 1 or self._is_show_result == true or tonumber(_ED.guard_battle_stronghold_info.state) ~= 0 then
        return
    end
    if tonumber(_ED.guard_battle_stronghold_info.result) < 0 
        or (tonumber(_ED.guard_battle_stronghold_info.top_legion) ~= nil and tonumber(_ED.guard_battle_stronghold_info.top_legion) == -1)
        or (#self._list_view:getItems() == 0)
        then
    else
        local info = {
            param = "5|".._ED.guard_battle_stronghold_info.result..",".._ED.guard_battle_stronghold_info.top_legion
        }
        local index = #self._list_view:getItems() + 1
        local cell = state_machine.excute("legion_hegemony_fighting_cell_create", 0, {index, info, self._from_type + 3, false})
        self._list_view:addChild(cell)

        self._list_view:requestRefreshView()
        self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
        self._list_view_height = self._list_view:getInnerContainer():getPositionY()
        self._list_view:jumpToBottom()
        self._list_jump_bottom = true
        
        self._is_show_result = true
    end
end

function GuardBattleRecordListview:addReportCell( ... )
    local root = self.roots[1]
    local items = self._list_view:getItems()
    local index = #items
    if self._from_type == 1 then
        local info_list = _ED.city_resource_battle_report[209]
        if info_list ~= nil then
            for k,v in pairs(info_list) do
                if v.isShowed ~= true then
                    index = index + 1
                    local cell = state_machine.excute("legion_hegemony_fighting_cell_create", 0, {index, v, self._from_type + 3, false})
                    self._list_view:addChild(cell)
                end
            end
        end
    elseif self._from_type == 2 then
        local info_list = _ED.city_resource_battle_report[10006]
        if info_list ~= nil then
            for k,v in pairs(info_list) do
                if v.isShowed ~= true then
                    index = index + 1
                    local cell = state_machine.excute("legion_hegemony_fighting_cell_create", 0, {index, v, self._from_type + 3, false})
                    self._list_view:addChild(cell)
                end
            end
        end
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:jumpToBottom()
    self._list_jump_bottom = true

    local Text_expedition_record_p = ccui.Helper:seekWidgetByName(root, "Text_expedition_record_p")
    if #self._list_view:getItems() == 0 then
        Text_expedition_record_p:setVisible(true)
    else
        Text_expedition_record_p:setVisible(false)
    end
end

function GuardBattleRecordListview:onUpdateDraw()
    local root = self.roots[1]

    local ListView_expedition_record = ccui.Helper:seekWidgetByName(root, "ListView_expedition_record")
    self._list_view = ListView_expedition_record
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    local function sortFunction(a, b)
        return tonumber(a.time) < tonumber(b.time)
    end

    if self._from_type == 1 then
        local info_list = _ED.city_resource_battle_report[209]
        if info_list ~= nil then
            table.sort(info_list, sortFunction)
            for k,v in pairs(info_list) do
                if v.isShowed ~= true then
                    local cell = state_machine.excute("legion_hegemony_fighting_cell_create", 0, {k, v, self._from_type + 3, true})
                    self._list_view:addChild(cell)
                end
            end
        end
        self._list_jump_bottom = true
    elseif self._from_type == 2 then
        local info_list = _ED.city_resource_battle_report[10006]
        if info_list ~= nil then
            table.sort(info_list, sortFunction)
            for k,v in pairs(info_list) do
                if v.isShowed ~= true then
                    local cell = state_machine.excute("legion_hegemony_fighting_cell_create", 0, {k, v, self._from_type + 3, true})
                    self._list_view:addChild(cell)
                end
            end
        end
        self._list_jump_bottom = true
    end
    self._is_show_result = false
    self:addResultCell()

    self._list_view:requestRefreshView()

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    if self._list_jump_bottom == true then
        self._list_view:jumpToBottom()
    end

    local Text_expedition_record_p = ccui.Helper:seekWidgetByName(root, "Text_expedition_record_p")
    if #self._list_view:getItems() == 0 then
        Text_expedition_record_p:setVisible(true)
    else
        Text_expedition_record_p:setVisible(false)
    end
end

function GuardBattleRecordListview:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_arrow_down:setVisible(true)
        else
            self._Image_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_arrow_up:setVisible(true)
        else
            self._Image_arrow_up:setVisible(false)
        end

        if self._list_jump_bottom == false and self._list_view_poy == posY then
            return
        end
        if self._list_jump_bottom == true then
            self._list_jump_bottom = false
            self._list_view:jumpToBottom()
        end
        self._list_view_poy = posY
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

function GuardBattleRecordListview:onInit()
    local csbItem = csb.createNode(config_csb.campaign.guard_battle_record_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_guard_record_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_guard_record_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_arrow_down:stopAllActions()
    self._Image_arrow_up:stopAllActions()
    playActions(self._Image_arrow_down)
    playActions(self._Image_arrow_up)
    self._Image_arrow_down:setVisible(false)
    self._Image_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

function GuardBattleRecordListview:onEnterTransitionFinish()
    
end

function GuardBattleRecordListview:init(params)
    local rootWindow = params[1]
    self._from_type = params[2]         --1：个人记录，2：全服记录

    self._rootWindows = rootWindow

    self:onInit()
    return self
end

function GuardBattleRecordListview:onExit()
    state_machine.remove("guard_battle_record_listview_window_show")
    state_machine.remove("guard_battle_record_listview_window_hide")
    state_machine.remove("guard_battle_record_listview_update_draw")
    state_machine.remove("guard_battle_record_listview_add_report_cell")
end
