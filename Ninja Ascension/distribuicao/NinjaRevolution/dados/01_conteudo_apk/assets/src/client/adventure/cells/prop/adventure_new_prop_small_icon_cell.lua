----------------------------------------------------------------------------------------------------
-- 说明：道具的小图标绘制
-------------------------------------------------------------------------------------------------------
adventureNewSmallPropIconCell = class("adventureNewSmallPropIconCellClass", Window)

function adventureNewSmallPropIconCell:ctor()
    self.super:ctor()

	app.load("client.adventure.utils.AdventureActivityIconInfoSee")
    app.load("client.adventure.packs.hero.AdventureHeroInformation")
    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.num	= 0		-- 自己传入数量
	self.parentNode = nil  --父窗口节点,控制世界坐标
	self.button_item = nil
	self.isClickBegan = false
	self.isItemMove = false
	self.show_quantity = false
	self.propName = "" --道具名称 给外部使用
	self.enum_type = {
		
	}
	
	self.show_type = {

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
		FRIENDS_POINT = 23,							--  23:好友点数
		SYSTEM_PROP_PACKAGE = 24,					--  24:系统发送道具
		WARCRAFT_WIN_POINT = 25,					--  25:排位赛胜点
		WARCRAFT_INTEGRAL = 26,					    --  26:排位赛积分
		WARCRAFT_REWARD = 27,					    --  26:排位赛奖励
	}
	
	self.panel_prop = nil
	self.isShowName = nil
	self.types = nil
	self.number = nil
	self.isHideNameAndCount = false
	self.isGet = nil
	self.isDrawNumber = nil
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_prop_icon_cell_terminal()
	
        state_machine.init()
	end
	init_prop_icon_cell_terminal()
end

function adventureNewSmallPropIconCell:onUpdateDraw()
	local root = self.roots[1]
	
end

function adventureNewSmallPropIconCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("icon/item_prop_small.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local size = root:getContentSize()

	self:setContentSize(root:getContentSize())
	
	self.panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	self.button_item =  ccui.Helper:seekWidgetByName(root, "Button_item")
	ccui.Helper:seekWidgetByName(root, "Button_item"):setTouchEnabled(false)
	ccui.Helper:seekWidgetByName(root, "Text_number"):setColor(cc.c3b(255,255,255))
	
	
	-- debug.print_r(self.mould_data)
	-- debug.print_r(self.prop)
	-- 绘制品质框
	local quality = 1
	local picIndex = 0
	if self.mould_data ~= nil then
		quality = dms.atoi(self.mould_data, prop_mould.prop_quality)+1
		picIndex = dms.atos(self.mould_data, prop_mould.pic_index)
		self.propName =  dms.atos(self.mould_data, prop_mould.prop_name)
		local p = fwin:convertToWorldSpaceAR(self, cc.p(0, 0))
	else
		if self.prop.resource_type == self.enum_resource_type.SILVER_COIN_INFORMATION then
			quality = 1
			picIndex = 6003
			
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
		elseif self.prop.resource_type == self.enum_resource_type.EXPERIENCE_INFORMATION then	
			quality = 1
			picIndex = 6007
			self.propName = _All_tip_string_info._expNameDescription	
		elseif self.prop.resource_type == self.enum_resource_type.FRIENDS_POINT then
			quality = 5
			picIndex = 2046
		elseif self.prop.resource_type == self.enum_resource_type.SYSTEM_PROP_PACKAGE then
			quality = 5
			picIndex = 6008
		elseif self.prop.resource_type == self.enum_resource_type.WARCRAFT_WIN_POINT then --排位赛积分
			quality = 5
			picIndex = 6009
		elseif self.prop.resource_type == self.enum_resource_type.WARCRAFT_INTEGRAL then --排位赛积分
			quality = 5
			picIndex = 6010
		elseif self.prop.resource_type == self.enum_resource_type.WARCRAFT_REWARD then  --排位赛奖励
			quality = 5
			picIndex = 3295
		end
	end
	if quality == nil then
		print("AdventureHeroIconCell@onEnterTransitionFinish()", "hero mould_data prop_mould.ship_type is nil.")
		return
	end
	local qualityImage = nil
	if self.types == -1 then--矿搞是-1
		quality = 0
	end
	qualityImage = string.format("images/ui/quality/icon_prop_%d.png", quality)
	self.panel_prop:setBackGroundImage(qualityImage)
	local Panel_role_image = ccui.Helper:seekWidgetByName(root, "Panel_role_huodong")
	Panel_role_image:setVisible(false)
	--绘制道具图标
	local Panel_item = ccui.Helper:seekWidgetByName(root, "Panel_item")
	Panel_item:removeBackGroundImage()
	-- local picIndex = dms.atos(self.mould_data, prop_mould.pic_index)
	if self.types == -1 then--矿搞是-1
		Panel_item:setBackGroundImage("images/ui/icon/icon_kuanggongchu.png")
	elseif self.types == 4 then  -- 技能武器
		local equipInfo = dms.element(dms["equipment_mould"], self.prop.id)
		picIndex = dms.atos(equipInfo, equipment_mould.pic_index)
		Panel_item:setBackGroundImage(string.format("images/face/hero_head/bg_skill_skill_%d.png", zstring.tonumber(picIndex)))
	
	else -- 其他
		if zstring.tonumber(picIndex) < 1000 then
			Panel_role_image:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex)))
			Panel_role_image:setVisible(true)
		else
			Panel_item:setBackGroundImage(string.format("images/ui/props/porps_%d.png", zstring.tonumber(picIndex)))
			Panel_item:setScale(1.0)
		end	
	end
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
				if self.current_type == 7 then
					fwin:open(AdventureActivityIconInfoSee:new():init(self.prop, self,4,false), fwin._dialog)
				else
					fwin:open(AdventureActivityIconInfoSee:new():init(self.prop, self,4,false), fwin._dialog)
				end
				
			else 
				if self.current_type == 7 then 
					fwin:open(AdventureActivityIconInfoSee:new():init(self.prop, self,0,false), fwin._dialog)
				else 
					fwin:open(AdventureActivityIconInfoSee:new():init(self.prop, self,0,false), fwin._dialog)
				end
			end
		elseif eventType == ccui.TouchEventType.moved then 
			self.isItemMove = true
		elseif eventType == ccui.TouchEventType.ended then 
			fwin:close(fwin:find("AdventureActivityIconInfoSeeClass"))
		else 
			fwin:close(fwin:find("AdventureActivityIconInfoSeeClass"))
		end
	end
	if self.current_type  ~= 5 then
		ccui.Helper:seekWidgetByName(root, "Panel_item_2"):setTouchEnabled(true)
		ccui.Helper:seekWidgetByName(root, "Panel_item_2"):addTouchEventListener(formationTouchListener)
	else 
		ccui.Helper:seekWidgetByName(root, "Panel_item_2"):setTouchEnabled(false)
	end

	if self.types == 4 then 
		 -- 是技能武器,不需要显示其他信息
		 Panel_item:setColor(cc.c3b(255, 255, 255))
		 ccui.Helper:seekWidgetByName(root, "Text_text_number"):setVisible(false)
		 ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(false)
		return 
	end
	--数量
	-- local mould_id = dms.atoi(self.mould_data, prop_mould.id)	
	-- local have_amount = 0
	-- if (mould_id ~= nil) then
	-- 	have_amount = get_prop_amount(mould_id)
	-- end

	if self.number~=nil then
		local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
		if zstring.tonumber(self.number) == -1 then 
			--不显示--
			Text_number:setVisible(false)
		else
			ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(true)
			Text_number:setString(self.number)
			if (self.extra.show_quantity ~= nil and self.extra.show_quantity) then
				local mould_id = dms.atoi(self.mould_data, prop_mould.id)	
				local have_amount = 0
				if (mould_id ~= nil) then
					have_amount = get_prop_amount(mould_id)
				end
				if tonumber(have_amount) >= tonumber(self.number) then 
					Text_number:setColor(cc.c3b(255,255,255))
				else
					Text_number:setColor(cc.c3b(255,0,0))
				end
				Text_number:setString(have_amount .. "/" .. self.number)
			else
				
				local num_array = zstring.split("" .. self.number, "/")
				if  num_array ~= nil and #num_array == 2 then 
					local currentNum = num_array[1]
					local consumeNum = num_array[2]
					if tonumber(currentNum) >= tonumber(consumeNum) then
						Text_number:setColor(cc.c3b(255,255,255))
					else	
						Text_number:setColor(cc.c3b(255,0,0))
					end
				end
			end
		end
	else
		local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
		Text_number:setVisible(false)
		local Text_wuqiNumber = ccui.Helper:seekWidgetByName(root, "Text_text_number")
		ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(false)
		if self.isGet == nil or self.isGet =="" then
			if self.isDrawNumber ~= nil and self.isDrawNumber ~="" then	
				ccui.Helper:seekWidgetByName(root, "Text_text_number"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Text_text_number"):setString("0")
			end
			--Panel_item:setColor(cc.c3b(50, 50, 50))
		else
			if self.isDrawNumber ~= nil and self.isDrawNumber ~="" then	
				Text_wuqiNumber:setVisible(true)
				Text_wuqiNumber:setString("" .. self.isGet)
				local num_array = zstring.split("" .. self.isGet, "/")
				if num_array ~= nil and #num_array == 2 then 
					local currentNum = num_array[1]
					local consumeNum = num_array[2]
					if tonumber(currentNum) >= tonumber(consumeNum) then
						Text_wuqiNumber:setColor(cc.c3b(255,255,255))
					else	
						Text_wuqiNumber:setColor(cc.c3b(255,0,0))
					end
				end
			end
			Panel_item:setColor(cc.c3b(255, 255, 255))
		end
	end
end

function adventureNewSmallPropIconCell:onExit()
	
end

function adventureNewSmallPropIconCell:onUpdate(dt)

end

-- /**
-- *interfaceType		逻辑类型   --特殊情况  4 装备类型 5竞技场里面的,不需要显示提示  7 本周签到奖励,层级需要高一层
-- *prop				道具实例
-- *numbers			数量（没用过）
-- *drawType			绘制类型  4标示技能装备
-- *getprop			显示的数量（可以是字符串，同时控制暗和亮）
-- *isdrawNumber		是否显示数量
-- */
function adventureNewSmallPropIconCell:init(interfaceType, prop, numbers, drawType,getprop,isdrawNumber,parent, extra)
	self.current_type = interfaceType
	self.prop = prop
	self.mould_data = prop.mould_data or dms.element(dms["prop_mould"], self.prop.mould_id)

	self.types = drawType
	self.number = numbers
	self.isGet = getprop
	self.isDrawNumber = isdrawNumber
	self.parentNode = parent
	self.extra = extra or {}
end

function adventureNewSmallPropIconCell:createCell()
	local cell = adventureNewSmallPropIconCell:new()
	cell:registerOnNodeEvent(cell)
	--cell:registerOnNoteUpdate(cell)
	return cell
end

