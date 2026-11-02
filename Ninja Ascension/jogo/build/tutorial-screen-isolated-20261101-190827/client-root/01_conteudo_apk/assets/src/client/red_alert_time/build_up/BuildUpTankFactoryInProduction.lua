--------------------------------------------------------------------------------------------------------------
--  生成中或改造中列表
--------------------------------------------------------------------------------------------------------------
BuildUpTankFactoryInProduction = class("BuildUpTankFactoryInProductionClass", Window)

local build_up_tank_factory_in_production_window_open_terminal = {
    _name = "build_up_tank_factory_in_production_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = BuildUpTankFactoryInProduction:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_tank_factory_in_production_window_open_terminal)
state_machine.init()

function BuildUpTankFactoryInProduction:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._Image_in_production_arrow_up = nil
    self._Image_in_production_arrow_down = nil
    self._list_view = nil
    --列表初始高度
    self._list_view_poy = nil

    self._list_view_height = 0
    -- 1：坦克工厂1，2：坦克工厂2，3：改造工厂
    self._from_type = nil 

    app.load("client.red_alert_time.cells.build_up.build_up_tank_factory_in_production_cell")

    -- Initialize build_up_tank_factory_in_production state machine.
    local function init_build_up_tank_factory_in_production_terminal()
        local build_up_tank_factory_in_production_update_draw_terminal = {
            _name = "build_up_tank_factory_in_production_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    if missionIsOver() == false then
                        resetMission()
                    end
                    local posY = instance._list_view_poy
                    instance:updateDraw()
                    if math.abs(posY) > math.abs(instance._list_view_height) then
                        posY = instance._list_view_height
                    end
                    instance._list_view:getInnerContainer():setPositionY(posY)   
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local build_up_tank_factory_in_production_show_terminal = {
            _name = "build_up_tank_factory_in_production_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = params
                if page ~= nil and page.roots ~= nil and page.roots[1] ~= nil then
                    page:setVisible(true)
                    page:refreshListView()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_factory_in_production_hide_terminal = {
            _name = "build_up_tank_factory_in_production_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local page = params
                if page ~= nil and page.roots ~= nil and page.roots[1] ~= nil then
                    page:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(build_up_tank_factory_in_production_update_draw_terminal)
        state_machine.add(build_up_tank_factory_in_production_show_terminal)
        state_machine.add(build_up_tank_factory_in_production_hide_terminal)
        state_machine.init()
    end
    
    -- call func build_up_tank_factory_in_production create state machine.
    init_build_up_tank_factory_in_production_terminal()
end

function BuildUpTankFactoryInProduction:refreshListView()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
end

function BuildUpTankFactoryInProduction:updateDraw()
    local root = self.roots[1]
    local ListView_in_production = ccui.Helper:seekWidgetByName(root,"ListView_in_production")
    local Text_in_production_not = ccui.Helper:seekWidgetByName(root,"Text_in_production_not")
    Text_in_production_not:setVisible(false)
    ListView_in_production:jumpToTop()
    ListView_in_production:removeAllItems()

    local result = {}
    local ready_list = {}           -- 等待队列

    if _ED.production_info[""..(self._from_type - 1)] ~= nil then
        for k, v in pairs(_ED.production_info[""..(self._from_type - 1)]) do
            if tonumber(v.production_state) == 0 then
                table.insert(result, v)
            else
                table.insert(ready_list, v)
            end
        end

        function sortByTime(a, b)
            return a.production_start_time < b.production_start_time
        end
        table.sort(ready_list, sortByTime)
        for k, v in pairs(ready_list) do
            table.insert(result, v)
        end
        if #result <= 0 then
            Text_in_production_not:setVisible(true)
        end
        local index = 1
        for k, v in pairs(result) do
            local cell = state_machine.excute("build_up_tank_factory_in_production_cell_create", 0, {index, self._from_type, v})
            ListView_in_production:addChild(cell)
            index = index + 1
        end
    else
        Text_in_production_not:setVisible(true)
    end

    ListView_in_production:requestRefreshView()
    self._list_view = ListView_in_production
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function BuildUpTankFactoryInProduction:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_in_production_arrow_down:setVisible(true)
        else
            self._Image_in_production_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_in_production_arrow_up:setVisible(true)
        else
            self._Image_in_production_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function BuildUpTankFactoryInProduction:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_tank_factory_tab_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_in_production_arrow_up = ccui.Helper:seekWidgetByName(root,"Image_in_production_arrow_up")
    self._Image_in_production_arrow_down = ccui.Helper:seekWidgetByName(root,"Image_in_production_arrow_down")

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_in_production_arrow_down:stopAllActions()
    self._Image_in_production_arrow_up:stopAllActions()
    playActions(self._Image_in_production_arrow_down)
    playActions(self._Image_in_production_arrow_up)
    self._Image_in_production_arrow_down:setVisible(false)
    self._Image_in_production_arrow_up:setVisible(false)

    self:updateDraw()
end

function BuildUpTankFactoryInProduction:onEnterTransitionFinish()
    
end

function BuildUpTankFactoryInProduction:init(params)
    local rootWindow = params[1]
    self._from_type = params[2]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function BuildUpTankFactoryInProduction:onExit()
    state_machine.remove("build_up_tank_factory_in_production_update_draw")
    state_machine.remove("build_up_tank_factory_in_production_show")
    state_machine.remove("build_up_tank_factory_in_production_hide")
end