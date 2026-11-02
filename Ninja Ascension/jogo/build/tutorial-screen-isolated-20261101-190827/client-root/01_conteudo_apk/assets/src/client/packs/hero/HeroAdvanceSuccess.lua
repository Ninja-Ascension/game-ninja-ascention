----------------------------------------------------------------------------------------------------
-- 说明：武将的小图标绘制
-------------------------------------------------------------------------------------------------------
HeroAdvanceSuccess = class("HeroAdvanceSuccessClass", Window)

function HeroAdvanceSuccess:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.actions = {}
	self._ship = nil					-- 卡片实例
	self._advancedBefore = {}			-- 前属性
	self._advancedBack = {}				-- 后属性
	self.keepOutPanel = {}				-- 遮挡层
	self.shipMouldFront = nil			-- 进阶前模板
	self.shipMouldBack = nil			-- 进阶前模板
	self.shopmould = nil				--真正的进阶前模板
	self._controlcount = 0
	

	app.load("client.cells.ship.ship_body_cell")
	-- 初始化武将小像事件响应需要使用的状态机
	local function init_hero_advance_success_terminal()
		
		-- 设计在升级界面，点击武将全身图像需要处理的逻辑
		local hero_advance_success_show_end_terminal = {
            _name = "hero_advance_success_show_end",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- if nil ~= instance.keepOutPanel then
					-- instance.keepOutPanel[1]:setVisible(true)
					-- instance.keepOutPanel[2]:setVisible(false)
				-- end
				if self._controlcount ~= 0 then
					return
				end	
				self._controlcount = self._controlcount + 1
				
				local action = nil
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					action = instance.actions[1]
					instance.actions[1]:play("advanced_show_over", false)
				else
					action = csb.createTimeline("packs/HeroStorage/generals_breakthrough.csb")
					action:play("advanced_show_over", false)
					instance.roots[1]:runAction(action)
				end
				action:setFrameEventCallFunc(function (frame)
					if nil == frame then
						return
					end
					
					local str = frame:getEvent()
					if str == "show_break_through_over" then
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then		
							if tonumber(instance._ship.captain_type) == 0 then
								state_machine.excute("hero_develop_update_hero",0,"")
							else
								state_machine.excute("hero_develop_hero_show",0,"")
							end
						end
						fwin:close(instance)
						state_machine.excute("hero_advanced_page_set_lock", 0, false)
						state_machine.excute("hero_advanced_page_Success_data_refresh", 0, "hero_advanced_page_Success_data_refresh.")
						local FormationWnd = nil
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							-- FormationWnd = fwin:find("FormationTigerGateClass")
						else
							FormationWnd = fwin:find("FormationClass")
							if FormationWnd ~= nil then
								FormationWnd:updateDrawPartnerView()
							end
						end
					elseif str == "close" then
					end
				
				end)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(hero_advance_success_show_end_terminal)		
        state_machine.init()
	end
	init_hero_advance_success_terminal()
end

function HeroAdvanceSuccess:onUpdateDraw() -- Text_45
	self.shipMouldFront = dms.element(dms["ship_mould"], self._ship.ship_template_id)
	local rankLevelBack = dms.atoi(self.shipMouldFront, ship_mould.initial_rank_level)  	--进阶后的进阶等级
	local rankLevelFront = rankLevelBack - 1												--进阶后的进阶等级
	local ship_name = nil											--战船名称
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], self._ship.ship_template_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        local ship_evo = zstring.split(self._ship.evolution_status, "|")
        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
		ship_name = word_info[3]
    else
		if dms.atoi(self.shipMouldFront, ship_mould.captain_type) == 0 then
			ship_name = _ED.user_info.user_name
			if ___is_open_leadname == true then
				local Text_5 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_5")
				Text_5:setFontName("")
				Text_5:setFontSize(Text_5:getFontSize())
			end
		else
			ship_name = dms.string(dms["ship_mould"], self.shopmould, ship_mould.captain_name)
		end
	end
	-- 进阶后的属性描述 rankLevelBack
	local talent_id = dms.atos(self.shipMouldFront, ship_mould.talent_id)  --进阶hou的进阶等级
	local talent_id_ship = zstring.zsplit(talent_id, "|")				--进阶的表
	local talent = zstring.zsplit(talent_id_ship[rankLevelBack], ",")
	local talent_name = dms.string(dms["talent_mould"], talent[3], talent_mould.talent_name)
	local talent_describe = dms.string(dms["talent_mould"], talent[3], talent_mould.talent_describe)
	
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_2"):setString(talent_name)					-- 进阶后解锁属性
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_4"):setString(talent_describe)				-- 进阶后解锁属性
	
	local ship_type = dms.atoi(self.shipMouldFront, ship_mould.ship_type) + 1
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_5"):setString(ship_name.. "+" .. rankLevelFront)		-- 进阶前名称
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_5"):setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type][1], tipStringInfo_quality_color_Type[ship_type][2], tipStringInfo_quality_color_Type[ship_type][3]))
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_45"):setString(self._advancedBefore[2])				-- 进阶前攻击
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_45_0"):setString(self._advancedBefore[3])				-- 进阶前生命
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_45_0_0"):setString(self._advancedBefore[4])			-- 进阶前物防
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_45_0_0_0"):setString(self._advancedBefore[5])			-- 进阶前法防
	
	local advancedMould = dms.element(dms["ship_mould"], dms.int(dms["ship_mould"], self.shopmould, ship_mould.grow_target_id))
	local advancedtype = dms.atoi(advancedMould, ship_mould.ship_type) + 1
	local advancedName = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], self._ship.ship_template_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        local ship_evo = zstring.split(self._ship.evolution_status, "|")
        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
		advancedName = word_info[3]
    else
		if dms.atoi(advancedMould, ship_mould.captain_type) == 0 then
			advancedName = _ED.user_info.user_name
			if ___is_open_leadname == true then
				local Text_6 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_6")
				Text_6:setFontName("")
				Text_6:setFontSize(Text_6:getFontSize())
			end
		else
			advancedName = dms.atos(advancedMould, ship_mould.captain_name)
		end
	end
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_6"):setString(advancedName.. "+" .. rankLevelBack)		-- 进阶后名称
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_6"):setColor(cc.c3b(tipStringInfo_quality_color_Type[advancedtype][1], tipStringInfo_quality_color_Type[advancedtype][2], tipStringInfo_quality_color_Type[advancedtype][3]))
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_41"):setString(tonumber(self._advancedBefore[2]) + tonumber(self._advancedBack[2]))	-- 进阶后攻击
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_42"):setString(tonumber(self._advancedBefore[3]) + tonumber(self._advancedBack[3]))	-- 进阶后生命
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_42_0"):setString(tonumber(self._advancedBefore[4]) + tonumber(self._advancedBack[4]))	-- 进阶后物防
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_42_0_0"):setString(tonumber(self._advancedBefore[5]) + tonumber(self._advancedBack[5])) -- 进阶后法防
	
	--武将全身像后
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		local shipCell = LformationChangeHeroCell:createCell()
		shipCell:init(self._ship,2)--10强化成功后的调用type 为 2
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_hero_tupo"):addChild(shipCell)
	else
		local shipCell = ShipBodyCell:createCell()
		shipCell:init(self._ship, 0)
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_hero_tupo"):addChild(shipCell)				-- 放置武将突破
	end
end

function HeroAdvanceSuccess:onEnterTransitionFinish()
	local csbItem = csb.createNode("packs/HeroStorage/generals_breakthrough.csb")
	local root = nil
	root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	-- local action = csb.createTimeline("packs/HeroStorage/generals_breakthrough.csb")
	-- root:runAction(action)
	-- action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	local shipactive = ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_jinhua/effect_jinhua.ExportJson")
	local cell = ccs.Armature:create("effect_jinhua")
	cell:getAnimation():playWithIndex(0)
	local heroPanel = ccui.Helper:seekWidgetByName(root, "Panel_wj_tp")
	heroPanel:addChild(cell)
	-- cell:setAnchorPoint(cc.p(0.5, 0.5))
	cell:setPosition(cc.p(heroPanel:getContentSize().width/2, heroPanel:getContentSize().height/2))
			
	local action = csb.createTimeline("packs/HeroStorage/generals_breakthrough.csb")
	action:play("advanced_show", false)
	root:runAction(action)
	table.insert(self.actions,action)
	action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end
		
		local str = frame:getEvent()
		if str == "information_popup_over" then
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_14"), nil, {terminal_name = "hero_advance_success_show_end"}, nil, 0)
		elseif str == "close" then
		end
		
		end)
	
	self:onUpdateDraw()
	playEffectForAbilityUp()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		state_machine.excute("hero_develop_hero_hide",0,"")
	end
end

function HeroAdvanceSuccess:close( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local Panel_hero_tupo = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_hero_tupo")
		if Panel_hero_tupo ~= nil then
			Panel_hero_tupo:removeAllChildren(true)
		end
	end
	-- body
end
function HeroAdvanceSuccess:onExit()
	self._controlcount = 0
	state_machine.remove("hero_advance_success_show_end")
end

function HeroAdvanceSuccess:init(_ship, _advancedBefore, _advancedBack, keepOutPanel , shopmould)
	self._ship = _ship
	self._advancedBefore = _advancedBefore
	self._advancedBack = _advancedBack
	self.keepOutPanel = keepOutPanel
	self.shopmould = shopmould
end

