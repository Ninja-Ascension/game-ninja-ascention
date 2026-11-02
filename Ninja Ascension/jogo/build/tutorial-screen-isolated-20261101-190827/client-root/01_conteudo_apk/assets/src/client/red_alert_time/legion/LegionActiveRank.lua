-- ------------------------------------------------------------------------------------------------------------
--  说明：军团活跃排行
-- ------------------------------------------------------------------------------------------------------------
LegionActiveRank = class("LegionActiveRankClass", Window)

--打开界面
local legion_active_rank_open_terminal = {
    _name = "legion_active_rank_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = LegionActiveRank:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_active_rank_open_terminal)
state_machine.init()

function LegionActiveRank:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_shop_arrow_down = nil
    self._Image_shop_arrow_up = nil

    self._daily_active = nil

    local function init_legion_active_rank_terminal()
        local legion_active_rank_show_terminal = {
            _name = "legion_active_rank_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_active_rank_hide_terminal = {
            _name = "legion_active_rank_hide",
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

        local legion_active_rank_update_draw_terminal = {
            _name = "legion_active_rank_update_draw",
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

        state_machine.add(legion_active_rank_show_terminal)
        state_machine.add(legion_active_rank_hide_terminal)
        state_machine.add(legion_active_rank_update_draw_terminal)
        state_machine.init()
    end
    init_legion_active_rank_terminal()
end

function LegionActiveRank:refreshListView()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
end


function LegionActiveRank:onUpdateDraw()
    if self._daily_active == nil or self._daily_active ~= tonumber(_ED.union_active_info.daily_active) then
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    response.node:onUpdateInfo()
                end
            end
        end
        protocol_command.union_persion_list.param_list = _ED.union.union_info.union_id.."\r\n".._ED.union.union_info.union_camp
        NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, self, responseCallback, false, nil)
    else
        self:onUpdateInfo()
    end
end

function LegionActiveRank:onUpdateInfo()
    local root = self.roots[1]
    local Text_active_tank_me_n = ccui.Helper:seekWidgetByName(root, "Text_active_tank_me_n")
    local Text_player_lv_n = ccui.Helper:seekWidgetByName(root, "Text_player_lv_n")
    local Text_player_active_n = ccui.Helper:seekWidgetByName(root, "Text_player_active_n")
    local ListView_active_rank = ccui.Helper:seekWidgetByName(root, "ListView_active_rank")
    self._list_view = ListView_active_rank
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()
    Text_player_lv_n:setString("".._ED.user_info.user_grade)

    local arry = _ED.union.union_member_list_info
    local function sortfunction( a,b )
        return tonumber(a.daily_active) > tonumber(b.daily_active)
    end
    table.sort( arry, sortfunction )

    for i=1,tonumber(_ED.union.union_member_list_sum) do
        local cell = state_machine.excute("legion_active_rank_create_cell", 0, {arry[i], i})
        self._list_view:addChild(cell)
        if tonumber(arry[i].id) == tonumber(_ED.user_info.user_id) then
            Text_active_tank_me_n:setString(""..i)
            Text_player_active_n:setString(""..arry[i].daily_active)
            self._daily_active = tonumber(arry[i].daily_active)
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
end

function LegionActiveRank:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_shop_arrow_down:setVisible(true)
        else
            self._Image_shop_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_shop_arrow_up:setVisible(true)
        else
            self._Image_shop_arrow_up:setVisible(false)
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

function LegionActiveRank:onInit()
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_active_tab, 3))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_shop_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_active_rank_arrow_down")
    self._Image_shop_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_active_rank_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_shop_arrow_down:stopAllActions()
    self._Image_shop_arrow_up:stopAllActions()
    playActions(self._Image_shop_arrow_down)
    playActions(self._Image_shop_arrow_up)
    self._Image_shop_arrow_down:setVisible(false)
    self._Image_shop_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

function LegionActiveRank:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function LegionActiveRank:onExit()
    state_machine.remove("legion_active_rank_show")
    state_machine.remove("legion_active_rank_hide")
    state_machine.remove("legion_active_rank_update_draw")
end