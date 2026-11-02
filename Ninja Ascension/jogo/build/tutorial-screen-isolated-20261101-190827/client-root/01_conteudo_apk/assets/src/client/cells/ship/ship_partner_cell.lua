----------------------------------------------------------------------------------------------------
-- 说明：武将的援军图标绘制
-------------------------------------------------------------------------------------------------------
ShipPartnerCell = class("ShipPartnerCellClass", Window)

function ShipPartnerCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例

	-- 初始化援军按钮事件响应需要使用的状态机
	local function init_ship_partner_cell_terminal()
		
		-- 设计点击援军图标需要处理的逻辑
		local ship_partner_cell_change_formation_terminal = {
            _name = "ship_partner_cell_change_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 点击援军图标后的响应逻辑
				state_machine.excute("jump_formation_partner_info", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(ship_partner_cell_change_formation_terminal)	
        state_machine.init()
	end
	init_ship_partner_cell_terminal()
end

function ShipPartnerCell:onUpdateDraw()
	local root = self.roots[1]
	self.size = root:getContentSize()
	self:setContentSize(self.size)
	root:setSwallowTouches(false)
end

function ShipPartnerCell:onEnterTransitionFinish()
end

function ShipPartnerCell:onInit()
	local csbItem = csb.createNode("formation/line_up_yuanjun.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_1"), nil, {terminal_name = "ship_partner_cell_change_formation", terminal_state = 0, _self = self}, nil, 0)
end

function ShipPartnerCell:onExit()
	state_machine.remove("ship_partner_cell_change_formation")
end

function ShipPartnerCell:init()
	self:onInit()
end

function ShipPartnerCell:createCell()
	local cell = ShipPartnerCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

