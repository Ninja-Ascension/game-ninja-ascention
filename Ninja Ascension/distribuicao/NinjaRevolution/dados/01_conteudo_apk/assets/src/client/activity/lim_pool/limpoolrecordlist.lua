--[[ ----------------------------------------------------------------------------
-- 记录列表项
--]] ----------------------------------------------------------------------------
LimPoolRecordList = class("LimPoolRecordListClass", Window)
LimPoolRecordList.__size = nil

-- 创建Cell实例
local lim_pool_record_list_create_terminal = {
	_name = "lim_pool_record_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if LimPoolRecordList then
			local cell = LimPoolRecordList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lim_pool_record_list_create_terminal)
state_machine.init()

-- 构造器
function LimPoolRecordList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._info = nil

	-- load lua files.

	-- Initialize lim pool record list page state machine.
	local function init_lim_pool_record_list_terminal()
		
	end
	-- call func init lim pool record list state machine.
	init_lim_pool_record_list_terminal()
end

-- 对象初始化
function LimPoolRecordList:init(params)
	self._info = params

	self:onInit(params)
	self:setContentSize(LimPoolRecordList.__size)
	return self
end

function LimPoolRecordList:updateUI()
	local nickName = self._info.nickName
	self.Text_player_name:setString(nickName)

	local propInfo = zstring.split(self._info.rewards, ",") 
	local name = self:getRankRewardName(propInfo)
	local count = propInfo[3]
	self.Text_reward:setString(name .. "*" .. count)
end

-- 获取道具的名字和品质
function LimPoolRecordList:getRankRewardName(propInfo)
	local propType = tonumber(propInfo[1])
	local propId = tonumber(propInfo[2])
	if 1 == propType or 
		2 == propType or 
		3 == propType or 
		9 == propType or
		10 == propType
		 then 
		porp_name = _my_gane_name[propType]
	elseif 4 == propType then 
		porp_name = _my_gane_name[5]
	elseif 6 == propType then
		local property = dms.int(dms["prop_mould"],propId,prop_mould.prop_name)
		local porp_name_word = dms.element(dms["word_mould"], property)
		porp_name = porp_name_word[3]
	elseif 7 == propType then 
		local nameindex = dms.int(dms["equipment_mould"], propId, equipment_mould.equipment_name)
		local word_info = dms.element(dms["word_mould"], nameindex)
		porp_name = word_info[3]	
	elseif 8 == propType then 
		porp_name = _my_gane_name[7]
	elseif 12 == propType then 
		porp_name = _my_gane_name[8]
	elseif 13 == propType then 
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], propId, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local evo_mould_id = evo_info[dms.int(dms["ship_mould"], propId, ship_mould.captain_name)]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		porp_name = word_info[3]
	elseif 18 == propType then 
		porp_name = _my_gane_name[6]
	elseif 20 == propType then 
		porp_name = _my_gane_name[11]
	elseif 28 == propType then 
		porp_name = _my_gane_name[13]
	elseif 31 == propType then 
		porp_name = red_alert_resouce_tip[1][1]
	elseif 33 == propType then 
		porp_name = _my_gane_name[14]
	elseif 34 == propType then 
		porp_name = _my_gane_name[15]
	elseif 71 == propType then 
		porp_name = dms.string(dms["ship_silk_bag_mould"], propId, ship_silk_bag_mould.silkbag_name)
	elseif 73 == propType then 
		local pos = dms.int(dms["fight_spirit_mould"], propId, fight_spirit_mould.pos)
		local suitId = dms.int(dms["fight_spirit_mould"], propId, fight_spirit_mould.suit_id)
		porp_name = dms.element(dms["word_mould"], dms.int(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.suit_name))[3].."."..chinese_num[pos]
	end

	return porp_name


	-- local name = ""
	-- local quality = 0
	-- if tonumber(propInfo.prop_type) == 6 then
	-- 	name = smPropWordlFundByIndex(propInfo.mould_id, 1)
	-- 	quality = dms.int(dms["prop_mould"], propInfo.mould_id, prop_mould.prop_quality)
	-- elseif tonumber(propInfo.prop_type) == 7 then
	-- 	name = smEquipWordlFundByIndex(propInfo.mould_id, 1)
	-- 	quality = dms.int(dms["equipment_mould"], propInfo.mould_id, equipment_mould.grow_level)
	-- elseif tonumber(propInfo.mould_id) == -1 then
	-- 	name = _my_gane_name[propInfo.prop_type]
	-- 	quality = 2
	-- end

	-- return name, quality
end

function LimPoolRecordList:onUpdateDraw()
	local root = self.roots[1]

	-- 名字
	self.Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")

	-- 道具名称
	self.Text_reward = ccui.Helper:seekWidgetByName(root, "Text_reward")

	self:updateUI()
end

function LimPoolRecordList:onEnterTransitionFinish()
	
end

function LimPoolRecordList:onInit(params)
	-- 加载LimPoolRecordListWindow界面资源.
	-- res.activity.lim_pool.lim_pool_record_list = res/activity/lim_pool/lim_pool_record_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/lim_pool/lim_pool_record_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/lim_pool/lim_pool_record_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if LimPoolRecordList.__size == nil then
		LimPoolRecordList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function LimPoolRecordList:onExit()
	-- 释放LimPoolRecordListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/lim_pool/lim_pool_record_list.csb", root)
	-- ]]
end

function LimPoolRecordList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function LimPoolRecordList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/lim_pool/lim_pool_record_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
