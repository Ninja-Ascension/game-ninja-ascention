-----------------------------
--神兵副本主界面
-----------------------------
GodWeaponryDuplicate = class("GodWeaponryDuplicateClass", Window)

local god_weaponry_duplicate_window_open_terminal = {
    _name = "god_weaponry_duplicate_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(86) == true then
            return
        end
        fwin:close("GodWeaponryDuplicateClass")
        
        state_machine.excute("home_select_action_window_close", 0, nil)
        if fwin:find("MainWindowClass") == nil then
            state_machine.excute("main_window_open",0,1)
        else
            local _Window = GodWeaponryDuplicate:new():init(params)
            fwin:open(_Window, fwin._ui)
        end
        
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local god_weaponry_duplicate_window_close_terminal = {
    _name = "god_weaponry_duplicate_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GodWeaponryDuplicateClass"))
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(god_weaponry_duplicate_window_open_terminal)
state_machine.add(god_weaponry_duplicate_window_close_terminal)
state_machine.init()

function GodWeaponryDuplicate:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.duplicates = {}
    self.npc_state = {}
    self.chooseLeftIndex = 0
    -- 副本难度
    self._duplicate_level = 0 
    app.load("client.red_alert.god_weaponry.GodWeaponryBuyTimes")
    app.load("client.red_alert.god_weaponry.GodWeaponryDuplicateInfor")
    app.load("client.red_alert.cells.god_weaponry.god_weaponry_duplicate_left_cell")

    local function init_god_weaponry_duplicate_terminal()
		local god_weaponry_duplicate_buy_times_terminal = {
            _name = "god_weaponry_duplicate_buy_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("god_weaponry_buy_times_window_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local god_weaponry_duplicate_choose_npc_terminal = {
            _name = "god_weaponry_duplicate_choose_npc",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                if instance.npc_state[index] < 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[105])
                    return
                end
                state_machine.excute("god_weaponry_duplicate_infor_window_open",0,{instance.duplicates[index],instance.chooseLeftIndex,instance.npc_state[index]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local god_weaponry_duplicate_left_once_terminal = {
            _name = "god_weaponry_duplicate_left_once",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeLeftSelectState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local god_weaponry_duplicate_update_draw_terminal = {
            _name = "god_weaponry_duplicate_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(god_weaponry_duplicate_buy_times_terminal)
		state_machine.add(god_weaponry_duplicate_choose_npc_terminal)	
        state_machine.add(god_weaponry_duplicate_left_once_terminal)   
        state_machine.add(god_weaponry_duplicate_update_draw_terminal)
        state_machine.init()
    end
    
    init_god_weaponry_duplicate_terminal()
end

function GodWeaponryDuplicate:changeLeftSelectState( selectedIndex )
    local root = self.roots[1]
    local ListView_left = ccui.Helper:seekWidgetByName(root, "ListView_left")
    self.chooseLeftIndex = selectedIndex
    local items = ListView_left:getItems()
    for i, v in pairs(items) do
        v:changeSelectedState(i == self.chooseLeftIndex)
    end
    self:initData(selectedIndex)
    self:onUpdateDraw(selectedIndex)
end

function GodWeaponryDuplicate:onUpdateDrawLeft()
    local root = self.roots[1]
    local ListView_left = ccui.Helper:seekWidgetByName(root, "ListView_left")
    local index = 1
    for i = 1, dms.count( dms["pve_scene"] ) do 
        local scene_type = dms.int(dms["pve_scene"], i, pve_scene.scene_type)
        if scene_type == 103 then
            local cell = state_machine.excute("god_weaponry_duplicate_left_create_cell",0,{index})
            ListView_left:addChild(cell)
            ListView_left:requestRefreshView()
            self:changeLeftSelectState(self._duplicate_level)
            index = index + 1
        end
    end
end

function GodWeaponryDuplicate:onUpdateDraw(selectedIndex)
    local root = self.roots[1]
    -- 攻击次数
    local attack_times = zstring.tonumber(_ED.weaponry_attack_times)
    local Text_today_last_time_v = ccui.Helper:seekWidgetByName(root, "Text_today_last_time_v")
    Text_today_last_time_v:setString(attack_times)
    for i,v in pairs(self.npc_state) do
        local Text_boss_name = ccui.Helper:seekWidgetByName(root,"Text_boss_name_"..i)
        Text_boss_name:setString(gems_duplicate_level[self.chooseLeftIndex].. "·" .. self.duplicates[i].name)
        local Button_gem_duplicate_pvp = ccui.Helper:seekWidgetByName(root,"Button_gem_duplicate_pvp_"..i)

        if v < 0 then
            Button_gem_duplicate_pvp:setBright(false)
        else
            Button_gem_duplicate_pvp:setBright(true)
        end
    end
end

function GodWeaponryDuplicate:onEnterTransitionFinish()
    
end

function GodWeaponryDuplicate:initData(selectedIndex)
    self.duplicates = {}

    local index = 1
    local duplicate_level = selectedIndex + 73
    local npc_str = dms.string(dms["pve_scene"], duplicate_level, pve_scene.npcs)
    local npc_tables =  zstring.split(npc_str,",")
    for i,v in pairs(npc_tables) do
        local npc_name = dms.string(dms["npc"], npc_tables[i], npc.npc_name)
        local reward_id = dms.int(dms["npc"], npc_tables[i], npc.drop_library)
        local sign_msg = dms.string(dms["npc"], npc_tables[i], npc.sign_msg)
        local reward_items = dms.string(dms["scene_reward"], reward_id, scene_reward.reward_items)
        reward_items = zstring.split(reward_items,"|")
        local reward_table = {}
        for j, v in pairs(reward_items) do
            local data_temp = zstring.split(v,",")
            reward_table[j] = {
                prop_item = data_temp[1],
                prop_type = data_temp[2],
                item_value = data_temp[3],
            } 
        end
        local data = {
            id = index,
            name = npc_name,
            msg = sign_msg,
            npcids = npc_tables[i],
            reward_data = reward_table,
            scene_id = duplicate_level,
        }
        table.insert(self.duplicates, data)
        index = index + 1
    end

    self.npc_state = {}
    for i, info in pairs(self.duplicates) do
        local state = tonumber(_ED.npc_state[tonumber(info.npcids)])  -- -1 没开启 0 开启了 >0 过关
        table.insert(self.npc_state, state)
    end
    -- debug.print_r(self.duplicates)
    -- debug.print_r(self.npc_state)
end

function GodWeaponryDuplicate:onInit( )
    local csbItem = csb.createNode(config_csb.god_weaponry.god_weaponry_duplicate)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "god_weaponry_duplicate_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add_time"), nil, 
    {
        terminal_name = "god_weaponry_duplicate_buy_times", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    for i=1,6 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gem_duplicate_pvp_"..i), nil, 
        {
            terminal_name = "god_weaponry_duplicate_choose_npc", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i,
        }, nil, 0)
    end

    self:onUpdateDrawLeft()
end

function GodWeaponryDuplicate:init(params)
    if tonumber(params) == nil then
        params = 1 
    end
    self._duplicate_level = params
	self:onInit()
    return self
end

function GodWeaponryDuplicate:onExit()
    state_machine.remove("god_weaponry_duplicate_buy_times")
    state_machine.remove("god_weaponry_duplicate_choose_npc")
    state_machine.remove("god_weaponry_duplicate_left_once")
    state_machine.remove("god_weaponry_duplicate_update_draw")
end
