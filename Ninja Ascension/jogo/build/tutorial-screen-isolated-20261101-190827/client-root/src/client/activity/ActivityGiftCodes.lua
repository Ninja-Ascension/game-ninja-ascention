-- ----------------------------------------------------------------------------------------------------
-- 说明：礼品码活动
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityGiftCodes = class("ActivityGiftCodesClass", Window)
    
function ActivityGiftCodes:ctor()
    self.super:ctor()
	self.roots = {}
	self.loaded = false

	
    -- Initialize ActivityGiftCodes state machine.
    local function init_ActivityGiftCodes_terminal()
		--前往 验证礼品码
		local activity_gift_codes_exchange_button_terminal = {
            _name = "activity_gift_codes_exchange_button",
            _init = function (terminal) 
                
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
			
				local text = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_1")
				text:didNotSelectSelf()
				local codes = text:getString()
				
				if codes == nil or codes == "" or string.len(codes) == 0 then
					TipDlg.drawTextDailog(_string_piece_info[257])
					return
				end
				
				codes = zstring.exchangeTo(codes)
				
				local function responseInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- text:setString("")
						-- instance:showReward()
						if response.node ~= nil and response.node.roots[1] ~= nil then
							local text = ccui.Helper:seekWidgetByName(response.node.roots[1], "TextField_1")
							text:setString("")
							response.node:showReward()
						end
					end
				end

				protocol_command.draw_cdkey_reward.param_list = codes.."\r\n"..app.configJson.url
				NetworkManager:register(protocol_command.draw_cdkey_reward.code, nil, nil, nil, instance, responseInitCallback, false, nil)
				
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(activity_gift_codes_exchange_button_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityGiftCodes state machine.
    init_ActivityGiftCodes_terminal()

    self._load_over = false
	self:onLoad()
end

function ActivityGiftCodes:showReward()
	
	local rewardInfo = {
		show_reward_item_count = 0,
		show_reward_list = {}
	}
	
	
	function addItem (prop_item, prop_type, item_value)
	
		local item = {
			prop_item = prop_item,
			prop_type = prop_type,
			item_value = item_value,
		}
		
		table.insert(rewardInfo.show_reward_list, item)
	end
	
	
	local activity = _ED.active_activity[16]
	local activityInfo = activity.activity_Info[1]
	--local activity_count = activity.activity_count
	-- local activityInfo = {
			-- activityInfo_name = npos(list),		--奖励1名称
			-- activityInfo_silver = npos(list),		--奖励1可领取银币数量 
			-- activityInfo_gold = npos(list),		--奖励1可领取金币数量
			-- -- activityInfo_food = npos(list),		--奖励1可领取体力数量 
			-- -- activityInfo_honour = npos(list),		--奖励1可领取声望数量
		-- }
		
	local silver = zstring.tonumber(activityInfo.activityInfo_silver)
	local gold = zstring.tonumber(activityInfo.activityInfo_gold)
	local food = zstring.tonumber(activityInfo.activityInfo_food)
	if silver > 0 then
		addItem(-1,1,silver)
	end
	if gold > 0 then
		addItem(-1,2,gold)
	end
	if food > 0 then
		addItem(-1,12,food)
	end
	
	-- activityInfo.activityInfo_prop_count = npos(list)	--奖励1可领取道具种类量
	-- activityInfo.activityInfo_prop_info = {}
	for i = 1 , activityInfo.activityInfo_prop_count do
		local propInfo = activityInfo.activityInfo_prop_info[i]
		addItem(propInfo.propMould, 6, propInfo.propMouldCount)
	end
	
	-- activityInfo.activityInfo_equip_count = npos(list)		--可领取装备种类量
	-- activityInfo.activityInfo_equip_info = {}
	for i = 1 , activityInfo.activityInfo_equip_count do
		local equipInfo = activityInfo.activityInfo_equip_info[i]
		addItem(equipInfo.equipMould, 7, equipInfo.equipMouldCount)
	end

	rewardInfo.show_reward_item_count = table.getn(rewardInfo.show_reward_list)

	app.load("client.reward.DrawGiftsReward")
	local getRewardWnd = DrawGiftsReward:new()
	getRewardWnd:init(nil,rewardInfo)
	fwin:open(getRewardWnd,fwin._ui)

end

function ActivityGiftCodes:onUpdateDraw()
	if self.loaded == false then
		return
	end
	local root = self.roots[1]
	
end


function ActivityGiftCodes:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	self:onInit()
end

function ActivityGiftCodes:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
end

function ActivityGiftCodes:onEnterTransitionFinish()

end

function ActivityGiftCodes.onImageLoaded(texture)
	
end

function ActivityGiftCodes:onArmatureDataLoad(percent)
	
end

function ActivityGiftCodes:onArmatureDataLoadEx(percent)

end

function ActivityGiftCodes:onLoad()

end

function ActivityGiftCodes:onInit()
    local csbActivityGiftCodes = csb.createNode("activity/wonderful/gift_codes.csb")
    local root = csbActivityGiftCodes:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbActivityGiftCodes)
	
	self:onUpdateDraw()

	local text = ccui.Helper:seekWidgetByName(root, "TextField_1")
	draw:addEditBox(text, _string_piece_info[342], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_01"), 120, cc.KEYBOARD_RETURNTYPE_DONE)
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_01"), nil, 
			{
				terminal_name = "activity_gift_codes_exchange_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				codes = text:getString()
			},
			nil,0)

end

function ActivityGiftCodes:onExit()
	state_machine.remove("activity_gift_codes_exchange_button")
end

function ActivityGiftCodes:init()
end


function ActivityGiftCodes:createCell()
	local cell = ActivityGiftCodes:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 0.5)
	return cell
end