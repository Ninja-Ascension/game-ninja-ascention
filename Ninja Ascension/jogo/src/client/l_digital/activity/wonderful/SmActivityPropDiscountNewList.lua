-- ----------------------------------------------------------------------------------------------------
-- 说明：道具折扣list
-- 创建时间：2018-11-1
-- 作者：shinefeng
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
SmActivityPropDiscountNewList = class("SmActivityPropDiscountNewListClass", Window)
    
function SmActivityPropDiscountNewList:ctor()
	self.super:ctor()
	self.roots = {}

	self.activity = nil
	self.index = 0

	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.l_digital.activity.wonderful.SmActivityPropDiscountNew")

	-- Initialize emblem_limit_time_exchange_cell state machine.
	local function init_activity_prop_discount_list_new_terminal()
        local sm_activity_prop_discount_buy_terminal = {
            _name = "sm_activity_prop_discount_buy",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local activity = _ED.active_activity[112]
                if activity == nil then
                    return
                end
                --print("=======_index===777777======",cell.index)
                app.load("client.l_digital.activity.wonderful.SmActivityPropDiscountBuyConfirm")
                local temp = {index = cell.index, activity_id = 112}
                state_machine.excute("sm_activity_auto_upgrade_window_open", 0, temp)
			    return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_activity_prop_discount_buy_terminal)
		state_machine.init()
	end

	init_activity_prop_discount_list_new_terminal()
end

function SmActivityPropDiscountNewList:onUpdateDraw()
	local root = self.roots[1]
	--local activityInfo = self.activity.activity_Info[tonumber(self.index)]
	--local countInfos = zstring.split(self.activity.activity_params, ",")
	local activity = self.activity
	local currentTimess = zstring.split(activity.activity_params, ",")
	local activityDatas = activity.activity_Info[tonumber(self.index)]
	local Panel_props = ccui.Helper:seekWidgetByName(root, "Panel_props_1")
	local Text_prop_name = ccui.Helper:seekWidgetByName(root, "Text_prop_name_1")
	local Text_prop_sell = ccui.Helper:seekWidgetByName(root, "Text_prop_sell_1")
	local Text_prop_sell_end = ccui.Helper:seekWidgetByName(root, "Text_prop_sell_1_1")
	local Text_prop_text = ccui.Helper:seekWidgetByName(root, "Text_prop_text_1_0")
	local Button_buy = ccui.Helper:seekWidgetByName(root, "Button_buy_1")
	local infos = zstring.split(activityDatas.activityInfo_need_day, ",")

	Text_prop_sell:setString(infos[3])
    Text_prop_sell_end:setString(infos[2])
    Text_prop_text:setString(currentTimess[tonumber(self.index)].."/"..infos[1])
    if tonumber(currentTimess[tonumber(self.index)]) <= 0 then
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
                else
                    if v[4] then
                        cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1,{shipStar = tonumber(v[4])})
                    else
                        cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1)
                    end
                    
                    local types = tonumber(v[1])
                end
                local name = getItemNameAndQuality({rewardType, tonumber(v[2]), tonumber(v[3])})[1]
                Text_prop_name:setString(name)
                Panel_props:addChild(cell)
            end
        end
    end
end
function SmActivityPropDiscountNewList:onInit()
	local csbSmActivityPropDiscountNewList = csb.createNode("activity/wonderful/ltem_discount_list.csb")
	local root = csbSmActivityPropDiscountNewList:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_1"), nil, 
	{
		terminal_name = "sm_activity_prop_discount_buy", 
		terminal_state = 0, 
		cell = self,	
		isPressedActionEnabled = true
	},
	nil,0)
	
	self:setContentSize(root:getContentSize())

	self:onUpdateDraw()
end

function SmActivityPropDiscountNewList:onExit()
end

function SmActivityPropDiscountNewList:init(activity, index, listView)
	self.activity = activity
	self.index = index
	self.listView = listView
	self:onInit()
end

function SmActivityPropDiscountNewList:createCell()
	local cell = SmActivityPropDiscountNewList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end