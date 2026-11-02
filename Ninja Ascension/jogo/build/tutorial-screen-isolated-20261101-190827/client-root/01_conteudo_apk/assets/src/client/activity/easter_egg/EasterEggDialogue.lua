--[[ ----------------------------------------------------------------------------
-- 彩蛋剧情对话界面
--]] ----------------------------------------------------------------------------
EasterEggDialogue = class("EasterEggDialogueClass", Window)

-- 打开窗口
local easter_egg_dialogue_window_open_terminal = {
    _name = "easter_egg_dialogue_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("EasterEggDialogueClass") then
            fwin:open(EasterEggDialogue:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local easter_egg_dialogue_window_close_terminal = {
    _name = "easter_egg_dialogue_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EasterEggDialogueClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(easter_egg_dialogue_window_open_terminal)
state_machine.add(easter_egg_dialogue_window_close_terminal)
state_machine.init()

-- 构造器
function EasterEggDialogue:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._egg_info = {} -- 彩蛋信息
    self._talk_list = {} -- 对话列表
    self._talk_idx = 1 -- 当前对话
    self._callBack = nil -- 领取奖励回调
    -- load lua files.

    -- Initialize easter egg dialogue page state machine.
    local function init_easter_egg_dialogue_terminal()
        -- 打开角色创建窗口
        local easter_egg_dialogue_open_terminal = {
            _name = "easter_egg_dialogue_open",
            _init = function(terminal)
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

        -- 关闭角色创建窗口
        local easter_egg_dialogue_close_terminal = {
            _name = "easter_egg_dialogue_close",
            _init = function(terminal)
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

        -- 显示窗口
        local easter_egg_dialogue_show_terminal = {
            _name = "easter_egg_dialogue_show",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 显示窗口
                if nil ~= instance then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏窗口
        local easter_egg_dialogue_hide_terminal = {
            _name = "easter_egg_dialogue_hide",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 隐藏窗口
                if nil ~= instance then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 下一对话
        local easter_egg_dialogue_click_next_terminal = {
            _name = "easter_egg_dialogue_click_next",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    state_machine.lock("easter_egg_dialogue_click_next", 0, nil)
                    instance:handleNextTalk()
                    state_machine.unlock("easter_egg_dialogue_click_next")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(easter_egg_dialogue_open_terminal)
        state_machine.add(easter_egg_dialogue_close_terminal)
        state_machine.add(easter_egg_dialogue_show_terminal)
		state_machine.add(easter_egg_dialogue_hide_terminal)
		state_machine.add(easter_egg_dialogue_click_next_terminal)
        state_machine.init()
    end
    -- call func init easter egg dialogue state machine.
    init_easter_egg_dialogue_terminal()
end

-- 对象初始化
function EasterEggDialogue:init(params)
    self._egg_info = params.eggInfo
    self._callBack = params.callback
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function EasterEggDialogue:onHandleData()
    self._talk_list = {}
    local talkConfig = zstring.splits(self._egg_info[easter_egg_mould.talk], "|", ",")
    for i, v in ipairs(talkConfig) do
        local temp = {
            headId = v[1],
            pos = tonumber(v[2]),
            decrip = dms.element(dms["word_mould"], v[3])[3],
            title = dms.element(dms["word_mould"], v[4])[3]
        }
        table.insert(self._talk_list, temp)
    end
end

function EasterEggDialogue:onUpdateDraw()
    local root = self.roots[1]
    local talkInfo = self._talk_list[self._talk_idx]

    -- 左边的对话
    local Panel_dialogue_1 = ccui.Helper:seekWidgetByName(root, "Panel_dialogue_1")
    -- 右边的对话
    local Panel_dialogue_2 = ccui.Helper:seekWidgetByName(root, "Panel_dialogue_2")
    local Panel_role = nil
    local Text_talk = nil
    local Text_name = nil
    if talkInfo.pos == 1 then
        Panel_dialogue_1:setVisible(true)
        Panel_dialogue_2:setVisible(false)
        self.actions[1]:play("open_right", false)
        Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role_1")
        Text_talk = ccui.Helper:seekWidgetByName(root, "Text_talk_1")
        Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_1")
    else
        Panel_dialogue_1:setVisible(false)
        Panel_dialogue_2:setVisible(true)
        self.actions[1]:play("open_left", false)
        Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role_2")
        Text_talk = ccui.Helper:seekWidgetByName(root, "Text_talk_2")
        Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_2")
    end

    -- 头像路径
    local imageleft = string.format("images/face/big_head/big_head_%s.png", talkInfo.headId)
    Panel_role:removeBackGroundImage()
    Panel_role:setBackGroundImage(imageleft)

    -- 对话文本
    Text_talk:setString(talkInfo.decrip)

    -- 标题
    Text_name:setString(talkInfo.title)
end

function EasterEggDialogue:handleNextTalk()
	local nextId = self._talk_idx + 1 
	if nextId > #self._talk_list then 
		-- 领奖
		self._callBack()
		state_machine.excute("easter_egg_dialogue_window_close",0,"")
	else
		self._talk_idx = nextId
		self:onUpdateDraw()
	end
end

function EasterEggDialogue:onInit()
    -- 加载EasterEggDialogueWindow界面资源.
    -- easter_egg/easter_egg_dialogue = easter_egg/easter_egg_dialogue.csb
    local csbNode = csb.createNode("activity/easter_egg/easter_egg_dialogue.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    local action = csb.createTimeline("activity/easter_egg/easter_egg_dialogue.csb")
    table.insert(self.actions, action)
    csbNode:runAction(action)

    -- 全屏的点击层
    self.Panel_dialog =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Panel_dialog"),
        nil,
        {
            terminal_name = "easter_egg_dialogue_click_next",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self:onHandleData()
    self:onUpdateDraw()
end

function EasterEggDialogue:onExit()
    -- 释放EasterEggDialogueWindow界面资源.
    state_machine.remove("easter_egg_dialogue_open")
    state_machine.remove("easter_egg_dialogue_close")
    state_machine.remove("easter_egg_dialogue_show")
	state_machine.remove("easter_egg_dialogue_hide")
	state_machine.remove("easter_egg_dialogue_click_next")
end

function EasterEggDialogue:close()
    -- window event : close.
end

function EasterEggDialogue:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
