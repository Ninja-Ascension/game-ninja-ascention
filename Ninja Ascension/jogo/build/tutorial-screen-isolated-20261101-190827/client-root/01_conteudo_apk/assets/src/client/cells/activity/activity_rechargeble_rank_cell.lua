-- ----------------------------------------------------------------------------------------------------
-- 说明：累計充值榜活动
-------------------------------------------------------------------------------------------------------
ActivityRechargebleRankCell = class("ActivityRechargebleRankCellClass", Window)
ActivityRechargebleRankCell.__size = nil
-- ActivityRechargebleRankCell
function ActivityRechargebleRankCell:ctor()
    self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	self.example = nil
	self.index = 0
	self.activityIndex = 0
	self.activity = nil
	self.rewardIndex = 0
	self.activityId = 0
	
    -- Initialize ActivityRechargebleRankCell state machine.
    local function init_activity_rechargeble_rank_cell_terminal()
		local activity_rechargeble_rank_cell_draw_fund_reward_terminal = {
            _name = "activity_rechargeble_rank_cell_draw_fund_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					local RewardCell = params._datas._cell
					local index = RewardCell.index
					local function responseGetActivityRewardCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil then
								response.node:rewadDraw(response.node.index)
							end
							app.load("client.reward.DrawRareReward")
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd, fwin._windows)
						end
					end
					protocol_command.get_activity_reward.param_list = ""..RewardCell.activityId.."\r\n"..RewardCell.rewardIndex.."\r\n".."1"
					NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, RewardCell, responseGetActivityRewardCallback, false, nil)
				end
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(activity_rechargeble_rank_cell_draw_fund_reward_terminal)
		state_machine.init()
    end
    
    -- -- call func init ActivityRechargebleRankCell state machine.
    init_activity_rechargeble_rank_cell_terminal()
end

function ActivityRechargebleRankCell:onUpdateDrawRecharge()

end

function ActivityRechargebleRankCell:rewadDraw(_index)
	local root = self.roots[1]	
	ccui.Helper:seekWidgetByName(root, "Button_12"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_16_0"):setVisible(true)

end
	
function ActivityRechargebleRankCell:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[79]
	local rewadArry = nil
	self.activityId = activity.activity_id
	self.rewardIndex = self.index
	
	self.activity  = activity
	local pic = ccui.Helper:seekWidgetByName(root, "Panel_1")	--tubiao
	local rankNum = ccui.Helper:seekWidgetByName(root, "Text_13")	--战斗力

	local signInButton = ccui.Helper:seekWidgetByName(root, "Text_name")	--  名字
	if zstring.tonumber( self.example.user_fighting) > 10000 then
		rankNum:setString(math.floor(zstring.tonumber( self.example.user_fighting)/1000)..string_equiprety_name[40])
	else
		rankNum:setString(zstring.tonumber( self.example.user_fighting))
	end
	signInButton:setString(self.example.user_name)
	
	local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_11")
	ListViewDraw:removeAllItems()
	ccui.Helper:seekWidgetByName(root, "Image_100_1st"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_100_2st"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Image_100_3st"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Text_mingci"):setString(" ")

	local order = zstring.tonumber(self.example.order)
	if order == 1 then
		ccui.Helper:seekWidgetByName(root, "Image_100_1st"):setVisible(true)
	elseif order == 2 then
		ccui.Helper:seekWidgetByName(root, "Image_100_2st"):setVisible(true)
	elseif order == 3 then
		ccui.Helper:seekWidgetByName(root, "Image_100_3st"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Text_mingci"):setString(self.index)
	end
	local quality = dms.int(dms["ship_mould"], self.example.user_mould, ship_mould.ship_type)
	ccui.Helper:seekWidgetByName(root, "Text_name"):setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))

	local Panel_3_ro = ccui.Helper:seekWidgetByName(root, "Panel_1")
	Panel_3_ro:removeAllChildren(true)
	Panel_3_ro:addChild(self:onHeadDraw(self.example))
	local function drawicon(rewadArry,ListViewDraw1)
		local nodrawButton = ccui.Helper:seekWidgetByName(root, "Image_16_0")
				local drawButton = ccui.Helper:seekWidgetByName(root, "Button_12")
			if tonumber(self.example.user_id) == tonumber(_ED.user_info.user_id) then
				
				if   tonumber(rewadArry.activityInfo_isReward)  == 0 then
					drawButton:setBright(true)
					drawButton:setTouchEnabled(true)
					drawButton:setVisible(true)
				elseif 	tonumber(rewadArry.activityInfo_isReward) == 1 then
					nodrawButton:setVisible(true)
					drawButton:setBright(false)
					drawButton:setVisible(false)
				else
				end
			end
			if tonumber(rewadArry.activityInfo_silver) > 0 then--可领取银币数量
				local cell = propMoneyIcon:createCell()
				cell:init("1",rewadArry.activityInfo_silver,nil)
				ListViewDraw1:addChild(cell)
			end
			if tonumber(rewadArry.activityInfo_gold) > 0 then--奖励1可领取金币数量
				local cell = propMoneyIcon:createCell()
				cell:init("2",rewadArry.activityInfo_gold,nil)
				ListViewDraw1:addChild(cell)
			end
			if tonumber(rewadArry.activityInfo_food) > 0 then--奖励1可领取体力数量
				local cell = ResourcesIconCell:createCell()
				cell:init(0, 0, 0, {show_reward_list={{prop_type = 12, item_value = rewadArry.activityInfo_food}}})
				ListViewDraw1:addChild(cell)
			end
			if tonumber(rewadArry.activityInfo_honour) > 0 then--奖励1可领取声望数量
				local cell = propMoneyIcon:createCell()
				cell:init("3",rewadArry.activityInfo_honour,nil)
				ListViewDraw1:addChild(cell)
			end
			if tonumber(rewadArry.activityInfo_equip_count) > 0 then	--可领取装备种类数量
				for n, v in pairs(rewadArry.activityInfo_equip_info) do
					local cell = EquipIconCell:createCell()
					cell:init(10, nil, v.equipMould, nil, nil, v.equipMouldCount)
					ListViewDraw1:addChild(cell)
				end
			end
			if tonumber(rewadArry.activityInfo_prop_count) > 0 then--可领取道具种类数量
				for n, v in pairs(rewadArry.activityInfo_prop_info) do
					local cell = self:getItemCell(v.propMould,nil,v.propMouldCount)
					ListViewDraw1:addChild(cell)
				end
			end
	end
	rewadArry = activity.activity_Info[self.rewardIndex]
	drawicon(rewadArry,ListViewDraw)
end

function ActivityRechargebleRankCell:onHeadDraw(person)
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
	if  person.user_head ~= nil and zstring.tonumber(person.user_head) then
		pic = zstring.tonumber(person.user_head)
	end

	local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality)+1)
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
		terminal_name = "fame_hall_list_show_info", 	
		_id = person.user_id,
		terminal_state = 0,
	}, 
	nil, 0)
	return roots
end

--道具
function ActivityRechargebleRankCell:getItemCell(mid,mtype,count,isCertainly)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.isShowName = false
	cellConfig.isDebris = true
	cellConfig.mouldType = mtype
	cellConfig.touchShowType = 1
	cellConfig.count = count
	cellConfig.isCertainly = isCertainly
	cell:init(cellConfig)
	return cell
end

function ActivityRechargebleRankCell:onEnterTransitionFinish()

end

function ActivityRechargebleRankCell:onInit()

 	local root = cacher.createUIRef("activity/wonderful/activity_charge_rank_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	if ActivityRechargebleRankCell.__size == nil then
		ActivityRechargebleRankCell.__size = root:getChildByName("Panel_land_list"):getContentSize()
	end	
	state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.ActivityFightingRank)
	-- 列表控件动画播放
	-- local action = csb.createTimeline("activity/wonderful/activity_zhanlibang_list.csb")
    -- root:runAction(action)
    -- action:play("list_view_cell_open", false)

	local drawButton = ccui.Helper:seekWidgetByName(root, "Button_12")
	local nodrawButton = ccui.Helper:seekWidgetByName(root, "Image_16_0")
	nodrawButton:setVisible(false)
	drawButton:setBright(false)
	drawButton:setTouchEnabled(false)
	drawButton:setVisible(true)
	--if tonumber(self.activityIndex) == 1 then
		self:onUpdateDraw()
	--end
	 -- 领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"),       nil, 
    {
        terminal_name = "activity_rechargeble_rank_cell_draw_fund_reward",
        current_button_name = "Button_12",
        but_image = "Image_kf_01",   
        _cell = self,    
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function ActivityRechargebleRankCell:clearUIInfo( ... )
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
	local Panel_3_ro = ccui.Helper:seekWidgetByName(root, "Panel_1")
	if Panel_3_ro ~= nil then
		Panel_3_ro:removeAllChildren(true)
	end
	local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_11")
	if ListViewDraw ~= nil then
		ListViewDraw:removeAllItems()
	end
end

function ActivityRechargebleRankCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("activity/wonderful/activity_top_rank_list.csb", self.roots[1])
end

function ActivityRechargebleRankCell:init(example,index,activityIndex)
	self.example = example
	self.index = index
	self.activityIndex = activityIndex

	--if index < 5 then
		self:onInit()
	--end
	self:setContentSize(ActivityRechargebleRankCell.__size)
end

function ActivityRechargebleRankCell:reload()

	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ActivityRechargebleRankCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", self.roots[2])
	cacher.freeRef("activity/wonderful/activity_top_rank_list.csb", root)

	root:removeFromParent(false)
	self.roots = {}
	self.activity = nil
end

function ActivityRechargebleRankCell:createCell()
	local cell = ActivityRechargebleRankCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end