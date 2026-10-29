-----------------------------
--战地争霸的排行的幸运排行列表的cell
-----------------------------
ArenaRankLuckyCell = class("ArenaRankLuckyCellClass", Window)
ArenaRankLuckyCell.__size = nil

local arena_rank_lucky_cell_terminal = {
    _name = "arena_rank_lucky_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArenaRankLuckyCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_rank_lucky_cell_terminal)
state_machine.init()

function ArenaRankLuckyCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._info = nil
	    	
end


function ArenaRankLuckyCell:onUpdateDraw()
	local root = self.roots[1]
	--排名
	local Text_lucky_rank_now_n = ccui.Helper:seekWidgetByName(root, "Text_lucky_rank_now_n")
	Text_lucky_rank_now_n:setString(self._info.this_period_lucky_rank)
	
	--奖励
	local Text_lucky_reward_now_n = ccui.Helper:seekWidgetByName(root, "Text_lucky_reward_now_n")
	Text_lucky_reward_now_n:removeAllChildren(true)
	local fontSize = Text_lucky_reward_now_n:getFontSize()
	local reword = dms.string(dms["arena_lucky"], tonumber(self._info.lucky_mould_id), arena_lucky.lucky_reward)
	local datas = zstring.split(reword,",")
	local prop_name = nil
	local quality = 0
	if tonumber(datas[2]) == 13 then     -- 坦克
		local tank_data = dms.element(dms["ship_mould"], datas[1])
		prop_name = dms.atos(tank_data, ship_mould.captain_name)
		quality = dms.atoi(tank_data, ship_mould.ship_type)
	elseif tonumber(datas[2]) == 6 then  -- 道具
		local prop_data = dms.element(dms["prop_mould"], datas[1])
		prop_name = dms.atos(prop_data, prop_mould.prop_name)
		quality = dms.atoi(prop_data, prop_mould.prop_quality)
	elseif tonumber(datas[2]) == 7 then     -- 配件
		local equipment_data = dms.element(dms["equipment_mould"], datas[1])
		prop_name = dms.atos(equipment_data, equipment_mould.equipment_name)
		quality = dms.atos(equipment_data, equipment_mould.grow_level)
	else
		local prop_data = dms.element(dms["prop_mould"], datas[1])
		prop_name = dms.atos(prop_data, prop_mould.prop_name)
		quality = dms.atoi(prop_data, prop_mould.prop_quality)
	end
	local _richText1 = ccui.RichText:create()
	_richText1:ignoreContentAdaptWithSize(false)
	local color = cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3])
	local color1 = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
	local re1 =ccui.RichElementText:create(1, color,255, prop_name, config_res.font.font_name,fontSize)
	_richText1:pushBackElement(re1)
	local re2 =ccui.RichElementText:create(1, color1,255, "*"..datas[3], config_res.font.font_name,fontSize)
	_richText1:pushBackElement(re2)
	_richText1:setAnchorPoint(0,0.5)
	_richText1:setContentSize(cc.size(Text_lucky_reward_now_n:getContentSize().width,Text_lucky_reward_now_n:getContentSize().height))
	_richText1:setPosition(cc.p(-35,Text_lucky_reward_now_n:getContentSize().height/2))
	Text_lucky_reward_now_n:addChild(_richText1)
end


function ArenaRankLuckyCell:onEnterTransitionFinish()

end

function ArenaRankLuckyCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.arena.arena_rank_cell_2, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
	if ArenaRankLuckyCell.__size == nil then
		ArenaRankLuckyCell.__size = root:getContentSize()
	end
	
	self:onUpdateDraw()
end

function ArenaRankLuckyCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.arena.arena_rank_cell_2, root)
end

function ArenaRankLuckyCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ArenaRankLuckyCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.arena.arena_rank_cell_2, root)
	root:removeFromParent(false)
	self.roots = {}
end

function ArenaRankLuckyCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_lucky_rank_now_n = ccui.Helper:seekWidgetByName(root, "Text_lucky_rank_now_n")
    local Text_lucky_reward_now_n = ccui.Helper:seekWidgetByName(root, "Text_lucky_reward_now_n")

    if Text_lucky_rank_now_n ~= nil then
        Text_lucky_rank_now_n:setString("")
        Text_lucky_reward_now_n:setString("")
        Text_lucky_reward_now_n:removeAllChildren(true)
    end
end

function ArenaRankLuckyCell:init(params)
	self._info = params[1]
	self._index = params[2]
    if self._index ~= nil and self._index <= 12 then
        self:onInit()
    end
	self:setContentSize(ArenaRankLuckyCell.__size)
    return self
end

