----------------------------------------------------------------------------------------------------
-- 说明：武将出战
----------------------------------------------------------------------------------------------------
AdventureHeroFormationIconCell = class("AdventureHeroFormationIconCellClass", Window)
AdventureHeroFormationIconCell.__size = nil
AdventureHeroFormationIconCell.__ware_house_choose_cell = nil --出战选中cell
AdventureHeroFormationIconCell.__fromation_change_cell = nil --变换阵型选中cell

function AdventureHeroFormationIconCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.propName = "" --道具名称,供外部使用
	self.current_type = 0
	self.isCanAgreement = false
	--3 可以继续上阵
	--0 需要通关条件
	--5 正常显示英雄
	self.enum_type = { -- 3 5  0 有效
		_TYPE_NORMAL = 0,					-- 静态的UI显示
		_TYPE_SHOW_HERO_INFORMATION = 1,	-- 可以触发打开武将信息的窗口	
		_TYPE_SHOW_HERO_WAREHOUSE = 2,		-- 武将仓库内的控制
		_TYPE_SHOW_BATTLE_POSITION = 3,		-- 阵容上阵位置
		_TYPE_SHOW_BATTLE_CONFIRM = 4,		-- 阵容上阵确认
		_TYPE_SHOW_BATTLE_FORMATION = 5,	-- 阵容界面控制
		
	}

	self.drawHeadType = 0
	self.ifdim = nil
	self.numbers = nil

	self.drawIndex = 0
	self.isLarger = false
	self.isFrame = false
	self.isEmpty = false --是否是空位置
	self.Panel_choose_role = nil
	
	self.number_image = nil 
	self.number_text = nil 
	
	app.load("client.adventure.utils.AdventureSprite")
	-- Initialize adventure hero icon cell state machine.
	local function init_adventure_hero_formation_icon_cell_terminal()

		--点击英雄显示
		local adventure_hero_formation_icon_cell_show_hero_terminal = {
            _name = "adventure_hero_formation_icon_cell_show_hero",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
            	
				state_machine.excute("adventure_hero_icon_cell_show_hero_warehouse_larger_formation", 0, params)
				state_machine.excute("adventure_battle_formation_select_hero", 0, params)
				
				state_machine.excute("adventure_battle_formation_update_draw_skill", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
    
		local adventure_hero_icon_cell_show_hero_warehouse_larger_formation_terminal = {
            _name = "adventure_hero_icon_cell_show_hero_warehouse_larger_formation",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell

            	terminal.largerId = AdventureHeroFormationIconCell.__ware_house_choose_cell
				if terminal.largerId ~= nil and terminal.largerId == cell then
					
					return false
				end
				if terminal.largerId ~= nil and terminal.largerId ~= cell then
					terminal.largerId.isLarger = false
					if terminal.largerId.roots[1]== nil then
						AdventureHeroFormationIconCell.__ware_house_choose_cell = cell
						terminal.largerId = cell
					
						terminal.largerId.roots[1]:setScale(1.1)
						cell.isLarger = true
						return false
					end
					
					terminal.largerId.roots[1]:setScale(1)
					AdventureHeroFormationIconCell.__ware_house_choose_cell = cell
					terminal.largerId = cell
					
					cell.roots[1]:setScale(1.1)
					cell.isLarger = true
					return false
				end
				if terminal.largerId == nil then
					AdventureHeroFormationIconCell.__ware_house_choose_cell = cell
					terminal.largerId = AdventureHeroFormationIconCell.__ware_house_choose_cell
					
					terminal.largerId.roots[1]:setScale(1.1)
					cell.isLarger = true
					return false
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		local adventure_hero_formation_icon_cell_open_hero_formation_list_terminal = {
            _name = "adventure_hero_formation_icon_cell_open_hero_formation_list",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				state_machine.excute("adventure_battle_formation_change_open_hero_list", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_hero_formation_icon_cell_show_hero_terminal)

		state_machine.add(adventure_hero_icon_cell_show_hero_warehouse_larger_formation_terminal)
		state_machine.add(adventure_hero_formation_icon_cell_open_hero_formation_list_terminal)

        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_adventure_hero_formation_icon_cell_terminal()
end


function AdventureHeroFormationIconCell:onEnterTransitionFinish()

end

function AdventureHeroFormationIconCell:updateDraw()
	local root = self.roots[1]

	-- 绘制品质框
	local quality = dms.atoi(self.mould_data, ship_mould.ship_type)
	if quality == nil then
		print("AdventureHeroIconCell@onEnterTransitionFinish()", "hero mould_data ship_mould.ship_type is nil.")
		return
	end
	
	local herobg = ccui.Helper:seekWidgetByName(root, "Image_1")
	local jiabg = ccui.Helper:seekWidgetByName(root, "Image_jia2")
 	herobg:setVisible(false)
 	jiabg:setVisible(false)
	-- 绘制武将的动画形象
	--3 可以继续上阵 0
	--0 需要通关条件 99
	--5 正常显示英雄
	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	Panel_role:removeAllChildren(true)
	
	if self.drawHeadType == 0 then
	
		herobg:setVisible(true)
		self.isEmpty = true
		jiabg:setVisible(true)
		
	elseif self.drawHeadType == 99 then
		self.isEmpty = true
		jiabg:setVisible(false)
		herobg:setVisible(true)
	else
		Panel_role:removeBackGroundImage()
		self.isEmpty = false
		local picIndex = dms.atos(self.mould_data, ship_mould.head_icon)
		local role = AdventureSpriteBattle:create(picIndex, 9) -- ccs.Armature:create("spirte_" .. temp_bust_index)
        local size = role:getContentSize()
        role:getAnimation():playWithIndex(0)
        role:setAnchorPoint(cc.p(0.5,0.0))
        role:setPosition(cc.p(Panel_role:getContentSize().width /2 , -size.height/2))
        role:getAnimation():setSpeedScale(0.4)

		Panel_role:addChild(role)
		
		self.roots[1]:setTouchEnabled(true)
  
	end
		
	if self.ifdim == nil or self.ifdim =="" then
		self.roots[1]:setColor(cc.c3b(150, 150, 150))
	end
	self:setScale(1)
	
	if self.isLarger == true then
		
		self.roots[1]:setScale(1.1)
	else
		
		self.roots[1]:setScale(1)
	end
end

function AdventureHeroFormationIconCell:onInit()
	self.roots = {}
	local root = cacher.createUIRef("icon/item_role_0.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
 	self.actions = {}
 	self.roots[1]:setScale(1)
 	self.roots[1]:setColor(cc.c3b(255, 255, 255))
 	self.roots[1]:setTouchEnabled(false)
 
	if root.Panel_role_bg == nil then
		root.Panel_role_bg = ccui.Helper:seekWidgetByName(root, "Panel_role_bg")
		root.Panel_role_bg:setSwallowTouches(false)
	end

	root.Panel_role_bg:setName("Panel_role_bg_"..self.drawIndex)

	if self.drawHeadType == 99 and self.current_type == self.enum_type._TYPE_SHOW_BATTLE_POSITION then
		--herobg:setVisible(true)
	end


	if self.enum_type._TYPE_SHOW_BATTLE_POSITION == self.current_type then
		fwin:addTouchEventListener(root.Panel_role_bg,       nil, 
	    {
	        terminal_name = "adventure_hero_formation_icon_cell_open_hero_formation_list",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	elseif self.enum_type._TYPE_SHOW_BATTLE_FORMATION == self.current_type then
		fwin:addTouchEventListener(root.Panel_role_bg,       nil, 
	    {
	        terminal_name = "adventure_hero_formation_icon_cell_show_hero",
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
	if AdventureHeroFormationIconCell.__size == nil then
		local size = root:getContentSize()
		AdventureHeroFormationIconCell.__size = size
	end
	
	self:updateDraw()
end

function AdventureHeroFormationIconCell:onExit()
	cacher.freeRef("icon/item_role_0.csb", self.roots[1])
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
function AdventureHeroFormationIconCell:init(interfaceType, hero, drawHeadType, ifdim, number, capadility, level, awaken, drawIndex,agreement)
	self.current_type = interfaceType
	self.hero = hero
	self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
	self.propName = dms.string(dms["ship_mould"],self.hero.ship_template_id, ship_mould.captain_name)
	self.drawHeadType = drawHeadType
	self.ifdim = ifdim
	self.numbers = number

	self.drawIndex = drawIndex
	
	if drawIndex ~= nil and drawIndex < 36 then
		self:onInit()
	end
	
	self:setContentSize(AdventureHeroFormationIconCell.__size)
	return self
end

function AdventureHeroFormationIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureHeroFormationIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	root:stopAllActions()
	
	cacher.freeRef("icon/item_role_0.csb", root)
	root:removeFromParent(false)
	self.roots = {}
	if self.actions ~= nil and self.actions[1] ~= nil then 
		self.actions[1]:stop()
		self.actions = {}
	end
end

function AdventureHeroFormationIconCell:createCell()
	local cell = AdventureHeroFormationIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

