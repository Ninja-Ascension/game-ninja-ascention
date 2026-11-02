----------------------------------------------------------------------------------------------------
-- 说明：排行榜
-------------------------------------------------------------------------------------------------------
RankingLeftCellBig = class("RankingLeftCellBigClass", Window)
RankingLeftCellBig.__size = nil

local ranking_left_big_create_cell_terminal = {
    _name = "ranking_left_big_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = RankingLeftCellBig:new()
        local index = params[1]
        local dec = params[2]
        cell:init(index,dec)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(ranking_left_big_create_cell_terminal)
state_machine.init()

function RankingLeftCellBig:ctor()
    self.super:ctor()
	self.roots = {}		

	-- var
	-- 排行索引 1：战力，2：等级，3：侠客行，4：华山论剑，5：帮派
	self._index = index
	--描述
	self._dec = dec
	--是否已经选中
	self._select = false
 	local function init_ranking_left_big_cell_terminal()
        
        local ranking_left_big_cell_click_terminal = {
            _name = "ranking_left_big_cell_click",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	--取消其他选择
            	local cell = params._datas.cell
                if cell._index == 1 then
                    if funOpenDrawTip(116) == true then
                        return
                    end 
                elseif cell._index == 3 then
                    if funOpenDrawTip(118) == true then
                        return
                    end 
                elseif cell._index == 4 then
                    if funOpenDrawTip(117) == true then
                        return
                    end 
                elseif cell._index == 5 then
                    if funOpenDrawTip(119) == true then
                        return
                    end                     
                end
                state_machine.excute("ranking_set_left_big_listview_unselect",0,"")
                --设置当前点击为选择
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
        state_machine.add(ranking_left_big_cell_click_terminal)       
        state_machine.init()
    end
	init_ranking_left_big_cell_terminal()        	
end

function RankingLeftCellBig:onUpdateDraw()
	local root = self.roots[1]
	local Text_ranking_name = ccui.Helper:seekWidgetByName(root,"Text_ranking_name")
	Text_ranking_name:setString(self._dec)
    Text_ranking_name:setColor(tipStringInfo_rank_color_Type[5])
    ccui.Helper:seekWidgetByName(root,"Image_ranking_left_light"):setVisible(false)
end

function RankingLeftCellBig:setSelected()
	local root = self.roots[1]
	local Image_ranking_left_light = ccui.Helper:seekWidgetByName(root,"Image_ranking_left_light")
    local Text_ranking_name = ccui.Helper:seekWidgetByName(root,"Text_ranking_name")

    if self._select == true then
        Image_ranking_left_light:setVisible(true)
        Text_ranking_name:setColor(tipStringInfo_rank_color_Type[6])
    else
        Image_ranking_left_light:setVisible(false)
        Text_ranking_name:setColor(tipStringInfo_rank_color_Type[5])
    end
end

function RankingLeftCellBig:onEnterTransitionFinish()

end

function RankingLeftCellBig:onInit()

	local root = cacher.createUIRef(config_csb.cells.rank.ranking_left_cell_big, "root")
 	table.insert(self.roots, root)
 	self:addChild(root) 
	
	if RankingLeftCellBig.__size == nil then
		RankingLeftCellBig.__size = root:getContentSize()
	end

 	--点击响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_ranking_left_cell"), nil, 
    {
        terminal_name = "ranking_left_big_cell_click", 
        terminal_state = 0,
        touch_scale = true,
        cell = self,
        touch_scale_xy = 0.95, 
    },
    nil,3)
	
	self:onUpdateDraw()
end

function RankingLeftCellBig:onExit()
	cacher.freeRef(config_csb.cells.rank.ranking_left_cell_big, self.roots[1])

end

function RankingLeftCellBig:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RankingLeftCellBig:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef(config_csb.cells.rank.ranking_left_cell_big, root)
	root:removeFromParent(false)
	self.roots = {}
end

function RankingLeftCellBig:init(index,dec) 
	self._index = index
	self._dec = dec
	self:onInit()
	self:setContentSize(RankingLeftCellBig.__size)
end

