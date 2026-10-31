----------------------------------------------------------------------------------------------------
-- 说明：提供游戏中各种加号的绘图及相就的界面逻辑处理
-------------------------------------------------------------------------------------------------------
AddActionCellCell = class("AddActionCellClass", Window)

function AddActionCellCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0
	self.enum_type = {
		_FORMATION_EQUIPMENT_ADD_INTERFACE = 1,	-- 阵容界面装备添加的加号
		_FORMATION_SHIP_ADD_INTERFACE = 2,		-- 阵容界面武将上阵的加号
		_FORMATION_PARTNER_ADD_INTERFACE = 3,	-- 阵容界面小伙伴上阵的加号
	}
	self.data = {}		-- 根据不同的界面提供相应的逻辑数据
	self.tipTypes = nil
	self.isHaveShip = true -- 是否存在英雄 没有上阵的英雄是不显示提示穿戴装备

	-- 初始化武将小像事件响应需要使用的状态机
	local function init_add_action_cell_terminal()
		
		-- 设计在阵容界面，点击装备空位上面的小加号需要处理的逻辑
		local add_action_cell_equipment_for_ship_terminal = {
            _name = "add_action_cell_equipment_for_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 在这里处理阵容界面，点击装备空位上面的小加号后的响应逻辑
            	local data = params._datas._data
				if tonumber(data) < 4 then
					if dms.int(dms["fun_open_condition"], 7, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
						state_machine.excute("open_add_ship_equip_window", 0, data)
					else
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 7, fun_open_condition.tip_info))
					end
				elseif tonumber(data) >= 4 then
					if dms.int(dms["fun_open_condition"], 8, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
						state_machine.excute("open_add_ship_equip_window", 0, data)
					else
						TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 8, fun_open_condition.tip_info))
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 设计在阵容界面，点击阵容空位上面的小加号需要处理的逻辑
		local add_action_cell_ship_for_ship_terminal = {
            _name = "add_action_cell_ship_for_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 在这里处理阵容界面，点击阵容空位上面的小加号后的响应逻辑
				local data = params._datas._data
				state_machine.excute("open_add_ship_window", 0, data)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 设计在小伙伴界面，点击空位上面的小加号需要处理的逻辑
		local add_action_cell_partner_for_ship_terminal = {
            _name = "add_action_cell_partner_for_ship",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- 在这里处理阵容界面，点击阵容空位上面的小加号后的响应逻辑
        		--判断是否上阵满了，才可以上阵援军
        		local counts = 0
        		for i = 1, 6 do
					local shipType = 0
					local shipId = _ED.user_formetion_status[i]
					if zstring.tonumber(shipId) > 0 then
						counts = counts + 1
					end
				end
				if counts < 6 then 
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
						TipDlg.drawTextDailog(_string_piece_info[432])
					else
						TipDlg.drawTextDailog(_string_piece_info[386])
					end
					
					return
				end
				local data = params._datas._data
				state_machine.excute("open_add_partner_ship_window", 0, data)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(add_action_cell_equipment_for_ship_terminal)	
		state_machine.add(add_action_cell_ship_for_ship_terminal)
		state_machine.add(add_action_cell_partner_for_ship_terminal)	
        state_machine.init()
	end
	init_add_action_cell_terminal()
end

function AddActionCellCell:onUpdateDraw()
	local root = self.roots[1]
	-- self.size = root:getContentSize()
	-- self:setContentSize(self.size)
	-- root:setSwallowTouches(false)
	if self.current_type == self.enum_type._FORMATION_EQUIPMENT_ADD_INTERFACE then
		root:getChildByName("Panel_zhuangbei"):setVisible(true)
		if self.tipTypes~= nil and tonumber(self.tipTypes)~=-1 then
			root:getChildByName("Panel_zhuangbei")._data = self.data
			if tonumber(self.data) < 4 then
				if dms.int(dms["fun_open_condition"], 7, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
					local isCanPush = true
					if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
						if self.isHaveShip == false then 
							isCanPush = false
						end
					else
						isCanPush = true
					end
					if isCanPush == true then 
						state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_equipment",
						_widget = root:getChildByName("Panel_zhuangbei"),
						_invoke = nil,
						_interval = 0.5,})
					else
						state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_equipment",
						_widget = nil,
						_invoke = nil,
						_interval = 0.5,})
						local zbButton = root:getChildByName("Panel_zhuangbei")
						local chidlBall = zbButton:getChildByName("tipBall")
						if chidlBall ~= nil then 
							zbButton:removeChildByName("tipBall")
						end
						
					end
				end
			elseif tonumber(self.data) >= 4 then
				if dms.int(dms["fun_open_condition"], 8, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
					local isCanPush = true
					if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
						if self.isHaveShip == false then 
							isCanPush = false
						end
					else
						isCanPush = true
					end
					if isCanPush == true then
						state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_equipment",
						_widget = root:getChildByName("Panel_zhuangbei"),
						_invoke = nil,
						_interval = 0.5,})
					else
						state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation_equipment",
						_widget = nil,
						_invoke = nil,
						_interval = 0.5,})
						local zbButton = root:getChildByName("Panel_zhuangbei")
						local chidlBall = zbButton:getChildByName("tipBall")
						if chidlBall ~= nil then 
							zbButton:removeChildByName("tipBall")
						end
					end
				end
			end
			
		end
	elseif self.current_type == self.enum_type._FORMATION_SHIP_ADD_INTERFACE then 
		root:getChildByName("Panel_zrlb"):setVisible(true)
	elseif self.current_type == self.enum_type._FORMATION_PARTNER_ADD_INTERFACE then
		root:getChildByName("Panel_yuanfen"):setVisible(true)
	end
end

function AddActionCellCell:onEnterTransitionFinish()

end

function AddActionCellCell:onInit()
	local filePath = nil
	filePath = "icon/box_add.csb"
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	self.size = root:getContentSize()
	self:setContentSize(self.size)
	root:setSwallowTouches(false)

	self:onUpdateDraw()
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)

	if self.current_type == self.enum_type._FORMATION_SHIP_ADD_INTERFACE then
		fwin:addTouchEventListener(root, nil, {terminal_name = "add_action_cell_ship_for_ship", terminal_state = 0, _data = self.data}, nil, 0)
	elseif self.current_type == self.enum_type._FORMATION_EQUIPMENT_ADD_INTERFACE then
		fwin:addTouchEventListener(root, nil, {terminal_name = "add_action_cell_equipment_for_ship", terminal_state = 0, _data = self.data}, nil, 0)
	elseif self.current_type == self.enum_type._FORMATION_PARTNER_ADD_INTERFACE	then
		fwin:addTouchEventListener(root, nil, {terminal_name = "add_action_cell_partner_for_ship", terminal_state = 0, _data = self.data}, nil, 0)
	else
		--> debug.log(true, "error")
	end
end

function AddActionCellCell:onExit()
	-- state_machine.remove("add_action_cell_ship_for_ship")
	-- state_machine.remove("add_action_cell_equipment_for_ship")
	-- state_machine.remove("add_action_cell_partner_for_ship")
end

function AddActionCellCell:init(interfaceType, data, tipsType,isHaveShip)
	self.current_type = interfaceType
	self.data = data
	self.tipTypes = tipsType
	if isHaveShip ~= nil then 
		self.isHaveShip = isHaveShip
	else
		self.isHaveShip = true
	end

	self:onInit()
end

function AddActionCellCell:createCell()
	local cell = AddActionCellCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

