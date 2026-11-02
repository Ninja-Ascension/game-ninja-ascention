--------------------------------------------------------------------------------------------------------------
--  战力提升cell
--------------------------------------------------------------------------------------------------------------
PlayerFightClassifyCell = class("PlayerFightClassifyCellClass", Window)
PlayerFightClassifyCell.__size = nil
PlayerFightClassifyCell.__scroll_size = nil
PlayerFightClassifyCell.__image_size = nil

-- 创建cell
local player_fight_classify_cell_create_terminal = {
    _name = "player_fight_classify_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = PlayerFightClassifyCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(player_fight_classify_cell_create_terminal)
state_machine.init()

function PlayerFightClassifyCell:ctor()
    self.super:ctor()
    self.roots = {}
    
    -- 定义变量
    self._index = 0
    self._info = nil
    
    -- 加载lua文件
    
    -- 初始化状态机
    local function init_player_fight_classify_cell_terminal()

    end 
    init_player_fight_classify_cell_terminal()

end

-- 刷新
function PlayerFightClassifyCell:updateDraw()
    local root = self.roots[1]
    local Text_head_type = ccui.Helper:seekWidgetByName(root,"Text_head_type")
    Text_head_type:setString(tipStringInfo_strategy_combat[self._index])

    local ScrollView_head_icon = ccui.Helper:seekWidgetByName(root,"ScrollView_head_icon")
    local Image_head_type_list_box = ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box")
    ScrollView_head_icon:removeAllChildren(true)

    local result = {}
    for k, v in pairs(_ED.strategy_combat_info) do
        if v.ntype == self._index then
            table.insert(result, v)
        end
    end
    function sortByIndex(a, b)
        return a.index < b.index
    end
    table.sort(result, sortByIndex)

    local cell_tables = {}
    local cell_size = nil
    local total_col = 4
    for k, v in pairs(result) do
        local cell = state_machine.excute("player_fight_create_cell", 0, {v.index, v})
        ScrollView_head_icon:addChild(cell)
        table.insert(cell_tables, cell)
        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
    end

    local count = #cell_tables
    if count > 0 then
        local cell_height = cell_size.height + 5
        local size = cc.size(PlayerFightClassifyCell.__scroll_size.width, PlayerFightClassifyCell.__scroll_size.height)
        local height = cell_height * math.ceil(count / total_col)
        local width = size.width / total_col
        local add_height = height - size.height
        if add_height > 0 then
            size.height = height

            ScrollView_head_icon:setContentSize(cc.size(PlayerFightClassifyCell.__scroll_size.width, PlayerFightClassifyCell.__scroll_size.height + add_height))
            Image_head_type_list_box:setContentSize(cc.size(PlayerFightClassifyCell.__image_size.width, PlayerFightClassifyCell.__image_size.height + add_height))
            self:setContentSize(cc.size(PlayerFightClassifyCell.__size.width, PlayerFightClassifyCell.__size.height + add_height))
            root:setPositionY(PlayerFightClassifyCell.__size.height + add_height)
        end
        ScrollView_head_icon:setInnerContainerSize(ScrollView_head_icon:getContentSize())

        for k, v in pairs(cell_tables) do
            local row = math.floor((k - 1) % total_col) + 1
            local col = math.floor((k - 1) / total_col) + 1
            local posX = size.width * row / total_col - width / 2 - cell_size.width / 2
            local posY = size.height - cell_height * col
            v:setPosition(posX, posY)
        end
    end
end 

function PlayerFightClassifyCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.player.player_fight_classify_cell, "root") 
    table.insert(self.roots, root)
    self:addChild(root)

    if PlayerFightClassifyCell.__size == nil then
        PlayerFightClassifyCell.__size = root:getContentSize()
    end
    local ScrollView_head_icon = ccui.Helper:seekWidgetByName(root,"ScrollView_head_icon")
    local Image_head_type_list_box = ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box")
    if PlayerFightClassifyCell.__scroll_size == nil then
        PlayerFightClassifyCell.__scroll_size = ScrollView_head_icon:getContentSize()
    end
    if PlayerFightClassifyCell.__image_size == nil then
        PlayerFightClassifyCell.__image_size = Image_head_type_list_box:getContentSize()
    end
    root:setContentSize(PlayerFightClassifyCell.__size)
    root:setPositionY(PlayerFightClassifyCell.__size.height)
    ScrollView_head_icon:setContentSize(PlayerFightClassifyCell.__scroll_size)
    ScrollView_head_icon:setInnerContainerSize(PlayerFightClassifyCell.__scroll_size)
    Image_head_type_list_box:setContentSize(PlayerFightClassifyCell.__image_size)

    self:setAnchorPoint(cc.p(0, 0))
    self:setContentSize(PlayerFightClassifyCell.__size)

    self:updateDraw()
end

function PlayerFightClassifyCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function PlayerFightClassifyCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ScrollView_head_icon = ccui.Helper:seekWidgetByName(root,"ScrollView_head_icon")
    local Text_head_type = ccui.Helper:seekWidgetByName(root,"Text_head_type")
    local Image_head_type_list_box = ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box")
    if ScrollView_head_icon ~= nil then
        ScrollView_head_icon:removeAllChildren(true)
        Text_head_type:setString("")

        root:setContentSize(PlayerFightClassifyCell.__size)
        root:setPositionY(PlayerFightClassifyCell.__size.height)
        ScrollView_head_icon:setContentSize(PlayerFightClassifyCell.__scroll_size)
        ScrollView_head_icon:setInnerContainerSize(PlayerFightClassifyCell.__scroll_size)
        Image_head_type_list_box:setContentSize(PlayerFightClassifyCell.__image_size)
    end
end

function PlayerFightClassifyCell:reload()
    -- local root = self.roots[1]
    -- if root ~= nil then
    --     return
    -- end
    -- self:onInit()
end

function PlayerFightClassifyCell:unload()
    -- local root = self.roots[1]
    -- if root == nil then
    --     return
    -- end
    -- self:clearUIInfo()
    -- cacher.freeRef(config_csb.cells.player.player_fight_classify_cell, root)
    -- root:removeFromParent(false)
    -- self.roots = {}
end

function PlayerFightClassifyCell:init(params)
    self._index = params[1]
    self:onInit()
    -- self:setContentSize(PlayerFightClassifyCell.__size)
    return self
end

function PlayerFightClassifyCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.player.player_fight_classify_cell, self.roots[1])
end