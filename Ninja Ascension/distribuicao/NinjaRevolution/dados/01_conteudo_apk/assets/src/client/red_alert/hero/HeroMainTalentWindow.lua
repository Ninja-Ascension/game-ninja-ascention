-----------------------------
--英雄武学突破天赋属性界面
-----------------------------
HeroMainTalentWindow = class("HeroMainTalentWindowClass", Window)

local hero_main_talent_window_open_terminal = {
    _name = "hero_main_talent_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroMainTalentWindowClass")
        if nil == _Window then
            fwin:open(HeroMainTalentWindow:new():init(params._datas))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local hero_main_talent_window_close_terminal = {
    _name = "hero_main_talent_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroMainTalentWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_main_talent_window_open_terminal)
state_machine.add(hero_main_talent_window_close_terminal)
state_machine.init()

function HeroMainTalentWindow:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua files
    app.load("client.red_alert.cells.hero.hero_skill_grow_up_list_cell")
    
    -- var
    -- 用户武将数据
    self.ship = nil

    -- 0我 1其它玩家
    self.camp = 0 
end

function HeroMainTalentWindow:onHide( ... )
    self:setVisible(false)
end

function HeroMainTalentWindow:onShow( ... )
    self:setVisible(true)
end

function HeroMainTalentWindow:getShipNumber(need_same_card_count)
    local have_numbers = 0
    local ship_str = ""
    for i,ship in pairs(_ED.user_ship) do
        if ship.ship_base_template_id == self.ship.ship_base_template_id and ship.ship_id ~= self.ship.ship_id 
            and zstring.tonumber(ship.ship_template_id) == zstring.tonumber(ship.ship_base_template_id)
            and zstring.tonumber(ship.formation_index) == 0
            and zstring.tonumber(ship.little_partner_formation_index) == 0
            and zstring.tonumber(ship.skill_grow_up_level) <= 0
            then
            local nv = true
            for e, m in pairs(ship.equipment) do
                if zstring.tonumber(m.user_equiment_id) > 0 then
                    nv = false
                end
            end
            for j,k in pairs(ship.stars_state) do
                if tonumber(k.state) == 1 then
                    nv = false
                end
            end
            if true == nv then
                have_numbers = have_numbers + 1 
                if have_numbers == need_same_card_count then
                    ship_str = ship_str.. ship.ship_id
                elseif have_numbers < need_same_card_count then
                    ship_str = ship_str.. ship.ship_id .. ","
                end
            end
        end
    end
    self.ship_str = ship_str
    return have_numbers
end

function HeroMainTalentWindow:onUpdateDraw(change)
    local root = self.roots[1]

    -- 绘制武学列表
    local ListView_grade = ccui.Helper:seekWidgetByName(root, "ListView_grade")

    local items = nil
    if true == change then
        ListView_grade:removeAllItems()
    else
        items = ListView_grade:getItems()
    end
    local lvSize = ListView_grade:getContentSize()
    local ship_mould_id = self.ship.ship_template_id or self.ship.ship_mould_id
    local shipSkillGrowUpParam = dms.string(dms["ship_mould"], ship_mould_id, ship_mould.skill_grow_up_param)
    -- debug.print_r(shipSkillGrowUpParam)
    shipSkillGrowUpParam = zstring.split(shipSkillGrowUpParam, "|")
    local height = 0
    local maxOpenIndex = 0
    local waitOpenIndex = -1
    for i, v in pairs(shipSkillGrowUpParam) do
        local params = zstring.split(v, ",")
        local talentId = params[1]
        local resourceNeedId = params[2]
        local isAlive = self.ship.skill_grow_up_states[i] == "1"
        if isAlive then
            maxOpenIndex = i
        else
            if waitOpenIndex < 0 then
                waitOpenIndex = i
            end
        end
        local cell = nil 
        if true == change then
            cell = state_machine.excute("hero_skill_grow_up_list_cell_create", 0, {self.ship, lvSize.width, talentId, resourceNeedId, isAlive})
            ListView_grade:addChild(cell)
            height = height + cell:getContentSize().height
        else
            cell = items[i]
            if isAlive ~= cell.isAlive then
                state_machine.excute("hero_skill_grow_up_list_cell_update_draw", 0, {cell, isAlive})
            end
        end
    end

    if true == change then
        if lvSize.height < height then
            lvSize.height = height
        end
        ListView_grade:setInnerContainerSize(lvSize)
        ListView_grade:requestRefreshView()
    end
end

function HeroMainTalentWindow:onUpdate(dt) 
   
end

function HeroMainTalentWindow:onEnterTransitionFinish()

end

function HeroMainTalentWindow:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_main_talent_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_talent_window_close"), nil,
    {
        terminal_name = "hero_main_talent_window_close", 
        -- func_string = [[funOpenDrawTip(99)]], 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw(true) 
end

function HeroMainTalentWindow:init(params)
    self.ship = params.cell.ship
    self:onInit()
    return self
end

function HeroMainTalentWindow:onExit()

end
