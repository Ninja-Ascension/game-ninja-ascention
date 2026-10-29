-- ----------------------------------------------------------------------------------------------------
-- 说明：城市战小地图
-------------------------------------------------------------------------------------------------------
redAlertTimeSmallMap = class("redAlertTimeSmallMapClass", Window)

local red_alert_time_small_map_open_terminal = {
    _name = "red_alert_time_small_map_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        		local _window = fwin:find("redAlertTimeSmallMapClass")
                if nil == _window then
            		fwin:open(redAlertTimeSmallMap:new():init(), fwin._ui)
                end
            end
        end
        protocol_command.world_city_list_get.param_list = ""
        NetworkManager:register(protocol_command.world_city_list_get.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_small_map_close_terminal = {
    _name = "red_alert_time_small_map_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		fwin:close(fwin:find("redAlertTimeSmallMapClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_small_map_open_terminal)
state_machine.add(red_alert_time_small_map_close_terminal)
state_machine.init()
    
function redAlertTimeSmallMap:ctor()
    self.super:ctor()
    self.roots = {}

    self._chooseIndex = 0
    self._chooseType = 0

    self._p1 = nil
    self._p2 = nil
    self._p3 = nil
    self._p4 = nil

    self._factory_state = {}
    self._choosePosition = nil

    app.load("client.red_alert_time.big_map.WorldMapPlayInfor")

    local function init_red_alert_time_small_map_terminal()
        local red_alert_time_small_map_choose_terminal = {
            _name = "red_alert_time_small_map_choose",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateDraw(params._datas.index, params._datas.chooseType)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_small_map_go_to_terminal = {
            _name = "red_alert_time_small_map_go_to",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    local posX, posY = 0, 0
                    if instance._choosePosition ~= nil then
                        posX, posY = instance._choosePosition.x, instance._choosePosition.y
                    elseif instance._chooseIndex ~= 0 and instance._chooseType ~= 0 then
                        if instance._chooseType == 1 then
                            local pos = zstring.split(dms.string(dms["world_city_mould"], instance._chooseIndex, world_city_mould.position), ",")
                            posX = pos[1]
                            posY = pos[2]
                        else
                            local pos_info = zstring.split(dms.string(dms["world_city_config"], 30, world_city_config.param), "|")
                            local pos = zstring.split(pos_info[instance._chooseIndex], ",")
                            posX = pos[1]
                            posY = pos[2]
                        end
                    end
                    if posX ~= 0 and posY ~= 0 then
                        state_machine.excute("adventure_mine_record_view_position", 0, {posX, posY})
                        state_machine.excute("adventure_mine_update_view_position", 0, 0)
                        
                        local function responseCallBack(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.excute("red_alert_time_small_map_close", 0, nil)
                            end
                        end
                        _ED.world_map_focus = {posX, posY}
                        protocol_command.world_map_arena_info_refresh.param_list = "" .. posX .. "\r\n" .. posY
                        NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, instance, responseCallBack, false, nil)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_small_map_touch_terminal = {
            _name = "red_alert_time_small_map_touch",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:chooseOncePosition(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_small_map_choose_terminal)
        state_machine.add(red_alert_time_small_map_go_to_terminal)
        state_machine.add(red_alert_time_small_map_touch_terminal)
        state_machine.init()
    end
    init_red_alert_time_small_map_terminal()
end

function redAlertTimeSmallMap:init()
    self:onInit()
    return self
end

function redAlertTimeSmallMap:updateMyPosition( ... )
    local root = self.roots[1]
    local size = 600
    local Image_map_xy_location = ccui.Helper:seekWidgetByName(root, "Image_map_xy_location")
    if (zstring.tonumber(_ED.world_map.position_coordinates_x) == 1
        or zstring.tonumber(_ED.world_map.position_coordinates_x) == 600)
        and (zstring.tonumber(_ED.world_map.position_coordinates_y) == 1
        or zstring.tonumber(_ED.world_map.position_coordinates_y) == 600)
        then
        if zstring.tonumber(_ED.world_map.position_coordinates_x) == 1
            and zstring.tonumber(_ED.world_map.position_coordinates_y) == 1
            then
            Image_map_xy_location:setPosition(cc.p(self._p1.x, self._p1.y))
        elseif zstring.tonumber(_ED.world_map.position_coordinates_x) == 1
            and zstring.tonumber(_ED.world_map.position_coordinates_y) == 600
            then
            Image_map_xy_location:setPosition(cc.p(self._p2.x, self._p2.y))
        elseif zstring.tonumber(_ED.world_map.position_coordinates_x) == 600
            and zstring.tonumber(_ED.world_map.position_coordinates_y) == 1
            then
            Image_map_xy_location:setPosition(cc.p(self._p4.x, self._p4.y))
        elseif zstring.tonumber(_ED.world_map.position_coordinates_x) == 600
            and zstring.tonumber(_ED.world_map.position_coordinates_y) == 600
            then
            Image_map_xy_location:setPosition(cc.p(self._p3.x, self._p3.y))
        end
    else
        local my_point = {x = _ED.world_map.position_coordinates_x, y = _ED.world_map.position_coordinates_y}

        local pos1_4 = {x = 0, y = 0}
        pos1_4.x = ((size - my_point.x) * (self._p1.x - self._p4.x)) / size + self._p4.x
        pos1_4.y = ((size - my_point.x) * (self._p1.y - self._p4.y)) / size + self._p4.y

        local pos1_2 = {x = 0, y = 0}
        pos1_2.x = ((size - my_point.y) * (self._p1.x - self._p2.x)) / size + self._p2.x
        pos1_2.y = ((size - my_point.y) * (self._p1.y - self._p2.y)) / size + self._p2.y

        local pos2_3 = {x = 0, y = 0}
        pos2_3.x = ((size - my_point.x) * (self._p2.x - self._p3.x)) / size + self._p3.x
        pos2_3.y = ((size - my_point.x) * (self._p2.y - self._p3.y)) / size + self._p3.y

        local pos3_4 = {x = 0, y = 0}
        pos3_4.x = ((size - my_point.y) * (self._p4.x - self._p3.x)) / size + self._p3.x
        pos3_4.y = ((size - my_point.y) * (self._p4.y - self._p3.y)) / size + self._p3.y

        local result_point = segmentsIntr(pos1_4, pos2_3, pos1_2, pos3_4)
        if result_point ~= false then
            Image_map_xy_location:setPosition(cc.p(result_point.x, result_point.y))
        end
    end
end

function redAlertTimeSmallMap:chooseOncePosition( pos )
    local root = self.roots[1]
    local size = 600
    local Text_world_mp_xy = ccui.Helper:seekWidgetByName(root, "Text_world_mp_xy")
    local Image_map_xy_arrow = ccui.Helper:seekWidgetByName(root, "Image_map_xy_arrow")
    local Text_world_mp_xy_city_name = ccui.Helper:seekWidgetByName(root, "Text_world_mp_xy_city_name")

    local map_pos = {x = 0, y = 0}
    local pos1_2 = {x = 0, y = 0}
    pos1_2.x = pos.x - ((self._p4.x - self._p1.x) * pos.y) / (self._p4.y - self._p1.y)
    local point1_2 = segmentsIntr(self._p1, self._p2, pos, pos1_2)
    if point1_2 ~= false then
        map_pos.y = size - math.ceil(((self._p2.y - point1_2.y) * size) / (self._p2.y - self._p1.y))
    end

    local pos1_4 = {x = 0, y = 0}
    pos1_4.x = pos.x - ((self._p2.x - self._p1.x) * pos.y) / (self._p2.y - self._p1.y)
    local point1_4 = segmentsIntr(self._p1, self._p4, pos, pos1_4)
    if point1_4 ~= false then
        map_pos.x = math.floor(((point1_4.x - self._p1.x) * size) / (self._p4.x - self._p1.x))
    end
    if map_pos.x ~= 0 and map_pos.y ~= 0 then
        self._choosePosition = map_pos
        self._chooseIndex = 0
        self._chooseType = 0
        Text_world_mp_xy:setString(map_pos.x..","..map_pos.y)
        Image_map_xy_arrow:setPosition(cc.p(pos.x, pos.y))
        Text_world_mp_xy_city_name:setString("")
    end
end

function redAlertTimeSmallMap:updateDraw( chooseIndex , chooseType)
    if self._chooseIndex == chooseIndex and self._chooseType == chooseType then
        return
    end
    self._choosePosition = nil
    local root = self.roots[1]
    local Image_map_xy_arrow = ccui.Helper:seekWidgetByName(root, "Image_map_xy_arrow")
    local Text_world_mp_xy = ccui.Helper:seekWidgetByName(root, "Text_world_mp_xy")
    local Text_world_mp_xy_city_name = ccui.Helper:seekWidgetByName(root, "Text_world_mp_xy_city_name")

    local lastPanel = nil
    local choosePanel = nil
    local pos = ""
    local name = ""

    if self._chooseType == 1 then
        lastPanel = ccui.Helper:seekWidgetByName(root, "Panel_map_legion_city_"..self._chooseIndex)
    elseif self._chooseType == 2 then
        lastPanel = ccui.Helper:seekWidgetByName(root, "Panel_map_legion_factory_"..self._chooseIndex)
    end

    if chooseType == 1 then
        choosePanel = ccui.Helper:seekWidgetByName(root, "Panel_map_legion_city_"..chooseIndex)
        local worldCityMould = dms.element(dms["world_city_mould"], chooseIndex)
        pos = dms.atos(worldCityMould, world_city_mould.position)
        name = dms.atos(worldCityMould, world_city_mould.name)
    elseif chooseType == 2 then
        choosePanel = ccui.Helper:seekWidgetByName(root, "Panel_map_legion_factory_"..chooseIndex)
        local pos_info = zstring.split(dms.string(dms["world_city_config"], 30, world_city_config.param), "|")
        pos = pos_info[chooseIndex]
        name = world_city_tip_str[62 + chooseIndex]
    end

    self._chooseIndex = chooseIndex
    self._chooseType = chooseType
    if lastPanel ~= nil then
        lastPanel:setColor(cc.c3b(199, 199, 199))
    end
    choosePanel:setColor(cc.c3b(255, 255, 255))
    Image_map_xy_arrow:setPosition(cc.p(choosePanel:getPositionX() + choosePanel:getScale() * choosePanel:getContentSize().width/2, choosePanel:getPositionY() + choosePanel:getContentSize().height/2))
    Text_world_mp_xy:setString(pos)
    Text_world_mp_xy_city_name:setString(name)

    if chooseType == 1 then
        local city_info = _ED.world_city_info.city_info[""..chooseIndex]
        if city_info ~= nil and tonumber(city_info.state) < 0 then
            Text_world_mp_xy_city_name:setString(name..world_city_tip_str[70])
        end
    elseif chooseType == 2 then
        if self._factory_state[chooseIndex] < 0 then
            Text_world_mp_xy_city_name:setString(name..world_city_tip_str[70])
        end
    end
end

function redAlertTimeSmallMap:updateMapStateInfo( ... )
    local root = self.roots[1]
    local result = {}
    local factory_result = {}
    if _ED.world_city_info ~= nil and _ED.world_city_info.city_info ~= nil then
        for k, v in pairs(_ED.world_city_info.city_info) do
            if tonumber(v.city_type) == 3000 then
                table.insert(result, v)
            elseif tonumber(v.city_type) == 3002 then
                table.insert(factory_result, v)
            end
        end
    end
    -- local open_state = 0
    -- if _ED.mould_function_push_info["14"] ~= nil then
    --     open_state = tonumber(_ED.mould_function_push_info["14"].state)
    -- end
    local myUnionId = 0
    if _ED.union.union_info == nil 
        or _ED.union.union_info == {} 
        or _ED.union.union_info.union_id == nil 
        or _ED.union.union_info.union_id == "" 
        or tonumber(_ED.union.union_info.union_id) == 0 then
    else
        myUnionId = zstring.tonumber(_ED.union.union_info.union_id)
    end

    for k, v in pairs(result) do
        local panel = ccui.Helper:seekWidgetByName(root, "Panel_map_legion_city_"..v.city_id)
        panel:removeAllChildren(true)
        panel:removeBackGroundImage()
        local sort_type = dms.int(dms["world_city_mould"], v.city_id, world_city_mould.sort_type)
        sort_type = 7 - sort_type
        if tonumber(v.state) < 0 then
            -- 未开启
            panel:setBackGroundImage(string.format(config_res.images.ui.share.world_city_close_icon, sort_type))
        else
            local isOwner = false
            if myUnionId > 0 then
                if tonumber(v.state) == 2 and myUnionId == zstring.tonumber(v.progress_union_id) then
                    isOwner = true
                end
            end
            if isOwner == true then
                if zstring.tonumber(v.progress_union_id) ~= zstring.tonumber(v.union_id) or zstring.tonumber(v.progress) > 0 then
                    -- 我方在交战中
                    panel:setBackGroundImage(string.format(config_res.images.ui.share.world_map_legion_city_icon, sort_type))
                    local armature = ccs.Armature:create("effect_map_my_fight")
                    armature:getAnimation():playWithIndex(0)
                    panel:addChild(armature)
                    armature:setPosition(cc.p(armature:getContentSize().width/2, armature:getContentSize().height))
                else
                    -- 我方已经占领
                    panel:setBackGroundImage(string.format(config_res.images.ui.share.world_map_my_city_icon, sort_type))
                end
            else
                panel:setBackGroundImage(string.format(config_res.images.ui.share.world_map_legion_city_icon, sort_type))
                if zstring.tonumber(v.union_id) > 0 and zstring.tonumber(v.progress_union_id) ~= zstring.tonumber(v.union_id) or zstring.tonumber(v.progress) > 0 then
                    -- 交战中
                    local armature = ccs.Armature:create("effect_map_world_fight")
                    armature:getAnimation():playWithIndex(0)
                    panel:addChild(armature)
                    armature:setPosition(cc.p(armature:getContentSize().width/2, armature:getContentSize().height))
                end
            end
        end
    end

    local pos_info = zstring.split(dms.string(dms["world_city_config"], 30, world_city_config.param), "|")
    for i = 1, #pos_info do
        local panel = ccui.Helper:seekWidgetByName(root, "Panel_map_legion_factory_"..i)
        panel:removeBackGroundImage()
        local info = zstring.split(pos_info[i], ",")
        local pos_x = tonumber(info[1])
        local pos_y = tonumber(info[2])

        local city_info = nil
        for k, v in pairs(factory_result) do
            local pos = zstring.split(dms.string(dms["world_city_mould"], v.city_id, world_city_mould.position), ",")
            if tonumber(pos[1]) >= pos_x - 1 and tonumber(pos[1]) <= pos_x + 1
                and tonumber(pos[2]) >= pos_y - 1 and tonumber(pos[2]) <= pos_y + 1
                then
                city_info = v
                break
            end
        end

        local city_state = -1
        if city_info ~= nil then
            city_state = tonumber(city_info.state)
        end
        table.insert(self._factory_state, city_state)

        if city_state < 0 then
            -- 未开启
            panel:setBackGroundImage(string.format(config_res.images.ui.share.world_city_close_icon, 2))
        else
            panel:setBackGroundImage(string.format(config_res.images.ui.share.world_map_legion_city_icon, 7))
        end
    end
end

function redAlertTimeSmallMap:onInit()
    local csbredAlertTimeMinehelpInfo = csb.createNode(config_csb.world_map.world_small_map)
    local root = csbredAlertTimeMinehelpInfo:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMinehelpInfo)

    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_map_my_fight)
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_map_world_fight)

    local ScrollView_map_small = ccui.Helper:seekWidgetByName(root,"ScrollView_map_small")
    local width = ScrollView_map_small:getContentSize().width
    local map_width = ScrollView_map_small:getInnerContainer():getContentSize().width
    if width < map_width / 2 then
        ScrollView_map_small:getInnerContainer():setPositionX(width - map_width / 2 - 20)
    end

    self._p1 = {x = ScrollView_map_small:getChildByName("Node_base_pos_1"):getPositionX(), y = ScrollView_map_small:getChildByName("Node_base_pos_1"):getPositionY()}
    self._p2 = {x = ScrollView_map_small:getChildByName("Node_base_pos_2"):getPositionX(), y = ScrollView_map_small:getChildByName("Node_base_pos_2"):getPositionY()}
    self._p3 = {x = ScrollView_map_small:getChildByName("Node_base_pos_3"):getPositionX(), y = ScrollView_map_small:getChildByName("Node_base_pos_3"):getPositionY()}
    self._p4 = {x = ScrollView_map_small:getChildByName("Node_base_pos_4"):getPositionX(), y = ScrollView_map_small:getChildByName("Node_base_pos_4"):getPositionY()}	

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_map_small_close"), nil, 
    {
        terminal_name = "red_alert_time_small_map_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil, 3)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_world_map_go"), nil, 
    {
        terminal_name = "red_alert_time_small_map_go_to",
        terminal_state = 0,
        touch_black = true,
    },
    nil, 3)

    for i=1,37 do
        local panel = ccui.Helper:seekWidgetByName(root, "Panel_map_legion_city_"..i)
        fwin:addTouchEventListener(panel, nil, 
        {
            terminal_name = "red_alert_time_small_map_choose",
            terminal_state = 0,
            index = i,
            chooseType = 1,
        },
        nil, 3)
        panel:setColor(cc.c3b(199, 199, 199))
    end

    for i = 1, 5 do
        local panel = ccui.Helper:seekWidgetByName(root, "Panel_map_legion_factory_"..i)
        fwin:addTouchEventListener(panel, nil, 
        {
            terminal_name = "red_alert_time_small_map_choose",
            terminal_state = 0,
            index = i,
            chooseType = 2,
        },
        nil, 3)
        panel:setColor(cc.c3b(199, 199, 199))
    end

    -- 玩法说明
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_world_player_infor"), nil, 
    {
        terminal_name = "world_map_play_infor_window_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
    local Panel_touch_map = ccui.Helper:seekWidgetByName(root, "Panel_touch_map")
    local function touchListener(sender, eventType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if math.abs(__spoint.x - __epoint.x) <= 3
                and math.abs(__spoint.y - __epoint.y) <= 3
                then
                pushEffect(formatMusicFile("button", 3))
                state_machine.excute("red_alert_time_small_map_touch", 0, sender:convertToNodeSpace(cc.p(__epoint.x, __epoint.y)))
            end
        end
    end
    Panel_touch_map:addTouchEventListener(touchListener)
    Panel_touch_map:setSwallowTouches(true)

    self:updateDraw(0, 0)
    self:updateMapStateInfo()
    self:updateMyPosition()
end

function redAlertTimeSmallMap:onExit()
	state_machine.remove("red_alert_time_small_map_choose")
    state_machine.remove("red_alert_time_small_map_go_to")
    state_machine.remove("red_alert_time_small_map_touch")
end