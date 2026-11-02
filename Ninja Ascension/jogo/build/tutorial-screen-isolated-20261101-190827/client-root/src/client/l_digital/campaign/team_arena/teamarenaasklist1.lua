--[[ ----------------------------------------------------------------------------
-- 申请的玩家
--]] ----------------------------------------------------------------------------
TeamArenaAskList1 = class("TeamArenaAskList1Class", Window)
TeamArenaAskList1.__size = nil

-- 创建Cell实例
local team_arena_ask_list1_create_terminal = {
	_name = "team_arena_ask_list1_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if TeamArenaAskList1 then
			local cell = TeamArenaAskList1:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_ask_list1_create_terminal)
state_machine.init()

-- 构造器
function TeamArenaAskList1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize team arena ask list1 page state machine.
	local function init_team_arena_ask_list1_terminal()
		
	end
	-- call func init team arena ask list1 state machine.
	init_team_arena_ask_list1_terminal()
end

-- 对象初始化
function TeamArenaAskList1:init(params)
	self:onInit(params)
	self:setContentSize(TeamArenaAskList1.__size)
	return self
end

function TeamArenaAskList1:onUpdateDraw()
	local root = self.roots[1]

	-- 玩家头像
	self.Panel_player_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1")
	-- 头像
	self.Panel_player_icon_1:removeBackGroundImage()
	local playerIconStr = nil
	if tonumber(self.data.headPic) >= 9 then
		playerIconStr = string.format("images/ui/props/props_%s.png", self.data.headPic)
	else
		playerIconStr = string.format("images/ui/home/head_%s.png", self.data.headPic)
	end
	self.Panel_player_icon_1:setBackGroundImage(playerIconStr)
	-- 玩家战力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")
	self.Text_craft:setString(self.data.combat)
	-- 玩家名字
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	self.Text_name:setString(self.data.nickName)

	-- 玩家等级
	self.Text_level_n = ccui.Helper:seekWidgetByName(root, "Text_level_n")
	self.Text_level_n:setString(self.data.level)

	-- @Text_nothing
	-- self.Text_nothing = ccui.Helper:seekWidgetByName(root, "Text_nothing")

end

function TeamArenaAskList1:onEnterTransitionFinish()
	
end

function TeamArenaAskList1:onInit(params)
	-- 加载TeamArenaAskList1Window界面资源.
	-- res.campaign.team_arena.team_arena_ask_list_1 = res/campaign/team_arena/team_arena_ask_list_1.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("campaign/team_arena/team_arena_ask_list_1.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("campaign/team_arena/team_arena_ask_list_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if TeamArenaAskList1.__size == nil then
		TeamArenaAskList1.__size = root:getContentSize()
	end

	self.data = params.data
	self.pos = params.pos

	-- 拒绝
	self.Button_refuse = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refuse"), nil,
	{
		terminal_name = "team_arena_ask1_handle",
		terminal_state = 0,
		isPressedActionEnabled = true,
		type = 0,
		pos = self.pos,
	}, nil, 0)	

	-- 同意
	self.Button_agree = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_agree"), nil,
	{
		terminal_name = "team_arena_ask1_handle",
		terminal_state = 0,
		isPressedActionEnabled = true,
		type = 1,
		pos = self.pos,
	}, nil, 0)	


	self:onUpdateDraw()
end

function TeamArenaAskList1:onExit()
	-- 释放TeamArenaAskList1Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("campaign/team_arena/team_arena_ask_list_1.csb", root)
	-- ]]
end

function TeamArenaAskList1:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function TeamArenaAskList1:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("campaign/team_arena/team_arena_ask_list_1.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
