----------------------------------------------------------------------------------------------------
-- 说明：排行榜
-------------------------------------------------------------------------------------------------------
RankingRightTopCell = class("RankingRightTopCellClass", Window)
RankingRightTopCell.__size = nil

local ranking_right_top_create_cell_terminal = {
    _name = "ranking_right_top_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local from_type = params[1]
        local info_data = params[2]
        local cell = RankingRightTopCell:new()
        cell:init(from_type, info_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(ranking_right_top_create_cell_terminal)
state_machine.init()

function RankingRightTopCell:ctor()
    self.super:ctor()
	self.roots = {}		

    --var
    -- 类型 1 2 3 战斗力排行 无双排行 家族排行
    self._from_type = nil

    self._info_data = nil

 	local function init_ranking_right_top_cell_terminal()
       
    end
	init_ranking_right_top_cell_terminal()        	
end

function RankingRightTopCell:onUpdateDraw()
	local root = self.roots[1]
    local Image_ranking_get_up = ccui.Helper:seekWidgetByName(root,"Image_ranking_get_up") -- 上升
    local Image_ranking_get_down = ccui.Helper:seekWidgetByName(root,"Image_ranking_get_down") --下降
    local Text_ranking_number = ccui.Helper:seekWidgetByName(root,"Text_ranking_number")  --排名变化
    local Panel_ranking_player_icon = ccui.Helper:seekWidgetByName(root,"Panel_ranking_player_icon")
    local BitmapFontLabel_rank = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_rank") -- 排名text
    local Panel_ranking_picture = ccui.Helper:seekWidgetByName(root,"Panel_ranking_picture") --  排名图片
    local Panel_camp = ccui.Helper:seekWidgetByName(root,"Panel_force") -- 阵型
    local Text_player_name = ccui.Helper:seekWidgetByName(root,"Text_player_name") -- 用户名
    local Text_fight = ccui.Helper:seekWidgetByName(root,"Text_fight") --  进度 战力
    local Text_fighting_number = ccui.Helper:seekWidgetByName(root,"Text_fighting_number") -- 进度 战力 值
    local Panel_rank_camp = ccui.Helper:seekWidgetByName(root,"Panel_rank_camp") -- 阵营旗帜
    local Image_3 = ccui.Helper:seekWidgetByName(root,"Image_3") --战力
    local Image_8 = ccui.Helper:seekWidgetByName(root,"Image_4") --进度   
    local Image_legion_t_1 = ccui.Helper:seekWidgetByName(root,"Image_legion_t_1") --贡献
    Image_ranking_get_up:setVisible(false)
    Image_ranking_get_down:setVisible(false)
    Text_ranking_number:setString("")
    Panel_ranking_player_icon:removeBackGroundImage()
    Panel_ranking_player_icon:removeAllChildren(true)
    BitmapFontLabel_rank:setString("")
    Panel_ranking_picture:removeBackGroundImage()
    Panel_camp:removeBackGroundImage()
    Panel_rank_camp:removeBackGroundImage()
    Text_player_name:setString("")
    Text_fight:setString("")
    Text_fighting_number:setString("")
    Image_3:setVisible(false)
    Image_8:setVisible(false)
    Image_legion_t_1:setVisible(false)
    local data = 
        {
            user_id = _ED.user_info.user_id,
            user_name = _ED.user_info.user_name,
            user_camp = _ED.user_info.user_force,
            user_rank = math.random(100),
            user_sex = _ED.user_info.user_gender,
            user_level = _ED.user_info.user_grade,
            user_fight = _ED.user_info.fighter_capacity,
            user_official = math.random(1,9),
        }
    if self._from_type == 1 then
        local cell = state_machine.excute("user_head_icon_create",0,{data})
        Panel_ranking_player_icon:addChild(cell)
        Text_player_name:setString(_ED.user_info.user_name)
        Text_fight:setString(red_alert_all_str[126])
        Text_fighting_number:setString(_ED.user_info.fighter_capacity)
        local change_numbers = _ED.fight_ranks.my_info.now_rank - _ED.fight_ranks.my_info.last_rank
        if change_numbers < 0 then
            change_numbers = 0 - change_numbers
        end
        Text_ranking_number:setString(change_numbers)
        if _ED.fight_ranks.my_info.last_rank < _ED.fight_ranks.my_info.now_rank 
            and _ED.fight_ranks.my_info.now_rank ~= 0 then
            Image_ranking_get_down:setVisible(true)
        else
            Image_ranking_get_up:setVisible(true)
        end
        Panel_camp:setBackGroundImage(string.format("images/ui/quality/camp_icon_%d.png", zstring.tonumber(_ED.user_info.user_force)))
        if _ED.fight_ranks.my_info.now_rank < 4 and _ED.fight_ranks.my_info.now_rank ~= 0  then
            Panel_ranking_picture:setBackGroundImage("images/ui/text/paihangb_".._ED.fight_ranks.my_info.now_rank..".png")
        else
            BitmapFontLabel_rank:setString(_ED.fight_ranks.my_info.now_rank)
        end
        Image_3:setVisible(true)
    elseif self._from_type == 2 then
        local cell = state_machine.excute("user_head_icon_create",0,{data})
        Panel_ranking_player_icon:addChild(cell)
        Text_player_name:setString(_ED.user_info.user_name)
        Text_fight:setString(red_alert_all_str[127])
        Text_fighting_number:setString(string.format(red_alert_all_str[118],_ED.trialtower_ranking_info.max_floor))
        local change_numbers = _ED.trialtower_ranking_info.my_rank - _ED.trialtower_ranking_info.last_rank
        if change_numbers < 0 then
            change_numbers = 0 - change_numbers
        end
        Text_ranking_number:setString(change_numbers)
        if _ED.trialtower_ranking_info.last_rank < _ED.trialtower_ranking_info.my_rank
            and _ED.trialtower_ranking_info.last_rank ~= 0 then
            Image_ranking_get_down:setVisible(true)
        else
            Image_ranking_get_up:setVisible(true)
        end
        Panel_camp:setBackGroundImage(string.format("images/ui/quality/camp_icon_%d.png", zstring.tonumber(_ED.user_info.user_force)))
        if _ED.trialtower_ranking_info.my_rank < 4 and _ED.trialtower_ranking_info.my_rank ~= 0 then
            Panel_ranking_picture:setBackGroundImage("images/ui/text/paihangb_".._ED.trialtower_ranking_info.my_rank..".png")
        else
            BitmapFontLabel_rank:setString(_ED.trialtower_ranking_info.my_rank)
        end
        Image_8:setVisible(true)
    elseif self._from_type == 3 then
        Panel_rank_camp:setBackGroundImage("images/ui/quality/camp_"..self._info_data.union_camp..".png")
        if tonumber(self._info_data.union_rank) < 4 then
            Panel_ranking_picture:setBackGroundImage("images/ui/text/paihangb_"..self._info_data.union_rank..".png")
        else
            BitmapFontLabel_rank:setString(self._info_data.union_rank)
        end

        local change_numbers = tonumber(self._info_data.union_rank) - tonumber(self._info_data.union_last_rank)
        if change_numbers < 0 then
            change_numbers = 0 - change_numbers
        end
        Text_ranking_number:setString(change_numbers)
        if tonumber(self._info_data.union_last_rank) < tonumber(self._info_data.union_rank) then
            Image_ranking_get_down:setVisible(true)
        else
            Image_ranking_get_up:setVisible(true)
        end

        Text_player_name:setString(self._info_data.union_name .. "  Lv" .. self._info_data.union_level)
        Text_fight:setString(red_alert_all_str[128])
        Text_fighting_number:setString(self._info_data.union_contribution)
        Image_legion_t_1:setVisible(true)
    end
end

function RankingRightTopCell:onEnterTransitionFinish()

end

function RankingRightTopCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.rank.ranking_right_top_cell, "root")
 	table.insert(self.roots, root)
 	self:addChild(root) 
	
	if RankingRightTopCell.__size == nil then
		RankingRightTopCell.__size = root:getContentSize()
	end
	self:onUpdateDraw()
end

function RankingRightTopCell:onExit()
    local Panel_ranking_player_icon = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_ranking_player_icon")
    if Panel_ranking_player_icon ~= nil then
        Panel_ranking_player_icon:removeAllChildren(true)
    end
	cacher.freeRef(config_csb.cells.rank.ranking_right_top_cell, self.roots[1])

end

function RankingRightTopCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RankingRightTopCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    local Panel_ranking_player_icon = ccui.Helper:seekWidgetByName(root,"Panel_ranking_player_icon")
    Panel_ranking_player_icon:removeAllChildren(true)
	cacher.freeRef(config_csb.cells.rank.ranking_right_top_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function RankingRightTopCell:init(from_type, info_data) 
    self._from_type = from_type
    self._info_data = info_data
	self:onInit()
	self:setContentSize(RankingRightTopCell.__size)
end

