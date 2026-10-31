----------------------------------------------------------------------------------------------------
-- 说明：将领技能cell
-------------------------------------------------------------------------------------------------------
LeaderInforCellOut = class("LeaderInforCellOutClass", Window)
LeaderInforCellOut.__size = nil

local leader_infor_cell_out_create_terminal = {
    _name = "leader_infor_cell_out_cretae",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = LeaderInforCellOut:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(leader_infor_cell_out_create_terminal)
state_machine.init()

function LeaderInforCellOut:ctor()
    self.super:ctor()
    self.roots = {}     

    self._index = 0
    self._telent_id = 0
    self._is_lock = false
    self._current_level = 0
    self._max_level = 0
    self._ship_info = nil

    local function init_leader_infor_cell_out_terminal()
        -- 升级
        local leader_infor_cell_out_skill_up_terminal = {
            _name = "leader_infor_cell_out_skill_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell._current_level < cell._max_level then
                    state_machine.excute("leader_skill_lv_up_window_open", 0, {cell._ship_info, cell._telent_id, cell._index, cell._max_level})
                else
                    TipDlg.drawTextDailog(red_alert_time_str[76])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(leader_infor_cell_out_skill_up_terminal)
        state_machine.init()
    end
    init_leader_infor_cell_out_terminal()          
end

function LeaderInforCellOut:onUpdateDraw()
    local root = self.roots[1]
    local Panel_skille_effice_icon = ccui.Helper:seekWidgetByName(root,"Panel_skille_effice_icon")
    local Text_skille_effice_name = ccui.Helper:seekWidgetByName(root,"Text_skille_effice_name")
    local Text_skille_effice_infor = ccui.Helper:seekWidgetByName(root,"Text_skille_effice_infor")
    local Text_skille_effice_unlock = ccui.Helper:seekWidgetByName(root,"Text_skille_effice_unlock")
    local Button_skill_up = ccui.Helper:seekWidgetByName(root,"Button_skill_up")
    Panel_skille_effice_icon:removeBackGroundImage()
    Text_skille_effice_name:setString("")
    Text_skille_effice_infor:setString("")
    Text_skille_effice_unlock:setString("")
    Button_skill_up:setVisible(false)

    local telent_pic = dms.int(dms["talent_mould"], self._telent_id, talent_mould.talent_pic)
    local telent_name = dms.string(dms["talent_mould"], self._telent_id, talent_mould.talent_name)
    local telent_des = dms.string(dms["talent_mould"], self._telent_id, talent_mould.talent_describe)
    local skill_growing = dms.float(dms["talent_mould"], self._telent_id, talent_mould.skill_growing)
    local add_attr_value = ""..(self._current_level * skill_growing)

    if self._telent_id ~= 225 
        and self._telent_id ~= 226 then
        add_attr_value = add_attr_value.."%"
    end

    Panel_skille_effice_icon:setBackGroundImage(string.format(config_res.images.ui.skills.skills, telent_pic))
    Text_skille_effice_infor:setString(string.format(telent_des, add_attr_value))

    if self._is_lock == true then
        Text_skille_effice_name:setString(telent_name .." "..string.format(red_alert_time_str[33], self._current_level))
        Text_skille_effice_unlock:setString(string.format(red_alert_time_str[65], self._index))
    else
        Text_skille_effice_name:setString(telent_name .." ".. string.format(red_alert_time_str[60], self._current_level, self._max_level))
        Button_skill_up:setVisible(true)
    end

    if self._current_level < self._max_level then
        Button_skill_up:setBright(true)
    else
        Button_skill_up:setBright(false)
    end
end

function LeaderInforCellOut:onInit()
    local root = cacher.createUIRef(config_csb.cells.leader.leader_infor_cell_out, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if LeaderInforCellOut.__size == nil then
        LeaderInforCellOut.__size = root:getContentSize()
    end

    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_skill_up"), nil, 
    {
        terminal_name = "leader_infor_cell_out_skill_up",
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    root:setTouchEnabled(true)
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
                state_machine.excute("leader_infor_cell_out_skill_up", 0, {_datas = {cell = self}})
            end
        end
    end
    root:addTouchEventListener(panelTouchListener)

    self:onUpdateDraw()
end

function LeaderInforCellOut:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.leader.leader_infor_cell_out, self.roots[1])
end

function LeaderInforCellOut:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LeaderInforCellOut:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.leader.leader_infor_cell_out, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LeaderInforCellOut:clearUIInfo()
    local root = self.roots[1]
    local Panel_skille_effice_icon = ccui.Helper:seekWidgetByName(root,"Panel_skille_effice_icon")
    local Text_skille_effice_name = ccui.Helper:seekWidgetByName(root,"Text_skille_effice_name")
    local Text_skille_effice_infor = ccui.Helper:seekWidgetByName(root,"Text_skille_effice_infor")
    local Text_skille_effice_unlock = ccui.Helper:seekWidgetByName(root,"Text_skille_effice_unlock")
    local Button_skill_up = ccui.Helper:seekWidgetByName(root,"Button_skill_up")

    if Panel_skille_effice_icon ~= nil then
        Panel_skille_effice_icon:removeBackGroundImage()
        Text_skille_effice_name:setString("")
        Text_skille_effice_infor:setString("")
        Text_skille_effice_unlock:setString("")
        Button_skill_up:setVisible(true)
    end
end

function LeaderInforCellOut:init(params)
    self._index = params[1]
    self._telent_id = params[2]
    self._is_lock = params[3]
    self._current_level = params[4]
    self._max_level = params[5]
    self._ship_info = params[6]
    -- if self._index <= 4 then
       self:onInit()
    -- end
    self:setContentSize(LeaderInforCellOut.__size)
end

