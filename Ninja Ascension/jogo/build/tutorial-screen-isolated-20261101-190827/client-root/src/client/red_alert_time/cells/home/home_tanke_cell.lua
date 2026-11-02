------------------------------------
-- 主页面坦克图标
------------------------------------
HomeTankeCell = class("HomeTankeCellClass", Window)

local home_tanke_cell_create_terminal = {
    _name = "home_tanke_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local ship_id = params[1]
        local panel = params[2]
        local cell = HomeTankeCell:new()
        cell:init(ship_id, panel)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(home_tanke_cell_create_terminal)
state_machine.init()

function HomeTankeCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.ship_id = nil
    self._ship = nil

    local function init_home_tanke_cell_terminal()
        local home_tanke_cell_open_window_terminal = {
            _name = "home_tanke_cell_open_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local info = {}
                info.tank_id = cell._ship.ship_template_id
                state_machine.excute("build_up_tank_production_window_open", 0, {1, info, false, cell._ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新信息
        local home_tanke_cell_update_info_terminal = {
            _name = "home_tanke_cell_update_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                if cell ~= nil then
                    cell:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(home_tanke_cell_open_window_terminal)
        state_machine.add(home_tanke_cell_update_info_terminal)
        state_machine.init()
    end

    init_home_tanke_cell_terminal()
end

function HomeTankeCell:updateDraw()
    self._ship = _ED.user_ship[""..self.ship_id]
    local root = self.roots[1]
    local Panel_build_icon = ccui.Helper:seekWidgetByName(root,"Panel_build_icon")
    local Text_num = ccui.Helper:seekWidgetByName(root,"Text_num")
    local Image_name_bg = ccui.Helper:seekWidgetByName(root,"Image_name_bg")
    Panel_build_icon:removeBackGroundImage()
    local icon = dms.int(dms["ship_mould"], self._ship.ship_template_id, ship_mould.All_icon)
    local camp_preference = dms.int(dms["ship_mould"], self._ship.ship_template_id, ship_mould.camp_preference)
    if camp_preference == 2 then
        Panel_build_icon:setBackGroundImage(string.format(config_res.images.ui.props.home_tank, icon))
    else
        Panel_build_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, icon))
    end
    if zstring.tonumber(self._ship.current_count) > 0 then
        Text_num:setString(""..zstring.tonumber(self._ship.current_count))
        local size = Image_name_bg:getContentSize()
        local len = string.len(""..zstring.tonumber(self._ship.current_count))
        local width = len * 10 + 10
        Image_name_bg:setContentSize(cc.size(width, size.height))
        self:setVisible(true)
    else
        self:setVisible(false)
    end
end

function HomeTankeCell:onInit()
    local csbString = string.format(config_csb.cells.home.home_build_cell_n, 5)
    local csbItem = csb.createNode(csbString)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    root:setSwallowTouches(false)
    local function panelTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
            pushEffect(formatMusicFile("button", 1))
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if math.abs(__spoint.x - __epoint.x) <= 10 and math.abs(__spoint.y - __epoint.y) <= 10 then
                local function playActions( sender1 )
                    state_machine.excute("home_tanke_cell_open_window", 0, {_datas = {cell = self}})
                end
                local tinto1 = cc.TintTo:create(0.03, 255, 255, 255)
                local tinto2 = cc.TintTo:create(0.02, 100, 100, 100)
                sender:runAction(cc.Sequence:create(tinto2, tinto1, cc.CallFunc:create(playActions)))
            end
        end
    end
    root:addTouchEventListener(panelTouchListener)

    self:updateDraw()
end

function HomeTankeCell:onEnterTransitionFinish()
end

function HomeTankeCell:init(ship_id, panel)
    self.ship_id = ship_id
    self._panel_city = panel
    
    self:onInit()
end

function HomeTankeCell:onExit()

end