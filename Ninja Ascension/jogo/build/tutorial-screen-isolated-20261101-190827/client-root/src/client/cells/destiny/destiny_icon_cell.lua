----------------------------------------------------------------------------------------------------
-- 说明：天命的显示图标icon
-------------------------------------------------------------------------------------------------------
DestinyIconCell = class("DestinyIconCellClass", Window)

function DestinyIconCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}	
	self.actions = {}		
	self.current_type = 0
	self.mouldIndex = 0
	self._isEnd = false
	self.propertyList = nil
	self.enum_type = {
		_DESTINY_MENU_ICON = 1,	-- 菜单栏上的小图标
		_DESTINY_BODY_ICON = 2,	-- 显示在星云图上的小图标
	}
	self.data = {}
	
	self._iconUI = nil
	self._textUI = nil
	
	
	local function init_add_action_cell_terminal()
		
		-- 点击菜单栏上icon后,跳转天命主界面的显示视图
		local destiny_icon_cell_switch_page_terminal = {
            _name = "destiny_icon_cell_switch_page",
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
		
		-- 点击星云图上icon后,显示增加的属性提示
		local destiny_icon_cell_show_tip_terminal = {
            _name = "destiny_icon_cell_show_tip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- 取该节点的属性,填入值,播放
					-- 实际上的响应事件人,事件消息发起人和事件消息的处理人,之间毫无关系
					-- 只需要根据params中传入的对象,就做响应了.
					local target = params._datas._target
					target:showTip()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 提示的tip要消失时间到了
		local destiny_icon_cell_update_icon_show_tip_timer_end_terminal = {
            _name = "destiny_icon_cell_update_icon_show_tip_timer_end",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- 取该节点的属性,填入值,播放
					-- 实际上的响应事件人,事件消息发起人和事件消息的处理人,之间毫无关系
					-- 只需要根据params中传入的对象,就做响应了.
					local target = params.target
					target:hideTip()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		
		
		
		-------------------------------------------------------------
		--原本如此所想,但是当前状态机只有一个响应的,故留着不处理了.
		--当收到天命星的信息更新的通知后,子控件更新自己的状态
		-- local destiny_icon_cell_update_all_state_terminal = {
            -- _name = "destiny_icon_cell_update_all_state",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- instance:updateAllState()
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		
		
		-- local destiny_icon_cell_set_chosen_state_terminal = {
            -- _name = "destiny_icon_cell_set_chosen_state",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
					--> print("--------------------------------------------------------------")
					-- --local target = params._target
					-- --target:showTip()
					
					-- -- if params._target == instance then
						-- -- instance:setChosen()
					-- -- else
						-- -- instance:removeChosen()
					-- -- end
			
					-- params.target:setChosen()
			
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(destiny_icon_cell_switch_page_terminal)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		else	
			state_machine.add(destiny_icon_cell_show_tip_terminal)
		end
		state_machine.add(destiny_icon_cell_update_icon_show_tip_timer_end_terminal)
        state_machine.init()
	end
	init_add_action_cell_terminal()
end


---更新自己状态
function DestinyIconCell:updateAllState(instance, params)
	if instance == nil then
		instance = self
	end
	if instance.current_type == instance.enum_type._DESTINY_MENU_ICON then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			if tonumber(_ED.cur_destiny_id) + 1 < tonumber(instance.mouldIndex) then
				instance:setGray()
			else
				instance:removeGray()
			end
			if self:CheckIsOpen() == false then
				--新添加的锁住的图片,未开启的时候 还是要设置成灰色
				ccui.Helper:seekWidgetByName(self.roots[1],"Image_sou"):setVisible(true)
				instance:setGray()
			end
		else
			if tonumber(_ED.cur_destiny_id)  < tonumber(instance.mouldIndex) then
				instance:setGray()
			else
				instance:removeGray()
			end
		end
	end
	
	if instance.current_type == instance.enum_type._DESTINY_BODY_ICON then
		if tonumber(_ED.cur_destiny_id) + 1 == tonumber(instance.mouldIndex) then
			instance:setChosen()
		else
			instance:removeChosen()
		end
		
		if tonumber(_ED.cur_destiny_id)  < tonumber(instance.mouldIndex) then
			instance:setGray()
		else
			instance:removeGray()
		end
	end
end

-- 设置灰色
function DestinyIconCell:setGray()
	local imagePath = "images/ui/play/destiny/"..string.format("a%d.png", self._pic_index) 
	self._iconUI:setBackGroundImage(imagePath)
end

-- 取消灰色
function DestinyIconCell:removeGray()
	local imagePath = "images/ui/play/destiny/"..string.format("%d.png", self._pic_index) 
	self._iconUI:setBackGroundImage(imagePath)
end

-- 选中冒泡泡
function DestinyIconCell:setChosen()
	self.panel_light:setVisible(true)
end

-- 取消选中
function DestinyIconCell:removeChosen()
	self.panel_light:setVisible(false)
end


-- 显示tip动画
function DestinyIconCell:showTip()
	self.panel_sgz_qipao:setVisible(true)
	
	local action = self.actions[1]	
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	if self._isEnd == false then
		-- cell不支持onupdate,所以状态传递出去
		local data = {
				target = self,
				}
		state_machine.excute("destiny_system_update_icon_show_tip", 0, data)
	end
end

function DestinyIconCell:hideTip()
	self.panel_sgz_qipao:setVisible(false)
end


function DestinyIconCell:drawPropertyText()
	local text_sgz_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_sgz_01")
	local text_sgz_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_sgz_02")
	
	text_sgz_1:setString(self.propertyValue)
	text_sgz_2:setString(self.propertyName)

end

-- 算出当前cell的显示属性
function DestinyIconCell:calculatePropertyAdditional()

	-- 显示属性加成
	local property_additional = dms.string(dms["destiny_mould"], self.mouldIndex, destiny_mould.property_additional)
	if tonumber(property_additional) == -1 then
		-- 已经取到属性变更信息
		-- 进入pirates_config - 176行索引
		self:calculateSpecialPropertyAdditional()
	else
		local propertyList = zstring.zsplit(property_additional, "|")
		self.propertyList = propertyList	
		for i=1 ,#propertyList do
			propertyList[i] = zstring.zsplit(propertyList[i], ",")
		end
		
		self.propertyName = string_equiprety_name[tonumber(propertyList[#propertyList][1])+1]
		self.propertyValue = tostring(propertyList[#propertyList][2])..string_equiprety_name_vlua_type[tonumber(propertyList[#propertyList][1])+1]
	end
	
	self:drawPropertyText()
end

-- 算出当前为-1时的获取
function DestinyIconCell:calculateSpecialPropertyAdditional()
	-- 优先算是否改运
	local is_change_destiny = dms.string(dms["destiny_mould"], self.mouldIndex, destiny_mould.is_change_destiny)
	if tonumber(is_change_destiny) == 1 then
		-- 1就是改
		-- 改运,则取pirates_config配置表中,283	天命ID,描述|天命ID2,描述2|…	283	10,主角升紫|25,主角升橙|40,主角升红|60,主角升金
		-- local data = zstring.split(dms.string(dms["pirates_config"], 285, pirates_config.param), "|")
		-- for i = 1 , table.getn(data) do
			-- local item = zstring.split(data[i], ",")
			-- if tonumber(item[1]) == tonumber(self.mouldIndex) then
				-- self.propertyName = tostring(item[2])
				-- self.propertyValue = tostring(item[3])
				-- break
			-- end
		-- end
		
		local name = dms.string(dms["destiny_mould"], mouldIndex, destiny_mould.descript)
		property.propertyName = tostring(name)
		property.propertyValue = tostring("")
		
	else
		-- 0就是不改
		-- 不是改运,则取当前字段中获得道具
		local get_of_prop = dms.string(dms["destiny_mould"], self.mouldIndex, destiny_mould.get_of_prop)
		local get_of_prop_count = dms.string(dms["destiny_mould"], self.mouldIndex, destiny_mould.get_of_prop_count)
		-- 道具模板 
		local prop_name = dms.string(dms["prop_mould"], get_of_prop, prop_mould.prop_name)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            prop_name = setThePropsIcon(get_of_prop)[2]
        end
		self.propertyName = tostring(prop_name)
		self.propertyValue = tostring(get_of_prop_count)
	end
end

function DestinyIconCell:setEnd(bl)
	self._isEnd = bl
	self:drawEndTip()
end

function DestinyIconCell:drawEndTip()
	if self._isEnd == true then
		self:showTip()
	end
end

function DestinyIconCell:onUpdateDraw()
	local root = self.roots[1]
	-- self.size = root:getContentSize()
	-- self:setContentSize(self.size)
	root:setSwallowTouches(false)
	
	local _index = dms.int(dms["destiny_mould"], self.mouldIndex, destiny_mould.pic_index)
	self._pic_index = _index
	local _name = dms.string(dms["destiny_mould"], self.mouldIndex, destiny_mould.destiny_name)
	
	local imagePath = "images/ui/play/destiny/"..string.format("%d.png", _index) 
	local _icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sgz_icon")
	self._iconUI = _icon
	_icon:setBackGroundImage(imagePath)
	
	
	if self.current_type == self.enum_type._DESTINY_MENU_ICON then
		local _text = ccui.Helper:seekWidgetByName(self.roots[1], "Text_sgz_icon_1")
		self._textUI = _text
		_text:setString(_name)
	end
	self:calculatePropertyAdditional()
	self:drawEndTip()
end
--检测当前id是否开放
function DestinyIconCell:CheckIsOpen()
	local previous_id = dms.int(dms["destiny_mould"], self.mouldIndex, destiny_mould.previous_id)
	local next_id = dms.int(dms["destiny_mould"], self.mouldIndex, destiny_mould.next_id)
	if previous_id == -1 and next_id == -1 then
		return false
	end
	return true
end
function DestinyIconCell:onEnterTransitionFinish()	
	--app.load("frameworks.support.filters.gray")
	-- local csbItem = csb.createNode("destiny/destiny_icon.csb")
	-- self.csbItem = csbItem
	-- local root = csbItem:getChildByName("root")
	-- table.insert(self.roots, root)
	-- --self:addChild(csbItem)
	-- root:removeFromParent(false)
	-- self:addChild(root)
	-- local csbDestinySystem = csb.createNode("destiny/destiny_icon.csb")
    -- --self:addChild(csbDestinySystem)
	-- local root = csbDestinySystem:getChildByName("root")
	-- table.insert(self.roots, root)
	-- self:addChild(root)
	
	local csbFormation = csb.createNode("destiny/destiny_icon.csb")
	self:addChild(csbFormation)
	local root = csbFormation:getChildByName("root")
	table.insert(self.roots, root)
	
	
	local action = csb.createTimeline("destiny/destiny_icon.csb")
	self.actions[1] = action
	--action:gotoFrameAndPlay(0, action:getDuration(), false)
	root:runAction(action)

	
	local panel_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_2")
	self.panel_sgz_qipao = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sgz_qipao")

	self.panel_light = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_light")

	self.size = panel_2:getContentSize()
	self:setContentSize(self.size)
	
	panel_2:setSwallowTouches(false)
	
	self:onUpdateDraw()
	
	local panel_sgz_qipao = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sgz_qipao")
	
	if self.current_type == self.enum_type._DESTINY_MENU_ICON then
		self.panel_sgz_qipao:setVisible(false)
		-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_sgz_icon"), nil, 
		-- {
			-- terminal_name = "destiny_icon_cell_set_chosen_state", 
			-- terminal_state = 0, 
			-- _data = {
					-- target = self,
					-- mouldIndex = self.mouldIndex,
				-- }
		-- }, nil, 0)
		
		ObjectMessage.addMessageListener(ObjectMessageNameEnum.destiny_icon_cell_update_all_state, self, "updateAllState")
		ObjectMessage.addMessageListener(ObjectMessageNameEnum.destiny_icon_cell_set_chosen_state, self, function(instance, params)
			if params.target == instance then
				if type(instance.setChosen) == "function" then
					instance:setChosen()
				end
			else
				if type(instance.removeChosen) == "function" then
					instance:removeChosen()
				end
			end
		end)

		local Panel_sgz_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sgz_icon")
		Panel_sgz_icon:setSwallowTouches(false)
		local function Panel_sgz_icon_onTouchEvent(sender, evenType)
			local __spoint = sender:getTouchBeganPosition()
			local __mpoint = sender:getTouchMovePosition()
			local __epoint = sender:getTouchEndPosition()
			if evenType == ccui.TouchEventType.began then
			elseif evenType == ccui.TouchEventType.moved then
			elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					if self:CheckIsOpen() == false then
						TipDlg.drawTextDailog(_string_piece_info[199])
						return
					end
				end
				if math.abs(__epoint.x - __spoint.x) < 5 then
				
					local _messageName = ObjectMessageNameEnum.destiny_icon_cell_set_chosen_state
					local _messageData = ObjectMessageData.getInitExample(_messageName)
					_messageData.source = self
					_messageData.target = self
					ObjectMessage.fireMessage(_messageName, _messageData)

					-- local chosenData = {
									-- target = self,
									-- mouldIndex = self.mouldIndex,
								-- }
					-- state_machine.excute("destiny_icon_cell_set_chosen_state", 0, chosenData)
					
					local data = {
							_datas = {
								_data = {
									_index = self.int_pageIndex,
									}
								}
							}
					state_machine.excute("destiny_system_update_page_index", 0, data)
				end
			end
		end
		Panel_sgz_icon:addTouchEventListener(Panel_sgz_icon_onTouchEvent)

	elseif self.current_type == self.enum_type._DESTINY_BODY_ICON then
		
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_sgz_icon"), nil, 
		{
			terminal_name = "destiny_icon_cell_show_tip", 
			terminal_state = 0, 
			_target = self
		}, nil, 0)
		self:updateAllState()
		ObjectMessage.addMessageListener(ObjectMessageNameEnum.destiny_icon_cell_update_all_state, self, "updateAllState")
	else
		--> debug.log(true, "error")
	end

end

function DestinyIconCell:setPageIndex(int_pageIndex)

	self.int_pageIndex = int_pageIndex
end


function DestinyIconCell:getPageIndex()

	return self.int_pageIndex
end


function DestinyIconCell:onExit()
	state_machine.remove("destiny_icon_cell_switch_page")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else	
		state_machine.remove("destiny_icon_cell_show_tip")
	end	
	state_machine.remove("destiny_icon_cell_set_chosen_state")
	state_machine.remove("destiny_icon_cell_update_icon_show_tip_timer_end")
	
	ObjectMessage.removeMessageListener(ObjectMessageNameEnum.destiny_icon_cell_update_all_state,self)
	ObjectMessage.removeMessageListener(ObjectMessageNameEnum.destiny_icon_cell_set_chosen_state,self)
end

function DestinyIconCell:init(number_interfaceType, number_mouldIndex)
	self.current_type = number_interfaceType
	self.mouldIndex = number_mouldIndex
end


function DestinyIconCell:createCell()
	local cell = DestinyIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

