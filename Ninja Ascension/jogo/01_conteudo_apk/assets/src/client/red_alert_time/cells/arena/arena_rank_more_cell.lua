-----------------------------
--战地争霸查看后20个排名cell
-----------------------------
ArenaRankMoreCell = class("ArenaRankMoreCellClass", Window)
ArenaRankMoreCell.__size = nil

local arena_rank_more_cell_create_terminal = {
    _name = "arena_rank_more_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ArenaRankMoreCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_rank_more_cell_create_terminal)
state_machine.init()

function ArenaRankMoreCell:ctor()
    self.super:ctor()
    self.roots = {}     
    
    local function init_arena_rank_more_cell_terminal()
        local arena_rank_more_cell_get_more_rank_terminal = {
            _name = "arena_rank_more_cell_get_more_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells = params._datas.cells
                local list_type = cells._list_type
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("arena_rank_all_tab_update_draw", 0, "")
                        state_machine.excute("rank_update_draw_list_view", 0, {list_type})
                        state_machine.excute("legion_list_update_draw", 0, "")
                    end
                end
                if cells._list_type == 1                     --请求战力排行榜 
                    or cells._list_type == 2                 --请求关卡排行榜 
                    or cells._list_type == 3 then            --请求军功排行榜 
                    protocol_command.order_get_info.param_list = ""..(cells._list_type - 1).. "\r\n" ..cells._index.. "\r\n" ..(cells._index+19)
                    NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, cells, responseCallback, false, nil)
                elseif cells._list_type == 4 then             --请求军团排行数据  
                    protocol_command.union_order.param_list = cells._index.. "\r\n" ..(cells._index+19).."\r\n0"
                    NetworkManager:register(protocol_command.union_order.code, nil, nil, nil, cells, responseCallback, false, nil)
                elseif cells._list_type == 5 then    --请求战地排行数据  
                    protocol_command.arena_order.param_list = "0".. "\r\n" ..cells._index.. "\r\n" ..(cells._index+19)
                    NetworkManager:register(protocol_command.arena_order.code, nil, nil, nil, cells, responseCallback, false, nil)
                elseif cells._list_type == 7  then                   --请求叛军总排行数据  
                    protocol_command.rebel_haunt_rank_list_get.param_list = "1".. "\r\n" ..cells._index.. "\r\n" ..(cells._index+19)
                    NetworkManager:register(protocol_command.rebel_haunt_rank_list_get.code, nil, nil, nil, cells, responseCallback, false, nil)
                elseif cells._list_type == 8  then                   --请求军团申请列表数据  
                    protocol_command.union_list.param_list = cells._index.. "\r\n" ..(cells._index+19)
                    NetworkManager:register(protocol_command.union_list.code, nil, nil, nil, cells, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(arena_rank_more_cell_get_more_rank_terminal)
        state_machine.init()
    end
    init_arena_rank_more_cell_terminal()         
end


function ArenaRankMoreCell:onUpdateDraw()
    local root = self.roots[1]
    -- local Text_player_fight_n = ccui.Helper:seekWidgetByName(root, "Text_player_fight_n")
    -- if self._width ~= nil then
    --     root:setContentSize(self._width, root:getContentSize().height)
    --     self:setContentSize(root:getContentSize())
    --     Text_player_fight_n:setPositionX(self._width / 2)
    -- end
end


function ArenaRankMoreCell:onEnterTransitionFinish()

end

function ArenaRankMoreCell:onInit()
    local root = nil
    if self._width == 1 then
        root = cacher.createUIRef(config_csb.cells.arena.arena_rank_cell_3, "root")
    else 
        root = cacher.createUIRef(config_csb.cells.rank.rank_add_cell, "root")
    end
    table.insert(self.roots, root)
    self:addChild(root) 
    
    if ArenaRankMoreCell.__size == nil then
        ArenaRankMoreCell.__size = root:getContentSize()
    end

    root:setContentSize(ArenaRankMoreCell.__size)

    --挑战
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_rank_bar_list"), nil, 
    {
        terminal_name = "arena_rank_more_cell_get_more_rank", 
        terminal_state = 0, 
        cells = self,
    }, nil, 1)

    self:onUpdateDraw()
end

function ArenaRankMoreCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.arena.arena_rank_cell_3, root)
end

function ArenaRankMoreCell:reload()
    -- local root = self.roots[1]
    -- if root ~= nil then
    --     return
    -- end
    -- self:onInit()
end

function ArenaRankMoreCell:unload()
    -- local root = self.roots[1]
    -- if root == nil then
    --     return
    -- end
    -- self:clearUIInfo()
    -- cacher.freeRef(config_csb.cells.arena.arena_rank_cell_3, root)
    -- root:removeFromParent(false)
    -- self.roots = {}
end

function ArenaRankMoreCell:clearUIInfo( ... )
    -- local Text_player_fight_n = ccui.Helper:seekWidgetByName(root, "Text_player_fight_n")
    -- if Text_player_fight_n ~= nil then
    --     root:setContentSize(ArenaRankMoreCell.__size)
    --     Text_player_fight_n:setPositionX(ArenaRankMoreCell.__size._width / 2)
    -- end
end

function ArenaRankMoreCell:init(params)
    self._index = params[1]
    self._list_type = params[2] 
    self._width = params[3] 
    -- if self._index ~= nil and self._index <= 14 then
        self:onInit()
    -- end
    self:setContentSize(ArenaRankMoreCell.__size)
    return self
end

