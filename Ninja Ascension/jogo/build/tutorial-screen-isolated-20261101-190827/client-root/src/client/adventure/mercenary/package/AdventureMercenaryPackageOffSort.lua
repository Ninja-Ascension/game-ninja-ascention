-- ----------------------------------------------------------------------------------------------------
-- 说明：武将解雇排序
-------------------------------------------------------------------------------------------------------
AdventureMercenaryPackageOffSort = class("AdventureMercenaryPackageOffSortClass", Window)
    
function AdventureMercenaryPackageOffSort:ctor()

    self.super:ctor()
    self.roots = {}
	self.showType = 0
    
    -- Initialize adventure mercenary package sort state machine.
    local function init_adventure_mercenary_package_off_sort_terminal()
        -- 按照品质
        local adventure_mercenary_package_off_by_quality_terminal = {
            _name = "adventure_mercenary_package_off_by_quality",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("AdventureMercenaryPackageOffSortClass"))
                state_machine.excute("adventure_mercenary_package_sort_off_update",0,params._datas.current_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 重置
        local adventure_mercenary_package_off_reset_terminal = {
            _name = "adventure_mercenary_package_off_reset",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("AdventureMercenaryPackageOffSortClass"))
                state_machine.excute("adventure_mercenary_package_sort_off_update",0,6)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_mercenary_package_off_by_quality_terminal)
        state_machine.add(adventure_mercenary_package_off_reset_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mercenary package sort state machine.
    init_adventure_mercenary_package_off_sort_terminal()
end

function AdventureMercenaryPackageOffSort:init(showType,sortType)
	self.showType = showType
    self.sortType = sortType
    return self
end

function AdventureMercenaryPackageOffSort:onEnterTransitionFinish()
    local csbAdventureMercenaryPackageSort = csb.createNode("packs/Mercenary/yongbing_jiegu_pingzhi.csb")
    local root = csbAdventureMercenaryPackageSort:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMercenaryPackageSort)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMercenaryPackageOffSortClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 橙将以下
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_orange"),       nil, 
    {
        terminal_name = "adventure_mercenary_package_off_by_quality",      
        terminal_state = 0, 
        current_type = 4,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --紫将
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_purple"),       nil, 
    {
        terminal_name = "adventure_mercenary_package_off_by_quality",      
        terminal_state = 0, 
        current_type = 3,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --蓝将以下
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_blue"),       nil, 
    {
        terminal_name = "adventure_mercenary_package_off_by_quality",      
        terminal_state = 0, 
        current_type = 2,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --绿将
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_green"),       nil, 
    {
        terminal_name = "adventure_mercenary_package_off_by_quality",      
        terminal_state = 0, 
        current_type = 1,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --白将
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_white"),       nil, 
    {
        terminal_name = "adventure_mercenary_package_off_by_quality",      
        terminal_state = 0, 
        current_type = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --重置
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_res"),       nil, 
    {
        terminal_name = "adventure_mercenary_package_off_reset",      
        terminal_state = 0, 
        current_type = 6,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
end

function AdventureMercenaryPackageOffSort:onExit()
    state_machine.remove("adventure_mercenary_package_off_by_quality")
    state_machine.remove("adventure_mercenary_package_off_reset")
end
