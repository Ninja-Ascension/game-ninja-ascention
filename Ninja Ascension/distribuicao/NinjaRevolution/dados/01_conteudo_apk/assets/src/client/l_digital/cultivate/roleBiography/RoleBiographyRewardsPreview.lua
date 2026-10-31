--[[ ----------------------------------------------------------------------------
-- 奖励预览界面
--]] ----------------------------------------------------------------------------
RoleBiographyRewardsPreview = class("RoleBiographyRewardsPreviewClass", Window)

-- 打开窗口
local role_biography_rewards_preview_window_open_terminal = {
	_name = "role_biography_rewards_preview_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyRewardsPreviewClass") then
			fwin:open(RoleBiographyRewardsPreview:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_rewards_preview_window_close_terminal = {
	_name = "role_biography_rewards_preview_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyRewardsPreviewClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_rewards_preview_window_open_terminal)
state_machine.add(role_biography_rewards_preview_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyRewardsPreview:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies rewards page state machine.
	local function init_role_biography_rewards_preview_terminal()
		-- 打开角色创建窗口
		local role_biography_rewards_preview_open_terminal = {
			_name = "role_biography_rewards_preview_open",
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
		local role_biography_rewards_preview_close_terminal = {
			_name = "role_biography_rewards_preview_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_rewards_preview_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_rewards_preview_show_terminal = {
			_name = "role_biography_rewards_preview_show",
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
		local role_biography_rewards_preview_hide_terminal = {
			_name = "role_biography_rewards_preview_hide",
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

		state_machine.add(role_biography_rewards_preview_open_terminal)
		state_machine.add(role_biography_rewards_preview_close_terminal)
		state_machine.add(role_biography_rewards_preview_show_terminal)
		state_machine.add(role_biography_rewards_preview_hide_terminal)
		state_machine.init()
	end
	-- call func init ninja biographies rewards state machine.
	init_role_biography_rewards_preview_terminal()
end

-- 对象初始化
function RoleBiographyRewardsPreview:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RoleBiographyRewardsPreview:onUpdateDraw()
	local root = self.roots[1]

	-- 奖励容器
	local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
	self.ListView_1 = ListView_1
	ListView_1:removeAllItems()

	local result = {}
	local tempResultSet = {}
	local allRewareds = RoleBiographyHandle.getBiographyDrawRewardsInfo()
	for _, v in pairs(allRewareds) do
		local propId = tonumber(v[2])
		-- print("propId = ", propId)

		if not tempResultSet[propId] then
			local quality = dms.int(dms["prop_mould"], propId, prop_mould.prop_quality) + 1

			if result[quality] == nil then
				result[quality] = {}
			end
			table.insert(result[quality], v)
			
			tempResultSet[propId] = true
		end
	end

	local function fightingCapacity(a, b)
		local al = dms.int(dms["prop_mould"], tonumber(a[2]), prop_mould.trace_scene)
		local bl = dms.int(dms["prop_mould"], tonumber(b[2]), prop_mould.trace_scene)
		local result = false
		if al < bl then
			result = true
		end
		return result 
	end

	local index = 0
	-- 7种品质
	for i = 7, 1, -1 do
		local quality = i
		local rewards = result[quality] or {}
		local rewardCount = table.nums(rewards)

		if rewardCount > 0 then
			table.sort(rewards, fightingCapacity)

			-- index = index + 1

			local cellTitle = state_machine.excute("role_biography_rewards_preview_cell_1_create", 0, {index = index, quality = quality})
			ListView_1:addChild(cellTitle)

			local coloum = 5
			local result = {}
			local index = 1

			local function pushData(index, data)
				if result[index] == nil then
					result[index] = {}
				end
				if #result[index] < coloum then
					table.insert(result[index], data)
				else
					index = index + 1
					pushData(index, data)
				end
			end

			for _, v in ipairs(rewards) do
				pushData(index, v)
			end

			for _, v in ipairs(result) do
				index = index + 1

				local cell = state_machine.excute("role_biography_rewards_preview_cell_2_create", 0, {index = index, data = v})
				ListView_1:addChild(cell)
			end
		end
	end

	self.ListView_1_poy = ListView_1:getInnerContainer():getPositionY()

	ListView_1:jumpToTop()
	ListView_1:requestRefreshView()
end

-- @onUpdate(dt)
function RoleBiographyRewardsPreview:onUpdate(dt)
	-- if self.ListView_1 ~= nil then
	-- 	local size = self.ListView_1:getContentSize()
	-- 	local posY = self.ListView_1:getInnerContainer():getPositionY()
	-- 	if self.ListView_1_poy == posY then
	-- 		return
	-- 	end
	-- 	self.ListView_1_poy = posY
	-- 	local items = self.ListView_1:getItems()
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

function RoleBiographyRewardsPreview:onEnterTransitionFinish()
	-- 加载RoleBiographyRewardsPreviewWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_rewards = res/cultivate/ninja_biographies/ninja_biographies_rewards.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_rewards.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "role_biography_rewards_preview_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function RoleBiographyRewardsPreview:onExit()
	-- 释放RoleBiographyRewardsPreviewWindow界面资源.
	state_machine.remove("role_biography_rewards_preview_open")
	state_machine.remove("role_biography_rewards_preview_close")
	state_machine.remove("role_biography_rewards_preview_show")
	state_machine.remove("role_biography_rewards_preview_hide")
end

function RoleBiographyRewardsPreview:close()
	-- window event : close.
	
end

function RoleBiographyRewardsPreview:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
