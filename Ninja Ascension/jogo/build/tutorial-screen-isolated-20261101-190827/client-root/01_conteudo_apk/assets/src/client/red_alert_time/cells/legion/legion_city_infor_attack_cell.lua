-- ------------------------------------------------------------------------------------------------------------
--  军团成员cell
-- ------------------------------------------------------------------------------------------------------------
LegionCityInforAttackCell = class("LegionCityInforAttackCellClass", Window)
LegionCityInforAttackCell.__size = nil

--创建cell
local legion_city_infor_attack_cell_create_terminal = {
    _name = "legion_city_infor_attack_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionCityInforAttackCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_city_infor_attack_cell_create_terminal)
state_machine.init()

function LegionCityInforAttackCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = nil

    app.load("client.red_alert_time.cells.worldMap.player_head_icon")
    app.load("client.red_alert_time.friend.RedAlertTimeFriendInfo")
    
    local function init_legion_city_infor_attack_cell_terminal()
        local legion_city_infor_attack_cell_look_info_terminal = {
            _name = "legion_city_infor_attack_cell_look_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if tonumber(cell._info.nType) == 0 then
                    state_machine.excute("red_alert_time_friend_info_open", 0, ""..cell._info.user_id)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_city_infor_attack_cell_look_info_terminal)  
        state_machine.init()
    end
    
    init_legion_city_infor_attack_cell_terminal()
end


function LegionCityInforAttackCell:updateDraw()
    local root = self.roots[1]
    local Panel_legion_city_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_player_icon")
    local Text_legion_city_defend_name = ccui.Helper:seekWidgetByName(root, "Text_legion_city_defend_name")
    local Text_legion_city_defend_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_city_defend_legion_name")
    Panel_legion_city_player_icon:removeAllChildren(true)

    if tonumber(self._info.nType) == 0 then
        if isContentZh_TW() == true then
            local font_size = Text_legion_city_defend_name:getFontSize()
            Text_legion_city_defend_name:setFontName("")
            Text_legion_city_defend_name:setFontSize(font_size)
        end

        Text_legion_city_defend_name:setString(self._info.user_name)
        Text_legion_city_defend_legion_name:setString(self._info.union_name)

        local cell = PlayerHeadIcon:createCell()
        local avatar_info = {}
        avatar_info.object = self._info.head_pic
        avatar_info.vip = 0
        avatar_info._type = 0
        cell:init(avatar_info)
        Panel_legion_city_player_icon:addChild(cell)

        root:setTouchEnabled(true)
    else
        local npc_id = tonumber(self._info.user_id)
        local npc_name = dms.string(dms["npc"], npc_id, npc.npc_name)
        local head_pic = dms.string(dms["npc"], npc_id, npc.head_pic)

        local npc_head_pic = ""..head_pic..",0,0"

        if isContentZh_TW() == true then
            local font_size = Text_legion_city_defend_name:getFontSize()
            Text_legion_city_defend_name:setFontName(config_res.font.font_name)
            Text_legion_city_defend_name:setFontSize(font_size)
        end

        Text_legion_city_defend_name:setString(npc_name)
        Text_legion_city_defend_legion_name:setString("")

        local cell = PlayerHeadIcon:createCell()
        local avatar_info = {}
        avatar_info.object = npc_head_pic
        avatar_info.vip = 0
        avatar_info._type = 0
        cell:init(avatar_info)
        Panel_legion_city_player_icon:addChild(cell)

        root:setTouchEnabled(false)
    end
end

function LegionCityInforAttackCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_city_infor_attack_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LegionCityInforAttackCell.__size == nil then
        LegionCityInforAttackCell.__size = root:getContentSize()
    end 

    root:setSwallowTouches(false)
    local function panelTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
            pushEffect(formatMusicFile("button", 1))
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if math.abs(__spoint.x - __epoint.x) <= 10 and math.abs(__spoint.y - __epoint.y) <= 10 then
                state_machine.excute("legion_city_infor_attack_cell_look_info", 0, {_datas = {cell = self}})
            end
        end
    end
    root:addTouchEventListener(panelTouchListener)

    self:updateDraw()
end

function LegionCityInforAttackCell:onEnterTransitionFinish()

end

function LegionCityInforAttackCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionCityInforAttackCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_infor_attack_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionCityInforAttackCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_legion_city_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_legion_city_player_icon")
    local Text_legion_city_defend_name = ccui.Helper:seekWidgetByName(root, "Text_legion_city_defend_name")
    local Text_legion_city_defend_legion_name = ccui.Helper:seekWidgetByName(root, "Text_legion_city_defend_legion_name")
    if Panel_legion_city_player_icon ~= nil then
        Panel_legion_city_player_icon:removeAllChildren(true)
        Text_legion_city_defend_name:setString("")
        Text_legion_city_defend_legion_name:setString("")
    end
end

function LegionCityInforAttackCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self:onInit()
    self:setContentSize(LegionCityInforAttackCell.__size)
    return self
end

function LegionCityInforAttackCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_city_infor_attack_cell, self.roots[1])
end
