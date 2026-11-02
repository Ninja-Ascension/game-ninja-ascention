
-- ----------------------------------------------------------------------------------------------------
-- 说明：VIP权限查看界面
-- 创建时间2015-03-03 17:01
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------


VipPrilige = class("VipPriligeClass", Window)
    
function VipPrilige:ctor()
    self.super:ctor()
    
    -- Initialize VipPrilige page state machine.
    local function init_VipPrilige_terminal()
		--关掉VIP界面
		local vip_privilege_return_recharge_terminal = {
            _name = "vip_privilege_return_recharge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				--> print(params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--返回充值界面
		local vip_privilege_show_recharge_terminal = {
            _name = "vip_privilege_show_recharge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 

				fwin:close(instance)
				app.load("client.shop.money.Recharge")
				fwin:open(Recharge:new(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(vip_privilege_return_recharge_terminal)
		state_machine.add(vip_privilege_show_recharge_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_VipPrilige_terminal()
end

function VipPrilige:onEnterTransitionFinish()

    local csbVipPrilige = csb.createNode("shop/money/ShowVipPrivilege.csb")
    self:addChild(csbVipPrilige)
	
	local root = csbVipPrilige:getChildByName("root")
	local return_recharge = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1_0"), nil, {func_string = [[state_machine.excute("vip_privilege_return_recharge", 0, "click vip_privilege_return_recharge.'")]],isPressedActionEnabled = true}, nil, 2)

	local chongzhi = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {func_string = [[state_machine.excute("vip_privilege_show_recharge", 0, "click vip_privilege_show_recharge.'")]],isPressedActionEnabled = true}, nil, 0)

end


function VipPrilige:onExit()
	
	
	state_machine.remove("vip_privilege_return_recharge")
	state_machine.remove("vip_privilege_show_recharge")
end
