--------------------------------------------------------------------------------------------------------------
--  国战排行榜信息
--------------------------------------------------------------------------------------------------------------
PlayerHeadCell = class("PlayerHeadCellClass", Window)
PlayerHeadCell.__size = nil

--创建cell
local player_head_cell_create_terminal = {
    _name = "player_head_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = PlayerHeadCell:new()
        cell:init(params)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(player_head_cell_create_terminal)
state_machine.init()

function PlayerHeadCell:ctor()
    -- 初始化调用参数
    self.super:ctor()
    self.roots = {}
end

function PlayerHeadCell:onUpdateDraw(params)
    local root = self.roots[1]

    local sex = "man"
    local level = params.rank_lv

    -- 添加头像 设置头像
    local Panel_leading_head = ccui.Helper:seekWidgetByName(root, "Panel_leading_head")
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
        sex = params.rank_sex
        if tonumber(params.rank_sex) == 2 then
            sex = 6
        end
        Panel_leading_head:setBackGroundImage("images/ui/home/head_"..sex..".png")
    else
        Panel_leading_head:setBackGroundImage("images/ui/home/home_head_bg_" .. sex ..".png")
    end
    -- 添加头像 设置等级
    local Text_lv = ccui.Helper:seekWidgetByName(root, "Text_lv")
    Text_lv:setString(tostring(level))
end

function PlayerHeadCell:onInit(params)
    -- 绘图初始化
    local csbItem = csb.createNode(config_csb.cells.player_head_info)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)

    if PlayerHeadCell.__size == nil then
        PlayerHeadCell.__size = root:getContentSize()
    end

    self:setContentSize(PlayerHeadCell.__size)
    self:onUpdateDraw(params)
end

function PlayerHeadCell:init(params)
    -- 参数赋值
    self:onInit(params)
    return self
end

function PlayerHeadCell:onExit()

end