--------------------------------------------------------------------------------------------------------------
--  说明：角色战斗力详情
--------------------------------------------------------------------------------------------------------------
PlayerFight = class("PlayerFightClass", Window)

--打开界面
local player_fight_open_terminal = {
	_name = "player_fight_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("PlayerFightClass") == nil then
                    fwin:open(PlayerFight:new():init(params), fwin._ui)  
                end
            end
        end
        protocol_command.order_get_info.param_list = "0"
        NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, self, responseCallback, false, nil)
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_fight_close_terminal = {
	_name = "player_fight_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerFightClass"))
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_fight_open_terminal)
state_machine.add(player_fight_close_terminal)
state_machine.init()

function PlayerFight:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    app.load("client.red_alert_time.cells.player.player_fight_cell")
    app.load("client.red_alert_time.cells.player.player_fight_classify_cell")
    app.load("client.red_alert_time.player.PlayerFightTip")
    app.load("client.red_alert_time.player.PlayerFightInfor")
    local function init_play_info_skill_terminal()
        local player_fight_show_terminal = {
            _name = "player_fight_show",
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

        local player_fight_hide_terminal = {
            _name = "player_fight_hide",
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

        -- 刷新
        local player_fight_update_draw_terminal = {
            _name = "player_fight_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local posY = instance._list_view_poy
                instance:updateDraw()
                if math.abs(posY) > math.abs(instance._list_view_height) then
                    posY = instance._list_view_height
                end
                instance._list_view:getInnerContainer():setPositionY(posY)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_fight_show_terminal)
        state_machine.add(player_fight_hide_terminal)
        state_machine.add(player_fight_update_draw_terminal)
        state_machine.init()
    end
    
    init_play_info_skill_terminal()
end

function PlayerFight:refreshListView()
    local root = self.roots[1]
    local ListView = ccui.Helper:seekWidgetByName(root, "ListView_fight_up")
    ListView:jumpToTop()
end

function PlayerFight:showCurrentMaxFight()
    local root = self.roots[1]
    local Text_fight_battle_n = ccui.Helper:seekWidgetByName(root, "Text_fight_battle_n")

    local result = {}
    local leaders = {}
    for k,v in pairs(_ED.user_ship) do
        local last_count = zstring.tonumber(v.current_count)
        if v.captain_type ~= 3 then
            local index = 0
            while last_count > 0 and index < 6 do
                last_count = last_count - tonumber(_ED.user_info.soldier)
                if last_count >= 0 then
                    table.insert(result, {ship = v, count = tonumber(_ED.user_info.soldier)})
                else
                    table.insert(result, {ship = v, count = last_count + tonumber(_ED.user_info.soldier)})
                end
                index = index + 1
            end
        else
            if last_count > 0 then
                table.insert(leaders, {ship = v})
            end
        end
    end

    for k, v in pairs(result) do
        v.fight_number = tonumber(getShipFightNumber(v.ship, tonumber(v.count)))
    end
    for k, v in pairs(leaders) do
        v.fight_number = tonumber(getLeaderFighting(v.ship))
    end

    function sortFight( a, b )
        return a.fight_number > b.fight_number
    end
    table.sort(result, sortFight)
    table.sort(leaders, sortFight)


    local choose_formation = {}
    for k,v in pairs(result) do
        if k > 6 then
            break
        end
        table.insert(choose_formation, {ship = v.ship, choose_count = v.count})
    end
    for k,v in pairs(leaders) do
        if k > 6 then
            break
        end
        if choose_formation[k] ~= nil then
            choose_formation[k].leader = v.ship
        end
    end

    local all_fight_number = 0
    for k, info in pairs(choose_formation) do
        if info.ship ~= nil then
            all_fight_number = all_fight_number + getShipFightNumber(info.ship, info.choose_count, info.leader, k)
        end
    end
    all_fight_number = math.ceil(all_fight_number)
    Text_fight_battle_n:setString(all_fight_number.."("..exChangeNumToString(all_fight_number)..")")

end

function PlayerFight:updateDraw()
    local root = self.roots[1]
    -- 当前战斗力
    local Text_fight_now_n = ccui.Helper:seekWidgetByName(root, "Text_fight_now_n")
    Text_fight_now_n:setString(_ED.user_info.fighter_capacity.."("..exChangeNumToString(_ED.user_info.fighter_capacity)..")")

    local dec = " "..red_alert_time_str[1].." "
    local user_rank = 0
    local quality = 6
    if _ED.fight_ranks ~= nil 
        and _ED.fight_ranks.my_info ~= nil 
        then
        user_rank = _ED.fight_ranks.my_info.now_rank
    end
    if user_rank > 0 then
        dec = " "..user_rank.." "
        quality = 1
    end
    -- 战斗力排行榜
    local Text_fight_rank_n = ccui.Helper:seekWidgetByName(root, "Text_fight_rank_n")
    Text_fight_rank_n:removeAllChildren(true)
    local _richText_1 = ccui.RichText:create()
    _richText_1:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]),255,dec, "fonts/simhei.ttf",24)
    _richText_1:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255,red_alert_time_str[193], "fonts/simhei.ttf",24)
    _richText_1:pushBackElement(re2)
    _richText_1:setPosition(cc.p(Text_fight_rank_n:getContentSize().width/2,Text_fight_rank_n:getContentSize().height/2))
    _richText_1:setContentSize(cc.size(Text_fight_rank_n:getContentSize().width,24))
    Text_fight_rank_n:addChild(_richText_1)

    local ListView = ccui.Helper:seekWidgetByName(root,"ListView_fight_up")
    ListView:jumpToTop()
    ListView:removeAllItems()

    for i = 1, 3 do
        local cell = state_machine.excute("player_fight_classify_cell_create", 0, {i})
        ListView:addChild(cell)
    end

    ListView:requestRefreshView()
    self._list_view = ListView
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self:showCurrentMaxFight()
end

function PlayerFight:onUpdate( dt )
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_production_arrow_down:setVisible(true)
        else
            self._Image_production_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_production_arrow_up:setVisible(true)
        else
            self._Image_production_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        -- local items = self._list_view:getItems()
        -- if items[1] == nil then
        --     return
        -- end
        -- local itemSize = items[1]:getContentSize()
        -- for i, v in pairs(items) do
        --     local tempY = v:getPositionY() + posY
        --     if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
        --         v:unload()
        --     else
        --         v:reload()
        --     end
        -- end
    end
end

--初始化
function PlayerFight:onInit()
    local csbItem = csb.createNode(config_csb.player.player_fight)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fight_close"), nil, 
    {
        terminal_name = "player_fight_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    -- 战斗力排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fight_rank"), nil, 
    {
        terminal_name = "rank_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        list_type = 1,
    }, nil, 1)

    -- 说明
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fight_infor"), nil, 
    {
        terminal_name = "player_fight_infor_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self._Image_production_arrow_up = ccui.Helper:seekWidgetByName(root,"Image_production_arrow_up")
    self._Image_production_arrow_down = ccui.Helper:seekWidgetByName(root,"Image_production_arrow_down")

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_production_arrow_down:stopAllActions()
    self._Image_production_arrow_up:stopAllActions()
    playActions(self._Image_production_arrow_down)
    playActions(self._Image_production_arrow_up)
    self._Image_production_arrow_down:setVisible(false)
    self._Image_production_arrow_up:setVisible(false)

    self:updateDraw()
end

function PlayerFight:onEnterTransitionFinish()

end

function PlayerFight:init(param)
    self._rootWindows = param[1]
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function PlayerFight:onExit()
    state_machine.remove("player_fight_show")
    state_machine.remove("player_fight_hide")
    state_machine.remove("player_fight_update_draw")
end