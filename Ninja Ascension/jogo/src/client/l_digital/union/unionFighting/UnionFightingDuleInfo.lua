-- ---------------------------
-- 工会战-决赛战斗过程中
-- ---------------------------
UnionFightingDuleInfo = class("UnionFightingDuleInfoClass", Window)

local union_fighting_dule_info_window_open_terminal = {
    _name = "union_fighting_dule_info_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("UnionFightingDuleInfoClass") == nil then
            local panel = UnionFightingDuleInfo:new():init(params)
            fwin:open(panel)
            return panel
        end
        return nil
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fighting_dule_info_window_open_terminal)
state_machine.init()

function UnionFightingDuleInfo:ctor()
    self.super:ctor()
    self.roots = {}

    self._last_battle_type = 0

    local function init_union_fighting_dule_info_terminal()
        local union_fighting_dule_info_update_info_terminal = {
            _name = "union_fighting_dule_info_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求决赛战报
        local union_fighting_dule_info_request_refresh_terminal = {
            _name = "union_fighting_dule_info_request_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    if _ED.union.union_fight_duel_info ~= nil and _ED.union.union_fight_duel_info.user_battle_type ~= nil then
                        local battle_type = _ED.union.union_fight_duel_info.user_battle_type
                        local position = _ED.union.union_fight_duel_info.user_position
                        local function responseCallback(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                    state_machine.excute("union_fighting_dule_info_update_info", 0, "")
                                    state_machine.excute("union_fighting_join_update_dule_report", 0, "")
                                end
                            end
                        end

                        local leftUnionId = 0
                        local rightUnionId = 0
                        if battle_type == 0 then
                            local vs_position = math.ceil(position / 2)
                            local left_info = _ED.union.union_fight_duel_info.battle_info[""..battle_type][""..(vs_position * 2 - 1)]
                            local right_info = _ED.union.union_fight_duel_info.battle_info[""..battle_type][""..(vs_position * 2)]
                            leftUnionId = left_info.union_id
                            rightUnionId = right_info.union_id
                        elseif battle_type == 1 then
                            for k, v in pairs(_ED.union.union_fight_duel_info.battle_info[""..battle_type]) do
                                if v.position == position then
                                    if tonumber(k) <= 4 then
                                        leftUnionId = v.union_id
                                    elseif tonumber(k) <= 8 then
                                        rightUnionId = v.union_id
                                    end
                                end
                            end
                        else
                            for k,v in pairs(_ED.union.union_fight_duel_info.battle_info[""..battle_type]) do
                                if v.position == 9 then
                                    leftUnionId = v.union_id
                                elseif v.position == 10 then
                                    rightUnionId = v.union_id
                                end
                            end
                            local win_info = _ED.union.union_fight_duel_info.battle_info[""..battle_type]["11"]
                            if leftUnionId == 0 then
                                leftUnionId = win_info.union_id
                            elseif rightUnionId == 0 then
                                rightUnionId = win_info.union_id
                            end
                        end

                        protocol_command.union_warfare_manager.param_list = "6\r\n5\r\n"..(leftUnionId..","..rightUnionId).."\r\n"..battle_type
                        NetworkManager:register(protocol_command.union_warfare_manager.code, nil, nil, nil, instance, responseCallback, false, nil)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 选择决赛战场
        local union_fighting_dule_info_change_dule_battle_count_terminal = {
            _name = "union_fighting_dule_info_change_dule_battle_count",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    local battle_count = params._datas.battle_count
                    instance:showCurrentBattleCount(battle_count)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fighting_dule_info_update_info_terminal)
        state_machine.add(union_fighting_dule_info_request_refresh_terminal)
        state_machine.add(union_fighting_dule_info_change_dule_battle_count_terminal)
        state_machine.init()
    end
    init_union_fighting_dule_info_terminal()
end

function UnionFightingDuleInfo:showCurrentBattleCount(battle_count)
    local root = self.roots[1]
    local Text_ghz_infor_p = ccui.Helper:seekWidgetByName(root, "Text_ghz_infor_p")
    Text_ghz_infor_p:setString(tipStringInfo_union_str[battle_count + 102])

    state_machine.excute("union_fighting_join_change_dule_battle_count", 0, {battle_count})
end

function UnionFightingDuleInfo:updateDraw()
    local root = self.roots[1]
    if _ED.union.union_fight_duel_match_info == nil then
        return
    end

    self._last_battle_type = _ED.union.union_fight_duel_match_info.battle_type

    local Panel_ghz_infor_title = ccui.Helper:seekWidgetByName(root, "Panel_ghz_infor_title")
    Panel_ghz_infor_title:removeBackGroundImage()

    -- 公会信息
    local Text_vs_n = ccui.Helper:seekWidgetByName(root, "Text_vs_n")

    local battle_type = _ED.union.union_fight_duel_match_info.battle_type
    local match_pos = zstring.split(_ED.union.union_fight_duel_match_info.match_pos, ",")
    Panel_ghz_infor_title:setBackGroundImage(string.format("images/ui/text/GHZ_res/ghz_%d.png", battle_type + 116))

    local battle_result = 0
    local left_info = _ED.union.union_fight_duel_info.battle_info[""..battle_type][""..match_pos[1]]
    local right_info = _ED.union.union_fight_duel_info.battle_info[""..battle_type][""..match_pos[2]]

    local position = tonumber(match_pos[1])
    if battle_type == 1 then
        for k, v in pairs(_ED.union.union_fight_duel_info.battle_info[""..battle_type]) do
            if tonumber(k) <= 4 and v.position == tonumber(match_pos[1]) then
                left_info = v
            elseif tonumber(k) <= 8 and v.position == tonumber(match_pos[2]) then
                right_info = v
            end
        end
    else
        left_info = _ED.union.union_fight_duel_info.battle_info[""..battle_type][""..match_pos[1]]
        right_info = _ED.union.union_fight_duel_info.battle_info[""..battle_type][""..match_pos[2]]
    end

    local left_win_times = 0
    local right_win_times = 0
    for i = 1, 3 do
        local current_num_info = zstring.split(_ED.union.union_fight_duel_match_info.battle_list[i].current_num_info, ",")
        if tonumber(current_num_info[1]) == 0 then
            right_win_times = right_win_times + 1
        elseif tonumber(current_num_info[2]) == 0 then
            left_win_times = left_win_times + 1
        end
    end

    if tonumber(left_win_times) > tonumber(right_win_times) then
        battle_result = 1
    elseif tonumber(left_win_times) < tonumber(right_win_times) then
        battle_result = -1
    end

    Text_vs_n:setString(left_win_times..":"..right_win_times)

    for i = 1, 2 do
        local Panel_legion_logo_icon = ccui.Helper:seekWidgetByName(root, "Panel_legion_logo_icon_"..i)
        local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name_"..i)
        local Text_legion_vs = ccui.Helper:seekWidgetByName(root, "Text_legion_vs_"..i)
        local Panel_legion_vic = ccui.Helper:seekWidgetByName(root, "Panel_legion_vic_"..i)
        local Image_legion_me = ccui.Helper:seekWidgetByName(root, "Image_legion_me_"..i)

        Panel_legion_logo_icon:removeBackGroundImage()
        Panel_legion_logo_icon:removeAllChildren(true)
        Text_legion_name:setString("")
        Text_legion_vs:setString("")
        Panel_legion_vic:removeBackGroundImage()
        Image_legion_me:setVisible(false)

        local info = nil
        local result = 0
        if i == 1 then
            info = left_info
            result = battle_result
        else
            info = right_info
            result = battle_result * -1
        end

        local sprite_icon = cc.Sprite:create(string.format("images/ui/union_logo/union_logo_%d.png", info.union_pic))
        sprite_icon:setPosition(cc.p(Panel_legion_logo_icon:getContentSize().width / 2, Panel_legion_logo_icon:getContentSize().height/2))
        Panel_legion_logo_icon:addChild(sprite_icon)
        
        if result == 0 then         -- 未分出胜负
        elseif result > 0 then           -- 胜利
            Panel_legion_vic:setBackGroundImage("images/ui/text/SMZB_res/46.png")
        else                        -- 失败
            display:gray(sprite_icon)
            Panel_legion_vic:setBackGroundImage("images/ui/text/SMZB_res/47.png")
        end

        if tonumber(info.union_id) == tonumber(_ED.union.union_info.union_id) then
            Image_legion_me:setVisible(true)
        else
            Image_legion_me:setVisible(false)
        end

        local count_infos = zstring.split(_ED.union.union_fight_duel_match_info.current_nums, ",")
        Text_legion_vs:setString("("..count_infos[i].."/"..info.join_num..")")
        Text_legion_name:setString("["..info.union_name.."]")

        if result < 0 then
            Text_legion_name:setColor(cc.c3b(tipStringInfo_property_change_color_Type[6][1], tipStringInfo_property_change_color_Type[6][2], tipStringInfo_property_change_color_Type[6][3]))
        else
            Text_legion_name:setColor(cc.c3b(tipStringInfo_property_change_color_Type[3][1], tipStringInfo_property_change_color_Type[3][2], tipStringInfo_property_change_color_Type[3][3]))
        end
    end

    local is_left = true
    if right_info.union_id == tonumber(_ED.union.union_info.union_id) then
        is_left = false
    end

    -- 战场信息
    for i = 1, 3 do
        local Text_ghz_infor_n = ccui.Helper:seekWidgetByName(root, "Text_ghz_infor_n_"..i)
        local current_num = 0
        local total_count = 0
        local current_num_info = zstring.split(_ED.union.union_fight_duel_match_info.battle_list[i].current_num_info, ",")
        if is_left == true then
            current_num = tonumber(current_num_info[1])
            total_count = left_info.join_num
        else
            current_num = tonumber(current_num_info[2])
            total_count = right_info.join_num
        end
        Text_ghz_infor_n:setString("("..current_num.."/"..total_count..")")
    end
end

function UnionFightingDuleInfo:onEnterTransitionFinish()

end

function UnionFightingDuleInfo:onInit( )
    local csbItem = csb.createNode(string.format(config_csb.union_fight.sm_legion_ghz_tab, 7))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    for i=1,3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ghz_zk_"..i), nil, 
        {
            terminal_name = "union_fighting_dule_info_change_dule_battle_count", 
            terminal_state = 0, 
            battle_count = i,
            isPressedActionEnabled = true
        }, nil, 1)

        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_ghz_infor_"..i), nil, 
        {
            terminal_name = "union_fighting_dule_info_change_dule_battle_count", 
            terminal_state = 0, 
            battle_count = i,
            isPressedActionEnabled = true
        }, nil, 1)
    end

    self:showCurrentBattleCount(1)
    state_machine.excute("union_fighting_dule_info_request_refresh", 0, nil)
end

function UnionFightingDuleInfo:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function UnionFightingDuleInfo:onExit()
    state_machine.remove("union_fighting_dule_info_update_info")
    state_machine.remove("union_fighting_dule_info_change_dule_battle_count")
    state_machine.remove("union_fighting_dule_info_request_refresh")
end
