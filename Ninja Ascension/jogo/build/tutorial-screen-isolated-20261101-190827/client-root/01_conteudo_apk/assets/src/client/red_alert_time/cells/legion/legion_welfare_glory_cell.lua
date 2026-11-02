-- ------------------------------------------------------------------------------------------------------------
--  军团荣耀cell
-- ------------------------------------------------------------------------------------------------------------
LegionWelfareGloryCell = class("LegionWelfareGloryCellClass", Window)
LegionWelfareGloryCell.__size = nil

--创建cell
local legion_welfare_glory_cell_create_terminal = {
    _name = "legion_welfare_glory_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionWelfareGloryCell:new()
        local info_data = params[1]
        local index = params[2]
        cell:init(info_data, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_welfare_glory_cell_create_terminal)
state_machine.init()

function LegionWelfareGloryCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._info_data = nil
    local function init_legion_welfare_glory_cell_terminal()

        state_machine.init()
    end
    
    init_legion_welfare_glory_cell_terminal()
end


function LegionWelfareGloryCell:updateDraw()
    local root = self.roots[1]

    local Text_date = ccui.Helper:seekWidgetByName(root, "Text_date")
    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
    local Text_info = ccui.Helper:seekWidgetByName(root, "Text_info")
    Text_date:setString("")
    Text_time:setString("")
    Text_info:removeAllChildren(true)
    if self._info_data == nil then
        return
    end
    local date_info = os.date("%m-%d", zstring.exchangeFrom(zstring.tonumber(self._info_data.time)/1000))
    Text_date:setString(date_info)
    local time_info = os.date("%H:%M", zstring.exchangeFrom(zstring.tonumber(self._info_data.time)/1000))
    Text_time:setString(time_info)

    local info = ""
    local info1 = ""
    local info2 = ""
    local info3 = ""
    local posY = 0
    if tonumber(self._info_data.ntype) == 20 then
        local param = zstring.split(self._info_data.param, "!")
        local reward_info = zstring.split(param[2], "|")
        info1 = param[1]
        for k,v in pairs(reward_info) do
            local reward_data = zstring.split(v, ",")
            local prop_name = dms.string(dms["prop_mould"], reward_data[1], prop_mould.prop_name)
            info2 = info2..prop_name.."*"..reward_data[3].."，"
        end
        info2 = "%|3|"..info2.."%"
        info = string.format(tipStringInfo_union_str[14], info1, info2)
    elseif tonumber(self._info_data.ntype) == 21 then
        local param = zstring.split(self._info_data.param, ",")
        info1 = param[1]
        info2 = param[2]
        info = string.format(tipStringInfo_union_str[29], info1, info2)
    elseif tonumber(self._info_data.ntype) == 22 then
        local param = zstring.split(self._info_data.param, "!")
        local reward_info = zstring.split(param[2], "|")
        info1 = param[1]
        for k,v in pairs(reward_info) do
            local reward_data = zstring.split(v, ",")
            local prop_name = dms.string(dms["prop_mould"], reward_data[1], prop_mould.prop_name)
            info2 = info2..prop_name.."*"..reward_data[3].."，"
        end
        info2 = "%|3|"..info2.."%"
        info = string.format(tipStringInfo_union_str[15], info1, info2)
    elseif tonumber(self._info_data.ntype) == 23 then
        local param = zstring.split(self._info_data.param, "!") 
        local reward_info = zstring.split(param[2], "|")
        info1 = dms.string(dms["world_city_mould"], param[1], world_city_mould.name)
        for k,v in pairs(reward_info) do
            local reward_data = zstring.split(v, ",")
            local prop_name = dms.string(dms["prop_mould"], reward_data[1], prop_mould.prop_name)
            info2 = info2..prop_name.."*"..reward_data[3].."，"
        end
        info2 = "%|3|"..info2.."%"
        info = string.format(tipStringInfo_union_str[135], info1, info2)
    end
    local _richText,l = self:cutStringMain(info, tonumber(Text_info:getContentSize().height),22, tonumber(Text_info:getContentSize().width))
    _richText:setAnchorPoint(cc.p(0, 0.5))
    _richText:setPosition(cc.p(-_richText:getContentSize().width/2 + 5, posY+30))
    Text_info:removeAllChildren(true)
    Text_info:addChild(_richText)
end

function LegionWelfareGloryCell:cutStringMain(str, height, fontSize, width)
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
        local re1 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[2][1],tipStringInfo_union_color[2][2],tipStringInfo_union_color[2][3]), 255, name, "fonts/simhei.ttf", fontSize)
        mRoot:pushBackElement(re1)
        str = string.sub(str, e+1, l)
        l = string.len(str)
    end
    mRoot:setContentSize(cc.size(width-10, height+20))
    return mRoot, count
end


function LegionWelfareGloryCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_welfare_glory_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    if LegionWelfareGloryCell.__size == nil then
        LegionWelfareGloryCell.__size = root:getContentSize()
    end

    self:updateDraw()
end

function LegionWelfareGloryCell:onEnterTransitionFinish()

end

function LegionWelfareGloryCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionWelfareGloryCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_welfare_glory_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionWelfareGloryCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_date = ccui.Helper:seekWidgetByName(root,"Text_date")
    local Text_time = ccui.Helper:seekWidgetByName(root,"Text_time")
    local Text_info = ccui.Helper:seekWidgetByName(root,"Text_info")
    if Text_date ~= nil then
        Text_date:setString("")
        Text_time:setString("")
        Text_info:setString("")
        Text_info:removeAllChildren(true)
    end
end

function LegionWelfareGloryCell:init(info_data, index)
    self._info_data = info_data

    if index ~= nil and index <= 7 then
        self:onInit()
    end
    self:setContentSize(LegionWelfareGloryCell.__size)
    return self
end

function LegionWelfareGloryCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion.legion_welfare_glory_cell, self.roots[1])
end

