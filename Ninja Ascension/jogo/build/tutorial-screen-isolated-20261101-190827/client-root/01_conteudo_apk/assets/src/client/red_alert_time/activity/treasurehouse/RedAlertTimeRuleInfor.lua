-----------------------------
--规则说明
-----------------------------
RedAlertTimeRuleInfor = class("RedAlertTimeRuleInforClass", Window)

local red_alert_time_rule_infor_window_open_terminal = {
    _name = "red_alert_time_rule_infor_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("RedAlertTimeRuleInforClass") then
			fwin:open(RedAlertTimeRuleInfor:new():init(params), fwin._ui)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_rule_infor_window_close_terminal = {
    _name = "red_alert_time_rule_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeRuleInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_rule_infor_window_open_terminal)
state_machine.add(red_alert_time_rule_infor_window_close_terminal)
state_machine.init()

function RedAlertTimeRuleInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self._index = 0
end


function RedAlertTimeRuleInfor:onUpdateDraw()
    local root = self.roots[1]
    local Panel_map_res_infor = ccui.Helper:seekWidgetByName(root,"Panel_map_res_infor")
    local Image_map_res_box = ccui.Helper:seekWidgetByName(root,"Image_map_res_box")
	local Text_res_icon_name_lv_0_1_1 = ccui.Helper:seekWidgetByName(root,"Text_res_icon_name_lv_0_1_1")
	-- Text_res_icon_name_lv_0_1_1:setString(activity_rules_document[1])
	Text_res_icon_name_lv_0_1_1:setString("")
	Text_res_icon_name_lv_0_1_1:removeAllChildren(true)
	local datas = dms.string(dms["activity_rule"], self._index, activity_rule.content)
	local texts_info = zstring.split(datas, "/r/n")
	local index = 0
    local fontSize = Text_res_icon_name_lv_0_1_1:getFontSize()
	for i=1,#texts_info do
		local _richText2 = ccui.RichText:create()
		_richText2:ignoreContentAdaptWithSize(false)
		_richText2:setContentSize(cc.size(Text_res_icon_name_lv_0_1_1:getContentSize().width, 0))
		_richText2:setAnchorPoint(cc.p(0, 0))
		local char_str = texts_info[i]
		local rt, count, text = draw.richTextCollectionMethod(_richText2, 
		char_str, 
		cc.c3b(189, 206, 224),
		cc.c3b(189, 206, 224),
		0, 
		0, 
		config_res.font.font_name, 
		fontSize,
		chat_rich_text_color)
		_richText2:formatTextExt()
		local rsize = _richText2:getContentSize()
		_richText2:setPositionY(Text_res_icon_name_lv_0_1_1:getContentSize().height-index)
		-- _richText2:setPositionX(400 - 0.5 * fontSize)
		Text_res_icon_name_lv_0_1_1:addChild(_richText2)
		index = index + rsize.height
    end
    local text_height = Text_res_icon_name_lv_0_1_1:getContentSize().height
    if index >= text_height then
        local add_height = index - text_height
        Image_map_res_box:setContentSize(cc.size(Image_map_res_box:getContentSize().width ,Image_map_res_box:getContentSize().height + add_height))
        Panel_map_res_infor:setPositionY(Panel_map_res_infor:getPositionY() + add_height / 2)
    end
end

function RedAlertTimeRuleInfor:onEnterTransitionFinish()

end

function RedAlertTimeRuleInfor:onInit( )
    local csbItem = csb.createNode(config_csb.treasurehouse.brothers_share_rule_infor)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_infor_close"), nil, 
    {
        terminal_name = "red_alert_time_rule_infor_window_close", 
        terminal_state = 0,
        touch_black = true,
    }, nil, 3)
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_rule_infor_window_close", 
        terminal_state = 0,
    }, nil, 3)
	
	self:onUpdateDraw()
end

function RedAlertTimeRuleInfor:init(params)
	self._index = tonumber(params)
	self:onInit()
    return self
end

function RedAlertTimeRuleInfor:onExit()
    -- state_machine.remove("red_alert_time_rule_infor_activity_codes")
end
