-- ----------------------------------------------------------------------------------------------------
-- 说明：特殊招募界面   ShopSpecialBounty  XXXXXXXXXXXXXXXXXXXXXXXXX
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：   
-------------------------------------------------------------------------------------------------------

ShopSpecialBounty = class("ShopSpecialBountyClass", Window)
    
function ShopSpecialBounty:ctor()
    self.super:ctor()
	
	self.roots = {}
	
    -- Initialize ShopSpecialBounty page state machine.
    local function init_ShopSpecialBounty_terminal()
		--返回shop主界面
		local shop_special_bounty_return_shop_page_terminal = {
            _name = "shop_special_bounty_return_shop_page",
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
		
		local RecruitiCount = 0
		local usegold = 80
		local recruit_time = 0
		local recruit_beishu = 1
		local user_gold = 1000
		
		--势力招募招一次
		local shop_special_bounty_chick_shile_recruit_one_terminal = {
            _name = "shop_special_bounty_chick_shile_recruit_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print(params)
				-- fwin:close(instance)
				RecruitiCount = RecruitiCount + 1
				-- SpecialRecruitOnce()
				
				if user_gold <= usegold then
					--> print("gold is less")
				else
					-- -- sender(3..."",,,,)
				end

				app.load("client.shop.HeroRecruitSuccess")
				fwin:open(HeroRecruitSuccess:new(), fwin._windows)				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--势力招募预览
		local hop_special_bounty_show_hero_recruit_preview_terminal = {
            _name = "hop_special_bounty_show_hero_recruit_preview",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			
				app.load("client.shop.HeroRecruitPreview")
				fwin:open(HeroRecruitPreview:new(),fwin._windows)			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(shop_special_bounty_return_shop_page_terminal)
		state_machine.add(shop_special_bounty_chick_shile_recruit_one_terminal)
		state_machine.add(hop_special_bounty_show_hero_recruit_preview_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_ShopSpecialBounty_terminal()
end



function ShopSpecialBounty:onEnterTransitionFinish()
    local csbShopSpecialBounty = csb.createNode("shop/recruit_god.csb")
    local csbShopSpecialBounty_root = csbShopSpecialBounty:getChildByName("root")
	table.insert(self.roots, csbShopSpecialBounty_root)
	self:addChild(csbShopSpecialBounty)
	
	-- -- [[-------------------------------------
	-- -- add page for shop special bounty
    -- local csbShopSpecialBounty = csb.createNode("shop/recruit_god.csb")
    -- local csbShopSpecialBounty_root = csbShopSpecialBounty:getChildByName("root")
	-- table.insert(self.roots, csbShopSpecialBounty_root)
	-- self:addChild(csbShopSpecialBounty)
	
	
	-- -- ~end map module ]]
	
	
	-- -- [[-------------------------------------
	-- -- add page for shop special bounty

	
	-- -- ~end map module ]]
	

	-- --返回shop界面
	-- local return_shop = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbShopSpecialBounty_root, "Button_33401"), nil, {func_string = [[state_machine.excute("shop_special_bounty_return_shop_page", 0, "click shop_return_show_shop.'")]]}, nil, 0)
	-- local Panel_3 = ccui.Helper:seekWidgetByName(csbShopSpecialBounty_root, "Panel_3")
	-- local zhao_one	= fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(Panel_3, "Button_33413"), nil, {func_string = [[state_machine.excute("shop_special_bounty_chick_shile_recruit_one", 0, "click shop_return_show_shop.'")]]}, nil, 0)
	-- local zhaomuyulan = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbShopSpecialBounty_root, "Button_1"), nil, {func_string = [[state_machine.excute("hop_special_bounty_show_hero_recruit_preview", 0, "click shop_return_show_shop.'")]]}, nil, 0)
	
end


function ShopSpecialBounty:onExit()

	state_machine.remove("shop_special_bounty_return_shop_page")
	state_machine.remove("shop_special_bounty_chick_shile_recruit_one")
	state_machine.remove("hop_special_bounty_show_hero_recruit_preview")

end

--return ShopSpecialBounty:new()

