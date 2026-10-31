--[[ ----------------------------------------------------------------------------
-- 神兽养成主界面
--]] ----------------------------------------------------------------------------
MythicalAnimalsMainUI = class("MythicalAnimalsMainUIClass", Window)

-- 打开窗口
local mythical_animals_main_ui_window_open_terminal = {
	_name = "mythical_animals_main_ui_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("MythicalAnimalsMainUIClass") then
			fwin:open(MythicalAnimalsMainUI:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local mythical_animals_main_ui_window_close_terminal = {
	_name = "mythical_animals_main_ui_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		state_machine.excute("notification_center_update",0,"push_notification_mythical_animal")
		fwin:close(fwin:find("MythicalAnimalsMainUIClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_main_ui_window_open_terminal)
state_machine.add(mythical_animals_main_ui_window_close_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsMainUI:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	-- 1信息页签 2天命页签 3神兽页签
	self._curPage = 1

	self._infoUI = nil
	self._destinyUI = nil
	self._animalUI = nil
	
	-- load
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimals")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsDestiny")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsDestinyProperty")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsDestinyPropertyCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsDestinySmallStoneCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsDestinyStoneCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsForge")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsForgeCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsForgeStoneCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsHandle")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsIconCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsInfo")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsInfoPropertyCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsLeague")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsLeagueCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsLeaguePropertyCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsObtain")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsObtainCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsPropertyCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsRebirth")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsRebirthChoice")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsRebirthChoiceCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsRule")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsSkill")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsSkillConfig")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsSkillIconCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsSkillTip")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsSkillTipCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsTalentTip")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsTalentTipCell")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsTip")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsUpStar")
	
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_money_icon")

	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")


	-- Initialize role_biography page state machine.
	local function init_mythical_animals_main_ui_terminal()
		-- 打开角色创建窗口
		local mythical_animals_main_ui_open_terminal = {
			_name = "mythical_animals_main_ui_open",
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
		local mythical_animals_main_ui_close_terminal = {
			_name = "mythical_animals_main_ui_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_main_ui_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local mythical_animals_main_ui_show_terminal = {
			_name = "mythical_animals_main_ui_show",
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
		local mythical_animals_main_ui_hide_terminal = {
			_name = "mythical_animals_main_ui_hide",
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

		local mythical_animals_main_ui_open_rule_terminal = {
            _name = "mythical_animals_main_ui_open_rule",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("mythical_animals_rule_window_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local mythical_animals_main_ui_change_page_terminal = {
            _name = "mythical_animals_main_ui_change_page",
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

        local mythical_animals_main_ui_refresh_red_dot_terminal = {
            _name = "mythical_animals_main_ui_refresh_red_dot",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil then
            		instance:updatePageRedDot()
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(mythical_animals_main_ui_open_terminal)
		state_machine.add(mythical_animals_main_ui_close_terminal)
		state_machine.add(mythical_animals_main_ui_show_terminal)
		state_machine.add(mythical_animals_main_ui_hide_terminal)
		state_machine.add(mythical_animals_main_ui_open_rule_terminal)
		state_machine.add(mythical_animals_main_ui_change_page_terminal)
		state_machine.add(mythical_animals_main_ui_refresh_red_dot_terminal)
		state_machine.init()
	end
	-- call func init role_biography state machine.
	init_mythical_animals_main_ui_terminal()
end

-- 对象初始化
function MythicalAnimalsMainUI:init(params)
	self._curPage = params or 1
	return self
end

-- 打开对应页签
function MythicalAnimalsMainUI:changeSelectPage(curPage)
	local Panel_box = self.Panel_box

	local Button_shenShou_xinXi = self.Button_shenShou_xinXi
	local Button_tianMing = self.Button_tianMing
	local Button_shenShou = self.Button_shenShou


    if curPage == 1 then
        Button_shenShou_xinXi:setHighlighted(true)
    elseif curPage == 2 then
        Button_tianMing:setHighlighted(true)
    elseif curPage == 3 then
        Button_shenShou:setHighlighted(true)
    end

    self._curPage = curPage

    Button_shenShou_xinXi:setHighlighted(false)
    Button_tianMing:setHighlighted(false)
    Button_shenShou:setHighlighted(false)

    -- 隐藏所有页签对应的界面
    if self._infoUI ~= nil then
    	state_machine.excute("mythical_animals_info_hide", 0, nil)
    end
    if self._destinyUI ~= nil then
    	state_machine.excute("mythical_animals_destiny_hide", 0, nil)
    end

    if self._animalUI ~= nil then
    	state_machine.excute("mythical_animals_hide", 0, nil)
    end

    if curPage == 1 then
        Button_shenShou_xinXi:setHighlighted(true)
        if self._infoUI == nil then
        	self._infoUI = state_machine.excute("mythical_animals_info_window_open", 0, {Panel_box})
        else
        	-- 显示页签内容
        	state_machine.excute("mythical_animals_info_show", 0, nil)
        end
    elseif curPage == 2 then
        Button_tianMing:setHighlighted(true)
        if self._destinyUI == nil then
            self._destinyUI = state_machine.excute("mythical_animals_destiny_window_open", 0, {Panel_box})
        else
            -- 显示页签内容
            state_machine.excute("mythical_animals_destiny_show", 0, nil)
        end
    else
        Button_shenShou:setHighlighted(true)
        if self._animalUI == nil then
            self._animalUI = state_machine.excute("mythical_animals_window_open", 0, {Panel_box})
        else
            -- 显示页签内容
            state_machine.excute("mythical_animals_show", 0, nil)
        end
    end
end

function MythicalAnimalsMainUI:updatePageRedDot()
	local showDestinyRedDot = MythicalAnimalsHandle.canActivateNextDestiny()
	self.Image_rianMing_red:setVisible(showDestinyRedDot)

	local showAnimalsRedDot = false
	local data = dms["magical_animals_mould"]
	for _, v in pairs(data) do
		local id = dms.atof(v, magical_animals_mould.id)
			if MythicalAnimalsHandle.showMythicalAnimalsRedDotById(id) == true then
				showAnimalsRedDot = true
			break
		end
	end

	self.Image_shenShou_red:setVisible(showAnimalsRedDot)
end

function MythicalAnimalsMainUI:onUpdateDraw()
	local root = self.roots[1]

	self.Panel_box = ccui.Helper:seekWidgetByName(root, "Panel_box")
    
	self.Image_rianMing_red = ccui.Helper:seekWidgetByName(root, "Image_rianMing_red")

	self.Image_shenShou_red = ccui.Helper:seekWidgetByName(root, "Image_shenShou_red")

	self:openTopWindow()
	self:changeSelectPage(self._curPage)
	self:updatePageRedDot()
end

function MythicalAnimalsMainUI:openTopWindow()
	local userinfo = UserTopInfoA:new()
	userinfo._rootWindows = self
	fwin:open(userinfo, fwin._windows)
end

function MythicalAnimalsMainUI:onEnterTransitionFinish()
	-- 加载NinjaBiographiesWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals = res/cultivate/Mythical_animals/mythical_animals.csb
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 查看规则
	self.Button_rule = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rule"), nil,
	{
		terminal_name = "mythical_animals_main_ui_open_rule",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_shenShou_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shenShou_close"), nil,
	{
		terminal_name = "mythical_animals_main_ui_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 信息页签
    self.Button_shenShou_xinXi = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_shenShou_xinXi"), nil, 
    {
        terminal_name = "mythical_animals_main_ui_change_page", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        _page = 1,
    }, nil, 1)

    -- 天命页签
    self.Button_tianMing = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tianMing"), nil, 
    {
        terminal_name = "mythical_animals_main_ui_change_page", 
        terminal_state = 0,
        isPressedActionEnabled = true, 
        _page = 2,
    }, nil, 1)

    -- 神兽页签
    self.Button_shenShou = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_shenShou"), nil, 
    {
        terminal_name = "mythical_animals_main_ui_change_page", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        _page = 3,
    }, nil, 1)

	self:onUpdateDraw()
end

function MythicalAnimalsMainUI:onExit()
	-- 释放RoleBiographyWindow界面资源.
	state_machine.remove("mythical_animals_main_ui_open")
	state_machine.remove("mythical_animals_main_ui_close")
	state_machine.remove("mythical_animals_main_ui_show")
	state_machine.remove("mythical_animals_main_ui_hide")
	state_machine.remove("mythical_animals_main_ui_refresh_red_dot")
end

function MythicalAnimalsMainUI:close()
	-- window event : close.

end

function MythicalAnimalsMainUI:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
