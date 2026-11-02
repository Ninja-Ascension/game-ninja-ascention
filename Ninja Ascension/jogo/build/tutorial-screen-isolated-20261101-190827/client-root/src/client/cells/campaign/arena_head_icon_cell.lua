----------------------------------------------------------------------------------------------------
-- 说明：用于查看他人阵容的 小头像 图标绘制
-------------------------------------------------------------------------------------------------------
ArenaHeadIconCell = class("ArenaHeadIconCellClass", Window)

function ArenaHeadIconCell:ctor()
    self.super:ctor()
	app.load("client.utils.objectMessage.ObjectMessage")
	app.load("client.cells.ship.ship_head_cell")
    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0
	
	self.userPic = nil
	-- -- 初始化事件响应需要使用的状态机
	-- local function init_Plunder_icon_cell_terminal()
		
		-- local plunder_icon_cell_set_chosen_terminal = {
            -- _name = "plunder_icon_cell_set_chosen",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
            	
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		
		-- -- 添加需要使用的状态机到状态机管理器去
		-- state_machine.add(Plunder_icon_cell_change_ship_Plunder_terminal)	
			
        -- state_machine.init()
	-- end
	-- init_Plunder_icon_cell_terminal()
end

function ArenaHeadIconCell:onUpdateDraw()
end

function ArenaHeadIconCell:setChosen()
	self.image_light:setVisible(true)
end

function ArenaHeadIconCell:removeChosen()
	self.image_light:setVisible(false)
end

function ArenaHeadIconCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("campaign/Snatch/snath_icon.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	--高亮背景图
	local image_light = ccui.Helper:seekWidgetByName(root, "Image_light_5")
	self.image_light = image_light
	
	--icon容器层
	local panel_grid = ccui.Helper:seekWidgetByName(root, "Panel_13")
	
	--点击触发层
	local panel_touch = ccui.Helper:seekWidgetByName(root, "Panel_13_0")
	
	--父容器
	local panel_liaght = ccui.Helper:seekWidgetByName(root, "Panel_liaght")
	
	--重置大小
	self:setContentSize(panel_liaght:getContentSize())
	self:setSwallowTouches(true)

	--处理滑动时触发点击
	local function panel_touch_onTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if evenType == ccui.TouchEventType.began then
		elseif evenType == ccui.TouchEventType.moved then
		elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
			if math.abs(__epoint.x - __spoint.x) < 5 then
				-- fwin:addTouchEventListener(panel_liaght, nil, {
					-- terminal_name = "plunder_icon_cell_click", 
					-- terminal_state = 0, 
					-- _target = self
				-- }, nil, 0)
				
				local data = {
					source = self
				}
				state_machine.excute("player_review_infomation_update_page", 0, data)
				
				local _messageName = ObjectMessageNameEnum.player_review_infomation_icon_cell_set_chosen_state
				local _messageData = ObjectMessageData.getInitExample(_messageName)
				_messageData.source = self
				_messageData.target = self
				ObjectMessage.fireMessage(_messageName, _messageData)
			end
			
		end
	end
	panel_touch:addTouchEventListener(panel_touch_onTouchEvent)
	
	--插入显示icon
	local cell = ShipHeadCell:createCell()
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and self.userPic ~= nil then
		cell:init(nil,14,self.shipMID,1,nil,self.userPic)
	else
		cell:init(nil,12,self.shipMID,1)
	end
	panel_grid:addChild(cell)
	cell._data = self.data
	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_expedition_indiana_cell",
		-- _widget = cell,
		-- _invoke = nil,
		-- _interval = 0.5,})	
	--绘制更新
	self:onUpdateDraw()
	
	--默认不选中
	self:removeChosen()
	
	-- 监听消息
	ObjectMessage.addMessageListener(ObjectMessageNameEnum.player_review_infomation_icon_cell_set_chosen_state, 
		self, 
		function(instance, params)
			if params.target == instance then
				if type(instance.setChosen) == "function" then
					instance:setChosen()
				end
			else
				if type(instance.removeChosen) == "function" then
					instance:removeChosen()
				end
			end
		end
	)
end

function ArenaHeadIconCell:onExit()

	ObjectMessage.removeMessageListener(ObjectMessageNameEnum.player_review_infomation_icon_cell_set_chosen_state, self)
end

function ArenaHeadIconCell:init(shipMID,userPic)
	self.shipMID = shipMID
	self.userPic = userPic     --  主角时装图片ID
end

function ArenaHeadIconCell:createCell()
	local cell = ArenaHeadIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

