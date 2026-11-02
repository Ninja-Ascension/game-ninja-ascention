--[[ ----------------------------------------------------------------------------
-- 荣誉排名界面
--]] ----------------------------------------------------------------------------
RoleBiographyRank = class("RoleBiographyRankClass", Window)

-- 打开窗口
local role_biography_rank_window_open_terminal = {
	_name = "role_biography_rank_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyRankClass") then
			fwin:open(RoleBiographyRank:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_rank_window_close_terminal = {
	_name = "role_biography_rank_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyRankClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_rank_window_open_terminal)
state_machine.add(role_biography_rank_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyRank:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies report page state machine.
	local function init_role_biography_rank_terminal()
		-- 打开角色创建窗口
		local role_biography_rank_open_terminal = {
			_name = "role_biography_rank_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local role_biography_rank_close_terminal = {
			_name = "role_biography_rank_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_rank_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_rank_show_terminal = {
			_name = "role_biography_rank_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local role_biography_rank_hide_terminal = {
			_name = "role_biography_rank_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		local role_biography_rank_change_terminal = {
			_name = "role_biography_rank_change",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local tabType = params._datas._tabType

					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							-- 刷新界面
							instance:updateRankList(tabType)
						end
					end
					protocol_command.biographies_rank.param_list = "" .. tabType
					NetworkManager:register(protocol_command.biographies_rank.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(role_biography_rank_open_terminal)
		state_machine.add(role_biography_rank_close_terminal)
		state_machine.add(role_biography_rank_show_terminal)
		state_machine.add(role_biography_rank_hide_terminal)
		state_machine.add(role_biography_rank_change_terminal)
		state_machine.init()
	end
	-- call func init ninja biographies report state machine.
	init_role_biography_rank_terminal()
end

-- 对象初始化
function RoleBiographyRank:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RoleBiographyRank:updateUI()
	self:updateRankList(0)
end

function RoleBiographyRank:updateRankList(tabType)
	self.Button_bfpm:setTouchEnabled(tabType ~= 0)
	self.Button_bfpm:setHighlighted(tabType == 0)
	self.Button_kfpm:setTouchEnabled(tabType ~= 1)
	self.Button_kfpm:setHighlighted(tabType == 1)
	-- DSC按钮文字特殊显示
	if __lua_project_id == __lua_project_l_digital and self.Text_bfpm_0 and self.Text_kfpm_0 then 
		self.Text_bfpm:setVisible(tabType == 0)
		self.Text_bfpm_0:setVisible(tabType ~= 0)
		self.Text_kfpm:setVisible(tabType == 1)
		self.Text_kfpm_0:setVisible(tabType ~= 1)
	end
	local ListView_zhanbao = self.ListView_zhanbao
	ListView_zhanbao:removeAllItems()

	local data = RoleBiographyHandle.getBiographyRankInfo()
	for i, v in ipairs(data) do
		local cell = state_machine.excute("role_biography_rank_cell_create", 0, {index = i, data = v})
		ListView_zhanbao:addChild(cell)
	end

	self.ListView_zhanbao_poy = self.ListView_zhanbao:getInnerContainer():getPositionY()

	ListView_zhanbao:jumpToTop()
	ListView_zhanbao:requestRefreshView()

	local myRank = RoleBiographyHandle.getBiographyMyRank()
	if tonumber(myRank) ~= -1 then
		self.Text_1_0:setString(myRank)
	else
		self.Text_1_0:setString(tipStringInfo_role_biography[12])
	end
	

	local curAchieveValue = RoleBiographyHandle.getCurAchievementValue()
	self.Text_2_0:setString(curAchieveValue)

	local info = RoleBiographyHandle.getAllBiographyInfo()
	self.Text_3_0:setString(table.nums(info))
end

function RoleBiographyRank:onUpdateDraw()
	local root = self.roots[1]

	-- 荣誉排名容器
	self.ListView_zhanbao = ccui.Helper:seekWidgetByName(root, "ListView_zhanbao")

	-- 我的排名数值
	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")

	-- 我的荣誉数值
	self.Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")

	-- 已激活的图鉴数量
	self.Text_3_0 = ccui.Helper:seekWidgetByName(root, "Text_3_0")

	-- 本服排名文字
	self.Text_bfpm = ccui.Helper:seekWidgetByName(root, "Text_bfpm")
	self.Text_bfpm_0 = ccui.Helper:seekWidgetByName(root, "Text_bfpm_0")
	-- 全服排名文字
	self.Text_kfpm = ccui.Helper:seekWidgetByName(root, "Text_kfpm")
	self.Text_kfpm_0 = ccui.Helper:seekWidgetByName(root, "Text_kfpm_0")

	self:updateUI()
end

-- @onUpdate(dt)
function RoleBiographyRank:onUpdate(dt)
	-- if self.ListView_zhanbao ~= nil then
	-- 	local size = self.ListView_zhanbao:getContentSize()
	-- 	local posY = self.ListView_zhanbao:getInnerContainer():getPositionY()
	-- 	if self.ListView_zhanbao_poy == posY then
	-- 		return
	-- 	end
	-- 	self.ListView_zhanbao_poy = posY
	-- 	local items = self.ListView_zhanbao:getItems()
	-- 	if items[1] == nil then
	-- 		return
	-- 	end
	-- 	local itemSize = items[1]:getContentSize()
	-- 	for i, v in pairs(items) do
	-- 		local tempY = v:getPositionY() + posY
	-- 		if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then	
	-- 			v:unload()
	-- 		else	
	-- 			v:reload()				
	-- 		end
	-- 	end
	-- end
end

function RoleBiographyRank:onEnterTransitionFinish()
	-- 加载RoleBiographyRankWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_report = res/cultivate/ninja_biographies/ninja_biographies_report.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_report.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 本服排名
	self.Button_bfpm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bfpm"), nil,
	{
		terminal_name = "role_biography_rank_change",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_tabType = 0
	}, nil, 0)	

	-- 跨服排名
	self.Button_kfpm = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kfpm"), nil,
	{
		terminal_name = "role_biography_rank_change",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_tabType = 1
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "role_biography_rank_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function RoleBiographyRank:onExit()
	-- 释放RoleBiographyRankWindow界面资源.
	state_machine.remove("role_biography_rank_open")
	state_machine.remove("role_biography_rank_close")
	state_machine.remove("role_biography_rank_show")
	state_machine.remove("role_biography_rank_hide")
	state_machine.remove("role_biography_rank_change")
end

function RoleBiographyRank:close()
	-- window event : close.
	
end

function RoleBiographyRank:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
