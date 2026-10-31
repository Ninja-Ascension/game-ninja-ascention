----------------------------------------------------------------------------------------------------
-- 说明：武将的小图标绘制
-- 用于游戏王
-------------------------------------------------------------------------------------------------------
ShipIconCellNew = class("ShipIconCellNewClass", Window)
ShipIconCellNew.__userHeroFontName = nil
function ShipIconCellNew:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0
	self.enum_type = {
		_HERO_STRENGTHEN = 1,					-- 绘制升级武将里的升级元素
		_SHOW_SHIP_HEAD = 2,					-- 只绘制武将头像,布阵界面调用
	}
	self.ship = nil		-- 当前要绘制的战船实现数据对对象
	self._mouldId = nil
	self.ships = nil
	self.strengShip = nil
	self.panelFour = nil
	-- 初始化武将小像事件响应需要使用的状态机
	local function init_ship_head_cell_new_terminal()
		
		-- 设计在升级界面，点击武将全身图像需要处理的逻辑
		local ship_head_cell_new_show_choose_hero_terminal = {
            _name = "ship_head_cell_new_show_choose_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

            	-- -- 在这里处理阵容界面，点击武将全身图像后的响应逻辑
            	local ships = params._datas._ships
            	local strengShipId = params._datas._strengShipId
				app.load("client.packs.hero.ChooseHeroToStreng")
				local choose_hero_to_streng = ChooseHeroToStreng:new()
				choose_hero_to_streng:init(ships, strengShipId)
				fwin:open(choose_hero_to_streng, fwin._taskbar)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(ship_head_cell_new_show_choose_hero_terminal)	

        state_machine.init()
	end
	init_ship_head_cell_new_terminal()
end

function ShipIconCellNew:onUpdateDraw()
	local root = self.roots[1]
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")--装备等级底框
	local item_name = ccui.Helper:seekWidgetByName(root, "Label_name")--名称
	local item_shuxin = ccui.Helper:seekWidgetByName(root, "Label_shuxin")--属性
	local item_lv = ccui.Helper:seekWidgetByName(root, "Text_1")--右上角等级
	local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级

	if self.ship ~= nil then
		local picIndex = 0
		local quality = 0

		local item_index = nil--物品图标索引
		local item_qulityindex = nil--物品品质索引
		local item_nameIndex = nil--物品名称索引
		local item_mouldid = nil--物品模板id
		item_index = ship_mould.head_icon
		item_qulityindex = ship_mould.ship_type
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id =  evo_info[tonumber(ship_evo[1])]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			item_nameIndex = word_info[3]
		else
			item_nameIndex = ship_mould.captain_name
		end
		item_mouldid= self.ship.ship_template_id
		picIndex = dms.int(dms["ship_mould"], item_mouldid, item_index)
		capacity = dms.int(dms["ship_mould"], item_mouldid, ship_mould.capacity)
		quality = dms.int(dms["ship_mould"], item_mouldid, item_qulityindex)+1
		if self.ship.captain_type == "0" then
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		else
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		end
		Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
	end
	
	if self.current_type == self.enum_type._HERO_STRENGTHEN then
	
		fwin:addTouchEventListener(Panel_prop, nil, 
		{
			terminal_name = "ship_head_cell_show_choose_hero", 
			terminal_state = 0, 
			_ships = self.ships,
			_strengShipId = self.strengShipId
		}, 
		nil, 0)
	elseif self.current_type == self.enum_type._SHOW_SHIP_HEAD then
		Panel_prop:setTouchEnabled(false)
		self:setTouchEnabled(true)
	end
end

function ShipIconCellNew:setScalePanel(n)
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Panel_29"):setScale(n)
end

function ShipIconCellNew:onEnterTransitionFinish()

	if table.getn(self.roots) > 0 then
		return
	end

end

function ShipIconCellNew:onInit()

	if table.getn(self.roots) > 0 then
		return
	end
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		root = cacher.createUIRef("icon/item.csb", "root")
		if root._x == nil then
			root._x = 0
		end
		if root._y == nil then
			root._x = 0
		end
	else
		local csbItem = csb.createNode("icon/item.csb")
		root = csbItem:getChildByName("root")
	end
	
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)

	self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end


	self:onUpdateDraw()
end

function ShipIconCellNew:clearUIInfo( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
		if root._x ~= nil then
			root:setPositionX(root._x)
		end
		if root._y ~= nil then
			root:setPositionY(root._y)
		end
	    local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
	    local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
	    local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
	    local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
	    local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
	    local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
	    local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
	    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
	    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
	    local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
	    local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
	    local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
	    local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
	    local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
	    local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
	    local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
	    local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
	    local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
	    local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
	    local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
	    local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
	    local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
		if Image_double ~= nil then
			Image_double:setVisible(false)
		end
	    if Image_xuanzhong ~= nil then
	    	Image_xuanzhong:setVisible(false)
	    end
        if Image_3 ~= nil then
        	Image_3:setVisible(false)
        end
	    if Label_l_order_level ~= nil then 
	    	Label_l_order_level:setVisible(true)
	    	if Label_l_order_level._x then
		    	Label_l_order_level:setPositionX(Label_l_order_level._x)
		    end
	        Label_l_order_level:setString("")
	    end
	    if Label_name ~= nil then
	        Label_name:setString("")
	        Label_name:setVisible(true)
	        Label_name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
	    end
	    if Label_quantity ~= nil then
	        Label_quantity:setString("")
	    end
	    if Label_shuxin ~= nil then
	        Label_shuxin:setString("")
	    end
	    if Panel_prop ~= nil then
	        Panel_prop:removeAllChildren(true)
	        Panel_prop:removeBackGroundImage()
	    end
	    if Panel_kuang ~= nil then
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
	    if Panel_ditu ~= nil then
	    	Panel_ditu:setVisible(true)
	        Panel_ditu:removeAllChildren(true)
	        Panel_ditu:removeBackGroundImage()
	    end
	    if Panel_star ~= nil then
	        Panel_star:removeAllChildren(true)
	        Panel_star:removeBackGroundImage()
	    end
	    if Panel_props_right_icon ~= nil then
	        Panel_props_right_icon:removeAllChildren(true)
	        Panel_props_right_icon:removeBackGroundImage()
	    end
	    if Panel_props_left_icon ~= nil then
	        Panel_props_left_icon:removeAllChildren(true)
	        Panel_props_left_icon:removeBackGroundImage()
	    end
	    if Panel_num ~= nil then
	        Panel_num:removeAllChildren(true)
	        Panel_num:removeBackGroundImage()
	    end
	    if Panel_4 ~= nil then
	        Panel_4:removeAllChildren(true)
	        Panel_4:removeBackGroundImage()
	    end
	    if Text_1 ~= nil then
	        Text_1:setString("")
	    end
	end
end

function ShipIconCellNew:onExit()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
	    self:clearUIInfo()
	    cacher.freeRef("icon/item.csb", root)
	end
end

function ShipIconCellNew:init(ship, interfaceType, mouldId, ships, strengShipId)
	self.ship = ship
	self.current_type = interfaceType
	if mouldId ~= nil then
		self._mouldId = mouldId
	end
	if ships ~= nil then
		self.ships = ships
	end	
	if strengShipId ~= nil then
		self.strengShipId = strengShipId
	end	
	self:onInit()
end

function ShipIconCellNew:createCell()
	local cell = ShipIconCellNew:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

