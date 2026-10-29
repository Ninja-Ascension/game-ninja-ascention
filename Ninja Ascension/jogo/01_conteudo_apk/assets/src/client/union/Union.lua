--------------------------------------------------------------------------------------------------------------
--  说明：军团主界面
--------------------------------------------------------------------------------------------------------------
if __lua_project_id ~= __lua_project_gragon_tiger_gate and __lua_project_id ~= __lua_project_l_digital and __lua_project_id ~= __lua_project_l_dragonball and __lua_project_id ~= __lua_project_l_dragonball2 and __lua_project_id ~= __lua_project_l_pokemon and __lua_project_id ~= __lua_project_onepiece and __lua_project_id ~= __lua_project_l_naruto  then

Union = class("UnionClass", Window)

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
			local UnionWindow = fwin:find("UnionClass")
			if UnionWindow ~= nil and UnionWindow:isVisible() == true then
				return true
			end
			state_machine.excute("union_create_close", 0, "")
			state_machine.excute("union_join_close", 0, "")
			fwin:open(Union:new():init(params),fwin._view)
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
		local UnionWindow = fwin:find("UnionClass")
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
        local UnionWindow = fwin:find("UnionClass")
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

function Union:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions={}
    self.isPlay = true
	
    self.pushShop = nil
    self.pushHeaven = nil
    self.pushDuplicate = nil
    self.pushTime = nil
    self.osTime = nil
    self.tickTime = 0
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.union.meeting.UnionTheMeetingPlace")
    else
        app.load("client.union.meeting.UnionTheMeetingPlace")
    end
	 -- Initialize union  state machine.
    local function init_Union_terminal()
		
		--查看帮助信息
		local union_look_help_information_terminal = {
            _name = "union_look_help_information",
            _init = function (terminal)
                app.load("client.refinery.TreasureInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
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
				-- for i, v in pairs(self.group) do
					-- if v ~= nil then
						-- fwin:close(v)
					-- end
				-- end
				state_machine.excute("Union_close", 0, "")
                    
				-- if fwin:find("HomeClass") == nil then
				-- 	state_machine.excute("menu_manager", 0, 
				-- 		{
				-- 			_datas = {
				-- 				terminal_name = "menu_manager", 	
				-- 				next_terminal_name = "menu_show_home_page", 
				-- 				current_button_name = "Button_home",
				-- 				but_image = "Image_home", 		
				-- 				terminal_state = 0, 
				-- 				isPressedActionEnabled = true
				-- 			}
				-- 		}
				-- 	)
				-- end
				
				-- state_machine.excute("menu_back_home_page", 0, "")
                
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
                -- state_machine.excute("union_shop_open", 0, "")
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
		--点击议事大厅
		local union_go_to_the_meeting_place_terminal = {
            _name = "union_go_to_the_meeting_place",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("union_the_meeting_place_open", 0, nil)
                    end
                end
                -- 每次打开及时同步工会成员数据 by-tongwensen
                -- if tonumber(_ED.union.union_member_list_sum) == nil then
                    NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, nil, responseCallback, false, nil)
                -- else
                --     state_machine.excute("union_the_meeting_place_open", 0, nil)
                -- end
                -- local function responseCallback1( response )
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --     end
                -- end
                -- if tonumber(_ED.union.union_message_number) == nil then
                --     NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, nil, responseCallback1, false, nil)
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--点击军团技能
		local union_go_to_learn_skill_terminal = {
            _name = "union_go_to_learn_skill",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                TipDlg.drawTextDailog(_function_unopened_tip_string)
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
                -- NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, nil, responseCallback, true, nil)
                _ED.union.union_list_info = nil  
				protocol_command.union_list.param_list = "0"
				NetworkManager:register(protocol_command.union_list.code, nil, nil, nil, self, responseUnionListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--点击公告喇叭
		local union_button_play_announcement_terminal = {
            _name = "union_button_play_announcement",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mcell = params._datas.cell
                if mcell.isPlay == false then
                    mcell.isPlay = true
                    mcell:announcementPlay(true)
                else
                    mcell:announcementPlay(false)
                    mcell.isPlay = false
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
		state_machine.add(union_go_to_the_meeting_place_terminal)
		state_machine.add(union_go_to_learn_skill_terminal)
		state_machine.add(union_go_to_rank_terminal)
		state_machine.add(union_button_play_announcement_terminal)
        state_machine.init()
    end
    init_Union_terminal()
end

function Union:announcementPlay(_type)
    local root = self.roots[1]
    if root == nil then
        return
    end
    local action = self.actions[1]
    if _type == true then
        action:play("Button_124_touch_1", false)
    elseif _type == false then
        action:play("Button_124_touch_2", false)
    end
end 

function Union:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end

    ccui.Helper:seekWidgetByName(root, "Text_219"):setString(_ED.union.union_info.bulletin)
	local gongx = ccui.Helper:seekWidgetByName(root, "Text_23") -- 个人贡献
	local unionname = ccui.Helper:seekWidgetByName(root, "Text_21") -- 军团名称
	local unionlv = ccui.Helper:seekWidgetByName(root, "Text_24") -- 军团等级
	local totalCon = dms.string(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.maxExp)
    ccui.Helper:seekWidgetByName(root, "LoadingBar_21"):setPercent(tonumber(_ED.union.union_info.union_contribution) * 100 /tonumber(totalCon))
    ccui.Helper:seekWidgetByName(root, "Text_jindu_1"):setString(_ED.union.union_info.union_contribution.."/"..totalCon)
	gongx:setString(zstring.tonumber(_ED.union.user_union_info.rest_contribution))
	unionname:setString(_ED.union.union_info.union_name)
	unionlv:setString(_ED.union.union_info.union_grade)
end

function Union:pushNotification( ... )
    --类型(1,商店奖励 2,限时商店 3,祭天 3,军团副本)
    for k,v in pairs(_ED.union_push_notification_info) do
        if v ~= nil then
            if k == 1 then
                if zstring.tonumber(v) == 0 and self.pushShop ~= nil then
                    self.pushShop:setVisible(false)
                elseif zstring.tonumber(v) == 1 and self.pushShop ~= nil then
                    self.pushShop:setVisible(true)
                    if self.pushTime:isVisible() == true then
                        self.pushTime:setVisible(false)
                    end
                end    
            elseif k == 2 then
                if  _ED.union_push_notification_info_limit_refresh ~= nil and _ED.union_push_notification_info_limit_refresh == false then
                    self.pushTime:setVisible(false)
                else
                    if zstring.tonumber(v) == 0 and self.pushTime ~= nil then
                        self.pushTime:setVisible(false)
                    elseif zstring.tonumber(v) == 1 and self.pushTime ~= nil then
                        if self.pushShop:isVisible() == false then
                            self.pushTime:setVisible(true)
                        end  
                    end
                end
            elseif k == 3 then
                if zstring.tonumber(v) == 0 and self.pushHeaven ~= nil then
                    self.pushHeaven:setVisible(false)
                elseif zstring.tonumber(v) == 1 and self.pushHeaven ~= nil then
                    self.pushHeaven:setVisible(true)
                end 
            elseif k == 4 then
                if zstring.tonumber(v) == 0 and self.pushDuplicate ~= nil then
                    self.pushDuplicate:setVisible(false)
                elseif zstring.tonumber(v) == 1 and self.pushDuplicate ~= nil then
                    self.pushDuplicate:setVisible(true)
                end 
            end
        end 
    end
    self.osTime = _ED.union_push_notification_time
end

function Union:onUpdate(dt)
    -- if _ED.union.union_info == nil and _ED.union.user_union_info == nil then
    --     local UnionWindow = fwin:find("UnionClass")
    --     if UnionWindow ~= nil and UnionWindow:isVisible() == true then
    --         fwin:close(UnionWindow)
    --         fwin:cleanView(fwin._view)
    --         if fwin:find("HomeClass") == nil then
    --             state_machine.excute("menu_manager", 0, 
    --                 {
    --                     _datas = {
    --                         terminal_name = "menu_manager",     
    --                         next_terminal_name = "menu_show_home_page", 
    --                         current_button_name = "Button_home",
    --                         but_image = "Image_home",       
    --                         terminal_state = 0, 
    --                         isPressedActionEnabled = true
    --                     }
    --                 }
    --             )
    --         end
    --         state_machine.excute("menu_back_home_page", 0, "")
    --     end
    -- end
    if _ED.union_push_notification_info ~= nil and _ED.union_push_notification_info ~= "" and _ED.union_push_notification_time ~= nil  then
        if self.osTime == nil then
            local root = self.roots[1]
            if root ~= nil then
                self:pushNotification()
            end
        else
            if self.osTime ~= _ED.union_push_notification_time then
                self:pushNotification()
            end
        end  
    end
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

function Union:onInit()
	local csbUnion = csb.createNode("legion/legion.csb")
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)
	
    
    local action = csb.createTimeline("legion/legion.csb")
    table.insert(self.actions, action)
    root:runAction(action)
    action:play("Button_124_touch_1", false)


    self.pushShop = ccui.Helper:seekWidgetByName(root, "Panel_781")
    self.pushHeaven = ccui.Helper:seekWidgetByName(root, "Panel_782")
    self.pushDuplicate = ccui.Helper:seekWidgetByName(root, "Panel_783")
    self.pushTime = ccui.Helper:seekWidgetByName(root, "Panel_784")
    self.pushShop:setVisible(false)
    self.pushHeaven:setVisible(false)
    self.pushDuplicate:setVisible(false)
    self.pushTime:setVisible(false)



    local csbUnion1 = csb.createNode("legion/legion_tuisong.csb")
    table.insert(self.roots, csbUnion1:getChildByName("root"))
    local path1 = "images/ui/play/legion/icon_jiangli.png"
    local image1 = ccui.Helper:seekWidgetByName(csbUnion1:getChildByName("root"), "Panel_tubiao")
    image1:setBackGroundImage(path1)
    local action1 = csb.createTimeline("legion/legion_tuisong.csb")
    table.insert(self.actions, action1)
    csbUnion1:runAction(action1)
    action1:play("tishi_donghua_1", true)
    self.pushShop:addChild(csbUnion1)


    local csbUnion2 = csb.createNode("legion/legion_tuisong.csb")
    table.insert(self.roots, csbUnion2:getChildByName("root"))
    local path2 = "images/ui/play/legion/icon_shuaxin.png"
    local image2 = ccui.Helper:seekWidgetByName(csbUnion2:getChildByName("root"), "Panel_tubiao")
    image2:setBackGroundImage(path2)
    local action2 = csb.createTimeline("legion/legion_tuisong.csb")
    table.insert(self.actions, action2)
    csbUnion2:runAction(action2)
    action2:play("tishi_donghua_1", true)
    self.pushTime:addChild(csbUnion2)

    local csbUnion3 = csb.createNode("legion/legion_tuisong.csb")
    table.insert(self.roots, csbUnion3:getChildByName("root"))
    local path3 = "images/ui/play/legion/zhuangxiu.png"
    local image3 = ccui.Helper:seekWidgetByName(csbUnion3:getChildByName("root"), "Panel_tubiao")
    image3:setBackGroundImage(path3)
    local action3 = csb.createTimeline("legion/legion_tuisong.csb")
    table.insert(self.actions, action3)
    csbUnion3:runAction(action3)
    action3:play("tishi_donghua_1", true)
    self.pushHeaven:addChild(csbUnion3)

    local csbUnion4 = csb.createNode("legion/legion_tuisong.csb")
    table.insert(self.roots, csbUnion4:getChildByName("root"))
    local path4 = "images/ui/play/legion/icon_jiangli.png"
    local image4 = ccui.Helper:seekWidgetByName(csbUnion4:getChildByName("root"), "Panel_tubiao")
    image4:setBackGroundImage(path4)
    local action4 = csb.createTimeline("legion/legion_tuisong.csb")
    table.insert(self.actions, action4)
    csbUnion4:runAction(action4)
    action4:play("tishi_donghua_1", true)
    self.pushDuplicate:addChild(csbUnion4)


    ccui.Helper:seekWidgetByName(root, "Button_124"):setVisible(true)

	self:updateDraw()
    -- local animationName = "juntuan_1"
    -- local jsonFile = "images/ui/effice/effice_ui_legion/juntuan_1.json"
    -- local atlasFile = "images/ui/effice/effice_ui_legion/juntuan_1.atlas"
    -- local  zhumingnamedh = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
    -- if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
    --     local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, true, nil)
    --     zhumingnamedh:addChild(animation)
    --     zhumingnamedh:setVisible(true)
    -- end



    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_124"), nil, 
    {
        terminal_name = "union_button_play_announcement", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)


	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_22"), nil, 
    {
        terminal_name = "union_return_home", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	--商店
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_24"), nil, 
    {
        terminal_name = "union_go_to_shop", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	--帮助
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_21"), nil, 
    {
        terminal_name = "union_look_help_information", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	-- 	排行榜
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_23"), nil, 
    {
        terminal_name = "union_go_to_rank", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_25"), nil, 
    {
        terminal_name = "union_go_to_heaven", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_26"), nil, 
    {
        terminal_name = "union_go_to_learn_skill", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
     fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_27"), nil, 
    {
        terminal_name = "union_go_to_learn_skill", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)


    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_28"), nil, 
    {
        terminal_name = "union_go_to_the_meeting_place", 
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
end

function Union:onEnterTransitionFinish()
	app.load("client.player.UserInformationShop") 					--顶部用户信息
	local userinfo = fwin:find("UserInformationShopClass")
	if userinfo == nil then
		fwin:open(UserInformationShop:new(),fwin._ui)
	end
end

function Union:init()
	self:onInit()
	return self
end

function Union:onExit()
	state_machine.remove("union_look_help_information")
	state_machine.remove("union_refresh_info")
	state_machine.remove("union_return_home")
	state_machine.remove("union_go_to_shop")
	state_machine.remove("union_go_to_heaven")
	state_machine.remove("union_go_to_duplicate")
	state_machine.remove("union_go_to_the_meeting_place")
	state_machine.remove("union_go_to_learn_skill")
	state_machine.remove("union_go_to_rank")
	state_machine.remove("union_button_play_announcement")
end

end