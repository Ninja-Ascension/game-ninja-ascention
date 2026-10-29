-----HeroInfomation.lua-----------------------------------------------------------------------------------------------------------
-- 碎片合成、武将信息、合击。缘分
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------


HeroInfomation = class("HeroInfomationClass", Window)
    
function HeroInfomation:ctor()
    self.super:ctor()

	
    -- Initialize HeroInfomation page state machine.
    local function init_HeroInfomation_terminal()
		--返回招募预览界面
		local hero_infomation_returen_hero_recruit_preview_page_terminal = {
            _name = "hero_infomation_returen_hero_recruit_preview_page",
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

		state_machine.add(hero_infomation_returen_hero_recruit_preview_page_terminal)


        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_HeroInfomation_terminal()
end

function HeroInfomation:onEnterTransitionFinish()

    local csbHeroInfomation = csb.createNode("shop/hero/HeroInformation.csb")
    self:addChild(csbHeroInfomation)

	
	local root = csbHeroInfomation:getChildByName("root")	
	local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {func_string = [[state_machine.excute("hero_infomation_returen_hero_recruit_preview_page", 0, "click shop_return_show_shop.'")]],isPressedActionEnabled = true}, nil, 2)
	
end


function HeroInfomation:onExit()
	
	state_machine.remove("hero_infomation_returen_hero_recruit_preview_page")


end

--return HeroInfomation:new()