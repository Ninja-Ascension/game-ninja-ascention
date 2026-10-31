----------------------------------------------------------------------------------------------------
-- 说明：天命的显示图标icon
-------------------------------------------------------------------------------------------------------
DestinyBodyIconCell = class("DestinyBodyIconCellClass", Window)

function DestinyBodyIconCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}	
	self.actions = {}		
	self.current_type = 0
	self.mouldIndex = 0
	self._isEnd = false
	self.propertyList = nil

	self.data = {}
	
	self._iconUI = nil
	self._textUI = nil
	
	self.iconImg = {
		hide = "images/ui/play/destiny/lvdian.png",
		show = "images/ui/play/destiny/hongdian.png" 
	}
	
	local function init_add_action_cell_terminal()
		
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
					local target = params._target
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
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(destiny_icon_cell_show_tip_terminal)
		state_machine.add(destiny_icon_cell_update_icon_show_tip_timer_end_terminal)
        state_machine.init()
	end
	init_add_action_cell_terminal()
end


---更新自己状态
function DestinyBodyIconCell:updateAllState(instance, params)
	if instance == nil then
		instance = self
	end
	
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

-- 设置灰色
function DestinyBodyIconCell:setGray()
	local imagePath = self.iconImg.hide
	self._iconUI:setBackGroundImage(imagePath)
end

-- 取消灰色
function DestinyBodyIconCell:removeGray()
	local imagePath = self.iconImg.show
	self._iconUI:setBackGroundImage(imagePath)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local Panel_light_1  = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_light_1")
		Panel_light_1:removeAllChildren(true)
		Panel_light_1:setVisible(true)
		local armature = ccs.Armature:create("effect_ui_destiny_icon")
        draw.initArmature(armature, nil, -1, 0, 1)
        Panel_light_1:addChild(armature)
	end
end

-- 选中冒泡泡
function DestinyBodyIconCell:setChosen()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self:removeChosen()
		local armature = ccs.Armature:create("effect_47")
        draw.initArmature(armature, nil, -1, 0, 1)
		self.panel_light:addChild(armature)
	end
	self.panel_light:setVisible(true)
end

-- 取消选中
function DestinyBodyIconCell:removeChosen()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self.panel_light:removeAllChildren(true)
	end
	self.panel_light:setVisible(false)
end


-- 显示tip动画
function DestinyBodyIconCell:showTip()
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

function DestinyBodyIconCell:hideTip()
	self.panel_sgz_qipao:setVisible(false)
end


function DestinyBodyIconCell:drawPropertyText()
	local text_sgz_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_sgz_01")
	local text_sgz_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_sgz_02")
	
	text_sgz_1:setString(self.propertyValue)
	text_sgz_2:setString(self.propertyName)

end
-- 算出当前cell的显示属性
function DestinyBodyIconCell:calculatePropertyAdditional()

	-- 显示属性加成
	local property_additional = dms.string(dms["destiny_mould"], self.mouldIndex, destiny_mould.property_additional)
	local descript = dms.string(dms["destiny_mould"], self.mouldIndex, destiny_mould.descript)
	descript = zstring.zsplit(descript, ",")
	local descriptStr = ""
	for i,v in pairs(descript) do
		descriptStr = descriptStr..v
	end
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
		
		self.propertyName = descriptStr--string_equiprety_name[tonumber(propertyList[#propertyList][1])+1]
		self.propertyValue = ""--tostring(propertyList[#propertyList][2])..string_equiprety_name_vlua_type[tonumber(propertyList[#propertyList][1])+1]
	end
	
	self:drawPropertyText()
end

-- 算出当前为-1时的获取
function DestinyBodyIconCell:calculateSpecialPropertyAdditional()
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
		
		local name = dms.string(dms["destiny_mould"], self.mouldIndex, destiny_mould.descript)
		self.propertyName = tostring(name)
		self.propertyValue = tostring("")
		
	else
		-- 0就是不改
		-- 不是改运,则取当前字段中获得道具
		local get_of_prop = dms.string(dms["destiny_mould"], self.mouldIndex, destiny_mould.get_of_prop)
		local get_of_prop_count = dms.string(dms["destiny_mould"], self.mouldIndex, destiny_mould.get_of_prop_count)
		local descript = dms.string(dms["destiny_mould"], self.mouldIndex, destiny_mould.descript)
		-- 道具模板 
		--local prop_name = dms.string(dms["prop_mould"], get_of_prop, prop_mould.prop_name)
		
		self.propertyName = descript--tostring(prop_name)
		self.propertyValue = ""--tostring(get_of_prop_count)
	end
	

end

function DestinyBodyIconCell:setEnd(bl)
	self._isEnd = bl
	self:drawEndTip()
end

function DestinyBodyIconCell:drawEndTip()
	if self._isEnd == true then
		self:showTip()
	end
end

function DestinyBodyIconCell:onUpdateDraw()
	local root = self.roots[1]
	-- self.size = root:getContentSize()
	-- self:setContentSize(self.size)
	root:setSwallowTouches(false)
	
	local _index = dms.int(dms["destiny_mould"], self.mouldIndex, destiny_mould.pic_index)
	self._pic_index = _index
	local _name = dms.string(dms["destiny_mould"], self.mouldIndex, destiny_mould.destiny_name)
	
	local imagePath = self.iconImg.hide
	local _icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sgz_icon")
	self._iconUI = _icon
	_icon:setBackGroundImage(imagePath)
	
	self:calculatePropertyAdditional()
	self:drawEndTip()
end


function DestinyBodyIconCell:onEnterTransitionFinish()	
	
	local csbFormation = csb.createNode("destiny/destiny_icon.csb")
	self:addChild(csbFormation)
	local root = csbFormation:getChildByName("root")
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("destiny/destiny_icon.csb")
	self.actions[1] = action
	root:runAction(action)

	local panel_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_2")
	self.panel_sgz_qipao = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sgz_qipao")

	self.panel_light = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_light_0")
	
	local Panel_sgz_icon = ccui.Helper:seekWidgetByName(root, "Panel_sgz_icon")
	
	self.size = panel_2:getContentSize()
	self:setContentSize(self.size)
	
	panel_2:setSwallowTouches(false)
	Panel_sgz_icon:setSwallowTouches(false)
	
	self:hideTip()
	
	self:onUpdateDraw()
	
	
	self:updateAllState()
	ObjectMessage.addMessageListener(ObjectMessageNameEnum.destiny_icon_cell_update_all_state, self, "updateAllState")
	
	-- 监听消息
	ObjectMessage.addMessageListener(ObjectMessageNameEnum.destiny_body_icon_cell_set_chosen_state, 
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
	
	local function panel_touch_onTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if evenType == ccui.TouchEventType.began then
		elseif evenType == ccui.TouchEventType.moved then
		elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				--不切换光圈，只显示tip提示
			else
				local _messageName = ObjectMessageNameEnum.destiny_body_icon_cell_set_chosen_state
				local _messageData = ObjectMessageData.getInitExample(_messageName)
				_messageData.source = self
				_messageData.target = self
				ObjectMessage.fireMessage(_messageName, _messageData)
			end
			state_machine.excute("destiny_icon_cell_show_tip", 0, {_target = self})
		end
	end
	Panel_sgz_icon:addTouchEventListener(panel_touch_onTouchEvent)
end

function DestinyBodyIconCell:setPageIndex(int_pageIndex)

	self.int_pageIndex = int_pageIndex
end


function DestinyBodyIconCell:getPageIndex()

	return self.int_pageIndex
end


function DestinyBodyIconCell:onExit()
	state_machine.remove("destiny_icon_cell_switch_page")
	state_machine.remove("destiny_icon_cell_show_tip")
	state_machine.remove("destiny_icon_cell_set_chosen_state")
	state_machine.remove("destiny_icon_cell_update_icon_show_tip_timer_end")
	
	ObjectMessage.removeMessageListener(ObjectMessageNameEnum.destiny_icon_cell_update_all_state,self)
	ObjectMessage.removeMessageListener(ObjectMessageNameEnum.destiny_icon_cell_set_chosen_state,self)
end

function DestinyBodyIconCell:init(number_mouldIndex)
	self.mouldIndex = number_mouldIndex
end


function DestinyBodyIconCell:createCell()
	local cell = DestinyBodyIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

