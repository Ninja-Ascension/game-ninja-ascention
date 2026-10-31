----------------------------------------------------------------------------------------------------
-- 说明：副本增益cell
-------------------------------------------------------------------------------------------------------
pveGainCell = class("pveGainCellClass", Window)
pveGainCell.__size = nil

local pve_gain_cell_terminal = {
    _name = "pve_gain_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = pveGainCell:new()
        cell:init(params[1],params[2],params[3])
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_gain_cell_terminal)
state_machine.init()

function pveGainCell:ctor()
    self.super:ctor()
	self.roots = {}		
	self.mould_id = 0
	self._have_lv = 0
 	local function init_pve_gain_cell_terminal()
        local pve_gain_cell_choose_terminal = {
            _name = "pve_gain_cell_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if not cell.can_click then
                    return true
                end
                if __lua_project_id == __lua_project_pacific_rim then
                    state_machine.excute("pve_troops_attribute_ex_window_open", 0, {cell.mould_id})
                else
                    state_machine.excute("pve_troops_attribute_window_open", 0, {cell.mould_id,cell._have_lv})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_gain_cell_update_info_terminal = {
            _name = "pve_gain_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params.cell
                cell:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(pve_gain_cell_choose_terminal)
        state_machine.add(pve_gain_cell_update_info_terminal)
        state_machine.init()
    end
	init_pve_gain_cell_terminal()        	
end

function pveGainCell:onUpdateDraw()
	local root = self.roots[1]
	local talent = dms.string(dms["pve_buff"], self.mould_id, pve_buff.condition)
	local talent_info = zstring.split(talent, ",")
	local lv = 0
	for i, v in pairs(_ED.factor_permanent) do
		for j=1, #talent_info do
			if tonumber(v.mould_id) == tonumber(talent_info[j]) then
				if tonumber(v.factor_cd_time) == -1 and j > lv then
					lv = j
				end
			end
		end
	end
	self._have_lv = lv
	local buff_data = dms.string(dms["pve_buff"], self.mould_id, pve_buff.icon_info)
	local buff_info = zstring.split(buff_data, ",")
	--框
	local Panel_quality_icon = ccui.Helper:seekWidgetByName(root,"Panel_quality_icon")
	Panel_quality_icon:removeAllChildren(true)
	local quality_icon = cc.Sprite:create(string.format(config_res.images.ui.icon.icon, buff_info[2]))
	quality_icon:setPosition(cc.p(Panel_quality_icon:getContentSize().width/2,Panel_quality_icon:getContentSize().height/2))
	Panel_quality_icon:addChild(quality_icon)
	
	--图
	local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon") 
	Panel_props_icon:removeAllChildren(true)
	local props_icon = cc.Sprite:create(string.format(config_res.images.ui.props.props, buff_info[1]))
	props_icon:setPosition(cc.p(Panel_props_icon:getContentSize().width/2,Panel_props_icon:getContentSize().height/2))
	Panel_props_icon:addChild(props_icon)
	--等级
	local Text_props_res_lv = ccui.Helper:seekWidgetByName(root,"Text_props_res_lv")
	if lv == 0 then
		display:gray(quality_icon)
		display:gray(props_icon)
		Text_props_res_lv:setString(string.format(red_alert_all_str[117],1))
	else
		Text_props_res_lv:setString(string.format(red_alert_all_str[117],lv))
		display:ungray(quality_icon)
		display:ungray(props_icon)
	end
    if self.lv < 0 then
        Text_props_res_lv:setString("")
    end
end

function pveGainCell:onEnterTransitionFinish()

end

function pveGainCell:onInit()
	local root = cacher.createUIRef(string.format(config_csb.cells.props.props_res_icon, 3), "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if pveGainCell.__size == nil then
		pveGainCell.__size = root:getContentSize()
	end

    -- 使用
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_icon")
    Panel_props_icon:setTouchEnabled(true)
    Panel_props_icon:setSwallowTouches(false)
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
                state_machine.excute("pve_gain_cell_choose", 0, {_datas = {cell = self}})
            end
        end
    end
    Panel_props_icon:addTouchEventListener(panelTouchListener)
	
	self:onUpdateDraw()
end

function pveGainCell:onExit()
	cacher.freeRef(string.format(config_csb.cells.props.props_res_icon, 3), self.roots[1])
end

function pveGainCell:reload()

end

function pveGainCell:unload()

end

function pveGainCell:init(id,lv,can_click)
	self.mould_id = zstring.tonumber(id)
	self.lv = zstring.tonumber(lv)
    self.can_click = can_click
    self:onInit()
	self:setContentSize(pveGainCell.__size)
end

