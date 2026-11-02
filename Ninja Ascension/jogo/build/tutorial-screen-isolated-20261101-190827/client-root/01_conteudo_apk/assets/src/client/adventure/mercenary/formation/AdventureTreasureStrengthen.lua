-- ----------------------------------------------------------------------------------------------------
-- 说明：宝具锻造
-------------------------------------------------------------------------------------------------------
AdventureTreasureStrengthen = class("AdventureTreasureStrengthenClass", Window)
    
function AdventureTreasureStrengthen:ctor()
    self.super:ctor()
    self.roots = {}

    -- Initialize adventure treasure strengthen state machine.
    local function init_adventure_treasure_strengthen_terminal()
        -- 宝具强化
        local adventure_treasure_strengthen_treasure_strengthen_terminal = {
            _name = "adventure_treasure_strengthen_treasure_strengthen",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseShipTrainCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            --print("宝具强化成功。", response.node.hero.treasure_strengthen_level)
                            -- response.node.hero.treasure_strengthen_level = zstring.tonumber(response.node.hero.treasure_strengthen_level) + 1
                            --response.node:updateDraw()
                            response.node:playAnimation()
                            state_machine.excute("adventure_strengthen_manager_update_hero_list_cell", 0, 0)
							state_machine.excute("adventure_battle_formation_update_draw", 0, nil)
                        end
                    end
                end
                protocol_command.ship_train.param_list = "" .. instance.hero.ship_id .. "\r\n" .. "0"
                NetworkManager:register(protocol_command.ship_train.code, nil, nil, nil, instance, responseShipTrainCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_treasure_strengthen_treasure_strengthen_terminal)
        state_machine.init()
    end
    
    -- call func init adventure treasure strengthen state machine.
    init_adventure_treasure_strengthen_terminal()
end

function AdventureTreasureStrengthen:init(hero)
    self.hero = hero
    self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
    return self
end

function AdventureTreasureStrengthen:updateDraw()
    local root = self.roots[1]
    -- 绘制宝具名称
    local skillMouldId = dms.atoi(self.mould_data, ship_mould.treasureSkill)
    local skillMould = dms.element(dms["skill_mould"], dms.int(dms["equipment_mould"], skillMouldId, equipment_mould.skill_mould))
    local skillName = dms.atos(skillMould, skill_mould.skill_name)
    ccui.Helper:seekWidgetByName(root, "Text_16"):setString(skillName)

    -- 绘制宝具的图标
    local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
    Panel_prop:removeAllChildren(true)
    local cell = AdventureSkillIconCell:createCell()
    cell:init(0, {id = skillMouldId}, 0, 2)
    Panel_prop:addChild(cell)
    -- 绘制四维属性
    ccui.Helper:seekWidgetByName(root, "Text_shuxin_1"):setString("0")
    ccui.Helper:seekWidgetByName(root, "Text_shuxin_2"):setString("0")
    ccui.Helper:seekWidgetByName(root, "Text_shuxin_3"):setString("0")
    ccui.Helper:seekWidgetByName(root, "Text_shuxin_4"):setString("0")
    local skillInfluences = zstring.split(dms.atos(skillMould, skill_mould.health_affect), ",")

    for i, v in pairs(skillInfluences) do
        local skillInfluenceMould = dms.element(dms["skill_influence"], v)
        local skillParam = dms.atoi(skillInfluenceMould, skill_influence.skill_category)
        if skillParam == 12 then
            ccui.Helper:seekWidgetByName(root, "Text_shuxin_1"):setString(dms.atoi(skillInfluenceMould, skill_influence.skill_effect_min_value))
        elseif skillParam == 13 then
            ccui.Helper:seekWidgetByName(root, "Text_shuxin_2"):setString(dms.atoi(skillInfluenceMould, skill_influence.skill_effect_min_value))
        elseif skillParam == 14 then
            ccui.Helper:seekWidgetByName(root, "Text_shuxin_3"):setString(dms.atoi(skillInfluenceMould, skill_influence.skill_effect_min_value))
        elseif skillParam == 15 then
            ccui.Helper:seekWidgetByName(root, "Text_shuxin_4"):setString(dms.atoi(skillInfluenceMould, skill_influence.skill_effect_min_value))
        end
    end

    -- 绘制消耗状态信息
    if zstring.tonumber(self.hero.treasure_strengthen_level) > 0 then
        -- 已经锻造
        ccui.Helper:seekWidgetByName(root, "Panel_10"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_11"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root, "Panel_11"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_10"):setVisible(false)
        -- 绘制消耗列表
        local needParam = {
            {_type = 1, _prop_id = 0, _prop_count = dms.int(dms["pirates_config"], 310, pirates_config.param)}
        }
        local needPropList = zstring.split(dms.string(dms["pirates_config"], 311, pirates_config.param), ";")
        for i, v in pairs(needPropList) do
            local params = zstring.split(v, ",")
            table.insert(needParam, {_type = 0, _prop_id = zstring.tonumber(params[1]), _prop_count = zstring.tonumber(params[2])})
        end

        local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
        listView:removeAllItems()
        local _width = 0
        local _nCount = 0
        for i, v in pairs(needParam) do
            local cell = nil
            if v._type == 0 then
                if v._prop_id > 0 then
                    cell = adventureNewSmallPropIconCell:createCell()
                    cell:init(0, {mould_id = v._prop_id} , nil, nil, "" .. getPropAllCountByMouldId(v._prop_id) .. "/" .. v._prop_count, 0)
                end
            elseif v._type == 1 then
                cell = adventureNewSmallPropIconCell:createCell()
                cell:init(0, {resource_type = 1} , nil, nil, "" .. getResourceValueToStringForAdventure(v._prop_count), 0)
            end
            if cell ~= nil then
                listView:addChild(cell)
                _width = cell:getContentSize().width
                _nCount = _nCount + 1
            end
        end
        listView:requestRefreshView()

        if listView._x == nil then
            listView._x = listView:getPositionX()
        end

        listView:setPositionX(listView._x - (_width + listView:getItemsMargin()) * (_nCount - 1) / 2)
    end
end

function AdventureTreasureStrengthen:playAnimation()
    local root = self.roots[1]
    local Panel_15 = ccui.Helper:seekWidgetByName(root, "Panel_15")
    local ArmatureNode_1 = Panel_15:getChildByName("ArmatureNode_1")
    local function changeActionCallback(armatureBack)
        armatureBack._self:updateDraw()
        armatureBack:setVisible(false)
        armatureBack._invoke = nil
    end
    ArmatureNode_1:setVisible(true)
    csb.animationChangeToAction(ArmatureNode_1, 0, 0, nil)
    ArmatureNode_1._invoke = changeActionCallback
end

function AdventureTreasureStrengthen:onEnterTransitionFinish()
    local csbAdventureTreasureStrengthen = csb.createNode("duplicate/treasure_strengthen.csb")
    local root = csbAdventureTreasureStrengthen:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureTreasureStrengthen)

    -- 宝具强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_dz_over"),       nil, 
    {
        terminal_name = "adventure_treasure_strengthen_treasure_strengthen",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 初始化动画文件
    local Panel_15 = ccui.Helper:seekWidgetByName(root, "Panel_15")
    local ArmatureNode_1 = Panel_15:getChildByName("ArmatureNode_1")
    ArmatureNode_1._self = self
    draw.initArmature(ArmatureNode_1, nil, -1, 0, 1)
    ArmatureNode_1:getAnimation():playWithIndex(0, 0, 0)

    self:updateDraw()
end

function AdventureTreasureStrengthen:onExit()
    state_machine.remove("adventure_treasure_strengthen_treasure_strengthen")
end
