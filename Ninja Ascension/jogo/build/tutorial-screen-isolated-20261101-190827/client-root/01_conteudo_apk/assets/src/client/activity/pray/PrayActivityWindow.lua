--[[ ----------------------------------------------------------------------------
-- 祈福窗口
--]] ----------------------------------------------------------------------------
PrayActivityWindow = class("PrayActivityWindowClass", Window)

-- 打开窗口
local pray_activity_window_open_terminal = {
    _name = "pray_activity_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("PrayActivityWindowClass") then
            fwin:open(PrayActivityWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local pray_activity_window_close_terminal = {
    _name = "pray_activity_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PrayActivityWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pray_activity_window_open_terminal)
state_machine.add(pray_activity_window_close_terminal)
state_machine.init()

-- 构造器
function PrayActivityWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self.deltaTime = 1
    self.totalTime = 0
    self.activityEndTime = nil
    self.selectPage = 0
    self._activityInfo = nil
    -- load lua files.
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.activity.pray.PrayUserTopInfo")
    app.load("client.activity.pray.PrayActivityRule")
    app.load("client.activity.pray.pray_activity_goods_cell")
    app.load("client.activity.pray.pray_activity_box_cell")
    app.load("client.activity.pray.pray_activity_list_cell")
    app.load("client.shop.recruit.HeroRecruitSuccess")
    app.load("client.shop.recruit.HeroRecruitSuccessTen")
    app.load("client.activity.pray.PrayActivityNotice")
    app.load("client.activity.pray.PrayActivityGetTip")
    app.load("client.activity.pray.PrayActivityChoice")

    -- Initialize pray activity window page state machine.
    local function init_pray_activity_window_terminal()
        -- 显示窗口
        local pray_activity_window_show_terminal = {
            _name = "pray_activity_window_show",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 显示窗口
                if nil ~= instance then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏窗口
        local pray_activity_window_hide_terminal = {
            _name = "pray_activity_window_hide",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 隐藏窗口
                if nil ~= instance then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切页面
        local pray_activity_window_change_page_terminal = {
            _name = "pray_activity_window_change_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance and params then
                    local mPage = params._datas.m_page
                    instance:onShowPage(mPage)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击抽取
        local pray_activity_window_click_extract_terminal = {
            _name = "pray_activity_window_click_extract",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance and params then
                    local times = params._datas.m_times
                    local m_type = params._datas.m_type
                    if not instance:haveEnoughProp(times) then
                        -- 提示跳转任务界面
                        state_machine.excute("pray_activity_get_tip_window_open", 0, "")
                        return true
                    end
                    local state = instance:getCanExtract()
                    if not state then
                        -- 提示选择奖励
                        TipDlg.drawTextDailog(tipStringInfo_limit_pray_activity_tips[3])
                        return true
                    end
                    if fwin:find("HeroRecruitSuccessClass") ~= nil then
                        fwin:close(fwin:find("HeroRecruitSuccessClass"))
                    end

                    if fwin:find("HeroRecruitSuccessTenClass") ~= nil then
                        fwin:close(fwin:find("HeroRecruitSuccessTenClass"))
                    end 
                    state_machine.lock("pray_activity_window_click_extract")
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then                               
                                getSceneReward(64)
                                _ED.show_reward_list_group_ex = {}
                                if times == 1 then
                                    local obj = HeroRecruitSuccess:new()
                                    obj:setRanking(herorIndex, m_type, true)
                                    fwin:open(obj, fwin._ui)
                                elseif times == 10 then
                                    local obj = HeroRecruitSuccessTen:new()
                                    obj:setRanking(herorIndex, m_type, true)
                                    fwin:open(obj, fwin._ui)
                                end

                                state_machine.excute("menu_hide_event", 0, "menu_hide_event.")

                                state_machine.excute("pray_activity_window_refush_box", 0, "")
                                state_machine.excute("pray_activity_window_refush_prop_info", 0, "")
                                state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 180)
                                fwin:addService(
                                    {
                                        callback = function(params)
                                            state_machine.excute("notification_center_update", 0, "push_notification_limit_pray_page_push")
                                        end,
                                        delay = 0
                                    }
                                )
                            end
                            state_machine.unlock("pray_activity_window_click_extract")
                        else
                            state_machine.unlock("pray_activity_window_click_extract")
                        end
                        _ED.prop_chest_store_recruiting = false
                    end
                    _ED.new_prop_object = {}
                    _ED.recruit_success_ship_id = nil
                    _ED.new_reward_object = {}
                    _ED.prop_chest_store_recruiting = true

                    protocol_command.limit_blessing_draw.param_list = "" .. times
                    NetworkManager:register(protocol_command.limit_blessing_draw.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 主界面刷新
        local pray_activity_window_refush_view_terminal = {
            _name = "pray_activity_window_refush_view",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    local mType = nil 
                    if params and params.mType then 
                        mType = params.mType 
                    end
                    if mType and mType == 1 then 
                        instance:onRefreshView(1)
                    else
                        instance:onRefreshView()
                    end

                    state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 180)
                    fwin:addService(
                        {
                            callback = function(params)
                                state_machine.excute("notification_center_update", 0, "push_notification_limit_pray_page_push")
                            end,
                            delay = 0
                        }
                    )
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pray_activity_window_refush_box_terminal = {
            _name = "pray_activity_window_refush_box",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    instance:drawBoxView()
                    state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 180)
                    fwin:addService(
                        {
                            callback = function(params)
                                state_machine.excute("notification_center_update", 0, "push_notification_limit_pray_page_push")
                            end,
                            delay = 0
                        }
                    )
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pray_activity_window_refush_prop_info_terminal = {
            _name = "pray_activity_window_refush_prop_info",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    instance:drawUiInfo()
                    instance:refushExactRed()
                    state_machine.excute("pray_user_top_info_refresh_prop_count", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pray_activity_window_refush_select_reward_terminal = {
            _name = "pray_activity_window_refush_select_reward",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    instance:drawWishReward()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(pray_activity_window_show_terminal)
        state_machine.add(pray_activity_window_hide_terminal)
        state_machine.add(pray_activity_window_change_page_terminal)
        state_machine.add(pray_activity_window_click_extract_terminal)
        state_machine.add(pray_activity_window_refush_view_terminal)
        state_machine.add(pray_activity_window_refush_box_terminal)
        state_machine.add(pray_activity_window_refush_prop_info_terminal)
        state_machine.add(pray_activity_window_refush_select_reward_terminal)
        state_machine.init()
    end
    -- call func init pray activity window state machine.
    init_pray_activity_window_terminal()
end

-- 对象初始化
function PrayActivityWindow:init(params)
    self._activityInfo = _ED.active_activity[180].activity_data
    self.activityEndTime = _ED.active_activity[180].end_time
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function PrayActivityWindow:onUpdate(dt)
    self.totalTime = self.totalTime + dt
    if self.totalTime >= self.deltaTime then
        self:updateActivityRemainTime()
        self:updateRunHouse()
        self.totalTime = 0
    end
end

function PrayActivityWindow:updateActivityRemainTime()
    if self.Text_time == nil or self.activityEndTime == nil then
        return
    end
    local surplus_time = (self.activityEndTime - (os.time() + _ED.time_add_or_sub) * 1000)
    self.Text_time:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function PrayActivityWindow:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.floor((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .. _string_piece_info[231]
    end
    if _hourTime < 10 then
        timeString = timeString .. "0" .. _hourTime .. ":"
    else
        timeString = timeString .. _hourTime .. ":"
    end

    if _minutesTime < 10 then
        timeString = timeString .. "0" .. _minutesTime .. ":"
    else
        timeString = timeString .. _minutesTime .. ":"
    end

    if _secondsTime < 10 then
        timeString = timeString .. "0" .. _secondsTime
    else
        timeString = timeString .. _secondsTime
    end
    return timeString
end

-- 刷新跑马灯信息
function PrayActivityWindow:updateRunHouse()
    if not self.Panel_paomadeng then
        return
    end
    local houseDatas = _ED.active_activity[180].notice

    if nil == houseDatas or 0 == #houseDatas then
        self.Panel_paomadeng:setVisible(false)
        return
    end
    if houseDatas and _ED.active_activity[180].notice_update then
        _ED.active_activity[180].notice_update = false
        if #houseDatas >= 2 then
            local function sortFunction(a, b)
                if tonumber(a.updateTime) > tonumber(b.updateTime) then
                    return true
                end
                return false
            end

            table.sort(houseDatas, sortFunction)
        end

        self.Panel_paomadeng:removeAllChildren(true)
        local cell = state_machine.excute("activity_pray_push_notice_list_create", 0, houseDatas)
        cell:setAnchorPoint(cc.p(0, 0))
        self.Panel_paomadeng:addChild(cell)
        self.Panel_paomadeng:setVisible(true)
    end
end

function PrayActivityWindow:onUpdateDraw()
    local root = self.roots[1]

    -- 祈福大奖展示动画
    self.Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")

    -- 超值礼包分页显示容器
    self.Panel_libao = ccui.Helper:seekWidgetByName(root, "Panel_libao")

    -- 超值礼包列表容器
    self.ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")

    -- 活跃任务分页显示容器
    self.Panel_renwu = ccui.Helper:seekWidgetByName(root, "Panel_renwu")

    -- 活跃任务列表容器
    self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

    -- 限时祈福分页显示容器
    self.Panel_qifu = ccui.Helper:seekWidgetByName(root, "Panel_qifu")

    -- 活动剩余时间显示
    self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")

    -- 稀有物品框道具显示
    self.Panel_red_1 = ccui.Helper:seekWidgetByName(root, "Panel_red_1")

    -- 稀有物品框动画显示
    self.Panel_red_effect = ccui.Helper:seekWidgetByName(root, "Panel_red_effect")

    -- 选择物品panel
    self.Panel_bule = {}
    for i = 1, 8 do
        self.Panel_bule[i] = ccui.Helper:seekWidgetByName(root, "Panel_bule_" .. i)
    end

    -- 祈福值宝箱进度条
    self.LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")

    -- 祈福值显示
    self.Text_qifuzhi = ccui.Helper:seekWidgetByName(root, "Text_qifuzhi")

    -- 宝箱显示容器
    self.Panel_box = ccui.Helper:seekWidgetByName(root, "Panel_box")

    -- 单抽道具剩余数量显示
    self.Text_surplus_1 = ccui.Helper:seekWidgetByName(root, "Text_surplus_1")

    -- 十抽道具剩余数量显示
    self.Text_surplus_2 = ccui.Helper:seekWidgetByName(root, "Text_surplus_2")

    self.Panel_paomadeng = ccui.Helper:seekWidgetByName(root, "Panel_paomadeng")
    self.Image_tip_bg = ccui.Helper:seekWidgetByName(root, "Image_tip_bg")
    self.Image_role_black = ccui.Helper:seekWidgetByName(root, "Image_role_black")
    self.Text_role_tip = ccui.Helper:seekWidgetByName(root, "Text_role_tip")

    state_machine.excute("pray_user_top_info_open", 0, self)
end

-- 是否选择奖励
function PrayActivityWindow:getCanExtract()
    self._activityInfo = _ED.active_activity[180].activity_data
    if self._activityInfo.wishRewardList then
        for k, v in pairs(self._activityInfo.wishRewardList) do
            if tostring(v.wishState) == "-1" then
                return false
            end
        end
        return true
    else
        return nil
    end
end

-- 道具是否满足
function PrayActivityWindow:haveEnoughProp(times)
    local propID = dms.string(dms["activity_config"], 84, activity_config.param)
    local needCount = times
    local havePropNum = tonumber(getPropAllCountByMouldId(propID))

    return havePropNum >= needCount
end

function PrayActivityWindow:playAnimations(sender, file, loop, mScale, pos)
    sender:removeAllChildren()
    local jsonFile = file .. ".json"
    local atlasFile = file .. ".atlas"
    local aniName = "animation"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, loop, nil)
    if pos then 
        animation:setPosition(pos)
    else
        animation:setPosition(cc.p(sender:getContentSize().width/2, 0))
    end
    if mScale then 
        animation:setScale(mScale)
    else
        animation:setScale(0.8)
    end
    
    sender:addChild(animation)
end

function PrayActivityWindow:onShowPage(mPage)
    if mPage == self.selectPage then
        return
    end
    self.selectPage = mPage
    self.Button_qifu:setTouchEnabled(true)
    self.Button_qifu:setHighlighted(false)
    self.Button_renwu:setTouchEnabled(true)
    self.Button_renwu:setHighlighted(false)
    self.Button_libao:setTouchEnabled(true)
    self.Button_libao:setHighlighted(false)
    self.Panel_qifu:setVisible(false)
    self.Panel_renwu:setVisible(false)
    self.Panel_libao:setVisible(false)
    if self.selectPage == 1 then
        self:drawPageFirst()
        self.Panel_qifu:setVisible(true)
        self.Button_qifu:setTouchEnabled(false)
        self.Button_qifu:setHighlighted(true)
    elseif self.selectPage == 2 then
        if self.pageTaskItem == nil then
            self.pageTaskItem = self:drawPageTask()
        end

        self.Panel_renwu:setVisible(true)
        self.Button_renwu:setTouchEnabled(false)
        self.Button_renwu:setHighlighted(true)
    elseif self.selectPage == 3 then
        if self.pageBagItem == nil then
            self.pageBagItem = self:drawPageBag()
        end
        self.Panel_libao:setVisible(true)
        self.Button_libao:setTouchEnabled(false)
        self.Button_libao:setHighlighted(true)
    end
    state_machine.excute("pray_activity_window_refush_prop_info", 0, nil)
end

-- 祈福页面
function PrayActivityWindow:drawPageFirst()
    self:drawWishReward()
    self:drawBoxView()
    return true
end

function PrayActivityWindow:drawBoxView()
    self._activityInfo = _ED.active_activity[180].activity_data
    local infos = self._activityInfo.boxRewardList
    local curVal = tonumber(self._activityInfo.userWishVal)
    local maxVal = tonumber(infos[table.nums(infos)].boxAim)

    -- self.LoadingBar_1:setPercent(math.floor((curVal / maxVal) * 100))
    local loadBarWidth = self.Panel_box:getContentSize().width
    self.Panel_box:removeAllChildren()
    local disNums = #infos
    local averDistance = math.floor(loadBarWidth / disNums)
    local posX = 0
    local completedNum = 0
    for i, v in ipairs(infos) do
        local curGearVal = tonumber(v.boxAim)
        -- local posX = math.floor((curGearVal / maxVal) * loadBarWidth)
        local cell = state_machine.excute("pray_activity_box_cell_create", 0, {boxInfo = v})
        posX = posX + averDistance
        cell:setPositionX(posX)
        self.Panel_box:addChild(cell)
        if v.boxState == 1 or v.boxState == 2 then
            completedNum = completedNum + 1
        end
    end
    self.LoadingBar_1:setPercent((completedNum /  disNums ) * 100)
    self.Text_qifuzhi:setString(curVal)
end

-- 八个奖励列表
function PrayActivityWindow:drawWishReward()
    local infos = _ED.active_activity[180].activity_data
    -- 特殊奖励
    self.Panel_role:removeAllChildren(true)
    local rewardData = infos.wishRewardList[1]
    local selectReward = nil
    if rewardData.wishState == -1 then
        self.Image_tip_bg:setVisible(false)
        self.Text_role_tip:setVisible(false)
        self.Image_role_black:setVisible(true)
        
        local filePath = "images/ui/effice/effect_xianshiqiyuan_tips/effect_xianshiqiyuan_tips"
        self:playAnimations(self.Panel_red_effect,filePath,true,1,cc.p(self.Panel_red_effect:getContentSize().width/2,self.Panel_red_effect:getContentSize().height/2))
    else
        self.Panel_red_effect:removeAllChildren(true)
        self.Image_tip_bg:setVisible(true)
        self.Text_role_tip:setVisible(true)
        self.Image_role_black:setVisible(false)
        for i, v in ipairs(rewardData.wishReward) do
            if i == rewardData.wishState then
                selectReward = v
                break
            end
        end
        local handleReward = zstring.split(selectReward, ",")
        if tonumber(handleReward[1]) == 6 then
            local propData = dms.element(dms["prop_mould"], tonumber(handleReward[2]))
            local shipMouldId = dms.atoi(propData, prop_mould.use_of_ship)
            if dms.atoi(propData, prop_mould.storage_page_index) == 18 and shipMouldId > 0 then
                -- 武将碎片
                self:showRoleAni(shipMouldId)
            else
                local animalId = nil
                local data = dms["magical_animals_mould"]
                for _, v in ipairs(data) do
                    local aId = dms.atof(v, magical_animals_mould.id)
                    local upStarGoupId = tonumber(dms.atof(v, magical_animals_mould.upStarGoupId))
                    for m, n in ipairs(dms["magical_animals_star_mould"]) do
                        local groupId = dms.atof(n, magical_animals_star_mould.groupId)
                        if groupId == upStarGoupId then
                            local nextId = dms.atof(n, magical_animals_star_mould.nextId)
                            if nextId ~= -1 then
                                local costPropStr = dms.string(dms["magical_animals_star_mould"], nextId, magical_animals_star_mould.costProp)
                                local costProp = zstring.split(costPropStr, ",")
                                local costId = costProp[2]
                                if tonumber(handleReward[2]) == tonumber(costId) then 
                                    animalId = aId
                                    break
                                end
                            end
                        end
                    end
                    if animalId ~= nil then 
                        break
                    end
                end
                if animalId ~= nil then 
                    -- 神兽碎片
                    local spriteId = dms.int(dms["magical_animals_mould"], animalId, magical_animals_mould.spriteId)
                    local hero_animation = sp.spine_sprite(self.Panel_role, spriteId, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
                    hero_animation.animationNameList = spineAnimations
                    sp.initArmature(hero_animation, true)
                else
                    -- 普通道具
                    local filePath = "images/ui/effice/effect_xianshiqiyuan_daoju/effect_xianshiqiyuan_daoju"
                    self:playAnimations(self.Panel_role, filePath, true)
                end
            end
        elseif tonumber(handleReward[1]) == 7 then
            local filePath = "images/ui/effice/effect_xianshiqiyuan_wuqi/effect_xianshiqiyuan_wuqi"
            self:playAnimations(self.Panel_role, filePath, true)
        elseif tonumber(handleReward[1]) == 13 then
            local mouldId = tonumber(handleReward[2])
            self:showRoleAni(mouldId)
        elseif tonumber(handleReward[1]) == 71 then
            local filePath = "images/ui/effice/effect_xianshiqiyuan_renju/effect_xianshiqiyuan_renju"
            self:playAnimations(self.Panel_role, filePath, true)
        end
    end
    local function rewardTouchCallback(sender, eventType)
        if eventType == ccui.TouchEventType.ended 
        or eventType == ccui.TouchEventType.canceled
        then
            state_machine.excute("pray_activity_choice_window_open", 0, {mPos = 1, mType = 1, awardInfo = rewardData})
        end
    end
    
    self.Panel_role:addTouchEventListener(rewardTouchCallback)
    for i, v in ipairs(self.Panel_bule) do
        v:removeAllChildren(true)
        local cell = state_machine.excute("pray_activity_goods_cell_create", 0, {mType = 1, mInfo = {mIndex = i, rewardInfo = infos.wishRewardList[i]}})
        v:addChild(cell)
    end
end

function PrayActivityWindow:showRoleAni(mouldId)
    local evo_image = dms.string(dms["ship_mould"], mouldId, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local evo_mould_id = evo_info[dms.int(dms["ship_mould"], mouldId, ship_mould.captain_name)]
    --新的形象编号
    local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

    self.Panel_role:removeAllChildren()
    local armature_hero = sp.spine_sprite(self.Panel_role, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
    armature_hero:setScaleX(-1.3)
    armature_hero:setScaleY(1.3)
    armature_hero.animationNameList = spineAnimations
    sp.initArmature(armature_hero, true)
end

function PrayActivityWindow:drawUiInfo()
    local propID = dms.string(dms["activity_config"], 84, activity_config.param)
    local needCount = 1
    local havePropNum = tonumber(getPropAllCountByMouldId(propID))

    self.Text_surplus_1:setString(havePropNum .. "/" .. needCount)
    self.Text_surplus_2:setString(havePropNum .. "/" .. (needCount * 10))
end
-- 任务界面
function PrayActivityWindow:drawPageTask()
    local infos = self._activityInfo
    local taskInfos = nil
    self.ListView_1:removeAllItems()
    local taskCanReward = {}
    local taskUnAim = {}
    local taskHaveReward = {}
    for i, v in ipairs(infos.taskInfos) do
        local cell = state_machine.excute("pray_activity_list_cell_create", 0, {mType = 1, mInfo = v})
        if v.state == 0 then
            table.insert(taskUnAim, cell)
        elseif v.state == 1 then
            table.insert(taskCanReward, cell)
        elseif v.state == 2 then
            table.insert(taskHaveReward, cell)
        end
    end
    local taskResult = {}
    for k, v in pairs(taskCanReward) do
        table.insert(taskResult, v)
    end
    for k, v in pairs(taskUnAim) do
        table.insert(taskResult, v)
    end
    for k, v in pairs(taskHaveReward) do
        table.insert(taskResult, v)
    end

    for i, v in ipairs(taskResult) do
        self.ListView_1:addChild(v)
    end
    self.ListView_1:jumpToTop()
    self.ListView_1:requestRefreshView()
    return true
end

function PrayActivityWindow:sortFunc(items)
    local result = items
    local function sortHandle(a, b)
        if tonumber(a.gear) < tonumber(b.gear) then
            return true
        else
            return false
        end
    end

    table.sort(result, sortHandle)
    return result
end

-- 礼包界面
function PrayActivityWindow:drawPageBag()
    local infos = {}
    for k, v in pairs(self._activityInfo.userSpreeReward) do
        table.insert(infos, v)
    end
    infos = self:sortFunc(infos)
    local bagCanReward = {}
    local bagUnAim = {}
    local bagHaveReward = {}
    self.ListView_2:removeAllItems()
    for i = 1, table.nums(infos) do
        local data = infos[i]
        local cell = state_machine.excute("pray_activity_list_cell_create", 0, {mType = 2, mInfo = data})
        if tonumber(data.canFinish) > 0 then
            if data.state == 0 then
                table.insert(bagUnAim, cell)
            elseif data.state == 1 then
                table.insert(bagCanReward, cell)
            elseif data.state == 2 then
                table.insert(bagHaveReward, cell)
            end
        else
            table.insert(bagHaveReward, cell)
        end
    end
    local bagResult = {}
    for k, v in pairs(bagCanReward) do
        table.insert(bagResult, v)
    end
    for k, v in pairs(bagUnAim) do
        table.insert(bagResult, v)
    end
    for k, v in pairs(bagHaveReward) do
        table.insert(bagResult, v)
    end

    for i, v in ipairs(bagResult) do
        self.ListView_2:addChild(v)
    end
    -- self.ListView_2:jumpToTop()
    self.ListView_2:requestRefreshView()
    return true
end

-- 按钮红点的显示
function PrayActivityWindow:pushRedTip()
    -- 点击刷新
    getLimitPrayClickTips(true)

    for i = 1, 3 do
        state_machine.excute(
            "push_notification_center_manager",
            0,
            {
                _terminal_name = "push_notification_limit_pray_page_push",
                _widget = self._showRedBtnList[i],
                _invoke = nil,
                _pageIndex = i,
                _interval = 0.5
            }
        )
    end
end

function PrayActivityWindow:refushExactRed()
    self:changeRedDotShowState(self.Button_danchou, self:haveEnoughProp(1))
    self:changeRedDotShowState(self.Button_shichou, self:haveEnoughProp(10))
end

function PrayActivityWindow:changeRedDotShowState(widget, isShow)
    if widget._istips == true then
        widget:removeChild(widget._nodeChild, true)
        widget._nodeChild = nil
        widget._istips = false
    end

    if isShow then
        if widget._istips == nil or widget._istips == false then
            local ball = cc.Sprite:create("images/ui/bar/tips.png")
            ball:setAnchorPoint(cc.p(0.7, 0.7))
            ball:setPosition(cc.p(widget:getContentSize().width, widget:getContentSize().height))
            widget:addChild(ball)
            widget._nodeChild = ball
            widget._istips = true
        end
    end
end

function PrayActivityWindow:onRefreshView(curSelectPage)
    self._activityInfo = _ED.active_activity[180].activity_data
    if self.selectPage == 1 or (curSelectPage and curSelectPage == 1) then
        self:drawPageFirst()
    elseif self.selectPage == 2 then
        self:drawPageTask()
    elseif self.selectPage == 3 then
        self:drawPageBag()
    end

    -- 刷新道具拥有数量和红点
    state_machine.excute("pray_activity_window_refush_prop_info", 0, nil)
end

function PrayActivityWindow:onEnterTransitionFinish()
    -- 加载PrayActivityWindowWindow界面资源.
    -- res.activity.Pray.Pray_zhujiemian = res/activity/Pray/Pray_zhujiemian.csb
    local csbNode = csb.createNode("activity/Pray/Pray_zhujiemian.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self:onUpdateDraw()
    self:onDrawBtn()
    self:onShowPage(1)
    self:pushRedTip()
    self:updateActivityRemainTime()
end

function PrayActivityWindow:onDrawBtn()
    local root = self.roots[1]
    -- 限时祈福分页按钮
    self.Button_qifu =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_qifu"),
        nil,
        {
            terminal_name = "pray_activity_window_change_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_page = 1
        },
        nil,
        0
    )

    -- 活跃任务分页按钮
    self.Button_renwu =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_renwu"),
        nil,
        {
            terminal_name = "pray_activity_window_change_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_page = 2
        },
        nil,
        0
    )

    -- 超值礼包分页按钮
    self.Button_libao =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_libao"),
        nil,
        {
            terminal_name = "pray_activity_window_change_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_page = 3
        },
        nil,
        0
    )

    -- 十抽按钮
    self.Button_shichou =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_shichou"),
        nil,
        {
            terminal_name = "pray_activity_window_click_extract",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_times = 10,
            m_type = 14
        },
        nil,
        0
    )

    -- 单抽按钮
    self.Button_danchou =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_danchou"),
        nil,
        {
            terminal_name = "pray_activity_window_click_extract",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_times = 1,
            m_type = 14
        },
        nil,
        0
    )

    -- 祈福活动规则说明
    self.Button_rule =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_rule"),
        nil,
        {
            terminal_name = "pray_activity_rule_window_open",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 祈福活动界面返回按钮
    self.Button_close =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "pray_activity_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
    self._showRedBtnList = {}
    table.insert(self._showRedBtnList, self.Button_qifu)
    table.insert(self._showRedBtnList, self.Button_renwu)
    table.insert(self._showRedBtnList, self.Button_libao)
end

function PrayActivityWindow:onExit()
    -- 释放PrayActivityWindowWindow界面资源.
    state_machine.remove("pray_activity_window_show")
    state_machine.remove("pray_activity_window_hide")
    state_machine.remove("pray_activity_window_change_page")
    state_machine.remove("pray_activity_window_refush_view")
    state_machine.remove("pray_activity_window_refush_box")
    state_machine.remove("pray_activity_window_refush_prop_info")
    state_machine.remove("pray_activity_window_refush_select_reward")
end

function PrayActivityWindow:close()
    -- window event : close.
end

function PrayActivityWindow:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
