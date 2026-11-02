---------------------------------
---说明：宝物出售信息选项卡界面
-- 创建时间:2015.03.19
-- 作者：刘迎
-- 修改记录：
-- 最后修改人：
---------------------------------

TreasureSellSeatCell = class("TreasureSellSeatCellClass", Window)
TreasureSellSeatCell.__size = nil
   
function TreasureSellSeatCell:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.status = false
	self.treasureInstance = nil
	
	self.statusBoxArt = nil		-- statusBox 的打勾 美术资源
	self.myPrice = 0			-- 我自己可以卖多少钱一晚

	self.selected = false		-- 是否已经被选取了
	
	self.showTypeMode = 1		-- 显示模式 1 = 出售 2 = 材料选择
	app.load("client.cells.treasure.treasure_icon_new_cell")
	app.load("client.cells.treasure.treasure_icon_cell")
	
    -- Initialize HeroSeat state machine.
    local function init_treasure_sell_seat_terminal()
		-- 选项勾选
		-- local treasure_sell_selected_on_offs_terminal = {
            -- _name = "treasure_sell_selected_on_offs",
            -- _init = function (terminal) 
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- local tempCell = params._datas.cell
				-- > print("*************")
				-- state_machine.excute("treasure_material_selected_one", 0, tempCell)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- state_machine.add(treasure_sell_selected_on_off_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_treasure_sell_seat_terminal()
end

function TreasureSellSeatCell:onUpdateDraw()
	
	local root = self.roots[1]
	local currentTreasure = self.treasureInstance
	
	local levelNumber = ccui.Helper:seekWidgetByName(root, "Text_300")
	levelNumber:setString("")
	local selNumber = ccui.Helper:seekWidgetByName(root, "Text_6")
	selNumber:setString("")
	local Text_41 = ccui.Helper:seekWidgetByName(root, "Text_41")
	Text_41:setString("")

	-- 宝物名字
	local textTreasureName = ccui.Helper:seekWidgetByName(root, "Panel_2"):getChildByName("Text_1")
	textTreasureName:setString(currentTreasure.user_equiment_name)
	
	-- 重新设置宝物的名字颜色
	local quality = dms.int(dms["equipment_mould"], currentTreasure.user_equiment_template, equipment_mould.grow_level) + 1
	self:setTextLabelColor(textTreasureName, quality)
	--进行文字描边
	self:setTextOutline(textTreasureName)
	
	--加载Icon图片cell
	local iconLayer = ccui.Helper:seekWidgetByName(root, "Panel_3")
	iconLayer:removeAllChildren(true)
	local tic = TreasureIconNewCell.createCell()
	tic:init(self.treasureInstance,2)
	iconLayer:addChild(tic);
	
	--获取宝物等级
	local textLv = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	if verifySupportLanguage(_lua_release_language_en) == true then
		textLv:setString(_string_piece_info[6]..currentTreasure.user_equiment_grade)
	else
		textLv:setString(currentTreasure.user_equiment_grade .. _string_piece_info[6])
	end
	--self:setTextOutline(textLv)
	
	local textPrice = ccui.Helper:seekWidgetByName(root, "Text_7")
	textPrice:setString("")
	
	if self.showTypeMode == 1 then	--showTypeMode = 1显示价格
		local price = dms.int(dms["equipment_mould"], currentTreasure.user_equiment_template, equipment_mould.silver_price)
		self.myPrice = price
		textPrice:setString(_string_piece_info[17])
		selNumber:setString(price)
		--self:setTextOutline(textPrice)
	elseif self.showTypeMode == 2 then	--showTypeMode = 2 显示价格经验值
		local totalExp = 0
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_warship_girl_b 
			then 
			totalExp = getOfferOfTreasureExp(currentTreasure.user_equiment_id)
		else
			local initExp = dms.int(dms["equipment_mould"], tonumber(currentTreasure.user_equiment_template), equipment_mould.initial_supply_escalate_exp)
			totalExp = currentTreasure.user_equiment_exprience + initExp
		end
		textPrice:setString(_string_piece_info[134])
		selNumber:setString(totalExp)
	end
	
end


--设置文本描边
function TreasureSellSeatCell:setTextOutline(text)
	text:enableOutline(cc.c4b(120, 120, 120, 255), 1)
end

--判断这件宝物是否可以出售
function TreasureSellSeatCell:canSell()
	local price = dms.int(dms["equipment_mould"], self.treasureInstance.user_equiment_template, equipment_mould.silver_price)
	if price > 0 then
		return true
	end
	return false
end

--设置文本颜色
function TreasureSellSeatCell:setTextLabelColor(label, quality)
	label:setColor(cc.c3b(
		tipStringInfo_quality_color_Type[quality][1],
		tipStringInfo_quality_color_Type[quality][2],
		tipStringInfo_quality_color_Type[quality][3]
	))
end

function TreasureSellSeatCell:onEnterTransitionFinish()

end
function TreasureSellSeatCell:onInit()

 --    local csbTreasureSellSeatCell = csb.createNode("list/list_equipment_sui_1.csb")
	-- local root = csbTreasureSellSeatCell:getChildByName("root")
	-- root:removeFromParent(true)
 --    self:addChild(root)
	-- table.insert(self.roots, root)

	local root = cacher.createUIRef("list/list_equipment_sui_1.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	-- -- 列表控件动画播放
	-- local action = csb.createTimeline("list/list_equipment_sui_1.csb")
 --    root:runAction(action)
 --    action:play("list_view_cell_open", false)
	local head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_3")
	head:removeAllChildren(true)
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_2")
	local panelSize = panel:getContentSize()
	
	--隐藏去寻找按钮
	local tmpBtn = ccui.Helper:seekWidgetByName(root, "Button_1")
	tmpBtn:setVisible(false)
	
	--显示整个底板
	local statusBoxPanel = ccui.Helper:seekWidgetByName(root, "Panel_6")
	statusBoxPanel:setVisible(true)
	
	--将钩钩图片设置为不可见 并且 不可响应touch事件
	local statusBoxArt = ccui.Helper:seekWidgetByName(root, "Image_10")
	-- statusBoxArt:setVisible(false)
	statusBoxArt:setTouchEnabled(false)
	self.statusBoxArt = statusBoxArt
	
	--为底板设置点击事件
	local checkBox = ccui.Helper:seekWidgetByName(root, "Image_9")
	checkBox:setTouchEnabled(false)

	ccui.Helper:seekWidgetByName(root, "Button_7"):setVisible(false)
	
	--为整个面板添加点击事件
	if self.showTypeMode == 1 then 
		statusBoxArt:setVisible(self.selected)
		fwin:addTouchEventListener(statusBoxPanel, nil, 
		{
			terminal_name = "treasure_sell_selected_on_off", 
			next_terminal_name = "", 
			but_image = "", 
			terminal_state = 0, 
			isPressedActionEnabled = false,
			cell = self
		}, 
		nil, 0)
		
	elseif self.showTypeMode == 2 then
		statusBoxArt:setVisible(self.status)
		fwin:addTouchEventListener(statusBoxPanel, nil, 
		{
			terminal_name = "treasure_material_selected_one", 
			next_terminal_name = "", 
			but_image = "", 
			terminal_state = 1, 
			isPressedActionEnabled = false,
			cell = self
		}, 
		nil, 0)
		
	end
	
	--调用自己的更新函数
	self:onUpdateDraw()
	if TreasureSellSeatCell.__size == nil then
		TreasureSellSeatCell.__size = panelSize
		-- self:setContentSize(panelSize)
	end
	
end

--通用按钮点击事件添加
-- function TreasureSellSeatCell:addTouchEventFunc(uiName, eventName, actionMode)
	-- local tmpArt = ccui.Helper:seekWidgetByName(self.roots[1], uiName)
	-- fwin:addTouchEventListener(tmpArt, nil, 
	-- {
		-- terminal_name = eventName, 
		-- next_terminal_name = "", 
		-- but_image = "", 	
		-- terminal_state = 0, 
		-- isPressedActionEnabled = actionMode
	-- }, 
	-- nil, 0)
	-- return tmpArt
-- end

function TreasureSellSeatCell:close( ... )
	local head = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_3")
	head:removeAllChildren(true)
end

function TreasureSellSeatCell:onExit()
	-- state_machine.remove("treasure_sell_selected_on_off")
	cacher.freeRef("list/list_equipment_sui_1.csb",  self.roots[1])
end

function TreasureSellSeatCell:init(value, typeMode, index)
	--> print("TreasureSellSeatCell:init", value.user_equiment_template)
	self.treasureInstance = value
	self.showTypeMode = typeMode

	if index ~= nil and index < 8 then
		self:onInit()
	end

	self:setContentSize(TreasureSellSeatCell.__size)
	return self
end

function TreasureSellSeatCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function TreasureSellSeatCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	if Panel_3 ~= nil then
		Panel_3:removeAllChildren(true)
	end
	cacher.freeRef("list/list_equipment_sui_1.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:removeFromParent(false)
	self.roots = {}
	self.statusBoxArt = nil
end

function TreasureSellSeatCell:createCell()
	local cell = TreasureSellSeatCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
