-- ----------------------------------------------------------------------------------------------------
-- 说明：武将背包排序
-------------------------------------------------------------------------------------------------------
AdventureMercenaryPackageSort = class("AdventureMercenaryPackageSortClass", Window)
    
function AdventureMercenaryPackageSort:ctor()

    self.super:ctor()
    self.roots = {}
	self.showType = 0
    self.sortType = nil	--1=武将背包排序 2=武将解雇排序 3=更换佣兵界面排序 4=灵力转移的佣兵更换界面排序
    -- Initialize adventure mercenary package sort state machine.
    local function init_adventure_mercenary_package_sort_terminal()
        -- 品质排序
        local adventure_mercenary_package_sort_quality_terminal = {
            _name = "adventure_mercenary_package_sort_quality",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self.sortType == 1   then
                    fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 0
                    state_machine.excute("adventure_mercenary_package_sort_update", 0, params)
                elseif self.sortType == 2 then
                    fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 0
                    state_machine.excute("adventure_mercenary_package_sort_update_Batch", 0, params)
				elseif self.sortType == 3 then
					fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 0
					state_machine.excute("adventure_mercenary_hero_battle_sort_update", 0, params)
				elseif self.sortType == 4 then
					fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 0
					state_machine.excute("adventure_mercenary_transform_choice_sort_update", 0, params)
                end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 觉醒排序
        local adventure_mercenary_package_sort_awaken_terminal = {
            _name = "adventure_mercenary_package_sort_awaken",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self.sortType == 1   then
                    fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 1
                    state_machine.excute("adventure_mercenary_package_sort_update", 0, params)
                elseif self.sortType == 2 then
                    fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 1
                    state_machine.excute("adventure_mercenary_package_sort_update_Batch", 0, params)
				elseif self.sortType == 3 then
					fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 1
					state_machine.excute("adventure_mercenary_hero_battle_sort_update", 0, params)
                elseif self.sortType == 4 then
					fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 1
					state_machine.excute("adventure_mercenary_transform_choice_sort_update", 0, params)
                end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 战力排序
        local adventure_mercenary_package_sort_power_terminal = {
            _name = "adventure_mercenary_package_sort_power",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self.sortType == 1   then
                    fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 2
                    state_machine.excute("adventure_mercenary_package_sort_update", 0, params)
                elseif self.sortType == 2 then
                    fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 2
                    state_machine.excute("adventure_mercenary_package_sort_update_Batch", 0, params)
				elseif self.sortType == 3 then
					fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 2
					state_machine.excute("adventure_mercenary_hero_battle_sort_update", 0, params)
                elseif self.sortType == 4 then
					fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 2
					state_machine.excute("adventure_mercenary_transform_choice_sort_update", 0, params)
                end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 等级排序
        local adventure_mercenary_package_sort_level_terminal = {
            _name = "adventure_mercenary_package_sort_level",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self.sortType == 1   then
                    fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 3
                    state_machine.excute("adventure_mercenary_package_sort_update", 0, params)
                elseif self.sortType == 2 then
                    fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 3
                    state_machine.excute("adventure_mercenary_package_sort_update_Batch", 0, params)
				elseif self.sortType == 3 then
					fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 3
					state_machine.excute("adventure_mercenary_hero_battle_sort_update", 0, params)
                elseif self.sortType == 4 then
					fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))
                    params._datas._showType = 3
					state_machine.excute("adventure_mercenary_transform_choice_sort_update", 0, params)
                end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_mercenary_package_sort_quality_terminal)
        state_machine.add(adventure_mercenary_package_sort_awaken_terminal)
        state_machine.add(adventure_mercenary_package_sort_power_terminal)
        state_machine.add(adventure_mercenary_package_sort_level_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mercenary package sort state machine.
    init_adventure_mercenary_package_sort_terminal()
end

function AdventureMercenaryPackageSort:init(showType,sortType)
	self.showType = showType
    self.sortType = sortType
    return self
end

function AdventureMercenaryPackageSort:onEnterTransitionFinish()
    local csbAdventureMercenaryPackageSort = csb.createNode("packs/Mercenary/yongbing_pzpaixu.csb")
    local root = csbAdventureMercenaryPackageSort:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMercenaryPackageSort)
	if self.showType == 0 then
		ccui.Helper:seekWidgetByName(root, "Button_pingzhi"):setHighlighted(true)
	elseif self.showType == 1 then
		ccui.Helper:seekWidgetByName(root, "Button_juexing"):setHighlighted(true)
	elseif self.showType == 2 then
		ccui.Helper:seekWidgetByName(root, "Button_zhanli"):setHighlighted(true)
	elseif self.showType == 3 then
		ccui.Helper:seekWidgetByName(root, "Button_dengji"):setHighlighted(true)
	end
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMercenaryPackageSortClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 品质排序
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pingzhi"),       nil, 
    {
        terminal_name = "adventure_mercenary_package_sort_quality",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 觉醒排序
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_juexing"),       nil, 
    {
        terminal_name = "adventure_mercenary_package_sort_awaken",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 战力排序
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhanli"),       nil, 
    {
        terminal_name = "adventure_mercenary_package_sort_power",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 等级排序
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_dengji"),       nil, 
    {
        terminal_name = "adventure_mercenary_package_sort_level",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
end

function AdventureMercenaryPackageSort:onExit()
    state_machine.remove("adventure_mercenary_package_sort_quality")
    state_machine.remove("adventure_mercenary_package_sort_awaken")
    state_machine.remove("adventure_mercenary_package_sort_power")
    state_machine.remove("adventure_mercenary_package_sort_level")
end
