--------------------------------------------------------------------------------------------------------------
--  说明：主页面角色信息窗口
--------------------------------------------------------------------------------------------------------------
PlayerInforWindow = class("PlayerInforWindowClass", Window)

--打开界面
local player_infor_window_window_open_terminal = {
	_name = "player_infor_window_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTip(102) == true then
            return
        end 
        if fwin:find("PlayerInforWindowClass") == nil then
    		fwin:open(PlayerInforWindow:new():init(),fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_infor_window_window_close_terminal = {
	_name = "player_infor_window_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerInforWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_infor_window_window_open_terminal)
state_machine.add(player_infor_window_window_close_terminal)
state_machine.init()

function PlayerInforWindow:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    --load lua file
    app.load("client.red_alert.utils.SetWindow")
    
    --var
    --
    self.last_time = nil
    --体力恢复所需时间
    self.text_time = nil
    --体力恢复倒计时面板
    self.panel_time = nil

	 -- Initialize alert_home state machine.
    local function init_play_infor_window_terminal()
        --关闭界面
        local player_infor_window_close_terminal = {
            _name = "player_infor_window_close",
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

        state_machine.add(player_infor_window_close_terminal)	
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_play_infor_window_terminal()

end


function PlayerInforWindow:updateDraw()
    local root = self.roots[1]

    local Panel_camp_icon = ccui.Helper:seekWidgetByName(root,"Panel_camp_icon")            --阵营icon
    local Panel_power_time = ccui.Helper:seekWidgetByName(root,"Panel_power_time")          --体力恢复倒计时面板
    self.panel_time = Panel_power_time
    local Text_player_name = ccui.Helper:seekWidgetByName(root,"Text_player_name")          --玩家名称
    local BitmapFontLabel_vip = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_vip")    --VIP等级
    local Text_fight_number = ccui.Helper:seekWidgetByName(root,"Text_fight_number")        --战斗力
    local Text_lv_number = ccui.Helper:seekWidgetByName(root,"Text_lv_number")              --等级
    local LoadingBar_lv = ccui.Helper:seekWidgetByName(root,"LoadingBar_lv")                --经验条
    local Text_legion_lv = ccui.Helper:seekWidgetByName(root,"Text_legion_lv")              --公会名
    local Text_power_number = ccui.Helper:seekWidgetByName(root,"Text_power_number")        --体力
    local Text_loading = ccui.Helper:seekWidgetByName(root,"Text_loading")                  --经验值
    local Text_power_time = ccui.Helper:seekWidgetByName(root,"Text_power_time")            --体力恢复倒计时
    --城堡icon  1部落  2天灾  3联盟
    local Image_camp = ccui.Helper:seekWidgetByName(root,"Image_camp_".._ED.user_info.user_force)
    Image_camp:setVisible(true)

    self.text_time = Text_power_time
    Panel_camp_icon:removeBackGroundImage()
    Panel_camp_icon:setBackGroundImage("images/ui/quality/camp_".. _ED.user_info.user_force ..".png")
    local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role")--主角
    Panel_role:setVisible(true)
    Panel_role:removeAllChildren(true)
    if tonumber(_ED.user_info.user_gender) == 1 then
        jsonPath = "sprite/spirte_nanzhu.json"
        atlasPath = "sprite/spirte_nanzhu.atlas"
    elseif tonumber(_ED.user_info.user_gender) == 2 then    
        jsonPath = "sprite/spirte_nvzhu.json"
        atlasPath = "sprite/spirte_nvzhu.atlas"
    end
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
    animation:setPosition(cc.p(Panel_role:getContentSize().width/2,Panel_role:getContentSize().height/2))
    Panel_role:addChild(animation)

    local Image_build_main = ccui.Helper:seekWidgetByName(root,"Image_build_main")
    local Text_player_lv_top_t = ccui.Helper:seekWidgetByName(root,"Text_player_lv_top_t")
    local Text_player_lv_top_number = ccui.Helper:seekWidgetByName(root,"Text_player_lv_top_number")    --城堡等级上限
    -- local level_max = self:getOpenMaxLevel()
    -- Text_player_lv_top_number:setString(string.format(red_alert_all_str[13],level_max - 1))
    local build_level = zstring.tonumber(_ED.home_build["1"].level) - 1
    Text_player_lv_top_number:setString(build_level)

    BitmapFontLabel_vip:setString("V".._ED.vip_grade)
    Text_player_name:setString(_ED.user_info.user_name)
    Text_lv_number:setString(_ED.user_info.user_grade)
    --战力
    if tonumber(_ED.user_info.fighter_capacity) >= 1000000 then
        local info = math.floor(tonumber(_ED.user_info.fighter_capacity)/10000)
        Text_fight_number:setString(string.format(red_alert_all_str[122],info))
    else
        Text_fight_number:setString(_ED.user_info.fighter_capacity)
    end
    Text_power_number:setString(_ED.user_info.user_food .. "/".. _ED.user_info.max_user_food)

    if _ED.union.union_info.union_name == "" then
        Text_legion_lv:setString(red_alert_all_str[157])
    else
        Text_legion_lv:setString(_ED.union.union_info.union_name)
    end
    if tonumber(_ED.user_info.user_food) >= tonumber(_ED.user_info.max_user_food) then
        Panel_power_time:setVisible(false)
    else
        Panel_power_time:setVisible(true)
    end
    Text_power_time:setString("")
    Text_loading:setString(zstring.tonumber(_ED.user_info.user_experience) .. "/" .. _ED.user_info.user_grade_need_experience )
    local persent = zstring.tonumber(_ED.user_info.user_experience) / zstring.tonumber(_ED.user_info.user_grade_need_experience) *100
    LoadingBar_lv:setPercent(persent)
    -- print("========",_ED.user_info.user_food_add_cd)
end

--得到能打开最大等级
function PlayerInforWindow:getOpenMaxLevel()
    local level_data = {}
    for i,v in pairs(_ED.build_escalate_info["1"]) do
        -- print("==========",v.by_open_user_level)
        local data = {
            level = v.level,
            by_open_user_level = v.by_open_user_level,
        }
        table.insert(level_data,data)
    end

    local function sortType( a, b )
        return tonumber(a.level) > tonumber(b.level)
    end  
    table.sort(level_data, sortType)

    for i,v in pairs(level_data) do
        if tonumber(_ED.user_info.user_grade) >= tonumber(v.by_open_user_level) and  tonumber(v.by_open_user_level) ~= -1 then
            return tonumber(v.level) + 1
        end
    end
    
end

function PlayerInforWindow:formatTimeString(_time)    --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(math.max(0,tonumber(_time)/3600))) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((math.max(0,tonumber(_time)%3600)/60))) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(math.max(0,tonumber(_time)%60)))
    return timeString
end

--更新时间
function PlayerInforWindow:onUpdate()
    if self.panel_time == nil or self.text_time == nil then
        return
    end

    local now_time = os.time()
    if now_time - zstring.tonumber(self.last_time) >= 1 then
        local times = self.need_time - now_time
        self.text_time:setString(self:formatTimeString(times))
        self.last_time = now_time
    end
end

-- 关闭主页面角色信息窗口
function PlayerInforWindow:onWindowClose()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("window_close", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("player_infor_window_window_close", 0, "")
        end
    end)
end

--初始化
function PlayerInforWindow:onInit()
    local csbItem = csb.createNode(config_csb.player.player_infor_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
    
    local action = csb.createTimeline(config_csb.player.player_infor_window)
    table.insert(self.actions, action)
    -- action:setTimeSpeed(app.getTimeSpeed())
    action:play("window_open", false)
    csbItem:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "window_open_over" then

        end  
    end)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), nil, 
    {
        terminal_name = "player_infor_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,         
    }, nil, 0)   

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_bg"), nil, 
    {
        terminal_name = "player_infor_window_close", 
        terminal_state = 0,     
    }, nil, 0)   

    local Button_player_center = ccui.Helper:seekWidgetByName(root,"Button_player_center")
    local Image_player_center = ccui.Helper:seekWidgetByName(root,"Image_player_center")
    Button_player_center:setVisible(false)
    Image_player_center:setVisible(false)

    --用户中心  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_center"), nil, 
    {
        -- terminal_name = "", 
        func_string = [[funOpenDrawTip(102)]], 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,            
    }, nil, 0)
    --用户设置
    local Button_set = ccui.Helper:seekWidgetByName(root,"Button_set")
    Button_set:setVisible(false)
    if funOpenDrawTip(103,false) == false then 
        Button_set:setVisible(true)
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_set"), nil, 
    {
        terminal_name = "set_window_open", 
        -- func_string = [[funOpenDrawTip(103)]], 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,            
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_game_ann"), nil, 
    {
        terminal_name = "game_announcement_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,            
    }, nil, 0)

    self:updateDraw()
end

function PlayerInforWindow:onEnterTransitionFinish()

end

--初始化
function PlayerInforWindow:init()
    local now_food = tonumber(_ED.user_info.user_food)
    local max_user_food = tonumber(_ED.user_info.max_user_food)
    local need_food = max_user_food - now_food
    local cover_food_every_minute = dms.float(dms["user_config"],8,user_config.param)
    self.need_time = need_food / cover_food_every_minute * 60 + os.time()
	self:onInit()
    return self
end

function PlayerInforWindow:onExit()
    state_machine.remove("player_infor_window_close")
end