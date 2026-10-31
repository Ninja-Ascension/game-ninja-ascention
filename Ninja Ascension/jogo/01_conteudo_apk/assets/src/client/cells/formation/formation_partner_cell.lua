----------------------------------------------------------------------------------------------------
-- 说明：阵容界面中，阵容位上面的小伙伴图标的绘制及逻辑处理
-------------------------------------------------------------------------------------------------------
FormationPartnerCell = class("FormationPartnerCellClass", Window)

function FormationPartnerCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例

	-- 初始化阵容位上面的小伙伴图标的事件响应需要使用的状态机
	local function init_formation_partner_cell_terminal()
		
		-- 设计在阵容界面，点击武将小图像需要处理的逻辑
		local formation_partner_cell_change_to_partner_page_terminal = {
            _name = "formation_partner_cell_change_to_partner_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 在这里处理阵容界面，点击阵容位上面的小伙伴图标后的响应逻辑
            	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(formation_partner_cell_change_to_partner_page_terminal)	
        state_machine.init()
	end
	init_formation_partner_cell_terminal()
end

function FormationPartnerCell:onUpdateDraw()
	
end

function FormationPartnerCell:onEnterTransitionFinish()
	local filePath = "icon/box_add.csb"
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()
	
	
end

function FormationPartnerCell:onExit()
end

function FormationPartnerCell:init()
	
end

function FormationPartnerCell:createCell()
	local cell = FormationPartnerCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

