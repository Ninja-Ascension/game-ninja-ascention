-- -----------------------------------------------------------------------------
-- 说明：头衔
-- -----------------------------------------------------------------------------
SmTitleInfoWindow = class("SmTitleInfoWindowClass", Window)
local sm_title_info_window_open_terminal = {
	_name = "sm_title_info_window_open",
	_init = function (terminal) 
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params) 
		local _window = fwin:find("SmTitleInfoWindowClass")
		if _window == nil then
			fwin:open(SmTitleInfoWindow:new(), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭
local sm_title_info_window_close_terminal = {
	_name = "sm_title_info_window_close",
	_init = function (terminal) 
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params) 
		fwin:close(fwin:find("SmTitleInfoWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(sm_title_info_window_open_terminal)
state_machine.add(sm_title_info_window_close_terminal)
state_machine.init()
	
function SmTitleInfoWindow:ctor()
	self.super:ctor()
	self.roots = {}
   	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.l_digital.cells.player.role_information_title_cell")
	
	local function init_sm_title_info_window_terminal()
		
		state_machine.init()
	end
	
	init_sm_title_info_window_terminal()
end

function SmTitleInfoWindow:onUpdateDraw()
	local root = self.roots[1]

	local openTitles = {}
	local closeTitles = {}

	for i, v in pairs(_ED.user_rank_title_info._title_infos) do
		if "0" == v[2] then
			table.insert(closeTitles, v)
		else
			table.insert(openTitles, v)
		end
	end

	-- 加入一个无称号的按钮
	-- if #openTitles > 1 then
	-- 	openTitles[#openTitles + 1] = {"0", "-1"}
	-- end

	openTitles[#openTitles + 1] = {"0", "-1"}

	-- 开启的头衔
	local ScrollView_blacklist = ccui.Helper:seekWidgetByName(root, "ScrollView_blacklist")
	local size = ScrollView_blacklist:getContentSize()
	local height = math.max(size.height, (#openTitles / 2 + 1) * size.height / 3)
	ScrollView_blacklist:setInnerContainerSize(cc.size(size.width, height))
	-- local openCount = #openTitles
	-- for i = 1, openCount do
	-- 	local v = openTitles[openCount - i + 1]
	for i, v in pairs(openTitles) do
		local cell = state_machine.excute("role_information_title_cell_create", 0, v)
		cell:setPosition( cc.p( ((i - 1) % 2) * size.width / 2 + (size.width / 2 - RoleInformationTitleCell.__size.width) / 2, height - (math.floor((i - 1) / 2) + 1) * size.height / 3 ) )
		ScrollView_blacklist:addChild(cell)
	end

	-- 未开启的头衔
	local ScrollView_blacklist_0 = ccui.Helper:seekWidgetByName(root, "ScrollView_blacklist_0")
	local size0 = ScrollView_blacklist_0:getContentSize()
	local height0 = math.max(size0.height, (#closeTitles / 2 + 1) * size.height / 3)
	ScrollView_blacklist_0:setInnerContainerSize(cc.size(size.width, height0))
	-- local closeCount = #closeTitles
	-- for i = 1, closeCount do
	-- 	local v = closeTitles[closeCount - i + 1]
	for i, v in pairs(closeTitles) do
		local cell = state_machine.excute("role_information_title_cell_create", 0, v)
		cell:setPosition( cc.p( ((i - 1) % 2) * size0.width / 2 + (size.width / 2 - RoleInformationTitleCell.__size.width) / 2, height0 - (math.floor((i - 1) / 2) + 1) * size0.height / 3 ) )
		ScrollView_blacklist_0:addChild(cell)
	end
end

function SmTitleInfoWindow:onEnterTransitionFinish()
	local csbNode = csb.createNode("player/role_information_title.csb")
	self:addChild(csbNode)
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)

	local action = csb.createTimeline("player/role_information_title.csb")
	table.insert(self.actions, action)
	csbNode:runAction(action)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
	{
		terminal_name = "sm_title_info_window_close",	 
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)

	self:onUpdateDraw()
end

function SmTitleInfoWindow:onExit()

end

function SmTitleInfoWindow:destroy( window )
	if nil ~= sp.SkeletonRenderer.clear then
		sp.SkeletonRenderer:clear()
	end
	audioUtilUncacheAll()
	cacher.cleanSystemCacher()
end
-- ~end
-- -----------------------------------------------------------------------------