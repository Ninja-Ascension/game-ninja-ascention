
-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的充值列表界面
-- 创建时间2015-03-03 16:51
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------


Recharge = class("RechargeClass", Window)
    
function Recharge:ctor()
    self.super:ctor()
    
    -- Initialize Recharge page state machine.
    local function init_Recharge_terminal()
		--返回商城界面
		local recharge_return_shop_terminal = {
            _name = "recharge_return_shop",
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
	
		--产看VIP特权
		local recharge_show_vip_vilegeterminal = {
            _name = "recharge_show_vip_vilege",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				--> print(params)
				fwin:close(instance)
				app.load("client.shop.money.VipPrilige")
				fwin:open(VipPrilige:new(), fwin._windows)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(recharge_return_shop_terminal)
		state_machine.add(recharge_show_vip_vilegeterminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_Recharge_terminal()
end

function Recharge:onEnterTransitionFinish()

    local csbRecharge = csb.createNode("shop/money/RechargeWindow.csb")
    self:addChild(csbRecharge)
	
	local root = csbRecharge:getChildByName("root")
	local return_shop = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {func_string = [[state_machine.excute("recharge_return_shop", 0, "click Recharge_show_generals.'")]],isPressedActionEnabled = true}, nil, 2)

	local look_vip = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1_0"), nil, {func_string = [[state_machine.excute("recharge_show_vip_vilege", 0, "click recharge_show_vip_vilege.'")]],isPressedActionEnabled = true}, nil, 0)
end


function Recharge:onExit()
	
	
	state_machine.remove("recharge_return_shop")
	state_machine.remove("recharge_show_vip_vilege")
end
