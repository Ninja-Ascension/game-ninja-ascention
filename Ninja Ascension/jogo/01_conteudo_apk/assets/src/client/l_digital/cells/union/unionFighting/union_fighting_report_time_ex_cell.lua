-- ------------------------------------------------------------------------------------------------------------
--  工会战战报时间cell
-- ------------------------------------------------------------------------------------------------------------
UnionFightingReportTimeEXCell = class("UnionFightingReportTimeEXCellClass", Window)
UnionFightingReportTimeEXCell.__size = nil

--创建cell
local union_fighting_report_time_ex_cell_create_terminal = {
    _name = "union_fighting_report_time_ex_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = UnionFightingReportTimeEXCell:new()
        local time = params[1]
        local round = params[2]
        local isOver = params[3]
        local info = params[4]
        cell:init(time, round, isOver, info)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 1)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_fighting_report_time_ex_cell_create_terminal)
state_machine.init()

function UnionFightingReportTimeEXCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._time = 0
    self._round = 0
    self._isOver = false
    self._info = nil
    self._AtlasLabel_m = nil
    self._AtlasLabel_s = nil
end

function UnionFightingReportTimeEXCell:updateDraw()
    local root = self.roots[1]
    local Text_ghz_js_p = ccui.Helper:seekWidgetByName(root, "Text_ghz_js_p")
    local Image_ghz_ks = ccui.Helper:seekWidgetByName(root, "Image_ghz_ks")
    local Image_daojishi_m = ccui.Helper:seekWidgetByName(root, "Image_daojishi_m")

    self._AtlasLabel_m = ccui.Helper:seekWidgetByName(root, "AtlasLabel_m")
    self._AtlasLabel_s = ccui.Helper:seekWidgetByName(root, "AtlasLabel_s")

    Text_ghz_js_p:setString("")
    self._AtlasLabel_m:setString("")
    self._AtlasLabel_s:setString("")
    Image_ghz_ks:setVisible(false)
    Image_daojishi_m:setVisible(false)
    if self._time == nil then
        if self._isOver == true then
            if self._info ~= nil then
                if self._info.win_union ~= nil and self._info.lose_union ~= nil and self._info.report_count ~= nil then
                    if self._info.report_count > 0 then
                        Text_ghz_js_p:setString(string.format(tipStringInfo_union_str[106], self._info.win_union, self._info.lose_union))
                    else
                        Text_ghz_js_p:setString(string.format(tipStringInfo_union_str[109], self._info.lose_union, self._info.win_union, self._info.lose_union))
                    end
                elseif self._info.union_is_join == false then
                    Text_ghz_js_p:setString(tipStringInfo_union_str[108])
                end
            else
                Text_ghz_js_p:setString(tipStringInfo_union_str[79])
            end
        else
            Text_ghz_js_p:setString(string.format(tipStringInfo_union_str[78], self._round))
        end
    else
        self:registerOnNoteUpdate(self, 1)
        self._AtlasLabel_m:setString(string.format("%02d", math.floor(self._time / 60)))
        self._AtlasLabel_s:setString(string.format("%02d", math.floor(self._time % 60)))
        Image_ghz_ks:setVisible(true)
        Image_daojishi_m:setVisible(true)
    end
end

function UnionFightingReportTimeEXCell:onUpdate( dt )
    if self._time == nil then
        return
    end
    self._time = self._time - dt
    if self._AtlasLabel_m ~= nil and self._AtlasLabel_s ~= nil then
        if self._time <= 0 then
            self._time = 0
        end
        self._AtlasLabel_m:setString(string.format("%02d", math.floor(self._time / 60)))
        self._AtlasLabel_s:setString(string.format("%02d", math.floor(self._time % 60)))
    end
end

function UnionFightingReportTimeEXCell:onInit(isNewReport)
    local root = cacher.createUIRef(string.format(config_csb.union_fight.sm_legion_ghz_fighting_cell, 2), "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if UnionFightingReportTimeEXCell.__size == nil then
        UnionFightingReportTimeEXCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function UnionFightingReportTimeEXCell:onEnterTransitionFinish()

end

function UnionFightingReportTimeEXCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function UnionFightingReportTimeEXCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:unregisterOnNoteUpdate(self)
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_fighting_cell, 2), root)
    root:removeFromParent(false)
    self.roots = {}
    self.actions = {}
end

function UnionFightingReportTimeEXCell:clearUIInfo( ... )
    local root = self.roots[1]
    self:unregisterOnNoteUpdate(self)
    local Text_ghz_js_p = ccui.Helper:seekWidgetByName(root, "Text_ghz_js_p")
    local Image_ghz_ks = ccui.Helper:seekWidgetByName(root, "Image_ghz_ks")
    local Image_daojishi_m = ccui.Helper:seekWidgetByName(root, "Image_daojishi_m")
    local AtlasLabel_m = ccui.Helper:seekWidgetByName(root, "AtlasLabel_m")
    local AtlasLabel_s = ccui.Helper:seekWidgetByName(root, "AtlasLabel_s")
    if Text_ghz_js_p ~= nil then
        Text_ghz_js_p:setString("")
        AtlasLabel_m:setString("")
        AtlasLabel_s:setString("")
        Image_ghz_ks:setVisible(false)
        Image_daojishi_m:setVisible(false)
    end
    self._AtlasLabel_m = nil
    self._AtlasLabel_s = nil
end

function UnionFightingReportTimeEXCell:init(time, round, isOver, info)
    self._time = time
    self._round = round
    self._isOver = isOver
    self._info = info
    self:onInit()
    self:setContentSize(UnionFightingReportTimeEXCell.__size)
    return self
end

function UnionFightingReportTimeEXCell:onExit()
    self:clearUIInfo()
    local root = self.roots[1]
    cacher.freeRef(string.format(config_csb.union_fight.sm_legion_ghz_fighting_cell, 2), root)
end

