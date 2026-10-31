--------------------------------------------------------------------------------------------------------------
--  说明：叛军出没-叛军
--------------------------------------------------------------------------------------------------------------
RebelHauntList = class("RebelHauntListClass", Window)

--打开界面
local rebel_haunt_list_open_terminal = {
	_name = "rebel_haunt_list_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = RebelHauntList:new():init(params)
		fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rebel_haunt_list_open_terminal)
state_machine.init()

function RebelHauntList:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._current_page = 0
    self._buttons = {}
    self._pages = {}
    self._Text_rebel_haunt_time_n = nil
    self._tick_time = 0

    self._show_soild_time = 0
    self._show_boss_time = 0

    local function init_rebel_haunt_list_terminal()
        local rebel_haunt_list_show_terminal = {
            _name = "rebel_haunt_list_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(true)
                    instance:changeSelectPage(1)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local rebel_haunt_list_hide_terminal = {
            _name = "rebel_haunt_list_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local rebel_haunt_list_update_terminal = {
            _name = "rebel_haunt_list_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateDraw()
                    local page = instance._current_page
                    instance._current_page = 0
                    instance:changeSelectPage(page)
                    instance:onUpdateDrawPage()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local rebel_haunt_list_open_rule_terminal = {
            _name = "rebel_haunt_list_open_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("expedition_rule_infor_window_open",0,5)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local rebel_haunt_list_change_page_terminal = {
            _name = "rebel_haunt_list_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:changeSelectPage(params._datas._page)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(rebel_haunt_list_show_terminal)
        state_machine.add(rebel_haunt_list_hide_terminal)
        state_machine.add(rebel_haunt_list_update_terminal)
        state_machine.add(rebel_haunt_list_open_rule_terminal)
        state_machine.add(rebel_haunt_list_change_page_terminal)
        state_machine.init()
    end
    
    init_rebel_haunt_list_terminal()
end

function RebelHauntList:updateButtonInfo()
    for k,v in pairs(self._button_info) do
        local info = _ED.user_rebel_haunt_list_info[""..(k - 1)]
        local current_count = 0
        local max_count = 0
        if info ~= nil then
            for k,v in pairs(info) do
                if tonumber(v._kill_name) == -1 then
                    current_count = current_count + 1
                else
                end
                max_count = max_count + 1
            end

            v:removeAllChildren(true)
            local _richText_2 = ccui.RichText:create()
            _richText_2:ignoreContentAdaptWithSize(false) 
            local color = cc.c3b(color_Type[k + 1][1], color_Type[k + 1][2], color_Type[k + 1][3])
            local re1 = ccui.RichElementText:create(1, color, 255, tipStringInfo_campaign_info[k], "fonts/simhei.ttf", 22)
            _richText_2:pushBackElement(re1)
            color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
            local re1_1 = ccui.RichElementText:create(1, color, 255, "("..current_count.."/"..max_count..")", "fonts/simhei.ttf", 22)
            _richText_2:pushBackElement(re1_1)
            _richText_2:setContentSize(cc.size(200, 55))
            _richText_2:setPosition(cc.p(150,0))
            v:addChild(_richText_2)
        end
    end
end

function RebelHauntList:updateDraw()
    local root = self.roots[1]
    self._tick_time = 0
    local time_info = zstring.split(dms.string(dms["rebel_haunt_config"], 1, rebel_haunt_config.param), ",")
    local show_time_info = zstring.split(dms.string(dms["rebel_haunt_config"], 3, rebel_haunt_config.param), ",")
    local max_time = dms.int(dms["rebel_haunt_config"], 2, rebel_haunt_config.param)
    self._show_soild_time = max_time - tonumber(show_time_info[2])
    self._show_boss_time = max_time - tonumber(show_time_info[3])
    local server_time = getCurrentGTM8Time()
    if _ED.user_rebel_haunt_state == 1 then
        for k,v in pairs(time_info) do
            local info = zstring.split(v, ":")
            if server_time.hour >= tonumber(info[1]) and server_time.hour <= tonumber(info[1]) + max_time/3600 then
                self._tick_time = max_time - (server_time.hour - tonumber(info[1])) * 3600
                 - (server_time.min - tonumber(info[2])) * 60 - (server_time.sec - tonumber(info[3]))
            end
        end
    end
    self:updateButtonInfo()
    local Text_rebel_haunt_attack_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_haunt_attack_n")
    local Text_rebel_show_time_t = ccui.Helper:seekWidgetByName(root, "Text_rebel_show_time_t")
    local Text_rebel_show_time_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_show_time_n")
    
    local max_times = dms.int(dms["rebel_haunt_config"], 9, rebel_haunt_config.param)
    Text_rebel_haunt_attack_n:setString(_ED.user_rebel_haunt_user_info.today_kill_count.."/"..max_times)

    self:updateStateInfo()
end

function RebelHauntList:updateStateInfo( ... )
    local root = self.roots[1]
    local Text_rebel_haunt_state_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_haunt_state_n")
    local Text_rebel_haunt_time_t = ccui.Helper:seekWidgetByName(root, "Text_rebel_haunt_time_t")
    local Text_rebel_show_time_t = ccui.Helper:seekWidgetByName(root, "Text_rebel_show_time_t")
    local Text_rebel_show_time_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_show_time_n")

    self._Text_rebel_haunt_time_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_haunt_time_n")
    if _ED.user_rebel_haunt_state == 1 then
        Text_rebel_haunt_state_n:setString(tipStringInfo_campaign_info[12])
        Text_rebel_haunt_time_t:setVisible(true)
        self._Text_rebel_haunt_time_n:setString(exChangeTimeToString(self._tick_time))
        if self._tick_time - self._show_soild_time > 0 then
            Text_rebel_show_time_t:setString(tipStringInfo_campaign_info[2]..tipStringInfo_campaign_info[32])
            Text_rebel_show_time_n:setString(exChangeTimeToString(self._tick_time - self._show_soild_time))
        elseif self._tick_time - self._show_boss_time > 0 then
            Text_rebel_show_time_t:setString(tipStringInfo_campaign_info[3]..tipStringInfo_campaign_info[32])
            Text_rebel_show_time_n:setString(exChangeTimeToString(self._tick_time - self._show_boss_time))
        else
            Text_rebel_show_time_t:setString("")
            Text_rebel_show_time_n:setString("")
        end
    else
        Text_rebel_haunt_state_n:setString(tipStringInfo_campaign_info[11])
        Text_rebel_haunt_time_t:setVisible(false)
        self._Text_rebel_haunt_time_n:setString("")
        Text_rebel_show_time_t:setString("")
        Text_rebel_show_time_n:setString("")
    end
end

function RebelHauntList:onUpdateDrawPage()
    for i, page in pairs(self._pages) do 
        state_machine.excute("rebel_haunt_list_info_update", 0, page)
    end
end

function RebelHauntList:changeSelectPage(page)
    local root = self.roots[1]
    local Panel_rebel_soldier_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_rebel_soldier_tab_box")
    for k,v in pairs(self._buttons) do
        if page == k then
            v:setHighlighted(true)
        else
            v:setHighlighted(false)
        end
    end
    if page == self._current_page then
        return
    end
    self._current_page = page
    for k,v in pairs(self._pages) do
        v:setVisible(false)
    end
    if self._pages[""..page] == nil then
        self._pages[""..page] = state_machine.excute("rebel_haunt_list_info_open", 0, {Panel_rebel_soldier_tab_box, page})
    else
        self._pages[""..page]:setVisible(true)
    end
end

function RebelHauntList:onUpdate( dt )
    local root = self.roots[1]

    if _ED.user_rebel_haunt_state == 1 then
        self._tick_time = self._tick_time - dt
        if self._tick_time <= 0 then
            self._tick_time = 0
        end
        if self._Text_rebel_haunt_time_n ~= nil then
            self._Text_rebel_haunt_time_n:setString(exChangeTimeToString(self._tick_time))
            if self._tick_time <= 0 then
                self:updateStateInfo()
            end
            
            local Text_rebel_show_time_t = ccui.Helper:seekWidgetByName(root, "Text_rebel_show_time_t")
            local Text_rebel_show_time_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_show_time_n")
            if self._tick_time - self._show_soild_time > 0 then
                Text_rebel_show_time_t:setString(tipStringInfo_campaign_info[2]..tipStringInfo_campaign_info[32])
                Text_rebel_show_time_n:setString(exChangeTimeToString(self._tick_time - self._show_soild_time))
            elseif self._tick_time - self._show_boss_time > 0 then
                Text_rebel_show_time_t:setString(tipStringInfo_campaign_info[3]..tipStringInfo_campaign_info[32])
                Text_rebel_show_time_n:setString(exChangeTimeToString(self._tick_time - self._show_boss_time))
            else
                Text_rebel_show_time_t:setString("")
                Text_rebel_show_time_n:setString("")
            end
        end
    end
end

--初始化
function RebelHauntList:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.rebel_haunt_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rebel_haunt_infor"), nil, 
    {
        terminal_name = "rebel_haunt_list_open_rule", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    self._buttons = {ccui.Helper:seekWidgetByName(root, "Button_rebel_haunt_soldier"),
                    ccui.Helper:seekWidgetByName(root, "Button_rebel_haunt_mercenary"),
                    ccui.Helper:seekWidgetByName(root, "Button_rebel_haunt_leader")}

    self._button_info = {ccui.Helper:seekWidgetByName(root, "Text_rebel_haunt_soldier"),
                ccui.Helper:seekWidgetByName(root, "Text_rebel_haunt_mercenary"),
                ccui.Helper:seekWidgetByName(root, "Text_rebel_haunt_leader")}

    for k,v in pairs(self._buttons) do
        fwin:addTouchEventListener(v, nil, 
        {
            terminal_name = "rebel_haunt_list_change_page", 
            terminal_state = 0, 
            _page = k,
        }, nil, 1)
    end

    self:updateDraw()
    self:changeSelectPage(1)
end

function RebelHauntList:onEnterTransitionFinish()

end

function RebelHauntList:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function RebelHauntList:onExit()
    state_machine.remove("rebel_haunt_list_show")
    state_machine.remove("rebel_haunt_list_hide")
    state_machine.remove("rebel_haunt_list_update")
    state_machine.remove("rebel_haunt_list_open_rule")
    state_machine.remove("rebel_haunt_list_change_page")
end