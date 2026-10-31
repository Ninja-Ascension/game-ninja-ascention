-- ----------------------------------------------------------------------------------------------------
-- 说明：VIP礼包
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
VipPackageSelectCell = class("VipPackageSelectCellClass", Window)
    
function VipPackageSelectCell:ctor()
    self.super:ctor()
	self.roots = {}
	
	self.vip_level = 0
	self.list_index = 0
	
    -- Initialize VipPackageSelectCell state machine.
    local function init_VipPackageSelectCell_terminal()
		--选中变红，切换页面
		local vip_package_select_touch_terminal = {
            _name = "vip_package_select_touch",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas._cell
				cell:focusOn()
				state_machine.excute("activity_vip_package_update", 0, cell.list_index)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(vip_package_select_touch_terminal)
        state_machine.init()
    end
    
    -- call func init VipPackageSelectCell state machine.
    init_VipPackageSelectCell_terminal()
end

function VipPackageSelectCell:focusOn()
	local root = self.roots[1]
	state_machine.excute("activity_vip_package_focusallOff", 0, "")
	ccui.Helper:seekWidgetByName(root, "Image_light_2"):setVisible(true)
end

function VipPackageSelectCell:focusOff()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Image_light_2"):setVisible(false)
end

function VipPackageSelectCell:onUpdateDraw()
	local root = self.roots[1]
	
	ccui.Helper:seekWidgetByName(root, "AtlasLabel_vip_91"):setString(self.vip_level)
	self:focusOff()
end

function VipPackageSelectCell:onEnterTransitionFinish()
	local csbVipPackageSelectCell = csb.createNode("activity/wonderful/vip_package_k.csb")
    local root = csbVipPackageSelectCell:getChildByName("root")
    table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	
	self:setContentSize(root:getChildByName("Panel_vip_52"):getContentSize())
	
	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_vip_52"), nil, 
		{
			terminal_name = "vip_package_select_touch", 
			terminal_state = 0, 
			_cell = self,
		},
		nil,0)
end

function VipPackageSelectCell:onExit()
	
end

function VipPackageSelectCell:init(vip_level, list_index)
	self.vip_level = tonumber(vip_level)
	self.list_index = tonumber(list_index)
end


function VipPackageSelectCell:createCell()
	local cell = VipPackageSelectCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end