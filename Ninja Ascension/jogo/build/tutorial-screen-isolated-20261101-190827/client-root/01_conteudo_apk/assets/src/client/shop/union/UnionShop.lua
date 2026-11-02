-- ----------------------------------------------------------------------------------------------------
-- 说明：军团商店
-- 创建时间	2015-03-06
-- 作者：胡文轩
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

UnionShop = class("UnionShopClass", Window)
    
function UnionShop:ctor()
    self.super:ctor()
    
	-- app.load("client.packs.treasure.TreasureStorage")
	
    -- Initialize UnionShop page state machine.
    local function init_union_shop_terminal()
	
		local union_shop_back_terminal = {
            _name = "union_shop_back",
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
	
	
	
		state_machine.add(union_shop_back_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_union_shop_terminal()
end

function UnionShop:onEnterTransitionFinish()
	

	local csbUnionShop = csb.createNode("shop/union/UnionShop.csb")
	self:addChild(csbUnionShop)
		
	local root = csbUnionShop:getChildByName("root")
	local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1_0"), nil, {terminal_name = "union_shop_back", terminal_state = 0, 
									isPressedActionEnabled = true}, nil, 0)
	
	local Text = ccui.Helper:seekWidgetByName(root, "Text")
	Text:setString(_string_piece_info[147])
	

	
end


function UnionShop:onExit()
	
	
	state_machine.remove("union_shop_back")
end