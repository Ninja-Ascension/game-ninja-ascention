
RaceCourseRideSkillCell = class("RaceCourseRideSkillCellClass", Window)

local racecource_ride_skill_create_cell_terminal = {
    _name = "racecource_ride_skill_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RaceCourseRideSkillCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(racecource_ride_skill_create_cell_terminal)
state_machine.init()

function RaceCourseRideSkillCell:ctor()
	self.super:ctor()
	self.roots = {}
    self._index = 0
    self._horse = nil
    self._chooseShip = nil

    -- load lua file
    app.load("client.red_alert_time.notification.push_notification_horse")
    
    local function init_racecource_ride_skill_cell_terminal()
        local racecource_ride_skill_choose_terminal = {
            _name = "racecource_ride_skill_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if tonumber(cell._horse.horse_spirits[cell._index]) == 0 then
                    local canOpen = false
                    for i,v in pairs(_ED.horse_spirits) do
                        if tonumber(v.horse_id) == 0 then
                            canOpen = true
                            break
                        end
                    end
                    if canOpen == false then
                        TipDlg.drawTextDailog(horse_string_info[9])
                    else
                        state_machine.excute("racecourse_pack_window_open", 0, {2,1,cell._horse, cell._index})
                    end
                else
                    state_machine.excute("racecourse_attribute_window_open", 0, {cell._horse, cell._index})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(racecource_ride_skill_choose_terminal)
        state_machine.init()
    end
    
    init_racecource_ride_skill_cell_terminal()
end

function RaceCourseRideSkillCell:updateDraw()
    local root = self.roots[1]
    local Panel_choose = ccui.Helper:seekWidgetByName(root, "Panel_choose")
    local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
    local Panel_skill = ccui.Helper:seekWidgetByName(root, "Panel_skill")
    local Panel_locked = ccui.Helper:seekWidgetByName(root, "Panel_locked")
    local Text_level = ccui.Helper:seekWidgetByName(root, "Text_level")
    local Text_sou_lv = ccui.Helper:seekWidgetByName(root, "Text_sou_lv")
    Text_sou_lv:setVisible(true)
    Panel_choose:setVisible(true)
    Panel_skill:setVisible(true)
    Panel_skill:removeAllChildren(true)
    Image_2:setVisible(true)
    local actions = cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.3,1.1),cc.ScaleTo:create(0.3,1)))
    Image_2:runAction(actions)
    Panel_locked:setVisible(false)
    local house_spirits = _ED.horse_spirits[""..self._horse.horse_spirits[self._index]]
    if house_spirits ~= nil then
        local icon = dms.int(dms["horse_spirit_mould"], house_spirits.mould_id, horse_spirit_mould.icon)
        -- 兽魂动画资源加载
        for i, v in pairs(config_res.sprites_cached["horse_spirit"]) do
            cc.SpriteFrameCache:getInstance():addSpriteFrames(string.format(v, icon))
        end
        Image_2:setVisible(false)
        local level = dms.int(dms["horse_spirit_mould"], house_spirits.mould_id, horse_spirit_mould.level)
        Text_sou_lv:setString("+"..level)
        local effect_paths = string.format(config_res.images.ui.effice.treasure_effect, icon)
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
        local armature = ccs.Armature:create("treasure_effect_"..icon)
        draw.initArmature(armature, nil, -1, 0, 1)
        armature:setPosition(cc.p(Panel_skill:getContentSize().width/2, Panel_skill:getContentSize().height/2))
        Panel_skill:addChild(armature)
    else
        local horse_spirit_open_info = dms.string(dms["horse_mould"], self._horse.mould_id, horse_mould.horse_spirit_open_info)
        local infos = zstring.split(horse_spirit_open_info, "|")
        local is_lock = false
        local open_level = 0
        for k,v in pairs(infos) do
            if k == self._index then
                local spirit_info = zstring.split(v, ",")
                open_level = tonumber(spirit_info[2])
                if tonumber(_ED.user_info.user_grade) < open_level then
                    is_lock = true
                end
            end
        end
        if is_lock == true then
            Panel_choose:setVisible(false)
            Panel_skill:setVisible(false)
            Text_sou_lv:setVisible(false)
            Panel_locked:setVisible(true)
            Text_level:setString(string.format(horse_string_info[1], ""..open_level))
            Image_2:setVisible(false)
        end
    end
end

function RaceCourseRideSkillCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.racecourse.racecourse_ride_skill_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root) 
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_skill"), nil, 
    {
        terminal_name = "racecource_ride_skill_choose", 
        terminal_state = 0, 
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,        
    }, nil, 1) 
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_horse_spilits_ware",
        _widget = ccui.Helper:seekWidgetByName(root,"Panel_skill"),
        _invoke = nil,
        _horse_spirits = _ED.horse_spirits[""..self._horse.horse_spirits[self._index]],
        _interval = 0.5,})   
	self:updateDraw()
end

function RaceCourseRideSkillCell:onEnterTransitionFinish()

end

function RaceCourseRideSkillCell:init(params)
    self._index = params[1]
    self._horse = params[2]
    self._chooseShip = params[3]
	self:onInit()
    return self
end

function RaceCourseRideSkillCell:onExit()
    local root = self.roots[1]
    local Panel_skill = ccui.Helper:seekWidgetByName(root, "Panel_skill")
    if Panel_skill ~= nil then
        Panel_skill:removeAllChildren(true)
    end
end