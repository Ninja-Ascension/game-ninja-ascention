----------------------------------------------------------------------------------------------------
-- 说明：将领列表cell
-------------------------------------------------------------------------------------------------------
LeaderCell = class("LeaderCellClass", Window)
LeaderCell.__size = nil

local leader_cell_create_cell_terminal = {
    _name = "leader_cell_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = LeaderCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(leader_cell_create_cell_terminal)
state_machine.init()

function LeaderCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
    self._info = nil

 	local function init_leader_cell_terminal()
        local leader_cell_click_terminal = {
            _name = "leader_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                state_machine.excute("leader_info_window_open", 0, {cell._info.ship_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(leader_cell_click_terminal)
        state_machine.init()
    end
	init_leader_cell_terminal()        	
end

function LeaderCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_leader_icon = ccui.Helper:seekWidgetByName(root,"Panel_leader_icon")
    local Text_leader_name = ccui.Helper:seekWidgetByName(root,"Text_leader_name")
    local Text_leader_lv = ccui.Helper:seekWidgetByName(root,"Text_leader_lv")
    local Text_leader_soul_n = ccui.Helper:seekWidgetByName(root,"Text_leader_soul_n")
    local Text_leader_soul_t = ccui.Helper:seekWidgetByName(root,"Text_leader_soul_t")
    local Image_leader_battle = ccui.Helper:seekWidgetByName(root,"Image_leader_battle")
    Text_leader_soul_t:setVisible(true)
    Text_leader_soul_n:setString("")
    Image_leader_battle:setVisible(false)

    Panel_leader_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell", 0, {2, 3, self._info.ship_template_id, 3})
    Panel_leader_icon:addChild(cell)

    Text_leader_name:setString(self._info.captain_name)
    Text_leader_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[self._info.ship_type+1][1],tipStringInfo_quality_color_Type[self._info.ship_type+1][2],tipStringInfo_quality_color_Type[self._info.ship_type+1][3]))
    if tonumber(self._info.current_count)== 0 then
        Image_leader_battle:setVisible(true)
    end
    -- 等级
    local current_level = tonumber(self._info.ship_level)
    local max_level = dms.int(dms["ship_mould"], self._info.ship_template_id, ship_mould.ship_star)
    Text_leader_lv:setString(string.format(red_alert_time_str[60], current_level, max_level))

    -- 升星消耗魂数
    local required_material_id = dms.int(dms["ship_mould"], self._info.ship_template_id, ship_mould.required_material_id)
    if required_material_id > 0 then
        local prop_id = dms.int(dms["ship_grow_requirement"], required_material_id, ship_grow_requirement.need_prop1)
        local prop_max_count = dms.int(dms["ship_grow_requirement"], required_material_id, ship_grow_requirement.need_prop1_count)
        local prop_count = 0
        if fundPropWidthId(prop_id) ~= nil then 
            local token = fundPropWidthId(prop_id)
            prop_count = zstring.tonumber(token.prop_number)
        end
        Text_leader_soul_n:setString(""..prop_count.."/"..prop_max_count)
    else
        Text_leader_soul_t:setVisible(false)
    end
end

function LeaderCell:onEnterTransitionFinish()

end

function LeaderCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.leader.leader_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if LeaderCell.__size == nil then
		LeaderCell.__size = root:getContentSize()
	end
    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_leader_infor"), nil, 
    {
        terminal_name = "leader_cell_click",
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
                state_machine.excute("leader_cell_click", 0, {_datas = {cell = self}})
            end
        end
    end
    root:addTouchEventListener(panelTouchListener)

	self:onUpdateDraw()
end

function LeaderCell:onExit()
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.leader.leader_cell, self.roots[1])
end

function LeaderCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function LeaderCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.leader.leader_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function LeaderCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_leader_icon = ccui.Helper:seekWidgetByName(root,"Panel_leader_icon")
    local Text_leader_name = ccui.Helper:seekWidgetByName(root,"Text_leader_name")
    local Text_leader_lv = ccui.Helper:seekWidgetByName(root,"Text_leader_lv")
    local Text_leader_soul_n = ccui.Helper:seekWidgetByName(root,"Text_leader_soul_n")
    local Text_leader_soul_t = ccui.Helper:seekWidgetByName(root,"Text_leader_soul_t")
    local Image_leader_battle = ccui.Helper:seekWidgetByName(root,"Image_leader_battle")
    if Panel_leader_icon ~= nil then
        Panel_leader_icon:removeAllChildren(true)
        Text_leader_name:setString("")
        Text_leader_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        Text_leader_lv:setString("")
        Text_leader_soul_n:setString("")
        Text_leader_soul_t:setVisible(true)
        Image_leader_battle:setVisible(false)
    end
end

function LeaderCell:init(params)
    self._index = params[1]
    self._info = params[2]
    if self._index <= 8 then
	   self:onInit()
    end
	self:setContentSize(LeaderCell.__size)
end

