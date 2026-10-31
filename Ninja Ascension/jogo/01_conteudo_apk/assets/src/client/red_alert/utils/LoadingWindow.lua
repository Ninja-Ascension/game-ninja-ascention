-- ----------------------------------------------------------------------------------------------------
-- 说明：资源加载界面
-- ----------------------------------------------------------------------------------------------------
LoadingWindow = class("LoadingWindowClass", Window)
LoadingWindow._load_interfaces = nil

local loading_window_open_terminal = {
    _name = "loading_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _loadingWindow = LoadingWindow:new():init(params)
        fwin:open(_loadingWindow, fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local loading_window_close_terminal = {
    _name = "loading_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	fwin:close(fwin:find("LoadingWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(loading_window_open_terminal)
state_machine.add(loading_window_close_terminal)
state_machine.init()

function LoadingWindow:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    -- var
    self._elapsed = 0
    self._duration = 1

    self._is_over = false

    self._update_terminal_name = nil
    self._close_terminal_name = nil

    self.Text_loading_progress = nil
    self.Text_loading_help = nil

    self.Image_load_ing = nil

    self.frameCount = 25
end

function LoadingWindow:init(params)
	self._rootWindows = params[1]
    self._update_terminal_name = params[2]
    self._close_terminal_name = params[3]
    self.frameCount = params[4] or self.frameCount

    if nil == LoadingWindow._load_interfaces then
        LoadingWindow._load_interfaces = {}
        -- 加载配置数据
        for i, v in pairs(dms["load_interface"]) do
            local needInsert = true
            local tOrder = dms.atoi(v, load_interface.order)
            for n, m in pairs(LoadingWindow._load_interfaces) do
                local cOrder = dms.atoi(m, load_interface.order)
                if tOrder < cOrder then
                    needInsert = false
                    table.insert(LoadingWindow._load_interfaces, n, v)
                    break
                end
            end
            if true == needInsert then
                table.insert(LoadingWindow._load_interfaces, v)
            end
        end
        -- debug.print_r(LoadingWindow._load_interfaces)
    end

    local randomPool = {}
    local randomValue = 0
    local element = nil -- 制取加载对象
    for i, v in pairs(LoadingWindow._load_interfaces) do
        local notificationType = dms.atoi(v, load_interface.notification_type)
        local notificationParam = dms.atos(v, load_interface.notification_param)
        local notificationWeightValue = dms.atoi(v, load_interface.notification_weight_value)
        if 0 == notificationType then
            -- 0每日首次登陆
            local server_date = os.date("%x", _ED.system_time)
            local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("today_first_login_game"), "")
            if save_date ~= server_date then
                element = v
                cc.UserDefault:getInstance():setStringForKey(getKey("today_first_login_game"), server_date)
                break
            end
        elseif 1 == notificationType then
            -- 1首日登陆
            local create_date = os.date("%x", _ED.user_info.create_time)
            local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("first_login_game"), "")
            if save_date == create_date or "" == create_date then
                if "" == create_date then
                    cc.UserDefault:getInstance():setStringForKey(getKey("first_login_game"), create_date)
                end
                if "1" == notificationParam then
                    -- 是否首充
                    if zstring.tonumber(_ED.user_info.recharge_all_rmb) <= 0 then
                        if notificationWeightValue > 0 then
                            table.insert(randomPool, v)
                            randomValue = randomValue + notificationWeightValue
                        else
                            element = v
                            break
                        end
                    end
                end
            end
        elseif 2 == notificationType then
            -- 2登陆送礼
            if "1" == notificationParam then
                -- 七日登陆
                local server_date = os.date('*t', _ED.user_info.system_time)
                local create_date = os.date('*t', _ED.user_info.create_time)
                -- yday
                local dCount = 0
                if server_date.yday == create_date.yday then
                    dCount = server_date.yday - create_date.yday
                else
                    dCount = server_date.yday + (365 - create_date.yday)
                end
                if zstring.tonumber(notificationParam) > dCount then
                    if notificationWeightValue > 0 then
                        table.insert(randomPool, v)
                        randomValue = randomValue + notificationWeightValue
                    else
                        element = v
                        break
                    end
                end
            end
        elseif 3 == notificationType then
            -- 3月卡购买
            if "1" == notificationParams then
                -- 金卡
                local bug = true
                if notificationWeightValue > 0 then
                    table.insert(randomPool, v)
                    randomValue = randomValue + notificationWeightValue
                else
                    element = v
                    break
                end
            elseif "2" == notificationParams then
                -- 钻卡
                local bug = true
                if notificationWeightValue > 0 then
                    table.insert(randomPool, v)
                    randomValue = randomValue + notificationWeightValue
                else
                    element = v
                    break
                end
            end
        elseif 4 == notificationType then
            -- VIP等级
            if zstring.tonumber(notificationParam) > zstring.tonumber(_ED.user_info.vip_level) then
                if notificationWeightValue > 0 then
                    table.insert(randomPool, v)
                    randomValue = randomValue + notificationWeightValue
                else
                    element = v
                    break
                end
            end
        elseif 5 == notificationType then
            -- VIP礼包
            if notificationWeightValue > 0 then
                table.insert(randomPool, v)
                randomValue = randomValue + notificationWeightValue
            else
                element = v
                break
            end
        elseif 6 == notificationType then
            -- 未首充
            if zstring.tonumber(_ED.user_info.recharge_all_rmb) <= 0 then
                if notificationWeightValue > 0 then
                    table.insert(randomPool, v)
                    randomValue = randomValue + notificationWeightValue
                else
                    element = v
                    break
                end
            end
        elseif 7 == notificationType then
            -- 月卡购买天数（大于）
            local notificationParams = zstring.split(notificationParam, ",")
            -- 3月卡购买
            if "1" == notificationParams[1] then
                -- 金卡

            elseif "2" == notificationParams[1] then
                -- 钻卡
                local buyCount = 0
                if zstring.tonumber(notificationParams[2]) < buyCount then
                    if notificationWeightValue > 0 then
                        table.insert(randomPool, v)
                        randomValue = randomValue + notificationWeightValue
                    else
                        element = v
                        break
                    end
                end
            end
        elseif 8 == notificationType then
            -- 定点刷新
            if "1" == notificationParams then
                -- 天宝阁
                if notificationWeightValue > 0 then
                    table.insert(randomPool, v)
                    randomValue = randomValue + notificationWeightValue
                else
                    element = v
                    break
                end
            end
        elseif 9 == notificationType then
            -- 免费刷新次数
            if "1" == notificationParams then
                -- 天宝阁
                if notificationWeightValue > 0 then
                    table.insert(randomPool, v)
                    randomValue = randomValue + notificationWeightValue
                else
                    element = v
                    break
                end
            end
        elseif 10 == notificationType then
            local notificationParams = zstring.split(notificationParam, ",")
            -- 首次攻击NPC
            local npcId = zstring.tonumber(notificationParams[1])
            local maxNpcId = zstring.tonumber(notificationParams[2])
            local f = false
            if npcId == zstring.tonumber(_ED._scene_npc_id) then
                if 0 == zstring.tonumber(_ED.npc_state[npcId]) then
                    f = true
                end
            end

            if true == f or 0 < zstring.tonumber(_ED.npc_state[maxNpcId]) then
                if true == f then
                    element = v
                    break
                elseif notificationWeightValue > 0 then
                    table.insert(randomPool, v)
                    randomValue = randomValue + notificationWeightValue
                end
            end
        elseif 11 == notificationType then
            -- 随机
            if notificationWeightValue > 0 then
                table.insert(randomPool, v)
                randomValue = randomValue + notificationWeightValue
            end
        end
    end

    if nil == element and nil ~= randomPool and #randomPool > 0 then
        element = randomPool[math.random(1, #randomPool)]
    end
    if nil == element and nil ~= LoadingWindow._load_interfaces and #LoadingWindow._load_interfaces > 0 then
        element = LoadingWindow._load_interfaces[math.random(1, #LoadingWindow._load_interfaces)]
    end
    -- print("------------>>>>", element, #randomPool)

    local csbLoadingWindow = csb.createNode(config_csb.utils.loading_window)
    self:addChild(csbLoadingWindow)

    local root = csbLoadingWindow:getChildByName("root")
    table.insert(self.roots, root)

    self.LoadingBar_pragress = ccui.Helper:seekWidgetByName(root, "LoadingBar_pragress")
   
    self.Text_loading_progress = ccui.Helper:seekWidgetByName(root, "Text_loading_progress")
    -- self.Text_loading_progress:setString("0/100")

    -- local element = dms.element(dms["load_interface"], math.random(1, dms.count(dms["load_interface"])))

    self.Text_loading_help = ccui.Helper:seekWidgetByName(root, "Text_loading_help")
    self.Text_loading_help:setString(dms.atos(element, load_interface.help) or "")

    self.Image_load_ing = ccui.Helper:seekWidgetByName(root, "Image_load_ing")
    self.Image_load_ing._x = self.Image_load_ing:getPositionX()
    self.Image_load_ing._width = self.Text_loading_progress:getContentSize().width

    local id = 1 + math.floor(math.random() * 8)
    if id > 8 then
        id = 8
    end
	
	local Panel_loading_bg = ccui.Helper:seekWidgetByName(root, "Panel_loading_bg")
	if nil ~= Panel_loading_bg then
		local path = nil
        if nil ~= element then
            path = dms.atos(element, load_interface.addition_png)
        else
            path = string.format("images/ui/bg/loading_bg%d.png", id)
        end
		if cc.FileUtils:getInstance():isFileExist(path) == true then
			Panel_loading_bg:setBackGroundImage(path)
		end
	end

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
        local Panel_login_loading = ccui.Helper:seekWidgetByName(root, "Panel_login_loading")
        local ArmatureNode_5 = Panel_login_loading:getChildByName("ArmatureNode_5")
        local function changeActionCallback( armatureBack )
            armatureBack:pause()
        end
        ArmatureNode_5._invoke = changeActionCallback
        ArmatureNode_5:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(ArmatureNode_5, 0, 0, false)
    end
    return self
end

function LoadingWindow:onEnterTransitionFinish()
    
end

function LoadingWindow:onUpdate(dt)
    if self._is_over == true then
        self:unregisterOnNoteUpdate(self)
        fwin:addService({
                callback = function ( ... )
                    state_machine.excute("loading_window_close", 0, 0)
                end
            })
    else
        self._elapsed = self._elapsed + 1.0/self.frameCount * 1.0
        -- local progress = math.min(math.modf(self._elapsed * 100), 100)
        local progress = math.min(self._elapsed * 100, 100)
        self.LoadingBar_pragress:setPercent(progress)
        -- self.Text_loading_progress:setString("" .. math.modf(progress) .. "/100")
        local ret = state_machine.excute(self._update_terminal_name, 0, progress)
        if self._elapsed >= self._duration 
            and ret == true
            then
            self._is_over = true
        end
        self.Image_load_ing:setPositionX(self.Image_load_ing._x + self.Image_load_ing._width * progress)
    end
end

function LoadingWindow:close()

end

function LoadingWindow:destroy()
    state_machine.excute(self._close_terminal_name, 0, 0)
end
-- ----------------------------------------------------------------------------------------------------