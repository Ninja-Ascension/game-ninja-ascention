--------------------------------------------------------------------------------------------------------------
--  说明：角色详情
--------------------------------------------------------------------------------------------------------------
PlayerInfomation = class("PlayerInfomationClass", Window)

--打开界面
local player_infomation_open_terminal = {
	_name = "player_infomation_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = PlayerInfomation:new():init(params)
        fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_infomation_close_terminal = {
	_name = "player_infomation_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerInfomationClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_infomation_open_terminal)
state_machine.add(player_infomation_close_terminal)
state_machine.init()

function PlayerInfomation:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    -- 能量回复倒计时
    self._need_time = 0
    self._last_time = nil
    --体力恢复所需时间
    self._text_time = nil

    app.load("client.red_alert_time.player.PlayerMilitaryRank")
    app.load("client.red_alert_time.player.PlayerMilitaryHelpInfor")
    app.load("client.red_alert_time.player.PlayerEnergyAdd")
    app.load("client.red_alert_time.player.PlayerHeadChange")
	app.load("client.red_alert_time.cells.worldMap.player_head_icon")

    app.load("client.red_alert_time.system.RedAlertTimeGameAnnouncement")
    app.load("client.red_alert_time.system.RedAlertTimeSystemGameSet")

    local function init_play_infomation_terminal()
        local player_infomation_show_terminal = {
            _name = "player_infomation_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local player_infomation_hide_terminal = {
            _name = "player_infomation_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local player_infomation_update_info_terminal = {
            _name = "player_infomation_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 跳转排行榜
        local player_infomation_goto_rank_terminal = {
            _name = "player_infomation_goto_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("rank_window_open", 0, {_datas = {list_type = 1}})
                state_machine.excute("player_info_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 跳转商店
        local player_infomation_goto_shop_terminal = {
            _name = "player_infomation_goto_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("props_shop_packs_window_open",0,{_datas = {page_index = 1}})
                state_machine.excute("player_info_window_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 登出
        local player_infomation_set_logout_terminal = {
            _name = "player_infomation_set_logout",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
                    and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
                    and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
                    handlePlatformRequest(0, LOGOUT, "")
                else
                    local platformloginInfo = {
                        platform_id="",
                        register_type="",
                        platform_account="",
                        nickname="",        
                        password="",
                        is_registered = false
                    }
                    _ED.user_platform = {}
                    _ED.user_platform[platformloginInfo.platform_account] = platformloginInfo
                    _ED.default_user = platformloginInfo.platform_account
                    fwin:addService({
                            callback = function ( params )
                                fwin:removeAll()
                                app.unload("client.loader.EnvironmentDatas")
                                app.load("client.loader.EnvironmentDatas")
                                -- fwin:reset(nil)
                                fwin:open(Login:new(), fwin._view)
                                fwin:close(fwin:find("ConnectingViewClass"))
                                _ED.m_is_games = false
                            end,
                            delay = 0.1,
                            params = self
                        })
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        state_machine.add(player_infomation_show_terminal)
        state_machine.add(player_infomation_hide_terminal)
        state_machine.add(player_infomation_update_info_terminal)
        state_machine.add(player_infomation_goto_rank_terminal)
        state_machine.add(player_infomation_goto_shop_terminal)
        state_machine.add(player_infomation_set_logout_terminal)
        state_machine.init()
    end
    
    init_play_infomation_terminal()
end

function PlayerInfomation:updateDraw()
    local root = self.roots[1]
    local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head")
    Panel_head:removeAllChildren(true)
    Panel_head:removeBackGroundImage()
    -- if zstring.tonumber(_ED.user_info.user_gender) == 1 then
        -- Panel_head:setBackGroundImage("images/ui/home/role_head_man.png")
    -- else
        -- Panel_head:setBackGroundImage("images/ui/home/role_head_women.png")
    -- end
    
    -- 玩家名
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    Text_name:setString(_ED.user_info.user_name)
    -- 玩家等级
    local Text_lv_n = ccui.Helper:seekWidgetByName(root,"Text_lv_n")
    if __lua_project_id == __lua_project_pacific_rim then
        Text_lv_n:setString(_ED.user_info.user_grade)
        local head_data = zstring.split(_ED.user_info.user_head_id, ",")
        local head_info = zstring.split(dms.string(dms["avatar_head"], head_data[1], avatar_head.icon_info), ",")
        local head_pic = tonumber(head_info[1])
        Panel_head:setBackGroundImage(string.format(config_res.images.ui.props.tank, head_pic))
    else
    	local cell = PlayerHeadIcon:createCell()
    	local avatar_info = {}
    	avatar_info.object = _ED.user_info.user_head_id
    	avatar_info.vip = _ED.vip_grade
    	avatar_info._type = 0
    	cell:init(avatar_info)
    	Panel_head:addChild(cell)
        Text_lv_n:setString(string.format(red_alert_all_str[117],_ED.user_info.user_grade))
    end
    -- VIP等级
    local Text_vip_n = ccui.Helper:seekWidgetByName(root,"Text_vip_n")
    Text_vip_n:setString("".._ED.vip_grade)
    -- 军团名
    local Text_legion_n = ccui.Helper:seekWidgetByName(root,"Text_legion_n")
    if _ED.union.union_info == nil 
        or _ED.union.union_info == {} 
        or _ED.union.union_info.union_id == nil 
        or _ED.union.union_info.union_id == "" 
        or tonumber(_ED.union.union_info.union_id) == 0 
        then
        Text_legion_n:setString(tipStringInfo_union_str[3])
    else
        Text_legion_n:setString(_ED.union.union_info.union_name)
    end

    -- 用户带兵量
    local Text_famtion_n = ccui.Helper:seekWidgetByName(root,"Text_famtion_n")
    Text_famtion_n:setString(_ED.user_info.soldier)
    -- 经验值
    local Text_exp_n = ccui.Helper:seekWidgetByName(root,"Text_exp_n")
    Text_exp_n:setString(exChangeNumToString(_ED.user_info.user_experience) .. "/" .. exChangeNumToString(_ED.user_info.user_grade_need_experience))
    local LoadingBar_exp = ccui.Helper:seekWidgetByName(root,"LoadingBar_exp")
    if zstring.tonumber(_ED.user_info.user_experience) == 0 then
        LoadingBar_exp:setPercent(0)
    else
        LoadingBar_exp:setPercent(zstring.tonumber(_ED.user_info.user_experience) / zstring.tonumber(_ED.user_info.user_grade_need_experience) *100)
    end
    -- 能量
    local Text_energy_n = ccui.Helper:seekWidgetByName(root,"Text_energy_n")
    self._text_time = Text_energy_n  
    Text_energy_n:setString(zstring.tonumber(_ED.user_info.user_food) .. "/" .. _ED.user_info.max_user_food)
    local LoadingBar_energy = ccui.Helper:seekWidgetByName(root,"LoadingBar_energy")
    LoadingBar_energy:setPercent(zstring.tonumber(_ED.user_info.user_food) / zstring.tonumber(_ED.user_info.max_user_food) *100)
    -- 战斗力
    local Text_fight_n = ccui.Helper:seekWidgetByName(root,"Text_fight_n")
    Text_fight_n:setString(exChangeNumToString(_ED.user_info.fighter_capacity))
    -- 荣誉
    local Text_honor_n = ccui.Helper:seekWidgetByName(root,"Text_honor_n")
    Text_honor_n:setString("0") -- 目前没有荣誉，暂时写死
    -- Text_honor_n:setString(_ED.user_info.booming)

    -- 军功
    if _ED.user_info.war_industry_level ~= nil then
        local military_info = _ED.base_military_info["".._ED.user_info.war_industry_level]

        local Text_military_n = ccui.Helper:seekWidgetByName(root,"Text_military_n")
        Text_military_n:setString(exChangeNumToString(_ED.user_info.total_war_industry))
        -- 军功增加带兵量
        local Text_military_famtion_n = ccui.Helper:seekWidgetByName(root,"Text_military_famtion_n")
        Text_military_famtion_n:setString(military_info.add_famtion)
        -- 军衔
        local Panel_military_icon = ccui.Helper:seekWidgetByName(root,"Panel_military_icon")
        Panel_military_icon:removeBackGroundImage()
        Panel_military_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, military_info.pic))
        local Text_military_lv_n = ccui.Helper:seekWidgetByName(root,"Text_military_lv_n")
        Text_military_lv_n:setString(military_info.name)
    end

    -- 统率等级
    local Text_command_n = ccui.Helper:seekWidgetByName(root,"Text_command_n")
    Text_command_n:setString(string.format(red_alert_time_str[33],_ED.user_info.command_level))
    
    -- 统率带兵量
    local Text_command_famtion_n = ccui.Helper:seekWidgetByName(root,"Text_command_famtion_n")
    local current_famtion = _ED.base_command_info["".._ED.user_info.command_level].current_famtion
    Text_command_famtion_n:setString("+"..current_famtion)

    --声望等级
    local Text_prestige_n = ccui.Helper:seekWidgetByName(root,"Text_prestige_n")
    Text_prestige_n:setString(string.format(red_alert_all_str[117],_ED.user_info.credit_level))
    -- 声望经验值
    local basePrestigeLevelInfo = _ED.base_prestige_level_info["".._ED.user_info.credit_level]
    local Text_prestige_ing = ccui.Helper:seekWidgetByName(root,"Text_prestige_ing")
    Text_prestige_ing:setString(_ED.user_info.credit.."/"..basePrestigeLevelInfo.max_point)
    local LoadingBar_prestige = ccui.Helper:seekWidgetByName(root,"LoadingBar_prestige")
    LoadingBar_prestige:setPercent(zstring.tonumber(_ED.user_info.credit)/zstring.tonumber(basePrestigeLevelInfo.max_point) * 100)
    local Button_prestige_up = ccui.Helper:seekWidgetByName(root,"Button_prestige_up")

    if zstring.tonumber(_ED.user_info.credit_buy_state) == 1 then
        Button_prestige_up:setBright(false)
    else
        Button_prestige_up:setBright(true)
    end

    -- 繁荣度值
    local Text_boom_n = ccui.Helper:seekWidgetByName(root,"Text_boom_n")
    Text_boom_n:setString(_ED.user_info.booming.."/".._ED.user_info.forage)
    local LoadingBar_boom = ccui.Helper:seekWidgetByName(root,"LoadingBar_boom")
    LoadingBar_boom:setPercent(zstring.tonumber(_ED.user_info.booming)/zstring.tonumber(_ED.user_info.forage) * 100)

    local _glories = zstring.tonumber(_ED.user_info.booming)

    local boom_state = 0
    local boom_bar = zstring.tonumber(_glories)/zstring.tonumber(_ED.user_info.forage)
    for i= 1, dms.count(dms["build_boom_lose"]) do
        local boom_proportion = dms.string(dms["build_boom_lose"], i, build_boom_lose.boom_proportion)
        if boom_bar >= tonumber(boom_proportion) then
            boom_state = dms.int(dms["build_boom_lose"], i, build_boom_lose.boom_state)
            break
        end
    end
    if boom_state == 0 then
        LoadingBar_boom:loadTexture("images/ui/share/loading_boom_bar.png")
    elseif boom_state == 1 then
        LoadingBar_boom:loadTexture("images/ui/share/loading_boom_bar_1.png")
    else
        LoadingBar_boom:loadTexture("images/ui/share/loading_boom_bar_2.png")
    end

    local boom_index = 0
    local boom_level = 0
    for i= 1, dms.count(dms["build_boom_mould"]) do
        local now_need_boom = dms.int(dms["build_boom_mould"], i, build_boom_mould.need_boom)
        local last_need_boom = dms.int(dms["build_boom_mould"], i+1, build_boom_mould.need_boom)
        if tonumber(_ED.user_info.booming) >= now_need_boom 
            and (last_need_boom == nil or tonumber(_ED.user_info.booming) < last_need_boom) then
            boom_index = i
            boom_level = dms.int(dms["build_boom_mould"], i, build_boom_mould.boom_level)
        end
    end
    -- 繁荣度增加带兵量
    local boom_famtion = dms.int(dms["build_boom_mould"], boom_index, build_boom_mould.boom_famtion)    -- 带兵数量
    local Text_boom_famtion_n = ccui.Helper:seekWidgetByName(root,"Text_boom_famtion_n")
    Text_boom_famtion_n:setString("+"..boom_famtion)
    -- 资源增产
    local add_resources = dms.int(dms["build_boom_mould"], boom_index, build_boom_mould.add_resources)  -- 基地资源产量
    local Text_res_add_n = ccui.Helper:seekWidgetByName(root,"Text_res_add_n")
    Text_res_add_n:setString("+"..add_resources.."%")

    -- 繁荣度增加按钮
    local Button_boom_up = ccui.Helper:seekWidgetByName(root,"Button_boom_up")
    if zstring.tonumber(_ED.user_info.booming) < zstring.tonumber(_ED.user_info.forage) then
        Button_boom_up:setBright(true)
    else
        Button_boom_up:setBright(false)
    end

    local Button_command_up = ccui.Helper:seekWidgetByName(root,"Button_command_up")
    if tonumber(_ED.base_command_info["".._ED.user_info.command_level].need_level) > tonumber(_ED.user_info.user_grade) then
        Button_command_up:setBright(false)
    else
        Button_command_up:setBright(true)
    end
end

--更新时间
function PlayerInfomation:onUpdate()
    if self.roots ~= nil and self.roots[1] ~= nil then
        if tonumber(_ED.user_info.user_food) < tonumber(_ED.user_info.max_user_food) then
            local now_time = os.time()
            if now_time - zstring.tonumber(self._last_time) >= 1 then
                local times = zstring.tonumber(_ED._next_energy_recover_time)/1000 - now_time
                if times > 0 then
                    self._text_time:setString(zstring.tonumber(_ED.user_info.user_food) .. "/" .. _ED.user_info.max_user_food.."("..exChangeTimeToString(times)..")")
                else
                    
                    self._text_time:setString(zstring.tonumber(_ED.user_info.user_food) .. "/" .. _ED.user_info.max_user_food)
                end
                self._last_time = now_time
            end
        end
    end
end

--初始化
function PlayerInfomation:onInit()
    local csbItem = csb.createNode(string.format(config_csb.player.player_infor_tab, "1"))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    local ListView_player_infor = ccui.Helper:seekWidgetByName(root, "ListView_player_infor")
    if nil ~= ListView_player_infor.setBounceBottomBoundary then
        ListView_player_infor:setBounceBottomBoundary(0)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_head_change"), nil, 
    {
        -- terminal_name = "player_info_window_close", 
        terminal_state = 0, 
    }, nil, 1)
    -- 声望
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_prestige_up"), nil, 
    {
        terminal_name = "player_info_prestige_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)
    -- 声望
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_player_infor_3"), nil, 
    {
        terminal_name = "player_info_prestige_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)
    -- 声望
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prestige_icon"), nil, 
    {
        terminal_name = "player_info_prestige_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boom_up"), nil, 
    {
        terminal_name = "player_info_boom_up_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    -- 繁荣度界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boom_infor"), nil, 
    {
        terminal_name = "player_infor_boom_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)
    -- 繁荣度 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_player_infor_4"), nil, 
    {
        terminal_name = "player_infor_boom_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)
    -- 繁荣度
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_boom_icon"), nil, 
    {
        terminal_name = "player_infor_boom_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    -- 军衔列表
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_military_box"), nil, 
    {
        terminal_name = "player_military_rank_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)
    -- 军衔列表
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_miliary_list"), nil, 
    {
        terminal_name = "player_military_rank_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    -- 军衔说明
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_military_infor"), nil, 
    {
        terminal_name = "player_military_help_infor_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    -- 统率界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_player_infor_2"), nil, 
    {
        terminal_name = "player_infor_command_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)
    -- 统率界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_command_icon"), nil, 
    {
        terminal_name = "player_infor_command_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)
    -- 统率界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_command_up"), nil, 
    {
        terminal_name = "player_infor_command_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    -- 排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rank"), nil, 
    {
        terminal_name = "player_infomation_goto_rank", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    -- 商店
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_infor"), nil, 
    {
        terminal_name = "player_infomation_goto_shop", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    -- 军功排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_miliary_rank"), nil, 
    {
        terminal_name = "rank_window_open", 
        terminal_state = 0, 
        touch_black = true,
        list_type = 3,
    }, nil, 1)

    -- 体力购买
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add_energy"), nil, 
    {
        terminal_name = "player_energy_add_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)
	
	-- 头像进入
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_head"), nil, 
    {
        terminal_name = "player_head_change_open", 
        touch_black = true,
    }, nil, 1)

	 fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_head_change"), nil, 
    {
        terminal_name = "player_head_change_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    -- 帮助
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil, 
    {
        terminal_name = "help_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    -- 设置
    if __lua_project_id == __lua_project_pacific_rim then
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_set"), nil, 
        {
            terminal_name = "red_alert_time_system_game_set_open", 
            terminal_state = 0, 
            touch_black = true,
        }, nil, 1)
    else
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_set"), nil, 
        {
            terminal_name = "red_alert_time_system_settings_open", 
            terminal_state = 0, 
            touch_black = true,
        }, nil, 1)
    end

    -- 切换账号
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_switch_number"), nil, 
    {
        terminal_name = "player_infomation_set_logout", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    -- 服务器列表
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_server"), nil, 
    {
        terminal_name = "server_managers_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    -- 公告
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_announcement"), nil, 
    {
        terminal_name = "game_announcement_window_open", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    self:updateDraw()
end

function PlayerInfomation:onEnterTransitionFinish()

end

function PlayerInfomation:init(param)
    self._rootWindows = param[1]

	self:onInit()
    return self
end

function PlayerInfomation:onExit()
    state_machine.remove("player_infomation_show")
    state_machine.remove("player_infomation_hide")
    state_machine.remove("player_infomation_update_info")
    state_machine.remove("player_infomation_goto_rank")
    state_machine.remove("player_infomation_goto_shop")
    state_machine.remove("player_infomation_set_logout")
end