-- ----------------------------------------------------------------------------------------------------
-- 说明：世界排名
-------------------------------------------------------------------------------------------------------
AdventureArenaWorldRanking = class("AdventureArenaWorldRankingClass", Window)
    
function AdventureArenaWorldRanking:ctor()
    self.super:ctor()
    self.roots = {}
	
	app.load("client.adventure.cells.arena.AdventureArenaManagerWorldRankingList")
    -- Initialize adventure arena state machine.
    local function init_adventure_arena_qualifying_rule_terminal()
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_qualifying_rule_terminal()
end

function AdventureArenaWorldRanking:init()
	return self
end

function AdventureArenaWorldRanking:onUpdateDraw()
	local root = self.roots[1]
	local ListView_libao = ccui.Helper:seekWidgetByName(root, "ListView_libao")
	ListView_libao:removeAllItems()
	for i=1, zstring.tonumber(_ED.arena_rank_user_number) do
		local cell = AdventureArenaManagerWorldRankingList:createCell()
		cell:init(_ED.arena_rank_user[i],i)
		ListView_libao:addChild(cell)
		ListView_libao:requestRefreshView()
	end
	
end

function AdventureArenaWorldRanking:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/jingjichang_shijiepaiming.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)
	
	local function responseArenaRankingPanelInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil then
				response.node:onUpdateDraw()
			end
		end
	end
		
	protocol_command.arena_order.param_list = "0"
	NetworkManager:register(protocol_command.arena_order.code, nil, nil, nil, self, responseArenaRankingPanelInitCallback, false, nil)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureArenaWorldRankingClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
end

function AdventureArenaWorldRanking:onExit()

end