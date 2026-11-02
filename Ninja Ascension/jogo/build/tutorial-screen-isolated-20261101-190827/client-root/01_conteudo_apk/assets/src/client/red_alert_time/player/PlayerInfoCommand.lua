--------------------------------------------------------------------------------------------------------------
--  说明：统率界面
--------------------------------------------------------------------------------------------------------------
PlayerInfoCommand = class("PlayerInfoCommandClass", Window)

--打开界面
local player_infor_command_window_open_terminal = {
	_name = "player_infor_command_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("PlayerInfoCommandClass") == nil then
    		fwin:open(PlayerInfoCommand:new():init(), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_infor_command_window_close_terminal = {
	_name = "player_infor_command_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerInfoCommandClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_infor_command_window_open_terminal)
state_machine.add(player_infor_command_window_close_terminal)
state_machine.init()

function PlayerInfoCommand:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    app.load("client.red_alert_time.props.PropsInforPrompt")
    app.load("client.red_alert_time.cells.props.props_icon_cell")
    local function init_play_info_build_upgrade_terminal()
        local player_infor_command_window_show_terminal = {
            _name = "player_infor_command_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local player_infor_command_window_hide_terminal = {
            _name = "player_infor_command_window_hide",
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

        -- 升级
        local player_infor_command_upgrade_terminal = {
            _name = "player_infor_command_upgrade",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local state = 0
                if params ~= nil and params._datas ~= nil and params._datas.state ~= nil then
                    state = params._datas.state
                end
                _ED.last_commander_level = _ED.user_info.command_level
                -- 用户等级不足
                if tonumber(_ED.base_command_info["".._ED.user_info.command_level].need_level) > tonumber(_ED.user_info.user_grade) then
                    TipDlg.drawTextDailog(red_alert_time_str[8])
                    return
                end

                -- 统率书不足
                local update_cost = _ED.base_command_info["".._ED.user_info.command_level].update_cost
                update_cost = zstring.split(update_cost,",")
                local prop_count = 0 
                if fundPropWidthId(update_cost[1]) ~= nil then 
                    local token = fundPropWidthId(update_cost[1])
                    prop_count = zstring.tonumber(token.prop_number)
                end
                if prop_count <= 0 then
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.sureGoldUpgrade, red_alert_time_str[9])
                    fwin:open(tip,fwin._windows) 
                    return
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:updateDraw()
                        end
                        if tonumber(_ED.user_info.command_state) == 1 then
                            TipDlg.drawTextDailog(red_alert_all_str[317])
                        else
                            checkEffectLevelUp()
                            state_machine.excute("player_infomation_update_info",0,"")  
                        end
                    end
                end
                protocol_command.command_update.param_list = ""..state
                NetworkManager:register(protocol_command.command_update.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 道具详情
        local player_infor_command_props_info_terminal = {
            _name = "player_infor_command_props_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local update_cost = _ED.base_command_info["".._ED.user_info.command_level].update_cost
                update_cost = zstring.split(update_cost,",")
                state_machine.excute("props_infor_prompt_window_open", 0, {update_cost[1]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_infor_command_window_show_terminal)
        state_machine.add(player_infor_command_window_hide_terminal)
        state_machine.add(player_infor_command_upgrade_terminal)
        state_machine.add(player_infor_command_props_info_terminal)
        state_machine.init()
    end
    
    init_play_info_build_upgrade_terminal()
end

-- 金币升级
function PlayerInfoCommand:sureGoldUpgrade(sure_number)
    if self.roots == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                response.node:updateDraw()
            end
            if tonumber(_ED.user_info.command_state) == 1 then
                TipDlg.drawTextDailog(red_alert_all_str[317])
            else
                checkEffectLevelUp()
                state_machine.excute("player_infomation_update_info",0,"")  
            end
        end
    end
    if sure_number == 0 then
        protocol_command.command_update.param_list = "0"
        NetworkManager:register(protocol_command.command_update.code, nil, nil, nil, self, responseCallback, false, nil) 
    end
end

function PlayerInfoCommand:updateDraw()
    local root = self.roots[1]
    -- 统率等级
    local Text_command_lv = ccui.Helper:seekWidgetByName(root,"Text_command_lv")
    Text_command_lv:setString(string.format(red_alert_time_str[164], _ED.user_info.command_level))
    -- icon
    local Panel_command_icon = ccui.Helper:seekWidgetByName(root,"Panel_command_icon")        
    Panel_command_icon:removeAllChildren(true)
    local update_cost = _ED.base_command_info["".._ED.user_info.command_level].update_cost
    update_cost = zstring.split(update_cost,",")
    local cell = state_machine.excute("props_icon_create_cell",0,{6,1,update_cost[1],1})
    Panel_command_icon:addChild(cell)   

    local Button_command_up = ccui.Helper:seekWidgetByName(root,"Button_command_up")
    local Button_command_up_ten = ccui.Helper:seekWidgetByName(root,"Button_command_up_ten")
    Button_command_up:setVisible(true)
    if tonumber(_ED.base_command_info["".._ED.user_info.command_level].need_level) > tonumber(_ED.user_info.user_grade) then
        Button_command_up:setBright(false)
        Button_command_up_ten:setBright(false)
    else
        Button_command_up:setBright(true)
        Button_command_up_ten:setBright(true)
    end

    -- name
    local prop_name = dms.string(dms["prop_mould"], update_cost[1], prop_mould.prop_name)

    -- 统率带兵量
    local Text_command_famtion_n = ccui.Helper:seekWidgetByName(root,"Text_command_famtion_n")
    local current_famtion = _ED.base_command_info["".._ED.user_info.command_level].current_famtion
    Text_command_famtion_n:setString(current_famtion)

    local Text_command_up_have_n = ccui.Helper:seekWidgetByName(root,"Text_command_up_have_n")
    local Text_command_next_famtion_n = ccui.Helper:seekWidgetByName(root,"Text_command_next_famtion_n")
    local Text_command_success_n = ccui.Helper:seekWidgetByName(root,"Text_command_success_n")
    local Text_command_famtion = ccui.Helper:seekWidgetByName(root,"Text_command_famtion")
    local Text_command_up = ccui.Helper:seekWidgetByName(root,"Text_command_up")
    local Text_command_success_t = ccui.Helper:seekWidgetByName(root,"Text_command_success_t")
    local Text_command_next = ccui.Helper:seekWidgetByName(root,"Text_command_next")
    local Image_command_next_famtion_up = ccui.Helper:seekWidgetByName(root,"Image_command_next_famtion_up")
    local Image_command_box = ccui.Helper:seekWidgetByName(root,"Image_command_box")
    local Text_command_success_vip_add = ccui.Helper:seekWidgetByName(root,"Text_command_success_vip_add")
    -- 下一级统率带兵量
    local next_current_famtion = current_famtion
    if _ED.base_command_info["".._ED.user_info.command_level+1] ~= nil then
        next_current_famtion  = _ED.base_command_info["".._ED.user_info.command_level+1].current_famtion
    else
        Text_command_next:setString(tipStringInfo_union_str[70])
        Text_command_famtion_n:setString("")
        Text_command_up_have_n:setString(red_alert_time_str[197]..current_famtion)
        Text_command_up_have_n:setPositionX(Image_command_box:getContentSize().width/2-30)
        Text_command_next_famtion_n:setString("")
        Text_command_success_n:setString("")
        Text_command_famtion:setString("")
        Text_command_up:setString("")
        Text_command_success_t:setString("")
        Image_command_next_famtion_up:setVisible(false)
        Button_command_up:setVisible(false)
        Button_command_up_ten:setVisible(false)
        return
    end
    Text_command_next_famtion_n:setString(next_current_famtion)
    -- 升级需求
    local need_level = _ED.base_command_info["".._ED.user_info.command_level].need_level
    Text_command_up_have_n:setString(string.format(red_alert_time_str[95],need_level))

    -- 升级成功率
    local success_percent = _ED.base_command_info["".._ED.user_info.command_level].success_percent
    local add_success_percent = dms.int(dms["base_consume"], 87, base_consume.vip_0_value + tonumber(_ED.vip_grade))
    if add_success_percent > 0 then
        local have_success_percent = (add_success_percent/100) * success_percent
        Text_command_success_vip_add:setString("(VIP+"..have_success_percent.."%)")
    end

    -- 全名狂欢活动加成
    local activity_add_percent = 0
    local Text_command_up_act = ccui.Helper:seekWidgetByName(root,"Text_command_up_act")
    Text_command_up_act:setString("")
    if _ED.activity_info ~= nil and _ED.activity_info["84"] ~= nil then
        local info = zstring.split(_ED.activity_info["84"].activity_add_state, ",")
        activity_add_percent = tonumber(info[3])
        local have_success_percent = activity_add_percent * success_percent
        Text_command_up_act:setString("(".._ED.activity_info["84"].activity_title.."+"..have_success_percent.."%)")
    end

    -- 狂欢时刻活动加成
    activity_add_percent = 0
    if _ED.activity_info ~= nil and _ED.activity_info["130"] ~= nil then
        local info = zstring.split(_ED.activity_info["130"].activity_add_state, "|")
        activity_add_percent = tonumber(info[2])
        local have_success_percent = activity_add_percent * success_percent
        Text_command_up_act:setString("(".._ED.activity_info["130"].activity_title.."+"..have_success_percent.."%)")
    end

    local have_success_percent = ((add_success_percent/100) + activity_add_percent) * success_percent
    have_success_percent = have_success_percent + success_percent
    have_success_percent = math.min(100,have_success_percent)
    Text_command_success_n:setString(have_success_percent.."%")
end

function PlayerInfoCommand:onUpdate(dt)

end

--初始化
function PlayerInfoCommand:onInit()
    local csbItem = csb.createNode(config_csb.player.player_infor_command)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boom_up_close"), nil, 
    {
        terminal_name = "player_infor_command_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "player_infor_command_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_command_up"), nil, 
    {
        terminal_name = "player_infor_command_upgrade", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        state = 0,
    }, nil, 1)

    -- 升级十次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_command_up_ten"), nil, 
    {
        terminal_name = "player_infor_command_upgrade", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        state = 1,
    }, nil, 1)

    -- 统帅书详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_command_icon"), nil, 
    {
        terminal_name = "player_infor_command_props_info", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    self:updateDraw()
end

function PlayerInfoCommand:onEnterTransitionFinish()

end

function PlayerInfoCommand:init()
	self:onInit()
    return self
end

function PlayerInfoCommand:onExit()
    state_machine.remove("player_infor_command_window_show")
    state_machine.remove("player_infor_command_window_hide")
    state_machine.remove("player_infor_command_upgrade")
    state_machine.remove("player_infor_command_props_info")
end