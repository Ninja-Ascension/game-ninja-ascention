-- ------------------------------------------------------------------------------------------------------------
--  说明：科技中心
-- ------------------------------------------------------------------------------------------------------------
BuildUpScientific = class("BuildUpScientificClass", Window)

--打开界面
local build_up_scientific_window_open_terminal = {
    _name = "build_up_scientific_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("BuildUpScientificClass") == nil then
            local build_id = params[1]
            local base_build_info = params[2]
            local page = 1
            if params[3] ~= nil then
                page = tonumber(params[3])
            end
            if funOpenDrawTip(base_build_info.fun_open_tab_id) == true then
                return
            end 
            local _win = BuildUpScientific:new()
            _win:init(build_id, page)
            fwin:open(_win, fwin._ui)
        end
        -- 进入科技中心时 触发教学
        state_machine.excute("main_window_check_mission", 0, 0)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local build_up_scientific_window_close_terminal = {
    _name = "build_up_scientific_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildUpScientificClass"))
        state_machine.excute("main_window_update_userinfo", 0, nil)
        state_machine.excute("player_fight_update_draw", 0, "")
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_scientific_window_open_terminal)
state_machine.add(build_up_scientific_window_close_terminal)
state_machine.init()

function BuildUpScientific:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.last_time = nil
    -- 1建造，2研究
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
    -- 研究列表
    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_scientific_arrow_down = nil
    self._Image_scientific_arrow_up = nil

    self._build_res_cell = nil

    self._free_time = 0             -- 可免费升级时间
    self._build_up_state = 0        -- 0：未升级，1：升级中，2：免费升级
    self.m_times = 0

    self._need_update = false

    self._activity_type = 0

    --load lua file
    app.load("client.red_alert_time.cells.build_up.build_up_cell")
    app.load("client.red_alert_time.cells.build_up.build_up_scientific_cell")
    app.load("client.red_alert_time.cells.build_up.build_up_scientific_rock_cell")
    app.load("client.red_alert_time.cells.build_up.build_up_scientific_ing_cell")
    app.load("client.red_alert_time.cells.build_up.build_up_scientific_classify_cell")
    app.load("client.red_alert_time.build_up.BuildUpBbuildQuickly")
    app.load("client.red_alert_time.build_up.BuildUpBuildScientificQuickly")
    app.load("client.red_alert_time.build_up.BuildUpScientificInfo")
    app.load("client.red_alert_time.build_up.BuildUpScientificUp")
     -- Initialize alert_home state machine.
    local function init_build_up_scientific_terminal()

        --显示所有
        local build_up_scientific_window_show_terminal = {
            _name = "build_up_scientific_window_show",
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
        local build_up_scientific_window_hide_terminal = {
            _name = "build_up_scientific_window_hide",
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
        local build_up_scientific_change_to_build_page_terminal = {
            _name = "build_up_scientific_change_to_build_page",
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
     
        -- 研究
        local build_up_scientific_change_to_introduce_page_terminal = {
            _name = "build_up_scientific_change_to_introduce_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._last_page_index = 2
                instance:onUpdateDraw()
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 升级
        local build_up_scientific_to_up_terminal = {
            _name = "build_up_scientific_to_up",
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
                local current_level = zstring.tonumber(_ED.home_build[""..instance._build_id].level)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("build_up_scientific_to_update_draw", 0, "")
                        end
                        TipDlg.drawTextDailog(red_alert_all_str[279])
                        if current_level == 0 then
                            checkPlayEffect(31)
                        else
                            checkPlayEffect(32)
                        end
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
        local build_up_scientific_to_add_speed_terminal = {
            _name = "build_up_scientific_to_add_speed",
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
        local build_up_scientific_to_cancel_terminal = {
            _name = "build_up_scientific_to_cancel",
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
        local build_up_scientific_to_update_draw_terminal = {
            _name = "build_up_scientific_to_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    local posY = instance._list_view_poy
                    instance:onUpdateDraw()
                    instance:updateBarracks()
                    if math.abs(posY) > math.abs(instance._list_view_height) then
                        posY = instance._list_view_height
                    end
                    instance._list_view:getInnerContainer():setPositionY(posY)  
                    instance._need_update = true 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        local build_up_scientific_activity_rule_infor_terminal = {
            _name = "build_up_scientific_activity_rule_infor",
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

        state_machine.add(build_up_scientific_window_show_terminal)
        state_machine.add(build_up_scientific_window_hide_terminal)   
        state_machine.add(build_up_scientific_change_to_build_page_terminal)
        state_machine.add(build_up_scientific_change_to_introduce_page_terminal)
        state_machine.add(build_up_scientific_to_up_terminal)
        state_machine.add(build_up_scientific_to_add_speed_terminal)
        state_machine.add(build_up_scientific_to_cancel_terminal)
        state_machine.add(build_up_scientific_to_update_draw_terminal)
        state_machine.add(build_up_scientific_activity_rule_infor_terminal)
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_build_up_scientific_terminal()

end

function BuildUpScientific:refreshListView()
    self._list_view:jumpToTop()
    self._list_view:requestRefreshView()
end

-- 取消建造
function BuildUpScientific:sureCancelBuild(sure_number)
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

-- 加速
function BuildUpScientific:sureSpeedUp(sure_number)
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
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    response.node:onUpdateDraw()
                end
                state_machine.excute("home_map_update_build",0,"")
            end
        end
    end
    if sure_number == 0 then
        protocol_command.build_speed_up.param_list = _ED.home_build[""..self._build_id].base_mould_id
        NetworkManager:register(protocol_command.build_speed_up.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

--显示
function BuildUpScientific:onShow()
   self:setVisible(true)
end

--隐藏
function BuildUpScientific:onHide()
   self:setVisible(false)
end

--初始化界面
function BuildUpScientific:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_scientific)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    local ListView_scientific = ccui.Helper:seekWidgetByName(root, "ListView_scientific")
    self._list_view = ListView_scientific

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "build_up_scientific_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build_up"), nil, 
    {
        terminal_name = "build_up_scientific_to_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil, 
    {
        terminal_name = "build_up_scientific_to_cancel", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 加速完成
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_speed_finsh"), nil, 
    {
        terminal_name = "build_up_scientific_to_add_speed", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 建造
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build"), nil, 
    {
        terminal_name = "build_up_scientific_change_to_build_page",     
        terminal_state = 0, 
    }, nil, 1)      

    -- 研究
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_introduce"), nil, 
    {
        terminal_name = "build_up_scientific_change_to_introduce_page",     
        terminal_state = 0, 
    }, nil, 1)

    -- 活动规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build_up_res_act"), nil, 
    {
        terminal_name = "build_up_scientific_activity_rule_infor",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1) 

    self._Image_scientific_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_scientific_arrow_down")
    self._Image_scientific_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_scientific_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_scientific_arrow_down:stopAllActions()
    self._Image_scientific_arrow_up:stopAllActions()
    playActions(self._Image_scientific_arrow_down)
    playActions(self._Image_scientific_arrow_up)
    self._Image_scientific_arrow_down:setVisible(false)
    self._Image_scientific_arrow_up:setVisible(false)

    if zstring.tonumber(_ED.home_build[""..self._build_id].level) >= tonumber(self._base_build_info.max_level) then
        self._last_page_index = 2
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
    self:updateBarracks()
end

-- 显示信息
function BuildUpScientific:onUpdateDraw()
    local root = self.roots[1]
    -- 建筑名和等级
    local Text_build_name_lv = ccui.Helper:seekWidgetByName(root,"Text_build_name_lv")
    local level = zstring.tonumber(_ED.home_build[""..self._build_id].level)
    local base_build_level_info = _ED.base_build_level_info[""..level]
    Text_build_name_lv:setString(string.format(tipStringInfo_build_name_info[self._base_build_info.id],level))
    local Button_build_up = ccui.Helper:seekWidgetByName(root,"Button_build_up")              -- 升级按钮
    Button_build_up:setVisible(true)
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

    local Panel_information = ccui.Helper:seekWidgetByName(root,"Panel_information")    -- 建筑信息
    local Button_build = ccui.Helper:seekWidgetByName(root,"Button_build")              -- 建筑按钮
    local Button_introduce = ccui.Helper:seekWidgetByName(root,"Button_introduce")      -- 介绍按钮
    local Text_time = ccui.Helper:seekWidgetByName(root,"Text_time")                          -- 升级所需时间
    local Image_time_icon = ccui.Helper:seekWidgetByName(root,"Image_time_icon")                        -- 时间icon
    local Button_cancel = ccui.Helper:seekWidgetByName(root,"Button_cancel")                  -- 取消按钮
    local Button_speed_finsh = ccui.Helper:seekWidgetByName(root,"Button_speed_finsh")        -- 加速完成按钮
    local Image_bg_2 = ccui.Helper:seekWidgetByName(root,"Image_bg_2")    
    local Button_build_up_res_act = ccui.Helper:seekWidgetByName(root,"Button_build_up_res_act")   
    local Panel_build_up_scientific_list = ccui.Helper:seekWidgetByName(root,"Panel_build_up_scientific_list")   
    local Image_scientific_up = ccui.Helper:seekWidgetByName(root,"Image_scientific_up")   
    Image_bg_2:setVisible(true)
    if Button_build_up_res_act ~= nil then
        Button_build_up_res_act:setVisible(false)
    end
    if Panel_build_up_scientific_list ~= nil then
        Panel_build_up_scientific_list:setVisible(false)
    end
    if Image_scientific_up ~= nil then
        Image_scientific_up:setVisible(false)
    end

    if self._last_page_index == 1 then
        Image_bg_2:setVisible(false)
        Button_introduce:setHighlighted(false)
        Button_introduce:setTouchEnabled(true)
        Button_build:setHighlighted(true)
        Button_build:setTouchEnabled(false)
        if self._build_res_cell == nil then
            self._build_res_cell = state_machine.excute("build_up_cell_create", 0, {Panel_information, self._build_id,_ED.base_build_info[""..self._build_id],base_build_level_info})
        else
            state_machine.excute("build_up_cell_update_all_info", 0, {cell = self._build_res_cell, build_info = _ED.base_build_info[""..self._build_id], build_up_info = base_build_level_info})
        end

        Panel_information:setVisible(true)
        self._list_view:setVisible(false)
        Image_time_icon:setVisible(true)
        Text_time:setVisible(true)

        self._Image_scientific_arrow_down:setVisible(false)
        self._Image_scientific_arrow_up:setVisible(false)

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
        Button_introduce:setHighlighted(true)
        Button_introduce:setTouchEnabled(false)
        Button_build:setHighlighted(false)
        Button_build:setTouchEnabled(true)
        Button_build_up:setVisible(false)
        Panel_information:setVisible(false)
        self._list_view:setVisible(true)
        Image_time_icon:setVisible(false)
        Text_time:setVisible(false)
        Button_cancel:setVisible(false)
        Button_speed_finsh:setVisible(false)
        if Panel_build_up_scientific_list ~= nil then
            Panel_build_up_scientific_list:setVisible(true)
        end
        if Image_scientific_up ~= nil then
            Image_scientific_up:setVisible(true)
        end
        return
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

    -- 区分正在升级和没有升级时的显示状态
    if self:getNowBuildState() ~= 1 then
        Button_cancel:setVisible(false)
        Button_speed_finsh:setVisible(false)
        local need_time = zstring.tonumber(_ED.base_build_level_info[""..level].need_time * _ED.base_build_info[""..self._build_id].upgrade_factor)
        need_time = math.floor(need_time / (1 + _ED.build_time_factor / 100))
        Text_time:setString(exChangeTimeToString(need_time))
        Image_time_icon:setVisible(true)
        self._build_up_state = 0
    else
        Button_cancel:setVisible(true)
        Button_speed_finsh:setVisible(true)
        Button_build_up:setVisible(false)
        Text_time:setString("")
        Image_time_icon:setVisible(false)

        self._text_time:setVisible(true)
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
    if level == 0 then
        Button_build_up:setTitleText(red_alert_all_str[278])
        local need_up_time = _ED.base_build_info[""..self._build_id].need_time
        Text_time:setString(need_up_time.."s")
    else
        Button_build_up:setTitleText(red_alert_all_str[74])
    end

    -- 判断建筑是否满级
    if level >= tonumber(self._base_build_info.max_level) then
        Button_build_up:setVisible(false)
        Text_time:setString("")
        Image_time_icon:setVisible(false)
    end
end

function BuildUpScientific:updateButtonState()
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

function BuildUpScientific:updateBarracksEx()
    -- 研究队列
    local root = self.roots[1]
    local ListView_build_up_scientific = ccui.Helper:seekWidgetByName(root,"ListView_build_up_scientific")
    ListView_build_up_scientific:removeAllItems()
    local max_count = 6
    local result = {}
    local on_update_barracks = {}       -- 正在升级的科技
    local ready_barracks = {}           -- 等待中的科技

    for k, v in pairs(_ED.base_barracks_info) do
        local barrack_info = _ED.barracks_info[""..k]
        if barrack_info ~= nil then     -- 已解锁
            if zstring.tonumber(barrack_info.barrack_state) == 1 then    -- 升级中
                v.barrack_upgrade_time = zstring.tonumber(barrack_info.barrack_upgrade_time)
                v.barrack_level = zstring.tonumber(barrack_info.barrack_level)
                table.insert(on_update_barracks, v)
            elseif zstring.tonumber(barrack_info.barrack_state) == 2 then    -- 等待中
                v.barrack_upgrade_time = zstring.tonumber(barrack_info.barrack_upgrade_time)
                v.barrack_level = zstring.tonumber(barrack_info.barrack_level)
                table.insert(ready_barracks, v)
            end    
        end
    end

    function sortByTime(a, b)
        return a.barrack_upgrade_time < b.barrack_upgrade_time
    end
    table.sort(on_update_barracks, sortByTime)
    table.sort(ready_barracks, sortByTime)

    for k, v in pairs(on_update_barracks) do
        table.insert(result, v)
    end
    for k, v in pairs(ready_barracks) do
        table.insert(result, v)
    end

    for i = 1, max_count do
        local cell = nil
        if result[i] ~= nil then
            cell = state_machine.excute("build_up_scientific_ing_cell_cell_create", 0, {i, result[i], _ED.barracks_info[""..result[i].id]})
        else
            cell = state_machine.excute("build_up_scientific_ing_cell_cell_create", 0, {i, nil, nil})
        end
        ListView_build_up_scientific:addChild(cell)
    end
    ListView_build_up_scientific:requestRefreshView()

    -- 科技列表
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    for i = 1, 3 do
        local cell = state_machine.excute("build_up_scientific_classify_cell_create", 0, {i})
        self._list_view:addChild(cell)
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

-- 刷新研究列表
function BuildUpScientific:updateBarracks()
    if __lua_project_id == __lua_project_pacific_rim then
        self:updateBarracksEx()
        return
    end
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    local on_update_barracks = {}       -- 正在升级的科技
    local ready_barracks = {}           -- 等待中的科技
    local can_update_barracks = {}      -- 资源足够升级的科技
    local cannot_update_barracks = {}   -- 资源不足升级的科技
    local lock_barracks = {}            -- 未解锁科技
    local lave_info_table = {}
    for k, v in pairs(_ED.base_barracks_info) do
        local barrack_info = _ED.barracks_info[""..k]
        if barrack_info ~= nil then     -- 已解锁
            if zstring.tonumber(barrack_info.barrack_state) == 1 then    -- 升级中
                v.barrack_upgrade_time = zstring.tonumber(barrack_info.barrack_upgrade_time)
                v.barrack_level = zstring.tonumber(barrack_info.barrack_level)
                table.insert(on_update_barracks, v)
            elseif zstring.tonumber(barrack_info.barrack_state) == 2 then    -- 等待中
                v.barrack_upgrade_time = zstring.tonumber(barrack_info.barrack_upgrade_time)
                v.barrack_level = zstring.tonumber(barrack_info.barrack_level)
                table.insert(ready_barracks, v)
            elseif self:isCanUpdateBarracks(v, barrack_info.barrack_level) == true then  -- 资源足够
                table.insert(can_update_barracks, v)
            else                                                                    -- 资源不足
                lave_info_table = self:isCanConsumeGold(v, barrack_info.barrack_level)
                table.insert(cannot_update_barracks, v)
            end    
        else                                        -- 未解锁
            table.insert(lock_barracks, v)
        end
    end

    function sortByTime(a, b)
        return a.barrack_upgrade_time < b.barrack_upgrade_time
    end

    function sortByOrder(a, b)
        return a.order < b.order
    end

    function sortByLevel(a, b)
        return a.open_level < b.open_level
    end

    table.sort(on_update_barracks, sortByTime)
    table.sort(ready_barracks, sortByTime)
    table.sort(can_update_barracks, sortByOrder)
    table.sort(cannot_update_barracks, sortByOrder)
    table.sort(lock_barracks, sortByLevel)

    --计算科技飙升活动加层
    if _ED.activity_info["85"] ~= nil then
        local timesData = zstring.split(_ED.activity_info["85"].activity_add_state, ",")
        self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    else
        self.m_times = 0
    end

    local count = 0
    for i, v in pairs(on_update_barracks) do
        local cell = state_machine.excute("build_up_scientific_ing_cell_cell_create", 0, {i + count, v, _ED.barracks_info[""..v.id]})
        self._list_view:addChild(cell)
    end
    count = count + #on_update_barracks
    for i, v in pairs(ready_barracks) do
        local cell = state_machine.excute("build_up_scientific_ing_cell_cell_create", 0, {i + count, v, _ED.barracks_info[""..v.id]})
        self._list_view:addChild(cell)
    end
    count = count + #ready_barracks
    for i, v in pairs(can_update_barracks) do
        local cell = state_machine.excute("build_up_scientific_cell_create", 0, {i + count, v, _ED.barracks_info[""..v.id], true,lave_info_table,self.m_times})
        self._list_view:addChild(cell)
    end
    count = count + #can_update_barracks
    for i, v in pairs(cannot_update_barracks) do
        local cell = state_machine.excute("build_up_scientific_cell_create", 0, {i + count, v, _ED.barracks_info[""..v.id], false,lave_info_table,self.m_times})
        self._list_view:addChild(cell)
    end
    count = count + #cannot_update_barracks
    for i, v in pairs(lock_barracks) do
        local cell = state_machine.excute("build_up_scientific_rock_cell_create", 0, {i + count, v})
        self._list_view:addChild(cell)
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

-- 检查是否有足够的资源升级科技
function BuildUpScientific:isCanUpdateBarracks(barracks_info, level)
    --计算科技飙升活动加层
    local activity_discount = 1
    local talentInfo = dms.string(dms["talent_mould"],barracks_info.gift, talent_mould.base_additional)
    local infoArry = zstring.split(talentInfo,"|")
    local currType = zstring.split(infoArry[1],",")
    if _ED.activity_info["85"] ~= nil and tonumber(currType[1]) == 59 then
        local timesData = zstring.split(_ED.activity_info["85"].activity_add_state, ",")
        local m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if m_times > 0 then
            activity_discount = tonumber(timesData[3])
        end
    end

    local barracks_level_info = _ED.base_barracks_level_info[""..level]
    local cost_iron = barracks_info.cost_iron_factor * barracks_level_info.cost_iron * activity_discount
    local cost_oil = barracks_info.cost_oil_factor * barracks_level_info.cost_oil * activity_discount
    local cost_lead = barracks_info.cost_lead_factor * barracks_level_info.cost_lead * activity_discount
    local cost_tita = barracks_info.cost_tita_factor * barracks_level_info.cost_tita * activity_discount
    local cost_gem = barracks_info.cost_gem_factor * barracks_level_info.cost_gem * activity_discount

    if _ED.home_build["3"].level < (level + 1)
        or tonumber(_ED.user_info.credit_level) < (level + 1)
        or tonumber(_ED.user_info.user_iron) < cost_iron
        or tonumber(_ED.user_info.oil_field) < cost_oil
        or tonumber(_ED.user_info.exploits) < cost_lead
        or tonumber(_ED.user_info.tiger_shaped) < cost_tita
        or tonumber(_ED.user_info.user_silver) < cost_gem
        then
        return false
    end
    return true
end

-- 检查消耗多少金币
function BuildUpScientific:isCanConsumeGold(barracks_info, level)
    local barracks_level_info = _ED.base_barracks_level_info[""..level]
    local cost_iron = barracks_info.cost_iron_factor * barracks_level_info.cost_iron
    local cost_oil = barracks_info.cost_oil_factor * barracks_level_info.cost_oil
    local cost_lead = barracks_info.cost_lead_factor * barracks_level_info.cost_lead
    local cost_tita = barracks_info.cost_tita_factor * barracks_level_info.cost_tita
    local cost_gem = barracks_info.cost_gem_factor * barracks_level_info.cost_gem

    local lave_info = {cost_iron - _ED.user_info.user_iron ,
                    cost_oil - _ED.user_info.oil_field,
                    cost_lead - _ED.user_info.exploits,
                    cost_tita - _ED.user_info.tiger_shaped,
                    cost_gem - _ED.user_info.user_silver,}
    local lave_info_table = {}
    for i,v in pairs(lave_info) do
        if v > 0 then
            table.insert(lave_info_table, v) 
        end
    end
    return lave_info_table
end

function BuildUpScientific:getNowBuildState()
    return zstring.tonumber(_ED.home_build[""..self._build_id].update_state) -- 1 正在升级 2 升级结束了
end

function BuildUpScientific:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("build_up_scientific_to_update_draw",0,"")
        end
    end
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
                local persent = math.floor((max_time - leave_time) * 100 / max_time)
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
                    state_machine.excute("build_up_scientific_to_update_draw", 0, "")
                end
                self._loading_bar:setVisible(false)
                self._text_time:setVisible(false)
                self._update_image:setVisible(false)
            end
        end
    end

    if self._last_page_index ~= 1 and self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_scientific_arrow_down:setVisible(true)
        else
            self._Image_scientific_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_scientific_arrow_up:setVisible(true)
        else
            self._Image_scientific_arrow_up:setVisible(false)
        end
        if self._need_update == true then
            self._need_update = false
            return
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

--初始化
function BuildUpScientific:init(build_id, page)
    self._build_id = build_id
    self._base_build_info = _ED.base_build_info[""..build_id]
    self._last_page_index = page
    self:setTouchEnabled(true)
    self:onInit()
end

--移除状态机
function BuildUpScientific:onExit()
    state_machine.remove("build_up_scientific_window_show")
    state_machine.remove("build_up_scientific_window_hide")
    state_machine.remove("build_up_scientific_change_to_build_page")
    state_machine.remove("build_up_scientific_change_to_introduce_page")
    state_machine.remove("build_up_scientific_to_up")
    state_machine.remove("build_up_scientific_to_add_speed")
    state_machine.remove("build_up_scientific_to_cancel")
    state_machine.remove("build_up_scientific_to_update_draw")
    state_machine.remove("build_up_scientific_activity_rule_infor")
end