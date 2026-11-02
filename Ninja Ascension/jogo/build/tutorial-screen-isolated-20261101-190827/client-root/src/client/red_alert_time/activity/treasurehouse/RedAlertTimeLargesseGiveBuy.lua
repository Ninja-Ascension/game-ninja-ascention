-- ------------------------------------------------------------------------------------------------------------
--  慷慨馈赠的排行界面
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeLargesseGiveBuy = class("RedAlertTimeLargesseGiveBuyClass", Window)

local red_alert_time_largesse_give_buy_window_open_terminal = {
	_name = "red_alert_time_largesse_give_buy_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)      
    	local tab = RedAlertTimeLargesseGiveBuy:new():init(params)
    	fwin:open(tab)       	       
		return tab
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(red_alert_time_largesse_give_buy_window_open_terminal)
state_machine.init()

function RedAlertTimeLargesseGiveBuy:ctor()
	self.super:ctor()
	self.roots = {}	
	self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0
    self._Image_seek_rank_arrow_down = nil
    self._Image_seek_rank_arrow_up = nil

    app.load("client.red_alert_time.cells.activity.treasurehouse.activity_largesse_give_buy_cell")

	local function init_red_alert_time_largesse_give_buy_terminal()
		--显示界面
        local red_alert_time_largesse_give_buy_show_terminal = {
			_name = "red_alert_time_largesse_give_buy_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
		        instance:setVisible(true)
			end,
			_terminal = nil,
			_terminals = nil
		}
        --刷新
        local red_alert_time_largesse_give_buy_update_terminal = {
            _name = "red_alert_time_largesse_give_buy_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_largesse_give_buy_update_terminal)
		state_machine.add(red_alert_time_largesse_give_buy_show_terminal)
		state_machine.init()
	end	
	init_red_alert_time_largesse_give_buy_terminal()
end

function RedAlertTimeLargesseGiveBuy:updateDraw()
	local root = self.roots[1]
    local ListView_seek_treasure_rank = ccui.Helper:seekWidgetByName(root, "ListView_seek_treasure_rank")
    local Text_seek_treasure_rank_me_t_1 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_1")
    local Text_seek_treasure_rank_me_t_5 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_5")
    local Text_seek_treasure_rank_t_3 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_t_3")
    local Text_seek_treasure_rank_me_t_2 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_2")    --我的慷慨值
    local Text_seek_treasure_rank_me_t_4 = ccui.Helper:seekWidgetByName(root, "Text_seek_treasure_rank_me_t_4")    --我的排名
    
    self._list_view = ListView_seek_treasure_rank
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()
    Text_seek_treasure_rank_me_t_1:setString(activity_str_tip[160])
    Text_seek_treasure_rank_me_t_5:setString(string.format(activity_str_tip[161], 100))
    Text_seek_treasure_rank_t_3:setString(activity_str_tip[162])

    for i=1, 6 do
        local cell = state_machine.excute("activity_largesse_give_buy_create_cell", 0, {})
        ListView_seek_treasure_rank:addChild(cell)
    end
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:requestRefreshView()
        
end	

function RedAlertTimeLargesseGiveBuy:onUpdate(dt)
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

function RedAlertTimeLargesseGiveBuy:onInit()
    local csbItem = csb.createNode(config_csb.treasurehouse.seek_treasure_tab_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_seek_rank_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_seek_rank_arrow_down")
    self._Image_seek_rank_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_seek_rank_arrow_up")
    self._Image_seek_rank_arrow_down:stopAllActions()
    self._Image_seek_rank_arrow_up:stopAllActions()
    playActions(self._Image_seek_rank_arrow_down)
    playActions(self._Image_seek_rank_arrow_up)
    self._Image_seek_rank_arrow_down:setVisible(false)
    self._Image_seek_rank_arrow_up:setVisible(false)

    self:updateDraw()
end

function RedAlertTimeLargesseGiveBuy:init(params)
    self._rootWindows = params[1]
	self:onInit()
    return self
end

function RedAlertTimeLargesseGiveBuy:onExit()
    state_machine.remove("red_alert_time_largesse_give_buy_show")
    state_machine.remove("red_alert_time_largesse_give_buy_update")
end