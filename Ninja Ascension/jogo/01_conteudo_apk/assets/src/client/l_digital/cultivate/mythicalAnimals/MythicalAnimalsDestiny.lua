--[[ ----------------------------------------------------------------------------
-- 神兽天命页签界面
--]] ----------------------------------------------------------------------------
MythicalAnimalsDestiny = class("MythicalAnimalsDestinyClass", Window)
MythicalAnimalsDestiny.__size = nil

-- 打开窗口
local mythical_animals_destiny_window_open_terminal = {
	_name = "mythical_animals_destiny_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local panel = MythicalAnimalsDestiny:new():init(params)
        fwin:open(panel)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_destiny_window_open_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsDestiny:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	


	-- Initialize role_biography page state machine.
	local function init_mythical_animals_destiny_terminal()
		-- 显示窗口
		local mythical_animals_destiny_show_terminal = {
			_name = "mythical_animals_destiny_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:updateUI()
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local mythical_animals_destiny_hide_terminal = {
			_name = "mythical_animals_destiny_hide",
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

		-- 天命总属性
		local mythical_animals_destiny_open_total_property_terminal = {
			_name = "mythical_animals_destiny_open_total_property",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_destiny_property_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 一键激活
		local mythical_animals_destiny_one_key_activate_terminal = {
			_name = "mythical_animals_destiny_one_key_activate",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.lock("mythical_animals_destiny_one_key_activate")
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- 战力飘字
						smFightingChange()

						-- 刷新界面
						state_machine.excute("mythical_animals_destiny_refresh_ui", 0, nil)

						state_machine.excute("notification_center_update",0,"push_notification_mythical_animal")

						state_machine.excute("mythical_animals_main_ui_refresh_red_dot", 0, 0)

						state_machine.unlock("mythical_animals_destiny_one_key_activate")
					else
						state_machine.unlock("mythical_animals_destiny_one_key_activate")
					end
				end
				NetworkManager:register(protocol_command.magical_animals_activate_fate.code, nil, nil, nil, instance, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新右侧天命
		local mythical_animals_destiny_refresh_ui_terminal = {
			_name = "mythical_animals_destiny_refresh_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					if params ~= nil then
						instance._curLeftSelectIndex = params
					else
						instance._curLeftSelectIndex = MythicalAnimalsHandle.getCurDestinyStep() + 1
					end

					local stageList = MythicalAnimalsHandle.getDestinyStageList()
					if instance._curLeftSelectIndex > #stageList then
						instance._curLeftSelectIndex = #stageList
					elseif instance._curLeftSelectIndex == 0 then
						instance._curLeftSelectIndex = 1
					end

					instance._curMiddleSelectIndex = MythicalAnimalsHandle.getCurDestinyProgress()

					if params == nil then
						instance:updateLeftStoneList()
					end
					instance:selectLeftStone()

					instance:updateMiddleUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开天命任务
		local mythical_animals_destiny_open_task_terminal = {
			_name = "mythical_animals_destiny_open_task",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.excute("mythical_animals_obtain_window_open", 0, {prop = instance._destinyProp, showType = 1})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		

		state_machine.add(mythical_animals_destiny_show_terminal)
		state_machine.add(mythical_animals_destiny_hide_terminal)
		state_machine.add(mythical_animals_destiny_open_total_property_terminal)
		state_machine.add(mythical_animals_destiny_one_key_activate_terminal)
		state_machine.add(mythical_animals_destiny_refresh_ui_terminal)
		state_machine.add(mythical_animals_destiny_open_task_terminal)
		state_machine.init()
	end
	-- call func init role_biography state machine.
	init_mythical_animals_destiny_terminal()
end

-- 对象初始化
function MythicalAnimalsDestiny:init(params)
	local rootWindow = params[1] 
    self._rootWindows = rootWindow

    self._destinyProp = MythicalAnimalsHandle.getDestinyProp()

    self:onInit()
	return self
end

-- 打开对应页签
function MythicalAnimalsDestiny:onInit()
	local csbItem = csb.createNode("cultivate/Mythical_animals/mythical_animals_cell_1.csb")
	self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

	if MythicalAnimalsDestiny.__size == nil then
		MythicalAnimalsDestiny.__size = root:getContentSize()
	end
	self:setContentSize(MythicalAnimalsDestiny.__size)
	self:onUpdateDraw()
end

function MythicalAnimalsDestiny:onUpdateDraw()
	local root = self.roots[1]

	-- 天命总属性
	self.Button_properties = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_properties"), nil,
	{
		terminal_name = "mythical_animals_destiny_open_total_property",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 一键激活
	self.Button_autoActivity = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_autoActivity"), nil,
	{
		terminal_name = "mythical_animals_destiny_one_key_activate",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)
		

	-- 天命任务
	self.Button_task = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task"), nil,
	{
		terminal_name = "mythical_animals_destiny_open_task",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 中间的天命石
	self.Panel_tianming = ccui.Helper:seekWidgetByName(root, "Panel_tianming")

	-- 阶数列表
	self.ListView_3 = ccui.Helper:seekWidgetByName(root, "ListView_3")
		
	-- 5个固定的天命石图片
	self.Panel_stone = {}
	for i = 1, 5 do
		local Panel_stone = ccui.Helper:seekWidgetByName(root, "Panel_stone_"..i)
		table.insert(self.Panel_stone, Panel_stone)
	end

	-- 拥有数量
	self.Text_cost_1 = ccui.Helper:seekWidgetByName(root, "Text_cost_1")

	-- 本次消耗数量
	self.Text_cost_2 = ccui.Helper:seekWidgetByName(root, "Text_cost_2")

	self.Panel_autoActivity = ccui.Helper:seekWidgetByName(root, "Panel_autoActivity")

	self.Image_levelMax = ccui.Helper:seekWidgetByName(root, "Image_levelMax")

	self.Panel_tianming_dh = ccui.Helper:seekWidgetByName(root, "Panel_tianming_dh")

	self.Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")

	self:updateUI()
end

function MythicalAnimalsDestiny:updateUI()
	self._curLeftSelectIndex = MythicalAnimalsHandle.getCurDestinyStep() + 1

	local stageList = MythicalAnimalsHandle.getDestinyStageList()
	if self._curLeftSelectIndex > #stageList then
		self._curLeftSelectIndex = #stageList
	elseif self._curLeftSelectIndex == 0 then
		self._curLeftSelectIndex = 1
	end

	self._curMiddleSelectIndex = MythicalAnimalsHandle.getCurDestinyProgress()

	self:updateLeftStoneList()
	self:selectLeftStone()

	self:updateMiddleUI()
end

function MythicalAnimalsDestiny:updateMiddleUI()
	self:updateMiddleStone()
	self:updateCost()
	self:updateTaskButtonRedPoint()
end

function MythicalAnimalsDestiny:updateLeftStoneList()
	local ListView_3 = self.ListView_3
	ListView_3:removeAllItems()

	local stageList = MythicalAnimalsHandle.getDestinyStageList()
	for i, v in ipairs(stageList) do
		local cell = state_machine.excute("mythical_animals_dstiny_stone_cell_create", 0, {index = i})
		ListView_3:addChild(cell)
	end

	self.ListView_3_poy = self.ListView_3:getInnerContainer():getPositionY()

	local curLeftSelectIndex = self._curLeftSelectIndex

	ListView_3:jumpToPercentVertical((curLeftSelectIndex / #stageList) * 100)

	-- ListView_3:jumpToTop()
	ListView_3:requestRefreshView()
end

-- 选择左侧石头
function MythicalAnimalsDestiny:selectLeftStone()
	local curLeftSelectIndex = self._curLeftSelectIndex

	local items = self.ListView_3:getItems()
	for i, v in ipairs(items) do
		v:setSelectState(false)
		if i == curLeftSelectIndex then
			v:setSelectState(true)
		end
	end
end

function MythicalAnimalsDestiny:updateMiddleStone()
	local Panel_stone = self.Panel_stone
	for i, v in ipairs(Panel_stone) do
		v:removeAllChildren(true)

		local cell = state_machine.excute("mythical_animals_destiny_small_stone_cell", 0, {index = i, curLeftSelectIndex = self._curLeftSelectIndex})
		v:addChild(cell)
	end

	self.Panel_tianming:removeAllChildren(true)

	local stonePicIndex = MythicalAnimalsHandle.getDestinyLeftIconInfoByStage(self._curLeftSelectIndex)
	local sp = cc.Sprite:create(string.format("images/ui/text/TF_res/Mythical_animals/mythical_icon/mythical_icon_%d.png", stonePicIndex))
	sp:setPosition(cc.p(self.Panel_tianming:getContentSize().width/2, self.Panel_tianming:getContentSize().height/2))
	self.Panel_tianming:addChild(sp)
end

function MythicalAnimalsDestiny:updateCost()
	local curLeftSelectIndex = self._curLeftSelectIndex
	local curStep = MythicalAnimalsHandle.getCurDestinyStep() + 1

	self.Panel_tianming_dh:removeAllChildren(true)

	if curLeftSelectIndex < curStep then
		self.Panel_autoActivity:setVisible(false)
		self.Image_levelMax:setVisible(true)
		self:playMillleAni()
	else
		self.Panel_autoActivity:setVisible(true)
		self.Image_levelMax:setVisible(false)

		local haveCount = tonumber(getPropAllCountByMouldId(self._destinyProp[2]))
		self.Text_cost_1:setString(haveCount)

		local needCount = MythicalAnimalsHandle.getCurDestinyCostPropCount()
		self.Text_cost_2:setString("/" .. needCount)

		if haveCount < needCount then
			self.Text_cost_1:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
		else
			self.Text_cost_1:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
		end
	end
end

-- 播放中间的天命石动画
function MythicalAnimalsDestiny:playMillleAni()
	self.Panel_tianming_dh:removeAllChildren(true)

	local jsonFile = "images/ui/effice/effect_shenshou2/effect_shenshou2.json"
	local atlasFile = "images/ui/effice/effect_shenshou2/effect_shenshou2.atlas"

	local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	sp.initArmature(animation, true)
	animation:setAnimation(0, "animation", true)
	animation:setPosition(self.Panel_tianming_dh:getContentSize().width / 2, self.Panel_tianming_dh:getContentSize().height / 2)
	self.Panel_tianming_dh:addChild(animation)
end

function MythicalAnimalsDestiny:updateTaskButtonRedPoint()
	local isShow = false
	local taskData = MythicalAnimalsHandle.getDestinyTaskData()
	for _, v in pairs(taskData) do
		if tonumber(v.status) == 1 then
			isShow = true
			break
		end
	end

	self.Image_red:setVisible(isShow)
end

function MythicalAnimalsDestiny:onUpdate()
	-- if self.ListView_3 ~= nil then
	-- 	local size = self.ListView_3:getContentSize()
	-- 	local posY = self.ListView_3:getInnerContainer():getPositionY()
	-- 	if self.ListView_3_poy == posY then
	-- 		return
	-- 	end
	-- 	self.ListView_3_poy = posY
	-- 	local items = self.ListView_3:getItems()
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

function MythicalAnimalsDestiny:onExit()
	-- 释放RoleBiographyWindow界面资源.
	state_machine.remove("mythical_animals_destiny_show")
	state_machine.remove("mythical_animals_destiny_hide")
	state_machine.remove("mythical_animals_destiny_open_total_property")
	state_machine.remove("mythical_animals_destiny_one_key_activate")
	state_machine.remove("mythical_animals_destiny_refresh_ui")
	state_machine.remove("mythical_animals_destiny_open_task")
end

function MythicalAnimalsDestiny:close()
	-- window event : close.

end

function MythicalAnimalsDestiny:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
