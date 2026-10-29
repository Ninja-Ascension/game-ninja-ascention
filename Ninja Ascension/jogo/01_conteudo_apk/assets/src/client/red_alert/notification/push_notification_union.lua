-- Initialize push notification center state machine.
local function init_push_notification_union_terminal()
    --组队争霸
    local push_notification_union_team_fight_terminal = {
        _name = "push_notification_union_team_fight",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getUnionTeamFightTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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
    --阿拉希之战
    local push_notification_union_axila_terminal = {
        _name = "push_notification_union_axila",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getUnionAxilaTip() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

    --建设
    local push_notification_union_build_terminal = {
        _name = "push_notification_union_build",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getUnionBuildTip() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

    --工会申请
    local push_notification_center_union_apply_terminal = {
        _name = "push_notification_center_union_apply",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getUnionApplyTips() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
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

    state_machine.add(push_notification_union_team_fight_terminal)
    state_machine.add(push_notification_union_axila_terminal)
    state_machine.add(push_notification_union_build_terminal)
    state_machine.add(push_notification_center_union_apply_terminal)
    state_machine.init()
end
init_push_notification_union_terminal()

--组队争霸
function getUnionTeamFightTip()
    if tonumber(_ED.union.user_union_info.team_fight_use_state) == 0 then
        return true
    end
    return false
end
    
--阿希拉
function getUnionAxilaTip()
    push_npc_level = _ED.push_notification_info.union.axila_npc_level
    for k,v in pairs(push_npc_level) do
        local levels = zstring.split(v, ",")
        local min_level = levels[1]
        local max_level = levels[2]
        local npc_id = levels[3]
        if tonumber(_ED.user_info.user_grade) >= tonumber(min_level)
            and tonumber(_ED.user_info.user_grade) <= tonumber(max_level)
            then
            if tonumber(_ED.npc_current_attack_count[tonumber(npc_id)]) == 0 then
                return true
            end
        end
    end
    return false
end

--建设
function getUnionBuildTip()
    if tonumber(_ED.union.user_union_info.build_count) == 0 then
        return true
    end
    return false
end

--加入申请
function getUnionApplyTips( ... )
    if _ED.union.union_examine_list_sum ~= nil and zstring.tonumber(_ED.union.union_examine_list_sum) > 0 then
        return true
    end
    return false 
end
