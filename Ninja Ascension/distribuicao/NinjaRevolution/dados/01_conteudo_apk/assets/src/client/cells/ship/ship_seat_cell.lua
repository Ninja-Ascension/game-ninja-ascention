---------------------------------
---说明：武将信息选项卡
-- 创建时间:2015.03.16
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
---------------------------------
HeroSeatCell = class("HeroSeatCellClass", Window)
HeroSeatCell.__size = nil
HeroSeatCell.__userHeroFontName = nil
function HeroSeatCell:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.heroInstance = nil
	self.num = nil
	app.load("client.cells.ship.ship_head_new_cell")
    local function init_HeroSeat_terminal()
	
		local hero_seat_update_terminal = {
            _name = "hero_seat_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				params:onUpdateDraw()


                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 拉回弹框
		local hero_storage_show_listview_bounce_terminal = {
            _name = "hero_storage_show_listview_bounce",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("ship_expansion_action_start", 0, {_datas = {cell = params._datas}})
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(hero_seat_update_terminal)
		state_machine.add(hero_storage_show_listview_bounce_terminal)
        state_machine.init()
    end
    
    init_HeroSeat_terminal()
end

function HeroSeatCell:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then
		--cell 在unload状态，没有root
		return
	end
	local hero_mould_id = self.heroInstance.ship_template_id
	local hero_data = dms.element(dms["ship_mould"], hero_mould_id)
	
	local hero_head = ShipHeadNewCell:createCell()
	hero_head:init(self.heroInstance,hero_head.enum_type._SHOW_SHIP_INFORMATION)
	local hero_name = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship_evo = zstring.split(self.heroInstance.evolution_status, "|")
		local evo_mould_id =  evo_info[tonumber(ship_evo[1])]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		hero_name = word_info[3]
	else
		hero_name = self.heroInstance.captain_name
		if tonumber(self.heroInstance.captain_type) == 0 then
			hero_name = _ED.user_info.user_name
			hero_grade = _ED.user_info.user_grade
		end
	end
	local hero_grade = self.heroInstance.ship_grade
	if tonumber(self.heroInstance.captain_type) == 0 then
		hero_name = _ED.user_info.user_name
		hero_grade = _ED.user_info.user_grade
	end
	local colortype = dms.atoi(hero_data, ship_mould.ship_type)
	
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_wujiang")
	headPanel:removeAllChildren(true)
	headPanel:addChild(hero_head)
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "ImageView_general"), nil, 
		{
			terminal_name = "ship_head_new_cell_info", 
			_self = hero_head,
			_ship = hero_head.ship
		}, 
		nil, 0)
	end

	local rankLevelFront = dms.atoi(hero_data, ship_mould.initial_rank_level)  --进阶前的进阶等级
	local ship_name = nil
	if rankLevelFront ~= 0 then
		ship_name = hero_name.." +"..rankLevelFront		--战船名称
	else
		ship_name = hero_name
	end
	if ___is_open_leadname == true then
		if dms.int(dms["ship_mould"], tonumber(hero_mould_id), ship_mould.captain_type) == 0 then
			Text_name:setFontName("")
			Text_name:setFontSize(Text_name:getFontSize())-->设置字体大小
		else
			Text_name:setFontName(HeroSeatCell.__userHeroFontName)
		end
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto then 
			--繁体字读取本地ship_mould
			if tonumber(self.heroInstance.captain_type) == 0 then
			else
				ship_name = dms.atos(hero_data, ship_mould.captain_name)
			end
		end
	end

	Text_name:setString(ship_name)
	Text_name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	ccui.Helper:seekWidgetByName(root, "Text_dengji_0"):setString(hero_grade)
	local level = nil
	
	if _ED.hero_skillstren_info.level ~= nil and _ED.hero_skillstren_info.hero_id ~= nil and
		tonumber(_ED.hero_skillstren_info.hero_id) == tonumber(self.heroInstance.ship_id) then
		level = _ED.hero_skillstren_info.level
	else
		level = self.heroInstance.ship_skillstren.skill_level
	end
	if verifySupportLanguage(_lua_release_language_en) == true then
		ccui.Helper:seekWidgetByName(root, "Text_tianming_0"):setString(_string_piece_info[6]..(level or "0"))
	else
		ccui.Helper:seekWidgetByName(root, "Text_tianming_0"):setString((level or "0").._string_piece_info[6])
	end
end

function HeroSeatCell:onEnterTransitionFinish()

end

function HeroSeatCell:onInit()
	-- if self.roots[1] ~= nil then
	-- 	return
	-- end
 --    local csbHeroSell = csb.createNode("packs/HeroStorage/list_generals_big.csb")
	
	-- local root = csbHeroSell:getChildByName("root")
	-- self:setContentSize(root:getChildByName("Panel_6549"):getContentSize())
 --    self:addChild(csbHeroSell)
	-- table.insert(self.roots, root)

	local root = cacher.createUIRef("packs/HeroStorage/list_generals_big.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if HeroSeatCell.__size == nil then
 		HeroSeatCell.__size = root:getChildByName("Panel_6549"):getContentSize()
 	end
 	if ___is_open_leadname == true then
 		if HeroSeatCell.__userHeroFontName == nil then
 			HeroSeatCell.__userHeroFontName = ccui.Helper:seekWidgetByName(root, "Text_name"):getFontName()
 		end
 	end
	
	-- local action = csb.createTimeline("packs/HeroStorage/list_generals_big.csb")
	-- csbHeroSell:runAction(action)
	-- action:play("list_view_cell_open", false)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local expansion_pad = ccui.Helper:seekWidgetByName(root, "Panel_xiala")
		expansion_pad:setSwallowTouches(false)
		if expansion_pad._pos == nil then
	 		expansion_pad._pos = cc.p(expansion_pad:getPosition())
	 	else
			expansion_pad:removeAllChildren(true)
	 		expansion_pad:setPosition(expansion_pad._pos)
	 	end

	 	local expansion_pad_parent = expansion_pad:getParent()
	 	if expansion_pad_parent._pos == nil then
	 		expansion_pad_parent._pos = cc.p(expansion_pad_parent:getPosition())
	 	else
	 		expansion_pad_parent:setPosition(expansion_pad_parent._pos)
	 	end
	end

	ccui.Helper:seekWidgetByName(root, "ImageView_general"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(root, "Panel_wujiang"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(root, "Button_kuozhan"):setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(root, "Button_kuozhan_0"):setSwallowTouches(false)


	
	--扩展界面展开                                                                                     
	local seat_expansion_on_button = ccui.Helper:seekWidgetByName(root, "Panel_btn_jh")
	seat_expansion_on_button:setSwallowTouches(false)
	
		local function headLayerTouchEvent(sender, evenType)
			local __spoint = sender:getTouchBeganPosition()
			local __mpoint = sender:getTouchMovePosition()
			local __epoint = sender:getTouchEndPosition()
			if ccui.TouchEventType.began == evenType then
				
			elseif evenType == ccui.TouchEventType.moved then
				
			elseif ccui.TouchEventType.ended == evenType or
				ccui.TouchEventType.canceled == evenType then
				--> print(math.abs( __epoint.y - __spoint.y))
				if math.abs( __epoint.y - __spoint.y) < 8 then
					if fwin:find("HeroInformationClass") == nil then
						state_machine.excute("ship_expansion_action_start", 0, {_datas = {cell = self}})
					end
				end
			end
		end
	seat_expansion_on_button:addTouchEventListener(headLayerTouchEvent)
	
	--扩展界面回收                                                                               
	local seat_expansion_off_button = ccui.Helper:seekWidgetByName(root, "Button_kuozhan_0")
	fwin:addTouchEventListener(seat_expansion_off_button, nil, 
	{
		terminal_name = "ship_expansion_action_start", 
		next_terminal_name = "general", 
		but_image = "Image_home", 	
		terminal_state = 0, 
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	local expandButton = ccui.Helper:seekWidgetByName(root, "Button_kuozhan")
	fwin:addTouchEventListener(expandButton, nil, 
	{
		terminal_name = "ship_expansion_action_start", 
		next_terminal_name = "general", 
		but_image = "Image_home", 	
		terminal_state = 0, 
		cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	if self.num ~= nil then
		ccui.Helper:seekWidgetByName(root, "Panel_4004"):setName("Panel_4004_"..self.num)
	end
	
	self:onUpdateDraw()
end

function HeroSeatCell:close( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_red_alert 
        or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
        or __lua_project_id == __lua_project_yugioh
        or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
        or __lua_project_id == __lua_project_warship_girl_b 
        then
		local headPanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang")
		headPanel:removeAllChildren(true)
	end
end

function HeroSeatCell:onExit()
	local root = self.roots[1]
	if root ~= nil then
		if ___is_open_leadname == true then
	 		if HeroSeatCell.__userHeroFontName ~= nil then
	 			ccui.Helper:seekWidgetByName(root, "Text_name"):setFontName(HeroSeatCell.__userHeroFontName)
	 		end
	 	end
		cacher.freeRef("packs/HeroStorage/list_generals_big.csb", self.roots[1])
	end
end

function HeroSeatCell:init(heroInstance, num, index)
	self.heroInstance = heroInstance
	self.num = num


	if index ~= nil and index < 8 then
		self:onInit()
	end

	self:setContentSize(HeroSeatCell.__size)
	return self
end

function HeroSeatCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function HeroSeatCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_wujiang")
		headPanel:removeAllChildren(true)
	end
	cacher.freeRef("packs/HeroStorage/list_generals_big.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:removeFromParent(false)
	self.roots = {}
	self.csbHeroSell = nil
end

function HeroSeatCell:createCell()
	local cell = HeroSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end