-----------------------------
--战地争霸的奖励的排行排行列表的cell
-----------------------------
ArenaRewardRankCell = class("ArenaRewardRankCellClass", Window)
ArenaRewardRankCell.__size = nil

local arena_reward_rank_cell_terminal = {
    _name = "arena_reward_rank_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArenaRewardRankCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_reward_rank_cell_terminal)
state_machine.init()

function ArenaRewardRankCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._index = 0
	    	
end


function ArenaRewardRankCell:onUpdateDraw()
	local root = self.roots[1]
	local ListView_integral_reward = ccui.Helper:seekWidgetByName(root, "ListView_integral_reward")
	ListView_integral_reward:removeAllItems()
	local rewarld = zstring.split(dms.string(dms["arena_reward_param"], self._index, arena_reward_param.arena_every_reward), "|")
	for i=1,#rewarld do
		local info = zstring.split(rewarld[i], ",")
		if tonumber(info[1]) == -1 then
			info[1] = resource_prop_id[tonumber(info[2])]
			info[2] = 1
		end
		local prop_type = tonumber(info[2])
		local show_type = 6
		if tonumber(info[2]) == 13 then --坦克
			prop_type = 3
		elseif tonumber(info[2]) == 6 then --道具	
			prop_type = 1
		elseif tonumber(info[2]) == 7 then --配件	
			prop_type = 7
		else
			prop_type = 1
		end
		local cell = state_machine.excute("props_icon_create_cell",0,{show_type, 1, tonumber(info[1]), prop_type, tonumber(info[3])})
		ListView_integral_reward:addChild(cell)
	end
	ListView_integral_reward:requestRefreshView()
	local arena_order_begin = dms.int(dms["arena_reward_param"], self._index, arena_reward_param.arena_order_begin)
	local arena_order_end = dms.int(dms["arena_reward_param"], self._index, arena_reward_param.arena_order_end)
	--前3
	local Panel_integral_rank_top_icon = ccui.Helper:seekWidgetByName(root, "Panel_integral_rank_top_icon")
	Panel_integral_rank_top_icon:removeBackGroundImage()
	if arena_order_begin < 4 then
		Panel_integral_rank_top_icon:setBackGroundImage(string.format("images/ui/share/rank_icon_%s.png", arena_order_begin))
	end
	
	--3名之后
	local Text_integral_rank_n = ccui.Helper:seekWidgetByName(root, "Text_integral_rank_n")
	
	if arena_order_begin < 4 then
		Text_integral_rank_n:setString("")
	else
		if arena_order_begin == arena_order_end then
			Text_integral_rank_n:setString(arena_order_begin)
		else
			if arena_order_end == -1 then
				Text_integral_rank_n:setString(string.format(arena_tip_text[24],arena_order_begin))
			else
				Text_integral_rank_n:setString(arena_order_begin.."-"..arena_order_end)
			end
		end
	end
end


function ArenaRewardRankCell:onEnterTransitionFinish()

end

function ArenaRewardRankCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.arena.arena_reward_cell_2, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
	if ArenaRewardRankCell.__size == nil then
		ArenaRewardRankCell.__size = root:getContentSize()
	end
	
	self:onUpdateDraw()
end

function ArenaRewardRankCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.arena.arena_reward_cell_2, root)
end

function ArenaRewardRankCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ArenaRewardRankCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.arena.arena_reward_cell_2, root)
	root:removeFromParent(false)
	self.roots = {}
end

function ArenaRewardRankCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ListView_integral_reward = ccui.Helper:seekWidgetByName(root, "ListView_integral_reward")
    local Panel_integral_rank_top_icon = ccui.Helper:seekWidgetByName(root, "Panel_integral_rank_top_icon")
    local Text_integral_rank_n = ccui.Helper:seekWidgetByName(root, "Text_integral_rank_n")

    if ListView_integral_reward ~= nil then
        ListView_integral_reward:removeAllItems()
        Panel_integral_rank_top_icon:removeBackGroundImage()
        Text_integral_rank_n:setString("")
    end
end

function ArenaRewardRankCell:init(params)
	self._index = tonumber(params)
	if self._index ~= nil and self._index <= 6 then
        self:onInit()
    end
	self:setContentSize(ArenaRewardRankCell.__size)
    return self
end

