----------------------------------------------------------------------------------------------------
-- 说明：排行榜cell
-------------------------------------------------------------------------------------------------------
RankCell = class("RankCellClass", Window)
RankCell.__size = nil

local rank_create_cell_terminal = {
    _name = "rank_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = RankCell:new()
        local index = params[1]
        local from_type = params[2]
        local user_data = params[3]
        cell:init(index, from_type, user_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rank_create_cell_terminal)
state_machine.init()

function RankCell:ctor()
    self.super:ctor()
	self.roots = {}		

    --var 
    --用户信息
    self._user_data = nil
    --当前排行榜列表类型 1战力，2关卡，3军功，4军团，5战地，6学霸，7平叛，8歼敌，9参战
    self._from_type = nil

    app.load("client.red_alert_time.legion.LegionInforWindow")
    app.load("client.red_alert_time.friend.RedAlertTimeFriendInfo")

 	local function init_rank_cell_terminal()
        
        local rank_cell_look_info_terminal = {
            _name = "rank_cell_look_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell._from_type == 1 
                    or cell._from_type == 2
                    or cell._from_type == 3
                    then
                    state_machine.excute("red_alert_time_friend_info_open", 0, ""..cell._user_data.user_id)
                elseif cell._from_type == 4 then
                    state_machine.excute("legion_infor_window_open", 0, {cell._user_data, 2})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(rank_cell_look_info_terminal)       
        state_machine.init()
    end
	init_rank_cell_terminal()        	
end

function RankCell:onUpdateDraw()
	local root = self.roots[1]
    -- 排名
    local Panel_rank_top_icon = ccui.Helper:seekWidgetByName(root,"Panel_rank_top_icon")
    local Text_player_name_n = ccui.Helper:seekWidgetByName(root,"Text_player_name_n")  -- 名字
    local Text_player_lv_n = ccui.Helper:seekWidgetByName(root,"Text_player_lv_n")      -- 等级
    local Text_rank_type_n = ccui.Helper:seekWidgetByName(root,"Text_rank_type_n")      -- type
    local Text_rank_n = ccui.Helper:seekWidgetByName(root,"Text_rank_n")
    Text_player_name_n:setString("")
    Text_player_lv_n:setString("")
    Text_rank_type_n:setString("")
    Panel_rank_top_icon:removeBackGroundImage()
    Text_rank_n:setString("")
    if self._index <= 3 then
        Panel_rank_top_icon:setBackGroundImage(string.format(config_res.images.ui.share.rank_icon, self._index))
    else
        Text_rank_n:setString(self._index)
    end

    local color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
    if self._index <= 3 then
        color = cc.c3b(arena_color_Type[self._index+2][1], arena_color_Type[self._index+2][2], arena_color_Type[self._index+2][3])
    elseif self._index <= 10 then
        color = cc.c3b(arena_color_Type[6][1], arena_color_Type[6][2], arena_color_Type[6][3])
    else
        color = cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3])
    end
    Text_rank_n:setColor(color)
    Text_player_name_n:setColor(color)

    if self._from_type == 1 then    -- 战力
        Text_player_name_n:setString(self._user_data.user_name)
        Text_player_lv_n:setString(self._user_data.user_level)
        Text_rank_type_n:setString(exChangeNumToString(self._user_data.user_fight))
    elseif self._from_type == 2 then        -- 关卡
        Text_player_name_n:setString(self._user_data.user_name)
        Text_player_lv_n:setString(self._user_data.user_level)
        Text_rank_type_n:setString(exChangeNumToString(self._user_data.npc_count))
    elseif self._from_type == 3 then         -- 军功
        Text_player_name_n:setString(self._user_data.user_name)
        Text_player_lv_n:setString(self._user_data.user_level)
        Text_rank_type_n:setString(exChangeNumToString(self._user_data.exploit))
    elseif self._from_type == 4 then    -- 军团
        Text_player_name_n:setString(self._user_data.union_name)
        Text_player_lv_n:setString(self._user_data.union_level)
        Text_rank_type_n:setString(exChangeNumToString(self._user_data.union_fight))                  -- 总战力  
    elseif self._from_type == 5 then    -- 战地榜
        Text_player_name_n:setString(self._user_data.user_name)
        Text_player_lv_n:setString(self._user_data.user_level)
        Text_rank_type_n:setString(exChangeNumToString(self._user_data.user_fight))                  -- 伤害  
    elseif self._from_type == 6 then    -- 学霸
        Text_player_name_n:setString(self._user_data.name)
        Text_player_lv_n:setString(self._user_data.level)
        Text_rank_type_n:setString(self._user_data.score)                                             -- 积分
    elseif self._from_type == 7 then    -- 叛军
        Text_player_name_n:setString(self._user_data.user_name)
        Text_player_lv_n:setString(self._user_data.level)
        Text_rank_type_n:setString(self._user_data.score)                                             -- 积分
    elseif self._from_type == 8 then    -- 歼敌榜
        Text_player_name_n:setString(self._user_data.user_name)
        Text_player_lv_n:setString(self._user_data.level)
        Text_rank_type_n:setString(exChangeNumToString(self._user_data.total_value))                  -- 伤害  
    elseif self._from_type == 9 then    -- 参战榜
        Text_player_name_n:setString(self._user_data.user_name)
        Text_player_lv_n:setString(self._user_data.level)
        Text_rank_type_n:setString(self._user_data.total_value)                                        -- 次数  
    end
    if verifySupportLanguage(_lua_release_language_en) == true then
        local str = Text_player_lv_n:getString()
        Text_player_lv_n:setString(red_alert_time_str[2]..str)
    end
end 

function RankCell:onEnterTransitionFinish()

end

function RankCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.rank.rank_cell, "root")
 	table.insert(self.roots, root)
 	self:addChild(root) 
	
	if RankCell.__size == nil then
		RankCell.__size = root:getContentSize()
	end

    

    fwin:addTouchEventListener(root, nil, 
    {
        terminal_name = "rank_cell_look_info",
        terminal_state = 0,
        cell = self,
    },
    nil,1)

	self:onUpdateDraw()
end

function RankCell:onExit()
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.rank.rank_cell, self.roots[1])
end

function RankCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RankCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef(config_csb.cells.rank.rank_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function RankCell:clearUIInfo()
    local root = self.roots[1]
    local Panel_rank_top_icon = ccui.Helper:seekWidgetByName(root,"Panel_rank_top_icon")
    local Text_player_name_n = ccui.Helper:seekWidgetByName(root,"Text_player_name_n")
    local Text_player_lv_n = ccui.Helper:seekWidgetByName(root,"Text_player_lv_n")
    local Text_rank_type_n = ccui.Helper:seekWidgetByName(root,"Text_rank_type_n")
    local Text_rank_n = ccui.Helper:seekWidgetByName(root,"Text_rank_n")
    if Panel_rank_top_icon ~= nil then
        Panel_rank_top_icon:removeAllChildren(true)
        Panel_rank_top_icon:removeBackGroundImage()
        Text_player_name_n:setString("")
        Text_player_lv_n:setString("")
        Text_rank_type_n:setString("")  
        Text_rank_n:setString("")
    end
end

function RankCell:init(index, from_type, user_data) 
    self._index = index
    self._from_type = from_type
    self._user_data = user_data
	if index ~= nil and index <= 14 then
		self:onInit()
	end
	self:setContentSize(RankCell.__size)
end

