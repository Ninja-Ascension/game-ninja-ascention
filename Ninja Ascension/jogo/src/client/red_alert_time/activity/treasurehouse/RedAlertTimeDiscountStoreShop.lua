--------------------------------------------------------------------------------------------------------------
--  说明：折扣卖场界面3
--------------------------------------------------------------------------------------------------------------
RedAlertTimeDiscountStoreShop = class("RedAlertTimeDiscountStoreShopClass", Window)

--打开界面
local red_alert_time_discount_store_shop_open_terminal = {
	_name = "red_alert_time_discount_store_shop_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("RedAlertTimeDiscountStoreShopClass") == nil then
    		fwin:open(RedAlertTimeDiscountStoreShop:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local red_alert_time_discount_store_shop_close_terminal = {
	_name = "red_alert_time_discount_store_shop_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeDiscountStoreShopClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(red_alert_time_discount_store_shop_open_terminal)
state_machine.add(red_alert_time_discount_store_shop_close_terminal)
state_machine.init()

function RedAlertTimeDiscountStoreShop:ctor()
	self.super:ctor()
	self.roots = {}
    self.m_reset_times = 0
    self.text_reset_times = nil
    self.have_golds_text = nil 
    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0
    self._Image_discount_store_shop_arrow_down = nil
    self._Image_discount_store_shop_arrow_up = nil
	
    local function init_red_alert_time_discount_store_shop_terminal()
        local red_alert_time_discount_store_shop_show_terminal = {
            _name = "red_alert_time_discount_store_shop_show",
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

        local red_alert_time_discount_store_shop_hide_terminal = {
            _name = "red_alert_time_discount_store_shop_hide",
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

        --刷新
        local red_alert_time_discount_store_shop_update_terminal = {
            _name = "red_alert_time_discount_store_shop_update",
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

        state_machine.add(red_alert_time_discount_store_shop_show_terminal)
        state_machine.add(red_alert_time_discount_store_shop_hide_terminal)
        state_machine.add(red_alert_time_discount_store_shop_update_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_discount_store_shop_terminal()
end

function RedAlertTimeDiscountStoreShop:updateDraw()
    local root = self.roots[1]
    --拥有金币
    self.have_golds_text = ccui.Helper:seekWidgetByName(root,"Text_discount_gold_n")
    self._activity_type = _ED.activity_info[""..self._activity_type.activity_type]
    --道具信息
    local discount_store_info = _ED.treasure_discount_store_info[2]

    -- 刷新倒计时
    self.m_reset_times = ((tonumber(discount_store_info.reset_times)/1000)-(os.time()-discount_store_info.time))
    self.text_reset_times = ccui.Helper:seekWidgetByName(root,"Text_discount_shop_time_n")

    --添加道具
    local ListView_discount_shop = ccui.Helper:seekWidgetByName(root,"ListView_discount_shop")
    ListView_discount_shop:removeAllItems()

    local all_reward_data = self._activity_type.activity_data[3]
    for i = 1 , tonumber(discount_store_info.number) do
        local index = tonumber(discount_store_info.reward[i].index) + 1
        local activity_data = all_reward_data[index]
        local cell = state_machine.excute("red_alert_time_discount_store_shop_cell_create",0,{ i , activity_data})
        ListView_discount_shop:addChild(cell)
    end
    ListView_discount_shop:requestRefreshView()
    self.listview = ListView_discount_shop
    self.listview_poy = self.listview:getInnerContainer():getPositionY()
    self.listview_height = self.listview:getInnerContainer():getPositionY()
end

--初始化
function RedAlertTimeDiscountStoreShop:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.discount_store_tab_3)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self._Image_discount_store_shop_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_discount_shop_arrow_down")
    self._Image_discount_store_shop_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_discount_shop_arrow_up")
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_discount_store_shop_arrow_down:stopAllActions()
    self._Image_discount_store_shop_arrow_up:stopAllActions()
    playActions(self._Image_discount_store_shop_arrow_down)
    playActions(self._Image_discount_store_shop_arrow_up)
    self._Image_discount_store_shop_arrow_down:setVisible(false)
    self._Image_discount_store_shop_arrow_up:setVisible(false)   
    
    self:updateDraw()
end

function RedAlertTimeDiscountStoreShop:onUpdate(dt)
    if self.m_reset_times > 0 then
        self.m_reset_times = self.m_reset_times - dt
        if self.text_reset_times ~= nil then
            self.text_reset_times:setString(getRedAlertTimeActivityFormat(self.m_reset_times))
        end
        if self.m_reset_times <= 0 then
            self.m_reset_times = 0
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                        response.node:updateDraw()
                    end
                end
            end     
            protocol_command.draw_activity_reward.param_list = self._activity_type.activity_id .. "\r\n"..self._activity_type.activity_type.."\r\n".."2".."\r\n".."0".."\r\n".."2"
            NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)
        end
    end
    if self.have_golds_text ~= nil then
        self.have_golds_text:setString(_ED.user_info.user_gold)
    end
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_discount_store_shop_arrow_down:setVisible(true)
        else
            self._Image_discount_store_shop_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_discount_store_shop_arrow_up:setVisible(true)
        else
            self._Image_discount_store_shop_arrow_up:setVisible(false)
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

function RedAlertTimeDiscountStoreShop:onEnterTransitionFinish()

end

function RedAlertTimeDiscountStoreShop:init(params)
    self._rootWindows = params[1]
    self._activity_type = params[2]
	self:onInit()
    return self
end

function RedAlertTimeDiscountStoreShop:onExit()
    state_machine.remove("red_alert_time_discount_store_shop_show")
    state_machine.remove("red_alert_time_discount_store_shop_hide")
    state_machine.remove("red_alert_time_discount_store_shop_update")
end