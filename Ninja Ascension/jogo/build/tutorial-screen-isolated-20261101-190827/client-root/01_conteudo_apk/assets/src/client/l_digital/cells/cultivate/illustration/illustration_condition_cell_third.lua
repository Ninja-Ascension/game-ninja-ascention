--[[ ----------------------------------------------------------------------------
-- 条件列表项
--]] ----------------------------------------------------------------------------
IllustrationConditionCellThird = class("IllustrationConditionCellThirdClass", Window)
IllustrationConditionCellThird.__size = nil

-- 创建Cell实例
local illustration_condition_cell_third_create_terminal = {
	_name = "illustration_condition_cell_third_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if IllustrationConditionCellThird then
			local cell = IllustrationConditionCellThird:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_condition_cell_third_create_terminal)
state_machine.init()

-- 构造器
function IllustrationConditionCellThird:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._combine_card_data = nil
	self._condition_id = nil

	-- load lua files.

	-- Initialize lim pool record list page state machine.
	local function init_illustration_condition_cell_third_terminal()
		
	end
	-- call func init lim pool record list state machine.
	init_illustration_condition_cell_third_terminal()
end

-- 对象初始化
function IllustrationConditionCellThird:init(params)
	self._combine_card_data = params[1]
	self._condition_id = params[2]

	self:onInit(params)
	self:setContentSize(IllustrationConditionCellThird.__size)
	return self
end

function IllustrationConditionCellThird:updateUI()
    local cardMouldId = tonumber(self._combine_card_data[ship_illustration_card_mould.id])
	local conditionIndex = self:getConditionIndex()
	local isFinsh, curProgress = IllustrationHandle.isSpecialTaskFinished(cardMouldId, conditionIndex)

    local finish_times_data = self._combine_card_data[ship_illustration_card_mould.finish_times]
    local finish_times_str = zstring.split(finish_times_data, ",")
    local finish_times = zstring.tonumber(finish_times_str[conditionIndex])

	local is_show_progress = dms.int(dms["comb_card_activite_mould"], self._condition_id, ship_illustration_comobine_card_activite_mould.is_show_progress)
	local str = ""
	if is_show_progress == 1 then
		curProgress = curProgress <= finish_times and curProgress or finish_times
		str = curProgress .. "/" .. finish_times
	else
		str = tostring(finish_times)
	end

	local name = ""

	local condition_is_hide_str = self._combine_card_data[ship_illustration_card_mould.is_hide]
	local condition_is_hide = zstring.split(condition_is_hide_str, ",")
	local is_hide = tonumber(condition_is_hide[conditionIndex])

	if is_hide == 0 or isFinsh == true then
		local name_mould_id = dms.int(dms["comb_card_activite_mould"], self._condition_id, ship_illustration_comobine_card_activite_mould.describe)
	    local word_info = dms.element(dms["word_mould"], name_mould_id)
	    name = word_info[3]
	else
		name = tipStringInfo_illustration_tip[14]
	end

	self.Text_special:setString(string.format(name, str))

	self.Text_special_n:setString(isFinsh and tipStringInfo_illustration_tip[11] or tipStringInfo_illustration_tip[10])
	if isFinsh then
		self.Text_special:setColor(cc.c3b(0, 203, 11))
		self.Text_special_n:setColor(cc.c3b(0, 203, 11))
	else
		self.Text_special:setColor(cc.c3b(125, 58, 0))
		self.Text_special_n:setColor(cc.c3b(125, 58, 0))
	end
end

function IllustrationConditionCellThird:getConditionIndex()
	local conditionIndex = nil
	local condition_id = self._condition_id
	local special_condition_str = self._combine_card_data[ship_illustration_card_mould.special_condition]
    local special_condition = zstring.split(special_condition_str, ",")

    for k, v in pairs(special_condition) do
    	if tonumber(v) == condition_id then
    		conditionIndex = k
    		break
    	end
    end

    return conditionIndex
end

function IllustrationConditionCellThird:onUpdateDraw()
	local root = self.roots[1]

	-- 条件文本
	self.Text_special = ccui.Helper:seekWidgetByName(root, "Text_special")

	-- 已完成
	self.Text_special_n = ccui.Helper:seekWidgetByName(root, "Text_special_n")

	self:updateUI()
end

function IllustrationConditionCellThird:onEnterTransitionFinish()
	
end

function IllustrationConditionCellThird:onInit(params)
	-- 加载IllustrationConditionCellThirdWindow界面资源.
	-- res.cultivate.illustration.illustration_levelup_list_3 = res/cultivate/illustration/illustration_levelup_list_3.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/illustration/illustration_levelup_list_3.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/illustration/illustration_levelup_list_3.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if IllustrationConditionCellThird.__size == nil then
		IllustrationConditionCellThird.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function IllustrationConditionCellThird:onExit()
	-- 释放IllustrationConditionCellThirdWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/illustration/illustration_levelup_list_3.csb", root)
	-- ]]
end

function IllustrationConditionCellThird:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function IllustrationConditionCellThird:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/illustration/illustration_levelup_list_3.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
