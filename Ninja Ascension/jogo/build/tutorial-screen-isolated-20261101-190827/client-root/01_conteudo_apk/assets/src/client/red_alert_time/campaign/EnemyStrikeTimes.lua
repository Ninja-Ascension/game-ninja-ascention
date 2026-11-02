--------------------------------------------------------------------------------------------------------------
--  说明：敌军来袭-参战次数
--------------------------------------------------------------------------------------------------------------
EnemyStrikeTimes = class("EnemyStrikeTimesClass", Window)

--打开界面
local enemy_strike_times_open_terminal = {
	_name = "enemy_strike_times_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = EnemyStrikeTimes:new():init(params)
		fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(enemy_strike_times_open_terminal)
state_machine.init()

function EnemyStrikeTimes:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0
    self._Image_rebel_rank_arrow_down = nil
    self._Image_rebel_rank_arrow_up = nil

    local function init_enemy_strike_times_terminal()
        local enemy_strike_times_show_terminal = {
            _name = "enemy_strike_times_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                -- if _ED.user_enemy_strike_boss_info.state ~= 0 then
                    instance:updateDraw()
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_times_hide_terminal = {
            _name = "enemy_strike_times_hide",
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

        local enemy_strike_times_update_info_terminal = {
            _name = "enemy_strike_times_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(enemy_strike_times_show_terminal)
        state_machine.add(enemy_strike_times_hide_terminal)
        state_machine.add(enemy_strike_times_update_info_terminal)
        state_machine.init()
    end
    
    init_enemy_strike_times_terminal()
end

function EnemyStrikeTimes:updateDraw()
    local root = self.roots[1]
    local Text_rebel_week_integral_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_week_integral_n")
    local Text_rebel_last_week_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_last_week_rank_n")
    local Text_rebel_last_week_rank_t = ccui.Helper:seekWidgetByName(root, "Text_rebel_last_week_rank_t")
    local ListView_rebel_week_rank = ccui.Helper:seekWidgetByName(root, "ListView_rebel_week_rank")
    ListView_rebel_week_rank:jumpToTop()
    ListView_rebel_week_rank:removeAllItems()
    Text_rebel_last_week_rank_t:setString(tipStringInfo_campaign_info[7])
    Text_rebel_last_week_rank_n:setString("0")
    Text_rebel_week_integral_n:setString("0")
    
    local user_info = nil
    local index = 1
    local result = {}

    if _ED.user_enemy_strike_boss_info.state == 0 then
        if _ED.user_enemy_strike_rank_info ~= nil and _ED.user_enemy_strike_rank_info.rank_times_list ~= nil then
            for k, v in pairs(_ED.user_enemy_strike_rank_info.rank_times_list) do
                result[""..v.rank] = v
                if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
                    user_info = v
                end
            end
        end
    else
        if _ED.user_enemy_strike_boss_info ~= nil and _ED.user_enemy_strike_boss_info.join_list ~= nil then
            local hurt_result = {}
            for k, v in pairs(_ED.user_enemy_strike_boss_info.join_list) do
                table.insert(hurt_result, v)
            end
            local function sortFunction (a, b)
                return tonumber(a.total_times) > tonumber(b.total_times)
            end
            table.sort(hurt_result, sortFunction)
            for k, v in pairs(hurt_result) do
                result[""..k] = v
                if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
                    user_info = {}
                    user_info.rank = k
                    user_info.total_value = tonumber(v.total_times)
                end
            end
        end
    end


    -- BOSS击杀
    local cell = state_machine.excute("enemy_strike_reward_create_cell", 0, {index, 1, 0, {}})
    ListView_rebel_week_rank:addChild(cell)
    index = index + 1
    for i = 1, dms.count(dms["enemy_boss_reward"]) do
        local cell = state_machine.excute("enemy_strike_reward_create_cell", 0, {index, 3, i, result[""..i]})
        ListView_rebel_week_rank:addChild(cell)
        index = index + 1
    end

    ListView_rebel_week_rank:requestRefreshView()
    self.listview = ListView_rebel_week_rank
    self.listview_poy = ListView_rebel_week_rank:getInnerContainer():getPositionY()
    self.listview_height = ListView_rebel_week_rank:getInnerContainer():getPositionY()

    if user_info == nil then
        Text_rebel_last_week_rank_n:setString("0")
        Text_rebel_week_integral_n:setString(tipStringInfo_campaign_info[4])
    else
        if tonumber(user_info.rank) > 0 then
            Text_rebel_week_integral_n:setString(user_info.rank)
        else
            Text_rebel_week_integral_n:setString(tipStringInfo_campaign_info[4])
        end
        Text_rebel_last_week_rank_n:setString(user_info.total_value)
    end
end

function EnemyStrikeTimes:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_rebel_rank_arrow_down:setVisible(true)
        else
            self._Image_rebel_rank_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_rebel_rank_arrow_up:setVisible(true)
        else
            self._Image_rebel_rank_arrow_up:setVisible(false)
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
function EnemyStrikeTimes:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.enemy_strike_tab, 3))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_rebel_rank_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_rebel_rank_arrow_down")
    self._Image_rebel_rank_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_rebel_rank_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_rebel_rank_arrow_down:stopAllActions()
    self._Image_rebel_rank_arrow_up:stopAllActions()
    playActions(self._Image_rebel_rank_arrow_down)
    playActions(self._Image_rebel_rank_arrow_up)
    self._Image_rebel_rank_arrow_down:setVisible(false)
    self._Image_rebel_rank_arrow_up:setVisible(false)

    local function responseCallback1(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:updateDraw() 
            end
        end
    end
    protocol_command.enemy_boss_rank_list_get.param_list = "1"
    NetworkManager:register(protocol_command.enemy_boss_rank_list_get.code, nil, nil, nil, self, responseCallback1, false, nil)
end

function EnemyStrikeTimes:onEnterTransitionFinish()

end

function EnemyStrikeTimes:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function EnemyStrikeTimes:onExit()
    state_machine.remove("enemy_strike_times_show")
    state_machine.remove("enemy_strike_times_hide")
    state_machine.remove("enemy_strike_times_update_info")
end