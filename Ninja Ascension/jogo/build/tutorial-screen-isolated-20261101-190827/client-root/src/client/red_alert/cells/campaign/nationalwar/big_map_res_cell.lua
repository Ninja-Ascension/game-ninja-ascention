--------------------------------------------------------------------------------------------------------------
--  城池资源信息显示
--------------------------------------------------------------------------------------------------------------
BigMapResCell = class("BigMapResCellClass", Window)

--创建cell
local big_map_res_cell_create_terminal = {
    _name = "big_map_res_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = BigMapResCell:new()
        cell:init(params)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(big_map_res_cell_create_terminal)
state_machine.init()

function BigMapResCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    -- var
    self._parent = nil
    self._city_data = nil
    -- 1资源占领, 2工会占领
    self._state = 0
    -- 是否开启占领标识
    self._open_union_cap_state = false

    self._attack_time = 0
    self._Panel_battle_vs = nil
end

function BigMapResCell:onUpdateDraw()
    local root = self.roots[1]
    for i=1,5 do   
        local Image_gr = ccui.Helper:seekWidgetByName(root,"Image_gr_"..i)
        Image_gr:setVisible(false)
    end
    local resourceType = 0
    if self._state == 1 then
        local mouldData = zstring.split(self._city_data.city_Resource_points_mould, ",")
        local elementId = nil
        local quality = 0
        for j, r in pairs(mouldData) do
            local resourceId = zstring.tonumber(r)
            local tquality = dms.int(dms["city_resource_mould"],resourceId,city_resource_mould.quality)
            if elementId == nil then
                elementId = resourceId
            end
            if tquality ~= nil and quality < tquality then
                elementId = resourceId
                quality = tquality
            end
        end
        local Image_gr = ccui.Helper:seekWidgetByName(root,"Image_gr_"..(quality + 1))
        Image_gr:setVisible(true)
        resourceType = dms.int(dms["city_resource_mould"],elementId,city_resource_mould.resourceType)
        state_machine.excute("natinal_war_smllemap_update_draw_resource_quality", 0, {self._city_data.city_world_map_id, quality})
    else
        self._Panel_battle_vs = ccui.Helper:seekWidgetByName(root, "Panel_battle_vs")
        self._Panel_battle_vs:removeAllChildren(true)
        local Panel_legion_occ = ccui.Helper:seekWidgetByName(root, "Panel_legion_occ")
        Panel_legion_occ:setVisible(false)
        local Panel_build = ccui.Helper:seekWidgetByName(root, "Panel_build")
        Panel_build:removeBackGroundImage()
        Panel_build:setBackGroundImage("images/ui/play/big_map/big_map_build_1.png")
        
        local reward_items_show = dms.string(dms["scene_reward"], self._city_data.reward_id, scene_reward.reward_items)
        reward_items_show = zstring.split(reward_items_show,"|")
        for k,m in pairs(reward_items_show) do
            resourceType = tonumber(zstring.split(m,",")[2])
            break
        end
        local Image_gr = ccui.Helper:seekWidgetByName(root,"Image_gr_4")
        Image_gr:setVisible(true)

        if tonumber(self._city_data.union_id) > 0 then
            Panel_legion_occ:setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Text_legion_name"):setString(self._city_data.union_name)
            local quality = tonumber(self._city_data.union_level)
            if tonumber(quality) > 11 then
                quality = 11
            end
            ccui.Helper:seekWidgetByName(root, "Panel_legion_grade"):setBackGroundImage(string.format(config_res.images.ui.play.big_map.path_legion, quality))
        end
        if tonumber(self._city_data.attack_union_id) > 0 then
            -- 城池资源动画加载
            for i, v in pairs(config_res.sprites_cached["big_map_res"]) do
                cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
            end
            for i, v in pairs(config_res.armatures_cached["big_map_res"]) do
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(v)
            end
            local armature = ccs.Armature:create("effect_jiaozhanzhong")
            self._Panel_battle_vs:addChild(armature)
            draw.initArmature(armature, nil, -1, 0, 1)
            armature:getAnimation():playWithIndex(0)

            self._attack_time = tonumber(self._city_data.attack_time_cd)/1000
            if tonumber(self._attack_time) > 0 then
                self:registerOnNoteUpdate(self)
                self._Panel_battle_vs:setVisible(true)
            else
                self._Panel_battle_vs:setVisible(false)
            end
        else
            self._Panel_battle_vs:setVisible(false)
        end
    end
    if resourceType == 33 then
        ccui.Helper:seekWidgetByName(root,"Panel_resources_1"):setBackGroundImage(config_res.images.ui.props.props_4019)
    elseif resourceType == 31 then
        ccui.Helper:seekWidgetByName(root,"Panel_resources_1"):setBackGroundImage(config_res.images.ui.props.props_4016)
    elseif resourceType == 1 then
        ccui.Helper:seekWidgetByName(root,"Panel_resources_1"):setBackGroundImage(config_res.images.ui.props.props_4002)
    elseif resourceType == 2 then
        ccui.Helper:seekWidgetByName(root,"Panel_resources_1"):setBackGroundImage(config_res.images.ui.props.props_4001)
    else
        ccui.Helper:seekWidgetByName(root,"Panel_resources_1"):setBackGroundImage(config_res.images.ui.props.props_4008)
    end
end

function BigMapResCell:onUpdate( dt )
    local root = self.roots[1]
    if root == nil then
        return
    end
    self._attack_time = self._attack_time - dt
    if self._attack_time <= 0 then
        self._attack_time = 0
        self:unregisterOnNoteUpdate(self)
        self._Panel_battle_vs:setVisible(false)
    elseif tonumber(self._city_data.attack_union_id) == 0 then
        self._Panel_battle_vs:setVisible(false)
    end
end

function BigMapResCell:formatTimeString(_time)
    local timeString = ""
    local now_time = math.max(tonumber(_time), 0)
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))
    return timeString
end

function BigMapResCell:onInit()
    local csbNode = csb.createNode(config_csb.cells.big_map.big_map_res_cell)
    self:addChild(csbNode)
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.cells.big_map.big_map_res_cell)
    action:setTimeSpeed(app.getTimeSpeed())
    table.insert(self.actions, action)

    csbNode:runAction(action)

    action:play("animation_res", true)

    self:onUpdateDraw()
end

function BigMapResCell:init(params)
    self._parent = params[1]
    self._city_data = params[2]
    self._state = params[3]
    if params[4] ~= nil then
        self._open_union_cap_state = params[4]
    end
    self:onInit()
    return self
end
