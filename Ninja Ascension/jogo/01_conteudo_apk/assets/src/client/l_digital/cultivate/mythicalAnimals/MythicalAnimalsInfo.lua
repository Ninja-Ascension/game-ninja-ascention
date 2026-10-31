--[[ ----------------------------------------------------------------------------
-- 神兽信息页签界面
--]] ----------------------------------------------------------------------------
MythicalAnimalsInfo = class("MythicalAnimalsInfoClass", Window)
MythicalAnimalsInfo.__size = nil

-- 打开窗口
local mythical_animals_info_window_open_terminal = {
	_name = "mythical_animals_info_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local panel = MythicalAnimalsInfo:new():init(params)
        fwin:open(panel)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_info_window_open_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsInfo:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._csbItem = nil
	self._began_pos = nil

	self._nowSelectAnimalId = nil
	self._curSelectAnimalIndx = nil

	-- Initialize role_biography page state machine.
	local function init_mythical_animals_info_terminal()
		-- 显示窗口
		local mythical_animals_info_show_terminal = {
			_name = "mythical_animals_info_show",
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
		local mythical_animals_info_hide_terminal = {
			_name = "mythical_animals_info_hide",
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

		-- 打开神兽配置界面
		local mythical_animals_info_open_set_up_skill_terminal = {
			_name = "mythical_animals_info_open_set_up_skill",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_skill_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开技能释放顺序界面
		local mythical_animals_info_open_set_up_skill_order_terminal = {
			_name = "mythical_animals_info_open_set_up_skill_order",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_skill_config_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 设置使用技能
		local mythical_animals_info_open_set_up_use_skill_terminal = {
			_name = "mythical_animals_info_open_set_up_use_skill",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local changeIndex = params.changeIndex
					local changeAnimalMouldId = params.changeAnimalMouldId

					local preIndex = nil
					local info = MythicalAnimalsHandle.getSkillInfo()
					for i, v in ipairs(info) do
						if v == changeAnimalMouldId then
							preIndex = i
							break
						end
					end

					local preAnimalMouldId = -1
					for i, v in ipairs(info) do
						if i == changeIndex then
							preAnimalMouldId = v
							break
						end
					end

					local isChange = false
					local info = MythicalAnimalsHandle.getSkillInfo()
					for i, v in ipairs(info) do
						if i == changeIndex then
							if v ~= changeAnimalMouldId then
								isChange = true
								break
							end
						end
					end

					-- print("changeIndex = ", changeIndex, " changeAnimalMouldId = ", changeAnimalMouldId)
					-- print("preIndex = ", preIndex, " preAnimalMouldId = ", preAnimalMouldId)
					-- print("isChange = ", isChange)

					if isChange == true then
						local result = ""

						for i = 1, 3 do
							if preIndex ~= nil then
								info[preIndex] = preAnimalMouldId
							end

							if changeIndex ~= nil then
								info[changeIndex] = changeAnimalMouldId
							end

							result = result .. info[i]
							if i < #info then
								result = result .. ","
							end
						end

						-- print("result = ", result, " isChange = ", isChange)
						local function responseCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								-- 刷新界面
								instance:updateSkillList()
								-- 刷新界面
								state_machine.excute("mythical_animals_skill_refresh_ui", 0, nil)

								state_machine.excute("notification_center_update",0,"push_notification_mythical_animal")

								state_machine.excute("mythical_animals_main_ui_refresh_red_dot", 0, 0)
							end
						end
						protocol_command.magical_animals_set_skill.param_list = "" .. result
						NetworkManager:register(protocol_command.magical_animals_set_skill.code, nil, nil, nil, instance, responseCallback, false, nil)
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 打开技能释放顺序界面
		local mythical_animals_info_update_skill_list_terminal = {
			_name = "mythical_animals_info_update_skill_list",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:updateSkillList()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 切换分页
		local mythical_animals_info_turn_page_terminal = {
			_name = "mythical_animals_info_turn_page",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					local dir = params._datas._dir
					local maxCount = #instance._haveActivateList

					if dir > 0 then
						self._curSelectAnimalIndx = self._curSelectAnimalIndx + 1
						if self._curSelectAnimalIndx > maxCount then
							self._curSelectAnimalIndx = 1
						end
					else
						self._curSelectAnimalIndx = self._curSelectAnimalIndx - 1
						if self._curSelectAnimalIndx < 1 then
							self._curSelectAnimalIndx = maxCount
						end
					end

					instance:updateModel()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_info_show_terminal)
		state_machine.add(mythical_animals_info_hide_terminal)
		state_machine.add(mythical_animals_info_open_set_up_skill_terminal)
		state_machine.add(mythical_animals_info_open_set_up_skill_order_terminal)
		state_machine.add(mythical_animals_info_open_set_up_use_skill_terminal)
		state_machine.add(mythical_animals_info_update_skill_list_terminal)
		state_machine.add(mythical_animals_info_turn_page_terminal)
		state_machine.init()
	end
	-- call func init role_biography state machine.
	init_mythical_animals_info_terminal()
end

-- 对象初始化
function MythicalAnimalsInfo:init(params)
	local rootWindow = params[1] 
    self._rootWindows = rootWindow      
    self:onInit()
	return self
end

-- 打开对应页签
function MythicalAnimalsInfo:onInit()
	local csbItem = csb.createNode("cultivate/Mythical_animals/mythical_animals_cell_0.csb")
	self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

	if MythicalAnimalsInfo.__size == nil then
		MythicalAnimalsInfo.__size = root:getContentSize()
	end
	self:setContentSize(MythicalAnimalsInfo.__size)
	self:onUpdateDraw()
end

function MythicalAnimalsInfo:onUpdateDraw()
	local root = self.roots[1]

	-- 配置
	self.Button_config = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_config"), nil,
	{
		terminal_name = "mythical_animals_info_open_set_up_skill",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 技能释放顺序设置
	self.Button_line = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_line"), nil,
	{
		terminal_name = "mythical_animals_info_open_set_up_skill_order",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Panel_armatureNode = ccui.Helper:seekWidgetByName(root, "Panel_armatureNode")
	self.ListView_prop = ccui.Helper:seekWidgetByName(root, "ListView_prop")
	self.Panel_view = ccui.Helper:seekWidgetByName(root, "Panel_view")

	-- 三个技能位置
	self.Panel_skill_box = {}
	for i = 1, 3 do
		local Panel_skill_box = ccui.Helper:seekWidgetByName(root, "Panel_skill_box_"..i)
		table.insert(self.Panel_skill_box, Panel_skill_box)
	end

	-- 左翻页
	self.Image_left = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_left"), nil,
	{
		terminal_name = "mythical_animals_info_turn_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_dir = -1
	}, nil, 0)

	-- 右翻页
	self.Image_right = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_right"), nil,
	{
		terminal_name = "mythical_animals_info_turn_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_dir = 1
	}, nil, 0)

	self.Image_left:setTouchEnabled(true)
	self.Image_right:setTouchEnabled(true)
	-- 限定神兽标签挂载控件
	self.Panel_effect_sp = ccui.Helper:seekWidgetByName(root, "Panel_effect_sp")
	self:updateUI()
end

function MythicalAnimalsInfo:updateUI()
	self:updateModel()
	self:updatePropertyList()
	self:updateSkillList()
	self:updateTurnButtonState()
end

-- 设置翻页按钮的显示隐藏状态
function MythicalAnimalsInfo:updateTurnButtonState()
	local info = MythicalAnimalsHandle.getAllMythicalAnimalsInfo()

	local isShow = false
	if info ~= nil and table.nums(info) > 0 then
		isShow = true
	end

	self.Image_left:setVisible(isShow)
	self.Image_right:setVisible(isShow)
end

-- 创建模型
function MythicalAnimalsInfo:updateModel()
	local Panel_armatureNode = self.Panel_armatureNode
	Panel_armatureNode:removeAllChildren(true)

	self:addHeroAnimation(Panel_armatureNode)
end

function MythicalAnimalsInfo:addHeroAnimation(widget)
	local nowSelectAnimalId = dms.int(dms["play_config"], 217, play_config.param)
	self._nowSelectAnimalId = nowSelectAnimalId

	if self._nowSelectAnimalId ~= nil then
		if self._curSelectAnimalIndx == nil then
			self._curSelectAnimalIndx = 1
		end

		self._haveActivateList = {}

		for _, v in ipairs(dms["magical_animals_mould"]) do
			local id = dms.atof(v, magical_animals_mould.id)
			local animalsInfo = MythicalAnimalsHandle.getMythicalAnimalsInfoById(id)
			if animalsInfo ~= nil then
				table.insert(self._haveActivateList, id)
			end
		end
		for i, v in ipairs(self._haveActivateList) do
			if self._curSelectAnimalIndx == i then
				nowSelectAnimalId = v
				self._curSelectAnimalIndx = i
				break
			end
		end

		self._nowSelectAnimalId = nowSelectAnimalId
	end


    local spriteId = dms.int(dms["magical_animals_mould"], self._nowSelectAnimalId, magical_animals_mould.spriteId)

    local hero_animation = sp.spine_sprite(widget, spriteId, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
	hero_animation.animationNameList = spineAnimations
	sp.initArmature(hero_animation, true)
	-- 限定神兽标签
	if self.Panel_effect_sp then 
		self.Panel_effect_sp:removeAllChildren(true)
		self.Panel_effect_sp:setVisible(false)
		DisplayLimitAnimal(self._nowSelectAnimalId, nil, self.Panel_effect_sp, 3)
	end
end

-- 绘制属性列表
function MythicalAnimalsInfo:updatePropertyList()
	local ListView_prop = self.ListView_prop
	ListView_prop:removeAllItems()

	local animalPropertyTypeList = {}
	for k in pairs(MythicalAnimalsHandle.AnimalPropertyTypeMap) do
		table.insert(animalPropertyTypeList, k)
	end
	table.sort(animalPropertyTypeList, function(a, b)
		return a < b
	end)

	local result = {}
	local animallProperty = MythicalAnimalsHandle.getAnimallProperty()
    for i, v in ipairs(animalPropertyTypeList) do
    	local propertyType = v
    	local propertyValue = animallProperty[propertyType] or 0
        table.insert(result, {propertyType = propertyType, propertyValue = propertyValue})
    end

	for _, v in ipairs(result) do
		local cell = state_machine.excute("mythical_animals_info_property_cell_create", 0, v)
		ListView_prop:addChild(cell)
	end
end

local function skillIconLongTouchCallback(sender, eventType)
	local _self = sender._datas._self
	local _animalsMouldId = sender._datas._animalsMouldId
	local _index = sender._datas._index

	local __spoint = sender:getTouchBeganPosition()
	local __mpoint = sender:getTouchMovePosition()
	local __epoint = sender:getTouchEndPosition()   
	if eventType == ccui.TouchEventType.began then
		if _self._csbItem == nil then
    		local info = MythicalAnimalsHandle.getAnimalsSkillInfoById(_animalsMouldId)
			local talentMouldId = info.talentMouldId

			--天赋模板id
			local pic_index = dms.int(dms["talent_mould"], talentMouldId, talent_mould.new_skill_pic)
			_self._csbItem = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", pic_index))

	        sender:addChild(_self._csbItem)
	        _self._began_pos = cc.p(sender:getContentSize().width/2, sender:getContentSize().height/2)
			_self._csbItem:setPosition(_self._began_pos)

	        local e_position = fwin:convertToWorldSpace(_self._csbItem, _self._began_pos)
	        e_position = _self.roots[1]:convertToNodeSpace(cc.p(e_position.x, e_position.y))
	        _self._began_pos = e_position
	        _self._csbItem:removeFromParent(true)
	        _self._csbItem:setPosition(cc.p(e_position.x, e_position.y))
	        _self.roots[1]:addChild(_self._csbItem)

	        _self._csbItem:setLocalZOrder(1000000)

	        _self._csbItem:setVisible(false)
        end

    elseif eventType == ccui.TouchEventType.moved then
    	if _self._csbItem ~= nil then
        	_self._csbItem:setVisible(true)
        	_self._csbItem:setPosition(cc.p((__mpoint.x - __spoint.x) / app.scaleFactor  + _self._began_pos.x , (__mpoint.y - __spoint.y) / app.scaleFactor + _self._began_pos.y))
        end
   	elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
		local moveX = 0
		local moveY = 0

		if eventType == ccui.TouchEventType.ended then
            local endPos = sender:getTouchEndPosition()
            moveX, moveY = endPos.x - __spoint.x, endPos.y - __spoint.y
        else
            local movePos = sender:getTouchMovePosition()
            moveX, moveY = movePos.x - __spoint.x, movePos.y - __spoint.y
        end

        -- 点击
        if moveX > 10 or moveX < -10 or moveY > 10 or moveY < -10 then
        	for i, panel in ipairs(_self.Panel_skill_box) do
				local changeIndex = _self:judgeChangeSkill(_self._csbItem, panel, i)
				if changeIndex ~= nil then
					local changeAnimalMouldId = _animalsMouldId
					state_machine.excute("mythical_animals_info_open_set_up_use_skill", 0, {changeIndex = changeIndex, changeAnimalMouldId = changeAnimalMouldId})
				end
			end
        else
			state_machine.excute("mythical_animals_skill_icon_cell_select", 0, _animalsMouldId)
        end

		if _self._csbItem then
			_self._csbItem:removeFromParent(true)
			_self._csbItem = nil
			_self._began_pos = nil 
		end
	end
end

function MythicalAnimalsInfo:judgeChangeSkill(newObject, panel, index)
	local changeIndex = nil

	if newObject and panel then
		local worldMenuP = fwin:convertToWorldSpace(newObject, cc.p(0, 0))
	    local rect4 = {}
	    rect4.x = worldMenuP.x
	    rect4.y = worldMenuP.y
	    rect4.width = newObject:getContentSize().width - 20
	    rect4.height = newObject:getContentSize().height - 20

    	local rect3 = {}
		local worldvp = fwin:convertToWorldSpace(panel, cc.p(0, 0))
		rect3.x = worldvp.x
		rect3.y = worldvp.y
		rect3.width = panel:getContentSize().width
		rect3.height = panel:getContentSize().height

		if cc.rectIntersectsRect(rect3, rect4) == true then
			changeIndex = index
		end
    end
	
	return changeIndex
end

-- 绘制技能列表
function MythicalAnimalsInfo:updateSkillList()
	local info = MythicalAnimalsHandle.getSkillInfo()
	for i, v in ipairs(self.Panel_skill_box) do
		self:runAction(cc.Sequence:create({cc.DelayTime:create(i*0.01), cc.CallFunc:create(function (sender)
			v:removeAllChildren(true)

			local animalsMouldId = info[i]
			local cell = state_machine.excute("mythical_animals_skill_icon_cell_create", 0, {index = i, animalsMouldId = animalsMouldId, isCanDrag = true})
			v:addChild(cell)

			if animalsMouldId ~= -1 then
				v._datas = {_self = self, _animalsMouldId = animalsMouldId, _index = i}
				v:setTouchEnabled(true)
				v:setSwallowTouches(true)
				v:setPropagateTouchEvents(false)
				v:addTouchEventListener(skillIconLongTouchCallback)
			end
		end)}))
	end
end

function MythicalAnimalsInfo:onExit()
	-- 释放RoleBiographyWindow界面资源.
	state_machine.remove("mythical_animals_info_show")
	state_machine.remove("mythical_animals_info_hide")
	state_machine.remove("mythical_animals_info_open_set_up_skill")
	state_machine.remove("mythical_animals_info_open_set_up_skill_order")
	state_machine.remove("mythical_animals_info_open_set_up_use_skill")
	state_machine.remove("mythical_animals_info_update_skill_list")
	state_machine.remove("mythical_animals_info_turn_page")
end

function MythicalAnimalsInfo:close()
	-- window event : close.

end

function MythicalAnimalsInfo:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
