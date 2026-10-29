MapBuildInfor = class("MapBuildInforClass", Window)

local map_build_infor_window_open_terminal = {
    _name = "map_build_infor_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("MapBuildInforClass")
        if nil == _Window then
            fwin:open(MapBuildInfor:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local map_build_infor_window_close_terminal = {
    _name = "map_build_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("MapBuildInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(map_build_infor_window_open_terminal)
state_machine.add(map_build_infor_window_close_terminal)
state_machine.init()

function MapBuildInfor:ctor()
    self.super:ctor()
    self.roots = {}

	self.city_id = nil

    -- load lua file
    app.load("client.red_alert_time.cells.big_map.map_build_infor_cell")

    local function init_map_build_infor_terminal()
        local map_build_infor_update_terminal = {
            _name = "map_build_infor_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(map_build_infor_update_terminal)
        state_machine.init()
    end
    init_map_build_infor_terminal()
end

function MapBuildInfor:onUpdateDraw()
    local root = self.roots[1]
    local Text_build_name = ccui.Helper:seekWidgetByName(root, "Text_build_name")
    local ListView_rec = ccui.Helper:seekWidgetByName(root, "ListView_rec")
    ListView_rec:removeAllItems()

    for k,v in pairs(_ED.city_resource_hold_resource_infos) do
        local cell = state_machine.excute("map_build_infor_create_cell", 0, {k, v})
        ListView_rec:addChild(cell)
    end
    ListView_rec:requestRefreshView()

    local city_name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],self.city_id,warfare_map_mould.city_name)
    Text_build_name:setString(city_name)
end

function MapBuildInfor:onEnterTransitionFinish()

end

function MapBuildInfor:onInit( )
    local csbItem = csb.createNode(config_csb.big_map.map_build_infor)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "map_build_infor_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
	
	self:onUpdateDraw()
end

function MapBuildInfor:init(params)
	self.city_id = params[1]
	self:onInit()
    return self
end

function MapBuildInfor:onExit()
    state_machine.remove("map_build_infor_update")
end
