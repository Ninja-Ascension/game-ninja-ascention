--[[ ----------------------------------------------------------------------------
-- 彩蛋界面
--]] ----------------------------------------------------------------------------
EasterEggWindow = class("EasterEggWindowClass", Window)
EasterEggWindow.__size = nil

-- 打开窗口
local easter_egg_window_open_terminal = {
    _name = "easter_egg_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if EasterEggWindow then
            local cell = EasterEggWindow:new()
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

state_machine.add(easter_egg_window_open_terminal)
state_machine.init()

-- 构造器
function EasterEggWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._egg_info = nil -- 当前彩蛋模版信息

    -- load lua files.
    app.load("client.activity.easter_egg.EasterEggDialogue")
    -- Initialize easter egg window page state machine.
    local function init_easter_egg_window_terminal()
        -- 点击彩蛋
        local easter_egg_window_click_terminal = {
            _name = "easter_egg_window_click",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params and params._datas then
                    local mObj = params._datas.m_obj
                    if _ED.active_activity[191] == nil then 
                        -- 活动已结束
                        mObj:removeFromParent(true)
                        TipDlg.drawTextDailog(tipStringInfo_easter_egg_tips[3])
                        return 
                    end
                    state_machine.lock("easter_egg_window_click", 0, "")
                    local mInfo = params._datas.m_info
                    local eveType = tonumber(mInfo[easter_egg_mould.type])
                    local eveId = mInfo[easter_egg_mould.ID]
                    local function getReward()
                        EasterEggHandle.showEasterEggReward(
                            eveId,
                            function()
                                -- 彩蛋消失
                                mObj:onEggDisappear()
                            end
                        )
                    end
                    if eveType == 1 then
                        -- 点击事件
                        getReward()
                    elseif eveType == 2 then
                        -- 线性事件
                        state_machine.excute("easter_egg_dialogue_window_open", 0, {eggInfo = mInfo, callback = getReward})
                    end
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(easter_egg_window_click_terminal)
        state_machine.init()
    end
    -- call func init easter egg window state machine.
    init_easter_egg_window_terminal()
end

-- 对象初始化
function EasterEggWindow:init(params)
    self._egg_info = params.eggInfo
    if nil ~= self.onInit then
        self:onInit(params)
    end
    self:setContentSize(EasterEggWindow.__size)
    return self
end

function EasterEggWindow:onUpdateDraw()
    local root = self.roots[1]
    -- 位置
    local pos = zstring.split(self._egg_info[easter_egg_mould.pos], ",")
    local aim = cc.p(tonumber(pos[1])-(app.baseOffsetX/2), tonumber(pos[2]))
    root:setPosition(aim)

    local Panel_type = ccui.Helper:seekWidgetByName(root, "Panel_type")
    local Image_tip = ccui.Helper:seekWidgetByName(root, "Image_tip")
    Image_tip:setVisible(false)
    local eveType = tonumber(self._egg_info[easter_egg_mould.type])
    if eveType == 5 then
        -- cd事件,不显示彩蛋,只显示气泡提示
        Panel_type:setVisible(false)
        local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
        Text_tip:setString(tipStringInfo_easter_egg_tips[2])
        self:runAction(
            cc.RepeatForever:create(
                cc.Sequence:create(
                    cc.CallFunc:create(
                        function(sender)
                            self.actions[1]:play("open", false)
                            Image_tip:setVisible(true)
                        end
                    ),
                    cc.DelayTime:create(5),
                    cc.CallFunc:create(
                        function(sender)
                            Image_tip:setVisible(false)
                        end
                    ),
                    cc.DelayTime:create(2)
                )
            )
        )
    else
        Panel_type:setVisible(true)
        -- 彩蛋图案
        local imageType = self._egg_info[easter_egg_mould.imageId]
        Panel_type:removeBackGroundImage()
        Panel_type:setBackGroundImage(string.format("image/activity/easter_egg/easter_egg_icon_%s.png", imageType))

        -- 彩蛋背景特效
        local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
        Panel_effect:removeAllChildren(true)
        local jsonFile = "images/ui/effice/effice_egg_light/effice_egg_light.json"
        local atlasFile = "images/ui/effice/effice_egg_light/effice_egg_light.atlas"
        local spNode = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_effect:addChild(spNode)
    end
end

function EasterEggWindow:onEggDisappear()
    local root = self.roots[1]
    
    local function disappearCallback()
        local Panel_type = ccui.Helper:seekWidgetByName(root, "Panel_type")
        Panel_type:setVisible(false)
        local imageType = self._egg_info[easter_egg_mould.imageId]
        local aniPath = string.format("images/ui/effice/effice_egg_%s/effice_egg_%s", imageType,imageType)
        local Panel_disappear = ccui.Helper:seekWidgetByName(root, "Panel_disappear")
        Panel_disappear:removeAllChildren(true)
        local jsonFile = aniPath .. ".json"
        local atlasFile = aniPath .. ".atlas"
        local spNode = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        spNode:setAnimation(0, "animation", false)
        Panel_disappear:addChild(spNode)
        spNode:registerSpineEventHandler(
            function(event)
                state_machine.unlock("easter_egg_window_click")
                spNode:removeFromParent(true)
                if self:getParent() and self:getParent().homeEgg ~= nil then 
                    self:getParent().homeEgg = nil
                end
                self:removeFromParent(true)
            end,
            sp.EventType.ANIMATION_COMPLETE
        )
    end

    local eveType = tonumber(self._egg_info[easter_egg_mould.type])
    if eveType == 2 then
        -- 线性事件提示下一线索
        local descripId = self._egg_info[easter_egg_mould.pop]
        if tonumber(descripId) ~= -1 then 
            local popTxt = dms.element(dms["word_mould"], descripId)[3]
            local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
            Text_tip:setString(popTxt)
            local Image_tip = ccui.Helper:seekWidgetByName(root, "Image_tip")
            Image_tip:setVisible(true)

            self.actions[1]:play("open", false)
            local seq =
                cc.Sequence:create(
                cc.DelayTime:create(2),
                cc.CallFunc:create(
                    function(sender)
                        disappearCallback()
                    end
                )
            )
            self:runAction(seq)
        else
            disappearCallback()
        end
    else
        disappearCallback()
    end
end

function EasterEggWindow:onInit(params)
    -- 加载EasterEggWindowWindow界面资源.
    -- easter_egg/easter_egg = easter_egg/easter_egg.csb
    -- [[ 使用缓存创建
    local root = cacher.createUIRef("activity/easter_egg/easter_egg.csb", "root")
    -- ]]
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    self:clearUIInfo()
    if EasterEggWindow.__size == nil then
        EasterEggWindow.__size = root:getContentSize()
    end

    local action = csb.createTimeline("activity/easter_egg/easter_egg.csb")
    table.insert(self.actions, action)
    root:runAction(action)
    -- 领奖按钮
    self.Panel_type =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Panel_type"),
        nil,
        {
            terminal_name = "easter_egg_window_click",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_info = self._egg_info,
            m_obj = self
        },
        nil,
        0
    )

    self:onUpdateDraw()
end

function EasterEggWindow:onExit()
    self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/easter_egg/easter_egg.csb", root)
	-- ]]
end

function EasterEggWindow:clearUIInfo()
	local root = self.roots[1]
	if root == nil then
        return
    end
end

function EasterEggWindow:close()
    -- window event : close.
end

function EasterEggWindow:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
