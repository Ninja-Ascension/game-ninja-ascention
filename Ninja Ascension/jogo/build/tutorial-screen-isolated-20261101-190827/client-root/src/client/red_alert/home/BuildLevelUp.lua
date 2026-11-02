-----------------------------
--建筑升级窗口
-----------------------------
BuildLevelUp = class("BuildLevelUpClass", Window)

local build_level_up_window_open_terminal = {
    _name = "build_level_up_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("BuildLevelUpClass")
        if nil == _Window then
            local build_id = params[1]
            fwin:open(BuildLevelUp:new():init(build_id), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local build_level_up_window_close_terminal = {
    _name = "build_level_up_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BuildLevelUpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(build_level_up_window_open_terminal)
state_machine.add(build_level_up_window_close_terminal)
state_machine.init()

function BuildLevelUp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.build_id = nil
    self.update_id = nil
    self.time_text = nil
    self.last_time = nil
    self.need_gold_text = nil
    self.need_gold = nil
    --正在升级中的建筑数量
    self._have_build_times = 0
    --当前可同时升级建筑数量
    self._build_times = 0 
    app.load("client.red_alert.cells.barrack.barrack_science_icon_cell")
    app.load("client.red_alert.home.BuildLevelUpSkillIntroduceCell")
    app.load("client.red_alert.home.BuildLevelUpMineCell")
    app.load("client.red_alert.cells.home.protagonist_skills_cell")
    app.load("client.red_alert.home.ProtagonistSkillsInfor")
    app.load("client.red_alert.cells.majesty.majesty_icon_cell")
    app.load("client.red_alert.cells.home.home_build_unlock_cell")
    app.load("client.utils.ConfirmTip")
    
    -- Initialize build_level_up state machine.
    local function init_build_level_up_terminal()
	    --升级
		local build_level_up_to_up_terminal = {
            _name = "build_level_up_to_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- print("==========升级建筑")
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("build_level_up_window_close",0,"")
                        playEffect(formatMusicFile("effect", 10012))
                    end
                end
                if instance._have_build_times >= tonumber(instance._build_times) then 
                     TipDlg.drawTextDailog(red_alert_all_str[158])
                     return
                end
                local level =  zstring.tonumber(_ED.home_build[""..instance.build_id].level)
                if zstring.tonumber(_ED.build_escalate_info[""..instance.update_id][""..level].update_need_resouce) > tonumber(_ED.user_info.user_iron) then
                    TipDlg.drawTextDailog(red_alert_all_str[81])
                    return
                end
                protocol_command.build_level_up.param_list = _ED.home_build[""..instance.build_id].id--实例id
                NetworkManager:register(protocol_command.build_level_up.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 加速
        local build_level_up_to_add_speed_terminal = {
            _name = "build_level_up_to_add_speed",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.need_gold > tonumber(_ED.user_info.user_gold) then
                    TipDlg.drawTextDailog(red_alert_all_str[79])
                    return
                end

                local tip = ConfirmTip:new()
                local info = string.format(red_alert_all_str[130],instance.need_gold)
                tip:init(instance, instance.sureSpeedUp, info)
                fwin:open(tip,fwin._windows) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        
                -- 刷新   
        local build_level_up_onupdate_terminal = {
            _name = "build_level_up_onupdate",
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

        --关闭界面
        local build_level_up_close_terminal = {
            _name = "build_level_up_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onWindowClose()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(build_level_up_to_up_terminal)
        state_machine.add(build_level_up_to_add_speed_terminal)
        state_machine.add(build_level_up_onupdate_terminal)
        state_machine.add(build_level_up_close_terminal)
        state_machine.init()
    end
    
    -- call func init build_level_up state machine.
    init_build_level_up_terminal()
end

function BuildLevelUp:sureSpeedUp(sure_number)
    if self.roots == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end
    local build_id = self.build_id
    local build_name = dms.string(dms["build_mould"],build_id,build_mould.build_name)
    local level = tonumber(_ED.home_build[""..build_id].level)
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                state_machine.excute("main_window_update_build_level",0,response.node.build_id)
                if tonumber(response.node.build_id) > 18 then
                    state_machine.excute("personal_fight_main_update",0,tonumber(response.node.build_id) - 18)
                end
            end
            playEffect(formatMusicFile("effect", 10012))
            state_machine.excute("build_level_up_onupdate",0,"")
            state_machine.excute("build_level_up_window_close",0,"")
            state_machine.excute("personal_fight_main_update_info", 0, nil)
            TipDlg.drawTextDailog(string.format(red_alert_all_str[129],build_name,level))
        end
    end
    if sure_number == 0 then
        protocol_command.build_speed_up.param_list = _ED.home_build[""..build_id].id--实例id
        NetworkManager:register(protocol_command.build_speed_up.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function BuildLevelUp:onUpdateDraw()
    local root = self.roots[1]
    local Panel_build_level_up_icon = ccui.Helper:seekWidgetByName(root,"Panel_build_level_up_icon")
    

    local Text_build_level_up_lv = ccui.Helper:seekWidgetByName(root,"Text_build_level_up_lv")
    local level = self:getNowBuildLevel()
    local name = dms.string(dms["build_mould"],self.build_id,build_mould.build_name)
    local pic = dms.string(dms["build_mould"],self.build_id,build_mould.pic)

    local Text_build_level_up_title = ccui.Helper:seekWidgetByName(root,"Text_build_level_up_title")
    Text_build_level_up_title:setString(name..red_alert_all_str[74])

    if level <= 1 then
        Panel_build_level_up_icon:setBackGroundImage(string.format(config_res.images.ui.home.home_building_png,_ED.user_info.user_force) .."_"..pic.."_0.png")
    else
        Panel_build_level_up_icon:setBackGroundImage(string.format(config_res.images.ui.home.home_building_png,_ED.user_info.user_force) .."_"..pic..".png")
    end
    Text_build_level_up_lv:setString(string.format(red_alert_all_str[163],level,name))
    local Text_main_build = ccui.Helper:seekWidgetByName(root,"Text_main_build")  -- 藏经阁描述
    Text_main_build:setVisible(false)
    if self.build_id == 1 then
    --     Panel_build_level_up_icon:setScale(0.7)
        Text_main_build:setVisible(true)
    end
    local Text_build_level_up_time = ccui.Helper:seekWidgetByName(root,"Text_build_level_up_time")
    Text_build_level_up_time:setString(self:getNowBuildLevelUpTime())
    self.time_text = Text_build_level_up_time
    local Text_build_level_up_consume = ccui.Helper:seekWidgetByName(root,"Text_build_level_up_consume")
    Text_build_level_up_consume:setString(self:getNowBuildUpConsume())
    local Panel_build_level_up_unlock = ccui.Helper:seekWidgetByName(root,"Panel_build_level_up_unlock")
    local Panel_build_level_up_effect = ccui.Helper:seekWidgetByName(root,"Panel_build_level_up_effect")
    local Panel_build_level_up_effect_14 = ccui.Helper:seekWidgetByName(root,"Panel_build_level_up_effect_14")
    local Panel_up_accelerate = ccui.Helper:seekWidgetByName(root,"Panel_up_accelerate")
    local Panel_build_level_up_need_money = ccui.Helper:seekWidgetByName(root,"Panel_build_level_up_need_money")
	local Text_build_level_up_need_lv = ccui.Helper:seekWidgetByName(root,"Text_build_level_up_need_lv")
    local Image_build_level_up_8 = ccui.Helper:seekWidgetByName(root,"Image_build_level_up_8")
    Image_build_level_up_8:setPositionX(Text_build_level_up_consume:getPositionX()+Text_build_level_up_consume:getBoundingBox().width*1.5+10)
    Panel_up_accelerate:setVisible(false)
    Panel_build_level_up_need_money:setVisible(false)
    Panel_build_level_up_unlock:setVisible(false)
    Panel_build_level_up_effect:setVisible(false)
    Panel_build_level_up_effect_14:setVisible(false)
    if self.build_id == 1 or self.build_id == 2 then -- 主城或者兵营
        Panel_build_level_up_unlock:setVisible(true)
        local ListView_build_level_up_unlock = ccui.Helper:seekWidgetByName(root,"ListView_build_level_up_unlock")
        ListView_build_level_up_unlock:removeAllItems()
        if self.build_id == 1 then
            self:addHomeBuildUnLockData()
        elseif self.build_id == 2 then
            local barracks = self:getBarracksUnlockData()
            for i,v in pairs(barracks) do
                local cell = state_machine.excute("barrack_science_icon_create_cell",0,{v,3})
                ListView_build_level_up_unlock:addChild(cell)
            end
        end
    elseif self.build_id == 19 then
        Panel_build_level_up_effect_14:setVisible(true)
        local info = _ED.build_escalate_info[""..self.update_id]
        local max_volumn_teams = info[""..level].max_volumn_teams
        max_volumn_teams = zstring.split(max_volumn_teams, ",")

        local next_max_volumn_teams = {}
        if info[""..level+1] == nil then
            next_max_volumn_teams = info[""..level].max_volumn_teams
        else
            next_max_volumn_teams = info[""..level + 1].max_volumn_teams
        end
        next_max_volumn_teams = zstring.split(next_max_volumn_teams, ",")

        for i=1,4 do
            local Text_res_num = ccui.Helper:seekWidgetByName(root,"Text_res_num_"..i)
            Text_res_num:setString(max_volumn_teams[i])
            local Text_res_num_add = ccui.Helper:seekWidgetByName(root,"Text_res_num_add_"..i)
            Text_res_num_add:setString("+"..tonumber(next_max_volumn_teams[i] - max_volumn_teams[i]))
        end
    else
        Panel_build_level_up_effect:setVisible(true) -- 民居 矿场 马场

        local Text_build_production_speed = ccui.Helper:seekWidgetByName(root,"Text_build_production_speed") -- 产出速度
        Text_build_production_speed:setString(self:getOutPut())
        local Text_build_maximum_capacity = ccui.Helper:seekWidgetByName(root,"Text_build_maximum_capacity") -- 最大容量
        if self.build_id == 17 then
            Text_build_maximum_capacity:setString(string.format(red_alert_all_str[160],_ED.build_escalate_info[""..self.update_id][""..level].max_volumn))
        else
            Text_build_maximum_capacity:setString(_ED.build_escalate_info[""..self.update_id][""..level].max_volumn)
        end
        local speed_add,max_add = self:getOutAdd()
        local Text_build_production_speed_add = ccui.Helper:seekWidgetByName(root,"Text_build_production_speed_add")
        Text_build_production_speed_add:setString(speed_add)
        local Text_build_maximum_capacity_add = ccui.Helper:seekWidgetByName(root,"Text_build_maximum_capacity_add")
        Text_build_maximum_capacity_add:setString(max_add)
        local Text_build_level_up_14 = ccui.Helper:seekWidgetByName(root,"Text_build_level_up_14")
        Text_build_level_up_14:setString(red_alert_all_str[226])
        if self.build_id > 19 then
            Text_build_level_up_14:setString(red_alert_all_str[227])
        end
    end
    local update_need_resouce = _ED.build_escalate_info[""..self.update_id][""..level].update_need_resouce
    local can_update,show_str = self:NowBuildLevelUpConditionIsOK()
    if update_need_resouce ~= nil then
    	if can_update == true then --判断是否到升级条件
    		if self:getNowBuildState() == 1 then
    			-- print("==========正在升级")
    			Panel_up_accelerate:setVisible(true)
                Panel_build_level_up_need_money:setVisible(false)
    		else
    			-- print("==========没有升级")
                Panel_up_accelerate:setVisible(false)
    			Panel_build_level_up_need_money:setVisible(true)
    		end
    	else
    		Text_build_level_up_need_lv:setString(show_str)
        end
    else
        Text_build_level_up_lv:setString(string.format(red_alert_all_str[204],name))
    end

    local Text_up_accelerate_money = ccui.Helper:seekWidgetByName(root,"Text_up_accelerate_money")
    local leave_time = self:getNowBuildLevelUpTimeTemp() - (os.time() + _ED.time_add_or_sub -_ED.home_build[""..self.build_id].update_start_time)

    Text_up_accelerate_money:setString(math.abs(math.ceil(math.ceil(leave_time/60.0)/2/10)*10))
    self.need_gold_text = Text_up_accelerate_money
    self.need_gold = math.abs(math.ceil(math.ceil(leave_time/60.0)/2/10)*10)

    if level <= 1 then
        local Text_build_production_speed = ccui.Helper:seekWidgetByName(root,"Text_build_production_speed")
        local Text_build_production_speed_add = ccui.Helper:seekWidgetByName(root,"Text_build_production_speed_add")
        local Text_build_maximum_capacity = ccui.Helper:seekWidgetByName(root,"Text_build_maximum_capacity")
        local Text_build_maximum_capacity_add = ccui.Helper:seekWidgetByName(root,"Text_build_maximum_capacity_add")
        Text_build_production_speed:setString(string.format(red_alert_all_str[146],"0"))--("0/小时")
        Text_build_maximum_capacity:setString(string.format(red_alert_all_str[146],"0"))--("0/小时")
        if tonumber(self.build_id) >= 11 and tonumber(self.build_id) <= 14 then
            Text_build_production_speed_add:setString(string.format(red_alert_all_str[146],"+600"))
            Text_build_maximum_capacity_add:setString(string.format(red_alert_all_str[146],"+7200"))
        elseif tonumber(self.build_id) >= 9 and tonumber(self.build_id) <= 10 then
            Text_build_production_speed_add:setString(string.format(red_alert_all_str[146],"+100"))
            Text_build_maximum_capacity_add:setString(string.format(red_alert_all_str[146],"+4200"))
        elseif tonumber(self.build_id) == 17 then
            Text_build_production_speed:setString(string.format(red_alert_all_str[78],0))
            Text_build_maximum_capacity:setString(string.format(red_alert_all_str[160],"0"))
            Text_build_production_speed_add:setString("+1")
            Text_build_maximum_capacity_add:setString("+9")
        end
    end
end

function BuildLevelUp:getOutPut()
    local str_temp = ""
    local level = self:getNowBuildLevel()
    local output_count = zstring.tonumber(_ED.build_escalate_info[""..self.update_id][""..level].output_count)
    local output_time = zstring.tonumber(_ED.build_escalate_info[""..self.update_id][""..level].output_time)
    if self.build_id == 17 then
        str_temp = string.format(red_alert_all_str[78],math.floor(output_count * 60*60*24/output_time))
    else
        str_temp = string.format(red_alert_all_str[77],math.floor(output_count * 60*60/output_time))
    end
    return str_temp
end

function BuildLevelUp:getOutAdd()
    local str_temp_output = 0
    local str_temp_output_max = 0
    local level = self:getNowBuildLevel()

    if _ED.build_escalate_info[""..self.update_id][""..level+1] == nil then
        return "",""
    end
    local output_count = zstring.tonumber(_ED.build_escalate_info[""..self.update_id][""..level].output_count)
    local output_time = zstring.tonumber(_ED.build_escalate_info[""..self.update_id][""..level].output_time)

    local output_count_next = zstring.tonumber(_ED.build_escalate_info[""..self.update_id][""..(level+1)].output_count)
    local output_time_next = zstring.tonumber(_ED.build_escalate_info[""..self.update_id][""..(level+1)].output_time)
    if self.build_id == 17 then
        str_temp_output = math.floor(output_count_next* 60*60*24 /output_time_next ) - math.floor(output_count* 60*60*24 /output_time )
    else
        str_temp_output = math.floor(output_count_next * 60*60/output_time_next) - math.floor(output_count* 60*60/output_time )
    end

    local output_max = zstring.tonumber(_ED.build_escalate_info[""..self.update_id][""..level].max_volumn)
    local output_max_next = zstring.tonumber(_ED.build_escalate_info[""..self.update_id][""..level+1].max_volumn)

    str_temp_output_max = output_max_next - output_max

    return "+ "..str_temp_output,"+ "..str_temp_output_max
end

function BuildLevelUp:addHomeBuildUnLockData()
    local root = self.roots[1]
    local ListView_build_level_up_unlock = ccui.Helper:seekWidgetByName(root,"ListView_build_level_up_unlock")
    ListView_build_level_up_unlock:removeAllItems()

    local build_level = tonumber(_ED.home_build[""..self.build_id].level)

    --_ED.build_escalate_info[""..update_id][""..level].by_open_home_level
    local data = {}
    for i,v in pairs(_ED.build_escalate_info) do
        for j,k in pairs(v) do  
            if tonumber(k.update_id) == 17 then 
                if tonumber(k.by_open_home_level - 1) == build_level then
                    table.insert(data,k)
                end
            else
                if build_level == 1 then
                elseif build_level == 2 then
                    if tonumber(k.by_open_home_level + 1) == build_level then
                        table.insert(data,k)
                    end
                else
                    if tonumber(k.by_open_home_level) == build_level then
                        table.insert(data,k)
                    end
                end
            end
        end
    end

    local param = dms.string(dms["major_city_config"],1,major_city_config.param)
    param = zstring.split(param,",")

    local open_new_majesty_skill = false
    for i,v in pairs(param) do
        if tonumber(v-1) == build_level then
            open_new_majesty_skill = true
        end
    end

    local open_majesty_id = 0
    for i = 1, dms.count(dms["majesty_skill"]) do
        local skill_type = dms.int(dms["majesty_skill"],i,majesty_skill.skill_type)
        if skill_type ~= 0 then
            local open_level = dms.int(dms["majesty_skill"],i,majesty_skill.open_level) - 1
            if open_level == build_level then
                open_majesty_id = i
            end
        end
    end

    if open_new_majesty_skill == true then
        local majesty_icon_cell = state_machine.excute("majesty_icon_create_cell",0,{nil})
        ListView_build_level_up_unlock:addChild(majesty_icon_cell)
    end

    if open_majesty_id ~= 0 then
        local majesty_icon_cell = state_machine.excute("majesty_icon_create_cell",0,{open_majesty_id})
        ListView_build_level_up_unlock:addChild(majesty_icon_cell)
    end

    for i,v in pairs(data) do
        local home_icon_cell = state_machine.excute("home_build_unlock_create_cell",0,{v})
        ListView_build_level_up_unlock:addChild(home_icon_cell)
    end
    -- print("==========开启的建筑")
    -- debug.print_r(data)
        
end

function BuildLevelUp:getBarracksUnlockData()
    -- 解析兵营科技数据
    if _ED.barracks_escalate_info == nil or table.nums(_ED.barracks_escalate_info) == 0 then
        initAllBarracksEscapeData()
    end
    local barrack_level = tonumber(_ED.home_build[""..self.build_id].level) + 1
    local barrack_ids = {}
    local new_barrack = {}
    local unlock_level_barrack = {}
    -- print("========兵营等级",barrack_level)
    for i= 1 ,dms.count(dms["teach_escalate_param"]) do
        local group_id = dms.int(dms["teach_escalate_param"],i,teach_escalate_param.update_group)
        local open_level = dms.int(dms["teach_escalate_param"],i,teach_escalate_param.open_level)
        if barrack_level > open_level then
            for j,k in pairs(_ED.barracks_escalate_info[""..group_id]) do
                if tonumber(k.need_barracks_level) == tonumber(barrack_level) then
                    -- print("===========升级科技id===",k.id)
                    table.insert(unlock_level_barrack,tonumber(k.id))
                end
            end
        end

        if barrack_level == open_level then
            for j,k in pairs(_ED.barracks_escalate_info[""..group_id]) do
                if tonumber(k.need_barracks_level) == tonumber(barrack_level) then
                    -- print("===========解锁科技id===",k.id)
                    table.insert(new_barrack,tonumber(k.id))
                end
            end
        end
    end

    for i,v in pairs(new_barrack) do
        table.insert(barrack_ids,v)
    end
    for i,v in pairs(unlock_level_barrack) do
        table.insert(barrack_ids,v)
    end

    return barrack_ids 
end

function BuildLevelUp:getNowBuildState()
    return zstring.tonumber(_ED.home_build[""..self.build_id].update_state) -- 1 正在升级 2 升级结束了
end

function BuildLevelUp:getNowBuildLevel()
    return zstring.tonumber(_ED.home_build[""..self.build_id].level)
end

function BuildLevelUp:onUpdate()    --系统时间转换
    local now_time = os.time()
    if self.time_text ~= nil then
        if self:getNowBuildState() == 1 then
            if now_time - zstring.tonumber(self.last_time) >= 1 then
                local leave_time = self:getNowBuildLevelUpTimeTemp() - (now_time + _ED.time_add_or_sub -_ED.home_build[""..self.build_id].update_start_time)      
                self.last_time = now_time
                self.need_gold_text:setString(math.abs(math.max(0,math.ceil(math.ceil(leave_time/60.0)/2/10)*10)))
                if leave_time >= 0 then
                    self.time_text:setString(self:formatTimeString(leave_time))
                end
                self.need_gold = math.abs(math.ceil(math.ceil(leave_time/60.0)/2/10)*10)
                if leave_time <= 0 then               
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                state_machine.excute("main_window_update_build_level",0,response.node.build_id)
                            end
                            state_machine.excute("build_level_up_onupdate",0,"")
                        end
                    end
                    protocol_command.build_check_up.param_list = _ED.home_build[""..self.build_id].id--实例id
                    NetworkManager:register(protocol_command.build_check_up.code, nil, nil, nil, self, responseCallback, false, nil)
                    return
                end
            end 
        end
    end
end

function BuildLevelUp:formatTimeString(_time)    --系统时间转换
    local timeString = ""
    local now_time = math.max(tonumber(_time),0)
    timeString = timeString .. string.format("%02d", math.floor(now_time/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))
    return timeString
end

function BuildLevelUp:getNowBuildLevelUpTime()
    local leave_time = 0
    if zstring.tonumber(_ED.home_build[""..self.build_id].update_state) == 0 then--未升级
        --表里读取  
        local level = _ED.home_build[""..self.build_id].level
        leave_time = _ED.build_escalate_info[""..self.update_id][""..level].consume_time
    else -- 升级中
        leave_time = self:getNowBuildLevelUpTimeTemp() - (os.time() + _ED.time_add_or_sub -_ED.home_build[""..self.build_id].update_start_time)
    end
    return self:formatTimeString(leave_time)
end

--未格式化
function BuildLevelUp:getNowBuildLevelUpTimeTemp()
    local level = _ED.home_build[""..self.build_id].level
    local leave_time = zstring.tonumber(_ED.build_escalate_info[""..self.update_id][""..level].consume_time)
    return leave_time
end

function BuildLevelUp:getNowBuildUpConsume()
    --表里读取
    local level = _ED.home_build[""..self.build_id].level
    return zstring.tonumber(_ED.build_escalate_info[""..self.update_id][""..level].update_need_resouce)
end

function BuildLevelUp:NowBuildLevelUpConditionIsOK()
    local level =  zstring.tonumber(_ED.home_build[""..self.build_id].level)
    local need_home_level = zstring.tonumber(_ED.build_escalate_info[""..self.update_id][""..level].by_open_home_level)
    local need_user_level = zstring.tonumber(_ED.build_escalate_info[""..self.update_id][""..level].by_open_user_level)

    local now_user_level = zstring.tonumber(_ED.user_info.user_grade)
    local now_home_level = zstring.tonumber(_ED.home_build["1"].level)
    
    if now_home_level < need_home_level then
        return false , string.format(red_alert_all_str[75],need_home_level - 1)
    end
    if now_user_level < need_user_level then
        return false , string.format(red_alert_all_str[76],need_user_level)
    end
	return true
end

function BuildLevelUp:onEnterTransitionFinish()

end

-- 关闭界面动画
function BuildLevelUp:onWindowClose()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("window_close", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("build_level_up_window_close", 0, "")
        end
    end)
end

function BuildLevelUp:onInit( )
    local csbItem = csb.createNode(config_csb.home.build_level_up)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.home.build_level_up)
    table.insert(self.actions, action)
    action:play("window_open", false)
    csbItem:runAction(action)

    self._build_times = dms.string(dms["base_consume"],75,(tonumber(base_consume.vip_0_value)+tonumber(_ED.vip_grade)))
    for i,v in pairs(_ED.home_build) do
        if tonumber(v.update_state) == 1 then
            self._have_build_times = self._have_build_times + 1 
        end
    end 

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_build_level_up_close"), nil, 
    {
        terminal_name = "build_level_up_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_build_level_up"), nil, 
    {
        terminal_name = "build_level_up_to_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 加速
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_up_accelerate"), nil, 
    {
        terminal_name = "build_level_up_to_add_speed", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    
    
    self:onUpdateDraw() 
end

function BuildLevelUp:checkMissonCanRun()

    -- print("==========,教学没有")
    local root = self.roots[1]
    local level =  zstring.tonumber(_ED.home_build[""..self.build_id].level)
    local can_update = true
    if zstring.tonumber(_ED.build_escalate_info[""..self.update_id][""..level].update_need_resouce) > tonumber(_ED.user_info.user_iron) then
        can_update = false
    end
    local Panel_build_level_up_need_money = ccui.Helper:seekWidgetByName(root,"Panel_build_level_up_need_money")
    -- print("============", Panel_build_level_up_need_money:isVisible())
    if Panel_build_level_up_need_money:isVisible() == false then
        -- print("==111")
       can_update = false 
    end

    -- print("============", zstring.tonumber(_ED.home_build[""..self.build_id].update_state) )
    if zstring.tonumber(_ED.home_build[""..self.build_id].update_state) == 1 then--升级中
        -- print("==222")
       can_update = false
    end
     -- 还原教学
     -- print("============",can_update)
    if can_update == false then
        if fwin:find("TuitionControllerClass") ~= nil then
            fwin:close(fwin:find("TuitionControllerClass"))
        end
        if fwin:find("WindowLockClass") ~= nil then
            fwin:close(fwin:find("WindowLockClass"))
        end
        if fwin:find("RoleDialogueClass") ~= nil then
            fwin:close(fwin:find("RoleDialogueClass"))
        end
        resetMission(true)
    end
    -- print("=========关闭教学")
end

function BuildLevelUp:init(build_id)
    self.build_id = build_id
    self.update_id = dms.int(dms["build_mould"],self.build_id,build_mould.update_id)
	self:onInit()
    self:checkMissonCanRun()
    return self
end

function BuildLevelUp:onExit()
    state_machine.remove("build_level_up_to_up")
    state_machine.remove("build_level_up_to_add_speed")
    state_machine.remove("build_level_up_onupdate")
    state_machine.remove("build_level_up_close")
end
