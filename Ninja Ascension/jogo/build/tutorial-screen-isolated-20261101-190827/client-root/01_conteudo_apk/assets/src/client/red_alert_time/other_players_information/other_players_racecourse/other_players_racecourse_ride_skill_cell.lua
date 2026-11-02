-----------------------------
--兽魂cell
-----------------------------
OtherPlayersRaceCourseRideSkillCell = class("OtherPlayersRaceCourseRideSkillCellClass", Window)

local other_players_racecource_ride_skill_create_cell_terminal = {
    _name = "other_players_racecource_ride_skill_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = OtherPlayersRaceCourseRideSkillCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(other_players_racecource_ride_skill_create_cell_terminal)
state_machine.init()

function OtherPlayersRaceCourseRideSkillCell:ctor()
	self.super:ctor()
	self.roots = {}
    self._index = 0
    -- 珍兽信息
    self._horse = nil
    
    local function init_other_players_racecource_ride_skill_cell_terminal()
        -- 查看兽魂详情
        local other_players_racecource_ride_skill_choose_terminal = {
            _name = "other_players_racecource_ride_skill_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if tonumber(cell._horse.horse_spirits[cell._index]) == 0 then
                else
                    state_machine.excute("other_players_racecourse_attribute_window_open", 0, {cell._horse, cell._index})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(other_players_racecource_ride_skill_choose_terminal)
        state_machine.init()
    end
    
    init_other_players_racecource_ride_skill_cell_terminal()
end

function OtherPlayersRaceCourseRideSkillCell:updateDraw()
    local root = self.roots[1]
    -- 兽魂层
    local Panel_choose = ccui.Helper:seekWidgetByName(root, "Panel_choose")
    Panel_choose:setVisible(true)
    -- 没有镶嵌兽魂时的动画
    local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
    Image_2:setVisible(true)
    local actions = cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.3,1.1),cc.ScaleTo:create(0.3,1)))
    Image_2:runAction(actions)
    -- 兽魂动画
    local Panel_skill = ccui.Helper:seekWidgetByName(root, "Panel_skill")
    Panel_skill:setVisible(true)
    Panel_skill:removeAllChildren(true)
    -- 兽魂等级
    local Text_sou_lv = ccui.Helper:seekWidgetByName(root, "Text_sou_lv")
    Text_sou_lv:setVisible(true)
    local house_spirits = _ED.other_horse_spirits[""..self._horse.horse_spirits[self._index]]
    -- 如果有兽魂播放兽魂动画显示兽魂等级
    if house_spirits ~= nil then
        local icon = dms.int(dms["horse_spirit_mould"], house_spirits.mould_id, horse_spirit_mould.icon)
        cc.Director:getInstance():getTextureCache():addImage("images/ui/enchant/treasure_effect/treasure_effect_"..icon.."0.png")
        cc.SpriteFrameCache:getInstance():addSpriteFrames("images/ui/enchant/treasure_effect/treasure_effect_"..icon.."0.plist")
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/enchant/treasure_effect/treasure_effect_"..icon..".ExportJson")
        Image_2:setVisible(false)
        local level = dms.int(dms["horse_spirit_mould"], house_spirits.mould_id, horse_spirit_mould.level)
        Text_sou_lv:setString("+"..level)
        local effect_paths = "images/ui/enchant/treasure_effect/treasure_effect_"..icon..".ExportJson"
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
        local armature = ccs.Armature:create("treasure_effect_"..icon)
        draw.initArmature(armature, nil, -1, 0, 1)
        armature:setPosition(cc.p(Panel_skill:getContentSize().width/2, Panel_skill:getContentSize().height/2))
        Panel_skill:addChild(armature)
    end
end

function OtherPlayersRaceCourseRideSkillCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.racecourse.racecourse_ride_skill_cell)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root) 
    table.insert(self.roots, root)
    -- 兽魂详情
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_skill"), nil, 
    {
        terminal_name = "other_players_racecource_ride_skill_choose", 
        terminal_state = 0, 
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95,        
    }, nil, 2) 

	self:updateDraw()
end

function OtherPlayersRaceCourseRideSkillCell:onEnterTransitionFinish()

end

function OtherPlayersRaceCourseRideSkillCell:init(params)
    self._index = params[1]
    self._horse = params[2]
	self:onInit()
    return self
end

function OtherPlayersRaceCourseRideSkillCell:onExit()
    local root = self.roots[1]
    local Panel_skill = ccui.Helper:seekWidgetByName(root, "Panel_skill")
    if Panel_skill ~= nil then
        Panel_skill:removeAllChildren(true)
    end
end