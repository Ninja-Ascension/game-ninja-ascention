----------------------------------------------------------------------------------------------------
-- 敌军来袭-叛军攻击中cell
-------------------------------------------------------------------------------------------------------
RebelSoldierAttackCell = class("RebelSoldierAttackCellClass", Window)
RebelSoldierAttackCell.__size = nil

local rebel_soldier_attack_create_cell_terminal = {
    _name = "rebel_soldier_attack_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = RebelSoldierAttackCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rebel_soldier_attack_create_cell_terminal)
state_machine.init()

function RebelSoldierAttackCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
    self._info = nil
    self._ntype = 0
    self._total_time = 0

    local function init_rebel_soldier_attack_cell_terminal()
        local rebel_soldier_attack_cell_goto_terminal = {
            _name = "rebel_soldier_attack_cell_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(210) == true then
                    return
                end 
                local cell = params._datas.cell
                local _x = cell._info._x
                local _y = cell._info._y
                state_machine.excute("rebel_haunt_close")
                state_machine.excute("campaign_window_close")
                state_machine.excute("red_alert_time_chat_sent_window_close_action", 0, 0)
                state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
                state_machine.excute("adventure_mine_record_view_position", 0, {_x, _y})
                state_machine.excute("adventure_mine_update_view_position", 0, 0)
                state_machine.excute("world_input_window_close", 0, 0)
                protocol_command.world_map_arena_info_refresh.param_list = "" .. _x.."\r\n".._y
                NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, nil, nil, false, nil)
                _ED.world_map_focus = {_x, _y}
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(rebel_soldier_attack_cell_goto_terminal)
        state_machine.init()
    end
    
    init_rebel_soldier_attack_cell_terminal()
end

function RebelSoldierAttackCell:onUpdateDraw()
	local root = self.roots[1]
    local Panel_build_icon = ccui.Helper:seekWidgetByName(root, "Panel_build_icon")
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root, "Panel_tank_icon")
    local Text_rebel_name = ccui.Helper:seekWidgetByName(root, "Text_rebel_name")
    local Text_rebel_arrive_time_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_arrive_time_n")
    local Text_rebel_arrive_time_t = ccui.Helper:seekWidgetByName(root, "Text_rebel_arrive_time_t")
    local LoadingBar_rebel_arrive_bar = ccui.Helper:seekWidgetByName(root, "LoadingBar_rebel_arrive_bar")
    local Image_rebel_arrive_bar_bg = ccui.Helper:seekWidgetByName(root, "Image_rebel_arrive_bar_bg")

    local npc_id = dms.int(dms["rebel_haunt_mould"], self._info._mould_id, rebel_haunt_mould.npc_mould_id)
    local name = dms.string(dms["npc"], npc_id, npc.npc_name)
    local head_pic = zstring.split(dms.string(dms["npc"], npc_id, npc.head_pic), ",")

    Panel_build_icon:removeBackGroundImage()
    Panel_tank_icon:removeBackGroundImage()
    Panel_build_icon:setBackGroundImage(string.format(config_res.images.ui.home.home_build, head_pic[1]))
    Panel_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, head_pic[2]))
    if self._ntype == 1 then
        Panel_build_icon:setScale(0.3)
    elseif self._ntype == 2 then
        Panel_build_icon:setScale(0.36)
    else
        Panel_build_icon:setScale(0.42)
    end
    Text_rebel_name:setString(name)
    Text_rebel_name:setColor(cc.c3b(color_Type[self._ntype + 1][1], color_Type[self._ntype + 1][2], color_Type[self._ntype + 1][3]))
    
    self._total_time = getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,
            _ED.world_map.position_coordinates_y, self._info._x, self._info._y, true)

    LoadingBar_rebel_arrive_bar:setPercent(math.floor(self._info._hp * 100 / self._info._max_hp))
    Text_rebel_arrive_time_n:setString(exChangeTimeToString(self._total_time))
    if _ED.user_rebel_haunt_open_list_state < self._ntype - 1 then
        Text_rebel_arrive_time_t:setString(tipStringInfo_campaign_info[13])
        LoadingBar_rebel_arrive_bar:setVisible(false)
        Image_rebel_arrive_bar_bg:setVisible(false)
        Text_rebel_arrive_time_n:setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_1"):setVisible(false)
    else
        LoadingBar_rebel_arrive_bar:setVisible(true)
        Image_rebel_arrive_bar_bg:setVisible(true)
        Text_rebel_arrive_time_n:setVisible(true)
        Text_rebel_arrive_time_t:setString(tipStringInfo_campaign_info[37])
        ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_1"):setVisible(true)
    end
end

function RebelSoldierAttackCell:onEnterTransitionFinish()

end

function RebelSoldierAttackCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.campaign.rebel_soldier_attack_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if RebelSoldierAttackCell.__size == nil then
		RebelSoldierAttackCell.__size = root:getContentSize()
	end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_limit_dekaron_1"), nil, 
    {
        terminal_name = "rebel_soldier_attack_cell_goto", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cell = self,
    }, nil, 1)

	self:onUpdateDraw()
end

function RebelSoldierAttackCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.campaign.rebel_soldier_attack_cell, root)
end

function RebelSoldierAttackCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RebelSoldierAttackCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_build_icon = ccui.Helper:seekWidgetByName(root, "Panel_build_icon")
    local Text_rebel_name = ccui.Helper:seekWidgetByName(root, "Text_rebel_name")
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root, "Panel_tank_icon")
    local Text_rebel_arrive_time_n = ccui.Helper:seekWidgetByName(root, "Text_rebel_arrive_time_n")
    local LoadingBar_rebel_arrive_bar = ccui.Helper:seekWidgetByName(root, "LoadingBar_rebel_arrive_bar")
    if Panel_build_icon ~= nil then
        Panel_build_icon:removeBackGroundImage()
        Panel_tank_icon:removeBackGroundImage()
        Text_rebel_name:setString("")
        Text_rebel_arrive_time_n:setString("")
        LoadingBar_rebel_arrive_bar:setPercent(100)
    end
end

function RebelSoldierAttackCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.campaign.rebel_soldier_attack_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function RebelSoldierAttackCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._ntype = params[3]
    if self._index <= 6 then
        self:onInit()
    end
    if RebelSoldierAttackCell.__size ~= nil then
        self:setContentSize(RebelSoldierAttackCell.__size)
    else
        self:setContentSize(RebelSoldierCell.__size)
    end
end

