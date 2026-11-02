----------------------------------------------------------------------------------------------------
-- 说明：道具的小图标绘制
-------------------------------------------------------------------------------------------------------
adventureShopIconCell = class("adventureShopIconCellClass", Window)

function adventureShopIconCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.role = nil		-- 当前要绘制的道具实例数据对对象
	self.num	= 0		-- 自己传入数量
	self.enum_type = {

	}
	
	self.panel_prop = nil
	self.isShowName = nil
	self.types = nil
	self.number = nil

	-- 初始化道具小图标事件响应需要使用的状态机
	-- local function init_prop_icon_cell_terminal()
	
        -- state_machine.init()
	-- end
	-- init_prop_icon_cell_terminal()
end

--灵魂数量
function adventureShopIconCell:showSoulNumber(number)
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Text_number"):setString("0")--没数据
end

--等级
function adventureShopIconCell:showLv(number)
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Text_level"):setString(number)
end

--战力
function adventureShopIconCell:showCombatCapability(number)
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Text_zhanli"):setString(number)
end

--画人物动作
function adventureShopIconCell:showShipAnimation()
	local root = self.roots[1]
	local mould_id = nil
	if self.prop.ship_id == nil or self.prop.ship_id == "" then
		mould_id = self.prop
	else
		mould_id = self.prop.ship_template_id
	end
	local temp_bust_index = dms.int(dms["ship_mould"], zstring.tonumber(mould_id), ship_mould.bust_index)
	-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
	local cell = AdventureSprite:create(temp_bust_index, 9) -- ccs.Armature:create("spirte_" .. temp_bust_index)
	cell:getAnimation():playWithIndex(0)
	self.panel_role:addChild(cell)
	cell:setAnchorPoint(cc.p(0.5, 0.5))
	cell:setPosition(cc.p(self.panel_role:getContentSize().width/2, self.panel_role:getContentSize().height/2))
end

--画人物形象
function adventureShopIconCell:showShipIcon()
	local root = self.roots[1]
	local picIndex = nil 
	if self.prop.ship_id == nil or self.prop.ship_id == "" then
		picIndex = dms.int(dms["ship_mould"], self.prop, ship_mould.head_icon)			-- 物品图标索引
	else
		picIndex = dms.int(dms["ship_mould"], self.prop.ship_template_id, ship_mould.head_icon)			-- 物品图标索引
	end
	self.panel_role:setBackGroundImage(string.format("images/ui/props/props_%d.png", zstring.tonumber(picIndex)))
end


function adventureShopIconCell:onUpdateDraw()
	local root = self.roots[1]
	local quality = nil
	local picIndex = nil 
	if self.role ~= nil then
		if self.prop.ship_id == nil or self.prop.ship_id == "" then
			quality = dms.int(dms["ship_mould"], self.prop, ship_mould.ship_type) + 1
		else
			quality = dms.int(dms["ship_mould"], self.prop.ship_template_id, ship_mould.ship_type) + 1
		end
	end
	-- self.panel_role:setBackGroundImage(string.format("images/ui/bg/bg_herolist_bg%d.png", quality)) -- 品质框
	-- ccui.Helper:seekWidgetByName(root, "Panel_item"):setBackGroundImage(string.format("images/ui/props/props_%d.png", zstring.tonumber(picIndex)))
	
	--
	
end

function adventureShopIconCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("icon/item_role.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self.panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	self.panel_role:removeAllChildren(true)
	
	self:onUpdateDraw()
	
end

function adventureShopIconCell:onExit()
	-- state_machine.remove("prop_icon_cell_show_prop_info")
	-- state_machine.remove("prop_icon_cell_show_hero_info")
	-- state_machine.remove("prop_head_manager")
end

function adventureShopIconCell:init(interfaceType, role, num, isShowName,types)
	self.current_type = interfaceType
	self.role = role
	self.number = num
end

function adventureShopIconCell:createCell()
	local cell = adventureShopIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

