--[[ ----------------------------------------------------------------------------
-- 跨服矿战排名cell(比赛结束后)
--]] ----------------------------------------------------------------------------

CrossServiceRankOverCell = class("CrossServiceRankOverCellClass", Window)
CrossServiceRankOverCell.__size = nil

-- 创建Cell实例
local sm_cross_service_rank_over_cell_create_terminal = {
    _name = "sm_cross_service_rank_over_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if CrossServiceRankOverCell then
            local cell = CrossServiceRankOverCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cross_service_rank_over_cell_create_terminal)
state_machine.init()

-- 构造器
function CrossServiceRankOverCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._rank_idx = nil  -- 名次
    self._rank_info = nil -- 排行信息
    -- load lua files.

    -- Initialize sm battle report cell page state machine.
    local function init_sm_cross_service_rank_over_cell_terminal()
    end
    -- call func init sm battle report cell state machine.
    init_sm_cross_service_rank_over_cell_terminal()
end

-- 对象初始化
function CrossServiceRankOverCell:init(params)
    self._rank_idx = params.rank_idx
    self._rank_info = params.rank_info
    self:onInit(params)
    self:setContentSize(CrossServiceRankOverCell.__size)
    return self
end

function CrossServiceRankOverCell:onUpdateDraw()
    local root = self.roots[1]
    -- 排名
    local BitmapFontLabel_1 = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_1")
    local BitmapFontLabel_2 = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_2")
    if self._rank_idx < 4 then 
        BitmapFontLabel_1:setVisible(true)
        BitmapFontLabel_2:setVisible(false)
        BitmapFontLabel_1:setString(self._rank_idx)
    else
        BitmapFontLabel_1:setVisible(false)
        BitmapFontLabel_2:setVisible(true)
        BitmapFontLabel_2:setString(self._rank_idx)
    end

    local server_name = _ED.cross_server_battel_all_servers[self._rank_info.serverId]
    local getStr1 = string.match(server_name, "-")
    local getStr2 = string.match(server_name, "_")
    if getStr1 and getStr1 ~= "" then
        server_name = zstring.split(server_name, "-")[1]
    elseif getStr2 and getStr2 ~= "" then
        server_name = zstring.split(server_name, "_")[1]
    end
    -- 服务器名称
    local Text_cross_sver_name = ccui.Helper:seekWidgetByName(root, "Text_cross_sver_name")
    Text_cross_sver_name:setString(server_name)

    -- 积分
    local Text_sver_rank_integral_n = ccui.Helper:seekWidgetByName(root, "Text_sver_rank_integral_n")
    Text_sver_rank_integral_n:setString(self._rank_info.totalScore)

    -- 奖励
    local Text_sver_rank_reward_n = ccui.Helper:seekWidgetByName(root, "Text_sver_rank_reward_n")
    if tonumber(self._rank_info.reWard)> 1000000 then
        Text_sver_rank_reward_n:setString(math.floor(tonumber(self._rank_info.reWard) / 1000) .. string_equiprety_name[40])
    else
        Text_sver_rank_reward_n:setString(self._rank_info.reWard)
    end

end

function CrossServiceRankOverCell:onEnterTransitionFinish()
end

function CrossServiceRankOverCell:onInit(params)
    local root = cacher.createUIRef("campaign/cross_service/cross_service_map_over_cell.csb", "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if CrossServiceRankOverCell.__size == nil then
        CrossServiceRankOverCell.__size = root:getContentSize()
    end
    self:clearUIInfo()
    self:onUpdateDraw()
end

function CrossServiceRankOverCell:onExit()
    -- 释放CrossServiceSeverListCellWindow界面资源.
    self:clearUIInfo()
    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("campaign/cross_service/cross_service_map_over_cell.csb", root)
    -- ]]
end

function CrossServiceRankOverCell:clearUIInfo(...)
    local root = self.roots[1]
    if root ~= nil then
        local Text_cross_sver_name = ccui.Helper:seekWidgetByName(root, "Text_cross_sver_name")
        Text_cross_sver_name:setString("")
        local Text_sver_rank_integral_n = ccui.Helper:seekWidgetByName(root, "Text_sver_rank_integral_n")
        Text_sver_rank_integral_n:setString("")
        local Text_sver_rank_reward_n = ccui.Helper:seekWidgetByName(root, "Text_sver_rank_reward_n")
        Text_sver_rank_reward_n:setString("")
    end
end

-- ~END
-- ----------------------------------------------------------------------------
