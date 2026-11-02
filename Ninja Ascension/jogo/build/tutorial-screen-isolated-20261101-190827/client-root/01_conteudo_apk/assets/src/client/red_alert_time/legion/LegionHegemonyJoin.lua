-- ---------------------------
-- 军团争霸-报名
-- ---------------------------
LegionHegemonyJoin = class("LegionHegemonyJoinClass", Window)

local legion_hegemony_join_window_open_terminal = {
    _name = "legion_hegemony_join_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = LegionHegemonyJoin:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_hegemony_join_window_open_terminal)
state_machine.init()

function LegionHegemonyJoin:ctor()
    self.super:ctor()
    self.roots = {}

    self.listview = nil
    self.listview_poy = nil
    self.listview_height = 0
    self._Image_player_build_arrow_down = nil
    self._Image_player_build_arrow_up = nil

    self._Text_sign_up_open_state = nil
    self._tick_time = 0
    self._end_time = 0

    self._last_state = nil
    self._reconnect_state = false       

    local function init_legion_hegemony_join_terminal()
        -- 显示界面
        local legion_hegemony_join_show_terminal = {
            _name = "legion_hegemony_join_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                state_machine.excute("legion_hegemony_join_update_draw", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local legion_hegemony_join_hide_terminal = {
            _name = "legion_hegemony_join_hide",
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
        local legion_hegemony_join_update_draw_terminal = {
            _name = "legion_hegemony_join_update_draw",
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

        local legion_hegemony_join_request_terminal = {
            _name = "legion_hegemony_join_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                protocol_command.union_craft_init.param_list = ""
                NetworkManager:register(protocol_command.union_craft_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_hegemony_join_show_terminal)  
        state_machine.add(legion_hegemony_join_hide_terminal)
        state_machine.add(legion_hegemony_join_update_draw_terminal)
        state_machine.add(legion_hegemony_join_request_terminal)
        state_machine.init()
    end
    init_legion_hegemony_join_terminal()
end

function LegionHegemonyJoin:onHide()
    self:setVisible(false)
end

function LegionHegemonyJoin:onShow()
    self:setVisible(true)
end

function LegionHegemonyJoin:onUpdateDraw()
    local root = self.roots[1]
    local Text_not_sign_up_p = ccui.Helper:seekWidgetByName(root,"Text_not_sign_up_p")
    local Text_sign_up_people_n = ccui.Helper:seekWidgetByName(root,"Text_sign_up_people_n")
    local Text_sign_up_state = ccui.Helper:seekWidgetByName(root,"Text_sign_up_state")
    local Text_sign_up_open_state = ccui.Helper:seekWidgetByName(root,"Text_sign_up_open_state")
    local ListView_vs_troops = ccui.Helper:seekWidgetByName(root,"ListView_vs_troops")
    ListView_vs_troops:jumpToTop()
    ListView_vs_troops:removeAllItems()

    local owner_is_join = false
    local user_info = nil
    if zstring.tonumber(_ED.union.union_hegemony_sign_up_number) == 0 then
        Text_not_sign_up_p:setVisible(true)
    else
        Text_not_sign_up_p:setVisible(false)
        for k, v in pairs(_ED.union.union_hegemony_sign_up_list) do
            if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
                owner_is_join = true
                user_info = v
            end
        end

        local index = 1
        if user_info ~= nil then
            local cell = state_machine.excute("legion_hegemony_sign_up_cell_create", 0, {index, user_info})
            ListView_vs_troops:addChild(cell)
            index = index + 1
        end
        for k, v in pairs(_ED.union.union_hegemony_sign_up_list) do
            if tonumber(v.user_id) ~= tonumber(_ED.user_info.user_id) then
                local cell = state_machine.excute("legion_hegemony_sign_up_cell_create", 0, {index, v})
                ListView_vs_troops:addChild(cell)
                index = index + 1
            end
        end
    end

    ListView_vs_troops:requestRefreshView()
    self.listview = ListView_vs_troops
    self.listview_poy = ListView_vs_troops:getInnerContainer():getPositionY()
    self.listview_height = ListView_vs_troops:getInnerContainer():getPositionY()

    -- 报名状态
    local Text_sign_up_people_n = ccui.Helper:seekWidgetByName(root,"Text_sign_up_people_n")
    local Button_formation = ccui.Helper:seekWidgetByName(root,"Button_formation")
    local Button_text_formation = ccui.Helper:seekWidgetByName(root,"Button_text_formation")
    local Text_sign_up_state = ccui.Helper:seekWidgetByName(root,"Text_sign_up_state")
    self._Text_sign_up_open_state = ccui.Helper:seekWidgetByName(root,"Text_sign_up_open_state")
    Text_sign_up_people_n:setString("("..zstring.tonumber(_ED.union.union_hegemony_sign_up_number).."/".._ED.union.union_info.members..")")

    self._tick_time = 0
    local server_time = getCurrentGTM8Time()
    -- local time_info = zstring.split(dms.string(dms["union_fight_config"], 5, union_fight_config.param), "|")[2]
    -- time_info = zstring.split(time_info, ",")

    Button_formation:setBright(false)
    Button_formation:setTouchEnabled(false)
    if owner_is_join == false then
        Button_formation:setTitleText(tipStringInfo_campaign_info[29])
        Text_sign_up_state:setString(tipStringInfo_campaign_info[27])
        Text_sign_up_state:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    else
        Button_formation:setTitleText(tipStringInfo_campaign_info[30])
        Text_sign_up_state:setString(tipStringInfo_campaign_info[28])
        Text_sign_up_state:setColor(cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3]))
    end

    local state = tonumber(_ED.union.union_hegemony_info.state)
    self._tick_time = 0
    local push_info = _ED.mould_function_push_info["9"]
    if push_info ~= nil then
        state = tonumber(_ED.mould_function_push_info["9"].state)
        -- self._tick_time = tonumber(push_info.params) / 1000 - (os.time() - push_info.start_time)
        self._end_time = tonumber(push_info.params) / 1000 + push_info.start_time
    end
    self._tick_time = self._end_time - (os.time() + _ED.time_add_or_sub)
    if state == 0 then
        self._Text_sign_up_open_state:setString(tipStringInfo_campaign_info[20])
        Button_formation:setTitleText(tipStringInfo_campaign_info[29])
    elseif state == 1 then
        self._Text_sign_up_open_state:setString(string.format(tipStringInfo_campaign_info[21], exChangeTimeToString(self._tick_time)))
        Button_formation:setBright(true)
        Button_formation:setTouchEnabled(true)
    elseif state == 2 then
        self._Text_sign_up_open_state:setString(tipStringInfo_campaign_info[22])
    elseif state == 3 then
        self._Text_sign_up_open_state:setString("("..tipStringInfo_campaign_info[23]..")")
    else
        self._Text_sign_up_open_state:setString("("..tipStringInfo_campaign_info[24]..")")
    end
    if Button_text_formation ~= nil then
    	Button_text_formation:setString(Button_formation:getTitleText())
        Button_formation:setTitleText("")
    end

    if self._last_state == nil then
        self._last_state = state
    end
    if self._last_state ~= state then
        self._reconnect_state = false
    end
    self._last_state = state
end

function LegionHegemonyJoin:onUpdate(dt)
    if self._Text_sign_up_open_state ~= nil then
        -- self._tick_time = self._tick_time - dt
        self._tick_time = self._end_time - (os.time() + _ED.time_add_or_sub)
        if tonumber(_ED.union.union_hegemony_info.state) == 1
            or tonumber(_ED.union.union_hegemony_info.state) == 2 
            then
            if self._tick_time <= 0 then
                self._Text_sign_up_open_state:setString("")
                local state = tonumber(_ED.union.union_hegemony_info.state)
                if _ED.mould_function_push_info["9"] ~= nil then
                    if state ~= tonumber(_ED.mould_function_push_info["9"].state) then
                        state = tonumber(_ED.mould_function_push_info["9"].state)
                    end
                end
                if state ~= self._last_state then
                    self:onUpdateDraw()
                else
                    if self._tick_time <= -1 then
                        if self._reconnect_state == false then
                            self._reconnect_state = true
                            state_machine.excute("legion_hegemony_join_request", 0, "")
                        end
                    end
                end
            else
                self._Text_sign_up_open_state:setString(string.format(tipStringInfo_campaign_info[21], exChangeTimeToString(self._tick_time)))
            end
        end
    end
    if self.listview ~= nil and zstring.tonumber(_ED.union.union_hegemony_sign_up_number) > 0 then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_pepole_arrow_down:setVisible(true)
        else
            self._Image_pepole_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_pepole_arrow_up:setVisible(true)
        else
            self._Image_pepole_arrow_up:setVisible(false)
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

function LegionHegemonyJoin:onEnterTransitionFinish()

end

function LegionHegemonyJoin:onInit( )
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_hegemony_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_pepole_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_sign_up_arrow_down")
    self._Image_pepole_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_sign_up_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_pepole_arrow_down:stopAllActions()
    self._Image_pepole_arrow_up:stopAllActions()
    playActions(self._Image_pepole_arrow_down)
    playActions(self._Image_pepole_arrow_up)
    self._Image_pepole_arrow_down:setVisible(false)
    self._Image_pepole_arrow_up:setVisible(false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_participate"), nil, 
    {
        terminal_name = "legion_hegemony_other_join_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation"), nil, 
    {
        terminal_name = "formation_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
        form_type = 14,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sign_up_infor"), nil, 
    {
        terminal_name = "legion_hegemony_help_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        touch_black = true,
        infor_type = 1,
    }, nil, 1)

    self:onUpdateDraw()
end

function LegionHegemonyJoin:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function LegionHegemonyJoin:onExit()
    state_machine.remove("legion_hegemony_join_show")
    state_machine.remove("legion_hegemony_join_hide")
    state_machine.remove("legion_hegemony_join_update_draw")
end
