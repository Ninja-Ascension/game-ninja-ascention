----------------------------------------------------------------------------------------------------
-- 说明：道具的小图标绘制
-------------------------------------------------------------------------------------------------------
adventurePropIconCell = class("adventurePropIconCellClass", Window)

function adventurePropIconCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.num	= 0		-- 自己传入数量
	self.enum_type = {
		SHOP_RECHARGE_ITEM = 1,	--商店充值
		DIAMIND_SHOP = 2,	--钻石商店
		YUEKA_SHOP = 3,		--月卡界面
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

function adventurePropIconCell:onUpdateDraw()
	local root = self.roots[1]
	local quality = nil
	local picIndex = nil 
	if self.prop ~= nil then
		if self.current_type == self.enum_type.YUEKA_SHOP then
			quality = self.prop.quality
		else
			if self.prop.mould_id == nil or self.prop.mould_id == "" then
				quality = dms.int(dms["prop_mould"], self.prop, prop_mould.prop_quality) + 1
				picIndex = dms.int(dms["prop_mould"], self.prop, prop_mould.pic_index)			-- 物品图标索引
			else
				quality = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.prop_quality) + 1
				picIndex = dms.int(dms["prop_mould"], self.prop.mould_id, prop_mould.pic_index)			-- 物品图标索引
			end
		end
		
	end
	if self.current_type == self.enum_type.SHOP_RECHARGE_ITEM then
		self.panel_prop:setBackGroundImage("images/ui/quality/icon_hero_5.png")
		ccui.Helper:seekWidgetByName(root, "Panel_item"):setBackGroundImage("images/ui/icon/icon_baoshi.png")
		ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_number"):setString(self.number)
	elseif self.current_type == self.enum_type.YUEKA_SHOP then
		self.panel_prop:setBackGroundImage(self.prop.mould_pic)
		self.panel_prop:setBackGroundImage("images/ui/bg/bg_item_bg.png") -- 品质框
		if zstring.tonumber(self.number) > 0 then
			ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_number"):setString(self.number)
		end
	else
		self.panel_prop:setBackGroundImage(string.format("images/ui/quality/icon_hero_%d.png", quality)) -- 品质框
		ccui.Helper:seekWidgetByName(root, "Panel_item"):setBackGroundImage(string.format("images/ui/props/porps_%d.png", zstring.tonumber(picIndex)))
		if zstring.tonumber(self.number) > 0 then
			ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_number"):setString(self.number)
		end
	end
end

function adventurePropIconCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("icon/item_prop.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self.panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	
	self:onUpdateDraw()
	
end

function adventurePropIconCell:onExit()
	-- state_machine.remove("prop_icon_cell_show_prop_info")
	-- state_machine.remove("prop_icon_cell_show_hero_info")
	-- state_machine.remove("prop_head_manager")
end

function adventurePropIconCell:init(interfaceType, prop, num, isShowName,types)
	self.current_type = interfaceType
	self.prop = prop
	self.number = num
end

function adventurePropIconCell:createCell()
	local cell = adventurePropIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

