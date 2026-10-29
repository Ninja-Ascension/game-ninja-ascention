---------------------------------
---说明：玩家背包无宝物时，显示去寻宝的引导界面
-- 创建时间:2015.03.16
-- 作者：刘迎
-- 修改记录：
-- 最后修改人：
---------------------------------

TreasureHelpCell = class("TreasureHelpCellClass", Window)
   
function TreasureHelpCell:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
    -- Initialize HeroSeat state machine.
    local function init_treasure_help_terminal()
	
		--无宝物时，面板上面的去夺宝
		local treasure_help_terminal = {
            _name = "treasure_help",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--todo
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(treasure_help_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_treasure_help_terminal()
end


function TreasureHelpCell:onEnterTransitionFinish()

	--获取美术资源
    local csbXXXXXXX = csb.createNode("*")
	local root = csbXXXXXXX:getChildByName("root")
	root:removeFromParent(false)
    self:addChild(root)
	table.insert(self.roots, root)
	
	--去寻宝
	local treasure_hold_button = ccui.Helper:seekWidgetByName(root, "Button_XXXXXXXXX")
	fwin:addTouchEventListener(treasure_hold_button, nil, 
	{
		terminal_name = "treasure_help", 
		next_terminal_name = "", 
		but_image = "", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
end


function TreasureHelpCell:onExit()
	state_machine.remove("treasure_help")
end