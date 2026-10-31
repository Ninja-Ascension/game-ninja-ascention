--------------------------------------------------------------------------------------------------------------
--  科技研究cell
--------------------------------------------------------------------------------------------------------------
BuildUpScientificClassifyCell = class("BuildUpScientificClassifyCellClass", Window)
BuildUpScientificClassifyCell.__size = nil
BuildUpScientificClassifyCell.__scroll_size = nil
BuildUpScientificClassifyCell.__image_size = nil

-- 创建cell
local build_up_scientific_classify_cell_create_terminal = {
    _name = "build_up_scientific_classify_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = BuildUpScientificClassifyCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(build_up_scientific_classify_cell_create_terminal)
state_machine.init()

function BuildUpScientificClassifyCell:ctor()
    self.super:ctor()
    self.roots = {}
    
    -- 定义变量
    self._index = 0
    self.m_times = 0
    
    -- 初始化状态机
    local function init_build_up_scientific_classify_cell_terminal()

    end 
    init_build_up_scientific_classify_cell_terminal()

end

-- 刷新
function BuildUpScientificClassifyCell:updateDraw()
    local root = self.roots[1]
    local Text_head_type = ccui.Helper:seekWidgetByName(root,"Text_head_type")
    Text_head_type:setString(tipStringInfo_build_up_scientific[self._index])

    local ScrollView_head_icon = ccui.Helper:seekWidgetByName(root,"ScrollView_head_icon")
    local Image_head_type_list_box = ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box")
    ScrollView_head_icon:removeAllChildren(true)

    local result = {}
    local cell_tables = {}
 
    for k, v in pairs(_ED.base_barracks_info) do
        local ntype = dms.int(dms["teach_escalate_param"], v.id, teach_escalate_param.ntype)
        if ntype == self._index then
            local barrack_info = _ED.barracks_info[""..k]
            if barrack_info ~= nil then     -- 已解锁
                v.is_open = true
            else                                        -- 未解锁
                v.is_open = false
            end
            table.insert(result, v)
        end
    end
    function sortByOrder(a, b)
        return a.order < b.order
    end
    table.sort(result, sortByOrder)

    --计算科技飙升活动加层
    if _ED.activity_info["85"] ~= nil then
        local timesData = zstring.split(_ED.activity_info["85"].activity_add_state, ",")
        self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    else
        self.m_times = 0
    end

    for k, v in pairs(result) do
        local cell = nil
        if v.is_open == true then
            cell = state_machine.excute("build_up_scientific_cell_create", 0, {k, v, _ED.barracks_info[""..v.id], true,{},self.m_times})
        else
            cell = state_machine.excute("build_up_scientific_rock_cell_create", 0, {k, v})
        end
        ScrollView_head_icon:addChild(cell)
        table.insert(cell_tables, cell)
        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
    end

    local total_col = 4
    local count = #cell_tables
    if count > 0 then
        local cell_height = cell_size.height + 5
        local size = cc.size(BuildUpScientificClassifyCell.__scroll_size.width, BuildUpScientificClassifyCell.__scroll_size.height)
        local height = cell_height * math.ceil(count / total_col)
        local width = size.width / total_col
        local add_height = height - size.height
        if add_height > 0 then
            size.height = height

            ScrollView_head_icon:setContentSize(cc.size(BuildUpScientificClassifyCell.__scroll_size.width, BuildUpScientificClassifyCell.__scroll_size.height + add_height))
            Image_head_type_list_box:setContentSize(cc.size(BuildUpScientificClassifyCell.__image_size.width, BuildUpScientificClassifyCell.__image_size.height + add_height))
            self:setContentSize(cc.size(BuildUpScientificClassifyCell.__size.width, BuildUpScientificClassifyCell.__size.height + add_height))
            root:setPositionY(BuildUpScientificClassifyCell.__size.height + add_height)
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

function BuildUpScientificClassifyCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.player.player_fight_classify_cell, "root") 
    table.insert(self.roots, root)
    self:addChild(root)

    if BuildUpScientificClassifyCell.__size == nil then
        BuildUpScientificClassifyCell.__size = root:getContentSize()
    end
    local ScrollView_head_icon = ccui.Helper:seekWidgetByName(root,"ScrollView_head_icon")
    local Image_head_type_list_box = ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box")
    if BuildUpScientificClassifyCell.__scroll_size == nil then
        BuildUpScientificClassifyCell.__scroll_size = ScrollView_head_icon:getContentSize()
    end
    if BuildUpScientificClassifyCell.__image_size == nil then
        BuildUpScientificClassifyCell.__image_size = Image_head_type_list_box:getContentSize()
    end
    root:setContentSize(BuildUpScientificClassifyCell.__size)
    root:setPositionY(BuildUpScientificClassifyCell.__size.height)
    ScrollView_head_icon:setContentSize(BuildUpScientificClassifyCell.__scroll_size)
    ScrollView_head_icon:setInnerContainerSize(BuildUpScientificClassifyCell.__scroll_size)
    Image_head_type_list_box:setContentSize(BuildUpScientificClassifyCell.__image_size)

    self:setAnchorPoint(cc.p(0, 0))
    self:setContentSize(BuildUpScientificClassifyCell.__size)

    self:updateDraw()
end

function BuildUpScientificClassifyCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function BuildUpScientificClassifyCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ScrollView_head_icon = ccui.Helper:seekWidgetByName(root,"ScrollView_head_icon")
    local Text_head_type = ccui.Helper:seekWidgetByName(root,"Text_head_type")
    local Image_head_type_list_box = ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box")
    if ScrollView_head_icon ~= nil then
        ScrollView_head_icon:removeAllChildren(true)
        Text_head_type:setString("")

        root:setContentSize(BuildUpScientificClassifyCell.__size)
        root:setPositionY(BuildUpScientificClassifyCell.__size.height)
        ScrollView_head_icon:setContentSize(BuildUpScientificClassifyCell.__scroll_size)
        ScrollView_head_icon:setInnerContainerSize(BuildUpScientificClassifyCell.__scroll_size)
        Image_head_type_list_box:setContentSize(BuildUpScientificClassifyCell.__image_size)
    end
end

function BuildUpScientificClassifyCell:reload()
    -- local root = self.roots[1]
    -- if root ~= nil then
    --     return
    -- end
    -- self:onInit()
end

function BuildUpScientificClassifyCell:unload()
    -- local root = self.roots[1]
    -- if root == nil then
    --     return
    -- end
    -- self:clearUIInfo()
    -- cacher.freeRef(config_csb.cells.player.player_fight_classify_cell, root)
    -- root:removeFromParent(false)
    -- self.roots = {}
end

function BuildUpScientificClassifyCell:init(params)
    self._index = params[1]
    self:onInit()
    -- self:setContentSize(BuildUpScientificClassifyCell.__size)
    return self
end

function BuildUpScientificClassifyCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.player.player_fight_classify_cell, self.roots[1])
end