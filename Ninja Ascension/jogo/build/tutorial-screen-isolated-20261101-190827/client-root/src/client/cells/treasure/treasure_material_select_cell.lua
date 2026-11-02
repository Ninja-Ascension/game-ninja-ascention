---------------------------------
-- 说明：宝物强化 --材料选择选项卡
-- 创建时间:2015.03.16
-- 作者：刘迎
-- 修改记录：
-- 最后修改人：
---------------------------------

TreasureMaterialSelectCell = class("TreasureMaterialSelectCellClass", Window)

function TreasureMaterialSelectCell:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
    -- Initialize HeroSeat state machine.
    local function init_material_select_terminal()
		
		local treasure_material_select_terminal = {
            _name = "treasure_material_select",
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
		
		state_machine.add(treasure_material_select_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_material_select_terminal()
end

function TreasureMaterialSelectCell:onUpdateDraw()
	--todo
end

function TreasureMaterialSelectCell:onEnterTransitionFinish()

	--获取美术资源
    local csbTreasureMaterialSeat = csb.createNode("list/list_equipment_sui.csb")
	local root = csbTreasureMaterialSeat:getChildByName("root")
	root:removeFromParent(false)
    self:addChild(root)
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(
		ccui.Helper:seekWidgetByName(root, "Panel_6"), 
		nil, 
		{
			terminal_name = "treasure_material_select", 	
			next_terminal_name = "", 	
			but_image = "", 
			terminal_state = 0, 
			cell = self,
			isPressedActionEnabled = false,
		}, 
		nil, 
		0)
	
end


function TreasureMaterialSelectCell:onExit()
	state_machine.remove("treasure_refine_excute")
end