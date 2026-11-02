-- ------------------------------------------------------------------------------------------------------------
--  说明：红包抢夺
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeRedEnvelopesRob = class("RedAlertTimeRedEnvelopesRobClass", Window)

--打开界面
local red_alert_time_red_rnvelopes_rob_window_open_terminal = {
    _name = "red_alert_time_red_rnvelopes_rob_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        state_machine.excute("red_alert_time_red_rnvelopes_rob_window_close", 0, nil) 
        local _win = RedAlertTimeRedEnvelopesRob:new()
        _win:init(params)
        fwin:open(_win, fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local red_alert_time_red_rnvelopes_rob_window_close_terminal = {
    _name = "red_alert_time_red_rnvelopes_rob_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeRedEnvelopesRobClass"))

        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_red_rnvelopes_rob_window_open_terminal)
state_machine.add(red_alert_time_red_rnvelopes_rob_window_close_terminal)
state_machine.init()

function RedAlertTimeRedEnvelopesRob:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

     -- Initialize alert_home state machine.
    local function init_red_alert_time_red_rnvelopes_rob_terminal()

        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_red_alert_time_red_rnvelopes_rob_terminal()

end


--初始化界面
function RedAlertTimeRedEnvelopesRob:onInit()
    local csbItem = csb.createNode(config_csb.activity.act_red_envelopes_rob)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_red_envelopes_rob_close"), nil, 
    {
        terminal_name = "red_alert_time_red_rnvelopes_rob_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    self:onUpdateDraw()

end

-- 显示信息
function RedAlertTimeRedEnvelopesRob:onUpdateDraw()
    local root = self.roots[1]
    
    local Text_red_envelopes_rob_give_name = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_rob_give_name")  -- 赠送人name
    local Text_red_envelopes_rob_infor = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_rob_infor")          -- 发红包详情
    local Panel_red_envelopes_rob_icon = ccui.Helper:seekWidgetByName(root,"Panel_red_envelopes_rob_icon")          -- 红包icon
    local Text_red_envelopes_rob_name = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_rob_name")            -- 红包name
    local Text_red_envelopes_rob_gold = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_rob_gold")            -- 金币数量
    local Text_red_envelopes_rob_gold_n = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_rob_gold_n")        -- 金币数量
    local Text_red_envelopes_rob_rec_n = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_rob_rec_n")          -- 剩余红包
    local Text_red_envelopes_rob_rec_infor = ccui.Helper:seekWidgetByName(root,"Text_red_envelopes_rob_rec_infor")  -- 领红包详情

    Text_red_envelopes_rob_give_name:setString(_ED.send_red_envelopes_name)
    local str = ""
    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        fontName = ""
    end
    Text_red_envelopes_rob_give_name:setFontName(fontName)
    Text_red_envelopes_rob_give_name:setFontSize(Text_red_envelopes_rob_give_name:getFontSize())
    Text_red_envelopes_rob_infor:removeAllChildren(true)
    local infor_fontSize = Text_red_envelopes_rob_infor:getFontSize()
    local _richText_1 = ccui.RichText:create()
    _richText_1:ignoreContentAdaptWithSize(false) 
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, _ED.send_red_envelopes_name, fontName,infor_fontSize)
    _richText_1:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, chat_sent_string[9], config_res.font.font_name,infor_fontSize)
    _richText_1:pushBackElement(re2)
    _richText_1:setPosition(cc.p(Text_red_envelopes_rob_infor:getContentSize().width/2,Text_red_envelopes_rob_infor:getContentSize().height/2))
    _richText_1:setContentSize(cc.size(Text_red_envelopes_rob_infor:getContentSize().width,infor_fontSize))
    _richText_1:formatText()
    _richText_1:ignoreContentAdaptWithSize(false)
    Text_red_envelopes_rob_infor:addChild(_richText_1)

    Panel_red_envelopes_rob_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{1,1,_ED.red_envelopes_template_id,1})
    Panel_red_envelopes_rob_icon:addChild(cell) 

    local prop_name = dms.string(dms["prop_mould"], _ED.red_envelopes_template_id, prop_mould.prop_name)
    Text_red_envelopes_rob_name:setString(prop_name)

    local shop_of_gold = dms.int(dms["prop_mould"], _ED.red_envelopes_template_id, prop_mould.shop_of_gold)
    local remarks = dms.string(dms["prop_mould"], _ED.red_envelopes_template_id, prop_mould.remarks)
    Text_red_envelopes_rob_gold_n:setString("")
    if tonumber(_ED.red_envelopes_template_id) == 681 then
        Text_red_envelopes_rob_gold:setString(remarks)
        str = chat_sent_string[13]
    else
        Text_red_envelopes_rob_gold_n:setString(shop_of_gold)
        str = chat_sent_string[10]
    end
    

    Text_red_envelopes_rob_rec_n:removeAllChildren(true)
    local rec_fontSize = Text_red_envelopes_rob_rec_n:getFontSize()
    local _richText_2 = ccui.RichText:create()
    _richText_2:ignoreContentAdaptWithSize(false) 
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, _ED.red_envelopes_max_times - _ED.red_envelopes_make_times, config_res.font.font_name,rec_fontSize)
    _richText_2:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/".._ED.red_envelopes_max_times, config_res.font.font_name,rec_fontSize)
    _richText_2:pushBackElement(re2)
    _richText_2:setPosition(cc.p(Text_red_envelopes_rob_rec_n:getContentSize().width/2,Text_red_envelopes_rob_rec_n:getContentSize().height/2))
    _richText_2:setContentSize(cc.size(Text_red_envelopes_rob_rec_n:getContentSize().width,rec_fontSize))
    Text_red_envelopes_rob_rec_n:addChild(_richText_2)

    Text_red_envelopes_rob_rec_infor:removeAllChildren(true)
    local rec_infor_fontSize = Text_red_envelopes_rob_rec_infor:getFontSize()
    local index = 20
    for i,v in pairs(_ED.get_red_envelopes_info) do
        local _richText_3 = ccui.RichText:create()
        _richText_3:ignoreContentAdaptWithSize(false) 
        _richText_3:setContentSize(cc.size(Text_red_envelopes_rob_rec_infor:getContentSize().width,30))
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]),255, v.name, fontName ,rec_infor_fontSize)
        _richText_3:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, str, config_res.font.font_name,rec_infor_fontSize)
        _richText_3:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, v.gold, config_res.font.font_name,rec_infor_fontSize)
        _richText_3:pushBackElement(re3)
        -- _richText_3:formatTextExt()
        local rsize = _richText_3:getContentSize()
        _richText_3:setPosition(cc.p(Text_red_envelopes_rob_rec_infor:getContentSize().width/2,Text_red_envelopes_rob_rec_infor:getContentSize().height-index))
        _richText_3:formatText()
        _richText_3:ignoreContentAdaptWithSize(false)
        Text_red_envelopes_rob_rec_infor:addChild(_richText_3)
        index = index + rsize.height
    end

end

function RedAlertTimeRedEnvelopesRob:onUpdate(dt)

end


--初始化
function RedAlertTimeRedEnvelopesRob:init(params)
    self._info = params[1]
    self:setTouchEnabled(true)
    self:onInit()
end


--移除状态机
function RedAlertTimeRedEnvelopesRob:onExit()
end