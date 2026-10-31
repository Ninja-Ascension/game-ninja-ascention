------------------------------------
-- 主页面建筑图标
------------------------------------
HomeBuildCell = class("HomeBuildCellClass", Window)

local home_build_cell_create_terminal = {
    _name = "home_build_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local build_id = params[1]
        local build_info = params[2]
        local panel = params[3]
        local cell = HomeBuildCell:new()
        cell:init(build_id,build_info,panel)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(home_build_cell_create_terminal)
state_machine.init()

function HomeBuildCell:ctor()
    self.super:ctor()
    self.roots = {}

    self.__cdt = 1

    self.build_id = nil
    self.base_build_info = nil
    self.actions = {}

    self.update_image = nil
    self.loading_bar = nil
    self.text_time = nil

    self.update_panel = nil
    self.loading_bar = nil
    self.text_time = nil
    self.last_time = nil

    self.production_max_time = nil            -- 有生产时的生产总时间    
    self.production_start_time = nil          -- 有生产时的生产开始时间  
    self.production_last_time = nil  
    self.production_id = nil

    self._build_armature = nil

    self._need_check_build_level_up = true      -- 是否可升级状态
    self._need_check_build_produce_up = true    -- 是否可生产状态

    self._is_play_effect = true
    self._last_pve_receive = -1
    self._have_free_time = false

    self._last_update_state = 0

    self._free_time = 0             -- 可免费升级时间
    self._build_up_state = 0        -- 0：未升级，1：升级中，2：免费升级

    self._show_tables = nil
    self._campaign_text_times = nil

    local function init_home_build_cell_terminal()
        local home_build_cell_open_window_terminal = {
            _name = "home_build_cell_open_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local build_id = tonumber(cell.build_id)

                if nil == cell.base_build_info then
                    cell.base_build_info = _ED.base_build_info[""..cell.build_mould_id]
                end

                if funOpenDrawTip(cell.base_build_info.fun_open_tab_id) == true then
                    return
                end

                if build_id == 1 then -- 司令部
                    state_machine.excute("build_up_headquarters_window_open",0,{cell.build_id})
                elseif build_id == 2 then -- 军团
                    state_machine.excute("legion_window_open",0,"")

                elseif build_id == 3 then -- 科技中心
                    state_machine.excute("build_up_scientific_window_open",0,{cell.build_id,cell.base_build_info})
				elseif build_id == 4 then -- 战地争霸
					state_machine.excute("arena_window_open",0,"")
                elseif build_id == 5 then
                    state_machine.excute("campaign_window_open", 0, nil)
                elseif build_id == 6 then -- 配件车间
                    state_machine.excute("equipment_window_open",0,"")

                elseif build_id == 7 then -- 将领学堂
                    state_machine.excute("leader_school_window_open",0,nil)

                elseif build_id == 8 then -- 制造工厂
                    state_machine.excute("build_up_make_factory_window_open",0,{cell.build_id,cell.base_build_info})

                elseif build_id == 9
                    or build_id == 10 then -- 坦克工厂
                    state_machine.excute("build_up_tank_factory_window_open",0,{cell.build_id,cell.base_build_info})

                elseif build_id == 11 then -- 改造工厂
                    state_machine.excute("build_up_reform_factory_window_open",0,{cell.build_id,cell.base_build_info})

                elseif build_id == 12 then -- 坦克仓库
                    if __lua_project_id == __lua_project_pacific_rim then
                        state_machine.excute("build_up_tank_warehouse_ex_window_open",0,"")
                    else
                        state_machine.excute("build_up_tank_warehouse_window_open",0,"")
                    end

                elseif build_id >= 13 
                    and build_id <= 24 
                    then -- 仓库、宝石、钛矿
                    state_machine.excute("build_up_res_window_open",0,{cell.build_id,cell.base_build_info})

                elseif build_id >= 25 
                    and build_id <= 53 
                    then -- 空田    
                    if build_id ~= cell.base_build_info.id then
                        state_machine.excute("build_up_res_window_open",0,{cell.build_id,cell.base_build_info})
                    else
                        state_machine.excute("build_up_res_build_window_open",0,{cell.build_id,cell.base_build_info})
                    end
                elseif build_id == 54 then
                    state_machine.excute("armor_window_open",0,"")
                elseif build_id == 55 then
                    state_machine.excute("rank_window_open",0,{_datas = {list_type = 1}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新生产状态
        local home_build_cell_update_production_terminal = {
            _name = "home_build_cell_update_production",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= nil then
                    local cell = params[1]
                    if cell ~= nil then
                        cell:updateInProductionInfo()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新将领学堂、战地争霸状态
        local home_build_cell_update_leader_info_terminal = {
            _name = "home_build_cell_update_leader_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                if cell ~= nil then
                    cell:pushLeaderBuildInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 刷新作战中心状态
        local home_build_cell_update_campaign_info_terminal = {
            _name = "home_build_cell_update_campaign_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                if cell ~= nil then
                    cell:updateCampaignInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 免费升级
        local home_build_cell_free_build_up_terminal = {
            _name = "home_build_cell_free_build_up",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell ~= nil then
                    state_machine.excute("home_map_free_build_up", 0, {cell.build_id})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 作战中心
        local home_build_cell_open_campaign_window_terminal = {
            _name = "home_build_cell_open_campaign_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local index = params._datas.index
                if cell ~= nil then
                    if cell._show_tables ~= nil and cell._show_tables[index] ~= nil then
                        local page = cell._show_tables[index].list_type + 1
                        state_machine.excute("campaign_window_open", 0, {_datas = {_page = page}})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 排行榜
        local home_build_cell_update_rank_info_terminal = {
            _name = "home_build_cell_update_rank_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                if cell ~= nil then
                    cell:updateRankInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(home_build_cell_open_window_terminal)
        state_machine.add(home_build_cell_update_production_terminal)
        state_machine.add(home_build_cell_update_leader_info_terminal)
        state_machine.add(home_build_cell_update_campaign_info_terminal)
        state_machine.add(home_build_cell_free_build_up_terminal)
        state_machine.add(home_build_cell_open_campaign_window_terminal)
        state_machine.add(home_build_cell_update_rank_info_terminal)
        state_machine.init()
    end

    init_home_build_cell_terminal()
end

-- 排行榜信息
function HomeBuildCell:updateRankInfo()
    local root = self.roots[1]
    if root == nil 
        or tonumber(self.build_id) ~= 55
        then
        return
    end

    local top_name = red_alert_all_str[251]
    if _ED.mould_function_push_info["17"] ~= nil then
        if _ED.mould_function_push_info["17"].params ~= "-1" then
            top_name = _ED.mould_function_push_info["17"].params
        end
    end

    local Text_rank_top_name = ccui.Helper:seekWidgetByName(root,"Text_rank_top_name")
    Text_rank_top_name:setString(top_name)
end

function HomeBuildCell:updateCampaignInfoEx()
    local root = self.roots[1]

    if tonumber(self.build_id) ~= 5 then
        for i = 1, 2 do
            local Panel = ccui.Helper:seekWidgetByName(root,"Panel_"..i)
            Panel:setVisible(false)
        end
        return
    end

    local current_time = _ED.system_time + (os.time() - _ED.native_time)
    local server_time = os.date("*t", zstring.tonumber(current_time) - _ED.GTM_Time)

    local campaign_tables = {}
    local campaign_ids = {3, 4, 5, 7, 8, 9}
    local pic_tables = {3, 2, 1, 4, 5, 6}
    for k, id in pairs(campaign_ids) do
        local info = {
            list_type = 0,
            index = 0,
            pic = 0,
            state = 0,
            end_time = 0,
            des = "",
        }
        info.list_type = dms.int(dms["fight_center_list"], id, fight_center_list.list_type)
        info.index = k
        info.pic = pic_tables[k]
        if k == 1 then      -- 学霸之战
            if _ED.mould_function_push_info["3"] ~= nil then
                state = _ED.mould_function_push_info["3"].state
            end
            if tonumber(state) == 0 then
                local open_time = dms.string(dms["answer_config"], 1, answer_config.param)
                open_time = zstring.split(open_time, ":")

                local tick_time = (open_time[1] - server_time.hour + 24) * 3600 + (open_time[2] - server_time.min) * 60 + (open_time[3] - server_time.sec)
                if tick_time < 0 then
                    tick_time = tick_time + 24 * 3600
                end
                info.state = 0
                info.end_time = tick_time + current_time
                info.des = limit_dekaron_tip_daily[3]
            else
                info.state = 1
                info.des = tipString_info_project_pacific_rim[15]
            end
        elseif k == 2 then      -- 敌军来袭
            local push_info = _ED.mould_function_push_info["4"]
            if push_info ~= nil then
                info.state = tonumber(push_info.state)
                info.end_time = tonumber(push_info.params) / 1000 + push_info.start_time
            end
            if info.state == 0 then
                info.des = limit_dekaron_tip_daily[12]
            else
                info.des = tipString_info_project_pacific_rim[15]
            end
        elseif k == 3 then      -- 叛军出没
            local open_time = dms.string(dms["rebel_haunt_config"], 1, rebel_haunt_config.param)
            local continue_time = dms.int(dms["rebel_haunt_config"], 2, rebel_haunt_config.param)
            open_time = zstring.split(open_time, ",")
            local open_time_one = zstring.split(open_time[1], ":")
            local open_time_two = zstring.split(open_time[2], ":")
            if _ED.mould_function_push_info["5"] ~= nil then
                state = _ED.mould_function_push_info["5"].state
            end
            if tonumber(state) == 0 then
                info.des = limit_dekaron_tip_daily[13]
                info.state = 0
                local tick_time = 0
                if server_time.hour < tonumber(open_time_one[1]) then
                    tick_time = (open_time_one[1] - server_time.hour) * 3600 + (open_time_one[2] - server_time.min) * 60 - server_time.sec
                elseif server_time.hour < tonumber(open_time_two[1]) then
                    tick_time = (open_time_two[1] - server_time.hour) * 3600 + (open_time_two[2] - server_time.min) * 60 - server_time.sec
                else
                    tick_time = (24 + open_time_one[1] - server_time.hour) * 3600 + (open_time_one[2] - server_time.min) * 60 - server_time.sec
                end
                info.end_time = tick_time + current_time
            else
                info.des = tipString_info_project_pacific_rim[15]
                info.state = 1
                local tick_time = 0
                if server_time.hour < tonumber(open_time_one[1]) + continue_time/3600 then
                    tick_time = (continue_time/3600) - (open_time_one[1] - server_time.hour) * 3600 + (open_time_one[2] - server_time.min) * 60 - server_time.sec
                elseif server_time.hour < tonumber(open_time_two[1]) + continue_time/3600 then
                    tick_time = (continue_time/3600) - (open_time_two[1] - server_time.hour) * 3600 + (open_time_two[2] - server_time.min) * 60 - server_time.sec + continue_time
                else
                    tick_time = (24 - server_time.hour + open_time_one[1] + (continue_time/3600)) * 3600 + (open_time_one[2] - server_time.min) * 60 - server_time.sec + continue_time
                end
                info.end_time = tick_time + current_time
            end
        elseif k == 4 then      -- 军团争霸
            local push_info = _ED.mould_function_push_info["9"]
            if push_info ~= nil then
                info.state = tonumber(push_info.state)
                info.end_time = tonumber(push_info.params) / 1000 + push_info.start_time
            end
            if info.state == 3 then
                info.des = tipString_info_project_pacific_rim[15]
            elseif info.state == 2 then
                info.des = tipString_info_project_pacific_rim[14]
            elseif info.state == 1 then
                info.des = tipString_info_project_pacific_rim[14]
            else
                info.state = 0
                info.des = limit_dekaron_tip_spacing[1]
            end
        elseif k == 5 then      -- 阵营对决
            local push_info = _ED.mould_function_push_info["10"]
            if push_info ~= nil then
                info.state = tonumber(push_info.state)
                local time_info = zstring.split(push_info.params, ",")
                info.end_time = tonumber(time_info[3]) / 1000 + push_info.start_time
            end
            if info.state == 3 then
                info.des = tipString_info_project_pacific_rim[15]
            elseif info.state == 2 then
                info.des = tipString_info_project_pacific_rim[14]
            elseif info.state == 1 then
                info.des = tipString_info_project_pacific_rim[14]
            else
                info.des = limit_dekaron_tip_spacing[5]
            end
        elseif k == 6 then      -- 守卫战
            local push_info = _ED.mould_function_push_info["13"]
            if push_info ~= nil then
                info.state = tonumber(push_info.state)
                info.end_time = tonumber(push_info.params) / 1000 + push_info.start_time
            end
            if info.state == 2 then
                info.des = tipString_info_project_pacific_rim[15]
            elseif info.state == 1 then
                info.des = tipString_info_project_pacific_rim[14]
            else
                info.des = tipStringInfo_campaign_info[3]
            end
        end

        table.insert(campaign_tables, info)
    end

    local need_show_time = 2 * 3600     -- 提前2个小时倒计时
    self._show_tables = nil
    for k, v in pairs(campaign_tables) do
        local is_show = false
        if v.state > 0 then
            is_show = true
        else
            local tick_time = v.end_time - current_time
            if tick_time > 0 and tick_time < need_show_time then
                is_show = true
            end
        end
        if is_show == true then
            self._show_tables = self._show_tables or {}
            table.insert(self._show_tables, v)
        end
    end

    self._campaign_text_times = nil
    for i = 1, 2 do
        local Panel = ccui.Helper:seekWidgetByName(root,"Panel_"..i)
        local Panel_icon_tips = ccui.Helper:seekWidgetByName(root,"Panel_icon_tips"..i)
        local Text_time = ccui.Helper:seekWidgetByName(root,"Text_time_"..i)
        local Panel_name = ccui.Helper:seekWidgetByName(root,"Panel_name_"..i)

        if self._show_tables == nil or self._show_tables[i] == nil then
            Panel:setVisible(false)
        else
            local info = self._show_tables[i]
            Panel:setVisible(true)
            Panel_icon_tips:removeBackGroundImage()
            Panel_name:removeBackGroundImage()
            Panel_icon_tips:setBackGroundImage(string.format(config_res.images.ui.combat.icon_end, info.pic))
            Panel_name:setBackGroundImage(string.format(config_res.images.ui.combat.text_end, info.pic))
            if info.state == 0 then
                local tick_time = info.end_time - (os.time() + _ED.time_add_or_sub)
                Text_time:setString(string.format(tipString_info_project_pacific_rim[13], exChangeTimeToString(tick_time, 1)))

                self._campaign_text_times = self._campaign_text_times or {}
                self._campaign_text_times[""..info.index] = Text_time
            else
                Text_time:setString(info.des)
            end
        end
    end
end

function HomeBuildCell:onUpdateCampaignTime(dt)
    if self._show_tables ~= nil and self._campaign_text_times ~= nil then
        local local_time = os.time()
        for k, v in pairs(self._show_tables) do
            if self._campaign_text_times[""..v.index] ~= nil and v.state == 0 then
                local tick_time = v.end_time - (local_time + _ED.time_add_or_sub)
                self._campaign_text_times[""..v.index]:setString(string.format(tipString_info_project_pacific_rim[13], exChangeTimeToString(tick_time, 1)))
                if tick_time < 0 then
                    self:updateCampaignInfoEx()
                end
            end
        end
    end
end

-- 升级动画
function HomeBuildCell:updateBuildLevelEffect()
    local root = self.roots[1]
    local Panel_build_up_1 = ccui.Helper:seekWidgetByName(root,"Panel_build_up_1")
    if Panel_build_up_1 == nil then
        return
    end
    Panel_build_up_1:removeAllChildren(true)

    local update_state = zstring.tonumber(_ED.home_build[""..self.build_id].update_state)
    if self._last_update_state ~= update_state then
        if update_state == 1 then   -- 开始升级
            local max_time = _ED.home_build[""..self.build_id].update_time_cd
            if max_time >= 3 then
                local armature = ccs.Armature:create("effice_home_up_success1")
                local animation = armature:getAnimation()
                draw.initArmature(armature, nil, -1, 0, 1)
                if __lua_project_id == __lua_project_pacific_rim then
                    local animationIndex, nextAnimationIndex = 0, 0
                    if self.base_build_info.build_size == 1 then
                        animationIndex, nextAnimationIndex = 1, 4
                    elseif self.base_build_info.build_size == 2
                        or self.base_build_info.build_size == 3 then
                        animationIndex, nextAnimationIndex = 0, 3
                    else
                        animationIndex, nextAnimationIndex = 2, 5
                    end
                    animation:playWithIndex(animationIndex)
                    armature._nextAction = nextAnimationIndex
                else
                    animation:playWithIndex(0, 0, 0)
                    armature._nextAction = 1
                end
                armature:setPosition(Panel_build_up_1:getContentSize().width / 2, Panel_build_up_1:getContentSize().height / 2)
                Panel_build_up_1:addChild(armature)
            end
        else                        -- 升级完成
            local armature = ccs.Armature:create("effice_build_success1")
            local animation = armature:getAnimation()
            animation:playWithIndex(0, 0, 0)
            armature:setPosition(Panel_build_up_1:getContentSize().width / 2, Panel_build_up_1:getContentSize().height / 2)
            Panel_build_up_1:addChild(armature)
        end
    else
        if update_state == 1 then   -- 升级中
            local armature = ccs.Armature:create("effice_home_up_success1")
            local animation = armature:getAnimation()
            armature:setPosition(Panel_build_up_1:getContentSize().width / 2, Panel_build_up_1:getContentSize().height / 2)
            Panel_build_up_1:addChild(armature)
            if __lua_project_id == __lua_project_pacific_rim then
                local nextAnimationIndex = 0
                if self.base_build_info.build_size == 1 then
                    nextAnimationIndex = 4
                elseif self.base_build_info.build_size == 2
                    or self.base_build_info.build_size == 3 then
                    nextAnimationIndex = 3
                else
                    nextAnimationIndex = 5
                end
                animation:playWithIndex(nextAnimationIndex)
            else
                draw.initArmatureTwo(armature, nil, -1, 0, 1, 1)
            end
        end
    end

    self._last_update_state = update_state
end

function HomeBuildCell:updateCampaignInfo()
    if tonumber(self.build_id) ~= 5 then
        return
    end
    if funOpenDrawTip(155,false) == true then
        return
    end

    if __lua_project_id == __lua_project_pacific_rim then
        self:updateCampaignInfoEx()
        return
    end

    if self._operations_center_armature == nil then
        return
    end
    local root = self.roots[1]

    local personal_open = false             -- 个人限时活动
    local legion_open = false               -- 军团限时活动

    -- 个人活动是否开启
    local personal_push_id = {3, 4, 5}
    local fun_open_id = {219, 220, 221}
    for k, v in pairs(personal_push_id) do
        local state = 0
        if funOpenDrawTip(fun_open_id[k],false) == false and _ED.mould_function_push_info[""..v] ~= nil then
            state = _ED.mould_function_push_info[""..v].state
        end
        if tonumber(state) > 0 then
            personal_open = true
            break
        end
    end

    -- 军团活动是否开启
    -- 军团争霸开启状态
    local state = 0
    if funOpenDrawTip(223,false) == false and _ED.mould_function_push_info["9"] ~= nil then
        state = _ED.mould_function_push_info["9"].state
    end
    if tonumber(state) ~= 0 and tonumber(state) ~= 4 then
        legion_open = true
    end
    -- 阵营战开启状态
    state = 0
    if funOpenDrawTip(224,false) == false and _ED.mould_function_push_info["10"] ~= nil then
        state = _ED.mould_function_push_info["10"].state
    end
    if tonumber(state) > 0 then
        legion_open = true
    end
    -- 守卫战开启状态
    state = 0
    if funOpenDrawTip(225,false) == false and _ED.mould_function_push_info["13"] ~= nil then
        state = _ED.mould_function_push_info["13"].state
    end
    if tonumber(state) > 0 then
        legion_open = true
    end
    -- -- 城市战开启状态
    -- state = 0
    -- if funOpenDrawTip(244,false) == false and _ED.mould_function_push_info["14"] ~= nil then
    --     state = _ED.mould_function_push_info["14"].state
    -- end
    -- if tonumber(state) > 0 then
    --     legion_open = true
    -- end

    if legion_open == false and personal_open == false then
        self._operations_center_armature:setVisible(false)
    else
        self._operations_center_armature:setVisible(true)
        if self._is_play_effect == true then
            checkPlayEffect(72)
            self._is_play_effect = false
        end
        self._operations_center_armature.__play_index = -1
        -- end
        if legion_open == true then
            if self._operations_center_armature.__play_index ~= 0 then
                self._operations_center_armature:getAnimation():playWithIndex(0)
                self._operations_center_armature.__play_index = 0
            end
        elseif personal_open == true then
            if self._operations_center_armature.__play_index ~= 1 then
                self._operations_center_armature:getAnimation():playWithIndex(1)
                self._operations_center_armature.__play_index = 1
            end
        else
            self._operations_center_armature.__play_index = -1
            self._operations_center_armature:setVisible(false)
        end
    end
end

function HomeBuildCell:updateArenaBuildInfo( ... )
    local root = self.roots[1]
    if root == nil 
        or tonumber(self.build_id) ~= 4
        then
        return
    end
    local Panel_arena_top = ccui.Helper:seekWidgetByName(root,"Panel_arena_top")
    Panel_arena_top:removeAllChildren(true)

    local csbItem = csb.createNode(config_csb.cells.home.home_arena_top_view_cell)
    Panel_arena_top:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    local Text_arena_top_name = ccui.Helper:seekWidgetByName(root,"Text_arena_top_name")
    local Text_arena_top_name_1 = ccui.Helper:seekWidgetByName(root,"Text_arena_top_name_1")
    Text_arena_top_name:setAnchorPoint(cc.p(0, 0.5))
    Text_arena_top_name_1:setAnchorPoint(cc.p(0, 0.5))
    local top_name = red_alert_all_str[251]
    if _ED.mould_function_push_info["1"] ~= nil then
        local params = zstring.split(_ED.mould_function_push_info["1"].params, ",") 
        if params[1] == nil 
            or params[1] == "" then
            top_name = arena_tip_text[33]
        else
            top_name = params[1]
        end
    end

    local len = string.len(top_name)
    local space_num = 18 - len
    local head_space = math.floor(space_num / 2)
    local tail_space = space_num - head_space
    local name = ""
    for i = 1, head_space do
        name = name.." "
    end
    name = name..top_name
    for i = 1, tail_space do
        name = name.." "
    end
    Text_arena_top_name:setString(limit_dekaron_tip_daily[1]..name)
    Text_arena_top_name_1:setString(limit_dekaron_tip_daily[1]..name)

    local start_pos = cc.p(-120, 21)
    local end_pos = cc.p(-480, 21)
    local tail_pos = cc.p(200, 21)

    Text_arena_top_name:setPosition(start_pos)
    Text_arena_top_name_1:setPosition(tail_pos)

    local function playAction()
        Text_arena_top_name:setPosition(start_pos)
        Text_arena_top_name:runAction(cc.Sequence:create(cc.MoveTo:create(10, end_pos), 
            cc.DelayTime:create(5),
            cc.CallFunc:create(playAction)))
        Text_arena_top_name_1:setPosition(tail_pos)
        Text_arena_top_name_1:runAction(cc.MoveTo:create(10, start_pos))
    end

    playAction()
end

function HomeBuildCell:changeLevelState( state )
    local root = self.roots[1]
    if tonumber(_ED.user_info.user_grade) < 16 then
        state = true
    end
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    local Image_name_bg = ccui.Helper:seekWidgetByName(root,"Image_name_bg")
    if Text_name ~= nil then
        Text_name:setVisible(state)
        Image_name_bg:setVisible(state)
    end
    local build_info = _ED.home_build[""..self.build_id]
    if build_info == nil
        or build_info.level == 0
        or tonumber(self.base_build_info.build_ids) ~= -1
        or self.production_id ~= nil 
        or funOpenDrawTip(self.base_build_info.fun_open_tab_id, false) 
        then
        Text_name:setVisible(false)
        Image_name_bg:setVisible(false)
    end
end

-- 机甲工厂生产状态
function HomeBuildCell:updateInProductionInfoEx()
    local root = self.roots[1]
    local Panel_build_make_tank  = ccui.Helper:seekWidgetByName(root,"Panel_build_make_tank")
    Panel_build_make_tank:setVisible(false)

    self._production_text_time = nil
    self._production_loading_bar = nil

    local production_info = nil
    if _ED.production_info ~= nil then
        local ntype = self.build_id - 9
        if _ED.production_info[""..ntype] ~= nil then
            for k, v in pairs(_ED.production_info[""..ntype]) do
                if tonumber(v.production_state) == 0 then
                    production_info = v
                    break
                end
            end
            if production_info ~= nil then
                Panel_build_make_tank:setVisible(true)
                local mould_id = production_info.mould_id
                local camp_preference = dms.int(dms["ship_mould"], mould_id, ship_mould.camp_preference)                  -- 类型
                local quality = dms.int(dms["ship_mould"], mould_id, ship_mould.ship_type)              -- 品质

                local Panel_build_make_qquality = ccui.Helper:seekWidgetByName(root,"Panel_build_make_qquality")
                local Panel_build_make_type = ccui.Helper:seekWidgetByName(root,"Panel_build_make_type")
                local LoadingBar_build_make_time = ccui.Helper:seekWidgetByName(root,"LoadingBar_build_make_time")
                local Text_build_make_time = ccui.Helper:seekWidgetByName(root,"Text_build_make_time")
                Panel_build_make_qquality:removeBackGroundImage()
                Panel_build_make_type:removeBackGroundImage()

                Panel_build_make_qquality:setBackGroundImage(string.format(config_res.images.ui.home.bar_build_make_qquality_box, quality))
                Panel_build_make_type:setBackGroundImage(string.format(config_res.images.ui.home.bar_build_make_type, camp_preference))

                local leave_time = production_info.production_start_cd - zstring.tonumber((os.time() + _ED.time_add_or_sub - production_info.production_start_time))
                local percent = math.floor((production_info.production_start_cd - leave_time) * 100 / production_info.production_start_cd)
                Text_build_make_time:setString(exChangeTimeToString(leave_time))
                LoadingBar_build_make_time:setPercent(percent)

                self._production_loading_bar = LoadingBar_build_make_time
                self._production_text_time = Text_build_make_time
            end
        end
    end
    self:updateFactoryProduction(production_info)
end

function HomeBuildCell:updateInProductionInfo()
    local root = self.roots[2]
    if root == nil then
        return
    end
    local build_info = _ED.home_build[""..self.build_id]
    if build_info == nil or build_info.level == 0 then
        return
    end

    self._Panel_effice:setVisible(false)

    local production_info = nil
    if tonumber(self.build_id) == 9            -- 坦克工厂1   
        or tonumber(self.build_id) == 10       -- 坦克工厂2
        or tonumber(self.build_id) == 11       -- 改造工厂
        then
        if __lua_project_id == __lua_project_pacific_rim then
            self:updateInProductionInfoEx()
        else
            if _ED.production_info ~= nil then
                local ntype = self.build_id - 9
                if _ED.production_info[""..ntype] ~= nil then
                    for k, v in pairs(_ED.production_info[""..ntype]) do
                        if tonumber(v.production_state) == 0 then
                            production_info = v
                            break
                        end
                    end
                    if production_info ~= nil then
                        local mould_id = production_info.mould_id
                        local pic = dms.int(dms["ship_mould"], mould_id, ship_mould.All_icon)                  -- 图标
                        local quality = dms.int(dms["ship_mould"], mould_id, ship_mould.ship_type)              -- 品质
                        self._Panel_effice:setVisible(true)
                        root:setBackGroundImage(string.format(config_res.images.ui.share.in_production_box, quality + 1))

                        local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
                        Panel_tank_icon:removeAllChildren(true)
                        Panel_tank_icon:removeBackGroundImage()
                        Panel_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic))
                    end
                end
            end
            self:updateFactoryProduction(production_info)
        end
    elseif tonumber(self.build_id) == 8 then            -- 制造工厂
        if _ED.production_info ~= nil then
            if _ED.production_info["3"] ~= nil then
                for k, v in pairs(_ED.production_info["3"]) do
                    if tonumber(v.production_state) == 0 then
                        production_info = v
                        break
                    end
                end
            end

            if production_info ~= nil then
                local mould_id = production_info.mould_id
                mould_id = _ED.base_prop_make_info[""..mould_id].get_prop_id
                local pic_index = dms.string(dms["prop_mould"], mould_id, prop_mould.pic_index)
                pic_index = zstring.split(pic_index, ",")
                self._Panel_effice:setVisible(true)
                local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
                Panel_tank_icon:removeAllChildren(true)
                local cell = state_machine.excute("props_icon_create_cell",0,{4,3,mould_id,1,0})
                Panel_tank_icon:addChild(cell) 
                root:setBackGroundImage(string.format(config_res.images.ui.share.in_production_box, pic_index[2] + 1))
            end
        end
        self:updateFactoryProduction(production_info)
    elseif tonumber(self.build_id) == 3 then            -- 科技中心
        if _ED.barracks_info ~= nil then
            for k, v in pairs(_ED.barracks_info) do
                if tonumber(v.barrack_state) == 1 then
                    production_info = v
                    break
                end
            end
        end
        if production_info ~= nil then
            local mould_id = production_info.mould_id
            local pic = dms.int(dms["ship_mould"], mould_id, ship_mould.head_icon)                  -- 图标
            self._Panel_effice:setVisible(true)
            local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
            Panel_tank_icon:removeAllChildren(true)
            local barrack_id = _ED.base_barracks_info[""..production_info.barrack_id].id
            local cell = state_machine.excute("props_icon_create_cell",0,{4,3,barrack_id,4,0})
            Panel_tank_icon:addChild(cell) 
            pic_index = dms.string(dms["teach_escalate_param"], barrack_id, teach_escalate_param.pic_index)
            pic_index = zstring.split(pic_index, ",")
            root:setBackGroundImage(string.format(config_res.images.ui.share.in_production_box, 1))
        end
        self:updateScientificProduction(production_info)
    elseif tonumber(self.build_id) == 6 then            -- 配件车间
        if funOpenDrawTip(self.base_build_info.fun_open_tab_id, false) == true then
            self.production_id = nil
            return
        end
        local equip_info = nil
        local need_level_info = zstring.split(dms.string(dms["equipment_config"], 7, equipment_config.param), "|")
        local need_levels = {}
        for i = 1, 4 do
            local need_levels = zstring.split(need_level_info[i], ",")
            for j=1,8 do
                if tonumber(_ED.user_info.user_grade) >= tonumber(need_levels[j]) then
                    local is_have_war = false
                    local is_have_equip = false
                    local equipments = {}
                    for k, v in pairs(_ED.user_equiment) do
                        if tonumber(v.influence_type) == i and tonumber(v.equipment_type) == j then
                            if tonumber(v.is_equiped) == 1 then
                                is_have_war = true
                                break
                            else
                                is_have_equip = true
                                table.insert(equipments, v)
                            end
                        end
                    end
                    if is_have_war == false and is_have_equip == true then
                        local function sortFunction(a, b)
                            if tonumber(a.grow_level) > tonumber(b.grow_level) 
                                or tonumber(a.grow_level) == tonumber(b.grow_level) and tonumber(a.rank_up_level) > tonumber(b.rank_up_level) 
                                or tonumber(a.grow_level) == tonumber(b.grow_level) and tonumber(a.rank_up_level) > tonumber(b.rank_up_level) and tonumber(a.upgrade_level) > tonumber(a.upgrade_level) 
                                then
                                return true
                            end
                            return false
                        end
                        table.sort(equipments, sortFunction)
                        equip_info = equipments[1]
                    end
                end
                if equip_info ~= nil then
                    break
                end
            end
            if equip_info ~= nil then
                break
            end
        end
        if equip_info ~= nil then
            self._Panel_effice:setVisible(true)
            local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
            Panel_tank_icon:removeAllChildren(true)
            local cell = state_machine.excute("props_icon_create_cell", 0, {8, 3, equip_info.equip_id, 7,0})
            Panel_tank_icon:addChild(cell)
            root:removeBackGroundImage()
            local pic_index = zstring.split(equip_info.pic_index, ",")
            root:setBackGroundImage(string.format(config_res.images.ui.share.in_production_box, pic_index[2]+1))
            self.production_id = 1 
        else
            self.production_id = nil
        end
        production_info = equip_info

    elseif tonumber(self.build_id) == 2 then            -- 军团奖励
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            then
            self.production_id = nil
            return
        end
        self.production_id = 1

        root:setBackGroundImage(string.format(config_res.images.ui.share.in_production_box, 1))
        local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
        Panel_tank_icon:removeAllChildren(true)
        Panel_tank_icon:removeBackGroundImage()
        if getlegionApplyTips() == true then
            self._Panel_effice:setVisible(true)
            self._last_pve_receive = zstring.tonumber(_ED._can_receive_count)
            Panel_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.props, 6125))
            return
        end
        if zstring.tonumber(_ED._can_receive_count) > 0 then
            self._Panel_effice:setVisible(true)
            self._last_pve_receive = zstring.tonumber(_ED._can_receive_count)
            Panel_tank_icon:setBackGroundImage(string.format(config_res.images.ui.pve.treasure_box, 1))
        else
            self.production_id = nil
            self._last_pve_receive = zstring.tonumber(_ED._can_receive_count)
        end
    end
end

-- 更新工厂的生产状态
function HomeBuildCell:updateFactoryProduction(production_info)
    if production_info == nil then
        self.production_id = nil
        self.production_max_time = nil
        self.production_start_time = nil
    else
        self.production_id = production_info.id
        self.production_start_time = production_info.production_start_time
        self.production_max_time = production_info.production_start_cd
    end
end

-- 更新科技中心的生产状态
function HomeBuildCell:updateScientificProduction(production_info)
    if production_info == nil then
        self.production_id = nil
        self.production_max_time = nil
        self.production_start_time = nil
    else
        self.production_id = production_info.barrack_id
        self.production_start_time = production_info.barrack_upgrade_time
        self.production_max_time = production_info.barrack_upgrade_cd
    end
end


function HomeBuildCell:updateDraw(build_info)
    local last_build_ids = -1
    if self.base_build_info ~= nil then
        last_build_ids = tonumber(self.base_build_info.build_ids)
    end
    if build_info ~= nil then
        self.base_build_info = _ED.base_build_info[""..build_info.build_mould_id]
    end
    local home_build_info = _ED.home_build[""..self.build_id]

    self._need_check_build_level_up = true
    self._need_check_build_produce_up = true
    local root = self.roots[1]
    local root2 = self.roots[2]
    local Panel_build_icon = ccui.Helper:seekWidgetByName(root,"Panel_build_icon")
    local Image_rock = ccui.Helper:seekWidgetByName(root,"Image_rock")
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    local Image_name_bg = ccui.Helper:seekWidgetByName(root,"Image_name_bg")
    local Text_lv = ccui.Helper:seekWidgetByName(root,"Text_lv")
    local Image_lv_bg = ccui.Helper:seekWidgetByName(root,"Image_lv_bg")

    Text_lv:setString("")
    Image_lv_bg:setVisible(false)
    root:setVisible(true)

    local len = 0
    if self.base_build_info.max_level > 0 and home_build_info ~= nil then
        local level = home_build_info.level
        Text_name:setString(""..level.." "..self.base_build_info.build_name)
        if tonumber(level) > 0 then
            Text_lv:setString(level)
        end
        Image_lv_bg:setVisible(true)
    elseif tonumber(self.build_id) == 2 then
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            then
            Text_name:setString(self.base_build_info.build_name)
        else
            Text_name:setString("".._ED.union.union_info.union_grade.." ".._ED.union.union_info.union_name)
            Text_lv:setString(_ED.union.union_info.union_grade)
            Image_lv_bg:setVisible(true)
            if isContentZh_TW() == true then
                Text_name:setFontSize(Text_name:getFontSize())
                Text_name:setFontName("")
            end
        end
    else
        Text_name:setString(self.base_build_info.build_name)
    end
    local size = Image_name_bg:getContentSize()
    local len = 0
    local map = string.utf8.chars(Text_name:getString())
    for k, v in pairs(map) do
        if string.len(v) == 1 then
            len = len + 1
        else
            len = len + 2
        end
    end
    len = math.ceil(len)
    local width = len * 14 + 25
    local ttSize = Text_name:getAutoRenderSize()
    Image_name_bg:setContentSize(cc.size(ttSize.width + 26,ttSize.height + 10))
    --Image_name_bg:setContentSize(cc.size(width, size.height))
        
    self._tile_size = Panel_build_icon:getContentSize()
    if self._Panel_effice_0 ~= nil then
        if tonumber(self.build_id) == 4 
            or tonumber(self.build_id) == 5
            or tonumber(self.build_id) == 7
            or tonumber(self.build_id) == 54
            then
        else
            self._Panel_effice_0:setVisible(false)
        end
    end
    if tonumber(self.base_build_info.build_ids) ~= -1 then
        if last_build_ids ~= tonumber(self.base_build_info.build_ids)
            or build_info == nil then
            Panel_build_icon:removeBackGroundImage()
            Panel_build_icon:removeAllChildren(true)
            Panel_build_icon:stopAllActions()
            self._build_armature = nil
            local function playActions(sender)
                local tinto1 = cc.TintTo:create(0.5, 255, 255, 255)
                local tinto2 = cc.TintTo:create(0.5, 100, 100, 100)
                sender:runAction(cc.Sequence:create(tinto1, tinto2, cc.CallFunc:create(playActions)))
            end
            playActions(Panel_build_icon)
            local icon_name = string.format(config_res.images.ui.home.home_build, self.base_build_info.pic)
            Panel_build_icon:setBackGroundImage(icon_name)
        end
    else
        if last_build_ids ~= tonumber(self.base_build_info.build_ids)
            or build_info == nil then
            Panel_build_icon:removeBackGroundImage()
            Panel_build_icon:removeAllChildren(true)
            Panel_build_icon:stopAllActions()
            local effect_paths = string.format(config_res.images.ui.home.home_build_effect, self.base_build_info.pic)
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
            self._build_armature = ccs.Armature:create("home_build_"..self.base_build_info.pic)
            draw.initArmature(self._build_armature, nil, -1, 0, 1)
            self._build_armature:setPosition(cc.p(Panel_build_icon:getContentSize().width/2, Panel_build_icon:getContentSize().height/2))
            Panel_build_icon:addChild(self._build_armature)
        end
        if self._build_armature ~= nil then
            if tonumber(home_build_info.level) <= 0 then
                self._build_armature:getAnimation():playWithIndex(0)
            else
                Panel_build_icon:setColor(cc.c3b(255, 255, 255))
                self._build_armature:getAnimation():playWithIndex(1)
            end
        end
    end

    if funOpenDrawTip(self.base_build_info.fun_open_tab_id, false) == true then
        if self.base_build_info.build_type >= 0 and Image_rock ~= nil then         -- 未达开启条件
            Image_rock:setVisible(true)
            if self._build_armature ~= nil then
                self._build_armature:getAnimation():playWithIndex(0)
            end
        else                                            -- 没有开启资源建筑
            root:setVisible(false)
        end
    elseif home_build_info == nil or home_build_info.level == 0 then -- 已开启，没有建造
        if self._build_armature ~= nil then
            self._build_armature:getAnimation():playWithIndex(0)
        end
        if self._Panel_effice_0 ~= nil then
            self._Panel_effice_0:setVisible(true)
        end
        if Image_rock ~= nil then
            Image_rock:setVisible(false)
        end
    else                -- 已建造的建筑
        if self._build_armature ~= nil then
            self._build_armature:getAnimation():playWithIndex(1)
        end
        if Image_rock ~= nil then
            Image_rock:setVisible(false)
        end
    end

    local Image_build_up_bg = ccui.Helper:seekWidgetByName(root,"Image_build_up_bg")
    local Text_up_time = ccui.Helper:seekWidgetByName(root,"Text_up_time")
    local LoadingBar_build_up = ccui.Helper:seekWidgetByName(root,"LoadingBar_build_up")

    self.update_image = Image_build_up_bg
    self.loading_bar = LoadingBar_build_up
    self.text_time = Text_up_time

    self.update_image:setVisible(false)
    self.loading_bar:setVisible(false)
    self.text_time:setVisible(false)

    -- 可免费升级时间
    self._free_time = 60 * dms.int(dms["base_consume"], 102, tonumber(_ED.vip_grade) + 4)
    self._build_up_state = 0
    if self.base_build_info.max_level >= 0 and _ED.home_build[""..self.build_id] ~= nil then
        local build_info = _ED.home_build[""..self.build_id]
        if zstring.tonumber(build_info.update_state) == 1 then
            self._build_up_state = 1
            self.update_image:setVisible(true)
            self.loading_bar:setVisible(true)
            self.text_time:setVisible(true)
            local max_time = build_info.update_time_cd
            local leave_time = max_time - zstring.tonumber((os.time() + _ED.time_add_or_sub - build_info.update_start_time))
            leave_time = math.min(leave_time, max_time)
            local persent = math.floor((max_time - leave_time) * 100 / max_time)
            self.loading_bar:setPercent(persent)
            self.text_time:setString(exChangeTimeToString(leave_time))
            if leave_time < self._free_time then
                self._build_up_state = 2
            end
        end
    end
    self:updateButtonState()
end

function HomeBuildCell:updateButtonState()
    local root = self.roots[1]
    local Button_build_up_free = ccui.Helper:seekWidgetByName(root,"Button_build_up_free")
    if Button_build_up_free == nil then
        return
    end

    if self._build_up_state == 0 or self._build_up_state == 1 then
        Button_build_up_free:setVisible(false)
    elseif self._build_up_state == 2 then
        Button_build_up_free:setVisible(true)
    end
end

function HomeBuildCell:checkBuildLevelUp( ... )
    local build_info = _ED.home_build[""..self.build_id]
    local level = zstring.tonumber(build_info.level)
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node._need_check_build_level_up = true
                fwin:close(fwin:find("ReconnectViewClass"))
                if fwin:find("FightClass") == nil then
                    if zstring.tonumber(build_info.update_state) == 0 then
                        TipDlg.drawTextDailog(string.format(red_alert_all_str[280],response.node.base_build_info.build_name,level+1))
                    end
                end
                response.node:updateDraw(_ED.home_build[""..response.node.build_id])
            end
            state_machine.excute("main_window_update_quick_info", 0, nil)
            state_machine.excute("main_window_update_task_info", 0, nil)
            state_machine.excute("main_window_update_boom_info", 0, nil)

            state_machine.excute("build_up_build_quickly_window_close",0,"")
            state_machine.excute("build_up_tank_factory_to_update_draw", 0, nil)
            state_machine.excute("build_up_headquarters_to_update_draw",0,"")
            state_machine.excute("build_up_scientific_to_update_draw",0,"")
            state_machine.excute("build_up_res_to_update_draw",0,"")
            state_machine.excute("build_up_reform_factory_to_update_draw",0,"")
            state_machine.excute("build_up_make_factory_to_update_draw",0,"")
            checkPlayEffect(36)
        else
            if fwin:find("ReconnectViewClass") == nil then
                local reconnectView = ReconnectView:new():init(_string_piece_info[420])
                reconnectView.request = response
                fwin:open(reconnectView, fwin._system)
            end
        end
    end
    NetworkManager:register(protocol_command.build_check_up.code, nil, nil, nil, self, responseCallback, false, nil)
end

function HomeBuildCell:onUpdate(dt)
    self:pushBuildInfo()
    self:onUpdateCampaignTime(dt)

    if self.base_build_info.max_level == -1 then
        return
    end
    local build_info = _ED.home_build[""..self.build_id]
    if build_info == nil then
        return
    end

    if self.text_time ~= nil and self._need_check_build_level_up == true then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            local level = zstring.tonumber(build_info.level)
            if zstring.tonumber(build_info.update_state) == 1 then
                if self._last_update_state == 0 then
                    self:updateBuildLevelEffect()
                end
                local max_time = build_info.update_time_cd
                self.update_image:setVisible(true)
                self.loading_bar:setVisible(true)
                self.text_time:setVisible(true)
                local leave_time = max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - build_info.update_start_time))
                leave_time = math.min(leave_time, max_time)
                local persent = math.floor((max_time - leave_time) * 100 / max_time)
                self.loading_bar:setPercent(persent)
                self.text_time:setString(exChangeTimeToString(leave_time))
                if leave_time < 0.5 then
                    self._need_check_build_level_up = false
                    self:checkBuildLevelUp()
                end

                if self._build_up_state ~= 2 and leave_time <= self._free_time then
                    self._build_up_state = 2
                    self:updateButtonState()
                    state_machine.excute("main_window_update_quick_info", 0, "")
                elseif self._build_up_state == 2 and leave_time > self._free_time then
                    self._build_up_state = 1
                    self:updateButtonState() 
                    state_machine.excute("main_window_update_quick_info", 0, "")   
                end
            else
                if self._last_update_state == 1 then
                    self:updateBuildLevelEffect()
                end
                self.update_image:setVisible(false)
                self.loading_bar:setVisible(false)
                self.text_time:setVisible(false)

                if self._build_up_state ~= 0 then
                    self._build_up_state = 0 
                    self:updateButtonState()   
                end
            end
        end
    end

    if self.production_id ~= nil and self._need_check_build_produce_up == true then           -- 生产状态
        local now_time = os.time()
        if now_time - zstring.tonumber(self.production_last_time) >= 1 then 
            self.production_last_time = now_time
            local leave_time = self.production_max_time - zstring.tonumber((now_time + _ED.time_add_or_sub - self.production_start_time))
            local mould_id = 0 
            if tonumber(self.build_id) == 9            -- 坦克工厂1   
                or tonumber(self.build_id) == 10       -- 坦克工厂2
                or tonumber(self.build_id) == 11       -- 改造工厂
                or tonumber(self.build_id) == 8        -- 制造工厂
                then
                local factory_type = 0
                if tonumber(self.build_id) == 8 then
                    factory_type = 3
                else
                    factory_type = tonumber(self.build_id) - 9
                end
                local factory_type_info = _ED.production_info[""..factory_type]
                if self._production_text_time ~= nil then
                    self._production_text_time:setString(exChangeTimeToString(leave_time))
                end
                if self._production_loading_bar ~= nil then
                    local percent = math.floor((self.production_max_time - leave_time) * 100 / self.production_max_time)
                    self._production_loading_bar:setPercent(percent)
                end
                if factory_type_info ~= nil then
                    local factory_production_info = factory_type_info[""..self.production_id]
                    if factory_production_info ~= nil
                        and zstring.tonumber(factory_production_info.production_state) == 0 then
                        if tonumber(self.build_id) == 8 then
                            mould_id = factory_production_info.mould_id
                            mould_id = _ED.base_prop_make_info[""..mould_id].get_prop_id
                        else
                            mould_id = zstring.tonumber(factory_production_info.mould_id)
                        end
                        if leave_time <= 0.5 then             -- 生产完成
                            self._need_check_build_produce_up = false
                            local function responseCallback( response )
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                        response.node._need_check_build_produce_up = true
                                        fwin:close(fwin:find("ReconnectViewClass"))
                                        local now_factory_type_info = _ED.production_info[""..factory_type]
                                        if now_factory_type_info == nil 
                                            or now_factory_type_info[""..response.node.production_id] == nil
                                            then        -- 生产完成
                                            if tonumber(factory_type) == 3 then
                                                local prop_name = dms.string(dms["prop_mould"], mould_id, prop_mould.prop_name)
                                                TipDlg.drawTextDailog(string.format(red_alert_all_str[305],prop_name))
                                            else
                                                checkRewardObtainDraw()
                                                TipDlg.drawTextDailog(red_alert_all_str[288])
                                            end
                                            state_machine.excute("home_map_update_tanke_info", 0, nil)
                                            state_machine.excute("build_up_make_factory_ing_production_update_draw", 0, "")
                                            state_machine.excute("build_up_tank_factory_in_production_update_draw", 0, nil)
                                            state_machine.excute("build_up_tank_factory_production_update_draw", 0, nil)
                                            state_machine.excute("build_up_tank_factory_production_ex_update_draw", 0, nil)
                                            state_machine.excute("main_window_update_quick_info", 0, "")
                                            state_machine.excute("build_up_build_production_quickly_window_close", 0, "")
                                            state_machine.excute("home_map_update_prodcution_state", 0, {8, 9, 10, 11})
                                            if tonumber(factory_type) < 3 then      -- 生产
                                                local camp_preference = dms.int(dms["ship_mould"], tonumber(mould_id), ship_mould.camp_preference)
                                                checkPlayEffect(camp_preference + 37)
                                            end
                                        end
                                    end
                                else
                                    if fwin:find("ReconnectViewClass") == nil then
                                        local reconnectView = ReconnectView:new():init(_string_piece_info[420])
                                        reconnectView.request = response
                                        fwin:open(reconnectView, fwin._system)
                                    end
                                end
                            end
                            NetworkManager:register(protocol_command.factory_product_check_cd.code, nil, nil, nil, self, responseCallback, false, nil)
                        end
                    end
                end
            elseif tonumber(self.build_id) == 3 then           -- 科技中心
                if leave_time <= 0.5 then
                    self._need_check_build_produce_up = false
                    local function responseCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node._need_check_build_produce_up = true
                                fwin:close(fwin:find("ReconnectViewClass"))
                                local barrack_id = response.node.production_id
                                if _ED.barracks_info ~= nil then
                                    local barrack_id_info = _ED.barracks_info[""..barrack_id]
                                    if barrack_id_info ~= nil
                                        and tonumber(barrack_id_info.barrack_state) == 0 then       -- 升级完成
                                        local name = _ED.base_barracks_info[""..barrack_id].name
                                        local level = barrack_id_info.barrack_level
                                        -- TipDlg.drawTextDailog(string.format(red_alert_all_str[280],name,level))
                                        response.node:updateInProductionInfo()
                                        state_machine.excute("main_window_update_quick_info", 0, "")
                                        state_machine.excute("build_up_build_scientific_quickly_window_close", 0, "")
                                        checkPlayEffect(37)
                                    end
                                end
                            end
                        else
                            if fwin:find("ReconnectViewClass") == nil then
                                local reconnectView = ReconnectView:new():init(_string_piece_info[420])
                                reconnectView.request = response
                                fwin:open(reconnectView, fwin._system)
                            end
                        end
                    end
                    NetworkManager:register(protocol_command.barracks_teach_check_cd.code, nil, nil, nil, self, responseCallback, false, nil)
                end
            end
        end
    end
end

function HomeBuildCell:pushLeaderBuildInfo(state)
    local root = self.roots[1]
    if self._Panel_effice_0 ~= nil then
        if tonumber(self.build_id) == 7 then    -- 将领学堂
            self.production_id = nil
            if state == true then
                self._Panel_effice_0:setVisible(true)
                self.production_id = 1
                return
            end
            if funOpenDrawTip(157,false) == false then
                --活动
                local active_count = 0
                if _ED.activity_info~=nil and _ED.activity_info["8"]~= nil then
                    local a_datas = zstring.split(_ED.activity_info["8"].activity_add_state ,",")
                    active_count = tonumber(a_datas[4])
                end

                local specil_recruit = (tonumber(_ED.free_info[2].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[2].free_start))
                local free_time = 0
                if tonumber(_ED.free_info[1].surplus_free_number) ~= nil then
                    free_time = tonumber(_ED.free_info[1].surplus_free_number) + active_count
                end
                local normal_recruit = (tonumber(_ED.free_info[1].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[1].free_start))
                if tonumber(specil_recruit) < 0
                    or (free_time > 0 and normal_recruit < 0) then
                    self._Panel_effice_0:setVisible(true)
                    self.production_id = 1
                    return
                else
                    self._have_free_time = false
                end
                for k, v in pairs(_ED.user_prop) do
                    if tonumber(v.storage_page_index) == 23 then
                        local is_owned = false
                        local ship_template_id = dms.int(dms["prop_mould"], tonumber(v.user_prop_template), prop_mould.use_of_ship)     -- 兑换后将领模板id
                        local base_template_id = dms.int(dms["ship_mould"], ship_template_id, ship_mould.base_mould)
                        for k, v in pairs(_ED.user_ship) do
                            if tonumber(v.ship_base_template_id) == base_template_id then
                                is_owned = true
                                break
                            end
                        end
                        if is_owned == false 
                            and tonumber(v.prop_number) >= tonumber(v.coming_need_number) then
                            self._Panel_effice_0:setVisible(true)
                            self.production_id = 1
                            return
                        end
                    end
                end
            end
            self._Panel_effice_0:setVisible(false)
        elseif tonumber(self.build_id) == 4 then    -- 战地争霸
            self.production_id = nil
            if getCampaignDailyTip(1) == true then
                self._Panel_effice_0:setVisible(true)
                self.production_id = 1
                return
            end
            self._Panel_effice_0:setVisible(false)
        elseif tonumber(self.build_id) == 54 then    -- 装甲车间
            self.production_id = nil
            if getArmorProductionTip(0) == true then
                self._Panel_effice_0:setVisible(true)
                self.production_id = 1
                return
            end
            self._Panel_effice_0:setVisible(false)
        end
    end
end

function HomeBuildCell:pushBuildInfo()
    local root = self.roots[1]
    if self._Panel_effice_0 ~= nil then
        if tonumber(self.build_id) == 7 then    -- 将领学堂
            if self._have_free_time == false then
                --活动
                local active_count = 0
                if _ED.activity_info~=nil and _ED.activity_info["8"]~= nil then
                    local a_datas = zstring.split(_ED.activity_info["8"].activity_add_state ,",")
                    active_count = tonumber(a_datas[4])
                end
                local specil_recruit = (tonumber(_ED.free_info[2].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[2].free_start))
                local free_time = 0
                if tonumber(_ED.free_info[1].surplus_free_number) ~= nil then
                    free_time = tonumber(_ED.free_info[1].surplus_free_number) + active_count
                end

                local normal_recruit = (tonumber(_ED.free_info[1].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[1].free_start))
                if tonumber(specil_recruit) < 0
                    or (free_time > 0 and normal_recruit < 0) then
                    if funOpenDrawTip(157,false) == false then
                        self:pushLeaderBuildInfo(true)
                        self._have_free_time = true
                        return
                    end
                end
            end
        end
    end
end

function HomeBuildCell:onInit()
    local csbString = string.format(config_csb.cells.home.home_build_cell_n, self.base_build_info.build_size)
    local csbItem = csb.createNode(csbString)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._last_update_state = zstring.tonumber(_ED.home_build[""..self.build_id].update_state)

    local Button_build_up_free = ccui.Helper:seekWidgetByName(root, "Button_build_up_free")
    if Button_build_up_free ~= nil then
        -- 免费升级
        fwin:addTouchEventListener(Button_build_up_free, nil, 
        {
            terminal_name = "home_build_cell_free_build_up", 
            terminal_state = 0, 
            touch_black = true,
            cell = self,
        }, nil, 1)    
    end

    for i = 1, 2 do
        local Panel_icon_tips = ccui.Helper:seekWidgetByName(root,"Panel_icon_tips"..i)
        if Panel_icon_tips ~= nil then
            fwin:addTouchEventListener(Panel_icon_tips, nil, 
            {
                terminal_name = "home_build_cell_open_campaign_window", 
                terminal_state = 0, 
                touch_black = true,
                cell = self,
                index = i,
            }, nil, 1) 
        end
    end

    local Panel_effice = ccui.Helper:seekWidgetByName(root, "Panel_effice")
    if Panel_effice ~= nil then
        self._Panel_effice = Panel_effice
        Panel_effice:setVisible(false)
        Panel_effice:removeAllChildren(true)
        if tonumber(self.build_id) == 9            -- 坦克工厂1   
            or tonumber(self.build_id) == 10       -- 坦克工厂2
            or tonumber(self.build_id) == 11       -- 改造工厂
            then
            local csbItem1 = csb.createNode(config_csb.cells.home.home_tank_build_effice_cell)
            local root1 = csbItem1:getChildByName("root")
            root1:removeFromParent(false)
            Panel_effice:addChild(root1)
            table.insert(self.roots, root1)
        elseif tonumber(self.build_id) == 8       -- 制造工厂
            or tonumber(self.build_id) == 3       -- 科技中心
            or tonumber(self.build_id) == 6       -- 配件车间
            or tonumber(self.build_id) == 2       -- 军团
            then
            local csbItem1 = csb.createNode(config_csb.cells.home.home_make_build_effice_cell)
            local root1 = csbItem1:getChildByName("root")
            root1:removeFromParent(false)
            Panel_effice:addChild(root1)
            table.insert(self.roots, root1)
        end
    end

    -- 建筑升级动画资源加载
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_build_success1)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effice_home_up_success1)

    if tonumber(self.build_id) == 5 then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_operations_center)
        self._operations_center_armature = ccs.Armature:create("effect_operations_center")
        self._operations_center_armature:setPosition(cc.p(root:getContentSize().width/2, root:getContentSize().height/2))
        self._operations_center_armature:setTag(1000)
        root:addChild(self._operations_center_armature)
        self._operations_center_armature:setVisible(false)
    end

    local effect_paths = config_res.images.ui.effice.effice_can_build
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    local Panel_build_interactive = ccui.Helper:seekWidgetByName(root,"Panel_build_interactive")
    Panel_build_interactive:setSwallowTouches(false)

    local Panel_effice_0 = ccui.Helper:seekWidgetByName(root,"Panel_effice_0")
    if Panel_effice_0 ~= nil then
        self._Panel_effice_0 = Panel_effice_0
        Panel_effice_0:setVisible(false)
        if tonumber(self.build_id) ~= 1           -- 司令部
            and tonumber(self.build_id) ~= 2       -- 军团
            and tonumber(self.build_id) ~= 5       -- 作战中心
            and tonumber(self.build_id) ~= 6       -- 配件车间
            and tonumber(self.build_id) ~= 12      -- 坦克仓库
            then
            local armature = ccs.Armature:create("effice_can_build")
            draw.initArmature(armature, nil, -1, 0, 1)
            local tuishong_icon_name = config_res.images.ui.bar.tuishong
            local tuishong_icon = ccs.Skin:create(tuishong_icon_name)
            if tonumber(self.build_id) == 4 
                or tonumber(self.build_id) == 5
                or tonumber(self.build_id) == 7
                or tonumber(self.build_id) == 54
                then
                armature:getBone("Layer2"):addDisplay(tuishong_icon, 0)
            end
            armature:setPosition(cc.p(Panel_effice_0:getContentSize().width/2, Panel_effice_0:getContentSize().height/2))
            Panel_effice_0:addChild(armature)
        end
    end

    local function panelTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
            pushEffect(formatMusicFile("button", 1))
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if missionIsOver() == true and (sender._locked == true or fwin._lock_touch == true or fwin._close_touch_end_event == true) then
                -- touch locked
            else
                if math.abs(__spoint.x - __epoint.x) <= 10 and math.abs(__spoint.y - __epoint.y) <= 10 
                    or missionIsOver() == false
                    then
                    -- state_machine.excute("home_build_cell_open_window", 0, {_datas = {cell = self}})
                    local function playActions( sender1 )
                        state_machine.excute("home_build_cell_open_window", 0, {_datas = {cell = self}})
                    end
                    local tinto1 = cc.TintTo:create(0.1, 255, 255, 255)
                    local tinto2 = cc.TintTo:create(0.1, 100, 100, 100)
                    root:runAction(cc.Sequence:create(tinto2, tinto1, cc.CallFunc:create(playActions)))
                end
            end
        end
    end
    Panel_build_interactive:addTouchEventListener(panelTouchListener)
    Panel_build_interactive.callback = panelTouchListener

    local Panel_build_interactive_ck = ccui.Helper:seekWidgetByName(root, "Panel_build_interactive_ck")
    if Panel_build_interactive_ck ~= nil then
        Panel_build_interactive_ck:setSwallowTouches(false)
        Panel_build_interactive_ck:addTouchEventListener(panelTouchListener)
        Panel_build_interactive_ck.callback = panelTouchListener
        if tonumber(self.build_id) == 12 then   -- 仓库
            Panel_build_interactive_ck:setVisible(true)
            Panel_build_interactive:setVisible(false)
        else
            Panel_build_interactive_ck:setVisible(false)
            Panel_build_interactive:setVisible(true)
        end
    end

    self:updateDraw()
    self:updateInProductionInfo()
    self:updateBuildLevelEffect()
    self:changeLevelState(false)
    if tonumber(self.build_id) == 4             -- 战地争霸
        or tonumber(self.build_id) == 7         -- 将领学堂
        or tonumber(self.build_id) == 54         -- 装甲车间
        then
        self:updateArenaBuildInfo()
        self:pushLeaderBuildInfo()
    elseif tonumber(self.build_id) == 5 then    -- 作战中心
        self:updateCampaignInfo()
    elseif tonumber(self.build_id) == 55 then    -- 排行榜
        self:updateRankInfo()
    end
end

function HomeBuildCell:onEnterTransitionFinish()
end

function HomeBuildCell:init(build_id, build_info, panel)
    self.build_id = build_id
    self._panel_city = panel
    self.base_build_info = _ED.base_build_info[""..build_info.build_mould_id]
    
    self:onInit()
end

function HomeBuildCell:onExit()

end