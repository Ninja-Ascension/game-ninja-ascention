-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军商店购买选择数量(没有用到)
-- 创建时间	2015-03-06
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

DispatchBuyProp = class("DispatchBuyPropClass", Window)
    
function DispatchBuyProp:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.cells.prop.prop_icon_cell")
	self.dispatchStrMouID = nil
	self.propRecruitCount = nil
	self.prop_instance = nil
	self.propPrice = nil
    -- Initialize DispatchBuyProp page state machine.
    local function init_world_boss_terminal()
		--	关闭npc二级信息界面
		local dispatch_buy_prop_button_close_terminal = {
            _name = "dispatch_buy_prop_button_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 使用
		local dispatch_buy_prop_use_button_terminal = {
            _name = "dispatch_buy_prop_use_button",
            _init = function (terminal) 
               
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local _propId = params._datas.propId
				local _count = 1
				
				
				local function responseShopViewCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						TipDlg.drawTextDailog(_string_piece_info[311].._count.._string_piece_info[70])
						response.node:onUpdateDraw()
						--发出消息使用了东西了.
						state_machine.excute("betray_army_battle_scene_refresh_state", 0, "betray_army_battle_scene_refresh_state.")
					end
				end
				local prop = fundPropWidthId(_propId)
				if prop ~= nil then
					local _prop_id = prop.user_prop_id
					protocol_command.prop_use.param_list = _prop_id.."\r\n" .. _count
					NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, instance, responseShopViewCallBack, false, nil)
				else
					TipDlg.drawTextDailog(_string_piece_info[312])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--购买
		local dispatch_buy_prop_button_dispatch_terminal = {
            _name = "dispatch_buy_prop_button_dispatch",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local _propInstance = params._datas.propInstance
				local _propPrice = params._datas.prop_price
				local _count = 1
				local function responseBuyPropCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						TipDlg.drawTextDailog(_string_piece_info[76])
						_propInstance.buy_times = _propInstance.buy_times + 1
						response.node:onUpdateDraw()
					end
				end
				if zstring.tonumber(_propPrice) <= zstring.tonumber(_ED.user_info.user_gold) then
					_ED._buy_item_consumption = _propPrice
					protocol_command.prop_purchase.param_list = _propInstance.shop_prop_instance .. "\r\n" .._count.. "\r\n" .. "0"
					NetworkManager:register(protocol_command.prop_purchase.code, nil, nil, nil, instance, responseBuyPropCallback, false, nil)
				else
					TipDlg.drawTextDailog(_string_piece_info[74])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(dispatch_buy_prop_button_close_terminal)
		state_machine.add(dispatch_buy_prop_use_button_terminal)
		state_machine.add(dispatch_buy_prop_button_dispatch_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_world_boss_terminal()
end

--计算价格
function DispatchBuyProp:drawPrice(_prop)
	if tonumber(_prop.price_increase) == -1 then
		return tonumber(_prop.original_cost)
	end
	local ret = _prop.price_increase
	local ret2 = zstring.split(ret,"!")
	local priceConfig = {}
	for n, v in pairs(ret2) do
		local temp = zstring.split(v,",")
		local range = zstring.split(temp[1], "-")
		local price = {
			_range = range,
			_price = temp[2]
		}
		priceConfig[n] = price
	end
	
	local buyTimes = tonumber(_prop.buy_times + 1)
	local price = 0
	for i, v in pairs(priceConfig) do
		if buyTimes >= tonumber(v._range[1]) and buyTimes <= tonumber(v._range[2]) then
			return tonumber(v._price)
		end
	end
	return price
end

function DispatchBuyProp:onUpdateDraw()
	local root = self.roots[1]
	
	local dispatchCount = ccui.Helper:seekWidgetByName(root, "Text_7")
	local goldNumber = ccui.Helper:seekWidgetByName(root, "Text_5")			--价格
	local propResidue = ccui.Helper:seekWidgetByName(root, "Text_10")		--剩余购买数量
	local headPanel = ccui.Helper:seekWidgetByName(root, "Panel_4")			--道具图标
	local propName = ccui.Helper:seekWidgetByName(root, "Text_4")			--道具名字
	local propDescribe = ccui.Helper:seekWidgetByName(root, "Text_3")			--道具描述
	--征讨令的数量
	local dispatchStr =dms.string(dms["pirates_config"], 273, pirates_config.param)
	self.dispatchStrMouID = zstring.split(dispatchStr,",")	
	local propRecruitCount = getPropAllCountByMouldId(self.dispatchStrMouID[17])
	dispatchCount:setString(propRecruitCount)
	
	for i, v in pairs(_ED.return_prop) do
		if tonumber(v.prop_type) == 0 then
			if tonumber(self.dispatchStrMouID[17]) == tonumber(v.mould_id) then
				--征讨令的可购买次数
				local times = tonumber(v.VIP_buy_times) - tonumber(v.buy_times)
				if tonumber(v.VIP_buy_times) == -1 then
					propResidue:setString(_string_piece_info[75])
				else
					if times >= 0 then
						propResidue:setString(times)
					else
						propResidue:setString("0")
					end
				end
				--征讨令的描述
				propDescribe:setString(v.mould_remarks)
				--征讨令的名字和品质
				local propQuality = tonumber(v.prop_quality) + 1
				propName:setString(v.mould_name)
				propName:setColor(cc.c3b(color_Type[propQuality][1], color_Type[propQuality][2], color_Type[propQuality][3]))
				--征讨令的价格
				goldNumber:setString(self:drawPrice(v))
				--征讨令的图标
				local iconCell = PropIconCell:createCell()
				iconCell:init(7, {mould_id = v.mould_id})
				headPanel:addChild(iconCell)
				
				self.prop_instance = v
				self.propPrice = self:drawPrice(v)
			end
		end
	end
end

function DispatchBuyProp:onEnterTransitionFinish()
	local csbShopPropBuyNumberTip = csb.createNode("campaign/activity_buy_props.csb")
	local root = csbShopPropBuyNumberTip:getChildByName("root")
	table.insert(self.roots, root)
	local action = csb.createTimeline("campaign/activity_buy_props.csb") 
	
   	action:gotoFrameAndPlay(0, action:getDuration(), false)
    csbShopPropBuyNumberTip:runAction(action)
    self:addChild(csbShopPropBuyNumberTip)
	
	
	self:onUpdateDraw()
	--关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gmdj_gb"), nil, 
		{
			terminal_name = "dispatch_buy_prop_button_close",
			terminal_state = 0,
			isPressedActionEnabled = true
		}, nil, 2)
	--使用
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
		{
			terminal_name = "dispatch_buy_prop_use_button",
			terminal_state = 0,
			propId = self.dispatchStrMouID[17],
			isPressedActionEnabled = true
		}, nil, 0)
	--购买
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
		{
			terminal_name = "dispatch_buy_prop_button_dispatch",
			terminal_state = 0,
			propInstance = self.prop_instance,
			prop_price = self.propPrice,
			isPressedActionEnabled = true
		}, nil, 0)
		
end

function DispatchBuyProp:onExit()
	state_machine.remove("dispatch_buy_prop_button_close")
end

function DispatchBuyProp:init()
	
end

function DispatchBuyProp:createCell()
	local cell = DispatchBuyProp:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


