-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险副本战斗请求对话框
-------------------------------------------------------------------------------------------------------
AdventureDuplicateBattleDlg = class("AdventureDuplicateBattleDlgClass", Window)
AdventureDuplicateBattleDlg.__mine_boss_name = ""
    
function AdventureDuplicateBattleDlg:ctor()
    self.super:ctor()
    self.roots = {}

    self.selectSceneId = -1
    self.selectNpcId = -1
    self.sceneDifficultyIndex = -1

    self.interval = 0
	
	self.enum_type = {
		_MINE_BATTLE = 2,		--矿山战斗
		
	}
	self.battleType = 0
	self.mineData = nil
    self.battleNpcName = nil

    fwin:close(fwin:find("AdventureDuplicateBattleDlgClass"))

    app.load("client.adventure.cells.duplicate.adventure_duplicate_npc_bubble_cell")
    
    -- Initialize adventure duplicate battle dlg state machine.
    local function init_adventure_duplicate_battle_dlg_terminal()
        -- 请求战斗
        local adventure_duplicate_battle_dlg_request_terminal = {
            _name = "adventure_duplicate_battle_dlg_request",
            _init = function (terminal)
                app.load("client.adventure.battle.AdventureBattle")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseBattleInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        AdventureDuplicateBattleDlg.__mine_boss_name = ""
                        if instance.enum_type._MINE_BATTLE == instance.battleType then
                            --矿区战斗胜利后需要刷新
                            if tonumber(_ED.attackData.isWin) == 1 then
                                local resource_type = dms.int(dms["mine_grid"], instance.mineData.tileType, mine_grid.resource_type)
                                if resource_type == 3 then  
                                    AdventureDuplicateBattleDlg.__mine_boss_name = instance.battleNpcName   
                                end
                                if resource_type == 3 or resource_type == 2 then  
                                    --刷新BOSS杂兵数据
                                    state_machine.excute("adventure_mine_battle_victory_update",0 ,{x = tonumber(instance.mineData.tileX),y =tonumber(instance.mineData.tileY)})
                                end
                            
                                instance.mineData.tileType = "0" 
                                instance.mineData.__tile._tileType = "0"
                                instance.mineData.__tile._focus = nil
                                instance.mineData.__tile._exploit = false
                                _ED.adventure_mine.current_mine.x = 0
                                _ED.adventure_mine.current_mine.y = 0
                                _ED.adventure_mine.current_mine.mining_cd = 0
                                instance.mineData:unload()
                                instance.mineData:reload()
                                instance.mineData:updateDraw()
                                
                               -- state_machine.excute("adventure_mine_tile_cell_battle_update",0,{cell = instance.mineData})
                                state_machine.excute("adventure_mine_reset_add_draw", 0, "adventure_mine_reset_add_draw.")
                            else
                                AdventureDuplicateBattleDlg.__mine_boss_name = ""
                            end
                        end
                        cacher.removeAllTextures()
                        
                        fwin:removeAll()
                        cc.Director:getInstance():purgeCachedData()
                        fwin:open(AdventureBattle:new():init(), fwin._background)

                    end
                end
				
				if self.enum_type._MINE_BATTLE == self.battleType then
					_ED._battle_map_type = 2
					protocol_command.mine_fight_launch.param_list = ""..self.mineData.tileX.."\r\n"..self.mineData.tileY
					NetworkManager:register(protocol_command.mine_fight_launch.code, nil, nil, nil, nil, responseBattleInitCallback, true, nil)
				else
					-- text var
					_ED._current_scene_id = instance.selectSceneId
					_ED._scene_npc_id = instance.selectNpcId
					_ED._npc_difficulty_index = instance.sceneDifficultyIndex
					_ED._battle_map_type = 0
					protocol_command.battle_field_init.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
					NetworkManager:register(protocol_command.battle_field_init.code, nil, nil, nil, nil, responseBattleInitCallback, true, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_duplicate_battle_dlg_request_terminal)
        state_machine.init()
    end
    
    -- call func init adventure duplicate battle dlg state machine.
    init_adventure_duplicate_battle_dlg_terminal()
end

function AdventureDuplicateBattleDlg:init(sceneId, selectNpcId, sceneDifficultyIndex, battleType, mineData)
    self.selectSceneId = sceneId
    self.selectNpcId = zstring.tonumber(selectNpcId)
    self.sceneDifficultyIndex = sceneDifficultyIndex
	if battleType~= nil then
		self.battleType = zstring.tonumber(battleType)
	end
	if mineData ~= nil then
		self.mineData = mineData
	end
	return self
end

function AdventureDuplicateBattleDlg:updateScenekCd()
    local root = self.roots[1]
    local interval = self.interval
    if interval <= 0 then
        ccui.Helper:seekWidgetByName(root, "Text_time"):setString("00:00:00")
    else
        self.interval = math.max(0, self.interval)

        local timeTabel = formatTime(self.interval)
        local str = timeTabel.hour
        str = str .. string.format(":%02d", timeTabel.minute)
        str = str .. string.format(":%02d", timeTabel.second)

        ccui.Helper:seekWidgetByName(root, "Text_time"):setString(str)
    end
end

function AdventureDuplicateBattleDlg:onUpdate(dt)
    if self.interval > 0 then
        local interval = (_ED.less_reset_time_os_time + _ED.npc_attack_reset_time) - os.time()
        if interval ~= self.interval then
            self.interval = interval
            self:updateScenekCd()
        end
    end
end

function AdventureDuplicateBattleDlg:onEnterTransitionFinish()
	local csbAdventureDuplicateBattleDlg = csb.createNode("duplicate/battle_shijian.csb")
    local root = csbAdventureDuplicateBattleDlg:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureDuplicateBattleDlg)

    -- 绘制NPC剧情对话
    local plot_dialogue_info = dms.string(dms["on_hook_reward"], self.selectNpcId, on_hook_reward.plot_dialogue)
    local plot_dialogue_cell_info = zstring.split(plot_dialogue_info, "|")
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
    listView:removeAllItems()
    for i, v in pairs(plot_dialogue_cell_info) do
        local cell_msg = zstring.split(v, "-")
        local cell = AdventureDuplicateNpcBubbleCell:createCell()
        cell:init(zstring.tonumber(cell_msg[1]), cell_msg[2])
        listView:addChild(cell)
    end
    listView:requestRefreshView()
    
    -- 绘制主角的头像
--    ccui.Helper:seekWidgetByName(root, "Panel_role_1"):setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", )
    -- 绘制NPC的头像
    -- local headPic = dms.int(dms["npc"], self.selectNpcId, npc.head_pic)
    local headPic = dms.int(dms["npc"], self.selectNpcId, npc.base_pic)
    self.battleNpcName = dms.string(dms["npc"], self.selectNpcId, npc.npc_name)
    -- ccui.Helper:seekWidgetByName(root, "Panel_role_2"):setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", headPic - 1000))
    --ccui.Helper:seekWidgetByName(root, "Panel_role_2"):setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", headPic))
    local Panel_role_1 = ccui.Helper:seekWidgetByName(root, "Panel_role_1")
    local Panel_role_2 = ccui.Helper:seekWidgetByName(root, "Panel_role_2")
    local armature1 = AdventureSpriteRole:create(500 + zstring.tonumber(_ED.user_info.user_head))
    local armature2 = AdventureSpriteRole:create(headPic)
    armature1:setPosition(cc.p(Panel_role_1:getContentSize().width/2,-Panel_role_1:getContentSize().height/2))
    armature2:setPosition(cc.p(Panel_role_2:getContentSize().width/2,-Panel_role_2:getContentSize().height/2))

    Panel_role_1:removeAllChildren(true)
    Panel_role_2:removeAllChildren(true)
    Panel_role_1:addChild(armature1)
    Panel_role_2:addChild(armature2)


    -- 绘制金币信息
    local battleFailCount = zstring.tonumber(_ED.all_npc_attack_lose_count[self.selectNpcId])
    local needSilverInit = dms.int(dms["on_hook_reward"], self.selectNpcId, on_hook_reward.need_silver_init) or 0
    local needSilver =  (needSilverInit * math.pow(2, battleFailCount))
    ccui.Helper:seekWidgetByName(root, "Text_jinbi"):setString("" .. needSilver .. "/" .. getResourceValueToStringForAdventure(_ED.user_info.user_silver))

    -- CD
    -- ccui.Helper:seekWidgetByName(root, "Text_time"):setString("00:00:00")
    self.interval = (_ED.less_reset_time_os_time + _ED.npc_attack_reset_time) - os.time()
    self:updateScenekCd()

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureDuplicateBattleDlgClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_start"),       nil, 
    {
        terminal_name = "adventure_duplicate_battle_dlg_request",         
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureDuplicateBattleDlg:onExit()
    state_machine.remove("adventure_duplicate_battle_dlg_request")
end