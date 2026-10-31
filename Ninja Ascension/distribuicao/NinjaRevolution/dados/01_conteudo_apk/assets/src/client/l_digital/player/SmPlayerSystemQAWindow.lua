-- ----------------------------------------------------------------------------------------------------
-- 客服留言功能
-------------------------------------------------------------------------------------------------------
SmPlayerSystemQAWindow = class("SmPlayerSystemQAWindowClass", Window)
local sm_player_system_qa_window_open_terminal = {
    _name = "sm_player_system_qa_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _window = fwin:find("SmPlayerSystemQAWindowClass")
        if _window == nil then
            fwin:open(SmPlayerSystemQAWindow:new(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_player_system_qa_window_open_terminal)
state_machine.init()

function SmPlayerSystemQAWindow:ctor()
    self.super:ctor()
    self.actions = {}
    self.roots = {}

    self.infos = {}
    self.curBtn = 0

    app.load("client.l_digital.cells.player.gm_message_question_right_cell")
    app.load("client.l_digital.cells.player.gm_message_question_left_cell")

    local function init_sm_player_system_qa_window_terminal()
        --关闭
        local sm_player_system_qa_window_close_terminal = {
            _name = "sm_player_system_qa_window_close",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击问题条目按钮
        local sm_player_system_qa_message_btn_page_terminal = {
            _name = "sm_player_system_qa_message_btn_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance and params and params._datas then
                    local mType = params._datas.m_type
                    instance:onDarwBtn(mType)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --web
        local sm_player_system_qa_message_open_web_terminal = {
            _name = "sm_player_system_qa_message_open_web",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                handlePlatformRequest(0, CC_OPEN_URL, tipStringInfo_customer_service_tips[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_player_system_qa_window_close_terminal)
        state_machine.add(sm_player_system_qa_message_btn_page_terminal)
        state_machine.add(sm_player_system_qa_message_open_web_terminal)
        state_machine.init()
    end

    init_sm_player_system_qa_window_terminal()
end

function SmPlayerSystemQAWindow:onUpdataDraw()
    self.infos = {}
    local typeTotal = {}
    for i = 1, dms.count(dms["faq_mould"]) do
        local elementShip = dms.element(dms["faq_mould"], i)
        local curType = dms.atoi(elementShip, player_system_faq_mould.question_type)
        typeTotal[curType] = curType
    end

    for i = 1, #typeTotal do
        local qaDatas = {}
        local rows = dms.searchs(dms["faq_mould"], player_system_faq_mould.question_type, typeTotal[i])
        qaDatas.type = tonumber(typeTotal[i])
        qaDatas.typeName = tonumber(rows[1][3])
        qaDatas.content = {}
        for i = 1, #rows do
            local tempContent = {}
            tempContent.id = tonumber(rows[i][1])
            tempContent.type = tonumber(rows[i][2])
            tempContent.typeName = tonumber(rows[i][3])
            tempContent.qustName = tonumber(rows[i][4])
            tempContent.aswName = tonumber(rows[i][5])
            table.insert(qaDatas.content, tempContent)
        end
        table.insert(self.infos, qaDatas)
    end
    self:onDarwBtn(1)
end

function SmPlayerSystemQAWindow:onDarwBtn(btnType)
    if self.curBtn == btnType then
        return
    end
    self.curBtn = btnType

    local root = self.roots[1]
    local mListview = self.ListView_questionTag
    mListview:removeAllItems()

    for i, v in ipairs(self.infos) do
        local cell = GmMessageQuestionLeftCell:createCell()
        cell:init({mInfos = v, mSelect = btnType})
        mListview:addChild(cell)
    end

    self:onDarwText(btnType)
    mListview:requestRefreshView()
end

function SmPlayerSystemQAWindow:onDarwText(btnType)
    local root = self.roots[1]
    local mListview = self.ListView_message
    mListview:removeAllItems()
    local idx = 1
    for i = 1, #self.infos do
        local val = self.infos[i]
        if btnType == val.type then
            for j = 1, #val.content do
                -- 问
                local cell = GmMessageQuestionRightCell:createCell()
                cell:init({mInfos = val.content[j], qaType = 4})
                mListview:addChild(cell)
                -- 答
                local cell = GmMessageQuestionRightCell:createCell()
                cell:init({mInfos = val.content[j], qaType = 5})
                mListview:addChild(cell)
            end
        end
    end

    mListview:jumpToTop()
    mListview:requestRefreshView()
end

function SmPlayerSystemQAWindow:onEnterTransitionFinish()
    local csbUserInfo = csb.createNode("player/role_information_gm_message.csb")
    self:addChild(csbUserInfo)
    local root = csbUserInfo:getChildByName("root")
    table.insert(self.roots, root)
    --关闭
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_message_closed"),
        nil,
        {
            terminal_name = "sm_player_system_qa_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    local Button_go_web = ccui.Helper:seekWidgetByName(root, "Button_go_web")
    if Button_go_web then
        -- 跳转web
        fwin:addTouchEventListener(
            Button_go_web,
            nil,
            {
                terminal_name = "sm_player_system_qa_message_open_web",
                terminal_state = 0,
                isPressedActionEnabled = true
            },
            nil,
            0
        )
    end

    self.ListView_questionTag = ccui.Helper:seekWidgetByName(root, "ListView_questionTag")
    self.ListView_message = ccui.Helper:seekWidgetByName(root, "ListView_message")

    self:onUpdataDraw()
end

function SmPlayerSystemQAWindow:onExit()
    state_machine.remove("sm_player_system_qa_window_close")
    state_machine.remove("sm_player_system_qa_message_open_web")
    state_machine.remove("sm_player_system_qa_message_btn_page")
end
