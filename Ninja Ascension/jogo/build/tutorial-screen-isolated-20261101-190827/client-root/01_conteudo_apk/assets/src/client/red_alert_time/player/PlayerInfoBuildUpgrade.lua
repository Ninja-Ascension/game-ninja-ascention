--------------------------------------------------------------------------------------------------------------
--  说明：角色建筑快速升级
--------------------------------------------------------------------------------------------------------------
PlayerInfoBuildUpgrade = class("PlayerInfoBuildUpgradeClass", Window)

--打开界面
local player_info_build_upgrade_open_terminal = {
	_name = "player_info_build_upgrade_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = PlayerInfoBuildUpgrade:new():init(params)
        fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_info_build_upgrade_close_terminal = {
	_name = "player_info_build_upgrade_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerInfoBuildUpgradeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_info_build_upgrade_open_terminal)
state_machine.add(player_info_build_upgrade_close_terminal)
state_machine.init()

function PlayerInfoBuildUpgrade:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0
    self._Image_player_build_arrow_down = nil
    self._Image_player_build_arrow_up = nil

    self._last_state = 0

    self._Text_time_n = nil
    self._auto_upgrade_time = 0

    app.load("client.red_alert_time.cells.player.player_build_upgrade_cell")
    app.load("client.red_alert_time.cells.props.props_icon_cell")
    local function init_play_info_build_upgrade_terminal()
        local player_info_build_upgrade_show_terminal = {
            _name = "player_info_build_upgrade_show",
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

        local player_info_build_upgrade_hide_terminal = {
            _name = "player_info_build_upgrade_hide",
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

        -- 刷新界面
        local player_info_build_upgrade_update_draw_terminal = {
            _name = "player_info_build_upgrade_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local posY = instance.listview_poy
                instance:updateDraw()
                if math.abs(posY) > math.abs(instance.listview_height) then
                    posY = instance.listview_height
                end
                instance.listview:getInnerContainer():setPositionY(posY)    
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 开启
        local player_info_build_open_auto_upgrade_terminal = {
            _name = "player_info_build_open_auto_upgrade",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if zstring.tonumber(_ED.build_auto_upgrade_state) == 0 
                    and zstring.tonumber(_ED.build_auto_upgrade_time) > 0 then
                    state_machine.excute("player_info_build_open_auto_pause", 0, nil)
                    return
                end
                local prop_id = dms.int(dms["prop_config"], 10, prop_config.param)
                local prop_count = 0
                local prop = fundPropWidthId(prop_id)
                if prop ~= nil then
                    prop_count = zstring.tonumber(prop.prop_number)
                end
                if prop_count <= 0 then
                    local shop_of_gold = dms.int(dms["prop_mould"], prop_id, prop_mould.shop_of_gold)
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.costOpenAutoUpgrade, string.format(red_alert_all_str[299], shop_of_gold))
                    fwin:open(tip, fwin._windows)
                else
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                response.node:updateDraw()
                                response.node:updateAutoUpgradeInfo()
                            end
                            state_machine.excute("main_window_update_quick_info", 0, nil)
                        end
                    end
                    protocol_command.prop_use.param_list = prop.user_prop_id.."\r\n".."1"
                    NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, instance, responseCallback, false, nil)    
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 暂停
        local player_info_build_open_auto_pause_terminal = {
            _name = "player_info_build_open_auto_pause",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:updateDraw()
                            response.node:updateAutoUpgradeInfo()
                        end
                    end
                end
                if zstring.tonumber(_ED.build_auto_upgrade_time) > 0 then
                    NetworkManager:register(protocol_command.build_auto_update.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 购买并使用
        local player_info_build_cost_open_auto_upgrade_terminal = {
            _name = "player_info_build_cost_open_auto_upgrade",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local prop_id = dms.int(dms["prop_config"], 10, prop_config.param)
                local shop_of_gold = dms.int(dms["prop_mould"], prop_id, prop_mould.shop_of_gold)
                local tip = ConfirmTip:new()
                tip:init(instance, instance.costOpenAutoUpgrade, string.format(red_alert_all_str[298], shop_of_gold))
                fwin:open(tip, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新VIP队列显示
        local player_info_build_update_VIP_info_terminal = {
            _name = "player_info_build_update_VIP_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateVIPInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_info_build_upgrade_show_terminal)
        state_machine.add(player_info_build_upgrade_hide_terminal)
        state_machine.add(player_info_build_upgrade_update_draw_terminal)
        state_machine.add(player_info_build_open_auto_upgrade_terminal)
        state_machine.add(player_info_build_open_auto_pause_terminal)
        state_machine.add(player_info_build_cost_open_auto_upgrade_terminal)
        state_machine.add(player_info_build_update_VIP_info_terminal)
        state_machine.init()
    end
    
    init_play_info_build_upgrade_terminal()
end

function PlayerInfoBuildUpgrade:costOpenAutoUpgrade( sure_number )
    local function responseBuyCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            local function responseCallback( response )
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if response.node ~= nil and response.node.roots ~= nil then
                        response.node:updateDraw()
                        response.node:updateAutoUpgradeInfo()
                    end
                    _ED.show_reward_list_group_ex = {}
                    state_machine.excute("main_window_update_quick_info", 0, nil)
                end
            end
            local prop_id = dms.int(dms["prop_config"], 10, prop_config.param)
            local prop = fundPropWidthId(prop_id)
            if prop ~= nil then
                protocol_command.prop_use.param_list = prop.user_prop_id.."\r\n".."1"
                NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, response.node, responseCallback, false, nil)    
            end
        end
    end
    if sure_number == 0 then
        local user_prop_id = dms.int(dms["prop_config"], 15, prop_config.param)
        protocol_command.avatar_shop_buy.param_list = user_prop_id.."\r\n1"
        NetworkManager:register(protocol_command.avatar_shop_buy.code, nil, nil, nil, self, responseBuyCallback, false, nil)
    end
end

function PlayerInfoBuildUpgrade:refreshListView( ... )
    local root = self.roots[1]
    local ListView = ccui.Helper:seekWidgetByName(root,"ListView_player_build")
    ListView:jumpToTop()
    ListView:getInnerContainer():setPositionY(ListView:getInnerContainer():getPositionY() - 1)
    ListView:requestRefreshView()
end

function PlayerInfoBuildUpgrade:updateDraw()
    local root = self.roots[1]
    local ListView = ccui.Helper:seekWidgetByName(root,"ListView_player_build")
    ListView:jumpToTop()
    ListView:removeAllItems()
    local index = 0
    local upgrade_list = {}
    local other_list = {}
    local not_upgrade_list = {}
    local lock_list = {}                -- 未解锁

    for k,v in pairs(_ED.home_build) do
        local base_mould_info = _ED.base_build_info[""..v.build_mould_id]
        local base_build_level_info = _ED.base_build_level_info["".._ED.home_build[""..v.base_mould_id].level]
        if tonumber(base_mould_info.max_level) >= 1 
            and tonumber(v.base_mould_id) ~= 2
            then
            if zstring.tonumber(v.update_state) == 1 then
                table.insert(upgrade_list, v)
            else
                -- 判断建筑是否满级
                if _ED.home_build[""..v.base_mould_id].level >= base_mould_info.max_level then
                else
                    if funOpenDrawTip(base_mould_info.fun_open_tab_id, false) == true then
                        table.insert(lock_list, v)
                    else
                        local need_iron = base_mould_info.cost_iron_factor * base_build_level_info.cost     -- 需要铁矿
                        local need_oil = base_mould_info.cost_oil_factor * base_build_level_info.cost       -- 需要石油
                        local need_lead = base_mould_info.cost_lead_factor * base_build_level_info.cost     -- 需要铅矿
                        if need_iron > tonumber(_ED.user_info.user_iron) 
                            or need_oil > tonumber(_ED.user_info.oil_field) 
                            or need_lead > tonumber(_ED.user_info.exploits) 
                            then
                            table.insert(not_upgrade_list, v)
                        else
                            if tonumber(v.base_mould_id) ~= 1 then
                                if _ED.home_build[""..v.base_mould_id].level + 1 > zstring.tonumber(_ED.home_build["1"].level) then
                                    table.insert(not_upgrade_list, v)
                                else
                                    table.insert(other_list, v)
                                end
                            else
                                table.insert(other_list, v)
                            end
                        end
                    end
                end
            end
        end
    end

    -- 升级中按剩余升级时间从小到大排序
    local now_time = os.time()
    local function sortUpgrade( a, b )
        return (tonumber(a.update_time_cd) +tonumber(a.update_start_time)) < (tonumber(b.update_time_cd) +tonumber(b.update_start_time))
    end
    table.sort(upgrade_list, sortUpgrade)

    -- 可升级按建筑等级从小到大排序
    local function sortFunc( a, b )
        return tonumber(a.level) < tonumber(b.level)
    end
    table.sort(other_list, sortFunc)

    -- 不可升级按建筑等级从小到大排序
    local function sortNotUpgrade( a, b )
        return tonumber(a.level) < tonumber(b.level)
    end
    table.sort(not_upgrade_list, sortNotUpgrade)

    self.listview_height = 0
    for k,v in pairs(upgrade_list) do
        index = index + 1
        local cell = state_machine.excute("player_build_upgrade_create_cell", 0, {index, v, true})
        ListView:addChild(cell)
    end

    for k,v in pairs(other_list) do
        index = index + 1
        local cell = state_machine.excute("player_build_upgrade_create_cell", 0, {index, v, true})
        ListView:addChild(cell)
    end

    for k,v in pairs(not_upgrade_list) do
        index = index + 1
        local cell = state_machine.excute("player_build_upgrade_create_cell", 0, {index, v, false})
        ListView:addChild(cell)
    end

    for k,v in pairs(lock_list) do
        index = index + 1
        local cell = state_machine.excute("player_build_upgrade_create_cell", 0, {index, v, false})
        ListView:addChild(cell)
    end
    ListView:requestRefreshView()
    self.listview = ListView
    self.listview_poy = ListView:getInnerContainer():getPositionY()
    self.listview_height = ListView:getInnerContainer():getPositionY()
end

function PlayerInfoBuildUpgrade:updateAutoUpgradeInfo()
    self._last_state = _ED.build_auto_upgrade_state
    local root = self.roots[1]
    local Text_state = ccui.Helper:seekWidgetByName(root, "Text_state")
    local Text_build_num = ccui.Helper:seekWidgetByName(root, "Text_build_num")
    local Button_open = ccui.Helper:seekWidgetByName(root, "Button_open")
    local Button_suspend = ccui.Helper:seekWidgetByName(root, "Button_suspend")
    self._Text_time_n = ccui.Helper:seekWidgetByName(root, "Text_time_n")

    -- 道具数量
    local prop_id = dms.int(dms["prop_config"], 10, prop_config.param)
    local prop_count = zstring.tonumber(getPropAllCountByMouldId(prop_id))
    Text_build_num:setString(""..prop_count)
	-- icon
	local Panel_auto_build_icon = ccui.Helper:seekWidgetByName(root, "Panel_auto_build_icon")
    Panel_auto_build_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{1,1,prop_id,1})
    Panel_auto_build_icon:addChild(cell) 
    -- 购买价格
    local Text_gold_n = ccui.Helper:seekWidgetByName(root, "Text_gold_n")
    local need_gold = dms.string(dms["prop_mould"], prop_id, prop_mould.shop_of_gold)
    Text_gold_n:setString(need_gold)

    if zstring.tonumber(_ED.build_auto_upgrade_state) == 0 
        and zstring.tonumber(_ED.build_auto_upgrade_time) == 0 then
        Button_suspend:setVisible(false)
        Button_open:setVisible(true)
        Button_open:setTitleText(red_alert_all_str[302])
        Text_state:setString(red_alert_all_str[303])
        Text_state:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        self._auto_upgrade_time = 0
    elseif zstring.tonumber(_ED.build_auto_upgrade_state) == 1 then
        Button_suspend:setVisible(true)
        Button_open:setVisible(false)
        Text_state:setString(red_alert_all_str[302])
        Text_state:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
        self._auto_upgrade_time = zstring.tonumber(_ED.build_auto_upgrade_time)/1000 - (os.time() + _ED.time_add_or_sub)
    else
        self._auto_upgrade_time = zstring.tonumber(_ED.build_auto_upgrade_cd)/1000
        Button_suspend:setVisible(false)
        Button_open:setVisible(true)
        Button_open:setTitleText(red_alert_all_str[302])
        Text_state:setString(red_alert_all_str[301])
        Text_state:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    end
    if self._auto_upgrade_time == 0 then
        self._Text_time_n:setString("0s")
    else
        self._Text_time_n:setString(exChangeTimeToString(self._auto_upgrade_time))
    end
end

function PlayerInfoBuildUpgrade:updateVIPInfo()
    local root = self.roots[1]
    local Text_promp_n = ccui.Helper:seekWidgetByName(root, "Text_promp_n")
    Text_promp_n:removeAllChildren(true)
    local build_queue_times = tonumber(_ED.home_build_max_count)
    local _richText_1 = ccui.RichText:create()
    _richText_1:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255,_string_piece_info[228] .. _ED.vip_grade, "fonts/simhei.ttf",22)
    _richText_1:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, string.format(red_alert_all_str[283],build_queue_times), "fonts/simhei.ttf",22)
    _richText_1:pushBackElement(re2)
    local info = _string_piece_info[228] .. _ED.vip_grade .. string.format(red_alert_all_str[283],build_queue_times)
    local len_size = 0
    local map = string.utf8.chars(info)
    for i,v in pairs(map) do
        local len = string.len(v)
        if string.len(v) > 1 then
            len = string.len(v) - 1
        end
        len_size = len_size + len
    end
    _richText_1:setPosition(cc.p(Text_promp_n:getContentSize().width/2+120-len_size*3,Text_promp_n:getContentSize().height/2))
    _richText_1:setContentSize(cc.size(Text_promp_n:getContentSize().width,22))
    Text_promp_n:addChild(_richText_1)
end

function PlayerInfoBuildUpgrade:onUpdate(dt)
    if self._Text_time_n ~= nil
        and zstring.tonumber(_ED.build_auto_upgrade_state) == 1 then
        self._auto_upgrade_time = self._auto_upgrade_time - dt
        if self._auto_upgrade_time >= 0 then
            self._Text_time_n:setString(exChangeTimeToString(self._auto_upgrade_time))
        end
    end
    if tonumber(self._last_state) ~= zstring.tonumber(_ED.build_auto_upgrade_state) then
        self:updateAutoUpgradeInfo()
    end
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_player_build_arrow_down:setVisible(true)
        else
            self._Image_player_build_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_player_build_arrow_up:setVisible(true)
        else
            self._Image_player_build_arrow_up:setVisible(false)
        end
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
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
function PlayerInfoBuildUpgrade:onInit()
    local csbItem = csb.createNode(string.format(config_csb.player.player_infor_tab, "3"))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    -- 开启
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_open"), nil, 
    {
        terminal_name = "player_info_build_open_auto_upgrade", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
        touch_black = true, 
    }, nil, 1)
    -- 暂停
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_suspend"), nil, 
    {
        terminal_name = "player_info_build_open_auto_pause", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
        touch_black = true, 
    }, nil, 1)

    -- 购买并使用
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_medal"), nil, 
    {
        terminal_name = "player_info_build_cost_open_auto_upgrade", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95, 
        touch_black = true, 
    }, nil, 1)

    self._Image_player_build_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_player_build_arrow_down")
    self._Image_player_build_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_player_build_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_player_build_arrow_down:stopAllActions()
    self._Image_player_build_arrow_up:stopAllActions()
    playActions(self._Image_player_build_arrow_down)
    playActions(self._Image_player_build_arrow_up)
    self._Image_player_build_arrow_down:setVisible(false)
    self._Image_player_build_arrow_up:setVisible(false)

    self:updateDraw()
    self:updateAutoUpgradeInfo()
    self:updateVIPInfo()
end

function PlayerInfoBuildUpgrade:onEnterTransitionFinish()

end

function PlayerInfoBuildUpgrade:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function PlayerInfoBuildUpgrade:onExit()
    state_machine.remove("player_info_build_upgrade_show")
    state_machine.remove("player_info_build_upgrade_hide")
    state_machine.remove("player_info_build_upgrade_update_draw")
    state_machine.remove("player_info_build_open_auto_upgrade")
    state_machine.remove("player_info_build_cost_open_auto_upgrade")
    state_machine.remove("player_info_build_open_auto_pause")
    state_machine.remove("player_info_build_update_VIP_info")
end