-- ----------------------------------------------------------------------------------------------------
-- 说明：数码冒险活动副本主界面
-------------------------------------------------------------------------------------------------------
ActivityCopyWindow = class("ActivityCopyWindowClass", Window)

local activity_copy_window_open_terminal = {
    _name = "activity_copy_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("activity_copy_window_close")
        if nil == fwin:find("ActivityCopyWindowClass") then
            fwin:open(ActivityCopyWindow:new():init(), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_copy_window_close_terminal = {
    _name = "activity_copy_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if (__lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto) and zstring.tonumber(_ED.server_review) == 1 then
        else
        state_machine.unlock("explore_window_open_fun_window")
        if nil == fwin:find("ExploreWindowClass") then
            state_machine.excute("explore_window_open", 0, "") 
        end
        end
        fwin:close(fwin:find("ActivityCopyWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_copy_window_open_terminal)
state_machine.add(activity_copy_window_close_terminal)
state_machine.init()

function ActivityCopyWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.initialText = nil
    self.initialPosX = 0

    -- load lua file
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.equip.equip_icon_cell")

    -- var
    self._current_page_index = 1
    self._current_scene = nil
    self._is_time_opened = true

    -- Initialize explore window state machine.
    local function init_activity_copy_window_terminal()
        local activity_copy_window_change_to_page_terminal = {
            _name = "activity_copy_window_change_to_page",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local pageIndex = params._datas.page_index
                if true == params._datas.is_opened then
                    if nil ~= terminal._choice_button then
                        local Sprite_guaka_text_1 = terminal._choice_button:getChildByName("Sprite_guaka_text_1") -- 未选中
                        local Sprite_guaka_text_2 = terminal._choice_button:getChildByName("Sprite_guaka_text_2") -- 选中
                        Sprite_guaka_text_1:setVisible(true)
                        Sprite_guaka_text_2:setVisible(false)
                        terminal._choice_button:setHighlighted(false)
                        terminal._choice_button:setTouchEnabled(true)
                    end
                    terminal._choice_button = params._datas.button

                    fwin:addService({
                        callback = function ( params )
                            if nil ~= params._choice_button then
                                local Sprite_guaka_text_1 = params._choice_button:getChildByName("Sprite_guaka_text_1") -- 未选中
                                local Sprite_guaka_text_2 = params._choice_button:getChildByName("Sprite_guaka_text_2") -- 选中
                                Sprite_guaka_text_1:setVisible(false)
                                Sprite_guaka_text_2:setVisible(true)
                                params._choice_button:setHighlighted(true)
                                params._choice_button:setTouchEnabled(false) 
                            end
                        end,
                        params = terminal,
                        delay = 0
                    })

                    instance._current_scene = params._datas.scene
                    instance._current_page_index = pageIndex
                    instance._is_time_opened = params._datas.is_time_opened
                    instance:onUpdateDraw()
                else
                    TipDlg.drawTextDailog(dms.atos(params._datas.scene, pve_scene.open_condition_describe))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_copy_window_open_fun_window_terminal = {
            _name = "activity_copy_window_open_fun_window",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local pageType = params._datas.page_type
                if 1 == pageType then
                    TipDlg.drawTextDailog("缺少界面资源")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_copy_window_lock_fun_window_terminal = {
            _name = "activity_copy_window_lock_fun_window",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 18, fun_open_condition.tip_info))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_copy_window_show_help_dailog_terminal = {
            _name = "activity_copy_window_show_help_dailog",
            _init = function (terminal) 
                app.load("client.l_digital.explore.activity_copy.ActivityDuplicateRuleWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("activity_duplicate_rule_window_open",0,instance._current_page_index) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_copy_window_join_battle_terminal = {
            _name = "activity_copy_window_join_battle",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.l_digital.explore.activity_copy.ChoiceDifficultyWindow")
                state_machine.excute("choice_difficulty_window_open", 0, {instance._current_page_index, instance._current_scene})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_copy_window_check_battle_cd_terminal = {
            _name = "activity_copy_window_check_battle_cd",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance._interval and instance._interval > 0 then
                    TipDlg.drawTextDailog(dms.string(dms["error_code"], 596, error_code.infoCn))
                    return false
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_copy_window_on_update_draw_terminal = {
            _name = "activity_copy_window_on_update_draw",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_copy_window_change_to_page_terminal)
        state_machine.add(activity_copy_window_open_fun_window_terminal)
        state_machine.add(activity_copy_window_lock_fun_window_terminal)
        state_machine.add(activity_copy_window_show_help_dailog_terminal)
        state_machine.add(activity_copy_window_join_battle_terminal)
        state_machine.add(activity_copy_window_check_battle_cd_terminal)
        state_machine.add(activity_copy_window_on_update_draw_terminal)
        state_machine.init()
    end

    -- call func init explore window state machine.
    init_activity_copy_window_terminal()
end

function ActivityCopyWindow:init()
    return self
end

function ActivityCopyWindow:onDrawRewardListView(listView, rewardInfoString)
    local isHaveActivity = false
    if self._current_page_index == 1 then
        if _ED.active_activity[99] ~= nil and _ED.active_activity[99] ~= "" then
            isHaveActivity = true
        end
    elseif self._current_page_index == 2 then
        if _ED.active_activity[131] ~= nil and _ED.active_activity[131] ~= "" then
            isHaveActivity = true
        end
    elseif self._current_page_index == 3 then
        if _ED.active_activity[133] ~= nil and _ED.active_activity[133] ~= "" then
            isHaveActivity = true
        end
    elseif self._current_page_index == 4 then
        if _ED.active_activity[132] ~= nil and _ED.active_activity[132] ~= "" then
            isHaveActivity = true
        end
    end
    local rewardInfoArr = zstring.split(rewardInfoString, "|")
    for i, v in pairs(rewardInfoArr) do
        local info = zstring.split(v, ",")
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{info[1],info[2],info[3]},false,false,false,true})
        listView:addChild(cell)
        if isHaveActivity == true then
            cell:setActivityDouble(true)
        end
        -- if info[1] == "1" then
        --     local cell = ResourcesIconCell:createCell()
        --     cell:init(1, tonumber(info[3]), -1,nil,nil,nil,true)
        --     cell:hideCount(true)
        --     listView:addChild(cell)
        --     if isHaveActivity == true then
        --         cell:setActivityDouble(true)
        --     end
        -- elseif info[1] == "2" then
        --     local cell = ResourcesIconCell:createCell()
        --     cell:init(2, tonumber(info[3]), -1,nil,nil,nil,true)
        --     cell:hideCount(true)
        --     listView:addChild(cell)
        --     if isHaveActivity == true then
        --         cell:setActivityDouble(true)
        --     end
        -- elseif info[1] == "6" then
        --     local cell = ResourcesIconCell:createCell()
        --     local reawrdID = tonumber(info[2])
        --     local rewardNum = tonumber(info[3])
        --     cell:init(6, 0, reawrdID,nil,nil,nil,true)
        --     listView:addChild(cell)
        --     if isHaveActivity == true then
        --         cell:setActivityDouble(true)
        --     end
        -- elseif info[1] == "7" then
        --     local reawrdID = tonumber(info[2])
        --     local rewardNum = tonumber(info[3])
            
        --     local tmpTable = {
        --         user_equiment_template = reawrdID,
        --         mould_id = reawrdID,
        --         user_equiment_grade = 1
        --     }
            
        --     local cell = ResourcesIconCell:createCell()
        --     cell:init(7, 0, reawrdID,nil,nil,nil,true)
        --     listView:addChild(cell)
        --     if isHaveActivity == true then
        --         cell:setActivityDouble(true)
        --     end
        -- end
    end
end

function ActivityCopyWindow:onUpdateDraw( ... )
    local root = self.roots[1]
    local Image_jinbi_x2 = ccui.Helper:seekWidgetByName(root, "Image_jinbi_x2")
    if Image_jinbi_x2 ~= nil then
        Image_jinbi_x2:setVisible(false)
        if _ED.active_activity[99] ~= nil and _ED.active_activity[99] ~= "" then
            Image_jinbi_x2:setVisible(true)
        end
    end

    local Image_jinyan_x2 = ccui.Helper:seekWidgetByName(root, "Image_jinyan_x2")
    if Image_jinyan_x2 ~= nil then
        Image_jinyan_x2:setVisible(false)
        if _ED.active_activity[131] ~= nil and _ED.active_activity[131] ~= "" then
            Image_jinyan_x2:setVisible(true)
        end
    end

    local Image_huanxiang_x2 = ccui.Helper:seekWidgetByName(root, "Image_huanxiang_x2")
    if Image_huanxiang_x2 ~= nil then
        Image_huanxiang_x2:setVisible(false)
        if _ED.active_activity[133] ~= nil and _ED.active_activity[133] ~= "" then
            Image_huanxiang_x2:setVisible(true)
        end
    end

    local Image_ji_x2 = ccui.Helper:seekWidgetByName(root, "Image_ji_x2")
    if Image_ji_x2 ~= nil then
        Image_ji_x2:setVisible(false)
        if _ED.active_activity[132] ~= nil and _ED.active_activity[132] ~= "" then
            Image_ji_x2:setVisible(true)
        end
    end

    -- 更新标题信息
    local Panel_huodong_guaka_title_text = ccui.Helper:seekWidgetByName(root, "Panel_huodong_guaka_title_text")
    Panel_huodong_guaka_title_text:removeBackGroundImage()
    Panel_huodong_guaka_title_text:setBackGroundImage("images/ui/text/huodong_guanka_text_" .. self._current_page_index .. ".png")

    -- 更新背景信息
    local Panel_huodong_guaka_fun_pic = ccui.Helper:seekWidgetByName(root, "Panel_huodong_guaka_fun_pic")
    Panel_huodong_guaka_fun_pic:removeBackGroundImage()
    Panel_huodong_guaka_fun_pic:setBackGroundImage("images/ui/play/huodong_guanka_pic_box_" .. self._current_page_index .. ".png")

    -- 绘制副本信息
    local ListView_huodong_guaka_drop_icon = ccui.Helper:seekWidgetByName(root, "ListView_huodong_guaka_drop_icon")
    ListView_huodong_guaka_drop_icon:removeAllItems()
    self:onDrawRewardListView(ListView_huodong_guaka_drop_icon, dms.atos(self._current_scene, pve_scene.access_introduction))

    -- 剩余的挑战次数
    local nfCounts = {
        dms.string(dms["play_config"], 2, play_config.param),
        dms.string(dms["play_config"], 7, play_config.param),
        dms.string(dms["play_config"], 14, play_config.param),
        dms.string(dms["play_config"], 16, play_config.param),
    }

    if nil == _ED.activity_pve_times[349] then
        _ED.activity_pve_times[349] = dms.string(dms["play_config"], 14, play_config.param)
    end
    if nil == _ED.activity_pve_times[347] then
        _ED.activity_pve_times[347] = dms.string(dms["play_config"], 2, play_config.param)
    end
    if nil == _ED.activity_pve_times[348] then
        _ED.activity_pve_times[348] = dms.string(dms["play_config"], 7, play_config.param)
    end
    if nil == _ED.activity_pve_times[350] then
        _ED.activity_pve_times[350] = dms.string(dms["play_config"], 16, play_config.param)
    end

    local cnfCounts = {
        _ED.activity_pve_times[347],
        _ED.activity_pve_times[348],
        _ED.activity_pve_times[349],
        _ED.activity_pve_times[350],
    }
    local addTimes = 0
    if self._current_page_index == 1 then
        if _ED.active_activity[101] ~= nil and _ED.active_activity[101] ~= "" then
            addTimes = tonumber(_ED.active_activity[101].activity_Info[1].activityInfo_need_day)
        end
    elseif self._current_page_index == 2 then -- 经验副本次数增加
        if _ED.active_activity[128] ~= nil and _ED.active_activity[128] ~= "" then
            addTimes = tonumber(_ED.active_activity[128].activity_Info[1].activityInfo_need_day)
        end
    elseif self._current_page_index == 3 then -- 幻像挑战副本次数增加
        if _ED.active_activity[130] ~= nil and _ED.active_activity[130] ~= "" then
            addTimes = tonumber(_ED.active_activity[130].activity_Info[1].activityInfo_need_day)
        end
    elseif self._current_page_index == 4 then -- 幻像挑战副本次数增加
        if _ED.active_activity[129] ~= nil and _ED.active_activity[129] ~= "" then
            addTimes = tonumber(_ED.active_activity[129].activity_Info[1].activityInfo_need_day)
        end
    end

    local Text_huodong_guaka_have_time = ccui.Helper:seekWidgetByName(root, "Text_huodong_guaka_have_time")
    Text_huodong_guaka_have_time:setVisible(true)
    local Text_huodong_guaka_have_time_n = ccui.Helper:seekWidgetByName(root, "Text_huodong_guaka_have_time_n")
    local nfCount = cnfCounts[self._current_page_index] or "0"
    local allCounts = tonumber(nfCounts[self._current_page_index]) + tonumber(addTimes)
    
    Text_huodong_guaka_have_time_n:setString("" .. nfCount .. "/" .. allCounts)
    Text_huodong_guaka_have_time_n:setVisible(true)


    local Text_huodong_guaka_cd_time = ccui.Helper:seekWidgetByName(root, "Text_huodong_guaka_cd_time")
    Text_huodong_guaka_cd_time:setVisible(false)

    local Text_huodong_guaka_cd_time_n = ccui.Helper:seekWidgetByName(root, "Text_huodong_guaka_cd_time_n")
    Text_huodong_guaka_cd_time_n:setVisible(false)

    local Button_huodong_guaka_join = ccui.Helper:seekWidgetByName(root, "Button_huodong_guaka_join")
    if self._is_time_opened == true then

        Button_huodong_guaka_join:setBright(true)
        Button_huodong_guaka_join:setHighlighted(false)
        Button_huodong_guaka_join:setTouchEnabled(true)
    else
        Button_huodong_guaka_join:setBright(false)
        Button_huodong_guaka_join:setHighlighted(true)
        Button_huodong_guaka_join:setTouchEnabled(false)
    end


    self._interval = nil
    if tonumber(nfCount) > 0 then
        if nil ~= _ED._activity_copy_battle_wait_cds then
            local cdtime = zstring.tonumber(_ED._activity_copy_battle_wait_cds[self._current_page_index])
            if cdtime > 0 then
                local interval = cdtime / 1000 - (_ED.system_time + (os.time() - _ED.native_time))
                if interval > 0 then
                    Text_huodong_guaka_have_time:setVisible(false)
                    Text_huodong_guaka_have_time_n:setVisible(false)
                    Text_huodong_guaka_cd_time:setVisible(true)
                    Text_huodong_guaka_cd_time_n:setVisible(true)

                    self._interval = interval
                    self._last_interval = interval
                    self._Text_huodong_guaka_cd_time_n = Text_huodong_guaka_cd_time_n
                    self._Text_huodong_guaka_cd_time_n:setString(self:formatTimeString(self._interval))
                end
            end
        end
    end
    Text_huodong_guaka_have_time:setString(self.initialText)
    Text_huodong_guaka_have_time:setPositionX(self.initialPosX)
    if self._current_page_index == 3 or self._current_page_index == 4 then
        local Button_huodong_guaka = ccui.Helper:seekWidgetByName(root, "Button_huodong_guaka_" .. self._current_page_index)
        local Image_open_day = ccui.Helper:seekWidgetByName(Button_huodong_guaka, "Image_open_day_" .. self._current_page_index)
        if Image_open_day:isVisible() == true then
            -- Text_huodong_guaka_cd_time_n:setVisible(false)
            -- Text_huodong_guaka_cd_time:setVisible(false)
            if self._interval and self._interval > 0 then
                Text_huodong_guaka_have_time:setVisible(false)
                Text_huodong_guaka_have_time_n:setVisible(false)
            else
                Text_huodong_guaka_have_time:setVisible(true)
                Text_huodong_guaka_have_time_n:setVisible(true)
            end
            --活动没开始
            if self._is_time_opened == false then
                Text_huodong_guaka_have_time:setString(_new_interface_text[127 + self._current_page_index])
                Text_huodong_guaka_have_time_n:setVisible(false)
                Text_huodong_guaka_cd_time:setVisible(false)
                Text_huodong_guaka_cd_time_n:setVisible(false)
            end
            
            -- if verifySupportLanguage(_lua_release_language_en) == true then
            -- else
            --     local currX = Button_huodong_guaka_join:getPositionX() - Button_huodong_guaka_join:getContentSize().width / 2 
            --     Text_huodong_guaka_have_time:setPositionX(currX - Text_huodong_guaka_have_time:getAutoRenderSize().width - 10)
            -- end
        end
    end


    -- local Button_huodong_guaka_join = ccui.Helper:seekWidgetByName(root, "Button_huodong_guaka_join")
    -- if nil ~= self._interval then
    --     Button_huodong_guaka_join:setBright(false);
    --     Button_huodong_guaka_join:setTouchEnabled(false)
    -- else
    --     Button_huodong_guaka_join:setBright(true);
    --     Button_huodong_guaka_join:setTouchEnabled(true)
    -- end
end

function ActivityCopyWindow:formatTimeString(_time)  --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function ActivityCopyWindow:onUpdate(dt)
    if nil ~= self._interval then
        self._interval = self._interval - dt
        if self._last_interval - self._interval > 0.5 then
            self._last_interval = self._interval
            if self._interval < 0 then
                self:onUpdateDraw()
            else
                self._Text_huodong_guaka_cd_time_n:setString(self:formatTimeString(self._interval))
            end
        end
    end
end

function ActivityCopyWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/huodong_guaka_fb.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_daoju_back"), nil, 
    {
        terminal_name = "activity_copy_window_close", 
        isPressedActionEnabled = true
    },
    nil,0)

    -- 帮助信息
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_huodong_guaka_help"), nil, 
    {
        terminal_name = "activity_copy_window_show_help_dailog", 
        isPressedActionEnabled = true
    },
    nil,0)

    -- 挑战
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_huodong_guaka_join"), nil, 
    {
        terminal_name = "activity_copy_window_join_battle", 
        isPressedActionEnabled = true
    },
    nil,0)

    local Text_huodong_guaka_have_time = ccui.Helper:seekWidgetByName(root, "Text_huodong_guaka_have_time")
    if self.initialText == nil then
        self.initialText = Text_huodong_guaka_have_time:getString()
        self.initialPosX = Text_huodong_guaka_have_time:getPositionX()
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        local scenes = {
            dms.searchs(dms["pve_scene"], pve_scene.scene_type, "2")[1],
            dms.searchs(dms["pve_scene"], pve_scene.scene_type, "3")[1],
            dms.searchs(dms["pve_scene"], pve_scene.scene_type, "51")[1],
            dms.searchs(dms["pve_scene"], pve_scene.scene_type, "52")[1]
        }
        for i=1,4 do
            if #scenes >= i then
                local needLevel = dms.atoi(scenes[i], pve_scene.open_level)
                local isOpened = needLevel <= tonumber(_ED.user_info.user_grade)
                local Button_huodong_guaka = ccui.Helper:seekWidgetByName(root, "Button_huodong_guaka_" .. i)
                local isTimeOpened = true
                if isOpened then
                    if i == 3 or i == 4 then
                        isTimeOpened = false
                        local current = _ED.system_time + (os.time() - _ED.native_time) - 5*60*60
                        -- local weekDay = os.date("%w",os.time())
                        local weekDay = tonumber(os.date("%w", getBaseGTM8Time(current)))
                        if weekDay == 0 then
                            weekDay = 7
                        end
                        local openNeedWeedDays = nil
                        if i == 3 then
                            openNeedWeedDays = zstring.split(dms.string(dms["play_config"], 13, play_config.param), ",")
                        else
                            openNeedWeedDays = zstring.split(dms.string(dms["play_config"], 15, play_config.param), ",")
                        end
                        for w, d in pairs(openNeedWeedDays) do
                            if tonumber(d) == weekDay then
                                isTimeOpened = true
                                break
                            end
                        end

                        if false == isTimeOpened then
                            local Image_open_day = ccui.Helper:seekWidgetByName(Button_huodong_guaka, "Image_open_day_" .. i)
                            if nil ~= Image_open_day then
                                Image_open_day:setVisible(true)
                            end
                        end
                    end
                end

                fwin:addTouchEventListener(Button_huodong_guaka, nil, 
                {
                    terminal_name = "activity_copy_window_change_to_page", 
                    page_index = i,
                    scene = scenes[i],
                    is_opened = isOpened,
                    is_time_opened = isTimeOpened,
                    button = Button_huodong_guaka, 
                    isPressedActionEnabled = true
                },
                nil,0)
                
                local Text_guaka_lock_lv = ccui.Helper:seekWidgetByName(Button_huodong_guaka, "Text_guaka_lock_lv_" .. i)
                local tinfo = Text_guaka_lock_lv:getString()
                Text_guaka_lock_lv:setString("" .. tinfo .. needLevel)
                
                -- if __lua_project_id == __lua_project_l_pokemon then
                --     Text_guaka_lock_lv:setString("Lv." .. needLevel .. tinfo)
                -- end
                
                if true == isOpened then -- 解锁的选项
                    local Image_guaka_lock = ccui.Helper:seekWidgetByName(Button_huodong_guaka, "Image_guaka_lock_" .. i)
                    Image_guaka_lock:setVisible(false)
                    Text_guaka_lock_lv:setVisible(false)
                else
                    Text_guaka_lock_lv:setVisible(true)
                    Button_huodong_guaka:setBright(false)
                    -- Button_huodong_guaka:setTouchEnabled(false)
                    local Sprite_guaka_text_1 = Button_huodong_guaka:getChildByName("Sprite_guaka_text_1") -- 未选中
                    display:gray(Sprite_guaka_text_1)
                    local Sprite_guaka_exp_icon = Button_huodong_guaka:getChildByName("Sprite_guaka_exp_icon")
                    if nil ~= Sprite_guaka_exp_icon then
                        display:gray(Sprite_guaka_exp_icon)
                    end
                end
            end
            -- if self._current_page_index == 1 then
                local Image_jinbi_x2 = ccui.Helper:seekWidgetByName(root, "Image_jinbi_x2")
                if Image_jinbi_x2 ~= nil then
                    Image_jinbi_x2:setVisible(false)
                    if _ED.active_activity[99] ~= nil and _ED.active_activity[99] ~= "" then
                        Image_jinbi_x2:setVisible(true)
                    end
                end
            -- elseif self._current_page_index == 2 then
                local Image_jinyan_x2 = ccui.Helper:seekWidgetByName(root, "Image_jinyan_x2")
                if Image_jinyan_x2 ~= nil then
                    Image_jinyan_x2:setVisible(false)
                    if _ED.active_activity[131] ~= nil and _ED.active_activity[131] ~= "" then
                        Image_jinyan_x2:setVisible(true)
                    end
                end
            -- elseif self._current_page_index == 3 then
                local Image_huanxiang_x2 = ccui.Helper:seekWidgetByName(root, "Image_huanxiang_x2")
                if Image_huanxiang_x2 ~= nil then
                    Image_huanxiang_x2:setVisible(false)
                    if _ED.active_activity[133] ~= nil and _ED.active_activity[133] ~= "" then
                        Image_huanxiang_x2:setVisible(true)
                    end
                end
            -- elseif self._current_page_index == 4 then
                local Image_ji_x2 = ccui.Helper:seekWidgetByName(root, "Image_ji_x2")
                if Image_ji_x2 ~= nil then
                    Image_ji_x2:setVisible(false)
                    if _ED.active_activity[132] ~= nil and _ED.active_activity[132] ~= "" then
                        Image_ji_x2:setVisible(true)
                    end
                end
            -- end
        end
    else
        local ListView_huodong_guaka = ccui.Helper:seekWidgetByName(root, "ListView_huodong_guaka")
        local items = ListView_huodong_guaka:getItems()
        local scenes = {
            dms.searchs(dms["pve_scene"], pve_scene.scene_type, "2")[1],
            dms.searchs(dms["pve_scene"], pve_scene.scene_type, "3")[1],
            dms.searchs(dms["pve_scene"], pve_scene.scene_type, "51")[1],
            dms.searchs(dms["pve_scene"], pve_scene.scene_type, "52")[1]
        }
        for i, v in pairs(items) do
            if v:isVisible() and #scenes >= i then
                local needLevel = dms.atoi(scenes[i], pve_scene.open_level)
                local isOpened = needLevel <= tonumber(_ED.user_info.user_grade)
                local Button_huodong_guaka = ccui.Helper:seekWidgetByName(root, "Button_huodong_guaka_" .. i)
                local isTimeOpened = true
                if isOpened then
                    if i == 3 or i == 4 then
                        isTimeOpened = false
                        local current = _ED.system_time + (os.time() - _ED.native_time) - 5*60*60
                        -- local weekDay = os.date("%w",os.time())
                        local weekDay = tonumber(os.date("%w", getBaseGTM8Time(current)))
                        if weekDay == 0 then
                            weekDay = 7
                        end
                        local openNeedWeedDays = nil
                        if i == 3 then
                            openNeedWeedDays = zstring.split(dms.string(dms["play_config"], 13, play_config.param), ",")
                        else
                            openNeedWeedDays = zstring.split(dms.string(dms["play_config"], 15, play_config.param), ",")
                        end
                        for w, d in pairs(openNeedWeedDays) do
                            if tonumber(d) == weekDay then
                                isTimeOpened = true
                                break
                            end
                        end

                        if false == isTimeOpened then
                            local Image_open_day = ccui.Helper:seekWidgetByName(Button_huodong_guaka, "Image_open_day_" .. i)
                            if nil ~= Image_open_day then
                                Image_open_day:setVisible(true)
                            end
                        end
                    end
                end

                fwin:addTouchEventListener(Button_huodong_guaka, nil, 
                {
                    terminal_name = "activity_copy_window_change_to_page", 
                    page_index = i,
                    scene = scenes[i],
                    is_opened = isOpened,
                    is_time_opened = isTimeOpened,
                    button = Button_huodong_guaka, 
                    isPressedActionEnabled = true
                },
                nil,0)
                
                local Text_guaka_lock_lv = ccui.Helper:seekWidgetByName(Button_huodong_guaka, "Text_guaka_lock_lv_" .. i)
                local tinfo = Text_guaka_lock_lv:getString()
                Text_guaka_lock_lv:setString("" .. tinfo .. needLevel)
                -- if ((__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and app.configJson.ReleaseLanguage == "en") or __lua_project_id == __lua_project_l_naruto then
                --     Text_guaka_lock_lv:setString("" .. tinfo .. needLevel)
                -- end
                
                if true == isOpened then -- 解锁的选项
                    local Image_guaka_lock = ccui.Helper:seekWidgetByName(Button_huodong_guaka, "Image_guaka_lock_" .. i)
                    Image_guaka_lock:setVisible(false)
                    Text_guaka_lock_lv:setVisible(false)
                else
                    Text_guaka_lock_lv:setVisible(true)
                    Button_huodong_guaka:setBright(false)
                    -- Button_huodong_guaka:setTouchEnabled(false)
                    local Sprite_guaka_text_1 = Button_huodong_guaka:getChildByName("Sprite_guaka_text_1") -- 未选中
                    display:gray(Sprite_guaka_text_1)
                    local Sprite_guaka_exp_icon = Button_huodong_guaka:getChildByName("Sprite_guaka_exp_icon")
                    if nil ~= Sprite_guaka_exp_icon then
                        display:gray(Sprite_guaka_exp_icon)
                    end
                end
            end
        end
    end

    -- self:onUpdateDraw()
    local Button_huodong_guaka = ccui.Helper:seekWidgetByName(root, "Button_huodong_guaka_" .. 1)
    state_machine.excute("activity_copy_window_change_to_page", 0, Button_huodong_guaka)


    -- 绘制顶部用户信息栏
    local userInformationHeroStorage = UserInformationHeroStorage:new()
    userInformationHeroStorage._rootWindows = self
    fwin:open(userInformationHeroStorage,fwin._view)
end

function ActivityCopyWindow:onExit()
    state_machine.remove("activity_copy_window_change_to_page")
    state_machine.remove("activity_copy_window_open_fun_window")
    state_machine.remove("activity_copy_window_lock_fun_window")
    state_machine.remove("activity_copy_window_show_help_dailog")
    state_machine.remove("activity_copy_window_join_battle")
    state_machine.remove("activity_copy_window_check_battle_cd")
    state_machine.remove("activity_copy_window_on_update_draw")
end

function ActivityCopyWindow:destroy(window)
    state_machine.excute("explore_window_show")
end
