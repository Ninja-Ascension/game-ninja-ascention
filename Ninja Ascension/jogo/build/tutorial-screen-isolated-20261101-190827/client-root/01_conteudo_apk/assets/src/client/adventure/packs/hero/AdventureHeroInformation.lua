-- ----------------------------------------------------------------------------------------------------
-- 说明：武将信息界面
-------------------------------------------------------------------------------------------------------
AdventureHeroInformation = class("AdventureHeroInformationClass", Window)
    
app.load("client.adventure.cells.prop.adventure_new_prop_small_icon_cell")
app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
app.load("client.adventure.cells.skill.adventure_skill_icon_cell")

function AdventureHeroInformation:ctor()
    self.super:ctor()
    self.roots = {}

    self.hero = nil
    self.selectCell = nil
    self.showRecruit = false
    self.Text_plCount = 0
    self.Button_pl = nil

    -- Initialize adventure hero information state machine.
    local function init_adventure_hero_information_terminal()
        -- 评价
        local adventure_hero_information_evaluation_terminal = {
            _name = "adventure_hero_information_evaluation",
            _init = function (terminal)
                app.load("client.adventure.mercenary.handbook.AdventureMercenaryEvaluationDialog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseShowShipMouldListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        fwin:open(AdventureMercenaryEvaluationDialog:new():init(tonumber(instance.hero.ship_template_id)), fwin._windows)
                    end
                end
                protocol_command.ship_comment_content.param_list = "" .. instance.hero.ship_template_id 
                NetworkManager:register(protocol_command.ship_comment_content.code, nil, nil, nil, nil, responseShowShipMouldListCallback, true, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 通过战船模板ID来招募
        local adventure_hero_information_recruit_with_ship_id_terminal = {
            _name = "adventure_hero_information_recruit_with_ship_id",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.adventure.packs.hero.AdventureHeroPurchase")
                fwin:open(AdventureHeroPurchase:new():init(instance.hero, instance.selectCell), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         -- 刷新灵魂石数量
        local adventure_hero_information_update_soul_stone_terminal = {
            _name = "adventure_hero_information_update_soul_stone",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
               instance:updateSouleStone()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         -- 刷新评论数
        local adventure_hero_information_evaluation_count_update_terminal = {
            _name = "adventure_hero_information_evaluation_count_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateEvaluation()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(adventure_hero_information_evaluation_terminal)
        state_machine.add(adventure_hero_information_recruit_with_ship_id_terminal)
        state_machine.add(adventure_hero_information_evaluation_count_update_terminal)
        state_machine.add(adventure_hero_information_update_soul_stone_terminal)
    
        state_machine.init()
    end
    
    -- call func init adventure hero information state machine.
    init_adventure_hero_information_terminal()
end

function AdventureHeroInformation:init(hero, selectCell)
    self.hero = hero
    local propr_id = dms.int(dms["ship_mould"], hero.ship_template_id, ship_mould.refine_get_jade)
    local handbook = _ED.user_prop_soul_stone["" .. propr_id]

    self.showRecruit = true
    -- if -- fundShipWidthBaseTemplateId(""..hero.ship_template_id) == nil and 
    --     _ED.hero_handbook["" .. hero.ship_template_id] ~= nil
    --     --_ED.user_prop_soul_stone["" .. propr_id] ~= nil 

    --     then
    
    -- end
    self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
    self.selectCell = selectCell
    return self
end

function AdventureHeroInformation:updateEvaluation()
    local root = self.roots[1]
    if root == nil or self.Text_plCount ==nil then 
        return
    end
     if _ED.ship_comment["" .. self.hero.ship_template_id] ~= nil then 
        
        plCount =_ED.ship_comment["" .. self.hero.ship_template_id]
        self.Text_plCount:setString("" .. plCount)
    else
        self.Text_plCount:setString("0")
    end
    
end

function AdventureHeroInformation:updateSouleStone()
    local root = self.roots[1]
    if root == nil  then 
        return
    end
       -- 炼化得到的将魂
    local propr_id = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.refine_get_jade)
    local handbook = _ED.user_prop_soul_stone["" .. propr_id]
    if handbook ~= nil then
        ccui.Helper:seekWidgetByName(root, "Text_linghun"):setString(handbook)
    else
        ccui.Helper:seekWidgetByName(root, "Text_linghun"):setString("0")
    end

    
end

function AdventureHeroInformation:onEnterTransitionFinish()
    local csbAdventureHeroInformation = csb.createNode("packs/Mercenary/yongbing_info.csb")
    local root = csbAdventureHeroInformation:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureHeroInformation)
    self.Button_pl = ccui.Helper:seekWidgetByName(root, "Button_17")
    self.Text_plCount = ccui.Helper:seekWidgetByName(root, "Text_pingjia")
    self.Text_plCount:setVisible(true)
    local plCount = 0
    if _ED.ship_comment["" .. self.hero.ship_template_id] ~= nil then 
        plCount =_ED.ship_comment["" .. self.hero.ship_template_id]
    end
    self.Text_plCount:setString("" .. plCount)

    self.Button_pl:setVisible(true)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureHeroInformationClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureHeroInformationClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 评价
    fwin:addTouchEventListener(self.Button_pl,       nil, 
    {
        terminal_name = "adventure_hero_information_evaluation",    
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 显示重新招募
    local recruitPad = ccui.Helper:seekWidgetByName(root, "Panel_1")
    recruitPad:setVisible(false)
    if self.showRecruit == true and self.selectCell ~= nil then
        recruitPad:setVisible(true)

        -- 重新召唤
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhao"),       nil, 
        {
            terminal_name = "adventure_hero_information_recruit_with_ship_id",       
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 2)
    end

    -- 绘制标题名称
    local titleName = dms.atos(self.mould_data, ship_mould.captain_name)
    local quality = dms.atoi(self.mould_data, ship_mould.ship_type)
    local titleText = ccui.Helper:seekWidgetByName(root, "Text_role_name")
    titleText:setColor(cc.c3b(hero_name_color_Type[quality+1][1],hero_name_color_Type[quality+1][2],hero_name_color_Type[quality+1][3]))
    titleText:setString(titleName)

    ccui.Helper:seekWidgetByName(root, "Text_zhonglei"):setString("*/*/*/*")

    -- 绘制武将动画
    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role_1")
    Panel_role:removeAllChildren(true)
    local temp_bust_index = dms.atoi(self.mould_data, ship_mould.bust_index)
    -- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
    local spx = AdventureSpriteBattle:create(temp_bust_index, 9) -- ccs.Armature:create("spirte_" .. temp_bust_index)
    local size = spx:getContentSize()
    spx:getAnimation():playWithIndex(0)
    spx:setAnchorPoint(cc.p(0.5,0.0))
    spx:setPosition(cc.p(2, -size.height/2))
    Panel_role:addChild(spx)
    spx:getAnimation():setSpeedScale(0.4)

    -- 绘制武将签名
    local sign_msg = dms.atos(self.mould_data, ship_mould.sign_msg)
    ccui.Helper:seekWidgetByName(root, "Text_role_shuohua"):setString(sign_msg)

    -- 绘制武将名称
    ccui.Helper:seekWidgetByName(root, "Text_rolename"):setString("——" .. titleName)

    -- 绘制武将简介
    local introduce = dms.atos(self.mould_data, ship_mould.introduce)
    ccui.Helper:seekWidgetByName(root, "Text_role_info"):setString(introduce)

    -- 炼化得到的将魂
    local propr_id = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.refine_get_jade)
    local handbook = _ED.user_prop_soul_stone["" .. propr_id]
    if handbook ~= nil then 
        ccui.Helper:seekWidgetByName(root, "Text_linghun"):setString(handbook)
    else
        ccui.Helper:seekWidgetByName(root, "Text_linghun"):setString("0")
    end

    -- 绘制装备、技能信息
    local cells = {}
    if dms.atoi(self.mould_data, ship_mould.deadly_skill_mould) ~= -1 then
        local cell = AdventureSkillIconCell:createCell()
        cell:init(99, {id=dms.atoi(self.mould_data, ship_mould.deadly_skill_mould)},0)
        table.insert(cells, cell)
    end
    if dms.atoi(self.mould_data, ship_mould.fitSkillOne) ~= -1 then
        local cell = AdventureSkillIconCell:createCell()
        cell:init(99, {id=dms.atoi(self.mould_data, ship_mould.fitSkillOne)},0)
        table.insert(cells, cell)
    end
    if dms.atoi(self.mould_data, ship_mould.fitSkillTwo) ~= -1 then
        local cell = AdventureSkillIconCell:createCell()
        cell:init(99, {id=dms.atoi(self.mould_data, ship_mould.fitSkillTwo)},0)
        table.insert(cells, cell)
    end
    if dms.atoi(self.mould_data, ship_mould.treasureSkill) ~= -1 then
        local cell = AdventureSkillIconCell:createCell()
        cell:init(99, {id=dms.atoi(self.mould_data, ship_mould.treasureSkill)},0,2)
        table.insert(cells, cell)
    end
    for i, v in pairs(cells) do
        ccui.Helper:seekWidgetByName(root, "Panel_skill_" .. i):addChild(v)
    end
end

function AdventureHeroInformation:onExit()
    state_machine.remove("adventure_hero_information_evaluation")
    state_machine.remove("adventure_hero_information_recruit_with_ship_id")
    state_machine.remove("adventure_hero_information_open_discuss_dialog")
    
    -- 显示招募成功的界面
    state_machine.excute("adventure_recruit_success_show", 0, 0)
    state_machine.excute("adventure_recruit_success_ten_show", 0, 0)
end
