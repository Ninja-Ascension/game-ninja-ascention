--------------------------------------------------------------------------------------------------------------
--  说明：角色技能详情
--------------------------------------------------------------------------------------------------------------
PlayerInfoSkill = class("PlayerInfoSkillClass", Window)

--打开界面
local player_info_skill_open_terminal = {
	_name = "player_info_skill_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = PlayerInfoSkill:new():init(params)
        fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_info_skill_close_terminal = {
	_name = "player_info_skill_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerInfoSkillClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_info_skill_open_terminal)
state_machine.add(player_info_skill_close_terminal)
state_machine.init()

function PlayerInfoSkill:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    app.load("client.red_alert_time.cells.player.player_skill_upgrade_cell")
    local function init_play_info_skill_terminal()
        local player_info_skill_show_terminal = {
            _name = "player_info_skill_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local player_info_skill_hide_terminal = {
            _name = "player_info_skill_hide",
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

        local player_info_skill_reset_skill_terminal = {
            _name = "player_info_skill_reset_skill",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cost = dms.int(dms["major_city_config"], 19, major_city_config.param)
                local tip = ConfirmTip:new()
                tip:init(instance, instance.sureReset, string.format(red_alert_all_str[287], cost))
                fwin:open(tip, fwin._windows) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local player_info_skill_goto_shop_terminal = {
            _name = "player_info_skill_goto_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("short_cut_go_to_other_window",0,{17,4})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local player_info_skill_update_skill_point_terminal = {
            _name = "player_info_skill_update_skill_point",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateOtherInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_info_skill_show_terminal)
        state_machine.add(player_info_skill_hide_terminal)
        state_machine.add(player_info_skill_reset_skill_terminal)
        state_machine.add(player_info_skill_update_skill_point_terminal)
        state_machine.add(player_info_skill_goto_shop_terminal)
        state_machine.init()
    end
    
    init_play_info_skill_terminal()
end

function PlayerInfoSkill:sureReset(sure_number)
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                response.node:updateDraw()
                response.node:updateOtherInfo()
            end
            checkRewardObtainDraw()
            TipDlg.drawTextDailog(red_alert_time_str[216])
        end
    end
    if sure_number == 0 then
        NetworkManager:register(protocol_command.majesty_skill_reset.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function PlayerInfoSkill:updateOtherInfo( ... )
    local root = self.roots[1]
    local Text_skill_medal_n = ccui.Helper:seekWidgetByName(root, "Text_skill_medal_n")
    local prop_id = dms.int(dms["prop_config"], 9, prop_config.param)
    Text_skill_medal_n:setString(getPropAllCountByMouldId(prop_id))
end

function PlayerInfoSkill:refreshListView( ... )
    local root = self.roots[1]
    local ListView = ccui.Helper:seekWidgetByName(root, "ListView_skill")
    ListView:jumpToTop()
end

function PlayerInfoSkill:updateDraw()
    local root = self.roots[1]
    local ListView = ccui.Helper:seekWidgetByName(root,"ListView_skill")
    ListView:jumpToTop()
    ListView:removeAllItems()
    -- 技能排序
    local result = {}
    for k, v in pairs(_ED.base_skill_info) do
        table.insert(result, v)
    end
    function sortByIndex(a, b)
        return a.index < b.index
    end
    table.sort(result, sortByIndex)
    local index = 0
    for k,v in pairs(result) do
        index = index + 1
        local cell = state_machine.excute("player_skill_upgrade_create_cell", 0, {index, v})
        ListView:addChild(cell)
    end

    ListView:requestRefreshView()
    self._list_view = ListView
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function PlayerInfoSkill:onUpdate( dt )
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_skill_arrow_down:setVisible(true)
        else
            self._Image_skill_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_skill_arrow_up:setVisible(true)
        else
            self._Image_skill_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

--初始化
function PlayerInfoSkill:onInit()
    local csbItem = csb.createNode(string.format(config_csb.player.player_infor_tab, "2"))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_medal"), nil, 
    {
        terminal_name = "player_info_skill_goto_shop", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reset_medal"), nil, 
    {
        terminal_name = "player_info_skill_reset_skill", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self._Image_skill_arrow_up = ccui.Helper:seekWidgetByName(root,"Image_skill_arrow_up")
    self._Image_skill_arrow_down = ccui.Helper:seekWidgetByName(root,"Image_skill_arrow_down")

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_skill_arrow_down:stopAllActions()
    self._Image_skill_arrow_up:stopAllActions()
    playActions(self._Image_skill_arrow_down)
    playActions(self._Image_skill_arrow_up)
    self._Image_skill_arrow_down:setVisible(false)
    self._Image_skill_arrow_up:setVisible(false)

    self:updateDraw()
    self:updateOtherInfo()
end

function PlayerInfoSkill:onEnterTransitionFinish()

end

function PlayerInfoSkill:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function PlayerInfoSkill:onExit()
    state_machine.remove("player_info_skill_show")
    state_machine.remove("player_info_skill_hide")
    state_machine.remove("player_info_skill_reset_skill")
    state_machine.remove("player_info_skill_update_skill_point")
    state_machine.remove("player_info_skill_goto_shop")
end