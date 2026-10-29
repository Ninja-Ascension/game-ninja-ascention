-- ------------------------------------------------------------------------------------------------------------
--  阵营对决排行cell
-- ------------------------------------------------------------------------------------------------------------
CampPkMeritoriousCell = class("CampPkMeritoriousCellClass", Window)
CampPkMeritoriousCell.__size = nil

--创建cell
local camp_pk_meritorious_cell_create_terminal = {
    _name = "camp_pk_meritorious_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = CampPkMeritoriousCell:new()
        local index = params[1]
        local info_data = params[2]
        local rank_type = params[3]
        cell:init(index, info_data, rank_type)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(camp_pk_meritorious_cell_create_terminal)
state_machine.init()

function CampPkMeritoriousCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0
    self._rank_type = 0
    local function init_camp_pk_meritorious_cell_terminal()

    end
    init_camp_pk_meritorious_cell_terminal()
end

function CampPkMeritoriousCell:updateDraw()
    local root = self.roots[1]
    local Panel_camp_pk_rank_top = ccui.Helper:seekWidgetByName(root, "Panel_camp_pk_rank_top")
    local Text_camp_pk_rank_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_rank_n")
    local Text_camp_pk_name_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_name_n")
    local Text_camp_pk_fight_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_fight_n")
    local Text_camp_pk_camp_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_camp_n")
    local Text_camp_pk_meritorious_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_meritorious_n")
    Panel_camp_pk_rank_top:removeBackGroundImage()
    Text_camp_pk_rank_n:setString("")
    Text_camp_pk_name_n:setString("")
    Text_camp_pk_fight_n:setString("")
    Text_camp_pk_camp_n:setString("")
    Text_camp_pk_meritorious_n:setString("")

    -- 排名
    if self._index <= 3 then
        Panel_camp_pk_rank_top:setBackGroundImage(string.format(config_res.images.ui.share.rank_icon, self._index))
    else
        Text_camp_pk_rank_n:setString(self._index)
    end

    if self._info_data ~= nil then
        Text_camp_pk_name_n:setString(self._info_data.user_name)
        Text_camp_pk_fight_n:setString(self._info_data.fighting)
        if self._info_data.camp_state == 0 then
            Text_camp_pk_meritorious_n:setString(tipStringInfo_campaign_info[44])
            Text_camp_pk_meritorious_n:setColor(cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3]))
        else
            Text_camp_pk_meritorious_n:setString(tipStringInfo_campaign_info[45])
            Text_camp_pk_meritorious_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        end
        if self._rank_type == 0 then
            Text_camp_pk_camp_n:setString(self._info_data.con)
        else
            Text_camp_pk_camp_n:setString(self._info_data.win_times)
        end
    end
end

function CampPkMeritoriousCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.campaign.camp_pk_meritorious_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if CampPkMeritoriousCell.__size == nil then
        CampPkMeritoriousCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function CampPkMeritoriousCell:onEnterTransitionFinish()

end

function CampPkMeritoriousCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function CampPkMeritoriousCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.camp_pk_meritorious_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function CampPkMeritoriousCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_camp_pk_rank_top = ccui.Helper:seekWidgetByName(root, "Panel_camp_pk_rank_top")
    local Text_camp_pk_rank_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_rank_n")
    local Text_camp_pk_name_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_name_n")
    local Text_camp_pk_fight_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_fight_n")
    local Text_camp_pk_camp_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_camp_n")
    local Text_camp_pk_meritorious_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_meritorious_n")

    if Text_camp_pk_rank_n ~=nil then
        Panel_camp_pk_rank_top:removeBackGroundImage()
        Text_camp_pk_rank_n:setString("")
        Text_camp_pk_name_n:setString("")
        Text_camp_pk_fight_n:setString("")
        Text_camp_pk_camp_n:setString("")
        Text_camp_pk_meritorious_n:setString("")
    end
end

function CampPkMeritoriousCell:init(index, info_data, rank_type)
    self._info_data = info_data
    self._index = index 
    self._rank_type = rank_type
    if index ~= nil and index <= 16 then
        self:onInit()
    end
    self:setContentSize(CampPkMeritoriousCell.__size)
    return self
end

function CampPkMeritoriousCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.camp_pk_meritorious_cell, self.roots[1])
end

