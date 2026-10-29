-- ----------------------------------------------------------------------------------------------------
-- 说明：宿命武器
-------------------------------------------------------------------------------------------------------
AdventureMercenaryEquipmentFate = class("AdventureMercenaryEquipmentFateClass", Window)
    
function AdventureMercenaryEquipmentFate:ctor()
    self.super:ctor()
    self.roots = {}

    self.equip = nil
    self.fouceCell = nil
    self.selectCell = nil

    app.load("client.adventure.cells.equip.adventure_equip_list_icon_cell")

    -- Initialize adventure mercenary equipment fate state machine.
    local function init_adventure_mercenary_equipment_fate_terminal()
            -- 更新选中武器状态机
        local adventure_mercenary_equipment_fate_update_draw_terminal = {
            _name = "adventure_mercenary_equipment_fate_update_draw",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 选择装备的状态机
        local adventure_mercenary_equipment_fate_selected_terminal = {
            _name = "adventure_mercenary_equipment_fate_selected",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local selectCell = instance.selectCell
                if zstring.tonumber(selectCell.equip.user_equiment_id) <=0 then
                    return false
                end
                -- 网络的回调
                local function responseSwitchEquipmentCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:playAnimation()
                        end
                    end
                end
                protocol_command.switch_equipment.param_list = "" .. selectCell.equip.user_equiment_id
                NetworkManager:register(protocol_command.switch_equipment.code, nil, nil, nil, instance, responseSwitchEquipmentCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_mercenary_equipment_fate_update_draw_terminal)
        state_machine.add(adventure_mercenary_equipment_fate_selected_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mercenary equipment fate state machine.
    init_adventure_mercenary_equipment_fate_terminal()
end

function AdventureMercenaryEquipmentFate:init()
    return self
end

function AdventureMercenaryEquipmentFate:initListView()
    local root = self.roots[1]
    local ListView_wuqi = ccui.Helper:seekWidgetByName(root, "ListView_wuqi")
    local equipment_list = zstring.split(dms.string(dms["pirates_config"], 309, pirates_config.param), ",")
    ListView_wuqi:removeAllItems()
    -- 排序算法
    local sortFunc = function( cell1, cell2 )
        return cell2._flag > cell1._flag
    end

    local cells = {}
    for i, v in pairs(equipment_list) do
        
        local cell = AdventureEquipListIconCell:createCell()
        cell:init(fundEquipWidthId(v) or {user_equiment_template = v}, i)
        table.insert(cells,cell)
        if zstring.tonumber(cell.equip.ship_id) > 0 then
           cell._flag = 0
           self.selectCell = cell
        else
            if zstring.tonumber(cell.equip.user_equiment_id) <=0 then
                -- 未拥有的 就按照ID 大小排序
                cell._flag = tonumber(v)
            else
                --- 拥有的
                cell._flag = 1
            end
        end
    end
    table.sort(cells, sortFunc)
    for i, v in pairs(cells) do
        ListView_wuqi:addChild(v)
        if i == 1 and self.selectCell == nil then 
            --新手指引的引动,没有装备上去,切有这个装备
            self.selectCell = v
        end
    end

    if self.selectCell ~= nil then
        local parmas = { _datas = {}}
        parmas._datas.cell = self.selectCell
        self.fouceCell = self.selectCell
        state_machine.excute("adventure_equip_list_icon_cell_select", 0, parmas)
    end
end

-- 绘制当前的装备信息
function AdventureMercenaryEquipmentFate:updateDraw(cell)
    local root = self.roots[1]

    local equipmentName = dms.atos(cell.mould_data, equipment_mould.equipment_name)
    -- 绘制宿命武器的名称
    local Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")
    Text_11:setString("" .. equipmentName)
    -- 绘制宿命武器的图标
    local Panel_wuqi = ccui.Helper:seekWidgetByName(root, "Panel_wuqi")
    Panel_wuqi:removeAllChildren(true)
    local iconCell = AdventureSkillIconCell:createCell()
    iconCell:init(0, {id = cell.equip.user_equiment_template}, 0, 2, 1)

    local Text_dianji = ccui.Helper:seekWidgetByName(root, "Text_dianji")
    local Text_weihuode = ccui.Helper:seekWidgetByName(root, "Text_weihuode")
    local Text_yizhuangbei = ccui.Helper:seekWidgetByName(root, "Text_yizhuangbei")
    -- 武器是否获得
    if zstring.tonumber(cell.equip.user_equiment_id) > 0    then
        iconCell.roots[1]:setColor(cc.c3b(255, 255, 255))
        -- 是否装备
        if zstring.tonumber(cell.equip.ship_id) > 0    then
            Text_dianji:setVisible(false)
            Text_weihuode:setVisible(false)
            Text_yizhuangbei:setVisible(true)
        else
            Text_dianji:setVisible(true)
            Text_weihuode:setVisible(false)
            Text_yizhuangbei:setVisible(false)
        end
    else
        --这个地方要特别注意了,AdventureSkillIconCell在其他地方也用到了 ,这里修改后内存资源就变了
        iconCell.roots[1]:setColor(cc.c3b(130, 130, 130))
        Text_dianji:setVisible(false)
        Text_weihuode:setVisible(true)
        Text_yizhuangbei:setVisible(false)
    end
    Panel_wuqi:addChild(iconCell)
    -- 武器信息的显示
    local Text_wuqi_info = ccui.Helper:seekWidgetByName(root, "Text_wuqi_info")
    Text_wuqi_info:setString(dms.atos(cell.mould_data, equipment_mould.trace_remarks))

    -- 宿命技信息的显示
    local Text_suming_info = ccui.Helper:seekWidgetByName(root, "Text_suming_info")
    local skillMouldId = dms.atoi(cell.mould_data, equipment_mould.skill_mould)
    local skillMouldData = dms.element(dms["skill_mould"], skillMouldId)
    local skill_describe = dms.atos(skillMouldData, skill_mould.skill_describe)
    Text_suming_info:setString(skill_describe)
    -- 显示宿命技名称
    local Text_sumingji = ccui.Helper:seekWidgetByName(root, "Text_sumingji")
    Text_sumingji:setString(dms.atos(skillMouldData, skill_mould.skill_name))
    self.selectCell = cell
end

    -- 播放装备武器的动画
function AdventureMercenaryEquipmentFate:playAnimation()
    local root = self.roots[1]
    local Panel_11 = ccui.Helper:seekWidgetByName(root, "Panel_11")
    local ArmatureNode_1 = Panel_11:getChildByName("ArmatureNode_1")
    local function changeActionCallback(armatureBack)
        state_machine.excute("adventure_equip_list_icon_cell_update_draw", 0, self.fouceCell)
        state_machine.excute("adventure_equip_list_icon_cell_update_draw", 0, self.selectCell)
        self.fouceCell = self.selectCell

        armatureBack._self:updateDraw(self.fouceCell)
        armatureBack:setVisible(false)
        armatureBack._invoke = nil
    end
    ArmatureNode_1:setVisible(true)
    csb.animationChangeToAction(ArmatureNode_1, 0, 0, nil)
    ArmatureNode_1._invoke = changeActionCallback
end

function AdventureMercenaryEquipmentFate:onEnterTransitionFinish()
    local csbAdventureMercenaryEquipmentFate = csb.createNode("packs/Mercenary/yongbing_wuqi.csb")
    local root = csbAdventureMercenaryEquipmentFate:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMercenaryEquipmentFate)

    -- 创建顶部列表窗口
    self:initListView()

    -- 初始化动画
    local Panel_11 = ccui.Helper:seekWidgetByName(root, "Panel_11")
    local ArmatureNode_1 = Panel_11:getChildByName("ArmatureNode_1")
    ArmatureNode_1._self = self
    draw.initArmature(ArmatureNode_1, nil, -1, 0, 1)
    ArmatureNode_1:getAnimation():playWithIndex(0, 0, 0)

    -- 点击装备
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Text_dianji"),       nil, 
    {
        terminal_name = "adventure_mercenary_equipment_fate_selected",   
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMercenaryEquipmentFateClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureMercenaryEquipmentFate:onExit()
    state_machine.remove("adventure_mercenary_equipment_fate_update_draw")
    state_machine.remove("adventure_mercenary_equipment_fate_selected")
end


