-- ------------------------------------------------------------------------------------------------------------
--  说明：司令部
-- ------------------------------------------------------------------------------------------------------------
BuildUpHeadquarters = class("BuildUpHeadquartersClass", Window)

--打开界面
local build_up_headquarters_window_open_terminal = {
    _name = "build_up_headquarters_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("BuildUpHeadquartersClass") == nil then
            local build_id = params[1]
            local _win = BuildUpHeadquarters:new()
            _win:init(build_id)
            fwin:open(_win, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local build_up_headquarters_window_close_terminal = {
    _name = "build_up_headquarters_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildUpHeadquartersClass"))
        state_machine.excute("main_window_update_userinfo", 0, nil)
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_headquarters_window_open_terminal)
state_machine.add(build_up_headquarters_window_close_terminal)
state_machine.init()

function BuildUpHeadquarters:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.last_time = nil
    -- 1建造，2介绍
    self._last_page_index = 0

    -- 建筑id
    self._build_id = 0
    -- 加速倒计时
    self._text_time = nil
    self._loading_bar = nil
    self._base_build_info = nil
    self._update_image = nil
    -- 加速所需金币
    self._need_gold = 0
    self._can_update = false
    self._config_need_gold = 0
    self._build_res_cell = nil

    self._free_time = 0             -- 可免费升级时间
    self._build_up_state = 0        -- 0：未升级，1：升级中，2：免费升级

    self._activity_type = 0

    --load lua file
    app.load("client.red_alert_time.cells.build_up.build_up_cell")
    app.load("client.red_alert_time.build_up.BuildUpBbuildQuickly")
     -- Initialize alert_home state machine.
    local function init_build_up_headquarters_terminal()

        --显示所有
        local build_up_headquarters_window_show_terminal = {
            _name = "build_up_headquarters_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:onShow()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏所有
        local build_up_headquarters_window_hide_terminal = {
            _name = "build_up_headquarters_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 建筑
        local build_up_headquarters_change_to_build_page_terminal = {
            _name = "build_up_headquarters_change_to_build_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._last_page_index = 1
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
     
        -- 介绍
        local build_up_headquarters_change_to_introduce_page_terminal = {
            _name = "build_up_headquarters_change_to_introduce_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._last_page_index = 2
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 升级
        local build_up_headquarters_to_up_terminal = {
            _name = "build_up_headquarters_to_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                        TipDlg.drawTextDailog(red_alert_all_str[279])
                        checkPlayEffect(32)
                    end
                end     
                protocol_command.build_level_up.param_list = _ED.home_build[""..instance._build_id].base_mould_id .. "\r\n" .. "-1"
                NetworkManager:register(protocol_command.build_level_up.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 加速
        local build_up_headquarters_to_add_speed_terminal = {
            _name = "build_up_headquarters_to_add_speed",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._build_up_state == 1 then
                    state_machine.excute("build_up_build_quickly_window_open",0,{instance._build_id,instance._base_build_info,instance._need_gold})
                elseif instance._build_up_state == 2 then
                    -- 免费升级
                    state_machine.excute("home_map_free_build_up", 0, {instance._build_id})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 取消
        local build_up_headquarters_to_cancel_terminal = {
            _name = "build_up_headquarters_to_cancel",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local tip = ConfirmTip:new()
                tip:init(instance, instance.sureCancelBuild, red_alert_all_str[270])
                fwin:open(tip,fwin._windows) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 刷新界面
        local build_up_headquarters_to_update_draw_terminal = {
            _name = "build_up_headquarters_to_update_draw",
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

        local build_up_headquarters_activity_rule_infor_terminal = {
            _name = "build_up_headquarters_activity_rule_infor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_rule_infor_window_open",0,instance._activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }     

        state_machine.add(build_up_headquarters_window_show_terminal)
        state_machine.add(build_up_headquarters_window_hide_terminal)   
        state_machine.add(build_up_headquarters_change_to_build_page_terminal)
        state_machine.add(build_up_headquarters_change_to_introduce_page_terminal)
        state_machine.add(build_up_headquarters_to_up_terminal)
        state_machine.add(build_up_headquarters_to_add_speed_terminal)
        state_machine.add(build_up_headquarters_to_cancel_terminal)
        state_machine.add(build_up_headquarters_to_update_draw_terminal)
        state_machine.add(build_up_headquarters_activity_rule_infor_terminal)
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_build_up_headquarters_terminal()

end

-- 取消建造
function BuildUpHeadquarters:sureCancelBuild(sure_number)
    if self.roots == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end
    if self:getNowBuildState() ~= 1 then
        return
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                response.node:onUpdateDraw()
            end
            checkPlayEffect(78)
        end
    end
    if sure_number == 0 then
        protocol_command.build_level_up_cancel.param_list = _ED.home_build[""..self._build_id].base_mould_id
        NetworkManager:register(protocol_command.build_level_up_cancel.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

--显示
function BuildUpHeadquarters:onShow()
   self:setVisible(true)
end

--隐藏
function BuildUpHeadquarters:onHide()
   self:setVisible(false)
end

--初始化界面
function BuildUpHeadquarters:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_headquarters)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "build_up_headquarters_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build_up"), nil, 
    {
        terminal_name = "build_up_headquarters_to_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil, 
    {
        terminal_name = "build_up_headquarters_to_cancel", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 加速完成
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_speed_finsh"), nil, 
    {
        terminal_name = "build_up_headquarters_to_add_speed", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 建造
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build"), nil, 
    {
        terminal_name = "build_up_headquarters_change_to_build_page",     
        terminal_state = 0, 
    }, nil, 1)      

    -- 介绍
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_introduce"), nil, 
    {
        terminal_name = "build_up_headquarters_change_to_introduce_page",     
        terminal_state = 0, 
    }, nil, 1)

    -- 活动规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build_up_res_act"), nil, 
    {
        terminal_name = "build_up_headquarters_activity_rule_infor",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)

    local Panel_information = ccui.Helper:seekWidgetByName(root,"Panel_information")
    local Panel_build_icon = ccui.Helper:seekWidgetByName(root,"Panel_build_icon")
    Panel_information:removeAllChildren(true)
    Panel_build_icon:removeAllChildren(true)

    self:openHeadquartersDraw()

    local id = _ED.home_build[""..self._build_id].build_mould_id
    local pic = dms.int(dms["build_mould"], id, build_mould.pic)
    local effect_paths = string.format(config_res.images.ui.home.home_build_effect, pic)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    local armature = ccs.Armature:create("home_build_"..pic)
    draw.initArmature(armature, nil, -1, 0, 1)
    armature:setPosition(cc.p(Panel_build_icon:getContentSize().width/2, Panel_build_icon:getContentSize().height/2))
    Panel_build_icon:addChild(armature)
    armature:getAnimation():playWithIndex(1)

    self._config_need_gold = dms.int(dms["major_city_config"], 11, major_city_config.param)
end

-- 显示信息
function BuildUpHeadquarters:onUpdateDraw()
    local root = self.roots[1]
    -- 建筑名和等级
    local Text_build_name_lv = ccui.Helper:seekWidgetByName(root,"Text_build_name_lv")
    local level = zstring.tonumber(_ED.home_build[""..self._build_id].level)
    local base_build_level_info = _ED.base_build_level_info[""..level]
    Text_build_name_lv:setString(string.format(tipStringInfo_build_name_info[self._base_build_info.id],level))
    local Button_build_up = ccui.Helper:seekWidgetByName(root,"Button_build_up")              -- 升级按钮
    local need_iron = self._base_build_info.cost_iron_factor * base_build_level_info.cost     -- 需要铁矿
    local need_oil = self._base_build_info.cost_oil_factor * base_build_level_info.cost       -- 需要石油
    local need_lead = self._base_build_info.cost_lead_factor * base_build_level_info.cost     -- 需要铅矿
    Button_build_up:setVisible(true)
    local lave_info = {need_iron - _ED.user_info.user_iron ,
                    need_oil - _ED.user_info.oil_field,
                    need_lead - _ED.user_info.exploits}
    local lave_info_table = {}
    for i,v in pairs(lave_info) do
        if v > 0 then
            table.insert(lave_info_table, v) 
        end
    end
    if need_iron > tonumber(_ED.user_info.user_iron) 
        or need_oil > tonumber(_ED.user_info.oil_field) 
        or need_lead > tonumber(_ED.user_info.exploits) 
        then
        Button_build_up:setBright(false)
        Button_build_up:setTouchEnabled(false)
    else
        Button_build_up:setBright(true)
        Button_build_up:setTouchEnabled(true)
    end

    local Panel_information = ccui.Helper:seekWidgetByName(root,"Panel_information")    -- 建筑信息
    local Text_introduce = ccui.Helper:seekWidgetByName(root,"Text_introduce")          -- 介绍
    local Button_build = ccui.Helper:seekWidgetByName(root,"Button_build")              -- 建筑按钮
    local Button_introduce = ccui.Helper:seekWidgetByName(root,"Button_introduce")      -- 介绍按钮
    local Text_time = ccui.Helper:seekWidgetByName(root,"Text_time")                          -- 升级所需时间
    local Image_time = ccui.Helper:seekWidgetByName(root,"Image_time")                        -- 时间icon          
    local Image_bg_2 = ccui.Helper:seekWidgetByName(root,"Image_bg_2")    
    local Button_build_up_res_act = ccui.Helper:seekWidgetByName(root,"Button_build_up_res_act")    
    Image_bg_2:setVisible(false)
    if Button_build_up_res_act ~= nil then
        Button_build_up_res_act:setVisible(false)
    end

    -- 可免费升级时间
    self._free_time = 60 * dms.int(dms["base_consume"], 102, tonumber(_ED.vip_grade) + 4)

    local Button_cancel = ccui.Helper:seekWidgetByName(root,"Button_cancel")                        -- 取消
    local Button_speed_finsh = ccui.Helper:seekWidgetByName(root,"Button_speed_finsh")                        -- 加速

    -- 升级完成倒计时
    local Text_time_n = ccui.Helper:seekWidgetByName(root,"Text_time_n")
    local LoadingBar_up_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_up_time")
    local Image_loading_up_bg = ccui.Helper:seekWidgetByName(root,"Image_loading_up_bg")
    self._text_time = Text_time_n
    self._loading_bar = LoadingBar_up_time
    self._update_image = Image_loading_up_bg
    self._text_time:setVisible(false)
    self._loading_bar:setVisible(false)
    self._update_image:setVisible(false)
    self._loading_bar:setPercent(0)

    Text_introduce:setVisible(false)
    if self._last_page_index == 1 then
        Panel_information:setVisible(true)
        Button_introduce:setHighlighted(false)
        Button_introduce:setTouchEnabled(true)
        Button_build:setHighlighted(true)
        Button_build:setTouchEnabled(false)
        Text_time:setVisible(true)
        if self._build_res_cell == nil then
            self._build_res_cell = state_machine.excute("build_up_cell_create", 0, {Panel_information, self._build_id, _ED.base_build_info[""..self._build_id], base_build_level_info})
        else
            state_machine.excute("build_up_cell_update_all_info", 0, {cell = self._build_res_cell, build_info = _ED.base_build_info[""..self._build_id], build_up_info = base_build_level_info})
        end

        -- 火力驱动活动标志
        if _ED.activity_info ~= nil and _ED.activity_info["117"] ~= nil and Button_build_up_res_act ~= nil then
            local other_info = zstring.split(_ED.activity_info["117"].activity_add_state, "!")
            local timesData = zstring.split(other_info[1], ",")
            local leave_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
            if leave_times > 0 then
                local start_time = tonumber(timesData[1]/1000)
                local current_time = os.time() + _ED.time_add_or_sub
                local open_info = zstring.split(other_info[2], "|")
                open_info = zstring.split(open_info[5], ",")        -- 建筑升级加速
                if (current_time - start_time) > (tonumber(open_info[1])) * 3600 then
                    Button_build_up_res_act:setVisible(true)
                    self._activity_type = 117
                end
            end
        end
    else
        Panel_information:setVisible(false)
        Image_bg_2:setVisible(true)
        Button_introduce:setHighlighted(true)
        Button_introduce:setTouchEnabled(false)
        Button_build:setHighlighted(false)
        Button_build:setTouchEnabled(true)
        Text_introduce:setVisible(true)
        Button_build_up:setVisible(false)
        Image_time:setVisible(false)
        Text_time:setVisible(false)
        Button_cancel:setVisible(false)
        Button_speed_finsh:setVisible(false)
        return
    end

    -- 区分正在升级和没有升级时的显示状态
    local Button_cancel = ccui.Helper:seekWidgetByName(root,"Button_cancel")                  -- 取消按钮
    local Button_speed_finsh = ccui.Helper:seekWidgetByName(root,"Button_speed_finsh")        -- 加速完成按钮
    local need_time = zstring.tonumber(_ED.base_build_level_info[""..level].need_time * _ED.base_build_info[""..self._build_id].upgrade_factor)
    need_time = math.floor(need_time / (1 + _ED.build_time_factor / 100))
    
    if self:getNowBuildState() ~= 1 then
        Button_cancel:setVisible(false)
        Button_speed_finsh:setVisible(false)
        Text_time:setString(exChangeTimeToString(need_time))
        Image_time:setVisible(true)

        self._build_up_state = 0
    else
        Button_cancel:setVisible(true)
        Button_speed_finsh:setVisible(true)
        Button_build_up:setVisible(false)
        Text_time:setString("")
        Image_time:setVisible(false)
        self._text_time:setVisible(true)
        self._text_time:setString(exChangeTimeToString(need_time))
        self._loading_bar:setVisible(true)
        self._update_image:setVisible(true)

        local max_time = _ED.home_build[""..self._build_id].update_time_cd
        local leave_time = max_time - zstring.tonumber((os.time() + _ED.time_add_or_sub - _ED.home_build[""..self._build_id].update_start_time))
        leave_time = math.min(leave_time, max_time)
        local persent = math.floor((max_time - leave_time) * 100 / max_time)
        self._loading_bar:setPercent(persent)
        self._text_time:setString(exChangeTimeToString(leave_time))

        self._build_up_state = 1
        if leave_time <= self._free_time then
            self._build_up_state = 2
        end
        self:updateButtonState()
    end

    -- 判断建筑是否满级
    if level >= tonumber(self._base_build_info.max_level) then
        Button_build_up:setVisible(false)
        Text_time:setString("")
        Image_time:setVisible(false)
    end
end

function BuildUpHeadquarters:updateButtonState()
    local root = self.roots[1]
    local Button_speed_finsh = ccui.Helper:seekWidgetByName(root,"Button_speed_finsh")
    if self._build_up_state == 1 then
        Button_speed_finsh:loadTextureNormal("images/ui/share/button_share_2.png", 1)
        Button_speed_finsh:loadTexturePressed("images/ui/share/button_share_2.png", 1)
        Button_speed_finsh:setTitleText(red_alert_time_str[286])
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_quick_prop_push",
            _widget = Button_speed_finsh,
            ntype = 1,
            _invoke = nil,
            _interval = 0.2,})
    elseif self._build_up_state == 2 then
        Button_speed_finsh:loadTextureNormal("images/ui/share/button_share_1.png", 1)
        Button_speed_finsh:loadTexturePressed("images/ui/share/button_share_1.png", 1)
        Button_speed_finsh:setTitleText(red_alert_time_str[287])
    end

end

function BuildUpHeadquarters:getNowBuildState()
    return zstring.tonumber(_ED.home_build[""..self._build_id].update_state) -- 1 正在升级 2 升级结束了
end

-- 打开司令部
function BuildUpHeadquarters:openHeadquartersDraw()
    if self._last_page_index == 0 then
        self._last_page_index = 1
    end
    self:onUpdateDraw()
end

function BuildUpHeadquarters:onUpdate(dt)
    if self._base_build_info.max_level == -1 then
        return
    end
    local build_info = _ED.home_build[""..self._build_id]
    if build_info == nil then
        return
    end
    if self._text_time ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            local level = zstring.tonumber(build_info.level)
            if zstring.tonumber(build_info.update_state) == 1 then
                local max_time = build_info.update_time_cd
                if self._last_page_index == 1 then
                    self._loading_bar:setVisible(true)
                    self._text_time:setVisible(true)
                    self._update_image:setVisible(true)
                end
                local leave_time = max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - _ED.home_build[""..self._build_id].update_start_time))
                leave_time = math.min(leave_time, max_time)
                local persent = math.floor((max_time - leave_time) * 100 / max_time)
                self._loading_bar:setPercent(persent)
                self._text_time:setString(exChangeTimeToString(leave_time))
                self._can_update = true
                self._need_gold = math.ceil(leave_time/60 * self._config_need_gold)

                if self._build_up_state == 1 and leave_time <= self._free_time then
                    self._build_up_state = 2
                    self:updateButtonState()
                elseif self._build_up_state == 2 and leave_time > self._free_time then
                    self._build_up_state = 1
                    self:updateButtonState()
                end
            else
                if self._can_update == true then
                    state_machine.excute("build_up_build_quickly_window_close",0,"")
                    self:onUpdateDraw()
                end
                self._can_update = false
                self._loading_bar:setVisible(false)
                self._text_time:setVisible(false)
                self._update_image:setVisible(false)
            end
        end
    end
end

--初始化
function BuildUpHeadquarters:init(build_id)
    self._build_id = build_id
    self._base_build_info = _ED.base_build_info[""..build_id]
    self:setTouchEnabled(true)
    self:onInit()
end

--移除状态机
function BuildUpHeadquarters:onExit()
    state_machine.remove("build_up_headquarters_window_show")
    state_machine.remove("build_up_headquarters_window_hide")
    state_machine.remove("build_up_headquarters_change_to_build_page")
    state_machine.remove("build_up_headquarters_change_to_introduce_page")
    state_machine.remove("build_up_headquarters_to_up")
    state_machine.remove("build_up_headquarters_to_add_speed")
    state_machine.remove("build_up_headquarters_to_cancel")
    state_machine.remove("build_up_headquarters_to_update_draw")
    state_machine.remove("build_up_headquarters_activity_rule_infor")
end