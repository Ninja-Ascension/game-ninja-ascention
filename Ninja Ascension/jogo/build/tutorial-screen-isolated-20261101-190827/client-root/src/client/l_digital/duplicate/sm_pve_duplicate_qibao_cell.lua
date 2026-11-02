----------------------------------------------------------------------------------------------------
-- 说明：pve的气泡框
-------------------------------------------------------------------------------------------------------
SmPveDuplicateQibaoCell = class("SmPveDuplicateQibaoCellClass", Window)

function SmPveDuplicateQibaoCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.actions = {}
	self.updateTimes = 0

	-- 初始化事件响应需要使用的状态机
	local function init_sm_pve_duplicate_qibao_cell_terminal()
	
		-- 添加需要使用的状态机到状态机管理器去
        state_machine.init()
	end
	init_sm_pve_duplicate_qibao_cell_terminal()
end

function SmPveDuplicateQibaoCell:onUpdateDraw()
	local root = self.roots[1]
	local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip")
	local textId = dms.int(dms["npc"], self.npcid, npc.npc_type)
	local word_info = dms.element(dms["word_mould"], textId)
	Text_tip:setString(word_info[3])
end

function SmPveDuplicateQibaoCell:onEnterTransitionFinish()
	
end

function SmPveDuplicateQibaoCell:onUpdate(dt)
	if self.updateTimes == 0 then
		self.actions[1]:play("animation1", false)
	elseif self.updateTimes > 5 then
		self.actions[1]:play("animation2", false)
		self.updateTimes = -3
	elseif self.updateTimes >= -1 and self.updateTimes < 0 then
		self.updateTimes = 0
		self.actions[1]:play("animation1", false)
	end
	self.updateTimes = self.updateTimes + dt
end

function SmPveDuplicateQibaoCell:onInit( ... )
	local pveQipao = csb.createNode("duplicate/pve_duplicate_k_qibao.csb")
    self:addChild(pveQipao)
	local root = pveQipao:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline("duplicate/pve_duplicate_k_qibao.csb")
    table.insert(self.actions, action)
    pveQipao:runAction(action)

	self:onUpdateDraw()
end

function SmPveDuplicateQibaoCell:clearUIInfo( ... )
	
end

function SmPveDuplicateQibaoCell:onExit()
	local root = self.roots[1]
	self:clearUIInfo()
	cacher.freeRef("duplicate/pve_duplicate_k_qibao.csb", root)
end

function SmPveDuplicateQibaoCell:init(npcId)
	self.npcid = npcId
	self:onInit()
end

function SmPveDuplicateQibaoCell:createCell()
	local cell = SmPveDuplicateQibaoCell:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end

