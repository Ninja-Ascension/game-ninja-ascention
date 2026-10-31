----------------------------------------------------------------------------------------------------
-- 说明：首充的气泡框
-------------------------------------------------------------------------------------------------------
SmFirstChargeQibaoCell = class("SmFirstChargeQibaoCellClass", Window)

function SmFirstChargeQibaoCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.actions = {}
	self.updateTimes = 0

	-- 初始化事件响应需要使用的状态机
	local function init_sm_first_charge_qibao_cell_terminal()
	
		-- 添加需要使用的状态机到状态机管理器去
        state_machine.init()
	end
	init_sm_first_charge_qibao_cell_terminal()
end

function SmFirstChargeQibaoCell:onUpdateDraw()
	local root = self.roots[1]

end

function SmFirstChargeQibaoCell:onEnterTransitionFinish()
	
end

function SmFirstChargeQibaoCell:onUpdate(dt)
	if self.updateTimes == 0 then
		self.actions[1]:play("animation_open", false)
	elseif self.updateTimes > 5 then
		self.actions[1]:play("animation_close", false)
		self.updateTimes = -3
	elseif self.updateTimes >= -1 and self.updateTimes < 0 then
		self.updateTimes = 0
		self.actions[1]:play("animation_open", false)
	end
	self.updateTimes = self.updateTimes + dt
end

function SmFirstChargeQibaoCell:onInit( ... )

	local pveQipao = csb.createNode("activity/icon/activity_shouchong.csb")
    self:addChild(pveQipao)
	local root = pveQipao:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline("activity/icon/activity_shouchong.csb")
    table.insert(self.actions, action)
    pveQipao:runAction(action)

	self:onUpdateDraw()
end

function SmFirstChargeQibaoCell:clearUIInfo( ... )
	
end

function SmFirstChargeQibaoCell:onExit()
	local root = self.roots[1]
	self:clearUIInfo()
	cacher.freeRef("activity/icon/activity_shouchong.csb", root)
end

function SmFirstChargeQibaoCell:init()
	self:onInit()
end

function SmFirstChargeQibaoCell:createCell()
	local cell = SmFirstChargeQibaoCell:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end

