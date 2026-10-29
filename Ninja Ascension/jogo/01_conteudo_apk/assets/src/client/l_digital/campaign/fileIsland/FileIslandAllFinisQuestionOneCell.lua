----------------------------------------------------------------------------------------------------
-- 说明:一键探索完成
----------------------------------------------------------------------------------------------------
FileIslandAllFinisQuestionOneCell = class("FileIslandAllFinisQuestionOneCellClass", Window)
FileIslandAllFinisQuestionOneCell.__size = nil

function FileIslandAllFinisQuestionOneCell:ctor()
    self.super:ctor()
    self.roots = {}
    
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinish")
    app.load("client.l_digital.campaign.fileIsland.FileIslandAllFinisQuestionResult")

	local function init_fileIsland_all_finish_question_one_cell_terminal()
		-- -- 点击cell
		local fileIsland_all_finish_window_goto_next_terminal = {
            _name = "fileIsland_all_finish_window_goto_next",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _type = params._datas._type
                local cur_index = tonumber(table.getKeyByValue(instance.ids, instance.id))

                local question_id = _ED.eventIds[instance.id][instance.question_index + _type]
                local id = question_id and instance.id or instance.ids[cur_index + 1]
                local index = question_id and instance.question_index + _type or 1

                if not _ED.isReview and not question_id then
                    local function callback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            local result = FileIslandAllFinisQuestionResult:new()
                            result:init({instance.id, instance.ids, instance.is_all, getSceneReward(7)})
                            fwin:open(result, fwin._ui)
                        end
                    end

                    local data = {}
                    for i,v in ipairs(_ED.eventIds[instance.id]) do
                        data[i] = {}
                        data[i].resultIndex = v.index
                        data[i].answer = _ED.all_answer[i]
                    end
                    local req = json.encode(data)
                    protocol_command.fileIslandAnswer.param_list = req
                    NetworkManager:register(protocol_command.fileIslandAnswer.code, nil, nil, nil, nil, callback, false, nil)
                else
                    state_machine.excute("fileIsland_window_all_finish_update", 0, {(id or 0), index})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fileIsland_all_finish_question_window_close_terminal = {
            _name = "fileIsland_all_finish_question_window_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cur_index = tonumber(table.getKeyByValue(instance.ids, instance.id))
                local id = instance.ids[cur_index + 1]
                state_machine.excute("fileIsland_window_all_finish_update", 0, {(id or 0), 1})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fileIsland_all_finish_window_goto_next_terminal)
        state_machine.add(fileIsland_all_finish_question_window_close_terminal)
        state_machine.init()
	end

	init_fileIsland_all_finish_question_one_cell_terminal()
end

function FileIslandAllFinisQuestionOneCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_explore_all_finish_num = ccui.Helper:seekWidgetByName(root, "Text_explore_all_finish_num")

    local img_1 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0_0_0")
    local img_2 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0")
    local img_3 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0_0")
    local img_4 = ccui.Helper:seekWidgetByName(root, "Image_37_2_0_0_1")
    local imgs = {img_1, img_2, img_3, img_4}
    
    local img_arrow_1 = ccui.Helper:seekWidgetByName(root, "Image_37_2_1")
    local img_arrow_2 = ccui.Helper:seekWidgetByName(root, "Image_37_2_1_0")
    local img_arrow_3 = ccui.Helper:seekWidgetByName(root, "Image_37_2_1_0_0")
    local img_arrows = {img_arrow_1, img_arrow_2, img_arrow_3}
    
    local question_id = _ED.eventIds[self.id][self.question_index].questionId
    local question = dms.string(dms["file_island_question"], question_id, file_island_question.question)
    self.correctAnwser = dms.int(dms["file_island_question"], question_id, file_island_question.rightIndex)
    Text_explore_all_finish_num:setString(question)
    for i = 1, 4 do
        local answer = dms.string(dms["file_island_question"], question_id, (i + 2))
        local Text_explore_answer_choice = ccui.Helper:seekWidgetByName(root, "Text_explore_answer_choice_" .. i)
        Text_explore_answer_choice:setString(answer)
    end

    local paths = {
        {"images/ui/text/TS/sj_gdjl_text_1.png", "images/ui/text/TS/sj_gdjl_text.png"}, 
        [3] = {"images/ui/text/TS/sj_bx_1_1.png", "images/ui/text/TS/sj_bx_1_1_1.png"}, 
        [4] = {"images/ui/text/TS/sj_wh_5_1.png", "images/ui/text/TS/sj_wh_5_1_2.png"}, 
        [5] = {"images/ui/text/TS/sj_gw_2_1.png", "images/ui/text/TS/sj_gw_2_1_1.png"}, 
    }

    for i = 1, 4 do
        local img = imgs[i]
        if i == 1 then
            img:loadTexture(paths[i][1])
        else
            if self.ids[i - 1] then
                local pic_index = (tonumber(self.id) == tonumber(self.ids[i - 1])) and 2 or 1
                img:loadTexture(paths[tonumber(self.ids[i - 1])][pic_index])
                img:setVisible(true)
                img_arrows[i - 1]:setVisible(true)
            else
                img:setVisible(false)
                img_arrows[i - 1]:setVisible(false)
            end
        end
    end

    for i=1, 4 do
        local checkbox  = ccui.Helper:seekWidgetByName(root, "CheckBox_explore_answer_choice_" .. i)
        local Text_explore_answer_choice = ccui.Helper:seekWidgetByName(root, "Text_explore_answer_choice_" .. i)
        checkbox:setTouchEnabled(not _ED.isReview)
        if _ED.isReview and self.correctAnwser == i then
            Text_explore_answer_choice:setColor(cc.c3b(255,0,0))
        else
            Text_explore_answer_choice:setColor(cc.c3b(255,255,255))
        end
    end

    if _ED.all_answer[self.question_index] then
        local checkbox  = ccui.Helper:seekWidgetByName(root, "CheckBox_explore_answer_choice_" .. _ED.all_answer[self.question_index])
        checkbox:setSelected(true)
    end

    if table.nums(_ED.all_answer) > 0 then
        self:btnShow()
    end
    ccui.Helper:seekWidgetByName(root, "Panel_explore_all_finish_jl"):setVisible(self.is_all and table.nums(_ED.all_answer) <= 0)
end

function FileIslandAllFinisQuestionOneCell:updateCheckBox(index, isSelected)
    local root = self.roots[1]
    for i=1,4 do
        local checkbox  = ccui.Helper:seekWidgetByName(root, "CheckBox_explore_answer_choice_" .. i)
        if index == i then
            self.anwsers[i] = isSelected
            checkbox:setTouchEnabled(false)
        else
            self.anwsers[i] = -1
            checkbox:setTouchEnabled(true)
        end
        checkbox:setSelected(self.anwsers[i] == 1)
    end
    
    local isHaveAnwser = false
    for i,v in ipairs(self.anwsers) do
        if v == 1 then
            self.lastAnwser = i
            _ED.all_answer[self.question_index] = i
            isHaveAnwser = true
            break
        end
    end

    self:btnShow()
end

function FileIslandAllFinisQuestionOneCell:btnShow()
    local root = self.roots[1]
    local Button_sure = ccui.Helper:seekWidgetByName(root, "Button_sure")
    local Button_last_question = ccui.Helper:seekWidgetByName(root, "Button_last_question")
    local Button_next_question = ccui.Helper:seekWidgetByName(root, "Button_next_question")
    local Button_close = ccui.Helper:seekWidgetByName(root, "Button_close")

    local last_question = _ED.eventIds[self.id][self.question_index - 1]
    local next_question = _ED.eventIds[self.id][self.question_index + 1]

    Button_sure:setVisible(not next_question and _ED.all_answer[self.question_index] ~= nil)
    Button_last_question:setVisible(not(not last_question))
    Button_next_question:setVisible(not(not next_question) and _ED.all_answer[self.question_index] ~= nil)
    if not last_question and not next_question then
        Button_sure:setPosition(self.default_pos)
    elseif last_question and not next_question then
        local move_posX = (not _ED.all_answer[self.question_index] or _ED.isReview) and 0 or 150
        Button_last_question:setPosition(cc.p(self.default_pos.x - move_posX, self.default_pos.y))
        Button_sure:setPosition(cc.p(self.default_pos.x + move_posX, self.default_pos.y))
    elseif not last_question and next_question then
        Button_next_question:setPosition(self.default_pos)
    else
        local move_posX = (not _ED.all_answer[self.question_index]) and 0 or 150
        Button_last_question:setPosition(cc.p(self.default_pos.x - move_posX, self.default_pos.y))
        Button_next_question:setPosition(cc.p(self.default_pos.x + move_posX, self.default_pos.y))
    end

    if _ED.isReview then
        Button_sure:setVisible(false)
        Button_close:setVisible(true)
    end
    
    ccui.Helper:seekWidgetByName(root, "Panel_explore_all_finish_jl"):setVisible(self.is_all and table.nums(_ED.all_answer) <= 0)
end

function FileIslandAllFinisQuestionOneCell:onInit()
    local csbNode = csb.createNode("campaign/explore/explore_question_1_cell.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    self.anwsers = {-1, -1, -1, -1}
    self.lastAnwser = -1

    --确定答案
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"), nil, 
    {
        terminal_name = "fileIsland_all_finish_window_goto_next",
        _type = 1, 
        isPressedActionEnabled = true
    },
    nil, 0)

    --下一题
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_next_question"), nil, 
    {
        terminal_name = "fileIsland_all_finish_window_goto_next", 
        _type = 1,
        isPressedActionEnabled = true
    },
    nil, 0)

    --上一题
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_last_question"), nil, 
    {
        terminal_name = "fileIsland_all_finish_window_goto_next", 
        _type = -1,
        isPressedActionEnabled = true
    },
    nil, 0)

     --关闭
     fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
     {
         terminal_name = "fileIsland_all_finish_question_window_close", 
         _type = 1,
         isPressedActionEnabled = true
     },
     nil, 0)

    for i=1,4 do
        local function selectedEvent(sender, eventType)
            if eventType == ccui.CheckBoxEventType.selected then
                self:updateCheckBox(sender.index, 1)
            elseif eventType == ccui.CheckBoxEventType.unselected then
                sender:setSelected(true)
                return
            end
        end
        local checkbox  = ccui.Helper:seekWidgetByName(root, "CheckBox_explore_answer_choice_" .. i)
        checkbox.index = i
        checkbox:addEventListener(selectedEvent)
    end

    local Button_sure = ccui.Helper:seekWidgetByName(root, "Button_sure")
    self.default_pos = cc.p(Button_sure:getPosition())
    self:onUpdateDraw()
end

function FileIslandAllFinisQuestionOneCell:clearUIInfo()
    local root = self.roots[1]
    local Button_sure = ccui.Helper:seekWidgetByName(root, "Button_sure")
    local Button_last_question = ccui.Helper:seekWidgetByName(root, "Button_last_question")
    local Button_next_question = ccui.Helper:seekWidgetByName(root, "Button_next_question")

    Button_sure:setPosition(self.default_pos)
    Button_last_question:setPosition(self.default_pos)
    Button_next_question:setPosition(self.default_pos)
end

function FileIslandAllFinisQuestionOneCell:initData()
end

function FileIslandAllFinisQuestionOneCell:init(params)
    self.id = params[1]
    self.ids = params[2]
    self.question_index = params[3]
    self.is_all = params[4] -- true 一键  false 单次

    self.all_nums = table.nums(_ED.eventIds[self.id])
    
    self:onInit()
end

function FileIslandAllFinisQuestionOneCell:onExit()
    self:clearUIInfo()
end

function FileIslandAllFinisQuestionOneCell:createCell()
	local cell = FileIslandAllFinisQuestionOneCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


