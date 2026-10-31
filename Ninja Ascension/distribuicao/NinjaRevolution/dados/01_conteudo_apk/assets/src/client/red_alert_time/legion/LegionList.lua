-- ------------------------------------------------------------------------------------------------------------
--  说明：加入军团列表
-- ------------------------------------------------------------------------------------------------------------
LegionList = class("LegionListClass", Window)

--打开界面
local legion_list_window_open_terminal = {
    _name = "legion_list_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionListClass") == nil then
            local _win = LegionList:new()
            _win:init()
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_list_window_close_terminal = {
    _name = "legion_list_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionListClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_list_window_open_terminal)
state_machine.add(legion_list_window_close_terminal)
state_machine.init()

function LegionList:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._text_field = nil
    self._check_box = nil

    self._Image_list_arrow_down = nil
    self._Image_list_arrow_up = nil

    self._is_filter = false      

    self._current_page = 0   

    app.load("client.red_alert_time.cells.arena.arena_rank_more_cell")
     -- Initialize alert_home state machine.
    local function init_legion_list_terminal()
        -- 搜索
        local legion_list_search_terminal = {
            _name = "legion_list_search",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:lookLegion()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_list_check_add_terminal = {
            _name = "legion_list_check_add",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._is_filter == true then
                    instance._is_filter = false
                else
                    instance._is_filter = true
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_list_update_draw_terminal = {
            _name = "legion_list_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local posY = instance._list_view_poy
                instance:onUpdateDraw()
                if math.abs(posY) > math.abs(instance._list_view_height) then
                    posY = instance._list_view_height
                end
                instance._list_view:getInnerContainer():setPositionY(posY)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_list_change_page_terminal = {
            _name = "legion_list_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changePgae(params._datas.page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_list_search_terminal)
        state_machine.add(legion_list_check_add_terminal)
        state_machine.add(legion_list_update_draw_terminal)
        state_machine.add(legion_list_change_page_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_list_terminal()
end

function LegionList:lookLegion()
    local str = zstring.exchangeTo(self._text_field:getString())

    local function responseUnionSearchCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateDraw()
            end
        end
    end
    _ED.union.union_list_info = {}
    protocol_command.union_search.param_list = str
    NetworkManager:register(protocol_command.union_search.code, nil, nil, nil, self, responseUnionSearchCallback, false, nil)
end

function LegionList:changePgae(page)
    if self._current_page == page then
        return
    end
    local root = self.roots[1]
    self._current_page = page

    local Button_legion_recommend = ccui.Helper:seekWidgetByName(root, "Button_legion_recommend")
    local Button_legion_list = ccui.Helper:seekWidgetByName(root, "Button_legion_list")

    if Button_legion_list ~= nil then
        if self._current_page == 1 then
            Button_legion_list:setHighlighted(true)
            Button_legion_list:setTouchEnabled(false)
        else
            Button_legion_list:setHighlighted(false)
            Button_legion_list:setTouchEnabled(true)
        end
    end
    if Button_legion_recommend ~= nil then
        if self._current_page == 2 then
            Button_legion_recommend:setHighlighted(true)
            Button_legion_recommend:setTouchEnabled(false)
        else
            Button_legion_recommend:setHighlighted(false)
            Button_legion_recommend:setTouchEnabled(true)
        end
    end

    self:onUpdateDraw()
end

-- 显示信息
function LegionList:onUpdateDraw()
    local root = self.roots[1]

    local ListView_legion_list = ccui.Helper:seekWidgetByName(root, "ListView_legion_list")
    self._list_view = ListView_legion_list
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()
    local width = ListView_legion_list:getContentSize().width

    if _ED.union.union_list_info ~= nil then
        local result_union = {}  
        if self._current_page == 1 then  
            for k, v in pairs(_ED.union.union_list_info) do
                if self._is_filter == true then             -- 过滤不能加入的公会
                    local can_add = true
                    local max_member = dms.int(dms["union_lobby_param"], tonumber(v.union_level), union_lobby_param.maxMember)
                    if tonumber(v.union_member) >= zstring.tonumber(max_member)
                        or tonumber(_ED.user_info.user_grade) < tonumber(v.need_level)
                        or tonumber(_ED.user_info.fighter_capacity) < tonumber(v.need_combat_force)
                        then
                        can_add = false
                    end
                    if can_add == true then
                        table.insert(result_union, v)
                    end
                else
                    table.insert(result_union, v)
                end
            end
        elseif self._current_page == 2 then  
            if _ED.union.recommend_union_list_info ~= nil then
                result_union = _ED.union.recommend_union_list_info
            end
        end

        -- local function sortfunction( a,b )
        --     return tonumber(a.union_level) > tonumber(b.union_level) 
        --         or (tonumber(a.union_level) == tonumber(b.union_level) and tonumber(a.union_fight) > tonumber(b.union_fight))
        -- end
        -- table.sort(result_union, sortfunction)

        for i, v in pairs(result_union) do
            if tonumber(v.union_level) > 0 then
                local cell = state_machine.excute("legion_list_cell_create", 0, {i, v})
                self._list_view:addChild(cell)
            end
        end

        if self._current_page == 1 then
            if #result_union < 1000 
                and #result_union > 0 
                and (#result_union % 20) == 0 
                then
                local cell = state_machine.excute("arena_rank_more_cell_create", 0, {#result_union + 1, 8, 1})
                self._list_view:addChild(cell)
            end
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self._list_view:requestRefreshView()
    self._Image_list_arrow_down:setVisible(false)
    self._Image_list_arrow_up:setVisible(false)
end

function LegionList:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_list_arrow_down:setVisible(true)
        else
            self._Image_list_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_list_arrow_up:setVisible(true)
        else
            self._Image_list_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
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

--初始化界面
function LegionList:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_list)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    local nameData = zstring.split(dms.string(dms["user_config"],36,user_config.param),",")
    local TextField_legion_name = ccui.Helper:seekWidgetByName(root, "TextField_legion_name")
    TextField_legion_name = draw:addEditBoxEx(TextField_legion_name, red_alert_time_str[91], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_legion_search"), tonumber(nameData[2]), cc.KEYBOARD_RETURNTYPE_DONE)     
    self._text_field = TextField_legion_name

    local CheckBox_legion_add = ccui.Helper:seekWidgetByName(root, "CheckBox_legion_add")
    self._check_box = CheckBox_legion_add
    self._check_box:setSelected(false)
    self._is_filter = false

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_establish_close"), nil, 
    {
        terminal_name = "legion_list_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    -- 搜索
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_search"), nil, 
    {
        terminal_name = "legion_list_search", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)   

    -- 过滤是否可加入
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_legion_add"), nil, 
    {
        terminal_name = "legion_list_check_add", 
        terminal_state = 0, 
        touch_black = true,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_list"), nil, 
    {
        terminal_name = "legion_list_change_page", 
        terminal_state = 0, 
        page = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_recommend"), nil, 
    {
        terminal_name = "legion_list_change_page", 
        terminal_state = 0, 
        page = 2,
    }, nil, 1)

    self._Image_list_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_list_arrow_down")
    self._Image_list_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_list_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_list_arrow_down:stopAllActions()
    self._Image_list_arrow_up:stopAllActions()
    playActions(self._Image_list_arrow_down)
    playActions(self._Image_list_arrow_up)
    self._Image_list_arrow_down:setVisible(false)
    self._Image_list_arrow_up:setVisible(false)

    if __lua_project_id == __lua_project_pacific_rim then
        self:changePgae(2)
    else
        self:changePgae(1)
    end
end

--初始化
function LegionList:init()
    self:setTouchEnabled(true)
    self:onInit()
end

--移除状态机
function LegionList:onExit()
    state_machine.remove("legion_list_search")
    state_machine.remove("legion_list_check_add")
    state_machine.remove("legion_list_update_draw")
    state_machine.remove("legion_list_change_page")
end