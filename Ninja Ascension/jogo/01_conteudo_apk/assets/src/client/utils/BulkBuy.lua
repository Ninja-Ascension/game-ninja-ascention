-- ----------------------------------------------------------------------------------------------------
-- 说明：批量购买界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
BulkBuy = class("BulkBuyClass", Window)
    
function BulkBuy:ctor()
    self.super:ctor()
 
    -- Initialize BulkBuy state machine.
    local function init_BulkBuy_terminal()
		-- 界面关闭按钮
        local bulk_buy_return_terminal = {
            _name = "bulk_buy_return",
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
		
        state_machine.add(bulk_buy_return_terminal)
        state_machine.init()
    end
    
    -- call func init BulkBuy state machine.
    init_BulkBuy_terminal()
end

function BulkBuy:onEnterTransitionFinish()
    local csbBulkBuy = csb.createNode("utils/BulkBuy.csb")
    self:addChild(csbBulkBuy)
	
	local root = csbBulkBuy:getChildByName("root")
	
	local close_button = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {terminal_name = "bulk_buy_return", terminal_state = 1,isPressedActionEnabled = true}, nil, 2)
end

function BulkBuy:onExit()
	state_machine.remove("bulk_buy_return")
end