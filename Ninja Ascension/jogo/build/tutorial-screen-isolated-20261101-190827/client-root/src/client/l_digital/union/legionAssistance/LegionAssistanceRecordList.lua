--[[ ----------------------------------------------------------------------------
-- 捐赠记录列表项
--]] ----------------------------------------------------------------------------
LegionAssistanceRecordList = class("LegionAssistanceRecordListClass", Window)
LegionAssistanceRecordList.__size = nil

-- 创建Cell实例
local legion_assistance_record_list_create_terminal = {
	_name = "legion_assistance_record_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if LegionAssistanceRecordList then
			local cell = LegionAssistanceRecordList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(legion_assistance_record_list_create_terminal)
state_machine.init()

-- 构造器
function LegionAssistanceRecordList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.recordInfo = nil

	-- load lua files.

	-- Initialize legion assistance record list page state machine.
	local function init_legion_assistance_record_list_terminal()
		
	end
	-- call func init legion assistance record list state machine.
	init_legion_assistance_record_list_terminal()
end

-- 对象初始化
function LegionAssistanceRecordList:init(params)
	self.recordInfo = params
	if self.recordInfo.index < 9 then
		self:onInit(params)
	end
	self:setContentSize(LegionAssistanceRecordList.__size)
	return self
end

function LegionAssistanceRecordList:updateRecord()
	-- "time": 123456789101,
	-- "donor": "哈哈哈",
	-- "beneficiary": "呵呵呵",
	-- "propId": 1234
	local recordTime = tonumber(self.recordInfo.data.time) / 1000

	local nowTime = getBaseGTM8Time(_ED.system_time + (os.time() - _ED.native_time))
	local gmtTime = getBaseGTM8Time(recordTime)

	local nowTimeStruct = FormatUnixTime2Date(nowTime)
	local nowYear = nowTimeStruct.year
	local nowMonth = nowTimeStruct.month
	local nowDay = nowTimeStruct.day

	local recordTimeStruct = FormatUnixTime2Date(gmtTime)
	local recordYear = recordTimeStruct.year
	local recordMonth = recordTimeStruct.month
	local recordDay = recordTimeStruct.day

	-- print("nowYear = ", nowYear, " recordYear = ", recordYear, "nowMonth = ", nowMonth, " recordMonth = ", recordMonth, "nowDay = ", nowDay, " recordDay = ", recordDay)

	local timeStr = ""
	if (nowYear == recordYear) and (nowMonth == recordMonth) and (nowDay == recordDay) then
		timeStr = string.format("%02d:%02d", recordTimeStruct.hour, recordTimeStruct.minute)
	else
		timeStr = tipStringInfo_union_donation_tip[1]
	end
	self.Text_time:setString(timeStr)

	self.Text_player_name_1:setString(self.recordInfo.data.donor)
	self.Text_player_name_2:setString(self.recordInfo.data.beneficiary)

	local name = setThePropsIcon(tonumber(self.recordInfo.data.propId))[2]
	self.Text_props:setString(name)
end

function LegionAssistanceRecordList:onUpdateDraw()
	local root = self.roots[1]

	-- 时间显示
	self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")

	-- 捐赠者id
	self.Text_player_name_1 = ccui.Helper:seekWidgetByName(root, "Text_player_name_1")

	-- 接受者id
	self.Text_player_name_2 = ccui.Helper:seekWidgetByName(root, "Text_player_name_2")

	-- 道具名称
	self.Text_props = ccui.Helper:seekWidgetByName(root, "Text_props")

	self:updateRecord()
end

function LegionAssistanceRecordList:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
	self.Text_time:setString("")

	self.Text_player_name_1 = ccui.Helper:seekWidgetByName(root, "Text_player_name_1")
	self.Text_player_name_1:setString("")

	self.Text_player_name_2 = ccui.Helper:seekWidgetByName(root, "Text_player_name_2")
	self.Text_player_name_2:setString("")

	self.Text_props = ccui.Helper:seekWidgetByName(root, "Text_props")
	self.Text_props:setString("")
end

function LegionAssistanceRecordList:onEnterTransitionFinish()
	
end

function LegionAssistanceRecordList:onInit(params)
	-- 加载LegionAssistanceRecordListWindow界面资源.
	-- res.legion.legion_assistance_record_list = res/legion/legion_assistance_record_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("legion/legion_assistance_record_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("legion/legion_assistance_record_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if LegionAssistanceRecordList.__size == nil then
		LegionAssistanceRecordList.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function LegionAssistanceRecordList:onExit()
	-- 释放LegionAssistanceRecordListWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("legion/legion_assistance_record_list.csb", root)
	-- ]]
end

function LegionAssistanceRecordList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function LegionAssistanceRecordList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("legion/legion_assistance_list.csb", root)
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
