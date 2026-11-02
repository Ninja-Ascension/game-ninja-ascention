--[[ ----------------------------------------------------------------------------
-- 神兽技能配置
--]] ----------------------------------------------------------------------------
MythicalAnimalsSkill = class("MythicalAnimalsSkillClass", Window)

-- 打开窗口
local mythical_animals_skill_window_open_terminal = {
	_name = "mythical_animals_skill_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("MythicalAnimalsSkillClass") then
			fwin:open(MythicalAnimalsSkill:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local mythical_animals_skill_window_close_terminal = {
	_name = "mythical_animals_skill_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MythicalAnimalsSkillClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_skill_window_open_terminal)
state_machine.add(mythical_animals_skill_window_close_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsSkill:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._csbItem = nil
	self._began_pos = nil

	self._openType = nil
	self._extraParams = nil

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_mythical_animals_skill_terminal()
		-- 打开角色创建窗口
		local mythical_animals_skill_open_terminal = {
			_name = "mythical_animals_skill_open",
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
		local mythical_animals_skill_close_terminal = {
			_name = "mythical_animals_skill_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_skill_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local mythical_animals_skill_show_terminal = {
			_name = "mythical_animals_skill_show",
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
		local mythical_animals_skill_hide_terminal = {
			_name = "mythical_animals_skill_hide",
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

		-- 
		local mythical_animals_skill_refresh_ui_terminal = {
			_name = "mythical_animals_skill_refresh_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:updateScrollView()
					instance:updateUseSkillList()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 
		local mythical_animals_skill_set_touched_enable_terminal = {
			_name = "mythical_animals_skill_set_touched_enable",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local panel = instance.ScrollView_1:getInnerContainer()
					panel:setTouchEnabled(params)

					instance.ScrollView_1:setTouchEnabled(params)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 设置使用技能
		local mythical_animals_skill_open_set_up_use_skill_terminal = {
			_name = "mythical_animals_skill_open_set_up_use_skill",
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
					local info = instance:getEquipSkillList()
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
					local info = instance:getEquipSkillList()
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

						if instance._openType == nil then
							local function responseCallback(response)
								if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
									-- 刷新界面
									state_machine.excute("mythical_animals_info_update_skill_list", 0, nil)
									-- 刷新界面
									state_machine.excute("mythical_animals_skill_refresh_ui", 0, nil)

									state_machine.excute("notification_center_update",0,"push_notification_mythical_animal")

									state_machine.excute("mythical_animals_main_ui_refresh_red_dot", 0, 0)
								end
							end
							protocol_command.magical_animals_set_skill.param_list = "" .. result
							NetworkManager:register(protocol_command.magical_animals_set_skill.code, nil, nil, nil, instance, responseCallback, false, nil)
						elseif instance._openType == 1 then
							instance._extraParams.animalSkillList = info
							state_machine.excute("cross_total_war_formation_update_animalSkillList", 0, {index = instance._extraParams.index, data = info})
							state_machine.excute("mythical_animals_skill_refresh_ui", 0, nil)
						elseif instance._openType == 2 then
							instance._extraParams.animalSkillList = info
							state_machine.excute("cross_total_war_attack_formation_update_animalSkillList", 0, {index = instance._extraParams.index, data = info})
							state_machine.excute("mythical_animals_skill_refresh_ui", 0, nil)
						elseif instance._openType == 3 then
							instance._extraParams.animalSkillList = info
							state_machine.excute("team_arena_formation_update_animalSkillList", 0, {index = instance._extraParams.index, data = info})
							state_machine.excute("mythical_animals_skill_refresh_ui", 0, nil)
						end
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_skill_open_terminal)
		state_machine.add(mythical_animals_skill_close_terminal)
		state_machine.add(mythical_animals_skill_show_terminal)
		state_machine.add(mythical_animals_skill_hide_terminal)
		state_machine.add(mythical_animals_skill_refresh_ui_terminal)
		state_machine.add(mythical_animals_skill_set_touched_enable_terminal)
		state_machine.add(mythical_animals_skill_open_set_up_use_skill_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_mythical_animals_skill_terminal()
end

-- 对象初始化
function MythicalAnimalsSkill:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function MythicalAnimalsSkill:onInit(params)
	if params ~= nil then
		-- 界面打开类型
		self._openType = params.openType
		-- 额外参数
		self._extraParams = params.extraParams
	end
end

function MythicalAnimalsSkill:onUpdateDraw()
	local root = self.roots[1]

	self.ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
	self.Panel_view = ccui.Helper:seekWidgetByName(root, "Panel_view")

	-- 三个技能位置
	self.Panel_skill_box = {}
	for i = 1, 3 do
		local Panel_skill_box = ccui.Helper:seekWidgetByName(root, "Panel_skill_box_"..i)
		table.insert(self.Panel_skill_box, Panel_skill_box)
	end

	self:updateScrollView()
	self:updateUseSkillList()
end

function MythicalAnimalsSkill:getHaveSkillList()
	local haveSkillInfo = {}

	local info = MythicalAnimalsHandle.getAllMythicalAnimalsInfo()
	for _, v in pairs(info) do
		local animalMouldId = tonumber(v.maMouldId)
		table.insert(haveSkillInfo, animalMouldId)
	end

	return haveSkillInfo
end

function MythicalAnimalsSkill:getEquipSkillList()
	local info = {}
	if self._openType == nil then
		info = MythicalAnimalsHandle.getSkillInfo()
	elseif self._openType == 1 or self._openType == 2 or self._openType == 3 then
		-- 1 冠军试炼设置防守方阵容
		-- 2 冠军试炼设置攻击方阵容
		-- 3 跨服小队设置防守方阵容
		local listData = self._extraParams.animalSkillList
		for _, v in pairs(listData) do
			table.insert(info, tonumber(v))
		end
	end
	
	return info
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
					state_machine.excute("mythical_animals_skill_open_set_up_use_skill", 0, {changeIndex = changeIndex, changeAnimalMouldId = changeAnimalMouldId})
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

function MythicalAnimalsSkill:updateScrollView()
	local tSortedHeroes = self:getHaveSkillList()

	local m_ScrollView = self.ScrollView_1
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
	local wPosition = sWidth/3

	local Hlindex = 0
	local number = #tSortedHeroes
	local m_number = math.ceil(number/3)

	-- 单个cell高度是scrollview的一半
	cellHeight = m_number*(m_ScrollView:getContentSize().height/2.3)

	sHeight = math.max(sHeight, cellHeight)
	panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
	local first = nil
	for j, v in pairs(tSortedHeroes) do
		local cell = state_machine.excute("mythical_animals_skill_icon_cell_create", 0, {index = j, animalsMouldId = v, isCanDrag = true})

		local layer = ccui.Layout:create()
		layer:setAnchorPoint(cc.p(0, 0))
		layer:setContentSize(cc.size(cell:getContentSize().width, cell:getContentSize().height))
		layer:addChild(cell)

		if animalsMouldId ~= -1 then 
			layer._datas = {_self = self, _animalsMouldId = v, _index = j}
			layer:setTouchEnabled(true)
			-- 设置触摸事件不可传递
			layer:setSwallowTouches(true)
			layer:setPropagateTouchEvents(false)
			layer:addTouchEventListener(skillIconLongTouchCallback)
		end
		panel:addChild(layer)

		local realCellHeight = layer:getContentSize().height
		if j == 1 then
			first = layer
		end
		tWidth = tWidth + wPosition

		if (j-1)%3 ==0 then
			Hlindex = Hlindex+1
			tWidth = 0
			tHeight = sHeight - realCellHeight*Hlindex  
		end
		layer:setPosition(cc.p(tWidth,tHeight))
	end
	m_ScrollView:jumpToTop()
end

function MythicalAnimalsSkill:judgeChangeSkill(newObject, panel, index)
	local changeIndex = nil

	if newObject and panel then
		local worldMenuP = fwin:convertToWorldSpace(newObject, cc.p(0, 0))
	    local rect4 = {}
	    rect4.x = worldMenuP.x
	    rect4.y = worldMenuP.y
	    rect4.width = newObject:getContentSize().width
	    rect4.height = newObject:getContentSize().height

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
function MythicalAnimalsSkill:updateUseSkillList()
	local info = self:getEquipSkillList()
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

function MythicalAnimalsSkill:onEnterTransitionFinish()
	-- 加载MythicalAnimalsSkillWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_skill = res/cultivate/Mythical_animals/mythical_animals_skill.csb
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_skill.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "mythical_animals_skill_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function MythicalAnimalsSkill:onExit()
	-- 释放MythicalAnimalsSkillWindow界面资源.
	state_machine.remove("mythical_animals_skill_open")
	state_machine.remove("mythical_animals_skill_close")
	state_machine.remove("mythical_animals_skill_show")
	state_machine.remove("mythical_animals_skill_hide")
	state_machine.remove("mythical_animals_skill_refresh_ui")
	state_machine.remove("mythical_animals_skill_set_touched_enable")
end

function MythicalAnimalsSkill:close()
	-- window event : close.
	
end

function MythicalAnimalsSkill:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
