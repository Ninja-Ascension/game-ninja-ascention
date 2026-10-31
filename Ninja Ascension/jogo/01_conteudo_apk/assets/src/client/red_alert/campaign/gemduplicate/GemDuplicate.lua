-----------------------------
--宝石副本
-----------------------------
GemDuplicate = class("GemDuplicateClass", Window)

local gem_duplicate_window_open_terminal = {
    _name = "gem_duplicate_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(112) == true then
            return
        end   
        if nil == fwin:find("GemDuplicateClass") then
            fwin:open(GemDuplicate:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local gem_duplicate_window_close_terminal = {
    _name = "gem_duplicate_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GemDuplicateClass"))
        if fwin:find("TaskClass") ~= nil then
            state_machine.excute("campaign_window_close",0,"") 
            state_machine.excute("task_window_show",0,"") 
            state_machine.excute("player_resource_window_hide",0,"") 
            state_machine.excute("home_button_for_action_window_hide",0,"") 
            state_machine.excute("chat_view_window_hide",0,"")
            state_machine.excute("seven_star_map_ui_window_hide",0,"")
        end
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(gem_duplicate_window_open_terminal)
state_machine.add(gem_duplicate_window_close_terminal)
state_machine.init()

function GemDuplicate:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    app.load("client.red_alert.campaign.gemduplicate.GemDuplicateTow")

    -- Initialize gem_duplicate state machine.
    local function init_gem_duplicate_terminal()
	
        --点击打开对应的宝石副本出战界面
        local gem_duplicate_check_open_tow_terminal = {
            _name = "gem_duplicate_check_open_tow",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params._datas.index
                if instance.npc_state[index][1].state < 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[105])
                    return
                end
                if  tonumber(_ED.get_star_count[tonumber(instance.gem_duplicate[index].scene_id)]) > 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[134])
                    return
                end
                state_machine.excute("gem_duplicate_tow_window_open",0,{instance.npc_state[index],instance.gem_duplicate[index]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 刷新
        local gem_duplicate_update_draw_terminal = {
            _name = "gem_duplicate_update_draw",
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

		state_machine.add(gem_duplicate_check_open_tow_terminal)
        state_machine.add(gem_duplicate_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init gem_duplicate state machine.
    init_gem_duplicate_terminal()
end


function GemDuplicate:onUpdateDraw()
    local root = self.roots[1]

    for i,v in pairs(self.npc_state) do
        local Text_boss_name = ccui.Helper:seekWidgetByName(root,"Text_boss_name_"..i)
        Text_boss_name:setString(gems_duplicate_level[v.open_level].. "·" .. self.gem_duplicate[i].name)
        local Button_gem_duplicate_pvp = ccui.Helper:seekWidgetByName(root,"Button_gem_duplicate_pvp_"..i)

        --已击败
        local Image_gem_duplicate_fail = ccui.Helper:seekWidgetByName(root,"Image_gem_duplicate_fail_"..i)
        local Text_gem_duplicate_fail = ccui.Helper:seekWidgetByName(root,"Text_gem_duplicate_fail_"..i)
        Image_gem_duplicate_fail:setVisible(false)
        Text_gem_duplicate_fail:setVisible(false)
        if v[1].state < 0 then
            Button_gem_duplicate_pvp:setBright(false)
        end
        if tonumber(_ED.get_star_count[tonumber(self.gem_duplicate[i].scene_id)]) > 0 then
            Button_gem_duplicate_pvp:setBright(false)
            Image_gem_duplicate_fail:setVisible(true)
            Text_gem_duplicate_fail:setVisible(true)
        end
    end
end

function GemDuplicate:onEnterTransitionFinish()

end

function GemDuplicate:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.gemduplicate.gem_duplicate)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "gem_duplicate_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
  
    -- 点击打开对应的宝石副本出战界面
    for i = 1,6 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_gem_duplicate_pvp_"..i), nil, 
        {
            terminal_name = "gem_duplicate_check_open_tow",
            terminal_state = 0,
            index = i,
            touch_scale = true,
            touch_scale_xy = 0.95,

        }, nil, 0)
    end  
	self:onUpdateDraw()
end

--初始化数据
function GemDuplicate:initData()
    self.gem_duplicate = {}

    local index = 1
    for i = 1, dms.count( dms["pve_scene"] ) do 
        local scene_type = dms.int(dms["pve_scene"],i,pve_scene.scene_type)
        if scene_type == 16 then
            local npc_str = dms.string(dms["pve_scene"],i,pve_scene.npcs)
            local npc_tables =  zstring.split(npc_str,",")
            local npc_name = dms.string(dms["npc"],npc_tables[1],npc.npc_name)
            local reward_id = dms.int(dms["npc"],npc_tables[1],npc.drop_library)
            local reward_items = dms.string(dms["scene_reward"],reward_id,scene_reward.reward_items)
            reward_items = zstring.split(reward_items,"|")
            local reward_table = {}
            for j,v in pairs(reward_items) do
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
                npcids = npc_tables,
                reward_data = reward_table,
                scene_id = i
            }
            table.insert(self.gem_duplicate,data)
            index = index + 1
        end
    end

    self.npc_state = {}
    for i,info in pairs(self.gem_duplicate) do
        self.npc_state[i] = {}
        for j,npc_id in pairs(info.npcids) do
            local state = tonumber(_ED.npc_state[tonumber(npc_id)])  -- -1 没开启 0 开启了 >0 过关
            self.npc_state[i][j] = {}
            if state >= 0 then
                self.npc_state[i].open_level = j --打开到了第几难度
            end
            self.npc_state[i][j] = {}
            self.npc_state[i][j].state = state --单个难度的npc状态
            self.npc_state[i][j].npc_id = npc_id --单个难度的npcid
        end
        if self.npc_state[i].open_level == nil then
            self.npc_state[i].open_level = 1
        end
    end
    
    -- debug.print_r(self.gem_duplicate)
    -- debug.print_r(self.npc_state)
end

function GemDuplicate:init()
    self:initData()
	self:onInit()
    return self
end

function GemDuplicate:onExit()
    state_machine.remove("gem_duplicate_check_open_tow")
    state_machine.remove("gem_duplicate_update_draw")
end
