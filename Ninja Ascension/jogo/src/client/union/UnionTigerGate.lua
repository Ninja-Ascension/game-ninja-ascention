--------------------------------------------------------------------------------------------------------------
--  说明：龙虎门军团主界面
--------------------------------------------------------------------------------------------------------------
if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then

UnionTigerGate = class("UnionTigerGateClass", Window)

--打开界面
local union_open_terminal = {
	_name = "Union_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if params ~= nil then
			local UnionWindow = fwin:find("UnionTigerGateClass")
            if UnionWindow ~= nil and UnionWindow:isVisible() == true then
				return true
			end
			state_machine.excute("union_create_close", 0, "")
			state_machine.excute("union_join_close", 0, "")
			fwin:open(UnionTigerGate:new():init(params),fwin._view)
		end	
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
--关闭界面
local union_close_terminal = {
	_name = "Union_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local UnionWindow = fwin:find("UnionTigerGateClass")
		if UnionWindow ~= nil then
			fwin:close(UnionWindow)
		end
        fwin:cleanView(fwin._view)
        if fwin:find("MenuClass") == nil then
            fwin:open(Menu:new(), fwin._taskbar)
        end
        if fwin:find("HomeClass") == nil then
            state_machine.excute("menu_manager", 0, 
                {
                    _datas = {
                        terminal_name = "menu_manager",     
                        next_terminal_name = "menu_show_home_page", 
                        current_button_name = "Button_home",
                        but_image = "Image_home",       
                        terminal_state = 0, 
                        isPressedActionEnabled = true
                    }
                }
            )
        end
        state_machine.excute("menu_back_home_page", 0, "")
        state_machine.excute("menu_clean_page_state", 0, "")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--退出或者被踢出清空数据
local union_the_meeting_place_clean_all_data_terminal = {
    _name = "union_the_meeting_place_clean_all_data",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        _ED.union.union_examine_list_sum = 0
        _ED.union.union_examine_list_info = {}
        _ED.union.union_find_list_sum = 0                  
        _ED.union.union_find_list_info = {}
        _ED.union.user_union_info = {}
        _ED.union.union_member_list_sum = 0
        _ED.union.union_member_list_info = {}
        _ED.union.union_info = {}
        _ED.union.union_message_number = {}
        local UnionWindow = fwin:find("UnionTigerGateClass")
        if UnionWindow ~= nil then
            state_machine.excute("Union_close", 0, nil)
        end 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_open_terminal)
state_machine.add(union_close_terminal)
state_machine.add(union_the_meeting_place_clean_all_data_terminal)
state_machine.init()

function UnionTigerGate:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions={}
    self.tickTime = 0
    
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.union.unionFighting.UnionFightingMain")
    else
    app.load("client.union.meeting.UnionTheMeetingPlace")
        -- app.load("client.union.unionFighting.UnionFightingMain")
    end

    local function init_Union_terminal()
		--查看帮助信息
		local union_look_help_information_terminal = {
            _name = "union_look_help_information",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.refinery.TreasureInfo")
				local cell = TreasureInfo:new()
				cell:init(5)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新界面信息
		local union_refresh_info_terminal = {
            _name = "union_refresh_info",
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
		--返回主页
		local union_return_home_terminal = {
            _name = "union_return_home",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("Union_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--点击军团商店
		local union_go_to_shop_terminal = {
            _name = "union_go_to_shop",
            _init = function (terminal)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    app.load("client.l_digital.union.shop.UnionShop")
                else
                    app.load("client.union.shop.UnionShop")
                end
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("union_shop_open", 0, 
					{
						_datas = {
							terminal_name = "union_shop_select_page", 	
							next_terminal_name = "union_shop_to_prop_page", 		
							current_button_name = "Button_32", 		
							but_image = "Button_32",	
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--点击封坛祭天
		local union_go_to_heaven_terminal = {
            _name = "union_go_to_heaven",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    app.load("client.l_digital.union.heaven.UnionHeaven")
                else
                    app.load("client.union.heaven.UnionHeaven")
                end
                state_machine.excute("union_heaven_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--点击军团副本
		local union_go_to_duplicate_terminal = {
            _name = "union_go_to_duplicate",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local isOpen = tonumber(_ED.union.union_info.union_grade) >= dms.int(dms["fun_open_condition"], 56, fun_open_condition.level)
                if isOpen == false then
                    TipDlg.drawTextDailog(_function_unopened_tip_string)
                    return
                end
                local function responseCallback( response )
                end
                if _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
                    protocol_command.unino_map_refush.param_list = _ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number.."\r\n0"
                    NetworkManager:register(protocol_command.unino_map_refush.code, _ED.union_fight_url, nil, nil, nil, responseCallback, false, nil)
                end
                -- app.load("client.union.duplicate.UnionDuplicate")
                -- state_machine.excute("union_duplicate_open", 0, nil)
                if tonumber(_ED.union_fight_state) == 3 and _ED.union_fight_is_join == true then
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        app.load("client.l_digital.union.unionFighting.UnionFightingMain")
                    else
                        app.load("client.union.unionFighting.UnionFightingMain")
                    end
                    state_machine.excute("union_fighting_main_open", 0, nil)
                else
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                        app.load("client.l_digital.union.unionFighting.UnionFightJoin")
                    else
                        app.load("client.union.unionFighting.UnionFightJoin")
                    end
                    state_machine.excute("union_fighting_join_open", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--点击军团排行
		local union_go_to_rank_terminal = {
            _name = "union_go_to_rank",
            _init = function (terminal)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    app.load("client.l_digital.union.rank.UnionRank")
                else
                    app.load("client.union.rank.UnionRank")
                end
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseUnionListCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("union_rank_open", 0, "")
                        end 
                    end
                end
                _ED.union.union_list_info = nil  
				protocol_command.union_list.param_list = "0"
				NetworkManager:register(protocol_command.union_list.code, nil, nil, nil, self, responseUnionListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --切换主界面列表容器状态
        local union_change_right_list_view_state_terminal = {
            _name = "union_change_right_list_view_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                if root ~= nil then
                    ccui.Helper:seekWidgetByName(root, "ListView_city"):setVisible(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_look_help_information_terminal)
		state_machine.add(union_refresh_info_terminal)
		state_machine.add(union_return_home_terminal)
		state_machine.add(union_go_to_shop_terminal)
		state_machine.add(union_go_to_heaven_terminal)
		state_machine.add(union_go_to_duplicate_terminal)
		state_machine.add(union_go_to_rank_terminal)
        state_machine.add(union_change_right_list_view_state_terminal)
        state_machine.init()
    end
	
    init_Union_terminal()
end

function UnionTigerGate:onUpdate( dt )
    if self.roots == nil or self.tickTime == nil then 
        return
    end
    self.tickTime = self.tickTime - dt
    if self.tickTime <= 0 then
        self.tickTime = 2
        local function responseCallback( response )
        end
        -- NetworkManager:register(protocol_command.refush_cache_message.code, nil, nil, nil, nil, responseCallback, false, nil)
    end
end

function UnionTigerGate:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
    state_machine.excute("union_the_meeting_place_refresh", 0, nil)
end

function UnionTigerGate:onInit()
	local csbUnion = csb.createNode("legion/legion.csb")
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_22"), nil, 
    {
        terminal_name = "union_return_home", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	--商店
    local Button_24 = ccui.Helper:seekWidgetByName(root, "Button_24")
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_24"), nil, 
    {
        terminal_name = "union_go_to_shop", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	--帮助
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_21"), nil, 
    {
        terminal_name = "union_look_help_information", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	-- 	排行榜
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_23"), nil, 
    {
        terminal_name = "union_go_to_rank", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    local Button_25 = ccui.Helper:seekWidgetByName(root, "Button_25")
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_25"), nil, 
    {
        terminal_name = "union_go_to_heaven", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    local Button_29 = ccui.Helper:seekWidgetByName(root, "Button_29")
    fwin:addTouchEventListener(Button_29, nil, 
    {
        terminal_name = "union_go_to_duplicate", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_fighting",
    _widget = Button_29,
    _invoke = nil,
    _interval = 0.5,})

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_shop_reward",
    _widget = Button_24,
    _invoke = nil,
    _interval = 0.5,})

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_build",
    _widget = Button_25,
    _invoke = nil,
    _interval = 0.5,})

    -- 每次打开及时同步工会成员数据 by-tongwensen
    -- local function responseCallback( response )
    -- end
    -- if tonumber(_ED.union.union_member_list_sum) == nil then
    --     NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, nil, responseCallback, false, nil)
    -- end
    local function responseCallback1( response )
    end
    -- if tonumber(_ED.union.union_message_number) == nil then
        NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, nil, responseCallback1, false, nil)
    -- end
    if _ED.union ~= nil and _ED.union.union_info ~= nil and _ED.union.union_info.union_id ~= nil and _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
        protocol_command.unino_fight_init.param_list = _ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number
        NetworkManager:register(protocol_command.unino_fight_init.code, _ED.union_fight_url, nil, nil, self, responseUnionFightCallback, false, nil)
    end
    local cell = UnionTheMeetingPlace:createCell()
    self:addChild(cell)
end

function UnionTigerGate:onEnterTransitionFinish()
    fwin:close(fwin:find("UserTopInfoAClass"))
    app.load("client.player.UserTopInfoA")
    fwin:open(UserTopInfoA:new(), fwin._view)
end

function UnionTigerGate:init()
	self:onInit()
	return self
end

function UnionTigerGate:onExit()
	state_machine.remove("union_look_help_information")
	state_machine.remove("union_refresh_info")
	state_machine.remove("union_return_home")
	state_machine.remove("union_go_to_shop")
	state_machine.remove("union_go_to_heaven")
	state_machine.remove("union_go_to_duplicate")
	state_machine.remove("union_go_to_learn_skill")
	state_machine.remove("union_go_to_rank")
    state_machine.remove("union_change_right_list_view_state")
end

end