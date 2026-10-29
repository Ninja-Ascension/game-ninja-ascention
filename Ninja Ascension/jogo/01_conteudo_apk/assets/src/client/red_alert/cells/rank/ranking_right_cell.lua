----------------------------------------------------------------------------------------------------
-- 说明：排行榜
-------------------------------------------------------------------------------------------------------
RankingRightCell = class("RankingRightCellClass", Window)
RankingRightCell.__size = nil

local ranking_right_create_cell_terminal = {
    _name = "ranking_right_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = RankingRightCell:new()
        local user_data = params[1]
        local from_type = params[2]
        local index = params[3]
        local show_look = params[4]
        cell:init(user_data,from_type,index,show_look)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(ranking_right_create_cell_terminal)
state_machine.init()

function RankingRightCell:ctor()
    self.super:ctor()
	self.roots = {}		

    --var 
    --用户信息
    self._user_data = nil
    --排行类型
    self._from_type = nil -- 1：战力，2：等级，3：侠客行，4：华山论剑，5：帮派

 	local function init_ranking_right_cell_terminal()
        
        local ranking_right_cell_look_info_terminal = {
            _name = "ranking_right_cell_look_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell._from_type == 5 then
                    state_machine.excute("ranking_union_member_window_open", 0, cell._user_data)
                else
                    local _user_id = params._datas.cell._user_data.user_id
                    state_machine.excute("user_info_window_open",0,{_datas = {user_id = _user_id}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(ranking_right_cell_look_info_terminal)       
        state_machine.init()
    end
	init_ranking_right_cell_terminal()        	
end

function RankingRightCell:onUpdateDraw()
	local root = self.roots[1]
    root:setVisible(true)
    local Text_ranking_text = ccui.Helper:seekWidgetByName(root,"Text_ranking_text") -- 排名数字
    local Panel_ranking_picture = ccui.Helper:seekWidgetByName(root,"Panel_ranking_picture") -- 排名图片
    local Text_player_name = ccui.Helper:seekWidgetByName(root,"Text_player_name")  -- 用户姓名
    local Text_rank_lv = ccui.Helper:seekWidgetByName(root,"Text_rank_lv")          -- 帮派名或帮派等级
    local Text_fighting_number = ccui.Helper:seekWidgetByName(root,"Text_fighting_number") --  战力值或等级、关卡数、帮派经验
    local Panel_ranking_grade = ccui.Helper:seekWidgetByName(root,"Panel_ranking_grade") -- 官职
    local Text_ranking_grade = ccui.Helper:seekWidgetByName(root,"Text_ranking_grade") 
    local Text_ranking_grade_name = ccui.Helper:seekWidgetByName(root,"Text_ranking_grade_name")

    Text_ranking_text:setString("")
    Panel_ranking_picture:removeBackGroundImage()
    Text_player_name:setString("")
    Text_rank_lv:setString("")
    Text_fighting_number:setString("")
    Text_fighting_number:setVisible(false)
    Panel_ranking_grade:setVisible(false)
    Text_ranking_grade:setString("")
    Text_ranking_grade_name:setString("")

    -- 显示玩家排名
    local rank_number = self._index

    local color = cc.c3b(0, 0, 0)
    if tonumber(rank_number) < 4 then
        Panel_ranking_picture:setBackGroundImage("images/ui/text/text_new_rank_"..rank_number..".png")
        color = tipStringInfo_rank_color_Type[rank_number]
    else
        Text_ranking_text:setString(rank_number)
        color = tipStringInfo_rank_color_Type[4]
    end

    Text_ranking_text:setColor(color)
    Text_player_name:setColor(color)
    Text_rank_lv:setColor(color)
    Text_fighting_number:setColor(color)
    Text_ranking_grade:setColor(color)
    Text_ranking_grade_name:setColor(color)

    if self._from_type == 1 then    --战力
        Text_player_name:setString(self._user_data.user_name)
        if zstring.tonumber(self._user_data.user_union_id) <= 0 then            --没有帮派
            Text_rank_lv:setString(tipStringInfo_rank_str[6])
        else
            Text_rank_lv:setString(self._user_data.user_union_name)
        end

        Text_fighting_number:setVisible(true)
        Panel_ranking_grade:setVisible(false)
        Text_fighting_number:setString(self._user_data.user_fight)
    elseif self._from_type == 2 then    --等级
        Text_player_name:setString(self._user_data.user_name)
        if zstring.tonumber(self._user_data.user_union_id) <= 0 then            --没有帮派
            Text_rank_lv:setString(tipStringInfo_rank_str[6])
        else
            Text_rank_lv:setString(self._user_data.user_union_name)
        end

        Text_fighting_number:setVisible(true)
        Panel_ranking_grade:setVisible(false)
        Text_fighting_number:setString(self._user_data.user_level)
    elseif self._from_type == 3 then    --侠客行
        Text_player_name:setString(self._user_data.user_name)
        if zstring.tonumber(self._user_data.user_union_id) <= 0 then            --没有帮派
            Text_rank_lv:setString(tipStringInfo_rank_str[6])
        else
            Text_rank_lv:setString(self._user_data.user_union_name)
        end

        Text_fighting_number:setVisible(true)
        Panel_ranking_grade:setVisible(false)
        Text_fighting_number:setString(self._user_data.user_process)
    elseif self._from_type == 4 then    --华山论剑
        Text_player_name:setString(self._user_data.user_name)
        if zstring.tonumber(self._user_data.user_union_id) <= 0 then            --没有帮派
            Text_rank_lv:setString(tipStringInfo_rank_str[6])
        else
            Text_rank_lv:setString(self._user_data.user_union_name)
        end

        Text_fighting_number:setVisible(false)
        Panel_ranking_grade:setVisible(true)
        local arena_name = dms.string(dms["arena_reward_param"],self._user_data.user_arena_id,arena_reward_param.arena_name)
        arena_name = zstring.split(arena_name,",")
        arena_name = arena_name[tonumber(self._user_data.user_camp)]
        Text_ranking_grade:setString(red_alert_officer[tonumber(self._user_data.user_official)])
        Text_ranking_grade_name:setString(arena_name)
    elseif self._from_type == 5 then    --帮派排行
        Text_player_name:setString(self._user_data.union_name)
        Text_rank_lv:setString(self._user_data.union_level)

        Text_fighting_number:setVisible(true)
        Panel_ranking_grade:setVisible(false)
        Text_fighting_number:setString(self._user_data.union_contribution)   
    end 
end

function RankingRightCell:onEnterTransitionFinish()

end

function RankingRightCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.rank.ranking_right_cell, "root")
 	table.insert(self.roots, root)
 	self:addChild(root) 
	
	if RankingRightCell.__size == nil then
		RankingRightCell.__size = root:getContentSize()
	end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_information_look"), nil, 
    {
        terminal_name = "ranking_right_cell_look_info",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    },
    nil,0)

	self:onUpdateDraw()
end

function RankingRightCell:onExit()
    local Panel_ranking_player_icon = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_ranking_player_icon")
    if Panel_ranking_player_icon ~= nil then
        Panel_ranking_player_icon:removeAllChildren(true)
    end
	cacher.freeRef(config_csb.cells.rank.ranking_right_cell, self.roots[1])

end

function RankingRightCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RankingRightCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    local Panel_ranking_player_icon = ccui.Helper:seekWidgetByName(root,"Panel_ranking_player_icon")
    Panel_ranking_player_icon:removeAllChildren(true)
	cacher.freeRef(config_csb.cells.rank.ranking_right_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function RankingRightCell:init(user_data,from_type,index,show_look) 
	self._user_data = user_data
    self._from_type = from_type
    self._show_look = show_look
    self._index = index
	if index ~= nil and index < 11 then
		self:onInit()
	end
	self:setContentSize(RankingRightCell.__size)
end

