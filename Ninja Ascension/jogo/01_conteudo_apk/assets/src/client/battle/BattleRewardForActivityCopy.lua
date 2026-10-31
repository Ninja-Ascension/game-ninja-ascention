-- ----------------------------------------------------------------------------------------------------
-- 说明：活动副本战斗结束奖励结算界面
-------------------------------------------------------------------------------------------------------
BattleRewardForActivityCopy = class("BattleRewardForActivityCopyClass", Window)

local battle_reward_for_activity_copy_window_open_terminal = {
    _name = "battle_reward_for_activity_copy_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("BattleRewardForActivityCopyClass") then
            fwin:open(BattleRewardForActivityCopy:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_reward_for_activity_copy_window_close_terminal = {
    _name = "battle_reward_for_activity_copy_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleRewardForActivityCopyClass"))

		fwin:close(fwin:find("BattleSceneClass"))
		
		-- 有升级,播升级
		if true == _ED.user_is_level_up then
            app.load("client.battle.BattleLevelUp")
			fwin:open(BattleLevelUp:new(), fwin._viewdialog) 
			return
		end

		fwin:close(fwin:find("BattleSceneClass"))
        cacher.removeAllTextures()
        fwin:reset(nil)
		-- fwin:removeAll()
		app.load("client.home.Menu")
		fwin:open(Menu:new(), fwin._taskbar)
		
		state_machine.excute("explore_window_open", 0, 0)
		state_machine.excute("explore_window_open_fun_window", 0, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_reward_for_activity_copy_window_open_terminal)
state_machine.add(battle_reward_for_activity_copy_window_close_terminal)
state_machine.init()

function BattleRewardForActivityCopy:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._current_page_index = 1

    -- Initialize battle_reward_for_activity_copy window state machine.
    local function init_battle_reward_for_activity_copy_window_terminal()

        state_machine.init()
    end

    -- call func init battle_reward_for_activity_copy window state machine.
    init_battle_reward_for_activity_copy_window_terminal()
end

function BattleRewardForActivityCopy:init(params)
    return self
end

function BattleRewardForActivityCopy:onDrawRewardListView(listView, rewardInfoString)
    local isHaveActivity = false
    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2 then
        if _ED.active_activity[99] ~= nil and _ED.active_activity[99] ~= "" then
            isHaveActivity = true
        end
    elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3 or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4 then
        if _ED.active_activity[131] ~= nil and _ED.active_activity[131] ~= "" then
            isHaveActivity = true
        end
    elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_52 then
        if _ED.active_activity[132] ~= nil and _ED.active_activity[132] ~= "" then
            isHaveActivity = true
        end
    elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_51 then
        if _ED.active_activity[133] ~= nil and _ED.active_activity[133] ~= "" then
            isHaveActivity = true
        end
    elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_54 then
        if _ED.active_activity[134] ~= nil and _ED.active_activity[134] ~= "" then
            isHaveActivity = true
        end
    end
    local rewardInfoArr = zstring.split(rewardInfoString, "|")
    for i, v in pairs(rewardInfoArr) do
        local info = zstring.split(v, ",")
        if info[1] == "1" then
            local cell = ResourcesIconCell:createCell()
            cell:init(1, tonumber(info[3]), -1, nil, nil, true, true)
            cell:hideCount(true)
            listView:addChild(cell)
            if cell.setActivityDouble ~= nil then
                cell:setActivityDouble(isHaveActivity)
            end
        elseif info[1] == "2" then
            local cell = ResourcesIconCell:createCell()
            cell:init(2, tonumber(info[3]), -11, nil, nil, true, true)
            cell:hideCount(true)
            listView:addChild(cell)
            if cell.setActivityDouble ~= nil then
                cell:setActivityDouble(isHaveActivity)
            end
        elseif info[1] == "6" then
            local cell = ResourcesIconCell:createCell()
            cell:init(6, tonumber(info[3]), tonumber(info[2]), nil, nil, true, true)
            cell:hideCount(true)
            listView:addChild(cell)
            if cell.setActivityDouble ~= nil then
                cell:setActivityDouble(isHaveActivity)
            end
            -- local cell = PropIconCell:createCell()
            -- local reawrdID = tonumber(info[2])
            -- local rewardNum = tonumber(info[3])
            -- cell:init(23, {user_prop_template = reawrdID, prop_number = rewardNum}, nil, false)
            -- listView:addChild(cell)
        elseif info[1] == "7" then
            local reawrdID = tonumber(info[2])
            local rewardNum = tonumber(info[3])
            
            local tmpTable = {
                user_equiment_template = reawrdID,
                mould_id = reawrdID,
                user_equiment_grade = 1
            }
            
            local cell = EquipIconCell:createCell()
            cell:init(10, tmpTable, reawrdID, nil, false)
            listView:addChild(cell)
            if cell.setActivityDouble ~= nil then
                cell:setActivityDouble(isHaveActivity)
            end
        end
    end
end

function BattleRewardForActivityCopy:onUpdateDraw()
    local root = self.roots[1]

    -- SSS
    local Panel_maoxian_battle_jiesuan_S_1 = ccui.Helper:seekWidgetByName(root, "Panel_maoxian_battle_jiesuan_S_1")
    local Panel_maoxian_battle_jiesuan_S_2 = ccui.Helper:seekWidgetByName(root, "Panel_maoxian_battle_jiesuan_S_2")
    local Panel_maoxian_battle_jiesuan_S_3 = ccui.Helper:seekWidgetByName(root, "Panel_maoxian_battle_jiesuan_S_3")

    -- 等级
    local Text_maoxian_battle_jiesuan_lv_n = ccui.Helper:seekWidgetByName(root, "Text_maoxian_battle_jiesuan_lv_n")
    local nLevel = (zstring.tonumber(_ED.user_info.user_grade) - zstring.tonumber(_ED.user_info.last_user_grade))
    Text_maoxian_battle_jiesuan_lv_n:setString("" .. nLevel)

    -- 经验
    local Text_maoxian_battle_jiesuan_exp_n = ccui.Helper:seekWidgetByName(root, "Text_maoxian_battle_jiesuan_exp_n")
    local nExp = 0
    -- if nLevel > 0 then
    --     nExp = (zstring.tonumber(_ED.user_info.last_user_grade_need_experience) - zstring.tonumber(_ED.user_info.last_user_experience))
    --         + (zstring.tonumber(_ED.user_info.user_experience) - zstring.tonumber(_ED.user_info.last_user_grade_need_experience))
    -- else
    --     nExp = (zstring.tonumber(_ED.user_info.user_experience) - zstring.tonumber(_ED.user_info.last_user_experience))
    -- end
    Text_maoxian_battle_jiesuan_exp_n:setString("" .. nExp)

    -- 声望?
    local Text_maoxian_battle_jiesuan_icon_n = ccui.Helper:seekWidgetByName(root, "Text_maoxian_battle_jiesuan_icon_n")
    Text_maoxian_battle_jiesuan_icon_n:setString("0")

    -- 通关评分
    local r = 1
    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2 then
        r = dms.float(dms["play_config"], 5, pirates_config.param)
    elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3 
        or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4
        then
        r = dms.float(dms["play_config"], 10, pirates_config.param)
    end
    local score = math.floor(_ED._fightModule.totalDefenceDamage * r)
    local Text_maoxian_battle_jiesuan_pass_n = ccui.Helper:seekWidgetByName(root, "Text_maoxian_battle_jiesuan_pass_n")
    Text_maoxian_battle_jiesuan_pass_n:setString("" .. score)

    -- 击杀百分比
    local Text_maoxian_battle_jiesuan_kill_n = ccui.Helper:seekWidgetByName(root, "Text_maoxian_battle_jiesuan_kill_n")
    local r = math.floor(_ED._fightModule.totalDefenceDamage / _ED._fightModule.npcMaxHealth * 100)
    Text_maoxian_battle_jiesuan_kill_n:setString(r.."%")

    local ns = 0
    if r < 10 then
        ns = 1
        Panel_maoxian_battle_jiesuan_S_1:setVisible(true)
    elseif r < 100 then
        ns = 2
        Panel_maoxian_battle_jiesuan_S_1:setVisible(true)
        Panel_maoxian_battle_jiesuan_S_2:setVisible(true)
    else
        ns = 3
        Panel_maoxian_battle_jiesuan_S_1:setVisible(true)
        Panel_maoxian_battle_jiesuan_S_2:setVisible(true)
        Panel_maoxian_battle_jiesuan_S_3:setVisible(true)
    end

    -- 获得物品
    local rewardList = getSceneReward(2)
    local rewardInfo = ""
    if nil ~= rewardList and nil ~= rewardList.show_reward_list then
        for i, v in pairs(rewardList.show_reward_list) do
            if #rewardInfo > 0 then
                rewardInfo = rewardInfo .. "|"
            end
            rewardInfo = rewardInfo .. "" .. v.prop_type .. "," .. v.prop_item .. "," .. v.item_value
        end
    end

    local ListView_maoxian_battle_jiesuan_icon = ccui.Helper:seekWidgetByName(root, "ListView_maoxian_battle_jiesuan_icon")
    if #rewardInfo > 0 then
        self:onDrawRewardListView(ListView_maoxian_battle_jiesuan_icon, rewardInfo)
    end

    if _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
        _ED.user_is_level_up = true
    end
end

function BattleRewardForActivityCopy:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/maoxian_battle_jiesuan.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_maoxian_battle_jiesuan_bg"), nil, 
    {
        terminal_name = "battle_reward_for_activity_copy_window_close", 
        isPressedActionEnabled = true
    },
    nil,0)

    self:onUpdateDraw()
end

function BattleRewardForActivityCopy:onExit()

end

function BattleRewardForActivityCopy:destory(window)

end
-- END
-- ----------------------------------------------------------------------------------------------------