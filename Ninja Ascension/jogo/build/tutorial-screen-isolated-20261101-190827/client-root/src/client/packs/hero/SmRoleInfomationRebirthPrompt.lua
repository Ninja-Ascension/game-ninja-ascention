SmRoleInfomationRebirthPrompt = class("SmRoleInfomationRebirthPromptClass", Window)

local sm_role_infomation_rebirth_prompt_window_open_terminal = {
    _name = "sm_role_infomation_rebirth_prompt_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SmRoleInfomationRebirthPromptClass") == nil then
            fwin:open(SmRoleInfomationRebirthPrompt:new():init(params), fwin._ui)     
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_infomation_rebirth_prompt_window_close_terminal = {
    _name = "sm_role_infomation_rebirth_prompt_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmRoleInfomationRebirthPromptClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_infomation_rebirth_prompt_window_open_terminal)
state_machine.add(sm_role_infomation_rebirth_prompt_window_close_terminal)
state_machine.init()

function SmRoleInfomationRebirthPrompt:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._choose_ship = nil
    self._choose_index = 0
    self._is_max = false
    self._cost = 0

    local function init_sm_role_infomation_rebirth_prompt_terminal()
        local sm_role_infomation_rebirth_prompt_ok_terminal = {
            _name = "sm_role_infomation_rebirth_prompt_ok",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_role_infomation_rebirth_reward_ok", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        local sm_role_infomation_rebirth_prompt_cancel_terminal = {
            _name = "sm_role_infomation_rebirth_prompt_cancel",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_role_infomation_rebirth_prompt_window_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_role_infomation_rebirth_prompt_ok_terminal)
        state_machine.add(sm_role_infomation_rebirth_prompt_cancel_terminal)
        state_machine.init()
    end
    init_sm_role_infomation_rebirth_prompt_terminal()
end

function SmRoleInfomationRebirthPrompt:onUpdateDraw( ... )
    local root = self.roots[1]
    local Text_title = ccui.Helper:seekWidgetByName(root, "Text_title")
    local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
    local Text_price = ccui.Helper:seekWidgetByName(root, "Text_price")
    Text_1:removeAllChildren(true)
    Text_2:removeAllChildren(true)
    Text_title:setString(_new_interface_text[268 + self._choose_index - 1])
    local quality = shipOrEquipSetColour(tonumber(self._choose_ship.Order))
    local evo_image = dms.string(dms["ship_mould"], self._choose_ship.ship_template_id, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    local ship_evo = zstring.split(self._choose_ship.evolution_status, "|")
    local evo_mould_id = smGetSkinEvoIdChange(self._choose_ship)
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    local name = word_info[3]
    if getShipNameOrder(tonumber(self._choose_ship.Order)) > 0 then
        name = name.." +"..getShipNameOrder(tonumber(self._choose_ship.Order))
    end

    local char_str = string.format(_new_interface_text[277], "%|"..(quality - 1).."|"..name.."%", _new_interface_text[259 + self._choose_index])
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth = Text_1:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = Text_1:getFontSize() * 6
    end
    local showColorType = cc.c3b(189, 206, 224)
    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_pokemon then
        showColorType = Text_1:getColor()
    end 
    _richText2:setContentSize(cc.size(richTextWidth, Text_1:getContentSize().height))
    _richText2:setAnchorPoint(cc.p(0, 0.5))
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
        char_str, 
        showColorType,
        showColorType,
        0, 
        0, 
        Text_1:getFontName(),
        20,
        chat_rich_text_color)
    if _ED.is_can_use_formatTextExt == false then
    else
        _richText2:formatTextExt()
    end
    local rsize = _richText2:getContentSize()
    _richText2:setPositionX(0)
    _richText2:setPositionY(24)
    Text_1:addChild(_richText2)

    char_str = ""
    if self._is_max == true then
        char_str = string.format(_new_interface_text[278], "%|4|100%%")
    else
        char_str = string.format(_new_interface_text[279].._new_interface_text[278], "%|4|90%%")
    end
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)

    local richTextWidth2 = Text_2:getContentSize().width
    if richTextWidth2 == 0 then
        richTextWidth2 = Text_2:getFontSize() * 6
    end

    _richText:setContentSize(cc.size(richTextWidth2, Text_2:getContentSize().height))
    _richText:setAnchorPoint(cc.p(0, 0.5))
    local rt, count, text = draw.richTextCollectionMethod(_richText, 
        char_str, 
        showColorType,
        showColorType,
        0, 
        0, 
        Text_2:getFontName(),
        20,
        chat_rich_text_color)
    if _ED.is_can_use_formatTextExt == false then
    else
        _richText:formatTextExt()
    end
    local rsize = _richText:getContentSize()
    _richText:setPositionX(0)
    _richText:setPositionY(12)
    Text_2:addChild(_richText)

    if self._cost == 0 then
        ccui.Helper:seekWidgetByName(root, "Text_1_2_2_1_0"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Panel_icon"):setVisible(false)
        Text_price:setString("")
    else
        ccui.Helper:seekWidgetByName(root, "Text_1_2_2_1_0"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_icon"):setVisible(true)
        Text_price:setString(self._cost)
    end

end

function SmRoleInfomationRebirthPrompt:onInit( ... )
    local csbConfirmPrompted = csb.createNode("packs/HeroStorage/generals_rebirth_rweep_prompt.csb")
    self:addChild(csbConfirmPrompted)
    local root = csbConfirmPrompted:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("packs/HeroStorage/generals_rebirth_rweep_prompt.csb")
    table.insert(self.actions, action)
    csbConfirmPrompted:runAction(action)
    action:play("window_open", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4_8_4"), nil, 
        {
            terminal_name = "sm_role_infomation_rebirth_prompt_cancel", 
            terminal_state = 1,
            isPressedActionEnabled = true
        }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3_6_2"), nil, 
        {
            terminal_name = "sm_role_infomation_rebirth_prompt_ok", 
            terminal_state = 1,
            isPressedActionEnabled = true
        }, nil, 2)

    self:onUpdateDraw()
end

function SmRoleInfomationRebirthPrompt:onEnterTransitionFinish()
end

function SmRoleInfomationRebirthPrompt:init(params)
	self._choose_ship = params[1]
    self._choose_index = params[2]
    self._is_max = params[3]
    self._cost = params[4]
    self:onInit()
    return self
end

function SmRoleInfomationRebirthPrompt:onExit()
	state_machine.remove("sm_role_infomation_rebirth_prompt_ok")
	state_machine.remove("sm_role_infomation_rebirth_prompt_cancel")
end