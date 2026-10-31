-- ----------------------------------------------------------------------------------------------------
-- 说明：每日签到
-------------------------------------------------------------------------------------------------------
AdventureDailySignIn = class("AdventureDailySignInClass", Window)
    
app.load("client.adventure.cells.prop.adventure_sign_prop_icon_cell")

function AdventureDailySignIn:ctor()
    self.super:ctor()
    self.roots = {}

    self.curSignIndex = 0

    -- Initialize adventure daily sign in state machine.
    local function init_adventure_daily_sign_in_terminal()
        -- 每日签到
        local adventure_daily_sign_in_everyday_sign_in_terminal = {
            _name = "adventure_daily_sign_in_everyday_sign_in",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance:checkSign() then
                    -- 可以签到
                    local function responseGetServerListCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            response.node:onUpdateDraw()
                            -- 清除奖励数据
                            _ED.recruit_success_ship_id = ""
                            _ED.recruit_success_ship_ids = ""
                        end
                    end
                    local activityId = _ED.active_activity[38].activity_id
					if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
						protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..self.curSignIndex.."\r\n".."1"
					else	
						protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..self.curSignIndex
					end	
                    NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                else
                    TipDlg.drawTextDailog(_string_piece_info[413])
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更多
        local adventure_daily_sign_in_more_terminal = {
            _name = "adventure_daily_sign_in_more",
            _init = function (terminal) 
                app.load("client.adventure.activity.sign.AdventureWeekSignInReward")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureWeekSignInReward:new():init(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_daily_sign_in_everyday_sign_in_terminal)
        state_machine.add(adventure_daily_sign_in_more_terminal)
        state_machine.init()
    end
    
    -- call func init adventure daily sign in state machine.
    init_adventure_daily_sign_in_terminal()
end

function AdventureDailySignIn:init()

    return self
end

function AdventureDailySignIn:checkSign()
    local hour = tonumber(os.date("%H"))

    local activity_Info = _ED.active_activity[38].activity_Info[1]            -- 取当天数据
    local signStatus = zstring.split(activity_Info.activityInfo_isReward, ",")

    if hour >= 0 and hour < 12 then
        if tonumber(signStatus[1]) == 0 then
            return true
        else
            return false
        end
    elseif hour >= 12 and hour < 18 then
        if tonumber(signStatus[2]) == 0 then
            return true
        else
            return false
        end
    elseif hour >= 18 and hour < 24 then
        if tonumber(signStatus[3]) == 0 then
            return true
        else
            return false
        end
    end
end

function AdventureDailySignIn:onUpdateDraw()
    local root = self.roots[1]
    local activity_Info = _ED.active_activity[38].activity_Info[1]            -- 取当天数据
    local signStatus = zstring.split(activity_Info.activityInfo_isReward, ",")

    for i = 1, 3 do
        local signedImage = ccui.Helper:seekWidgetByName(root, "Image_r" .. i)
        if tonumber(signStatus[i]) == 1 then
            signedImage:setVisible(true)
            self.curSignIndex = i
        end
    end
end

function AdventureDailySignIn:initSignReward()
    local root = self.roots[1]
    local activity_Info = _ED.active_activity[38].activity_Info[1]            -- 取当天数据
    local prop_info_list = activity_Info.activityInfo_prop_info
	
    for i = 1, 3 do
        local rewardPanel = ccui.Helper:seekWidgetByName(root, "Panel_reward_" .. i)
        rewardPanel:removeAllChildren(true)

        local prop_info = prop_info_list[i]
        local cell = adventureSignPropIconCell:createCell()
        if zstring.tonumber(prop_info.propIcon) == 6 then          -- 目前用propIcon代表类型（道具或者货币）
            cell:init(0,  {mould_id = prop_info.propMould}, prop_info.propMouldCount, 0)
        else
            cell:init(0, {resource_type = zstring.tonumber(prop_info.propIcon)}, prop_info.propMouldCount, 0)
        end

        rewardPanel:addChild(cell)
    end 
end

function AdventureDailySignIn:onEnterTransitionFinish()
    local csbActivityDailySignIn = csb.createNode("system/sign_day.csb")
    local root = csbActivityDailySignIn:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbActivityDailySignIn)
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureDailySignInClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 签到
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sign"),       nil, 
    {
        terminal_name = "adventure_daily_sign_in_everyday_sign_in",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 更多
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_more"),       nil, 
    {
        terminal_name = "adventure_daily_sign_in_more",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:initSignReward()
    self:onUpdateDraw()
end

function AdventureDailySignIn:onExit()
    state_machine.remove("adventure_daily_sign_in_everyday_sign_in")
    state_machine.remove("adventure_daily_sign_in_more")
end