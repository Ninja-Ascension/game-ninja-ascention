--[[ ----------------------------------------------------------------------------
-- 队内玩家信息
--]] ----------------------------------------------------------------------------
TeamArenaTeamList2 = class("TeamArenaTeamList2Class", Window)
TeamArenaTeamList2.__size = nil

-- 创建Cell实例
local team_arena_team_list2_create_terminal = {
	_name = "team_arena_team_list2_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if TeamArenaTeamList2 then
			local cell = TeamArenaTeamList2:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_team_list2_create_terminal)
state_machine.init()

-- 构造器
function TeamArenaTeamList2:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize team arena team list2 page state machine.
	local function init_team_arena_team_list2_terminal()

		
	end
	-- call func init team arena team list2 state machine.
	init_team_arena_team_list2_terminal()
end

-- 对象初始化
function TeamArenaTeamList2:init(params)
	self.data = params
	self:onInit(params)
	self:setContentSize(TeamArenaTeamList2.__size)
	return self
end

function TeamArenaTeamList2:onUpdateDraw()
	local root = self.roots[1]
		
	-- 玩家头像
	self.Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
	self.Panel_player_icon:setTouchEnabled(false)
	self.Panel_player_icon:setBackGroundImage("images/ui/play/arena/team_arena/icon_add.png")
	-- if self.data.userId then 
	-- 	fwin:addTouchEventListener(self.Panel_player_icon, nil,
	-- 	{
	-- 		terminal_name = "init_team_arena_team_list2_pop",
	-- 		terminal_state = 0,
	-- 		isPressedActionEnabled = true,
	-- 	}, nil, 0)
	-- else
	-- 	fwin:addTouchEventListener(self.Panel_player_icon, nil,
	-- 	{
	-- 		terminal_name = "team_arena_ask2_window_open",
	-- 		terminal_state = 0,
	-- 		isPressedActionEnabled = true,
	-- 	}, nil, 0)
	-- end

	self.Image_6 = ccui.Helper:seekWidgetByName(root, "Image_6")
	self.Image_6:setVisible(false)
				
	-- 玩家战力
	self.Text_fight_n = ccui.Helper:seekWidgetByName(root, "Text_fight_n")
	self.Text_fight_n:setVisible(false)

	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	self.Text_name:setVisible(false)

	if self.data.userId then 
		-- self.Panel_player_icon:setTouchEnabled(false)
		local playerIconStr = nil
		if tonumber(self.data.headPic) >= 9 then
			playerIconStr = string.format("images/ui/props/props_%s.png", self.data.headPic)
		else
			playerIconStr = string.format("images/ui/home/head_%s.png", self.data.headPic)
		end
		self.Panel_player_icon:setBackGroundImage(playerIconStr)

		-- 玩家名字
		self.Text_name:setString(self.data.nickName)
		self.Text_name:setVisible(true)

		
		self.Text_fight_n:setString(self.data.combat)
		self.Text_fight_n:setVisible(true)
		self.Image_6:setVisible(true)

	end

end

function TeamArenaTeamList2:onEnterTransitionFinish()
	
end

function TeamArenaTeamList2:onInit(params)
	-- 加载TeamArenaTeamList2Window界面资源.
	-- res.campaign.team_arena.team_arena_team_list_2 = res/campaign/team_arena/team_arena_team_list_2.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("campaign/team_arena/team_arena_team_list_2.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("campaign/team_arena/team_arena_team_list_2.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if TeamArenaTeamList2.__size == nil then
		TeamArenaTeamList2.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function TeamArenaTeamList2:onExit()
	-- 释放TeamArenaTeamList2Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("campaign/team_arena/team_arena_team_list_2.csb", root)
	-- ]]
end

function TeamArenaTeamList2:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function TeamArenaTeamList2:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self.Panel_player_icon:removeBackGroundImage()
	self.Text_fight_n:setVisible(false)
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("campaign/team_arena/team_arena_team_list_2.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
