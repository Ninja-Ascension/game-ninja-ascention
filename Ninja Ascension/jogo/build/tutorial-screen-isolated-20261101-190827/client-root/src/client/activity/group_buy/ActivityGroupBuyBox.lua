ActivityGroupBuyBox = class("ActivityGroupBuyBoxClass", Window)
ActivityGroupBuyBox.__size = nil

-- 创建Cell实例
local activity_group_buy_box_create_terminal = {
    _name = "activity_group_buy_box_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if ActivityGroupBuyBox then
            local cell = ActivityGroupBuyBox:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_group_buy_box_create_terminal)
state_machine.init()

-- 构造器
function ActivityGroupBuyBox:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    ------------------------------------------------------------------------ var------------------------------------------------------------------------

    ------------------------------------------------------------------ load lua files-------------------------------------------------------------------

    ------------------------------------------------- Initialize summer drink cell page state machine---------------------------------------------------
    local function init_activity_group_buy_box_terminal()
        -- 购买按钮
        local activity_group_buy_box_onclick_buy_gift_terminal = {
            _name = "activity_group_buy_box_onclick_buy_gift",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params._datas._self.box_reward_state == 1 then
                    local function call_back_1(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("activity_group_buy_refresh_all", 0, "")

                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(7)
                            fwin:open(getRewardWnd, fwin._ui)
                        end
                    end

                    protocol_command.activity_group_buy_get_reward.param_list = "0" .. "\r\n" .. params._datas._self.cell_index .. "\r\n" .. params._datas.__box_index
                    NetworkManager:register(protocol_command.activity_group_buy_get_reward.code, nil, nil, nil, params._datas._self, call_back_1, false, nil)
                else
                    app.load("client.activity.group_buy.ActivityGroupBuyPopUp")
                    state_machine.excute("activity_group_buy_pop_up_open", 0, params._datas._self.reward)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_group_buy_box_onclick_buy_gift_terminal)
    end

    ------------------------------------------------- call func init user return window state machine---------------------------------------------------
    init_activity_group_buy_box_terminal()
end

-- 对象初始化
function ActivityGroupBuyBox:init(_data)
    if _data ~= nil then
        self.posX = _data.posX
        self.cell_index = _data.cell_index
        self.box_index = _data.box_index
        self.box_reward_state = tonumber(_data.box_reward_state)
        self.reward = _data.reward
    end

    self:onInit()
    self:setContentSize(ActivityGroupBuyBox.__size)

    return self
end

function ActivityGroupBuyBox:onInit()
    -- res.duplicate.pve_super_mopping_cell = duplicate/pve_super_mopping_cell.csb
    --[[ 不使用缓存创建
	local csbNode = csb.createNode("duplicate/pve_super_mopping_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
    -- [[ 使用缓存创建
    local root = cacher.createUIRef("activity/group_buy/group_buy_box.csb", "root")
    -- ]]
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if ActivityGroupBuyBox.__size == nil then
        ActivityGroupBuyBox.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function ActivityGroupBuyBox:onUpdateDraw()
    local root = self.roots[1]

    -- 坐标位置
    root:setPositionX(0)
    root:setPositionX(self.posX)

    -- 按钮绑定
    self.Image_box = ccui.Helper:seekWidgetByName(root, "Image_box")

    -- 光效
    local jsonFile = "images/ui/effice/effect_chaozhituangou/effect_chaozhituangou.json"
    local atlasFile = "images/ui/effice/effect_chaozhituangou/effect_chaozhituangou.atlas"
    self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
    self.Panel_effect:removeAllChildren(true)
    local spine_node = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    spine_node:setPosition(cc.p(self.Panel_effect:getContentSize().width / 2, self.Panel_effect:getContentSize().height / 2))
    spine_node:setAnchorPoint(cc.p(0.5, 0.5))
    self.Panel_effect:addChild(spine_node)
    self.Panel_effect:setVisible(self.box_reward_state == 1)
    self.Image_box:setVisible(self.box_reward_state ~= 1)

    -- 换图
    if self.box_reward_state == 0 then
        self.Image_box:loadTexture("images/ui/text/sm_hd/group_buy/group_buy_box.png")
    elseif self.box_reward_state == 2 then
        self.Image_box:loadTexture("images/ui/text/sm_hd/group_buy/group_buy_box_0.png")
    end

    -- 宝箱
    fwin:addTouchEventListener(
        self.Image_box,
        nil,
        {
            terminal_name = "activity_group_buy_box_onclick_buy_gift",
            terminal_state = 0,
            isPressedActionEnabled = true,
            __box_index = self.box_index,
            _self = self
        },
        nil,
        0
    )

    -- 宝箱
    fwin:addTouchEventListener(
        self.Panel_effect,
        nil,
        {
            terminal_name = "activity_group_buy_box_onclick_buy_gift",
            terminal_state = 0,
            isPressedActionEnabled = true,
            __box_index = self.box_index,
            _self = self
        },
        nil,
        0
    )
end

function ActivityGroupBuyBox:createCell()
    local cell = ActivityGroupBuyBox:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function ActivityGroupBuyBox:onEnterTransitionFinish()
end

function ActivityGroupBuyBox:onExit()
    -- 释放ActivityGroupBuyCell界面资源.
    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("activity/group_buy/group_buy_box.csb", root)
    -- ]]

    state_machine.remove("activity_group_buy_box_onclick_buy_gift")
end

function ActivityGroupBuyBox:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ActivityGroupBuyBox:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("activity/group_buy/group_buy_box.csb", root)

    self.roots = {}
end
