--------------------------------------------------------------------------------------------------------------
--  常规战令奖励cell
--------------------------------------------------------------------------------------------------------------
CommonOrderRewardList = class("CommonOrderRewardListClass", Window)
CommonOrderRewardList.__size = nil

-- 创建cell
local common_order_reward_list_create_terminal = {
    _name = "common_order_reward_list_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = CommonOrderRewardList:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(common_order_reward_list_create_terminal)
state_machine.init()

function CommonOrderRewardList:ctor()
    self.super:ctor()
    self.roots = {}

    self.m_index = 0
    self.normalState = 0
    self.advanceState = 0
    self.achieveID = 0                  -- 成就ID

    self.allReward = {}
    self.effectTable = {}

    self.isLoad = false
    self.isTwoAdvanceReward = false

    -- 初始化状态机
    local function init_common_order_reward_list_terminal()
        
    end 
    init_common_order_reward_list_terminal()

end

-- 初始化动画资源
function CommonOrderRewardList:drawEffectPanel(type, panel)
    local animation = nil
    panel:removeAllChildren(true)
    if type == 1 then
        local jsonFile = "images/ui/effice/effice_passport_changgui_1/effice_passport_changgui_1.json"
        local atlasFile = "images/ui/effice/effice_passport_changgui_1/effice_passport_changgui_1.atlas"
        local aniName1 = "animation"
        animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName1, true, nil)
    elseif type == 2 then
        local jsonFile = "images/ui/effice/effice_passport_changgui_2/effice_passport_changgui_2.json"
        local atlasFile = "images/ui/effice/effice_passport_changgui_2/effice_passport_changgui_2.atlas"
        local aniName2 = "animation"
        animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName2, true, nil)
    end
    animation:setPosition(cc.p(panel:getContentSize().width/2, panel:getContentSize().height/2))
    panel:addChild(animation)
end

-- 更新奖励状态数据
function CommonOrderRewardList:onUpdateRewardState(stateInfo)
    self.normalState = stateInfo.normalState
    self.advanceState = stateInfo.advanceState
    if self.isLoad == true then
        self:updateDrawState()
    end
end

-- 更新绘制奖励状态
function CommonOrderRewardList:updateDrawState()
    self.Button_normal:setVisible(false)
    self.Button_advance:setVisible(false)

    self.Image_normal_block:setVisible(false)
    self.Image_advance_block:setVisible(false)

    self.Image_advance_lock:setVisible(false)
    self.Image_normal_lock:setVisible(false)

    self.Image_gou_1:setVisible(false)
    self.Image_gou_2:setVisible(false)
    self.Image_gou_3:setVisible(false)


    if self.normalState == 0 then
        self.Image_normal_lock:setVisible(false)
    elseif self.normalState == 1 then
        self.Button_normal:setVisible(true)
        
        self.Panel_effect:setVisible(true)
        self:drawEffectPanel(1, self.Panel_effect)
    else
        self.Image_normal_block:setVisible(true)
        self.Image_gou_1:setVisible(true)
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

function CommonOrderRewardList:updateUI()
    
    -- 普通奖励
    local rewardNormalInfo = {}
    -- 进阶奖励
    local rewardAdvancedInfo = {}
    
    self.isTwoAdvanceReward = false

    local achieveInfo = dms.atos(dms["achieve"], self.achieveID)
    local descText = dms.atos(achieveInfo, achieve.descript)
    local rewardString = dms.atos(achieveInfo, achieve.reward_value)

    -- local descText = dms.string(dms["achieve"],self.achieveID, achieve.descript)
    -- local rewardString = dms.string(dms["achieve"], self.achieveID, achieve.reward_value)
    local rewardInfo = zstring.split(rewardString, "!")
    local rewardNormal = zstring.split(rewardInfo[1], "|")
    for i, v in ipairs(rewardNormal) do
        local cell = DrawHandle.drawIcon(v)
        self.Panel_normal:addChild(cell)
    end

    local rewardAdvanced = zstring.split(rewardInfo[2], "|")
    local cellAdvanced1 = DrawHandle.drawIcon(rewardAdvanced[1])
    self.Panel_advance_1:addChild(cellAdvanced1)
    if rewardAdvanced[2] ~= nil then
        local cellAdvanced2 = DrawHandle.drawIcon(rewardAdvanced[2])
        self.Panel_advance_2:addChild(cellAdvanced2)
        self.isTwoAdvanceReward = true
    end
    self.Text_open:setVisible(true)
    self.Text_open:setString(descText)

    self:updateDrawState()
end

-- 刷新
function CommonOrderRewardList:updateDraw()
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

    -- 开启文本内容
    self.Text_open = ccui.Helper:seekWidgetByName(root, "Text_1")

    -- 普通奖励可领取的特效
    self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
    
    -- 特殊奖励可领取的特效
    self.Panel_effect_0 = ccui.Helper:seekWidgetByName(root, "Panel_effect_0")

    self:updateUI()

end 

function CommonOrderRewardList:init(params)
    self.achieveID = params.achieveID
    self.m_index = params.index

    -- self.allReward = params.rewardInfo
    -- self.curLevel = params.level
    if params.normalState and params.advanceState then
        self.normalState = params.normalState
        self.advanceState = params.advanceState
    else
        self.normalState = 1
        self.advanceState = 1
    end
    if self.m_index ~= nil and self.m_index <= 8 then
       self:onInit()
    end
    self:setContentSize(CommonOrderRewardList.__size)
    return self
end

function CommonOrderRewardList:onInit()
    self.isLoad = true
    local root = cacher.createUIRef("activity/passport/passport_main_changgui_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if CommonOrderRewardList.__size == nil then
        CommonOrderRewardList.__size = root:getContentSize()
    end

    -- 普通奖励领取
    self.Button_normal = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kelingqu"), nil,
	{
		terminal_name = "common_order_main_refresh_rewards_state",
		terminal_state = 0,
		isPressedActionEnabled = true,
        rewardType = 1,
        rewardIdx = self.m_index,
	}, nil, 0)	

    -- 进阶奖励领取
    self.Button_advance = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kelingqu_0"), nil,
	{
		terminal_name = "common_order_main_refresh_rewards_state",
		terminal_state = 0,
		isPressedActionEnabled = true,
        rewardType = 2,
        rewardIdx = self.m_index,
	}, nil, 0)	

    self:updateDraw()
end

function CommonOrderRewardList:onEnterTransitionFinish()
    local root = self.roots[1]
end

function CommonOrderRewardList:clearUIInfo( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
    -- 普通奖励容器
    local Panel_normal = ccui.Helper:seekWidgetByName(root, "Panel_item_1")
    Panel_normal:removeAllChildren()
    -- 进阶奖励容器一
    local Panel_advance_1 = ccui.Helper:seekWidgetByName(root, "Panel_item_2")
    Panel_advance_1:removeAllChildren()
    -- 进阶奖励容器二
    local Panel_advance_2 = ccui.Helper:seekWidgetByName(root, "Panel_item_3")
    Panel_advance_2:removeAllChildren()
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
    local Text_open = ccui.Helper:seekWidgetByName(root, "Text_1")
    Text_open:setString("")
    Text_open:setVisible(false)
end

function CommonOrderRewardList:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function CommonOrderRewardList:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self.isLoad = false
    self:clearUIInfo()
    cacher.freeRef("activity/passport/passport_main_changgui_cell.csb", root)
    root:removeFromParent(false)
    self.roots = {}
end

function CommonOrderRewardList:onExit()
    self:clearUIInfo()
    cacher.freeRef("activity/passport/passport_main_changgui_cell.csb", self.roots[1])
end