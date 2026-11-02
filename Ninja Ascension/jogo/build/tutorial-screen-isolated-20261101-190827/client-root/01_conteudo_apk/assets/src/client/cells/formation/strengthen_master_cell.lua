----------------------------------------------------------------------------------------------------
-- 说明：强化大师装备（宝物）绘制
-------------------------------------------------------------------------------------------------------
StrengthenMasterCell = class("StrengthenMasterCellClass", Window)

function StrengthenMasterCell:ctor()
    self.super:ctor()

	self.roots = {}
	self.instanceId = nil
	self.instanceInfo = nil
	self.nextMasterNeedLevel = nil
	self.type = nil 
	
	self.enum_type = {
		_EQUIPSTRENGTHEN = 1,		-- 装备强化
		_EQUIPREFINE = 2,			-- 装备精炼
		_TREASURESTRENGTHEN = 3,	-- 宝物强化
		_TREASUREREFINE  = 4,		-- 宝物精炼
	}	
	
	local function init_strengthen_master_cell_terminal()
		local strengthen_master_cell_jump_terminal = {
            _name = "strengthen_master_cell_jump",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.enum_type._EQUIPSTRENGTHEN == params._datas._cell.type then
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						fwin:find("FormationTigerGateClass"):setVisible(false)
						fwin:find("HeroIconListViewClass"):setVisible(false)
					else
						fwin:find("FormationClass"):setVisible(false)
					end
					fwin:find("StrengthenMasterClass"):setVisible(false)
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					else
						local userinfo = EquipPlayerInfomation:new()
						local info = fwin:open(userinfo,fwin._view)
					end
					local equipStrengthenRefineStrorageWindow = EquipStrengthenRefineStrorage:new()
					equipStrengthenRefineStrorageWindow:init(params._datas._instanceInfo, "1", params._datas._cell, "strengthen_master")
					fwin:open(equipStrengthenRefineStrorageWindow, fwin._view)
					
				elseif instance.enum_type._TREASURESTRENGTHEN == params._datas._cell.type then
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						fwin:find("FormationTigerGateClass"):setVisible(false)
						fwin:find("HeroIconListViewClass"):setVisible(false)
					else
						fwin:find("FormationClass"):setVisible(false)
					end

					fwin:find("StrengthenMasterClass"):setVisible(false)
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					else				
						local userinfo = UserInformationHeroStorage:new()
						local info = fwin:open(userinfo,fwin._view)
					end
					local tcp = TreasureControllerPanel:new()
					tcp:setCurrentTreasure(params._datas._instanceInfo, "strengthen_master",1)
					fwin:open(tcp, fwin._view)
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					else
						state_machine.excute("treasure_controller_manager", 0, 
							{
								_datas = {
									terminal_name = "treasure_controller_manager", 	
									next_terminal_name = "treasure_refine_to_strengthen",	
									current_button_name = "Button_equipment",  	
									but_image = "", 	
									terminal_state = 0, 
									openWinId = -1,
									isPressedActionEnabled = false
								}
							}
						)
					end
				elseif instance.enum_type._EQUIPREFINE == params._datas._cell.type then
					local arena_grade=dms.int(dms["fun_open_condition"], 40, fun_open_condition.level)
					if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							fwin:find("FormationTigerGateClass"):setVisible(false)
							fwin:find("HeroIconListViewClass"):setVisible(false)
						else
							fwin:find("FormationClass"):setVisible(false)
						end
						fwin:find("StrengthenMasterClass"):setVisible(false)
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						else
							local userinfo = EquipPlayerInfomation:new()
							local info = fwin:open(userinfo,fwin._view)
						end
						local equipStrengthenRefineStrorageWindow = EquipStrengthenRefineStrorage:new()
						equipStrengthenRefineStrorageWindow:init(params._datas._instanceInfo,"2", params._datas._cell, "strengthen_master")
						fwin:open(equipStrengthenRefineStrorageWindow, fwin._view)
					else
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 40, fun_open_condition.tip_info))
					end
					
				elseif instance.enum_type._TREASUREREFINE == params._datas._cell.type then
					local arena_grade=dms.int(dms["fun_open_condition"], 46, fun_open_condition.level)
					if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
							fwin:find("FormationTigerGateClass"):setVisible(false)
							fwin:find("HeroIconListViewClass"):setVisible(false)
						else
							fwin:find("FormationClass"):setVisible(false)
						end
						fwin:find("StrengthenMasterClass"):setVisible(false)
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						else				
							local userinfo = UserInformationHeroStorage:new()
							local info = fwin:open(userinfo,fwin._view)			
						end
						local tcp = TreasureControllerPanel:new()
						tcp:setCurrentTreasure(params._datas._instanceInfo, "strengthen_master",2)
						fwin:open(tcp, fwin._view)
						if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						else
							state_machine.excute("treasure_controller_manager", 0, 
								{
									_datas = {
										terminal_name = "treasure_controller_manager", 	
										next_terminal_name = "treasure_strengthen_to_refine",	
										current_button_name = "Button_pieces_equipment",  	
										but_image = "", 	
										terminal_state = 0, 
										openWinId = 46,
										isPressedActionEnabled = false
									}
								}
							)
						end
					else
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 46, fun_open_condition.tip_info))
					end
					
					end
					
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(strengthen_master_cell_jump_terminal)	
        state_machine.init()
	end
	init_strengthen_master_cell_terminal()
end

--红装光效显示设置
function StrengthenMasterCell:setRedVisible(isshow)
	local hong = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_hong")
	if nil ~= hong then
		hong:setVisible(isshow)
	end
end

function StrengthenMasterCell:onUpdateDraw()
	local root = self.roots[1]
	
	local mould_data = dms.element(dms["equipment_mould"], self.instanceInfo.user_equiment_template)
	
	-- 绘制图像
	local icon_panel = ccui.Helper:seekWidgetByName(root, "Panel_04_5")
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		local quality_panel = ccui.Helper:seekWidgetByName(root, "Panel_pingzhi_di")	
		local pic_index = dms.atoi(mould_data, equipment_mould.grow_level)

		quality_panel:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", pic_index + 1))
		icon_panel:setBackGroundImage(string.format("images/ui/props/props_%d.png", dms.atoi(mould_data, equipment_mould.pic_index)))
	else
		icon_panel:setBackGroundImage(string.format("images/ui/big_props/big_props_%d.png", dms.atoi(mould_data, equipment_mould.All_icon)))
	end

	-- 绘制名称
	local name = self.instanceInfo.user_equiment_name
	local colortype = dms.atoi(mould_data, equipment_mould.grow_level)
	local name_text = ccui.Helper:seekWidgetByName(root, "Text_06_2")
	name_text:setString(name)
	name_text:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))

	
	-- 绘制进度
	local level = 0
	
	if self.enum_type._EQUIPSTRENGTHEN == self.type or self.enum_type._TREASURESTRENGTHEN == self.type then
		level = tonumber(self.instanceInfo.user_equiment_grade)
	elseif self.enum_type._EQUIPREFINE == self.type or self.enum_type._TREASUREREFINE == self.type then
		level = tonumber(self.instanceInfo.equiment_refine_level)
	end
	
	local _string = level .. "/" .. self.nextMasterNeedLevel
	local _percent = level / self.nextMasterNeedLevel * 100
	
	local loading_bar = ccui.Helper:seekWidgetByName(root, "LoadingBar_01_2") 
	local string_text = ccui.Helper:seekWidgetByName(root, "Text_01_1") 
	
	if _percent > 100 then
		_percent = 100
	end
	loading_bar:setPercent(_percent)
	string_text:setString(_string)
	
	
	
		
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local quality = dms.atoi(mould_data, equipment_mould.grow_level)
		local lv =ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_lv")
		local lan=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_lan")
		local zi=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_zi")
		local cheng=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_cheng")
		lv:setVisible(false)
		lan:setVisible(false)
		zi:setVisible(false)
		cheng:setVisible(false)
		self:setRedVisible(false)
		if quality == 1 then
			--print("绿色")
			lv:setVisible(true)
		elseif quality == 2 then
			--print("蓝色")
			lan:setVisible(true)
		elseif quality == 3 then
			--print("紫色")
			zi:setVisible(true)
		elseif quality == 4 then
			--print("橙色")
			cheng:setVisible(true)
		elseif quality == 5 then
			--print("红色")
			self:setRedVisible(true)	
		end
	end
	
end

function StrengthenMasterCell:onEnterTransitionFinish()
	local filePath = "formation/strengthen_masters_list.csb"
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root"):getChildByName("Panel_dh_list")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_06_2"), nil, 
	{
		terminal_name = "strengthen_master_cell_jump", 	
		terminal_state = 0, 
		_instanceInfo = self.instanceInfo,
		_cell = self,
		isPressedActionEnabled = true
	}, 
	nil, 0)
end

function StrengthenMasterCell:onExit()

end

function StrengthenMasterCell:init(_type, _instanceId, _nextMasterNeedLevel)
	self.type = _type
	self.instanceId = _instanceId
	self.instanceInfo = _ED.user_equiment[self.instanceId]
	self.nextMasterNeedLevel = _nextMasterNeedLevel
end

function StrengthenMasterCell:createCell()
	local cell = StrengthenMasterCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end