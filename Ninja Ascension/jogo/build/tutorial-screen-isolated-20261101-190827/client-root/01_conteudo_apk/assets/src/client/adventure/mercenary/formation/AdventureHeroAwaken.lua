-- ----------------------------------------------------------------------------------------------------
-- 说明：武将觉醒
-------------------------------------------------------------------------------------------------------
AdventureHeroAwaken = class("AdventureHeroAwakenClass", Window)
    
function AdventureHeroAwaken:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.hero = nil

    app.load("client.loader.formula")

    -- Initialize adventure hero awaken state machine.
    local function init_adventure_hero_awaken_terminal()
        -- 觉醒
        local adventure_hero_awaken_ship_strengthen_terminal = {
            _name = "adventure_hero_awaken_ship_strengthen",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)                
                local function responseShipGrowUpCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node.actions[1]:play("juexing", false)
                            --state_machine.excute("adventure_hero_awaken_manager_update_hero_list_cell", 0, 0)
                        end
                    end
                    state_machine.excute("adventure_hero_storage_update_capacity_", 0, "")
                    state_machine.excute("adventure_hero_awaken_manager_update_hero_list_cell", 0, 0)
                end

                protocol_command. ship_grow_up.param_list = "" .. instance.hero.ship_id .. "\r\n" .. "" .. "\r\n"  .. "" .. "\r\n"  .. "" .. "\r\n" 
                NetworkManager:register(protocol_command.ship_grow_up.code, nil, nil, nil, instance, responseShipGrowUpCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_hero_awaken_ship_strengthen_terminal)
        state_machine.init()
    end
    
    -- call func init adventure hero awaken state machine.
    init_adventure_hero_awaken_terminal()
end

function AdventureHeroAwaken:init(hero)
    self.hero = hero
    self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
    return self
end

function AdventureHeroAwaken:updateDraw()
    local root = self.roots[1]

    local advanceLevel, maxAdvanceLevel = getShipAwakenLv2(self.hero.ship_template_id, self.hero.ship_base_template_id)
    local level = zstring.tonumber(self.hero.ship_grade)

    -- 绘制武将的头像
    local cell = AdventureHeroIconCell:createCell()
    cell:init(0, self.hero, 1, 0, nil, nil, nil, nil, 0)
    ccui.Helper:seekWidgetByName(root, "Panel_role"):removeAllChildren(true)
    ccui.Helper:seekWidgetByName(root, "Panel_role"):addChild(cell)

    -- 绘制角色的觉醒等级-前
    local Panel_yu_qian = ccui.Helper:seekWidgetByName(root, "Panel_yu_qian")
    for i = 1, maxAdvanceLevel do
        local sprite = Panel_yu_qian:getChildByName("Sprite_yu_".. i .."_qian")
        sprite:setVisible(true)
        if advanceLevel < i then
            display:gray(sprite)
        end
    end
    -- 绘制角色的觉醒等级-后
    local nextAdvanceLevel = math.min(advanceLevel + 1, maxAdvanceLevel)
    local Panel_yu_hou = ccui.Helper:seekWidgetByName(root, "Panel_yu_hou")
    for i = 1, maxAdvanceLevel do
        local sprite = Panel_yu_hou:getChildByName("Sprite_yu_".. i .."_hou")
        sprite:setVisible(true)
        if nextAdvanceLevel < i then
            display:gray(sprite)
        end
    end

    -- 绘制战斗力的提升-前
    ccui.Helper:seekWidgetByName(root, "Text_zhanli_qian"):setString(self.hero.hero_fight)
    -- 绘制战斗力的提升-后
    local nextFight = self.hero.hero_fight
    if advanceLevel < maxAdvanceLevel then
        nextFight = nextFight + get_ship_growup_added_fight_force(self.hero)
    end
    ccui.Helper:seekWidgetByName(root, "Text_zhanli_hou"):setString("" .. nextFight)

    -- 绘制觉醒消耗
    if advanceLevel < maxAdvanceLevel then
        ccui.Helper:seekWidgetByName(root, "Panel_juexing_xh"):setVisible(true)

        -- 绘制消耗信息
        local listView = ccui.Helper:seekWidgetByName(root, "ListView_need_props")
        listView:removeAllItems()
        local shipGrowRequirement = dms.element(dms["ship_grow_requirement"], advanceLevel)
        local needParam = {
            {_type = 1, _prop_id = 0, _prop_count = dms.atoi(shipGrowRequirement, ship_grow_requirement.need_silver)},
            {_type = 0, _prop_id = dms.atoi(shipGrowRequirement, ship_grow_requirement.need_prop1), _prop_count = dms.atoi(shipGrowRequirement, ship_grow_requirement.need_prop1_count)}
        }

        local _width = 0
        local _nCount = 0
        for i, v in pairs(needParam) do
            local cell = nil
            if v._type == 0  then
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

        if maxAdvanceLevel < 5 or tonumber(self.hero.captain_type) == 0 then
            ccui.Helper:seekWidgetByName(root, "Text_juexing_2"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root, "Text_juexing_1"):setVisible(true)
        end
    else
        if zstring.tonumber(self.hero.ship_breakthrough_level) > 0 then
            ccui.Helper:seekWidgetByName(root, "Panel_11"):setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root, "Panel_11_0"):setVisible(true)
        end
    end

    -- 绘制觉醒后的突破信息
end

function AdventureHeroAwaken:onEnterTransitionFinish()
    local csbAdventureHeroAwaken = csb.createNode("duplicate/awaken_1.csb")
    local root = csbAdventureHeroAwaken:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureHeroAwaken)

    local action = csb.createTimeline("duplicate/awaken_1.csb")
    table.insert(self.actions, action)
    csbAdventureHeroAwaken:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "juexing_over" then
            self:updateDraw()
        end
    end)

    -- 觉醒
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_juexing_sure"),       nil, 
    {
        terminal_name = "adventure_hero_awaken_ship_strengthen",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:updateDraw()
end

function AdventureHeroAwaken:onExit()
    state_machine.remove("adventure_hero_awaken_ship_strengthen")
end
