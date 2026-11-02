-----------------------------
--国战结算奖励
-----------------------------
NationalWarVictoryReward = class("NationalWarVictoryRewardClass", Window)

local nationalwar_victory_reward_window_open_terminal = {
    _name = "nationalwar_victory_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalWarVictoryRewardClass") == nil then
            fwin:open(NationalWarVictoryReward:new():init(),fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local nationalwar_victory_reward_window_close_terminal = {
    _name = "nationalwar_victory_reward_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarVictoryRewardClass"))      
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(nationalwar_victory_reward_window_open_terminal)
state_machine.add(nationalwar_victory_reward_window_close_terminal)
state_machine.init()

function NationalWarVictoryReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.reward_data = {}

    self.country_rank = nil
    self.my_person_rank = nil
    self.reward_state = nil

    local function init_nationalwar_victory_reward_terminal()
        local nationalwar_victory_reward_toget_terminal = {
            _name = "nationalwar_victory_reward_toget",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseKeepAliveCallback(response)
                    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
                        app.load("client.reward.DrawRareReward")
                        if response.node ~= nil and response.node.onUpdateDraw ~= nil then
                            response.node:onUpdateDraw()
                        end
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(57)
                        fwin:open(getRewardWnd, fwin._windows)
                    else
                        state_machine.excute("reward_obtain_window_open",0,{57})
                    end
                end
                NetworkManager:register(protocol_command.draw_warfare_order_reward.code, nil, nil, nil, instance, responseKeepAliveCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(nationalwar_victory_reward_toget_terminal)    
        state_machine.init()
    end
    init_nationalwar_victory_reward_terminal()
  
end


function NationalWarVictoryReward:onUpdateDraw()
    local root = self.roots[1]
    local ListView_reward = ccui.Helper:seekWidgetByName(root,"ListView_reward")
    ListView_reward:removeAllItems()

    local Button_reward_sure = ccui.Helper:seekWidgetByName(root,"Button_reward_sure")
    local Image_already_receive = ccui.Helper:seekWidgetByName(root,"Image_already_receive")
    self.reward_state = zstring.tonumber(_ED.user_war_get_reward_state) 
    if self.reward_state == -1 then
        Button_reward_sure:setBright(false)
        Button_reward_sure:setTouchEnabled(false)
        return
    elseif self.reward_state == 0 then
        Image_already_receive:setVisible(false)
    elseif self.reward_state == 1 then
        Button_reward_sure:setVisible(false)
        Image_already_receive:setVisible(true)
    end

    for i ,v in pairs(self.reward_data) do
        local cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,9,0,false,true})
        ListView_reward:addChild(cell)
    end

end

function NationalWarVictoryReward:getCountryReward()
    local country_reward_data = dms.searchs(dms["warfare_order_reward"], warfare_order_reward.type, 0)
    local country_reward = dms.searchs(country_reward_data, warfare_order_reward.order_begin, self.country_rank)
    local reward_str = dms.string(country_reward,1,warfare_order_reward.reward_info)
    reward_str = zstring.split(reward_str,"|")
    for i,v in pairs(reward_str) do
        local data_table = zstring.split(v,",")
        local prop_types = data_table[1]
        local prop_ids = data_table[2]
        local prop_numbers = data_table[3]
        local data = 
        {
            prop_type = prop_types,
            prop_item = prop_ids,
            item_value = prop_numbers,
        }
        table.insert(self.reward_data,data)
    end
    -- debug.print_r(self.reward_data)
end

function NationalWarVictoryReward:getPersonReward()
    local person_reward_data = dms.searchs(dms["warfare_order_reward"], warfare_order_reward.type, 1)

    if self.my_person_rank > 1000 then
        local reward_str = dms.string(dms["warfare_order_reward"],12,warfare_order_reward.reward_info)
        reward_str = zstring.split(reward_str,"|")
        for i,v in pairs(reward_str) do
            local data_table = zstring.split(v,",")
            local prop_types = data_table[1]
            local prop_ids = data_table[2]
            local prop_numbers = data_table[3]
            local data = 
            {
                prop_type = prop_types,
                prop_item = prop_ids,
                item_value = prop_numbers,
            }

            for i,v in pairs(self.reward_data) do
                if v.prop_type == data.prop_type and  v.prop_item == data.prop_item then
                    v.item_value = tonumber(v.item_value) + tonumber(data.item_value)
                end
            end
            table.insert(self.reward_data,data)  
        end        
        return
    end

    for i=1,dms.count(person_reward_data) do
        local order_end = dms.int(person_reward_data,i,warfare_order_reward.order_end)
        local order_begin = dms.int(person_reward_data,i,warfare_order_reward.order_begin)

        if self.my_person_rank <= order_end and self.my_person_rank >= order_begin then
            local reward_str = dms.string(person_reward_data,i,warfare_order_reward.reward_info)
            reward_str = zstring.split(reward_str,"|")
            for i,v in pairs(reward_str) do
                local data_table = zstring.split(v,",")
                local prop_types = data_table[1]
                local prop_ids = data_table[2]
                local prop_numbers = data_table[3]
                local data = 
                {
                    prop_type = prop_types,
                    prop_item = prop_ids,
                    item_value = prop_numbers,
                }
                -- debug.print_r(data)
                local the_same  =  false
                for i,v in pairs(self.reward_data) do
                    -- print("========",v.prop_type,data.prop_type,v.prop_item,data.prop_item)
                    if tonumber(v.prop_type) == tonumber(data.prop_type) and  tonumber(v.prop_item) == tonumber(data.prop_item) then
                        v.item_value = tonumber(v.item_value) + tonumber(data.item_value)
                        the_same = true 
                    end
                end
                if the_same == false then
                    table.insert(self.reward_data,data) 
                end
            end        
        end

    end
end

function NationalWarVictoryReward:getLastRank()
    self.country_rank = zstring.tonumber(_ED.user_war_now_country_rank)
    self.my_person_rank = zstring.tonumber(_ED.user_war_now_person_rank) 
    self.reward_state = zstring.tonumber(_ED.user_war_get_reward_state) 

    if self.country_rank == 0 or self.my_person_rank == 0 then
        return
    end
    self:getCountryReward()
    self:getPersonReward()
end

function NationalWarVictoryReward:onInit( )

    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_victory_reward)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)


    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "nationalwar_victory_reward_window_close",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)    
    -- 领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reward_sure"), nil, 
    {
        terminal_name = "nationalwar_victory_reward_toget",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
    
    self:onUpdateDraw() 
end

function NationalWarVictoryReward:init()
    self:getLastRank()
    self:onInit()
    return self
end

function NationalWarVictoryReward:onExit()
    state_machine.remove("nationalwar_victory_reward_toget")
end
