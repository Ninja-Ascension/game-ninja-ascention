-----------------------------
-- 城市战部队兑换确认界面
-----------------------------
LegionCityFormaitonChangeSure = class("LegionCityFormaitonChangeSureClass", Window)

local legion_city_formaiton_change_sure_window_open_terminal = {
    _name = "legion_city_formaiton_change_sure_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("LegionCityFormaitonChangeSureClass") then
            local panel = LegionCityFormaitonChangeSure:new():init(params)
            fwin:open(panel, fwin._ui)
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local legion_city_formaiton_change_sure_window_close_terminal = {
    _name = "legion_city_formaiton_change_sure_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionCityFormaitonChangeSureClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_city_formaiton_change_sure_window_open_terminal)
state_machine.add(legion_city_formaiton_change_sure_window_close_terminal)
state_machine.init()

function LegionCityFormaitonChangeSure:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._info = nil
    self._count = 0

    local function init_legion_city_formaiton_change_sure_terminal()
        local legion_city_formaiton_change_sure_change_terminal = {
            _name = "legion_city_formaiton_change_sure_change",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("legion_city_formation_update_draw", 0, "")
                        state_machine.excute("formation_choose_troop_window_close", 0, nil)
                        state_machine.excute("home_map_update_tanke_info", 0, "")
                        state_machine.excute("legion_city_formaiton_change_sure_window_close", 0, "")
                        TipDlg.drawTextDailog(red_alert_time_str[36])
                    end
                end
                protocol_command.world_city_army_exchange.param_list = ""..instance._info.ship_id.."\r\n"..instance._count
                NetworkManager:register(protocol_command.world_city_army_exchange.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(legion_city_formaiton_change_sure_change_terminal)
        state_machine.init()
    end
    init_legion_city_formaiton_change_sure_terminal()
end

-- 刷新界面
function LegionCityFormaitonChangeSure:onUpdateDraw()
    local root = self.roots[1]
    local Text_active_tip_1 = ccui.Helper:seekWidgetByName(root,"Text_active_tip_1")
    Text_active_tip_1:removeAllChildren(true)
    Text_active_tip_1:setString("")

    local change_factor = dms.int(dms["world_city_config"], 35, world_city_config.param)
    local tips = world_city_tip_str[74]
    tips = string.gsub(tips, "!x@", self._count)
    tips = string.gsub(tips, "!y@", self._info.captain_name)
    tips = string.gsub(tips, "!z@", self._count * change_factor)

    local font_size = Text_active_tip_1:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    _richText:setContentSize(cc.size(Text_active_tip_1:getContentSize().width, Text_active_tip_1:getContentSize().height))  
    local rt2, count2, text2 = draw.richTextCollectionMethod(_richText, 
        tips, 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        config_res.font.font_name, 
        font_size,
        chat_rich_text_color)

    _richText:formatTextExt()
    _richText:setPosition(cc.p(Text_active_tip_1:getContentSize().width, Text_active_tip_1:getContentSize().height))  
    Text_active_tip_1:addChild(_richText)
end 

function LegionCityFormaitonChangeSure:onEnterTransitionFinish()

end

function LegionCityFormaitonChangeSure:onInit( )
    local csbItem = csb.createNode(config_csb.legion.legion_city_formaiton_change_sure)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_city_formation_close"), nil, 
    {
        terminal_name = "legion_city_formaiton_change_sure_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "legion_city_formaiton_change_sure_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_city_formation_col"), nil, 
    {
        terminal_name = "legion_city_formaiton_change_sure_window_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_city_formation_sure"), nil, 
    {
        terminal_name = "legion_city_formaiton_change_sure_change",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    self:onUpdateDraw()
end

function LegionCityFormaitonChangeSure:init(params)
    self._info = params[1]
    self._count = params[2]
    self:onInit()
    return self
end

function LegionCityFormaitonChangeSure:onExit()
    state_machine.remove("legion_city_formaiton_change_sure_change")
end
