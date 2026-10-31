-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将培养界面
-------------------------------------------------------------------------------------------------------
HeroTrainPage = class("HeroTrainPageClass", Window)
HeroTrainPage.__userHeroFontName = nil
function HeroTrainPage:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.shipId = 0        --当前武将Id
	self.ship = {}		--当前武将参数
	self.affirm = {}       --培养选项图
	self.affirmChoose = 1	--培养默认选择培养方式一
	self.timesChoose = 0    --培养默认选择次数  0：一次			1：五次			2：十次
	self.initDatas = false	--用户信息是否初始化
	self.action = {}
	self.user_dan = nil 				--用户培养丹
	
	self.ship_add_max = {}			--加成属性上限    	1：生命	2：攻击	3：物防	4：法防
	self.ship_add_max[1] = 0			
	self.ship_add_max[2] = 0			
	self.ship_add_max[3] = 0			
	self.ship_add_max[4] = 0			
	
	self.ship_has_added = {}			--已加成的属性
	self.ship_has_added[1] = 0			--
	self.ship_has_added[2] = 0			--
	self.ship_has_added[3] = 0			--
	self.ship_has_added[4] = 0			--
	
	self.ship_will_change = {}			-- 可以加成的属性    	
	self.ship_will_change[1] = 0
	self.ship_will_change[2] = 0
	self.ship_will_change[3] = 0
	self.ship_will_change[4] = 0
	
	self.button_train = {}			--1:培养按钮	2:替换按钮      3替换按钮
	self.cultivate_property_id = nil --培养参数
	self.types = nil
	self.status = false
	app.load("client.cells.ship.ship_body_cell")
	app.load("client.packs.hero.HeroTrainVipPage")
    local function init_hero_train_page_terminal()
		--选择丹药个数
		local hero_train_page_chooes_danyao_terminal = {
            _name = "hero_train_page_chooes_danyao",
            _init = function (terminal)
				terminal._state = 1
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				for i,v in pairs(instance.affirm) do
					v:setVisible(false)
				end
				instance.affirm[terminal._state]:setVisible(true)
				instance.affirmChoose = terminal._state
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--培养武将按钮
		local hero_train_page_chooes_train_terminal = {
            _name = "hero_train_page_chooes_train",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseTrainHeroCallback(response)
					if (__lua_project_id == __lua_project_warship_girl_a 
						or __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_digimon_adventure 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh) 
						and params.status ~= nil 
						then
						state_machine.excute("use_diamond_confirm_tip_close",0,"")
					end
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							state_machine.excute("formation_update_ship_info",0,"")
						end
						if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then 
							return
						end
						response.node:onUpdateCultivateStartDraw()
						response.node:onUpdateDraw()
						local one = tonumber(response.node.ship_will_change[1])					--生命培养可增加值
						local two = tonumber(response.node.ship_will_change[2])				--攻击培养可增加值
						local three = tonumber(response.node.ship_will_change[3])		--物防培养可增加值
						local four = tonumber(response.node.ship_will_change[4])		--法防培养可增加值
						local numbert = one ~= two ~= four ~= three ~= 0
						if one >= 0 and two >= 0 and three>= 0 and four >= 0 and numbert then
							response.node.button_train[3]:setVisible(true)
							response.node.button_train[2]:setVisible(false)
							
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								or __lua_project_id == __lua_project_legendary_game 
								then
								response.node.button_train[1]:setPosition(response.node.button_train[1]._center_position)
								response.node.button_train[3]:setPosition(response.node.button_train[3]._center_position)
							end

							fwin:addTouchEventListener(response.node.button_train[3], nil, 
							{
								terminal_name = "hero_train_page_change_train", 
								terminal_state = 0, 
								isPressedActionEnabled = true
							}, 
							nil, 0)
						else
							response.node.button_train[2]:setVisible(true)
							response.node.button_train[3]:setVisible(false)
							
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								or __lua_project_id == __lua_project_legendary_game 
								then
								response.node.button_train[1]:setPosition(response.node.button_train[1]._start_position)
								response.node.button_train[3]:setPosition(response.node.button_train[3]._start_position)
							end
							
							fwin:addTouchEventListener(response.node.button_train[2], nil, 
							{
								terminal_name = "hero_train_page_change_train", 
								terminal_state = 0, 
								isPressedActionEnabled = true
							}, 
							nil, 0)
						end
					end
				end
				local timesChoose = self.timesChoose * 5  --培养次数
				if timesChoose == 0 then timesChoose = 1 end
				local needTrainCount = 0 			--需要的培养丹
				local needGold = 0					--需要的元宝
				local needSilver = 0				--需要的银币
				local sivler =  dms.int(dms["cultivate_require_param"],2, cultivate_require_param.need_silver)
				local gold = dms.int(dms["cultivate_require_param"],3, cultivate_require_param.need_gold)
				if self.affirmChoose == 1 then
					needTrainCount = timesChoose * 5
				elseif self.affirmChoose == 2 then
					needTrainCount = timesChoose * 4
					needSilver = timesChoose * sivler
				elseif self.affirmChoose == 3 then
					needTrainCount = timesChoose * 3
					needGold = timesChoose * gold
				end
				if tonumber(self.ship_has_added[1]) == tonumber(self.ship_add_max[1]) and tonumber(self.ship_has_added[2]) == tonumber(self.ship_add_max[2]) and
					tonumber(self.ship_has_added[3]) == tonumber(self.ship_add_max[3]) and tonumber(self.ship_has_added[4]) == tonumber(self.ship_add_max[4]) then
					TipDlg.drawTextDailog(_string_piece_info[348])
					return true
				end
				
				if tonumber(self.user_dan.prop_number) < needTrainCount then
					app.load("client.packs.hero.HeroPatchInformationPageGetWay")
					local cell = HeroPatchInformationPageGetWay:createCell()
					cell:init(zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param),",")[9], 2)
					fwin:open(cell, fwin._windows)
					return true
				elseif tonumber(_ED.user_info.user_silver) < needSilver then
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						state_machine.excute("shortcut_function_silver_to_get_open",0,1)
					else	
						TipDlg.drawTextDailog(_string_piece_info[127])
					end
					return true
				elseif tonumber(_ED.user_info.user_gold) < needGold then
					TipDlg.drawTextDailog(_string_piece_info[128])
					return true
				else
					if (__lua_project_id == __lua_project_warship_girl_a 
						or __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_digimon_adventure 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh) 
						and ___is_open_diamond_confirm == true 
						and zstring.tonumber(needGold) > 0 
						and params.status == nil 
						then
						app.load("client.utils.UseDiamondConfirmTip")
						local window_terminal = state_machine.find("use_diamond_confirm_tip_open")
		            	if window_terminal.unopen ~= true then
		            		local str1 = string.format(tipStringInfo_use_diamond[1],needGold)
		            		local str2 = tipStringInfo_use_diamond[7]
		            		state_machine.excute("use_diamond_confirm_tip_open", 0, {_datas={instance,nil,str1.."|"..str2 ,params}})
		            		return
		            	else
		            		protocol_command.cultivate_start.param_list = ""..instance.shipId.."\r\n"..instance.affirmChoose.."\r\n"..instance.timesChoose
							NetworkManager:register(protocol_command.cultivate_start.code, nil, nil, nil, instance, responseTrainHeroCallback, false, nil)
					    end
					else
						protocol_command.cultivate_start.param_list = ""..instance.shipId.."\r\n"..instance.affirmChoose.."\r\n"..instance.timesChoose
						NetworkManager:register(protocol_command.cultivate_start.code, nil, nil, nil, instance, responseTrainHeroCallback, false, nil)
					end

					-- protocol_command.cultivate_start.param_list = ""..instance.shipId.."\r\n"..instance.affirmChoose.."\r\n"..instance.timesChoose
					-- NetworkManager:register(protocol_command.cultivate_start.code, nil, nil, nil, instance, responseTrainHeroCallback, false, nil)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--点击替换
		local hero_train_page_change_train_terminal = {
            _name = "hero_train_page_change_train",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseCultivateReplaceCallback(response)
					_ED.baseFightingCount = calcTotalFormationFight()
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						for i = 1, 4 do
							if tonumber(self.ship_will_change[i]) ~= 0 then
								local animation = self.action[i]:getAnimation()
								animation:playWithIndex(0, 0, 0)
								
								if true == getVersionsIsAB2002() then
									playEffectForFoster()
								else
									playEffect(formatMusicFile("effect", 9991))
								end
							end

						end
						instance:onUpdateCultivateReplaceDraw()
						instance:onUpdateDraw()
						self.button_train[2]:setVisible(false)
						self.button_train[3]:setVisible(false)
						
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							or __lua_project_id == __lua_project_legendary_game 
							then
							self.button_train[1]:setPosition(self.button_train[1]._center_position)
							self.button_train[3]:setPosition(self.button_train[3]._center_position)
							state_machine.excute("hero_develop_page_update",0,"")
						end
						state_machine.excute("hero_strengthen_page_check_updata_by_other_page", 0, "haha")
						state_machine.excute("hero_advanced_page_check_updata_by_other_page", 0, false)
					end
				end

				protocol_command.cultivate_replace.param_list = ""..instance.shipId
				NetworkManager:register(protocol_command.cultivate_replace.code, nil, nil, nil, nil, responseCultivateReplaceCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--点击一次消耗培养丹个数
		local hero_train_page_chooes_times_terminal = {
            _name = "hero_train_page_chooes_times",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cost_arg = {}
				local cost_silver = {}
				local cost_gold = {}
				for i=1, #dms["cultivate_require_param"] do
					cost_arg[i] = dms.int(dms["cultivate_require_param"], i, cultivate_require_param.need_prop_count)
					cost_silver[i] = dms.int(dms["cultivate_require_param"], i, cultivate_require_param.need_silver)
					cost_gold[i] = dms.int(dms["cultivate_require_param"], i, cultivate_require_param.need_gold)
				end
			
				if terminal._state == 1 then
					fwin:open(HeroTrainVipPage:new(), fwin._windows)
				elseif terminal._state == 2 then
					local Text_cishu = ccui.Helper:seekWidgetByName(self.roots[1], "Text_cishu")
					local vipTimes = params._datas.vipTimes
					instance.timesChoose = vipTimes
					local text_cost_prop1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_33_1")
					local text_cost_prop2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_33_0_1")
					local text_cost_prop3 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_33_0_0_0")
					local text_cost_silver = ccui.Helper:seekWidgetByName(self.roots[1],"Text_33_0_1_0") --培养金钱
					local text_cost_gold = ccui.Helper:seekWidgetByName(self.roots[1],"Text_33_0_0_0_0") --培养钻石
					if vipTimes == 0 then
						Text_cishu:setString(_string_piece_info[142]) -- 1
						text_cost_prop1:setString(cost_arg[1])
						text_cost_prop2:setString(cost_arg[2])
						text_cost_prop3:setString(cost_arg[3])
						text_cost_silver:setString(cost_silver[2])
						text_cost_gold:setString(cost_gold[3])
					elseif vipTimes == 1 then
						Text_cishu:setString(_string_piece_info[143]) -- 5
						text_cost_prop1:setString(cost_arg[1]*5)
						text_cost_prop2:setString(cost_arg[2]*5)
						text_cost_prop3:setString(cost_arg[3]*5)
						text_cost_silver:setString(cost_silver[2]*5)
						text_cost_gold:setString(cost_gold[3]*5)
					elseif vipTimes == 2 then
						Text_cishu:setString(_string_piece_info[144]) -- 10
						text_cost_prop1:setString(cost_arg[1]*10)
						text_cost_prop2:setString(cost_arg[2]*10)
						text_cost_prop3:setString(cost_arg[3]*10)
						text_cost_silver:setString(cost_silver[2]*10)
						text_cost_gold:setString(cost_gold[3]*10)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--选择被培养的武将
		local hero_train_page_chooes_hero_terminal = {
            _name = "hero_train_page_chooes_hero",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新
		local hero_train_page_check_updata_by_other_page_terminal = {
            _name = "hero_train_page_check_updata_by_other_page",
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
		
		state_machine.add(hero_train_page_chooes_danyao_terminal)
		state_machine.add(hero_train_page_chooes_train_terminal)
		state_machine.add(hero_train_page_change_train_terminal)
		state_machine.add(hero_train_page_chooes_times_terminal)
		state_machine.add(hero_train_page_chooes_hero_terminal)
		state_machine.add(hero_train_page_check_updata_by_other_page_terminal)
        state_machine.init()
    end
    init_hero_train_page_terminal()
end

--	培养开始接收的协议信息
function HeroTrainPage:onUpdateCultivateStartDraw()
	self.ship_will_change[1] = _ED.hero_train_info[self.shipId].hero_attribute[1][3]
	self.ship_will_change[2] = _ED.hero_train_info[self.shipId].hero_attribute[2][3]
	self.ship_will_change[3] = _ED.hero_train_info[self.shipId].hero_attribute[3][3]
	self.ship_will_change[4] = _ED.hero_train_info[self.shipId].hero_attribute[4][3]
end

--	培养替换接收的协议信息替换
function HeroTrainPage:onUpdateCultivateReplaceDraw()
	_ED.hero_train_info[self.shipId].hero_attribute[1][3] = 0
	_ED.hero_train_info[self.shipId].hero_attribute[2][3] = 0
	_ED.hero_train_info[self.shipId].hero_attribute[3][3] = 0
	_ED.hero_train_info[self.shipId].hero_attribute[4][3] = 0
	
	-- _ED.hero_train_info[self.shipId].hero_attribute[1][2] = tonumber(_ED.hero_train_info[self.shipId].hero_attribute[1][2]) + tonumber(self.ship_will_change[1])
	-- _ED.hero_train_info[self.shipId].hero_attribute[2][2] = tonumber(_ED.hero_train_info[self.shipId].hero_attribute[2][2]) + tonumber(self.ship_will_change[2])
	-- _ED.hero_train_info[self.shipId].hero_attribute[3][2] = tonumber(_ED.hero_train_info[self.shipId].hero_attribute[3][2]) + tonumber(self.ship_will_change[3])
	-- _ED.hero_train_info[self.shipId].hero_attribute[4][2] = tonumber(_ED.hero_train_info[self.shipId].hero_attribute[4][2]) + tonumber(self.ship_will_change[4]) 

	self.ship_has_added[1] = _ED.hero_train_info[self.shipId].hero_attribute[1][2]
	self.ship_has_added[2] = _ED.hero_train_info[self.shipId].hero_attribute[2][2]
	self.ship_has_added[3] = _ED.hero_train_info[self.shipId].hero_attribute[3][2]
	self.ship_has_added[4] = _ED.hero_train_info[self.shipId].hero_attribute[4][2]
	
	self.ship.ship_train_info.train_life = self.ship_has_added[1]					--生命培养已增加值
	self.ship.ship_train_info.train_attack = self.ship_has_added[2]					--攻击培养已增加值
	self.ship.ship_train_info.train_physical_defence = self.ship_has_added[3]		--物防培养已增加值
	self.ship.ship_train_info.train_skill_defence = self.ship_has_added[4]			--法防培养已增加值

	self.ship_will_change[1] = 0
	self.ship_will_change[2] = 0
	self.ship_will_change[3] = 0
	self.ship_will_change[4] = 0
end

function HeroTrainPage:onUpdateDraw()
	local configParam =dms.string(dms["pirates_config"], 273, pirates_config.param)
	local paramInfo = zstring.split(configParam,",")
	for i,v in pairs(_ED.user_prop) do
		if tonumber(v.user_prop_template) == tonumber(paramInfo[9]) then
			self.user_dan = v 				--用户培养丹
		end
	end

	if	self.user_dan == nil then
		self.user_dan = {}
		self.user_dan.prop_number = 0
	end
	
	self.cultivate_property_id = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.cultivate_property_id)
	self.ship_add_max[1] = dms.int(dms["cultivate_property_param"], self.cultivate_property_id, cultivate_property_param.max_life)					--生命培养上限
	self.ship_add_max[2] = dms.int(dms["cultivate_property_param"], self.cultivate_property_id, cultivate_property_param.max_attack)				--攻击培养上限
	self.ship_add_max[3] = dms.int(dms["cultivate_property_param"], self.cultivate_property_id, cultivate_property_param.max_physical_defence)		--物防培养上限
	self.ship_add_max[4] = dms.int(dms["cultivate_property_param"], self.cultivate_property_id, cultivate_property_param.max_skill_defence)			--法防培养上限
	--金钱显示不正确
	local Text_33_0_1_0 = ccui.Helper:seekWidgetByName(self.roots[1],"Text_33_0_1_0") --培养金钱
	local Text_33_0_0_0_0 = ccui.Helper:seekWidgetByName(self.roots[1],"Text_33_0_0_0_0") --培养钻石
	local sivler =  dms.int(dms["cultivate_require_param"],2, cultivate_require_param.need_silver)
	local gold = dms.int(dms["cultivate_require_param"],3, cultivate_require_param.need_gold)
	Text_33_0_1_0:setString(sivler)
	Text_33_0_0_0_0:setString(gold)
	--金钱显示不正确

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		local cost_arg = {}
		local cost_silver = {}
		local cost_gold = {}
		for i=1, #dms["cultivate_require_param"] do
			cost_arg[i] = dms.int(dms["cultivate_require_param"], i, cultivate_require_param.need_prop_count)
			cost_silver[i] = dms.int(dms["cultivate_require_param"], i, cultivate_require_param.need_silver)
			cost_gold[i] = dms.int(dms["cultivate_require_param"], i, cultivate_require_param.need_gold)
		end
		local text_cost_prop1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_33_1")
		local text_cost_prop2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_33_0_1")
		local text_cost_prop3 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_33_0_0_0")
		local text_cost_silver = ccui.Helper:seekWidgetByName(self.roots[1],"Text_33_0_1_0") --培养金钱
		local text_cost_gold = ccui.Helper:seekWidgetByName(self.roots[1],"Text_33_0_0_0_0") --培养钻石
		if self.timesChoose == 0 then
			text_cost_prop1:setString(cost_arg[1])
			text_cost_prop2:setString(cost_arg[2])
			text_cost_prop3:setString(cost_arg[3])
			text_cost_silver:setString(cost_silver[2])
			text_cost_gold:setString(cost_gold[3])
		elseif self.timesChoose == 1 then
			text_cost_prop1:setString(cost_arg[1]*5)
			text_cost_prop2:setString(cost_arg[2]*5)
			text_cost_prop3:setString(cost_arg[3]*5)
			text_cost_silver:setString(cost_silver[2]*5)
			text_cost_gold:setString(cost_gold[3]*5)
		elseif self.timesChoose == 2 then
			text_cost_prop1:setString(cost_arg[1]*10)
			text_cost_prop2:setString(cost_arg[2]*10)
			text_cost_prop3:setString(cost_arg[3]*10)
			text_cost_silver:setString(cost_silver[2]*10)
			text_cost_gold:setString(cost_gold[3]*10)
		end
	end
	if self.initDatas ~= true then 
		self.ship_has_added[1] = self.ship.ship_train_info.train_life					--生命培养已增加值
		self.ship_has_added[2] = self.ship.ship_train_info.train_attack					--攻击培养已增加值
		self.ship_has_added[3] = self.ship.ship_train_info.train_physical_defence		--物防培养已增加值
		self.ship_has_added[4] = self.ship.ship_train_info.train_skill_defence			--法防培养已增加值
		if _ED.hero_train_info[self.shipId] == nil then 
			self.ship_will_change[1] = tonumber(self.ship.ship_train_info.train_life_temp)					--生命培养可增加值
			self.ship_will_change[2] = tonumber(self.ship.ship_train_info.train_attack_temp)				--攻击培养可增加值
			self.ship_will_change[3] = tonumber(self.ship.ship_train_info.train_physical_defence_temp)		--物防培养可增加值
			self.ship_will_change[4] = tonumber(self.ship.ship_train_info.train_skill_defence_temp)		--法防培养可增加值
		else
			self.ship_will_change[1] = tonumber(_ED.hero_train_info[self.shipId].hero_attribute[1][3])					--生命培养可增加值
			self.ship_will_change[2] = tonumber(_ED.hero_train_info[self.shipId].hero_attribute[2][3])					--攻击培养可增加值
			self.ship_will_change[3] = tonumber(_ED.hero_train_info[self.shipId].hero_attribute[3][3])					--物防培养可增加值
			self.ship_will_change[4] = tonumber(_ED.hero_train_info[self.shipId].hero_attribute[4][3])					--法防培养可增加值
		end
		local one = tonumber(self.ship_will_change[1])					--生命培养可增加值
		local two = tonumber(self.ship_will_change[2])				--攻击培养可增加值
		local three = tonumber(self.ship_will_change[3])		--物防培养可增加值
		local four = tonumber(self.ship_will_change[4])		--法防培养可增加值
		local numbert = true
		local allzero = false
		if one == 0 and two == 0 and three == 0 and four == 0 then
			numbert = false
			allzero = true
		elseif one < 0 or two < 0 or three < 0 or four < 0 then
			numbert = false
		end
		
		--> print(self.ship_will_change[1],self.ship_will_change[2],self.ship_will_change[3],self.ship_will_change[4])
		if one >= 0 and two >= 0 and three>= 0 and four >= 0 and numbert then
			self.button_train[1]:setVisible(false)
			self.button_train[3]:setVisible(true)
			self.button_train[2]:setVisible(false)
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_legendary_game 
				then
				self.button_train[1]:setPosition(self.button_train[1]._center_position)
				self.button_train[3]:setPosition(self.button_train[3]._center_position)
			end
			fwin:addTouchEventListener(self.button_train[3], nil, 
			{
				terminal_name = "hero_train_page_change_train", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			}, 
			nil, 0)
		else
			self.button_train[2]:setVisible(true)
			self.button_train[3]:setVisible(false)
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_legendary_game 
				then
				self.button_train[1]:setPosition(self.button_train[1]._start_position)
				self.button_train[3]:setPosition(self.button_train[3]._start_position)
			end
			fwin:addTouchEventListener(self.button_train[2], nil, 
			{
				terminal_name = "hero_train_page_change_train", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			}, 
			nil, 0)
		end	
		
		if -- _ED.hero_train_info[self.shipId] == nil and 
			allzero == true then 
			self.button_train[1]:setVisible(true)
			self.button_train[2]:setVisible(false)
			self.button_train[3]:setVisible(false)
			
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_legendary_game 
				then
				self.button_train[1]:setPosition(self.button_train[1]._center_position)
				self.button_train[3]:setPosition(self.button_train[3]._center_position)
			end
		end	
		self.initDatas = true
	end

	-- 显示加成数值对应的箭头 
	for i = 1,4 do
		if	tonumber(self.ship_will_change[i]) > 0 then
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_arrow_"..i.."1"):setVisible(true)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_arrow_"..i.."2"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Text_4"..i):setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))   -- 亮绿色
		elseif tonumber(self.ship_will_change[i]) == 0 then
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_arrow_"..i.."1"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_arrow_"..i.."2"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Text_4"..i):setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))   -- 纯白色
		elseif tonumber(self.ship_will_change[i]) < 0 then
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_arrow_"..i.."1"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_arrow_"..i.."2"):setVisible(true)
			ccui.Helper:seekWidgetByName(self.roots[1], "Text_4"..i):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))   -- 大红色
		end
	end
	
	local LoadingBar_hp = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_hp")
	local LoadingBar_gongji = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_gongji")
	local LoadingBar_wufang = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_wufang")
	local LoadingBar_fafang = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_fafang")
	
	local function percent(data, data_max)
		local back = data/data_max * 100
		if back < 0 then
			back = 0
		elseif back > 100 then
			back = 100
		end
		return back
	end
	
	LoadingBar_hp:setPercent(percent(self.ship_has_added[1], self.ship_add_max[1]))
	LoadingBar_gongji:setPercent(percent(self.ship_has_added[2], self.ship_add_max[2]))
	LoadingBar_wufang:setPercent(percent(self.ship_has_added[3], self.ship_add_max[3]))
	LoadingBar_fafang:setPercent(percent(self.ship_has_added[4], self.ship_add_max[4]))
	
	local ship_health_added = ccui.Helper:seekWidgetByName(self.roots[1], "Text_hp")
	local ship_courage_added = ccui.Helper:seekWidgetByName(self.roots[1], "Text_gongji")
	local ship_intellect_added = ccui.Helper:seekWidgetByName(self.roots[1], "Text_wufang")
	local ship_quick_added = ccui.Helper:seekWidgetByName(self.roots[1], "Text_fangfa")
	
	ship_health_added:setString(self.ship_has_added[1].."/"..self.ship_add_max[1])
	ship_courage_added:setString(self.ship_has_added[2].."/"..self.ship_add_max[2])
	ship_intellect_added:setString(self.ship_has_added[3].."/"..self.ship_add_max[3])
	ship_quick_added:setString(self.ship_has_added[4].."/"..self.ship_add_max[4])
	
	local ship_health_add = ccui.Helper:seekWidgetByName(self.roots[1], "Text_41")
	local ship_courage_add = ccui.Helper:seekWidgetByName(self.roots[1], "Text_42")
	local ship_intellect_add = ccui.Helper:seekWidgetByName(self.roots[1], "Text_43")
	local ship_quick_add = ccui.Helper:seekWidgetByName(self.roots[1], "Text_44")
	local ship_dan = ccui.Helper:seekWidgetByName(self.roots[1], "Text_dan_1")
	local Text_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_name")
	
	local ship_type = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type) + 1
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type][1], tipStringInfo_quality_color_Type[ship_type][2], tipStringInfo_quality_color_Type[ship_type][3]))
	end
	local a,b,c,d
	
	if tonumber(self.ship_will_change[1]) > 0 then
		a = "+" .. self.ship_will_change[1]
	else
		a = self.ship_will_change[1]
	end
	if tonumber(self.ship_will_change[2]) > 0 then
		b = "+" .. self.ship_will_change[2]
	else
		b = self.ship_will_change[2]
	end
	if tonumber(self.ship_will_change[3]) > 0 then
		c = "+" .. self.ship_will_change[3]
	else
		c = self.ship_will_change[3]
	end
	if tonumber(self.ship_will_change[4]) > 0 then
		d = "+" .. self.ship_will_change[4]
	else
		d = self.ship_will_change[4]
	end
	ship_health_add:setString(a)
	ship_courage_add:setString(b)
	ship_intellect_add:setString(c)
	ship_quick_add:setString(d)
	ship_dan:setString(tostring(self.user_dan.prop_number))
	if tonumber(self.user_dan.prop_number) < 3 then
		ship_dan:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
	else
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			ship_dan:setColor(cc.c3b(69,29,29))
		elseif __lua_project_id == __lua_project_warship_girl_b then
			ship_dan:setColor(cc.c3b(color_Type[9][1], color_Type[9][2], color_Type[9][3]))
		else
			ship_dan:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
		end
	end
	-- --武将全身像
	local Panel_juese = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_juese")
	if self.status == false then
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_legendary_game 
			then
			-- local temp_bust_index = dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.bust_index)
			-- -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
			-- -- local cell = ccs.Armature:create("spirte_" .. temp_bust_index)
			-- -- cell:getAnimation():playWithIndex(0)
			-- -- -- cell:setAnchorPoint(cc.p(0.5, 0.5))
			-- -- Panel_juese:addChild(cell)
			-- -- cell:setPosition(cc.p(Panel_juese:getContentSize().width/2, 0))
			-- Panel_juese:removeAllChildren(true)
			-- draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_juese, nil, nil, cc.p(0.5, 0))
			-- if animationMode == 1 then
			-- 	app.load("client.battle.fight.FightEnum")
			-- 	sp.spine_sprite(Panel_juese, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			-- else
			-- 	draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", Panel_juese, -1, nil, nil, cc.p(0.5, 0))
			-- end
		else
			local shipCell = ShipBodyCell:createCell()
			shipCell:init(self.ship, 0)
			Panel_juese:addChild(shipCell)
		end
	end
	
	self.status = true
	
	local rankLevelFront = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.initial_rank_level)
	-- local ship_name = self.ship.captain_name.." +"..rankLevelFront	--战船名称
	local ship_name = nil
	if dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_type) == 0 then
		ship_name = _ED.user_info.user_name .." +"..rankLevelFront
	else
		ship_name = self.ship.captain_name.." +"..rankLevelFront		--战船名称
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		if ___is_open_leadname == true then
			if HeroTrainPage.__userHeroFontName == nil then
				HeroTrainPage.__userHeroFontName = Text_name:getFontName()
			end
			if dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_type) == 0 then
				Text_name:setFontName("")
				Text_name:setFontSize(Text_name:getFontSize())-->设置字体大小
			else
				Text_name:setFontName(HeroTrainPage.__userHeroFontName)
			end
		end
		Text_name:setString(ship_name)
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

function HeroTrainPage:playShow( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self.actions[1]:play("window_open",false)
	end
end

function HeroTrainPage:onEnterTransitionFinish()
	local csbGeneralsQianghua = csb.createNode("packs/HeroStorage/generals_peiyang.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("packs/HeroStorage/generals_peiyang.csb")
	csbGeneralsQianghua:runAction(action)
	action:play("window_open", false)
	table.insert(self.actions,action)
	self:addChild(csbGeneralsQianghua)
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
	
	self.affirm = 
	{	
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_23"),			--培养方式一选项
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_23_0"),			--培养方式二选项
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_23_1")			--培养方式三选项
	}
	self.affirm[1]:setVisible(true)
	self.button_train = 
	{
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_peiyang"),		--培养按钮
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_tihuan"),		--替换按钮
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_tihuan_0")		--替换按钮
	}
	self.action = 
	{
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_successfully_1"):getChildByName("ArmatureNode_successfully_hp"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_successfully_2"):getChildByName("ArmatureNode_successfully_gongji"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_successfully_3"):getChildByName("ArmatureNode_successfully_zhuangjia"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_successfully_4"):getChildByName("ArmatureNode_successfully_fangkong"),
	}
	
	local Image_danyao 	= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Image_danyao"), nil, {terminal_name = "hero_train_page_chooes_danyao", terminal_state = 1}, nil, 0)
	local Image_yinbi 	= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Image_yinbi"), nil, {terminal_name = "hero_train_page_chooes_danyao", terminal_state = 2}, nil, 0)
	local Image_yuanbao = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Image_yuanbao"), nil, {terminal_name = "hero_train_page_chooes_danyao", terminal_state = 3}, nil, 0)
	
	local Button_peiyang = fwin:addTouchEventListener(self.button_train[1], nil, {terminal_name = "hero_train_page_chooes_train", terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
	local Button_8 		= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_8"), nil, {terminal_name = "hero_train_page_chooes_times", terminal_state = 1, isPressedActionEnabled = true}, nil, 0)
	local Text_cishu 	= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Text_cishu"), nil, {terminal_name = "hero_train_page_chooes_times", terminal_state = 1}, nil, 0)
	local Panel_juese 	= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_juese"), nil, {terminal_name = "hero_train_page_chooes_hero", terminal_state = 0}, nil, 0)	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		self.button_train[1]._start_position = cc.p(self.button_train[1]:getPosition())
		self.button_train[1]._center_position = cc.p(self.button_train[1]._start_position.x + 80, self.button_train[1]._start_position.y)
		self.button_train[3]._start_position = cc.p(self.button_train[3]:getPosition())
		self.button_train[3]._center_position = cc.p(self.button_train[3]._start_position.x + 80, self.button_train[3]._start_position.y)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		self:onUpdateDraw()
	end
end

function HeroTrainPage:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local Panel_juese = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_juese")
		if Panel_juese ~= nil then
			Panel_juese:removeAllChildren(true)		
		end
		ccs.GUIReader:destroyInstance()
		ccs.ActionManagerEx:destroyInstance()
		ccs.ActionTimelineCache:destroyInstance()
		ccs.ArmatureDataManager:destroyInstance()
		cc.Director:getInstance():getTextureCache():removeUnusedTextures()
		cc.Director:getInstance():purgeCachedData()
		cc.GLProgramCache:destroyInstance()		
		cacher.destoryRefPool("packs/HeroStorage/generals_peiyang.csb")
	end	
end

function HeroTrainPage:onExit()
	state_machine.remove("hero_train_page_chooes_danyao")
	state_machine.remove("hero_train_page_chooes_train")
	state_machine.remove("hero_train_page_change_train")
	state_machine.remove("hero_train_page_chooes_times")
	state_machine.remove("hero_train_page_chooes_hero")
	state_machine.remove("hero_train_page_check_updata_by_other_page")
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
	self.ship_will_change[1] = nil					--生命培养可增加值
	self.ship_will_change[2] = nil				--攻击培养可增加值
	self.ship_will_change[3] = nil		--物防培养可增加值
	self.ship_will_change[4] = nil
end

function HeroTrainPage:init(shipId, types)
	self.shipId = shipId
	self.types = types
	self.ship = fundShipWidthId(self.shipId)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self.status = false
		self.initDatas = false
	end
end