-- ------------------------------------------------------------------------------------------------------------
--  说明：学霸之战排行
-- ------------------------------------------------------------------------------------------------------------
SuperScholarRank = class("SuperScholarRankClass", Window)

--打开界面
local super_scholar_rank_open_terminal = {
    _name = "super_scholar_rank_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = SuperScholarRank:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(super_scholar_rank_open_terminal)
state_machine.init()

function SuperScholarRank:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_super_scholar_rank_down = nil
    self._Image_super_scholar_rank_up = nil

    self._need_update = false

    local function init_super_scholar_rank_terminal()
        local super_scholar_rank_show_terminal = {
            _name = "super_scholar_rank_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                if instance._need_update == true then
                    instance._need_update = false
                    instance:onUpdateRankInfo()
                    instance:onUpdateListView()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local super_scholar_rank_hide_terminal = {
            _name = "super_scholar_rank_hide",
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

        local super_scholar_rank_update_draw_terminal = {
            _name = "super_scholar_rank_update_draw",
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

        local super_scholar_rank_update_rank_info_terminal = {
            _name = "super_scholar_rank_update_rank_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._need_update = true
                instance:onUpdateRankInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(super_scholar_rank_show_terminal)
        state_machine.add(super_scholar_rank_hide_terminal)
        state_machine.add(super_scholar_rank_update_draw_terminal)
        state_machine.add(super_scholar_rank_update_rank_info_terminal)
        state_machine.init()
    end
    init_super_scholar_rank_terminal()
end

function SuperScholarRank:onUpdateListView()
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                state_machine.excute("super_scholar_rank_update_draw", 0, "")
            end
        end
    end
    protocol_command.answer_init.param_list = ""
    NetworkManager:register(protocol_command.answer_init.code, nil, nil, nil, self, responseCallback, false, nil)
end

function SuperScholarRank:onUpdateRankInfo()
    local root = self.roots[1]
    -- 玩家自己的排名信息
    local Text_super_scholar_integral_n = ccui.Helper:seekWidgetByName(root, "Text_super_scholar_integral_n")
    local Text_super_scholar_integral_rank_n = ccui.Helper:seekWidgetByName(root, "Text_super_scholar_integral_rank_n")

    if _ED.answer_user_info == nil then
        Text_super_scholar_integral_n:setString("0")
        Text_super_scholar_integral_rank_n:setString(red_alert_time_str[112])
    else
        Text_super_scholar_integral_n:setString(_ED.answer_user_info.score)
        if tonumber(_ED.answer_user_info.rank) > 0 then
            Text_super_scholar_integral_rank_n:setString(_ED.answer_user_info.rank)
        else
            Text_super_scholar_integral_rank_n:setString(red_alert_time_str[112])
        end
    end
end

function SuperScholarRank:onUpdateDraw()
    local root = self.roots[1]

    local ListView_super_scholar_rank = ccui.Helper:seekWidgetByName(root, "ListView_super_scholar_rank")
    self._list_view = ListView_super_scholar_rank
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    if _ED.answer_rank_list_info ~= nil then
        for k, v in pairs(_ED.answer_rank_list_info) do
            local cell = state_machine.excute("super_scholar_rank_cell_create", 0, {k, v})
            self._list_view:addChild(cell)
        end
    end

    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()

    self:onUpdateRankInfo()
end

function SuperScholarRank:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_super_scholar_rank_down:setVisible(true)
        else
            self._Image_super_scholar_rank_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_super_scholar_rank_up:setVisible(true)
        else
            self._Image_super_scholar_rank_up:setVisible(false)
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

function SuperScholarRank:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.super_scholar_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_super_scholar_rank_down = ccui.Helper:seekWidgetByName(root, "Image_super_scholar_rank_down")
    self._Image_super_scholar_rank_up = ccui.Helper:seekWidgetByName(root, "Image_super_scholar_rank_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_super_scholar_rank_down:stopAllActions()
    self._Image_super_scholar_rank_up:stopAllActions()
    playActions(self._Image_super_scholar_rank_down)
    playActions(self._Image_super_scholar_rank_up)
    self._Image_super_scholar_rank_down:setVisible(false)
    self._Image_super_scholar_rank_up:setVisible(false)

    self:onUpdateDraw()
end

function SuperScholarRank:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function SuperScholarRank:onExit()
    state_machine.remove("super_scholar_rank_show")
    state_machine.remove("super_scholar_rank_hide")
    state_machine.remove("super_scholar_rank_update_draw")
    state_machine.remove("super_scholar_rank_update_rank_info")
end