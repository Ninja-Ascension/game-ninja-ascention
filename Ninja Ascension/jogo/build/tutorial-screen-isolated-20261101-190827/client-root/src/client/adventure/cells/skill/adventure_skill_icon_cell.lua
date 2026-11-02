----------------------------------------------------------------------------------------------------
-- 说明：武将技能图标绘制
----------------------------------------------------------------------------------------------------
AdventureSkillIconCell = class("AdventureSkillIconCellClass", Window)
AdventureSkillIconCell.__size = nil
AdventureSkillIconCell._show_skill_larger = nil --技能选中的Cell
--AdventureSkillIconCell._show_skill_confirm_larger = nil --技能选中的Cell确定界面

function AdventureSkillIconCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.current_type = 0
	self.enum_type = {
		_TYPE_NORMAL = 0,					-- 静态的UI显示
		_HANDLE_MERCENARY_WAREHOUSE = 1,			--佣兵仓库逻辑
		_HANDLE_MERCENARY_SHOP_CONFIRM = 2,			--佣兵确认界面
		_HANDLE_MERCENARY_FIRE_CONFIRM = 3,			--佣兵解雇界面
		_HANDLE_AGREEMENT_ICON = 4,					--契约图标
		_HANDLE_LOOK_INFO = 99,					--查看信息

	}
	
	self.show_type = {
		_SHOW_MERCENARY_WAREHOUSE = 1,			--佣兵仓库
		_SHOW_MERCENARY_EQUIP = 2,				--宝具显示
	}
	self.drawShowType = 0
	self.drawSkillType = 0
	self.size = 0
	app.load("client.adventure.utils.AdventureHookSkillInfoSee")
	-- Initialize adventure hero icon cell state machine.
	local function init_adventure_skill_icon_cell_terminal()
		--佣兵仓库的技能查看选择逻辑
		local adventure_skill_icon_cell_show_hero_warehouse_terminal = {
            _name = "adventure_skill_icon_cell_show_hero_warehouse",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				state_machine.excute("adventure_skill_icon_cell_show_hero_warehouse_larger", 0, params)
				state_machine.excute("adventure_mercenary_package_sort_update_skill_info", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--佣兵确认的查看选择逻辑
		local adventure_skill_icon_cell_show_hero_confirm_terminal = {
            _name = "adventure_skill_icon_cell_show_hero_confirm",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				state_machine.excute("adventure_skill_icon_cell_show_hero_confirm_warehouse_larger", 0, params)
				state_machine.excute("adventure_mercenary_hero_battle_list_update_skill_info", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--佣兵解雇的查看选择逻辑
		local adventure_skill_icon_cell_fire_confirm_terminal = {
            _name = "adventure_skill_icon_cell_fire_confirm",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				state_machine.excute("adventure_skill_icon_cell_show_hero_warehouse_larger", 0, params)
				state_machine.excute("adventure_mercenary_hero_fire_update_skill_info", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--点击契约
		local adventure_skill_icon_cell_agreement_terminal = {
            _name = "adventure_skill_icon_cell_agreement",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	state_machine.excute("adventure_skill_icon_cell_show_hero_warehouse_larger", 0, params)
				state_machine.excute("adventure_mercenary_hero_formation_update_agreement_info", 0, params)
	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		local adventure_skill_icon_cell_show_hero_warehouse_larger_terminal = {
            _name = "adventure_skill_icon_cell_show_hero_warehouse_larger",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
            	local cell = params._datas.cell
            	terminal.largerId = AdventureSkillIconCell._show_skill_larger
				if terminal.largerId ~= nil and terminal.largerId == cell then
					return false
				end
				if terminal.largerId ~= nil and terminal.largerId ~= cell then
					ccui.Helper:seekWidgetByName(terminal.largerId.roots[1], "Panel_choose"):setVisible(false)
					AdventureSkillIconCell._show_skill_larger = cell
					terminal.largerId = cell
					ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_choose"):setVisible(true)
					return false
				end
				if terminal.largerId == nil then
					AdventureSkillIconCell._show_skill_larger = cell
					terminal.largerId = cell
					ccui.Helper:seekWidgetByName(terminal.largerId.roots[1], "Panel_choose"):setVisible(true)
					return false
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --佣兵确认窗口 选中单个技能
    	local adventure_skill_icon_cell_show_hero_confirm_warehouse_larger_terminal = {
            _name = "adventure_skill_icon_cell_show_hero_confirm_warehouse_larger",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
            	local cell = params._datas.cell
         
				if terminal.largerId ~= nil and terminal.largerId == cell then
					return false
				end
				if terminal.largerId ~= nil and terminal.largerId ~= cell then
					ccui.Helper:seekWidgetByName(terminal.largerId.roots[1], "Panel_choose"):setVisible(false)
				
					terminal.largerId = cell
					ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_choose"):setVisible(true)
					return false
				end
				if terminal.largerId == nil then
				
					terminal.largerId = cell
					ccui.Helper:seekWidgetByName(terminal.largerId.roots[1], "Panel_choose"):setVisible(true)
					return false
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_skill_icon_cell_show_hero_warehouse_terminal)
		state_machine.add(adventure_skill_icon_cell_show_hero_confirm_terminal)
		state_machine.add(adventure_skill_icon_cell_show_hero_warehouse_larger_terminal)
		state_machine.add(adventure_skill_icon_cell_fire_confirm_terminal)
		state_machine.add(adventure_skill_icon_cell_agreement_terminal)
		state_machine.add(adventure_skill_icon_cell_show_hero_confirm_warehouse_larger_terminal)
		
        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_adventure_skill_icon_cell_terminal()
end

function AdventureSkillIconCell:onInit()
	local root = cacher.createUIRef("icon/item_skill.csb", "root")
	root:setColor(cc.c3b(255, 255, 255))
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	if self.enum_type._HANDLE_MERCENARY_WAREHOUSE == self.current_type then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_skill_item"),       nil, 
	    {
	        terminal_name = "adventure_skill_icon_cell_show_hero_warehouse",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	elseif self.enum_type._HANDLE_MERCENARY_SHOP_CONFIRM == self.current_type then	
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_skill_item"),       nil, 
	    {
	        terminal_name = "adventure_skill_icon_cell_show_hero_confirm",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	elseif self.enum_type._HANDLE_MERCENARY_FIRE_CONFIRM == self.current_type then	
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_skill_item"),       nil, 
	    {
	        terminal_name = "adventure_skill_icon_cell_fire_confirm",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	elseif self.enum_type._HANDLE_LOOK_INFO	 == self.current_type then
		local function formationTouchListener(sender, eventType)
			if eventType == ccui.TouchEventType.began then
				
				if self.show_type._SHOW_MERCENARY_EQUIP == self.drawShowType then
					local equipInfo = dms.element(dms["equipment_mould"], self.skill.id)
					fwin:open(AdventureHookSkillInfoSee:new():init(self.current_type,{id = dms.atoi(equipInfo, equipment_mould.skill_mould)}, self), fwin._ui)
				else
					fwin:open(AdventureHookSkillInfoSee:new():init(self.current_type,self.skill, self), fwin._ui)
				end
			elseif eventType == ccui.TouchEventType.moved then 
			else 
				fwin:close(fwin:find("AdventureHookSkillInfoSeeClass"))
			end
		end
		ccui.Helper:seekWidgetByName(root, "Panel_skill_item"):addTouchEventListener(formationTouchListener)
	elseif self.enum_type._HANDLE_AGREEMENT_ICON == self.current_type then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_skill_item"),       nil, 
	    {
	        terminal_name = "adventure_skill_icon_cell_agreement",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_skill_item"),       nil, 
	    {
	        terminal_name = "",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	end
	
	local Panel_skill = ccui.Helper:seekWidgetByName(root, "Panel_skill_item")
	local Panel_baoju_di = ccui.Helper:seekWidgetByName(root, "Panel_baoju_di")
	Panel_baoju_di:removeBackGroundImage()
	Panel_skill:removeBackGroundImage()
	Panel_skill:setSwallowTouches(false)
	local imageSkill = ccui.Helper:seekWidgetByName(root, "Image_skill")
	imageSkill:setVisible(false)
	local picIndex = nil
	if self.enum_type._HANDLE_AGREEMENT_ICON == self.current_type then  
		Panel_skill:setBackGroundImage("images/face/hero_head/bg_skill_skill_13.png")
		
		if zstring.tonumber(self.mould_data) ~= 0 then 
			--已经签约
			root:setColor(cc.c3b(255, 255, 255))
		else
			root:setColor(cc.c3b(150, 150, 150))
		end
	else
		if self.show_type._SHOW_MERCENARY_EQUIP == self.drawShowType then
			if zstring.tonumber(self.size) == 0 then
				Panel_baoju_di:setBackGroundImage("images/ui/bg/bg_skill_skill_20.png")
			end
			local equipInfo = dms.element(dms["equipment_mould"], self.skill.id)
			picIndex = dms.atos(equipInfo, equipment_mould.pic_index)
		else
			picIndex = dms.atos(self.mould_data, skill_mould.skill_pic)
		end
		Panel_skill:setBackGroundImage(string.format("images/face/hero_head/bg_skill_skill_%d.png", zstring.tonumber(picIndex)))
	
		if is_skill_union(self.mould_data) then
			imageSkill:setVisible(true)
		end
	end
	ccui.Helper:seekWidgetByName(root, "Panel_choose"):setVisible(false)
	if AdventureSkillIconCell.__size == nil then
		local size = root:getContentSize()
		AdventureSkillIconCell.__size = size
	end
end

function AdventureSkillIconCell:onExit()
	local root =  self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Panel_choose"):setVisible(false)
	root:stopAllActions()

	cacher.freeRef("icon/item_skill.csb", self.roots[1])
end

-- /**
-- */
function AdventureSkillIconCell:init(interfaceType, skill,drawIndex, showType, size)
	self.current_type = interfaceType
	self.skill = skill
	self.mould_data = skill.mould_data or dms.element(dms["skill_mould"], self.skill.id)
	self.drawShowType = showType
	self.size = size
	if drawIndex ~= nil and drawIndex < 45 then
		self:onInit()
	end
	
	self:setContentSize(AdventureSkillIconCell.__size)
	return self
end

function AdventureSkillIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureSkillIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("icon/item_skill.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureSkillIconCell:createCell()
	local cell = AdventureSkillIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

