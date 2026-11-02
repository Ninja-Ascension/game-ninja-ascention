--[[ ----------------------------------------------------------------------------
-- 幸运转盘累计獎勵
--]] ----------------------------------------------------------------------------
ChristmasRomanceItem = class("ChristmasRomanceItemClass", Window)
ChristmasRomanceItem.__size = nil

-- 创建Cell实例
local christmas_romance_item_create_terminal = {
    _name = "christmas_romance_item_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if ChristmasRomanceItem then
            local cell = ChristmasRomanceItem:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(christmas_romance_item_create_terminal)
state_machine.init()

-- 构造器
function ChristmasRomanceItem:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._rewardData = nil
    self._type = nil
    -- load lua files.

    -- Initialize christmas romance item page state machine.
    local function init_christmas_romance_item_terminal()
        -- 领取宝箱奖励
        local christmas_romance_item_click_box_terminal = {
            _name = "christmas_romance_item_click_box",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("christmas_romance_item_click_box")
                if params then
                    local mCell = params._datas.m_cell
                    local info = mCell._rewardData
                    local type = mCell._type
                    if tonumber(info.state) == 1 then
                        state_machine.excute("christmas_romance_turntable_get_box_reward", 0, {type, info})
                    elseif tonumber(info.state) == 0 or tonumber(info.state) == 2 then
                        state_machine.excute("christmas_romance_box_window_open", 0, {type, info})
                    end
                    state_machine.unlock("christmas_romance_item_click_box")
                end
                state_machine.unlock("christmas_romance_item_click_box")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(christmas_romance_item_click_box_terminal)
        state_machine.init()
    end
    -- call func init christmas romance item state machine.
    init_christmas_romance_item_terminal()
end

-- 对象初始化
function ChristmasRomanceItem:init(params)
    self._type = params[1]
    self._rewardData = params[2]
    self:onInit(params)
    self:setContentSize(ChristmasRomanceItem.__size)
    return self
end

function ChristmasRomanceItem:onUpdateDraw()
    local root = self.roots[1]

    -- 道具icon容器
    self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")

    -- 道具名称
    self.Text_Prop_cishu = ccui.Helper:seekWidgetByName(root, "Text_Prop_cishu")
    self.Text_Prop_cishu:setString(self._rewardData.aim)

    -- 钻石宝箱
    self.Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
    self.Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
    self.Image_1:setVisible(false)
    self.Image_2:setVisible(false)
    -- 幸运宝箱
    self.Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
    self.Image_4 = ccui.Helper:seekWidgetByName(root, "Image_4")
    self.Image_3:setVisible(false)
    self.Image_4:setVisible(false)

    local Panel_effect1 = ccui.Helper:seekWidgetByName(root, "Panel_effect1")
    Panel_effect1:setVisible(false)
    local Panel_effect2 = ccui.Helper:seekWidgetByName(root, "Panel_effect2")
    Panel_effect2:setVisible(false)

    -- self.Button_choice:setTouchEnabled(true)
    if tonumber(self._rewardData.state) == 0 then
        -- 未达成
        if self._type == 1 then
            self.Image_1:setVisible(true)
        else
            self.Image_3:setVisible(true)
        end
    elseif tonumber(self._rewardData.state) == 1 then
        -- 达成
        local path = ""
        local panelAni = nil
        if self._type == 1 then
            panelAni = Panel_effect1
            path = "images/ui/effice/christmas_romance_box1/christmas_romance_box1"
        else
            panelAni = Panel_effect2
            path = "images/ui/effice/christmas_romance_box2/christmas_romance_box2"
        end
        panelAni:setVisible(true)
        self:playAnimations(panelAni, path, true)
    elseif tonumber(self._rewardData.state) == 2 then
        -- 已领取
        -- self.Button_choice:setTouchEnabled(false)
        if self._type == 1 then
            self.Image_2:setVisible(true)
        else
            self.Image_4:setVisible(true)
        end
    end
end

function ChristmasRomanceItem:playAnimations(sender, file, loop)
    sender:removeAllChildren()
    local jsonFile = file .. ".json"
    local atlasFile = file .. ".atlas"
    local aniName = "animation"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, loop, nil)
    animation:setPosition(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
    sender:addChild(animation)
end

function ChristmasRomanceItem:onEnterTransitionFinish()
end

function ChristmasRomanceItem:onInit(params)
    -- 加载ChristmasRomanceItemWindow界面资源.
    -- res.cultivate.Mythical_animals.christmas_romance_item = res/activity/christmas_romance/christmas_romance_item.csb
    --[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/christmas_romance/christmas_romance_item.csb")
	local root = csbNode:getChildByName("root")
	--]]
    -- [[ 使用缓存创建
    local root = cacher.createUIRef("activity/christmas_romance/christmas_romance_item.csb", "root")
    -- ]]
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if ChristmasRomanceItem.__size == nil then
        ChristmasRomanceItem.__size = root:getContentSize()
    end
    self:clearUIInfo()
    -- 交互层
    self.Button_choice =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_choice"),
        nil,
        {
            terminal_name = "christmas_romance_item_click_box",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_cell = self
        },
        nil,
        0
    )

    self:onUpdateDraw()
end

function ChristmasRomanceItem:onExit()
    -- 释放ChristmasRomanceItemWindow界面资源.

    -- [[ 释放缓存
    self:clearUIInfo()
    local root = self.roots[1]
    cacher.freeRef("activity/christmas_romance/christmas_romance_item.csb", root)
    -- ]]
end

function ChristmasRomanceItem:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ChristmasRomanceItem:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("activity/christmas_romance/christmas_romance_item.csb", root)

    self.roots = {}
end

function ChristmasRomanceItem:clearUIInfo(...)
    local root = self.roots[1]
    if root == nil then
        return
    end

    -- 道具名称
    local  Text_Prop_cishu = ccui.Helper:seekWidgetByName(root, "Text_Prop_cishu")
    Text_Prop_cishu:setString("")
    -- 钻石宝箱
    local  Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
    local  Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
    Image_1:setVisible(false)
    Image_2:setVisible(false)
    -- 幸运宝箱
    local  Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
    local  Image_4 = ccui.Helper:seekWidgetByName(root, "Image_4")
    Image_3:setVisible(false)
    Image_4:setVisible(false)

    local Panel_effect1 = ccui.Helper:seekWidgetByName(root, "Panel_effect1")
    Panel_effect1:removeAllChildren(true)
    local Panel_effect2 = ccui.Helper:seekWidgetByName(root, "Panel_effect2")
    Panel_effect2:removeAllChildren(true)
end

-- ~END
-- ----------------------------------------------------------------------------
