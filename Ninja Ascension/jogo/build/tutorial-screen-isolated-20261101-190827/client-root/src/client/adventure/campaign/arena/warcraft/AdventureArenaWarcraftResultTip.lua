-- ----------------------------------------------------------------------------------------------------
-- 说明：排位赛战斗结束后提示
-------------------------------------------------------------------------------------------------------
AdventureArenaWarcraftResultTip = class("AdventureArenaWarcraftResultTipClass", Window)
    
function AdventureArenaWarcraftResultTip:ctor()
    self.super:ctor()
    self.roots = {}
    self.current_type = 0 
    app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraft")
    self.enum_type = {
        _TYPE_SHOW_LEVEL_UP  = 1,              -- 晋升成功
        _TYPE_SHOW_LEVEL_DOWN = 2,              -- 晋升失败
        _TYPE_SHOW_TITLE_DOWN = 3,              -- 掉段惩罚
        _TYPE_SHOW_TITLE_UP = 4,              -- 晋升赛
    }
     -- Initialize adventure arena state machine.
    local function init_adventure_arena_warcraft_result_tip_terminal()
    
        --返回
        local adventure_arena_warcraft_more_reward_close_terminal = {
            _name = "adventure_arena_warcraft_more_reward_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
             fwin:close(fwin:find("AdventureArenaWarcraftMoreRewardClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }        
        state_machine.add(adventure_arena_warcraft_level_get_reward_terminal)    
        state_machine.add(adventure_arena_warcraft_level_reward_more_terminal)   
        state_machine.add(adventure_arena_warcraft_level_reward_close_terminal)   
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_warcraft_result_tip_terminal()
end

function AdventureArenaWarcraftResultTip:init(show_type)
    self.current_type = show_type 
	return self
end

function AdventureArenaWarcraftResultTip:onUpdateDraw()
	local root = self.roots[1]
    if root == nil then 
        return
    end
    local Text_title = ccui.Helper:seekWidgetByName(root, "Text_tishi_1")
    local Text_info = ccui.Helper:seekWidgetByName(root, "Text_tishi_2")
    Text_title:setString(_warcraft_states_string_info[self.current_type])
    if self.current_type == self.enum_type._TYPE_SHOW_LEVEL_UP or self.current_type == self.enum_type._TYPE_SHOW_TITLE_DOWN then 
        local titleOldName = dms.string(dms["warcraft_mould"], AdventureArenaWarcraft._old_title_id, warcraft_mould.title_name)
        local titleNewName = dms.string(dms["warcraft_mould"], _ED.warcraft_info.current_title_id, warcraft_mould.title_name)
        local infoString = string.format(_warcraft_states_string_info[self.current_type + 4],titleOldName,titleNewName)
        Text_info:setString(infoString)
    else
        Text_info:setString(_warcraft_states_string_info[self.current_type + 4])
    end
end

function AdventureArenaWarcraftResultTip:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/jingji_pws_tishi.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)
    self:onUpdateDraw()
    	
	-- --确定刷新
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureArenaWarcraftResultTipClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureArenaWarcraftResultTip:onExit()
    
end