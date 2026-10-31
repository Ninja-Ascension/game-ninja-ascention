-- ------------------------------------------------------------------------------------------------------------
--  说明：坦克生产
-- ------------------------------------------------------------------------------------------------------------
BuildUpTankProduction = class("BuildUpTankProductionClass", Window)

--打开界面
local build_up_tank_production_window_open_terminal = {
    _name = "build_up_tank_production_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("BuildUpTankProductionClass") == nil then
            local from_type = params[1]
            local tank_info = params[2]
            local can_production = params[3]
            local ship = params[4]
            local is_share = params[5]
            local _win = BuildUpTankProduction:new()
            _win:init(from_type, tank_info, can_production, ship, is_share)
            fwin:open(_win, fwin._ui)
        end
        local platformFbMethodWindow = fwin:find("platformFbMethodClass") 
        if platformFbMethodWindow ~= nil and platformFbMethodWindow:isVisible() == true then
            platformFbMethodWindow:setVisible(false)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local build_up_tank_production_window_close_terminal = {
    _name = "build_up_tank_production_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildUpTankProductionClass"))

        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
        local platformFbMethodWindow = fwin:find("platformFbMethodClass") 
        if platformFbMethodWindow ~= nil and platformFbMethodWindow:isVisible() == false then
            platformFbMethodWindow:setVisible(true)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_tank_production_window_open_terminal)
state_machine.add(build_up_tank_production_window_close_terminal)
state_machine.init()

function BuildUpTankProduction:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.last_time = nil
    -- 1属性，2生产
    self._last_page_index = 2
    self._pages = {}

    self._from_type = 1

    self._ship = nil            -- 非空时查看部队实际属性

    self._telent_id = nil       -- 红色坦克技能id

    self._activity_type = 0

    --load lua file
    app.load("client.red_alert_time.build_up.BuildUpTankProductionProc")
    app.load("client.red_alert_time.build_up.BuildUpTankProductionAttr")
    app.load("client.red_alert_time.build_up.BuildUpTankProductionSkillInfo")
     -- Initialize alert_home state machine.
    local function init_build_up_tank_production_terminal()

        --显示所有
        local build_up_tank_production_window_show_terminal = {
            _name = "build_up_tank_production_window_show",
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
        local build_up_tank_production_window_hide_terminal = {
            _name = "build_up_tank_production_window_hide",
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
        -- 切换页面
        local build_up_tank_production_change_page_terminal = {
            _name = "build_up_tank_production_change_page",
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
		
		-- 打开分享
        local build_up_tank_production_open_share_terminal = {
            _name = "build_up_tank_production_open_share",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(true)
                Panel_share_close:setVisible(true)
                Animations_PlayOpenMainUI({Panel_share}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_SLIDE_DOWN, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 关闭分享
        local build_up_tank_production_close_share_terminal = {
            _name = "build_up_tank_production_close_share",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(false)
                Panel_share_close:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		-- 分享到聊天
        local build_up_tank_production_share_chat_terminal = {
            _name = "build_up_tank_production_share_chat",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(params._datas.chat_type) == 14 then
                    if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                        state_machine.excute("build_up_tank_production_close_share", 0, 0)          
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("build_up_tank_production_close_share", 0, 0)          
                    return
                end 
				local function responseSendMessageCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("build_up_tank_production_close_share", 0, 0)						
						TipDlg.drawTextDailog(game_share_tip_text[1])
					end
				end
				local datas = dms.string(dms["message_share"], 3, message_share.content)
				local tank_data = dms.element(dms["ship_mould"], instance._tank_info.tank_id)
				local tank_name = dms.atos(tank_data, ship_mould.captain_name)        -- 名称
				local quality = dms.atoi(tank_data, ship_mould.ship_type)              -- 品质
				local mine_info = "|"..quality.."|"..tank_name
				local data1 =  string.gsub(datas, "!x@", mine_info)
                -- local paramsInfo = mine_info
                local paramsInfo = "1-1-"..instance._tank_info.tank_id..","..mine_info

				datas = ""--data1
                local ship = instance._ship
                if ship == nil then
                    ship = getShipByTemplateId(instance._tank_info.tank_id)
                end

				local str =datas..chat_section[1].."2".."|"..ship.ship_template_id..","..ship.ship_health..","..ship.ship_courage..","..ship.attack_speed..","..ship.crit
					..","..ship.wreck..","..ship.toughness..","..ship.block..","..ship.hit..","..ship.dodge
				
                str = zstring.exchangeTo(str)
                protocol_command.send_message.param_list = str.."\r\n"..params._datas.chat_type.. "\r\n0\r\n3\r\n"..paramsInfo
				-- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, instance, responseSendMessageCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 查看技能
        local build_up_tank_production_skill_info_terminal = {
            _name = "build_up_tank_production_skill_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._telent_id ~= nil then
                    state_machine.excute("build_up_tank_production_skill_info_window_open", 0, {instance._telent_id})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local build_up_tank_production_activity_rule_infor_terminal = {
            _name = "build_up_tank_production_activity_rule_infor",
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

        state_machine.add(build_up_tank_production_window_show_terminal)
        state_machine.add(build_up_tank_production_window_hide_terminal)   
        state_machine.add(build_up_tank_production_change_page_terminal)   
        state_machine.add(build_up_tank_production_open_share_terminal)   
        state_machine.add(build_up_tank_production_close_share_terminal)   
        state_machine.add(build_up_tank_production_share_chat_terminal)   
        state_machine.add(build_up_tank_production_skill_info_terminal)   
        state_machine.add(build_up_tank_production_activity_rule_infor_terminal)   
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_build_up_tank_production_terminal()

end

--显示
function BuildUpTankProduction:onShow()
   self:setVisible(true)
end

--隐藏
function BuildUpTankProduction:onHide()
   self:setVisible(false)
end

--初始化界面
function BuildUpTankProduction:onInit()
    local csbItem = csb.createNode(config_csb.build_up.build_up_tank_production)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "build_up_tank_production_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "build_up_tank_production_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 属性
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_attribute"), nil, 
    {
        terminal_name = "build_up_tank_production_change_page", 
        terminal_state = 0, 
        index = 1,
    }, nil, 1)    
    -- 生产
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_production"), nil, 
    {
        terminal_name = "build_up_tank_production_change_page", 
        terminal_state = 0, 
        index = 2,
    }, nil, 1)    

	--打开分享
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share"), nil, 
    {
        terminal_name = "build_up_tank_production_open_share", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        index = 2,
    }, nil, 1)    
	
	--关闭分享
	ccui.Helper:seekWidgetByName(root,"Panel_share_close"):setSwallowTouches(false)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_share_close"), nil, 
    {
        terminal_name = "build_up_tank_production_close_share", 
        terminal_state = 0, 
    }, nil, 1)    
	
	--分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_legion_chat"), nil, 
    {
        terminal_name = "build_up_tank_production_share_chat", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 14,
    }, nil, 1)    
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_world_chat"), nil, 
    {
        terminal_name = "build_up_tank_production_share_chat", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 13,
    }, nil, 1)

    -- 查看技能
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_skille_effice_icon"), nil, 
    {
        terminal_name = "build_up_tank_production_skill_info", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    -- 活动规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build_up_res_act"), nil, 
    {
        terminal_name = "build_up_tank_production_activity_rule_infor",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,1) 
	
    self:onUpdateDraw()

end

-- 显示信息
function BuildUpTankProduction:onUpdateDraw()
    local root = self.roots[1]
    local Text_tank_name = ccui.Helper:seekWidgetByName(root, "Text_tank_name")
    local Text_tank_restrain = ccui.Helper:seekWidgetByName(root, "Text_tank_restrain")
    local Text_num_n = ccui.Helper:seekWidgetByName(root, "Text_num_n")
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root, "Panel_tank_icon")

    local tank_data = dms.element(dms["ship_mould"], self._tank_info.tank_id)
    local tank_name = dms.atos(tank_data, ship_mould.captain_name)        -- 名称
    local pic = dms.atoi(tank_data, ship_mould.All_icon)                    -- 图标
    local quality = dms.atoi(tank_data, ship_mould.ship_type)              -- 品质
    local restrain = dms.atos(tank_data, ship_mould.skill_name)              -- 克制描述
    local range = dms.atoi(tank_data, ship_mould.sign_msg)

    Text_tank_name:setString(tank_name)
    Text_tank_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))

    local count = 0
    if self._tank_info.count ~= nil then
        count = self._tank_info.count
    else
        local tank_data = getShipByTemplateId(self._tank_info.tank_id)
        if tank_data ~= nil then
            count = tonumber(tank_data.current_count)
        end
    end
    
    Panel_tank_icon:removeBackGroundImage()
    Panel_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic))
    Text_num_n:setString(count)
    Text_tank_restrain:setString(restrain)

    local Button_attribute = ccui.Helper:seekWidgetByName(root, "Button_attribute")
    local Button_production = ccui.Helper:seekWidgetByName(root, "Button_production")

    if self._can_production == true then
        if Button_attribute ~= nil then
            Button_attribute:setVisible(true)
        end
        if Button_production ~= nil then
            Button_production:setVisible(true)
        end
        self._last_page_index = 2
    else
        if Button_attribute ~= nil then
            Button_attribute:setVisible(false)
        end
        if Button_production ~= nil then
            Button_production:setVisible(false)
        end
        self._last_page_index = 1
    end

    -- 分享
    local Button_share = ccui.Helper:seekWidgetByName(root, "Button_share")
    if tonumber(count) > 0 and self._is_share ~= true then
        Button_share:setVisible(true)
    else
        Button_share:setVisible(false)
    end

    local Panel_troops_stye = ccui.Helper:seekWidgetByName(root, "Panel_troops_stye")
    if Panel_troops_stye ~= nil then
        Panel_troops_stye:removeBackGroundImage()
        Panel_troops_stye:setBackGroundImage(string.format(config_res.images.ui.share.troops_stye, range))
    end

    local Panel_troops_box_bg = ccui.Helper:seekWidgetByName(root, "Panel_troops_box_bg")
    if Panel_troops_box_bg ~= nil then
        Panel_troops_box_bg:setBackGroundImage(string.format(config_res.images.ui.icon.icon, 200 + quality))
    end
    -- 红色坦克技能
    local Panel_skille_effice_icon = ccui.Helper:seekWidgetByName(root, "Panel_skille_effice_icon")
    if Panel_skille_effice_icon ~= nil then
        local talent_ids = zstring.split(dms.string(dms["ship_mould"], self._tank_info.tank_id, ship_mould.talent_id), "|")   
        local telent_id = 0
        for k, info in pairs(talent_ids) do
            local temp_telent = zstring.split(info, ",")
            local telent_type = tonumber(temp_telent[1])
            if telent_type == 1 then
                telent_id = tonumber(temp_telent[3])
            end
        end
        if telent_id > 0 then
            Panel_skille_effice_icon:setVisible(true)
            Panel_skille_effice_icon:removeBackGroundImage()
            local telent_pic = dms.string(dms["talent_mould"], telent_id, talent_mould.talent_pic)
            Panel_skille_effice_icon:setBackGroundImage(string.format(config_res.images.ui.skills.skills, telent_pic))
            self._telent_id = telent_id
        else
            Panel_skille_effice_icon:setVisible(false)
        end
    end

    -- 火力驱动活动标志
    local Button_build_up_res_act = ccui.Helper:seekWidgetByName(root,"Button_build_up_res_act")    
    if Button_build_up_res_act ~= nil then
        Button_build_up_res_act:setVisible(false)
        if self._can_production == true and _ED.activity_info ~= nil and _ED.activity_info["117"] ~= nil then
            local other_info = zstring.split(_ED.activity_info["117"].activity_add_state, "!")
            local timesData = zstring.split(other_info[1], ",")
            local leave_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
            if leave_times > 0 then
                local start_time = tonumber(timesData[1]/1000)
                local current_time = os.time() + _ED.time_add_or_sub
                local open_info = zstring.split(other_info[2], "|")
                if self._from_type == 3 then
                    open_info = zstring.split(open_info[4], ",")        -- 改造生产加速
                else
                    open_info = zstring.split(open_info[3], ",")        -- 坦克生产加速
                end
                if (current_time - start_time) > (tonumber(open_info[1])) * 3600 then
                    Button_build_up_res_act:setVisible(true)
                    self._activity_type = 117
                end
            end
        end
    end

    self:changePage()
end

function BuildUpTankProduction:changePage()
    local root = self.roots[1]
    local Text_res_build_name = ccui.Helper:seekWidgetByName(root, "Text_res_build_name")
    if Text_res_build_name ~= nil then
        Text_res_build_name:setString(tipStringInfo_tank_production_info[self._last_page_index])
    end

    local Button_attribute = ccui.Helper:seekWidgetByName(root, "Button_attribute")
    local Button_production = ccui.Helper:seekWidgetByName(root, "Button_production")
    local Panel_tab_box = ccui.Helper:seekWidgetByName(root, "Panel_tab_box")

    for k, v in pairs(self._pages) do
        v:setVisible(false)
    end

    if Button_attribute ~= nil then
        if self._last_page_index == 1 then
            Button_attribute:setHighlighted(true)
            Button_attribute:setTouchEnabled(false)
        else
            Button_attribute:setHighlighted(false)
            Button_attribute:setTouchEnabled(true)
        end
    end
          
    if Button_production ~= nil then
        if self._last_page_index == 1 then
            Button_production:setHighlighted(false)
            Button_production:setTouchEnabled(true)
        else
            Button_production:setHighlighted(true)
            Button_production:setTouchEnabled(false)
        end
    end  

    if self._last_page_index == 1 then
        if self._pages["1"] == nil then
            self._pages["1"] = state_machine.excute("build_up_tank_production_attr_window_open", 0, {Panel_tab_box, self._can_production, self._tank_info, self._ship})
        end
        self._pages["1"]:setVisible(true)
    else
        if self._pages["2"] == nil then
            self._pages["2"] = state_machine.excute("build_up_tank_production_proc_window_open", 0, {Panel_tab_box, self._from_type, self._tank_info})
        end
        self._pages["2"]:setVisible(true)
    end
end

function BuildUpTankProduction:onUpdate(dt)

end


--初始化
function BuildUpTankProduction:init(from_type, tank_info, can_production, ship, is_share)
    self._from_type = from_type
    self._tank_info = tank_info
    self._can_production = can_production
    self._ship = ship
    self._is_share = is_share
    self:onInit()
end


--移除状态机
function BuildUpTankProduction:onExit()
    state_machine.remove("build_up_tank_production_window_show")
    state_machine.remove("build_up_tank_production_window_hide")
    state_machine.remove("build_up_tank_production_change_page")
    state_machine.remove("build_up_tank_production_open_share")
    state_machine.remove("build_up_tank_production_close_share")
    state_machine.remove("build_up_tank_production_share_chat")
    state_machine.remove("build_up_tank_production_skill_info")
    state_machine.remove("build_up_tank_production_activity_rule_infor")
end  