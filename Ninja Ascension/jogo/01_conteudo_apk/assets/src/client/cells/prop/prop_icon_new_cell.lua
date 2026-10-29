----------------------------------------------------------------------------------------------------
-- 说明：道具的小图标绘制
-------------------------------------------------------------------------------------------------------
PropIconNewCell = class("PropIconNewCellClass", Window)

function PropIconNewCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.useSmall = nil -- 舰娘觉醒使用小底图
	self.enum_type = {
		_SHOW_EQUIPMENT_INFORMATION = 1,					-- 查看装备信息
		_COPY_PAGE_DROP_REWARD_INFORMATION = 2,					-- 
		_SHOW_HERO_INFORMATION = 3,					-- 查看武将碎片信息
		_SHOW_EQUIP_INFORMATION = 4,					-- 查看装备碎片信息
		_SHOW_REWARD_INFORMATION = 5,		-- 显示名字和数量 （底部和右下角）
		_SHOW_REWARD_POINT_INFORMATION = 6,	-- 显示数量
		_SHOW_PROP_INFORMATION = 7,			-- 查看道具信息
		_SHOW_RES_INFORMATION = 8, 			-- 查看物品信息
		_SHOW_PROP_GETWAY_INFORMATION = 9,  -- 查看道具获取途径
		_SHOW_PROP_GETWAY_INFORMATION_PROP = 10,  -- 查看道具获取途径
		_SHOW_PROP_INFORMATION_NOT_CHOOSE = 11,  -- 查看道具信息(点击无响应)
		_SHOW_ONLY_ICON = 12,					--不要显示名称
		_SHOW_ONLY_ICON_NOT_CHOOSE = 13,			--不要显示名称
		_SHOW_EQUIP_INFO = 14,			--不要显示名称,不能点击
		_SHOW_VIP_GIFT_INFO = 15,			--	vip	礼包专用
		_SHOW_ARENA_HONOR_SHOP = 16,		-- 竞技场商城
		_EQUIP_AWAKEN_COMPOSE = 17,			--觉醒装备合成 数字用 x/x 标示，道具不足，颜色改成红色
		_AWAKEN_PROP_BROWSE = 18 , 		--- 觉醒道具浏览弹出装备信息
		_AWAKEN_SHOP = 19 , 		--- 觉醒商店展示
		_SHOW_EQUIP_PATCH = 20 ,   -- 只显示装备碎片，无点击
		_SHOW_HERO_PATCH = 21 ,  -- 只显示武将碎片，无点击
		_USE_CONSUMPTION = 22,	--使用道具消耗
		_CUITIVATE_SPIRIT_USE = 23,	--数码精神道具消耗
		_AUTO_UPGRADE = 24,	--一键升级
		_SILK_AUTO_UPGRADE = 25, --锦囊一键升级
	}

	self.began_times = 0
	self.began_times_twi = 0
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_prop_icon_new_cell_terminal()

		-- 点击道具小图标需要处理的逻辑
		local prop_icon_new_cell_show_prop_info_terminal = {
            _name = "prop_icon_new_cell_show_prop_info",
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
					fwin:open(FragmentInformation, fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 点击武将碎片小图标需要处理的逻辑
		local prop_icon_new_cell_show_hero_info_terminal = {
            _name = "prop_icon_new_cell_show_hero_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.packs.hero.HeroPatchInformation")
            	local cell = HeroPatchInformation:new()
				cell:init(params._datas._prop)
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					fwin:open(cell, fwin._windows)
				else
					fwin:open(cell, fwin._view)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--道具头像按钮的点击
		local prop_new_head_manager_terminal = {
            _name = "prop_new_head_manager",
            _init = function (terminal) 
                app.load("client.cells.prop.prop_information")
				app.load("client.shop.ShopVIPPropShow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params) 
				local propInfo = params._datas._prop
				if tonumber(propInfo.prop_use_type) == 2 then
					local cell = ShopVIPPropShow:new()
					cell:init(propInfo,2)
					fwin:open(cell, fwin._taskbar)
				else
					local cell = propInformation:new()
					cell:init(propInfo,1)
					fwin:open(cell, fwin._ui)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--道具头像按钮的点击
		local prop_new_head_prop_manager_terminal = {
            _name = "prop_new_head_prop_manager",
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
		
		--VIP礼包预览
		local prop_head_vip_gift_terminal = {
            _name = "prop_head_vip_gift",
            _init = function (terminal) 
                app.load("client.shop.ShopVIPPropShow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local id = params._datas._prop.mould_id
				local types = dms.int(dms["prop_mould"], id, prop_mould.prop_type)
				if types == 2 then
					local cell = ShopVIPPropShow:new()
					cell:init(params._datas._prop)
					fwin:open(cell, fwin._taskbar)
				else
					local cell = propInformation:new()
					cell:init(params._datas._prop,1)
					fwin:open(cell, fwin._taskbar)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 觉醒道具合成、获取
		local prop_icon_cell_awaken_compose_terminal = {
            _name = "prop_icon_cell_awaken_compose",
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
		local prop_icon_cell_awaken_browse_terminal = {
            _name = "prop_icon_cell_awaken_browse",
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

        -- 道具追踪
		local prop_icon_cell_track_terminal = {
            _name = "prop_icon_cell_track",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
            	local prop = params._datas._prop --道具模板id
            	local page_index = dms.int(dms["prop_mould"], prop, prop_mould.storage_page_index)
				app.load("client.packs.hero.HeroPatchInformationPageGetWay")
				local cell = HeroPatchInformationPageGetWay:createCell()
				if page_index == 18 then
					cell:init(prop,5,params._datas.existNumber,params._datas.totalNumber)
				else
					cell:init(prop,2,params._datas.existNumber,params._datas.totalNumber)
				end
				
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local prop_icon_cell_click_auto_upgrade_terminal = {
            _name = "prop_icon_cell_click_auto_upgrade",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local prop = params._datas._prop
				state_machine.excute("sm_auto_upgrade_update_choose_props", 0, prop)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(prop_new_head_manager_terminal)
		state_machine.add(prop_head_vip_gift_terminal)
		state_machine.add(prop_icon_new_cell_show_prop_info_terminal)	
		state_machine.add(prop_icon_new_cell_show_hero_info_terminal)	
		state_machine.add(prop_new_head_prop_manager_terminal)
		state_machine.add(prop_icon_cell_awaken_compose_terminal)
		state_machine.add(prop_icon_cell_awaken_browse_terminal)
		state_machine.add(prop_icon_cell_track_terminal)
		state_machine.add(prop_icon_cell_click_auto_upgrade_terminal)
		
        state_machine.init()
	end
	init_prop_icon_new_cell_terminal()
end

function PropIconNewCell:updateIconCountInfo( info )
	local root = self.roots[1]
	local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")
	if item_order_level ~= nil then
		item_order_level:setVisible(true)
		item_order_level:setString(info)
	end
end

function PropIconNewCell:updateAutoUpgradeState( isSelected )
	local root = self.roots[1]
	local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
	if Image_xuanzhong ~= nil then
		Image_xuanzhong:setVisible(isSelected)
	end
end

function PropIconNewCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.size = root:getContentSize()
	self:setContentSize(self.size)
	if Image_2 ~= nil then
		Image_2:setSwallowTouches(false)
	end
	
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	local Panel_num = ccui.Helper:seekWidgetByName(root, "Panel_num")--装备等级底框
	local item_name = ccui.Helper:seekWidgetByName(root, "Label_name")--名称
	local item_shuxin = ccui.Helper:seekWidgetByName(root, "Label_shuxin")--属性
	local item_lv = ccui.Helper:seekWidgetByName(root, "Text_1")--右上角等级
	local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级

	local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon")
	local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_right_icon")

	-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
 --        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
 --        then
 --        local spanel = Panel_kuang
 --        Panel_kuang = Panel_prop
 --        Panel_prop = spanel
 --    end
	if ccui.Helper:seekWidgetByName(root, "Image_3") ~= nil then
		ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(false)
	end
	if Panel_prop ~= nil then
		Panel_prop:setSwallowTouches(false)
		Panel_prop:setTouchEnabled(true)
	end
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
	if type(self.prop) ~= "number" then
		item_mouldid= self.prop.user_prop_template
		item_count = self.prop.prop_number
	end
	if self.current_type == self.enum_type._SHOW_ARENA_HONOR_SHOP then
		item_mouldid = self.prop
		item_count = 0
	end
	if self.current_type == self.enum_type._SHOW_PROP_INFORMATION 
		or self.current_type == self.enum_type._SHOW_PROP_INFORMATION_NOT_CHOOSE 
		or self.current_type == self.enum_type._SHOW_VIP_GIFT_INFO then
		item_mouldid= self.prop.mould_id
		item_count = 0
	end
	
	if self.current_type == self.enum_type._SHOW_EQUIP_INFO then
		item_mouldid = self.prop
		if Panel_prop ~= nil then
			Panel_prop:setTouchEnabled(false)
		end
	end
	if self.enum_type._AWAKEN_SHOP  == self.current_type then
		--觉醒商店
		item_mouldid = self.prop.goods_id
		item_count = self.prop.sell_count
	end
	if item_mouldid == nil then
		item_mouldid = self.prop
	end
	picIndex = tonumber(dms.string(dms["prop_mould"], item_mouldid, item_index))
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		picIndex = setThePropsIcon(item_mouldid)[1]
	end
	
	quality = tonumber(dms.string(dms["prop_mould"], item_mouldid, prop_mould.prop_quality))+1
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self.Panel_prop_icon = cc.Sprite:create(getPropsPath(picIndex))
		if self.Panel_prop_icon ~= nil then
			self.Panel_prop_icon:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
			if Panel_prop ~= nil then
				Panel_prop:addChild(self.Panel_prop_icon)
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
			if self.isGrayed ~= nil then
				display:gray(self.Panel_prop_icon)
			else
				display:ungray(self.Panel_prop_icon)
			end
		end
	else
		Panel_prop:setBackGroundImage(getPropsPath(picIndex))
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
				
				DisplayLimitCard(tonumber(shipMouldId)  , Panel_xianding , 1)
			else
				-- 限定神兽标签
				DisplayLimitAnimal(nil, item_mouldid, Panel_xianding, 1)
			end

		end
	end

	local useSmallQuality = true
	if __lua_project_id == __lua_project_warship_girl_b then
		if self.useSmall ~= true then
			useSmallQuality = false
		end
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
		useSmallQuality = false --龙虎门使用bigkuang
	end
	if useSmallQuality == true then
		Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
	else
		
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			self.Panel_kuang_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", quality))
			if self.Panel_kuang_icon ~= nil then
				if Panel_ditu ~= nil then
					Panel_ditu:setVisible(true)
					self.Panel_kuang_icon:setPosition(cc.p(Panel_ditu:getContentSize().width/2,Panel_ditu:getContentSize().height/2))
					Panel_ditu:addChild(self.Panel_kuang_icon)
				end
			end

			local footerData = dms.string(dms["prop_mould"], item_mouldid, prop_mould.trace_remarks)
    		local footerInfo = zstring.split(footerData ,",")

    		if Panel_props_left_icon ~= nil then
    			Panel_props_left_icon:removeAllChildren(true)
    		end
		    if footerInfo[1] ~= nil and tonumber(footerInfo[1])~= -1 then
		        local props_left_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[1])))
		        if props_left_icon ~= nil then
		        	if Panel_props_left_icon ~= nil then
				        props_left_icon:setPosition(cc.p(Panel_props_left_icon:getContentSize().width/2,Panel_props_left_icon:getContentSize().height/2))
				        Panel_props_left_icon:addChild(props_left_icon)
				    end
			        if self.isGrayed ~= nil then
						display:gray(props_left_icon)
					else
						display:ungray(props_left_icon)
					end
				end
		    end
		    if Panel_props_right_icon ~= nil then
		    	Panel_props_right_icon:removeAllChildren(true)
		    end
		    if footerInfo[2] ~= nil and tonumber(footerInfo[2])~= -1 then
		        local props_right_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[2])))
		        if props_right_icon ~= nil then
		        	if Panel_props_right_icon ~= nil then
				        props_right_icon:setPosition(cc.p(Panel_props_right_icon:getContentSize().width/2,Panel_props_right_icon:getContentSize().height/2))
				        Panel_props_right_icon:addChild(props_right_icon)
				    end
			        if self.isGrayed ~= nil then
						display:gray(props_right_icon)
					else
						display:ungray(props_right_icon)
					end
				end
		    end
		    if self.Panel_kuang_icon ~= nil then
				if self.isGrayed ~= nil then
					display:gray(self.Panel_kuang_icon)
				else
					display:ungray(self.Panel_kuang_icon)
				end
			end
		else
			-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			-- 	Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))
			-- else
			-- 	Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))
			-- end
			if Panel_kuang ~= nil then
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
				else
					Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))
				end
			end
		end
		
	end
	-- Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))

	if self.current_type == self.enum_type._SHOW_ONLY_ICON then
	else
		if item_name ~= nil then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				item_name:setString(setThePropsIcon(item_mouldid)[2])
			else
				item_name:setString(dms.string(dms["prop_mould"], item_mouldid, item_nameIndex))
			end
			item_name:setString(dms.string(dms["prop_mould"], item_mouldid, item_nameIndex))
			item_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		end
	end
	if Panel_num ~= nil then
		Panel_num:setBackGroundImage(string.format("images/ui/quality/level_%d.png", quality))
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
			terminal_name = "prop_new_head_manager", 
			terminal_state = 0, 
			_prop = self.prop
		}, 
		nil, 0)
	end

	if self.current_type == self.enum_type._SHOW_PROP_GETWAY_INFORMATION then
		-- if self.isGrayed ~= nil then

			fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "prop_icon_cell_track", 
				terminal_state = 0, 
				_prop = self.prop,
				existNumber = self.existNumber,
				totalNumber = self.totalNumber,
				
			}, 
			nil, 0)
		-- end
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

	if self.current_type == self.enum_type._SHOW_EQUIP_PATCH then
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
	if self.current_type == self.enum_type._SHOW_HERO_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if ccui.Helper:seekWidgetByName(root, "Image_4") ~= nil then
			ccui.Helper:seekWidgetByName(root, "Image_4"):setVisible(true)
		end
		fwin:addTouchEventListener(Panel_prop, nil,
		{
			terminal_name = "prop_icon_new_cell_show_hero_info", 
			terminal_state = 0, 
			_prop = self.prop
		}, 
		nil, 0)
	end

	if self.current_type == self.enum_type._SHOW_HERO_PATCH then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
			then
		else
			ccui.Helper:seekWidgetByName(root, "Image_4"):setVisible(true)
		end
	end
	if self.current_type == self.enum_type._SHOW_EQUIPMENT_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if ccui.Helper:seekWidgetByName(root, "Image_4") ~= nil then
			ccui.Helper:seekWidgetByName(root, "Image_4"):setVisible(true)
		end
		fwin:addTouchEventListener(Panel_prop, nil, 
		{
			terminal_name = "prop_icon_new_cell_show_prop_info", 
			terminal_state = 0, 
			_prop = self.prop
		},
		nil,0)
	end

	if self.current_type == self.enum_type._SHOW_EQUIP_PATCH  then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if ccui.Helper:seekWidgetByName(root, "Image_4") ~= nil then
			ccui.Helper:seekWidgetByName(root, "Image_4"):setVisible(true)
		end
	end
	if self.current_type == self.enum_type._SHOW_REWARD_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_order_level ~= nil then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				item_order_level:setString(item_count)
			else
				item_order_level:setString("x"..item_count)
			end
		end
	end
	if self.current_type == self.enum_type._SHOW_REWARD_POINT_INFORMATION then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_order_level ~= nil then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				item_order_level:setString(item_count)
			else
				item_order_level:setString("x"..item_count)
			end
		end
		if item_name ~= nil then
			item_name:setString("")
		end
	end
	if self.current_type == self.enum_type._SHOW_PROP_GETWAY_INFORMATION or self.current_type == self.enum_type._USE_CONSUMPTION or self.current_type == self.enum_type._CUITIVATE_SPIRIT_USE then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if self.current_type == self.enum_type._USE_CONSUMPTION or self.current_type == self.enum_type._CUITIVATE_SPIRIT_USE then
			if item_order_level ~= nil then
				item_order_level:setVisible(true)
			end
			if item_order_level ~= nil then
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					if fundPropWidthId(self.prop) == nil then
						item_order_level:setString("")
					else
						item_order_level:setString(fundPropWidthId(self.prop).prop_number)
					end
				else
					if fundPropWidthId(self.prop) == nil then
						item_order_level:setString("x0")
					else
						item_order_level:setString("x"..fundPropWidthId(self.prop).prop_number)
					end
				end
			end
		end
	end
	if self.current_type == self.enum_type._AUTO_UPGRADE then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if item_order_level ~= nil then
			item_order_level:setVisible(true)
			item_order_level:setString("")
		end
		if self.isGrayed == true then
		else
			fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "prop_icon_cell_click_auto_upgrade", 
				terminal_state = 0, 
				_prop = self.prop,
			},
			nil,0)
		end
	end

	if self.current_type == self.enum_type._SILK_AUTO_UPGRADE then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		if item_order_level ~= nil then
			item_order_level:setVisible(true)
			item_order_level:setString("")
		end
		if self.isGrayed == true then
		else
			-- fwin:addTouchEventListener(Panel_prop, nil, 
			-- {
			-- 	terminal_name = "silkbag_auto_upgrade_update_choose_props", 
			-- 	terminal_state = 0, 
			-- 	_prop = self.prop,
			-- },
			-- nil,0)
		end
	end
	if self.current_type == self.enum_type._SHOW_PROP_INFORMATION or self.current_type == self.enum_type._SHOW_ARENA_HONOR_SHOP then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		-- if tonumber(item_mouldid) ~=1148 and tonumber(item_mouldid) ~=1149 and tonumber(item_mouldid) ~=1150 then
			-- if dms.int(dms["prop_mould"], item_mouldid, prop_mould.change_of_equipment) ~= 0 then
				-- ccui.Helper:seekWidgetByName(root, "Image_4"):setVisible(true)
			-- elseif dms.int(dms["prop_mould"], item_mouldid,  prop_mould.use_of_ship) ~= 0 then
				-- ccui.Helper:seekWidgetByName(root, "Image_4"):setVisible(true)
			-- end
		-- end
		if self.current_type == self.enum_type._SHOW_PROP_INFORMATION then
			fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "prop_new_head_prop_manager", 
				terminal_state = 0, 
				_prop = self.prop
			},
			nil,0)
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
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				item_order_level:setString(item_count)
			else
				item_order_level:setString("x"..item_count)
			end
		end

		local propInfo = {user_prop_template = item_mouldid}
		fwin:addTouchEventListener(Panel_prop, nil, 
		{
			terminal_name = "prop_new_head_prop_manager", 
			terminal_state = 0, 
			_prop = propInfo
		},
		nil,0)
	end
	if self.current_type == self.enum_type._SHOW_VIP_GIFT_INFO then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
		fwin:addTouchEventListener(Panel_prop, nil, 
		{
			terminal_name = "prop_head_vip_gift", 
			terminal_state = 0, 
			_prop = self.prop
		},
		nil,0)
	end
	
	if self.current_type == self.enum_type._SHOW_EQUIP_INFO then
		if Panel_num ~= nil then
			Panel_num:setVisible(false)
		end
		if item_name ~= nil then
			item_name:setString("")
		end
	end
	if self.current_type == self.enum_type._EQUIP_AWAKEN_COMPOSE then
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
			terminal_name = "prop_icon_cell_awaken_compose", 
			terminal_state = 0, 
			cell = self
		}, nil, 0)
	end

	if self.current_type == self.enum_type._AWAKEN_PROP_BROWSE then
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
			terminal_name = "prop_icon_cell_awaken_browse", 
			terminal_state = 0, 
			cell = self
		}, nil, 0)
	end
	if self.current_type == self.enum_type._USE_CONSUMPTION or self.current_type == self.enum_type._CUITIVATE_SPIRIT_USE then
		if self.current_type == self.enum_type._USE_CONSUMPTION then
			self.user_props = fundPropWidthId(self.prop)
		end
		local function consumptionOnTouchEvent(sender, evenType)
			local __spoint = sender:getTouchBeganPosition()
			local __mpoint = sender:getTouchMovePosition()
			local __epoint = sender:getTouchEndPosition()

			if sender == nil or sender._self == nil then
				return true
			end

			if ccui.TouchEventType.began == evenType then
				-- if self.isGrayed ~= nil then
				-- 	fwin:addTouchEventListener(Panel_prop, nil, 
				-- 	{
				-- 		terminal_name = "prop_icon_cell_track", 
				-- 		terminal_state = 0, 
				-- 		_prop = self.prop
				-- 	}, 
				-- 	nil, 0)
				-- else

				if sender._self.current_type == sender._self.enum_type._USE_CONSUMPTION then
					sender._self.one = true
					if sender._self.began_times == 0 then
						sender._self.began_times = os.time()
						sender._self.began_times_twi = os.time()
					end
				end
				--end
			elseif ccui.TouchEventType.moved == evenType then
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			 		or __lua_project_id == __lua_project_red_alert 
				 	or __lua_project_id == __lua_project_digimon_adventure 
				 	or __lua_project_id == __lua_project_yugioh
				 	or __lua_project_id == __lua_project_warship_girl_b 
				 	then
					if __mpoint.x - __spoint.x > 80 
						or __mpoint.x - __spoint.x < -80 
						or __mpoint.y - __spoint.y > 50 
						or __mpoint.y - __spoint.y < -50 
						then
						if sender._self.current_type == sender._self.enum_type._CUITIVATE_SPIRIT_USE then
							-- state_machine.excute("sm_cultivate_spirit_add_send_a_gift",0,{_datas = {m_type = 0,prop = self.prop}})
						else
							if sender._self.one == true then
								sender._self.one = false
								sender._self.began_times = 0
								sender._self.began_times_twi = 0
								local delayTime = 0
			                    if zstring.tonumber(sender._self.iscounts) > 2 and zstring.tonumber(sender._self.iscounts) <= 10 then
			                        delayTime = 0.3
			                    elseif zstring.tonumber(sender._self.iscounts) > 10 then
			                        delayTime = 0.15
			                    else
			                        delayTime = 0
			                    end
			                    fwin:addService({callback = function ( params )
			                            state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
			                            state_machine.unlock("formation_back_to_home_activity", 0, "")
			                            state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
										state_machine.excute("sm_role_strengthen_tab_up_grade_strengthen_exp", 0, params._self)
										params._self.iscounts = 0
										-- local shipGradeWin = fwin:find("SmRoleStrengthenTabUpgradeClass")
										-- if shipGradeWin ~= nil then
										-- 	shipGradeWin.user_exp_number = 0
										-- end
										state_machine.excute("sm_role_strengthen_tab_show_prop_number",0,"0")
										-- state_machine.excute("sm_role_strengthen_tab_skill_update_draw",0,"sm_role_strengthen_tab_skill_update_draw.")
										-- state_machine.excute("sm_role_strengthen_tab_up_stop_update",0,".")
			                        end,
			                        delay = delayTime,
			                        params = sender
			                    })
							end
						end
					end
				end
			elseif ccui.TouchEventType.ended == evenType or ccui.TouchEventType.canceled == evenType then

				if sender._self.current_type == sender._self.enum_type._CUITIVATE_SPIRIT_USE then
					state_machine.excute("sm_cultivate_spirit_add_send_a_gift",0,{_datas = {m_type = 0,prop = sender._self.prop}})
				else
					sender._self.one = false
					sender._self.began_times = 0
					sender._self.began_times_twi = 0
					local delayTime = 0
                    -- if zstring.tonumber(sender._self.iscounts) > 5 and zstring.tonumber(sender._self.iscounts) <= 15 then
                    --     delayTime = 0.2
                    -- elseif zstring.tonumber(sender._self.iscounts) > 15 then
                    --     delayTime = 0
                    -- else
                    --     delayTime = 0.5
                    -- end
                    fwin:addService({callback = function ( params )
                            state_machine.unlock("sm_role_strengthen_tab_up_grade_strengthen_exp")
                            state_machine.unlock("formation_back_to_home_activity", 0, "")
                            state_machine.unlock("sm_role_strengthen_tab_open_auto_upgrade", 0, "")
							state_machine.excute("sm_role_strengthen_tab_up_grade_strengthen_exp", 0, params._self)
							params._self.iscounts = 0
							-- local shipGradeWin = fwin:find("SmRoleStrengthenTabUpgradeClass")
							-- if shipGradeWin ~= nil then
							-- 	shipGradeWin.user_exp_number = 0
							-- end
							state_machine.excute("sm_role_strengthen_tab_show_prop_number",0,"0")
							-- state_machine.excute("sm_role_strengthen_tab_skill_update_draw",0,"sm_role_strengthen_tab_skill_update_draw.")
							-- state_machine.excute("sm_role_strengthen_tab_up_stop_update",0,".")
                        end,
                        delay = delayTime,
                        params = sender
                    })
					sender._one_called = true
				end
			end
		end
		local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
		Panel_prop._self = self
		Panel_prop:addTouchEventListener(consumptionOnTouchEvent)
		Panel_prop.callback = consumptionOnTouchEvent
	end
end

function PropIconNewCell:onInit( ... )
	if self.roots[1] == nil then
		local root = cacher.createUIRef("icon/item.csb","root")
		self:addChild(root)
		table.insert(self.roots, root)

		self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
		if self.item_order_level._x == nil then
			self.item_order_level._x = self.item_order_level:getPositionX()
		end
		root:setColor(cc.c3b(255, 255, 255))
		if root._x == nil then
			root._x = 0
		end
		if root._y == nil then
			root._x = 0
		end
		self:onUpdateDraw()
	end
end

function PropIconNewCell:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if self.roots[1] == nil then
			local root = cacher.createUIRef("icon/item.csb","root")
			self:addChild(root)
			table.insert(self.roots, root)
			root:setColor(cc.c3b(255, 255, 255))
			if root._x == nil then
				root._x = 0
			end
			if root._y == nil then
				root._x = 0
			end
			self:onUpdateDraw()
		end
	else
		local csbItem = csb.createNode("icon/item_big.csb")
		local root = csbItem:getChildByName("root")
		root:removeFromParent(false)
		root:setColor(cc.c3b(255, 255, 255))
		self:addChild(root)
		table.insert(self.roots, root)
		self:onUpdateDraw()
	end
end

function PropIconNewCell:onUpdate(dt)
	if self.one == true then
		if self.began_times ~= 0 then
			self.began_times = self.began_times + dt
			if self.began_times - self.began_times_twi > 0.5 then
				state_machine.excute("sm_role_strengthen_tab_up_grade_strengthen_exp", 0, self)
			end
		end
	end
end

function PropIconNewCell:onExit()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
        local root = self.roots[1]
        if root == nil then
            return
        end
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
	    local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	    local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
		local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
		local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
		if ssrIcon then
			ssrIcon:setVisible(false)
		end

		if Image_double ~= nil then
			Image_double:setVisible(false)
		end
		if Image_2 ~= nil then
			Image_2:setVisible(true)
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
	        Panel_prop:setTouchEnabled(true)
	        fwin:removeTouchEventListener(Panel_prop)
	    end
	    if Panel_kuang ~= nil then
	    	Panel_kuang:setVisible(true)
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
	    if Image_xuanzhong ~= nil then
	    	Image_xuanzhong:setVisible(false)
		end
		if Panel_xianding ~= nil then 
			Panel_xianding:removeAllChildren(true)
		end

        cacher.freeRef("icon/item.csb", root)

        root:stopAllActions()
        root:removeFromParent(false)
        self.roots = {}
    end
	-- state_machine.remove("prop_icon_cell_show_prop_info")
	-- state_machine.remove("prop_icon_cell_show_hero_info")
	-- state_machine.remove("prop_head_manager")
end

function PropIconNewCell:init(interfaceType, prop, useSmall, isGrayed)
	self.current_type = interfaceType
	self.prop = prop
	self.useSmall = useSmall
	self.isGrayed = isGrayed or nil
end

function PropIconNewCell:createCell()
	local cell = PropIconNewCell:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 0.5)
	return cell
end

