-----------------------------
--战况
-----------------------------
NationalWarFighting = class("NationalWarFightingClass", Window)

local national_war_fighting_window_open_terminal = {
    _name = "national_war_fighting_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalWarFightingClass") == nil then
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    fwin:open(NationalWarFighting:new():init(), fwin._ui)
                end
            end
            NetworkManager:register(protocol_command.look_up_situation.code, nil, nil, nil,nil, responseCallback, false, nil)       
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_fighting_window_close_terminal = {
    _name = "national_war_fighting_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarFightingClass"))  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_fighting_window_open_terminal)
state_machine.add(national_war_fighting_window_close_terminal)
state_machine.init()

function NationalWarFighting:ctor()
    self.super:ctor()
    self.roots = {}
    -- Initialize national_war_decree machine.
    local function init_nationalwar_fighting_terminal()
        -- 参战
        local nationalwar_fighting_join_terminal = {
            _name = "nationalwar_fighting_join",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local city_id = params._datas.city_id
                state_machine.excute("national_war_map_scroll_to_city",0,{city_id})
                state_machine.excute("national_war_fighting_window_close",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(nationalwar_fighting_join_terminal)    
        state_machine.init()
    end
    
    -- call func init national_war_decree machine.
    init_nationalwar_fighting_terminal()
end


function NationalWarFighting:onUpdateDraw()
    local root = self.roots[1]
    for i,v in pairs(_ED.warfar_news.fight_info) do
        local Panel_build_infor = ccui.Helper:seekWidgetByName(root,"Panel_build_infor_"..i)
        local Panel_build_icon = Panel_build_infor:getChildByName("Panel_build_icon")
        local Text_build_name = Panel_build_infor:getChildByName("Text_build_name")
        local Text_build_camp_v_1 = Panel_build_infor:getChildByName("Text_build_camp_v_1")
        local Text_build_camp_v_2 = Panel_build_infor:getChildByName("Text_build_camp_v_2")
        local Text_build_camp_v_3 = Panel_build_infor:getChildByName("Text_build_camp_v_3")
        local Text_build_camp_v_4 = Panel_build_infor:getChildByName("Text_build_camp_v_4")
        local Panel_build_camp_1 = Panel_build_infor:getChildByName("Panel_build_camp_1")
        local Panel_build_camp_2 = Panel_build_infor:getChildByName("Panel_build_camp_2")
        local Panel_build_camp_3 = Panel_build_infor:getChildByName("Panel_build_camp_3")
        local Panel_build_camp_4 = Panel_build_infor:getChildByName("Panel_build_camp_4")

        local city_id = tonumber(v.city_id)
        local attack_camp = zstring.split(v.attack_camp,",")
        if zstring.tonumber(attack_camp[1]) == 0 then
            Text_build_camp_v_1:setString(0)
        else
            Text_build_camp_v_1:setString(zstring.tonumber(v.all_people_numbers[tonumber(attack_camp[1])]))
        end

        if zstring.tonumber(attack_camp[1]) == 0 then
            Text_build_camp_v_2:setString(0)
        else
            Text_build_camp_v_2:setString(zstring.tonumber(v.all_people_numbers[tonumber(attack_camp[2])]))
        end

        Text_build_camp_v_3:setString(zstring.tonumber(v.guard_numbers))
        
        local defense_camp = zstring.split(v.defense_camp,",")
        if zstring.tonumber(defense_camp[1]) == 0 then
            Text_build_camp_v_4:setString(0)
        else
            Text_build_camp_v_4:setString(zstring.tonumber(v.all_people_numbers[tonumber(defense_camp[1])]))
        end
        Panel_build_camp_1:setBackGroundImage("images/ui/play/nationalwar/camp_text_"..attack_camp[1]..".png")
        Panel_build_camp_2:setBackGroundImage("images/ui/play/nationalwar/camp_text_"..attack_camp[2]..".png")
        Panel_build_camp_3:setBackGroundImage("images/ui/play/nationalwar/camp_text_0.png")
        Panel_build_camp_4:setBackGroundImage("images/ui/play/nationalwar/camp_text_".. defense_camp[1]..".png")
        local name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],city_id,warfare_map_mould.city_name)
        Text_build_name:setString(name)
        local pic_index = dms.int(dms[config_res.campaign.nationalwar.warfare_map_mould],city_id,warfare_map_mould.city_pic)
        Panel_build_icon:setBackGroundImage("images/ui/play/nationalwar/build/nationalwar_building_".. pic_index ..".png")

        local Button_build_attend = Panel_build_infor:getChildByName("Button_build_attend_"..i)
        -- 参战
        fwin:addTouchEventListener(Button_build_attend, nil, 
        {
            terminal_name = "nationalwar_fighting_join",
            terminal_state = 0, 
            touch_scale = true,
            city_id = city_id,
            touch_scale_xy = 0.95,
        }, nil, 0)        
    end

    local Text_build_occupy_v_1 = ccui.Helper:seekWidgetByName(root,"Text_build_occupy_v_1")
    local Text_build_occupy_v_2 = ccui.Helper:seekWidgetByName(root,"Text_build_occupy_v_2")
    local Text_build_occupy_v_3 = ccui.Helper:seekWidgetByName(root,"Text_build_occupy_v_3")
    Text_build_occupy_v_1:setString(_ED.warfar_news.tribe_city_numbers)
    Text_build_occupy_v_2:setString(_ED.warfar_news.union_city_numbers)
    Text_build_occupy_v_3:setString(_ED.warfar_news.neutral_city_numbers)

end

function NationalWarFighting:onInit()
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_fighting)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_fighting_close"), nil, 
    {
        terminal_name = "national_war_fighting_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    self:onUpdateDraw() 
end

function NationalWarFighting:init()
    self:onInit()
    return self
end

function NationalWarFighting:onExit()
    state_machine.remove("nationalwar_fighting_join")
end
