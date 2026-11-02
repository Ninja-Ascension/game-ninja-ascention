-- ----------------------------------------------------------------------------------------------------

SmActivityVIPDiscount = class("SmActivityVIPDiscountClass", Window)
    
function SmActivityVIPDiscount:ctor()
    self.super:ctor()
	self.roots = {}

	self.loaded = false
	self._tick_time = 0
	self._endtime = nil
    self._chooseIndex = 0

    app.load("client.l_digital.cells.activity.wonderful.sm_activity_vip_discount_cell")
    local function init_SmActivityVIPDiscount_terminal()
		local sm_activity_vip_discount_update_terminal = {
            _name = "sm_activity_vip_discount_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
	            	instance:onUpdateDraw()
	            end
			    return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_activity_vip_discount_choose_index_terminal = {
            _name = "sm_activity_vip_discount_choose_index",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._chooseIndex = params
                instance:updateVIPChooseState()
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_activity_vip_discount_buy_terminal = {
            _name = "sm_activity_vip_discount_buy",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local activity = _ED.active_activity[111]
                if activity == nil then
                    return
                end
                local activityDatas = activity.activity_Info[instance._chooseIndex]
                local infos = zstring.split(activityDatas.activityInfo_need_day, ",")
                if tonumber(_ED.vip_grade) < tonumber(infos[1]) then
                    TipDlg.drawTextDailog(string.format(_new_interface_text[226], infos[1]))
                    return
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)
                        state_machine.excute("sm_activity_vip_discount_update", 0, nil)
                    end
                end
                protocol_command.get_activity_reward.param_list = activity.activity_id.."\r\n"..(instance._chooseIndex- 1).."\r\n0"
                NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
			    return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_activity_vip_discount_update_terminal)
		state_machine.add(sm_activity_vip_discount_buy_terminal)
        state_machine.add(sm_activity_vip_discount_choose_index_terminal)
        state_machine.init()
    end
    init_SmActivityVIPDiscount_terminal()
end

function SmActivityVIPDiscount:onUpdateDraw()
	if self.loaded == false then
		return
	end
	local root = self.roots[1]
	local activity = _ED.active_activity[111]
	local endtime = ccui.Helper:seekWidgetByName(root, "Text_32")
	self._endtime = endtime
	self._tick_time = zstring.tonumber(activity.end_time)/1000 - (os.time() + _ED.time_add_or_sub)
	endtime:setString(getRedAlertTimeActivityFormat(self._tick_time))
	local currentTimess = zstring.split(activity.activity_params, ",")

    local Text_prop_sell_1 = ccui.Helper:seekWidgetByName(root, "Text_prop_sell_1")
    local Text_prop_sell_1_1 = ccui.Helper:seekWidgetByName(root, "Text_prop_sell_1_1")
    local Text_vip = ccui.Helper:seekWidgetByName(root, "Text_vip")
    local Text_vip_1 = ccui.Helper:seekWidgetByName(root, "Text_vip_1")
    local Text_V = ccui.Helper:seekWidgetByName(root, "Text_V")
    local Button_21 = ccui.Helper:seekWidgetByName(root, "Button_21")
    local propPanels = {ccui.Helper:seekWidgetByName(root, "Panel_icon_2"),
        ccui.Helper:seekWidgetByName(root, "Panel_icon_1"),
        ccui.Helper:seekWidgetByName(root, "Panel_icon_3")}
    for k,v in pairs(propPanels) do
        v:removeAllChildren(true)
    end

    local activityDatas = activity.activity_Info[self._chooseIndex]
    if tonumber(activityDatas.activityInfo_isReward) == 0 then
        Button_21:setTouchEnabled(true)
        Button_21:setBright(true)
        Button_21:setTitleText(_activity_new_tip_string_info[9])
    else
        if tonumber(activityDatas.activityInfo_isReward) == 1 then
            Button_21:setTitleText(_activity_new_tip_string_info[3])
        end
        Button_21:setTouchEnabled(false)
        Button_21:setBright(false)
    end
    local infos = zstring.split(activityDatas.activityInfo_need_day, ",")
    Text_vip:setString("VIP "..infos[1])
    Text_prop_sell_1:setString(infos[3])
    Text_prop_sell_1_1:setString(infos[2])
    Text_vip_1:setString("".._ED.vip_grade)
    Text_V:setString(string.format(_new_interface_text[242], tonumber(infos[1])))

    if tonumber(infos[1]) <= tonumber(_ED.vip_grade) then
        Text_vip:setColor(cc.c3b(tipStringInfo_quality_color_Type[1][1],tipStringInfo_quality_color_Type[1][2],tipStringInfo_quality_color_Type[1][3]))
    else
        Text_vip:setColor(cc.c3b(tipStringInfo_quality_color_Type[6][1],tipStringInfo_quality_color_Type[6][2],tipStringInfo_quality_color_Type[6][3]))
    end

    local index = 0
    if tonumber(activityDatas.activityInfo_silver) ~= 0 then
        index = index + 1
        local cell = ResourcesIconCell:createCell()
        cell:init(1, tonumber(activityDatas.activityInfo_silver), -1,nil,nil,true,true)
        if index <= #propPanels then
            propPanels[index]:addChild(cell)
        end
        if index == 1 then
            propPanels[1]:setVisible(true)
            propPanels[2]:setVisible(false)
            propPanels[3]:setVisible(false)
        elseif index == 2 then
            propPanels[1]:setVisible(false)
            propPanels[2]:setVisible(true)
            propPanels[3]:setVisible(false)
        elseif index == 3 then
            propPanels[1]:setVisible(false)
            propPanels[2]:setVisible(false)
            propPanels[3]:setVisible(true)
        end
    end
    if tonumber(activityDatas.activityInfo_gold) ~= 0 then
        index = index + 1
        local cell = ResourcesIconCell:createCell()
        cell:init(2, tonumber(activityDatas.activityInfo_gold), -1,nil,nil,true,true)
        if index <= #propPanels then
            propPanels[index]:addChild(cell)
        end
        if index == 1 then
            propPanels[1]:setVisible(true)
            propPanels[2]:setVisible(false)
            propPanels[3]:setVisible(false)
        elseif index == 2 then
            propPanels[1]:setVisible(false)
            propPanels[2]:setVisible(true)
            propPanels[3]:setVisible(false)
        elseif index == 3 then
            propPanels[1]:setVisible(false)
            propPanels[2]:setVisible(false)
            propPanels[3]:setVisible(true)
        end
    end
    if tonumber(activityDatas.activityInfo_food) ~= 0 then
        index = index + 1
        local cell = ResourcesIconCell:createCell()
        cell:init(12, tonumber(activityDatas.activityInfo_food), -1,nil,nil,true,true)
        if index <= #propPanels then
            propPanels[index]:addChild(cell)
        end
        if index == 1 then
            propPanels[1]:setVisible(true)
            propPanels[2]:setVisible(false)
            propPanels[3]:setVisible(false)
        elseif index == 2 then
            propPanels[1]:setVisible(false)
            propPanels[2]:setVisible(true)
            propPanels[3]:setVisible(false)
        elseif index == 3 then
            propPanels[1]:setVisible(false)
            propPanels[2]:setVisible(false)
            propPanels[3]:setVisible(true)
        end
    end
    if tonumber(activityDatas.activityInfo_equip_count) ~= 0 then
        index = index + 1
        local equip_data = activityDatas.activityInfo_equip_info[1]
        local cell = ResourcesIconCell:createCell()
        cell:init(7, tonumber(equip_data.equipMouldCount), equip_data.equipMould,nil,nil,true,true)
        if index <= #propPanels then
            propPanels[index]:addChild(cell)
        end
        if index == 1 then
            propPanels[1]:setVisible(true)
            propPanels[2]:setVisible(false)
            propPanels[3]:setVisible(false)
        elseif index == 2 then
            propPanels[1]:setVisible(false)
            propPanels[2]:setVisible(true)
            propPanels[3]:setVisible(false)
        elseif index == 3 then
            propPanels[1]:setVisible(false)
            propPanels[2]:setVisible(false)
            propPanels[3]:setVisible(true)
        end
    end
    if tonumber(activityDatas.activityInfo_prop_count) ~= 0 then
        index = index + 1
        local prop_data = activityDatas.activityInfo_prop_info[1]
        local cell = ResourcesIconCell:createCell()
        cell:init(6, tonumber(prop_data.propMouldCount), prop_data.propMould, nil,nil,true,true)
        if index <= #propPanels then
            propPanels[index]:addChild(cell)
        end
        if dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.use_of_ship) > 0 
            and dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.storage_page_index) == 18 
            then
            local jsonFile = "sprite/sprite_wzkp.json"
            local atlasFile = "sprite/sprite_wzkp.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            animation:setPosition(cc.p(cell:getContentSize().width/2,cell:getContentSize().height/2))
            cell:addChild(animation)
        end
        if index == 1 then
            propPanels[1]:setVisible(true)
            propPanels[2]:setVisible(false)
            propPanels[3]:setVisible(false)
        elseif index == 2 then
            propPanels[1]:setVisible(false)
            propPanels[2]:setVisible(true)
            propPanels[3]:setVisible(false)
        elseif index == 3 then
            propPanels[1]:setVisible(false)
            propPanels[2]:setVisible(false)
            propPanels[3]:setVisible(true)
        end
    end

    local otherRewards = zstring.splits(activityDatas.activityInfo_reward_select, "|", ",")
    if #otherRewards > 0 then
        for i, v in pairs(otherRewards) do
            if #v >= 3 then
                index = index + 1
                local cell = ResourcesIconCell:createCell()
                local rewardType = tonumber(v[1])
                if 13 == rewardType then
                    local table = {}
                    if v[4] ~= nil and tonumber(v[4]) ~= -1 then
                        table.shipStar = tonumber(v[4])
                    end
                    cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1,table)
                    -- local evo_image = dms.string(dms["ship_mould"], v[2], ship_mould.fitSkillTwo)
                    -- local evo_info = zstring.split(evo_image, ",")
                    -- local evo_mould_id = evo_info[dms.int(dms["ship_mould"], v[2], ship_mould.captain_name)]
                    -- local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
                    -- local word_info = dms.element(dms["word_mould"], name_mould_id)
                    -- local name = word_info[3]
                    -- Text_prop_name:setString(name)
                else
                    cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1)
                    local types = tonumber(v[1])
                    if types == 1 then
                        name = _All_tip_string_info._fundName
                    elseif types == 2 then
                        name = _All_tip_string_info._crystalName
                    elseif types == 5 then
                        name = _All_tip_string_info._soulName
                    elseif types == 8 then
                        name = reward_prop_list[8]
                    elseif types == 18 then
                        name = _All_tip_string_info._glories
                    elseif types == 3 then
                        name = _All_tip_string_info._reputation
                    elseif types == 31 then
                        name = red_alert_resouce_tip[1][1]
                    elseif types == 33 then 
                        name = _my_gane_name[14]
                    elseif types == 34 then 
                        name = _my_gane_name[15]
                    elseif types == 4 then
                        name = _All_tip_string_info._hero
                    end
                end
                if index <= #propPanels then
                    propPanels[index]:addChild(cell)
                end
                if index == 1 then
                    propPanels[1]:setVisible(true)
                    propPanels[2]:setVisible(false)
                    propPanels[3]:setVisible(false)
                elseif index == 2 then
                    propPanels[1]:setVisible(false)
                    propPanels[2]:setVisible(true)
                    propPanels[3]:setVisible(false)
                elseif index == 3 then
                    propPanels[1]:setVisible(false)
                    propPanels[2]:setVisible(false)
                    propPanels[3]:setVisible(true)
                end
            end
        end
	end
end

function SmActivityVIPDiscount:updateVIPChooseState( ... )
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    for k,v in pairs(ListView_1:getItems()) do
        if k == self._chooseIndex then
            v:updateChooseState(true)
        else
            v:updateChooseState(false)
        end
    end
end

function SmActivityVIPDiscount:updateVIPInfo( ... )
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    ListView_1:removeAllItems()
    local activity = _ED.active_activity[111]
    for k,v in pairs(activity.activity_Info) do
        local cell = state_machine.excute("sm_activity_vip_discount_cell_create", 0, {k, v})
        ListView_1:addChild(cell)
        if k == 1 then
            cell:updateChooseState(true)
        end
    end
end

function SmActivityVIPDiscount:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	self:onInit()
	self:registerOnNoteUpdate(self, 1)
end

function SmActivityVIPDiscount:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	self._tick_time = 0
	self._endtime = nil
	self:unregisterOnNoteUpdate(self)
end

function SmActivityVIPDiscount:onEnterTransitionFinish()
end

function SmActivityVIPDiscount:onLoad()

end

function SmActivityVIPDiscount:onUpdate( dt )
    if self._endtime == nil then
        return
    end
    self._tick_time = self._tick_time - dt
    if self._tick_time <= 0 then
    	self._tick_time = 0
    end
	self._endtime:setString(getRedAlertTimeActivityFormat(self._tick_time))
end

function SmActivityVIPDiscount:onInit()
    local csbActivityDoubleDiscount = csb.createNode("activity/wonderful/vip_package.csb")
    local root = csbActivityDoubleDiscount:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbActivityDoubleDiscount)
		
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_72860"), nil, 
	{
		-- terminal_name = "sm_activity_vip_discount_buy", 
		terminal_state = 0,
		isPressedActionEnabled = true
	},
	nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_72861"), nil, 
    {
        -- terminal_name = "sm_activity_vip_discount_buy", 
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_21"), nil, 
    {
        terminal_name = "sm_activity_vip_discount_buy", 
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil,0)

    self._chooseIndex = 1
    self:updateVIPInfo()
	self:onUpdateDraw()
end

function SmActivityVIPDiscount:init()
	
end

function SmActivityVIPDiscount:createCell()
	local cell = SmActivityVIPDiscount:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function SmActivityVIPDiscount:onExit()
	state_machine.remove("sm_activity_vip_discount_update")
	state_machine.remove("sm_activity_vip_discount_buy")
    state_machine.remove("sm_activity_vip_discount_choose_index")
end