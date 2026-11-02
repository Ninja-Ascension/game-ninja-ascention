--------------------------------------------------------------------------------------------------------------
--  说明：将领兑换列表
--------------------------------------------------------------------------------------------------------------
LeaderExchangeList = class("LeaderExchangeListClass", Window)

--打开界面
local leader_exchange_list_window_open_terminal = {
	_name = "leader_exchange_list_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local panel = LeaderExchangeList:new():init(params)
		fwin:open(panel)
		return panel
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(leader_exchange_list_window_open_terminal)
state_machine.init()

function LeaderExchangeList:ctor()
	self.super:ctor()
	self.roots = {}
    
    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0

    local function init_leader_exchange_list_terminal()
        local leader_exchange_list_show_terminal = {
            _name = "leader_exchange_list_show",
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

        local leader_exchange_list_hide_terminal = {
            _name = "leader_exchange_list_hide",
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

        local leader_exchange_list_update_terminal = {
            _name = "leader_exchange_list_update",
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

        state_machine.add(leader_exchange_list_show_terminal)	
        state_machine.add(leader_exchange_list_hide_terminal)
        state_machine.add(leader_exchange_list_update_terminal)
        state_machine.init()
    end
    init_leader_exchange_list_terminal()
end

function LeaderExchangeList:refreshListView()
    self.listview:jumpToTop()
    self.listview:requestRefreshView()
end

function LeaderExchangeList:onUpdateDraw(  )
    local root = self.roots[1]
    local ListView_leader = ccui.Helper:seekWidgetByName(root, "ListView_leader")
    ListView_leader:removeAllItems()
    ListView_leader:jumpToTop()

    local can_recuit = {}           -- 可招募
    local not_recuit = {}           -- 不可招募
    local owned_leader = {}         -- 已拥有

    local result = {}
    for k, v in pairs(_ED.user_prop) do
        if tonumber(v.storage_page_index) == 23 then
            local info = {}
            info.user_prop_id = tonumber(v.user_prop_id)
            info.prop_id = tonumber(v.user_prop_template)
            info.count = tonumber(v.prop_number)
            info.coming_need_number = tonumber(v.coming_need_number)
            info.prop_name = v.prop_name
            info.quality = tonumber(v.quality)
            info.order = tonumber(v.prop_track_scene)

            local is_owned = false
            local ship_template_id = dms.int(dms["prop_mould"], info.prop_id, prop_mould.use_of_ship)     -- 兑换后将领模板id
            local base_template_id = dms.int(dms["ship_mould"], ship_template_id, ship_mould.base_mould)
            is_owned = false
            for k, v in pairs(_ED.user_ship) do
                if tonumber(v.ship_base_template_id) == base_template_id then
                    is_owned = true
                    break
                end
            end

            if is_owned == true then
                table.insert(owned_leader, info)
            elseif info.count < info.coming_need_number then
                table.insert(not_recuit, info)
            else
                table.insert(can_recuit, info)
            end
        end
    end

    local function sortFunction(a, b)
        return a.count > b.count
    end
    table.sort(can_recuit, sortFunction)
    table.sort(not_recuit, sortFunction)
    table.sort(owned_leader, sortFunction)

    local index = 1
    for k, v in pairs(can_recuit) do
        local cell = state_machine.excute("leader_soul_create_cell", 0, {index,v})
        ListView_leader:addChild(cell)
        index = index + 1
    end

    for k, v in pairs(not_recuit) do
        local cell = state_machine.excute("leader_soul_create_cell", 0, {index,v})
        ListView_leader:addChild(cell)
        index = index + 1
    end

    for k, v in pairs(owned_leader) do
        local cell = state_machine.excute("leader_soul_create_cell", 0, {index,v})
        ListView_leader:addChild(cell)
        index = index + 1
    end

    ListView_leader:requestRefreshView()
    self.listview = ListView_leader
    self.listview_poy = ListView_leader:getInnerContainer():getPositionY()
    self.listview_height = ListView_leader:getInnerContainer():getPositionY()
end

function LeaderExchangeList:onUpdate(dt)
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

function LeaderExchangeList:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_leader_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    
    self:onUpdateDraw()
end

function LeaderExchangeList:onEnterTransitionFinish()

end

function LeaderExchangeList:init(params)
	self._rootWindows = params[1]
	self:onInit()
    return self
end

function LeaderExchangeList:onExit()
    state_machine.remove("leader_exchange_list_show")
    state_machine.remove("leader_exchange_list_hide")
    state_machine.remove("leader_exchange_list_update")
end