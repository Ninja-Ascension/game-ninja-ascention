-- ------------------------------------------------------------------------------------------------------------
--  说明：消费转盘排行
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeConsumptionTurntableRank = class("RedAlertTimeConsumptionTurntableRankClass", Window)

--打开界面
local red_alert_time_consumption_turntable_rank_open_terminal = {
    _name = "red_alert_time_consumption_turntable_rank_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = RedAlertTimeConsumptionTurntableRank:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_consumption_turntable_rank_open_terminal)
state_machine.init()

function RedAlertTimeConsumptionTurntableRank:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_seek_rank_arrow_down = nil
    self._Image_seek_rank_arrow_up = nil
	
	app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_seek_treasure_rank_cell")

    local function init_red_alert_time_consumption_turntable_rank_terminal()
        local red_alert_time_consumption_turntable_rank_show_terminal = {
            _name = "red_alert_time_consumption_turntable_rank_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                local acitvity = _ED.activity_info[""..self._activity_type.activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..instance._activity_type.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."2"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_consumption_turntable_rank_hide_terminal = {
            _name = "red_alert_time_consumption_turntable_rank_hide",
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

        local red_alert_time_consumption_turntable_rank_update_draw_terminal = {
            _name = "red_alert_time_consumption_turntable_rank_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local posY = instance._list_view_poy
                instance:onUpdateDraw()
                if math.abs(posY) > math.abs(instance._list_view_height) then
                    posY = instance._list_view_height
                end
                instance._list_view:getInnerContainer():setPositionY(posY)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_consumption_turntable_rank_update_rank_info_terminal = {
            _name = "red_alert_time_consumption_turntable_rank_update_rank_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateRankInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_consumption_turntable_rank_show_terminal)
        state_machine.add(red_alert_time_consumption_turntable_rank_hide_terminal)
        state_machine.add(red_alert_time_consumption_turntable_rank_update_draw_terminal)
        state_machine.add(red_alert_time_consumption_turntable_rank_update_rank_info_terminal)
        state_machine.init()
    end
    init_red_alert_time_consumption_turntable_rank_terminal()
end

function RedAlertTimeConsumptionTurntableRank:onUpdateRankInfo()
    local root = self.roots[1]
    -- 玩家自己的排名信息
    local Text_seek_treasure_rank_me_t_2 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_2")
    local Text_seek_treasure_rank_me_t_6 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_6")
    local Text_seek_treasure_rank_me_t_4 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_4")
	Text_seek_treasure_rank_me_t_2:setString("")
	Text_seek_treasure_rank_me_t_6:setString("")
	Text_seek_treasure_rank_me_t_4:setString("")
	
	--已有积分
	local datas = zstring.split(_ED.activity_info[""..self._activity_type.activity_type].activity_add_state, ",")
	Text_seek_treasure_rank_me_t_2:setString(math.floor(datas[6]))
	--最低进榜
	Text_seek_treasure_rank_me_t_6:setString(datas[12])
	--我的排名
	Text_seek_treasure_rank_me_t_4:setString(activity_str_tip[40])
	if zstring.tonumber(datas[13]) > 0 then
		Text_seek_treasure_rank_me_t_4:setString(datas[13])
	end

end

function RedAlertTimeConsumptionTurntableRank:onUpdateDraw()
    local root = self.roots[1]

    local ListView_seek_treasure_rank = ccui.Helper:seekWidgetByName(root, "ListView_seek_treasure_rank")
    self._list_view = ListView_seek_treasure_rank
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()
	local index = 0
	for i,v in pairs(_ED.integral_carousel_ranking) do
		index = index + 1
        local cell = state_machine.excute("red_alert_time_seek_treasure_rank_cell_create", 0, {v,_ED.activity_info[""..self._activity_type.activity_type],index})
        self._list_view:addChild(cell)
	end
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()

    self:onUpdateRankInfo()
end

function RedAlertTimeConsumptionTurntableRank:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_seek_rank_arrow_down:setVisible(true)
        else
            self._Image_seek_rank_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_seek_rank_arrow_up:setVisible(true)
        else
            self._Image_seek_rank_arrow_up:setVisible(false)
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

function RedAlertTimeConsumptionTurntableRank:onInit()
    local csbItem = csb.createNode(string.format(config_csb.treasurehouse.seek_treasure_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_seek_rank_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_seek_rank_arrow_down")
    self._Image_seek_rank_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_seek_rank_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_seek_rank_arrow_down:stopAllActions()
    self._Image_seek_rank_arrow_up:stopAllActions()
    playActions(self._Image_seek_rank_arrow_down)
    playActions(self._Image_seek_rank_arrow_up)
    self._Image_seek_rank_arrow_down:setVisible(false)
    self._Image_seek_rank_arrow_up:setVisible(false)

	local acitvity = _ED.activity_info[""..self._activity_type.activity_type]
	local function responseCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots ~= nil then
				self:onUpdateDraw()
			end
		end
	end		
	protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."2"
	NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)  
end

function RedAlertTimeConsumptionTurntableRank:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeConsumptionTurntableRank:onExit()
    state_machine.remove("red_alert_time_consumption_turntable_rank_show")
    state_machine.remove("red_alert_time_consumption_turntable_rank_hide")
    state_machine.remove("red_alert_time_consumption_turntable_rank_update_draw")
    state_machine.remove("red_alert_time_consumption_turntable_rank_update_rank_info")
end