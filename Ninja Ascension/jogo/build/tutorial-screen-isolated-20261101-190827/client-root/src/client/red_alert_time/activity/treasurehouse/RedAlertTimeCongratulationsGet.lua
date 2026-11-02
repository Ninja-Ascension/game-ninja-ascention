--------------------------------------------------------------------------------------------------------------
--  说明：坦克拉霸抽取
--------------------------------------------------------------------------------------------------------------
RedAlertTimeCongratulationsGet = class("RedAlertTimeCongratulationsGetClass", Window)

--打开界面
local red_alert_time_congratulations_get_window_open_terminal = {
	_name = "red_alert_time_congratulations_get_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(RedAlertTimeCongratulationsGet:new():init(params), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local red_alert_time_congratulations_get_window_close_terminal = {
    _name = "red_alert_time_congratulations_get_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeCongratulationsGetClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_congratulations_get_window_open_terminal)
state_machine.add(red_alert_time_congratulations_get_window_close_terminal)
state_machine.init()

function RedAlertTimeCongratulationsGet:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	self.reworld = nil

    self._once_gold = 0
    self._activity_id = nil
    self._activity_type = nil

    -- local function init_red_alert_time_congratulations_get_terminal()
        -- local red_alert_time_congratulations_get_sure_recruit_terminal = {
            -- _name = "red_alert_time_congratulations_get_sure_recruit",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params) 
                -- local price = countActivityHeroDiscount()
                -- local tip = ConfirmTip:new()
                -- tip:init(instance, instance.sureRecruit, string.format(red_alert_time_str[215], self._once_gold, 1))
                -- fwin:open(tip, fwin._windows)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }

        -- state_machine.add(red_alert_time_congratulations_get_sure_recruit_terminal) 
        -- state_machine.init()
    -- end
    -- init_red_alert_time_congratulations_get_terminal()
end

-- function RedAlertTimeCongratulationsGet:sureRecruit(sure_number)
    -- local function responseCallback( response )
        -- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            -- if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                -- response.node:onUpdateDraw()
            -- end
        -- end
    -- end
    -- if sure_number == 0 then
        -- protocol_command.draw_activity_reward.param_list = self._activity_id .. "\r\n"..self._activity_type.."\r\n".."0".."\r\n".."0".."\r\n".."0"
        -- NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, self, responseCallback, false, nil)  
    -- end
-- end

function RedAlertTimeCongratulationsGet:onUpdateDraw(  )
    local root = self.roots[1]
    _ED.tank_draw_lottery = false
    showFightUpOrDown()
	state_machine.excute("main_window_update_fighting", 0, nil)
    local reward_type = 1000 + tonumber(self._activity_type)
	self.reworld = getSceneReward(reward_type)
	_ED.show_reward_list_group_ex = {}
	local m_ScrollView = ccui.Helper:seekWidgetByName(root,"ScrollView_act_congratulations_get")
	local Image_act_congratulations_get_box = ccui.Helper:seekWidgetByName(root,"Image_act_congratulations_get_box")
	local Button_act_congratulations_get_close = ccui.Helper:seekWidgetByName(root,"Button_act_congratulations_get_close")
	local Text_act_congratulations_get_name = ccui.Helper:seekWidgetByName(root,"Text_act_congratulations_get_name")
	local Button_act_congratulations_get_sure = ccui.Helper:seekWidgetByName(root,"Button_act_congratulations_get_sure")
	local panel = ccui.Layout:create()
	panel:setName("panelPoint")
    panel:setContentSize(m_ScrollView:getContentSize())
	panel:removeAllChildren(true)
	m_ScrollView:addChild(panel)
	local sSize = panel:getContentSize()
    local controlSize = m_ScrollView:getInnerContainerSize()
    local cellWidth = 0
	local maxHeight = 0
	if tonumber(self.reworld.show_reward_item_count) > 3 then
		cellWidth = sSize.width / 4
	else
		cellWidth = sSize.width/tonumber(self.reworld.show_reward_item_count)
	end

    local reward_list = {}
    for k, v in pairs(self.reworld.show_reward_list) do
        table.insert(reward_list, v)
    end
    if tonumber(self._activity_type) == 75 or tonumber(self._activity_type) == 58 then
        for k, v in pairs(reward_list) do
            v.camp_preference = dms.int(dms["ship_mould"], tonumber(v.prop_item), ship_mould.camp_preference)
            v.ship_type = dms.int(dms["ship_mould"], tonumber(v.prop_item), ship_mould.ship_type)
        end

        local function sortFunction(a, b)
            if a.ship_type > b.ship_type
                or (a.ship_type == b.ship_type and a.camp_preference < b.camp_preference)
                then
                return true
            else
                return false
            end
        end
        table.sort(reward_list, sortFunction)
    end
	
	local function addRewardScrollView(_index)
		local cell = nil
		local info = reward_list[_index]
		local prop_id = tonumber(info.prop_item)
		local prop_type = 1
		if tonumber(prop_id) == -1 then
			prop_id = resource_prop_id[tonumber(info.prop_type)]
			prop_type = 1
		end
		local show_type = 6
		local prop_from_type = 3
		if tonumber(info.prop_type) == 13 then --坦克
			prop_type = 3
			prop_from_type = 10
		elseif tonumber(info.prop_type) == 6 then --道具	
			prop_type = 1
			prop_from_type = 1
		elseif tonumber(info.prop_type) == 7 then --配件	
			prop_type = 7
			prop_from_type = 4
		else
			prop_type = 1
			prop_from_type = 1
		end
		if prop_type == 7 then
			local equip_datas = {}
			equip_datas.equipment_name = dms.string(dms["equipment_mould"], prop_id, equipment_mould.equipment_name)
			equip_datas.pic_index = dms.string(dms["equipment_mould"], prop_id, equipment_mould.pic_index)
			cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(info.item_value)})
		else
			cell = state_machine.excute("props_icon_create_cell", 0, {show_type, prop_from_type, prop_id, prop_type, tonumber(info.item_value)})
		end
		ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):setVisible(false)
		ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_attribute_icon"):setVisible(false)
		local cellHeight = cell:getContentSize().height + 26
		local row = 0
        local col = 0
        local controlHeight = 0
		local pos = nil
		if tonumber(self.reworld.show_reward_item_count) > 3 then
			row = math.floor((_index - 1) / 4 + 1)-1
			col = math.floor((_index - 1) % 4)
			controlHeight = row * cellHeight
			
			if controlHeight < sSize.height then
				controlSize.height = sSize.height
			else
				controlSize.height = controlHeight + cellHeight
			end
			
			m_ScrollView:setInnerContainerSize(cc.size(controlSize.width, controlSize.height))
			pos=cc.p(cellWidth * col + (cellWidth - cell:getContentSize().width)/2,
            sSize.height - cellHeight * row - cellHeight)
			maxHeight = controlHeight + cellHeight
		else
			col = math.floor((_index - 1) % tonumber(self.reworld.show_reward_item_count))
			pos=cc.p(cellWidth * col + (cellWidth - cell:getContentSize().width)/2,
            (sSize.height -cell:getContentSize().height+20)/2 )
			maxHeight = sSize.height
		end
		cell:setPosition(pos)
		cell:setTag(_index)
        panel:addChild(cell)
        -- panel:setPositionY(controlSize.height - sSize.height)
		return cell
	end
	
	for i=1,tonumber(self.reworld.show_reward_item_count) do
		addRewardScrollView(i)
		ccui.Helper:seekWidgetByName(root,"panelPoint"):getChildByTag(i):setVisible(false)
		ccui.Helper:seekWidgetByName(root,"panelPoint"):getChildByTag(i):setScale(0.1)
	end
	
	local upHeight = maxHeight - sSize.height
	if tonumber(self.reworld.show_reward_item_count) > 3 then
		upHeight = upHeight + 30
	end
	Image_act_congratulations_get_box:setContentSize(cc.size(Image_act_congratulations_get_box:getContentSize().width,Image_act_congratulations_get_box:getContentSize().height+upHeight))
	m_ScrollView:setContentSize(cc.size(m_ScrollView:getContentSize().width,m_ScrollView:getContentSize().height+upHeight))
	Button_act_congratulations_get_close:setPositionY(Button_act_congratulations_get_close:getPositionY()+upHeight)
	Text_act_congratulations_get_name:setPositionY(Text_act_congratulations_get_name:getPositionY()+upHeight)
	if tonumber(self.reworld.show_reward_item_count) > 3 then
		panel:setPositionY(panel:getPositionY()+upHeight+10)
	end
	Image_act_congratulations_get_box:setPositionY(Image_act_congratulations_get_box:getPositionY()-upHeight/2)
	m_ScrollView:setPositionY(m_ScrollView:getPositionY()-upHeight/2)
	Button_act_congratulations_get_close:setPositionY(Button_act_congratulations_get_close:getPositionY()-upHeight/2)
	Text_act_congratulations_get_name:setPositionY(Text_act_congratulations_get_name:getPositionY()-upHeight/2)
	Button_act_congratulations_get_sure:setPositionY(Button_act_congratulations_get_sure:getPositionY()-upHeight/2)
	
	self:animationCellPlay()
end

function RedAlertTimeCongratulationsGet:animationCellPlay()
	local root = self.roots[1]
	local panel = ccui.Helper:seekWidgetByName(root,"panelPoint")
	
	function actionCallBack1(sender)
        local armature = ccs.Armature:create("effice_recruit_get_light")
		draw.initArmature(armature, nil, -1, 0, 1)
		armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		sender:addChild(armature)
		armature:setPosition(cc.p(sender:getContentSize().width/2, sender:getContentSize().height/2))
		armature:getAnimation():playWithIndex(0)
    end
	
	function actionCallBack(sender)
        sender:setVisible(true)
    end
	
	for i=1, tonumber(self.reworld.show_reward_item_count) do
		panel:getChildByTag(i):runAction(cc.Sequence:create(
		cc.DelayTime:create(0.1+i*0.1),
		cc.CallFunc:create(actionCallBack),
        cc.ScaleTo:create(0.1, 1),
        cc.CallFunc:create(actionCallBack1)
        ))
	end
end

function RedAlertTimeCongratulationsGet:onInit(params)
    local csbItem = csb.createNode(config_csb.treasurehouse.act_congratulations_get)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
	local action = csb.createTimeline(config_csb.treasurehouse.act_congratulations_get)
    table.insert(self.actions, action)
    csbItem:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("window_open", false)
	
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_recruit_get_light)
	
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_act_congratulations_get_close"), nil, 
    {
        terminal_name = "red_alert_time_congratulations_get_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_act_congratulations_get_sure"), nil, 
    {
        terminal_name = "red_alert_time_congratulations_get_window_close", 
        terminal_state = 0, 
       	touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_congratulations_get_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    self:onUpdateDraw()
end

function RedAlertTimeCongratulationsGet:onEnterTransitionFinish()

end

function RedAlertTimeCongratulationsGet:init(params)
    self._activity_type = params
	self:onInit()
    return self
end

function RedAlertTimeCongratulationsGet:onExit()
    state_machine.remove("red_alert_time_congratulations_get_sure_recruit")
end