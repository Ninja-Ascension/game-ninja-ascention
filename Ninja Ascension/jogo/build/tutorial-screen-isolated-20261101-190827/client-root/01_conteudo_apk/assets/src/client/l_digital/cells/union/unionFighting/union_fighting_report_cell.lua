-- ------------------------------------------------------------------------------------------------------------
--  工会战战报cell
-- ------------------------------------------------------------------------------------------------------------
UnionFightingReportCell = class("UnionFightingReportCellClass", Window)
UnionFightingReportCell.__size = nil

--创建cell
local union_fighting_report_cell_create_terminal = {
    _name = "union_fighting_report_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = UnionFightingReportCell:new()
        local index = params[1]
        local info = params[2]
        local count = params[3]
        cell:init(index, info, count)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_fighting_report_cell_create_terminal)
state_machine.init()

function UnionFightingReportCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._info_data = nil
    self._index = 0
    self._count = false

    self._left_info = 0
    self._right_info = 0

    local function init_union_fighting_report_cell_terminal()
        local union_fighting_report_cell_enter_fight_terminal = {
            _name = "union_fighting_report_cell_enter_fight",
            _init = function (terminal)
                app.load("client.battle.BattleStartEffect")
                app.load("client.battle.fight.FightEnum")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local info = zstring.split(cell._info_data, "@")
                local reportId = zstring.split(info[1], ",")[2]
                local userId = zstring.split(info[2], ",")[1]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            -- _ED.battle_playback_arena.playback = true
                            -- _ED.battle_playback_arena.nType = _enum_fight_type._fight_type_213
                            -- _ED.battle_playback_arena.time = 0
                            _ED.battle_playback_213_info = response.node._info_data
                            fwin:cleanView(fwin._windows)
                            fwin:freeAllMemeryPool()
                            local bse = BattleStartEffect:new()
                            bse:init(_enum_fight_type._fight_type_213)
                            fwin:open(bse, fwin._windows)
                        end 
                    end
                end
                protocol_command.battlefield_report_battle_info_get.param_list = "10007".."\r\n"..reportId.."\r\n"..userId
                NetworkManager:register(protocol_command.battlefield_report_battle_info_get.code, nil, nil, nil, cell, responseCallback, true, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_report_cell_look_infor_terminal = {
            _name = "union_fighting_report_cell_look_infor",
            _init = function (terminal)
                app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local m_type = params._datas.m_type
                local user_info = nil
                if m_type == 1 then
                    user_info = cell._left_info
                else
                    user_info = cell._right_info
                end
                local function responseShowUserInfoCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            local datainfo = {}
                            datainfo.user_id = user_info[1]
                            datainfo.icon = user_info[4]
                            datainfo.name = user_info[2]
                            datainfo.level = _ED.chat_user_info.grade
                            datainfo.rank = -1
                            datainfo.force = _ED.chat_user_info.fighting
                            datainfo.vip = _ED.chat_user_info.vip_grade
                            datainfo.template = {}
                            datainfo.template[1] = _ED.chat_user_info.formation
                            if _ED.chat_user_info.army == "" then
                                datainfo.arame = "?"
                            else
                                datainfo.arame = _ED.chat_user_info.army
                            end
                            state_machine.excute("sm_arena_player_info_window_open",0,datainfo)
                        end
                    end
                end
                protocol_command.see_user_info.param_list = user_info[1]
                NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, cell, responseShowUserInfoCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fighting_report_cell_enter_fight_terminal)
        state_machine.add(union_fighting_report_cell_look_infor_terminal)
    end
    
    init_union_fighting_report_cell_terminal()
end

function UnionFightingReportCell:updateUserInfo(index, info, result)
    local root = self.roots[1]

    local Panel_vs = ccui.Helper:seekWidgetByName(root, "Panel_vs_"..index)
    local Text_ls_n = ccui.Helper:seekWidgetByName(root, "Text_ls_n_"..index)
    local Sprite_role_icon_bg = Panel_vs:getChildByName("Sprite_role_icon_bg_"..index)
    local Sprite_role_icon = Panel_vs:getChildByName("Sprite_role_icon_"..index)
    local Panel_ghz_js_t = ccui.Helper:seekWidgetByName(root, "Panel_ghz_js_t_"..index)
    local Text_role_n = ccui.Helper:seekWidgetByName(root, "Text_role_n_"..index)
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name_"..index)
    local Text_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_name_"..index)
    local LoadingBar_hp = ccui.Helper:seekWidgetByName(root, "LoadingBar_hp_"..index)
    local Text_gh_dw_n = ccui.Helper:seekWidgetByName(root, "Text_gh_dw_n_"..index)

    if tonumber(result) == 1 then       -- 胜利
        display:ungray(Sprite_role_icon_bg)
        display:ungray(Sprite_role_icon)
        Text_ls_n:setString(string.format(_new_interface_text[216], tonumber(info[9])))
        Panel_ghz_js_t:setBackGroundImage("images/ui/text/SMZB_res/46.png")
    else        -- 失败
        display:gray(Sprite_role_icon_bg)
        display:gray(Sprite_role_icon)
        Text_ls_n:setString("")
        Panel_ghz_js_t:setBackGroundImage("images/ui/text/SMZB_res/47.png")
    end

    local function getHeadPicPath(pic_index)
        local icon_path = ""
        if tonumber(pic_index) < 9 then
            icon_path = string.format("images/ui/home/head_%d.png", tonumber(pic_index))
        else
            icon_path = string.format("images/ui/props/props_%d.png", tonumber(pic_index))
        end
        return icon_path
    end

    Text_role_n:setString(info[5])
    Sprite_role_icon:setTexture(getHeadPicPath(info[4]))
    Text_player_name:setString(info[2])
    Text_legion_name:setString(info[3])
    if tonumber(result) == 0 then
        LoadingBar_hp:setPercent(0)
    else
        LoadingBar_hp:setPercent(math.ceil(tonumber(info[7]) * 100/tonumber(info[8])))
    end
    Text_gh_dw_n:setString(tipStringInfo_union_str[88]..info[6])
end

function UnionFightingReportCell:updateDraw()
    local root = self.roots[1]
    local Text_ghz_zk_c_n = ccui.Helper:seekWidgetByName(root, "Text_ghz_zk_c_n")
    local Panel_vs_me = ccui.Helper:seekWidgetByName(root, "Panel_vs_me")

-- 胜负,战报id@id,昵称,公会名,头像,等级,队伍,当前血量,最大血量,连胜数@昵称,公会名,头像,等级,队伍,当前血量,最大血量,连胜数|
    local info = zstring.split(self._info_data, "@")
    local result = zstring.split(info[1], ",")[1]
    local leftInfo = zstring.split(info[2], ",")
    local rightInfo = zstring.split(info[3], ",")

    Text_ghz_zk_c_n:setString(string.format(tipStringInfo_union_str[85], self._count))
    Panel_vs_me:removeAllChildren(true)
    Panel_vs_me:setVisible(true)
    if tonumber(leftInfo[1]) == tonumber(_ED.user_info.user_id)
        or tonumber(rightInfo[1]) == tonumber(_ED.user_info.user_id)
        then
        local jsonFile = "images/ui/effice/effect_ghz_list/effect_ghz_list.json"
        local atlasFile = "images/ui/effice/effect_ghz_list/effect_ghz_list.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_vs_me:addChild(animation)
        -- draw.createEffect("effect_ghz_list", "images/ui/effice/effect_ghz_list/effect_ghz_list.ExportJson", Panel_vs_me)
    end

    if leftInfo[3] == _ED.union.union_info.union_name then
        if tonumber(result) == 1 then
            self:updateUserInfo(1, leftInfo, 1)
            self:updateUserInfo(2, rightInfo, 0)
        else
            self:updateUserInfo(1, leftInfo, 0)
            self:updateUserInfo(2, rightInfo, 1)
        end
        self._left_info = leftInfo
        self._right_info = rightInfo
    else
        if tonumber(result) == 1 then
            self:updateUserInfo(1, rightInfo, 0)
            self:updateUserInfo(2, leftInfo, 1)
        else
            self:updateUserInfo(1, rightInfo, 1)
            self:updateUserInfo(2, leftInfo, 0)
        end
        self._left_info = rightInfo
        self._right_info = leftInfo
    end
end


function UnionFightingReportCell:onInit(isNewReport)
    local root = cacher.createUIRef(string.format(config_csb.union_fight.sm_legion_ghz_tab_4_cell, 3), "root")
    table.insert(self.roots, root)
    self:addChild(root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_vs_chakan"), nil, 
    {
        terminal_name = "union_fighting_report_cell_enter_fight", 
        terminal_state = 0,
        cell = self,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_role_icon_xy_1"), nil, 
    {
        terminal_name = "union_fighting_report_cell_look_infor", 
        terminal_state = 0,
        cell = self,
        m_type = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_role_icon_xy_2"), nil, 
    {
        terminal_name = "union_fighting_report_cell_look_infor", 
        terminal_state = 0,
        cell = self,
        m_type = 2,
    }, nil, 1)

    self:updateDraw()

    if UnionFightingReportCell.__size == nil then
        UnionFightingReportCell.__size = root:getContentSize()
    end
end

function UnionFightingReportCell:onEnterTransitionFinish()

end

function UnionFightingReportCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function UnionFightingReportCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_tab_4_cell, 3), root)
    root:removeFromParent(false)
    self.roots = {}
    self.actions = {}
end

function UnionFightingReportCell:clearUIInfo( ... )
    if true then
        return
    end
    local root = self.roots[1]
    local Text_ghz_zk_c_n = ccui.Helper:seekWidgetByName(root, "Text_ghz_zk_c_n")
    local Panel_vs_me = ccui.Helper:seekWidgetByName(root, "Panel_vs_me")
    local Panel_vs_1 = ccui.Helper:seekWidgetByName(root, "Panel_vs_1")
    local Text_ls_n_1 = ccui.Helper:seekWidgetByName(root, "Text_ls_n_1")
    local Sprite_role_icon_bg_1 = Panel_vs_1:getChildByName("Sprite_role_icon_bg_1")
    local Sprite_role_icon_1 = Panel_vs_1:getChildByName("Sprite_role_icon_1")
    local Panel_ghz_js_t_1 = ccui.Helper:seekWidgetByName(root, "Panel_ghz_js_t_1")
    local Text_role_n_1 = ccui.Helper:seekWidgetByName(root, "Text_role_n_1")
    local Text_player_name_1 = ccui.Helper:seekWidgetByName(root, "Text_player_name_1")
    local Text_legion_name_1 = ccui.Helper:seekWidgetByName(root, "Text_legion_name_1")
    local LoadingBar_hp_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_hp_1")
    local Text_gh_dw_n_1 = ccui.Helper:seekWidgetByName(root, "Text_gh_dw_n_1")
    local Panel_vs_2 = ccui.Helper:seekWidgetByName(root, "Panel_vs_2")
    local Text_ls_n_2 = ccui.Helper:seekWidgetByName(root, "Text_ls_n_2")
    local Sprite_role_icon_bg_2 = Panel_vs_2:getChildByName("Sprite_role_icon_bg_2")
    local Sprite_role_icon_2 = Panel_vs_2:getChildByName("Sprite_role_icon_2")
    local Panel_ghz_js_t_2 = ccui.Helper:seekWidgetByName(root, "Panel_ghz_js_t_2")
    local Text_role_n_2 = ccui.Helper:seekWidgetByName(root, "Text_role_n_2")
    local Text_player_name_2 = ccui.Helper:seekWidgetByName(root, "Text_player_name_2")
    local Text_legion_name_2 = ccui.Helper:seekWidgetByName(root, "Text_legion_name_2")
    local LoadingBar_hp_2 = ccui.Helper:seekWidgetByName(root, "LoadingBar_hp_2")
    local Text_gh_dw_n_2 = ccui.Helper:seekWidgetByName(root, "Text_gh_dw_n_2")
    if Text_ghz_zk_c_n ~= nil then
        Panel_vs_me:removeAllChildren(true)
        Text_ls_n_1:setString("")
        display:ungray(Sprite_role_icon_bg_1)
        display:ungray(Sprite_role_icon_1)
        Panel_ghz_js_t_1:removeBackGroundImage()
        Text_role_n_1:setString("")
        Text_player_name_1:setString("")
        Text_legion_name_1:setString("")
        LoadingBar_hp_1:setPrecent(0)
        Text_gh_dw_n_1:setString("")
        Text_ls_n_2:setString("")
        display:ungray(Sprite_role_icon_bg_2)
        display:ungray(Sprite_role_icon_2)
        Panel_ghz_js_t_2:removeBackGroundImage()
        Text_role_n_2:setString("")
        Text_player_name_2:setString("")
        Text_legion_name_2:setString("")
        LoadingBar_hp_2:setPrecent(0)
        Text_gh_dw_n_2:setString("")
    end
end

function UnionFightingReportCell:init(index, info, count)
    self._index = index 
    self._info_data = info
    self._count = count
    if index ~= nil and index <= 6 then
        self:onInit()
    end
    self:setContentSize(UnionFightingReportCell.__size)
    return self
end

function UnionFightingReportCell:onExit()
    self:clearUIInfo()
    local root = self.roots[1]
    cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_tab_4_cell, 3), root)
end

