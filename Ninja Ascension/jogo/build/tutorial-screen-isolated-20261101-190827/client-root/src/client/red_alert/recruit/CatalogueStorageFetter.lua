-- ----------------------------------------------------------------------------------------------------
-- 说明将星录天赋
-------------------------------------------------------------------------------------------------------
CatalogueStorageFetter = class("CatalogueStorageFetterClass", Window)

--打开将星录
local catalogue_storage_fetter_window_open_terminal = {
    _name = "catalogue_storage_fetter_window_open",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)

        if nil == fwin:find("CatalogueStorageFetterClass") then
            local ship_mould_id = params._datas.cell._ship_mould_id
            fwin:open(CatalogueStorageFetter:new():init(ship_mould_id), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local catalogue_storage_fetter_window_close_terminal = {
    _name = "catalogue_storage_fetter_window_close",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CatalogueStorageFetterClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(catalogue_storage_fetter_window_open_terminal)
state_machine.add(catalogue_storage_fetter_window_close_terminal)
state_machine.init()
function CatalogueStorageFetter:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    self.panel_fetter = nil
    self._ship_mould_id = nil
    --LOAD LUA FILE
    app.load("client.red_alert.recruit.CatalogueStorageFetterPanel")
end

function CatalogueStorageFetter:onEnterTransitionFinish()


end


function CatalogueStorageFetter:onUpdateDraw()
    state_machine.excute("catalogue_storage_fetter_panel_window_open",0,{self.panel_fetter,self._ship_mould_id})

end


function CatalogueStorageFetter:onInit()
    local csbItem = csb.createNode(config_csb.recruit.catalogue_storage_fetter)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)


    local Panel_fetter = ccui.Helper:seekWidgetByName(root,"Panel_fetter")
    self.panel_fetter = Panel_fetter

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "catalogue_storage_fetter_window_close",        
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    self:onUpdateDraw()
end

function CatalogueStorageFetter:init(ship_mould_id)
    self._ship_mould_id = ship_mould_id
    self:onInit()
    return self
end

function CatalogueStorageFetter:onExit()
end