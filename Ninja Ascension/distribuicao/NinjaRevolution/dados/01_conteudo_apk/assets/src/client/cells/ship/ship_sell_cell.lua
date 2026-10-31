---------------------------------
---说明：武将出售选项卡
-- 创建时间:2015.03.16
-- 作者：刘迎
-- 修改记录：
-- 最后修改人：
---------------------------------

HeroSellCell = class("HeroSellCellClass", Window)
   
function HeroSellCell:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
	self.ship = {0}
	self.interfaceType = 1
	
	self.sell_hero_name = "孙权"			--武将名字
	self.sell_hero_grade = 20				--武将等级
	self.sell_hero_surmount = "突破：0"		--武将突破等级
	self.hero_grade_information = "等级"

	self.hero_sell_price_name = "价格"
	self.hero_sell_price = 1000
	app.load("client.cells.ship.ship_head_new_cell")
end

function HeroSellCell:onUpdateDraw()
	local root = self.roots[1]
	
	local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")		--绘制武将小图标控件
	local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")			-- 武将名字
	local Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")		-- “等级”
	local Text_3 = ccui.Helper:seekWidgetByName(root, "Text_3")
	local Text_4 = ccui.Helper:seekWidgetByName(root, "Text_4")			-- 武将等级
	local Text_41 = ccui.Helper:seekWidgetByName(root, "Text_41")			-- 武将等级
	local Button_1 = ccui.Helper:seekWidgetByName(root, "Button_1")		-- 去获取按钮
	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")		-- 勾勾框


	local Text_6 = ccui.Helper:seekWidgetByName(Panel_6, "Text_6")		--价格
	local Text_7 = ccui.Helper:seekWidgetByName(Panel_6, "Text_7")		--“价格”
	local Image_9 = ccui.Helper:seekWidgetByName(Panel_6, "Image_9")	--未勾选图片
	local Image_10 = ccui.Helper:seekWidgetByName(Panel_6, "Image_10")	--已勾选图片

	local levelNumber = ccui.Helper:seekWidgetByName(root, "Text_300")
	levelNumber:setString("")
	Text_41:setString("")
	
	-- app.load("client.cells.ship.ship_head_cell")
	--掉用绘制头部图像控件实现绘图
	local cell = ShipHeadNewCell:createCell()
	cell:init(self.ship, self.interfaceType)
	Panel_3:addChild(cell)
	
	Text_1:setString(self.sell_hero_name)
	Text_1_0:setString(self.hero_grade_information)

	Text_3:setString(self.sell_hero_grade)
	Text_4:setString(self.sell_hero_surmount)

	Button_1:setVisible(false)
	Panel_6:setVisible(true)
	
	Text_7:setString(self.hero_sell_price_name)
	Text_6:setString(self.hero_sell_price)
	
	Image_9:setVisible(true)
	Image_10:setVisible(false)
	
end


function HeroSellCell:onEnterTransitionFinish()

    --获取 武将碎片选项卡 美术资源
    local csbListEquipmentSui = csb.createNode("list/list_equipment_sui_1.csb")
	local root = csbListEquipmentSui:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbListEquipmentSui)
	
	-- 列表控件动画播放
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local action = csb.createTimeline("list/list_equipment_sui_1.csb")
	    csbListEquipmentSui:runAction(action)
	    action:play("list_view_cell_open", false)
	end
	
	self:onUpdateDraw()
end


function HeroSellCell:onExit()
	state_machine.remove("ship_fragment_seat_find")
end