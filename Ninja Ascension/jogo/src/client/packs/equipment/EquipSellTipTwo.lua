-- ----------------------------------------------------------------------------------------------------
-- 说明：装备出售界面提示框   2
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EquipSellTipTwo = class("EquipSellTipTwoClass", Window)
   
function EquipSellTipTwo:ctor()
    self.super:ctor()
	self.equip = nil
	self.roots = {}
	self.price = 0
    -- Initialize Home page state machine.
    local function init_equip_sell_tip_two_terminal()
		
		--返回
		local equip_sell_tip_two_to_return_terminal = {
            _name = "equip_sell_tip_two_to_return",
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
		
		--确定出售
		local equip_sell_tip_two_to_sell_terminal = {
            _name = "equip_sell_tip_two_to_sell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

				local function responseSellEquipCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("equip_sell_true_update_cell_status", 0, "equip_sell_true_update_cell_status.")
						state_machine.excute("equip_show_equip_counts", 0, "equip_show_equip_counts.")
						
						TipDlg.drawTextDailog(_string_piece_info[93]..response.node.price)
						fwin:close(response.node)
						
					end
				end
				
				local temp = nil
				for i, v in pairs(instance.equip) do
					if i == 1 then
						temp = v.user_equiment_id .. ","
					else
						temp = temp .. v.user_equiment_id .. ","
					end
				end
				protocol_command.equipment_sell.param_list = temp
				NetworkManager:register(protocol_command.equipment_sell.code, nil, nil, nil, instance, responseSellEquipCallback, false, nil)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(equip_sell_tip_two_to_return_terminal)
		state_machine.add(equip_sell_tip_two_to_sell_terminal)

        state_machine.init()
    end
    
    init_equip_sell_tip_two_terminal()
end


function EquipSellTipTwo:onEnterTransitionFinish()
    local csbEquipSellTipTwo = csb.createNode("packs/EquipStorage/equipment_sell_prompt.csb")
	local action = csb.createTimeline("packs/EquipStorage/equipment_sell_prompt.csb")
	csbEquipSellTipTwo:runAction(action)
    self:addChild(csbEquipSellTipTwo)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	local root = csbEquipSellTipTwo:getChildByName("root")
	table.insert(self.roots, root)
	
	ccui.Helper:seekWidgetByName(root, "Panel_6"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Text_5"):setVisible(false)
	local num = 0
	for i, v in pairs(self.equip) do
		num = num + 1
		self.price = self.price + tonumber(v.sell_price)
	end
	
	ccui.Helper:seekWidgetByName(root, "Text_1"):setString(_string_piece_info[25]..num.._string_piece_info[26]..",".."\r\n".._string_piece_info[27]..self.price.._string_piece_info[28])
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, {func_string = [[state_machine.excute("equip_sell_tip_two_to_sell", 0, "click equip_sell_tip_two_to_sell.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, {func_string = [[state_machine.excute("equip_sell_tip_two_to_return", 0, "click equip_sell_tip_two_to_return.'")]], 
									isPressedActionEnabled = true}, nil, 1)
end


function EquipSellTipTwo:onExit()
	state_machine.remove("equip_sell_tip_two_to_return")
	state_machine.remove("equip_sell_tip_two_to_sell")

end

function EquipSellTipTwo:init(equip)
	self.equip = equip
end