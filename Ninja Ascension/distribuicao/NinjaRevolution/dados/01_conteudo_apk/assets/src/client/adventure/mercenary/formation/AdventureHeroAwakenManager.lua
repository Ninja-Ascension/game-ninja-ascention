-- ----------------------------------------------------------------------------------------------------
-- 说明：武将觉醒主界面，分觉醒、觉醒+限界突破两种模式
-------------------------------------------------------------------------------------------------------
AdventureHeroAwakenManager = class("AdventureHeroAwakenManagerClass", Window)
    
function AdventureHeroAwakenManager:ctor()
    self.super:ctor()
    self.roots = {}

    self.hero = nil
    self.mould_data = nil
    self.hero_list_cell = nil
    self.current_type = nil
    self._enum_type = {
        _OPEN_AWAKEN = 1,
        _OPEN_BREAK_THROUGH = 2
    }

    app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
    app.load("client.adventure.cells.skill.adventure_skill_icon_cell")
    app.load("client.adventure.mercenary.formation.AdventureHeroAwaken")
    app.load("client.adventure.mercenary.formation.AdventureHeroBreakthrough")

    -- Initialize adventure hero awaken manager state machine.
    local function init_adventure_hero_awaken_manager_terminal()
        local adventure_hero_awaken_manager_manager_terminal = {
            _name = "adventure_hero_awaken_manager_manager",
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

        local adventure_hero_awaken_manager_open_hero_awaken_terminal = {
            _name = "adventure_hero_awaken_manager_open_hero_awaken",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 打开觉醒界面
                fwin:open(AdventureHeroAwaken:new():init(instance.hero), fwin._windows)
                fwin:close(fwin:find("AdventureHeroBreakthroughClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭觉醒突破窗口
        local adventure_hero_awaken_manager_close_hero_awaken_terminal = {
            _name = "adventure_hero_awaken_manager_close_hero_awaken",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("AdventureHeroAwakenManagerClass"))
                fwin:close(fwin:find("AdventureHeroAwakenClass"))
                fwin:close(fwin:find("AdventureHeroBreakthroughClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local adventure_hero_awaken_manager_open_hero_breakthrough_terminal = {
            _name = "adventure_hero_awaken_manager_open_hero_breakthrough",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 打开突破界面
                fwin:open(AdventureHeroBreakthrough:new():init(instance.hero), fwin._windows)
                fwin:close(fwin:find("AdventureHeroAwakenClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新列表中的武将信息
        local adventure_hero_awaken_manager_update_hero_list_cell_terminal = {
            _name = "adventure_hero_awaken_manager_update_hero_list_cell",
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

        state_machine.add(adventure_hero_awaken_manager_manager_terminal)
        state_machine.add(adventure_hero_awaken_manager_open_hero_awaken_terminal)
        state_machine.add(adventure_hero_awaken_manager_open_hero_breakthrough_terminal)
        state_machine.add(adventure_hero_awaken_manager_update_hero_list_cell_terminal)
        state_machine.add(adventure_hero_awaken_manager_close_hero_awaken_terminal)
        state_machine.init()
    end
    
    -- call func init adventure hero awaken manager state machine.
    init_adventure_hero_awaken_manager_terminal()
end

function AdventureHeroAwakenManager:init(hero, cell,type)
    self.hero = hero
    self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
    self.breakthrough = false
    self.hero_list_cell = cell
    self.current_type = type
    return self
end

function AdventureHeroAwakenManager:getShipAwakenLv2(mouldid,baseMouldid)
    mouldid = zstring.tonumber(mouldid)
    baseMouldid = zstring.tonumber(baseMouldid)
    local theCurrentAwakenLv = dms.string(dms["ship_mould"], mouldid, ship_mould.initial_rank_level)
    local theMaxAwakenLv = dms.string(dms["ship_mould"], mouldid, ship_mould.max_rank_level)
    
    return zstring.tonumber(theCurrentAwakenLv), zstring.tonumber(theMaxAwakenLv)
end

function AdventureHeroAwakenManager:onEnterTransitionFinish()
    local csbFileName = nil
    local mode = tonumber(self.hero.captain_type)
    local advanceLevel, maxAdvanceLevel = getShipAwakenLv2(self.hero.ship_template_id, self.hero.ship_base_template_id)
    if mode == 0 or maxAdvanceLevel < 5 then
        --主角显示界限突破
        csbFileName = "duplicate/awaken_2.csb"
    else

        csbFileName = "duplicate/awaken.csb"
    end
    local csbAdventureHeroAwakenManager = csb.createNode(csbFileName)
    local root = csbAdventureHeroAwakenManager:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureHeroAwakenManager)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        terminal_name = "adventure_hero_awaken_manager_close_hero_awaken",     
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = false
    }, 
    nil, 2)

    -- 觉醒按钮
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_juexing"),       nil, 
    {
        terminal_name = "adventure_hero_awaken_manager_manager",     
        next_terminal_name = "adventure_hero_awaken_manager_open_hero_awaken",      
        current_button_name = "Button_juexing",        
        but_image = "",   
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)

    -- 突破按钮
    local Button_tupo = ccui.Helper:seekWidgetByName(root, "Button_tupo")
    if Button_tupo ~= nil then
        --界限突破
        fwin:addTouchEventListener(Button_tupo,       nil, 
        {
            terminal_name = "adventure_hero_awaken_manager_manager",     
            next_terminal_name = "adventure_hero_awaken_manager_open_hero_breakthrough",      
            current_button_name = "Button_tupo",        
            but_image = "",   
            terminal_state = 0, 
            isPressedActionEnabled = false
        }, 
        nil, 0)
    end
    if tonumber(self.current_type) == self._enum_type._OPEN_AWAKEN then 
        state_machine.excute("adventure_hero_awaken_manager_manager", 0, 
        {_datas ={
            terminal_name = "adventure_hero_awaken_manager_manager",     
            next_terminal_name = "adventure_hero_awaken_manager_open_hero_awaken",      
            current_button_name = "Button_juexing",        
            but_image = "",   
            terminal_state = 0, 
            isPressedActionEnabled = true
        }}
        )
        --显示突破
        ccui.Helper:seekWidgetByName(root, "Button_juexing"):setColor(cc.c3b(255, 255, 255))
        if Button_tupo ~= nil then
            Button_tupo:setColor(cc.c3b(130, 130, 130))
            Button_tupo:setVisible(false)
        end
    else
        state_machine.excute("adventure_hero_awaken_manager_manager", 0, 
        {_datas ={
            terminal_name = "adventure_hero_awaken_manager_manager",     
            next_terminal_name = "adventure_hero_awaken_manager_open_hero_breakthrough",      
            current_button_name = "Button_tupo",        
            but_image = "",   
            terminal_state = 0, 
            isPressedActionEnabled = true
        }}
        )
        --显示觉醒
        ccui.Helper:seekWidgetByName(root, "Button_juexing"):setColor(cc.c3b(130, 130, 130))
        ccui.Helper:seekWidgetByName(root, "Button_juexing"):setVisible(false)
         if Button_tupo ~= nil then
            Button_tupo:setColor(cc.c3b(255, 255, 255))
            Button_tupo:setVisible(true)
        end
    end
    
end

function AdventureHeroAwakenManager:onExit()
    state_machine.remove("adventure_hero_awaken_manager_manager")
    state_machine.remove("adventure_hero_awaken_manager_close_hero_awaken")
    state_machine.remove("adventure_hero_awaken_manager_open_hero_awaken")
    state_machine.remove("adventure_hero_awaken_manager_open_hero_breakthrough")
    state_machine.remove("adventure_hero_awaken_manager_update_hero_list_cell")
end
