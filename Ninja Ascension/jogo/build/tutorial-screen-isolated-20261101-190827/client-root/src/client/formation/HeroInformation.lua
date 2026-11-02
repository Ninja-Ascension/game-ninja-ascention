-- ----------------------------------------------------------------------------------------------------
-- 说明：武将信息面板显示
-- 创建时间
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

HeroInformation = class("HeroInformationClass", Window)

HeroInformation.__userHeroFontName = nil
local hero_information_open_window_terminal = {
    _name = "hero_information_open_window",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local ship = params[1]
    	local enter_type = params[2]
    	if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_legendary_game
			then
    		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
    			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
    			then
    		else
	    		app.load("client.packs.hero.HeroDevelop")
	    		if fwin:find("HeroDevelopClass") ~= nil then
	    			state_machine.excute("formation_set_ship",0,ship)
	    			return
	    			-- fwin:close(fwin:find("HeroDevelopClass"))
	    		end
				local heroDevelopWindow = HeroDevelop:new()
				if ship == -1 then
					ship = _ED.user_ship[_ED.user_formetion_status[1]]
					enter_type = "learn"
				end
			if __lua_project_id ==__lua_project_gragon_tiger_gate then
				ship.shengming = zstring.tonumber(ship.ship_health)
				ship.gongji = zstring.tonumber(ship.ship_courage)
				ship.waigong = zstring.tonumber(ship.ship_intellect)
				ship.neigong = zstring.tonumber(ship.ship_quick)
			end
				-- print("=======11=====",enter_type)
				if enter_type ~= "learn" and enter_type ~= "pack" then
					enter_type = "formation"
				end
				for i,v in pairs(_ED.user_formetion_status) do
					if zstring.tonumber(v) == tonumber(ship.ship_id) then
						enter_type = "formation"
					end
				end
				heroDevelopWindow:init(ship.ship_id, enter_type)
				fwin:open(heroDevelopWindow, fwin._viewdialog)
			end


			function openlist( ... )
				app.load("client.packs.hero.HeroIconListView")
				state_machine.excute("hero_icon_listview_open",0,ship)
				state_machine.excute("hero_icon_listview_first_set_index",0,ship)			
			end
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                then
            else
				cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
				cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,openlist,instance)		
			end	
			if enter_type == "learn" then
				state_machine.excute("hero_develop_page_manager", 0, 
					{
						_datas = {
							terminal_name = "hero_develop_page_manager", 	
							next_terminal_name = "hero_develop_page_open_skill_stren_page", 
							current_button_name = "Button_tianming",
							but_image = "", 		
							heroInstance = ship,
							terminal_state = 0,
							openWinId = 4,
							isPressedActionEnabled = false
						}
					}
				)

			elseif enter_type == "pack" then
				state_machine.excute("hero_develop_page_manager", 0, 
					{
						_datas = {
							terminal_name = "hero_develop_page_manager", 	
							next_terminal_name = "hero_develop_page_open_hero_information_page", 
							current_button_name = "Button_xinxi",
							but_image = "", 		
							heroInstance = ship,
							terminal_state = 0,
							openWinId = -1,
							isPressedActionEnabled = false
						}
					}
				)	
			else
				state_machine.excute("hero_develop_page_manager", 0, 
					{
						_datas = {
							terminal_name = "hero_develop_page_manager", 	
							next_terminal_name = "hero_develop_page_show_equip", 
							current_button_name = "Button_zhuangbei",
							but_image = "", 		
							heroInstance = ship,
							terminal_state = 0,
							openWinId = 7,
							isPressedActionEnabled = false
						}
					}
				)	
			end

			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                then
				openlist()
			end

			-- function openlist( ... )
			-- 	app.load("client.packs.hero.HeroIconListView")
			-- 	state_machine.excute("hero_icon_listview_open",0,"")
			-- 	if types == "formation" then
			-- 		if tonumber(ship.captain_type) == 0 then
			-- 			state_machine.excute("hero_icon_list_view_get_developpage",0,3)
			-- 		else
			-- 			state_machine.excute("hero_icon_list_view_get_developpage",0,2)
			-- 		end
			-- 	end
			-- 	state_machine.excute("hero_icon_listview_first_set_index",0,ship)
			-- 	if fwin:find("UserInformationHeroStorageClass") == nil then
			-- 		fwin:open(UserInformationHeroStorage:new(),fwin._ui)
			-- 	else
			-- 		fwin:close(fwin:find("UserInformationHeroStorageClass"))
			-- 		fwin:open(UserInformationHeroStorage:new(),fwin._ui)
			-- 	end				
			-- end
			-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
			-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,openlist,instance)
			-- if types == "formation" then
			-- 	if tonumber(ship.captain_type) == 0 then
			-- 		state_machine.excute("hero_develop_page_manager", 0, 
			-- 			{
			-- 				_datas = {
			-- 					terminal_name = "hero_develop_page_manager", 	
			-- 					next_terminal_name = "hero_develop_page_open_advanced", 
			-- 					current_button_name = "Button_tupo",
			-- 					but_image = "", 		
			-- 					heroInstance = ship,
			-- 					terminal_state = 0,
			-- 					openWinId = 34,
			-- 					isPressedActionEnabled = false
			-- 				}
			-- 			}
			-- 		)
			-- 	else
			-- 		state_machine.excute("hero_develop_page_manager", 0, 
			-- 			{
			-- 				_datas = {
			-- 					terminal_name = "hero_develop_page_manager", 	
			-- 					next_terminal_name = "hero_develop_page_open_strengthen_page", 
			-- 					current_button_name = "Button_shengji",
			-- 					but_image = "", 		
			-- 					heroInstance = ship,
			-- 					terminal_state = 0,
			-- 					openWinId = 33,
			-- 					isPressedActionEnabled = false
			-- 				}
			-- 			}
			-- 		)
			-- 	end
			-- elseif types == "learn" then
			-- 	state_machine.excute("hero_develop_page_manager", 0, 
			-- 		{
			-- 			_datas = {
			-- 				terminal_name = "hero_develop_page_manager", 	
			-- 				next_terminal_name = "hero_develop_page_open_skill_stren_page", 
			-- 				current_button_name = "Button_tianming",
			-- 				but_image = "", 		
			-- 				heroInstance = ship,
			-- 				terminal_state = 0,
			-- 				openWinId = 4,
			-- 				isPressedActionEnabled = false
			-- 			}
			-- 		}
			-- 	)							
			-- else
			-- 	state_machine.excute("hero_develop_page_manager", 0, 
			-- 		{
			-- 			_datas = {
			-- 				terminal_name = "hero_develop_page_manager", 	
			-- 				next_terminal_name = "hero_develop_page_open_hero_information_page", 
			-- 				current_button_name = "Button_xinxi",
			-- 				but_image = "", 		
			-- 				heroInstance = ship,
			-- 				terminal_state = 0,
			-- 				openWinId = -1,
			-- 				isPressedActionEnabled = false
			-- 			}
			-- 		}
			-- 	)			
			-- end
    	else
    		if ship == nil then
    			ship = params
    		end
			local heroInfo = HeroInformation:new()
			heroInfo:init(ship)
			fwin:open(heroInfo, fwin._ui) 
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(hero_information_open_window_terminal)	
state_machine.init()
    
function HeroInformation:ctor()
    self.super:ctor()
	
	app.load("client.cells.ship.ship_hero_base_information_cell")
	app.load("client.cells.ship.ship_hero_skill_cell")
	app.load("client.cells.ship.ship_hero_skill_temp_cell")
	app.load("client.cells.ship.ship_hero_destiny_cell")
	app.load("client.cells.ship.ship_hero_luck_talent_explain_cell")
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.actions = {}

	self.hero = nil
	
	self.current_type = 0
	self.enum_type = {
		_SHIP_MOULD = 1,				-- ship
		_ENVIRONMENT_SHIP = 2,			-- npc
	}
	
    -- Initialize HeroInformation state machine.
    local function init_HeroInformation_terminal()
		local hero_information_close_terminal = {
            _name = "hero_information_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(instance)	--关闭自己	
                --fwin:close(fwin:find("HeroInformationClass"))	--?这里为什么要关两次？
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		--英雄成长界面
		local hero_formation_show_hero_develop_page_terminal = {
            _name = "hero_formation_show_hero_develop_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				--> print(params)
				-- app.load("client.develop.HeroDevelop")
				-- fwin:open(HeroDevelop:new(), fwin._viewdialog)				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		--英雄音效播放按钮
		local hero_formation_play_hero_music_terminal = {
            _name = "hero_formation_play_hero_music",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local tempMusicIndex = dms.int(dms["ship_mould"], instance.hero.ship_template_id, ship_mould.sound_index)
					--> print("33333333333333333333333333333333333333333333333", self.hero.ship_template_id,tempMusicIndex)
					if tempMusicIndex ~= nil and tempMusicIndex > 0  then
						playEffect(formatMusicFile("effect", tempMusicIndex))
					end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		
		--更换英雄按钮
		local hero_formation_chick_replace_hero_terminal = {
            _name = "hero_formation_chick_replace_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				--> print(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        local hero_formation_update_terminal = {
            _name = "hero_formation_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	--print("更新英雄信息")
				self:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	
		state_machine.add(hero_information_close_terminal)	
		state_machine.add(hero_formation_show_hero_develop_page_terminal)	
		state_machine.add(hero_formation_play_hero_music_terminal)	
		state_machine.add(hero_formation_chick_replace_hero_terminal)
		state_machine.add(hero_formation_update_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_HeroInformation_terminal()
end

function HeroInformation:formatData()

	local data = {}
	if self.enum_type._SHIP_MOULD == self.current_type  then
		data.quality = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.ship_type)
		data.camp = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.capacity)
		data.heroType = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.camp_preference)
		data.ability = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.ability)
		data.rankLevelFront = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.initial_rank_level)
		data.AllIcon = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.All_icon)
		data.captain_type = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.captain_type)
		data.relationship_count = self.hero.relationship_count	
		data.talent_count = self.hero.talent_count	
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			data.temp_bust_index = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.bust_index)
		end
	elseif self.enum_type._ENVIRONMENT_SHIP == self.current_type  then
		local mouldId = self.hero.ship_template_id
		data.quality = dms.int(dms["environment_ship"], mouldId, environment_ship.ship_type)
		data.camp = dms.int(dms["environment_ship"], mouldId, environment_ship.capacity)
		data.heroType = dms.int(dms["environment_ship"], mouldId, environment_ship.camp_preference)
		data.ability = dms.int(dms["environment_ship"], mouldId, ship_mould.ability)
		data.rankLevelFront = 1--dms.int(dms["environment_ship"], mouldId, environment_ship.initial_rank_level)
		data.AllIcon = dms.int(dms["environment_ship"], mouldId, environment_ship.bust_index)
		data.captain_type = dms.int(dms["environment_ship"], mouldId, environment_ship.captain_type)
		data.relationship_count = 0
		data.talent_count = 0
		--talent_mould 取天赋
		-- local talent_mould = dms.string(dms["environment_ship"], mouldId, environment_ship.talent_mould)
		--> print("talent_mould---",talent_mould)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
			data.temp_bust_index = dms.int(dms["environment_ship"], mouldId, environment_ship.bust_index)
		end
	else

	end
	return data
end

function HeroInformation:playShow( ... )
	self.actions[1]:play("window_open",false)	
end
function HeroInformation:onUpdateDraw()
	local root = self.roots[1]
	
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")			--武将名字
	local Panel_pinz = ccui.Helper:seekWidgetByName(root, "Panel_wujiang_pu2")			--白将贴图
	local Text_zizhi = ccui.Helper:seekWidgetByName(root, "Text_zizhi")			--“资质”
	local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")			--ListView
	local panelWujiang = ccui.Helper:seekWidgetByName(root, "Panel_wujiang")
	local Text_zizhi_0 = ccui.Helper:seekWidgetByName(root, "Text_zizhi_0") --资质
	local text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv") --突破等级
	
	
	local data = self:formatData()
	local quality = data.quality
	local camp = data.camp
	local heroType = data.heroType
	local ability = data.ability
	local rankLevelFront = data.rankLevelFront
	local AllIcon = data.AllIcon
	local captain_type = data.captain_type
	local level=data.ship_grade
	ccui.Helper:seekWidgetByName(root, "Panel_pinz"):removeBackGroundImage()
	ccui.Helper:seekWidgetByName(root, "Panel_pinz"):setBackGroundImage(string.format("images/ui/quality/hero_name_quality_%d.png", quality))
	
	if heroType == 0 then
	elseif heroType == 1 then
		ccui.Helper:seekWidgetByName(root, "Panel_neixing_0"):setBackGroundImage("images/ui/quality/leixing_1.png")
	elseif heroType == 2 then
		ccui.Helper:seekWidgetByName(root, "Panel_neixing_0"):setBackGroundImage("images/ui/quality/leixing_2.png")
	elseif heroType == 3 then
		ccui.Helper:seekWidgetByName(root, "Panel_neixing_0"):setBackGroundImage("images/ui/quality/leixing_3.png")
	elseif heroType == 4 then
		ccui.Helper:seekWidgetByName(root, "Panel_neixing_0"):setBackGroundImage("images/ui/quality/leixing_4.png")
	end 
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		if camp == 0 then
		elseif camp == 1 then
			ccui.Helper:seekWidgetByName(root, "Panel_neixing"):setBackGroundImage("images/ui/quality/pve_leixing_1.png")
		elseif camp == 2 then
			ccui.Helper:seekWidgetByName(root, "Panel_neixing"):setBackGroundImage("images/ui/quality/pve_leixing_2.png")
		elseif camp == 3 then
			ccui.Helper:seekWidgetByName(root, "Panel_neixing"):setBackGroundImage("images/ui/quality/pve_leixing_3.png")
		elseif camp == 4 then
			ccui.Helper:seekWidgetByName(root, "Panel_neixing"):setBackGroundImage("images/ui/quality/pve_leixing_4.png")
		end 
	end 
	
	
	if quality == 0 then
		ccui.Helper:seekWidgetByName(root, "Panel_pinz"):setBackGroundImage("images/ui/quality/xinxi_baijiang.png")	--白将
	elseif quality == 1 then
		ccui.Helper:seekWidgetByName(root, "Panel_pinz"):setBackGroundImage("images/ui/quality/xinxi_lvjiang.png")	--绿将
	elseif quality == 2 then
		ccui.Helper:seekWidgetByName(root, "Panel_pinz"):setBackGroundImage("images/ui/quality/xinxi_lanjiang.png")	--蓝将
	elseif quality == 3 then
		ccui.Helper:seekWidgetByName(root, "Panel_pinz"):setBackGroundImage("images/ui/quality/xinxi_zijiang.png")	--紫将
	elseif quality == 4 then
		ccui.Helper:seekWidgetByName(root, "Panel_pinz"):setBackGroundImage("images/ui/quality/xinxi_hongjiang.png")--红将
	elseif quality == 5 then
		ccui.Helper:seekWidgetByName(root, "Panel_pinz"):setBackGroundImage("images/ui/quality/xinxi_jinjiang.png")	--金将
	end 
	
	
	-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	-- 	local lv =ccui.Helper:seekWidgetByName(root, "Panel_pzgz_lv")
	-- 	local lan=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_lan")
	-- 	local zi=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_zi")
	-- 	local cheng=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_cheng")
	-- 	local hong=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_hong")
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
	
	
	
		--数码宝贝进化形象
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		local ship_basic = dms.int(dms["ship_mould"], tonumber(self.hero.ship_template_id), ship_mould.base_mould)
		local current_ship = ship_basic
		for i=1,4 do
			local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_role_jh_" .. i)
			rolePanel:removeBackGroundImage()
			rolePanel:removeAllChildren(true)
			local imgIcon = ccui.Helper:seekWidgetByName(root, "Image_jt_" .. (i - 1))
			if imgIcon ~= nil then
				imgIcon:setVisible(false)
			end
			local next_ship_id = dms.int(dms["ship_mould"], current_ship, ship_mould.way_of_gain)
			if current_ship ~= -1 and current_ship ~= nil then
				local AllIcon = dms.int(dms["ship_mould"], current_ship, ship_mould.All_icon)
				rolePanel:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", AllIcon))
				if imgIcon ~= nil then
					imgIcon:setVisible(true)
				end
			end
			current_ship = next_ship_id
		end
	end

	if __lua_project_id == __lua_project_yugioh then
		local Panel_shuxing = ccui.Helper:seekWidgetByName(root, "Panel_shuxing")
		local Panel_zhongzu = ccui.Helper:seekWidgetByName(root, "Panel_zhongzu")
		Panel_shuxing:removeBackGroundImage()
		Panel_zhongzu:removeBackGroundImage()
		local faction_id = dms.string(dms["ship_mould"], self.hero.ship_template_id, ship_mould.faction_id)
		local attribute_id = dms.string(dms["ship_mould"], self.hero.ship_template_id, ship_mould.attribute_id)
		Panel_shuxing:setBackGroundImage(string.format("images/ui/quality/shuxing_%s.png", attribute_id))
		Panel_zhongzu:setBackGroundImage(string.format("images/ui/quality/zhongzu_%s.png", faction_id))
	end	
	
	Text_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	if ___is_open_leadname == true then
		if HeroInformation.__userHeroFontName == nil then
			HeroInformation.__userHeroFontName = Text_name:getFontName()
		end
		if captain_type == 0 then
			Text_name:setFontName("")
			Text_name:setFontSize(Text_name:getFontSize())-->设置字体大小
		else
			Text_name:setFontName(HeroInformation.__userHeroFontName)
		end
	end
	if captain_type == 0 then
		Text_name:setString(_ED.user_info.user_name)
	else
		Text_name:setString(self.hero.captain_name)
	end
	
	--local rankLevelFront = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.initial_rank_level)
	
	if rankLevelFront ~= 0 then
		text_lv:setString(" +"..rankLevelFront)
		text_lv:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	end
	Text_zizhi:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	if __lua_project_id == __lua_project_yugioh then
		for i=1,12 do
			local Panel_start = ccui.Helper:seekWidgetByName(root, "Panel_start_"..i)
			Panel_start:removeBackGroundImage()
			if i <= tonumber(ability) then
				Panel_start:setBackGroundImage("images/ui/state/zizhi.png")
			end
		end
	else
		Text_zizhi_0:setString(ability)
		Text_zizhi_0:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	end
	--local AllIcon = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.All_icon)
	
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. data.temp_bust_index .. ".ExportJson")
		-- local cell = ccs.Armature:create("spirte_" .. data.temp_bust_index)
		-- cell:getAnimation():playWithIndex(0)
		-- panelWujiang:removeAllChildren(true)
		-- panelWujiang:addChild(cell)
		-- -- cell:setAnchorPoint(cc.p(0.5, 0.5))
		-- -- cell:setPosition(cc.p(panelWujiang:getContentSize().width/2, panelWujiang:getContentSize().height/2))
		-- cell:setPosition(cc.p(panelWujiang:getContentSize().width/2, 0))

		-- local temp_bust_index = data.temp_bust_index
		-- local shipPanel = panelWujiang
		-- shipPanel:removeAllChildren(true)
		-- -- draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
		-- if animationMode == 1 then
		-- 	app.load("client.battle.fight.FightEnum")
		-- 	sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
		-- else
		-- 	draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0))
		-- end

		local Text_dj_1 = ccui.Helper:seekWidgetByName(root, "Text_dj_1") 
		Text_dj_1:setString(self.hero.ship_grade)
	else
		
		if __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			then 
			panelWujiang:removeAllChildren(true)
			app.load("client.cells.ship.ship_body_cell")
			local cell = ShipBodyCell:createCell()
			cell:init({ship_template_id = self.hero.ship_template_id},5)
			panelWujiang:addChild(cell)
		else
			panelWujiang:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", AllIcon))
		end
		
	end
	
	---------缘分
	local drawLot = {}
	local number = data.relationship_count						-- 缘分数量
	for i = 1, number do
		drawLot[i] = {}
		local relationship_id = self.hero.relationship[i].relationship_id		--缘分id
		local relationship_status = self.hero.relationship[i].is_activited			--是否激活
		local relationship_name = dms.string(dms["fate_relationship_mould"], relationship_id, fate_relationship_mould.relation_name)
		local relationship_describe = dms.string(dms["fate_relationship_mould"], relationship_id, fate_relationship_mould.relation_describe)
		drawLot[i][1] = relationship_status
		drawLot[i][2] = relationship_name
		drawLot[i][3] = relationship_describe
	end
	---------天赋
	local drawTalent = {}
	local tembNumber = data.talent_count								-- 天赋数量
	for i = 1, tembNumber do
		drawTalent[i] = {}
		local talent_id = self.hero.talents[i].talent_id		--缘分id
		local talent_status = self.hero.talents[i].is_activited			--是否激活
		local talent_name = dms.string(dms["talent_mould"], talent_id, talent_mould.talent_name)
		local talent_describe = dms.string(dms["talent_mould"], talent_id, talent_mould.talent_describe)
		drawTalent[i][1] = talent_status
		drawTalent[i][2] = talent_name
		drawTalent[i][3] = talent_describe
	end
	
	---------
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self:stopAllActions()
		ListView_1:removeAllChildren(true)
	end
	if self.enum_type._SHIP_MOULD == self.current_type  then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			-- for i =1, 6 do
				local index = 1
				function addcell(i)
					if i > 6 then
						self:stopAllActions()
						return
					end					
					if i == 1 then
						local cell = HeroBaseInformation:createCell()
						cell:init(self.hero)
						ListView_1:addChild(cell)
					elseif i == 2 then
						local cell = FormationHeroSkill:createCell()
						cell:init(self.hero)
						ListView_1:addChild(cell)
					-- elseif i == 3 then
						-- local cell = FormationHeroDestiny:createCell()
						-- cell:init(self.hero)
						-- ListView_1:addChild(cell)
					elseif i == 4 then
						local cell = HeroLuckTalentExplain:createCell()
						cell:init(self.hero,i,drawLot)
						ListView_1:addChild(cell)
						local cellSize = cell:getContentSize()
						cellSize.height = cellSize.height + 8
						cell:setContentSize(cellSize)
					elseif i == 5 then
						local cell = HeroLuckTalentExplain:createCell()
						cell:init(self.hero,i,drawTalent)
						ListView_1:addChild(cell)
						local cellSize = cell:getContentSize()
						cellSize.height = cellSize.height + 17
						cell:setContentSize(cellSize)
					elseif i == 6 then
						local cell = HeroLuckTalentExplain:createCell()
						cell:init(self.hero,i,nil)
						ListView_1:addChild(cell)
						local cellSize = cell:getContentSize()
						cellSize.height = cellSize.height + 17
						cell:setContentSize(cellSize)
					end
					ListView_1:requestRefreshView()
				end
				-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
				-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg,addcell,self)
				local se = cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(function(sender)
					addcell(index)
					index = index + 1
					end))
				self:runAction(cc.RepeatForever:create(se))
		else
			for i =1, 6 do
				if i == 1 then
					local cell = HeroBaseInformation:createCell()
					cell:init(self.hero)
					ListView_1:addChild(cell)
				elseif i == 2 then
					local cell = FormationHeroSkill:createCell()
					cell:init(self.hero)
					ListView_1:addChild(cell)
				elseif i == 3 then
					local cell = FormationHeroDestiny:createCell()
					cell:init(self.hero)
					ListView_1:addChild(cell)
				elseif i == 4 then
					local cell = HeroLuckTalentExplain:createCell()
					cell:init(self.hero,i,drawLot)
					ListView_1:addChild(cell)
					local cellSize = cell:getContentSize()
					cellSize.height = cellSize.height + 8
					cell:setContentSize(cellSize)
				elseif i == 5 then
					local cell = HeroLuckTalentExplain:createCell()
					cell:init(self.hero,i,drawTalent)
					ListView_1:addChild(cell)
					local cellSize = cell:getContentSize()
					cellSize.height = cellSize.height + 17
					cell:setContentSize(cellSize)
				elseif i == 6 then
					local cell = HeroLuckTalentExplain:createCell()
					cell:init(self.hero,i,nil)
					ListView_1:addChild(cell)
					local cellSize = cell:getContentSize()
					cellSize.height = cellSize.height + 17
					cell:setContentSize(cellSize)
				end
			end			
		end
	end
end


function HeroInformation:onEnterTransitionFinish()
    local csbGeneralsInformation_1 = csb.createNode("packs/HeroStorage/generals_information_2.csb")
	local root = csbGeneralsInformation_1:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_1)
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local action = csb.createTimeline("packs/HeroStorage/generals_information_2.csb")
		table.insert(self.actions,action)
		action:play("window_open", false)
		root:runAction(action)    
    else
		self:onUpdateDraw()
	end
	local return_line_up = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1077"), nil, {func_string = [[state_machine.excute("hero_information_close", 0, "click hero_information_close.'")]], isPressedActionEnabled = true}, nil, 2)
	
	local horn = ccui.Helper:seekWidgetByName(root, "Button_1")
	fwin:addTouchEventListener(horn, nil, 
	{
		func_string = [[state_machine.excute("hero_formation_play_hero_music", 0, "hero_formation_play_hero_music.'")]], 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	if true ~= hasShipSound(self.hero.ship_template_id) then
		horn:setVisible(false)
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {func_string = [[state_machine.excute("hero_formation_chick_replace_hero", 0, "hero_formation_chick_replace_hero.'")]], isPressedActionEnabled = true}, nil, 0)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		

		if fwin:find("UserInformationHeroStorageClass") == nil then
			fwin:open(UserInformationHeroStorage:new(),fwin._ui)
		else
			fwin:close(fwin:find("UserInformationHeroStorageClass"))
			fwin:open(UserInformationHeroStorage:new(),fwin._ui)
		end

		-- 将角色信息界面的功能按钮取消掉
		-- if dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.captain_type) == 0 then 
		-- 	ccui.Helper:seekWidgetByName(root, "Button_16"):setBright(false)
		-- 	ccui.Helper:seekWidgetByName(root, "Button_16"):setTouchEnabled(false)
		-- end
		-- --升级
		-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_16"), nil, 
		-- {
		-- 	terminal_name = "hero_formation_show_Level_up_page",
		-- 	terminal_state = 0,
		-- 	_ship_id = self.hero.ship_id,
		-- 	isPressedActionEnabled = true
		-- }, 
		-- nil, 0)
		
		-- --突破
		-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_26"), nil, 
		-- {
		-- 	terminal_name = "hero_formation_show_break_page",
		-- 	terminal_state = 0,
		-- 	_ship_id = self.hero.ship_id,
		-- 	isPressedActionEnabled = true
		-- }, nil, 0)
		-- --培养
		-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_36"), nil, 
		-- {
		-- 	terminal_name = "hero_formation_show_develop_page",
		-- 	terminal_state = 0,
		-- 	_ship_id = self.hero.ship_id,
		-- 	isPressedActionEnabled = true
		-- }, nil, 0)
	end
end
function HeroInformation:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local ListView_1 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")			--ListView
		local panelWujiang = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang")
		if ListView_1 ~= nil then
			ListView_1:removeAllItems()
		end
		if panelWujiang ~= nil then
			panelWujiang:removeAllChildren(true)
		end
		ccs.GUIReader:destroyInstance()
		ccs.ActionManagerEx:destroyInstance()
		ccs.ActionTimelineCache:destroyInstance()
		ccs.ArmatureDataManager:destroyInstance()
		cc.Director:getInstance():getTextureCache():removeUnusedTextures()
		cc.Director:getInstance():purgeCachedData()
		cc.GLProgramCache:destroyInstance()
		cacher.destoryRefPool("packs/HeroStorage/generals_information_2.csb")
	end
end
function HeroInformation:onExit()
	state_machine.remove("hero_information_close")
	state_machine.remove("hero_formation_show_hero_develop_page")
	state_machine.remove("hero_formation_play_hero_music")
	state_machine.remove("hero_formation_chick_replace_hero")
	state_machine.remove("hero_formation_update")
end

--在抢夺中,调用这里的武将信息查看,是在另一张表里.所以修改下参数,传个表的类型进来
--mould_type : int 表名类型
function HeroInformation:init(hero, mould_type)
	self.hero = hero
	if nil == mould_type then
		mould_type = 1
	end
	self.current_type = mould_type
end

