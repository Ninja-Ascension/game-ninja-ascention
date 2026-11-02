--------------------------------------------------------------------------------------------------------------
--  制造列表
--------------------------------------------------------------------------------------------------------------
BuildUpMakeFactoryProduction = class("BuildUpMakeFactoryProductionClass", Window)

local build_up_make_factory_production_window_open_terminal = {
    _name = "build_up_make_factory_production_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list_view = BuildUpMakeFactoryProduction:new():init(params)
        fwin:open(list_view)
        return list_view
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_up_make_factory_production_window_open_terminal)
state_machine.init()

function BuildUpMakeFactoryProduction:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    --列表初始高度
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_production_arrow_down = nil
    self._Image_production_arrow_up = nil

    app.load("client.red_alert_time.cells.build_up.build_up_make_factory_cell")
    local function init_build_up_make_factory_production_terminal()
        local build_up_make_factory_production_update_draw_terminal = {
            _name = "build_up_make_factory_production_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil then
                    -- local posY = instance._list_view_poy
                    -- instance:updateDraw()
                    -- if math.abs(posY) > math.abs(instance._list_view_height) then
                    --     posY = instance._list_view_height
                    -- end
                    -- instance._list_view:getInnerContainer():setPositionY(posY)

                    instance:updateAllListInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_make_factory_production_show_terminal = {
            _name = "build_up_make_factory_production_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(true)
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(build_up_make_factory_production_update_draw_terminal)
        state_machine.add(build_up_make_factory_production_show_terminal)
        state_machine.init()
    end
    init_build_up_make_factory_production_terminal()
end

function BuildUpMakeFactoryProduction:refreshListView()
    local root = self.roots[1]
    local ListView = ccui.Helper:seekWidgetByName(root,"ListView_in_production")
    ListView:jumpToTop()
    ListView:getInnerContainer():setPositionY(ListView:getInnerContainer():getPositionY() - 1)
    ListView:requestRefreshView()
end

function BuildUpMakeFactoryProduction:updateAllListInfo( ... )
    local items = self._list_view:getItems()
    for i, v in pairs(items) do
        state_machine.excute("build_up_make_factory_cell_update_info", 0, {cell = v})
    end
end

function BuildUpMakeFactoryProduction:updateDraw()
    local root = self.roots[1]
    local ListView_in_production = ccui.Helper:seekWidgetByName(root,"ListView_in_production")
    ListView_in_production:jumpToTop()
    ListView_in_production:removeAllItems()

    local info = {}
    for k,v in pairs(_ED.base_prop_make_info) do
        table.insert(info,v)
    end
    local function sortPropMakeInfo( a,b )
        return tonumber(a.id) < tonumber(b.id)  
    end
    table.sort( info, sortPropMakeInfo )

    local open_list = {}
    local lock_list = {}
    for k,v in pairs(info) do
        if tonumber(_ED.vip_grade) >= tonumber(v.need_vip_level) then
            table.insert(open_list, v)
        else
            table.insert(lock_list, v)
        end
    end

    local index = 0
    for k,v in pairs(open_list) do
        index = index + 1
        local cell = state_machine.excute("build_up_make_factory_cell_create", 0, {index, v})
        ListView_in_production:addChild(cell)
    end

    for k,v in pairs(lock_list) do
        index = index + 1
        local cell = state_machine.excute("build_up_make_factory_cell_create", 0, {index, v})
        ListView_in_production:addChild(cell)
    end

    self._list_view = ListView_in_production
    self._list_view_poy = ListView_in_production:getInnerContainer():getPositionY()
    self._list_view_height = ListView_in_production:getInnerContainer():getPositionY()
end

function BuildUpMakeFactoryProduction:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_production_arrow_down:setVisible(true)
        else
            self._Image_production_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_production_arrow_up:setVisible(true)
        else
            self._Image_production_arrow_up:setVisible(false)
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

function BuildUpMakeFactoryProduction:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_tank_factory_tab_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_production_arrow_down = ccui.Helper:seekWidgetByName(root,"Image_in_production_arrow_down")
    self._Image_production_arrow_up = ccui.Helper:seekWidgetByName(root,"Image_in_production_arrow_up")
    
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

function BuildUpMakeFactoryProduction:onEnterTransitionFinish()
    
end

function BuildUpMakeFactoryProduction:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function BuildUpMakeFactoryProduction:onExit()
   state_machine.remove("build_up_make_factory_production_update_draw")
   state_machine.remove("build_up_make_factory_production_show")
end