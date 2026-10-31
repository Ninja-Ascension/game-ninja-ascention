-- ------------------------------------------------------------------------------------------------------------
--  军团贡献排名cell
-- ------------------------------------------------------------------------------------------------------------
LegionCotributionRankCell = class("LegionCotributionRankCellClass", Window)
LegionCotributionRankCell.__size = nil

--创建cell
local legion_cotribution_rank_create_cell_terminal = {
    _name = "legion_cotribution_rank_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionCotributionRankCell:new()
        local info_data = params[1]
        local index = params[2]
        cell:init(info_data, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_cotribution_rank_create_cell_terminal)
state_machine.init()

function LegionCotributionRankCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    self._index = 0
    local function init_legion_cotribution_rank_cell_terminal()
        local legion_cotribution_rank_cell_open_manager_terminal = {
            _name = "legion_cotribution_rank_cell_open_manager",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                state_machine.excute("legion_member_infor_window_open", 0, {cell._info_data, cell})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_cotribution_rank_cell_update_info_terminal = {
            _name = "legion_cotribution_rank_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params.cell
                cell._index = params.index
                cell._info_data = params.info_data
                if cell._info_data ~= nil then
                    if cell._index <= 7 then
                        cell:reload()
                        cell:updateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_cotribution_rank_cell_open_manager_terminal)  
        state_machine.add(legion_cotribution_rank_cell_update_info_terminal)  
        state_machine.init()
    end
    
    init_legion_cotribution_rank_cell_terminal()
end


function LegionCotributionRankCell:updateDraw()
    local root = self.roots[1]
    local Text_legion_people_name = ccui.Helper:seekWidgetByName(root, "Text_legion_people_name")
    local Text_legion_people_lv = ccui.Helper:seekWidgetByName(root, "Text_legion_people_lv")
    local Text_cotribution_rank = ccui.Helper:seekWidgetByName(root, "Text_cotribution_rank")
    local Text_cotribution_n = ccui.Helper:seekWidgetByName(root, "Text_cotribution_n")
    local Button_set_up_people = ccui.Helper:seekWidgetByName(root, "Button_set_up_people")
    local Image_vip_icon = ccui.Helper:seekWidgetByName(root, "Image_vip_icon")
    local Text_vip_lv_n = ccui.Helper:seekWidgetByName(root, "Text_vip_lv_n")
    Text_legion_people_name:removeAllChildren(true)
    Text_legion_people_name:setString("")
    Text_legion_people_lv:setString("")
    Text_cotribution_rank:setString("")
    Text_cotribution_n:setString("")
    Text_vip_lv_n:setString("")
    Image_vip_icon:setVisible(false)
    Button_set_up_people:setVisible(true)

    if self._info_data == nil then
        return
    end
    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        fontName = ""
    end
    -- name
    if __lua_project_id == __lua_project_pacific_rim then
        local Panel_leader_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_icon")
        Panel_leader_icon:removeBackGroundImage()
        Panel_leader_icon:setVisible(true)
        Text_legion_people_name:setString(self._info_data.name)
        Text_vip_lv_n:setString(_string_piece_info[228]..self._info_data.vip_level)
        if tonumber(self._info_data.post) == 1 then
            Panel_leader_icon:setBackGroundImage(string.format(config_res.images.ui.legion.legion_leader_icon, 1))
        elseif tonumber(self._info_data.post) == 2 then
            Panel_leader_icon:setBackGroundImage(string.format(config_res.images.ui.legion.legion_leader_icon, 2))
        end
        if tonumber(self._info_data.id) == tonumber(_ED.user_info.user_id) then
            root:setTouchEnabled(false)
        else
            root:setTouchEnabled(true)
        end
    else
        root:setTouchEnabled(false)
        if tonumber(self._info_data.post) == 1 then         -- 团长
            local _richText_1 = ccui.RichText:create()
            _richText_1:ignoreContentAdaptWithSize(false)       
            local re1 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[1][1],tipStringInfo_union_color[1][2],tipStringInfo_union_color[1][3]),255,  tipStringInfo_union_str[33], "fonts/simhei.ttf",20)
            _richText_1:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[3][1],tipStringInfo_union_color[3][2],tipStringInfo_union_color[3][3]),255, self._info_data.name, fontName,20)
            _richText_1:pushBackElement(re2)
            _richText_1:setPosition(cc.p(Text_legion_people_name:getContentSize().width/2,Text_legion_people_name:getContentSize().height/2))
            _richText_1:setContentSize(cc.size(Text_legion_people_name:getContentSize().width,20))
            Text_legion_people_name:addChild(_richText_1)
        elseif tonumber(self._info_data.post) == 2 then     -- 副团长
            local _richText_1 = ccui.RichText:create()
            _richText_1:ignoreContentAdaptWithSize(false)       
            local re1 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[2][1],tipStringInfo_union_color[2][2],tipStringInfo_union_color[2][3]),255,  tipStringInfo_union_str[34], "fonts/simhei.ttf",20)
            _richText_1:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[3][1],tipStringInfo_union_color[3][2],tipStringInfo_union_color[3][3]),255, self._info_data.name, fontName,20)
            _richText_1:pushBackElement(re2)
            _richText_1:setPosition(cc.p(Text_legion_people_name:getContentSize().width/2,Text_legion_people_name:getContentSize().height/2))
            _richText_1:setContentSize(cc.size(Text_legion_people_name:getContentSize().width,20))
            Text_legion_people_name:addChild(_richText_1)
        else                                                -- 普通成员
            Text_legion_people_name:setString(self._info_data.name)
        end
        -- VIP
        if tonumber(self._info_data.vip_level) > 0 then
            Image_vip_icon:setVisible(true)
            Text_vip_lv_n:setString(self._info_data.vip_level)
        end
    end

    -- 等级
    Text_legion_people_lv:setString(string.format(red_alert_all_str[117],self._info_data.level))

    -- 战力
    local Text_legion_people_fight = ccui.Helper:seekWidgetByName(root, "Text_legion_people_fight")
    if Text_legion_people_fight ~= nil then
        Text_legion_people_fight:setString(exChangeNumToString(self._info_data.capactity))
    end

    -- 周贡献
    Text_cotribution_n:setString(self._info_data.week_devote)

    -- 管理按钮
    if tonumber(self._info_data.id) == tonumber(_ED.user_info.user_id) then
        Button_set_up_people:setVisible(false)
    end

    -- 排名
    Text_cotribution_rank:setString(self._info_data.rank)
end

function LegionCotributionRankCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_cotribution_rank_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LegionCotributionRankCell.__size == nil then
        LegionCotributionRankCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_set_up_people"), nil, 
    {
        terminal_name = "legion_cotribution_rank_cell_open_manager", 
        terminal_state = 0, 
        cell = self,
        touch_black = true,
    }, nil, 1)  

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
                state_machine.excute("legion_cotribution_rank_cell_open_manager", 0, {_datas = {cell = self}})
            end
        end
    end
    root:addTouchEventListener(panelTouchListener) 

    self:updateDraw()
end

function LegionCotributionRankCell:onEnterTransitionFinish()

end

function LegionCotributionRankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionCotributionRankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_cotribution_rank_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionCotributionRankCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_legion_people_name = ccui.Helper:seekWidgetByName(root, "Text_legion_people_name")
    local Text_legion_people_lv = ccui.Helper:seekWidgetByName(root, "Text_legion_people_lv")
    local Text_cotribution_rank = ccui.Helper:seekWidgetByName(root, "Text_cotribution_rank")
    local Text_cotribution_n = ccui.Helper:seekWidgetByName(root, "Text_cotribution_n")
    local Button_set_up_people = ccui.Helper:seekWidgetByName(root, "Button_set_up_people")
    local Image_vip_icon = ccui.Helper:seekWidgetByName(root, "Image_vip_icon")
    local Text_vip_lv_n = ccui.Helper:seekWidgetByName(root, "Text_vip_lv_n")
    if Text_legion_people_name ~= nil then
        Text_legion_people_name:removeAllChildren(true)
        Text_legion_people_name:setString("")
        Text_legion_people_lv:setString("")
        Text_cotribution_rank:setString("")
        Text_cotribution_n:setString("")
        Text_vip_lv_n:setString("")
        Image_vip_icon:setVisible(false)
        Button_set_up_people:setVisible(true)
    end
end

function LegionCotributionRankCell:init(info_data, index)
    self._info_data = info_data
    self._index = index 
    if index ~= nil and index <= 7 then
        self:onInit()
    end
    self:setContentSize(LegionCotributionRankCell.__size)
    return self
end

function LegionCotributionRankCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_cotribution_rank_cell, self.roots[1])
end

