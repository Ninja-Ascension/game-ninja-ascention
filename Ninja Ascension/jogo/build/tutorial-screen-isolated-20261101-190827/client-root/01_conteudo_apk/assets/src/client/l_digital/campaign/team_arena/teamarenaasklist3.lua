--[[ ----------------------------------------------------------------------------
-- 发出邀请队伍
--]] ----------------------------------------------------------------------------
TeamArenaAskList3 = class("TeamArenaAskList3Class", Window)
TeamArenaAskList3.__size = nil

-- 创建Cell实例
local team_arena_ask_list3_create_terminal = {
	_name = "team_arena_ask_list3_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if TeamArenaAskList3 then
			local cell = TeamArenaAskList3:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_ask_list3_create_terminal)
state_machine.init()

-- 构造器
function TeamArenaAskList3:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize team arena ask list3 page state machine.
	local function init_team_arena_ask_list3_terminal()
		
	end
	-- call func init team arena ask list3 state machine.
	init_team_arena_ask_list3_terminal()
end

-- 对象初始化
function TeamArenaAskList3:init(params)
	self:onInit(params)
	self:setContentSize(TeamArenaAskList3.__size)
	return self
end

function TeamArenaAskList3:onUpdateDraw()
	local root = self.roots[1]

	-- 玩家1头像
	local playerIconStr = nil
	local playerData = nil
	self.Panel_player_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1")
	if self.data.players[1].headPic then 
		playerData = self.data.players[1]
		self.Panel_player_icon_1:removeBackGroundImage()
		if tonumber(playerData.headPic) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", playerData.headPic)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", playerData.headPic)
		end
		self.Panel_player_icon_1:setBackGroundImage(playerIconStr)
	end
	-- 玩家2头像
	self.Panel_player_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_2")
	if self.data.players[2].headPic then 
		playerData = self.data.players[2]
		self.Panel_player_icon_2:removeBackGroundImage()
		if tonumber(playerData.headPic) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", playerData.headPic)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", playerData.headPic)
		end
		self.Panel_player_icon_2:setBackGroundImage(playerIconStr)
	end
	-- 玩家3头像
	self.Panel_player_icon_3 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_3")
	if self.data.players[3].headPic then 
		playerData = self.data.players[3]
		self.Panel_player_icon_3:removeBackGroundImage()
		if tonumber(playerData.headPic) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", playerData.headPic)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", playerData.headPic)
		end
		self.Panel_player_icon_3:setBackGroundImage(playerIconStr)
	end

	-- 队伍战力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")
	self.Text_craft:setString(self.data.combat)

	-- 队伍名字
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	self.Text_name:setString(self.data.teamName)

end

function TeamArenaAskList3:onEnterTransitionFinish()
	
end

function TeamArenaAskList3:onInit(params)
	-- 加载TeamArenaAskList3Window界面资源.
	-- res.campaign.team_arena.team_arena_ask_list_3 = res/campaign/team_arena/team_arena_ask_list_3.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("campaign/team_arena/team_arena_ask_list_3.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("campaign/team_arena/team_arena_ask_list_3.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if TeamArenaAskList3.__size == nil then
		TeamArenaAskList3.__size = root:getContentSize()
	end
	self.data = params.data
	self.pos = params.pos
	-- 拒绝
	self.Button_refuse = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refuse"), nil,
	{
		terminal_name = "team_arena_ask3_handle",
		terminal_state = 0,
		isPressedActionEnabled = true,
		type = 0,
		pos = self.pos,
	}, nil, 0)	

	-- 同意
	self.Button_agree = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_agree"), nil,
	{
		terminal_name = "team_arena_ask3_handle",
		terminal_state = 0,
		isPressedActionEnabled = true,
		type = 1,
		pos = self.pos,
	}, nil, 0)	


	self:onUpdateDraw()
end

function TeamArenaAskList3:onExit()
	-- 释放TeamArenaAskList3Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("campaign/team_arena/team_arena_ask_list_3.csb", root)
	-- ]]
end

function TeamArenaAskList3:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function TeamArenaAskList3:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("campaign/team_arena/team_arena_ask_list_3.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
