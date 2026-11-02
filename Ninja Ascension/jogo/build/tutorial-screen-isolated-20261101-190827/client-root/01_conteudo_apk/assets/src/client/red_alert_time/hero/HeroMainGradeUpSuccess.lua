-- ---------------------------
-- 英雄武学突破成功的界面
-- ---------------------------
HeroMainGradeUpSuccess = class("HeroMainGradeUpSuccessClass", Window)

local hero_main_grade_up_success_window_open_terminal = {
    _name = "hero_main_grade_up_success_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroMainGradeUpSuccessClass")
        if nil == _Window then
            fwin:open(HeroMainGradeUpSuccess:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local hero_main_grade_up_success_window_close_terminal = {
    _name = "hero_main_grade_up_success_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.unlock("hero_main_grade_up_request_skill_grow", 0, 0)
        fwin:close(fwin:find("HeroMainGradeUpSuccessClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_main_grade_up_success_window_open_terminal)
state_machine.add(hero_main_grade_up_success_window_close_terminal)
state_machine.init()

function HeroMainGradeUpSuccess:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- load lua files
 
    -- var
    -- 用户武将数据
    self.ship = nil
end

function HeroMainGradeUpSuccess:onUpdateDraw(change)
    local root = self.roots[1]

    local Panel_quality_1 = ccui.Helper:seekWidgetByName(root, "Panel_quality_1")
    local Panel_quality_2 = ccui.Helper:seekWidgetByName(root, "Panel_quality_2")
    local Panel_role_1 = ccui.Helper:seekWidgetByName(root, "Panel_role_1")
    local Panel_role_2 = ccui.Helper:seekWidgetByName(root, "Panel_role_2")
    local Text_skill_name = ccui.Helper:seekWidgetByName(root, "Text_skill_name")
    local Text_hero_name_1 = ccui.Helper:seekWidgetByName(root, "Text_hero_name_1")
    local Text_hero_name_2 = ccui.Helper:seekWidgetByName(root, "Text_hero_name_2")
    local Text_skill_info = ccui.Helper:seekWidgetByName(root, "Text_skill_info")

    local ship_mould_id = self.ship.ship_template_id or self.ship.ship_mould_id
    local picIndex = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.head_icon)       --头像图标
    local quality = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.ship_type)        --角色颜色品质
    local shipSkillGrowUpParam = dms.string(dms["ship_mould"], ship_mould_id, ship_mould.skill_grow_up_param)
    shipSkillGrowUpParam = zstring.split(shipSkillGrowUpParam, "|")
    
    if zstring.tonumber(self.ship.skill_grow_up_level) <= 0 then
        self.ship.skill_grow_up_level = 1
    elseif zstring.tonumber(self.ship.skill_grow_up_level) >= #shipSkillGrowUpParam then
        self.ship.skill_grow_up_level = #shipSkillGrowUpParam
    end
    shipSkillGrowUpParam = zstring.split(shipSkillGrowUpParam[self.ship.skill_grow_up_level], ",")

    local talentId = shipSkillGrowUpParam[1]
    local talentMould = dms.element(dms["talent_mould"], talentId)
    local talent_name = dms.atos(talentMould,talent_mould.talent_name)
    local talent_describe = dms.atos(talentMould,talent_mould.talent_describe)
    local quality = self.ship.ship_type

    Panel_quality_1:setBackGroundImage(string.format("images/ui/quality/hero_icon_quality_%d.png", quality))
    Panel_quality_2:setBackGroundImage(string.format("images/ui/quality/hero_icon_quality_%d.png", quality))
    Panel_role_1:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
    Panel_role_2:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
    Text_skill_name:setString(talent_name)

    local lastLevel = self.ship.skill_grow_up_level - 1
    -- 显示突破前武将名称+N
    Text_hero_name_1:setString(self.ship.captain_name .. "+" .. lastLevel)
    Text_hero_name_1:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))

    -- 显示突破后武将名称+N+1
    Text_hero_name_2:setString(self.ship.captain_name .. "+" .. self.ship.skill_grow_up_level )
    Text_hero_name_2:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))

    -- 显示解锁天赋技能的描述
    Text_skill_info:setString(talent_describe)


    -- Text_skill_name:setString(talent_describe)

    -- -- 绘制武学列表
    -- local ListView_grade = ccui.Helper:seekWidgetByName(root, "ListView_grade")
    -- local items = nil
    -- if true == change then
    --     ListView_grade:removeAllItems()
    -- else
    --     items = ListView_grade:getItems()
    -- end
    -- local lvSize = ListView_grade:getContentSize()
    -- local ship_mould_id = self.ship.ship_template_id or self.ship.ship_mould_id
    -- local shipSkillGrowUpParam = dms.string(dms["ship_mould"], ship_mould_id, ship_mould.skill_grow_up_param)
    -- -- debug.print_r(shipSkillGrowUpParam)
    -- shipSkillGrowUpParam = zstring.split(shipSkillGrowUpParam, "|")
    -- local height = 0
    -- local maxOpenIndex = 0
    -- local waitOpenIndex = -1
    -- for i, v in pairs(shipSkillGrowUpParam) do
    --     local params = zstring.split(v, ",")
    --     local talentId = params[1]
    --     local resourceNeedId = params[2]
    --     local isAlive = self.ship.skill_grow_up_states[i] == "1"
    --     if isAlive then
    --         maxOpenIndex = i
    --     else
    --         if waitOpenIndex < 0 then
    --             waitOpenIndex = i
    --         end
    --     end
    --     local cell = nil 
    --     if true == change then
    --         cell = state_machine.excute("hero_skill_grow_up_list_cell_create", 0, {self.ship, lvSize.width, talentId, resourceNeedId, isAlive})
    --         ListView_grade:addChild(cell)
    --         height = height + cell:getContentSize().height
    --     else
    --         cell = items[i]
    --         if isAlive ~= cell.isAlive then
    --             print(isAlive, cell.isAlive)
    --             state_machine.excute("hero_skill_grow_up_list_cell_update_draw", 0, {cell, isAlive})
    --         end
    --     end
    -- end

    -- if true == change then
    --     if lvSize.height < height then
    --         lvSize.height = height
    --     end
    --     ListView_grade:setInnerContainerSize(lvSize)
    --     ListView_grade:requestRefreshView()
    -- end

    -- -- 绘制资源消耗
    -- local Panel_hero_star_hero = ccui.Helper:seekWidgetByName(root, "Panel_hero_star_hero") -- 资源图标
    -- local Text_hero_star_material_number = ccui.Helper:seekWidgetByName(root, "Text_hero_star_material_number") -- 资源需求数量
    -- local Text_hero_star_gold_have = ccui.Helper:seekWidgetByName(root, "Text_hero_star_gold_have") -- 当前拥有的数量

    -- Panel_hero_star_hero:removeAllChildren(true)

    -- local pic_index = dms.int(dms["ship_mould"], self.ship.ship_base_template_id,ship_mould.head_icon) + 10000
    -- local drawIndex = maxOpenIndex
    -- if waitOpenIndex > maxOpenIndex then
    --     drawIndex = waitOpenIndex
    -- end
    -- local openParam = zstring.split(shipSkillGrowUpParam[drawIndex], ",")
    -- local shipGrowRequirement = dms.element(dms["ship_grow_requirement"], openParam[2])
    -- local needSameCardCount = dms.atoi(shipGrowRequirement, ship_grow_requirement.need_same_card_count)
    -- local have_numbers = self:getShipNumber(needSameCardCount)

    -- Panel_hero_star_hero:setBackGroundImage(string.format("images/ui/props/props_%d.png", pic_index))
    -- Text_hero_star_material_number:setString("x" .. needSameCardCount)
    -- Text_hero_star_gold_have:setString(string.format(red_alert_all_str[18], have_numbers))
end

function HeroMainGradeUpSuccess:onEnterTransitionFinish()

end

function HeroMainGradeUpSuccess:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_grade_up_success)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.hero.hero_grade_up_success)
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_open", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_open_over" then
        elseif str == "over" then 
            state_machine.unlock("hero_main_grade_up_success_window_close", 0, 0)
        end
    end)

    -- 掉落追踪
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_hero_grade_up_success_close"), nil, 
    {
        terminal_name = "hero_main_grade_up_success_window_close", 
        -- func_string = [[funOpenDrawTip(99)]], 
        terminal_state = 0, 
        cell = self, 
    }, nil, 2)
    state_machine.lock("hero_main_grade_up_success_window_close", 0, 0)

    playEffect(formatMusicFile("effect", 10023))
    self:onUpdateDraw(true) 
end

function HeroMainGradeUpSuccess:init(params)
    self.ship = params

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/hero_tupo/hero_tupo.ExportJson")

    self:onInit()
    return self
end

function HeroMainGradeUpSuccess:onExit()
    ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo("images/ui/effice/hero_tupo/hero_tupo.ExportJson")
end

function HeroMainGradeUpSuccess:onUpdate(dt)
    if fwin:find("TuitionControllerClass") ~= nil and fwin:find("TuitionControllerClass"):isVisible() == true then
        fwin:find("TuitionControllerClass"):setVisible(false)
    end
    if fwin:find("WindowLockClass") ~= nil and fwin:find("WindowLockClass"):isVisible() == true then
        fwin:find("WindowLockClass"):setVisible(false)
    end
    if fwin:find("RoleDialogueClass") ~= nil and fwin:find("RoleDialogueClass"):isVisible() == true then
        fwin:find("RoleDialogueClass"):setVisible(false)
    end
end

function HeroMainGradeUpSuccess:destroy()
    if fwin:find("TuitionControllerClass") ~= nil then
        fwin:find("TuitionControllerClass"):setVisible(true)
    end
    if fwin:find("WindowLockClass") ~= nil then
        fwin:find("WindowLockClass"):setVisible(true)
    end
    if fwin:find("RoleDialogueClass") ~= nil then
        fwin:find("RoleDialogueClass"):setVisible(true)
    end
end
