-----------------------------
--个人战报列表
-----------------------------
NationalWarMyFightInfo = class("NationalWarMyFightInfoClass", Window)

local national_war_my_fight_info_window_open_terminal = {
    _name = "national_war_my_fight_info_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalWarMyFightInfoClass") == nil then
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    fwin:open(NationalWarMyFightInfo:new():init(),fwin._ui)
                end
            end   
            NetworkManager:register(protocol_command.warfare_get_my_fight_info.code, nil, nil, nil,nil, responseCallback, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_my_fight_info_window_close_terminal = {
    _name = "national_war_my_fight_info_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarMyFightInfoClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(national_war_my_fight_info_window_open_terminal)
state_machine.add(national_war_my_fight_info_window_close_terminal)
state_machine.init()

function NationalWarMyFightInfo:ctor()
    self.super:ctor()
    self.roots = {}
end


function NationalWarMyFightInfo:onUpdateDraw()
    local root = self.roots[1]
    -- _ED.warfar_my_fight_info = 
    -- {
    --     {
    --     name = "hehehe",
    --     attack_index = "0",
    --     },
    --             {
    --     name = "hahaha",
    --     attack_index = "1",
    --     },
    --             {
    --     name = "hihihi",
    --     attack_index = "0",
    --     },
    -- }
    local ListView_situation = ccui.Helper:seekWidgetByName(root,"ListView_situation")
    ListView_situation:removeAllItems()
    local width = ListView_situation:getContentSize().width
    local height = ListView_situation:getContentSize().height
    local fontName = ""
    if ___is_open_leadname == false then 
        fontName = "fonts/FZYiHei-M20S.ttf"
    end
    for i , v in pairs(_ED.warfar_my_fight_info) do   
        local temp_str = nil
        local name = v.name
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)       
        if tonumber(v.attack_index) == 0 then
             local re1 = ccui.RichElementText:create(1, cc.c3b(255,85,39),255, name, fontName,18)
            _richText:pushBackElement(re1)  
             local re2 = ccui.RichElementText:create(1, cc.c3b(255,238,141),255, red_alert_all_str[61], "fonts/FZYiHei-M20S.ttf",18)
            _richText:pushBackElement(re2)
             local re3 = ccui.RichElementText:create(1, cc.c3b(255,238,141),255, red_alert_all_str[63], "fonts/FZYiHei-M20S.ttf",18)
            _richText:pushBackElement(re3)
            
        elseif tonumber(v.attack_index) == 1 then
             local re1 = ccui.RichElementText:create(1, cc.c3b(255,238,141),255, red_alert_all_str[62], "fonts/FZYiHei-M20S.ttf",18)
            _richText:pushBackElement(re1)  
             local re2 = ccui.RichElementText:create(1, cc.c3b(255,85,39),255, name, fontName,18)
            _richText:pushBackElement(re2)
             local re3 = ccui.RichElementText:create(1, cc.c3b(255,238,141),255, red_alert_all_str[63], "fonts/FZYiHei-M20S.ttf",18)
            _richText:pushBackElement(re3)
        end
        _richText:setContentSize(cc.size(width-20,18*3))
        ListView_situation:addChild(_richText)
    end
    
end

function NationalWarMyFightInfo:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_my_fight_info)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)


    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_my_fight"), nil, 
    {
        terminal_name = "national_war_my_fight_info_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    self:onUpdateDraw() 
end

function NationalWarMyFightInfo:init()
    self:onInit()
    return self
end

function NationalWarMyFightInfo:onExit()

end
