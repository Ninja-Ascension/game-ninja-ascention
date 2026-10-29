--城池详情
-----------------------------
NationalWarBuildInfor = class("NationalWarBuildInforClass", Window)

local national_war_build_infor_window_open_terminal = {
    _name = "national_war_build_infor_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalWarBuildInforClass") == nil then
            local city_id = params[1]
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                   fwin:open(NationalWarBuildInfor:new():init(city_id),fwin._ui)
                end
            end  
            protocol_command.look_up_war_situation.param_list = ""..city_id
            NetworkManager:register(protocol_command.look_up_war_situation.code, nil, nil, nil,nil, responseCallback, false, nil)       
        end        
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_build_infor_window_close_terminal = {
    _name = "national_war_build_infor_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarBuildInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(national_war_build_infor_window_open_terminal)
state_machine.add(national_war_build_infor_window_close_terminal)
state_machine.init()

function NationalWarBuildInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.city_id = nil
    app.load("client.red_alert.campaign.nationalwar.NationalWarBuildInforCell")
    -- Initialize national_war_build_infor state machine.
    local function init_national_war_build_infor_terminal()

        -- 
        local national_truce_build_infor_click_city_terminal = {
            _name = "national_truce_build_infor_click_city",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 

                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(national_truce_build_infor_click_city_terminal)    
        state_machine.init()
    end
    
    -- call func init national_truce_build_infor state machine.
    init_national_war_build_infor_terminal()
end


function NationalWarBuildInfor:onUpdateDraw()
    local root = self.roots[1]
    local city_data_table = dms.element(dms[config_res.campaign.nationalwar.warfare_map_mould],self.city_id)
    local name = dms.atos(city_data_table,warfare_map_mould.city_name)
    local gain_property = dms.atoi(city_data_table,warfare_map_mould.gain_property)
    local subjoin_property = dms.atoi(city_data_table,warfare_map_mould.subjoin_property)

    local Panel_build_infor_build = ccui.Helper:seekWidgetByName(root,"Panel_build_infor_build") -- 城池图片
    local pic_index = dms.int(dms[config_res.campaign.nationalwar.warfare_map_mould],self.city_id,warfare_map_mould.city_pic)
    Panel_build_infor_build:setBackGroundImage("images/ui/play/nationalwar/build/nationalwar_building_".. pic_index ..".png")
    local Text_build_infor_name = ccui.Helper:seekWidgetByName(root,"Text_build_infor_name") -- 城池名字
    Text_build_infor_name:setString(name)
    local Text_build_infor_des = ccui.Helper:seekWidgetByName(root,"Text_build_infor_des") -- 增益描述
    local str_dec = ""
    if gain_property == -1 then
        str_dec = ""
    else
        str_dec = red_alert_hero_camp[gain_property]..string.format(red_alert_all_str[40],subjoin_property,subjoin_property)
    end
    if subjoin_property == -1 then
        str_dec = ""
    end    
    Text_build_infor_des:setString(str_dec)
    local Text_build_infor_home = ccui.Helper:seekWidgetByName(root,"Text_build_infor_home") -- 城池当前所属
    if tonumber(self.city_data.now_city_camp) == 0 then
        -- print("=============",self.city_data.now_city_camp,red_alert_hero_camp[4])
        Text_build_infor_home:setString(red_alert_hero_camp[4])
    else
        -- print("=============",self.city_data.now_city_camp,red_alert_hero_camp[tonumber(self.city_data.now_city_camp)])
        Text_build_infor_home:setString(red_alert_hero_camp[tonumber(self.city_data.now_city_camp)])
    end
    
    local have_official = false
    for i,v in pairs(self.city_data.official_info_table) do
        local Panel_build_infor_officer = ccui.Helper:seekWidgetByName(root,"Panel_build_infor_officer_"..i)
        Panel_build_infor_officer:setVisible(true)
        local Panel_build_infor_officer_camp = ccui.Helper:seekWidgetByName(root,"Panel_build_infor_officer_camp_"..i)
        Panel_build_infor_officer_camp:setBackGroundImage("images/ui/play/nationalwar/camp_text_"..i..".png")
        local Text_build_infor_officer_level = ccui.Helper:seekWidgetByName(root,"Text_build_infor_officer_level_"..i)
        Text_build_infor_officer_level:setString(red_alert_officer[v.official_level]..v.name)
        Text_build_infor_officer_level:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        have_official = true
    end

    local Text_build_infor_officer_no = ccui.Helper:seekWidgetByName(root,"Text_build_infor_officer_no")
    if have_official == true then
        Text_build_infor_officer_no:setVisible(false)
    else
        Text_build_infor_officer_no:setVisible(true)
    end

end

function NationalWarBuildInfor:onUpdateDrawCampShow()
    local root = self.roots[1]
    local ListView_build_infor_war = ccui.Helper:seekWidgetByName(root,"ListView_build_infor_war")
    -- ListView_build_infor_war:setContentSize(cc.size(640,130))
    local index = 0
    local width = 0
    if #self.city_data.attack_info_table == 0 then  -- 没有攻击方
        for i,v in pairs(self.city_data.defense_info_table) do
            local cell = state_machine.excute("national_war_build_infor_create_cell",0,{v.camp,v.number,2})
            ListView_build_infor_war:addChild(cell)
            index = index + 1
            width = cell:getContentSize().width
        end
    else
        for i,v in pairs(self.city_data.attack_info_table) do
            local cell = state_machine.excute("national_war_build_infor_create_cell",0,{v.camp,v.number,1})
            ListView_build_infor_war:addChild(cell)
            index = index + 1
            width = cell:getContentSize().width
        end
        local cell = state_machine.excute("national_war_build_infor_create_cell",0,{nil})
        ListView_build_infor_war:addChild(cell)
        index = index + 1
        width = cell:getContentSize().width

        if #self.city_data.defense_info_table == 1 then
            local cell = state_machine.excute("national_war_build_infor_create_cell",0,{_ED.war_city_fight_info[self.city_id].now_city_camp,0,2})
            ListView_build_infor_war:addChild(cell)
            index = index + 1
            width = cell:getContentSize().width
        end         
        for i,v in pairs(self.city_data.defense_info_table) do
            local cell = state_machine.excute("national_war_build_infor_create_cell",0,{v.camp,v.number,2})
            ListView_build_infor_war:addChild(cell)
            index = index + 1
            width = cell:getContentSize().width
        end 
        --print("=========",#self.city_data.defense_info_table,_ED.war_city_fight_info[self.city_id].defense_number)

    end
    ListView_build_infor_war:setContentSize(cc.size(width*index,ListView_build_infor_war:getContentSize().height))
end

function NationalWarBuildInfor:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_build_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)


    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_build_infor_close"), nil, 
    {
        terminal_name = "national_war_build_infor_window_close",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    
    self:onUpdateDraw() 
    self:onUpdateDrawCampShow()
end

function NationalWarBuildInfor:init(city_id)
    self.city_id = city_id
    self.city_data = _ED.war_city_fight_info[city_id]
    --debug.print_r(self.city_data)
    self:onInit()
    return self
end

function NationalWarBuildInfor:onExit()
    state_machine.remove("national_truce_build_infor_click_city")
end
