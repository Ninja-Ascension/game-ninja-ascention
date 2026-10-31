-----------------------------
--英雄武学突破子界面
-----------------------------
HeroMainGradeUp = class("HeroMainGradeUpClass", Window)

local hero_main_grade_up_window_open_terminal = {
    _name = "hero_main_grade_up_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroMainGradeUpClass")
        if nil == _Window then
            fwin:open(HeroMainGradeUp:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_main_grade_up_window_open_terminal)
state_machine.init()

function HeroMainGradeUp:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua files
    app.load("client.red_alert_time.cells.hero.hero_skill_grow_up_list_cell")
    app.load("client.red_alert_time.hero.HeroMainTalentWindow")
    
    -- var
    -- 用户武将数据
    self.ship = nil

    -- 0我 1其它玩家
    self.camp = 0 

    -- 突破按钮
    self.Button_grade_up = nil

    -- 资源不足的追踪
    self.tracking = 0 --0武将，1将魂

    -- Initialize hero_main_grade_up state machine.
    local function init_hero_main_grade_up_terminal() 
        local hero_main_grade_up_open_talent_terminal = {
            _name = "hero_main_grade_up_open_talent",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- state_machine.excute("hero_main_talent_window_open", 0, params)
                app.load("client.red_alert_time.hero.HeroMainStarUpWindow")
                state_machine.excute("hero_main_star_up_window_window_open", 0, {2, params._datas.cell.ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --显示界面
        local hero_main_grade_up_window_show_terminal = {
            _name = "hero_main_grade_up_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        --隐藏界面
        local hero_main_grade_up_window_hide_terminal = {
            _name = "hero_main_grade_up_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --改变英雄
        local hero_main_grade_up_change_ship_terminal = {
            _name = "hero_main_grade_up_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local change = false
                if params ~= "" and params ~= nil then
                    instance.ship = params 
                    change = true
                end
                instance:onUpdateDraw(change)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 同名武将缺少的追踪
        local hero_main_grade_up_goto_short_the_same_hero_terminal = {
            _name = "hero_main_grade_up_goto_short_the_same_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.tracking == 0 then 
                    state_machine.excute("get_the_way_window_open",0,{13,instance.ship.ship_template_id,0,instance.ship})
                elseif instance.tracking == 1 then
                    app.load("client.red_alert_time.utils.GetTheWay")
                    -- state_machine.excute("short_cut_go_to_other_window", 0, {831})
                    state_machine.excute("get_the_way_window_open",0,{_datas = {
                        terminal_name = "get_the_way_window_open", 
                        -- func_string = [[funOpenDrawTip(100)]],       
                        terminal_state = 0, 
                        prop_type = 5,
                        prop_item = -1,
                        touch_scale = true,
                        touch_scale_xy = 0.95, 
                    }})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --改变英雄
        local hero_main_grade_up_request_skill_grow_terminal = {
            _name = "hero_main_grade_up_request_skill_grow",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- print("请求武将技能突破。")
                local cell = params._datas.cell
                if cell.camp ~= 0 then
                    -- tip
                    -- print("不能对其他玩家使用技能突破")
                    return
                end
                local function responseShipSkill_GrowUpCallback(response)
                    state_machine.unlock("hero_main_grade_up_request_skill_grow", 0, 0)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            -- print("技能突破成功")
                            state_machine.excute("hero_main_change_ship",0,"")
                            state_machine.excute("hero_main_update_draw",0,"")
                            state_machine.excute("hero_main_update_hero_info",0,"")

                            app.load("client.red_alert_time.hero.HeroMainGradeUpSuccess")
                            state_machine.excute("hero_main_grade_up_success_window_open",0,response.node.ship)
                            state_machine.lock("hero_main_grade_up_request_skill_grow", 0, 0)
                        end
                    end
                end
                local index = -1
                -- debug.print_r(cell.ship.skill_grow_up_states)
                for i, v in pairs(cell.ship.skill_grow_up_states) do
                    if zstring.tonumber(v) <= 0 then
                        index = i - 1
                        break
                    end
                end
                if index < 0 then
                    -- tip
                    -- print("无效的突破索引")
                    return false
                end
                -- print("当前的突破索引", index)
                state_machine.lock("hero_main_grade_up_request_skill_grow", 0, 0)
                protocol_command.ship_skill_grow_up.param_list = cell.ship.ship_id .. "\r\n" .. index
                NetworkManager:register(protocol_command.ship_skill_grow_up.code, nil, nil, nil, cell, responseShipSkill_GrowUpCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        state_machine.add(hero_main_grade_up_open_talent_terminal)
        state_machine.add(hero_main_grade_up_window_show_terminal)   
        state_machine.add(hero_main_grade_up_window_hide_terminal)
        state_machine.add(hero_main_grade_up_goto_short_the_same_hero_terminal)
        state_machine.add(hero_main_grade_up_change_ship_terminal)
        state_machine.add(hero_main_grade_up_request_skill_grow_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_hero_main_grade_up_terminal()
end

function HeroMainGradeUp:onHide( ... )
    self:setVisible(false)
end

function HeroMainGradeUp:onShow( ... )
    self:setVisible(true)
end

function HeroMainGradeUp:getShipNumber(need_same_card_count)
    local have_numbers = 0
    local ship_str = ""
    for i,ship in pairs(_ED.user_ship) do
        if ship.ship_base_template_id == self.ship.ship_base_template_id 
            and ship.ship_id ~= self.ship.ship_id 
            and zstring.tonumber(ship.ship_template_id) == zstring.tonumber(ship.ship_base_template_id)
            and zstring.tonumber(ship.formation_index) == 0
            and zstring.tonumber(ship.little_partner_formation_index) == 0
            and zstring.tonumber(ship.skill_grow_up_level) <= 0
            and zstring.tonumber(ship.god_weaponry) <= 0
            and ship.is_have_fetters == false
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

function HeroMainGradeUp:onUpdateDraw(change)
    local root = self.roots[1]

    -- 新增界面：hero_main_talent_window
    -- 需要技术处理的控件：
    -- Button_talent_window_close 关闭界面
    -- ListView_grade 显示天赋
    -- 名称和功能与原来在hero_main_grow_up里的一致
    -- ——————————————
    -- hero_main_grow_up新增控件：
    -- Button_hero_talent
    -- 点击后打开hero_main_talent_window

    -- Text_unlock_info
    -- 突破等级未满时显示文字“突破到+x解锁天赋：”
    -- 突破等级满时显示文字“已解锁天赋：”
    local Text_unlock_info = ccui.Helper:seekWidgetByName(root, "Text_unlock_info")

    -- Text_talent_info
    -- 显示下一个突破等级的天赋名称和描述
    -- 如突破等级已满，则显示当前突破等级的天赋名称和描述
    local Text_talent_info = ccui.Helper:seekWidgetByName(root, "Text_talent_info")

    -- Text_demand_lv 
    -- 当等级不足时需要显示“需要等级达到XX“
    -- 当突破满时需要显示“突破等级已满“
    local Text_demand_lv = ccui.Helper:seekWidgetByName(root, "Text_demand_lv")

    -- 绘制武学列表
    local ListView_grade = ccui.Helper:seekWidgetByName(root, "ListView_grade")
    local drawListView = ListView_grade:isVisible()

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

        if true == drawListView then
            local cell = nil 
            if true == change then
                cell = state_machine.excute("hero_skill_grow_up_list_cell_create", 0, {self.ship, lvSize.width, talentId, resourceNeedId, isAlive})
                ListView_grade:addChild(cell)
                height = height + cell:getContentSize().height
            else
                cell = items[i]
                if isAlive ~= cell.isAlive then
                    print(isAlive, cell.isAlive)
                    state_machine.excute("hero_skill_grow_up_list_cell_update_draw", 0, {cell, isAlive})
                end
            end
        end
    end

    if true == drawListView then
        if true == change then
            if lvSize.height < height then
                lvSize.height = height
            end
            ListView_grade:setInnerContainerSize(lvSize)
            ListView_grade:requestRefreshView()
        end
    end

    -- 绘制资源消耗
    local Panel_hero_star_hero = ccui.Helper:seekWidgetByName(root, "Panel_hero_star_hero") -- 资源图标
    local Text_hero_star_material_number = ccui.Helper:seekWidgetByName(root, "Text_hero_star_material_number") -- 资源需求数量
    local Text_hero_star_gold_have = ccui.Helper:seekWidgetByName(root, "Text_hero_star_gold_have") -- 当前拥有的数量

    Panel_hero_star_hero:removeAllChildren(true)

    local pic_index = dms.int(dms["ship_mould"], self.ship.ship_base_template_id,ship_mould.head_icon) + 10000
    local drawIndex = maxOpenIndex
    if waitOpenIndex > maxOpenIndex then
        drawIndex = waitOpenIndex
    end
    local openParam = zstring.split(shipSkillGrowUpParam[drawIndex], ",")
    local shipGrowRequirement = dms.element(dms["ship_grow_requirement"], openParam[2])
    local needLevel = dms.atoi(shipGrowRequirement, ship_grow_requirement.need_level)
    local needSameCardCount = dms.atoi(shipGrowRequirement, ship_grow_requirement.need_same_card_count)
    local growNeedExperience = dms.atoi(shipGrowRequirement, ship_grow_requirement.grow_need_experience)
    local needCount = 0
    local have_numbers = 0

    if nil ~= Text_unlock_info then
        if waitOpenIndex < maxOpenIndex then
            Text_unlock_info:setString(tipStringInfo_hero_info[4])
        else
            Text_unlock_info:setString(string.format(tipStringInfo_hero_info[3], (self.ship.skill_grow_up_level + 1)))
        end
    end

    if nil ~= Text_talent_info then
        local talentId = openParam[1]
        local talentMould = dms.element(dms["talent_mould"], talentId)
        local talent_name = dms.atos(talentMould,talent_mould.talent_name)
        local talent_describe = dms.atos(talentMould,talent_mould.talent_describe)
        Text_talent_info:setString(string.format(tipStringInfo_hero_info[5], talent_name) .. talent_describe)
    end

    if nil ~= Text_demand_lv
        then
        -- 突破等级已满
        if waitOpenIndex < maxOpenIndex then
            Text_demand_lv:setVisible(true)
            Text_demand_lv:setString(tipStringInfo_hero_info[2])
        else
            local currentLevel = 0
            if self.camp == 0 then
                -- currentLevel = zstring.tonumber(_ED.user_info.user_grade)
                currentLevel = zstring.tonumber(_ED.home_build["1"].level)
            else
                if nil ~= _ED.other_user_info then
                    -- currentLevel = zstring.tonumber(_ED.other_user_info.user_level)
                    currentLevel = zstring.tonumber(_ED.home_build["1"].level)
                end
            end
            if currentLevel >= needLevel + 1 then
                -- Text_demand_lv:setVisible(false)
                Text_demand_lv:setColor(hero_skill_grade_color_info[3])
            else
                -- Text_demand_lv:setVisible(true)
                Text_demand_lv:setColor(hero_skill_grade_color_info[1])
            end
            Text_demand_lv:setString(string.format(tipStringInfo_hero_info[1], needLevel))
        end
    end

    if waitOpenIndex < maxOpenIndex or self.camp == 1 then
        self.Button_grade_up:setVisible(false)
        if nil ~= Text_demand_lv then
            Text_demand_lv:setVisible(false)
        end
    else
        self.Button_grade_up:setVisible(true)
    end

    if growNeedExperience > 0 then
        self.tracking = 1
        needCount = growNeedExperience
        have_numbers = _ED.user_info.jade
        Panel_hero_star_hero:setBackGroundImage("images/ui/props/props_4008.png")
    else
        self.tracking = 0
        needCount = needSameCardCount
        have_numbers = self:getShipNumber(needSameCardCount)
        Panel_hero_star_hero:setBackGroundImage(string.format("images/ui/props/props_%d.png", pic_index))
    end
    Text_hero_star_material_number:setString("x" .. needCount)
    Text_hero_star_gold_have:setString(string.format(red_alert_all_str[18], have_numbers))
    if zstring.tonumber(have_numbers) >= zstring.tonumber(needCount) then
        Text_hero_star_material_number:setColor(hero_skill_grade_color_info[3])
    else
        Text_hero_star_material_number:setColor(hero_skill_grade_color_info[1])
    end
end

function HeroMainGradeUp:onUpdate(dt) 
   
end

function HeroMainGradeUp:onEnterTransitionFinish()

end

function HeroMainGradeUp:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_main_grade_up)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 查看天赋信息
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_talent"), nil,
    {
        terminal_name = "hero_main_grade_up_open_talent", 
        -- func_string = [[funOpenDrawTip(99)]], 
        terminal_state = 0, 
        cell = self, 
        ship = self.ship,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    if self.camp == 0 then
    else
        ccui.Helper:seekWidgetByName(root, "Button_hero_star_dropped"):setVisible(false)
        -- ccui.Helper:seekWidgetByName(root, "Button_hero_star_dropped_1"):setVisible(false)
    end
    -- 掉落追踪
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_star_dropped"), nil, 
    {
        terminal_name = "hero_main_grade_up_goto_short_the_same_hero", 
        -- func_string = [[funOpenDrawTip(99)]], 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 掉落追踪
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_star_dropped_1"), nil, 
    {
        terminal_name = "hero_main_grade_up_goto_short_the_same_hero", 
        -- func_string = [[funOpenDrawTip(99)]], 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 角色技能突破
    local Button_grade_up = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_grade_up"), nil, 
    {
        terminal_name = "hero_main_grade_up_request_skill_grow", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    if nil ~= Button_grade_up and self.camp == 1 then
        Button_grade_up:setVisible(false)
    end
    self.Button_grade_up = Button_grade_up

    self:onUpdateDraw(true) 
end

function HeroMainGradeUp:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.ship = params[2]
    self.camp = params[3] -- 0我 1其它玩家
    self:onInit()
    return self
end

function HeroMainGradeUp:onExit()
    state_machine.remove("hero_main_grade_up_open_talent")
    state_machine.remove("hero_main_grade_up_window_show")  
    state_machine.remove("hero_main_grade_up_window_hide")
    state_machine.remove("hero_main_grade_up_goto_short_the_same_hero")
    state_machine.remove("hero_main_grade_up_change_ship")
    state_machine.remove("hero_main_grade_up_request_skill_grow")
end
