---------------------------------
---说明：宝物信息扩展选项卡界面
-- 创建时间:2015.03.16
-- 作者：刘迎
-- 修改记录：
-- 最后修改人：
---------------------------------

TreasureExpansionCell = class("TreasureExpansionCellClass", Window)
   
function TreasureExpansionCell:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
	self._cell = nil -- parent
	self.treasureInstance = nil		-- 宝物实例 外部传参
	
    -- Initialize HeroSeat state machine.
    local function init_treasure_expansion_terminal()
	
		--去夺宝
		local treasure_hold_terminal = {
            _name = "treasure_hold",
            _init = function (terminal) 
                app.load("client.campaign.plunder.Plunder")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if tonumber(_ED.user_info.user_grade) >= 15 then
					-- state_machine.excute("treasure_storage_return_home_page", 0, "click treasure_storage_return_home_page.")
					fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
					app.load("client.home.Menu")
					state_machine.excute("menu_clean_page_state", 0,"") 
					if fwin:find("MenuClass") == nil then
						fwin:open(Menu:new(), fwin._taskbar)
					end
					
					state_machine.excute("menu_manager", 0, 
						{
							_datas = {
								terminal_name = "menu_manager", 	
								next_terminal_name = "menu_show_campaign", 		
								current_button_name = "Button_activity", 		
								but_image = "Image_activity",	
								terminal_state = 0, 
								isPressedActionEnabled = true
							}
						}
					)
					fwin:open(Plunder:new(), fwin._view)  
					
					state_machine.excute("treasure_expansion_action_start", 0, {_datas = {cell = self._cell}})
				else
					TipDlg.drawTextDailog("15".._string_piece_info[6].._opened_tip.._string_piece_info[266])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--强行关闭自己
		local treasure_expansion_close_terminal = {
            _name = "treasure_expansion_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--todo
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--强化
		local treasure_strengthen_terminal = {
            _name = "treasure_strengthen",
            _init = function (terminal)
                app.load("client.packs.treasure.TreasureStrengthenPanel")
				app.load("client.packs.treasure.TreasureControllerPanel")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if tonumber(params._datas.currentTreasure.equipment_type) ~= 8 then
					state_machine.excute("treasure_storage_hide_treasure_storages", 0, "click treasure_storage_hide_treasure_storages.")
					local tcp = TreasureControllerPanel:new()
					tcp:setCurrentTreasure(params._datas.currentTreasure)
					fwin:open(tcp, fwin._view)
					
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
					
					state_machine.excute("treasure_expansion_action_start", 0, {_datas = {cell = self._cell}})
				else
					TipDlg.drawTextDailog(_string_piece_info[297])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--精炼
		local treasure_refine_terminal = {
            _name = "treasure_refine",
            _init = function (terminal) 
                app.load("client.packs.treasure.TreasureControllerPanel")
				app.load("client.packs.treasure.TreasureRefinePanel")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if tonumber(params._datas.currentTreasure.equipment_type) ~= 8 then
					if dms.int(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
						state_machine.excute("treasure_storage_hide_treasure_storages", 0, "click treasure_storage_hide_treasure_storages.")
						local tcp = TreasureControllerPanel:new()
						tcp:setCurrentTreasure(params._datas.currentTreasure)
						fwin:open(tcp, fwin._view)
						
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
						
						state_machine.excute("treasure_expansion_action_start", 0, {_datas = {cell = self._cell}})
					else
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.tip_info))
					end
				else
					TipDlg.drawTextDailog(_string_piece_info[298])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(treasure_hold_terminal)
		state_machine.add(treasure_strengthen_terminal)
		state_machine.add(treasure_refine_terminal)
		state_machine.add(treasure_expansion_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_treasure_expansion_terminal()
end

function TreasureExpansionCell:onUpdateDraw()

	--todo
	
end

function TreasureExpansionCell:onEnterTransitionFinish()

	--获取美术资源
    local csbListExpansionCell = csb.createNode("list/list_equipment_tan.csb")
	local root = csbListExpansionCell:getChildByName("root")
	root:removeFromParent(false)
    self:addChild(root)
	table.insert(self.roots, root)
	-- local panel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_2")
	-- local panelSize = panel:getContentSize()
	-- self:onUpdateDraw()
	-- self:setContentSize(panelSize)
	
	--去寻宝
	local treasure_hold_button = ccui.Helper:seekWidgetByName(root, "Button_3")
	treasure_hold_button:setVisible(true)
	fwin:addTouchEventListener(treasure_hold_button, nil, 
	{
		terminal_name = "treasure_hold", 
		next_terminal_name = "", 
		but_image = "", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	--强化
	local treasure_strengthen_button = ccui.Helper:seekWidgetByName(root, "Button_79520")
	fwin:addTouchEventListener(treasure_strengthen_button, nil, 
	{
		terminal_name = "treasure_strengthen", 
		next_terminal_name = "", 
		but_image = "", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		openWinId = -1,
		currentTreasure = self.treasureInstance
	}, 
	nil, 0)
	
	--精炼
	local treasure_refine_button = ccui.Helper:seekWidgetByName(root, "Button_2")
	fwin:addTouchEventListener(treasure_refine_button, nil, 
	{
		terminal_name = "treasure_refine", 
		next_terminal_name = "", 
		but_image = "", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		openWinId = 46,
		currentTreasure = self.treasureInstance
	}, 
	nil, 0)
	local strengthenExplain = ccui.Helper:seekWidgetByName(root, "Text_29")
	local refineExplain = ccui.Helper:seekWidgetByName(root, "Text_1")
	if tonumber(self.treasureInstance.equipment_type)~=8 then
		strengthenExplain:setString("")
		if dms.int(dms["fun_open_condition"], 46, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
			refineExplain:setString("")
		else
			refineExplain:setString(_string_piece_info[299])
		end
	else
		strengthenExplain:setString(_string_piece_info[300])
		refineExplain:setString(_string_piece_info[301])
	end
	

	--self:onUpdateDraw()
	
end

function TreasureExpansionCell:init(cells)
	self._cell = cells
	self.treasureInstance = cells.treasureInstance
end

function TreasureExpansionCell:createCell()
	local cell = TreasureExpansionCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function TreasureExpansionCell:onExit()
	state_machine.remove("treasure_hold")
	state_machine.remove("treasure_strengthen")
	state_machine.remove("treasure_refine")
	state_machine.remove("treasure_expansion_close")
end