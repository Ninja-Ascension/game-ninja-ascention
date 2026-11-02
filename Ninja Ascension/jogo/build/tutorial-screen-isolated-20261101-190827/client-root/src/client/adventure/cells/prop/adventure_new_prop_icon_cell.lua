----------------------------------------------------------------------------------------------------
-- 说明：道具的小图标绘制
-------------------------------------------------------------------------------------------------------
adventureNewPropIconCell = class("adventureNewPropIconCellClass", Window)

function adventureNewPropIconCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.num	= 0		-- 自己传入数量
	self.propName = ""  --道具名称 供外部使用  
	self.enum_type = {
		
	}
	
	self.show_type = {
		SHOP_RECHARGE_ITEM = 1,	--商店充值
		DIAMIND_SHOP = 2,	--钻石商店
		YUEKA_SHOP = 3,		--月卡界面
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
		RECHARGE_MONTH_CARD = 23,				--	23:月卡
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

function adventureNewPropIconCell:onUpdateDraw()
	local root = self.roots[1]
	
end

function adventureNewPropIconCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("icon/item_prop.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local size = root:getContentSize()
	
	self.panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	
	local quality = 1
	local picIndex = 0
	if self.mould_data ~= nil then
		quality = dms.atoi(self.mould_data, prop_mould.prop_quality)+1
		picIndex = dms.atos(self.mould_data, prop_mould.pic_index)
		self.propName =  dms.atos(self.mould_data, prop_mould.prop_name)
	else
		if self.prop.resource_type == self.enum_resource_type.SILVER_COIN_INFORMATION then
			quality = 5
			picIndex = 6003
			self.propName = _All_tip_string_info._fundName
		elseif self.prop.resource_type == self.enum_resource_type.GOLD_COIN_INFORMATION then
			quality = 5
			picIndex = 6001
			self.propName = _All_tip_string_info._crystalName
		elseif self.prop.resource_type == self.enum_resource_type.HERO_SOUL_INFORMATION then
			quality = 4
			picIndex = 6005
			self.propName = _All_tip_string_info._soulName
		elseif self.prop.resource_type == self.enum_resource_type.SOUL_JADE_INFORMATION then	
			quality = 5
			picIndex = 6005
		elseif self.prop.resource_type == self.enum_resource_type.REPUTATION_INFORMATION then	
			quality = 5
			picIndex = 6006
			self.propName = _All_tip_string_info._glories
		elseif self.prop.resource_type == self.enum_resource_type.RECHARGE_MONTH_CARD then	
			quality = 5
			picIndex = 6002
			self.propName = ""
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
	
	--绘制道具图标
	local Panel_item = ccui.Helper:seekWidgetByName(root, "Panel_item")
	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_reward_role")
	Panel_item:removeBackGroundImage()
	Panel_role:removeBackGroundImage()
	Panel_item:setVisible(false)
	Panel_role:setVisible(false)
	if self.types == self.show_type.SHOP_RECHARGE_ITEM then
		Panel_item:setBackGroundImage("images/ui/icon/icon_baoshi.png")
		Panel_item:setVisible(true)
	else
		if zstring.tonumber(picIndex) < 1000 then
			Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex)))
			Panel_role:setVisible(true)
		else
			Panel_item:setBackGroundImage(string.format("images/ui/props/porps_%d.png", zstring.tonumber(picIndex)))
			Panel_item:setVisible(true)
		end
	end
	
	local image = ccui.Helper:seekWidgetByName(root, "Image_1")
	local number = ccui.Helper:seekWidgetByName(root, "Text_number")
	
	number:setString(getResourceValueToStringForAdventure(self.number))
	image:setVisible(zstring.tonumber(self.number) > 0)
	number:setVisible(zstring.tonumber(self.number) > 0)
	
end

function adventureNewPropIconCell:onExit()
	
end

function adventureNewPropIconCell:init(interfaceType, prop, numbers, drawType)
	self.current_type = interfaceType
	self.prop = prop
	self.mould_data = prop.mould_data or dms.element(dms["prop_mould"], self.prop.mould_id)
	self.types = drawType
	self.number = numbers
	local quality = 1
	local picIndex = 0
	if self.mould_data ~= nil then
		self.propName =  dms.atos(self.mould_data, prop_mould.prop_name)
	else
		if self.prop.resource_type == self.enum_resource_type.SILVER_COIN_INFORMATION then
			self.propName = _All_tip_string_info._fundName
		elseif self.prop.resource_type == self.enum_resource_type.GOLD_COIN_INFORMATION then
			self.propName = _All_tip_string_info._crystalName
		elseif self.prop.resource_type == self.enum_resource_type.HERO_SOUL_INFORMATION then
			self.propName = _All_tip_string_info._soulName
		elseif self.prop.resource_type == self.enum_resource_type.SOUL_JADE_INFORMATION then		
		elseif self.prop.resource_type == self.enum_resource_type.REPUTATION_INFORMATION then	
			self.propName = _All_tip_string_info._glories
		end
	end
end

function adventureNewPropIconCell:createCell()
	local cell = adventureNewPropIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

