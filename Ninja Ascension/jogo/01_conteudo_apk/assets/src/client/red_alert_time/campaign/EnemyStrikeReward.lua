-- ------------------------------------------------------------------------------------------------------------
--  敌军来袭-奖励
-- ------------------------------------------------------------------------------------------------------------
EnemyStrikeReward = class("EnemyStrikeRewardClass", Window)

--打开界面
local enemy_strike_reward_window_open_terminal = {
    _name = "enemy_strike_reward_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("EnemyStrikeRewardClass") == nil then
            fwin:open(EnemyStrikeReward:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local enemy_strike_reward_window_close_terminal = {
    _name = "enemy_strike_reward_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EnemyStrikeRewardClass"))
        checkRewardObtainDraw()
        state_machine.excute("enemy_strike_fight_update_fight_info", 0, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(enemy_strike_reward_window_open_terminal)
state_machine.add(enemy_strike_reward_window_close_terminal)
state_machine.init()

function EnemyStrikeReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._reward_info = {}
end

-- 显示信息
function EnemyStrikeReward:onUpdateDraw()
    local root = self.roots[1]
    local Text_hurt_n = ccui.Helper:seekWidgetByName(root, "Text_hurt_n")
    Text_hurt_n:removeAllChildren(true)

    for i = 1, 6 do
        local Panel_hurt_reward_icon = ccui.Helper:seekWidgetByName(root, "Panel_hurt_reward_icon_"..i)
        if Panel_hurt_reward_icon ~= nil and self._reward_info[i] ~= nil and self._reward_info[i] ~= "" then
            Panel_hurt_reward_icon:removeAllChildren(true)
            local info = zstring.split(self._reward_info[i], ",")
            local prop_id = tonumber(info[1])
            local prop_type = tonumber(info[2])
            local prop_count = tonumber(info[3])
            local cell = nil
            if prop_id > 0 then
                cell = state_machine.excute("props_icon_create_cell", 0, {6, 1, prop_id, 1, prop_count})
            else
                cell = state_machine.excute("props_icon_create_cell", 0, {6, 1, prop_type, 1, prop_count})
            end
            Panel_hurt_reward_icon:addChild(cell)
        end
    end

    local Panel_hurt_reward_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_hurt_reward_icon_1")
    local Panel_hurt_reward_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_hurt_reward_icon_2")
    local Panel_hurt_reward_icon_3 = ccui.Helper:seekWidgetByName(root, "Panel_hurt_reward_icon_3")
    if #self._reward_info == 1 then
        Panel_hurt_reward_icon_1:setPositionX(Panel_hurt_reward_icon_2:getPositionX())
    elseif #self._reward_info == 2 then
        local posX_1 = (Panel_hurt_reward_icon_1:getPositionX() + Panel_hurt_reward_icon_2:getPositionX()) / 2
        local posX_2 = (Panel_hurt_reward_icon_2:getPositionX() + Panel_hurt_reward_icon_3:getPositionX()) / 2
        Panel_hurt_reward_icon_1:setPositionX(posX_1)
        Panel_hurt_reward_icon_2:setPositionX(posX_2)
    end
    
    local _richText_2 = ccui.RichText:create()
    _richText_2:ignoreContentAdaptWithSize(false)
    local color = cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3])
    local re1 = ccui.RichElementText:create(1, color, 255, exChangeNumToString(_ED.user_enemy_strike_info.current_hurt), "fonts/simhei.ttf", 25)
    _richText_2:pushBackElement(re1)
    if _ED.user_enemy_strike_info.double == 1 then
        color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
        local re1_1 = ccui.RichElementText:create(1, color, 255, tipStringInfo_campaign_info[17], "fonts/simhei.ttf", 25)
        _richText_2:pushBackElement(re1_1)
    end
    _richText_2:setContentSize(cc.size(200, 55))
    _richText_2:setPosition(cc.p(100, 0))
    Text_hurt_n:addChild(_richText_2)
end

--初始化界面
function EnemyStrikeReward:onInit()
    local csbItem = nil
    if #self._reward_info <= 3 then
        csbItem = csb.createNode(config_csb.campaign.enemy_strike_hurt_reward)
    else
        csbItem = csb.createNode(config_csb.campaign.enemy_strike_hurt_reward_1)
    end
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hurt_reward_close"), nil, 
    {
        terminal_name = "enemy_strike_reward_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hurt_reward_sure"), nil, 
    {
        terminal_name = "enemy_strike_reward_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "enemy_strike_reward_window_close", 
        terminal_state = 0, 
    }, nil, 1)

    self:onUpdateDraw()
end

--初始化
function EnemyStrikeReward:init()
    self._reward_info = zstring.split(_ED.user_enemy_strike_info.reward_info, "|")
    _ED.user_enemy_strike_info.reward_info = ""
    self:onInit()
    return self
end

--移除状态机
function EnemyStrikeReward:onExit()

end