--------------------------------------------------------------------------------------------------------------
--  加入军团列表cell
--------------------------------------------------------------------------------------------------------------
LegionListCell = class("LegionListCellClass", Window)
LegionListCell.__size = nil

--创建cell
local legion_list_cell_create_terminal = {
    _name = "legion_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionListCell:new()
        local index = params[1]
        local legion_info = params[2]
        cell:init(index, legion_info)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_list_cell_create_terminal)
state_machine.init()

function LegionListCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._legion_info = nil
    
    app.load("client.red_alert_time.legion.LegionInforWindow")

    local function init_legion_list_cell_terminal()
        local legion_list_cell_click_terminal = {
            _name = "legion_list_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("legion_infor_window_open", 0, {cell._legion_info, 1})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local legion_list_cell_apply_terminal = {
            _name = "legion_list_cell_apply",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("legion_infor_window_apply_add_union", 0, {cell._legion_info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(legion_list_cell_click_terminal)
        state_machine.add(legion_list_cell_apply_terminal)
        state_machine.init()
    end
    
    init_legion_list_cell_terminal()
end


function LegionListCell:updateDraw()
    local root = self.roots[1]
    local Text_legion_fight_n = ccui.Helper:seekWidgetByName(root, "Text_legion_fight_n")
    local Text_legion_lv_n = ccui.Helper:seekWidgetByName(root, "Text_legion_lv_n")
    local Text_legion_name_n = ccui.Helper:seekWidgetByName(root, "Text_legion_name_n")
    local Text_legion_rank_n = ccui.Helper:seekWidgetByName(root, "Text_legion_rank_n")
    local Text_legion_pepole_n = ccui.Helper:seekWidgetByName(root, "Text_legion_pepole_n")
    local Panel_legion_rank_top_icon = ccui.Helper:seekWidgetByName(root, "Panel_legion_rank_top_icon")
    Panel_legion_rank_top_icon:removeBackGroundImage()

    Text_legion_fight_n:setString(exChangeNumToString(self._legion_info.union_fight))            -- 战斗力
    Text_legion_lv_n:setString(exChangeNumToString(self._legion_info.union_level))
    Text_legion_name_n:setString(self._legion_info.union_name)
    Text_legion_rank_n:setString(self._legion_info.union_rank)

    local max_member = dms.int(dms["union_lobby_param"], tonumber(self._legion_info.union_level), union_lobby_param.maxMember)
    Text_legion_pepole_n:setString(self._legion_info.union_member .. "/" .. max_member)

    if tonumber(self._legion_info.union_rank) <= 3 then
        Panel_legion_rank_top_icon:setBackGroundImage(string.format(config_res.images.ui.share.rank_icon, tonumber(self._legion_info.union_rank)))
    end

    -- 审核状态
    local Image_legion_add_pending_audit = ccui.Helper:seekWidgetByName(root, "Image_legion_add_pending_audit")
    if tonumber(self._legion_info.union_appiy) == 0 then
        Image_legion_add_pending_audit:setVisible(false)
    else
        Image_legion_add_pending_audit:setVisible(true)
    end
    local Button_legion_list_apply = ccui.Helper:seekWidgetByName(root, "Button_legion_list_apply")
    if Button_legion_list_apply ~= nil then
        if tonumber(self._legion_info.union_appiy) == 0 then
            Button_legion_list_apply:setTouchEnabled(true)
            Button_legion_list_apply:setBright(true)
        else
            Button_legion_list_apply:setTouchEnabled(false)
            Button_legion_list_apply:setBright(false)
        end
    end
end

function LegionListCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_list_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LegionListCell.__size == nil then
        LegionListCell.__size = root:getContentSize()
    end

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
                state_machine.excute("legion_list_cell_click", 0, {_datas = {cell = self}})
            end
        end
    end
    root:addTouchEventListener(panelTouchListener)

    -- 申请
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_list_apply") , nil, 
    {
        terminal_name = "legion_list_cell_apply", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    }, nil, 1) 

    -- 查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legion_list_look") , nil, 
    {
        terminal_name = "legion_list_cell_click", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    }, nil, 1) 

    self:updateDraw()
end

function LegionListCell:onEnterTransitionFinish()

end

function LegionListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_list_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionListCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_legion_rank_top_icon = ccui.Helper:seekWidgetByName(root, "Panel_legion_rank_top_icon")
    local Text_legion_fight_n = ccui.Helper:seekWidgetByName(root, "Text_legion_fight_n")
    local Text_legion_lv_n = ccui.Helper:seekWidgetByName(root, "Text_legion_lv_n")
    local Text_legion_name_n = ccui.Helper:seekWidgetByName(root, "Text_legion_name_n")
    local Text_legion_rank_n = ccui.Helper:seekWidgetByName(root, "Text_legion_rank_n")
    local Text_legion_pepole_n = ccui.Helper:seekWidgetByName(root, "Text_legion_pepole_n")
    local Image_legion_add_pending_audit = ccui.Helper:seekWidgetByName(root, "Image_legion_add_pending_audit")
    if Panel_legion_rank_top_icon ~= nil then
        Panel_legion_rank_top_icon:removeAllChildren(true)
        Panel_legion_rank_top_icon:removeBackGroundImage()
        Text_legion_fight_n:setString("")
        Text_legion_lv_n:setString("")
        Text_legion_name_n:setString("")
        Text_legion_rank_n:setString("")
        Text_legion_pepole_n:setString("")
        Image_legion_add_pending_audit:setVisible(false)
    end
end

function LegionListCell:init(index, legion_info)
    self._index = index
    self._legion_info = legion_info

    if index ~= nil and index <= 15 then
        self:onInit()
    end
    self:setContentSize(LegionListCell.__size)
    return self
end

function LegionListCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_list_cell, self.roots[1])
end

