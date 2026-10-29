-- ----------------------------------------------------------------------------------------------------
-- 说明：装备分解界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipResolvePage = class("EquipResolvePageClass", Window)

function EquipResolvePage:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.action = nil
	
	self.needEquipInfo = {}
	self.panel_Equip = {}	--武将的五个层
	self.panel_Add	= {}	--加号的五个层
	
	self.isDropping = false
	
	self.Panel_31=nil
	self.ArmatureNode_zhuangbeifenjie = nil
		
    -- Initialize EquipResolvePage page state machine.
    local function init_equip_resolve_terminal()
        --自动添加
		local equip_resolve_open_ex_terminal = {
            _name = "equip_resolve_open_ex",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.isDropping == false then
					state_machine.excute("equip_resolve_clean", 0, "equip_resolve_clean.")
				
					for i, v in ipairs(instance:getSortedEquips()) do
						table.insert(self.needEquipInfo, v)
						if #self.needEquipInfo == 5 then
							break
						end	
					end
					
					if #self.needEquipInfo <= 0 then
						TipDlg.drawTextDailog(_string_piece_info[94])
						return
					end
					
					instance:onUpdateDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--清除操作
		local equip_resolve_clean_terminal = {
            _name = "equip_resolve_clean",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.needEquipInfo = {}
				--> print("kokokokoko","进来啦")
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--分解
		local equip_resolve_do_terminal = {
            _name = "equip_resolve_do",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.lock("equip_resolve_do")
				if instance.isDropping == false then
					local function responseGetPreviewCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							--TODO:
							local previewWnd = ResolveReturnPreview:new()
							previewWnd:init(2, instance.needEquipInfo)
							fwin:open(previewWnd)
							state_machine.unlock("equip_resolve_do")
						end
					end
					
					local str = ""
					for i, v in pairs(instance.needEquipInfo) do
						if v ~= nil then
							str = str .. v.user_equiment_id .. ","
						end	
					end
					if str == nil or str == "" then 
						TipDlg.drawTextDailog(_string_piece_info[88].._All_tip_string_info._equip)
						state_machine.unlock("equip_resolve_do")
						return
					end
					protocol_command.recycle_init.param_list = "".."1".."\r\n"..str
					NetworkManager:register(protocol_command.recycle_init.code, nil, nil, nil, nil, responseGetPreviewCallback, false, nil)
				else
					state_machine.unlock("equip_resolve_do")
                end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--接收选择列表传来的数据
		local equip_resolve_update_info_terminal = {
            _name = "equip_resolve_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.needEquipInfo = params._datas.needEquipInfo
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--进入选择英雄列表
		local equip_resolve_enter_choose_equip_terminal = {
            _name = "equip_resolve_enter_choose_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.isDropping == false then
					local choose_equip_list = EquipChooseForResolve:new()
					choose_equip_list:init(instance.needEquipInfo)
					fwin:open(choose_equip_list, fwin._view)
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--取消一个升级材料的选择
		local equip_resolve_cancel_one_terminal = {
            _name = "equip_resolve_cancel_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.isDropping == false then
					-- local _equiment_id = params._datas._equiment_id
					-- local pos = nil
					-- for i, v in pairs(instance.needEquipInfo) do
						-- if v.user_equiment_id == _equiment_id then
							-- pos = i 
							-- break
						-- end
					-- end
					-- local equipPanel = instance.panel_Equip[pos]
					-- local addPanel = instance.panel_Add[pos]
					-- addPanel:setVisible(true)
					-- equipPanel:removeAllChildren(true)
					-- instance.needEquipInfo[pos] = nil
					local _equiment_id = params._datas._equiment_id
					local pos = nil
					local EquipInfotable = {}
					for i, v in pairs(instance.needEquipInfo) do
						if v.user_equiment_id ~= _equiment_id then
							table.insert(EquipInfotable, v)
						end
					end
					
					instance.needEquipInfo = {}
					for i, v in pairs(EquipInfotable) do
						table.insert(instance.needEquipInfo, v)
						if #instance.needEquipInfo == 5 then
							break
						end	
					end			
					instance:onUpdateDraw()
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--分解前，去除所有装备头上的叉叉
		local equip_resolve_remove_equip_x_terminal = {
            _name = "equip_resolve_remove_equip_x",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				for i, v in pairs(instance.needEquipInfo) do
					local equipPanel = instance.panel_Equip[i]
					ccui.Helper:seekWidgetByName(equipPanel, "Button_12"):setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--分解完毕的刷新
		local equip_resolve_over_update_terminal = {
            _name = "equip_resolve_over_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- local action = csb.createTimeline("refinery/refinery_information.csb")
				-- instance.roots[1]:runAction(action)
				
				playEffect(formatMusicFile("effect", 9990))
				
				local action = instance.action
				action:gotoFrameAndPlay(0, action:getDuration(), false)
				action:setFrameEventCallFunc(function (frame)
					if nil == frame then
						return
					end

					local str = frame:getEvent()
					if str == "over" then
						-- 更新用户银币信息
						state_machine.excute("shop_window_update", 0, "shop_window_update.")
						
						-- 更新威名
						ccui.Helper:seekWidgetByName(self.roots[1], "Text_jianghun_0"):setString(_ED.user_info.all_glories) 
						
						-- 移除材料
						state_machine.excute("equip_resolve_clean", 0, "equip_resolve_clean.")
						
						action:gotoFrameAndPlay(0, 0, false)
					end
				end)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--神装商店跳转
		local equip_resolve_goto_equip_shop_terminal = {
            _name = "equip_resolve_goto_equip_shop",
            _init = function (terminal) 
             app.load("client.campaign.trialtower.TrialTowerShop")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				-- 增加去神装商店的 等级判定
				if checkupTrialTowerShopIsOpened(true) then
			
					local function responseKingdomsCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							local function responsePropCompoundCallback(response)
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									fwin:open(TrialTowerShop:new(), fwin._view)
								end
							end
							NetworkManager:register(protocol_command.dignified_shop_init.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
						else
						end
					end
					NetworkManager:register(protocol_command.three_kingdoms_init.code, nil, nil, nil, nil, responseKingdomsCallback, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--帮助
		local equip_resolve_open_helpdlg_terminal = {
            _name = "equip_resolve_open_helpdlg",
            _init = function (terminal) 
                app.load("client.refinery.TreasureInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = TreasureInfo:new()
				cell:init(2)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		        --分解动画播放
        local equip_resolve_amiation_play_terminal = {
            _name = "equip_resolve_amiation_play",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
            		instance:playEquipAnimation()
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(equip_resolve_open_ex_terminal)
        state_machine.add(equip_resolve_clean_terminal)
        state_machine.add(equip_resolve_do_terminal)
        state_machine.add(equip_resolve_update_info_terminal)
        state_machine.add(equip_resolve_enter_choose_equip_terminal)
        state_machine.add(equip_resolve_goto_equip_shop_terminal)
        state_machine.add(equip_resolve_open_helpdlg_terminal)
        state_machine.add(equip_resolve_cancel_one_terminal)
        state_machine.add(equip_resolve_over_update_terminal)
        state_machine.add(equip_resolve_remove_equip_x_terminal)
        state_machine.add(equip_resolve_amiation_play_terminal)
        state_machine.init()
    end
    
    init_equip_resolve_terminal()
end
function EquipResolvePage:playEquipAnimation()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self.ArmatureNode_zhuangbeifenjie:getParent():setVisible(true)
		csb.animationChangeToAction(self.ArmatureNode_zhuangbeifenjie, 0, 0, nil)
	end
end
function EquipResolvePage:getSortedEquips()
	local function chooseEquip()
		local list = {}
		local j = 1
		for i, v in pairs(_ED.user_equiment) do
			local shipId = v.user_equiment_id
			local shipData = dms.element(dms["equipment_mould"], v.user_equiment_template)
			local shipQuality = dms.atoi(shipData, equipment_mould.grow_level)
			
			local equipType = nil
			if dms.atoi(shipData, equipment_mould.equipment_type) <= 3 then
				equipType = 1
			end		
			if (equipType == 1 
				and zstring.tonumber(v.ship_id) == 0 
				and dms.atoi(shipData, equipment_mould.refining_get_of_stone) >= 0 )
				or dms.atoi(shipData, equipment_mould.refining_items) ~= -1
				then
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
			if a.user_equiment_grade > b.user_equiment_grade then
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

function EquipResolvePage:onUpdateDraw()
	for i = 1,5 do
		local equipPanel = self.panel_Equip[i]
		local addPanel = self.panel_Add[i]
		if self.needEquipInfo[i] ~= nil then
			addPanel:setVisible(false)
			equipPanel:removeAllChildren(true)
			local equipCell = EquipRefineryIcon:createCell()
			equipCell:init(1, self.needEquipInfo[i].user_equiment_template, self.needEquipInfo[i].user_equiment_id)
			equipPanel:addChild(equipCell)
			
			--> print(equipPanel,"添加=--============================================")
		else
			--> print(equipPanel,"清除=--============================================")
			addPanel:setVisible(true)
			equipPanel:removeAllChildren(true)
		end
	end
end

function EquipResolvePage:onEnterTransitionFinish()
	local csbequip_resolve = csb.createNode("refinery/refinery_eqm_fj.csb")
	self:addChild(csbequip_resolve)
	local root = csbequip_resolve:getChildByName("root")
	table.insert(self.roots, root)
	
	self.action = csb.createTimeline("refinery/refinery_information.csb")
	root:runAction(self.action)
	
	local view_pad = ccui.Helper:seekWidgetByName(root, "Panel_18")
	local equips_pad = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		equips_pad = view_pad:getChildByName("ProjectNode_5"):getChildByName("root")
	else
	 	equips_pad = view_pad:getChildByName("ProjectNode_5_pu2"):getChildByName("root")
	end
	
	if __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		self.panel_Equip[1] = ccui.Helper:seekWidgetByName(equips_pad, "Panel_35")
		self.panel_Equip[2] = ccui.Helper:seekWidgetByName(equips_pad, "Panel_34")
		self.panel_Equip[3] = ccui.Helper:seekWidgetByName(equips_pad, "Panel_36")
		self.panel_Equip[4] = ccui.Helper:seekWidgetByName(equips_pad, "Panel_37")
		self.panel_Equip[5] = ccui.Helper:seekWidgetByName(equips_pad, "Panel_38")
	else
		for i = 1, 5 do
			local equip_panel = ccui.Helper:seekWidgetByName(equips_pad, string.format("Panel_%d", 33 + i))
			table.insert(self.panel_Equip, equip_panel)
		end
	end
	
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		self.panel_Add[1] = ccui.Helper:seekWidgetByName(equips_pad, "Panel_29_2")
		self.panel_Add[2] = ccui.Helper:seekWidgetByName(equips_pad, "Panel_29_1")
		self.panel_Add[3] = ccui.Helper:seekWidgetByName(equips_pad, "Panel_29_3")
		self.panel_Add[4] = ccui.Helper:seekWidgetByName(equips_pad, "Panel_29_4")
		self.panel_Add[5] = ccui.Helper:seekWidgetByName(equips_pad, "Panel_29_5")
	else
		for i = 1, 5 do
			local equip_panel = ccui.Helper:seekWidgetByName(equips_pad, string.format("Panel_%d", 33 + i))
			table.insert(self.panel_Equip, equip_panel)
		end

		for i = 1, 5 do
			local add_panel = ccui.Helper:seekWidgetByName(equips_pad, string.format("Panel_29_%d", i))
			table.insert(self.panel_Add, add_panel)
		end
	end
	
	--显示威名
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_jianghun_0"):setString(_ED.user_info.all_glories or "0") 
	
	self:onUpdateDraw()
	
	for i, v in ipairs(self.panel_Equip) do
		fwin:addTouchEventListener(v, nil, 
		{
			terminal_name = "equip_resolve_enter_choose_equip", 
			_ships = self.needEquipInfo, 
		}, 
		nil, 0)
	end
	
	--自动添加
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_17"), nil, 
	{
		terminal_name = "equip_resolve_open_ex", 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--分解
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_18"), nil, 
	{
		terminal_name = "equip_resolve_do", 
		isPressedActionEnabled = true
	},
	nil, 0)
	
	--神将商店
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_16"), nil, 
	{
		terminal_name = "equip_resolve_goto_equip_shop", 
		isPressedActionEnabled = true
	},
	nil, 0)
	
	--帮助
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_19"), nil, 
	{
		terminal_name = "equip_resolve_open_helpdlg", 
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
		
		local Panle_2=ccui.Helper:seekWidgetByName(root, "Panel_2")
		self.Panel_31=ccui.Helper:seekWidgetByName(equips_pad, "Panel_31")
		self.ArmatureNode_zhuangbeifenjie = self.Panel_31:getChildByName("ArmatureNode_zhuangbeifenjie")
		
		draw.initArmature(self.ArmatureNode_zhuangbeifenjie, nil, -1, 0, 1)
		self.ArmatureNode_zhuangbeifenjie:getAnimation():playWithIndex(0, 0, 0)
		self.ArmatureNode_zhuangbeifenjie._invoke = changeActionCallback
	end
end

function EquipResolvePage:onExit()
	state_machine.remove("equip_resolve_open_ex")
	state_machine.remove("equip_resolve_clean")
	state_machine.remove("equip_resolve_do")
	state_machine.remove("equip_resolve_update_info")
	state_machine.remove("equip_resolve_enter_choose_equip")
	state_machine.remove("equip_resolve_goto_equip_shop")
	state_machine.remove("equip_resolve_open_helpdlg")
	state_machine.remove("equip_resolve_cancel_one")
	state_machine.remove("equip_resolve_over_update")
	state_machine.remove("equip_resolve_remove_equip_x")
	state_machine.remove("equip_resolve_amiation_play")
end
