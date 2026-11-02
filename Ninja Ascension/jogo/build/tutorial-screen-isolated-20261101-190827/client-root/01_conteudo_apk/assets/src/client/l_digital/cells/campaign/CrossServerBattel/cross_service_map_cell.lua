----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战地图控件
----------------------------------------------------------------------------------------------------
CrossServiceMapCell = class("CrossServiceMapCellClass", Window)

function CrossServiceMapCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelGrabOtherFormation")
    app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelFormation")
end

function CrossServiceMapCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_cross_map_rank = ccui.Helper:seekWidgetByName(root,"Panel_cross_map_rank") --排名
    local Text_cross_map_player_name = ccui.Helper:seekWidgetByName(root,"Text_cross_map_player_name") --名称
    local Text_cross_map_service_name = ccui.Helper:seekWidgetByName(root,"Text_cross_map_service_name") -- 服务器名称
    local Text_cross_map_rank_n = ccui.Helper:seekWidgetByName(root,"Text_cross_map_rank_n") -- 排名
    local Text_cross_map_integral_n = ccui.Helper:seekWidgetByName(root,"Text_cross_map_integral_n") -- 积分
    local Text_cross_map_speed_n = ccui.Helper:seekWidgetByName(root,"Text_cross_map_speed_n") -- 产速
    local Text_cross_map_fight_n = ccui.Helper:seekWidgetByName(root,"Text_cross_map_fight_n") -- 战力
    local Button_cross_map_rob = ccui.Helper:seekWidgetByName(root, "Button_cross_map_rob")
    local Button_cross_map_guard = ccui.Helper:seekWidgetByName(root, "Button_cross_map_guard")

    Panel_cross_map_rank:removeBackGroundImage()
    Text_cross_map_player_name:setString("")
    Text_cross_map_service_name:setString("")
    Text_cross_map_rank_n:setString("")
    Text_cross_map_integral_n:setString("")
    Text_cross_map_speed_n:setString("")
    Text_cross_map_fight_n:setString("")

    if self.mapType == 2 and tonumber(self.mapInfo.mineId) > 0 and tonumber(self.mapInfo.mineId) <= 3 then
        Panel_cross_map_rank:setBackGroundImage(string.format("images/ui/text/cross_service/ico_%d.png", tonumber(self.mapInfo.mineId)))
    elseif self.mapType == 2 and tonumber(self.mapInfo.mineId) > 3 then
        Panel_cross_map_rank:setBackGroundImage("images/ui/text/cross_service/ico_4.png")
    elseif self.mapType == 1 then
        Panel_cross_map_rank:setBackGroundImage("images/ui/text/cross_service/ico_5.png")
    end

    Text_cross_map_speed_n:setString(self.mapInfo.mineProdution .. "/10m")
    Text_cross_map_fight_n:setString(self.mapInfo.maxCombat)
    Text_cross_map_integral_n:setString(self.mapInfo.mineScore)

    Text_cross_map_player_name:setString(self.mapInfo.userInfo.nickName)

    local server_name = _ED.cross_server_battel_all_servers[self.mapInfo.userInfo.serverId]
    local getStr1 = string.match(server_name, "-")
    local getStr2 = string.match(server_name, "_")
    if getStr1 and getStr1 ~= "" then
        server_name = zstring.split(server_name, "-")[1]
    elseif getStr2 and getStr2 ~= "" then
        server_name = zstring.split(server_name, "_")[1]
    end
    Text_cross_map_service_name:setString(server_name)
    Text_cross_map_rank_n:setString(self.mapInfo.mineId)
    Button_cross_map_rob:setVisible(not self.is_myself)
    Button_cross_map_guard:setVisible(self.is_myself)
end

function CrossServiceMapCell:onInit()
    local csbCrossServiceMapCell= csb.createNode("campaign/cross_service/cross_service_map_cell.csb")
    local root = csbCrossServiceMapCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

    local action = csb.createTimeline("campaign/cross_service/cross_service_map_cell.csb")
    table.insert(self.actions, action)
    root:runAction(action)
    action:play("window_open_1", false)

    --抢矿
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_map_rob"), nil, 
    {
        terminal_name = "cross_server_battel_grab_other_formation_open", 
        user_info = self.mapInfo.userInfo,
        open_type = 1,
        isPressedActionEnabled = true
    },
    nil,0)

    --守矿
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_map_guard"), nil, 
    {
        terminal_name = "cross_server_battel_formation_open", 
        _type = 2,
        isPressedActionEnabled = true
    },
    nil,0)

    if self.is_myself then
        local Panel_corss_map_spot_sprint_1 = ccui.Helper:seekWidgetByName(root, "Panel_corss_map_spot_sprint_1")
        local jsonFile = "images/ui/effice/effect_kfwxs/effect_kfwxs.json" 
        local atlasFile = "images/ui/effice/effect_kfwxs/effect_kfwxs.atlas" 
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        animation.animationNameList = {"animation"}
        sp.initArmature(animation, true)
        animation._invoke = changeActionCallback
        Panel_corss_map_spot_sprint_1:addChild(animation)
        animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        csb.animationChangeToAction(animation, 0, 0, false)
    end

    self:onUpdateDraw()
end

function CrossServiceMapCell:onEnterTransitionFinish()
end

function CrossServiceMapCell:onExit()

end

function CrossServiceMapCell:initData()
    self.is_myself = false
    if tonumber(self.mapInfo.userInfo.serverId) == tonumber(_ED.cross_server_battel_map_info.realServerId) and 
     tonumber(self.mapInfo.userInfo.userId) == tonumber(_ED.user_info.user_id) then
        self.is_myself = true
    end
end

function CrossServiceMapCell:init(params)
    self.mapType = params[1]
    self.mapInfo = params[2]
    self.mapInfo.userInfo.mineId = self.mapInfo.mineId
    self:initData()
    self:onInit()
end

function CrossServiceMapCell:createCell()
	local cell = CrossServiceMapCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

