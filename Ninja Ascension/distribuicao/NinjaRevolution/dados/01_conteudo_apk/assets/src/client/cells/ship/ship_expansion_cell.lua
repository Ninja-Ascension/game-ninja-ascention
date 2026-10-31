---------------------------------
---说明：武将信息选项卡扩展界面
-- 创建时间:2015.03.16
-- 作者：刘迎
-- 修改记录：
-- 最后修改人：
---------------------------------

HeroExpansionsCell = class("HeroExpansionsCellClass", Window)
   
function HeroExpansionsCell:ctor()
    self.super:ctor()
	
	self.heroInstance = nil
	self.roots = {}
	self.isPlayer = false
	self.num = nil
    local function init_hero_Seat_expansions_terminal()
	
		local ship_seat_expansions_manager_terminal = {
            _name = "ship_seat_expansions_manager",
            _init = function (terminal) 
				app.load("client.packs.hero.HeroDevelop")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local arena_grade=dms.int(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.level)
				if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
					if __lua_project_id == __lua_project_warship_girl_a 
						or __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_yugioh then
						if params._datas.next_terminal_name == "ship_seat_fashion" then
							terminal.last_terminal_name = params._datas.next_terminal_name
							state_machine.excute(params._datas.next_terminal_name, 0, params)
							state_machine.excute("hero_storage_hide_window", 0, params)
							return true
						end
					end
					if tonumber(instance.heroInstance.ship_grade) >= tonumber(_ED.user_info.user_grade) and 
						params._datas.next_terminal_name == "ship_seat_strengthen" then
						TipDlg.drawTextDailog(_string_piece_info[345])
						return
					end
					if params._datas.next_terminal_name == "ship_seat_breach" and tonumber(instance.heroInstance.ship_template_id) == 1148 or tonumber(instance.heroInstance.ship_template_id) == 1149 or
						 tonumber(instance.heroInstance.ship_template_id) == 1150 then
						TipDlg.drawTextDailog(_string_piece_info[346])
						return
					end
					if params._datas.next_terminal_name == "ship_seat_breach" and dms.int(dms["ship_mould"], instance.heroInstance.ship_template_id, ship_mould.grow_target_id) == -1 then
						TipDlg.drawTextDailog(_string_piece_info[91])
						return
					end
					if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
						or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge 
						or __lua_project_id == __lua_project_warship_girl_b 
						or __lua_project_id == __lua_project_yugioh
						then 
						--觉醒等级不够
						local isOpen = dms.int(dms["fun_open_condition"], 5, fun_open_condition.level) <= zstring.tonumber(instance.heroInstance.ship_grade)
		    	
						if params._datas.next_terminal_name == "ship_seat_awaken" and isOpen == false then
							TipDlg.drawTextDailog(_awaken_tipString_info[9])
							return
						end
					end
					local id = dms.int(dms["ship_mould"], instance.heroInstance.ship_template_id, ship_mould.cultivate_property_id)
					local maxOne = dms.int(dms["cultivate_property_param"], id, cultivate_property_param.max_life)					--生命培养上限
					local maxTwo = dms.int(dms["cultivate_property_param"], id, cultivate_property_param.max_attack)				--攻击培养上限
					local maxThree = dms.int(dms["cultivate_property_param"], id, cultivate_property_param.max_physical_defence)		--物防培养上限
					local maxFour = dms.int(dms["cultivate_property_param"], id, cultivate_property_param.max_skill_defence)
					if params._datas.next_terminal_name == "ship_seat_culture" and tonumber(instance.heroInstance.ship_train_info.train_life) == maxOne and tonumber(instance.heroInstance.ship_train_info.train_attack) == maxTwo and
						tonumber(instance.heroInstance.ship_train_info.train_physical_defence) == maxThree and tonumber(instance.heroInstance.ship_train_info.train_skill_defence) == maxFour then
						TipDlg.drawTextDailog(_string_piece_info[348])
						return
					end
					
					state_machine.excute("hero_storage_show_listview_bounce", 0,{_datas = instance.num})
					local heroInstance = params._datas.heroInstance
		    		if fwin:find("HeroDevelopClass") ~= nil then
		    			fwin:close(fwin:find("HeroDevelopClass"))
		    		end
					local heroDevelopWindow = HeroDevelop:new()
					heroDevelopWindow:init(heroInstance.ship_id)
					fwin:open(heroDevelopWindow, fwin._viewdialog)
					
					terminal.last_terminal_name = params._datas.next_terminal_name
					state_machine.excute(params._datas.next_terminal_name, 0, params)
					state_machine.excute("hero_storage_hide_window", 0, params)
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--武将时装
		local ship_seat_fashion_terminal = {
            _name = "ship_seat_fashion",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
           		if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
           			app.load("client.packs.fashion.FashionDevelop")
					state_machine.excute("fashion_develop_open", 0,{_datas= {_pageType = 1}})
           		else
					TipDlg.drawTextDailog(_function_unopened_tip_string)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--武将升级
		local ship_seat_strengthen_terminal = {
            _name = "ship_seat_strengthen",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local heroInstance = params._datas.heroInstance
				state_machine.excute("hero_develop_page_manager", 0, 
					{
						_datas = {
							terminal_name = "hero_develop_page_manager", 	
							next_terminal_name = "hero_develop_page_open_strengthen_page", 
							current_button_name = "Button_shengji",
							but_image = "", 		
							heroInstance = heroInstance,
							terminal_state = 0,
							openWinId = 33,
							isPressedActionEnabled = false
						}
					}
				)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--武将突破
		local ship_seat_breach_terminal = {
            _name = "ship_seat_breach",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local heroInstance = params._datas.heroInstance
				state_machine.excute("hero_develop_page_manager", 0, 
					{
						_datas = {
							terminal_name = "hero_develop_page_manager", 	
							next_terminal_name = "hero_develop_page_open_advanced", 
							current_button_name = "Button_tupo",
							but_image = "", 		
							heroInstance = heroInstance,
							terminal_state = 0,
							openWinId = 34,
							isPressedActionEnabled = false
						}
					}
				)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--武将培养
		local ship_seat_culture_terminal = {
            _name = "ship_seat_culture",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local heroInstance = params._datas.heroInstance
				state_machine.excute("hero_develop_page_manager", 0, 
					{
						_datas = {
							terminal_name = "hero_develop_page_manager", 	
							next_terminal_name = "hero_develop_page_open_train_page", 
							current_button_name = "Button_peiyang",
							but_image = "", 		
							heroInstance = heroInstance,
							terminal_state = 0,
							openWinId = 3,
							isPressedActionEnabled = false
						}
					}
				)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--武将天命
		local ship_seat_fate_terminal = {
            _name = "ship_seat_fate",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local heroInstance = params._datas.heroInstance
				state_machine.excute("hero_develop_page_manager", 0, 
					{
						_datas = {
							terminal_name = "hero_develop_page_manager", 	
							next_terminal_name = "hero_develop_page_open_skill_stren_page", 
							current_button_name = "Button_tianming",
							but_image = "", 		
							heroInstance = heroInstance,
							terminal_state = 0,
							openWinId = 4,
							isPressedActionEnabled = false
						}
					}
				)
				-- TipDlg.drawTextDailog(_function_unopened_tip_string)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--武将觉醒
		local ship_seat_awaken_terminal = {
            _name = "ship_seat_awaken",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

				local heroInstance = params._datas.heroInstance
				local requirement = dms.int(dms["ship_mould"], heroInstance.ship_template_id, ship_mould.base_mould2)
				local grouds = dms.searchs(dms["awaken_requirement"], awaken_requirement.group_id, requirement)
				local awaken_info = nil
				if grouds ~= nil then 
			        for i, v in pairs(grouds) do
			            if tonumber(v[3]) == tonumber(heroInstance.awakenLevel) then
			               awaken_info = v 
			               break
			            end
			        end
		    	end
		    	if awaken_info ~= nil and zstring.tonumber(awaken_info[4]) == -1 then 
		    		--满级
		    		TipDlg.drawTextDailog(_awaken_tipString_info[10])
		    		return	true
		    	end
				state_machine.excute("hero_develop_page_manager", 0, 
					{
						_datas = {
							terminal_name = "hero_develop_page_manager", 	
							next_terminal_name = "hero_develop_page_open_juexin", 
							current_button_name = "Button_juexing",
							but_image = "", 		
							heroInstance = heroInstance,
							terminal_state = 0,
							openWinId = 33,
							isPressedActionEnabled = false
						}
					}
				)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(ship_seat_expansions_manager_terminal)
		state_machine.add(ship_seat_fashion_terminal)
		state_machine.add(ship_seat_strengthen_terminal)
		state_machine.add(ship_seat_breach_terminal)
		state_machine.add(ship_seat_culture_terminal)
		state_machine.add(ship_seat_fate_terminal)
		state_machine.add(ship_seat_awaken_terminal)
        state_machine.init()
    end
    
    init_hero_Seat_expansions_terminal()
end


function HeroExpansionsCell:onEnterTransitionFinish()

    --获取 角色信息选项卡 --该资源包含扩展界面资源 美术资源
    local csbListGenerals = csb.createNode("packs/HeroStorage/list_generals_1.csb")
	local root = csbListGenerals:getChildByName("root")
	--> print("root", root)
	table.insert(self.roots, root)
    self:addChild(csbListGenerals)
	
	--武将时装
	local seat_expansion_on_button = ccui.Helper:seekWidgetByName(root, "Button_shizhuang_0")
	local shizhuang_Text = ccui.Helper:seekWidgetByName(root, "Text_shizhuang")
	fwin:addTouchEventListener(seat_expansion_on_button, nil, 
	{
		terminal_name = "ship_seat_expansions_manager", 
		next_terminal_name = "ship_seat_fashion", 
		current_button_name = "Button_shizhuang_0",  
		but_image = "", 	
		heroInstance = self.heroInstance,
		terminal_state = 0, 
		openWinId = 2,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	if seat_expansion_on_button ~= nil then
		seat_expansion_on_button:setVisible(false)
		if self.isPlayer == true then
			seat_expansion_on_button:setVisible(true)
			shizhuang_Text:setVisible(true)
		end
	end

	if dms.int(dms["fun_open_condition"], 2, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
		ccui.Helper:seekWidgetByName(root, "Text_shizhuang"):setString("")
	else
		ccui.Helper:seekWidgetByName(root, "Text_shizhuang"):setString(_wait_open_tip)
	end
	
	--武将升级
	local hero_strengthen_button = ccui.Helper:seekWidgetByName(root, "Button_shengji")
	fwin:addTouchEventListener(hero_strengthen_button, nil, 
	{
		terminal_name = "ship_seat_expansions_manager", 
		next_terminal_name = "ship_seat_strengthen", 
		current_button_name = "Button_shengji",  
		but_image = "", 	
		heroInstance = self.heroInstance,
		terminal_state = 0, 
		openWinId = 33,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	if hero_strengthen_button ~= nil and self.isPlayer == false then
		hero_strengthen_button:setVisible(true)
	end
	if dms.int(dms["fun_open_condition"], 33, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
		ccui.Helper:seekWidgetByName(root, "Text_shengji"):setVisible(false)
	end
	
	--武将突破
	local seat_breach_button = ccui.Helper:seekWidgetByName(root, "Button_tupo")
	fwin:addTouchEventListener(seat_breach_button, nil, 
	{
		terminal_name = "ship_seat_expansions_manager", 
		next_terminal_name = "ship_seat_breach", 
		current_button_name = "Button_tupo",  
		but_image = "", 		
		heroInstance = self.heroInstance,
		terminal_state = 0, 
		openWinId = 34,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	if dms.int(dms["fun_open_condition"], 34, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
		ccui.Helper:seekWidgetByName(root, "Text_tupo"):setVisible(false)
	end
	
	--武将培养
	local seat_culture_button = ccui.Helper:seekWidgetByName(root, "Button_peiyang")
	fwin:addTouchEventListener(seat_culture_button, nil, 
	{
		terminal_name = "ship_seat_expansions_manager", 
		next_terminal_name = "ship_seat_culture", 
		current_button_name = "Button_peiyang",  
		but_image = "", 	 
		heroInstance = self.heroInstance,	
		terminal_state = 0, 
		openWinId = 3,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	if dms.int(dms["fun_open_condition"], 3, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
		ccui.Helper:seekWidgetByName(root, "Text_peiyang"):setVisible(false)
	end
	
	--武将天命
	local seat_fate_button = ccui.Helper:seekWidgetByName(root, "Button_tianming")
	fwin:addTouchEventListener(seat_fate_button, nil, 
	{
		terminal_name = "ship_seat_expansions_manager", 
		next_terminal_name = "ship_seat_fate", 
		current_button_name = "Button_tianming",  
		but_image = "", 	
		heroInstance = self.heroInstance,	
		terminal_state = 0, 
		openWinId = 4,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	if dms.int(dms["fun_open_condition"], 4, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
		ccui.Helper:seekWidgetByName(root, "Text_tianming"):setVisible(false)
	end
	
	--武将觉醒
	local Button_juexing = nil
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_yugioh
		then 
		Button_juexing = ccui.Helper:seekWidgetByName(root, "Button_juexing")
		fwin:addTouchEventListener(Button_juexing, nil, 
		{
			terminal_name = "ship_seat_expansions_manager", 
			next_terminal_name = "ship_seat_awaken", 
			current_button_name = "Button_juexing",  
			but_image = "", 	
			heroInstance = self.heroInstance,	
			terminal_state = 0, 
			openWinId = 5,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	else
		Button_juexing = ccui.Helper:seekWidgetByName(root, "Button_juexing")
		fwin:addTouchEventListener(Button_juexing, nil, 
		{
			terminal_name = "ship_seat_expansions_manager", 
			next_terminal_name = "ship_seat_awaken", 
			current_button_name = "Button_juexing",  
			but_image = "", 	
			heroInstance = self.heroInstance,	
			terminal_state = 0, 
			openWinId = 5,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		if dms.int(dms["fun_open_condition"], 5, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
			ccui.Helper:seekWidgetByName(root, "Text_juexing"):setString("")
		else
			ccui.Helper:seekWidgetByName(root, "Text_juexing"):setString(_wait_open_tip)
		end
	end
	
	if tonumber(self.heroInstance.ship_grade) >= tonumber(_ED.user_info.user_grade) then
		ccui.Helper:seekWidgetByName(root, "Text_shengji"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_shengji"):setString(_string_piece_info[344])
	end
	
	if tonumber(self.heroInstance.ship_template_id) == 1148 or tonumber(self.heroInstance.ship_template_id) == 1149 or
		 tonumber(self.heroInstance.ship_template_id) == 1150 then
		ccui.Helper:seekWidgetByName(root, "Text_tupo"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_tupo"):setString(_string_piece_info[346])
		ccui.Helper:seekWidgetByName(root, "Text_juexing"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_juexing"):setString(_string_piece_info[347])
	end
	
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_yugioh
		then 
		local isOpen = dms.int(dms["fun_open_condition"], 5, fun_open_condition.level) <= zstring.tonumber(self.heroInstance.ship_grade)
		local requirement = dms.int(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.base_mould2)
		--主角 红橙将可以觉醒
		if self.isPlayer == true or requirement ~= -1 then
			if isOpen == true then 
				--级别够了
				ccui.Helper:seekWidgetByName(root, "Text_juexing"):setString("")
			else
				--
				ccui.Helper:seekWidgetByName(root, "Text_juexing"):setString(_awaken_tipString_info[7])
			end
		else
			ccui.Helper:seekWidgetByName(root, "Text_juexing"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_juexing"):setString(_string_piece_info[347])
			Button_juexing:setTouchEnabled(false)
		end
	end

	if dms.int(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.grow_target_id) == -1 then
		ccui.Helper:seekWidgetByName(root, "Text_tupo"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_tupo"):setString(_string_piece_info[344])
	end
	
	local id = dms.int(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.cultivate_property_id)
	local maxOne = dms.int(dms["cultivate_property_param"], id, cultivate_property_param.max_life)					--生命培养上限
	local maxTwo = dms.int(dms["cultivate_property_param"], id, cultivate_property_param.max_attack)				--攻击培养上限
	local maxThree = dms.int(dms["cultivate_property_param"], id, cultivate_property_param.max_physical_defence)		--物防培养上限
	local maxFour = dms.int(dms["cultivate_property_param"], id, cultivate_property_param.max_skill_defence)
	if tonumber(self.heroInstance.ship_train_info.train_life) == maxOne and tonumber(self.heroInstance.ship_train_info.train_attack) == maxTwo and
		tonumber(self.heroInstance.ship_train_info.train_physical_defence) == maxThree and tonumber(self.heroInstance.ship_train_info.train_skill_defence) == maxFour then
		ccui.Helper:seekWidgetByName(root, "Text_peiyang"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_peiyang"):setString(_string_piece_info[349])
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		hero_strengthen_button:setName("Button_shengji100")
		seat_breach_button:setName("Button_tupo100")
	end
end


function HeroExpansionsCell:onExit()
	state_machine.remove("ship_seat_expansions_manager")
	state_machine.remove("ship_seat_fashion")
	state_machine.remove("ship_seat_strengthen")
	state_machine.remove("ship_seat_breach")
	state_machine.remove("ship_seat_culture")
	state_machine.remove("ship_seat_fate")
end

function HeroExpansionsCell:init(heroInstance,num)
	self.heroInstance = heroInstance
	self.isPlayer = false
	if dms.int(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.captain_type) == 0 then 	
		self.isPlayer = true
	else
		self.isPlayer = false
	end
	self.num = num
end

function HeroExpansionsCell:createCell()
	local cell = HeroExpansionsCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end