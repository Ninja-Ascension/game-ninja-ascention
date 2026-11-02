--------------------------------------------------------------------------------------------------------------
--  说明：主页建筑控件项
--------------------------------------------------------------------------------------------------------------
HomeBuildCell = class("HomeBuildCellClass", Window)

--创建cell
local home_build_create_cell_terminal = {
    _name = "home_build_create_cell",
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
        local cell = HomeBuildCell:new()
        cell:init(build_id,pos_x,pos_y,panel)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(home_build_create_cell_terminal)
state_machine.init()

function HomeBuildCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.build_id = nil
    self.actions = {}

    self.update_panel = nil
    self.loading_bar = nil
    self.text_time = nil
    self.last_time = nil
    self.last_resource = nil
    self.last_build_level = nil
    self._isPlayUpgrade = false
    app.load("client.red_alert.recruit.HeroRecruit")
    app.load("client.red_alert.genral_choose.seven_star.SevenStar")
	 -- Initialize home_build_cell state machine.
    local function init_home_build_cell_terminal()
		
		--打开建筑响应窗口
		local home_build_cell_open_window_terminal = {
            _name = "home_build_cell_open_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if HomeBuildCell.touch_lock == true then
                    return
                end    
                local cell = params._datas.cell
                local fun_open_tab_id = dms.int(dms["build_mould"],cell.build_id,build_mould.fun_open_tab_id)

                if cell.build_id ~= 18 then
                    if missionIsOver() == true and funOpenDrawTip(fun_open_tab_id) == true then
                        return
                    end
                end
                
                -- print("=======对应建筑id========",cell.build_id)
            	if cell.build_id == 1 then -- 主城
                    state_machine.excute("home_select_action_window_open",0,{cell.build_id})
            	elseif cell.build_id == 2 then -- 兵营
                    state_machine.excute("home_select_action_window_open",0,{cell.build_id})
                elseif cell.build_id == 3 then -- 锻造室
                    state_machine.excute("home_select_action_window_open",0,{cell.build_id})
                elseif cell.build_id == 4 then -- 比武台
                    state_machine.excute("home_select_action_window_open",0,{cell.build_id})
                elseif cell.build_id == 5 then -- 军机处
                    TipDlg.drawTextDailog(_function_unopened_tip_string)
            	elseif cell.build_id == 6 then -- 酒馆
                    state_machine.excute("hero_recruit_window_open",0,"")
                elseif cell.build_id == 7 then -- 祭坛
                    state_machine.excute("fate_window_open",0,"")
                elseif cell.build_id == 8 then -- 秘宝商店
                    local function recruitCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("mystery_shop_window_open",0,"")            
                        end
                    end
                    if _ED.secret_shop_init_info.os_time == nil or _ED.secret_shop_init_info.os_time == "" then
                        NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
                    else
                        local times = os.time()- tonumber(_ED.secret_shop_init_info.os_time)
                        local leave_time = _ED.secret_shop_init_info.refresh_time/1000-times
                        if leave_time <= 0 then
                            NetworkManager:register(protocol_command.secret_shop_init.code, nil, nil, nil, self, recruitCallBack, false, nil)
                        else
                            recruitCallBack({RESPONSE_SUCCESS = true,PROTOCOL_STATUS = 0})
                        end
                    end

                elseif cell.build_id >= 9 and cell.build_id <= 14 then -- 矿场1
                    if _ED.home_build[""..cell.build_id] ~= nil then
                        local result_time = os.time() + _ED.time_add_or_sub - _ED.home_build[""..cell.build_id].output_start_time
                        local build_level = zstring.tonumber(_ED.home_build[""..cell.build_id].level)
                        if result_time > 40 and build_level > 1 then
                            local update_id = dms.int(dms["build_mould"], cell.build_id, build_mould.update_id)
                            local info = _ED.build_escalate_info[""..update_id][""..build_level]
                            local output_count = tonumber(info.output_count)
                            local output_time = tonumber(info.output_time)
                            if output_count / output_time * result_time >= 1 then
                                local function recruitCallBack(response)
                                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                        if response.node ~= nil and response.node.getResource ~= nil then
                                            response.node:getResource()        
                                        end
                                    end
                                end
                                if cell.build_id <= 10 then
                                    cell.last_resource = _ED.user_info.user_iron
                                else
                                    cell.last_resource = _ED.user_info.user_silver
                                end
                                
                                protocol_command.get_home_resource.param_list = _ED.home_build[""..cell.build_id].id--实例id
                                NetworkManager:register(protocol_command.get_home_resource.code, nil, nil, nil, cell, recruitCallBack, false, nil)
                            else
                                state_machine.excute("build_level_up_window_open",0,{cell.build_id})
                            end
                        else
                            state_machine.excute("build_level_up_window_open",0,{cell.build_id})
                        end
                    end
                elseif cell.build_id == 15 then -- 点将台
                    -- TipDlg.drawTextDailog(_function_unopened_tip_string)
                    state_machine.excute("seven_star_window_open",0,"")
                elseif cell.build_id == 16 then -- 神兵冢
                    if _ED.god_weaponry_open_state == nil 
                        or tonumber(_ED.god_weaponry_open_state) ~= 0 then
                        state_machine.excute("home_select_action_window_open",0,{cell.build_id})
                    else
                        TipDlg.drawTextDailog(_function_unopened_tip_string)
                    end
                elseif cell.build_id == 17 then -- 马场
                    state_machine.excute("home_select_action_window_open",0,{cell.build_id})
                elseif cell.build_id == 18 then -- 个人领地
                    state_machine.excute("personal_fight_main_open", 0, nil)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        -- 刷新等级
        local home_build_cell_update_level_terminal = {
            _name = "home_build_cell_update_level",
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
        state_machine.add(home_build_cell_update_level_terminal)
		state_machine.add(home_build_cell_open_window_terminal)
        state_machine.init()
    end
    
    -- call func home_build_cell create state machine.
    init_home_build_cell_terminal()

end

function HomeBuildCell:getResource()
    -- 推送箭头动画资源加载
    for i, v in pairs(config_res.sprites_cached["push_arrows"]) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
    end
    -- 资源收取动画资源加载
    for i, v in pairs(config_res.sprites_cached["building_charge"]) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
    end
    for i, v in pairs(config_res.armatures_cached["building_charge"]) do
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v)
    end
    local root = self.roots[1]
    local Text_get_number = ccui.Helper:seekWidgetByName(root,"Text_get_number")
    local add_number = 0
    if self.build_id <= 10 then
        add_number = tonumber(_ED.user_info.user_iron) - tonumber(self.last_resource)
    else
        add_number = tonumber(_ED.user_info.user_silver) - tonumber(self.last_resource)
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
    local up_times = 0 
    if add_number >= tonumber(max_volumn)/2 then
        up_times = 5
    else
        up_times = 3
    end
    --删除
    local function removeDrawAntNumberFuncN(sender)
        sender:removeFromParent(true)
        Panel_home_up_get:removeAllChildren(true)
        -- state_machine.excute("battle_drop_pos_window_close", 0, 0)
    end
    local gold_x = 0
    local gold_y = 0
    local mine_x = 0
    local mine_y = 0
    local scrollView_x = nil
    local scrollView_y = nil
    local position_x = 0
    local position_y = 0
    if fwin:find("PlayerResourceClass")~= nil then
        gold_x = fwin:find("PlayerResourceClass")._gold_x
        gold_y = fwin:find("PlayerResourceClass")._gold_y
        mine_x = fwin:find("PlayerResourceClass")._mine_x
        mine_y = fwin:find("PlayerResourceClass")._mine_y
    end

    if fwin:find("MainWindowClass")~= nil then
        scrollView_x,scrollView_y = fwin:find("MainWindowClass"):scrollViewHomePosition()
    end
    if self.build_id >= 11 then -- 铜币
        if self.build_id == 11 or self.build_id == 12 then
            position_y = self.pos_y + 50
            position_x = self.pos_x / 1.1
        else
            position_y = self.pos_y
            position_x = self.pos_x
        end
        for i = 1, up_times do
            local effice = ccs.Armature:create("effect_ziyuan_qb")
            effice:setOpacity(0)
            effice:getAnimation():playWithIndex(0)
            if math.floor(i % 2) == 0 then
                effice:setPosition(cc.p(self._panel_city:getContentSize().width + 10 * i, self._panel_city:getContentSize().height + 50))
            else
                effice:setPosition(cc.p(self._panel_city:getContentSize().width - 10 * i, self._panel_city:getContentSize().height + 50))
            end
            self._panel_city:addChild(effice, 100000) 
            effice:runAction(cc.Sequence:create(
            cc.DelayTime:create(i/5),
            cc.MoveTo:create(1, cc.p(gold_x - position_x - scrollView_x, gold_y - position_y + 20 - scrollView_y)),
            cc.CallFunc:create(removeDrawAntNumberFuncN)
            ))
            effice:runAction(cc.Sequence:create(cc.FadeIn:create(i/5)))
        end
        playEffect(formatMusicFile("effect", 9992))
        local text_table = {"+"..add_number}
        state_machine.excute("add_number_window_open",0,{24,text_table})
    else -- 铁矿
        local mine_Positionx = 0
        local mine_Positiony = 0
        position_y = self.pos_y + 150
        position_x = self.pos_x / 1.1
        for i = 1, up_times do
            local effice = ccs.Armature:create("effect_ziyuan_mt")
            effice:setOpacity(0)
            effice:getAnimation():playWithIndex(0)
            if math.floor(i % 2) == 0 then
                effice:setPosition(cc.p(self._panel_city:getContentSize().width + 10 * i, self._panel_city:getContentSize().height + 50))
            else
                effice:setPosition(cc.p(self._panel_city:getContentSize().width - 10 * i, self._panel_city:getContentSize().height + 50))
            end
            self._panel_city:addChild(effice, 100000)   
            effice:runAction(cc.Sequence:create(
            cc.DelayTime:create(i/5),
            cc.MoveTo:create(0.5 + i/5 , cc.p(mine_x - position_x * 1.1 - scrollView_x, mine_y - position_y + 120 - scrollView_y)),
            cc.CallFunc:create(removeDrawAntNumberFuncN)
            ))   
            effice:runAction(cc.Sequence:create(cc.FadeIn:create(i/5)))
        end
        local text_table = {"+"..add_number}
        state_machine.excute("add_number_window_open",0,{25,text_table})
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
            -- Panel_home_up_get:removeAllChildren(true)
            -- Panel_home_build_up:setVisible(false)
            Text_get_number:setVisible(false)
            Panel_home_build_cell_t._istips = false
        end
    end)
end

function HomeBuildCell:updateDrawLevel()
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

function HomeBuildCell:updateDraw()
    local root = self.roots[1]
    local Button_home_build = ccui.Helper:seekWidgetByName(root, "Button_home_build")
    local pic = dms.string(dms["build_mould"],self.build_id,build_mould.pic)
    local button_name = string.format(config_res.images.ui.home.home_building_png,_ED.user_info.user_force) .."_"..pic..".png"
    local sprites = cc.Sprite:create(button_name)
    Button_home_build:loadTextures(button_name,button_name,button_name)
    Button_home_build:setContentSize(cc.size(sprites:getContentSize().width,sprites:getContentSize().height))
    local Panel_home_build_cell_name_bg = ccui.Helper:seekWidgetByName(root,"Panel_home_build_cell_name_bg")
    local Panel_home_build_cell_lv = ccui.Helper:seekWidgetByName(root,"Panel_home_build_cell_lv")
    local Text_home_build_cell_name = ccui.Helper:seekWidgetByName(root,"Text_home_build_cell_name")
    local Text_home_build_cell_lv = ccui.Helper:seekWidgetByName(root,"Text_home_build_cell_lv")
    local name = dms.string(dms["build_mould"],self.build_id,build_mould.build_name)
    Text_home_build_cell_name:setString(name)
    
    local show_level_test = true
    local update_id = dms.int(dms["build_mould"],self.build_id,build_mould.update_id)
    if update_id == -1 then
        show_level_test = false
    end

    local isShowTip = true
    local fun_open_tab_id = dms.int(dms["build_mould"],self.build_id,build_mould.fun_open_tab_id)
    Panel_home_build_cell_lv:setVisible(show_level_test)
    if (self.build_id == 18 and funOpenDrawTipEX(fun_open_tab_id,false) == true)
        or (self.build_id ~= 18 and funOpenDrawTip(fun_open_tab_id,false) == true) then
        Panel_home_build_cell_lv:setVisible(false)
        Panel_home_build_cell_name_bg:setVisible(false)
        isShowTip = false
        button_name = string.format(config_res.images.ui.home.home_building_png,_ED.user_info.user_force) .."_"..pic.."_0.png"
        if cc.FileUtils:getInstance():isFileExist(button_name) == true then
            sprites = cc.Sprite:create(button_name)
            Button_home_build:loadTextures(button_name,button_name,button_name)
            Button_home_build:setContentSize(cc.size(sprites:getContentSize().width,sprites:getContentSize().height))
        end
    else
        Panel_home_build_cell_name_bg:setVisible(true)
        if dms.int(dms["build_mould"],self.build_id,build_mould.update_id) == -1 then 
            Panel_home_build_cell_lv:setVisible(false)
        else
            -- print("==========",self.build_id)
            Panel_home_build_cell_lv:setVisible(true)
            if _ED.home_build[""..self.build_id] ~= nil then
                local build_lv = _ED.home_build[""..self.build_id].level
                Text_home_build_cell_lv:setString(tonumber(build_lv) - 1)
                if tonumber(build_lv) <= 1 then
                    isShowTip = false
                    button_name = string.format(config_res.images.ui.home.home_building_png,_ED.user_info.user_force) .."_"..pic.."_0.png"
                    if cc.FileUtils:getInstance():isFileExist(button_name) == true then
                        if (self.build_id == 18 and funOpenDrawTipEX(fun_open_tab_id,false) == false)
                            or (self.build_id ~= 18 and funOpenDrawTip(fun_open_tab_id,false) == false) then
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

    self.update_panel = Panel_home_build_cell_up
    self.loading_bar = LoadingBar_home_build_cell_up
    self.text_time = Text_home_build_cell_up_time
end

function HomeBuildCell:formatTimeString(_time)    --系统时间转换
    local timeString = ""
    local now_time = math.max(tonumber(_time),0)
    timeString = timeString .. string.format("%02d", math.floor(now_time/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))
    return timeString

end

function HomeBuildCell:playUpgradeEffect( ... )
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

function HomeBuildCell:onUpdate(dt)
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
                                state_machine.excute("main_window_update_build_level",0,response.node.build_id)
                                response.node:updateDraw()
                            end
                            playEffect(formatMusicFile("effect", 10013))
                            state_machine.excute("build_level_up_onupdate",0,"")
                        else
                            state_machine.excute("main_window_update_build", 0, nil)
                        end
                    end
                    self.update_panel:setVisible(false)
                    protocol_command.build_check_up.param_list = _ED.home_build[""..self.build_id].id--实例id
                    NetworkManager:register(protocol_command.build_check_up.code, nil, nil, nil, self, responseCallback, false, nil)
                    return
                end
            else
                self.update_panel:setVisible(false)
            end
        end
    end
end

function HomeBuildCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.home.home_build_cell, "root")
    -- local root = csbItem:getChildByName("root")
    -- root:removeFromParent(false)
    self:addChild(root) 
    table.insert(self.roots, root) 

    local action = csb.createTimeline(config_csb.cells.home.home_build_cell)
    table.insert(self.actions,action)
    action:setTimeSpeed(app.getTimeSpeed())
    action:play("push_anmi", true)
    root:runAction(action)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_home_build"), nil, 
    {
        terminal_name = "home_build_cell_open_window", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95,        
    }, nil, 2) 
	self:updateDraw()

end

function HomeBuildCell:onEnterTransitionFinish()

end

function HomeBuildCell:init(build_id,pos_x,pos_y,panel)
    self.build_id = build_id
    self.pos_x = pos_x
    self.pos_y = pos_y
    self._panel_city = panel
    self.update_id = dms.int(dms["build_mould"],self.build_id,build_mould.update_id)
    if _ED.home_build[""..self.build_id] ~= nil then
        self.last_build_level = zstring.tonumber(_ED.home_build[""..self.build_id].level)
    end
	self:onInit()
end

function HomeBuildCell:onExit()
    cacher.freeRef(config_csb.cells.home.home_build_cell, self.roots[1])
end