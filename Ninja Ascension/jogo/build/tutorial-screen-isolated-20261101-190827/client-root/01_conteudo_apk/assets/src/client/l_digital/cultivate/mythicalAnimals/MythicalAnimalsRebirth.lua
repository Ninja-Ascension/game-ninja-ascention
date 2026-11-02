--[[ ----------------------------------------------------------------------------
-- 重生
--]] ----------------------------------------------------------------------------
MythicalAnimalsRebirth = class("MythicalAnimalsRebirthClass", Window)

-- 打开窗口
local mythical_animals_rebirth_window_open_terminal = {
	_name = "mythical_animals_rebirth_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("MythicalAnimalsRebirthClass") then
			fwin:open(MythicalAnimalsRebirth:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local mythical_animals_rebirth_window_close_terminal = {
	_name = "mythical_animals_rebirth_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MythicalAnimalsRebirthClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_rebirth_window_open_terminal)
state_machine.add(mythical_animals_rebirth_window_close_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsRebirth:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_mythical_animals_rebirth_terminal()
		-- 打开角色创建窗口
		local mythical_animals_rebirth_open_terminal = {
			_name = "mythical_animals_rebirth_open",
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
		local mythical_animals_rebirth_close_terminal = {
			_name = "mythical_animals_rebirth_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_rebirth_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local mythical_animals_rebirth_show_terminal = {
			_name = "mythical_animals_rebirth_show",
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
		local mythical_animals_rebirth_hide_terminal = {
			_name = "mythical_animals_rebirth_hide",
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

		-- 重生
		local mythical_animals_rebirth_go_terminal = {
			_name = "mythical_animals_rebirth_go",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local prop = MythicalAnimalsHandle.getRestStageCostProp()
					local haveCount = tonumber(getPropAllCountByMouldId(prop[2]))

					if haveCount >= tonumber(prop[3]) then
						TipDlg.drawTextDailog(tipStringInfo_magical_animals_word[14])
						return
					end

					local curAnimalsMouldId = instance._curAnimalsMouldId
					if curAnimalsMouldId == nil then
						TipDlg.drawTextDailog(tipStringInfo_magical_animals_word[8])
					else
						state_machine.lock("mythical_animals_rebirth_go")
						local function responseCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								-- 战力飘字
								smFightingChange()

								local getRewardWnd = DrawRareReward:new()
								getRewardWnd:init(7)
								fwin:open(getRewardWnd, fwin._ui)

								-- 刷新界面
								state_machine.excute("mythical_animals_refresh_ui", 0, nil)

								state_machine.excute("notification_center_update",0,"push_notification_mythical_animal")

								state_machine.excute("mythical_animals_main_ui_refresh_red_dot", 0, 0)

								state_machine.unlock("mythical_animals_rebirth_go")

								state_machine.excute("mythical_animals_rebirth_close", 0, nil)
							else
								state_machine.unlock("mythical_animals_rebirth_go")
							end
						end
						protocol_command.magical_animals_steps_rebirth.param_list = "" .. curAnimalsMouldId
						NetworkManager:register(protocol_command.magical_animals_steps_rebirth.code, nil, nil, nil, instance, responseCallback, false, nil)
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开重生选择界面
		local mythical_animals_rebirth_open_choice_terminal = {
			_name = "mythical_animals_rebirth_open_choice",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_rebirth_choice_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新界面
		local mythical_animals_rebirth_refresh_ui_terminal = {
			_name = "mythical_animals_rebirth_refresh_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance._curAnimalsMouldId = params
					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_rebirth_open_terminal)
		state_machine.add(mythical_animals_rebirth_close_terminal)
		state_machine.add(mythical_animals_rebirth_show_terminal)
		state_machine.add(mythical_animals_rebirth_hide_terminal)
		state_machine.add(mythical_animals_rebirth_go_terminal)
		state_machine.add(mythical_animals_rebirth_open_choice_terminal)
		state_machine.add(mythical_animals_rebirth_refresh_ui_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_mythical_animals_rebirth_terminal()
end

-- 对象初始化
function MythicalAnimalsRebirth:init(params)
	self._curAnimalsMouldId = nil

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function MythicalAnimalsRebirth:onUpdateDraw()
	local root = self.roots[1]

	-- 消耗数量
	self.Text_quanaity_n = ccui.Helper:seekWidgetByName(root, "Text_quanaity_n")
	self.Image_2_0 = ccui.Helper:seekWidgetByName(root, "Image_2_0")
	self.Image_1_0 = ccui.Helper:seekWidgetByName(root, "Image_1_0")
	self.Text_prompt = ccui.Helper:seekWidgetByName(root, "Text_prompt")
	
	self:updateUI()
end

function MythicalAnimalsRebirth:updateUI()
	self.Text_prompt:setVisible(false)
	self.Button_add:setTouchEnabled(true)

	self.Panel_mythical_animals:removeAllChildren(true)

	if self._curAnimalsMouldId == nil then
		self.Panel_mythical_animals:setVisible(false)
		self.Button_add:setVisible(true)
		self.Image_1_0:setVisible(true)
	else
		self.Panel_mythical_animals:setVisible(true)
		self.Button_add:setVisible(false)
		self.Image_1_0:setVisible(false)

		self:updateAnimalModel()
	end

	local prop = MythicalAnimalsHandle.getRestStageCostProp()
	self.Text_quanaity_n:setString(prop[3])

	local resultList = {}

 	local data = dms["magical_animals_mould"]
    for _, v in ipairs(data) do
        local id = dms.atof(v, magical_animals_mould.id)
        -- 神锻过
        if MythicalAnimalsHandle.getAnimalsHaveForgeStateById(id) == true then
            table.insert(resultList, id)
        end
    end

    if #resultList <= 0 then
    	self.Text_prompt:setVisible(true)
    	self.Button_add:setTouchEnabled(false)
    end
end

function MythicalAnimalsRebirth:updateAnimalModel()
	self.Panel_mythical_animals:removeAllChildren(true)
	self:addHeroAnimation(self.Panel_mythical_animals)
end
-- 
function MythicalAnimalsRebirth:addHeroAnimation(widget)
    local spriteId = dms.int(dms["magical_animals_mould"], self._curAnimalsMouldId, magical_animals_mould.spriteId)

    local hero_animation = sp.spine_sprite(widget, spriteId, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
	hero_animation.animationNameList = spineAnimations
	sp.initArmature(hero_animation, true)
end

function MythicalAnimalsRebirth:onEnterTransitionFinish()
	-- 加载MythicalAnimalsRebirthWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_rebirth = res/cultivate/Mythical_animals/mythical_animals_rebirth.csb
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_rebirth.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "mythical_animals_rebirth_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 重生
	self.Button_rebirth = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rebirth"), nil,
	{
		terminal_name = "mythical_animals_rebirth_go",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 打开重生选择界面
	self.Button_add = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil,
	{
		terminal_name = "mythical_animals_rebirth_open_choice",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 打开重生选择界面/神兽容器
	self.Panel_mythical_animals = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_mythical_animals"), nil,
	{
		terminal_name = "mythical_animals_rebirth_open_choice",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

function MythicalAnimalsRebirth:onExit()
	-- 释放MythicalAnimalsRebirthWindow界面资源.
	state_machine.remove("mythical_animals_rebirth_open")
	state_machine.remove("mythical_animals_rebirth_close")
	state_machine.remove("mythical_animals_rebirth_show")
	state_machine.remove("mythical_animals_rebirth_hide")
	state_machine.remove("mythical_animals_rebirth_go")
	state_machine.remove("mythical_animals_rebirth_open_choice")
	state_machine.remove("mythical_animals_rebirth_refresh_ui")
end

function MythicalAnimalsRebirth:close()
	-- window event : close.
	
end

function MythicalAnimalsRebirth:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
