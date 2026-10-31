-- ----------------------------------------------------------------------------------------------------
-- 说明：灵力转移确认框
-- lc 2015-10-28
-------------------------------------------------------------------------------------------------------
AdventureMercenaryTransConfirm = class("AdventureMercenaryTransConfirmClass", Window)
    
function AdventureMercenaryTransConfirm:ctor()
    self.super:ctor()
    self.roots = {}
	self.herolist = nil
	self.servants_ship_id = nil
	self.themain_ship_id = nil
	self.consumeText = nil
	self.consumeNum = 0
    -- Initialize adventure mercenary hero explode state machine.
    local function init_adventure_mercenary_trans_confirm_terminal()
	
		local adventure_mercenary_trans_confirm_terminal = {
            _name = "adventure_mercenary_trans_confirm",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("adventure_mercenary_transform_confirm_ok",0,nil)
					end
                    fwin:close(fwin:find("AdventureMercenaryTransConfirmClass"))
				end
				protocol_command.ship_transfer.param_list = self.servants_ship_id.."\r\n"..self.themain_ship_id
				NetworkManager:register(protocol_command.ship_transfer.code, nil, nil, nil, nil, responseInitCallback, true, nil)
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_mercenary_trans_confirm_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mercenary hero explode state machine.
    init_adventure_mercenary_trans_confirm_terminal()
end

function AdventureMercenaryTransConfirm:init(servants,themain,consume)
	self.servants_ship_id = servants
	self.themain_ship_id = themain
	self.consumeNum = consume
    return self
end

function AdventureMercenaryTransConfirm:onEnterTransitionFinish()
    local csb = csb.createNode("packs/Mercenary/yongbing_lingli_queren.csb")
    local root = csb:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csb)
    local user_gold = _ED.user_info.user_gold
    local total_gold = "".. user_gold
	if zstring.tonumber( user_gold) > 1000000000 then
		total_gold = string.format("%.02f",user_gold/ 1000000000) .. string_equiprety_name[42]
	elseif zstring.tonumber(user_gold)> 1000000 then
		total_gold = string.format("%.02f",user_gold / 1000000) .. string_equiprety_name[41]
	elseif zstring.tonumber(user_gold)> 1000 then
		total_gold = string.format("%.02f",user_gold / 1000) .. string_equiprety_name[40]
	end
    self.consumeText = ccui.Helper:seekWidgetByName(root, "Text_num")
	self.consumeText:setString("" .. self.consumeNum .. "/" .. total_gold)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMercenaryTransConfirmClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close_2"), nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMercenaryTransConfirmClass"))]],    
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 确认
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_10_sure"), nil, 
    {
        terminal_name = "adventure_mercenary_trans_confirm", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)
end

function AdventureMercenaryTransConfirm:onExit()
    state_machine.remove("adventure_mercenary_trans_confirm")
end
