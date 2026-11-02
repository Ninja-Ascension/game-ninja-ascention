-- ----------------------------------------------------------------------------------------------------
-- 说明：装备重生界面

-------------------------------------------------------------------------------------------------------
EquipRebornPage = class("EquipRebornPageClass", Window)

function EquipRebornPage:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.equip_instance = nil
	
	self.Panel_xinfa = nil
	self.ArmatureNode_xinfa = nil
    -- Initialize EquipRebornPage page state machine.
    local function init_equip_reborn_terminal()
		-- 重生界面初始化，包含清除当前武将处理
        local equip_reborn_init_terminal = {
            _name = "equip_reborn_init",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:displayTypeChange("no_equip")
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 选中武将时调用，显示武将图标，武将信息
		local equip_reborn_show_equip_info_terminal = {
            _name = "equip_reborn_show_equip_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:displayTypeChange("show_equip")
				
				local root = instance.roots[1]
				local treasure_pad = ccui.Helper:seekWidgetByName(root, "Panel_8"):getChildByName("ProjectNode_1"):getChildByName("root")
				
				local equip_instance = params._datas.cell.equipInstance
				instance.equip_instance = equip_instance
				-- 绘制全身像
				local treasure_data = dms.element(dms["equipment_mould"], equip_instance.user_equiment_template)
				local all_icon = dms.atoi(treasure_data, equipment_mould.All_icon)
				ccui.Helper:seekWidgetByName(treasure_pad, "Panel_21"):setBackGroundImage(string.format("images/ui/big_props/big_props_%d.png", all_icon))
				
				-- 名称 
				local treasure_color = dms.atoi(treasure_data, equipment_mould.grow_level)
				local name_text = ccui.Helper:seekWidgetByName(treasure_pad, "Text_33")
				name_text:setString(equip_instance.user_equiment_name)
				name_text:setColor(cc.c3b(color_Type[treasure_color+1][1],color_Type[treasure_color+1][2],color_Type[treasure_color+1][3]))
				
				-- 强化
				if verifySupportLanguage(_lua_release_language_en) == true then
					ccui.Helper:seekWidgetByName(root, "Text_qh_0"):setString(_string_piece_info[6]..equip_instance.user_equiment_grade)
				else
					ccui.Helper:seekWidgetByName(root, "Text_qh_0"):setString(equip_instance.user_equiment_grade.._string_piece_info[6])
				end
				
				-- 精炼
				ccui.Helper:seekWidgetByName(root, "Text_jl_0"):setString(equip_instance.equiment_refine_level.._string_piece_info[46])
				local config = zstring.split(dms.string(dms["pirates_config"], 182, pirates_config.param), ",")
				local maxStar = dms.int(dms["equipment_mould"], equip_instance.user_equiment_template, equipment_mould.star_level)
				
				local currentStar = zstring.tonumber(equip_instance.current_star_level)

				--升星属性
				for i=1,5 do
					local starCloseImage = ccui.Helper:seekWidgetByName(root, "Image_c_"..i)
					local starOpenImage = ccui.Helper:seekWidgetByName(root, "Image_o_"..i)
					starCloseImage:setVisible(false)
					starOpenImage:setVisible(false)
					if maxStar ~= -1 then 
						if i <= maxStar then 
							starCloseImage:setVisible(true)
						end
						if i <= currentStar then 
							starOpenImage:setVisible(true)
						end
					end
				end
				-- 元宝
				ccui.Helper:seekWidgetByName(root, "Text_money_1"):setString(config[1])
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 装备重生请求
		local equip_reborn_request_reborn_terminal = {
            _name = "equip_reborn_request_reborn",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- 请求打开重生预览
				local function responseGetPreviewCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
						local previewWnd = ResolveReturnPreview:new()
						previewWnd:init(7, {response.node.equip_instance})
						fwin:open(previewWnd)
					end
				end
				
				protocol_command.recycle_init.param_list = "".."7".."\r\n"..instance.equip_instance.user_equiment_id
				NetworkManager:register(protocol_command.recycle_init.code, nil, nil, nil, instance, responseGetPreviewCallback, false, nil)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 选择重生武将
		local equip_reborn_choose_treasure_terminal = {
            _name = "equip_reborn_choose_treasure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	app.load("client.refinery.EquipChooseForReborn")
				local status = false
				for i,v in ipairs(self:sortEquipsForReborn()) do
					status = true
				end
				if status == true then
					fwin:open(EquipChooseForReborn:new(), fwin._view)
				else
					TipDlg.drawTextDailog(_string_piece_info[89].._All_tip_string_info._equip)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--帮助
		local equip_reborn_open_helpdlg_terminal = {
            _name = "equip_reborn_open_helpdlg",
            _init = function (terminal) 
                app.load("client.refinery.TreasureInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = TreasureInfo:new()
				cell:init(9)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--重生完毕的刷新
		local equip_reborn_over_update_terminal = {
            _name = "equip_reborn_over_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				pushEffect(formatMusicFile("effect", 9993))

				state_machine.excute("equip_reborn_init", 0, "equip_reborn_init.")
				state_machine.excute("shop_window_update", 0, "shop_window_update.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(equip_reborn_init_terminal)
        state_machine.add(equip_reborn_show_equip_info_terminal)
        state_machine.add(equip_reborn_request_reborn_terminal)
        state_machine.add(equip_reborn_choose_treasure_terminal)
        state_machine.add(equip_reborn_open_helpdlg_terminal)
        state_machine.add(equip_reborn_over_update_terminal)
        state_machine.init()
    end
    
    init_equip_reborn_terminal()
end

function EquipRebornPage:sortEquipsForReborn()
	local function chooseEquip()
		local list = {}
		local j = 1
		for i, v in pairs(_ED.user_equiment) do
			local shipId = v.user_equiment_id
			local shipData = dms.element(dms["equipment_mould"], v.user_equiment_template)
			local shipQuality = dms.atoi(shipData, equipment_mould.grow_level)
			local equipType = 0
			if dms.atoi(shipData, equipment_mould.equipment_type) <= 3 then
				equipType = 2
			end
			--强化，精炼，升星
			if equipType == 2 and (zstring.tonumber(v.ship_id) == 0) then
				list[j] = v
				j = j+1
			end
		end
		return list
	end
	
	local function compare(a, b)
		local a_quality = dms.int(dms["equipment_mould"], a.user_equiment_template, equipment_mould.grow_level)
		local b_quality = dms.int(dms["equipment_mould"], b.user_equiment_template, equipment_mould.grow_level)
		if a_quality > b_quality then
			return false
		elseif a_quality == b_quality then
			if tonumber(a.user_equiment_grade) > tonumber(b.user_equiment_grade) then
				return false
			end
		end
		return true
	end
	
	local function sortList(list)
		local count = #list
		
		for i=1, count do
			for j=1, count-i do
				if compare(list[j], list[j+1]) == false then
					list[j], list[j+1] = list[j+1], list[j]
				end
			end
		end
		return list
	end
	
	return sortList(chooseEquip())
end

function EquipRebornPage:displayTypeChange(_type)
	local root = self.roots[1]
	local treasure_pad = ccui.Helper:seekWidgetByName(root, "Panel_8"):getChildByName("ProjectNode_1"):getChildByName("root")

	if _type == "show_equip" then
		-- 显示属性面板
		ccui.Helper:seekWidgetByName(root, "Panel_29"):setVisible(true)
		-- 显示名称
		ccui.Helper:seekWidgetByName(treasure_pad, "Image_20"):setVisible(true)
		-- 隐藏初始面板
		ccui.Helper:seekWidgetByName(root, "Panel_27"):setVisible(false)
		-- 隐藏“+”
		ccui.Helper:seekWidgetByName(treasure_pad, "Image_21"):setVisible(false)		
	elseif _type == "no_equip" then
		-- 清除属性面板
		ccui.Helper:seekWidgetByName(root, "Panel_29"):setVisible(false)
		-- 清除武将
		ccui.Helper:seekWidgetByName(treasure_pad, "Panel_21"):removeBackGroundImage()
		-- 隐藏名称
		ccui.Helper:seekWidgetByName(treasure_pad, "Image_20"):setVisible(false)
		-- 显示初始面板
		ccui.Helper:seekWidgetByName(root, "Panel_27"):setVisible(true)
		-- 显示“+”
		ccui.Helper:seekWidgetByName(treasure_pad, "Image_21"):setVisible(true)
	end
end

function EquipRebornPage:onEnterTransitionFinish()
	local csbequip_reborn = csb.createNode("refinery/refinery_zhuangbei_cs.csb")
	self:addChild(csbequip_reborn)
	local root = csbequip_reborn:getChildByName("root")
	table.insert(self.roots, root)
	
    local treasure_pad = ccui.Helper:seekWidgetByName(root, "Panel_8"):getChildByName("ProjectNode_1"):getChildByName("root")
	
	state_machine.excute("equip_reborn_init", 0, "equip_reborn_init.")
	
	--选择
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(treasure_pad, "Panel_21"), nil, 
	{
		terminal_name = "equip_reborn_choose_treasure",
	},
	nil, 0)
	
    --帮助
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_20"), nil, 
	{
		terminal_name = "equip_reborn_open_helpdlg", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 0)
	
	--重生
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_21_1"), nil, 
	{
		terminal_name = "equip_reborn_request_reborn",
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 0)
end

function EquipRebornPage:onExit()
	state_machine.remove("equip_reborn_init")
	state_machine.remove("equip_reborn_show_equip_info")
	state_machine.remove("equip_reborn_request_reborn")
	state_machine.remove("equip_reborn_choose_treasure")
	state_machine.remove("equip_reborn_open_helpdlg")
	state_machine.remove("equip_reborn_over_update")
end
