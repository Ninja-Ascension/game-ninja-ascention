----------------------------------------------------------------------------------------------------
-- 说明：道具的小图标绘制
-------------------------------------------------------------------------------------------------------
PropIconCell = class("PropIconCellClass", Window)

function PropIconCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.num	= 0		-- 自己传入数量
	self.enum_type = {
		_SHOW_EQUIPMENT_INFORMATION = 1,					-- 查看装备信息
		_COPY_PAGE_DROP_REWARD_INFORMATION = 2,					-- 
		_SHOW_HERO_INFORMATION = 3,					-- 查看武将碎片信息
		_SHOW_EQUIP_INFORMATION = 4,					-- 查看装备碎片信息
		_SHOW_REWARD_INFORMATION = 5,		-- 显示名字和数量 （底部和右下角）
		_SHOW_REWARD_POINT_INFORMATION = 6,	-- 显示数量
		_SHOW_PROP_INFORMATION = 7,			-- 查看道具信息
		_SHOW_RES_INFORMATION = 8, 			-- 查看物品信息
		_SHOW_PROP_GETWAY_INFORMATION = 9,  -- 查看道具获取途径 不可点击 无数量显示
		_SHOW_PROP_GETWAY_INFORMATION_PROP = 10,  -- 查看道具获取途径
		_SHOW_PROP_INFORMATION_NOT_CHOOSE = 11,  -- 查看道具信息(点击无响应)
		_SHOW_ONLY_ICON = 12,					--不要显示名称
		_SHOW_ONLY_ICON_NOT_CHOOSE = 13,			--不要显示名称
		_SHOW_ONLY_ICON_NOT = 14,			--神将商店
		_VALUE_IS_MOULD = 15,				--传参为模板
		_VALUE_IS_MOULD_AND_REWORLD = 16,				--传参为模板且显示传参数
		_VALUE_IS_MOULD_HONOR_SHOP = 17,				--荣誉商店
		_SHOW_MINE_REWARD_INFORMATION = 18,				--领地攻讨
		_BATTLE_INFO = 19,							--战斗结算
		_CARD_INFO = 20,							--翻牌结算
		_VALUE_IS_MOULD_HONOR_SHOP_SHIP = 21, --荣誉商店,但是id是战船
		_GET_WAY = 22, --荣誉商店,但是id是战船
		_DUPLICATE = 23, --副本专用
		_VIP_SHOP = 24, --VIP礼包
		_VALUE_IS_MOULD_HONOR_SHOP_equip = 25,--荣誉商店,但是id是装备
		GAIN_REWARD_CELL_ICON = 26,--领奖中心道具头像绘制d
		GAIN_REWARD_SEVEN_DAY = 27,--七日活动
		_VIP_SHOW = 28,								-- Vip特权查看
		_SPECIAL_PASS = 29,								-- 帐篷
		_MOPPING_RESULT = 30,								-- 副本扫荡
		_DOUBLE_DISCOUNT = 31,								-- 双倍活动
		_DAILY_BOX = 32,--日常礼包
		_WORLD_BOSS_REWARD = 33, --日常功勋奖励
		_UNION_CLEAR_REWARD = 34, --军团通关奖励
		_CATURE_REWARD = 35, --军团通关奖励
		_AWAKEN_SHOP = 36 , 		--- 觉醒商店展示
		_AWAKEN_PROP_BROWSE = 37 , 		--- 觉醒道具浏览弹出装备信息
		_EQUIP_AWAKEN_COMPOSE = 38,		--觉醒装备合成 数字用 x/x 标示，道具不足，颜色改成红色
		_BOX_OPEN_CHOOSE = 39,		--宝箱多选一
	}
	
	self.panel_prop = nil
	self.isShowName = nil
	self.types = nil

	self.isHideNameAndCount = false

	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_prop_icon_cell_terminal()

		-- 点击道具小图标需要处理的逻辑
		local prop_icon_cell_show_prop_info_terminal = {
            _name = "prop_icon_cell_show_prop_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
					app.load("client.packs.equipment.EquipFragmentInfomation")
					local prop = params._datas._prop
					local FragmentInformation = EquipFragmentInfomation:new()
					FragmentInformation:init(prop)
					fwin:open(FragmentInformation, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 点击武将碎片小图标需要处理的逻辑
		local prop_icon_cell_show_hero_info_terminal = {
            _name = "prop_icon_cell_show_hero_info",
            _init = function (terminal) 
                app.load("client.packs.hero.HeroPatchInformation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = HeroPatchInformation:new()
				if params._datas._types == 2 then
					cell:init(params._datas._prop,nil,nil,2)
				else
					cell:init(params._datas._prop)
				end
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--道具头像按钮的点击
		local prop_head_manager_terminal = {
            _name = "prop_head_manager",
            _init = function (terminal) 
                app.load("client.cells.prop.prop_information")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = propInformation:new()
				cell:init(params._datas._prop,1)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--获得途径
		local prop_icon_cell_change_get_terminal = {
            _name = "prop_icon_cell_change_get",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local ship = params._datas._prop
				local step = params._datas._type
				if step == nil then
					step = 1
				end
				app.load("client.packs.hero.HeroPatchInformationPageGetWay")
				local cell = HeroPatchInformationPageGetWay:createCell()
				cell:init(ship,step)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
				--道具头像按钮的点击
		local prop_head_for_capture_terminal = {
            _name = "prop_head_for_capture",
            _init = function (terminal) 
                app.load("client.cells.prop.prop_information")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = propInformation:new()
				cell:init(cell:constructionPropTemplate(params._datas._prop),1)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --道具头像按钮的点击
		local prop_small_head_prop_manager_terminal = {
            _name = "prop_small_head_prop_manager",
            _init = function (terminal) 
                app.load("client.cells.prop.prop_information")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local cell = propInformation:new()
				cell:init(params._datas._prop,1)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 觉醒道具合成、获取
		local prop_small_icon_cell_awaken_compose_terminal = {
            _name = "prop_small_icon_cell_awaken_compose",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local propId = params._datas.cell.prop.user_prop_template
            	state_machine.excute("hero_awaken_equip_compose_select_equip", 0,propId )
            	 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 觉醒道具浏览弹出装备信息
		local prop_small_icon_cell_awaken_browse_terminal = {
            _name = "prop_small_icon_cell_awaken_browse",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            app.load("client.packs.hero.HeroAwakenEquipInfo")
            	local propId = params._datas.cell.prop
				local cell = HeroAwakenEquipInfo:new()
				cell:init(propId,3)
				fwin:open(cell, fwin._dialog)
            	 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(prop_head_manager_terminal)
		state_machine.add(prop_icon_cell_show_prop_info_terminal)	
		state_machine.add(prop_icon_cell_show_hero_info_terminal)	
		state_machine.add(prop_icon_cell_change_get_terminal)	
		state_machine.add(prop_head_for_capture_terminal)
		state_machine.add(prop_small_head_prop_manager_terminal)
		state_machine.add(prop_small_icon_cell_awaken_compose_terminal)
		state_machine.add(prop_small_icon_cell_awaken_browse_terminal)
        state_machine.init()
	end
	init_prop_icon_cell_terminal()
end

function PropIconCell:hideNameAndCount(isHide)
	--local root = self.roots[1]
	--ccui.Helper:seekWidgetByName(root, "Label_name"):setVisible(false)
	--ccui.Helper:seekWidgetByName(root, "Label_l-order_level"):setVisible(false)

	if isHide == nil then
		self.isHideNameAndCount = true
	else
		self.isHideNameAndCount = isHide
	end
end

function PropIconCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.size = root:getContentSize()
	
	self:setContentSize(self.size)
	if Image_2 ~= nil then
		Image_2:setSwallowTouches(false)
	end
	
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	if Panel_kuang ~= nil then
		Panel_kuang:removeAllChildren(true)
	end
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	if Panel_ditu ~= nil then
		Panel_ditu:removeAllChildren(true)
	end
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	if Panel_prop ~= nil then
		Panel_prop:removeAllChildren(true)
	end
	local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")--装备等级底框
	local item_name = ccui.Helper:seekWidgetByName(root, "Label_name")--名称
	local item_shuxin = ccui.Helper:seekWidgetByName(root, "Label_shuxin")--属性
	local item_lv = ccui.Helper:seekWidgetByName(root, "Text_1")--右上角等级
	local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级

	if self.isHideNameAndCount == true then
		if item_name ~= nil then
			item_name:setVisible(false)
		end
		if item_order_level ~= nil then
			item_order_level:setVisible(false)
		end
	else
		if item_name ~= nil then
			item_name:setVisible(true)
		end
		if item_order_level ~= nil then
			item_order_level:setVisible(true)
		end
	end	

	if Panel_prop ~= nil then
		Panel_prop:setSwallowTouches(false)
	end
	
	-- images/ui/quality
	
	local picIndex = 0
	local quality = 0
	
	item_element={
		"prop_mould",
		"equipment_mould",
		"ship_mould",
	}
	
	local item_index = nil--物品图标索引
	local item_qulityindex = nil--物品品质索引
	local item_nameIndex = nil--物品名称索引
	local item_mouldid = nil--物品模板id
	local item_count = nil --物品数量

	item_index = prop_mould.pic_index
	item_qulityindex = prop_mould.prop_quality
	item_nameIndex = prop_mould.prop_name
	--print("-----------------",self.current_type)
	if self.enum_type._CARD_INFO == self.current_type then
		item_mouldid = self.prop.fight_rewar_icon
		item_count = self.prop.fight_reward_count
	elseif self.current_type == self.enum_type._VALUE_IS_MOULD 
		or self.current_type == self.enum_type._BATTLE_INFO 
		or self.current_type == self.enum_type._GET_WAY 
		or self.current_type == self.enum_type._DOUBLE_DISCOUNT 
		or self.current_type == self.enum_type._AWAKEN_PROP_BROWSE
		then
		item_mouldid	= self.prop
		item_count 		= 0
	elseif self.current_type == self.enum_type._VALUE_IS_MOULD_AND_REWORLD or 
			self.current_type == self.enum_type._VIP_SHOW or 
			self.current_type == self.enum_type._MOPPING_RESULT or 
			self.current_type == self.enum_type._SPECIAL_PASS or
			self.current_type == self.enum_type._CATURE_REWARD then
		item_mouldid	= self.prop
		item_count 		= self.num
	elseif self.current_type == self.enum_type._AWAKEN_SHOP then
		--觉醒商店
		item_mouldid = self.prop.goods_id
		item_count = self.prop.sell_count
	else
		item_mouldid = self.prop.user_prop_template
		item_count = self.prop.prop_number
	end
	 
	if self.current_type == self.enum_type._SHOW_PROP_INFORMATION or 
	  self.current_type == self.enum_type._SHOW_PROP_INFORMATION_NOT_CHOOSE then
		item_mouldid= self.prop.mould_id
		item_count = 0
	end
	
	if self.enum_type._SHOW_ONLY_ICON_NOT == self.current_type then
		item_mouldid = self.prop.goods_id
		item_count = self.prop.sell_count
	end
	
	if self.enum_type._VALUE_IS_MOULD_HONOR_SHOP == self.current_type or
		self.enum_type._VALUE_IS_MOULD_HONOR_SHOP_SHIP == self.current_type or
		self.enum_type._VALUE_IS_MOULD_HONOR_SHOP_equip == self.current_type then
		item_mouldid = self.prop.user_prop_template
		item_count = self.prop.prop_number
	end
	
	if self.enum_type._SHOW_MINE_REWARD_INFORMATION == self.current_type then
		item_mouldid = self.prop
		item_count = self.num
	end
	
	if self.enum_type._VIP_SHOP == self.current_type then
		item_mouldid = self.prop
		item_count = self.num
	end
	if self.enum_type._UNION_CLEAR_REWARD == self.current_type then
		item_mouldid = self.prop
		item_count = self.num
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if self.enum_type._DAILY_BOX == self.current_type then
			item_mouldid = self.prop
			item_count = self.num
		end

		if self.enum_type._WORLD_BOSS_REWARD == self.current_type then
			item_mouldid = self.prop
			item_count = self.num
			item_vip = self.isShowName
		end
	end
	if self.enum_type.GAIN_REWARD_CELL_ICON == self.current_type then
		item_mouldid = self.prop
		item_count = self.num
		item_vip = self.isShowName
	end
	
	if self.enum_type.GAIN_REWARD_SEVEN_DAY == self.current_type then
		item_mouldid = self.prop
		item_count = self.num
	end
	
	if self.current_type == self.enum_type._SHOW_PROP_GETWAY_INFORMATION_PROP then
		item_mouldid = self.prop
		item_count = self.num
	end
	if self.enum_type._VALUE_IS_MOULD_HONOR_SHOP_SHIP == self.current_type then
		--道具模板中没有,就检查战船模板
		picIndex = dms.int(dms["ship_mould"], item_mouldid, ship_mould.head_icon)
		--tonumber(dms.string(dms["ship_mould"], item_mouldid, ship_mould.head_icon))
		quality = tonumber(dms.string(dms["ship_mould"], item_mouldid, ship_mould.ship_type))+1
		
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			if Panel_ditu ~= nil then
				Panel_ditu:setVisible(true)
				Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
			end
		else
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_0.png", quality))
		end
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		end
		
		--检查是否为碎片
		-- local prop_type = dms.int(dms["prop_mould"], item_mouldid, prop_mould.prop_type)
		-- if prop_type == 1 then
			-- ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
		-- end
	else
		--192号协议不会返回道具id,所以进来之后凡涉及道具id的全部要处理--------------------------
		--> print("00000000000item_mouldid",item_mouldid)
		if self.enum_type._CARD_INFO == self.current_type then
			picIndex = tonumber(self.prop.fight_rewar_icon)
			quality = tonumber(self.prop.fight_reward_quality)+1
			local cc192_mouldId = tonumber(self.prop.fight_reward_mould_id)  
			
			--检查是否为碎片
			local prop_type = getIsPropDebris(cc192_mouldId)
			--dms.int(dms["prop_mould"], cc192_mouldId, prop_mould.prop_type)
			if prop_type == true then
				if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
					ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
				end
			end
			
			if Panel_num ~= nil then
				Panel_num:setVisible(true)
			end
			if item_order_level ~= nil then
				item_order_level:setString("x"..self.prop.fight_reward_count)
			end
			if item_name ~= nil then
				item_name:setString(self.prop.fight_reward_name)
				if quality > 0 then
					item_name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
				end
			end
		elseif self.enum_type._VALUE_IS_MOULD_HONOR_SHOP_equip == self.current_type then
			picIndex = tonumber(dms.string(dms["equipment_mould"], item_mouldid, equipment_mould.pic_index))
			quality = tonumber(dms.string(dms["equipment_mould"], item_mouldid, equipment_mould.grow_level))+1
		else
			picIndex = tonumber(dms.string(dms["prop_mould"], item_mouldid, item_index))
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				picIndex = setThePropsIcon(item_mouldid)[1]
			end
			quality = tonumber(dms.string(dms["prop_mould"], item_mouldid, prop_mould.prop_quality))+1
			if Panel_prop ~= nil then
				local sell_tag = dms.int(dms["prop_mould"], item_mouldid, prop_mould.sell_tag)
				if sell_tag == 3 then
					local effect_paths = string.format(config_res.images.ui.effice.effect_quality_box, 1, 1)
					if cc.FileUtils:getInstance():isFileExist(effect_paths) == true then
						ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
						local armature = ccs.Armature:create("effect_quality_box_1")
						draw.initArmature(armature, nil, -1, 0, 1)
						armature:setPosition(cc.p(Panel_prop:getContentSize().width/2, Panel_prop:getContentSize().height/2))
						Panel_prop:addChild(armature)
					end
				end
			end
		end
		if Panel_prop ~= nil then
			Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			if Panel_ditu ~= nil then
				Panel_ditu:setVisible(true)
				Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
			end
		else
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
			Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_0.png", quality))
		end
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
	end
	
	if self.enum_type._CARD_INFO == self.current_type then
	elseif self.current_type == self.enum_type._SHOW_ONLY_ICON or
		self.enum_type._VALUE_IS_MOULD_HONOR_SHOP_SHIP == self.current_type or 
		self.enum_type._VALUE_IS_MOULD_HONOR_SHOP_equip == self.current_type then
	else
		if self.enum_type._VALUE_IS_MOULD_HONOR_SHOP ~= self.current_type then
			if item_name ~= nil then
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					item_name:setString(setThePropsIcon(item_mouldid)[2])
				else
					item_name:setString(dms.string(dms["prop_mould"], item_mouldid, item_nameIndex))
				end
				item_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
			end
		end
	end
	if Panel_num ~= nil then
		Panel_num:setBackGroundImage(string.format("images/ui/quality/level_%d.png", quality))
	end
	if self.current_type == self.enum_type._SHOW_ONLY_ICON_NOT then
		local proptypeString = tonumber(dms.string(dms["prop_mould"], item_mouldid, prop_mould.prop_type))
		if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
			if dms.int(dms["prop_mould"], item_mouldid, prop_mould.change_of_equipment) ~= 0 and getIsPropDebris(item_mouldid) == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			elseif dms.int(dms["prop_mould"], item_mouldid,  prop_mould.use_of_ship) ~= 0 and getIsPropDebris(item_mouldid) == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			end
		end
		if item_order_level ~= nil then
			item_order_level:setString("x"..item_count)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		
		self.prop.user_prop_template = self.prop.goods_id
		self.prop.prop_number = self.prop.sell_count
		if proptypeString == 4 then
			fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "prop_head_manager", 
				terminal_state = 0, 
				_prop = self.prop
			},
			nil,0)
		else
			fwin:addTouchEventListener(Panel_prop, nil,
			{
				terminal_name = "prop_icon_cell_show_hero_info", 
				terminal_state = 0, 
				_prop = self.prop
			}, 
			nil, 0)
		end
	end
	if self.current_type == self.enum_type._SHOW_PROP_GETWAY_INFORMATION_PROP then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		--道具头像的点击显示详细信息
		fwin:addTouchEventListener(Panel_prop, nil, 
		{
			terminal_name = "prop_head_manager", 
			terminal_state = 0, 
			_prop = self.prop
		}, 
		nil, 0)
	end
	if self.current_type == self.enum_type._SHOW_EQUIP_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
	end
	
	if self.current_type == self.enum_type._SHOW_EQUIPMENT_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
	end
	if self.current_type == self.enum_type._SHOW_PROP_INFORMATION_NOT_CHOOSE then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
	end
	if self.current_type == self.enum_type._SHOW_ONLY_ICON_NOT_CHOOSE then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
	end	
	if self.current_type == self.enum_type._VALUE_IS_MOULD_HONOR_SHOP or
		self.enum_type._VALUE_IS_MOULD_HONOR_SHOP_SHIP == self.current_type then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_order_level ~= nil then
			item_order_level:setString(_string_piece_info[152] .. self.prop.prop_number)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		
		-- Panel_num:setVisible(false)
		if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
			local prop_type = getIsPropDebris(item_mouldid)
			--dms.int(dms["prop_mould"], item_mouldid, prop_mould.prop_type)
			if prop_type == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			end
		end
	end	
	if self.current_type == self.enum_type._VALUE_IS_MOULD then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
	elseif self.current_type == self.enum_type._BATTLE_INFO then
		local proptypeString = tonumber(dms.string(dms["prop_mould"], item_mouldid, prop_mould.prop_type))
		if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
			if dms.int(dms["prop_mould"], item_mouldid, prop_mould.change_of_equipment) ~= 0 and getIsPropDebris(item_mouldid) == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			elseif dms.int(dms["prop_mould"], item_mouldid,  prop_mould.use_of_ship) ~= 0 and getIsPropDebris(item_mouldid) == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			end
		end
		if item_name ~= nil then
			item_name:setString("")
		end
	elseif self.current_type == self.enum_type._VALUE_IS_MOULD_AND_REWORLD then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_order_level ~= nil then
			if item_count ~= nil and tonumber(item_count) > 0 then
				item_order_level:setString("X" .. item_count)
			end
		end
		if item_name ~= nil then
			item_name:setString("")
		end
	end
	if self.current_type == self.enum_type._SHOW_HERO_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		fwin:addTouchEventListener(Panel_prop, nil,
		{
			terminal_name = "prop_icon_cell_show_hero_info", 
			terminal_state = 0, 
			_prop = self.prop
		}, 
		nil, 0)
	end
	if self.current_type == self.enum_type._SHOW_EQUIPMENT_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
		else
			item_name:setString("")
		end
		fwin:addTouchEventListener(Panel_prop, nil, 
		{
			terminal_name = "prop_icon_cell_show_prop_info", 
			terminal_state = 0, 
			_prop = self.prop
		},
		nil,0)
	end
	if self.current_type == self.enum_type._SHOW_REWARD_INFORMATION then
		if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
			if dms.int(dms["prop_mould"], item_mouldid, prop_mould.change_of_equipment) ~= 0 and getIsPropDebris(item_mouldid) == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			elseif dms.int(dms["prop_mould"], item_mouldid,  prop_mould.use_of_ship) ~= 0 and getIsPropDebris(item_mouldid) == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			end
		end
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_order_level ~= nil then
			item_order_level:setString("x"..item_count)
		end
	end
	
	if self.current_type == self.enum_type._DUPLICATE 
		or self.current_type == self.enum_type._BOX_OPEN_CHOOSE
		then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_order_level ~= nil and item_count > 0 then
			item_order_level:setString("x"..item_count)
		end

		local footerData = dms.string(dms["prop_mould"], item_mouldid, prop_mould.trace_remarks)
        local footerInfo = zstring.split(footerData, ",")
        --碎片标识
        local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon")
        Panel_props_left_icon:removeAllChildren(true)
        if footerInfo[1] ~= nil and tonumber(footerInfo[1])~= -1 then
            local props_left_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[1])))
            if props_left_icon ~= nil then
                props_left_icon:setPosition(cc.p(Panel_props_left_icon:getContentSize().width/2,Panel_props_left_icon:getContentSize().height/2))
                Panel_props_left_icon:addChild(props_left_icon)
            end
        end
        --升级材料标识
        local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_right_icon")
        Panel_props_right_icon:removeAllChildren(true)
        if footerInfo[2] ~= nil and tonumber(footerInfo[2]) ~= -1 then
            local props_left_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[2])))
            if props_left_icon ~= nil then
                props_left_icon:setPosition(cc.p(Panel_props_right_icon:getContentSize().width/2, Panel_props_right_icon:getContentSize().height/2))
                Panel_props_right_icon:addChild(props_left_icon)
            end
		end
		
		-- pmc武将碎片图标显示ssr
		if true then
			local storage_page_index = dms.int(dms["prop_mould"], item_mouldid, prop_mould.storage_page_index)
			local shipMouldId = dms.int(dms["prop_mould"], item_mouldid, prop_mould.use_of_ship)

			if storage_page_index == 18 and shipMouldId > 0 then
				local ability = dms.int(dms["ship_mould"], shipMouldId, ship_mould.ability)
				local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
				ssrIcon:setVisible(true)
				ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
			end
		end

		if __lua_project_id == __lua_project_l_digital then 
			-- 武将限定卡SP标签
			local storage_page_index = dms.int(dms["prop_mould"], item_mouldid, prop_mould.storage_page_index)
			local shipMouldId = dms.int(dms["prop_mould"], item_mouldid, prop_mould.use_of_ship)
			local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
			DisplaySpCardTag(shipMouldId, spIcon)
		else
			-- 武将限定卡显示
			local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
			if Panel_xianding  then 
				Panel_xianding:setVisible(false)
				Panel_xianding:removeAllChildren(true)
				local storage_page_index = dms.int(dms["prop_mould"], item_mouldid, prop_mould.storage_page_index)
				local shipMouldId = dms.int(dms["prop_mould"], item_mouldid, prop_mould.use_of_ship)

				if storage_page_index == 18 and shipMouldId > 0 then
					DisplayLimitCard(tonumber(shipMouldId) , Panel_xianding ,1)
				else
					-- 限定神兽标签
					DisplayLimitAnimal(nil, item_mouldid, Panel_xianding, 1)
				end
			end
		end

        if self.current_type == self.enum_type._BOX_OPEN_CHOOSE then
        	fwin:addTouchEventListener(Panel_prop, nil, 
				{
					terminal_name = "sm_prop_choose_update_draw", 
					terminal_state = 0, 
					cell = self
				},
				nil,0)
        else
			if dms.int(dms["prop_mould"], item_mouldid, prop_mould.change_of_equipment) ~= 0 and getIsPropDebris(item_mouldid) == true then
				if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
					ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
				end
				fwin:addTouchEventListener(Panel_prop, nil, 
				{
					terminal_name = "prop_icon_cell_show_prop_info", 
					terminal_state = 0, 
					_prop = self.prop
				},
				nil,0)
			elseif dms.int(dms["prop_mould"], item_mouldid,  prop_mould.use_of_ship) ~= 0 and getIsPropDebris(item_mouldid) == true then
				if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
					ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
				end
				fwin:addTouchEventListener(Panel_prop, nil,
				{
					terminal_name = "prop_icon_cell_show_hero_info", 
					terminal_state = 0, 
					_prop = self.prop
				}, 
				nil, 0)
			else
				fwin:addTouchEventListener(Panel_prop, nil, 
				{
					terminal_name = "prop_head_manager", 
					terminal_state = 0, 
					_prop = self.prop
				}, 
				nil, 0)
			end
		end
	end
	
	if self.current_type == self.enum_type._VIP_SHOW then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if item_order_level ~= nil then
			item_order_level:setString("x"..item_count)
		end
		if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
			if dms.int(dms["prop_mould"], item_mouldid, prop_mould.change_of_equipment) ~= 0 and getIsPropDebris(item_mouldid) == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			elseif dms.int(dms["prop_mould"], item_mouldid,  prop_mould.use_of_ship) ~= 0 and getIsPropDebris(item_mouldid) == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			end
		end
	end
	
	if self.current_type == self.enum_type.GAIN_REWARD_SEVEN_DAY then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_order_level ~= nil then
			item_order_level:setString("x"..item_count)
		end
		
		if dms.int(dms["prop_mould"], item_mouldid, prop_mould.change_of_equipment) ~= 0 and getIsPropDebris(item_mouldid) == true then
			if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			end
			fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "prop_icon_cell_show_prop_info", 
				terminal_state = 0, 
				_prop = self.prop,
			},
			nil,0)
		elseif dms.int(dms["prop_mould"], item_mouldid,  prop_mould.use_of_ship) ~= 0 and getIsPropDebris(item_mouldid) == true then
			if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			end
			local shipId = dms.int(dms["prop_mould"], self.prop, prop_mould.use_of_ship)
			fwin:addTouchEventListener(Panel_prop, nil,
			{
				terminal_name = "prop_icon_cell_show_hero_info", 
				terminal_state = 0, 
				_prop = shipId,
				_types = 2,
			}, 
			nil, 0)
		else
			fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "prop_head_manager", 
				terminal_state = 0, 
				_prop = self.prop
			}, 
			nil, 0)
		end
	end
	
	if self.current_type == self.enum_type._VIP_SHOP then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			if item_name ~= nil then
				item_name:setString("")
			end
		end
		if item_order_level ~= nil then
			item_order_level:setString("x"..item_count)
		end
		fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "prop_head_manager", 
				terminal_state = 0, 
				_prop = self.prop
			},
			nil,0)
		if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
			if dms.int(dms["prop_mould"], item_mouldid, prop_mould.change_of_equipment) ~= 0 and getIsPropDebris(item_mouldid) == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			elseif dms.int(dms["prop_mould"], item_mouldid,  prop_mould.use_of_ship) ~= 0 and getIsPropDebris(item_mouldid) == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			end
		end
	end
	if self.current_type == self.enum_type._UNION_CLEAR_REWARD then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if item_order_level ~= nil then
			item_order_level:setString("x"..item_count)
		end
		fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "prop_head_manager", 
				terminal_state = 0, 
				_prop = self.prop
			},
			nil,0)
		if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
			if dms.int(dms["prop_mould"], item_mouldid, prop_mould.change_of_equipment) ~= 0 and getIsPropDebris(item_mouldid) == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			elseif dms.int(dms["prop_mould"], item_mouldid,  prop_mould.use_of_ship) ~= 0 and getIsPropDebris(item_mouldid) == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			end
		end
	end
	if self.current_type == self.enum_type._AWAKEN_SHOP then 
		if item_name ~= nil then
			item_name:setString("")
		end
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_order_level ~= nil then
			item_order_level:setString("x"..item_count)
		end
		local propInfo = {user_prop_template = item_mouldid}
		fwin:addTouchEventListener(Panel_prop, nil, 
		{
			terminal_name = "prop_small_head_prop_manager", 
			terminal_state = 0, 
			_prop = propInfo
		},
		nil,0)
	elseif self.current_type == self.enum_type._AWAKEN_PROP_BROWSE then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, 
		{
			terminal_name = "prop_small_icon_cell_awaken_browse", 
			terminal_state = 0, 
			cell = self
		}, nil, 0)
	elseif self.current_type == self.enum_type._EQUIP_AWAKEN_COMPOSE then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_lv ~= nil then
			item_lv:setString("")
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if item_order_level ~= nil then
			local propNum = zstring.tonumber(getPropAllCountByMouldId(item_mouldid))
			if propNum < zstring.tonumber(item_count) then 
				item_order_level:setColor(cc.c3b(255,0,0))
			else
				item_order_level:setColor(cc.c3b(255,255,255))
			end
			item_order_level:setVisible(true)
			item_order_level:setString(propNum .. "/"..item_count)
		end
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, 
		{
			terminal_name = "prop_small_icon_cell_awaken_compose", 
			terminal_state = 0, 
			cell = self
		}, nil, 0)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if self.enum_type._DAILY_BOX == self.current_type then
			if Panel_num ~= nil then
				Panel_num:setVisible(false)
			end
			-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			-- 	item_name:setString("")
			-- end
			if item_order_level ~= nil then
				item_order_level:setString("x"..item_count)
			end
			fwin:addTouchEventListener(Panel_prop, nil, 
				{
					terminal_name = "prop_head_manager", 
					terminal_state = 0, 
					_prop = self.prop
				},
				nil,0)
			if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
				if dms.int(dms["prop_mould"], item_mouldid, prop_mould.change_of_equipment) ~= 0 and getIsPropDebris(item_mouldid) == true then
					ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
				elseif dms.int(dms["prop_mould"], item_mouldid,  prop_mould.use_of_ship) ~= 0 and getIsPropDebris(item_mouldid) == true then
					ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
				end
			end
		end

		if self.enum_type._WORLD_BOSS_REWARD == self.current_type then
			if Panel_num ~= nil then
				Panel_num:setVisible(false)
			end
			if item_order_level ~= nil then
				item_order_level:setString("x"..item_count)
			end
			if item_name ~= nil then
				item_name:setString("")
			end
			if item_vip ~= nil then
				local vip_double = ccui.Helper:seekWidgetByName(root, "Panel_4")--左上角VIP双倍
				if vip_double ~= nil then
					vip_double:setVisible(true)
					vip_double:setBackGroundImage(string.format("images/ui/vip/mrqd_shuangbei_v%d.png",item_vip))
				end
			end
			local proptypeString = tonumber(dms.string(dms["prop_mould"], item_mouldid, prop_mould.prop_type))
			if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
				if dms.int(dms["prop_mould"], item_mouldid, prop_mould.change_of_equipment) ~= 0 and getIsPropDebris(item_mouldid) == true then
					ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
				elseif dms.int(dms["prop_mould"], item_mouldid,  prop_mould.use_of_ship) ~= 0 and getIsPropDebris(item_mouldid) == true then
					ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
				end
			end
			if proptypeString == 1 then
				fwin:addTouchEventListener(Panel_prop, nil, 
				{
					terminal_name = "prop_icon_cell_show_prop_info", 
					terminal_state = 0, 
					_prop = self.prop
				},
				nil,0)
			else
				fwin:addTouchEventListener(Panel_prop, nil, 
				{
					terminal_name = "prop_head_manager", 
					terminal_state = 0, 
					_prop = self.prop
				},
				nil,0)
			end
		end

	end
	
	
	if self.enum_type.GAIN_REWARD_CELL_ICON == self.current_type then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_order_level ~= nil then
			item_order_level:setString("x"..item_count)
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
		else
			item_name:setString("")
		end
		if item_vip ~= nil then
			local vip_double = ccui.Helper:seekWidgetByName(root, "Panel_4")--左上角VIP双倍
			if vip_double ~= nil then
				vip_double:setVisible(true)
				vip_double:setBackGroundImage(string.format("images/ui/vip/mrqd_shuangbei_v%d.png",item_vip))
			end
		end
		local proptypeString = tonumber(dms.string(dms["prop_mould"], item_mouldid, prop_mould.prop_type))
		if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
			if dms.int(dms["prop_mould"], item_mouldid, prop_mould.change_of_equipment) ~= 0 and getIsPropDebris(item_mouldid) == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			elseif dms.int(dms["prop_mould"], item_mouldid,  prop_mould.use_of_ship) ~= 0 and getIsPropDebris(item_mouldid) == true then
				ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
			end
		end
		if proptypeString == 1 then
			fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "prop_icon_cell_show_prop_info", 
				terminal_state = 0, 
				_prop = self.prop
			},
			nil,0)
		else
			fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "prop_head_manager", 
				terminal_state = 0, 
				_prop = self.prop
			},
			nil,0)
		end
	end
	if self.current_type == self.enum_type._SHOW_REWARD_POINT_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_order_level ~= nil then
			item_order_level:setString("x"..item_count)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
	end
	
	if self.current_type == self.enum_type._GET_WAY then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_order_level ~= nil then
			item_order_level:setString("")
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		fwin:addTouchEventListener(Panel_prop, nil, 
		{
			terminal_name = "prop_icon_cell_change_get", 
			terminal_state = 0, 
			_prop = self.prop,
			_type = self.types
		},
		nil,0)
	end
	
	if self.current_type == self.enum_type._SHOW_MINE_REWARD_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_order_level ~= nil then
			item_order_level:setString("x"..item_count)
		end
		-- fwin:addTouchEventListener(Panel_prop, nil, 
		-- {
			-- terminal_name = "prop_head_manager", 
			-- terminal_state = 0, 
			-- _prop = self.prop
		-- },
		-- nil,0)
	end
	
	if self.current_type == self.enum_type._SHOW_PROP_GETWAY_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
	end
	if self.current_type == self.enum_type._SHOW_PROP_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		fwin:addTouchEventListener(Panel_prop, nil, 
		{
			terminal_name = "prop_head_manager", 
			terminal_state = 0, 
			_prop = self.prop
		},
		nil,0)
	end
	
	if self.current_type == self.enum_type._SPECIAL_PASS then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		-- item_name:setString("")
		fwin:addTouchEventListener(Panel_prop, nil, 
		{
			terminal_name = "prop_head_manager", 
			terminal_state = 0, 
			_prop = self.prop
		},
		nil,0)
	end

	if self.current_type == self.enum_type._CATURE_REWARD then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_order_level ~= nil then
			if item_count ~= nil and tonumber(item_count) > 0 then
				item_order_level:setString("X" .. item_count)
			end
		end
		-- local name = dms.string(dms["prop_mould"], item_mouldid, prop_mould.prop_name)
		-- item_name:setString(name)
		if item_name ~= nil then
			item_name:setString("")
		end
		fwin:addTouchEventListener(Panel_prop, nil, 
		{
			terminal_name = "prop_head_for_capture", 
			terminal_state = 0, 
			_prop = self.prop
		},
		nil,0)
	end
	if item_name ~= nil then
		if self.isShowName == false then
			item_name:setVisible(false)
		end
	end
	
	if self.current_type == self.enum_type._MOPPING_RESULT then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_order_level ~= nil then
			if item_count ~= nil and tonumber(item_count) > 0 then
				item_order_level:setString("X" .. item_count)
			end
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				item_order_level:setVisible(true)
			end
		end
		if item_name ~= nil then
			local name = dms.string(dms["prop_mould"], item_mouldid, prop_mould.prop_name)
			item_name:setString(name)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				item_name:setVisible(false)
			else
				item_name:setVisible(true)
			end
		end

		local footerData = dms.string(dms["prop_mould"], item_mouldid, prop_mould.trace_remarks)
        local footerInfo = zstring.split(footerData, ",")
        --碎片标识
        local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon")
        Panel_props_left_icon:removeAllChildren(true)
        if footerInfo[1] ~= nil and tonumber(footerInfo[1])~= -1 then
            local props_left_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[1])))
            if props_left_icon ~= nil then
                props_left_icon:setPosition(cc.p(Panel_props_left_icon:getContentSize().width/2,Panel_props_left_icon:getContentSize().height/2))
                Panel_props_left_icon:addChild(props_left_icon)
            end
        end

        --升级材料标识
        local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_right_icon")
        Panel_props_right_icon:removeAllChildren(true)
        if footerInfo[2] ~= nil and tonumber(footerInfo[2]) ~= -1 then
            local props_left_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[2])))
            if props_left_icon ~= nil then
                props_left_icon:setPosition(cc.p(Panel_props_right_icon:getContentSize().width/2, Panel_props_right_icon:getContentSize().height/2))
                Panel_props_right_icon:addChild(props_left_icon)
            end
        end
        
		if ccui.Helper:seekWidgetByName(root, "Image_26") ~= nil then
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_legendary_game 
				then
				local proptypeString = tonumber(dms.string(dms["prop_mould"], item_mouldid, prop_mould.prop_type))
				if dms.int(dms["prop_mould"], item_mouldid, prop_mould.change_of_equipment) ~= 0 and getIsPropDebris(item_mouldid) == true then
					ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
				elseif dms.int(dms["prop_mould"], item_mouldid,  prop_mould.use_of_ship) ~= 0 and getIsPropDebris(item_mouldid) == true then
					ccui.Helper:seekWidgetByName(root, "Image_26"):setVisible(true)
				end
			end
		end
		fwin:removeTouchEventListener(Panel_prop)
	end
	
	if self.current_type == self.enum_type._DOUBLE_DISCOUNT then
		if ccui.Helper:seekWidgetByName(root, "Image_nub2") ~= nil then
			ccui.Helper:seekWidgetByName(root, "Image_nub2"):setVisible(true)
		end
	end
end

function PropIconCell:onEnterTransitionFinish()
	
end

function PropIconCell:onInit( ... )
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		root = cacher.createUIRef("icon/item.csb", "root")
	else
		local csbItem = csb.createNode("icon/item.csb")
		root = csbItem:getChildByName("root")
	end
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
	    if root._x == nil then
	    	root._x = 0
	    	root:setPositionX(root._x)
	    end

	    if root._y == nil then
	    	root._y = 0
	    	root:setPositionY(root._y)
	    end
	end

	self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end

	self.panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	
	self:onUpdateDraw()
	
	if self.current_type == self.enum_type._VALUE_IS_MOULD_AND_REWORLD then
	end
end

function PropIconCell:setChooseSelectState( isChoose )
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
	if Image_xuanzhong ~= nil then
    	Image_xuanzhong:setVisible(isChoose)
    end
end

function PropIconCell:setActivityDouble( isShow )
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
	if Image_double ~= nil then
    	Image_double:setVisible(isShow)
    end
end

function PropIconCell:clearUIInfo( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
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
		local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
		if ssrIcon ~= nil then
			ssrIcon:setVisible(false)
		end
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
	    	Panel_ditu:setVisible(true)
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
end

function PropIconCell:onExit()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
	    self:clearUIInfo()
	    cacher.freeRef("icon/item.csb", root)
	end
end

function PropIconCell:init(interfaceType, prop, num, isShowName,types)
	self.current_type = interfaceType
	self.prop = prop
	if num ~= nil then
		self.num = num
	end
	if isShowName ~= nil then
		self.isShowName = isShowName
	end
	if types ~= nil then
		self.types = types		--控制跳转途径
	end
	self:onInit()
end

function PropIconCell:createCell()
	local cell = PropIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

