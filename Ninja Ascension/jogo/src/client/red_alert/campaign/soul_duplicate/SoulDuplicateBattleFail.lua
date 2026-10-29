-----------------------------
--战斗失败
-----------------------------
SoulDuplicateBattleFail = class("SoulDuplicateBattleFailClass", Window)

--打开战斗失败界面
local soul_duplicate_battle_fail_window_open_terminal = {
    _name = "soul_duplicate_battle_fail_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _window = fwin:find("SoulDuplicateBattleFailClass")
        if nil == _window then
            fwin:open(SoulDuplicateBattleFail:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭战斗失败界面
local soul_duplicate_battle_fail_window_close_terminal = {
    _name = "soul_duplicate_battle_fail_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SoulDuplicateBattleFailClass"))
        -- cacher.removeAllTextures()
        -- fwin:reset(nil)
        fwin:removeAll()
        cacher.destorySystemCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(soul_duplicate_battle_fail_window_open_terminal)
state_machine.add(soul_duplicate_battle_fail_window_close_terminal)
state_machine.init()

function SoulDuplicateBattleFail:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
  
    self._reward_list = nil
    --获得道具列表
    self._reward_cells = {}
    -- Initialize soul_duplicate_battle_fail state machine.
    local function init_soul_duplicate_battle_fail_terminal()
        -- 退出
        local soul_duplicate_battle_fail_button_close_terminal = {
            _name = "soul_duplicate_battle_fail_button_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("soul_duplicate_battle_fail_window_close")
                -- fwin:removeAll()
                -- fwin:freeAllMemeryPool()
                state_machine.excute("campaign_window_open",0,"")
                state_machine.excute("soul_duplicate_window_open",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(soul_duplicate_battle_fail_button_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_soul_duplicate_battle_fail_terminal()
end


function SoulDuplicateBattleFail:onUpdateDraw()
    local root = self.roots[1]
    local ListView_victory_in_soul_duplicate = ccui.Helper:seekWidgetByName(root,"ListView_victory_in_soul_duplicate")      --获得道具列表
    ListView_victory_in_soul_duplicate:removeAllItems()
    if self._reward_list ~= nil then
        for i,v in pairs(self._reward_list.show_reward_list) do
            if zstring.tonumber(v.prop_type) ~= 8 then
                local cell = nil
                if zstring.tonumber(v.prop_type) == 6 and 
                    (zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.change_of_equipment))> 0 
                    or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.use_of_ship)) > 0) then
                    cell = state_machine.excute("all_resource_create_cell",0,{3,v,v,9,0})
                elseif zstring.tonumber(v.prop_type) == 7 then
                    cell = state_machine.excute("all_resource_create_cell",0,{6,v,v,9,0})
                elseif zstring.tonumber(v.prop_type) == 13 then
                    cell = state_machine.excute("all_resource_create_cell",0,{7,v,v,9,0})
                else
                    cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,9,0})
                end
                ListView_victory_in_soul_duplicate:addChild(cell)
                cell:setVisible(false)
                table.insert(self._reward_cells,cell)
            elseif zstring.tonumber(v.prop_type) == 8 then
                add_exp = tonumber(v.item_value)
            end
        end
    end
    ListView_victory_in_soul_duplicate:requestRefreshView()

    local Panel_player_role = ccui.Helper:seekWidgetByName(root,"Panel_player_role")
    if nil ~= Panel_player_role and Panel_player_role:isVisible() == true then
        local jsonPath = nil
        local atlasPath = nil
        if tonumber(_ED.user_info.user_gender) == 1 then
            jsonPath = "sprite/spirte_nanzhu.json"
            atlasPath = "sprite/spirte_nanzhu.atlas"
        elseif tonumber(_ED.user_info.user_gender) == 2 then
            jsonPath = "sprite/spirte_nvzhu.json"
            atlasPath = "sprite/spirte_nvzhu.atlas"
        end
        local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", false, nil)
        animation:setPosition(cc.p(Panel_player_role:getContentSize().width / 2, 0))
        Panel_player_role:addChild(animation)
    end
end

--播放战斗失败动画
function SoulDuplicateBattleFail:onEnterTransitionFinish()
    local root = self.roots[1]
    local action = self.actions[1]
    local Panel_soul_duplicate_open = ccui.Helper:seekWidgetByName(root, "Panel_soul_duplicate_open")
    local Panel_soul_duplicate_fail = ccui.Helper:seekWidgetByName(root, "Panel_soul_duplicate_fail")
    if Panel_soul_duplicate_open ~= nil then
        local ArmatureNode_1 = Panel_soul_duplicate_open:getChildByName("ArmatureNode_1")
        local ArmatureNode_1_0 = Panel_soul_duplicate_fail:getChildByName("ArmatureNode_1_0")
        Panel_soul_duplicate_open:setVisible(true)
        local animation = ArmatureNode_1:getAnimation()
        local animation_2 = ArmatureNode_1_0:getAnimation()
        local animationEventCallFunc = function()
            Panel_soul_duplicate_open:setVisible(false)
            Panel_soul_duplicate_fail:setVisible(true)
            animation_2:playWithIndex(1, 0, -1)
        end
        animation:playWithIndex(0, 0, 0)
        animation:setMovementEventCallFunc(animationEventCallFunc)
    end

    local max_cell = #self._reward_cells
    local index = 1
    --获得道具顺序显示
    local function playRewardCells()
        if index > max_cell then
            self:stopAllActions()
            return
        else
            self._reward_cells[index]:setVisible(true)
            index = index + 1 
        end
    end
    local action_2 = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(playRewardCells)))
    self:runAction(action_2)
end

--初始化界面
function SoulDuplicateBattleFail:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.soul_duplicate.soul_duplicate_fall)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.campaign.soul_duplicate.soul_duplicate_fall)
    table.insert(self.actions,action)
    csbItem:runAction(action)
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_victory_in_soul_duplicate_go_on"), nil, 
    {
        terminal_name = "soul_duplicate_battle_fail_button_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw() 
end


function SoulDuplicateBattleFail:init()
    self._reward_list = getSceneReward(69, true)
    self:onInit()
    return self
end

--移除状态机
function SoulDuplicateBattleFail:onExit()
    state_machine.remove("soul_duplicate_battle_fail_button_close")
end
