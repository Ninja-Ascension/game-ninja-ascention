-- ----------------------------------------------------------------------------------------------------
-- 说明：武将重生界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
HeroRebornPage = class("HeroRebornPageClass", Window)

function HeroRebornPage:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.hero_instance = nil
	
	self.Panel_yingxiong = nil
	self.ArmatureNode_yingxiong = nil
	
    -- Initialize HeroRebornPage page state machine.
    local function init_hero_reborn_terminal()
		-- 重生界面初始化，包含清除当前武将处理
        local hero_reborn_init_terminal = {
            _name = "hero_reborn_init",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:displayTypeChange("no_hero")
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 选中武将时调用，显示武将图标，武将信息
		local hero_reborn_show_hero_info_terminal = {
            _name = "hero_reborn_show_hero_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:displayTypeChange("show_hero")
				
				local root = instance.roots[1]
				local hero_pad = ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Panel_10"):getChildByName("ProjectNode_1"):getChildByName("root")
				
				local heroInstance = params._datas.cell.heroInstance
				instance.hero_instance = heroInstance
				-- 绘制全身像
				local hero_data = dms.element(dms["ship_mould"], heroInstance.ship_template_id)
				local all_icon = dms.atoi(hero_data, ship_mould.All_icon)
				
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then			--龙虎门项目控制
					local Panel_wujiang=ccui.Helper:seekWidgetByName(hero_pad, "Panel_wujiang")
					local temp_bust_index = 0
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						then
						----------------------新的数码的形象------------------------
						--进化形象
						local evo_image = dms.string(dms["ship_mould"], heroInstance.ship_template_id, ship_mould.fitSkillTwo)
						local evo_info = zstring.split(evo_image, ",")
						--进化模板id
						local ship_evo = zstring.split(heroInstance.evolution_status, "|")
						local evo_mould_id = evo_info[tonumber(ship_evo[1])]
						--新的形象编号
						temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
					else
						temp_bust_index = dms.atoi(hero_data, ship_mould.bust_index)
					end
					-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
					-- local cell = ccs.Armature:create("spirte_" .. temp_bust_index)
					-- cell:getAnimation():playWithIndex(0)
					-- Panel_wujiang:removeAllChildren(true)
					-- Panel_wujiang:addChild(cell)
					-- -- cell:setAnchorPoint(cc.p(0.5, 0.5))
					-- -- cell:setPosition(cc.p(Panel_wujiang:getContentSize().width/2, Panel_wujiang:getContentSize().height/2))
					-- cell:setPosition(cc.p(Panel_wujiang:getContentSize().width/2, 0))
					ccui.Helper:seekWidgetByName(hero_pad, "Panel_31"):setVisible(true)

					
					Panel_wujiang:removeAllChildren(true)
					draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_wujiang, nil, nil, cc.p(0.5, 0))
					if animationMode == 1 then
						app.load("client.battle.fight.FightEnum")
						local shipSpine = sp.spine_sprite(Panel_wujiang, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
						if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					        shipSpine:setScaleX(-1)
					    end
					else
						draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", Panel_wujiang, -1, nil, nil, cc.p(0.5, 0))
					end
				else
					ccui.Helper:seekWidgetByName(hero_pad, "Panel_31"):setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", all_icon))
				end
				-- 绘制名称、突破等级
				local hero_rank_level = dms.atoi(hero_data, ship_mould.initial_rank_level)
				local hero_color = dms.atoi(hero_data, ship_mould.ship_type)
				local name_text = ccui.Helper:seekWidgetByName(hero_pad, "Text_65")
				name_text:setString(heroInstance.captain_name.."+"..hero_rank_level)
				name_text:setColor(cc.c3b(color_Type[hero_color+1][1],color_Type[hero_color+1][2],color_Type[hero_color+1][3]))
				
				local hero_level = heroInstance.ship_grade
				local hero_skill_level = heroInstance.ship_skillstren.skill_level
				local hero_skill_value = heroInstance.ship_skillstren.skill_value
				local config = zstring.split(dms.string(dms["pirates_config"], 181, pirates_config.param), ",")
				-- 绘制面板
				-- 元宝
				local money = config[1]
				if hero_color == 2 then
					money = config[2]
				elseif hero_color == 3 then
					money = config[3]
				elseif hero_color == 4 then
					money = config[4]
				elseif hero_color == 5 then
					money = config[5]
				end
				
				ccui.Helper:seekWidgetByName(root, "Text_money"):setString(money)
				
				-- 等级
				ccui.Helper:seekWidgetByName(root, "Text_lv_0"):setString(hero_level)
				
				-- 突破
				ccui.Helper:seekWidgetByName(root, "Text_tp_0"):setString("+"..hero_rank_level)
				
				-- 天命
				if verifySupportLanguage(_lua_release_language_en) == true then
					ccui.Helper:seekWidgetByName(root, "Text_tm_0"):setString(_string_piece_info[6]..hero_skill_level)
				else
					ccui.Helper:seekWidgetByName(root, "Text_tm_0"):setString(hero_skill_level.._string_piece_info[6])
				end
				
				-- 当前天命值
				ccui.Helper:seekWidgetByName(root, "Text_sm_0"):setString(hero_skill_value)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 武将重生请求
		local hero_reborn_request_reborn_terminal = {
            _name = "hero_reborn_request_reborn",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- 请求打开重生预览
				local function responseGetPreviewCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							response.node.Panel_yingxiong:setVisible(true)
							csb.animationChangeToAction(response.node.ArmatureNode_yingxiong, 0, 0, nil)
						end
						
						local previewWnd = ResolveReturnPreview:new()
						previewWnd:init(3, {response.node.hero_instance})
						fwin:open(previewWnd)
					end
				end
				--> print(instance.hero_instance.ship_id,"instance.hero_instance.ship_id---------------------")
				protocol_command.recycle_init.param_list = "".."2".."\r\n"..instance.hero_instance.ship_id
				NetworkManager:register(protocol_command.recycle_init.code, nil, nil, nil, instance, responseGetPreviewCallback, false, nil)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 选择重生武将
		local hero_reborn_choose_hero_terminal = {
            _name = "hero_reborn_choose_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local status = false
				for i,v in ipairs(self:sortHerosForReborn()) do
					status = true
				end
				if status == true then
					fwin:open(HeroChooseForReborn:new(), fwin._view)
				else
					TipDlg.drawTextDailog(_string_piece_info[227])
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--帮助
		local hero_reborn_open_helpdlg_terminal = {
            _name = "hero_reborn_open_helpdlg",
            _init = function (terminal) 
                app.load("client.refinery.TreasureInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = TreasureInfo:new()
				cell:init(3)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--重生完毕的刷新
		local hero_reborn_over_update_terminal = {
            _name = "hero_reborn_over_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				pushEffect(formatMusicFile("effect", 9993))
				
				state_machine.excute("hero_reborn_init", 0, "hero_reborn_init.")
				state_machine.excute("shop_window_update", 0, "shop_window_update.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(hero_reborn_init_terminal)
        state_machine.add(hero_reborn_show_hero_info_terminal)
        state_machine.add(hero_reborn_request_reborn_terminal)
        state_machine.add(hero_reborn_choose_hero_terminal)
        state_machine.add(hero_reborn_open_helpdlg_terminal)
        state_machine.add(hero_reborn_over_update_terminal)
        state_machine.init()
    end
    
    init_hero_reborn_terminal()
end

function HeroRebornPage:sortHerosForReborn()
	
	local function chooseHero()
		local list = {}
		local j = 1
		for i, v in pairs(_ED.user_ship) do
			local shipId = v.ship_id
			local shipData = dms.element(dms["ship_mould"], v.ship_template_id)
			local shipQuality = dms.atoi(shipData, ship_mould.ship_type)
			local shipRankLevel = dms.atoi(shipData, ship_mould.initial_rank_level) 
			local captain_type = dms.atoi(shipData, ship_mould.captain_type) 
			if tonumber(v.ship_base_template_id) < 1148 or tonumber(v.ship_base_template_id) > 1150 then
				if captain_type ~= 3 then 
				--不是宠物
					if shipQuality >= 2 and (zstring.tonumber(v.formation_index) == 0)
					  and (zstring.tonumber(v.little_partner_formation_index) == 0) then
						list[j] = v
						j = j+1
					end
				end
			end
		end
		return list
	end
	
	local function compare(a, b)
		local a_quality = dms.int(dms["ship_mould"], a.ship_template_id, ship_mould.ship_type)
		local b_quality = dms.int(dms["ship_mould"], b.ship_template_id, ship_mould.ship_type)
		if a_quality > b_quality then
			return false
		elseif a_quality == b_quality then
			if tonumber(a.ship_grade) > tonumber(b.ship_grade) then
				return false
			end
		end
		return true
	end
	
	local function sortList(list)
		local count = #list
		
		for i=1, count do
			for j=1, count-i do
				if compare(list[j], list[j+1]) == false then
					list[j], list[j+1] = list[j+1], list[j]
				end
			end
		end
		return list
	end
	
	return sortList(chooseHero())
end

function HeroRebornPage:displayTypeChange(_type)
	local root = self.roots[1]
	local hero_pad =  ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Panel_10"):getChildByName("ProjectNode_1"):getChildByName("root")

	if _type == "show_hero" then
		-- 显示属性面板
		ccui.Helper:seekWidgetByName(root, "Panel_28"):setVisible(true)
		-- 显示名称
		ccui.Helper:seekWidgetByName(hero_pad, "Image_26"):setVisible(true)
		-- 隐藏初始面板
		ccui.Helper:seekWidgetByName(root, "Panel_27"):setVisible(false)
		-- 隐藏“+”
		ccui.Helper:seekWidgetByName(hero_pad, "Image_33"):setVisible(false)
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			ccui.Helper:seekWidgetByName(hero_pad, "Panel_wujiang"):setVisible(true)
		elseif __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_warship_girl_b
			or __lua_project_id == __lua_project_yugioh
			then 
			ccui.Helper:seekWidgetByName(hero_pad, "Panel_2"):getChildByName("ArmatureNode_1"):setVisible(false)
		end
	elseif _type == "no_hero" then
		-- 清除属性面板
		ccui.Helper:seekWidgetByName(root, "Panel_28"):setVisible(false)
		-- 清除武将
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
		--print("showno--------------------")
			ccui.Helper:seekWidgetByName(hero_pad, "Panel_wujiang"):setVisible(false)
		else
			ccui.Helper:seekWidgetByName(hero_pad, "Panel_31"):removeBackGroundImage()
		end
		-- 隐藏名称
		ccui.Helper:seekWidgetByName(hero_pad, "Image_26"):setVisible(false)
		-- 显示初始面板
		ccui.Helper:seekWidgetByName(root, "Panel_27"):setVisible(true)
		-- 显示“+”
		ccui.Helper:seekWidgetByName(hero_pad, "Image_33"):setVisible(true)
		if __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_warship_girl_b
			or __lua_project_id == __lua_project_yugioh
			then 
			ccui.Helper:seekWidgetByName(hero_pad, "Panel_2"):getChildByName("ArmatureNode_1"):setVisible(true)
		end
	end
end

function HeroRebornPage:onEnterTransitionFinish()
	local csbhero_reborn = csb.createNode("refinery/refinery_gen_cs.csb")
	self:addChild(csbhero_reborn)
	local root = csbhero_reborn:getChildByName("root")
	table.insert(self.roots, root)
    local hero_pad = ccui.Helper:seekWidgetByName(root, "Panel_20"):getChildByName("Panel_10"):getChildByName("ProjectNode_1"):getChildByName("root")
	
	state_machine.excute("hero_reborn_init", 0, "hero_reborn_init.")
	
	--选择
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(hero_pad, "Panel_31"), nil, 
	{
		terminal_name = "hero_reborn_choose_hero"
	},
	nil, 0)
	
    --帮助
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_20"), nil, 
	{
		terminal_name = "hero_reborn_open_helpdlg", 
		isPressedActionEnabled = true
	},
	nil, 0)
	
	--重生
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_21"), nil, 
	{
		terminal_name = "hero_reborn_request_reborn", 
		isPressedActionEnabled = true
	},
	nil, 0)
	
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		-- 动画
		local function changeActionCallback(armatureBack)
			armatureBack:getParent():setVisible(false)
		end
		
		self.Panel_yingxiong=ccui.Helper:seekWidgetByName(hero_pad, "Panel_yingxiong")
		self.ArmatureNode_yingxiong = self.Panel_yingxiong:getChildByName("ArmatureNode_yingxiong")
		
		draw.initArmature(self.ArmatureNode_yingxiong, nil, -1, 0, 1)
		self.ArmatureNode_yingxiong:getAnimation():playWithIndex(0, 0, 0)
		self.ArmatureNode_yingxiong._invoke = changeActionCallback
	end
end

function HeroRebornPage:onExit()
	state_machine.remove("hero_reborn_init")
	state_machine.remove("hero_reborn_show_hero_info")
	state_machine.remove("hero_reborn_request_reborn")
	state_machine.remove("hero_reborn_choose_hero")
	state_machine.remove("hero_reborn_open_helpdlg")
	state_machine.remove("hero_reborn_over_update")
end
