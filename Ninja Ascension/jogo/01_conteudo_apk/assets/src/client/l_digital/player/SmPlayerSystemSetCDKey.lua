-- ----------------------------------------------------------------------------------------------------
-- 说明：数码系统cdkey兑换
-------------------------------------------------------------------------------------------------------
SmPlayerSystemSetCDKey = class("SmPlayerSystemSetCDKeyClass", Window)
local sm_player_system_set_cdkey_page_open_terminal = {
    _name = "sm_player_system_set_cdkey_page_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local _window = fwin:find("SmPlayerSystemSetCDKeyClass")
        if _window == nil then
            fwin:open(SmPlayerSystemSetCDKey:new(),fwin._ui)
        end
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_player_system_set_cdkey_page_open_terminal)
state_machine.init()
    
function SmPlayerSystemSetCDKey:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
	
    local function init_sm_player_system_set_cdkey_page_terminal()
        --确定
        local sm_player_system_set_cdkey_page_define_terminal = {
            _name = "sm_player_system_set_cdkey_page_define",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local TextField_name = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_name")
                local codes = TextField_name:getString()
                codes = zstring.exchangeTo(codes)
                if tonumber(#codes) ~= 10 then
                    app.load("client.l_digital.union.meeting.SmUnionTipsWindow")
                    state_machine.excute("sm_union_tips_window_open", 0, {_new_interface_text[114],2})
                    return
                end
                local function responseInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- app.load("client.reward.DrawRareReward")
                        -- local getRewardWnd = DrawRareReward:new()
                        -- getRewardWnd:init(7)
                        -- fwin:open(getRewardWnd,fwin._ui)
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                            -- response.node:showReward()
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(67)
                            fwin:open(getRewardWnd,fwin._ui)
                        end
                        state_machine.excute("sm_player_system_set_cdkey_page_close",0,"sm_player_system_set_cdkey_page_close.")
                    end
                end
                protocol_command.draw_cdkey_reward.param_list = codes.."\r\n"..app.configJson.url
                NetworkManager:register(protocol_command.draw_cdkey_reward.code, nil, nil, nil, instance, responseInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --关闭
        local sm_player_system_set_cdkey_page_close_terminal = {
            _name = "sm_player_system_set_cdkey_page_close",
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
        state_machine.add(sm_player_system_set_cdkey_page_get_random_name_terminal)
		state_machine.add(sm_player_system_set_cdkey_page_define_terminal)
        state_machine.add(sm_player_system_set_cdkey_page_close_terminal)
        state_machine.init()
    end
    
    init_sm_player_system_set_cdkey_page_terminal()
end

function SmPlayerSystemSetCDKey:detachWithIME()
    local root = self.roots[1]
    local TextField_name = ccui.Helper:seekWidgetByName(root, "TextField_name")
    TextField_name:didNotSelectSelf()
end

function SmPlayerSystemSetCDKey:showReward()
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
            -- activityInfo_name = npos(list),      --奖励1名称
            -- activityInfo_silver = npos(list),        --奖励1可领取银币数量 
            -- activityInfo_gold = npos(list),      --奖励1可领取金币数量
            -- -- activityInfo_food = npos(list),       --奖励1可领取体力数量 
            -- -- activityInfo_honour = npos(list),     --奖励1可领取声望数量
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

    for i = 1 , activityInfo.activityInfo_prop_count do
        local propInfo = activityInfo.activityInfo_prop_info[i]
        addItem(propInfo.propMould, 6, propInfo.propMouldCount)
    end
    
    for i = 1 , activityInfo.activityInfo_equip_count do
        local equipInfo = activityInfo.activityInfo_equip_info[i]
        addItem(equipInfo.equipMould, 7, equipInfo.equipMouldCount)
    end

    rewardInfo.show_reward_item_count = table.getn(rewardInfo.show_reward_list)
    app.load("client.reward.DrawRareReward")
    local getRewardWnd = DrawRareReward:new()
    getRewardWnd:init(nil,rewardInfo)
    fwin:open(getRewardWnd,fwin._ui)

end

function SmPlayerSystemSetCDKey:onEnterTransitionFinish()
	local csbUserInfo = csb.createNode("player/role_information_cdkey.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"),nil, 
    {
        terminal_name = "sm_player_system_set_cdkey_page_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ok"),nil, 
    {
        terminal_name = "sm_player_system_set_cdkey_page_define",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)
    local TextField_name = ccui.Helper:seekWidgetByName(root, "TextField_name")
    draw:addEditBox(TextField_name, _new_interface_text[108], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_ok"), 20, cc.KEYBOARD_RETURNTYPE_DONE)
end

function SmPlayerSystemSetCDKey:onExit()
    state_machine.remove("sm_player_system_set_cdkey_page_define")
    state_machine.remove("sm_player_system_set_cdkey_page_close")
end
