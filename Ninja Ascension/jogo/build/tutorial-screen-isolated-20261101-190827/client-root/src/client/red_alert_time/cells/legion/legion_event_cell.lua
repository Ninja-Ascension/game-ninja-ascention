-- ------------------------------------------------------------------------------------------------------------
--  军团事件cell
-- ------------------------------------------------------------------------------------------------------------
LegionEventCell = class("LegionEventCellClass", Window)
LegionEventCell.__size = nil

--创建cell
local legion_event_create_cell_terminal = {
    _name = "legion_event_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionEventCell:new()
        local info_data = params[1]
        local index = params[2]
        cell:init(info_data, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_event_create_cell_terminal)
state_machine.init()

function LegionEventCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    
    local function init_legion_event_cell_terminal()

        state_machine.init()
    end
    
    init_legion_event_cell_terminal()
end


function LegionEventCell:updateDraw()
    local root = self.roots[1]

    local Text_event_time = ccui.Helper:seekWidgetByName(root, "Text_event_time")
    local Text_event_infor = ccui.Helper:seekWidgetByName(root, "Text_event_infor")
    Text_event_time:setString("")
    Text_event_infor:removeAllChildren(true)
    if self._info_data == nil then
        return
    end

    local time_info = os.date("%Y-%m-%d".." ".."%H:%M:%S", zstring.exchangeFrom(zstring.tonumber(self._info_data.time)/1000))
    Text_event_time:setString(time_info)
    local info_name = zstring.split(self._info_data.param, ",")
    local post_1 = 0
    local post_2 = 0
    if self._info_data.post_1 ~= nil then
        post_1 = self._info_data.post_1
    end
    if self._info_data.post_2 ~= nil then
        post_2 = self._info_data.post_2
    end
    local post_name_1 = ""
    local post_name_2 = ""
    if post_1 == 1 then
        post_name_1 = "%|1|".."["..tip_legion_player_position[1].."]".."%"
    elseif post_1 == 2 then
        post_name_1 = "%|2|".."["..tip_legion_player_position[2].."]".."%"
    end
    if post_2 == 1 then
        post_name_2 = "%|1|".."["..tip_legion_player_position[1].."]".."%"
    elseif post_2 == 2 then
        post_name_2 = "%|2|".."["..tip_legion_player_position[2].."]".."%"
    end
    local info = ""
    local info1 = ""
    local info2 = ""
    local info3 = ""
    local posY = 0
    if tonumber(self._info_data.ntype) == 1 or tonumber(self._info_data.ntype) == 2 then
        local infoCount = tonumber(self._info_data.ntype) + 13
        info1 = post_name_1.."%|4|"..self._info_data.name.."%"
        if tonumber(self._info_data.ntype) == 1 then
            info2 = "%|5|"..tipStringInfo_union_str[infoCount].."%"
        elseif tonumber(self._info_data.ntype) == 2 then
            info2 = "%|6|"..tipStringInfo_union_str[infoCount].."%"
        end
        info3 = post_name_2.."%|4|"..self._info_data.param.."%"
        info = string.format(tipStringInfo_union_str[4], info1, info2, info3)
    elseif tonumber(self._info_data.ntype) == 3 
        or tonumber(self._info_data.ntype) == 4
        or tonumber(self._info_data.ntype) == 5
        or tonumber(self._info_data.ntype) == 6
        then
        info2 = post_name_1.."%|4|"..self._info_data.name.."%"
        info1 = post_name_2.."%|4|"..self._info_data.param.."%"
        info = string.format(tipStringInfo_union_str[tonumber(self._info_data.ntype) + 2], info1, info2)
    elseif tonumber(self._info_data.ntype) == 7 then
        info1 = post_name_1.."%|4|"..self._info_data.name.."%"
        info2 = post_name_2.."%|4|"..self._info_data.param.."%"
        info = string.format(tipStringInfo_union_str[tonumber(self._info_data.ntype) + 2], info1, info2)
    elseif tonumber(self._info_data.ntype) == 8 then
        info1 = post_name_1.."%|4|"..self._info_data.name.."%"
        info = string.format(tipStringInfo_union_str[10], info1) 
    elseif tonumber(self._info_data.ntype) == 9 then
        info1 = post_name_2.."%|4|"..self._info_data.param.."%"
        -- info2 = "%|3|"..self._info_data.name.."%"
        info = string.format(tipStringInfo_union_str[11], info1)
    elseif tonumber(self._info_data.ntype) == 10 then
        info1 = post_name_1.."%|4|"..self._info_data.name.."%"
        -- 类型10,参数：模板id,6,数量
        local itemInfo = zstring.split(self._info_data.param, ",")
        local itemName = ""
        if zstring.tonumber(itemInfo[2]) == 13 then
            itemName = dms.string(dms["ship_mould"], itemInfo[1], ship_mould.captain_name)
        elseif zstring.tonumber(itemInfo[2]) == 6 then
            itemName = dms.string(dms["prop_mould"], itemInfo[1], prop_mould.prop_name)
        end
        info2 = "%|4|"..itemName.."%"
        info = string.format(tipStringInfo_union_str[12], info1, info2)
    elseif tonumber(self._info_data.ntype) == 11 then
        info1 = post_name_1.."%|4|"..self._info_data.name.."%"
        local npc_name = dms.string(dms["npc"], self._info_data.param, npc.npc_name)
        local index = dms.string(dms["npc"], self._info_data.param, npc.by_open_npc)
        info2 = "%|3|"..npc_name.."%"
        info = string.format(tipStringInfo_union_str[13], info1, info2, index)
        posY = 20
    elseif tonumber(self._info_data.ntype) == 12 then
        info1 = post_name_1.."%|4|"..self._info_data.name.."%"
        local roleInfo = zstring.split(self._info_data.param, ",")
        if roleInfo[2] ~= "" then
            info2 = "["..roleInfo[2].."]-"..post_name_2.."%|4|"..roleInfo[1].."%"
        else
            info2 = post_name_2.."%|4|"..roleInfo[1].."%"
        end
        info3 = "%|4|"..exChangeNumToString(roleInfo[3]).."%"
        info = string.format(tipStringInfo_union_str[56], info1, info2, info3)
    elseif tonumber(self._info_data.ntype) == 13 then
        info1 = post_name_1.."%|4|"..self._info_data.name.."%"
        local roleInfo = zstring.split(self._info_data.param, ",")
        if roleInfo[2] ~= "" then
            info2 = "["..roleInfo[2].."]-"..post_name_2.."%|4|"..roleInfo[1].."%"
        else
            info2 = post_name_2.."%|4|"..roleInfo[1].."%"
        end
        info = string.format(tipStringInfo_union_str[57], info1, info2)
    elseif tonumber(self._info_data.ntype) == 14 then
        info1 = post_name_1.."%|4|"..self._info_data.name.."%"
        local roleInfo = zstring.split(self._info_data.param, ",")
        if roleInfo[2] ~= "" then
            info2 = "["..roleInfo[2].."]-"..post_name_2.."%|4|"..roleInfo[1].."%"
        else
            info2 = post_name_2.."%|4|"..roleInfo[1].."%"
        end
        info = string.format(tipStringInfo_union_str[58], info1, info2)
    elseif tonumber(self._info_data.ntype) == 15 then
        info1 = post_name_1.."%|4|"..self._info_data.name.."%"
        local roleInfo = zstring.split(self._info_data.param, ",")
        if roleInfo[2] ~= "" then
            info2 = "["..roleInfo[2].."]-"..post_name_2.."%|4|"..roleInfo[1].."%"
        else
            info2 = post_name_2.."%|4|"..roleInfo[1].."%"
        end
        info3 = "%|4|"..exChangeNumToString(roleInfo[3]).."%"
        info = string.format(tipStringInfo_union_str[59], info1, info2, info3)
    elseif tonumber(self._info_data.ntype) == 16 then
        info1 = post_name_2.."%|4|"..self._info_data.param.."%"
        info = string.format(tipStringInfo_union_str[60], info1)
        posY = 20
    elseif tonumber(self._info_data.ntype) == 17 then
        info1 = post_name_2.."%|4|"..self._info_data.param.."%"
        info2 = "%|4|"..self._info_data.name.."%"
        info = string.format(tipStringInfo_union_str[136], info2, info1, info2)
        
    elseif tonumber(self._info_data.ntype) == 40 then
        local world_city_name = dms.string(dms["world_city_mould"], self._info_data.name, world_city_mould.name)
        info1 = "%|4|"..world_city_name.."%"
        local roleInfo = zstring.split(self._info_data.param, ",")
        if roleInfo[2] ~= "" then
            info2 = "["..roleInfo[2].."]-"..post_name_2.."%|4|"..roleInfo[1].."%"
        else
            info2 = post_name_2.."%|4|"..roleInfo[1].."%"
        end
        info = string.format(tipStringInfo_union_str[131], info1, info2)
    elseif tonumber(self._info_data.ntype) == 41 then
        local world_city_name = dms.string(dms["world_city_mould"], self._info_data.name, world_city_mould.name)
        info1 = "%|4|"..world_city_name.."%"
        local roleInfo = zstring.split(self._info_data.param, ",")
        if roleInfo[2] ~= "" then
            info2 = "["..roleInfo[2].."]-"..post_name_2.."%|4|"..roleInfo[1].."%"
        else
            info2 = post_name_2.."%|4|"..roleInfo[1].."%"
        end
        info3 = "%|4|"..exChangeNumToString(roleInfo[3]).."%"
        info = string.format(tipStringInfo_union_str[132], info1, info2, info3)
    elseif tonumber(self._info_data.ntype) == 42 then
        info1 = post_name_1.."%|4|"..self._info_data.name.."%"
        local roleInfo = zstring.split(self._info_data.param, ",")
        local world_city_name = dms.string(dms["world_city_mould"], roleInfo[2], world_city_mould.name)
        info2 = "%|4|"..roleInfo[1].."%"
        info3 = "%|4|"..world_city_name.."%"
        info4 = "%|4|"..exChangeNumToString(roleInfo[3]).."%"
        info = string.format(tipStringInfo_union_str[133], info1, info2, info3, info4)
    elseif tonumber(self._info_data.ntype) == 43 then
        info1 = post_name_1.."%|4|"..self._info_data.name.."%"
        local roleInfo = zstring.split(self._info_data.param, ",")
        local world_city_name = dms.string(dms["world_city_mould"], roleInfo[2], world_city_mould.name)
        info2 = "%|4|"..roleInfo[1].."%"
        info3 = "%|4|"..world_city_name.."%"
        info = string.format(tipStringInfo_union_str[134], info1, info2, info3, info3)
    elseif tonumber(self._info_data.ntype) == 44 then
        local world_city_name = dms.string(dms["world_city_mould"], self._info_data.param, world_city_mould.name)
        info1 = "%|4|"..world_city_name.."%"
        info = string.format(tipStringInfo_union_str[137], info1)
    elseif tonumber(self._info_data.ntype) == 45 then
        local roleInfo = zstring.split(self._info_data.param, ",")
        local world_city_name = dms.string(dms["world_city_mould"], roleInfo[1], world_city_mould.name)
        info1 = "%|4|"..world_city_name.."%"
        info2 = "%|4|"..roleInfo[2].."%"
        info = string.format(tipStringInfo_union_str[138], info1, info2)
    end
    local _richText,l = self:cutStringMain(info, tonumber(Text_event_infor:getContentSize().height),22, tonumber(Text_event_infor:getContentSize().width))
    _richText:setAnchorPoint(cc.p(0, 0.5))
    _richText:setPosition(cc.p(-_richText:getContentSize().width/2 + 5, posY))
    Text_event_infor:removeAllChildren(true)
    Text_event_infor:addChild(_richText)
end

function LegionEventCell:cutStringMain(str, height, fontSize, width)
    local mRoot = ccui.RichText:create()
    local l = string.len(str)
    mRoot:ignoreContentAdaptWithSize(false)
    local count = 0
    while (l > 0) do
        local f,e = string.find(str, "%%%C-%%")
        if f == nil or e == nil then
            local re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[5][1], tipStringInfo_union_color[5][2], tipStringInfo_union_color[5][3]), 255, str, "fonts/simhei.ttf", fontSize)
            mRoot:pushBackElement(re)
            count = count + zstring.utfstrlen(str)
            break
        end
        if f > 1 then
            local strsub = string.sub(str, 1, f-1)
            count = count + zstring.utfstrlen(strsub)
            local re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[5][1], tipStringInfo_union_color[5][2], tipStringInfo_union_color[5][3]), 255, strsub, "fonts/simhei.ttf", fontSize)
            mRoot:pushBackElement(re)
        end
        local name = string.sub(str, f+1, e-1)
        local f1, e1 = string.find(name, "%d+")
        if name == nil or f1 == nil or e1 == nil then
            mRoot:removeAllChildrenWithCleanup(true)
            break
        end
        local quality = string.sub(name, f1, e1)
        local color = tonumber(quality)
        name = string.sub(name, e1+2, string.len(name))
        count = count + zstring.utfstrlen(name)
        if color == nil or color <= 0 or color > 11 then
            mRoot:removeAllChildrenWithCleanup(true)
            break
        end
        local re1 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[color][1],tipStringInfo_union_color[color][2],tipStringInfo_union_color[color][3]), 255, name, "fonts/simhei.ttf", fontSize)
        mRoot:pushBackElement(re1)
        str = string.sub(str, e+1, l)
        l = string.len(str)
    end
    mRoot:setContentSize(cc.size(width-10, height+20))
    return mRoot, count
end

function LegionEventCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_event_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LegionEventCell.__size == nil then
        LegionEventCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function LegionEventCell:onEnterTransitionFinish()

end

function LegionEventCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionEventCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_event_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionEventCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_event_infor = ccui.Helper:seekWidgetByName(root, "Text_event_infor")
    local Text_event_time = ccui.Helper:seekWidgetByName(root, "Text_event_time")
    if Text_event_infor ~= nil then
        Text_event_infor:removeAllChildren(true)
        Text_event_time:setString("")
    end
end

function LegionEventCell:init(info_data, index)
    self._info_data = info_data

    if index ~= nil and index <= 7 then
        self:onInit()
    end
    self:setContentSize(LegionEventCell.__size)
    return self
end

function LegionEventCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_event_cell, self.roots[1])
end

