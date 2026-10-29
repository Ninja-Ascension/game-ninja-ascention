-- ----------------------------------------------------------------------------------------------------
-- 说明：名人堂人物排行榜cell
-- 创建时间	2015.4.27
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FameHallList = class("FameHallListClass", Window)
FameHallList.__size = nil    
FameHallList.__userHeroFontName = nil
function FameHallList:ctor()
    self.super:ctor()
    self.roots = {}
	self.person = nil
	self.num = nil
	self.types = nil
	
	-- app.load("client.packs.treasure.TreasureStorage")
	
    -- Initialize FameHall page state machine.
    local function init_fame_hall_show_list_terminal()
		
		local fame_hall_list_show_info_terminal = {
            _name = "fame_hall_list_show_info",
            _init = function (terminal) 
                app.load("client.chat.ChatFriendInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local cell = ChatFriendInfo:createCell()
				cell:init(params._datas._id,1)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(fame_hall_list_show_info_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_fame_hall_show_list_terminal()
end

function FameHallList:onHeadDraw(person)
	-- local csbItem = csb.createNode("icon/item.csb")
	-- local roots = csbItem:getChildByName("root")
	local roots = cacher.createUIRef("icon/item.csb", "root")
	table.insert(self.roots, roots)
	roots:removeFromParent(true)
	if roots._x == nil then
		roots._x = 0
	end
	if roots._y == nil then
		roots._x = 0
	end

	self.item_order_level = ccui.Helper:seekWidgetByName(roots, "Label_l-order_level")--右下角等级
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end


	local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
	local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if Panel_head ~= nil then
	        Panel_head:removeAllChildren(true)
	        Panel_head:removeBackGroundImage()
	    end
	    if Panel_kuang ~= nil then
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
    end
	local quality = dms.int(dms["ship_mould"], person.user_mould, ship_mould.ship_type)
	local pic = dms.int(dms["ship_mould"], person.user_mould, ship_mould.head_icon)
	local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality)+1)
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		if person.user_head ~= nil and zstring.tonumber(person.user_head) > 0 then
			pic = person.user_head
		end
	end

	local big_icon_path = string.format("images/ui/props/props_%s.png", pic)
	Panel_kuang:setBackGroundImage(quality_path)
	Panel_head:setBackGroundImage(big_icon_path)
	
	ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(false)
	if tonumber(person.vip_grade) > 0 then
		ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(true)
	end
	fwin:addTouchEventListener(Panel_head, nil, 
	{
		terminal_name = "fame_hall_list_show_info", 	
		_id = person.user_id,
		terminal_state = 0,
	}, 
	nil, 0)
	return roots
end

function FameHallList:onUpdateDraw()
	local root = self.roots[1]
		
	ccui.Helper:seekWidgetByName(root, "Image_232"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_420"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_560"):setVisible(false)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		ccui.Helper:seekWidgetByName(root, "Text_mingci_00"):setString("")
	else
		ccui.Helper:seekWidgetByName(root, "Text_1036"):setString("")
	end
	if self.num == 1 then
		ccui.Helper:seekWidgetByName(root, "Image_232"):setVisible(true)
	elseif self.num == 2 then
		ccui.Helper:seekWidgetByName(root, "Image_420"):setVisible(true)
	elseif self.num == 3 then
		ccui.Helper:seekWidgetByName(root, "Image_560"):setVisible(true)
	else
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			ccui.Helper:seekWidgetByName(root, "Text_mingci_00"):setString(self.num)
		else
			ccui.Helper:seekWidgetByName(root, "Text_1036"):setString(self.num)
		end
	end

	local Panel_3_ro = ccui.Helper:seekWidgetByName(root, "Panel_3_ro")
	Panel_3_ro:removeAllChildren(true)
	Panel_3_ro:addChild(self:onHeadDraw(self.person))
	if ___is_open_leadname == true then
		if FameHallList.__userHeroFontName == nil then
			FameHallList.__userHeroFontName = ccui.Helper:seekWidgetByName(root, "Text_103"):getFontName()
		end
		if dms.int(dms["ship_mould"], self.person.user_mould, ship_mould.captain_type) == 0 then
			ccui.Helper:seekWidgetByName(root, "Text_103"):setFontName("")
			ccui.Helper:seekWidgetByName(root, "Text_103"):setFontSize(ccui.Helper:seekWidgetByName(root, "Text_103"):getFontSize())-->设置字体大小
		else
			ccui.Helper:seekWidgetByName(root, "Text_103"):setFontName(FameHallList.__userHeroFontName)
		end
	end

	ccui.Helper:seekWidgetByName(root, "Text_103"):setString(self.person.user_name)
	if self.person.arame ~= "" then
		ccui.Helper:seekWidgetByName(root, "Text_103_0_0_0"):setString(self.person.arame)
	else
		ccui.Helper:seekWidgetByName(root, "Text_103_0_0_0"):setString(_string_piece_info[310])
	end
	local quality = dms.int(dms["ship_mould"], self.person.user_mould, ship_mould.ship_type)
	ccui.Helper:seekWidgetByName(root, "Text_103"):setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))

	if self.types == 1 then
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			ccui.Helper:seekWidgetByName(root, "Panel_dengji"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Panel_zhangli"):setVisible(true)
		else
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_warship_girl_b 
				then 
				ccui.Helper:seekWidgetByName(root, "Panel_4_1"):setVisible(false)
			else
				ccui.Helper:seekWidgetByName(root, "Panel_46"):setVisible(false)
			end
			ccui.Helper:seekWidgetByName(root, "Panel_4_0"):setVisible(true)
		end
		local recommendFight = tonumber(self.person.user_fighting)
		if recommendFight >= 10000 then
			recommendFight = math.floor(recommendFight / 10000).._string_piece_info[150]
		end
		ccui.Helper:seekWidgetByName(root, "Text_7_9"):setString(recommendFight)
		ccui.Helper:seekWidgetByName(root, "Text_103_0"):setString(_string_piece_info[16].." " .. self.person.user_level)
	elseif self.types == 2 then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			ccui.Helper:seekWidgetByName(root, "Panel_dengji"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Panel_zhangli"):setVisible(false)
		else
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_warship_girl_b 
				then 
				ccui.Helper:seekWidgetByName(root, "Panel_4_1"):setVisible(true)
			else
				ccui.Helper:seekWidgetByName(root, "Panel_46"):setVisible(true)
			end	
			ccui.Helper:seekWidgetByName(root, "Panel_4_0"):setVisible(false)
		end
		
		ccui.Helper:seekWidgetByName(root, "Text_7"):setString(self.person.user_level)
		local recommendFight = tonumber(self.person.user_fighting)
		if recommendFight >= 10000 then
			recommendFight = math.floor(recommendFight / 10000).._string_piece_info[150]
		end
		ccui.Helper:seekWidgetByName(root, "Text_103_0"):setString(_string_piece_info[303].." " .. recommendFight)
	end

end



function FameHallList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function FameHallList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("system/famous_rank_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function FameHallList:onEnterTransitionFinish()

end


function FameHallList:onInit()

	local root = cacher.createUIRef("system/famous_rank_list.csb", "root")
	table.insert(self.roots, root)
 	self:addChild(root)
	
	 if FameHallList.__size == nil then
	 	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_269")
		local MySize = PanelGeneralsEquipment:getContentSize()

	 	FameHallList.__size = MySize
	 end
	
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_269")
	local size = panel:getContentSize()
	self:setContentSize(size)
	
	self:onUpdateDraw()
end

function FameHallList:clearUIInfo( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[2]
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
	local root = self.roots[1]
	local Panel_3_ro = ccui.Helper:seekWidgetByName(root, "Panel_3_ro")
	if Panel_3_ro ~= nil then
		Panel_3_ro:removeAllChildren(true)
	end
end

function FameHallList:onExit()
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("system/famous_rank_list.csb", self.roots[1])
end

function FameHallList:init(person,num,types, index)
	self.person = person
	self.num = num
	self.types = types
	if index ~= nil and index < 7 then
		self:onInit()
	end
	self:setContentSize(FameHallList.__size)
	return self
end

function FameHallList:createCell()
	local cell = FameHallList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
