----------------------------------------------------------------------------------------------------
-- 说明：武将的小图标绘制
-------------------------------------------------------------------------------------------------------
ArenaRoleIconCell = class("ArenaRoleIconCellClass", Window)

function ArenaRoleIconCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.fashionPic = nil
	self.shipTID = nil			--icon的名字
	
	self.frame = nil			--框子
	self.panel = nil			--面板
	
	self.enum_type = {
		_NONE_ACTION = 1,							-- 没有任何动作
		_CLICK_REVIEW_OPPONENT = 2,					-- 查看对手装备信息界面所使用
	}
	
	self.currentType = 1
	
	-- 初始化武将小像事件响应需要使用的状态机
	local function init_ship_head_new_cell_terminal()
		
		-- 设计在阵容界面，点击武将小图像需要处理的逻辑
		-- local ship_head_new_cell_change_formation_ship_terminal = {
            -- _name = "ship_head_new_cell_change_formation_ship",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
            	-- -- 在这里处理阵容界面，点击武将小图像后的响应逻辑
            	-- local ship = params._datas._ship
				-- state_machine.excute("formation_change_to_ship_page_view", 0, ship)
				
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- 添加需要使用的状态机到状态机管理器去
		-- state_machine.add(ship_head_new_cell_change_formation_ship_terminal)
        state_machine.init()
	end
	init_ship_head_new_cell_terminal()
end

function ArenaRoleIconCell:onUpdateDraw()

	if self.currentType == self.enum_type._NONE_ACTION then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if self.frame ~= nil then
				self.frame:setBackGroundImage("images/ui/quality/icon_enemy_1.png")
			end
			local big_icon_path = nil
			local pic = tonumber(self.shipTID)
		    if pic < 9 then
		        big_icon_path = string.format("images/ui/home/head_%d.png", pic)
		    else
		        big_icon_path = string.format("images/ui/props/props_%d.png", pic)
		    end 
			self.panel:setBackGroundImage(big_icon_path)
		else
			local color = dms.string(dms["ship_mould"], self.shipTID, ship_mould.ship_type)+1
			if self.frame ~= nil then
				self.frame:setBackGroundImage("images/ui/quality/icon_enemy_" .. color .. ".png")
			end
			local pic = dms.string(dms["ship_mould"], self.shipTID, ship_mould.head_icon)
			if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b then
				if self.fashionPic ~= nil and zstring.tonumber(self.fashionPic) > 0 then
					pic = zstring.tonumber(self.fashionPic) 
				end
			end
			self.panel:setBackGroundImage("images/ui/props/props_" .. pic .. ".png")
		end
		
	elseif self.currentType == self.enum_type._CLICK_REVIEW_OPPONENT then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if self.frame ~= nil then
				self.frame:setBackGroundImage("images/ui/quality/icon_enemy_1.png")
			end
			local ship = fundShipWidthTemplateId(self.shipTID)
			local shipInitGroup = 1
			if ship ~= nil then
				local ship_evo = zstring.split(ship.evolution_status, "|")
            	shipInitGroup = tonumber(ship_evo[1])
			else
				shipInitGroup = dms.int(dms["ship_mould"], tonumber(self.shipTID), ship_mould.captain_name)
			end
			local evo_image = dms.string(dms["ship_mould"], tonumber(self.shipTID), ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			local shipEvoMouldId = tonumber(evo_info[shipInitGroup])
			local picIndex = dms.int(dms["ship_evo_mould"], shipEvoMouldId, ship_evo_mould.form_id)
			local big_icon_path = string.format("images/ui/props/props_%d.png", picIndex)
			self.panel:setBackGroundImage(big_icon_path)

		else
			local color = dms.string(dms["ship_mould"], self.shipTID, ship_mould.ship_type)+1
			if self.frame ~= nil then
				self.frame:setBackGroundImage("images/ui/quality/icon_enemy_" .. color .. ".png")
			end
			local pic = dms.string(dms["ship_mould"], self.shipTID, ship_mould.head_icon)
			self.panel:setBackGroundImage("images/ui/props/props_" .. pic .. ".png")
		end
	end
	
end

function ArenaRoleIconCell:setSelected(value)
	if self.frame == nil then
		return
	end
	if value == true then
		self.frame:setBackGroundImage("images/ui/quality/icon_enemy_6.png")
	else
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			self.frame:setBackGroundImage("images/ui/quality/icon_enemy_1.png")
		else
			if self.currentType == self.enum_type._NONE_ACTION then
				self.frame:setBackGroundImage("images/ui/quality/icon_enemy_5.png")
			elseif self.currentType == self.enum_type._CLICK_REVIEW_OPPONENT then
				local color = dms.string(dms["ship_mould"], self.shipTID, ship_mould.ship_type)+1
				self.frame:setBackGroundImage("images/ui/quality/icon_enemy_" .. color .. ".png")
			end
		end
	end
	
end

function ArenaRoleIconCell:onEnterTransitionFinish()
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		root = cacher.createUIRef("icon/item.csb", "root")
		table.insert(self.roots, root)
   		self:addChild(root)
   		if root._x == nil then
			root._x = 0
		end
		if root._y == nil then
			root._x = 0
		end
	else
		local csbItem = csb.createNode("icon/item.csb")
		root = csbItem:getChildByName("root")
		table.insert(self.roots, root)
    	self:addChild(csbIcon)
	end
	self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end
	
	self.frame = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	self.panel = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	self:setContentSize(self.frame:getContentSize())
	self.panel:setSwallowTouches(false)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		self.frame = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
		if self.frame ~= nil then
			self.frame:setVisible(true)
		end
		self.kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
		self.kuang:setBackGroundImage("images/ui/quality/quality_frame_14.png")
		self.panel:setSwallowTouches(false)
	end

	
	
	if self.currentType == self.enum_type._CLICK_REVIEW_OPPONENT then
		--添加点击事件撒撒撒撒
		fwin:addTouchEventListener(self.panel, 	nil, 
		{
			terminal_name = "init_player_review_click_seat", 	
			next_terminal_name = "init_player_review_click_seat", 	
			current_button_name = "Panel_prop",		
			but_image = "player_review_click",	
			terminal_state = 0, 
			isPressedActionEnabled = false,
			seat = self
		}, 
		nil, 0)
	end
	
	self:onUpdateDraw()
end

function ArenaRoleIconCell:clearUIInfo( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
		if root == nil then
			return
		end
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
	    local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
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

function ArenaRoleIconCell:onExit()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
	    self:clearUIInfo()
		cacher.freeRef("icon/item.csb", root)
	end
end

function ArenaRoleIconCell:init(shipTID, aType,icon)
	self.shipTID = shipTID
	self.currentType = aType
	self.fashionPic = icon
end

function ArenaRoleIconCell:createCell()
	local cell = ArenaRoleIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

