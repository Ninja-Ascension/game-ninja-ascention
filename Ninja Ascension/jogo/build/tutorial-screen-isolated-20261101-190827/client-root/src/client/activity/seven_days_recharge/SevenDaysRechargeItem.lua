--[[ ----------------------------------------------------------------------------
-- 奖励物品展示分页
--]] ----------------------------------------------------------------------------
SevenDaysRechargeItem = class("SevenDaysRechargeItemClass", Window)
SevenDaysRechargeItem.__size = nil

-- 创建Cell实例
local seven_days_recharge_item_create_terminal = {
	_name = "seven_days_recharge_item_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if SevenDaysRechargeItem then
			local cell = SevenDaysRechargeItem:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(seven_days_recharge_item_create_terminal)
state_machine.init()

-- 构造器
function SevenDaysRechargeItem:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.infos = nil
	-- load lua files.

	-- Initialize seven days recharge item page state machine.
	local function init_seven_days_recharge_item_terminal()
		
	end
	-- call func init seven days recharge item state machine.
	init_seven_days_recharge_item_terminal()
end

-- 对象初始化
function SevenDaysRechargeItem:init(params)
	self:onInit(params)
	return self
end

function SevenDaysRechargeItem:onUpdateDraw()
	local root = self.roots[1]
	local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
	local Panel_item = ccui.Helper:seekWidgetByName(root, "Panel_item")
	Panel_item:removeAllChildren(true)
	local propData = self.infos.propDatas
	local propType = tonumber(propData[1])

	local cell = ResourcesIconCell:createCell()
	if 13 == propType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(propType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(propType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1)
	end

	Panel_item:addChild(cell)

	local Text_45 = ccui.Helper:seekWidgetByName(root, "Text_45")
	Text_45:setString(string.format(tipStringInfo_seven_days_recharge_tips[5],self.infos.days))

	
	local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
	Panel_effect:removeAllChildren(true)
	local jsonFile = "images/ui/effice/effect_qitianlianchong/effect_qitianlianchong.json"
	local atlasFile = "images/ui/effice/effect_qitianlianchong/effect_qitianlianchong.atlas"
	local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	animation:setPosition(cc.p(Panel_effect:getContentSize().width/2, Panel_effect:getContentSize().height/2))
	Panel_effect:addChild(animation)
end

function SevenDaysRechargeItem:onEnterTransitionFinish()
	
end

function SevenDaysRechargeItem:onInit(params)
	-- 加载SevenDaysRechargeItemWindow界面资源.
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate.sevenday_recharge.sevenday_recharge_item.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/sevenday_recharge/sevenday_recharge_item.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if SevenDaysRechargeItem.__size == nil then
		SevenDaysRechargeItem.__size = root:getContentSize()
	end
	self:setContentSize(SevenDaysRechargeItem.__size)
	self.infos = params[1]
	self:onUpdateDraw()
end

function SevenDaysRechargeItem:onExit()
	-- 释放SevenDaysRechargeItemWindow界面资源.
	
	-- [[ 释放缓存
	self:clearUIInfo()
	local root = self.roots[1]
	cacher.freeRef("activity/sevenday_recharge/sevenday_recharge_item.csb", root)
	-- ]]
end

function SevenDaysRechargeItem:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SevenDaysRechargeItem:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/sevenday_recharge/sevenday_recharge_item.csb", root)
	
	self.roots = {}

end

function SevenDaysRechargeItem:clearUIInfo()
    local root = self.roots[1]
    if root == nil then
        return
    end
    if root._x ~= nil then
        root:setPositionX(root._x)
    end
    if root._y ~= nil then
        root:setPositionY(root._y)
    end
    -- local Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")
    -- Text_11:setString(Text_11:getString())
    -- local ListView_11 = ccui.Helper:seekWidgetByName(root, "ListView_11")
    -- ListView_11:removeAllChildren()
    -- fwin:removeTouchEventListener(ListView_11)
end

-- ~END
-- ----------------------------------------------------------------------------
