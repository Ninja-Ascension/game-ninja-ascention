--------------------------------------------------------------------------------------------------------------
--  开服冲top列表控件
--------------------------------------------------------------------------------------------------------------
ServerTopRankRihgtCell = class("ServerTopRankRihgtCellClass", Window)
ServerTopRankRihgtCell.__size = nil

--创建cell
local server_top_rank_rihgt_create_cell_terminal = {
    _name = "server_top_rank_rihgt_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local index = params[1]
        local reward = params[2]
        local info = params[3]
        local rank_info = params[4]
        local day_index = params[5]
        local cell = ServerTopRankRihgtCell:new()
        cell:init(index, reward, info, rank_info ,day_index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(server_top_rank_rihgt_create_cell_terminal)
state_machine.init()

function ServerTopRankRihgtCell:ctor()
	self.super:ctor()
	self.roots = {}
    self._index = 0         -- cell数量
    self._reward = ""       -- 排名奖励
    self._info = nil        -- 排行类型
    self._rank_info = ""    -- 排名区间
    
    self._listview = nil
	 -- Initialize server_top_rank_rihgt_cell state machine.
    local function init_server_top_rank_rihgt_cell_terminal()

    end
    
    -- call func server_top_rank_rihgt_cell create state machine.
    init_server_top_rank_rihgt_cell_terminal()
end

function ServerTopRankRihgtCell:updateDraw()
    local root = self.roots[1]
    local ListView_reward = ccui.Helper:seekWidgetByName(root,"ListView_reward")
    ListView_reward:removeAllItems()
    local Text_time_infor = ccui.Helper:seekWidgetByName(root,"Text_time_infor")
    local info = nil
    if self._day_index == 1 then 
        info = _ED.server_rank_info_three[self._laft_page][self._index]
    elseif self._day_index == 2 then 
        info = _ED.server_rank_info_seven[self._laft_page][self._index]
    else
        info = _ED.server_rank_info_fourteen[self._laft_page][self._index]
    end
    
    local rank_infos = zstring.split(self._rank_info, "-")
    if info ~= nil then
        Text_time_infor:setString(string.format(tipStringInfo_server_top_rank[self._laft_page], rank_infos[1], info.name, info.power))
    else
        Text_time_infor:setString(tipStringInfo_server_top_rank[6])
    end
    if tonumber(rank_infos[1]) == tonumber(rank_infos[2]) then
        ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_n"):setString(string.format(tipStringInfo_server_top_rank[5],rank_infos[1]))
    else
        Text_time_infor:setString("")
        ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_n"):setString(string.format(tipStringInfo_server_top_rank[5],self._rank_info))
    end
    if tonumber(self._reward) == -1 then
    else
        local rewards = zstring.split(self._reward, "|")
        for k,v in pairs(rewards) do
            local reward_info = zstring.split(v, ",")
            local data = 
            {
                item_value = reward_info[3],
                prop_type = reward_info[2],
                prop_item = reward_info[1],
            }
            local cell = nil
            if tonumber(data.prop_type) == 6 then    
                if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment))> 0 
                    or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
                    cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,touch_type,0,false,true})
                else
                    cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,touch_type,0,false,true})
                end  
            elseif tonumber(data.prop_type) == 34 then    
                cell = state_machine.excute("all_resource_create_cell",0,{5,data,data,touch_type,0,false,true})   
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,touch_type,0,false,true})
            end
            ListView_reward:addChild(cell)
        end
    end
end

function ServerTopRankRihgtCell:onUpdate(dt)
    if self.roots == nil then 
        return
    end
    local server_time = _ED.system_time + (os.time() - _ED.native_time)
    local infos = 0
    if _ED.activity_info["23"] == nil then
        infos = tonumber(_ED.activity_info["40"].activity_add_state)/1000
    else
        infos = tonumber(_ED.activity_info["23"].activity_add_state)/1000
    end
    if self._day_index == 1 then 
        infos = infos + 3600 * 24 * 3
    elseif self._day_index == 2 then 
        infos = infos + 3600 * 24 * 7
    else
        infos = infos + 3600 * 24 * 14
    end
    local timeString = ""
    local now_time = math.max(tonumber(infos - server_time),0)
    if now_time > 0 then
        local day = math.floor(tonumber(now_time)/3600/24)
        local hour = math.floor(tonumber(now_time)/3600%24)
        local minute = math.floor((tonumber(now_time)%3600)/60)
        local second = math.floor((tonumber(now_time)%3600)%60)
        self.time_text:setString(string.format(red_alert_all_str[180], ""..day, ""..hour, ""..minute, ""..second))
        self.time_over:setVisible(true)
    else
        self.time_text:setString(red_alert_all_str[201])
        self.time_over:setVisible(false)
    end
end

function ServerTopRankRihgtCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.server_top_rank.ranking_top_right_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ServerTopRankRihgtCell.__size == nil then
        ServerTopRankRihgtCell.__size = root:getContentSize()
    end
    local Text_top_time = ccui.Helper:seekWidgetByName(root,"Text_top_time")

    self.time_text = Text_top_time
    self.time_text:setString("")
    local Text_top_time_0 = ccui.Helper:seekWidgetByName(root,"Text_top_time_0")
    self.time_over = Text_top_time_0
    self.time_over:setVisible(false)
    local ListView_reward = ccui.Helper:seekWidgetByName(root,"ListView_reward") --列表
    self._listview = ListView_reward
  	self:updateDraw()
    self:registerOnNoteUpdate(self)
end

function ServerTopRankRihgtCell:onEnterTransitionFinish()

end

function ServerTopRankRihgtCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ServerTopRankRihgtCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:unregisterOnNoteUpdate(self)
    self._listview:removeAllItems()
    cacher.freeRef(config_csb.cells.activity.server_top_rank.ranking_top_right_cell, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function ServerTopRankRihgtCell:init(index, reward, _laft_page, rank_info, day_index)
    self._index = index
    self._reward = reward
    self._laft_page = _laft_page
    self._rank_info = rank_info
    self._day_index = day_index
    if self._index ~= nil and self._index < 4 then
	    self:onInit()
    end
    self:setContentSize(ServerTopRankRihgtCell.__size)
    return self
end

function ServerTopRankRihgtCell:onExit()
    if self._listview ~= nil then
        self._listview:removeAllItems()
    end
    self:unregisterOnNoteUpdate(self)
    cacher.freeRef(config_csb.cells.activity.server_top_rank.ranking_top_right_cell, self.roots[1])
end