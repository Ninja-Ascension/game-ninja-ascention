--------------------------------------------------------------------------------------------------------------
--  说明：阵营对决-个人事件
--------------------------------------------------------------------------------------------------------------
CampPkBattleMyEvent = class("CampPkBattleMyEventClass", Window)

--打开界面
local camp_pk_battle_my_event_open_terminal = {
	_name = "camp_pk_battle_my_event_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = CampPkBattleMyEvent:new():init(params)
        fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

local camp_pk_battle_my_event_close_terminal = {
    _name = "camp_pk_battle_my_event_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CampPkBattleMyEventClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(camp_pk_battle_my_event_open_terminal)
state_machine.add(camp_pk_battle_my_event_close_terminal)
state_machine.init()

function CampPkBattleMyEvent:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = 0

    self._tick_time = 0

    local function init_camp_pk_battle_my_event_terminal()
        local camp_pk_battle_my_event_update_terminal = {
            _name = "camp_pk_battle_my_event_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- instance:updateDraw()
                instance:updateInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_battle_my_event_update_tick_time_terminal = {
            _name = "camp_pk_battle_my_event_update_tick_time",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._tick_time = params
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(camp_pk_battle_my_event_update_terminal)
        state_machine.add(camp_pk_battle_my_event_update_tick_time_terminal)
        state_machine.init()
    end
    
    init_camp_pk_battle_my_event_terminal()
end

function CampPkBattleMyEvent:updateInfo( ... )
    if _ED.camp_pk_battle_event_info ~= nil 
        and _ED.camp_pk_battle_event_info["2"] ~= nil then
        local result = _ED.camp_pk_battle_event_info["2"]
        if nil ~= result then
            -- local items = self._list_view:getItems()
            -- for k,v in pairs(items) do
            --     local info = result[k]
            --     local describe = ""
            --     local params_str = ""
            --     local event_id = 0
            --     if info ~= nil then
            --         describe = _ED.camp_battle_event_info[""..info.event_id].info
            --         params_str = info.params
            --         event_id = info.event_id
            --     end
            --     state_machine.excute("camp_pk_event_text_cell_update_info", 0, {cell = v, index = k, info = describe, params_str = params_str, event_id = event_id})
            -- end

            -- if #items > #result then
            --     local index = 0
            --     for i=#result + 1, #items do
            --         self._list_view:removeItem(#items - index - 1)
            --         index = index + 1
            --     end
            -- elseif #items < #result then
            --     for i=#items + 1, #result do
            --         local info = result[i]
            --         local describe = _ED.camp_battle_event_info[""..info.event_id].info
            --         local cell = state_machine.excute("camp_pk_event_text_cell_create",0, {i, describe, info.params, info.event_id})
            --         self._list_view:addChild(cell)
            --     end
            -- end

            local items = self._list_view:getItems()
            if #items < #result then
                for i=#items + 1, #result do
                    local info = result[i]
                    local describe = _ED.camp_battle_event_info[""..info.event_id].info
                    local cell = state_machine.excute("camp_pk_event_text_cell_create",0, {i, describe, info.params, info.event_id})
                    self._list_view:addChild(cell)
                    table.insert(items, cell)
                end
            end

            if #items > 20 then
                for i=20 + 1, #items do
                    self._list_view:removeItem(0)
                    table.remove(result, 1, 1)
                end
            end
        
            self._list_view:requestRefreshView()
            self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
            self._list_view:jumpToBottom()
        end
    end
end

function CampPkBattleMyEvent:updateDraw()
    local root = self.roots[1]
    local ListView_camp_pk_battle = ccui.Helper:seekWidgetByName(root, "ListView_camp_pk_battle")
    local Text_camp_pk_battle_p = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_battle_p")
    Text_camp_pk_battle_p:setString("")
    ListView_camp_pk_battle:jumpToTop()
    ListView_camp_pk_battle:removeAllItems()

    if _ED.camp_pk_battle_event_info ~= nil then
        if _ED.camp_pk_battle_event_info["2"] ~= nil then
            -- for k,v in pairs(_ED.camp_pk_battle_event_info["2"]) do
            local list_info = _ED.camp_pk_battle_event_info["2"]
            local tcount = #list_info
            local s = math.max(0, tcount - 20) + 1
            for i = s, tcount do
                local k = i
                local v = list_info[i]
                local describe = _ED.camp_battle_event_info[""..v.event_id].info
                local cell = state_machine.excute("camp_pk_event_text_cell_create", 0, {k, describe, v.params, v.event_id})
                ListView_camp_pk_battle:addChild(cell)
            end
        end
    end

    ListView_camp_pk_battle:requestRefreshView()
    self._list_view = ListView_camp_pk_battle
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view:jumpToBottom()
end

function CampPkBattleMyEvent:updateTickTime()
    local root = self.roots[1]
    local Text_camp_pk_battle_p = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_battle_p")

    if self._tick_time <= 0 or tonumber(_ED.camp_pk_info.state) ~= 2 then
        Text_camp_pk_battle_p:setVisible(false)
        return
    end
    Text_camp_pk_battle_p:setVisible(true)
    Text_camp_pk_battle_p:removeAllChildren(true)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_campaign_pk_str[21], "fonts/simhei.ttf",22)
    _richText:pushBackElement(re1)  
    if _ED.camp_pk_user_info.camp_state == 0 then
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, red_alert_campaign_pk_str[22], "fonts/simhei.ttf",22)
        _richText:pushBackElement(re2)
    else
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]),255, red_alert_campaign_pk_str[23], "fonts/simhei.ttf",22)
        _richText:pushBackElement(re2)
    end
    local str3 = red_alert_campaign_pk_str[3]..","..limit_dekaron_tip_spacing[2]..exChangeNumTimeString(self._tick_time, 3)
    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, str3, "fonts/simhei.ttf",22)
    _richText:pushBackElement(re3) 
    _richText:setContentSize(cc.size(Text_camp_pk_battle_p:getContentSize().width,22))
    _richText:formatTextExt()
    _richText:setPosition(cc.p(Text_camp_pk_battle_p:getContentSize().width,Text_camp_pk_battle_p:getContentSize().height))
    Text_camp_pk_battle_p:addChild(_richText)
end

function CampPkBattleMyEvent:onUpdate(dt)
    self._tick_time = self._tick_time - dt
    self:updateTickTime()

    -- if self._list_view ~= nil then
    --     local size = self._list_view:getContentSize()
    --     local posY = self._list_view:getInnerContainer():getPositionY()
    --     if self._list_view_poy == posY then
    --         return
    --     end
    --     self._list_view_poy = posY
    --     local items = self._list_view:getItems()
    --     if items[1] == nil then
    --         return
    --     end
    --     local itemSize = items[1]:getContentSize()
    --     for i, v in pairs(items) do
    --         local tempY = v:getPositionY() + posY
    --         if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
    --             v:unload()
    --         else
    --             v:reload()
    --         end
    --     end
    -- end
end

function CampPkBattleMyEvent:onInit()
    local csbItem = csb.createNode(string.format(config_csb.cells.campaign.camp_pk_battle_cell, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:updateDraw()
end

function CampPkBattleMyEvent:onEnterTransitionFinish()

end

function CampPkBattleMyEvent:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function CampPkBattleMyEvent:onExit()
    state_machine.remove("camp_pk_battle_my_event_update")
    state_machine.remove("camp_pk_battle_my_event_update_tick_time")
end