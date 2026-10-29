-- ----------------------------------------------------------------------------------------------------
-- 说明：装备出售界面提示框   1
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EquipSellTip = class("EquipSellTipClass", Window)
   
function EquipSellTip:ctor()
    self.super:ctor()
	self.equip = nil
	self.roots = {}
    -- Initialize Home page state machine.
	 app.load("client.refinery.RefiningFurnace")
    local function init_equip_sell_tip_terminal()
		--跳转到分解界面
		local equip_sell_tip_to_resolve_terminal = {
            _name = "equip_sell_tip_to_resolve",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
            	    local isopen,tip = getFunopenLevelAndTip(10)
                    if isopen == true then	
	           			state_machine.excute("equip_storage_close_all_window",0,"")
						fwin:close(instance)
						local refiningFurnaceWindow = RefiningFurnace:new()
						fwin:cover(refiningFurnaceWindow, fwin._ui, true)
						fwin:uncover(refiningFurnaceWindow, {"MenuClass"})
						refiningFurnaceWindow = fwin:open(refiningFurnaceWindow, fwin._view)
						state_machine.excute("refining_furnace_manager", 0, 
							{
								_datas = {
									terminal_name = "refining_furnace_manager", 	
									next_terminal_name = "refining_furnace_show_equip_resolve_view",	
									current_button_name = "Button_zbfj",  	
									but_image = "", 	
									terminal_state = 0, 
									isPressedActionEnabled = false
								}
							}
						)
                    else
                        TipDlg.drawTextDailog(tip)
                    end
                else
					fwin:close(instance)
					local refiningFurnaceWindow = RefiningFurnace:new()
					fwin:cover(refiningFurnaceWindow, fwin._ui, true)
					fwin:uncover(refiningFurnaceWindow, {"MenuClass"})
					refiningFurnaceWindow = fwin:open(refiningFurnaceWindow, fwin._view)
					state_machine.excute("refining_furnace_manager", 0, 
						{
							_datas = {
								terminal_name = "refining_furnace_manager", 	
								next_terminal_name = "refining_furnace_show_equip_resolve_view",	
								current_button_name = "Button_zbfj",  	
								but_image = "", 	
								terminal_state = 0, 
								isPressedActionEnabled = false
							}
						}
					)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--继续出售
		local equip_sell_tip_to_sell_terminal = {
            _name = "equip_sell_tip_to_sell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local temp = nil
				for i, v in pairs(instance.equip) do
					temp = v
				end
				if temp ~= nil then
					local EquipSellTipTwo = EquipSellTipTwo:new()
					EquipSellTipTwo:init(instance.equip)
					fwin:open(EquipSellTipTwo, fwin._dialog)
				else
					TipDlg.drawTextDailog(_string_piece_info[24])
				end
				
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--返回
		local equip_sell_tip_to_return_terminal = {
            _name = "equip_sell_tip_to_return",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(equip_sell_tip_to_resolve_terminal)
		state_machine.add(equip_sell_tip_to_sell_terminal)
		state_machine.add(equip_sell_tip_to_return_terminal)

        state_machine.init()
    end
    
    init_equip_sell_tip_terminal()
end


function EquipSellTip:onEnterTransitionFinish()
    local csbEquipSellTip = csb.createNode("packs/EquipStorage/equipment_sell_prompt.csb")
	local action = csb.createTimeline("packs/EquipStorage/equipment_sell_prompt.csb")
	csbEquipSellTip:runAction(action)
    self:addChild(csbEquipSellTip)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	local root = csbEquipSellTip:getChildByName("root")
	table.insert(self.roots, root)
	ccui.Helper:seekWidgetByName(root, "Panel_5"):setVisible(false)
	
	local return_equipment = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {func_string = [[state_machine.excute("equip_sell_tip_to_resolve", 0, "click equip_sell_tip_to_resolve.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	local qualityButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {func_string = [[state_machine.excute("equip_sell_tip_to_sell", 0, "click equip_sell_tip_to_sell.'")]], 
									isPressedActionEnabled = true}, nil, 0)

	local buttonBack = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, {func_string = [[state_machine.excute("equip_sell_tip_to_return", 0, "click equip_sell_tip_to_return.'")]]}, nil, 0)
end


function EquipSellTip:onExit()
	state_machine.remove("equip_sell_tip_to_resolve")
	state_machine.remove("equip_sell_tip_to_sell")
	state_machine.remove("equip_sell_tip_to_return")
end

function EquipSellTip:init(equip)
	self.equip = equip
end
