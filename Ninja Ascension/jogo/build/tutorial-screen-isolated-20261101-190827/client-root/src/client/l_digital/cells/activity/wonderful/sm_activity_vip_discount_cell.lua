--------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------
SmActivityVipDiscountCell = class("SmActivityVipDiscountCellClass", Window)
SmActivityVipDiscountCell.__size = nil

local sm_activity_vip_discount_cell_create_terminal = {
    _name = "sm_activity_vip_discount_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivityVipDiscountCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_vip_discount_cell_create_terminal)
state_machine.init()

function SmActivityVipDiscountCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._index = 0
    self._info = nil
    self._isChoose = false

    local function init_sm_activity_vip_discount_cell_terminal()
        local sm_activity_vip_discount_choose_terminal = {
            _name = "sm_activity_vip_discount_choose",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell._isChoose == true then
                    return
                end
                state_machine.excute("sm_activity_vip_discount_choose_index", 0, cell._index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_activity_vip_discount_choose_terminal)
        state_machine.init()
    end
    init_sm_activity_vip_discount_cell_terminal()
end

function SmActivityVipDiscountCell:updateChooseState(isChoose)
    self._isChoose = isChoose
    self:updateDraw()
end

function SmActivityVipDiscountCell:updateDraw()
    local root = self.roots[1]
    local AtlasLabel_vip = ccui.Helper:seekWidgetByName(root, "AtlasLabel_vip")
    local Image_light_2 = ccui.Helper:seekWidgetByName(root, "Image_light_2")
    local infos = zstring.split(self._info.activityInfo_need_day, ",")
    AtlasLabel_vip:setString(infos[1])
    if self._isChoose == true then
        Image_light_2:setVisible(true)
    else
        Image_light_2:setVisible(false)
    end
end

function SmActivityVipDiscountCell:onInit()
    local csbActivityDiscount = csb.createNode("activity/wonderful/vip_package_k.csb")
    local root = csbActivityDiscount:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    self:addChild(root)

    if SmActivityVipDiscountCell.__size == nil then
        SmActivityVipDiscountCell.__size = ccui.Helper:seekWidgetByName(root, "Panel_vip_52"):getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_vip_52"), nil, 
    {
        terminal_name = "sm_activity_vip_discount_choose", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        cell = self,
    },
    nil,0)

	self:updateDraw()
end

function SmActivityVipDiscountCell:onEnterTransitionFinish()
end

function SmActivityVipDiscountCell:init(params)
    self._index = params[1]
    self._info = params[2]
	self:onInit()
    self:setContentSize(SmActivityVipDiscountCell.__size)
    return self
end

function SmActivityVipDiscountCell:onExit()
end