-- ---------------------------
-- 工会战-决赛赛场战况
-- ---------------------------
UnionFightingDule = class("UnionFightingDuleClass", Window)

local union_fighting_dule_window_open_terminal = {
    _name = "union_fighting_dule_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("UnionFightingDuleClass") == nil then
            local panel = UnionFightingDule:new():init(params)
            fwin:open(panel)
            return panel
        end
        return nil
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fighting_dule_window_open_terminal)
state_machine.init()

function UnionFightingDule:ctor()
    self.super:ctor()
    self.roots = {}

    self._battle_type = 0       -- 当前赛次
    self._need_update_state = false

    local function init_union_fighting_dule_terminal()
        -- 刷新界面
        local union_fighting_dule_update_draw_terminal = {
            _name = "union_fighting_dule_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance._need_update_state = true
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local union_fighting_dule_show_terminal = {
            _name = "union_fighting_dule_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local union_fighting_dule_hide_terminal = {
            _name = "union_fighting_dule_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        state_machine.add(union_fighting_dule_update_draw_terminal)
        state_machine.add(union_fighting_dule_show_terminal)
        state_machine.add(union_fighting_dule_hide_terminal)
        state_machine.init()
    end
    init_union_fighting_dule_terminal()
end

function UnionFightingDule:updateUnionInfo(index, info, result)
    local root = self.roots[1]

    local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head_"..index)
    local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_"..index)
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name_"..index)
    local Image_lose = ccui.Helper:seekWidgetByName(root, "Image_lose_"..index)
    local Image_win = ccui.Helper:seekWidgetByName(root, "Image_win_"..index)
    local Image_player_me = ccui.Helper:seekWidgetByName(root, "Image_player_me_"..index)
    local Text_player_vs_n = ccui.Helper:seekWidgetByName(root, "Text_player_vs_n_"..index)
    local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_"..index)
    Panel_digimon_icon:removeBackGroundImage()
    Panel_digimon_icon:removeAllChildren(true)
    Text_player_name:setString("")
    Image_player_me:setVisible(false)
    Text_player_vs_n:setString("")
    if Image_lose ~= nil then
        Image_lose:setVisible(false)
    end
    if Image_win ~= nil then
        Image_win:setVisible(false)
    end
    if info == nil then
        if (index == 9 or index == 10) and self._battle_type == 2 
            or (index == 11) and self._battle_type == 3
            then
            Panel_head:setVisible(true)
            Panel_digimon_icon:setBackGroundImage("images/ui/text/GHZ_res/legion_icon_bg.png")
        else
            Panel_head:setVisible(false)
        end 
        return
    end
    Panel_head:setVisible(true)

    local sprite_icon = cc.Sprite:create(string.format("images/ui/union_logo/union_logo_%d.png", info.union_pic))
    sprite_icon:setPosition(cc.p(Panel_digimon_icon:getContentSize().width / 2, Panel_digimon_icon:getContentSize().height/2))
    Panel_digimon_icon:addChild(sprite_icon)
    if result < 0 then
        display:gray(sprite_icon)
    end
    
    if Image_lose ~= nil and result < 0 then
        Image_lose:setVisible(true)
    end
    if Image_win ~= nil and result > 0 then
        Image_win:setVisible(true)
    end

    if tonumber(info.union_id) == tonumber(_ED.union.union_info.union_id) then
        Image_player_me:setVisible(true)
    else
        Image_player_me:setVisible(false)
    end

    Text_player_vs_n:setString("("..info.current_num.."/"..info.join_num..")")
    Text_player_name:setString(info.union_name)

    if result < 0 then
        Text_player_vs_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    else
        Text_player_vs_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end
end

function UnionFightingDule:updateUnionVsInfo(index, left_info, right_info)
    local root = self.roots[1]
    local Panel_vs = ccui.Helper:seekWidgetByName(root, "Panel_vs_"..index)
    local Text_vs_n = ccui.Helper:seekWidgetByName(root, "Text_vs_n_"..index)
    local Image_line_win_1 = ccui.Helper:seekWidgetByName(root, "Image_line_win_"..(index * 2 - 1))
    local Image_line_win_2 = ccui.Helper:seekWidgetByName(root, "Image_line_win_"..(index * 2))
    Image_line_win_1:setVisible(false)
    Image_line_win_2:setVisible(false)
    if left_info == nil and right_info == nil then
        Panel_vs:setVisible(false)
        return 0, 0
    end
    Panel_vs:setVisible(true)

    local left_win_times = 0
    local right_win_times = 0

    if left_info ~= nil then
        left_win_times = left_info.win_times
    end
    if right_info ~= nil then
        right_win_times = right_info.win_times
    end

    local left_result = 0            -- 0：未分出胜负，1：左胜利，-1：右胜利
    local right_result = 0
    Text_vs_n:setString(""..left_win_times..":"..right_win_times)
    if tonumber(left_win_times) > tonumber(right_win_times) then
        Image_line_win_1:setVisible(true)
        left_result = 1
        right_result = -1
    elseif tonumber(left_win_times) < tonumber(right_win_times) then
        Image_line_win_2:setVisible(true)
        left_result = -1
        right_result = 1
    elseif tonumber(left_win_times) == 0 and tonumber(right_win_times) == 0 then
        Panel_vs:setVisible(false)
    end
    return left_result, right_result
end

function UnionFightingDule:updateDraw()
    local root = self.roots[1]
    if self._need_update_state ~= true then
        return
    end

    if _ED.union.union_fight_duel_info == nil then
        return
    end

    self._need_update_state = false
    local next_begin_time = 0
    for i = 1, 3 do
        next_begin_time = _ED.union.union_fight_duel_info.next_begin_time
    end
    self._battle_type = 1         -- 下一场赛次

    -- 初始化
    for i = 1, 11 do
        self:updateUnionInfo(i, nil, 0)
    end
    for i = 1, 7 do
        self:updateUnionVsInfo(i, nil, nil)
    end

    -- 四强赛
    local battle_info = _ED.union.union_fight_duel_info.battle_info["0"]
    if battle_info ~= nil then
        self._battle_type =  1
        for i = 1, 4 do
            local left_index = i * 2 - 1
            local right_index = i * 2
            local left_info = battle_info[""..left_index]
            local right_info = battle_info[""..right_index]
            local left_result, right_result = self:updateUnionVsInfo(i, left_info, right_info)

            self:updateUnionInfo(left_index, left_info, left_result)
            self:updateUnionInfo(right_index, right_info, right_result)

            -- 四强赛结束
            if left_result ~= 0 then
                self._battle_type = 2
                self:updateUnionInfo(9, nil, 0)
                self:updateUnionInfo(10, nil, 0)
            end
        end
    end

    -- 半决赛
    local battle_info = _ED.union.union_fight_duel_info.battle_info["1"]
    if battle_info ~= nil then
        self._battle_type =  2
        for i = 5, 6 do
            local left_index = 0
            local right_index = 0
            for k, v in pairs(battle_info) do
                if v.position == i + 4 then
                    if tonumber(k) <= 4 then
                        left_index = tonumber(k)
                    elseif tonumber(k) <= 8 then
                        right_index = tonumber(k)
                    end
                end
            end
            local left_info = battle_info[""..left_index]
            local right_info = battle_info[""..right_index]
            local left_result, right_result = self:updateUnionVsInfo(i, left_info, right_info)
            local win_info = nil
            if left_result > 0 then
                win_info = left_info
            elseif right_result > 0 then
                win_info = right_info
            end

            if win_info ~= nil then
                self:updateUnionInfo(i + 4, win_info, 1)
                self._battle_type =  3
                self:updateUnionInfo(11, nil, 0)
            end
        end
    end

    -- 决赛
    local fight_end = false
    local battle_info = _ED.union.union_fight_duel_info.battle_info["2"]
    if battle_info ~= nil then
        self._battle_type =  3
        local left_index = 9
        local right_index = 10
        local win_index = 11
        local left_info = battle_info[""..left_index]
        local right_info = battle_info[""..right_index]
        local win_info = nil
        if left_info == nil then
            win_info = battle_info[""..win_index]
            left_info = win_info
        elseif right_info == nil then
            win_info = battle_info[""..win_index]
            right_info = win_info
        end

        local left_result, right_result = self:updateUnionVsInfo(7, left_info, right_info)
        local win_info = nil
        if left_result > 0 then
            win_info = left_info
        elseif right_result > 0 then
            win_info = right_info
        end

        if win_info ~= nil then
            self:updateUnionInfo(11, win_info, 0)
            fight_end = true            -- 公会战结束
        end
    end

    -- 当前赛次
    self._AtlasLabel_djs_m = nil
    self._AtlasLabel_djs_s = nil
    self._tick_time = 0

    local Panel_dfdj_cc = ccui.Helper:seekWidgetByName(root, "Panel_dfdj_cc")
    local AtlasLabel_djs_m = ccui.Helper:seekWidgetByName(root, "AtlasLabel_djs_m")
    local AtlasLabel_djs_s = ccui.Helper:seekWidgetByName(root, "AtlasLabel_djs_s")
    local Image_mh = ccui.Helper:seekWidgetByName(root, "Image_mh")
    local Image_djs_bg = ccui.Helper:seekWidgetByName(root, "Image_djs_bg")
    Panel_dfdj_cc:removeBackGroundImage()
    Panel_dfdj_cc:setBackGroundImage(string.format("images/ui/text/GHZ_res/ghz_%d.png", _ED.union.union_fight_duel_info.current_battle_type + 116))
    if fight_end == true then
        AtlasLabel_djs_m:setVisible(false)
        AtlasLabel_djs_s:setVisible(false)
        Image_mh:setVisible(false)
        Image_djs_bg:setVisible(false)
    else
        AtlasLabel_djs_m:setVisible(true)
        AtlasLabel_djs_s:setVisible(true)
        Image_mh:setVisible(true)
        Image_djs_bg:setVisible(true)

        self._AtlasLabel_djs_m = AtlasLabel_djs_m
        self._AtlasLabel_djs_s = AtlasLabel_djs_s
        self._tick_time = next_begin_time - (os.time() + _ED.time_add_or_sub)
        if self._tick_time <= 0 then
            self._tick_time = 0
        end
        self._AtlasLabel_djs_m:setString(string.format("%02d", math.floor(self._tick_time / 60)))
        self._AtlasLabel_djs_s:setString(string.format("%02d", math.floor(self._tick_time % 60)))
    end
end

function UnionFightingDule:onUpdate(dt)
    if self._AtlasLabel_djs_m ~= nil and self._AtlasLabel_djs_s ~= nil then
        self._tick_time = self._tick_time - dt
        if self._tick_time <= 0 then
            self._tick_time = 0
            self:updateDraw()
        else
            self._AtlasLabel_djs_m:setString(string.format("%02d", math.floor(self._tick_time / 60)))
            self._AtlasLabel_djs_s:setString(string.format("%02d", math.floor(self._tick_time % 60)))
        end
    end
end

function UnionFightingDule:onEnterTransitionFinish()

end

function UnionFightingDule:onInit( )
    local csbItem = csb.createNode(string.format(config_csb.union_fight.sm_legion_ghz_tab, 6))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    for i = 1, 7 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chakan_"..i), nil, 
        {
            terminal_name = "union_fight_report_window_open", 
            terminal_state = 0,
            isPressedActionEnabled = true,
            battle_type = 2,
            position = i, 
        }, 
        nil, 0)
    end

    self._need_update_state = true
    self:updateDraw()
end

function UnionFightingDule:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function UnionFightingDule:onExit()
    state_machine.remove("union_fighting_dule_update_draw")
    state_machine.remove("union_fighting_dule_show")
    state_machine.remove("union_fighting_dule_hide")
end
