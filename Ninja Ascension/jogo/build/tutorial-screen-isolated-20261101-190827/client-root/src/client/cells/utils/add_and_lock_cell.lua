----------------------------------------------------------------------------------------------------
-- 说明：提供游戏中各种加号的绘图及相就的界面逻辑处理
-------------------------------------------------------------------------------------------------------
AddAndLockCell = class("AddAndLockCellClass", Window)

function AddAndLockCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0
	self.enum_type = {
		_FORMATION_BUDDY_INTERFACE = 1,	-- 小伙伴
		_FORMATION_SHIP_ADD_INTERFACE = 2,		-- 阵容界面武将上阵的加号
		_FORMATION_LOCK_INTERFACE = 3,	-- 阵容界面的锁
	}
	self.data = {}		-- 根据不同的界面提供相应的逻辑数据
	self.num = nil
	self.panelOne = nil
	self.panelTwo = nil
	self.panelThree = nil
	self.choose = nil
	-- 初始化武将小像事件响应需要使用的状态机
	local function init_add_and_lock_cell_terminal()
		
		-- 设计在阵容界面，点击阵容空位上面的小加号需要处理的逻辑
		-- local add_action_cell_ship_for_ship_terminal = {
            -- _name = "add_action_cell_ship_for_ship",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- local data = params._datas._data
				-- state_machine.excute("open_add_ship_window", 0, data)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		
		-- 添加需要使用的状态机到状态机管理器去
		-- state_machine.add(add_action_cell_ship_for_ship_terminal)
        state_machine.init()
	end
	init_add_and_lock_cell_terminal()
end


function AddAndLockCell:setScalePanel(n)
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Panel_5"):setScale(n)
end


function AddAndLockCell:onUpdateDraw()
	local root = self.roots[1]
	-- self.size = root:getContentSize()
	-- self:setContentSize(self.size)
	-- root:setSwallowTouches(false)

	if self.current_type == self.enum_type._FORMATION_BUDDY_INTERFACE then
		ccui.Helper:seekWidgetByName(root, "Panel_2"):setVisible(true)
		
	elseif self.current_type == self.enum_type._FORMATION_SHIP_ADD_INTERFACE then 
		ccui.Helper:seekWidgetByName(root, "Panel_3"):setVisible(true)
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_formation",
		_widget = root,
		_invoke = nil,
		_interval = 1,})
	elseif self.current_type == self.enum_type._FORMATION_LOCK_INTERFACE then
		
		ccui.Helper:seekWidgetByName(root, "Panel_4"):setVisible(true)
		local openLevel = {}
		openLevel = dms.searchs(dms["user_experience_param"], user_experience_param.battle_unit, self.num)
		ccui.Helper:seekWidgetByName(root, "Text_1"):setString(openLevel[1][2])
	end
	
	ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(true)
end

function AddAndLockCell:onEnterTransitionFinish()
	if table.getn(self.roots) > 0 then
		return
	end
end
function AddAndLockCell:onInit()
	if table.getn(self.roots) > 0 then
		return
	end
	local filePath = nil
	filePath = "utils/xiaohuoban.csb"
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

	-- if self.current_type == self.enum_type._FORMATION_SHIP_ADD_INTERFACE then
		-- fwin:addTouchEventListener(root, nil, {terminal_name = "add_action_cell_ship_for_ship", terminal_state = 0, _data = self.data}, nil, 0)
	-- elseif self.current_type == self.enum_type._FORMATION_EQUIPMENT_ADD_INTERFACE then
		-- fwin:addTouchEventListener(root, nil, {terminal_name = "add_action_cell_equipment_for_ship", terminal_state = 0, _data = self.data}, nil, 0)
	-- elseif self.current_type == self.enum_type._FORMATION_PARTNER_ADD_INTERFACE	then
		-- fwin:addTouchEventListener(root, nil, {terminal_name = "add_action_cell_partner_for_ship", terminal_state = 0, _data = self.data}, nil, 0)
	-- else
		--> debug.log(true, "error")
	-- end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		
		self.panelOne = ccui.Helper:seekWidgetByName(root, "Panel_2")
		self.panelTwo = ccui.Helper:seekWidgetByName(root, "Panel_3")
		self.panelThree = ccui.Helper:seekWidgetByName(root, "Panel_4")
		self.choose = ccui.Helper:seekWidgetByName(root, "Image_5")
	end
	
end

function AddAndLockCell:onExit()
	self.choose = nil
	-- state_machine.remove("add_action_cell_ship_for_ship")
end

function AddAndLockCell:init(interfaceType, data,num)
	self.current_type = interfaceType
	self.data = data
	if num ~= nil then
		self.num = num
	end
	self:onInit()
end

function AddAndLockCell:createCell()
	local cell = AddAndLockCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

