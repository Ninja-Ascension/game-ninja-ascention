-----------------------------
-- 还原奖励界面
-----------------------------
SmRoleInfomationRebirthReward = class("SmRoleInfomationRebirthRewardClass", Window)

local sm_role_infomation_rebirth_reward_window_open_terminal = {
	_name = "sm_role_infomation_rebirth_reward_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmRoleInfomationRebirthRewardClass") == nil then
			fwin:open(SmRoleInfomationRebirthReward:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local sm_role_infomation_rebirth_reward_window_close_terminal = {
	_name = "sm_role_infomation_rebirth_reward_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmRoleInfomationRebirthRewardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_role_infomation_rebirth_reward_window_open_terminal)
state_machine.add(sm_role_infomation_rebirth_reward_window_close_terminal)
state_machine.init()

function SmRoleInfomationRebirthReward:ctor()
	self.super:ctor()
	self.roots = {}

    self._choose_state = 0
    self._choose_ship = nil
    self._choose_index = 0
    self._is_max = false

    self._cost = 0

    local function init_sm_role_infomation_rebirth_reward_terminal()
        local sm_role_infomation_rebirth_reward_choose_state_terminal = {
            _name = "sm_role_infomation_rebirth_reward_choose_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._is_max = not instance._is_max
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_infomation_rebirth_reward_open_prompt_terminal = {
            _name = "sm_role_infomation_rebirth_reward_open_prompt",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_role_infomation_rebirth_prompt_window_open", 0, {instance._choose_ship, instance._choose_index, instance._is_max, instance._cost})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_role_infomation_rebirth_reward_ok_terminal = {
            _name = "sm_role_infomation_rebirth_reward_ok",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = instance._choose_index
                local function responseCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)
                        state_machine.excute("sm_role_infomation_rebirth_success_update", 0, index)
                        for i,v in pairs(_ED.user_ship) do
                            setShipPushData(v.ship_id,0,-1)
                        end
                    end
                end
                local ntype = 1
                if instance._is_max == false then
                    ntype = 0
                end
                if instance._choose_index <= 4 then
                    protocol_command.ship_rebirth.param_list = instance._choose_ship.ship_id.."\r\n"..(instance._choose_index - 1).."\r\n"..ntype
                    NetworkManager:register(protocol_command.ship_rebirth.code, nil, nil, nil, instance, responseCallBack, false, nil)  
                else
                    protocol_command.equipment_rebirth.param_list = instance._choose_ship.ship_id.."\r\n"..(instance._choose_index - 5).."\r\n"..ntype
                    NetworkManager:register(protocol_command.equipment_rebirth.code, nil, nil, nil, instance, responseCallBack, false, nil)  
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_infomation_rebirth_reward_choose_state_terminal)
        state_machine.add(sm_role_infomation_rebirth_reward_open_prompt_terminal)
        state_machine.add(sm_role_infomation_rebirth_reward_ok_terminal)
        state_machine.init()
    end
    init_sm_role_infomation_rebirth_reward_terminal()
end

function SmRoleInfomationRebirthReward:updateRoleInfo( ... )
    local root = self.roots[1]
    local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
    Text_tip:removeAllChildren(true)
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

    local char_str = string.format(_new_interface_text[259], "%|"..(quality - 1).."|"..name.."%", _new_interface_text[259 + self._choose_index])
    Text_tip:setString(char_str)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth = Text_tip:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = Text_tip:getFontSize() * 6
    end

    _richText2:setContentSize(cc.size(richTextWidth, Text_tip:getContentSize().height))
    _richText2:setAnchorPoint(cc.p(0, 0))
    if  __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece  then
        local rt, count, text = draw.richTextCollectionMethod(_richText2, 
        char_str, 
        cc.c3b(255, 255, 255),
        cc.c3b(255, 255, 255),
        0, 
        0, 
        Text_tip:getFontName(),
        20,
        chat_rich_text_color)
    else
         local rt, count, text = draw.richTextCollectionMethod(_richText2, 
        char_str, 
        cc.c3b(189, 206, 224),
        cc.c3b(189, 206, 224),
        0, 
        0, 
        Text_tip:getFontName(),
        20,
        chat_rich_text_color)
    end
   
    if _ED.is_can_use_formatTextExt == false then
    else
        _richText2:formatTextExt()
    end
    local rsize = _richText2:getContentSize()
    -- _richText2:setPositionX(140)
    -- _richText2:setPositionY(24)
    Text_tip:addChild(_richText2)
    Text_tip:setString("")

    local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
    local Text_words = ccui.Helper:seekWidgetByName(root, "Text_words")
    Text_words:setString(_new_interface_text[268 + self._choose_index - 1])
    if self._choose_index == 8 then
        Panel_1:setVisible(false)
    else
        Panel_1:setVisible(true)
    end

    local Panel_1_0 = ccui.Helper:seekWidgetByName(root, "Panel_1_0")
    Panel_1_0:setVisible(true)
    local Panel_10 = ccui.Helper:seekWidgetByName(root, "Panel_10")
    local Text_buy_1_0 = ccui.Helper:seekWidgetByName(root, "Text_buy_1_0")
    Text_buy_1_0:removeAllChildren(true)
    Panel_10:removeBackGroundImage()
    local icon = 0
    local str = ""
    if self._choose_index == 1 then
        local needProps = zstring.split(dms.string(dms["ship_config"], 16, ship_config.param), ",")
        local havePropCount = getPropAllCountByMouldId(needProps[2])
        str = string.format(_new_interface_text[280], needProps[3], "%|4|"..havePropCount.."%")
        icon = dms.int(dms["prop_mould"], needProps[2], prop_mould.pic_index)
    elseif self._choose_index == 2 then
        local needProps = zstring.split(dms.string(dms["ship_config"], 19, ship_config.param), ",")
        local havePropCount = getPropAllCountByMouldId(needProps[2])
        str = string.format(_new_interface_text[280], needProps[3], "%|4|"..havePropCount.."%")
        icon = dms.int(dms["prop_mould"], needProps[2], prop_mould.pic_index)
    elseif self._choose_index == 3 then
        local needProps = zstring.split(dms.string(dms["ship_config"], 23, ship_config.param), ",")
        local havePropCount = getPropAllCountByMouldId(needProps[2])
        str = string.format(_new_interface_text[280], needProps[3], "%|4|"..havePropCount.."%")
        icon = dms.int(dms["prop_mould"], needProps[2], prop_mould.pic_index)
    elseif self._choose_index == 5 then
        local needProps = zstring.split(dms.string(dms["equipment_config"], 9, equipment_config.param), ",")
        local havePropCount = getPropAllCountByMouldId(needProps[2])
        str = string.format(_new_interface_text[280], needProps[3], "%|4|"..havePropCount.."%")
        icon = dms.int(dms["prop_mould"], needProps[2], prop_mould.pic_index)
    else
        Panel_1_0:setVisible(false)
    end
    if icon > 0 then
        Panel_10:setBackGroundImage(string.format("images/ui/props/props_%d.png", icon))
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)

        local richTextWidth = Text_buy_1_0:getContentSize().width
        if richTextWidth == 0 then
            richTextWidth = Text_buy_1_0:getFontSize() * 6
        end
                
        _richText:setContentSize(cc.size(richTextWidth, Text_buy_1_0:getContentSize().height))
        _richText:setAnchorPoint(cc.p(0, 0.5))
        local rt, count, text = draw.richTextCollectionMethod(_richText, 
            str, 
            cc.c3b(189, 206, 224),
            cc.c3b(189, 206, 224),
            0, 
            0, 
            Text_buy_1_0:getFontName(),
            20,
            chat_rich_text_color)
        if _ED.is_can_use_formatTextExt == false then
        else
            _richText:formatTextExt()
        end
        local rsize = _richText:getContentSize()
        _richText:setPositionX(0)
        _richText:setPositionY(12)
        Text_buy_1_0:addChild(_richText)
    end
end

function SmRoleInfomationRebirthReward:onUpdateDraw()
    local root = self.roots[1]
    local CheckBox_1 = ccui.Helper:seekWidgetByName(root, "CheckBox_1")
    local Text_buy = ccui.Helper:seekWidgetByName(root, "Text_buy")
    local Image_2_0 = ccui.Helper:seekWidgetByName(root, "Image_2_0")
    CheckBox_1:setSelected(not self._is_max)
    Text_buy:setString("")
    Image_2_0:setVisible(false)

    local costInfo = {}
    local rewardInfo = {}
    if self._is_max == true then
        costInfo = zstring.split(_ED.user_rebirth_info.high_cost_info, "|")
        rewardInfo = zstring.split(_ED.user_rebirth_info.high_reward_info, "|")
    else
        costInfo = zstring.split(_ED.user_rebirth_info.normal_cost_info, "|")
        rewardInfo = zstring.split(_ED.user_rebirth_info.normal_reward_info, "|")
    end
    self._cost = 0
    for k,v in pairs(costInfo) do
        v = zstring.split(v, ",")
        if tonumber(v[1]) ~= 6 and tonumber(v[3]) > 0 then
            Text_buy:setString(v[3])
            Image_2_0:setVisible(true)
            self._cost = tonumber(v[3])
        end
    end

    local ScrollView_reward = ccui.Helper:seekWidgetByName(root, "ScrollView_reward")
    ScrollView_reward:removeAllChildren(true)
    local panel = ScrollView_reward:getInnerContainer()
    panel:setContentSize(ScrollView_reward:getContentSize())
    panel:setPosition(cc.p(0, 0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local tHeight = 0
    local tWidth = 0
    local wPosition = sSize.width/5
    local Hlindex = 0
    local m_number = math.ceil(table.nums(rewardInfo)/5)
    local cellHeight = 0
    local cellWidth = 0
    local index = 0
    cellHeight = m_number*(ScrollView_reward:getContentSize().width/5)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(ScrollView_reward:getContentSize().width, sHeight)
    for k,v in pairs(rewardInfo) do
        v = zstring.split(v, ",")
        local cell = nil
        if tonumber(v[3]) > 0 then
            if tonumber(v[1]) == 1 then
                cell = ResourcesIconCell:createCell()
                cell:init(v[1], tonumber(v[3]), -1,nil,nil,true,true)
                local nameCell = cell:getName()
                nameCell:setColor(cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]))
                nameCell:setString(_All_tip_string_info._fundName)
            elseif tonumber(v[1]) == 2 then
                cell = ResourcesIconCell:createCell()
                cell:init(v[1], tonumber(v[3]),-1,nil,nil,true,true)
                local nameCell = cell:getName()
                nameCell:setColor(cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]))
                nameCell:setString(_All_tip_string_info._crystalName)
            elseif tonumber(v[1]) == 5 then
                cell = ResourcesIconCell:createCell()
                cell:init(v[1], tonumber(v[3]), -1)
                local nameCell = cell:getName()
                nameCell:setColor(cc.c3b(color_Type[4][1],color_Type[4][2],color_Type[4][3]))
                nameCell:setString(_All_tip_string_info._juexingsuipian)
            elseif tonumber(v[1]) == 6 then
                cell = ResourcesIconCell:createCell()
                cell:init(v[1], tonumber(v[3]), v[2],nil,nil,true,true)
                local name = setThePropsIcon(v[2])[2]
                local quality = dms.int(dms["prop_mould"], v[2], prop_mould.prop_quality) + 1
                local nameCell = cell:getName()
                nameCell:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
                nameCell:setString(name)
            elseif tonumber(v[1]) == 7 then
                cell = ResourcesIconCell:createCell()
                cell:init(v[1], tonumber(v[3]), v[2],nil,nil,true,true,nil,{equipQuality = 0})
                local nameindex = dms.int(dms["equipment_mould"], v[2], equipment_mould.equipment_name)
                local word_info = dms.element(dms["word_mould"], nameindex)
                local name = word_info[3]
                local quality = dms.int(dms["equipment_mould"], v[2], equipment_mould.trace_npc_index) + 1
                local nameCell = cell:getName()
                nameCell:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
                nameCell:setString(name)
            elseif tonumber(v[1]) == 13 then
                cell = ResourcesIconCell:createCell()
                cell:init(v[1], tonumber(v[3]), v[2],nil,nil,true,true,1)
                local evo_image = dms.string(dms["ship_mould"], v[2], ship_mould.fitSkillTwo)
                local evo_info = zstring.split(evo_image, ",")
                local evo_mould_id = evo_info[dms.int(dms["ship_mould"], v[2], ship_mould.captain_name)]
                local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
                local word_info = dms.element(dms["word_mould"], name_mould_id)
                local name = word_info[3]
                local nameCell = cell:getName()
                nameCell:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
                nameCell:setString(name)
            elseif tonumber(v[1]) == 18 then
                cell = ResourcesIconCell:createCell()
                cell:init(v[1], tonumber(v[3]),-1)
                local nameCell = cell:getName()
                nameCell:setColor(cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]))
                nameCell:setString(_All_tip_string_info._glories)
            elseif tonumber(v[1]) == 3 then
                cell = ResourcesIconCell:createCell()
                cell:init(v[1], tonumber(v[3]),-1)
                local nameCell = cell:getName()
                nameCell:setColor(cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]))
                nameCell:setString(_All_tip_string_info._reputation)
            elseif tonumber(v[1]) == 34 then
                cell = ResourcesIconCell:createCell()
                cell:init(v[1], tonumber(v[3]),-1)
                local nameCell = cell:getName()
                nameCell:setColor(cc.c3b(color_Type[3][1],color_Type[3][2],color_Type[3][3]))
                nameCell:setString(_my_gane_name[15])
            end
        end

        if cell ~= nil then
            index = index + 1
            panel:addChild(cell)
            tWidth = tWidth + wPosition
            if (index - 1)%5 == 0 then
                Hlindex = Hlindex + 1
                tWidth = 0
                tHeight = sHeight - (wPosition - 15) * Hlindex
            end
            if index <= 5 then
                tHeight = sHeight - wPosition
            end
            cell:setPosition(cc.p(tWidth, tHeight))
        end
    end
    ScrollView_reward:jumpToTop()
end

function SmRoleInfomationRebirthReward:init(params)
    self._choose_ship = params[1]
    self._choose_state = params[2]
    self._choose_index = params[3]
	self:onInit()
    return self
end

function SmRoleInfomationRebirthReward:onInit()
    local csbItem = csb.createNode("packs/HeroStorage/generals_rebirth_rweep.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_fanhui_lwj"), nil, 
    {
        terminal_name = "sm_role_infomation_rebirth_reward_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    local CheckBox_1 = ccui.Helper:seekWidgetByName(root,"CheckBox_1")
    fwin:addTouchEventListener(CheckBox_1, nil, 
    {
        terminal_name = "sm_role_infomation_rebirth_reward_choose_state", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_choice"), nil, 
    {
        terminal_name = "sm_role_infomation_rebirth_reward_open_prompt", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    if self._choose_index == 8 then
        self._is_max = true
    end

    self:updateRoleInfo()
	self:onUpdateDraw()
    CheckBox_1:setSelected(false)
end

function SmRoleInfomationRebirthReward:onEnterTransitionFinish()
end

function SmRoleInfomationRebirthReward:onExit()
    state_machine.remove("sm_role_infomation_rebirth_reward_choose_state")
    state_machine.remove("sm_role_infomation_rebirth_reward_open_prompt")
    state_machine.remove("sm_role_infomation_rebirth_reward_ok")
end