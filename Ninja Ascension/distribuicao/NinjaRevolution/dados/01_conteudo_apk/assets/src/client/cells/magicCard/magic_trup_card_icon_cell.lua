----------------------------------------------------------------------------------------------------
-- 说明：魔陷卡小图标
-------------------------------------------------------------------------------------------------------
MagicTrupCardIconCell = class("MagicTrupCardIconCellClass", Window)

function MagicTrupCardIconCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.magicInfo = nil		-- 当前要绘制的道具实例数据对对象
	self.num = nil
	local function init_magic_trup_icon_cell_terminal()

	end
	init_magic_trup_icon_cell_terminal()
end

function MagicTrupCardIconCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)
	Image_2:setSwallowTouches(false)
	
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")--装备等级底框
	local item_name = ccui.Helper:seekWidgetByName(root, "Label_name")--名称
	local item_shuxin = ccui.Helper:seekWidgetByName(root, "Label_shuxin")--属性
	local item_lv = ccui.Helper:seekWidgetByName(root, "Text_1")--右上角等级
	local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end

	local magicMouldData = dms.element(dms["magic_trap_card_info"], self.magicInfo)
	local picIndex = 0
	local quality = 0
	Panel_num:setVisible(false)
	item_name:setString("")
	local magic_type = dms.atoi(magicMouldData,magic_trap_card_info.card_type)
	if magic_type == 0 then 
		quality = 2
	else
		quality = 4
	end
	picIndex = dms.atoi(magicMouldData,magic_trap_card_info.pic)
	Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
	Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
	if self.num ~= nil then 
		item_order_level:setVisible(true)
		item_order_level:setString("x"..self.num)
	end
end

function MagicTrupCardIconCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("icon/item.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()
end

function MagicTrupCardIconCell:onExit()
	local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")
	if Label_l_order_level ~= nil then 
	    Label_l_order_level:setVisible(true)
	    if Label_l_order_level._x then
		    Label_l_order_level:setPositionX(Label_l_order_level._x)
		end
	    Label_l_order_level:setString("")
	end
	
end

function MagicTrupCardIconCell:init(magicId,cardCounts)
	self.magicInfo = magicId
	self.num = cardCounts
end

function MagicTrupCardIconCell:showName(id,types)
	local root = self.roots[1]
	local nameCell = ccui.Helper:seekWidgetByName(root, "Label_name")--mingzi
	local quality = nil
	local name = nil
	local magic_type = dms.int(dms["magic_trap_card_info"],self.magicInfo,magic_trap_card_info.card_type)
	if magic_type == 0 then 
		quality = 2
	else
		quality = 4
	end

	name = dms.string(dms["magic_trap_card_info"], self.magicInfo,magic_trap_card_info.card_name)
	nameCell:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
	nameCell:setString(name)
	nameCell:setVisible(true)
end

function MagicTrupCardIconCell:getName()
	local cardName = ""
	card_name = dms.string(dms["magic_trap_card_info"],self.magicInfo,magic_trap_card_info.card_name)
	return cardName
end

function MagicTrupCardIconCell:getQuality()
	local magic_type = dms.int(dms["magic_trap_card_info"],self.magicInfo,magic_trap_card_info.card_type)
	local quality = 2
	if magic_type == 0 then 
		quality = 2
	else
		quality = 4
	end
	return quality
end

function MagicTrupCardIconCell:createCell()
	local cell = MagicTrupCardIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

