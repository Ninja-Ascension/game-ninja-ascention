-----------------------------
--武将包裹
-----------------------------
HeroPacks = class("HeroPacksClass", Window)

local hero_packs_window_open_terminal = {
    _name = "hero_packs_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroPacksClass")
        if nil == _Window then
			if zstring.tonumber(params._datas.darwType)==1 then
				fwin:open(HeroPacks:new():init(params._datas.darwType), fwin._windows)
			else
				fwin:open(HeroPacks:new():init(params._datas.darwType), fwin._viewdialog)
			end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local hero_packs_window_close_terminal = {
    _name = "hero_packs_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroPacksClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_packs_window_open_terminal)
state_machine.add(hero_packs_window_close_terminal)
state_machine.init()

function HeroPacks:ctor()
    self.super:ctor()
    self.roots = {}
    self.scroll_panel = nil
    self.show_page_type = 1 -- 1 所有 2 前排 3 中排 4 后排
	
	self.draw_Type = 0

    -- load lua file
    app.load("client.red_alert_time.packs.herostorage.HeroPacksScrollviewAll")
    app.load("client.red_alert_time.packs.herostorage.HeroPacksScrollviewFont")
    app.load("client.red_alert_time.packs.herostorage.HeroPacksScrollviewMiddle")
    app.load("client.red_alert_time.packs.herostorage.HeroPacksScrollviewBack")

    -- Initialize hero_packs state machine.
    local function init_hero_packs_terminal()
	
        --管理
        local hero_packs_manager_terminal = {
        _name = "hero_packs_manager",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)

            if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                -- hide child window
                terminal.last_terminal_name = params._datas.next_terminal_name
                state_machine.excute(params._datas.next_terminal_name, 0, params)
            end 
            -- set select ui button is highlighted
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(false)
                terminal.select_button:setTouchEnabled(true)
            end
            terminal.page_name = params._datas.but_image
            if terminal.select_button == nil and params._datas.current_button_name ~= nil then
                terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
            else
                terminal.select_button = params
            end
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(true)
                terminal.select_button:setTouchEnabled(false)
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
        }

        -- 所有
        local hero_packs_change_to_all_terminal = {
            _name = "hero_packs_change_to_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.show_page_type = 1
                state_machine.excute("hero_packs_scrollview_all_window_open",0,{instance.scroll_panel,instance.draw_Type})
                state_machine.excute("hero_packs_scrollview_all_window_show",0,"")
                state_machine.excute("hero_packs_scrollview_font_window_hide",0,"")
                state_machine.excute("hero_packs_scrollview_middle_window_hide",0,"")
                state_machine.excute("hero_packs_scrollview_back_window_hide",0,"")
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        -- 前排
        local hero_packs_change_to_font_terminal = {
            _name = "hero_packs_change_to_font",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.show_page_type = 2
                state_machine.excute("hero_packs_scrollview_font_window_open",0,{instance.scroll_panel,instance.draw_Type})
                state_machine.excute("hero_packs_scrollview_all_window_hide",0,"")
                state_machine.excute("hero_packs_scrollview_font_window_show",0,"")
                state_machine.excute("hero_packs_scrollview_middle_window_hide",0,"")
                state_machine.excute("hero_packs_scrollview_back_window_hide",0,"")                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 中排
        local hero_packs_change_to_middle_terminal = {
            _name = "hero_packs_change_to_middle",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.show_page_type = 3
                state_machine.excute("hero_packs_scrollview_middle_window_open",0,{instance.scroll_panel,instance.draw_Type})
                state_machine.excute("hero_packs_scrollview_all_window_hide",0,"")
                state_machine.excute("hero_packs_scrollview_font_window_hide",0,"")
                state_machine.excute("hero_packs_scrollview_middle_window_show",0,"")
                state_machine.excute("hero_packs_scrollview_back_window_hide",0,"")                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 后排
        local hero_packs_change_to_back_terminal = {
            _name = "hero_packs_change_to_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.show_page_type = 4
                state_machine.excute("hero_packs_scrollview_back_window_open",0,{instance.scroll_panel,instance.draw_Type})
                state_machine.excute("hero_packs_scrollview_all_window_hide",0,"")
                state_machine.excute("hero_packs_scrollview_font_window_hide",0,"")
                state_machine.excute("hero_packs_scrollview_middle_window_hide",0,"")
                state_machine.excute("hero_packs_scrollview_back_window_show",0,"")                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 武将个数
        local hero_packs_updatedraw_hero_numbers_terminal = {
            _name = "hero_packs_updatedraw_hero_numbers",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                    instance:onUpdateDrawHeroNumbers(params)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        state_machine.add(hero_packs_manager_terminal)
        state_machine.add(hero_packs_change_to_all_terminal)
        state_machine.add(hero_packs_change_to_font_terminal)
        state_machine.add(hero_packs_change_to_middle_terminal)
        state_machine.add(hero_packs_change_to_back_terminal)
        state_machine.add(hero_packs_updatedraw_hero_numbers_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_hero_packs_terminal()
end

function HeroPacks:onUpdateDraw()
    state_machine.excute("hero_packs_manager",0,{
        _datas = {
                terminal_name = "hero_packs_manager",     
                next_terminal_name = "hero_packs_change_to_all", 
                current_button_name = "Button_hero_packs_all",   
                but_image = "",     
                terminal_state = 0, 
                touch_scale = true,
                touch_scale_xy = 0.95, 
            }
        })
end

function HeroPacks:onUpdateDrawHeroNumbers(ship_numbers)
    local root = self.roots[1]
    local Text_hero_packs_11 = ccui.Helper:seekWidgetByName(root,"Text_hero_packs_11")
    if self.show_page_type == 1 then
        Text_hero_packs_11:setString(string.format(red_alert_all_str[21],ship_numbers))
    elseif self.show_page_type == 2 then
        Text_hero_packs_11:setString(string.format(red_alert_all_str[22],ship_numbers))
    elseif self.show_page_type == 3 then
        Text_hero_packs_11:setString(string.format(red_alert_all_str[23],ship_numbers))
    elseif self.show_page_type == 4 then
        Text_hero_packs_11:setString(string.format(red_alert_all_str[24],ship_numbers))
    end

end

function HeroPacks:onEnterTransitionFinish()

end

function HeroPacks:onInit( )
    local csbItem = csb.createNode(config_csb.packs.herostorage.hero_packs)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_packs_close"), nil, 
    {
        terminal_name = "hero_packs_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 所有
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_packs_all"), nil, 
    {
        terminal_name = "hero_packs_manager",     
        next_terminal_name = "hero_packs_change_to_all", 
        current_button_name = "Button_hero_packs_all",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)    
    
    -- 前排
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_packs_front"), nil, 
    {
        terminal_name = "hero_packs_manager",     
        next_terminal_name = "hero_packs_change_to_font", 
        current_button_name = "Button_hero_packs_front",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)   
    -- 中排
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_packs_in_row"), nil, 
    {
        terminal_name = "hero_packs_manager",     
        next_terminal_name = "hero_packs_change_to_middle", 
        current_button_name = "Button_hero_packs_in_row",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)   
    -- 后排
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_packs_back_row"), nil, 
    {
        terminal_name = "hero_packs_manager",     
        next_terminal_name = "hero_packs_change_to_back",
        current_button_name = "Button_hero_packs_back_row",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3) 

    local Panel_hero_packs = ccui.Helper:seekWidgetByName(root,"Panel_hero_packs")
    self.scroll_panel = Panel_hero_packs
	self:onUpdateDraw()
end

function HeroPacks:init(drawType)
	if drawType~= nil and drawType~= "" then
		self.draw_Type = drawType
	end
	self:onInit()
    return self
end

function HeroPacks:onExit()
    state_machine.remove("hero_packs_manager")
    state_machine.remove("hero_packs_change_to_all")
    state_machine.remove("hero_packs_change_to_font")
    state_machine.remove("hero_packs_change_to_middle")
    state_machine.remove("hero_packs_change_to_back")
    state_machine.remove("hero_packs_updatedraw_hero_numbers")
end
