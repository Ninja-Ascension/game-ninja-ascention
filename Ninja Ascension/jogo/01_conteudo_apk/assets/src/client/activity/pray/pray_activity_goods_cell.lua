--[[ ----------------------------------------------------------------------------
-- 祈福活动
-- 稀有物品框及普通物品框
--]] ----------------------------------------------------------------------------
PrayActivityGoodsCell = class("PrayActivityGoodsCellClass", Window)
PrayActivityGoodsCell.__size = nil

-- 创建Cell实例
local pray_activity_goods_cell_create_terminal = {
    _name = "pray_activity_goods_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if PrayActivityGoodsCell then
            local cell = PrayActivityGoodsCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pray_activity_goods_cell_create_terminal)
state_machine.init()

-- 构造器
function PrayActivityGoodsCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._mType = 0 -- 1:主界面显示 2:礼包选择 3:祈福选择
    self._mInfo = nil
    -- load lua files.

    -- Initialize pray activity goods cell page state machine.
    local function init_pray_activity_goods_cell_terminal()
        -- 打开角色创建窗口
        local pray_activity_goods_cell_select_terminal = {
            _name = "pray_activity_goods_cell_select",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params and instance then
                    state_machine.lock("pray_activity_goods_cell_select")
                    local mCell = params._datas.m_cell
                    local mType = params._datas.m_type
                    if mCell._mInfo == nil then 
                        state_machine.unlock("pray_activity_goods_cell_select")
                        return 
                    end
                    if mType == 1 or mType == 2 then
                        -- 1:祈福界面  2:礼包界面
                        state_machine.excute("pray_activity_choice_window_open", 0, {mPos = mCell._mInfo.mIndex, mType = mType, awardInfo = mCell._mInfo.rewardInfo})
                    elseif mType == 3 then
                        -- 选择奖励界面
                        state_machine.excute("pray_activity_choice_select_award", 0, {mIndex = mCell._mInfo.mIndex})
                    end

                    state_machine.unlock("pray_activity_goods_cell_select")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(pray_activity_goods_cell_select_terminal)
        state_machine.init()
    end
    -- call func init pray activity goods cell state machine.
    init_pray_activity_goods_cell_terminal()
end

-- 对象初始化
function PrayActivityGoodsCell:init(params)
    self._mInfo = params.mInfo
    self._mType = params.mType
    self:onInit(params)
    self:setContentSize(PrayActivityGoodsCell.__size)
    return self
end

function PrayActivityGoodsCell:onUpdateDraw()
    local root = self.roots[1]

    -- 道具显示容器
    self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")

    -- 稀有道具框可选择状态
    self.Image_choice_red = ccui.Helper:seekWidgetByName(root, "Image_choice_red")
    self.Image_choice_red:setVisible(false)
    -- 稀有道具框正常状态
    self.Image_normal_red = ccui.Helper:seekWidgetByName(root, "Image_normal_red")
    self.Image_normal_red:setVisible(false)
    -- 边框
    self.Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
    self.Image_1:setVisible(false)
    -- 普通道具框可选择状态
    self.Image_choice_bule = ccui.Helper:seekWidgetByName(root, "Image_choice_bule")
    self.Image_choice_bule:setVisible(false)
    -- 普通道具框正常状态
    self.Image_normal_bule = ccui.Helper:seekWidgetByName(root, "Image_normal_bule")
    self.Image_normal_bule:setVisible(false)
    -- 边框
    self.Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
    self.Image_2:setVisible(false)
    -- 物品选择完毕状态
    self.Image_Selected = ccui.Helper:seekWidgetByName(root, "Image_Selected")
    self.Image_Selected:setVisible(false)
    self.Button_exchange = ccui.Helper:seekWidgetByName(root, "Button_exchange")
    self.Button_exchange:setVisible(false)
    -- 道具名称
    self.Text_Prop_name = ccui.Helper:seekWidgetByName(root, "Text_Prop_name")
    self.Text_Prop_name:setVisible(false)
    self.Panel_1:removeAllChildren(true)
    if self._mType == 1 then
        -- 祈福界面
        self:showWishMain()
    elseif self._mType == 2 then
        -- 礼包界面
        self:showBagMain()
    elseif self._mType == 3 then
        -- 祈福/礼包选择奖励
        self:showWishSelectView()
    end
end
-- 礼包选择奖励
function PrayActivityGoodsCell:showBagMain()
    if self._mInfo.notClick then
        self.Button_choice:setEnabled(false)
        self.Button_exchange:setEnabled(false)
        self.Image_choice_bule:setVisible(false)
        self.Image_normal_bule:setVisible(true)
        if self._mInfo.tempRewardInfo then
            local selectRewardInfo = zstring.split(self._mInfo.tempRewardInfo, ",")
            local cell = self:addResourcesIconCell(selectRewardInfo)
            self.Panel_1:addChild(cell)
        end
    else
        local infos = self._mInfo.rewardInfo
        local haveSelectReward = zstring.split(infos.chooseReward, "|")
        local selectId = nil
        for i, v in ipairs(haveSelectReward) do
            if self._mInfo.mIndex == i then
                selectId = tonumber(v)
                break
            end
        end
        if selectId and selectId == -1 then
            self.Image_choice_bule:setVisible(true)
            self:addClickInfo(true)
        else
            local selectReward = zstring.split(infos.optionalReward[self._mInfo.mIndex],"|")[selectId]
            self.Image_normal_bule:setVisible(true)
            self.Button_exchange:setVisible(true)
            local selectRewardInfo = zstring.split(selectReward, ",")
            local cell = self:addResourcesIconCell(selectRewardInfo)
            self.Panel_1:addChild(cell)
            self:addClickInfo(false)
        end
        if self._mInfo.isCanChange == false then
            self.Button_choice:setEnabled(false)
            self.Button_exchange:setVisible(false)
            self.Image_choice_bule:setVisible(false)
        end
    end
end

-- 祈福选择奖励
function PrayActivityGoodsCell:showWishSelectView()
    if self._mInfo.isSelect then
        self.Image_Selected:setVisible(true)
    else
        self.Image_normal_red:setVisible(true)
    end
    if self._mInfo.mPos and self._mInfo.mPos == 1 then 
        self.Image_1:setVisible(true)
    else
        self.Image_2:setVisible(true)
    end
    local awardInfo = zstring.split(self._mInfo.rewardInfo, ",")
    local cell = self:addResourcesIconCell(awardInfo)
    self.Panel_1:addChild(cell)
end

-- 祈福主界面ICON
function PrayActivityGoodsCell:showWishMain()
    if self._mInfo.notClick then
        self.Button_choice:setEnabled(false)
        self.Button_exchange:setEnabled(false)
        if self._mInfo.mIndex == 1 then
            self.Image_choice_red:setVisible(false)
            self.Image_normal_red:setVisible(true)
            self.Image_1:setVisible(true)
        else
            self.Image_choice_bule:setVisible(false)
            self.Image_normal_bule:setVisible(true)
            self.Image_2:setVisible(true)
        end
        if self._mInfo.tempRewardInfo then
            local selectRewardInfo = zstring.split(self._mInfo.tempRewardInfo, ",")
            local cell = self:addResourcesIconCell(selectRewardInfo)
            self.Panel_1:addChild(cell)
        end
    else
        local wishInfo = _ED.active_activity[180].activity_data.wishRewardList[self._mInfo.mIndex]
        if wishInfo.wishState == -1 then
            if self._mInfo.mIndex == 1 then
                self.Image_choice_red:setVisible(true)
            else
                self.Image_choice_bule:setVisible(true)
            end
            self:addClickInfo(true)
        else
            if self._mInfo.mIndex == 1 then
                self.Image_normal_red:setVisible(true)
                self.Image_1:setVisible(true)
            else
                self.Image_normal_bule:setVisible(true)
                self.Image_2:setVisible(true)
            end
            self.Button_exchange:setVisible(true)
            local selectRewardInfo = zstring.split(wishInfo.wishReward[wishInfo.wishState], ",")
            local cell = self:addResourcesIconCell(selectRewardInfo)
            self.Panel_1:addChild(cell)
            self:addClickInfo(false)
        end
    end
end

function PrayActivityGoodsCell:addResourcesIconCell(propData)
    function clickCallBack(mCell, mType)
        state_machine.excute("pray_activity_goods_cell_select", 0, {_datas = {m_cell = mCell, m_type = mType}})
    end
    local cell = ResourcesIconCell:createCell()
    local rewardType = tonumber(propData[1])
    local extraTable = {}
    extraTable.mCell = self
    extraTable.mType = self._mType
    if self._mInfo.isCanChange ~= nil and self._mInfo.isCanChange == false then
    else
        extraTable.mSelectPray = true
        extraTable.callback = clickCallBack
    end

    if 13 == rewardType then
        if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
            extraTable.shipStar = tonumber(propData[4])
        else
            extraTable.shipStar = 0
        end
        cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
    else
        cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
    end
    return cell
end

function PrayActivityGoodsCell:onEnterTransitionFinish()
end

function PrayActivityGoodsCell:onInit(params)
    local root = cacher.createUIRef("activity/Pray/Pray_item.csb", "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    
    if PrayActivityGoodsCell.__size == nil then
        PrayActivityGoodsCell.__size = root:getContentSize()
    end
    self:clearUIInfo()
    
    self.Button_exchange = ccui.Helper:seekWidgetByName(root, "Button_exchange")
    self.Button_choice = ccui.Helper:seekWidgetByName(root, "Button_choice")
    
    self.Button_choice:setSwallowTouches(false)

    self:onUpdateDraw()
end

function PrayActivityGoodsCell:addClickInfo(canClick) 
    if canClick then 
        self.Button_choice:setEnabled(true)
        self.Button_exchange:setEnabled(true)
        -- 道具选择按钮
        fwin:addTouchEventListener(
            self.Button_choice,
        nil,
        {
            terminal_name = "pray_activity_goods_cell_select",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_cell = self,
            m_type = self._mType
        },
        nil,
        0
        )

        
        fwin:addTouchEventListener(
            self.Button_exchange,
        nil,
        {
            terminal_name = "pray_activity_goods_cell_select",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_cell = self,
            m_type = self._mType
        },
        nil,
        0
        )
    else
        self.Button_choice:setEnabled(false)
        self.Button_exchange:setEnabled(false)
    end
end

function PrayActivityGoodsCell:onExit()
    self:clearUIInfo()
    local root = self.roots[1]
    cacher.freeRef("activity/Pray/Pray_item.csb", root)
end

function PrayActivityGoodsCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:registerOnNoteUpdate(self)
    self:onInit()
end
function PrayActivityGoodsCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
    end
    ccui.Helper:seekWidgetByName(root, "Panel_1"):removeAllChildren(true)
    ccui.Helper:seekWidgetByName(root, "Image_choice_red"):setVisible(true)
    ccui.Helper:seekWidgetByName(root, "Image_normal_red"):setVisible(true)
    ccui.Helper:seekWidgetByName(root, "Image_choice_bule"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_normal_bule"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Image_Selected"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Button_exchange"):setVisible(true)
    ccui.Helper:seekWidgetByName(root, "Text_Prop_name"):setString("")
    ccui.Helper:seekWidgetByName(root, "Button_choice"):setEnabled(true)
    ccui.Helper:seekWidgetByName(root, "Button_exchange"):setEnabled(true)
end

function PrayActivityGoodsCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("activity/Pray/Pray_item.csb", root)

    self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
