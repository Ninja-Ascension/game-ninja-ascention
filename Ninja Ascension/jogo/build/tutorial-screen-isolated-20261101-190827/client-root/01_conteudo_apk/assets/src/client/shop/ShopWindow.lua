-- ----------------------------------------------------------------------------------------------------
-- 说明：商城主界面
-- 创建时间
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ShopWindow = class("ShopWindowClass", Window)

function ShopWindow:ctor()
    self.super:ctor()
	
	self.roots = {}
	
    app.load("client.shop.ShopUserInformation")
	app.load("client.shop.ShopRecruitList")
	
	-- Initialize shop_window page state machine.
    local function init_shop_window_terminal()
	
		local shop_window_chick_tavern_terminal = {
            _name = "shop_window_chick_tavern_zhaoxian",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:open(ShopRecruitList:new(), fwin._view)	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(shop_window_chick_tavern_terminal)
	
        -- state_machine.init()
    end
    
    -- call func init hom state machine.
    init_shop_window_terminal()
end

--UI的显示
function ShopWindow:ShowUI()
	local csbShopWindow = csb.createNode("shop/shop_1.csb")
	local csbShopWindow_root = csbShopWindow:getChildByName("root")
	table.insert(self.roots, csbShopWindow_root)
    self:addChild(csbShopWindow)
	
	fwin:open(ShopUserInformation:new(), fwin._view)
end

function ShopWindow:onEnterTransitionFinish()
	-- [[-------------------------------------
	-- add button for shop window
	self:ShowUI()
	state_machine.excute("shop_window_chick_tavern_zhaoxian", 0, "zhaoxian.'")
end

function ShopWindow:onExit()
	state_machine.remove("shop_window_chick_tavern_zhaoxian")

end
