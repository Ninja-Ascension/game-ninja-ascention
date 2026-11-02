-- ----------------------------------------------------------------------------------------------------
-- 说明：排位赛刷新对手
-------------------------------------------------------------------------------------------------------
AdventureArenaWarcraftRefreshRival = class("AdventureArenaWarcraftRefreshRivalClass", Window)
    
function AdventureArenaWarcraftRefreshRival:ctor()
    self.super:ctor()
    self.roots = {}
	self.isTouchLock = false
	self.interval = 0
    self.current_type = 1 --刷新对手 2 刷新挑战次数 3 购买阵型4
    

    -- Initialize adventure arena state machine.
    local function init_adventure_arena_warcraft_refresh_rival_terminal()

        --刷新
		local adventure_arena_warcraft_refresh_fighter_terminal = {
            _name = "adventure_arena_warcraft_refresh_fighter",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.current_type == 1 then 
                    --刷新对手
                    local function responseRefreshFighterCallback(response)
                        fwin:close(fwin:find("AdventureArenaWarcraftRefreshRivalClass"))
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("adventure_arena_warcraft_list_refresh_info", 0, "")
                        end
                    end
                    NetworkManager:register(protocol_command.warcraft_rush_fighter.code, nil, nil, nil, instance, responseRefreshFighterCallback, true, nil)
                elseif instance.current_type == 2 then 
                    --刷新次数
                    local function responseRefreshFightCountsCallback(response)
                        fwin:close(fwin:find("AdventureArenaWarcraftRefreshRivalClass"))
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("adventure_arena_warcraft_list_refresh_fight_counts", 0, "")
                        end
                    end
                    NetworkManager:register(protocol_command.warcraft_buy_fight_count.code, nil, nil, nil, instance, responseRefreshFightCountsCallback, true, nil)
                elseif instance.current_type == 3 then 
                    --购买阵型4
                    local function responseRefreshFormationCallback(response)
                        fwin:close(fwin:find("AdventureArenaWarcraftRefreshRivalClass"))
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            state_machine.excute("adventure_battle_formation_open_lock_four_fomation", 0, 2)
                        end
                    end
                    NetworkManager:register(protocol_command.buy_fourth_formation.code, nil, nil, nil, instance, responseRefreshFormationCallback, true, nil)
           
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(adventure_arena_warcraft_refresh_fighter_terminal)
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_warcraft_refresh_rival_terminal()
end

function AdventureArenaWarcraftRefreshRival:init(show_type)
    self.current_type = show_type 
	return self
end

function AdventureArenaWarcraftRefreshRival:onUpdateDraw()
	local root = self.roots[1]
    if root == nil then 
        return
    end
    local Text_number = ccui.Helper:seekWidgetByName(root, "Text_xh_number")
    local Text_title = ccui.Helper:seekWidgetByName(root, "Text_11")
    local consume = 0
    if self.current_type == 1 then 
        --刷新对手
        Text_title:setString(_string_piece_info[445])
        
        local consumes = zstring.split(dms.string(dms["pirates_config"], 337, pirates_config.param), ",")

        if _ED.warcraft_info.rival_info ~= nil and _ED.warcraft_info.rival_info.buy_times ~= nil then  -- 购买次数
            local current_buy_times = zstring.tonumber(_ED.warcraft_info.rival_info.buy_times)
            if current_buy_times >= #consumes then 
                consume = consumes[#consumes]
            else
                consume = consumes[current_buy_times + 1]
            end
        end

    elseif self.current_type == 2 then 
        --Text_title:setString(_string_piece_info[446])
        --刷新挑战次数
        
        local consumesArr = nil
        if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
            or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge 
            or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
            or __lua_project_id == __lua_project_yugioh 
            or __lua_project_id == __lua_project_warship_girl_b 
            then 
            consumesArr = zstring.split(dms.string(dms["pirates_config"], 308, pirates_config.param), ",")
            Text_title:setString(warcraft_tip[28])
        else
            consumesArr = zstring.split(dms.string(dms["pirates_config"], 334, pirates_config.param), ",")
            Text_title:setString(_string_piece_info[469])
        end
        
        local current_buy_times = zstring.tonumber(_ED.warcraft_info.buy_times)
        if current_buy_times >= #consumesArr then 
            consume = consumesArr[#consumesArr]
        else
            consume = consumesArr[current_buy_times + 1]
        end
    else
        Text_title:setString(_string_piece_info[470])
        consume = dms.int(dms["pirates_config"], 338, pirates_config.param)
    end
    Text_number:setString("" .. consume)
end

function AdventureArenaWarcraftRefreshRival:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/jingji_shuaxin_pws.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)
    self:onUpdateDraw()
    	
	-- --确定刷新
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_refresh_fighter", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    --取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureArenaWarcraftRefreshRivalClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureArenaWarcraftRefreshRivalClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
    
end

function AdventureArenaWarcraftRefreshRival:onExit()
    self.roots = nil
    state_machine.remove("adventure_arena_warcraft_refresh_fighter")
    
end