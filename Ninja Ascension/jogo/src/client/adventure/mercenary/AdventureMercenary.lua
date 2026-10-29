-- ----------------------------------------------------------------------------------------------------
-- 说明：佣兵主界面
-------------------------------------------------------------------------------------------------------
AdventureMercenary = class("AdventureMercenaryClass", Window)
    
function AdventureMercenary:ctor()
    self.super:ctor()
    self.roots = {}
    
    app.load("client.adventure.cells.prop.adventure_new_prop_small_icon_cell")

    -- Initialize adventure mercenary state machine.
    local function init_adventure_mercenary_terminal()
        -- 出战阵容
        local adventure_mercenary_battle_formation_terminal = {
            _name = "adventure_mercenary_battle_formation",
            _init = function (terminal)
                app.load("client.adventure.mercenary.formation.AdventureBattleFormation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureBattleFormation:new():init(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 佣兵列表
        local adventure_mercenary_package_terminal = {
            _name = "adventure_mercenary_package",
            _init = function (terminal)
                app.load("client.adventure.mercenary.package.AdventureMercenaryPackage")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureMercenaryPackage:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 转移灵力
        local adventure_mercenary_transform_terminal = {
            _name = "adventure_mercenary_transform",
            _init = function (terminal)
                app.load("client.adventure.mercenary.transform.AdventureMercenaryTransform")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureMercenaryTransform:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 我的宿命武器
        local adventure_mercenary_equipment_fate_terminal = {
            _name = "adventure_mercenary_equipment_fate",
            _init = function (terminal)
                app.load("client.adventure.mercenary.equipment.AdventureMercenaryEquipmentFate")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureMercenaryEquipmentFate:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 批量解雇
        local adventure_mercenary_batch_off_terminal = {
            _name = "adventure_mercenary_batch_off",
            _init = function (terminal)
                app.load("client.adventure.mercenary.explode.AdventureMercenaryBatchOff")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureMercenaryBatchOff:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 图鉴
        local adventure_mercenary_hero_handbook_terminal = {
            _name = "adventure_mercenary_hero_handbook",
            _init = function (terminal)
                app.load("client.adventure.mercenary.handbook.AdventureMercenaryHeroHandbook")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.hero_handbook == nil or table.nums(_ED.hero_handbook) == 0 then
    				local function responseShowShipMouldListCallback(response)
    					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    						state_machine.excute("adventure_mercenary_hero_handbook_open",0,true)
    					end
    				end
    				
    				NetworkManager:register(protocol_command.show_ship_mould_list.code, nil, nil, nil, nil, responseShowShipMouldListCallback, false, nil)
                else
                    state_machine.excute("adventure_mercenary_hero_handbook_open",0,true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 刷新empty
        local adventure_mercenary_update_empty_terminal = {
            _name = "adventure_mercenary_update_empty",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local formentionNumber = 0
				local isFull = true
				-- for i,w in pairs(_ED.formetion_list) do
				-- 	if zstring.tonumber(w[1]) == 1 then
				-- 		formentionNumber = i
				-- 		break
				-- 	end
				-- end
				for j ,v in pairs(_ED.formetion) do
                    if j >= 1 then 
    					if v == "0" then
    						isFull = false
    						break
    					end
    					if v == "-1" then
    						isFull = true
    						break
    					end
                    end
				end
				if isFull == true then
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_empty"):setVisible(false)
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_empty"):setVisible(true)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_mercenary_open_agreement_terminal = {
            _name = "adventure_mercenary_open_agreement",
            _init = function (terminal)
                app.load("client.adventure.mercenary.agreement.AdventureMercenaryAgreement")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureMercenaryAgreement:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(adventure_mercenary_battle_formation_terminal)
        state_machine.add(adventure_mercenary_package_terminal)
        state_machine.add(adventure_mercenary_transform_terminal)
        state_machine.add(adventure_mercenary_equipment_fate_terminal)
        state_machine.add(adventure_mercenary_batch_off_terminal)
        state_machine.add(adventure_mercenary_hero_handbook_terminal)
        state_machine.add(adventure_mercenary_update_empty_terminal)
        state_machine.add(adventure_mercenary_open_agreement_terminal)

        state_machine.init()
    end
    
    -- call func init adventure mercenary state machine.
    init_adventure_mercenary_terminal()
end

function AdventureMercenary:init()
	return self
end

function AdventureMercenary:onEnterTransitionFinish()
	local csbAdventureMercenary = csb.createNode("packs/Mercenary/yongbing.csb")
    local root = csbAdventureMercenary:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMercenary)

	state_machine.excute("adventure_mercenary_update_empty", 0, "adventure_mercenary_update_empty.")
    -- 出战阵容
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chuzhan"), nil, 
    {
        terminal_name = "adventure_mercenary_battle_formation", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 佣兵列表
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yb_list"), nil, 
    {
        terminal_name = "adventure_mercenary_package", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 转移灵力
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_linli"), nil, 
    {
        terminal_name = "adventure_mercenary_transform", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 我的宿命武器
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wuqi"), nil, 
    {
        terminal_name = "adventure_mercenary_equipment_fate", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 批量解雇
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jiegu"), nil, 
    {
        terminal_name = "adventure_mercenary_batch_off", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qiyue"), nil, 
    {
        terminal_name = "adventure_mercenary_open_agreement", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 图鉴
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tujian"), nil, 
    {
        terminal_name = "adventure_mercenary_hero_handbook", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)
    state_machine.excute("adventure_push_info_open",0,5)
end

function AdventureMercenary:onExit()
    state_machine.excute("adventure_push_info_close",0,0)
    state_machine.remove("adventure_mercenary_battle_formation")
    state_machine.remove("adventure_mercenary_package")
    state_machine.remove("adventure_mercenary_transform")
    state_machine.remove("adventure_mercenary_equipment_fate")
    state_machine.remove("adventure_mercenary_batch_off")
    state_machine.remove("adventure_mercenary_hero_handbook")
    state_machine.remove("adventure_mercenary_open_agreement")
end