--------------------------------------------------------------------------------------------------------------
--  皇城商店
--------------------------------------------------------------------------------------------------------------
TourneyfieldShop = class("TourneyfieldShopClass", Window)

--打开界面
local tourneyfield_shop_window_open_terminal = {
	_name = "tourneyfield_shop_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTip(113) == true then
            return
        end    
        if fwin:find("TourneyfieldShopClass") == nil then
            state_machine.excute("home_select_action_window_close",0,"")
            fwin:open(TourneyfieldShop:new():init(),_view)
        end
        if fwin:find("HeroRecruitClass")  ~= nil then
            state_machine.excute("hero_recruit_window_hide", 0, "")
            state_machine.excute("catalogue_storage_window_hide", 0, "")
        end
        state_machine.excute("main_window_hide", 0, "")
        state_machine.excute("player_resource_window_hide", 0, "")     
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")  
        if fwin:find("StrategyClass")  ~= nil then
            state_machine.excute("strategy_window_hide", 0, "")
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local tourneyfield_shop_window_close_terminal = {
	_name = "tourneyfield_shop_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TourneyfieldShopClass"))
        if fwin:find("StrategyClass")  ~= nil then
            state_machine.excute("strategy_window_show", 0, "")
        end   
        if fwin:find("HeroRecruitClass")  ~= nil then
            state_machine.excute("hero_recruit_window_show", 0, "")
            state_machine.excute("catalogue_storage_window_show", 0, "")
        elseif fwin:find("PacksClass")  ~= nil then
            state_machine.excute("packs_window_show", 0, "")
        else
            state_machine.excute("main_window_open",0,"")
            state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("duplicate_title_window_show",0,"")   
        end
        -- clear cacher
        cacher.clearWindowCacher()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(tourneyfield_shop_window_open_terminal)
state_machine.add(tourneyfield_shop_window_close_terminal)
state_machine.init()

function TourneyfieldShop:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    self._choose_type = 0

    app.load("client.red_alert.cells.shop.mystery_shop_cell")
    app.load("client.red_alert.shop.MysteryShopBuy")
    
	 -- Initialize tourneyfield state machine.
    local function init_tourneyfield_shop_terminal()
        local tourneyfield_change_page_terminal = {
            _name = "tourneyfield_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeUIPage(params._datas.change_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local tourneyfield_shop_update_info_terminal = {
            _name = "tourneyfield_shop_update_info",
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

        state_machine.add(tourneyfield_change_page_terminal)
        state_machine.add(tourneyfield_shop_update_info_terminal)
        state_machine.init()
    end
    
    -- call func tourneyfield create state machine.
    init_tourneyfield_shop_terminal()

end

function TourneyfieldShop:updateDraw( ... )
    local root = self.roots[1]
    local Text_spend_number_1 = ccui.Helper:seekWidgetByName(root, "Text_spend_number_1")
    local Text_spend_number_2 = ccui.Helper:seekWidgetByName(root, "Text_spend_number_2")
    local Text_spend_number_3 = ccui.Helper:seekWidgetByName(root, "Text_spend_number_3")
    local Text_spend_number_4 = ccui.Helper:seekWidgetByName(root, "Text_spend_number_4")
    Text_spend_number_1:setString("".._ED.user_info.user_honour)
    Text_spend_number_2:setString("")
    Text_spend_number_3:setString("")
    Text_spend_number_4:setString("")
end

function TourneyfieldShop:changeUIPage( changeState )
    local root = self.roots[1]
    local Button_right_1 = ccui.Helper:seekWidgetByName(root, "Button_right_1")
    local Button_right_2 = ccui.Helper:seekWidgetByName(root, "Button_right_2")
    local Button_right_3 = ccui.Helper:seekWidgetByName(root, "Button_right_3")
    Button_right_1:setHighlighted(false)
    Button_right_2:setHighlighted(false)
    Button_right_3:setHighlighted(false)
    local Panel_spend_1 = ccui.Helper:seekWidgetByName(root, "Panel_spend_1")
    local Panel_spend_2 = ccui.Helper:seekWidgetByName(root, "Panel_spend_2")
    local Panel_spend_3 = ccui.Helper:seekWidgetByName(root, "Panel_spend_3")
    local Panel_spend_4 = ccui.Helper:seekWidgetByName(root, "Panel_spend_4")
    Panel_spend_1:setVisible(false)
    Panel_spend_2:setVisible(false)
    Panel_spend_3:setVisible(false)
    Panel_spend_4:setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Text_spend_number_1"):setString("")
    ccui.Helper:seekWidgetByName(root, "Text_spend_number_2"):setString("")
    ccui.Helper:seekWidgetByName(root, "Text_spend_number_3"):setString("")
    ccui.Helper:seekWidgetByName(root, "Text_spend_number_4"):setString("")
    if changeState == 1 then
        Button_right_1:setHighlighted(true)
        Panel_spend_1:setVisible(true)
    elseif changeState == 2 then
        Button_right_2:setHighlighted(true)
        Panel_spend_2:setVisible(true)
        Panel_spend_3:setVisible(true)
    elseif changeState == 3 then
        Button_right_3:setHighlighted(true)
        Panel_spend_4:setVisible(true)
    end
    self:updateDraw()
    if self._choose_type == changeState then
        return
    end
    self._choose_type = changeState
    self:onUpdateDrawList()
end

function TourneyfieldShop:onUpdateDrawList( ... )
    local root = self.roots[1]
    local ListView_mystery_shop_list_top = ccui.Helper:seekWidgetByName(root,"ListView_mystery_shop_list_top")
    local ListView_mystery_shop_list_bottom = ccui.Helper:seekWidgetByName(root,"ListView_mystery_shop_list_bottom")
    local ScrollView_mystery_shop_list = ccui.Helper:seekWidgetByName(root,"ScrollView_mystery_shop_list")
    ListView_mystery_shop_list_top:removeAllItems()
    ListView_mystery_shop_list_bottom:removeAllItems()
    
    local items = _ED.all_shop_info[""..(self._choose_type - 1)]
    local width = 0
    local index = 0
    if items ~= nil then
        for i, v in pairs(_ED.all_shop_info[""..(self._choose_type - 1)]) do
            local openInfos = zstring.split(v.open_info, ",")
            local result = true
            if tonumber(openInfos[1]) == 0 and tonumber(openInfos[2]) > tonumber(_ED.user_info.user_grade) then
                result = false
            end
            if result == true then
                local cell = state_machine.excute("mystery_shop_create_cell", 0, {v, i-1, 2})
                if math.floor(i % 2) ~= 0 then
                    index = index + 1 
                    ListView_mystery_shop_list_top:addChild(cell)
                else
                    ListView_mystery_shop_list_bottom:addChild(cell)
                end
                width = cell:getContentSize().width
            end
        end
    end

    ScrollView_mystery_shop_list:getInnerContainer():setContentSize(cc.size(width * index, ScrollView_mystery_shop_list:getContentSize().height))
    ListView_mystery_shop_list_top:requestRefreshView()
    ListView_mystery_shop_list_bottom:requestRefreshView()
end

--初始化界面
function TourneyfieldShop:onInit()
    local csbItem = csb.createNode(config_csb.campaign.tourneyfield.tourneyfield_shop)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    --阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")
    
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mystery_shop_close"), nil, 
    {
        terminal_name = "tourneyfield_shop_window_close", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    

    for i=1,3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_right_"..i), nil, 
        {
            terminal_name = "tourneyfield_change_page", 
            terminal_state = 0, 
            cell = self, 
            change_type = i,
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)    
    end
    
	self:onUpdateDraw()
end

function TourneyfieldShop:onEnterTransitionFinish()

end

--刷新英雄icon列表
function TourneyfieldShop:onUpdateDraw()
    local root = self.roots[1]
    self:changeUIPage(1)
end

function TourneyfieldShop:close()

end

--初始化
function TourneyfieldShop:init()
    _ED._push_tourneyfield = 0
	self:onInit()
    return self
end

--移除状态机
function TourneyfieldShop:onExit()
    state_machine.remove("tourneyfield_change_page")
    state_machine.remove("tourneyfield_shop_update_info")
end