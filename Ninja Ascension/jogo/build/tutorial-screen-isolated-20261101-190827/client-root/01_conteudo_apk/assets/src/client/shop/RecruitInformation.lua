---  RecruitInformation
-- ----------------------------------------------------------------------------------------------------
-- 说明：势力招募招将排期界面显示
-- 创建时间
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

RecruitInformation = class("RecruitInformationClass", Window)
    
function RecruitInformation:ctor()
    self.super:ctor()
	
	self.roots = {}
    -- Initialize RecruitInformation page state machine.
    local function init_RecruitInformation_terminal()
		--返回shop主界面
		local shop_hero_page_return_show_shop_terminal = {
            _name = "shop_hero_page_return_show_shop",
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
	
		state_machine.add(shop_hero_page_return_show_shop_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_RecruitInformation_terminal()
end

function RecruitInformation:onEnterTransitionFinish()
	-- [[-------------------------------------
	-- add map for trial tower
    local csbRecruitInformation = csb.createNode("shop/zhaojiangpaiqi.csb")
	local csbRecruitInformation_root = csbRecruitInformation:getChildByName("root")
	table.insert(self.roots, csbRecruitInformation_root)
	self:addChild(csbRecruitInformation)
	
	-- ~end map module ]]


	--返回shop界面
	-- local root = csbRecruitInformation:getChildByName("root") 
	local Panel_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbRecruitInformation_root, "Panel_2"), nil, {func_string = [[state_machine.excute("shop_hero_page_return_show_shop", 0, "click shop_return_show_shop.'")]]}, nil, 0)
	local return_shop = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(csbRecruitInformation_root, "Button_01"), nil, {func_string = [[state_machine.excute("shop_hero_page_return_show_shop", 0, "click shop_return_show_shop.'")]],isPressedActionEnabled = true}, nil, 2)

end

function RecruitInformation:onExit()

	state_machine.remove("shop_hero_page_return_show_shop")
end

--return RecruitInformation:new()