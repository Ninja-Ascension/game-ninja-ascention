--------------------------------------------------------------------------------------------------------------
--  制造中列表
--------------------------------------------------------------------------------------------------------------
BuildUpMakeFactoryIngProduction = class("BuildUpMakeFactoryIngProductionClass", Window)

local build_up_make_factory_ing_production_window_open_terminal = {
    _name = "build_up_make_factory_ing_production_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = BuildUpMakeFactoryIngProduction:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_make_factory_ing_production_window_open_terminal)
state_machine.init()

function BuildUpMakeFactoryIngProduction:ctor()
    self.super:ctor()
    self.roots = {}

    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0
    self._Image_in_production_arrow_down = nil
    self._Image_in_production_arrow_up = nil

    app.load("client.red_alert_time.cells.build_up.build_up_make_factory_ing_cell")
    local function init_build_up_make_factory_ing_production_terminal()
        local build_up_make_factory_ing_production_update_draw_terminal = {
            _name = "build_up_make_factory_ing_production_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local posY = instance.listview_poy
                instance:updateDraw()
                if math.abs(posY) > math.abs(instance.listview_height) then
                    posY = instance.listview_height
                end
                instance.listview:getInnerContainer():setPositionY(posY)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(build_up_make_factory_ing_production_update_draw_terminal)
        state_machine.init()
    end
    init_build_up_make_factory_ing_production_terminal()
end

function BuildUpMakeFactoryIngProduction:updateDraw()
    local root = self.roots[1]
    local ListView_in_production = ccui.Helper:seekWidgetByName(root,"ListView_in_production")
    local Text_in_production_not = ccui.Helper:seekWidgetByName(root,"Text_in_production_not")
    Text_in_production_not:setVisible(false)
    Text_in_production_not:setString(tipStringInfo_build_up_info[29])
    ListView_in_production:jumpToTop()
    ListView_in_production:removeAllItems()
    local result = {}
    local ready_list = {}
    if _ED.production_info["3"] ~= nil then
        for k, v in pairs(_ED.production_info["3"]) do
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
            local cell = state_machine.excute("build_up_make_factory_ing_cell_create", 0, {index, v})
            ListView_in_production:addChild(cell)
            index = index + 1
        end
    else
        Text_in_production_not:setVisible(true)
    end
    
    ListView_in_production:requestRefreshView()

    self.listview = ListView_in_production
    self.listview_poy = ListView_in_production:getInnerContainer():getPositionY()
    self.listview_height = ListView_in_production:getInnerContainer():getPositionY()
end

function BuildUpMakeFactoryIngProduction:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_in_production_arrow_down:setVisible(true)
        else
            self._Image_in_production_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_in_production_arrow_up:setVisible(true)
        else
            self._Image_in_production_arrow_up:setVisible(false)
        end
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
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

function BuildUpMakeFactoryIngProduction:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_tank_factory_tab_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_in_production_arrow_down = ccui.Helper:seekWidgetByName(root,"Image_in_production_arrow_down")
    self._Image_in_production_arrow_up = ccui.Helper:seekWidgetByName(root,"Image_in_production_arrow_up")
    
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

function BuildUpMakeFactoryIngProduction:onEnterTransitionFinish()
    
end

function BuildUpMakeFactoryIngProduction:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function BuildUpMakeFactoryIngProduction:onExit()
    state_machine.remove("build_up_make_factory_ing_production_update_draw")
end