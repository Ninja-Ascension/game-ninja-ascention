-- ----------------------------------------------------------------------------------------------------
-- 说明：武具强化
-------------------------------------------------------------------------------------------------------
AdventureEquipmentStrengthen = class("AdventureEquipmentStrengthenClass", Window)
    
function AdventureEquipmentStrengthen:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.default_success_rate = 100
    self.current_success_rate = 0
    self.add_need_gold = 0
    -- 刷新显示强化的状态机名称
    self.refreshStongName = nil
    self.ArmatureNode_strong = nil
    self.Button_qianghua = nil
    self.isCanClickStrengthen = true
    app.load("client.adventure.cells.prop.adventure_new_prop_small_icon_cell")
    -- Initialize adventure equipment strengthen state machine.
    local function init_adventure_equipment_strengthen_terminal()
        -- 减少宝石
        local adventure_equipment_strengthen_sub_gold_terminal = {
            _name = "adventure_equipment_strengthen_sub_gold",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.default_success_rate < instance.current_success_rate then
                    instance.current_success_rate = instance.current_success_rate - 1
                    local needGold = math.ceil((instance.current_success_rate - instance.default_success_rate) / self.add_need_gold)
                    -- 宝石消耗
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Text_xuezhuan"):setString("" .. needGold)
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Text_rate_1"):setString("" .. self.current_success_rate .. "%")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 增加宝石
        local adventure_equipment_strengthen_add_gold_terminal = {
            _name = "adventure_equipment_strengthen_add_gold",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if 100 > instance.current_success_rate then
                    instance.current_success_rate = instance.current_success_rate + 1
                    local needGold = math.ceil((instance.current_success_rate - instance.default_success_rate) / self.add_need_gold)
                    -- 宝石消耗
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Text_xuezhuan"):setString("" .. needGold)
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Text_rate_1"):setString("" .. self.current_success_rate .. "%")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--100%
		local adventure_equipment_strengthen_add_one_hundred_terminal = {
            _name = "adventure_equipment_strengthen_add_one_hundred",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if 100 > instance.current_success_rate then
                    instance.current_success_rate = instance.current_success_rate+100-instance.current_success_rate
                    local needGold = math.ceil((instance.current_success_rate - instance.default_success_rate) / self.add_need_gold)
                    -- 宝石消耗
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Text_xuezhuan"):setString("" .. needGold)
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Text_rate_1"):setString("" .. self.current_success_rate .. "%")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 武具强化
        local adventure_equipment_strengthen_equipment_strengthen_terminal = {
            _name = "adventure_equipment_strengthen_equipment_strengthen",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseShipEquipStrengthCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            -- print("武具强化成功。", response.node.hero.equipment_strengthen_level)
                            -- response.node.hero.equipment_strengthen_level = zstring.tonumber(response.node.hero.equipment_strengthen_level) + 1
                            -- response.node:updateDraw()
                            instance.ArmatureNode_strong:setVisible(true)
                            csb.animationChangeToAction(instance.ArmatureNode_strong, 0, 0, false)
                            instance.ArmatureNode_strong._invoke = function(armatureBack)
                                instance.ArmatureNode_strong:setVisible(false)
                                instance.isCanClickStrengthen = true
                            end
                            response.node.actions[1]:play("qianghua", false)
                            state_machine.excute("adventure_strengthen_manager_update_hero_list_cell", 0, 0)
                            state_machine.excute(params._datas.cell.refreshStongName, 0, 0)
                            state_machine.excute("adventure_hero_storage_update_capacity_", 0, "")
                        else
                            instance.isCanClickStrengthen = true
                        end
                    end
                    if _ED.equip_strength_result == 0 then
                        instance.ArmatureNode_strong:setVisible(true)
                            csb.animationChangeToAction(instance.ArmatureNode_strong, 1, 1, false)
                            instance.ArmatureNode_strong._invoke = function(armatureBack)
                                instance.ArmatureNode_strong:setVisible(false)
                                instance.isCanClickStrengthen = true
                            end
                    end
                end
                local needGold = 0
				if self.add_need_gold == 0 then
					needGold = 0
				else
					needGold = math.ceil((instance.current_success_rate - instance.default_success_rate) / self.add_need_gold)
				end
                
                if self.isCanClickStrengthen == true then 
                    self.isCanClickStrengthen = false
                    protocol_command.ship_equip_strength.param_list = "" .. instance.hero.ship_id .. "\r\n" .. needGold
                    NetworkManager:register(protocol_command.ship_equip_strength.code, nil, nil, nil, instance, responseShipEquipStrengthCallback, false, nil)
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_equipment_strengthen_sub_gold_terminal)
        state_machine.add(adventure_equipment_strengthen_add_gold_terminal)
        state_machine.add(adventure_equipment_strengthen_equipment_strengthen_terminal)
        state_machine.add(adventure_equipment_strengthen_add_one_hundred_terminal)
        state_machine.init()
    end
    
    -- call func init adventure equipment strengthen state machine.
    init_adventure_equipment_strengthen_terminal()
end

function AdventureEquipmentStrengthen:init(hero,refreshStongName)
    self.hero = hero
    self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
    self.refreshStongName = refreshStongName
    return self
end

function AdventureEquipmentStrengthen:updateDraw()
    local root = self.roots[1]

    -- 绘制武将的头像
  
    local iconPanel = ccui.Helper:seekWidgetByName(root, "Panel_prop")
    local cell = AdventureHeroIconCell:createCell()
    cell:init(0, self.hero, 1, 0, nil, nil, nil, nil, 0)
    iconPanel:removeAllChildren(true)
    iconPanel:addChild(cell)
    
    if tonumber(self.hero.equipment_strengthen_level) >= 30 then
        ccui.Helper:seekWidgetByName(root, "Panel_qianghua_1"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Panel_qianghua_2"):setVisible(true) 
        return
    else
        ccui.Helper:seekWidgetByName(root, "Panel_qianghua_1"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_qianghua_2"):setVisible(false) 
    end
    
    -- local current_equipment_strength_param = dms.element(dms["equipment_strength_param"], self.hero.equipment_strengthen_level)
    local currentShipRankUpParam = dms.element(dms["ship_rank_up_param"], (self.hero.equipment_strengthen_level + 1))
    self.currentShipRankUpParam = currentShipRankUpParam

    -- 绘制武将的强化前的等级
    ccui.Helper:seekWidgetByName(root, "Text_str_dj"):setString("" .. self.hero.equipment_strengthen_level)
    -- 绘制武将的强化后的等级
    ccui.Helper:seekWidgetByName(root, "Text_str_dj_1"):setString("" .. (self.hero.equipment_strengthen_level + 1))

    -- 绘制武将的强化前的战斗力提升
    local begainRankUpParam = dms.element(dms["ship_rank_up_param"], (self.hero.equipment_strengthen_level))
    ccui.Helper:seekWidgetByName(root, "Text_zhanli_begin"):setString("" .. (dms.atoi(begainRankUpParam, ship_rank_up_param.add_power) or 0) .. "%")
    -- 绘制武将的强化后的战斗力提升
    local endRankUpParam = dms.element(dms["ship_rank_up_param"], (self.hero.equipment_strengthen_level+1))
    ccui.Helper:seekWidgetByName(root, "Text_zhanli_1"):setString("" .. (dms.atoi(endRankUpParam, ship_rank_up_param.add_power) or 0) .. "%")

    -- 宝石消耗
    ccui.Helper:seekWidgetByName(root, "Text_xuezhuan"):setString("0")
    
    -- 强化的成功率
    self.default_success_rate =  (dms.atoi(currentShipRankUpParam, ship_rank_up_param.up_limit) or 100)
    self.current_success_rate = self.default_success_rate
    self.add_need_gold = (dms.atof(currentShipRankUpParam, ship_rank_up_param.extral_limit) or 0)
    ccui.Helper:seekWidgetByName(root, "Text_rate_1"):setString("" .. self.default_success_rate .. "%")

    -- 绘制道具消耗信息 -- ship_rank_up_param
    local shipRankUpParam = dms.element(dms["ship_rank_up_param"], (self.hero.equipment_strengthen_level + 1))
    if shipRankUpParam ~= nil then
        local needParam = {
                {_type = 0, _prop_id = dms.atoi(shipRankUpParam, ship_rank_up_param.prop1_mould), _prop_count = dms.atoi(shipRankUpParam, ship_rank_up_param.prop1_count)},
                {_type = 0, _prop_id = dms.atoi(shipRankUpParam, ship_rank_up_param.prop2_mould), _prop_count = dms.atoi(shipRankUpParam, ship_rank_up_param.prop2_count)},
                {_type = 0, _prop_id = dms.atoi(shipRankUpParam, ship_rank_up_param.prop3_mould), _prop_count = dms.atoi(shipRankUpParam, ship_rank_up_param.prop3_count)},
                {_type = 0, _prop_id = dms.atoi(shipRankUpParam, ship_rank_up_param.prop4_mould), _prop_count = dms.atoi(shipRankUpParam, ship_rank_up_param.prop4_count)},
                {_type = 0, _prop_id = dms.atoi(shipRankUpParam, ship_rank_up_param.prop5_mould), _prop_count = dms.atoi(shipRankUpParam, ship_rank_up_param.prop5_count)},
            }
        local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
        listView:removeAllItems()
        local _width = 0
        local _nCount = 0
        local isCanStrengthen = true
        for i, v in pairs(needParam) do
            if v._prop_id > 0 then
                local cell = adventureNewSmallPropIconCell:createCell()
                cell:init(0, {mould_id = v._prop_id} , nil, nil, "" .. getPropAllCountByMouldId(v._prop_id) .. "/" .. v._prop_count, 0)
                if tonumber(getPropAllCountByMouldId(v._prop_id)) < tonumber(v._prop_count) then
                    isCanStrengthen = false
                end
                listView:addChild(cell)
                _width = cell:getContentSize().width
                _nCount = _nCount + 1
            end
        end
        if isCanStrengthen == true then 
            self.Button_qianghua:setColor(cc.c3b(255, 255, 255))
        else
            self.Button_qianghua:setColor(cc.c3b(130, 130, 130))
        end
        listView:requestRefreshView()

        if listView._x == nil then
            listView._x = listView:getPositionX()
        end

        listView:setPositionX(listView._x - (_width + listView:getItemsMargin()) * (_nCount - 1) / 2)
    end

    -- 更新提示文字
    if zstring.tonumber(self.hero.equipment_strengthen_level) > 20 and zstring.tonumber(self.hero.treasure_strengthen_level) >0 then
		local Panel_qianghua = ccui.Helper:seekWidgetByName(root, "Panel_qianghua")
        Panel_qianghua:setVisible(false)
        local Panel_duanzhao = ccui.Helper:seekWidgetByName(root, "Panel_duanzhao")
        Panel_duanzhao:setVisible(true)
        -- 显示当前的宝具的名称
        -- local skillMouldId = dms.atoi(self.mould_data, ship_mould.treasureSkill)
        -- local skillName = dms.string(dms["skill_mould"], skillMouldId, skill_mould.skill_name)
        -- ccui.Helper:seekWidgetByName(root, "Text_duanzao_prop"):setString(skillName)
        local skillMouldId = dms.atoi(self.mould_data, ship_mould.treasureSkill)

        local skillMould = dms.element(dms["skill_mould"], dms.int(dms["equipment_mould"], skillMouldId, equipment_mould.skill_mould))
        local skillName = dms.atos(skillMould, skill_mould.skill_name)
        ccui.Helper:seekWidgetByName(root, "Text_duanzao_prop"):setString(skillName)
    else
        local Panel_qianghua = ccui.Helper:seekWidgetByName(root, "Panel_qianghua")
        Panel_qianghua:setVisible(true)
		local Panel_duanzhao = ccui.Helper:seekWidgetByName(root, "Panel_duanzhao")
        Panel_duanzhao:setVisible(false)
    end
end

function AdventureEquipmentStrengthen:onEnterTransitionFinish()
    local csbAdventureEquipmentStrengthen = csb.createNode("duplicate/weapon_strengthen.csb")
    local root = csbAdventureEquipmentStrengthen:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureEquipmentStrengthen)

    local action = csb.createTimeline("duplicate/weapon_strengthen.csb")
    table.insert(self.actions, action)
    csbAdventureEquipmentStrengthen:runAction(action)
    local armaturePanel = ccui.Helper:seekWidgetByName(root, "Panel_15")
    self.ArmatureNode_strong = armaturePanel:getChildByName("ArmatureNode_qianghua") -- 强化动画
    draw.initArmature( self.ArmatureNode_strong, nil, -1, 0, 1)
    csb.animationChangeToAction(self.ArmatureNode_strong, 0, 0, false)
    self.ArmatureNode_strong:setVisible(false)
    self.isCanClickStrengthen = true

    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
    
        local str = frame:getEvent()
        if str == "qianghua_over" then
            self:updateDraw()
        end
    end)

    -- 减少宝石
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jian"),       nil, 
    {
        terminal_name = "adventure_equipment_strengthen_sub_gold",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 增加宝石
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"),       nil, 
    {
        terminal_name = "adventure_equipment_strengthen_add_gold",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    self.Button_qianghua = ccui.Helper:seekWidgetByName(root, "Button_qianghua_over")
    -- 武具强化
    fwin:addTouchEventListener(self.Button_qianghua,       nil, 
    {
        terminal_name = "adventure_equipment_strengthen_equipment_strengthen",       
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	--100%
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bili"),       nil, 
    {
        terminal_name = "adventure_equipment_strengthen_add_one_hundred",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:updateDraw()
end

function AdventureEquipmentStrengthen:onExit()
    state_machine.remove("adventure_equipment_strengthen_sub_gold")
    state_machine.remove("adventure_equipment_strengthen_add_gold")
    state_machine.remove("adventure_equipment_strengthen_equipment_strengthen")
end
