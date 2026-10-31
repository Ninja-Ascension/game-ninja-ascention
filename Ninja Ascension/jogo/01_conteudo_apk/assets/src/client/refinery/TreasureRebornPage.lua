-- ----------------------------------------------------------------------------------------------------
-- 说明：宝物重生界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
TreasureRebornPage = class("TreasureRebornPageClass", Window)

function TreasureRebornPage:ctor()
    self.super:ctor()
    
	self.roots = {}
	self.treasure_instance = nil
	
	self.Panel_xinfa = nil
	self.ArmatureNode_xinfa = nil
    -- Initialize TreasureRebornPage page state machine.
    local function init_treasure_reborn_terminal()
		-- 重生界面初始化，包含清除当前武将处理
        local treasure_reborn_init_terminal = {
            _name = "treasure_reborn_init",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:displayTypeChange("no_treasure")
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 选中武将时调用，显示武将图标，武将信息
		local treasure_reborn_show_treasure_info_terminal = {
            _name = "treasure_reborn_show_treasure_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:displayTypeChange("show_treasure")
				
				local root = instance.roots[1]
				local treasure_pad = ccui.Helper:seekWidgetByName(root, "Panel_8"):getChildByName("ProjectNode_1"):getChildByName("root")
				
				local treasureInstance = params._datas.cell.treasureInstance
				instance.treasure_instance = treasureInstance
				-- 绘制全身像
				local treasure_data = dms.element(dms["equipment_mould"], treasureInstance.user_equiment_template)

				local all_icon = dms.atoi(treasure_data, equipment_mould.All_icon)
				ccui.Helper:seekWidgetByName(treasure_pad, "Panel_21"):setBackGroundImage(string.format("images/ui/big_props/big_props_%d.png", all_icon))
				
				-- 名称 
				local treasure_color = dms.atoi(treasure_data, equipment_mould.grow_level)
				
				local name_text = ccui.Helper:seekWidgetByName(treasure_pad, "Text_33")

				name_text:setString(treasureInstance.user_equiment_name)
				name_text:setColor(cc.c3b(color_Type[treasure_color+1][1],color_Type[treasure_color+1][2],color_Type[treasure_color+1][3]))
				
				-- 强化
				if verifySupportLanguage(_lua_release_language_en) == true then
					ccui.Helper:seekWidgetByName(root, "Text_qh_0"):setString(_string_piece_info[6]..treasureInstance.user_equiment_grade)
				else
					ccui.Helper:seekWidgetByName(root, "Text_qh_0"):setString(treasureInstance.user_equiment_grade.._string_piece_info[6])
				end
				
				-- 精炼
				ccui.Helper:seekWidgetByName(root, "Text_jl_0"):setString(treasureInstance.equiment_refine_level.._string_piece_info[46])
				local config = nil
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_yugioh 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					or __lua_project_id == __lua_project_warship_girl_b 
					then 
					--宝物重生读取
				 	config = zstring.split(dms.string(dms["pirates_config"], 228, pirates_config.param), ",")
				 	-- 元宝
					ccui.Helper:seekWidgetByName(root, "Text_money_1"):setString(config[treasure_color + 1])
				else
					config = zstring.split(dms.string(dms["pirates_config"], 182, pirates_config.param), ",")
					-- 元宝
					ccui.Helper:seekWidgetByName(root, "Text_money_1"):setString(config[1])
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 武将重生请求
		local treasure_reborn_request_reborn_terminal = {
            _name = "treasure_reborn_request_reborn",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- 请求打开重生预览
				local function responseGetPreviewCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							response.node.Panel_xinfa:setVisible(true)
							csb.animationChangeToAction(response.node.ArmatureNode_xinfa, 0, 0, nil)
						end
						
						local previewWnd = ResolveReturnPreview:new()
						previewWnd:init(4, {response.node.treasure_instance})
						fwin:open(previewWnd)
					end
				end
				
				protocol_command.recycle_init.param_list = "".."3".."\r\n"..instance.treasure_instance.user_equiment_id
				NetworkManager:register(protocol_command.recycle_init.code, nil, nil, nil, instance, responseGetPreviewCallback, false, nil)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 选择重生武将
		local treasure_reborn_choose_treasure_terminal = {
            _name = "treasure_reborn_choose_treasure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local status = false
				for i,v in ipairs(self:sortEquipsForReborn()) do
					status = true
				end
				if status == true then
					fwin:open(TreasureChooseForReborn:new(), fwin._view)
				else
					TipDlg.drawTextDailog(_string_piece_info[226])
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--帮助
		local treasure_reborn_open_helpdlg_terminal = {
            _name = "treasure_reborn_open_helpdlg",
            _init = function (terminal) 
                app.load("client.refinery.TreasureInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = TreasureInfo:new()
				cell:init(4)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--重生完毕的刷新
		local treasure_reborn_over_update_terminal = {
            _name = "treasure_reborn_over_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				pushEffect(formatMusicFile("effect", 9993))

				state_machine.excute("treasure_reborn_init", 0, "treasure_reborn_init.")
				state_machine.excute("shop_window_update", 0, "shop_window_update.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(treasure_reborn_init_terminal)
        state_machine.add(treasure_reborn_show_treasure_info_terminal)
        state_machine.add(treasure_reborn_request_reborn_terminal)
        state_machine.add(treasure_reborn_choose_treasure_terminal)
        state_machine.add(treasure_reborn_open_helpdlg_terminal)
        state_machine.add(treasure_reborn_over_update_terminal)
        state_machine.init()
    end
    
    init_treasure_reborn_terminal()
end

function TreasureRebornPage:sortEquipsForReborn()
	local function chooseEquip()
		local list = {}
		local j = 1
		for i, v in pairs(_ED.user_equiment) do
			local shipId = v.user_equiment_id
			local shipData = dms.element(dms["equipment_mould"], v.user_equiment_template)
			local shipQuality = dms.atoi(shipData, equipment_mould.grow_level)
			local equipType = 0
			if dms.atoi(shipData, equipment_mould.equipment_type) >=4 and dms.atoi(shipData, equipment_mould.equipment_type) <6 then
				equipType = 2
			end
			if equipType == 2 and tonumber(v.user_equiment_grade) > 1 and (zstring.tonumber(v.ship_id) == 0) then
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

function TreasureRebornPage:displayTypeChange(_type)
	local root = self.roots[1]
	local treasure_pad = ccui.Helper:seekWidgetByName(root, "Panel_8"):getChildByName("ProjectNode_1"):getChildByName("root")

	if _type == "show_treasure" then
		-- 显示属性面板
		ccui.Helper:seekWidgetByName(root, "Panel_29"):setVisible(true)
		-- 显示名称
		ccui.Helper:seekWidgetByName(treasure_pad, "Image_20"):setVisible(true)
		-- 隐藏初始面板
		ccui.Helper:seekWidgetByName(root, "Panel_27"):setVisible(false)
		-- 隐藏“+”
		ccui.Helper:seekWidgetByName(treasure_pad, "Image_21"):setVisible(false)
		
	elseif _type == "no_treasure" then
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

function TreasureRebornPage:onEnterTransitionFinish()
	local csbtreasure_reborn = csb.createNode("refinery/refinery_treasure_cs.csb")
	self:addChild(csbtreasure_reborn)
	local root = csbtreasure_reborn:getChildByName("root")
	table.insert(self.roots, root)
	
    local treasure_pad = ccui.Helper:seekWidgetByName(root, "Panel_8"):getChildByName("ProjectNode_1"):getChildByName("root")
	
	state_machine.excute("treasure_reborn_init", 0, "treasure_reborn_init.")
	
	--选择
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(treasure_pad, "Panel_21"), nil, 
	{
		terminal_name = "treasure_reborn_choose_treasure",
	},
	nil, 0)
	
    --帮助
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_20"), nil, 
	{
		terminal_name = "treasure_reborn_open_helpdlg", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 0)
	
	--重生
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_21_1"), nil, 
	{
		terminal_name = "treasure_reborn_request_reborn",
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 0)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		-- 动画
		local function changeActionCallback(armatureBack)
			armatureBack:getParent():setVisible(false)
		end
		
		self.Panel_xinfa=ccui.Helper:seekWidgetByName(treasure_pad, "Panel_xinfa")
		self.ArmatureNode_xinfa = self.Panel_xinfa:getChildByName("ArmatureNode_xinfa")
			
		draw.initArmature(self.ArmatureNode_xinfa, nil, -1, 0, 1)
		self.ArmatureNode_xinfa:getAnimation():playWithIndex(0, 0, 0)
		self.ArmatureNode_xinfa._invoke = changeActionCallback
	
	end
end

function TreasureRebornPage:onExit()
	state_machine.remove("treasure_reborn_init")
	state_machine.remove("treasure_reborn_show_treasure_info")
	state_machine.remove("treasure_reborn_request_reborn")
	state_machine.remove("treasure_reborn_choose_treasure")
	state_machine.remove("treasure_reborn_open_helpdlg")
	state_machine.remove("treasure_reborn_over_update")
end
