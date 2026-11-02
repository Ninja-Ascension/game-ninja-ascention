-- ----------------------------------------------------------------------------------------------------
-- 说明：特殊招募界面   
-- 创建时间
-- 作者：liwenjun
-- 修改记录：
-- 最后修改人：   
-------------------------------------------------------------------------------------------------------

AdventureShopSpecialBounty = class("AdventureShopSpecialBountyClass", Window)
    
function AdventureShopSpecialBounty:ctor()
    self.super:ctor()
	
	self.roots = {}
	
    -- Initialize ShopSpecialBounty page state machine.
    local function init_AdventureShopSpecialBounty_terminal()
		--返回shop主界面
		local adventure_shop_special_bounty_return_shop_page_terminal = {
            _name = "adventure_shop_special_bounty_return_shop_page",
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
		
		--单次招募
		local adventure_shop_diamonds_recruit_terminal = {
			_name = "adventure_shop_diamonds_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                protocol_command.ship_bounty.param_list = "3"
				NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, nil, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		-- 十次招募
		local adventure_shop_ten_diamonds_recruit_terminal = {
			_name = "adventure_shop_ten_diamonds_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                protocol_command.ship_batch_bounty.param_list = "3"
				NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, nil, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		state_machine.add(adventure_shop_special_bounty_return_shop_page_terminal)
		state_machine.add(adventure_shop_diamonds_recruit_terminal)
		state_machine.add(adventure_shop_ten_diamonds_recruit_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_AdventureShopSpecialBounty_terminal()
end



function AdventureShopSpecialBounty:onEnterTransitionFinish()
    local csbShopSpecialBounty = csb.createNode("shop/heroshop/heroshop_xuezhuan.csb")
    local csbShopSpecialBounty_root = csbShopSpecialBounty:getChildByName("root")
	table.insert(self.roots, csbShopSpecialBounty_root)
	self:addChild(csbShopSpecialBounty)
	
	 -- 返回
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbShopSpecialBounty_root, "Button_7"),       nil, 
    {
		terminal_name = "adventure_shop_special_bounty_return_shop_page",        
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2)
	
	-- 单次招募
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbShopSpecialBounty_root, "Button_8"),       nil, 
    {
		terminal_name = "adventure_shop_diamonds_recruit",        
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2)
end


function AdventureShopSpecialBounty:onExit()

end


