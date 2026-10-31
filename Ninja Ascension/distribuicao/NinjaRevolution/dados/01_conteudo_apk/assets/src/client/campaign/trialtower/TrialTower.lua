-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双主界面
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

TrialTower = class("TrialTowerClass", Window)
    
function TrialTower:ctor()
    self.super:ctor()
    app.load("client.campaign.trialtower.JiangLi")
    app.load("client.campaign.trialtower.GuanQia")
    app.load("client.campaign.trialtower.PaiHang")
    app.load("client.campaign.trialtower.TrialTowerShop")
    app.load("client.campaign.trialtower.AttributeAddition")
	app.load("client.campaign.trialtower.AdditionSelect")
	app.load("client.campaign.trialtower.TrialTowerRewardBox")
	app.load("client.campaign.trialtower.TrialTowerLostTreasure")
	app.load("client.campaign.trialtower.TrialTowerSpoilsReport")
	
	app.load("client.battle.BattleStartEffect")
	
	
	
	self.enum_stateType = { 
		_COMMON = 1,	--普通默认的
		_UPDATE = 2, --播放更新动画的
		_WIN = 3, --播放胜利动画的
		_LOST = 4, --播放失败动画的
		
	}
	self.updateState = 0
	
	self.roots = {}
	
	self.npcQueue = {} -- npc-csb
	self.currentResetPrice = 0 --可重置的价格 0,免费重置价格,大于0宝石重置价格,-1重置用完了
    -- Initialize TrialTower page state machine.
    local function init_trial_tower_terminal()
		--返回
		local trial_tower_back_activity_terminal = {
            _name = "trial_tower_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then	
					if fwin:find("CampaignClass") == nil then
						state_machine.excute("menu_show_campaign",0,3)
					else
						state_machine.excute("campaign_window_show",0,"")
					end
				else
					fwin:open(Campaign:new(), fwin._view)
				end
				fwin:close(instance)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--宝石重置的消息来了
		local trialtower_goto_reset_gem_terminal = {
            _name = "trialtower_goto_reset_gem",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					instance:resetTrialTower()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--扫荡回来了要清理界面了
		local trialtower_sweep_end_terminal = {
            _name = "trialtower_sweep_end",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:sweepEnd()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
	
		--进到下一层了刷新吧
		local trialtower_goto_next_level_terminal = {
            _name = "trialtower_goto_next_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					instance:refresh()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--已经领取了奖励了,该去检查加属性了
		local trialtower_draw_reward_end_terminal = {
            _name = "trialtower_draw_reward_end",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
            		if instance == nil or instance.roots == nil then
            			return
            		end
            	end
				instance:showAdditionSelect()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--打开选择属性加成
		local addition_Select_tower_button_terminal = {
            _name = "addition_Select_tower_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					local win = AdditionSelect:new()
					win:init()
					fwin:open(win, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--重置按钮
		local reset_trial_tower_button_terminal = {
            _name = "reset_trial_tower_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					instance:checkupReset()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--扫荡
		local trial_tower_sweep_button_terminal = {
            _name = "trial_tower_sweep_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					instance:checkupSweep()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		--奖励按钮
		local trial_tower_reward_button_terminal = {
            _name = "trial_tower_reward_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:open(JiangLi:new(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--获得通关奖励
		local trial_tower_show_reward_list_box_terminal = {
            _name = "trial_tower_show_reward_list_box",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					
				local win = TrialTowerRewardBox:new() 
				win:init(params.rewardList171)
                fwin:open(win, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		
		
			--英雄按钮
		local hero_trial_tower_button_terminal = {
            _name = "hero_trial_tower_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					-- or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				-- else
				-- 	if true == instance._endNPC then
				-- 		TipDlg.drawTextDailog(tipStringInfo_trialTower[18])
				-- 		return
				-- 	end
				-- end
				local guanQia = GuanQia:new()
				guanQia:init(params._datas._info)
                fwin:open(guanQia, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
			--排行按钮
		local arrange_trial_tower_button_terminal = {
            _name = "arrange_trial_tower_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
            		or __lua_project_id == __lua_project_red_alert 
            		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
            		or __lua_project_id == __lua_project_yugioh
            		or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
            		or __lua_project_id == __lua_project_warship_girl_b 
            		then
            		fwin:open(PaiHang:new(), fwin._windows)
            	else
					local function responsePropCompoundCallback(response)
	                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
							fwin:open(PaiHang:new(), fwin._windows)
						end
	                end
					protocol_command.search_order_list.param_list = "".."10"
	                NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		--神装商店按钮
		local shop_trial_tower_button_terminal = {
            _name = "shop_trial_tower_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if nil == fwin:find("TrialTowerClass") then
					return
				end
				
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
					or __lua_project_id == __lua_project_yugioh
					or __lua_project_id ==__lua_project_pokemon
					or __lua_project_id == __lua_project_warship_girl_b 
					then
					fwin:open(TrialTowerShop:new(), fwin._view)
				else
					local day = os.date("%d")
				
					if nil ~= _ED.dignified_shop_init and day == instance.day then
						fwin:open(TrialTowerShop:new(), fwin._view)
					else
						local function responseDignifiedShopInitCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								if nil == fwin:find("TrialTowerClass") then
									return
								end
					
								response.node.day = day
								
								fwin:open(TrialTowerShop:new(), fwin._view)
							end
						end
						NetworkManager:register(protocol_command.dignified_shop_init.code, nil, nil, nil, instance, responseDignifiedShopInitCallback, false, nil)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--属性加成按钮
		local AttributeAddition_button_terminal = {
            _name = "AttributeAddition_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
                fwin:open(AttributeAddition:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		
		-- 购买无双秘籍完成了
		local trial_tower_buy_lost_treasure_complete_terminal = {
            _name = "trial_tower_buy_lost_treasure_complete",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
				
				instance:buyLostTreasureComplete()

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local trial_tower_buy_updatenumber_terminal = {
            _name = "trial_tower_buy_updatenumber",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 						
				instance:updateUINumber()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --一键三星
		local trial_tower_one_key_three_star_terminal = {
            _name = "trial_tower_one_key_three_star",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 	
                local target = params._datas.cell				
				local is_onKey3 = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 72, fun_open_condition.level)
				if is_onKey3 == false then 
					TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 72, fun_open_condition.tip_info))
					return
				end
                local npcIndex = (tonumber(_ED.three_kingdoms_view.current_floor)-1) * 3 + 1 
                if npcIndex >= _ED.one_key_sweep_three_max_pass then 
                    --超过最大数
                    TipDlg.drawTextDailog(tipStringInfo_trialTower[33])
                    return
                end
				local function requestReset(instance,n)
                    if n == 0 then 
                        local function responseOneKeyCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								if nil == fwin:find("TrialTowerClass") then
									return
								end
								app.load("client.campaign.trialtower.TrialTowerOneKeyThreeStar")
								state_machine.excute("trial_tower_one_key_three_star_window_open",0,0)
						
							end
						end
						NetworkManager:register(protocol_command.one_key_sweep_three_kingdoms.code, nil, nil, nil, nil, responseOneKeyCallback, false, nil)
                    end
                end
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                    or __lua_project_id == __lua_project_red_alert then 
                    app.load("client.utils.ConfirmTip")
                    local tip = ConfirmTip:new()
                    local stringTip = string.format(tipStringInfo_trialTower[32],_ED.one_key_sweep_three_max_pass)
                    tip:init(self, requestReset,stringTip)
                    fwin:open(tip,fwin._dialog)
                else
                    app.load("client.utils.ConfirmPrompted")
                    local tip = ConfirmPrompted:new()
                    local stringTip = string.format(tipStringInfo_trialTower[32],_ED.one_key_sweep_three_max_pass)

                    tip:init(self, requestReset,stringTip)
                    fwin:open(tip,fwin._ui)
                end 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        
		state_machine.add(trial_tower_buy_lost_treasure_complete_terminal)
		state_machine.add(trialtower_sweep_end_terminal)
		state_machine.add(trial_tower_sweep_button_terminal)
		state_machine.add(trialtower_goto_reset_gem_terminal)
		state_machine.add(trialtower_goto_next_level_terminal)
		state_machine.add(trial_tower_show_reward_list_box_terminal)
		state_machine.add(reset_trial_tower_button_terminal)
		state_machine.add(trialtower_draw_reward_end_terminal)
		state_machine.add(addition_Select_tower_button_terminal)
		state_machine.add(trial_tower_back_activity_terminal)
		state_machine.add(trial_tower_reward_button_terminal)
		state_machine.add(hero_trial_tower_button_terminal)
		state_machine.add(arrange_trial_tower_button_terminal)
		state_machine.add(shop_trial_tower_button_terminal)
		state_machine.add(AttributeAddition_button_terminal)
		state_machine.add(trial_tower_buy_updatenumber_terminal)
		state_machine.add(trial_tower_one_key_three_star_terminal)
        state_machine.init()
    end
	
	
    -- call func init hom state machine.
    init_trial_tower_terminal()
end



-- 刷新.当进入下一层
function TrialTower:refresh()
	self.activateNPCInfo = nil
	self.updateState = self.enum_stateType._UPDATE
	self:updataDraw()
	self:activateNPC()
end

function TrialTower:updataDraw()
	
	self:initDate()
	self:updateUIInfo()
	
	
	-- 宝箱归位
	if nil ~= self.Button_2 then
		self.Button_2:setTouchEnabled(true)
		self.Button_2:setVisible(true)
	end
	self.rewardBoxAction = csb.createTimeline("campaign/TrialTower/trial_tower.csb")
	self.csbTrialTower:runAction(self.rewardBoxAction)
	self.rewardBoxAction:gotoFrameAndPlay(1, 1, false)
	
	
	self:updateNPCState()
	self:updateReset()
	
	-- 检查扫荡开启
	local grade = dms.int(dms["fun_open_condition"], 48, fun_open_condition.level)
	-- if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		-- or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		if tonumber(_ED.user_info.user_grade) < grade or tonumber(_ED.three_kingdoms_view.lost_stae)  == -1  or tonumber(_ED.three_kingdoms_view.lost_stae)  == -2  then
			self.resetButton:setVisible(true)
			self.sweepButton:setVisible(false)
		else
			self.sweepButton:setVisible(true)
			self.resetButton:setVisible(false)
		end
	-- else
	-- 	if tonumber(_ED.user_info.user_grade) < grade or tonumber(_ED.three_kingdoms_view.lost_stae)  == -1 then
	-- 		self.resetButton:setVisible(true)
	-- 	else
	-- 		self.sweepButton:setVisible(true)
	-- 	end
	-- end


	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local tip = dms.string(dms["fun_open_condition"],48,fun_open_condition.tip_info)
		-- local isopen , tip = getFunopenLevelAndTip(48)
		-- print("=========",tip)
		local Text_saodang = ccui.Helper:seekWidgetByName(self.roots[1],"Text_saodang")
		if Text_saodang ~= nil then
			Text_saodang:setString(tip)
		end
	end
end

-- 显示失败界面
function TrialTower:createOverLost(panelLayer)
	local csbTrialTowerCard = csb.createNode("campaign/TrialTower/trial_tower_card_0.csb")
	panelLayer:addChild(csbTrialTowerCard)
	self.lostNPC = csbTrialTowerCard
	local csbTrialTowerCard_root = csbTrialTowerCard:getChildByName("root")
	local npcIcon = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Panel_17")
	local Panel_right = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Panel_4")
	local Text_right = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Text_2023")
	local Armature = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Panel_26")
	Armature:setVisible(false)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local shipPanel = npcIcon
		shipPanel:removeAllChildren(true)
		draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
		if animationMode == 1 then
			app.load("client.battle.fight.FightEnum")
			local hero = sp.spine_sprite(shipPanel, 1089, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			hero:setScaleX(-1.3)
			hero:setScaleY(1.3)
		else
			draw.createEffect("spirte_" .. 89, "sprite/spirte_" .. 89 .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0)):setScaleX(-1)
		end
	else
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
			npcIcon:removeBackGroundImage()
		else
			npcIcon:setBackGroundImage("images/ui/decorative/yindao_zhushou.png")
		end
		
	end
	Panel_right:setVisible(true)
	
	local Panel_left = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Panel_3")
	Panel_left:setVisible(false)
	
	local npcIndex = self.npcIndex -1
    local endlevel = 0
    if  __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_yugioh 
        or __lua_project_id == __lua_project_warship_girl_b 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge
        --or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then 
            endlevel = self.npcIndex + self.currentIndex
    else
            endlevel = npcIndex
    end
	local txt = ""
	if npcIndex == 0 then
		txt = _string_piece_info[287]
	else
		txt = string.format(tipStringInfo_trialTower[16],endlevel)	
	end

	Text_right:setString(txt)
	
	local grade = dms.int(dms["fun_open_condition"], 48, fun_open_condition.level)

	if tonumber(_ED.user_info.user_grade) < grade then
		local levelStr = tipStringInfo_trialTower[30] --string.format(tipStringInfo_trialTower[17],grade)
		ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Text_157"):setString(levelStr)
	end
	

	local action = csb.createTimeline("campaign/TrialTower/trial_tower_card_0.csb")
    csbTrialTowerCard:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
    end)
    action:play("qipao_dh", false)
end

function TrialTower:onTouchEventFromLostTreasure(iconCell)
	-- 显示 购买秘籍
	local treasure = TrialTowerLostTreasure:new()
	treasure:init()
	fwin:open(treasure, fwin._windows)
end

function TrialTower:getPropCell(mid, count, mouldType)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.count = count
	cellConfig.touchShowType = nil
	cellConfig.isShowName = nil
	cellConfig.isDebris = true
	cellConfig.mouldType = mouldType or 6
	cell:init(cellConfig,self.onTouchEventFromLostTreasure, self)
	return cell
end


function TrialTower:buyLostTreasureComplete()

	if 1 == _ED.three_kingdoms_lost_treasure.isBuy then
		ccui.Helper:seekWidgetByName(self.csbTrialTower_root, "Panel_204"):setVisible(false)
	end

end

-- 画失败的无双秘籍
function TrialTower:drawLostTreasure()
	-- 取出 购买索引和购买的状态
	-- 无双秘籍ID 购买状态(0 未购买 1 已购买)
	-- _ED.three_kingdoms_lost_treasure = {
		-- indexID = 6,
		-- isBuy = 0,
	-- }
	
	self:buyLostTreasureComplete()
	
	local indexID = _ED.three_kingdoms_lost_treasure.indexID
	local isBuy = _ED.three_kingdoms_lost_treasure.isBuy
	local mid = nil
	local count = nil
	local mouldType = nil
	local selType = nil
	
	mid = dms.int(dms["unparalleled_reward_param"], indexID, unparalleled_reward_param.mould)
	count = dms.int(dms["unparalleled_reward_param"], indexID, unparalleled_reward_param.sel_count)
	selType = dms.int(dms["unparalleled_reward_param"], indexID, unparalleled_reward_param.sel_type)
	
	selSilver = dms.int(dms["unparalleled_reward_param"], indexID, unparalleled_reward_param.sel_silver)
	
	if 0 < selSilver then
		mouldType = 1
		count = selSilver
	elseif 0 == selType then
		mouldType = 6
	elseif 1 == selType then
		mouldType = 13
	elseif 2 == selType then
		mouldType = 7
	
	end
	
	local treasureCell = self:getPropCell(mid, count, mouldType)

	ccui.Helper:seekWidgetByName(self.csbTrialTower_root, "Panel_1"):setVisible(true)
	ccui.Helper:seekWidgetByName(self.csbTrialTower_root, "Panel_trial_box"):addChild(treasureCell)
end

-- 关闭无双秘籍显示
function TrialTower:closeLostTreasure()
	ccui.Helper:seekWidgetByName(self.csbTrialTower_root, "Panel_1"):setVisible(false)
end


-- 画胜利的星星
function TrialTower:drawWinStar(csbCard,starsNum)
	
	starsNum = math.min(tonumber(starsNum), 3)
	local fname = {
		"star_1",
		"star_2",
		"star_3",
	}
	
	local i = 1
	
	local action = csb.createTimeline("campaign/TrialTower/trial_tower_card.csb")
	csbCard:runAction(action)
	
	
	function playStar()
		i = i + 1
			
		if i <= starsNum then
			action:play(fname[i], false)	
		else
			-- 播完了
			self:checkupSceneReward()
			self:activateNPC()
		end
	
	end
	
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
		elseif str == "over1" then
			playStar()
		elseif str == "over2" then
			playStar()
        elseif str == "over3" then
			playStar()
        end
    end)
    action:play(fname[i], false)

end

-- 打败的npc
function TrialTower:createOverNPC(panelLayer, starsNum)
	local csbCard = csb.createNode("campaign/TrialTower/trial_tower_card.csb")
	panelLayer:addChild(csbCard)
	local csbCard_root = csbCard:getChildByName("root")
	local action = csb.createTimeline("campaign/TrialTower/trial_tower_card.csb")
	if -1 ~= starsNum then
		starsNum = math.min(tonumber(starsNum), 3)
		--星星
		local fname = {
			"star_1_0",
			"star_2_0",
			"star_3_0",
		}
		
		if  starsNum > 0 then
			action:play(fname[starsNum], false)
		end
	else
		action:gotoFrameAndPlay(1, 1, false)
	end
	
	csbCard:runAction(action)
	
	return csbCard
end

function TrialTower:activateNPC()
	-- 如此写法,只是为了移植代码兼容

	if nil == self.activateNPCInfo then
		return
	end

	local csbTrialTowerCard = self.activateNPCInfo.npcNode
	local npcMID = self.activateNPCInfo.npcMID
	local panelLayer  = self.activateNPCInfo.panelLayer
	local npcIconIndex  = self.activateNPCInfo.npcIconIndex
	local npcState  = self.activateNPCInfo.npcState
	local num  = self.activateNPCInfo.num
	local name  = self.activateNPCInfo.name
	local paopao  = self.activateNPCInfo.paopao
	local isleft  = self.activateNPCInfo.isleft

	--csbTrialTowerCard:removeFromParent(false)
	
	
	-- self.npcQueue[1]:removeFromParent(false)
	
	
	-- panelLayer:removeChild(csbTrialTowerCard)

	local csbTrialTowerCard_root = csbTrialTowerCard:getChildByName("root")
	--local overIcon = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Panel_19")
	local npcIcon = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Panel_17")
	local Armature = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Panel_26")
	
	local nameText = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Text_24")
	nameText:setString(name)
	
	local numText = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Text_024_0")
	numText:setString(_string_piece_info[2]..num.._string_piece_info[3])

	-- 左边气泡
	local Panel_left = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Panel_3")
	local Text_left = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Text_2023_0")
	
	-- 右边气泡
	local Panel_right = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Panel_4")
	local Text_right = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Text_2023")
	
	npcIcon:setColor(cc.c3b(255, 255, 255))
	
	--呼吸
	local scaleByBreathe = cc.ScaleBy:create(5, 1.05)
	npcIcon:runAction(cc.RepeatForever:create(cc.Sequence:create(scaleByBreathe, scaleByBreathe:reverse())))
	
	
	Armature:setVisible(true)
	
	if nil ~= paopao then
		if true == isleft then 
			Panel_left:setVisible(true)
			Panel_right:setVisible(false)
			
			Text_left:setString(paopao)
		else
			Panel_left:setVisible(false)
			Panel_right:setVisible(true)
			
			Text_right:setString(paopao)
		end
		
		
		local action = csb.createTimeline("campaign/TrialTower/trial_tower_card_0.csb")
		csbTrialTowerCard:runAction(action)
		action:setFrameEventCallFunc(function (frame)
			if nil == frame then
				return
			end
		end)
		action:play("qipao_dh", false)
		
		
		--点击事件
		fwin:addTouchEventListener(npcIcon, nil, 
		{
			terminal_name = "hero_trial_tower_button", 
			terminal_state = 0,
			_info = {
				npcMID = npcMID,
				num = num,
				name = name,
				paopao = paopao,
				npcIconIndex = npcIconIndex,
				guanqiaCondition = self.GuanqiaCondition,	
				achievementIndex = self.achievementIndex,
			}
		}, nil, 0)
	end
	
end

-- 一般的npc
function TrialTower:createNPC(npcMID,panelLayer, npcIconIndex, npcState, num, name, paopao, isleft,delayIndex)
	
	local csbTrialTowerCard = csb.createNode("campaign/TrialTower/trial_tower_card_0.csb")
	panelLayer:addChild(csbTrialTowerCard)
	local csbTrialTowerCard_root = csbTrialTowerCard:getChildByName("root")
	
	table.insert(self.roots, csbTrialTowerCard_root)
	
	--local overIcon = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Panel_19")
	local npcIcon = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Panel_17")
	local ArmaturePanel = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Panel_26")
	ArmaturePanel:removeAllChildren(true)

	local nameText = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Text_24")
	nameText:setString(name)
	
	local numText = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Text_024_0")
	numText:setString(_string_piece_info[2]..num.._string_piece_info[3])

	-- 左边气泡
	local Panel_left = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Panel_3")
	local Text_left = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Text_2023_0")
	Panel_left:setVisible(false)
	-- 右边气泡
	local Panel_right = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Panel_4")
	local Text_right = ccui.Helper:seekWidgetByName(csbTrialTowerCard_root, "Text_2023")
	Panel_right:setVisible(false)
	if npcState == 1 then
		-- 打过的
		
	elseif npcState == 2 then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			local temp_bust_index = npcIconIndex
			local shipPanel = npcIcon
			shipPanel:removeAllChildren(true)
			draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
			if animationMode == 1 then
				app.load("client.battle.fight.FightEnum")
				local shipSpine = sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0)):setScaleX(-1)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    shipSpine:setScaleX(-1)
                end
            else
				draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0)):setScaleX(-1)
			end
			local armature = ccs.Armature:create("effice_ui_npc_2")
	        draw.initArmature(armature, nil, -1, 0, 1)
			ArmaturePanel:addChild(armature)
			armature._actionIndex = 0
			armature:getAnimation():playWithIndex(0)
		else
			local isHaveSpineAni = false
			if __lua_project_id == __lua_project_yugioh then
				local jsonFile = string.format("sprite/spirte_battle_card_%s.json", npcIconIndex)
				if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
					isHaveSpineAni = true
					npcIcon:removeAllChildren(true)
			        local atlasFile = string.format("sprite/spirte_battle_card_%s.atlas", npcIconIndex)
			        app.load("client.battle.fight.FightEnum")
			        local spArmature = sp.spine(jsonFile, atlasFile, 1, 0, 
			            spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)

			        spArmature:setPosition(cc.p(npcIcon:getContentSize().width/2, 0))
			        spArmature.animationNameList = spineAnimations
			        sp.initArmature(spArmature, true)
			        npcIcon:addChild(spArmature)
			  
			        if delayIndex ~= nil then 
		        	elseif delayIndex == 1 then 
		        		spArmature:setScale(0.77)
					elseif delayIndex == 2 then 
						spArmature:setScale(0.62)
					elseif delayIndex == 3 then 
						spArmature:setScale(0.5)			        		
			        end
			    end
		    end

			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge then
				npcIcon:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", npcIconIndex))
				npcIcon:setScale(0.6)
			else
				if isHaveSpineAni == false then
					if __lua_project_id == __lua_project_yugioh then
						npcIcon:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", npcIconIndex))
					end
				end
				npcIcon:setBackGroundImage(string.format("images/face/card_head/card_head_%d.png", npcIconIndex))
			end
			npcIcon:setColor(cc.c3b(50, 50, 50))
		end
	elseif npcState == 3 then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_"..npcIconIndex ..".ExportJson")
			-- local cell = ccs.Armature:create("spirte_".. npcIconIndex)
			-- cell:getAnimation():playWithIndex(0)
			-- npcIcon:addChild(cell)
			-- cell:setScaleX(-1)
			-- -- cell:setPosition(cc.p( cell:getContentSize().width/2, cell:getContentSize().height/2) )
			-- -- cell:setAnchorPoint(0.5,0.5)
			-- cell:setPosition(cc.p( npcIcon:getContentSize().width/2, 0) )
			
			local temp_bust_index = npcIconIndex
			local shipPanel = npcIcon
			shipPanel:removeAllChildren(true)
			draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
			
			if animationMode == 1 then
				app.load("client.battle.fight.FightEnum")
				local shipSpine = sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0)):setScaleX(-1)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    shipSpine:setScaleX(-1)
                end
            else
				draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0)):setScaleX(-1)
			end

			npcIcon:setColor(cc.c3b(50, 50, 50))
		else
			local isHaveSpineAni = false
			if __lua_project_id == __lua_project_yugioh then
				local jsonFile = string.format("sprite/spirte_battle_card_%s.json", npcIconIndex)
				if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
					isHaveSpineAni = true
					npcIcon:removeAllChildren(true)
			        local atlasFile = string.format("sprite/spirte_battle_card_%s.atlas", npcIconIndex)
			        app.load("client.battle.fight.FightEnum")
			        local spArmature = sp.spine(jsonFile, atlasFile, 1, 0, 
			            spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)

			        spArmature:setPosition(cc.p(npcIcon:getContentSize().width/2, 0))
			        spArmature.animationNameList = spineAnimations
			        sp.initArmature(spArmature, true)
			        npcIcon:addChild(spArmature)
			        if delayIndex ~= nil then 
		        	elseif delayIndex == 1 then 
		        		spArmature:setScale(0.77)
					elseif delayIndex == 2 then 
						spArmature:setScale(0.62)
					elseif delayIndex == 3 then 
						spArmature:setScale(0.5)			        		
			        end
			        spArmature:setColor(cc.c3b(50, 50, 50))
			    end
		    end

			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge then
				npcIcon:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", npcIconIndex))
				npcIcon:setScale(0.6)
			else
				if isHaveSpineAni == false then
					if __lua_project_id == __lua_project_yugioh then
						npcIcon:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", npcIconIndex))
					end
				end
				npcIcon:setBackGroundImage(string.format("images/face/card_head/card_head_%d.png", npcIconIndex))
			end
			
			npcIcon:setColor(cc.c3b(50, 50, 50))
		end
	end
	
	-- 将原处理延迟到创建完毕所有之后(即砸星星动画之后)
	-- if nil ~= paopao then
		-- if true == isleft then 
			-- Panel_left:setVisible(true)
			-- Panel_right:setVisible(false)
			
			-- Text_left:setString(paopao)
		-- else
			-- Panel_left:setVisible(false)
			-- Panel_right:setVisible(true)
			
			-- Text_right:setString(paopao)
		-- end
		
		
		-- local action = csb.createTimeline("campaign/TrialTower/trial_tower_card_0.csb")
		-- csbTrialTowerCard:runAction(action)
		-- action:setFrameEventCallFunc(function (frame)
			-- if nil == frame then
				-- return
			-- end
		-- end)
		-- action:play("qipao_dh", false)
		
		
		-- --点击事件
		-- fwin:addTouchEventListener(npcIcon, nil, 
		-- {
			-- terminal_name = "hero_trial_tower_button", 
			-- terminal_state = 0,
			-- _info = {
				-- npcMID = npcMID,
				-- num = num,
				-- name = name,
				-- paopao = paopao,
				-- npcIconIndex = npcIconIndex,
				-- guanqiaCondition = self.GuanqiaCondition,		
			-- }
		-- }, nil, 0)
	-- end
	
	return csbTrialTowerCard
end

function TrialTower:initDate()
	self.layerNpcCount = 3	--  3个npc
	self.npcStar = _ED.three_kingdoms_view.npc_star --星星
	self.layerCount = tonumber(_ED.three_kingdoms_view.current_floor) -- 第几层
	self.currentIndex = tonumber(_ED.three_kingdoms_view.current_npc_pos) --当前挑战位置
	
	self.npcList = dms.string(dms["three_kingdoms_config"], tonumber(self.layerCount), three_kingdoms_config.npc_id) -- {npc_id1, npc_id2,...}  当前npc列表
	self.datas = zstring.split(self.npcList , ",")  --拆分
	
	self.npcIndex = (self.layerCount-1) * 3 + 1 
	
	self.sceneState = {3, 3, 3}	 -- max:0结束npc	1打过了 2可以攻打 3还没的  npc状态
	
	for i = 1 , self.layerNpcCount do
		if i == self.currentIndex + 1 then
			self.sceneState[i] = 2
		elseif i <= self.currentIndex then
			self.sceneState[i] = 1
		end
	end
	
	--检查当前要攻打的是不是最后一关
	local data = dms["three_kingdoms_config"]
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		if self.layerCount ==  #data then
			if self.currentIndex == 2 then
				self._endNPC = true --标记当前是末尾npc了
			end
		end
	else
		if self.layerCount + 1 ==  #data then
			if self.currentIndex == 2 then
				self._endNPC = true --标记当前是末尾npc了
			end
		end
	end
end




-- 对npc的状态做更新
function TrialTower:updateNPCState()
	
	for i = 1, #self.npcQueue do
		self.npcQueue[i]:stopAllActions()
		self.npcQueue[i]:removeFromParent(false)
	end
	
	if nil ~= self.lostNPC then
		self.lostNPC:removeFromParent(false)
	end
	
	self.npcQueue = {}
	
	local panelLayer = nil
    local root = self.roots[1]
	local Button_3xing = ccui.Helper:seekWidgetByName(root, "Button_3xing")
    if Button_3xing ~= nil then 
        Button_3xing:setVisible(true)
    end
	
	if tonumber(_ED.three_kingdoms_view.lost_stae)  == -1 then
		-- 进入战败处理
		panelLayer = ccui.Helper:seekWidgetByName(self.csbTrialTowerJuese_root, "Panel_19")
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
			panelLayer:setVisible(true)
		end
		self:createOverLost(panelLayer)
		
		-- 准备无双秘籍
		self:drawLostTreasure()
		
		if self.updateState == self.enum_stateType._LOST then
			-- 弹出秘籍
			self:onTouchEventFromLostTreasure(nil)
		end
		self.Button_2:setVisible(false)
        if Button_3xing ~= nil then 
            Button_3xing:setVisible(false)
        end
		
	else

		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
			ccui.Helper:seekWidgetByName(self.csbTrialTowerJuese_root, "Panel_19"):setVisible(false)
		end
		self:closeLostTreasure()
		local delayIndex = 0
		local function drawOnceNPC( ... )
			panelLayer = ccui.Helper:seekWidgetByName(self.csbTrialTowerJuese_root, string.format("Panel_no%d", delayIndex))	
			
			--32,33,34	
			local npcMID = tonumber(self.datas[delayIndex])
			local npcIconIndex = dms.int(dms["npc"], npcMID, npc.head_pic) - 1000
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				npcIconIndex = dms.int(dms["npc"], npcMID, npc.head_pic)
			else
				npcIconIndex = dms.int(dms["npc"], npcMID, npc.head_pic) - 1000
			end
			local num = self.npcIndex + delayIndex
			local name = dms.string(dms["npc"], npcMID, npc.npc_name)
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                local name_info = ""
                local name_data = zstring.split(name, "|")
                for i, v in pairs(name_data) do
                    local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
                    name_info = name_info..word_info[3]
                end
                name = name_info
            end
			local npcNode = nil
			local npcNode_root = nil
			local isleft = false
			local paopao = nil
			
			
			if self.sceneState[delayIndex] == 1 then
				-- 已经打过的
				
				local num = self.npcStar[delayIndex]
				if delayIndex == self.currentIndex and self.updateState == self.enum_stateType._WIN then
					num = -1
				end
				npcNode = self:createOverNPC(panelLayer, num)
			elseif self.sceneState[delayIndex] == 2 then
				-- 当前的
				if __lua_project_id == __lua_project_yugioh then
					if delayIndex == 2 then
						isleft = true
					end
				else
					if delayIndex == 3 then
						isleft = true
					end
				end
				paopao =  dms.string(dms["npc"], npcMID, npc.sign_msg)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    local word_info = dms.element(dms["word_mould"], zstring.tonumber(paopao))
                    paopao = word_info[3]
                end
				
				npcNode = self:createNPC(npcMID, panelLayer, npcIconIndex, self.sceneState[delayIndex], num-1, name, paopao, isleft,delayIndex)
				
				self.activateNPCInfo = {
					npcNode = npcNode,
					npcMID = npcMID,
					panelLayer = panelLayer, 
					npcIconIndex = npcIconIndex, 
					npcState = self.sceneState[delayIndex], 
					num = num-1, 
					name = name, 
					paopao = paopao, 
					isleft = isleft,
				}
			else
				-- 还没的
				npcNode = self:createNPC(npcMID, panelLayer, npcIconIndex, self.sceneState[delayIndex], num-1, name,nil,nil,delayIndex)
			end
			
			table.insert(self.npcQueue, npcNode)
		end
		function drawAllNPC() 
			-- 绘制npc状态
			-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			-- 	local function repetBack( sender )
			-- 		delayIndex = delayIndex + 1
			-- 		if delayIndex > self.layerNpcCount then
			-- 			self:stopAllActionsByTag(100)
			-- 			return
			-- 		end
			-- 		drawOnceNPC()
			-- 	end
			-- 	repetBack()
			-- 	local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.05), cc.CallFunc:create(repetBack)))
			-- 	action:setTag(100)
			-- 	self:runAction(action)
			-- else
				for i = 1, self.layerNpcCount do
					delayIndex = i
					drawOnceNPC()
				end
			-- end
		end
			
		--当前是 第一个开打的npc 且 当前更新中 播放入场动画
		if 0 == self.currentIndex and self.updateState == self.enum_stateType._UPDATE then

			local action = csb.createTimeline("campaign/TrialTower/trial_tower_juese.csb")
			self.csbTrialTowerJuese_root:runAction(action)
			action:setFrameEventCallFunc(function (frame)
				if nil == frame then
					return
				end
				
				local str = frame:getEvent()
				if str == "open" then
				elseif str == "Panel_no_in_over" then
					drawAllNPC()
					self:activateNPC()
				end
			end)
			
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				for i=1, 3 do
					local Panel_no = ccui.Helper:seekWidgetByName(self.csbTrialTowerJuese_root, "Panel_no"..i)
					Panel_no:setVisible(true)
					local function changeActionCallback(armatureBack)
						if armatureBack ~= nil then
							armatureBack:removeFromParent(true)
						end
					end
					local armature = ccs.Armature:create("effect_82")
			        draw.initArmature(armature, nil, -1, 0, 1)
					Panel_no:addChild(armature)
					armature:setPosition(armature:getContentSize().width/2 - 40, armature:getContentSize().height/2 - 70)
					armature._actionIndex = 0
					armature:getAnimation():playWithIndex(0)
					armature._invoke = changeActionCallback
				end
			else
				local Panel_donghua = ccui.Helper:seekWidgetByName(self.csbTrialTowerJuese_root, "Panel_donghua")   
				for i=1, 3 do
					local ArmatureNode_no1 = Panel_donghua:getChildByName("ArmatureNode_no"..i)
					local animation_no1 = ArmatureNode_no1:getAnimation()
					animation_no1:playWithIndex(0, 0, 0)
				end
			end
			action:play("Panel_no_in", false)
		else
			drawAllNPC()
		end
	end
end
--威名刷新
function TrialTower:updateUINumber()
	local trialTowerPowerValue = _ED.user_info.all_glories or 0					-- user power value.  威名
	self.Text_31:setString(""..trialTowerPowerValue)
end
-- 界面ui的信息更新
function TrialTower:updateUIInfo()

	local csbTrialTower_root = self.csbTrialTower_root
	
	local lastStarCount = _ED.three_kingdoms_view.history_max_stars				-- last count total star count.最后星
	local currentStarCount = _ED.three_kingdoms_view.current_max_stars			-- today total star count.当前星星
	local canUseStarCount = _ED.three_kingdoms_view.left_stars					-- can you use the star. 能使用的星星
	local trialTowerPowerValue = _ED.user_info.all_glories or 0					-- user power value.  威名
	
	local npcMID = tonumber(self.datas[self.currentIndex+1])
	local achievementIndex = dms.string(dms["npc"], npcMID, npc.get_star_condition)	--通关条件-从npc取找成就模板
	self.achievementIndex = achievementIndex
	local GuanqiaCondition = dms.string(dms["achievement_mould"], achievementIndex, achievement_mould.achievement_describe)
	self.GuanqiaCondition = GuanqiaCondition

	self.Text_26_0:setString(""..lastStarCount)
	self.Text_26_1:setString(""..currentStarCount)
	self.Text_16:setString(""..canUseStarCount)
	
	self.Text_31:setString(""..trialTowerPowerValue)
	self.Text_13:setString(GuanqiaCondition)
	
	self.Text_wujiacheng:setVisible(true)
	local atrribute = _ED.three_kingdoms_view.atrribute
	local buff = ""
	ccui.Helper:seekWidgetByName(csbTrialTower_root, "Panel_20_t"):setVisible(false)
	
	
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	--重置挑战后，文本框里的都要清空，符合条件后才能重新载入
		local text1 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_19")
		local text2 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_20")
		local text3 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_19_0")
		local text4 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_20_0")
		local text5 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_23")
		text1:setString("")
		text2:setString("")
		text3:setString("")
		text4:setString("")
		text5:setString("")
	end
	
	if table.getn(atrribute) > 2 then
		ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_23"):setString(tipStringInfo_trialTower[25])
	end
	
	function aligning(title, text)
		--调整字左对齐
		local x = title:getPositionX()
		local w = title:getContentSize().width
		text:setPositionX(x + w)
	end
	local Text_title = nil 
	local Text_txt = nil
	for i, v in ipairs(atrribute) do	
		if i == 1 then
			
			if nil ~= tonumber(v[1]) and nil ~= tonumber(v[2]) then
				self.Text_wujiacheng:setVisible(false)
				ccui.Helper:seekWidgetByName(csbTrialTower_root, "Panel_20_t"):setVisible(true)
				local value,name = getTrialtowerAdditionFormatValue(v[1], v[2]) 
				
				Text_title = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_19")
				Text_title:setString(name)
				
				Text_txt = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_20")
				Text_txt:setString(value)
				
				aligning(Text_title, Text_txt)
			end
		elseif i == 2 then
			
			if nil ~= tonumber(v[1]) and nil ~= tonumber(v[2]) then
				local value,name = getTrialtowerAdditionFormatValue(v[1], v[2]) 
				
				Text_title = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_19_0")
				Text_title:setString(name)
				
				Text_txt = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_20_0")
				Text_txt:setString(value)
				
				aligning(Text_title, Text_txt)
				break
			end
		end
	end
end


function TrialTower:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self:onLoad()
	end
	-- add map for trial tower
	local csbTrialTowerJuese = csb.createNode("campaign/TrialTower/trial_tower_juese.csb")
	self.csbTrialTowerJuese_root = csbTrialTowerJuese:getChildByName("root")
	-- table.insert(self.roots, self.csbTrialTowerJuese_root)
	self:addChild(csbTrialTowerJuese)
	
	-- 放置顶部信息条
	--fwin:open(UserTopInfoA:new(), fwin._view)
	app.load("client.player.EquipPlayerInfomation") 					--顶部用户信息
	local userinfo = EquipPlayerInfomation:new()
	fwin:open(userinfo,fwin._view)
	
	-- add control layer for trial tower
    local csbTrialTower = csb.createNode("campaign/TrialTower/trial_tower.csb")
	self.csbTrialTower = csbTrialTower
	local csbTrialTower_root = csbTrialTower:getChildByName("root")
	table.insert(self.roots, csbTrialTower_root)
    self:addChild(csbTrialTower)
	self.csbTrialTower_root = csbTrialTower_root
	
	self.Text_26_0 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_26_0")

	self.Text_26_1 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_26_1")

	self.Text_16 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_16")

	self.Text_25 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_25")

	self.Text_31 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_31")

	self.Text_13 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_13")
	
	self.Text_wujiacheng = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_wujiacheng")
	
	
	--等配置  -- 重置次数已用完 --可免费重置1次
	self.Text_wuchongzhi = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Text_wuchongzhi")
	self.Text_wuchongzhi:setVisible(false)
	
	--  钻石,可重置次数
	self.Panel_21 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Panel_21")
	self.Panel_21:setVisible(false)

	
	--
	
	--重置按钮
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_9"), nil, {func_string = [[state_machine.excute("reset_trial_tower_button", 0, "reset_trial_tower_button.")]]}, nil, 0)
	
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_1"), nil, {func_string = [[state_machine.excute("trial_tower_back_activity", 0, "trial_tower_back_activity.")]]}, nil, 2)
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_10"), nil, {func_string = [[state_machine.excute("arrange_trial_tower_button", 0, "arrange_trial_tower_button.")]]}, nil, 0)
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_11"), nil, {func_string = [[state_machine.excute("shop_trial_tower_button", 0, "shop_trial_tower_button.")]]}, nil, 0)
	
	-- self.Button_2 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_2")
	-- fwin:addTouchEventListener(self.Button_2, nil, {func_string = [[state_machine.excute("trial_tower_reward_button", 0, "trial_tower_reward_button.")]]}, nil, 0)
	
	
	self.Button_2 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_2")
	
	self.resetButton = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_9")
	self.resetButton:setVisible(false)
	
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_trialtower_reset",
		_widget = self.resetButton,
		_invoke = nil,
		_interval = 0.5,})	
	
	self.sweepButton = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_9_0")
	self.sweepButton:setVisible(false)

	-- 重置按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_9"), nil, 
	{
		terminal_name = "reset_trial_tower_button", 
		terminal_state = nil,
		cell = self,
		isPressedActionEnabled = true
	},
	nil, 0)	
	
	-- 扫荡
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_9_0"), nil, 
	{
		terminal_name = "trial_tower_sweep_button", 
		terminal_state = nil,
		cell = self,
		isPressedActionEnabled = true
	},
	nil, 0)	

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_1"), nil, 
	{
		terminal_name = "trial_tower_back_activity", 
		terminal_state = nil,
		cell = self,
		isPressedActionEnabled = true
	},
	nil, 0)	
	
	local Button_10 = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_10")
	--评审状态不显示排行榜
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto then 
		if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
			Button_10:setVisible(true)
		else
			Button_10:setVisible(false)
		end
	end
	fwin:addTouchEventListener(Button_10, nil, 
	{
		terminal_name = "arrange_trial_tower_button", 
		terminal_state = nil,
		cell = self,
		isPressedActionEnabled = true
	},
	nil, 0)	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_11"), nil, 
	{
		terminal_name = "shop_trial_tower_button", 
		terminal_state = nil,
		cell = self,
		isPressedActionEnabled = true
	},
	nil, 0)	
	
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_trialtower_equip_shop",
		_widget = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_11"),
		_invoke = nil,
		_interval = 0.5,})	
	
	-- 打开奖励宝箱的按钮 
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_2"), nil, 
	{
		terminal_name = "trial_tower_reward_button", 
		terminal_state = nil,
		cell = self,
		isPressedActionEnabled = true
	},
	nil, 0)	
	
	local Button_3xing = ccui.Helper:seekWidgetByName(csbTrialTower_root, "Button_3xing")
	if Button_3xing ~= nil then 

		fwin:addTouchEventListener(Button_3xing, nil, 
		{
			terminal_name = "trial_tower_one_key_three_star", 
			terminal_state = nil,
			cell = self,
			isPressedActionEnabled = true
		},
		nil, 0)	
	end
	

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbTrialTower_root, "Panel_20_t"), nil, {func_string = [[state_machine.excute("AttributeAddition_button", 0, "AttributeAddition_button.")]]}, nil, 0)
		
	if nil == self.rewardBoxAction then
		self.rewardBoxAction = csb.createTimeline("campaign/TrialTower/trial_tower.csb")
	end
	
	self:updataDraw()
	table.insert(self.roots, self.csbTrialTowerJuese_root)
	table.insert(self.roots, csbTrialTower_root)
	
	if self.updateState == self.enum_stateType._WIN then
		local _csbCard =  self.npcQueue[self.currentIndex]
		local _starsNum = self.npcStar[self.currentIndex]
		self:drawWinStar(_csbCard,_starsNum)
	else
		--if 0 == self.currentIndex then
			self:activateNPC()
		--end
	
		self:checkupSceneReward()
	end
	
	state_machine.excute("menu_button_hide_highlighted_all", 0, nil)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		local function responsePropCompoundCallback(response)
	        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			end
	    end
		protocol_command.search_order_list.param_list = "".."10"
	    NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
    	
    	if nil == _ED.dignified_shop_init or tonumber(_ED.dignified_shop_init.count) == 0 then
	    	local function responseDignifiedShopInitCallback(response)
				if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				end
			end
			NetworkManager:register(protocol_command.dignified_shop_init.code, nil, nil, nil, nil, responseDignifiedShopInitCallback, false, nil)
		end			
    end
end

-- 扫荡 取末尾的困难战力值
function TrialTower:getLastCombatForce()
	local npcMID = tonumber(self.datas[3])
	local strength_3 = dms.int(dms["npc"], tonumber(npcMID), npc.environment_formation3)
	local combat_force_3 = dms.int(dms["environment_formation"], strength_3, environment_formation.combat_force)
	return combat_force_3
end

--检查扫荡
function TrialTower:checkupSweep()
	--检查当前的战力,和关卡末尾的困难战力相比
	if self:getLastCombatForce() > tonumber(_ED.user_info.fight_capacity) then
		TipDlg.drawTextDailog(tipStringInfo_trialTower[26])
	else
		self:sweepTrialTower()
	end
end

-- 发起扫荡了
function TrialTower:sweepTrialTower()

	--测试-----------------------------------------
	-- _ED.sweep_kingdoms = {}
	
	-- -- 普通奖励数量
	-- _ED.sweep_kingdoms.battleReward = {}
	-- _ED.sweep_kingdoms.battleRewardCount = 3
	-- for i =1, _ED.sweep_kingdoms.battleRewardCount do
		 -- local data = {
			-- 100, --奖励1荣誉
			-- 1, --奖励1荣誉暴击率
			-- 200, --奖励1银币
			-- 2, --奖励1银币暴击率
		-- }
		-- _ED.sweep_kingdoms.battleReward[i] =  data
	-- end
	
	
	-- -- 通关奖励数量
	-- _ED.sweep_kingdoms.examReward = {}
	-- _ED.sweep_kingdoms.examRewardCount = 2
	-- for i =1, _ED.sweep_kingdoms.examRewardCount do
		 -- local data = {
			-- 20, --奖励1模板id
			-- 6, --奖励1类型
			-- 5, --奖励1数量
		-- }
		-- _ED.sweep_kingdoms.examReward[i] =  data
	-- end

	
	-- local view = TrialTowerSpoilsReport:new()
	-- view:init(self.npcIndex)
	-- fwin:open(view,fwin._windows)
	
	--------------------------

	local function responseSweepTrialTowerCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

			local view = TrialTowerSpoilsReport:new()
			if  __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_warship_girl_b 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge
				or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then 
				--当前NPC + 打到对应的索引位置为起始关卡
				view:init(self.npcIndex  + self.currentIndex,self.currentIndex)
			else
				view:init(self.npcIndex ,self.currentIndex)
			end
			
			fwin:open(view,fwin._windows)
			
		end
	end
	NetworkManager:register(protocol_command.sweep_kingdoms.code, nil, nil, nil, nil, responseSweepTrialTowerCallback, false, nil)
end

--扫荡回来了,直接弹属性选择表
function TrialTower:sweepEnd()
	self:showAdditionSelect()
end


function TrialTower:checkupSceneReward()
--检查171奖励,存在就提示获得宝箱 --三国无双37号
	local rewardList = getSceneReward(37)
	if nil ~= rewardList then
		self:runOpenRewardBox(rewardList)
	else
		self:showAdditionSelect()
	end

end

--执行打开奖励宝箱的奖励
function TrialTower:runOpenRewardBox(rewardList)
	
	self.Button_2:setTouchEnabled(false)

	--self.csbTrialTower = csb.createNode("campaign/TrialTower/trial_tower.csb")
	self.rewardBoxAction = csb.createTimeline("campaign/TrialTower/trial_tower.csb")
    self.csbTrialTower:runAction(self.rewardBoxAction)
    self.rewardBoxAction:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()

        if str == "open" then
        elseif str == "baoxiang_open_over" then
        	self.Button_2:setVisible(false)
			state_machine.excute("trial_tower_show_reward_list_box", 0, {rewardList171 = rewardList}) 
        end
    end)
    self.rewardBoxAction:play("Button_2_dh", false)
end

function TrialTower.getFreeReset()
	local vipLevel = zstring.tonumber(_ED.vip_grade)           
	local resetCountElement = dms.element(dms["base_consume"], 51)
	local attackCount = dms.atoi(resetCountElement, base_consume.vip_0_value + vipLevel) --当前vip可重置次数
	
	local count = attackCount - tonumber(_ED.three_kingdoms_reset_times)
	
	local config = zstring.split(dms.string(dms["pirates_config"], 272, pirates_config.param), ",")
	-------------计算免费的可用数--------------------------------
	local nIndex = tonumber(_ED.three_kingdoms_reset_times) + 1

	
	local freeCount = 0
	local chargeCount = 0
	for i = 1 , attackCount do
		if tonumber(config[i]) == 0 then
			freeCount = freeCount +1
		elseif tonumber(config[i]) > 0 then
			chargeCount = chargeCount +1
		end
	end
	
	local myFreeCount = freeCount - tonumber(_ED.three_kingdoms_reset_times)
	
	if myFreeCount > 0 then 
	
		return true
	end
	
	return false
end

--处理重置可用次数更新
function TrialTower:updateReset()
	-- 宝石的提示和普通提示只一次

	-- base_consume 获取vip等级可以获得的免费重置次数
	-- pirates_config272 取累计需要花费宝石数
	
	local vipLevel = zstring.tonumber(_ED.vip_grade)           
	local resetCountElement = dms.element(dms["base_consume"], 51)
	local attackCount = dms.atoi(resetCountElement, base_consume.vip_0_value + vipLevel) --当前vip可重置次数
	
	local count = attackCount - tonumber(_ED.three_kingdoms_reset_times)
	
	local config = zstring.split(dms.string(dms["pirates_config"], 272, pirates_config.param), ",")
	
	local txt = ""
	if count <= 0 then
		--免费次数已完,开始检查 宝石可购买数
		self.Panel_21:setVisible(false) --隐藏宝石显示
		self.Text_wuchongzhi:setVisible(true)
		self.Text_wuchongzhi:setString(tipStringInfo_trialTower[1])
		
		self.currentResetPrice = -1
	else
		--宝石花费为0时,提示为免费重置
		
		--否则提示为花宝石
		
		-- 提示可用的免费次数
		
		local nIndex = tonumber(_ED.three_kingdoms_reset_times) + 1
		
		local price = tonumber(config[nIndex])
		
		
		local freeCount = 0
		local chargeCount = 0
		for i = 1 , attackCount do
			if tonumber(config[i]) == 0 then
				freeCount = freeCount +1
			elseif tonumber(config[i]) > 0 then
				chargeCount = chargeCount +1
			end
		end
		
		-------------计算免费的可用数--------------------------------
		local myFreeCount = freeCount - tonumber(_ED.three_kingdoms_reset_times)
		
		-------------计算收费的可用数--------------------------------
		local myChargeCount =  chargeCount - tonumber(_ED.three_kingdoms_reset_times)
	
		------------------------------------------------------------
		if price == 0 then
			self.currentResetPrice = 0
			
			txt = string.format(tipStringInfo_trialTower[2], myFreeCount)
			self.Text_wuchongzhi:setString(txt)
			self.Text_wuchongzhi:setVisible(true)
		else
			self.currentResetPrice = price
			
			self.Panel_21:setVisible(true) 
			self.Text_wuchongzhi:setVisible(false)
			self.Text_25:setString(price)
			
			self.surplusResetCount = myChargeCount+1
		
		end
		
	end
	
end

--检查当前是否可重置
function TrialTower:checkupReset()
	if tonumber(_ED.three_kingdoms_view.lost_stae)  == -1 or tonumber(_ED.three_kingdoms_view.lost_stae)  == -2 then
		self:isResetTrialTower()
	else
		TipDlg.drawTextDailog(tipStringInfo_trialTower[9])
	end
end

-- 等玩家决定是否要重置确认
function TrialTower:showConfirmTipCallback(n)
	if n == 0 then
		-- yes
		self:resetTrialTower()
	else
		-- no
	end
end
	
-- 重置提醒
function TrialTower:isResetTrialTower()

	if -1 == self.currentResetPrice then
		-- 是否没有重置次数了
		--TipDlg.drawTextDailog(tipStringInfo_trialTower[1])
		TipDlg.drawTextDailog(_string_piece_info[252])
	elseif 0 == self.currentResetPrice then
		-- 是否有免费的
		
		app.load("client.utils.ConfirmTip")
		local tip = ConfirmTip:new()
		tip:init(self, self.showConfirmTipCallback, tipStringInfo_trialTower[19])
		fwin:open(tip,fwin._windows)
	
	elseif 1 < self.currentResetPrice then
		-- 是否要元宝了
		app.load("client.campaign.trialtower.TrialTowerResetNPCAttackCount")
	
		local tip = TrialTowerResetNPCAttackCount:new()
		tip:init(self.currentResetPrice, self.surplusResetCount)
		fwin:open(tip,fwin._windows)
		
	end
	
end

-- 发起重置了
function TrialTower:resetTrialTower()
	local function responseBattleInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			--已使用的免费次数+1
			--_ED.three_kingdoms_reset_times = tonumber(_ED.three_kingdoms_reset_times) 
			response.node:refresh()
		end
	end
	protocol_command.basic_consumption.param_list = "51\r\n0\r\n0"
	NetworkManager:register(protocol_command.basic_consumption.code, nil, nil, nil, self, responseBattleInitCallback, false, nil)
end


-- 显示是否有属性加成的选择
function TrialTower:showAdditionSelect()
	--检查344,如果存在属性就提示
	if nil ~= _ED.three_kingdoms_property and zstring.tonumber(_ED.three_kingdoms_view.lost_stae) ~= -2 and 
			nil ~= _ED.three_kingdoms_property.three_star and
			string.len(_ED.three_kingdoms_property.three_star) > 0
		then
		state_machine.excute("addition_Select_tower_button", 0, nil) 
    elseif zstring.tonumber(_ED.three_kingdoms_view.lost_stae) == -2 then 
        --通关后刷新
        _ED.three_kingdoms_property = {}
        state_machine.excute("trialtower_goto_next_level", 0, nil) 
	end
end


-- 更新状态 updateState
function TrialTower:init(updateState)
	self.updateState = updateState
end

function TrialTower:close( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local effect_paths = "images/ui/effice/effect_82/effect_82.ExportJson"
	    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
	    effect_paths = "images/ui/effice/effice_ui_npc_2/effice_ui_npc_2.ExportJson"
	    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(effect_paths)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
	    for i=1,3 do
    	local panelLayer = ccui.Helper:seekWidgetByName(self.csbTrialTowerJuese_root, string.format("Panel_no%d",i))
			panelLayer:removeAllChildren(true)
	    end
		cacher.destoryRefPools()
		cacher.removeAllTextures()
		cacher.cleanSystemCacher()
	end
end

function TrialTower:onExit()
	--fwin:close(fwin:find("UserTopInfoAClass"))
	state_machine.remove("trial_tower_buy_lost_treasure_complete")
	state_machine.remove("trial_tower_back_activity")
	state_machine.remove("trial_tower_reward_button")
	state_machine.remove("hero_trial_tower_button")
	state_machine.remove("arrange_trial_tower_button")
	state_machine.remove("shop_trial_tower_button")
	state_machine.remove("AttributeAddition_button")
	state_machine.remove("trial_tower_buy_updatenumber")
	state_machine.remove("trial_tower_one_key_three_star")
end

function TrialTower:onLoad( ... )
	local effect_paths = "images/ui/effice/effect_82/effect_82.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    effect_paths = "images/ui/effice/effice_ui_npc_2/effice_ui_npc_2.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
end