--[[ ----------------------------------------------------------------------------
-- 连携
--]] ----------------------------------------------------------------------------
MythicalAnimalsLeague = class("MythicalAnimalsLeagueClass", Window)

-- 打开窗口
local mythical_animals_league_window_open_terminal = {
	_name = "mythical_animals_league_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("MythicalAnimalsLeagueClass") then
			fwin:open(MythicalAnimalsLeague:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local mythical_animals_league_window_close_terminal = {
	_name = "mythical_animals_league_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MythicalAnimalsLeagueClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_league_window_open_terminal)
state_machine.add(mythical_animals_league_window_close_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsLeague:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_mythical_animals_league_terminal()
		-- 打开角色创建窗口
		local mythical_animals_league_open_terminal = {
			_name = "mythical_animals_league_open",
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
		local mythical_animals_league_close_terminal = {
			_name = "mythical_animals_league_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_league_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local mythical_animals_league_show_terminal = {
			_name = "mythical_animals_league_show",
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
		local mythical_animals_league_hide_terminal = {
			_name = "mythical_animals_league_hide",
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

		-- 刷新界面
		local mythical_animals_league_refresh_ui_terminal = {
			_name = "mythical_animals_league_refresh_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_league_open_terminal)
		state_machine.add(mythical_animals_league_close_terminal)
		state_machine.add(mythical_animals_league_show_terminal)
		state_machine.add(mythical_animals_league_hide_terminal)
		state_machine.add(mythical_animals_league_refresh_ui_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_mythical_animals_league_terminal()
end

-- 对象初始化
function MythicalAnimalsLeague:init(params)
	self._animalsMouldId = params

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function MythicalAnimalsLeague:onUpdateDraw()
	local root = self.roots[1]

	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	self:updateUI()
end

function MythicalAnimalsLeague:updateUI()
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	local info = MythicalAnimalsHandle.getMythicalAnimalsLegueInfoById(self._animalsMouldId)

	local leagueMouldIdList = {}
	for _, v in ipairs(dms["magical_animals_relevant_mould"]) do
        local animalIdsStr = dms.atos(v, magical_animals_relevant_mould.animalIds)
        local animalIds = zstring.split(animalIdsStr, ",")

        for _, m in ipairs(animalIds) do
            if self._animalsMouldId == tonumber(m) then
            	local needStar = dms.atof(v, magical_animals_relevant_mould.needStar)
            	table.insert(leagueMouldIdList, {id = dms.atof(v, magical_animals_relevant_mould.id), needStar = needStar})
            end
        end
    end

	table.sort(leagueMouldIdList, function(a, b)
		return a.needStar < b.needStar
	end)

	-- debug.print_r(info, "info")

	for i, v in ipairs(info) do
		local leagueMouldId = leagueMouldIdList[i].id
		local cell = state_machine.excute("mythical_animals_league_cell_create", 0, {index = i, activateState = tonumber(v), leagueMouldId = leagueMouldId})
		ListView_1:addChild(cell)
	end
end

function MythicalAnimalsLeague:onEnterTransitionFinish()
	-- 加载MythicalAnimalsLeagueWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_comb = res/cultivate/Mythical_animals/mythical_animals_comb.csb
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_comb.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "mythical_animals_league_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function MythicalAnimalsLeague:onExit()
	-- 释放MythicalAnimalsLeagueWindow界面资源.
	state_machine.remove("mythical_animals_league_open")
	state_machine.remove("mythical_animals_league_close")
	state_machine.remove("mythical_animals_league_show")
	state_machine.remove("mythical_animals_league_hide")
	state_machine.remove("mythical_animals_league_refresh_ui")
end

function MythicalAnimalsLeague:close()
	-- window event : close.
	
end

function MythicalAnimalsLeague:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
