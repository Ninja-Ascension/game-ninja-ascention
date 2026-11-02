--------------------------------------------------------------------------------------------------------------
--  生产列表
--------------------------------------------------------------------------------------------------------------
BuildUpTankFactoryProduction = class("BuildUpTankFactoryProductionClass", Window)

local build_up_tank_factory_production_window_open_terminal = {
    _name = "build_up_tank_factory_production_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = BuildUpTankFactoryProduction:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_tank_factory_production_window_open_terminal)
state_machine.init()

function BuildUpTankFactoryProduction:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._Image_production_arrow_up = nil
    self._Image_production_arrow_down = nil

    self.scroll_view = nil
    --列表初始高度
    self.scroll_view_poy = nil

    self.scroll_view_height = 0

    app.load("client.red_alert_time.cells.build_up.build_up_tank_factory_tank_cell")
    -- Initialize build_up_tank_factory_production state machine.
    local function init_build_up_tank_factory_production_terminal()
        local build_up_tank_factory_production_update_draw_terminal = {
            _name = "build_up_tank_factory_production_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("build_up_tank_factory_production_upgrade_info", 0, nil)
                -- if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                --     local posY = instance.scroll_view_poy
                --     instance:updateDraw()
                --     if math.abs(posY) > math.abs(instance.scroll_view_height) then
                --         posY = instance.scroll_view_height
                --     end
                --     instance.scroll_view:getInnerContainer():setPositionY(posY)   
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local build_up_tank_factory_production_show_terminal = {
            _name = "build_up_tank_factory_production_show",
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

        local build_up_tank_factory_production_hide_terminal = {
            _name = "build_up_tank_factory_production_hide",
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

        local build_up_tank_factory_production_upgrade_info_terminal = {
            _name = "build_up_tank_factory_production_upgrade_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateListInfoByBuildUpgrade()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(build_up_tank_factory_production_update_draw_terminal)
        state_machine.add(build_up_tank_factory_production_show_terminal)
        state_machine.add(build_up_tank_factory_production_hide_terminal)
        state_machine.add(build_up_tank_factory_production_upgrade_info_terminal)
        state_machine.init()
    end
    
    -- call func build_up_tank_factory_production create state machine.
    init_build_up_tank_factory_production_terminal()
end

function BuildUpTankFactoryProduction:refreshListView()
    self.scroll_view:jumpToTop()
end

function BuildUpTankFactoryProduction:updateListInfoByBuildUpgrade( ... )
    local items = self.scroll_view:getChildren()
    for k,v in pairs(items) do
        if v ~= nil and v.onUpdateDraw ~= nil then
            v:onUpdateDraw()
        end
    end
end

function BuildUpTankFactoryProduction:updateDraw()
    local root = self.roots[1]
    local ScrollView_production = ccui.Helper:seekWidgetByName(root,"ScrollView_production")
    ScrollView_production:removeAllChildren(true)

    local width = ScrollView_production:getContentSize().width
    local height = ScrollView_production:getContentSize().height
    local temp_cell = state_machine.excute("build_up_tank_factory_tank_cell_create",0,{0})
    local size = temp_cell:getContentSize()

    local result_tank = {}
    local count = dms.count(dms["ship_mould"])
    for i = 1, 100 do
        local can_production = dms.int(dms["ship_mould"], i, ship_mould.is_general)        -- 是否可生产
        local order = dms.int(dms["ship_mould"], i, ship_mould.base_mould_priority)        -- 排序
        local tank_info = {}
        if can_production == 1 then
            tank_info.tank_id = i
            tank_info.order = order
            table.insert(result_tank, tank_info)
        end
    end

    local function sortTank(a, b)
        return a.order < b.order
    end
    table.sort(result_tank, sortTank)

    local scroll_height = 0
    local tank_count = #result_tank
    if tank_count % 4 == 0 then
        scroll_height = tank_count / 4
    else
        scroll_height = tank_count / 4 + 1
    end

    if scroll_height*size.height > height then
        height = scroll_height*size.height
    end
    ScrollView_production:getInnerContainer():setContentSize(cc.size(width,height))
    
    ScrollView_production._items = {}
    
    for i = 1, tank_count do
        local row = math.floor((i - 1) % 4)
        local col = math.floor((i - 1) / 4)
        local cell = state_machine.excute("build_up_tank_factory_tank_cell_create", 0, {i, self._from_type, result_tank[i]})
        cell:setAnchorPoint(cc.p(0,1))
        cell:setPosition(cc.p(row*(width/4),height - col*size.height))
        ScrollView_production:addChild(cell)

        table.insert(ScrollView_production._items, cell)
    end

    ScrollView_production:jumpToTop()

    self.scroll_view = ScrollView_production
    self.scroll_view_poy = ScrollView_production:getInnerContainer():getPositionY()
    self.scroll_view_height = ScrollView_production:getInnerContainer():getPositionY()
end

function BuildUpTankFactoryProduction:onUpdate(dt)
    if self.scroll_view ~= nil then
        local size = self.scroll_view:getContentSize()
        local posY = self.scroll_view:getInnerContainer():getPositionY()
        if self.scroll_view_height == 0 then
            self.scroll_view_height = posY
        end
        if self.scroll_view_poy <= -30 then
            self._Image_production_arrow_down:setVisible(true)
        else
            self._Image_production_arrow_down:setVisible(false)
        end
        if self.scroll_view_poy >= self.scroll_view_height + 30 then
            self._Image_production_arrow_up:setVisible(true)
        else
            self._Image_production_arrow_up:setVisible(false)
        end
        if self.scroll_view_poy == posY then
            return
        end
        self.scroll_view_poy = posY
    end
end

function BuildUpTankFactoryProduction:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_tank_factory_tab_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_production_arrow_up = ccui.Helper:seekWidgetByName(root,"Image_production_arrow_up")
    self._Image_production_arrow_down = ccui.Helper:seekWidgetByName(root,"Image_production_arrow_down")

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_production_arrow_down:stopAllActions()
    self._Image_production_arrow_up:stopAllActions()
    playActions(self._Image_production_arrow_down)
    playActions(self._Image_production_arrow_up)
    self._Image_production_arrow_down:setVisible(false)
    self._Image_production_arrow_up:setVisible(false)
    
    self:updateDraw()
end

function BuildUpTankFactoryProduction:onEnterTransitionFinish()
    
end

function BuildUpTankFactoryProduction:init(params)
    local rootWindow = params[1]
    self._from_type = params[2]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function BuildUpTankFactoryProduction:onExit()
    state_machine.remove("build_up_tank_factory_production_update_draw")
    state_machine.remove("build_up_tank_factory_production_show")
    state_machine.remove("build_up_tank_factory_production_hide")
    state_machine.remove("build_up_tank_factory_production_upgrade_info")
end

