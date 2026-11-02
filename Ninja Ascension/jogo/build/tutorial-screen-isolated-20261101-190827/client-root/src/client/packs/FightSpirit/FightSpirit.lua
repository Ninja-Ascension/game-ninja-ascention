--[[ ----------------------------------------------------------------------------
-- 战魂主界面
--]] ----------------------------------------------------------------------------
FightSpirit = class("FightSpiritClass", Window)

-- 打开窗口
local fight_spirit_window_open_terminal = {
	_name = "fight_spirit_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritClass") then
			fwin:open(FightSpirit:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_window_close_terminal = {
	_name = "fight_spirit_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_window_open_terminal)
state_machine.add(fight_spirit_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpirit:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._curPage = nil

	self._mainUI = nil
	self._hechengUI = nil
	self._awakeUI = nil
	
	-- load lua files.
	app.load("client.packs.FightSpirit.FightSpiritCell1")
	app.load("client.packs.FightSpirit.FightSpiritCell2")
	app.load("client.packs.FightSpirit.FightSpiritCell4")
	app.load("client.packs.FightSpirit.FightSpiritHandle")
	app.load("client.packs.FightSpirit.fightspiritcell1zhlist")
	app.load("client.packs.FightSpirit.FightSpiritZhAtt")
	app.load("client.packs.FightSpirit.FightSpiritZhEquip")
	app.load("client.packs.FightSpirit.fightspiritcell2xllist")
	app.load("client.packs.FightSpirit.FightSpiritBreakDown")
	app.load("client.packs.FightSpirit.FightSpiritBreakDownConfirm")
	app.load("client.packs.FightSpirit.FightSpiritSkill")
	app.load("client.packs.FightSpirit.FightSpiritCell4Confirm")
	app.load("client.packs.FightSpirit.FightSpiritZhSkill")
	app.load("client.packs.FightSpirit.FightSpiritQianghua")
	app.load("client.packs.FightSpirit.FightSpiritQianghuaSx")
	app.load("client.packs.FightSpirit.FightSpiritJxAtt")
	app.load("client.packs.FightSpirit.FightSpiritSjAtt")
	app.load("client.packs.FightSpirit.FightSpiritXilianConfirm")
	app.load("client.packs.FightSpirit.FightSpiritObtain")
	app.load("client.packs.FightSpirit.FightSpiritRule")
	
	-- Initialize fight spirit page state machine.
	local function init_fight_spirit_terminal()
		-- 打开角色创建窗口
		local fight_spirit_open_terminal = {
			_name = "fight_spirit_open",
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
		local fight_spirit_close_terminal = {
			_name = "fight_spirit_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local wnd
				if instance._curPage == 1 then
					wnd = fwin:find("FightSpiritCell1Class")
				elseif instance._curPage == 3 then
					wnd = fwin:find("FightSpiritCell2Class")
				else
					wnd = fwin:find("FightSpiritCell1Class")
					if not wnd then
						wnd = fwin:find("FightSpiritCell2Class")
					end
				end
				if wnd then
					local ship = getPlayerShip(wnd.curShipId)
					if fwin:find("HeroDevelopClass") ~= nil then
						state_machine.excute("hero_develop_page_strength_to_update_ship",0,ship)
						state_machine.excute("hero_develop_page_strength_to_update_all_icon",0,ship)
					end
				end
				state_machine.excute("fight_spirit_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local fight_spirit_show_terminal = {
			_name = "fight_spirit_show",
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
		local fight_spirit_hide_terminal = {
			_name = "fight_spirit_hide",
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

		local fight_spirit_change_page_terminal = {
            _name = "fight_spirit_change_page",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
            		instance:changeSelectPage(params._datas._page)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_spirit_change_awake_btn_terminal = {
            _name = "fight_spirit_change_awake_btn",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
            		instance:changeAwakeBtn(params.index)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(fight_spirit_open_terminal)
		state_machine.add(fight_spirit_close_terminal)
		state_machine.add(fight_spirit_show_terminal)
		state_machine.add(fight_spirit_hide_terminal)
		state_machine.add(fight_spirit_change_page_terminal)
		state_machine.add(fight_spirit_change_awake_btn_terminal)
		state_machine.init()
	end
	-- call func init fight spirit state machine.
	init_fight_spirit_terminal()
end

-- 对象初始化
function FightSpirit:init(params)
	self._page = params and params.page or 1
	self._curShipId = params and params.curShipId
	self._types = params and params.types
	return self
end

--切换觉醒洗练按钮
function FightSpirit:changeAwakeBtn(index)
	--1觉醒，2洗练
	self.Button_juexing:setOpacity(index == 1 and 255 or 0)
	self.Button_xilian:setOpacity(index == 2 and 255 or 0)
end

-- 打开对应页签
function FightSpirit:changeSelectPage(curPage)
	if curPage == 3 then
		if funOpenDrawTip(203) == true then
			return
		end
	end

	if self._curPage ~= curPage then
		if curPage ~= 3 then
			self:changeAwakeBtn(1)
		end
	end

	local Panel_box = self.Panel_box

	local Button_zhanhun = self.Button_zhanhun
	local Button_hecheng = self.Button_hecheng
	local Button_juexing = self.Button_juexing
	local Button_xilian = self.Button_xilian

    self._curPage = curPage

    Button_zhanhun:setBrightStyle(0)
    Button_hecheng:setBrightStyle(0)
    Button_juexing:setBrightStyle(0)
    Button_xilian:setBrightStyle(0)
    Button_zhanhun:setTouchEnabled(true)
    Button_hecheng:setTouchEnabled(true)
    Button_juexing:setTouchEnabled(true)
    Button_xilian:setTouchEnabled(true)

    -- 隐藏所有页签对应的界面
    if self._mainUI ~= nil then
    	state_machine.excute("fight_spirit_main_hide", 0, nil)
    end
    if self._hechengUI ~= nil then
    	state_machine.excute("fight_spirit_hecheng_hide", 0, nil)
    end

    if self._awakeUI ~= nil then
    	state_machine.excute("fight_spirit_awake_hide", 0, nil)
    end

    if curPage == 1 then
        Button_zhanhun:setBrightStyle(1)
        Button_zhanhun:setTouchEnabled(false)
        if self._mainUI == nil then
        	self._mainUI = state_machine.excute("fight_spirit_main_window_open", 0, {Panel_box, self._curShipId, self._types})
        else
        	-- 显示页签内容
        	state_machine.excute("fight_spirit_main_show", 0, nil)
        end
    elseif curPage == 2 then
        Button_hecheng:setBrightStyle(1)
        Button_hecheng:setTouchEnabled(false)
        if self._hechengUI == nil then
            self._hechengUI = state_machine.excute("fight_spirit_hecheng_window_open", 0, {Panel_box})
        else
            -- 显示页签内容
            state_machine.excute("fight_spirit_hecheng_show", 0, nil)
        end
    else
        Button_juexing:setBrightStyle(1)
        Button_xilian:setBrightStyle(1)
        Button_juexing:setTouchEnabled(false)
        Button_xilian:setTouchEnabled(false)
        if self._awakeUI == nil then
            self._awakeUI = state_machine.excute("fight_spirit_awake_window_open", 0, {Panel_box, self._curShipId, self._types})
        else
            -- 显示页签内容
            state_machine.excute("fight_spirit_awake_show", 0, nil)
        end
    end
end

function FightSpirit:onUpdateDraw()
	local root = self.roots[1]

	-- 战魂、合成、觉醒界面
	self.Panel_box = ccui.Helper:seekWidgetByName(root, "Panel_box")

	self:changeSelectPage(self._page)
end

function FightSpirit:onEnterTransitionFinish()
	-- 加载FightSpiritWindow界面资源.
	-- res.packs.FightSpirit = res/packs/FightSpirit/FightSpirit.csb
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 查看规则
	self.Button_rule = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rule"), nil,
	{
		terminal_name = "fight_spirit_rule_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 觉醒界面按钮
	self.Button_juexing = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_juexing"), nil,
	{
		terminal_name = "fight_spirit_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_page = 3,
	}, nil, 0)	

	-- 合成界面按钮
	self.Button_hecheng = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hecheng"), nil,
	{
		terminal_name = "fight_spirit_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_page = 2,
	}, nil, 0)	

	-- 战魂界面按钮
	self.Button_zhanhun = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhanhun"), nil,
	{
		terminal_name = "fight_spirit_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_page = 1,
	}, nil, 0)	

	-- 分解按钮
	self.Button_fenjie = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fenjie"), nil,
	{
		terminal_name = "fight_spirit_break_down_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 洗练按钮
	self.Button_xilian = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xilian"), nil,
	{
		terminal_name = "fight_spirit_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_page = 3,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "fight_spirit_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function FightSpirit:onExit()
	-- 释放FightSpiritWindow界面资源.
	state_machine.remove("fight_spirit_open")
	state_machine.remove("fight_spirit_close")
	state_machine.remove("fight_spirit_show")
	state_machine.remove("fight_spirit_hide")
	state_machine.remove("fight_spirit_change_page")
	state_machine.remove("fight_spirit_change_awake_btn")
end

function FightSpirit:close()
	-- window event : close.
	
end

function FightSpirit:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
