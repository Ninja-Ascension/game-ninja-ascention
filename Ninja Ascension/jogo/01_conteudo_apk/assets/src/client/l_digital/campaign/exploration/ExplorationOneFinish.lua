-- ----------------------------------------------------------------------------------------------------
-- 说明：一次探索一个任务
-------------------------------------------------------------------------------------------------------
ExplorationOneFinish = class("ExplorationOneFinishClass", Window)

local exploration_one_finish_window_open_terminal = {
    _name = "exploration_one_finish_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if type(params) == "number" then
            if fwin:find("ExplorationOneFinishClass") == nil then
                fwin:open(ExplorationOneFinish:new():init(params), fwin._view)
            end
        else     
            -- 刷新探索点和计时
            -- state_machine.excute("exploration_window_onUpdateDraw", 0, "") 

            if fwin:find("ExplorationOneFinishClass") == nil then
                fwin:open(ExplorationOneFinish:new():init(params), fwin._view)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local exploration_one_finish_window_close_terminal = {
    _name = "exploration_one_finish_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("ExplorationOneFinishClass") then
            fwin:close(fwin:find("ExplorationOneFinishClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_one_finish_window_open_terminal)
state_machine.add(exploration_one_finish_window_close_terminal)
state_machine.init()

function ExplorationOneFinish:ctor()
    self.super:ctor()
    self.roots = {}
    self.eventId = nil

    -- app.load("client.l_digital.campaign.pokemonExplore.pokemonExploreAllFinish")
    -- app.load("client.l_digital.campaign.pokemonExplore.pokemonExploreAllFinishRegularCell")
    -- app.load("client.l_digital.campaign.pokemonExplore.pokemonExploreAllFinishFreeBoxCell")
    -- app.load("client.l_digital.campaign.pokemonExplore.pokemonExploreAllFinishCostBoxCell")
    -- app.load("client.l_digital.campaign.pokemonExplore.pokemonExploreAllFinisQuestionOneCell")
    -- app.load("client.l_digital.campaign.pokemonExplore.pokemonExploreAllFinisQuestionTowCell")
    -- app.load("client.l_digital.campaign.pokemonExplore.pokemonExploreAllFinishPKOneCell")
    app.load("client.l_digital.campaign.exploration.ExplorationOpenBox")
    app.load("client.l_digital.campaign.exploration.ExplorationFormation")
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinish")
    app.load("client.l_digital.campaign.exploration.ExplorationBoss")
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinishCatchBegin")
    -- app.load("client.l_digital.campaign.pokemonExplore.pokemonExploreFriends")
    -- app.load("client.l_digital.campaign.pokemonExplore.pokemonExploreBoss")
    -- app.load("client.l_digital.campaign.pokemonExplore.pokemonExploreWindow")
    
    local function init_exploration_one_finish_terminal()
        local exploration_one_finish_sure_terminal = {
            _name = "exploration_one_finish_sure",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local eventId = instance.eventInfo.eventId
                local infos = instance.eventInfo
                -- _ED.event_window_open = true
                
                if eventId == 1 then -- 随机宝箱
                    state_machine.excute("exploration_open_box_window_open", 0, infos)
                    state_machine.excute("exploration_one_finish_window_close", 0, "")
                elseif tonumber(eventId) == 6 then --单人挑战
                    state_machine.excute("exploration_formation_open", 0, {info = infos, infoType = 2})
                elseif eventId == 2 then           -- 休息
                    local function callback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("exploration_one_finish_window_close", 0, "")
                        end
                    end
                    protocol_command.pokemon_explore_single_event_finish.param_list = json.encode({resultIndex = instance.eventInfo.index})
                    NetworkManager:register(protocol_command.pokemon_explore_single_event_finish.code, nil, nil, nil, nil, callback, false, nil)

                elseif eventId == 3 then           -- boss 
                    state_machine.excute("exploration_window_team_boss_open_request_data", 0, "")
                    state_machine.excute("exploration_window_updateDraw_boss_redPoint", 0, "")
                    state_machine.excute("exploration_one_finish_window_close", 0, "")
                elseif tonumber(eventId) == 4 then --趣味问答
                    state_machine.excute("exploration_all_finish_window_open", 0, infos)
                    state_machine.excute("exploration_one_finish_window_close", 0, "")
                elseif tonumber(eventId) == 5 then --捕捉
                    state_machine.excute("exploration_all_finish_catch_begin_window_open", 0, {infos, 1})
                    state_machine.excute("exploration_one_finish_window_close", 0, "")
                end
                
                _ED.player_move = false
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_one_finish_give_up_terminal = {
            _name = "exploration_one_finish_give_up",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function showConfirmTip( instance,n )
                    if n == 0 then
                        local function callback( response )
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.excute("exploration_one_finish_window_close", 0, "")
                            end
                        end
                        protocol_command.pokemon_explore_single_event_finish.param_list = json.encode({resultIndex = instance.eventInfo.index})
                        NetworkManager:register(protocol_command.pokemon_explore_single_event_finish.code, nil, nil, nil, nil, callback, false, nil)
                        -- state_machine.excute("exploration_one_finish_window_close", 0, "")
                    end
                end
                -- _ED.event_window_open = true
                _ED.player_move = false
                if zstring.tonumber(params._datas._type) == 1 then
                    app.load("client.utils.ConfirmTip")
                    local tip = ConfirmTip:new()
                    tip:init(instance, showConfirmTip, tipStringInfo_file_island_tips[4])
                    fwin:open(tip, fwin._ui)
                else
                    showConfirmTip(instance, 0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(exploration_one_finish_sure_terminal)
        state_machine.add(exploration_one_finish_give_up_terminal)
        state_machine.init()
    end
    
    init_exploration_one_finish_terminal()
end

function ExplorationOneFinish:init(params) 
    self.eventInfo = params
    return self
end

function ExplorationOneFinish:onUpdate(dt)

end

function ExplorationOneFinish:onUpdateDraw()
    local root = self.roots[1]
    local Text_explore_success_ex_n = ccui.Helper:seekWidgetByName(root, "Text_explore_success_ex_n")
    local Text_explore_success_jb_n = ccui.Helper:seekWidgetByName(root, "Text_explore_success_jb_n")
    local Text_explore_success_tsb_n = ccui.Helper:seekWidgetByName(root, "Text_explore_success_tsb_n")
    local Text_explore_success_cue_2 = ccui.Helper:seekWidgetByName(root, "Text_explore_success_cue_2")
    local event_id = self.eventInfo.eventId
    local event_des_id = dms.int(dms["role_explore_event"], event_id, pokemon_explore_event.describe)
    local word_info = dms.element(dms["word_mould"], event_des_id)
    Text_explore_success_cue_2:setString(word_info[3])

    local infos = zstring.splits(dms.searchs(dms["role_explore_fix_reward"], 2, _ED.user_info.user_grade)[1][3], "|", ",")

    -- local rewordInfo = getSceneReward(71)
    for i,info in ipairs(infos) do
        if tonumber(info[1]) == 8 then
            Text_explore_success_ex_n:setString("x " .. info[3])
        elseif tonumber(info[1]) == 1 then
            Text_explore_success_jb_n:setString("x " .. info[3])
        elseif tonumber(info[1]) == 70 then
            Text_explore_success_tsb_n:setString("x " .. info[3])
        end
    end

    --按钮
    local Button_explore_success_sure = ccui.Helper:seekWidgetByName(root, "Button_explore_success_sure")
    local Button_explore_success_tip = ccui.Helper:seekWidgetByName(root, "Button_explore_success_tip")
    local Button_explore_success_q_tip = ccui.Helper:seekWidgetByName(root, "Button_explore_success_q_tip")
    local Button_explore_success_no_tip = ccui.Helper:seekWidgetByName(root, "Button_explore_success_no_tip")
    local Button_thanks_challenge = ccui.Helper:seekWidgetByName(root, "Button_thanks_challenge")
    local Button_thanks_give_up = ccui.Helper:seekWidgetByName(root, "Button_thanks_give_up")

    Button_explore_success_sure:setVisible(false)
    Button_explore_success_tip:setVisible(false)
    Button_explore_success_q_tip:setVisible(false)
    Button_explore_success_no_tip:setVisible(false)
    Button_thanks_challenge:setVisible(false)
    Button_thanks_give_up:setVisible(false)

    local eventId = self.eventInfo.eventId

    if eventId == 1 then
        -- Button_explore_success_q_tip:setVisible(true)
        -- Button_explore_success_no_tip:setVisible(true)
        Button_explore_success_tip:setVisible(true)
    elseif eventId == 4 then
        Button_explore_success_tip:setVisible(true)
    elseif eventId == 6 then
        Button_thanks_challenge:setVisible(true)
        Button_thanks_give_up:setVisible(true)

        -- local curMapId = cc.UserDefault:getInstance():getStringForKey(getKey("exploration_map_id"), "")
        -- local req = json.encode({mapId = curMapId,nextEventId = eventId})
        -- protocol_command.pokemon_explore_dispose_next_search_eventId.param_list = req
        -- --前端自己存进行到哪一步
        -- _ED.pokemonExplore.resultInfo.curRewardIndex = eventId
        -- NetworkManager:register(protocol_command.pokemon_explore_dispose_next_search_eventId.code, nil, nil, nil, nil, callback, false, nil)
    else
        Button_explore_success_sure:setVisible(true)
    end
end

function ExplorationOneFinish:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/explore/explore_thanks_answer.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    local Image_explore_success_bg_0 = ccui.Helper:seekWidgetByName(root, "Image_explore_success_bg_0")
    Image_explore_success_bg_0:setVisible(false)
    local Panel_success_text = ccui.Helper:seekWidgetByName(root, "Panel_success_text")
    Panel_success_text:setVisible(false)

    local jsonFile = "images/ui/effice/effect_kdtxtscg/effect_kdtxtscg.json" 
    local atlasFile = "images/ui/effice/effect_kdtxtscg/effect_kdtxtscg.atlas" 
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    animation.animationNameList = {"animation"}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    animation:setPosition(cc.p(Image_explore_success_bg_0:getPositionX() + Image_explore_success_bg_0:getContentSize().width / 2, Image_explore_success_bg_0:getPositionY() + 50))
    Image_explore_success_bg_0:getParent():addChild(animation)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation, 0, 1, false)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_success_sure"), nil, 
    {
        terminal_name = "exploration_one_finish_sure", 
        isPressedActionEnabled = true
    },
    nil, 0)

    --查看趣味问题
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_success_tip"), nil, 
    {
        terminal_name = "exploration_one_finish_sure", 
        isPressedActionEnabled = true
    },
    nil, 0)

    --查看好友任务或者团队boss
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_success_q_tip"), nil, 
    {
        terminal_name = "exploration_one_finish_sure", 
        isPressedActionEnabled = true
    },
    nil, 0)

    --放弃查看好友任务或团队boss
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_success_no_tip"), nil, 
    {
        terminal_name = "exploration_one_finish_give_up", 
        _type = 0,
        isPressedActionEnabled = true
    },
    nil, 0)

    --单人挑战
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_thanks_challenge"), nil, 
    {
        terminal_name = "exploration_one_finish_sure", 
        isPressedActionEnabled = true
    },
    nil, 0)

    --单人挑战放弃
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_thanks_give_up"), nil, 
    {
        terminal_name = "exploration_one_finish_give_up", 
        _type = 1,
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw(1)
end

function ExplorationOneFinish:onExit()

end
