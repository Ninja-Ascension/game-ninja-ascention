-- ------------------------------------------------------------------------------------------------------------
--  说明：制造工厂
-- ------------------------------------------------------------------------------------------------------------
BuildUpMakeFactory = class("BuildUpMakeFactoryClass", Window)

--打开界面
local build_up_make_factory_window_open_terminal = {
    _name = "build_up_make_factory_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local build_id = params[1]
        local base_build_info = params[2]
        local page = nil
        if params[3] ~= nil then
            page = tonumber(params[3])
        end
        if funOpenDrawTip(base_build_info.fun_open_tab_id) == true then
            return
        end 
        if fwin:find("BuildUpMakeFactoryClass") == nil then
            local _win = BuildUpMakeFactory:new()
            _win:init(build_id, base_build_info, page)
            fwin:open(_win, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local build_up_make_factory_window_close_terminal = {
    _name = "build_up_make_factory_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildUpMakeFactoryClass"))
        state_machine.excute("main_window_update_userinfo", 0, nil)
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_make_factory_window_open_terminal)
state_machine.add(build_up_make_factory_window_close_terminal)
state_machine.init()

function BuildUpMakeFactory:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.last_time = nil
    -- 1建造，2生产，3生产中
    self._last_page_index = nil
    self._pages = {} 

    -- 建筑id
    self._build_id = 0
    -- 加速倒计时
    self._text_time = nil
    self._loading_bar = nil
    self._base_build_info = nil
    self._update_image = nil
    self._can_update = false
    -- 加速所需金币
    self._need_gold = 0

    -- 金币加速
    self._need_gold_up = false

    self._free_time = 0             -- 可免费升级时间
    self._build_up_state = 0        -- 0：未升级，1：升级中，2：免费升级

    self._activity_type = 0

    --load lua file
    app.load("client.red_alert_time.cells.build_up.build_up_cell")
    app.load("client.red_alert_time.build_up.BuildUpMakeFactoryProduction")
    app.load("client.red_alert_time.build_up.BuildUpMakeFactoryIngProduction")
    app.load("client.red_alert_time.build_up.BuildUpBbuildQuickly")
    app.load("client.red_alert_time.build_up.BuildUpMakeProps")

     -- Initialize alert_home state machine.
    local function init_build_up_make_factory_terminal()
        --显示所有
        local build_up_make_factory_window_show_terminal = {
            _name = "build_up_make_factory_window_show",
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
        local build_up_make_factory_window_hide_terminal = {
            _name = "build_up_make_factory_window_hide",
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

        local build_up_make_factory_change_page_terminal = {
            _name = "build_up_make_factory_change_page",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._last_page_index = params._datas.index
                instance:changePage()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 升级
        local build_up_make_factory_to_up_terminal = {
            _name = "build_up_make_factory_to_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local other_levels = dms.string(dms["fun_open_condition"], instance._base_build_info.fun_open_tab_id, fun_open_condition.other_levels)
                local build_infos = zstring.split(other_levels, ",")
                if zstring.tonumber(_ED.home_build[""..instance._build_id].level + 1) > zstring.tonumber(_ED.home_build[""..build_infos[1]].level) then
                    if tonumber(build_infos[1]) == 1 then
                        state_machine.excute("build_up_headquarters_window_open",0,{1})
                        return
                    else
                        TipDlg.drawTextDailog(red_alert_all_str[275])
                        return
                    end
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
                        TipDlg.drawTextDailog(red_alert_all_str[279])
                        checkPlayEffect(31)
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
        local build_up_make_factory_to_add_speed_terminal = {
            _name = "build_up_make_factory_to_add_speed",
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
        local build_up_make_factory_to_cancel_terminal = {
            _name = "build_up_make_factory_to_cancel",
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
        local build_up_make_factory_to_update_draw_terminal = {
            _name = "build_up_make_factory_to_update_draw",
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

        local build_up_make_factory_activity_rule_infor_terminal = {
            _name = "build_up_make_factory_activity_rule_infor",
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

        state_machine.add(build_up_make_factory_window_show_terminal)
        state_machine.add(build_up_make_factory_window_hide_terminal)   
        state_machine.add(build_up_make_factory_change_page_terminal)
        state_machine.add(build_up_make_factory_to_up_terminal)
        state_machine.add(build_up_make_factory_to_add_speed_terminal)
        state_machine.add(build_up_make_factory_to_cancel_terminal)
        state_machine.add(build_up_make_factory_to_update_draw_terminal)
        state_machine.add(build_up_make_factory_activity_rule_infor_terminal)
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_build_up_make_factory_terminal()
end

-- 取消建造
function BuildUpMakeFactory:sureCancelBuild(sure_number)
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
function BuildUpMakeFactory:onShow()
   self:setVisible(true)
end

--隐藏
function BuildUpMakeFactory:onHide()
   self:setVisible(false)
end

--初始化界面
function BuildUpMakeFactory:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_make_factory)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "build_up_make_factory_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build_up"), nil, 
    {
        terminal_name = "build_up_make_factory_to_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil, 
    {
        terminal_name = "build_up_make_factory_to_cancel", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 加速完成
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_speed_finsh"), nil, 
    {
        terminal_name = "build_up_make_factory_to_add_speed", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 建造
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build"), nil, 
    {
        terminal_name = "build_up_make_factory_change_page",     
        terminal_state = 0, 
        index = 1,
    }, nil, 1)      

    -- 制造
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_production"), nil, 
    {
        terminal_name = "build_up_make_factory_change_page",     
        terminal_state = 0, 
        index = 2,
    }, nil, 1)  

    -- 制造中
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_in_production"), nil, 
    {
        terminal_name = "build_up_make_factory_change_page",     
        terminal_state = 0, 
        index = 3,
    }, nil, 1)

    -- 活动规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build_up_res_act"), nil, 
    {
        terminal_name = "build_up_make_factory_activity_rule_infor",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1)  

    if self._last_page_index == nil then
        local current_level = zstring.tonumber(_ED.home_build[""..self._build_id].level)
        if current_level > 0 then
            self._last_page_index = 2
        else
            self._last_page_index = 1
        end
    end

    local Panel_build_icon = ccui.Helper:seekWidgetByName(root,"Panel_build_icon")
    Panel_build_icon:removeAllChildren(true)
    local id = _ED.home_build[""..self._build_id].build_mould_id
    local pic = dms.int(dms["build_mould"], id, build_mould.pic) 
    local effect_paths = string.format(config_res.images.ui.home.home_build_effect, pic)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    local armature = ccs.Armature:create("home_build_"..pic)
    draw.initArmature(armature, nil, -1, 0, 1)
    armature:setPosition(cc.p(Panel_build_icon:getContentSize().width/2, Panel_build_icon:getContentSize().height/2))
    Panel_build_icon:addChild(armature)
    armature:getAnimation():playWithIndex(1)

    self:onUpdateDraw()
end

-- 显示信息
function BuildUpMakeFactory:onUpdateDraw()
    local root = self.roots[1]
    local Panel_tab_box = ccui.Helper:seekWidgetByName(root,"Panel_information")    -- 建筑信息

    -- 建筑名和等级
    local Text_build_name_lv = ccui.Helper:seekWidgetByName(root,"Text_build_name_lv")
    local level = zstring.tonumber(_ED.home_build[""..self._build_id].level)
    local base_build_level_info = _ED.base_build_level_info[""..level]
    Text_build_name_lv:setString(string.format(tipStringInfo_build_name_info[self._base_build_info.id],level))
    local Button_build_up = ccui.Helper:seekWidgetByName(root,"Button_build_up")              -- 升级按钮
    local need_iron = self._base_build_info.cost_iron_factor * base_build_level_info.cost     -- 需要铁矿
    local need_oil = self._base_build_info.cost_oil_factor * base_build_level_info.cost       -- 需要石油
    local need_lead = self._base_build_info.cost_lead_factor * base_build_level_info.cost     -- 需要铅矿
    local lave_info = {need_iron - _ED.user_info.user_iron ,
                    need_oil - _ED.user_info.oil_field,
                    need_lead - _ED.user_info.exploits}
    local lave_info_table = {}
    for i,v in pairs(lave_info) do
        if v > 0 then
            table.insert(lave_info_table, v) 
        end
    end
    if level + 1 > zstring.tonumber(_ED.home_build["1"].level) then
        Button_build_up:setBright(false)
        Button_build_up:setTouchEnabled(false)
    else
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
    end
    
    if self._pages["1"] == nil then
        self._pages["1"] = state_machine.excute("build_up_cell_create", 0, {Panel_tab_box, self._build_id,self._base_build_info,base_build_level_info})
    else
        state_machine.excute("build_up_cell_update_all_info", 0, {cell = self._pages["1"], build_info = self._base_build_info, build_up_info = base_build_level_info})
    end

    -- 可免费升级时间
    self._free_time = 60 * dms.int(dms["base_consume"], 102, tonumber(_ED.vip_grade) + 4)

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

    -- 区分正在升级和没有升级时的显示状态
    local Button_cancel = ccui.Helper:seekWidgetByName(root,"Button_cancel")                  -- 取消按钮
    local Button_speed_finsh = ccui.Helper:seekWidgetByName(root,"Button_speed_finsh")        -- 加速完成按钮
    local Text_time = ccui.Helper:seekWidgetByName(root,"Text_time")                          -- 升级所需时间
    local Image_loading_up_bg = ccui.Helper:seekWidgetByName(root,"Image_loading_up_bg")      -- 时间icon
    if self:getNowBuildState() == 1 then
        Button_cancel:setVisible(true)
        Button_speed_finsh:setVisible(true)
        Button_build_up:setVisible(false)
        Text_time:setString("")
        Image_loading_up_bg:setVisible(true)
        self._loading_bar:setVisible(true)

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
    else
        Button_cancel:setVisible(false)
        Button_speed_finsh:setVisible(false)
        Button_build_up:setVisible(true)
        local need_time = zstring.tonumber(_ED.base_build_level_info[""..level].need_time * self._base_build_info.upgrade_factor)
        need_time = math.floor(need_time / (1 + _ED.build_time_factor / 100))
        Text_time:setString(exChangeTimeToString(need_time))
        Image_loading_up_bg:setVisible(false)
        self._loading_bar:setVisible(false)

        self._build_up_state = 0
    end
    if level == 0 then
        Button_build_up:setTitleText(red_alert_all_str[278])
        local need_up_time = _ED.base_build_info[""..self._build_id].need_time
        Text_time:setString(exChangeTimeToString(need_up_time))
    else
        Button_build_up:setTitleText(red_alert_all_str[74])
    end

    self:changePage()
    
    -- 判断建筑是否满级
    local Image_time_icon = ccui.Helper:seekWidgetByName(root,"Image_time_icon")
    if level >= tonumber(self._base_build_info.max_level) then
        Button_build_up:setVisible(false)
        Text_time:setString("")
        Image_time_icon:setVisible(false)
    end
end

function BuildUpMakeFactory:updateButtonState()
    local root = self.roots[1]
    local Button_speed_finsh = ccui.Helper:seekWidgetByName(root,"Button_speed_finsh")
    if self._build_up_state == 1 then
        Button_speed_finsh:loadTextureNormal("images/ui/share/button_share_2.png", 1)
        Button_speed_finsh:loadTexturePressed("images/ui/share/button_share_2.png", 1)
        Button_speed_finsh:setTitleText(red_alert_time_str[286])
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_quick_prop_push",
            _widget = ccui.Helper:seekWidgetByName(root, "Button_speed_finsh"),
            ntype = 1,
            _invoke = nil,
            _interval = 0.2,})
    elseif self._build_up_state == 2 then
        Button_speed_finsh:loadTextureNormal("images/ui/share/button_share_1.png", 1)
        Button_speed_finsh:loadTexturePressed("images/ui/share/button_share_1.png", 1)
        Button_speed_finsh:setTitleText(red_alert_time_str[287])
    end
end

function BuildUpMakeFactory:setUpdateVisible(flag)
    local root = self.roots[1]
    local Text_time = ccui.Helper:seekWidgetByName(root,"Text_time")
    local Button_build_up = ccui.Helper:seekWidgetByName(root,"Button_build_up")
    local Image_loading_up_bg = ccui.Helper:seekWidgetByName(root,"Image_loading_up_bg")
    local LoadingBar_up_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_up_time")
    local Text_time_n = ccui.Helper:seekWidgetByName(root,"Text_time_n")
    local Button_cancel = ccui.Helper:seekWidgetByName(root,"Button_cancel")
    local Button_speed_finsh = ccui.Helper:seekWidgetByName(root,"Button_speed_finsh")
    local Image_time_icon = ccui.Helper:seekWidgetByName(root,"Image_time_icon")      -- 时间icon
    local Button_build_up_res_act = ccui.Helper:seekWidgetByName(root,"Button_build_up_res_act")
    local level = zstring.tonumber(_ED.home_build[""..self._build_id].level)
    if Button_build_up_res_act ~= nil then
        Button_build_up_res_act:setVisible(false)
    end
    
    if flag == true then
        if self:getNowBuildState() == 1 then
            Text_time:setVisible(false)
            Button_build_up:setVisible(false)
            Image_time_icon:setVisible(false)
            Image_loading_up_bg:setVisible(true)
            LoadingBar_up_time:setVisible(true)
            Text_time_n:setVisible(true)
            Button_cancel:setVisible(true)
            Button_speed_finsh:setVisible(true)
        else
            Button_build_up:setVisible(true)
            if level + 1 > zstring.tonumber(_ED.home_build["1"].level) then
                Button_build_up:setBright(false)
                Button_build_up:setTouchEnabled(false)
            end
            Text_time:setVisible(true)
            Image_time_icon:setVisible(true)
            Image_loading_up_bg:setVisible(false)
            LoadingBar_up_time:setVisible(false)
            Text_time_n:setVisible(false)
            Button_cancel:setVisible(false)
            Button_speed_finsh:setVisible(false)
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
        Image_loading_up_bg:setVisible(false)
        Text_time:setVisible(false)
        Button_build_up:setVisible(false)
        Image_time_icon:setVisible(false)
        Image_loading_up_bg:setVisible(false)
        LoadingBar_up_time:setVisible(false)
        Text_time_n:setVisible(false)
        Button_cancel:setVisible(false)
        Button_speed_finsh:setVisible(false)
    end
    -- 判断建筑是否满级
    local Image_time_icon = ccui.Helper:seekWidgetByName(root,"Image_time_icon")
    if level >= tonumber(self._base_build_info.max_level) then
        Button_build_up:setVisible(false)
        Text_time:setString("")
        Image_time_icon:setVisible(false)
    end
end

function BuildUpMakeFactory:changePage()
    local root = self.roots[1]
    local Panel_tab_box = ccui.Helper:seekWidgetByName(root,"Panel_tab_box") 
    local Button_build = ccui.Helper:seekWidgetByName(root,"Button_build")              -- 建筑按钮
    local Button_production = ccui.Helper:seekWidgetByName(root,"Button_production")      -- 生产按钮
    local Button_in_production = ccui.Helper:seekWidgetByName(root,"Button_in_production")      -- 生产中按钮
    local Image_bg_2 = ccui.Helper:seekWidgetByName(root,"Image_bg_2")    
    Image_bg_2:setVisible(true)

    Button_build:setHighlighted(false)
    Button_build:setTouchEnabled(true)
    Button_production:setHighlighted(false)
    Button_production:setTouchEnabled(true)
    Button_in_production:setHighlighted(false)
    Button_in_production:setTouchEnabled(true)

    for i, page in pairs(self._pages) do 
        page:setVisible(false)
    end   
    if self._last_page_index == 1 then
        Image_bg_2:setVisible(false)
        Button_build:setHighlighted(true)
        Button_build:setTouchEnabled(false)
        self:setUpdateVisible(true)
    elseif self._last_page_index == 2 then
        Button_production:setHighlighted(true)
        Button_production:setTouchEnabled(false)
        if self._pages["2"] == nil then
            self._pages["2"] = state_machine.excute("build_up_make_factory_production_window_open", 0, {Panel_tab_box})
        else
            state_machine.excute("build_up_make_factory_production_show", 0, nil)
        end
        self:setUpdateVisible(false)
    elseif self._last_page_index == 3 then
        Button_in_production:setHighlighted(true)
        Button_in_production:setTouchEnabled(false)
        if self._pages["3"] == nil then
            self._pages["3"] = state_machine.excute("build_up_make_factory_ing_production_window_open", 0, {Panel_tab_box})
        end
        self:setUpdateVisible(false)
    end
    self._pages[""..self._last_page_index]:setVisible(true)
end

function BuildUpMakeFactory:getNowBuildState()
    return zstring.tonumber(_ED.home_build[""..self._build_id].update_state) -- 1 正在升级 2 升级结束了
end

function BuildUpMakeFactory:onUpdate(dt)
    if self._base_build_info.max_level == -1 then
        return
    end
    if _ED.home_build[""..self._build_id] == nil then
        return
    end
    if self._text_time ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            if zstring.tonumber(_ED.home_build[""..self._build_id].update_state) == 1 then
                local max_time = _ED.home_build[""..self._build_id].update_time_cd
                if self._last_page_index == 1 then
                    self._loading_bar:setVisible(true)
                    self._text_time:setVisible(true)
                    self._update_image:setVisible(true)
                end
                local leave_time = max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - _ED.home_build[""..self._build_id].update_start_time))
                leave_time = math.min(leave_time, max_time)
                local persent = 0
                persent = math.floor((max_time - leave_time) * 100/ max_time)
                self._loading_bar:setPercent(persent)
                if leave_time > 0 then
                    self._text_time:setString(exChangeTimeToString(leave_time))
                    local need_gold = dms.int(dms["major_city_config"],11,major_city_config.param)
                    self._need_gold = math.ceil(leave_time/60 * need_gold)
                else
                    self._can_update = true
                end

                if self._build_up_state == 1 and leave_time <= self._free_time then
                    self._build_up_state = 2
                    self:updateButtonState()
                elseif self._build_up_state == 2 and leave_time > self._free_time then
                    self._build_up_state = 1
                    self:updateButtonState()
                end
            else
                if self._can_update == true then
                    self._can_update = false
                    state_machine.excute("build_up_build_quickly_window_close",0,"")
                    self:onUpdateDraw()
                end
                self._loading_bar:setVisible(false)
                self._text_time:setVisible(false)
                self._update_image:setVisible(false)
            end
        end
    end
end

--初始化
function BuildUpMakeFactory:init(build_id, base_build_info, page)
    self._build_id = build_id
    self._base_build_info = base_build_info
    self._last_page_index = page
    self:setTouchEnabled(true)
    self:onInit()
end

--移除状态机
function BuildUpMakeFactory:onExit()
    state_machine.remove("build_up_make_factory_window_show")
    state_machine.remove("build_up_make_factory_window_hide")
    state_machine.remove("build_up_make_factory_change_page")
    state_machine.remove("build_up_make_factory_to_up")
    state_machine.remove("build_up_make_factory_to_add_speed")
    state_machine.remove("build_up_make_factory_to_cancel")
    state_machine.remove("build_up_make_factory_to_update_draw")
    state_machine.remove("build_up_make_factory_activity_rule_infor")
end