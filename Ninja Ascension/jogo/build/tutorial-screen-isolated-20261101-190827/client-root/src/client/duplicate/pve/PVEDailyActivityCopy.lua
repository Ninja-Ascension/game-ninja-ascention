----------------------------------------------------------------------------------------------------
-- 说明：日常活动副本
-------------------------------------------------------------------------------------------------------
PVEDailyActivityCopy = class("PVEDailyActivityCopyClass", Window)

function PVEDailyActivityCopy:ctor()
    self.super:ctor()
    self.roots = {}

    self.openCopys = {}
    self.copyId = 0
    self.needFood = 0
    self.currentIndex = 0
    self.currentUserVipLevel = 0
	
    app.load("client.cells.npc.plot_npc_cell")
    app.load("client.cells.copy.daily_activity_copy_title_cell")

	self:initCSB()
	
	local function init_pve_daily_activity_copy_terminal()

		local pve_daily_activity_copy_close_terminal = {
            _name = "pve_daily_activity_copy_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_daily_activity_copy_into_vip_privilege_erminal = {
            _name = "pve_daily_activity_copy_into_vip_privilege",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- TipDlg.drawTextDailog(_function_unopened_tip_string)
                state_machine.excute("shortcut_open_vip_privilege_window", 0, {1, vipLevel, attackCount})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_daily_activity_copy_request_fight_terminal = {
            _name = "pve_daily_activity_copy_request_fight",
            _init = function (terminal)
            app.load("client.duplicate.pve.PVEDailyActivityCopyRewardRanking")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(PVEDailyActivityCopyRewardRanking:new():init(instance.copyId, instance.needFood), fwin._ui)
                
				----体力足的提示
                -- if instance.needFood > zstring.tonumber(_ED.user_info.user_food) then
                    -- fwin:open(PropBuyPrompt:new():init(31, 1), fwin._dialog)
                    -- return
                -- end
                -- local function responseDailyInstanceCallback(response)
                    -- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- fwin:cleanView(fwin._windows)
                        -- local battleStartEffectWindow = BattleStartEffect:new()
                        ----battleStartEffectWindow:init(_enum_fight_type._fight_type_101 + response.node.copyId - 1)
                        -- battleStartEffectWindow:init(_enum_fight_type._fight_type_101)
                        -- fwin:open(battleStartEffectWindow, fwin._windows)
                    -- end
                -- end
                -- protocol_command.daily_instance.param_list = ""..instance.copyId
                -- NetworkManager:register(protocol_command.daily_instance.code, nil, nil, nil, instance, responseDailyInstanceCallback, true, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        local pve_daily_activity_copy_request_buy_fight_count_terminal = {
            _name = "pve_daily_activity_copy_request_buy_fight_count",
            _init = function (terminal)
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
				if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					 local vipLevel = zstring.tonumber(_ED.vip_grade)
					local resetCountElement = dms.element(dms["base_consume"], 54)
					local attackCount = dms.atoi(resetCountElement, base_consume.vip_0_value + vipLevel)
					local buytimes = zstring.tonumber(_ED.game_activity_buy_times)
					if buytimes < attackCount then   -- 已购买次数小于可购买次数
						 app.load("client.duplicate.pve.PVEGameActivityBuyCount")
						 
						 local config = zstring.split(dms.string(dms["pirates_config"], 291, pirates_config.param), ",")
						 local golds = config[buytimes+1]
						 local view = PVEGameActivityBuyCount:new():init(1,golds,(attackCount -buytimes),instance)
						fwin:open(view, fwin._windows)
					else
						if vipLevel < _ED.max_vip_level then
							local vipLevel = zstring.tonumber(_ED.vip_grade) + 1
							local resetCountElement = dms.element(dms["base_consume"], 54)
							local attackCount = dms.atoi(resetCountElement, base_consume.vip_0_value + vipLevel)
							state_machine.excute("shortcut_open_recharge_tip_dialog", 0, {1, vipLevel, attackCount})
						else
							TipDlg.drawTextDailog(_string_piece_info[238])
						end
					end
				else
					 local vipLevel = zstring.tonumber(_ED.vip_grade) + 1
					if vipLevel < _ED.max_vip_level then
						local resetCountElement = dms.element(dms["base_consume"], 54)
						local attackCount = dms.atoi(resetCountElement, base_consume.vip_0_value + vipLevel)
						state_machine.excute("shortcut_open_recharge_tip_dialog", 0, {1, vipLevel, attackCount})
					else
						TipDlg.drawTextDailog(_string_piece_info[238])
					end
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_daily_activity_copy_change_to_page_terminal = {
            _name = "pve_daily_activity_copy_change_to_page",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local pageIndex = params
                instance:changeToPage(pageIndex)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
			--界面刷新
        local pve_daily_activity_copy_updata_terminal = {
            _name = "pve_daily_activity_copy_updata",
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
		
		state_machine.add(pve_daily_activity_copy_close_terminal)
        state_machine.add(pve_daily_activity_copy_into_vip_privilege_erminal)
        state_machine.add(pve_daily_activity_copy_request_fight_terminal)
        state_machine.add(pve_daily_activity_copy_request_buy_fight_count_terminal)
        state_machine.add(pve_daily_activity_copy_change_to_page_terminal)
		state_machine.add(pve_daily_activity_copy_updata_terminal)
        state_machine.init()
	end
	init_pve_daily_activity_copy_terminal()
end

function PVEDailyActivityCopy:init(_copyId)
    self.copyId = _copyId
    -- _ED._current_scene_id = copyId
    -- _ED._scene_npc_id = dms.string(dms["daily_instance_mould"], tonumber(self.copyId), daily_instance_mould.npc)
    -- _ED._npc_difficulty_index = 0
    -- _ED._npc_addition_params = ""

    local vipLevel = zstring.tonumber(_ED.vip_grade)
    local needDrawClose = false
    local nCount = #dms["daily_instance_mould"]
    for i, v in pairs(dms["daily_instance_mould"]) do
        local needVipLevel = dms.atoi(v, daily_instance_mould.need_viplevel)
        if needVipLevel == nil or _ED.max_vip_level < needVipLevel then 
            break
        end
        if needVipLevel <= vipLevel then
            table.insert(self.openCopys, v)
		else
			table.insert(self.openCopys, v)
			break
        end
    end

    return self
end

function PVEDailyActivityCopy:changeToPage(pageIndex)
    local root = self.roots[1]

    local pageView = ccui.Helper:seekWidgetByName(root, "PageView_1")
    local currentPageIndex = pageView:getCurPageIndex()
    if currentPageIndex ~= pageIndex then
        pageView:scrollToPage(pageIndex)
    end
end

function PVEDailyActivityCopy:initCopyTabListView()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")

    local vipLevel = zstring.tonumber(_ED.vip_grade)
    for i, v in pairs(self.openCopys) do
        local copyId = dms.atoi(v, daily_instance_mould.id)
        local needVipLevel = dms.atoi(v, daily_instance_mould.need_viplevel)
        local npcId = dms.atoi(v, daily_instance_mould.npc)
        local dailyActivityCopyTitleCell = DailyActivityCopyTitleCell:createCell()
        if needVipLevel <= vipLevel then
            -- card/card_role.csb
        else

        end
		dailyActivityCopyTitleCell:init(v, needVipLevel <= vipLevel, listView)
        listView:addChild(dailyActivityCopyTitleCell)
		if self.copyId == copyId then
			-- state_machine.excute("daily_activity_copy_title_cell_select_npc", 0, {_datas = {_cell = dailyActivityCopyTitleCell}})
            self.currentIndex = i
            --> print("self.copyId == copyId:", self.copyId, copyId, self.currentIndex)
            --> debug.print_r(v)
		end
    end
end

function PVEDailyActivityCopy:initCopyNpcHeadPageView()
    local root = self.roots[1]

    local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
    local pageView = ccui.Helper:seekWidgetByName(root, "PageView_1")

    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
            local pageView = sender
            local currentPageIndex = pageView:getCurPageIndex() + 1
            self.currentIndex = currentPageIndex
            local currentPage = pageView:getPage(pageView:getCurPageIndex())
            local copyId = dms.atoi(self.openCopys[currentPageIndex], daily_instance_mould.id)
            self.copyId = copyId
			self:onUpdateDraw()
            state_machine.excute("plot_npc_cell_show_fizz", 0, currentPage)

            local items = listView:getItems()
            local dailyActivityCopyTitleCell = items[currentPageIndex]
            state_machine.excute("daily_activity_copy_title_cell_select_npc", 0, {_datas = {_cell = dailyActivityCopyTitleCell}})
            state_machine.excute("duplicate_update_selected_data", 0, {copyId})
            state_machine.excute("duplicate_controller_update_draw_tile_info", 0, "")
        end
    end 

    pageView:addEventListener(pageViewEvent)


    local vipLevel = zstring.tonumber(_ED.vip_grade)
    for i, v in pairs(self.openCopys) do
        local needVipLevel = dms.atoi(v, daily_instance_mould.need_viplevel)
        local npcId = dms.atoi(v, daily_instance_mould.npc)
        local plotNpcCell = PlotNPCCell:createCell()
        if needVipLevel <= vipLevel then
            -- card/card_role.csb
        else

        end
        plotNpcCell:init(npcId, 1, 2)
        pageView:addPage(plotNpcCell)
    end
end

function PVEDailyActivityCopy:onUpdate(dt)
    local vipLevel = zstring.tonumber(_ED.vip_grade)
    if vipLevel ~= self.currentUserVipLevel then
        self:onUpdateDraw()
    end
end

function PVEDailyActivityCopy:onUpdateDraw()
	local root = self.roots[1]
	local pageView = ccui.Helper:seekWidgetByName(root, "PageView_1")
	local vipLevel = zstring.tonumber(_ED.vip_grade)
	local currentPageIndex = pageView:getCurPageIndex() + 1
	local elementData = self.openCopys[currentPageIndex]
	local additionData = dms.element(dms["daily_instance_addition"], vipLevel + 1)
    local attackCountElement = dms.element(dms["base_consume"], 53)
    local resetCountElement = dms.element(dms["base_consume"], 54)
	
    local npcElement = dms.element(dms["npc"], dms.atoi(elementData, daily_instance_mould.npc))

	-- 绘制奖励图标
	local rewardIcon = ResourcesIconCell:createCell()
	local rewardType = dms.atoi(elementData, daily_instance_mould.reward_type)
	local rewardMouldId = dms.atoi(elementData, daily_instance_mould.reward_id)

    self.currentUserVipLevel = vipLevel

	rewardIcon:init(rewardType, 0, rewardMouldId <= 0 and -1 or rewardMouldId)
	ccui.Helper:seekWidgetByName(root, "Panel_4"):addChild(rewardIcon)
	rewardIcon:hideCount(false)
	-- 绘制奖励的数量
	ccui.Helper:seekWidgetByName(root, "Text_812"):setString(dms.atos(elementData, daily_instance_mould.reward_value))
	
	-- 绘制当前用户的VIP信息
	ccui.Helper:seekWidgetByName(root, "Text_814"):setString(_emailTypeSystemTip[2] .. vipLevel)
	
	-- 绘制当前用户的生命加成
	ccui.Helper:seekWidgetByName(root, "Text_816"):setString("+"..dms.atos(additionData, daily_instance_addition.power_addition))
	
	-- 绘制当前用户的攻击加成
	ccui.Helper:seekWidgetByName(root, "Text_818"):setString("+"..dms.atos(additionData, daily_instance_addition.attack_addition))
	
	-- 绘制体力消耗
	self.needFood = dms.atoi(npcElement, npc.attack_need_food)
	ccui.Helper:seekWidgetByName(root, "Text_9_0"):setString("" .. self.needFood)
	
	-- 今日挑战次数
	local fightCount = dms.atoi(attackCountElement, base_consume.vip_0_value + vipLevel) - zstring.tonumber(_ED.game_activity_times)
	ccui.Helper:seekWidgetByName(root, "Text_12"):setString(""..fightCount)
end

function PVEDailyActivityCopy:initMoveListener()
    local root = self.roots[1]
    local pageView = ccui.Helper:seekWidgetByName(root, "PageView_1")
    local moveController = ccui.Helper:seekWidgetByName(root, "Panel_156")
    moveController:setSwallowTouches(false)

    local function pageViewMoveListenerCallback(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            local pages = pageView:getPages()
            for i, v in pairs(pages) do
                state_machine.excute("plot_npc_cell_hide_fizz", 0, v)
            end
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended then
        elseif eventType == ccui.TouchEventType.canceled then
        end
    end
    moveController:addTouchEventListener(pageViewMoveListenerCallback)
end


function PVEDailyActivityCopy:initCSB()
	local csbPVEDailyActivityCopy = csb.createNode("duplicate/GameActivity/GameActivity.csb")
    local root = csbPVEDailyActivityCopy:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPVEDailyActivityCopy)

end


function PVEDailyActivityCopy:onEnterTransitionFinish()
	
	local root = self.roots[1]
	
    -- 绘制副本图标列表
    self:initCopyTabListView()

    -- 绘制副本NPC头像翻页列表窗口
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	
	else
		self:initCopyNpcHeadPageView()
		-- 定位焦点npc
		-- self:changeToPage(self.currentIndex - 1)
		local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
		state_machine.excute("daily_activity_copy_title_cell_select_npc", 0, {_datas = {_cell = listView:getItems()[self.currentIndex]}})
		--> print("self.currentIndex:", self.currentIndex)
			
		-- 初始化滑动的事件监听
		self:initMoveListener()
	
		-- 更新界面信息
		self:onUpdateDraw()

		-- 跳转到VIP权限界面
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103"), nil, 
		{
			terminal_name = "pve_daily_activity_copy_into_vip_privilege",     
			current_button_name = "Button_103",       
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)

		-- 请求战斗
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
		{
			terminal_name = "pve_daily_activity_copy_request_fight",     
			current_button_name = "Button_2",       
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)

		-- 增加挑战次数
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
		{
			terminal_name = "pve_daily_activity_copy_request_buy_fight_count",     
			current_button_name = "Button_3",     
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, nil, 0)
	end
end

function PVEDailyActivityCopy:onExit()
	state_machine.remove("pve_daily_activity_copy_close")
    state_machine.remove("pve_daily_activity_copy_into_vip_privilege")
    state_machine.remove("pve_daily_activity_copy_request_fight")
    state_machine.remove("pve_daily_activity_copy_request_buy_fight_count")
    state_machine.remove("pve_daily_activity_copy_change_to_page")
	state_machine.remove("pve_daily_activity_copy_updata")
end