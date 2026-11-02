----------------------------------------------------------------------------------------------------
-- 说明:问答结果
----------------------------------------------------------------------------------------------------
FileIslandAllFinisQuestionResult = class("FileIslandAllFinisQuestionResultClass", Window)

function FileIslandAllFinisQuestionResult:ctor()
    self.super:ctor()
    self.roots = {}
    
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinish")

	local function init_fileIsland_all_finish_question_result_cell_terminal()
		-- -- 点击cell
		local fileIsland_all_finish_window_goto_next_terminal = {
            _name = "fileIsland_all_finish_window_goto_next",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cur_index = table.getKeyByValue(instance.ids, instance.id)
                local id = instance.ids[cur_index + 1]
                state_machine.excute("fileIsland_window_all_finish_update", 0, {id or 0}, 1)
                fwin:close(fwin:find("FileIslandAllFinisQuestionResultClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fileIsland_all_finish_question_review_terminal = {
            _name = "fileIsland_all_finish_question_review",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("fileIsland_window_all_finish_update", 0, {instance.id, 1})
                fwin:close(fwin:find("FileIslandAllFinisQuestionResultClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fileIsland_all_finish_window_goto_next_terminal)
        state_machine.add(fileIsland_all_finish_question_review_terminal)
        state_machine.init()
	end

	init_fileIsland_all_finish_question_result_cell_terminal()
end

function FileIslandAllFinisQuestionResult:onUpdateDraw()
    local root = self.roots[1]
    local right_num = 0
    for i,v in ipairs(_ED.eventIds[self.id]) do
        local right_index = dms.int(dms["file_island_question"], v.questionId, file_island_question.rightIndex)
        if right_index == _ED.all_answer[i] then
            right_num = right_num + 1
        end
    end

    local Text_explore_thanks_n = ccui.Helper:seekWidgetByName(root, "Text_explore_thanks_n")
    local all_num = table.nums(_ED.eventIds[self.id])
    
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
            Text_explore_thanks_n:setString(tipStringInfo_file_island_tips[13])
        else
            Panel_10_0_0:setVisible(true)
            Text_explore_thanks_n:setString(tipStringInfo_file_island_tips[14])
        end
    end
end

function FileIslandAllFinisQuestionResult:onInit()
    local csbNode = csb.createNode("campaign/explore/explore_once.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_thanks_sure"), nil, 
    {
        terminal_name = "fileIsland_all_finish_window_goto_next", 
        isPressedActionEnabled = true
    },
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_thanks_review"), nil, 
    {
        terminal_name = "fileIsland_all_finish_question_review", 
        isPressedActionEnabled = true
    },
    nil, 0)
    self:onUpdateDraw()
end

function FileIslandAllFinisQuestionResult:clearUIInfo()
end

function FileIslandAllFinisQuestionResult:initData()
end

function FileIslandAllFinisQuestionResult:init(params)
    self.id = params[1]
    self.ids = params[2]
    self.is_all = params[3]
    self.getReword = params[4]

    _ED.isReview = true
    self:onInit()
end


