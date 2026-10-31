--------------------------------------------------------------------------------------------------------------
--  军团在线奖励幸运榜cell
--------------------------------------------------------------------------------------------------------------
LegionOnlineRewardRankCell = class("LegionOnlineRewardRankCellClass", Window)
LegionOnlineRewardRankCell.__size = nil
LegionOnlineRewardRankCell.__text_posY = nil

-- 创建cell
local legion_online_reward_rank_cell_create_terminal = {
    _name = "legion_online_reward_rank_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = LegionOnlineRewardRankCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_online_reward_rank_cell_create_terminal)
state_machine.init()

function LegionOnlineRewardRankCell:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._index = 0
    self._info = nil

    local function init_legion_online_reward_rank_cell_terminal()

    end 
    init_legion_online_reward_rank_cell_terminal()
end

function LegionOnlineRewardRankCell:timeToString(_time)
    local leave_time = os.time() + _ED.time_add_or_sub - _time
    leave_time = math.max(zstring.tonumber(leave_time),0)
    leave_time = math.floor(leave_time)
    local day = math.floor(leave_time/86400)
    if day > 0 then
        leave_time = math.floor(leave_time%86400)
    end
    local hour = math.floor(leave_time/3600)
    local minute = math.floor((leave_time%3600)/60)

    local time_str = ""
    if day > 0 then
        time_str = ""..day..tipStringInfo_time_info[4]
    elseif hour > 0 then
        time_str = ""..hour..tipStringInfo_time_info[5]
    else
        time_str = ""..minute..tipStringInfo_time_info[6]
    end

    return time_str
end

-- 刷新
function LegionOnlineRewardRankCell:updateDraw()
    local root = self.roots[1]
    local current_time = os.time() + _ED.time_add_or_sub

    local Text_1_1 = ccui.Helper:seekWidgetByName(root,"Text_1_1")
    Text_1_1:setString("")
    Text_1_1:removeAllChildren(true)

    local text_size = Text_1_1:getContentSize()

    if self._info ~= nil then
        local time_str = string.format(activity_str_tip[209], self:timeToString(self._info.time), self._info.name)

        local propInfo = zstring.split(self._info.reward, ",")
        local prop_id = propInfo[1]
        if tonumber(propInfo[1]) == -1 then
            prop_id = propInfo[2]
        end
        local name = dms.string(dms["prop_mould"], prop_id, prop_mould.prop_name)
        local quality = dms.int(dms["prop_mould"], prop_id, prop_mould.prop_quality)

        local font_size = Text_1_1:getFontSize()
        local _richText = ccui.RichText:create()
        _richText:setContentSize(cc.size(Text_1_1:getContentSize().width,font_size))
        _richText:setAnchorPoint(0, 1)
        _richText:ignoreContentAdaptWithSize(false)
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, time_str, config_res.font.font_name,font_size)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]),255, name.."*"..propInfo[3], config_res.font.font_name,font_size)
        _richText:pushBackElement(re2)

        _richText:formatTextExt()
        local rsize = _richText:getContentSize()
        _richText:setPosition(cc.p(0,Text_1_1:getContentSize().height))
        Text_1_1:addChild(_richText)
        
        local add_height = rsize.height - text_size.height
        self:setContentSize(LegionOnlineRewardRankCell.__size.width, rsize.height)
        Text_1_1:setPositionY(LegionOnlineRewardRankCell.__text_posY + rsize.height + add_height)
    end
end 

function LegionOnlineRewardRankCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion_online_reward_rank_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LegionOnlineRewardRankCell.__size == nil then
        LegionOnlineRewardRankCell.__size = root:getContentSize()
    end

    local Text_1_1 = ccui.Helper:seekWidgetByName(root,"Text_1_1")
    if LegionOnlineRewardRankCell.__text_posY == nil then
        LegionOnlineRewardRankCell.__text_posY = Text_1_1:getPositionY()
    end

    root:setContentSize(LegionOnlineRewardRankCell.__size)
    Text_1_1:setPositionY(LegionOnlineRewardRankCell.__text_posY)

    self:setContentSize(LegionOnlineRewardRankCell.__size)

    self:updateDraw()
end

function LegionOnlineRewardRankCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function LegionOnlineRewardRankCell:clearUIInfo( ... )
    local root = self.roots[1]
     local Text_1_1 = ccui.Helper:seekWidgetByName(root,"Text_1_1")
     if Text_1_1 ~= nil then
        Text_1_1:setString("")
        Text_1_1:removeAllChildren(true)

        Text_1_1:setPositionY(LegionOnlineRewardRankCell.__text_posY)
        root:setContentSize(LegionOnlineRewardRankCell.__size)
    end
end

function LegionOnlineRewardRankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LegionOnlineRewardRankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion_online_reward_rank_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function LegionOnlineRewardRankCell:init(params)
    self._index = params[1]
    self._info = params[2]

    -- if self._index ~= nil and self._index <= 3 then
       self:onInit()
    -- end
    -- self:setContentSize(LegionOnlineRewardRankCell.__size)
    return self
end

function LegionOnlineRewardRankCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.legion_online_reward_rank_cell, self.roots[1])
end