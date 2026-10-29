cc.Director:getInstance():getTextureCache():addImage("images/ui/bar/tuishong.png")
push_notification_can_receive_count = 0      -- 军团副本可领取宝箱数量
-- Initialize push notification center state machine.
local function init_push_notification_legion_terminal()

    -- 军团申请
    local push_notification_center_legion_apply_terminal = {
        _name = "push_notification_center_legion_apply",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getlegionApplyTips() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.3, params._widget:getContentSize().height-ball:getContentSize().height*0.3))
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    -- 军团副本
    local push_notification_legion_pve_receive_terminal = {
        _name = "push_notification_legion_pve_receive",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local count = getLegionPveCanReceiveCount()
            local isChange = false
            if count ~= push_notification_can_receive_count then
                isChange = true
            end
            push_notification_can_receive_count = count
            if count > 0 then
                if isChange == true then
                    if params._widget._istips == true then
                        params._widget:removeChild(params._widget._nodeChild, true)
                        params._widget._nodeChild = nil
                        params._widget._istips = false
                    end
                end
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {count})
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(push_notification_center_legion_apply_terminal)
    state_machine.add(push_notification_legion_pve_receive_terminal)
    state_machine.init()
end
init_push_notification_legion_terminal()

--加入申请
function getlegionApplyTips( ... )
    if _ED.union.union_info == nil 
        or _ED.union.union_info == {} 
        or _ED.union.union_info.union_id == nil 
        or _ED.union.union_info.union_id == "" 
        or tonumber(_ED.union.union_info.union_id) == 0 
        or tonumber(_ED.union.user_union_info.union_post) >= 3
        then
    else
        if _ED.union.union_examine_list_sum ~= nil 
            and zstring.tonumber(_ED.union.union_examine_list_sum) > 0 
            and (tonumber(_ED.union.user_union_info.union_post) == 1 or tonumber(_ED.union.user_union_info.union_post) == 2)
            then
            return true
        end
    end
    return false 
end

function getLegionPveCanReceiveCount()
    local canReceiveCount = 0
    if _ED.union.union_info == nil 
        or _ED.union.union_info == {} 
        or _ED.union.union_info.union_id == nil 
        or _ED.union.union_info.union_id == "" 
        or tonumber(_ED.union.union_info.union_id) == 0 
        or _ED.scene_current_state == nil 
        or _ED.union_pve_is_receive == nil 
        or _ED.union_pve_info == nil 
        then
        canReceiveCount = 0
    else
        for k,v in pairs(_ED.scene_current_state) do
            local _scene_type = dms.int(dms["pve_scene"], k, pve_scene.scene_type) 
            if _scene_type == battle_enum._fight_type._fight_type_107 then
                local scene_id = dms.int(dms["pve_scene"], k, pve_scene.scene_id) 
                local npcs = zstring.split(dms.string(dms["pve_scene"], k, pve_scene.npcs), ",")
                if _ED.union_pve_is_receive[scene_id] ~= nil then
                    local is_receive = zstring.split(_ED.union_pve_is_receive[scene_id], ",")
                    for i=1,#npcs do
                        local scene_npc_state = tonumber(_ED.union_pve_info[""..scene_id][""..i].npc_state)
                        local scene_is_receive = tonumber(is_receive[i])
                        if scene_npc_state == 1 and scene_is_receive == 0 then
                            canReceiveCount = canReceiveCount + 1
                        end
                    end
                end
            end
        end
    end
    _ED._can_receive_count = canReceiveCount
    return canReceiveCount
end
