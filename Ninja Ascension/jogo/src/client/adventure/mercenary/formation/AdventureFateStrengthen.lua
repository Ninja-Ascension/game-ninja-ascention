-- ----------------------------------------------------------------------------------------------------
-- 说明：宿命武器强化
-------------------------------------------------------------------------------------------------------
AdventureFateStrengthen = class("AdventureFateStrengthenClass", Window)
    
function AdventureFateStrengthen:ctor()
    self.super:ctor()
    self.roots = {}

    self.hero = nil
    self.mould_data = nil
    self.hero_list_cell = nil
    self.fatePanel = nil
    -- 刷新强化显示的状态机的名称
    self.refreshStongName = nil
    self.ArmatureNode_strong = nil
    app.load("client.adventure.cells.prop.adventure_new_prop_small_icon_cell")
    -- Initialize adventure hero awaken state machine.
    local function init_adventure_hero_awaken_terminal()
        -- 更多宿命武器
        local adventure_hero_awaken_view_more_terminal = {
            _name = "adventure_hero_awaken_view_more",
            _init = function (terminal)
                app.load("client.adventure.mercenary.equipment.AdventurEquipmentFateListView")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventurEquipmentFateListView:new():init(instance.hero), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 宿命武器强化
        local adventure_hero_awaken_ship_destiny_strength_terminal = {
            _name = "adventure_hero_awaken_ship_destiny_strength",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
     
                local function responseShipDestinyStrengthCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:updateDraw()
                            instance.ArmatureNode_strong:setVisible(true)
                            csb.animationChangeToAction(instance.ArmatureNode_strong, 0, 0, false)
                            instance.ArmatureNode_strong._invoke = function(armatureBack)
                                instance.ArmatureNode_strong:setVisible(false)
                            end

                            if params._datas.cell.refreshStongName ~= nil then
                                state_machine.excute(params._datas.cell.refreshStongName , 0 , 0)
                            end
                            state_machine.excute("adventure_fate_strengthen_update_hero_list_cell", 0, 0)
                        end
                    end
                end
                protocol_command.ship_destiny_strength.param_list = "" .. instance.hero.ship_id
                NetworkManager:register(protocol_command.ship_destiny_strength.code, nil, nil, nil, instance, responseShipDestinyStrengthCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新列表中的武将信息
        local adventure_fate_strengthen_update_hero_list_cell_terminal = {
            _name = "adventure_fate_strengthen_update_hero_list_cell",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.hero_list_cell ~= nil then
                    instance.hero_list_cell:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_hero_awaken_view_more_terminal)
        state_machine.add(adventure_hero_awaken_ship_destiny_strength_terminal)
        state_machine.add(adventure_fate_strengthen_update_hero_list_cell_terminal)
        state_machine.init()
    end
    
    -- call func init adventure hero awaken state machine.
    init_adventure_hero_awaken_terminal()
end

function AdventureFateStrengthen:init(hero, cell,refreshStongName)
    self.hero = hero
    self.hero_list_cell = cell
    self.refreshStongName = refreshStongName
    return self
end

function AdventureFateStrengthen:updateDraw()

    local currentLevel = zstring.tonumber(self.hero.equipment_strengthen_level)

    local currentDestinyStrengthParam = dms.element(dms["destiny_strength_param"], (currentLevel))
    local nextDestinyStrengthParam = dms.element(dms["destiny_strength_param"], (currentLevel + 1))
    nextDestinyStrengthParam = nextDestinyStrengthParam or currentDestinyStrengthParam

    -- 绘制宿命武器等级
    ccui.Helper:seekWidgetByName(self.roots[1], "Text_shuming"):setString("Lv" .. self.hero.equipment_strengthen_level .. "/10")
    -- 绘制宿命武器图片   换成相应的图片
    local picIndex = 1
    local equipInfo = nil
    local name = "" 
    if _ED.showed_destiny_equip_mould == -1 then 
         equipInfo = nil
    else
        equipInfo=  dms.element(dms["equipment_mould"], _ED.showed_destiny_equip_mould)
        picIndex = dms.atos(equipInfo, equipment_mould.pic_index)
        name = dms.atos(equipInfo, equipment_mould.equipment_name)
    end
    if equipInfo == nil then 
        ccui.Helper:seekWidgetByName(self.roots[1], "Text_wuqi"):setString(_string_piece_info[422])
        ccui.Helper:seekWidgetByName(self.roots[1], "Panel_prop_xiaohao"):setVisible(false)
    else 
        ccui.Helper:seekWidgetByName(self.roots[1], "Text_wuqi"):setString(name)
        ccui.Helper:seekWidgetByName(self.roots[1], "Panel_prop_xiaohao"):setBackGroundImage(string.format("images/face/hero_head/bg_skill_skill_%d.png", zstring.tonumber(picIndex)))
    end

    -- 点亮宿命
    for i = 1, currentLevel do
        local fatePanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_14_" .. i)
        fatePanel:getChildByName("Text_liang"):setVisible(true)
        fatePanel:getChildByName("Image_an_" .. i):setVisible(true)
        fatePanel:getChildByName("Image_liang_" .. i):setVisible(true)
    end

    -- 绘制可以唤醒的数
    local fCount = currentLevel == 10 and "10" or (currentLevel + 1)
    ccui.Helper:seekWidgetByName(self.roots[1], "Text_ceng"):setString(fCount)

    -- 提升前的战力提升
    ccui.Helper:seekWidgetByName(self.roots[1], "Text_zhanli"):setString("" .. (dms.atoi(currentDestinyStrengthParam, destiny_strength_param.property_add_rate) or 0) .."%")
    -- 提升后的战力提升
    ccui.Helper:seekWidgetByName(self.roots[1], "Text_zhanli_1"):setString("" .. dms.atoi(nextDestinyStrengthParam, destiny_strength_param.property_add_rate) .. "%")

    if currentLevel < 10 or true then
        local needParam = {
            {_type = 0, _prop_id = dms.atoi(nextDestinyStrengthParam, destiny_strength_param.consume_prop1_id), _prop_count = dms.atoi(nextDestinyStrengthParam, destiny_strength_param.consume_prop1_count)},
            {_type = 0, _prop_id = dms.atoi(nextDestinyStrengthParam, destiny_strength_param.consume_prop2_id), _prop_count = dms.atoi(nextDestinyStrengthParam, destiny_strength_param.consume_prop2_count)},
            {_type = 0, _prop_id = dms.atoi(nextDestinyStrengthParam, destiny_strength_param.consume_prop3_id), _prop_count = dms.atoi(nextDestinyStrengthParam, destiny_strength_param.consume_prop3_count)},
            {_type = 0, _prop_id = dms.atoi(nextDestinyStrengthParam, destiny_strength_param.consume_prop4_id), _prop_count = dms.atoi(nextDestinyStrengthParam, destiny_strength_param.consume_prop4_count)},
        }

        -- 绘制资源消耗需求
        local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_prop")
        listView:removeAllItems()
        listView:setVisible(true)
        local _width = 0
        local _nCount = 0
        for i, v in pairs(needParam) do
            if v._prop_id > 0 then
                local cell = adventureNewSmallPropIconCell:createCell()
                cell:init(0, {mould_id = v._prop_id} , nil, nil, "" .. getPropAllCountByMouldId(v._prop_id) .. "/" .. v._prop_count, 0)
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

function AdventureFateStrengthen:onEnterTransitionFinish()
    local csbAdventureFateStrengthen = csb.createNode("packs/Mercenary/fatalism_strength.csb")
    local root = csbAdventureFateStrengthen:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureFateStrengthen)
    local armaturePanel = ccui.Helper:seekWidgetByName(root, "Panel_15")
    self.ArmatureNode_strong = armaturePanel:getChildByName("ArmatureNode_sm_1") -- 技能动画
    draw.initArmature( self.ArmatureNode_strong, nil, -1, 0, 1)
    csb.animationChangeToAction(self.ArmatureNode_strong, 0, 0, false)
    self.ArmatureNode_strong:setVisible(false)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureFateStrengthenClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 更多宿命武器
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_juexing_sure_0"),       nil, 
    {
        terminal_name = "adventure_hero_awaken_view_more",   
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 确认强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_strength_sure"),       nil, 
    {
        terminal_name = "adventure_hero_awaken_ship_destiny_strength",      
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:updateDraw()
end

function AdventureFateStrengthen:onExit()
    state_machine.remove("adventure_hero_awaken_view_more")
    state_machine.remove("adventure_hero_awaken_ship_destiny_strength")
    state_machine.remove("adventure_fate_strengthen_update_hero_list_cell")
end
