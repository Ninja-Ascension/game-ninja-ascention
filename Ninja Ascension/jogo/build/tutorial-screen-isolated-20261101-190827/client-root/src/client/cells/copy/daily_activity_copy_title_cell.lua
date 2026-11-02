----------------------------------------------------------------------------------------------------
-- 说明：日常活动副本的标题部件
-------------------------------------------------------------------------------------------------------
DailyActivityCopyTitleCell = class("DailyActivityCopyTitleCellClass", Window)
 
function DailyActivityCopyTitleCell:ctor()
    self.super:ctor()
	self.roots = {}
	
	self._dailyInstanceMould = nil
	self._isOpened = false
	self._listView = nil
	
    -- Initialize daily activity copy title cell page state machine.
    local function init_daily_activity_copy_title_cell_terminal()
        local daily_activity_copy_title_cell_select_npc_terminal = {
            _name = "daily_activity_copy_title_cell_select_npc",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                params._datas._cell:selectNpc()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local daily_activity_copy_title_cell_post_fight_terminal = {
			_name = "daily_activity_copy_title_cell_post_fight",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				params._datas._cell:challenge()
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		state_machine.add(daily_activity_copy_title_cell_post_fight_terminal)
        state_machine.add(daily_activity_copy_title_cell_select_npc_terminal)
        state_machine.init()
    end

    -- call func init daily activity copy title cell state machine.
    init_daily_activity_copy_title_cell_terminal()
end


function DailyActivityCopyTitleCell:challenge()
	-- 判断是否有可挑次数
	if self:getFightCount() <= 0 then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			local vipLevel = zstring.tonumber(_ED.vip_grade)
			local resetCountElement = dms.element(dms["base_consume"], 54)
			local attackCount = dms.atoi(resetCountElement, base_consume.vip_0_value + vipLevel)
			local buytimes = zstring.tonumber(_ED.game_activity_buy_times)
			if buytimes < attackCount then   -- 已购买次数小于可购买次数
				TipDlg.drawTextDailog(_string_piece_info[253])
				return false
			else
				if vipLevel < _ED.max_vip_level then
					local vipLevel = zstring.tonumber(_ED.vip_grade) + 1
					local resetCountElement = dms.element(dms["base_consume"], 54)
					local attackCount = dms.atoi(resetCountElement, base_consume.vip_0_value + vipLevel)
					state_machine.excute("shortcut_open_recharge_tip_dialog", 0, {1, vipLevel, attackCount})
					return false
				else
					TipDlg.drawTextDailog(_string_piece_info[253])
					return false
				end
			end
		-- else
			-- local vipLevel = zstring.tonumber(_ED.vip_grade)
			-- local vipLevel = zstring.tonumber(_ED.vip_grade) + 1
			-- if vipLevel < _ED.max_vip_level then
				-- local resetCountElement = dms.element(dms["base_consume"], 54)
				-- local attackCount = dms.atoi(resetCountElement, base_consume.vip_0_value + vipLevel)
				-- state_machine.excute("shortcut_open_recharge_tip_dialog", 0, {1, vipLevel, attackCount})
				-- return false
			-- else
				-- TipDlg.drawTextDailog(_string_piece_info[253])
				-- return false
			-- end
		end	
	end
	-- 体力足的提示
	--print("有挑战次数.....")
	if self.needFood > zstring.tonumber(_ED.user_info.user_food) then
		app.load("client.cells.prop.prop_buy_prompt")
		fwin:open(PropBuyPrompt:new():init(31, 1), fwin._ui)
		return
	end
	--print("有体力.....")
	
	local function responseDailyInstanceCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		-- print("请求成功....")
			_ED._current_scene_id = 0
			_ED._scene_npc_id = dms.string(dms["daily_instance_mould"], tonumber(response.node.copyId), daily_instance_mould.npc)

			_ED._npc_difficulty_index = 0
			_ED._npc_addition_params = ""
			_ED._daily_copy_npc_id = response.node.copyId

			app.load("client.battle.BattleStartEffect")
			local battleStartEffectWindow = BattleStartEffect:new()
			-- battleStartEffectWindow:init(_enum_fight_type._fight_type_101 + response.node.copyId - 1)
			battleStartEffectWindow:init(_enum_fight_type._fight_type_101)
			fwin:cleanView(fwin._windows)
			fwin:open(battleStartEffectWindow, fwin._windows)
		end
	end

	local function launchBattle()
		--print("开始请求...", self._dailyInstanceMould)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			app.load("client.battle.fight.FightEnum")
			local fightType = state_machine.excute("fight_get_current_fight_type", 0, nil)
			if fightType ~= _enum_fight_type._fight_type_10 and
				fightType ~= _enum_fight_type._fight_type_11 and 
				fightType ~= _enum_fight_type._fight_type_14 and 
				fightType ~= _enum_fight_type._fight_type_102 then
				app.load("client.battle.report.BattleReport")
				local resultBuffer = {}
				if _ED._fightModule == nil then
					_ED._fightModule = FightModule:new()
				end
				_ED.attackData = {
					roundCount = _ED._fightModule.totalRound,
					roundData ={}
				}
				
				local copyId = dms.atoi(self._dailyInstanceMould, daily_instance_mould.id)
				
				_ED._current_scene_id = 0
				_ED._scene_npc_id = dms.string(dms["daily_instance_mould"], tonumber(copyId), daily_instance_mould.npc)
				local roundCount = dms.atoi(self._dailyInstanceMould,daily_instance_mould.round_count)
			
				_ED._npc_difficulty_index = 0
				_ED._npc_addition_params = ""
				_ED._daily_copy_npc_id = copyId
				self.copyId = copyId
				_ED._fightModule.dailyRoundCount = roundCount
				_ED._fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, _enum_fight_type._fight_type_101, resultBuffer)
				local orderList = {}
				_ED._fightModule:initFightOrder(_ED.user_info, orderList)
				
				

				responseDailyInstanceCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0, node = self})
			end
		else
			local copyId = dms.atoi(self._dailyInstanceMould, daily_instance_mould.id)
					--print("copyId..",copyId)
			protocol_command.daily_instance.param_list = ""..copyId
			NetworkManager:register(protocol_command.daily_instance.code, nil, nil, nil, self, responseDailyInstanceCallback, false, nil)
		end
	end
	
	launchBattle()

end


function DailyActivityCopyTitleCell:getFightCount()
    local vipLevel = zstring.tonumber(_ED.vip_grade)
    local attackCountElement = dms.element(dms["base_consume"], 53)
	self.fightCount = dms.atoi(attackCountElement, base_consume.vip_0_value + vipLevel) - zstring.tonumber(_ED.game_activity_times)

    return self.fightCount
end

--

function DailyActivityCopyTitleCell:updateListViewPosition()
	local listViewSize = self._listView:getContentSize()
	local innerLayout = self._listView:getInnerContainer()
	local innerPosition = cc.p(innerLayout:getPosition())
	local currentIndex = 0
	local items = self._listView:getItems()
	for i, v in pairs(items) do
		if v == self then
			break;
		end
		currentIndex = currentIndex + 1
	end
	local margin = self._listView:getItemsMargin()
	local size = self:getContentSize()
	local beginPosition = cc.p(-1 * currentIndex * (size.width + margin), 0)
	local endPosition = cc.p(-1 * currentIndex * (size.width + margin) + listViewSize.width - size.width, 0)
	if innerPosition.x < beginPosition.x then
		innerLayout:runAction(cc.MoveTo:create(0.3, cc.p(beginPosition.x, innerPosition.y)))
	elseif innerPosition.x > endPosition.x then
		innerLayout:runAction(cc.MoveTo:create(0.3, cc.p(endPosition.x, innerPosition.y)))
	end

	state_machine.excute("pve_daily_activity_copy_change_to_page", 0, currentIndex)
end

function DailyActivityCopyTitleCell:selectNpc()
	local items = self._listView:getItems()
	for i, v in pairs(items) do
		v:unselectNpc()
	end
	local root = self.roots[1]
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		if self._isOpened == true then
			ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(false)
		end
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			ccui.Helper:seekWidgetByName(root, "Image_41"):setVisible(false)
		else
			ccui.Helper:seekWidgetByName(root, "Image_41"):setVisible(true)
		end
		
		self:updateListViewPosition()
	end
end

function DailyActivityCopyTitleCell:unselectNpc()
	local root = self.roots[1]
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		if self._isOpened == true then
			ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
		end
		ccui.Helper:seekWidgetByName(root, "Image_41"):setVisible(false)
	end
end

function DailyActivityCopyTitleCell:onUpdateDraw()
	local root = self.roots[1]	
	
	local picIndex = dms.atoi(self._dailyInstanceMould, daily_instance_mould.instance_pic)
	local filePath = string.format("images/ui/pve_sn/gameActivity/richang_tuanka_icon_%s%d.png", self._isOpened == true and "" or "a", picIndex)
	ccui.Helper:seekWidgetByName(root, self._isOpened == true and "Panel_rcfb_1" or "Panel_rcfb_2"):setBackGroundImage(filePath)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		ccui.Helper:seekWidgetByName(root, "Image_4"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(true)
		if self._isOpened == true then
			ccui.Helper:seekWidgetByName(root, "Panel_10"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Panel_hui_4"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_3"):setString("")
			ccui.Helper:seekWidgetByName(root, "Text_4"):setString("")
		else
			ccui.Helper:seekWidgetByName(root, "Button_123_tz"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_345_tili"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_345"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Panel_10"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Panel_hui_4"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_3"):setString(_emailTypeSystemTip[2] .. dms.atos(self._dailyInstanceMould, daily_instance_mould.need_viplevel))
			ccui.Helper:seekWidgetByName(root, "Text_4"):setString(_opened_tip)
		end
	else
		if self._isOpened == true then
			ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Panel_10"):setVisible(true)
		else
			ccui.Helper:seekWidgetByName(root, "Panel_hui_4"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_3"):setString(_emailTypeSystemTip[2] .. dms.atos(self._dailyInstanceMould, daily_instance_mould.need_viplevel))
			ccui.Helper:seekWidgetByName(root, "Text_4"):setString(_opened_tip)
			if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
				ccui.Helper:seekWidgetByName(root, self._isOpened == true and "Panel_rcfb_1" or "Panel_rcfb_2"):setVisible(false)
			end
			
		end
	end
	local iconPath = string.format("images/ui/pve_sn/gameActivity/icon_%d.png", picIndex)
	ccui.Helper:seekWidgetByName(root, "Panel_suoyin_3"):setBackGroundImage(iconPath)
end

function DailyActivityCopyTitleCell:onEnterTransitionFinish()
    local csbEquipPatchListCell = csb.createNode("duplicate/GameActivity/GameActivity_icon.csb")
	local root = csbEquipPatchListCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(true)
	self:addChild(root)
	local panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_2")
	local panelSize = panel:getContentSize()
	self:setContentSize(panelSize)

	self:onUpdateDraw()	
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local vipLevel = zstring.tonumber(_ED.vip_grade)
		local attackCountElement = dms.element(dms["base_consume"], 53)
		local npcElement = dms.element(dms["npc"], dms.atoi(self._dailyInstanceMould, daily_instance_mould.npc))
		-- 绘制体力消耗
		self.needFood = dms.atoi(npcElement, npc.attack_need_food)
		ccui.Helper:seekWidgetByName(root, "Text_345_tili"):setString("" .. self.needFood)
		
		-- 今日挑战次数
		local fightCount = dms.atoi(attackCountElement, base_consume.vip_0_value + vipLevel) - zstring.tonumber(_ED.game_activity_times)
		ccui.Helper:seekWidgetByName(root, "Text_123_tzcx"):setString(""..fightCount)
		
		local dec = dms.atos(npcElement, npc.sign_msg)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(dec))
            dec = word_info[3]
        end
		local Text_huode = ccui.Helper:seekWidgetByName(root,"Text_huode")
		Text_huode:setString(dec)
		-- request fight
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_123_tz"), nil, 
		{
			terminal_name = "daily_activity_copy_title_cell_post_fight",   
			terminal_state = 0,
			_cell = self
		}, nil, 0)
	else
		-- 选择要挑战的副本NPC
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, 
		{
			terminal_name = "daily_activity_copy_title_cell_select_npc",   
			terminal_state = 0, 
			_cell = self
		}, nil, 0)
	end
end

function DailyActivityCopyTitleCell:onExit()	

end

function DailyActivityCopyTitleCell:init(_dailyInstanceMould, _isOpened, _listView)
	self._dailyInstanceMould = _dailyInstanceMould
	self._isOpened = _isOpened
	self._listView = _listView
	return self
end

function DailyActivityCopyTitleCell:createCell()
	local cell = DailyActivityCopyTitleCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end