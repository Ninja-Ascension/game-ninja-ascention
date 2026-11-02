-- ------------------------------------------------------------------------------------------------------------
--  说明：装甲套装效果一览
-- ------------------------------------------------------------------------------------------------------------
ArmorSuitEffectLook = class("ArmorSuitEffectLookClass", Window)

--打开界面
local armor_suit_effect_look_window_open_terminal = {
    _name = "armor_suit_effect_look_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("ArmorSuitEffectLookClass") == nil then
            local _win = ArmorSuitEffectLook:new()
            _win:init(params)
            fwin:open(_win,fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local armor_suit_effect_look_window_close_terminal = {
    _name = "armor_suit_effect_look_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ArmorSuitEffectLookClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(armor_suit_effect_look_window_open_terminal)
state_machine.add(armor_suit_effect_look_window_close_terminal)
state_machine.init()

function ArmorSuitEffectLook:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.current_formation = 0

     -- Initialize alert_home state machine.
    local function init_armor_suit_effect_look_terminal()

    end
    -- call func alert_home create state machine.
    init_armor_suit_effect_look_terminal()
end


-- 显示信息
function ArmorSuitEffectLook:onUpdateDraw()
    local root = self.roots[1]
    local armor_list = {}
    if _ED.push_user_armor_equip_table[""..self.current_formation] ~= nil then
        armor_list = _ED.push_user_armor_equip_table[""..self.current_formation]
    end

    local suit_armor_count = {0, 0, 0}
    for k, v in pairs(armor_list) do
        if suit_armor_count[v.suit_id] == nil then
            suit_armor_count[v.suit_id] = 0
        end
        suit_armor_count[v.suit_id] = suit_armor_count[v.suit_id] + 1
    end

    for i=1,2 do
        local Text_armor_attribute_infor = ccui.Helper:seekWidgetByName(root,"Text_armor_attribute_infor_"..i)
        Text_armor_attribute_infor:setString("")
        Text_armor_attribute_infor:removeAllChildren(true)

        local suit_id = i
        local str = zstring.split(armor_tip_str[suit_id + 3], ",")
        local color_1 = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
        local color_2 = cc.c3b(color_Type[suit_id + 2][1],color_Type[suit_id + 2][2],color_Type[suit_id + 2][3])
        local color_3 = cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3])
        local fontSize = Text_armor_attribute_infor:getFontSize()
        local _richText_1 = ccui.RichText:create()
        _richText_1:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, color_1,255, str[1], config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, color_2,255, str[2], config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, color_1,255, str[3], config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re3)
        local re4 = ccui.RichElementText:create(1, color_3,255, str[4], config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re4)
        local re5 = ccui.RichElementText:create(1, color_1,255, string.format(str[5],suit_armor_count[suit_id]), config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re5)
        _richText_1:setPosition(cc.p(Text_armor_attribute_infor:getContentSize().width/2,Text_armor_attribute_infor:getContentSize().height/2))
        _richText_1:setContentSize(cc.size(Text_armor_attribute_infor:getContentSize().width,fontSize))
        Text_armor_attribute_infor:addChild(_richText_1)
    end

end

--初始化界面
function ArmorSuitEffectLook:onInit()
    local csbItem = csb.createNode(config_csb.armor.armor_suit_effect_look)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_infor_close"), nil, 
    {
        terminal_name = "armor_suit_effect_look_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "armor_suit_effect_look_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    self:onUpdateDraw()
end

--初始化
function ArmorSuitEffectLook:init(params)
    self.current_formation = params[1]
    self:onInit()
end

--移除状态机
function ArmorSuitEffectLook:onExit()

end