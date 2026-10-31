
CaptureResourceInfo = class("CaptureResourceInfoClass", Window)

local capture_resource_info_open_terminal = {
    _name = "capture_resource_info_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local CaptureResourceInfoWindow = fwin:find("CaptureResourceInfoClass")
        if CaptureResourceInfoWindow ~= nil and CaptureResourceInfoWindow:isVisible() == true then
            return true
        end
        state_machine.lock("capture_resource_info_open")
        fwin:open(CaptureResourceInfo:new():init(params), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local capture_resource_info_close_terminal = {
    _name = "capture_resource_info_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local CaptureResourceInfoWindow = fwin:find("CaptureResourceInfoClass")
        if CaptureResourceInfoWindow ~= nil then
            fwin:close(CaptureResourceInfoWindow)
        end 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(capture_resource_info_open_terminal)
state_machine.add(capture_resource_info_close_terminal)
state_machine.init()

function CaptureResourceInfo:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    self.mapBuild = nil
    self.buildInfo = nil
    self.current_time = nil
    self.last_time = 0

    app.load("client.utils.TimeUtil")
    local function init_capture_resource_info_terminal()
		local capture_resource_button_close_touch_terminal = {
            _name = "capture_resource_button_close_touch",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("capture_resource_info_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local capture_resource_button_capture_touch_terminal = {
            _name = "capture_resource_button_capture_touch",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local buildOpenInfo = zstring.split(dms.string(dms["pirates_config"], 292, pirates_config.param), ",")
                -- print("==================",tonumber(_ED.open_resource_bulid_max_count),table.nums(_ED.captureResourceInfo))
                if tonumber(_ED.open_resource_bulid_max_count) == table.nums(_ED.captureResourceInfo) then
                    state_machine.excute("capture_resource_add_capture_times",0,"")
                    return
                end
                instance:enterFormation()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local capture_resource_button_show_formation_touch_terminal = {
            _name = "capture_resource_button_show_formation_touch",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:enterFormation()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local capture_resource_button_add_time_touch_terminal = {
            _name = "capture_resource_button_add_time_touch",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addCaptureTime()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local capture_resource_button_give_up_touch_terminal = {
            _name = "capture_resource_button_give_up_touch",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:giveUpCapture()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local capture_resource_my_resource_by_lose_terminal = {
            _name = "capture_resource_my_resource_by_lose",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.buildInfo ~= nil then
                    local mapIndex = tonumber(params[1])
                    local posX = tonumber(params[2])
                    local posY = tonumber(params[3])
                    if mapIndex == tonumber(instance.buildInfo.map_index) and 
                        posX == tonumber(instance.buildInfo.pos_x) and 
                        posY == tonumber(instance.buildInfo.pos_y) then
                        state_machine.excute("capture_resource_info_close", 0, nil)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(capture_resource_button_close_touch_terminal)
        state_machine.add(capture_resource_button_capture_touch_terminal)
        state_machine.add(capture_resource_button_show_formation_touch_terminal)
        state_machine.add(capture_resource_button_add_time_touch_terminal)
        state_machine.add(capture_resource_button_give_up_touch_terminal)
        state_machine.add(capture_resource_my_resource_by_lose_terminal)
        state_machine.init()
    end
    init_capture_resource_info_terminal()
end

function CaptureResourceInfo:addCaptureTime( ... )
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            TipDlg.drawTextDailog(_string_piece_info[401])
            if response.node ~= nil and response.node.roots ~= nil then
                local posX = response.node.mapBuild.pos_x
                local posY = response.node.mapBuild.pos_y
                local mapIndex = response.node.mapBuild.map_index
                for k,v in pairs(_ED.captureResourceInfo) do
                    if tonumber(v.pos_x) == tonumber(posX) and tonumber(v.pos_y) == tonumber(posY) and 
                        tonumber(v.map_index) == tonumber(mapIndex) then
                        response.node.buildInfo = v
                    end
                end
                response.node:updateDraw()
            end
        end
    end
    local posX = tonumber(self.mapBuild.pos_x) - 1
    local posY = tonumber(self.mapBuild.pos_y) - 1
    protocol_command.hold_extend.param_list = self.mapBuild.map_index.."\r\n"..posX..","..posY
    NetworkManager:register(protocol_command.hold_extend.code, nil, nil, nil, self, responseCallback, false, nil)                     
end

function CaptureResourceInfo:sureGiveUpResource( sure_number, cell )
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            local infoLayer = fwin:find("CaptureResourceInfoClass")
            if infoLayer ~= nil and infoLayer.roots ~= nil then
                fwin:close(response.node)
            end
        end
    end
    if sure_number == 0 then
        local posX = tonumber(self.mapBuild.pos_x) - 1
        local posY = tonumber(self.mapBuild.pos_y) - 1
        protocol_command.hold_drop.param_list = self.mapBuild.map_index.."\r\n"..posX..","..posY
        NetworkManager:register(protocol_command.hold_drop.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function CaptureResourceInfo:giveUpCapture( ... )
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.mapBuild ~= nil then
                local buildData = dms.element(dms["grab_build_param"], response.node.mapBuild.build_id)
                local reward_name = dms.atos(buildData, grab_build_param.reward_name)
                app.load("client.utils.ConfirmTip")
                local tip = ConfirmTip:new()
                local info = string.format(_string_piece_info[396], _ED._capture_resource_reward, reward_name)
                tip:init(response.node, response.node.sureGiveUpResource, info)
                fwin:open(tip,fwin._windows)
            end
        end
    end
    local posX = tonumber(self.mapBuild.pos_x) - 1
    local posY = tonumber(self.mapBuild.pos_y) - 1
    protocol_command.hold_drop_efficacy.param_list = self.mapBuild.map_index.."\r\n"..posX..","..posY
    NetworkManager:register(protocol_command.hold_drop_efficacy.code, nil, nil, nil, self, responseCallback, false, nil)
end

function CaptureResourceInfo:enterFormation( ... )
    if self.buildInfo == nil then
        if #self.mapBuild.ships > 0 then
            state_machine.excute("capture_resource_formation_open", 0, {state = -1, build = self.mapBuild})
        else
            state_machine.excute("capture_resource_formation_open", 0, {state = 0, build = self.mapBuild})
        end
    else
        state_machine.excute("capture_resource_formation_open", 0, {state = 1, build = self.mapBuild})
    end
end

function CaptureResourceInfo:onUpdate( dt )
    if self.timeText == nil or self.current_time == nil then 
        return
    end

    local time = self.current_time - os.time()
    if time >= 0 and self.last_time - time >= 1 then
        self.last_time = time
        self.timeText:setString(getTimeDesByInterval(time))
    end

    -- self.current_time = self.current_time - dt
    -- if self.current_time >= 0 and self.last_time - self.current_time >= 1 then
    --     self.last_time = self.current_time
    --     self.timeText:setString(getTimeDesByInterval(self.current_time))
    -- end
end

function CaptureResourceInfo:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end

    local buildData = dms.element(dms["grab_build_param"], self.mapBuild.build_id)
    local buildName = dms.atos(buildData, grab_build_param.build_name)
    local buildCondition = dms.element(dms["grab_condition_param"], self.mapBuild.build_condition)
    local attack_limit = dms.atos(buildCondition, grab_condition_param.attack_limit)
    local attack_level_limit = dms.atos(buildCondition, grab_condition_param.attack_level_limit)
    local attack_quility_limit = dms.atos(buildCondition, grab_condition_param.attack_quility_limit)
    local attack_consume = zstring.split(dms.atos(buildData, grab_build_param.attack_consume), ",")
    local second_reward_values = zstring.split(dms.atos(buildData, grab_build_param.second_reward_values), ",")
    local reward_icon = dms.atos(buildData, grab_build_param.reward_icon)
    local reward_name = dms.atos(buildData, grab_build_param.reward_name)
    local max_hold_time = dms.atos(buildData, grab_build_param.max_hold_time)
    local rewardNum = tonumber(second_reward_values[3])*3600
    local hourRewardInfo = ""..math.floor(rewardNum)

    local mapName = dms.atos(dms.element(dms["grab_map_mould"], self.mapBuild.map_index), grab_map_mould.map_name)
    ccui.Helper:seekWidgetByName(root, "Text_citi_map"):setString(mapName.."00"..self.mapBuild.map_index)
    ccui.Helper:seekWidgetByName(root, "Text_citi_xy"):setString("x:"..self.mapBuild.pos_x.." , y:"..self.mapBuild.pos_y)

    ccui.Helper:seekWidgetByName(root, "Text_citi_name"):setString(buildName)
    local Text_zhanling_name = ccui.Helper:seekWidgetByName(root, "Text_zhanling_name")
    local tipsInfo = ""
    Text_zhanling_name:setString(self.mapBuild.captureName)
    self.timeText = ccui.Helper:seekWidgetByName(root, "Text_zhanling_time")
    local Text_zhanli = ccui.Helper:seekWidgetByName(root, "Text_zhanli")
    Text_zhanli:setString(""..self.mapBuild.cap_fighting)
    if self.buildInfo == nil then
        ccui.Helper:seekWidgetByName(root, "Panel_11"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_zhanling"):setVisible(false)
        self.timeText:setString(_string_piece_info[410])
        tipsInfo = string.format(_string_piece_info[394], 4, rewardNum*4, reward_name)
        self.current_time = nil
    else
        ccui.Helper:seekWidgetByName(root, "Panel_zhanling"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_11"):setVisible(false)
        self.current_time = self.buildInfo.capture_time/1000
        -- local total_time = (self.buildInfo.extend_count + 1) * tonumber(max_hold_time) * 3600
        -- self.current_time = self.current_time - total_time
        self.last_time = self.current_time

        local costs = zstring.split(dms.string(dms["pirates_config"], 239, pirates_config.param), ",")
        local addTime = 0
        if tonumber(self.buildInfo.extend_count) == 0 then
            addTime = costs[2]
        else
            addTime = costs[3]
        end
        ccui.Helper:seekWidgetByName(root, "Text_1_0"):setString(""..addTime)
        
        local time = 4 * (tonumber(self.buildInfo.extend_count) + 1)
        local aditionReward = rewardNum * time
        tipsInfo = string.format(_string_piece_info[394], time, aditionReward, reward_name)
        if tonumber(self.buildInfo.add_per) ~= 0 then
            hourRewardInfo = hourRewardInfo.."  + "..self.buildInfo.add_per.."%"
        end
    end
    ccui.Helper:seekWidgetByName(root, "Text_ziyuan"):setString(tipsInfo)

    local index = 1
    for i=1,6 do
        local Panel_hero = ccui.Helper:seekWidgetByName(root, "Panel_hero_"..index):setVisible(false)
        local Panel_quality = ccui.Helper:seekWidgetByName(root, "Panel_hero_"..index.."_0"):setVisible(false)
        local shipId = self.mapBuild.ships[i]
        if shipId ~= nil and tonumber(shipId) ~= nil and tonumber(shipId) ~= 0 then
            index = index + 1
            local picIndex = dms.int(dms["ship_mould"], shipId, ship_mould.head_icon)
            Panel_hero:setVisible(true)
            Panel_quality:setVisible(true)
            Panel_hero:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
            local quality = dms.int(dms["ship_mould"], shipId, ship_mould.ship_type)+1
            if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
                Panel_quality:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
            else
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    Panel_quality:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
                else
                    Panel_quality:setBackGroundImage(string.format("images/ui/quality/icon_hero_%d.png", quality))
                end
            end
            
        end
    end

    ccui.Helper:seekWidgetByName(root, "Text_ziyuan_name"):setString(reward_name)
    ccui.Helper:seekWidgetByName(root, "Panel_ziyuan_icon"):setBackGroundImage(string.format("images/ui/play/secret_society/secret_icon_%s.png", reward_icon))
    local infoStr = string.format(_string_piece_info[409], hourRewardInfo, reward_name)
    ccui.Helper:seekWidgetByName(root, "Text_ziyuan_number"):setString(infoStr)

    local infoTips = {}
    if tonumber(attack_limit) < 0 then
    else
        table.insert(infoTips, string.format(_string_piece_info[391], attack_limit))
    end
    if tonumber(attack_level_limit) < 0 then
    else
        table.insert(infoTips, string.format(_string_piece_info[392], attack_level_limit))
    end
    if tonumber(attack_quility_limit) < 0 then
    else
        table.insert(infoTips, string.format(_string_piece_info[393], _ship_types_by_color[tonumber(attack_quility_limit) + 1]))
    end
    for i=1,3 do
        if infoTips[i] ~= nil then
            ccui.Helper:seekWidgetByName(root, "Text_ziyuantiaojian_"..i):setString(infoTips[i])
        else
            ccui.Helper:seekWidgetByName(root, "Text_ziyuantiaojian_"..i):setString("")
        end
    end
    ccui.Helper:seekWidgetByName(root, "Text_17_0"):setString(""..attack_consume[3])
end

function CaptureResourceInfo:onEnterTransitionFinish()
	local csbSocietyInfo = csb.createNode("secret_society/secret_society_xx.csb")
    local root = csbSocietyInfo:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSocietyInfo)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xx_close"), nil, 
    {
        terminal_name = "capture_resource_button_close_touch", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gongda"), nil, 
    {
        terminal_name = "capture_resource_button_capture_touch", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chankanzhenrong"), nil, 
    {
        terminal_name = "capture_resource_button_show_formation_touch", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yanchang"), nil, 
    {
        terminal_name = "capture_resource_button_add_time_touch", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fangqi"), nil, 
    {
        terminal_name = "capture_resource_button_give_up_touch", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    
    self:updateDraw()
    self:registerOnNoteUpdate(self, 0.5)
    state_machine.unlock("capture_resource_info_open")
end

function CaptureResourceInfo:init( params )
    self.mapBuild = params.mapBuild
    self.buildInfo = params.info
    if self.buildInfo == nil and _ED.captureResourceInfo ~= nil then
        for k,v in pairs(_ED.captureResourceInfo) do
            if v.pos_x == self.mapBuild.pos_x and v.pos_y == self.mapBuild.pos_y and
                v.map_index == self.mapBuild.map_index then
                self.buildInfo = v
            end
        end
    end
    return self
end

function CaptureResourceInfo:onExit()
	state_machine.remove("capture_resource_button_close_touch")
    state_machine.remove("capture_resource_button_capture_touch")
    state_machine.remove("capture_resource_button_show_formation_touch")
    state_machine.remove("capture_resource_button_add_time_touch")
    state_machine.remove("capture_resource_button_give_up_touch")
    state_machine.remove("capture_resource_my_resource_by_lose")
end
