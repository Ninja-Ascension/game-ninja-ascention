----------------------------------------------------------------------------------------------------
-- 说明：玩家详情建筑升级
-------------------------------------------------------------------------------------------------------
PlayerBuildUpgradeCell = class("PlayerBuildUpgradeCellClass", Window)
PlayerBuildUpgradeCell.__size = nil

local player_build_upgrade_create_cell_terminal = {
    _name = "player_build_upgrade_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PlayerBuildUpgradeCell:new()       
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(player_build_upgrade_create_cell_terminal)
state_machine.init()

function PlayerBuildUpgradeCell:ctor()
    self.super:ctor()
	self.roots = {}		

	self._index = 0
    self._build_info = nil

    self.last_time = 0

    self._Text_build_time = nil
    self._Image_loading_time_bg = nil
    self._LoadingBar_time = nil
    self._Text_build_time_ing = nil
    -- 是否可以升级
    self._can_upgrade = false

    self._free_time = 0             -- 可免费升级时间
    self._build_up_state = 0        -- 0：未升级，1：升级中，2：免费升级

    app.load("client.red_alert_time.build_up.BuildUpBbuildQuickly")
 	local function init_player_build_upgrade_cell_terminal()
        -- 升级
        local player_build_upgrade_upgrade_terminal = {
            _name = "player_build_upgrade_upgrade",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                if cell._can_upgrade == false then
                    state_machine.excute("player_build_upgrade_infor", 0, {_datas = {["cell"] = cell}})
                    return true
                end
                local current_level = zstring.tonumber(cell._build_info.level)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then                       
                        TipDlg.drawTextDailog(red_alert_all_str[279])
                        state_machine.excute("player_info_build_upgrade_update_draw", 0, nil)
                        state_machine.excute("home_map_update_build", 0, "")
                        state_machine.excute("main_window_update_userinfo", 0, nil)
                        if current_level == 0 then
                            checkPlayEffect(31)
                        else
                            checkPlayEffect(32)
                        end
                    end
                end     
                protocol_command.build_level_up.param_list = cell._build_info.base_mould_id .. "\r\n" .. "-1"
                NetworkManager:register(protocol_command.build_level_up.code, nil, nil, nil, cell, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 加速
        local player_build_upgrade_speed_terminal = {
            _name = "player_build_upgrade_speed",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                local cell = params._datas.cell
                local base_build_info = _ED.base_build_info[""..cell._build_info.build_mould_id]
                state_machine.excute("build_up_build_quickly_window_open",0,{cell._build_info.base_mould_id,base_build_info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 取消
        local player_build_upgrade_cancel_terminal = {
            _name = "player_build_upgrade_cancel",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local tip = ConfirmTip:new()
                tip:init(cell, cell.sureCancelBuild, red_alert_all_str[270])
                fwin:open(tip,fwin._windows) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 详情
        local player_build_upgrade_infor_terminal = {
            _name = "player_build_upgrade_infor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local build_id = tonumber(cell._build_info.build_mould_id)
                local base_build_info = _ED.base_build_info[""..build_id]
                if funOpenDrawTip(base_build_info.fun_open_tab_id) == true then
                    return true
                end
                if build_id == 1 then -- 司令部
                    state_machine.excute("build_up_headquarters_window_open",0,{build_id})
                elseif build_id == 3 then -- 科技中心
                    state_machine.excute("build_up_scientific_window_open",0,{build_id,base_build_info})
                elseif build_id == 8 then -- 制造工厂
                    state_machine.excute("build_up_make_factory_window_open",0,{build_id,base_build_info})
                elseif build_id == 9
                    or build_id == 10 then -- 坦克工厂
                    state_machine.excute("build_up_tank_factory_window_open",0,{build_id,base_build_info})
                elseif build_id == 11 then -- 改造工厂
                    state_machine.excute("build_up_reform_factory_window_open",0,{build_id,base_build_info})
                elseif build_id >= 13 
                    and build_id <= 24 
                    then -- 仓库、宝石、钛矿
                    state_machine.excute("build_up_res_window_open",0,{cell._build_info.base_mould_id,base_build_info})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 免费升级
        local player_build_upgrade_free_terminal = {
            _name = "player_build_upgrade_free",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell ~= nil then
                    state_machine.excute("home_map_free_build_up", 0, {cell._build_info.base_mould_id})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(player_build_upgrade_upgrade_terminal)
        state_machine.add(player_build_upgrade_speed_terminal)
        state_machine.add(player_build_upgrade_cancel_terminal)
        state_machine.add(player_build_upgrade_infor_terminal)
        state_machine.add(player_build_upgrade_free_terminal)
        state_machine.init()
    end
	init_player_build_upgrade_cell_terminal()        	
end

-- 取消建造
function PlayerBuildUpgradeCell:sureCancelBuild(sure_number)
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    if self._build_info == nil or zstring.tonumber(self._build_info.update_state) ~= 1 then
        return
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                state_machine.excute("home_map_update_build", 0, "")
                state_machine.excute("main_window_update_userinfo", 0, nil)
                state_machine.excute("player_info_build_upgrade_update_draw", 0, nil)
            end
        end
    end
    if sure_number == 0 then
        protocol_command.build_level_up_cancel.param_list = self._build_info.base_mould_id
        NetworkManager:register(protocol_command.build_level_up_cancel.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function PlayerBuildUpgradeCell:onUpdateDraw()
    self._build_info = _ED.home_build[""..self._build_info.base_mould_id]
	local root = self.roots[1]
	local Panel_icon = ccui.Helper:seekWidgetByName(root,"Panel_icon")
    local Text_build_name_lv = ccui.Helper:seekWidgetByName(root,"Text_build_name_lv")
    self._Text_build_time = ccui.Helper:seekWidgetByName(root,"Text_build_time")
    self._Image_loading_time_bg = ccui.Helper:seekWidgetByName(root,"Image_loading_time_bg")
    self._LoadingBar_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_time")
    self._LoadingBar_time:setPercent(0)
    self._Text_build_time_ing = ccui.Helper:seekWidgetByName(root,"Text_build_time_ing")
    local baseInfo = _ED.base_build_info[""..self._build_info.build_mould_id]
    Panel_icon:removeBackGroundImage()
    Panel_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, baseInfo.pic))
    Text_build_name_lv:removeAllChildren(true)
    local _richText_3 = ccui.RichText:create()
    _richText_3:ignoreContentAdaptWithSize(false) 
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, baseInfo.build_name, "fonts/simhei.ttf",24)
    _richText_3:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, " "..string.format(red_alert_all_str[13], ""..self._build_info.level), "fonts/simhei.ttf",24)
    _richText_3:pushBackElement(re2)
    _richText_3:setPosition(cc.p(Text_build_name_lv:getContentSize().width/2,Text_build_name_lv:getContentSize().height/2))
    _richText_3:setContentSize(cc.size(Text_build_name_lv:getContentSize().width,24))
    Text_build_name_lv:addChild(_richText_3)

    -- 司令部等级不足设置按钮不可点击
    local Button_up = ccui.Helper:seekWidgetByName(root,"Button_up")
    if tonumber(self._build_info.base_mould_id) ~= 1 then
        if self._build_info.level + 1 > zstring.tonumber(_ED.home_build["1"].level) 
            or self._can_upgrade == false then
            Button_up:setBright(false)
        else
            Button_up:setBright(true)
        end
    elseif self._can_upgrade == false then
        Button_up:setBright(false)
    else
        Button_up:setBright(true)
    end

    -- 可免费升级时间
    self._free_time = 60 * dms.int(dms["base_consume"], 102, tonumber(_ED.vip_grade) + 4)

    self._Text_build_time:setString("")
    local Button_up = ccui.Helper:seekWidgetByName(root,"Button_up")
    local Button_infor = ccui.Helper:seekWidgetByName(root,"Button_infor")
    local Button_quicken = ccui.Helper:seekWidgetByName(root,"Button_quicken")
    local Button_cancel = ccui.Helper:seekWidgetByName(root,"Button_cancel")
    Button_up:setVisible(false)
    Button_infor:setVisible(false)
    Button_quicken:setVisible(false)
    Button_cancel:setVisible(false)
    if zstring.tonumber(self._build_info.update_state) == 1 then
        Button_quicken:setVisible(true)
        Button_cancel:setVisible(true)
        self._Image_loading_time_bg:setVisible(true)
        self._LoadingBar_time:setVisible(true)
        self._build_up_state = 1
        local now_time = os.time()
        local max_time = self._build_info.update_time_cd
        local leave_time = max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - self._build_info.update_start_time))
        leave_time = math.min(leave_time, max_time)       
        if leave_time <= self._free_time then
            self._build_up_state = 2
        end
    else
        Button_up:setVisible(true)
        Button_infor:setVisible(true)
        self._Image_loading_time_bg:setVisible(false)
        self._LoadingBar_time:setVisible(false)
        self._Text_build_time_ing:setString("")
        local need_time = zstring.tonumber(_ED.base_build_level_info[""..self._build_info.level].need_time * _ED.base_build_info[""..self._build_info.build_mould_id].upgrade_factor)
        need_time = math.ceil(need_time / (1 + _ED.build_time_factor / 100))
        self._Text_build_time:setString(exChangeTimeToString(need_time))
        self._build_up_state = 0
    end
    self:updateButtonState()
end

function PlayerBuildUpgradeCell:updateButtonState()
    local root = self.roots[1]
    local Button_up = ccui.Helper:seekWidgetByName(root,"Button_up")
    local Button_quicken = ccui.Helper:seekWidgetByName(root,"Button_quicken")
    local Button_up_free = ccui.Helper:seekWidgetByName(root,"Button_up_free")
    if self._build_up_state == 0 then
        Button_up:setVisible(true)
        Button_up_free:setVisible(false)
        Button_quicken:setVisible(false)
    elseif self._build_up_state == 1 then
        Button_up:setVisible(false)
        Button_up_free:setVisible(false)
        Button_quicken:setVisible(true)
    elseif self._build_up_state == 2 then
        Button_up:setVisible(false)
        Button_up_free:setVisible(true)
        Button_quicken:setVisible(false)
    end
end

function PlayerBuildUpgradeCell:onUpdate( dt )
    if zstring.tonumber(self._build_info.update_state) ~= 1 then
        return
    end
    if self._Text_build_time_ing ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            if zstring.tonumber(self._build_info.update_state) == 1 then
                local max_time = self._build_info.update_time_cd
                self._LoadingBar_time:setVisible(true)
                self._Image_loading_time_bg:setVisible(true)
                local leave_time = max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - self._build_info.update_start_time))
                leave_time = math.min(leave_time, max_time)
                local persent = 0
                persent = math.ceil((max_time - leave_time) / max_time *100)
                self._LoadingBar_time:setPercent(persent)
                self._Text_build_time_ing:setString(exChangeTimeToString(leave_time))
                self._Text_build_time:setString("")
                if self._build_up_state == 1 and leave_time <= self._free_time then
                    self._build_up_state = 2
                    self:updateButtonState()
                elseif self._build_up_state == 2 and leave_time > self._free_time then
                    self._build_up_state = 1
                    self:updateButtonState()
                end 
            else
                self._LoadingBar_time:setVisible(false)
                self._Image_loading_time_bg:setVisible(false)
            end
        end
    end
end

function PlayerBuildUpgradeCell:onEnterTransitionFinish()

end

function PlayerBuildUpgradeCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.player.player_build_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if PlayerBuildUpgradeCell.__size == nil then
		PlayerBuildUpgradeCell.__size = root:getContentSize()
	end
    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_up"), nil, 
    {
        terminal_name = "player_build_upgrade_upgrade",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)

    -- 详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_infor"), nil, 
    {
        terminal_name = "player_build_upgrade_infor", 
        terminal_state = 0,
        cell = self,
        touch_black = true, 
    },
    nil,1)

    -- 详情
    root:setSwallowTouches(false)
    fwin:addTouchEventListener(root, nil,
    {
        terminal_name = "player_build_upgrade_infor", 
        terminal_state = 0,
        cell = self,
        touch_black = true, 
    },
    nil,1)

    -- 加速
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_quicken"), nil, 
    {
        terminal_name = "player_build_upgrade_speed", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95, 
        touch_black = true, 
    },
    nil,1)
    local widget = ccui.Helper:seekWidgetByName(root, "Button_quicken")
    if widget._nodeChild ~= nil then
        widget:removeChild(widget._nodeChild, true)
        widget._nodeChild = nil
        widget._istips = false
    end
    state_machine.excute("notification_center_remove_widget", 0, { _widget = widget })
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_quick_prop_push",
        _widget = widget,
        ntype = 1,
        _invoke = nil,
        _interval = 0.2,})

    -- 清除
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cancel"), nil, 
    {
        terminal_name = "player_build_upgrade_cancel", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95, 
        touch_black = true, 
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_up_free"), nil, 
    {
        terminal_name = "player_build_upgrade_free", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95, 
        touch_black = true, 
    }, nil, 1)   
	
	self:onUpdateDraw()
end

function PlayerBuildUpgradeCell:onExit()
	local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.player.player_build_cell, root)
end

function PlayerBuildUpgradeCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
    self:registerOnNoteUpdate(self, 0.5)
end

function PlayerBuildUpgradeCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.player.player_build_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function PlayerBuildUpgradeCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    local Text_build_name_lv = ccui.Helper:seekWidgetByName(root, "Text_build_name_lv")
    local LoadingBar_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_time")
    if Panel_icon ~= nil then
        Panel_icon:removeAllChildren(true)
        Text_build_name_lv:removeAllChildren(true)
        Text_build_name_lv:removeAllChildren(true)
        LoadingBar_time:setPercent(0)
        self.last_time = 0
        self._Text_build_time = nil
        self._Image_loading_time_bg = nil
        self._LoadingBar_time = nil
        self._Text_build_time_ing = nil
    end
    self:unregisterOnNoteUpdate(self)
end

function PlayerBuildUpgradeCell:init(params)
    self._index = params[1]
    self._build_info = params[2]
    self._can_upgrade = params[3]
    if self._index ~= nil and self._index <= 6 then
        self:onInit()
    end
	self:setContentSize(PlayerBuildUpgradeCell.__size)
end

