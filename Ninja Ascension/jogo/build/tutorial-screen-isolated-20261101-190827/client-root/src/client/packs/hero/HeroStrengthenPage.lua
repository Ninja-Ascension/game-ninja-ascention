-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将升级界面
-------------------------------------------------------------------------------------------------------
HeroStrengthenPage = class("HeroStrengthenPageClass", Window)

function HeroStrengthenPage:ctor()
    self.super:ctor()
	self.roots = {}
	self.action = nil       --本页面动画
	self.shipId = nil       --当前武将Id
	self.ship = nil			--当前武将实例
	self.needShipInfo = {}	--当前被消耗的武将参数
	self.needMoney = 0		--转化经验所需银币 getOfferOfExp(shipId)
	self.needExp = 0		--转化经验所需银币 getOfferOfExp(shipId)
	self.panel_Close = {}	--武将5个层
	self.panel_Add	= {}	--加号的五个层
	self.effice = {}		--光效的五个层
	self.power_Add  = {}	--加成属性 -- 1.等级增加  2.攻击增加  3.生命增加  4.物防增加  5.法防增加
	self.levelUpEffice = {}			-- 升级动画效果对应的层
	self.cacheFightArmatures = {}	-- 升级动画效果
	self.diffExp = 0  --差多少经验
	self.status = true
	-- self.getExp = 0
	self.isStopPropertyChange = false -- 因为要等弹出的属性变更信息,出现并消失之后才显示属性栏的数据变更,所以增加此属性,防止属性被立即更新
	self.isSure = false
	app.load("client.player.UserInformationHeroStorage")
	app.load("client.cells.ship.ship_body_cell")
	app.load("client.cells.ship.ship_icon_cell")
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		app.load("client.cells.formation.Lformation_change_hero_cell")
	end
    local function init_hero_strengthen_page_terminal()
		--自动添加
		local hero_strengthen_page_open_ex_terminal = {
            _name = "hero_strengthen_page_open_ex",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
            		if tonumber(instance.ship.ship_grade) >= tonumber(_ED.user_info.user_grade) then
            			TipDlg.drawTextDailog(_string_piece_info[90])
            			return
            		end	
            	end
				if instance.status == true then
					state_machine.excute("hero_strengthen_page_clean", 0, "hero_strengthen_page_clean.")
					self.needShipInfo = {}
					local function fnSortOfHero(a,b)
						if a._lvexp < b._lvexp then
							return true
						end
						return false
					end
					
					local function getUpdateAutoHero()
						local heroTable = {}
						for i,shipInfo in pairs(_ED.user_ship) do

							local inRosouce = false
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
								if shipInfo.inResourceFromation == true then
									inRosouce = true
								end
							end
							local captain_type = dms.int(dms["ship_mould"],shipInfo.ship_template_id,ship_mould.captain_type)
							if captain_type == 3 then 
								--宠物
								inRosouce = true
							end
							if shipInfo ~= instance.ship and inRosouce == false then
								shipInfo._lvexp = getOfferOfExp(shipInfo.ship_id)	
								table.insert(heroTable, shipInfo)
							end
						end 
						table.sort(heroTable,fnSortOfHero)
						return heroTable
					end
					
					local captainGrade = tonumber(_ED.user_info.user_grade)	--主角等级
					local AllExp = 0			--可获总经验
					local NeedExp = zstring.tonumber(_ED.user_ship[instance.shipId].grade_need_exprience) --需要多少经验
					local ship_grade = tonumber(_ED.user_ship[instance.shipId].ship_grade)				  --战船当前等级
						
					local exps = 0
					for i,v in ipairs(getUpdateAutoHero()) do
						if v ~= nil then
							local shipType = dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.ship_type)
							local shipData = dms.element(dms["ship_mould"], v.ship_template_id)
							if dms.atoi(shipData, ship_mould.captain_type) ~= 0 and (zstring.tonumber(v.formation_index) == 0) and
						(zstring.tonumber(v.little_partner_formation_index)==0) then
						
								if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
									or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
									or __lua_project_id == __lua_project_red_alert 
									then
									if shipType <= 1 or tonumber(v.ship_template_id) ==1489 or tonumber(v.ship_template_id) ==1490 or tonumber(v.ship_template_id) == 1491 then
										table.insert(instance.needShipInfo, v)
										
										instance.needMoney = instance.needMoney + getOfferOfExp(v.ship_id)
										-- 当前组已经够达到最大级,否则取最多5个
										if #instance.needShipInfo == 5 then
											break
										end	
									end	
								else
									if shipType <= 1 or tonumber(v.ship_template_id) ==1148 or tonumber(v.ship_template_id) ==1149 or tonumber(v.ship_template_id) == 1150 then
										table.insert(instance.needShipInfo, v)
										
										instance.needMoney = instance.needMoney + getOfferOfExp(v.ship_id)
										-- 当前组已经够达到最大级,否则取最多5个
										if #instance.needShipInfo == 5 then
											break
										end	
									end	
								end
							end
						end
					end
					
					if #instance.needShipInfo <= 0 then
						TipDlg.drawTextDailog(_string_piece_info[36])
						return
					end

					state_machine.excute("hero_strengthen_page_check_exp", 0, params)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--升级成功，清除操作
		local hero_strengthen_page_clean_terminal = {
            _name = "hero_strengthen_page_clean",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.needShipInfo = {}
				self.needMoney = 0
				for i = 1,5 do
					local panel = instance.panel_Close[i]
					local panel_2 = instance.panel_Add[i]
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						local child = panel:getChildByTag(1001)
						if child ~= nil then
							panel:removeChildByTag(1001)
						end
					else
						panel:removeChildByTag(1001)
					end
					panel:setVisible(false)
					panel_2:setVisible(true)
				end
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--升级
		local hero_strengthen_page_level_up_terminal = {
            _name = "hero_strengthen_page_level_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.status = false
				params._NotTipMaxLevel = true
				local function responseSellHeroCallback(response)
					_ED.baseFightingCount = calcTotalFormationFight() 
					_ED.up_streng_reduce_ship = nil
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						pushEffect(formatMusicFile("effect", 9988))
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							state_machine.excute("formation_sort_and_get_index",0,"")
						end
						if instance == nil or instance.roots == nil then
							return
						end
						--升级后要刷新觉醒界面
						if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_warship_girl_b
							or __lua_project_id == __lua_project_yugioh 
							then
								local shipInfo = fundShipWidthId(instance.shipId)
								local ship_template_id = shipInfo.ship_template_id
								local requirement = dms.int(dms["ship_mould"], ship_template_id, ship_mould.base_mould2)
								local isOpen = dms.int(dms["fun_open_condition"], 5, fun_open_condition.level) <= zstring.tonumber(shipInfo.ship_grade)
								local captain =  dms.int(dms["ship_mould"], ship_template_id, ship_mould.captain_type) == 0 
								--主角 红橙将可以觉醒
								if requirement ~= -1 or captain == true then
									if isOpen == true then 
										--刷新
										state_machine.excute("hero_awaken_page_check_updata_by_other_page",0,"")	
										state_machine.excute("hero_develop_page_strength_to_awaken",0,"")
									end
								end
						end
						--------------------------------------------------------------------------
						-- 属性改变动画效果
						instance.isStopPropertyChange = true
						instance:showPropertyChangeTipInfo()
						--------------------------------------------------------------------------
						-- 升级动画效果
						-- 动画封装
						local function cacheArmature(PanelCacheFightArmature, cacheFightArmature)
							PanelCacheFightArmature:setVisible(true)
							local function changeActionCallback(armatureBack)
								local armature = armatureBack
								if armature ~= nil and cacheFightArmature._isStop == false then
									PanelCacheFightArmature:setVisible(false)
									cacheFightArmature._isStop = true
								end
							end
							if cacheFightArmature.isInited ~= true then
								draw.initArmature(cacheFightArmature, nil, 1, nil, nil)
							end
							cacheFightArmature.isInited = true
							cacheFightArmature._isStop = false
							cacheFightArmature._invoke = nil
							cacheFightArmature._actionIndex = 0
							cacheFightArmature._nextAction = 0
							cacheFightArmature:getAnimation():playWithIndex(0)
							cacheFightArmature._invoke = changeActionCallback
						end
						-- 播放动画
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							local panel = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_12")
							local ani = panel:getChildByName("ArmatureNode_15")
							cacheArmature(panel, ani)
							playEffect(formatMusicFile("effect", 9997))
						else
							if __lua_project_id == __lua_project_warship_girl_b 
								or __lua_project_id == __lua_project_digimon_adventure 
								or __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge 
								or __lua_project_id == __lua_project_yugioh 
								then 
								for i = 1,5 do
									if instance.needShipInfo[i] ~= nil then
										cacheArmature(instance.levelUpEffice[i], instance.cacheFightArmatures[i])
										playEffect(formatMusicFile("effect", 9997))
									end
								end
							else
								for i = 1,6 do
									if i == 6 or instance.needShipInfo[i] ~= nil then
										cacheArmature(instance.levelUpEffice[i], instance.cacheFightArmatures[i])
										playEffect(formatMusicFile("effect", 9997))
									end
								end
							end
							
						end
						-- 飘信息条
						-- app.load("client.cells.utils.add_attribute_animation")
						-- local newPage = AddAttributeAnimation:createCell()
						-- newPage:init(self.power_Add, 1, cc.p( 0, 0), 1)
						-- fwin:open(newPage, fwin._view)
						
						--刷新其他页面内容
						state_machine.excute("hero_advanced_page_check_updata_by_other_page", 0, "haha")
						state_machine.excute("hero_train_page_check_updata_by_other_page", 0, "haha")
						
						--从上层列表背包移除
						state_machine.excute("hero_list_view_remove_cell", 0, instance.needShipInfo)
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							state_machine.excute("hero_icon_list_view_remove_cell", 0, instance.needShipInfo)
						end
						--上层列表项中武将信息刷新
						state_machine.excute("hero_list_view_update_cell", 0, instance.shipId)
					
						--更新用户银币信息
						state_machine.excute("user_info_hero_storage_update", 0, "user_info_hero_storage_update.")
						
						--移除材料
						state_machine.excute("hero_strengthen_page_clean", 0, "hero_strengthen_page_clean.")
						
						--更新面板
						state_machine.excute("hero_strengthen_page_check_exp", 0, params)
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							state_machine.excute("hero_develop_page_update",0,"")--刷新信息界面信息	
							if fwin:find("HeroFormationChoiceWearClass") ~= nil then
								state_machine.excute("request_choice_hero_update",0,"")
							end
						end
						instance.status = true
					end
				end
				
				local needShipInfo = {}
				local temp = ""
				for i, v in pairs(instance.needShipInfo) do
					if v ~= nil then
						local shipInfo = fundShipWidthId(v.ship_id)
						if nil ~= shipInfo then
							temp = temp .. v.ship_id .. ","
							table.insert(needShipInfo, v)
						end
					end	
				end
				
				instance.needShipInfo = needShipInfo
				
				if temp == nil or temp == "" then 
					TipDlg.drawTextDailog(_string_piece_info[35])
					instance.status = true
					return
				end
				
				local captainGrade = tonumber(_ED.user_info.user_grade)	--主角等级
				local AllExp = 0			--可获总经验
				local NeedExp = zstring.tonumber(_ED.user_ship[instance.shipId].grade_need_exprience) --需要多少经验
				local ship_grade = tonumber(_ED.user_ship[instance.shipId].ship_grade)				  --战船当前等级
				for i,v in pairs(instance.needShipInfo) do
					AllExp = AllExp + getOfferOfExp(v.ship_id)
				end
				
				for i,v in pairs(_ED.user_ship) do
					if dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.captain_type) == 0 then 
						captainGrade = tonumber(_ED.user_info.user_grade)
					end
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					--升级英雄的前端判断添加
					if tonumber(instance.needMoney) > tonumber(_ED.user_info.user_silver) then
						instance.needMoney = 0
						for i,v in pairs(instance.needShipInfo) do
							instance.needMoney = instance.needMoney + getOfferOfExp(v.ship_id)
						end
						state_machine.excute("shortcut_function_silver_to_get_open",0,1)
						return
					end		
					for i,v in pairs(instance.needShipInfo) do
						local captain_type = dms.int(dms["ship_mould"],v.ship_template_id,ship_mould.captain_type)
						local ship_type = dms.int(dms["ship_mould"],v.ship_template_id,ship_mould.ship_type)
						if tonumber(ship_type) >= 3 and tonumber(captain_type) ~= 2 and instance.isSure == false then
							app.load("client.utils.ConfirmTip")
							instance.status = true 
							local tip = ConfirmTip:new()
							tip:init(instance,instance.sureToStreng,_string_piece_info[385])
							fwin:open(tip,fwin._windows)
							return
						end
					end
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					instance.isSure = false
				end
				if ship_grade >= captainGrade and AllExp > NeedExp then
					TipDlg.drawTextDailog(_string_piece_info[62])
					instance.status = true
				else
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						instance._currentExp = zstring.tonumber(_ED.user_ship[instance.shipId].exprience)
					end					
					protocol_command.ship_escalate.param_list = "".."0".."\r\n"..instance.shipId.."\r\n"..temp
					NetworkManager:register(protocol_command.ship_escalate.code, nil, nil, nil, nil, responseSellHeroCallback, false, nil)
				end
				--刷新加成属性
				state_machine.excute("hero_strengthen_page_check_exp", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--选择被强化武将
		local hero_strengthen_page_open_been_level_up_hero_terminal = {
            _name = "hero_strengthen_page_been_level_up_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				state_machine.excute("hero_develop_page_close", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新银币经验
		local hero_strengthen_page_update_cost_terminal = {
            _name = "hero_strengthen_page_update_cost",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				-- 刷新钱币
				instance.needMoney = 0
				for i,v in pairs(instance.needShipInfo) do
					instance.needMoney = instance.needMoney + getOfferOfExp(v.ship_id)
				end
				local exprience = zstring.tonumber(_ED.user_ship[self.shipId].exprience)     			--战船当前可获经验
				local grade_need_exprience = zstring.tonumber(_ED.user_ship[self.shipId].grade_need_exprience)    	--战船升级所需经验
				local progressBar = (instance.needMoney + exprience) / grade_need_exprience * 100
				if progressBar < 0 then 
					progressBar = 0
				elseif progressBar > 100 then 
					progressBar = 100
				end
				local LoadingBar_ex = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_ex")
				LoadingBar_ex:setPercent(progressBar)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_money"):setString(instance.needMoney)
				if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
					if tonumber(instance.needMoney) > tonumber(_ED.user_info.user_silver) then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Text_money"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
					end
				else	
					if tonumber(instance.needMoney) > tonumber(_ED.user_info.user_silver) then
						ccui.Helper:seekWidgetByName(instance.roots[1], "Text_money"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
					else
						ccui.Helper:seekWidgetByName(instance.roots[1], "Text_money"):setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
					end
				end	
				ccui.Helper:seekWidgetByName(instance.roots[1], "Text_ex_1"):setString(instance.needMoney)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--接收ChooseHeroToStreng传来的数据
		local hero_strengthen_page_update_info_terminal = {
            _name = "hero_strengthen_page_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.needShipInfo = params._datas.needShipInfo
				self:onUpdateDraw()
				state_machine.excute("hero_strengthen_page_check_exp", 0, params)
				for i = 1,5 do
					--> print("quxiao*-*-*-*-*-*-*", i, self.panel_Add[i]:isVisible())
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--进入选择英雄列表
		local hero_strengthen_page_enter_choose_hero_terminal = {
            _name = "hero_strengthen_page_enter_choose_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
            		if tonumber(instance.ship.ship_grade) >= tonumber(_ED.user_info.user_grade) then
            			TipDlg.drawTextDailog(_string_piece_info[90])
            			return
            		end	
            	end            
				app.load("client.packs.hero.ChooseHeroToStreng")
				local choose_hero_to_streng = ChooseHeroToStreng:new()
				choose_hero_to_streng:init(instance.needShipInfo, instance.shipId)
				fwin:open(choose_hero_to_streng, fwin._taskbar)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--取消一个升级材料的选择
		local hero_strengthen_page_cancel_one_terminal = {
            _name = "hero_strengthen_page_cancel_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local pos = params._datas._pos
				local panel = instance.panel_Close[pos]
				panel:setVisible(false)
				local panel_2 = instance.panel_Add[pos]
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					panel = instance.panel_Close2[pos]
					local child = panel:getChildByTag(1001)
					if child ~= nil then
						panel:removeChildByTag(1001)
					end
				else
					panel:removeChildByTag(1001)
				end
				panel:setVisible(false)
				panel_2:setVisible(true)
				
				instance.needShipInfo[pos] = nil
				-- state_machine.excute("hero_strengthen_page_update_cost", 0, params)
				state_machine.excute("hero_strengthen_page_check_exp", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--判断经验值是否溢出
		local hero_strengthen_page_check_exp_terminal = {
            _name = "hero_strengthen_page_check_exp",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- 记录当前用户经验,便于提示
				instance._currentExp = zstring.tonumber(_ED.user_ship[instance.shipId].exprience)
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					state_machine.excute("formation_update_ship_info",0,"")
				end
				self.needExp = 0
				for i = 1,5 do
					if self.needShipInfo[i] ~= nil then
						self.needExp = self.needExp + getOfferOfExp(self.needShipInfo[i].ship_id)
					end
				end
				local Panel_jiachangsx = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_jiachangsx")	--下辖 下面的各个属性
				local levelUpButton = ccui.Helper:seekWidgetByName(self.roots[1], "Button_sj")
				local NeedExp = zstring.tonumber(_ED.user_ship[self.shipId].grade_need_exprience)
				local Exp = zstring.tonumber(_ED.user_ship[self.shipId].exprience)
				--> print("self.needExp", self.needExp, "NeedExp", NeedExp)
				-- if tonumber(getUpLevel(self.ship, self.needExp, 0)) + tonumber(_ED.user_ship[self.shipId].ship_grade) > tonumber(_ED.user_info.user_grade) then
					-- if self.needExp > (NeedExp - Exp) then
					if tonumber(_ED.user_ship[self.shipId].ship_grade) >= tonumber(_ED.user_info.user_grade) then
						levelUpButton:setTouchEnabled(false)
						Panel_jiachangsx:setVisible(false)
						for i = 1,5 do
							self.needShipInfo[i] = nil
						end
						
						local LoadingBar_ex = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_ex")
						local progressBar = Exp / NeedExp * 100
						if progressBar < 0 then 
							progressBar = 0
						elseif progressBar > 100 then 
							progressBar = 100
						end
						LoadingBar_ex:setPercent(progressBar)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Text_money"):setString(0)
						ccui.Helper:seekWidgetByName(instance.roots[1], "Text_ex_1"):setString(0)
						
						if params._NotTipMaxLevel ~= true then
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
							else
								TipDlg.drawTextDailog(_string_piece_info[90])
							end
						end	
					else
						levelUpButton:setTouchEnabled(true)
						state_machine.excute("hero_strengthen_page_update_cost", 0, "hero_strengthen_page_update_cost.")
						--刷新加成属性
						instance:onUpdateNewDraw()				
					end
				-- else
					-- levelUpButton:setTouchEnabled(true)
					-- state_machine.excute("hero_strengthen_page_update_cost", 0, "hero_strengthen_page_update_cost.")
					--刷新加成属性
					-- instance:onUpdateNewDraw()
				-- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--通过改变其他页面内容更新本类信息
		local hero_strengthen_page_check_updata_by_other_page_terminal = {
            _name = "hero_strengthen_page_check_updata_by_other_page",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
					cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,instance.onUpdateDraw,self)            	
        		else
        			if instance ~= nil and instance.roots ~= nil then 
        				instance:onUpdateDraw()
        			end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--收到改变属性显示动画
		local hero_strengthen_grade_change_animation_terminal = {
            _name = "hero_strengthen_grade_change_animation",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:runningGradeChangeAnimation(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--
		local hero_strengthen_grade_change_of_icon_terminal = {
            _name = "hero_strengthen_grade_change_of_icon",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
					
				if instance == nil or instance.roots[1] == nil then
					return
				end		
				for i = 1, 5 do
					-- state_machine.excute("hero_strengthen_page_cancel_one",0,{
					-- 	_datas = 
					-- 		{
					-- 			terminal_name = "hero_strengthen_page_cancel_one",
					-- 			_pos = i,
					-- 			isPressedActionEnabled = true
					-- 		}
					-- 	}
					-- 	)
					local pos = i
					local panel = instance.panel_Close[pos]
					local panel_2 = instance.panel_Add[pos]
					panel = instance.panel_Close2[pos]
					local child = panel:getChildByTag(1001)
					if child ~= nil then
						panel:removeChildByTag(1001)
					end
					panel:setVisible(false)
					panel_2:setVisible(true)
					instance.needShipInfo[pos] = nil
					state_machine.excute("hero_strengthen_page_check_exp", 0, params)
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--一键升级
		local hero_strengthen_page_one_key_terminal = {
            _name = "hero_strengthen_page_one_key",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert 
            		or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh  then
            		if tonumber(instance.ship.ship_grade) >= tonumber(_ED.user_info.user_grade) then
            			TipDlg.drawTextDailog(_string_piece_info[90])
            			return
            		end	
            	end            
		    	state_machine.lock("hero_strengthen_page_one_key")
		    	local function responseCallback( response )   		
		    		_ED.baseFightingCount = calcTotalFormationFight()	
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.unlock("hero_strengthen_page_one_key")
						pushEffect(formatMusicFile("effect", 9988))
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							state_machine.excute("formation_sort_and_get_index",0,"")
							state_machine.excute("hero_strengthen_page_clean", 0, "hero_strengthen_page_clean.")
						end
						--从上层列表背包移除
						if _ED.up_streng_reduce_ship == nil then 
							_ED.up_streng_reduce_ship = {}
						end
						if __lua_project_id == __lua_project_warship_girl_b
						  or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
						  or __lua_project_id == __lua_project_yugioh 
						  or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge
						  then 
						  --清除英雄
							state_machine.excute("hero_list_view_remove_cell", 0, _ED.up_streng_reduce_ship)
						else
							--龙虎门看需不需要修改
							state_machine.excute("hero_list_view_remove_cell", 0, instance.needShipInfo)
						end
						_ED.up_streng_reduce_ship = nil
						
						if instance == nil or instance.roots == nil then
							return
						end
						--升级后要刷新觉醒界面
						if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_warship_girl_b
							or __lua_project_id == __lua_project_yugioh 
							then
								local shipInfo = fundShipWidthId(instance.shipId)
								local ship_template_id = shipInfo.ship_template_id
								local requirement = dms.int(dms["ship_mould"], ship_template_id, ship_mould.base_mould2)
								local isOpen = dms.int(dms["fun_open_condition"], 5, fun_open_condition.level) <= zstring.tonumber(shipInfo.ship_grade)
								local captain =  dms.int(dms["ship_mould"], ship_template_id, ship_mould.captain_type) == 0 
								--主角 红橙将可以觉醒
								if requirement ~= -1 or captain == true then
									if isOpen == true then 
										--刷新
										state_machine.excute("hero_awaken_page_check_updata_by_other_page",0,"")	
										state_machine.excute("hero_develop_page_strength_to_awaken",0,"")
									end
								end
						end
						--------------------------------------------------------------------------
						-- 属性改变动画效果
						instance.isStopPropertyChange = true
						instance:showPropertyChangeTipInfo()
						
						--------------------------------------------------------------------------
						-- 升级动画效果
						-- 动画封装
						local function cacheArmature(PanelCacheFightArmature, cacheFightArmature)
							PanelCacheFightArmature:setVisible(true)
							local function changeActionCallback(armatureBack)
								local armature = armatureBack
								if armature ~= nil and cacheFightArmature._isStop == false then
									PanelCacheFightArmature:setVisible(false)
									cacheFightArmature._isStop = true
								end
							end
							if cacheFightArmature.isInited ~= true then
								draw.initArmature(cacheFightArmature, nil, 1, nil, nil)
							end
							cacheFightArmature.isInited = true
							cacheFightArmature._isStop = false
							cacheFightArmature._invoke = nil
							cacheFightArmature._actionIndex = 0
							cacheFightArmature._nextAction = 0
							cacheFightArmature:getAnimation():playWithIndex(0)
							cacheFightArmature._invoke = changeActionCallback
						end

						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							local panel = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_12")
							local ani = panel:getChildByName("ArmatureNode_15")
							cacheArmature(panel, ani)
							playEffect(formatMusicFile("effect", 9997))
						elseif __lua_project_id == __lua_project_warship_girl_b 
							or __lua_project_id == __lua_project_digimon_adventure 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_yugioh 
							then 
							for i = 1,5 do
								cacheArmature(instance.levelUpEffice[i], instance.cacheFightArmatures[i])
								playEffect(formatMusicFile("effect", 9997))
							end
						else
							for i = 1,6 do
								if i == 6 or instance.needShipInfo[i] ~= nil then
									cacheArmature(instance.levelUpEffice[i], instance.cacheFightArmatures[i])
									playEffect(formatMusicFile("effect", 9997))
								end
							end
						end
						
						--刷新其他页面内容
						state_machine.excute("hero_advanced_page_check_updata_by_other_page", 0, "haha")
						state_machine.excute("hero_train_page_check_updata_by_other_page", 0, "haha")
						--上层列表项中武将信息刷新
						state_machine.excute("hero_list_view_update_cell", 0, instance.shipId)

						--更新用户银币信息
						state_machine.excute("user_info_hero_storage_update", 0, "user_info_hero_storage_update.")
						
						--移除材料
						state_machine.excute("hero_strengthen_page_clean", 0, "hero_strengthen_page_clean.")
						
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							then
							state_machine.excute("hero_icon_listview_update_all_icon", 0, nil)
						end
						--更新面板
						state_machine.excute("hero_strengthen_page_check_exp", 0, params)
						state_machine.excute("hero_develop_page_update",0,"")--刷新信息界面信息	
						if fwin:find("HeroFormationChoiceWearClass") ~= nil then
							state_machine.excute("request_choice_hero_update",0,"")
						end
					else
		    			state_machine.unlock("hero_strengthen_page_one_key")
		    		end
	    		end
                -- print("==============强化请求",instance.ship.ship_id,instance.ship.captain_name)
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					instance._currentExp = zstring.tonumber(_ED.user_ship[instance.shipId].exprience)
				end		                
                protocol_command.ship_one_key_escalate.param_list = ""..instance.ship.ship_id
                NetworkManager:register(protocol_command.ship_one_key_escalate.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(hero_strengthen_page_open_ex_terminal)	
        state_machine.add(hero_strengthen_page_level_up_terminal)	
        state_machine.add(hero_strengthen_page_open_been_level_up_hero_terminal)	
        state_machine.add(hero_strengthen_page_open_expence_hero_terminal)	
        state_machine.add(hero_strengthen_page_clean_terminal)	
        state_machine.add(hero_strengthen_page_update_cost_terminal)	
        state_machine.add(hero_strengthen_page_update_info_terminal)	
        state_machine.add(hero_strengthen_page_enter_choose_hero_terminal)	
        state_machine.add(hero_strengthen_page_cancel_one_terminal)	
        state_machine.add(hero_strengthen_page_check_exp_terminal)	
        state_machine.add(hero_strengthen_page_check_updata_by_other_page_terminal)	
		state_machine.add(hero_strengthen_grade_change_animation_terminal)	
		state_machine.add(hero_strengthen_grade_change_of_icon_terminal)	
		state_machine.add(hero_strengthen_page_one_key_terminal)
        state_machine.init()
    end
    init_hero_strengthen_page_terminal()
end
function HeroStrengthenPage:sureToStreng(sure_number)
	if sure_number == 0 then
		self.isSure = true
		state_machine.excute("hero_strengthen_page_level_up",0,
			{
			_datas={
				terminal_name = "hero_strengthen_page_level_up", 
				shipId = self.shipId, 
				isPressedActionEnabled = true,
				}
			})
	end
end

function HeroStrengthenPage:onUpdateDrawButton( ... )
	local root = self.roots[1]
	local Button_zdtj = ccui.Helper:seekWidgetByName(root,"Button_zdtj")
	local Button_sj = ccui.Helper:seekWidgetByName(root,"Button_sj")
	local Button_sj_0 = ccui.Helper:seekWidgetByName(root,"Button_sj_0")
	if tonumber(self.ship.captain_type) == 0 then
		Button_zdtj:setBright(false)
		Button_zdtj:setTouchEnabled(false)
		Button_sj:setBright(false)
		Button_sj:setTouchEnabled(false)
		Button_sj_0:setBright(false)
		Button_sj_0:setTouchEnabled(false)
		for i= 1,5 do
			self.panel_Add[i]:setVisible(false)
			self.panel_Close[i]:setVisible(false)
		end
	else
		Button_zdtj:setBright(true)
		Button_zdtj:setTouchEnabled(true)
		Button_sj:setBright(true)
		Button_sj:setTouchEnabled(true)	
		Button_sj_0:setBright(true)
		Button_sj_0:setTouchEnabled(true)			
		for i= 1,5 do
			self.panel_Add[i]:setVisible(true)
			-- self.panel_Close[i]:setVisible(true)
		end		
	end
end
--更新界面英雄
function HeroStrengthenPage:onUpdateNewDraw()
	for i = 1,5 do
		if self.needShipInfo[i] == nil then
			local panel_3 = self.panel_Close2[i]
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
				local child = panel_3:getChildByTag(1001)
				if child ~= nil then
					panel_3:removeChildByTag(1001)
				end
			else
				panel_3:removeChildByTag(1001)
				self.effice[i]:setVisible(false)
				ccui.Helper:seekWidgetByName(self.roots[1], "Panel_shengji_d_"..i):setVisible(false)
			end
			panel_3:setVisible(false)
			self.panel_Close[i]:setVisible(false)
			self.panel_Add[i]:setVisible(true)

			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			else
				self.effice[i]:setVisible(false)
				ccui.Helper:seekWidgetByName(self.roots[1], "Panel_shengji_d_"..i):setVisible(false)
			end
		end
	end
	for i = 1,5 do
		if self.needShipInfo[i] ~= nil then
			local panel_3 = self.panel_Close2[i]
			self.panel_Close[i]:setVisible(true)
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
			else
				self.effice[i]:setVisible(true)
				ccui.Helper:seekWidgetByName(self.roots[1], "Panel_shengji_d_"..i):setVisible(true)
			end
			self.panel_Add[i]:setVisible(false)
			panel_3:setVisible(true)
			local shipCell = nil
			if __lua_project_id == __lua_project_yugioh then 
				app.load("client.cells.ship.ship_icon_cell_new")
				shipCell = ShipIconCellNew:createCell()
				shipCell:init(self.needShipInfo[i], 1, nil, self.needShipInfo, self.shipId)
			else
				shipCell = ShipIconCell:createCell()
				shipCell:init(self.needShipInfo[i], 8, nil, self.needShipInfo, self.shipId)
			end
			
			shipCell:setTag(1001)
			panel_3:removeAllChildren(true)
			panel_3:addChild(shipCell)
		end
	end

	--加成属性  包括动画  dms.atoi(shipData, ship_mould.grow_power) 
	local shipData = dms.element(dms["ship_mould"], self.ship.ship_template_id)
	self.power_Add[1] = getUpLevel(self.ship, self.needMoney, 0, _ED.user_info.user_grade)				
	self.power_Add[2] = self.power_Add[1] * dms.atoi(shipData, ship_mould.grow_power)				
	self.power_Add[3] = self.power_Add[1] * dms.atoi(shipData, ship_mould.grow_courage)				
	self.power_Add[4] = self.power_Add[1] * dms.atoi(shipData, ship_mould.grow_intellect)			
	self.power_Add[5] = self.power_Add[1] * dms.atoi(shipData, ship_mould.grow_nimable)
	
	local Panel_jiachangsx = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_jiachangsx")	--下辖 下面的各个属性
	local Text_lv_add = ccui.Helper:seekWidgetByName(self.roots[1], "Text_lv_add")	--攻击
	local Text_gongji_0_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_gongji_0_0")	--攻击
	local Text_shengming_0_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_shengming_0_0")	--生命
	local Text_wufang_0_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_wufang_0_0")	--物防
	local Text_fafang_0_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_fafang_0_0")	--法防
	
	Text_lv_add:setString("+ "..self.power_Add[1])
	Text_shengming_0_0:setString("+ "..self.power_Add[2])
	Text_gongji_0_0:setString("+ "..self.power_Add[3])
	Text_wufang_0_0:setString("+ "..self.power_Add[4])
	Text_fafang_0_0:setString("+ "..self.power_Add[5])

	if self.power_Add[1] == 0 then
		Panel_jiachangsx:setVisible(false)
	else
		Panel_jiachangsx:setVisible(true)
	end
	self.action:play("Button_zdtj_touch", true)
	
	if tonumber(self.power_Add[1]) >= tonumber(_ED.user_info.user_grade) then
		state_machine.excute("hero_develop_page_change_button", 0, "Button_shengji")
	end
end


-- 显示属性变更的提示信息
function HeroStrengthenPage:showPropertyChangeTipInfo(previousShip)
	-- 计算两次属性差

	-- previousShip = {
		-- ship_courage = pship.ship_courage,--攻击
		-- ship_health = pship.ship_health,--生命
		-- ship_intellect = pship.ship_intellect,--物防
		-- ship_quick = pship.ship_quick,--法防
	-- }

	local Text_level = ccui.Helper:seekWidgetByName(self.roots[1], "Text_lv_0")
	local Text_gongji = ccui.Helper:seekWidgetByName(self.roots[1], "Text_gongji_0")
	local Text_shengming = ccui.Helper:seekWidgetByName(self.roots[1], "Text_shengming_0")
	local Text_wufang = ccui.Helper:seekWidgetByName(self.roots[1], "Text_wufang_0")
	local Text_fafang = ccui.Helper:seekWidgetByName(self.roots[1], "Text_fafang_0")
	
	local ship_grade = _ED.user_ship[self.shipId].ship_grade     	--战船等级
	local ship_health = _ED.user_ship[self.shipId].ship_health     	--战船生命
	local ship_courage = _ED.user_ship[self.shipId].ship_courage     --战船攻击
	local ship_intellect = _ED.user_ship[self.shipId].ship_intellect --战船物防
	local ship_quick = _ED.user_ship[self.shipId].ship_quick     	--战船法防
	
	local difference_ship_grade = tonumber(ship_grade) - tonumber(Text_level:getString())
	local difference_ship_courage = tonumber(ship_courage) - tonumber(Text_gongji:getString())
	local difference_ship_health = tonumber(ship_health) - tonumber(Text_shengming:getString())
	local difference_ship_intellect = tonumber(ship_intellect) - tonumber(Text_wufang:getString())
	local difference_ship_quick = tonumber(ship_quick) - tonumber(Text_fafang:getString())
		
		
	app.load("client.cells.utils.property_change_tip_info_cell") 
	local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
	
	
	if difference_ship_grade > 0 then
		-- 升级成功
		local textData = {}
		
		--if difference_ship_health ~= 0 then
			table.insert(textData, {property = _property[1], value = difference_ship_health})
		--end
		--if difference_ship_courage ~= 0 then
			table.insert(textData, {property = _property[2], value = difference_ship_courage})
		--end
		--if difference_ship_intellect ~= 0 then
			table.insert(textData, {property = _property[3], value = difference_ship_intellect})
		--end
		--if difference_ship_quick ~= 0 then
			table.insert(textData, {property = _property[4], value = difference_ship_quick})
		--end
	
		tipInfo:init(2,tipStringInfo_hero_change_Type[2], textData)	
	else
		-- 只是增加了经验
		-- 获取战船
		if nil == self._currentExp then
			self._currentExp = 0 
		end
		local newExp = zstring.tonumber(_ED.user_ship[self.shipId].exprience)
		local difference_shipExp =  newExp- self._currentExp
		if difference_shipExp < 0 then 
			--在升级的时候，会出现负数，应该是上一级所需要的经验 + 当前经验
			difference_shipExp = self.diffExp + newExp
		end
		local textData = {}
		
		table.insert(textData, {property = -1, value = difference_shipExp})
	
		tipInfo:init(3,tipStringInfo_hero_change_Type[3], textData)
		
		self._currentExp = zstring.tonumber(_ED.user_ship[self.shipId].exprience)
		
		self.isStopPropertyChange = false
		self:onUpdateDraw()
	end
	fwin:open(tipInfo, fwin._view)
end

-- 执行跑计数的动画
function HeroStrengthenPage:runningGradeChangeAnimation(params)
	local ship_grade 	= tonumber(_ED.user_ship[self.shipId].ship_grade)     	--战船等级
	local ship_health 	= tonumber(_ED.user_ship[self.shipId].ship_health)    	--战船生命
	local ship_courage 	= tonumber(_ED.user_ship[self.shipId].ship_courage)     --战船攻击
	local ship_intellect = tonumber(_ED.user_ship[self.shipId].ship_intellect) --战船物防
	local ship_quick 	= tonumber(_ED.user_ship[self.shipId].ship_quick)     	--战船法防

	local Text_level 	= ccui.Helper:seekWidgetByName(self.roots[1], "Text_lv_0")
	local Text_gongji 	= ccui.Helper:seekWidgetByName(self.roots[1], "Text_gongji_0")
	local Text_shengming = ccui.Helper:seekWidgetByName(self.roots[1], "Text_shengming_0")
	local Text_wufang 	= ccui.Helper:seekWidgetByName(self.roots[1], "Text_wufang_0")
	local Text_fafang 	= ccui.Helper:seekWidgetByName(self.roots[1], "Text_fafang_0")
	
	local old_ship_health	= tonumber(Text_shengming:getString())--战船生命
	local old_ship_courage 	= tonumber(Text_gongji:getString()) --战船攻击
	local old_ship_intellect	= tonumber(Text_wufang:getString())--战船物防
	local old_ship_quick 	= tonumber(Text_fafang:getString())--战船法防
	
	
	if "table" == type(params) then
		old_ship_health		= ship_health - tonumber(params[1].value)--战船生命
		old_ship_courage 	= ship_courage - tonumber(params[2].value) --战船攻击
		old_ship_intellect	= ship_intellect - tonumber(params[3].value)--战船物防
		old_ship_quick 		= ship_quick - tonumber(params[4].value)--战船法防
	else
		old_ship_health		= tonumber(Text_shengming:getString())--战船生命
		old_ship_courage 	= tonumber(Text_gongji:getString()) --战船攻击
		old_ship_intellect	= tonumber(Text_wufang:getString())--战船物防
		old_ship_quick 		= tonumber(Text_fafang:getString())--战船法防
	end	

	local change_ship_courage 	= math.max(math.floor((ship_courage - old_ship_courage)*0.1), 1)
	local change_ship_health	= math.max(math.floor((ship_health - old_ship_health)*0.1), 1)
	local change_ship_intellect	= math.max(math.floor((ship_intellect - old_ship_intellect)*0.1), 1)
	local change_ship_quick 	= math.max(math.floor((ship_quick - old_ship_quick)*0.1), 1)

	--动画帧-----------------------------------------------------
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self.action:play("wj_sj_text_up", false)
	else
		self.action = csb.createTimeline("packs/HeroStorage/generals_strengthen.csb")
		self.action:play("wj_sj_text_up", false)
		self.roots[1]:runAction(self.action)
	end
	
	function addTextNum(_ship_courage, _ship_health, _ship_intellect, _ship_quick)
		Text_gongji:setString(_ship_courage)
		Text_shengming:setString(_ship_health)
		Text_wufang:setString(_ship_intellect)
		Text_fafang:setString(_ship_quick)
	end

	local findex = 1
	self.action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end
		local str = frame:getEvent()

		local ffeventName = string.format("wjsj_text_%d", findex)
		if str == "over33" then
			self.isStopPropertyChange = false
			self:onUpdateDraw()
		elseif str == ffeventName then
			if findex == 10 then
				addTextNum(ship_courage, ship_health, ship_intellect, ship_quick)
			else
				old_ship_courage 	= old_ship_courage + change_ship_courage
				old_ship_health 	= old_ship_health + change_ship_health
				old_ship_intellect 	= old_ship_intellect + change_ship_intellect
				old_ship_quick 		= old_ship_quick + change_ship_quick
				
				old_ship_courage = math.min(old_ship_courage, ship_courage)
				old_ship_health = math.min(old_ship_health, ship_health)
				old_ship_intellect = math.min(old_ship_intellect, ship_intellect)
				old_ship_quick = math.min(old_ship_quick, ship_quick)
				
				addTextNum(old_ship_courage, old_ship_health, old_ship_intellect, old_ship_quick)
				
			end
			findex = findex + 1
		end
	end)
end

function HeroStrengthenPage:onUpdateDraw()

	if true == self.isStopPropertyChange then
		return
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		-- if tonumber(_ED.user_ship[""..self.shipId].ship_grade) >= tonumber(_ED.user_info.user_grade) then
		-- 	state_machine.excute("hero_develop_page_change_button", 0, "Button_shengji")
		-- end
		self:onUpdateDrawButton()
	end
	if self == nil or self.roots[1] == nil then
		return
	end
	local rankLevelFront = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.initial_rank_level)
	local ship_name = self.ship.captain_name.." +"..rankLevelFront	--战船名称
	local ship_grade = _ED.user_ship[self.shipId].ship_grade     	--战船等级
	local ship_health = _ED.user_ship[self.shipId].ship_health     	--战船生命
	local ship_courage = _ED.user_ship[self.shipId].ship_courage     --战船攻击
	local ship_intellect = _ED.user_ship[self.shipId].ship_intellect --战船物防
	local ship_quick = _ED.user_ship[self.shipId].ship_quick     	--战船法防
	local exprience = zstring.tonumber(_ED.user_ship[self.shipId].exprience)     						--战船当前可获经验
	local grade_need_exprience = zstring.tonumber(_ED.user_ship[self.shipId].grade_need_exprience)    	--战船升级所需经验
	self.diffExp  = grade_need_exprience - exprience
	local progressBar = (exprience / grade_need_exprience) * 100
	if progressBar < 0 then 
		progressBar = 0
	elseif progressBar > 100 then 
		progressBar = 100
	end
	
	local Text_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_upgrade_name")
	local Text_level = ccui.Helper:seekWidgetByName(self.roots[1], "Text_lv_0")
	local Text_gongji = ccui.Helper:seekWidgetByName(self.roots[1], "Text_gongji_0")
	local Text_shengming = ccui.Helper:seekWidgetByName(self.roots[1], "Text_shengming_0")
	local Text_wufang = ccui.Helper:seekWidgetByName(self.roots[1], "Text_wufang_0")
	local Text_fafang = ccui.Helper:seekWidgetByName(self.roots[1], "Text_fafang_0")
	local Panel_wujiang_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_hero_110")
	local Text_money = ccui.Helper:seekWidgetByName(self.roots[1], "Text_money")
	local LoadingBar_2 = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_2")
	local Text_ex_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_ex_1")
	
	if __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		then 
		Panel_wujiang_1:removeAllChildren(true)
		Panel_wujiang_1:setTouchEnabled(false)
	end
	local ship_type = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type) + 1
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type][1], tipStringInfo_quality_color_Type[ship_type][2], tipStringInfo_quality_color_Type[ship_type][3]))
		Text_name:setString(ship_name)
	end
	Text_level:setString(ship_grade)
	Text_gongji:setString(ship_courage)
	Text_shengming:setString(ship_health)
	Text_wufang:setString(ship_intellect)
	Text_fafang:setString(ship_quick)
	Text_money:setString(self.needMoney)
	if __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		then
		if tonumber(self.needMoney) > tonumber(_ED.user_info.user_silver) then
			Text_money:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
		end
	else
		if tonumber(self.needMoney) > tonumber(_ED.user_info.user_silver) then
			Text_money:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
		else
			Text_money:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
		end
	end
	LoadingBar_2:setPercent(progressBar)
	Text_ex_1:setString(self.needMoney)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		-- local shipCell = LformationChangeHeroCell:createCell()
		-- shipCell:init(_ED.user_ship[""..self.shipId])
		-- Panel_wujiang_1:removeAllChildren(true)
		-- Panel_wujiang_1:addChild(shipCell)
	else
		local shipCell = ShipBodyCell:createCell()
		shipCell:init(_ED.user_ship[""..self.shipId], 0)
		Panel_wujiang_1:addChild(shipCell)
	end
	
	

	-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	-- 	local quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type)
	-- 	local lv =ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_lv")
	-- 	local lan=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_lan")
	-- 	local zi=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_zi")
	-- 	local cheng=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_cheng")
	-- 	local hong=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_hong")
	-- 	if quality == 0 then
	-- 		--print("白色")
	-- 		lv:setVisible(false)
	-- 		lan:setVisible(false)
	-- 		zi:setVisible(false)
	-- 		cheng:setVisible(false)
	-- 		hong:setVisible(false)
	-- 	elseif quality == 1 then
	-- 		--print("绿色")
	-- 		lv:setVisible(true)
	-- 		lan:setVisible(false)
	-- 		zi:setVisible(false)
	-- 		cheng:setVisible(false)
	-- 		hong:setVisible(false)
	-- 	elseif quality == 2 then
	-- 		--print("蓝色")
	-- 		lv:setVisible(false)
	-- 		lan:setVisible(true)
	-- 		zi:setVisible(false)
	-- 		cheng:setVisible(false)
	-- 		hong:setVisible(false)
	-- 	elseif quality == 3 then
	-- 		--print("紫色")
	-- 		lv:setVisible(false)
	-- 		lan:setVisible(false)
	-- 		zi:setVisible(true)
	-- 		cheng:setVisible(false)
	-- 		hong:setVisible(false)
	-- 	elseif quality == 4 then
	-- 		--print("橙色")
	-- 		lv:setVisible(false)
	-- 		lan:setVisible(false)
	-- 		zi:setVisible(false)
	-- 		cheng:setVisible(true)
	-- 		hong:setVisible(false)
	-- 	elseif quality == 5 then
	-- 		--print("红色")
	-- 		lv:setVisible(false)
	-- 		lan:setVisible(false)
	-- 		zi:setVisible(false)
	-- 		cheng:setVisible(false)
	-- 		hong:setVisible(true)			
	-- 	end
	-- end
	
end
function HeroStrengthenPage:playShow( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self.action:play("window_open",false)	
	end
end
function HeroStrengthenPage:onEnterTransitionFinish()
	-- if __lua_project_id == __lua_project_gragon_tiger_gate
	-- 	or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
	-- 	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	-- 	or __lua_project_id == __lua_project_red_alert 
	-- 	then
	--     local effect_paths = "images/ui/effice/effect_16/effect_16.ExportJson"
	--     ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)	
	-- end
	local csbGeneralsQianghua = csb.createNode("packs/HeroStorage/generals_strengthen.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)
    if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if fwin:find("UserInformationHeroStorageClass") == nil then
			fwin:open(UserInformationHeroStorage:new(),fwin._ui)
		else
			fwin:close(fwin:find("UserInformationHeroStorageClass"))
			fwin:open(UserInformationHeroStorage:new(),fwin._ui)
		end
	end
	if self.types == "formation" then
		app.load("client.player.UserInformationHeroStorage")
		local seq = fwin:find("UserInformationHeroStorageClass")
		if seq == nil then
			fwin:open(UserInformationHeroStorage:new(), fwin._ui)
		end
		state_machine.excute("formation_property_change_before", 0, "formation_property_change_before.")
	end
	
	if fwin:find("UserInformationHeroStorageClass") == nil then
		if fwin:find("HeroFormationChoiceWearClass") ~= nil then
			fwin:open(UserInformationHeroStorage:new(), fwin._ui)
		end
	end
	self.action = csb.createTimeline("packs/HeroStorage/generals_strengthen.csb")
	self.action:play("window_open", false)
    root:runAction(self.action)
	-- 另外一个动画 经验条的闪烁
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self.action:play("loadingbar_exp", true)
	else
		local action = csb.createTimeline("packs/HeroStorage/generals_strengthen.csb")
		action:play("loadingbar_exp", true)
	    root:runAction(action)
	end
    self.action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "over" then
			self.action:play("window_add", true)
        end
    end)
	
	self.panel_Close = 
	{
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang_2"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang_3"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang_4"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang_5"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang_6")
	}
	self.panel_Close2 = 
	{
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_hero_02"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_hero_03"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_hero_04"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_hero_05"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_hero_06")
	}
	
	self.panel_Add = 
	{
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang_7"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang_8"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang_9"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang_10"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang_11")
	}
		
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		self.effice = 
		{
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_shengji_d_1"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_shengji_d_2"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_shengji_d_3"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_shengji_d_4"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_shengji_d_5"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_shengji_d_6")
		}

		self.levelUpEffice = 
		{
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_up_1"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_up_2"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_up_3"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_up_4"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_up_5"),
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_12")
		}
		
		self.cacheFightArmatures = 
		{
			self.levelUpEffice[1]:getChildByName("ArmatureNode_2"),
			self.levelUpEffice[2]:getChildByName("ArmatureNode_5"),
			self.levelUpEffice[3]:getChildByName("ArmatureNode_8"),
			self.levelUpEffice[4]:getChildByName("ArmatureNode_13"),
			self.levelUpEffice[5]:getChildByName("ArmatureNode_14"),
			self.levelUpEffice[6]:getChildByName("ArmatureNode_15"),
		}
	end
	
    if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,self.onUpdateDraw,self)
		self:onUpdateDraw()
    else
    	self:onUpdateDraw()
    end
	
	--逻辑控制 Button_zdtj
	local Button_zdtj = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_zdtj"), nil, 
	{
		terminal_name = "hero_strengthen_page_open_ex", 
		root = self.roots[1], 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	local Button_sj = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_sj"), nil, 
	{
		terminal_name = "hero_strengthen_page_level_up", 
		shipId = self.shipId, 
		isPressedActionEnabled = true
	},
	nil, 0)
	
	local Panel_wujiang_1 = fwin:addTouchEventListener(self.panel_Add[1], nil, 
	{
		terminal_name = "hero_strengthen_page_enter_choose_hero", 
		_ships = self.needShipInfo, 
		touch_scale = true
	}, 
	nil, 0)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or 
		__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		local Button_sj_0 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_sj_0"), nil, 
		{
			terminal_name = "hero_strengthen_page_one_key", 
			shipId = self.shipId, 
			isPressedActionEnabled = true
		},
		nil, 0)
	end
	local Panel_wujiang_2 = fwin:addTouchEventListener(self.panel_Add[2], nil, 
	{
		terminal_name = "hero_strengthen_page_enter_choose_hero", 
		_ships = self.needShipInfo, 
		touch_scale = true
	}, 
	nil, 0)
	
	local Panel_wujiang_3 = fwin:addTouchEventListener(self.panel_Add[3], nil, 
	{
		terminal_name = "hero_strengthen_page_enter_choose_hero", 
		_ships = self.needShipInfo, 
		touch_scale = true
	}, 
	nil, 0)
	
	local Panel_wujiang_4 = fwin:addTouchEventListener(self.panel_Add[4], nil, 
	{
		terminal_name = "hero_strengthen_page_enter_choose_hero", 
		_ships = self.needShipInfo, 
		touch_scale = true
	}, 
	nil, 0)
	
	local Panel_wujiang_5 = fwin:addTouchEventListener(self.panel_Add[5], nil, 
	{
		terminal_name = "hero_strengthen_page_enter_choose_hero", 
		_ships = self.needShipInfo, 
		touch_scale = true
	}, 
	nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang_1"), nil, 
	{
		terminal_name = "hero_strengthen_page_been_level_up_hero", 
		_ships = self.needShipInfo, 
		touch_scale = true
	}, 
	nil, 0)
	
	-- "X"
	for i = 1, 5 do
		fwin:addTouchEventListener(self.panel_Close[i]:getChildByName(string.format("Button_wujiang_%d", 1+i)), nil, 
		{
			terminal_name = "hero_strengthen_page_cancel_one", 
			_pos = i, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		-- if tonumber(_ED.user_ship[""..self.shipId].ship_grade) >= tonumber(_ED.user_info.user_grade) then
		-- 	state_machine.excute("hero_develop_page_change_button", 0, "Button_shengji")
		-- end
	end
end
function HeroStrengthenPage:close()	
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		local Panel_wujiang_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_hero_110")
		if Panel_wujiang_1 ~= nil then
			Panel_wujiang_1:removeAllChildren(true)		
		end
		-- for i = 1,5 do
		-- 	local panel_3 = self.panel_Close2[i]
		-- 	panel_3:removeAllChildren(true)
		-- end
		cacher.destoryRefPools()
		cacher.removeAllTextures()
		cacher.cleanSystemCacher()
	end
end
function HeroStrengthenPage:onExit()
	state_machine.remove("hero_strengthen_page_open_ex")
	state_machine.remove("hero_strengthen_page_level_up")
	state_machine.remove("hero_strengthen_page_been_level_up_hero")
	state_machine.remove("hero_strengthen_page_clean")
	state_machine.remove("hero_strengthen_page_update_cost")
	state_machine.remove("hero_strengthen_page_update_info")
	state_machine.remove("hero_strengthen_page_enter_choose_hero")
	state_machine.remove("hero_strengthen_page_cancel_one")
	state_machine.remove("hero_strengthen_page_check_exp")
	state_machine.remove("hero_strengthen_page_check_updata_by_other_page")
	state_machine.remove("hero_strengthen_grade_change_animation")
	state_machine.remove("hero_strengthen_grade_change_of_icon")
	state_machine.remove("hero_strengthen_page_one_key")
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		if self.types == "formation" then
			local seq = fwin:find("UserInformationHeroStorageClass")
			if seq ~= nil then
				fwin:close(seq)
			end
			
		end
		if fwin:find("UserInformationHeroStorageClass") ~= nil then
			if fwin:find("HeroFormationChoiceWearClass") ~= nil then
				fwin:close(fwin:find("UserInformationHeroStorageClass"))
			end
		end
	end
end

function HeroStrengthenPage:init(shipId,types)
	self.shipId = shipId
	self.ship 	= fundShipWidthId(self.shipId) 
	self.types = types
	--> print("floor~~~~~~~~~~~~~~~~~~~~~~~~",math.floor(0.1))
end
