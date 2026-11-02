--[[ ----------------------------------------------------------------------------
-- 一键升级cell道具项
--]] ----------------------------------------------------------------------------
CombinationCardUpgradeCell = class("CombinationCardUpgradeCellClass", Window)
CombinationCardUpgradeCell.__size = nil

-- 创建Cell实例
local combination_card_upgrade_cell_create_terminal = {
	_name = "combination_card_upgrade_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CombinationCardUpgradeCell then
			local cell = CombinationCardUpgradeCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(combination_card_upgrade_cell_create_terminal)
state_machine.init()

-- 构造器
function CombinationCardUpgradeCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	
	-- load lua files.

	-- Initialize combination card upgrade cell state machine.
	local function init_combination_card_upgrade_cell_terminal()
		-- 金币购买
		local init_combination_card_upgrade_cell_open_buy_terminal = {
			_name = "init_combination_card_upgrade_cell_open_buy",
			_init = function (terminal)
				
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
		state_machine.add(init_combination_card_upgrade_cell_open_buy_terminal)
	end
	-- call func iinit_combination_card_upgrade_cell_terminal.
	init_combination_card_upgrade_cell_terminal()
end

function CombinationCardUpgradeCell:getPropKey()
	return self.propString
end

function CombinationCardUpgradeCell:updateUI()

	-- 玩家该道具的数量文本
	self:updateDrawPropNums()
	-- 玩家需要消耗该道具的数量
	self:updateDrawCostNums(self.needCostNum)
	-- 判断是否置灰显示
	self:checkShowInGray()
end

function CombinationCardUpgradeCell:simplifyText(number)
	if number > 10000 then
		number = math.floor(number / 1000) .. string_equiprety_name[40]
	end

	return number
end

-- 玩家拥有该道具的数量
function CombinationCardUpgradeCell:updateDrawPropNums()
	local havePropNum = self:getPropNums()
	havePropNum = self:simplifyText(havePropNum)
	local needPropNum = self:simplifyText(self.needCostNum)
	self.Text_role_up_lv_num_2:setString(havePropNum .. "/" .. needPropNum)
	if tonumber(self.needCostNum) > 0 then
		self.Text_role_up_lv_num_2:setColor(cc.c3b(_quality_color[2][1], _quality_color[2][2], _quality_color[2][3]))
	else
		self.Text_role_up_lv_num_2:setColor(cc.c3b(_quality_color[1][1], _quality_color[1][2], _quality_color[1][3]))
	end
end

function CombinationCardUpgradeCell:getPropNums()
	local propInfo = self.propInfo
	local havePropNum = 0
    if propInfo[1] == 1 then
        havePropNum = tonumber(_ED.user_info.user_silver)
    elseif propInfo[1] == 2 then
        havePropNum = tonumber(_ED.user_info.user_gold)
    elseif propInfo[1] == 6 then
        havePropNum = tonumber(getPropAllCountByMouldId(propInfo[2]))
    end

    return havePropNum
end

-- 刷新消耗道具数量
function CombinationCardUpgradeCell:updateDrawCostNums(costNum)
	self.needCostNum = costNum
	self:updateDrawPropNums()
end

function CombinationCardUpgradeCell:checkShowInGray()
	local isShow = self:getPropNums() <= 0
	-- 如果没有该道具则置灰
	local children = self.Panel_role_up_lv_box_2:getChildren()
	local cell = children[1]
	if cell ~= nil then
		cell:setGrayState(isShow)
	end
end

-- 绘制图标
function CombinationCardUpgradeCell:drawPropIcon()
	local iconCell = DrawHandle.drawIcon(self.propInfo)
	self.Panel_role_up_lv_box_2:addChild(iconCell)
end

-- 绘制勾选状态
function CombinationCardUpgradeCell:updateChoose(isShow)
	local children = self.Panel_role_up_lv_box_2:getChildren()
	local cell = children[1]
	if cell ~= nil then
		cell:setChooseSelectState(isShow)
	end
end

-- 对象初始化 {propString = "6,121,1000", costNum = 1000}
function CombinationCardUpgradeCell:init(params)
	self.propString = params.propString
	self.propInfo = zstring.split(self.propString, ",", tonumber)
	self.needCostNum = params.costNum

	if nil ~= self.onInit then
		self:onInit(params)
	end
	self:setContentSize(CombinationCardUpgradeCell.__size)
	return self
end

function CombinationCardUpgradeCell:onUpdateDraw()
	local root = self.roots[1]
    -- 道具消耗数量文本
    self.Text_role_up_lv_num_2 = ccui.Helper:seekWidgetByName(root, "Text_role_up_lv_num_2")
    -- 道具图标容器
    self.Panel_role_up_lv_box_2 = ccui.Helper:seekWidgetByName(root, "Panel_role_up_lv_box_2")

	self:drawPropIcon()
	self:updateUI()
end

function CombinationCardUpgradeCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end
end

function CombinationCardUpgradeCell:onEnterTransitionFinish()
	
end

function CombinationCardUpgradeCell:onInit(params)
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Combination_card/Combination_card_upgrade_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CombinationCardUpgradeCell.__size == nil then
		CombinationCardUpgradeCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function CombinationCardUpgradeCell:onExit()
	-- 释放CombinationCardUpgradeCell界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/lim_pool/combination_card_upgrade_cell.csb", root)
	-- ]]
end

function CombinationCardUpgradeCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CombinationCardUpgradeCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/lim_pool/combination_card_upgrade_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
