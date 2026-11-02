-- ----------------------------------------------------------------------------------------------------
-- 说明：探索地图主界面
-------------------------------------------------------------------------------------------------------
ExplorationMap = class("ExplorationMapClass", Window)

local exploration_map_open_terminal = {
    _name = "exploration_map_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ExplorationMapClass") == nil then
            fwin:open(ExplorationMap:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_map_open_terminal)
state_machine.init()

function ExplorationMap:ctor()
    self.super:ctor()
    self.roots = {}
    self.is_move = false -- 人物行走中，不能点击其他地方
    _ED.player_move = false -- 人物行走中，不能点击其他地方
    self.lastPlayerPos = cc.p(0, 0) -- 人物位置初始化
    self.lastMapPos = cc.p(0, 0)-- 地图位置初始化
    self.lastTilePos = {2, 15} -- 地块位置初始化
    self.beginTilePos = {}
    for i=1, #dms["role_explore_map"] do
        table.insert(self.beginTilePos, {2, 15})
    end

    --控制事件界面还没出来又再次请求数据
    _ED.event_window_open = true

    local posStr = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_end_point"), "")
    if posStr and posStr ~= "" then
        local str = zstring.split(posStr, ",")
        self.lastTilePos = {tonumber(str[1]), tonumber(str[2])}
    end

    self.lastDirection = -1 -- 人物朝向初始化

    self.walkMap = {2840, 1480}  -- 地图大小

    self.maxTileNum = 19 -- 地图瓦块最大坐标 0- 49 

    self.mapId = 1 -- 初始化地图id
    local mapId = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_id"), "")
    if mapId and mapId ~= "" then
        self.mapId = tonumber(mapId)
    end
    self.direction = {
        FRONT_STAND_LEFT = 0,   -- 正面朝左待机
        FRONT_MOVE_LEFT = 1,    -- 正面朝左移动
        FRONT_STAND_RIGHT = 2,  -- 正面朝右待机
        FRONT_MOVE_RIGHT = 3,   -- 正面朝右移动
        BACK_STAND_RIGHT = 4,   -- 背面朝右待机
        BACK_MOVE_RIGHT = 5,    -- 背面朝右移动
        BACK_STAND_LEFT = 6,    -- 背面朝左待机
        BACK_MOVE_LEFT = 7      -- 背面朝左移动
    }

    app.load("client.l_digital.campaign.exploration.ExplorationWindow")
    app.load("client.l_digital.campaign.exploration.ExplorationOneFinish")
    
    local function init_exploration_map_terminal()
        -- 关闭
		local exploration_map_close_terminal = {
            _name = "exploration_map_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.unlock("explore_window_open_fun_window")

                if fwin:find("HomeClass") == nil then
                    state_machine.excute("menu_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "menu_manager",
                                next_terminal_name = "menu_show_home_page", 
                                current_button_name = "Button_home",
                                but_image = "Image_home",       
                                terminal_state = 0, 
                                _needOpenHomeHero = true,
                                isPressedActionEnabled = true
                            }
                        }
                    )
                    state_machine.excute("menu_back_home_page", 0, "")
                    state_machine.excute("home_change_open_atrribute", 0, false)
                end
                
                fwin:close(fwin:find("ExplorationMapClass"))
                fwin:close(fwin:find("FileIslandShopBuyTopClass"))

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_map_change_terminal = {
            _name = "exploration_map_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.mapId = params
                instance:drawMap()
                local canFreeMap = dms.int(dms["play_config"], 152, play_config.param)
                if not table.containValue(_ED.pokemonExplore.mapFirstRefresh, instance.mapId) and canFreeMap == tonumber(instance.mapId) then --第一次免费刷新
                    state_machine.excute("exploration_icon_refresh", 0, 10)
                else
                    instance:drawEventIcon()
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_icon_refresh_del_terminal = {
            _name = "exploration_icon_refresh_del",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:drawEventIcon()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local exploration_icon_refresh_terminal = {
            _name = "exploration_icon_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local nums = tonumber(params)
                local function callback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- 刷新探索点和计时
                        state_machine.excute("exploration_window_onUpdateDraw", 0, "")
                        instance:drawEventIcon()
                    end
                end
                local havePos = {}
                local posStr = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_end_point"), "")
                local function randomPos()
                    local posX = 0
                    local posY = 0
                    posX = math.random(0, self.maxTileNum)
                    posY = math.random(0, self.maxTileNum)

                    local bossIconinfo = zstring.splits(dms.string(dms["play_config"], 151, play_config.param), "|", "!")
                    for i, info in ipairs(bossIconinfo) do
                        if tonumber(info[1]) == tonumber(self.mapId) then
                            bossIconPos = info[2]
                        end
                    end

                    while(self.allTitlePos[tonumber(posX)][tonumber(posY)].stop ~= 0 or table.containValue(havePos, posX .. "," ..  posY) or table.containValue(havePos, posStr) or bossIconPos == (posX .. "," ..  posY))
                    do
                        posX = math.random(0, self.maxTileNum)
                        posY = math.random(0, self.maxTileNum)
                    end
                    -- if self.allTitlePos[tonumber(posX)][tonumber(posY)].stop ~= 0 
                    --     or table.containValue(havePos, posX .. "," ..  posY) or table.containValue(havePos, posStr) then
                    --     randomPos()
                    --     print("1111111111111")
                    -- else
                    --     print("222222222222222")
                    --     table.insert(havePos, posX .. "," ..  posY)
                    --     return posX .. "," ..  posY
                    -- end
                    table.insert(havePos, posX .. "," ..  posY)
                    return posX .. "," ..  posY
                end

                local mapId = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_id"), "1")
                local data = {}
                data.mapId = mapId
                data.type = 0
                data.locationInfo = {}
                for i = 1, nums do
                    local pos = randomPos()--i .. ",49"
                    if pos then
                        table.insert(data.locationInfo, pos)
                    end
                end
                local req = json.encode(data)
                protocol_command.pokemon_explore_search.param_list = req
                NetworkManager:register(protocol_command.pokemon_explore_search.code, nil, nil, nil, nil, callback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
                
        state_machine.add(exploration_map_close_terminal)
        state_machine.add(exploration_map_change_terminal)
        state_machine.add(exploration_icon_refresh_terminal)
        state_machine.add(exploration_icon_refresh_del_terminal)
        state_machine.init()
    end
    init_exploration_map_terminal()
end

function ExplorationMap:init(params)
    self:registerOnNoteUpdate(self, 1)
    return self
end

function ExplorationMap:onUpdateDraw()
    local root = self.roots[1]

end

function ExplorationMap:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/exploration/exploration_map.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)
    -- 地图按钮界面
    state_machine.excute("exploration_window_open", 0, "")
end


--绘制事件图标
function ExplorationMap:drawEventIcon()
    local root = self.roots[1]
    local Panel_map = ccui.Helper:seekWidgetByName(root, "Panel_map")
    local haveBoss = false
    -- debug.print_r(_ED.pokemonExplore.resultInfo.resultArray)
    --统计事件数量
    NetworkManager:register(protocol_command.pokemon_explore_boss_info.code, nil, nil, nil, nil, callback, false, nil)  
    state_machine.excute("exploration_map_event_nums", 0, "")
    --清除
    for i=1,10 do
        local anim = self.tmxMap:getChildByName("animationIcon" .. i)
        if anim then
            anim:removeFromParent(true)
        end
    end

    --boss图标
    local animBoss = self.tmxMap:getChildByName("animationBoss")
    if animBoss then
        animBoss:removeFromParent(true)
    end

    local bossIconPos = nil
    local bossIconinfo = zstring.splits(dms.string(dms["play_config"], 151, play_config.param), "|", "!")
    for i, info in ipairs(bossIconinfo) do
        if tonumber(info[1]) == tonumber(self.mapId) then
            bossIconPos = zstring.split(info[2], ",")
        end
    end
    if bossIconPos then
        local tile = self.allTitlePos[tonumber(bossIconPos[1])][tonumber(bossIconPos[2])]
        local jsonFile = "images/ui/effice/effect_tansuoboss/spirte_tansuoboss.json"
        local atlasFile = "images/ui/effice/effect_tansuoboss/spirte_tansuoboss.atlas"
        local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation2.animationNameList = {"animation"}
        sp.initArmature(animation2, false)
        self.tmxMap:addChild(animation2)
        animation2:setPosition(tile.player_pos)
        local zOrder = tile.tile_pos[1] + tile.tile_pos[2]
        self.tmxMap:reorderChild(animation2, zOrder)
        animation2:setName("animationBoss")
        csb.animationChangeToAction(animation2, 0, 0, false)
        tile.iconInfo = {}
        tile.iconInfo.eventId = 3
        tile.iconInfo.location = bossIconPos[1] .. "," .. bossIconPos[2]
    end

    local mapId = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_id"), "1")
    if (_ED.pokemonExplore.lastSearchType and tonumber(_ED.pokemonExplore.lastSearchType) == 1) or tonumber(_ED.pokemonExplore.curSearchMap) ~= tonumber(mapId) then
        return
    end

    for i, event in pairs(_ED.pokemonExplore.resultInfo.resultArray) do
        if tonumber(event.eventId) ~= 3 and tonumber(event.isTouch) ~= 1 and event.location then
            local pos = zstring.split(event.location, ",")
            local tile = self.allTitlePos[tonumber(pos[1])][tonumber(pos[2])]
            local iconIndex = dms.int(dms["role_explore_event"], event.eventId, 5)
            local jsonFile = "images/ui/effice/effect_tansuosuiji/effect_tansuosuiji.json"
            local atlasFile = "images/ui/effice/effect_tansuosuiji/effect_tansuosuiji.atlas"
            if iconIndex == 2 then
                jsonFile = "images/ui/effice/effect_tansuobuzhuo/effect_tansuobuzhuo.json"
                atlasFile = "images/ui/effice/effect_tansuobuzhuo/effect_tansuobuzhuo.atlas"
            end

            local animation1 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            animation1.animationNameList = {"animation"}
            sp.initArmature(animation1, false)
            self.tmxMap:addChild(animation1)
            animation1:setPosition(tile.player_pos)
            local zOrder = tile.tile_pos[1] + tile.tile_pos[2]
            self.tmxMap:reorderChild(animation1, zOrder)
            animation1:setName("animationIcon" .. i)
            csb.animationChangeToAction(animation1, 0, 0, false)
            tile.iconInfo = event
            tile.armature = animation1
        end
        -- if tonumber(event.eventId) == 3 then
        --     haveBoss = true
        -- end
    end
end

--绘制地图
function ExplorationMap:drawMap()
    local root = self.roots[1]
    local mapPath = string.format("tmx/map_%d.tmx", self.mapId)
    local mapDiPath = string.format("tmx/image/map_di_%d.jpg", self.mapId)
    local mapNode = csb.createNode(string.format("campaign/exploration/exploration_map_%d.csb", self.mapId))

    local tmxMap = cc.TMXTiledMap:create(mapPath)
    -- local tmxMapd = ccui.ImageView:create(mapDiPath)
    local Panel_map = ccui.Helper:seekWidgetByName(root, "Panel_map")
    Panel_map:removeAllChildren(true)
    local mapId = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_id"), "")
    if tonumber(self.mapId) ~= zstring.tonumber(mapId) then
        self.lastTilePos = self.beginTilePos[self.mapId]
    end

    cc.UserDefault:getInstance():setStringForKey(getKey("exploration_map_id"), "" .. self.mapId)   

    self.Panel_map = Panel_map
    -- tmxMapd:setAnchorPoint(0, 0)
    -- tmxMapd:setTouchEnabled(true)
    local Panel_sp = ccui.Helper:seekWidgetByName(root, "Panel_sp")
    local screen_size = Panel_sp:getContentSize()
    Panel_sp:setTouchEnabled(true)
    mapNode:setPosition(cc.p(-screen_size.width/2, -screen_size.height/2))
    Panel_map:addChild(mapNode)
    Panel_map:addChild(tmxMap)
    self.tmxMap = tmxMap


    -- 获取地块信息
    local groundLayer = self.tmxMap:getLayer("tu1")
    -- local treeLayer = self.tmxMap:getLayer("tu2")
    -- local shu = self.tmxMap:getObjectGroup("shu")
    self.allTiles = {}
    self.allTitlePos = {}
    for i = 0, self.maxTileNum do
        self.allTitlePos[i] = {}
        for j = 0, self.maxTileNum do
            local tile = groundLayer:getTileAt(cc.p(i, j))
            -- local tree = treeLayer:getTileAt(cc.p(i, j))

            -- 人物的位置
            tile.player_pos = cc.p(tile:getPositionX() + tile:getContentSize().width/2, tile:getPositionY() + tile:getContentSize().height/2)
            -- 地块坐标
            tile.tile_pos = {i, j}
            -- if i == 29 and j == 29 then
            --     print(tile:getPositionX(), tile:getPositionY(), tile:getContentSize().height)
            -- end
            -- 是否有遮挡物
            tile.stop = 0
            -- 地块坐标对应的人物坐标
            tile.player_tile = tile.player_pos
            self.allTitlePos[i][j] = tile
            table.insert(self.allTiles, tile)
        end
    end
    Panel_map:setTouchEnabled(true)
    self:drawPlayer()
    self:drawTrees()
    local function touchBack( sender, evenType )
        if self.is_move then
            return
        end
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if evenType == ccui.TouchEventType.ended then
            local bPosition = self.Panel_map:convertToNodeSpace(cc.p(__epoint.x, __epoint.y))
            local tile = self:getTouchTile(bPosition)
            if not tile then
                return
            end

            if _ED.player_move then
                return
            end
            
            local roads = self:getMapRoad(tile)
            if not roads or table.nums(roads) <= 0 then
                return
            end
            self.index = 1
            self:pokemonSearch(roads)
        end
        
    end
    Panel_map:addTouchEventListener(touchBack)
end

-- 随机取一个终点
function ExplorationMap:randomNewEventRoads( roads )
    local max = #roads
    local endPointIndex = math.random(1, max)
    local newRoads = {}
    for i = 1, endPointIndex do
        table.insert(newRoads, roads[i])
    end

    -- 记录终点的位置，退出再进处于同一个位置
    -- local endPointStr = "" .. roads[endPointIndex][1] .. "," .. roads[endPointIndex][2]
    -- cc.UserDefault:getInstance():setStringForKey(getKey("exploration_map_end_point"), endPointStr)
    return newRoads
end

--单次探索请求
function ExplorationMap:pokemonSearch(roads)
    -- local searchPoint = tonumber(_ED.pokemonExplore.searchPoint)
    -- local needPoint = dms.int(dms["play_config"], 124, play_config.param)
    -- -- 有探索点进行请求
    -- if searchPoint >= needPoint then
    --     local function callback( response )
    --         if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    --             if _ED.pokemonExplore.resultInfo.resultArray and table.nums(_ED.pokemonExplore.resultInfo.resultArray) > 0
    --             and tonumber(_ED.pokemonExplore.resultInfo.resultArray[1].eventId) ~= 2 then
    --                 self:playerMove(self:randomNewEventRoads(roads))
    --             else
    --                 --休息事件直接行走
    --                 _ED.event_window_open = true
    --                 self:playerMove(roads)
    --             end
    --         end
    --     end
    --     local data = {}
    --     data.mapId = self.mapId
    --     data.type = 0
    --     local req = json.encode(data)
    --     if _ED.event_window_open then
    --         _ED.event_window_open = false
    --         protocol_command.pokemon_explore_search.param_list = req
    --         NetworkManager:register(protocol_command.pokemon_explore_search.code, nil, nil, nil, nil, callback, false, nil)
    --     end
    -- else
    --     --没有探索点直接行走
    --     self:playerMove(roads)
    -- end
    self:playerMove(roads)
end

--获取路线
function ExplorationMap:getMapRoad( tile )
    local addX = tile.tile_pos[1] >= self.lastTilePos[1] and 1 or -1
    local addY = tile.tile_pos[2] >= self.lastTilePos[2] and 1 or -1
    
    local tileRoads = {}
    local roadsss = self:findRoadA(self.lastTilePos, tile.tile_pos)
    if roadsss then
        for i = #roadsss - 1, 1, -1 do
            local pos = {roadsss[i].row, roadsss[i].col}
            table.insert(tileRoads, pos)
        end
    end

    -- 记录终点的位置，退出再进处于同一个位置
    -- if tileRoads and table.nums(tileRoads) > 0 then
    --     local endPointStr = "" .. tileRoads[#tileRoads][1] .. "," .. tileRoads[#tileRoads][2]
    --     cc.UserDefault:getInstance():setStringForKey(getKey("exploration_map_end_point"), endPointStr)
    -- end
    return tileRoads
end

-- 人物移动
function ExplorationMap:playerMove( roads )
    local road = roads[self.index]

    if not road then
        self.index = 1
        self.is_move = false
        self.lastDirection = -1
        csb.animationChangeToAction(self.player, self.standDirection, self.standDirection, true)
        -- if table.nums(_ED.pokemonExplore.resultInfo.resultArray) > 0 
        --     and _ED.pokemonExplore.resultInfo.resultArray[1].eventId ~= 2 then
        --     state_machine.excute("exploration_one_finish_window_open", 0, "")
        -- end
        -- 记录终点的位置，退出再进处于同一个位置
        local endPointStr = "" .. self.tile.tile_pos[1] .. "," .. self.tile.tile_pos[2]
        cc.UserDefault:getInstance():setStringForKey(getKey("exploration_map_end_point"), endPointStr)
        if self.tile.iconInfo then
            if tonumber(self.tile.iconInfo.eventId) ~= 3 then
                local function callback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        self.tile.armature:removeFromParent(true)
                        state_machine.excute("exploration_one_finish_window_open", 0, self.tile.iconInfo)
                        self.tile.iconInfo = nil
                    end
                end

                protocol_command.pokemon_explore_event_touch.param_list = json.encode({resultIndex = self.tile.iconInfo.index})
                NetworkManager:register(protocol_command.pokemon_explore_event_touch.code, nil, nil, nil, nil, callback, false, nil)
            else
                state_machine.excute("exploration_window_team_boss_open_request_data", 0, "")
                local pos = zstring.split(self.tile.iconInfo.location, ",")
                self:playerMove({{tonumber(pos[1])+1, tonumber(pos[2])}})
                _ED.player_move = false
            end
        else
            _ED.player_move = false
        end
        return
    end
    self.is_move = true
    _ED.player_move = true

    local tile = self.allTitlePos[road[1]][road[2]]
    self.tile = tile
    
    local move_x = tile.player_pos.x - self.lastPlayerPos.x
    local move_y = tile.player_pos.y - self.lastPlayerPos.y

    local standDirection = 0
    local moveDirection = 1
    --判断方向
    if move_x > 0 then     -- 朝向右方
        if move_y > 0 then -- 背面
            standDirection = self.direction.BACK_STAND_RIGHT
            moveDirection = self.direction.BACK_MOVE_RIGHT
        elseif move_y < 0 then-- 正面
            standDirection = self.direction.FRONT_STAND_RIGHT
            moveDirection = self.direction.FRONT_MOVE_RIGHT 
        end
    elseif move_x < 0 then -- 朝向左边
        if move_y > 0 then -- 背面
            standDirection = self.direction.BACK_STAND_LEFT
            moveDirection = self.direction.BACK_MOVE_LEFT
        elseif move_y < 0 then -- 正面
            standDirection = self.direction.FRONT_STAND_LEFT
            moveDirection = self.direction.FRONT_MOVE_LEFT 
        end
    end
    self.standDirection = standDirection
    if self.lastDirection ~= moveDirection then
        csb.animationChangeToAction(self.player, moveDirection, moveDirection, true)
        self.lastDirection = moveDirection
    end

    -- self.Panel_map:stopAllActions()
    -- self.player:stopAllActions()
    local Panel_sp = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sp")
    local screen_pos = cc.p(Panel_sp:getPosition())
    local map_move_pos = cc.p(screen_pos.x - tile.player_pos.x, screen_pos.y-tile.player_pos.y)
    self.Panel_map:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, map_move_pos), 
        cc.CallFunc:create(function () 
            self.lastMapPos = map_move_pos
        end
    )))

    local zOrder = tile.tile_pos[1] + tile.tile_pos[2]
    self.tmxMap:reorderChild(self.player, zOrder)
    self.player:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, tile.player_pos), 
        cc.CallFunc:create(function () 
            self.index = self.index + 1
            self.lastPlayerPos = tile.player_pos
            self.lastTilePos = {tile.tile_pos[1], tile.tile_pos[2]}
            self:playerMove(roads)
        end
    )))
end

-- 人物和地图的初始化
function ExplorationMap:drawPlayer()
    local root = self.roots[1]
    local Panel_map = ccui.Helper:seekWidgetByName(root, "Panel_map")
    local groundLayer = self.tmxMap:getLayer("tu1")
    local jsonFile = "images/ui/effice/spirte_ts.json"
    local atlasFile = "images/ui/effice/spirte_ts.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation9", true, nil)
    animation.animationNameList = {"animation9", "animation2","animation3","animation4","animation5","animation6","animation7","animation8"}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    self.tmxMap:addChild(animation)
    self.player = animation
    csb.animationChangeToAction(animation, 0, 0, true)
    local player_tile = groundLayer:getTileAt(cc.p(self.lastTilePos[1], self.lastTilePos[2]))
    animation:setPosition(cc.p(player_tile:getPositionX() + player_tile:getContentSize().width/2, player_tile:getPositionY() + player_tile:getContentSize().height/2))
    local zOrder = self.lastTilePos[1] + self.lastTilePos[2]
    self.tmxMap:reorderChild(self.player, zOrder)
    local Panel_sp = ccui.Helper:seekWidgetByName(root, "Panel_sp")
    local screen_pos = cc.p(Panel_sp:getPosition())

    -- 记录地图上次的位置
    self.lastMapPos = cc.p(screen_pos.x - player_tile.player_pos.x, screen_pos.y-player_tile.player_pos.y)
    -- 记录人物上次的位置
    self.lastPlayerPos = cc.p(player_tile.player_pos.x, player_tile.player_pos.y)
    --地图的位置
    Panel_map:setPosition(cc.p(screen_pos.x - player_tile.player_pos.x, screen_pos.y-player_tile.player_pos.y))
end


-- 障碍物初始化
function ExplorationMap:drawTrees()
    local allGroups = self.tmxMap:getObjectGroups()
    for k, group in pairs(allGroups) do
        for i, obj in pairs(group:getObjects()) do
            local img = ccui.ImageView:create(obj.path)
            
            local atX = math.floor(obj.x/obj.width) 
            local atY = math.floor(obj.y/obj.height)
            local tile = self.allTitlePos[atX][self.maxTileNum - atY]
            if zstring.tonumber(obj.stop) == 1 then
                img:setLocalZOrder(atX+self.maxTileNum-atY)
            end
            if obj.type == "tree" then
                img:setAnchorPoint(cc.p(0.5, 0.2))
            elseif obj.type == "dk" then
                img:setAnchorPoint(cc.p(0.5, 0.35)) 
            elseif obj.type == "lud" then
                img:setAnchorPoint(cc.p(0.5, 0.2))
            elseif obj.type == "gmc" then
                img:setAnchorPoint(cc.p(0.5, 0.35))
            elseif obj.type == "xrz1" then
                img:setAnchorPoint(cc.p(0.5, 0.2))
            elseif obj.type == "lup1" then
                img:setAnchorPoint(cc.p(0.5, 0.3))
            end
            tile.stop = zstring.tonumber(obj.stop)
            img:setPosition(tile.player_pos)

            self.tmxMap:addChild(img)
        end
    end

    -- local shuTu = ccui.ImageView:create("tmx/image/shu.png")
    -- shuTu:setAnchorPoint(cc.p(0.5, 0.2))
    -- for i, tree in ipairs(shu:getObjects()) do
    --     debug.print_r(tree, "tree")
    --     if tree.type == "tree" then
    --         local curTree = shuTu:clone()
    --         local atX = math.floor(tree.x/tree.width) 
    --         local atY = math.floor(tree.y/tree.height)
    --         local tile = self.allTitlePos[atX][self.maxTileNum - atY]
    --         tile.stop = 1
    --         curTree:setPosition(tile.player_pos)
    --         curTree:setLocalZOrder(atX+self.maxTileNum-atY)
    --         self.tmxMap:addChild(curTree)
    --     end
    -- end
    
end

-- 实时改变人物的层级
function ExplorationMap:onUpdate( dt )
    -- if self.allTiles then
    --     local tile = self:getTouchTile(cc.p(self.player:getPositionX(), self.player:getPositionY()))
    --     if tile then
    --         local zOrder = tile.tile_pos[1] + tile.tile_pos[2]
    --         self.tmxMap:reorderChild(self.player, zOrder)
    --     end
    -- end
end

function ExplorationMap:getPlayerZorder()
    -- body
end

-- 获取点击的地块
function ExplorationMap:getTouchTile( point )
    for i,tile in ipairs(self.allTiles) do
        local rect = tile:getBoundingBox()
        if self:rectContainsPoint( tile, point ) then
            return tile
        end
    end
end

function ExplorationMap:rectContainsPoint( tile, point )
    local ret = false
    local rect = tile:getBoundingBox()
    -- if rect.x == 0 and rect.y == 1813 then
    --     print("333333333333333333333333====", rect.height, rect.width, (point.x >= rect.x) and (point.x <= rect.x + rect.width), (point.y >= (rect.y - rect.height/2)) and (point.y <= (rect.y + rect.height/2)))
    --     print("44444444444444444444====", (rect.y - rect.height/2), (rect.y + rect.height/2))
    --     local tileBoundingbox = rect
    -- end

    local rX = point.x
    local rY = point.y - self.walkMap[2]/2
    if tile.tile_pos[1] == math.floor(rX/rect.width - rY/rect.height) and
    tile.tile_pos[2] == self.maxTileNum - math.floor(rX/rect.width + rY/rect.height) then
        ret = true
    end
    return ret
end

-- 寻路算法
function ExplorationMap:findRoadA( startPoint, endPoint )
    --A*寻路算法，目前只适用于 01图, 0可通行， 1不可通行
    -- 行走的4个方向
    local four_dir ={{1, 0},{0, 1}, {0, -1},{-1, 0}}

    local cost          = 10 -- 单位花费
    self.open_list      = {}
    self.close_list     = {}
    local mapRows       = #self.allTitlePos
    local mapCols       = #self.allTitlePos[1]

    -- 在open_list中找到最佳点,并删除
    local getMinNode = function()
        if #self.open_list < 1 then
            return nil
        end

        local min_node = self.open_list[1]
        local min_i = 1
        for i,v in ipairs(self.open_list) do
            if min_node.f > v.f then
                min_node = v
                min_i = i
            end
        end
        table.remove(self.open_list, min_i)
        return min_node
    end

    -- 计算路径
    local buildPath = function(node)
        local path = {}
        local sumCost = node.f -- 路径的总花费
        while node do
            path[#path + 1] = {row = node.row, col = node.col}
            node = node.father
        end
        return path, sumCost
    end

    -- 估价h函数
    -- 曼哈顿估价法（用于不能对角行走）
    local manhattan = function(row, col)  
        local h = math.abs(row - endPoint[1]) + math.abs(col - endPoint[2])
        return h * cost
    end

    -- 获取 f ,g ,h, 最后参数是否对角线走
    local getFGH = function(father, row, col, isdiag)
        local node = {}
        node.father = father
        node.row = row
        node.col = col
        node.g = father.g + cost
        -- 估计值h
        node.h = manhattan(row, col)
        node.f = node.g + node.h  -- f = g + h 
        return node
    end

    -- 判断节点是否已经存在 open list 里面
    local nodeInOpenList = function(row, col)
        for i = 1, #self.open_list do
            local node = self.open_list[i]
            if node.row == row and node.col == col then
                return node, i   -- 返回节点和下标
            end
        end
    end

    -- 判断节点是否已经存在 close list 里面
    local nodeInCloseList = function(row, col)
        for i = 1, #self.close_list do
            local node = self.close_list[i]
            if node.row == row and node.col == col then
                return node, i
            end
        end

        return nil
    end

-- ------------------------核心方法--------------------------
    if self.allTitlePos[endPoint[1]][endPoint[2]].stop ~= 0 then
        -- Logger.info("(", self.endPoint.row, ",", self.endPoint.col, ") 是阻挡！！！无法寻路")
        -- TipDlg.drawTextDailog(tipStringInfo_exploration_tips[1])
        return nil
    end
 
    -- 把第一节点加入 open_list中
    local startNode = {}  
    startNode.row = startPoint[1]
    startNode.col = startPoint[2]
    startNode.g = 0
    startNode.h = 0
    startNode.f = 0
    table.insert(self.open_list, startNode)
         
    -- 检查边界、障碍点 
    local check = function(row, col)
        if 0 <= row and row <= mapRows and 0 <= col and col <= mapCols then
            if self.allTitlePos[row][col].stop == 0 or (row == endPoint[1] and col == endPoint[2]) then
                return true 
            end
        end
        return false
    end
 
    while #self.open_list > 0 do
        local node = getMinNode()
        if node.row == endPoint[1] and node.col == endPoint[2] then
            -- 找到路径
            return buildPath(node)
        end

        for i = 1, #four_dir do
            local row = node.row + four_dir[i][1]
            local col = node.col + four_dir[i][2]
            if check(row, col) then
                local curNode = getFGH(node, row, col, (row ~= node.row and col ~= node.col))
                local openNode, openIndex = nodeInOpenList(row, col)
                local closeNode, closeIndex = nodeInCloseList(row, col)
                if not openNode and not closeNode then
                    -- 不在OPEN表和CLOSE表中
                    -- 添加特定节点到 open list
                    table.insert(self.open_list, curNode)
                elseif openNode then
                    -- 在OPEN表
                    if openNode.f > curNode.f then
                        -- 更新OPEN表中的估价值
                        self.open_list[openIndex] = curNode
                    end
                else
                    -- 在CLOSE表中
                    if closeNode.f > curNode.f then
                        table.insert(self.open_list, curNode)
                        table.remove(self.close_list, closeIndex)
                    end
                end
            end
        end

        -- 节点放入到 close list 里面
        table.insert(self.close_list, node)
    end

    -- 不存在路径
    return nil
end

function ExplorationMap:onExit()
    state_machine.remove("exploration_map_close")
end

function ExplorationMap:destroy(window)
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end