-- ----------------------------------------------------------------------------------------------------
-- 说明：武具、宝具强化的管理页面
-------------------------------------------------------------------------------------------------------
AdventureStrengthenManager = class("AdventureStrengthenManagerClass", Window)
    
function AdventureStrengthenManager:ctor()
    self.super:ctor()
    self.roots = {}

    self.hero = nil
    self.hero_list_cell = nil
    --  刷新强化显示数据的状态机的名字
    self.refreshStongName = nil

    app.load("client.adventure.mercenary.formation.AdventureEquipmentStrengthen")
    app.load("client.adventure.mercenary.formation.AdventureTreasureStrengthen")

    -- Initialize adventure strengthen manager state machine.
    local function init_adventure_strengthen_manager_terminal()
        local adventure_strengthen_manager_manager_terminal = {
            _name = "adventure_strengthen_manager_manager",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- set select ui button is highlighted
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setColor(cc.c3b(130, 130, 130))
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setColor(cc.c3b(255, 255, 255))
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end

                if terminal.last_terminal_name ~= params._datas.next_terminal_name and params._datas.next_terminal_name ~= params._datas.terminal_name then
                    local but_bgImage = nil
                    if terminal.page_name ~= nil then
                        but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                        if but_bgImage ~= nil then
                            but_bgImage:setVisible(false)
                        end
                    end
                    terminal.page_name = params._datas.but_image
                    but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                    if but_bgImage ~= nil then
                        but_bgImage:setVisible(false)
                    end

                    terminal.last_terminal_name = params._datas.next_terminal_name
                    state_machine.excute(params._datas.next_terminal_name, 0, params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_strengthen_manager_open_equipment_strengthen_terminal = {
            _name = "adventure_strengthen_manager_open_equipment_strengthen",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 武具强化
                local strengthen_manager = fwin:find("AdventureStrengthenManagerClass")
                if strengthen_manager ~= nil then
                    fwin:open(AdventureEquipmentStrengthen:new():init(self.hero,strengthen_manager.refreshStongName), fwin._windows)
                end
                fwin:close(fwin:find("AdventureTreasureStrengthenClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_strengthen_manager_open_treasure_strengthen_terminal = {
            _name = "adventure_strengthen_manager_open_treasure_strengthen",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 宝具强化
                fwin:open(AdventureTreasureStrengthen:new():init(self.hero), fwin._windows)
                fwin:close(fwin:find("AdventureEquipmentStrengthenClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新列表中的武将信息
        local adventure_strengthen_manager_update_hero_list_cell_terminal = {
            _name = "adventure_strengthen_manager_update_hero_list_cell",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.hero_list_cell ~= nil then
                    instance.hero_list_cell:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_strengthen_manager_manager_terminal)
        state_machine.add(adventure_strengthen_manager_open_equipment_strengthen_terminal)
        state_machine.add(adventure_strengthen_manager_open_treasure_strengthen_terminal)
        state_machine.add(adventure_strengthen_manager_update_hero_list_cell_terminal)
        state_machine.init()
    end
    
    -- call func init adventure strengthen manager state machine.
    init_adventure_strengthen_manager_terminal()
end

function AdventureStrengthenManager:init(hero, cell,refreshStongName)
    self.hero = hero
    self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
    self.hero_list_cell = cell
    self.refreshStongName = refreshStongName
    return self
end

function AdventureStrengthenManager:onEnterTransitionFinish()
    local mode = 0
    if dms.atoi(self.mould_data, ship_mould.treasureSkill) ~= -1 then
        mode = 1
    end
    local csbFileName = nil
    if mode == 0 then
        csbFileName = "duplicate/weapon_strengthen_1.csb"
    else
        csbFileName = "duplicate/wuqi_strengthen.csb"
    end
    local csbAdventureStrengthenManager = csb.createNode(csbFileName)
    local root = csbAdventureStrengthenManager:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureStrengthenManager)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[
            fwin:close(fwin:find("AdventureStrengthenManagerClass"))
            fwin:close(fwin:find("AdventureEquipmentStrengthenClass"))
            fwin:close(fwin:find("AdventureTreasureStrengthenClass"))
        ]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 武具强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tab_qianghua"),       nil, 
    {
        terminal_name = "adventure_strengthen_manager_manager",     
        next_terminal_name = "adventure_strengthen_manager_open_equipment_strengthen",      
        current_button_name = "Button_tab_qianghua",        
        but_image = "",   
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)

    -- 宝具强化
    local Button_tab_baoju = ccui.Helper:seekWidgetByName(root, "Button_tab_baoju")
    if Button_tab_baoju ~= nil then
        fwin:addTouchEventListener(Button_tab_baoju,       nil, 
        {
            terminal_name = "adventure_strengthen_manager_manager",     
            next_terminal_name = "adventure_strengthen_manager_open_treasure_strengthen",      
            current_button_name = "Button_tab_baoju",        
            but_image = "",   
            terminal_state = 0, 
            isPressedActionEnabled = false
        }, 
        nil, 0):setColor(cc.c3b(130, 130, 130))
    end
    
    state_machine.excute("adventure_strengthen_manager_manager", 0, 
        {_datas = {
            terminal_name = "adventure_strengthen_manager_manager",     
            next_terminal_name = "adventure_strengthen_manager_open_equipment_strengthen",      
            current_button_name = "Button_tab_qianghua",        
            but_image = "",   
            terminal_state = 0, 
            isPressedActionEnabled = false
        }}
    )
end

function AdventureStrengthenManager:onExit()
    state_machine.remove("adventure_strengthen_manager_manager")
    state_machine.remove("adventure_strengthen_manager_open_equipment_strengthen")
    state_machine.remove("adventure_strengthen_manager_open_treasure_strengthen")
    state_machine.remove("adventure_strengthen_manager_update_hero_list_cell")
end
