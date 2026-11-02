
-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的时装界面
-- 创建时间
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

Fashion = class("FashionClass", Window)
    
function Fashion:ctor()
    self.super:ctor()
    
    -- Initialize Fashion state machine.
    local function init_Fashion_terminal()
	
		--装备查看按钮
		local Fashion_chick_imageview_terminal = {
            _name = "Fashion_chick_imageview",
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

		state_machine.add(Fashion_chick_imageview_terminal)	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_Fashion_terminal()
end

function Fashion:onEnterTransitionFinish()

    local csbFashion = csb.createNode("Chat/chat.csb")
    self:addChild(csbFashion)

	
	local root = csbFashion:getChildByName("root")
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1_1_0"), nil, {func_string = [[state_machine.excute("Fashion_chick_imageview", 0, "click Fashion_chick_imageview.'")]], 
									isPressedActionEnabled = true}, nil, 0)
	
	
end

function Fashion:enterGame(_terminal, _instance, _params)
    
	return true
end

function Fashion:onExit()
	state_machine.remove("Fashion_chick_imageview")


end

--return Home:new()