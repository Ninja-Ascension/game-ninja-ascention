--[[ ----------------------------------------------------------------------------
-- 申请的玩家
--]] ----------------------------------------------------------------------------
TeamArenaTeamList1 = class("TeamArenaTeamList1Class", Window)
TeamArenaTeamList1.__size = nil

-- 创建Cell实例
local team_arena_team_list1_create_terminal = {
	_name = "team_arena_team_list1_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if TeamArenaTeamList1 then
			local cell = TeamArenaTeamList1:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_team_list1_create_terminal)
state_machine.init()

-- 构造器
function TeamArenaTeamList1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize team arena team list1 page state machine.
	local function init_team_arena_team_list1_terminal()
		
	end
	-- call func init team arena team list1 state machine.
	init_team_arena_team_list1_terminal()
end

-- 对象初始化
function TeamArenaTeamList1:init(params)
	self.data = params
	self:onInit(params)
	self:setContentSize(TeamArenaTeamList1.__size)
	return self
end

function TeamArenaTeamList1:onUpdateDraw()
	local root = self.roots[1]

	debug.print_r(self.data,"team list1 data")
	-- 队伍名称
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	self.Text_name:setString(self.data.teamName)
	-- 战力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")
	self.Text_craft:setString(self.data.combat)

	-- 要求战力
	self.Text_craft_0 = ccui.Helper:seekWidgetByName(root, "Text_craft_0")
	self.Text_craft_0:setString(self.data.joinLimit)

	-- 已申请
	self.Image_applied = ccui.Helper:seekWidgetByName(root, "Image_applied")

	local serverNum = self.data.serverNum

	-- 玩家1头像
	local playerIconStr = nil
	local playerData = nil
	self.Panel_player_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1")
	self.Panel_player_icon_1:removeBackGroundImage()
	self.Panel_player_icon_1:removeAllChildren(true)
	if self.data.players[1].headPic then 
		playerData = self.data.players[1]
		if tonumber(playerData.headPic) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", playerData.headPic)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", playerData.headPic)
		end
		local sprit = cc.Sprite:create(playerIconStr)
		sprit:setAnchorPoint(cc.p(0.5,0.5))
		sprit:setPosition(cc.p(self.Panel_player_icon_1:getContentSize().width / 2, self.Panel_player_icon_1:getContentSize().height / 2))
		self.Panel_player_icon_1:addChild(sprit,0)

		local function func_showinfo(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				state_machine.excute("team_arena_player_info_show_window_open",0, {self.data.players[1], serverNum})
			end
		end
		fwin:addTouchEventListener(self.Panel_player_icon_1, func_showinfo)
	else
		fwin:removeTouchEventListener(self.Panel_player_icon_1)
		self.Panel_player_icon_1:setBackGroundImage("images/ui/play/arena/team_arena/icon_nobody.png")
	end
	-- 玩家2头像
	self.Panel_player_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_2")
	self.Panel_player_icon_2:removeBackGroundImage()
	self.Panel_player_icon_2:removeAllChildren(true)
	if self.data.players[2].headPic then 
		playerData = self.data.players[2]
		if tonumber(playerData.headPic) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", playerData.headPic)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", playerData.headPic)
		end
		local sprit = cc.Sprite:create(playerIconStr)
		sprit:setAnchorPoint(cc.p(0.5,0.5))
		sprit:setPosition(cc.p(self.Panel_player_icon_2:getContentSize().width / 2, self.Panel_player_icon_2:getContentSize().height / 2))
		self.Panel_player_icon_2:addChild(sprit,0)

		local function func_showinfo(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				state_machine.excute("team_arena_player_info_show_window_open",0, {self.data.players[2], serverNum})
			end
		end
		fwin:addTouchEventListener(self.Panel_player_icon_2, func_showinfo)
	else
		fwin:removeTouchEventListener(self.Panel_player_icon_2)
		self.Panel_player_icon_2:setBackGroundImage("images/ui/play/arena/team_arena/icon_nobody.png")
	end
	-- 玩家3头像
	self.Panel_player_icon_3 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_3")
	self.Panel_player_icon_3:removeBackGroundImage()
	self.Panel_player_icon_3:removeAllChildren(true)
	if self.data.players[3].headPic then 
		playerData = self.data.players[3]
		if tonumber(playerData.headPic) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", playerData.headPic)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", playerData.headPic)
		end
		local sprit = cc.Sprite:create(playerIconStr)
		sprit:setAnchorPoint(cc.p(0.5,0.5))
		sprit:setPosition(cc.p(self.Panel_player_icon_3:getContentSize().width / 2, self.Panel_player_icon_3:getContentSize().height / 2))
		self.Panel_player_icon_3:addChild(sprit,0)

		local function func_showinfo(sender, eventType)
			if eventType == ccui.TouchEventType.ended then
				state_machine.excute("team_arena_player_info_show_window_open",0, {self.data.players[3], serverNum})
			end
		end
		fwin:addTouchEventListener(self.Panel_player_icon_3, func_showinfo)
	else
		fwin:removeTouchEventListener(self.Panel_player_icon_3)
		self.Panel_player_icon_3:setBackGroundImage("images/ui/play/arena/team_arena/icon_nobody.png")
	end
end

function TeamArenaTeamList1:onEnterTransitionFinish()
	
end

function TeamArenaTeamList1:onInit(params)
	-- 加载TeamArenaTeamList1Window界面资源.
	-- res.campaign.team_arena.team_arena_team_list_1 = res/campaign/team_arena/team_arena_team_list_1.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("campaign/team_arena/team_arena_team_list_1.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("campaign/team_arena/team_arena_team_list_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if TeamArenaTeamList1.__size == nil then
		TeamArenaTeamList1.__size = root:getContentSize()
	end

	-- 申请
	self.Button_apply = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_apply"), nil,
	{
		terminal_name = "team_arena_team1_invite",
		terminal_state = 0,
		isPressedActionEnabled = true,
		teamid = self.data.teamId
	}, nil, 0)	


	self:onUpdateDraw()
end

function TeamArenaTeamList1:onExit()
	-- 释放TeamArenaTeamList1Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("campaign/team_arena/team_arena_team_list_1.csb", root)
	-- ]]
end

function TeamArenaTeamList1:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function TeamArenaTeamList1:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("campaign/team_arena/team_arena_team_list_1.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
