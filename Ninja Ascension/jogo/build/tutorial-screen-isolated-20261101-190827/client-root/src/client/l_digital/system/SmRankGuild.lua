-----------------------------
--公会排行
-----------------------------
SmRankGuild = class("SmRankGuildClass", Window)
SmRankGuild.__size = nil

local sm_rank_guild_open_terminal = {
    _name = "sm_rank_guild_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmRankGuild:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_rank_guild_open_terminal)
state_machine.init()

function SmRankGuild:ctor()
    self.super:ctor()
    self.roots = {}

    self.prop_list = {}

    self.starting_point = 1
    self.end_point = 10
    self.isOver = false

    app.load("client.l_digital.cells.activity.wonderful.sm_activity_all_ranking_information_cell")
    app.load("client.l_digital.cells.activity.wonderful.sm_activity_ranking_cell_new")
    
    local function init_sm_rank_guild_terminal()
		--显示界面
		local sm_rank_guild_show_terminal = {
            _name = "sm_rank_guild_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local sm_rank_guild_hide_terminal = {
            _name = "sm_rank_guild_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        local sm_rank_guild_open_rank_terminal = {
            _name = "sm_rank_guild_open_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.isOver == false then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node.starting_point = response.node.starting_point+10
                                response.node.end_point = response.node.end_point+10
                                response.node:addnewlistCell()
                            end
                        end
                    end
                    local energyData = zstring.split(dms.string(dms["user_config"], 8, user_config.param), ",")
                    if tonumber(energyData[5]) <= instance.end_point then
                        instance.isOver = true
                        return
                    end
                    protocol_command.union_order.param_list = (instance.starting_point+10).. "\r\n" ..(instance.end_point+10).."\r\n0"
                    NetworkManager:register(protocol_command.union_order.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_rank_guild_show_terminal)	
        state_machine.add(sm_rank_guild_hide_terminal)
		state_machine.add(sm_rank_guild_open_rank_terminal)

        state_machine.init()
    end
    init_sm_rank_guild_terminal()
end

function SmRankGuild:onHide()
    self:setVisible(false)
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_phb")
    ListView_phb:removeAllItems()
    self:stopAllActions()
end

function SmRankGuild:onShow()
    self:setVisible(true)
    self:onUpdateDraw()
end

function SmRankGuild:addnewlistCell()
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_phb")
    for i= self.starting_point,self.end_point do
        if _ED.union.rank_union_list_info[i] ~= nil then
            local cell = nil
            -- DSC修改排行榜布局
            if __lua_project_id == __lua_project_l_digital then
                cell = state_machine.excute("sm_activity_ranking_cell_new_create",0,{_ED.union.rank_union_list_info[i],5})
            else
                cell = state_machine.excute("sm_activity_all_ranking_information_cell",0,{_ED.union.rank_union_list_info[i],5})
            end
            ListView_phb:addChild(cell)
        else
            self.isOver = true
        end
    end
    ListView_phb:requestRefreshView()
end

function SmRankGuild:onUpdateDraw()
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_phb")
    ListView_phb:removeAllItems()
    self.starting_point = 1
    self.end_point = 10
    self.isOver = false
    for i, v in ipairs(_ED.union.rank_union_list_info) do 
        local cell = nil
        -- DSC修改排行榜布局
        if __lua_project_id == __lua_project_l_digital then
            cell = state_machine.excute("sm_activity_ranking_cell_new_create",0,{v,5})
        else
            cell = state_machine.excute("sm_activity_all_ranking_information_cell",0,{v,5})
        end
        ListView_phb:addChild(cell)
    end
    ListView_phb:requestRefreshView()

    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.bounceBottom then--6
            --滑到头
            state_machine.excute("sm_rank_guild_open_rank", 0, nil)
        end
    end
    ListView_phb:addScrollViewEventListener(scrollViewEvent)
end

function SmRankGuild:onUpdate(dt)
    
end

function SmRankGuild:onEnterTransitionFinish()

end

function SmRankGuild:onInit( )
    local csbItem = csb.createNode("system/sm_ranking_listview.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    if SmRankGuild.__size == nil then
        SmRankGuild.__size = root:getContentSize()
    end
    self:setContentSize(SmRankGuild.__size)

    self:onUpdateDraw()
end

function SmRankGuild:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmRankGuild:onExit()
    state_machine.remove("sm_rank_guild_show")    
    state_machine.remove("sm_rank_guild_hide")
end
