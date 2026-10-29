--[[ ----------------------------------------------------------------------------
-- 主界面列表项
--]] ----------------------------------------------------------------------------
TeamArenaRole = class("TeamArenaRoleClass", Window)
TeamArenaRole.__size = nil

-- 创建Cell实例
local team_arena_role_create_terminal = {
	_name = "team_arena_role_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if TeamArenaRole then
			local cell = TeamArenaRole:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_role_create_terminal)
state_machine.init()

-- 构造器
function TeamArenaRole:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize team arena role page state machine.
	local function init_team_arena_role_terminal()
		
	end
	-- call func init team arena role state machine.
	init_team_arena_role_terminal()
end

-- 对象初始化
function TeamArenaRole:init(params)
	self.data = params
	self:onInit(params)
	self:setContentSize(TeamArenaRole.__size)
	return self
end

function TeamArenaRole:onUpdateDraw()
	local root = self.roots[1]

	self.Text_role_name = ccui.Helper:seekWidgetByName(root, "Text_role_name")
	self.Text_role_name:setString(self.data.teamName)

	self.Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
	self.Text_5:setString(self.data.combat)

	self.Text_server_n = ccui.Helper:seekWidgetByName(root, "Text_server_n")
	local num = GetServerNameByServerNumber(self.data.serverNum)
	
	self.Text_server_n:setString(num)

	self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
	self.Text_2:setString(self.data.ranking)

	-- 积分
	local Text_point_n = ccui.Helper:seekWidgetByName(root, "Text_point_n")
	Text_point_n:setString(self.data.integral)

	
	-- 玩家1头像
	local playerIconStr = nil
	local playerData = nil
	self.Panel_player_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_item_1")
	if self.data.player1.headPic then 
		playerData = self.data.player1
		self.Panel_player_icon_1:removeBackGroundImage()
		if tonumber(playerData.headPic) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", playerData.headPic)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", playerData.headPic)
		end
		self.Panel_player_icon_1:setBackGroundImage(playerIconStr)
	end
	-- 玩家2头像
	self.Panel_player_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_item_2")
	if self.data.player2.headPic then 
		playerData = self.data.player2
		self.Panel_player_icon_2:removeBackGroundImage()
		if tonumber(playerData.headPic) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", playerData.headPic)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", playerData.headPic)
		end
		self.Panel_player_icon_2:setBackGroundImage(playerIconStr)
	end
	-- 玩家3头像
	self.Panel_player_icon_3 = ccui.Helper:seekWidgetByName(root, "Panel_item_3")
	if self.data.player3.headPic then 
		playerData = self.data.player3
		self.Panel_player_icon_3:removeBackGroundImage()
		if tonumber(playerData.headPic) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", playerData.headPic)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", playerData.headPic)
		end
		self.Panel_player_icon_3:setBackGroundImage(playerIconStr)
	end

	self.Panel_player_icon_1:setTouchEnabled(false)
	self.Panel_player_icon_2:setTouchEnabled(false)
	self.Panel_player_icon_3:setTouchEnabled(false)

	local function func_showinfo(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			state_machine.excute("team_arena_enemy_window_open",0, self.data)
		end
	end
	
	ccui.Helper:seekWidgetByName(root, "Panel_2"):addTouchEventListener(func_showinfo)

end

function TeamArenaRole:onEnterTransitionFinish()
	
end

function TeamArenaRole:onInit(params)
	-- 加载TeamArenaRoleWindow界面资源.
	-- res.campaign.team_arena.team_arena_role = res/campaign/team_arena/team_arena_role.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("campaign/team_arena/team_arena_role.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("campaign/team_arena/team_arena_role.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if TeamArenaRole.__size == nil then
		TeamArenaRole.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function TeamArenaRole:onExit()
	-- 释放TeamArenaRoleWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("campaign/team_arena/team_arena_role.csb", root)
	-- ]]
end

function TeamArenaRole:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function TeamArenaRole:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("campaign/team_arena/team_arena_role.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
