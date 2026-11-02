PersonalPlayerBuildMapCell = class("PersonalPlayerBuildMapCellClass", Window)

local personal_player_build_map_cell_create_terminal = {
    _name = "personal_player_build_map_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = PersonalPlayerBuildMapCell:new()
        cell:init(params)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(personal_player_build_map_cell_create_terminal)
state_machine.init()

function PersonalPlayerBuildMapCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._parent = nil
    self._info = nil
    self._isMySelf = false
end

function PersonalPlayerBuildMapCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    local Image_player_1 = ccui.Helper:seekWidgetByName(root, "Image_player_1")
    local Image_player_2 = ccui.Helper:seekWidgetByName(root, "Image_player_2")
    local Panel_battle_wins = ccui.Helper:seekWidgetByName(root, "Panel_battle_wins")
    local Panel_enemy = ccui.Helper:seekWidgetByName(root, "Panel_enemy")
    Panel_battle_wins:removeAllChildren(true)
    Panel_enemy:removeAllChildren(true)
    Image_player_1:setVisible(false)
    Image_player_2:setVisible(false)
    if self._isMySelf == true then
        Text_name:setString(red_alert_all_str[229])
        Text_name:setColor(cc.c3b(red_alert_war_city_map_color[5][1], red_alert_war_city_map_color[5][2], red_alert_war_city_map_color[5][3]))
        Image_player_1:setVisible(true)
    else
        local server_number = 0
        local server_info = _ED.all_servers[""..self._info.user_server_number]
        if server_info ~= nil and server_info.server_code ~= nil and tonumber(server_info.server_code) ~= nil then
            server_number = server_info.server_code
        end
        if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
            if server_info ~= nil and server_info.server_code ~= nil then
                Text_name:setString(self._info.user_name.."("..server_info.server_code..")")
            else
                Text_name:setString(self._info.user_name)
            end
        else
            Text_name:setString(string.format(red_alert_all_str[230], self._info.user_name, server_number))
        end

        Image_player_1:setVisible(false)
        if tonumber(self._info.user_fighting) > tonumber(_ED.user_info.fighter_capacity) then
            -- 个人争夺战其他战力比自己高的颜色
            Text_name:setColor(cc.c3b(red_alert_war_city_map_color[6][1], red_alert_war_city_map_color[6][2], red_alert_war_city_map_color[6][3]))
        else
            -- 个人争夺战其他战力比自己低的颜色
            Text_name:setColor(cc.c3b(red_alert_war_city_map_color[7][1], red_alert_war_city_map_color[7][2], red_alert_war_city_map_color[7][3]))
        end
    end
    -- 添加已被掠夺提示
    if self._info ~= nil and tonumber(self._info.user_state) == -1 then        -- 已掠夺
        local armature1 = ccs.Armature:create("effect_xiaoyan")
        Panel_battle_wins:addChild(armature1)
        draw.initArmature(armature1, nil, -1, 0, 1)
        armature1:getAnimation():playWithIndex(0)
    end
    -- 添加仇人特效
    if self._isEnemy == true then      -- 是仇人
        local armature2 = ccs.Armature:create("effice_shanzhuang_choudi")
        Panel_enemy:addChild(armature2)
        draw.initArmature(armature2, nil, -1, 0, 1)
        armature2:getAnimation():playWithIndex(0)  
    end  
end

function PersonalPlayerBuildMapCell:playUpgradeEffect()
    local root = self.roots[1]
    if self._info ~= nil and self._index ~= nil then
        local Panel_refresh = ccui.Helper:seekWidgetByName(root, "Panel_refresh")
        Panel_refresh:removeAllChildren(true)
        local armature1 = ccs.Armature:create("effice_build_refresh")
        local function deleteEffectFile(armatureBack)
            if armatureBack.removeFromParent ~= nil then
                armatureBack:removeFromParent(true)
            end
        end
        draw.initArmature(armature1, nil, -1, 0, 1)
        armature1:getAnimation():playWithIndex(0)
        armature1:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        armature1._invoke = deleteEffectFile
        Panel_refresh:addChild(armature1)
    end
end

function PersonalPlayerBuildMapCell:onInit()
    -- 个人战动画资源加载
    for i, v in pairs(config_res.sprites_cached["personal_war"]) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
    end
    for i, v in pairs(config_res.armatures_cached["personal_war"]) do
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v)
    end
    local csbNode = csb.createNode(config_csb.cells.palyer_build.player_build_map_cell)
    self:addChild(csbNode)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.cells.palyer_build.player_build_map_cell)
    action:setTimeSpeed(app.getTimeSpeed())
    table.insert(self.actions, action)

    csbNode:runAction(action)

    action:play("animation0", true)

    self:onUpdateDraw()
    self:playUpgradeEffect()
end

function PersonalPlayerBuildMapCell:init(params)
    self._parent = params[1]
    self._info = params[2]
    self._isMySelf = params[3]
    self._isEnemy = params[4]
    self._index = params[5]
    self:onInit()
    return self
end
