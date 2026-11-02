--[[ ----------------------------------------------------------------------------
-- 可以邀请的好友
--]] ----------------------------------------------------------------------------
TeamArenaAskList2 = class("TeamArenaAskList2Class", Window)
TeamArenaAskList2.__size = nil

-- 创建Cell实例
local team_arena_ask_list2_create_terminal = {
	_name = "team_arena_ask_list2_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if TeamArenaAskList2 then
			local cell = TeamArenaAskList2:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_ask_list2_create_terminal)
state_machine.init()

-- 构造器
function TeamArenaAskList2:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize team arena ask list2 page state machine.
	local function init_team_arena_ask_list2_terminal()
		
	end
	-- call func init team arena ask list2 state machine.
	init_team_arena_ask_list2_terminal()
end

-- 对象初始化
function TeamArenaAskList2:init(params)
	self.data = params
	self:onInit(params)
	self:setContentSize(TeamArenaAskList2.__size)
	return self
end

function TeamArenaAskList2:onUpdateDraw()
	local root = self.roots[1]

	-- 玩家头像
	local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1")
	Panel_head:removeAllChildren(true)
	local playerIconStr = nil
	if tonumber(self.data.headPic) >= 9 then
		playerIconStr = string.format("images/ui/props/props_%s.png", self.data.headPic)
	else
		playerIconStr = string.format("images/ui/home/head_%s.png", self.data.headPic)
	end
	local sprit = cc.Sprite:create(playerIconStr)
	sprit:setAnchorPoint(cc.p(0.5,0.5))
	sprit:setPosition(cc.p(Panel_head:getContentSize().width / 2, Panel_head:getContentSize().height / 2))
	Panel_head:addChild(sprit,0)
	
	local function func_showinfo(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			state_machine.excute("team_arena_info_showwindow_open",0, self.data)
		end
	end
	Panel_head:addTouchEventListener(func_showinfo)
	-- 玩家战力
	self.Text_craft = ccui.Helper:seekWidgetByName(root, "Text_craft")
	self.Text_craft:setString(self.data.combat)
	-- 玩家名字
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	self.Text_name:setString(self.data.nickName)

	-- 玩家等级
	self.Text_level_n = ccui.Helper:seekWidgetByName(root, "Text_level_n")
	self.Text_level_n:setString(self.data.level)

end

function TeamArenaAskList2:onEnterTransitionFinish()
	
end

function TeamArenaAskList2:onInit(params)
	-- 加载TeamArenaAskList2Window界面资源.
	-- res.campaign.team_arena.team_arena_ask_list_2 = res/campaign/team_arena/team_arena_ask_list_2.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("campaign/team_arena/team_arena_ask_list_2.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("campaign/team_arena/team_arena_ask_list_2.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if TeamArenaAskList2.__size == nil then
		TeamArenaAskList2.__size = root:getContentSize()
	end

	-- 邀请
	self.Button_invite = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_invite"), nil,
	{
		terminal_name = "team_arena_ask2_invite",
		terminal_state = 0,
		isPressedActionEnabled = true,
		userid = self.data.userId,
	}, nil, 0)	


	self:onUpdateDraw()
end

function TeamArenaAskList2:onExit()
	-- 释放TeamArenaAskList2Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("campaign/team_arena/team_arena_ask_list_2.csb", root)
	-- ]]
end

function TeamArenaAskList2:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function TeamArenaAskList2:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("campaign/team_arena/team_arena_ask_list_2.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
