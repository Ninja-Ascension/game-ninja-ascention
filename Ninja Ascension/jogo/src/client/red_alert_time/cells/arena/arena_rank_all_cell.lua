-----------------------------
--战地争霸全部排行榜的列表的cell
-----------------------------
ArenaRankAllCell = class("ArenaRankAllCellClass", Window)
ArenaRankAllCell.__size = nil

local arena_rank_all_cell_terminal = {
    _name = "arena_rank_all_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArenaRankAllCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_rank_all_cell_terminal)
state_machine.init()

function ArenaRankAllCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._info = nil
	
	-- app.load("client.red_alert_time.cells.worldMap.player_head_icon")
	
 	local function init_arena_rank_all_cell_terminal()
		
        state_machine.init()
    end
	init_arena_rank_all_cell_terminal()        	
end


function ArenaRankAllCell:onUpdateDraw()
	local root = self.roots[1]
	--战力
	local Text_player_fight_n = ccui.Helper:seekWidgetByName(root, "Text_player_fight_n")
	Text_player_fight_n:setString(exChangeNumToString(tonumber(self._info.user_fight)))
	
	--等级
	local Text_player_lv_n = ccui.Helper:seekWidgetByName(root, "Text_player_lv_n") 
	Text_player_lv_n:setString(string.format(red_alert_all_str[13], ""..self._info.user_level))
	
	--名称
	local Text_player_name_n = ccui.Helper:seekWidgetByName(root, "Text_player_name_n") 
	local colos = nil
	if tonumber(self._info.user_rank) < 4 then
		colos = cc.c3b(arena_color_Type[tonumber(self._info.user_rank)+2][1], arena_color_Type[tonumber(self._info.user_rank)+2][2], arena_color_Type[tonumber(self._info.user_rank)+2][3])
	else
		colos = cc.c3b(arena_color_Type[6][1], arena_color_Type[6][2], arena_color_Type[6][3])
	end
	Text_player_name_n:setColor(colos)
	Text_player_name_n:setString(self._info.user_name)
	
	--排名
	local Text_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rank_n")  
	if tonumber(self._info.user_rank) < 4 then
		Text_rank_n:setString("")
	else
		Text_rank_n:setString(self._info.user_rank)
	end
	
	--前三的牌子
	local Panel_rank_top_icon = ccui.Helper:seekWidgetByName(root, "Panel_rank_top_icon")  
	Panel_rank_top_icon:removeBackGroundImage()
	if tonumber(self._info.user_rank) < 4 then
		Panel_rank_top_icon:setBackGroundImage(string.format("images/ui/share/rank_icon_%s.png", self._info.user_rank))
	end
	
end


function ArenaRankAllCell:onEnterTransitionFinish()

end

function ArenaRankAllCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.arena.arena_rank_cell_1, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if ArenaRankAllCell.__size == nil then
		ArenaRankAllCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function ArenaRankAllCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.arena.arena_rank_cell_1, root)
end

function ArenaRankAllCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ArenaRankAllCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.arena.arena_rank_cell_1, root)
	root:removeFromParent(false)
	self.roots = {}
end

function ArenaRankAllCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_rank_top_icon = ccui.Helper:seekWidgetByName(root, "Panel_rank_top_icon")  
    local Text_player_fight_n = ccui.Helper:seekWidgetByName(root, "Text_player_fight_n")
    local Text_player_lv_n = ccui.Helper:seekWidgetByName(root, "Text_player_lv_n") 
    local Text_player_name_n = ccui.Helper:seekWidgetByName(root, "Text_player_name_n")
    local Text_rank_n = ccui.Helper:seekWidgetByName(root, "Text_rank_n")  

    if Panel_rank_top_icon ~= nil then
        Panel_rank_top_icon:removeBackGroundImage()
        Text_player_fight_n:setString("")
        Text_player_lv_n:setString("")
        Text_player_name_n:setString("")
        Text_rank_n:setString("")
    end
end

function ArenaRankAllCell:init(params)
	self._info = params[1]
    self._index = params[2]
	if self._index ~= nil and self._index <= 14 then
        self:onInit()
    end
	self:setContentSize(ArenaRankAllCell.__size)
    return self
end

