-- ------------------------------------------------------------------------------------------------------------
--  说明：科威特秘密规则,摧枯拉朽
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeSecretRule = class("RedAlertTimeSecretRuleClass", Window)

--打开界面
local red_alert_time_secret_rule_open_terminal = {
    _name = "red_alert_time_secret_rule_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = RedAlertTimeSecretRule:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_secret_rule_open_terminal)
state_machine.init()

function RedAlertTimeSecretRule:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._activity_type = nil
    self._index = 0

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_seek_rank_arrow_down = nil
    self._Image_seek_rank_arrow_up = nil

    local function init_red_alert_time_secret_rule_terminal()
        local red_alert_time_secret_rule_show_terminal = {
            _name = "red_alert_time_secret_rule_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_secret_rule_hide_terminal = {
            _name = "red_alert_time_secret_rule_hide",
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

        state_machine.add(red_alert_time_secret_rule_show_terminal)
        state_machine.add(red_alert_time_secret_rule_hide_terminal)
        state_machine.init()
    end
    init_red_alert_time_secret_rule_terminal()
end

function RedAlertTimeSecretRule:onUpdateDraw()
    local root = self.roots[1]
    local Text_introduce = ccui.Helper:seekWidgetByName(root, "Text_introduce")
    Text_introduce:setString("")
    Text_introduce:removeAllChildren(true)
    local datas = dms.string(dms["activity_rule"], self._index, activity_rule.content)
    local texts_info = zstring.split(datas, "/r/n")
    local index = 0
    for i=1,#texts_info do
        local _richText2 = ccui.RichText:create()
        _richText2:ignoreContentAdaptWithSize(false)
        _richText2:setContentSize(cc.size(Text_introduce:getContentSize().width, 0))
        _richText2:setAnchorPoint(cc.p(0, 0))
        local char_str = texts_info[i]
        local rt, count, text = draw.richTextCollectionMethod(_richText2, 
        char_str, 
        cc.c3b(189, 206, 224),
        cc.c3b(189, 206, 224),
        0, 
        0, 
        config_res.font.font_name, 
        20,
        chat_rich_text_color)
        _richText2:formatTextExt()
        local rsize = _richText2:getContentSize()
        _richText2:setPositionY(Text_introduce:getContentSize().height-index)
        -- _richText2:setPositionX(400 - 0.5 * fontSize)
        Text_introduce:addChild(_richText2)
        index = index + rsize.height
    end
end


function RedAlertTimeSecretRule:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.seek_treasure_tab_4)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw()
end

function RedAlertTimeSecretRule:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self._activity_type = params[2]
    self._index = tonumber(self._activity_type.activity_type)
    self:onInit()
    return self
end

function RedAlertTimeSecretRule:onExit()
    state_machine.remove("red_alert_time_secret_rule_show")
    state_machine.remove("red_alert_time_secret_rule_hide")
end