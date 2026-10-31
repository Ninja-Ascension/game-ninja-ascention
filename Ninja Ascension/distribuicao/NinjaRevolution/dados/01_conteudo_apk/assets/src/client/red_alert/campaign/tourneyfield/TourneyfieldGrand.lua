--------------------------------------------------------------------------------------------------------------
--  战报
--------------------------------------------------------------------------------------------------------------
TourneyfieldGrand = class("TourneyfieldGrandClass", Window)

--打开界面
local tourneyfield_grand_window_open_terminal = {
	_name = "tourneyfield_grand_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)    
        if fwin:find("TourneyfieldGrandClass") == nil then
            fwin:open(TourneyfieldGrand:new():init(),fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local tourneyfield_grand_window_close_terminal = {
	_name = "tourneyfield_grand_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TourneyfieldGrandClass"))  
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(tourneyfield_grand_window_open_terminal)
state_machine.add(tourneyfield_grand_window_close_terminal)
state_machine.init()

function TourneyfieldGrand:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    self._info_data = {}            --战报数据
    self._chooseState = 0           --战报类型：1：进攻，2：防守

    -- load lua file
    app.load("client.red_alert.cells.campaign.tourneyfield.tourneyfield_grand_cell")
	 -- Initialize tourneyfield_grand state machine.
    local function init_tourneyfield_grand_terminal()
        --管理
        local tourneyfield_grand_all_page_terminal = {
        _name = "tourneyfield_grand_all_page",
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

        -- 防守
        local tourneyfield_grand_guard_page_terminal = {
            _name = "tourneyfield_grand_guard_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)      
                if instance._info_data["2"] ~= nil then
                    instance:onUpdateDraw(params._datas.state)
                    return true
                end

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node._info_data["2"] = _ED.city_resource_battle_report
                            response.node:onUpdateDraw(params._datas.state)
                        end
                    end
                end
                protocol_command.battlefield_report_get.param_list = "1011"
                NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 进攻
        local tourneyfield_grand_attack_page_terminal = {
            _name = "tourneyfield_grand_attack_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)  
                if instance._info_data["1"] ~= nil then
                    instance:onUpdateDraw(params._datas.state)
                    return true
                end  

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node._info_data["1"] = _ED.city_resource_battle_report
                            response.node:onUpdateDraw(params._datas.state)
                        end
                    end
                end
                protocol_command.battlefield_report_get.param_list = "11"
                NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- -- 添加某个头像
        -- local hero_main_add_list_item_terminal = {
        --     _name = "hero_main_add_list_item",
        --     _init = function (terminal) 
                
        --     end,
        --     _inited = false,
        --     _instance = self,
        --     _state = 0,
        --     _invoke = function(terminal, instance, params)
        --         instance:addListViewItem(params)
        --         return true
        --     end,
        --     _terminal = nil,
        --     _terminals = nil
        -- }   
        state_machine.add(tourneyfield_grand_all_page_terminal)
        state_machine.add(tourneyfield_grand_guard_page_terminal)
        state_machine.add(tourneyfield_grand_attack_page_terminal)
        state_machine.init()
    end
    
    -- call func tourneyfield_grand create state machine.
    init_tourneyfield_grand_terminal()

end

--第一次打开显示防守页面
function TourneyfieldGrand:openMainLine()
    local root = self.roots[1]
    state_machine.excute("tourneyfield_grand_all_page",0,{_datas = {
        terminal_name = "tourneyfield_grand_all_page",   
        next_terminal_name = "tourneyfield_grand_guard_page", 
        current_button_name = "Button_right1",
        but_image = "",  
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        state = 2,
    }})
end

function TourneyfieldGrand:onUpdateDraw(changeState)
    if changeState == self._chooseState then
        return
    end
    self._chooseState = changeState

    local root = self.roots[1]   
    local ListView_grand = ccui.Helper:seekWidgetByName(root,"ListView_grand")
    ListView_grand:removeAllItems()
    local index = 1
    if _ED.city_resource_battle_report == nil then
        return
    end
    local finish_cells = {}
    finish_cells = self._info_data[""..self._chooseState] 

    local function sortfunction( a,b )
        return tonumber(a.time) > tonumber(b.time)
    end
    table.sort( finish_cells, sortfunction )
    for i,v in pairs(finish_cells) do
        local cell = state_machine.excute("tourneyfield_grand_create_cell",0, {v,index})
        ListView_grand:addChild(cell)
    end
    ListView_grand:requestRefreshView()
    self.listview = ListView_grand
    self.listview_poy = ListView_grand:getInnerContainer():getPositionY() 
    self.listview_poy = -1
end

--初始化界面
function TourneyfieldGrand:onInit()
    local csbItem = csb.createNode(config_csb.campaign.tourneyfield.tourneyfield_grand)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "tourneyfield_grand_window_close", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    

    -- 防守
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_right1"), nil, 
    {
        terminal_name = "tourneyfield_grand_all_page",     
        next_terminal_name = "tourneyfield_grand_guard_page", 
        current_button_name = "Button_right1",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        state = 2,
    }, nil, 3)  

    -- 进攻
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_right2"), nil, 
    {
        terminal_name = "tourneyfield_grand_all_page",     
        next_terminal_name = "tourneyfield_grand_attack_page", 
        current_button_name = "Button_right2",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        state = 1,
    }, nil, 3)   
    
    self:openMainLine()
end

function TourneyfieldGrand:onEnterTransitionFinish()

end

function TourneyfieldGrand:close()

end

--初始化
function TourneyfieldGrand:init()
	self:onInit()
    return self
end

--移除状态机
function TourneyfieldGrand:onExit()
    state_machine.remove("tourneyfield_grand_all_page")
    state_machine.remove("tourneyfield_grand_guard_page")
    state_machine.remove("tourneyfield_grand_attack_page")
end