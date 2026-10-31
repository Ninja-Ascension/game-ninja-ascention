-- ----------------------------------------------------------------------------------------------------
-- 说明：文件岛布阵界面
-------------------------------------------------------------------------------------------------------

FileIslandFormation = class("FileIslandFormationClass", Window)

local fileIsland_formation_open_terminal = {
    _name = "fileIsland_formation_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	state_machine.excute("fileIsland_formation_close")
		local FileIslandFormationWindow = fwin:find("FileIslandFormationClass")
    	if FileIslandFormationWindow == nil then
    		fwin:open(FileIslandFormation:new():init(params), fwin._view)
    	end

    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭
local fileIsland_formation_close_terminal = {
    _name = "fileIsland_formation_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	if nil ~= _ED.user_formetion_status_copy then
            _ED.user_formetion_status = _ED.user_formetion_status_copy
            _ED.user_formetion_status_copy = nil
        end
        if nil ~= _ED.formetion_copy then
            _ED.formetion = _ED.formetion_copy
            _ED.formetion_copy = nil
        end
		fwin:close(fwin:find("FileIslandFormationClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fileIsland_formation_open_terminal)
state_machine.add(fileIsland_formation_close_terminal)
state_machine.init()

function FileIslandFormation:ctor()
    self.super:ctor()
	self.roots = {}

	app.load("client.l_digital.cells.campaign.fileIsland.fileIsland_formation_cell")

	local function init_fileIsland_formation_terminal()
		

        -- 打开数码兽管理界面
        local fileIsland_formation_open_join_formation_window_terminal = {
            _name = "fileIsland_formation_open_join_formation_window",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("hero_formation_choice_wear_window_open", 0, {params._datas.cell_index, 1, -1, nil, "fileIsland_formation_join_formation", params._datas.cell_index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 加入阵营
        local fileIsland_formation_formation_terminal = {
            _name = "fileIsland_formation_join_formation",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:joinFormtion(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 一键上阵
        local fileIsland_formation_oneKey_terminal = {
            _name = "fileIsland_formation_oneKey",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:oneKey(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 开始战斗
        local fileIsland_formation_start_battle_terminal = {
            _name = "fileIsland_formation_start_battle",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:startBattle(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fileIsland_formation_change_request_terminal = {
            _name = "fileIsland_formation_change_request",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:formationChange(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fileIsland_formation_change_back_terminal = {
            _name = "fileIsland_formation_change_back",
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

        -- 阵型变更
        local fileIsland_formation_change_terminal = {
            _name = "fileIsland_formation_change",
            _init = function (terminal)
                app.load("client.formation.FormationChange") 
                app.load("client.home.HomeHero") 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.info.isChallenged == 1 then
                    TipDlg.drawTextDailog(tipStringInfo_file_island_tips[11])
                    return
                end

                local max = dms.string(dms["play_config"], 100, play_config.param)
                if instance.info.uid ~= tonumber(_ED.user_info.user_id) and instance.attackFriendBossCount == tonumber(max) then
                    TipDlg.drawTextDailog(tipStringInfo_file_island_tips[12])
                    return
                end

                for i,v in pairs(_ED.user_formetion_status) do
                    if tonumber(v) > 0 then
                        app.load("client.formation.FormationChange")
                        state_machine.excute("formation_change_window_open", 0, {"fileIsland_formation_start_battle", "fileIsland_formation_change_request", "fileIsland_formation_change_back"})
                        return
                    end
                end
                TipDlg.drawTextDailog(_new_interface_text[143])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fileIsland_formation_open_join_formation_window_terminal)
        state_machine.add(fileIsland_formation_formation_terminal)
        state_machine.add(fileIsland_formation_oneKey_terminal)
        state_machine.add(fileIsland_formation_start_battle_terminal)
        state_machine.add(fileIsland_formation_change_terminal)
        state_machine.add(fileIsland_formation_change_request_terminal)
        state_machine.add(fileIsland_formation_change_back_terminal)

		state_machine.init()
	end

	init_fileIsland_formation_terminal()
end

function FileIslandFormation:formationChange(params)
    for i = 1, 6 do
        if tonumber(_ED.user_formetion_status[i]) ~= tonumber(_ED.formetion[i+1]) then
            _ED.user_formetion_status[i] = _ED.formetion[i+1]
        end
    end
    cc.UserDefault:getInstance():setStringForKey(getKey(self.fileIsland_copy_formation_status_info_key), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey(self.fileIsland_copy_formation_info_key), zstring.concat(_ED.formetion, ","))
end

function FileIslandFormation:oneKey()
	local nMaxCount = 6

    local function fightingCapacity(a, b)
        local al = tonumber(a.hero_fight)
        local bl = tonumber(b.hero_fight)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end

    local fightShipList = {}

    for i, ship in pairs(_ED.user_ship) do
        if ship.ship_id ~= nil then
            table.insert(fightShipList, ship) 
        end
    end

    table.sort(fightShipList, fightingCapacity)

    local function courageCapacity(a, b)
        local al = tonumber(a.ship_courage)
        local bl = tonumber(b.ship_courage)
        local result = false
        if al < bl then
            result = true
        end
        return result 
    end
    
    local courageShipList = {}
    for i = 1, 6 do
        table.insert(courageShipList, fightShipList[i]) 
    end
    table.sort(courageShipList, courageCapacity)
    fightShipList = courageShipList

    local str = ""
    for i = 1, 6 do
        _ED.formetion[i + 1] = 0
        _ED.user_formetion_status[i] = 0
        if i <= nMaxCount then
            local ship = fightShipList[i]
            local shipId = zstring.tonumber(_ED.formetion[i + 1])

            if nil ~= ship then
                _ED.formetion[i + 1] = ship.ship_id
                _ED.user_formetion_status[i] = ship.ship_id
            end
        end
    end

    cc.UserDefault:getInstance():setStringForKey(getKey(self.fileIsland_copy_formation_status_info_key), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey(self.fileIsland_copy_formation_info_key), zstring.concat(_ED.formetion, ","))

    self:updateHeroList()

end

function FileIslandFormation:startBattle()
	-- cc.UserDefault:getInstance():setStringForKey(getKey(self.fileIsland_copy_formation_status_info_key), zstring.concat(_ED.user_formetion_status, ","))
 --    cc.UserDefault:getInstance():setStringForKey(getKey(self.fileIsland_copy_formation_info_key), zstring.concat(_ED.formetion, ","))

    if self.infoType == 1 then
        -- 缓存，挑战boss胜利后发消息
        local temp = {}
        temp.finderUid = self.info.uid 
        temp.taskId = self.info.taskId
        _ED.fileIsland.file_island_boss_challenge = temp

    else
        -- 缓存，单人挑战胜利后发消息
        local temp = {}
        temp.resultIndex = self.info.index 
        _ED.fileIsland.fileIslandSingleChallenge = temp

    end

    state_machine.lock("fileIsland_formation_start_battle")
    -- 战斗请求
    local function responseBattleInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

            cacher.removeAllTextures()
            
            fwin:cleanView(fwin._windows)
            cc.Director:getInstance():purgeCachedData()
            
            -- 记录上次战斗是否选择的最后的NPC
            LDuplicateWindow._infoDatas._isLastNpc = false
            LDuplicateWindow._infoDatas._isNewNPCAction = false
            
            local bse = BattleStartEffect:new()
            bse:init(self.currentSceneType)
            fwin:open(bse, fwin._windows)
        end
    end

    local function responseBattleStartCallback( response )
        state_machine.unlock("fileIsland_formation_start_battle")
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            app.load("client.battle.report.BattleReport")
            app.load("client.battle.BattleStartEffect")

            _ED.user_info.last_user_grade = _ED.user_info.user_grade
            _ED.user_info.last_user_experience = _ED.user_info.user_experience
            _ED.user_info.last_user_grade_need_experience = _ED.user_info.user_grade_need_experience
            
            local resultBuffer = {}
            if _ED._fightModule == nil then
                _ED._fightModule = FightModule:new()
            end
            _ED.attackData = {
                roundCount = _ED._fightModule.totalRound,
                roundData ={}
            }
            if _ED._scene_npc_id == nil or _ED._scene_npc_id == "" or tonumber(_ED._scene_npc_id) == 0 then
                _ED._scene_npc_id = _ED._scene_npc_copy_net_id
            end
            local fightType = 0
            if self.currentSceneType ~= nil then
                fightType = self.currentSceneType
            end
            if fightType == 1 then
                fightType = _enum_fight_type._fight_type_108
            end

            _ED._fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, fightType, resultBuffer)
            local orderList = {}
            _ED._fightModule:initFightOrder(_ED.user_info, orderList)
            
            responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
        end
    end

    _ED._current_scene_id = self.sceneId
    _ED._scene_npc_id = self.npcId
    _ED._npc_difficulty_index = 1

    responseBattleStartCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})

end

function FileIslandFormation:joinFormtion(params)
    state_machine.excute("hero_formation_choice_wear_window_close", 0, 0)

    local nMaxCount = 6

    local cell_index = params[1]
    local ship_id = params[2]

    local ship = _ED.user_ship["" .. ship_id]

    for i, v in pairs(_ED.user_formetion_status) do
        if zstring.tonumber(v) <= 0 and i <= nMaxCount then
            cell_index = i
            break
        end
    end

    local old_ship_id = zstring.tonumber(_ED.user_formetion_status[cell_index])
    _ED.user_formetion_status[cell_index] = ship_id
    for i = 1, 6 do
        local shipId = zstring.tonumber(_ED.formetion[i + 1])
        if i <= nMaxCount then
            if shipId > 0 then
                if old_ship_id == shipId then
                    _ED.formetion[i + 1] = ship_id
                    break
                end
            else
                _ED.formetion[i + 1] = ship_id
                break
            end
        end
    end
    
    cc.UserDefault:getInstance():setStringForKey(getKey(self.fileIsland_copy_formation_status_info_key), zstring.concat(_ED.user_formetion_status, ","))
    cc.UserDefault:getInstance():setStringForKey(getKey(self.fileIsland_copy_formation_info_key), zstring.concat(_ED.formetion, ","))

    self:updateHeroList()
end

function FileIslandFormation:onUpdateDraw()
	local root = self.roots[1]

    self:updateFriendList()

	self:updateHeroList()


    -- 名称
    local npcData = dms.element(dms["npc"], self.info.npcId)
    local nickId = dms.atos(npcData, npc.npc_name)
    self.nick = dms.element(dms["word_mould"], nickId)[3]
    self.Text_boss_name:setString(self.nick)

    -- 描述
    local desId = dms.atos(npcData, npc.sign_msg)
    self.desc = dms.element(dms["word_mould"], desId)[3]
    self.Text_npc_story:setString(self.desc)

    -- 头像
    local picId = dms.atos(npcData, npc.head_pic)
    pidId = zstring.split(picId, ",")[2]
    self.head = string.format("images/face/big_head/big_head_%d.png", pidId)
    self.Panel_npc:setBackGroundImage(self.head)

    -- 剩余次数
    if self.infoType == 1 then
        local max = dms.string(dms["play_config"], 99, play_config.param)
        self.lastCount = tonumber(max) - #self.info.rewardFriends
        self.Text_explore_friend_times_n:setString(self.lastCount .. "/" .. max)
    end
    
    -- 奖励
    local rewardID = dms.atos(npcData, npc.drop_library)
    local rewardInfoString = dms.string(dms["scene_reward_ex"], rewardID, scene_reward_ex.show_reward)

    local rewards = zstring.split(rewardInfoString, "|")

    -- 显示掉落
    for i = 1, #rewards do
        local reward = zstring.split(rewards[i], ",")
        local node = ccui.Helper:seekWidgetByName(root, "Panel_30_" .. i)
        node:setVisible(true)
        local icon = ResourcesIconCell:createCell()
        icon:init(tonumber(reward[2]), tonumber(reward[3]), tonumber(reward[1]), nil, nil, true, true, 1)
        node:addChild(icon)
    end

end

-- 刷新挑战好友信息列表
function FileIslandFormation:updateFriendList()
    if self.infoType == 1 then
        self.Panel_infor:setVisible(true)
        -- 列表
        self.ListView_boss_infor:stopAllActions()
        self.ListView_boss_infor:removeAllItems()
        self.ListView_boss_infor:jumpToTop()

        for i = 1, #self.info.joinFriends do
            local cellData = self.info.joinFriends[i]
            local cell = FileIslandFormationCell:createCell()
            cell:init(cellData, i)
            self.ListView_boss_infor:addChild(cell)
        end

        self.ListView_boss_infor:requestRefreshView()
        
        self.list_view_posY = self.ListView_boss_infor:getInnerContainer():getPositionY()

    else
        self.Panel_infor:setVisible(false)
    end

end

-- 刷新上阵列表
function FileIslandFormation:updateHeroList()
	self.ListView_npc:removeAllItems()
	
	for i = 1, 6 do
        local cell = HeroIconListCell:createCell()
        local ship = _ED.user_ship["".._ED.user_formetion_status[i]]
        if ship then
            cell:init(ship, i, true, nil, nil, true)
            local Image_line_role = ccui.Helper:seekWidgetByName(cell.roots[1], "Image_line_role")
            if Image_line_role then
                Image_line_role:setVisible(false)
            end

            if cell:getChildByTag(1024) then 
                cell:removeChildByTag(1024)
            end
        else
            cell:init(nil, i, true, nil, nil, true)
        end

        if i <= 6 then
            -- 上阵
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"), nil, 
            {
                terminal_name = "fileIsland_formation_open_join_formation_window",
                cell_index = i,
                isPressedActionEnabled = true
            },
            nil, 0)
        end
        ccui.Helper:seekWidgetByName(cell.roots[1], "Text_equip_lv"):setString("")
        self.ListView_npc:addChild(cell) 
    end
end

function FileIslandFormation:onUpdate(dt)
    if self.infoType == 1 and self.ListView_boss_infor ~= nil then
	    local size = self.ListView_boss_infor:getContentSize()
	    local posY = self.ListView_boss_infor:getInnerContainer():getPositionY()
	    if self.list_view_posY == posY then
	        return
	    end

	    self.list_view_posY = posY
	    local items = self.ListView_boss_infor:getItems()

	    if items[1] == nil then
	        return
	    end

	    local itemSize = items[1]:getContentSize()

	    for i, v in pairs(items) do
	        local tempY = v:getPositionY() + posY
	        if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
	            v:unload()
	        else
	            v:reload()
	        end
	    end
	end
end

function FileIslandFormation:onInit()
	local csb_explore_friend_task = csb.createNode("campaign/explore/explore_boss_formation.csb")
	local root = csb_explore_friend_task:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csb_explore_friend_task)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103"), nil, 
	{
		terminal_name = "fileIsland_formation_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 0)

    -- 一键上阵
    local Button_huodong_guaka_line = ccui.Helper:seekWidgetByName(root, "Button_huodong_guaka_line")
    fwin:addTouchEventListener(Button_huodong_guaka_line, nil, 
	{
		terminal_name = "fileIsland_formation_oneKey", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 0)

    -- 开始战斗
    local Button_huodong_guaka_zd = ccui.Helper:seekWidgetByName(root, "Button_huodong_guaka_zd")
	fwin:addTouchEventListener(Button_huodong_guaka_zd, nil, 
	{
		terminal_name = "fileIsland_formation_change", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 0)

	-- 上阵列表
	self.ListView_npc = ccui.Helper:seekWidgetByName(root, "ListView_huodong_guaka_line")
	-- 当前挑战信息列表
	self.ListView_boss_infor = ccui.Helper:seekWidgetByName(root, "ListView_explore_friend_infor")
	-- npc介绍
	self.Text_npc_story = ccui.Helper:seekWidgetByName(root, "Text_npc_story")
	-- 掉落节点列表
	self.dropNodeTable = {}
	for i = 1, 5 do
		local node = ccui.Helper:seekWidgetByName(root, "Panel_30_" .. i)
		table.insert(self.dropNodeTable, node)
	end

    -- 挑战好友信息
    self.Panel_infor = ccui.Helper:seekWidgetByName(root, "Panel_infor")
    self.Panel_infor:setVisible(false)

	-- boss名称
	self.Text_boss_name = ccui.Helper:seekWidgetByName(root, "Text_boss_name")
	-- 好友剩余挑战次数
	self.Text_explore_friend_times_n = ccui.Helper:seekWidgetByName(root, "Text_explore_friend_times_n")
    local Text_explore_friend_times_t = ccui.Helper:seekWidgetByName(root, "Text_explore_friend_times_t")
    if self.infoType == 1 then
        self.Text_explore_friend_times_n:setVisible(true)
        Text_explore_friend_times_t:setVisible(true)
    else
        self.Text_explore_friend_times_n:setVisible(false)
        Text_explore_friend_times_t:setVisible(false)
    end
	-- npc头像
	self.Panel_npc = ccui.Helper:seekWidgetByName(root, "Panel_npc")

	self:onUpdateDraw()

    -- 顶部用户信息
	app.load("client.l_digital.campaign.fileIsland.FileIslandShopBuyTop") 					
	local userinfo = FileIslandShopBuyTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

	self:registerOnNodeEvent(self)
	self:registerOnNoteUpdate(self, 1)
end

function FileIslandFormation:init(params)

    self.info = params.info
    -- 1表示boss 2个人挑战
    self.infoType = params.infoType

    self.attackFriendBossCount = params.attackFriendBossCount

    -- 任务发现者的配置
    self.my_table = {}
    self.my_table.npcId = dms.atos(configdata, file_island_friend_task.npcId)

    if self.infoType == 1 then
        self.npcId = self.info.npcId
        local pveSceneData = dms.element(dms["pve_scene"], self.info.configId)
        self.sceneId = dms.atos(pveSceneData, pve_scene.scene_id)
        self.currentSceneType = dms.atoi(pveSceneData, pve_scene.scene_type)

    elseif self.infoType == 2 then
        self.npcId = self.info.npcId
        local pveSceneData = dms.element(dms["pve_scene"], self.info.sceneId)
        self.sceneId = dms.atos(pveSceneData, pve_scene.scene_id)
        self.currentSceneType = dms.atoi(pveSceneData, pve_scene.scene_type)
    end

	_ED.user_formetion_status_copy = {}
    _ED.formetion_copy = {}
    table.merge(_ED.user_formetion_status_copy, _ED.user_formetion_status)
    table.merge(_ED.formetion_copy, _ED.formetion)

    self.fileIsland_copy_formation_status_info_key = "fileIsland_copy_formation_status_info_key"
    self.fileIsland_copy_formation_info_key = "fileIsland_copy_formation_info_key"

    local fileIsland_copy_formation_status_info = cc.UserDefault:getInstance():getStringForKey(getKey(self.fileIsland_copy_formation_status_info_key), "")
    local fileIsland_copy_formation_info = cc.UserDefault:getInstance():getStringForKey(getKey(self.fileIsland_copy_formation_info_key), "")

    if nil == fileIsland_copy_formation_status_info or "" == fileIsland_copy_formation_status_info or nil == fileIsland_copy_formation_info or "" == fileIsland_copy_formation_info then
        cc.UserDefault:getInstance():setStringForKey(getKey(self.fileIsland_copy_formation_status_info_key), zstring.concat(_ED.user_formetion_status, ","))
        cc.UserDefault:getInstance():setStringForKey(getKey(self.fileIsland_copy_formation_info_key), zstring.concat(_ED.formetion, ","))
    else
        _ED.user_formetion_status = zstring.split(fileIsland_copy_formation_status_info, ",")
        _ED.formetion = zstring.split(fileIsland_copy_formation_info, ",")
    end

	self:onInit()
	return self
end

function FileIslandFormation:onExit()
	state_machine.remove("fileIsland_formation_open_join_formation_window")
	state_machine.remove("fileIsland_formation_join_formation")
	state_machine.remove("fileIsland_formation_oneKey")
	state_machine.remove("fileIsland_formation_start_battle")
    state_machine.remove("fileIsland_formation_change")
    state_machine.remove("fileIsland_formation_change_request")
    state_machine.remove("fileIsland_formation_change_back")

end

