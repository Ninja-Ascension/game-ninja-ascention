-----------------------------
--战斗失败结算
-----------------------------
NationalWarRecord = class("NationalWarRecordClass", Window)

local national_war_record_window_open_terminal = {
    _name = "national_war_record_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalWarRecordClass") == nil then
            local city_id = params[1]
            fwin:open(NationalWarRecord:new():init(city_id), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_record_window_close_terminal = {
    _name = "national_war_record_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarRecordClass"))  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_record_window_open_terminal)
state_machine.add(national_war_record_window_close_terminal)
state_machine.init()

function NationalWarRecord:ctor()
    self.super:ctor()
    self.roots = {}
    self.city_id = nil
    -- -- Initialize national_war_decree machine.
    local function init_national_war_record_terminal()

    end
    
    -- call func init national_war_decree machine.
    init_national_war_record_terminal()
end

function NationalWarRecord:onUpdateDraw()
        --击败敌人 挫败兵力 活动荣耀 最高连斩
    local root = self.roots[1]

    local Text_record_troops = ccui.Helper:seekWidgetByName(root,"Text_record_troops")
    Text_record_troops:setString(zstring.tonumber(_ED.war_fight_fail_info.kill_hp))
    
    local Text_record_enemy = ccui.Helper:seekWidgetByName(root,"Text_record_enemy")
    Text_record_enemy:setString(zstring.tonumber(_ED.war_fight_fail_info.kill_person))

    local Text_record_glory = ccui.Helper:seekWidgetByName(root,"Text_record_glory")
    Text_record_glory:setString(zstring.tonumber(_ED.war_fight_fail_info.get_hornor))

    local Text_record_even_cut = ccui.Helper:seekWidgetByName(root,"Text_record_even_cut")
    Text_record_even_cut:setString(zstring.tonumber(_ED.war_fight_fail_info.kill_max))

    local Text_record_describe = ccui.Helper:seekWidgetByName(root,"Text_record_describe")
    if ___is_open_leadname == true then 
        Text_record_describe:setFontName("")
        Text_record_describe:setFontSize(Text_record_describe:getFontSize())
    end
    local city_name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],self.city_id,warfare_map_mould.city_name)
    Text_record_describe:setString(string.format(red_alert_all_str[42],_ED.war_fight_fail_info.otherSideName,city_name))
    local Panel_record_camp = ccui.Helper:seekWidgetByName(root,"Panel_record_camp")
    Panel_record_camp:setBackGroundImage("images/ui/play/nationalwar/camp_text_"..zstring.tonumber(_ED.war_fight_fail_info.otherSideCountry)..".png")
    
    _ED.war_fight_fail_info.kill_person = 0
    _ED.war_fight_fail_info.kill_hp = 0
    _ED.war_fight_fail_info.get_hornor = 0
    _ED.war_fight_fail_info.kill_max = 0
    _ED.war_fight_fail_info.otherSideName = ""
    _ED.war_fight_fail_info.otherSideCountry = ""
end

function NationalWarRecord:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_record)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_record_sure"), nil, 
    {
        terminal_name = "national_war_record_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
     
    self:onUpdateDraw() 
end

function NationalWarRecord:init(city_id)
    self.city_id = city_id
    self:onInit()
    return self
end

function NationalWarRecord:onExit()

end
