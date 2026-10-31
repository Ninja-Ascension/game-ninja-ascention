----------------------------------------------------------------------------------------------------
-- 说明：小图标绘制
--prop_type
-- 物品1类型(1:金币 2:元宝 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 
-- 11:上阵人数 12:体力 13:武将 14竞技场排名 15:伤害 16:比武积分 17:霸气 18威名 19 日常任务积分 20功勋 21战功 28军团贡献 )
-- 33:木材 34:宝石  35 战马:36 马魂 37:龙马碎片 38:马魂碎片 39:VIP经验 40:个人站积分

-- prop_show_type --负责绘制

-- resource_1.csb    商店界面图标                    含  图标名称    绿色文字属性
-- resource_2.csb    恭喜获得界面图标 战斗结算       含  图标名称                  白色文字属性
-- resource_3.csb    包裹界面碎片图标                含                            白色文字属性   图标选中框  碎片图标标示
-- resource_4.csb    包裹界面图标                    含                            白色文字属性   图标选中框
-- resource_5.csb    包裹界面图标                    含              绿色文字属性                 图标选中框
-- resource_6.csb    武将重生 有星级 方框
-- resource_7.csb    武将  装备  方形品质框   选择为勾

---------prop_from_type -- 负责 响应
--  1 无响应 奖励获得界面 
--  2 响应包裹 界面道具
--  3 响应分解系统 
--  4 响应合成系统 
--  5 响应重生系统
--  6 无响应 对应战斗结算
--  7 响应装备 穿戴界面
--  8 无响应 无小说明
--  9 无响应
--  10 宝石镶嵌
--  11 宝石融合
--  12 宝石祭祀
--  13 签到
--  14 战马
--  15 马魂
--  16 马魂强化
--  17 兵符

------push_type---- 推送
--	1	合成
--	2	装备更换
--	3	宝石
--	4	橙色附魔碎片
--	5	宝箱、宝石袋
--	6	活动(累积充值、单笔充值标签)
-------------------------------------------------------------------------------------------------------
AllResourcesCell = class("AllResourcesCellClass", Window)
AllResourcesCell.__size = nil

local all_resource_create_cell_terminal = {
    _name = "all_resource_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local prop_show_type = params[1]
        local prop_data = params[2]
        local prop = params[3]
        local prop_from_type = params[4]
      	local index = params[5]
      	local show_name = params[6]
      	local show_numbers = params[7]
      	local push_type = params[8]
      	local index_max = params[9]
        local cell = AllResourcesCell:new()
        cell:init(prop_show_type,prop_data,prop,prop_from_type,index,show_name,show_numbers,push_type,index_max)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(all_resource_create_cell_terminal)
state_machine.init()

function AllResourcesCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例

	self.prop_show_type = nil
	self.prop_from_type = nil
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.prop_type = 0
	self.prop_numbers = 1
	self.prop_id = ""
	self.prop_name = ""
	self.selected = false
	self.prop_data = nil
    self.show_name = nil
    self.show_numbers = nil
	self.open_window = false
	self.prop_numbers_color = nil

	--推送红点
	self._push_notification = nil
	--宝石推送
	self._push_notification_gem = nil
	--推送类型
	self._push_type = 0

	self._last_time = nil
	--活动标签
	self._activity_send = nil

	self._touch_time = 0
	self._is_touched = nil
	self._touch_pos = nil

 	local function init_all_resource_cell_terminal()
        --设置选中
        local all_resource_set_selected_terminal = {
            _name = "all_resource_set_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local cell = params._datas._cell
            	if cell.prop_from_type == 2 then
	            	state_machine.excute("packs_scrollview_all_un_set_selected",0,"")
	            	state_machine.excute("packs_scrollview_equip_un_set_selected",0,"")
	            	state_machine.excute("packs_scrollview_hero_un_set_selected",0,"")
	            	state_machine.excute("packs_scrollview_jewelry_un_set_selected",0,"")
	            	state_machine.excute("packs_scrollview_use_un_set_selected",0,"")  
	                cell.selected = true
	                cell:setSelected()
	                state_machine.excute("packs_left_prop_draw",0,{cell.prop_show_type,cell.prop_data,cell.prop,cell.prop_from_type})
				elseif cell.prop_from_type == 3 then
					if cell.selected == false then
						cell.selected = true
						cell:setSelected()
						if tonumber(cell.prop_type) == 7 then
							state_machine.excute("refining_add_item",0,{cell.prop.user_equiment_id})
						elseif tonumber(cell.prop_type) == 13 then
							state_machine.excute("refining_add_item",0,{cell.prop.ship_id})
						elseif tonumber(cell.prop_type) == 35 then
							state_machine.excute("refining_add_item",0,{cell.prop.id})
						end
					elseif cell.selected == true then
						cell.selected = false
						cell:setSelected()
						if tonumber(cell.prop_type) == 7 then
							state_machine.excute("refining_remove_item",0,{cell.prop.user_equiment_id})
						elseif tonumber(cell.prop_type) == 13 then
							state_machine.excute("refining_remove_item",0,{cell.prop.ship_id})
						elseif tonumber(cell.prop_type) == 35 then
							state_machine.excute("refining_remove_item",0,{cell.prop.id})
						end
					end
				elseif cell.prop_from_type == 4 then
					state_machine.excute("combining_scrollview_equip_un_set_selected",0,"")
					state_machine.excute("combining_scrollview_hero_un_set_selected",0,"")
					state_machine.excute("combining_scrollview_tally_un_set_selected",0,"")
					cell.selected = true
					cell:setSelected()
					state_machine.excute("combining_update_draw_left",0,cell.prop)
				elseif cell.prop_from_type == 5 then
					state_machine.excute("rebirth_all_set_unselect",0,"")
					cell.selected = true
					cell:setSelected()
					state_machine.excute("rebirth_updrawleft",0,cell.prop)
	            elseif cell.prop_from_type == 7 then
	            	state_machine.excute("equipment_wear_un_set_selected",0,"")
	                cell.selected = true 
	                cell:setSelected()
	                state_machine.excute("equipment_wear_update_left_draw",0,{cell.prop_show_type,cell.prop_data,cell.prop,cell.prop_from_type})
	            elseif cell.prop_from_type == 8 then
	            	--无任何响应 并且长按不弹出小说明
	            elseif cell.prop_from_type == 9 then
	            	--无任何响应
	            elseif cell.prop_from_type == 10 then --宝石镶嵌
					state_machine.excute("equipment_gem_input_un_set_selected",0,"")
	                cell.selected = true 
	                cell:setSelected()
	                state_machine.excute("equipment_gem_input_update_left_draw",0,{cell.prop_show_type,cell.prop_data,cell.prop,cell.prop_from_type})
	            elseif cell.prop_from_type == 11 then --宝石融合
					if cell.selected == false then
						cell.selected = true
						cell:setSelected()
						state_machine.excute("equipment_gem_guse_add_item",0,{cell.prop.id})
					elseif cell.selected == true then
						cell.selected = false
						cell:setSelected()
						state_machine.excute("equipment_gem_guse_remove_item",0,{cell.prop.id})
					end
				elseif cell.prop_from_type == 12 then --宝石祭祀

				elseif cell.prop_from_type == 13 then -- 签到
					state_machine.excute("sign_in_cell_right_click",0,{cell, cell.prop_data})
				elseif cell.prop_from_type == 14 then -- 战马
					state_machine.excute("racecourse_pack_left_prop_draw",0,{cell.prop,1})
					state_machine.excute("racecourse_scrollview_un_set_selected", 0, nil)
					cell.selected = true
	                cell:setSelected()
				elseif cell.prop_from_type == 15 then -- 马魂
					state_machine.excute("racecourse_pack_left_prop_draw",0,{cell.prop,2})
					state_machine.excute("racecourse_scrollview_un_set_selected", 0, nil)
	            	cell.selected = true
	                cell:setSelected()
	            elseif cell.prop_from_type == 16 then
					if cell.selected == false then
						cell.selected = true
						cell:setSelected()
						state_machine.excute("racecourse_horse_strength_add_item",0,{cell.prop.id})
					elseif cell.selected == true then
						cell.selected = false
						cell:setSelected()
						state_machine.excute("racecourse_horse_strength_remove_item",0,{cell.prop.id})
					end
				elseif cell.prop_from_type == 17 then -- 兵符
					state_machine.excute("weapon_book_pack_left_prop_draw",0,{cell.prop})
					state_machine.excute("weapon_book_scrollview_un_set_selected", 0, nil)
					cell.selected = true
	                cell:setSelected()
	            elseif cell.prop_from_type == 18 then 	-- 回炉
					if cell.selected == false then
						cell.selected = true
						cell:setSelected()
						state_machine.excute("equipment_clear_refining_add_item",0,{cell.prop.user_equiment_id})
					elseif cell.selected == true then
						cell.selected = false
						cell:setSelected()
						state_machine.excute("equipment_clear_refining_remove_item",0,{cell.prop.user_equiment_id})
					end
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新
        local all_resource_update_draw_terminal = {
            _name = "all_resource_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local cell = params
            	cell:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(all_resource_set_selected_terminal)  
        state_machine.add(all_resource_update_draw_terminal)      
        state_machine.init()
    end
	init_all_resource_cell_terminal()        	
end

function AllResourcesCell:setSelected()
	local root = self.roots[1]
	local Image_props_quality_square = ccui.Helper:seekWidgetByName(root,"Image_props_quality_square")
	if Image_props_quality_square == nil then
		return
	end
	Image_props_quality_square:setVisible(self.selected)
end

function AllResourcesCell:onUpdateDraw()
	local root = self.roots[1]
	root:setOpacity(255)
	local prop_type  = self.prop_type 	
	local prop_numbers = self.prop_numbers
	local prop_id = self.prop_id
	local prop_name = self.prop_name

	local Panel_props_quality = ccui.Helper:seekWidgetByName(root, "Panel_props_quality") -- 道具品质
	local Panel_porps_icon = ccui.Helper:seekWidgetByName(root, "Panel_porps_icon") -- 道具图标
	local Panel_poros_star = ccui.Helper:seekWidgetByName(root,"Panel_poros_star") -- 星数	
	
	local Text_props_number = ccui.Helper:seekWidgetByName(root, "Text_props_number") -- 道具数量
	local Text_props_name = ccui.Helper:seekWidgetByName(root, "Text_props_name") -- 道具名字
	
	local Image_props_quality_square = ccui.Helper:seekWidgetByName(root,"Image_props_quality_square") -- 碎片选中
	local Image_props_fragment = ccui.Helper:seekWidgetByName(root,"Image_props_fragment") -- 碎片标志

	local Image_push = ccui.Helper:seekWidgetByName(root,"Image_push")		--推送红点
	self._push_notification = Image_push

	local Panel_push = ccui.Helper:seekWidgetByName(root,"Panel_push")		--宝石推送
	self._push_notification_gem = Panel_push

	local Image_send = ccui.Helper:seekWidgetByName(root,"Image_send")		--活动标签
	self._activity_send = Image_send

	if Panel_props_quality ~= nil then
		Panel_props_quality:removeAllChildren(true)
		Panel_props_quality:removeBackGroundImage()
	end

	if Panel_porps_icon ~= nil then
		Panel_porps_icon:removeAllChildren(true)
		Panel_porps_icon:removeBackGroundImage()
		Panel_porps_icon:setTouchEnabled(true)	
	end

	if Panel_poros_star ~= nil then
		Panel_poros_star:removeAllChildren(true)
		Panel_poros_star:removeBackGroundImage()		
	end
	if Text_props_number ~= nil then
		Text_props_number:setString("")
		Text_props_number:setVisible(self.show_numbers)
		self.prop_numbers_color = Text_props_number:getColor()
	end

	if Text_props_name ~= nil then
		Text_props_name:setString("")
		Text_props_name:setVisible(self.show_name)
	end

	if Image_props_quality_square ~= nil then
		Image_props_quality_square:setVisible(false)
	end

	if Image_props_fragment ~= nil then
		Image_props_fragment:setVisible(false)
	end

	if Image_push ~= nil then
		Image_push:setVisible(false)
	end

	if Panel_push ~= nil then
		Panel_push:setVisible(false)
	end

	if Image_send ~= nil then
		Image_send:setVisible(false)
	end

	if self.prop_show_type == 1 then

	elseif self.prop_show_type == 2 
		or self.prop_show_type == 10
		then -- 恭喜获得 战斗结算
		local name = reward_prop_list[tonumber(prop_type)]
		local quality = 4
		if tonumber(prop_type) == 1 then
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4002.png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_4.png")
			quality = 4
		elseif tonumber(prop_type) == 2 then
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4001.png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_4.png")	
			quality = 4	
		elseif tonumber(prop_type) == 3 then
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4004.png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_4.png")	
			quality = 4			
		elseif tonumber(prop_type) == 5 then
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4008.png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_4.png")
			quality = 4
		elseif tonumber(prop_type) == 6 then
			name = self.prop.prop_name or dms.string(dms["prop_mould"],prop_id,prop_mould.prop_name)
			local pic_index = dms.int(dms["prop_mould"],prop_id,prop_mould.pic_index)
			quality = dms.int(dms["prop_mould"],prop_id,prop_mould.prop_quality)
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_"..pic_index..".png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")			
		elseif tonumber(prop_type) == 7 then
			name = dms.string(dms["equipment_mould"],prop_id,equipment_mould.equipment_name)
			local pic_index = dms.int(dms["equipment_mould"],prop_id,equipment_mould.pic_index)
			quality = dms.int(dms["equipment_mould"],prop_id,equipment_mould.grow_level)
			Panel_porps_icon:setBackGroundImage("images/ui/equip/equip_"..pic_index..".png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
		elseif tonumber(prop_type) == 12 then
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4009.png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_4.png")
			quality = 4
		elseif tonumber(prop_type) == 13 then
			name = dms.string(dms["ship_mould"],prop_id,ship_mould.captain_name)
			local pic_index = dms.int(dms["ship_mould"],prop_id,ship_mould.head_icon) + 10000
			quality = dms.int(dms["ship_mould"],prop_id,ship_mould.ship_type)
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
			Panel_porps_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", pic_index))
		elseif tonumber(prop_type) == 28 then   --军团贡献
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4013.png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_4.png")
			quality = 4
		elseif tonumber(prop_type) == 31 then 		--战神令
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4016.png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_4.png")
			quality = 4
		elseif tonumber(prop_type) == 32 then 		--气势值
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4017.png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_4.png")
			quality = 4
		elseif tonumber(prop_type) == 33 then 		--木材
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4019.png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_4.png")
			quality = 4
		elseif tonumber(prop_type) == 34 then 		--宝石
			local pic_index = dms.int(dms["gems_mould"],prop_id,gems_mould.pic)
			quality = dms.int(dms["gems_mould"],prop_id,gems_mould.quality)
			name = dms.string(dms["gems_mould"],prop_id,gems_mould.name)
			local level = dms.int(dms["gems_mould"],prop_id,gems_mould.level)
			prop_numbers = "+"..level
			Panel_porps_icon:setBackGroundImage("images/ui/equip_gem_icon/equip_gem_icon_"..pic_index..".png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
		elseif tonumber(prop_type) == 35 then 		-- 马
			quality = dms.int(dms["horse_mould"], prop_id, horse_mould.quality)
			name = dms.string(dms["horse_mould"], prop_id, horse_mould.horse_name)
			local picIndex = dms.int(dms["horse_mould"], prop_id, horse_mould.icon)
			local star = dms.int(dms["horse_mould"], prop_id, horse_mould.star)
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
			Panel_porps_icon:setBackGroundImage(string.format("images/ui/big_treasure/small_treasure_%d.png", picIndex))
		elseif tonumber(prop_type) == 36 then 		--马魂
			quality = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.quality)
			name = dms.string(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.horse_spirit_name)
			local picIndex = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.icon)
			local level = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.level)
			if level < 0 then 
			else
				prop_numbers = "+"..level
			end
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
			Panel_porps_icon:setBackGroundImage(string.format("images/ui/enchant/enchant_%d.png", picIndex))
		elseif tonumber(prop_type) == 37 then 		--龙马碎片
			Panel_porps_icon:setBackGroundImage("images/ui/racecourse/orange_treasure_make.png")
			quality = 4
			Panel_props_quality:setBackGroundImage("images/ui/quality/fragment_box_6.png")
		elseif tonumber(prop_type) == 38 then 		--马魂碎片
			quality = 4
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4021.png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/fragment_box_6.png")
		elseif tonumber(prop_type) == 39 then 		--VIP经验
			quality = 4
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4020.png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/fragment_box_6.png")
		elseif tonumber(prop_type) == 40 then 		--个人站积分
			quality = 4
			name = red_alert_resouce_tip[6][1]
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4022.png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
		elseif tonumber(prop_type) == 10000 then 		--箱子
			quality = 4
			name = ""
			Panel_porps_icon:setBackGroundImage("images/ui/play/player_build/rew_battle_box.png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
		end
		Text_props_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
		Text_props_name:setString(name)
		if prop_numbers == 1 then
			Text_props_number:setString("")
		else
			Text_props_number:setString(prop_numbers)
		end
	elseif self.prop_show_type == 3 then
		if tonumber(prop_type) == 36 then
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4021.png")
			Text_props_number:setString("".._ED.user_info.horse_spirits_patch)
			Image_props_fragment:setVisible(true)
			Panel_props_quality:setBackGroundImage("images/ui/quality/fragment_box_6.png")
		elseif tonumber(prop_type) == 7 then
			local quality = dms.int(dms["equipment_mould"],prop_id,equipment_mould.grow_level)
			local pic_index = dms.int(dms["equipment_mould"],prop_id,equipment_mould.pic_index) + 10000
			Panel_porps_icon:setBackGroundImage("images/ui/equip_piece/equip_"..pic_index..".png")	
			Image_props_fragment:setVisible(true)
			Text_props_number:setString(prop_numbers)
			Panel_props_quality:setBackGroundImage("images/ui/quality/fragment_box_".. quality ..".png")
		else
			local equipment_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], prop_id, prop_mould.change_of_equipment))
			local ship_mould_id = zstring.tonumber(dms.int(dms["prop_mould"],prop_id, prop_mould.use_of_ship))
			local quality = nil 
			local pic_index = nil
			if equipment_mould_id > 0 then
				quality = dms.int(dms["equipment_mould"],equipment_mould_id,equipment_mould.grow_level)
				pic_index = dms.int(dms["equipment_mould"],equipment_mould_id,equipment_mould.pic_index) + 10000
				Panel_porps_icon:setBackGroundImage("images/ui/equip_piece/equip_"..pic_index..".png")	
			elseif ship_mould_id > 0 then
				quality = dms.int(dms["ship_mould"],ship_mould_id,ship_mould.ship_type)
				picIndex = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.head_icon) + 20000
				Panel_porps_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			end
			Image_props_fragment:setVisible(true)
			Text_props_number:setString(prop_numbers)
			Panel_props_quality:setBackGroundImage("images/ui/quality/fragment_box_".. quality ..".png")
		end
	elseif self.prop_show_type == 4 then -- 道具
		local pic_index = dms.int(dms["prop_mould"],prop_id,prop_mould.pic_index)
		local quality = dms.int(dms["prop_mould"],prop_id,prop_mould.prop_quality)
		Panel_porps_icon:setBackGroundImage("images/ui/props/props_"..pic_index..".png")
		Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
		Text_props_number:setString(prop_numbers)
	elseif self.prop_show_type == 5 then -- 有实例
		if tonumber(prop_type) == 6 then
			local quality = dms.int(dms["prop_mould"],prop_id,prop_mould.prop_quality)
			Text_props_number:setString(prop_numbers)
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
			local pic_index = dms.int(dms["prop_mould"],prop_id,prop_mould.pic_index)
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_"..pic_index..".png")			
		elseif tonumber(prop_type) == 7 then
			local quality = dms.int(dms["equipment_mould"],prop_id,equipment_mould.grow_level)
			if self.prop.user_equiment_grade == nil or tonumber(self.prop.user_equiment_grade)-1 == 0 then
				Text_props_number:setString("")	
			else
				Text_props_number:setString("+"..tonumber(self.prop.user_equiment_grade)-1)
			end
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
			local pic_index = dms.int(dms["equipment_mould"],prop_id,equipment_mould.pic_index)
			Panel_porps_icon:setBackGroundImage("images/ui/equip/equip_"..pic_index..".png")	  
		elseif tonumber(prop_type) == 34 then 		--宝石
			local pic_index = dms.int(dms["gems_mould"],prop_id,gems_mould.pic)
			local quality  = dms.int(dms["gems_mould"],prop_id,gems_mould.quality)
			Panel_porps_icon:setBackGroundImage("images/ui/equip_gem_icon/equip_gem_icon_"..pic_index..".png")
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")	
			local level = dms.int(dms["gems_mould"],prop_id,gems_mould.level)
			Text_props_number:setString("+"..level)
		elseif tonumber(prop_type) == 36 then
			local quality = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.quality)
			local picIndex = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.icon)
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
			Panel_porps_icon:setBackGroundImage(string.format("images/ui/enchant/enchant_%d.png", picIndex))
			local level = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.level)
			Text_props_number:setString("+"..level)
			if level < 0 then 
				if prop_numbers == 1 then
					Text_props_number:setString("")
				else
					Text_props_number:setString(prop_numbers)
				end
			end
		end
	elseif self.prop_show_type == 6 then
		if tonumber(prop_type) == 7 then
			local quality = dms.int(dms["equipment_mould"],prop_id,equipment_mould.grow_level)
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
			-- print("=====品质=====",quality,self.prop.user_equiment_name)
			local pic_index = dms.int(dms["equipment_mould"],prop_id,equipment_mould.pic_index)
			Panel_porps_icon:setBackGroundImage("images/ui/equip/equip_"..pic_index..".png")			
		elseif tonumber(prop_type) == 13 then
			local quality = dms.int(dms["ship_mould"],prop_id,ship_mould.ship_type)
			local picIndex = dms.int(dms["ship_mould"], prop_id, ship_mould.head_icon) + 10000
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
			Panel_porps_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			local stars,stars_level = getHeroStars(prop_id)
			draw.addHeroStar(Panel_poros_star,stars,stars_level)
		elseif tonumber(prop_type) == 35 then
			local quality = dms.int(dms["horse_mould"], prop_id, horse_mould.quality)
			local picIndex = dms.int(dms["horse_mould"], prop_id, horse_mould.icon)
			local star = dms.int(dms["horse_mould"], prop_id, horse_mould.star)
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
			Panel_porps_icon:setBackGroundImage(string.format("images/ui/big_treasure/small_treasure_%d.png", picIndex))
			draw.addHeroStar(Panel_poros_star, star, quality)
		end
	elseif self.prop_show_type == 7 then
		if tonumber(prop_type) == 7 then
			local quality = dms.int(dms["equipment_mould"],prop_id,equipment_mould.grow_level)
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
			-- print("=====品质=====",quality,self.prop.user_equiment_name)
			if tonumber(self.prop.user_equiment_grade)-1 == 0 then
				Text_props_number:setString("")
			else
				Text_props_number:setString("+"..tonumber(self.prop.user_equiment_grade)-1)
			end
			local pic_index = dms.int(dms["equipment_mould"],prop_id,equipment_mould.pic_index)
			Panel_porps_icon:setBackGroundImage("images/ui/equip/equip_"..pic_index..".png")			
		elseif tonumber(prop_type) == 13 then
			local quality = dms.int(dms["ship_mould"],prop_id,ship_mould.ship_type)
			local picIndex = dms.int(dms["ship_mould"], prop_id, ship_mould.head_icon) + 10000
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
			Panel_porps_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
		elseif tonumber(prop_type) == 34 then
			local pic_index = dms.int(dms["gems_mould"],prop_id,gems_mould.pic)
			local quality  = dms.int(dms["gems_mould"],prop_id,gems_mould.quality)
			Panel_porps_icon:setBackGroundImage("images/ui/equip_gem_icon/equip_gem_icon_"..pic_index..".png")
			if self.prop_from_type == 11 then
				Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
			else
				Panel_props_quality:setBackGroundImage("images/ui/quality/stone_box_".. quality ..".png")	
			end
			local level = dms.int(dms["gems_mould"],prop_id,gems_mould.level)
			Text_props_number:setString("+"..level)
		elseif tonumber(prop_type) == 35 then
			local quality = dms.int(dms["horse_mould"], prop_id, horse_mould.quality)
			local picIndex = dms.int(dms["horse_mould"], prop_id, horse_mould.icon)
			local star = dms.int(dms["horse_mould"], prop_id, horse_mould.star)
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
			Panel_porps_icon:setBackGroundImage(string.format("images/ui/big_treasure/small_treasure_%d.png", picIndex))
			-- draw.addHeroStar(Panel_poros_star, star, quality)
		elseif tonumber(prop_type) == 36 then
			local quality = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.quality)
			local picIndex = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.icon)
			Panel_props_quality:setBackGroundImage("images/ui/quality/equipment_box_".. quality ..".png")
			Panel_porps_icon:setBackGroundImage(string.format("images/ui/enchant/enchant_%d.png", picIndex))
			local level = dms.int(dms["horse_spirit_mould"],prop_id,horse_spirit_mould.level)
			Text_props_number:setString("+"..level)
			if level < 0 then 
				Text_props_number:setString("")
			end
		end
	elseif self.prop_show_type == 8 then -- 只有图标的
		if tonumber(prop_type) == 1 then
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4002.png")
		elseif tonumber(prop_type) == 2 then
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4001.png")
		elseif tonumber(prop_type) == 3 then
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4004.png")
		elseif tonumber(prop_type) == 5 then
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4008.png")
		elseif tonumber(prop_type) == 6 then
			local pic_index = 0
			local equipment_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], prop_id, prop_mould.change_of_equipment))
			local ship_mould_id = zstring.tonumber(dms.int(dms["prop_mould"],prop_id, prop_mould.use_of_ship))
			if equipment_mould_id > 0 then
				quality = dms.int(dms["equipment_mould"],equipment_mould_id,equipment_mould.grow_level)
				pic_index = dms.int(dms["equipment_mould"],equipment_mould_id,equipment_mould.pic_index) + 10000
				Panel_porps_icon:setBackGroundImage("images/ui/equip_piece/equip_"..pic_index..".png")	
			elseif ship_mould_id > 0 then
				quality = dms.int(dms["ship_mould"],ship_mould_id,ship_mould.ship_type)
				picIndex = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.head_icon) + 10000
				Panel_porps_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
			else
				pic_index = dms.int(dms["prop_mould"],prop_id,prop_mould.pic_index)
			end
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_"..pic_index..".png")		
		elseif tonumber(prop_type) == 7 then
			local pic_index = dms.int(dms["equipment_mould"],prop_id,equipment_mould.pic_index)
			Panel_porps_icon:setBackGroundImage("images/ui/equip/equip_"..pic_index..".png")
		elseif tonumber(prop_type) == 12 then
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4009.png")
		elseif tonumber(prop_type) == 13 then
			local pic_index = dms.int(dms["ship_mould"],prop_id,ship_mould.head_icon) + 10000
			Panel_porps_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", pic_index))
		elseif tonumber(prop_type) == 28 then   --军团贡献
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4013.png")
		elseif tonumber(prop_type) == 31 then
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4016.png")
		elseif tonumber(prop_type) == 32 then
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4017.png")
		elseif tonumber(prop_type) == 33 then
			Panel_porps_icon:setBackGroundImage("images/ui/props/props_4019.png")
		elseif tonumber(prop_type) == 34 then
			local pic_index = dms.int(dms["gems_mould"],prop_id,gems_mould.pic)
			Panel_porps_icon:setBackGroundImage("images/ui/equip_gem_icon/equip_gem_icon_"..pic_index..".png")
		end
	end	
	
	self:setSelected()
	self.open_window = false

	--装备界面按钮不给交互，避免遮挡下层响应
	if self.prop_from_type == 8 then
		Panel_porps_icon:setTouchEnabled(false)
	end

	self._touch_time = 0
	self._is_touched = nil
	self._touch_pos = nil

	local function buttonTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		self._touch_pos = __spoint
        if ccui.TouchEventType.began == evenType then
        	self._touch_time = 0
        	self._is_touched = true
   --      	if tonumber(prop_type) == 7 then
   --      		local function openOtherWindow()
			--     	if self.open_window == false then
			--     		state_machine.excute("equipment_information_window_open",0,{
			--     			self.prop_show_type,self.prop_data,self.prop,self.prop_from_type,0,self.show_name,self.show_numbers,cc.p(__spoint.x,__spoint.y)
			--     			})
			--     		self.open_window = true
			--     	else
			--     		state_machine.excute("equipment_information_window_close", 0, 0)
			--     	end
			--     end 
			-- 	self.open_window = false   	    
			--     local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
			--     self:stopAllActions()
			-- 	self:runAction(action)
			-- elseif tonumber(prop_type) == 35 then
			-- 	app.load("client.red_alert.utils.PropsInformationHorse")
			-- 	local function openOtherWindow()				
			--     	if self.open_window == false then
			--     		state_machine.excute("props_information_horse_window_open",0,{
			--     			self.prop_data,cc.p(__spoint.x,__spoint.y)
			--     			})
			--     		self.open_window = true
			--     	else
			--     		state_machine.excute("props_information_horse_window_close", 0, 0)
			--     	end
			--     end 
			-- 	self.open_window = false   	    
			--     local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
			--     self:stopAllActions()
			-- 	self:runAction(action)
			-- elseif self.prop_from_type == 3 and self.prop_data.prop_type == 13 then
			-- 	local function openOtherWindow()
			--     	if self.open_window == false then
			--     		state_machine.excute("hero_packs_information_window_open",0,{self.prop,false,self.prop_from_type})
			--     		self.open_window = true
			--     	else
			--     		state_machine.excute("hero_packs_information_window_close", 0, 0)
			--     	end
			--     end 
			-- 	self.open_window = false   	    
			--     local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
			--     self:stopAllActions()
			-- 	self:runAction(action)
			-- elseif self.prop_from_type == 5 then
			-- 	local function openOtherWindow()
			--     	if self.open_window == false then
			--     		state_machine.excute("hero_packs_information_window_open",0,{self.prop,false,self.prop_from_type})
			--     		self.open_window = true
			--     	else
			--     		state_machine.excute("hero_packs_information_window_close", 0, 0)
			--     	end
			--     end 
			-- 	self.open_window = false   	    
			--     local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
			--     self:stopAllActions()
			-- 	self:runAction(action)
   --      	elseif self.prop_from_type ~= 10 
   --      		and self.prop_from_type ~= 11 
   --      		and self.prop_from_type ~= 12 
   --      		and self.prop_from_type ~= 14 
   --      		and self.prop_from_type ~= 15 
   --      		and self.prop_from_type ~= 16 
   --      		then
			--     local function openOtherWindow()
			--     	if self.open_window == false then
			--     		state_machine.excute("props_information_window_open",0,{
			--     			self.prop_show_type,self.prop_data,self.prop,self.prop_from_type,0,self.show_name,self.show_numbers,cc.p(__spoint.x,__spoint.y)
			--     			})
			--     		self.open_window = true
			--     	else
			--     		state_machine.excute("props_information_window_close", 0, 0)
			--     	end
			--     end 
			-- 	self.open_window = false   	    
			--     local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
			--     self:stopAllActions()
			-- 	self:runAction(action)
			-- elseif self.prop_from_type == 12 then
			-- 	local function openOtherWindow()
			--     	if self.open_window == false then
			--     		state_machine.excute("fate_choose_info_window_open",0,{
			--     			self.prop,cc.p(__spoint.x,__spoint.y)
			--     			})
			--     		self.open_window = true
			--     	else
			--     		state_machine.excute("fate_choose_info_window_close", 0, 0)
			--     	end
			--     end 
			-- 	self.open_window = false   	    
			--     local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
			--     self:stopAllActions()
			-- 	self:runAction(action)
			-- end
        elseif ccui.TouchEventType.moved == evenType then
        	-- if math.abs(__spoint.x - __epoint.x) > 3 or math.abs(__spoint.y - __epoint.y) > 3 then
        	-- 	self:stopAllActions()
        	-- end
        elseif ccui.TouchEventType.canceled == evenType then
        	-- self:stopAllActions()
        	-- state_machine.excute("props_information_window_close", 0, 0)
        	-- state_machine.excute("fate_choose_info_window_close", 0, 0)
        	-- state_machine.excute("equipment_information_window_close", 0, 0)
        	-- state_machine.excute("hero_packs_information_window_close",0,"")
        	-- state_machine.excute("props_information_horse_window_close", 0, 0)
        	if self._is_touched ~= nil or missionIsOver() == false then
         		self._is_touched = false
         	end
        elseif ccui.TouchEventType.ended == evenType then
        	-- self:stopAllActions()
        	-- state_machine.excute("props_information_window_close", 0, 0)
        	-- state_machine.excute("fate_choose_info_window_close", 0, 0)
        	-- state_machine.excute("equipment_information_window_close", 0, 0)
        	-- state_machine.excute("hero_packs_information_window_close",0,"")
        	-- state_machine.excute("props_information_horse_window_close", 0, 0)
        	-- if self.open_window == true then
        	-- 	return
        	-- end
         --    state_machine.excute("all_resource_set_selected",0,{_datas = {_cell = self}})
         	if self._is_touched ~= nil or missionIsOver() == false then
         		self._is_touched = false
         	end
        end
    end
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
    	local touch_button = ccui.Helper:seekWidgetByName(root,"Panel_porps_icon")
    	fwin:addTouchEventListener(touch_button, nil, {
    		terminal_name = "shortcut_open_show_reward_item_info",
    		from_icon_type = "red_alert",
    		cell = self
    	}, nil, 0)	
    else
	    local touch_button = ccui.Helper:seekWidgetByName(root,"Panel_porps_icon")
	    if self.prop_from_type == 12 then
	    	touch_button:setSwallowTouches(false)
	    else
	    	touch_button:setSwallowTouches(true)
	    end
	    touch_button:addTouchEventListener(buttonTouchEvent)
		touch_button.callback = buttonTouchEvent
	    -- fwin:addTouchEventListener(touch_button, buttonTouchEvent, {terminal_name = "",_cell = self}, nil, 0)	
	end
	-- 活动标签
	if self._push_type == 6 then
		if self._activity_send == nil then
			return
		end
		self._activity_send:setVisible(true)
	end
end

function AllResourcesCell:onEnterTransitionFinish()

end

function AllResourcesCell:pushNotification()
	--合成
	if self._push_type == 1 then
		if self._push_notification == nil then
			return
		end
		self._push_notification:setVisible(false)
		if tonumber(self.prop_type) == 6 then
			if tonumber(self.prop.coming_need_number) ~= 0 and tonumber(self.prop.prop_number) >= tonumber(self.prop.coming_need_number) then
				self._push_notification:setVisible(true)
			end
		end
	end
	--装备
	if self._push_type == 2 then
		if tonumber(self.prop_type) == 7 then
			if zstring.tonumber(self.prop.user_equiment_id) ~= 0 then
				if self._push_notification == nil then
				else 	--有更好的装备可以更换
					for i,v in pairs(_ED.user_equiment) do
						if tonumber(v.ship_id) == 0 and tonumber(v.rela_state) == 0 then 
			                if zstring.tonumber(self.prop.equipment_type) == zstring.tonumber(v.equipment_type) and zstring.tonumber(self.prop.rank_level) < zstring.tonumber(v.rank_level) then
								self._push_notification:setVisible(true)
								return
							else
                            	self._push_notification:setVisible(false)
							end
						end
		            end
				end
	            if self._push_notification_gem == nil then
	            	return
	            end
	            self._push_notification_gem:setVisible(false)
	            local equip_id = self.prop.user_equiment_id
	            if zstring.tonumber(equip_id) > 0 then
		            local equip = _ED.user_equiment[""..equip_id]
		            local can_add_gems = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.equipment_gem_numbers)
		            local table_gem_type = {}
		            for n,v in pairs(equip.jewelrys) do
		                if tonumber(v) ~= 0 then
		                    local gem = _ED.user_gems[""..v]
		                    local gem_type = dms.int(dms["gems_mould"],gem.mould_id,gems_mould.gem_type)
		                    table.insert(table_gem_type,gem_type)
		                end
		            end
		            for l,gem_id in pairs(equip.jewelrys) do
		            	--宝石可镶嵌
		                if tonumber(gem_id) <= 0 then
		                	if l <= can_add_gems then
			                    for n,v in pairs(_ED.user_gems) do
			                        local can_push = false
			                        local have_type = false
			                        local gem_type = dms.int(dms["gems_mould"],v.mould_id,gems_mould.gem_type)
			                        if tonumber(v.equip_id) > 0 then
			                        else
			                            can_push = true
			                            for k,m in pairs(table_gem_type) do
			                                if gem_type == m then
			                                    have_type = true
			                                    break
			                                end
			                            end
			                        end

			                        if can_push == true and have_type == false then
			                            self._push_notification_gem:setVisible(true)
			                            return
			                        -- else
		                         --    	self._push_notification_gem:setVisible(false)
			                        end
			                    end
			                end
		                else 	--宝石可升级
		                    local gem = _ED.user_gems[""..gem_id]
		                    local getExp = 0
		                    for n,v in pairs(_ED.user_gems) do
		                        local gem_type = dms.int(dms["gems_mould"],v.mould_id,gems_mould.gem_type)
		                        if tonumber(v.equip_id) > 0 then
		                        else
		                            if gem_type == gem.gem_type then
		                                getExp = getExp + v.give_exp
		                            end
		                        end
		                    end
		                    if gem.up_need_exp > 0 then 
			                    if getExp >= gem.up_need_exp - gem.exp then
			                        self._push_notification_gem:setVisible(true)
			                        return
			                    -- else
			                    --     self._push_notification_gem:setVisible(false)
			                    end
			                else
			                	self._push_notification_gem:setVisible(false)
			                end
		                end
		            end
		        end
			end
		end
	end
	--宝石
	if self._push_type == 3 then
		if tonumber(self.prop_type) == 34 then
			if zstring.tonumber(self.prop.equip_id) ~= 0 then 
				if self._push_notification_gem == nil then
	            	return
	            end
	            self._push_notification_gem:setVisible(false)
	            local getExp = 0
	            --宝石可升级
                for n,v in pairs(_ED.user_gems) do
                    local gem_type = dms.int(dms["gems_mould"],v.mould_id,gems_mould.gem_type)
                    if tonumber(v.equip_id) > 0 then
                    else
                        if gem_type == self.prop.gem_type then
                            getExp = getExp + v.give_exp
                        end
                    end
                end
                if self.prop.up_need_exp > 0 then 
	                if getExp >= self.prop.up_need_exp - self.prop.exp then
	                    self._push_notification_gem:setVisible(true)
	                end
	            end
			end
		end
	end
	--橙色附魔碎片
	if self._push_type == 4 then
		if self.prop_show_type == 3 and tonumber(self.prop_type) == 36 then
			local param = dms.int(dms["horse_config"], 4, horse_config.param)
			if tonumber(_ED.user_info.horse_spirits_patch) >= param then 
				self._push_notification:setVisible(true)
			end
		end
	end
	-- 宝箱、宝石袋
	if self._push_type == 5 then
		if self._push_notification == nil then
			return
		end
		self._push_notification:setVisible(false)
		if tonumber(self.prop_type) == 6 then 
			local use_of_prop_type = zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(self.prop_id), prop_mould.prop_type))
			if tonumber(use_of_prop_type) == 0 then
				self._push_notification:setVisible(true)
			end
		end
	end
end

function AllResourcesCell:openInfomationWindow( ... )
	if tonumber(self.prop_type) == 7 then
		local equipment_type = dms.int(dms["equipment_mould"], self.prop_id, equipment_mould.equipment_type)
		if equipment_type == 11 then --兵符

		else
			state_machine.excute("equipment_information_window_open",0,{
				self.prop_show_type,self.prop_data,self.prop,self.prop_from_type,0,self.show_name,self.show_numbers,cc.p(self._touch_pos.x,self._touch_pos.y)
				})
		end
	elseif tonumber(self.prop_type) == 35 then
		app.load("client.red_alert.utils.PropsInformationHorse")
		state_machine.excute("props_information_horse_window_open",0,{
			self.prop_data,cc.p(self._touch_pos.x,self._touch_pos.y)
			})
	elseif self.prop_from_type == 3 and self.prop_data.prop_type == 13 then
		state_machine.excute("hero_packs_information_window_open",0,{self.prop,false,self.prop_from_type})
	elseif self.prop_from_type == 5 then
		state_machine.excute("hero_packs_information_window_open",0,{self.prop,false,self.prop_from_type})
	elseif self.prop_from_type ~= 10 
		and self.prop_from_type ~= 11 
		and self.prop_from_type ~= 12 
		and self.prop_from_type ~= 14 
		and self.prop_from_type ~= 15 
		and self.prop_from_type ~= 16 
		then
    		state_machine.excute("props_information_window_open",0,{
    			self.prop_show_type,self.prop_data,self.prop,self.prop_from_type,0,self.show_name,self.show_numbers,cc.p(self._touch_pos.x,self._touch_pos.y)
    			})
	elseif self.prop_from_type == 12 then
		state_machine.excute("fate_choose_info_window_open",0,{
			self.prop,cc.p(self._touch_pos.x, self._touch_pos.y)
			})
	end
end

function AllResourcesCell:closeInfomationWindow( ... )
	state_machine.excute("props_information_window_close", 0, 0)
	state_machine.excute("fate_choose_info_window_close", 0, 0)
	state_machine.excute("equipment_information_window_close", 0, 0)
	state_machine.excute("hero_packs_information_window_close",0,"")
	state_machine.excute("props_information_horse_window_close", 0, 0)
end

function AllResourcesCell:onUpdate(dt)
	if self._is_touched == true then
		self._touch_time = self._touch_time + dt
		if self._touch_time >= 0.3 then
			if self.open_window == false and self._touch_pos ~= nil then
				self:openInfomationWindow()
				self.open_window = true
			end
		end
	elseif self._is_touched == false then
		self._is_touched = nil
		self._touch_time = 0
		if self.open_window == true then
			self:closeInfomationWindow()
		else
			state_machine.excute("all_resource_set_selected",0,{_datas = {_cell = self}})
		end
		self.open_window = false
	end
	if self._push_type ~= nil then
		local now_time = os.time()
		if now_time - zstring.tonumber(self._last_time) >= 1 then
			self:pushNotification()
			self._last_time = now_time
		end
	end
end

function AllResourcesCell:onInit()
	-- 推送箭头动画资源加载
	for i, v in pairs(config_res.sprites_cached["push_arrows"]) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
    end

	local root = cacher.createUIRef("cells/packs/resource_"..self.prop_show_type..".csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root) 
	
	if AllResourcesCell.__size == nil then
		AllResourcesCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function AllResourcesCell:onExit()
	self:stopAllActions()
	self._is_touched = nil
	local Text_props_number = ccui.Helper:seekWidgetByName(self.roots[1], "Text_props_number")
	if Text_props_number ~= nil and self.prop_numbers_color ~= nil then
		Text_props_number:setColor(self.prop_numbers_color)
	end
	cacher.freeRef("cells/packs/resource_"..self.prop_show_type..".csb", self.roots[1])
end

function AllResourcesCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	if self._push_notification ~= nil and self._push_notification_gem ~= nil then
        self._push_notification:setVisible(false)
        self._push_notification_gem:setVisible(false)
    end
	self:registerOnNoteUpdate(self)
	self:onInit()
end

function AllResourcesCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self._is_touched = nil
	if self._push_notification ~= nil and self._push_notification_gem ~= nil then
        self._push_notification:setVisible(false)
        self._push_notification_gem:setVisible(false)
    end
	local Text_props_number = ccui.Helper:seekWidgetByName(root, "Text_props_number")
	if Text_props_number ~= nil and self.prop_numbers_color ~= nil then
		Text_props_number:setColor(self.prop_numbers_color)
	end
	cacher.freeRef("cells/packs/resource_"..self.prop_show_type..".csb", root)
	self:unregisterOnNoteUpdate(self)
	self:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AllResourcesCell:init(prop_show_type,prop_data,prop,prop_from_type,index,show_name,show_numbers,push_type,index_max) --显示类型,拼出来用于绘图的实例,道具本身实例,用于给下个界面,缓存用的下标
	self.prop_show_type = prop_show_type
	self.prop_data = prop_data
	self.prop = prop
	self.prop_from_type = prop_from_type
	self.prop_type = prop_data.prop_type
	self.prop_numbers = prop_data.item_value
	self.prop_id = prop_data.prop_item
	self.prop_name = ""
	if show_name == nil then
		self.show_name = true
	else
		self.show_name = show_name
	end

	if show_numbers == nil then
		self.show_numbers = true
	else
		self.show_numbers = show_numbers
	end

	self._push_type = push_type	
	local max_cout = 6
	if index_max ~= nil then
		max_cout = index_max
	end
	
	if index ~= nil and index < max_cout then
		self:onInit()
	end

	self:setContentSize(AllResourcesCell.__size)

end

