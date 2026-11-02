--[[ ----------------------------------------------------------------------------
-- 跨服矿战报名界面服务器列表cell
--]] ----------------------------------------------------------------------------
CrossServiceSeverListCell = class("CrossServiceSeverListCellClass", Window)
CrossServiceSeverListCell.__size = nil

-- 创建Cell实例
local sm_cross_service_sever_list_cell_create_terminal = {
    _name = "sm_cross_service_sever_list_cell_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if CrossServiceSeverListCell then
            local cell = CrossServiceSeverListCell:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cross_service_sever_list_cell_create_terminal)
state_machine.init()

-- 构造器
function CrossServiceSeverListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._server_name = nil -- 服务器信息

    -- load lua files.

    -- Initialize sm battle report cell page state machine.
    local function init_sm_cross_service_sever_list_cell_terminal()
    end
    -- call func init sm battle report cell state machine.
    init_sm_cross_service_sever_list_cell_terminal()
end

-- 对象初始化
function CrossServiceSeverListCell:init(params)
    self._server_name = params.sever_name
    self:onInit(params)
    self:setContentSize(CrossServiceSeverListCell.__size)
    return self
end

function CrossServiceSeverListCell:onUpdateDraw()
    local root = self.roots[1]
    local server_name = self._server_name
    local getStr1 = string.match(server_name, "-")
    local getStr2 = string.match(server_name, "_")
    if getStr1 and getStr1 ~= "" then
        server_name = zstring.split(server_name, "-")[1]
    elseif getStr2 and getStr2 ~= "" then
        server_name = zstring.split(server_name, "_")[1]
    end
    -- 服务器名称
    local Text_severs_num = ccui.Helper:seekWidgetByName(root, "Text_severs_num")
    Text_severs_num:setString(server_name)
end

function CrossServiceSeverListCell:onEnterTransitionFinish()
end

function CrossServiceSeverListCell:onInit(params)
    local root = cacher.createUIRef("campaign/cross_service/cross_service_begin_cell.csb", "root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if CrossServiceSeverListCell.__size == nil then
        CrossServiceSeverListCell.__size = root:getContentSize()
    end
    self:clearUIInfo()
    self:onUpdateDraw()
end

function CrossServiceSeverListCell:onExit()
    -- 释放CrossServiceSeverListCellWindow界面资源.
    self:clearUIInfo()
    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("campaign/cross_service/cross_service_begin_cell.csb", root)
    -- ]]
end

function CrossServiceSeverListCell:clearUIInfo(...)
    local root = self.roots[1]
    if root ~= nil then
        local Text_severs_num = ccui.Helper:seekWidgetByName(root, "Text_severs_num")
        Text_severs_num:setString("")
    end
end

-- ~END
-- ----------------------------------------------------------------------------
