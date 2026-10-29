PersonalFightBuildCell = class("PersonalFightBuildCellClass", Window)

local personal_fight_build_cell_create_terminal = {
    _name = "personal_fight_build_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local build_id = params[1]
        local pos_x = params[2]
        local pos_y = params[3]
        local panel = params[4]
        local cell = PersonalFightBuildCell:new()
        cell:init(build_id,pos_x,pos_y,panel)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(personal_fight_build_cell_create_terminal)
state_machine.init()

function PersonalFightBuildCell:ctor()
	self.super:ctor()
    self.roots = {}
    self.build_id = nil
    self.actions = {}

    self.update_panel = nil
    self.loading_bar = nil
    self.text_time = nil
    self.last_time = nil
    -- 距离收取剩余时间
    self.Text_build_res_time = nil
    self.last_resource = nil
    self.last_build_level = nil
    self._isPlayUpgrade = false
    -- 收取倒计时
    self._panel_res_time = nil

    local function init_personal_fight_build_cell_terminal()
        local personal_fight_build_cell_open_window_terminal = {
            _name = "personal_fight_build_cell_open_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local fun_open_tab_id = dms.int(dms["build_mould"],cell.build_id,build_mould.fun_open_tab_id)
                if funOpenDrawTipEX(fun_open_tab_id) == true then
                    return
                end
                if cell.build_id == 19 then
                    state_machine.excute("build_level_up_window_open", 0, {cell.build_id})
                else
                    local update_id = dms.int(dms["build_mould"], cell.build_id, build_mould.update_id)
                    local build_info = _ED.home_build[""..cell.build_id]
                    local build_level = zstring.tonumber(build_info.level)
                    local info = _ED.build_escalate_info[""..update_id][""..build_level]
                    local max_volumn = zstring.tonumber(info.max_volumn)
                    local output_count = zstring.tonumber(info.output_count)
                    local output_time = zstring.tonumber(info.output_time)

                    if tonumber(build_info.output_start_time) > 0 
                        and math.floor((os.time() + _ED.time_add_or_sub - tonumber(build_info.output_start_time))/3600 * output_count) >= max_volumn 
                        and tonumber(build_info.level) > 1 then
                        local function recruitCallBack(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if response.node ~= nil and response.node.getResource ~= nil then
                                    response.node:getResource()
                                    state_machine.excute("personal_fight_main_update_info",0,nil)
                                end
                            end
                        end
                        if cell.build_id == 22 then
                            cell.last_resource = _ED.user_info.user_iron
                        elseif cell.build_id == 20 then
                            cell.last_resource = _ED.user_info.user_silver
                        elseif cell.build_id == 24 then
                            cell.last_resource = _ED.user_info.jade
                        end
                        protocol_command.get_home_resource.param_list = _ED.home_build[""..cell.build_id].id
                        NetworkManager:register(protocol_command.get_home_resource.code, nil, nil, nil, cell, recruitCallBack, false, nil)
                    else
                        state_machine.excute("build_level_up_window_open", 0, {cell.build_id})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 刷新等级
        local personal_fight_build_cell_update_level_terminal = {
            _name = "personal_fight_build_cell_update_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params
                if cell ~= nil and cell.updateDrawLevel ~= nil then
                    cell:updateDrawLevel()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(personal_fight_build_cell_update_level_terminal)
        state_machine.add(personal_fight_build_cell_open_window_terminal)
        state_machine.init()
    end

    init_personal_fight_build_cell_terminal()
end

function PersonalFightBuildCell:getResource()
    local root = self.roots[1]
    local Text_get_number = ccui.Helper:seekWidgetByName(root,"Text_get_number")
    local add_number = 0
    if self.build_id == 22 then
        add_number = tonumber(_ED.user_info.user_iron) - tonumber(self.last_resource)
    elseif self.build_id == 20 then
        add_number = tonumber(_ED.user_info.user_silver) - tonumber(self.last_resource)
    elseif self.build_id == 24 then
        add_number = tonumber(_ED.user_info.jade) - tonumber(self.last_resource)
    end
    Text_get_number:setString(add_number)

    local Panel_home_build_up = ccui.Helper:seekWidgetByName(root,"Panel_home_build_up")
    Panel_home_build_up:setVisible(true)
    local Text_get_number = ccui.Helper:seekWidgetByName(root,"Text_get_number")
    Text_get_number:setVisible(true)
    local Panel_home_up_get = ccui.Helper:seekWidgetByName(root,"Panel_home_up_get")
    Panel_home_up_get:removeAllChildren(true)
    local Panel_home_build_cell_t = ccui.Helper:seekWidgetByName(root,"Panel_home_build_cell_t")
    Panel_home_build_cell_t:setVisible(false)

    local update_id = dms.int(dms["build_mould"],self.build_id,build_mould.update_id)
    local build_level = zstring.tonumber(_ED.home_build[""..self.build_id].level)
    local max_volumn = _ED.build_escalate_info[""..update_id][""..build_level].max_volumn
    if self.build_id >= 11 then -- 铜币
        playEffect(formatMusicFile("effect", 9992))
    else -- 铁矿
        playEffect(formatMusicFile("effect", 9993))
    end 
    local action = self.actions[1]
    action:play("Text_get_number_anmi",false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "Text_get_number_anmi_over" then
            action:play("push_anmi",true)
            Text_get_number:setVisible(false)
            Panel_home_build_cell_t._istips = false
        end
    end)
end

function PersonalFightBuildCell:updateDrawLevel()
    local root = self.roots[1]
    local Text_home_build_cell_lv = ccui.Helper:seekWidgetByName(root,"Text_home_build_cell_lv")
    local build_lv = _ED.home_build[""..self.build_id].level
    Text_home_build_cell_lv:setString(tonumber(build_lv) - 1)

    if tonumber(build_lv) > 1 then
        local Button_home_build = ccui.Helper:seekWidgetByName(root, "Button_home_build")
        local pic = dms.string(dms["build_mould"],self.build_id,build_mould.pic)
        local button_name = string.format(config_res.images.ui.home.home_building_png,_ED.user_info.user_force) .."_"..pic..".png"
        local sprites = cc.Sprite:create(button_name)
        Button_home_build:loadTextures(button_name,button_name,button_name)
        Button_home_build:setContentSize(cc.size(sprites:getContentSize().width,sprites:getContentSize().height))
        if tonumber(build_lv) == 2 then
            self:updateDraw()
        end
    end

    if _ED.home_build[""..self.build_id] ~= nil and self.last_build_level ~= zstring.tonumber(_ED.home_build[""..self.build_id].level) then
        local Panel_home_up_success = ccui.Helper:seekWidgetByName(root, "Panel_home_up_success")
        local ArmatureNode_up = Panel_home_up_success:getChildByName("ArmatureNode_up")
        local animation = ArmatureNode_up:getAnimation()
        local AnimationEventCallFunc = function()
             Panel_home_up_success:setVisible(false)
        end 
        animation:playWithIndex(0, 0, 0)
        animation:setMovementEventCallFunc(AnimationEventCallFunc)
        Panel_home_up_success:setVisible(true)
    end
    self._isPlayUpgrade = false
end

function PersonalFightBuildCell:updateDraw()
    local root = self.roots[1]
    local Button_home_build = ccui.Helper:seekWidgetByName(root, "Button_home_build")
    local pic = dms.string(dms["build_mould"], self.build_id, build_mould.pic)
    local button_name = config_res.images.ui.home.home_building_png.."_"..pic..".png"
    local sprites = cc.Sprite:create(button_name)
    Button_home_build:loadTextures(button_name, button_name, button_name)
    Button_home_build:setContentSize(cc.size(sprites:getContentSize().width,sprites:getContentSize().height))
    local Panel_home_build_cell_name_bg = ccui.Helper:seekWidgetByName(root,"Panel_home_build_cell_name_bg")
    local Panel_home_build_cell_lv = ccui.Helper:seekWidgetByName(root,"Panel_home_build_cell_lv")
    local Text_home_build_cell_name = ccui.Helper:seekWidgetByName(root,"Text_home_build_cell_name")
    local Text_home_build_cell_lv = ccui.Helper:seekWidgetByName(root,"Text_home_build_cell_lv")
    local name = dms.string(dms["build_mould"],self.build_id,build_mould.build_name)
    Text_home_build_cell_name:setString(name)
    local Panel_res_time = ccui.Helper:seekWidgetByName(root,"Panel_res_time")
    self._panel_res_time = Panel_res_time
    local show_level_test = true
    local update_id = dms.int(dms["build_mould"], self.build_id, build_mould.update_id)
    if update_id == -1 then
        show_level_test = false
    end

    local isShowTip = true
    local fun_open_tab_id = dms.int(dms["build_mould"],self.build_id,build_mould.fun_open_tab_id)
    Panel_home_build_cell_lv:setVisible(show_level_test)
    if funOpenDrawTipEX(fun_open_tab_id,false) == true then  
        Panel_home_build_cell_lv:setVisible(false)
        Panel_home_build_cell_name_bg:setVisible(false)
        isShowTip = false
        button_name = string.format(config_res.images.ui.home.home_building_png,_ED.user_info.user_force) .."_"..pic.."_0.png"
        if cc.FileUtils:getInstance():isFileExist(button_name) == true then
            sprites = cc.Sprite:create(button_name)
            Button_home_build:loadTextures(button_name,button_name,button_name)
            Button_home_build:setContentSize(cc.size(sprites:getContentSize().width,sprites:getContentSize().height))
        end
        Panel_res_time:setVisible(false)
    else
        Panel_home_build_cell_name_bg:setVisible(true)
        if dms.int(dms["build_mould"],self.build_id,build_mould.update_id) == -1 then 
            Panel_home_build_cell_lv:setVisible(false)
        else
            Panel_home_build_cell_lv:setVisible(true)
            if _ED.home_build[""..self.build_id] ~= nil then
                if self.build_id ~= 19 then
                    Panel_res_time:setVisible(true)
                end
                local build_lv = _ED.home_build[""..self.build_id].level
                Text_home_build_cell_lv:setString(tonumber(build_lv) - 1)
                if tonumber(build_lv) <= 1 then
                    isShowTip = false
                    Panel_res_time:setVisible(false)
                    button_name = string.format(config_res.images.ui.home.home_building_png,_ED.user_info.user_force) .."_"..pic.."_0.png"
                    if cc.FileUtils:getInstance():isFileExist(button_name) == true then
                        if funOpenDrawTipEX(fun_open_tab_id,false) == false then
                            isShowTip = true
                        end
                        Panel_home_build_cell_lv:setVisible(false)
                        Panel_home_build_cell_name_bg:setVisible(false)
                        sprites = cc.Sprite:create(button_name)
                        Button_home_build:loadTextures(button_name,button_name,button_name)
                        Button_home_build:setContentSize(cc.size(sprites:getContentSize().width,sprites:getContentSize().height))
                    end
                end
            else
                Text_home_build_cell_lv:setString("")
            end
        end
    end

    local Panel_home_build_cell_t = ccui.Helper:seekWidgetByName(root,"Panel_home_build_cell_t")
    local Panel_home_build_cell_t_icon = ccui.Helper:seekWidgetByName(root,"Panel_home_build_cell_t_icon")
    local Image_home_build_cell_t = ccui.Helper:seekWidgetByName(root,"Image_home_build_cell_t")
    -- 推送箭头动画资源加载
    for i, v in pairs(config_res.sprites_cached["push_arrows"]) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
    end
    if isShowTip == true then
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_build_resouce_canget",
            _widget = Panel_home_build_cell_t,
            _panel_animation = Panel_home_build_cell_t_icon,
            _image = Image_home_build_cell_t,
            _buildID = self.build_id,
            _pic_id = pic,
            _invoke = nil,
            _interval = 0.5,})   
    end

    local Panel_home_build_cell_up = ccui.Helper:seekWidgetByName(root,"Panel_home_build_cell_up")
    local LoadingBar_home_build_cell_up = ccui.Helper:seekWidgetByName(root,"LoadingBar_home_build_cell_up")
    local Text_home_build_cell_up_time = ccui.Helper:seekWidgetByName(root,"Text_home_build_cell_up_time")
    self.Text_build_res_time = ccui.Helper:seekWidgetByName(root,"Text_build_res_time")

    self.update_panel = Panel_home_build_cell_up
    self.loading_bar = LoadingBar_home_build_cell_up
    self.text_time = Text_home_build_cell_up_time
end

function PersonalFightBuildCell:formatTimeString(_time)    --系统时间转换
    local timeString = ""
    local now_time = math.max(tonumber(_time),0)
    timeString = timeString .. string.format("%02d", math.floor(now_time/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))
    return timeString
end

function PersonalFightBuildCell:playUpgradeEffect( ... )
    if self._isPlayUpgrade == true then
        return
    end
    self._isPlayUpgrade = true
    local root = self.roots[1]
    local Panel_home_build_cell_up = ccui.Helper:seekWidgetByName(root, "Panel_home_build_cell_up")
    local ArmatureNode_14 = Panel_home_build_cell_up:getChildByName("ArmatureNode_14")
    local animation = ArmatureNode_14:getAnimation()
    draw.initArmature(ArmatureNode_14, nil, -1, 0, 1)
    ArmatureNode_14._invoke = function(armatureBack)
        csb.animationChangeToAction(armatureBack, 1, 1, false)
    end
    csb.animationChangeToAction(ArmatureNode_14, 0, 0, false)
end

function PersonalFightBuildCell:onUpdate(dt)
    if self.update_id == -1 then
        return
    end
    if _ED.home_build[""..self.build_id] == nil then
        return
    end
    if self.text_time ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 then 
            self.last_time = now_time  
            if zstring.tonumber(_ED.home_build[""..self.build_id].update_state) == 1 then
                local level = zstring.tonumber(_ED.home_build[""..self.build_id].level)
                local max_time = zstring.tonumber(_ED.build_escalate_info[""..self.update_id][""..level].consume_time)
                self.update_panel:setVisible(true)
                local leave_time = max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - _ED.home_build[""..self.build_id].update_start_time))
                if leave_time >= 0 then
                    self.text_time:setString(self:formatTimeString(leave_time))
                end
                local persent = 0
                persent = math.floor((max_time - leave_time) / max_time *100)
                self:playUpgradeEffect()
                self.loading_bar:setPercent(persent)
                if leave_time <= 0 then
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                state_machine.excute("personal_fight_main_update",0,(response.node.build_id - 18))
                                response.node:updateDraw()
                            end
                            playEffect(formatMusicFile("effect", 10013))
                            state_machine.excute("build_level_up_onupdate",0,"")
                            -- state_machine.excute("personal_fight_main_update_info",0,nil)
                        else
                            state_machine.excute("personal_fight_main_update_build", 0, nil)
                        end
                    end
                    self.update_panel:setVisible(false)
                    protocol_command.build_check_up.param_list = _ED.home_build[""..self.build_id].id
                    NetworkManager:register(protocol_command.build_check_up.code, nil, nil, nil, self, responseCallback, false, nil)
                    return
                end
            else
                self.update_panel:setVisible(false)
            end
            local build_info = _ED.home_build[""..self.build_id]
            if tonumber(build_info.level) > 1
                and tonumber(build_info.output_start_time) > 0 then
                local build_level = zstring.tonumber(build_info.level)
                local info = _ED.build_escalate_info[""..self.update_id][""..build_level]
                local max_volumn = zstring.tonumber(info.max_volumn)
                local output_count = zstring.tonumber(info.output_count)
                local output_time = zstring.tonumber(info.output_time)
                local time = (max_volumn/output_count)*3600 - (now_time + _ED.time_add_or_sub - tonumber(build_info.output_start_time))
                if time > 0 then 
                    self._panel_res_time:setVisible(true)
                    self.Text_build_res_time:setString(self:formatTimeString(time))
                else
                    self._panel_res_time:setVisible(false)
                end
            end
        end
    end
end

function PersonalFightBuildCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.palyer_build.player_build_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root) 
    table.insert(self.roots, root) 

    local action = csb.createTimeline(config_csb.cells.palyer_build.player_build_cell)
    table.insert(self.actions,action)
    action:setTimeSpeed(app.getTimeSpeed())
    action:play("push_anmi", true)
    root:runAction(action)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_home_build"), nil, 
    {
        terminal_name = "personal_fight_build_cell_open_window", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 2)

    self:updateDraw()
end

function PersonalFightBuildCell:onEnterTransitionFinish()
end

function PersonalFightBuildCell:init(build_id,pos_x,pos_y,panel)
    self.build_id = build_id + 18
    self.pos_x = pos_x
    self.pos_y = pos_y
    self._panel_city = panel
    self.update_id = dms.int(dms["build_mould"],self.build_id,build_mould.update_id)
    if _ED.home_build[""..self.build_id] ~= nil then
        self.last_build_level = zstring.tonumber(_ED.home_build[""..self.build_id].level)
    end
    self:onInit()
end

function PersonalFightBuildCell:onExit()

end