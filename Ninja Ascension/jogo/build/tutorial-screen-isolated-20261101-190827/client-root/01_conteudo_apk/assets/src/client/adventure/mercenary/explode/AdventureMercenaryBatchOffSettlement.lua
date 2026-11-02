-- ----------------------------------------------------------------------------------------------------
-- 说明：武将解雇-去结算
-------------------------------------------------------------------------------------------------------
AdventureMercenaryBatchOffSettlement = class("AdventureMercenaryBatchOffSettlementClass", Window)
    
function AdventureMercenaryBatchOffSettlement:ctor()
    self.super:ctor()
    self.roots = {}
	self.herolist = nil
	app.load("client.loader.formula")
	app.load("client.adventure.reward.AdventureTipReward")
    -- Initialize adventure mercenary hero explode state machine.
    local function init_adventure_mercenary_hero_explode_terminal()
	
		local adventure_mercenary_hero_explode_fire_confirm_terminal = {
            _name = "adventure_mercenary_hero_explode_fire_confirm",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseChoiceHeroBattleCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("adventure_mercenary_hero_fire_update_draw", 0, nil)
						fwin:close(fwin:find("AdventureMercenaryBatchOffSettlementClass"))
						local reward = getSceneReward(59)

						if reward ~= nil then 
							fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
						end
						
					end
				end
				local str = ""
				for j, v in pairs(self.herolist) do
					if v ~= nil then 
						str = str..v.ship_id..","
					end
				end
				str = string.sub(str,0,#str-1)
            	if str == "" then
					return
				end
				protocol_command.ship_sell.param_list = str
				NetworkManager:register(protocol_command.ship_sell.code, nil, nil, nil, nil, responseChoiceHeroBattleCallback, true, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_mercenary_hero_explode_fire_confirm_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mercenary hero explode state machine.
    init_adventure_mercenary_hero_explode_terminal()
end

function AdventureMercenaryBatchOffSettlement:init(list)
	self.herolist = list
    return self
end

function AdventureMercenaryBatchOffSettlement:onEnterTransitionFinish()
    local csbAdventureMercenaryBatchOffSettlement = csb.createNode("packs/Mercenary/yongbing_jiegu_result.csb")
    local root = csbAdventureMercenaryBatchOffSettlement:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMercenaryBatchOffSettlement)
	local number = 0
	local ship_count = 0
	for i, ship in pairs(self.herolist) do
		if ship ~= nil then 
			local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
			number = number + dms.atoi(shipData, ship_mould.refine_get_soul)
			ship_count = ship_count + 1 
		end
		
	end
	local Text_suipian = ccui.Helper:seekWidgetByName(root, "Text_suipian")
	if ship_count <= 0 then
		Text_suipian:setString("0")
	else
		
		Text_suipian:setString(number)
	end
	
	local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
	Text_number:setString(ship_count)
	
	local Text_exp_all = ccui.Helper:seekWidgetByName(root, "Text_exp_all")
	if ship_count <= 0 then
		Text_exp_all:setString("0")
	else
		local costExp = 0
		for i, ship in pairs(self.herolist) do
			if ship ~= nil then 
				costExp = costExp + zstring.tonumber(getShipTotalCostExperience(ship))
			end
		end
		Text_exp_all:setString(costExp)
	end

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMercenaryBatchOffSettlementClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMercenaryBatchOffSettlementClass"))]],    
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 确认
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"), nil, 
    {
        terminal_name = "adventure_mercenary_hero_explode_fire_confirm", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)
end

function AdventureMercenaryBatchOffSettlement:onExit()
    state_machine.remove("adventure_mercenary_hero_explode_fire_confirm")
end
