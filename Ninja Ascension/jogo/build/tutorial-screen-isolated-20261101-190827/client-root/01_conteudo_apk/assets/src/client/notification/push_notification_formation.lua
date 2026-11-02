-- Initialize push notification center state machine.
pushNotificationHeroFormationTip = false
pushNotificationlevel7 = nil
pushNotificationlevel8 = nil

local function init_push_notification_center_formation_terminal()
	--阵容里的可上阵推送
    local push_notification_center_formation_the_battle_terminal = {
        _name = "push_notification_center_formation",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	pushNotificationHeroFormationTip = getSortedHeroesFormationtips()
			if pushNotificationHeroFormationTip == true then
				if params._widget._istips == true then
					return
				end
				local ball = cc.Sprite:create("images/ui/bar/tips.png")
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					ball:setAnchorPoint(cc.p(0, 0))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width+22, params._widget:getContentSize().height-ball:getContentSize().height+22))
				else
					ball:setAnchorPoint(cc.p(0, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width, params._widget:getContentSize().height-ball:getContentSize().height))
				end
				params._widget:addChild(ball)
				params._widget._nodeChild = ball
				params._widget._istips = true
			else
				params._widget:removeChild(params._widget._nodeChild, true)
				params._widget._nodeChild = nil
				params._widget._istips = false
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	--主页阵容图标推送
	local push_notification_center_formation_all_terminal = {
        _name = "push_notification_center_formation_all",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local istips = false
			local nCount = 0
			local openCount = zstring.tonumber(_ED.user_info.user_fight)
			for i = 1, 6 do
				local shipType = 0
				local shipId = _ED.user_formetion_status[i]
				if zstring.tonumber(shipId) > 0 then 
					nCount = nCount + 1
				else
					break
				end
			end
			
			if nCount < openCount then
				if pushNotificationHeroFormationTip == true then
					istips = true
				end
			end
			if istips == false then
				if pushNotificationFormationTip1 == true then
					if getfunctionEquipEquipment() == true then
						istips = true
					end
				end
			end
			if istips == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
			
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	--阵容里可装备的推送
    local push_notification_center_formation_equipment_terminal = {
        _name = "push_notification_center_formation_equipment",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getLocationEquipment(params._widget._data) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setName("tipBall")
					ball:setAnchorPoint(cc.p(1, 1))
					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						ball:setPosition(cc.p(params._widget:getContentSize().width+10, params._widget:getContentSize().height+10))
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					end
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	--阵容里可替换装备的推送
    local push_notification_center_formation_replacement_equipment_terminal = {
        _name = "push_notification_center_formation_replacement_equipment",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getupdateequipequipment(params._widget._data) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
						local ballSzie = ball:getContentSize()
						local _widgetSize = params._widget:getContentSize()
						ball:setPosition(cc.p(_widgetSize.width + ballSzie.width / 2, _widgetSize.height + ballSzie.height / 2))
					elseif __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setPosition(cc.p(params._widget:getContentSize().width+17, params._widget:getContentSize().height+17))
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					end
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
	
	--阵容里可替换装备船只的推送
    local push_notification_center_formation_replacement_equipment_ship_terminal = {
        _name = "push_notification_center_formation_replacement_equipment_ship",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getupdateequipequipmentShipTips(params._widget._data) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						ball:setAnchorPoint(cc.p(0, 0))
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width, params._widget:getContentSize().height-ball:getContentSize().height))
					else
						ball:setAnchorPoint(cc.p(0, 1))
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width/3*4, params._widget:getContentSize().height-ball:getContentSize().height))
					end
					
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    --装备进阶按钮推送
    local push_notification_center_formation_equipment_up_grade_terminal = {
        _name = "push_notification_center_formation_equipment_up_grade",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getEquipmentUpGrade(params._widget._data) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.7, 0.7))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --装备觉醒按钮推送
    local push_notification_center_formation_equipment_awakening_terminal = {
        _name = "push_notification_center_formation_equipment_awakening",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getEquipmentAwakening(params._widget._data) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.7, 0.7))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --装备强化标签页推送
    local push_notification_center_formation_equipment_up_grade_page_tips_terminal = {
        _name = "push_notification_center_formation_equipment_up_grade_page_tips",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getEquipmentUpGradePageTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
	}
	
    --装备觉醒标签页推送
    local push_notification_center_formation_equipment_awakening_page_tips_terminal = {
        _name = "push_notification_center_formation_equipment_awakening_page_tips",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getEquipmentAwakeningPageTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
	}
	
	--装备淬炼标签页推送
    local push_notification_center_formation_equipment_harden_page_tips_terminal = {
        _name = "push_notification_center_formation_equipment_harden_page_tips",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getEquipmentHardenPageTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --阵容武将强化按钮
    local push_notification_center_formation_ship_strengthen_button_terminal = {
        _name = "push_notification_center_formation_ship_strengthen_button",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getFormationShipStrengthenButton() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.7, 0.7))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --阵容界面武将头像推送
    local push_notification_center_formation_ship_icon_terminal = {
        _name = "push_notification_center_formation_ship_icon",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getFormationShipIconTip(params._widget._data) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --武将是否可进化推送
    local push_notification_center_formation_ship_evo_terminal = {
        _name = "push_notification_center_formation_ship_evo",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getFormationShipEvolutionButton() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --阵容界面武将是否可强化推送
    local push_notification_center_formation_ship_formation_terminal = {
        _name = "push_notification_center_formation_ship_formation",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getFormationShipFormationButton() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --阵容界面装备是否可进阶推送
    local push_notification_center_formation_equip_upgrade_terminal = {
        _name = "push_notification_center_formation_equip_upgrade",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getFormationEquipUpgradeButton() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --武将仓库养成界面装备是否可进阶推送
    local push_notification_center_develop_equip_upgrade_terminal = {
        _name = "push_notification_center_develop_equip_upgrade",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getDevelopEquipUpgradeButton() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --阵容界面装备是否可觉醒推送
    local push_notification_center_formation_equip_awake_terminal = {
        _name = "push_notification_center_formation_equip_awake",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getFormationEquipAwakeButton() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					if __lua_project_id == __lua_project_onepiece then
                        ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height-20))   
                    else
                        ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))   
                    end
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --武将仓库养成界面装备是否可觉醒推送
    local push_notification_center_develop_equip_awake_terminal = {
        _name = "push_notification_center_develop_equip_awake",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getDevelopEquipAwakeButton() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(push_notification_center_formation_the_battle_terminal)
    state_machine.add(push_notification_center_formation_all_terminal)
    state_machine.add(push_notification_center_formation_equipment_terminal)
    state_machine.add(push_notification_center_formation_replacement_equipment_terminal)
    state_machine.add(push_notification_center_formation_replacement_equipment_ship_terminal)
    state_machine.add(push_notification_center_formation_equipment_up_grade_terminal)
    state_machine.add(push_notification_center_formation_equipment_awakening_terminal)
    state_machine.add(push_notification_center_formation_equipment_up_grade_page_tips_terminal)
    state_machine.add(push_notification_center_formation_equipment_awakening_page_tips_terminal)
    state_machine.add(push_notification_center_formation_ship_strengthen_button_terminal)
    state_machine.add(push_notification_center_formation_ship_icon_terminal)
    state_machine.add(push_notification_center_formation_ship_evo_terminal)
    state_machine.add(push_notification_center_formation_ship_formation_terminal)
    state_machine.add(push_notification_center_formation_equip_upgrade_terminal)
    state_machine.add(push_notification_center_develop_equip_upgrade_terminal)
    state_machine.add(push_notification_center_formation_equip_awake_terminal)
	state_machine.add(push_notification_center_develop_equip_awake_terminal)
	state_machine.add(push_notification_center_formation_equipment_harden_page_tips_terminal)
    state_machine.init()
end
init_push_notification_center_formation_terminal()


function getSortedHeroesFormationtips()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		for i, ship in pairs(_ED.user_ship) do
			if ship.ship_id ~= nil then
				local sameBattleShip = false
				for j = 2, 7 do
					local shipId = _ED.formetion[j]
					if zstring.tonumber(shipId) > 0 then
						if zstring.tonumber(_ED.user_ship[shipId].ship_base_template_id) == zstring.tonumber(ship.ship_base_template_id) then
							sameBattleShip = true
							break
						end
					end
				end
				if sameBattleShip == false then
					for j = 2, 7 do
						if zstring.tonumber(_ED.formetion[j]) <= 0 then
							return true
						end
					end
				end
			end
		end
	else
		for i, ship in pairs(_ED.user_ship) do
			if ship.ship_id ~= nil then
				-- local shipData = dms.element(dms["ship_mould"], ship.ship_base_template_id)
				local sameBattleShip = false
				local samePartnerShip = false
				if zstring.tonumber(ship.captain_type) ~= 0 then
					for j = 2, 7 do
						local shipId = _ED.formetion[j]
						if zstring.tonumber(shipId) > 0 then
							if zstring.tonumber(_ED.user_ship[shipId].ship_base_template_id) == zstring.tonumber(ship.ship_base_template_id) then
								sameBattleShip = true
								break
							end
						end
					end	
					if sameBattleShip == false then
						for w, v in pairs(_ED.little_companion_state) do
							if zstring.tonumber(v) > 0 then
								if zstring.tonumber(fundShipWidthId(v).ship_base_template_id) == zstring.tonumber(ship.ship_base_template_id) then
									samePartnerShip = true
									break
								end
							end
						end
						if samePartnerShip == false then
							if zstring.tonumber(ship.formation_index) > 0 or zstring.tonumber(ship.little_partner_formation_index) > 0 then
								--table.insert(arrBusyHeroes, ship)
							else
								return true
							end
						end
					end
				end
			end
		end
	end
	return false
end

function getfunctionEquipEquipment()
	if pushNotificationlevel7 == nil then
		pushNotificationlevel7 = dms.int(dms["fun_open_condition"], 7, fun_open_condition.level)
	end
	if pushNotificationlevel8 == nil then
		pushNotificationlevel8 = dms.int(dms["fun_open_condition"], 8, fun_open_condition.level)
	end
	local isSame = false
	local tSortedHeroes = {}
	for i,v in pairs(_ED.user_equiment) do
		if tonumber(v.equipment_type) >= 4 and tonumber(_ED.user_info.user_grade) < 15 then
		elseif tonumber(v.equipment_type) < 4 and tonumber(_ED.user_info.user_grade) < 5 then
		else		
			if zstring.tonumber(v.ship_id) == 0 then
				for j = 1, 6 do
					local shipId = _ED.user_formetion_status[j]
					if zstring.tonumber(shipId) > 0 then
						isSame = false
						tSortedHeroes = {}
						local ship = fundShipWidthId(shipId)
						for w = 1, #ship.equipment do
							local equipment = ship.equipment[w]
							if equipment.user_equiment_id ~= nil and equipment.user_equiment_id ~= "" 
								and zstring.tonumber(equipment.user_equiment_id) ~= 0 then
								table.insert(tSortedHeroes, equipment.equipment_type)
								if zstring.tonumber(equipment.equipment_type) == zstring.tonumber(v.equipment_type) then
									-- local grow_level = dms.int(dms["equipment_mould"], equipment.user_equiment_template, equipment_mould.grow_level)
									if zstring.tonumber(v.grow_level) > zstring.tonumber(equipment.grow_level) then
										return true
									end
								end
							end
						end
						
						if zstring.tonumber(v.equipment_type) <= 5 then
							for x = 1, #tSortedHeroes do
								if zstring.tonumber(v.equipment_type)==zstring.tonumber(tSortedHeroes[x])then
									isSame = true
								end
							end
							if isSame == false then
								if zstring.tonumber(v.equipment_type) < 4 then
									if pushNotificationlevel7 <= zstring.tonumber(_ED.user_info.user_grade) then
										return true
									end
								elseif zstring.tonumber(v.equipment_type) >= 4 then
									if pushNotificationlevel8 <= zstring.tonumber(_ED.user_info.user_grade) then
										return true
									end
								end
								return false
							end
						end
					end
				end
			end
		end
	end
	return false
end

function getLocationEquipment(data)
	for i,v in pairs(_ED.user_equiment) do
		if tonumber(v.equipment_type) >= 4 and tonumber(_ED.user_info.user_grade) < 15 then
		elseif tonumber(v.equipment_type) < 4 and tonumber(_ED.user_info.user_grade) < 5 then
		else		
			if zstring.tonumber(v.ship_id) == 0 then
				if zstring.tonumber(v.equipment_type) == zstring.tonumber(data) then
					return true
				end
			end
		end
	end
	return false
end

function getupdateequipequipment(data)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local ship = fundShipWidthId(data.ship_id)
		local index = data.m_index
		--进阶
		if equipmentIsCanEvolution(ship , index) == true then
			return true
		end
		--觉醒
		if equipmentIsCanAwake(ship , index) == true then
			return true
		end
	else
	-- local user_equiment_data = dms.element(dms["equipment_mould"], data.user_equiment_template)
	-- local equipment_type = zstring.tonumber(data.equipment_type)
	-- local grow_level = zstring.tonumber(data.grow_level)
	-- if grow_level ~= nil then
		for i,v in pairs(_ED.user_equiment) do
			if tonumber(v.equipment_type) >= 4 and tonumber(_ED.user_info.user_grade) < 15 then
			elseif tonumber(v.equipment_type) < 4 and tonumber(_ED.user_info.user_grade) < 5 then
			else
				if zstring.tonumber(v.ship_id) == 0 then
					-- local other_equiment_data = dms.element(dms["equipment_mould"], v.user_equiment_template)
					if zstring.tonumber(v.equipment_type) == zstring.tonumber(data.equipment_type) then
						if data.grow_level ~= nil and data.grow_level ~= "" then
							if zstring.tonumber(v.grow_level) > zstring.tonumber(data.grow_level) then
								return true
							end
						end
					end
				end
			end
		end
	-- end
	end
	return false
end

function getupdateequipequipmentShipTips(data)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if fwin:find("FormationTigerGateClass") == nil then
			return
		end
	end
	local isSame = false
	local tSortedHeroes = {}
	local shipId = data
	if zstring.tonumber(shipId) > 0 then
		local ship = fundShipWidthId(shipId)
		for i,v in pairs(_ED.user_equiment) do
			if tonumber(v.equipment_type) >= 4 and tonumber(_ED.user_info.user_grade) < 15 then
			elseif tonumber(v.equipment_type) < 4 and tonumber(_ED.user_info.user_grade) < 5 then
			else
				if zstring.tonumber(v.ship_id) == 0 then
					isSame = false
					tSortedHeroes = {}
					for w = 1, #ship.equipment do
						local equipment = ship.equipment[w]
						if equipment.user_equiment_id ~= nil and equipment.user_equiment_id ~= "" 
							and zstring.tonumber(equipment.user_equiment_id) ~= 0 then
							table.insert(tSortedHeroes, equipment.equipment_type)
							if zstring.tonumber(equipment.equipment_type) == zstring.tonumber(v.equipment_type) then
								-- local grow_level = dms.int(dms["equipment_mould"], equipment.user_equiment_template, equipment_mould.grow_level)
								if zstring.tonumber(v.grow_level) > zstring.tonumber(equipment.grow_level) then
									return true
								end
							end
						end
					end
					if zstring.tonumber(v.equipment_type) ~= 8 then
						for i,k in ipairs(tSortedHeroes) do
							if zstring.tonumber(v.equipment_type)==zstring.tonumber(k) or zstring.tonumber(v.equipment_type) > 5 then
								isSame = true
							end
						end
						if isSame == false then
							return true
						end
					end
				end
			end
		end
	end
	return false
end
--单个装备强化
function getEquipmentUpGrade(data)
	local ship = fundShipWidthId(data.ship_id)
	local index = data.m_index
	--进阶
	if equipmentIsCanEvolution(ship , index) == true then
		return true
	end
	return false
end
--单个装备觉醒
function getEquipmentAwakening(data)
	local ship = fundShipWidthId(data.ship_id)
	local index = data.m_index
	--觉醒
	if equipmentIsCanAwake(ship , index) == true then
		return true
	end
	return false
end

--装备强化标签页
function getEquipmentUpGradePageTip()
	local _window = fwin:find("SmEquipmentQianghuaClass")
	if _window == nil then
		return false
	end
	local currPage = _window._current_page
	if currPage == 1 then
		return false 
	end
	local ship = fundShipWidthId(_window.shipId)
	if shipEquipmentIsCanEvolution(ship) == true then
        return true
    end
	-- if ship ~= nil then
	-- 	for i = 1 , 6 do
	-- 		if equipmentIsCanEvolution(ship , i) == true then
	-- 			return true
	-- 		end
	-- 	end
	-- end
	return false
end
--装备觉醒标签页
function getEquipmentAwakeningPageTip()
	local _window = fwin:find("SmEquipmentQianghuaClass")
	if _window == nil then
		return false
	end
	local currPage = _window._current_page
	if currPage == 2 then
		return false 
	end
	local ship = fundShipWidthId(_window.shipId)
    if shipEquipmentIsCanAwake(ship) == true then
        return true
    end
	-- if ship ~= nil then
	-- 	for i = 1 , 6 do
	-- 		if equipmentIsCanAwake(ship , i) == true then
	-- 			return true
	-- 		end
	-- 	end
	-- end
	return false	
end

-- 装备淬炼标签页
function getEquipmentHardenPageTip()
	
	local _window = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece  
		then
		_window = fwin:find("FormationTigerGateClass")
		if _window == nil then
			_window = fwin:find("HeroDevelopClass")
			if _window == nil then 
				return false
			end
		end
		
		local ship = _window.ship
		if ship == nil then 
			ship = fundShipWidthId(_window.shipId)
		end
		if shipEquipmentIsCanHarden(ship) == true then
			return true
		end
	else
		_window = fwin:find("SmEquipmentQianghuaClass")
		if _window == nil then
			return false
		end
		local currPage = _window._current_page
		if currPage == 3 then
			return false 
		end

		local ship = fundShipWidthId(_window.shipId)
		if shipEquipmentIsCanHarden(ship) == true then
			return true
		end
	end
	return false	
end


--武将是否可强化
function getFormationShipStrengthenButton()
	local _window = fwin:find("FormationTigerGateClass")
	if _window ~= nil then
		local ship = _window.ship
		--升星
		if shipIsCanUpGradeStar(ship) == true then
			return true
		end
		--进阶
		if shipIsCanEvolution(ship) == true then
			return true
		end
	end
	return false
end
--阵容头像推送
function getFormationShipIconTip( ship )
	--升星
	if shipIsCanUpGradeStar(ship) == true then
		return true
	end
	--进阶
	if shipIsCanEvolution(ship) == true then
		return true
	end
	for i = 1 , 6 do
		--装备进阶
		if equipmentIsCanEvolution(ship , i) == true then
			return true
		end
		--装备觉醒
		if equipmentIsCanAwake(ship , i) == true then
			return true
		end
	end 
	return false
end

--武将是否可进化
function getFormationShipEvolutionButton()
	local _window = fwin:find("FormationTigerGateClass")
	if _window ~= nil then
		local ship = _window.ship
		--进化
		if shipIsCanProcess(ship) == true then
			return true
		end
	end
	return false
end

--阵容界面武将是否可强化推送
function getFormationShipFormationButton()
	local _window = fwin:find("FormationTigerGateClass")
	if _window ~= nil then
		if tonumber(_window._current_page) == 1 then
            return false
        end
		local ship = _window.ship
		--进阶
		if shipIsCanEvolution(ship) == true then
			return true
		end
		--升星
		if shipIsCanUpGradeStar(ship) == true then
			return true
		end
	end
	return false
end

--阵容界面装备是否可进阶推送
function getFormationEquipUpgradeButton()
	local _window = fwin:find("FormationTigerGateClass")
	if _window ~= nil then
		if tonumber(_window._current_page) == 2 then
            return false
        end
		local ship = _window.ship
		--进阶
		if shipEquipmentIsCanEvolution(ship) == true then
			return true
		end
	end
	return false
end

--武将仓库养成界面装备是否可进阶推送
function getDevelopEquipUpgradeButton()
	local _window = fwin:find("HeroDevelopClass")
	if _window ~= nil then
		if tonumber(_window.m_type) == 6 then
            return false
        end
		local ship = fundShipWidthId(_window.shipId)
		--进阶
		if shipEquipmentIsCanEvolution(ship) == true then
			return true
		end
	end
	return false
end

--阵容界面装备是否可觉醒推送
function getFormationEquipAwakeButton()
	local _window = fwin:find("FormationTigerGateClass")
	if _window ~= nil then
		if tonumber(_window._current_page) == 3 then
            return false
        end
		local ship = _window.ship
		--觉醒
		if shipEquipmentIsCanAwake(ship) == true then
			return true
		end
	end
	return false
end

--武将仓库养成界面装备是否可觉醒推送
function getDevelopEquipAwakeButton()
	local _window = fwin:find("HeroDevelopClass")
	if _window ~= nil then
		if tonumber(_window.m_type) == 7 then
            return false
        end
		local ship = fundShipWidthId(_window.shipId)
		--觉醒
		if shipEquipmentIsCanAwake(ship) == true then
			return true
		end
	end
	return false
end

