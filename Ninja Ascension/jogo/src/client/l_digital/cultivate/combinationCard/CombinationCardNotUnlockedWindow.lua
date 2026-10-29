--[[ ----------------------------------------------------------------------------
-- 组合卡主界面
--]] ----------------------------------------------------------------------------
CombinationCardNotUnlockedWindow = class("CombinationCardNotUnlockedWindowClass", Window)

-- 打开窗口
local combination_card_not_unlocked_window_open_terminal = {
	_name = "combination_card_not_unlocked_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CombinationCardNotUnlockedWindowClass") then
			fwin:open(CombinationCardNotUnlockedWindow:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local combination_card_not_unlocked_window_close_terminal = {
	_name = "combination_card_not_unlocked_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		state_machine.excute("combination_card_refresh_list",0,"")
		fwin:close(fwin:find("CombinationCardNotUnlockedWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(combination_card_not_unlocked_window_open_terminal)
state_machine.add(combination_card_not_unlocked_window_close_terminal)
state_machine.init()

-- 构造器
function CombinationCardNotUnlockedWindow:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.is_lock = true		--是否解锁
	self.ship_mould_id = nil		-- 组合卡模版id
	self.last_solt_id = -1	-- 上次点击的槽位
	self.solt_infos = {}	--槽位数组信息
	self.can_aim_break = true -- 是否达到升阶条件
	self.can_aim_break_prop = true -- 升阶道具是否够
	self.can_aim_break_condition = true 
	self.can_aim_up = true 	-- 是否达到升级条件
	self.can_solt_unlock = true
	self.buttonType = 1 	-- 防止过快点击按钮
	-- load lua files.
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.ship.hero_icon_list_cell")
	app.load("client.cells.ship.ship_icon_cell")
	app.load("client.l_digital.cultivate.combinationCard.CombinationCardClipHead")
	app.load("client.cells.ship.ship_head_new_cell")
	app.load("client.l_digital.cultivate.combinationCard.CombinationCardSell")
	app.load("client.l_digital.cultivate.combinationCard.CombinationCardTabWindow")
	app.load("client.l_digital.cultivate.combinationCard.CombinationCardUpgrade")
	
	-- Initialize combination card not unlocked window page state machine.
	local function init_combination_card_not_unlocked_window_terminal()

		-- 显示窗口
		local combination_card_not_unlocked_window_show_terminal = {
			_name = "combination_card_not_unlocked_window_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local combination_card_not_unlocked_window_hide_terminal = {
			_name = "combination_card_not_unlocked_window_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 跳转获得卡牌界面
		local combination_card_unlocked_condition_card_get_terminal = {
			_name = "combination_card_unlocked_condition_card_get",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("shortcut_function_trace", 0, {trace_function_id = 291, _datas = {}})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 解锁组合卡
		local combination_card_click_unlock_card_terminal = {
			_name = "combination_card_click_unlock_card",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.lock("combination_card_click_unlock_card",0,"")
				if not params then
					return
				end
				local shipId = params._datas.ship_id

				local function responseInitCallBack( response )
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						instance:openTipDraw(tipStringInfo_combination_card_tip[1])
						state_machine.excute("combination_card_unlock_window_refresh",0,"")
					end
				end
				
				local function responseUnlockCallBack( response )
					state_machine.unlock("combination_card_click_unlock_card",0,"")
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						protocol_command.combine_ship_init.param_list = "" 
						NetworkManager:register(protocol_command.combine_ship_init.code, nil, nil, nil, instance, responseInitCallBack, false, nil)
					end
				end
				protocol_command.combine_ship_unlock_card.param_list = ""..shipId
				NetworkManager:register(protocol_command.combine_ship_unlock_card.code, nil, nil, nil, instance, responseUnlockCallBack, false, nil)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击槽位处理
		local combination_card_slot_click_terminal = {
			_name = "combination_card_slot_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local mType = tonumber(params._datas.m_type)
				if -1 ~= instance.last_solt_id and -1 == CombinationCardHandle.getOneSoltInfoById(instance.last_solt_id).shipId then
					instance.last_solt_id = mType
					instance:onUpdateDraw()
					return true
				end

				local soltInfos = instance.solt_infos[mType]

				local cardId = instance.ship_mould_id
				if instance.last_solt_id == mType then
					-- 没有符合的卡
					if 0 == CombinationCardHandle.getCanAddCardUp(cardId,mType,soltInfos.ship_id_can,soltInfos.ship_id_have) then
						TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[8])
						return true
					end
					-- 组合卡上阵不给下阵固定镶嵌槽
					if 0 < tonumber(soltInfos.ship_id_can) and 0 < tonumber(soltInfos.ship_id_have) and CombinationCardHandle.getIsUpLoadFlag(cardId) then
						TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[9])
						return true
					end
					instance:onUpdateDraw()
					-- 打开背包
					instance.last_solt_id = -1
					state_machine.excute("connecting_view_window_open",0,0)
					state_machine.excute("combination_card_sell_window_open",0,{card_id = cardId,solt_id = mType,
						ship_mould_id_can = soltInfos.ship_id_can,
							ship_mould_id_have = soltInfos.ship_id_have })
				else
					-- 显示加成升级升阶
					instance.last_solt_id = mType
					instance:onUpdateDraw()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击碎片兑换
		local combination_card_chip_exchange_click_terminal = {
			_name = "combination_card_chip_exchange_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local shipMouldId = params._datas.ship_mould_id
				state_machine.excute("combination_card_tab_window_open",0,{shipMouldId})

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 升级按钮
		local combination_card_up_level_click_terminal = {
			_name = "combination_card_up_level_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil == instance then
					return true
				end
				
				if not instance.can_aim_up then
					TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[12])
					return true
				end
				if 2 == instance.buttonType then
					return true
				end
				
				local soltId = instance.last_solt_id
				local soltInfo = CombinationCardHandle.getOneSoltInfoById(soltId)
				local level = soltInfo.slotLevel
				local groupId = soltInfo.groupId
				local maxLevel = self:getMaxLevelByGroupID(groupId)
				if level >= maxLevel then
					TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[13])
					return true
				end

				instance.buttonType = 2
				state_machine.lock("combination_card_up_level_click",0,"")
				local cardId = instance.ship_mould_id
				local shipId = soltInfo.shipId
				local mouldId = 0
				if _ED.user_ship[""..shipId] then
					mouldId = _ED.user_ship[""..shipId].ship_template_id
				end

				local function responseUpLevelCallBack( response )
					
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[2])
						state_machine.excute("combination_card_unlock_window_refresh",0,"")
						smFightingChange()
						state_machine.unlock("combination_card_up_level_click",0,"")
					else
						state_machine.unlock("combination_card_up_level_click",0,"")
					end
				end
				protocol_command.combine_ship_update_slot.param_list = ""..cardId.."\r\n"..(soltId - 1).."\r\n"..mouldId.."\r\n"..level.."\r\n"..groupId
				NetworkManager:register(protocol_command.combine_ship_update_slot.code, nil, nil, nil, instance, responseUpLevelCallBack, false, nil)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 升阶按钮
		local combination_card_break_click_terminal = {
			_name = "combination_card_break_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil == instance then
					return true
				end
				
				if not instance.can_aim_break then
					TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[7])
					return true
				end
				if not instance.can_aim_break_prop then
					TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[12])
					return true
				end
				if 2 == instance.buttonType then
					return true
				end
				instance.buttonType = 2
				state_machine.lock("combination_card_break_click",0,"")
				local cardId = instance.ship_mould_id
				local soltId = instance.last_solt_id
				local soltInfo = CombinationCardHandle.getOneSoltInfoById(soltId)
				local shipId = soltInfo.shipId
				local mouldId = 0
				if _ED.user_ship[""..shipId] then
					mouldId = _ED.user_ship[""..shipId].ship_template_id
				end
				local level = soltInfo.slotLevel
				local groupId = soltInfo.groupId

				local function responseUpLevelCallBack( response )
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[3])
						state_machine.excute("combination_card_unlock_window_refresh",0,"")
						smFightingChange()
						state_machine.unlock("combination_card_break_click",0,"")
					else
						state_machine.unlock("combination_card_break_click",0,"")
					end
				end
				protocol_command.combine_ship_update_slot.param_list = ""..cardId.."\r\n"..(soltId - 1).."\r\n"..mouldId.."\r\n"..level.."\r\n"..groupId
				NetworkManager:register(protocol_command.combine_ship_update_slot.code, nil, nil, nil, instance, responseUpLevelCallBack, false, nil)

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 解锁槽位
		local combination_card_solt_unlock_click_terminal = {
			_name = "combination_card_solt_unlock_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.lock("combination_card_solt_unlock_click",0,"")
				if instance then
					if not instance.can_solt_unlock then
						TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[7])
						state_machine.unlock("combination_card_solt_unlock_click",0,"")
						return true
					end
					local cardId = instance.ship_mould_id
					local soltId = instance.last_solt_id
					
					local function responseSoltUnlockCallBack( response )
						state_machine.unlock("combination_card_solt_unlock_click",0,"")
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[4])
							state_machine.excute("combination_card_unlock_window_refresh",0,"")
						end
					end
					protocol_command.combine_ship_unlock_slot.param_list = ""..cardId.."\r\n"..(soltId - 1)
					NetworkManager:register(protocol_command.combine_ship_unlock_slot.code, nil, nil, nil, instance, responseSoltUnlockCallBack, false, nil)
				end

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 界面刷新
		local combination_card_unlock_window_refresh_terminal = {
			_name = "combination_card_unlock_window_refresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if params and "" ~= params then
					instance.last_solt_id = params
				end
				if instance then
					local function responseOneDetailCallBack( response )
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 and response.node ~= nil and response.node.roots[1] ~= nil then
							instance:onUpdateDraw()
							instance:redTipPush()
						end
					end

					protocol_command.combine_ship_get_one.param_list = ""..instance.ship_mould_id
					NetworkManager:register(protocol_command.combine_ship_get_one.code, nil, nil, nil, instance, responseOneDetailCallBack, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--随机播放角色动作
		local combination_card_change_hero_sprite_info_play_animation_terminal = {
		    _name = "combination_card_change_hero_sprite_info_play_animation",
		    _init = function (terminal)

		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
			_invoke = function(terminal, instance, params)
		    	-- instance._bust_index = instance._bust_index
		    	local ship = getShipByTemplateId(instance.ship_mould_id)
		    	local ship_evo = zstring.split(ship.evolution_status, "|")
				instance._bust_index = tonumber(ship_evo[1])
		    	instance:newFormationShowShipChange(instance._bust_index)
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		--打开一键升级界面
		local combination_card_open_upgrade_terminal = {
		    _name = "combination_card_open_upgrade",
		    _init = function (terminal)

		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
			_invoke = function(terminal, instance, params)
		    	if instance ~= nil then
					if not instance.can_aim_up then
						TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[12])
						return true
					end

					local cardId = instance.ship_mould_id
					local soltId = instance.last_solt_id
					local soltInfo = CombinationCardHandle.getOneSoltInfoById(soltId)
					local level = soltInfo.slotLevel
					local groupId = soltInfo.groupId
					local maxLevel = self:getMaxLevelByGroupID(groupId)
					if level >= maxLevel then
						TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[13])
						return true
					end
					
					state_machine.excute("combination_card_upgrade_window_open", 0, {cardId, soltId})
				end
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}

		state_machine.add(combination_card_not_unlocked_window_show_terminal)
		state_machine.add(combination_card_not_unlocked_window_hide_terminal)
		state_machine.add(combination_card_unlocked_condition_card_get_terminal)
		state_machine.add(combination_card_click_unlock_card_terminal)
		state_machine.add(combination_card_slot_click_terminal)
		state_machine.add(combination_card_chip_exchange_click_terminal)
		state_machine.add(combination_card_up_level_click_terminal)
		state_machine.add(combination_card_break_click_terminal)
		state_machine.add(combination_card_unlock_window_refresh_terminal)
		state_machine.add(combination_card_solt_unlock_click_terminal)
		state_machine.add(combination_card_change_hero_sprite_info_play_animation_terminal)
		state_machine.add(combination_card_open_upgrade_terminal)

		state_machine.init()
	end
	-- call func init combination card not unlocked window state machine.
	init_combination_card_not_unlocked_window_terminal()
end

-- 获取当前库组最大等级
function CombinationCardNotUnlockedWindow:getMaxLevelByGroupID(groupId)
	local curGroupInfo = dms.searchs(dms["comb_inset"], comb_inset.groupId, groupId) 
	return table.nums(curGroupInfo)
end

-- 固定无需刷新界面控件
function CombinationCardNotUnlockedWindow:onFixDraw()
	local root = self.roots[1]
	-- 卡牌星级显示
	local starLevel = 0
	if getShipByTemplateId(self.ship_mould_id) then
		starLevel = tonumber(getShipByTemplateId(self.ship_mould_id).StarRating)
	else
		starLevel = dms.int(dms["ship_mould"], self.ship_mould_id, ship_mould.ship_star)
	end
	for i=1,7 do
		local Image_star = ccui.Helper:seekWidgetByName(root, "juexing_rukou_2_0"):getChildByName("Image_star_"..i)
		Image_star:setVisible(false)
		if i <= starLevel then
			Image_star:setVisible(true)
		end
	end
	
	local pic = dms.int(dms["ship_mould"], self.ship_mould_id, ship_mould.All_icon)
	-- 角色立绘名称
	self.Image_dizuo_0 = ccui.Helper:seekWidgetByName(root, "Image_dizuo_0")
	if cc.FileUtils:getInstance():isFileExist(string.format("images/ui/text/TF_res/combination_card/combination_card_wenzi2_%d.png", pic)) then
		self.Image_dizuo_0:loadTexture(string.format("images/ui/text/TF_res/combination_card/combination_card_wenzi2_%d.png", pic))
	end
	-- 角色立绘
	self.Panel_lihui = ccui.Helper:seekWidgetByName(root, "Panel_lihui")
	self.Panel_lihui:removeBackGroundImage()
	self.Panel_lihui:removeAllChildren(true)
	if getShipByTemplateId(self.ship_mould_id) then
		--进化形象
		-- 随机播放动画
		
		if self.Panel_lihui ~= nil then
			fwin:addTouchEventListener(self.Panel_lihui, nil, 
			{
				terminal_name = "combination_card_change_hero_sprite_info_play_animation", 
				terminal_state = 0,
				isPressedActionEnabled = true
			}, 
			nil, 0)
		end
		local evo_image = dms.string(dms["ship_mould"], self.ship_mould_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		local ship = getShipByTemplateId(self.ship_mould_id)
		--进化模板id
		local ship_evo = zstring.split(ship.evolution_status, "|")
		local evo_mould_id = smGetSkinEvoIdChange(ship)
		--新的形象编号
		local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

		draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), self.Panel_lihui, nil, nil, cc.p(0.5, 0))
		app.load("client.battle.fight.FightEnum")
		local armature_hero = sp.spine_sprite(self.Panel_lihui, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
		armature_hero:setScaleX(-1)
		self.armature_hero = armature_hero
		armature_hero.animationNameList = spineAnimations
		sp.initArmature(self.armature_hero, true)
		local function changeActionCallback( armatureBack )
			
		end
		local actionIndex = _enum_animation_l_frame_index.animation_skill_attacking
		local actionIndexs = {
			_enum_animation_l_frame_index.animation_standby,
		}
		actionIndex = actionIndexs[math.random(1, #actionIndexs)]

		armature_hero._self = self
		-- armature_hero:getAnimation():setFrameEventCallFunc(onFrameEventRole)
		armature_hero._invoke = changeActionCallback
		armature_hero:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		csb.animationChangeToAction(self.armature_hero, actionIndex, 0, false)
		armature_hero._nextAction = 0

		local soundid = dms.string(dms["ship_mould"], self.ship_mould_id, ship_mould.sound_index)
		playEffectExt(formatMusicFile("effect", soundid))
	else
		if cc.FileUtils:getInstance():isFileExist(string.format("images/face/big_head/big_head_%d.png", pic)) then
			self.Panel_lihui:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", pic))
		end
	end

		
	-- 未解锁条件和消耗panel
	self.Panel_lock_condition = ccui.Helper:seekWidgetByName(root, "Panel_you")

	-- 解锁后panel
	self.Panel_unlock = ccui.Helper:seekWidgetByName(root,"Panel_jiesuo1")

	-- 未解锁图片做显示隐藏
	self.Image_bg_3 = ccui.Helper:seekWidgetByName(root, "Image_bg_3")

	-- 解锁按钮
	self.Button_unLock = ccui.Helper:seekWidgetByName(root, "Button_jiesuo")

	-- 左边四个固定框做显示隐藏
	self.Panel_tx_guding_4 = ccui.Helper:seekWidgetByName(root, "Panel_tx_guding_4")

	-- 左边五个固定框做显示隐藏
	self.Panel_tx_guding_5 = ccui.Helper:seekWidgetByName(root, "Panel_tx_guding_5")

	-- 额外加成说明兑换框显示隐藏
	self.Panel_additional_infor = ccui.Helper:seekWidgetByName(root, "Panel_additional_infor")

	-- 基础属性说明兑换框显示隐藏
	self.Panel_arrt_infor = ccui.Helper:seekWidgetByName(root, "Panel_arrt_infor")

	-- 进阶条件显示隐藏
	self.Panel_soul_up = ccui.Helper:seekWidgetByName(root, "Panel_soul_up")

	-- 基础属性说明按钮显示隐藏
	self.Button_arrt_infor = ccui.Helper:seekWidgetByName(root, "Button_arrt_infor")

	-- 额外加成说明按钮显示隐藏
	self.Button_additional_infor = ccui.Helper:seekWidgetByName(root, "Button_additional_infor")

	-- 进阶条件做显示隐藏
	self.Panel_soul_up_infor = ccui.Helper:seekWidgetByName(root, "Panel_soul_up_infor")
	
	-- 升级消耗图
	self.Image_biaoti_3 = ccui.Helper:seekWidgetByName(root, "Image_biaoti_3")

	-- 木业图片
	self.Image_muye = ccui.Helper:seekWidgetByName(root, "Image_muye")

	-- 等级和阶级显示
	self.Text_infor = ccui.Helper:seekWidgetByName(root, "Text_infor")

	-- 已达到最顶级图片
	self.Image_soul_up_top = ccui.Helper:seekWidgetByName(root, "Image_soul_up_top")

	--用户信息
	local userinfo = UserTopInfoA:new()
	userinfo._rootWindows = self
	local info = fwin:open(userinfo,fwin._windows)
	self:onUpdateDraw()
	self:redTipPush()
end

function CombinationCardNotUnlockedWindow:onUpdateDraw()
	local root = self.roots[1]
	-- 判断是否解锁
	--TODO:
	for i,v in ipairs(_ED.combine_card_list_info.comb_mould_list) do
		if self.ship_mould_id == v.shipId and v.isUnlock then
			self.is_lock = false
		end
	end

	-- 未解锁条件和消耗panel
	self.Panel_lock_condition:setVisible(false)

	-- 解锁后panel
	self.Panel_unlock:setVisible(false)

	-- 未解锁图片做显示隐藏
	self.Image_bg_3:setVisible(false)

	-- 解锁按钮
	self.Button_unLock:setVisible(false)

	-- 左边四个固定框做显示隐藏
	self.Panel_tx_guding_4:setVisible(false)

	-- 左边五个固定框做显示隐藏
	self.Panel_tx_guding_5:setVisible(false)

	-- 额外加成说明兑换框显示隐藏
	self.Panel_additional_infor:setVisible(false)

	-- 基础属性说明兑换框显示隐藏
	self.Panel_arrt_infor:setVisible(false)

	-- 进阶条件显示隐藏
	self.Panel_soul_up:setVisible(false)

	-- 基础属性说明按钮显示隐藏
	self.Button_arrt_infor:setVisible(false)

	-- 额外加成说明按钮显示隐藏
	self.Button_additional_infor:setVisible(false)

	-- 升级升阶按钮
	self.Button_soul_up_1:setVisible(false)
	self.Button_soul_up_2:setVisible(false)
	self.Button_soul_up_3:setVisible(false)
	self:setOneClickBtnShowAndTouch(false)

	-- 进阶条件做显示隐藏
	self.Panel_soul_up_infor:setVisible(false)
	
	-- 升级消耗图
	self.Image_biaoti_3:setVisible(false)

	-- 木业图片
	self.Image_muye:setVisible(false)

	-- 等级和阶级显示
	self.Text_infor:setVisible(false)

	-- 已达到最顶级图片
	self.Image_soul_up_top:setVisible(false)

	if self.is_lock then	
		-- 未解锁
		self:onUpdateDrawLock()
	else
		-- 解锁
		self:onUpdateDrawUnLock()
	end

end

--未解锁界面
function CombinationCardNotUnlockedWindow:onUpdateDrawLock()
	local root = self.roots[1]
	self.Panel_lock_condition:setVisible(true)
	self:setHideCouseme(false)
	--解锁条件卡牌要求
	local unLockLimitNum = CombinationCardHandle.getPerMouldByShipId(self.ship_mould_id,ship_combination_card_mould.solt_num)
	local aimUnlockFlag = true
	for i=1,5 do
		local Panel_character = ccui.Helper:seekWidgetByName(root,"Panel_character_"..i)
		Panel_character:setVisible(false)
		--已拥有头像层
		local  Panel_detail = Panel_character:getChildByName("panel_xiangqing_1")
		local Panel_prop = Panel_detail:getChildByName("Panel_prop")
		Panel_prop:removeAllChildren(true)
		Panel_prop:setVisible(false)
		--锁住
		local Image_role_up_lv_add_2 = Panel_character:getChildByName("Image_role_up_lv_add_2")
		Image_role_up_lv_add_2:setVisible(false)

		--文字初始化
		-- 名字要做颜色区分
		local title_mingzi_1 = Panel_character:getChildByName("title_mingzi_1")
		title_mingzi_1:setString(tipStringInfo_combination_card_configure[1])
		title_mingzi_1:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[1]))

		-- 星级要做颜色区分
		local title_xingji_1 = Panel_character:getChildByName("title_xingji_1")
		title_xingji_1:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[1]))

		-- 战力要做颜色区分
		local title_zhandouli_1 = Panel_character:getChildByName("title_zhandouli_1")
		title_zhandouli_1:setString(tipStringInfo_combination_card_configure[2])
		title_zhandouli_1:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[1]))

		-- 已达成图片做显示隐藏
		local Image_weidacheng = Panel_character:getChildByName("Image_weidacheng")
		Image_weidacheng:setVisible(false)

		-- 未达成图片做显示隐藏
		local Image_yidacheng = Panel_character:getChildByName("Image_yidacheng")
		Image_yidacheng:setVisible(false)

		for j=1,7 do
			local starImg =  Panel_character:getChildByName("juexing_rukou_1"):getChildByName("Image_star_bg_"..j)
			local starBlink =  Panel_character:getChildByName("juexing_rukou_1"):getChildByName("Image_star_"..j)
			local starRed = Panel_character:getChildByName("juexing_rukou_1"):getChildByName("Image_red_star_"..j)
			starImg:setVisible(false)
			starBlink:setVisible(false)
			starRed:setVisible(false)
		end
		
		if i <= unLockLimitNum then
			Panel_character:setVisible(true)
			-- 条件数据
			local unLockDatas = CombinationCardHandle.unLockConditionByShipId(self.ship_mould_id, i+5)
			local unLockShipId = unLockDatas.ship_id
			local shipName = CombinationCardHandle.getHeroNameByShipId(unLockShipId)
			local eightLvs = zstring.split(unLockDatas.eight_level,",")
			local shipStepLv = eightLvs[1]
			local shipStepSonLv = eightLvs[2]
			local aimCombat = unLockDatas.fight_effect

			-- 解锁条件头像
			local shipData = nil
			if getStrongestShipByTemplateId(unLockShipId) then
				shipData = _ED.user_ship[""..tonumber(getStrongestShipByTemplateId(unLockShipId).ship_id)]
			end

			if shipData then	-- 拥有卡牌
				Panel_prop:setVisible(true)
				local cell = HeroIconListCell:createCell()
				cell:init(shipData, nil, false,nil,nil,nil,1)  
				Panel_prop:addChild(cell)
			else
				Panel_prop:setVisible(true)	
				local hero_head = CombinationCardClipHead.createGrayHeroIcon(unLockShipId)
				hero_head:setAnchorPoint(cc.p(0.5,0.5))
				hero_head:setPosition(cc.p(Panel_prop:getContentSize().width/2, Panel_prop:getContentSize().height/2))
				-- -- local hero_mould_id = dms.string(dms["prop_mould"], unLockShipId, prop_mould.use_of_ship)
				-- -- local hero_head = ShipHeadNewCell:createCell()
				-- -- hero_head:init(hero_mould_id,hero_head.enum_type._SHOW_HERO_FROM_WARCRAFT, false)

				Panel_prop:addChild(hero_head)
			end
			-- 判断条件是否满足
			local curStar,lv,sonLv,curFight = CombinationCardHandle.getCurDataByMouldId(tonumber(unLockShipId))
			--星级
			
			local starNumLimit = tonumber(unLockDatas.star_level)
			for j=1,7 do
				local starBlink =  Panel_character:getChildByName("juexing_rukou_1"):getChildByName("Image_star_"..j)
				starBlink:setVisible(false)
				local starImg =  Panel_character:getChildByName("juexing_rukou_1"):getChildByName("Image_star_bg_"..j)
				starImg:setVisible(false)
				if j <= starNumLimit then
					starImg:setVisible(true)
				end
				local starNumVis = curStar
				if starNumLimit < curStar then
					starNumVis = starNumLimit
				end

				if j <= starNumVis then
					starBlink:setVisible(true)
				else
					starBlink:setVisible(false)
				end
				
			end
			
			-- 名字标题
			local nameSuf = ""
			if 0 < tonumber(shipStepLv) and 0 < tonumber(shipStepSonLv) then
				nameSuf = string.format( tipStringInfo_combination_card_configure[4], shipStepLv, shipStepSonLv)
			end
			title_mingzi_1:setString(shipName..nameSuf)

			if shipData and tonumber(lv) >= tonumber(shipStepLv) 
				and tonumber(sonLv) >= tonumber(shipStepSonLv) 
					and tonumber(curStar) >= tonumber(starNumLimit)
						and tonumber(curFight) >= tonumber(aimCombat) 
							then
					-- 达成
					Image_yidacheng:setVisible(true)
			else
				-- 未达成
				Image_weidacheng:setVisible(true)
				aimUnlockFlag = false
			end
			if tonumber(lv) >= tonumber(shipStepLv) and tonumber(sonLv) >= tonumber(shipStepSonLv) then
				title_mingzi_1:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[2]))
			else
				title_mingzi_1:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[3]))
			end

			if tonumber(curFight) >= tonumber(aimCombat) then
				title_zhandouli_1:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[2]))
			else
				title_zhandouli_1:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[3]))
			end
			-- 需求战力
			title_zhandouli_1:setString(string.format( tipStringInfo_combination_card_configure[3], curFight, aimCombat))
			if shipData then
				
			else
				title_mingzi_1:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[3]))
				title_zhandouli_1:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[3]))
				Image_weidacheng:setVisible(true)
			end
		else
			Panel_character:setVisible(false)
			-- 锁住
			Image_role_up_lv_add_2:setVisible(true)
		end
	end

	-- 解锁消耗
	local propConsumeDatas = CombinationCardHandle.unLockConsumeByShipId(self.ship_mould_id)
	local propTypeNum = #propConsumeDatas
	-- 道具是否够
	local aimConsume = true
	for i=1,3 do
		local Panel_unLock_consume = ccui.Helper:seekWidgetByName(root, "Panel_jinjiexiaohao_"..i)
		Panel_unLock_consume:setVisible(false)
		if i <= propTypeNum then
			local propDatas = zstring.split(propConsumeDatas[i],",")
			local propType = tonumber(propDatas[1])
			local propId = tonumber(propDatas[2])
			local aimNum = tonumber(propDatas[3])
			Panel_unLock_consume:setVisible(true)
			local propPanel = Panel_unLock_consume:getChildByName("Panel_daoju_1")
			propPanel:removeAllChildren(true)
			local haveNum = 0
			
			if fundPropWidthId(propId) then
				haveNum = fundPropWidthId(propId).prop_number
			end
			local cell = ResourcesIconCell:createCell()
			cell:init(propType,0,propId,nil,nil,true,true)
			cell:setAnchorPoint(cc.p(0.5,0.5))     
			cell:setPosition(cc.p(propPanel:getContentSize().width/2,propPanel:getContentSize().height/2))
            propPanel:addChild(cell)

			local Text_num = Panel_unLock_consume:getChildByName("Text_shuzhi_1")
			Text_num:setString(haveNum.."/"..aimNum)
			if tonumber(haveNum) >= aimNum then
				Text_num:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[4]))
			else
				aimConsume = false
				Text_num:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[5]))
			end
			
		end
	end

	--解锁按钮
	local canUnLockflag = aimUnlockFlag and aimConsume
	self.Button_unLock:setVisible(true)
	if canUnLockflag then
		self.Button_unLock:setEnabled(true)
		self.Button_unLock:setBright(true)

		fwin:addTouchEventListener(self.Button_unLock, nil,
		{
			terminal_name = "combination_card_click_unlock_card",
			terminal_state = 0,
			ship_id = self.ship_mould_id,
			isPressedActionEnabled = true,
		}, nil, 0)
	else
		self.Button_unLock:setEnabled(false)
		self.Button_unLock:setBright(false)
	end

end

--解锁界面
function CombinationCardNotUnlockedWindow:onUpdateDrawUnLock()
	local root = self.roots[1]
	self.Panel_unlock:setVisible(true)
	self.Image_bg_3:setVisible(true)
	self.can_aim_break = true
	self.can_aim_break_prop = true
	self.can_aim_up = true
	self.solt_infos = {}
	-- 基本槽位
	local slotData = CombinationCardHandle.getSoltDatas(self.ship_mould_id)
	local slotNum = #slotData
	if 4 == slotNum then	-- 4个固定槽
		self.Panel_tx_guding_4:setVisible(true)
		for i = 1,4 do 
			local Image_kuang = self.Panel_tx_guding_4:getChildByName("Image_kuang_"..i)
			local Panel_kuang = Image_kuang:getChildByName("Panel_kuang_1")
			Panel_kuang:removeAllChildren()
			
			local Image_select = Image_kuang:getChildByName("Image_xuanz_1")
			Image_select:setVisible(flase)
			local Text_xuanz = Image_kuang:getChildByName("Text_xuanz_"..i)
			local slotInfoPer = CombinationCardHandle.getOneSoltInfoById(i)
			self.solt_infos[i] = {}
			self.solt_infos[i].ship_id_can =  slotInfoPer.defaultShipId
			Text_xuanz:setString(string.format( tipStringInfo_combination_card_configure[11], slotInfoPer.slotLevel))
			Text_xuanz:setColor(CombinationCardHandle.getQualityColorByLevel(slotInfoPer.slotLevel))
			if 0 == tonumber(slotInfoPer.shipId)  then
				-- 未上阵
				self.solt_infos[i].ship_id_have =  -1
			else
				self.solt_infos[i].ship_id_have =  tonumber(slotInfoPer.shipId)
				CombinationCardClipHead.createCircleSprite(Panel_kuang,CombinationCardClipHead.createHeroIcon(_ED.user_ship[""..slotInfoPer.shipId].ship_template_id))
			end
			if self.last_solt_id and self.last_solt_id == i then
				Image_select:setVisible(true)
			end

			self:addTouchForSlot(Panel_kuang,i)
		end
	else
		self.Panel_tx_guding_5:setVisible(true)
		local mIndex = 1
		for i=1,5 do
			local Image_kuang = self.Panel_tx_guding_5:getChildByName("Image_kuang_"..i)		
			local Panel_kuang = Image_kuang:getChildByName("Panel_kuang_1")
			local Image_select = Image_kuang:getChildByName("Image_xuanz_1")
			local Text_xuanz = Image_kuang:getChildByName("Text_xuanz_"..i)
			Panel_kuang:setVisible(false)
			Panel_kuang:removeAllChildren()
			Image_kuang:setVisible(false)
			Image_select:setVisible(false)

			if 3 == slotNum then   	--3个固定槽
				if 2 <= i and 4 >= i then
					Panel_kuang:setVisible(true)
					Image_kuang:setVisible(true)
					local slotInfoPer = CombinationCardHandle.getOneSoltInfoById(mIndex)
					self.solt_infos[mIndex] = {}
					self.solt_infos[mIndex].ship_id_can =  slotInfoPer.defaultShipId
					Text_xuanz:setString(string.format( tipStringInfo_combination_card_configure[11], slotInfoPer.slotLevel))
					Text_xuanz:setColor(CombinationCardHandle.getQualityColorByLevel(slotInfoPer.slotLevel))
					if 0 == tonumber(slotInfoPer.shipId)  then
						-- 未上阵
						self.solt_infos[mIndex].ship_id_have =  -1
					else
						self.solt_infos[mIndex].ship_id_have =  tonumber(slotInfoPer.shipId)
						CombinationCardClipHead.createCircleSprite(Panel_kuang,CombinationCardClipHead.createHeroIcon(_ED.user_ship[""..slotInfoPer.shipId].ship_template_id))
					end
					if self.last_solt_id and self.last_solt_id == mIndex then
						Image_select:setVisible(true)
					end
					self:addTouchForSlot(Panel_kuang,mIndex)
					mIndex = mIndex + 1
				end
			else	-- 5个固定槽	
				Panel_kuang:setVisible(true)
				Image_kuang:setVisible(true)
				local slotInfoPer = CombinationCardHandle.getOneSoltInfoById(i)
				self.solt_infos[i] = {}
				self.solt_infos[i].ship_id_can =  slotInfoPer.defaultShipId
				Text_xuanz:setString(string.format( tipStringInfo_combination_card_configure[11], slotInfoPer.slotLevel))
				Text_xuanz:setColor(CombinationCardHandle.getQualityColorByLevel(slotInfoPer.slotLevel))
				if 0 == tonumber(slotInfoPer.shipId)  then
					-- 未上阵
					self.solt_infos[i].ship_id_have =  -1
				else
					self.solt_infos[i].ship_id_have =  tonumber(slotInfoPer.shipId)
					CombinationCardClipHead.createCircleSprite(Panel_kuang,CombinationCardClipHead.createHeroIcon(_ED.user_ship[""..slotInfoPer.shipId].ship_template_id))
				end
				if self.last_solt_id and self.last_solt_id == i then
					Image_select:setVisible(true)
				end
				self:addTouchForSlot(Panel_kuang,i)
			end
		end
		
	end

	-- 灵活槽位
	local slotChangeNum = 7 - slotNum
	local slotIndex = slotNum
	for i=1,4 do
		local Panel_change_slot = ccui.Helper:seekWidgetByName(root, "Panel_tx_kuang_"..i)
		local Image_change_slot = ccui.Helper:seekWidgetByName(root, "Image_tx_kuang_"..i)
		local Image_lock_slot = ccui.Helper:seekWidgetByName(root, "Image_wjs_"..i)
		local Text_xuanz = ccui.Helper:seekWidgetByName(root, "Text_tx_"..i)
		Panel_change_slot:removeAllChildren()
		Panel_change_slot:setVisible(false)
		Image_change_slot:setVisible(false)
		Text_xuanz:setVisible(false)
		if i <= slotChangeNum then
			Panel_change_slot:setVisible(true)
			Image_change_slot:setVisible(true)
			Image_lock_slot:setVisible(false)
			slotIndex = slotIndex + 1
			local slotInfoPer = CombinationCardHandle.getOneSoltInfoById(slotIndex)
			self.solt_infos[#self.solt_infos+1] = {}
			self.solt_infos[#self.solt_infos].ship_id_can =  slotInfoPer.defaultShipId
			if 0 == tonumber(slotInfoPer.shipId)  then
				-- 未上阵
				self.solt_infos[slotIndex].ship_id_have =  -1
				Text_xuanz:setVisible(true)
				Text_xuanz:setString(string.format( tipStringInfo_combination_card_configure[11], slotInfoPer.slotLevel))
				Text_xuanz:setColor(CombinationCardHandle.getQualityColorByLevel(slotInfoPer.slotLevel))
			elseif -1 == tonumber(slotInfoPer.shipId) then
				-- 未解锁槽位
				Text_xuanz:setVisible(false)
				Image_lock_slot:setVisible(true)
				self.solt_infos[slotIndex].ship_id_have =  -2
				local unlockFlag = CombinationCardHandle.getSoltCanUnlockBySoltId(self.ship_mould_id,slotIndex)
				local Image_wjs = ccui.Helper:seekWidgetByName(root, "Image_wjs_"..i)
				if unlockFlag then
					Image_wjs:loadTexture("images/ui/text/TF_res/combination_card/text_kejiesuo_1.png")
				else
					Image_wjs:loadTexture("images/ui/text/TF_res/combination_card/text_weijiesuo_1.png")
				end
			else
				Text_xuanz:setVisible(true)
				Text_xuanz:setString(string.format( tipStringInfo_combination_card_configure[11], slotInfoPer.slotLevel))
				Text_xuanz:setColor(CombinationCardHandle.getQualityColorByLevel(slotInfoPer.slotLevel))
				self.solt_infos[slotIndex].ship_id_have =  tonumber(slotInfoPer.shipId)
				local hero_head = ShipHeadNewCell:createCell()
				hero_head:init(_ED.user_ship[""..slotInfoPer.shipId],hero_head.enum_type._FORMATION_CHANGE_SHIP_PAGE_VIEW,nil,{1, 1})
				Panel_change_slot:addChild(hero_head)
			end
			
			self:addTouchForSlot(Panel_change_slot,slotIndex)
			if slotIndex == self.last_solt_id then
				Image_change_slot:loadTexture("images/ui/text/TF_res/combination_card/combination_card_toux_6.png")
			else
				Image_change_slot:loadTexture("images/ui/text/TF_res/combination_card/combination_card_toux_2.png")
			end
		end
	end


	-- 属性加成
	self:addAttribute()
	if -1 ~= self.last_solt_id and -1 == tonumber(CombinationCardHandle.getOneSoltInfoById(self.last_solt_id).shipId) then
		-- 未解锁
		self:soltUnlockCondition()
	else
		--升级还是进阶
		self:soltUpLevelAndBreak()
	end
	
end


-- 属性说明控制
function CombinationCardNotUnlockedWindow:attExpalinControl()
	local root = self.roots[1]
	local Panel_Base_bonus = ccui.Helper:seekWidgetByName(root,"Panel_Base_bonus")
	Panel_Base_bonus:setVisible(true)
	local Text_dev_ing_n = Panel_Base_bonus:getChildByName("Text_dev_ing_n")
	local Text_qut_n = Panel_Base_bonus:getChildByName("Text_qut_n")
	local Text_other_n = Panel_Base_bonus:getChildByName("Text_other_n")
	--额外加成
	local Panel_Extra_bonus = ccui.Helper:seekWidgetByName(root,"Panel_Extra_bonus")
	Panel_Extra_bonus:setVisible(true)
	Panel_Extra_bonus:setPosition(cc.p(0,0))
	local Text_additional_evolution = Panel_Extra_bonus:getChildByName("Text_additional_evolution")
    

    local Text_additional_qua = Panel_Extra_bonus:getChildByName("Text_additional_qua")
    

	local Text_additional_other = Panel_Extra_bonus:getChildByName("Text_additional_other")
	
	-- 背景图
	local Image_bg = ccui.Helper:seekWidgetByName(root,"Image_62")

	local extAdd = zstring.split(CombinationCardHandle.getAddProperty(self.last_solt_id)[3],",")
	if extAdd then
		Text_additional_evolution:setString(math.floor(tonumber(extAdd[1])))
		Text_additional_qua:setString(math.floor(tonumber(extAdd[2])))
		Text_additional_other:setString(math.floor(tonumber(extAdd[3])))
	else
		Text_additional_evolution:setString("00")
		Text_additional_qua:setString("00")
		Text_additional_other:setString("00")
	end
	
	if -1 == self.last_solt_id then
		Panel_Base_bonus:setVisible(false)
		Panel_Extra_bonus:setPosition(cc.p(-Image_bg:getContentSize().width/2,Panel_Extra_bonus:getPositionY()))
		Text_dev_ing_n:setString("0")
		Text_qut_n:setString("0")
		Text_other_n:setString("0")
	else
		-- 实例Id
		local shipId = CombinationCardHandle.getOneSoltInfoById(self.last_solt_id).shipId
		if 0 == tonumber(shipId) or -1 == tonumber(shipId) then
			Text_dev_ing_n:setString("0")
			Text_qut_n:setString("0")
			Text_other_n:setString("0")
		else
			local shipMouldId = _ED.user_ship[""..shipId].ship_template_id

			--八门难度
			local megalv = CombinationCardHandle.getMegaProperty(shipId)
	   
			Text_dev_ing_n:setString(megalv)
			
			--资质
			local ability = dms.int(dms["ship_mould"], tonumber(shipMouldId), ship_mould.ability)
			
			Text_qut_n:setString(ability)
	
			--进阶数
			local m_Order = tonumber((_ED.user_ship[""..shipId].Order)) 
			
			if m_Order == 0 then
				Text_other_n:setString(0)
			else
				Text_other_n:setString(tipStringInfo_maga_uplv[m_Order])
			end
		end
	end
	
	local function onOpenTouchEvent(sender, eventType)
        if eventType == ccui.TouchEventType.began then
			self.Panel_arrt_infor:setVisible(true)
        elseif evenType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
            self.Panel_arrt_infor:setVisible(false)
        end
    end

    local function onOpenTouchEventtwo(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            self.Panel_additional_infor:setVisible(true)
        elseif evenType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			self.Panel_additional_infor:setVisible(false)
        end
    end

    self.Button_arrt_infor:addTouchEventListener(onOpenTouchEvent)
    
	self.Button_additional_infor:addTouchEventListener(onOpenTouchEventtwo)
	
end

-- 升阶条件
function CombinationCardNotUnlockedWindow:breakConditionDraw()
	local root = self.roots[1]
	-- 目标条件是否达成
	local Image_bg = ccui.Helper:seekWidgetByName(root, "Image_biaoti_2")
	Image_bg:setVisible(true)
	Image_bg:loadTexture("images/ui/text/TF_res/combination_card/combination_card_title_2.png")
	local canAimFlag = true
	if -1 ~= self.last_solt_id then
		local slotCalss = CombinationCardHandle.getOneSoltInfoById(self.last_solt_id).slotClass
		local breakCondition = CombinationCardHandle.getBreakCondition(slotCalss)
		local starLv = breakCondition.star_level
		local eightLvs = zstring.split(breakCondition.eight_level,",")
		local shipStepLv = eightLvs[1]
		local shipStepSonLv = eightLvs[2]
		local aimCombat = breakCondition.fight_effect
		local shipInfos = _ED.user_ship[""..CombinationCardHandle.getOneSoltInfoById(self.last_solt_id).shipId]
		local curStar,lv,sonLv,curFight = 0,0,0,0
		if shipInfos then
			local slotCardId = shipInfos.ship_template_id
			curStar,lv,sonLv,curFight = CombinationCardHandle.getCurDataByMouldId(tonumber(slotCardId))
		end
		
		local filePathYes = "images/ui/text/TF_res/combination_card/icon_gou.png"
		local filePathNo = "images/ui/text/TF_res/combination_card/icon_cha.png"
		for i=3,6 do
			local Text_jinjietiaojian = ccui.Helper:seekWidgetByName(root, "Text_jinjietiaojian_"..i)
			Text_jinjietiaojian:setVisible(false)
			local Panel_duicuo = ccui.Helper:seekWidgetByName(root, "Panel_duicuo_"..i)
			Panel_duicuo:setVisible(false)
		end
		-- 进阶条件1
		local Text_jinjietiaojian_1 = ccui.Helper:seekWidgetByName(root, "Text_jinjietiaojian_1")
		Text_jinjietiaojian_1:setString(string.format(tipStringInfo_combination_card_configure[5],curStar,starLv))
		local Panel_duicuo_1 = ccui.Helper:seekWidgetByName(root, "Panel_duicuo_1")
		if tonumber(curStar) >= tonumber(starLv) then
			Panel_duicuo_1:setBackGroundImage(filePathYes)
		else
			Panel_duicuo_1:setBackGroundImage(filePathNo)
			canAimFlag = false
		end

		-- 进阶条件2
		local Text_jinjietiaojian_2 = ccui.Helper:seekWidgetByName(root, "Text_jinjietiaojian_2")

		-- 进阶条件3
		local Text_jinjietiaojian_3 = ccui.Helper:seekWidgetByName(root, "Text_jinjietiaojian_3")

		local Panel_duicuo_2 = ccui.Helper:seekWidgetByName(root, "Panel_duicuo_2")
		local Panel_duicuo_3 = ccui.Helper:seekWidgetByName(root, "Panel_duicuo_3")
		if 0 < tonumber(shipStepLv)  then
			Text_jinjietiaojian_3:setVisible(true)
			Panel_duicuo_3:setVisible(true)
			Text_jinjietiaojian_2:setString(string.format(tipStringInfo_combination_card_configure[6],lv,shipStepLv,sonLv,shipStepSonLv))
			Text_jinjietiaojian_3:setString(string.format(tipStringInfo_combination_card_configure[7],curFight,aimCombat))
			if tonumber(lv) >= tounmber(shipStepLv) and tonumber(sonLv) >= tonumber(shipStepSonLv) then
				Panel_duicuo_2:setBackGroundImage(filePathYes)
			else
				Panel_duicuo_2:setBackGroundImage(filePathNo)
				canAimFlag = false
			end
			if tonumber(curFight) >= tonumber(aimCombat) then
				Panel_duicuo_3:setBackGroundImage(filePathYes)
			else
				Panel_duicuo_3:setBackGroundImage(filePathNo)
				canAimFlag = false
			end
			
		else
			Text_jinjietiaojian_2:setString(string.format(tipStringInfo_combination_card_configure[7],curFight,aimCombat))
			Text_jinjietiaojian_3:setVisible(false)
			Panel_duicuo_3:setVisible(false)
			if tonumber(curFight) >= tonumber(aimCombat) then
				Panel_duicuo_2:setBackGroundImage(filePathYes)
			else
				Panel_duicuo_2:setBackGroundImage(filePathNo)
				canAimFlag = false
			end
		end
	end
	self.can_aim_break = canAimFlag
end

-- 升级升阶消耗道具
function CombinationCardNotUnlockedWindow:upLevelAndBreakConsume(consumeDatas,isUplevel)
	local root = self.roots[1]
	for i=1,3 do
		local Panel_unLock_consume = ccui.Helper:seekWidgetByName(root, string.format( "Panel_jinjiexiaohao_%d_0", i))
		
		Panel_unLock_consume:setVisible(false)
	end

	local index  = 1
	for i,v in pairs(consumeDatas) do
		local consumeData = zstring.split(v,",")
		local propType = tonumber(consumeData[1])
		local propId = tonumber(consumeData[2])
		local Panel_unLock_consume = ccui.Helper:seekWidgetByName(root, string.format( "Panel_jinjiexiaohao_%d_0", index))
		Panel_unLock_consume:setVisible(true)
		local propPanel = Panel_unLock_consume:getChildByName("Panel_daoju_1")
		propPanel:removeAllChildren(true)
		local haveNum = 0
		local aimNum = tonumber(consumeData[3])
		if propType == 1 then
			haveNum = _ED.user_info.user_silver
		elseif propType == 2 then
			haveNum = _ED.user_info.user_gold
		else
			if fundPropWidthId(propId) then
				haveNum = fundPropWidthId(propId).prop_number
			end
		end
		
		local cell = ResourcesIconCell:createCell()
		cell:init(propType,0,propId,nil,nil,true,true,0,nil)      
		propPanel:addChild(cell)

		local Text_num = Panel_unLock_consume:getChildByName("Text_shuzhi_1")

		local haveStr = ""
		if propType == 1 then
			Text_num:setString(aimNum)
			-- if zstring.tonumber(silver) > 1000000000 then
			-- 	Text_num:setString(string.format("%.02f",silver/ 1000000000) .. string_equiprety_name[42].."/"..aimNum)
			-- elseif zstring.tonumber(silver)> 1000000 then
			-- 	Text_num:setString(string.format("%.02f",silver / 1000000) .. string_equiprety_name[41].."/"..aimNum)
			-- elseif zstring.tonumber(silver)> 1000 then
			-- 	Text_num:setString(string.format("%.02f",silver / 1000) .. string_equiprety_name[40].."/"..aimNum)
			-- end
		else
			Text_num:setString(haveNum.."/"..aimNum)
		end
		
		if tonumber(haveNum) >= aimNum then
			Text_num:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[4]))
		else
			Text_num:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[5]))
			if isUplevel then
				self.can_aim_up = false
			else
				self.can_aim_break_prop = false
			end
		end
		index = index + 1
	end
end

-- 隐藏升级消耗
function CombinationCardNotUnlockedWindow:setHideCouseme(flag)
	local root = self.roots[1]
	self.Panel_soul_up_infor:setVisible(flag)
	self.Image_biaoti_3:setVisible(flag)
	self.Text_infor:setVisible(flag)
	for i=1,3 do
		local Panel_unLock_consume = ccui.Helper:seekWidgetByName(root, string.format( "Panel_jinjiexiaohao_%d_0", i))
		Panel_unLock_consume:setVisible(flag)
	end
end

-- 解锁槽位
function CombinationCardNotUnlockedWindow:soltUnlockCondition()
	local root = self.roots[1]
	self.Panel_additional_infor:setVisible(false)
	self.Panel_arrt_infor:setVisible(false)
	self:setHideCouseme(true)
	self.Text_infor:setVisible(false)
	self.Button_soul_up_3:setVisible(true)
	local canAimFlag = true
	for i=1,6 do
		local Text_jinjietiaojian = ccui.Helper:seekWidgetByName(root, "Text_jinjietiaojian_"..i)
		local Panel_duicuo = ccui.Helper:seekWidgetByName(root, "Panel_duicuo_"..i)
		Text_jinjietiaojian:setVisible(false)
		Panel_duicuo:setVisible(false)
	end
	-- 解锁消耗图片
	local Image_bg = ccui.Helper:seekWidgetByName(root, "Image_biaoti_3")
	Image_bg:setVisible(true)
	Image_bg:loadTexture("images/ui/text/TF_res/combination_card/combination_card_title_5.png")
	-- 解锁条件
	local conditionData,condition = CombinationCardHandle.getSoltUnlockCondition(self.ship_mould_id,self.last_solt_id)

	if condition then
		self.Panel_soul_up:setVisible(true)
		local Image_bg = ccui.Helper:seekWidgetByName(root, "Image_biaoti_2")
		Image_bg:setVisible(true)
		Image_bg:loadTexture("images/ui/text/TF_res/combination_card/combination_card_title_4.png")

		local filePathYes = "images/ui/text/TF_res/combination_card/icon_gou.png"
		local filePathNo = "images/ui/text/TF_res/combination_card/icon_cha.png"

		for i=1,#condition do
			local conData = condition[i]
			local type = conData.type
			local level = conData.level
			local Text_jinjietiaojian = ccui.Helper:seekWidgetByName(root, "Text_jinjietiaojian_"..i)
			Text_jinjietiaojian:setVisible(true)
			local Panel_duicuo = ccui.Helper:seekWidgetByName(root, "Panel_duicuo_"..i)
			Panel_duicuo:setVisible(true)
			if 0 == type then
				local totalLevel = CombinationCardHandle.getCurLevelByMouldId(self.ship_mould_id)
				Text_jinjietiaojian:setString(string.format(tipStringInfo_combination_card_configure[12],level))
				if totalLevel >= level then
					Panel_duicuo:setBackGroundImage(filePathYes)
				else
					Panel_duicuo:setBackGroundImage(filePathNo)
					canAimFlag = false
				end
			else
				local curLevel = CombinationCardHandle.getOneSoltInfoById(type).slotLevel
				Text_jinjietiaojian:setString(string.format(tipStringInfo_combination_card_configure[13],type,level))
				if curLevel >= level then
					Panel_duicuo:setBackGroundImage(filePathYes)
				else
					Panel_duicuo:setBackGroundImage(filePathNo)
					canAimFlag = false
				end
			end
		end
	end
	
	-- 道具

	for i=1,3 do
		local Panel_unLock_consume = ccui.Helper:seekWidgetByName(root, string.format( "Panel_jinjiexiaohao_%d_0", i))
		Panel_unLock_consume:setVisible(false)
	end

	local consumeData = zstring.split(conditionData,",")
	local propType = 6
	local propId = tonumber(consumeData[1])
	local Panel_unLock_consume = ccui.Helper:seekWidgetByName(root, "Panel_jinjiexiaohao_1_0")
	Panel_unLock_consume:setVisible(true)
	local propPanel = Panel_unLock_consume:getChildByName("Panel_daoju_1")
	propPanel:removeAllChildren(true)
	local haveNum = 0
	local aimNum = tonumber(consumeData[2])
	if propType == 1 then
		haveNum = _ED.user_info.user_silver
	elseif propType == 2 then
		haveNum = _ED.user_info.user_gold
	else
		if fundPropWidthId(propId) then
			haveNum = fundPropWidthId(propId).prop_number
		end
	end
	
	local cell = ResourcesIconCell:createCell()
	cell:init(propType,0,propId,nil,nil,true,true,0,nil)      
	propPanel:addChild(cell)

	local Text_num = Panel_unLock_consume:getChildByName("Text_shuzhi_1")

	local haveStr = ""
	if propType == 1 then
		Text_num:setString(aimNum)
	else
		Text_num:setString(haveNum.."/"..aimNum)
	end
	
	if tonumber(haveNum) >= aimNum then
		Text_num:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[4]))
	else
		Text_num:setColor(CombinationCardHandle.getStringColor(tipStringInfo_combination_card_configure_color[5]))
		canAimFlag = false
	end
	self.can_solt_unlock = canAimFlag
end

-- 处理升级升阶
function CombinationCardNotUnlockedWindow:soltUpLevelAndBreak()
	
	if -1 == self.last_solt_id then
		-- 总加成不显示消耗和解锁
		self.Button_additional_infor:setVisible(true)
		self.Button_arrt_infor:setVisible(true)
		self.Panel_soul_up:setVisible(false)
		self.Image_muye:setVisible(true)
		--升级按钮
		self.Button_soul_up_1:setVisible(true)
		self.Button_soul_up_2:setVisible(false)
		self:setOneClickBtnShowAndTouch(true)
		--说明控制
		self:attExpalinControl()
		self:setHideCouseme(false)
		return
	end
	-- 槽位未解锁时显示
	if -1 == CombinationCardHandle.getOneSoltInfoById(self.last_solt_id) then
		return
	end
	
	local root = self.roots[1]
	local soltInfoPer = CombinationCardHandle.getOneSoltInfoById(self.last_solt_id)
	local consumeDatas,isUpLevel = CombinationCardHandle.getSoltConsume(soltInfoPer.groupId,soltInfoPer.slotLevel,soltInfoPer.slotClass)
	-- 显示等级和阶级
	local colorData,sufText = CombinationCardHandle.getQualityColorByBreak(soltInfoPer.slotClass)
	self.Text_infor:setString(sufText.."  "..string.format( tipStringInfo_combination_card_configure[11], soltInfoPer.slotLevel))
	self.Text_infor:setColor(colorData)
	if consumeDatas then
		self:setHideCouseme(true)
		self.Image_soul_up_top:setVisible(false)
		if isUpLevel then		--升级显示
			self.Button_additional_infor:setVisible(true)
			self.Button_arrt_infor:setVisible(true)
			self.Panel_soul_up:setVisible(false)
			--升级按钮
			self.Button_soul_up_1:setVisible(true)
			-- 一键升级按钮显示和点击
			local oneClickBtnShow = true
			local oneClickBtnTouch = false
			if 0 < self.solt_infos[self.last_solt_id].ship_id_have then
				oneClickBtnTouch = true
				self.Button_soul_up_1:setEnabled(true)
				self.Button_soul_up_1:setBright(true)
			else
				oneClickBtnTouch = false
				self.Button_soul_up_1:setEnabled(false)
				self.Button_soul_up_1:setBright(false)
			end
			self.Button_soul_up_2:setVisible(false)
			-- 一键升级按钮
			self:setOneClickBtnShowAndTouch(oneClickBtnShow, oneClickBtnTouch)
			--说明控制
			self:attExpalinControl()
			local Image_bg = ccui.Helper:seekWidgetByName(root, "Image_biaoti_3")
			Image_bg:setVisible(true)
			Image_bg:loadTexture("images/ui/text/TF_res/combination_card/combination_card_title_6.png")
		else	--升阶条件
			self.Panel_soul_up:setVisible(true)
			self.Button_additional_infor:setVisible(false)
			self.Button_arrt_infor:setVisible(false)
			--升阶按钮
			self.Button_soul_up_2:setVisible(true)
			if 0 < self.solt_infos[self.last_solt_id].ship_id_have then
				self.Button_soul_up_2:setEnabled(true)
				self.Button_soul_up_2:setBright(true)
			else
				self.Button_soul_up_2:setEnabled(false)
				self.Button_soul_up_2:setBright(false)
			end
			self.Button_soul_up_1:setVisible(false)
			self:setOneClickBtnShowAndTouch(false)
			local Image_bg = ccui.Helper:seekWidgetByName(root, "Image_biaoti_3")
			Image_bg:setVisible(true)
			Image_bg:loadTexture("images/ui/text/TF_res/combination_card/combination_card_title_3.png")
			--升阶条件
			self:breakConditionDraw()
		end
		self.buttonType = 1
		-- 消耗
		self:upLevelAndBreakConsume(consumeDatas,isUpLevel)
	else	-- 满级
		self:setHideCouseme(false)
		self.Image_soul_up_top:setVisible(true)
	end
end

-- 属性加成面板
function CombinationCardNotUnlockedWindow:addAttribute()
	-- 所有加成属性
	local attrDatas = CombinationCardHandle.getAddProperty(self.last_solt_id)
	

	local root = self.roots[1]
	-- 最终加成(攻防血))
	local finalAdd = zstring.split(attrDatas[1],",")
	for i=1,3 do
		local Text_soul_add = ccui.Helper:seekWidgetByName(root, "Text_soul_add_"..i)
		local attNum = "0000"
		if finalAdd[i] then
			attNum = math.floor(tonumber(finalAdd[i]))
		end
		Text_soul_add:setString(attNum)
	end
	
	-- 基础加成(攻防血))
	local baseAdd = zstring.split(attrDatas[2],",")
	for i=1,3 do
		local Text_soul_attr = ccui.Helper:seekWidgetByName(root, "Text_soul_attr_0_"..i)
		local attrNum = "0000"
		if baseAdd[i] then
			attrNum = math.floor(tonumber(baseAdd[i]))
		end
		Text_soul_attr:setString(""..attrNum)
	end

	-- 额外加成(攻防血))
	local extAdd = zstring.split(attrDatas[3],",")
	for i=1,3 do
		local Text_soul_additional = ccui.Helper:seekWidgetByName(root, "Text_soul_additional_"..i)
		local attrNum = "0000"
		if extAdd[i] then
			attrNum = math.floor(tonumber(extAdd[i]))
		end
		Text_soul_additional:setString(attrNum)
	end
	
end

-- 未固定槽位添加点击事件
function CombinationCardNotUnlockedWindow:addTouchForSlot(sender,type)
	fwin:addTouchEventListener(sender, nil,{
		terminal_name = "combination_card_slot_click",
		m_type = type,
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
end

function CombinationCardNotUnlockedWindow:openTipDraw(str)
	function showConfirmTip(self,n)

	end
	app.load("client.utils.ConfirmTip")
	local tip = ConfirmTip:new()
	tip:init(self, showConfirmTip, str)
	fwin:open(tip,fwin._ui)
end

-- 红点推送
function CombinationCardNotUnlockedWindow:redTipPush()
	local root = self.roots[1]
	-- 重置
	for i = 1, 4 do
		local Image_kuang = self.Panel_tx_guding_4:getChildByName("Image_kuang_"..i)
		CombinationCardHandle.pushTipControlSmall(Image_kuang,false,self.ship_mould_id)
	end
	for i = 1, 5 do
		local Image_kuang = self.Panel_tx_guding_5:getChildByName("Image_kuang_"..i)
		CombinationCardHandle.pushTipControlSmall(Image_kuang,false,self.ship_mould_id)
	end
	for i=1,4 do
		local Image_tx_kuang = ccui.Helper:seekWidgetByName(root, "Image_tx_kuang_"..i)
		CombinationCardHandle.pushTipControlSmall(Image_tx_kuang,false,self.ship_mould_id)
	end
	
	-- 槽位是否可以解锁
	for k, v in pairs(self.solt_infos) do
			local flagUnlock = false
			local flagAdd = false
			if -2 == v.ship_id_have  then
				-- 是否可以解锁
				flagUnlock = CombinationCardHandle.getSoltCanUnlockBySoltId(self.ship_mould_id,tonumber(k))
			else
				if 0 > v.ship_id_can and 0 > v.ship_id_have then
					flagAdd = #CombinationCardHandle.getCanAddCardDatas(self.ship_mould_id,tonumber(k)) > 0
				elseif 0 < v.ship_id_can and 0 > v.ship_id_have then
					if CombinationCardHandle.getCanAddFixCardDatas(v.ship_id_can) then
						flagAdd = true
					end
				end
			end			
			if flagUnlock or flagAdd then
				k = tonumber(k)
				local slotNum = #CombinationCardHandle.getSoltDatas(self.ship_mould_id)
				if 4 == slotNum then	-- 4个固定槽
					if 4 >= k then
						local Image_kuang = self.Panel_tx_guding_4:getChildByName("Image_kuang_"..k)
						CombinationCardHandle.pushTipControlSmall(Image_kuang,true,self.ship_mould_id)
					else
						local Image_tx_kuang = ccui.Helper:seekWidgetByName(root, "Image_tx_kuang_"..(k - 4))
						CombinationCardHandle.pushTipControlSmall(Image_tx_kuang,true,self.ship_mould_id)
					end
				elseif 5 == slotNum then -- 5个固定槽
					if 5 >= k then
						local Image_kuang = self.Panel_tx_guding_5:getChildByName("Image_kuang_"..k)
						CombinationCardHandle.pushTipControlSmall(Image_kuang,true,self.ship_mould_id)
					else
						local Image_tx_kuang = ccui.Helper:seekWidgetByName(root, "Image_tx_kuang_"..(k - 5))
						CombinationCardHandle.pushTipControlSmall(Image_tx_kuang,true,self.ship_mould_id)
					end
							
				elseif 3 == slotNum then   	--3个固定槽
					if 3 >= k then
						local Image_kuang = self.Panel_tx_guding_5:getChildByName("Image_kuang_"..(k + 1))
						CombinationCardHandle.pushTipControlSmall(Image_kuang,true,self.ship_mould_id)
					else
						local Image_tx_kuang = ccui.Helper:seekWidgetByName(root, "Image_tx_kuang_"..(k - 3))
						CombinationCardHandle.pushTipControlSmall(Image_tx_kuang,true,self.ship_mould_id)
					end
				end
			end
	end
end

--新项目的绘制形象方法（24，25项目）
function CombinationCardNotUnlockedWindow:newFormationShowShipChange(evoIndex)
	local root = self.roots[1]

	local Panel_1_4 = self.Panel_lihui
	-- Panel_1_4:setTouchEnabled(false)
	
	local ship = getShipByTemplateId(self.ship_mould_id)
	----------------------新的数码的形象------------------------
	--进化形象
	local evo_image = dms.string(dms["ship_mould"], self.ship_mould_id, ship_mould.fitSkillTwo)
	local evo_info = zstring.split(evo_image, ",")
	evoIndex = evoIndex or 1
	evoIndex = (evoIndex - 1) % #evo_info + 1
	evoIndex = math.abs(evoIndex)
	--进化模板id
	local ship_evo = zstring.split(ship.evolution_status, "|")
	local evo_mould_id = smGetSkinEvoIdChange(ship)
	--新的形象编号
	local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
	Panel_1_4:removeAllChildren(true)
	draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_1_4, nil, nil, cc.p(0.5, 0))
	app.load("client.battle.fight.FightEnum")
	local armature_hero = sp.spine_sprite(Panel_1_4, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
	armature_hero:setScaleX(-1)
	self.armature_hero = armature_hero
	armature_hero.animationNameList = spineAnimations
	sp.initArmature(self.armature_hero, true)
	local function changeActionCallback( armatureBack )
		
	end

	local actionIndex = _enum_animation_l_frame_index.animation_skill_attacking
	local actionIndexs = {
		_enum_animation_l_frame_index.animation_standby,
		_enum_animation_l_frame_index.animation_skill_attacking,
		_enum_animation_l_frame_index.animation_power_skill_attacking,
		-- _enum_animation_l_frame_index.animation_new_skill_13_jueji
	}
	actionIndex = actionIndexs[math.random(1, #actionIndexs)]

	armature_hero._self = self
	-- armature_hero:getAnimation():setFrameEventCallFunc(onFrameEventRole)
	armature_hero._invoke = changeActionCallback
	armature_hero:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	csb.animationChangeToAction(self.armature_hero, actionIndex, 0, false)
	
	local soundid = dms.string(dms["ship_mould"], self.ship_mould_id, ship_mould.sound_index)
	playEffectExt(formatMusicFile("effect", soundid))
end

-- 控制一键升级按钮的显隐，以及可交互性
function CombinationCardNotUnlockedWindow:setOneClickBtnShowAndTouch(isShow, isTouch)
	if self.Button_soul_up_4 ~= nil then
		isTouch = isTouch == true and isTouch or false
		self.Button_soul_up_4:setVisible(isShow)
		self.Button_soul_up_4:setEnabled(isTouch)
		self.Button_soul_up_4:setBright(isTouch)
	end
end

function CombinationCardNotUnlockedWindow:onEnterTransitionFinish()
	-- 加载CombinationCardNotUnlockedWindowWindow界面资源.
	-- res.cultivate.combinationCard.Combination_card_not_unlocked = res/cultivate/combinationCard/Combination_card_not_unlocked.csb
	local csbNode = csb.createNode("cultivate/Combination_card/Combination_card_not_unlocked.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	-- 关闭按钮
	self.Button_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil,
	{
		terminal_name = "combination_card_not_unlocked_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 兑换碎片按钮做显示隐藏
	self.Button_duhuan = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_duhuan"), nil,
	{
		terminal_name = "combination_card_chip_exchange_click",
		terminal_state = 0,
		ship_mould_id = self.ship_mould_id,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 升级按钮做显示隐藏
	self.Button_soul_up_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_soul_up_1"), nil,
	{
		terminal_name = "combination_card_up_level_click",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 进阶按钮做显示隐藏
	self.Button_soul_up_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_soul_up_2"), nil,
	{
		terminal_name = "combination_card_break_click",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.Button_soul_up_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_soul_up_3"), nil,
	{
		terminal_name = "combination_card_solt_unlock_click",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 一键升级按钮
	self.Button_soul_up_4 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_soul_up_4"), nil,
	{
		terminal_name = "combination_card_open_upgrade",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
	
	self:onFixDraw()
end

-- 对象初始化
function CombinationCardNotUnlockedWindow:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CombinationCardNotUnlockedWindow:onInit(params)
	self.ship_mould_id = tonumber(params[1])
	return self
end

function CombinationCardNotUnlockedWindow:onExit()
	-- 释放CombinationCardNotUnlockedWindowWindow界面资源.
	state_machine.remove("combination_card_not_unlocked_window_show")
	state_machine.remove("combination_card_not_unlocked_window_hide")
	state_machine.remove("combination_card_unlocked_condition_card_get")
	state_machine.remove("combination_card_click_unlock_card")
	state_machine.remove("combination_card_slot_click")
	state_machine.remove("combination_card_chip_exchange_click")
	state_machine.remove("combination_card_up_level_click")
	state_machine.remove("combination_card_break_click")
	state_machine.remove("combination_card_unlock_window_refresh")
	state_machine.remove("combination_card_solt_unlock_click")
	state_machine.remove("combination_card_change_hero_sprite_info_play_animation")
	state_machine.remove("combination_card_open_upgrade")
	
end

function CombinationCardNotUnlockedWindow:close()
	-- window event : close.
	
end

function CombinationCardNotUnlockedWindow:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------