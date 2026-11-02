----------------------------------------------------------------------------------------------------
-- 敌军来袭-攻击排行cell
-------------------------------------------------------------------------------------------------------
EnemyStrikeFightRankCell = class("EnemyStrikeFightRankCellClass", Window)
EnemyStrikeFightRankCell.__size = nil

local enemy_strike_fight_rank_create_cell_terminal = {
    _name = "enemy_strike_fight_rank_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = EnemyStrikeFightRankCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(enemy_strike_fight_rank_create_cell_terminal)
state_machine.init()

function EnemyStrikeFightRankCell:ctor()
    self.super:ctor()
	self.roots = {}

	self._index = 0
    self._info = nil
end

function EnemyStrikeFightRankCell:onUpdateDraw()
	local root = self.roots[1]
    local Text_enemy_rank_name = ccui.Helper:seekWidgetByName(root, "Text_enemy_rank_name")
    local Text_enemy_rank_infor = ccui.Helper:seekWidgetByName(root, "Text_enemy_rank_infor")
    Text_enemy_rank_name:setString(""..self._index.."."..self._info.user_name)

    if self._from_type == 1 then
        Text_enemy_rank_infor:setString(""..exChangeNumToString(self._info.total_hurt))
    else
        Text_enemy_rank_infor:setString(""..self._info.total_times)
    end

    if tonumber(self._info.user_id) == tonumber(_ED.user_info.user_id) then
        Text_enemy_rank_name:setColor(cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3]))
        Text_enemy_rank_infor:setColor(cc.c3b(color_Type[7][1], color_Type[7][2], color_Type[7][3]))
    else
        Text_enemy_rank_name:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        Text_enemy_rank_infor:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end
end

function EnemyStrikeFightRankCell:onEnterTransitionFinish()

end

function EnemyStrikeFightRankCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.campaign.enemy_strike_tab_2_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if EnemyStrikeFightRankCell.__size == nil then
		EnemyStrikeFightRankCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function EnemyStrikeFightRankCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.campaign.enemy_strike_tab_2_cell, root)
end

function EnemyStrikeFightRankCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function EnemyStrikeFightRankCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_enemy_rank_name = ccui.Helper:seekWidgetByName(root, "Text_enemy_rank_name")
    local Text_enemy_rank_infor = ccui.Helper:seekWidgetByName(root, "Text_enemy_rank_infor")
    if Text_enemy_rank_name ~= nil then
        Text_enemy_rank_name:setString("")
        Text_enemy_rank_infor:setString("")
    end
end

function EnemyStrikeFightRankCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.campaign.enemy_strike_tab_2_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function EnemyStrikeFightRankCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._from_type = params[3]
    -- if self._index <= 6 then
        self:onInit()
    -- end
	self:setContentSize(EnemyStrikeFightRankCell.__size)
end

