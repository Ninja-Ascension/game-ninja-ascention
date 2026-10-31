----------------------------------------------------------------------------------------------------
-- 说明：用于时装列表的小图标绘制
-------------------------------------------------------------------------------------------------------
FashionListviewIconCell = class("FashionListviewIconCellClass", Window)

function FashionListviewIconCell:ctor()
    self.super:ctor()
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.fashion.fashion_icon_cell")

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0

	self.enum_type = {
		_FROM_FORMATION_GOTO_FASHION_INFORMATION = 1,		-- 从阵容界面进入时装信息界面
		_FROM_FORMATION_GOTO_FASHION_INFORMATION_SHIP = 2,  -- 时装列表的战船 
	}

	self.equip = nil		-- 当前要绘制的装备实例数据对对象
	self.mould_id = nil
	self.shipData = nil   --穿戴装备的shipId
	self.is_active = false
	self.num = nil	--数量
	self.isShowName = nil
	self.isHideNameAndCount = false
	self.grade = nil 
	self.ship = nil
	self.isWear = false
	-- 初始化事件响应需要使用的状态机 fashion_listview_icon_cell.lua
	local function init_fashion_listview_icon_cell_terminal()
		
		local fashion_listview_icon_cell_set_chosen_terminal = {
            _name = "fashion_listview_icon_cell_set_chosen_state_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local _self = params._datas._self
            	if params._datas._grade ~= nil and params._datas._grade == -1 then
            		app.load("client.packs.hero.HeroPatchInformationPageGetWay")
					-- local fightWindow = EquipAcquire:new()
					local fightWindow = HeroPatchInformationPageGetWay:new()
					fightWindow:init(_self.mould_id,3)
					fwin:open(fightWindow, fwin._windows)
            		return true
            	end
            	
				
				
				local data = {
					source = _self
				}

				state_machine.excute("fashion_develop_open_updata_index", 0, data)
				state_machine.excute("fashion_information_page_refresh", 0, data)
				state_machine.excute("fashion_strengthen_page_refresh", 0, data)
				state_machine.excute("fashion_recast_page_refresh", 0, data)
				
				local _messageName = ObjectMessageNameEnum.fashion_listview_icon_cell_set_chosen_state
				local _messageData = ObjectMessageData.getInitExample(_messageName)
				_messageData.source = _self
				_messageData.target = _self
				ObjectMessage.fireMessage(_messageName, _messageData)
				
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(fashion_listview_icon_cell_set_chosen_terminal)	
			
        state_machine.init()
	end
	init_fashion_listview_icon_cell_terminal()
end

function FashionListviewIconCell:onUpdateDraw2()
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
	local Text_nub = ccui.Helper:seekWidgetByName(root, "Text_nub")--zuo上角等级
	local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	local Image_bidiao =  ccui.Helper:seekWidgetByName(root, "Image_bidiao") -- 装备中
	-- ccui.Helper:seekWidgetByName(root, "Text_huoqu"):setVisible(false)
	Panel_num:setVisible(false)
	Text_nub:setString("")
	if self.ship ~= nil then
		local picIndex = 0
		local quality = 0
		local item_index = nil--物品图标索引
		local item_qulityindex = nil--物品品质索引
		local item_nameIndex = nil--物品名称索引
		local item_mouldid = nil--物品模板id
		item_index = ship_mould.head_icon
		item_qulityindex = ship_mould.ship_type
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[tonumber(ship_evo[1])]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			item_nameIndex = word_info[3]
		else
			item_nameIndex = ship_mould.captain_name
		end
		item_mouldid= self.ship.ship_template_id
		
		picIndex = dms.int(dms["ship_mould"], item_mouldid, item_index)
		quality = dms.int(dms["ship_mould"], item_mouldid, item_qulityindex)+1
		-- print("self.ship.equipment[7]")
		Image_bidiao:setVisible(true)
		self.isWear = true
		for i, equip in pairs(self.ship.equipment) do
			if i > 8 then
				break
			end			
			if tonumber(equip.ship_id) > 0 then  
				if tonumber(equip.equipment_type) == 6 then
					Image_bidiao:setVisible(false)
					self.isWear = false
				end
			end
		end
		if self.ship.captain_type == "0" then
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		else
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		end
		Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
	end
end

function FashionListviewIconCell:onUpdateDraw1()
	local root = self.roots[1]
	if root == nil then 
		return 
	end 
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	local Image_bidiao =  ccui.Helper:seekWidgetByName(root, "Image_bidiao") -- 装备中
	local Text_huoqu =  ccui.Helper:seekWidgetByName(root, "Text_huoqu") -- 获取

	self.size = root:getContentSize()
	
	self:setContentSize(self.size)

	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	-- local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")--装备等级底框
	local item_name = ccui.Helper:seekWidgetByName(root, "Label_name")--名称
	-- local item_shuxin = ccui.Helper:seekWidgetByName(root, "Label_shuxin")--属性
	local Text_nub = ccui.Helper:seekWidgetByName(root, "Text_nub")--zuo上角等级
	-- local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级


	if self.isHideNameAndCount == true then
		item_name:setVisible(false)
		item_order_level:setVisible(false)
	end
	local picIndex = 0
	local quality = 0
	local item_index = nil--物品图标索引
	local item_qulityindex = nil--物品品质索引
	local item_nameIndex = nil--物品名称索引
	local item_mouldid = nil--物品模板id

	item_index = equipment_mould.pic_index
	item_qulityindex = equipment_mould.grow_level
	item_nameIndex = equipment_mould.equipment_name
	local Equip = fundEquipWidthId(self.mould_id)
	self.equip = Equip
	if self.equip ~= nil then
		item_mouldid= self.equip.user_equiment_template
	else
		item_mouldid = self.mould_id
	end
	picIndex = dms.int(dms["equipment_mould"], item_mouldid, item_index)
	-- picIndex = 2001
	quality = dms.int(dms["equipment_mould"], item_mouldid, item_qulityindex) + 1

	Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
	Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
	item_name:setString(dms.string(dms["equipment_mould"], item_mouldid, item_nameIndex))
	item_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	Panel_num:setBackGroundImage(string.format("images/ui/quality/level_%d.png", quality))

	-- if self.equip ~= nil then 
	-- 	item_lv:setString(self.equip.user_equiment_grade)
	-- end Text_1
	ccui.Helper:seekWidgetByName(root, "Panel_prop"):setTouchEnabled(true)
	self.isWear =false

	local Equip = fundEquipWidthId(item_mouldid)
    if Equip ~= nil then
        if tonumber(Equip.ship_id) > 0 then
            self._grade = 10000
        else
            self._grade = tonumber(Equip.user_equiment_grade)
        end
        
    else
        self._grade = -1
    end
    self.grade = self._grade
	if self.grade ~= nil then
		if self.grade == -1 then
			Image_bidiao:setVisible(false)
			-- print("未获得")
			Text_huoqu:setVisible(true)
			Panel_num:setVisible(false)
			Text_nub:setString("")
			-- ccui.Helper:seekWidgetByName(root, "Panel_prop"):setTouchEnabled(false)
			self.isWear = true
			Panel_prop:setColor(cc.c3b(tipStringInfo_fashion_str[3][1],tipStringInfo_fashion_str[3][2],tipStringInfo_fashion_str[3][3]))
		elseif self.grade == 10000 then
			Image_bidiao:setVisible(true)
			Text_huoqu:setVisible(false)
			Panel_num:setVisible(true)
			
			Text_nub:setString(self.equip.user_equiment_grade)
			self.isWear = true
			-- print("已装备")
		else
			Image_bidiao:setVisible(false)
			Text_huoqu:setVisible(false)
			Panel_num:setVisible(true)
			Text_nub:setString(self.equip.user_equiment_grade)
			-- print("已拥有")
		end
	end
end
function FashionListviewIconCell:onUpdateDraw()
	if self.current_type == self.enum_type._FROM_FORMATION_GOTO_FASHION_INFORMATION then
		self:onUpdateDraw1()
	elseif self.current_type == self.enum_type._FROM_FORMATION_GOTO_FASHION_INFORMATION_SHIP then
		self:onUpdateDraw2()
	end
end

function FashionListviewIconCell:setChosen()
	self.image_light:setVisible(true)
end

function FashionListviewIconCell:removeChosen()
	self.image_light:setVisible(false)
end

function FashionListviewIconCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("fashionable_dress/fashionable_icon.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	--高亮背景图
	local image_light = ccui.Helper:seekWidgetByName(root, "Image_fa_light")
	self.image_light = image_light
	
	--icon容器层
	-- local panel_grid = ccui.Helper:seekWidgetByName(root, "Panel_13")
	
	--点击触发层

	local panel_touch = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	

	self:setSwallowTouches(true)

	--处理滑动时触发点击
	local function panel_touch_onTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if evenType == ccui.TouchEventType.began then
		elseif evenType == ccui.TouchEventType.moved then
		elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
			if math.abs(__epoint.x - __spoint.x) < 5 then
				-- fwin:addTouchEventListener(panel_liaght, nil, {
					-- terminal_name = "fashion_listview_icon_cell_click", 
					-- terminal_state = 0, 
					-- _target = self
				-- }, nil, 0)
				
				state_machine.excute("fashion_listview_icon_cell_set_chosen_state_change", 0, {_datas = {_self = self,_grade=self.grade}})
			end
			
		end
	end
	
	--插入显示icon

	
	--  local cell = FashionIconCell:createCell()
	-- cell:init(self.current_type, self.equip, self.mould_id, self.shipData, self.isShowName, self.num, self.grade, self.ship)
	-- panel_grid:addChild(cell)
	self._data = self.mould_id
	
	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_indiana_cell",
		-- _widget = cell,
		-- _invoke = nil,
		-- _interval = 0.5,})	
	--绘制更新
	self:onUpdateDraw()
	
	--默认不选中
	self:removeChosen()
	
	-- 监听消息
	panel_touch:addTouchEventListener(panel_touch_onTouchEvent)
	ObjectMessage.addMessageListener(ObjectMessageNameEnum.fashion_listview_icon_cell_set_chosen_state, 
		self, 
		function(instance, params)
			if params.target == instance then
				if type(instance.setChosen) == "function" then
					instance:setChosen()
				end
			else
				if type(instance.removeChosen) == "function" then
					instance:removeChosen()
				end
			end
		end
	)
end

function FashionListviewIconCell:onExit()
	-- state_machine.remove("fashion_listview_icon_cell_change_ship_Plunder")
	-- state_machine.remove("fashion_listview_icon_cell_change_Plunder_storage")
	-- state_machine.remove("fashion_listview_icon_cell_change_shop_buy")
	ObjectMessage.removeMessageListener(ObjectMessageNameEnum.fashion_listview_icon_cell_set_chosen_state, self)
end

function FashionListviewIconCell:getId()
	return self.mould_id
end

function FashionListviewIconCell:init(interfaceType, equip, mould_id, shipData, isShowName, num, grade, ship)
	self.current_type = interfaceType
	self.equip = equip
	self.mould_id = mould_id
	self.shipData = shipData
	self.isShowName = isShowName
	self.num = num
	self.grade = grade
	self.ship = ship
end

function FashionListviewIconCell:createCell()
	local cell = FashionListviewIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

