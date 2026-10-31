--------------------------------------------------------------------------------------------------------------
--  排汗榜列表(蜀魏吴)
--------------------------------------------------------------------------------------------------------------
RankingSListview = class("RankingSListviewClass", Window)

local ranking_s_create_listview_terminal = {
    _name = "ranking_s_create_listview",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local listview = RankingSListview:new()
        listview:init()
        listview:registerOnNodeEvent(listview)
        return listview
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(ranking_s_create_listview_terminal)
state_machine.init()

function RankingSListview:ctor()
	self.super:ctor()
	self.roots = {}
    
    --var 
    -- 高度
    self._self_height = nil
    -- cell_table
    self._small_cells = {}
	-- Initialize ranking_s_listview state machine.
    local function init_ranking_s_listview_terminal()
        -- 展开
        local ranking_s_listview_scale_open_terminal = {
            _name = "ranking_s_listview_scale_open",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:scaleOpen()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        
        --  收起
        local ranking_s_listview_scale_close_terminal = {
            _name = "ranking_s_listview_scale_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:scaleClose()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        -- 左侧小cell取消所有选中
        local ranking_set_left_small_listview_unselect_terminal = {
            _name = "ranking_set_left_small_listview_unselect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setLeftSmallListviewUnselect()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(ranking_s_listview_scale_open_terminal)
        state_machine.add(ranking_s_listview_scale_close_terminal)
        state_machine.add(ranking_set_left_small_listview_unselect_terminal)
        state_machine.init()
    end
    
    -- call func ranking_s_listview create state machine.
    init_ranking_s_listview_terminal()

end

function RankingSListview:setLeftSmallListviewUnselect()
    for i,small_cell in pairs(self._small_cells) do
        small_cell._select = false
        small_cell:setSelected()
    end
end

function RankingSListview:scaleOpen()
    local root = self.roots[1]
    local ListView_s = ccui.Helper:seekWidgetByName(root,"ListView_s")
    -- self:setContentSize(cc.size(self:getContentSize().width,self._self_height))
    -- ListView_s:setContentSize(self:getContentSize())
    
    state_machine.excute("ranking_change_listview_refrush",0,"")
    state_machine.excute("ranking_left_small_cell_click",0,{_datas = { cell = self._small_cells[1]}})
end

function RankingSListview:scaleClose()
    local root = self.roots[1]
    local ListView_s = ccui.Helper:seekWidgetByName(root,"ListView_s")
    self:setContentSize(cc.size(self:getContentSize().width,0))
    ListView_s:setContentSize(self:getContentSize())    
    state_machine.excute("ranking_change_listview_refrush",0,"")
end

function RankingSListview:updateDraw()
    local root = self.roots[1]
    local ListView_s = ccui.Helper:seekWidgetByName(root,"ListView_s")
    ListView_s:setContentSize(self:getContentSize())

    for i,v in pairs(red_alert_hero_camp) do
        local cell = state_machine.excute("ranking_left_small_create_cell",0,{v,i+4})
        ListView_s:addChild(cell)
        table.insert(self._small_cells,cell)
        self._self_height = cell:getContentSize().height * 3
    end
end

function RankingSListview:onInit()
    local csbItem = csb.createNode(config_csb.rank.ranking_s_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
    self:updateDraw()
    self:setContentSize(cc.size(root:getContentSize().width,0))
end

function RankingSListview:onEnterTransitionFinish()
    
end

function RankingSListview:init()
    self:onInit()
    return self
end

function RankingSListview:onExit()
    state_machine.remove("ranking_s_listview_scale_open")
    state_machine.remove("ranking_s_listview_scale_close")
    state_machine.remove("ranking_set_left_small_listview_unselect")
end