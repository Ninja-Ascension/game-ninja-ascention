ActivityGroupBuyJd = class("ActivityGroupBuyJdClass", Window)
ActivityGroupBuyJd.__size = nil

-- 创建Cell实例
local activity_group_buy_jd_create_terminal = {
    _name = "activity_group_buy_jd_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if ActivityGroupBuyJd then
            local cell = ActivityGroupBuyJd:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_group_buy_jd_create_terminal)
state_machine.init()

-- 构造器
function ActivityGroupBuyJd:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    ------------------------------------------------------------------------ var------------------------------------------------------------------------

    ------------------------------------------------------------------ load lua files-------------------------------------------------------------------

    ------------------------------------------------- Initialize summer drink cell page state machine---------------------------------------------------
    local function init_activity_group_buy_jd_terminal()
    end

    ------------------------------------------------- call func init user return window state machine---------------------------------------------------
    init_activity_group_buy_jd_terminal()
end

-- 对象初始化
function ActivityGroupBuyJd:init(_data)
    if _data ~= nil then
        self.posX = _data.posX
        self.discount_num = _data.discount_num
    end

    self:onInit()
    self:setContentSize(ActivityGroupBuyJd.__size)

    return self
end

function ActivityGroupBuyJd:onInit()
    -- res.duplicate.pve_super_mopping_cell = duplicate/pve_super_mopping_cell.csb
    --[[ 不使用缓存创建
	local csbNode = csb.createNode("duplicate/pve_super_mopping_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
    -- [[ 使用缓存创建
    local root = cacher.createUIRef("activity/group_buy/group_buy_jd.csb", "root")
    -- ]]
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if ActivityGroupBuyJd.__size == nil then
        ActivityGroupBuyJd.__size = root:getContentSize()
    end

    self:onUpdateDraw()
end

function ActivityGroupBuyJd:onUpdateDraw()
    local root = self.roots[1]

    -- 折扣文本
    self.group_buy_jd_Text_1 = ccui.Helper:seekWidgetByName(root, "group_buy_jd_Text_1")

    if verifySupportLanguage(_lua_release_language_en) == true then
        local discount = (10 - tonumber(self.discount_num)) * 10
        local str = string.format("%d%%", discount)
        self.group_buy_jd_Text_1:setString(string.format(tipStringInfo_activity_group_buy[13], str))
    else
        self.group_buy_jd_Text_1:setString(string.format(tipStringInfo_activity_group_buy[13], self.discount_num))
    end

    -- 坐标位置
    root:setPositionX(0)
    root:setPositionX(self.posX)
end

function ActivityGroupBuyJd:createCell()
    local cell = ActivityGroupBuyJd:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function ActivityGroupBuyJd:onEnterTransitionFinish()
end

function ActivityGroupBuyJd:onExit()
    -- 释放ActivityGroupBuyCell界面资源.
    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("activity/group_buy/group_buy_jd.csb", root)
    -- ]]
end

function ActivityGroupBuyJd:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ActivityGroupBuyJd:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("activity/group_buy/group_buy_jd.csb", root)

    self.roots = {}
end
