--------------------------------------------------------------------------------------------------------------
--  说明：军团副本NPC挑战界面
--------------------------------------------------------------------------------------------------------------
UnionDuplicateChallenge = class("UnionDuplicateChallengeClass", Window)
        --打开界面
local union_duplicate_challenge_open_terminal = {
    _name = "union_duplicate_challenge_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _UnionDuplicateChallenge = UnionDuplicateChallenge:new()
        _UnionDuplicateChallenge:init()
        fwin:open(_UnionDuplicateChallenge,fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_duplicate_challenge_close_terminal = {
    _name = "union_duplicate_challenge_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("UnionDuplicateChallengeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_duplicate_challenge_open_terminal)
state_machine.add(union_duplicate_challenge_close_terminal)
state_machine.init()
function UnionDuplicateChallenge:ctor()
	self.super:ctor()
	self.roots = {}
	self.seatId = nil
	
	 -- Initialize union duplicate challenge state machine.
    local function init_union_duplicate_challenge_terminal()
		--点击布阵
		local union_duplicate_challenge_open_lineup_terminal = {
            _name = "union_duplicate_challenge_open_lineup",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 点击挑战状态机
		local union_duplicate_challenge_go_fight_terminal = {
            _name = "union_duplicate_challenge_go_fight",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_duplicate_challenge_open_lineup_terminal)
		state_machine.add(union_duplicate_challenge_go_fight_terminal)
        state_machine.init()
    end
    
    -- call func init  union duplicate challenge state machine.
    init_union_duplicate_challenge_terminal()

end

function UnionDuplicateChallenge:updateDraw()
    local root = self.roots[1]
    local npc_tab = dms.string(dms["union_pve_scene"], self.seatId,union_pve_scene.npc_tab)
    local npcs = zstring.split(npc_tab, ",")
    for i=1,4 do
        local name = dms.string(dms["union_npc"],npcs[i],union_npc.npc_name)
        local Text_lv_name =ccui.Helper:seekWidgetByName(root, string.format("Text_lv_name_%d",i))
        Text_lv_name:setString(name)
    end
end

function UnionDuplicateChallenge:onInit()
    local csbUnionDuplicateChallenge = csb.createNode("legion/legion_pve_chapter_tow.csb")
    local root = csbUnionDuplicateChallenge:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionDuplicateChallenge)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"),  nil, 
    {
        terminal_name = "union_duplicate_challenge_close",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	self:updateDraw()
    state_machine.unlock("union_duplicate_cell_enter_pve_scene")
end

function UnionDuplicateChallenge:onEnterTransitionFinish()

end

function UnionDuplicateChallenge:init()
    self.seatId = tonumber(_ED.union.union_current_scene_id)
	self:onInit()
	return self
end

function UnionDuplicateChallenge:onExit()
	state_machine.remove("union_duplicate_challenge_open_lineup")
	state_machine.remove("union_duplicate_challenge_go_fight")

end