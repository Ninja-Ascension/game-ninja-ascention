-- ----------------------------------------------------------------------------------------------------
-- 说明：兑换确认
-------------------------------------------------------------------------------------------------------
AdventureArenaExchangeConfirmation = class("AdventureArenaExchangeConfirmationClass", Window)
    
function AdventureArenaExchangeConfirmation:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.adventure.cells.prop.adventure_new_prop_small_icon_cell")
	self.arenaInfo = nil
    -- Initialize adventure arena state machine.
    local function init_adventure_arena_exchange_confirmation_terminal()
		local adventure_arena_exchange_confirmation_request_terminal = {
            _name = "adventure_arena_exchange_confirmation_request",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			
				local function responseArenaBuyProdCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("adventure_arena_reward_shop_update_draw", 0, "adventure_arena_reward_shop_update_draw.")
						app.load("client.adventure.reward.AdventureTipReward")
						fwin:open(AdventureTipReward:new():init(getSceneReward(14)), fwin._ui)
						fwin:close(fwin:find("AdventureArenaExchangeConfirmationClass"))
					end
				end
				protocol_command.arena_shop_exchange.param_list = self.arenaInfo.good_id .. "\r\n1"
				NetworkManager:register(protocol_command.arena_shop_exchange.code, nil, nil, nil, nil, responseArenaBuyProdCallback, false, nil)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_arena_exchange_confirmation_request_terminal)
		
        state_machine.init()
    end
    
    -- call func init adventure arena state machine.
    init_adventure_arena_exchange_confirmation_terminal()
end

function AdventureArenaExchangeConfirmation:init(arenaInfo)
	self.arenaInfo = arenaInfo
	return self
end

function AdventureArenaExchangeConfirmation:onUpdateDraw()
	local root = self.roots[1]

	
end

function AdventureArenaExchangeConfirmation:onEnterTransitionFinish()
	local csbAdventureArena = csb.createNode("campaign/Arena/buy_props.csb")
    local root = csbAdventureArena:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureArena)
  
	local ListView_prop = ccui.Helper:seekWidgetByName(root, "ListView_prop")
	ListView_prop:removeAllItems()
	local _width = 0
	local _nCount = 0

	-- 勋章
	local cell = adventureNewSmallPropIconCell:createCell()
	cell:init(5, {resource_type = 3} , dms.int(dms["arena_shop_info"], self.arenaInfo.good_id, arena_shop_info.need_honor), nil, 0, 0)
	ListView_prop:addChild(cell)
	_width = cell:getContentSize().width
	_nCount = _nCount + 1

	if dms.int(dms["arena_shop_info"], self.arenaInfo.good_id, arena_shop_info.ranking) == -1 then
		-- 金币
		local cell = adventureNewSmallPropIconCell:createCell()
		cell:init(5, {resource_type = 1} , dms.string(dms["arena_shop_info"], self.arenaInfo.good_id, arena_shop_info.reward_silver), nil, 0, 0,ListView_prop)
		ListView_prop:addChild(cell)
	else
		--
		--碎片
		local cell = adventureNewSmallPropIconCell:createCell()
		cell:init(5, {resource_type = 4} , dms.int(dms["arena_shop_info"], self.arenaInfo.good_id, arena_shop_info.ranking), nil, 0, 0,ListView_prop)
		ListView_prop:addChild(cell)	
	end

	_nCount = _nCount + 1
		
	-- end
	ListView_prop:requestRefreshView()		
	if ListView_prop._x == nil then
		ListView_prop._x = ListView_prop:getPositionX()
	end

	ListView_prop:setPositionX(ListView_prop._x - (_width + ListView_prop:getItemsMargin()) * (_nCount - 1) / 2)
		
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
	{
		terminal_name = "adventure_arena_exchange_confirmation_request",  
		terminal_state = 0, 
		isPressedActionEnabled = false
	}, 
	nil, 0)
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureArenaExchangeConfirmationClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureArenaExchangeConfirmationClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
end

function AdventureArenaExchangeConfirmation:onExit()

end