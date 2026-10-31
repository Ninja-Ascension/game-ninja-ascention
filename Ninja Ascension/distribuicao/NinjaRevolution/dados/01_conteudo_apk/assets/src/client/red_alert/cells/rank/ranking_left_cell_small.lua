----------------------------------------------------------------------------------------------------
-- 说明：排行榜
-------------------------------------------------------------------------------------------------------
RankingLeftCellSmall = class("RankingLeftCellBigClass", Window)
RankingLeftCellSmall.__size = nil

local ranking_left_small_create_cell_terminal = {
    _name = "ranking_left_small_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = RankingLeftCellSmall:new()
        local dec = params[1]
        local index = params[2]
        cell:init(dec,index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(ranking_left_small_create_cell_terminal)
state_machine.init()

function RankingLeftCellSmall:ctor()
    self.super:ctor()
    self.roots = {}     

    -- var
    -- 排行索引 1 战斗力排行 2皇城排行 3 无双试炼 4 家族排行 5 6 7  阵营
    self._index = index
    --描述
    self._dec = dec
    --是否已经选中
    self._select = false
    local function init_ranking_left_small_cell_terminal()
        
        local ranking_left_small_cell_click_terminal = {
            _name = "ranking_left_small_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                --取消其他选择
                state_machine.excute("ranking_set_left_small_listview_unselect",0,"")
                --设置当前点击为选择
                local cell = params._datas.cell
                cell._select = true
                cell:setSelected()
                --切换列表
                local index = cell._index
                state_machine.excute("ranking_change_listview_page",0,index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(ranking_left_small_cell_click_terminal)       
        state_machine.init()
    end
    init_ranking_left_small_cell_terminal()           
end

function RankingLeftCellSmall:onUpdateDraw()
    local root = self.roots[1]
    local Text_ranking_name = ccui.Helper:seekWidgetByName(root,"Text_ranking_name")
    Text_ranking_name:setString(self._dec)
end

function RankingLeftCellSmall:setSelected()
    local root = self.roots[1]
    local Image_ranking_left_cell_choose = ccui.Helper:seekWidgetByName(root,"Image_ranking_left_cell_choose")

    if Image_ranking_left_cell_choose ~= nil then
        Image_ranking_left_cell_choose:setVisible(self._select)
    end
end

function RankingLeftCellSmall:onEnterTransitionFinish()

end

function RankingLeftCellSmall:onInit()

    local root = cacher.createUIRef(config_csb.cells.rank.ranking_left_cell_small, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if RankingLeftCellSmall.__size == nil then
        RankingLeftCellSmall.__size = root:getContentSize()
    end

    --点击响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_ranking_left_cell_normal"), nil, 
    {
        terminal_name = "ranking_left_small_cell_click", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95, 
    },
    nil,3)
    
    self:onUpdateDraw()
end

function RankingLeftCellSmall:onExit()
    cacher.freeRef(config_csb.cells.rank.ranking_left_cell_small, self.roots[1])

end

function RankingLeftCellSmall:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RankingLeftCellSmall:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.rank.ranking_left_cell_small, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RankingLeftCellSmall:init(dec,index) 
    self._dec = dec
    self._index = index
    self:onInit()
    self:setContentSize(RankingLeftCellSmall.__size)
end

