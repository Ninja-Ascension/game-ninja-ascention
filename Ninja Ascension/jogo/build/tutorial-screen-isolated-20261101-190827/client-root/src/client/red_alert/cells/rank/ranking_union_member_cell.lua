
RankingUnionMemberCell = class("RankingUnionMemberCellClass", Window)
RankingUnionMemberCell.__size = nil

local ranking_union_member_cell_terminal = {
    _name = "ranking_union_member_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = RankingUnionMemberCell:new()
        local index = params[1]
        local info_data = params[2]
        cell:init(info_data, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(ranking_union_member_cell_terminal)
state_machine.init()

function RankingUnionMemberCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._info_data = nil

 	local function init_ranking_right_cell_terminal()
        
    end
	init_ranking_right_cell_terminal()        	
end

function RankingUnionMemberCell:onUpdateDraw()
	local root = self.roots[1]
    
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
    Text_player_name:setString(self._info_data.user_name)

    local Text_fight = ccui.Helper:seekWidgetByName(root, "Text_fight")
    Text_fight:setString(self._info_data.user_fighting)

    local Text_job = ccui.Helper:seekWidgetByName(root, "Text_job")
    Text_job:setString("")
    
    local Panel_player_head = ccui.Helper:seekWidgetByName(root,"Panel_player_head") -- 用户头像
    Panel_player_head:removeAllChildren(true)
    local data = {
        user_sex = self._info_data.user_sex, 
        user_level = self._info_data.user_level,
        user_camp = self._info_data.union_camp,
    }
    Panel_player_head:addChild(state_machine.excute("user_head_icon_create", 0, {data}))
    
    if tonumber(self._info_data.user_post) == 1 then
        Text_job:setString(tipStringInfo_union_str[52])
        -- Text_job:setColor(cc.c3b(color_table[1], color_table[2], color_table[3]))
    elseif tonumber(self._info_data.user_post) == 2 then
        Text_job:setString(tipStringInfo_union_str[53])
    elseif tonumber(self._info_data.user_post) == 3 then
        Text_job:setString(tipStringInfo_union_str[54])
    end
end

function RankingUnionMemberCell:onEnterTransitionFinish()

end

function RankingUnionMemberCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.rank.ranking_legion_cell, "root")
 	table.insert(self.roots, root)
 	self:addChild(root) 
	
	if RankingUnionMemberCell.__size == nil then
		RankingUnionMemberCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function RankingUnionMemberCell:onExit()
    local Panel_player_head = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_player_head")
    if Panel_player_head ~= nil then
        Panel_ranking_player_icon:removeAllChildren(true)
    end
	cacher.freeRef(config_csb.cells.rank.ranking_legion_cell, self.roots[1])

end

function RankingUnionMemberCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RankingUnionMemberCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    local Panel_player_head = ccui.Helper:seekWidgetByName(root,"Panel_player_head")
    Panel_player_head:removeAllChildren(true)
	cacher.freeRef(config_csb.cells.rank.ranking_legion_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function RankingUnionMemberCell:init(info_data, index) 
	self._info_data = info_data
	if index ~= nil and index < 6 then
		self:onInit()
	end
	self:setContentSize(RankingUnionMemberCell.__size)
end

