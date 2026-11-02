-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场奖励商店窗口
-------------------------------------------------------------------------------------------------------
AdventureArenaRewardShop = class("AdventureArenaRewardShopClass", Window)
    
function AdventureArenaRewardShop:ctor()
    self.super:ctor()
    self.roots = {}
	self.isTouchLock = false
	self.interval = 0
    self.needUpdateRefreshCd = false
	app.load("client.adventure.cells.arena.AdventureArenaManagerExchangeList")
    -- Initialize adventure arena state machine.
    local function init_adventure_arena_reward_shop_terminal()
		
		local adventure_arena_reward_shop_update_draw_terminal = {
            _name = "adventure_arena_reward_shop_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_arena_reward_shop_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_reward_shop_terminal()
end

function AdventureArenaRewardShop:init()
	return self
end

function AdventureArenaRewardShop:onUpdateDraw()
	local root = self.roots[1]
	local Text_suipian = ccui.Helper:seekWidgetByName(root, "Text_suipian")
	Text_suipian:setString(_ED.user_info.soul)
	local Text_xunzhang = ccui.Helper:seekWidgetByName(root, "Text_xunzhang")
	Text_xunzhang:setString(_ED.user_info.user_honour)
	local Text_jinbi = ccui.Helper:seekWidgetByName(root, "Text_jinbi")
	local silver = _ED.user_info.user_silver
    if zstring.tonumber(silver) > 1000000000 then
        Text_jinbi:setString(string.format("%.02f",silver/ 1000000000) .. string_equiprety_name[42])
    elseif zstring.tonumber(silver)> 1000000 then
        Text_jinbi:setString(string.format("%.02f",silver / 1000000) .. string_equiprety_name[41])
    elseif zstring.tonumber(silver)> 1000 then
        Text_jinbi:setString(string.format("%.02f",silver / 1000) .. string_equiprety_name[40])
    else
        Text_jinbi:setString(silver)
    end
    
	local ListView_libao = ccui.Helper:seekWidgetByName(root, "ListView_libao")
	ListView_libao:removeAllItems()
	for i=1, zstring.tonumber(_ED.arena_good_reward_number) do
		local cell = AdventureArenaManagerExchangeList:createCell()
		cell:init(_ED.arena_good_reward[i],i)
		ListView_libao:addChild(cell)
		ListView_libao:requestRefreshView()
	end
end

function AdventureArenaRewardShop:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/jingjichang_duihuan.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)

	self:onUpdateDraw()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureArenaRewardShopClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureArenaRewardShop:onExit()

end