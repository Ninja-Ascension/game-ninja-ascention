-- ----------------------------------------------------------------------------------------------------
-- 说明：武将背包排序
-------------------------------------------------------------------------------------------------------
AdventurePokedexMercenaryPackageSort = class("AdventurePokedexMercenaryPackageSortClass", Window)
    
function AdventurePokedexMercenaryPackageSort:ctor()
    self.super:ctor()
    self.roots = {}
	self.choice = -1
    -- Initialize adventure mercenary package sort state machine.
    local function init_adventure_mercenary_package_sort_terminal()
        -- 闪金
        local adventure_mercenary_package_sort_view_type_5_terminal = {
            _name = "adventure_mercenary_package_sort_view_type_5",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.choice = 5
				fwin:close(fwin:find("AdventurePokedexMercenaryPackageSortClass"))
				params._datas._showType = 5
				state_machine.excute("adventure_mercenary_hero_handbook_sort_update", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 金色
        local adventure_mercenary_package_sort_view_type_4_terminal = {
            _name = "adventure_mercenary_package_sort_view_type_4",
            _init = function (terminal)
			
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.choice = 4
				fwin:close(fwin:find("AdventurePokedexMercenaryPackageSortClass"))
				params._datas._showType = 4
				state_machine.excute("adventure_mercenary_hero_handbook_sort_update", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 紫色
        local adventure_mercenary_package_sort_view_type_3_terminal = {
            _name = "adventure_mercenary_package_sort_view_type_3",
            _init = function (terminal)
			
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.choice = 3
				fwin:close(fwin:find("AdventurePokedexMercenaryPackageSortClass"))
				params._datas._showType = 3
				state_machine.excute("adventure_mercenary_hero_handbook_sort_update", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 蓝色
        local adventure_mercenary_package_sort_view_type_2_terminal = {
            _name = "adventure_mercenary_package_sort_view_type_2",
            _init = function (terminal)
			
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.choice = 2
				fwin:close(fwin:find("AdventurePokedexMercenaryPackageSortClass"))
				params._datas._showType = 2
				state_machine.excute("adventure_mercenary_hero_handbook_sort_update", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 绿色
        local adventure_mercenary_package_sort_view_type_1_terminal = {
            _name = "adventure_mercenary_package_sort_view_type_1",
            _init = function (terminal)
			
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.choice = 1
				fwin:close(fwin:find("AdventurePokedexMercenaryPackageSortClass"))
				params._datas._showType = 1
				state_machine.excute("adventure_mercenary_hero_handbook_sort_update", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 白色
        local adventure_mercenary_package_sort_view_type_0_terminal = {
            _name = "adventure_mercenary_package_sort_view_type_0",
            _init = function (terminal)
			
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.choice = 0
				fwin:close(fwin:find("AdventurePokedexMercenaryPackageSortClass"))
				params._datas._showType = 0
				state_machine.excute("adventure_mercenary_hero_handbook_sort_update", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 全部
        local adventure_mercenary_package_sort_view_type_all_terminal = {
            _name = "adventure_mercenary_package_sort_view_type_all",
            _init = function (terminal)
			
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.choice = -1
				fwin:close(fwin:find("AdventurePokedexMercenaryPackageSortClass"))
				params._datas._showType = -1
				state_machine.excute("adventure_mercenary_hero_handbook_sort_update", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_mercenary_package_sort_view_type_5_terminal)
        state_machine.add(adventure_mercenary_package_sort_view_type_4_terminal)
        state_machine.add(adventure_mercenary_package_sort_view_type_3_terminal)
        state_machine.add(adventure_mercenary_package_sort_view_type_2_terminal)
        state_machine.add(adventure_mercenary_package_sort_view_type_1_terminal)
        state_machine.add(adventure_mercenary_package_sort_view_type_0_terminal)
        state_machine.add(adventure_mercenary_package_sort_view_type_all_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mercenary package sort state machine.
    init_adventure_mercenary_package_sort_terminal()
end

function AdventurePokedexMercenaryPackageSort:init(type)
    self.showType = type
    return self
end

function AdventurePokedexMercenaryPackageSort:onEnterTransitionFinish()
    local csbAdventureMercenaryPackageSort = csb.createNode("packs/Mercenary/yongbing_pzpaixu_1.csb")
    local root = csbAdventureMercenaryPackageSort:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMercenaryPackageSort)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventurePokedexMercenaryPackageSortClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    local shanjinButton = ccui.Helper:seekWidgetByName(root, "Button_shanjin")
    local jinButton = ccui.Helper:seekWidgetByName(root, "Button_jin")
    local ziButton = ccui.Helper:seekWidgetByName(root, "Button_zi")
    local lanButton = ccui.Helper:seekWidgetByName(root, "Button_lan")
    local lvButton = ccui.Helper:seekWidgetByName(root, "Button_lv")
    local baiButton = ccui.Helper:seekWidgetByName(root, "Button_bai")
    local allButton = ccui.Helper:seekWidgetByName(root, "Button_all")

    allButton:setHighlighted(self.showType == -1)
    shanjinButton:setHighlighted(self.showType == 5)
    jinButton:setHighlighted(self.showType == 4)
    ziButton:setHighlighted(self.showType == 3)
    lanButton:setHighlighted(self.showType == 2)
    lvButton:setHighlighted(self.showType == 1)
    baiButton:setHighlighted(self.showType == 0)

    -- 闪金
    fwin:addTouchEventListener(shanjinButton,       nil, 
    {
        terminal_name = "adventure_mercenary_package_sort_view_type_5",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 金将
    fwin:addTouchEventListener(jinButton,       nil, 
    {
        terminal_name = "adventure_mercenary_package_sort_view_type_4",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 紫将
    fwin:addTouchEventListener(ziButton,       nil, 
    {
        terminal_name = "adventure_mercenary_package_sort_view_type_3",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 蓝将
    fwin:addTouchEventListener(lanButton,       nil, 
    {
        terminal_name = "adventure_mercenary_package_sort_view_type_2",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	 -- 绿将
    fwin:addTouchEventListener(lvButton,       nil, 
    {
        terminal_name = "adventure_mercenary_package_sort_view_type_1",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	 -- 白将
    fwin:addTouchEventListener(baiButton,       nil, 
    {
        terminal_name = "adventure_mercenary_package_sort_view_type_0",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

	-- 所有
    fwin:addTouchEventListener(allButton,       nil, 
    {
        terminal_name = "adventure_mercenary_package_sort_view_type_all",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventurePokedexMercenaryPackageSort:onExit()
    state_machine.remove("adventure_mercenary_package_sort_view_type_all")
    state_machine.remove("adventure_mercenary_package_sort_view_type_0")
    state_machine.remove("adventure_mercenary_package_sort_view_type_1")
    state_machine.remove("adventure_mercenary_package_sort_view_type_2")
    state_machine.remove("adventure_mercenary_package_sort_view_type_3")
    state_machine.remove("adventure_mercenary_package_sort_view_type_4")
    state_machine.remove("adventure_mercenary_package_sort_view_type_5")
end
