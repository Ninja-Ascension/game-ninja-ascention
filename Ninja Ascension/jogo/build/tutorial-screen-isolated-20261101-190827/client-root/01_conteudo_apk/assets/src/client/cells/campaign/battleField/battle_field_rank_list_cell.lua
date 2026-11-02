
BattleFieldRankListCell = class("BattleFieldRankListCellClass", Window)
BattleFieldRankListCell.__size = nil

function BattleFieldRankListCell:ctor()
    self.super:ctor()
    self.roots = {}

    self.rank_info = nil

    self.Panel_role = nil
    --第一名
	self.Image_1st = nil
	--第二名
	self.Image_2st = nil
	--第三名
	self.Image_3st = nil
	--名次
	self.Text_st = nil
	--人物名字
	self.Text_name = nil
	--公会名称
	self.Text_gonghui = nil
	--历史最高驯兽魂
	self.Text_ls_1 = nil

    local function init_battle_field_rank_list_cell_terminal()
    	local battle_field_rank_list_cell_open_userInfo_terminal = {
            _name = "battle_field_rank_list_cell_open_userInfo",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.player.PlayerReviewInfomation")
            	local playerReviewInfomationPanel = PlayerReviewInfomation:new()
				playerReviewInfomationPanel:init(params._datas._id)
				fwin:open(playerReviewInfomationPanel, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(battle_field_rank_list_cell_open_userInfo_terminal)
        state_machine.init()
    end
    
    init_battle_field_rank_list_cell_terminal()
end

function BattleFieldRankListCell:onHeadDraw(person)
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
	if person.user_head ~= nil and zstring.tonumber(person.user_head) > 0 then
		pic = person.user_head
	end

	local big_icon_path = string.format("images/ui/props/props_%s.png", pic)
	Panel_kuang:setBackGroundImage(quality_path)
	Panel_head:setBackGroundImage(big_icon_path)
	
	if ccui.Helper:seekWidgetByName(roots, "Image_item_vip") ~= nil then
		ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(false)
		if tonumber(person.vip_grade) > 0 then
			ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(true)
		end
	end
	fwin:addTouchEventListener(Panel_head, nil, 
	{
		terminal_name = "battle_field_rank_list_cell_open_userInfo", 	
		_id = person.user_id,
		terminal_state = 0,
	}, 
	nil, 0)
	return roots
end

function BattleFieldRankListCell:initDraw( ... )
	self.Panel_role:removeAllChildren(true)
	self.Image_1st:setVisible(false)
	self.Image_2st:setVisible(false)
	self.Image_3st:setVisible(false)
	self.Text_st:setString("")
	self.Text_name:setString("")
	self.Text_gonghui:setString("")
	self.Text_ls_1:setString("")

	self.Panel_role:addChild(self:onHeadDraw(self.rank_info))
	self.Text_name:setString(self.rank_info.user_name)
	local quality = dms.int(dms["ship_mould"], self.rank_info.user_mould, ship_mould.ship_type)
	self.Text_name:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))

	if zstring.tonumber(self.rank_info.order) == 1 then
		self.Image_1st:setVisible(true)
	elseif zstring.tonumber(self.rank_info.order) == 2 then
		self.Image_2st:setVisible(true)
	elseif zstring.tonumber(self.rank_info.order) == 3 then
		self.Image_3st:setVisible(true)
	else
		self.Text_st:setString(self.rank_info.order)
	end
	self.Text_ls_1:setString(self.rank_info.user_fighting)
	self.Text_gonghui:setString(self.rank_info.arame)
	if self.rank_info.arame ~= "" then
		self.Text_gonghui:setString(self.rank_info.arame)
	else
		self.Text_gonghui:setString(_string_piece_info[310])
	end
end

function BattleFieldRankListCell:onInit( ... )
	local root = cacher.createUIRef("campaign/BattleField/BattleField_ranking_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if BattleFieldRankListCell.__size == nil then
	 	local Panel_phb_list = ccui.Helper:seekWidgetByName(root, "Panel_phb_list")
		local MySize = Panel_phb_list:getContentSize()
	 	BattleFieldRankListCell.__size = MySize
	end

	-- 列表控件动画播放
	local action = csb.createTimeline("campaign/BattleField/BattleField_ranking_list.csb")
    root:runAction(action)
    action:play("list_view_cell_open", false)
	
	self.Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")

	self.Image_1st = ccui.Helper:seekWidgetByName(root, "Image_1st")
	
	self.Image_2st = ccui.Helper:seekWidgetByName(root, "Image_2st")
	
	self.Image_3st = ccui.Helper:seekWidgetByName(root, "Image_3st")
	
	self.Text_st = ccui.Helper:seekWidgetByName(root, "Text_st")
	
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	
	self.Text_gonghui = ccui.Helper:seekWidgetByName(root, "Text_gonghui")
	
	self.Text_ls_1 = ccui.Helper:seekWidgetByName(root, "Text_ls_1")
     
   
	self:initDraw()
end

function BattleFieldRankListCell:init( index, rank_info )
	self.rank_info = rank_info
	if index ~= nil and index < 5 then
		self:onInit()
	end
	self:setContentSize(BattleFieldRankListCell.__size)
	return self
end

function BattleFieldRankListCell:onEnterTransitionFinish()
	
end

function BattleFieldRankListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function BattleFieldRankListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("campaign/BattleField/BattleField_ranking_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function BattleFieldRankListCell:clearUIInfo( ... )
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
	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	if Panel_role ~= nil then
		Panel_role:removeAllChildren(true)
	end
end

function BattleFieldRankListCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("campaign/BattleField/BattleField_ranking_list.csb", self.roots[1])
end

function BattleFieldRankListCell:createCell( ... )
	local cell = BattleFieldRankListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end