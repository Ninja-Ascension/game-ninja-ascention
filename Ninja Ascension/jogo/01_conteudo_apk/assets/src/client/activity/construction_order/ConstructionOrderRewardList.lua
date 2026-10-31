--------------------------------------------------------------------------------------------------------------
--  建号战令奖励展示cell
--------------------------------------------------------------------------------------------------------------
ConstructionOrderRewardList = class("ConstructionOrderRewardListClass", Window)
ConstructionOrderRewardList.__size = nil

-- 创建cell
local construction_order_reward_list_create_terminal = {
    _name = "construction_order_reward_list_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = ConstructionOrderRewardList:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(construction_order_reward_list_create_terminal)
state_machine.init()

function ConstructionOrderRewardList:ctor()
    self.super:ctor()
    self.roots = {}

    self.m_index = 0
    self.normalState = 0
    self.advanceState = 0
    self.curLevel = 0
    self.normalIsNil = false
    self.isTwoAdvanceReward = false     -- 特殊奖励有两个

    self.isLoad = false                 -- 当前奖励是否被加载

    self.allReward = {}
    self.rewardAdvancedInfo = {}        -- 特殊奖励

    -- 初始化状态机
    local function init_construction_order_reward_list_terminal()
        -- local construction_order_reward_list_received_terminal = {
        --     _name = "construction_order_reward_list_received",
        --     _init = function(terminal)
        --     end,
        --     _inited = false,
        --     _instance = self,
        --     _state = 0,
        --     _invoke = function(terminal, instance, params)
        --         if instance ~= nil and params ~= nil then
        --             local type = params._datas.
        --             local function responseBuyPropCallback(response)
        --                 if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        --                     app.load("client.reward.DrawRareReward")
        --                     local getRewardWnd = DrawRareReward:new()
        --                     getRewardWnd:init(7)
        --                     fwin:open(getRewardWnd,fwin._ui)
                            
        --                     state_machine.excute("construction_order_welfare_update", 0, nil)
        --                 end
        --             end
                    
                    
        --             protocol_command.user_build_war_order_get_reward.param_list = oneClickCollection .. "\r\n" .. rewarddType .. "\r\n" .. welfareID
        --             NetworkManager:register(protocol_command.user_build_war_order_get_reward.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
        --             state_machine.excute("construction_order_main_refresh_rewards_state", 0, nil)
        --         end
        --         return true
        --     end,
        --     _terminal = nil,
        --     _terminals = nil
        -- }

        -- state_machine.add(construction_order_reward_list_received_terminal)
        state_machine.init()
    end 
    init_construction_order_reward_list_terminal()

end

-- 更新奖励状态数据
function ConstructionOrderRewardList:onUpdateRewardState(stateInfo)
    self.normalState = stateInfo.normalState
    self.advanceState = stateInfo.advanceState
    if self.isLoad == true then
        self:updateDrawState()
    end
end

-- 更新奖励状态绘制
function ConstructionOrderRewardList:updateDrawState()
    self.Image_normal_lock:setVisible(false)
    self.Image_gou_1:setVisible(false)
    self.Image_gou_2:setVisible(false)
    self.Image_gou_3:setVisible(false)
    self.Image_normal_block:setVisible(false)
    self.Image_advance_lock:setVisible(false)
    self.Image_advance_block:setVisible(false)
    
    self.Button_advance:setVisible(false)
    self.Button_normal:setVisible(false)

    if self.normalIsNil == true then
        -- self.Image_normal_block:setVisible(true)
    else
        if self.normalState == 0 then
            self.Image_normal_lock:setVisible(false)
        elseif self.normalState == 1 then
            self.Button_normal:setVisible(true)
            
            self.Panel_effect:setVisible(true)
            self:drawEffectPanel(1, self.Panel_effect)
            
        elseif self.normalState == 2 then
            self.Image_normal_block:setVisible(true)
            self.Image_gou_1:setVisible(true)
        end
    end

    if self.advanceState == 0 then
        self.Image_advance_lock:setVisible(false)
    elseif self.advanceState == 1 then
        self.Button_advance:setVisible(true)

        self.Panel_effect_0:setVisible(true)
        self:drawEffectPanel(2, self.Panel_effect_0)
    else
        self.Image_advance_block:setVisible(true)
        self.Image_gou_2:setVisible(true)
        if self.isTwoAdvanceReward then
            self.Image_gou_3:setVisible(true)
        end
    end

end

function ConstructionOrderRewardList:drawEffectPanel(type, panel)
    local animation = nil
    panel:removeAllChildren(true)
    if type == 1 then
        local jsonFile = "images/ui/effice/effice_passport_jianhao_1/effice_passport_jianhao_1.json"
        local atlasFile = "images/ui/effice/effice_passport_jianhao_1/effice_passport_jianhao_1.atlas"
        local aniName1 = "animation"
        animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName1, true, nil)
    elseif type == 2 then
        local jsonFile = "images/ui/effice/effice_passport_jianhao_2/effice_passport_jianhao_2.json"
        local atlasFile = "images/ui/effice/effice_passport_jianhao_2/effice_passport_jianhao_2.atlas"
        local aniName2 = "animation"
        animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName2, true, nil)
    end
    animation:setPosition(cc.p(panel:getContentSize().width/2, panel:getContentSize().height/2))
    panel:addChild(animation)
end

function ConstructionOrderRewardList:updateUI()
    self.Panel_advance_1:removeAllChildren()
    self.Panel_advance_2:removeAllChildren()
    self.Panel_normal:removeAllChildren()
    self.isTwoAdvanceReward = false
    -- 普通奖励
    self.normalIsNil = false
    local rewardNormalInfo = {}
    self.rewardAdvancedInfo = zstring.split(self.allReward, "!")
    local rewardNormal = zstring.split(self.rewardAdvancedInfo[1], "|")
    for i, v in ipairs(rewardNormal) do
        if v ~= nil and v ~= "" then
            local cell = DrawHandle.drawIcon(v)
            self.Panel_normal:addChild(cell)
        else
            self.normalIsNil = true
        end
    end

    local rewardAdvanced = zstring.split(self.rewardAdvancedInfo[2], "|")
    local cellAdvanced1 = DrawHandle.drawIcon(rewardAdvanced[1])
    self.Panel_advance_1:addChild(cellAdvanced1)
    if rewardAdvanced[2] ~= nil then
        local cellAdvanced2 = DrawHandle.drawIcon(rewardAdvanced[2])
        self.Panel_advance_2:addChild(cellAdvanced2)
        self.isTwoAdvanceReward = true
    end
    -- if self.curLevel == 50 then
    --     print(self.normalState, "====self.normalState", self.advanceState)
    -- end
    self.Text_level:setVisible(true)
    local levelText = string.format(war_order_str[21], tonumber(self.curRewardIdx))
    self.Text_level:setString(levelText)

    self:updateDrawState()
end

-- 刷新
function ConstructionOrderRewardList:updateDraw()
    local root = self.roots[1]

    -- 普通奖励容器
    self.Panel_normal = ccui.Helper:seekWidgetByName(root, "Panel_item_1")

    -- 普通奖励已领取图案一
    self.Image_gou_1 = ccui.Helper:seekWidgetByName(root, "Image_gou_1")

    -- 进阶奖励容器一
    self.Panel_advance_1 = ccui.Helper:seekWidgetByName(root, "Panel_item_2")

    -- 进阶奖已领取图案一
    self.Image_gou_2 = ccui.Helper:seekWidgetByName(root, "Image_gou_2")

    -- 进阶奖励容器二
    self.Panel_advance_2 = ccui.Helper:seekWidgetByName(root, "Panel_item_3")
    
    -- 进阶奖已领取图案一
    self.Image_gou_3 = ccui.Helper:seekWidgetByName(root, "Image_gou_3")

    -- 普通奖励锁图案
    self.Image_normal_lock = ccui.Helper:seekWidgetByName(root, "Image_lock")

    -- 普通奖励蒙版
    self.Image_normal_block = ccui.Helper:seekWidgetByName(root, "Image_3")

    -- 进阶奖励锁图案
    self.Image_advance_lock = ccui.Helper:seekWidgetByName(root, "Image_lock_0")

    -- 进阶奖励蒙版
    self.Image_advance_block = ccui.Helper:seekWidgetByName(root, "Image_3_0")

    -- 等级显示
    self.Text_level = ccui.Helper:seekWidgetByName(root, "Text_1")

    -- 普通奖励可领取的特效
    self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
    
    -- 特殊奖励可领取的特效
    self.Panel_effect_0 = ccui.Helper:seekWidgetByName(root, "Panel_effect_0")

    self:updateUI()

end 

function ConstructionOrderRewardList:onInit()
    self.isLoad = true
    local root = cacher.createUIRef("activity/passport/passport_main_jianhao_cell.csb", "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if ConstructionOrderRewardList.__size == nil then
        ConstructionOrderRewardList.__size = root:getContentSize()
    end

    self.Button_normal = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kelingqu"), nil,
	{
		terminal_name = "construction_order_main_refresh_rewards_state",
		terminal_state = 0,
		isPressedActionEnabled = true,
        rewardType = 1,
        receiveType = 1,
        cell = self,
	}, nil, 0)	

    self.Button_advance = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kelingqu_0"), nil,
	{
		terminal_name = "construction_order_main_refresh_rewards_state",
		terminal_state = 0,
		isPressedActionEnabled = true,
        rewardType = 2,
        receiveType = 1,
        cell = self,
	}, nil, 0)	

    self:updateDraw()
end

function ConstructionOrderRewardList:onEnterTransitionFinish()
    local root = self.roots[1]
end

function ConstructionOrderRewardList:clearUIInfo( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
    -- 普通奖励容器
    local Panel_normal = ccui.Helper:seekWidgetByName(root, "Panel_item_1")
    Panel_normal:removeAllChildren(true)
    -- 进阶奖励容器一
    local Panel_advance_1 = ccui.Helper:seekWidgetByName(root, "Panel_item_2")
    Panel_advance_1:removeAllChildren(true)
    -- 进阶奖励容器二
    local Panel_advance_2 = ccui.Helper:seekWidgetByName(root, "Panel_item_3")
    Panel_advance_2:removeAllChildren(true)
    -- 普通奖励锁图案
    local Image_normal_lock = ccui.Helper:seekWidgetByName(root, "Image_lock")
    Image_normal_lock:setVisible(false)
    -- 普通奖励蒙版
    local Image_normal_block = ccui.Helper:seekWidgetByName(root, "Image_3")
    Image_normal_block:setVisible(false)
    -- 进阶奖励锁图案
    local Image_advance_lock = ccui.Helper:seekWidgetByName(root, "Image_lock_0")
    Image_advance_lock:setVisible(false)
    -- 进阶奖励蒙版
    local Image_advance_block = ccui.Helper:seekWidgetByName(root, "Image_3_0")
    Image_advance_block:setVisible(false)
    -- 等级显示
    local Text_level = ccui.Helper:seekWidgetByName(root, "Text_1")
    Text_level:setVisible(false)
    -- 特效框1
    local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
    Panel_effect:removeAllChildren(true)
    -- 特效框2
    local Panel_effect_0 = ccui.Helper:seekWidgetByName(root, "Panel_effect_0")
    Panel_effect_0:removeAllChildren(true)
end

function ConstructionOrderRewardList:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ConstructionOrderRewardList:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    self.isLoad = false
    cacher.freeRef("activity/passport/passport_main_jianhao_cell.csb", root)
    root:removeFromParent(false)
    self.roots = {}
end

function ConstructionOrderRewardList:init(params)
    self.allReward = params.rewardInfo
    self.m_index = params.index
    self.curRewardIdx = params.level
    if params.normalState and params.advanceState then
        self.normalState = params.normalState
        self.advanceState = params.advanceState
    end
    if self.m_index ~= nil and self.m_index <= 6 then
       self:onInit()
    end
    self:setContentSize(ConstructionOrderRewardList.__size)
    return self
end

function ConstructionOrderRewardList:onExit()
    self:clearUIInfo()
    cacher.freeRef("activity/passport/passport_main_jianhao_cell.csb", self.roots[1])
end