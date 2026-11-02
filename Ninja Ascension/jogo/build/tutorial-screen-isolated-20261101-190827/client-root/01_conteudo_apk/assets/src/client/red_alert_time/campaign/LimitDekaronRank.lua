-- ------------------------------------------------------------------------------------------------------------
--  说明：极限挑战排名
-- ------------------------------------------------------------------------------------------------------------
LimitDekaronRank = class("LimitDekaronRankClass", Window)

--打开界面
local limit_dekaron_rank_open_terminal = {
    _name = "limit_dekaron_rank_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = LimitDekaronRank:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(limit_dekaron_rank_open_terminal)
state_machine.init()

function LimitDekaronRank:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_dekarona_rank_arrow_down = nil
    self._Image_dekarona_rank_arrow_up = nil

    local function init_limit_dekaron_rank_terminal()
        local limit_dekaron_rank_show_terminal = {
            _name = "limit_dekaron_rank_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                protocol_command.extreme_rank_get.param_list = ""
                NetworkManager:register(protocol_command.extreme_rank_get.code, nil, nil, nil, instance, responseCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local limit_dekaron_rank_hide_terminal = {
            _name = "limit_dekaron_rank_hide",
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

        local limit_dekaron_rank_update_draw_terminal = {
            _name = "limit_dekaron_rank_update_draw",
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

        local limit_dekaron_rank_battle_rule_terminal = {
            _name = "limit_dekaron_rank_battle_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("expedition_rule_infor_window_open",0,6)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(limit_dekaron_rank_show_terminal)
        state_machine.add(limit_dekaron_rank_hide_terminal)
        state_machine.add(limit_dekaron_rank_update_draw_terminal)
        state_machine.add(limit_dekaron_rank_battle_rule_terminal)
        state_machine.init()
    end
    init_limit_dekaron_rank_terminal()
end

function LimitDekaronRank:onUpdateDraw()
    local root = self.roots[1]
    local Text_limit_dekarona_rank_me_n = ccui.Helper:seekWidgetByName(root, "Text_limit_dekarona_rank_me_n")
    local Text_limit_dekarona_best_time_n = ccui.Helper:seekWidgetByName(root, "Text_limit_dekarona_best_time_n")

    local ListView_limit_dekarona_rank = ccui.Helper:seekWidgetByName(root, "ListView_limit_dekarona_rank")
    self._list_view = ListView_limit_dekarona_rank
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    if _ED.user_extreme_rank_info == nil then
        return
    end
    function sortFunction(a, b)
        return tonumber(a.rank) < tonumber(b.rank)
    end
    table.sort(_ED.user_extreme_rank_info, sortFunction)
    local user_rank = 0
    local user_npc_count = 0
    local user_star_count = 0
    for k, v in pairs(_ED.user_extreme_rank_info) do
        if v.user_id == tonumber(_ED.user_info.user_id) then
            user_rank = v.rank
            user_npc_count = v.npc_count
            user_star_count = v.star_count
        end
        local cell = state_machine.excute("limit_dekarona_rank_cell_create", 0, {k, v})
        self._list_view:addChild(cell)
    end

    if user_rank == 0 then
        Text_limit_dekarona_rank_me_n:setString(red_alert_time_str[1])
        Text_limit_dekarona_rank_me_n:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
    else
        Text_limit_dekarona_rank_me_n:setString(user_rank)
        Text_limit_dekarona_rank_me_n:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    end
    Text_limit_dekarona_best_time_n:setString(string.format(red_alert_time_str[135],user_npc_count,user_star_count))

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function LimitDekaronRank:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_dekarona_rank_arrow_down:setVisible(true)
        else
            self._Image_dekarona_rank_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_dekarona_rank_arrow_up:setVisible(true)
        else
            self._Image_dekarona_rank_arrow_up:setVisible(false)
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

function LimitDekaronRank:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.limit_dekarona_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_limit_dekarona_infor"), nil, 
    {
        terminal_name = "limit_dekaron_rank_battle_rule", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    self._Image_dekarona_rank_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_dekarona_rank_arrow_down")
    self._Image_dekarona_rank_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_dekarona_rank_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_dekarona_rank_arrow_down:stopAllActions()
    self._Image_dekarona_rank_arrow_up:stopAllActions()
    playActions(self._Image_dekarona_rank_arrow_down)
    playActions(self._Image_dekarona_rank_arrow_up)
    self._Image_dekarona_rank_arrow_down:setVisible(false)
    self._Image_dekarona_rank_arrow_up:setVisible(false)

    -- self:onUpdateDraw()
    state_machine.excute("limit_dekaron_rank_show", 0, "")
end

function LimitDekaronRank:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function LimitDekaronRank:onExit()
    state_machine.remove("limit_dekaron_rank_show")
    state_machine.remove("limit_dekaron_rank_hide")
    state_machine.remove("limit_dekaron_rank_update_draw")
    state_machine.remove("limit_dekaron_rank_battle_rule")
end