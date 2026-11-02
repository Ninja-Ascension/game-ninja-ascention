----------------------------------------------------------------------------------------------------
-- 说明：小图标绘制
--prop_type
-- 物品1类型(1:宝石 2: 3: 4: 5: 6:道具 7: 8:经验 9:耐力 10: 
-- 11: 12: 13:  15: 16: 17:  19:  20:  28: 
-- 33:铁矿 34:  35:  36: 37: 38: 39: 40:
-- 41:石油 42:铅矿 43:钛矿

-- prop_show_type --负责绘制

-- props_res_icon_1.csb    含  品质框  图标
-- props_res_icon_2.csb    含  品质框  图标  右下icon
-- props_res_icon_3.csb    含  品质框  图标  中间文字位
-- props_res_icon_4.csb    含  品质框  图标  中间文字位  右下icon
-- props_res_icon_5.csb    含  品质框  图标  中间文字位  右上数量
-- props_res_icon_6.csb    含  品质框  图标  中间文字位  右下icon  道具名字
-- props_res_icon_7.csb    含  品质框  图标  中间文字位  右下icon  右上数量
-- props_res_icon_8.csb    含  品质框  图标  左上改造等级  右下强化等级  左下配件类型 道具名字
-- props_res_icon_9.csb (碎片)   含  品质框  图标  左上改造等级  右下强化等级  左下配件类型 道具名字

---------prop_from_type -- 负责 响应
--  1 响应道具详情界面 
--  2 响应小说明界面
--  3 无响应
--  4 响应配件说明
--  5 响应配件操作
--  6 响应配件碎片操作
--  7 响应配件碎片说明
--  8 响应将领基础属性页面
--  9 响应将领属性页面
--  10 响应坦克基础属性页面
--  11 响应军团切磋
--  12 响应选择道具使用
--  13 响应科威特的秘密的道具查看类型
--  14 响应配件/装甲说明(模板id)
--  15 响应坦克属性

-- attribute_type --
-- 1 道具
-- 2 技能
-- 3 坦克
-- 4 科技
-- 5 仓库
-- 6 增益
-- 7 配件
-- 8 配件碎片
-- 9 任务
-- 10 战斗力
-- 11 军团科技
-- 12 副本增益
-- 13 作战中心
-- 14 极限挑战buff
-- 15 配件(模板id)
-- 17 守卫战增益

-------------------------------------------------------------------------------------------------------
PropsIconCell = class("PropsIconCellClass", Window)
PropsIconCell.__size = nil

local props_icon_create_cell_terminal = {
    _name = "props_icon_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local prop_show_type = params[1]
        local prop_from_type = params[2]
        local prop_id = params[3]
        local attribute_type = params[4]
        local have_num = params[5]
        local show_name = params[6]
        local info = params[7]
        local cell = PropsIconCell:new()
        cell:init(prop_show_type,prop_from_type,prop_id,attribute_type,have_num,show_name,info)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(props_icon_create_cell_terminal)
state_machine.init()

function PropsIconCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	-- 显示类型
	self._prop_show_type = nil
	-- 响应类型
	self._prop_from_type = nil 
	-- 道具id
	self._prop_id = nil 
	-- 数据类型
	self._attribute_type = nil 
	-- 数量
	self._have_num = nil
    -- 是否显示名称
    self._show_name = nil

    -- 物品实例
    self._info = nil

	app.load("client.red_alert_time.props.PropsInforPrompt")
    app.load("client.red_alert_time.equipment.EquipmentInforPrompt")
    app.load("client.red_alert_time.equipment.EquipmentPartsInfor")
    app.load("client.red_alert_time.leader.LeaderExchangeInfo")
    app.load("client.red_alert_time.build_up.BuildUpTankProduction")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeUnknownChest")
    app.load("client.red_alert_time.equipment.EquipmentStrengthenReform")
 	local function init_props_icon_cell_terminal()
        --设置选中
        local props_icon_set_selected_terminal = {
            _name = "props_icon_set_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
            	if cell._prop_from_type == 1 then
            		state_machine.excute("props_infor_prompt_window_open", 0, {cell._prop_id})
            	elseif cell._prop_from_type == 2 then
                elseif cell._prop_from_type == 4 then
                    state_machine.excute("equipment_infor_prompt_window_open", 0, {_ED.user_equiment[""..cell._prop_id].equipment_mould_id, _ED.user_equiment[""..cell._prop_id]})
                elseif cell._prop_from_type == 5 then
                    if __lua_project_id == __lua_project_pacific_rim then
                        state_machine.excute("equipment_strengthen_reform_window_open", 0, {_datas = {page_index = 1, equipment_id = cell._prop_id, equipment_cell = cell}})
                    else
                        state_machine.excute("equipment_parts_infor_window_open", 0, {_ED.user_equiment[""..cell._prop_id], cell})
                    end
                elseif cell._prop_from_type == 6 then
                    local chip_id = dms.int(dms["prop_config"], 16, prop_config.param)
                    if cell._prop_id == chip_id then
                        state_machine.excute("props_infor_prompt_window_open", 0, {cell._prop_id})
                    else
                        state_machine.excute("equipment_parts_fragment_infor_open", 0, {cell._prop_id, cell._info})
                    end
                elseif cell._prop_from_type == 7 then
                    state_machine.excute("props_infor_prompt_window_open", 0, {cell._prop_id})
                elseif cell._prop_from_type == 8 then
                    local use_of_ship = dms.string(dms["prop_mould"], cell._prop_id, prop_mould.use_of_ship)
                    state_machine.excute("leader_exchange_info_window_open", 0, {use_of_ship,cell._info, 0})
                elseif cell._prop_from_type == 9 then
                    state_machine.excute("leader_exchange_info_window_open", 0, {cell._prop_id,cell._info, 0})
                elseif cell._prop_from_type == 10 then
                    local info = {}
                    info.tank_id = cell._prop_id
                    state_machine.excute("build_up_tank_production_window_open", 0, {1, info, false})
                elseif cell._prop_from_type == 11 then
                    if __lua_project_id == __lua_project_pacific_rim then
                        _ED._battle_init_type = battle_enum._fight_type._fight_type_202
                        _ED._current_scene_id = 1
                        _ED._scene_npc_id = 1
                        _ED._npc_difficulty_index = cell._have_num - 1
                        state_machine.excute("formation_defend_attack_open", 0, {2, cell._have_num})
                        state_machine.excute("formation_defend_attack_add_legion_formation_info", 0, {cell._info, cell._have_num})
                    else
                        state_machine.excute("legion_pk_attack_open", 0, {cell._info, cell._have_num})
                    end
				elseif cell._prop_from_type == 12 then	--选择道具使用
					state_machine.excute("red_alert_time_unknown_chest_window_open", 0, {cell._prop_id,cell._have_num})
				elseif cell._prop_from_type == 13 then	--科威特的秘密的道具查看类型
					state_machine.excute("red_alert_time_secret_transfer_preview", 0, {cell._prop_id})
                elseif cell._prop_from_type == 14 then
                    state_machine.excute("equipment_infor_prompt_window_open", 0, {cell._prop_id, cell._info})
                elseif cell._prop_from_type == 15 then
                    local info = {}
                    info.tank_id = cell._prop_id
                    state_machine.excute("build_up_tank_production_window_open", 0, {1, info, false, nil})
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新
        local props_icon_update_draw_terminal = {
            _name = "props_icon_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local cell = params
                if cell ~= nil then
            	   cell:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(props_icon_set_selected_terminal)  
        state_machine.add(props_icon_update_draw_terminal)      
        state_machine.init()
    end
	init_props_icon_cell_terminal()        	
end


function PropsIconCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_quality_icon = ccui.Helper:seekWidgetByName(root, "Panel_quality_icon") 	-- 道具品质
	local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon") 		-- 道具图标
	local Panel_attribute_icon = ccui.Helper:seekWidgetByName(root,"Panel_attribute_icon") 	-- 右下icon	
	
	local Text_props_res_lv = ccui.Helper:seekWidgetByName(root, "Text_props_res_lv") 		-- 中间文字位
	local Text_props_n = ccui.Helper:seekWidgetByName(root, "Text_props_n") 				-- 道具数量
    local Image_num_bg = ccui.Helper:seekWidgetByName(root, "Image_num_bg")
    local Image_num_lv_bg = ccui.Helper:seekWidgetByName(root, "Image_num_lv_bg")
	local Text_props_name = ccui.Helper:seekWidgetByName(root, "Text_props_name") 			-- 道具名字

    local Text_props_lv_n = ccui.Helper:seekWidgetByName(root, "Text_props_lv_n")           -- 强化等级
    local Panel_formation_position = ccui.Helper:seekWidgetByName(root, "Panel_formation_position")     -- 配件类型图标
    local Panel_fragment = ccui.Helper:seekWidgetByName(root, "Panel_fragment")     -- 碎片
    local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")     -- 背景
    local Image_106 = ccui.Helper:seekWidgetByName(root, "Image_106")

    local Text_props_n_1 = ccui.Helper:seekWidgetByName(root, "Text_props_n_1")                 -- 配件数量
    local Image_num_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_num_bg_1")
    if Image_1 ~= nil then
        Image_1:setVisible(false)
    end

    if Image_106 ~= nil then
        Image_106:setVisible(true)
    end

    if Image_num_bg ~= nil then
        Image_num_bg:setVisible(false)
    end

    if Image_num_lv_bg ~= nil then
        Image_num_lv_bg:setVisible(false)
    end

	if Panel_quality_icon ~= nil then
        Panel_quality_icon:setVisible(true)
		Panel_quality_icon:removeAllChildren(true)
		Panel_quality_icon:removeBackGroundImage()
	end

	if Panel_props_icon ~= nil then
		Panel_props_icon:removeAllChildren(true)
		Panel_props_icon:removeBackGroundImage()
        Panel_props_icon:setTouchEnabled(true)
	end

	if Panel_attribute_icon ~= nil then
		Panel_attribute_icon:removeAllChildren(true)
		Panel_attribute_icon:removeBackGroundImage()		
	end

	if Text_props_res_lv ~= nil then
		Text_props_res_lv:setString("")
	end

	if Text_props_n ~= nil then
        Text_props_n:setVisible(true)
		Text_props_n:setString("")
	end

	if Text_props_name ~= nil then
        Text_props_name:setScale(1)
		Text_props_name:setString("")
	end

    if Text_props_lv_n ~= nil then
        Text_props_lv_n:setString("")
    end

    if Panel_formation_position ~= nil then
        Panel_formation_position:removeBackGroundImage()
        Panel_formation_position:removeAllChildren(true)
    end

    if Panel_fragment ~= nil then
        Panel_fragment:removeBackGroundImage()
        Panel_fragment:removeAllChildren(true)
    end

    if Text_props_n_1 ~= nil then
        Text_props_n_1:setString("")
    end

    if Image_num_bg_1 ~= nil then
        Image_num_bg_1:setVisible(false)
    end

	local pic_index = nil 
    local range = 0
    local prop_name = ""
	if self._attribute_type == 1 then
		pic_index = dms.string(dms["prop_mould"], self._prop_id, prop_mould.pic_index)
		pic_index = zstring.split(pic_index, ",")
        prop_name = dms.string(dms["prop_mould"], self._prop_id, prop_mould.prop_name)
	elseif self._attribute_type == 2 then
		pic_index = dms.string(dms["majesty_skill"], self._prop_id, majesty_skill.skill_pic)
		pic_index = zstring.split(pic_index, ",")
        prop_name = dms.string(dms["majesty_skill"], self._prop_id, majesty_skill.skill_name)
	elseif self._attribute_type == 3 then
		pic_index = dms.string(dms["ship_mould"], self._prop_id, ship_mould.head_icon)
		pic_index = zstring.split(pic_index, ",")
        prop_name = dms.string(dms["ship_mould"], self._prop_id, ship_mould.captain_name)
	elseif self._attribute_type == 4 then
		pic_index = dms.string(dms["teach_escalate_param"], self._prop_id, teach_escalate_param.pic_index)
		pic_index = zstring.split(pic_index, ",")
        prop_name = dms.string(dms["teach_escalate_param"], self._prop_id, teach_escalate_param.name)
	elseif self._attribute_type == 5 then
		pic_index = dms.string(dms["prop_mould"], self._prop_id, prop_mould.pic_index)
		pic_index = zstring.split(pic_index, ",")
		pic_index[2] = 100
        prop_name = dms.string(dms["prop_mould"], self._prop_id, prop_mould.prop_name)
	elseif self._attribute_type == 6 then
		pic_index = dms.string(dms["build_buff"], self._prop_id, build_buff.pic)
		pic_index = zstring.split(pic_index, ",")
    elseif self._attribute_type == 7 then       -- 配件
		local equipment_info = nil
		if self._prop_id.equipment_name ~= nil then
			equipment_info = self._prop_id
		else
			equipment_info = _ED.user_equiment[""..self._prop_id]
		end
        pic_index = zstring.split(equipment_info.pic_index, ",")
		prop_name = self._prop_id.equipment_name
    elseif self._attribute_type == 8 then       -- 配件碎片
        pic_index = dms.string(dms["prop_mould"], self._prop_id, prop_mould.pic_index)
        pic_index = zstring.split(pic_index, ",")
        local change_of_equipment = dms.int(dms["prop_mould"], self._prop_id, prop_mould.change_of_equipment)
        if change_of_equipment > 0 then
            local equipment_type = dms.int(dms["equipment_mould"], change_of_equipment, equipment_mould.equipment_type)
            prop_name = "" .. equipment_type .."." .. tipStringInfo_equipment_info[equipment_type]
        else
            prop_name = dms.string(dms["prop_mould"], self._prop_id, prop_mould.prop_name)
        end
    elseif self._attribute_type == 9 then       -- 任务
        pic_index = dms.string(dms["task_mould"], self._prop_id, task_mould.task_pic)
        pic_index = zstring.split(pic_index, ",")
    elseif self._attribute_type == 10 then       -- 战斗力
        pic_index = _ED.strategy_combat_info[""..self._prop_id].pic
    elseif self._attribute_type == 11 then       -- 军团科技
        prop_name = dms.string(dms["union_science_mould"], self._prop_id, union_science_mould.name)
        pic_index = dms.string(dms["union_science_mould"], self._prop_id, union_science_mould.pic_index)
        pic_index = zstring.split(pic_index, ",")
    elseif self._attribute_type == 12 then       -- 副本增益
        pic_index = dms.string(dms["pve_buff"], self._prop_id, pve_buff.icon_info)
        pic_index = zstring.split(pic_index, ",")
    elseif self._attribute_type == 13 then       -- 作战中心
        pic_index = _ED.fight_center_list_info[""..self._prop_id].pic_index
    elseif self._attribute_type == 14 then       -- 极限挑战buff
        pic_index = dms.string(dms["limit_challenge_buff"], self._prop_id, limit_challenge_buff.pic_index)
        pic_index = zstring.split(pic_index, ",")
    elseif self._attribute_type == 15 then       -- 配件(模板id)，装甲
        pic_index = dms.string(dms["equipment_mould"], self._prop_id, equipment_mould.pic_index)
        pic_index = zstring.split(pic_index, ",")
        prop_name = dms.string(dms["equipment_mould"], self._prop_id, equipment_mould.equipment_name)
    elseif self._attribute_type == 17 then
        pic_index = dms.string(dms["guard_buff"], self._prop_id, guard_buff.pic_index)
        pic_index = zstring.split(pic_index, ",")
	end
	Panel_props_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, pic_index[1]))
	Panel_quality_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[2]))

    local quality = pic_index[2] - 2
    local effect_paths = string.format(config_res.images.ui.effice.effect_quality_box, quality,quality)
    if cc.FileUtils:getInstance():isFileExist(effect_paths) == true then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
        local armature = ccs.Armature:create("effect_quality_box_"..quality)
        draw.initArmature(armature, nil, -1, 0, 1)
        armature:setPosition(cc.p(Panel_quality_icon:getContentSize().width/2, Panel_quality_icon:getContentSize().height/2))
        Panel_quality_icon:addChild(armature)
    end

	local count_len = 0
    local lv_len = 0
	if self._prop_show_type == 1 then
		if tonumber(pic_index[4]) > 0 then
            Panel_fragment:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[4]))
        end
	elseif self._prop_show_type == 2 then
        Panel_attribute_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[2] + 118))
        if self._show_name == true then
            Text_props_name:setString(prop_name)
        end
	elseif self._prop_show_type == 3 then
        if self._have_num ~= nil then
            Text_props_res_lv:setString("      x"..self._have_num)
        end
	elseif self._prop_show_type == 4 then
		if tonumber(pic_index[3]) == nil or tonumber(pic_index[3]) > 0 then
			Text_props_res_lv:setString(pic_index[3])
		end
		if tonumber(pic_index[6]) > 0 then
			Panel_attribute_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[6]))
		end
        if self._have_num ~= nil then
            Panel_quality_icon:setVisible(false)
        end
	elseif self._prop_show_type == 5 then
		if tonumber(pic_index[3]) == nil or tonumber(pic_index[3]) > 0 then
			Text_props_res_lv:setString(pic_index[3])
		end
		local prop_count = 0 
		if self._have_num ~= nil then
			prop_count = self._have_num
		else
	        if fundPropWidthId(self._prop_id) ~= nil then 
	            local token = fundPropWidthId(self._prop_id)
	            prop_count = zstring.tonumber(token.prop_number)
	        end
	    end
        Text_props_n:setString(exChangeNumToString(prop_count))
        count_len = string.len(""..exChangeNumToString(prop_count))
	elseif self._prop_show_type == 6 then
		local prop_count = 0 
		if self._have_num ~= nil then
			prop_count = self._have_num
		else
	        if fundPropWidthId(self._prop_id) ~= nil then 
	            local token = fundPropWidthId(self._prop_id)
	            prop_count = zstring.tonumber(token.prop_number)
	        end
	    end
        if tonumber(prop_count) < 0 then
            Text_props_n:setVisible(false)
            Image_num_bg:setVisible(false)
        else
            Text_props_n:setVisible(true)
            Image_num_bg:setVisible(true)
        end
        Text_props_n:setString(exChangeNumToString(prop_count))
        count_len = string.len(""..exChangeNumToString(prop_count))
        if self._attribute_type == 3 then
            Image_1:setVisible(true)
            -- Panel_attribute_icon:setPositionX(51)
            -- Panel_attribute_icon:setPositionY(10)
            Panel_attribute_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[2] + 118))
        else
            if tonumber(pic_index[3]) == nil or tonumber(pic_index[3]) > 0 then
                Text_props_res_lv:setString(pic_index[3])
            end
            -- Panel_attribute_icon:setPositionX(75)
            -- Panel_attribute_icon:setPositionY(23)
            Panel_attribute_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[6]))
        end
        Text_props_name:setString(prop_name)
	elseif self._prop_show_type == 7 then
		local prop_count = 0 
        if fundPropWidthId(self._prop_id) ~= nil then 
            local token = fundPropWidthId(self._prop_id)
            prop_count = zstring.tonumber(token.prop_number)
        end
        if tonumber(prop_count) < 0 then
            Image_num_bg:setVisible(false)
        else
            Image_num_bg:setVisible(true)
        end
        Text_props_n:setString(exChangeNumToString(prop_count))
        Text_props_res_lv:setString(pic_index[3])
        Panel_attribute_icon:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[6]))
    elseif self._prop_show_type == 8 then
        local equip_type = 0                -- 0：配件，1：装甲
        if self._attribute_type == 15 then
            local armor_type = dms.int(dms["equipment_mould"], self._prop_id, equipment_mould.equipment_seat)
            if armor_type == 0 then
                equip_type = 0
            else
                equip_type = 1
            end
        else
            equip_type = 0
        end
        if equip_type == 1 then              -- 装甲
            Image_num_lv_bg:setVisible(true)
            local strength_level = 1
            if self._info ~= nil then
                strength_level = self._info.upgrade_level
            end
            Text_props_lv_n:setString(string.format(red_alert_time_str[33], strength_level))
            lv_len = string.len(Text_props_lv_n:getString())
            if self._have_num ~= nil and tonumber(self._have_num) >= 0 then
                Text_props_n_1:setString(exChangeNumToString(self._have_num))
                Image_num_bg_1:setVisible(true)
                local num_len = string.len(Text_props_n_1:getString())
                local size = Image_num_bg:getContentSize()
                local width = num_len * 10 + 6
                Image_num_bg_1:setContentSize(cc.size(width, size.height))
            end
        else         -- 配件
            Image_num_bg:setVisible(true)
            Image_num_lv_bg:setVisible(true)
            local equipment_info = {}
            if self._attribute_type == 15 then
                equipment_info.upgrade_level = 0
                equipment_info.rank_up_level = 0
                equipment_info.equipment_type = dms.int(dms["equipment_mould"], self._prop_id, equipment_mould.equipment_type)
                equipment_info.influence_type = dms.int(dms["equipment_mould"], self._prop_id, equipment_mould.influence_type)

                if self._have_num ~= nil and tonumber(self._have_num) >= 0 then
                    Text_props_n_1:setString(exChangeNumToString(self._have_num))
                    Image_num_bg_1:setVisible(true)
                    local num_len = string.len(Text_props_n_1:getString())
                    local size = Image_num_bg:getContentSize()
                    local width = num_len * 10 + 6
                    Image_num_bg_1:setContentSize(cc.size(width, size.height))
                end
            else
                if self._prop_id.equipment_name ~= nil then
                    equipment_info = self._prop_id
                else
                    equipment_info = _ED.user_equiment[""..self._prop_id]
                end
                prop_name = "" .. equipment_info.equipment_type .."." .. tipStringInfo_equipment_info[tonumber(equipment_info.equipment_type)]
                if self._have_num ~= nil then
                    Panel_quality_icon:setVisible(false)
                end
            end
            local strength_level = tonumber(equipment_info.upgrade_level)         -- 当前强化等级
            local reform_level = tonumber(equipment_info.rank_up_level)           -- 当前改造等级
            Text_props_n:setString("+"..reform_level)
            Text_props_lv_n:setString(string.format(red_alert_time_str[33], strength_level))
            count_len = string.len("+"..reform_level)
            lv_len = string.len(string.format(red_alert_time_str[33], strength_level))
            if tonumber(pic_index[5]) > 0 then
                Panel_formation_position:setBackGroundImage(string.format(config_res.images.ui.icon.icon, equipment_info.influence_type + 114))
            end
        end
        if self._show_name == true then
            Text_props_name:setString(prop_name)
        end
    elseif self._prop_show_type == 9 then
        local prop_count = 0 
        if self._have_num ~= nil then
            prop_count = self._have_num
        else
            if fundPropWidthId(self._prop_id) ~= nil then 
                local token = fundPropWidthId(self._prop_id)
                prop_count = zstring.tonumber(token.prop_number)
            end
        end
        if tonumber(prop_count) < 0 then
            Text_props_n:setVisible(false)
            Image_num_bg:setVisible(false)
        else
            Text_props_n:setVisible(true)
            Image_num_bg:setVisible(true)
        end
        Text_props_n:setString(exChangeNumToString(prop_count))
        count_len = string.len(exChangeNumToString(prop_count))
        Text_props_name:setString(prop_name)
        Panel_fragment:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[4]))
        Panel_formation_position:setBackGroundImage(string.format(config_res.images.ui.icon.icon, pic_index[5]))
	end

    if self._show_name == false and Text_props_name ~= nil then
        Text_props_name:setString("")
    end

    if count_len > 0 and Image_num_bg ~= nil then
        local size = Image_num_bg:getContentSize()
        local width = count_len * 10 + 6
        Image_num_bg:setContentSize(cc.size(width, size.height))
    end

    if lv_len > 0 and Image_num_lv_bg ~= nil then
        local size = Image_num_lv_bg:getContentSize()
        local width = lv_len * 10 + 6
        Image_num_lv_bg:setContentSize(cc.size(width, size.height))
    end

	if self._prop_from_type == 3 then
		Panel_props_icon:setTouchEnabled(false)
	end

    -- 使用
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    Panel_props_icon:setSwallowTouches(false)
    local function panelTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
            pushEffect(formatMusicFile("button", 1))
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if math.abs(__spoint.x - __epoint.x) <= 10 and math.abs(__spoint.y - __epoint.y) <= 10 
                or missionIsOver() == false
                then
                state_machine.excute("props_icon_set_selected", 0, {_datas = {cell = self}})
            end
        end
    end
    Panel_props_icon:addTouchEventListener(panelTouchListener)
    Panel_props_icon.callback = panelTouchListener
end

function PropsIconCell:onEnterTransitionFinish()

end

function PropsIconCell:onUpdate(dt)

end

function PropsIconCell:onInit()
	local root = cacher.createUIRef(string.format(config_csb.cells.props.props_res_icon, self._prop_show_type), "root")
 	table.insert(self.roots, root)
 	self:addChild(root) 
	
	if root._x == nil then
		root._x = root:getPositionX()
	end
	root:setPositionX(root._x)
	
	if PropsIconCell.__size == nil then
		PropsIconCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function PropsIconCell:onExit()
	local root = self.roots[1]
	self:clearUIInfo()
	self:stopAllActions()
	cacher.freeRef(string.format(config_csb.cells.props.props_res_icon, self._prop_show_type), root)
end

function PropsIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:registerOnNoteUpdate(self)
	self:onInit()
end

function PropsIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end        
	self:clearUIInfo()
	cacher.freeRef(string.format(config_csb.cells.props.props_res_icon, self._prop_show_type), root)
	self:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function PropsIconCell:clearUIInfo()
local root = self.roots[1]
    local Panel_quality_icon = ccui.Helper:seekWidgetByName(root, "Panel_quality_icon")     -- 道具品质
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")         -- 道具图标
    local Panel_attribute_icon = ccui.Helper:seekWidgetByName(root,"Panel_attribute_icon")  -- 右下icon   
    
    local Text_props_res_lv = ccui.Helper:seekWidgetByName(root, "Text_props_res_lv")       -- 中间文字位
    local Text_props_n = ccui.Helper:seekWidgetByName(root, "Text_props_n")                 -- 道具数量
    local Image_num_bg = ccui.Helper:seekWidgetByName(root, "Image_num_bg")
    local Image_num_lv_bg = ccui.Helper:seekWidgetByName(root, "Image_num_lv_bg")
    local Text_props_name = ccui.Helper:seekWidgetByName(root, "Text_props_name")           -- 道具名字

    local Text_props_lv_n = ccui.Helper:seekWidgetByName(root, "Text_props_lv_n")           -- 强化等级
    local Panel_formation_position = ccui.Helper:seekWidgetByName(root, "Panel_formation_position")     -- 配件类型图标
    local Panel_fragment = ccui.Helper:seekWidgetByName(root, "Panel_fragment")     -- 碎片
    local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")     -- 背景
    local Image_106 = ccui.Helper:seekWidgetByName(root, "Image_106") 

    local Text_props_n_1 = ccui.Helper:seekWidgetByName(root, "Text_props_n_1")                 -- 配件数量
    local Image_num_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_num_bg_1")
    if Image_1 ~= nil then
        Image_1:setVisible(true)
    end

    if Image_106 ~= nil then
        Image_106:setVisible(true)
    end

    if Text_props_n ~= nil then
        Text_props_n:setVisible(true)
    end

    if Image_num_bg ~= nil then
        Image_num_bg:setVisible(true)
    end

    if Image_num_lv_bg ~= nil then
        Image_num_lv_bg:setVisible(true)
    end

    if Panel_quality_icon ~= nil then
        Panel_quality_icon:removeAllChildren(true)
        Panel_quality_icon:removeBackGroundImage()
    end

    if Panel_props_icon ~= nil then
        Panel_props_icon:removeAllChildren(true)
        Panel_props_icon:removeBackGroundImage()
        Panel_props_icon:setTouchEnabled(true)
    end

    if Panel_attribute_icon ~= nil then
        Panel_attribute_icon:setVisible(true)
        Panel_attribute_icon:removeAllChildren(true)
        Panel_attribute_icon:removeBackGroundImage()        
    end

    if Text_props_res_lv ~= nil then
        Text_props_res_lv:setString("")
    end

    if Text_props_n ~= nil then
        Text_props_n:setString("")
    end

    if Text_props_name ~= nil then
        Text_props_name:setScale(1)
        Text_props_name:setVisible(true)
        Text_props_name:setString("")
    end

    if Text_props_lv_n ~= nil then
        Text_props_lv_n:setString("")
    end

    if Panel_formation_position ~= nil then
        Panel_formation_position:removeBackGroundImage()
        Panel_formation_position:removeAllChildren(true)
    end

    if Panel_fragment ~= nil then
        Panel_fragment:removeBackGroundImage()
        Panel_fragment:removeAllChildren(true)
    end

    if Text_props_n_1 ~= nil then
        Text_props_n_1:setString("")
    end

    if Image_num_bg_1 ~= nil then
        Image_num_bg_1:setVisible(false)
    end
end

function PropsIconCell:init(prop_show_type,prop_from_type,prop_id,attribute_type,have_num,show_name,info) --显示类型,拼出来用于绘图的实例,道具本身实例,用于给下个界面,缓存用的下标
	self._prop_show_type = prop_show_type
	self._prop_from_type = prop_from_type
	self._prop_id = prop_id
	self._attribute_type = attribute_type
	self._have_num = have_num
    self._show_name = show_name
    self._info = info
	-- if index ~= nil and index < max_cout then
		self:onInit()
	-- end

	self:setContentSize(PropsIconCell.__size)

end

