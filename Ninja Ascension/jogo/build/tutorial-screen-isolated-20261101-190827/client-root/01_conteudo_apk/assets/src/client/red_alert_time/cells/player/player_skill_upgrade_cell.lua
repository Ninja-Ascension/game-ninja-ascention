----------------------------------------------------------------------------------------------------
-- 说明：玩家技能建筑升级
-------------------------------------------------------------------------------------------------------
PlayerSkillUpgradeCell = class("PlayerSkillUpgradeCellClass", Window)
PlayerSkillUpgradeCell.__size = nil

local player_skill_upgrade_create_cell_terminal = {
    _name = "player_skill_upgrade_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PlayerSkillUpgradeCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(player_skill_upgrade_create_cell_terminal)
state_machine.init()

function PlayerSkillUpgradeCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
    self._info = nil

    app.load("client.red_alert_time.build_up.BuildUpBbuildQuickly")
    app.load("client.red_alert_time.cells.props.props_use_cell")
 	local function init_player_skill_upgrade_cell_terminal()
        -- 升级
        local player_skill_upgrade_upgrade_terminal = {
            _name = "player_skill_upgrade_upgrade",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- state_machine.excute("effect_play_update_action",0,"")
            	local cell = params._datas.cell
                local level = zstring.tonumber(_ED.majesty_info[cell._info.index])
                if level >= zstring.tonumber(_ED.user_info.user_grade) then
                    TipDlg.drawTextDailog(red_alert_all_str[295])
                    return
                end

                local prop_id = dms.int(dms["prop_config"], 9, prop_config.param)
                local prop_count = zstring.tonumber(getPropAllCountByMouldId(prop_id))
                local buy_count = level + 1 - prop_count
                if buy_count > 0 then
                    local shop_of_gold = dms.int(dms["prop_mould"], prop_id, prop_mould.shop_of_gold)
                    local tip = ConfirmTip:new()
                    tip:init(cell, cell.sureUpgrade, string.format(red_alert_all_str[294], buy_count*shop_of_gold, buy_count))
                    fwin:open(tip, fwin._windows)
                else
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node:onUpdateDraw()
                                state_machine.excute("player_info_skill_update_skill_point", 0, nil)
                            end
                            state_machine.excute("effect_play_window_open",0,{4})
                            state_machine.excute("combat_effectiveness_up_continue_play", 0, "")
                            checkPlayEffect(29)
                        end
                    end     
                    protocol_command.wear_majesty_change.param_list = cell._info.id
                    NetworkManager:register(protocol_command.wear_majesty_change.code, nil, nil, nil, cell, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_skill_upgrade_upgrade_terminal)
        state_machine.init()
    end
	init_player_skill_upgrade_cell_terminal()        	
end

function PlayerSkillUpgradeCell:sureUpgrade(sure_number)
    local skill_id = self._info.id
    local function responseBuyCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            local function responseCallback( response )
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                        response.node:onUpdateDraw()
                        state_machine.excute("player_info_skill_update_skill_point", 0, nil)
                    end
                    state_machine.excute("effect_play_window_open",0,{4})
                    checkPlayEffect(29)
                end
            end
            _ED.show_reward_list_group_ex = {}

            protocol_command.wear_majesty_change.param_list = skill_id
            NetworkManager:register(protocol_command.wear_majesty_change.code, nil, nil, nil, response.node, responseCallback, false, nil)
        end
    end
    if sure_number == 0 then
        -- state_machine.excute("effect_play_update_action",0,"")
        local user_prop_id = dms.int(dms["prop_config"], 9, prop_config.param)
        local prop_count = zstring.tonumber(getPropAllCountByMouldId(user_prop_id))
        local buy_count = zstring.tonumber(_ED.majesty_info[self._info.index]) + 1 - prop_count
        local prop_id = dms.int(dms["prop_config"], 31, prop_config.param)
        protocol_command.avatar_shop_buy.param_list = prop_id.."\r\n"..buy_count
        NetworkManager:register(protocol_command.avatar_shop_buy.code, nil, nil, nil, self, responseBuyCallback, false, nil)
    end
end

function PlayerSkillUpgradeCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    local Text_skill_type_lv = ccui.Helper:seekWidgetByName(root, "Text_skill_type_lv")
    local Text_skill_infor = ccui.Helper:seekWidgetByName(root, "Text_skill_infor")
    local Text_have_n = ccui.Helper:seekWidgetByName(root, "Text_have_n")
    local Button_up = ccui.Helper:seekWidgetByName(root, "Button_up")

    local level = zstring.tonumber(_ED.majesty_info[self._info.index])
    Text_skill_type_lv:removeAllChildren(true)
    --Text_skill_infor:setString(self._info.dec)
    Text_skill_infor:setString("")
    Text_skill_infor:removeAllChildren(true)
    local fontName = Text_skill_infor:getFontName()
    local fontSize = Text_skill_infor:getFontSize()
    local dec_info = zstring.split(self._info.dec, "!x@")
    local _richText_1 = ccui.RichText:create()
    _richText_1:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,dec_info[1], fontName,fontSize)
    _richText_1:pushBackElement(re1)
    local re2 = nil 
    if #dec_info > 1 then
        local talent_info = zstring.split(dms.string(dms["talent_mould"], self._info.to_skill_id, talent_mould.base_additional), ",")
        local add_attr = tonumber(talent_info[2]) * level
        for k, v in pairs(attribute_hundred) do
            if v == tonumber(talent_info[1]) then
                add_attr = ""..add_attr.."%"
                break
            end
        end

        re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[8][1],color_Type[8][2],color_Type[8][3]),255,"+"..add_attr, fontName,fontSize)
        _richText_1:pushBackElement(re2)
    end
    _richText_1:setPosition(cc.p(Text_skill_infor:getContentSize().width/2,Text_skill_infor:getContentSize().height/2))
    _richText_1:setContentSize(cc.size(Text_skill_infor:getContentSize().width,fontSize))
    Text_skill_infor:addChild(_richText_1)

    Text_have_n:setString(""..(level + 1))
    Panel_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,3,self._info.id,2})
    Panel_icon:addChild(cell) 

    local _richText_3 = ccui.RichText:create()
    _richText_3:ignoreContentAdaptWithSize(false) 
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, self._info.skill_name, "fonts/simhei.ttf",24)
    _richText_3:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "  "..string.format(red_alert_all_str[13], ""..level), "fonts/simhei.ttf",24)
    _richText_3:pushBackElement(re2)
    _richText_3:setPosition(cc.p(Text_skill_type_lv:getContentSize().width/2,Text_skill_type_lv:getContentSize().height/2))
    _richText_3:setContentSize(cc.size(Text_skill_type_lv:getContentSize().width,24))
    Text_skill_type_lv:addChild(_richText_3)

    if level >= zstring.tonumber(_ED.user_info.user_grade) then
        Button_up:setBright(false)
    else
        Button_up:setBright(true)
    end
end

function PlayerSkillUpgradeCell:onEnterTransitionFinish()

end

function PlayerSkillUpgradeCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.player.player_skill_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if PlayerSkillUpgradeCell.__size == nil then
		PlayerSkillUpgradeCell.__size = root:getContentSize()
	end
    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_up"), nil, 
    {
        terminal_name = "player_skill_upgrade_upgrade",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

	self:onUpdateDraw()
end

function PlayerSkillUpgradeCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.player.player_skill_cell, root)
end

function PlayerSkillUpgradeCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PlayerSkillUpgradeCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    local Text_skill_type_lv = ccui.Helper:seekWidgetByName(root, "Text_skill_type_lv")
    local Text_skill_infor = ccui.Helper:seekWidgetByName(root, "Text_skill_infor")
    local Text_have_n = ccui.Helper:seekWidgetByName(root, "Text_have_n")
    local Button_up = ccui.Helper:seekWidgetByName(root, "Button_up")
    if Panel_icon ~= nil then
        Panel_icon:removeAllChildren(true)
        Text_skill_type_lv:setString("")
        Text_skill_infor:setString("")
        Text_skill_infor:removeAllChildren(true)
        Text_have_n:setString("")
        Button_up:setBright(true)
    end
end

function PlayerSkillUpgradeCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.player.player_skill_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function PlayerSkillUpgradeCell:init(params)
    self._index = params[1]
    self._info = params[2]
    if self._index <= 6 then
        self:onInit()
    end
	self:setContentSize(PlayerSkillUpgradeCell.__size)
end

