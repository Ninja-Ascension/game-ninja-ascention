-----------------------------
--主界面打开窗口选择动画
-----------------------------
HomeSelectAction = class("HomeSelectActionClass", Window)

--打开界面
local home_select_action_window_open_terminal = {
    _name = "home_select_action_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HomeSelectActionClass")
        if nil == _Window then
            local build_id = params[1]
            fwin:open(HomeSelectAction:new():init(build_id), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local home_select_action_window_close_terminal = {
    _name = "home_select_action_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HomeSelectActionClass"))
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(home_select_action_window_open_terminal)
state_machine.add(home_select_action_window_close_terminal)
state_machine.init()

function HomeSelectAction:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- load lua file
    app.load("client.red_alert.forging.Refining")
    app.load("client.red_alert.forging.Rebirth")
    app.load("client.red_alert.forging.Combining")
    app.load("client.red_alert.barrack.BarrackScience")
    app.load("client.red_alert.horse.Racecourse")
    app.load("client.red_alert.horse.RacecourseDragonHorseMake")
    app.load("client.red_alert.horse.RacecourseHorseSoul")
    app.load("client.red_alert.horse.RacecoursePack")
    app.load("client.red_alert.horse.RacecourseRide")
    app.load("client.red_alert.horse.RacecourseSoulExchange")
    app.load("client.red_alert.notification.push_notification_home_select")
    app.load("client.red_alert.notification.push_notification_horse")
    app.load("client.red_alert.campaign.tourneyfield.TourneyfieldShop")
    app.load("client.red_alert.home.HomeHeroReel")
    app.load("client.red_alert.weapon_book.WeaponBookMain")
    app.load("client.red_alert.weapon_book.WeaponBookPartner")
    app.load("client.red_alert.forging.Inherit")

    --var
    --建筑ID
    self.build_id = nil

    -- Initialize home_select_action state machine.
    local function init_home_select_action_terminal()
	
		--打开升级窗口
		local home_select_action_open_level_up_window_terminal = {
            _name = "home_select_action_open_level_up_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local build_id = instance.build_id
                state_machine.excute("home_select_action_window_close",0,"")
                state_machine.excute("build_level_up_window_open",0,{build_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开神兵
        local home_select_action_open_god_weaponry_window_terminal = {
            _name = "home_select_action_open_god_weaponry_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("god_weaponry_window_open",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 打开华山论剑
        local home_select_action_open_tourneyfield_window_terminal = {
            _name = "home_select_action_open_tourneyfield_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("tourneyfield_window_open",0,{1})
                    end
                end
                protocol_command.arena_init.param_list = "0"
                NetworkManager:register(protocol_command.arena_init.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(home_select_action_open_level_up_window_terminal) 
		state_machine.add(home_select_action_open_god_weaponry_window_terminal)	
        state_machine.add(home_select_action_open_tourneyfield_window_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_home_select_action_terminal()
end

--更新画面
function HomeSelectAction:onUpdateDraw()
    local root = self.roots[1]
    local Image_level_up_text = ccui.Helper:seekWidgetByName(root,"Image_level_up_text")    -- 升级
    local Image_level_up_text_0 = ccui.Helper:seekWidgetByName(root,"Image_level_up_text_0")    --正在升级
    local Image_level_up_text_1 = ccui.Helper:seekWidgetByName(root,"Image_level_up_text_1")    -- 已满级
    if _ED.home_build[""..self.build_id] == nil then
        return
    end
    Image_level_up_text:setVisible(false)
    Image_level_up_text_0:setVisible(false)
    Image_level_up_text_1:setVisible(false)
    local level = _ED.home_build[""..self.build_id].level
    local update_id = dms.int(dms["build_mould"],self.build_id,build_mould.update_id)
    local update_need_resouce = _ED.build_escalate_info[""..update_id][""..level].update_need_resouce
    if update_need_resouce ~= nil then 
        if zstring.tonumber(_ED.home_build[""..self.build_id].update_state) == 1 then   -- 1 正在升级 0 升级结束了
            Image_level_up_text_0:setVisible(true)
        else
            Image_level_up_text:setVisible(true)
        end
    else
        Image_level_up_text_1:setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_select_up"):setTouchEnabled(false)
    end
end

--初始化界面
function HomeSelectAction:onEnterTransitionFinish()
    local csbItem = csb.createNode(string.format(config_csb.home.home_select_action,self.build_id))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(string.format(config_csb.home.home_select_action,self.build_id))
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("home_select_action",false)

    --关闭
    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "home_select_action_window_close", 
        terminal_state = 0, 
    }, nil, 0)

    --升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_select_up"), nil, 
    {
        terminal_name = "home_select_action_open_level_up_window", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_select_up",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_select_up"),
        _invoke = nil,
        _build = self.build_id,
        _interval = 0.5,})   

    --主公技
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_protagonist_skills"), nil, 
    {
        terminal_name = "protagonist_skills_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 英雄榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_reel"), nil, 
    {
        terminal_name = "home_hero_reel_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --分解
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_break_down"), nil, 
    {
        terminal_name = "refining_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        page_index = 1,
    }, nil, 0)     
  
    --合成
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_synthesis"), nil, 
    {
        terminal_name = "combining_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_select_synthesis",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_synthesis"),
        _invoke = nil,
        _interval = 0.5,})   

    --重生
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rebirth"), nil, 
    {
        terminal_name = "rebirth_window_open",
        -- func_string = [[funOpenDrawTip(97)]],  
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    --传承
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_inherit"), nil, 
    {
        terminal_name = "inherit_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

        --兵营科技
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_barrack_skills"), nil, 
    {
        terminal_name = "barrack_science_window_open",
        -- func_string = [[funOpenDrawTip(106)]],  
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    

    --马场
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_horses_horses"), nil, 
    {
        terminal_name = "racecourse_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)      
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_horse_recuit",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_horses_horses"),
        _invoke = nil,
        _interval = 0.5,})

    --马场乘骑
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_riding_horses"), nil, 
    {
        terminal_name = "racecourse_ride_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_horse_all_info",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_riding_horses"),
        _invoke = nil,
        _interval = 0.5,})

    --皇城
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tourney_field"), nil, 
    {
        terminal_name = "home_select_action_open_tourneyfield_window",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)  

    -- 群雄擂台
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pack_ring"), nil, 
    {
        func_string = [[funOpenDrawTip(132)]],
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)  

    -- 一站到底
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_aspirations_world"), nil, 
    {
        func_string = [[funOpenDrawTip(133)]],
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    --荣誉商店
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tourney_field_shop"), nil, 
    {
        terminal_name = "tourneyfield_shop_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_home_tourneyfield_shop",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_tourney_field_shop"),
        _invoke = nil,
        _interval = 0.5,})   

    -- 神兵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_god_weaponry"), nil, 
    {
        terminal_name = "home_select_action_open_god_weaponry_window",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    -- 神兵副本
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_god_duplicate"), nil, 
    {
        terminal_name = "god_weaponry_duplicate_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    --珍兽分解
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_break_down_1"), nil, 
    {
        terminal_name = "refining_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        page_index = 3,
    }, nil, 0)     

    --兵符
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_weapon"), nil, 
    {
        terminal_name = "weapon_book_main_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    --援军
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_weapon_aid"), nil, 
    {
        terminal_name = "weapon_book_partner_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    self:onUpdateDraw()
end

function HomeSelectAction:onInit( )

end

function HomeSelectAction:init(build_id)
    self.build_id = build_id
	self:onInit()
    return self
end

--移除状态机
function HomeSelectAction:onExit()
    state_machine.remove("home_select_action_open_level_up_window") 
    state_machine.remove("home_select_action_open_god_weaponry_window")
    state_machine.remove("home_select_action_open_tourneyfield_window")
end
