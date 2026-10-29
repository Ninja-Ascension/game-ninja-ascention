----------------------------------------------------------------------------------------------------
-- 说明：道具的小图标绘制
-- 专属签到  长按弹起提示
-------------------------------------------------------------------------------------------------------
adventureSignPropIconCell = class("adventureSignPropIconCellClass", Window)

function adventureSignPropIconCell:ctor()
    self.super:ctor()
	app.load("client.adventure.utils.AdventureActivityIconInfoSee")
    app.load("client.adventure.packs.hero.AdventureHeroInformation")

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.num	= 0		-- 自己传入数量
	self.enum_type = {
		
	}
	
	self.show_type = {
		SHOP_RECHARGE_ITEM = 1,	--商店充值
		DIAMIND_SHOP = 2,	--钻石商店
		YUEKA_SHOP = 3,		--月卡界面
		VIP_SHOP = 4 , ---VIP
	}
	
	self.enum_resource_type = {
		-- _RESOURCE_TYPE_PROP 			= 0,	-- 道具类
		-- _RESOURCE_TYPE_SILVER 			= 1,	-- 银币类
		-- _RESOURCE_TYPE_GOLE 			= 2,	-- 钻石类

		SILVER_COIN_INFORMATION = 1,				-- 	1:银币
		GOLD_COIN_INFORMATION = 2,					--	2:金币 
		REPUTATION_INFORMATION = 3,					--	3:声望 
		HERO_SOUL_INFORMATION = 4,					--	4:将魂 
		SOUL_JADE_INFORMATION = 5,					--	5:魂玉 
		PROP_INFORMATION = 6,						--	6:道具 
		EQUIPMENT_INFORMATION = 7,					--	7:装备 
		EXPERIENCE_INFORMATION = 8,					--	8:经验 
		ENDURANCE_INFORMATION = 9,					--	9:耐力 
		FUNCTION_INFORMATION = 10,					--	10:功能点 
		BATTLE_NUMBER_PEOPLE_INFORMATION = 11,		--	11:上阵人数 
		PHYSICAL_STRENGTH_INFORMATION = 12,			--	12:体力
		HERO_INFORMATION = 13,						--	13:武将 
		AREAN_RANK_INFORMATION = 14,				--	14:竞技场排名
		DPS_INFORMATION = 15,						--	15:伤害
		DUEL_INFORMATION = 16,						--	16:比武积分
		POWER_INFORMATION = 17,						--	17:霸气
		GLORIES_INFORMATION= 18,					--	18:威名
		DAILYTASK_SCORE_INFORMATION = 19,			--	19:日常任务积分
		FEATS_INFORMATION = 20,						--	20:功勋
		BATTLE_ACHIEVEMENT_INFORMATION = 21,		--	21:战功
		RECHARGE_SHOP_INFORMATION = 22,				--	22:充值商店
	}
	
	
	self.panel_prop = nil
	self.isShowName = nil
	self.types = nil
	self.number = nil
	self.isHideNameAndCount = false

	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_prop_icon_cell_terminal()
	
        state_machine.init()
	end
	init_prop_icon_cell_terminal()
end

function adventureSignPropIconCell:onUpdateDraw()
	local root = self.roots[1]
	
end

function adventureSignPropIconCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("icon/item_prop.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	local size = root:getContentSize()
	self:setContentSize(size)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte.ExportJson")
	
	self.panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	
	local quality = 1
	local picIndex = 0
	if self.mould_data ~= nil then
		quality = dms.atoi(self.mould_data, prop_mould.prop_quality)+1
		picIndex = dms.atos(self.mould_data, prop_mould.pic_index)
	else
		if self.prop.resource_type == self.enum_resource_type.SILVER_COIN_INFORMATION then
			quality = 5
			picIndex = 6003
		elseif self.prop.resource_type == self.enum_resource_type.GOLD_COIN_INFORMATION then
			quality = 5
			picIndex = 6001
		elseif self.prop.resource_type == self.enum_resource_type.HERO_SOUL_INFORMATION then
			quality = 4
			picIndex = 6005
		elseif self.prop.resource_type == self.enum_resource_type.SOUL_JADE_INFORMATION then	
			quality = 5
			picIndex = 6005
		elseif self.prop.resource_type == self.enum_resource_type.REPUTATION_INFORMATION then	
			quality = 5
			picIndex = 6006
		elseif self.prop.resource_type == self.enum_resource_type.EXPERIENCE_INFORMATION then	
			quality = 1
			picIndex = 6007
		elseif self.prop.resource_type == self.enum_resource_type.FRIENDS_POINT then
			quality = 5
			picIndex = 2046
		elseif self.prop.resource_type == self.enum_resource_type.SYSTEM_PROP_PACKAGE then
			quality = 5
			picIndex = 6008
		end

	end
	-- 绘制品质框
	if quality == nil then
		print("AdventureHeroIconCell@onEnterTransitionFinish()", "hero mould_data prop_mould.ship_type is nil.")
		return
	end
	local qualityImage = nil
	if self.types == self.show_type.SHOP_RECHARGE_ITEM then
		qualityImage = "images/ui/quality/icon_hero_5.png"
	else
		qualityImage = string.format("images/ui/quality/icon_hero_%d.png", quality)
	end	
	self.panel_prop:setBackGroundImage(qualityImage)
	self.panel_prop:setTouchEnabled(true)
	
	local function formationTouchListener(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			self.isClickBegan = true
			self.isItemMove = false
			local ship_id = dms.int(dms["prop_mould"],   self.prop.mould_id, prop_mould.use_of_ship)
			if ship_id ~= nil and ship_id > 0 then 
				-- 需要显示英雄界面
				-- 这个地方用_dialog层比较特殊 ,在签到界面中,会弹出更多奖励,在弹出武将信息窗口,这个时候,需要比_windows 更高一层
   				fwin:open(AdventureHeroInformation:new():init({ship_template_id = ship_id}, nil), fwin._dialog)
				return 
			end
			
			if self.types == 4  then 
				fwin:open(AdventureActivityIconInfoSee:new():init(self.prop, self,4,false), fwin._dialog)
			else 
				fwin:open(AdventureActivityIconInfoSee:new():init(self.prop, self,0,false), fwin._dialog)
			end
		elseif eventType == ccui.TouchEventType.moved then 
			self.isItemMove = true
		elseif eventType == ccui.TouchEventType.ended then 
			fwin:close(fwin:find("AdventureActivityIconInfoSeeClass"))
		else 
			fwin:close(fwin:find("AdventureActivityIconInfoSeeClass"))
		end
	end
	if self.show_type ~= self.show_type.VIP_SHOP then 
		self.panel_prop:addTouchEventListener(formationTouchListener)
	end

	--绘制道具图标
	local Panel_item = ccui.Helper:seekWidgetByName(root, "Panel_item")
	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_reward_role")
	Panel_item:setTouchEnabled(false)

	Panel_item:removeBackGroundImage()
	Panel_role:removeBackGroundImage()
	Panel_item:setVisible(false)
	Panel_role:setVisible(false)
	Panel_role:removeAllChildren(true)
	if self.types == self.show_type.SHOP_RECHARGE_ITEM then
		Panel_item:setBackGroundImage("images/ui/icon/icon_baoshi.png")
		Panel_item:setVisible(true)
	else
		if zstring.tonumber(picIndex) < 1000 then
			local size = Panel_role:getContentSize()
			local armature = ccs.Armature:create("spirte")
			local spriteIcon = string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex))
	        local skinIcon = ccs.Skin:create(spriteIcon)
	        skinIcon:getTexture():setAliasTexParameters()
	        armature:getBone("big_head_"..1):addDisplay(skinIcon, 0)
	        armature:setPosition(cc.p(size.width/2,0))
	        
			Panel_role:addChild(armature)
			--Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex)))
			Panel_role:setVisible(true)
		else
			Panel_item:setBackGroundImage(string.format("images/ui/props/porps_%d.png", zstring.tonumber(picIndex)))
			Panel_item:setVisible(true)
		end
	end
	
	--数量
	if zstring.tonumber(self.number) > 0 and self.show_type ~= self.show_type.VIP_SHOP then
		ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_number"):setString(getResourceValueToStringForAdventure(self.number))
	end
end

function adventureSignPropIconCell:onExit()
	
end

function adventureSignPropIconCell:init(interfaceType, prop, numbers, drawType)
	self.current_type = interfaceType
	self.prop = prop
	self.mould_data = prop.mould_data or dms.element(dms["prop_mould"], self.prop.mould_id)
	self.types = drawType
	self.number = numbers
end

function adventureSignPropIconCell:createCell()
	local cell = adventureSignPropIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

