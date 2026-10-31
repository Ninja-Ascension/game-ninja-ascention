--[[ ----------------------------------------------------------------------------
-- 超级扫荡二级级cell
--]] ----------------------------------------------------------------------------
PveSuperMoppingInfoCell = class("PveSuperMoppingInfoCellClass", Window)
PveSuperMoppingInfoCell.__size = nil

-- 创建Cell实例
local pve_super_mopping_info_cell_create_terminal = {
    _name = "pve_super_mopping_info_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if PveSuperMoppingInfoCell then
            local cell = PveSuperMoppingInfoCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_super_mopping_info_cell_create_terminal)
state_machine.init()

-- 构造器
function PveSuperMoppingInfoCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    ------------------------------------------------------------------------ var------------------------------------------------------------------------

    -- 当前章节ID
    self.current_chapter_id = 0

    -- 当前NPC的通关星级
    self.npc_star = 0

    -- 当前NPC的ID
    self.npc_id = 0

    ------------------------------------------------------------------ load lua files-------------------------------------------------------------------

    ------------------------------------------------- Initialize summer drink cell page state machine---------------------------------------------------
    local function init_pve_super_mopping_info_cell_terminal()
        -- 请求扫荡
        local pve_super_mopping_info_cell_open_mopping_results_terminal = {
            _name = "pve_super_mopping_info_cell_open_mopping_results",
            _init = function(terminal)
                app.load("client.duplicate.MoppingResults")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local DifficultyID = 1 -- 攻击下标
                local surplusTimes = params._datas.mopping_time -- 扫荡次数
                local elseContent = 0 -- 扫荡类型
                local callfunc = {"pve_super_mopping_info_cell_mopping_success_callfunc", {_self = params._datas._self}} -- 扫荡完成后回调
                local times = params._datas.mopping_time
                local currentSceneType = dms.int(dms["pve_scene"], params._datas._self.current_chapter_id, pve_scene.scene_type) --当前章节类型

                -- 处理挑战次数是否足够
                if currentSceneType == 1 then
                    local totalAttackTimes = dms.int(dms["npc"], params._datas._self.npc_id, npc.daily_attack_count)
                    local addTimes = 0
                    if currentSceneType == 1 then
                        if _ED.active_activity[100] ~= nil and _ED.active_activity[100] ~= "" then
                            addTimes = tonumber(_ED.active_activity[100].activity_Info[1].activityInfo_need_day)
                        end
                    end
                    local surplusAttackCount = tonumber(_ED.npc_current_attack_count[tonumber(params._datas._self.npc_id)])

                    local remain_time = totalAttackTimes - surplusAttackCount + addTimes
                    if remain_time < surplusTimes then
                        app.load("client.utils.ConfirmTip")
                        local function sureFunc(sender, sure_number)
                            if sure_number ~= 0 then
                                return
                            end
                            local function responseCallback(response)
                                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                    if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                        state_machine.excute("pve_super_mopping_info_cell_mopping_success_callfunc", 0, {_self = params._datas._self})
                                    end
                                end
                            end
                            protocol_command.basic_consumption.param_list = "22" .. "\r\n" .. params._datas._self.npc_id
                            NetworkManager:register(protocol_command.basic_consumption.code, nil, nil, nil, instance, responseCallback, false, nil)
                        end

                        local buy_times = tonumber(_ED.npc_current_buy_count[tonumber(params._datas._self.npc_id)]) + 1
                        local total_reset_times = dms.int(dms["base_consume"], 22, base_consume.vip_0_value + tonumber(_ED.vip_grade))
                        if buy_times > total_reset_times then
                            app.load("client.utils.SmResetDuplicateTip")
                            state_machine.excute("sm_reset_duplicate_tip_open", 0, nil)
                            -- TipDlg.drawTextDailog(_new_interface_text[211])
                            return
                        end
                        local reset_info = zstring.split(dms.string(dms["copy_config"], 1, copy_config.param), ",")
                        local cost = reset_info[buy_times]
                        local tip = ConfirmTip:new()
                        tip:init(instance, sureFunc, string.format(_new_interface_text[210], cost, buy_times - 1))
                        fwin:open(tip, fwin._windows)
                        return true
                    end
                end

                -- 体力不足的情况
                local user_food = zstring.tonumber(_ED.user_info.user_food)
                local current_food = dms.int(dms["npc"], params._datas._self.npc_id, npc.attack_need_food)
                if user_food < current_food then
                    app.load("client.cells.prop.prop_buy_prompt")
                    local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
                    local mid = zstring.tonumber(config[15])

                    local win = PropBuyPrompt:new()
                    win:init(mid)
                    fwin:open(win, fwin._ui)
                    return
                end

                if user_food < current_food * surplusTimes then
                    surplusTimes = math.floor(user_food / current_food)
                end

                fwin:open(
                    MoppingResults:new():init(1, params._datas._self.npc_id, DifficultyID, surplusTimes, elseContent, callfunc, times, params._datas._self.current_chapter_id, currentSceneType),
                    fwin._ui
                )
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 扫荡完成后更新界面信息
        local pve_super_mopping_info_cell_mopping_success_callfunc_terminal = {
            _name = "pve_super_mopping_info_cell_mopping_success_callfunc",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                params._self:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(pve_super_mopping_info_cell_mopping_success_callfunc_terminal)
        state_machine.add(pve_super_mopping_info_cell_open_mopping_results_terminal)
    end

    ------------------------------------------------- call func init user return window state machine---------------------------------------------------
    init_pve_super_mopping_info_cell_terminal()
end

-- 对象初始化
function PveSuperMoppingInfoCell:init(npc_star, npc_id, current_chapter_id)
    if npc_star > 0 then
        self.npc_star = npc_star
    end

    if npc_id > 0 then
        self.npc_id = npc_id
    end

    if current_chapter_id > 0 then
        self.current_chapter_id = current_chapter_id
    end

    self:onInit()
    self:setContentSize(PveSuperMoppingInfoCell.__size)

    return self
end

function PveSuperMoppingInfoCell:onInit()
    -- 加载PveSuperMoppingInfoCell界面资源.
    -- res.duplicate.pve_super_mopping_info_cell = duplicate/pve_super_mopping_info_cell.csb
    --[[ 不使用缓存创建
	local csbNode = csb.createNode("duplicate/pve_super_mopping_info_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
    -- [[ 使用缓存创建
    local root = cacher.createUIRef("duplicate/pve_super_mopping_info_cell.csb", "root")
    -- ]]
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if PveSuperMoppingInfoCell.__size == nil then
        PveSuperMoppingInfoCell.__size = root:getContentSize()
    end

    self:buttonAddClickEvent()
    self:onUpdateDraw()
    self:updateButtonState()
end

function PveSuperMoppingInfoCell:createCell()
    local cell = PveSuperMoppingInfoCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function PveSuperMoppingInfoCell:onUpdateDraw()
    local root = self.roots[1]

    -- NPC名称
    local Text_chapter = ccui.Helper:seekWidgetByName(self.roots[1], "Text_chapter")
    local npc_info = dms.atos(dms["npc"], self.npc_id)
    local word_mould_id = dms.atos(npc_info, npc.npc_name)
    local word_mould_msg = getMessageForWordMouldID(word_mould_id)
    Text_chapter:setString(word_mould_msg)

    -- 按钮文本
    local Button_sweep_10 = ccui.Helper:seekWidgetByName(self.roots[1], "Button_sweep_10")
    local Button_sweep_50 = ccui.Helper:seekWidgetByName(self.roots[1], "Button_sweep_50")
    Button_sweep_10:setVisible(true)
    Button_sweep_50:setVisible(true)

    local pve_scene_info = dms.atos(dms["pve_scene"], self.current_chapter_id)
    local pve_scene_type = tonumber(pve_scene_info[pve_scene.scene_type])
    if pve_scene_type == 0 then
        Button_sweep_10:setTitleText(string.format(tipStringInfo_mopping_word[1], 10))
        Button_sweep_50:setTitleText(string.format(tipStringInfo_mopping_word[1], 50))
    elseif pve_scene_type == 1 then
        Button_sweep_10:setTitleText(string.format(tipStringInfo_mopping_word[1], 1))
        Button_sweep_50:setTitleText(string.format(tipStringInfo_mopping_word[1], 3))
    end

    local currentSceneType = dms.int(dms["pve_scene"], self.current_chapter_id, pve_scene.scene_type) --当前章节类型
    if currentSceneType == 1 then
        local totalAttackTimes = dms.int(dms["npc"], self.npc_id, npc.daily_attack_count)
        local addTimes = 0
        if currentSceneType == 1 then
            if _ED.active_activity[100] ~= nil and _ED.active_activity[100] ~= "" then
                addTimes = tonumber(_ED.active_activity[100].activity_Info[1].activityInfo_need_day)
            end
        end
        local surplusAttackCount = tonumber(_ED.npc_current_attack_count[tonumber(self.npc_id)])

        local remain_time = totalAttackTimes - surplusAttackCount + addTimes
        if remain_time < 1 then
            Button_sweep_10:setTitleText(tipStringInfo_mopping_word[2])
            Button_sweep_10:setVisible(false)
        end

        if remain_time < 3 then
            Button_sweep_50:setTitleText(tipStringInfo_mopping_word[2])
        end
    end

    -- 头像
    local npc_head = dms.atos(npc_info, npc.head_pic)
    local npc_head_id = zstring.split(npc_head, ",")
    local Panel_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_2")
    Panel_2:removeAllChildren(true)
    local sprite = cc.Sprite:create(string.format("images/ui/props/props_%s.png", npc_head_id[1]))
    sprite:setAnchorPoint(0.5, 0.5)
    sprite:setPosition(cc.p(Panel_2:getContentSize().width / 2, Panel_2:getContentSize().height / 2))
    Panel_2:addChild(sprite)

    -- 奖励
    local drop_library_id = dms.atos(npc_info, npc.drop_library)
    local scene_reward_ex_info = dms.atos(dms["scene_reward_ex"], drop_library_id)
    local show_reward = dms.atos(scene_reward_ex_info, scene_reward_ex.show_reward)
    local cells = DrawHandle.drawIcons(show_reward, true)
    local ListView_reward = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_reward")
    ListView_reward:removeAllItems()
    for i = 1, #cells do
        ListView_reward:addChild(cells[i])
    end
    ListView_reward:requestRefreshView()
end

function PveSuperMoppingInfoCell:updateButtonState()
    -- 按钮状态
    if self.npc_star > 0 then
        local Button_sweep_10 = ccui.Helper:seekWidgetByName(self.roots[1], "Button_sweep_10")
        local Button_sweep_50 = ccui.Helper:seekWidgetByName(self.roots[1], "Button_sweep_50")
        Button_sweep_10:setTouchEnabled(self.npc_star >= 3)
        Button_sweep_10:setBright(self.npc_star >= 3)
        Button_sweep_50:setTouchEnabled(self.npc_star >= 3)
        Button_sweep_50:setBright(self.npc_star >= 3)
    end
end

function PveSuperMoppingInfoCell:buttonAddClickEvent()
    local root = self.roots[1]

    local mopping_time_1 = 0
    local mopping_time_2 = 0
    local pve_scene_info = dms.atos(dms["pve_scene"], self.current_chapter_id)
    local pve_scene_type = tonumber(pve_scene_info[pve_scene.scene_type])
    if pve_scene_type == 0 then
        mopping_time_1 = 10
        mopping_time_2 = 50
    elseif pve_scene_type == 1 then
        mopping_time_1 = 1
        mopping_time_2 = 3
    end

    -- 扫荡 10次 或者1次
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_sweep_10"),
        nil,
        {
            terminal_name = "pve_super_mopping_info_cell_open_mopping_results",
            terminal_state = 0,
            isPressedActionEnabled = true,
            mopping_time = mopping_time_1,
            _self = self
        },
        nil,
        0
    )

    -- 扫荡 50次 或者3次
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_sweep_50"),
        nil,
        {
            terminal_name = "pve_super_mopping_info_cell_open_mopping_results",
            terminal_state = 0,
            isPressedActionEnabled = true,
            mopping_time = mopping_time_2,
            _self = self
        },
        nil,
        0
    )
end

function PveSuperMoppingInfoCell:onEnterTransitionFinish()
end

function PveSuperMoppingInfoCell:onExit()
    state_machine.remove("pve_super_mopping_info_cell_mopping_success_callfunc_terminal")
    state_machine.remove("pve_super_mopping_info_cell_open_mopping_results_terminal")
    -- 释放PveSuperMoppingInfoCell界面资源.
    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("duplicate/pve_super_mopping_info_cell.csb", root)
    -- ]]
end

function PveSuperMoppingInfoCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function PveSuperMoppingInfoCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("duplicate/pve_super_mopping_info_cell.csb", root)

    self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
