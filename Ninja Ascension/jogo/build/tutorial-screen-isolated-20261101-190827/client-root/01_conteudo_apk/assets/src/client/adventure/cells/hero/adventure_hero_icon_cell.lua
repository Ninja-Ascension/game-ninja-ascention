----------------------------------------------------------------------------------------------------
-- 说明：武将图标绘制
----------------------------------------------------------------------------------------------------
AdventureHeroIconCell = class("AdventureHeroIconCellClass", Window)
AdventureHeroIconCell.__size = nil
AdventureHeroIconCell.__ware_house_choose_cell = nil --出战选中cell
AdventureHeroIconCell.__fromation_change_cell = nil --变换阵型选中cell

function AdventureHeroIconCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.propName = "" --道具名称,供外部使用
	self.current_type = 0
	self.isCanAgreement = false
	self.enum_type = {
		_TYPE_NORMAL = 0,					-- 静态的UI显示
		_TYPE_SHOW_HERO_INFORMATION = 1,	-- 可以触发打开武将信息的窗口	
		_TYPE_SHOW_HERO_WAREHOUSE = 2,		-- 武将仓库内的控制
		_TYPE_SHOW_BATTLE_POSITION = 3,		-- 阵容上阵位置
		_TYPE_SHOW_BATTLE_CONFIRM = 4,		-- 阵容上阵确认
		_TYPE_SHOW_BATTLE_FORMATION = 5,	-- 阵容界面控制
		_TYPE_SHOW_TRANSFORM_CHOICE_SERVANTS = 6,	-- 选择灵源
		_TYPE_SHOW_TRANSFORM_CHOICE_THEMAIN = 7,	-- 选择灵主
		_TYPE_SHOW_HERO_FORE = 8,			-- 武将解雇
		_TYPE_SHOW_FORMATION_ARRANGEMENT = 9,			-- 阵型排列内的
		_TYPE_SHOW_AGREEMENT = 10,			-- 契约
		_TYPE_SHOW_WARCRAFT = 11,			-- 排行榜
	}

	self.drawHeadType = 0
	self.ifdim = nil
	self.numbers = nil
	self.capadility = nil
	self.level = nil
	self.awaken = nil
	self.agreement = nil
	self.drawIndex = 0
	self.isLarger = false
	self.isFrame = false
	self.isEmpty = false --是否是空位置
	self.Panel_choose_role = nil
	self.chuzhan_image = nil 
	self.number_image = nil 
	self.number_text = nil 
	self.is_select_off = false -- 解雇中选中状态
	app.load("client.adventure.cells.hero.adventure_hero_selected_cell")
	-- Initialize adventure hero icon cell state machine.
	local function init_adventure_hero_icon_cell_terminal()
        -- 显示武将信息
        local adventure_hero_icon_cell_show_hero_information_terminal = {
            _name = "adventure_hero_icon_cell_show_hero_information",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
                app.load("client.adventure.packs.hero.AdventureHeroInformation")
                fwin:open(AdventureHeroInformation:new():init(cell.hero, cell), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_hero_icon_cell_update_cell_terminal = {
            _name = "adventure_hero_icon_cell_update_cell",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params[1]
				cell.capadility = params[2]
            	cell:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_hero_icon_cell_show_hero_warehouse_terminal = {
            _name = "adventure_hero_icon_cell_show_hero_warehouse",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				state_machine.excute("adventure_hero_icon_cell_show_hero_warehouse_larger", 0, params)
				state_machine.excute("adventure_mercenary_package_sort_update_attribute", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_hero_icon_cell_show_hero_warehouse_larger_terminal = {
            _name = "adventure_hero_icon_cell_show_hero_warehouse_larger",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	terminal.largerId = AdventureHeroIconCell.__ware_house_choose_cell
				if terminal.largerId ~= nil and terminal.largerId == cell then
					
					return false
				end
				if terminal.largerId ~= nil and terminal.largerId ~= cell then
					terminal.largerId.isLarger = false
					if terminal.largerId.roots[1]== nil then
						AdventureHeroIconCell.__ware_house_choose_cell = cell
						terminal.largerId = cell
						ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_choose_role"):setVisible(true)
						terminal.largerId.roots[1]:setScale(1.1)
						cell.isLarger = true
						return false
					end
					ccui.Helper:seekWidgetByName(terminal.largerId.roots[1], "Panel_choose_role"):setVisible(false)
					terminal.largerId.roots[1]:setScale(1)
					AdventureHeroIconCell.__ware_house_choose_cell = cell
					terminal.largerId = cell
					ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_choose_role"):setVisible(true)
					cell.roots[1]:setScale(1.1)
					cell.isLarger = true
					return false
				end
				if terminal.largerId == nil then
					AdventureHeroIconCell.__ware_house_choose_cell = cell
					terminal.largerId = AdventureHeroIconCell.__ware_house_choose_cell
					ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_choose_role"):setVisible(true)
					terminal.largerId.roots[1]:setScale(1.1)
					cell.isLarger = true
					return false
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_hero_icon_cell_show_hero_warehouse_two_larger_terminal = {
            _name = "adventure_hero_icon_cell_show_hero_warehouse_two_larger",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	terminal.largerId = AdventureHeroIconCell.__fromation_change_cell
				if terminal.largerId ~= nil and terminal.largerId == cell then
					return false
				end
				if terminal.largerId ~= nil and terminal.largerId ~= cell then
					terminal.largerId.isFrame = false
					if terminal.largerId.roots[1] == nil then
						terminal.largerId = cell
						AdventureHeroIconCell.__fromation_change_cell = cell
						ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_choose_role"):setVisible(true)
						cell.isFrame = trues
						return false
					end
					ccui.Helper:seekWidgetByName(terminal.largerId.roots[1], "Panel_choose_role"):setVisible(false)
					terminal.largerId = cell
					AdventureHeroIconCell.__fromation_change_cell = cell
					ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_choose_role"):setVisible(true)
					cell.isFrame = true
					return false
				end
				if terminal.largerId == nil then
					terminal.largerId = cell
					AdventureHeroIconCell.__fromation_change_cell = cell
					ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_choose_role"):setVisible(true)
					cell.isFrame = true
					return false
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_hero_icon_cell_open_hero_list_terminal = {
            _name = "adventure_hero_icon_cell_open_hero_list",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				state_machine.excute("adventure_battle_formation_open_battle_list", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_hero_icon_cell_battle_confirm_terminal = {
            _name = "adventure_hero_icon_cell_battle_confirm",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				state_machine.excute("adventure_mercenary_hero_battle_list_open_confirm", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--选择了需要签订的英雄
		local adventure_hero_icon_cell_agreement_confirm_terminal = {
            _name = "adventure_hero_icon_cell_agreement_confirm",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	local oneagreement = dms.atoi(params._datas.cell.mould_data, ship_mould.price)
            	if oneagreement == -1 then 
            		TipDlg.drawTextDailog(tipStringInfo_hero_agreement_states[15])
            	else
            		state_machine.excute("adventure_mercenary_hero_agreement_list_open_confirm", 0, params)	
            	end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local adventure_hero_icon_cell_show_hero_formation_terminal = {
            _name = "adventure_hero_icon_cell_show_hero_formation",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				state_machine.excute("adventure_hero_icon_cell_show_hero_warehouse_larger", 0, params)
				state_machine.excute("adventure_battle_formation_update_draw_skill", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_hero_icon_cell_transform_choice_servants_terminal = {
            _name = "adventure_hero_icon_cell_transform_choice_servants",
            _init = function (terminal)
                app.load("client.adventure.mercenary.formation.AdventureMercenaryHeroBattleConfirm")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				if zstring.tonumber(_ED.transform_strengthen) == zstring.tonumber(cell.hero.ship_id) then
					TipDlg.drawTextDailog(_string_piece_info[379])
				else
					fwin:open(AdventureMercenaryHeroBattleConfirm:new():init(1,nil, nil, cell.hero), fwin._ui)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_hero_icon_cell_transform_choice_themain_terminal = {
            _name = "adventure_hero_icon_cell_transform_choice_themain",
            _init = function (terminal)
                app.load("client.adventure.mercenary.formation.AdventureMercenaryHeroBattleConfirm")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				if zstring.tonumber(_ED.transform_strengthen) == zstring.tonumber(cell.hero.ship_id) then
					TipDlg.drawTextDailog(_string_piece_info[379])
				else
					fwin:open(AdventureMercenaryHeroBattleConfirm:new():init(2,nil, nil, cell.hero), fwin._ui)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_hero_icon_cell_transform_fire_choice_terminal = {
            _name = "adventure_hero_icon_cell_transform_fire_choice",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				-- state_machine.excute("adventure_hero_icon_cell_hero_fire_larger", 0, params)
				state_machine.excute("adventure_mercenary_hero_fire_info_update", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_hero_icon_cell_formation_arrangement_choice_terminal = {
            _name = "adventure_hero_icon_cell_formation_arrangement",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				state_machine.excute("adventure_hero_icon_cell_show_hero_warehouse_two_larger", 0, params)
				state_machine.excute("adventure_battle_formation_change_selected", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(adventure_hero_icon_cell_show_hero_information_terminal)
		state_machine.add(adventure_hero_icon_cell_show_hero_warehouse_terminal)
		state_machine.add(adventure_hero_icon_cell_show_hero_warehouse_larger_terminal)
		state_machine.add(adventure_hero_icon_cell_show_hero_warehouse_two_larger_terminal)
		state_machine.add(adventure_hero_icon_cell_open_hero_list_terminal)
		state_machine.add(adventure_hero_icon_cell_battle_confirm_terminal)
		state_machine.add(adventure_hero_icon_cell_show_hero_formation_terminal)
		state_machine.add(adventure_hero_icon_cell_transform_choice_servants_terminal)
		state_machine.add(adventure_hero_icon_cell_transform_choice_themain_terminal)
		state_machine.add(adventure_hero_icon_cell_transform_fire_choice_terminal)
		state_machine.add(adventure_hero_icon_cell_formation_arrangement_choice_terminal)
		state_machine.add(adventure_hero_icon_cell_update_cell_terminal)
		state_machine.add(adventure_hero_icon_cell_agreement_confirm_terminal)
		
        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_adventure_hero_icon_cell_terminal()
end

-- 播放抖动动画
function AdventureHeroIconCell:playAction()
	if self.actions ~= nil and self.actions[1] ~= nil then 
		self.actions[1]:play("role_donghua",true)	
	end
end

function AdventureHeroIconCell:onEnterTransitionFinish()

end
function AdventureHeroIconCell:updateDrawSelectOffSign()
	local root = self.roots[1]
	if root == nil then
		return
	end
	if self.enum_type._TYPE_SHOW_HERO_FORE == self.current_type then
		local cellChild = self:getChildByTag(99)
		if cellChild ~= nil then 
			self:removeChildByTag(99)
		end
		if self.is_select_off == true then 
			local cells = AdventureHeroSelectedCell:createCell()
			cells:init(0, 3)
			cells:setTag(99)
			self:addChild(cells)	
		end
	end
end
function AdventureHeroIconCell:updateDraw()
	local root = self.roots[1]

	-- 绘制品质框
	local quality = dms.atoi(self.mould_data, ship_mould.ship_type)
	if quality == nil then
		print("AdventureHeroIconCell@onEnterTransitionFinish()", "hero mould_data ship_mould.ship_type is nil.")
		return
	end
	if self.drawHeadType == 99 then
		root.Panel_role_bg:removeBackGroundImage()

	else
		local qualityImage = string.format("images/ui/quality/icon_hero_%d.png", quality+1)
		root.Panel_role_bg:setBackGroundImage(qualityImage)
	end

	-- 绘制武将的动画形象
	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	Panel_role:removeAllChildren(true)
	if self.drawHeadType == 0 then
		local temp_bust_index = dms.atoi(self.mould_data, ship_mould.bust_index)
		-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
		local spx = AdventureSprite:create(temp_bust_index, 9) -- ccs.Armature:create("spirte_" .. temp_bust_index)
		spx:getAnimation():playWithIndex(0)
		-- spx:setAnchorPoint(cc.p(0.5, 0.5))
		-- spx:setPosition(cc.p(size.width / 2, size.height / 2))
		Panel_role:addChild(spx)
	elseif self.drawHeadType == 99 then
		Panel_role:removeBackGroundImage()
		Panel_role:setBackGroundImage("images/ui/bg/bg_heroformation_bgempty_d.png")
		local sWidth = (root.Panel_role_bg:getContentSize().width - Panel_role:getContentSize().width)/2
		local sHeight = (root.Panel_role_bg:getContentSize().height - Panel_role:getContentSize().height)/2
		Panel_role:setPosition(cc.p(sWidth,sHeight))
	else
		Panel_role:removeBackGroundImage()
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte.ExportJson")
		local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")

		if  self.enum_type._TYPE_SHOW_FORMATION_ARRANGEMENT == self.current_type then
			Panel_1:setTouchEnabled(true)
		else			
			Panel_1:setTouchEnabled(false)
		end
	
		local picIndex = dms.atos(self.mould_data, ship_mould.head_icon)
		local size = Panel_1:getContentSize()
		local armature = ccs.Armature:create("spirte")
		local spriteIcon = string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex))
        local skinIcon = ccs.Skin:create(spriteIcon)
        skinIcon:getTexture():setAliasTexParameters()
        armature:getBone("big_head_"..1):addDisplay(skinIcon, 0)
        
		Panel_role:addChild(armature)
    	--Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex)))
    	--local sHeight = (Panel_1:getContentSize().height)/2+Panel_1:getContentSize().height/20
		local sWidth = (size.width)/2
		local sHeight = (size.height)/2 - size.height/3.6
		Panel_role:setPosition(cc.p(sWidth,sHeight))
	end
	if self.ifdim == nil or self.ifdim =="" then
		self.roots[1]:setColor(cc.c3b(150, 150, 150))
	end

	if self.numbers ~= nil then
		
		self.number_image:setVisible(true)
		self.number_text:setVisible(true)
		self.number_text:setString(self.numbers)
	else
		self.number_image:setVisible(false)
		self.number_text:setVisible(false)
	end

	local Text_level = ccui.Helper:seekWidgetByName(root, "Text_level")
	local Text_zhanli = ccui.Helper:seekWidgetByName(root, "Text_zhanli")
	local Text_agreement = ccui.Helper:seekWidgetByName(root, "Text_lvqiyue")
	local action_panel = ccui.Helper:seekWidgetByName(root, "Panel_1")
	local add_action = action_panel:getChildByName("ArmatureNode_keqianyue")
	Text_zhanli:setVisible(false)
	Text_level:setVisible(false)
	Text_agreement:setVisible(false)
	add_action:setVisible(false)
	if self.capadility ~= nil then
		Text_zhanli:setVisible(true)
		Text_level:setVisible(false)
		Text_zhanli:setString(self.capadility)
	end
	
	if self.level ~= nil then
		Text_level:setVisible(true)
		Text_zhanli:setVisible(false)
		Text_level:setString("LV"..self.level)
	end
	
	if self.awaken ~= nil then
		Text_level:setVisible(true)
		Text_zhanli:setVisible(false)
		Text_level:setString(self.awaken)
	end
	if self.agreement ~= nil then 
		Text_agreement:setVisible(true)
		local oneagreement = dms.atoi(self.mould_data, ship_mould.price)
		if oneagreement == -1 then 
			
			Text_agreement:setString(tipStringInfo_hero_agreement_states[17])
		else
			local twoagreement = dms.atoi(self.mould_data, ship_mould.need_honor)
			if zstring.tonumber(self.hero.agreementStates) == 0 then 
				add_action:setVisible(true)
			elseif zstring.tonumber(self.hero.agreementStates) == 1 then 
				if twoagreement == -1 then 
					add_action:setVisible(false)
				else
					add_action:setVisible(true)
				end
			elseif zstring.tonumber(self.hero.agreementStates) == 2 then 
				add_action:setVisible(false)
			end
			Text_agreement:setString("".. self.agreement .. "" .. _string_piece_info[46])
		end
		
	end
	self.chuzhan_image:setVisible(false)
	if self.enum_type._TYPE_SHOW_HERO_WAREHOUSE	== self.current_type or self.enum_type._TYPE_SHOW_TRANSFORM_CHOICE_THEMAIN	== self.current_type 
		or self.enum_type._TYPE_SHOW_TRANSFORM_CHOICE_SERVANTS == self.current_type or self.enum_type._TYPE_SHOW_AGREEMENT	== self.current_type
		then
		-- local formetionId = 0
		-- for n=1,tonumber(_ED.have_formetion_number) do
		-- 	if zstring.tonumber(_ED.formetion_list[n][1]) == 1 then
		-- 		formetionId = n
		-- 	end
		-- end
		for i, v in pairs(_ED.formetion) do
			if i >= 1 and zstring.tonumber(self.hero.ship_id) == zstring.tonumber(v) and zstring.tonumber(v)~=0 and zstring.tonumber(v)~=-1 then
				self.chuzhan_image:setVisible(true)
				break
			end
		end
	end
	
	self.Panel_choose_role:setVisible(false)
	self:setScale(1)
	
	if self.isLarger == true then
		self.Panel_choose_role:setVisible(true)
		self.roots[1]:setScale(1.1)
	else
		if self.isFrame == true then
			self.Panel_choose_role:setVisible(true)
		else
			self.Panel_choose_role:setVisible(false)
		end
		self.roots[1]:setScale(1)
	end
end

function AdventureHeroIconCell:onInit()
	self.roots = {}
	local root = cacher.createUIRef("icon/item_role.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
 	self.actions = {}
 	self.roots[1]:setScale(1)
 	self.roots[1]:setColor(cc.c3b(255, 255, 255))
 	if self.enum_type._TYPE_SHOW_FORMATION_ARRANGEMENT == self.current_type then
 		-- 初始化加载抖动动画
 		local action = csb.createTimeline("icon/item_role.csb")
 		self:runAction(action)
    	table.insert(self.actions,action)
    else
  --   	local action = csb.createTimeline("icon/item_role.csb")
  --   	action:gotoFrameAndPlay(15, 15, false)
		-- cc.Director:getInstance():getActionManager():pauseTarget(self)
		-- action =nil
	end
	if self.enum_type._TYPE_SHOW_HERO_FORE == self.current_type then 
		local cellChild = self:getChildByTag(99)
		if cellChild ~= nil then 
			self:removeChildByTag(99)
		end
		if self.is_select_off == true then 
			local cells = AdventureHeroSelectedCell:createCell()
			cells:init(0, 3)
			cells:setTag(99)
			self:addChild(cells)
		end
	end
	local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
	Panel_1:setTouchEnabled(false)
		
	if root.Panel_role_bg == nil then
		root.Panel_role_bg = ccui.Helper:seekWidgetByName(root, "Panel_role_bg")
	end
	root.Panel_role_bg:setName("Panel_role_bg_"..self.drawIndex)
	self.Panel_choose_role = ccui.Helper:seekWidgetByName(root, "Panel_choose_role")
	self.chuzhan_image = ccui.Helper:seekWidgetByName(root, "Image_chuzhan")
	self.number_image = ccui.Helper:seekWidgetByName(root, "Image_1") 
	self.number_text = ccui.Helper:seekWidgetByName(root, "Text_number") 
	self.shangzhen_text = ccui.Helper:seekWidgetByName(root, "Text_shangzhen") 
	self.shangzhen_text:setVisible(false)
	root.Panel_role_bg:setSwallowTouches(false)
	ccui.Helper:seekWidgetByName(root, "Panel_choose_role"):setSwallowTouches(false)

	if self.drawHeadType == 99 and self.current_type == self.enum_type._TYPE_SHOW_BATTLE_POSITION then
		self.shangzhen_text:setVisible(true)
	end

 	-- 显示武将信息
 	if self.enum_type._TYPE_SHOW_HERO_INFORMATION == self.current_type then
	    fwin:addTouchEventListener(root.Panel_role_bg,       nil, 
	    {
	        terminal_name = "adventure_hero_icon_cell_show_hero_information",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	elseif self.enum_type._TYPE_SHOW_HERO_WAREHOUSE	== self.current_type then
		fwin:addTouchEventListener(root.Panel_role_bg,       nil, 
	    {
	        terminal_name = "adventure_hero_icon_cell_show_hero_warehouse",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	elseif self.enum_type._TYPE_SHOW_BATTLE_POSITION == self.current_type then
		fwin:addTouchEventListener(root.Panel_role_bg,       nil, 
	    {
	        terminal_name = "adventure_battle_formation_open_battle_list",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	elseif self.enum_type._TYPE_SHOW_BATTLE_CONFIRM	== self.current_type then
		fwin:addTouchEventListener(root.Panel_role_bg,       nil, 
	    {
	        terminal_name = "adventure_hero_icon_cell_battle_confirm",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	elseif self.enum_type._TYPE_SHOW_BATTLE_FORMATION == self.current_type then
		fwin:addTouchEventListener(root.Panel_role_bg,       nil, 
	    {
	        terminal_name = "adventure_hero_icon_cell_show_hero_formation",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	elseif self.enum_type._TYPE_SHOW_TRANSFORM_CHOICE_SERVANTS == self.current_type then
		fwin:addTouchEventListener(root.Panel_role_bg,       nil, 
	    {
	        terminal_name = "adventure_hero_icon_cell_transform_choice_servants",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	elseif self.enum_type._TYPE_SHOW_TRANSFORM_CHOICE_THEMAIN == self.current_type then
		fwin:addTouchEventListener(root.Panel_role_bg,       nil, 
	    {
	        terminal_name = "adventure_hero_icon_cell_transform_choice_themain",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	elseif self.enum_type._TYPE_SHOW_HERO_FORE == self.current_type then
		fwin:addTouchEventListener(root.Panel_role_bg,       nil, 
	    {
	        terminal_name = "adventure_hero_icon_cell_transform_fire_choice",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	elseif self.enum_type._TYPE_SHOW_FORMATION_ARRANGEMENT == self.current_type then
		fwin:addTouchEventListener(root.Panel_role_bg,       nil, 
	    {
	        terminal_name = "adventure_hero_icon_cell_formation_arrangement",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	    self:playAction()
	elseif self.enum_type._TYPE_SHOW_AGREEMENT == self.current_type then
		fwin:addTouchEventListener(root.Panel_role_bg,       nil, 
	    {
	        terminal_name = "adventure_hero_icon_cell_agreement_confirm",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	else
		fwin:addTouchEventListener(root.Panel_role_bg,       nil, 
	    {
	        terminal_name = "",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	end
	
	-- Get size for root node.
	if AdventureHeroIconCell.__size == nil then
		local size = root:getContentSize()
		AdventureHeroIconCell.__size = size
	end
	
	self:updateDraw()
end

function AdventureHeroIconCell:onExit()
	cacher.freeRef("icon/item_role.csb", self.roots[1])
	self.roots = {}
end

-- /**
-- * interfaceType	逻辑类型
-- * hero			实例对象
-- * drawHeadType	绘制类型
-- * ifdim			阴影显示逻辑
-- * number			数量
-- * capadility		战力显示数
-- * level			等级显示数
-- * awaken			觉醒等级显示数
-- * drawIndex		一个屏幕内显示最多的数量,也是当前在阵容中的位置
-- * 契约等级
-- */
function AdventureHeroIconCell:init(interfaceType, hero, drawHeadType, ifdim, number, capadility, level, awaken, drawIndex,agreement)
	self.current_type = interfaceType
	self.hero = hero
	self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
	self.propName = dms.string(dms["ship_mould"],self.hero.ship_template_id, ship_mould.captain_name)
	self.drawHeadType = drawHeadType
	self.ifdim = ifdim
	self.numbers = number
	self.capadility = capadility --战力
	self.level = level	--等级
	self.awaken = awaken	--觉醒
	self.drawIndex = drawIndex
	self.agreement = agreement
	
	if drawIndex ~= nil and drawIndex < 36 then
		self:onInit()
	end
	self.isEmpty = false
	if drawHeadType == 99 then  -- 标示空图片
		self.isEmpty = true
	else 
		self.isEmpty = false
	end
	self:setContentSize(AdventureHeroIconCell.__size)
	return self
end

function AdventureHeroIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureHeroIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	root:stopAllActions()
	if self.enum_type._TYPE_SHOW_HERO_FORE == self.current_type then
		if self.is_select_off == true then 
			self:removeChildByTag(99)
		end
	end
	cacher.freeRef("icon/item_role.csb", root)
	root:removeFromParent(false)
	self.roots = {}
	if self.actions ~= nil and self.actions[1] ~= nil then 
		self.actions[1]:stop()
		self.actions = {}
	end
end

function AdventureHeroIconCell:createCell()
	local cell = AdventureHeroIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

