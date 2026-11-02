-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将天命界面
-------------------------------------------------------------------------------------------------------
HeroSkillStrenPage = class("HeroSkillStrenPageClass", Window)
HeroSkillStrenPage.__userHeroFontName = nil
function HeroSkillStrenPage:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.shipId = 0        --当前武将Id
	self.ship = nil
	self.num = 0
	self.need = 0
	self.prop = nil
	self.one = false
	self.level = 0		--等级
	self.tianming = 0	--当前天命数值
	self.types = nil
	self.status = true
	self.falst = false
	self.levelup = false
	self.isregister = false
	app.load("client.cells.ship.ship_body_cell")
    local function init_hero_skill_stren_page_terminal()
		--强化
		local hero_skill_stren_page_go_terminal = {
            _name = "hero_skill_stren_page_go",
            _init = function (terminal) 
                app.load("client.packs.hero.HeroPatchInformationPageGetWay")
                app.load("client.packs.hero.HeroSkillStrenSuccess")
				app.load("client.cells.utils.property_change_tip_info_cell") 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
            		local hero_data = dms.element(dms["ship_mould"], instance.ship.ship_template_id)
            		local skillInfos = zstring.split(dms.atos(hero_data, ship_mould.skill_mould_info),",")
					if tonumber(instance.level) >= table.nums(skillInfos) then
						instance.one = false
						TipDlg.drawTextDailog(_string_piece_info[378])
						return
					end
				end
				if tonumber(params._datas._num) >= tonumber(params._datas._need) then
					local function responseInitCallback(response)
						_ED.baseFightingCount = calcTotalFormationFight()
						instance.isregister = false
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							pushEffect(formatMusicFile("effect", 9989))
							
							if tonumber(_ED.hero_skillstren_info.level) > tonumber(self.level) then
								self.levelup = true
								state_machine.excute("hero_list_view_update_cell", 0, params._datas._shipId)
								
								if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
									self.one = false
									state_machine.excute("hero_develop_page_update",0,"")--刷新信息界面信息		
													
									state_machine.excute("formation_update_ship_info",0,"")
				
									local Panel_8fdfdf = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_8fdfdf")

									local ArmatureNode_shengji  = Panel_8fdfdf:getChildByName("ArmatureNode_shengji")			
								    draw.initArmature(ArmatureNode_shengji, nil, -1, 0, 1)
								    ArmatureNode_shengji:getAnimation():playWithIndex(0, 0, 0)

								    local Panel_down = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_down")
									local ArmatureNode_jindutiao =  Panel_down:getChildByName("ArmatureNode_jindutiao")
									draw.initArmature(ArmatureNode_jindutiao, nil, -1, 0, 1)
								    ArmatureNode_jindutiao:getAnimation():playWithIndex(0, 0, 0)

									ArmatureNode_shengji._invoke = function(armatureBack)
										local cell = HeroSkillStrenSuccess:new()
										cell:init(params._datas._shipId)
										fwin:open(cell, fwin._windows)
								    end
								else
									local cell = HeroSkillStrenSuccess:new()
									cell:init(params._datas._shipId)
									fwin:open(cell, fwin._windows)
								end
								-- playEffectForAbilityUp()
								pushEffect(formatMusicFile("effect", 9992))
							else
								local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
								local str = ""
								local textData = {}
								local name = _string_piece_info[254]
								local values = tonumber(_ED.hero_skillstren_info.value) - tonumber(self.tianming)
								table.insert(textData, {property = name, value = values})
								
								tipInfo:init(6,str, textData, 3,nil)	
								fwin:open(tipInfo, fwin._windows)

								if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
								    local Panel_down = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_down")
									local ArmatureNode_jindutiao =  Panel_down:getChildByName("ArmatureNode_jindutiao")
									draw.initArmature(ArmatureNode_jindutiao, nil, -1, 0, 1)
								    ArmatureNode_jindutiao:getAnimation():playWithIndex(0, 0, 0)
								end
								
							end
							instance:onUpdateDraw()
						end
					end
					if self.levelup == false then
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							local maxSkillLevel = tonumber(dms.string(dms["pirates_config"],276,pirates_config.param))
							 if tonumber(instance.level) >= maxSkillLevel then
							 	self.one = false
							 	TipDlg.drawTextDailog(_string_piece_info[381])
							 	return
							 end
						end
						instance.isregister = true
						protocol_command.destiny_click.param_list = params._datas._shipId
						NetworkManager:register(protocol_command.destiny_click.code, nil, nil, nil, nil, responseInitCallback, false, nil)
					end
					
				else
					if fwin:find("HeroPatchInformationPageGetWayClass") == nil then
						local cell = HeroPatchInformationPageGetWay:createCell()
						cell:init(params._datas._propId, 2)
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							fwin:open(cell, fwin._windows)
						else
							fwin:open(cell, fwin._view)
						end
						self.one =false
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		--通过改变其他页面内容更新本类信息
		local hero_skill_stren_page_check_updata_by_other_page_terminal = {
            _name = "hero_skill_stren_page_check_updata_by_other_page",
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
		state_machine.add(hero_skill_stren_page_go_terminal)
		state_machine.add(hero_skill_stren_page_check_updata_by_other_page_terminal)
        state_machine.init()
    end
    init_hero_skill_stren_page_terminal()
end

function HeroSkillStrenPage:onUpdate(dt)
	if self.isregister == true then
		return
	end
	if self.one == true then
		state_machine.excute("hero_skill_stren_page_go", 0, {_datas = {_shipId = self.shipId,_num = self.num,_need = self.need,_propId = self.prop,_level = self.level , isPressedActionEnabled = true}})
	end
end

function HeroSkillStrenPage:onUpdateDraw()
	self.ship = fundShipWidthId(self.shipId)
	
	-- 数据初始化
	
	-- UI 获取
	local Panel_10 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_10")
	
	-- 武将全身像
	if self.falst == false then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			-- local shipCell = LformationChangeHeroCell:createCell()
			-- shipCell:init(_ED.user_ship[""..self.shipId])
			-- Panel_10:removeAllChildren(true)
			-- Panel_10:addChild(shipCell)
		else
			local shipCell = ShipBodyCell:createCell()
			shipCell:init(self.ship, 0)
			Panel_10:addChild(shipCell)
		end
	end
	
	self.falst = true
	--武将名称
	local textName = ccui.Helper:seekWidgetByName(self.roots[1], "Text_name")
	local name = nil
	local hero_data = dms.element(dms["ship_mould"], self.ship.ship_template_id)
	local rankLevelFront = dms.atoi(hero_data, ship_mould.initial_rank_level)  --进阶前的进阶等级
	local colortype = dms.atoi(hero_data, ship_mould.ship_type)
	local ship_name = ""
	if dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_type) == 0 then
		name = _ED.user_info.user_name
	else
		name = self.ship.captain_name
	end
	if rankLevelFront ~= 0 then
		ship_name = name.." +"..rankLevelFront		--战船名称
	else
		ship_name = name
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		if ___is_open_leadname == true then
			if HeroSkillStrenPage.__userHeroFontName == nil then
				HeroSkillStrenPage.__userHeroFontName = textName:getFontName()
			end
			if dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_type) == 0 then
				textName:setFontName("")
				textName:setFontSize(textName:getFontSize())-->设置字体大小
			else
				textName:setFontName(HeroSkillStrenPage.__userHeroFontName)
			end
		end
		textName:setString(ship_name)
		textName:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	end
	local level = nil
	local mynum = 0

	if _ED.hero_skillstren_info.level ~= nil and _ED.hero_skillstren_info.hero_id ~= nil and
		tonumber(_ED.hero_skillstren_info.hero_id) == tonumber(self.shipId) then
		level = _ED.hero_skillstren_info.level
		mynum = _ED.hero_skillstren_info.value
	else
		level = self.ship.ship_skillstren.skill_level
		mynum = self.ship.ship_skillstren.skill_value
	end
	self.level = level
	self.tianming = mynum
	--天命等级
	local skillLv = ccui.Helper:seekWidgetByName(self.roots[1], "Text_tmlv")
	if verifySupportLanguage(_lua_release_language_en) == true then
		skillLv:setString(_All_tip_string_info._destiny .. _string_piece_info[6]..level)
	else
		skillLv:setString(_All_tip_string_info._destiny .. level .. _string_piece_info[6])
	end

	-- 当前加成
	local lv = ccui.Helper:seekWidgetByName(self.roots[1], "Text_5")
	local one = ccui.Helper:seekWidgetByName(self.roots[1], "Text_gongji_0")
	local two= ccui.Helper:seekWidgetByName(self.roots[1], "Text_shengming_0")
	local three = ccui.Helper:seekWidgetByName(self.roots[1], "Text_wufang_0")
	local four = ccui.Helper:seekWidgetByName(self.roots[1], "Text_mofang_0")
	local skillName = ccui.Helper:seekWidgetByName(self.roots[1], "Text_jzjy")
	local skillLv = ccui.Helper:seekWidgetByName(self.roots[1], "Text_jzjy_0")
	
	if verifySupportLanguage(_lua_release_language_en) == true then
		lv:setString(_All_tip_string_info._destiny .. _string_piece_info[6]..level)
	else
		lv:setString(_All_tip_string_info._destiny .. level .. _string_piece_info[6])
	end

	-- 龙虎门的ship_mould表没有skill_mould_info属性，因此同步龙虎门需要做下面的修改
	local skillInfos = nil 
	local nextSkillId = nil
	local skillId = nil
	local skillNamesOne = nil 
	local skillNamesTwo = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		skillId = dms.atoi(hero_data, ship_mould.deadly_skill_mould)
		skillNamesOne = dms.string(dms["skill_mould"], skillId + tonumber(level) - 1, skill_mould.skill_name)
		skillNamesTwo = dms.string(dms["skill_mould"], skillId + tonumber(level), skill_mould.skill_name)
	else
		skillInfos = zstring.split(dms.atos(hero_data, ship_mould.skill_mould_info),",")
		nextSkillId = skillInfos[tonumber(level)]
		skillNamesOne = dms.string(dms["skill_mould"], nextSkillId, skill_mould.skill_name)
	end
	
	local name_table = zstring.split(skillNamesOne,"L")
	skillName:setString(name_table[1])

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		local name = getNowEquipSkillName(self.ship.ship_template_id)
		if name ~= nil then
			skillName:setString(name)
		end
	end
	
	if verifySupportLanguage(_lua_release_language_en) == true then
		skillLv:setString(_string_piece_info[6]..level)
	else
		skillLv:setString(level .. _string_piece_info[6])
	end
	
	local id = tonumber(level)
	local addition_percent_life = dms.int(dms["destiny_property_param"], id, destiny_property_param.addition_percent_life)
	local addition_percent_attack = dms.int(dms["destiny_property_param"], id, destiny_property_param.addition_percent_attack)
	local addition_percent_physical_defence = dms.int(dms["destiny_property_param"], id, destiny_property_param.addition_percent_physical_defence)
	local addition_percent_skill_defence = dms.int(dms["destiny_property_param"], id, destiny_property_param.addition_percent_skill_defence)
	one:setString("+" .. addition_percent_attack/100 .. "%")
	two:setString("+" .. addition_percent_life/100 .. "%")
	three:setString("+" .. addition_percent_physical_defence/100 .. "%")
	four:setString("+" .. addition_percent_skill_defence/100 .. "%")
	-- 下级加成
	local maxSkillLevel = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
		maxSkillLevel = tonumber(dms.string(dms["pirates_config"],276,pirates_config.param))
	else
		maxSkillLevel = table.nums(skillInfos)
	end
	if tonumber(level) < maxSkillLevel then
		local nextLv = ccui.Helper:seekWidgetByName(self.roots[1], "Text_5_1")
		local nextOne = ccui.Helper:seekWidgetByName(self.roots[1], "Text_gongji_1")
		local nextTwo= ccui.Helper:seekWidgetByName(self.roots[1], "Text_shengming_1")
		local nextThree = ccui.Helper:seekWidgetByName(self.roots[1], "Text_wufang_1")
		local nextFour = ccui.Helper:seekWidgetByName(self.roots[1], "Text_mofang_1")
		local nextSkillName = ccui.Helper:seekWidgetByName(self.roots[1], "Text_jzjy_1")
		local nextSkillLv = ccui.Helper:seekWidgetByName(self.roots[1], "Text_jzjy_0_0")
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
			nextSkillName:setString(skillNamesTwo)
		else
			nextSkillId = skillInfos[tonumber(level) + 1]
			skillNamesTwo = dms.string(dms["skill_mould"], nextSkillId, skill_mould.skill_name)
			local name_table = zstring.split(skillNamesTwo,"L")
			nextSkillName:setString(name_table[1])
		end
		
		if verifySupportLanguage(_lua_release_language_en) == true then
			nextLv:setString(_All_tip_string_info._destiny.. _string_piece_info[6] .. (tonumber(level) + 1))
			nextSkillLv:setString(_string_piece_info[6]..(tonumber(level) + 1))
		else
			nextLv:setString(_All_tip_string_info._destiny .. tonumber(level) + 1 .. _string_piece_info[6])
			nextSkillLv:setString(tonumber(level) + 1 .. _string_piece_info[6])
		end
		
		local addition_percent_lifes = dms.int(dms["destiny_property_param"], id+1, destiny_property_param.addition_percent_life)
		local addition_percent_attacks = dms.int(dms["destiny_property_param"], id+1, destiny_property_param.addition_percent_attack)
		local addition_percent_physical_defences = dms.int(dms["destiny_property_param"], id+1, destiny_property_param.addition_percent_physical_defence)
		local addition_percent_skill_defences = dms.int(dms["destiny_property_param"], id+1, destiny_property_param.addition_percent_skill_defence)
		nextOne:setString("+" .. addition_percent_attacks/100 .. "%")
		nextTwo:setString("+" .. addition_percent_lifes/100 .. "%")
		nextThree:setString("+" .. addition_percent_physical_defences/100 .. "%")
		nextFour:setString("+" .. addition_percent_skill_defences/100 .. "%")
		ccui.Helper:seekWidgetByName(self.roots[1],"Panel_xiaji"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(self.roots[1],"Panel_xiaji"):setVisible(false)
	end
	
	local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
	self.prop = config[4]
	
	self.num = 0
	
	for i,v in pairs(_ED.user_prop) do
		if tonumber(v.user_prop_template) == tonumber(self.prop) then
			self.num = v.prop_number
		end
	end
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_59"):setString(self.num)				--当前拥有数量
	
	self.need = dms.int(dms["destiny_property_param"], id, destiny_property_param.consume_prop_count)
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_60_0"):setString(self.need)			--每次消耗的数量
	

	if tonumber(self.num) < tonumber(self.need) then
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_59"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
	else
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_59"):setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
	end	
	local loadingBar = ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_1")
	local loadingText = ccui.Helper:seekWidgetByName(self.roots[1], "Text_64_0")
	local expCount = tonumber(mynum)/tonumber(dms.int(dms["destiny_property_param"], id, destiny_property_param.level_up_need_prop_count))*100
	loadingBar:setPercent(expCount)
	loadingText:setString(mynum .. "/" .. dms.int(dms["destiny_property_param"], id, destiny_property_param.level_up_need_prop_count))
	
	local probability = ccui.Helper:seekWidgetByName(self.roots[1], "Text_62_0")
	if expCount <= 20 then
		probability:setString(_probabilityName[6])
		probability:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
	elseif 20 < expCount and expCount <= 50 then	
		probability:setString(_probabilityName[4])
		probability:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
	elseif 50 < expCount and expCount <= 80 then
		probability:setString(_probabilityName[3])
		probability:setColor(cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3]))
	elseif 81 < expCount and expCount <= 99.99 then
		probability:setString(_probabilityName[2])
		probability:setColor(cc.c3b(color_Type[4][1], color_Type[4][2], color_Type[4][3]))
	end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		-- local quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type)
		-- local lv =ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_lv")
		-- local lan=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_lan")
		-- local zi=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_zi")
		-- local cheng=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_cheng")
		-- local hong=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_hong")
		-- if quality == 0 then
		-- 	--print("白色")
		-- 	lv:setVisible(false)
		-- 	lan:setVisible(false)
		-- 	zi:setVisible(false)
		-- 	cheng:setVisible(false)
		-- 	hong:setVisible(false)
		-- elseif quality == 1 then
		-- 	--print("绿色")
		-- 	lv:setVisible(true)
		-- 	lan:setVisible(false)
		-- 	zi:setVisible(false)
		-- 	cheng:setVisible(false)
		-- 	hong:setVisible(false)
		-- elseif quality == 2 then
		-- 	--print("蓝色")
		-- 	lv:setVisible(false)
		-- 	lan:setVisible(true)
		-- 	zi:setVisible(false)
		-- 	cheng:setVisible(false)
		-- 	hong:setVisible(false)
		-- elseif quality == 3 then
		-- 	--print("紫色")
		-- 	lv:setVisible(false)
		-- 	lan:setVisible(false)
		-- 	zi:setVisible(true)
		-- 	cheng:setVisible(false)
		-- 	hong:setVisible(false)
		-- elseif quality == 4 then
		-- 	--print("橙色")
		-- 	lv:setVisible(false)
		-- 	lan:setVisible(false)
		-- 	zi:setVisible(false)
		-- 	cheng:setVisible(true)
		-- 	hong:setVisible(false)
		-- elseif quality == 5 then
		-- 	--print("红色")
		-- 	lv:setVisible(false)
		-- 	lan:setVisible(false)
		-- 	zi:setVisible(false)
		-- 	cheng:setVisible(false)
		-- 	hong:setVisible(true)			
		-- end
	end
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		if tonumber(level) >= table.nums(skillInfos) then
			loadingText:setString("0".. "/" .. "0")
			ccui.Helper:seekWidgetByName(self.roots[1], "Text_60_0"):setString(0)			--每次消耗的数量
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xiaji"):setVisible(false)			
		end
	end
---

end

function HeroSkillStrenPage:playShow( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self.actions[1]:play("window_open",false)
	end
end
function HeroSkillStrenPage:onEnterTransitionFinish()
	local csbGeneralsQianghua = csb.createNode("packs/HeroStorage/generals_tianming.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	-- root:removeFromParent(true)
	table.insert(self.roots, root)
	local action = csb.createTimeline("packs/HeroStorage/generals_tianming.csb")
	csbGeneralsQianghua:runAction(action)
	table.insert(self.actions,action)
	action:play("window_open", false)
	self:addChild(csbGeneralsQianghua)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		self:onUpdateDraw()
	end
	self.status = true
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
	
	local button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_9"), nil, 
	{
		terminal_name = "hero_skill_stren_page_go", 	
		next_terminal_name = "hero_skill_stren_page_go",
		_shipId = self.shipId,
		_num = self.num,
		_need = self.need,
		_propId = self.prop,
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)

	local function buttonOneTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()

		if ccui.TouchEventType.began == evenType then
			self.one = true
		elseif ccui.TouchEventType.moved == evenType then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			 or __lua_project_id == __lua_project_red_alert 
			 or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			 or __lua_project_id == __lua_project_yugioh
			 or __lua_project_id == __lua_project_warship_girl_b 
			 then
				if __mpoint.x - __spoint.x > 80 
					or __mpoint.x - __spoint.x < -80 
					or __mpoint.y - __spoint.y > 50 
					or __mpoint.y - __spoint.y < -50 
					then
					self.one = false
				end
			end
		elseif ccui.TouchEventType.ended == evenType then
			self.one = false
		end
	end
	button:addTouchEventListener(buttonOneTouchEvent)
	
end
function HeroSkillStrenPage:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local Panel_10 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_10")		
		if Panel_10 ~= nil then
			Panel_10:removeAllChildren(true)
		end
		cacher.destoryRefPool("packs/HeroStorage/generals_tianming.csb")
	end
	fwin:close(fwin:find("PropertyChangeTipInfoAnimationCellClass"))
end

function HeroSkillStrenPage:onExit()
	state_machine.remove("hero_skill_stren_page_go")
	state_machine.remove("hero_skill_stren_page_check_updata_by_other_page")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		if self.types == "formation" then
			local seq = fwin:find("UserInformationHeroStorageClass")
			if seq ~= nil then
				fwin:close(seq)
			end
		end
		self.status = false
		
		if fwin:find("UserInformationHeroStorageClass") ~= nil then
			if fwin:find("HeroFormationChoiceWearClass") ~= nil then
				fwin:close(fwin:find("UserInformationHeroStorageClass"))
			end
		end
	end
end

function HeroSkillStrenPage:init(shipId,types)
	self.shipId = shipId
	self.types = types
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self.falst = false
	end
end