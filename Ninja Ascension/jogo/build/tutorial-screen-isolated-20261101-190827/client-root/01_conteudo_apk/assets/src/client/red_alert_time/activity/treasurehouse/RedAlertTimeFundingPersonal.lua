-- ------------------------------------------------------------------------------------------------------------
--  说明：军资集结个人
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeFundingPersonal = class("RedAlertTimeFundingPersonalClass", Window)

--打开界面
local red_alert_time_funding_personal_open_terminal = {
    _name = "red_alert_time_funding_personal_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = RedAlertTimeFundingPersonal:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_funding_personal_open_terminal)
state_machine.init()

function RedAlertTimeFundingPersonal:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0
    self._Image_funding_aggregation_arrow_down = nil
    self._Image_funding_aggregation_up = nil

	app.load("client.red_alert_time.cells.activity.treasurehouse.red_alert_time_funding_aggregation_reward_cell")

    local function init_red_alert_time_funding_personal_terminal()
        local red_alert_time_funding_personal_show_terminal = {
            _name = "red_alert_time_funding_personal_show",
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

        local red_alert_time_funding_personal_hide_terminal = {
            _name = "red_alert_time_funding_personal_hide",
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

        local red_alert_time_funding_personal_one_key_terminal = {
            _name = "red_alert_time_funding_personal_one_key",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cells
				local acitvity = self._activity_type
				local index = tonumber(params._datas._index)
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							cell:onUpdateDraw()
							checkRewardObtainDraw()
                        end
                        state_machine.excute("notification_center_update", 0, "push_notification_funding_personal")
					end
				end		
				local index = 0 
				for i=1,#self._activity_type.activity_data[2] do
					if tonumber(self._activity_type.activity_data[2][i].achieve_state) == 1 then
						index = tonumber(self._activity_type.activity_data[2][i].achieve_index)-1
						break
					end
				end
				protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..acitvity.activity_type.."\r\n".."1".."\r\n"..index.."\r\n".."1"
				NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_funding_personal_update_draw_terminal = {
            _name = "red_alert_time_funding_personal_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_funding_personal_show_terminal)
        state_machine.add(red_alert_time_funding_personal_hide_terminal)
        state_machine.add(red_alert_time_funding_personal_one_key_terminal)
        state_machine.add(red_alert_time_funding_personal_update_draw_terminal)
        state_machine.init()
    end
    init_red_alert_time_funding_personal_terminal()
end

function RedAlertTimeFundingPersonal:onUpdateDraw()
    local root = self.roots[1]
    local ListView_funding_aggregation_me = ccui.Helper:seekWidgetByName(root,"ListView_funding_aggregation_me")
    self._list_view = ListView_funding_aggregation_me
	ListView_funding_aggregation_me:removeAllItems()
    local isButton = false
	for i=1,#self._activity_type.activity_data[2] do
		local cell = state_machine.excute("red_alert_time_funding_aggregation_reward_cell",0,{self._activity_type.activity_data[2][i],i,self._activity_type.activity_type,2})
		ListView_funding_aggregation_me:addChild(cell)
        if tonumber(self._activity_type.activity_data[2][i].achieve_state) == 1 then
            isButton = true
        end
	end
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
	local Text_recharge_bonus_t_2 = ccui.Helper:seekWidgetByName(root,"Text_recharge_bonus_t_2")
	local datas = zstring.split(self._activity_type.activity_add_state, ",")
	--Text_recharge_bonus_t_2:setString((tonumber(datas[4])/10)..activity_str_tip[43])
    if isButton == true then
        ccui.Helper:seekWidgetByName(root,"Button_funding_aggregation_rec"):setTouchEnabled(true)
        ccui.Helper:seekWidgetByName(root,"Button_funding_aggregation_rec"):setBright(true)
    else
        ccui.Helper:seekWidgetByName(root,"Button_funding_aggregation_rec"):setTouchEnabled(false)
        ccui.Helper:seekWidgetByName(root,"Button_funding_aggregation_rec"):setBright(false)
    end 

    Text_recharge_bonus_t_2:removeAllChildren(true)
    local footSize = Text_recharge_bonus_t_2:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, tonumber(datas[4])/10, config_res.font.font_name, footSize)
    _richText:pushBackElement(re1)
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, activity_str_tip[43], config_res.font.font_name, footSize)
    _richText:pushBackElement(re2)
    _richText:setAnchorPoint(0.5,0.5)
    _richText:setContentSize(cc.size(Text_recharge_bonus_t_2:getContentSize().width, Text_recharge_bonus_t_2:getContentSize().height))
    _richText:setPosition(cc.p(Text_recharge_bonus_t_2:getContentSize().width/2, Text_recharge_bonus_t_2:getContentSize().height/2))
    Text_recharge_bonus_t_2:addChild(_richText)
end

function RedAlertTimeFundingPersonal:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_funding_aggregation_arrow_down:setVisible(true)
        else
            self._Image_funding_aggregation_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_funding_aggregation_up:setVisible(true)
        else
            self._Image_funding_aggregation_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
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


function RedAlertTimeFundingPersonal:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.funding_aggregation_tab_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

	--前往充值
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_funding_aggregation_buy"), nil, 
    {
        terminal_name = "recharge_dialog_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cells = self
    }, nil, 1)
	
	--一键
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_funding_aggregation_rec"), nil, 
    {
        terminal_name = "red_alert_time_funding_personal_one_key", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
		cells = self
    }, nil, 1)

    self._Image_funding_aggregation_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_funding_aggregation_arrow_down")
    self._Image_funding_aggregation_up = ccui.Helper:seekWidgetByName(root, "Image_funding_aggregation_up")
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_funding_aggregation_arrow_down:stopAllActions()
    self._Image_funding_aggregation_up:stopAllActions()
    playActions(self._Image_funding_aggregation_arrow_down)
    playActions(self._Image_funding_aggregation_up)
    self._Image_funding_aggregation_arrow_down:setVisible(false)
    self._Image_funding_aggregation_up:setVisible(false)
	
	self:onUpdateDraw()
end

function RedAlertTimeFundingPersonal:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self._activity_type = params[2]
    self:onInit()
    return self
end

function RedAlertTimeFundingPersonal:onExit()
    state_machine.remove("red_alert_time_funding_personal_show")
    state_machine.remove("red_alert_time_funding_personal_hide")
    state_machine.remove("red_alert_time_funding_personal_one_key")
    state_machine.remove("red_alert_time_funding_personal_update_draw")
end