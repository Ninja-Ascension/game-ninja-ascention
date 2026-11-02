--------------------------------------------------------------------------------------------------------------
--  说明：七星台单个控件项
--------------------------------------------------------------------------------------------------------------
SevenStarCell = class("SevenStarCellClass", Window)
SevenStarCell.__size = nil

local seven_star_create_cell_terminal = {
    _name = "seven_star_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SevenStarCell:new()
        local from_type = params[1]
        local scenceID = params[2]
        local index = params[3]  
        cell:init(from_type, scenceID,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(seven_star_create_cell_terminal)
state_machine.init()

function SevenStarCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.from_type = nil 
    -- 层数
    self._index = nil
    -- 场景id
    self.scenceID = nil

    -- load lua file
    app.load("client.red_alert_time.genral_choose.seven_star.SevenStarMapUi")
    app.load("client.red_alert_time.duplicate.DuplicateMap")
    app.load("client.red_alert_time.cells.duplicate.duplicate_current_level_cell")
    
     -- Initialize seven_star_cell state machine.
    local function init_seven_star_cell_terminal()
        --进入副本地图
        local seven_star_cell_click_terminal = {
            _name = "seven_star_cell_click",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local scenceID = params._datas.cell.scenceID
                local from_type = params._datas.cell.from_type
                local npc_id = params._datas.cell.npc_id
                local index = params._datas.cell._index
                state_machine.excute("duplicate_map_window_open",0,{_datas={_scenceID = scenceID,_from_type = from_type , _npc_id = npc_id, index = index}})
                state_machine.excute("seven_star_map_ui_window_open",0,{_datas={_scenceID = scenceID,index = index}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(seven_star_cell_click_terminal)
        state_machine.init()
    end
    
    -- call func SevenStarCell create state machine.
    init_seven_star_cell_terminal()

end

function SevenStarCell:updateDraw()
    local root = self.roots[1]
    -- 旗帜
    local Panel_pic = ccui.Helper:seekWidgetByName(root,"Panel_pic")
    Panel_pic:removeAllChildren(true)
    Panel_pic:setBackGroundImage("images/ui/play/seven_star/seven_star_bg_"..self._index..".png")
    -- 进度
    local Text_progress_number = ccui.Helper:seekWidgetByName(root,"Text_progress_number")
    local npcs = zstring.split(dms.string(dms["pve_scene"], tonumber(self.scenceID), pve_scene.npcs), ",")
    local scene_state = tonumber(_ED.scene_current_state[self.scenceID])
    Text_progress_number:setString(scene_state.."/".. #npcs)
    -- 关卡开启状态
    local Panel_open = ccui.Helper:seekWidgetByName(root,"Panel_open")      -- 已开启
    local Panel_locked = ccui.Helper:seekWidgetByName(root,"Panel_locked")  -- 未开启
    local Text_remind1 = ccui.Helper:seekWidgetByName(root,"Text_remind1")  -- 尚未开启
    local Text_remind2 = ccui.Helper:seekWidgetByName(root,"Text_remind2")  -- 明日开启
    Panel_open:setVisible(false)
    Panel_locked:setVisible(false)
    Text_remind1:setVisible(false)
    Text_remind2:setVisible(false)
    -- 当前系统星期几
    local server_time = _ED.system_time + (os.time() - _ED.native_time)
    local now_day = os.date("%w",server_time)
    if tonumber(self._index) <= tonumber(now_day) then
        Panel_open:setVisible(true)
    elseif self._index == tonumber(now_day) + 1 then
        Panel_locked:setVisible(true)
        Text_remind2:setVisible(true)
    else
        Panel_locked:setVisible(true)
        Text_remind1:setVisible(true)
    end

end

function SevenStarCell:onInit() 
    local root = cacher.createUIRef(config_csb.cells.genral_choose.seven_star.seven_star_cell,"root")
    self:addChild(root)    
    table.insert(self.roots, root) 

    if SevenStarCell.__size == nil then
        local __size = root:getContentSize()
        SevenStarCell.__size = __size
    end
    -- 进入七星台地图页面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_get_in"), nil, 
    {
        terminal_name = "seven_star_cell_click", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 0)

    self:updateDraw()
end

function SevenStarCell:onEnterTransitionFinish()

end

function SevenStarCell:init(from_type,scenceID,index)
    self.from_type = from_type
    self.scenceID = scenceID
    self._index = index
    self:onInit()
    self:setContentSize(SevenStarCell.__size)
end

function SevenStarCell:onExit()
    cacher.freeRef(config_csb.cells.genral_choose.seven_star.seven_star_cell, self.roots[1])
end