-----------------------------
--城池选项
-----------------------------
NationalWarBuildButton = class("NationalWarBuildButtonClass", Window)

local national_war_build_button_window_open_terminal = {
    _name = "national_war_build_button_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalWarBuildButtonClass") == nil then
            fwin:open(NationalWarBuildButton:new():init(params))
        else
            state_machine.excute("national_war_build_button_window_close",0,"")
            fwin:open(NationalWarBuildButton:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_build_button_window_close_terminal = {
    _name = "national_war_build_button_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarBuildButtonClass"))     
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_build_button_window_open_terminal)
state_machine.add(national_war_build_button_window_close_terminal)
state_machine.init()

function NationalWarBuildButton:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.city_id = nil
    -- Initialize national_war_build_button state machine.
    local function init_national_war_build_button_terminal()

        -- 前往
        local national_war_build_button_move_pos_terminal = {
            _name = "national_war_build_button_move_pos",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- print("====前往===点击的城池",instance.city_id)
                local city_id = instance.city_id
                state_machine.excute("national_war_build_button_window_close",0,"")
                state_machine.excute("national_war_map_move_my_pos",0,{city_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 军情
        local national_war_build_button_report_terminal = {
            _name = "national_war_build_button_report",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- print("=====军情==点击的城池",instance.city_id)
                local city_id = instance.city_id
                state_machine.excute("national_war_build_button_window_close",0,"")
                state_machine.excute("national_war_build_infor_window_open",0,{city_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        -- 号令
        local national_war_build_button_decree_terminal = {
            _name = "national_war_build_button_decree",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- print("===号令====点击的城池",instance.city_id)
                local city_id = instance.city_id
                state_machine.excute("national_war_build_decree_window_open",0,{city_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }    

        -- 突进 
        local national_war_build_button_onrush_terminal = {
            _name = "national_war_build_button_onrush",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- print("===突进====点击的城池",instance.city_id)
                local city_id = instance.city_id
                state_machine.excute("national_war_map_onrush",0,{city_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }          
        state_machine.add(national_war_build_button_move_pos_terminal)
        state_machine.add(national_war_build_button_report_terminal) 
        state_machine.add(national_war_build_button_decree_terminal) 
        state_machine.add(national_war_build_button_onrush_terminal)    
        state_machine.init()
    end
    
    -- call func init rebirth state machine.
    init_national_war_build_button_terminal()
end


function NationalWarBuildButton:onUpdateDraw()
    local root = self.roots[1] 
    local state_table = zstring.split(_ED.warfareCityInfo[self.city_id].state,",")
    local Button_national_truce_bilud_onrush = ccui.Helper:seekWidgetByName(root, "Button_national_truce_bilud_onrush")
    local border_city = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould],self.city_id,warfare_map_mould.border_city)
    border_city = zstring.split(border_city,",")
    local can_shoot = false
    for i,v in pairs(border_city) do
        --print("=========",_ED.war_in_city_info.now_city_camp,_ED.user_info.user_force,_ED.warfareCityInfo[tonumber(self.city_id)].camp)
        if zstring.tonumber(_ED.war_user_at_city_id) == tonumber(v) then -- 如果相邻城池中 有玩家所在的城池
            if tonumber(_ED.war_in_city_info.now_city_camp) ~= tonumber(_ED.user_info.user_force) 
                and tonumber(_ED.warfareCityInfo[tonumber(self.city_id)].camp) ~= tonumber(_ED.user_info.user_force) then -- 玩家所在城池阵营不属于玩家 并且 选中当前查看城池不属于玩家
                if tonumber(_ED.war_in_city_info.now_city_camp) == 1 then
                        if tonumber(_ED.user_info.user_force) == 2 then
                            if tonumber(_ED.war_in_city_info.act_of_god_numbers) >= (tonumber(_ED.war_in_city_info.defense_people_number) + zstring.tonumber(_ED.war_in_city_info.union_people_number) )*2 then
                                can_shoot = true
                                break
                            end
                        elseif tonumber(_ED.user_info.user_force) == 3 then
                            if tonumber(_ED.war_in_city_info.natural_numbers) >= (tonumber(_ED.war_in_city_info.defense_people_number)+ zstring.tonumber(_ED.war_in_city_info.union_people_number)) *2 then
                                can_shoot = true
                                break
                            end                            
                        end
                elseif tonumber(_ED.war_in_city_info.now_city_camp) == 2 then
                    
                        if tonumber(_ED.user_info.user_force) == 1 then
                            if tonumber(_ED.war_in_city_info.union_people_number) >= (tonumber(_ED.war_in_city_info.defense_people_number)+ zstring.tonumber(_ED.war_in_city_info.act_of_god_numbers) )*2 then
                                can_shoot = true
                                break
                            end
                        elseif tonumber(_ED.user_info.user_force) == 3 then
                            if tonumber(_ED.war_in_city_info.natural_numbers) >= (tonumber(_ED.war_in_city_info.defense_people_number)+ zstring.tonumber(_ED.war_in_city_info.act_of_god_numbers) )*2 then
                                can_shoot = true
                                break
                            end                            
                        end
                    
                elseif tonumber(_ED.war_in_city_info.now_city_camp) == 3 then
                    if tonumber(_ED.user_info.user_force) == 1 then
                        if tonumber(_ED.war_in_city_info.union_people_number) >= (tonumber(_ED.war_in_city_info.defense_people_number)+ zstring.tonumber(_ED.war_in_city_info.natural_numbers) )*2 then
                            can_shoot = true
                            break
                        end
                    elseif tonumber(_ED.user_info.user_force) == 2 then
                        if tonumber(_ED.war_in_city_info.act_of_god_numbers) >= (tonumber(_ED.war_in_city_info.defense_people_number)+ zstring.tonumber(_ED.war_in_city_info.natural_numbers) )*2 then
                            can_shoot = true
                            break
                        end                            
                    end                    
                end
            end
        end
    end
    if can_shoot == true then --城池突进状态  玩家在其相邻城池 且 不属于 被突进城市阵营
        Button_national_truce_bilud_onrush:setBright(true)
        Button_national_truce_bilud_onrush:setTouchEnabled(true)
    else
        Button_national_truce_bilud_onrush:setBright(false)
        Button_national_truce_bilud_onrush:setTouchEnabled(false)
    end



    local my_camp = tonumber(_ED.user_info.user_force)
    local Button_national_truce_bilud_decree = ccui.Helper:seekWidgetByName(root, "Button_national_truce_bilud_decree")
    local Button_national_truce_bilud_go = ccui.Helper:seekWidgetByName(root, "Button_national_truce_bilud_go")
    local can_decree = false
    for i,v in pairs(border_city) do
        local state = _ED.warfareCityInfo[tonumber(v)].state
        state = zstring.split(state,",")
        if my_camp == tonumber(_ED.warfareCityInfo[tonumber(v)].camp) and tonumber(state[6]) ~= 1 then 
            can_decree = true
        end
    end
    if can_decree == true then
        Button_national_truce_bilud_decree:setBright(true)
        Button_national_truce_bilud_decree:setTouchEnabled(true)      
    else
        Button_national_truce_bilud_decree:setBright(false)
        Button_national_truce_bilud_decree:setTouchEnabled(false)
    end

    local can_move = false
    for i,v in pairs(border_city) do
        --print("=====",my_camp,tonumber(_ED.warfareCityInfo[tonumber(v)].camp))
        if my_camp == tonumber(_ED.warfareCityInfo[tonumber(v)].camp) then 
            can_move = true
        end
    end

    if red_alert_home_city_id[tonumber(_ED.user_info.user_force)] == tonumber(self.city_id) then
        --print("=======222===",can_move)
        can_move = false
    end

    -- local state = _ED.warfareCityInfo[_ED.war_user_at_city_id].state
    -- state = zstring.split(state,",")
    -- if tonumber(state[6]) == 1 then
    --     --print("=======333===",can_move)
    --     can_move = false
    -- end
    --print("==========",can_move)
    if can_move == true then
        Button_national_truce_bilud_go:setBright(true)
        Button_national_truce_bilud_go:setTouchEnabled(true)        
    else
        Button_national_truce_bilud_go:setBright(false)
        Button_national_truce_bilud_go:setTouchEnabled(false)
    end    
    -- 城池状态0,0,0,0,0,0(1:正常,2:可突进,3:包围,4:进攻任务,5:防守任务,6:交战状态)    
end

function NationalWarBuildButton:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_build_button)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:setContentSize(root:getContentSize())
    local action = csb.createTimeline(config_csb.campaign.nationalwar.nationalwar_build_button)
    table.insert(self.actions,action)
    csbItem:runAction(action)
    action:play("nationalwar_bilud",false)
    --关闭 Panel_national_truce_bilud_button
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,""), nil, 
    {
        terminal_name = "national_war_build_button_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    -- 前往
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_national_truce_bilud_go"), nil, 
    {
        terminal_name = "national_war_build_button_move_pos",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    -- 军情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_national_truce_bilud_military_situation"), nil, 
    {
        terminal_name = "national_war_build_button_report",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    -- 号令
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_national_truce_bilud_decree"), nil, 
    {
        terminal_name = "national_war_build_button_decree",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    -- 突进
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_national_truce_bilud_onrush"), nil, 
    {
        terminal_name = "national_war_build_button_onrush",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    self:onUpdateDraw() 
end

function NationalWarBuildButton:init(params)
    self._rootWindows = params[1]
    self.city_id = tonumber(params[2])
    self.pos = params[3]
    self:onInit()
    self:setPosition(self.pos)
    self:setAnchorPoint(cc.p(0.5, 0.5)) 
    return self
end

function NationalWarBuildButton:onExit()
    state_machine.remove("national_war_build_button_move_pos")
    state_machine.remove("national_war_build_button_report")
    state_machine.remove("national_war_build_button_decree") 
    state_machine.remove("national_war_build_button_onrush")     
end
