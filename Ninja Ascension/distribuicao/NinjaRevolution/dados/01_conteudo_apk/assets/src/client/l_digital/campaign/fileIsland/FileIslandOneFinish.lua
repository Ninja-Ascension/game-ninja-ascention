-- ----------------------------------------------------------------------------------------------------
-- 说明：一次探索一个任务
-------------------------------------------------------------------------------------------------------
FileIslandOneFinish = class("FileIslandOneFinishClass", Window)

local fileIsland_one_finish_window_open_terminal = {
    _name = "fileIsland_one_finish_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if type(params) == "number" then
            if fwin:find("FileIslandOneFinishClass") == nil then
                fwin:open(FileIslandOneFinish:new():init(params), fwin._view)
            end
        else     
            local function callback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

                    -- 刷新探索点和计时
                    state_machine.excute("fileIsland_window_onUpdateDraw", 0, "") 

                    if fwin:find("FileIslandOneFinishClass") == nil then
                        fwin:open(FileIslandOneFinish:new():init(params), fwin._view)
                    end
                end
            end

            local data = {}
            data.type = 0
            local req = json.encode(data)
            protocol_command.fileIslandSearch.param_list = req
            NetworkManager:register(protocol_command.fileIslandSearch.code, nil, nil, nil, nil, callback, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local fileIsland_one_finish_window_close_terminal = {
    _name = "fileIsland_one_finish_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("FileIslandOneFinishClass") then
            fwin:close(fwin:find("FileIslandOneFinishClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fileIsland_one_finish_window_open_terminal)
state_machine.add(fileIsland_one_finish_window_close_terminal)
state_machine.init()

function FileIslandOneFinish:ctor()
    self.super:ctor()
    self.roots = {}
    self.eventId = nil

    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinish")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinishRegularCell")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinishFreeBoxCell")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinishCostBoxCell")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinisQuestionOneCell")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinisQuestionTowCell")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinishPKOneCell")
    app.load("client.l_digital.campaign.fileIsland.FileIslandOneFinishOpenBox")
    app.load("client.l_digital.campaign.fileIsland.FileIslandFriends")
    app.load("client.l_digital.campaign.fileIsland.FileIslandBoss")
    app.load("client.l_digital.campaign.fileIsland.FileIslandWindow")
    
    local function init_fileIsland_one_finish_terminal()
        local fileIsland_one_finish_sure_terminal = {
            _name = "fileIsland_one_finish_sure",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local eventId = _ED.fileIsland.resultInfo.resultArray[1].eventId
                local infos = _ED.fileIsland.resultInfo.resultArray[1]
                if instance.eventId and instance.eventId ~= "" and tonumber(instance.eventId) > 0 then
                    eventId = instance.eventId
                    infos = _ED.eventIds[eventId][1]
                end
                if eventId == 1 then -- 好友任务
                    state_machine.excute("fileIsland_window_friends_open_request_data", 0, "")
                    state_machine.excute("fileIsland_window_updateDraw_friend_redPoint", 0, "")
                    state_machine.excute("fileIsland_one_finish_window_close", 0, "")
                elseif eventId == 2 then -- 团队任务 
                    state_machine.excute("fileIsland_window_team_boss_open_request_data", 0, "")
                    state_machine.excute("fileIsland_window_updateDraw_boss_redPoint", 0, "")
                    state_machine.excute("fileIsland_one_finish_window_close", 0, "")
                elseif eventId == 3 then -- 随机宝箱
                    state_machine.excute("fileIsland_one_finish_open_box_open_box_window_open", 0, "")
                    local rewardInfo = getSceneReward(72) 
                    if rewardInfo ~= nil then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(nil, rewardInfo)
                        fwin:open(getRewardWnd, fwin._ui)
                    end
                    state_machine.excute("fileIsland_one_finish_window_close", 0, "")
                elseif tonumber(eventId) == 4 then --趣味问答
                    state_machine.excute("fileIsland_all_finish_window_open", 0, eventId)
                    state_machine.excute("fileIsland_one_finish_window_close", 0, "")
                elseif tonumber(eventId) == 5 then --单人挑战
                    state_machine.excute("fileIsland_formation_open", 0, {info = infos, infoType = 2})
                elseif tonumber(eventId) == 6 then --休息
                    NetworkManager:register(protocol_command.file_island_finish_search_result.code, nil, nil, nil, nil, callback, false, nil)
                    state_machine.excute("fileIsland_one_finish_window_close", 0, "")
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fileIsland_one_finish_give_up_terminal = {
            _name = "fileIsland_one_finish_give_up",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function showConfirmTip( instance,n )
                    if n == 0 then
                        local eventId = _ED.fileIsland.resultInfo.resultArray[1].eventId
                        NetworkManager:register(protocol_command.file_island_finish_search_result.code, nil, nil, nil, nil, callback, false, nil)
                        state_machine.excute("fileIsland_one_finish_window_close", 0, "")
                    end
                end

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

        state_machine.add(fileIsland_one_finish_sure_terminal)
        state_machine.add(fileIsland_one_finish_give_up_terminal)
        state_machine.init()
    end
    
    init_fileIsland_one_finish_terminal()
end

function FileIslandOneFinish:init(params) 
    self.eventId = params
    return self
end

function FileIslandOneFinish:onUpdate(dt)

end

function FileIslandOneFinish:onUpdateDraw()
    local root = self.roots[1]
    local Text_explore_success_ex_n = ccui.Helper:seekWidgetByName(root, "Text_explore_success_ex_n")
    local Text_explore_success_jb_n = ccui.Helper:seekWidgetByName(root, "Text_explore_success_jb_n")
    local Text_explore_success_tsb_n = ccui.Helper:seekWidgetByName(root, "Text_explore_success_tsb_n")
    local Text_explore_success_cue_2 = ccui.Helper:seekWidgetByName(root, "Text_explore_success_cue_2")

    local event_id = _ED.fileIsland.resultInfo.resultArray[1].eventId
    local event_des_id = dms.int(dms["file_island_event"], event_id, file_island_event.describe)
    local word_info = dms.element(dms["word_mould"], event_des_id)
    Text_explore_success_cue_2:setString(word_info[3])

    local infos = zstring.splits(dms.searchs(dms["file_island_reward"], 2, _ED.user_info.user_grade)[1][3], "|", ",")

    -- local rewordInfo = getSceneReward(71)
    for i,info in ipairs(infos) do
        if tonumber(info[1]) == 8 then
            Text_explore_success_ex_n:setString("x " .. info[3])
        elseif tonumber(info[1]) == 1 then
            Text_explore_success_jb_n:setString("x " .. info[3])
        elseif tonumber(info[1]) == 68 then
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

    local eventId = _ED.fileIsland.resultInfo.resultArray[1].eventId
    if self.eventId and self.eventId ~= "" and tonumber(self.eventId) > 0 then
        eventId = self.eventId
    end

    if eventId == 1 or eventId == 2 then
        Button_explore_success_q_tip:setVisible(true)
        Button_explore_success_no_tip:setVisible(true)
    elseif eventId == 3 or eventId == 4 then
        Button_explore_success_tip:setVisible(true)
    elseif eventId == 5 then
        Button_thanks_challenge:setVisible(true)
        Button_thanks_give_up:setVisible(true)

        local req = json.encode({nextEventId = eventId})
        protocol_command.file_island_dispose_next_search_eventId.param_list = req
        --前端自己存进行到哪一步
        _ED.fileIsland.resultInfo.curRewardIndex = eventId
        NetworkManager:register(protocol_command.file_island_dispose_next_search_eventId.code, nil, nil, nil, nil, callback, false, nil)
    else
        Button_explore_success_sure:setVisible(true)
    end
end

function FileIslandOneFinish:onEnterTransitionFinish()
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
        terminal_name = "fileIsland_one_finish_sure", 
        isPressedActionEnabled = true
    },
    nil, 0)

    --查看趣味问题
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_success_tip"), nil, 
    {
        terminal_name = "fileIsland_one_finish_sure", 
        isPressedActionEnabled = true
    },
    nil, 0)

    --查看好友任务或者团队boss
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_success_q_tip"), nil, 
    {
        terminal_name = "fileIsland_one_finish_sure", 
        isPressedActionEnabled = true
    },
    nil, 0)

    --放弃查看好友任务或团队boss
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_success_no_tip"), nil, 
    {
        terminal_name = "fileIsland_one_finish_give_up", 
        _type = 0,
        isPressedActionEnabled = true
    },
    nil, 0)

    --单人挑战
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_thanks_challenge"), nil, 
    {
        terminal_name = "fileIsland_one_finish_sure", 
        isPressedActionEnabled = true
    },
    nil, 0)

    --单人挑战放弃
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_thanks_give_up"), nil, 
    {
        terminal_name = "fileIsland_one_finish_give_up", 
        _type = 1,
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw(1)
end

function FileIslandOneFinish:onExit()

end
