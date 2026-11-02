--[[ ----------------------------------------------------------------------------
-- 碎片求助弹窗
--]] ----------------------------------------------------------------------------
LegionAssistanceWindow1 = class("LegionAssistanceWindow1Class", Window)

-- 打开窗口
local legion_assistance_window1_window_open_terminal = {
	_name = "legion_assistance_window1_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("LegionAssistanceWindow1Class") then
			fwin:open(LegionAssistanceWindow1:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local legion_assistance_window1_window_close_terminal = {
	_name = "legion_assistance_window1_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("LegionAssistanceWindow1Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(legion_assistance_window1_window_open_terminal)
state_machine.add(legion_assistance_window1_window_close_terminal)
state_machine.init()

-- 构造器
function LegionAssistanceWindow1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.currentScrollView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0

	-- 选择的碎片ID
	self.mySelectId = nil

	-- load lua files.
	app.load("client.cells.prop.sm_packs_cell")
	app.load("client.cells.utils.resources_icon_cell")

	-- Initialize legion assistance window1 page state machine.
	local function init_legion_assistance_window1_terminal()
		-- 打开角色创建窗口
		local legion_assistance_window1_open_terminal = {
			_name = "legion_assistance_window1_open",
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
		local legion_assistance_window1_close_terminal = {
			_name = "legion_assistance_window1_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("legion_assistance_window1_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local legion_assistance_window1_show_terminal = {
			_name = "legion_assistance_window1_show",
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
		local legion_assistance_window1_hide_terminal = {
			_name = "legion_assistance_window1_hide",
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

		-- 更新选中的碎片ID
		local legion_assistance_window1_update_select_debrisId_terminal = {
			_name = "legion_assistance_window1_update_select_debrisId",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance and instance.roots ~= nil and instance.roots[1] ~= nil then
					local prop = params[1]
					instance:updateSelectDebrisId(prop)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 确定求助
		local legion_assistance_window1_sure_seek_help_terminal = {
			_name = "legion_assistance_window1_sure_seek_help",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					if instance.mySelectId == nil then
						TipDlg.drawTextDailog(tipStringInfo_union_donation_tip[2])
						return
					end

					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
							if response.node ~= nil and response.node.roots ~= nil then
								-- 刷新公会援助界面
								state_machine.excute("legion_assistance_refresh_main_ui", 0, nil)
								-- 关闭公会求助界面
								state_machine.excute("legion_assistance_window1_close", 0, nil)
							end
						end
					end
					protocol_command.union_assistance_seek_help.param_list = instance.mySelectId
					NetworkManager:register(protocol_command.union_assistance_seek_help.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		

		state_machine.add(legion_assistance_window1_open_terminal)
		state_machine.add(legion_assistance_window1_close_terminal)
		state_machine.add(legion_assistance_window1_show_terminal)
		state_machine.add(legion_assistance_window1_hide_terminal)

		state_machine.add(legion_assistance_window1_update_select_debrisId_terminal)
		state_machine.add(legion_assistance_window1_sure_seek_help_terminal)

		state_machine.init()
	end
	-- call func init legion assistance window1 state machine.
	init_legion_assistance_window1_terminal()
end

-- 对象初始化
function LegionAssistanceWindow1:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

-- 选中的碎片Id
function LegionAssistanceWindow1:updateSelectDebrisId(prop)
	-- debug.print_r(prop)
	self.mySelectId = prop.user_prop_id
end

function LegionAssistanceWindow1:getSortDebrisList()
	local function fightingCapacity(a,b)
		local al = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.trace_scene)
		local bl = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.trace_scene)
		
		local result = false
		if al < bl then
			result = true
		end
		return result
	end

	local tSortedHeroes = {}

	for i, prop in pairs(_ED.user_prop) do
		local propData = dms.element(dms["prop_mould"], prop.user_prop_template)
		local shipMouldId = dms.atoi(propData, prop_mould.use_of_ship)
		if dms.atoi(propData, prop_mould.storage_page_index) == 18 then
			table.insert(tSortedHeroes, prop)
		end
	end

	table.sort(tSortedHeroes, fightingCapacity)
	return tSortedHeroes
end

function LegionAssistanceWindow1:updateDebrisList()
	local tSortedHeroes = self:getSortDebrisList()

	local m_ScrollView = self.ScrollView_shard
	m_ScrollView:removeAllChildren(true)

	local panel = m_ScrollView:getInnerContainer()
	panel:setContentSize(m_ScrollView:getContentSize())
	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)

	local sSize = panel:getContentSize()
	local sHeight = sSize.height
	local sWidth = sSize.width
	local controlSize = m_ScrollView:getInnerContainerSize()
	local nextY = sSize.height
	local nextX = sSize.width
	local tHeight = 0
	local cellHeight = 0
	local tWidth = 0
	local wPosition = sWidth/5

	local Hlindex = 0
	local number = #tSortedHeroes
	local m_number = math.ceil(number/5)

	cellHeight = m_number*(m_ScrollView:getContentSize().width/5)

	sHeight = math.max(sHeight, cellHeight)
	panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
	local first = nil
	for j, v in pairs(tSortedHeroes) do
		-- 调用仓库控件 useType = 
		local cell = state_machine.excute("sm_packs_cell", 0, {v, 0, nil, nil, nil, j})
		panel:addChild(cell)
		if j == 1 then
			first = cell
		end
		tWidth = tWidth + wPosition

		if (j-1)%5 ==0 then
			Hlindex = Hlindex+1
			tWidth = 0
			tHeight = sHeight - wPosition*Hlindex  
		end
		if j <= 5 then
			tHeight = sHeight - wPosition
		end
		cell:setPosition(cc.p(tWidth,tHeight))
	end
	m_ScrollView:jumpToTop()

	self.currentScrollView = m_ScrollView
	self.currentInnerContainer = self.currentScrollView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function LegionAssistanceWindow1:onUpdateDraw()
	local root = self.roots[1]

	-- 可选择碎片列表
	self.ScrollView_shard = ccui.Helper:seekWidgetByName(root, "ScrollView_shard")

	self:updateDebrisList()
end

function LegionAssistanceWindow1:onEnterTransitionFinish()
	-- 加载LegionAssistanceWindow1Window界面资源.
	-- res.legion.legion_assistance_window_1 = res/legion/legion_assistance_window_1.csb
	local csbNode = csb.createNode("legion/legion_assistance_window_1.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 确定求助
	self.Button_ok = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"), nil,
	{
		terminal_name = "legion_assistance_window1_sure_seek_help",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "legion_assistance_window1_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function LegionAssistanceWindow1:onUpdate(dt)
    if self.currentScrollView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentScrollView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentScrollView:getChildren()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function LegionAssistanceWindow1:onExit()
	-- 释放LegionAssistanceWindow1Window界面资源.
	state_machine.remove("legion_assistance_window1_open")
	state_machine.remove("legion_assistance_window1_close")
	state_machine.remove("legion_assistance_window1_show")
	state_machine.remove("legion_assistance_window1_hide")

	state_machine.remove("legion_assistance_window1_update_select_debrisId")
	state_machine.remove("legion_assistance_window1_sure_seek_help")
end

function LegionAssistanceWindow1:close()
	-- window event : close.
	
end

function LegionAssistanceWindow1:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
