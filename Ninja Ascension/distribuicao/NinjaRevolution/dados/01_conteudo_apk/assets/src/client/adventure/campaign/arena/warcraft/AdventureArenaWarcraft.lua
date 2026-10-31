-- ----------------------------------------------------------------------------------------------------
-- 说明：排位赛列表界面
-------------------------------------------------------------------------------------------------------
AdventureArenaWarcraft = class("AdventureArenaWarcraftClass", Window)
AdventureArenaWarcraft._old_title_id = 0 -- 上次称号ID
AdventureArenaWarcraft._old_warcraf_state = 0 --上次状态

--全局函数
--是否有阶段化提示 得到状态做刷新以及播放动画用
function getResultTipType()
    --晋升成功:titleid增加 而且state由1或者2变为0
    --晋升失败:titleid不变 而且state由1或者2变为0
    --掉段惩罚:titleid变小
    --晋升赛:titleid不变 而且state由0变为1或者2
    --AdventureArenaWarcraft._old_title_id = zstring.tonumber(_ED.warcraft_info.current_title_id)
    --AdventureArenaWarcraft._old_warcraf_state = zstring.tonumber(_ED.warcraft_info.current_state)
   
    local openType = 0
    if zstring.tonumber(_ED.warcraft_info.current_title_id) > zstring.tonumber(AdventureArenaWarcraft._old_title_id) then 
        if zstring.tonumber(_ED.warcraft_info.current_state) == 0 and 
            AdventureArenaWarcraft._old_warcraf_state > zstring.tonumber(_ED.warcraft_info.current_state) then 
            openType = 1
        end
    end
    if zstring.tonumber(_ED.warcraft_info.current_title_id) == zstring.tonumber(AdventureArenaWarcraft._old_title_id) then 
        if zstring.tonumber(_ED.warcraft_info.current_state) == 0 and 
            AdventureArenaWarcraft._old_warcraf_state > zstring.tonumber(_ED.warcraft_info.current_state) then 
            openType = 2
        end
    end
    if zstring.tonumber(_ED.warcraft_info.current_title_id) < AdventureArenaWarcraft._old_title_id then 
        openType = 3
    end
    if zstring.tonumber(_ED.warcraft_info.current_title_id) == zstring.tonumber(AdventureArenaWarcraft._old_title_id) then 
         if AdventureArenaWarcraft._old_warcraf_state == 0  then 
            if zstring.tonumber(_ED.warcraft_info.current_state) > AdventureArenaWarcraft._old_warcraf_state then 
                openType = 4         
            end
         end
    end
   return openType 
end
--全局函数
--是否有阶段化提示 弹出对应的框
function checkResultTip()
    --晋升成功:titleid增加 而且state由1或者2变为0
    --晋升失败:titleid不变 而且state由1或者2变为0
    --掉段惩罚:titleid变小
    --晋升赛:titleid不变 而且state由0变为1或者2
    --AdventureArenaWarcraft._old_title_id = zstring.tonumber(_ED.warcraft_info.current_title_id)
    --AdventureArenaWarcraft._old_warcraf_state = zstring.tonumber(_ED.warcraft_info.current_state)
   
    local openType = 0
    if zstring.tonumber(_ED.warcraft_info.current_title_id) > zstring.tonumber(AdventureArenaWarcraft._old_title_id) then 
        if zstring.tonumber(_ED.warcraft_info.current_state) == 0 and 
            AdventureArenaWarcraft._old_warcraf_state > zstring.tonumber(_ED.warcraft_info.current_state) then 
            openType = 1
        end
    end
    if zstring.tonumber(_ED.warcraft_info.current_title_id) == zstring.tonumber(AdventureArenaWarcraft._old_title_id) then 
        if zstring.tonumber(_ED.warcraft_info.current_state) == 0 and 
            AdventureArenaWarcraft._old_warcraf_state > zstring.tonumber(_ED.warcraft_info.current_state) then 
            openType = 2
        end
    end
    if zstring.tonumber(_ED.warcraft_info.current_title_id) < AdventureArenaWarcraft._old_title_id then 
        openType = 3
    end
    if zstring.tonumber(_ED.warcraft_info.current_title_id) == zstring.tonumber(AdventureArenaWarcraft._old_title_id) then 
         if AdventureArenaWarcraft._old_warcraf_state == 0  then 
            if zstring.tonumber(_ED.warcraft_info.current_state) > AdventureArenaWarcraft._old_warcraf_state then 
                openType = 4         
            end
         end
    end
    if openType > 0 then 
          app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftResultTip")
          fwin:open(AdventureArenaWarcraftResultTip:new():init(openType), fwin._windows)
    end
    
    AdventureArenaWarcraft._old_title_id = zstring.tonumber(_ED.warcraft_info.current_title_id)
    AdventureArenaWarcraft._old_warcraf_state = zstring.tonumber(_ED.warcraft_info.current_state)
end

function AdventureArenaWarcraft:ctor()
    self.super:ctor()
    self.roots = {}
    self.isTouchLock = false
    self.interval = 0
    self.needUpdateRefreshCd = false
    -- 显示CD的时间
    self.strtime = nil
    self.isGetServer = false

    app.load("client.adventure.utils.AdventureSprite")
    -- Initialize adventure arena state machine.
    local function init_adventure_arena_warcraft_terminal()
        --商店
        local adventure_arena_warcraft_shop_terminal = {
            _name = "adventure_arena_warcraft_shop",
            _init = function (terminal)
                 app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftShop")     
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureArenaWarcraftShop:new(),fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --返回
        local adventure_arena_warcraft_close_terminal = {
            _name = "adventure_arena_warcraft_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("AdventureArenaWarcraftClass"))
                if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
                    or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge 
                    or __lua_project_id == __lua_project_yugioh 
                    or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                    or __lua_project_id == __lua_project_warship_girl_b 
                    then
                    if fwin:find("CampaignClass") == nil then
                        fwin:open(Campaign:new(), fwin._view)
                    else
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --查看阵型
        local adventure_arena_warcraft_see_fight_info_terminal = {
            _name = "adventure_arena_warcraft_see_fight_info",
            _init = function (terminal)
                 app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftFighterInfo")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local panelIndex = params._datas.current_index
                if _ED.warcraft_info.rank_list[panelIndex] == nil then 
                    return true
                end
                local function responseSeeInfoCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        fwin:open(AdventureArenaWarcraftFighterInfo:new(),fwin._windows)        
                    end
                end
                if __lua_project_id == __lua_project_yugioh 
                    or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
                    or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge 
                    or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                    or __lua_project_id == __lua_project_warship_girl_b 
                    then 
                    return
                end
                protocol_command.warcraft_see_user_formation.param_list = "" .. _ED.warcraft_info.rank_list[panelIndex].formationid.."\r\n".."0" 
                NetworkManager:register(protocol_command.warcraft_see_user_formation.code, nil, nil, nil, nil, responseSeeInfoCallBack, true, nil)
  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
          --刷新积分点数
        local adventure_arena_warcraft_refresh_integral_terminal = {
            _name = "adventure_arena_warcraft_refresh_integral",
            _init = function (terminal)
        
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDrawIntegral()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --排行
        local adventure_arena_warcraft_rank_terminal = {
            _name = "adventure_arena_warcraft_rank",
            _init = function (terminal)
                app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftRankList")     
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseRankCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        fwin:open(AdventureArenaWarcraftRankList:new(),fwin._windows)        
                    end
                end
                if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
                    or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge 
                    or __lua_project_id == __lua_project_yugioh 
                    or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                    or __lua_project_id == __lua_project_warship_girl_b 
                    then 
                    local currentServerNumber = _ED.all_servers[_ED.selected_server].server_number
                    protocol_command.warcraft_show_rank_list.param_list = currentServerNumber
                    NetworkManager:register(protocol_command.warcraft_show_rank_list.code, _ED.union_fight_url, nil, nil, nil, responseRankCallBack, false, nil)
                else
                    NetworkManager:register(protocol_command.warcraft_show_rank_list.code, nil, nil, nil, nil, responseRankCallBack, false, nil)
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --进入擂台
        local adventure_arena_warcraft_enter_list_terminal = {
            _name = "adventure_arena_warcraft_enter_list",
            _init = function (terminal)
                app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftList")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local is_over = false
                local is_digimon = true --数码宝贝
                if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
                    or __lua_project_id == __lua_project_pokemon 
                    or __lua_project_id == __lua_project_rouge 
                    or __lua_project_id == __lua_project_yugioh 
                    or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
                    or __lua_project_id == __lua_project_warship_girl_b 
                    then 
                    is_digimon = true
                    is_over = zstring.tonumber(_ED.warcraft_info.is_action_over) >= 1
                else
                    is_digimon = false
                    is_over = _ED.active_activity[72] == nil
                end

                if is_over == false then 
                    --可以进入
                    fwin:close(fwin:find("AdventureArenaWarcraftClass"))
                    if is_digimon == true then 
                        fwin:open(AdventureArenaWarcraftList:new(), fwin._view)
                    else
                        fwin:open(AdventureArenaWarcraftList:new(), fwin._windows)
                    end
                    
                else

                end 
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
    
        state_machine.add(adventure_arena_warcraft_rank_terminal)
        state_machine.add(adventure_arena_warcraft_close_terminal)
        state_machine.add(adventure_arena_warcraft_shop_terminal)
        state_machine.add(adventure_arena_warcraft_enter_list_terminal)
        state_machine.add(adventure_arena_warcraft_see_fight_info_terminal)
        state_machine.add(adventure_arena_warcraft_refresh_integral_terminal)
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_warcraft_terminal()
end

function AdventureArenaWarcraft:init(isGetServer)
    if isGetServer ~= nil and isGetServer == true then 
        self.isGetServer = true
    else
        self.isGetServer = false
    end
    return self
end

function AdventureArenaWarcraft:updateRefreshCd()
    if self.needUpdateRefreshCd == false then
        return
    end
    local root = self.roots[1]
    local interval = self.interval
    if interval <= 0 then
        ccui.Helper:seekWidgetByName(root, "Text_cd"):setString("00:00:00")
    else
        self.interval = math.max(0, self.interval)

        local timeTabel = formatTime(self.interval)
        self.strtime = timeTabel.hour
        self.strtime = self.strtime .. string.format(":%02d", timeTabel.minute)
        self.strtime = self.strtime .. string.format(":%02d", timeTabel.second)

        ccui.Helper:seekWidgetByName(root, "Text_cd"):setString(self.strtime)
    end
    
end

function AdventureArenaWarcraft:onUpdate(dt)

end

function AdventureArenaWarcraft:onUpdateDrawIntegral()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    ccui.Helper:seekWidgetByName(root, "Text_jifen"):setString("" .._ED.warcraft_info.current_integral ) --我的积分
    ccui.Helper:seekWidgetByName(root, "Text_shengdian"):setString("" .._ED.warcraft_info.current_win_count ) --我的胜点
end    

function AdventureArenaWarcraft:onUpdateDraw()
    local root = self.roots[1]

    if root == nil then 
        return
    end

    local enterButton = ccui.Helper:seekWidgetByName(root, "Button_enter")
    local is_over = false
    local is_digimon = true --数码宝贝
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
        or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
        or __lua_project_id == __lua_project_warship_girl_b 
        then 
        is_digimon = true
        is_over = zstring.tonumber(_ED.warcraft_info.is_action_over) >= 1
    else
        is_digimon = false
        is_over = _ED.active_activity[72] == nil
    end
    if is_over then 
        enterButton:setTouchEnabled(false)
        enterButton:setColor(cc.c3b(150, 150, 150))
        if is_digimon == true then 
            ccui.Helper:seekWidgetByName(root, "Text_button"):setString(warcraft_tip[19])
        else
            ccui.Helper:seekWidgetByName(root, "Text_button"):setString(_string_piece_info[459])
        end
    else
        enterButton:setTouchEnabled(true)
        enterButton:setColor(cc.c3b(255, 255, 255))
        if is_digimon == true then 
            if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
            else
                ccui.Helper:seekWidgetByName(root, "Text_button"):setString(warcraft_tip[18])
            end
        else
            ccui.Helper:seekWidgetByName(root, "Text_button"):setString(_string_piece_info[458])
        end
        
    end
    
    if is_digimon == true then 
        app.load("client.cells.ship.ship_body_cell_new")
        for i=1,6 do    
            local shipId = zstring.tonumber(_ED.formetion[1+i])
            local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_role_"..i) 
            rolePanel:removeAllChildren()
            if shipId > 0 then 
                local cell = ShipBodyCellNew:createCell()
                local temple_id = _ED.user_ship["" .. shipId].ship_template_id
                local picIndex = dms.int(dms["ship_mould"], temple_id, ship_mould.All_icon)
                local roleShipId = dms.string(dms["ship_mould"], temple_id, ship_mould.bust_index)
                cell:init(picIndex, true, nil, roleShipId)
                rolePanel:addChild(cell)
            end
        end    
    else    
        for i=1,25 do
            local shipId = zstring.tonumber(_ED.formetion[1+i])
            local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_role_"..i) --我的整形到 25
            rolePanel:removeBackGroundImage()
            rolePanel:removeAllChildren(true)
            if shipId > 0 then 
                local _ship_mould_id = _ED.user_ship["" .. shipId].ship_template_id
            
                local heroData = dms.element(dms["ship_mould"], _ship_mould_id)  
                
                local temp_bust_index = dms.atoi(heroData, ship_mould.bust_index)

                local role = AdventureSpriteBattle:create(temp_bust_index, 9) -- ccs.Armature:create("spirte_" .. temp_bust_index)
                local size = role:getContentSize()
                role:getAnimation():playWithIndex(0)
                role:setAnchorPoint(cc.p(0.5,0.0))
                role:setPosition(cc.p(rolePanel:getContentSize().width /2 , -size.height/2))
                role:getAnimation():setSpeedScale(0.4)
                local shadow = cc.Sprite:create("images/ui/bg/shadow.png")
                shadow:setScale(0.5)
                rolePanel:addChild(shadow, -1)
                shadow:setPosition(cc.p(rolePanel:getContentSize().width /2,0 ))
                rolePanel:addChild(role, 1)
            end
        end
    end
    if _ED.warcraft_info == nil then 
        return
    end
    local begin_time = os.date("%Y".."."
                                        .."%m".."."
                                        .."%d".." "
                                        .."%H"..":00", zstring.exchangeFrom(zstring.tonumber(_ED.warcraft_info.start_time/1000)))
    local end_time = os.date("%Y".."."
                                        .."%m".."."
                                        .."%d".." "
                                        .."%H"..":00", zstring.exchangeFrom(zstring.tonumber(_ED.warcraft_info.end_time/1000))) 

    local timeString = ""
    if is_digimon == true then 
        time = string.format(warcraft_tip[5],begin_time,end_time)
    else
        time = string.format(_string_piece_info[444],begin_time,end_time)
    end
    
    ccui.Helper:seekWidgetByName(root, "Text_20"):setString(time)
    ccui.Helper:seekWidgetByName(root, "AtlasLabel_2"):setString(_ED.warcraft_info.current_count)

    for i=1,3 do
        local nameText = ccui.Helper:seekWidgetByName(root, "Text_name_"..i) 
        local rolePanel =ccui.Helper:seekWidgetByName(root, "Panel_winner_".. i) --第一名panel
        if is_digimon == true then 
            ccui.Helper:seekWidgetByName(root, "Text_".. i):setString(warcraft_tip[4])
        else
            ccui.Helper:seekWidgetByName(root, "Text_".. i):setString(_string_piece_info[443])
        end
        
        ccui.Helper:seekWidgetByName(root, "Image_23_".. i):setVisible(true)
        rolePanel:removeAllChildren(true)
        nameText:setString("")
        if i <= #_ED.warcraft_info.rank_list then
            if is_digimon == true then
                local num = math.floor(tonumber(_ED.warcraft_info.rank_list[i].server_number)%1000)
                nameText:setString("S"..num.." ".. _ED.warcraft_info.rank_list[i].nickname)
            else
                nameText:setString(_ED.warcraft_info.rank_list[i].nickname)
            end
            
            if is_digimon == true then 
                app.load("client.cells.ship.ship_body_cell_new")
                local cell = ShipBodyCellNew:createCell()
                local temple_id = _ED.warcraft_info.rank_list[i].temple_mould_id
                local picIndex = dms.int(dms["ship_mould"], temple_id, ship_mould.All_icon)
                local roleShipId = dms.string(dms["ship_mould"], temple_id, ship_mould.bust_index)
                cell:init(picIndex, false, nil, roleShipId)
                rolePanel:addChild(cell)
            else
                local picIndex = dms.int(dms["ship_mould"], _ED.warcraft_info.rank_list[i].temple_mould_id, ship_mould.head_icon)            -- 物品图标索引   
                local armature1 = AdventureSpriteRole:create(picIndex)
                armature1:setPosition(cc.p(rolePanel:getContentSize().width/2,-rolePanel:getContentSize().height/2))
                rolePanel:addChild(armature1)
            end
            ccui.Helper:seekWidgetByName(root, "Image_23_".. i):setVisible(false)
        end
    end

    AdventureArenaWarcraft._old_title_id = zstring.tonumber(_ED.warcraft_info.current_title_id)
    AdventureArenaWarcraft._old_warcraf_state = zstring.tonumber(_ED.warcraft_info.current_state)
    
    if zstring.tonumber(_ED.warcraft_info.current_rank) == 0 then 
        --未入榜
        if is_digimon == true  then 
            ccui.Helper:seekWidgetByName(root, "Text_paimng"):setString(warcraft_tip[1]) --我的排名
        else
            ccui.Helper:seekWidgetByName(root, "Text_paimng"):setString(_string_piece_info[440]) --我的排名
        end
    else
        ccui.Helper:seekWidgetByName(root, "Text_paimng"):setString("" .._ED.warcraft_info.current_rank ) --我的排名
    end
    ccui.Helper:seekWidgetByName(root, "Text_jifen"):setString("" .._ED.warcraft_info.current_integral ) --我的积分
    ccui.Helper:seekWidgetByName(root, "Text_shengdian"):setString("" .._ED.warcraft_info.current_win_count ) --我的胜点
end

function AdventureArenaWarcraft:onEnterTransitionFinish()
    local csbAdventureArena = csb.createNode("campaign/Arena/jingji_pws_enter.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)

    self:onUpdateDraw()

    -- -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    for i=1,3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_winner_".. i),       nil, 
        {
            terminal_name = "adventure_arena_warcraft_see_fight_info", 
            terminal_state = 0, 
            current_index = i,
            isPressedActionEnabled = true
        }, 
        nil, 2) --   
    end
    
    --商店
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shop"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_shop", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    --排名
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_rank", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)    
    
    --进入擂台
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_enter"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_enter_list", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
        fwin:close(fwin:find("UserTopInfoAClass"))
        app.load("client.player.UserTopInfoA")
        fwin:open(UserTopInfoA:new(), fwin._view)
    end
end

function AdventureArenaWarcraft:close( ... )
    fwin:close(fwin:find("UserTopInfoAClass"))
end

function AdventureArenaWarcraft:onExit()
    state_machine.remove("adventure_arena_warcraft_enter_list")
    state_machine.remove("adventure_arena_warcraft_rank")
    state_machine.remove("adventure_arena_warcraft_shop")
    state_machine.remove("adventure_arena_warcraft_close")
    
end
