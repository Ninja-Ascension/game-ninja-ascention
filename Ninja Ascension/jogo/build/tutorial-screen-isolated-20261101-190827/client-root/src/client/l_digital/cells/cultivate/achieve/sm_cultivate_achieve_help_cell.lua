--------------------------------------------------------------------------------------------------------------
SmCultivateAchieveHelpCell = class("SmCultivateAchieveHelpCellClass", Window)
SmCultivateAchieveHelpCell.__size = nil

local sm_cultivate_achieve_cell_help_terminal = {
    _name = "sm_cultivate_achieve_cell_help",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmCultivateAchieveHelpCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cultivate_achieve_cell_help_terminal)
state_machine.init()

function SmCultivateAchieveHelpCell:ctor()
	self.super:ctor()
	self.roots = {}
end

function SmCultivateAchieveHelpCell:updateDraw()
    local root = self.roots[1]
    local txt_name = ccui.Helper:seekWidgetByName(root,"Text_change_name")
    local txt_sorce = ccui.Helper:seekWidgetByName(root,"Text_013_6")
    local txt_current_title = ccui.Helper:seekWidgetByName(root,"Image_1")
    local lock = ccui.Helper:seekWidgetByName(root,"Panel_icon_lock")

    local name = dms.element(dms["word_mould"], zstring.tonumber(self.params.name))[3]
    local sorce = self.params.sorce

    txt_name:setString(name)
    txt_sorce:setString(sorce)
    txt_current_title:setVisible(tonumber(self.my_id) == tonumber(self.params.id))
    lock:setVisible(tonumber(self.my_id) < tonumber(self.params.id))

    self:drawHead()

end

function SmCultivateAchieveHelpCell:drawHead()
    local root = self.roots[1]
    --头像
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_change_icon")
    Panel_player_icon:removeBackGroundImage()
    Panel_player_icon:removeAllChildren(true)

    local quality_path = ""
    if tonumber(_ED.vip_grade) > 0 then
        quality_path = "images/ui/quality/player_1.png"
    else
        quality_path = "images/ui/quality/player_2.png"
    end
    local SpritKuang = cc.Sprite:create(quality_path)
    SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
    SpritKuang:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
    Panel_player_icon:addChild(SpritKuang,0)

    local big_icon_path = ""
    local pic = tonumber(_ED.user_info.user_head)
    if pic >= 9 then
        big_icon_path = string.format("images/ui/props/props_%d.png", pic)
    else
        big_icon_path = string.format("images/ui/home/head_%d.png", pic)
    end
    local sprit = cc.Sprite:create(big_icon_path)
    sprit:setAnchorPoint(cc.p(0.5,0.5))
    sprit:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
    Panel_player_icon:addChild(sprit,0)
end

function SmCultivateAchieveHelpCell:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_achievement_help_list.csb")
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if not SmCultivateAchieveHelpCell.__size then
        SmCultivateAchieveHelpCell.__size = root:getContentSize()
    end
    self:setContentSize(SmCultivateAchieveHelpCell.__size)
	self:updateDraw()
end

function SmCultivateAchieveHelpCell:onEnterTransitionFinish()

end

function SmCultivateAchieveHelpCell:init(params)
    self.params = params[1]
    self.my_id = params[2]
	self:onInit()
    if SmCultivateAchieveHelpCell.__size then
        self:setContentSize(SmCultivateAchieveHelpCell.__size)
    end

    return self
end

function SmCultivateAchieveHelpCell:onExit()
end