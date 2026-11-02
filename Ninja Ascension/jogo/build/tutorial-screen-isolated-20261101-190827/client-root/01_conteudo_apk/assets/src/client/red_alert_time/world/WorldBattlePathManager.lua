-- ----------------------------------------------------------------------------------------------------
-- 说明：世界的路径管理器
-------------------------------------------------------------------------------------------------------
WorldBattlePathManager = class("WorldBattlePathManagerClass", Window)

local world_battle_path_manager_open_terminal = {
    _name = "world_battle_path_manager_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("WorldBattlePathManagerClass") then
    		fwin:open(WorldBattlePathManager:new():init(), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local world_battle_path_manager_close_terminal = {
	_name = "world_battle_path_manager_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WorldBattlePathManagerClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(world_battle_path_manager_open_terminal)
state_machine.add(world_battle_path_manager_close_terminal)
state_machine.init()

function WorldBattlePathManager:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._path_list = {}

    local function init_world_battle_path_manager_terminal()
        local world_battle_path_manager_update_path_terminal = {
            _name = "world_battle_path_manager_update_path",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.onUpdateDraw ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(world_battle_path_manager_update_path_terminal)  
        state_machine.init()
    end
    init_world_battle_path_manager_terminal()
end

function WorldBattlePathManager:onUpdateDraw()
    if _ED.world_map == nil 
        or _ED.world_map.target_event_info == nil 
        or table.nums(_ED.world_map.target_event_info) == 0 then
        for k,v in pairs(self._path_list) do
            if v ~= nil and v:getParent() ~= nil then
                v:removeFromParent(true)
            end
        end
        self._path_list = {}
        return
    end
    for k,v in pairs(_ED.world_map.target_event_info) do
        local key = ""..k.."|"..v._event_type
        if v._event_type == 0 
            or v._event_type == 6
            or v._event_type == 8 
            or v._event_type == 19 
            then
            if self._path_list[key] == nil then
                self._path_list[key] = state_machine.excute("adventure_mine_create_road_path",0,{v, 1, v._sx, v._sy, v._dx, v._dy})
            end
        elseif v._event_type == 1
            or v._event_type == 18
            or v._event_type == 23 
            then
            if self._path_list[key] == nil then
                self._path_list[key] = state_machine.excute("adventure_mine_create_road_path",0,{v, 1, v._sx, v._sy, v._dx, v._dy})
            end
        elseif v._event_type == 11 
            then
            if self._path_list[key] == nil then
                self._path_list[key] = state_machine.excute("adventure_mine_create_road_path",0,{v, 2, v._dx, v._dy, v._sx, v._sy})
            end
        else
            if self._path_list[key] ~= nil and self._path_list[key]:getParent() ~= nil then
                self._path_list[key]:removeFromParent(true)
                self._path_list[key] = nil
            end
        end
    end
    for key,v in pairs(self._path_list) do
        local info = zstring.split(key, "|")
        local k = info[1]
        local event_type = tonumber(info[2])
        if v ~= nil and v:getParent() ~= nil and 
            (_ED.world_map.target_event_info[k] == nil or tonumber(_ED.world_map.target_event_info[k]._event_type) ~= event_type)
            then
            v:removeFromParent(true)
            self._path_list[key] = nil
        end
    end
end

function WorldBattlePathManager:onEnterTransitionFinish()

end

function WorldBattlePathManager:init(params)
    self:onUpdateDraw()
    return self
end

function WorldBattlePathManager:onExit()
    for k,v in pairs(self._path_list) do
        if v ~= nil and v:getParent() ~= nil then
            v:removeFromParent(true)
        end
    end
    self._path_list = {}
    state_machine.remove("world_battle_path_manager_update_path")
end