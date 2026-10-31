--[[ ----------------------------------------------------------------------------
-- 规则窗口
--]] ----------------------------------------------------------------------------
MythicalAnimalsUpStar = class("MythicalAnimalsUpStarClass", Window)

-- 打开窗口
local mythical_animals_up_star_window_open_terminal = {
	_name = "mythical_animals_up_star_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("MythicalAnimalsUpStarClass") then
			fwin:open(MythicalAnimalsUpStar:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local mythical_animals_up_star_window_close_terminal = {
	_name = "mythical_animals_up_star_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MythicalAnimalsUpStarClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_up_star_window_open_terminal)
state_machine.add(mythical_animals_up_star_window_close_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsUpStar:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_mythical_animals_up_star_terminal()
		-- 打开角色创建窗口
		local mythical_animals_up_star_open_terminal = {
			_name = "mythical_animals_up_star_open",
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
		local mythical_animals_up_star_close_terminal = {
			_name = "mythical_animals_up_star_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_up_star_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local mythical_animals_up_star_show_terminal = {
			_name = "mythical_animals_up_star_show",
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
		local mythical_animals_up_star_hide_terminal = {
			_name = "mythical_animals_up_star_hide",
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

		-- 神兽技能详情
		local mythical_animals_up_star_open_animal_info_terminal = {
			_name = "mythical_animals_up_star_open_animal_info",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.excute("mythical_animals_skill_tip_window_open", 0, instance._animalsMouldId)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开获得途径
		local mythical_animals_up_star_open_obtain_terminal = {
			_name = "mythical_animals_up_star_open_obtain",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(instance._animalsMouldId)
					local _, costProp = MythicalAnimalsHandle.canMythicalAnimalsUpStar(instance._animalsMouldId, curStar)
					state_machine.excute("mythical_animals_obtain_window_open", 0, {prop = costProp})
					return true
				end
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 升星
		local mythical_animals_up_star_go_terminal = {
			_name = "mythical_animals_up_star_go",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.lock("mythical_animals_up_star_go")
					local animalsMouldId = instance._animalsMouldId
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
							-- 战力飘字
							smFightingChange()

							instance:playUpStarAni()

							-- 刷新界面
							state_machine.excute("mythical_animals_refresh_ui", 0)

							state_machine.excute("notification_center_update",0,"push_notification_mythical_animal")

							state_machine.excute("mythical_animals_main_ui_refresh_red_dot", 0, 0)

							state_machine.unlock("mythical_animals_up_star_go")

							local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(animalsMouldId)
							local canActivate = MythicalAnimalsHandle.canMythicalAnimalsUpStar(animalsMouldId, curStar)
							if canActivate then
								instance:updateUI()
							else
								state_machine.excute("mythical_animals_up_star_close", 0, nil)
							end
						else
							state_machine.unlock("mythical_animals_up_star_go")
						end
					end
					protocol_command.magical_animals_advance_star.param_list = "" .. animalsMouldId
					NetworkManager:register(protocol_command.magical_animals_advance_star.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_up_star_open_terminal)
		state_machine.add(mythical_animals_up_star_close_terminal)
		state_machine.add(mythical_animals_up_star_show_terminal)
		state_machine.add(mythical_animals_up_star_hide_terminal)
		state_machine.add(mythical_animals_up_star_open_animal_info_terminal)
		state_machine.add(mythical_animals_up_star_open_obtain_terminal)
		state_machine.add(mythical_animals_up_star_go_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_mythical_animals_up_star_terminal()
end

-- 对象初始化
function MythicalAnimalsUpStar:init(params)
	self._animalsMouldId = params

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function MythicalAnimalsUpStar:onUpdateDraw()
	local root = self.roots[1]

	self.Text_character = ccui.Helper:seekWidgetByName(root, "Text_character")

	self.Text_character_0 = ccui.Helper:seekWidgetByName(root, "Text_character_0")

	self.propertyUI = {
		{name = ccui.Helper:seekWidgetByName(root, "Text_1_0"), preValue = ccui.Helper:seekWidgetByName(root, "Text_atk"), nextValue = ccui.Helper:seekWidgetByName(root, "Text_atkUp")},
		{name = ccui.Helper:seekWidgetByName(root, "Text_1_0_0"), preValue = ccui.Helper:seekWidgetByName(root, "Text_def"), nextValue = ccui.Helper:seekWidgetByName(root, "Text_defUp")},
		{name = ccui.Helper:seekWidgetByName(root, "Text_1_0_1"), preValue = ccui.Helper:seekWidgetByName(root, "Text_hp"), nextValue = ccui.Helper:seekWidgetByName(root, "Text_hpUP")}
	}

	-- 拥有
	self.Text_cost_n = ccui.Helper:seekWidgetByName(root, "Text_cost_n")

	-- 需要
	self.Text_cost = ccui.Helper:seekWidgetByName(root, "Text_cost")

	self.Panel_player_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1")

	self.Panel_player_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_2")

	self.Panel_animation_starUP = ccui.Helper:seekWidgetByName(root, "Panel_animation_starUP")

	self:updateUI()

end

-- 播放动画
function MythicalAnimalsUpStar:playUpStarAni()
	local Panel_animation_starUP = self.Panel_animation_starUP
	Panel_animation_starUP:removeAllChildren(true)


	local animation_name = "shengxingchenggong"
    local continued_name = "shengxingchenggong2"

	local jsonFile = "sprite/sprite_sjsx.json"
    local atlasFile = "sprite/sprite_sjsx.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, animation_name, true, nil)
    animation.animationNameList = {animation_name,continued_name}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    -- animation:getAnimation():setFrameEventCallFunc(onFrameEventBullet)
    animation:getAnimation():setMovementEventCallFunc(function()
    	Panel_animation_starUP:removeAllChildren(true)
    end)
    csb.animationChangeToAction(animation, 0, 1, false)

    animation:setPosition(Panel_animation_starUP:getContentSize().width / 2, Panel_animation_starUP:getContentSize().height / 2)
    Panel_animation_starUP:addChild(animation)
end

function MythicalAnimalsUpStar:updateUI()
	local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(self._animalsMouldId)

	local name = MythicalAnimalsHandle.getAnimalsNameById(self._animalsMouldId)
	self.Text_character:setString(name)
	self.Text_character_0:setString(name)

	self.Panel_player_icon_1:removeAllChildren(true)
	local cell = DrawHandle.drawIcon({72, self._animalsMouldId, 1, curStar})
	self.Panel_player_icon_1:addChild(cell)

	self.Panel_player_icon_2:removeAllChildren(true)
	local cell = DrawHandle.drawIcon({72, self._animalsMouldId, 1, curStar + 1})
	self.Panel_player_icon_2:addChild(cell)

	-- 消耗
	local curStar = MythicalAnimalsHandle.getMythicalAnimalsStarById(self._animalsMouldId)
	local canActivate, costProp = MythicalAnimalsHandle.canMythicalAnimalsUpStar(self._animalsMouldId, curStar)
	local havePropNum = tonumber(getPropAllCountByMouldId(costProp[2]))

	self.Text_cost_n:setString(havePropNum)
	self.Text_cost:setString("/" .. costProp[3])

	--属性
	local curPropertyData = MythicalAnimalsHandle.getAnimalsUpStarPropertyById(self._animalsMouldId, curStar - 1)
	local nextPropertyData = MythicalAnimalsHandle.getAnimalsUpStarPropertyById(self._animalsMouldId, curStar)

	local function sortFunc(a, b)
		return a.propertyType < b.propertyType
	end

	local data_1 = {}
	for k, v in pairs(curPropertyData) do
		table.insert(data_1, {propertyType = k, propertyValue = v})
	end

	local data_2 = {}
	for k, v in pairs(nextPropertyData) do
		table.insert(data_2, {propertyType = k, propertyValue = v})
	end

	table.sort(data_1, sortFunc)
	table.sort(data_2, sortFunc)

	for i, v in ipairs(self.propertyUI) do
		v.name:setVisible(false)
		v.preValue:setVisible(false)
		v.nextValue:setVisible(false)

		if data_1[i] then
			local propertyType1 = tonumber(data_1[i].propertyType)
			local propertyValue1 = tonumber(data_1[i].propertyValue)
			local name1, value1 = getHardenPropertyNameAndValue(propertyType1, propertyValue1, true, tipStringInfo_magical_animals_property_name_and_value)

			local propertyType2 = tonumber(data_2[i].propertyType)
			local propertyValue2 = tonumber(data_2[i].propertyValue)
			local name2, value2 = getHardenPropertyNameAndValue(propertyType2, propertyValue2, true, tipStringInfo_magical_animals_property_name_and_value)

			v.name:setString(name1)

			v.preValue:setString(value1)
			v.nextValue:setString(value2)
			
			v.name:setVisible(true)
			v.preValue:setVisible(true)
			v.nextValue:setVisible(true)
		end
	end
end

function MythicalAnimalsUpStar:onEnterTransitionFinish()
	-- 加载MythicalAnimalsUpStarWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_starUP = res/cultivate/Mythical_animals/mythical_animals_starUP.csb
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_starUP.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_buy_power_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil,
	{
		terminal_name = "mythical_animals_up_star_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 神兽详情
	self.Button_inf = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_inf"), nil,
	{
		terminal_name = "mythical_animals_up_star_open_animal_info",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 购买碎片
	self.Button_buy = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy"), nil,
	{
		terminal_name = "mythical_animals_up_star_open_obtain",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 升星
	self.Button_forging = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_forging"), nil,
	{
		terminal_name = "mythical_animals_up_star_go",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)


	self:onUpdateDraw()
end

function MythicalAnimalsUpStar:onExit()
	-- 释放MythicalAnimalsUpStarWindow界面资源.
	state_machine.remove("mythical_animals_up_star_open")
	state_machine.remove("mythical_animals_up_star_close")
	state_machine.remove("mythical_animals_up_star_show")
	state_machine.remove("mythical_animals_up_star_hide")
	state_machine.remove("mythical_animals_up_star_open_animal_info")
	state_machine.remove("mythical_animals_up_star_open_obtain")
	state_machine.remove("mythical_animals_up_star_go")
end

function MythicalAnimalsUpStar:close()
	-- window event : close.
	
end

function MythicalAnimalsUpStar:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
