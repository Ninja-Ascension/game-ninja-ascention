----------------------------------------------------------------------------------------------------
-- 说明:问答结果
----------------------------------------------------------------------------------------------------
ExplorationAllFinisQuestionResult = class("ExplorationAllFinisQuestionResultClass", Window)

function ExplorationAllFinisQuestionResult:ctor()
    self.super:ctor()
    self.roots = {}
    
    app.load("client.l_digital.campaign.exploration.ExplorationAllFinish")

	local function init_exploration_all_finish_question_result_cell_terminal()
		-- -- 点击cell
		local exploration_all_finish_window_goto_next_terminal = {
            _name = "exploration_all_finish_window_goto_next",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.pokemonExplore.lastSearchType) == 1 then
                    local cur_index = table.getKeyByValue(instance.ids, instance.id)
                    local id = instance.ids[cur_index + 1]
                    state_machine.excute("exploration_window_all_finish_update", 0, {id or 0}, 1)
                    fwin:close(fwin:find("ExplorationAllFinisQuestionResultClass"))
                else
                    local function callback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            fwin:close(fwin:find("ExplorationAllFinisQuestionResultClass"))
                            state_machine.excute("exploration_all_finish_window_close", 0, "")
                        end
                    end
                    protocol_command.pokemon_explore_single_event_finish.param_list = json.encode({resultIndex = instance.ids.index})
                    NetworkManager:register(protocol_command.pokemon_explore_single_event_finish.code, nil, nil, nil, nil, callback, false, nil)
                --     fwin:close(fwin:find("ExplorationAllFinisQuestionResultClass"))
                --     state_machine.excute("exploration_all_finish_window_close", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_all_finish_question_review_terminal = {
            _name = "exploration_all_finish_question_review",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("exploration_window_all_finish_update", 0, {instance.id, 1})
                fwin:close(fwin:find("ExplorationAllFinisQuestionResultClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(exploration_all_finish_window_goto_next_terminal)
        state_machine.add(exploration_all_finish_question_review_terminal)
        state_machine.init()
	end

	init_exploration_all_finish_question_result_cell_terminal()
end

function ExplorationAllFinisQuestionResult:onUpdateDraw()
    local root = self.roots[1]
    local right_num = 0
    for i,v in ipairs(_ED.pokemonEventIds[self.id]) do
        local right_index = dms.int(dms["role_explore_question"], v.questionId, file_island_question.rightIndex)
        if right_index == _ED.all_answer[i] then
            right_num = right_num + 1
        end
    end

    

    local Text_explore_thanks_n = ccui.Helper:seekWidgetByName(root, "Text_explore_thanks_n")
    local all_num = table.nums(_ED.pokemonEventIds[self.id])
    if not self.is_all then
        local right_index = dms.int(dms["role_explore_question"], self.ids.questionId, file_island_question.rightIndex)
        if right_index == _ED.all_answer[1] then
            right_num = right_num + 1
        end
        all_num = 1
    end
    
    for k,rewardList in ipairs(self.getReword.show_reward_list) do
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,-1,rewardList.item_value},true,true,false,true})
        local Panel_thanks = ccui.Helper:seekWidgetByName(root, "Panel_thanks_" .. k)
        Panel_thanks:addChild(cell)
    end

    local Panel_10 = ccui.Helper:seekWidgetByName(root, "Panel_10")
    local Panel_10_0 = ccui.Helper:seekWidgetByName(root, "Panel_10_0")
    local Panel_10_0_0 = ccui.Helper:seekWidgetByName(root, "Panel_10_0_0")
    Panel_10:setVisible(false)
    Panel_10_0:setVisible(false)
    Panel_10_0_0:setVisible(false)

    if self.is_all then
        Panel_10:setVisible(true)
        Text_explore_thanks_n:setString(string.format(tipStringInfo_file_island_tips[2],all_num, right_num))
    else
        if right_num >= all_num then
            Panel_10_0:setVisible(true)
            local jsonFile = "images/ui/effice/spirte_tansuozhengque/spirte_tansuozhengque.json"
            local atlasFile = "images/ui/effice/spirte_tansuozhengque/spirte_tansuozhengque.atlas"
            local animation3 = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
            animation3.animationNameList = {"animation"}
            sp.initArmature(animation3, false)
            animation3._invoke = tempActionCallback
            animation3:setPosition(cc.p(Panel_10_0:getContentSize().width/2, Panel_10_0:getContentSize().height/2))
            Panel_10_0:addChild(animation3)
            animation3:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            csb.animationChangeToAction(animation3, 0, 0, false)

            Text_explore_thanks_n:setString(tipStringInfo_file_island_tips[13])
        else
            Panel_10_0_0:setVisible(true)
            Text_explore_thanks_n:setString(tipStringInfo_file_island_tips[14])
        end
    end
end

function ExplorationAllFinisQuestionResult:onInit()
    local csbNode = csb.createNode("campaign/exploration/exploration_event_question_once.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_thanks_sure"), nil, 
    {
        terminal_name = "exploration_all_finish_window_goto_next", 
        isPressedActionEnabled = true
    },
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_thanks_review"), nil, 
    {
        terminal_name = "exploration_all_finish_question_review", 
        isPressedActionEnabled = true
    },
    nil, 0)
    self:onUpdateDraw()
end

function ExplorationAllFinisQuestionResult:clearUIInfo()
end

function ExplorationAllFinisQuestionResult:initData()
end

function ExplorationAllFinisQuestionResult:init(params)
    self.id = params[1]
    self.ids = params[2]
    self.is_all = params[3]
    self.getReword = params[4]

    _ED.isReview = true
    self:onInit()
end


