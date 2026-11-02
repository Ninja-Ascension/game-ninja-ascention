----------------------------------------------------------------------------------------------------
-- 说明：将领魂魄兑换cell
-------------------------------------------------------------------------------------------------------
LeaderSoulCell = class("LeaderSoulCellClass", Window)
LeaderSoulCell.__size = nil

local leader_soul_create_cell_terminal = {
    _name = "leader_soul_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = LeaderSoulCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(leader_soul_create_cell_terminal)
state_machine.init()

function LeaderSoulCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
    self._info = nil

    self._is_owned = false      -- 是否已拥有

    app.load("client.red_alert_time.cells.props.props_icon_cell")
 	local function init_leader_soul_cell_terminal()
        local leader_soul_exchange_terminal = {
            _name = "leader_soul_exchange",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell._is_owned == true then
                    TipDlg.drawTextDailog(red_alert_time_str[81])
                    return
                end

                if cell._info.count < cell._info.coming_need_number then
                    TipDlg.drawTextDailog(red_alert_time_str[237])
                    return
                end

                local function responseCombiningCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("leader_team_list_update", 0, "")
                        state_machine.excute("leader_exchange_list_update", 0, "")
                        checkPlayEffect(24)
                        state_machine.excute("leader_recruit_get_synthesis_window_open", 0, "")
                        state_machine.excute("home_map_update_prodcution_state", 0, {7})
                        state_machine.excute("notification_center_update", 0, "push_notification_leader_exhange")
                    end
                end
                protocol_command.prop_compound.param_list = cell._info.user_prop_id.."\r\n1\r\n1"
                NetworkManager:register(protocol_command.prop_compound.code, nil, nil, nil, cell, responseCombiningCallback, false, nil) 
 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(leader_soul_exchange_terminal)
        state_machine.init()
    end
	init_leader_soul_cell_terminal()        	
end

function LeaderSoulCell:onUpdateDraw()
	local root = self.roots[1]
    -- icon
	local Panel_leader_icon = ccui.Helper:seekWidgetByName(root,"Panel_leader_icon")
    Panel_leader_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{1,3,self._info.prop_id,1})
    Panel_leader_icon:addChild(cell)
    -- name
    local Text_leader_name = ccui.Helper:seekWidgetByName(root,"Text_leader_name")
    Text_leader_name:setString(self._info.prop_name)
    Text_leader_name:setColor(cc.c3b(color_Type[self._info.quality+1][1],color_Type[self._info.quality+1][2],color_Type[self._info.quality+1][3]))
    -- 拥有数量
    local Text_leader_soul_n = ccui.Helper:seekWidgetByName(root,"Text_leader_soul_n")
    if self._is_owned == false then
        Text_leader_soul_n:setString(self._info.count.."/"..self._info.coming_need_number)
    else
        Text_leader_soul_n:setString(self._info.count)
    end

    local Button_leader_infor = ccui.Helper:seekWidgetByName(root,"Button_leader_infor")

    if self._is_owned == true then
        Button_leader_infor:setBright(false)
        Button_leader_infor:setTitleText(red_alert_time_str[61])
    elseif self._info.count < self._info.coming_need_number then
        Button_leader_infor:setBright(false)
        Button_leader_infor:setTitleText(red_alert_time_str[80])
    else
        Button_leader_infor:setBright(true)
        Button_leader_infor:setTitleText(red_alert_time_str[80])
    end
end

function LeaderSoulCell:onEnterTransitionFinish()

end

function LeaderSoulCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.leader.leader_soul_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if LeaderSoulCell.__size == nil then
		LeaderSoulCell.__size = root:getContentSize()
	end
    -- 兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_leader_infor"), nil, 
    {
        terminal_name = "leader_soul_exchange",
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    local ship_template_id = dms.int(dms["prop_mould"], self._info.prop_id, prop_mould.use_of_ship)     -- 兑换后将领模板id
    local ship_base_template_id = dms.int(dms["ship_mould"], ship_template_id, ship_mould.base_mould)
    local ship_info = nil
    self._is_owned = false
    for k, v in pairs(_ED.user_ship) do
        if tonumber(v.ship_base_template_id) == ship_base_template_id then
            self._is_owned = true
            ship_info = v
            break
        end
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
                local ship_template_id = dms.string(dms["prop_mould"], self._info.prop_id, prop_mould.use_of_ship)
                state_machine.excute("leader_exchange_info_window_open", 0, {ship_template_id,ship_info, 1})
            end
        end
    end
    root:addTouchEventListener(panelTouchListener)

	self:onUpdateDraw()
end

function LeaderSoulCell:onExit()
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.leader.leader_soul_cell, self.roots[1])
end

function LeaderSoulCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function LeaderSoulCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.leader.leader_soul_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function LeaderSoulCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_leader_icon = ccui.Helper:seekWidgetByName(root,"Panel_leader_icon")
    local Text_leader_name = ccui.Helper:seekWidgetByName(root,"Text_leader_name")
    local Text_leader_soul_n = ccui.Helper:seekWidgetByName(root,"Text_leader_soul_n")
    local Button_leader_infor = ccui.Helper:seekWidgetByName(root,"Button_leader_infor")

    if Panel_leader_icon ~= nil then
        Panel_leader_icon:removeAllChildren(true)
        Text_leader_name:setString("")
        Text_leader_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        Text_leader_soul_n:setString("")
        Button_leader_infor:setBright(true)
        Button_leader_infor:setTitleText(red_alert_time_str[80])
    end
end

function LeaderSoulCell:init(params)
    self._index = params[1]
    self._info = params[2]
    if self._index <= 8 then
	   self:onInit()
    end
	self:setContentSize(LeaderSoulCell.__size)
end

