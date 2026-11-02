--[[ ----------------------------------------------------------------------------
-- 条件列表项
--]] ----------------------------------------------------------------------------
IllustrationConditionCellFirst = class("IllustrationConditionCellFirstClass", Window)
IllustrationConditionCellFirst.__size = nil

-- 创建Cell实例
local illustration_condition_cell_first_create_terminal = {
	_name = "illustration_condition_cell_first_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if IllustrationConditionCellFirst then
			local cell = IllustrationConditionCellFirst:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_condition_cell_first_create_terminal)
state_machine.init()

-- 构造器
function IllustrationConditionCellFirst:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._ship_mould_id = nil

	-- load lua files.

	-- Initialize lim pool record list page state machine.
	local function init_illustration_condition_cell_first_terminal()
		-- 跳转卡册对应卡
		local illustration_condition_cell_first_jump_windows_terminal = {
			_name = "illustration_condition_cell_first_jump_windows",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local ship_mould_id = params._datas.ship_mould_id

				local cardData = IllustrationHandle.getCardDataByShipMouldId(ship_mould_id)
				if cardData ~= nil then
					state_machine.excute("illustration_levelup_window_open",0,{cardData})
					state_machine.excute("illustration_activate_window_close", 0, nil)
	                -- fwin:reset(nil)
	                -- app.load("client.home.Menu")
	                -- fwin:open(Menu:new(), fwin._taskbar)
	                -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	                --     if fwin:find("HomeClass") == nil then
	                --         state_machine.excute("menu_manager", 0, 
	                --             {
	                --                 _datas = {
	                --                     terminal_name = "menu_manager",
	                --                     next_terminal_name = "menu_show_home_page", 
	                --                     current_button_name = "Button_home",
	                --                     but_image = "Image_home",       
	                --                     terminal_state = 0, 
	                --                     _needOpenHomeHero = true,
	                --                     isPressedActionEnabled = true
	                --                 }
	                --             }
	                --         )
	                --         state_machine.excute("menu_back_home_page", 0, "")
	                --     end
	                -- end

	                -- -- 跳转升星
	                -- state_machine.excute("shortcut_function_open_ship_rising_star", 0, {_datas = {root_trace = 110}})
				else
					TipDlg.drawTextDailog(tipStringInfo_illustration_tip[12])
				end

				-- local campPreference = dms.int(dms["ship_mould"], tonumber(ship_mould_id), ship_mould.camp_preference)
				-- state_machine.excute("illustration_mark_all_ability", 0, campPreference)
				-- local chooseIndex = state_machine.excute("illustration_get_card_index", 0, ship_mould_id)
				-- 这里跳转有问题
				-- state_machine.excute("illustration_local_list", 0, chooseIndex)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(illustration_condition_cell_first_jump_windows_terminal)
		-- state_machine.init()
	end
	-- call func init lim pool record list state machine.
	init_illustration_condition_cell_first_terminal()
end

-- 对象初始化
function IllustrationConditionCellFirst:init(params)
	self._ship_mould_id = params[1]

	self:onInit(params)
	self:setContentSize(IllustrationConditionCellFirst.__size)
	return self
end

function IllustrationConditionCellFirst:updateUI()
	local name = IllustrationHandle.getCardName(self._ship_mould_id)
	local cardDatas = IllustrationHandle.getCardDataByShipMouldId(self._ship_mould_id)

	local nowStar = cardDatas and cardDatas.cardStar or 0
	local maxStar = 7
	local isFinish = nowStar >= maxStar

	self.Text_normal:setString(string.format(tipStringInfo_illustration_tip[9], name, nowStar, maxStar))
	if isFinish then
		self.Text_normal:setColor(cc.c3b(0, 203, 11))
	else
		self.Text_normal:setColor(cc.c3b(125, 58, 0))
	end

	self.Image_normal:setVisible(isFinish)
	self.Button_go:setVisible(not isFinish)
end

function IllustrationConditionCellFirst:onUpdateDraw()
	local root = self.roots[1]

	-- 条件文本
	self.Text_normal = ccui.Helper:seekWidgetByName(root, "Text_normal")

	-- 进度完成
	self.Image_normal = ccui.Helper:seekWidgetByName(root, "Image_normal")

	-- 前往
	self.Button_go = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil,
	{
		terminal_name = "illustration_condition_cell_first_jump_windows",
		terminal_state = 0,
		isPressedActionEnabled = true,
		ship_mould_id = self._ship_mould_id
	}, nil, 0)	

	self:updateUI()
end

function IllustrationConditionCellFirst:onEnterTransitionFinish()
	
end

function IllustrationConditionCellFirst:onInit(params)
	-- 加载IllustrationConditionCellFirstWindow界面资源.
	-- res.cultivate.illustration.illustration_levelup_list_1 = res/cultivate/illustration/illustration_levelup_list_1.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/illustration/illustration_levelup_list_1.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/illustration/illustration_levelup_list_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if IllustrationConditionCellFirst.__size == nil then
		IllustrationConditionCellFirst.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function IllustrationConditionCellFirst:onExit()
	-- 释放IllustrationConditionCellFirstWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/illustration/illustration_levelup_list_1.csb", root)
	-- ]]
end

function IllustrationConditionCellFirst:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function IllustrationConditionCellFirst:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/illustration/illustration_levelup_list_1.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
