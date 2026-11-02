-- ----------------------------------------------------------------------------------------------------
-- 说明：武将限界突破
-------------------------------------------------------------------------------------------------------
AdventureHeroBreakthrough = class("AdventureHeroBreakthroughClass", Window)
    
function AdventureHeroBreakthrough:ctor()
    self.super:ctor()
    self.roots = {}

    self.hero = nil

    -- Initialize adventure hero breakthrough_ state machine.
    local function init_adventure_hero_breakthrough_terminal()
        local adventure_hero_breakthrough_ship_breakthrough_terminal = {
            _name = "adventure_hero_breakthrough_ship_breakthrough",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local advanceLevel, maxAdvanceLevel = getShipAwakenLv2(self.hero.ship_template_id, self.hero.ship_base_template_id)
                if advanceLevel < maxAdvanceLevel then
                    TipDlg.drawTextDailog(_string_piece_info[380])
                    return false
                end
                local function responseShipLimitBreakCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            -- print("武将限界突破成功。", response.node.hero.ship_breakthrough_level)
                            -- response.node.hero.ship_breakthrough_level = zstring.tonumber(response.node.hero.ship_breakthrough_level) + 1
                            -- response.node:updateDraw(false)
                            response.node:playAnimation()
                            state_machine.excute("adventure_hero_awaken_manager_update_hero_list_cell", 0, 0)
                            state_machine.excute("adventure_hero_storage_update_capacity_", 0, "")
                        end
                    end
                end
                protocol_command.ship_limit_break.param_list = "" .. instance.hero.ship_id
                NetworkManager:register(protocol_command.ship_limit_break.code, nil, nil, nil, instance, responseShipLimitBreakCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_hero_breakthrough_ship_breakthrough_terminal)
        state_machine.init()
    end
    
    -- call func init adventure hero breakthrough_ state machine.
    init_adventure_hero_breakthrough_terminal()
end

function AdventureHeroBreakthrough:init(hero)
    self.hero = hero
    self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
    return self
end

function AdventureHeroBreakthrough:updateStarList(shipBreakthroughLevel)
    local root = self.roots[1]
    local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
	
    local nMaxCount = #dms["limit_breached"]
    for i = 1, nMaxCount do
        local sprite = Panel_star:getChildByName("Sprite_star_" .. i)
        sprite:setVisible(true)
		display:ungray(sprite)
        if zstring.tonumber(shipBreakthroughLevel) < i then
            display:gray(sprite)
        end
    end
end

function AdventureHeroBreakthrough:updateListView()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_props")
    listView:removeAllItems()
    local needParam = {}
    local needPropList = zstring.split(dms.string(dms["pirates_config"], 298, pirates_config.param), "|")
    for i, v in pairs(needPropList) do
        local params = zstring.split(v, ",")
        table.insert(needParam, {_type = zstring.tonumber(params[1]), _prop_id = zstring.tonumber(params[2]), _prop_count = zstring.tonumber(params[3])})
    end

    local _width = 0
    local _nCount = 0
    for i, v in pairs(needParam) do
        local cell = nil
        if v._type == 6  then
            if v._prop_id > 0 then
                cell = adventureNewSmallPropIconCell:createCell()
                cell:init(0, {mould_id = v._prop_id} , nil, nil, "" .. getPropAllCountByMouldId(v._prop_id) .. "/" .. v._prop_count, 0)
            end
        else
            cell = adventureNewSmallPropIconCell:createCell()
            cell:init(0, {resource_type = v._type} , nil, nil, "" .. getResourceValueToStringForAdventure(v._prop_count), 0)
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

function AdventureHeroBreakthrough:updateDraw()
    local root = self.roots[1]
    local nMaxCount = #dms["limit_breached"]
    local shipBreakthroughLevel = zstring.tonumber(self.hero.ship_breakthrough_level)

    local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
    local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
    local Panel_11 = ccui.Helper:seekWidgetByName(root, "Panel_11")
    local Panel_2_0 = ccui.Helper:seekWidgetByName(root, "Panel_2_0")
    local Text_tupozhong = ccui.Helper:seekWidgetByName(root, "Text_tupozhong")

    Panel_1:setVisible(false)
    Panel_2:setVisible(false)
    Panel_11:setVisible(false)
    Panel_2_0:setVisible(false)
    Text_tupozhong:setVisible(false)
    if shipBreakthroughLevel == 0 then
        Panel_2:setVisible(true)
        Panel_1:setVisible(true)
        self:updateListView()
    else
        self:updateStarList(shipBreakthroughLevel)
        local Text_zhailibi = ccui.Helper:seekWidgetByName(root, "Text_zhailibi")
        Text_zhailibi:setString("" .. (dms.string(dms["limit_breached"], shipBreakthroughLevel, limit_breached.add_power) or 0) .. "%")
        if shipBreakthroughLevel == nMaxCount then
            Panel_2_0:setVisible(true)
            Panel_11:setVisible(true)

            -- 增加力量不显示-暂时不实现
            -- local Image_8 = ccui.Helper:seekWidgetByName(root, "Image_8")
            -- Image_8:setVisible(true)
            -- local Text_liliang = ccui.Helper:seekWidgetByName(root, "Text_liliang")
            -- Text_liliang:setString("+" .. 3)
        else
            Panel_1:setVisible(true)
            Panel_2_0:setVisible(true)
            Text_tupozhong:setVisible(true)
            self:updateListView()
        end
    end
end

function AdventureHeroBreakthrough:playAnimation()
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

function AdventureHeroBreakthrough:onEnterTransitionFinish()
    local csbAdventureHeroBreakthrough = csb.createNode("duplicate/awaken_jiexiantupo.csb")
    local root = csbAdventureHeroBreakthrough:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureHeroBreakthrough)

    -- 限界突破
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tupo_jx"),       nil, 
    {
        terminal_name = "adventure_hero_breakthrough_ship_breakthrough",     
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

function AdventureHeroBreakthrough:onExit()
    state_machine.remove("adventure_hero_breakthrough_ship_breakthrough")
end
