--[[ ----------------------------------------------------------------------------
-- 帐号注销主界面
--]] ----------------------------------------------------------------------------
AccountDeletionWindow = class("AccountDeletionWindowClass", Window)

-- 打开窗口
local account_deletion_window_open_terminal = {
    _name = "account_deletion_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("AccountDeletionWindowClass") then
            fwin:open(AccountDeletionWindow:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local account_deletion_window_close_terminal = {
    _name = "account_deletion_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("AccountDeletionWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(account_deletion_window_open_terminal)
state_machine.add(account_deletion_window_close_terminal)
state_machine.init()

-- 构造器
function AccountDeletionWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    -- var
    self._status_enum = {
        STATUS_NOT_APPLY = 1, -- 申请注销界面
        STATUS_APPLY_SUCCESS = 2, -- 申请注销成功
        STATUS_APPLY_CANCEL = 3, -- 申请撤销
        STATUS_CANCEL_SUCCESS = 4 -- 申请撤销成功
    }
    self._cur_state = 0 -- 当前注销状态	1:申请注销界面 2:申请注销成功 3:申请撤销 4:申请撤销成功
    -- load lua files.

    -- Initialize account deletion window page state machine.
    local function init_account_deletion_window_terminal()
        -- 点击确定操作
        local account_deletion_window_click_ok_terminal = {
            _name = "account_deletion_window_click_ok",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.handleStatus ~= nil then
                    state_machine.lock("account_deletion_window_click_ok")
                    instance:handleStatus()
                    state_machine.unlock("account_deletion_window_click_ok")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(account_deletion_window_click_ok_terminal)
        state_machine.init()
    end
    -- call func init account deletion window state machine.
    init_account_deletion_window_terminal()
end

-- 对象初始化
function AccountDeletionWindow:init(params)
    if nil ~= self.onInit then
        self._cur_state = tonumber(params[1])
        self:onInit(params)
    end
    return self
end

-- 状态处理
function AccountDeletionWindow:handleStatus()
    if self._cur_state == self._status_enum.STATUS_NOT_APPLY then
        if self:checkInputText() then
            self._cur_state = self._status_enum.STATUS_APPLY_SUCCESS
            local currentTime = _ED.system_time + (os.time() - _ED.native_time)
            writeKey("accout_deletion_times", currentTime)
            writeKey("accout_deletion_status", self._cur_state)
            self:refreshPage()
        end
    elseif self._cur_state == self._status_enum.STATUS_APPLY_CANCEL then
        self._cur_state = self._status_enum.STATUS_CANCEL_SUCCESS
        local currentTime = _ED.system_time + (os.time() - _ED.native_time)
        writeKey("accout_deletion_cancel_time", currentTime)
        writeKey("accout_deletion_status", self._cur_state)
        self:refreshPage()
    else
        state_machine.excute("account_deletion_window_close", 0, "")
    end
end

-- 检测输入文本
function AccountDeletionWindow:checkInputText()
    local currName = self.TextField_reason:getString()
    if currName == nil or #currName == 0 then
        TipDlg.drawTextDailog(tipStringInfo_account_deletion[2])
        return false
    end
    -- 长度限制
    local lens = 50
    if string.utf8len(currName) > lens then
        TipDlg.drawTextDailog(tipStringInfo_account_deletion[3])
        return false
    end

    return true
end

-- 切换显示界面
function AccountDeletionWindow:refreshPage()
    for i = 1, 4 do
        self.Panel_tab[i]:setVisible(false)
    end
    self.Panel_tab[self._cur_state]:setVisible(true)

    if self._cur_state == self._status_enum.STATUS_NOT_APPLY then
        draw:addEditBox(self.TextField_reason, "", "effect/effice_1500.png", self.Image_reason, 1000, cc.KEYBOARD_RETURNTYPE_DONE)
    elseif self._cur_state == self._status_enum.STATUS_APPLY_SUCCESS or self._status_enum.STATUS_APPLY_CANCEL then
        local deletTime = readKey("accout_deletion_times")
        if deletTime ~= nil and deletTime ~= "" then
            -- 3天后注销帐号
            local currentTime = _ED.system_time + (os.time() - _ED.native_time)
            local cutHour = math.ceil((24 * 60 * 60 * 3 - math.abs(currentTime - deletTime)) / (60 * 60))
            local strs = ""
            local sender = nil
            if self._cur_state == self._status_enum.STATUS_APPLY_SUCCESS then
                strs = string.format(tipStringInfo_account_deletion[4], cutHour)
                sender = self.Text_delete_tip
            else
                strs = string.format(tipStringInfo_account_deletion[5], cutHour)
                sender = self.Text_cancle_tip
            end
            self:showRichText(sender, strs)
        end
    end
end

-- 富文本文字处理
function AccountDeletionWindow:showRichText(sender, strs)
	sender:setString("")
    sender:removeAllChildren(true)
    local m_str_data = zstring.split(strs, "|")
    m_str_data[2] = "%|5|" .. m_str_data[2] .. "%"
    local m_str = ""
    for i = 1, #m_str_data do
        if i == 1 then
            m_str = m_str_data[i]
        else
            m_str = m_str .. m_str_data[i]
        end
    end
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth = sender:getContentSize().width
    if richTextWidth == 0 then
        richTextWidth = sender:getFontSize() * 6
    end

    _richText2:setContentSize(cc.size(richTextWidth, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    local color_Type_1 = sender:getColor()
    local color_Type_2 = sender:getColor()

    local char_str = m_str
    local rt, count, text = draw.richTextCollectionMethod(_richText2, char_str, color_Type_1, color_Type_2, 0, 0, sender:getFontName(), sender:getFontSize(), tipStringInfo_account_deletion)

    _richText2:formatTextExt()
    local rsize = _richText2:getContentSize()
    _richText2:setPositionY(sender:getContentSize().height)
    _richText2:setPositionX((sender:getContentSize().width - rsize.width) / 2)
    sender:addChild(_richText2)
end

function AccountDeletionWindow:onUpdateDraw()
    local root = self.roots[1]

    -- 界面切换
    self.Panel_tab = {}
    for i = 1, 4 do
        self.Panel_tab[i] = ccui.Helper:seekWidgetByName(root, "Panel_tab_" .. i)
    end

    -- 注销文本输入框
    self.TextField_reason = ccui.Helper:seekWidgetByName(root, "TextField_reason")
	self.TextField_reason:setString("")
    -- 注销文本底图
    self.Image_reason = ccui.Helper:seekWidgetByName(root, "Image_reason")

    -- 成功申请注销文本
    self.Text_delete_tip = ccui.Helper:seekWidgetByName(root, "Text_delete_tip")

    -- 撤销申请文本
    self.Text_cancle_tip = ccui.Helper:seekWidgetByName(root, "Text_cancle_tip")

end

function AccountDeletionWindow:onInit(params)
    local csbNode = csb.createNode("player/account_deletion.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)
    local action = csb.createTimeline("player/account_deletion.csb")
    root:runAction(action)
    action:play("animation_up", false)

    -- 关闭
    self.Button_close =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "account_deletion_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 确定
    self.Button_ok =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_ok"),
        nil,
        {
            terminal_name = "account_deletion_window_click_ok",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self:onUpdateDraw()
    self:refreshPage()
end

function AccountDeletionWindow:onExit()
    -- 释放AccountDeletionWindowWindow界面资源.
    state_machine.remove("account_deletion_window_click_ok")
end

function AccountDeletionWindow:close()
    -- window event : close.
end

function AccountDeletionWindow:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
