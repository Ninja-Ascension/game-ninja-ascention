--------------------------------------
-- 个人居所排行榜信息项
--------------------------------------
PersonalFightRankingCell = class("PersonalFightRankingCellClass", Window)
PersonalFightRankingCell.__size = nil

local personal_fight_ranking_cell_create_terminal = {
    _name = "personal_fight_ranking_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = PersonalFightRankingCell:new()
        local rank_type = params[1]
        local rank_data = params[2]
        local rank_index = params[3]
        cell:init(rank_type, rank_data, rank_index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(personal_fight_ranking_cell_create_terminal)
state_machine.init()

function PersonalFightRankingCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._user_data = nil           --显示用户的数据
    self._rank_type = 0             --排行榜类型：1，全服，2：本服，3：帮派
    self._rank_index = 0

    local function init_personal_fight_ranking_cell_terminal()
        --查看玩家详细信息
        local personal_fight_ranking_cell_look_info_terminal = {
            _name = "personal_fight_ranking_cell_look_info",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _user_data = params._datas.user_data
                local _user_id = _user_data.user_id
                local _user_server_number = _user_data.user_server_number
                local _server_link = nil            -- 玩家服务器地址
                local _show_chat = true             -- 是否显示私聊按钮，只有本服玩家显示

                for k, server in pairs(_ED.all_def_servers) do
                    if server.server_number == _user_server_number then
                        _server_link = server.server_link
                        break
                    end
                end

                if _user_server_number ~= _ED.selected_server then
                    _show_chat = false
                end

                state_machine.excute("user_info_window_open",0,{_datas = {user_id = _user_id, server_link = _server_link, show_chat = _show_chat}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(personal_fight_ranking_cell_look_info_terminal)
        state_machine.init()
    end

    init_personal_fight_ranking_cell_terminal()
end

function PersonalFightRankingCell:init(rank_type, rank_data, rank_index)
    self._rank_type = rank_type
    self._user_data = rank_data
    self._rank_index = rank_index

    if rank_index ~= nil and rank_index < 9 then
        self:onInit()
    end

    self:setContentSize(PersonalFightRankingCell.__size)
end

function PersonalFightRankingCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.palyer_build.palyer_build_ranking_cell, "root")
    self:addChild(root)
    table.insert(self.roots, root)
    
    if PersonalFightRankingCell.__size == nil then
        PersonalFightRankingCell.__size = root:getContentSize()
    end

    -- 查看玩家详细信息
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_1"), nil, 
    {
        terminal_name = "personal_fight_ranking_cell_look_info", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        user_data = self._user_data,
    },
    nil,0)

    self:updateDraw()
end

function PersonalFightRankingCell:updateDraw()
    local root = self.roots[1]

    local Text_rank = ccui.Helper:seekWidgetByName(root, "Text_rank_n")             --名次
    local Text_rank_lv = ccui.Helper:seekWidgetByName(root, "Text_rank_lv_n")       --等级
    local Text_rank_name = ccui.Helper:seekWidgetByName(root, "Text_rank_n_0")    --玩家名
    local Text_rank_score = ccui.Helper:seekWidgetByName(root, "Text_rank_n_0_0")   --积分

    Text_rank:setString(self._user_data.user_rank)
    Text_rank_lv:setString(self._user_data.user_level)
    Text_rank_score:setString(self._user_data.user_score)

    -- 服务器编号
    local server_number = 0
    local server_info = _ED.all_servers[""..self._user_data.user_server_number]
    if server_info ~= nil and server_info.server_code ~= nil and tonumber(server_info.server_code) ~= nil then
        server_number = server_info.server_code
    end
    local server_flag = ""
        if server_info ~= nil and server_info.server_flag ~= nil then
            server_flag = server_info.server_flag
        end
    -- if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
    --     if server_info ~= nil and server_info.server_code ~= nil then
    --         Text_rank_name:setString(self._user_data.user_name.."("..server_info.server_code..")")
    --     else
    --         Text_rank_name:setString(self._user_data.user_name)
    --     end
    -- else
    --     Text_rank_name:setString(string.format(red_alert_all_str[239], self._user_data.user_name, server_number))
    -- end
    Text_rank_name:setString(string.format(red_alert_all_str[239], self._user_data.user_name, server_flag, server_number))

    local Image_rank_lv = {}        --不同名次显示的图片
    for i = 1, 4 do
        Image_rank_lv[""..i] = ccui.Helper:seekWidgetByName(root, "Image_rank_lv_"..i)
        Image_rank_lv[""..i]:setVisible(false)
    end

    if tonumber(self._user_data.user_rank) <= 3 then
        Image_rank_lv[""..self._user_data.user_rank]:setVisible(true)
    else
        Image_rank_lv["4"]:setVisible(true)
    end

end

function PersonalFightRankingCell:onExit()
    cacher.freeRef(config_csb.cells.palyer_build.palyer_build_ranking_cell, self.roots[1])
end

function PersonalFightRankingCell:onEnterTransitionFinish()

end

function PersonalFightRankingCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function PersonalFightRankingCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.palyer_build.palyer_build_ranking_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end