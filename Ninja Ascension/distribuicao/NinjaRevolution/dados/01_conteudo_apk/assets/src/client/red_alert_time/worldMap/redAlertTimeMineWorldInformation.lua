-- ----------------------------------------------------------------------------------------------------
-- 说明：世界信息
-------------------------------------------------------------------------------------------------------
redAlertTimeMineWorldInformation = class("redAlertTimeMineWorldInformationClass", Window)

local red_alert_time_mine_world_information_open_terminal = {
    _name = "red_alert_time_mine_world_information_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineWorldInformationClass")
        if nil == _homeWindow then
    		fwin:open(redAlertTimeMineWorldInformation:new():init(), fwin._dview)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_world_information_close_terminal = {
    _name = "red_alert_time_mine_world_information_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMineWorldInformationClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("redAlertTimeMineWorldInformationClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_mine_world_information_open_terminal)
state_machine.add(red_alert_time_mine_world_information_close_terminal)
state_machine.init()
    
function redAlertTimeMineWorldInformation:ctor()
    self.super:ctor()
    self.roots = {}

end

function redAlertTimeMineWorldInformation:init()
    self:onInit()
    return self
end

function redAlertTimeMineWorldInformation:onInit()
    local csbredAlertTimeMineWorldInformation = csb.createNode(config_csb.world_map.world_lv)
    local root = csbredAlertTimeMineWorldInformation:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMineWorldInformation)
	--世界等级
	local Text_world_lv_n = ccui.Helper:seekWidgetByName(root,"Text_world_lv_n")
	Text_world_lv_n:setString(_ED.world_level)
	--我的等级
	local Text_world_me_lv_n = ccui.Helper:seekWidgetByName(root,"Text_world_me_lv_n")
	Text_world_me_lv_n:setString(_ED.user_info.user_grade)
	--经验加成
    local wdatas = zstring.split(dms.string(dms["world_config"], 17 , world_config.param), "|")
    local additionOne = zstring.split(wdatas[1],",")
    local additionTwo = zstring.split(wdatas[2],",")
    local m_addition = 0
    if tonumber(_ED.user_info.user_grade) < tonumber(_ED.world_level) then
        if tonumber(_ED.world_level) - tonumber(_ED.user_info.user_grade) >= tonumber(math.max(additionOne[1],additionTwo[1])) then
            m_addition = math.max(additionOne[2],additionTwo[2])
        else
            m_addition = math.min(additionOne[2],additionTwo[2])
        end
    end
	local Text_world_me_exp_n = ccui.Helper:seekWidgetByName(root,"Text_world_me_exp_n")
	Text_world_me_exp_n:setString(((1+tonumber(m_addition))*100).."%")
	--叛军出没加速
    local march_addition = dms.string(dms["world_level_addition_param"], _ED.world_level, world_level_addition_param.march_addition)
    local Text_world_lv_effice_1 = ccui.Helper:seekWidgetByName(root,"Text_world_lv_effice_1")
	Text_world_lv_effice_1:setString((tonumber(march_addition)*100).."%")
	--繁荣度恢复速度
    local boom_addition = dms.string(dms["world_level_addition_param"], _ED.world_level, world_level_addition_param.boom_addition)
	local Text_world_lv_effice_2 = ccui.Helper:seekWidgetByName(root,"Text_world_lv_effice_2")
	Text_world_lv_effice_2:setString((tonumber(boom_addition)*100).."%")
	--商店资源包优惠
    local store_addition = dms.string(dms["world_level_addition_param"], _ED.world_level, world_level_addition_param.store_addition)
	local Text_world_lv_effice_3 = ccui.Helper:seekWidgetByName(root,"Text_world_lv_effice_3")
	Text_world_lv_effice_3:setString((tonumber(store_addition)*100).."%")
	local MaxLevel = 0
    if _ED.world_level+1 < 70 then
        MaxLevel = _ED.world_level+1
    else
        MaxLevel = 70
    end
    --下一级叛军出没加速
    local march_addition_next = dms.string(dms["world_level_addition_param"], MaxLevel, world_level_addition_param.march_addition)
	local Text_world_lv_next_effice_1 = ccui.Helper:seekWidgetByName(root,"Text_world_lv_next_effice_1")
	Text_world_lv_next_effice_1:setString((tonumber(march_addition_next)*100).."%")
	--下一级繁荣度恢复速度
    local boom_addition_next = dms.string(dms["world_level_addition_param"], MaxLevel, world_level_addition_param.boom_addition)
	local Text_world_lv_next_effice_2 = ccui.Helper:seekWidgetByName(root,"Text_world_lv_next_effice_2")
	Text_world_lv_next_effice_2:setString((tonumber(boom_addition_next)*100).."%")
	--下一级商店资源包优惠
    local store_addition_next = dms.string(dms["world_level_addition_param"], MaxLevel, world_level_addition_param.store_addition)
	local Text_world_lv_next_effice_3 = ccui.Helper:seekWidgetByName(root,"Text_world_lv_next_effice_3")
	Text_world_lv_next_effice_3:setString((tonumber(store_addition_next)*100).."%")
	
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_world_lv_close"), nil, 
    {
        terminal_name = "red_alert_time_mine_world_information_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_mine_world_information_close",
        terminal_state = 0,
    },
    nil,3)
	
end

function redAlertTimeMineWorldInformation:onExit()
	
end