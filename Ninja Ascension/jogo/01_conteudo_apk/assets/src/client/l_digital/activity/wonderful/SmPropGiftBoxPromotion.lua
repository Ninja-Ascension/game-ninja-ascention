-- ----------------------------------------------------------------------------------------------------

SmPropGiftBoxPromotion = class("SmPropGiftBoxPromotionClass", Window)
    
function SmPropGiftBoxPromotion:ctor()
    self.super:ctor()
	self.roots = {}

	self._acitvity_type = 0
	self.loaded = false
	self._tick_time = 0
	self._endtime = nil

    local function init_SmPropGiftBoxPromotion_terminal()
		local sm_activity_prop_gift_box_promotion_update_terminal = {
            _name = "sm_activity_prop_gift_box_promotion_update",
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

        local sm_activity_prop_gift_box_promotion_buy_terminal = {
            _name = "sm_activity_prop_gift_box_promotion_buy",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _index = params._datas.index
                local activity = _ED.active_activity[127]
                if activity == nil then
                    return
                end
                app.load("client.l_digital.activity.wonderful.SmActivityPropDiscountBuyConfirm")
                local temp = {index = _index, activity_id = 127}
                state_machine.excute("sm_activity_auto_upgrade_window_open", 0, temp)
                -- local function responseCallback(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         app.load("client.reward.DrawRareReward")
                --         local getRewardWnd = DrawRareReward:new()
                --         getRewardWnd:init(7)
                --         fwin:open(getRewardWnd, fwin._ui)
                --         state_machine.excute("sm_activity_prop_gift_box_promotion_update", 0, nil)
                --     end
                -- end
                -- protocol_command.get_activity_reward.param_list = activity.activity_id.."\r\n"..(index- 1).."\r\n0"
                -- NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
			    return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_activity_prop_gift_box_promotion_update_terminal)
		state_machine.add(sm_activity_prop_gift_box_promotion_buy_terminal)
        state_machine.init()
    end
    init_SmPropGiftBoxPromotion_terminal()
end

function SmPropGiftBoxPromotion:onUpdateDraw()
	if self.loaded == false then
		return
	end
	local root = self.roots[1]
	local activity = _ED.active_activity[127]
	local endtime = ccui.Helper:seekWidgetByName(root, "Text_32")

    local Image_recruit_card_1 = ccui.Helper:seekWidgetByName(root, "Image_recruit_card_1")
    local Image_recruit_card_2 = ccui.Helper:seekWidgetByName(root, "Image_recruit_card_2")
    local Image_recruit_card_2_0 = ccui.Helper:seekWidgetByName(root, "Image_recruit_card_2_0")
    Image_recruit_card_1:loadTexture("images/ui/text/sm_hd/yy_bg_05.png")
    Image_recruit_card_2:loadTexture("images/ui/text/sm_hd/yy_bg_05.png")
    Image_recruit_card_2_0:loadTexture("images/ui/text/sm_hd/yy_bg_05.png")

	self._endtime = endtime
	self._tick_time = zstring.tonumber(activity.end_time)/1000 - (os.time() + _ED.time_add_or_sub)
	endtime:setString(getRedAlertTimeActivityFormat(self._tick_time).._new_interface_text[245])
	local currentTimess = zstring.split(activity.activity_params, ",")
	for i=1,3 do
		local activityDatas = activity.activity_Info[i]
		local Panel_props = ccui.Helper:seekWidgetByName(root, "Panel_props_"..i)
		local Text_prop_name = ccui.Helper:seekWidgetByName(root, "Text_prop_name_"..i)
		local Text_prop_sell = ccui.Helper:seekWidgetByName(root, "Text_prop_sell_"..i)
		local Text_prop_sell_end = ccui.Helper:seekWidgetByName(root, "Text_prop_sell_"..i.."_1")
		local Text_prop_text = ccui.Helper:seekWidgetByName(root, "Text_prop_text_"..i.."_0")
		local Button_buy = ccui.Helper:seekWidgetByName(root, "Button_buy_"..i)
		local infos = zstring.split(activityDatas.activityInfo_need_day, ",")

		Text_prop_sell:setString(infos[3])
        Text_prop_sell_end:setString(infos[2])
        Text_prop_text:setString(currentTimess[i].."/"..infos[1])
        if tonumber(currentTimess[i]) <= 0 then
        	Button_buy:setTouchEnabled(false)
			Button_buy:setBright(false)
        else
        	Button_buy:setTouchEnabled(true)
			Button_buy:setBright(true)
        end

		Panel_props:removeAllChildren(true)
        if tonumber(activityDatas.activityInfo_silver) ~= 0 then
            local cell = ResourcesIconCell:createCell()
            cell:init(1, tonumber(activityDatas.activityInfo_silver), -1,nil,nil,true,true)
            Panel_props:addChild(cell)
            Text_prop_name:setString(_All_tip_string_info._fundName)
        end
        if tonumber(activityDatas.activityInfo_gold) ~= 0 then
            local cell = ResourcesIconCell:createCell()
            cell:init(2, tonumber(activityDatas.activityInfo_gold), -1,nil,nil,true,true)
            Panel_props:addChild(cell)
            Text_prop_name:setString(_All_tip_string_info._crystalName)
        end
        if tonumber(activityDatas.activityInfo_food) ~= 0 then
            local cell = ResourcesIconCell:createCell()
            cell:init(12, tonumber(activityDatas.activityInfo_gold), -1,nil,nil,true,true)
            Panel_props:addChild(cell)
            Text_prop_name:setString(_All_tip_string_info._energyName)
        end
        if tonumber(activityDatas.activityInfo_equip_count) ~= 0 then
            local equip_data = activityDatas.activityInfo_equip_info[1]
            local cell = ResourcesIconCell:createCell()
            cell:init(7, tonumber(equip_data.equipMouldCount), equip_data.equipMould,nil,nil,true,true)
            Panel_props:addChild(cell)
            local nameindex = dms.int(dms["equipment_mould"], equip_data.equipMould, equipment_mould.equipment_name)
            local word_info = dms.element(dms["word_mould"], nameindex)
            Text_prop_name:setString(word_info[3])
        end
        if tonumber(activityDatas.activityInfo_prop_count) ~= 0 then
            local prop_data = activityDatas.activityInfo_prop_info[1]
            local cell = ResourcesIconCell:createCell()
            cell:init(6, tonumber(prop_data.propMouldCount), prop_data.propMould, nil,nil,true,true)
            Panel_props:addChild(cell)
            local name = setThePropsIcon(prop_data.propMould)[2]
            Text_prop_name:setString(name)
            if dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.use_of_ship) > 0 
                and dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.storage_page_index) == 18 
                then
                local jsonFile = "sprite/sprite_wzkp.json"
                local atlasFile = "sprite/sprite_wzkp.atlas"
                local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                animation:setPosition(cc.p(cell:getContentSize().width/2,cell:getContentSize().height/2))
                cell:addChild(animation)
            end
        end
        local otherRewards = zstring.splits(activityDatas.activityInfo_reward_select, "|", ",")
        if #otherRewards > 0 then
            for i, v in pairs(otherRewards) do
                if #v >= 3 then
                    local cell = ResourcesIconCell:createCell()
                    local rewardType = tonumber(v[1])
                    if 13 == rewardType then
                        local table = {}
                        if v[4] ~= nil and tonumber(v[4]) ~= -1 then
                            table.shipStar = tonumber(v[4])
                        end
                        cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1,table)
                        local evo_image = dms.string(dms["ship_mould"], v[2], ship_mould.fitSkillTwo)
                        local evo_info = zstring.split(evo_image, ",")
                        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], v[2], ship_mould.captain_name)]
                        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
                        local word_info = dms.element(dms["word_mould"], name_mould_id)
                        local name = word_info[3]
                        Text_prop_name:setString(name)
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
                        elseif 6 == rewardType then
                            name = setThePropsIcon(tonumber(v[2]))[2]
                        end
                        Text_prop_name:setString(name)
                    end
                    Panel_props:addChild(cell)
                end
            end
        end
	end
end

function SmPropGiftBoxPromotion:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	self:onInit()
	self:registerOnNoteUpdate(self, 1)
end

function SmPropGiftBoxPromotion:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	self._tick_time = 0
	self._endtime = nil
	self:unregisterOnNoteUpdate(self)
end

function SmPropGiftBoxPromotion:onEnterTransitionFinish()
end

function SmPropGiftBoxPromotion:onLoad()

end

function SmPropGiftBoxPromotion:onUpdate( dt )
    if self._endtime == nil then
        return
    end
    self._tick_time = self._tick_time - dt
    if self._tick_time <= 0 then
    	self._tick_time = 0
    end
	self._endtime:setString(getRedAlertTimeActivityFormat(self._tick_time).._new_interface_text[245])
end

function SmPropGiftBoxPromotion:onInit()
    local csbActivityDoubleDiscount = csb.createNode("activity/wonderful/ltem_discount.csb")
    local root = csbActivityDoubleDiscount:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbActivityDoubleDiscount)
		
	for i=1,3 do
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_"..i), nil, 
		{
			terminal_name = "sm_activity_prop_gift_box_promotion_buy", 
			terminal_state = 0, 
			index = i,	
			isPressedActionEnabled = true
		},
		nil,0)
	end

	self:onUpdateDraw()
end

function SmPropGiftBoxPromotion:init()
	
end

function SmPropGiftBoxPromotion:createCell()
	local cell = SmPropGiftBoxPromotion:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function SmPropGiftBoxPromotion:onExit()
	state_machine.remove("sm_activity_prop_gift_box_promotion_update")
	state_machine.remove("sm_activity_prop_gift_box_promotion_buy")
end