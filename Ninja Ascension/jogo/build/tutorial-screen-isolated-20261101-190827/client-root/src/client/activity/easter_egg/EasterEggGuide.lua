--[[ ----------------------------------------------------------------------------
-- 主城轮播界面
--]] ----------------------------------------------------------------------------
EasterEggGuide = class("EasterEggGuideClass", Window)

-- 打开窗口
local easter_egg_guide_window_open_terminal = {
    _name = "easter_egg_guide_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if EasterEggGuide then
			local cell = EasterEggGuide:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
        	cell:registerOnNoteUpdate(cell)
			return cell
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(easter_egg_guide_window_open_terminal)
state_machine.init()

-- 构造器
function EasterEggGuide:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._show_list = {} -- 当前轮播列表
    self._show_idx = 1 -- 当前下标
    self._cur_day = 0 -- 当前天数
    self._record_time = nil
    -- load lua files.

    -- Initialize easter egg guide page state machine.
    local function init_easter_egg_guide_terminal()
        -- 打开角色创建窗口
        local easter_egg_guide_open_terminal = {
            _name = "easter_egg_guide_open",
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
        local easter_egg_guide_close_terminal = {
            _name = "easter_egg_guide_close",
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
        local easter_egg_guide_show_terminal = {
            _name = "easter_egg_guide_show",
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
        local easter_egg_guide_hide_terminal = {
            _name = "easter_egg_guide_hide",
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
		
		-- 轮播内容刷新
        local easter_egg_guide_play_refrush_terminal = {
            _name = "easter_egg_guide_play_refrush",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance and instance.onRefrush then
                    instance:onRefrush()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭轮播界面
        local easter_egg_guide_close_refrush_terminal = {
            _name = "easter_egg_guide_close_refrush",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance and instance.onDisappear then
                    instance:onDisappear()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        

        state_machine.add(easter_egg_guide_open_terminal)
        state_machine.add(easter_egg_guide_close_terminal)
        state_machine.add(easter_egg_guide_show_terminal)
		state_machine.add(easter_egg_guide_hide_terminal)
        state_machine.add(easter_egg_guide_play_refrush_terminal)
        state_machine.add(easter_egg_guide_close_refrush_terminal)
        state_machine.init()
    end
    -- call func init easter egg guide state machine.
    init_easter_egg_guide_terminal()
end

-- 对象初始化
function EasterEggGuide:init(params)
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function EasterEggGuide:onHandleData()
    self._cur_day = EasterEggHandle.getEasterEggDays()
    self._record_time = 0
    local showData = zstring.split(dms.string(dms["activity_config"], 124, activity_config.param), "|")
    local showList = {} -- 配置的轮播列表
    for i, v in ipairs(showData) do
        if i <= self._cur_day then
            local info = zstring.split(v, ",")
            for k, val in ipairs(info) do
                table.insert(showList, val)
            end
        end
    end
    -- 活动事件完成信息
    local activityInfo = _ED.active_activity[191].activity_info

    self._show_list = {}
    -- 删除已完成事件
    for i, v in ipairs(showList) do
        local haveGet = tonumber(activityInfo["" .. v].haveGet)
        local eggInfo = dms.searchs(dms["easter_event_mould"], easter_egg_mould.ID, v)[1]
        local maxGet = tonumber(eggInfo[easter_egg_mould.limit])
        local txtId = eggInfo[easter_egg_mould.mTxt]
        if tonumber(txtId) ~= -1 and haveGet < maxGet then
            local condition = tonumber(zstring.split(eggInfo[easter_egg_mould.link], ",")[1])
            local showGuide = true
            if condition ~= -1 then
                showGuide = tonumber(activityInfo["" .. condition].haveGet) > 0
            end
            if showGuide then
                local wordInfo = dms.element(dms["word_mould"], txtId)
                local word = wordInfo[3]
                table.insert(self._show_list, word)
            end
        end
    end
end

-- 刷新轮播内容
function EasterEggGuide:onRefrush()
	self:onHandleData()
	if #self._show_list > 0 then 
		self._show_idx = 1
		self:onUpdateDraw()
	else
		-- 全部完成
		self:onDisappear()
	end
end

function EasterEggGuide:onUpdateDraw()
    local root = self.roots[1]
    -- 轮播窗文本控件
	self.Text_turn = ccui.Helper:seekWidgetByName(root, "Text_turn")
    self:showNextTitle()
    self.actions[1]:play("open", true)
    self.actions[1]:setFrameEventCallFunc(
        function(frame)
            if nil == frame then
                return
            end

            local str = frame:getEvent()
            if str == "over" then
                if self._start_move then
                    self:showNextTitle()
                end
            end
        end
    )
    self._start_move = true
    -- 迪路兽出现
    state_machine.excute("home_easter_egg_role_animation_change", 0, {type = 1})
end

-- 显示下一个文本
function EasterEggGuide:showNextTitle()
    self._show_idx = self._show_idx + 1 > #self._show_list and 1 or self._show_idx + 1
    self.Text_turn:setString(self._show_list[self._show_idx])
end


-- 迪路兽消失动画
function EasterEggGuide:onDisappear()
    state_machine.excute("home_easter_egg_role_animation_change", 0, {type = 2})
    if self:getParent() and self:getParent().guideCell ~= nil then 
        self:getParent().guideCell = nil
    end
    self:removeFromParent(true)
end

function EasterEggGuide:onUpdate(dt)
    if self._record_time ~= nil then
        self._record_time = self._record_time + dt 
        if  self._record_time >= 1 then
            self._record_time = 0
           local curDay = EasterEggHandle.getEasterEggDays()
            if self._cur_day ~= curDay then
                self._cur_day = curDay
                self:onRefrush()
            end
        end
    end
end

function EasterEggGuide:onInit()
    -- 加载EasterEggGuideWindow界面资源.
    -- easter_egg/easter_egg_guide = easter_egg/easter_egg_guide.csb
    local csbNode = csb.createNode("activity/easter_egg/easter_egg_guide.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("activity/easter_egg/easter_egg_guide.csb")
    table.insert(self.actions, action)
	csbNode:runAction(action)

    self:addChild(csbNode)
    self:onHandleData()
    self:onUpdateDraw()
end

function EasterEggGuide:onExit()
    -- 释放EasterEggGuideWindow界面资源.
    state_machine.remove("easter_egg_guide_open")
    state_machine.remove("easter_egg_guide_close")
    state_machine.remove("easter_egg_guide_show")
    state_machine.remove("easter_egg_guide_hide")
    state_machine.remove("easter_egg_guide_play_refrush")
    state_machine.remove("easter_egg_guide_close_refrush")
end

function EasterEggGuide:close()
    -- window event : close.
end

function EasterEggGuide:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
