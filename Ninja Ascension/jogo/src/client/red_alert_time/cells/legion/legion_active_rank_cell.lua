-- ------------------------------------------------------------------------------------------------------------
--  军团活跃排行cell
-- ------------------------------------------------------------------------------------------------------------
LegionActiveRankCell = class("LegionActiveRankCellClass", Window)
LegionActiveRankCell.__size = nil

--创建cell
local legion_active_rank_create_cell_terminal = {
    _name = "legion_active_rank_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionActiveRankCell:new()
        local info_data = params[1]
        local index = params[2]
        cell:init(info_data, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_active_rank_create_cell_terminal)
state_machine.init()

function LegionActiveRankCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0
    local function init_legion_active_rank_cell_terminal()
    end
    init_legion_active_rank_cell_terminal()
end

function LegionActiveRankCell:updateDraw()
    local root = self.roots[1]
    local Text_legion_people_name = ccui.Helper:seekWidgetByName(root, "Text_legion_people_name")
    local Text_legion_people_lv = ccui.Helper:seekWidgetByName(root, "Text_legion_people_lv")
    local Text_cotribution_rank = ccui.Helper:seekWidgetByName(root, "Text_cotribution_rank")
    local Text_active_n = ccui.Helper:seekWidgetByName(root, "Text_active_n")
    local Image_vip_icon = ccui.Helper:seekWidgetByName(root, "Image_vip_icon")
    local Text_vip_lv_n = ccui.Helper:seekWidgetByName(root, "Text_vip_lv_n")
    Text_legion_people_name:removeAllChildren(true)
    Text_legion_people_name:setString("")
    Text_legion_people_lv:setString("")
    Text_cotribution_rank:setString("")
    Text_active_n:setString("")
    Text_vip_lv_n:setString("")
    Image_vip_icon:setVisible(false)

    if self._info_data == nil then
        return
    end
    local fontSize = Text_legion_people_name:getFontSize()
    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        fontName = ""
    end

    if tonumber(self._info_data.post) == 1 then         -- 团长
        local _richText_1 = ccui.RichText:create()
        _richText_1:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[1][1],tipStringInfo_union_color[1][2],tipStringInfo_union_color[1][3]),255,  tipStringInfo_union_str[33], config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[3][1],tipStringInfo_union_color[3][2],tipStringInfo_union_color[3][3]),255, self._info_data.name, fontName,fontSize)
        _richText_1:pushBackElement(re2)
        _richText_1:setPosition(cc.p(Text_legion_people_name:getContentSize().width/2,Text_legion_people_name:getContentSize().height/2))
        _richText_1:setContentSize(cc.size(Text_legion_people_name:getContentSize().width,fontSize))
        Text_legion_people_name:addChild(_richText_1)
    elseif tonumber(self._info_data.post) == 2 then     -- 副团长
        local _richText_1 = ccui.RichText:create()
        _richText_1:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[2][1],tipStringInfo_union_color[2][2],tipStringInfo_union_color[2][3]),255,  tipStringInfo_union_str[34], config_res.font.font_name,fontSize)
        _richText_1:pushBackElement(re1)
        local re2 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[3][1],tipStringInfo_union_color[3][2],tipStringInfo_union_color[3][3]),255, self._info_data.name, fontName,fontSize)
        _richText_1:pushBackElement(re2)
        _richText_1:setPosition(cc.p(Text_legion_people_name:getContentSize().width/2,Text_legion_people_name:getContentSize().height/2))
        _richText_1:setContentSize(cc.size(Text_legion_people_name:getContentSize().width,fontSize))
        Text_legion_people_name:addChild(_richText_1)
    else                                                -- 普通成员
        Text_legion_people_name:setString(self._info_data.name)
    end

    Text_legion_people_lv:setString(string.format(red_alert_all_str[117],self._info_data.level))
    Text_cotribution_rank:setString(self._index)
    if tonumber(self._info_data.vip_level) > 0 then
        Image_vip_icon:setVisible(true)
        Text_vip_lv_n:setString(self._info_data.vip_level)
    end

    Text_active_n:setString(self._info_data.daily_active)
end

function LegionActiveRankCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_active_rank_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LegionActiveRankCell.__size == nil then
        LegionActiveRankCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function LegionActiveRankCell:onEnterTransitionFinish()

end

function LegionActiveRankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionActiveRankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_active_rank_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionActiveRankCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_legion_people_name = ccui.Helper:seekWidgetByName(root, "Text_legion_people_name")
    local Text_legion_people_lv = ccui.Helper:seekWidgetByName(root, "Text_legion_people_lv")
    local Text_cotribution_rank = ccui.Helper:seekWidgetByName(root, "Text_cotribution_rank")
    local Text_active_n = ccui.Helper:seekWidgetByName(root, "Text_active_n")
    local Image_vip_icon = ccui.Helper:seekWidgetByName(root, "Image_vip_icon")
    local Text_vip_lv_n = ccui.Helper:seekWidgetByName(root, "Text_vip_lv_n")
    if Text_legion_people_name ~= nil then
        Text_legion_people_name:removeAllChildren(true)
        Text_legion_people_name:setString("")
        Text_legion_people_lv:setString("")
        Text_cotribution_rank:setString("")
        Text_active_n:setString("")
        Text_vip_lv_n:setString("")
        Image_vip_icon:setVisible(false)
    end
end

function LegionActiveRankCell:init(info_data, index)
    self._info_data = info_data
    self._index = index 
    if index ~= nil and index <= 8 then
        self:onInit()
    end
    self:setContentSize(LegionActiveRankCell.__size)
    return self
end

function LegionActiveRankCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_active_rank_cell, self.roots[1])
end

