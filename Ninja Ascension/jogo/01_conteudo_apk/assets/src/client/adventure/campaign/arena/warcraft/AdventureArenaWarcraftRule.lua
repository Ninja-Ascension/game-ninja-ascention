-- ----------------------------------------------------------------------------------------------------
-- 说明：排位赛规则界面 or 九层妖塔
-------------------------------------------------------------------------------------------------------
AdventureArenaWarcraftRule = class("AdventureArenaWarcraftRuleClass", Window)
    
function AdventureArenaWarcraftRule:ctor()
    self.super:ctor()
    self.roots = {}
	self.isTouchLock = false	
    self.current_type = 1 -- 1排位赛 2 九层妖塔
    -- Initialize adventure arena state machine.
    local function init_adventure_arena_warcraft_rule_terminal()

        --返回
		local adventure_arena_warcraft_rule_close_terminal = {
            _name = "adventure_arena_warcraft_rule_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("AdventureArenaWarcraftRuleClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(adventure_arena_warcraft_rule_close_terminal)
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_warcraft_rule_terminal()
end

function AdventureArenaWarcraftRule:init(show_type)
    self.current_type = show_type
	return self
end

function AdventureArenaWarcraftRule:onUpdateDraw()
	local root = self.roots[1]
	local Text_cishu = ccui.Helper:seekWidgetByName(root, "Text_cishu")
	Text_cishu:setString(_ED.arena_user_remain)
	local ListView_jingji = ccui.Helper:seekWidgetByName(root, "ListView_jingji")
	ListView_jingji:removeAllItems()
	for i=1, zstring.tonumber(_ED.arena_challenge_number) do
		local cell = AdventureArenaManagerArenaTwoList:createCell()
		cell:init(_ED.arena_challenge[i],i)
		ListView_jingji:addChild(cell)
		ListView_jingji:requestRefreshView()
	end
	
	ccui.Helper:seekWidgetByName(root, "LoadingBar_1"):setPercent( zstring.tonumber(_ED.arena_user_victory)/ 9 * 100)
	
	self.interval = (_ED.native_arena_two_time + zstring.tonumber(_ED.arena_info[2].arena_challenge_lasttime)) - os.time()
    self.needUpdateRefreshCd = true
    self:updateRefreshCd()
end

function AdventureArenaWarcraftRule:onEnterTransitionFinish()
    local fileName = ""
    if self.current_type == 1 then 
        fileName = "campaign/Arena/guize_pws.csb"
    else
        fileName = "campaign/Arena/guize_pws.csb"
    end
	local csbAdventureArena = csb.createNode(fileName)
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)
    	
	-- -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        terminal_name = "adventure_arena_warcraft_rule_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureArenaWarcraftRule:onExit()
    self.roots = nil
    state_machine.remove("adventure_arena_warcraft_rule_close")
    
end