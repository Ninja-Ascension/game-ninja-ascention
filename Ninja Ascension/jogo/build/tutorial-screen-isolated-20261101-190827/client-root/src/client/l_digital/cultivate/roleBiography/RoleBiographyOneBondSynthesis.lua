--[[ ----------------------------------------------------------------------------
-- 幻彩印记合成界面
--]] ----------------------------------------------------------------------------
RoleBiographyOneBondSynthesis = class("RoleBiographyOneBondSynthesisClass", Window)

-- 打开窗口
local role_biography_one_bond_synthesis_window_open_terminal = {
	_name = "role_biography_one_bond_synthesis_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyOneBondSynthesisClass") then
			fwin:open(RoleBiographyOneBondSynthesis:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_one_bond_synthesis_window_close_terminal = {
	_name = "role_biography_one_bond_synthesis_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyOneBondSynthesisClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_one_bond_synthesis_window_open_terminal)
state_machine.add(role_biography_one_bond_synthesis_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyOneBondSynthesis:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
    self._biographyId = -1                  -- 忍列传ID
	-- load lua files.

	-- Initialize ninja biographies obtain page state machine.
	local function init_role_biography_one_bond_synthesis_terminal()
		-- 打开角色创建窗口
		local role_biography_one_bond_synthesis_open_terminal = {
			_name = "role_biography_one_bond_synthesis_open",
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
		local role_biography_one_bond_synthesis_close_terminal = {
			_name = "role_biography_one_bond_synthesis_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_one_bond_synthesis_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_one_bond_synthesis_show_terminal = {
			_name = "role_biography_one_bond_synthesis_show",
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
		local role_biography_one_bond_synthesis_hide_terminal = {
			_name = "role_biography_one_bond_synthesis_hide",
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

		-- 确认激活
		local role_biography_one_bond_synthesis_sure_activate_terminal = {
			_name = "role_biography_one_bond_synthesis_sure_activate",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
                    state_machine.excute("role_biography_one_bond_synthesis_close", 0, nil)
                    state_machine.excute("role_biography_activate", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
        
		-- 确认升星
		local role_biography_one_bond_synthesis_sure_level_up_terminal = {
			_name = "role_biography_one_bond_synthesis_sure_level_up",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
                    state_machine.excute("role_biography_one_bond_synthesis_close", 0, nil)
                    state_machine.excute("role_biography_up_level", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


		state_machine.add(role_biography_one_bond_synthesis_open_terminal)
		state_machine.add(role_biography_one_bond_synthesis_close_terminal)
		state_machine.add(role_biography_one_bond_synthesis_show_terminal)
		state_machine.add(role_biography_one_bond_synthesis_hide_terminal)
		state_machine.add(role_biography_one_bond_synthesis_sure_activate_terminal)
		state_machine.add(role_biography_one_bond_synthesis_sure_level_up_terminal)
		state_machine.init()
	end
	-- call func init ninja biographies obtain state machine.
	init_role_biography_one_bond_synthesis_terminal()
end

function RoleBiographyOneBondSynthesis:getComposeNeedProp()
    local allPropInfo = {}
    if self._curType == 1 then
        allPropInfo = RoleBiographyHandle.getBiographyComposeByActivate(self._biographyId)
    elseif self._curType == 2 then
        allPropInfo = RoleBiographyHandle.getBiographyComposeByLevelUp(self._biographyId)
    end
    
    return allPropInfo
end

-- 对象初始化
-- {biographyId = 忍列传ID, type = 类型激活/升星}
function RoleBiographyOneBondSynthesis:init(params)
	self._biographyId = params.biographyId
    self._curType = params.type
	self._composeNeedProps = self:getComposeNeedProp()

	return self
end

function RoleBiographyOneBondSynthesis:updateUI()
	local Panel_icon = self.Panel_icon
	Panel_icon:removeAllChildren(true)
    local picIdx = RoleBiographyHandle.getBiographyPicByID(self._biographyId)
    local headSp = cc.Sprite:create(string.format("images/ui/props/props_%d.png", picIdx))
	headSp:setAnchorPoint(0.5, 0.5)
	headSp:setPosition(cc.p(Panel_icon:getContentSize().width/2, Panel_icon:getContentSize().height/2))
	Panel_icon:addChild(headSp)

	local name = RoleBiographyHandle.getBiographyNameByID(self._biographyId)
	self.Text_yj_name:setString(name)

    self.Button_activation:setVisible(self._curType == 1)
    self.Button_upgrade:setVisible(self._curType == 2)

	self:updateList()
end

function RoleBiographyOneBondSynthesis:updateList()
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()
    local allPropInfo = {}
	
	for _, v in ipairs(self._composeNeedProps) do
        local costProps = RoleBiographyHandle.getCurImprintComposeNeedByProp(v)
        for _, propInfo in ipairs(costProps) do
            table.insert(allPropInfo, propInfo)
        end
	end
    local allProptringInfo = MergerSameRewards(allPropInfo)

    for _, v in ipairs(allProptringInfo) do
        local propInfo = zstring.split(v, ",", tonumber)
		local cell = state_machine.excute("role_biography_compound_cell_create", 0, propInfo)
		ListView_1:addChild(cell)
    end
	ListView_1:jumpToTop()
	ListView_1:requestRefreshView()
end

function RoleBiographyOneBondSynthesis:updatePropCount()
	local ListView_1 = self.ListView_1
	if ListView_1 then
		for _, v in pairs(ListView_1:getChildren()) do
			if v ~= nil and v.updateHaveCount then
				v:updateHaveCount()
			end
		end
	end
end

function RoleBiographyOneBondSynthesis:onUpdateDraw()
	local root = self.roots[1]

	-- 忍列传名称
	self.Text_yj_name = ccui.Helper:seekWidgetByName(root, "Text_yj_name")

	-- 印记图标容器
	self.Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")

	-- 获取途径容器
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	self:updateUI()
end

function RoleBiographyOneBondSynthesis:onEnterTransitionFinish()
	-- 加载RoleBiographyCompoundWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_synthesis_imprinting = res/cultivate/ninja_biographies/ninja_biographies_synthesis_imprinting.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_synthesis_imprinting.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "role_biography_one_bond_synthesis_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 激活按钮
	self.Button_activation = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_activation"), nil,
	{
		terminal_name = "role_biography_one_bond_synthesis_sure_activate",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 升星按钮
	self.Button_upgrade = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_upgrade"), nil,
	{
		terminal_name = "role_biography_one_bond_synthesis_sure_level_up",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function RoleBiographyOneBondSynthesis:onExit()
	-- 释放RoleBiographyCompoundWindow界面资源.
	state_machine.remove("role_biography_one_bond_synthesis_open")
	state_machine.remove("role_biography_one_bond_synthesis_close")
	state_machine.remove("role_biography_one_bond_synthesis_show")
	state_machine.remove("role_biography_one_bond_synthesis_hide")
	state_machine.remove("role_biography_one_bond_synthesis_sure")
	state_machine.remove("role_biography_one_bond_synthesis_sure_activate")
	state_machine.remove("role_biography_one_bond_synthesis_sure_level_up")
end

function RoleBiographyOneBondSynthesis:close()
	-- window event : close.
	
end

function RoleBiographyOneBondSynthesis:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
