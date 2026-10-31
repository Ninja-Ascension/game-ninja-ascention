-----------------------------
--选择攻击阵营
-----------------------------
NationalWarBattleRenovate = class("NationalWarBattleRenovateClass", Window)

-- 打开窗口
local national_war_battle_renovate_window_open_terminal = {
    _name = "national_war_battle_renovate_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalWarBattleRenovateClass") == nil then
            fwin:open(NationalWarBattleRenovate:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local national_war_battle_renovate_window_close_terminal = {
    _name = "national_war_battle_renovate_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarBattleRenovateClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_battle_renovate_window_open_terminal)
state_machine.add(national_war_battle_renovate_window_close_terminal)
state_machine.init()

function NationalWarBattleRenovate:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.choose_index = 1
    self.camp = {}
    -- Initialize national reward state machine.
    local function init_national_war_battle_renovate_terminal()
        --选择攻击阵营
        local national_war_battle_renovate_choose_attack_camp_terminal = {
            _name = "national_war_battle_renovate_choose_attack_camp",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local choose_index = params._datas.choose_index
                instance.choose_index = choose_index
                instance:onUpdateChoose()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --确认选择
        local national_war_battle_renovate_choose_sure_terminal = {
            _name = "national_war_battle_renovate_choose_sure",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("national_war_city_war_change_choose_camp",0,{self.camp[instance.choose_index]})
                state_machine.excute("national_war_battle_renovate_window_close",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(national_war_battle_renovate_choose_attack_camp_terminal)
        state_machine.add(national_war_battle_renovate_choose_sure_terminal)
        state_machine.init()     
    end
    -- call func init nationalReward state machine.
    init_national_war_battle_renovate_terminal()
end

function NationalWarBattleRenovate:onUpdateChoose()
    local root = self.roots[1]
    local Image_hook_1 = ccui.Helper:seekWidgetByName(root,"Image_hook_1")
    local Image_hook_2 = ccui.Helper:seekWidgetByName(root,"Image_hook_2")
    Image_hook_1:setVisible(false)
    Image_hook_2:setVisible(false)
    if self.choose_index == 1 then
        Image_hook_1:setVisible(true)
    elseif self.choose_index == 2 then
        Image_hook_2:setVisible(true)
    end
end

function NationalWarBattleRenovate:onUpdateDraw()
    local root = self.roots[1]
    for i=1,2 do
        local Panel_build_infor_war = ccui.Helper:seekWidgetByName(root,"Panel_build_infor_war_"..i)
        Panel_build_infor_war:setVisible(false)
    end
    for i,v in pairs(self.camp) do
        local Panel_build_infor_war = ccui.Helper:seekWidgetByName(root,"Panel_build_infor_war_"..i)
        Panel_build_infor_war:setVisible(true)
        local Panel_build_infor_camp = ccui.Helper:seekWidgetByName(root,"Panel_build_infor_camp_"..i)
        Panel_build_infor_camp:setBackGroundImage("images/ui/quality/camp_"..self.camp[i]..".png")
    end

    if #self.camp == 1 then
        local Panel_build_infor_war = ccui.Helper:seekWidgetByName(root,"Panel_build_infor_war_1")
        Panel_build_infor_war:setPositionX(Panel_build_infor_war:getPositionX() + Panel_build_infor_war:getContentSize().width)
    end
end

function NationalWarBattleRenovate:onInit()
	local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_battle_renovate)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_renovate_close"), nil, 
    {
        terminal_name = "national_war_battle_renovate_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 确认选择阵营
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_renovate_sure"), nil, 
    {
        terminal_name = "national_war_battle_renovate_choose_sure", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 选择阵营
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_renovate_cell_1"), nil, 
    {
        terminal_name = "national_war_battle_renovate_choose_attack_camp", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        choose_index = 1,
    }, nil, 0)
    -- 选择阵营
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_renovate_cell_2"), nil, 
    {
        terminal_name = "national_war_battle_renovate_choose_attack_camp", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        choose_index = 2,        
    }, nil, 0)
    self:onUpdateDraw()
end

function NationalWarBattleRenovate:canAttackCamp()
    local camp = {}
    if tonumber(_ED.user_info.user_force) == 1 then
        if tonumber(_ED.war_in_city_info.act_of_god_numbers) > 0 then
            table.insert(camp,2)
        end
        if tonumber(_ED.war_in_city_info.natural_numbers) > 0 then
            table.insert(camp,3)
        end        
    elseif tonumber(_ED.user_info.user_force) == 2 then
        if tonumber(_ED.war_in_city_info.union_people_number) > 0 then
            table.insert(camp,1)
        end
        if tonumber(_ED.war_in_city_info.natural_numbers) > 0 then
            table.insert(camp,3)
        end 
    elseif tonumber(_ED.user_info.user_force) == 3 then
        if tonumber(_ED.war_in_city_info.union_people_number) > 0 then
            table.insert(camp,1)
        end
        if tonumber(_ED.war_in_city_info.act_of_god_numbers) > 0 then
            table.insert(camp,2)
        end 
    end
    if #camp == 0 then
        table.insert(camp,zstring.tonumber(_ED.war_in_city_info.now_city_camp))
    end
    return camp
end

function NationalWarBattleRenovate:init()
    self.camp = self:canAttackCamp()
    self:onInit()
    return self
end

function NationalWarBattleRenovate:onExit()
    state_machine.remove("national_war_battle_renovate_choose_attack_camp")
    state_machine.remove("national_war_battle_renovate_choose_sure")
end

