--------------------------------------------------------------------------------------------------------------
--  说明：加入军团主界面
--------------------------------------------------------------------------------------------------------------
UnionJoin = class("UnionJoinClass", Window)

local union_join_open_terminal = {
	_name = "union_join_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if funOpenDrawTip(70) == true then
            return
        end
		fwin:open(UnionJoin:new():init(params), fwin._view)
		state_machine.excute("player_resource_window_hide", 0, "")
        state_machine.excute("main_window_hide", 0, "")   
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")
        state_machine.excute("duplicate_title_window_hide",0,"")
        state_machine.excute("seven_star_map_ui_window_hide",0,"")  
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_join_close_terminal = {
	_name = "union_join_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionJoinClass"))
		if fwin:find("NationalWarMapClass") ~= nil then 
            state_machine.excute("home_button_for_action_window_show",0,"")  
		elseif fwin:find("UnionJoinClass") == nil then
            state_machine.excute("main_window_open",0,"")
            state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("duplicate_title_window_show",0,"")
        else
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("player_resource_window_hide", 0, "")
            state_machine.excute("duplicate_title_window_show",0,"")
        end
        if fwin:find("DuplicateManagerClass") ~= nil then
        	state_machine.excute("player_resource_window_hide", 0, "")
        elseif fwin:find("SevenStarClass") ~= nil then
            state_machine.excute("seven_star_map_ui_window_show",0,"")
            state_machine.excute("duplicate_map_window_show",0,"")
            state_machine.excute("player_resource_window_hide",0,"")
            state_machine.excute("home_button_for_action_window_show",0,"")
        elseif fwin:find("DuplicateManagerClass") == nil and fwin:find("DuplicateMapClass") ~= nil then
            state_machine.excute("duplicate_map_window_show", 0, nil)
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("duplicate_title_window_show",0,"")
        end
        state_machine.excute("national_city_hide_game_resource_info", 0, nil)
        -- clear cacher
        cacher.clearWindowCacher()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_join_open_terminal)
state_machine.add(union_join_close_terminal)
state_machine.init()

function UnionJoin:ctor()
	self.super:ctor()
	self.roots = {}
	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0

	app.load("client.red_alert.union.create.UnionCreate")
	app.load("client.red_alert.cells.union.union_join_list_cell")
	app.load("client.red_alert.union.Union")

    local function init_union_join_terminal()
		--跳转创建军团
		local union_join_to_create_terminal = {
            _name = "union_join_to_create",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_create_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--搜索军团
		local union_join_to_look_terminal = {
            _name = "union_join_to_look",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:lookUnion()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_join_to_create_terminal)
		state_machine.add(union_join_to_look_terminal)
        state_machine.init()
    end

    init_union_join_terminal()
end

function UnionJoin:lookUnion()
	local root = self.roots[1]
	local text = ccui.Helper:seekWidgetByName(root, "TextField_1")
	local str = zstring.exchangeTo(text:getString())

	local function responseUnionSearchCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil and response.node.roots[1] ~= nil then
				response.node:updateDraw()
			end
		end
	end
	_ED.union.union_list_info = nil
	protocol_command.union_search.param_list = str
	NetworkManager:register(protocol_command.union_search.code, nil, nil, nil, self, responseUnionSearchCallback, false, nil)
end

function UnionJoin:loading()
	local function sortfunction( a,b )
		local result = false
		if tonumber(a.union_appiy) > tonumber(b.union_appiy) 
			or (tonumber(a.union_appiy) == tonumber(b.union_appiy) 
				and tonumber(a.union_rank) < tonumber(b.union_rank))
			then
			return true
		end 
		return result
	end
	table.sort( _ED.union.union_list_info, sortfunction )

	for i, v in pairs(_ED.union.union_list_info) do
		local cell = state_machine.excute("union_join_list_create_cell", 0, {v, UnionJoin.asyncIndex})
		UnionJoin.cacheListView:addChild(cell)
		UnionJoin.cacheListView:requestRefreshView()
		UnionJoin.asyncIndex = UnionJoin.asyncIndex + 1
	end
	UnionJoin.cacheListView:jumpToTop()
end

function UnionJoin:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local ListView_01 = ccui.Helper:seekWidgetByName(root, "ListView_01")
	ListView_01:setVisible(true)
	
	UnionJoin.asyncIndex = 1
	UnionJoin.cacheListView = ListView_01
	self.currentListView = UnionJoin.cacheListView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	ListView_01:removeAllItems()

	if _ED.union.union_list_info ~= nil then
		self:loading()
	end
end

function UnionJoin:onUpdate(dt)
	if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
		local size = self.currentListView:getContentSize()
		local posY = self.currentInnerContainer:getPositionY()
		if self.currentInnerContainerPosY == posY then
			return
		end
		self.currentInnerContainerPosY = posY
		local items = self.currentListView:getItems()
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

function UnionJoin:onInit()
	local csbItem = csb.createNode(config_csb.legion.legion_list)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
	--阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")
	
	local text = ccui.Helper:seekWidgetByName(root, "TextField_1")
	draw:addEditBox(text, chat_sent_string[3], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_19"), 6, cc.KEYBOARD_RETURNTYPE_DONE)

	self:updateDraw()

	-- 创建军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_02"), nil, 
    {
        terminal_name = "union_join_to_create", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	-- 搜索军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_19"), nil, 
    {
        terminal_name = "union_join_to_look", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_03"), nil, 
    {
        terminal_name = "union_join_close", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

end

function UnionJoin:onEnterTransitionFinish()

end

function UnionJoin:init()
	self:onInit()
	return self
end

function UnionJoin:onExit()
	state_machine.remove("union_join_to_create")
	state_machine.remove("union_join_to_look")
end