--------------------------------------------------------------------------------------------------------------
--  说明：将领列表
--------------------------------------------------------------------------------------------------------------
LeaderTeamList = class("LeaderTeamListClass", Window)

--打开界面
local leader_team_list_window_open_terminal = {
	_name = "leader_team_list_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local panel = LeaderTeamList:new():init(params)
		fwin:open(panel)
		return panel
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(leader_team_list_window_open_terminal)
state_machine.init()

function LeaderTeamList:ctor()
	self.super:ctor()
	self.roots = {}
    
    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0

    local function init_leader_team_list_terminal()
        local leader_team_list_show_terminal = {
            _name = "leader_team_list_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(true)
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local leader_team_list_hide_terminal = {
            _name = "leader_team_list_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local leader_team_list_update_terminal = {
            _name = "leader_team_list_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local posY = instance.listview_poy
                instance:onUpdateDraw()
                if math.abs(posY) > math.abs(instance.listview_height) then
                    posY = instance.listview_height
                end
                instance.listview:getInnerContainer():setPositionY(posY)    
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(leader_team_list_show_terminal)	
        state_machine.add(leader_team_list_hide_terminal)
        state_machine.add(leader_team_list_update_terminal)
        state_machine.init()
    end
    init_leader_team_list_terminal()
end

function LeaderTeamList:refreshListView()
    self.listview:jumpToTop()
    self.listview:requestRefreshView()
end

function LeaderTeamList:onUpdateDraw()
    local root = self.roots[1]
    local ListView_leader = ccui.Helper:seekWidgetByName(root, "ListView_leader")
    ListView_leader:jumpToTop()
    ListView_leader:removeAllItems()

    local result = {}
    for k, v in pairs(_ED.user_ship) do
        if tonumber(v.camp_preference) == 0 then
            table.insert(result, v)
        end
    end

    local function sortFunction(a, b)
        if tonumber(a.ship_type) > tonumber(b.ship_type)
            or tonumber(a.ship_type) == tonumber(b.ship_type) and tonumber(a.ship_level) > tonumber(b.ship_level) 
            or tonumber(a.ship_type) == tonumber(b.ship_type) and tonumber(a.ship_level) == tonumber(b.ship_level) and tonumber(a.ship_template_id) < tonumber(b.ship_template_id)
            then
            return true
        end
        return false
    end
    table.sort(result, sortFunction)

    for k, v in pairs(result) do
        local cell = state_machine.excute("leader_cell_create_cell", 0, {k, v})
        ListView_leader:addChild(cell)
    end

    ListView_leader:requestRefreshView()
    ListView_leader:jumpToTop()
    self.listview = ListView_leader
    self.listview_poy = ListView_leader:getInnerContainer():getPositionY()
    self.listview_height = ListView_leader:getInnerContainer():getPositionY()
end

function LeaderTeamList:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function LeaderTeamList:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_leader_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    
    self:onUpdateDraw()
end

function LeaderTeamList:onEnterTransitionFinish()

end

function LeaderTeamList:init(params)
	self._rootWindows = params[1]
	self:onInit()
    return self
end

function LeaderTeamList:onExit()
    state_machine.remove("leader_team_list_show")
    state_machine.remove("leader_team_list_hide")
    state_machine.remove("leader_team_list_update")
end