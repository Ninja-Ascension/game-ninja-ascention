-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险事件 --boss事件
-------------------------------------------------------------------------------------------------------
AdventureDuplicateEventBossDlg = class("AdventureDuplicateEventBossDlgClass", Window)
AdventureDuplicateEventBossDlg.__fight_type = 0    
function AdventureDuplicateEventBossDlg:ctor()
    self.super:ctor()
    self.roots = {}
    self.mould_date = nil
    self.boss_id = 0
    self.Text_xuezuan = nli
    self.current_type = nil
    self.tileCell = nil
    self._enum_type ={
        _DUPLICATE_EVENT_BOSS = 1, --冒险boss
        _MINE_EVENT_BOSS = 2 --矿区

}

    -- Initialize adventure prop storage state machine.
    local function init_adventure_event_boss_terminal()
        
        local adventure_event_boss_close_terminal = {
            _name = "adventure_event_boss_close",

            _init = function (terminal)
    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            
                if instance.current_type == instance._enum_type._DUPLICATE_EVENT_BOSS then 
                    local function responseOnceCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                          
                        end
                    end
                    
                    NetworkManager:register(protocol_command.random_event_close.code, nil, nil, nil, self, responseOnceCallback, false, nil)
                end
                fwin:close(fwin:find("AdventureDuplicateEventBossDlgClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
        
        --普通攻击
        local adventure_event_boss_attack_normal_terminal = {
            _name = "adventure_event_boss_attack_normal",

            _init = function (terminal)
                app.load("client.adventure.battle.AdventureBattle")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.current_type == instance._enum_type._DUPLICATE_EVENT_BOSS then 
                    local function responseOnceCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                           -- instance:onUpdateDraw()
                            _ED.random_event = nil
                            fwin:close(fwin:find("AdventureDuplicateEventBossDlgClass"))
                            fwin:removeAll()
                            cc.Director:getInstance():purgeCachedData()
                            _ED._battle_map_type = 1
                            fwin:open(AdventureBattle:new():init(), fwin._background)
                        else
                            NetworkManager:register(protocol_command.random_event_close.code, nil, nil, nil, self, nil, false, nil)
                            fwin:close(fwin:find("AdventureDuplicateEventBossDlgClass"))
                        end

                    end
                    protocol_command.random_event_launch.param_list = "".. 0 .."\r\n"
                    NetworkManager:register(protocol_command.random_event_launch.code, nil, nil, nil, self, responseOnceCallback, false, nil)
                else
                    local function responseOnceCallback2(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            --矿区战斗胜利后需要刷新
                            if tonumber(_ED.attackData.isWin) == 1 then
                                instance.tileCell.tileType = "0" 
                                instance.tileCell.__tile._tileType = "0"
                                instance.tileCell.__tile._focus = nil
                                instance.tileCell.__tile._exploit = false
                                _ED.adventure_mine.current_mine.x = 0
                                _ED.adventure_mine.current_mine.y = 0
                                _ED.adventure_mine.current_mine.mining_cd = 0
                                instance.tileCell:unload()
                                instance.tileCell:reload()
                                instance.tileCell:updateDraw()
                               -- state_machine.excute("adventure_mine_tile_cell_battle_update",0,{cell = instance.mineData})
                                state_machine.excute("adventure_mine_reset_add_draw", 0, "adventure_mine_reset_add_draw.")
                            end
                            fwin:close(fwin:find("AdventureDuplicateEventBossDlgClass"))
                            fwin:removeAll()
                            cc.Director:getInstance():purgeCachedData()
                            _ED._battle_map_type = 1
                            fwin:open(AdventureBattle:new():init(), fwin._background)
                        end
                    end
                    protocol_command.mine_boss_launch.param_list = "".. self.tileCell.tileX .. "\r\n" .. self.tileCell.tileY .. "\r\n" .. 0 .."\r\n"
                    NetworkManager:register(protocol_command.mine_boss_launch.code, nil, nil, nil, self, responseOnceCallback2, false, nil)
                end
            
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
		
		-- 全力一击
        local adventure_event_boss_attack_once_hit_terminal = {
            _name = "adventure_event_boss_attack_once_hit",
            _init = function (terminal)
                
           
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.current_type == instance._enum_type._DUPLICATE_EVENT_BOSS then 
                    local function responseOnceCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            _ED.random_event = nil
                            fwin:close(fwin:find("AdventureDuplicateEventBossDlgClass"))
                            fwin:removeAll()
                            cc.Director:getInstance():purgeCachedData()
                            _ED._battle_map_type = 1
                            fwin:open(AdventureBattle:new():init(), fwin._background)
                        else
                            NetworkManager:register(protocol_command.random_event_close.code, nil, nil, nil, self, nil, false, nil)
                            fwin:close(fwin:find("AdventureDuplicateEventBossDlgClass"))
                        end    
                    end
                    protocol_command.random_event_launch.param_list = "".. 1 .."\r\n"
                    NetworkManager:register(protocol_command.random_event_launch.code, nil, nil, nil, self, responseOnceCallback, false, nil)
                else
                    local function responseOnceCallback2(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                              --矿区战斗胜利后需要刷新
                            if tonumber(_ED.attackData.isWin) == 1 then
                                local resource_type = dms.int(dms["mine_grid"], instance.tileCell.tileType, mine_grid.resource_type)
                                if resource_type == 7 then 
                                    state_machine.excute("adventure_mine_boss_bubble_draw",0 ,{node = instance.tileCell,isOpen = false}) 
                                end
                                instance.tileCell.tileType = "0" 
                                instance.tileCell.__tile._tileType = "0"
                                instance.tileCell.__tile._focus = nil
                                instance.tileCell.__tile._exploit = false
                                _ED.adventure_mine.current_mine.x = 0
                                _ED.adventure_mine.current_mine.y = 0
                                _ED.adventure_mine.current_mine.mining_cd = 0
                                instance.tileCell:unload()
                                instance.tileCell:reload()
                                instance.tileCell:updateDraw()
                               -- state_machine.excute("adventure_mine_tile_cell_battle_update",0,{cell = instance.mineData})
                                state_machine.excute("adventure_mine_reset_add_draw", 0, "adventure_mine_reset_add_draw.")
                            end
                            fwin:close(fwin:find("AdventureDuplicateEventBossDlgClass"))
                            fwin:removeAll()
                            cc.Director:getInstance():purgeCachedData()
                            _ED._battle_map_type = 1
                            fwin:open(AdventureBattle:new():init(), fwin._background)
                        end    
                    end
                    protocol_command.mine_boss_launch.param_list = "".. self.tileCell.tileX .. "\r\n".. self.tileCell.tileY .."\r\n" .. 1 .."\r\n"
                    NetworkManager:register(protocol_command.mine_boss_launch.code, nil, nil, nil, self, responseOnceCallback2, false, nil)
                end
                 
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }


        state_machine.add(adventure_event_boss_attack_normal_terminal)
        state_machine.add(adventure_event_boss_attack_once_hit_terminal)
        state_machine.add(adventure_event_boss_close_terminal)
        state_machine.init()
    end
    
    -- call func init adventure prop storage state machine.
    init_adventure_event_boss_terminal()
end

function AdventureDuplicateEventBossDlg:init(type,cell)
    self.current_type = type
    self.tileCell = cell
    AdventureDuplicateEventBossDlg.__fight_type = type
    return self
end

function AdventureDuplicateEventBossDlg:updateOnInfo()
	local root = self.roots[1]
	
end

function AdventureDuplicateEventBossDlg:onUpdateDraw()
	local root = self.roots[1]
       -- "BOSS来袭",-------------430
    --"游荡的炎魔",-------------431
    if root == nil then 
        return
    end
    local titleText = ccui.Helper:seekWidgetByName(root, "Text_title_1")

    if self.current_type == self._enum_type._DUPLICATE_EVENT_BOSS then 
        if _ED.random_event ~= nil and tonumber( _ED.random_event.event_id) > 0 then 
            self.mould_date = dms.element(dms["spirite_palace_event_library"], tonumber(_ED.random_event.event_id))
            titleText:setString(_string_piece_info[430])
            local  random_event_id = dms.atoi(self.mould_date, spirite_palace_event_library.event_id)   --
            local  random_event_type = dms.atoi(self.mould_date, spirite_palace_event_library.group_type)   -- 5
            self.boss_id = dms.string(dms["spirite_palace_event_param"], tonumber(random_event_id), spirite_palace_event_param.event_param)
            
            local plot_dialogue_info = dms.string(dms["npc"], self.boss_id, npc.on_hook_reward)
            --记录NPC
            _ED._scene_npc_id = self.boss_id
            local name = dms.string(dms["npc"], self.boss_id, npc.npc_name)
            local headPic = dms.int(dms["npc"], self.boss_id, npc.base_pic)
            
            local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_boss")
            Panel_role:removeAllChildren(true) 
            Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", headPic))
            ccui.Helper:seekWidgetByName(root, "Text_boss_name"):setString(name)
            
            local param = dms.string(dms["pirates_config"], 323, pirates_config.param)
            local numberxz = zstring.split(param, ",")[9]
            self.Text_xuezuan:setString("X".. numberxz)

--         local plot_dialogue_info = dms.string(dms["on_hook_reward"], tonumber(self.boss_id), on_hook_reward.plot_dialogue)
--         debug.print_r(plot_dialogue_info)
--         local plot_dialogue_cell_info = zstring.split(plot_dialogue_info, "|")
--         print(plot_dialogue_cell_info[1])
-- --     local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
--     for i, v in pairs(plot_dialogue_cell_info) do
--         local cell_msg = zstring.split(v, "-")
--         local cell = AdventureDuplicateNpcBubbleCell:createCell()
--         cell:init(zstring.tonumber(cell_msg[1]), cell_msg[2])
--         listView:addChild(cell)
--     end
        end      
    else
        --矿区
        titleText:setString(_string_piece_info[431])
        local npc_array =zstring.split(_ED.mine_random_npc_infos ,"|")
        self.min_npc_datas = {}
        -- if npc_array ~=nil and #npc_array > 0 then 
        --     for k,v in pairs(npc_array) do
        --         local oneCell = zstring.split(v,",")
        --         local onData = {_type = oneCell[3],_id = oneCell[4],_headPic = oneCell[5]}

        --         self.min_npc_datas["" .. oneCell[1] .. "," .. oneCell[2]] = onData
        --     end
        -- end

        self.cell_data = nil
        self.cell_data = _ED.mine_random_boss_cells["" .. self.tileCell.tileX .. "," .. self.tileCell.tileY]
        if self.cell_data == nil then 
            
            return
        end
        
        if tonumber(self.cell_data._headPic) == 0  then 
        
        end
        local mould_date = 1
        local npcData = dms.element(dms["npc"], self.cell_data._id)
        local name = dms.atos(npcData, npc.npc_name)
        local headPic = dms.atoi(npcData, npc.base_pic)
        if npcData == nil then 
            
        end
        local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_boss")
        Panel_role:removeAllChildren(true) 
        Panel_role:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", headPic))
        ccui.Helper:seekWidgetByName(root, "Text_boss_name"):setString(name)
        local param = dms.string(dms["pirates_config"], 326, pirates_config.param)
        local numberxz = zstring.split(param, "|")[1]
        self.Text_xuezuan:setString("X".. numberxz)
    end
end

function AdventureDuplicateEventBossDlg:onEnterTransitionFinish()
    local csbEnvetBoss = csb.createNode("duplicate/maoxian_shijian_boss.csb")
    local root = csbEnvetBoss:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbEnvetBoss)
    self.Text_xuezuan = ccui.Helper:seekWidgetByName(root, "Text_xuezhuan")
	self:onUpdateDraw()
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
    
        terminal_name = "adventure_event_boss_close",    
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_attack_putong"),       nil, 
    {
        terminal_name = "adventure_event_boss_attack_normal",    
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
            
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_attack_quanli"),       nil, 
    {
        terminal_name = "adventure_event_boss_attack_once_hit",    
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureDuplicateEventBossDlg:onExit()
    state_machine.remove("adventure_event_boss_attack_normal")
    state_machine.remove("adventure_event_boss_attack_once_hit")
    state_machine.remove("adventure_event_boss_close")

end
